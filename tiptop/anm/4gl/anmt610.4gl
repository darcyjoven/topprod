# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: anmt610.4gl
# Descriptions...: 票券外匯平倉維護作業
# Date & Author..: 00/07/19 By Mandy
# Modify.........: No.7875 03/08/21 By Kammy 呼叫自動取單號時應在 Transction中
# Modify.........: No.FUN-4B0052 04/11/24 By Nicola 加入"匯率計算"功能
# Modify.........: No.FUN-4C0063 04/12/09 By Nicola 權限控管修改
# Modify.........: No.FUN-4C0070 04/12/15 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: NO.FUN-550057 05/05/28 By jackie 單據編號加大
# Modify.........: No.MOD-590401 05/09/21 By Smapmin 平倉數量不可大於投資數量.預設平倉金額.
#                                                    由anmt600帶出預設值
# Modify.........: No.FUN-590111 05/09/28 By Nicola 畫面功能大調，並新增分錄底稿功能
# Modify.........: No.FUN-5A0004 05/10/03 By Nicola 畫面欄位調整，存提異動碼需考慮' 存' 或 '提'
#                                                   平倉售價改變時, 入帳金額沒重算
#                                                   分錄底稿: 費用科目應在貸方
#                                                   支出總額, 累計損益 沒回寫.
# Modify.........: No.FUN-5A0012 05/10/04 By Nicola 費用之存提異動碼為"提"
#                                                   確認時,回寫記錄檔的單價應為'平倉銷售單價'
# Modify.........: No.TQC-5A0041 05/10/20 By Smapmin 加上若未查出資料則不執行 並顯示錯誤
#                                                    的功能 以防誤按
# Modify.........: No.MOD-5A0317 05/10/21 By Nicola 單別設定不拋轉傳票，可直接確認
# Modify.........: No.MOD-5A0269 05/10/21 By Nicola 單別放大為5碼
# Modify.........: NO.MOD-5B0159 05/11/28 BY yiting 輸入[費用金額(本幣)]未回寫[費用金額(原幣)]
# Modify.........: No.FUN-5C0015 06/02/14 BY GILL CALL s_def_npq() 依設定
#                                                 給摘要、異動碼預設值
# Modify.........: No.FUN-630020 06/03/08 By pengu 流程訊息通知功能
# Modify.........: No.TQC-630077 06/03/28 By Smapmin 金額與分錄之修改
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670060 06/07/28 By cl    新增"直接拋轉總帳"功能 
# Modify.........: No.FUN-680088 06/08/29 By Ray   多帳套處理
# Modify.........: No.FUN-680107 06/09/06 By Hellen 欄位類型修改
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6A0011 06/11/12 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-710070 07/02/07 By rainy 新增所屬部門 gse27
# Modify.........: No.FUN-730032 07/03/21 By Rayven 新增nme21,nme22,nme23,nme24
# Modify.........: No.FUN-730033 07/03/21 By Carrier 會計科目加帳套
# Modify.........: No.TQC-740042 07/04/09 By dxfwo   年度取帳套
# Modify.........: No.MOD-740346 07/04/23 By Rayven 取消審核是報anm-043的錯卻還是能取消審核
#                                                   不使用網銀時不去判斷是否未轉
# Modify.........: No.TQC-750098 07/05/18 By Rayven nme24默認初始值給'9'
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-760146 07/07/03 By Smapmin 修改幣別位數取位問題
# Modify.........: No.MOD-780251 07/08/28 By Smapmin 平倉數量等於留倉數量時,平倉金額應等於留倉金額
# Modify.........: no.TQC-790093 07/09/20 BY yiting Primary Key的-268訊息 程式修改
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-840393 08/04/25 By douzh  費用資料對應的存提異動碼(核算項)gse17只可錄提出的既nmc03='2'
# Modify.........: No.FUN-850038 08/05/13 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.MOD-880154 08/08/26 By Sarah 當gse19,gse20=0時,不需產生費用分錄
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值 
# Modify.........: No.FUN-940036 09/04/06 By jan 當其單據性質之【傳票單別】非空白者,即可有ACTION 【拋轉總帳】及【傳票拋轉還原】功能
# Modify.........: No.FUN-970003 09/07/13 By hongmei增加列印功能
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0073 10/01/15 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30008 10/03/03 By Carrier nme26 赋值
# Modify.........: No.TQC-A30012 10/03/04 By Carrier INSERT gsc_file前,做变量空
# Modify.........: No.MOD-A30144 10/03/19 By sabrina 刪除單據時要連同分錄底稿一併刪除
# Modify.........: No.FUN-A50102 10/07/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-9A0036 10/07/28 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/07/28 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/07/28 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No:CHI-9B0026 10/11/25 By Summer 1.產生貸方科目的幣別/匯率應帶原投資購買時的幣別/匯率(gsh08/gsh09),原幣金額使用本幣金額/匯率後算出
#                                                   2.產生損益科目時,原幣金額應給予0
# Modify.........: No.TQC-AB0326 10/12/06 By lixh1  調整第二筆新增 nme21 改為 2 
# Modify.........: No.MOD-AC0073 10/12/09 By Dido 立即確認時,確認圖示調整
# Modify.........: No.FUN-AA0087 11/01/28 By Mengxw 
# Modify.........: No:MOD-B20020 11/02/10 By Dido gse01 開窗查詢調整
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料 
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file 
# Modify.........: No:CHI-B70050 11/08/10 By Polly 新增權限Action控管
# Modify.........: No.MOD-BC0009 11/12/02 By Dido 單別檢核判斷條件調整 

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.MOD-C30713 12/03/15 By wangrr 投資單號gse03的時間不可以大於平倉日期
# Modify.........: No:FUN-C30085 12/06/20 By lixiang 串CR報表改GR報表
# Modify.........: No:MOD-C70074 12/07/06 By Polly 匯率為1時，損益分錄原幣本幣金額應相同
# Modify.........: No.CHI-C90052 12/10/02 By Lori 取消確認需在傳票拋轉還原成功後才執行
# Modify.........: No.MOD-CA0042 12/10/05 By Polly 調整損益的計算
# Modify.........: No.FUN-D10065 13/01/17 By wangrr 在調用s_def_npq前npq04=NULL
# Modify.........: No:FUN-D10116 13/03/07 By Polly 增加作廢功能
# Modify.........: No:FUN-D40118 13/05/20 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_gse         RECORD LIKE gse_file.*,
       g_gse_t       RECORD LIKE gse_file.*,
       g_gse_o       RECORD LIKE gse_file.*,
       g_npp         RECORD LIKE npp_file.*,   #No.FUN-590111
       g_npq         RECORD LIKE npq_file.*,   #No.FUN-590111
       g_gse01_t     LIKE gse_file.gse01,
       g_wc,g_sql    LIKE type_file.chr1000,   #No.FUN-680107 VARCHAR(300)
       g_cmd         LIKE type_file.chr1,      #No.FUN-680107 VARCHAR(1)
       g_nmydmy1     LIKE nmy_file.nmydmy1,    #MOD-AC0073
       g_nmydmy3     LIKE nmy_file.nmydmy3,    #MOD-AC0073
       g_t1          LIKE oay_file.oayslip     #No.FUN-550057 #No.FUN-680107 VARCHAR(5)
 
DEFINE g_dbs_gl      LIKE type_file.chr21      #NO.FUN-680107 VARCHAR(21)
DEFINE g_forupd_sql  STRING                    #SELECT ... FOR UPDATE SQL  
DEFINE g_before_input_done STRING              
DEFINE g_chr         LIKE type_file.chr1       #No.FUN-680107 VARCHAR(1)
DEFINE g_cnt         LIKE type_file.num10      #No.FUN-680107 INTEGER
DEFINE g_i           LIKE type_file.num5       #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE g_msg         LIKE ze_file.ze03         #No.FUN-680107 VARCHAR(72)
 
DEFINE g_row_count   LIKE type_file.num10      #No.FUN-680107 INTEGER
DEFINE g_curs_index  LIKE type_file.num10      #No.FUN-680107 INTEGER
DEFINE g_jump        LIKE type_file.num10      #No.FUN-680107 INTEGER
DEFINE mi_no_ask     LIKE type_file.num5       #No.FUN-680107 SMALLINT
DEFINE g_void        LIKE type_file.chr1       #NO.FUN-680107 VARCHAR(01)
DEFINE g_argv1       LIKE oea_file.oea01       #No.FUN-630020 add #NO.FUN-680107 VARCHAR(16)
DEFINE g_argv2       STRING                    #No.FUN-630020 add
DEFINE g_str         STRING                    #No.FUN-670060                                                                                     
DEFINE g_wc_gl       STRING                    #No.FUN-670060  
DEFINE g_bookno1        LIKE aza_file.aza81   #No.FUN-730033
DEFINE g_bookno2        LIKE aza_file.aza82   #No.FUN-730033
DEFINE g_flag           LIKE type_file.chr1   #No.FUN-730033
DEFINE g_npq25          LIKE npq_file.npq25   #No.FUN-9A0036
DEFINE g_aag44          LIKE aag_file.aag44   #FUN-D40118 add
DEFINE g_bookno3        LIKE aza_file.aza81   #FUN-D40118 add
 
MAIN
DEFINE p_row,p_col   LIKE type_file.num5       #No.FUN-680107 SMALLINT
 
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
    LET g_argv1=ARG_VAL(1)          #No.FUN-630020 add
    LET g_argv2=ARG_VAL(2)          #No.FUN-630020 add
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
 
   INITIALIZE g_gse.* TO NULL
   INITIALIZE g_gse_t.* TO NULL
   INITIALIZE g_gse_o.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM gse_file WHERE gse01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t610_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   LET p_row = 4 LET p_col = 3
   OPEN WINDOW t610_w AT p_row,p_col
     WITH FORM "anm/42f/anmt610" ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   # 先以g_argv2判斷直接執行哪種功能
   # 執行I時，g_argv1是單號
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t610_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t610_a()
            END IF
         OTHERWISE
                CALL t610_q()
      END CASE
   END IF
   LET g_action_choice=""
 
   CALL t610_menu()
 
   CLOSE WINDOW t610_w
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
 
END MAIN
 
FUNCTION t610_cs()
 DEFINE l_gsb05         LIKE gsb_file.gsb05,  #投資種類
        l_gsb06         LIKE gsb_file.gsb06,  #投資標的
        l_gsa02         LIKE gsa_file.gsa02,  #投資種類名稱
        l_gsb10         LIKE gsb_file.gsb10,  #投資數量
        l_gsb09         LIKE gsb_file.gsb09,  #投資單位價格
        l_gsb101        LIKE gsb_file.gsb101, #投資金額
        l_gsb12         LIKE gsb_file.gsb12,  #留倉數量
        l_gsb121        LIKE gsb_file.gsb121, #留倉金額
        l_nml02         LIKE nml_file.nml02   #現金變動碼說明
 
    CLEAR FORM
 
    IF cl_null(g_argv1) THEN         #No.FUN-630020 add
   INITIALIZE g_gse.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON gse01,gse02,gse27,gse03,gseconf,gse21,gse22,  #FUN-710070 add gse27 #FUN-940036 拿掉gse11
                                 gse05,gse26,gse07,gse08,gse09,gse10,gse11,
                                 gse12,gse23,gse13,gse14,gse15,gse16,gse17,
                                 gse18,gse19,gse20,gse04,gse06,gse24,gse25,
                                 gseuser,gsegrup,gsemodu,gsedate
                                ,gseud01,gseud02,gseud03,gseud04,gseud05,
                                gseud06,gseud07,gseud08,gseud09,gseud10,
                                gseud11,gseud12,gseud13,gseud14,gseud15
     
                 BEFORE CONSTRUCT
                    CALL cl_qbe_init()
           ON ACTION CONTROLP
               CASE
                   WHEN INFIELD(gse27)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_gem"
                        LET g_qryparam.state= "c"
                        LET g_qryparam.default1 = g_gse.gse27
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gse27
 
                   WHEN INFIELD(gse01)
                       #LET g_t1 = s_get_doc_no(g_gse.gse01)       #No.FUN-550057         #MOD-B20020 mark
                       #CALL q_nmy(TRUE,FALSE,g_t1,'C','ANM') RETURNING g_t1  #TQC-670008 #MOD-B20020 mark
                       #LET g_gse.gse01 = g_t1       #No.FUN-550057                       #MOD-B20020 mark
                       #DISPLAY BY NAME g_gse.gse01                                       #MOD-B20020 mark
                       #-MOD-B20020-add-
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_gse"
                        LET g_qryparam.state= "c"
                        LET g_qryparam.default1 = g_gse.gse01
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gse01
                       #-MOD-B20020-end-
                        NEXT FIELD gse01
                   WHEN INFIELD(gse03)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_gsb"
                        LET g_qryparam.state= "c"
                        LET g_qryparam.default1 = g_gse.gse03
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gse03
                        NEXT FIELD gse03
                   WHEN INFIELD(gse11)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_nml"
                        LET g_qryparam.state= "c"
                        LET g_qryparam.default1 = g_gse.gse11
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gse11
                        NEXT FIELD gse11
                   WHEN INFIELD(gse10)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_nmc01"   #No.FUN-5A0004
                        LET g_qryparam.arg1 = "1"         #No.FUN-5A0004
                        LET g_qryparam.state= "c"
                        LET g_qryparam.default1 = g_gse.gse10
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gse10
                        NEXT FIELD gse10
                   WHEN INFIELD(gse07)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_nma"
                        LET g_qryparam.state= "c"
                        LET g_qryparam.default1 = g_gse.gse07
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gse07
                        NEXT FIELD gse07
                   WHEN INFIELD(gse08)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_azi"
                        LET g_qryparam.state= "c"
                        LET g_qryparam.default1 = g_gse.gse08
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gse08
                        NEXT FIELD gse08
                   WHEN INFIELD(gse13)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_gsf"
                        LET g_qryparam.state= "c"
                        LET g_qryparam.default1 = g_gse.gse13
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gse13
                        NEXT FIELD gse13
                   WHEN INFIELD(gse18)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_nml"
                        LET g_qryparam.state= "c"
                        LET g_qryparam.default1 = g_gse.gse18
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gse18
                        NEXT FIELD gse18
                   WHEN INFIELD(gse17)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_nmc01"   #No.FUN-5A0004
                        LET g_qryparam.arg1 = "2"         #No.FUN-5A0004  #No.FUN-5A0012
                        LET g_qryparam.state= "c"
                        LET g_qryparam.default1 = g_gse.gse17
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gse17
                        NEXT FIELD gse17
                   WHEN INFIELD(gse14)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_nma"
                        LET g_qryparam.state= "c"
                        LET g_qryparam.default1 = g_gse.gse14
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gse14
                        NEXT FIELD gse14
                   WHEN INFIELD(gse15)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_azi"
                        LET g_qryparam.state= "c"
                        LET g_qryparam.default1 = g_gse.gse15
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO gse15
                        NEXT FIELD gse15
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
            	   CALL cl_qbe_select()
                   ON ACTION qbe_save
           	   CALL cl_qbe_save()
       END CONSTRUCT
 
     ELSE
        LET g_wc =" gse01 = '",g_argv1,"'"
     END IF
    #資料權限的檢查
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gseuser', 'gsegrup')
 
 
    LET g_sql="SELECT gse01 FROM gse_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, " ORDER BY gse01"
    PREPARE t610_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t610_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t610_prepare
 
    LET g_sql = "SELECT COUNT(*) FROM gse_file WHERE ",g_wc CLIPPED
    PREPARE t610_precount FROM g_sql
    DECLARE t610_count CURSOR FOR t610_precount
 
END FUNCTION
 
FUNCTION t610_menu()
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
            IF cl_chk_act_auth() THEN
                 CALL t610_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t610_q()
            END IF
        ON ACTION next
            CALL t610_fetch('N')
        ON ACTION previous
            CALL t610_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t610_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t610_r()
            END IF
        ON ACTION output     
            LET g_action_choice="output"                     #No.CHI-B70050 add                                                   
            IF cl_chk_act_auth() THEN                                           
               IF NOT cl_null(g_wc) THEN                                        
                 #LET g_msg = 'anmr610 "',g_today,'" "',g_user,  #FUN-C30085 mark            
                  LET g_msg = 'anmg610 "',g_today,'" "',g_user,  #FUN-C30085 add
                              '" "',g_lang,'" ',' "Y" " " "1" "',g_gse.gse01,'" "N"'
                  CALL cl_cmdrun(g_msg)                                         
               END IF                                                           
            END IF                                                              
  
        ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
               CALL t610_firm1()
               IF g_gse.gseconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_gse.gseconf,"","","",g_void,"")
            END IF
 
        ON ACTION undo_confirm
            LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
                CALL t610_firm2()
                IF g_gse.gseconf = 'X' THEN
                   LET g_void = 'Y'
                ELSE
                   LET g_void = 'N'
                END IF
                CALL cl_set_field_pic(g_gse.gseconf,"","","",g_void,"")
            END IF

       #--------------FUN-D10116---------------(S)
        ON ACTION void
           LET g_action_choice = "void"
           IF cl_chk_act_auth() THEN
              CALL t610_x()
              IF g_gse.gseconf = 'X' THEN
                 LET g_void = 'Y'
              ELSE
                 LET g_void = 'N'
              END IF
              CALL cl_set_field_pic(g_gse.gseconf,"","","",g_void,"")
           END IF
       #--------------FUN-D10116---------------(E)
 
        ON ACTION gen_entry_sheet
           LET g_action_choice="gen_entry_sheet"                     #No.CHI-B70050 add
           IF cl_chk_act_auth() THEN                                 #No.CHI-B70050 add
              CALL t610_g_gl(g_gse.gse01,'0')
              IF g_aza.aza63 = 'Y' THEN
                 CALL t610_g_gl(g_gse.gse01,'1')
              END IF
           END IF                                                    #No.CHI-B70050 add
 
        ON ACTION maintain_entry_sheet
           LET g_action_choice="maintain_entry_sheet"                     #No.CHI-B70050 add
           IF cl_chk_act_auth() THEN                                      #No.CHI-B70050 add
              CALL s_fsgl('NM',20,g_gse.gse01,0,g_nmz.nmz02b,5,g_gse.gseconf,'0',g_nmz.nmz02p)      #No.FUN-680088
              CALL cl_navigator_setting( g_curs_index, g_row_count )      #No.FUN-680088
              CALL t610_npp02('0')      #No.FUN-680088
           END IF                                                         #No.CHI-B70050 add 

        ON ACTION maintain_entry_sheet2
           LET g_action_choice="maintain_entry_sheet2"                     #No.CHI-B70050 add
           IF cl_chk_act_auth() THEN                                      #No.CHI-B70050 add
              CALL s_fsgl('NM',20,g_gse.gse01,0,g_nmz.nmz02c,5,g_gse.gseconf,'1',g_nmz.nmz02p)
              CALL cl_navigator_setting( g_curs_index, g_row_count )
              CALL t610_npp02('1')
           END IF                                                          #No.CHI-B70050 add
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
           IF g_gse.gseconf = 'X' THEN
              LET g_void = 'Y'
           ELSE
              LET g_void = 'N'
           END IF
           CALL cl_set_field_pic(g_gse.gseconf,"","","",g_void,"")
 
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON ACTION jump
            CALL t610_fetch('/')
 
        ON ACTION first
            CALL t610_fetch('F')
 
        ON ACTION last
            CALL t610_fetch('L')
 
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
        ON ACTION carry_voucher #傳票拋轉
            IF cl_chk_act_auth() THEN
               IF g_gse.gseconf = 'Y' THEN 
                  CALL t610_carry_voucher()
               ELSE 
                  CALL cl_err('','atm-402',1)
               END IF 
            END IF
 
        ON ACTION undo_carry_voucher #傳票拋轉還原
            IF cl_chk_act_auth() THEN
               IF g_gse.gseconf = 'Y' THEN
                  CALL t610_undo_carry_voucher()  
               ELSE 
                  CALL cl_err('','atm-403',1)
               END IF  
            END IF
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_gse.gse01 IS NOT NULL THEN
                  LET g_doc.column1 = "gse01"
                  LET g_doc.value1 = g_gse.gse01
                  CALL cl_doc()
               END IF
           END IF
 
            LET g_action_choice = "exit"
            CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      &include "qry_string.4gl"
    END MENU
    CLOSE t610_cs
END FUNCTION
 
FUNCTION t610_a()
DEFINE   l_sta       LIKE type_file.chr4,   #NO.FUN-680107 VARCHAR(04)
         l_time      LIKE oay_file.oayslip  #NO.FUN-680107 VARCHAR(05)
DEFINE   li_result   LIKE type_file.num5    #No.FUN-550057 #No.FUN-680107 SMALLINT
 
   IF s_anmshut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM                                   # 清螢幕欄位內容
   INITIALIZE g_gse.* LIKE gse_file.*
   LET g_gse_t.*     = g_gse.*
   LET g_gse01_t     = NULL
   LET g_gse.gseuser = g_user
   LET g_gse.gseoriu = g_user #FUN-980030
   LET g_gse.gseorig = g_grup #FUN-980030
   LET g_gse.gsegrup = g_grup               #使用者所屬群
   LET g_gse.gsedate = g_today
   LET g_gse.gse02   = g_today
   LET g_gse.gseconf = 'N'
   LET g_gse.gse04 = 0
   LET g_gse.gse05 = 0
   LET g_gse.gse06 = 0
   LET g_gse.gse09 = 1
   LET g_gse.gse12 = 0
   LET g_gse.gse16 = 1
   LET g_gse.gse19 = 0
   LET g_gse.gse20 = 0
   LET g_gse.gse23 = 0
   LET g_gse.gse24 = 0
   LET g_gse.gse25 = 0
   LET g_gse.gse26 = 0   #No.FUN-5A0004
   LET g_gse.gselegal = g_legal  
   CALL cl_opmsg('a')
 
   WHILE TRUE
 
      CALL t610_i("a")                       # 各欄位輸入
 
      IF INT_FLAG THEN                       # 若按了DEL鍵
         LET INT_FLAG = 0
         INITIALIZE g_gse.* TO NULL
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF
 
      IF cl_null(g_gse.gse01) THEN# KEY 不可空白
          CONTINUE WHILE
      END IF
      BEGIN WORK  #No.7875
 
      CALL s_auto_assign_no("anm",g_gse.gse01,g_gse.gse02,"C","gse_file","gse01","","","")
           RETURNING li_result,g_gse.gse01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_gse.gse01
 
 
      INSERT INTO gse_file VALUES (g_gse.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","gse_file",g_gse.gse01,"",SQLCA.sqlcode,"","t610_ins_gse:",1)  #No.FUN-660148 #No.FUN-B80067---調整至回滾事務前---
         ROLLBACK WORK #No.7875
         LET g_success = 'N'
         CONTINUE WHILE
      ELSE
        #-MOD-AC0073-add-
         #---判斷是否立即confirm-----
         LET g_t1 = s_get_doc_no(g_gse.gse01)    
         SELECT nmydmy1,nmydmy3 INTO g_nmydmy1,g_nmydmy3
           FROM nmy_file
          WHERE nmyslip = g_t1 AND nmyacti = 'Y'
         IF g_nmydmy3 = 'Y' THEN
            IF cl_confirm('axr-309') THEN
               CALL t610_g_gl(g_gse.gse01,'0')
               IF g_aza.aza63 = 'Y' THEN
                  CALL t610_g_gl(g_gse.gse01,'1')
               END IF
            END IF
         END IF
         IF g_nmydmy1 = 'Y' AND g_nmydmy3='N' THEN CALL t610_firm1() END IF
        #-MOD-AC0073-end-
         COMMIT WORK #No.7875
         CALL cl_flow_notify(g_gse.gse01,'I')
      END IF
 
      SELECT gse01 INTO g_gse.gse01 FROM gse_file WHERE gse01 = g_gse.gse01
      LET g_gse_t.* = g_gse.*
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t610_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,  #No.FUN-680107 VARCHAR(1)
        l_flag          LIKE type_file.chr1,  #判斷必要欄位是否有輸入 #No.FUN-680107 VARCHAR(1)
        l_n             LIKE type_file.num10, #No.FUN-680107 INTEGER       
        g_t1            LIKE oay_file.oayslip,#No.FUN-550057 #No.FUN-680107 VARCHAR(5)
        l_gsb05         LIKE gsb_file.gsb05,  #投資種類
        l_gsb06         LIKE gsb_file.gsb06,  #投資標的
        l_gsb10         LIKE gsb_file.gsb10,  #投資數量
        l_gsb12         LIKE gsb_file.gsb12,  #留倉數量   #MOD-780251
        l_gsb121        LIKE gsb_file.gsb121, #留倉金額   #MOD-780251
        l_gsa02         LIKE gsa_file.gsa02,  #投資種類名稱
        l_gsbconf       LIKE gsb_file.gsbconf,
        l_gsf02         LIKE gsf_file.gsf02   #No.FUN-590111
DEFINE  li_result       LIKE type_file.num5   #No.FUN-550057 #No.FUN-680107 SMALLINT
DEFINE  l_cnt           LIKE type_file.num5   #FUN-710070 add
DEFINE  l_nmc01         LIKE nmc_file.nmc01   #存提異動碼
DEFINE  l_nmc03         LIKE nmc_file.nmc03   #存提別
DEFINE  l_gsb03         LIKE gsb_file.gsb03   #MOD-C30713 投資日期
 
   INPUT BY NAME g_gse.gseoriu,g_gse.gseorig,g_gse.gse01,g_gse.gse02,g_gse.gse27,g_gse.gse03,g_gse.gseconf,  #FUN-710070 add gse27
                 g_gse.gse21,g_gse.gse22,g_gse.gse05,g_gse.gse26,
                 g_gse.gse07,g_gse.gse08,g_gse.gse09,g_gse.gse10,
                 g_gse.gse11,g_gse.gse12,g_gse.gse23,g_gse.gse13,
                 g_gse.gse14,g_gse.gse15,g_gse.gse16,g_gse.gse17,
                 g_gse.gse18,g_gse.gse19,g_gse.gse20,g_gse.gse04,
                 g_gse.gse06,g_gse.gse24,g_gse.gse25,g_gse.gseuser,
                 g_gse.gsegrup,g_gse.gsemodu,g_gse.gsedate
                ,g_gse.gseud01,g_gse.gseud02,g_gse.gseud03,g_gse.gseud04,
                 g_gse.gseud05,g_gse.gseud06,g_gse.gseud07,g_gse.gseud08,
                 g_gse.gseud09,g_gse.gseud10,g_gse.gseud11,g_gse.gseud12,
                 g_gse.gseud13,g_gse.gseud14,g_gse.gseud15 
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t610_set_entry(p_cmd)
         CALL t610_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("gse01")
 
      AFTER FIELD gse01
        #IF NOT cl_null(g_gse.gse01) AND (g_gse.gse01!=g_gse_t.gse01) THEN     #MOD-BC0009 mark
         IF NOT cl_null(g_gse.gse01) THEN                                      #MOD-BC0009   
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_gse.gse01 != g_gse01_t) THEN  #MOD-BC0009
               CALL s_check_no("anm",g_gse.gse01,g_gse01_t,"C","gse_file","gse01","")
                    RETURNING li_result,g_gse.gse01
               DISPLAY BY NAME g_gse.gse01
               IF (NOT li_result) THEN
                  NEXT FIELD gse01
               END IF
            END IF    #MOD-BC0009
         END IF
 
      AFTER FIELD gse02
         IF g_gse.gse02 <= g_nmz.nmz10 THEN  #no.5261
            CALL cl_err('','aap-176',1)
            NEXT FIELD gse02
         END IF
 
      AFTER FIELD gse03
         IF NOT cl_null(g_gse.gse03) THEN
            IF cl_null(g_gse_t.gse03) OR g_gse.gse03 != g_gse_t.gse03 THEN
               LET l_gsbconf = ' '
               SELECT gsb05,gsb06,gsb09,gsb12,gsb121,gsb13,gsbconf,gsb03  #MOD-C30713 add gsb03   
                 INTO l_gsb05,l_gsb06,g_gse.gse04,g_gse.gse05,g_gse.gse06,   
                      g_gse.gse07,l_gsbconf,l_gsb03   #MOD-590401 #MOD-C30713 add l_gsb03
                 FROM gsb_file
                WHERE gsb01 = g_gse.gse03
                  AND gsbconf !='X' #010816增
               IF STATUS THEN
                   CALL cl_err3("sel","gsb_file",g_gse.gse03,"",STATUS,"","select gsb",1)  #No.FUN-660148
                   NEXT FIELD gse03
               END IF
               IF l_gsbconf <> 'Y' THEN
                  CALL cl_err(g_gse.gse03,'anm-960',0)
                  NEXT FIELD gse03
               END IF
               #MOD-C30713--add--str
               IF l_gsb03>g_gse.gse02 THEN
                  CALL cl_err(g_gse.gse03,'anm-192',0)
                  NEXT FIELD gse03
               END IF
               #MOD-C30713--add--end
 
               DISPLAY BY NAME g_gse.gse04   #TQC-630077
 
               SELECT gsa02 INTO l_gsa02 FROM gsa_FILE
                WHERE gsa01 = l_gsb05
               DISPLAY l_gsb05,l_gsb06,l_gsa02 TO gsb05,gsb06,gsa02
 
               SELECT nma10 INTO g_gse.gse08 FROM nma_file
                WHERE nma01 = g_gse.gse07
               LET g_gse.gse14 = g_gse.gse07
               LET g_gse.gse15 = g_gse.gse08
               DISPLAY BY NAME g_gse.gse04,g_gse.gse07,g_gse.gse08,  #MOD-590401
                               g_gse.gse14,g_gse.gse15,g_gse.gse05,
                               g_gse.gse06
            END IF
         END IF
 
      AFTER FIELD gse05   #平倉數量
         SELECT gsb10,gsb12,gsb121 INTO l_gsb10,l_gsb12,l_gsb121 FROM gsb_file   #MOD-780251
          WHERE gsb01 = g_gse.gse03 AND gsbconf != 'X'
         IF g_gse.gse05 > l_gsb12 THEN   #MOD-780251
            CALL cl_err('','anm-051',0)
            NEXT FIELD gse05
         END IF
         IF g_gse.gse05 = l_gsb12 THEN
            LET g_gse.gse06 = l_gsb121
         ELSE
            LET g_gse.gse06 = g_gse.gse04 * g_gse.gse05   #No.FUN-590111
         END IF
         LET g_gse.gse06 = cl_digcut(g_gse.gse06,g_azi04)   #TQC-630077
         SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_gse.gse08  #NO.CHI-6A0004      #MOD-760146
         IF STATUS THEN
            LET t_azi04 = 0  #NO.CHI-6A0004
         END IF
 
 
            LET g_gse.gse23 = cl_digcut(g_gse.gse05 * g_gse.gse26,g_azi04)
            LET g_gse.gse24 = g_gse.gse23 - g_gse.gse06
            LET g_gse.gse24 = cl_digcut(g_gse.gse24,g_azi04)   #TQC-630077
            LET g_gse.gse25 = g_gse.gse24 - g_gse.gse20
            LET g_gse.gse25 = cl_digcut(g_gse.gse25,g_azi04)   #TQC-630077
            LET g_gse.gse12 = cl_digcut(g_gse.gse23/g_gse.gse09,t_azi04)   #TQC-630077  #NO.CHI-6A0004
            DISPLAY BY NAME g_gse.gse06,g_gse.gse24,
                            g_gse.gse23,g_gse.gse25,g_gse.gse12
 
      AFTER FIELD gse26
         IF g_gse.gse26 < 0 THEN
            NEXT FIELD gse26
         END IF
            LET g_gse.gse23 = cl_digcut(g_gse.gse05 * g_gse.gse26,g_azi04)
            LET g_gse.gse24 = g_gse.gse23 - g_gse.gse06
            LET g_gse.gse24 = cl_digcut(g_gse.gse24,g_azi04)   #TQC-630077
            LET g_gse.gse25 = g_gse.gse24 - g_gse.gse20
            LET g_gse.gse25 = cl_digcut(g_gse.gse25,g_azi04)   #TQC-630077
            DISPLAY BY NAME g_gse.gse23,g_gse.gse24,g_gse.gse25
 
     AFTER FIELD gse27  #所屬部門
       IF NOT cl_null(g_gse.gse27) THEN
         LET l_cnt = 0 
         SELECT COUNT(gem01) INTO l_cnt FROM gem_file 
          WHERE gem01 = g_gse.gse27
            AND gemacti = 'Y'
         IF l_cnt = 0 THEN
           CALL cl_err('','mfg3097',0)
           NEXT FIELD CURRENT
         END IF 
       END IF
 
      BEFORE FIELD gse07
          CALL t610_set_entry(p_cmd)
 
      AFTER FIELD gse07
          IF NOT cl_null(g_gse.gse07) THEN
             SELECT nma10 INTO g_gse.gse08 FROM nma_file
              WHERE nma01 = g_gse.gse07
             IF STATUS THEN
                CALL cl_err3("sel","nma_file",g_gse.gse07,"",STATUS,"","select nma",1)  #No.FUN-660148
                NEXT FIELD gse07
             END IF
             DISPLAY BY NAME g_gse.gse08
 
             SELECT azi04 INTO t_azi04 FROM azi_file  #NO.CHI-6A0004
              WHERE azi01 = g_gse.gse08
             IF STATUS THEN
                LET t_azi04 = 0  #NO.CHI-6A0004
             END IF
 
                IF g_aza.aza17 = g_gse.gse08 THEN    #本幣
                   LET g_gse.gse09 = 1
                   LET g_gse.gse12 = g_gse.gse23   #No.FUN-5A0004
                   LET g_gse.gse12 = cl_digcut(g_gse.gse12,t_azi04)   #TQC-630077  #NO.CHI-6A0004
                ELSE
                   CALL s_curr3(g_gse.gse08,g_gse.gse02,'B')
                   RETURNING g_gse.gse09
                   LET g_gse.gse12 = g_gse.gse23 / g_gse.gse09   #TQC-630077   #MOD-760146
                   LET g_gse.gse12 = cl_digcut(g_gse.gse12,t_azi04)   #TQC-630077 #NO.CHI-6A0004
                END IF
                DISPLAY BY NAME g_gse.gse09,g_gse.gse12   #No.FUN-5A0004
             CALL t610_set_no_entry(p_cmd)   #No.FUN-5A0004
          END IF
 
       AFTER FIELD gse09   #匯率
          IF g_gse.gse08 =g_aza.aza17 THEN
             LET g_gse.gse09  =1
             DISPLAY BY NAME g_gse.gse09
          END IF
          SELECT azi04 INTO t_azi04 FROM azi_file  #NO.CHI-6A0004
           WHERE azi01 = g_gse.gse08
          IF STATUS THEN
             LET t_azi04 = 0                      #NO.CHI-6A0004
          END IF
          IF cl_null(g_gse_t.gse09) OR g_gse.gse09 != g_gse_t.gse09 THEN
                LET g_gse.gse12 = g_gse.gse23 / g_gse.gse09
                LET g_gse.gse12 = cl_digcut(g_gse.gse12,t_azi04)   #TQC-630077   #NO.CHI-6A0004
                DISPLAY BY NAME g_gse.gse12
          END IF
 
      AFTER FIELD gse10
          IF NOT cl_null(g_gse.gse10) THEN
             SELECT nmc01,nmc03 INTO l_nmc01,l_nmc03 FROM nmc_file 
              WHERE nmc01 = g_gse.gse10
             IF STATUS THEN
                CALL cl_err3("sel","nmc_file",g_gse.gse10,"",STATUS,"","select nmc",1)  
                NEXT FIELD gse10
             ELSE
                IF l_nmc03 !='1' THEN
                   CALL cl_err(g_gse.gse10,'anm-334',1) 
                   NEXT FIELD gse10
                END IF
             END IF
          END IF
 
      AFTER FIELD gse11
          IF NOT cl_null(g_gse.gse11) THEN
             SELECT nml02 FROM nml_file
              WHERE nml01 = g_gse.gse11
             IF STATUS THEN
                CALL cl_err3("sel","nml_file",g_gse.gse11,"",STATUS,"","select nml",1)  #No.FUN-660148
                NEXT FIELD gse11
             END IF
          END IF
 
      AFTER FIELD gse12
          IF g_gse.gse12 < 0 THEN
             NEXT FIELD gse12
          END IF
          SELECT azi04 INTO t_azi04 FROM azi_file  #NO.CHI-6A0004
           WHERE azi01 = g_gse.gse08
          IF STATUS THEN
             LET t_azi04 = 0                       #NO.CHI-6A0004
          END IF
          LET g_gse.gse12 = cl_digcut(g_gse.gse12,t_azi04)  #NO.CHI-6A0004
 
 
      AFTER FIELD gse13
         IF NOT cl_null(g_gse.gse13) THEN
            SELECT gsf02 INTO l_gsf02
              FROM gsf_file
             WHERE gsf01 = g_gse.gse13
             IF STATUS THEN
                CALL cl_err3("sel","gsf_file",g_gse.gse13,"",STATUS,"","select nml",1)  #No.FUN-660148
                NEXT FIELD gse13
             END IF
             DISPLAY l_gsf02 TO gsf02
          END IF
 
      BEFORE FIELD gse14
          CALL t610_set_entry(p_cmd)
 
      AFTER FIELD gse14
          IF NOT cl_null(g_gse.gse14) THEN
             SELECT nma10 INTO g_gse.gse15 FROM nma_file
              WHERE nma01 = g_gse.gse14
             IF STATUS THEN
                CALL cl_err3("sel","nma_file",g_gse.gse14,"",STATUS,"","select nma",1)  #No.FUN-660148
                NEXT FIELD gse14
             END IF
             DISPLAY BY NAME g_gse.gse15
 
             SELECT azi04 INTO t_azi04 FROM azi_file #NO.CHI-6A0004
              WHERE azi01 = g_gse.gse15
             IF STATUS THEN
                LET t_azi04 = 0             #NO.CHI-6A0004
             END IF
 
             IF cl_null(g_gse_t.gse14) OR g_gse.gse14 != g_gse_t.gse14 THEN
                IF g_aza.aza17 = g_gse.gse15 THEN    #本幣
                   LET g_gse.gse16 = 1
                   LET g_gse.gse19 = g_gse.gse20   #No.FUN-5A0004
                ELSE
                   CALL s_curr3(g_gse.gse15,g_gse.gse02,'B')
                   RETURNING g_gse.gse16
                   LET g_gse.gse19 = cl_digcut(g_gse.gse20/g_gse.gse16,t_azi04)   #TQC-630077  #NO.CHI-6A0004
                END IF
                DISPLAY BY NAME g_gse.gse16,g_gse.gse19   #No.FUN-5A0004
                IF g_gse.gse20 = 0 THEN
                   LET g_gse.gse20 = g_gse.gse19 * g_gse.gse16
                   LET g_gse.gse20 = cl_digcut(g_gse.gse20,g_azi04)
                   LET g_gse.gse25 = g_gse.gse24 - g_gse.gse20
                   LET g_gse.gse25 = cl_digcut(g_gse.gse25,g_azi04)   #TQC-630077
                   DISPLAY BY NAME g_gse.gse20,g_gse.gse25
                END IF
             END IF
             CALL t610_set_no_entry(p_cmd)   #No.FUN-5A0004
          END IF
 
      AFTER FIELD gse16   #匯率
          IF g_gse.gse15 =g_aza.aza17 THEN
             LET g_gse.gse16  =1
             DISPLAY BY NAME g_gse.gse16
          END IF
          IF cl_null(g_gse_t.gse16) OR g_gse.gse16 != g_gse_t.gse16 THEN
             IF g_gse.gse20 = 0 THEN
                LET g_gse.gse20 = g_gse.gse19 * g_gse.gse16
                LET g_gse.gse20 = cl_digcut(g_gse.gse20,g_azi04)
                LET g_gse.gse25 = g_gse.gse24 - g_gse.gse20
                LET g_gse.gse25 = cl_digcut(g_gse.gse25,g_azi04)   #TQC-630077
                DISPLAY BY NAME g_gse.gse20,g_gse.gse25
             END IF
          END IF
 
      AFTER FIELD gse17
          IF NOT cl_null(g_gse.gse17) THEN
             SELECT nmc01,nmc03 INTO l_nmc01,l_nmc03 FROM nmc_file 
              WHERE nmc01 = g_gse.gse17
             IF STATUS THEN
                CALL cl_err3("sel","nmc_file",g_gse.gse17,"",STATUS,"","select nmc",1)  
                NEXT FIELD gse17
             ELSE
                IF l_nmc03 !='2' THEN
                   CALL cl_err(g_gse.gse17,'anm-333',1) 
                   NEXT FIELD gse17
                END IF
             END IF
          END IF
 
      AFTER FIELD gse18
          IF NOT cl_null(g_gse.gse18) THEN
             SELECT nml02 FROM nml_file
              WHERE nml01 = g_gse.gse18
             IF STATUS THEN
                CALL cl_err3("sel","nml_file",g_gse.gse18,"",STATUS,"","select nml",1)  #No.FUN-660148
                NEXT FIELD gse18
             END IF
          END IF
 
      AFTER FIELD gse19
          IF g_gse.gse19 < 0 THEN
             NEXT FIELD gse19
          END IF
          IF cl_null(g_gse_t.gse19) OR g_gse.gse19 != g_gse_t.gse19 THEN
             IF g_gse.gse20 = 0 THEN
                LET g_gse.gse20 = g_gse.gse19 * g_gse.gse16
                LET g_gse.gse20 = cl_digcut(g_gse.gse20,g_azi04)
                LET g_gse.gse25 = g_gse.gse24 - g_gse.gse20
                LET g_gse.gse25 = cl_digcut(g_gse.gse25,g_azi04)   #TQC-630077
                DISPLAY BY NAME g_gse.gse20,g_gse.gse25
             END IF
          END IF
 
      AFTER FIELD gse20
          IF g_gse.gse20 < 0 THEN
             NEXT FIELD gse20
          END IF
          #default 損益金額(gse25)=投資毛利(gse24)-費用金額(gse20)
          LET g_gse.gse25 = g_gse.gse24 - g_gse.gse20
          LET g_gse.gse25 = cl_digcut(g_gse.gse25,g_azi04)   #TQC-630077
             SELECT azi04 INTO t_azi04 FROM azi_file  #NO.CHI-6A0004
              WHERE azi01 = g_gse.gse15
             IF STATUS THEN
                LET t_azi04 = 0                #NO.CHI-6A0004
             END IF
             LET g_gse.gse19 = cl_digcut(g_gse.gse20/g_gse.gse16,t_azi04) #NO.CHI-6A0004
              DISPLAY BY NAME g_gse.gse19
          DISPLAY BY NAME g_gse.gse25
 
      AFTER FIELD gse23   #平倉售價
          IF g_gse.gse23 < 0 THEN
             NEXT FIELD gse23
          END IF
          #default 投資毛利(gse24)=平倉售價(gse23)-平倉金額(gse06)
          LET g_gse.gse24 = g_gse.gse23 - g_gse.gse06
          LET g_gse.gse24 = cl_digcut(g_gse.gse24,g_azi04)   #TQC-630077
          LET g_gse.gse25 = g_gse.gse24 - g_gse.gse20
          LET g_gse.gse25 = cl_digcut(g_gse.gse25,g_azi04)   #TQC-630077
          DISPLAY BY NAME g_gse.gse24,g_gse.gse25
          SELECT azi04 INTO t_azi04 FROM azi_file   #NO.CHI-6A0004
           WHERE azi01 = g_gse.gse08
          IF STATUS THEN
             LET t_azi04 = 0    #NO.CHI-6A0004
          END IF
          IF g_gse.gse09 = 1 THEN
             LET g_gse.gse12 = g_gse.gse23
             DISPLAY BY NAME g_gse.gse12
          ELSE
             IF cl_null(g_gse_t.gse23) OR g_gse_t.gse23 != g_gse.gse23 THEN
                   LET g_gse.gse12 = g_gse.gse23 * g_gse.gse09
                   LET g_gse.gse12 = cl_digcut(g_gse.gse12,t_azi04)   #NO.CHI-6A0004
                   DISPLAY BY NAME g_gse.gse12   #TQC-630077
             END IF
          END IF
 
        AFTER FIELD gseud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gseud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gseud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gseud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gseud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gseud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gseud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gseud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gseud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gseud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gseud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gseud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gseud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gseud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gseud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         LET g_gse.gseuser = s_get_data_owner("gse_file") #FUN-C10039
         LET g_gse.gsegrup = s_get_data_group("gse_file") #FUN-C10039
          IF INT_FLAG THEN
             EXIT INPUT
          END IF
 
 
      ON ACTION CONTROLP
          CASE
              WHEN INFIELD(gse27)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem"
                   LET g_qryparam.default1 = g_gse.gse27
                   CALL cl_create_qry() RETURNING g_gse.gse27
                   DISPLAY BY NAME g_gse.gse27
                   NEXT FIELD gse27
              WHEN INFIELD(gse01)
                   LET g_t1 = s_get_doc_no(g_gse.gse01)       #No.FUN-550057
                   CALL q_nmy(FALSE,FALSE,g_t1,'C','ANM') RETURNING g_t1  #TQC-670008
                   LET g_gse.gse01 = g_t1                #No.FUN-550057
                   DISPLAY BY NAME g_gse.gse01
                   NEXT FIELD gse01
              WHEN INFIELD(gse03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gsb"
                   LET g_qryparam.default1 = g_gse.gse03
                   CALL cl_create_qry() RETURNING g_gse.gse03
                   SELECT gsb05,gsb06 INTO l_gsb05,l_gsb06   #No.FUN-590111
                   FROM gsb_file WHERE gsb01 = g_gse.gse03
                                   AND gsbconf !='X' #010816增
                   SELECT gsa02 INTO l_gsa02 FROM gsa_FILE
                       WHERE gsa01 = l_gsb05
                   DISPLAY l_gsb05,l_gsb06,l_gsa02 TO gsb05,gsb06,gsa02
                   NEXT FIELD gse03
              WHEN INFIELD(gse11)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_nml"
                   LET g_qryparam.default1 = g_gse.gse11
                   CALL cl_create_qry() RETURNING g_gse.gse11
                   DISPLAY BY NAME g_gse.gse11
                   NEXT FIELD gse11
              WHEN INFIELD(gse10)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_nmc01"   #No.FUN-5A0004
                   LET g_qryparam.arg1 = "1"         #No.FUN-5A0004
                   LET g_qryparam.default1 = g_gse.gse10
                   CALL cl_create_qry() RETURNING g_gse.gse10
                   DISPLAY BY NAME g_gse.gse10
                   NEXT FIELD gse10
              WHEN INFIELD(gse07)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_nma"
                   LET g_qryparam.default1 = g_gse.gse07
                   CALL cl_create_qry() RETURNING g_gse.gse07
                   DISPLAY BY NAME g_gse.gse07
                   NEXT FIELD gse07
              WHEN INFIELD(gse09)
                   CALL s_rate(g_gse.gse08,g_gse.gse09) RETURNING g_gse.gse09
                   DISPLAY BY NAME g_gse.gse09
                   NEXT FIELD gse09
              WHEN INFIELD(gse13)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gsf"
                   LET g_qryparam.default1 = g_gse.gse13
                   CALL cl_create_qry() RETURNING g_gse.gse13
                   DISPLAY BY NAME g_gse.gse13
                   NEXT FIELD gse13
              WHEN INFIELD(gse18)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_nml"
                   LET g_qryparam.default1 = g_gse.gse18
                   CALL cl_create_qry() RETURNING g_gse.gse18
                   DISPLAY BY NAME g_gse.gse18
                   NEXT FIELD gse18
              WHEN INFIELD(gse17)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_nmc01"   #No.FUN-5A0004
                   LET g_qryparam.arg1 = "2"         #No.FUN-5A0004  #No.FUN-5A0012
                   LET g_qryparam.default1 = g_gse.gse17
                   CALL cl_create_qry() RETURNING g_gse.gse17
                   DISPLAY BY NAME g_gse.gse17
                   NEXT FIELD gse17
              WHEN INFIELD(gse14)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_nma"
                   LET g_qryparam.default1 = g_gse.gse14
                   CALL cl_create_qry() RETURNING g_gse.gse14
                   DISPLAY BY NAME g_gse.gse14
                   NEXT FIELD gse14
              WHEN INFIELD(gse16)
                   CALL s_rate(g_gse.gse15,g_gse.gse16) RETURNING g_gse.gse16
                   DISPLAY BY NAME g_gse.gse16
                   NEXT FIELD gse16
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
 
FUNCTION t610_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_gse.* TO NULL              #No.FUN-6A0011
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t610_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t610_count
    FETCH t610_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t610_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gse.gse01,SQLCA.sqlcode,0)
        INITIALIZE g_gse.* TO NULL
    ELSE
        CALL t610_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t610_fetch(p_flgse)
    DEFINE
        p_flgse  LIKE type_file.chr1,    #處理的方式  #NO.FUN-680107 VARCHAR(1)
        l_abso   LIKE type_file.num10    #絕對的筆數  #No.FUN-680107 INTEGER
 
    CASE p_flgse
        WHEN 'N' FETCH NEXT     t610_cs INTO g_gse.gse01
        WHEN 'P' FETCH PREVIOUS t610_cs INTO g_gse.gse01
        WHEN 'F' FETCH FIRST    t610_cs INTO g_gse.gse01
        WHEN 'L' FETCH LAST     t610_cs INTO g_gse.gse01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt mod
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
            FETCH ABSOLUTE g_jump t610_cs INTO g_gse.gse01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gse.gse01,SQLCA.sqlcode,0)
        INITIALIZE g_gse.* TO NULL   #TQC-5A0041
        RETURN
    ELSE
       CASE p_flgse
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_gse.* FROM gse_file    # 重讀DB,因TEMP有不被更新特性
        WHERE gse01 = g_gse.gse01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","gse_file",g_gse.gse01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
    ELSE
       LET g_data_owner = g_gse.gseuser     #No.FUN-4C0063
       LET g_data_group = g_gse.gsegrup     #No.FUN-4C0063
       CALL t610_show()                      # 重新顯示
    END IF
 
END FUNCTION
 
FUNCTION t610_show()
DEFINE  l_gsb05    LIKE gsb_file.gsb05,    #投資種類
        l_gsa02    LIKE gsa_file.gsa02,    #投資種類名稱
        l_gsb06    LIKE gsb_file.gsb06,    #投資標的
        l_gsf02    LIKE gsf_file.gsf02     #No.FUN-590111
 
    LET g_gse_t.* = g_gse.*
 
    DISPLAY BY NAME g_gse.gse01,g_gse.gse02,g_gse.gse03,g_gse.gse04, g_gse.gseoriu,g_gse.gseorig,
                    g_gse.gse05,g_gse.gse06,g_gse.gse07,g_gse.gse08,
                    g_gse.gse09,g_gse.gse10,g_gse.gse11,g_gse.gse12,
                    g_gse.gse13,g_gse.gse14,g_gse.gse15,g_gse.gse16,
                    g_gse.gse17,g_gse.gse18,g_gse.gse19,g_gse.gse20,
                    g_gse.gse21,g_gse.gse22,g_gse.gse23,g_gse.gse24,
                    g_gse.gse25,g_gse.gse26,g_gse.gseconf,g_gse.gseuser, #No.FUN-5A0004
                    g_gse.gsegrup,g_gse.gsemodu,g_gse.gsedate,g_gse.gse27  #FUN-710070 add gse27
                   ,g_gse.gseud01,g_gse.gseud02,g_gse.gseud03,g_gse.gseud04,
                    g_gse.gseud05,g_gse.gseud06,g_gse.gseud07,g_gse.gseud08,
                    g_gse.gseud09,g_gse.gseud10,g_gse.gseud11,g_gse.gseud12,
                    g_gse.gseud13,g_gse.gseud14,g_gse.gseud15 
 
 
    SELECT gsb05,gsb06 INTO l_gsb05,l_gsb06
      FROM gsb_file
     WHERE gsb01 = g_gse.gse03
       AND gsbconf !='X' #010816增
    DISPLAY l_gsb05,l_gsb06 TO gsb05,gsb06
 
    SELECT gsf02 INTO l_gsf02 FROM gsf_file
     WHERE gsf01 = g_gse.gse13
    DISPLAY l_gsf02 TO gsf02
 
    SELECT gsa02 INTO l_gsa02 FROM gsa_file
     WHERE gsa01 = l_gsb05
    DISPLAY l_gsa02 TO gsa02
 
    IF g_gse.gseconf = 'X' THEN
       LET g_void = 'Y'
    ELSE
       LET g_void = 'N'
    END IF
 
   #------------------------FUN-D10116---------------------------(S)
    IF g_gse.gseconf = 'X' THEN
       LET g_void = 'Y'
    ELSE
       LET g_void = 'N'
    END IF
   #------------------------FUN-D10116---------------------------(E)
    CALL cl_set_field_pic(g_gse.gseconf,"","","",g_void,"")
 
END FUNCTION
 
FUNCTION t610_u()
    IF s_anmshut(0) THEN RETURN END IF
    IF g_gse.gse01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_gse.gseconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    SELECT * INTO g_gse.* FROM gse_file WHERE gse01 = g_gse.gse01
    IF g_gse.gseconf = 'Y' THEN  CALL cl_err('','anm-137',0) RETURN END IF
   #----------------FUN-D10116-------------(S)
    IF g_gse.gseconf = 'X' THEN
       CALL cl_err(g_gse.gse01,'9024',0)
       RETURN
    END IF
   #----------------FUN-D10116-------------(E)

    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_gse01_t = g_gse.gse01
    LET g_gse_o.*=g_gse.*
 
    LET g_success = 'Y'
    BEGIN WORK
 
    OPEN t610_cl USING g_gse.gse01
    IF STATUS THEN
       CALL cl_err("OPEN t610_cl:", STATUS, 1)
       CLOSE t610_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t610_cl INTO g_gse.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gse.gse01,SQLCA.sqlcode,0)
        RETURN
    END IF
 
    LET g_gse.gsemodu = g_user                     #修改者
    LET g_gse.gsedate = g_today                  #修改日期
 
    CALL t610_show()                          # 顯示最新資料
 
    WHILE TRUE
 
        CALL t610_i("u")                      # 欄位更改
 
        IF INT_FLAG THEN
            LET INT_FLAG = 0 LET g_success = 'N'
            LET g_gse.*=g_gse_t.*
            CALL t610_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
 
        UPDATE gse_file SET gse_file.* = g_gse.*    # 更新DB
         WHERE gse01 = g_gse.gse01             # COLAUTH?
        IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL cl_err3("upd","gse_file",g_gse.gse01,"",SQLCA.sqlcode,"","t610_u:gse",1)  #No.FUN-660148
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
 
    CLOSE t610_cl
 
    IF g_success = 'Y'THEN
       CALL cl_cmmsg(1)
       COMMIT WORK
       CALL cl_flow_notify(g_gse.gse01,'U')
    ELSE
       CALL cl_rbmsg(1)
       ROLLBACK WORK
    END IF
 
END FUNCTION
 
FUNCTION t610_firm1()
   DEFINE l_gse01_old   LIKE gse_file.gse01
   DEFINE l_nme         RECORD LIKE nme_file.*
   DEFINE l_gsc         RECORD LIKE gsc_file.*,
          l_t           LIKE oay_file.oayslip,   #No.MOD-5A0269 #NO.FUN-680107 VARCHAR(5)
          l_nmydmy3     LIKE nmy_file.nmydmy3
   DEFINE l_nmyglcr     LIKE nmy_file.nmyglcr    #No.FUN-670060                                                                   
   DEFINE l_nmygslp     LIKE nmy_file.nmygslp    #No.FUN-670060                                                                   
   DEFINE l_n           LIKE type_file.num5      #No.FUN-670060 #No.FUN-680107 SMALLINT
#FUN-B30166--add--str
  DEFINE l_year     LIKE type_file.chr4
  DEFINE l_month    LIKE type_file.chr4
  DEFINE l_day      LIKE type_file.chr4
  DEFINE l_dt       LIKE type_file.chr20
  DEFINE l_date1    LIKE type_file.chr20
  DEFINE l_time     LIKE type_file.chr20
  DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end
 
   LET g_success='Y'                             #No.FUN-670060 
 
   IF cl_null(g_gse.gse01) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
 
 
   LET l_gse01_old = g_gse.gse01
   LET g_success = 'Y'
 
   IF g_gse.gseconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
 
   IF g_gse.gseconf = 'Y' THEN
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
   IF g_gse.gse02 <= g_nmz.nmz10 THEN #no.5261
      CALL cl_err(g_gse.gse01,'aap-176',1)
      RETURN
   END IF
 
   IF NOT cl_sure(20,20) THEN
      RETURN
   END IF
 
   LET g_success = "Y"
   BEGIN WORK
 
   #判斷該單別是否須拋轉總帳
   LET l_t = s_get_doc_no(g_gse.gse01)        #No.MOD-5A0269
   SELECT nmydmy3,nmyglcr INTO l_nmydmy3,l_nmyglcr FROM nmy_file WHERE nmyslip = l_t  #No.FUN-670060
   IF STATUS OR cl_null(l_nmydmy3) THEN
      LET l_nmydmy3 = 'N'
   END IF
 
   CALL s_get_bookno(YEAR(g_gse.gse02)) RETURNING g_flag,g_bookno1,g_bookno2   #No.TQC-740042
   IF g_flag =  '1' THEN  #抓不到帳別
      CALL cl_err(g_gse.gse02,'aoo-081',1)
   END IF
 
   IF l_nmydmy3 = 'Y' AND l_nmyglcr = 'N' THEN  #若單別須拋轉總帳, 檢查分錄底稿平衡正確否   #No.FUN-670060
      CALL s_chknpq(g_gse.gse01,'NM',5,'0',g_bookno1)     #No.FUN-730033
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
         CALL s_chknpq(g_gse.gse01,'NM',5,'1',g_bookno1)  #No.FUN-730033
      END IF
      IF g_success ='N' THEN RETURN END IF
   END IF
 
   OPEN t610_cl USING g_gse.gse01
   IF STATUS THEN
      CALL cl_err("OPEN t610_cl:", STATUS, 1)
      CLOSE t610_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t610_cl INTO g_gse.*#鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gse.gse01,SQLCA.sqlcode,0)#資料被他人LOCK
      CLOSE t610_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF l_nmydmy3 = 'Y' AND l_nmyglcr = 'Y' THEN   
      CALL s_get_doc_no(g_gse.gse01) RETURNING l_t
      SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip= l_t  
      SELECT COUNT(*) INTO l_n FROM npq_file  
       WHERE npqsys='NM' AND npq00=20 AND npq01=g_gse.gse01 AND npq011=5  
      IF l_n = 0 THEN 
         CALL t610_gen_glcr(g_gse.*,g_nmy.*)  
      END IF
      IF g_success = 'Y' THEN 
         CALL s_chknpq(g_gse.gse01,'NM',5,'0',g_bookno1)
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL s_chknpq(g_gse.gse01,'NM',5,'1',g_bookno1)
         END IF
         IF g_success = 'N' THEN
            RETURN
         END IF
      END IF
   END IF
 
   #---UPDATE gsb
   UPDATE gsb_file SET gsb15  = gsb15  + g_gse.gse20, #支出總額  #No.FUN-5A0004
                       gsb16  = gsb16  + g_gse.gse25, #累計損益  #No.FUN-5A0004
                       gsb11  = gsb11  + g_gse.gse05, #平倉數量
                       gsb111 = gsb111 + g_gse.gse06, #平倉金額
                       gsb12  = gsb12  - g_gse.gse05, #留倉數量
                       gsb121 = gsb121 - g_gse.gse06  #留倉金額
    WHERE gsb01 = g_gse.gse03
   IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err3("upd","gsb_file",g_gse.gse03,"",STATUS,"","upd gsb",1)  #No.FUN-660148
       LET g_success = 'N'
   END IF
 
   #---投資金額
   INITIALIZE l_nme.* TO NULL     #No.TQC-A30008
   LET l_nme.nme00 = 0
   LET l_nme.nme01 = g_gse.gse07
   LET l_nme.nme02 = g_gse.gse02
   LET l_nme.nme03 = g_gse.gse10
   LET l_nme.nme04 = g_gse.gse12
   LET l_nme.nme07 = g_gse.gse09
   LET l_nme.nme08 = g_gse.gse23
   LET l_nme.nme12 = g_gse.gse01
   LET l_nme.nme14 = g_gse.gse11
   LET l_nme.nme16 = g_gse.gse02
   LET l_nme.nme17 = ' '
   LET l_nme.nmeacti='Y'
   LET l_nme.nmeuser=g_user
   LET l_nme.nmegrup=g_grup
   LET l_nme.nmedate=TODAY
   LET l_nme.nme21 = 1
   LET l_nme.nme22 = '23'
   LET l_nme.nme23 = ''
   LET l_nme.nme24 = '9'  #No.TQC-750098
   LET l_nme.nme25 = ''
   LET l_nme.nme26 = 'N'  #No.TQC-A30008 
   LET l_nme.nmelegal = g_legal  
 
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
      CALL cl_err3("ins","nme_file",l_nme.nme02,"",STATUS,"","ins nme:",1)  #No.FUN-660148
      LET g_success = 'N'
   END IF
 
   #---投資費用
   INITIALIZE l_nme.* TO NULL     #No.TQC-A30008
   LET l_nme.nme00 = 0
   LET l_nme.nme01 = g_gse.gse14
   LET l_nme.nme02 = g_gse.gse02
   LET l_nme.nme03 = g_gse.gse17
   LET l_nme.nme04 = g_gse.gse19
   LET l_nme.nme07 = g_gse.gse16
   LET l_nme.nme08 = g_gse.gse20
   LET l_nme.nme12 = g_gse.gse01
   LET l_nme.nme14 = g_gse.gse18
   LET l_nme.nme16 = g_gse.gse02
   LET l_nme.nme17 = ' '
   LET l_nme.nmeacti='Y'
   LET l_nme.nmeuser=g_user
   LET l_nme.nmegrup=g_grup
   LET l_nme.nmedate=TODAY
 # LET l_nme.nme21 = 1        #TQC-AB0326 mark
   LET l_nme.nme21 = 2        #TQC-AB0326 add
   LET l_nme.nme22 = '23'
   LET l_nme.nme23 = ''
   LET l_nme.nme24 = '9'  #No.TQC-750098
   LET l_nme.nme25 = ''
   LET l_nme.nme26 = 'N'  #No.TQC-A30008 
   LET l_nme.nmelegal = g_legal  
 
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
      CALL cl_err3("ins","nme_file",l_nme.nme02,"",STATUS,"","ins nme:",1)  #No.FUN-660148
      LET g_success = 'N'
   END IF
   CALL s_flows_nme(l_nme.*,'1',g_plant)   #No.FUN-B90062  
   #---UPDATE gsc
   INITIALIZE l_gsc.* TO NULL      #No.TQC-A30012
   LET l_gsc.gsc01 = g_gse.gse03
   LET l_gsc.gsc02 = g_gse.gse01
   LET l_gsc.gsc03 = g_gse.gse02
   LET l_gsc.gsc04 = g_gse.gse05
   LET l_gsc.gsc05 = g_gse.gse26   #No.FUN-5A0012
   LET l_gsc.gsc06 = g_gse.gse23
   LET l_gsc.gsc07 = -1
   LET l_gsc.gsc08 = g_gse.gse13
   LET l_gsc.gsc09 = g_gse.gse20
 
   LET l_gsc.gsclegal = g_legal  
 
   INSERT INTO gsc_file VALUES(l_gsc.*)
   IF STATUS THEN
      CALL cl_err3("ins","gsc_file",l_gsc.gsc01,l_gsc.gsc02,STATUS,"","ins gsc:",1)  #No.FUN-660148
      LET g_success = 'N'
   END IF
 
   #---UPDATE gse
   UPDATE gse_file SET gseconf = 'Y' WHERE gse01 = g_gse.gse01
   IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err3("upd","gse_file",g_gse.gse01,"",STATUS,"","upd gseconf",1)  #No.FUN-660148
       LET g_success = 'N'
   END IF
 
   IF g_success='N' THEN
      LET g_gse.gseconf = 'N'
      ROLLBACK WORK
   ELSE
      LET g_gse.gseconf = 'Y'
      COMMIT WORK
      CALL cl_flow_notify(g_gse.gse01,'Y')
      CALL cl_cmmsg(1)
   END IF
 
   DISPLAY g_gse.gseconf TO gseconf
 
    IF l_nmydmy3 = 'Y' AND l_nmyglcr = 'Y' AND g_success = 'Y' THEN                                                                 
       LET g_wc_gl = 'npp01="',g_gse.gse01 CLIPPED,'" AND npp011=5 '
       LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmy.nmygslp,"' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"' '",g_gse.gse02,"' 'Y' '1' 'Y'"   #No.FUN-680088#FUN-860040
       CALL cl_cmdrun_wait(g_str)                                                                                                   
       SELECT gse21,gse22 INTO g_gse.gse21,g_gse.gse22 FROM gse_file                                                                              
        WHERE gse01 = g_gse.gse01                                                                                                   
       DISPLAY BY NAME g_gse.gse21,g_gse.gse22
    END IF                                                                                                                          
    CALL cl_set_field_pic(g_gse.gseconf,"","","","N","")   #MOD-AC0073
 
END FUNCTION
 
FUNCTION t610_firm2()
   DEFINE l_gse01_old LIKE gse_file.gse01
   DEFINE l_aba19     LIKE aba_file.aba19   #No.FUN-670060                                                                              
   DEFINE l_dbs       STRING                #No.FUN-670060                                                                              
   DEFINE l_sql       STRING 
   DEFINE l_nme24     LIKE nme_file.nme24   #No.FUN-730032
 
   IF cl_null(g_gse.gse01) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
 
   LET l_gse01_old=g_gse.gse01       # backup old key value gse01
 
   IF g_gse.gseconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
 
   IF g_gse.gseconf = 'N' THEN RETURN END IF
 
 
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p1 FROM g_sql
   EXECUTE nmz10_p1 INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_gse.gse02 <= g_nmz.nmz10 THEN #no.5261
      CALL cl_err(g_gse.gse01,'aap-176',1) RETURN
   END IF
 
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_gse.gse01) RETURNING g_t1 
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   IF NOT cl_null(g_gse.gse21) THEN
      IF NOT (g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y') THEN
         CALL cl_err(g_gse.gse01,'axr-370',0) RETURN
      END IF
   END IF
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN
      #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
      #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                  "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                  "    AND aba01 = '",g_gse.gse21,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
      PREPARE aba_pre FROM l_sql
      DECLARE aba_cs CURSOR FOR aba_pre
      OPEN aba_cs
      FETCH aba_cs INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_gse.gse21,'axr-071',1)
         RETURN
      END IF
   END IF
 
   IF NOT cl_sure(20,20) THEN RETURN END IF
 
   LET g_success='Y'

   #CHI-C90052 begin---
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr='Y' THEN
      LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gse.gse21,"' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT gse21,gse22 INTO g_gse.gse21,g_gse.gse22 FROM gse_file
       WHERE gse01 = g_gse.gse01
      IF NOT cl_null(g_gse.gse21) THEN
         CALL cl_err(g_gse.gse21,'aap-929',1)
         RETURN
      END IF
      DISPLAY BY NAME g_gse.gse21,g_gse.gse22
   END IF
   #CHI-C90052 end-----

   BEGIN WORK
 
   OPEN t610_cl USING g_gse.gse01
   IF STATUS THEN
      CALL cl_err("OPEN t610_cl:", STATUS, 1)
      CLOSE t610_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t610_cl INTO g_gse.*#鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gse.gse01,SQLCA.sqlcode,0)#資料被他人LOCK
      CLOSE t610_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   #---UPDATE gsb
   UPDATE gsb_file SET gsb15  = gsb15  - g_gse.gse20, #支出總額  #No.FUN-5A0004
                       gsb16  = gsb16  - g_gse.gse25, #累計損益  #No.FUN-5A0004
                       gsb11  = gsb11  - g_gse.gse05, #平倉數量
                       gsb111 = gsb111 - g_gse.gse06, #平倉金額
                       gsb12  = gsb12  + g_gse.gse05, #留倉數量
                       gsb121 = gsb121 + g_gse.gse06  #留倉金額
    WHERE gsb01 = g_gse.gse03
   IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("upd","gsb_file",g_gse.gse03,"",STATUS,"","upd gsb",1)  #No.FUN-660148
      LET g_success = 'N'
   END IF
 
   IF g_aza.aza73 = 'Y' THEN
      LET g_sql="SELECT nme24 FROM nme_file",
                " WHERE nme12='",g_gse.gse01,"'"
      PREPARE nme24_p1 FROM g_sql
      DECLARE nme24_cs1 CURSOR FOR nme24_p1
      FOREACH nme24_cs1 INTO l_nme24
         IF l_nme24 != '9' THEN
            CALL cl_err(g_gse.gse01,'anm-043',1)
            LET g_success='N'
            RETURN
         END IF
      END FOREACH
   END IF
   DELETE FROM nme_file WHERE nme12 = g_gse.gse01
   IF STATUS THEN
      CALL cl_err3("del","nme_file",g_gse.gse01,"",STATUS,"","del nme",1)  #No.FUN-660148
      LET g_success = 'N'
   END IF
   
   IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021
   #FUN-B40056  --begin
   DELETE FROM tic_file WHERE tic04 = g_gse.gse01
   IF STATUS THEN
      CALL cl_err3("del","tic_file",g_gse.gse01,"",STATUS,"","del tic",1)  #No.FUN-660148
      LET g_success = 'N'
   END IF
   #FUN-B40056  --end
   END IF                 #No.TQC-B70021
 
   DELETE FROM gsc_file WHERE gsc02 = g_gse.gse01
   IF STATUS THEN
      CALL cl_err3("del","gsc_file",g_gse.gse01,"",STATUS,"","del gsc",1)  #No.FUN-660148
      LET g_success = 'N'
   END IF
 
 
   UPDATE gse_file SET gseconf = 'N' WHERE gse01 = g_gse.gse01
   IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("upd","gse_file",g_gse.gse01,"",STATUS,"","upd gseconf",1)  #No.FUN-660148
      LET g_success = 'N'
   END IF
 
   IF g_success='N' THEN
      LET g_gse.gseconf = 'Y'
      ROLLBACK WORK
   ELSE
      LET g_gse.gseconf = 'N'
      COMMIT WORK
      CALL cl_cmmsg(1)
   END IF
 
   DISPLAY g_gse.gseconf TO gseconf
 
   #CHI-C90052 begin---
   #IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr='Y' AND g_success = 'Y' THEN 
   #   LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gse.gse21,"' 'Y'"
   #   CALL cl_cmdrun_wait(g_str)
   #   SELECT gse21,gse22 INTO g_gse.gse21,g_gse.gse22 FROM gse_file
   #    WHERE gse01 = g_gse.gse01
   #   DISPLAY BY NAME g_gse.gse21,g_gse.gse22
   #END IF
   #CHI-C90052 end-----
 
END FUNCTION
 
FUNCTION t610_r()
    DEFINE
        l_chr   LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
        l_time  LIKE oay_file.oayslip  #NO.FUN-680107 VARCHAR(05)
 
    IF s_anmshut(0) THEN RETURN END IF
    IF g_gse.gse01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_gse.* FROM gse_file WHERE gse01 = g_gse.gse01
    IF g_gse.gseconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_gse.gseconf = 'Y' THEN  CALL cl_err('','anm-137',0) RETURN END IF
    LET g_success = 'Y'
    BEGIN WORK
    OPEN t610_cl USING g_gse.gse01
    IF STATUS THEN
       CALL cl_err("OPEN t610_cl:", STATUS, 1)
       CLOSE t610_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t610_cl INTO g_gse.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gse.gse01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t610_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "gse01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_gse.gse01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
	DELETE FROM gse_file
            WHERE gse01 = g_gse.gse01
        IF SQLCA.SQLERRD[3]=0 THEN
            LET g_success = 'N'
            CALL cl_err3("del","gse_file",g_gse.gse01,"",SQLCA.sqlcode,"","(t610_r:gse)",1)  #No.FUN-660148
        END IF
       #MOD-A30144---add---start---
        DELETE FROM npp_file
              WHERE nppsys = 'NM' AND npp00 = 20
                AND npp01 = g_gse.gse01
                AND npp011 = 5
        DELETE FROM npq_file
         WHERE npqsys = 'NM'
           AND npq00 = 20
           AND npq01 = g_gse.gse01 
           AND npq011 = 5
       #MOD-A30144---add---end---

        #FUN-B40056--add--str--
        DELETE FROM tic_file WHERE tic04 = g_gse.gse01
        #FUN-B40056--add--end--

        IF g_success = 'Y' THEN CLEAR FORM END IF
	INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  #FUN-980005 add plant & legal
		VALUES ('anmt610',g_user,g_today,g_msg,g_gse.gse01,'Delete',g_plant,g_legal)
    END IF
    CLOSE t610_cl
    IF g_success = 'Y' THEN
       CALL cl_cmmsg(1) COMMIT WORK
       CALL cl_flow_notify(g_gse.gse01,'D')
       OPEN t610_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE t610_cs
          CLOSE t610_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH t610_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t610_cs
          CLOSE t610_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t610_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t610_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t610_fetch('/')
       END IF
    ELSE
        CALL cl_rbmsg(1) ROLLBACK WORK
    END IF
END FUNCTION
 
FUNCTION t610_x()
   IF s_anmshut(0) THEN RETURN END IF
   SELECT * INTO g_gse.* FROM gse_file WHERE gse01=g_gse.gse01
   IF g_gse.gse01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_gse.gseconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   BEGIN WORK
   LET g_success='Y'
   OPEN t610_cl USING g_gse.gse01
   IF STATUS THEN
      CALL cl_err("OPEN t610_cl:", STATUS, 1)
      CLOSE t610_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t610_cl INTO g_gse.*#鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gse.gse01,SQLCA.sqlcode,0)#資料被他人LOCK
      CLOSE t610_cl ROLLBACK WORK RETURN
   END IF
   #-->void轉換01/08/16
   IF cl_void(0,0,g_gse.gseconf)   THEN
      LET g_chr=g_gse.gseconf
      IF g_gse.gseconf ='N' THEN
        #-------------------FUN-D10116-------------------(S)
         DELETE FROM npp_file
          WHERE nppsys= 'NM'
            AND npp00 = 20
            AND npp01 = g_gse.gse01
            AND npp011 = 5
         IF STATUS THEN
            CALL cl_err3("del","npp_file",g_gse.gse01,"",SQLCA.sqlcode,"","",1)
         ELSE
            DELETE FROM npq_file
             WHERE npqsys= 'NM'
               AND npq00 = 20
               AND npq01 = g_gse.gse01
               AND npq011 = 5
            IF STATUS THEN
               CALL cl_err3("del","npq_file",g_gse.gse01,"",SQLCA.sqlcode,"","",1)
            END IF
         END IF
        #-------------------FUN-D10116-------------------(E)
         LET g_gse.gseconf='X'
      ELSE
         LET g_gse.gseconf='N'
      END IF
    UPDATE gse_file SET gseconf =g_gse.gseconf,gsemodu=g_user,gsedate=TODAY
           WHERE gse01 = g_gse.gse01
    IF STATUS THEN 
       CALL cl_err3("upd","gse_file",g_gse.gse01,"",STATUS,"","upd gseconf:",1)  #No.FUN-660148
       LET g_success='N' END IF
    IF g_success='Y' THEN
        COMMIT WORK
        CALL cl_flow_notify(g_gse.gse01,'V')
    ELSE
        ROLLBACK WORK
    END IF
    SELECT gseconf INTO g_gse.gseconf FROM gse_file
           WHERE gse01 = g_gse.gse01
    DISPLAY BY NAME g_gse.gseconf
   END IF
END FUNCTION
 
FUNCTION t610_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gse01",TRUE)
   END IF
 
   IF INFIELD(gse07) THEN
      CALL cl_set_comp_entry("gse09,gse12",TRUE)
   END IF
 
   IF INFIELD(gse14) THEN
      CALL cl_set_comp_entry("gse16,gse19",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t610_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gse01",FALSE)
   END IF
 
   IF INFIELD(gse07) THEN
      IF g_gse.gse08 = g_aza.aza17 THEN
         CALL cl_set_comp_entry("gse09,gse12",FALSE)
      END IF
   END IF
 
   IF INFIELD(gse14) THEN
      IF g_gse.gse15 = g_aza.aza17 THEN
         CALL cl_set_comp_entry("gse16,gse19",FALSE)
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t610_g_gl(p_trno,p_npptype)
   DEFINE p_npptype   LIKE npp_file.npptype   #No.FUN-680088
   DEFINE p_trno      LIKE gse_file.gse01
   DEFINE l_buf       LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(90)
   DEFINE l_n         LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_t         LIKE oay_file.oayslip,  #No.MOD-5A0269 #NO.FUN-680107 VARCHAR(5)
          l_nmydmy3   LIKE nmy_file.nmydmy3
 
   IF cl_null(g_gse.gse01) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
 
   SELECT * INTO g_gse.* FROM gse_file WHERE gse01 = g_gse.gse01
 
   IF p_trno IS NULL THEN
      RETURN
   END IF
 
   IF g_gse.gseconf='Y' THEN
      CALL cl_err(g_gse.gse01,'anm-232',0)
      RETURN
   END IF
 
   IF g_gse.gseconf='X' THEN
      CALL cl_err(g_gse.gse01,'9024',0)
      RETURN
   END IF
 
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p2 FROM g_sql
   EXECUTE nmz10_p2 INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_gse.gse02 <= g_nmz.nmz10 THEN
      CALL cl_err(g_gse.gse01,'aap-176',1)
      RETURN
   END IF
 
   IF NOT cl_null(g_gse.gse21) THEN
      CALL cl_err(g_gse.gse01,'aap-122',1)
      RETURN
   END IF
 
   #判斷該單別是否須拋轉總帳
   LET l_t = s_get_doc_no(p_trno)        #No.MOD-5A0269
   SELECT nmydmy3 INTO l_nmydmy3 FROM nmy_file WHERE nmyslip = l_t
   IF STATUS OR cl_null(l_nmydmy3) THEN
      LET l_nmydmy3 = 'N'
   END IF
   IF l_nmydmy3 = 'N' THEN
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success ="Y"
 
   SELECT COUNT(*) INTO l_n FROM npq_file
    WHERE npqsys = 'NM'
      AND npq00 = 20
      AND npq01 = p_trno
      AND npq011 = 5
   IF l_n > 0 THEN
      IF p_npptype = '0' THEN      #No.FUN-680088
         IF NOT s_ask_entry(p_trno) THEN
            LET g_success = "N"
            RETURN
         END IF
         #FUN-B40056--add--str--
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM tic_file
          WHERE tic04 = p_trno
         IF l_n > 0 THEN
            IF NOT cl_confirm('sub-533') THEN
               LET g_success = 'N'
               RETURN
            END IF
         END IF
         #FUN-B40056--add--end--
      END IF      #No.FUN-680088

      #FUN-B40056--add--str--
      DELETE FROM tic_file WHERE tic04 = p_trno
      #FUN-B40056--add--end--
 
      DELETE FROM npq_file
       WHERE npqsys = 'NM'
         AND npq00 = 20
         AND npq01 = p_trno
         AND npq011 = 5
         AND npqtype = p_npptype      #No.FUN-680088
      IF STATUS THEN
         LET g_success = "N"
      END IF
   END IF
 
   INITIALIZE g_npp.* TO NULL
   LET g_npp.nppsys='NM'
   LET g_npp.npp00 =20
   LET g_npp.npp01 =p_trno
   LET g_npp.npp011=5
   LET g_npp.npp02 =g_gse.gse02
   LET g_npp.npptype = p_npptype      #No.FUN-680088
 
   LET g_npp.npplegal = g_legal  
 
   INSERT INTO npp_file VALUES(g_npp.*)
 
    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #NO.TQC-790093
      UPDATE npp_file SET npp02 = g_npp.npp02
       WHERE nppsys = 'NM'
         AND npp00 = 20
         AND npp01 = p_trno
         AND npp011 = 5
         AND npptype = p_npptype      #No.FUN-680088
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("upd","npp_file",p_trno,"",STATUS,"","upd npp:",1)  #No.FUN-660148
         LET g_success = "N"
      END IF
   END IF
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err('ins npp:',STATUS,1)
      LET g_success = "N"
   END IF
 
   IF g_success = 'N' THEN
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t610_g_gl_1(p_trno,p_npptype)      #No.FUN-680088
   CALL t610_gen_diff()                    #No.FUN-A40033
 
   IF g_success = "Y" THEN
      CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
      MESSAGE g_msg CLIPPED
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION t610_g_gl_1(p_trno,p_npptype)        #No.FUN-680088
   DEFINE p_npptype   LIKE npp_file.npptype   #No.FUN-680088
   DEFINE p_trno      LIKE gse_file.gse01
   DEFINE l_gsb05     LIKE gsb_file.gsb05
   DEFINE l_aag05     LIKE aag_file.aag05    #FUN-710070 add
   DEFINE l_aaa03     LIKE aaa_file.aaa03    #FUN-A40067
   DEFINE l_azi04_2   LIKE azi_file.azi04    #FUN-A40067
   DEFINE l_flag      LIKE type_file.chr1    #FUN-D40118 add
 
#FUN-A40067 --Begin
   SELECT aaa03 INTO l_aaa03 FROM aaa_file
    WHERE aaa01 = g_bookno2
   SELECT azi04 INTO l_azi04_2 FROM azi_file
    WHERE azi01 = l_aaa03
#FUN-A40067 --End
   INITIALIZE g_npq.* TO NULL
   #---投資金額
   LET g_npq.npqsys = g_npp.nppsys
   LET g_npq.npq00  = g_npp.npp00
   LET g_npq.npq01  = g_npp.npp01
   LET g_npq.npq011 = g_npp.npp011
   LET g_npq.npq02 = 1
   LET g_npq.npqtype = p_npptype      #No.FUN-680088

   #FUN-D40118--add--str--
   IF g_npq.npqtype='0' THEN
      LET g_bookno3 = g_bookno1
   ELSE
      LET g_bookno3 = g_bookno2
   END IF  
   #FUN-D40118--add--end--

   IF p_npptype = '0' THEN
      SELECT nma05 INTO g_npq.npq03 FROM nma_file
       WHERE nma01 = g_gse.gse07
   ELSE
      SELECT nma051 INTO g_npq.npq03 FROM nma_file
       WHERE nma01 = g_gse.gse07
   END IF
   IF STATUS THEN
      LET g_npq.npq03 = ''
   END IF
 
   SELECT aag05 INTO l_aag05 FROM aag_file
    WHERE aag01 = g_npq.npq03
   IF l_aag05 = 'Y' THEN
     LET g_npq.npq05 = g_gse.gse27
   ELSE
     LET g_npq.npq05 = ''
   END IF
   LET g_npq.npq04 = NULL #FUN-D10065 
   LET g_npq.npq06 = '1'
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_gse.gse08  #NO.CHI-6A0004
   LET g_npq.npq07f= cl_digcut(g_gse.gse12,t_azi04)                 #NO.CHI-6A0004  
   LET g_npq.npq07 = cl_digcut(g_gse.gse23,g_azi04)
   LET g_npq.npq24 = g_gse.gse08
   LET g_npq.npq25 = g_gse.gse09
   LET g_npq25     = g_npq.npq25        #No.FUN-9A0036
 
   CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2   
   IF g_flag = '1' THEn
      CALL cl_err(YEAR(g_npp.npp02),'aoo-081',1)
      LET g_success = 'N'                                                    
   END IF
   IF g_npq.npqtype='0' THEN
     CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno1)
       RETURNING g_npq.*
       CALL s_def_npq31_npq34(g_npq.*,g_bookno1) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087
   ELSE
     CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno2)
       RETURNING g_npq.*
       CALL s_def_npq31_npq34(g_npq.*,g_bookno2) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087
   END IF
 
   LET g_npq.npqlegal = g_legal  
#No.FUN-9A0036 --Begin
   IF p_npptype = '1' THEN
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
      CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq1:",1)  #No.FUN-660148
      LET g_success = "N"
   END IF
 
   #---投資費用
   IF g_gse.gse19 != 0 OR g_gse.gse20 != 0 THEN    #MOD-880154 add
      LET g_npq.npq02 = g_npq.npq02+1
      IF p_npptype = '0' THEN
         SELECT gsf04 INTO g_npq.npq03 FROM gsf_file
          WHERE gsf01 = g_gse.gse13
      ELSE
         SELECT gsf041 INTO g_npq.npq03 FROM gsf_file
          WHERE gsf01 = g_gse.gse13
      END IF
      IF STATUS THEN
         LET g_npq.npq03 = ''
      END IF
 
      #FUN-D10065--add--str--
      LET g_npq.npq04=NULL
      IF g_npq.npqtype='0' THEN
         CALL s_def_npq3(g_bookno1,g_npq.npq03,g_prog,g_npq.npq01,'','')
         RETURNING g_npq.npq04
      ELSE
         CALL s_def_npq3(g_bookno2,g_npq.npq03,g_prog,g_npq.npq01,'','')
         RETURNING g_npq.npq04
      END IF
      #FUN-D10065--add--end
      SELECT aag05 INTO l_aag05 FROM aag_file
       WHERE aag01 = g_npq.npq03
      IF l_aag05 = 'Y' THEN
        LET g_npq.npq05 = g_gse.gse27
      ELSE
        LET g_npq.npq05 = ''
      END IF
      LET g_npq.npq06 = '1'   #No.FUN-5A0004
      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_gse.gse15  #NO.CHI-6A0004
      LET g_npq.npq07f= cl_digcut(g_gse.gse19,t_azi04)    #NO.CHI-6A0004
      LET g_npq.npq07 = cl_digcut(g_gse.gse20,g_azi04)
      LET g_npq.npq24 = g_gse.gse15
      LET g_npq.npq25 = g_gse.gse16
      LET g_npq25     = g_npq.npq25
 
      LET g_npq.npqlegal = g_legal  
 
#No.FUN-9A0036 --Begin
   IF p_npptype = '1' THEN
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
         CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq2:",1)  #No.FUN-660148
         LET g_success = "N"
      END IF
 
      LET g_npq.npq02 = g_npq.npq02+1
      IF p_npptype = '0' THEN
         SELECT nma05 INTO g_npq.npq03 FROM nma_file
          WHERE nma01 = g_gse.gse14
      ELSE
         SELECT nma051 INTO g_npq.npq03 FROM nma_file
          WHERE nma01 = g_gse.gse14
      END IF
      IF STATUS THEN
         LET g_npq.npq03 = ''
      END IF
      LET g_npq.npq04 = NULL #FUN-D10065 
      SELECT aag05 INTO l_aag05 FROM aag_file
       WHERE aag01 = g_npq.npq03
      IF l_aag05 = 'Y' THEN
        LET g_npq.npq05 = g_gse.gse27
      ELSE
        LET g_npq.npq05 = ''
      END IF
      LET g_npq.npq06 = '2'   #No.FUN-5A0004
      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_gse.gse15   #NO.CHI-6A0004
      LET g_npq.npq07f= cl_digcut(g_gse.gse19,t_azi04)    #NO.CHI-6A0004
      LET g_npq.npq07 = cl_digcut(g_gse.gse20,g_azi04)
      LET g_npq.npq24 = g_gse.gse15
      LET g_npq.npq25 = g_gse.gse16
      LET g_npq25     = g_npq.npq25
 
      IF g_npq.npqtype = '0' THEN
        CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno1)
          RETURNING g_npq.*
        CALL s_def_npq31_npq34(g_npq.*,g_bookno1) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
      ELSE
        CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno2)
          RETURNING g_npq.*
        CALL s_def_npq31_npq34(g_npq.*,g_bookno2) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
      END IF
 
      LET g_npq.npqlegal = g_legal  
#No.FUN-9A0036 --Begin
      IF p_npptype = '1' THEN
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
         CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq2:",1)  #No.FUN-660148
         LET g_success = "N"
      END IF
   END IF   #MOD-880154 add
 
   #---貸方
   LET g_npq.npq02 = g_npq.npq02+1
 
   SELECT gsb05 INTO l_gsb05 FROM gsb_file
    WHERE gsb01 = g_gse.gse03
   IF p_npptype = '0' THEN
      SELECT gsa04 INTO g_npq.npq03 FROM gsa_file
       WHERE gsa01 = l_gsb05
   ELSE
      SELECT gsa041 INTO g_npq.npq03 FROM gsa_file
       WHERE gsa01 = l_gsb05
   END IF
   IF STATUS THEN
      LET g_npq.npq03 = ''
   END IF
   LET g_npq.npq04=NULL  #FUN-D10065 
   SELECT aag05 INTO l_aag05 FROM aag_file
    WHERE aag01 = g_npq.npq03
   IF l_aag05 = 'Y' THEN
     LET g_npq.npq05 = g_gse.gse27
   ELSE
     LET g_npq.npq05 = ''
   END IF
   LET g_npq.npq06 = '2'
   LET g_npq.npq07 = cl_digcut(g_gse.gse06,g_azi04)
  #LET g_npq.npq07f= g_npq.npq07   #CHI-9B0026 mark
  #str CHI-9B0026 mod
  #應帶原投資購買時的幣別/匯率(gsh08/gsh09)
  #LET g_npq.npq24 = g_aza.aza17
  #LET g_npq.npq25 = 1
   SELECT gsh08,gsh09 INTO g_npq.npq24,g_npq.npq25 FROM gsh_file
    WHERE gsh03=g_gse.gse03 AND gshconf='Y' 
  #end CHI-9B0026 mod
   LET g_npq25     = g_npq.npq25
   LET g_npq.npq07f= cl_digcut(g_npq.npq07/g_npq.npq25,t_azi04)  #CHI-9B0026 add
 
   IF g_npq.npqtype='0' THEN
     CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno1)
     RETURNING g_npq.*
     CALL s_def_npq31_npq34(g_npq.*,g_bookno1) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
   ELSE
     CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno2)
     RETURNING g_npq.*
     CALL s_def_npq31_npq34(g_npq.*,g_bookno2) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
   END IF
 
   LET g_npq.npqlegal = g_legal  
 
#No.FUN-9A0036 --Begin
   IF p_npptype = '1' THEN
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
      CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq3:",1)  #No.FUN-660148
      LET g_success = "N"
   END IF
 
   #---損益
   LET g_npq.npq02 = g_npq.npq02+1
 
  #LET g_npq.npq07 = cl_digcut(g_gse.gse24,g_azi04)                 #TQC-630077 #MOD-C70074 mark
  #LET g_npq.npq07 = cl_digcut(g_gse.gse25,g_azi04)                 #MOD-C70074 add #MOD-CA0042 mark
   LET g_npq.npq07 = cl_digcut(g_gse.gse25 + g_gse.gse20,g_azi04)   #MOD-CA0042 add
   IF g_npq.npq07 < 0 THEN
      LET g_npq.npq07 = g_npq.npq07 * -1
      LET g_npq.npq06 = '1'   #TQC-630077
 
      IF p_npptype = '0' THEN
         SELECT gsa06 INTO g_npq.npq03 FROM gsa_file
          WHERE gsa01 = l_gsb05
      ELSE
         SELECT gsa061 INTO g_npq.npq03 FROM gsa_file
          WHERE gsa01 = l_gsb05
      END IF
      IF STATUS THEN
         LET g_npq.npq03 = ''
      END IF
   ELSE
      LET g_npq.npq06 = '2'   #TQC-630077
 
      IF p_npptype = '0' THEN
         SELECT gsa05 INTO g_npq.npq03 FROM gsa_file
          WHERE gsa01 = l_gsb05
      ELSE
         SELECT gsa051 INTO g_npq.npq03 FROM gsa_file
          WHERE gsa01 = l_gsb05
      END IF
      IF STATUS THEN
         LET g_npq.npq03 = ''
      END IF
   END IF
 
   SELECT aag05 INTO l_aag05 FROM aag_file
    WHERE aag01 = g_npq.npq03
   IF l_aag05 = 'Y' THEN
     LET g_npq.npq05 = g_gse.gse27
   ELSE
     LET g_npq.npq05 = ''
   END IF
   IF g_gse.gse09 = 1 THEN              #MOD-C70074 add
      LET g_npq.npq07f = g_npq.npq07    #CHI-9B0026 mark MOD-C70074 remark
   ELSE                                 #MOD-C70074 add
      LET g_npq.npq07f= 0               #CHI-9B0026 
   END IF                               #MOD-C70074 add
   LET g_npq.npq24 = g_aza.aza17
   LET g_npq.npq25 = 1
   LET g_npq25     = g_npq.npq25
 
   IF g_npq.npq07 != 0 THEN
     LET g_npq.npq04=NULL #FUN-D10065 
     IF g_npq.npqtype = '0' THEN
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno1)
      RETURNING g_npq.*
      CALL s_def_npq31_npq34(g_npq.*,g_bookno1) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
     ELSE
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno2)
      RETURNING g_npq.*
      CALL s_def_npq31_npq34(g_npq.*,g_bookno2) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
     END IF
 
      LET g_npq.npqlegal = g_legal  
 
#No.FUN-9A0036 --Begin
      IF p_npptype = '1' THEN
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
         CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq4:",1)  #No.FUN-660148
         LET g_success = "N"
      END IF
   END IF
   CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021  
    
END FUNCTION
 
FUNCTION t610_npp02(p_npptype)
   DEFINE p_npptype   LIKE npp_file.npptype      #No.FUN-680088
 
   IF g_gse.gse21 IS NULL OR g_gse.gse21=' ' THEN
      UPDATE npp_file SET npp02 = g_gse.gse02
       WHERE npp01 = g_gse.gse01
         AND npp00 = 19
         AND npp011 = 4
         AND nppsys = 'NM'
         AND npptype = p_npptype       #No.FUN-680088
      IF STATUS THEN
         CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq02:",1)  #No.FUN-660148
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t610_gen_glcr(p_gse,p_nmy)
  DEFINE p_gse     RECORD LIKE gse_file.*
  DEFINE p_nmy     RECORD LIKE nmy_file.*
 
    IF cl_null(p_nmy.nmygslp) THEN
       CALL cl_err(p_gse.gse01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    CALL t610_g_gl(g_gse.gse01,'0')
    IF g_aza.aza63 = 'Y' THEN
       CALL t610_g_gl(g_gse.gse01,'1')
    END IF
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t610_carry_voucher()
  DEFINE l_nmygslp    LIKE nmy_file.nmygslp
  DEFINE li_result    LIKE type_file.num5     #No.FUN-680107 SMALLINT
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING 
  DEFINE l_n          LIKE type_file.num5     #No.FUN-680107 SMALLINT
 
    IF NOT cl_null(g_gse.gse21) OR g_gse.gse21 IS NOT NULL THEN 
       CALL cl_err(g_gse.gse21,'aap-618',1)
       RETURN 
    END IF 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    CALL s_get_doc_no(g_gse.gse01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmydmy3 = 'N' THEN RETURN END IF
    IF g_nmy.nmyglcr = 'Y' OR (g_nmy.nmyglcr = 'N' AND NOT cl_null(g_nmy.nmygslp)) THEN #FUN-940036
       LET l_nmygslp = g_nmy.nmygslp
       #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
       #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                   "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                   "    AND aba01 = '",g_gse.gse21,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
       PREPARE aba_pre5 FROM l_sql
       DECLARE aba_cs5 CURSOR FOR aba_pre5
       OPEN aba_cs5
       FETCH aba_cs5 INTO l_n
       IF l_n > 0 THEN
          CALL cl_err(g_gse.gse21,'aap-991',1)
          RETURN
       END IF
    ELSE
       CALL cl_err('','aap-936',1) #FUN-940036 
       RETURN
 
    END IF
    IF cl_null(l_nmygslp) THEN
       CALL cl_err(g_gse.gse01,'axr-070',1)
       RETURN
    END IF
    LET g_wc_gl = 'npp01="',g_gse.gse01 CLIPPED,'" AND npp011=5 '
    LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmy.nmygslp,"' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"' '",g_gse.gse02,"' 'Y' '1' 'Y'"   #No.FUN-680088#FUN-860040
    CALL cl_cmdrun_wait(g_str)
    SELECT gse21,gse22 INTO g_gse.gse21,g_gse.gse22 FROM gse_file
     WHERE gse01 = g_gse.gse01
    DISPLAY BY NAME g_gse.gse21,g_gse.gse22
    
END FUNCTION
 
FUNCTION t610_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(1000)
  DEFINE l_dbs      STRING
 
    IF cl_null(g_gse.gse21) OR g_gse.gse21 IS NULL THEN
       CALL cl_err(g_gse.gse21,'aap-619',1) 
       RETURN 
    END IF
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
    CALL s_get_doc_no(g_gse.gse01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmyglcr = 'N' AND cl_null(g_nmy.nmygslp) THEN   #FUN-940036 
       CALL cl_err('','aap-936',1)   #FUN-940036
       RETURN
    END IF
    #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
    #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                "    AND aba01 = '",g_gse.gse21,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre1 FROM l_sql
    DECLARE aba_cs1 CURSOR FOR aba_pre1
    OPEN aba_cs1
    FETCH aba_cs1 INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_gse.gse21,'axr-071',1)
       RETURN
    END IF
    LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gse.gse21,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT gse21,gse22 INTO g_gse.gse21,g_gse.gse22 FROM gse_file
     WHERE gse01 = g_gse.gse01
    DISPLAY BY NAME g_gse.gse21,g_gse.gse22
END FUNCTION
#FUN-A40033 --Begin
FUNCTION t610_gen_diff()
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
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = g_bookno2
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
         LET l_npq1.npqlegal  = g_legal
         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = g_bookno2
            AND aag01 = l_npq1.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq1.npq03,g_bookno2) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq1.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
         INSERT INTO npq_file VALUES(l_npq1.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","npq_file",g_npp.npp01,"",STATUS,"","",1) #FUN-670091
            LET g_success = 'N'
         END IF
      END IF
   END IF   
END FUNCTION
#No.FUN-A40033 --End
#No.FUN-9C0073 -----------------By chenls 10/01/15

