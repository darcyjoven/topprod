# Prog. Version..: '5.30.06-13.04.01(00010)'     #
#
# Pattern name...: anmt920.4gl
# Descriptions...: 集團資金調撥維護作業
# Date & Author..: NO.FUN-620051 06/02/24 BY Mandy
# Modify.........: NO.TQC-630074 06/03/07 By Echo 流程訊息通知功能
# Modify.........: No.MOD-640270 06/03/10 By Nicola 撥出/入/手續費銀行不可為'支存'(架構上以T/T)
#                                                   若有手續費支出其銀行應與撥出銀行同(帶預設值)
# Modify.........: No.MOD-640210 06/03/10 By Nicola 撥出異動碼、手續費異動碼,不可輸入'存'項異動碼
#                                                   撥出幣別、手續費幣別若為本位幣時,其匯率不可異動
# Modify.........: No.MOD-640273 06/03/10 By Nicola 撥入營運中心不可同撥出營運中心
#                                                   撥入異動碼不可輸入'出'項
# Modify.........: No.MOD-640293 06/04/11 By Mandy  確認後再按產生分錄,不應出現'lib-028'異動更新不成功'訊息
# Modify.........: No.MOD-640332 06/04/12 By Mandy  手續費銀行為空時,其手續費相關欄位不可輸入,且不產生分錄底稿,和不INSERT 銀行異動資料
# Modify.........: No.TQC-640113 06/04/13 By Mandy  按Action撥出/撥入分錄底稿維護/確認時會切換工廠,切換工廠後FETCH的CURSOR應再DECLARE,OPEN 一次
# Modify.........: No.FUN-640142 06/04/14 By Nicola 金額欄位依幣別取位
# Modify.........: No.FUN-640144 06/04/19 By Nicola 增加列印功能
# Modify.........: No.MOD-650040 06/05/09 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.MOD-660086 06/07/05 By Sarah 查詢一筆未確認的單號後按新增再放棄,再按作廢,之前查詢的那筆會被作廢掉
# Modify.........: No.FUN-670060 06/08/04 By wujie 直接拋總帳修改
# Modify.........: No.FUN-680088 06/08/25 By Rayven 新增多帳套功能
# Modify.........: No.FUN-680107 06/09/11 By Hellen 欄位類型修改
# Modify.........: No.FUN-690090 06/09/25 By Rayven 新增內部帳戶
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改   
# Modify.........: No.FUN-6A0082 06/11/07 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0079 06/12/04 By jamie 1.FUNCTION _fetch() 清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-710024 07/01/29 By cheunl錯誤訊息匯整
# Modify.........: No.FUN-730032 07/03/21 By Elva  新增nme21,nme22,nme23,nme24
# Modify.........: No.TQC-730087 07/03/21 By jamie anmt920確認時，分錄檢查不過時，因資料庫沒有切過來，會產生-6372的錯誤
# Modify.........: No.MOD-740072 07/04/22 By rainy 分錄幣別錯誤
# Modify.........: No.CHI-740035 07/04/23 By Nicola nnv26給預設
# Modify.........: No.MOD-740346 07/04/23 By Rayven 不使用網銀時不去判斷是否未轉
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-790031 07/09/13 By Nicole 正Primary Key後,程式判斷錯誤訊息-239時必須改變做法
# Modify.........: No.TQC-790160 07/09/28 By Mandy 誤砍一行,補回
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-850038 08/05/13 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.MOD-8B0144 08/11/14 By chenyu 刪除時沒有刪除分錄底稿
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-930005 09/03/02 By chenl 調用函數t920_chgdbs(),當傳入的參數為g_azp03_curr時,需要重新鎖表.
# Modify.........: No.FUN-940036 09/04/07 By jan 當其單據性質之【傳票單別】非空白者,即可有ACTION 【拋轉總帳】及【傳票拋轉還原】功能
# Modify.........: No.FUN-980005 09/08/19 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980020 09/09/01 By douzh GP5.2架構重整，修改sub相關傳參
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980025 09/09/21 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No.FUN-980025 09/09/27 By dxfwo p_qry 跨資料庫查詢
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.TQC-990012 09/10/14 By Carrier chgdbs前,檢查傳參是否為空,若為空,則不進行db切換
# Modify.........: No.FUN-9C0073 10/01/15 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/07/13 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-9A0036 10/08/04 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/08/04 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/08/04 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No.TQC-A90063 10/09/20 By Carrier 科目二时检查错误
# Modify.........: No.MOD-A20047 10/10/05 By sabrina 將npq37的值移到CALL s_def_npq()後面 
# Modify.........: No.FUn-AA0087 11/01/29 By Mengxw  異動碼類型設定的改善 
# Modify.........: No:FUN-B20073 11/02/24 By lilingyu 科目查詢自動過濾-hcode
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: No:FUN-B40056 11/05/13 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50063 11/05/26 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料 
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file  
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30085 12/06/29 By lixiang 串CR報表改GR報表
# Modify.........: No:FUN-C80018 12/08/06 By minpp 大陸版時如果anmi030沒有維護單身時，anmt100單頭的簿號和支票號碼可以手動輸入
# Modify.........: No.CHI-C90052 12/10/02 By Lori 取消確認需在傳票拋轉還原成功後才執行
# Modify.........: No.FUN-D20035 13/02/19 By nanbing 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.FUN-D10065 13/03/07 By wangrr 在調用s_def_npq前npq04=NULL

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_nnv              RECORD LIKE nnv_file.*,
    g_nnv_t            RECORD LIKE nnv_file.*,
    g_nnv_o            RECORD LIKE nnv_file.*,
    g_npp              RECORD LIKE npp_file.*,
    g_npq              RECORD LIKE npq_file.*,
    g_nme              RECORD LIKE nme_file.*,
    g_nnv01_t          LIKE nnv_file.nnv01,
    g_nnv03_t          LIKE nnv_file.nnv03,
    g_nnv04_t          LIKE nnv_file.nnv04,
    g_nms              RECORD LIKE nms_file.*,
    g_nnz              RECORD LIKE nnz_file.*,
    g_dept             LIKE cob_file.cobgrup,  #No.FUN-680107 VARCHAR(6)
    g_wc,g_sql         LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(300)
    g_nna06            LIKE nna_file.nna06,
    g_nna03            LIKE nna_file.nna03,
    l_azi04            LIKE azi_file.azi04,    #No:8449
    g_dbs_gl           LIKE type_file.chr21,   #No.FUN-680107 VARCHAR(21)
    #目前所在
    g_dbs_curr         STRING,   #No.FUN-680107 VARCHAR(21)
    g_plant_curr       LIKE type_file.chr10,   #FUN-980020
    g_azp01_curr       LIKE azp_file.azp01,
    g_azp03_curr       LIKE azp_file.azp03,
    #撥出
    g_dbs_out          STRING,   #No.FUN-680107 VARCHAR(21)
    g_plant_out        LIKE type_file.chr10,   #No.FUN-980020
    g_azp01_out        LIKE azp_file.azp01,
    g_azp03_out        LIKE azp_file.azp03,
    g_aza17_out        LIKE aza_file.aza17,
    #撥入
    g_dbs_in           STRING,   #No.FUN-680107 VARCHAR(21)
    g_plant_in         LIKE type_file.chr10,   #No.FUN-980020
    g_azp01_in         LIKE azp_file.azp01,
    g_azp03_in         LIKE azp_file.azp03,
    g_aza17_in         LIKE aza_file.aza17,
    g_aag02_1          LIKE aag_file.aag02,
    g_aag02_2          LIKE aag_file.aag02,
    g_aag02_3          LIKE aag_file.aag02,
    g_aag02_4          LIKE aag_file.aag02,    #No.FUN-680088 
    g_aag02_5          LIKE aag_file.aag02,    #No.FUN-680088 
    g_aag02_6          LIKE aag_file.aag02,    #No.FUN-680088 
    l_cmd              LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(100)
    l_wc,l_wc2         LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(50)
    l_wc3,l_wc4        LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(50)
    l_prtway           LIKE zz_file.zz22,      #No.FUN-680107 VARCHAR(1)
    g_t1               LIKE nmy_file.nmyslip,  #No.FUN-680107 VARCHAR(5)
    g_nmydmy1          LIKE nmy_file.nmydmy1,  #No.FUN-680107 VARCHAR(1)
    g_argv1            LIKE nnv_file.nnv01,    #TQC-630074 #單號
    g_argv2            STRING                  #TQC-630074 #指定執行功能:query or insert 
 
DEFINE g_forupd_sql        STRING              #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done STRING
 
DEFINE   g_chr          LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
DEFINE   g_cnt          LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_i            LIKE type_file.num5    #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE   g_void         LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
DEFINE o_azi04          LIKE azi_file.azi04    #No.FUN-640142
DEFINE c_azi04          LIKE azi_file.azi04    #No.FUN-640142
DEFINE i_azi04          LIKE azi_file.azi04    #No.FUN-640142
DEFINE   g_str          STRING                 #No.FUN-670060                                                                                   
DEFINE   g_wc_gl        STRING                 #No.FUN-670060                                                                                   
DEFINE   g_nnv41_nma02  LIKE nma_file.nma02    #No.FUN-690090
DEFINE   g_nnv42_nma02  LIKE nma_file.nma02    #No.FUN-690090
DEFINE   g_nma01        LIKE nma_file.nma01    #No.FUN-690090
DEFINE g_flag       LIKE type_file.chr1       #No.FUN-730032
DEFINE g_bookno1    LIKE aza_file.aza81       #No.FUN-730032
DEFINE g_bookno2    LIKE aza_file.aza82       #No.FUN-730032
DEFINE g_bookno3    LIKE aza_file.aza82       #No.FUN-730032
DEFINE g_npq25      LIKE npq_file.npq25       #No.FUN-9A0036
 
MAIN
    DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
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
    CALL t920_lock_cur()
    LET g_plant_new = g_nmz.nmz02p
    CALL s_getdbs()
    LET g_dbs_gl = g_dbs_new
    CALL t920_plantnam('d','3',g_plant)
    LET g_azp01_curr = g_dbs_curr
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
    INITIALIZE g_nnv.* TO NULL
    INITIALIZE g_nnv_t.* TO NULL
    INITIALIZE g_nnv_o.* TO NULL
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW t920_w AT p_row,p_col
         WITH FORM "anm/42f/anmt920"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF g_aza.aza63 = 'N' THEN
       CALL cl_set_comp_visible("nnv121,nnv191,nnv271,aag02_4,aag02_5,aag02_6",FALSE)
    END IF
 
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t920_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t920_a()
            END IF
         OTHERWISE
            CALL t920_q()
      END CASE
   END IF
 
       LET g_action_choice = ""
       CALL t920_menu()
    CLOSE WINDOW t920_w
 
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION t920_lock_cur()
 
    LET g_forupd_sql = "SELECT * FROM nnv_file WHERE nnv01 = ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t920_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
END FUNCTION
FUNCTION t920_fetch_cur()
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nnvuser', 'nnvgrup')
 
    LET g_sql="SELECT nnv01 FROM nnv_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY nnv01"
    PREPARE t920_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t920_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t920_prepare
END FUNCTION
 
FUNCTION t920_cs()
    CLEAR FORM
 
    IF NOT cl_null(g_argv1) THEN 
         LET g_wc=" nnv01='",g_argv1,"'"
    ELSE
   INITIALIZE g_nnv.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        nnv01,nnv02,nnv03,nnv04,nnv33,nnv34,nnv35,nnvconf,nnv05,nnv06,
        nnv07,nnv08,nnv09,nnv10,nnv11,nnv12,nnv121,nnv41,nnv13,nnv14,nnv15,nnv16, #No.FUN-680088 add nnv121 #No.FUN-690090 add nnv41
        nnv17,nnv18,nnv19,nnv191,nnv20,nnv21,nnv22,nnv23,nnv24,nnv25,nnv26, #No.FUN-680088 add nnv191
        nnv27,nnv271,nnv42,nnv28,nnv29,nnv30,nnv31,nnv32,  #No.FUN-680088 add nnv271 #No.FUN-690090 add nnv42
        nnvuser,nnvgrup,nnvmodu,nnvdate,nnvacti
        ,nnvud01,nnvud02,nnvud03,nnvud04,nnvud05,
        nnvud06,nnvud07,nnvud08,nnvud09,nnvud10,
        nnvud11,nnvud12,nnvud13,nnvud14,nnvud15
 
       BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(nnv01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nnv"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnv01
                  NEXT FIELD nnv01
               WHEN INFIELD(nnv03) # 部門
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnv03
                  NEXT FIELD nnv03
               WHEN INFIELD(nnv04) #現金變動碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nml"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnv04
                  NEXT FIELD nnv04
               #==>撥出*****************************************
               WHEN INFIELD(nnv05) #撥出營運中心
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnv05
                  NEXT FIELD nnv05
               WHEN INFIELD(nnv06) #撥出銀行代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_m_nma"
                  LET g_qryparam.plant = g_plant_curr #No.FUN-980025 add  
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnv06
                  NEXT FIELD nnv06
              WHEN INFIELD(nnv07) #撥出異動碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_m_nmc01"
                  LET g_qryparam.plant = g_plant_curr #No.FUN-980025 add  
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnv07
                  NEXT FIELD nnv07
               WHEN INFIELD(nnv08) #撥出幣別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi1"
                  LET g_qryparam.plant = g_plant_curr #No.FUN-980025 add  
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnv08
                  NEXT FIELD nnv08
               WHEN INFIELD(nnv12) #撥出科目
                   CALL s_get_bookno1(YEAR(g_nnv.nnv02),g_plant_curr) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                  CALL q_m_aag(TRUE,TRUE,g_plant_curr,g_nnv.nnv12,'23',g_bookno1) #No.FUN-980025
                       RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnv12
                  NEXT FIELD nnv12
               WHEN INFIELD(nnv121)
                  CALL s_get_bookno1(YEAR(g_nnv.nnv02),g_plant_curr) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
                  CALL q_m_aag(TRUE,TRUE,g_plant_curr,g_nnv.nnv121,'23',g_bookno2)  #No.FUN-980025
                       RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnv121
                  NEXT FIELD nnv121
               #==>手續費**************************************
               WHEN INFIELD(nnv13) #手續費銀行代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_m_nma"
                  LET g_qryparam.plant = g_plant_curr #No.FUN-980025 add  
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnv13
                  NEXT FIELD nnv13
              WHEN INFIELD(nnv14) #手續費異動碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_m_nmc01"
                  LET g_qryparam.plant = g_plant_curr #No.FUN-980025 add  
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnv14
                  NEXT FIELD nnv14
               WHEN INFIELD(nnv15) #手續費幣別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi1"
                  LET g_qryparam.plant = g_plant_curr #No.FUN-980025 add  
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnv15
                  NEXT FIELD nnv15
               WHEN INFIELD(nnv19) #手續費科目
                  CALL s_get_bookno1(YEAR(g_nnv.nnv02),g_plant_curr) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                  CALL q_m_aag(TRUE,TRUE,g_plant_curr,g_nnv.nnv19,'23',g_bookno1)  #No.FUN-980025
                       RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnv19
                  NEXT FIELD nnv19
               WHEN INFIELD(nnv191)
                  CALL s_get_bookno1(YEAR(g_nnv.nnv02),g_plant_curr) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
                  CALL q_m_aag(TRUE,TRUE,g_plant_curr,g_nnv.nnv191,'23',g_bookno2)  #No.FUN-980025
                       RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnv191
                  NEXT FIELD nnv191
               #==>撥入*****************************************
               WHEN INFIELD(nnv20) #撥入營運中心
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnv20
                  NEXT FIELD nnv20
               WHEN INFIELD(nnv21) #撥入銀行代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_m_nma"
                  LET g_qryparam.plant = g_plant_curr #No.FUN-980025 add  
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnv21
                  NEXT FIELD nnv21
              WHEN INFIELD(nnv22) #撥入異動碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_m_nmc01"
                  LET g_qryparam.plant = g_plant_curr #No.FUN-980025 add  
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnv22
                  NEXT FIELD nnv22
               WHEN INFIELD(nnv23) #撥入幣別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi1"
                  LET g_qryparam.plant = g_plant_curr #No.FUN-980025 add  
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnv23
                  NEXT FIELD nnv23
               WHEN INFIELD(nnv27) #撥入科目
                  CALL s_get_bookno1(YEAR(g_nnv.nnv02),g_plant_curr) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
                  CALL q_m_aag(TRUE,TRUE,g_plant_curr,g_nnv.nnv27,'23',g_bookno1) #No.FUN-980025
                       RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnv27
                  NEXT FIELD nnv27
               WHEN INFIELD(nnv271)
                  CALL s_get_bookno1(YEAR(g_nnv.nnv02),g_plant_curr) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
                  CALL q_m_aag(TRUE,TRUE,g_plant_curr,g_nnv.nnv271,'23',g_bookno2) #No.FUN-980025
                       RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnv271
                  NEXT FIELD nnv271
               WHEN INFIELD(nnv41)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma3"
                  LET g_qryparam.plant = g_plant_curr #No.FUN-980025 add  
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnv41
                  NEXT FIELD nnv41
               WHEN INFIELD(nnv42)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma3"
                  LET g_qryparam.plant = g_plant_curr #No.FUN-980025 add  
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnv42
                  NEXT FIELD nnv42
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
       IF INT_FLAG THEN RETURN END IF
    END IF
    CALL t920_fetch_cur() #TQC-640113 add
       
 
    LET g_sql=
        "SELECT COUNT(*) FROM nnv_file WHERE ",g_wc CLIPPED
    PREPARE t920_precount FROM g_sql
    DECLARE t920_count CURSOR FOR t920_precount
END FUNCTION
 
FUNCTION t920_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
            IF g_aza.aza63 = 'N' THEN
               CALL cl_set_act_visible("maintain_entry_sheet_out_2,maintain_entry_sheet_in_2",FALSE)
            END IF
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t920_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t920_q()
            END IF
        ON ACTION next
            CALL t920_fetch('N')
        ON ACTION previous
            CALL t920_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                  CALL t920_u()
            END IF
 
        #分錄底稿產生
        ON ACTION gen_entry_sheet
            LET g_action_choice="gen_entry_sheet"
            IF cl_chk_act_auth() THEN
                 CALL t920_gen_entry_sheet()
            END IF
 
        #撥出分錄底稿維護
        ON ACTION maintain_entry_sheet_out
            LET g_action_choice="maintain_entry_sheet_out"
            IF cl_chk_act_auth() THEN
                 CALL t920_main_out()
            END IF
 
        ON ACTION maintain_entry_sheet_out_2
            LET g_action_choice="maintain_entry_sheet_out_2"
            IF cl_chk_act_auth() THEN
                 CALL t920_main_out_1()
            END IF
 
        #撥入分錄底稿維護
        ON ACTION maintain_entry_sheet_in
            LET g_action_choice="maintain_entry_sheet_in"
            IF cl_chk_act_auth() THEN
                 CALL t920_main_in()
            END IF
 
        ON ACTION maintain_entry_sheet_in_2
            LET g_action_choice="maintain_entry_sheet_in_2"
            IF cl_chk_act_auth() THEN
                 CALL t920_main_in_1()
            END IF
 
        #作廢
        ON ACTION void
            LET g_action_choice="void"
            IF cl_chk_act_auth() THEN
                #CALL t920_x() #FUN-D20035 mark
                CALL t920_x(1) #FUN-D20035 add
                IF g_nnv.nnvconf = 'X' THEN
                   LET g_void = 'Y'
                ELSE
                   LET g_void = 'N'
                END IF
                CALL cl_set_field_pic(g_nnv.nnvconf,"","","",g_void,"")
            END IF
#FUN-D20035 add sta
        ON ACTION undo_void
            LET g_action_choice="undo_void"
            IF cl_chk_act_auth() THEN
                CALL t920_x(2)
                IF g_nnv.nnvconf = 'X' THEN
                   LET g_void = 'Y'
                ELSE
                   LET g_void = 'N'
                END IF
                CALL cl_set_field_pic(g_nnv.nnvconf,"","","",g_void,"")
            END IF
#FUN-D20035 add end            
        #確認
        ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
                CALL t920_y()
                IF g_nnv.nnvconf = 'X' THEN
                   LET g_void = 'Y'
                ELSE
                   LET g_void = 'N'
                END IF
                CALL cl_set_field_pic(g_nnv.nnvconf,"","","",g_void,"")
            END IF
        #取消確認
        ON ACTION undo_confirm
            LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
                CALL t920_z()
                IF g_nnv.nnvconf = 'X' THEN
                   LET g_void = 'Y'
                ELSE
                   LET g_void = 'N'
                END IF
                CALL cl_set_field_pic(g_nnv.nnvconf,"","","",g_void,"")
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                CALL t920_r()
            END IF
         ON ACTION output
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_wc) THEN
                 #LET g_msg = 'anmr920 "',g_today,'" "',g_user,'" "',g_lang,'" ', #FUN-C30085 mark
                  LET g_msg = 'anmg920 "',g_today,'" "',g_user,'" "',g_lang,'" ', #FUN-C30085 add
                              ' "Y" " " "1" "',g_wc,'" "N"'
                  CALL cl_cmdrun(g_msg)
               END IF
            END IF
         ON ACTION carry_voucher                                                                                                    
            IF cl_chk_act_auth() THEN
               IF g_nnv.nnvconf = 'Y' THEN                                                                                             
                  CALL t920_carry_voucher()                                                                                            
               ELSE 
                  CALL cl_err('','atm-402',1)
               END IF                                                                                                                  
            END IF
         ON ACTION undo_carry_voucher                                                                                               
            IF cl_chk_act_auth() THEN
               IF g_nnv.nnvconf = 'Y' THEN                                                                                             
                  CALL t920_undo_carry_voucher()                                                                                       
               ELSE 
                  CALL cl_err('','atm-403',1)
               END IF                                                                                                                  
            END IF
         ON ACTION help
            CALL cl_show_help()
         ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
            IF g_nnv.nnvconf = 'X' THEN
               LET g_void = 'Y'
            ELSE
               LET g_void = 'N'
            END IF
            CALL cl_set_field_pic(g_nnv.nnvconf,"","","",g_void,"")
         ON ACTION jump
            CALL t920_fetch('/')
         ON ACTION first
            CALL t920_fetch('F')
         ON ACTION last
            CALL t920_fetch('L')
         ON ACTION CONTROLG
            CALL cl_cmdask()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
         ON ACTION about
            CALL cl_about()
            LET g_action_choice = "exit"
            CONTINUE MENU
 
         ON ACTION related_document       #相關文件
            LET g_action_choice="related_document"
              IF cl_chk_act_auth() THEN
                 IF g_nnv.nnv01 IS NOT NULL THEN
                 LET g_doc.column1 = "nnv01"
                 LET g_doc.value1 = g_nnv.nnv01
                 CALL cl_doc()
               END IF
            END IF
         ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE 		
            LET g_action_choice = "exit"
            EXIT MENU
 
      &include "qry_string.4gl"
    END MENU
    CLOSE t920_cs
END FUNCTION
 
FUNCTION t920_a()
DEFINE l_nma12  LIKE nma_file.nma12       #TQC-840066
DEFINE li_result  LIKE type_file.num5     #No.FUN-550057 #No.FUN-680107 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_nnv.* TO NULL
    INITIALIZE g_nnv_t.* TO NULL
    INITIALIZE g_nnv_o.* TO NULL
    LET g_nnv_t.* = g_nnv.*
    LET g_nnv01_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_nnv.nnv02 = g_today
        LET g_nnv.nnv03 = g_grup
        LET g_nnv.nnv05 = g_plant
        LET g_nnv.nnv28 = 0
        LET g_nnv.nnv29 = 0
        LET g_nnv.nnv30 = 0
        LET g_nnv.nnv31 = 0
        LET g_nnv.nnv32 = 0
        LET g_nnv.nnvconf = 'N'
        LET g_nnv.nnvacti = 'Y'
        LET g_nnv.nnvuser = g_user
        LET g_nnv.nnvoriu = g_user #FUN-980030
        LET g_nnv.nnvorig = g_grup #FUN-980030
        LET g_nnv.nnvgrup = g_grup               #使用者所屬群
        LET g_nnv.nnvdate = g_today
 
        LET g_nnv.nnvlegal= g_legal
 
        CALL t920_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_nnv.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        BEGIN WORK
        CALL s_auto_assign_no("anm",g_nnv.nnv01,g_nnv.nnv02,"H","nnv_file","nnv01","","","")
             RETURNING li_result,g_nnv.nnv01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_nnv.nnv01
 
        IF g_nnv.nnv01 IS NULL THEN                # KEY 不可空白
           CONTINUE WHILE
        END IF
        LET g_success = 'Y'
        INSERT INTO nnv_file VALUES(g_nnv.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","nnv_file",g_nnv.nnv01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            ROLLBACK WORK
            CONTINUE WHILE
        ELSE
            LET g_nnv_t.* = g_nnv.*                # 保存上筆資料
            SELECT nnv01 INTO g_nnv.nnv01 FROM nnv_file
             WHERE nnv01 = g_nnv.nnv01
            IF g_success = 'Y' THEN
                CALL cl_cmmsg(1)
                COMMIT WORK
                CALL cl_flow_notify(g_nnv.nnv01,'I')
            ELSE
                CALL cl_rbmsg(1)
                ROLLBACK WORK
                EXIT WHILE
            END IF
            #---判斷是否立即確認-----
            LET g_t1 = s_get_doc_no(g_nnv.nnv01)       #No.FUN-550057
            SELECT nmydmy1 INTO g_nmydmy1 FROM nmy_file
             WHERE nmyslip = g_t1 AND nmyacti = 'Y'
            IF g_nmydmy1 = 'Y' THEN 
                CALL t920_y() 
            END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t920_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
        l_cmd           LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(50)
        l_nma28         LIKE nma_file.nma28,    #No.MOD-510041
        l_buf           LIKE nmy_file.nmydesc,  #No.FUN-680107 VARCHAR(30)
        l_n             LIKE type_file.num5,    #No.FUN-680107 SMALLINT
        l_cnt           LIKE type_file.num5,    #No.FUN-680107 SMALLINT
        g_t1            LIKE nmy_file.nmyslip,  #No.FUN-680107 VARCHAR(5)
        l_t             LIKE nmy_file.nmyslip,  #No.FUN-690090
        l_nma37         LIKE nma_file.nma37,    #No.FUN-690090
        l_nma37_2       LIKE nma_file.nma37,    #No.FUN-690090
        l_nmc03_1       LIKE nmc_file.nmc03,    #No.FUN-690090
        l_nmc03_2       LIKE nmc_file.nmc03     #No.FUN-690090
DEFINE li_result        LIKE type_file.num5     #No.FUN-550057  #No.FUN-680107 SMALLINT
 
    INPUT BY NAME g_nnv.nnvoriu,g_nnv.nnvorig,
        g_nnv.nnv01,g_nnv.nnv02,g_nnv.nnv03,g_nnv.nnv04,g_nnv.nnv05,
        g_nnv.nnv06,g_nnv.nnv07,g_nnv.nnv08,g_nnv.nnv09,g_nnv.nnv10,
        g_nnv.nnv11,g_nnv.nnv12,g_nnv.nnv121,g_nnv.nnv41,g_nnv.nnv13,g_nnv.nnv14,g_nnv.nnv15, #No.FUN-680088 add g_nnv.nnv121 #No.FUN-690090 add nnv41
        g_nnv.nnv16,g_nnv.nnv17,g_nnv.nnv18,g_nnv.nnv19,g_nnv.nnv191,g_nnv.nnv20, #No.FUN-680088 add g_nnv.nnv191
        g_nnv.nnv21,g_nnv.nnv22,g_nnv.nnv23,g_nnv.nnv24,g_nnv.nnv25,
        g_nnv.nnv26,g_nnv.nnv27,g_nnv.nnv271,g_nnv.nnv42,g_nnv.nnv28,g_nnv.nnv29,g_nnv.nnv30, #No.FUN-680088 add g_nnv.nnv271 #No.FUN-690090 add nnv42
        g_nnv.nnv31,g_nnv.nnv32,g_nnv.nnv33,
        g_nnv.nnvconf,g_nnv.nnvacti,
        g_nnv.nnvuser,g_nnv.nnvgrup,g_nnv.nnvmodu,g_nnv.nnvdate
       ,g_nnv.nnvud01,g_nnv.nnvud02,g_nnv.nnvud03,g_nnv.nnvud04,
        g_nnv.nnvud05,g_nnv.nnvud06,g_nnv.nnvud07,g_nnv.nnvud08,
        g_nnv.nnvud09,g_nnv.nnvud10,g_nnv.nnvud11,g_nnv.nnvud12,
        g_nnv.nnvud13,g_nnv.nnvud14,g_nnv.nnvud15 
        WITHOUT DEFAULTS
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t920_set_entry_a()       #MOD-640332 add
            CALL t920_set_no_entry_a()    #MOD-640332 add
            CALL t920_no_required_a()     #MOD-640332 add
            CALL t920_required_a()        #MOD-640332 add
            LET g_before_input_done = TRUE
 
        AFTER FIELD nnv01
           IF NOT cl_null(g_nnv.nnv01) THEN
               IF g_nnv_o.nnv01 != g_nnv.nnv01 OR cl_null(g_nnv_o.nnv01) THEN
                   CALL s_check_no("anm",g_nnv.nnv01,g_nnv01_t,"H","nnv_file","nnv01","")
                   RETURNING li_result,g_nnv.nnv01
                   DISPLAY BY NAME g_nnv.nnv01
                   IF (NOT li_result) THEN
                       NEXT FIELD nnv01
                   END IF
                   LET l_buf = s_get_doc_no(g_nnv.nnv01)
                   SELECT nmydesc INTO l_buf FROM nmy_file
                    WHERE nmyslip=l_buf
                   DISPLAY l_buf TO FORMONLY.nmydesc
               END IF
               LET l_t = s_get_doc_no(g_nnv.nnv01)
               SELECT nmydmy6 INTO g_nmy.nmydmy6 FROM nmy_file WHERE nmyslip = l_t
               CALL t920_set_entry_a()
               CALL t920_set_no_entry_a()
           END IF
           LET g_nnv_o.nnv01 = g_nnv.nnv01
        AFTER FIELD nnv03 #部門
            IF NOT cl_null(g_nnv.nnv03) THEN
                CALL t920_nnv03(p_cmd)
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnv.nnv03,g_errno,1)
                    LET g_nnv.nnv03 = g_nnv_t.nnv03
                    DISPLAY BY NAME g_nnv.nnv03
                    NEXT FIELD nnv03
                END IF
            END IF
            LET g_nnv_o.nnv03 = g_nnv.nnv03
        AFTER FIELD nnv04 #現金變動碼
            IF NOT cl_null(g_nnv.nnv04) THEN
                CALL t920_nnv04(p_cmd)
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnv.nnv04,g_errno,1)
                    LET g_nnv.nnv04 = g_nnv_t.nnv04
                    DISPLAY BY NAME g_nnv.nnv04
                    NEXT FIELD nnv04
                END IF
            END IF
            LET g_nnv_o.nnv04 = g_nnv.nnv04
 
#==>撥出**********************************************
        AFTER FIELD nnv05 #撥出營運中心
            IF NOT cl_null(g_nnv.nnv05) THEN
                CALL t920_plantnam(p_cmd,'1',g_nnv.nnv05)
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnv.nnv05,g_errno,1)
                    LET g_nnv.nnv05 = g_nnv_t.nnv05
                    DISPLAY BY NAME g_nnv.nnv05
                    NEXT FIELD nnv05
                END IF
                IF NOT cl_null(g_nnv.nnv20) THEN
                   IF g_nnv.nnv05 = g_nnv.nnv20 THEN
                      CALL cl_err("","apm-101",0)
                      NEXT FIELD nnv05
                   END IF
                END IF
                #CALL t920_aza17(g_dbs_out) RETURNING g_aza17_out
                CALL t920_aza17(g_plant_out) RETURNING g_aza17_out  #FUN-A50102
                IF g_nnv_o.nnv05 != g_nnv.nnv05 THEN
                    IF NOT cl_null(g_nnv.nnv06) THEN
                        #CALL t920_nma01(p_cmd,'1',g_dbs_out,g_nnv.nnv06)
                        CALL t920_nma01(p_cmd,'1',g_plant_out,g_nnv.nnv06)  #FUN-A50102
                        IF NOT cl_null(g_errno) THEN
                            CALL cl_err(g_nnv.nnv06,g_errno,1)
                            LET g_nnv.nnv06 = g_nnv_t.nnv06
                            DISPLAY BY NAME g_nnv.nnv06
                            NEXT FIELD nnv06
                        END IF
                    END IF
                END IF
            END IF
            LET g_nnv_o.nnv05 = g_nnv.nnv05
 
        AFTER FIELD nnv06 #撥出銀行
            IF NOT cl_null(g_nnv.nnv06) THEN
                IF g_nnv_o.nnv06 != g_nnv.nnv06 OR cl_null(g_nnv_o.nnv06) THEN
                    #CALL t920_nma01(p_cmd,'1',g_dbs_out,g_nnv.nnv06)
                    CALL t920_nma01(p_cmd,'1',g_plant_out,g_nnv.nnv06)  #FUN-A50102
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_nnv.nnv06,g_errno,1)
                        LET g_nnv.nnv06 = g_nnv_t.nnv06
                        DISPLAY BY NAME g_nnv.nnv06
                        NEXT FIELD nnv06
                    END IF
                END IF
                IF p_cmd='a' THEN #MOD-640332 add if 判斷
                    IF cl_null(g_nnv.nnv13) THEN
                       LET g_nnv.nnv13 = g_nnv.nnv06
                       DISPLAY BY NAME g_nnv.nnv13
                    END IF
                    CALL t920_set_entry_a()       #MOD-640332 add
                    CALL t920_set_no_entry_a()    #MOD-640332 add
                    CALL t920_no_required_a()     #MOD-640332 add
                    CALL t920_required_a()        #MOD-640332 add
                END IF
                LET l_nma37 = NULL
                LET l_nma37_2 = NULL
                #LET g_sql = "SELECT nma37 FROM ",g_dbs_out,"nma_file",
                LET g_sql = "SELECT nma37 FROM ",cl_get_target_table(g_plant_out,'nma_file'), #FUN-A50102
                            " WHERE nma01 = '",g_nnv.nnv06,"'"
 	            CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                CALL cl_parse_qry_sql(g_sql,g_plant_out) RETURNING g_sql #FUN-A50102
                PREPARE nma37_p1 FROM g_sql
                DECLARE nma37_c1 CURSOR FOR nma37_p1
                OPEN nma37_c1
                FETCH nma37_c1 INTO l_nma37
                IF NOT cl_null(g_nnv.nnv01) THEN
                   IF g_nmy.nmydmy6 = 'Y' THEN
                      IF l_nma37 = '0' THEN
                         CALL cl_err(g_nnv.nnv06,'anm-991',1)
                         NEXT FIELD nnv06
                      END IF
                   END IF
                END IF
                IF NOT cl_null(g_nnv.nnv21) THEN
                   #LET g_sql = "SELECT nma37 FROM ",g_dbs_in,"nma_file",
                   LET g_sql = "SELECT nma37 FROM ",cl_get_target_table(g_plant_in,'nma_file'), #FUN-A50102
                               " WHERE nma01 = '",g_nnv.nnv21,"'"
 	               CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                   CALL cl_parse_qry_sql(g_sql,g_plant_in) RETURNING g_sql #FUN-A50102
                   PREPARE nma37_p2 FROM g_sql
                   DECLARE nma37_c2 CURSOR FOR nma37_p2
                   OPEN nma37_c2
                   FETCH nma37_c2 INTO l_nma37_2
                   IF l_nma37 <> l_nma37_2 THEN
                      CALL cl_err(g_nnv.nnv06,'anm-990',1)
                      NEXT FIELD nnv06
                   END IF
                END IF
            END IF
            LET g_nnv_o.nnv06 = g_nnv.nnv06
 
        AFTER FIELD nnv07 #撥出異動碼
            IF NOT cl_null(g_nnv.nnv07) THEN
                #CALL t920_nmc01(p_cmd,'1',g_dbs_out,g_nnv.nnv07,'2')
                CALL t920_nmc01(p_cmd,'1',g_plant_out,g_nnv.nnv07,'2')  #FUN-A50102
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnv.nnv07,g_errno,1)
                    LET g_nnv.nnv07 = g_nnv_t.nnv07
                    DISPLAY BY NAME g_nnv.nnv07
                    NEXT FIELD nnv07
                END IF
                IF NOT cl_null(g_nnv.nnv42) THEN
                   LET l_nmc03_1 = NULL
                   LET l_nmc03_2 = NULL
                   #LET g_sql = "SELECT nmc03 FROM ",g_dbs_in,"nmc_file",
                   LET g_sql = "SELECT nmc03 FROM ",cl_get_target_table(g_plant_in,'nmc_file'), #FUN-A50102
                               " WHERE nmc01 = '",g_nnv.nnv07,"'"
 	               CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                   CALL cl_parse_qry_sql(g_sql,g_plant_in) RETURNING g_sql #FUN-A50102
                   PREPARE nmc03_p1 FROM g_sql
                   DECLARE nmc03_c1 CURSOR FOR nmc03_p1
                   OPEN nmc03_c1
                   FETCH nmc03_c1 INTO l_nmc03_1
                   IF cl_null(l_nmc03_1) THEN
                      CALL cl_err(g_nnv.nnv07,'anm-987',1)
                      NEXT FIELD nnv07
                   ELSE
                      #LET g_sql = "SELECT nmc03 FROM ",g_dbs_out,"nmc_file",
                      LET g_sql = "SELECT nmc03 FROM ",cl_get_target_table(g_plant_out,'nmc_file'), #FUN-A50102
                                  " WHERE nmc01 = '",g_nnv.nnv07,"'"
 	                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                      CALL cl_parse_qry_sql(g_sql,g_plant_out) RETURNING g_sql #FUN-A50102
                      PREPARE nmc03_p2 FROM g_sql
                      DECLARE nmc03_c2 CURSOR FOR nmc03_p2
                      OPEN nmc03_c2
                      FETCH nmc03_c2 INTO l_nmc03_2
                      IF l_nmc03_1 <> l_nmc03_2 THEN
                         CALL cl_err(g_nnv.nnv07,'anm-986',1)
                         NEXT FIELD nnv07
                      END IF
                   END IF
                END IF
            END IF
            LET g_nnv_o.nnv07 = g_nnv.nnv07
 
        BEFORE FIELD nnv09 #撥出幣別/匯率
            IF NOT cl_null(g_nnv.nnv08) THEN
                #CALL t920_azi01(p_cmd,'1',g_dbs_out,g_nnv.nnv08)  #幣別
                CALL t920_azi01(p_cmd,'1',g_plant_out,g_nnv.nnv08)  #FUN-A50102
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnv.nnv08,g_errno,1)
                    LET g_nnv.nnv08 = g_nnv_t.nnv08
                    DISPLAY BY NAME g_nnv.nnv08
                    NEXT FIELD nnv08
                END IF
                IF g_nnv_o.nnv08 != g_nnv.nnv08 OR cl_null(g_nnv_o.nnv08) THEN
                    CALL s_currm(g_nnv.nnv08,g_nnv.nnv02,'S',g_plant_out)    #FUN-980020 
                         RETURNING g_nnv.nnv09
                    DISPLAY BY NAME g_nnv.nnv09
                    IF NOT cl_null(g_nnv.nnv09) AND g_nnv.nnv09 != 0 THEN
                        IF NOT cl_null(g_nnv.nnv10) AND g_nnv.nnv10 != 0 THEN
                            LET g_nnv.nnv11=g_nnv.nnv10 * g_nnv.nnv09
                            CALL cl_digcut(g_nnv.nnv11,g_azi04) RETURNING g_nnv.nnv11  #No.FUN-640142
                            DISPLAY BY NAME g_nnv.nnv11
                        END IF
                    END IF
                END IF
            END IF
            LET g_nnv_o.nnv08 = g_nnv.nnv08
 
        AFTER FIELD nnv09  #匯率
            IF NOT cl_null(g_nnv.nnv09) THEN
                IF g_nnv.nnv09 <=0 THEN
                    NEXT FIELD nnv09
                END IF
                IF g_nnv.nnv08 = g_aza17_out AND g_nnv.nnv09 != 1 THEN
                    NEXT FIELD nnv09
                END IF
                IF g_nnv_o.nnv09 != g_nnv.nnv09 OR cl_null(g_nnv_o.nnv09) THEN
                    IF NOT cl_null(g_nnv.nnv09) AND g_nnv.nnv09 != 0 THEN
                        IF NOT cl_null(g_nnv.nnv10) AND g_nnv.nnv10 != 0 THEN
                            LET g_nnv.nnv11=g_nnv.nnv10 * g_nnv.nnv09
                            CALL cl_digcut(g_nnv.nnv11,g_azi04) RETURNING g_nnv.nnv11  #No.FUN-640142
                            DISPLAY BY NAME g_nnv.nnv11
                        END IF
                    END IF
                END IF
            END IF
            LET g_nnv_o.nnv09 = g_nnv.nnv09
 
        AFTER FIELD nnv10 #撥出原幣
            IF NOT cl_null(g_nnv.nnv10) THEN
               CALL cl_digcut(g_nnv.nnv10,o_azi04) RETURNING g_nnv.nnv10  #No.FUN-640142
               DISPLAY BY NAME g_nnv.nnv10   #No.FUN-640142
                IF g_nnv.nnv10 < 0 THEN
                    CALL cl_err(g_nnv.nnv10,'aim-391',1)
                    LET g_nnv.nnv10 = g_nnv_t.nnv10
                    DISPLAY BY NAME g_nnv.nnv10
                    NEXT FIELD nnv10
                END IF
                IF g_nnv_o.nnv10 != g_nnv.nnv10 OR cl_null(g_nnv_o.nnv10) THEN
                    IF NOT cl_null(g_nnv.nnv09) AND g_nnv.nnv09 != 0 THEN
                        IF NOT cl_null(g_nnv.nnv10) AND g_nnv.nnv10 != 0 THEN
                            LET g_nnv.nnv11=g_nnv.nnv10 * g_nnv.nnv09
                            CALL cl_digcut(g_nnv.nnv11,g_azi04) RETURNING g_nnv.nnv11  #No.FUN-640142
                            DISPLAY BY NAME g_nnv.nnv11
                        END IF
                    END IF
                    LET g_nnv.nnv25 = g_nnv.nnv10
                    DISPLAY BY NAME g_nnv.nnv25
                    IF NOT cl_null(g_nnv.nnv24) AND g_nnv.nnv24 != 0 THEN
                        IF NOT cl_null(g_nnv.nnv25) AND g_nnv.nnv25 != 0 THEN
                            LET g_nnv.nnv26=g_nnv.nnv25 * g_nnv.nnv24
                            CALL cl_digcut(g_nnv.nnv26,g_azi04) RETURNING g_nnv.nnv26  #No.FUN-640142
                            DISPLAY BY NAME g_nnv.nnv26
                        END IF
                    END IF
                END IF
            END IF
            LET g_nnv_o.nnv10 = g_nnv.nnv10
 
        AFTER FIELD nnv11 #撥出本幣
            IF NOT cl_null(g_nnv.nnv11) THEN
               CALL cl_digcut(g_nnv.nnv11,g_azi04) RETURNING g_nnv.nnv11  #No.FUN-640142
               DISPLAY BY NAME g_nnv.nnv11   #No.FUN-640142
               IF g_nnv.nnv11 < 0 THEN
                   CALL cl_err(g_nnv.nnv11,'aim-391',1)
                   LET g_nnv.nnv11 = g_nnv_t.nnv11
                   DISPLAY BY NAME g_nnv.nnv11
                   NEXT FIELD nnv11
               END IF
            END IF
            LET g_nnv_o.nnv11 = g_nnv.nnv11

        BEFORE FIELD nnv12 #撥出科目
            IF cl_null(g_nnv.nnv12) THEN
                SELECT nmq21 INTO g_nnv.nnv12 FROM nmq_file
                 WHERE nmq00 = '0'
                DISPLAY BY NAME g_nnv.nnv12
            END IF
 
        AFTER FIELD nnv12 #撥出科目
            IF NOT cl_null(g_nnv.nnv12) THEN
                CALL t920_aag(g_nnv.nnv12,g_plant_out,'1') RETURNING g_aag02_1  #幣別   #FUN-980020   #No.TQC-A90063
                IF NOT cl_null(g_errno) THEN
#FUN-B20073 --begin--
#                    CALL cl_err(g_nnv.nnv12,g_errno,1)
                     CALL cl_err(g_nnv.nnv12,g_errno,0)
#                    LET g_nnv.nnv12 = g_nnv_t.nnv12
                  CALL q_m_aag(FALSE,FALSE,g_plant_out,g_nnv.nnv12,'23',g_bookno1)  
                       RETURNING g_nnv.nnv12
#FUN-B20073 --end--                    
                    DISPLAY BY NAME g_nnv.nnv12
                    NEXT FIELD nnv12
                END IF
                DISPLAY g_aag02_1  TO FORMONLY.aag02_1
            END IF
            LET g_nnv_o.nnv12 = g_nnv.nnv12
 
        BEFORE FIELD nnv121
            IF cl_null(g_nnv.nnv121) THEN
                SELECT nmq211 INTO g_nnv.nnv121 FROM nmq_file
                 WHERE nmq00 = '0'
                DISPLAY BY NAME g_nnv.nnv121
            END IF
 
        AFTER FIELD nnv121
            IF NOT cl_null(g_nnv.nnv121) THEN
                CALL t920_aag(g_nnv.nnv121,g_plant_out,'2') RETURNING g_aag02_4   #FUN-980020  #No.TQC-A90063
                IF NOT cl_null(g_errno) THEN
#FUN-B20073 --begin--
#                    CALL cl_err(g_nnv.nnv121,g_errno,1)
                     CALL cl_err(g_nnv.nnv121,g_errno,0)
#                    LET g_nnv.nnv121 = g_nnv_t.nnv121
         CALL q_m_aag(FALSE,FALSE,g_plant_out,g_nnv.nnv121,'23',g_bookno2) 
                       RETURNING g_nnv.nnv121
#FUN-B20073 --end--                    
                    DISPLAY BY NAME g_nnv.nnv121
                    NEXT FIELD nnv121
                END IF
                DISPLAY g_aag02_4  TO FORMONLY.aag02_4
            END IF
            LET g_nnv_o.nnv121 = g_nnv.nnv121
 
#==>手續費*********************************************
        BEFORE FIELD nnv13 #手續費銀行
            CALL t920_set_entry_a()       #MOD-640332 add
        AFTER FIELD nnv13 #手續費銀行
            IF NOT cl_null(g_nnv.nnv13) THEN
                IF g_nnv_o.nnv13 != g_nnv.nnv13 OR cl_null(g_nnv_o.nnv13) THEN
                    #CALL t920_nma01(p_cmd,'3',g_dbs_out,g_nnv.nnv13)
                    CALL t920_nma01(p_cmd,'3',g_plant_out,g_nnv.nnv13)  #FUN-A50102
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_nnv.nnv13,g_errno,1)
                        LET g_nnv.nnv13 = g_nnv_t.nnv13
                        DISPLAY BY NAME g_nnv.nnv13
                        NEXT FIELD nnv13
                    END IF
                END IF
            END IF
            CALL t920_set_no_entry_a()    #MOD-640332 add
            CALL t920_no_required_a()     #MOD-640332 add
            CALL t920_required_a()        #MOD-640332 add
            LET g_nnv_o.nnv13 = g_nnv.nnv13
 
        AFTER FIELD nnv14 #手續費異動碼
            IF NOT cl_null(g_nnv.nnv14) THEN
                #CALL t920_nmc01(p_cmd,'3',g_dbs_out,g_nnv.nnv14,'2')
                CALL t920_nmc01(p_cmd,'3',g_plant_out,g_nnv.nnv14,'2')  #FUN-A50102
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnv.nnv14,g_errno,1)
                    LET g_nnv.nnv14 = g_nnv_t.nnv14
                    DISPLAY BY NAME g_nnv.nnv14
                    NEXT FIELD nnv14
                END IF
            END IF
            LET g_nnv_o.nnv14 = g_nnv.nnv14
 
        BEFORE FIELD nnv16 #手續費幣別/匯率
            IF NOT cl_null(g_nnv.nnv15) THEN
                #CALL t920_azi01(p_cmd,'3',g_dbs_out,g_nnv.nnv15)  #幣別
                CALL t920_azi01(p_cmd,'3',g_plant_out,g_nnv.nnv15)  #FUN-A50102
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnv.nnv15,g_errno,1)
                    LET g_nnv.nnv15 = g_nnv_t.nnv15
                    DISPLAY BY NAME g_nnv.nnv15
                    NEXT FIELD nnv15
                END IF
                IF g_nnv_o.nnv15 != g_nnv.nnv15 OR cl_null(g_nnv_o.nnv15) THEN
                   CALL s_currm(g_nnv.nnv15,g_nnv.nnv02,'S',g_plant_out)      #FUN-980020
                        RETURNING g_nnv.nnv16
                    DISPLAY BY NAME g_nnv.nnv16
                    IF NOT cl_null(g_nnv.nnv16) AND g_nnv.nnv16 != 0 THEN
                        IF NOT cl_null(g_nnv.nnv17) AND g_nnv.nnv17 != 0 THEN
                            LET g_nnv.nnv18=g_nnv.nnv17 * g_nnv.nnv16
                            CALL cl_digcut(g_nnv.nnv18,g_azi04) RETURNING g_nnv.nnv18  #No.FUN-640142
                            DISPLAY BY NAME g_nnv.nnv18
                        END IF
                    END IF
                END IF
            END IF
            LET g_nnv_o.nnv15 = g_nnv.nnv15
 
        AFTER FIELD nnv16  #匯率
            IF NOT cl_null(g_nnv.nnv16) THEN
                IF g_nnv.nnv16 <=0 THEN
                    NEXT FIELD nnv16
                END IF
                IF g_nnv.nnv15 = g_aza17_out AND g_nnv.nnv16 != 1 THEN
                    NEXT FIELD nnv16
                END IF
                IF g_nnv_o.nnv16 != g_nnv.nnv16 OR cl_null(g_nnv_o.nnv16) THEN
                    IF NOT cl_null(g_nnv.nnv16) AND g_nnv.nnv16 != 0 THEN
                        IF NOT cl_null(g_nnv.nnv17) AND g_nnv.nnv17 != 0 THEN
                            LET g_nnv.nnv18=g_nnv.nnv17 * g_nnv.nnv16
                            CALL cl_digcut(g_nnv.nnv18,g_azi04) RETURNING g_nnv.nnv18  #No.FUN-640142
                            DISPLAY BY NAME g_nnv.nnv18
                        END IF
                    END IF
                END IF
            END IF
            LET g_nnv_o.nnv16 = g_nnv.nnv16
 
        AFTER FIELD nnv17 #手續費原幣
            IF NOT cl_null(g_nnv.nnv17) THEN
               CALL cl_digcut(g_nnv.nnv17,c_azi04) RETURNING g_nnv.nnv17  #No.FUN-640142
               DISPLAY BY NAME g_nnv.nnv17   #No.FUN-640142
               IF g_nnv.nnv17 < 0 THEN
                  CALL cl_err(g_nnv.nnv17,'aim-391',1)
                  LET g_nnv.nnv17 = g_nnv_t.nnv17
                  DISPLAY BY NAME g_nnv.nnv17
                  NEXT FIELD nnv17
               END IF
               IF g_nnv_o.nnv17 != g_nnv.nnv17 OR cl_null(g_nnv_o.nnv17) THEN
                  IF NOT cl_null(g_nnv.nnv16) AND g_nnv.nnv16 != 0 THEN
                     IF NOT cl_null(g_nnv.nnv17) AND g_nnv.nnv17 != 0 THEN
                        LET g_nnv.nnv18=g_nnv.nnv17 * g_nnv.nnv16
                        CALL cl_digcut(g_nnv.nnv18,g_azi04) RETURNING g_nnv.nnv18  #No.FUN-640142
                        DISPLAY BY NAME g_nnv.nnv18
                     END IF
                  END IF
               END IF
            END IF
            LET g_nnv_o.nnv17 = g_nnv.nnv17
 
        AFTER FIELD nnv18 #手續費本幣
            IF NOT cl_null(g_nnv.nnv18) THEN
               CALL cl_digcut(g_nnv.nnv18,g_azi04) RETURNING g_nnv.nnv18  #No.FUN-640142
               DISPLAY BY NAME g_nnv.nnv18   #No.FUN-640142
               IF g_nnv.nnv18 < 0 THEN
                   CALL cl_err(g_nnv.nnv18,'aim-391',1)
                   LET g_nnv.nnv18 = g_nnv_t.nnv18
                   DISPLAY BY NAME g_nnv.nnv18
                   NEXT FIELD nnv18
               END IF
            END IF
            LET g_nnv_o.nnv18 = g_nnv.nnv18
 
        BEFORE FIELD nnv19 #手續費科目
            IF cl_null(g_nnv.nnv19) THEN
                LET g_sql =
                           #"SELECT nms58 FROM ",g_dbs_out CLIPPED,"nms_file",
                           "SELECT nms58 FROM ",cl_get_target_table(g_plant_out,'nms_file'), #FUN-A50102
                           " WHERE nms01 = '",g_nnv.nnv03,"'"
 	            CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                CALL cl_parse_qry_sql(g_sql,g_plant_out) RETURNING g_sql #FUN-A50102
                PREPARE nms_pre1 FROM g_sql
                DECLARE nms_cur1 CURSOR FOR nms_pre1
                OPEN nms_cur1
                FETCH nms_cur1 INTO g_nnv.nnv19
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
                    FETCH nms_cur2 INTO g_nnv.nnv19
                END IF
                DISPLAY BY NAME g_nnv.nnv19
            END IF

             
        AFTER FIELD nnv19 #手續費科目
            IF NOT cl_null(g_nnv.nnv19) THEN
                CALL t920_aag(g_nnv.nnv19,g_plant_out,'1') RETURNING g_aag02_3  #FUN-980020  #No.TQC-A90063
                IF NOT cl_null(g_errno) THEN
#FUN-B20073 --begin--
#                    CALL cl_err(g_nnv.nnv19,g_errno,1)
                     CALL cl_err(g_nnv.nnv19,g_errno,0)
#                    LET g_nnv.nnv19 = g_nnv_t.nnv19
          CALL q_m_aag(FALSE,FALSE,g_plant_out,g_nnv.nnv19,'23',g_bookno1)  
                       RETURNING g_nnv.nnv19
#FUN-B20073 --end--                    
                    DISPLAY BY NAME g_nnv.nnv19
                    NEXT FIELD nnv19
                END IF
                DISPLAY g_aag02_3  TO FORMONLY.aag02_3
            END IF
            LET g_nnv_o.nnv19 = g_nnv.nnv19
 
        BEFORE FIELD nnv191
            IF cl_null(g_nnv.nnv191) THEN
                #LET g_sql = "SELECT nms581 FROM ",g_dbs_out CLIPPED,"nms_file",
                LET g_sql = "SELECT nms581 FROM ",cl_get_target_table(g_plant_out,'nms_file'), #FUN-A50102
                            " WHERE nms01 = '",g_nnv.nnv03,"'"
                CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                CALL cl_parse_qry_sql(g_sql,g_plant_out) RETURNING g_sql #FUN-A50102
                PREPARE nms_pre3 FROM g_sql
                DECLARE nms_cur3 CURSOR FOR nms_pre3
                OPEN nms_cur3
                FETCH nms_cur3 INTO g_nnv.nnv191
                IF STATUS = 100 THEN
                    #LET g_sql = "SELECT nms581 FROM ",g_dbs_out CLIPPED,"nms_file",
                    LET g_sql = "SELECT nms581 FROM ",cl_get_target_table(g_plant_out,'nms_file'), #FUN-A50102
                                " WHERE nms01 = ' ' "
 	                CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                    CALL cl_parse_qry_sql(g_sql,g_plant_out) RETURNING g_sql #FUN-A50102
                    PREPARE nms_pre4 FROM g_sql
                    DECLARE nms_cur4 CURSOR FOR nms_pre4
                    OPEN nms_cur4
                    FETCH nms_cur4 INTO g_nnv.nnv191
                END IF
                DISPLAY BY NAME g_nnv.nnv191
            END IF
            
        AFTER FIELD nnv191
            IF NOT cl_null(g_nnv.nnv191) THEN
                CALL t920_aag(g_nnv.nnv191,g_plant_out,'2') RETURNING g_aag02_6   #FUN-980020  #No.TQC-A90063
                IF NOT cl_null(g_errno) THEN
#FUN-B20073 --begin--                
#                    CALL cl_err(g_nnv.nnv191,g_errno,1)
                     CALL cl_err(g_nnv.nnv191,g_errno,0)
#                    LET g_nnv.nnv191 = g_nnv_t.nnv191
         CALL q_m_aag(FALSE,FALSE,g_plant_out,g_nnv.nnv191,'23',g_bookno2) 
                       RETURNING g_nnv.nnv191                  
#FUN-B20073 --end--
                    DISPLAY BY NAME g_nnv.nnv191
                    NEXT FIELD nnv191
                END IF
                DISPLAY g_aag02_6  TO FORMONLY.aag02_6
            END IF
            LET g_nnv_o.nnv191 = g_nnv.nnv191
 
        AFTER FIELD nnv20 #撥入營運中心
            IF NOT cl_null(g_nnv.nnv20) THEN
                CALL t920_plantnam(p_cmd,'2',g_nnv.nnv20)
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnv.nnv20,g_errno,1)
                    LET g_nnv.nnv20 = g_nnv_t.nnv20
                    DISPLAY BY NAME g_nnv.nnv20
                    NEXT FIELD nnv20
                END IF
                IF NOT cl_null(g_nnv.nnv05) THEN
                   IF g_nnv.nnv05 = g_nnv.nnv20 THEN
                      CALL cl_err("","apm-101",0)
                      NEXT FIELD nnv20
                   END IF
                END IF
                #CALL t920_aza17(g_dbs_in) RETURNING g_aza17_in
                CALL t920_aza17(g_plant_in) RETURNING g_aza17_in  #FUN-A50102
                IF g_nnv_o.nnv20 != g_nnv.nnv20 OR cl_null(g_nnv_o.nnv20) THEN
                    IF NOT cl_null(g_nnv.nnv21) THEN
                        #CALL t920_nma01(p_cmd,'2',g_dbs_in,g_nnv.nnv21)
                        CALL t920_nma01(p_cmd,'2',g_plant_in,g_nnv.nnv21)  #FUN-A50102
                        IF NOT cl_null(g_errno) THEN
                            CALL cl_err(g_nnv.nnv21,g_errno,1)
                            LET g_nnv.nnv21 = g_nnv_t.nnv21
                            DISPLAY BY NAME g_nnv.nnv21
                            NEXT FIELD nnv21
                        END IF
                    END IF
                END IF
            END IF
            LET g_nnv_o.nnv20 = g_nnv.nnv20
 
        AFTER FIELD nnv21 #撥入銀行
            IF NOT cl_null(g_nnv.nnv21) THEN
                IF g_nnv_o.nnv21 != g_nnv.nnv21 OR cl_null(g_nnv_o.nnv21) THEN
                    #CALL t920_nma01(p_cmd,'2',g_dbs_in,g_nnv.nnv21)
                    CALL t920_nma01(p_cmd,'2',g_plant_in,g_nnv.nnv21)  #FUN-A50102
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_nnv.nnv21,g_errno,1)
                        LET g_nnv.nnv21 = g_nnv_t.nnv21
                        DISPLAY BY NAME g_nnv.nnv21
                        NEXT FIELD nnv21
                    END IF
                END IF
            END IF
            LET l_nma37 = NULL
            LET l_nma37_2 = NULL
            #LET g_sql = "SELECT nma37 FROM ",g_dbs_in,"nma_file",
            LET g_sql = "SELECT nma37 FROM ",cl_get_target_table(g_plant_in,'nma_file'), #FUN-A50102
                        " WHERE nma01 = '",g_nnv.nnv21,"'"
 	        CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,g_plant_in) RETURNING g_sql #FUN-A50102
            PREPARE nma37_p3 FROM g_sql
            DECLARE nma37_c3 CURSOR FOR nma37_p3
            OPEN nma37_c3
            FETCH nma37_c3 INTO l_nma37
            IF NOT cl_null(g_nnv.nnv01) THEN
               IF g_nmy.nmydmy6 = 'Y' THEN
                  IF l_nma37 = '0' THEN
                     CALL cl_err(g_nnv.nnv21,'anm-991',1)
                     NEXT FIELD nnv21
                  END IF
               END IF
            END IF
            IF NOT cl_null(g_nnv.nnv06) THEN
               #LET g_sql = "SELECT nma37 FROM ",g_dbs_out,"nma_file",
               LET g_sql = "SELECT nma37 FROM ",cl_get_target_table(g_plant_out,'nma_file'), #FUN-A50102
                           " WHERE nma01 = '",g_nnv.nnv06,"'"
 	           CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
               CALL cl_parse_qry_sql(g_sql,g_plant_out) RETURNING g_sql #FUN-A50102
               PREPARE nma37_p4 FROM g_sql
               DECLARE nma37_c4 CURSOR FOR nma37_p4
               OPEN nma37_c4
               FETCH nma37_c4 INTO l_nma37_2
               IF l_nma37 <> l_nma37_2 THEN
                  CALL cl_err(g_nnv.nnv21,'anm-990',1)
                  NEXT FIELD nnv21
               END IF
            END IF
            LET g_nnv_o.nnv21 = g_nnv.nnv21
 
        AFTER FIELD nnv22 #撥入異動碼
            IF NOT cl_null(g_nnv.nnv22) THEN
                #CALL t920_nmc01(p_cmd,'2',g_dbs_in,g_nnv.nnv22,'1')  #No.MOD-640273
                CALL t920_nmc01(p_cmd,'2',g_plant_in,g_nnv.nnv22,'1') #FUN-A50102
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnv.nnv22,g_errno,1)
                    LET g_nnv.nnv22 = g_nnv_t.nnv22
                    DISPLAY BY NAME g_nnv.nnv22
                    NEXT FIELD nnv22
                END IF
                IF NOT cl_null(g_nnv.nnv41) THEN
                   LET l_nmc03_1 = NULL
                   LET l_nmc03_2 = NULL
                   #LET g_sql = "SELECT nmc03 FROM ",g_dbs_out,"nmc_file",
                   LET g_sql = "SELECT nmc03 FROM ",cl_get_target_table(g_plant_out,'nmc_file'), #FUN-A50102
                               " WHERE nmc01 = '",g_nnv.nnv22,"'"
 	               CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                   CALL cl_parse_qry_sql(g_sql,g_plant_out) RETURNING g_sql #FUN-A50102
                   PREPARE nmc03_p3 FROM g_sql
                   DECLARE nmc03_c3 CURSOR FOR nmc03_p3
                   OPEN nmc03_c3
                   FETCH nmc03_c3 INTO l_nmc03_1
                   IF cl_null(l_nmc03_1) THEN
                      CALL cl_err(g_nnv.nnv22,'anm-985',1)
                      NEXT FIELD nnv22
                   ELSE
                      #LET g_sql = "SELECT nmc03 FROM ",g_dbs_in,"nmc_file",
                      LET g_sql = "SELECT nmc03 FROM ",cl_get_target_table(g_plant_in,'nmc_file'), #FUN-A50102
                                  " WHERE nmc01 = '",g_nnv.nnv22,"'"
 	                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                      CALL cl_parse_qry_sql(g_sql,g_plant_in) RETURNING g_sql #FUN-A50102
                      PREPARE nmc03_p4 FROM g_sql
                      DECLARE nmc03_c4 CURSOR FOR nmc03_p4
                      OPEN nmc03_c4
                      FETCH nmc03_c4 INTO l_nmc03_2
                      IF l_nmc03_1 <> l_nmc03_2 THEN
                         CALL cl_err(g_nnv.nnv22,'anm-984',1)
                         NEXT FIELD nnv22
                      END IF
                   END IF
                END IF
            END IF
            LET g_nnv_o.nnv22 = g_nnv.nnv22
 
        BEFORE FIELD nnv24 #撥入幣別/匯率
            IF NOT cl_null(g_nnv.nnv23) THEN
                #CALL t920_azi01(p_cmd,'2',g_dbs_in,g_nnv.nnv23)  #幣別
                CALL t920_azi01(p_cmd,'2',g_plant_in,g_nnv.nnv23) #FUN-A50102
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnv.nnv23,g_errno,1)
                    LET g_nnv.nnv23 = g_nnv_t.nnv23
                    DISPLAY BY NAME g_nnv.nnv23
                    NEXT FIELD nnv23
                END IF
                IF g_nnv_o.nnv23 != g_nnv.nnv23 OR cl_null(g_nnv_o.nnv23) THEN
                   CALL s_currm(g_nnv.nnv23,g_nnv.nnv02,'S',g_plant_in)     #FUN-980020
                        RETURNING g_nnv.nnv24
                    DISPLAY BY NAME g_nnv.nnv24
                    IF NOT cl_null(g_nnv.nnv24) AND g_nnv.nnv24 != 0 THEN
                        IF NOT cl_null(g_nnv.nnv25) AND g_nnv.nnv25 != 0 THEN
                            LET g_nnv.nnv26=g_nnv.nnv25 * g_nnv.nnv24
                            CALL cl_digcut(g_nnv.nnv26,g_azi04) RETURNING g_nnv.nnv26  #No.FUN-640142
                            DISPLAY BY NAME g_nnv.nnv26
                        END IF
                    END IF
                END IF
            END IF
            LET g_nnv_o.nnv23 = g_nnv.nnv23
 
        AFTER FIELD nnv24  #匯率
            IF NOT cl_null(g_nnv.nnv24) THEN
                IF g_nnv.nnv24 <=0 THEN
                    NEXT FIELD nnv24
                END IF
                IF g_nnv.nnv23 = g_aza17_in AND g_nnv.nnv24 != 1 THEN
                    NEXT FIELD nnv24
                END IF
                IF g_nnv_o.nnv24 != g_nnv.nnv24 OR cl_null(g_nnv_o.nnv24) THEN
                    IF NOT cl_null(g_nnv.nnv24) AND g_nnv.nnv24 != 0 THEN
                        IF NOT cl_null(g_nnv.nnv25) AND g_nnv.nnv25 != 0 THEN
                            LET g_nnv.nnv26=g_nnv.nnv25 * g_nnv.nnv24
                            CALL cl_digcut(g_nnv.nnv26,g_azi04) RETURNING g_nnv.nnv26  #No.FUN-640142
                            DISPLAY BY NAME g_nnv.nnv26
                        END IF
                    END IF
                END IF
            END IF
            LET g_nnv_o.nnv24 = g_nnv.nnv24
 
        AFTER FIELD nnv25 #撥入原幣
            IF NOT cl_null(g_nnv.nnv25) THEN
               CALL cl_digcut(g_nnv.nnv25,i_azi04) RETURNING g_nnv.nnv25  #No.FUN-640142
               DISPLAY BY NAME g_nnv.nnv25   #No.FUN-640142
               IF g_nnv.nnv25 < 0 THEN
                   CALL cl_err(g_nnv.nnv25,'aim-391',1)
                   LET g_nnv.nnv25 = g_nnv_t.nnv25
                   DISPLAY BY NAME g_nnv.nnv25
                   NEXT FIELD nnv25
               END IF
               IF g_nnv_o.nnv25 != g_nnv.nnv25 OR cl_null(g_nnv_o.nnv25) THEN
                   IF NOT cl_null(g_nnv.nnv24) AND g_nnv.nnv24 != 0 THEN
                       IF NOT cl_null(g_nnv.nnv25) AND g_nnv.nnv25 != 0 THEN
                           LET g_nnv.nnv26=g_nnv.nnv25 * g_nnv.nnv24
                           CALL cl_digcut(g_nnv.nnv26,g_azi04) RETURNING g_nnv.nnv26  #No.FUN-640142
                           DISPLAY BY NAME g_nnv.nnv26
                       END IF
                   END IF
               END IF
            END IF
            LET g_nnv_o.nnv25 = g_nnv.nnv25
 
        BEFORE FIELD nnv26
           IF cl_null(g_nnv.nnv26) THEN
              IF g_nnv_o.nnv25 != g_nnv.nnv25 OR cl_null(g_nnv_o.nnv25) THEN
                 IF NOT cl_null(g_nnv.nnv24) AND g_nnv.nnv24 != 0 THEN
                    IF NOT cl_null(g_nnv.nnv25) AND g_nnv.nnv25 != 0 THEN
                       LET g_nnv.nnv26=g_nnv.nnv25 * g_nnv.nnv24
                       CALL cl_digcut(g_nnv.nnv26,g_azi04) RETURNING g_nnv.nnv26  #No.FUN-640142
                       DISPLAY BY NAME g_nnv.nnv26
                    END IF
                 END IF
              END IF
           END IF
 
        AFTER FIELD nnv26 #撥入本幣
            IF NOT cl_null(g_nnv.nnv26) THEN
               CALL cl_digcut(g_nnv.nnv26,g_azi04) RETURNING g_nnv.nnv26  #No.FUN-640142
               DISPLAY BY NAME g_nnv.nnv26   #No.FUN-640142
               IF g_nnv.nnv26 < 0 THEN
                   CALL cl_err(g_nnv.nnv26,'aim-391',1)
                   LET g_nnv.nnv26 = g_nnv_o.nnv26
                   DISPLAY BY NAME g_nnv.nnv26
                   NEXT FIELD nnv26
               END IF
            END IF
            LET g_nnv_o.nnv26 = g_nnv.nnv26
 
        BEFORE FIELD nnv27 #撥入科目
            IF cl_null(g_nnv.nnv27) THEN
                SELECT nmq22 INTO g_nnv.nnv27 FROM nmq_file
                 WHERE nmq00 = '0'
                DISPLAY BY NAME g_nnv.nnv27
            END IF
 
        AFTER FIELD nnv27 #撥入科目
            IF NOT cl_null(g_nnv.nnv27) THEN
                CALL t920_aag(g_nnv.nnv27,g_plant_in,'1') RETURNING g_aag02_2  #幣別  #FUN-980020  #No.TQC-A90063
                IF NOT cl_null(g_errno) THEN
#FUN-B20073 --begin--                
#                    CALL cl_err(g_nnv.nnv27,g_errno,1)
                     CALL cl_err(g_nnv.nnv27,g_errno,0)
#                    LET g_nnv.nnv27 = g_nnv_t.nnv27
                     CALL q_m_aag(FALSE,FALSE,g_plant_in,g_nnv.nnv27,'23',g_bookno1) 
                       RETURNING g_nnv.nnv27
#FUN-B20073 --end--
                    DISPLAY BY NAME g_nnv.nnv27
                    NEXT FIELD nnv27
                END IF
                DISPLAY g_aag02_2  TO FORMONLY.aag02_2
            END IF
            LET g_nnv_o.nnv27 = g_nnv.nnv27
 
        BEFORE FIELD nnv271
            IF cl_null(g_nnv.nnv271) THEN
                SELECT nmq221 INTO g_nnv.nnv271 FROM nmq_file
                 WHERE nmq00 = '0'
                DISPLAY BY NAME g_nnv.nnv271
            END IF
 
        AFTER FIELD nnv271
            IF NOT cl_null(g_nnv.nnv271) THEN
                CALL t920_aag(g_nnv.nnv271,g_plant_in,'2') RETURNING g_aag02_5    #FUN-980020  #No.TQC-A90063
                IF NOT cl_null(g_errno) THEN
#FUN-B20073 --begin--                
#                    CALL cl_err(g_nnv.nnv271,g_errno,1)
                     CALL cl_err(g_nnv.nnv271,g_errno,0)
#                    LET g_nnv.nnv271 = g_nnv_t.nnv271
             CALL q_m_aag(FALSE,FALSE,g_plant_in,g_nnv.nnv271,'23',g_bookno2)  
                       RETURNING g_nnv.nnv271
#FUN-B20073 --end--
                    DISPLAY BY NAME g_nnv.nnv271
                    NEXT FIELD nnv271
                END IF
                DISPLAY g_aag02_5  TO FORMONLY.aag02_5
            END IF
            LET g_nnv_o.nnv27 = g_nnv.nnv27
 
        AFTER FIELD nnv29
           IF NOT cl_null(g_nnv.nnv29) THEN
              CALL cl_digcut(g_nnv.nnv29,i_azi04) RETURNING g_nnv.nnv29
              DISPLAY BY NAME g_nnv.nnv29
           END IF   
 
        AFTER FIELD nnv30
           IF NOT cl_null(g_nnv.nnv30) THEN
              CALL cl_digcut(g_nnv.nnv30,g_azi04) RETURNING g_nnv.nnv30
              DISPLAY BY NAME g_nnv.nnv30
           END IF   
 
        AFTER FIELD nnv31
           IF NOT cl_null(g_nnv.nnv31) THEN
              CALL cl_digcut(g_nnv.nnv31,i_azi04) RETURNING g_nnv.nnv31
              DISPLAY BY NAME g_nnv.nnv31
           END IF   
 
        AFTER FIELD nnv32
           IF NOT cl_null(g_nnv.nnv32) THEN
              CALL cl_digcut(g_nnv.nnv32,g_azi04) RETURNING g_nnv.nnv32
              DISPLAY BY NAME g_nnv.nnv32
           END IF   
 
        BEFORE FIELD nnv41
           IF cl_null(g_nnv.nnv08) THEN
              CALL cl_err('','anm-989',0)
              NEXT FIELD nnv06
           END IF
 
        AFTER FIELD nnv41
           IF NOT cl_null(g_nnv.nnv41) THEN
              LET g_nma01 = NULL
              LET g_nnv41_nma02 = NULL
              #LET g_sql = "SELECT nma01,nma02 FROM ",g_dbs_out,"nma_file ",
              LET g_sql = "SELECT nma01,nma02 FROM ",cl_get_target_table(g_plant_out,'nma_file'), #FUN-A50102
                          " WHERE nma01 = '",g_nnv.nnv41,"'",
                          "   AND nma10 = '",g_nnv.nnv08,"'",
                          "   AND nma37 = '0'",
                          "   AND nmaacti = 'Y'"
 	          CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
              CALL cl_parse_qry_sql(g_sql,g_plant_out) RETURNING g_sql #FUN-A50102
              PREPARE nnv41_p1 FROM g_sql
              DECLARE nnv41_c1 CURSOR FOR nnv41_p1
              OPEN nnv41_c1
              FETCH nnv41_c1 INTO g_nma01,g_nnv41_nma02
              IF cl_null(g_nma01) THEN
                 CALL cl_err(g_nnv.nnv41,'aap-007',1)
                 NEXT FIELD nnv41
              ELSE
                 DISPLAY g_nnv41_nma02 TO FORMONLY.nnv41_nma02
              END IF
           END IF
           LET g_nnv_o.nnv41 = g_nnv.nnv41
 
        BEFORE FIELD nnv42
           IF cl_null(g_nnv.nnv23) THEN
              CALL cl_err('','anm-988',0)
              NEXT FIELD nnv21
           END IF
 
        AFTER FIELD nnv42
           IF NOT cl_null(g_nnv.nnv42) THEN
              LET g_nma01 = NULL
              LET g_nnv42_nma02 = NULL
              #LET g_sql = "SELECT nma01,nma02 FROM ",g_dbs_in,"nma_file ",
              LET g_sql = "SELECT nma01,nma02 FROM ",cl_get_target_table(g_plant_in,'nma_file'), #FUN-A50102
                          " WHERE nma01 = '",g_nnv.nnv42,"'",
                          "   AND nma10 = '",g_nnv.nnv23,"'",
                          "   AND nma37 = '0'",
                          "   AND nmaacti = 'Y'"
 	          CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
              CALL cl_parse_qry_sql(g_sql,g_plant_in) RETURNING g_sql #FUN-A50102
              PREPARE nnv42_p1 FROM g_sql
              DECLARE nnv42_c1 CURSOR FOR nnv42_p1
              OPEN nnv42_c1
              FETCH nnv42_c1 INTO g_nma01,g_nnv42_nma02
              IF cl_null(g_nma01) THEN
                 CALL cl_err(g_nnv.nnv42,'aap-007',1)
                 NEXT FIELD nnv42
              ELSE
                 DISPLAY g_nnv42_nma02 TO FORMONLY.nnv42_nma02
              END IF
           END IF
           LET g_nnv_o.nnv42 = g_nnv.nnv42
 
        AFTER FIELD nnvud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnvud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnvud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnvud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnvud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnvud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnvud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnvud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnvud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnvud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnvud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnvud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnvud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnvud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnvud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_nnv.nnvuser = s_get_data_owner("nnv_file") #FUN-C10039
           LET g_nnv.nnvgrup = s_get_data_group("nnv_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT  END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(nnv01)
                 LET g_t1 = s_get_doc_no(g_nnv.nnv01)
                 CALL q_nmy(FALSE,TRUE,g_t1,'H','ANM')  #TQC-670008
                      RETURNING g_t1 #票據性質:'H':集團間調撥
                 LET g_nnv.nnv01 = g_t1
                 DISPLAY BY NAME g_nnv.nnv01
                 NEXT FIELD nnv01
               WHEN INFIELD(nnv03) # 部門
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = g_nnv.nnv03
                  CALL cl_create_qry() RETURNING g_nnv.nnv03
                  DISPLAY BY NAME g_nnv.nnv03
                  NEXT FIELD nnv03
               WHEN INFIELD(nnv04) #現金變動碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nml"
                  LET g_qryparam.default1 = g_nnv.nnv04
                  CALL cl_create_qry() RETURNING g_nnv.nnv04
                  DISPLAY BY NAME g_nnv.nnv04
                  CALL t920_nnv04('d')
                  NEXT FIELD nnv04
               #==>撥出*****************************************
               WHEN INFIELD(nnv05) #撥出營運中心
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.default1 = g_nnv.nnv05
                  CALL cl_create_qry() RETURNING g_nnv.nnv05
                  DISPLAY BY NAME g_nnv.nnv05
                  NEXT FIELD nnv05
               WHEN INFIELD(nnv06) #撥出銀行代號
                  CALL cl_init_qry_var()
                  IF g_nmy.nmydmy6 = 'N' THEN  #No.FUN-690090
                     LET g_qryparam.form = "q_m_nma"
                  ELSE
                     LET g_qryparam.form = "q_m_nma2"
                  END IF
                  LET g_qryparam.default1 = g_nnv.nnv06
                  LET g_qryparam.arg2 = "23"    #No.MOD-640270
                  LET g_qryparam.plant = g_plant_out #No.FUN-980025 add
                  CALL cl_create_qry() RETURNING g_nnv.nnv06
                  DISPLAY BY NAME g_nnv.nnv06
                  NEXT FIELD nnv06
              WHEN INFIELD(nnv07) #撥出異動碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_m_nmc01"
                  LET g_qryparam.default1 = g_nnv.nnv07
                  LET g_qryparam.arg1 = '2'
                  LET g_qryparam.plant = g_plant_out #No.FUN-980025 add
                  CALL cl_create_qry() RETURNING g_nnv.nnv07
                  DISPLAY BY NAME g_nnv.nnv07
                  NEXT FIELD nnv07
               WHEN INFIELD(nnv08) #撥出幣別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi1"
                  LET g_qryparam.default1 = g_nnv.nnv08
                  LET g_qryparam.plant = g_plant_out #No.FUN-980025 add
                  CALL cl_create_qry() RETURNING g_nnv.nnv08
                  DISPLAY BY NAME g_nnv.nnv08
                  NEXT FIELD nnv08
               WHEN INFIELD(nnv09) #匯率
                    CALL s_rate(g_nnv.nnv08,g_nnv.nnv09) RETURNING g_nnv.nnv09
                    DISPLAY BY NAME g_nnv.nnv09
                    NEXT FIELD nnv09
               WHEN INFIELD(nnv12) #撥出科目
                  CALL s_get_bookno1(YEAR(g_nnv.nnv02),g_plant_out) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                  CALL q_m_aag(FALSE,TRUE,g_plant_out,g_nnv.nnv12,'23',g_bookno1)  #No.FUN-980025
                       RETURNING g_nnv.nnv12
                  DISPLAY BY NAME g_nnv.nnv12
                  NEXT FIELD nnv12
               WHEN INFIELD(nnv121)
                  CALL s_get_bookno1(YEAR(g_nnv.nnv02),g_plant_out) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                  CALL q_m_aag(FALSE,TRUE,g_plant_out,g_nnv.nnv121,'23',g_bookno2) #No.FUN-980025
                       RETURNING g_nnv.nnv121
                  DISPLAY BY NAME g_nnv.nnv121
                  NEXT FIELD nnv121
               #==>手續費**************************************
               WHEN INFIELD(nnv13) #手續費銀行代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_m_nma"
                  LET g_qryparam.default1 = g_nnv.nnv13
                  LET g_qryparam.arg2 = "23"    #No.MOD-640270
                  LET g_qryparam.plant = g_plant_out #No.FUN-980025 add
                  CALL cl_create_qry() RETURNING g_nnv.nnv13
                  DISPLAY BY NAME g_nnv.nnv13
                  NEXT FIELD nnv13
              WHEN INFIELD(nnv14) #手續費異動碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_m_nmc01"
                  LET g_qryparam.default1 = g_nnv.nnv14
                  LET g_qryparam.arg1 = '2'
                  LET g_qryparam.plant = g_plant_out #No.FUN-980025 add
                  CALL cl_create_qry() RETURNING g_nnv.nnv14
                  DISPLAY BY NAME g_nnv.nnv14
                  NEXT FIELD nnv14
               WHEN INFIELD(nnv15) #手續費幣別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi1"
                  LET g_qryparam.default1 = g_nnv.nnv15
                  LET g_qryparam.plant = g_plant_out #No.FUN-980025 add
                  CALL cl_create_qry() RETURNING g_nnv.nnv15
                  DISPLAY BY NAME g_nnv.nnv15
                  NEXT FIELD nnv15
               WHEN INFIELD(nnv16) #匯率
                    CALL s_rate(g_nnv.nnv15,g_nnv.nnv16) RETURNING g_nnv.nnv16
                    DISPLAY BY NAME g_nnv.nnv16
                    NEXT FIELD nnv16
               WHEN INFIELD(nnv19) #手續費科目
                  CALL s_get_bookno1(YEAR(g_nnv.nnv02),g_plant_out) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                  CALL q_m_aag(FALSE,TRUE,g_plant_out,g_nnv.nnv19,'23',g_bookno1)  #No.FUN-980025
                       RETURNING g_nnv.nnv19
                  DISPLAY BY NAME g_nnv.nnv19
                  NEXT FIELD nnv19
               WHEN INFIELD(nnv191)
                  CALL s_get_bookno1(YEAR(g_nnv.nnv02),g_plant_out) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
                  CALL q_m_aag(FALSE,TRUE,g_plant_out,g_nnv.nnv191,'23',g_bookno2) #No.FUN-980025
                       RETURNING g_nnv.nnv191
                  DISPLAY BY NAME g_nnv.nnv191
                  NEXT FIELD nnv191
               #==>撥入*****************************************
               WHEN INFIELD(nnv20) #撥入營運中心
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.default1 = g_nnv.nnv20
                  CALL cl_create_qry() RETURNING g_nnv.nnv20
                  DISPLAY BY NAME g_nnv.nnv20
                  NEXT FIELD nnv20
               WHEN INFIELD(nnv21) #撥入銀行代號
                  CALL cl_init_qry_var()
                  IF g_nmy.nmydmy6 = 'N' THEN  #No.FUN-690090
                     LET g_qryparam.form = "q_m_nma"
                  ELSE
                     LET g_qryparam.form = "q_m_nma2"
                  END IF
                  LET g_qryparam.default1 = g_nnv.nnv21
                  LET g_qryparam.arg2 = "23"    #No.MOD-640270
                  IF NOT cl_null(g_nnv.nnv08) THEN
                      LET g_qryparam.where    = " nma10 = '",g_nnv.nnv08,"'" 
                  END IF
                  LET g_qryparam.plant = g_plant_in #No.FUN-980025 add
                  CALL cl_create_qry() RETURNING g_nnv.nnv21
                  DISPLAY BY NAME g_nnv.nnv21
                  NEXT FIELD nnv21
              WHEN INFIELD(nnv22) #撥入異動碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_m_nmc01"
                  LET g_qryparam.default1 = g_nnv.nnv22
                  LET g_qryparam.arg1 = '1'   #No:640273
                  LET g_qryparam.plant = g_plant_in #No.FUN-980025 add
                  CALL cl_create_qry() RETURNING g_nnv.nnv22
                  DISPLAY BY NAME g_nnv.nnv22
                  NEXT FIELD nnv22
               WHEN INFIELD(nnv23) #撥入幣別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi1"
                  LET g_qryparam.default1 = g_nnv.nnv23
                  LET g_qryparam.plant = g_plant_in #No.FUN-980025 add
                  CALL cl_create_qry() RETURNING g_nnv.nnv23
                  DISPLAY BY NAME g_nnv.nnv23
                  NEXT FIELD nnv23
               WHEN INFIELD(nnv24) #匯率
                    CALL s_rate(g_nnv.nnv23,g_nnv.nnv24) RETURNING g_nnv.nnv24
                    DISPLAY BY NAME g_nnv.nnv24
                    NEXT FIELD nnv24
               WHEN INFIELD(nnv27) #撥入科目
                  CALL s_get_bookno1(YEAR(g_nnv.nnv02),g_plant_in) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
                  CALL q_m_aag(FALSE,TRUE,g_plant_in,g_nnv.nnv27,'23',g_bookno1) #No.FUN-980025
                       RETURNING g_nnv.nnv27
                  DISPLAY BY NAME g_nnv.nnv27
                  NEXT FIELD nnv27
               WHEN INFIELD(nnv271)
                  CALL s_get_bookno1(YEAR(g_nnv.nnv02),g_plant_in) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                  CALL q_m_aag(FALSE,TRUE,g_plant_in,g_nnv.nnv271,'23',g_bookno2)  #No.FUN-980025
                       RETURNING g_nnv.nnv271
                  DISPLAY BY NAME g_nnv.nnv271
                  NEXT FIELD nnv271
               WHEN INFIELD(nnv41)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma3"
                  LET g_qryparam.default1 = g_nnv.nnv41
                  LET g_qryparam.plant = g_plant_out #No.FUN-980025 add
                  LET g_qryparam.arg2 = g_nnv.nnv08
                  CALL cl_create_qry() RETURNING g_nnv.nnv41
                  DISPLAY BY NAME g_nnv.nnv41
                  NEXT FIELD nnv41
               WHEN INFIELD(nnv42)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma3"
                  LET g_qryparam.default1 = g_nnv.nnv42
                  LET g_qryparam.plant = g_plant_in #No.FUN-980025 add
                  LET g_qryparam.arg2 = g_nnv.nnv23
                  CALL cl_create_qry() RETURNING g_nnv.nnv42
                  DISPLAY BY NAME g_nnv.nnv42
                  NEXT FIELD nnv42
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
 
FUNCTION t920_nnv03(p_cmd)  #部門代號
    DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           l_gem02    LIKE gem_file.gem02,
           l_gemacti  LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem02,gemacti INTO l_gem02,l_gemacti
      FROM gem_file
     WHERE gem01 = g_nnv.nnv03
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
 
FUNCTION t920_nnv04(p_cmd) #現金變動碼
    DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
    DEFINE l_nmlacti LIKE nml_file.nmlacti
    DEFINE l_nml02   LIKE nml_file.nml02
    SELECT nmlacti,nml02 INTO l_nmlacti,l_nml02 FROM nml_file
     WHERE nml01 = g_nnv.nnv04
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = '100'
         WHEN l_nmlacti = 'N'     LET g_errno = '9028'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    DISPLAY l_nml02 TO nml02
END FUNCTION
 
FUNCTION t920_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t920_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        LET g_nnv.nnv01 = NULL   #MOD-660086 add
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t920_count
    FETCH t920_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t920_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nnv.nnv01,SQLCA.sqlcode,0)
        INITIALIZE g_nnv.* TO NULL
    ELSE
        CALL t920_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t920_fetch(p_flnnv)
    DEFINE
        p_flnnv         LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
        l_abso          LIKE type_file.num10   #No.FUN-680107 INTEGER
 
    CASE p_flnnv
        WHEN 'N' FETCH NEXT     t920_cs INTO g_nnv.nnv01
        WHEN 'P' FETCH PREVIOUS t920_cs INTO g_nnv.nnv01
        WHEN 'F' FETCH FIRST    t920_cs INTO g_nnv.nnv01
        WHEN 'L' FETCH LAST     t920_cs INTO g_nnv.nnv01
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
            FETCH ABSOLUTE g_jump t920_cs INTO g_nnv.nnv01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nnv.nnv01,SQLCA.sqlcode,0)
        INITIALIZE g_nnv.* TO NULL            #No.FUN-6B0079 add
        RETURN
    ELSE
       CASE p_flnnv
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_nnv.* FROM nnv_file            # 重讀DB,因TEMP有不被更新特性
     WHERE nnv01 = g_nnv.nnv01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","nnv_file",g_nnv.nnv01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
       INITIALIZE g_nnv.* TO NULL            #No.FUN-6B0079 add
    ELSE
       LET g_data_owner = g_nnv.nnvuser     #No.FUN-4C0063
       LET g_data_group = g_nnv.nnvgrup     #No.FUN-4C0063
       CALL t920_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t920_show()
DEFINE  l_nnv12    LIKE nnv_file.nnv12    #No.FUN-680107 VARCHAR(04)
DEFINE  l_buf      LIKE nmy_file.nmydesc  #No.FUN-680107 VARCHAR(30)
    LET g_nnv_t.* = g_nnv.*
    DISPLAY BY NAME g_nnv.nnvoriu,g_nnv.nnvorig,
        g_nnv.nnv01,g_nnv.nnv02,g_nnv.nnv03,g_nnv.nnv04,g_nnv.nnv05,
        g_nnv.nnv06,g_nnv.nnv07,g_nnv.nnv08,g_nnv.nnv09,g_nnv.nnv10,
        g_nnv.nnv11,g_nnv.nnv12,g_nnv.nnv13,g_nnv.nnv14,g_nnv.nnv15,
        g_nnv.nnv16,g_nnv.nnv17,g_nnv.nnv18,g_nnv.nnv19,g_nnv.nnv20,
        g_nnv.nnv21,g_nnv.nnv22,g_nnv.nnv23,g_nnv.nnv24,g_nnv.nnv25,
        g_nnv.nnv26,g_nnv.nnv27,g_nnv.nnv28,g_nnv.nnv29,g_nnv.nnv30,
        g_nnv.nnv31,g_nnv.nnv32,g_nnv.nnv33,g_nnv.nnv34,g_nnv.nnv35,
        g_nnv.nnv121,g_nnv.nnv191,g_nnv.nnv271,  #No.FUN-680088
        g_nnv.nnv41,g_nnv.nnv42,  #No.FUN-690090
        g_nnv.nnvuser,g_nnv.nnvgrup,g_nnv.nnvmodu,g_nnv.nnvdate,g_nnv.nnvacti,g_nnv.nnvconf
       ,g_nnv.nnvud01,g_nnv.nnvud02,g_nnv.nnvud03,g_nnv.nnvud04,
        g_nnv.nnvud05,g_nnv.nnvud06,g_nnv.nnvud07,g_nnv.nnvud08,
        g_nnv.nnvud09,g_nnv.nnvud10,g_nnv.nnvud11,g_nnv.nnvud12,
        g_nnv.nnvud13,g_nnv.nnvud14,g_nnv.nnvud15 
        LET l_buf = s_get_doc_no(g_nnv.nnv01)
        SELECT nmydesc INTO l_buf FROM nmy_file
         WHERE nmyslip=l_buf
        DISPLAY l_buf TO FORMONLY.nmydesc
        CALL t920_nnv03('d')
        CALL t920_nnv04('d')
 
        CALL t920_plantnam('d','1',g_nnv.nnv05)
        #CALL t920_aza17(g_dbs_out) RETURNING g_aza17_out
        CALL t920_aza17(g_plant_out) RETURNING g_aza17_out #FUN-A50102
        #CALL t920_nma01('d','1',g_dbs_out,g_nnv.nnv06)
        CALL t920_nma01('d','1',g_plant_out,g_nnv.nnv06)  #FUN-A50102
        #CALL t920_nmc01('d','1',g_dbs_out,g_nnv.nnv07,'2')
        CALL t920_nmc01('d','1',g_plant_out,g_nnv.nnv07,'2') #FUN-A50102
        #CALL t920_azi01('d','1',g_dbs_out,g_nnv.nnv08)
        CALL t920_azi01('d','1',g_plant_out,g_nnv.nnv08)   #FUN-A50102
        CALL t920_aag(g_nnv.nnv12,g_plant_curr,'1') RETURNING g_aag02_1  #FUN-980020  #No.TQC-A90063
        DISPLAY g_aag02_1  TO FORMONLY.aag02_1
        IF g_aza.aza63 = 'Y' THEN
           CALL t920_aag(g_nnv.nnv121,g_plant_curr,'2') RETURNING g_aag02_4   #FUN-980020  #No.TQC-A90063
           DISPLAY g_aag02_4  TO FORMONLY.aag02_4
        END IF
 
        #CALL t920_nma01('d','3',g_dbs_out,g_nnv.nnv13)
        CALL t920_nma01('d','3',g_plant_out,g_nnv.nnv13)   #FUN-A50102
        #CALL t920_nmc01('d','3',g_dbs_out,g_nnv.nnv14,'2')
        CALL t920_nmc01('d','3',g_plant_out,g_nnv.nnv14,'2') #FUN-A50102
        #CALL t920_azi01('d','3',g_dbs_out,g_nnv.nnv15)  #幣別
        CALL t920_azi01('d','3',g_plant_out,g_nnv.nnv15)    #FUN-A50102
        CALL t920_aag(g_nnv.nnv19,g_plant_out,'1') RETURNING g_aag02_3     #FUN-980020  #No.TQC-A90063
        DISPLAY g_aag02_3  TO FORMONLY.aag02_3
        IF g_aza.aza63 = 'Y' THEN
           CALL t920_aag(g_nnv.nnv191,g_plant_out,'2') RETURNING g_aag02_6  #FUN-980020  #No.TQC-A90063
           DISPLAY g_aag02_6  TO FORMONLY.aag02_6
        END IF
 
        CALL t920_plantnam('d','2',g_nnv.nnv20)
        #CALL t920_aza17(g_dbs_in) RETURNING g_aza17_in
        CALL t920_aza17(g_plant_in) RETURNING g_aza17_in  #FUN-A50102
        #CALL t920_nma01('d','2',g_dbs_in,g_nnv.nnv21)
        CALL t920_nma01('d','2',g_plant_in,g_nnv.nnv21)  #FUN-A50102
        #CALL t920_nmc01('d','2',g_dbs_in,g_nnv.nnv22,'1')   #No.MOD-640273
        CALL t920_nmc01('d','2',g_plant_in,g_nnv.nnv22,'1')  #FUN-A50102
        #CALL t920_azi01('d','2',g_dbs_in,g_nnv.nnv23)  #幣別
        CALL t920_azi01('d','2',g_plant_in,g_nnv.nnv23)    #FUN-A50102
        CALL t920_aag(g_nnv.nnv27,g_plant_in,'1') RETURNING g_aag02_2       #FUN-980020  #No.TQC-A90063
        DISPLAY g_aag02_2  TO FORMONLY.aag02_2
        IF g_aza.aza63 = 'Y' THEN
           CALL t920_aag(g_nnv.nnv271,g_plant_in,'2') RETURNING g_aag02_5    #No.TQC-A90063
           DISPLAY g_aag02_5  TO FORMONLY.aag02_5
        END IF
        LET g_nnv41_nma02 = NULL
        LET g_nnv42_nma02 = NULL
        #LET g_sql = "SELECT nma02 FROM ",g_dbs_out,"nma_file ",
        LET g_sql = "SELECT nma02 FROM ",cl_get_target_table(g_plant_out,'nma_file'), #FUN-A50102
                    " WHERE nma01 = '",g_nnv.nnv41,"'",
                    "   AND nma10 = '",g_nnv.nnv08,"'",
                    "   AND nma37 = '0'",
                    "   AND nmaacti = 'Y'"
 	    CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        CALL cl_parse_qry_sql(g_sql,g_plant_out) RETURNING g_sql #FUN-A50102
        PREPARE nnv41_p2 FROM g_sql
        DECLARE nnv41_c2 CURSOR FOR nnv41_p2
        OPEN nnv41_c2
        FETCH nnv41_c2 INTO g_nnv41_nma02
        DISPLAY g_nnv41_nma02 TO FORMONLY.nnv41_nma02
 
        #LET g_sql = "SELECT nma02 FROM ",g_dbs_in,"nma_file ",
        LET g_sql = "SELECT nma02 FROM ",cl_get_target_table(g_plant_in,'nma_file'), #FUN-A50102
                    " WHERE nma01 = '",g_nnv.nnv42,"'",
                    "   AND nma10 = '",g_nnv.nnv23,"'",
                    "   AND nma37 = '0'",
                    "   AND nmaacti = 'Y'"
 	    CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        CALL cl_parse_qry_sql(g_sql,g_plant_in) RETURNING g_sql #FUN-A50102
        PREPARE nnv42_p2 FROM g_sql
        DECLARE nnv42_c2 CURSOR FOR nnv42_p2
        OPEN nnv42_c2
        FETCH nnv42_c2 INTO g_nnv42_nma02
        DISPLAY g_nnv42_nma02 TO FORMONLY.nnv42_nma02
 
        CALL t920_set_entry_a()       
        CALL t920_set_no_entry_a()    
        CALL t920_no_required_a()   
        CALL t920_required_a()        
 
    IF g_nnv.nnvconf = 'X' THEN
       LET g_void = 'Y'
    ELSE
       LET g_void = 'N'
    END IF
    CALL cl_set_field_pic(g_nnv.nnvconf,"","","",g_void,"")
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t920_u()
    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_nnv.* FROM nnv_file WHERE nnv01 = g_nnv.nnv01
    IF g_nnv.nnvconf='Y' THEN CALL cl_err('','apm-267',1) RETURN END IF
    IF g_nnv.nnvconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_nnv.nnv01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_nnv01_t = g_nnv.nnv01
    LET g_nnv03_t = g_nnv.nnv03
    LET g_nnv04_t = g_nnv.nnv04
    LET g_nnv_o.*=g_nnv.*
    LET g_success = 'Y'
    BEGIN WORK
 
    OPEN t920_cl USING g_nnv.nnv01
    IF STATUS THEN
       CALL cl_err("OPEN t920_cl:", STATUS, 1)
       CLOSE t920_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t920_cl INTO g_nnv.*               # 對DB鎖定
    IF STATUS THEN CALL cl_err(g_nnv.nnv01,STATUS,0) RETURN END IF
    LET g_nnv.nnvmodu=g_user                     #修改者
    LET g_nnv.nnvdate = g_today                  #修改日期
 
    CALL t920_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t920_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_success = 'N'
            LET g_nnv.*=g_nnv_t.*
            CALL t920_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE nnv_file SET nnv_file.* = g_nnv.*    # 更新DB
            WHERE nnv01 = g_nnv01_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL cl_err3("upd","nnv_file",g_nnv01_t,"",SQLCA.sqlcode,"","(t920_u:nnv)",1)  #No.FUN-660148
            CONTINUE WHILE
        END IF
        UPDATE nmf_file SET nmf01=g_nnv.nnv01 WHERE nmf01=g_nnv_t.nnv01
        EXIT WHILE
    END WHILE
    CLOSE t920_cl
       IF g_success = 'Y'
          THEN CALL cl_cmmsg(1) COMMIT WORK
               CALL cl_flow_notify(g_nnv.nnv01,'U')
          ELSE CALL cl_rbmsg(1) ROLLBACK WORK
       END IF
END FUNCTION
 
FUNCTION t920_c()
    DEFINE
        l_chr   LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
    INITIALIZE g_nnz.* TO NULL
    IF s_shut(0) THEN RETURN END IF
    IF g_nnv.nnv01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_nnv.* FROM nnv_file WHERE nnv01 = g_nnv.nnv01
    IF g_nnv.nnv02 IS NULL THEN
       RETURN
    END IF
    IF g_nnv.nnvconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF NOT cl_confirm('axr-152') THEN RETURN END IF
    SELECT * INTO g_nnv.* FROM nnv_file WHERE nnv01 = g_nnv.nnv01
    LET g_success = 'Y'
    BEGIN WORK
    UPDATE nnv_file SET nnv02 = '' WHERE nnv01 = g_nnv.nnv01
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       LET g_success = 'N'
       CALL cl_err3("upd","nnv_file",g_nnv.nnv01,"",SQLCA.sqlcode,"","(t920_u:nmf)",1)  #No.FUN-660148
    END IF
    LET g_nnz.nnzuser = g_user
    LET g_nnz.nnzgrup = g_grup
    LET g_nnz.nnzmodu = ' '
    LET g_nnz.nnzdate = g_today
    LET g_nnz.nnzoriu = g_user      #No.FUN-980030 10/01/04
    LET g_nnz.nnzorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO nnz_file VALUES(g_nnz.*)
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","nnz_file",g_nnz.nnz01,g_nnz.nnz02,SQLCA.sqlcode,"","t150_ins_nnz",1)  #No.FUN-660148
        LET g_success = 'N'
    END IF
    LET g_nnv.nnv02 = ''
    CALL t920_show()
    IF g_success = 'Y' THEN
        CALL cl_cmmsg(1)
        COMMIT WORK
    ELSE
        CALL cl_rbmsg(1)
        ROLLBACK WORK
    END IF
END FUNCTION
 
#FUNCTION t920_x() #FUN-D20035 mark
FUNCTION t920_x(p_type) #FUN-D20035 add

    DEFINE
        l_begin   LIKE nmw_file.nmw04,
        l_end     LIKE nmw_file.nmw05,
        max_nnv02 LIKE nnv_file.nnv02,
        l_chr     LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
    DEFINE p_type    LIKE type_file.chr1  #FUN-D20035 add 
    IF s_shut(0) THEN RETURN END IF
    IF g_nnv.nnv01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_nnv.* FROM nnv_file WHERE nnv01 = g_nnv.nnv01
    IF g_nnv.nnvconf='Y' THEN CALL cl_err('','apm-267',1)  RETURN END IF
    #FUN-D20035---begin 
    IF p_type = 1 THEN 
       IF g_nnv.nnvconf='X' THEN RETURN END IF
    ELSE
       IF g_nnv.nnvconf<>'X' THEN RETURN END IF
    END IF 
    #FUN-D20035---end     
    LET g_success = 'Y'
    BEGIN WORK
 
    OPEN t920_cl USING g_nnv.nnv01
    IF STATUS THEN
       CALL cl_err("OPEN t920_cl:", STATUS, 1)
       CLOSE t920_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t920_cl INTO g_nnv.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nnv.nnv01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t920_show()
    IF cl_void(0,0,g_nnv.nnvconf) THEN
       IF g_nnv.nnvconf='N' THEN    #切換為作廢
          LET g_nnv.nnvconf='X'
       ELSE                       #取消作廢
          LET g_nnv.nnvconf='N'
       END IF
       UPDATE nnv_file
          SET nnvconf = g_nnv.nnvconf
        WHERE nnv01 = g_nnv.nnv01
       IF STATUS THEN
           CALL cl_err3("upd","nnv_file",g_nnv.nnv01,"",STATUS,"","",1)  #No.FUN-660148
           LET g_success='N'
       END IF
       IF SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err('','aap-161',0)
           LET g_success='N'
       END IF
    END IF
    SELECT nnvconf INTO g_nnv.nnvconf FROM nnv_file
     WHERE nnv01 = g_nnv.nnv01
    DISPLAY BY NAME g_nnv.nnvconf
    CLOSE t920_cl
    IF g_success = 'Y' THEN
        CALL cl_cmmsg(1)
        COMMIT WORK
        CALL cl_flow_notify(g_nnv.nnv01,'V')
    ELSE
        CALL cl_rbmsg(1)
        ROLLBACK WORK
    END IF
END FUNCTION
 
FUNCTION t920_r()
    DEFINE l_chr    LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           g_ala01  LIKE ala_file.ala01,    #No.MOD-530818
           l_ala931 LIKE ala_file.ala931    #No.MOD-530818
 
    IF s_shut(0) THEN RETURN END IF
    IF g_nnv.nnv01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    SELECT * INTO g_nnv.* FROM nnv_file WHERE nnv01 = g_nnv.nnv01
    IF g_nnv.nnvconf='Y' THEN CALL cl_err('','apm-267',1)  RETURN END IF
    IF g_nnv.nnvconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
    LET g_success = 'Y'
    BEGIN WORK
    OPEN t920_cl USING g_nnv.nnv01
    IF STATUS THEN
       CALL cl_err("OPEN t920_cl:", STATUS, 1)
       CLOSE t920_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t920_cl INTO g_nnv.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nnv.nnv01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t920_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "nnv01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_nnv.nnv01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
         DELETE FROM nnv_file
          WHERE nnv01 = g_nnv.nnv01 #PHYSICAL DELETE
           IF SQLCA.sqlcode THEN
              LET g_success = 'N'
              CALL cl_err3("del","nnv_file",g_nnv.nnv01,"",SQLCA.sqlcode,"","(t920_r:delete nnv)",1)  #No.FUN-660148
           END IF
         #CALL t920_delete(g_nnv.nnv01,g_dbs_in)
         #CALL t920_delete(g_nnv.nnv01,g_dbs_out)
         CALL t920_delete(g_nnv.nnv01,g_plant_in)    #FUN-A50102
         CALL t920_delete(g_nnv.nnv01,g_plant_out)   #FUN-A50102
    END IF
    CLOSE t920_cl
    IF g_success = 'Y' THEN
       CALL cl_cmmsg(1)
       COMMIT WORK
       CALL cl_flow_notify(g_nnv.nnv01,'D')
       OPEN t920_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE t920_cs
          CLOSE t920_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH t920_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t920_cs
          CLOSE t920_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t920_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t920_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t920_fetch('/')
       END IF
    ELSE
       CALL cl_rbmsg(1)
       ROLLBACK WORK
    END IF
END FUNCTION
 
#FUNCTION t920_delete(p_trno,p_dbs)
FUNCTION t920_delete(p_trno,l_plant)  #FUN-A50102
 DEFINE p_trno    LIKE nnv_file.nnv01
 #DEFINE p_dbs     LIKE type_file.chr21
 DEFINE l_plant   LIKE type_file.chr21 #FUN-A50102
 DEFINE l_n       LIKE type_file.num5
 DEFINE 
      l_sql        STRING       #NO.FUN-910082
 
      LET l_sql =
                 #"SELECT COUNT(*) FROM ",p_dbs CLIPPED,"npp_file",
                 "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'npp_file'), #FUN-A50102
                 " WHERE nppsys='NM' ",
                 "   AND npp00 =21 ",
                 "   AND npp01 ='",p_trno,"'",
                 "   AND npp011=9 " #集團資金調撥所產生的異動序號故意為9
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
      PREPARE npp_cnt_p1 FROM l_sql
      DECLARE npp_cnt_c1 CURSOR FOR npp_cnt_p1
      OPEN npp_cnt_c1
      FETCH npp_cnt_c1 INTO l_n
      IF l_n > 0 THEN
          LET l_sql =
                     #"DELETE FROM ",p_dbs CLIPPED,"npp_file",
                     "DELETE FROM ",cl_get_target_table(l_plant,'npp_file'), #FUN-A50102
                     " WHERE nppsys='NM' ",
                     "   AND npp00 =21 ",
                     "   AND npp01 ='",p_trno,"'",
                     "   AND npp011=9 " #集團資金調撥所產生的異動序號故意為9
 	  CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
          PREPARE npp_del_p1 FROM l_sql
          EXECUTE npp_del_p1
          IF SQLCA.sqlcode THEN
             LET g_success = 'N'
             CALL cl_err('delete npp',SQLCA.sqlcode,0)
          END IF
      END IF
 
      LET l_sql =
                 #"SELECT COUNT(*) FROM ",p_dbs CLIPPED,"npq_file",
                 "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'npq_file'), #FUN-A50102
                 " WHERE npqsys='NM' ",
                 "   AND npq00 =21 ",
                 "   AND npq01 ='",p_trno,"'",
                 "   AND npq011=9 " #集團資金調撥所產生的異動序號故意為9
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
      PREPARE npq_cnt_p1 FROM l_sql
      DECLARE npq_cnt_c1 CURSOR FOR npq_cnt_p1
      OPEN npq_cnt_c1
      FETCH npq_cnt_c1 INTO l_n
      IF l_n > 0 THEN
          LET l_sql =
                     #"DELETE FROM ",p_dbs CLIPPED,"npq_file",
                     "DELETE FROM ",cl_get_target_table(l_plant,'npq_file'), #FUN-A50102
                     " WHERE npqsys='NM' ",
                     "   AND npq00 =21 ",
                     "   AND npq01 ='",p_trno,"'",
                     "   AND npq011=9 " #集團資金調撥所產生的異動序號故意為9
 	  CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
          PREPARE npq_del_p1 FROM l_sql
          EXECUTE npq_del_p1
          IF SQLCA.sqlcode THEN
             LET g_success = 'N'
             CALL cl_err('delete npq',SQLCA.sqlcode,0)
          END IF
      END IF
 
      #FUN-B40056--add--str--
      LET l_n = 0   
      LET l_sql ="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'tic_file'),
                 " WHERE tic04 ='",p_trno,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
      PREPARE tic_cnt_p1 FROM l_sql
      DECLARE tic_cnt_c1 CURSOR FOR tic_cnt_p1
      OPEN tic_cnt_c1
      FETCH tic_cnt_c1 INTO l_n
      IF l_n > 0 THEN
          LET l_sql ="DELETE FROM ",cl_get_target_table(l_plant,'tic_file'),
                     " WHERE tic04 ='",p_trno,"'"
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
          CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
          PREPARE tic_del_p1 FROM l_sql
          EXECUTE tic_del_p1
          IF SQLCA.sqlcode THEN
             LET g_success = 'N'
             CALL cl_err('delete tic',SQLCA.sqlcode,0)
          END IF
      END IF
      #FUN-B40056--add--end-- 
END FUNCTION
 
FUNCTION t920_plantnam(p_cmd,p_code,p_plant)
    DEFINE p_cmd   LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           p_code  LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(01)
           p_plant LIKE nnv_file.nnv05,
           l_azp01 LIKE azp_file.azp01,
           l_azp02 LIKE azp_file.azp02,
           l_azp03 LIKE azp_file.azp03
 
    LET g_errno = ' '
 	SELECT azp01,azp02,azp03 INTO l_azp01,l_azp02,l_azp03  FROM azp_file
         WHERE azp01 = p_plant
 
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg9142'
                            LET l_azp02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       CASE p_code
           WHEN '1' #撥出
                    DISPLAY l_azp02 TO FORMONLY.azp02_1
                    LET g_azp01_out = l_azp01
                    LET g_azp03_out = l_azp03
                    LET g_plant_out = l_azp01     #FUN-980020
                    LET g_dbs_out = s_dbstring(l_azp03) CLIPPED
           WHEN '2' #撥入
                    DISPLAY l_azp02 TO FORMONLY.azp02_2
                    LET g_azp01_in = l_azp01
                    LET g_azp03_in = l_azp03
                    LET g_plant_in = l_azp01      #FUN-980020
                    LET g_dbs_in = s_dbstring(l_azp03) CLIPPED
           WHEN '3' #現在
                    LET g_azp01_curr = l_azp01
                    LET g_azp03_curr = l_azp03
                    LET g_plant_curr = l_azp01    #FUN-980020
                    LET g_dbs_curr = s_dbstring(l_azp03) CLIPPED
       END CASE
    END IF
END FUNCTION
 
#FUNCTION t920_nma01(p_cmd,p_code,p_dbs,p_nma01)  #銀行代號
FUNCTION t920_nma01(p_cmd,p_code,l_plant,p_nma01)  #FUN-A50102
    DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           p_code    LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(01)
           p_nma01   LIKE nma_file.nma01,
           #p_dbs     LIKE type_file.chr21,   #No.FUN-680107 VARCHAR(21)
           l_plant   LIKE type_file.chr21,   #FUN-A50102
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
         WHEN l_nma28 = "1" 
           IF  g_aza.aza26!='2' THEN LET g_errno = "aap-804"  END IF      #FUN-C80018
         WHEN l_nmaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) THEN
        CASE p_code
            WHEN '1' #撥出銀行
                  IF p_cmd <> 'd' THEN
                      LET g_nnv.nnv08 = l_nma10   #幣別
                      IF g_nnv.nnv08 = g_aza17_out THEN
                         CALL cl_set_comp_entry("nnv09",FALSE)
                         LET g_nnv.nnv09 = 1
                      ELSE
                         CALL cl_set_comp_entry("nnv09",TRUE)
                         CALL s_currm(g_nnv.nnv08,g_nnv.nnv02,'S',g_plant_out) #FUN-980020
                              RETURNING g_nnv.nnv09
                      END IF
                      DISPLAY BY NAME g_nnv.nnv08,g_nnv.nnv09
                  END IF
                  SELECT azi04 INTO o_azi04 FROM azi_file
                   WHERE azi01 = g_nnv.nnv08
                  DISPLAY l_nma02 TO FORMONLY.nma02_1
            WHEN '2' #撥入銀行
                  IF p_cmd <> 'd' THEN
                      IF l_nma10 <> g_nnv.nnv08 THEN
                          #撥入銀行的存款幣別需=撥出銀行的存款幣別
                          LET g_errno = 'anm-924'
                      ELSE
                         LET g_nnv.nnv23 = l_nma10   #幣別
                         IF g_nnv.nnv23 = g_aza17_in THEN
                            CALL cl_set_comp_entry("nnv24",FALSE)
                            LET g_nnv.nnv24 = 1
                         ELSE
                            CALL cl_set_comp_entry("nnv24",TRUE)
                            CALL s_currm(g_nnv.nnv23,g_nnv.nnv02,'S',g_plant_in)             #FUN-980020 
                                 RETURNING g_nnv.nnv24
                         END IF
                          DISPLAY BY NAME g_nnv.nnv23,g_nnv.nnv24
                      END IF
                  END IF
                  SELECT azi04 INTO i_azi04 FROM azi_file
                   WHERE azi01 = g_nnv.nnv23
                  DISPLAY l_nma02 TO FORMONLY.nma02_2
            WHEN '3' #手續費銀行
                  IF p_cmd <> 'd' THEN
                      LET g_nnv.nnv15 = l_nma10   #幣別
                      IF g_nnv.nnv15 = g_aza17_out THEN
                         CALL cl_set_comp_entry("nnv16",FALSE)
                         LET g_nnv.nnv16 = 1
                      ELSE
                         CALL cl_set_comp_entry("nnv16",TRUE)
                         CALL s_currm(g_nnv.nnv15,g_nnv.nnv02,'S',g_plant_out)   #FUN-980020
                              RETURNING g_nnv.nnv16
                      END IF
                      DISPLAY BY NAME g_nnv.nnv15,g_nnv.nnv16
                  END IF
                  SELECT azi04 INTO c_azi04 FROM azi_file
                   WHERE azi01 = g_nnv.nnv15
                  DISPLAY l_nma02 TO FORMONLY.nma02_3
        END CASE
    END IF
 
END FUNCTION
 
#FUNCTION t920_nmc01(p_cmd,p_code,p_dbs,p_nmc01,p_nmc03)  #銀行存提異動碼
FUNCTION t920_nmc01(p_cmd,p_code,l_plant,p_nmc01,p_nmc03)  #FUN-A50102
    DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           p_code    LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(01)
           p_nmc01   LIKE nmc_file.nmc01,
           p_nmc03   LIKE nmc_file.nmc03,
           #p_dbs     LIKE type_file.chr21,   #No.FUN-680107 VARCHAR(21)
           l_plant   LIKE type_file.chr21,    #FUN-A50102
           l_sql     LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(500)
           l_nmc02   LIKE nmc_file.nmc02,
           l_nmc03   LIKE nmc_file.nmc03,
           l_nmcacti LIKE nmc_file.nmcacti
 
    LET g_errno = ' '
    LET l_sql=
              #"SELECT nmc02,nmc03,nmcacti FROM ",p_dbs CLIPPED,"nmc_file",
              "SELECT nmc02,nmc03,nmcacti FROM ",cl_get_target_table(l_plant,'nmc_file'), #FUN-A50102
              " WHERE nmc01 = '",p_nmc01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
    PREPARE nmc_pre FROM l_sql
    DECLARE nmc_cur CURSOR FOR nmc_pre
    OPEN nmc_cur
    FETCH nmc_cur INTO l_nmc02,l_nmc03,l_nmcacti
    CASE WHEN SQLCA.SQLCODE = 100
                            LET g_errno = 'anm-024' #無此異動碼資料，請重新輸入
                            LET l_nmc03 = NULL
                            LET l_nmcacti = NULL
         WHEN l_nmc03 <> p_nmc03 LET g_errno = "anm-019"   #No.MOD-640210
         WHEN l_nmcacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
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
 
#FUNCTION t920_azi01(p_cmd,p_code,p_dbs,p_azi01)  #幣別
FUNCTION t920_azi01(p_cmd,p_code,l_plant,p_azi01)  #FUN-A50102
    DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           p_code    LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           #p_dbs     LIKE type_file.chr21,   #No.FUN-680107 VARCHAR(21)
           l_plant   LIKE type_file.chr21,   #FUN-A50102
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
 
#FUNCTION t920_aza17(p_dbs)  #本幣幣別
FUNCTION t920_aza17(l_plant)  #本幣幣別  #FUN-A50102
    DEFINE #p_dbs   LIKE type_file.chr21,   #No.FUN-680107 VARCHAR(21)
           l_plant LIKE type_file.chr21,   #FUN-A50102
           l_sql   LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(500)
           l_aza17 LIKE aza_file.aza17
 
    LET g_errno = ' '
    LET l_sql=
              #"SELECT aza17 FROM ",p_dbs CLIPPED,"aza_file",
              "SELECT aza17 FROM ",cl_get_target_table(l_plant,'aza_file'), #FUN-A50102
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
 
FUNCTION t920_aag(p_key,p_plant,p_flag)  #No.TQC-A90063
DEFINE
      l_sql      LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(500)
      l_aagacti  LIKE aag_file.aagacti,
      l_aag02    LIKE aag_file.aag02,
      l_aag07    LIKE aag_file.aag07,
      l_aag03    LIKE aag_file.aag03,
      l_aag09    LIKE aag_file.aag09,
      p_key      LIKE aag_file.aag01,
      p_dbs      LIKE type_file.chr21    #No.FUN-680107 VARCHAR(21)
DEFINE  l_flag1        LIKE type_file.chr1       #No.FUN-730032
DEFINE  l_bookno1      LIKE aza_file.aza81       #No.FUN-730032
DEFINE  l_bookno2      LIKE aza_file.aza82       #No.FUN-730032
DEFINE  p_plant        LIKE type_file.chr10      #FUN-980020
DEFINE  p_flag         LIKE type_file.chr1       #No.TQC-A90063                 
DEFINE  l_bookno3      LIKE aag_file.aag00       #No.TQC-A90063
 
   IF cl_null(p_plant)  THEN
      LET p_dbs = NULL
   ELSE
      LET g_plant_new = p_plant
      CALL s_getdbs()
      LET p_dbs = g_dbs_new
   END IF
 
   CALL s_get_bookno1(YEAR(g_nnv.nnv02),p_plant) RETURNING l_flag1,l_bookno1,l_bookno2   #FUN-980020
   IF l_flag1 = '1' THEN
       LET g_errno = 'aoo-081'
       RETURN ' '
   END IF

    #No.TQC-A90063  --Begin                                                     
    IF p_flag = '1' THEN                                                        
       LET l_bookno3 = l_bookno1                                                
    ELSE                                                                        
       LET l_bookno3 = l_bookno2                                                
    END IF                                                                      
    #No.TQC-A90063  --End 
 
    LET g_errno = " "
    LET l_sql =
               #"SELECT aag02,aagacti,aag07,aag03,aag09 FROM ",p_dbs CLIPPED,"aag_file",
               "SELECT aag02,aagacti,aag07,aag03,aag09 FROM ",cl_get_target_table(p_plant,'aag_file'), #FUN-A50102
               " WHERE aag01 = '",p_key,"'",
#              "   AND aag00 = '",l_bookno1,"'"  #No.FUN-730032  #No.TQC-A90063
               "   AND aag00 = '",l_bookno3,"'"  #No.FUN-730032  #No.TQC-A90063
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
 
FUNCTION t920_g_gl(p_trno,p_code,p_dbs,p_npptype,p_azp01)   #No.FUN-680088 add p_npptype
   DEFINE p_trno             LIKE nnv_file.nnv01
   DEFINE l_err_cd           LIKE ze_file.ze01
   DEFINE p_npptype          LIKE npp_file.npptype  #No.FUN-680088
   DEFINE p_code             LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1) #1:撥出, 2:撥入
   DEFINE p_dbs              LIKE type_file.chr21   #No.FUN-680107 VARCHAR(21)
   DEFINE l_buf              LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(70)
   DEFINE l_n                LIKE type_file.num5,   #No.FUN-680107 SMALLINT
          l_t                LIKE nmy_file.nmyslip, #No.FUN-680107 VARCHAR(05)
          l_nmydmy3          LIKE nmy_file.nmydmy3,
          l_sql              LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(500)
   DEFINE l_legal            LIKE npp_file.npplegal #FUN-980005 
   DEFINE p_azp01            LIKE azp_file.azp01    #FUN-980005 
 
   SELECT * INTO g_nnv.*
     FROM nnv_file
    WHERE nnv01 = g_nnv.nnv01
   IF p_trno IS NULL THEN
       LET g_success = 'N'
       RETURN
   END IF
   IF g_nnv.nnvconf='Y' THEN
       LET g_success = 'N'
       CALL cl_err(g_nnv.nnv01,'anm-232',1)
       RETURN
   END IF
   IF g_nnv.nnvconf='X' THEN
       LET g_success = 'N'
       CALL cl_err(g_nnv.nnv01,'apm-267',1)
       RETURN
   END IF
   IF NOT cl_null(g_nnv.nnv34) OR NOT cl_null(g_nnv.nnv35) THEN
       #該分錄底稿已拋轉總帳系統, 不允許重新產生 !
       LET g_success = 'N'
       CALL cl_err(g_nnv.nnv01,'aap-122',1)
       RETURN
   END IF
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p FROM g_sql
   EXECUTE nmz10_p INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_nnv.nnv02 <= g_nmz.nmz10 THEN #no.5261
       LET g_success = 'N'
       CALL cl_err(g_nnv.nnv01,'aap-176',1)
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
       CALL cl_err(g_nnv.nnv01,'anm-936',1)
       RETURN
   END IF
   IF p_npptype = '0' THEN  #No.FUN-680088 
      LET l_sql =
                 #"SELECT COUNT(*) FROM ",p_dbs CLIPPED,"npq_file",
                 "SELECT COUNT(*) FROM ",cl_get_target_table(p_azp01,'npq_file'), #FUN-A50102
                 " WHERE npqsys='NM' ",
                 "   AND npq00 =21 ",
                 "   AND npq01 ='",p_trno,"'",
                 "   AND npq011=9 " #集團資金調撥所產生的異動序號故意為9
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
          #FUN-B40056--add--str--
          LET l_n = 0
          LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_azp01,'tic_file'),
                      " WHERE tic04=  '",p_trno,"'" 
 	      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
          CALL cl_parse_qry_sql(l_sql,p_azp01) RETURNING l_sql 
          PREPARE tic_cnt_pre FROM l_sql
          DECLARE tic_cnt_cur CURSOR FOR tic_cnt_pre
          OPEN tic_cnt_cur
          FETCH tic_cnt_cur INTO l_n
          IF l_n > 0 THEN
             IF NOT cl_confirm('sub-533') THEN
                LET g_success = 'N' 
                RETURN
             END IF
          END IF

          LET l_sql ="DELETE FROM ",cl_get_target_table(p_azp01,'tic_file'), 
                     " WHERE tic04 = '",p_trno,"'"
 	      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
          CALL cl_parse_qry_sql(l_sql,p_azp01) RETURNING l_sql 
          PREPARE tic_del_pre FROM l_sql
          EXECUTE tic_del_pre
          #FUN-B40056--add--end--
          LET l_sql =
                     #"DELETE FROM ",p_dbs CLIPPED,"npq_file",
                     "DELETE FROM ",cl_get_target_table(p_azp01,'npq_file'), #FUN-A50102
                     " WHERE npqsys='NM' ",
                     "   AND npq00 =21 ",
                     "   AND npq01 ='",p_trno,"'",
                     "   AND npq011=9 " #集團資金調撥所產生的異動序號故意為9
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_azp01) RETURNING l_sql #FUN-A50102
          PREPARE npq_del_pre FROM l_sql
          EXECUTE npq_del_pre
      END IF
   END IF  #No.FUN-680088
    INITIALIZE g_npp.* TO NULL
    LET g_npp.nppsys='NM'
    LET g_npp.npp00 =21
    LET g_npp.npp01 =p_trno
    LET g_npp.npp011=9 #集團資金調撥所產生的異動序號故意為9
    LET g_npp.npp02 =g_nnv.nnv02
    LET g_npp.npptype = p_npptype  #No.FUN-680088
    LET l_sql =   
                  #"INSERT INTO ",p_dbs CLIPPED,"npp_file",
                  "INSERT INTO ",cl_get_target_table(p_azp01,'npp_file'), #FUN-A50102
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
                  "   npptype, ",  #No.FUN-680088
                  "   npplegal )", #FUN-980005
               "   VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?) "   #No.FUN-680088 add ?
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_azp01) RETURNING l_sql #FUN-A50102
    CALL s_getlegal(p_azp01) RETURNING l_legal  
    LET g_npp.npplegal = l_legal 
    PREPARE npp_ins_pre FROM l_sql
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
                              g_npp.npptype    #No.FUN-680088 #TQC-790160
                             ,g_npp.npplegal   #FUN-980005 
 
    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
        LET l_sql =
                   #"UPDATE ",p_dbs CLIPPED,"npp_file",
                   "UPDATE ",cl_get_target_table(p_azp01,'npp_file'), #FUN-A50102
                   "  SET npp02=? ",
                   " WHERE nppsys='NM' ",
                   "   AND npp00=21 ",
                   "   AND npp01='",p_trno,"'",
                   "   AND npp011=9 ", #集團資金調撥所產生的異動序號故意為9
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
    CALL t920_g_gl_1(p_trno,p_code,p_dbs,p_npptype,p_azp01)  #No.FUN-680088 add p_npptype
    CALL t920_gen_diff()                             #FUN-A40033
    CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021   
END FUNCTION
 
FUNCTION t920_g_gl_1(p_trno,p_code,p_dbs,p_npqtype,p_azp01)  #INSERT 分錄底稿單身檔#No.FUN-680088 add p_npqtype
   DEFINE p_trno        LIKE nnv_file.nnv01
   DEFINE p_npqtype     LIKE npq_file.npqtype        #No.FUN-680088
   DEFINE p_code        LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)             #1:撥出, 2:撥入
   DEFINE p_dbs         LIKE type_file.chr21,        #No.FUN-680107 VARCHAR(21)
          l_nma05       LIKE nma_file.nma05,
          l_aag05       LIKE aag_file.aag05,
          l_axz08       LIKE axz_file.axz08,
          l_sql         LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(1000)
   DEFINE p_azp01       LIKE azp_file.azp01          #FUN-980005 
   DEFINE l_legal       LIKE npq_file.npqlegal       #FUN-980005  
   DEFINE p_plant       LIKE type_file.chr10         #FUN-980020
   DEFINE l_aaa03       LIKE aaa_file.aaa03          #FUN-A40067
   DEFINE l_azi04_2     LIKE azi_file.azi04          #FUN-A40067
 
 
      LET p_plant = p_azp01                          #FUN-980020
      LET l_sql =
                 #"INSERT INTO ",p_dbs CLIPPED,"npq_file",
                 "INSERT INTO ",cl_get_target_table(p_plant,'npq_file'), #FUN-A50102
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
                 "  npqtype,  ",  #No.FUN-680088
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
                 "   AND aag00 = ? "   #No.FUN-730032
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
      PREPARE aag05_pre FROM l_sql
      DECLARE aag05_cur CURSOR FOR aag05_pre
 
      IF p_npqtype = '0' THEN  #NO.FUN-680088
         #LET l_sql = "SELECT nma05 FROM ",p_dbs CLIPPED,"nma_file",
         LET l_sql = "SELECT nma05 FROM ",cl_get_target_table(p_plant,'nma_file'), #FUN-A50102
                     " WHERE nma01 = ? "
      ELSE
         #LET l_sql = "SELECT nma051 FROM ",p_dbs CLIPPED,"nma_file",
         LET l_sql = "SELECT nma051 FROM ",cl_get_target_table(p_plant,'nma_file'), #FUN-A50102
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
 
   INITIALIZE g_npq.* TO NULL
   LET g_npq.npqsys = g_npp.nppsys
   LET g_npq.npq00  = g_npp.npp00
   LET g_npq.npq01  = g_npp.npp01
   LET g_npq.npq011 = g_npp.npp011
   LET g_npq.npq05  = g_nnv.nnv03 #部門
   LET g_npq.npqtype= p_npqtype   #No.FUN-680088
   CALL s_get_bookno1(YEAR(g_npp.npp02),p_plant) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag =  '1' THEN  #抓不到帳別
      CALL cl_err(p_dbs || ' ' || g_npp.npp02,'aoo-081',1)
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

   #==>撥出
   #借:集團暫付(nnv12,nnv11)
   #   手續費  (nnv19,nnv18)
   #貸:撥出銀行的銀存科目(nma05,nnv11)             
   #   手續費出帳銀行的銀存科目(nma05,nnv18)       
   #==>撥入
   #借:銀行存款(nma05,nnv26)
   #貸:集團借款(nnv27,nnv26)
   IF p_code = '1' THEN
       OPEN axz08_cur USING g_nnv.nnv05
       FETCH axz08_cur INTO l_axz08
      #MOD-A20047---mark---start---
      #IF cl_null(l_axz08) THEN
      #    LET g_npq.npq37 = g_nnv.nnv05
      #ELSE
      #    LET g_npq.npq37 = l_axz08
      #END IF
      #MOD-A20047---mark---end---
       #借:集團暫付(nnv12,nnv11)*********************************
       LET g_npq.npq02 = 1             #項次
       LET g_npq.npq06 = '1'           #借貸別 (1.借 2.貸)
       LET g_npq.npq07 = g_nnv.nnv11   #本幣金額
       LET g_npq.npq07f= g_nnv.nnv10   #原幣金額
       LET g_npq.npq24 = g_nnv.nnv08   #原幣幣別
       LET g_npq.npq25 = g_nnv.nnv09   #匯率
       LET g_npq25     = g_npq.npq25   #NO.FUN-9A0036
       IF p_npqtype = '0' THEN  #No.FUN-680088
          LET g_npq.npq03 = g_nnv.nnv12   #科目
       ELSE
          LET g_npq.npq03 = g_nnv.nnv121
       END IF
       #==>本科目是否作部門明細管理
       SELECT aag05
         INTO l_aag05
         FROM aag_file
        WHERE aag01=g_npq.npq03
          AND aag00=g_bookno3   #No.FUN-730032
       IF l_aag05='N' THEN
           LET g_npq.npq05 = ''
       ELSE
           LET g_npq.npq05 = g_nnv.nnv03
       END IF
       LET g_npq.npq04=NULL  #FUN-D10065
       CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)   #No.FUN-730032
       RETURNING  g_npq.*
       CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING  g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
      CALL s_getlegal(p_azp01) RETURNING l_legal  
      LET g_npq.npqlegal = l_legal 
     #MOD-A20047---add---start---
      IF cl_null(l_axz08) THEN
          LET g_npq.npq37 = g_nnv.nnv05
      ELSE
          LET g_npq.npq37 = l_axz08
      END IF
     #MOD-A20047---add---end---
#No.FUN-9A0036 --Begin
       IF p_npqtype = '1' THEN
          CALL s_newrate(g_bookno1,g_bookno2,
                         g_npq.npq24,g_npq25,g_npp.npp02)
          RETURNING g_npq.npq25
          LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
          LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
       ELSE
          LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
       END IF
#No.FUN-9A0036 --End
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
           CALL cl_err('ins npq_d1:',STATUS,1)
           LET g_success='N'
           RETURN
       END IF
 
       #借:手續費  (nnv19,nnv18)*********************************
       IF NOT cl_null(g_nnv.nnv13) THEN
           LET g_npq.npq02 = g_npq.npq02+1 #項次
           LET g_npq.npq06 = '1'           #借貸別 (1.借 2.貸)
           LET g_npq.npq07 = g_nnv.nnv18   #本幣金額
           LET g_npq.npq07f= g_nnv.nnv17   #原幣金額
           LET g_npq.npq24 = g_nnv.nnv15   #原幣幣別
           LET g_npq.npq25 = g_nnv.nnv16   #匯率
           LET g_npq25     = g_npq.npq25   #NO.FUN-9A0036
           IF p_npqtype = '0' THEN  #No.FUN-680088
              LET g_npq.npq03 = g_nnv.nnv19   #科目
           ELSE
              LET g_npq.npq03 = g_nnv.nnv191
           END IF
           #==>本科目是否作部門明細管理
           OPEN aag05_cur USING g_npq.npq03,g_bookno3  #No.FUN-730032
           FETCH aag05_cur INTO l_aag05
           IF l_aag05='N' THEN
               LET g_npq.npq05 = ''
           ELSE
               LET g_npq.npq05 = g_nnv.nnv03
           END IF
           LET g_npq.npq04=NULL  #FUN-D10065
           CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)  #No.FUN-730032
           RETURNING  g_npq.*
            
           CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING  g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
           CALL s_getlegal(p_azp01) RETURNING l_legal  
           LET g_npq.npqlegal = l_legal 
#No.FUN-9A0036 --Begin
           IF p_npqtype = '1' THEN
              CALL s_newrate(g_bookno1,g_bookno2,
                             g_npq.npq24,g_npq25,g_npp.npp02)
              RETURNING g_npq.npq25
              LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#             LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
           ELSE
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
           END IF
#No.FUN-9A0036 --End
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
                     g_npq.npqtype    #No.FUN-680088
                    ,g_npq.npqlegal   #FUN-980005  
           IF STATUS THEN
               CALL cl_err('ins npq_d2:',STATUS,1)
               LET g_success='N'
               RETURN
           END IF
       END IF
       #MOD-640332--add----if判斷------
 
       #貸:撥出銀行的銀存科目(nma05,nnv11)**********************************
       LET g_npq.npq02 = g_npq.npq02+1               #項次
       LET g_npq.npq06 = '2'                         #借貸別 (1.借 2.貸)
       LET g_npq.npq07 = g_nnv.nnv11                 #本幣金額
       LET g_npq.npq07f= g_nnv.nnv10                  #原幣金額   #MOD-740072
       LET g_npq.npq24 = g_nnv.nnv08                 #幣別         #MOD-740072
       LET g_npq.npq25 = g_nnv.nnv09                  #匯率        #MOD-740072
       LET g_npq25     = g_npq.npq25   #NO.FUN-9A0036
       OPEN nma05_cur USING g_nnv.nnv06
       FETCH nma05_cur INTO l_nma05
       LET g_npq.npq03 = l_nma05                      #科目
       #==>本科目是否作部門明細管理
       OPEN aag05_cur USING g_npq.npq03,g_bookno1   #No.FUN-730032
       FETCH aag05_cur INTO l_aag05
       IF l_aag05='N' THEN
           LET g_npq.npq05 = ''
       ELSE
           LET g_npq.npq05 = g_nnv.nnv03
       END IF
       LET g_npq.npq04=NULL  #FUN-D10065
       CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)  #No.FUN-730032
       RETURNING  g_npq.*
        
       CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING  g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
       CALL s_getlegal(p_azp01) RETURNING l_legal  
       LET g_npq.npqlegal = l_legal 
#No.FUN-9A0036 --Begin
       IF p_npqtype = '1' THEN
          CALL s_newrate(g_bookno1,g_bookno2,
                         g_npq.npq24,g_npq25,g_npp.npp02)
          RETURNING g_npq.npq25
          LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
          LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
       ELSE
          LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
       END IF
#No.FUN-9A0036 --End
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
                 g_npq.npqtype    #No.FUN-680088
                ,g_npq.npqlegal   #FUN-980005 
       IF STATUS THEN
           CALL cl_err('ins npq_d3:',STATUS,1)
           LET g_success='N'
           RETURN
       END IF
       #貸:手續費出帳銀行的銀存科目(nma05,nnv18)****************************
           IF NOT cl_null(g_nnv.nnv13) THEN
           LET g_npq.npq02 = g_npq.npq02+1               #項次
           LET g_npq.npq06 = '2'                         #借貸別 (1.借 2.貸)
           LET g_npq.npq07 = g_nnv.nnv18                 #本幣金額
           LET g_npq.npq07f= g_nnv.nnv18                 #原幣金額
           LET g_npq.npq24 = g_aza17_out                 #原幣幣別
           LET g_npq.npq25 = 1                           #匯率
           LET g_npq25     = g_npq.npq25   #NO.FUN-9A0036
           OPEN nma05_cur USING g_nnv.nnv13
           FETCH nma05_cur INTO l_nma05
           LET g_npq.npq03 = l_nma05                      #科目
           #==>本科目是否作部門明細管理
           OPEN aag05_cur USING g_npq.npq03,g_bookno3   #No.FUN-730032
           FETCH aag05_cur INTO l_aag05
           IF l_aag05='N' THEN
               LET g_npq.npq05 = ''
           ELSE
               LET g_npq.npq05 = g_nnv.nnv03
           END IF
           LET g_npq.npq04=NULL  #FUN-D10065
           CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)  #No.FUN-730032
           RETURNING  g_npq.*
           
          CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING  g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
          CALL s_getlegal(p_azp01) RETURNING l_legal  
          LET g_npq.npqlegal = l_legal 
#No.FUN-9A0036 --Begin
           IF p_npqtype = '1' THEN
              CALL s_newrate(g_bookno1,g_bookno2,
                             g_npq.npq24,g_npq25,g_npp.npp02)
              RETURNING g_npq.npq25
              LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#             LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
           ELSE
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
           END IF
#No.FUN-9A0036 --End
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
                     g_npq.npqtype    #No.FUN-680088
                    ,g_npq.npqlegal    #FUN-980005 
           IF STATUS THEN
               CALL cl_err('ins npq_d4:',STATUS,1)
               LET g_success='N'
               RETURN
           END IF
       END IF
       #MOD-640332--add----if判斷------
   ELSE
       #==>撥入
       OPEN axz08_cur USING g_nnv.nnv20
       FETCH axz08_cur INTO l_axz08
      #MOD-A20047---mark---start---
      #IF cl_null(l_axz08) THEN
      #    LET g_npq.npq37 = g_nnv.nnv20
      #ELSE
      #    LET g_npq.npq37 = l_axz08
      #END IF
      #MOD-A20047---mark---end---
       #借:銀行存款(nma05,nnv26)
       LET g_npq.npq02 = 1             #項次
       LET g_npq.npq06 = '1'           #借貸別 (1.借 2.貸)
       LET g_npq.npq07 = g_nnv.nnv26   #本幣金額
       LET g_npq.npq07f= g_nnv.nnv25   #原幣金額
       LET g_npq.npq24 = g_nnv.nnv23   #原幣幣別
       LET g_npq.npq25 = g_nnv.nnv24   #匯率
       LET g_npq25     = g_npq.npq25   #NO.FUN-9A0036
       OPEN nma05_cur USING g_nnv.nnv21
       FETCH nma05_cur INTO l_nma05
       LET g_npq.npq03 = l_nma05   #科目
       #==>本科目是否作部門明細管理
       OPEN aag05_cur USING g_npq.npq03,g_bookno3  #No.FUN-730032
       FETCH aag05_cur INTO l_aag05
       IF l_aag05='N' THEN
           LET g_npq.npq05 = ''
       ELSE
           LET g_npq.npq05 = g_nnv.nnv03
       END IF
       LET g_npq.npq04=NULL  #FUN-D10065
       CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)   #No.FUN-730032
       RETURNING  g_npq.*
  
       CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING  g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
       CALL s_getlegal(p_azp01) RETURNING l_legal  
       LET g_npq.npqlegal = l_legal 
      #MOD-A20047---add---start---
       IF cl_null(l_axz08) THEN
           LET g_npq.npq37 = g_nnv.nnv20
       ELSE
           LET g_npq.npq37 = l_axz08
       END IF
      #MOD-A20047---add---end---
#No.FUN-9A0036 --Begin
       IF p_npqtype = '1' THEN
          CALL s_newrate(g_bookno1,g_bookno2,
                         g_npq.npq24,g_npq25,g_npp.npp02)
          RETURNING g_npq.npq25
          LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
          LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
       ELSE
          LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
       END IF
#No.FUN-9A0036 --End
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
                 g_npq.npqtype    #No.FUN-680088
                ,g_npq.npqlegal   #FUN-980005 
       IF STATUS THEN
           CALL cl_err('ins npq_d5:',STATUS,1)
           LET g_success='N'
           RETURN
       END IF
 
       #貸:集團借款(nnv27,nnv26)
       LET g_npq.npq02 = g_npq.npq02+1               #項次
       LET g_npq.npq06 = '2'                         #借貸別 (1.借 2.貸)
       LET g_npq.npq07 = g_nnv.nnv26                 #本幣金額
       LET g_npq.npq07f= g_nnv.nnv25                 #原幣金額
       LET g_npq.npq24 = g_nnv.nnv23                 #原幣幣別
       LET g_npq.npq25 = g_nnv.nnv24                 #匯率
       LET g_npq25     = g_npq.npq25   #NO.FUN-9A0036
       IF p_npqtype = '0' THEN  #No.FUN-680088
          LET g_npq.npq03 = g_nnv.nnv27                 #科目
       ELSE
          LET g_npq.npq03 = g_nnv.nnv271
       END IF
       #==>本科目是否作部門明細管理
       SELECT aag05
         INTO l_aag05
         FROM aag_file
        WHERE aag01=g_npq.npq03
          AND aag00=g_bookno3   #No.FUN-730032
       IF l_aag05='N' THEN
           LET g_npq.npq05 = ''
       ELSE
           LET g_npq.npq05 = g_nnv.nnv03
       END IF
       LET g_npq.npq04=NULL  #FUN-D10065
       CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) #No.FUN-730032
       RETURNING  g_npq.*
       CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087  
       CALL s_getlegal(p_azp01) RETURNING l_legal  
       LET g_npq.npqlegal = l_legal 
#No.FUN-9A0036 --Begin
       IF p_npqtype = '1' THEN
          CALL s_newrate(g_bookno1,g_bookno2,
                         g_npq.npq24,g_npq25,g_npp.npp02)
          RETURNING g_npq.npq25
          LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
          LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
       ELSE
          LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
       END IF
#No.FUN-9A0036 --End
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
                 g_npq.npqtype    #No.FUN-680088
                ,g_npq.npqlegal   #FUN-980005 
       IF STATUS THEN
           CALL cl_err('ins npq_d6:',STATUS,1)
           LET g_success='N'
           RETURN
       END IF
   END IF
END FUNCTION
 
FUNCTION t920_npp02(p_code,p_npptype)       #No.FUN-680088 add p_npptype
   DEFINE p_code     LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE p_npptype  LIKE npp_file.npptype  #No.FUN-680088
 
   IF p_code = '1' THEN
       IF cl_null(g_nnv.nnv34) THEN
          UPDATE npp_file SET npp02=g_nnv.nnv02
           WHERE npp01=g_nnv.nnv01
             AND npp00=21
             AND npp011=9 #集團資金調撥所產生的異動序號故意為9
             AND nppsys= 'NM'
             AND npptype = p_npptype  #No.FUN-680088
          IF STATUS THEN 
             LET g_showmsg=g_nnv.nnv01,"/",p_npptype                    #No.FUN-710024
             CALL s_errmsg("npp01,npptype",g_showmsg,"UPD npp_file",SQLCA.sqlcode,0)  #No.FUN-710024
          END IF
       END IF
   ELSE
       IF cl_null(g_nnv.nnv35) THEN
          UPDATE npp_file SET npp02=g_nnv.nnv02
           WHERE npp01=g_nnv.nnv01
             AND npp00=21
             AND npp011=9 #集團資金調撥所產生的異動序號故意為9
             AND nppsys= 'NM'
             AND npptype = p_npptype  #No.FUN-680088
          IF STATUS THEN 
             LET g_showmsg=g_nnv.nnv01,"/",p_npptype                    #No.FUN-710024
             CALL s_errmsg("npp01,npptype",g_showmsg,"UPD npp_file",SQLCA.sqlcode,0)  #No.FUN-710024
          END IF
       END IF
   END IF
END FUNCTION
 
FUNCTION t920_chgdbs(p_dbs,p_plant)  #FUN-990069 add p_plant
  DEFINE p_dbs   LIKE azp_file.azp03
  DEFINE p_plant LIKE azp_file.azp01
 
   IF cl_null(p_dbs) THEN RETURN END IF   #No.TQC-990012
   CALL cl_ins_del_sid(2,'') #FUN-980030   #FUN-990069
   CLOSE DATABASE   #MOD-740072 add
   DATABASE p_dbs
   CALL cl_ins_del_sid(1,p_plant) #FUN-980030   #FUN-990069 
   IF STATUS THEN ERROR 'open database error!' RETURN END IF
   CALL cl_dsmark(0)
END FUNCTION
 
FUNCTION t920_y() #when g_nnv.nnvconf='N' (Turn to 'Y')
   DEFINE l_t                LIKE nmy_file.nmyslip     #No.FUN-680107 VARCHAR(05)
   DEFINE l_nmydmy3          LIKE nmy_file.nmydmy3
   DEFINE l_n1               LIKE type_file.num5       #No.FUN-670060  #No.FUN-680107 SMALLINT
   DEFINE l_n2               LIKE type_file.num5       #No.FUN-670060  #No.FUN-680107 SMALLINT
   DEFINE l_nmc03_1          LIKE nmc_file.nmc03       #No.FUN-690090
   DEFINE l_nmc03_2          LIKE nmc_file.nmc03       #No.FUN-690090
 
   IF g_nnv.nnv01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_nnv.* FROM nnv_file WHERE nnv01 = g_nnv.nnv01
   IF g_nnv.nnvconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_nnv.nnvconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   #判斷該單別是否須拋轉總帳
   LET l_t = s_get_doc_no(g_nnv.nnv01)
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip = l_t           #No.FUN-670060
   IF STATUS OR cl_null(g_nmy.nmydmy3) THEN                             #No.FUN-670060
       LET g_nmy.nmydmy3 = 'N'                                          #No.FUN-670060
   END IF
   IF g_nmy.nmydmy6 = 'Y' THEN
      LET l_nmc03_1 = NULL
      LET l_nmc03_2 = NULL
      #LET g_sql = "SELECT nmc03 FROM ",g_dbs_in,"nmc_file",
      LET g_sql = "SELECT nmc03 FROM ",cl_get_target_table(g_plant_in,'nmc_file'), #FUN-A50102
                  " WHERE nmc01 = '",g_nnv.nnv07,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_in) RETURNING g_sql #FUN-A50102
      PREPARE nmc03_p5 FROM g_sql
      DECLARE nmc03_c5 CURSOR FOR nmc03_p5
      OPEN nmc03_c5
      FETCH nmc03_c5 INTO l_nmc03_1
      IF cl_null(l_nmc03_1) THEN
         CALL cl_err(g_nnv.nnv07,'anm-987',1)
         RETURN
      ELSE
         #LET g_sql = "SELECT nmc03 FROM ",g_dbs_out,"nmc_file",
         LET g_sql = "SELECT nmc03 FROM ",cl_get_target_table(g_plant_out,'nmc_file'), #FUN-A50102
                     " WHERE nmc01 = '",g_nnv.nnv07,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_out) RETURNING g_sql #FUN-A50102
         PREPARE nmc03_p6 FROM g_sql
         DECLARE nmc03_c6 CURSOR FOR nmc03_p6
         OPEN nmc03_c6
         FETCH nmc03_c6 INTO l_nmc03_2
         IF l_nmc03_1 <> l_nmc03_2 THEN
            CALL cl_err(g_nnv.nnv07,'anm-986',1)
            RETURN
         END IF
      END IF
      LET l_nmc03_1 = NULL
      LET l_nmc03_2 = NULL
      #LET g_sql = "SELECT nmc03 FROM ",g_dbs_out,"nmc_file",
      LET g_sql = "SELECT nmc03 FROM ",cl_get_target_table(g_plant_out,'nmc_file'), #FUN-A50102
                  " WHERE nmc01 = '",g_nnv.nnv22,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_out) RETURNING g_sql #FUN-A50102
      PREPARE nmc03_p7 FROM g_sql
      DECLARE nmc03_c7 CURSOR FOR nmc03_p7
      OPEN nmc03_c7
      FETCH nmc03_c7 INTO l_nmc03_1
      IF cl_null(l_nmc03_1) THEN
         CALL cl_err(g_nnv.nnv22,'anm-985',1)
         RETURN
      ELSE
         #LET g_sql = "SELECT nmc03 FROM ",g_dbs_in,"nmc_file",
         LET g_sql = "SELECT nmc03 FROM ",cl_get_target_table(g_plant_in,'nmc_file'), #FUN-A50102
                     " WHERE nmc01 = '",g_nnv.nnv22,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_in) RETURNING g_sql #FUN-A50102
         PREPARE nmc03_p8 FROM g_sql
         DECLARE nmc03_c8 CURSOR FOR nmc03_p8
         OPEN nmc03_c8
         FETCH nmc03_c8 INTO l_nmc03_2
         IF l_nmc03_1 <> l_nmc03_2 THEN
            CALL cl_err(g_nnv.nnv22,'anm-984',1)
            RETURN
         END IF
      END IF
   END IF
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr ='N' THEN                   #No.FUN-670060
       #檢查撥出的若單別須拋轉總帳, 檢查分錄底稿平衡正確否
       CALL t920_chgdbs(g_azp03_out,g_plant_out)  #FUN-990069  add g_plant_out
       CALL s_get_bookno(YEAR(g_nnv.nnv02)) RETURNING g_flag,g_bookno1,g_bookno2
       IF g_flag =  '1' THEN  #抓不到帳別
          CALL cl_err(g_nnv.nnv02,'aoo-081',1)
          LET g_success='N'
          RETURN
       END IF
       CALL s_chknpq(g_nnv.nnv01,'NM',9,'0',g_bookno1)  #No.FUN-680088 add '0'  #No.FUN-730032
       IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
          CALL s_chknpq(g_nnv.nnv01,'NM',9,'1',g_bookno2)  #No.FUN-730032
       END IF
       CALL t920_chgdbs(g_azp03_curr,g_plant_curr)  #FUN-990069  add g_plant_curr
       CALL t920_lock_cur()
       CALL t920_fetch_cur() 
       OPEN t920_cs          
       FETCH ABSOLUTE g_curs_index t920_cs INTO g_nnv.nnv01 
       IF g_success = 'Y' THEN
           #檢查撥入的若單別須拋轉總帳, 檢查分錄底稿平衡正確否
           CALL t920_chgdbs(g_azp03_in,g_plant_in) #FUN-990069  add g_plant_in
           CALL s_get_bookno(YEAR(g_nnv.nnv02)) RETURNING g_flag,g_bookno1,g_bookno2
           IF g_flag =  '1' THEN  #抓不到帳別
              CALL cl_err(g_nnv.nnv02,'aoo-081',1)
              LET g_success='N'
              RETURN
           END IF
           CALL s_chknpq(g_nnv.nnv01,'NM',9,'0',g_bookno1)   #No.FUN-680088 add '0' #No.FUN-730032
           IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
              CALL s_chknpq(g_nnv.nnv01,'NM',9,'1',g_bookno2)  #No.FUN-730032
           END IF
           CALL t920_chgdbs(g_azp03_curr,g_plant_curr) #FUN-990069  add g_plant_curr
           CALL t920_lock_cur()
           CALL t920_fetch_cur() 
           OPEN t920_cs          
           FETCH ABSOLUTE g_curs_index t920_cs INTO g_nnv.nnv01 
       END IF
   END IF
   IF g_success = 'N' THEN RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   BEGIN WORK
   OPEN t920_cl USING g_nnv.nnv01
   IF STATUS THEN
      CALL cl_err("OPEN t920_cl:", STATUS, 1)
      CLOSE t920_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t920_cl INTO g_nnv.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nnv.nnv01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t920_cl ROLLBACK WORK RETURN
   END IF
 
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN                                                                           
      CALL t920_chgdbs(g_azp03_in,g_plant_in) #FUN-990069  add g_plant_in
      SELECT COUNT(*) INTO l_n1 FROM npq_file                                                                                     
       WHERE npqsys= 'NM'                                                                                                        
         AND npq00=21                                                                                                            
         AND npq01 = g_nnv.nnv01                                                                                                 
         AND npq011=9                                                                                                            
      IF l_n1 = 0 THEN                                                                                                            
         CALL t920_chgdbs(g_azp03_curr,g_plant_curr)  #FUN-990069  add g_plant_curr
         CALL t920_lock_cur()
         CALL t920_fetch_cur() 
         OPEN t920_cs          
         FETCH ABSOLUTE g_curs_index t920_cs INTO g_nnv.nnv01 
         CALL t920_g_gl(g_nnv.nnv01,'2',g_dbs_in,'0',g_azp01_in) #撥入  #No.FUN-680088 add '0'
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL t920_g_gl(g_nnv.nnv01,'2',g_dbs_in,'1',g_azp01_in)
         END IF
         CALL t920_chgdbs(g_azp03_in,g_plant_in) #FUN-990069  add g_plant_in
      END IF                                                                                                                     
      IF g_success = 'Y' THEN                                                                                                    
         CALL s_get_bookno(YEAR(g_nnv.nnv02)) RETURNING g_flag,g_bookno1,g_bookno2
         IF g_flag =  '1' THEN  #抓不到帳別
            CALL cl_err(g_nnv.nnv02,'aoo-081',1)
            LET g_success='N'
            RETURN
         END IF
         CALL s_chknpq(g_nnv.nnv01,'NM',9,'0',g_bookno1)  #No.FUN-680088 add '0'  #No.FUN-730032
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL s_chknpq(g_nnv.nnv01,'NM',9,'1',g_bookno2)  #No.FUN-730032
         END IF
         IF g_success ='N' THEN RETURN END IF
      END IF                                                                                                                     
      CALL t920_chgdbs(g_azp03_curr,g_plant_curr)  #FUN-990069  add g_plant_curr
      CALL t920_lock_cur()
      CALL t920_fetch_cur() 
      OPEN t920_cs          
      FETCH ABSOLUTE g_curs_index t920_cs INTO g_nnv.nnv01 
 
      CALL t920_chgdbs(g_azp03_out,g_plant_out)  #FUN-990069  add g_plant_out
      SELECT COUNT(*) INTO l_n2 FROM npq_file                                                                                     
       WHERE npqsys= 'NM'                                                                                                        
         AND npq00=21                                                                                                            
         AND npq01 = g_nnv.nnv01                                                                                                 
         AND npq011=9                                                                                                            
      IF l_n2 = 0 THEN                                                                                                            
         CALL t920_chgdbs(g_azp03_curr,g_plant_curr) #FUN-990069  add g_plant_curr
         CALL t920_lock_cur()
         CALL t920_fetch_cur() 
         OPEN t920_cs          
         FETCH ABSOLUTE g_curs_index t920_cs INTO g_nnv.nnv01 
         CALL t920_g_gl(g_nnv.nnv01,'1',g_dbs_out,'0',g_azp01_out) #撥出  #No.FUN-680088 add '0'
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL t920_g_gl(g_nnv.nnv01,'1',g_dbs_out,'1',g_azp01_out)
         END IF
         CALL t920_chgdbs(g_azp03_out,g_plant_out)  #FUN-990069  add g_plant_out
      END IF                                                                                                                     
      IF g_success = 'Y' THEN                                                                                                    
         CALL s_get_bookno(YEAR(g_nnv.nnv02)) RETURNING g_flag,g_bookno1,g_bookno2
         IF g_flag =  '1' THEN  #抓不到帳別
            CALL cl_err(g_nnv.nnv02,'aoo-081',1)
            LET g_success='N'
            RETURN
         END IF
         CALL s_chknpq(g_nnv.nnv01,'NM',9,'0',g_bookno1)  #No.FUN-680088 add '0'  #No.FUN-730032
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL s_chknpq(g_nnv.nnv01,'NM',9,'1',g_bookno2)  #No.FUN-730032
         END IF
         IF g_success ='N' THEN RETURN END IF
      END IF                                                                                                                     
      CALL t920_chgdbs(g_azp03_curr,g_plant_curr)  #FUN-990069  add g_plant_curr
      CALL t920_lock_cur()
      CALL t920_fetch_cur() 
      OPEN t920_cs          
      FETCH ABSOLUTE g_curs_index t920_cs INTO g_nnv.nnv01 
   END IF                                                                                                                        
   IF g_success = 'N' THEN 
      ROLLBACK WORK      
      RETURN 
   END IF
 
   LET g_success = 'Y'
   CALL t920_ins_nme('1',g_dbs_out,g_azp01_out) #撥出營運中心insert into 一筆nme_file銀行異動資料
   IF g_success = 'N' THEN
       ROLLBACK WORK
       RETURN
   END IF
   CALL t920_ins_nme('2',g_dbs_in,g_azp01_in)  #撥入營運中心insert into 一筆nme_file銀行異動資料
   IF g_success = 'N' THEN
       ROLLBACK WORK
       RETURN
   END IF
   IF NOT cl_null(g_nnv.nnv13) THEN #MOD-640332 add if 判斷----------
       CALL t920_ins_nme('3',g_dbs_out,g_azp01_out) #撥出營運中心insert into 一筆nme_file銀行異動資料 for 手續費
       IF g_success = 'N' THEN
           ROLLBACK WORK
           RETURN
       END IF
   END IF
   IF g_nmy.nmydmy6 = 'Y' THEN
      CALL t920_ins_nme('4',g_dbs_out,g_azp01_out)
      IF g_success = 'N' THEN
         ROLLBACK WORK
         RETURN
      END IF
      CALL t920_ins_nme('5',g_dbs_in,g_azp01_in)
      IF g_success = 'N' THEN
         ROLLBACK WORK
         RETURN
      END IF
   END IF
   IF g_success = 'Y' THEN
       UPDATE nnv_file SET nnvconf = 'Y'
        WHERE nnv01 = g_nnv.nnv01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err3("upd","nnv_file",g_nnv.nnv01,"",SQLCA.sqlcode,"","upd nmd_file",1)  #No.FUN-660148
           LET g_success ='N'
       END IF
   END IF
   IF g_success = 'Y' THEN
       CALL cl_flow_notify(g_nnv.nnv01,'Y')
       CALL cl_cmmsg(1)
       COMMIT WORK
   ELSE
       CALL cl_rbmsg(1)
       ROLLBACK WORK
   END IF
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN                                                          
      LET g_wc_gl = 'nnv01 = "',g_nnv.nnv01,'" AND nnv02 = "',g_nnv.nnv02,'"'                                                                      
      LET g_str="anmp930 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02b,"' '1' 'Y' '1' 'Y' '",g_nmz.nmz02c,"'"  #No.FUN-680088#FUN-860040
      CALL cl_cmdrun_wait(g_str)                                                                                                    
   END IF                                                                                                                           
   SELECT * INTO g_nnv.* FROM nnv_file
    WHERE nnv01 = g_nnv.nnv01
   CALL t920_show()
END FUNCTION
 
FUNCTION t920_ins_nme(p_code,p_dbs,p_azp01)
   DEFINE p_code        LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1) #1:撥出, 2:撥入 , 3:手續費 4:撥出內部 5:撥入內部
   DEFINE p_dbs         LIKE type_file.chr21,  #No.FUN-680107 VARCHAR(21)
          l_sql         LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(1000)
   DEFINE p_azp01       LIKE azp_file.azp01    #FUN-980005 
   DEFINE l_legal       LIKE nme_file.nmelegal #FUN-980005 

#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end

      LET l_sql =
                 #"INSERT INTO ",p_dbs CLIPPED,"nme_file",
                 "INSERT INTO ",cl_get_target_table(p_azp01,'nme_file'), #FUN-A50102
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
                 "  nme061 ,  ",  #No.FUN-680088 add nme061
                 "  nme21, ",   #FUN-730032
                 "  nme22, ",   #FUN-730032
                 "  nme23, ",   #FUN-730032
                 "  nme24, ",   #FUN-730032
                 "  nme25, ",   #FUN-730032
                 "  nme27, ",   #FUN-B30166
                 "  nmelegal) " ,   #FUN-980005 
                 "   VALUES(?,?,?,?,?,?,?,?,?,?, ",
                 "          ?,?,?,?,?,?,?,?,?,?, ",
                 "          ?,?,?,?,?,?,?,?,?,?,?,?,?, ", #No.FUN-680088 add ?  #FUN-730032
#                "          ?)"   #FUN-980005    #FUN-B30166 Mark
                 "          ?,?)" #FUN-B30166 Add
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_azp01) RETURNING l_sql #FUN-A50102
      PREPARE nme_ins_pre FROM l_sql
 
   INITIALIZE g_nme.* TO NULL
   LET g_nme.nme00  = 0
   LET g_nme.nme02  = g_nnv.nnv02
   LET g_nme.nme12  = g_nnv.nnv01
   LET g_nme.nme14  = g_nnv.nnv04
   LET g_nme.nme15  = g_nnv.nnv03
   LET g_nme.nme16  = g_nnv.nnv02
   LET g_nme.nme20  = 'N'
   LET g_nme.nmeacti = 'Y'
   LET g_nme.nmeuser = g_user
   LET g_nme.nmegrup = g_grup               #使用者所屬群
   LET g_nme.nmedate = g_today
   CASE p_code
        WHEN '1' #撥出
             LET g_nme.nme01  = g_nnv.nnv06
             LET g_nme.nme03  = g_nnv.nnv07
             LET g_nme.nme04  = g_nnv.nnv10
             LET g_nme.nme06  = g_nnv.nnv12
             IF g_aza.aza63 = 'Y' THEN
                LET g_nme.nme061  = g_nnv.nnv121
             END IF
             LET g_nme.nme07  = g_nnv.nnv09
             LET g_nme.nme08  = g_nnv.nnv11
             LET g_nme.nme13  = g_nnv.nnv20
        WHEN '2' #撥入
             LET g_nme.nme01  = g_nnv.nnv21
             LET g_nme.nme03  = g_nnv.nnv22
             LET g_nme.nme04  = g_nnv.nnv25
             LET g_nme.nme06  = g_nnv.nnv27
             IF g_aza.aza63 = 'Y' THEN
                LET g_nme.nme061  = g_nnv.nnv271
             END IF
             LET g_nme.nme07  = g_nnv.nnv24
             LET g_nme.nme08  = g_nnv.nnv26
             LET g_nme.nme13  = g_nnv.nnv05
        WHEN '3' #手續費
             LET g_nme.nme01  = g_nnv.nnv13
             LET g_nme.nme03  = g_nnv.nnv14
             LET g_nme.nme04  = g_nnv.nnv17
             LET g_nme.nme06  = g_nnv.nnv19
             IF g_aza.aza63 = 'Y' THEN
                LET g_nme.nme061  = g_nnv.nnv191
             END IF
             LET g_nme.nme07  = g_nnv.nnv16
             LET g_nme.nme08  = g_nnv.nnv18
             LET g_nme.nme13  = g_nnv.nnv20
        WHEN '4' 
             LET g_nme.nme01  = g_nnv.nnv41
             LET g_nme.nme03  = g_nnv.nnv22
             LET g_nme.nme04  = g_nnv.nnv10
             LET g_nme.nme06  = g_nnv.nnv12
             IF g_aza.aza63 = 'Y' THEN
                LET g_nme.nme061  = g_nnv.nnv121
             END IF
             LET g_nme.nme07  = g_nnv.nnv09
             LET g_nme.nme08  = g_nnv.nnv11
             LET g_nme.nme13  = g_nnv.nnv20
        WHEN '5' 
             LET g_nme.nme01  = g_nnv.nnv42
             LET g_nme.nme03  = g_nnv.nnv07
             LET g_nme.nme04  = g_nnv.nnv25
             LET g_nme.nme06  = g_nnv.nnv27
             IF g_aza.aza63 = 'Y' THEN
                LET g_nme.nme061  = g_nnv.nnv271
             END IF
             LET g_nme.nme07  = g_nnv.nnv24
             LET g_nme.nme08  = g_nnv.nnv26
             LET g_nme.nme13  = g_nnv.nnv05
   END CASE
   LET g_nme.nme21 = 1
   LET g_nme.nme22 = '05'
   LET g_nme.nme23 = '01'
   LET g_nme.nme24 = '9'
   LET g_nme.nme25 = g_nme.nme13 

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

    CALL s_getlegal(p_azp01) RETURNING l_legal  
    LET g_nme.nmelegal = l_legal 
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
                 g_nme.nme061 ,
                 g_nme.nme21,    #No.FUN-730032
                 g_nme.nme22,    #No.FUN-730032
                 g_nme.nme23,    #No.FUN-730032
                 g_nme.nme24,    #No.FUN-730032
                 g_nme.nme25,    #No.FUN-730032
                 g_nme.nme27,    #No.FUN-B30166
                 g_nme.nmelegal  #FUN-980005 
       IF SQLCA.sqlcode THEN
           CALL cl_err('ins nme',STATUS,1)  
           LET g_success='N'
           RETURN
       END IF
       CALL s_flows_nme(g_nme.*,'1',p_azp01)   #No.FUN-B90062  
END FUNCTION
 
FUNCTION t920_z() #when g_nnv.nnvconf='Y' (Turn to 'N')
  DEFINE l_sql      STRING               #No.FUN-670060
  DEFINE l_aba19    LIKE aba_file.aba19  #No.FUN-670060
 
   IF g_nnv.nnv01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_nnv.* FROM nnv_file WHERE nnv01 = g_nnv.nnv01
   IF g_nnv.nnvconf = 'N' THEN CALL cl_err('',9027,0) RETURN END IF
   IF g_nnv.nnvconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   IF (g_nnv.nnv29 > 0) OR (g_nnv.nnv30 > 0) THEN 
       #此調撥單已有還本或還息記錄,不可取消確認!
       CALL cl_err(g_nnv.nnv01,'anm-937',1) 
       RETURN 
   END IF
 
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原 
   CALL s_get_doc_no(g_nnv.nnv01) RETURNING g_t1
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   IF NOT cl_null(g_nnv.nnv34) OR NOT cl_null(g_nnv.nnv35) THEN
      IF NOT (g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y') THEN
         CALL cl_err(g_nnv.nnv01,'axr-370',0) RETURN 
      END IF 
   END IF 
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN                                                                              
      #LET l_sql = " SELECT aba19 FROM ",g_dbs_in,"aba_file",
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_in,'aba_file'), #FUN-A50102
                  "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                  "    AND aba01 = '",g_nnv.nnv35,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_in) RETURNING l_sql #FUN-A50102
      PREPARE aba_pre1 FROM l_sql
      DECLARE aba_cs1 CURSOR FOR aba_pre1
      OPEN aba_cs1
      FETCH aba_cs1 INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_nnv.nnv35,'axr-071',1)
         RETURN                                                                                                                     
      END IF                                                                                                                        
      #LET l_sql = " SELECT aba19 FROM ",g_dbs_out,"aba_file",
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_out,'aba_file'), #FUN-A50102
                  "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                  "    AND aba01 = '",g_nnv.nnv34,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_out) RETURNING l_sql #FUN-A50102
      PREPARE aba_pre2 FROM l_sql
      DECLARE aba_cs2 CURSOR FOR aba_pre2
      OPEN aba_cs2
      FETCH aba_cs2 INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_nnv.nnv34,'axr-071',1)
         RETURN                                                                                                                     
      END IF                                                                                                                        
   END IF                                                                                                                           
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF

   #CHI-C90052 add begin---
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN
      LET g_str="anmp940 '1' '",g_nmz.nmz02b,"' '",g_nnv.nnv01,"' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT nnv34,nnv35 INTO g_nnv.nnv34,g_nnv.nnv35 FROM nnv_file
       WHERE nnv01 = g_nnv.nnv01
      IF NOT cl_null(g_nnv.nnv34) THEN
         CALL cl_err(g_nnv.nnv34,'aap-929',1)
         RETURN
      END IF
      DISPLAY BY NAME g_nnv.nnv34
      DISPLAY BY NAME g_nnv.nnv35
   END IF
   #CHI-C90052 add end-----

   BEGIN WORK
   OPEN t920_cl USING g_nnv.nnv01
   IF STATUS THEN
      CALL cl_err("OPEN t920_cl:", STATUS, 1)
      CLOSE t920_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t920_cl INTO g_nnv.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nnv.nnv01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t920_cl ROLLBACK WORK RETURN
   END IF
 
   LET g_success = 'Y'
  #IF g_nmy.nmyglcr ='N' THEN  #No.FUN-670060   #CHI-C90052 mark
      #CALL t920_del_nme(g_dbs_out) #撥出營運中心DELETE二筆nme_file銀行異動資料
      CALL t920_del_nme(g_plant_out) #FUN-A50102
      IF g_success = 'N' THEN
          ROLLBACK WORK
          RETURN
      END IF
      #CALL t920_del_nme(g_dbs_in)  #撥入營運中心DELETE 一筆nme_file銀行異動資料
      CALL t920_del_nme(g_plant_in) #FUN-A50102
      IF g_success = 'N' THEN
          ROLLBACK WORK
          RETURN
      END IF
  #END IF           #No.FUN-670060     #CHI-C90052 mark
   IF g_success = 'Y' THEN
       UPDATE nnv_file SET nnvconf = 'N'
        WHERE nnv01 = g_nnv.nnv01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err3("upd","nnv_file",g_nnv.nnv01,"",SQLCA.sqlcode,"","upd nmd_file",1)  #No.FUN-660148
           LET g_success ='N'
       END IF
   END IF
   IF g_success = 'Y' THEN
       CALL cl_flow_notify(g_nnv.nnv01,'N')
       CALL cl_cmmsg(1)
       COMMIT WORK
   ELSE
       CALL cl_rbmsg(1)
       ROLLBACK WORK
   END IF
 
   #CHI-C90052 mark begin---
   #IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN 
   #   LET g_str="anmp940 '1' '",g_nmz.nmz02b,"' '",g_nnv.nnv01,"' 'Y'"
   #   CALL cl_cmdrun_wait(g_str) 
   #   SELECT nnv34,nnv35 INTO g_nnv.nnv34,g_nnv.nnv35 FROM nnv_file 
   #    WHERE nnv01 = g_nnv.nnv01
   #   DISPLAY BY NAME g_nnv.nnv34
   #   DISPLAY BY NAME g_nnv.nnv35
   #END IF 
   ##CALL t920_del_nme(g_dbs_out) #撥出營運中心DELETE二筆nme_file銀行異動資料
   ##CALL t920_del_nme(g_dbs_in)  #撥入營運中心DELETE 一筆nme_file銀行異動資料
   #CALL t920_del_nme(g_plant_out) #FUN-A50102
   #CALL t920_del_nme(g_plant_in)  #FUN-A50102
   #CHI-C90052 mark end-----

   SELECT * INTO g_nnv.* FROM nnv_file
    WHERE nnv01 = g_nnv.nnv01
   CALL t920_show()
END FUNCTION
 
#FUNCTION t920_del_nme(p_dbs)
FUNCTION t920_del_nme(l_plant)  #FUN-A50102
   DEFINE #p_dbs         LIKE type_file.chr21,  #No.FUN-680107 VARCHAR(21)
          l_plant       LIKE type_file.chr21,  #FUN-A50102
          l_sql         LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(1000)
   DEFINE l_nme24 LIKE nme_file.nme24   #FUN-730032
   DEFINE l_aza73      LIKE aza_file.aza73     #No.MOD-740346
 
   #LET g_sql="SELECT aza73 FROM ",p_dbs CLIPPED,"aza_file"
   LET g_sql="SELECT aza73 FROM ",cl_get_target_table(l_plant,'aza_file')#FUN-A50102
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
   PREPARE t920_aza_p FROM g_sql
   DECLARE t920_aza_c CURSOR FOR t920_aza_p
   OPEN t920_aza_c
   FETCH t920_aza_c INTO l_aza73
   IF l_aza73 = 'Y' THEN
      #LET g_sql="SELECT nme24 FROM ",p_dbs CLIPPED,"nme_file",
      LET g_sql="SELECT nme24 FROM ",cl_get_target_table(l_plant,'nme_file'), #FUN-A50102
                " WHERE nme12='",g_nnv.nnv01,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
      PREPARE del_nme24_p FROM g_sql
      DECLARE del_nme24_cs CURSOR FOR del_nme24_p
      FOREACH del_nme24_cs INTO l_nme24
         IF l_nme24 != '9' THEN
            CALL cl_err(g_nnv.nnv01,'anm-043',1)
            LET g_success='N'        #No.MOD-740346
            RETURN
         END IF
      END FOREACH
   END IF #No.MOD-740346
      LET l_sql =
                 #"DELETE FROM  ",p_dbs CLIPPED,"nme_file",
                 "DELETE FROM  ",cl_get_target_table(l_plant,'nme_file'), #FUN-A50102
                 " WHERE nme12 = ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
      PREPARE nme_del_pre FROM l_sql
 
      EXECUTE nme_del_pre USING g_nnv.nnv01
      IF STATUS THEN
          CALL cl_err('del nme',STATUS,1)
          LET g_success='N'
          RETURN
      END IF
      IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021 
      #FUN-B40056  --begin
      LET l_sql ="DELETE FROM  ",cl_get_target_table(l_plant,'tic_file'),
                 " WHERE tic04 = ? "
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql     
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
      PREPARE tic_del_pre2 FROM l_sql
 
      EXECUTE tic_del_pre2 USING g_nnv.nnv01
      IF STATUS THEN
          CALL cl_err('del tic',STATUS,1)
          LET g_success='N'
          RETURN
      END IF
      #FUN-B40056  --end
      END IF                 #No.TQC-B70021 
END FUNCTION
FUNCTION t920_gen_entry_sheet()  #分錄底稿產生
    BEGIN WORK
    LET g_success = 'Y'
    CALL t920_g_gl(g_nnv.nnv01,'1',g_dbs_out,'0',g_azp01_out) #撥出  #No.FUN-680088 add '0'
    IF g_success = 'N' THEN
        ROLLBACK WORK
    ELSE
        CALL t920_g_gl(g_nnv.nnv01,'2',g_dbs_in,'0',g_azp01_in) #撥入  #No.FUN-680088 add '0'
        IF g_success = 'N' THEN
            ROLLBACK WORK
        ELSE
           IF g_aza.aza63 = 'Y' THEN
              CALL t920_g_gl(g_nnv.nnv01,'1',g_dbs_out,'1',g_azp01_out)
              IF g_success = 'N' THEN
                 ROLLBACK WORK
              ELSE
                 CALL t920_g_gl(g_nnv.nnv01,'2',g_dbs_in,'1',g_azp01_in)
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
FUNCTION t920_main_out()  #撥出分錄底稿維護
    CALL t920_chgdbs(g_azp03_out,g_plant_out) #FUN-990069  add g_plant_out
    SELECT nmz02p,nmz02b INTO g_nmz.nmz02p,g_nmz.nmz02b  #No.FUN-680088 add nmz02p
      FROM nmz_file
     WHERE nmz00 = '0'
    CALL s_showmsg_init()           #No.FUN-710024
    CALL s_fsgl('NM',21,g_nnv.nnv01,0,g_nmz.nmz02b,9,g_nnv.nnvconf,'0',g_nmz.nmz02p) #No.FUN-680088 add '0',g_nmz.nmz02p
    CALL t920_npp02('1','0')  #No.FUN-680088 add '0'
    CALL s_showmsg()                 #No.FUN-710024
    CALL t920_chgdbs(g_azp03_curr,g_plant_curr) #FUN-990069  add g_plant_curr
    CALL t920_lock_cur()
    CALL t920_fetch_cur() 
    OPEN t920_cs          
    FETCH ABSOLUTE g_curs_index t920_cs INTO g_nnv.nnv01 
END FUNCTION
 
FUNCTION t920_main_out_1()
    CALL t920_chgdbs(g_azp03_out,g_plant_out) #FUN-990069  add g_plant_out
    SELECT nmz02p,nmz02c INTO g_nmz.nmz02p,g_nmz.nmz02c
      FROM nmz_file
     WHERE nmz00 = '0'
    CALL s_showmsg_init()           #No.FUN-710024
    CALL s_fsgl('NM',21,g_nnv.nnv01,0,g_nmz.nmz02c,9,g_nnv.nnvconf,'1',g_nmz.nmz02p)
    CALL t920_npp02('1','1')
    CALL s_showmsg()           #No.FUN-710024
    CALL t920_chgdbs(g_azp03_curr,g_plant_curr)  #FUN-990069  add g_plant_curr
    CALL t920_lock_cur()
    CALL t920_fetch_cur() 
    OPEN t920_cs          
    FETCH ABSOLUTE g_curs_index t920_cs INTO g_nnv.nnv01 
END FUNCTION
 
FUNCTION t920_main_in()  #撥入分錄底稿維護
    CALL t920_chgdbs(g_azp03_in,g_plant_in)  #FUN-990069  add g_plant_in
    SELECT nmz02p,nmz02b INTO g_nmz.nmz02p,g_nmz.nmz02b  #No.FUN-680088 add nmz02p
      FROM nmz_file
     WHERE nmz00 = '0'
    CALL s_showmsg_init()           #No.FUN-710024
    CALL s_fsgl('NM',21,g_nnv.nnv01,0,g_nmz.nmz02b,9,g_nnv.nnvconf,'0',g_nmz.nmz02p) #No.FUN-680088 add '0',g_nmz.nmz02p
    CALL t920_npp02('2','0')  #No.FUN-680088 add '0'
    CALL s_showmsg()           #No.FUN-710024
    CALL t920_chgdbs(g_azp03_curr,g_plant_curr)  #FUN-990069  add g_plant_curr
    CALL t920_lock_cur()
    CALL t920_fetch_cur() 
    OPEN t920_cs          
    FETCH ABSOLUTE g_curs_index t920_cs INTO g_nnv.nnv01 
END FUNCTION
 
FUNCTION t920_main_in_1()
    CALL t920_chgdbs(g_azp03_in,g_plant_in)  #FUN-990069  add g_plant_in
    SELECT nmz02p,nmz02c INTO g_nmz.nmz02p,g_nmz.nmz02c
      FROM nmz_file
     WHERE nmz00 = '0'
    CALL s_showmsg_init()           #No.FUN-710024
    CALL s_fsgl('NM',21,g_nnv.nnv01,0,g_nmz.nmz02c,9,g_nnv.nnvconf,'1',g_nmz.nmz02p) #No.FUN-680088 add '0',g_nmz.nmz02p
    CALL t920_npp02('2','1')
    CALL s_showmsg()           #No.FUN-710024
    CALL t920_chgdbs(g_azp03_curr,g_plant_curr)  #FUN-990069  add g_plant_curr
    CALL t920_lock_cur()
    CALL t920_fetch_cur() 
    OPEN t920_cs          
    FETCH ABSOLUTE g_curs_index t920_cs INTO g_nnv.nnv01 
END FUNCTION
 
FUNCTION t920_qry_bank_out()  #撥出銀行餘額查詢
    DEFINE l_cmd           LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(300)
           l_wc            LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(300)
 
    CALL t920_chgdbs(g_azp03_out,g_plant_out)  #FUN-990069  add g_plant_out
    LET l_wc=" nma01= '",g_nnv.nnv06,"'"
    SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'anmr322'
                
    LET l_cmd = "anmr322 "
    CALL cl_cmdrun_wait(l_cmd)
    
    CALL t920_chgdbs(g_azp03_curr,g_plant_curr)  #FUN-990069  add g_plant_out
    CALL t920_lock_cur()
    CALL t920_fetch_cur() 
    OPEN t920_cs          
    FETCH ABSOLUTE g_curs_index t920_cs INTO g_nnv.nnv01 
END FUNCTION
#欄位控制
#   條件欄位         被影響欄位                       REQUIRED成立條件
#   ------------     -------------------------------  -----------------------------
#   nnv13手續費銀行  nnv14手續費異動碼                not cl_null(g_nnv.nnv13)
#                    nnv15手續費幣別  
#                    nnv16手續費匯率  
#                    nnv17手續費原幣  
#                    nnv18手續費本幣  
#                    nnv19手續費科目  
FUNCTION t920_required_a()
     IF NOT cl_null(g_nnv.nnv13) THEN
         CALL cl_set_comp_required("nnv14,nnv16,nnv17,nnv18,nnv19",TRUE) 
         IF g_aza.aza63 = 'Y' THEN
            CALL cl_set_comp_required("nnv191",TRUE)
         END IF
     END IF
END FUNCTION
FUNCTION t920_no_required_a()
     IF cl_null(g_nnv.nnv13) THEN
         CALL cl_set_comp_required("nnv14,nnv16,nnv17,nnv18,nnv19,nnv191",FALSE) #No.FUN-680088
         LET g_nnv.nnv14 = NULL
         LET g_nnv.nnv15 = NULL
         LET g_nnv.nnv16 = NULL
         LET g_nnv.nnv17 = NULL
         LET g_nnv.nnv18 = NULL
         LET g_nnv.nnv19 = NULL
         LET g_nnv.nnv191= NULL  #No.FUN-680088
         DISPLAY BY NAME g_nnv.nnv14,g_nnv.nnv15,g_nnv.nnv16,g_nnv.nnv17,g_nnv.nnv18,g_nnv.nnv19
         DISPLAY '' TO FORMONLY.nma02_3
         DISPLAY '' TO FORMONLY.nmc03_3
         DISPLAY '' TO FORMONLY.aag02_3
         DISPLAY '' TO FORMONLY.aag02_6  #No.FUN-680088
     END IF
END FUNCTION
FUNCTION t920_set_entry_a()
      CALL cl_set_comp_entry("nnv14,nnv16,nnv17,nnv18,nnv19,nnv191",TRUE) #No.FUN-680088
      IF g_nmy.nmydmy6 = 'Y' THEN
          CALL cl_set_comp_entry("nnv41,nnv42",TRUE)
      END IF
END FUNCTION
FUNCTION t920_set_no_entry_a()
    IF cl_null(g_nnv.nnv13) THEN
        CALL cl_set_comp_entry("nnv14,nnv16,nnv17,nnv18,nnv19,nnv191",FALSE) #No.FUN-680088
    END IF
    IF g_nmy.nmydmy6 <> 'Y' THEN
        LET g_nnv.nnv41 = NULL
        LET g_nnv.nnv42 = NULL
        DISPLAY NULL TO nnv41
        DISPLAY NULL TO nnv42
        DISPLAY NULL TO FORMONLY.nnv41_nma02
        DISPLAY NULL TO FORMONLY.nnv42_nma02
        CALL cl_set_comp_entry("nnv41,nnv42",FALSE)
    END IF
END FUNCTION
 
FUNCTION t920_carry_voucher()
  DEFINE l_nmygslp_in   LIKE nmy_file.nmygslp
  DEFINE l_nmygslp_out  LIKE nmy_file.nmygslp
  DEFINE li_result      LIKE type_file.num5     #No.FUN-680107 SMALLINT
  DEFINE l_dbs          STRING
  DEFINE l_sql          STRING
  DEFINE l_n            LIKE type_file.num5     #No.FUN-680107 SMALLINT
 
    IF NOT cl_null(g_nnv.nnv34) AND NOT cl_null(g_nnv.nnv35) THEN
       CALL cl_err('','aap-618',1)
       RETURN
    END IF
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    CALL s_get_doc_no(g_nnv.nnv01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmyglcr = 'N' AND cl_null(g_nmy.nmygslp) THEN   #FUN-940036  
       CALL cl_err('','aap-936',1)  #FUN-940036
       RETURN
    END IF   
    IF g_nmy.nmydmy3 = 'N' THEN RETURN END IF
 
    #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
    #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                "    AND aba01 = '",g_nnv.nnv34,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre5 FROM l_sql
    DECLARE aba_cs5 CURSOR FOR aba_pre5
    OPEN aba_cs5
    FETCH aba_cs5 INTO l_n
    IF l_n > 0 THEN
       CALL cl_err(g_nnv.nnv34,'aap-991',1)
       RETURN
    END IF
 
    #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
    #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                "    AND aba01 = '",g_nnv.nnv35,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre6 FROM l_sql
    DECLARE aba_cs6 CURSOR FOR aba_pre6
    OPEN aba_cs6
    FETCH aba_cs6 INTO l_n
    IF l_n > 0 THEN
       CALL cl_err(g_nnv.nnv35,'aap-991',1)
       RETURN
    END IF
    LET g_wc_gl = 'nnv01 = "',g_nnv.nnv01,'" AND nnv02 = "',g_nnv.nnv02,'"'                                                                      
    LET g_str="anmp930 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02b,"' '1' 'Y' '1' 'Y' '",g_nmz.nmz02c,"'"  #No.FUN-680088#FUN-860040
    CALL cl_cmdrun_wait(g_str)
    SELECT nnv34,nnv35 INTO g_nnv.nnv34,g_nnv.nnv35 FROM nnv_file
     WHERE nnv01 = g_nnv.nnv01
    DISPLAY BY NAME g_nnv.nnv34
    DISPLAY BY NAME g_nnv.nnv35
    
END FUNCTION
 
FUNCTION t920_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      STRING
  DEFINE l_n1       LIKE type_file.num5       #No.FUN-680107 SMALLINT
  DEFINE l_n2       LIKE type_file.num5       #No.FUN-680107 SMALLINT
 
    IF cl_null(g_nnv.nnv34) AND cl_null(g_nnv.nnv35) THEN
       CALL cl_err('','aap-619',1)
       RETURN
    END IF
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
    CALL s_get_doc_no(g_nnv.nnv01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmyglcr = 'N' AND cl_null(g_nmy.nmygslp) THEN   #FUN-940036
       CALL cl_err('','aap-936',1)   #FUN-940036
       RETURN
    END IF
    #LET l_sql = " SELECT aba19 FROM ",g_dbs_in,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_in,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                "    AND aba01 = '",g_nnv.nnv35,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_in) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre3 FROM l_sql
    DECLARE aba_cs3 CURSOR FOR aba_pre3
    OPEN aba_cs3
    FETCH aba_cs3 INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_nnv.nnv35,'axr-071',1)
       RETURN                                                                                                                     
    END IF                                                                                                                        
    #LET l_sql = " SELECT aba19 FROM ",g_dbs_out,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_out,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                "    AND aba01 = '",g_nnv.nnv34,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_out) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre4 FROM l_sql
    DECLARE aba_cs4 CURSOR FOR aba_pre4
    OPEN aba_cs4
    FETCH aba_cs4 INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_nnv.nnv34,'axr-071',1)
       RETURN                                                                                                                     
    END IF                                                                                                                        
    LET g_str="anmp940 '1' '",g_nmz.nmz02b,"' '",g_nnv.nnv01,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT nnv34,nnv35 INTO g_nnv.nnv34,g_nnv.nnv35 FROM nnv_file
     WHERE nnv01 = g_nnv.nnv01
    DISPLAY BY NAME g_nnv.nnv34
    DISPLAY BY NAME g_nnv.nnv35
END FUNCTION
#FUN-A40033 --Begin
FUNCTION t920_gen_diff()
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
   IF g_npp.npptype = '1' THEN
      CALL s_get_bookno(YEAR(g_nnv.nnv02)) RETURNING g_flag,g_bookno1,g_bookno2
      IF g_flag =  '1' THEN
         CALL cl_err(g_nnv.nnv02,'aoo-081',1)
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
         INSERT INTO npq_file VALUES(l_npq1.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","npq_file",g_npp.npp01,"",STATUS,"","",1)
            LET g_success = 'N'
         END IF
      END IF
   END IF
END FUNCTION
#FUN-A40033 --End
#No.FUN-9C0073 -----------------By chenls 10/01/15


