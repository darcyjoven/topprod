# Prog. Version..: '5.30.06-13.03.19(00010)'     #
#
# Pattern name...: axmi250.4gl
# Descriptions...: 客戶申請維護作業
# Date & Author..: 2006/08/23 by Mandy
# Modify.........: No.FUN-680137 06/09/14 By bnlent 欄位型態定義，改為LIKE  
# Modify.........: No.FUN-6A0094 06/11/01 By yjkhero l_time轉g_time 
# Modify.........: No.FUN-6A0020 06/11/21 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6C0060 07/01/08 By alexstar 多語言功能單純化
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730018 07/03/26 By kim 行業別架構
# Modify.........: No.TQC-730112 07/04/12 By Mandy 將CALL aws_efapp_flowaction() 移至BEFORE MENU,可避免在畫面上按滑鼠右鍵，會出現簽核的指令
# Modify.........: No.TQC-740090 07/04/14 By Mandy 1.單據更改後,"資料更改者"沒有更新 
#                                                  2.資料拋轉時,s_carry_data()內的畫面多一個欄位'已存在',存放該要拋轉的資料是否存在當筆的那個資料庫
#                                                  3.申請類型為'U'時或此筆資料已無效,不可異動"信用額度"相關欄位
#                                                  4.額度客戶(occa33)管控
# Modify.........: No.TQC-740169 07/04/26 By Mandy 資料拋轉時,s_carry_date 重新給default 邏輯
# Modify.........: No.TQC-740334 07/04/27 By Mandy 當新增一筆申請類別為'U:修改'的申請單時,某些欄位內容錯誤,會帶修改的客戶編號在occ_file內的資料
# Modify.........: No.TQC-740343 07/04/27 By Mandy 資料拋轉時,資料所有者,資料所有部門,資料修改者,最近修改日 等欄位錯誤
# Modify.........: No.TQC-750007 07/05/02 By Mandy 1.串EasyFlow未OK
#                                                  2.修改時,狀況=>R:送簽退回,W:抽單 也要可以修改
# Modify.........: No.FUN-740193 07/05/10 By Mandy add 客戶財務資料
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-780003 07/08/01 By Mandy Action "資料拋轉"時,若申請類別為'新增'時,資料已存在的不能選取,做拋轉
#                                                                      若申請類別為'修改'時,資料不存在的不能選取,做拋轉,避免不必要的錯誤產生!
# Modify.........: No.TQC-770125 07/08/01 By claire MOD-720053 額度客戶<>客戶編號時,occ63可允許輸入0
# Modify.........: No.TQC-710125 07/08/01 By claire MOD-740031 新增時未檢查統一編號
# Modify.........: No.TQC-710125 07/08/01 By claire MOD-760150 性質為2時應default送貨客戶,性質為3時應default收款客戶
# Modify.........: No.CHI-780006 07/08/09 By jamie 增加CR列印功能
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/14 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-7C0084 08/01/23 By Mandy AFTER FIELD occa01 若occa00為"新增",控管申請客戶編號不可重覆
# Modify.........: No.FUN-7C0010 08/03/03 By Carrier 將"資料拋轉"的邏輯移至s_axmi221_carry.4gl中
# Modify.........: NO.FUN-840018 08/04/03 by Yiting 加入拋轉歷史查詢功能
# Modify.........: No.FUN-840042 08/04/10 by TSD.zeak 自訂欄位功能修改 
# Modify.........: NO.CHI-840028 08/04/20 By Mandy (1)申請時,客戶編號可空白
#                                                  (2)送簽中,未拋轉前,可補客戶編號
#                                                  (3)拋轉前,check必需有客戶編號
#                                                  (4)若有用自動編號,補客戶編號時,可另按Action產生
# Modify.........: NO.MOD-840275 08/04/20 By Mandy 申請單確認後且已正式拋轉，但仍可取消確認
# Modify.........: NO.FUN-840098 08/04/24 By sherry 新增復制功能
# Modify.........: NO.TQC-850019 08/05/13 By claire 使用更改性質的單據申請時,key值空白未控卡
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: NO.MOD-860078 08/06/06 BY Yiting ON IDLE 處理
# Modify.........: No.MOD-960005 09/07/07 By Smapmin 建檔無給予客戶編號,存檔時會卡在occa09/occa07
# Modify.........: No.MOD-970184 09/07/23 By sabrina occa55在uni區無泰文選項，將occa55改為動態抓取語言選項
# Modify.........: No.FUN-980010 09/08/20 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990046 09/09/18 By mike  慣用交運方式、慣用運送起點、慣用運送起點、卸貨港該四個欄位是否可以將說明秀出來   
# Modify.........: No:MOD-960126 09/06/09 By Pengu 新增料件時應遵循資料中心的關連與控管
# Modify.........: No:MOD-9B0035 09/11/05 By Smapmin 送貨客戶及收款客戶在資料未拋轉下會抓不到當下的客戶名稱
# Modify.........: No:FUN-9C0071 10/01/07 By huangrh 精簡程式
# Modify.........: No:TQC-A10019 10/01/08 By lilingyu "寬限天數 額度"欄位未控管負數
# Modify.........: No:TQC-A10023 10/01/08 By lilingyu "慣用傭金率 折扣率"欄位未控管負數 和大于100的數
# Modify.........: No:MOD-9C0435 10/02/23 By sabrina 複製時，若該單別需簽核，則複製後簽核欄位要打勾
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:CHI-A80023 10/08/23 By Summer 增加檢核,若確認時客戶編號還沒輸入,但資料中心拋轉設為1.自動拋轉時,提示訊息
# Modify.........: No:FUN-A80073 10/08/23 By wangxin 客戶資料來源為商戶資料, 禁止在本作業維護
# Modify.........: No:CHI-A80050 10/10/12 By Summer 開放axmi250其他欄位的修改,如同axmi221
# Modify.........: No:MOD-A80234 10/10/29 By Smapmin 單據新增前再次判斷客戶編號是否重複
# Modify.........: No:TQC-AB0088 10/11/28 By wangxin BUG修改
# Modify.........: No:CHI-AC0001 10/12/08 By Summer 申請作業上的欄位本來就可能與基本資料的不同,修改為直接抓取每個欄位放到g_occa的變數裡
# Modify.........: No:MOD-B40095 11/04/18 By Summer axm-227的控卡要排除'無效'的資料,另外,無效資料又要變為有效資料時,要確認已沒有有效資料存在 
# Modify.........: No:FUN-B30044 11/04/22 By suncx 新增欄位"慣用訂金收款條件(occa68)"、"慣用尾款收款條件(occa69)"
# Modify.........: No:TQC-B40201 11/04/25 By lilingyu EF簽核相關BUG修改
# Modify.........: No.CHI-B40058 11/05/16 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No:MOD-B50177 11/05/20 By Smapmin 無法連續列印二次
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No.MOD-B80131 11/08/12 By johung 補客戶編號時，若額度客戶為空，則預設額度客戶為客戶編號
# Modify.........: No:MOD-B90049 11/09/06 By johung 新增時客戶簡稱欄位為空時才預設帶入客戶編號
# Modify.........: No:MOD-B90068 11/09/08 By johung 集團碼開窗用q_occ34
# Modify.........: No:TQC-BA0104 11/10/25 By destiny 增加自動審核,自動列印功能
# Modify.........: No:TQC-BB0002 11/01/01 By Carrier MISC/EMPL时不CHECK pmc简称是否存在
# Modify.........: No:FUN-BB0049 11/11/23 By Carrier aza125='Y'&厂商及客户编号相同时,简称需保持相同,若为'N',则不需有此管控
#                                                    aza126='Y'&厂商客户简称修改后,需更新历史资料
# Modify.........: No:MOD-BA0206 12/01/17 By Vampire 將axmi250的axm-052錯誤訊息判斷拿掉 

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C20028 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No:FUN-C30017 12/03/07 By Mandy TP端簽核時,[資料拋轉歷史]/[信用額度設定] ACTION要隱藏
# Modify.........: No:TQC-C70076 12/07/11 By zhuhao 申請類型為U，客戶簡稱應不可以修改。
# Modify.........: No:MOD-C70144 12/07/17 By SunLM 在U更新狀態下,不得更改客戶簡稱
# Modify.........: No:TQC-C80037 12/08/06 By dongsz user和grup的參數應該是從occa_file取值
# Modify.........: No:TQC-C70218 12/08/01 By SunLM 还原MOD-C70144,FUN-BB0049已經處理
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-C80019 12/08/16 By pauline 集團碼開放可輸入自己的編號
# Modify.........: No:MOD-C80143 12/09/17 By jt_chen 增加控卡,不可新增重複的客戶編號
# Modify.........: No:CHI-CB0017 12/12/24 By Lori 申請類別為修改時,需將來源的相關文件複製寫入
# Modify.........: No:MOD-CC0094 13/01/31 By jt_chen 移除營業執照有效日期相關欄位(occ1001/occ1002;occa1001/occa1002)

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_occa          RECORD LIKE occa_file.*,
    g_occa_t        RECORD LIKE occa_file.*,
    g_occa_ct       RECORD LIKE occa_file.*,
    g_occa01_t             LIKE occa_file.occa01,
    g_occano_t             LIKE occa_file.occano,
    g_wc,g_sql             string,                 #No.FUN-580092 HCN
    g_argv1                LIKE occa_file.occano,
    g_t1                   LIKE oay_file.oayslip,  #No.FUN-680137 VARCHAR(5)
    g_buf                  LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(40)
    p_row,p_col            LIKE type_file.num5,    #No.FUN-680137 SMALLINT
    g_forupd_sql           STRING,                 #SELECT ... FOR UPDATE SQL
    g_before_input_done    LIKE type_file.num5,    #No.FUN-680137 SMALLINT
    g_on_change            LIKE type_file.chr1     #No.FUN-680137 SMALLINT   #FUN-590083
 
DEFINE   g_gev04              LIKE gev_file.gev04   #NO.FUN-840018
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
DEFINE   g_chr1,g_chr2   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
DEFINE   g_chr3          LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
DEFINE   g_count         LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE   g_cmd           LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(100)
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose  #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(72)
DEFINE   i               LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE   j               LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
DEFINE   g_row_count     LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE   g_jump          LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE   g_laststage     LIKE type_file.chr1    #FUN-580158   #No.FUN-680137  VARCHAR(1)
DEFINE   g_str           STRING                 #CHI-780006 add
DEFINE   g_input_custno  LIKE type_file.chr1   #CHI-840028---add
DEFINE g_flag2           LIKE type_file.chr1    #No:MOD-960126 add
 
MAIN
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP,
       FIELD ORDER FORM                   #整個畫面會依照p_per所設定的欄位順序(忽略4gl寫的順序)  #FUN-730018
 
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_input_custno = 'N' #CHI-840028--add
 
   IF s_shut(0) THEN EXIT PROGRAM END IF
   IF g_aza.aza61 !='Y' THEN #不使用客戶申作業
      #參數設定不使用申請作業,所以無法執行此支程式!
      CALL cl_err('','axm-253',1)
      EXIT PROGRAM
   END IF 
 
   LET g_argv1 = ARG_VAL(1)
                                                                                
   IF fgl_getenv('EASYFLOW') = "1" THEN
         LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #NO.FUN-6A0094 
 
   INITIALIZE g_occa.* TO NULL
   INITIALIZE g_occa_t.* TO NULL
 
   LET g_forupd_sql = " SELECT * FROM occa_file  WHERE occano = ? ",
                      " FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i250_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   LET p_row = 2 LET p_col = 2
 
   OPEN WINDOW i250_w AT p_row,p_col WITH FORM "axm/42f/axmi250"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   #如果由表單追蹤區觸發程式, 此參數指定為何種資料匣
   #當為 EasyFlow 簽核時, 加入 EasyFlow 簽核 toolbar icon
   CALL aws_efapp_toolbar()    #FUN-580158
 
   IF NOT cl_null(g_argv1) THEN
      CALL i250_q()
   END IF
 
   LET g_action_choice=""
   IF g_aza.aza50='Y' THEN                                                      
       CALL cl_set_comp_visible("Customer",TRUE)   
       CALL cl_set_act_visible("finance_info_maintenance",TRUE)   #FUN-740193 add
   ELSE
       CALL cl_set_comp_visible("Customer",FALSE)   
       CALL cl_set_act_visible("finance_info_maintenance",FALSE)  #FUN-740193 add
   END IF
 
   CALL cl_set_combo_lang("occa55")          #MOD-970184 add
   CALL i250_menu()
 
   CLOSE WINDOW i250_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #NO.FUN-6A0094 
 
END MAIN
 
FUNCTION i250_curs()
    CLEAR FORM
 
    IF NOT cl_null(g_argv1) THEN
        LET g_wc = "occano = '",g_argv1,"'"
    ELSE
   INITIALIZE g_occa.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
          occa00,  occano  ,occa01 ,occa02,occa18,occa19, 
         #occa1001,occa1002,occa11 ,occa37,occa28,occa34,   #MOD-CC0094 mark
          occa11 ,occa37,occa28,occa34,                     #MOD-CC0094 add 
          occa66,  occa1005,
 
          occa1004,occa10,occa06,  occa09 ,occa07,occa03,occa04,
          occa56,  occa57,  occa31 ,occa65,  
 
          occa22,  occa21,  occa20 ,occa35, 
          occa231, occa232, occa233,
          occa241, occa242, occa243,
 
          occa261, occa262, occa263,occa271,occa272,
          occa29,  occa30,  occa292,occa302,
 
          occa40,  occa38,  occa39,
 
          occa42,  occa41,  occa08,  occa44,  occa45, occa68, occa69,   #FUN-B30044add occa68,occa69
 
          occa67,  occa43,  occa55,  occa47,
          occa48,  occa49,  occa50,
 
          occa46,  occa53,  occa32,  occa51,  occa52, 
          occa701, occa702, occa703, occa704,
 
          occa12,  occa13,  occa14,  occa15,  occa05,
 
          occa62,occa33,occa61,occa36,occa175,occa631,occa63,occa64,
 
          occa1003,occa1006,occa1007,occa1008,occa1009,
          occa1010,occa1011,occa1012,occa1013,occa1014,
          occa1015,occa1016,occa1027,
 
          occauser,occagrup,occamodu,occadate,occaacti,
             occaud01,occaud02,occaud03,occaud04,occaud05,
             occaud06,occaud07,occaud08,occaud09,occaud10,
             occaud11,occaud12,occaud13,occaud14,occaud15
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
        ON ACTION controlp
            CASE
             WHEN INFIELD(occano)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_occano'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occano
                  NEXT FIELD occano
             WHEN INFIELD(occa01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_occa01'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa01
                  NEXT FIELD occa01
             WHEN INFIELD(occa03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_oca'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa03
                  NEXT FIELD occa03
             WHEN INFIELD(occa04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_gen'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa04
                  NEXT FIELD occa04
             WHEN INFIELD(occa09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_occ'    #TQC-740090 mod
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa09
                  NEXT FIELD occa09
             WHEN INFIELD(occa07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_occ'    #TQC-740090 mod
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa07
                  NEXT FIELD occa07
             #CHI-A80050 add --start--
             WHEN INFIELD(occa08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_occa08'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa08
                  NEXT FIELD occa08
             WHEN INFIELD(occa34)
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form = 'q_occa34'   #MOD-B90068 mark
                  LET g_qryparam.form = 'q_occ34'    #MOD-B90068
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa34
                  NEXT FIELD occa34   
             #CHI-A80050 add --end--
             WHEN INFIELD(occa20)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_gea'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa20
                  NEXT FIELD occa20
             WHEN INFIELD(occa21)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_geb'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa21
                  NEXT FIELD occa21
             WHEN INFIELD(occa22)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_geo'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa22
                  NEXT FIELD occa22
             WHEN INFIELD(occa631)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_azi'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa631
                  NEXT FIELD occa631
             WHEN INFIELD(occa61)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_ocg'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa61
                  NEXT FIELD occa61
             WHEN INFIELD(occa33)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_occ'    #TQC-740090 mod
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa33
                  NEXT FIELD occa33
              WHEN INFIELD(occa41)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_gec'
                   LET g_qryparam.arg1 = '2'
                   LET g_qryparam.state  = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO occa41
                   NEXT FIELD occa41
              WHEN INFIELD(occa47)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_ged'
                  LET g_qryparam.default1 = g_occa.occa47
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa47
                  NEXT FIELD occa47
              WHEN INFIELD(occa43)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oab'
                 LET g_qryparam.default1 = g_occa.occa43
                 LET g_qryparam.state  = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occa43
                 NEXT FIELD occa43
 
              WHEN INFIELD(occa44)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oah'
                 LET g_qryparam.default1 = g_occa.occa44
                 LET g_qryparam.state  = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occa44
                 NEXT FIELD occa44
 
              WHEN INFIELD(occa45)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oag'
                 LET g_qryparam.default1 = g_occa.occa45
                 LET g_qryparam.state  = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occa45
                 NEXT FIELD occa45
             #FUN-B30044 add begin---------------------------    
              WHEN INFIELD(occa68)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oag'
                 LET g_qryparam.default1 = g_occa.occa68
                 LET g_qryparam.state  = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occa68
                 NEXT FIELD occa68
                 
              WHEN INFIELD(occa69)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oag'
                 LET g_qryparam.default1 = g_occa.occa69
                 LET g_qryparam.state  = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occa69
                 NEXT FIELD occa69      
             #FUN-B30044 add -end-----------------------------
 
              WHEN INFIELD(occa67)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_ool"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO occa67
                   NEXT FIELD occa67
 
# 加查詢明細資料
              WHEN INFIELD(occa42)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_azi'
                 LET g_qryparam.default1 = g_occa.occa42
                 LET g_qryparam.state  = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occa42
                 NEXT FIELD occa42
 
              WHEN INFIELD(occa48)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oac'
                 LET g_qryparam.default1 = g_occa.occa48
                 LET g_qryparam.state  = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occa48
                 NEXT FIELD occa48
 
              WHEN INFIELD(occa49)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oac'
                 LET g_qryparam.default1 = g_occa.occa49
                 LET g_qryparam.state  = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occa49
                 NEXT FIELD occa49
 
              WHEN INFIELD(occa50)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_oac'
                  LET g_qryparam.default1 = g_occa.occa50
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa50
                  NEXT FIELD occa50
 
              WHEN INFIELD(occa51)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_pmc'
                 LET g_qryparam.default1 = g_occa.occa51
                 LET g_qryparam.state  = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occa51
                 NEXT FIELD occa51
 
              WHEN INFIELD(occa66)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_pmc8'   
                 LET g_qryparam.default1 = g_occa.occa66
                 LET g_qryparam.state  = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occa66
                 NEXT FIELD occa66
              WHEN INFIELD(occa1005)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_tqb'
                   LET g_qryparam.state  = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO occa1005
                   NEXT FIELD occa1005
 
             #CHI-A80050 add --start--
             WHEN INFIELD(occud02)
                 CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occud02
                 NEXT FIELD occud02
              WHEN INFIELD(occud03)
                 CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occud03
                 NEXT FIELD occud03
              WHEN INFIELD(occud04)
                 CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occud04
                 NEXT FIELD occud04
              WHEN INFIELD(occud05)
                 CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occud05
                 NEXT FIELD occud05
              WHEN INFIELD(occud06)
                 CALL cl_dynamic_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occud06
                 NEXT FIELD occud06
             #CHI-A80050 add --end--

             WHEN INFIELD(occa1003)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_tqa'
                  LET g_qryparam.arg1 = '12'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa1003
                  NEXT FIELD occa1003
              WHEN INFIELD(occa1006)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.state  = "c"
                  LET g_qryparam.form ="q_tqa"
                  LET g_qryparam.arg1 ="19"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa1006  
                  NEXT FIELD occa1006  
              WHEN INFIELD(occa1007)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.state  = "c"
                  LET g_qryparam.form ="q_tqa"
                  LET g_qryparam.arg1 ="10"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa1007  
                  NEXT FIELD occa1007  
              WHEN INFIELD(occa1008)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state  = "c"
                  LET g_qryparam.form ="q_tqa"
                  LET g_qryparam.arg1 ="11"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa1008  
                  NEXT FIELD occa1008  
             WHEN INFIELD(occa1009)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_too2'      
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa1009
                  NEXT FIELD occa1009                     
             WHEN INFIELD(occa1010)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_top01'     
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa1010
                  NEXT FIELD occa1010
             WHEN INFIELD(occa1011)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_toq1'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa1011
                  NEXT FIELD occa1011
              WHEN INFIELD(occa1016)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_imd1'
                  LET g_qryparam.default1 = g_occa.occa1016
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa1016
                  NEXT FIELD occa1016
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
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('occauser', 'occagrup')       #TQC-C80037 cca改成occa
 
 
    LET g_sql="SELECT occano FROM occa_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, " ORDER BY occano"
 
    PREPARE i250_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i250_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i250_prepare
    LET g_sql= "SELECT COUNT(*) FROM occa_file WHERE ",g_wc CLIPPED
    PREPARE i250_precount FROM g_sql
    DECLARE i250_count CURSOR FOR i250_precount
 
END FUNCTION
 
FUNCTION i250_menu()
  DEFINE l_flowuser      LIKE type_file.chr1     #No.FUN-680137 VARCHAR(1)
  DEFINE l_creator       LIKE type_file.chr1     #No.FUN-680137 VARCHAR(1)
  DEFINE l_cmd           LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(30)
         l_imabdate      LIKE imab_file.imabdate,
         l_priv1         LIKE zy_file.zy03,       # 使用者執行權限
         l_priv2         LIKE zy_file.zy04,       # 使用者資料權限
         l_priv3         LIKE zy_file.zy05        # 使用部門資料權限
 
    LET l_flowuser = "N"
 
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            #傳入簽核模式時不應執行的 action 清單
            CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, 
                                       locale, void, confirm, unconfirm,easyflow_approval,
                                       invalid,carry_data,finance_info_maintenance
                                      ,input_custno,credit_line,credit_line,qry_carry_history")#TQC-B40201 add    #FUN-C30017 
                  RETURNING g_laststage
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN    #cl_prichk('A') THEN
                 CALL i250_a()
            END IF
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN    #cl_prichk('Q') THEN
                 CALL i250_q()
            END IF
 
        ON ACTION next
            CALL i250_fetch('N')
 
        ON ACTION previous
            CALL i250_fetch('P')
 
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN    #cl_prichk('U') THEN
               CALL i250_u()
            END IF
        ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
               CALL i250_copy()
            END IF
 
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN    #cl_prich3(g_occa.occauser,g_occa.occagrup,'X') THEN
               CALL i250_x()
            END IF
 
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN    #cl_prichk('R') THEN
               CALL i250_r()
            END IF
 
        #客戶財務信息維護
        ON ACTION finance_info_maintenance
           LET g_action_choice="finance_info_maintenance"
           IF cl_chk_act_auth() THEN   
              IF NOT cl_null(g_occa.occano) THEN 
                 CALL i250_1(g_occa.occano)
                 LET INT_FLAG = 0
              END IF 
           END IF   
 
         ON ACTION qry_carry_history
            LET g_action_choice = "qry_carry_history"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_occa.occa01) THEN  #No.FUN-830090
                  SELECT gev04 INTO g_gev04 FROM gev_file
                    WHERE gev01 = '4' AND gev02 = g_plant
                  IF NOT cl_null(g_gev04) THEN
                     LET l_cmd='aooq604 "',g_gev04,'" "4" "',g_prog,'" "',g_occa.occa01,'"'
                     CALL cl_cmdrun(l_cmd)
                  END IF
               ELSE
                  CALL cl_err('',-400,0)
               END IF
            END IF
 
      #@ON ACTION 信用額度設定
        ON ACTION credit_line
            LET g_action_choice="credit_line"
            IF cl_chk_act_auth() THEN    #cl_prichk('D') THEN
               CALL i250_d()
            END IF
 
         ON ACTION easyflow_approval            #MOD-4A0299
             LET g_action_choice="approval_status"   #MOD-560001
            IF cl_chk_act_auth() THEN
              #FUN-C20028 add str---
               SELECT * INTO g_occa.* FROM occa_file
                WHERE occano = g_occa.occano
               CALL i250_show()
              #FUN-C20028 add end---
               CALL i250_ef()                            #No:6686
               CALL i250_show()  #FUN-C20028 add
            END IF
 
         ON ACTION approval_status                 #MOD-4A0299
            LET g_action_choice="approval_status"
            IF cl_chk_act_auth() THEN
               IF aws_condition2() THEN
                    CALL aws_efstat2()        #MOD-560007
               END IF
            END IF
 
        ON ACTION confirm           
           LET g_action_choice="confirm"
           IF cl_chk_act_auth() THEN
               CALL i250_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                   CALL i250_y_upd()      #CALL 原確認的 update 段
               END IF
           END IF
            
        ON ACTION unconfirm
           LET g_action_choice="unconfirm"
           IF cl_chk_act_auth() THEN
              CALL i250_z()
           END IF
      #補料號
      ON ACTION input_custno
         LET g_action_choice="input_custno"
         IF cl_chk_act_auth() THEN
             LET g_errno=''
             CASE 
              WHEN g_occa.occa1004='2'
                    LET g_errno = 'axm-225'
                    #已拋轉，不可再異動!
#TQC-B40201 --begin--
              WHEN g_occa.occa1004 = 'S'
                  LET g_errno = 'apm-228'
#TQC-B40201 --end--         
              WHEN g_occa.occa00 = 'U' 
                    LET g_errno = 'aim-158'
                    #只在申請類別為"新增"時,可使用此Action!
              OTHERWISE
                   LET g_errno=''
             END CASE
             IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_occa.occano,g_errno,1)
             ELSE
                 LET g_input_custno = 'Y'
                 CALL i250_u()
                 LET g_input_custno = 'N'
             END IF
         END IF
 
      #@ON ACTION 資料拋轉
        ON ACTION carry_data
            LET g_action_choice="carry_data"
            IF cl_chk_act_auth() AND     #cl_prichk('7') AND
               NOT cl_null(g_occa.occa01) THEN
               LET l_priv1=g_priv1
               LET l_priv2=g_priv2
               LET l_priv3=g_priv3
               CALL i250_dbs(g_occa.*)  #No.FUN-7C0010
               LET g_priv1=l_priv1
               LET g_priv2=l_priv2
               LET g_priv3=l_priv3
            ELSE
                #客戶編為空,請補上客戶編號
                CALL cl_err(g_occa.occano,'axm-257','1')
            END IF
            SELECT * INTO g_occa.* FROM occa_file 
             WHERE occano = g_occa.occano
            CALL i250_show()
                   
        ON ACTION output
           LET g_action_choice="output"
           IF cl_chk_act_auth() THEN    #THEN cl_prichk('O')
              CALL i250_out()
           END IF
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          #圖形顯示
           CALL cl_set_combo_lang("occa55")         #MOD-970184 add
           CALL i250_show_pic()
           CALL cl_show_fld_cont()                  #FUN-590083
 
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON ACTION related_document
            LET g_action_choice="related_document"
            IF cl_chk_act_auth() THEN
               IF g_occa.occano IS NOT NULL THEN
                  LET g_doc.column1 = "occano"
                  LET g_doc.value1 = g_occa.occano
                  CALL cl_doc()
               END IF
            END IF
 
        ON ACTION jump
            CALL i250_fetch('/')
 
        ON ACTION first
            CALL i250_fetch('F')
 
        ON ACTION last
            CALL i250_fetch('L')
 
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
                 CALL i250_y_upd()      #CALL 原確認的 update 段
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
                             CALL i250_q()
                             #設定簽核功能及哪些 action 在簽核狀態時是不可被>
                             CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail,
                                   query, locale, void, confirm,unconfirm,easyflow_approval,
                                   invalid,carry_data,finance_info_maintenance
                                  ,input_custno,credit_line,credit_line,qry_carry_history")#TQC-B40201 add    #FUN-C30017 
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
                      LET g_occa.occa1004 = 'R'
                      DISPLAY BY NAME g_occa.occa1004
                   END IF
                   IF cl_confirm('aws-081') THEN
                      IF aws_efapp_getnextforminfo() THEN
                          LET l_flowuser = 'N'
                          LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                          IF NOT cl_null(g_argv1) THEN
                                CALL i250_q()
                                #設定簽核功能及哪些 action 在簽核狀態時是不可被>
                                CALL aws_efapp_flowaction("insert, modify, delete, reproduce, 
                                    detail, query, locale, void, confirm,unconfirm,easyflow_approval,
                                    invalid,carry_data,finance_info_maintenance
                                   ,input_custno,credit_line,credit_line,qry_carry_history") #TQC-B40201 add #FUN-C30017
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
 
#END FUN-580158
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE 		
            LET g_action_choice = "exit"
            EXIT MENU
 
      &include "qry_string.4gl"
    END MENU
    CLOSE i250_cs
END FUNCTION
 
 
FUNCTION i250_a()
    DEFINE li_result LIKE type_file.num5      #No.FUN-680137 SMALLINT              
 
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM
    LET g_occa_ct.*=g_occa.*
    INITIALIZE g_occa.* TO NULL
    LET g_occa.occa00   ='I' #新增
    LET g_occa.occa1004 ='0' #0:開立
    LET g_occa.occa10   ='N' #不需簽核
    LET g_occa.occa1027 ='N' 
    LET g_occa.occa05   ='1'
    LET g_occa.occa06   ='1'
    LET g_occa.occa08   ='1' 
    LET g_occa.occa62   ='N'
    LET g_occa.occa34   =' '
    LET g_occa.occa66   =' '   
    LET g_occa.occa37   ='N'
    LET g_occa.occa40   ='Y'
    LET g_occa.occa56   ='N'    
    LET g_occa.occa57   ='N'    
    LET g_occa.occa63   =0
    LET g_occa.occa64   =0
    LET g_occa.occa31   ='N'    
    LET g_occa.occa65   ='N'    
    LET g_occa.occauser = g_user
    LET g_occa.occaoriu = g_user #FUN-980030
    LET g_occa.occaorig = g_grup #FUN-980030
    LET g_occa.occagrup = g_grup               #使用者所屬群
    LET g_occa.occadate = g_today
    LET g_occa.occaacti = 'Y'
    LET g_occa_t.*=g_occa.*
    LET g_occa01_t = NULL
    LET g_occano_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i250_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
           INITIALIZE g_occa.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF g_occa.occano IS NULL THEN                # KEY 不可空白
           CONTINUE WHILE
        END IF
 
        BEGIN WORK 
        CALL s_auto_assign_no("axm",g_occa.occano,g_occa.occadate,"09","occa_file","occano","","","") RETURNING li_result,g_occa.occano
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_occa.occano
 
        INSERT INTO occa_file VALUES(g_occa.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","occa_file",g_occa.occano,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            ROLLBACK WORK    
            CONTINUE WHILE
        ELSE
            IF SQLCA.sqlerrd[3]<=0 THEN
               CALL cl_err3("ins","occa_file",g_occa.occano,"",'lib-028',"","",1)  #No.FUN-660167
               ROLLBACK WORK    
               CONTINUE WHILE
            END IF
            LET g_occa_t.* = g_occa.*                # 保存上筆資料
            SELECT occano INTO g_occa.occano FROM occa_file
                WHERE occano = g_occa.occano
 
        END IF

        IF g_occa.occa00 = 'U' THEN   #CHI-CB0017 add
           CALL i250_copy_refdoc()    #CHI-CB0017 add
        END IF                        #CHI-CB0017 add

        COMMIT WORK
        CALL cl_err("INSERT occa_file","abm-019",0) #執行成功！
        #TQC-BA0104--begin
        IF g_oay.oayconf='Y' THEN 
           CALL i250_y_chk()         
           IF g_success = "Y" THEN
               CALL i250_y_upd()      
           END IF
        END IF 
        IF g_oay.oayprnt='Y' THEN 
           CALL i250_out()
        END IF    
        #TQC-BA0104--end          
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i250_i(p_cmd)
   DEFINE p_cmd         LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_msg         LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(40)
          l_n           LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE li_result     LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_occano      LIKE occa_file.occano
   DEFINE l_occacti     LIKE occ_file.occacti  #TQC-740090
   DEFINE l_occ02       LIKE occ_file.occ02    #TQC-740090
   DEFINE l_count       LIKE type_file.num5    #FUN-A80073 
   DEFINE l_occa11      STRING #CHI-A80050 add
   DEFINE l_occa02      LIKE occa_file.occa02  #MOD-B90049
 
   LET g_on_change = TRUE   #FUN-590083
 
    INPUT BY NAME g_occa.occaoriu,g_occa.occaorig,
          g_occa.occa00,g_occa.occano,g_occa.occa01,g_occa.occa02,g_occa.occa18,g_occa.occa19, 
         #g_occa.occa1001,g_occa.occa1002,g_occa.occa11,g_occa.occa37,g_occa.occa28,g_occa.occa34,   #MOD-CC0094 mark
          g_occa.occa11,g_occa.occa37,g_occa.occa28,g_occa.occa34,                                   #MOD-CC0094 add 
          g_occa.occa66,g_occa.occa1005,   
 
          g_occa.occa1004,g_occa.occa06,g_occa.occa09,  g_occa.occa07,  g_occa.occa03, g_occa.occa04,
          g_occa.occa56,  g_occa.occa57,g_occa.occa31,g_occa.occa65,  
 
          g_occa.occa22,  g_occa.occa21,  g_occa.occa20, #g_occa.occa35, #CHI-A80050 mark occa35
         #g_occa.occa231, g_occa.occa232, g_occa.occa233, #CHI-A80050 mark
         #g_occa.occa241, g_occa.occa242, g_occa.occa243, #CHI-A80050 mark
 
          g_occa.occa261, g_occa.occa262, g_occa.occa263, g_occa.occa271,g_occa.occa272,
          g_occa.occa29,  g_occa.occa30,  g_occa.occa292, g_occa.occa302,

          g_occa.occa35, #CHI-A80050 add
          g_occa.occa231, g_occa.occa232, g_occa.occa233, #CHI-A80050 add
          g_occa.occa241, g_occa.occa242, g_occa.occa243, #CHI-A80050 add
 
          g_occa.occa40,  g_occa.occa38,  g_occa.occa39,
 
          g_occa.occauser,g_occa.occagrup,g_occa.occamodu,g_occa.occadate,g_occa.occaacti,
 
          g_occa.occa42,  g_occa.occa41,  g_occa.occa08,  g_occa.occa44, g_occa.occa45,
          g_occa.occa68,  g_occa.occa69,  #FUN-B30044add occa68,occa69   
          g_occa.occa67,  g_occa.occa43,  g_occa.occa55,  g_occa.occa47,
          g_occa.occa48,  g_occa.occa49,  g_occa.occa50,
 
          g_occa.occa46,  g_occa.occa53,  g_occa.occa32,g_occa.occa51,  g_occa.occa52, 
          g_occa.occa701, g_occa.occa702, g_occa.occa703, g_occa.occa704,
 
          g_occa.occa12,  g_occa.occa13,  g_occa.occa14,  g_occa.occa15, g_occa.occa05,
 
          g_occa.occa1003,g_occa.occa1006,g_occa.occa1007,g_occa.occa1008,g_occa.occa1009,
          g_occa.occa1010,g_occa.occa1011,g_occa.occa1012,g_occa.occa1013,g_occa.occa1014,
          g_occa.occa1015,g_occa.occa1016,g_occa.occa1027,
          g_occa.occaud01,g_occa.occaud02,g_occa.occaud03,g_occa.occaud04,
          g_occa.occaud05,g_occa.occaud06,g_occa.occaud07,g_occa.occaud08,
          g_occa.occaud09,g_occa.occaud10,g_occa.occaud11,g_occa.occaud12,
          g_occa.occaud13,g_occa.occaud14,g_occa.occaud15 
 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i250_set_entry(p_cmd)
            CALL i250_set_no_entry(p_cmd)
            CALL i250_set_no_required(p_cmd)
            CALL i250_set_required(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD occa00
            IF cl_null(g_occa.occa00) THEN
                NEXT FIELD occa00
            END IF
            CALL i250_set_entry(p_cmd)
            CALL i250_set_no_entry(p_cmd)
            CALL i250_set_no_required(p_cmd)
            CALL i250_set_required(p_cmd)
 
        #只要申請類別(I:新增 U:修改)有變,客戶編號occa01就應重key
        ON CHANGE occa00
            LET g_occa.occa01 = NULL
            LET g_occa.occa02 = NULL
            LET g_occa.occa18 = NULL
            LET g_occa.occa19 = NULL
            LET g_occa_t.occa01 = NULL
            LET g_occa_t.occa02 = NULL
            LET g_occa_t.occa18 = NULL
            LET g_occa_t.occa19 = NULL
            DISPLAY BY NAME g_occa.occa01,g_occa.occa02,g_occa.occa18,g_occa.occa19
        AFTER FIELD occano
          IF NOT cl_null(g_occa.occano) THEN
            #FUN-B50026 mark
            #LET l_n = 0 
            #SELECT COUNT(*) INTO l_n
            #  FROM occa_file 
            # WHERE occano=g_occa.occano
            #IF l_n > 0 THEN
            #   CALL cl_err('sel occa:','-239',0)
            #   NEXT FIELD occano
            #END IF
            #FUN-B50026 mark--end
             LET g_t1=s_get_doc_no(g_occa.occano)
  	    #CALL s_check_no('axm',g_occa.occano,"","09","occa_file","occano","") RETURNING li_result,g_occa.occano 
  	     CALL s_check_no('axm',g_occa.occano,g_occa_t.occano,"09","occa_file","occano","") RETURNING li_result,g_occa.occano   #FUN-B50026 mod
             IF (NOT li_result) THEN
                  LET g_occa.occano=g_occa_t.occano
                  NEXT FIELD occano
             END IF
             LET g_t1=g_occa.occano[1,g_doc_len]
             SELECT oayapr INTO g_occa.occa10
               FROM oay_file 
              WHERE oayslip = g_t1
             DISPLAY By NAME g_occa.occa10
          END IF
 
        BEFORE FIELD occa01
            IF g_occa.occa00 = 'I' AND cl_null(g_occa.occa01) THEN #新增且申請客戶編號為空時,才CALL自動編號附程式
                IF g_aza.aza29 = 'Y' THEN
                  #CALL s_auno(g_occa.occa01,'2','') RETURNING g_occa.occa01,g_occa.occa02  #No.FUN-850100   #MOD-B90049 mark
#MOD-B90049 -- begin --
                   CALL s_auno(g_occa.occa01,'2','') RETURNING g_occa.occa01,l_occa02
                   IF cl_null(g_occa.occa02) THEN
                      LET g_occa.occa02 = l_occa02
                   END IF
#MOD-B90049 -- end --
                END IF
            END IF
            CALL i250_set_entry(p_cmd) #CHI-A80050 add
 
        AFTER FIELD occa01
            IF NOT cl_null(g_occa.occa01) THEN
               ###FUN-A80073 START ###
               SELECT COUNT(*) INTO l_count FROM lne_file 
                WHERE lne01 = g_occa.occa01
               IF (g_occa.occa00 = 'U' AND l_count > 0) THEN  #修改
                  CALL cl_err('','alm-h04',0)
                  NEXT FIELD occa01
                  RETURN
               END IF
               ###FUN-A80073 END ###
               #-----MOD-A80234---------
               #IF cl_null(g_occa_t.occa01) OR ( g_occa.occa01 != g_occa_t.occa01) THEN   
               IF p_cmd = "a" OR         
                 (p_cmd = "u" AND g_occa.occa01 != g_occa01_t) THEN
               #-----END MOD-A80234----- 
                  IF g_occa.occa00 = 'I' THEN #新增
                      SELECT count(*) INTO l_n FROM occ_file
                       WHERE occ01 = g_occa.occa01
                      IF l_n > 0 THEN
                         CALL cl_err(g_occa.occa01,-239,1) #FUN-7C0084 mod
                         LET g_occa.occa01 = g_occa_t.occa01
                         DISPLAY BY NAME g_occa.occa01
                         NEXT FIELD occa01
                      END IF
                      SELECT count(*) INTO l_n FROM occa_file
                       WHERE occa01 = g_occa.occa01
                         AND occa00 = 'I' #新增
                      IF l_n > 0 THEN
                         CALL cl_err(g_occa.occa01,-239,1) 
                         LET g_occa.occa01 = g_occa_t.occa01
                         DISPLAY BY NAME g_occa.occa01
                         NEXT FIELD occa01
                      END IF
                      CALL s_field_chk(g_occa.occa01,'4',g_plant,'occ01') RETURNING g_flag2
                      IF g_flag2 = '0' THEN
                         CALL cl_err(g_occa.occa01,'aoo-043',1)
                         LET g_occa.occa01 = g_occa_t.occa01
                         DISPLAY BY NAME g_occa.occa01
                         NEXT FIELD occa01
                      END IF
                      CALL i250_set_occa02('a')    #No.FUN-BB0049
                  ELSE
                      SELECT count(*) INTO l_n FROM occ_file
                       WHERE occ01 = g_occa.occa01
                      IF l_n <= 0 THEN
                         #無此客戶代號, 請重新輸入
                         CALL cl_err(g_occa.occa01,'anm-045',1)
                         LET g_occa.occa01 = g_occa_t.occa01
                         DISPLAY BY NAME g_occa.occa01
                         NEXT FIELD occa01
                      END IF
                      LET l_occano = NULL
                      SELECT occano INTO l_occano FROM occa_file
                       WHERE occa01 = g_occa.occa01
                         AND occa00 = 'U' #修改
                         AND occa1004 != '2' 
                         AND occaacti != 'N' #MOD-B40095 add
                      IF NOT cl_null(l_occano) THEN
                         #已存在一張相同客戶,但未拋轉的客戶申請單!
                         CALL cl_err(l_occano,'axm-227',1)
                         LET g_occa.occa01 = g_occa_t.occa01
                         DISPLAY BY NAME g_occa.occa01
                         NEXT FIELD occa01
                      END IF
                      
                      LET g_occa_t.occa00   = g_occa.occa00
                      LET g_occa_t.occano   = g_occa.occano
                      LET g_occa_t.occa011  = g_occa.occa011
                      LET g_occa_t.occa10   = g_occa.occa10
                      LET g_occa_t.occa1004 = g_occa.occa1004
                      LET g_occa_t.occaacti= g_occa.occaacti
                      LET g_occa_t.occauser= g_occa.occauser
                      LET g_occa_t.occagrup= g_occa.occagrup
                      LET g_occa_t.occamodu= g_occa.occamodu
                      LET g_occa_t.occadate= g_occa.occadate
                     #CHI-AC0001 mod --start--
                     #SELECT 'U','@1','@2',occ_file.* INTO g_occa.* FROM occ_file
                      SELECT 'U','@1','@2',
                             occ01,   occ02,   occ03,   occ04,   occ05,
                             occ06,   occ07,   occ08,   occ09,   occ10,
                             occ11,   occ12,   occ13,   occ14,   occ15,
                             occ16,   occ171,  occ172,  occ173,  occ174,   
                             occ175,  occ18,   occ19,   occ20,   occ21,    
                             occ22,   occ231,  occ232,  occ233,  occ241,   
                             occ242,  occ243,  occ261,  occ262,  occ263,   
                             occ271,  occ272,  occ273,  occ28,   occ29,    
                             occ292,  occ30,   occ302,  occ31,   occ32,    
                             occ33,   occ34,   occ35,   occ36,   occ37,    
                             occ38,   occ39,   occ39a,  occ40,   occ41,    
                             occ42,   occ43,   occ44,   occ45,   occ46,    
                             occ47,   occ48,   occ49,   occ50,   occ51,    
                             occ52,   occ53,   occ55,   occ56,   occ57,    
                             occ61,   occ62,   occ63,   occ631,  occ64,    
                             occ701,  occ702,  occ703,  occ704,  occacti,  
                             occuser, occgrup, occmodu, occdate, occ65,    
                            #occ1001, occ1002, occ1003, occ1004, occ1005,   #MOD-CC0094 mark
                             occ1003, occ1004, occ1005,                     #MOD-CC0094 add 
                             occ1006, occ1007, occ1008, occ1009, occ1010,  
                             occ1011, occ1012, occ1013, occ1014, occ1015,  
                             occ1016, occ1017, occ1018, occ1019, occ1020,  
                             occ1021, occ1022, occ1023, occ1024, occ1025,  
                             occ1026, occ1027, occ1028, occud01, occud02,  
                             occud03, occud04, occud05, occud06, occud07,  
                             occud08, occud09, occud10, occud11, occud12,  
                             occud13, occud14, occud15, occ66,   occ1029,  
                             occ67,   occoriu, occorig   
                        INTO g_occa.occa00,   g_occa.occano,   g_occa.occa011,   
                             g_occa.occa01,   g_occa.occa02,   g_occa.occa03,   g_occa.occa04,   g_occa.occa05,
                             g_occa.occa06,   g_occa.occa07,   g_occa.occa08,   g_occa.occa09,   g_occa.occa10,
                             g_occa.occa11,   g_occa.occa12,   g_occa.occa13,   g_occa.occa14,   g_occa.occa15,
                             g_occa.occa16,   g_occa.occa171,  g_occa.occa172,  g_occa.occa173,  g_occa.occa174,   
                             g_occa.occa175,  g_occa.occa18,   g_occa.occa19,   g_occa.occa20,   g_occa.occa21,    
                             g_occa.occa22,   g_occa.occa231,  g_occa.occa232,  g_occa.occa233,  g_occa.occa241,   
                             g_occa.occa242,  g_occa.occa243,  g_occa.occa261,  g_occa.occa262,  g_occa.occa263,   
                             g_occa.occa271,  g_occa.occa272,  g_occa.occa273,  g_occa.occa28,   g_occa.occa29,    
                             g_occa.occa292,  g_occa.occa30,   g_occa.occa302,  g_occa.occa31,   g_occa.occa32,    
                             g_occa.occa33,   g_occa.occa34,   g_occa.occa35,   g_occa.occa36,   g_occa.occa37,    
                             g_occa.occa38,   g_occa.occa39,   g_occa.occa39a,  g_occa.occa40,   g_occa.occa41,    
                             g_occa.occa42,   g_occa.occa43,   g_occa.occa44,   g_occa.occa45,   g_occa.occa46,    
                             g_occa.occa47,   g_occa.occa48,   g_occa.occa49,   g_occa.occa50,   g_occa.occa51,    
                             g_occa.occa52,   g_occa.occa53,   g_occa.occa55,   g_occa.occa56,   g_occa.occa57,    
                             g_occa.occa61,   g_occa.occa62,   g_occa.occa63,   g_occa.occa631,  g_occa.occa64,    
                             g_occa.occa701,  g_occa.occa702,  g_occa.occa703,  g_occa.occa704,  g_occa.occaacti,  
                             g_occa.occauser, g_occa.occagrup, g_occa.occamodu, g_occa.occadate, g_occa.occa65,    
                            #g_occa.occa1001, g_occa.occa1002, g_occa.occa1003, g_occa.occa1004, g_occa.occa1005,   #MOD-CC0094 mark
                             g_occa.occa1003, g_occa.occa1004, g_occa.occa1005,                                     #MOD-CC0094 add 
                             g_occa.occa1006, g_occa.occa1007, g_occa.occa1008, g_occa.occa1009, g_occa.occa1010,  
                             g_occa.occa1011, g_occa.occa1012, g_occa.occa1013, g_occa.occa1014, g_occa.occa1015,  
                             g_occa.occa1016, g_occa.occa1017, g_occa.occa1018, g_occa.occa1019, g_occa.occa1020,  
                             g_occa.occa1021, g_occa.occa1022, g_occa.occa1023, g_occa.occa1024, g_occa.occa1025,  
                             g_occa.occa1026, g_occa.occa1027, g_occa.occa1028, g_occa.occaud01, g_occa.occaud02,  
                             g_occa.occaud03, g_occa.occaud04, g_occa.occaud05, g_occa.occaud06, g_occa.occaud07,  
                             g_occa.occaud08, g_occa.occaud09, g_occa.occaud10, g_occa.occaud11, g_occa.occaud12,  
                             g_occa.occaud13, g_occa.occaud14, g_occa.occaud15, g_occa.occa66,   g_occa.occa1029,  
                             g_occa.occa67,   g_occa.occaoriu, g_occa.occaorig   
                        FROM occ_file
                     #CHI-AC0001 mod --end--
                       WHERE occ01 = g_occa.occa01
                      LET g_occa.occa00   = g_occa_t.occa00 
                      LET g_occa.occano   = g_occa_t.occano 
                      LET g_occa.occa011  = g_occa_t.occa011
                      LET g_occa.occa10   = g_occa_t.occa10
                      LET g_occa.occa1004 = g_occa_t.occa1004
                      LET g_occa.occaacti = g_occa_t.occaacti
                      LET g_occa.occauser = g_occa_t.occauser
                      LET g_occa.occagrup = g_occa_t.occagrup
                      LET g_occa.occamodu = g_occa_t.occamodu
                      LET g_occa.occadate = g_occa_t.occadate
                      CALL i250_show()
                  END IF
               END IF
              #IF p_cmd!='u' AND g_occa.occa00 = 'I' THEN                              #MOD-B90049 mark
               IF p_cmd!='u' AND g_occa.occa00 = 'I' AND cl_null(g_occa.occa02) THEN   #MOD-B90049
                  LET g_occa.occa02 = g_occa.occa01[1,8]
               END IF
               IF g_occa.occa06 = '1' THEN
                   LET g_occa.occa07=g_occa.occa01
                   LET g_occa.occa09=g_occa.occa01 
                  #CHI-A80050 mark --start--
                  #DISPLAY BY NAME g_occa.occa07,g_occa.occa09
                  #DISPLAY g_occa.occa02 TO FORMONLY.occa7_ds
                  #DISPLAY g_occa.occa02 TO FORMONLY.occa9_ds
                  #CHI-A80050 mark --end--
                  #CHI-A80050 add --start--
                  IF g_occa.occa07 = g_occa.occa01 THEN
                     DISPLAY g_occa.occa02 TO FORMONLY.occa7_ds
                  ELSE
                     SELECT occa02 INTO g_buf FROM occa_file
                      WHERE occa01 = g_occa.occa07
                     IF STATUS THEN LET g_buf = '' END IF
                     DISPLAY g_buf TO FORMONLY.occa7_ds
                  END IF
                  IF g_occa.occa09 = g_occa.occa01 THEN
                     DISPLAY g_occa.occa02 TO FORMONLY.occa9_ds
                  ELSE
                     SELECT occa02 INTO g_buf FROM occa_file
                      WHERE occa01 = g_occa.occa09
                     IF STATUS THEN LET g_buf = '' END IF
                     DISPLAY g_buf TO FORMONLY.occa9_ds
                  END IF
                  #CHI-A80050 add --end--
               END IF
               #CHI-A80050 add --start--
               IF g_occa.occa06 = '2' THEN
                  IF cl_null(g_occa.occa07) THEN
                     LET g_occa.occa07=g_occa.occa01
                  END IF
                  LET g_occa.occa1022=NULL
                  CALL cl_set_comp_entry("occa1022",FALSE)
                  LET g_occa.occa09=g_occa.occa01
                  DISPLAY g_occa.occa02 TO FORMONLY.occa9_ds
                  IF g_occa.occa07 = g_occa.occa01 THEN
                     DISPLAY g_occa.occa02 TO FORMONLY.occa7_ds
                  ELSE
                     SELECT occa02 INTO g_buf FROM occa_file
                       WHERE occa01 = g_occa.occa07
                     IF STATUS THEN LET g_buf = '' END IF
                     DISPLAY g_buf TO FORMONLY.occa7_ds
                  END IF
               END IF
               IF g_occa.occa06='3' THEN
                  IF cl_null(g_occa.occa09) THEN
                     LET g_occa.occa09=g_occa.occa01
                  END IF
                  LET g_occa.occa07=g_occa.occa01
                  DISPLAY g_occa.occa02 TO FORMONLY.occa7_ds
                  IF g_occa.occa09 = g_occa.occa01 THEN
                     DISPLAY g_occa.occa02 TO FORMONLY.occa9_ds
                  ELSE
                     SELECT occa02 INTO g_buf FROM occa_file
                       WHERE occa01 = g_occa.occa09
                     IF STATUS THEN LET g_buf = '' END IF
                     DISPLAY g_buf TO FORMONLY.occa9_ds
                  END IF
               END IF
               IF g_occa.occa06='4' THEN
                  IF cl_null(g_occa.occa09) THEN
                     LET g_occa.occa09=g_occa.occa01
                  END IF
                  LET g_occa.occa1022=' '
                  CALL cl_set_comp_entry("occa1022",FALSE)
                  IF g_occa.occa09 = g_occa.occa01 THEN
                     DISPLAY g_occa.occa02 TO FORMONLY.occa9_ds
                  ELSE
                     SELECT occa02 INTO g_buf FROM occa_file
                       WHERE occa01 = g_occa.occa09
                     IF STATUS THEN LET g_buf = '' END IF
                     DISPLAY g_buf TO FORMONLY.occa9_ds
                  END IF
               END IF               
               #CHI-A80050 add --end--
               #CHI-A80050 mark --start--
               #IF cl_null(g_occa.occa09) THEN 
               #   LET g_occa.occa09 = g_occa.occa01             
               #END IF
               #LET g_occa.occa07 = g_occa.occa01             
               #IF cl_null(g_occa.occa1022) THEN
               #   LET g_occa.occa1022 = g_occa.occa01             
               #END IF
               #CHI-A80050 mark --end--
#MOD-B80131 -- begin --
               IF g_input_custno = 'Y' AND cl_null(g_occa.occa33) THEN
                  LET g_occa.occa33 = g_occa.occa01
                  DISPLAY BY NAME g_occa.occa33
               END IF
#MOD-B80131 -- end --
               LET g_occa.occa1022 = g_occa.occa01 #CHI-A80050 add
               DISPLAY BY NAME g_occa.occa02,g_occa.occa09,g_occa.occa07
               IF cl_null(g_occa.occa02) THEN
                  LET g_occa.occa02 = ''
                  DISPLAY BY NAME g_occa.occa02
               END IF
            ELSE                             
             IF g_occa.occa00<>'I' THEN
               CALL cl_err('',-400,0)       
               DISPLAY BY NAME g_occa.occa01 
               NEXT FIELD occa01             
             END IF 
            END IF
            CALL i250_set_no_entry(p_cmd) #CHI-A80050 add
		
	AFTER FIELD occa02
            IF NOT cl_null(g_occa.occa02) THEN
               LET l_n =0
               SELECT count(*) INTO l_n FROM occa_file
                WHERE occa02 = g_occa.occa02 AND occa01 != g_occa.occa01
               #資料重複,請檢查客戶簡稱欄位資料
               IF l_n > 0 THEN CALL cl_err(g_occa.occa02,'axm-205',0) END IF
               IF cl_null(g_occa.occa18) THEN
                  LET g_occa.occa18=g_occa.occa02
                  DISPLAY BY NAME g_occa.occa18
                END IF
            ELSE
               LET g_occa.occa02 = NULL
               NEXT FIELD occa02
            END IF
 
	AFTER FIELD occa03
            IF NOT cl_null(g_occa.occa03) THEN
                SELECT oca02 INTO g_buf FROM oca_file  #MOD-4B0240
                WHERE oca01=g_occa.occa03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","oca_file",g_occa.occa03,"",STATUS,"","select oca",1)  #No.FUN-660167
                  NEXT FIELD occa03
               END IF
               DISPLAY g_buf TO FORMONLY.oca02  
               CALL s_field_chk(g_occa.occa03,'4',g_plant,'occ03') RETURNING g_flag2
               IF g_flag2 = '0' THEN
                  CALL cl_err(g_occa.occa03,'aoo-043',1)
                  LET g_occa.occa03 = g_occa_t.occa03
                  DISPLAY BY NAME g_occa.occa03
                  NEXT FIELD occa03
               END IF
            ELSE                               
               DISPLAY ' ' TO FORMONLY.oca02   
            END IF

         #CHI-A80050 add --start--
         AFTER FIELD occa34
            IF NOT cl_null(g_occa.occa34) THEN
                CALL i250_occa34('d')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_occa.occa34,g_errno,0)
                   LET g_occa.occa34 = g_occa_t.occa34
                   DISPLAY BY NAME g_occa.occa34
                   NEXT FIELD occa34
                END IF
            END IF
           
         AFTER FIELD occa08
           IF NOT cl_null(g_occa.occa08) THEN 
              LET l_count = 0 
              SELECT COUNT(*) INTO l_count FROM oom_file
               WHERE oom03 = g_occa.occa08
              IF l_count = 0 THEN 
                 CALL cl_err('','axr-128',0)
                 NEXT FIELD occa08
              END IF 
           END IF 
         #CHI-A80050 add --end--

     #MOD-CC0094 -- mark start --
     #AFTER FIELD occa1001
     #      IF NOT cl_null(g_occa.occa1001) THEN
     #         IF g_occa.occa1001 > g_occa.occa1002 THEN
     #            CALL cl_err(g_occa.occa1001,'atm-061',0)
     #            NEXT FIELD occa1001
     #         END IF
     #      END IF
 
     #AFTER FIELD occa1002
     #      IF NOT cl_null(g_occa.occa1002) THEN
     #         IF g_occa.occa1002 < g_occa.occa1001 THEN
     #            CALL cl_err(g_occa.occa1002,'atm-061',0)
     #            NEXT FIELD occa1002
     #         END IF
     #      END IF
     #MOD-CC0094 -- mark end --               

      AFTER FIELD occa1003
            IF NOT cl_null(g_occa.occa1003) THEN
               CALL i250_occa1003('d')
               IF NOT cl_null(g_errno) THEN                                     
                  CALL cl_err(g_occa.occa1003,g_errno,0)                            
                  LET g_occa.occa1003 = g_occa_t.occa1003                               
                  DISPLAY BY NAME g_occa.occa1003                                   
                  NEXT FIELD occa1003                                              
               END IF                    
            END IF

        AFTER FIELD occa1006
           IF NOT cl_null(g_occa.occa1006) THEN
              CALL i250_occa1006('d')
              IF NOT cl_null(g_errno) THEN                                     
                 CALL cl_err(g_occa.occa1006,g_errno,0)                          
                 LET g_occa.occa1006 = g_occa_t.occa1006                           
                 DISPLAY BY NAME g_occa.occa1006                               
                 NEXT FIELD occa1006                                          
              END IF               
            END IF
 
        AFTER FIELD occa1007
           IF NOT cl_null(g_occa.occa1007) THEN
              CALL i250_occa1007('d')
              IF NOT cl_null(g_errno) THEN                                     
                 CALL cl_err(g_occa.occa1007,g_errno,0)                          
                 LET g_occa.occa1007 = g_occa_t.occa1007                           
                 DISPLAY BY NAME g_occa.occa1007                               
                 NEXT FIELD occa1007                                          
              END IF               
            END IF
 
        AFTER FIELD occa1008
           IF NOT cl_null(g_occa.occa1008) THEN
              CALL i250_occa1008('d')
              IF NOT cl_null(g_errno) THEN                                     
                 CALL cl_err(g_occa.occa1008,g_errno,0)                          
                 LET g_occa.occa1008 = g_occa_t.occa1008                           
                 DISPLAY BY NAME g_occa.occa1008                               
                 NEXT FIELD occa1008                                          
              END IF               
            END IF
 
        AFTER FIELD occa1009
           IF NOT cl_null(g_occa.occa1009) THEN
              CALL i250_occa1009('d')
              IF NOT cl_null(g_errno) THEN                                     
                 CALL cl_err(g_occa.occa1009,g_errno,0)                          
                 LET g_occa.occa1009 = g_occa_t.occa1009                           
                 DISPLAY BY NAME g_occa.occa1009                               
                 NEXT FIELD occa1009                                          
              END IF               
            END IF
 
        AFTER FIELD occa1010
           IF NOT cl_null(g_occa.occa1010) THEN
              CALL i250_occa1010('d')
              IF NOT cl_null(g_errno) THEN                                     
                 CALL cl_err(g_occa.occa1010,g_errno,0)                          
                 LET g_occa.occa1010 = g_occa_t.occa1010                           
                 DISPLAY BY NAME g_occa.occa1010                               
                 NEXT FIELD occa1010                                          
              END IF               
            END IF
 
        AFTER FIELD occa1011
           IF NOT cl_null(g_occa.occa1011) THEN
              CALL i250_occa1011('d')
              IF NOT cl_null(g_errno) THEN                                     
                 CALL cl_err(g_occa.occa1011,g_errno,0)                          
                 LET g_occa.occa1011 = g_occa_t.occa1011                           
                 DISPLAY BY NAME g_occa.occa1011                               
                 NEXT FIELD occa1011                                          
              END IF               
            END IF
 
        AFTER FIELD occa1016
	      IF NOT cl_null(g_occa.occa1016) THEN 
                 CALL i250_occa1016('d')
	         IF NOT cl_null(g_errno) THEN
	            CALL cl_err('',g_errno,0) 
                    NEXT FIELD occa1016
                 END IF
	      END IF

	BEFORE FIELD occa06
            CALL i250_set_entry(p_cmd)
            CALL i250_set_no_required(p_cmd)
 
	AFTER FIELD occa06
            IF NOT cl_null(g_occa.occa06) THEN
                IF g_occa.occa06 NOT MATCHES '[1234]' THEN    
                    NEXT FIELD occa06
                END IF
                IF g_occa.occa06 = '1' THEN
                    LET g_occa.occa07=g_occa.occa01
                    LET g_occa.occa09=g_occa.occa01 
                    DISPLAY BY NAME g_occa.occa07,g_occa.occa09
                   #DISPLAY g_occa.occa02 TO FORMONLY.occa7_ds #CHI-A80050 mark
                   #DISPLAY g_occa.occa02 TO FORMONLY.occa9_ds #CHI-A80050 mark
                    #CHI-A80050 add --start--
                    IF g_occa.occa07 = g_occa.occa01 THEN
                       DISPLAY g_occa.occa02 TO FORMONLY.occa7_ds
                    ELSE
                       SELECT occa02 INTO g_buf FROM occa_file
                         WHERE occa01 = g_occa.occa07
                       IF STATUS THEN LET g_buf = '' END IF
                       DISPLAY g_buf TO FORMONLY.occa7_ds
                    END IF
                    IF g_occa.occa09 = g_occa.occa01 THEN
                       DISPLAY g_occa.occa02 TO FORMONLY.occa9_ds
                    ELSE
                       SELECT occa02 INTO g_buf FROM occa_file
                         WHERE occa01 = g_occa.occa09
                       IF STATUS THEN LET g_buf = '' END IF
                       DISPLAY g_buf TO FORMONLY.occa9_ds
                    END IF
                    #CHI-A80050 add --end--
                END IF
                IF g_occa.occa06 = '2' THEN 
                    IF cl_null(g_occa.occa07) THEN 
                        LET g_occa.occa07=g_occa.occa01 
                    END IF
                    LET g_occa.occa1022=NULL   
                    CALL cl_set_comp_entry("occa1022",FALSE)  
                   #LET g_occa.occa09=' ' #CHI-A80050 mark
                    LET g_occa.occa09=g_occa.occa01   #TQC-770125 add
                    DISPLAY BY NAME g_occa.occa07,g_occa.occa09
                    DISPLAY g_occa.occa02 TO FORMONLY.occa9_ds  #TQC-770125  
                    #CHI-A80050 add --start--
                    IF g_occa.occa07 = g_occa.occa01 THEN
                       DISPLAY g_occa.occa02 TO FORMONLY.occa7_ds
                    ELSE
                       SELECT occa02 INTO g_buf FROM occa_file
                        WHERE occa01 = g_occa.occa07
                       IF STATUS THEN LET g_buf = '' END IF
                       DISPLAY g_buf TO FORMONLY.occa7_ds
                    END IF
                    #CHI-A80050 add --end--  
                END IF
                IF g_occa.occa06='3' THEN   
                    IF cl_null(g_occa.occa09) THEN 
                        LET g_occa.occa09=g_occa.occa01 
                    END IF
                   #LET g_occa.occa07=' ' #CHI-A80050 mark
                    LET g_occa.occa07=g_occa.occa01   #TQC-770125 add
                    DISPLAY BY NAME g_occa.occa07,g_occa.occa09
                    DISPLAY g_occa.occa02 TO FORMONLY.occa7_ds  #TQC-770125  
                    #CHI-A80050 add --start--
                    IF g_occa.occa09 = g_occa.occa01 THEN
                       DISPLAY g_occa.occa02 TO FORMONLY.occa9_ds
                    ELSE
                       SELECT occa02 INTO g_buf FROM occa_file
                         WHERE occa01 = g_occa.occa09
                       IF STATUS THEN LET g_buf = '' END IF
                       DISPLAY g_buf TO FORMONLY.occa9_ds
                    END IF
                    #CHI-A80050 add --end-- 
                END IF
                IF g_occa.occa06='4' THEN
                    IF cl_null(g_occa.occa09) THEN 
                        LET g_occa.occa09=g_occa.occa01 
                    END IF
                    LET g_occa.occa1022=' '
                    CALL cl_set_comp_entry("occa1022",FALSE)
                    DISPLAY BY NAME g_occa.occa07,g_occa.occa09
                   #DISPLAY g_occa.occa02 TO FORMONLY.occa9_ds #CHI-A80050 mark
                    #CHI-A80050 add --start--
                    IF g_occa.occa09 = g_occa.occa01 THEN
                       DISPLAY g_occa.occa02 TO FORMONLY.occa9_ds
                    ELSE
                       SELECT occa02 INTO g_buf FROM occa_file
                         WHERE occa01 = g_occa.occa09
                       IF STATUS THEN LET g_buf = '' END IF
                       DISPLAY g_buf TO FORMONLY.occa9_ds
                    END IF
                    #CHI-A80050 add --end--
                END IF
            END IF
            CALL i250_set_no_entry(p_cmd)
            CALL i250_set_required(p_cmd)
 
	AFTER FIELD occa09 
           IF (NOT cl_null(g_occa.occa09)) AND g_occa.occa09 != g_occa.occa01 THEN
               SELECT occacti,occ02 
                 INTO l_occacti,l_occ02 
                 FROM occ_file
                WHERE occ01 = g_occa.occa09
               IF SQLCA.sqlcode THEN
                   #無此客戶代號, 請重新輸入
                   CALL cl_err(g_occa.occa09,'anm-045',1) 
                   LET g_occa.occa09 = g_occa_t.occa09
                   DISPLAY BY NAME g_occa.occa09
                   NEXT FIELD occa09
               ELSE
                  IF l_occacti = 'N' THEN
                      #無效的客戶資料！
                      CALL cl_err(g_occa.occa09,'axr-604',1) 
                      LET g_occa.occa09 = g_occa_t.occa09
                      DISPLAY BY NAME g_occa.occa09
                      NEXT FIELD occa09
                  END IF
                  DISPLAY l_occ02 TO FORMONLY.occa9_ds
               END IF
           ELSE
               DISPLAY g_occa.occa02 TO FORMONLY.occa9_ds
           END IF
           
           
           
           
        AFTER FIELD occa07
           IF NOT cl_null(g_occa.occa07) AND g_occa.occa07 != g_occa.occa01 THEN
               SELECT occacti,occ02 
                 INTO l_occacti,l_occ02 
                 FROM occ_file
                WHERE occ01 = g_occa.occa07
               IF STATUS THEN
                   #無此客戶代號, 請重新輸入
                   CALL cl_err(g_occa.occa07,'anm-045',1) 
                   LET g_occa.occa07 = g_occa_t.occa07
                   DISPLAY BY NAME g_occa.occa07
                   NEXT FIELD occa07
               ELSE
                  IF l_occacti = 'N' THEN
                      #無效的客戶資料！
                      CALL cl_err(g_occa.occa07,'axr-604',1) 
                      LET g_occa.occa07 = g_occa_t.occa07
                      DISPLAY BY NAME g_occa.occa07
                      NEXT FIELD occa07
                  END IF
                  DISPLAY l_occ02 TO FORMONLY.occa7_ds
               END IF
           ELSE
               DISPLAY g_occa.occa02 TO FORMONLY.occa7_ds
           END IF
 
	AFTER FIELD occa04
           IF NOT cl_null(g_occa.occa04) THEN
              SELECT gen02 INTO g_buf FROM gen_file
               WHERE gen01=g_occa.occa04
              IF STATUS THEN
                 LET g_buf = ''
                 CALL cl_err3("sel","gen_file",g_occa.occa04,"",STATUS,"","select gen",1)  #No.FUN-660167
                 NEXT FIELD occa04
              END IF
              DISPLAY g_buf TO FORMONLY.gen02
           ELSE                               
              DISPLAY ' ' TO FORMONLY.gen02  
           END IF
					
	AFTER FIELD occa11
           IF NOT cl_null(g_occa.occa11) THEN
              IF cl_null(g_occa_t.occa11) OR (g_occa_t.occa11 <> g_occa.occa11) THEN  #MOD-590138  #TQC-770125 add cl_null()
                 SELECT count(*) INTO l_n FROM occa_file
	          WHERE occa11 = g_occa.occa11 AND occa01 != g_occa.occa01
	         IF l_n > 0 THEN
                    CALL cl_err('','axm-028',1) 
	         END IF
                 IF g_aza.aza21 = 'Y' AND g_aza.aza26='0' THEN  #CHI-A80050 add g_aza.aza26='0'
                    LET l_occa11= g_occa.occa11 CLIPPED #CHI-A80050 add
                   #IF NOT s_chkban(g_occa.occa11) THEN #CHI-A80050 mark
                    IF NOT s_chkban(g_occa.occa11) OR l_occa11.getLength() > 8   #CHI-A80050 長度不可>8
                       OR NOT cl_numchk(g_occa.occa11,8)  THEN                    #CHI-A80050 
                       CALL cl_err('chkban-occa11:','aoo-080',0)
                       NEXT FIELD occa11
                    END IF
                 END IF
              END IF  
           END IF
 
         
	AFTER FIELD occa20
           IF NOT cl_null(g_occa.occa20) THEN
              CALL i250_occa20('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD occa20
              END IF
           END IF
					
	AFTER FIELD occa21
           IF NOT cl_null(g_occa.occa21) THEN
              CALL i250_occa21('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD occa21
              END IF
              SELECT geb03 INTO g_occa.occa20 FROM geb_file
               WHERE geb01 = g_occa.occa21
              DISPLAY BY NAME g_occa.occa20
              CALL i250_occa20('a')
           END IF
	AFTER FIELD occa22
           IF NOT cl_null(g_occa.occa22) THEN
              CALL i250_occa22('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_occa.occa22,g_errno,0)
                 LET g_occa.occa22 = g_occa_t.occa22
                 DISPLAY BY NAME g_occa.occa22
                 DISPLAY ' ' TO occa21
                 DISPLAY ' ' TO occa20
                 DISPLAY ' ' TO occa21_desc
                 DISPLAY ' ' TO occa20_desc
                 NEXT FIELD occa22
              END IF
           END IF
 
        AFTER FIELD occa233
           IF cl_null(g_occa.occa241) THEN
              LET g_occa.occa241 = g_occa.occa231
              LET g_occa.occa242 = g_occa.occa232
              LET g_occa.occa243 = g_occa.occa233
              DISPLAY BY NAME g_occa.occa241,g_occa.occa242,g_occa.occa243
           END IF
 
#TQC-A10023 --begin--
       AFTER FIELD occa32
         IF NOT cl_null(g_occa.occa32) THEN
           IF g_occa.occa32 < 0 OR g_occa.occa32 >100 THEN
              CALL cl_err('','aec-002',0)
              NEXT FIELD CURRENT
           END IF  
         END IF 

       AFTER FIELD occa53
         IF NOT cl_null(g_occa.occa53) THEN
           IF g_occa.occa53 < 0 OR g_occa.occa53 >100 THEN
              CALL cl_err('','aec-002',0)
              NEXT FIELD CURRENT
           END IF
         END IF
#TQC-A10023 --end--

        AFTER FIELD occa38
           IF NOT cl_null(g_occa.occa38) THEN
              IF g_occa.occa38 < 1 OR g_occa.occa38 > 31 THEN
#                 CALL cl_err('','apy-000',0)    #CHI-B40058
                 CALL cl_err('','alm-729',0)     #CHI-B40058
                 NEXT FIELD occa38
              END IF
           END IF
 
        AFTER FIELD occa39
           IF NOT cl_null(g_occa.occa39) THEN
              IF g_occa.occa39 < 1 OR g_occa.occa39 > 31 THEN
#                 CALL cl_err('','apy-000',0)    #CHI-B40058
                 CALL cl_err('','alm-729',0)     #CHI-B40058
                 NEXT FIELD occa39
              END IF
           END IF
 
	AFTER FIELD occa40
           IF NOT cl_null(g_occa.occa40) THEN
              IF g_occa.occa40 NOT MATCHES '[YN]' THEN
                 NEXT FIELD occa40
              END IF
           END IF
 
        AFTER FIELD occa41
	      IF NOT cl_null(g_occa.occa41) THEN
                 CALL i250_occa41('a')
	         IF NOT cl_null(g_errno) THEN
	            CALL cl_err('',g_errno,0)
                    NEXT FIELD occa41
	         END IF
              END IF
 
        AFTER FIELD occa43
	   IF g_occa.occa06 MATCHES "[13]" THEN
              IF cl_null(g_occa.occa43) THEN
                 CALL cl_err('','axm-221',0)
                 NEXT FIELD occa43
              END IF
 
	      CALL i250_occa43('a')
	      IF NOT cl_null(g_errno) THEN
	         CALL cl_err('',g_errno,0)
                 NEXT FIELD occa43
	      END IF
	   END IF
 
        AFTER FIELD occa44
	      IF NOT cl_null(g_occa.occa44) THEN
	         CALL i250_occa44('a')
	         IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0) NEXT FIELD occa44
                 END IF
	      END IF
 
        AFTER FIELD occa45
	   IF g_occa.occa06 MATCHES "[13]" THEN
 	      IF NOT cl_null(g_occa.occa45) THEN   
	         CALL i250_occa45('a')
	         IF NOT cl_null(g_errno) THEN
	            CALL cl_err('',g_errno,0) NEXT FIELD occa45
	         END IF
	      END IF
	   END IF
	   
	   #No.FUN-B30044-Add--Begin--#
	   AFTER FIELD occa68
	   IF g_occa.occa06 MATCHES "[13]" THEN
 	      IF NOT cl_null(g_occa.occa68) THEN   
	         CALL i250_occa68('a')
	         IF NOT cl_null(g_errno) THEN
	            CALL cl_err('',g_errno,0) NEXT FIELD occa68
	         END IF
	      END IF
	   END IF
	   
	   AFTER FIELD occa69
	   IF g_occa.occa06 MATCHES "[13]" THEN
 	      IF NOT cl_null(g_occa.occa69) THEN   
	         CALL i250_occa69('a')
	         IF NOT cl_null(g_errno) THEN
	            CALL cl_err('',g_errno,0) NEXT FIELD occa69
	         END IF
	      END IF
	   END IF
	   #No.FUN-B30044-Add--End--#
        
        AFTER FIELD occa67
           IF NOT cl_null(g_occa.occa67) THEN
              IF NOT i250_occa67('a') THEN
                 NEXT FIELD occa67
              END IF
           ELSE
              DISPLAY NULL TO FORMONLY.ool02
           END IF
 
	AFTER FIELD occa42
           IF NOT cl_null(g_occa.occa42) THEN
              CALL i250_occa42('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD occa42
              END IF
           END IF
 
 
        AFTER FIELD occa47
           IF NOT cl_null(g_occa.occa47) THEN
              SELECT COUNT(*) INTO l_n FROM ged_file
               WHERE ged01 = g_occa.occa47
              IF l_n = 0 THEN
                 CALL cl_err('','axm-309',0)
                 NEXT FIELD occa47
              END IF
           END IF
           CALL i250_occa47('a') #FUN-990046           
 
        AFTER FIELD occa48
           IF NOT cl_null(g_occa.occa48) THEN
              SELECT oac01 FROM oac_file
               WHERE oac01 = g_occa.occa48
              IF STATUS THEN
                 CALL cl_err3("sel","oac_file",g_occa.occa48,"",STATUS,"","select oac",1)  
                 NEXT FIELD occa48
              END IF
           END IF
           CALL i250_occa48('a') #FUN-990046            
 
        AFTER FIELD occa49
           IF NOT cl_null(g_occa.occa49) THEN
              SELECT oac01 FROM oac_file
               WHERE oac01=g_occa.occa49
              IF STATUS THEN
                 CALL cl_err3("sel","oac_file",g_occa.occa49,"",STATUS,"","select oac",1)  
                 NEXT FIELD occa49
              END IF
           END IF
           CALL i250_occa49('a') #FUN-990046                                                                                        
       AFTER FIELD occa50                                                                                                           
          IF NOT cl_null(g_occa.occa50) THEN                                                                                        
              SELECT oac01 FROM oac_file                                                                                            
               WHERE oac01=g_occa.occa50                                                                                            
              IF STATUS THEN                                                                                                        
                 CALL cl_err3("sel","oac_file",g_occa.occa50,"",STATUS,"","select oac",1)                                           
                 NEXT FIELD occa50                                                                                                  
              END IF                                                                                                                
           END IF                                                                                                                   
           CALL i250_occa50('a')                                                                                                    
        AFTER FIELD occa51
           IF NOT cl_null(g_occa.occa51) THEN
              SELECT pmc03 INTO g_buf FROM pmc_file
               WHERE pmc01 = g_occa.occa51
              IF STATUS THEN
                 CALL cl_err3("sel","pmc_file",g_occa.occa51,"",STATUS,"","select pmc_file",1)  
                 NEXT FIELD occa51
              END IF
              DISPLAY g_buf TO pmc03
           END IF
 
        BEFORE FIELD occa55
           IF cl_null(g_occa.occa55) THEN
              LET g_occa.occa55 = '0' #中文
              DISPLAY BY NAME g_occa.occa55
           END IF
 
        AFTER FIELD occa56
           IF cl_null(g_occa.occa56) OR g_occa.occa56 NOT MATCHES '[YN]' THEN
              NEXT FIELD occa56
           END IF
 
        AFTER FIELD occa57
           IF cl_null(g_occa.occa57) OR g_occa.occa57 NOT MATCHES '[YN]' THEN
              NEXT FIELD occa57
           END IF
 
        AFTER FIELD occa65
           IF cl_null(g_occa.occa65) OR g_occa.occa65 NOT MATCHES '[YN]' THEN
              NEXT FIELD occa65
           END IF
 
        AFTER FIELD occa66
           IF NOT cl_null(g_occa.occa66) THEN
              SELECT pmc03 INTO g_buf FROM pmc_file 
               WHERE pmc01=g_occa.occa66 AND pmc14='6'   
              IF STATUS THEN
                 CALL cl_err3("sel","pmc_file",g_occa.occa66,"",STATUS,"","select pmc_file",1)  #No.FUN-660167
                 #NEXT FIELD occa51 #TQC-AB0088 mark
                  NEXT FIELD occa66 #TQC-AB0088 add
              END IF
              DISPLAY g_buf TO FORMONLY.pmc03_1
           ELSE                                 
              DISPLAY ' ' TO FORMONLY.pmc03_1   
           END IF
 
        AFTER FIELD occa1005
           IF NOT cl_null(g_occa.occa1005) THEN
              CALL i250_occa1005('d')
              IF NOT cl_null(g_errno) THEN                                     
                 CALL cl_err(g_occa.occa1005,g_errno,0)                          
                 LET g_occa.occa1005 = g_occa_t.occa1005                           
                 DISPLAY BY NAME g_occa.occa1005                               
                 NEXT FIELD occa1005                                          
              END IF               
              LET g_occa.occa1024=g_occa.occa1005
              LET g_occa.occa1025=g_occa.occa1005
           ELSE
              DISPLAY ' ' TO FORMONLY.qb02
           END IF
        AFTER FIELD occaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD occaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
       ON CHANGE occa02
          IF g_aza.aza44 = "Y" AND NOT cl_null(g_occa.occa01) THEN 
             IF g_zx14 = "Y" AND g_on_change THEN
                CALL p_itemname_update("occa_file","occa02",g_occa.occa01) #TQC-6C0060 
                CALL cl_show_fld_cont()   #TQC-6C0060 
             END IF
          END IF
 
         AFTER INPUT
            LET g_occa.occauser = s_get_data_owner("occa_file") #FUN-C10039
            LET g_occa.occagrup = s_get_data_group("occa_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF cl_null(g_occa.occa01) AND g_occa.occa00<>'I' THEN 
               DISPLAY BY NAME g_occa.occa01
               NEXT FIELD occa01
            END IF

            #-----MOD-A80234---------
            IF NOT cl_null(g_occa.occa01) THEN
               IF p_cmd = "a" OR         
                 (p_cmd = "u" AND g_occa.occa01 != g_occa01_t) THEN
                  IF g_occa.occa00 = 'I' THEN #新增
                      LET l_n = 0 
                      SELECT count(*) INTO l_n FROM occ_file
                       WHERE occ01 = g_occa.occa01
                      IF l_n > 0 THEN
                         CALL cl_err(g_occa.occa01,-239,1) 
                         LET g_occa.occa01 = ''
                         DISPLAY BY NAME g_occa.occa01
                         NEXT FIELD occa01
                      END IF
                      LET l_n = 0 
                      SELECT count(*) INTO l_n FROM occa_file
                       WHERE occa01 = g_occa.occa01
                         AND occa00 = 'I' #新增
                      IF l_n > 0 THEN
                         CALL cl_err(g_occa.occa01,-239,1) 
                         LET g_occa.occa01 = ''
                         DISPLAY BY NAME g_occa.occa01
                         NEXT FIELD occa01
                      END IF
                  ELSE
                      LET l_occano = NULL
                      SELECT occano INTO l_occano FROM occa_file
                       WHERE occa01 = g_occa.occa01
                         AND occa00 = 'U' #修改
                         AND occa1004 != '2' 
                         AND occaacti != 'N' #MOD-B40095 add
                      IF NOT cl_null(l_occano) THEN
                         #已存在一張相同客戶,但未拋轉的客戶申請單!
                         CALL cl_err(l_occano,'axm-227',1)
                         LET g_occa.occa01 = ''
                         DISPLAY BY NAME g_occa.occa01
                         NEXT FIELD occa01
                      END IF
                  END IF
               END IF
            END IF 
            #-----END MOD-A80234-----
 
       ON ACTION update_item
          IF g_aza.aza44 = "Y" AND NOT cl_null(g_occa.occa01) THEN 
             CALL GET_FLDBUF(occa02) RETURNING g_occa.occa02
             CALL p_itemname_update("occa_file","occa02",g_occa.occa01) #TQC-6C0060 
             LET g_on_change=FALSE
             CALL cl_show_fld_cont()   #TQC-6C0060 
          ELSE
             CALL cl_err(g_occa.occa02,"lib-151",1)
          END IF
 
        ON ACTION CONTROLP
           CASE
             WHEN INFIELD(occano) #申請單號
                  CALL q_oay( FALSE,TRUE,g_t1,'09','AXM') RETURNING g_t1   
                  LET g_occa.occano=g_t1               
                  DISPLAY BY NAME g_occa.occano
                  NEXT FIELD occano
 
             WHEN INFIELD(occa01) #客戶編號
                  IF g_occa.occa00='U' THEN
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = 'q_occ'
                      LET g_qryparam.default1 = g_occa.occa01
                      CALL cl_create_qry() RETURNING g_occa.occa01
                      DISPLAY BY NAME g_occa.occa01
                      NEXT FIELD occa01
                  END IF
             WHEN INFIELD(occa03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oca'
                 LET g_qryparam.default1 = g_occa.occa03
                 CALL cl_create_qry() RETURNING g_occa.occa03
                 DISPLAY BY NAME g_occa.occa03
                 NEXT FIELD occa03
             WHEN INFIELD(occa04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_gen'
                 LET g_qryparam.default1 = g_occa.occa04
                 CALL cl_create_qry() RETURNING g_occa.occa04
                 DISPLAY BY NAME g_occa.occa04
                 NEXT FIELD occa04
 
             WHEN INFIELD(occa09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_occ'    #TQC-740090 mod
                 LET g_qryparam.default1 = g_occa.occa09
                 CALL cl_create_qry() RETURNING g_occa.occa09
                 DISPLAY BY NAME g_occa.occa09
                 NEXT FIELD occa09

             #CHI-A80050 add --start--
             WHEN INFIELD(occa08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_occ081'
                 LET g_qryparam.default1 = g_occa.occa08
                 CALL cl_create_qry() RETURNING g_occa.occa08
                 DISPLAY BY NAME g_occa.occa08
                 NEXT FIELD occa08
             #CHI-A80050 add --end--    
 
             WHEN INFIELD(occa07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_occ'    #TQC-740090 mod
                 LET g_qryparam.default1 = g_occa.occa07
                 CALL cl_create_qry() RETURNING g_occa.occa07
                 DISPLAY BY NAME g_occa.occa07
                 NEXT FIELD occa07

             #CHI-A80050 add --start--
             WHEN INFIELD(occa34)
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form = 'q_occa34'   #MOD-B90068 mark
                  LET g_qryparam.form = 'q_occ34'    #MOD-B90068
                  LET g_qryparam.arg1 = g_occa.occa01
                  LET g_qryparam.default1 = g_occa.occa34
                  CALL cl_create_qry() RETURNING g_occa.occa34
                  DISPLAY BY NAME g_occa.occa34
                  NEXT FIELD occa34     
             #CHI-A80050 add --end--

             WHEN INFIELD(occa20)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_gea'
                 LET g_qryparam.default1 = g_occa.occa20
                 CALL cl_create_qry() RETURNING g_occa.occa20
                 DISPLAY BY NAME g_occa.occa20
                 NEXT FIELD occa20
             WHEN INFIELD(occa21)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_geb'
                 LET g_qryparam.default1 = g_occa.occa21
                 CALL cl_create_qry() RETURNING g_occa.occa21
                 DISPLAY BY NAME g_occa.occa21
                 NEXT FIELD occa21
             WHEN INFIELD(occa22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_geo'
                 LET g_qryparam.default1 = g_occa.occa22
                 CALL cl_create_qry() RETURNING g_occa.occa22
                 DISPLAY BY NAME g_occa.occa22
                 NEXT FIELD occa22
              WHEN INFIELD(occa41)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_gec'
                   LET g_qryparam.default1 = g_occa.occa41
                   LET g_qryparam.arg1 = '2'
                   CALL cl_create_qry() RETURNING g_occa.occa41
                   DISPLAY BY NAME g_occa.occa41
                   NEXT FIELD occa41
              WHEN INFIELD(occa47)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_ged'
                  LET g_qryparam.default1 = g_occa.occa47
                  CALL cl_create_qry() RETURNING g_occa.occa47
                  DISPLAY BY NAME g_occa.occa47
                  NEXT FIELD occa47
              WHEN INFIELD(occa03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oca'
                 LET g_qryparam.default1 = g_occa.occa03
                 CALL cl_create_qry() RETURNING g_occa.occa03
                 DISPLAY BY NAME g_occa.occa03
                 NEXT FIELD occa03
 
              WHEN INFIELD(occa43)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oab'
                 LET g_qryparam.default1 = g_occa.occa43
                 CALL cl_create_qry() RETURNING g_occa.occa43
                 DISPLAY BY NAME g_occa.occa43
                 NEXT FIELD occa43
 
              WHEN INFIELD(occa44)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oah'
                 LET g_qryparam.default1 = g_occa.occa44
                 CALL cl_create_qry() RETURNING g_occa.occa44
                 DISPLAY BY NAME g_occa.occa44
                 NEXT FIELD occa44
 
              WHEN INFIELD(occa45)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oag'
                 LET g_qryparam.default1 = g_occa.occa45
                 CALL cl_create_qry() RETURNING g_occa.occa45
                 DISPLAY BY NAME g_occa.occa45
                 NEXT FIELD occa45
             #FUN-B30044 add begin---------------------------    
              WHEN INFIELD(occa68)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oag'
                 LET g_qryparam.default1 = g_occa.occa68
                 CALL cl_create_qry() RETURNING g_occa.occa68
                 DISPLAY BY NAME g_occa.occa68
                 NEXT FIELD occa68
                 
              WHEN INFIELD(occa69)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oag'
                 LET g_qryparam.default1 = g_occa.occa69
                 CALL cl_create_qry() RETURNING g_occa.occa69
                 DISPLAY BY NAME g_occa.occa69
                 NEXT FIELD occa69 
             #FUN-B30044 add -end-----------------------------
 
              WHEN INFIELD(occa67)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_ool"
                   LET g_qryparam.default1 = g_occa.occa67
                   CALL cl_create_qry() RETURNING g_occa.occa67
                   DISPLAY BY NAME g_occa.occa67
                   NEXT FIELD occa67
 
# 加查詢明細資料
              WHEN INFIELD(occa42)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_azi'
                 LET g_qryparam.default1 = g_occa.occa42
                 CALL cl_create_qry() RETURNING g_occa.occa42
                 DISPLAY BY NAME g_occa.occa42
                 NEXT FIELD occa42
 
              WHEN INFIELD(occa48)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oac'
                 LET g_qryparam.default1 = g_occa.occa48
                 CALL cl_create_qry() RETURNING g_occa.occa48
                 DISPLAY BY NAME g_occa.occa48
                 NEXT FIELD occa48
 
              WHEN INFIELD(occa49)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oac'
                 LET g_qryparam.default1 = g_occa.occa49
                 CALL cl_create_qry() RETURNING g_occa.occa49
                 DISPLAY BY NAME g_occa.occa49
                 NEXT FIELD occa49
 
              WHEN INFIELD(occa50)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_oac'
                  LET g_qryparam.default1 = g_occa.occa50
                  CALL cl_create_qry() RETURNING g_occa.occa50
                  DISPLAY BY NAME g_occa.occa50
                  NEXT FIELD occa50
 
              WHEN INFIELD(occa51)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_pmc'
                 LET g_qryparam.default1 = g_occa.occa51
                 CALL cl_create_qry() RETURNING g_occa.occa51
                 DISPLAY BY NAME g_occa.occa51
                 NEXT FIELD occa51
 
              WHEN INFIELD(occa66)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_pmc8'   
                 LET g_qryparam.default1 = g_occa.occa66
                 CALL cl_create_qry() RETURNING g_occa.occa66
                 DISPLAY BY NAME g_occa.occa66
                 NEXT FIELD occa66
             WHEN INFIELD(occa1005)      
                  CALL cl_init_qry_var() 
                  LET g_qryparam.form = 'q_tqb'
                  LET g_qryparam.default1 = g_occa.occa1005
                  CALL cl_create_qry() RETURNING g_occa.occa1005
                  DISPLAY BY NAME g_occa.occa1005
                  NEXT FIELD occa1005
             WHEN INFIELD(occa1003)      
                  CALL cl_init_qry_var() 
                  LET g_qryparam.form = 'q_tqa'
                  LET g_qryparam.arg1 = '12'
                  LET g_qryparam.default1 = g_occa.occa1003 
                  CALL cl_create_qry() RETURNING g_occa.occa1003 
                  DISPLAY BY NAME g_occa.occa1003 
                  NEXT FIELD occa1003
             WHEN INFIELD(occa1006)      
                  CALL cl_init_qry_var() 
                  LET g_qryparam.form = 'q_tqa'
                  LET g_qryparam.arg1 = '19'
                  LET g_qryparam.default1 = g_occa.occa1006
                  CALL cl_create_qry() RETURNING g_occa.occa1006
                  DISPLAY BY NAME g_occa.occa1006
                  NEXT FIELD occa1006
             WHEN INFIELD(occa1007)      
                  CALL cl_init_qry_var() 
                  LET g_qryparam.form = 'q_tqa'
                  LET g_qryparam.arg1 = '10' 
                  LET g_qryparam.default1 = g_occa.occa1007
                  CALL cl_create_qry() RETURNING g_occa.occa1007
                  DISPLAY BY NAME g_occa.occa1007
                  NEXT FIELD occa1007    
             WHEN INFIELD(occa1008)      
                  CALL cl_init_qry_var() 
                  LET g_qryparam.form = 'q_tqa'
                  LET g_qryparam.arg1 = '11' 
                  LET g_qryparam.default1 = g_occa.occa1008
                  CALL cl_create_qry() RETURNING g_occa.occa1008
                  DISPLAY BY NAME g_occa.occa1008 
                  NEXT FIELD occa1008
             WHEN INFIELD(occa1009)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_too2'
                 LET g_qryparam.default1 = g_occa.occa1009
                 CALL cl_create_qry() RETURNING g_occa.occa1009
                 DISPLAY BY NAME g_occa.occa1009
                 NEXT FIELD occa1009
             WHEN INFIELD(occa1010)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_top01'     
                 LET g_qryparam.arg1 = g_occa.occa1009
                 LET g_qryparam.default1 = g_occa.occa1010
                 CALL cl_create_qry() RETURNING g_occa.occa1010
                 DISPLAY BY NAME g_occa.occa1010
                 NEXT FIELD occa1010
             WHEN INFIELD(occa1011)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_toq1'
                 LET g_qryparam.arg1 = g_occa.occa1010
                 LET g_qryparam.default1 = g_occa.occa1011
                 CALL cl_create_qry() RETURNING g_occa.occa1011
                 DISPLAY BY NAME g_occa.occa1011
                 NEXT FIELD occa1011          
             WHEN INFIELD(occa1016)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_imd1'
                 LET g_qryparam.default1 = g_occa.occa1016
                 CALL cl_create_qry() RETURNING g_occa.occa1016
                 DISPLAY BY NAME g_occa.occa1016
                 NEXT FIELD occa1016
             #CHI-A80050 add --start--
             WHEN INFIELD(occaud02)
                CALL cl_dynamic_qry() RETURNING g_occa.occaud02
                DISPLAY BY NAME g_occa.occaud02
                NEXT FIELD occaud02
             WHEN INFIELD(occaud03)
                CALL cl_dynamic_qry() RETURNING g_occa.occaud03
                DISPLAY BY NAME g_occa.occaud03
                NEXT FIELD occaud03
             WHEN INFIELD(occaud04)
                CALL cl_dynamic_qry() RETURNING g_occa.occaud04
                DISPLAY BY NAME g_occa.occaud04
                NEXT FIELD occaud04
             WHEN INFIELD(occaud05)
                CALL cl_dynamic_qry() RETURNING g_occa.occaud05
                DISPLAY BY NAME g_occa.occaud05
                NEXT FIELD occaud05
             WHEN INFIELD(occaud06)
                CALL cl_dynamic_qry() RETURNING g_occa.occaud06
                DISPLAY BY NAME g_occa.occaud06
                NEXT FIELD occaud06
             #CHI-A80050 add --end--
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION auto_getcustno
          IF g_occa.occa00 = 'I' AND cl_null(g_occa.occa01) THEN #新增且申請客戶編號為空時,才CALL自動編號附程式
              IF g_aza.aza29 = 'Y' THEN
                 CALL s_auno(g_occa.occa01,'2','') RETURNING g_occa.occa01,g_occa.occa02  #No.FUN-850100
              END IF
              DISPLAY BY NAME g_occa.occa01,g_occa.occa02
          END IF
 
   END INPUT
 
END FUNCTION
 
FUNCTION i250_occa47(p_cmd)  #慣用交運方式                                                                                          
   DEFINE   p_cmd       LIKE type_file.chr1,                                                                                        
            l_ged02     LIKE ged_file.ged02            #交運方式說明                                                                
   LET g_errno = ' '                                                                                                                
   SELECT ged02                                                                                                                     
     INTO l_ged02                                                                                                                   
     FROM ged_file                                                                                                                  
    WHERE ged01 = g_occa.occa47                                                                                                     
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3011'                                                                           
                                  LET l_ged02   = NULL                                                                              
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'                                                              
   END CASE                                                                                                                         
   DISPLAY l_ged02 TO occa47_desc                                                                                                   
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i250_occa48(p_cmd)  #慣用運送起點                                                                                          
   DEFINE   p_cmd       LIKE type_file.chr1,                                                                                        
            l_oac02     LIKE oac_file.oac02            #運送起點說明                                                                
                                                                                                                                    
   LET g_errno = ' '                                                                                                                
   SELECT oac02                     
     INTO l_oac02                                                                                                                   
     FROM oac_file                                                                                                                  
    WHERE oac01 = g_occa.occa48                                                                                                     
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3011'                                                                           
                                  LET l_oac02   = NULL                                                                              
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'                                                              
   END CASE                                                                                                                         
   DISPLAY l_oac02 TO occa48_desc                                                                                                   
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i250_occa49(p_cmd)  #慣用運送終點                                                                                          
   DEFINE   p_cmd       LIKE type_file.chr1,                                                                                        
            l_oac02     LIKE oac_file.oac02            #運送終點說明                                                                
                                                                                                                                    
   LET g_errno = ' '                                                                                                                
   SELECT oac02                                                                                                                     
     INTO l_oac02                                                                                                                   
     FROM oac_file                                                                                                                  
    WHERE oac01 = g_occa.occa49                                                                                                     
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3011'                                                                           
                                  LET l_oac02   = NULL                                                                              
 OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'                                                                     
   END CASE                                                                                                                         
   DISPLAY l_oac02 TO occa49_desc           
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i250_occa50(p_cmd)  #卸貨港                                                                                                
   DEFINE   p_cmd       LIKE type_file.chr1,                                                                                        
            l_oac02     LIKE oac_file.oac02            #卸貨港說明                                                                  
                                                                                                                                    
   LET g_errno = ' '                                                                                                                
   SELECT oac02                                                                                                                     
     INTO l_oac02                                                                                                                   
     FROM oac_file                                                                                                                  
    WHERE oac01 = g_occa.occa50                                                                                                     
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3011'                                                                           
                                  LET l_oac02   = NULL                                                                              
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'                                                              
   END CASE                                                                                                                         
   DISPLAY l_oac02 TO occa50_desc                                                                                                   
END FUNCTION                                                                                                                        
 
FUNCTION i250_occa41(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
       l_gecacti       LIKE gec_file.gecacti,
       l_gec02         LIKE gec_file.gec02
 
   LET g_errno = ' '
 
   SELECT gec02,gecacti INTO l_gec02,l_gecacti
       FROM gec_file
       WHERE gec01 = g_occa.occa41
         AND gec011='2'  #銷項
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'axm-142'
                           LET l_gec02 = NULL
        WHEN l_gecacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   DISPLAY l_gec02 TO gec02
 
END FUNCTION
 
FUNCTION i250_occa43(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
    l_oab02       	LIKE oab_file.oab02
 
    LET g_errno = ' '
    SELECT oab02 INTO l_oab02
        FROM oab_file
        WHERE oab01 = g_occa.occa43
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4099'
                            LET l_oab02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    DISPLAY l_oab02 TO oab02
END FUNCTION
 
FUNCTION i250_occa44(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
    l_oah02         LIKE oah_file.oah02
 
    LET g_errno = ' '
    SELECT oah02 INTO l_oah02
        FROM oah_file
        WHERE oah01 = g_occa.occa44
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4101'
                            LET l_oah02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    DISPLAY l_oah02 TO oah02
END FUNCTION
 
FUNCTION i250_occa20(p_cmd)  #區域
DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
    l_gea02         LIKE gea_file.gea02,
    l_geaacti       LIKE gea_file.geaacti 
 
    LET g_errno = ' '
     SELECT gea02,geaacti INTO l_gea02,l_geaacti 
        FROM gea_file
        WHERE gea01 = g_occa.occa20
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3139'   
                                   LET l_gea02 = NULL
          WHEN l_geaacti='N'        LET g_errno='9028' 
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    DISPLAY l_gea02 TO occa20_desc
END FUNCTION
 
FUNCTION i250_occa21(p_cmd)  #國別
DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
    l_geb02         LIKE geb_file.geb02,
    l_gebacti       LIKE geb_file.gebacti 
 
    LET g_errno = ' '
     SELECT geb02,gebacti INTO l_geb02,l_gebacti 
        FROM geb_file
        WHERE geb01 = g_occa.occa21
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3029'   
                            LET l_geb02 = NULL
          WHEN l_gebacti='N'        LET g_errno='9028' 
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    DISPLAY l_geb02 TO occa21_desc
END FUNCTION
 
FUNCTION i250_occa22(p_cmd)  #地區代號
   DEFINE   p_cmd       LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
            l_geo03     LIKE geb_file.geb03,            #國別代號
            l_geb02     LIKE gea_file.gea02,            #國別名稱
            l_geo02     LIKE geb_file.geb02,            #地區代號
            l_geoacti   LIKE geb_file.gebacti,          #有效碼
            l_gea02     LIKE gea_file.gea02             #區域名稱
 
   LET g_errno = ' '
   SELECT geo03,geoacti,geo02
     INTO l_geo03,l_geoacti,l_geo02
     FROM geo_file
    WHERE geo01 = g_occa.occa22
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3011'
                                  LET l_geo03   = NULL
                                  LET l_geoacti = NULL
        WHEN l_geoacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF p_cmd = 'a' THEN
      LET g_occa.occa21 = l_geo03
 
      DISPLAY BY NAME g_occa.occa21
      SELECT geb02 INTO l_geb02 FROM geb_file WHERE geb01 = g_occa.occa21
      DISPLAY l_geb02 TO occa21_desc
      SELECT gea01,gea02 INTO g_occa.occa20,l_gea02 FROM gea_file,geb_file
       WHERE gea01 = geb03 AND geb01 = l_geo03
      DISPLAY BY NAME g_occa.occa20
      DISPLAY l_gea02 TO occa20_desc
   END IF
   DISPLAY l_geo02 TO occa22_desc  
 
END FUNCTION
 
#CHI-A80050 add --start--
FUNCTION i250_occa34(p_cmd)
   DEFINE p_cmd       LIKE type_file.chr1
   DEFINE l_occa1004  LIKE occa_file.occa1004

   LET g_errno=''

   SELECT occa1004 INTO l_occa1004
     FROM occa_file
    WHERE occa01=g_occa.occa34

   CASE WHEN SQLCA.SQLCODE=100   LET g_errno='mfg4106'
        WHEN l_occa1004 <> '1'   LET g_errno='atm-073'
       #WHEN g_occa.occa34 = g_occa.occa01                 #FUN-C80019 mark 
       #                         LET g_errno='axm-960'     #FUN-C80019 mark
        OTHERWISE                LET g_errno=SQLCA.SQLCODE USING '------'
   END CASE
  #FUN-C80019 add START
  #當集團輸入自己時,不控卡已確認否
  #IF g_occa.occa34 = g_occa.occa01  THEN
      IF l_occa1004 <> '1' THEN
         LET g_errno = ''
      END IF
  #END IF
  #FUN-C80019 add END

END FUNCTION
#CHI-A80050 add --end--

FUNCTION i250_occa45(p_cmd)
 
   DEFINE p_cmd           LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_oag02         LIKE oag_file.oag02
 
    LET g_errno = ' '
    SELECT oag02 INTO l_oag02
        FROM oag_file
        WHERE oag01 = g_occa.occa45
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg9357'
                            LET l_oag02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    DISPLAY l_oag02 TO oag02
END FUNCTION
 
FUNCTION i250_occa67(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
   DEFINE l_ool02 LIKE ool_file.ool02
   LET l_ool02=''
   SELECT ool02 INTO l_ool02 FROM ool_file WHERE ool01=g_occa.occa67
   IF (SQLCA.sqlcode) AND (p_cmd='a') THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      DISPLAY NULL TO FORMONLY.ool02
      RETURN FALSE
   END IF
   DISPLAY l_ool02 TO FORMONLY.ool02
   RETURN TRUE
END FUNCTION

#FUN-B30044  add begin------------------------------------
FUNCTION i250_occa68(p_cmd)
 
   DEFINE p_cmd           LIKE type_file.chr1,  
          l_oag02         LIKE oag_file.oag02
 
    LET g_errno = ' '
    SELECT oag02 INTO l_oag02
        FROM oag_file
        WHERE oag01 = g_occa.occa68
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg9357'
                            LET l_oag02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
       DISPLAY l_oag02 TO oag02_1
END FUNCTION
 
FUNCTION i250_occa69(p_cmd)
 
   DEFINE p_cmd           LIKE type_file.chr1,  
          l_oag02         LIKE oag_file.oag02
 
    LET g_errno = ' '
    SELECT oag02 INTO l_oag02
        FROM oag_file
        WHERE oag01 = g_occa.occa69
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg9357'
                            LET l_oag02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
       DISPLAY l_oag02 TO oag02_2
 
END FUNCTION
#FUN-B30044  add end------------------------------------
 
FUNCTION i250_occa42(p_cmd)  #幣別
DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
    l_aziacti       LIKE azi_file.aziacti
 
    LET g_errno = ' '
    SELECT aziacti INTO l_aziacti
        FROM azi_file
        WHERE azi01 = g_occa.occa42
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
         WHEN l_aziacti='N'        LET g_errno='9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
 
FUNCTION i250_occa1005(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_tqb02    LIKE tqb_file.tqb02,
          l_tqbacti  LIKE tqb_file.tqbacti
 
   LET g_errno=''
 
   SELECT tqb02,tqbacti INTO l_tqb02,l_tqbacti
     FROM tqb_file
    WHERE tqb01=g_occa.occa1005
 
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno='mfg9329'
                                 LET l_tqb02=NULL
        WHEN l_tqbacti='N'       LET g_errno='9028'
                                 LET l_tqb02=NULL
        OTHERWISE                LET g_errno=SQLCA.SQLCODE USING '------'
   END CASE
 
   DISPLAY l_tqb02 TO FORMONLY.tqb02
 
END FUNCTION
 
FUNCTION i250_occa1003(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqaacti  LIKE tqa_file.tqaacti
 
   LET g_errno=''
 
   SELECT tqa02,tqaacti INTO l_tqa02,l_tqaacti
     FROM tqa_file
    WHERE tqa01=g_occa.occa1003
      AND tqa03='12'
 
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno='mfg9329'
                                 LET l_tqa02=NULL
        WHEN l_tqaacti='N'       LET g_errno='9028'
                                 LET l_tqa02=NULL
        OTHERWISE                LET g_errno=SQLCA.SQLCODE USING '------'
   END CASE
 
   DISPLAY l_tqa02 TO FORMONLY.tqa02c
 
END FUNCTION
FUNCTION i250_occa1006(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqaacti  LIKE tqa_file.tqaacti
 
   LET g_errno=''
 
   SELECT tqa02,tqaacti INTO l_tqa02,l_tqaacti
     FROM tqa_file
    WHERE tqa01=g_occa.occa1006
      AND tqa03='19'
 
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno='mfg9329'
                                 LET l_tqa02=NULL
        WHEN l_tqaacti='N'       LET g_errno='9028'
                                 LET l_tqa02=NULL
        OTHERWISE                LET g_errno=SQLCA.SQLCODE USING '------'
   END CASE
 
   DISPLAY l_tqa02 TO FORMONLY.tqa02
 
END FUNCTION
 
FUNCTION i250_occa1007(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqaacti  LIKE tqa_file.tqaacti
 
   LET g_errno=''
 
   SELECT tqa02,tqaacti INTO l_tqa02,l_tqaacti
     FROM tqa_file
    WHERE tqa01=g_occa.occa1007
      AND tqa03='10'
 
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno='mfg9329'
                                 LET l_tqa02=NULL
        WHEN l_tqaacti='N'       LET g_errno='9028'
                                 LET l_tqa02=NULL
        OTHERWISE                LET g_errno=SQLCA.SQLCODE USING '------'
   END CASE
 
   DISPLAY l_tqa02 TO FORMONLY.tqa02a
 
END FUNCTION
 
FUNCTION i250_occa1008(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqaacti  LIKE tqa_file.tqaacti
 
   LET g_errno=''
 
   SELECT tqa02,tqaacti INTO l_tqa02,l_tqaacti
     FROM tqa_file
    WHERE tqa01=g_occa.occa1008
      AND tqa03='11'
 
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno='mfg9329'
                                 LET l_tqa02=NULL
        WHEN l_tqaacti='N'       LET g_errno='9028'
                                 LET l_tqa02=NULL
        OTHERWISE                LET g_errno=SQLCA.SQLCODE USING '------'
   END CASE
 
   DISPLAY l_tqa02 TO FORMONLY.tqa02b
 
END FUNCTION
FUNCTION i250_occa1009(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_too02    LIKE too_file.too02,
          l_tooacti  LIKE too_file.tooacti
 
   LET g_errno=''
 
   SELECT too02,tooacti INTO l_too02,l_tooacti
     FROM too_file
    WHERE too01=g_occa.occa1009
 
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno='mfg9329'
                                 LET l_too02=NULL
        WHEN l_tooacti='N'       LET g_errno='9028'
                                 LET l_too02=NULL
        OTHERWISE                LET g_errno=SQLCA.SQLCODE USING '------'
   END CASE
 
   DISPLAY l_too02 TO FORMONLY.too02
 
END FUNCTION
 
FUNCTION i250_occa1010(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_top02    LIKE top_file.top02,
          l_topacti  LIKE top_file.topacti
 
   LET g_errno=''
 
   SELECT top02,topacti INTO l_top02,l_topacti
     FROM top_file
    WHERE top01=g_occa.occa1010
      AND top03=g_occa.occa1009
 
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno='mfg9329'
                                 LET l_top02=NULL
        WHEN l_topacti='N'       LET g_errno='9028'
                                 LET l_top02=NULL
        OTHERWISE                LET g_errno=SQLCA.SQLCODE USING '------'
   END CASE
 
   DISPLAY l_top02 TO FORMONLY.top02
 
END FUNCTION
 
FUNCTION i250_occa1011(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_toq02    LIKE toq_file.toq02,
          l_toqacti  LIKE toq_file.toqacti
 
   LET g_errno=''
 
   SELECT toq02,toqacti INTO l_toq02,l_toqacti
     FROM toq_file
    WHERE toq01=g_occa.occa1011
      AND toq03=g_occa.occa1010
 
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno='mfg9329'
                                 LET l_toq02=NULL
        WHEN l_toqacti='N'       LET g_errno='9028'
                                 LET l_toq02=NULL
        OTHERWISE                LET g_errno=SQLCA.SQLCODE USING '------'
   END CASE
 
   DISPLAY l_toq02 TO FORMONLY.toq02
 
END FUNCTION
 
FUNCTION i250_occa1016(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_imd02    LIKE imd_file.imd02,
          l_imdacti  LIKE imd_file.imdacti
 
   LET g_errno=''
 
   SELECT imd02,imdacti INTO l_imd02,l_imdacti
     FROM imd_file
    WHERE imd01=g_occa.occa1016
 
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno='mfg9329'
                                 LET l_imd02=NULL
        WHEN l_imdacti='N'       LET g_errno='9028'
                                 LET l_imd02=NULL
        OTHERWISE                LET g_errno=SQLCA.SQLCODE USING '------'
   END CASE
 
   DISPLAY l_imd02 TO FORMONLY.imd02
 
END FUNCTION
 
FUNCTION i250_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_occa.* TO NULL               #No.FUN-6A0020
 
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i250_curs()                          # 宣告 SCROLL CURSOR
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      RETURN
   END IF
 
   OPEN i250_count
   FETCH i250_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
 
   OPEN i250_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_occa.occano,SQLCA.sqlcode,0)
      INITIALIZE g_occa.* TO NULL
   ELSE
      CALL i250_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i250_fetch(p_flocca)
   DEFINE p_flocca        LIKE type_file.chr1    #No.FUN-680137  VARCHAR(1)
 
   CASE p_flocca
       WHEN 'N' FETCH NEXT     i250_cs INTO g_occa.occano
       WHEN 'P' FETCH PREVIOUS i250_cs INTO g_occa.occano
       WHEN 'F' FETCH FIRST    i250_cs INTO g_occa.occano
       WHEN 'L' FETCH LAST     i250_cs INTO g_occa.occano
       WHEN '/'
           IF (NOT mi_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0  ######add for prompt bug
              PROMPT g_msg CLIPPED,': ' FOR g_jump
 
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
           FETCH ABSOLUTE g_jump i250_cs INTO g_occa.occano
           LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_occa.occano,SQLCA.sqlcode,0)
      INITIALIZE g_occa.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flocca
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_occa.* FROM occa_file
    WHERE occano = g_occa.occano
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","occa_file",g_occa.occano,"",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_occa.* TO NULL            
   ELSE
 
      LET g_data_owner = g_occa.occauser      
      LET g_data_group = g_occa.occagrup      
      CALL i250_show()                      # 重新顯示
   END IF
 
END FUNCTION
 
FUNCTION i250_show()
  DEFINE l_msg  LIKE type_file.chr1000 #No.FUN-680137  VARCHAR(40)
    DISPLAY BY NAME g_occa.occaoriu,g_occa.occaorig,
          g_occa.occa00,g_occa.occano,g_occa.occa01,g_occa.occa02,g_occa.occa18,g_occa.occa19, 
         #g_occa.occa1001,g_occa.occa1002,g_occa.occa11,g_occa.occa37,g_occa.occa28,g_occa.occa34,   #MOD-CC0094 mark
          g_occa.occa11,g_occa.occa37,g_occa.occa28,g_occa.occa34,                                   #MOD-CC0094 add 
          g_occa.occa66,g_occa.occa1005,   
 
          g_occa.occa1004,g_occa.occa10,g_occa.occa06,g_occa.occa09,  g_occa.occa07,  g_occa.occa03, g_occa.occa04,
          g_occa.occa56,  g_occa.occa57,g_occa.occa31,g_occa.occa65,  
 
          g_occa.occa22,  g_occa.occa21,  g_occa.occa20, #g_occa.occa35, #CHI-A80050 mark occa35
         #g_occa.occa231, g_occa.occa232, g_occa.occa233, #CHI-A80050 mark
         #g_occa.occa241, g_occa.occa242, g_occa.occa243, #CHI-A80050 mark
 
          g_occa.occa261, g_occa.occa262, g_occa.occa263, g_occa.occa271,g_occa.occa272,
          g_occa.occa29,  g_occa.occa30,  g_occa.occa292, g_occa.occa302,
 
          g_occa.occa35, #CHI-A80050 add
          g_occa.occa231, g_occa.occa232, g_occa.occa233, #CHI-A80050 add
          g_occa.occa241, g_occa.occa242, g_occa.occa243, #CHI-A80050 add

          g_occa.occa40,  g_occa.occa38,  g_occa.occa39,
 
          g_occa.occauser,g_occa.occagrup,g_occa.occamodu,g_occa.occadate,g_occa.occaacti,
 
          g_occa.occa42,  g_occa.occa41,  g_occa.occa08,  g_occa.occa44, g_occa.occa45,
          g_occa.occa68,  g_occa.occa69,   #FUN-B30044add occa68,occa69
          g_occa.occa67,  g_occa.occa43,  g_occa.occa55,  g_occa.occa47,
          g_occa.occa48,  g_occa.occa49,  g_occa.occa50,
 
          g_occa.occa46,  g_occa.occa53,  g_occa.occa32,g_occa.occa51,  g_occa.occa52, 
          g_occa.occa701, g_occa.occa702, g_occa.occa703, g_occa.occa704,
 
          g_occa.occa12,  g_occa.occa13,  g_occa.occa14,  g_occa.occa15, g_occa.occa05,
 
          g_occa.occa62,g_occa.occa33,g_occa.occa61,g_occa.occa36,g_occa.occa175,g_occa.occa631,g_occa.occa63,g_occa.occa64,
 
          g_occa.occa1003,g_occa.occa1006,g_occa.occa1007,g_occa.occa1008,g_occa.occa1009,
          g_occa.occa1010,g_occa.occa1011,g_occa.occa1012,g_occa.occa1013,g_occa.occa1014,
          g_occa.occa1015,g_occa.occa1016,g_occa.occa1027,
          g_occa.occaud01,g_occa.occaud02,g_occa.occaud03,g_occa.occaud04,
          g_occa.occaud05,g_occa.occaud06,g_occa.occaud07,g_occa.occaud08,
          g_occa.occaud09,g_occa.occaud10,g_occa.occaud11,g_occa.occaud12,
          g_occa.occaud13,g_occa.occaud14,g_occa.occaud15 
 
     SELECT occ02 INTO g_buf FROM occ_file WHERE occ01=g_occa.occa09
     IF STATUS THEN LET g_buf='' END IF
     DISPLAY g_buf TO FORMONLY.occa9_ds
     IF cl_null(g_buf) THEN
        SELECT UNIQUE occa02 INTO g_buf FROM occa_file WHERE occa01 = g_occa.occa09
        IF STATUS THEN LET g_buf='' END IF
        DISPLAY g_buf TO FORMONLY.occa9_ds
     END IF
     SELECT occ02 INTO g_buf FROM occ_file WHERE occ01=g_occa.occa07
     IF STATUS THEN LET g_buf='' END IF
     DISPLAY g_buf TO FORMONLY.occa7_ds
     IF cl_null(g_buf) THEN
        SELECT UNIQUE occa02 INTO g_buf FROM occa_file WHERE occa01 = g_occa.occa07
        IF STATUS THEN LET g_buf='' END IF
        DISPLAY g_buf TO FORMONLY.occa7_ds
     END IF
     SELECT gen02 INTO g_buf FROM gen_file WHERE gen01=g_occa.occa04
     IF STATUS THEN LET g_buf='' END IF
     DISPLAY g_buf TO FORMONLY.gen02
     SELECT oca02 INTO g_buf FROM oca_file
       WHERE oca01=g_occa.occa03
     IF STATUS THEN LET g_buf='' END IF
     DISPLAY g_buf TO FORMONLY.oca02
     CALL i250_occa47('d')                                                                                                          
     CALL i250_occa48('d')                                                                                                          
     CALL i250_occa49('d')                                                                                                          
     CALL i250_occa50('d')                                                                                                          
     CALL i250_occa1006('d')
     CALL i250_occa1007('d')
     CALL i250_occa1008('d')
     CALL i250_occa1003('d')
     CALL i250_occa1009('d')
     CALL i250_occa1010('d')
     CALL i250_occa1011('d')
     CALL i250_occa1016('d')
     CALL i250_occa41('d')   
     CALL i250_occa43('d')   
     CALL i250_occa44('d')   
     CALL i250_occa45('d')   
     CALL i250_occa67('d') RETURNING g_buf   
     CALL i250_occa22('d')   
     CALL i250_occa21('d')   
     CALL i250_occa20('d')   
     CALL i250_occa68('d')   #No.FUN-840183
     CALL i250_occa69('d')   #No.FUN-840183
     LET g_buf=NULL
     SELECT pmc03 INTO g_buf FROM pmc_file
      WHERE pmc01 = g_occa.occa51
     DISPLAY g_buf TO pmc03
     LET g_buf = ''
     SELECT pmc03 INTO g_buf FROM pmc_file
      WHERE pmc01 = g_occa.occa66 AND pmc14 = '6'   
     DISPLAY g_buf TO pmc03_1
     LET g_buf = ''
     SELECT tqb02 INTO g_buf FROM tqb_file
      WHERE tqb01 = g_occa.occa1005 
     DISPLAY g_buf TO tqb02
     CALL i250_show_pic() #圖示
     CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i250_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_occa.occano IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_occa.occaacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    #非開立狀態，不可異動！
   #狀況=>R:送簽退回,W:抽單 也要可以修改
    IF g_input_custno = 'N' THEN #CHI-840028 add if 判斷
        IF g_occa.occa1004 NOT MATCHES '[0RW]' THEN CALL cl_err('','atm-046',1) RETURN END IF 
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_occano_t = g_occa.occano
    LET g_occa01_t = g_occa.occa01   #MOD-C80143 add
 
    IF g_action_choice <> "reproduce" THEN    
       BEGIN WORK
    END IF
 
    OPEN i250_cl USING g_occa.occano
    IF STATUS THEN
       CALL cl_err("OPEN i250_cl:", STATUS, 1)
       CLOSE i250_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i250_cl INTO g_occa.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_occa.occano,SQLCA.sqlcode,0)
       ROLLBACK WORK         
       RETURN
    END IF
    LET g_occa_t.*=g_occa.*
    LET g_occa.occamodu = g_user                #修改者
    LET g_occa.occadate = g_today               #修改日期
    CALL i250_show()                            #顯示最新資料
    WHILE TRUE
          LET g_occa.occamodu = g_user          #修改者
          LET g_occa.occadate = g_today         #最近修改日
          CALL i250_i("u")                      #欄位更改
          IF INT_FLAG THEN
             LET INT_FLAG = 0
             LET g_occa.*=g_occa_t.*
             CALL i250_show()
             CALL cl_err('',9001,0)
             ROLLBACK WORK      
             EXIT WHILE
          END IF
          IF g_occa.occa1004 MATCHES '[RW]' THEN
              LET g_occa.occa1004 = '0' #開立
          END IF
          UPDATE occa_file SET occa_file.* = g_occa.*  # 更新DB
              WHERE occano = g_occano_t             # COLAUTH?
          IF SQLCA.SQLERRD[3]=0 THEN     
             CALL cl_err3("upd","occa_file",g_occano_t,"",SQLCA.sqlcode,"","",1)  
             ROLLBACK WORK     
             BEGIN WORK       
             CONTINUE WHILE
          END IF
          CALL i250_show_pic()
       EXIT WHILE
    END WHILE
    CLOSE i250_cl
    COMMIT WORK #TQC-740090 add
    SELECT * INTO g_occa.* FROM occa_file WHERE occano = g_occa.occano 
    CALL i250_show()                                            
END FUNCTION
 
FUNCTION i250_d()
   DEFINE l_n       LIKE type_file.num5     #No.FUN-680137 SMALLINT
   DEFINE l_occ62   LIKE occ_file.occ62     #TQC-740090 add
   DEFINE l_occacti LIKE occ_file.occacti   #TQC-740090 add
 
   IF s_shut(0) THEN RETURN END IF
   IF g_occa.occano IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   #申請類別為"U:修改",不允許變更信用額度資料!
   IF g_occa.occa00 = 'U' THEN 
       CALL cl_err('','axm-320',1) 
       RETURN 
   END IF  
 
   #此筆資料已無效, 不可異動!
   IF g_occa.occaacti = 'N' THEN 
       CALL cl_err('','aim-153',1) 
       RETURN 
   END IF  
 
   #非開立狀態，不可異動！
   #IF g_occa.occa1004!='0' THEN CALL cl_err('','atm-046',1) RETURN END IF 
   #狀況=>R:送簽退回,W:抽單 也要可以修改
    IF g_occa.occa1004 NOT MATCHES '[0RW]' THEN CALL cl_err('','atm-046',1) RETURN END IF 
 
   BEGIN WORK
 
   OPEN i250_cl USING g_occa.occano
   IF STATUS THEN
      CALL cl_err("OPEN i250_cl:", STATUS, 1)
      CLOSE i250_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i250_cl INTO g_occa.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_occa.occa01,SQLCA.sqlcode,1)
      RETURN
   END IF
 
   IF g_occa.occano IS NULL THEN
      RETURN
   END IF
 
   INPUT BY NAME g_occa.occa62,g_occa.occa33,g_occa.occa61,g_occa.occa36,
                 g_occa.occa175,g_occa.occa631,g_occa.occa63,g_occa.occa64
         WITHOUT DEFAULTS
 
      AFTER FIELD occa61
         IF NOT cl_null(g_occa.occa61) THEN
             SELECT * FROM ocg_file WHERE ocg01 = g_occa.occa61
             IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","ocg_file",g_occa.occa61,"",SQLCA.sqlcode,"","sel ocg",1)  #No.FUN-660167
                  NEXT FIELD occa61
             END IF
          END IF
 
       AFTER FIELD occa62
          IF cl_null(g_occa.occa62) THEN NEXT FIELd occa62 END IF
          IF g_occa.occa62 NOT MATCHES "[YN]" THEN NEXT FIELd occa62 END IF
          IF g_occa.occa62='N' THEN 
             LET g_occa.occa63=0
             CALL cl_set_comp_required("occa61,occa631",FALSE)
          ELSE
             CALL cl_set_comp_required("occa61,occa631",TRUE)
          END IF
          DISPLAY BY NAME g_occa.occa63
 
#TQC-A10019 --begin--
       AFTER FIELD occa36
          IF NOT cl_null(g_occa.occa36) THEN
             IF g_occa.occa36 < 0 THEN
                 CALL cl_err('','aec-020',0)
                  NEXT FIELD CURRENT
             END IF 
           END IF 
#TQC-A10019 --end-- 

       AFTER FIELD occa631
          IF NOT cl_null(g_occa.occa631) THEN
             SELECT COUNT(*) INTO l_n FROM azi_file WHERE azi01=g_occa.occa631
             IF l_n = 0  THEN
                CALL cl_err('','mfg3008',0) NEXT FIELD occa631
             END IF
          ELSE
             IF g_occa.occa63 > 0 THEN
                CALL cl_err('occa631','axm-917',0)
                NEXT FIELD occa631
             END IF
          END IF
 
       AFTER FIELD occa63
#TQC-A10019 --begin--
          IF NOT cl_null(g_occa.occa63) THEN
             IF g_occa.occa63 < 0 THEN
                 CALL cl_err('','aec-020',0)
                  NEXT FIELD CURRENT
             END IF
           END IF
#TQC-A10019 --end--
          IF cl_null(g_occa.occa63) THEN LET g_occa.occa63 = 0  END IF
          IF g_occa.occa63=0 AND g_occa.occa62 ='Y' THEN
            LET l_n = 0 
            IF g_occa.occa33 <> g_occa.occa01 THEN            
             SELECT SUM(occ63) INTO l_n FROM occ_file
              WHERE occ33 = g_occa.occa33
            END IF
            #MOD-BA0206 ---- mark start -----
            #IF cl_null(l_n) OR l_n=0 THEN
            #   CALL cl_err('occa63','axm-052',0)
            #   NEXT FIELD occa63
            #END IF  
            #MOD-BA0206 ----- mark  end  -----
          END IF
          DISPLAY BY NAME g_occa.occa63
          IF g_occa.occa63 > 0 AND cl_null(g_occa.occa631) THEN
             CALL cl_err('occa631','axm-917',0)
             NEXT FIELD occa631
          END IF
 
       AFTER FIELD occa64
          IF cl_null(g_occa.occa64) THEN LET g_occa.occa64 = 0 END IF
          IF g_occa.occa64<0 AND g_occa.occa62='Y' THEN
             CALL cl_err('occa64','mfg5034',0)
             NEXT FIELD occa64
          END IF
 
       BEFORE FIELD occa33
          IF cl_null(g_occa.occa33) THEN
             LET g_occa.occa33 = g_occa.occa01
             DISPLAY BY NAME g_occa.occa33
          ELSE
             LET g_occa_t.occa33 = g_occa.occa33
          END IF
 
       AFTER FIELD occa33
          IF cl_null(g_occa.occa33) THEN NEXT FIELD occa33 END IF
          IF g_occa.occa33 !=g_occa.occa01 THEN
             SELECT occacti,occ62 INTO l_occacti,l_occ62 FROM occ_file
              WHERE occ01 = g_occa.occa33
             IF STATUS THEN
                 #無此客戶代號, 請重新輸入
                 CALL cl_err(g_occa.occa33,'anm-045',1) 
                 LET g_occa.occa33 = g_occa_t.occa33
                 DISPLAY BY NAME g_occa.occa33
                 NEXT FIELD occa33
             ELSE
                IF l_occacti = 'N' THEN
                    #無效的客戶資料！
                    CALL cl_err(g_occa.occa33,'axr-604',1) 
                    LET g_occa.occa33 = g_occa_t.occa33
                    DISPLAY BY NAME g_occa.occa33
                    NEXT FIELD occa33
                END IF
                IF cl_null(l_occ62) OR l_occ62='N' THEN
                    #所輸入之客戶不須作信用查核 !!
                    CALL cl_err(g_occa.occa33,'axm-103',1)
                    LET g_occa.occa33 = g_occa_t.occa33
                    DISPLAY BY NAME g_occa.occa33
                    NEXT FIELD occa33
                END IF
             END IF
          END IF
 
       ON ACTION controlp
          CASE WHEN INFIELD(occa631)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = 'q_azi'
                    LET g_qryparam.default1 = g_occa.occa631
                    CALL cl_create_qry() RETURNING g_occa.occa631
                    DISPLAY BY NAME g_occa.occa631
                    NEXT FIELD occa631
               WHEN INFIELD(occa61)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = 'q_ocg'
                    LET g_qryparam.default1 = g_occa.occa61
                    CALL cl_create_qry() RETURNING g_occa.occa61
                    DISPLAY BY NAME g_occa.occa61
                    NEXT FIELD occa61
               WHEN INFIELD(occa33)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = 'q_occ'           #TQC-740090 mod
                    LET g_qryparam.default1 = g_occa.occa33
                    LET g_qryparam.where = " occ62='Y'"     #TQC-740090 add
                    CALL cl_create_qry() RETURNING g_occa.occa33
                    DISPLAY BY NAME g_occa.occa33
                    NEXT FIELD occa33
               WHEN INFIELD(occa66)   #代送商
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = 'q_pmc8'   
                    LET g_qryparam.default1 = g_occa.occa56
                    CALL cl_create_qry() RETURNING g_occa.occa66
                    DISPLAY BY NAME g_occa.occa66
                    NEXT FIELD occa66
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
 
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    LET g_occa.occa1004 = '0' #TQC-750007 add
    UPDATE occa_file SET * = g_occa.* WHERE occano = g_occa.occano
    IF SQLCA.SQLCODE THEN
       CALL cl_err3("upd","occa_file",g_occa.occa01,"",SQLCA.SQLCODE,"","update occa",1)  
       ROLLBACK WORK
    ELSE
       COMMIT WORK
    END IF
    SELECT * INTO g_occa.* FROM occa_file WHERE occano = g_occa.occano 
    CALL i250_show()                                            
 
END FUNCTION
 
 
FUNCTION i250_x()
 
   DEFINE g_chr LIKE occa_file.occaacti
   DEFINE l_occano      LIKE occa_file.occano #MOD-B40095 add
 
   IF s_shut(0) THEN RETURN END IF
   IF g_occa.occano IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   #非開立狀態，不可異動！
  #IF g_occa.occa1004!='0' THEN CALL cl_err('','atm-046',1) RETURN END IF 
  #狀況=>R:送簽退回,W:抽單 也要可以做無效切換
   IF g_occa.occa1004 NOT MATCHES '[0RW]' THEN CALL cl_err('','atm-046',1) RETURN END IF 

   #MOD-B40095 add --start--
   IF g_occa.occa00 = 'U' AND g_occa.occaacti='N' THEN
      LET l_occano = NULL
      SELECT occano INTO l_occano FROM occa_file
       WHERE occa01 = g_occa.occa01
         AND occa00 = 'U' #修改
         AND occa1004 != '2' 
         AND occaacti != 'N' 
      IF NOT cl_null(l_occano) THEN
         #已存在一張相同客戶,但未拋轉的客戶申請單!
         CALL cl_err(l_occano,'axm-227',1)
         RETURN
      END IF
   END IF
   #MOD-B40095 add --end--
 
   BEGIN WORK
 
   OPEN i250_cl USING g_occa.occano
   IF STATUS THEN
      CALL cl_err("OPEN i250_cl:", STATUS, 1)
      CLOSE i250_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i250_cl INTO g_occa.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_occa.occano,SQLCA.sqlcode,1)
      RETURN
   END IF
 
   CALL i250_show()
 
   IF cl_exp(0,0,g_occa.occaacti) THEN
      LET g_chr=g_occa.occaacti
      IF g_occa.occaacti='Y' THEN
         LET g_occa.occaacti='N'
      ELSE
         LET g_occa.occaacti='Y'
      END IF
 
      UPDATE occa_file SET occaacti = g_occa.occaacti,
                           occamodu = g_user,
                           occadate = g_today,
                           occa1004 = '0' #開立 TQC-750007 add
       WHERE occano = g_occa.occano
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","occa_file",g_occa.occano,"",SQLCA.sqlcode,"","",1)  
         LET g_occa.occaacti=g_chr
      END IF
      DISPLAY BY NAME g_occa.occaacti
   END IF
 
   CLOSE i250_cl
   COMMIT WORK
   SELECT * INTO g_occa.* FROM occa_file WHERE occano = g_occa.occano 
   CALL i250_show()                                            
 
END FUNCTION
 
FUNCTION i250_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_occa.occano IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #非開立狀態，不可異動！
   #IF g_occa.occa1004!='0' THEN CALL cl_err('','atm-046',1) RETURN END IF 
   #狀況=>R:送簽退回,W:抽單 也要可以做刪除
    IF g_occa.occa1004 NOT MATCHES '[0RW]' THEN CALL cl_err('','atm-046',1) RETURN END IF 
 
    BEGIN WORK
 
    OPEN i250_cl USING g_occa.occano
    IF STATUS THEN
       CALL cl_err("OPEN i250_cl:", STATUS, 1)
       CLOSE i250_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i250_cl INTO g_occa.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_occa.occa01,SQLCA.sqlcode,1)
       ROLLBACK WORK       
       RETURN
    END IF
    CALL i250_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL            #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "occano"          #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_occa.occano      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
       DELETE FROM occa_file  
        WHERE occano = g_occa.occano
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","occa_file",g_occa.occano,"",SQLCA.sqlcode,"","",1)  
          ROLLBACK WORK
          RETURN
       END IF
 
       LET g_msg=TIME
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  #FUN-980010 add plant  & legal 
          VALUES ('axmi250',g_user,g_today,g_msg,g_occa.occano,'delete',
                   g_plant,g_legal)
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","azo_file","axmi250","",SQLCA.sqlcode,"","",1)  
          ROLLBACK WORK
          RETURN
       END IF
 
       CLEAR FORM        
       INITIALIZE g_occa.* TO NULL
       OPEN i250_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE i250_cs
          CLOSE i250_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH i250_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i250_cs
          CLOSE i250_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i250_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i250_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i250_fetch('/')
       END IF
    END IF
    CLOSE i250_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i250_out()
   DEFINE l_occa           RECORD LIKE occa_file.*,
          l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_name          LIKE type_file.chr20,         #No.FUN-680137 VARCHAR(20)
          l_za05          LIKE type_file.chr1000        #No.FUN-680137 VARCHAR(40)
 
   IF cl_null(g_wc) THEN
      IF cl_null(g_occa.occa01) THEN 
          CALL cl_err('','9057',0) RETURN 
      ELSE 
           LET g_wc=" occa01='",g_occa.occa01,"'" 
      END IF 
   END IF
 
   CALL cl_wait()
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   LET g_sql = "SELECT * FROM occa_file ",     # 組合出 SQL 指令
               " WHERE ",g_wc CLIPPED
   PREPARE i250_p1 FROM g_sql                  # RUNTIME 編譯
   DECLARE i250_co CURSOR FOR i250_p1
 
   LET g_rlang = g_lang                               
 
   FOREACH i250_co INTO l_occa.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) 
         EXIT FOREACH
      END IF
   END FOREACH
 
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN
          CALL cl_wcchp(g_wc,
          'occa00,  occano  ,occa01 ,occa02,occa18,occa19, 
          #occa1001,occa1002,occa11 ,occa37,occa28,occa34,   #MOD-CC0094 mark
           occa11 ,occa37,occa28,occa34,                     #MOD-CC0094 add 
           occa66,  occa1005,
           occa1004,occa10,  occa06, occa09 ,occa07,occa03,occa04,
           occa56,  occa57,  occa31 ,occa65,  
           occa22,  occa21,  occa20 ,#occa35, #CHI-A80050 mark occa35
          #occa231, occa232, occa233, #CHI-A80050 mark
          #occa241, occa242, occa243, #CHI-A80050 mark
           occa261, occa262, occa263,occa271,occa272,
           occa29,  occa30,  occa292,occa302,
           occa35, #CHI-A80050 add
           occa231, occa232, occa233, #CHI-A80050 add
           occa241, occa242, occa243, #CHI-A80050 add
           occa40,  occa38,  occa39,
           occa42,  occa41,  occa08,  occa44,  occa45,
           occa67,  occa43,  occa55,  occa47,
           occa48,  occa49,  occa50,
           occa46,  occa53,  occa32,  occa51,  occa52, 
           occa701, occa702, occa703, occa704,
           occa12,  occa13,  occa14,  occa15,  occa05,
           occa62,occa33,occa61,occa36,occa175,occa631,occa63,occa64,
           occa1003,occa1006,occa1007,occa1008,occa1009,
           occa1010,occa1011,occa1012,occa1013,occa1014,
           occa1015,occa1016,occa1027,
           occauser,occagrup,occamodu,occadate,occaacti')
           RETURNING g_str    #MOD-B50177
          #RETURNING g_wc     #MOD-B50177
          #LET g_str = g_wc   #MOD-B50177   
    END IF
    LET g_str = g_str
 
   CALL cl_prt_cs1('axmi250','axmi250',g_sql,g_str)  
 
   CLOSE i250_co
   ERROR ""
 
END FUNCTION
 
FUNCTION i250_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
    #CHI-A80050 mark --start--
    #IF g_occa.occa00='I' THEN #新增
    #   CALL cl_set_comp_entry("occa02,occa18,occa19,occa11",TRUE)
    #   CALL cl_set_comp_entry("occa1001,occa1002,occa37,occa28,occa34",TRUE)
    #   CALL cl_set_comp_entry("occa66,occa1005",TRUE)
    #   CALL cl_set_comp_entry("occa06,occa09,occa07,occa03,occa04",TRUE)
    #   CALL cl_set_comp_entry("occa56,occa57,occa31,occa65",TRUE)
    #   CALL cl_set_comp_entry("occa22,occa21,occa20,occa35",TRUE)
    #   CALL cl_set_comp_entry("occa231,occa232,occa233",TRUE)
    #   CALL cl_set_comp_entry("occa241,occa242,occa243",TRUE)
    #   CALL cl_set_comp_entry("occa261,occa262,occa263,occa271,occa272",TRUE)
    #   CALL cl_set_comp_entry("occa29,occa30,occa292,occa302",TRUE)
    #   CALL cl_set_comp_entry("occa40,occa38,occa39",TRUE)
    #   CALL cl_set_comp_entry("occa42,occa41,occa08,occa44,occa45",TRUE)
    #   CALL cl_set_comp_entry("occa67,occa43,occa55,occa47",TRUE)
    #   CALL cl_set_comp_entry("occa48,occa49,occa50",TRUE)
    #   CALL cl_set_comp_entry("occa46,occa53,occa32,occa51,occa52",TRUE)
    #   CALL cl_set_comp_entry("occa701,occa702,occa703,occa704",TRUE)
    #   CALL cl_set_comp_entry("occa12,occa13,occa14,occa15,occa05",TRUE)
    #   CALL cl_set_comp_entry("occa1003,occa1006,occa1007,occa1008,occa1009",TRUE)
    #   CALL cl_set_comp_entry("occa1010,occa1011,occa1012,occa1013,occa1014",TRUE)
    #   CALL cl_set_comp_entry("occa1015,occa1016,occa1027",TRUE)
    #   CALL cl_set_comp_entry("occa02,occa18,occa19",TRUE) #CHI-840028
    #END IF
    #CHI-A80050 mark --start--
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("occa00,occano,occa01",TRUE)
    END IF
 
    IF INFIELD(occa06) OR ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("occa09,occa07",TRUE)
    END IF

    #CHI-A80050 add --start--
    IF INFIELD(occa01) OR NOT g_before_input_done THEN
       CALL cl_set_comp_entry("occa02,occa18,occa19",TRUE)
    END IF        
    #CHI-A80050 add --end--
 
END FUNCTION
 
FUNCTION i250_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
  DEFINE l_cnt   LIKE type_file.num5 #CHI-A80050 add
 
    IF g_occa.occa00='U' OR g_input_custno = 'Y' THEN #修改 #CHI-840028 add OR g_input_custno = 'Y' 的判斷
      #CHI-A80050 mark --start--
      # CALL cl_set_comp_entry("occa11,occa1001,occa1002,occa37,occa28,occa34",FALSE)
      # CALL cl_set_comp_entry("occa66,occa1005",FALSE)
      # CALL cl_set_comp_entry("occa1004,occa06,occa09,occa07,occa03,occa04",FALSE)
      # CALL cl_set_comp_entry("occa56,occa57,occa31,occa65",FALSE)
      # CALL cl_set_comp_entry("occa22,occa21,occa20,occa35",FALSE)
      # CALL cl_set_comp_entry("occa231,occa232,occa233",FALSE)
      # CALL cl_set_comp_entry("occa241,occa242,occa243",FALSE)
      # CALL cl_set_comp_entry("occa261,occa262,occa263,occa271,occa272",FALSE)
      # CALL cl_set_comp_entry("occa29,occa30,occa292,occa302",FALSE)
      # CALL cl_set_comp_entry("occa40,occa38,occa39",FALSE)
      # CALL cl_set_comp_entry("occauser,occagrup,occamodu,occadate,occaacti",FALSE)
      # CALL cl_set_comp_entry("occa42,occa41,occa08,occa44,occa45",FALSE)
      # CALL cl_set_comp_entry("occa67,occa43,occa55,occa47",FALSE)
      # CALL cl_set_comp_entry("occa48,occa49,occa50",FALSE)
      # CALL cl_set_comp_entry("occa46,occa53,occa32,occa51,occa52",FALSE)
      # CALL cl_set_comp_entry("occa701,occa702,occa703,occa704",FALSE)
      # CALL cl_set_comp_entry("occa12,occa13,occa14,occa15,occa05",FALSE)
      # CALL cl_set_comp_entry("occa1003,occa1006,occa1007,occa1008,occa1009",FALSE)
      # CALL cl_set_comp_entry("occa1010,occa1011,occa1012,occa1013,occa1014",FALSE)
      # CALL cl_set_comp_entry("occa1015,occa1016,occa1027",FALSE)
      #CHI-A80050 mark --end--
      IF g_input_custno = 'Y' THEN
          CALL cl_set_comp_entry("occa02,occa18,occa19",FALSE)
      END IF
    END IF
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       #TQC-750007----mod---str-
       CALL cl_set_comp_entry("occa00,occano",FALSE)
       IF g_occa.occa00 = 'U' THEN #申請類別U:修改時,不能改客戶編號
           CALL cl_set_comp_entry("occa01",FALSE)
       END IF
    END IF
 
    IF INFIELD(occa06) OR ( NOT g_before_input_done ) OR g_occa.occa00='I' THEN   #MOD-960005
       IF g_occa.occa06 MATCHES '[12]' THEN
           CALL cl_set_comp_entry("occa09",FALSE) #MOD-4B0241
       END IF
 
       IF g_occa.occa06 MATCHES '[13]' THEN
           CALL cl_set_comp_entry("occa07",FALSE) #MOD-4B0241
       END IF
       IF g_aza.aza50='Y' AND g_occa.occa06 MATCHES '[1]' THEN
          CALL cl_set_comp_entry("occa07,occa09",TRUE)
       END IF
       IF g_occa.occa06 MATCHES '[4]' THEN
           CALL cl_set_comp_entry("occa1022",FALSE)
       END IF
    END IF
   #TQC-C70076 -- add -- begin
    IF p_cmd = 'u' AND g_occa.occa00 = 'U' THEN
       CALL cl_set_comp_entry("occa02",FALSE)
    END IF
   #TQC-C70076 -- add -- end
    #No.FUN-BB0049  --Begin
    ##CHI-A80050 add --start--
    ##No.TQC-BB0002  --Begin
    ##IF p_cmd = 'a' THEN
    #IF g_occa.occa00 = 'I' THEN
    ##No.TQC-BB0002  --End
    #   IF INFIELD(occa01) AND NOT cl_null(g_occa.occa01) THEN
    #      #客戶編號和廠商編號相同時,要求簡稱也要一致,新增時會鎖簡稱字段
    #      SELECT COUNT(*) INTO l_cnt FROM pmc_file 
    #       WHERE pmc01 = g_occa.occa01
    #      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
    #      IF l_cnt > 0 AND NOT (g_occa.occa01 MATCHES 'MISC*' OR g_occa.occa01 MATCHES 'EMPL*') THEN   #No.TQC-BB0002
    #         CALL cl_set_comp_entry('occa02',FALSE)
    #      END IF
    #   END IF
    #END IF
    ##CHI-A80050 add --end--
    #No.FUN-BB0049  --End  
    #MOD-C70144 add beg---
#    IF g_occa.occa00='U' THEN #TQC-C70218 mark
#       CALL cl_set_comp_entry("occa02",FALSE)
#    END IF 
    #MOD-C70144 add end---- 
END FUNCTION
 
FUNCTION i250_set_required(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
 
  IF NOT g_before_input_done OR INFIELD(occa06) THEN
     IF g_occa.occa06 MATCHES '[13]' THEN
        CALL cl_set_comp_required("occa41,occa43,occa44",TRUE) #MOD-5A0173 add
     END IF
  END IF
END FUNCTION
 
FUNCTION i250_set_no_required(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
 
  IF NOT g_before_input_done OR INFIELD(occa06) THEN
     CALL cl_set_comp_required("occa41,occa43,occa44",FALSE) #MOD-5A0173 add
  END IF
            IF cl_chk_act_auth() THEN
  END IF
END FUNCTION
 
#CHI-A80050 mark --start--
#FUNCTION i250_require_check()
#   DEFINE l_occa01 LIKE occa_file.occa01
#    
#   IF (g_occa.occa01 IS NULL) THEN
#      CALL cl_err('',-400,0)
#      RETURN 
#   END IF
#   IF g_occa.occaacti='N' THEN 
#      CALL cl_err('','mfg0301',1)
#      RETURN
#   END IF
#   
#   IF g_occa.occa1004!='1' THEN
#      CALL cl_err('','atm-046',1)
#      RETURN
#   END IF
# 
#  IF g_occa.occa06 MATCHES '[1]' THEN
#   SELECT count(*) INTO g_cnt
#     FROM tqk_file
#    WHERE tqk01=g_occa.occa01
#   IF g_cnt=0 THEN
#      CALL cl_err(g_occa.occa01,'atm-050',0)
#      RETURN
#   END IF
#  END IF
# 
#   IF g_occa.occa06 MATCHES '[12]' THEN
#      SELECT COUNT(*) INTO g_cnt
#        FROM ocd_file
#       WHERE ocd01=g_occa.occa01
#      IF g_cnt=0 THEN
#         CALL cl_err(g_occa.occa01,'atm-049',0)
#         RETURN
#      END IF
#   END IF
# 
#  IF g_occa.occa06 MATCHES '[1]' THEN 
#   IF cl_null(g_occa.occa1021) THEN
#      CALL cl_err(g_occa.occa1021,'atm-051',0)
#      RETURN
#   END IF
#      
#   IF cl_null(g_occa.occa42) THEN
#      CALL cl_err(g_occa.occa42,'atm-062',0)
#      RETURN
#   END IF
# 
#   IF cl_null(g_occa.occa41) THEN
#      CALL cl_err(g_occa.occa41,'atm-063',0)
#      RETURN
#   END IF
# 
#   IF cl_null(g_occa.occa08) THEN
#      CALL cl_err(g_occa.occa08,'atm-064',0)
#      RETURN
#   END IF
# 
# 
#   IF cl_null(g_occa.occa1022) THEN
#      CALL cl_err(g_occa.occa1022,'atm-066',0)
#      RETURN
#   END IF
# 
#   IF cl_null(g_occa.occa1024) THEN
#      CALL cl_err(g_occa.occa1024,'atm-068',0)
#      RETURN
#   END IF
# 
#   IF cl_null(g_occa.occa1025) THEN
#      CALL cl_err(g_occa.occa1025,'atm-069',0)
#      RETURN
#   END IF
#  END IF
# 
#   IF NOT cl_confirm('atm-232') THEN RETURN END IF    
#   BEGIN WORK
# 
#   OPEN i250_cl USING g_occa.occano                                            
#   IF STATUS THEN                                                               
#       CALL cl_err("OPEN i250_cl:", STATUS, 1)                                  
#       CLOSE i250_cl                                                            
#       ROLLBACK WORK                                                            
#       RETURN                                                                   
#   END IF                                                                       
#   FETCH i250_cl INTO g_occa.*                                                
#   IF SQLCA.sqlcode THEN                                                        
#      CALL cl_err('',SQLCA.sqlcode,1)                                           
#      RETURN                                                                    
#   END IF                                     
#   CALL i250_show()
#   LET g_chr=g_occa.occa1004
#   IF g_occa.occa1004='1' THEN
#      LET g_occa.occa1004='2'
#   END IF
#   UPDATE occa_file 
#      SET occa1004=g_occa.occa1004
#    WHERE occano = g_occa.occano
#   IF SQLCA.SQLERRD[3]=0 THEN                                                 
#      CALL cl_err3("upd","occa_file",g_occa.occa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
#      LET g_occa.occa1004=g_chr                                              
#     DISPLAY BY NAME g_occa.occa1004                                         
#     END IF                                                                     
#  CLOSE i250_cl     
#  COMMIT WORK
#  CALL i250_show()
#END FUNCTION
# 
#    
#FUNCTION i250_cancel_check()
#   DEFINE l_occa01 LIKE occa_file.occa01
#    
#   IF (g_occa.occa01 IS NULL) THEN
#      CALL cl_err('',-400,0)
#      RETURN 
#   END IF
#   IF g_occa.occaacti='N' THEN 
#      CALL cl_err('','mfg0301',1)
#      RETURN
#   END IF
#  
#  #非申請狀態不能取消申請
#   IF g_occa.occa1004!='2' THEN
#      CALL cl_err('','atm-052',1)
#      RETURN
#   END IF
#   
#   IF NOT cl_confirm('atm-233') THEN RETURN END IF    #lyl
#   BEGIN WORK
# 
#   OPEN i250_cl USING g_occa.occano                                            
#   IF STATUS THEN                                                               
#       CALL cl_err("OPEN i250_cl:", STATUS, 1)                                  
#       CLOSE i250_cl                                                            
#       ROLLBACK WORK                                                            
#       RETURN                                                                   
#   END IF                                                                       
#   FETCH i250_cl INTO g_occa.*                                                
#   IF SQLCA.sqlcode THEN                                                        
#      CALL cl_err('',SQLCA.sqlcode,1)                                           
#      RETURN                                                                    
#   END IF                                     
#   CALL i250_show()
#   LET g_chr=g_occa.occa1004
#   IF g_occa.occa1004='2' THEN
#      LET g_occa.occa1004='1'
#   END IF
#   UPDATE occa_file 
#      SET occa1004=g_occa.occa1004
#    WHERE occano = g_occa.occano
#   IF SQLCA.SQLERRD[3]=0 THEN                                                 
#      CALL cl_err3("upd","occa_file",g_occa.occa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
#      LET g_occa.occa1004=g_chr                                              
#     DISPLAY BY NAME g_occa.occa1004                                         
#     END IF                                                                     
#  CLOSE i250_cl     
#  LET g_chr='N'
#  LET g_chr1='N'
#  LET g_chr2='N'
#  IF g_occa.occa1004='3' THEN                                                                                                       
#       LET g_chr='Y'                                                                                                              
#  END IF                                                                                                                          
#  IF g_occa.occa1004='2' THEN
#      LET g_chr1='Y'
#  END IF
#  IF g_occa.occa1004='4' THEN
#      LET g_chr2='Y'
#  END IF
#  CALL cl_set_field_pic1(g_chr,"","","","",g_occa.occaacti,g_chr1,g_chr2)
#  COMMIT WORK
#  CALL i250_show()
#END FUNCTION
#CHI-A80050 mark --end--
 
FUNCTION i250_y_chk()
   DEFINE l_occa01     LIKE   occa_file.occa01
   DEFINE l_tqo01      LIKE   tqo_file.tqo01 
   DEFINE l_tqk01      LIKE   tqk_file.tqk01
   DEFINE l_n          LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
   LET g_success = 'Y'
 
   IF (g_occa.occano IS NULL) THEN
       CALL cl_err('',-400,0)
       LET g_success = 'N'
       RETURN 
   END IF
   IF g_occa.occaacti='N' THEN 
       CALL cl_err('','mfg0301',1)
       LET g_success = 'N'
       RETURN
   END IF
   IF g_occa.occa1004='1' THEN
       #已核准
       CALL cl_err('','mfg3212',1)
       LET g_success = 'N'
       RETURN
   END IF
   IF g_occa.occa1004='2' THEN
       #已拋轉，不可再異動!
       CALL cl_err(g_occa.occano,'axm-225',1)
       LET g_success = 'N'
       RETURN
   END IF
 
  IF g_occa.occa06 MATCHES '[1]' THEN
      IF cl_null(g_occa.occa42) THEN                                                 
          CALL cl_err(g_occa.occa42,'atm-062',1)                                      
          LET g_success = 'N'
      END IF                                                                       
      IF cl_null(g_occa.occa41) THEN                                                 
          CALL cl_err(g_occa.occa41,'atm-063',1)                                      
          LET g_success = 'N'
      END IF                                                                       
      IF cl_null(g_occa.occa08) THEN                                                 
          CALL cl_err(g_occa.occa08,'atm-064',1)                                      
          LET g_success = 'N'
      END IF                                                                       
  END IF
 
END FUNCTION
 
FUNCTION i250_y_upd()
DEFINE l_gew03   LIKE gew_file.gew03   #CHI-A80023 add
DEFINE l_gev04   LIKE gev_file.gev04   #CHI-A80023 add

   LET g_success = 'Y'
 
   IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
      g_action_choice CLIPPED = "insert"     #FUN-640184 
   THEN 
      IF g_occa.occa10='Y' THEN            #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
         IF g_occa.occa1004 != '1' THEN
            #此狀況碼不為「1.已核准」，不可確認!!
            CALL cl_err('','aws-078',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      IF NOT cl_confirm('axm-108') THEN RETURN END IF  #詢問是否執行確認功能
   END IF
 
  BEGIN WORK
  OPEN i250_cl USING g_occa.occano                                            
  IF STATUS THEN                                                               
      CALL cl_err("OPEN i250_cl:", STATUS, 1)                                  
      CLOSE i250_cl                                                            
      ROLLBACK WORK                                                            
      RETURN                                                                   
  END IF                                                                       
  FETCH i250_cl INTO g_occa.*                                                
  IF SQLCA.sqlcode THEN                                                        
     CALL cl_err('',SQLCA.sqlcode,1)                                           
     RETURN                                                                    
  END IF                                     
  CALL i250_show()
  LET g_chr = g_occa.occa1004
  UPDATE occa_file 
     SET occa1004='1' #1:已核准
   WHERE occano = g_occa.occano
  IF SQLCA.SQLERRD[3]=0 THEN                                                 
      CALL cl_err3("upd","occa_file",g_occa.occano,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
      LET g_occa.occa1004=g_chr                                              
      DISPLAY BY NAME g_occa.occa1004                                         
  END IF                                                                     
  CLOSE i250_cl      
  COMMIT WORK
   SELECT * INTO g_occa.* FROM occa_file
    WHERE occano = g_occa.occano
  CALL i250_show()
   IF g_success = 'Y' THEN
      IF g_occa.occa10 = 'Y' THEN  #簽核模式
         CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
              WHEN 0  #呼叫 EasyFlow 簽核失敗
                  #LET g_pmk.pmk18="N"
                   LET g_success = "N"
                   ROLLBACK WORK
                   RETURN
              WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                  #LET g_pmk.pmk18="N"
                   ROLLBACK WORK
                   RETURN
         END CASE
      END IF
      IF g_success='Y' THEN
         LET g_occa.occa1004='1'          #執行成功, 狀態值顯示為 '1' 已核准
         COMMIT WORK
         CALL cl_flow_notify(g_occa.occano,'Y')
         DISPLAY BY NAME g_occa.occa1004
      ELSE
         LET g_success = 'N'
         ROLLBACK WORK
      END IF
   ELSE
      LET g_success = 'N'
      ROLLBACK WORK
   END IF
 
   #CKP
   CALL i250_show_pic() #圖示

   #CHI-A80023 add --start--
   SELECT gev04 INTO l_gev04 FROM gev_file
    WHERE gev01 = '4' and gev02 = g_plant
   SELECT UNIQUE gew03 INTO l_gew03 FROM gew_file
    WHERE gew01 = l_gev04
      AND gew02 = '4'
   IF l_gew03 = '1' THEN
      IF cl_null(g_occa.occa01) THEN
         CALL cl_err(g_occa.occano,'axm-267','1')
      ELSE
         CALL i250_dbs(g_occa.*)
         SELECT * INTO g_occa.* FROM occa_file WHERE occano = g_occa.occano 
         CALL i250_show()
      END IF
   END IF
   #CHI-A80023 add --end--
END FUNCTION
 
FUNCTION i250_z()
   DEFINE l_occa01 LIKE occa_file.occa01
    
   IF (g_occa.occano IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN 
   END IF
   IF g_occa.occaacti='N' THEN 
      CALL cl_err('','mfg0301',1)
      RETURN
   END IF
   IF g_occa.occa1004 = 'S' THEN
      #送簽中, 不可修改資料!
      CALL cl_err(g_occa.occano,'apm-030',1)
      RETURN
   END IF
   #非審核狀態 不能取消審核
   IF g_occa.occa1004 !='1' THEN
      CALL  cl_err('','atm-053',1)
      RETURN
   END IF
   
   IF NOT cl_confirm('aim-302') THEN RETURN END IF    #是否確定執行取消確認(Y/N)?
   BEGIN WORK
 
   OPEN i250_cl USING g_occa.occano                                            
   IF STATUS THEN                                                               
       CALL cl_err("OPEN i250_cl:", STATUS, 1)                                  
       CLOSE i250_cl                                                            
       ROLLBACK WORK                                                            
       RETURN                                                                   
   END IF                                                                       
   FETCH i250_cl INTO g_occa.*                                                
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err('',SQLCA.sqlcode,1)                                           
      RETURN                                                                    
   END IF                                     
   CALL i250_show()
   LET g_chr=g_occa.occa1004
   UPDATE occa_file 
      SET occa1004='0' #0:開立
    WHERE occano = g_occa.occano
   IF SQLCA.SQLERRD[3]=0 THEN                                                 
       CALL cl_err3("upd","occa_file",g_occa.occano,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       LET g_occa.occa1004=g_chr                                              
       DISPLAY BY NAME g_occa.occa1004                                         
   END IF                                                                     
   CLOSE i250_cl     
   SELECT * INTO g_occa.* FROM occa_file WHERE occano = g_occa.occano
   COMMIT WORK
   CALL i250_show()
END FUNCTION
 
FUNCTION i250_hang()
   DEFINE l_occa01 LIKE occa_file.occa01
    
   IF (g_occa.occa01 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN 
   END IF
   IF g_occa.occaacti='N' THEN 
      CALL cl_err('','mfg0301',1)
      RETURN
   END IF
   IF g_occa.occa1004 !='3' THEN
      CALL cl_err('','atm-053',1)
      RETURN
   END IF
 
   IF NOT cl_confirm('atm-236') THEN RETURN END IF    #lyl
 
   BEGIN WORK
 
   OPEN i250_cl USING g_occa.occano                                            
   IF STATUS THEN                                                               
       CALL cl_err("OPEN i250_cl:", STATUS, 1)                                  
       CLOSE i250_cl                                                            
       ROLLBACK WORK                                                            
       RETURN                                                                   
   END IF                                                                       
   FETCH i250_cl INTO g_occa.*                                                
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err('',SQLCA.sqlcode,1)                                           
      RETURN                                                                    
   END IF                                     
   CALL i250_show()
   LET g_chr=g_occa.occa1004
   IF g_occa.occa1004='3' THEN
      LET g_occa.occa1004='4'
   END IF
   UPDATE occa_file 
      SET occa1004=g_occa.occa1004
    WHERE occano = g_occa.occano
   IF SQLCA.SQLERRD[3]=0 THEN                                                 
      CALL cl_err3("upd","occa_file",g_occa.occa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
      LET g_occa.occa1004=g_chr                                              
     DISPLAY BY NAME g_occa.occa1004                                         
     END IF                                                                     
  CLOSE i250_cl     
  LET g_chr='N'
  LET g_chr1='N'
  LET g_chr2='N'
  IF g_occa.occa1004='3' THEN                                                                                                         
       LET g_chr='Y'                                                                                                                
  END IF                                                                                                                            
  IF g_occa.occa1004='2' THEN
     LET g_chr1='Y'
  END IF
  IF g_occa.occa1004='4' THEN
     LET g_chr2='Y'
  END IF
  CALL cl_set_field_pic1(g_chr,"","","","",g_occa.occaacti,g_chr1,g_chr2)
  COMMIT WORK
  CALL i250_show()
END FUNCTION
 
FUNCTION i250_unhang()
   DEFINE l_occa01 LIKE occa_file.occa01
    
   IF (g_occa.occa01 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN 
   END IF
   IF g_occa.occaacti='N' THEN 
      CALL cl_err('','mfg0301',1)
      RETURN
   END IF
   IF g_occa.occa1004!='4' THEN 
      CALL cl_err('','atm-054',1)
      RETURN
   END IF
 
   IF NOT cl_confirm('atm-237') THEN RETURN END IF    #lyl
   BEGIN WORK
 
   OPEN i250_cl USING g_occa.occano                                            
   IF STATUS THEN                                                               
       CALL cl_err("OPEN i250_cl:", STATUS, 1)                                  
       CLOSE i250_cl                                                            
       ROLLBACK WORK                                                            
       RETURN                                                                   
   END IF                                                                       
   FETCH i250_cl INTO g_occa.*                                                
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err('',SQLCA.sqlcode,1)                                           
      RETURN                                                                    
   END IF                                     
   CALL i250_show()
   LET g_chr=g_occa.occa1004
   IF g_occa.occa1004='4' THEN
      LET g_occa.occa1004='3'
   END IF
   UPDATE occa_file 
      SET occa1004=g_occa.occa1004
    WHERE occano = g_occa.occano
   IF SQLCA.SQLERRD[3]=0 THEN                                                 
      CALL cl_err3("upd","occa_file",g_occa.occa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
      LET g_occa.occa1004=g_chr                                              
     DISPLAY BY NAME g_occa.occa1004                                         
     END IF                                                                     
  CLOSE i250_cl     
  LET g_chr='N'
  LET g_chr1='N'
  LET g_chr2='N'
  IF g_occa.occa1004='3' THEN                                                                                                         
       LET g_chr='Y'                                                                                                                
  END IF                                                                                                                            
  IF g_occa.occa1004='2' THEN
      LET g_chr1='Y'
  END IF
  IF g_occa.occa1004='4' THEN
      LET g_chr2='Y'
  END IF
  CALL cl_set_field_pic1(g_chr,"","","","",g_occa.occaacti,g_chr1,g_chr2)
  COMMIT WORK
  CALL i250_show()
END FUNCTION
 
FUNCTION i250_untransaction()
   DEFINE l_occa01 LIKE occa_file.occa01
    
   IF (g_occa.occa01 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN 
   END IF
   IF g_occa.occaacti='N' THEN 
      CALL cl_err('','mfg0301',1)
      RETURN
   END IF
   IF g_occa.occa1004!='3' THEN 
      CALL cl_err('','atm-053',1)
      RETURN
   END IF
 
   IF NOT cl_confirm('atm-055') THEN RETURN END IF    #lyl
   BEGIN WORK
 
   OPEN i250_cl USING g_occa.occano                                            
   IF STATUS THEN                                                               
       CALL cl_err("OPEN i250_cl:", STATUS, 1)                                  
       CLOSE i250_cl                                                            
       ROLLBACK WORK                                                            
       RETURN                                                                   
   END IF                                                                       
   FETCH i250_cl INTO g_occa.*                                                
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err('',SQLCA.sqlcode,1)                                           
      RETURN                                                                    
   END IF                                     
   CALL i250_show()
   LET g_chr=g_occa.occa1004
   IF g_occa.occa1004='3' THEN
      LET g_occa.occa1004='5'
   END IF
   UPDATE occa_file 
      SET occa1004=g_occa.occa1004
    WHERE occano = g_occa.occano
   IF SQLCA.SQLERRD[3]=0 THEN                                                 
      CALL cl_err3("upd","occa_file",g_occa.occa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
      LET g_occa.occa1004=g_chr                                              
     DISPLAY BY NAME g_occa.occa1004                                         
     END IF                                                                     
  LET g_chr='N'
  LET g_chr1='N'
  LET g_chr2='N'
  IF g_occa.occa1004='3' THEN                                                                                                         
       LET g_chr='Y'                                                                                                                
  END IF                                                                                                                            
  IF g_occa.occa1004='2' THEN
      LET g_chr1='Y'
  END IF
  IF g_occa.occa1004='4' THEN
      LET g_chr2='Y'
  END IF
  CALL cl_set_field_pic1(g_chr,"","","","",g_occa.occaacti,g_chr1,g_chr2)
  CLOSE i250_cl     
  COMMIT WORK
  CALL i250_show()
END FUNCTION
 
FUNCTION i250_transaction()
   DEFINE l_occa01 LIKE occa_file.occa01
    
   IF (g_occa.occa01 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN 
   END IF
   IF g_occa.occaacti='N' THEN 
      CALL cl_err('','mfg0301',1)
      RETURN
   END IF
   IF g_occa.occa1004!='5' THEN 
      CALL cl_err('','atm-057',1)
      RETURN
   END IF
 
   IF NOT cl_confirm('atm-056') THEN RETURN END IF    #lyl
   BEGIN WORK
 
   OPEN i250_cl USING g_occa.occano                                            
   IF STATUS THEN                                                               
       CALL cl_err("OPEN i250_cl:", STATUS, 1)                                  
       CLOSE i250_cl                                                            
       ROLLBACK WORK                                                            
       RETURN                                                                   
   END IF                                                                       
   FETCH i250_cl INTO g_occa.*                                                
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err('',SQLCA.sqlcode,1)                                           
      RETURN                                                                    
   END IF                                     
   CALL i250_show()
   LET g_chr=g_occa.occa1004
   IF g_occa.occa1004='5' THEN
      LET g_occa.occa1004='3'
   END IF
   UPDATE occa_file 
      SET occa1004=g_occa.occa1004
    WHERE occano = g_occa.occano
   IF SQLCA.SQLERRD[3]=0 THEN                                                 
      CALL cl_err3("upd","occa_file",g_occa.occa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
      LET g_occa.occa1004=g_chr                                              
     DISPLAY BY NAME g_occa.occa1004                                         
     END IF                                                                     
  LET g_chr='N'
  LET g_chr1='N'
  LET g_chr2='N'
  IF g_occa.occa1004='3' THEN                                                                                                         
       LET g_chr='Y'                                                                                                                
  END IF                                                                                                                            
  IF g_occa.occa1004='2' THEN
      LET g_chr1='Y'
  END IF
  IF g_occa.occa1004='4' THEN
      LET g_chr2='Y'
  END IF
  CALL cl_set_field_pic1(g_chr,"","","","",g_occa.occaacti,g_chr1,g_chr2)
  CLOSE i250_cl     
  COMMIT WORK
  CALL i250_show()
END FUNCTION
 
 
#經營品類、經營系列
FUNCTION i250_8(p_occa01,p_tql03)
   DEFINE l_tql DYNAMIC ARRAY OF RECORD
                tql02 LIKE tql_file.tql02,
                tql04 LIKE tql_file.tql04,
                tqa02 LIKE tqa_file.tqa02
                END RECORD,
        l_tql_t RECORD
                tql02 LIKE tql_file.tql02,
                tql04 LIKE tql_file.tql04,
                tqa02 LIKE tqa_file.tqa02
                END RECORD,
        l_occa1004   LIKE occa_file.occa1004,
        l_occaacti   LIKE occa_file.occaacti,
        l_allow_insert    LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(01)
        l_allow_delete    LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(01)
        p_cmd             LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
        l_rec_b           LIKE type_file.num5,    #No.FUN-680137 SMALLINT
        p_occa01           LIKE occa_file.occa01,
        p_tql03           LIKE tql_file.tql03,
        i,l_ac,l_ac_t,l_n LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
   IF cl_null(p_occa01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET p_row = 11 LET p_col = 3
   OPEN WINDOW i250_8_w AT p_row,p_col WITH FORM "axm/42f/axmi250_8"
     ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_locale("axmi250_8")
   IF p_tql03 = '3' THEN
      CALL cl_set_comp_att_text("tql04",cl_getmsg('atm-058',g_lang))
   END IF
   LET g_sql = " SELECT tql02,tql04,tqa02 ",
               "   FROM tql_file,tqa_file ",
               "  WHERE tql01 = '",p_occa01,"' ",
               "    AND tql03 = '",p_tql03,"' ",
               "    AND tql04 = tqa01 ",
               "    AND tql03 = tqa03 ",
               "  ORDER BY tql02 "
   PREPARE i250_8_pb FROM g_sql
   DECLARE tql_curs CURSOR FOR i250_8_pb
   CALL l_tql.clear()
   LET i = 1
   LET l_rec_b = 0
   FOREACH tql_curs INTO l_tql[i].*
      IF STATUS THEN 
         CALL cl_err('foreach tql',STATUS,0) 
         EXIT FOREACH 
      END IF 
      LET i = i + 1
      IF i > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL l_tql.deleteElement(i)
   LET l_rec_b = i-1
   DISPLAY l_rec_b TO FORMONLY.cn2
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY l_tql TO s_tql.* ATTRIBUTE(COUNT=l_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         LET l_ac = ARR_CURR() 
         
      ON ACTION accept
 
          SELECT occaacti INTO l_occaacti
            FROM occa_file
           WHERE occa01=p_occa01
          IF l_occaacti='N' THEN
             CALL cl_err('','mfg0301',1)
             RETURN
          END IF
 
         #判斷若客戶已審核則不允許進入單身進行相應的動作               051024
          SELECT occa1004 INTO l_occa1004
            FROM occa_file
           WHERE occa01=p_occa01
           IF l_occa1004!='1' THEN
              CALL cl_err(p_occa01,'atm-046',1)
              RETURN
           END IF
                    
 
          CALL cl_set_act_visible("accept,cancel", TRUE)
          LET g_forupd_sql = " SELECT tql02,tql04,tqa02 ",
                             "   FROM tql_file,tqa_file ",
                             "  WHERE tql01 = ?  ",
                             "   AND tql02 = ? ",
                             "   AND tql03 = ? ",
                             "   AND tql04 = tqa01 ",
                             "   AND tql03 = tqa03 ",
                             " ORDER by tql02 ",
                             " FOR UPDATE "
         LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
         DECLARE i250_8_bc1 CURSOR FROM g_forupd_sql 
         LET l_allow_insert = cl_detail_input_auth("insert")
         LET l_allow_delete = cl_detail_input_auth("delete")
         INPUT ARRAY l_tql WITHOUT DEFAULTS FROM s_tql.* 
            ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                 APPEND ROW=l_allow_insert)
 
         BEFORE INPUT
               
            IF l_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            
         BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            BEGIN WORK
            IF l_rec_b >= l_ac THEN 
               LET p_cmd = 'u'
               LET l_tql_t.* = l_tql[l_ac].* 
               OPEN i250_8_bc1 USING p_occa01,l_tql_t.tql02,p_tql03
               IF STATUS THEN
                  CALL cl_err("OPEN i250_8_bc1:", STATUS, 1)
               ELSE
                  FETCH i250_8_bc1 INTO l_tql[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(l_tql_t.tql02,SQLCA.sqlcode,1)
                  END IF
               END IF
            END IF
 
         BEFORE INSERT
            LET p_cmd = 'a'
            INITIALIZE l_tql[l_ac].* TO NULL
            LET l_tql_t.* = l_tql[l_ac].* 
            NEXT FIELD tql02 
 
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO tql_file(tql01,tql02,tql03,tql04)
               VALUES(p_occa01,l_tql[l_ac].tql02,p_tql03,
                                    l_tql[l_ac].tql04)
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","tql_file",p_occa01,l_tql[l_ac].tql02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT O.K'
                  LET l_rec_b=l_rec_b+1
                  DISPLAY l_rec_b TO FORMONLY.cn2  
                  COMMIT WORK
               END IF
    
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET l_tql[l_ac].* = l_tql_t.*
               CLOSE i250_8_bc1
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            UPDATE tql_file SET tql02 = l_tql[l_ac].tql02, 
                                tql04 = l_tql[l_ac].tql04
                            WHERE tql01 = p_occa01
                              AND tql02 = l_tql_t.tql02
                              AND tql03 = p_tql03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","tql_file",p_occa01,l_tql_t.tql02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET l_tql[l_ac].* = l_tql_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
   
         AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac 
            IF INT_FLAG THEN 
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET l_tql[l_ac].* = l_tql_t.*
               END IF
               CLOSE i250_8_bc1 
               ROLLBACK WORK 
               EXIT INPUT
            END IF
            CLOSE i250_8_bc1 
            COMMIT WORK
    
         BEFORE DELETE                            #是否取消單身
            IF l_tql_t.tql02 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               DELETE FROM tql_file 
                WHERE tql01 = p_occa01
                  AND tql02 = l_tql_t.tql02
                  AND tql03 = p_tql03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","tql_file",p_occa01,l_tql_t.tql02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  EXIT INPUT
               END IF
               LET l_rec_b=l_rec_b-1
               DISPLAY l_rec_b TO FORMONLY.cn2  
               COMMIT WORK
            END IF
 
         BEFORE FIELD tql02
            IF cl_null(l_tql[l_ac].tql02) OR l_tql[l_ac].tql02 = 0 THEN
               SELECT MAX(tql02)+1 INTO l_tql[l_ac].tql02
                 FROM tql_file
                WHERE tql01 = p_occa01
                  AND tql03 = p_tql03
               IF cl_null(l_tql[l_ac].tql02) THEN
                  LET l_tql[l_ac].tql02 = 1
               END IF
            END IF
 
         AFTER FIELD tql02
            IF NOT cl_null(l_tql[l_ac].tql02) THEN
               IF l_tql[l_ac].tql02 != l_tql_t.tql02
                             OR cl_null(l_tql_t.tql02) THEN
                  SELECT COUNT(*) INTO l_n
                    FROM tql_file
                   WHERE tql01 = p_occa01
                     AND tql02 = l_tql[l_ac].tql02
                     AND tql03 = p_tql03
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET l_tql[l_ac].tql02 = l_tql_t.tql02
                     NEXT FIELD tql02
                  END IF
               END IF
            END IF
 
         AFTER FIELD tql04
            IF NOT cl_null(l_tql[l_ac].tql04) THEN
               SELECT COUNT(*) INTO l_n FROM tqa_file        
                WHERE tqa01 = l_tql[l_ac].tql04 
                  AND tqa03 = p_tql03
               IF l_n = 0 THEN    
                  IF p_tql03 = '1' THEN
                     CALL cl_err('','atm-059',0)  
                  END IF
                  IF p_tql03 = '3' THEN
                     CALL cl_err('','atm-060',0)  
                  END IF
                  NEXT FIELD tql04
               END IF 
               IF (p_cmd = 'u' AND l_tql[l_ac].tql04 != l_tql_t.tql04 )
                                OR p_cmd = 'a' THEN 
                  SELECT COUNT(*) INTO l_n FROM tql_file
                   WHERE tql01 = p_occa01
                     AND tql03 = p_tql03
                     AND tql04 = l_tql[l_ac].tql04 
                  IF l_n > 0 THEN 
                     CALL cl_err('','axm-298',0)
                     NEXT FIELD tql04
                  END IF 
               END IF
               SELECT tqa02 INTO l_tql[l_ac].tqa02
                 FROM tqa_file     
                WHERE tqa01 = l_tql[l_ac].tql04 
                  AND tqa03 = p_tql03
            END IF
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(tql04)
                  CALL cl_init_qry_var() 
                  LET g_qryparam.form = "q_tqa"
                  LET g_qryparam.arg1 = p_tql03
                  LET g_qryparam.default1 = l_tql[l_ac].tql04
                  CALL cl_create_qry() RETURNING l_tql[l_ac].tql04
                  DISPLAY BY NAME l_tql[l_ac].tql04
                  NEXT FIELD tql04
               OTHERWISE EXIT CASE
            END CASE
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()               #No.FUN-590083
 
         ON IDLE g_idle_seconds                                                   
            CALL cl_on_idle()                                                     
            CONTINUE INPUT
 
         ON ACTION controlg 
            CALL cl_cmdask()
 
         ON ACTION about 
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) 
               RETURNING g_fld_name,g_frm_name
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
         ON ACTION CONTROLR 
            CALL cl_show_req_fields() 
 
      END INPUT
 
      ON ACTION detail
      
          SELECT occaacti INTO l_occaacti
            FROM occa_file
           WHERE occa01=p_occa01
          IF l_occaacti='N' THEN
             CALL cl_err('','mfg0301',1)
             RETURN
          END IF
 
         #判斷若客戶已審核則不允許進入單身進行相應的動作               051024
          SELECT occa1004 INTO l_occa1004
            FROM occa_file
           WHERE occa01=p_occa01
           IF l_occa1004!='1' THEN
              CALL cl_err(p_occa01,'atm-046',1)
              RETURN
           END IF
                    
 
          CALL cl_set_act_visible("accept,cancel", TRUE)
          LET g_forupd_sql = " SELECT tql02,tql04,tqa02 ",
                             "   FROM tql_file,tqa_file ",
                             "  WHERE tql01 = ?  ",
                             "   AND tql02 = ? ",
                             "   AND tql03 = ? ",
                             "   AND tql04 = tqa01 ",
                             "   AND tql03 = tqa03 ",
                             " ORDER by tql02 ",
                             " FOR UPDATE "
         LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
         DECLARE i250_8_bc2 CURSOR FROM g_forupd_sql 
         LET l_allow_insert = cl_detail_input_auth("insert")
         LET l_allow_delete = cl_detail_input_auth("delete")
         INPUT ARRAY l_tql WITHOUT DEFAULTS FROM s_tql.* 
            ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                 APPEND ROW=l_allow_insert)
 
         BEFORE INPUT
               
            IF l_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            
         BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            BEGIN WORK
            IF l_rec_b >= l_ac THEN 
               LET p_cmd = 'u'
               LET l_tql_t.* = l_tql[l_ac].* 
               OPEN i250_8_bc2 USING p_occa01,l_tql_t.tql02,p_tql03
               IF STATUS THEN
                  CALL cl_err("OPEN i250_8_bc2:", STATUS, 1)
               ELSE
                  FETCH i250_8_bc2 INTO l_tql[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(l_tql_t.tql02,SQLCA.sqlcode,1)
                  END IF
               END IF
            END IF
 
         BEFORE INSERT
            LET p_cmd = 'a'
            INITIALIZE l_tql[l_ac].* TO NULL
            LET l_tql_t.* = l_tql[l_ac].* 
            NEXT FIELD tql02 
 
         AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO tql_file(tql01,tql02,tql03,tql04)
               VALUES(p_occa01,l_tql[l_ac].tql02,p_tql03,
                                    l_tql[l_ac].tql04)
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","tql_file",p_occa01,l_tql[l_ac].tql02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT O.K'
                  LET l_rec_b=l_rec_b+1
                  DISPLAY l_rec_b TO FORMONLY.cn2  
                  COMMIT WORK
               END IF
    
         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET l_tql[l_ac].* = l_tql_t.*
               CLOSE i250_8_bc2
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            UPDATE tql_file SET tql02 = l_tql[l_ac].tql02, 
                                tql04 = l_tql[l_ac].tql04
                            WHERE tql01 = p_occa01
                              AND tql02 = l_tql_t.tql02
                              AND tql03 = p_tql03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","tql_file",p_occa01,l_tql_t.tql02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET l_tql[l_ac].* = l_tql_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
   
         AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac 
            IF INT_FLAG THEN 
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET l_tql[l_ac].* = l_tql_t.*
               END IF
               CLOSE i250_8_bc2 
               ROLLBACK WORK 
               EXIT INPUT
            END IF
            CLOSE i250_8_bc2 
            COMMIT WORK
    
         BEFORE DELETE                            #是否取消單身
            IF l_tql_t.tql02 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               DELETE FROM tql_file 
                WHERE tql01 = p_occa01
                  AND tql02 = l_tql_t.tql02
                  AND tql03 = p_tql03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","tql_file",p_occa01,l_tql_t.tql02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  EXIT INPUT
               END IF
               LET l_rec_b=l_rec_b-1
               DISPLAY l_rec_b TO FORMONLY.cn2  
               COMMIT WORK
            END IF
 
         BEFORE FIELD tql02
            IF cl_null(l_tql[l_ac].tql02) OR l_tql[l_ac].tql02 = 0 THEN
               SELECT MAX(tql02)+1 INTO l_tql[l_ac].tql02
                 FROM tql_file
                WHERE tql01 = p_occa01
                  AND tql03 = p_tql03
               IF cl_null(l_tql[l_ac].tql02) THEN
                  LET l_tql[l_ac].tql02 = 1
               END IF
            END IF
 
         AFTER FIELD tql02
            IF NOT cl_null(l_tql[l_ac].tql02) THEN
               IF l_tql[l_ac].tql02 != l_tql_t.tql02
                             OR cl_null(l_tql_t.tql02) THEN
                  SELECT COUNT(*) INTO l_n
                    FROM tql_file
                   WHERE tql01 = p_occa01
                     AND tql02 = l_tql[l_ac].tql02
                     AND tql03 = p_tql03
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET l_tql[l_ac].tql02 = l_tql_t.tql02
                     NEXT FIELD tql02
                  END IF
               END IF
            END IF
 
         AFTER FIELD tql04
            IF NOT cl_null(l_tql[l_ac].tql04) THEN
               SELECT COUNT(*) INTO l_n FROM tqa_file        
                WHERE tqa01 = l_tql[l_ac].tql04 
                  AND tqa03 = p_tql03
               IF l_n = 0 THEN    
                  IF p_tql03 = '1' THEN
                     CALL cl_err('','atm-059',0)  
                  END IF
                  IF p_tql03 = '3' THEN
                     CALL cl_err('','atm-060',0)  
                  END IF
                  NEXT FIELD tql04
               END IF 
               IF (p_cmd = 'u' AND l_tql[l_ac].tql04 != l_tql_t.tql04 )
                                OR p_cmd = 'a' THEN 
                  SELECT COUNT(*) INTO l_n FROM tql_file
                   WHERE tql01 = p_occa01
                     AND tql03 = p_tql03
                     AND tql04 = l_tql[l_ac].tql04 
                  IF l_n > 0 THEN 
                     CALL cl_err('','axm-298',0)
                     NEXT FIELD tql04
                  END IF 
               END IF
               SELECT tqa02 INTO l_tql[l_ac].tqa02
                 FROM tqa_file     
                WHERE tqa01 = l_tql[l_ac].tql04 
                  AND tqa03 = p_tql03
            END IF
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(tql04)
                  CALL cl_init_qry_var() 
                  LET g_qryparam.form = "q_tqa"
                  LET g_qryparam.arg1 = p_tql03
                  LET g_qryparam.default1 = l_tql[l_ac].tql04
                  CALL cl_create_qry() RETURNING l_tql[l_ac].tql04
                  DISPLAY BY NAME l_tql[l_ac].tql04
                  NEXT FIELD tql04
               OTHERWISE EXIT CASE
            END CASE
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()               #No.FUN-590083
 
         ON IDLE g_idle_seconds                                                   
            CALL cl_on_idle()                                                     
            CONTINUE INPUT
 
         ON ACTION controlg 
            CALL cl_cmdask()
 
         ON ACTION about 
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) 
               RETURNING g_fld_name,g_frm_name
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
         ON ACTION CONTROLR 
            CALL cl_show_req_fields() 
 
      END INPUT
    
      CLOSE i250_8_bc2 
      COMMIT WORK
 
      CALL cl_set_act_visible("accept,cancel", FALSE)
      CONTINUE DISPLAY
 
      ON ACTION exit
         EXIT DISPLAY
 
      ON ACTION controlg 
         CALL cl_cmdask()
 
       ON ACTION about 
          CALL cl_about()
 
       ON ACTION help
          CALL cl_show_help()
 
       ON IDLE g_idle_seconds                                                   
          CALL cl_on_idle()                                                     
          CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   
   LET INT_FLAG=0
   CLOSE WINDOW i250_8_w 
END FUNCTION 
 
FUNCTION i250_copy()
   DEFINE l_new_occano LIKE occa_file.occano
   DEFINE l_old_occano LIKE occa_file.occano
   DEFINE l_occa RECORD LIKE occa_file.*
   DEFINE l_cnt LIKE type_file.num10   #No.FUN-680137 INTEGER
   DEFINE l_n           LIKE type_file.num5   
   DEFINE li_result     LIKE type_file.num5   
   DEFINE l_occa01      LIKE occa_file.occa01   #MOD-C80143 add
   DEFINE l_occano      LIKE occa_file.occano   #MOD-C80143 add

   IF cl_null(g_occa.occano) THEN 
      CALL cl_err('',-400,1)
      RETURN 
   END IF
   IF s_shut(0) THEN RETURN END IF 
   
   LET g_before_input_done = FALSE
   CALL i250_set_entry('a')
   LET g_before_input_done = TRUE
 
   INPUT l_new_occano,l_occa01 FROM occano,occa01   #MOD-C80143 add occa01
 
         AFTER FIELD occano
             CALL s_check_no('axm',l_new_occano,"","09","occa_file","occano","") RETURNING li_result,l_new_occano
  	         DISPLAY l_new_occano TO occano 
             IF (NOT li_result) THEN
                  LET g_occa.occano=g_occa_t.occano
                  NEXT FIELD occano
             END IF
            #MOD-9C0435---add---start---
             LET g_t1=l_new_occano[1,g_doc_len]
             SELECT oayapr INTO g_occa.occa10
               FROM oay_file 
              WHERE oayslip = g_t1
             DISPLAY By NAME g_occa.occa10
            #MOD-9C0435---add---end---
         #MOD-C80143  -- add start --
         AFTER FIELD occa01
            IF g_occa.occa00 = 'I' THEN #新增
               LET l_n = 0
               SELECT count(*) INTO l_n FROM occa_file
                WHERE occa01 = l_occa01
               IF l_n > 0 THEN
                  CALL cl_err(l_occa01,-239,1)
                  NEXT FIELD occa01
               END IF
               LET l_n = 0
               SELECT count(*) INTO l_n FROM occa_file
                WHERE occa01 = l_occa01
                  AND occa00 = 'I' #新增
               IF l_n > 0 THEN
                  CALL cl_err(l_occa01,-239,1)
                  NEXT FIELD occa01
               END IF
            ELSE
               LET l_n = 0
               SELECT count(*) INTO l_n FROM occa_file
                WHERE occa01 = l_occa01
               IF l_n <= 0 THEN
                  #無此客戶編號, 請重新輸入!
                  CALL cl_err(l_occa01,'mfg2732',1)
                  NEXT FIELD occa01
               END IF
               LET l_occano = NULL
               SELECT occano INTO l_occano FROM occa_file
                WHERE occa01 = l_occa01
                  AND occa00 = 'U' #修改
                  AND occa1004 != '2'
                  AND occaacti != 'N'
               IF NOT cl_null(l_occano) THEN
                  #已存在一張相同客戶編號,但未拋轉的客戶申請單!
                  CALL cl_err(l_occano,'axm-227',1)
                  NEXT FIELD occa01
               END IF
            END IF
         #MOD-C80143  -- add end --

         AFTER INPUT
            #TQC-850019-begin-add
            IF cl_null(g_occa.occa01) AND g_occa.occa00<>'I' THEN 
               DISPLAY BY NAME g_occa.occa01
               NEXT FIELD occa01
            END IF
            #TQC-850019-end-add
            CALL s_auto_assign_no("axm",l_new_occano,g_today,"09","occa_file","occano","","","") RETURNING li_result,l_new_occano
            
      ON ACTION CONTROLP
           CASE
             WHEN INFIELD(occano)
                  CALL q_oay( FALSE,TRUE,g_t1,'09','AXM') RETURNING g_t1   
                  LET l_new_occano=g_t1               
                  DISPLAY BY NAME g_occa.occano
                  NEXT FIELD occano
             OTHERWISE EXIT CASE
           END CASE 
                   
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      #DISPLAY g_occa.occano TO g_occa.occano #TQC-AB0088 mark
       DISPLAY g_occa.occano TO occano #TQC-AB0088 add
      ROLLBACK WORK 
      RETURN
   END IF
   
   LET l_occa.* = g_occa.* 
   LET l_occa.occano=l_new_occano
   LET l_occa.occa1004 ='0'
   LET l_occa.occauser = g_user
   LET l_occa.occagrup = g_grup
   LET l_occa.occadate = g_today
   LET l_occa.occaacti = 'Y'
   
   BEGIN WORK    #NO.FUN-680010
 
   LET l_occa.occaoriu = g_user      #No.FUN-980030 10/01/04
   LET l_occa.occaorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO occa_file VALUES (l_occa.*)
   IF SQLCA.sqlcode OR (SQLCA.sqlerrd[3]=0) THEN
      CALL cl_err3("ins","occa_file",l_occa.occa01,"","9050","","copy",1)  #No.FUN-660167
      ROLLBACK WORK     #FUN-680010
      LET g_success='N'
   ELSE
      LET g_success='Y'
   END IF
   IF g_success='Y' THEN
      LET l_old_occano=g_occa.occano
      SELECT occa_file.* INTO g_occa.* FROM occa_file
                  WHERE occano = l_new_occano
      CALL i250_u()
 
      # 傳入參數: (1)TABLE名稱, (2)新增資料,
      #           (3)功能選項：insert(新增),update(修改),delete(刪除)
      CASE aws_spccli_base('occa_file',base.TypeInfo.create(g_occa),'insert')
         WHEN 0  #無與 SPC 整合
              MESSAGE 'INSERT O.K'
              COMMIT WORK 
         WHEN 1  #呼叫 SPC 成功
              MESSAGE 'INSERT O.K, INSERT SPC O.K'
              COMMIT WORK 
         WHEN 2  #呼叫 SPC 失敗
              ROLLBACK WORK
      END CASE
 
      #SELECT occa_file.* INTO g_occa.* FROM occa_file #FUN-C80046
      #            WHERE occano = l_old_occano         #FUN-C80046
   END IF 
   CALL i250_show()
END FUNCTION
 
FUNCTION i250_ef()
 
   CALL i250_y_chk()
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
 
   IF aws_efcli2(base.TypeInfo.create(g_occa),'','','','','')
   THEN
       LET g_success = 'Y'
       LET g_occa.occa1004 = 'S'   #開單成功, 更新狀態碼為 'S. 送簽中'
       DISPLAY BY NAME g_occa.occa1004
   ELSE
       LET g_success = 'N'
   END IF
 
END FUNCTION
FUNCTION i250_show_pic()
     SELECT * INTO g_occa.* FROM occa_file WHERE occano = g_occa.occano
     IF g_occa.occa1004 MATCHES '[12]' THEN 
         LET g_chr1='Y' 
         LET g_chr2='Y' 
     ELSE 
         LET g_chr1='N' 
         LET g_chr2='N' 
     END IF
     CALL cl_set_field_pic(g_chr1,g_chr2,"","","",g_occa.occaacti)
END FUNCTION
#No:FUN-9C0071--------精簡程式-----

#No.FUN-BB0049  --Begin
FUNCTION i250_set_occa02(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  DEFINE l_cnt   LIKE type_file.num5
  DEFINE l_pmc03 LIKE pmc_file.pmc03

   IF cl_null(g_occa.occa01) THEN RETURN END IF
   IF p_cmd <> 'a' AND g_action_choice <> "reproduce" THEN RETURN END IF
   IF g_aza.aza125 = 'N' THEN RETURN END IF

   SELECT pmc03 INTO l_pmc03 FROM pmc_file
    WHERE pmc01 = g_occa.occa01
   IF cl_null(l_pmc03) THEN RETURN END IF
   IF NOT cl_null(l_pmc03) THEN
      LET g_occa.occa02 = l_pmc03
   END IF

END FUNCTION
#No.FUN-BB0049  --End

#CHI-CB0017 add begin---
FUNCTION i250_copy_refdoc()
   DEFINE l_gca01_o    LIKE gca_file.gca01
   DEFINE l_gca01_n    LIKE gca_file.gca01
   DEFINE l_filename   LIKE gca_file.gca07
   DEFINE l_gca        RECORD LIKE gca_file.*
   DEFINE l_gcb        RECORD LIKE gcb_file.*
   DEFINE l_sql        STRING
   DEFINE l_cnt        LIKE type_file.num5

   LET l_gca01_o = "occ01=",g_occa.occa01
   LET l_gca01_n = "occano=",g_occa.occano
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
