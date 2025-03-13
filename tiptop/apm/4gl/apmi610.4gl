# Prog. Version..: '5.30.06-13.03.20(00010)'     #
#
# Pattern name...: apmi610.4gl
# Descriptions...: 供應商申請維護作業
# Date & Author..: 2006/08/21 By Mandy
# Modify.........: No.FUN-680136 06/09/13 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0079 06/12/01 By jamie 1.FUNCTION _fetch() 清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-690023 06/12/18 By jamie 判斷occacti
# Modify.........: No.TQC-6C0060 07/01/08 By alexstar 多語言功能單純化
# Modify.........: No.FUN-730068 07/03/28 By kim 行業別架構
# Modify.........: No.TQC-730112 07/04/12 By Mandy 將CALL aws_efapp_flowaction() 移至BEFORE MENU,可避免在畫面上按滑鼠右鍵，會出現簽核的指令
# Modify.........: No.TQC-740071 07/04/13 By Ray 1.當初次新增供應商，系統廠商性質預設“3：兩者”欄位沒有進入，系統可以直接去維護“付款廠商和出貨廠商”
#                                                2.在按“付款廠商編號”邊上的放大鏡時出現錯誤
#                                                3.頁簽‘交易資料’中的兩個‘xxxx每月第幾日’不可為負數
# Modify.........: No.TQC-740090 07/04/16 By Mandy 1.單據更改後,"資料更改者"沒有更新 
#                                                  2.資料拋轉時,s_carry_data()內的畫面多一個欄位'已存在',存放該要拋轉的資料是否存在當筆的那個資料庫
# Modify.........: No.TQC-740169 07/04/26 By Mandy 資料拋轉時,s_carry_date 重新給default 邏輯
# Modify.........: No.TQC-740334 07/04/27 By Mandy 當新增一筆申請類別為'U:修改'的申請單時,某些欄位內容錯誤,會帶修改的廠商編號在pmc_file內的資料
# Modify.........: No.TQC-740343 07/04/27 By Mandy 資料拋轉時,資料所有者,資料所有部門,資料修改者,最近修改日 等欄位錯誤
# Modify.........: No.TQC-750007 07/05/02 By Mandy 1.串EasyFlow未OK
#                                                  2.修改時,狀況=>R:送簽退回,W:抽單 也要可以修改
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-780005 07/08/01 By Mandy Action "資料拋轉"時,若申請類別為'新增'時,資料已存在的不能選取,做拋轉
# Modify.........: No.CHI-780006 07/08/09 By jamie 增加CR列印功能
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/14 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.FUN-7B0080 07/11/16 By saki 移除自定義欄位程式
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-7C0084 08/01/23 By Mandy AFTER FIELD pmca01 若pmca00為"新增",控管申請廠商編號不可重覆
# Modify.........: No.FUN-820028 08/03/05 By lilingy 增加資料中心功能--將拋轉功能整體移至s_apmi600_carry.4gl
# Modify.........: NO.FUN-840018 08/04/03 by yiting 增加拋轉歷史查詢功能                                                                           
# Modify.........: No.FUN-840042 08/04/11 by TSD.zeak 自訂欄位功能修改 
# Modify.........: NO.CHI-840029 08/04/20 By Mandy (1)申請時,客戶編號可空白
#                                                  (2)送簽中,未拋轉前,可補客戶編號
#                                                  (3)拋轉前,check必需有客戶編號
#                                                  (4)若有用自動編號,補客戶編號時,可另按Action產生
# Modify.........: NO.MOD-840275 08/04/20 By Mandy 申請單確認後且已正式拋轉，但仍可取消確認
# Modify.........: NO.FUN-840097 08/04/23 By sherry 申請單增加復制功能
# Modify.........: NO.TQC-850019 08/05/13 By claire 使用更改性質的單據申請時,key值空白未控卡
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.MOD-850267 08/05/27 By Smapmin key值的判斷應為pmcano
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.MOD-860238 08/06/23 By Smapmin 無法依p_flow的流程定義寄MAIL
# Modify.........: No.CHI-860042 08/07/17 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.CHI-8C0017 08/12/17 By xiaofeizhu 一般及委外問題處理
# Modify.........: No.MOD-920282 09/02/23 By Smapmin 查詢出一筆資料,連續列印二次,第二次報表結果無法呈現
# Modify.........: No.FUN-930113 09/03/19 By mike 將oah_file-->pnz_file
# Modify.........: No.MOD-940002 09/04/08 By chenyu 出貨廠商的檢查應該先檢查是否存在pmc_file中
# Modify.........: No.MOD-940096 09/04/08 By lutingting程序copy段取消對pmg_file以及apl_file得處理
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.MOD-950196 09/05/25 By Dido show段需重新顯示圖示
# Modify.........: No.MOD-960146 09/07/07 By Smapmin 補廠商編號後,供應商編號卻仍是空白
# Modify.........: No.MOD-970184 09/07/23 By Sabrina pmca911在uni區無泰文選項，將pmca911改為動態抓取語言選項
# Modify.........: No.FUN-980006 09/08/13 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-970354 09/07/29 By dxfwo  1.在確認段在CLOSE i610_cl 之后，直接就commit work了?可是有串ezflow的不是要先跑后面緊接著的簽核段嗎?
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-960126 09/10/20 By Pengu 新增料件時應遵循資料中心的關連與控管
# Modify.........: No:FUN-9C0071 10/01/13 By huangrh 精簡程式
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A50174 10/05/30 By Smapmin 複製時,供應商編號也要加上控管是否重複
# Modify.........: No:MOD-A70159 10/07/23 By Smapmin 簡稱已有登打資料,就不再default
# Modify.........: No:CHI-A80023 10/08/23 By Summer 增加檢核,若確認時廠商編號還沒輸入,但資料中心拋轉設為1.自動拋轉時,提示訊息
# Modify.........: No:CHI-A80049 10/10/06 By Summer 開放apmi610其他欄位的修改,如同apmi600
# Modify.........: No:MOD-A80234 10/10/29 By Smapmin 單據新增前再次判斷廠商編號是否重複
# Modify.........: No:CHI-AC0001 10/12/08 By Summer 申請作業上的欄位本來就可能與基本資料的不同,修改為直接抓取每個欄位放到g_pmca的變數裡
# Modify.........: No:MOD-AC0310 10/12/27 By chenying apmi610 的pmca00欄位，選u修改後，跳到下一欄位，就無法在回pmca00 調整
# Modify.........: No:MOD-B30066 11/03/09 By Summer 關於統一編號是否重複的控卡,當廠商性質為1.送貨廠商時,只警告不控卡
# Modify.........: No:MOD-B40095 11/04/18 By Summer apm-601的控卡要排除'無效'的資料,另外,無效資料又要變為有效資料時,要確認已沒有有效資料存在 
# Modify.........: No:TQC-B40200 11/04/25 By lilingyu EF簽核相關BUG修改
# Modify.........: No:MOD-B40226 11/04/25 By Summer 修正CHI-A80049,申請作業可修改廠商簡稱和全名
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B80241 11/08/30 By guoch 资料建立者，资料建立部门查询时无法下条件
# Modify.........: No:TQC-BA0126 11/10/24 By destiny 增加新增自动审核功能
# Modify.........: No:MOD-BC0205 11/12/23 By Vampire 新增時,付款廠商簡稱未帶出
# Modify.........: No:FUN-B90080 12/01/16 By Sakura 新增VMI管理資料
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C20026 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No:FUN-C30017 12/03/07 By Mandy TP端簽核時,[取消確認]/[資料拋轉] ACTION要隱藏
# Modify.........: No:CHI-C20021 12/04/16 By suncx 新增手續費外加/內扣pmca281字段
# Modify.........: No:MOD-C70155 12/07/13 By Elise 抓取權限資料表為pmca_file,應傳pmcauser及pmcagrup
# Modify.........: No:MOD-C70107 12/07/17 By SunLM 申請類別U:不能改廠商名称
# Modify.........: No:TQC-C70218 12/08/01 By SunLM 还原MOD-C70107,并加入FUN-BB0049的判断
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-C80107 12/10/30 By suncx 新增imd23賦默認值
# Modify.........: No:CHI-CB0017 12/12/24 By Lori 申請類別為修改時,需將來源的相關文件複製寫入
# Modify.........: No.FUN-C40009 13/01/10 By Nina 只要程式有UPDATE pmh_file 的任何一個欄位時,多加pmhdate=g_today
# Modify.........: No:MOD-D10211 13/01/23 By Smapmin 簽核單據複製功能,未處理簽核否欄位.
# Modify.........: No:CHI-D30027 13/03/20 By Summer 統一編號重複控卡問題,排除apmi600無效單據  
# Modify.........: No.FUN-D40103 13/05/07 By fengrui ime_file添加imeacti
# Modify.........: No.TQC-D50116 13/05/27 By fengrui 修改儲位檢查報錯信息
# Modify.........: No.FUN-D60124 13/06/27 By fengrui 修正ime_file關於有效碼檢查
# Modify.........: No.TQC-DB0071 13/11/27 BY wangrr 修改倉庫儲位開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_apmi600_center.global"   #No.FUN-820028 
 
DEFINE    g_gev04               LIKE gev_file.gev04   #NO.FUN-840018 
DEFINE   g_input_vendorno  LIKE type_file.chr1   #CHI-840029---add
DEFINE g_flag2     LIKE type_file.chr1    #No:MOD-960126 add
DEFINE g_msg       STRING                 #CHI-CB0017 add
 
MAIN
   DEFINE l_aza           LIKE aza_file.aza01   #No.FUN-680136 VARCHAR(1) #FUN-610012
   DEFINE cb              ui.ComBobox           #FUN-610012
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP,
       FIELD ORDER FORM                   #整個畫面會依照p_per所設定的欄位順序(忽略4gl寫的順序)  #FUN-730068
   DEFER INTERRUPT				#擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   LET g_input_vendorno = 'N' #CHI-840029--add
   IF g_aza.aza62 !='Y' THEN #不使用廠商申作業
      #參數設定不使用申請作業,所以無法執行此支程式!
      CALL cl_err('','axm-253',1)
      EXIT PROGRAM
   END IF 
   LET g_argv1 = ARG_VAL(1) #TQC-750007 挪至此
   IF fgl_getenv('EASYFLOW') = "1" THEN
         LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   INITIALIZE g_pmca.* TO NULL
   INITIALIZE g_pmca_t.* TO NULL
   INITIALIZE g_pmca_o.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM pmca_file WHERE pmcano = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i610_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   OPEN WINDOW i610_w WITH FORM "apm/42f/apmi610"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()

   #如果由表單追蹤區觸發程式, 此參數指定為何種資料匣
   #當為 EasyFlow 簽核時, 加入 EasyFlow 簽核 toolbar icon
   CALL aws_efapp_toolbar()    #FUN-580158
 
   IF NOT cl_null(g_argv1) THEN
       LET g_action_choice="query"
       IF cl_chk_act_auth() THEN
           CALL i610_q()
       END IF
   END IF
 
   SELECT aza50 INTO l_aza FROM aza_file
   IF l_aza='N' OR (l_aza IS NULL) THEN
      LET cb = ui.ComBobox.forName("pmca14")
      CALL cb.removeItem(5)
   END IF
 
   LET g_action_choice=""

   CALL cl_set_combo_lang("pmca911")           #MOD-970184 add
   CALL i610_menu()
   CLOSE WINDOW i610_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i610_cs()
   CLEAR FORM
   IF NOT cl_null(g_argv1) THEN 
       LET g_wc = " pmcano ='",g_argv1,"'" 
   ELSE
   INITIALIZE g_pmca.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
          pmca00  ,pmcano  ,pmca01  ,pmca03  ,pmca081,pmca082,pmca24 ,pmca903,pmca14 ,
          pmca02  ,pmca30  ,pmca04  ,pmca901 ,pmca05 ,pmca23 ,
          pmca17  ,pmca49  ,pmca22  ,pmca47  ,pmca54 ,pmca911,
          pmca48  ,pmca902 ,pmca27  ,pmca50  ,pmca51 ,pmca28 ,pmca281,   #CHI-C20021 add pmca281
          pmca908 ,pmca07  ,pmca06  ,pmca904 ,pmca091,pmca092,pmca093,pmca094,pmca095,   
          pmca52  ,pmca53  ,pmca15  ,pmca16  ,
          pmca56  ,pmca55  ,pmca10  ,pmca11  ,pmca12 ,
          pmca914,pmca915,pmca916,pmca917,pmca918, #FUN-B90080 add
          pmca919,pmca920,pmca921,pmca922,pmca923, #FUN-B90080 add
          pmcauser,pmcagrup,pmcamodu,pmcadate,pmcaacti,
          pmcaud01,pmcaud02,pmcaud03,pmcaud04,pmcaud05,
          pmcaud06,pmcaud07,pmcaud08,pmcaud09,pmcaud10,
          pmcaud11,pmcaud12,pmcaud13,pmcaud14,pmcaud15,
          pmcaoriu,pmcaorig  #TQC-B80241  add
 
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
       
          ON ACTION CONTROLP
             CASE
                WHEN INFIELD(pmcano)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = 'q_pmcano'
                     LET g_qryparam.state  = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO pmcano
                     NEXT FIELD pmcano
                WHEN INFIELD(pmca01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_pmc"      #No.TQC-740071
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca01
                WHEN INFIELD(pmca03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_pmc"      #No.TQC-740071
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca03
                WHEN INFIELD(pmca02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_pmy"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca02
                WHEN INFIELD(pmca04) #查詢付款廠商檔
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_pmc"      #No.TQC-740071
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca04
                WHEN INFIELD(pmca901) #查詢出貨廠商檔
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_pmc"      #No.TQC-740071
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca901
                WHEN INFIELD(pmca06) #查詢區域檔
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_gea"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca06
       
                WHEN INFIELD(pmca07) #查詢國別檔
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_geb"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca07
                   NEXT FIELD pmca07
                WHEN INFIELD(pmca908) #查詢地區檔
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_geo"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca908
                   NEXT FIELD pmca908
                WHEN INFIELD(pmca15) #查詢地址資料檔 (0:表送貨地址)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_pme"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca15
                WHEN INFIELD(pmca16) #查詢地址資料檔 (1:表帳單地址)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_pme"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca16
                WHEN INFIELD(pmca17) #查詢付款條件資料檔(pma_file)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_pma"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca17
                   CALL i610_pmca17(g_pmca.pmca17)
                   NEXT FIELD pmca17
                WHEN INFIELD(pmca22) #查詢幣別資料檔
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_azi"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca22
                WHEN INFIELD(pmca47) #
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_gec"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca47
                WHEN INFIELD(pmca55) #
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_nmt"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca55
                WHEN INFIELD(pmca49) #價格條件
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_pnz01" #FUN-930113 oah-->pnz01
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca49
                WHEN INFIELD(pmca54) #佣金
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_ofs"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca54
                #FUN-B90080 add --start--
                WHEN INFIELD(pmca915) #VMI庫存倉庫
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_imd"
                   LET g_qryparam.arg1 = "SW"   #TQC-DB0071 add
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca915
                WHEN INFIELD(pmca916) #VMI庫存儲位
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                  #LET g_qryparam.form = "q_imd"  #TQC-DB0071 mark
                   LET g_qryparam.form = "q_ime4" #TQC-DB0071
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca916
                WHEN INFIELD(pmca917) #VMI結算倉庫
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_imd"
                   LET g_qryparam.arg1 = "SW"   #TQC-DB0071 add
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca917
                WHEN INFIELD(pmca918) #VMI結算儲位
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                  #LET g_qryparam.form = "q_imd"  #TQC-DB0071 mark
                   LET g_qryparam.form = "q_ime4" #TQC-DB0071
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca918
                WHEN INFIELD(pmca919) #VMI結算收貨單別
                   CALL q_smy(TRUE,TRUE,'','apm','3') RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca919
                WHEN INFIELD(pmca920) #VMI結算入庫單別
                   CALL q_smy(TRUE,TRUE,'','apm','7') RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca920
                WHEN INFIELD(pmca921) #VMI結算退貨單別
                   CALL q_smy(TRUE,TRUE,'','apm','4') RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca921
                WHEN INFIELD(pmca922) #VMI庫存雜發單別
                   CALL q_smy(TRUE,TRUE,'','aim','1') RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca922
                WHEN INFIELD(pmca923) #VMI庫存雜收單別
                   CALL q_smy(TRUE,TRUE,'','aim','2') RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmca923                
                #FUN-B90080 add --end--
                #CHI-A80049 add --start--
                WHEN INFIELD(pmcaud02)
                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmcaud02
                   NEXT FIELD pmcaud02
                WHEN INFIELD(pmcaud03)
                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmcaud03
                   NEXT FIELD pmcaud03
                WHEN INFIELD(pmcaud04)
                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmcaud04
                   NEXT FIELD pmcaud04
                WHEN INFIELD(pmcaud05)
                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmcaud05
                   NEXT FIELD pmcaud05
                WHEN INFIELD(pmcaud06)
                   CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmcaud06
                   NEXT FIELD pmcaud06
                #CHI-A80049 add --end--
                OTHERWISE EXIT CASE
             END CASE
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
   END IF 
 
   IF INT_FLAG THEN RETURN END IF
  #LET g_wc = g_wc CLIPPED,cl_get_extra_cond('mcauser', 'mcagrup')    #MOD-C70155 mark
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmcauser', 'pmcagrup')  #MOD-C70155
   LET g_sql="SELECT pmcano FROM pmca_file ", # 組合出 SQL 指令
       " WHERE ",g_wc CLIPPED, " ORDER BY pmcano "
 
   PREPARE i610_prepare FROM g_sql           # RUNTIME 編譯
   DECLARE i610_cs                           # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i610_prepare
   LET g_sql =
       "SELECT COUNT(*) FROM pmca_file WHERE ",g_wc CLIPPED
   PREPARE i610_precount FROM g_sql
   DECLARE i610_count CURSOR FOR i610_precount
END FUNCTION
 
FUNCTION i610_menu()
   DEFINE   l_flowuser      LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
   DEFINE   l_creator       LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
   DEFINE   l_imabdate      LIKE imab_file.imabdate
   DEFINE   l_cmd           LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(30)
            l_priv1         LIKE zy_file.zy03,      # 使用者執行權限
            l_priv2         LIKE zy_file.zy04,      # 使用者資料權限
            l_priv3         LIKE zy_file.zy05       # 使用部門資料權限
 
    LET l_flowuser = "N"
 
   MENU ""
 
       BEFORE MENU
           CALL cl_navigator_setting( g_curs_index, g_row_count )
           CALL aws_efapp_flowaction("insert, modify, delete,detail, query, locale, void, 
                                      confirm, undo_confirm,easyflow_approval,input_vendorno,unconfirm,carry_data") #FUN-C30017 add unconfirm,carry_data
                                                           #TQC-B40200 add input_vendorno
                 RETURNING g_laststage
 
      ON ACTION insert
         LET g_action_choice="insert"
         IF cl_chk_act_auth() THEN
            CALL i610_a()
         END IF
      ON ACTION query
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL i610_q()
         END IF
      ON ACTION next
         CALL i610_fetch('N')
      ON ACTION previous
         CALL i610_fetch('P')
      ON ACTION modify
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL i610_u()
         END IF
      ON ACTION invalid
         LET g_action_choice="invalid"
         IF cl_chk_act_auth() THEN
            CALL i610_x()
         END IF
 
      ON ACTION delete
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN
            CALL i610_r()
         END IF
 
#      ON ACTION 資料拋轉歷史   
       ON ACTION qry_carry_history                                                                                                
          LET g_action_choice = "qry_carry_history"                                                                               
          IF cl_chk_act_auth() THEN                                                                                               
            IF NOT cl_null(g_pmca.pmca01) THEN 
                SELECT gev04 INTO g_gev04 FROM gev_file                                                                           
                 WHERE gev01 = '5' AND gev02 = g_plant                                                                            
            END IF                                                                                                               
            IF NOT cl_null(g_gev04) THEN                                                                                         
                LET l_cmd='aooq604 "',g_gev04,'" "5" "',g_prog,'" "',g_pmca.pmca01,'"'                                              
                CALL cl_cmdrun(l_cmd)                                                                                             
            END IF     
          ELSE
              CALL cl_err('',-400,0)                                                                                                   
          END IF         #NO.FUN-820028                                                                                                         
 
      ON ACTION easyflow_approval            
          LET g_action_choice="approval_status"   
          IF cl_chk_act_auth() THEN
              #FUN-C20026 add str---
               SELECT * INTO g_pmca.* FROM pmca_file
                WHERE pmcano = g_pmca.pmcano
               CALL i610_show()
              #FUN-C20026 add end---
               CALL i610_ef() 
               CALL i610_show()  #FUN-C20026 add
          END IF
 
      ON ACTION approval_status                 
          LET g_action_choice="approval_status"
          IF cl_chk_act_auth() THEN
             IF aws_condition2() THEN
                  CALL aws_efstat2()        
             END IF
          END IF
 
      ON ACTION confirm           
         LET g_action_choice="confirm"
         IF cl_chk_act_auth() THEN
             CALL i610_y_chk()          #CALL 原確認的 check 段
             IF g_success = "Y" THEN
                 CALL i610_y_upd()      #CALL 原確認的 update 段
             END IF
         END IF
          
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         IF cl_chk_act_auth() THEN
            CALL i610_z()
         END IF
 
      #補料號
      ON ACTION input_vendorno
         LET g_action_choice="input_vendorno"
         IF cl_chk_act_auth() THEN
             LET g_errno=''
             CASE 
              WHEN g_pmca.pmca05='2'
                    LET g_errno = 'axm-225'
                    #已拋轉，不可再異動!
#TQC-B40200 --begin--                    
              WHEN g_pmca.pmca05 = 'S'
                   LET g_errno = 'apm-228'
#TQC-B40200 --end--                         
              WHEN g_pmca.pmca00 = 'U' 
                    LET g_errno = 'aim-158'
                    #只在申請類別為"新增"時,可使用此Action!
              OTHERWISE
                   LET g_errno=''
             END CASE
             IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pmca.pmcano,g_errno,1)
             ELSE
                 LET g_input_vendorno = 'Y'
                 CALL i610_u()
                 LET g_input_vendorno = 'N'
             END IF
         END IF
 
      #@ON ACTION 資料拋轉
        ON ACTION carry_data
            LET g_action_choice="carry_data"
            IF cl_chk_act_auth() THEN
              IF cl_null(g_pmca.pmca01) THEN
                 CALL cl_err('',-400,0)
                #廠商編號為空,請補上廠商編號
                CALL cl_err(g_pmca.pmcano,'apm-617','1')
              ELSE   
               LET l_priv1=g_priv1
               LET l_priv2=g_priv2
               LET l_priv3=g_priv3
               CALL i610_dbs()
               CALL i610_show()
               LET g_priv1=l_priv1
               LET g_priv2=l_priv2
               LET g_priv3=l_priv3
             END IF
           END IF
           SELECT * INTO g_pmca.* FROM pmca_file 
            WHERE pmcano = g_pmca.pmcano
           CALL i610_show()
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         IF cl_chk_act_auth() THEN
            CALL i610_copy()
         END IF
 
      ON ACTION output
         LET g_action_choice="output"
         IF cl_chk_act_auth() THEN
            CALL i610_out()
         END IF
 
      ON ACTION help
         CALL cl_show_help()
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   
         CALL cl_set_combo_lang("pmca911")       #MOD-970184 add
         CALL i610_show_pic()
 
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU

      ON ACTION jump
         CALL i610_fetch('/')
      ON ACTION first
         CALL i610_fetch('F')
      ON ACTION last
         CALL i610_fetch('L')

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION controlg      
         CALL cl_cmdask()     
        #"准"
        ON ACTION agree
            LET g_action_choice="agree"
              IF g_laststage = "Y" AND l_flowuser = 'N' THEN #最後一關
                 CALL i610_y_upd()      #CALL 原確認的 update 段
              ELSE
                 LET g_success = "Y"
                 IF NOT aws_efapp_formapproval() THEN
                    LET g_success = "N"
                 END IF
              END IF
              IF g_success = 'Y' THEN
                    IF cl_confirm('aws-081') THEN
                       IF aws_efapp_getnextforminfo() THEN
                          LET l_flowuser = 'N'
                          LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                          IF NOT cl_null(g_argv1) THEN
                                CALL i610_q()
                                #設定簽核功能及哪些 action 在簽核狀態時是不可被>
                                CALL aws_efapp_flowaction("insert, modify,
                                delete,            detail, query, locale,
                                void,confirm, undo_confirm,easyflow_approval,input_vendorno,unconfirm,carry_data") #FUN-C30017 add unconfirm,carry_data
                                            #TQC-B40200 add input_vendorno
                                      RETURNING g_laststage
                          ELSE
                              EXIT MENU
                          END IF
                        ELSE
                            EXIT MENU
                        END IF
                    ELSE
                        EXIT MENU
                    END IF
              END IF
 
         #"不准"
         ON ACTION deny
            LET g_action_choice="deny"
             IF (l_creator := aws_efapp_backflow()) IS NOT NULL THEN
                IF aws_efapp_formapproval() THEN
                   IF l_creator = "Y" THEN
                      LET g_pmca.pmca05 = 'R'
                      DISPLAY BY NAME g_pmca.pmca05
                   END IF
                   IF cl_confirm('aws-081') THEN
                      IF aws_efapp_getnextforminfo() THEN
                          LET l_flowuser = 'N'
                          LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                          IF NOT cl_null(g_argv1) THEN
                                CALL i610_q()
                                #設定簽核功能及哪些 action 在簽核狀態時是不可被>
                                CALL aws_efapp_flowaction("insert, modify,
                                delete,           detail, query, locale,void,
                                confirm, undo_confirm,easyflow_approval,input_vendorno,unconfirm,carry_data") #FUN-C30017 add unconfirm,carry_data
                                             #TQC-B40200 add input_vendorno
                                      RETURNING g_laststage
                          ELSE
                                 EXIT MENU
                          END IF
                      ELSE
                             EXIT MENU
                      END IF
                   ELSE
                       EXIT MENU
                   END IF
                END IF
              END IF
 
         #@WHEN "加簽"
         ON ACTION modify_flow
            LET g_action_choice="modify_flow"
              IF aws_efapp_flowuser() THEN
                 LET g_laststage = 'N'
                 LET l_flowuser = 'Y'
              ELSE
                 LET l_flowuser = 'N'
              END IF
 
         #"撤簽"
         ON ACTION withdraw
            LET g_action_choice="withdraw"
              IF cl_confirm("aws-080") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT MENU
                 END IF
              END IF
 
         #"抽單"
         ON ACTION org_withdraw
            LET g_action_choice="org_withdraw"
              IF cl_confirm("aws-079") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT MENU
                 END IF
              END IF
 
        #"簽核意見"
         ON ACTION phrase
            LET g_action_choice="phrase"
              CALL aws_efapp_phrase()
 
         ON ACTION related_document       #相關文件
            LET g_action_choice="related_document"
              IF cl_chk_act_auth() THEN
                 IF g_pmca.pmcano IS NOT NULL THEN
                 LET g_doc.column1 = "pmcano"
                 LET g_doc.value1 = g_pmca.pmcano
                 CALL cl_doc()
               END IF
            END IF
 
       -- for Windows close event trapped
       ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET INT_FLAG=FALSE 		
           LET g_action_choice = "exit"
           EXIT MENU
 
      &include "qry_string.4gl"
   END MENU
   CLOSE i610_cs
END FUNCTION
 
 
FUNCTION i610_a()
   DEFINE   li_result        LIKE type_file.num5    #No.FUN-680136 SMALLINT                
   DEFINE   l_pmca22         LIKE aza_file.aza17
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   MESSAGE ""
   CLEAR FORM                                  # 清螢墓欄位內容
   INITIALIZE g_pmca.* LIKE pmca_file.*
   LET g_wc = NULL
   LET g_pmcano_t = NULL
   LET g_pmca01_t = NULL
   LET g_pmca24_t = NULL
   LET g_pmca_t.* = g_pmca.*			# 保留舊值
   LET g_pmca_o.* = g_pmca.*		  	# 保留舊值
   LET g_pmca.pmca00 ='I' #新增
   LET g_pmca.pmca05 ='0' #0:開立
   LET g_pmca.pmca23 ='N' #不需簽核
   LET g_pmca.pmca14 = '1'       		# 資料性質
   IF cl_null(g_pmca.pmca14) THEN LET g_pmca.pmca14 = '1' END IF
   LET g_pmca.pmca22 = g_aza.aza17   # 幣別
   LET g_pmca.pmca27 = '1'           # 寄領方式
   LET g_pmca.pmca30 = '3'           # 廠商性質預設為兩者
   LET g_pmca.pmca45 =  0            # AP AMT
   LET g_pmca.pmca46 =  0            # AP AMT
   LET g_pmca.pmca48 =  'Y'   	     # 禁止背書
   LET g_pmca.pmca902 = '0'
   LET g_pmca.pmca903 = 'N'
   LET g_pmca.pmca911 = g_lang
   LET g_pmca.pmca914 = 'N' #FUN-B90080 add 
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL cl_show_fld_cont()       
      LET g_pmca.pmcaacti = 'Y'                 # 有效的資料
      LET g_pmca.pmcauser = g_user		# 使用者
      LET g_pmca.pmcaoriu = g_user #FUN-980030
      LET g_pmca.pmcaorig = g_grup #FUN-980030
      LET g_pmca.pmcagrup = g_grup              # 使用者所屬群
      LET g_pmca.pmcadate = g_today		# 更改日期
      CALL i610_i("a")                     # 各欄位輸入
      IF INT_FLAG THEN                        # 若按了DEL鍵
         INITIALIZE g_pmca.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF
      IF g_pmca.pmcano IS NULL THEN              # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      BEGIN WORK     
 
      CALL s_auto_assign_no("apm",g_pmca.pmcano,g_pmca.pmcadate,"Z","pmca_file","pmcano","","","") RETURNING li_result,g_pmca.pmcano
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_pmca.pmcano
 
      INSERT INTO pmca_file VALUES(g_pmca.*)     # DISK WRITE
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","pmca_file",g_pmca.pmca01,"",SQLCA.sqlcode,"","",1)  
         ROLLBACK WORK    
         CONTINUE WHILE
      ELSE
         LET g_pmca_t.* = g_pmca.*              # 保存上筆資料
         SELECT pmcano INTO g_pmca.pmcano FROM pmca_file
          WHERE pmcano = g_pmca.pmcano
      END IF
 
      IF g_pmca.pmca00 = 'U' THEN   #CHI-CB0017 add
         CALL i610_copy_refdoc()    #CHI-CB0017 add
      END IF                        #CHI-CB0017 add

      COMMIT WORK
      #TQC-BA0126--begin
      IF NOT cl_null(g_pmca.pmcano) AND g_smy.smydmy4='Y' AND g_smy.smyapr <> 'Y' THEN
         LET g_action_choice = "insert"
         CALL i610_y_chk()
         IF g_success = "Y" THEN
            CALL i610_y_upd()
         END IF
      END IF
      IF g_smy.smyprint='Y' THEN
         CALL i610_out()
       END IF
      #TQC-BA0126--end
      CALL cl_flow_notify(g_pmca.pmcano,'I')   #MOD-860238
      CALL cl_err("INSERT pmca_file","abm-019",0) #執行成功！
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i610_i(p_cmd)
   DEFINE l_pmcano      LIKE pmca_file.pmcano
   DEFINE
       p_cmd           LIKE type_file.chr1,  		 #狀態  #No.FUN-680136 VARCHAR(1)
       l_flag          LIKE type_file.chr1,  		 #是否必要欄位有輸入  #No.FUN-680136 VARCHAR(1)
       l_cmd           LIKE type_file.chr1000,   #No.FUN-680136 VARCHAR(30)
       g_msg_i600      LIKE ze_file.ze03,        #No.FUN-680136 VARCHAR(80)  #NO.FUN-820028
       l_msg           LIKE ze_file.ze03,        #No.FUN-680136 VARCHAR(80)
       l_pmca03_d      LIKE pmca_file.pmca03,    #No.FUN-680136 VARCHAR(10)
       l_pmca22         LIKE aza_file.aza17,	 #幣別
       l_pmca03         LIKE pmca_file.pmca03,	 #簡稱
       l_pmca06         LIKE pmca_file.pmca06,	 #區域代號
       x1,x2		LIKE pmca_file.pmca01,   #No.FUN-680136 VARCHAR(10)
       l_n,l_cnt        LIKE type_file.num5,     #No.FUN-680136 SMALLINT
       l_str            STRING           
   DEFINE li_result     LIKE type_file.num5                #No.FUN-680136 SMALLINT
   DEFINE l_pmca24       STRING                  #CHI-A80049 add
   DEFINE l_cot1        LIKE type_file.num5    #FUN-B90080 add
   DEFINE l_s           STRING                 #FUN-B90080 add
   DEFINE l_t           LIKE type_file.num5    #FUN-B90080 add
   DEFINE l_a           LIKE type_file.num5    #FUN-B90080 add  
   DEFINE l_cnt1        LIKE type_file.num5    #CHI-D30027 add  
   DEFINE l_cnt2        LIKE type_file.num5    #CHI-D30027 add

   LET g_on_change = TRUE   
   INPUT BY NAME g_pmca.pmcaoriu,g_pmca.pmcaorig,
         g_pmca.pmca00  ,g_pmca.pmcano  ,g_pmca.pmca01  ,g_pmca.pmca03  ,g_pmca.pmca081,g_pmca.pmca082,g_pmca.pmca24 ,g_pmca.pmca903,g_pmca.pmca14 ,
         g_pmca.pmca02  ,g_pmca.pmca30  ,g_pmca.pmca04  ,g_pmca.pmca901 ,g_pmca.pmca05 ,g_pmca.pmca23 ,
         g_pmca.pmca17  ,g_pmca.pmca49  ,g_pmca.pmca22  ,g_pmca.pmca47  ,g_pmca.pmca54 ,g_pmca.pmca911,
         g_pmca.pmca48  ,g_pmca.pmca902 ,g_pmca.pmca27  ,g_pmca.pmca50  ,g_pmca.pmca51 ,g_pmca.pmca28 ,g_pmca.pmca281,   #CHI-C20021 add pmca281
         g_pmca.pmca908 ,g_pmca.pmca07  ,g_pmca.pmca06  ,g_pmca.pmca904 ,g_pmca.pmca091,g_pmca.pmca092,g_pmca.pmca093,g_pmca.pmca094,g_pmca.pmca095,
         g_pmca.pmca52  ,g_pmca.pmca53  ,g_pmca.pmca15  ,g_pmca.pmca16  ,
         g_pmca.pmca56  ,g_pmca.pmca55  ,g_pmca.pmca10  ,g_pmca.pmca11  ,g_pmca.pmca12 ,
         g_pmca.pmca914,g_pmca.pmca915  ,g_pmca.pmca916 ,g_pmca.pmca917 ,g_pmca.pmca918, #FUN-B90080 add
         g_pmca.pmca919,g_pmca.pmca920  ,g_pmca.pmca921 ,g_pmca.pmca922 ,g_pmca.pmca923, #FUN-B90080 add
         g_pmca.pmcauser,g_pmca.pmcagrup,g_pmca.pmcamodu,g_pmca.pmcadate,g_pmca.pmcaacti,
         g_pmca.pmcaud01,g_pmca.pmcaud02,g_pmca.pmcaud03,g_pmca.pmcaud04,
         g_pmca.pmcaud05,g_pmca.pmcaud06,g_pmca.pmcaud07,g_pmca.pmcaud08,
         g_pmca.pmcaud09,g_pmca.pmcaud10,g_pmca.pmcaud11,g_pmca.pmcaud12,
         g_pmca.pmcaud13,g_pmca.pmcaud14,g_pmca.pmcaud15 
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i610_set_entry(p_cmd)
          CALL i610_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
        AFTER FIELD pmca00
            IF cl_null(g_pmca.pmca00) THEN
                NEXT FIELD pmca00
            END IF
            CALL i610_set_entry(p_cmd)
            CALL i610_set_no_entry(p_cmd)
 
        #只要申請類別(I:新增 U:修改)有變,供應廠商編號pmca01就應重key
        ON CHANGE pmca00
            LET g_pmca.pmca01  = NULL
            LET g_pmca.pmca03  = NULL
            LET g_pmca.pmca081 = NULL
            LET g_pmca.pmca082 = NULL
            LET g_pmca_t.pmca01  = NULL
            LET g_pmca_t.pmca03  = NULL
            LET g_pmca_t.pmca081 = NULL
            LET g_pmca_t.pmca082 = NULL
            DISPLAY BY NAME g_pmca.pmca01,g_pmca.pmca03,g_pmca.pmca081,g_pmca.pmca082
 
        AFTER FIELD pmcano
          IF NOT cl_null(g_pmca.pmcano) THEN
             LET l_n = 0 
             SELECT COUNT(*) INTO l_n
               FROM pmca_file 
              WHERE pmcano=g_pmca.pmcano
             IF l_n > 0 THEN
                CALL cl_err('sel pmca:','-239',0)
                NEXT FIELD pmcano
             END IF
             LET g_t1=s_get_doc_no(g_pmca.pmcano)
  	     CALL s_check_no('apm',g_pmca.pmcano,"","Z","pmca_file","pmcano","") RETURNING li_result,g_pmca.pmcano 
             IF (NOT li_result) THEN
                  LET g_pmca.pmcano=g_pmca_t.pmcano
                  NEXT FIELD pmcano
             END IF
             LET g_t1=g_pmca.pmcano[1,g_doc_len]
             LET  g_pmca.pmca23 = g_smy.smyapr
             DISPLAY By NAME g_pmca.pmca23
          END IF
 
        BEFORE FIELD pmca01
            IF g_pmca.pmca00 = 'I' AND cl_null(g_pmca.pmca01) THEN #新增且申請供應商編號為空時,才CALL自動編號附程式
                IF g_aza.aza30 = 'Y' THEN
                   #-----MOD-A70159---------
                   #CALL s_auno(g_pmca.pmca01,'3','') RETURNING g_pmca.pmca01,g_pmca.pmca03  #No.FUN-850100
                   CALL s_auno(g_pmca.pmca01,'3','') RETURNING g_pmca.pmca01,l_pmca03 
                   IF cl_null(g_pmca.pmca03) THEN
                      LET g_pmca.pmca03 = l_pmca03
                   END IF
                   #-----END MOD-A70159-----
                END IF
            END IF
            CALL i610_set_entry(p_cmd) #CHI-A80049 add
            #CALL i610_set_no_entry(p_cmd) #MOD-B40226 add #FUN-B90080 mark
 
        AFTER FIELD pmca01
            IF NOT cl_null(g_pmca.pmca01) THEN
               #-----MOD-A80234---------
               #IF cl_null(g_pmca_t.pmca01) OR ( g_pmca.pmca01 != g_pmca_t.pmca01) THEN  
               IF p_cmd = "a" OR         
                 (p_cmd = "u" AND g_pmca.pmca01 != g_pmca01_t) THEN
               #-----END MOD-A80234-----
                  IF g_pmca.pmca00 = 'I' THEN #新增
                      SELECT count(*) INTO l_n FROM pmc_file
                       WHERE pmc01 = g_pmca.pmca01
                      IF l_n > 0 THEN
                         CALL cl_err(g_pmca.pmca01,-239,1) #FUN-7C0084 mod
                         LET g_pmca.pmca01 = g_pmca_t.pmca01
                         DISPLAY BY NAME g_pmca.pmca01
                         NEXT FIELD pmca01
                      END IF
                      SELECT count(*) INTO l_n FROM pmca_file
                       WHERE pmca01 = g_pmca.pmca01
                         AND pmca00 = 'I' #新增
                      IF l_n > 0 THEN
                         CALL cl_err(g_pmca.pmca01,-239,1)
                         LET g_pmca.pmca01 = g_pmca_t.pmca01
                         DISPLAY BY NAME g_pmca.pmca01
                         NEXT FIELD pmca01
                      END IF
                      CALL s_field_chk(g_pmca.pmca01,'5',g_plant,'pmc01') RETURNING g_flag2                                               
                      IF g_flag2 = '0' THEN                                                                                             
                         CALL cl_err(g_pmca.pmca01,'aoo-043',1)                                                                           
                         LET g_pmca.pmca01 = g_pmca_t.pmca01                                                                                
                         DISPLAY BY NAME g_pmca.pmca01                                                                                    
                         NEXT FIELD pmca01
                      END IF
                      CALL i610_set_pmca03('a')    #No.TQC-C70218
                  ELSE
                      SELECT count(*) INTO l_n FROM pmc_file
                       WHERE pmc01 = g_pmca.pmca01
                      IF l_n <= 0 THEN
                         #無此供應廠商, 請重新輸入!
                         CALL cl_err(g_pmca.pmca01,'aap-000',1)
                         LET g_pmca.pmca01 = g_pmca_t.pmca01
                         DISPLAY BY NAME g_pmca.pmca01
                         NEXT FIELD pmca01
                      END IF
                      LET l_pmcano = NULL
                      SELECT pmcano INTO l_pmcano FROM pmca_file
                       WHERE pmca01 = g_pmca.pmca01
                         AND pmca00 = 'U' #修改
                         AND pmca05 != '2' 
                         AND pmcaacti != 'N' #MOD-B40095 add
                      IF NOT cl_null(l_pmcano) THEN
                         #已存在一張相同廠商,但未拋轉的廠商申請單!
                         CALL cl_err(l_pmcano,'apm-601',1)
                         LET g_pmca.pmca01 = g_pmca_t.pmca01
                         DISPLAY BY NAME g_pmca.pmca01
                         NEXT FIELD pmca01
                      END IF
                      
                      LET g_pmca_t.pmca00  = g_pmca.pmca00
                      LET g_pmca_t.pmcano  = g_pmca.pmcano
                      LET g_pmca_t.pmca011 = g_pmca.pmca011
                      LET g_pmca_t.pmca23  = g_pmca.pmca23
                      LET g_pmca_t.pmca05  = g_pmca.pmca05
                      LET g_pmca_t.pmcaacti= g_pmca.pmcaacti
                      LET g_pmca_t.pmcauser= g_pmca.pmcauser
                      LET g_pmca_t.pmcagrup= g_pmca.pmcagrup
                      LET g_pmca_t.pmcamodu= g_pmca.pmcamodu
                      LET g_pmca_t.pmcadate= g_pmca.pmcadate
                     #CHI-AC0001 mod --start--
                     #SELECT 'U','@1','@2',pmc_file.* INTO g_pmca.* FROM pmc_file
                      SELECT 'U','@1','@2', 
                             pmc01,    pmc02,    pmc03,    pmc04,    pmc05,    
                             pmc06,    pmc07,    pmc081,   pmc082,   pmc091,   
                             pmc092,   pmc093,   pmc094,   pmc095,   pmc10,    
                             pmc11,    pmc12,    pmc13,    pmc14,    pmc15,    
                             pmc16,    pmc17,    pmc18,    pmc19,    pmc20,    
                             pmc21,    pmc22,    pmc23,    pmc24,    pmc25,    
                             pmc26,    pmc27,    pmc28,    pmc281,   pmc30,    pmc40,     #CHI-C20021 add pmc281
                             pmc41,    pmc42,    pmc43,    pmc44,    pmc45,    
                             pmc46,    pmc47,    pmc48,    pmc49,    pmc50,    
                             pmc51,    pmc52,    pmc53,    pmc54,    pmc55,    
                             pmc56,    pmc901,   pmc902,   pmc903,   pmc904,   
                             pmc905,   pmc906,   pmc907,   pmc908,   pmc909,   
                             pmc910,   pmc911,   pmcacti,  pmcuser,  pmcgrup,  
                             pmcmodu,  pmcdate,  pmcud01,  pmcud02,  pmcud03,  
                             pmcud04,  pmcud05,  pmcud06,  pmcud07,  pmcud08,  
                             pmcud09,  pmcud10,  pmcud11,  pmcud12,  pmcud13,  
                             pmcud14,  pmcud15,  pmcoriu,  pmcorig,
                             #FUN-B90080 add --start--
                             pmc914,   pmc915,   pmc916,   pmc917,   pmc918,   
                             pmc919,   pmc920,   pmc921,   pmc922,   pmc923                             
                             #FUN-B90080 add --end--  
                        INTO g_pmca.pmca00,    g_pmca.pmcano,    g_pmca.pmca011,    
                             g_pmca.pmca01,    g_pmca.pmca02,    g_pmca.pmca03,    g_pmca.pmca04,    g_pmca.pmca05,    
                             g_pmca.pmca06,    g_pmca.pmca07,    g_pmca.pmca081,   g_pmca.pmca082,   g_pmca.pmca091,   
                             g_pmca.pmca092,   g_pmca.pmca093,   g_pmca.pmca094,   g_pmca.pmca095,   g_pmca.pmca10,    
                             g_pmca.pmca11,    g_pmca.pmca12,    g_pmca.pmca13,    g_pmca.pmca14,    g_pmca.pmca15,    
                             g_pmca.pmca16,    g_pmca.pmca17,    g_pmca.pmca18,    g_pmca.pmca19,    g_pmca.pmca20,    
                             g_pmca.pmca21,    g_pmca.pmca22,    g_pmca.pmca23,    g_pmca.pmca24,    g_pmca.pmca25,    
                             g_pmca.pmca26,    g_pmca.pmca27,    g_pmca.pmca28,    g_pmca.pmca281,   g_pmca.pmca30,    g_pmca.pmca40, #CHI-C20021 add g_pmca.pmca281   
                             g_pmca.pmca41,    g_pmca.pmca42,    g_pmca.pmca43,    g_pmca.pmca44,    g_pmca.pmca45,    
                             g_pmca.pmca46,    g_pmca.pmca47,    g_pmca.pmca48,    g_pmca.pmca49,    g_pmca.pmca50,    
                             g_pmca.pmca51,    g_pmca.pmca52,    g_pmca.pmca53,    g_pmca.pmca54,    g_pmca.pmca55,    
                             g_pmca.pmca56,    g_pmca.pmca901,   g_pmca.pmca902,   g_pmca.pmca903,   g_pmca.pmca904,   
                             g_pmca.pmca905,   g_pmca.pmca906,   g_pmca.pmca907,   g_pmca.pmca908,   g_pmca.pmca909,   
                             g_pmca.pmca910,   g_pmca.pmca911,   g_pmca.pmcaacti,  g_pmca.pmcauser,  g_pmca.pmcagrup,  
                             g_pmca.pmcamodu,  g_pmca.pmcadate,  g_pmca.pmcaud01,  g_pmca.pmcaud02,  g_pmca.pmcaud03,  
                             g_pmca.pmcaud04,  g_pmca.pmcaud05,  g_pmca.pmcaud06,  g_pmca.pmcaud07,  g_pmca.pmcaud08,  
                             g_pmca.pmcaud09,  g_pmca.pmcaud10,  g_pmca.pmcaud11,  g_pmca.pmcaud12,  g_pmca.pmcaud13,  
                             g_pmca.pmcaud14,  g_pmca.pmcaud15,  g_pmca.pmcaoriu,  g_pmca.pmcaorig,
                             #FUN-B90080 add --start--
                             g_pmca.pmca914,   g_pmca.pmca915,   g_pmca.pmca916,   g_pmca.pmca917,   g_pmca.pmca918,   
                             g_pmca.pmca919,   g_pmca.pmca920,   g_pmca.pmca921,   g_pmca.pmca922,   g_pmca.pmca923                             
                             #FUN-B90080 add --end--  
                        FROM pmc_file
                     #CHI-AC0001 mod --end--
                       WHERE pmc01 = g_pmca.pmca01
                      LET g_pmca.pmca00  = g_pmca_t.pmca00 
                      LET g_pmca.pmcano  = g_pmca_t.pmcano 
                      LET g_pmca.pmca011 = g_pmca_t.pmca011
                      LET g_pmca.pmca23  = g_pmca_t.pmca23
                      LET g_pmca.pmca05  = g_pmca_t.pmca05
                      LET g_pmca.pmcaacti= g_pmca_t.pmcaacti
                      LET g_pmca.pmcauser= g_pmca_t.pmcauser
                      LET g_pmca.pmcagrup= g_pmca_t.pmcagrup
                      LET g_pmca.pmcamodu= g_pmca_t.pmcamodu
                      LET g_pmca.pmcadate= g_pmca_t.pmcadate
                  END IF
                  IF g_pmca.pmca30 = '3' THEN
                      LET g_pmca.pmca04 =g_pmca.pmca01 #付款廠商編號
                      LET g_pmca.pmca901=g_pmca.pmca01 #出貨廠商
                  END IF
                  CALL i610_show()
               END IF
            ELSE                             
            #IF g_pmca.pmca00<>'I' THEN                   #MOD-AC0310 mark
             IF g_pmca.pmca00<>'I' AND p_cmd != 'a' THEN  #MOD-AC0310 add
               CALL cl_err('',-400,0)       
               DISPLAY BY NAME g_pmca.pmca01 
               NEXT FIELD pmca01             
             END IF 
            END IF
            CALL i610_set_no_entry(p_cmd) #FUN-B90080 add
 
      AFTER FIELD pmca03
         IF NOT cl_null(g_pmca.pmca03) THEN
            LET l_n =0
            SELECT count(*) INTO l_n FROM pmca_file
             WHERE pmca03 = g_pmca.pmca03 AND pmca01 != g_pmca.pmca01
             IF l_n > 0 THEN CALL cl_err('','apm-035',0) END IF   #No.MOD-570066
 
            IF cl_null(g_pmca.pmca081)  THEN
               LET g_pmca.pmca081=g_pmca.pmca03
               DISPLAY BY NAME g_pmca.pmca081
            END IF
         END IF
 
       AFTER FIELD pmca908                       #查詢地區
          IF NOT cl_null(g_pmca.pmca908)  THEN
             IF cl_null(g_pmca_o.pmca908) OR cl_null(g_pmca_t.pmca908) #CHI-A80049 add 
                OR (g_pmca.pmca908 != g_pmca_o.pmca908) THEN           #CHI-A80049 add
       	       	CALL i610_pmca908('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_pmca.pmca908,g_errno,0)
                   LET g_pmca.pmca908 = g_pmca_o.pmca908
                   DISPLAY BY NAME g_pmca.pmca908
                   DISPLAY ' ' TO pmca07
                   DISPLAY ' ' TO pmca06
                   DISPLAY ' ' TO geb02
                   DISPLAY ' ' TO gea02
                   NEXT FIELD pmca908
                END IF
             END IF #CHI-A80049 add 
          #CHI-A80049 add --start--
          ELSE
             DISPLAY '' TO geo02
             LET g_pmca.pmca06 = ' '
             LET g_pmca.pmca07 = ' '
             DISPLAY BY NAME g_pmca.pmca07
             DISPLAY '' TO geb02
             DISPLAY BY NAME g_pmca.pmca06
             DISPLAY '' TO gea02
          #CHI-A80049 add --end--
          END IF
          LET g_pmca_o.pmca908 = g_pmca.pmca908

      #CHI-A80049 add --start--
       AFTER FIELD pmca07                       #查詢國別
          IF NOT cl_null(g_pmca.pmca07)  THEN
             IF cl_null(g_pmca_o.pmca07) OR cl_null(g_pmca_t.pmca07)
                OR (g_pmca.pmca07 != g_pmca_o.pmca07) THEN
       	       	CALL i610_pmca07('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_pmca.pmca07,g_errno,0)
                   LET g_pmca.pmca07 = g_pmca_o.pmca07
                   DISPLAY BY NAME g_pmca.pmca07
                   DISPLAY ' ' TO pmca06
                   DISPLAY ' ' TO gea02
                   DISPLAY ' ' TO geb02
                    CALL i610_pmca07('a')
                   NEXT FIELD pmca07
                END IF
             END IF
          END IF
          LET g_pmca_o.pmca07 = g_pmca.pmca07

        AFTER FIELD pmca06                       #查詢區域
           IF NOT cl_null(g_pmca.pmca06)  THEN
              IF cl_null(g_pmca_o.pmca06) OR cl_null(g_pmca_t.pmca06)
                 OR (g_pmca.pmca06 != g_pmca_o.pmca06) THEN
        	       	CALL i610_pmca06('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_pmca.pmca06,g_errno,0)
                    LET g_pmca.pmca06 = g_pmca_o.pmca06
                    DISPLAY BY NAME g_pmca.pmca06
                    DISPLAY ' ' TO pmca06
                    DISPLAY ' ' TO gea02
                    DISPLAY ' ' TO geb02
                    CALL i610_pmca06('a')
                    NEXT FIELD pmca06
                 END IF
              END IF
           END IF
           LET g_pmca_o.pmca06 = g_pmca.pmca06
      #CHI-A80049 add --end--

      BEFORE FIELD pmca05
         DISPLAY BY NAME g_pmca.pmca05
 
      AFTER FIELD pmca05                       #目前狀況
         IF g_pmca.pmca05 IS NULL THEN
            CALL cl_err(g_pmca.pmca05,'mfg3284',0)
            LET g_pmca.pmca05=g_pmca_o.pmca05
            DISPLAY BY NAME g_pmca.pmca05
            NEXT FIELD pmca05
         END IF
         IF g_pmca_o.pmca05 != g_pmca.pmca05 THEN
            CALL i610_pmca05()
         END IF
         LET g_pmca_o.pmca05 = g_pmca.pmca05
 
      BEFORE FIELD pmca14
         CALL i610_set_entry(p_cmd)
 
      AFTER FIELD pmca14                       #資料性質
         CALL s_field_chk(g_pmca.pmca14,'5',g_plant,'pmc14') RETURNING g_flag2                                               
         IF g_flag2 = '0' THEN                                                                                             
            CALL cl_err(g_pmca.pmca14,'aoo-043',1)                                                                           
            LET g_pmca.pmca14 = g_pmca_t.pmca14                                                                                
            DISPLAY BY NAME g_pmca.pmca14                                                                                    
            NEXT FIELD pmca14
         END IF
         CALL i610_set_no_entry(p_cmd)
 
      BEFORE FIELD pmca30
         CALL i610_set_entry(p_cmd)
 
      AFTER FIELD pmca30                       #廠商性質
         CASE g_pmca.pmca30
            WHEN '1'
                 IF g_pmca.pmca04 = g_pmca.pmca01 THEN
                     LET g_pmca.pmca04=NULL        #付款廠商編號
                 END IF
                 LET g_pmca.pmca901=g_pmca.pmca01#出貨廠商
            WHEN '2'
                 LET g_pmca.pmca04=g_pmca.pmca01 #付款廠商編號
                 IF g_pmca.pmca901 = g_pmca.pmca01 THEN
                     LET g_pmca.pmca901=NULL       #出貨廠商
                 END IF
            WHEN '3'
                 LET g_pmca.pmca04=g_pmca.pmca01 #付款廠商編號
                 LET g_pmca.pmca901=g_pmca.pmca01#出貨廠商
         END CASE
         DISPLAY BY NAME g_pmca.pmca04,g_pmca.pmca901
         LET g_pmca_o.pmca30 = g_pmca.pmca30
         CALL i610_set_no_entry(p_cmd)
 
      AFTER FIELD pmca04                	#付款廠商
          IF NOT cl_null(g_pmca.pmca04) THEN 
            IF g_pmca.pmca04 = g_pmca.pmca901 THEN
               CALL cl_err(g_pmca.pmca04,'apm-033',0) #付款廠商和出貨廠商不可相同
               LET g_pmca.pmca04 = g_pmca_o.pmca04
               DISPLAY BY NAME g_pmca.pmca04
               NEXT FIELD pmca04
            END IF
            CALL i610_pmca04('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_pmca.pmca04,g_errno,0)
               LET g_pmca.pmca04 = g_pmca_o.pmca04
               DISPLAY BY NAME g_pmca.pmca04
                CALL i610_pmca04('a') #MOD-550023
               NEXT FIELD pmca04
            END IF
         END IF
         SELECT pmca03 INTO l_pmca03_d FROM pmca_file 
          WHERE pmca01 = g_pmca.pmca04
         DISPLAY l_pmca03_d TO pmca03_d
         LET g_pmca_o.pmca04 = g_pmca.pmca04
 
      AFTER FIELD pmca901   #出貨廠商
         IF NOT cl_null(g_pmca.pmca901) THEN #MOD-530531
            IF g_pmca.pmca04 = g_pmca.pmca901 THEN
               CALL cl_err(g_pmca.pmca901,'apm-033',0) #付款廠商和出貨廠商不可相同
               LET g_pmca.pmca901 = g_pmca_o.pmca901
               DISPLAY BY NAME g_pmca.pmca901
               NEXT FIELD pmca901
            END IF
            CALL i610_pmca901('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_pmca.pmca901,g_errno,0)
               LET g_pmca.pmca901 = g_pmca_o.pmca901
               DISPLAY BY NAME g_pmca.pmca901
                CALL i610_pmca901('a') #MOD-550023
               NEXT FIELD pmca901
            END IF
         END IF
 
      AFTER FIELD pmca24
         IF NOT cl_null(g_pmca.pmca24) THEN
            IF g_pmca_t.pmca24 IS NULL OR g_pmca_t.pmca24 <> g_pmca.pmca24 THEN
               LET x1=NULL
               SELECT MAX(pmca01) INTO x1 FROM pmca_file
                      WHERE pmca24=g_pmca.pmca24 AND pmca01<>g_pmca.pmca01
                        AND pmca30 <> '1'   #MOD-B30066 add
               CASE WHEN x1 IS NOT NULL
                         #CHI-D30027 add --start--
                         LET l_cnt1=0 LET l_cnt2=0
                         SELECT COUNT(*) INTO l_cnt1 FROM pmc_file
                                WHERE pmc24=g_pmca.pmca24 
                                  AND pmc30 <> '1' 
                                  AND pmcacti<>'N' #非無效的單據
                         SELECT COUNT(*) INTO l_cnt2 FROM pmc_file
                                WHERE pmc24=g_pmca.pmca24 
                                  AND pmc30 <> '1' 
                         IF (l_cnt1 > 0) OR l_cnt2=0 THEN #存在有效單據或未拋轉
                         #CHI-D30027 add --end--
                            CALL cl_getmsg('apm-600',g_lang) RETURNING l_str
                            ERROR l_str,x1,x2
                            IF g_pmca.pmca30 <> '1' THEN    #MOD-B30066 add
                               NEXT FIELD pmca24
                            END IF   #MOD-B30066 add
                         END IF   #CHI-D30027 add
                    WHEN SQLCA.SQLCODE=100
                    WHEN SQLCA.SQLCODE=0
                    OTHERWISE
                         CALL cl_err('sel pmca24:',SQLCA.SQLCODE,0)
                         NEXT FIELD pmca24
               END CASE
            END IF
            IF g_pmca.pmca01!='EMPL' AND g_pmca.pmca01!='MISC' THEN    #85-09-23
               IF g_aza.aza21 = 'Y' AND g_aza.aza26='0' THEN  #CHI-A80049 add AND g_aza.aza26='0'
                  LET l_pmca24= g_pmca.pmca24 CLIPPED #CHI-A80049 add
                  IF NOT s_chkban(g_pmca.pmca24) OR NOT cl_numchk(g_pmca.pmca24,8) #THEN #CHI-A80049 mark THEN
                     OR l_pmca24.getLength() > 8 THEN #CHI-A80049 add
                     CALL cl_err(g_pmca.pmca24,'aoo-080',0) NEXT FIELD pmca24
                  END IF
               END IF
            END IF
         END IF
         LET g_pmca_o.pmca24 = g_pmca.pmca24
 
      AFTER FIELD pmca091
         IF cl_null(g_pmca.pmca52) THEN LET g_pmca.pmca52 = g_pmca.pmca091 END IF
         IF cl_null(g_pmca.pmca53) THEN LET g_pmca.pmca53 = g_pmca.pmca091 END IF
 
      AFTER FIELD pmca22  		        #幣別
         IF NOT cl_null(g_pmca.pmca22) THEN
            IF cl_null(g_pmca_o.pmca22) OR cl_null(g_pmca_t.pmca22)
               OR  (g_pmca.pmca22 != g_pmca_o.pmca22 OR g_pmca.pmca22 = ' ' ) THEN
               CALL i610_pmca22(g_pmca.pmca22)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pmca.pmca22,g_errno,0)
                  LET g_pmca.pmca22 = g_pmca_o.pmca22
                  DISPLAY BY NAME g_pmca.pmca22
                   CALL i610_pmca22(g_pmca.pmca22) #MOD-550023
                  NEXT FIELD pmca22
               END IF
            END IF
          END IF
          LET g_pmca_o.pmca22 = g_pmca.pmca22
 
      AFTER FIELD pmca47  		        #稅別
         IF NOT cl_null(g_pmca.pmca47) THEN
            IF cl_null(g_pmca_o.pmca47) OR cl_null(g_pmca_t.pmca47)
               OR  (g_pmca.pmca47 != g_pmca_o.pmca47 OR g_pmca.pmca47 = ' ' ) THEN
               CALL i610_pmca47('d')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pmca.pmca47,g_errno,0)
                  LET g_pmca.pmca47 = g_pmca_o.pmca47
                  DISPLAY BY NAME g_pmca.pmca47
                   CALL i610_pmca47('d') #MOD-550023
                  NEXT FIELD pmca47
               END IF
            END IF
          END IF
          LET g_pmca_o.pmca47 = g_pmca.pmca47
 
      AFTER FIELD pmca54
         IF NOT cl_null(g_pmca.pmca54) THEN
            SELECT ofs01 FROM ofs_file WHERE ofs01=g_pmca.pmca54
            IF STATUS THEN
               CALL cl_err3("sel","ofs_file",g_pmca.pmca54,"","axm-461","","",1) 
               NEXT FIELD pmca54   
            END IF
         END IF
 
      AFTER FIELD pmca02 #廠商分類代碼
         IF NOT cl_null(g_pmca.pmca02) THEN
            CALL i610_pmca02('a')
            IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_pmca.pmca02,g_errno,0)
                LET g_pmca.pmca02 = g_pmca_t.pmca02
                DISPLAY BY NAME g_pmca.pmca02
                 CALL i610_pmca02('a') 
                NEXT FIELD pmca02
            END IF
         END IF
 
      AFTER FIELD pmca50 
         IF NOT cl_null(g_pmca.pmca50) THEN
            IF g_pmca.pmca50>31 OR g_pmca.pmca50 < 0 THEN       #No.TQC-740071
               CALL cl_err(g_pmca.pmca50,'apm-887',0)      #No.TQC-740071
               NEXT FIELD pmca50
            END IF
         END IF
 
      AFTER FIELD pmca51
         IF NOT cl_null(g_pmca.pmca51) THEN
            IF g_pmca.pmca51>31 OR g_pmca.pmca51 < 0 THEN       #No.TQC-740071
               CALL cl_err(g_pmca.pmca51,'apm-887',0)      #No.TQC-740071
               NEXT FIELD pmca51
            END IF
         END IF
 
      AFTER FIELD pmca15  		        #送貨地址
         IF NOT cl_null(g_pmca.pmca15) THEN
               CALL i610_area(g_pmca.pmca15,'0')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pmca.pmca15,g_errno,0)
                  LET g_pmca.pmca15 = g_pmca_o.pmca15
                  DISPLAY BY NAME g_pmca.pmca15
                  NEXT FIELD pmca15
               END IF
         END IF
         LET g_pmca_o.pmca15 = g_pmca.pmca15
 
      AFTER FIELD pmca16  		        #帳單地址
         IF NOT cl_null(g_pmca.pmca16) THEN
             CALL i610_area(g_pmca.pmca16,'1')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_pmca.pmca16,g_errno,0)
                LET g_pmca.pmca16 = g_pmca_o.pmca16
                DISPLAY BY NAME g_pmca.pmca16
                NEXT FIELD pmca16
             END IF
         END IF
         LET g_pmca_o.pmca16 = g_pmca.pmca16
 
      AFTER FIELD pmca49      #價格條件 97-06-18
         IF NOT cl_null(g_pmca.pmca49) THEN
            SELECT pnz02 INTO l_buf FROM pnz_file WHERE pnz01=g_pmca.pmca49 #FUN-930113 oah-->pnz
            IF STATUS THEN
               CALL cl_err3("sel","pnz_file",g_pmca.pmca49,"",STATUS,"sel pnz:","",1) #FUN-930113 oah-->pnz
               NEXT FIELD pmca49   
            END IF
            DISPLAY l_buf TO FORMONLY.pnz02 #FUN-930113 oah-->pnz
         END IF
 
      AFTER FIELD pmca27
         IF cl_null(g_pmca.pmca28) OR g_pmca.pmca28<=0 AND g_pmca.pmca27='1' THEN #寄出
             LET g_pmca.pmca28=0 
             DISPLAY BY NAME g_pmca.pmca28
         END IF
 
      AFTER FIELD pmca55   #匯款銀行
          IF NOT cl_null(g_pmca.pmca55) THEN
             SELECT nmt01 FROM nmt_file WHERE nmt01 = g_pmca.pmca55
             IF SQLCA.sqlcode THEN
                CALL cl_err3("sel","nmt_file",g_pmca.pmca55,"","apm-227","","",1)  
                NEXT FIELD pmca55
             END IF
          END IF
 
      AFTER FIELD pmca17                       #付款條件
         IF NOT cl_null(g_pmca.pmca17) THEN
            CALL i610_pmca17(g_pmca.pmca17)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_pmca.pmca17,g_errno,0)
               LET g_pmca.pmca17 = g_pmca_o.pmca17
               DISPLAY BY NAME g_pmca.pmca17
                CALL i610_pmca17(g_pmca.pmca17) #MOD-550023
               NEXT FIELD pmca17
            END IF
            LET g_pmca_o.pmca17 = g_pmca.pmca17
           ELSE                             #TQC-850019 add
              DISPLAY BY NAME g_pmca.pmca17 #TQC-850019 add
              NEXT FIELD pmca17             #TQC-850019 add
         END IF

      #CHI-A80049 add --start--
      BEFORE FIELD pmca28
         CALL i610_set_entry(p_cmd)
      #CHI-A80049 add --end--   
 
      AFTER FIELD pmca28
         IF NOT cl_null(g_pmca.pmca28) THEN
            IF g_pmca.pmca28 < 0 THEN NEXT FIELD pmca28 END IF
         END IF
         #CHI-C20021 add begin---------------------- 
         IF cl_null(g_pmca.pmca28) OR g_pmca.pmca28=0 THEN
            LET g_pmca.pmca281=NULL
            DISPLAY BY NAME g_pmca.pmca281 
         END IF
         #CHI-C20021 add end------------------------ 
         CALL i610_set_no_entry(p_cmd) #CHI-A80049 add
 
      #FUN-B90080 add --start--
      ON CHANGE pmca914
         CALL i610_set_entry(p_cmd)
         CALL i610_set_no_entry(p_cmd)

      AFTER FIELD pmca914
         CALL i610_set_entry(p_cmd)
         CALL i610_set_no_entry(p_cmd)

      AFTER FIELD pmca915
	#IF g_pmca.pmca915 IS NOT NULL AND g_pmca.pmca916 IS NOT NULL THEN  #FUN-D40103 mark
	IF g_pmca.pmca915 IS NOT NULL THEN                                  #FUN-D40103 add
           LET g_errno = ''                                                 #FUN-D40103 add
           IF g_pmca.pmca916 IS NOT NULL THEN                               #FUN-D40103 add
      #  IF g_pmca.pmca915 IS NOT NULL AND g_pmca.pmca916 IS NOT NULL THEN
           CALL i610_pmcachk(p_cmd,g_pmca.pmca915,g_pmca.pmca916,'1')
              #FUN-D60124--mark--str--
	      ##TQC-D50116--add--str--
              #IF cl_null(g_errno) THEN
              #   IF NOT s_imechk(g_pmca.pmca915,g_pmca.pmca916) THEN NEXT FIELD pmca916 END IF 
              #END IF 
              ##TQC-D50116--add--end--
              #FUN-D60124--mark--end--
           END IF                                                           #FUN-D40103 add
           #FUN-D60124--mark--str--
           #IF cl_null(g_errno) THEN
           #   SELECT COUNT(*) INTO l_cot1 FROM jce_file WHERE jce02=g_pmca.pmca915
           #   IF l_cot1=0 THEN
           #      LET g_errno='mfg4020'
           #   END IF
           #END IF
           #FUN-D60124--mark--end--
           IF NOT cl_null(g_errno) THEN
              IF g_errno <> 'aim-507' THEN  #FUN-D60124 add
                 CALL cl_err(g_pmca.pmca915,g_errno,1)
              END IF                        #FUN-D60124 add
              LET g_pmca.pmca915 = g_pmca_o.pmca915
              DISPLAY BY NAME g_pmca.pmca915
              NEXT FIELD pmca915
           END IF
        END IF
      AFTER FIELD pmca916
        IF g_pmca.pmca915 IS NOT NULL AND g_pmca.pmca916 IS NOT NULL THEN
	  LET g_errno = ''   #FUN-D40103 add
           CALL i610_pmcachk(p_cmd,g_pmca.pmca915,g_pmca.pmca916,'1')
           #FUN-D60124--mark--str--
           #TQC-D50116--add--str--
           #IF cl_null(g_errno) THEN
           #   IF NOT s_imechk(g_pmca.pmca915,g_pmca.pmca916) THEN NEXT FIELD pmca916 END IF 
           #END IF
           ##TQC-D50116--add--end--
           #FUN-D60124--mark--end--
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_pmca.pmca916,g_errno,1)
              LET g_pmca.pmca916 = g_pmca_o.pmca916
              DISPLAY BY NAME g_pmca.pmca916
              NEXT FIELD pmca916
           END IF
        END IF
      AFTER FIELD pmca917
        IF g_pmca.pmca917 IS NOT NULL AND g_pmca.pmca918 IS NOT NULL THEN
           IF g_pmca.pmca917 = g_pmca.pmca915 AND g_pmca.pmca918 = g_pmca.pmca916 THEN
              CALL cl_err(g_pmca.pmca917,'apm-929',1)
              #FUN-D60124--mark--str--
              ##TQC-D50116--add--str--
              #IF cl_null(g_errno) THEN
              #   IF NOT s_imechk(g_pmca.pmca917,g_pmca.pmca918) THEN NEXT FIELD pmca918 END IF 
              #END IF
              ##TQC-D50116--add--end--
              #FUN-D60124--mark--end--
              DISPLAY BY NAME g_pmca.pmca917
              NEXT FIELD pmca917
           ELSE
	  LET g_errno = ''   #FUN-D40103 add
              CALL i610_pmcachk(p_cmd,g_pmca.pmca917,g_pmca.pmca918,'2')
              IF NOT cl_null(g_errno) THEN
                 IF g_errno <> 'aim-507' THEN  #FUN-D60124 add
                    CALL cl_err(g_pmca.pmca917,g_errno,1)
                 END IF                        #FUN-D60124 add
                 LET g_pmca.pmca917 = g_pmca_o.pmca917
                 DISPLAY BY NAME g_pmca.pmca917
                 NEXT FIELD pmca917
              END IF
           END IF
        END IF
      AFTER FIELD pmca918
        IF g_pmca.pmca917 IS NOT NULL AND g_pmca.pmca918 IS NOT NULL THEN
           IF g_pmca.pmca917 = g_pmca.pmca915 AND g_pmca.pmca918 = g_pmca.pmca916 THEN
              CALL cl_err(g_pmca.pmca918,'apm-929',1)
              #FUN-D60124--mark--str--
              ##TQC-D50116--add--str--
              #IF cl_null(g_errno) THEN
              #   IF NOT s_imechk(g_pmca.pmca917,g_pmca.pmca918) THEN NEXT FIELD pmca918 END IF 
              #END IF
              ##TQC-D50116--add--end--
              #FUN-D60124--mark--end--
              DISPLAY BY NAME g_pmca.pmca918
              NEXT FIELD pmca918
           ELSE
	  LET g_errno = ''   #FUN-D40103 add
              CALL i610_pmcachk(p_cmd,g_pmca.pmca917,g_pmca.pmca918,'2')
              IF NOT cl_null(g_errno) THEN
                 IF g_errno <> 'aim-507' THEN  #FUN-D60124 add
                    CALL cl_err(g_pmca.pmca918,g_errno,1)
                 END IF                        #FUN-D60124 add
                 LET g_pmca.pmca918 = g_pmca_o.pmca918
                 DISPLAY BY NAME g_pmca.pmca918
                 NEXT FIELD pmca918
              END IF
           END IF
         END IF
      AFTER FIELD pmca919
         IF NOT cl_null(g_pmca.pmca919) THEN
            CALL s_check_no("apm",g_pmca.pmca919,"","3","pmca_file","pmca919","") RETURNING li_result,g_pmca.pmca919
            DISPLAY BY NAME g_pmca.pmca919
            IF (NOT li_result) THEN
               LET g_pmca.pmca919=g_pmca_o.pmca919
               NEXT FIELD pmca919
            END IF
            LET l_s=g_pmca.pmca919 CLIPPED
            LET l_t=l_s.getIndexOf('-',1)
            LET l_a=l_s.getLength()
            IF l_t !=0 THEN
               LET l_s=l_s.subString(1,l_t-1),l_s.subString(l_t+1,l_a)
               LET g_pmca.pmca919=l_s
            END IF
            DISPLAY BY NAME g_pmca.pmca919
         END IF
      AFTER FIELD pmca920
         IF NOT cl_null(g_pmca.pmca920) THEN
            CALL s_check_no("apm",g_pmca.pmca920,"","7","pmca_file","pmca920","") RETURNING li_result,g_pmca.pmca920
            DISPLAY BY NAME g_pmca.pmca920
            IF (NOT li_result) THEN
               LET g_pmca.pmca920=g_pmca_o.pmca920
               NEXT FIELD pmca920
            END IF
            LET l_s=g_pmca.pmca920 CLIPPED
            let l_t=l_s.getIndexOf('-',1)
            LET l_a=l_s.getLength()
            IF l_t !=0 THEN
               LET l_s=l_s.subString(1,l_t-1),l_s.subString(l_t+1,l_a)
               LET g_pmca.pmca920=l_s
            END IF
            DISPLAY BY NAME g_pmca.pmca920
         END IF
      AFTER FIELD pmca921
         IF NOT cl_null(g_pmca.pmca921) THEN
            CALL s_check_no("apm",g_pmca.pmca921,"","4","pmca_file","pmca921","") RETURNING li_result,g_pmca.pmca921
            DISPLAY BY NAME g_pmca.pmca921
            IF (NOT li_result) THEN
               LET g_pmca.pmca921=g_pmca_o.pmca921
               NEXT FIELD pmca921
            END IF
            LET l_s=g_pmca.pmca921 CLIPPED
            let l_t=l_s.getIndexOf('-',1)
            LET l_a=l_s.getLength()
            IF l_t !=0 THEN
               LET l_s=l_s.subString(1,l_t-1),l_s.subString(l_t+1,l_a)
               LET g_pmca.pmca921=l_s
            END IF
            DISPLAY BY NAME g_pmca.pmca921
         END IF
      AFTER FIELD pmca922
         IF NOT cl_null(g_pmca.pmca922) THEN
            CALL s_check_no("aim",g_pmca.pmca922,"","1","pmca_file","pmca922","") RETURNING li_result,g_pmca.pmca922
            DISPLAY BY NAME g_pmca.pmca922
            IF (NOT li_result) THEN
               LET g_pmca.pmca922=g_pmca_o.pmca922
               NEXT FIELD pmca922
            END IF
            LET l_s=g_pmca.pmca922 CLIPPED
            LET l_t=l_s.getIndexOf('-',1)
            LET l_a=l_s.getLength()
            IF l_t !=0 THEN
               LET l_s=l_s.subString(1,l_t-1),l_s.subString(l_t+1,l_a)
               LET g_pmca.pmca922=l_s
            END IF
            DISPLAY BY NAME g_pmca.pmca922
         END IF
      AFTER FIELD pmca923
         IF NOT cl_null(g_pmca.pmca923) THEN
            CALL s_check_no("aim",g_pmca.pmca923,"","2","pmca_file","pmca923","") RETURNING li_result,g_pmca.pmca923
            DISPLAY BY NAME g_pmca.pmca923
            IF (NOT li_result) THEN
               LET g_pmca.pmca923=g_pmca_o.pmca923
               NEXT FIELD pmca923
            END IF
            LET l_s=g_pmca.pmca923 CLIPPED
            LET l_t=l_s.getIndexOf('-',1)
            LET l_a=l_s.getLength()
            IF l_t !=0 THEN
               LET l_s=l_s.subString(1,l_t-1),l_s.subString(l_t+1,l_a)
               LET g_pmca.pmca923=l_s
            END IF
            DISPLAY BY NAME g_pmca.pmca923
         END IF      
      #FUN-B90080 add --end--
 
      AFTER FIELD pmcaud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pmcaud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pmcaud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pmcaud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pmcaud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pmcaud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pmcaud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pmcaud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pmcaud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pmcaud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pmcaud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pmcaud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pmcaud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pmcaud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pmcaud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         LET g_pmca.pmcauser = s_get_data_owner("pmca_file") #FUN-C10039
         LET g_pmca.pmcagrup = s_get_data_group("pmca_file") #FUN-C10039
         IF INT_FLAG THEN EXIT INPUT  END IF
         IF cl_null(g_pmca.pmca01) AND g_pmca.pmca00<>'I' THEN 
            DISPLAY BY NAME g_pmca.pmca01
            NEXT FIELD pmca01
         END IF
         IF g_pmca.pmca30 NOT MATCHES '[123]' THEN
            DISPLAY BY NAME g_pmca.pmca30
            NEXT FIELD pmca30
         END IF
         IF cl_null(g_pmca.pmca17) AND g_pmca.pmca05 ='0' THEN  #VAT 特性
            DISPLAY BY NAME g_pmca.pmca17
            NEXT FIELD pmca17
         END IF
         #FUN-B90080 add --start--
         IF cl_null(g_pmca.pmca914) THEN
            DISPLAY BY NAME g_pmca.pmca914
            NEXT FIELD pmca914
         END IF
          IF g_pmca.pmca914 = 'Y' THEN
             IF (g_pmca_t.pmca915 IS NULL OR g_pmca.pmca915 !=g_pmca_t.pmca915) OR
                (g_pmca_t.pmca916 IS NULL OR g_pmca.pmca916 !=g_pmca_t.pmca916) THEN
                CALL i610_ins(p_cmd,g_pmca.pmca915,g_pmca.pmca916,'1')
             END IF
          END IF
          IF g_pmca.pmca914 = 'Y' THEN
             IF (g_pmca_t.pmca917 IS NULL OR g_pmca.pmca917 !=g_pmca_t.pmca917) OR
                (g_pmca_t.pmca918 IS NULL OR g_pmca.pmca918 !=g_pmca_t.pmca918) THEN
                CALL i610_ins(p_cmd,g_pmca.pmca917,g_pmca.pmca918,'2')
             END IF
          END IF         
         #FUN-B90080 add --end--
         
         #-----MOD-A80234---------
         IF NOT cl_null(g_pmca.pmca01) THEN
            IF p_cmd = "a" OR         
              (p_cmd = "u" AND g_pmca.pmca01 != g_pmca01_t) THEN
               IF g_pmca.pmca00 = 'I' THEN #新增
                   LET l_n = 0
                   SELECT count(*) INTO l_n FROM pmc_file
                    WHERE pmc01 = g_pmca.pmca01
                   IF l_n > 0 THEN
                      CALL cl_err(g_pmca.pmca01,-239,1) 
                      LET g_pmca.pmca01 = ''
                      DISPLAY BY NAME g_pmca.pmca01
                      NEXT FIELD pmca01
                   END IF
                   LET l_n = 0
                   SELECT count(*) INTO l_n FROM pmca_file
                    WHERE pmca01 = g_pmca.pmca01
                      AND pmca00 = 'I' #新增
                   IF l_n > 0 THEN
                      CALL cl_err(g_pmca.pmca01,-239,1)
                      LET g_pmca.pmca01 = ''
                      DISPLAY BY NAME g_pmca.pmca01
                      NEXT FIELD pmca01
                   END IF
               ELSE
                   LET l_pmcano = NULL
                   SELECT pmcano INTO l_pmcano FROM pmca_file
                    WHERE pmca01 = g_pmca.pmca01
                      AND pmca00 = 'U' #修改
                      AND pmca05 != '2' 
                      AND pmcaacti != 'N' #MOD-B40095 add
                   IF NOT cl_null(l_pmcano) THEN
                      #已存在一張相同廠商,但未拋轉的廠商申請單!
                      CALL cl_err(l_pmcano,'apm-601',1)
                      LET g_pmca.pmca01 = ''
                      DISPLAY BY NAME g_pmca.pmca01
                      NEXT FIELD pmca01
                   END IF
               END IF
            END IF
         END IF 
         #-----END MOD-A80234----- 
 
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pmcano)
               LET g_t1 = s_get_doc_no(g_pmca.pmcano)    
               CALL q_smy(FALSE,FALSE,g_t1,'APM','Z') RETURNING g_t1 
               LET g_pmca.pmcano = g_t1
               DISPLAY BY NAME g_pmca.pmcano
               NEXT FIELD pmcano
            WHEN INFIELD(pmca01) #客戶編號
                 IF g_pmca.pmca00='U' THEN
                     #'U':修改時查pmc01
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = 'q_pmc2'
                     LET g_qryparam.default1 = g_pmca.pmca01
                     CALL cl_create_qry() RETURNING g_pmca.pmca01
                     DISPLAY BY NAME g_pmca.pmca01
                     NEXT FIELD pmca01
                 END IF
            WHEN INFIELD(pmca02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmy"
               LET g_qryparam.default1 = g_pmca.pmca02
               CALL cl_create_qry() RETURNING g_pmca.pmca02
               DISPLAY BY NAME g_pmca.pmca02
            WHEN INFIELD(pmca04) #查詢付款廠商檔
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmc"      #No.TQC-740071
               LET g_qryparam.default1 = g_pmca.pmca04
               CALL cl_create_qry() RETURNING g_pmca.pmca04
               DISPLAY BY NAME g_pmca.pmca04
               SELECT pmca03 INTO l_pmca03_d FROM pmca_file
               WHERE pmca01 = g_pmca.pmca04
               DISPLAY l_pmca03_d TO pmca03_d
               NEXT FIELD pmca04
            WHEN INFIELD(pmca901) #查詢出貨廠商檔
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmc"      #No.TQC-740071
               LET g_qryparam.default1 = g_pmca.pmca901
               CALL cl_create_qry() RETURNING g_pmca.pmca901
               DISPLAY BY NAME g_pmca.pmca901
               SELECT pmca03 INTO l_pmca03_d FROM pmca_file
               WHERE pmca01 = g_pmca.pmca901
               DISPLAY l_pmca03_d TO pmca03_e
               NEXT FIELD pmca901
            WHEN INFIELD(pmca06) #查詢區域檔
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gea"
               LET g_qryparam.default1 = g_pmca.pmca06
               CALL cl_create_qry() RETURNING g_pmca.pmca06
               DISPLAY BY NAME g_pmca.pmca06
               NEXT FIELD pmca06
            WHEN INFIELD(pmca07) #查詢國別檔
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_geb"
               LET g_qryparam.default1 = g_pmca.pmca07
               CALL cl_create_qry() RETURNING g_pmca.pmca07
               DISPLAY BY NAME g_pmca.pmca07
               NEXT FIELD pmca07
            WHEN INFIELD(pmca908) #查詢地區檔
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_geo"
               LET g_qryparam.default1 = g_pmca.pmca908
               CALL cl_create_qry() RETURNING g_pmca.pmca908
               DISPLAY BY NAME g_pmca.pmca908
               NEXT FIELD pmca908
            WHEN INFIELD(pmca15) #查詢地址資料檔 (0:表送貨地址)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pme"
               LET g_qryparam.default1 = g_pmca.pmca15
               LET g_qryparam.where = " ( pme02 = '0' OR pme02 = '2' )"
               CALL cl_create_qry() RETURNING g_pmca.pmca15
               DISPLAY BY NAME g_pmca.pmca15
               NEXT FIELD pmca15
            WHEN INFIELD(pmca16) #查詢地址資料檔 (1:表帳單地址)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pme"
               LET g_qryparam.default1 = g_pmca.pmca16
               LET g_qryparam.where = " ( pme02 = '1' OR pme02 = '2' )"
               CALL cl_create_qry() RETURNING g_pmca.pmca16
               DISPLAY BY NAME g_pmca.pmca16
               NEXT FIELD pmca16
            WHEN INFIELD(pmca17) #查詢付款條件資料檔(pma_file)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pma"
               LET g_qryparam.default1 = g_pmca.pmca17
               CALL cl_create_qry() RETURNING g_pmca.pmca17
               DISPLAY BY NAME g_pmca.pmca17
               CALL i610_pmca17(g_pmca.pmca17)
               NEXT FIELD pmca17
            WHEN INFIELD(pmca22) #查詢幣別資料檔
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = g_pmca.pmca22
               CALL cl_create_qry() RETURNING g_pmca.pmca22
               DISPLAY BY NAME g_pmca.pmca22
               NEXT FIELD pmca22
            WHEN INFIELD(pmca47) #
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gec"
               LET g_qryparam.default1 = g_pmca.pmca47
               LET g_qryparam.arg1 = "1"
               CALL cl_create_qry() RETURNING g_pmca.pmca47
               DISPLAY BY NAME g_pmca.pmca47
               NEXT FIELD pmca47
            WHEN INFIELD(pmca55) #
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nmt"
               LET g_qryparam.default1 = g_pmca.pmca55
               CALL cl_create_qry() RETURNING g_pmca.pmca55
               DISPLAY BY NAME g_pmca.pmca55
               NEXT FIELD pmca55
            WHEN INFIELD(pmca49) #價格條件
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pnz01" #FUN-930113 oah-->pnz01
               LET g_qryparam.default1 = g_pmca.pmca49
               CALL cl_create_qry() RETURNING g_pmca.pmca49
               DISPLAY BY NAME g_pmca.pmca49
               SELECT pnz02 INTO l_buf FROM pnz_file WHERE pnz01=g_pmca.pmca49 #FUN-930113 oah-->pnz
               DISPLAY l_buf TO FORMONLY.pnz02 #FUN-930113 oah-->pnz
            WHEN INFIELD(pmca54) #佣金
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ofs"
               LET g_qryparam.default1 = g_pmca.pmca54
               CALL cl_create_qry() RETURNING g_pmca.pmca54
               DISPLAY BY NAME g_pmca.pmca54
               NEXT FIELD pmca54
            #FUN-B90080 add --start--
            WHEN INFIELD(pmca915) #VMI庫存倉庫
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imd001"
               LET g_qryparam.default1 = g_pmca.pmca915
               CALL cl_create_qry() RETURNING g_pmca.pmca915
               DISPLAY BY NAME g_pmca.pmca915
               NEXT FIELD pmca915
            WHEN INFIELD(pmca916) #VMI庫存儲位
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ime4"
               LET g_qryparam.arg1 = '1'
               LET g_qryparam.default1 = g_pmca.pmca916
		#FUN-D40103--add--str--
               IF NOT cl_null(g_pmca.pmca915) THEN
                  LET g_qryparam.where = " ime01 = '",g_pmca.pmca915,"' "
               END IF
               #FUN-D40103--add--end--
               CALL cl_create_qry() RETURNING g_pmca.pmca916
               DISPLAY BY NAME g_pmca.pmca916
               NEXT FIELD pmca916
            WHEN INFIELD(pmca917) #VMI結算倉庫
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imd002"
               LET g_qryparam.default1 = g_pmca.pmca917
               CALL cl_create_qry() RETURNING g_pmca.pmca917
               DISPLAY BY NAME g_pmca.pmca917
               NEXT FIELD pmca917
            WHEN INFIELD(pmca918) #VMI結算儲位
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ime4"
               LET g_qryparam.arg1 = '2'
               CALL cl_create_qry() RETURNING g_pmca.pmca918
               DISPLAY BY NAME g_pmca.pmca918
               NEXT FIELD pmca918
            WHEN INFIELD(pmca919) #VMI結算收貨單別
               LET g_t1=s_get_doc_no(g_pmca.pmca919)
               CALL q_smy(FALSE,FALSE,g_t1,'apm','3') RETURNING g_t1
               LET g_pmca.pmca919 = g_t1
               DISPLAY BY NAME g_pmca.pmca919
               NEXT FIELD pmca919
            WHEN INFIELD(pmca920) #VMI結算入庫單別
               LET g_t1=s_get_doc_no(g_pmca.pmca920)
               CALL q_smy(FALSE,FALSE,g_t1,'apm','7') RETURNING g_t1
               LET g_pmca.pmca920 = g_t1
               DISPLAY BY NAME g_pmca.pmca920
               NEXT FIELD pmca920
            WHEN INFIELD(pmca921) #VMI結算退貨單別
               LET g_t1=s_get_doc_no(g_pmca.pmca921)
               CALL q_smy(FALSE,FALSE,g_t1,'apm','4') RETURNING g_t1
               LET g_pmca.pmca921 = g_t1
               DISPLAY BY NAME g_pmca.pmca921
               NEXT FIELD pmca921
            WHEN INFIELD(pmca922) #VMI庫存雜發單別
               LET g_t1=s_get_doc_no(g_pmca.pmca922)
               CALL q_smy(FALSE,FALSE,g_t1,'aim','1') RETURNING g_t1
               LET g_pmca.pmca922 = g_t1
               DISPLAY BY NAME g_pmca.pmca922
               NEXT FIELD pmca922
            WHEN INFIELD(pmca923) #VMI庫存雜收單別
               LET g_t1=s_get_doc_no(g_pmca.pmca923)
               CALL q_smy(FALSE,FALSE,g_t1,'aim','2') RETURNING g_t1
               LET g_pmca.pmca923 = g_t1
               DISPLAY BY NAME g_pmca.pmca923
               NEXT FIELD pmca923            
            #FUN-B90080 add --end--   
            #CHI-A80049 add --start--
            WHEN INFIELD(pmcaud02)
               CALL cl_dynamic_qry() RETURNING g_pmca.pmcaud02
               DISPLAY BY NAME g_pmca.pmcaud02
               NEXT FIELD pmcaud02
            WHEN INFIELD(pmcaud03)
               CALL cl_dynamic_qry() RETURNING g_pmca.pmcaud03
               DISPLAY BY NAME g_pmca.pmcaud03
               NEXT FIELD pmcaud03
            WHEN INFIELD(pmcaud04)
               CALL cl_dynamic_qry() RETURNING g_pmca.pmcaud04
               DISPLAY BY NAME g_pmca.pmcaud04
               NEXT FIELD pmcaud04
            WHEN INFIELD(pmcaud05)
               CALL cl_dynamic_qry() RETURNING g_pmca.pmcaud05
               DISPLAY BY NAME g_pmca.pmcaud05
               NEXT FIELD pmcaud05
            WHEN INFIELD(pmcaud06)
               CALL cl_dynamic_qry() RETURNING g_pmca.pmcaud06
               DISPLAY BY NAME g_pmca.pmcaud06
               NEXT FIELD pmcaud06
            #CHI-A80049 add --end--
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
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION auto_getvendorno
            IF g_pmca.pmca00 = 'I' AND cl_null(g_pmca.pmca01) THEN #新增且申請供應商編號為空時,才CALL自動編號附程式
                IF g_aza.aza30 = 'Y' THEN
                   #-----MOD-A70159---------
                   #CALL s_auno(g_pmca.pmca01,'3','') RETURNING g_pmca.pmca01,g_pmca.pmca03  #No.FUN-850100
                   CALL s_auno(g_pmca.pmca01,'3','') RETURNING g_pmca.pmca01,l_pmca03 
                   IF cl_null(g_pmca.pmca03) THEN
                      LET g_pmca.pmca03 = l_pmca03
                   END IF
                   #-----END MOD-A70159-----
                   DISPLAY BY NAME g_pmca.pmca01,g_pmca.pmca03
                END IF
            END IF
         
 
 
    END INPUT
END FUNCTION
 
#FUN-B90080 add --start--
FUNCTION i610_pmcachk(p_cmd,p_ime01,p_ime02,p_flag)
DEFINE p_cmd    LIKE type_file.chr1
DEFINE p_ime01  LIKE ime_file.ime01
DEFINE p_ime02  LIKE ime_file.ime02
DEFINE p_flag   LIKE type_file.chr1
DEFINE l_ime12  LIKE ime_file.ime12
DEFINE l_n      LIKE type_file.num5
DEFINE l_n2     LIKE type_file.num5
DEFINE l_err    LIKE  ime_file.ime02   #FUN-D60124 add
DEFINE l_imeacti LIKE ime_file.imeacti #FUN-D60124 add

   LET g_errno = ''


   #SELECT ime12 INTO l_ime12 FROM ime_file                    #FUN-D60124 mark
   SELECT ime12,imeacti INTO l_ime12,l_imeacti FROM ime_file   #FUN-D60124 add
    WHERE ime01=p_ime01
      AND ime02=p_ime02

	CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = ''
        WHEN l_ime12 = '0'        LET g_errno = 'apm-082'
        WHEN l_ime12 = '1'        IF p_flag='2' THEN LET g_errno = 'apm-083' END IF
        WHEN l_ime12 = '2'        IF p_flag='1' THEN LET g_errno = 'apm-084' END IF
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   #FUN-D60124--add--str--
   IF l_imeacti='N' THEN
      LET g_errno = 'aim-507'
      LET l_err = p_ime02
      IF cl_null(l_err) THEN LET l_err = "' '" END IF
      CALL cl_err_msg("","aim-507",p_ime01 || "|" || l_err ,0)
   END IF 
   #FUN-D60124--add--end--

   IF cl_null(g_errno) THEN
      IF p_flag = '1' THEN
         SELECT COUNT(*) INTO l_n FROM pmca_file
          WHERE pmca915 = p_ime01
            AND pmca916 = p_ime02
            AND pmca01 != g_pmca.pmca01
         IF l_n>0 THEN
            LET g_errno = 'apm-081'
         END IF
      END IF
      IF p_flag = '2' THEN
         SELECT COUNT(*) INTO l_n FROM pmca_file
          WHERE pmca917 = p_ime01
            AND pmca918 = p_ime02
            AND pmca01 != g_pmca.pmca01
         IF l_n>0 THEN
            LET g_errno = 'apm-081'
         END IF
      END IF
   END IF

   IF cl_null(g_errno) THEN
      IF p_flag = '1' THEN
         SELECT COUNT(*) INTO l_n FROM pmc_file
          WHERE pmc915 = p_ime01
            AND pmc916 = p_ime02
            AND pmc01 != g_pmca.pmca01
         IF l_n>0 THEN
            LET g_errno = 'apm-081'
         END IF
      END IF
      IF p_flag = '2' THEN
         SELECT COUNT(*) INTO l_n FROM pmc_file
          WHERE pmc917 = p_ime01
            AND pmc918 = p_ime02
            AND pmc01 != g_pmca.pmca01
         IF l_n>0 THEN
            LET g_errno = 'apm-081'
         END IF
      END IF
   END IF   

   IF cl_null(g_errno) AND p_cmd='u' THEN
      SELECT COUNT(*) INTO l_n2 FROM tlf_file
       WHERE tlf901 = p_ime01
         AND tlf902 = p_ime02
         AND tlf19 = g_pmca.pmca01
      IF l_n >0 THEN
         LET g_errno ='apm-085'
      END IF
   END IF

END FUNCTION
FUNCTION i610_ins(p_cmd,p_ime01,p_ime02,p_ime12)
DEFINE p_cmd    LIKE type_file.chr1
DEFINE p_ime01  LIKE ime_file.ime01
DEFINE p_ime02  LIKE ime_file.ime02
DEFINE p_ime12  LIKE ime_file.ime12
DEFINE l_n1     LIKE type_file.num5
DEFINE l_n2     LIKE type_file.num5
DEFINE l_imd    RECORD LIKE imd_file.*
DEFINE l_jce    RECORD LIKE jce_file.*
DEFINE l_ime    RECORD LIKE ime_file.*

       SELECT COUNT(ime01) INTO l_n1 FROM ime_file
        WHERE ime01 = p_ime01
          AND ime02 = p_ime02
          AND ime12 = p_ime12
       IF l_n1 = 0 THEN
          SELECT COUNT(imd01) INTO l_n2 FROM imd_file
           WHERE imd01 = p_ime01
          IF l_n2 =0 THEN
             LET l_imd.imd01 = p_ime01
             LET l_imd.imd10 = 'S'
             LET l_imd.imd11 = 'Y'
             LET l_imd.imd12 = 'Y'
             LET l_imd.imd13 = 'N'
             LET l_imd.imd14 = 0
             LET l_imd.imd15 = 0
             LET l_imd.imd09 = 'Y'
             LET l_imd.imd17 = 'N'
             LET l_imd.imd18 = '0'
             LET l_imd.imd19 = 'N'
             LET l_imd.imd23 = 'N'           #FUN-C80107 add
             LET l_imd.imdpos = 'N'
             LET l_imd.imdacti = 'Y'
             LET l_imd.imduser = g_user
             LET l_imd.imdgrup = g_grup
             LET l_imd.imddate = g_today
             LET l_imd.imdoriu = g_user
             LET l_imd.imdorig = g_grup
             INSERT INTO imd_file VALUES(l_imd.*)
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","imd_file","","",SQLCA.sqlcode,"","imd_file",1)
                RETURN
             END IF
             IF p_ime12 ='1' THEN
                LET l_jce.jce01 = p_ime01
                LET l_jce.jce02 = p_ime01
                LET l_jce.jceacti = 'Y'
                LET l_jce.jceuser = g_user
                LET l_jce.jcegrup = g_grup
                LET l_jce.jcedate = g_today
                LET l_jce.jceoriu = g_user
                LET l_jce.jceorig = g_grup
                INSERT INTO jce_file VALUES(l_jce.*)
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","jce_file","","",SQLCA.sqlcode,"","jce_file",1)
                   RETURN
                END IF
             END IF
          END IF
          LET l_ime.ime01 = p_ime01
          LET l_ime.ime02 = p_ime02
          LET l_ime.ime03 = p_ime02
          LET l_ime.ime04 = 'S'
          LET l_ime.ime05 = 'Y'
          LET l_ime.ime06 = 'Y'
          LET l_ime.ime07 = 'N'
          LET l_ime.ime08 = '0'
          LET l_ime.ime10 = 1
          LET l_ime.ime11 = 1
          LET l_ime.ime12 = p_ime12
          LET l_ime.ime17 = 'N'
	 LET l_ime.imeacti='Y'  #FUN-D40103 add
          INSERT INTO ime_file VALUES(l_ime.*)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","ime_file","","",SQLCA.sqlcode,"","ime_file",1)
             RETURN
          END IF
       END IF

END FUNCTION
#FUN-B90080 add --end--
 
FUNCTION i610_set_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   #CHI-A80049 mark --start--
   #IF g_pmca.pmca00='I' THEN #新增
   #MOD-B40226 remark --start--
       CALL cl_set_comp_entry("pmca24,pmca903,pmca14",TRUE)
       CALL cl_set_comp_entry("pmca02,pmca30,pmca04,pmca901",TRUE)
       CALL cl_set_comp_entry("pmca17,pmca49,pmca22,pmca47,pmca54,pmca911",TRUE)
       CALL cl_set_comp_entry("pmca48,pmca902,pmca27,pmca50,pmca51,pmca28,pmca281",TRUE)    #CHI-C20021 add pmca281
       CALL cl_set_comp_entry("pmca908,pmca904,pmca091,pmca092,pmca093,pmca094,pmca095",TRUE)
       CALL cl_set_comp_entry("pmca52,pmca53,pmca15,pmca16",TRUE)
       CALL cl_set_comp_entry("pmca56,pmca55,pmca10,pmca11,pmca12",TRUE)
       CALL cl_set_comp_entry("pmca03,pmca081,pmca082",TRUE) #CHI-840029
       CALL cl_set_comp_entry("pmca07,pmca06",TRUE) #MOD-B40226 add
       CALL cl_set_comp_entry("pmca01",TRUE) #MOD-B40226 add
   #MOD-B40226 remark --end--
   #END IF
   #CHI-A80049 mark --end--

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("pmca00,pmcano,pmca01",TRUE)
   END IF
 
   IF NOT g_before_input_done THEN
      CALL cl_set_comp_entry("pmca14",TRUE)
   END IF
 
   IF INFIELD(pmca30) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("pmca04,pmca901",TRUE)
   END IF
 
   IF INFIELD(pmca14) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("pmca54",TRUE)
   END IF

   CALL cl_set_comp_entry("pmca915,pmca916,pmca917,pmca918,pmca919,pmca920,pmca921,pmca922,pmca923",TRUE) #FUN-B90080 add   

  #MOD-B40226 mark --start--
  ##CHI-A80049 add --start--
  #IF INFIELD(pmca01) OR NOT g_before_input_done THEN
  #   CALL cl_set_comp_entry("pmca03,pmca081,pmca082",TRUE)
  #END IF 
  ##CHI-A80049 add --end--
  #MOD-B40226 mark --end--

END FUNCTION
 
FUNCTION i610_set_no_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   #CHI-A80049 mark --start--
   #IF g_pmca.pmca00='U' OR g_input_vendorno = 'Y' THEN #修改 #CHI-840029 add OR g_input_vendorno = 'Y' 的判斷
    IF g_input_vendorno = 'Y' THEN #MOD-B40226 add
   #MOD-B40226 remark --start--
       CALL cl_set_comp_entry("pmca24,pmca903,pmca14",FALSE)
       CALL cl_set_comp_entry("pmca02,pmca30,pmca04,pmca901",FALSE)
       CALL cl_set_comp_entry("pmca17,pmca49,pmca22,pmca47,pmca54,pmca911",FALSE)
       CALL cl_set_comp_entry("pmca48,pmca902,pmca27,pmca50,pmca51,pmca28,pmca281",FALSE)  #CHI-C20021 add pmca281
       CALL cl_set_comp_entry("pmca908,pmca904,pmca091,pmca092,pmca093,pmca094,pmca095",FALSE)
       CALL cl_set_comp_entry("pmca52,pmca53,pmca15,pmca16",FALSE)
       CALL cl_set_comp_entry("pmca56,pmca55,pmca10,pmca11,pmca12",FALSE)
       CALL cl_set_comp_entry("pmca07,pmca06",FALSE) #MOD-B40226 add
   #MOD-B40226 remark --end--
   #   #CHI-840029---add----str---
   #   IF g_input_vendorno = 'Y' THEN
           CALL cl_set_comp_entry("pmca03,pmca081,pmca082",FALSE) #MOD-B40226 remark
   #   END IF
   #   #CHI-840029---add----end---
    END IF #MOD-B40226 remark
   #CHI-A80049 mark --end--
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("pmca00,pmcano",FALSE)
      IF g_pmca.pmca00 = 'U' THEN #申請類別U:修改時,不能改廠商編號
          CALL cl_set_comp_entry("pmca01",FALSE)
      END IF
   END IF

  #MOD-B40226 mark --start--
  ##CHI-A80049 add --start--
  #IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
  #    #當參數設定使用廠商申請作業時,修改時可更改簡稱/全名
  #    IF g_aza.aza62 = 'N' THEN #MOD-B40226 mod Y->N
  #        CALL cl_set_comp_entry("pmca03,pmca081,pmca082",FALSE)
  #    END IF
  #END IF
  ##CHI-A80049 add --end--
  #MOD-B40226 mark --end--
 
      IF g_pmca.pmca30 MATCHES '[23]' THEN
         CALL cl_set_comp_entry("pmca04",FALSE)
      END IF
      IF g_pmca.pmca30 MATCHES '[13]' THEN
         CALL cl_set_comp_entry("pmca901",FALSE)
      END IF
 
   IF INFIELD(pmca14) OR (NOT g_before_input_done) THEN
      IF g_pmca.pmca14 != '4' THEN
         CALL cl_set_comp_entry("pmca54",FALSE)
      END IF
   END IF
   
   #FUN-B90080 add --start--
   IF g_pmca.pmca914 !='Y' THEN
      CALL cl_set_comp_entry("pmca915,pmca916,pmca917,pmca918,pmca919,pmca920,pmca921,pmca922,pmca923",FALSE)
   END IF
   #FUN-B90080 add --end--   
   #CHI-C20021 add begin---------------------------
   IF g_pmca.pmca28 = 0 OR cl_null(g_pmca.pmca28) THEN
      CALL cl_set_comp_entry("pmca281",FALSE)
   END IF
   #CHI-C20021 add end-------------------------
   #MOD-C70107申請類別U:不能改廠商名称
#   IF g_pmca.pmca00='U' THEN #TQC-C70218 mark
#      CALL cl_set_comp_entry("pmca03",FALSE)
#   END IF 
   #MOD-C70107   
END FUNCTION
 
FUNCTION i_pmca()
   OPEN WINDOW i603_w WITH FORM "apm/42f/apmi603"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_locale("apmi603")
 
   INPUT g_pmca.pmca091 ,g_pmca.pmca092 ,g_pmca.pmca093,g_pmca.pmca094,g_pmca.pmca095
         WITHOUT DEFAULTS
    FROM pmca091,pmca092,pmca093,pmca094,pmca095
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
     END INPUT
   CLOSE WINDOW i603_w
END FUNCTION
 
 
FUNCTION i610_pmca05()  			#Status
    DEFINE l_str1   LIKE type_file.chr1000,    #No.FUN-680136 VARCHAR(38)
           l_ans    LIKE type_file.chr1        #No.FUN-680136 VARCHAR(01)
 
    # 如從已核準更改成未核準或核準中時 pmh_file 一併修改
    IF g_pmca_o.pmca05 ='0' AND (g_pmca.pmca05 = '1' OR g_pmca.pmca05 ='2' ) THEN
       UPDATE pmh_file SET pmh05 = g_pmca.pmca05,
                           pmhdate = g_today     #FUN-C40009 add
        WHERE pmh02 = g_pmca.pmca01
          AND pmh13 = g_pmca.pmca22
       IF SQLCA.sqlcode THEN
          IF SQLCA.sqlcode != 100 THEN
             CALL cl_err3("upd","pmh_file","","",SQLCA.sqlcode,"Update pmh_file:","",1)  
          END IF
       END IF
    END IF
    IF (g_pmca_o.pmca05 ='1' OR  g_pmca_o.pmca05 ='2') AND g_pmca.pmca05='0' THEN
       UPDATE pmh_file SET pmh05 = g_pmca.pmca05,
                           pmhdate = g_today     #FUN-C40009 add
        WHERE pmh02 = g_pmca.pmca01
          AND pmh13 = g_pmca.pmca22
       IF SQLCA.sqlcode THEN
          IF SQLCA.sqlcode != 100 THEN
             CALL cl_err3("upd","pmh_file","","",SQLCA.sqlcode,"Update pmh_file:","",1)  #No.FUN-660129
          END IF
       END IF
    END IF
END FUNCTION
 
FUNCTION i610_pmca04(p_cmd)  			#付款廠商
   DEFINE   p_cmd       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
            l_pmca03     LIKE pmca_file.pmca03,	#付款廠商簡稱
            l_pmca30     LIKE pmca_file.pmca30,	#性質
            l_pmcaacti   LIKE pmca_file.pmcaacti
 
   LET g_errno = ' '
   #MOD-BC0205 ----- modify start -----
   IF g_pmca.pmca04 = g_pmca.pmca01 AND NOT cl_null(g_pmca.pmca04) THEN
      LET l_pmca03 = g_pmca.pmca03
   ELSE
   #MOD-BC0205 ----- modify end -----
      SELECT pmc03,pmc30,pmcacti INTO l_pmca03,l_pmca30,l_pmcaacti
        FROM pmc_file
       WHERE pmc01 = g_pmca.pmca04
      CASE WHEN SQLCA.SQLCODE = 100
              SELECT pmca03,pmca30,pmcaacti INTO l_pmca03,l_pmca30,l_pmcaacti
                FROM pmca_file
               WHERE pmca01 = g_pmca.pmca04
              CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3004'
                                             LET l_pmca03 = NULL
                   WHEN l_pmca30  ='1'       LET g_errno = 'mfg3004'
                   WHEN l_pmcaacti='N'       LET g_errno = '9028'
                   OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
              END CASE
           WHEN l_pmca30  ='1'       LET g_errno = 'mfg3004'
           WHEN l_pmcaacti='N'       LET g_errno = '9028'
           OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
      END CASE
   END IF #MOD-BC0205 add
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pmca03 TO FORMONLY.pmca03_d
   END IF
END FUNCTION
 
FUNCTION i610_pmca02(p_cmd)  			#廠商分類代碼
   DEFINE   p_cmd	LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
            l_pmyacti   LIKE pmy_file.pmyacti,
            l_pmy02     LIKE pmy_file.pmy02
 
   LET g_errno = ' '
   SELECT pmy02,pmyacti INTO l_pmy02,l_pmyacti
     FROM pmy_file
    WHERE pmy01 = g_pmca.pmca02
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3005'
                                  LET l_pmy02=''
                                   DISPLAY l_pmy02 TO pmy02 #No.MOD-580018
        WHEN l_pmyacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_pmy02 TO pmy02
   END IF
END FUNCTION
 
FUNCTION i610_pmca908(p_cmd)  #地區代號
   DEFINE   p_cmd       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
            l_geo03     LIKE geb_file.geb03,		#國別代號
            l_geb02     LIKE gea_file.gea02,		#國別名稱
            l_geo02     LIKE geb_file.geb02,		#地區代號
            l_geoacti   LIKE geb_file.gebacti, 		#有效碼
            l_gea02     LIKE gea_file.gea02             #區域名稱
 
   LET g_errno = ' '
   SELECT geo03,geoacti,geo02
     INTO l_geo03,l_geoacti,l_geo02
     FROM geo_file
    WHERE geo01 = g_pmca.pmca908
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3011'   
                                  LET l_geo03   = NULL
                                  LET l_geoacti = NULL
        WHEN l_geoacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF p_cmd = 'a' THEN
      LET g_pmca.pmca07 = l_geo03
      DISPLAY BY NAME g_pmca.pmca07
      SELECT geb02 INTO l_geb02 FROM geb_file WHERE geb01 = g_pmca.pmca07
      DISPLAY l_geo02 TO geo02
      DISPLAY l_geb02 TO geb02
      SELECT gea01,gea02 INTO g_pmca.pmca06,l_gea02 FROM gea_file,geb_file
             WHERE gea01 = geb03 AND geb01 = l_geo03
      DISPLAY BY NAME g_pmca.pmca06
      DISPLAY l_gea02 TO gea02
   END IF
END FUNCTION
 
FUNCTION i610_pmca06(p_cmd)  #區域代號
   DEFINE   p_cmd       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
            l_gea02     LIKE gea_file.gea02, #CHI-A80049 add
            l_geaacti   LIKE gea_file.geaacti	
 
   LET g_errno = ' '
  #SELECT geaacti INTO l_geaacti FROM gea_file #CHI-A80049 mark
   SELECT gea02,geaacti INTO l_gea02,l_geaacti #CHI-A80049
     FROM gea_file                             #CHI-A80049
    WHERE gea01=g_pmca.pmca06
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3139'
                                  LET l_geaacti = NULL
        WHEN l_geaacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   DISPLAY l_gea02 TO gea02 #CHI-A80049 add
END FUNCTION
 
#CHI-A80049 add --start--
FUNCTION i610_pmca07(p_cmd)  #國別
DEFINE
    p_cmd           LIKE type_file.chr1,
    l_gea02         LIKE gea_file.gea02,
    l_geb02         LIKE geb_file.geb02,
    l_gebacti       LIKE geb_file.gebacti

    LET g_errno = ' '
     SELECT geb02,gebacti INTO l_geb02,l_gebacti
        FROM geb_file
        WHERE geb01 = g_pmca.pmca07
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3029'
                            LET l_geb02 = NULL
          WHEN l_gebacti='N'        LET g_errno='9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    DISPLAY l_geb02 TO geb02
    SELECT gea01,gea02 INTO g_pmca.pmca06,l_gea02 FROM gea_file,geb_file
           WHERE gea01 = geb03 AND geb01 = g_pmca.pmca07
    DISPLAY BY NAME g_pmca.pmca06
    DISPLAY l_gea02 TO gea02
END FUNCTION
#CHI-A80049 add --end--

FUNCTION i610_area(p_no,p_code)  #區域代號
   DEFINE   p_no        LIKE pme_file.pme01,
            p_code      LIKE pme_file.pme02,
            l_pme02     LIKE pme_file.pme02,
            l_pmeacti   LIKE pme_file.pmeacti		
 
   LET g_errno = ' '
   SELECT pme02,pmeacti INTO l_pme02,l_pmeacti
     FROM pme_file
    WHERE pme01 = p_no
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3345'
                                  LET l_pmeacti = NULL
        WHEN p_code = '0'         IF l_pme02 = '1' THEN LET g_errno = 'mfg3019' END IF
        WHEN p_code = '1'         IF l_pme02 = '0' THEN LET g_errno = 'mfg3026' END IF
        WHEN l_pmeacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
FUNCTION i610_pmca17(p_cmd)  #付款方式
   DEFINE   p_cmd        LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
            l_pma02      LIKE pma_file.pma02,
            l_pmaacti    LIKE pma_file.pmaacti
 
   LET g_errno = ' '
   SELECT pma02,pmaacti
          INTO l_pma02,l_pmaacti
          FROM pma_file WHERE pma01 = g_pmca.pmca17
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3099'
                                  LET l_pmaacti = NULL  LET l_pma02=NULL
        WHEN l_pmaacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   DISPLAY l_pma02 TO FORMONLY.pma02
END FUNCTION
 
FUNCTION i610_pmca22(p_cmd)  #幣別
   DEFINE   p_cmd       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
            l_azi02     LIKE azi_file.azi02,
            l_aziacti   LIKE azi_file.aziacti
 
   LET g_errno = ' '
   SELECT aziacti,azi02
     INTO l_aziacti,l_azi02
     FROM azi_file WHERE azi01=g_pmca.pmca22
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                                  LET l_aziacti = NULL
                                  LET l_azi02 = NULL
                                  DISPLAY l_azi02 TO azi02
        WHEN l_aziacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_azi02 TO azi02
   END IF
 
END FUNCTION
 
FUNCTION i610_pmca47(p_cmd)  #幣別
   DEFINE   p_cmd       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
            l_gec02     LIKE gec_file.gec02,
            l_gecacti   LIKE gec_file.gecacti
 
   LET g_errno = ' '
   SELECT gecacti,gec02
     INTO l_gecacti,l_gec02
     FROM gec_file WHERE gec01=g_pmca.pmca47
                     AND gec011='1'  #進項
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3044'
                                  LET l_gecacti = NULL
                                  LET l_gec02 = NULL
                                  DISPLAY l_gec02 TO gec02
        WHEN l_gecacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_gec02 TO gec02
   END IF
END FUNCTION
 
FUNCTION i610_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL i610_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      INITIALIZE g_pmca.* TO NULL
      RETURN
   END IF
   OPEN i610_count
   FETCH i610_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN i610_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pmca.pmcano,SQLCA.sqlcode,0)
      INITIALIZE g_pmca.* TO NULL
   ELSE
      CALL i610_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
FUNCTION i610_fetch(p_flpmca)
   DEFINE   p_flpmca   LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)
 
   CASE p_flpmca
      WHEN 'N' FETCH NEXT     i610_cs INTO g_pmca.pmcano
      WHEN 'P' FETCH PREVIOUS i610_cs INTO g_pmca.pmcano
      WHEN 'F' FETCH FIRST    i610_cs INTO g_pmca.pmcano
      WHEN 'L' FETCH LAST     i610_cs INTO g_pmca.pmcano
      WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg_i600
                   LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg_i600 CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                   ON ACTION about         
                      CALL cl_about()      
                  
                   ON ACTION help          
                      CALL cl_show_help()  
                  
                   ON ACTION controlg      
                      CALL cl_cmdask()     
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i610_cs INTO g_pmca.pmcano
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pmca.pmcano,SQLCA.sqlcode,0)
      INITIALIZE g_pmca.* TO NULL         #NO.FUN-6B0079 add
      RETURN
   ELSE
      CASE p_flpmca
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_pmca.* FROM pmca_file          # 重讀DB,因TEMP有不被更新特性
    WHERE pmcano = g_pmca.pmcano
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","pmca_file","","",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_pmca.* TO NULL            
   ELSE
      LET g_data_owner = g_pmca.pmcauser      
      LET g_data_group = g_pmca.pmcagrup     
      CALL i610_show()                      # 重新顯示
   END IF
END FUNCTION
 
FUNCTION i610_show()
   DEFINE   l_msg     LIKE type_file.chr1000,   #No.FUN-680136 VARCHAR(30)
            l_gea02   LIKE gea_file.gea02,
            l_geb02   LIKE geb_file.geb02,
            l_geo02   LIKE geo_file.geo02   
 
 
   LET g_pmca_t.* = g_pmca.*
   LET g_pmca_o.* = g_pmca.*
   DISPLAY BY NAME g_pmca.pmcaoriu,g_pmca.pmcaorig,
         g_pmca.pmca00  ,g_pmca.pmcano  ,g_pmca.pmca01  ,g_pmca.pmca03  ,g_pmca.pmca081,g_pmca.pmca082,g_pmca.pmca24 ,g_pmca.pmca903,g_pmca.pmca14 ,
         g_pmca.pmca02  ,g_pmca.pmca30  ,g_pmca.pmca04  ,g_pmca.pmca901 ,g_pmca.pmca05 ,g_pmca.pmca23 ,
         g_pmca.pmca17  ,g_pmca.pmca49  ,g_pmca.pmca22  ,g_pmca.pmca47  ,g_pmca.pmca54 ,g_pmca.pmca911,
         g_pmca.pmca48  ,g_pmca.pmca902 ,g_pmca.pmca27  ,g_pmca.pmca50  ,g_pmca.pmca51 ,g_pmca.pmca28 ,g_pmca.pmca281,   #CHI-C20021 add g_pmca.pmca281
         g_pmca.pmca908 ,g_pmca.pmca07  ,g_pmca.pmca06  ,g_pmca.pmca904 ,g_pmca.pmca091,g_pmca.pmca092,g_pmca.pmca093,g_pmca.pmca094,g_pmca.pmca095,
         g_pmca.pmca52  ,g_pmca.pmca53  ,g_pmca.pmca15  ,g_pmca.pmca16  ,
         g_pmca.pmca56  ,g_pmca.pmca55  ,g_pmca.pmca10  ,g_pmca.pmca11  ,g_pmca.pmca12 ,
         g_pmca.pmca914 ,g_pmca.pmca915 ,g_pmca.pmca916 ,g_pmca.pmca917 ,g_pmca.pmca918, #FUN-B90080 add
         g_pmca.pmca919 ,g_pmca.pmca920 ,g_pmca.pmca921 ,g_pmca.pmca922 ,g_pmca.pmca923, #FUN-B90080 add         
         g_pmca.pmcauser,g_pmca.pmcagrup,g_pmca.pmcamodu,g_pmca.pmcadate,g_pmca.pmcaacti,
         g_pmca.pmcaud01,g_pmca.pmcaud02,g_pmca.pmcaud03,g_pmca.pmcaud04,
         g_pmca.pmcaud05,g_pmca.pmcaud06,g_pmca.pmcaud07,g_pmca.pmcaud08,
         g_pmca.pmcaud09,g_pmca.pmcaud10,g_pmca.pmcaud11,g_pmca.pmcaud12,
         g_pmca.pmcaud13,g_pmca.pmcaud14,g_pmca.pmcaud15 
 
   SELECT geo02 INTO l_geo02 FROM geo_file WHERE geo01 = g_pmca.pmca908   #FUN-550091
   DISPLAY l_geo02 TO geo02   #FUN-550091
   SELECT geb02 INTO l_geb02 FROM geb_file WHERE geb01 = g_pmca.pmca07
   DISPLAY l_geb02 TO geb02
   SELECT gea02 INTO l_gea02 FROM gea_file WHERE gea01 = g_pmca.pmca06
   DISPLAY l_gea02 TO gea02
   SELECT pnz02 INTO l_buf FROM pnz_file WHERE pnz01=g_pmca.pmca49 #FUN-930113 oah-->pnz
   DISPLAY l_buf TO FORMONLY.pnz02 #FUN-930113 oah-->pnz
   CALL i610_pmca04('d')
   CALL i610_pmca901('d')
   CALL i610_pmca02('d')
   CALL i610_pmca22('d')
   CALL i610_pmca47('d')
   CALL i610_pmca17(g_pmca.pmca17)
   CALL i610_show_pic() #CHI-840028  #MOD-950196 remark
   CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION s_datype(p_code)
   DEFINE p_code LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)
   DEFINE l_msg	 LIKE imd_file.imd01      #No.FUN-680136 VARCHAR(10)
 
   CASE g_lang
      WHEN '0'
         CASE WHEN p_code='1' LET l_msg='廠商'
              WHEN p_code='2' LET l_msg='雜項'
              WHEN p_code='3' LET l_msg='員工'
              WHEN p_code='4' LET l_msg='代理商'
         END CASE
      WHEN '2'
         CASE WHEN p_code='1' LET l_msg='廠商'
              WHEN p_code='2' LET l_msg='雜項'
              WHEN p_code='3' LET l_msg='員工'
              WHEN p_code='4' LET l_msg='代理商'
         END CASE
      OTHERWISE
         CASE WHEN p_code='1' LET l_msg='VEN.'
              WHEN p_code='2' LET l_msg='MISC'
              WHEN p_code='3' LET l_msg='EMPL'
              WHEN p_code='4' LET l_msg='AGENT'
         END CASE
   END CASE
   RETURN l_msg
END FUNCTION
 
FUNCTION i610_u()
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   IF g_pmca.pmcano IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_pmca.* FROM pmca_file
    WHERE pmcano=g_pmca.pmcano
   IF g_pmca.pmcaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_pmca.pmcano,'mfg1000',0)
      RETURN
   END IF
   #非開立狀態，不可異動！
   #狀況=>R:送簽退回,W:抽單 也要可以修改
   IF g_input_vendorno = 'N' THEN #CHI-840029 add if 判斷
       IF g_pmca.pmca05 NOT MATCHES '[0RW]' THEN CALL cl_err('','atm-046',1) RETURN END IF  
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_pmcano_t = g_pmca.pmcano
   LET g_pmca01_t = g_pmca.pmca01
   LET g_pmca24_t = g_pmca.pmca24
 
   IF g_action_choice <> "reproduce" THEN    #FUN-680010
      BEGIN WORK
   END IF
 
   OPEN i610_cl USING g_pmca.pmcano
   IF STATUS THEN
      CALL cl_err("OPEN i610_cl:", STATUS, 1)
      CLOSE i610_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i610_cl INTO g_pmca.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pmca.pmcano,SQLCA.sqlcode,0)
      ROLLBACK WORK      #FUN-680010
      RETURN
   END IF
   LET g_pmca.pmcamodu = g_user                   #修改者
   LET g_pmca.pmcadate = g_today                  #修改日期
   #FUN-B90080 add --start--
   IF g_pmca.pmca914 IS NULL OR cl_null(g_pmca.pmca914) THEN
      LET g_pmca.pmca914 = 'N'
   END IF
   #FUN-B90080 add --end--   
   CALL i610_show()                          # 顯示最新資料
   WHILE TRUE
      LET g_pmca.pmcamodu = g_user                   #修改者
      LET g_pmca.pmcadate = g_today                  #修改日期
      CALL i610_i("u")                      # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_pmca.* = g_pmca_t.*
         CALL i610_show()
         CALL cl_err('',9001,0)
         ROLLBACK WORK     
         EXIT WHILE
      END IF
       IF g_pmca.pmca05 MATCHES '[RW]' THEN
           LET g_pmca.pmca05 = '0' #開立
       END IF
      UPDATE pmca_file SET pmca_file.* = g_pmca.*    # 更新DB
        WHERE pmcano = g_pmcano_t
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","pmca_file",g_pmcano_t,"",SQLCA.sqlcode,"","",1)  
         ROLLBACK WORK     
         BEGIN WORK       
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i610_cl
   COMMIT WORK #TQC-740090 add
   CALL cl_flow_notify(g_pmca.pmcano,'U')   #MOD-860238
   SELECT * INTO g_pmca.* FROM pmca_file WHERE pmcano = g_pmca.pmcano 
   CALL i610_show()                                            
END FUNCTION
 
FUNCTION i610_x()
   DEFINE   l_cnt   LIKE type_file.num5,    #No.FUN-680136 SMALLINT
            l_chr   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
   DEFINE l_pmcano  LIKE pmca_file.pmcano  #MOD-B40095 add
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   IF g_pmca.pmcano IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   #非開立狀態，不可異動！
  #狀況=>R:送簽退回,W:抽單 也要可以做無效切換
   IF g_pmca.pmca05 NOT MATCHES '[0RW]' THEN CALL cl_err('','atm-046',1) RETURN END IF  

   #MOD-B40095 add --start--
   IF g_pmca.pmca00 = 'U' AND g_pmca.pmcaacti='N' THEN
      LET l_pmcano = NULL
      SELECT pmcano INTO l_pmcano FROM pmca_file
       WHERE pmca01 = g_pmca.pmca01
         AND pmca00 = 'U' #修改
         AND pmca05 != '2' 
         AND pmcaacti != 'N' 
      IF NOT cl_null(l_pmcano) THEN
         #已存在一張相同廠商,但未拋轉的廠商申請單!
         CALL cl_err(l_pmcano,'apm-601',1)
         RETURN
      END IF
   END IF
   #MOD-B40095 add --end--
 
   BEGIN WORK
 
   OPEN i610_cl USING g_pmca.pmcano
   IF STATUS THEN
      CALL cl_err("OPEN i610_cl:", STATUS, 1)
      CLOSE i610_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i610_cl INTO g_pmca.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pmca.pmcano,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   CALL i610_show()
   IF cl_exp(0,0,g_pmca.pmcaacti) THEN
      LET g_chr=g_pmca.pmcaacti
      IF g_pmca.pmcaacti='Y' THEN
         LET g_pmca.pmcaacti='N'
      ELSE
         LET g_pmca.pmcaacti='Y'
      END IF
      UPDATE pmca_file
          SET pmcaacti = g_pmca.pmcaacti,
              pmcamodu = g_user,
              pmcadate = g_today,
              pmca05   = '0' #開立 #TQC-750007 add
          WHERE pmcano = g_pmca.pmcano
      IF SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err3("upd","pmca_file","","",SQLCA.sqlcode,"","",1)  
          ROLLBACK WORK
      END IF
   END IF
   CLOSE i610_cl
   COMMIT WORK
   SELECT * INTO g_pmca.* FROM pmca_file WHERE pmcano = g_pmca.pmcano 
   CALL i610_show()                                            
 
END FUNCTION
 
FUNCTION i610_r()
   DEFINE   l_cnt   LIKE type_file.num5,    #No.FUN-680136 SMALLINT
            l_chr   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   IF g_pmca.pmcano IS NULL THEN   #MOD-850267
      CALL cl_err('',-400,0)
      RETURN
   END IF
   #非開立狀態，不可異動！
  #狀況=>R:送簽退回,W:抽單 也要可以做刪除
   IF g_pmca.pmca05 NOT MATCHES '[0RW]' THEN CALL cl_err('','atm-046',1) RETURN END IF  
 
   SELECT * INTO g_pmca.* FROM pmca_file
    WHERE pmcano=g_pmca.pmcano
 
   BEGIN WORK
 
   OPEN i610_cl USING g_pmca.pmcano
   IF STATUS THEN
      CALL cl_err("OPEN i610_cl:", STATUS, 1)
      CLOSE i610_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i610_cl INTO g_pmca.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pmca.pmcano,SQLCA.sqlcode,0)
      RETURN
   END IF
   CALL i610_show()
   IF cl_delete() THEN
       INITIALIZE g_doc.* TO NULL            #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "pmcano"          #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_pmca.pmcano      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
      DELETE FROM pmca_file 
       WHERE pmcano = g_pmca.pmcano
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("del","pmca_file",g_pmca.pmcano,"",SQLCA.sqlcode,"","",1)  
         ROLLBACK WORK
         RETURN
      END IF
 
      LET g_msg_i600=TIME    #NO.FUN-820028
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980006 add azoplant,azolegal
        VALUES ('apmi610',g_user,g_today,g_msg_i600,g_pmca.pmcano,'delete',g_plant,g_legal) #FUN-980006 add g_plant,g_legal
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","azo_file","apmi610","",SQLCA.sqlcode,"","",1)  
         ROLLBACK WORK
         RETURN
      END IF
 
      CLEAR FORM
      OPEN i610_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE i610_cs
         CLOSE i610_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH i610_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i610_cs
         CLOSE i610_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i610_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i610_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i610_fetch('/')
      END IF
   END IF
   CLOSE i610_cl
   COMMIT WORK
   CALL cl_flow_notify(g_pmca.pmcano,'D')   #MOD-860238
END FUNCTION
 
FUNCTION i610_copy()
   DEFINE   l_n               LIKE type_file.num5,    #No.FUN-680136 SMALLINT
            l_pmca            RECORD LIKE pmca_file.*,
            l_newno,l_oldno   LIKE pmca_file.pmcano,
            l_pmca01          LIKE pmca_file.pmca01,   #MOD-A50174
            l_pmcano          LIKE pmca_file.pmcano    #MOD-A50174
   DEFINE li_result           LIKE type_file.num5   
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   IF g_pmca.pmcano IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   LET g_before_input_done = FALSE
   CALL i610_set_entry('a')
   LET g_before_input_done = TRUE
 
   INPUT l_newno,l_pmca01 FROM pmcano,pmca01   #MOD-A50174 add pmca01
  
   AFTER FIELD pmcano
     CALL s_check_no('apm',l_newno,"","Z","pmca_file","pmcano","")
          RETURNING li_result,l_newno 
     IF (NOT li_result) THEN                                            
         LET g_pmca.pmcano=g_pmca_t.pmcano                             
         NEXT FIELD pmcano                                             
     END IF   
   #-----MOD-A50174---------
   AFTER FIELD pmca01 
     IF g_pmca.pmca00 = 'I' THEN #新增
         LET l_n = 0 
         SELECT count(*) INTO l_n FROM pmc_file
          WHERE pmc01 = l_pmca01
         IF l_n > 0 THEN
            CALL cl_err(l_pmca01,-239,1) 
            NEXT FIELD pmca01
         END IF
         LET l_n = 0
         SELECT count(*) INTO l_n FROM pmca_file
          WHERE pmca01 = l_pmca01
            AND pmca00 = 'I' #新增
         IF l_n > 0 THEN
            CALL cl_err(l_pmca01,-239,1)
            NEXT FIELD pmca01
         END IF
     ELSE
         LET l_n = 0
         SELECT count(*) INTO l_n FROM pmc_file
          WHERE pmc01 = l_pmca01
         IF l_n <= 0 THEN
            #無此供應廠商, 請重新輸入!
            CALL cl_err(l_pmca01,'aap-000',1)
            NEXT FIELD pmca01
         END IF
         LET l_pmcano = NULL
         SELECT pmcano INTO l_pmcano FROM pmca_file
          WHERE pmca01 = l_pmca01
            AND pmca00 = 'U' #修改
            AND pmca05 != '2' 
            AND pmcaacti != 'N' #MOD-B40095 add
         IF NOT cl_null(l_pmcano) THEN
            #已存在一張相同廠商,但未拋轉的廠商申請單!
            CALL cl_err(l_pmcano,'apm-601',1)
            NEXT FIELD pmca01
         END IF
     END IF
   #-----END MOD-A50174-----
  
   AFTER INPUT
     CALL s_auto_assign_no("apm",l_newno,g_today,"Z","pmca_file","pmcano","","","") 
          RETURNING li_result,l_newno   
                      
      ON ACTION CONTROLP                                                        
         CASE
            WHEN INFIELD(pmcano)                                                
               CALL q_smy(FALSE,FALSE,g_t1,'APM','Z') RETURNING g_t1            
               LET l_newno = g_t1                                         
               DISPLAY BY NAME g_pmca.pmcano                                    
               NEXT FIELD pmcano                                                                        
            OTHERWISE EXIT CASE                                                 
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
      DISPLAY BY NAME g_pmca.pmcano
      RETURN
   END IF
   LET l_pmca.*=g_pmca.*
   LET l_pmca.pmcano=l_newno     #資料鍵值
   LET l_pmca.pmca01=l_pmca01     #MOD-A50174
   LET l_pmca.pmca03=NULL        #廠商簡稱    #MOD-4C0099
   CASE l_pmca.pmca30
      WHEN '1'
            LET l_pmca.pmca04=NULL        #付款廠商編號#MOD-4C0099
            LET l_pmca.pmca901=l_pmca.pmca01#出貨廠商    #MOD-4C0099
      WHEN '2'
            LET l_pmca.pmca04=l_pmca.pmca01 #付款廠商編號#MOD-4C0099
            LET l_pmca.pmca901=NULL       #出貨廠商    #MOD-4C0099
      WHEN '3'
            LET l_pmca.pmca04=l_pmca.pmca01 #付款廠商編號#MOD-4C0099
            LET l_pmca.pmca901=l_pmca.pmca01#出貨廠商    #MOD-4C0099
   END CASE
 
   LET l_pmca.pmca24=NULL        #統一統號    #MOD-4C0099
   LET l_pmca.pmca45=0
   LET l_pmca.pmca46=0
   LET l_pmca.pmcauser=g_user    #資料所有者
   LET l_pmca.pmcagrup=g_grup    #資料所有者所屬群
   LET l_pmca.pmcamodu=NULL      #資料修改日期
   LET l_pmca.pmcadate=g_today   #資料建立日期
   LET l_pmca.pmcaacti='Y'       #有效資料
   LET l_pmca.pmca05 = 0         #交易狀況      #MOD-940096
   LET l_pmca.pmca23 = g_smy.smyapr      #MOD-D10211
   
   BEGIN WORK    #NO.FUN-680010
 
   LET l_pmca.pmcaoriu = g_user      #No.FUN-980030 10/01/04
   LET l_pmca.pmcaorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO pmca_file VALUES(l_pmca.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","pmca_file","","",SQLCA.sqlcode,"","pmca_file",1)  #No.FUN-660129
      ROLLBACK WORK     #FUN-680010
   ELSE
      LET g_success = 'Y'
      IF g_success = 'Y' THEN
         LET l_oldno = g_pmca.pmcano
         SELECT pmca_file.* INTO g_pmca.* FROM pmca_file
                        WHERE pmcano = l_newno
         CALL i610_u()
      
         COMMIT WORK     #MOD-940096    
 
         #SELECT pmca_file.* INTO g_pmca.* FROM pmca_file  #FUN-C80046
         #               WHERE pmcano = l_oldno            #FUN-C80046
      END IF
   END IF
   CALL i610_show()
END FUNCTION
 
FUNCTION i610_pmca901(p_cmd)
   DEFINE   l_pmcaacti LIKE pmca_file.pmcaacti 
   DEFINE   l_pmca03   LIKE pmca_file.pmca03,
            p_cmd     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    LET g_errno = " "
    IF g_pmca.pmca901 = g_pmca.pmca01 AND NOT cl_null(g_pmca.pmca901) THEN
       LET l_pmca03 = g_pmca.pmca03
    ELSE
       SELECT pmc03,pmcacti INTO l_pmca03,l_pmcaacti FROM pmc_file  
        WHERE pmc01=g_pmca.pmca901
       CASE
         WHEN SQLCA.SQLCODE = 100
            SELECT pmca03,pmcaacti INTO l_pmca03,l_pmcaacti FROM pmca_file  
             WHERE pmca01=g_pmca.pmca901
            CASE
              WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-000'
                                       LET l_pmca03 = NULL
              WHEN l_pmcaacti='N'      LET g_errno = '9028' #MOD-530531
              OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
            END CASE
          WHEN l_pmcaacti='N'     LET g_errno = '9028' #MOD-530531
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_pmca03 TO pmca03_e
    END IF
 
END FUNCTION
 
FUNCTION i610_azp(p_azp01)
   DEFINE   l_azp01   LIKE azp_file.azp01,
            p_azp01   LIKE azp_file.azp01
 
   LET g_errno = " "
   SELECT azp01 INTO l_azp01 FROM azp_file
    WHERE azp01=p_azp01
   CASE
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'apm-277'
                               LET l_azp01 = NULL
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
END FUNCTION
 
FUNCTION i610_occ(p_occ01)
   DEFINE   p_cmd	LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
            p_occ01     LIKE occ_file.occ01,		#客戶代號
            l_occ02     LIKE occ_file.occ02,		#客戶簡稱
            l_occacti   LIKE occ_file.occacti 		#有效碼
 
   LET g_errno = ''
   SELECT occ02,occacti INTO l_occ02,l_occacti
     FROM occ_file WHERE occ01= p_occ01
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3029'
                                  LET l_occ02   = NULL
                                  LET l_occacti = NULL
        WHEN l_occacti='N' LET g_errno = '9028'
        WHEN l_occacti MATCHES '[PH]'   LET g_errno = '9038'   #FUN-690023 add
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   RETURN l_occ02
END FUNCTION
 
FUNCTION i610_out()
   DEFINE   l_i      LIKE type_file.num5,               #No.FUN-680136 SMALLINT
            sr       RECORD LIKE pmca_file.*,
            l_name   LIKE type_file.chr20,              # External(Disk) file name  #No.FUN-680136 VARCHAR(20)
            l_za05   LIKE type_file.chr1000,            #  #No.FUN-680136 VARCHAR(40)
            l_chr    LIKE type_file.chr1,               #No.FUN-680136 VARCHAR(1)
            l_str    STRING   #MOD-920282
 
   IF cl_null(g_wc) THEN LET g_wc=" pmca01='",g_pmca.pmca01,"'" END IF
   LET g_choice = 'N'

   OPEN WINDOW i610_ww WITH FORM "apm/42f/apmi610w"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_locale("apmi610w")
 
   INPUT g_choice FROM choice
 
   CLOSE WINDOW i610_ww
 
   CALL cl_wait()
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   LET g_sql = "SELECT * FROM pmca_file ",         # 組合出 SQL 指令
               " WHERE ",g_wc CLIPPED
   PREPARE i610_p1 FROM g_sql                      # RUNTIME 編譯
   DECLARE i610_co                                 # CURSOR
       CURSOR FOR i610_p1
 
 
   FOREACH i610_co INTO sr.*
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)   #No.FUN-660129
           EXIT FOREACH
       END IF
   END FOREACH
 
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN
          CALL cl_wcchp(g_wc,
                   'pmca00  ,pmcano  ,pmca01  ,pmca03  ,pmca081,pmca082,
                    pmca24  ,pmca903 ,pmca14 ,
                    pmca02  ,pmca30  ,pmca04  ,pmca901 ,pmca05 ,pmca23 ,
                    pmca17  ,pmca49  ,pmca22  ,pmca47  ,pmca54 ,pmca911,
                    pmca48  ,pmca902 ,pmca27  ,pmca50  ,pmca51 ,pmca28 ,
                    pmca908 ,pmca07  ,pmca06  ,pmca904 ,pmca091,pmca092,
                    pmca093 ,pmca094 ,pmca095,   
                    pmca52  ,pmca53  ,pmca15  ,pmca16  ,
                    pmca56  ,pmca55  ,pmca10  ,pmca11  ,pmca12 ,
                    pmca914 ,pmca915 ,pmca916 ,pmca917 ,pmca918, #FUN-B90080 add
                    pmca919 ,pmca920 ,pmca921 ,pmca922 ,pmca923, #FUN-B90080 add
                    pmcauser,pmcagrup,pmcamodu,pmcadate,pmcaacti')
 
          RETURNING l_str   #MOD-920282
          LET g_str = l_str  #MOD-920282     
    END IF
    LET g_str = g_str,";",g_choice
 
   CALL cl_prt_cs1('apmi610','apmi610',g_sql,g_str)  #CHI-780006 add
 
   CLOSE i610_co
   ERROR ""
END FUNCTION
 
FUNCTION i610_ef()
 
   CALL i610_y_chk()
   IF g_success = "N" THEN
      RETURN
   END IF
 
   CALL aws_condition()                            #判斷送簽資料
   IF g_success = 'N' THEN
         RETURN
   END IF
 
##########
# CALL aws_efcli2()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
##########
 
   IF aws_efcli2(base.TypeInfo.create(g_pmca),'','','','','')
   THEN
       LET g_success = 'Y'
       LET g_pmca.pmca05 = 'S'   #開單成功, 更新狀態碼為 'S. 送簽中'
       DISPLAY BY NAME g_pmca.pmca05
   ELSE
       LET g_success = 'N'
   END IF
 
END FUNCTION
 
FUNCTION i610_show_pic()
     SELECT pmca05 INTO g_pmca.pmca05 FROM pmca_file WHERE pmcano = g_pmca.pmcano
     IF g_pmca.pmca05 MATCHES '[12]' THEN 
         LET g_chr1='Y' 
         LET g_chr2='Y' 
     ELSE 
         LET g_chr1='N' 
         LET g_chr2='N' 
     END IF
     CALL cl_set_field_pic(g_chr1,g_chr2,"","","",g_pmca.pmcaacti)
# Memo        	: ps_confirm 確認碼, ps_approve 核准碼, ps_post 過帳碼
#               : ps_close 結案碼, ps_void 作廢碼, ps_valid 有效碼
END FUNCTION
 
FUNCTION i610_y_chk()
   DEFINE l_pmca01     LIKE   pmca_file.pmca01
   DEFINE l_tqo01      LIKE   tqo_file.tqo01 
   DEFINE l_tqk01      LIKE   tqk_file.tqk01
   DEFINE l_n          LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
   LET g_success = 'Y'
 
   IF (g_pmca.pmcano IS NULL) THEN
       CALL cl_err('',-400,0)
       LET g_success = 'N'
       RETURN 
   END IF
   IF g_pmca.pmcaacti='N' THEN 
       #本筆資料無效
       CALL cl_err('','mfg0301',1)
       LET g_success = 'N'
       RETURN
   END IF
   IF g_pmca.pmca05='1' THEN
       #已核准
       CALL cl_err('','mfg3212',1)
       LET g_success = 'N'
       RETURN
   END IF
   IF g_pmca.pmca05='2' THEN
       #已拋轉，不可再異動!
       CALL cl_err(g_pmca.pmcano,'axm-225',1)
       LET g_success = 'N'
       RETURN
   END IF
 
END FUNCTION
 
FUNCTION i610_y_upd()
DEFINE l_gew03   LIKE gew_file.gew03   #CHI-A80023 add
DEFINE l_gev04   LIKE gev_file.gev04   #CHI-A80023 add

   LET g_success = 'Y'
 
   IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
      g_action_choice CLIPPED = "insert"     #FUN-640184 
   THEN 
      IF g_pmca.pmca23='Y' THEN            #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
         IF g_pmca.pmca05 != '1' THEN
            #此狀況碼不為「1.已核准」，不可確認!!
            CALL cl_err('','aws-078',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      IF NOT cl_confirm('axm-108') THEN RETURN END IF  #詢問是否執行確認功能
   END IF
 
  BEGIN WORK
  OPEN i610_cl USING g_pmca.pmcano                                            
  IF STATUS THEN                                                               
      CALL cl_err("OPEN i610_cl:", STATUS, 1)                                  
      CLOSE i610_cl                                                            
      ROLLBACK WORK                                                            
      RETURN                                                                   
  END IF                                                                       
  FETCH i610_cl INTO g_pmca.*                                                
  IF SQLCA.sqlcode THEN                                                        
     CALL cl_err('',SQLCA.sqlcode,1)                                           
     RETURN                                                                    
  END IF                                     
  CALL i610_show()
  LET g_chr = g_pmca.pmca05
  UPDATE pmca_file 
     SET pmca05='1' #1:已核准
   WHERE pmcano = g_pmca.pmcano
  IF SQLCA.SQLERRD[3]=0 THEN                                                 
      CALL cl_err3("upd","pmca_file",g_pmca.pmcano,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
      LET g_pmca.pmca05=g_chr                                              
      DISPLAY BY NAME g_pmca.pmca05                                         
  END IF                                                                     
  CLOSE i610_cl      
   SELECT * INTO g_pmca.* FROM pmca_file
    WHERE pmcano = g_pmca.pmcano
  CALL i610_show()
   IF g_success = 'Y' THEN
      IF g_pmca.pmca23 = 'Y' THEN  #簽核模式
         CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
              WHEN 0  #呼叫 EasyFlow 簽核失敗
                   LET g_success = "N"
                   ROLLBACK WORK
                   RETURN
              WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                   ROLLBACK WORK
                   RETURN
         END CASE
      END IF
      IF g_success='Y' THEN
         LET g_pmca.pmca05='1'          #執行成功, 狀態值顯示為 '1' 已核准
         COMMIT WORK
         CALL cl_flow_notify(g_pmca.pmcano,'Y')
         DISPLAY BY NAME g_pmca.pmca05
      ELSE
         LET g_success = 'N'
         ROLLBACK WORK
      END IF
   ELSE
      LET g_success = 'N'
      ROLLBACK WORK
   END IF
 
   #CKP
   SELECT * INTO g_pmca.* FROM pmca_file WHERE pmcano = g_pmca.pmcano 
   CALL i610_show_pic() #圖示

   #CHI-A80023 add --start--
   SELECT gev04 INTO l_gev04 FROM gev_file
    WHERE gev01 = '5' and gev02 = g_plant
   SELECT UNIQUE gew03 INTO l_gew03 FROM gew_file
    WHERE gew01 = l_gev04
      AND gew02 = '5'
   IF l_gew03 = '1' THEN
      IF cl_null(g_pmca.pmca01) THEN
         CALL cl_err(g_pmca.pmcano,'apm-611','1')
      ELSE
         CALL i610_dbs()
         SELECT * INTO g_pmca.* FROM pmca_file WHERE pmcano = g_pmca.pmcano 
         CALL i610_show()
      END IF
   END IF
   #CHI-A80023 add --end--
END FUNCTION
 
FUNCTION i610_z()
   DEFINE l_pmca01 LIKE pmca_file.pmca01
    
   IF (g_pmca.pmcano IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN 
   END IF
   IF g_pmca.pmcaacti='N' THEN 
      #本筆資料無效
      CALL cl_err('','mfg0301',1)
      RETURN
   END IF
   IF g_pmca.pmca05 = 'S' THEN
      #送簽中, 不可修改資料!
      CALL cl_err(g_pmca.pmcano,'apm-030',1)
      RETURN
   END IF
   #非審核狀態 不能取消審核
   IF g_pmca.pmca05 !='1' THEN
      CALL  cl_err('','atm-053',1)
      RETURN
   END IF
   
   IF NOT cl_confirm('aim-302') THEN RETURN END IF    #是否確定執行取消確認(Y/N)?
   BEGIN WORK
 
   OPEN i610_cl USING g_pmca.pmcano                                            
   IF STATUS THEN                                                               
       CALL cl_err("OPEN i610_cl:", STATUS, 1)                                  
       CLOSE i610_cl                                                            
       ROLLBACK WORK                                                            
       RETURN                                                                   
   END IF                                                                       
   FETCH i610_cl INTO g_pmca.*                                                
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err('',SQLCA.sqlcode,1)                                           
      RETURN                                                                    
   END IF                                     
   CALL i610_show()
   LET g_chr=g_pmca.pmca05
   UPDATE pmca_file 
      SET pmca05='0' #0:開立
    WHERE pmcano = g_pmca.pmcano
   IF SQLCA.SQLERRD[3]=0 THEN                                                 
       CALL cl_err3("upd","pmca_file",g_pmca.pmcano,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       LET g_pmca.pmca05=g_chr                                              
       DISPLAY BY NAME g_pmca.pmca05                                         
   END IF                                                                     
   CLOSE i610_cl     
   SELECT * INTO g_pmca.* FROM pmca_file WHERE pmcano = g_pmca.pmcano
   COMMIT WORK
   CALL i610_show()
END FUNCTION
#No:FUN-9C0071--------精簡程式-----


#No.TQC-C70218  --Begin
FUNCTION i610_set_pmca03(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  DEFINE l_cnt   LIKE type_file.num5
  DEFINE l_occ02 LIKE occ_file.occ02

   IF cl_null(g_pmca.pmca01) THEN RETURN END IF
   IF p_cmd <> 'a' AND g_action_choice <> "reproduce" THEN RETURN END IF   #No.FUN-BB0049
   IF g_aza.aza125 = 'N' THEN RETURN END IF          #No.FUN-BB0049

   SELECT occ02 INTO l_occ02 FROM occ_file
    WHERE occ01 = g_pmca.pmca01
   IF cl_null(l_occ02) THEN RETURN END IF
   IF NOT cl_null(l_occ02) THEN
      LET g_pmca.pmca03 = l_occ02
      DISPLAY BY NAME g_pmca.pmca03
   END IF

END FUNCTION
#No.TQC-C70218  --End

#CHI-CB0017 add begin---
FUNCTION i610_copy_refdoc()
   DEFINE l_gca01_o    LIKE gca_file.gca01
   DEFINE l_gca01_n    LIKE gca_file.gca01
   DEFINE l_filename   LIKE gca_file.gca07
   DEFINE l_gca        RECORD LIKE gca_file.*
   DEFINE l_gcb        RECORD LIKE gcb_file.*
   DEFINE l_sql        STRING
   DEFINE l_cnt        LIKE type_file.num5

   LET l_gca01_o = "pmc01=",g_pmca.pmca01
   LET l_gca01_n = "pmcano=",g_pmca.pmcano
   LET l_sql = "SELECT * FROM gca_file WHERE gca01 = '",l_gca01_o,"' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   PREPARE doc_pre1 FROM l_sql
   DECLARE doc_cur1 CURSOR WITH HOLD FOR doc_pre1
   FOREACH doc_cur1 INTO l_gca.*
      LET l_filename = s_get_docnum(l_gca.gca08)
      LET l_sql = " INSERT INTO gca_file",
                  "  (gca01 ,",
                  "   gca02 ,",
                  "   gca03 ,",
                  "   gca04 ,",
                  "   gca05 ,",
                  "   gca06 ,",
                  "   gca07 ,",
                  "   gca08 ,",
                  "   gca09 ,",
                  "   gca10 ,",
                  "   gca11 ,",
                  "   gca12 ,",
                  "   gca13 ,",
                  "   gca14 ,",
                  "   gca15 ,",
                  "   gca16 ,",
                  "   gca17 )",
                  " VALUES ( ?,?,?,?,?,   ?,?,?,?,?, ",
                  "          ?,?,?,?,?,   ?,?       )"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      PREPARE ins_doc FROM l_sql
      EXECUTE ins_doc USING l_gca01_n,
                            l_gca.gca02,
                            l_gca.gca03,
                            l_gca.gca04,
                            l_gca.gca05,
                            l_gca.gca06,
                            l_filename,
                            l_gca.gca08,
                            l_gca.gca09,
                            l_gca.gca10,
                            l_gca.gca11,
                            l_gca.gca12,
                            l_gca.gca13,
                            l_gca.gca14,
                            l_gca.gca15,
                            l_gca.gca16,
                            l_gca.gca17
      IF SQLCA.sqlcode THEN
          LET g_msg = 'INSERT ','gca_file'
          CALL cl_err(g_msg,'lib-028',1)
          LET g_success = 'N'
          EXIT FOREACH
      END IF

      DISPLAY "Insert gca_file/Rows: ",l_gca01_n," / ",SQLCA.sqlerrd[3]   #Background Message
      DISPLAY "l_filename: ",l_filename   #Background Message

      LET l_sql = " SELECT * FROM gcb_file",
                  "   WHERE gcb01= '",l_gca.gca07,"' "
      PREPARE doc_pre2 FROM l_sql
      DECLARE doc_cur2 CURSOR WITH HOLD FOR doc_pre2
      LOCATE l_gcb.gcb09 IN MEMORY
      FOREACH doc_cur2 INTO l_gcb.*
          LET l_sql = " INSERT INTO gcb_file",
                      "   ( gcb01 ,",
                      "     gcb02 ,",
                      "     gcb03 ,",
                      "     gcb04 ,",
                      "     gcb05 ,",
                      "     gcb06 ,",
                      "     gcb07 ,",
                      "     gcb08 ,",
                      "     gcb09 ,",
                      "     gcb10 ,",
                      "     gcb11 ,",
                      "     gcb12 ,",
                      "     gcb13 ,",
                      "     gcb14 ,",
                      "     gcb15 ,",
                      "     gcb16 ,",
                      "     gcb17 ,",
                      "     gcb18 )",
                      " VALUES ( ?,?,?,?,?,   ?,?,?,?,?, ",
                      "          ?,?,?,?,?,   ?,?,?     )"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         PREPARE ins_doc2 FROM l_sql
         EXECUTE ins_doc2 USING l_filename,
                                l_gcb.gcb02,
                                l_gcb.gcb03,
                                l_gcb.gcb04,
                                l_gcb.gcb05,
                                l_gcb.gcb06,
                                l_gcb.gcb07,
                                l_gcb.gcb08,
                                l_gcb.gcb09,
                                l_gcb.gcb10,
                                l_gcb.gcb11,
                                l_gcb.gcb12,
                                l_gcb.gcb13,
                                l_gcb.gcb14,
                                l_gcb.gcb15,
                                l_gcb.gcb16,
                                l_gcb.gcb17,
                                l_gcb.gcb18
         IF SQLCA.sqlcode THEN
             LET g_msg = 'INSERT ','gcb_file'
             CALL cl_err(g_msg,'lib-028',1)
             LET g_success = 'N'
             EXIT FOREACH
         END IF
         DISPLAY "Insert gcb_file/Rows: ",l_filename," / ",SQLCA.sqlerrd[3]   #Background Message
         FREE l_gcb.gcb09
      END FOREACH
   END FOREACH
END FUNCTION
#CHI-CB0017 add end-----
