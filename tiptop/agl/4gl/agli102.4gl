# Prog. Version..: '5.30.06-13.03.27(00010)'     #
#
# Pattern name...: agli102.4gl
# Descriptions...: 科目資料維護作業
# Date & Author..: 92/02/14 BY Nora
# Modify         : 95/10/03 By Lynn
#                : Add ^P 科目分類五、六(aag225、aag226)
# Modify.........: By Melody    新增 after field aag08(統制科目) 之 check
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-4A0252 04/10/20 By Smapmin 新增所屬統制科目開窗功能
# Modify.........: No.FUN-4C0048 04/12/08 By Nicola 權限控管修改
# Modify.........: No.MOD-4C0171 05/01/06 By Nicola 修改參數第一個保留給帳別
# Modify.........: No.MOD-4C0171 05/02/15 By Smapmin 接收參數時,第一個必為帳別,若第一個不是帳別,則加入Null
# Modify.........: No.FUN-510007 05/02/16 By Nicola 報表架構修改
# Modify.........: No.MOD-530569 05/03/26 By wujie  確定時，科目層級沒有及時更新
# Modify.........: No.FUN-590124 05/10/05 By Dido 表尾修改
# Modify.........: No.TQC-5B0097 05/11/14 By day  報表依選項打印，打印結構表時調用gglr001
# Modify.........: No.TQC-5B0090 05/11/11 By wujie  變更統制科目時，應自動推算科目層級，將BEFORE FIELD aag24 mark段重新放出
# Modify.........: No.FUN-5C0015 05/12/07 BY GILL 刪除異動碼管理GROUP
# Modify.........: No.TQC-620043 06/02/16 By Smapmin 財務分析類別新增32~37
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670032 06/07/11 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.MOD-6A0027 06/10/14 By Smapmin 會科為別的會科的「所屬統制科目」就不可刪除
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0040 06/11/15 By jamie FUNCTION _fetch() 一開始應清空key值
# Modify.........: No.MOD-6B0124 06/12/05 By Smapmin 此張單子不做調整
# Modify.........: No.FUN-6C0012 06/12/12 By wujie   增加批次產生額外科目名稱功能
# Modify.........: No.TQC-6C0060 07/01/08 By alexstar 多語言功能單純化
# Modify.........: No.CHI-710005 07/01/22 By Elva 去掉aza26的判斷
# Modify.........: No.MOD-710206 07/02/01 By Smapmin 所屬統制科目僅於新增時帶出預設值,更改時不再重帶預設值
# Modify.........: No.MOD-720093 07/02/14 By Smapmin 增加所屬統制科目合理性檢驗
# Modify.........: No.FUN-730020 07/03/13 By Carrier 會計科目加帳套
# Modify.........: No.FUN-730070 07/04/03 By Carrier 會計科目加帳套-財務
# Modify.........: No.MOD-730127 07/04/03 By Smapmin 科目層級不可小於等於0
# Modify.........: No.FUN-740032 07/04/12 By Carrier copy時,key值重復,跳不出來
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760085 07/07/27 By sherry  報表改由Crystal Report輸出 
# Modify.........: No.TQC-7B0102 07/11/16 By Rayven 打印科目結構表報錯：無資料
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.FUN-820031 08/02/20 By Sunyanchun 資料中心功能 
# Modify.........: NO.FUN-840018 08/04/07 BY yiting 增加一個頁面放置清單資料
# Modify.........: No.MOD-840358 08/04/21 By Sarah 若來源科目為3.獨立帳戶,所屬統制科目(aag08)應DEFAULT=NULL,待輸入科目編號後再自動帶入其值=科目編號
# Modify.........: No.CHI-880031 08/09/09 By xiaofeizhu 查出資料后,應該停在第一筆資料上,不必預設是看資料清單,有需要瀏覽,再行點選
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.TQC-860012 08/11/12 By jan agli102輸入時，依據輸入的科目欄位(aag01)
#                                                       IF aaz107,aaz108有輸入資料，自動依設定科目碼數推算出統制科目 (aag08)ELSE 照舊有羅輯取出所屬統制科目
# Modify.........: No.TQC-8C0015 09/01/07 By Sarah 當aag21(預算控制)或aag23(專案控制)其中一個有勾選時,不可將aag07(統制/明細別)改為1.統制帳戶
# Modify.........: No.MOD-940018 09/04/05 By dongbg_cs()中construct欄位寫重復 導致無法查詢
# Modify.........: No.TQC-940134 09/04/28 By chenl 增加科目設置規則功能。
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-950033 09/05/04 By xiaofeizhu 當資料有效碼(aagacti)='N'時，不可刪除該筆資料
# Modify.........:                                      所屬統制科目（aag08）可錄入任意字符，需增加管控檢查
# Modify.........: No.MOD-950167 09/05/18 By lilingyu 調整TQC-950033增加的邏輯判斷,新增科目,該科目為3且統制科目=科目編號時,不做檢查
# Modify.........: No.TQC-950204 09/05/31 By xiaofeizhu 調整TQC-950033的修改,aag08不需要管控，只需設置為不可錄入
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-990069 09/10/12 By baofei 增加子公司可新增資料的檢查  
# Modify.........: No:TQC-9C0046 09/12/08 By Carrier 明细科目时,aag24应该为99,不需要判断其他内容
# Modify.........: No:MOD-9C0350 09/12/24 By Sarah i102_chk(),提示訊息調整
# Modify.........: No:FUN-9C0072 10/01/05 By vealxu 精簡程式碼
# Modify.........: No:FUN-A10088 10/01/20 By wujie  增加现金变动码栏位
# Modify.........: No:MOD-A10143 10/01/25 By liuxqa 无效和改为统制科目时，检查是否存在于分录和凭证中。
# Modify.........: No.FUN-9C0113 10/01/28 By lutingting 新增時財務分析類別欄位應DEFAULT 30.其他 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30001 10/03/01 By Carrier 明细科目/独立科目时,科目级不能是除了99外的其他值
# Modify.........: No.FUN-A30077 10/03/23 By Carrier 增加aag42 按余额类型产生分录
# Modify.........: No.FUN-A40020 10/04/07 By Carrier 独立科目层及设置为1
# Modify.........: No.TQC-A40089 10/04/20 By wujie   现金变动码放到财务分析类型下面，当aag19 <>1时必输
# Modify.........: No.TQC-A40075 10/04/15 By xiaofeizhu 復制直接退出的時候關閉有些已經開啟的字段
# Modify.........: No.FUN-A50010 10/05/04 By sunchenxu 科目基本資料以樹狀構顯示
# Modify.........: No.TQC-A50008 10/05/11 By xiaofeizhu 勾選“貨幣性科目”選項，“計數單位”欄位應該灰掉
# Modify.........: No.TQC-A50015 10/05/05 By xiaofeizhu 1.上級統治科目若勾選“部門管理”，維其下級科目時應帶出默認值同時也勾選做部門門管理
#                                                       2.新增科目資料時，下級科目的“科目性質”和“資產/損益別”欄位內容    應帶出上級科目值的默認值                                                   
# Modify.........: No.TQC-A50019 10/05/05 By xiaofeizhu 復制時，錄入的科目編號仍需判斷agls103上 科目設置規則的設置
# Modify.........: No.FUN-A60024 10/06/09 By wujie   恢复FUN-A40020的修改 
# Modify.........: No:TQC-A60039 10/06/10 By sunchenxu 修改tree功能修改
# Modify.........: No:TQC-A60134 10/06/30 By sunchenxu 修改tree功能修改
# Modify.........: No.MOD-A70007 10/07/02 By sabrina 當aza26='2'時，aag42欄位才顯示出來
# Modify.........: No.TQC-A70006 10/07/02 By xiaofeizhu   IF aag07 = '1' OR aag07 = '3' THEN no entry aag08
# Modify.........: No.MOD-A80111 10/08/17 By elva aag41改为非必填
# Modify.........: No.MOD-A90141 10/09/21 By Dido 統制科目欄位在複製時應檢核合理性不需 no entry 
# Modify.........: No.TQC-A90149 10/09/29 By Dido 在複製時,aag07若改為獨立時,aag08應給予aag01 
# Modify.........: No.FUN-B10050 11/01/25 By Carrier 科目查询自动过滤
# Modify.........: No.MOD-B30377 11/03/15 By lixia aaz107與aaz108相關判斷/修改
# Modify.........: No.TQC-B50016 11/05/05 By yinhy 狀態頁簽的“資料建立者”“資料建立部門”欄位無法下條件查詢。
# Modify.........: No.TQC-B50084 11/05/17 By yinhy 更改時，統制明細別aag07由3.獨立科目更改為1.統制科目時SQL語句有誤
# Modify.........: No.TQC-B50067 11/05/18 By yinhy 更改時，i102_chk_x()增加帳套條件语句
# Modify.........: No.MOD-B80030 11/08/03 By Dido i102_chk_x 應排除無效資料
# Modify.........: No.TQC-B90119 11/09/19 By Carrier UPDATE aee_file时字段使用错误
# Modify.........: No.TQC-B90121 11/09/19 By lilingyu 修改完key值:科目編號後,畫面報錯
# Modify.........: No.MOD-BC0100 11/12/12 By Polly AFTER FIELD aag24增加條件控卡
# Modify.........: No.FUN-BC0067 12/01/17 By Lori 增加[整批複製]功能鍵
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.MOD-C50115 12/05/18 By Polly 新增時當科目重復，只需將aag01清空並停留在aag01即可
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.MOD-D10070 13/01/09 By yinhy 新增時報錯-400修改
# Modify.........: No.CHI-D10015 13/01/18 By apo 刪除時寫入歷史檔紀錄(azo_file)
# Modify.........: No.FUN-C90061 13/01/22 By wuxj  增加客商管理aag43
# Modify.........: No.FUN-C50147 12/05/31 By fengmy 還原資料清單功能
# Modify.........: No.MOD-D50041 13/05/07 By fengmy 複製后獨立科目不變成統制科目 
# Modify.........: No.MOD-D50042 13/05/07 By fengmy 複製后停留在新資料上
# Modify.........: No.FUN-D40118 13/05/20 By zhangweib 當aag44='Y'時，可調用按扭【控制核算作業設置】進行設置
# Modify.........: No.TQC-D70091 13/07/25 By yinhy 獨立科目應遵循agls103中aaz107設定的碼長
# Modify.........: No:MOD-DB0144 13/11/25 By wangrr 當科目層級大於2且查詢的是中間層級時,增加由下向上的查詢上層科目
# Modify.........: No:TQC-DB0087 13/11/28 By wangrr 當科目層級大於3層時修干tree的顯示

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_data_center.global"   #No.FUN-820031 
 
DEFINE g_argv1     LIKE obw_file.obw01     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
DEFINE g_argv3     STRING                  #FUN-820031
   DEFINE g_aag        RECORD LIKE aag_file.*,
          g_aag_t      RECORD LIKE aag_file.*,
          g_aag_o      RECORD LIKE aag_file.*,
          g_aag00_t    LIKE aag_file.aag00,          #No.FUN-730020
          g_aag01_t    LIKE aag_file.aag01,
          g_wc,g_sql   STRING,                       #TQC-630166   
          g_cmd        LIKE type_file.chr1000,       #No.FUN-680098 VARCHAR(50)
          g_mai        DYNAMIC ARRAY OF RECORD
                          mai01 LIKE mai_file.mai01, #報表編號
                          mai02 LIKE mai_file.mai02, #報表名稱
                          x LIKE type_file.chr1      #No.FUN-680098   VARCHAR(1)
                       END RECORD
   DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL      
   DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680098 SMALLINT
   DEFINE g_chr          LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
   DEFINE g_cnt          LIKE type_file.num10         #No.FUN-680098 INTEGER
   DEFINE g_msg          LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(72)
   DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680098 INTEGER
   DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680098 INTEGER
   DEFINE g_jump         LIKE type_file.num10         #No.FUN-680098 INTEGER 
   DEFINE g_no_ask      LIKE type_file.num5          #No.FUN-680098 SMALLINT
   DEFINE g_on_change_02      LIKE type_file.num5     #No.FUN-6C0012 SMALLINT
   DEFINE g_on_change_13      LIKE type_file.num5     #No.FUN-6C0012 SMALLINT
   DEFINE g_str          STRING                       #No.FUN-760085 
   DEFINE g_bookno       LIKE aaa_file.aaa01          #No.TQC-7B0102
DEFINE  g_aag_l       DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)   
          aag00       LIKE aag_file.aag00,
          aag01       LIKE aag_file.aag01,
          aag02       LIKE aag_file.aag02,
          aag13       LIKE aag_file.aag13,
          aag04       LIKE type_file.chr12,
          aag07       LIKE type_file.chr12,
          aag08       LIKE aag_file.aag08,
          aag24       LIKE aag_file.aag24,
          aag05       LIKE aag_file.aag05,
          aag21       LIKE aag_file.aag21,
          aag23       LIKE aag_file.aag23,
          aagacti     LIKE aag_file.aagacti,
          aag39       LIKE aag_file.aag39
                      END RECORD
DEFINE  g_aag_a       DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)   
          aag00       LIKE aag_file.aag00,
          aag01       LIKE aag_file.aag01
                      END RECORD
DEFINE  g_aagx       DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
          sel         LIKE type_file.chr1,
          aag00       LIKE aag_file.aag00,
          aag01       LIKE aag_file.aag01
                      END RECORD
DEFINE g_gev04        LIKE gev_file.gev04                                       
DEFINE l_ac1          LIKE type_file.num10                                      
DEFINE g_rec_b1       LIKE type_file.num10                                      
DEFINE g_bp_flag      LIKE type_file.chr10                                      
DEFINE g_flag2        LIKE type_file.chr1                                       
DEFINE g_gew06        LIKE gew_file.gew06                                       
DEFINE g_gew07        LIKE gew_file.gew07
DEFINE g_exit_flag    LIKE type_file.chr1
###FUN-9A0002 START ###
DEFINE g_wc_o            STRING                #g_wc舊值備份
DEFINE g_wc_t            STRING                ##帳別QBE條件
DEFINE g_idx             LIKE type_file.num5   #g_tree的index，用於tree_fill()的recursive
DEFINE g_tree DYNAMIC ARRAY OF RECORD
          name           STRING,                 #節點名稱
          pid            STRING,                 #父節點id
          id             STRING,                 #節點id
          has_children   BOOLEAN,                #TRUE:有子節點, FALSE:無子節點
          expanded       BOOLEAN,                #TRUE:展開, FALSE:不展開
          level          LIKE type_file.num5,    #階層
          path           STRING,                 #節點路徑，以"."隔開
          #各程式key的數量會不同，單身和單頭的key都要記錄
          #若key是數值，要先轉字串，避免數值型態放到Tree有多餘空白
          treekey1       STRING,
          treekey2       STRING
          END RECORD

DEFINE g_aag00 LIKE aag_file.aag00
DEFINE g_tree_focus_idx  STRING                  #focus節點idx
DEFINE g_tree_focus_path STRING                  #focus節點path
DEFINE g_tree_reload     LIKE type_file.chr1     #tree是否要重新整理 Y/N
DEFINE g_tree_b          LIKE type_file.chr1     #tree是否進入單身 Y/N
DEFINE g_path_self       DYNAMIC ARRAY OF STRING #tree加節點者至root的路徑(check loop)
DEFINE g_path_add        DYNAMIC ARRAY OF STRING #tree要增加的節點底層路徑(check loop)
###FUN-9A0002 END ###
DEFINE g_wc_1            STRING               #TQC-B90121
DEFINE g_chr_1           LIKE type_file.chr1  #TQC-B90121

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
    LET g_argv1 = ARG_VAL(1)     #No.FUN-730020
    LET g_argv2 = ARG_VAL(2)     #No.MOD-4C0171  #No.FUN-730020
    LET g_argv3 = ARG_VAL(3)     #No.FUN-820031
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   INITIALIZE g_aag.* TO NULL
   INITIALIZE g_aag_t.* TO NULL
   INITIALIZE g_aag_o.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM aag_file WHERE aag00 = ? AND aag01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i102_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW i102_w WITH FORM "agl/42f/agli102"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
  #MOD-A70007---add---start---
   IF g_aza.aza26 = '2' THEN
       CALL cl_set_comp_visible("aag42,aag43,aag44",TRUE)       #FUN-C90061 add aag43   #No.FUN-D40118   Add aag44    
   ELSE
      CALL cl_set_comp_visible("aag42,aag43,aag44",FALSE)      #FUN-C90061 add aag43   #No.FUN-D40118   Add aag44
   END IF
  #MOD-A70007---add---end---
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i102_q(0)
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i102_a()
            END IF
         OTHERWISE        
            CALL i102_q(0) 
      END CASE
   END IF
   LET g_wc = '1=1'
   LET g_tree_reload = "N"      #tree是否要重新整理 Y/N  #FUN-9A0002
   LET g_tree_b = "N"           #tree是否進入單身 Y/N    #FUN-9A0002
   LET g_tree_focus_idx = 0     #focus節點index       #FUN-9A0002
   CALL i102_menu()
 
   CLOSE WINDOW i102_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i102_cs(p_idx)                #FUN-A50010 加參數p_idx
   DEFINE p_idx  LIKE type_file.num5   #雙按Tree的節點index     #FUN-9A0002
   DEFINE l_wc   STRING                #雙按Tree的節點時的查詢條件 #FUN-9A0002
   DEFINE l_i    LIKE type_file.num5 ##FUN-A50010  by suncx1
   ###FUN-A50010 START ###
   LET l_wc = NUll
   IF p_idx>0 THEN
      LET l_wc = g_wc_o
   END IF
   ###FUN-A50010 END ###
   CLEAR FORM
   CALL g_mai.clear()
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      LET g_wc=" aag00='",g_argv1,"' AND aag01='",g_argv2,"'"       #FUN-7C0050
   ELSE
   INITIALIZE g_aag.* TO NULL    #No.FUN-750051
   IF p_idx = 0 THEN             #No.FUN-A50010
      CONSTRUCT BY NAME g_wc ON aag00,aag01,aag02,aag13,aag39,aag03,aag04,aag06,aag09,aag12,aag38, #FUN-670032 add aag38  FUN-6C0012 add aag13  #No.FUN-730020 #FUN-820031 add aag39
#                               aag221,aag223,aag224,aag225,aag226,aag19,
#                               aag41,aag221,aag223,aag224,aag225,aag226,aag19,    #No.FUN-A10088 add aag41
                                aag221,aag223,aag224,aag225,aag226,aag19,aag41,    #No.TQC-A40089 mov aag41
                                aag07,aag08,aag24,aag05,aag21,aag23,aag44,      #No.FUN-D40118   Add aag44
                                aag42,      #No.FUN-A30077
                                aag43,      #FUN-C90061 add aag43
                                aag14,aaguser,aaggrup,  #MOD-940018 取消aag13  #N.FUN-6C0012
                                aagmodu,aagdate,aagacti,
                                aagoriu,aagorig           #TQC-B50016 add
                            
         BEFORE CONSTRUCT
                 CALL cl_qbe_init()
                 
         AFTER FIELD aag00
            LET g_aag00 = get_fldbuf(aag00)
            IF cl_null(g_aag00) THEN
               LET g_wc_t = '1=1'
            ELSE 
               LET g_wc_t = "aag00 = '",g_aag00,"' "
            END IF
            
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(aag00)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aaa"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aag00  
                  
               WHEN INFIELD(aag223)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_aae"
                  LET g_qryparam.default1 = g_aag.aag223
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aag223
                  NEXT FIELD aag223
               WHEN INFIELD(aag224)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_aae"
                  LET g_qryparam.default1 = g_aag.aag224
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aag224
                  NEXT FIELD aag224
               WHEN INFIELD(aag225)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_aae"
                  LET g_qryparam.default1 = g_aag.aag225
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aag225
                  NEXT FIELD aag225
               WHEN INFIELD(aag226)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_aae"
                  LET g_qryparam.default1 = g_aag.aag226
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aag226
                  NEXT FIELD aag226
                WHEN INFIELD(aag08)  #MOD-4A0252 新增所屬統制科目開窗                 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_aag"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aag08
                  NEXT FIELD aag08
               WHEN INFIELD(aag39)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_azp"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret            
                  DISPLAY g_qryparam.multiret TO aag39                          
                  NEXT FIELD aag39                                  
#No.FUN-A10088 --begin
               WHEN INFIELD(aag41)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nml"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aag41
               NEXT FIELD aag41
#No.FUN-A10088 --end
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
             CALL cl_qbe_select()
          ON ACTION qbe_save
		     CALL cl_qbe_save()
      END CONSTRUCT
   ###FUN-A50010 START ###
   ELSE 
      LET g_wc = l_wc CLIPPED
   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('abduser', 'abdgrup') #FUN-980030
   IF p_idx = 0 THEN   #不是從tree點進來的，而是重新查詢時CONSTRUCT產生的原始查詢條件要備份
      LET g_wc_o = g_wc CLIPPED
      LET g_wc_1 = g_wc_o CLIPPED   #TQC-B90121
   END IF
   ###FUN-A50010 END ###
   IF INT_FLAG THEN
      RETURN
   END IF
  END IF  #FUN-7C0050
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
   IF cl_null(g_wc) THEN LET g_wc = '1=1' END IF                      #MOD-D10070
 
 
   LET g_sql="SELECT aag00,aag01 FROM aag_file ",       #No.FUN-730020
             " WHERE ",g_wc CLIPPED, " ORDER BY aag00,aag01,aag08"  #No.FUN-730020
   PREPARE i102_prepare FROM g_sql
   DECLARE i102_cs SCROLL CURSOR WITH HOLD FOR i102_prepare

   LET l_i = 1
   CALL g_aag_a.clear()
   PREPARE i102_prepare1 FROM g_sql
   DECLARE i102_cs1 CURSOR FOR i102_prepare1
   FOREACH i102_cs1  INTO g_aag_a[l_i].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF 
         LET l_i = l_i + 1
   END FOREACH
   DECLARE i102_list_cur CURSOR FOR i102_prepare                               
 
   LET g_sql= "SELECT COUNT(*) FROM aag_file WHERE ",g_wc CLIPPED
   PREPARE i102_precount FROM g_sql
   DECLARE i102_count CURSOR FOR i102_precount
 
END FUNCTION
 
FUNCTION i102_menu()
   ###No.FUN-A50010 START ###
   DEFINE l_wc               STRING
   DEFINE l_tree_arr_curr    LIKE type_file.num5
   DEFINE l_curs_index       STRING               #focus的資料是在第幾筆
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_tok              base.StringTokenizer
   WHILE TRUE
      LET g_action_choice = " "
      
      CALL cl_set_act_visible("accept,cancel", FALSE)
      #讓各個交談指令可以互動
      DIALOG ATTRIBUTES(UNBUFFERED)
         DISPLAY ARRAY g_tree TO tree.*
            BEFORE DISPLAY
               #重算g_curs_index，按上下筆按鈕才會正確
               IF g_tree_focus_idx <= 0 THEN
                  LET g_tree_focus_idx = ARR_CURR()
               END IF

               #以最上層的id當作單頭的g_curs_index
               #CALL cl_str_sepsub(g_tree[g_tree_focus_idx].id CLIPPED,".",1,1) RETURNING l_curs_index #依分隔符號分隔字串後，截取指定起點至終點的item
               CALL i102_jump(g_curs_index) RETURNING g_curs_index    ##FUN-A50010  by suncx1
               CALL cl_navigator_setting(g_curs_index, g_row_count)

            BEFORE ROW
               LET l_tree_arr_curr = ARR_CURR() #目前在tree的row 
               IF l_tree_arr_curr <= 1 THEN
                  CALL i102_tree_idxbykey() 
                  LET l_tree_arr_curr = g_tree_focus_idx
               END IF
               CALL DIALOG.setSelectionMode( "tree",1)  # FUN-A50010
               CALL cl_set_act_visible("addchild",TRUE)   # FUN-A50010
               LET g_tree_focus_path = g_tree[l_tree_arr_curr].path
               LET g_tree_focus_idx = l_tree_arr_curr CLIPPED
               CALL i102_tree_idxbypath()   #依tree path指定focus節點
               CALL i102_fetch('T',l_tree_arr_curr)
#TQC-B90121 --begin--
              IF g_chr_1 = 'Y' THEN                
                 LET g_tree_focus_idx= 0
                 CALL i102_tree_fill1(g_wc_1,NULL,0,NULL,NULL,NULL)   #Tree填充                    
                 LET g_chr_1 = 'N'
              END IF    
#TQC-B90121 --end--              

         END DISPLAY
         
         BEFORE DIALOG
            #No.FUN-A50010 add by sunchenxu  判斷是否要focus到tree的正確row
            CALL i102_tree_idxbykey()
            IF g_tree_focus_idx > 0 THEN
               CALL Dialog.nextField("tree.name")                   #No.FUN-A50010  add by sunchenxu   利用NEXT FIELD達到focus另一個table
               CALL Dialog.setCurrentRow("tree", g_tree_focus_idx)   #No.FUN-A50010  add by sunchenxu   指定tree要focus的row
            END IF

         ON ACTION insert
            LET g_action_choice="insert"
            EXIT DIALOG
            
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
            
         ON ACTION next
            CALL i102_fetch('N',0)      #FUN-A50010 加參數p_idx
            CALL i102_tree_idxbykey()   #No.FUN-A50010 
            ACCEPT DIALOG
            
         ON ACTION previous
            CALL i102_fetch('P',0)      #FUN-A50010  加參數p_idx
            CALL i102_tree_idxbykey()   #No.FUN-FUN-A50010 
            ACCEPT DIALOG

         ON ACTION modify
            LET g_action_choice="modify"
            EXIT DIALOG
            
         ON ACTION invalid
            LET g_action_choice="invalid"
            EXIT DIALOG

         ON ACTION delete
            LET g_action_choice="delete"   
            EXIT DIALOG

         ON ACTION reproduce
            LET g_action_choice="reproduce"
            EXIT DIALOG

         ON ACTION extra_name
            LET g_action_choice="extra_name" 
            EXIT DIALOG 

         ON ACTION extra_p_n
            LET g_action_choice="extra_p_n" 
            EXIT DIALOG  

         ON ACTION output
            LET g_action_choice="output"
            EXIT DIALOG  

         ON ACTION trans
            LET g_action_choice="trans"
            EXIT DIALOG

         #FUN-C50147 --Begin
         ON ACTION subjectlist
            LET g_action_choice = "subjectlist"
            EXIT DIALOG
         #FUN-C50147 --End

         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_set_field_pic("","","","","",g_aag.aagacti)
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            CALL i102_tree_fill1(g_wc_o,NULL,0,NULL,NULL,NULL)
 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG
         ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT DIALOG
 
         ON ACTION jump
            CALL i102_fetch('/',0)      #FUN-A50010  加參數p_idx
            CALL i102_tree_idxbykey()   #No.FUN-A50010 
            ACCEPT DIALOG
 
         ON ACTION first
            CALL i102_fetch('F',0)      #FUN-A50010  加參數p_idx
            CALL i102_tree_idxbykey()   #No.FUN-A50010 
            ACCEPT DIALOG
 
         ON ACTION last
            CALL i102_fetch('L',0)      #FUN-A50010  加參數p_idx
            CALL i102_tree_idxbykey()   #No.FUN-A50010 
            ACCEPT DIALOG
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
            
         ON ACTION carry                                                          
            LET g_action_choice = "carry"
            EXIT DIALOG

         ON ACTION download                                                       
            LET g_action_choice = "download"
            EXIT DIALOG
            
         ON ACTION qry_carry_history                                              
            LET g_action_choice = "qry_carry_history"
            EXIT DIALOG

         ON ACTION related_document    #No.MOD-470515
            LET g_action_choice="related_document"
            EXIT DIALOG

        #FUN-BC0067--Begin--
         ON ACTION batch_copy
            LET g_action_choice="batch_copy"
            EXIT DIALOG
        #FUN-BC0067---End---
        
        #No.FUN-D40118 ---Add--- Start
         ON ACTION accounting
            LET g_action_choice="accounting"
            EXIT DIALOG
        #No.FUN-D40118 ---Add--- End
      END DIALOG 

      CALL cl_set_act_visible("accept,cancel", TRUE)

      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i102_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i102_q(0)
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i102_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i102_x()
               CALL cl_set_field_pic("","","","","",g_aag.aagacti)
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i102_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i102_copy()
            END IF
         WHEN "extra_name"
            IF cl_chk_act_auth() AND NOT cl_null(g_aag.aag01) AND
               NOT cl_null(g_aag.aag00) THEN  #No.FUN-730020
               CALL i102_extra()
            END IF
         WHEN "extra_p_n"
            IF cl_chk_act_auth() THEN
               LET g_cmd = "agli103 '",g_aag.aag00 CLIPPED,"' '",g_aag.aag01 CLIPPED,"'"  #MOD-4C0171  #No.FUN-730020
               CALL cl_cmdrun(g_cmd)
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i102_out()
            END IF
         #No.FUN-C50147  --Begin
         WHEN "subjectlist"
            IF NOT cl_null(g_wc) THEN
               CALL i102_list_fill()
            END IF
            CALL i102_bp("G")
         #No.FUN-C50147  --End
         WHEN "trans"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_aag_t.aag01) THEN  #新增狀況，或是在menu段
                  CALL cl_cmdrun("agli1022")
               ELSE
                 IF g_aag.aag07 NOT MATCHES '[2,3]' THEN
                    #統制明細別需為 2明細帳戶或 3獨立帳戶，才可維護科目異動碼!
                    CALL cl_err('','agl-044',1)
                 ELSE
                    LET g_msg="agli1022 '",g_aag.aag00,"' '",g_aag.aag01,"'"  #No.FUN-730020
                    CALL cl_cmdrun(g_msg)
                 END IF
               END IF
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "carry"
            IF cl_chk_act_auth() THEN                                           
               CALL ui.Interface.refresh()                                      
               CALL i102_carry()                                                
               ERROR ""                                                         
            END IF 
         WHEN "download" 
            IF cl_chk_act_auth() THEN
               CALL i102_download()                               
            END IF
         WHEN "qry_carry_history"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_aag.aag00) AND NOT cl_null(g_aag.aag01) THEN
                  IF NOT cl_null(g_aag.aag39) THEN                                                                                    
                     SELECT gev04 INTO g_gev04 FROM gev_file                                                                           
                      WHERE gev01 = '6' AND gev02 = g_aag.aag39                                                                       
                  ELSE      #歷史資料,即沒有aag39的值                                                                                 
                     SELECT gev04 INTO g_gev04 FROM gev_file                                                                           
                      WHERE gev01 = '6' AND gev02 = g_plant                                                                            
                  END IF                                                                                                               
                  IF NOT cl_null(g_gev04) THEN                                                                                         
                     LET g_cmd='aooq604 "',g_gev04,'" "6" "',g_prog,'" "',g_aag.aag00,'" "+',g_aag.aag01,'"'     
                     CALL cl_cmdrun(g_cmd)                                                                                             
                  END IF
               END IF
            END IF     
       
         WHEN "related_document"  #No:MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_aag.aag01 IS NOT NULL THEN
                  LET g_doc.column1 = "aag00"
                  LET g_doc.value1 = g_aag.aag00
                  LET g_doc.column2 = "aag01"
                  LET g_doc.value2 = g_aag.aag01
                  CALL cl_doc()
               END IF
            END IF
            #No.FUN-D40118 ---Add--- Start
         WHEN "accounting"
            IF cl_chk_act_auth() THEN
               CALL i102_acc()
            END IF
        #No.FUN-D40118 ---Add--- End

        #FUN-BC0067--Begin--
         WHEN "batch_copy"
            IF cl_chk_act_auth() THEN
               CALL i102_batch_copy()
            END IF
        #FUN-BC0067---End---

      END CASE
   END WHILE
   ###No.FUN-A50010 END ###

   #No.FUN-A50010 mark START#
   #LET g_bp_flag = "main_pg" #No.FUN-A50010 mark
   #LET g_exit_flag = "N"     #No.FUN-A50010 mark
   #ENU ""
   # BEFORE MENU
   #     CALL cl_navigator_setting( g_curs_index, g_row_count )
   #     IF g_exit_flag = "Y" THEN
   #        EXIT MENU
   #     END IF
   # ON ACTION insert
   #    LET g_action_choice="insert"
   #    CALL cl_set_act_visible("accept,cancel", TRUE)    #NO.FUN-820031
   #    IF cl_chk_act_auth() THEN
   #       CALL i102_a()
   #    END IF
   #
   # ON ACTION query
   #    LET g_action_choice="query"
   #    CALL cl_set_act_visible("accept,cancel", TRUE)   #NO.FUN-820031
   #    IF cl_chk_act_auth() THEN
   #       CALL i102_q()
   #    END IF
   #
   # ON ACTION next
   #    CALL i102_fetch('N')
   # ON ACTION previous
   #    CALL i102_fetch('P')
   #
   # ON ACTION modify
   #    LET g_action_choice="modify"
   #    CALL cl_set_act_visible("accept,cancel", TRUE)   #NO.FUN-820031
   #    IF cl_chk_act_auth() THEN
   #       CALL i102_u()
   #    END IF
   #
   # ON ACTION invalid
   #    LET g_action_choice="invalid"
   #    IF cl_chk_act_auth() THEN
   #       CALL i102_x()
   #       CALL cl_set_field_pic("","","","","",g_aag.aagacti)
   #    END IF
   #
   # ON ACTION delete
   #    LET g_action_choice="delete"
   #    IF cl_chk_act_auth() THEN
   #       caLL i102_r()
   #    END IF
   #
   # ON ACTION reproduce
   #    LET g_action_choice="reproduce"
   #    CALL cl_set_act_visible("accept,cancel", TRUE)   #NO.FUN-820031
   #    IF cl_chk_act_auth() THEN
   #       CALL i102_copy()
   #    END IF
   # ON ACTION extra_name
   #    LET g_action_choice="extra_name"
   #    IF cl_chk_act_auth() AND NOT cl_null(g_aag.aag01) AND
   #       NOT cl_null(g_aag.aag00) THEN  #No.FUN-730020
   #       CALL i102_extra()
   #    END IF
#  # ON ACTION 額外名稱維護
   # ON ACTION extra_p_n
   #    LET g_action_choice="extra_p_n"
   #    IF cl_chk_act_auth() THEN
   #        LET g_cmd = "agli103 '",g_aag.aag00 CLIPPED,"' '",g_aag.aag01 CLIPPED,"'"  #MOD-4C0171  #No.FUN-730020
   #       CALL cl_cmdrun(g_cmd)
   #    END IF
   #
   # ON ACTION output
   #    LET g_action_choice="output"
   #    IF cl_chk_act_auth() THEN
   #       CALL i102_out()
   #    END IF
   #
   # #FUN-5C0015 增加「科目異動碼設定」功能
   # ON ACTION trans
   #    LET g_action_choice="trans"
   #    IF cl_chk_act_auth() THEN
   #       IF cl_null(g_aag_t.aag01) THEN  #新增狀況，或是在menu段
   #          CALL cl_cmdrun("agli1022")
   #       ELSE
   #         IF g_aag.aag07 NOT MATCHES '[2,3]' THEN
   #            #統制明細別需為 2明細帳戶或 3獨立帳戶，才可維護科目異動碼!
   #            CALL cl_err('','agl-044',1)
   #         ELSE
   #            LET g_msg="agli1022 '",g_aag.aag00,"' '",g_aag.aag01,"'"  #No.FUN-730020
   #            CALL cl_cmdrun(g_msg)
   #         END IF
   #       END IF
   #    END IF
   #
   # ON ACTION help
   #    CALL cl_show_help()
   #
   # ON ACTION locale
   #    CALL cl_dynamic_locale()
   #    CALL cl_set_field_pic("","","","","",g_aag.aagacti)
   #    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
   #
   # ON ACTION exit
   #    LET g_action_choice="exit"
   #    EXIT MENU
   #
   # ON ACTION jump
   #    CALL i102_fetch('/')
   #
   # ON ACTION first
   #    CALL i102_fetch('F')
   #
   # ON ACTION last
   #    CALL i102_fetch('L')
   #
   # ON IDLE g_idle_seconds
   #    CALL cl_on_idle()
   #
   #  ON ACTION about         #MOD-4C0121
   #     CALL cl_about()      #MOD-4C0121
   #
   #  ON ACTION controlg      #MOD-4C0121
   #     CALL cl_cmdask()     #MOD-4C0121
   #
   # -- for Windows close event trapped
   # ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
   #        LET INT_FLAG=FALSE 		#MOD-570244	mars
   #    LET g_action_choice = "exit"
   #    EXIT MENU
   #
   #  ON ACTION carry                                                          
   #     LET g_action_choice = "carry" 
   #     CALL cl_set_act_visible("accept,cancel", TRUE)    #NO.FUN-820031
   #     IF cl_chk_act_auth() THEN                                           
   #        CALL ui.Interface.refresh()                                      
   #        CALL i102_carry()                                                
   #        ERROR ""                                                         
   #     END IF                                        
   #                                                                           
   #  ON ACTION download                                                       
   #    LET g_action_choice = "download"       
   #    CALL cl_set_act_visible("accept,cancel", TRUE)    #NO.FUN-820031 
   #    IF cl_chk_act_auth() THEN
   #       CALL i102_download()                               
   #    END IF
   #                                                                  
   #  ON ACTION qry_carry_history                                              
   #     LET g_action_choice = "qry_carry_history"                             
   #     IF cl_chk_act_auth() THEN
   #        IF NOT cl_null(g_aag.aag00) AND NOT cl_null(g_aag.aag01) THEN
   #           IF NOT cl_null(g_aag.aag39) THEN                                                                                    
   #              SELECT gev04 INTO g_gev04 FROM gev_file                                                                           
   #                 WHERE gev01 = '6' AND gev02 = g_aag.aag39                                                                       
   #           ELSE      #歷史資料,即沒有aag39的值                                                                                 
   #              SELECT gev04 INTO g_gev04 FROM gev_file                                                                           
   #                 WHERE gev01 = '6' AND gev02 = g_plant                                                                            
   #           END IF                                                                                                               
   #           IF NOT cl_null(g_gev04) THEN                                                                                         
   #              LET g_cmd='aooq604 "',g_gev04,'" "6" "',g_prog,'" "',g_aag.aag00,'" "+',g_aag.aag01,'"'     
   #              CALL cl_cmdrun(g_cmd)                                                                                             
   #           END IF
   #        END IF
   #     END IF     
   #                                                            
   #  ON ACTION subjectlist                                                    
   #     LET g_action_choice = "subjectlist" 
   #     IF NOT cl_null(g_wc) THEN
   #        CALL i102_list_fill()
   #     END IF                                    
   #     CALL i102_bp("G")                                                     
   #
   # ON ACTION main
   #    LET g_bp_flag = 'main'
   #    LET l_ac1 = ARR_CURR()
   #    LET g_jump = l_ac1
   #    LET g_no_ask = TRUE
   #    IF g_rec_b1 >0 THEN
   #        CALL i102_fetch('/')
   #    END IF
   #    CALL cl_set_comp_visible("page100", FALSE)
   #    CALL ui.interface.refresh()
   #    CALL cl_set_comp_visible("page100", TRUE)
   #
   #  ON ACTION related_document    #No.MOD-470515
   #    LET g_action_choice="related_document"
   #    IF cl_chk_act_auth() THEN
   #       IF g_aag.aag01 IS NOT NULL THEN
   #          LET g_doc.column1 = "aag00"
   #          LET g_doc.value1 = g_aag.aag00
   #          LET g_doc.column2 = "aag01"
   #          LET g_doc.value2 = g_aag.aag01
   #          CALL cl_doc()
   #       END IF
   #    END IF
   #END MENU
   #No.FUN-A50010 mark END#
   CLOSE i102_cs
END FUNCTION
#No.FUN-C50147  --Begin 去掉mark
###FUN-A50010 mark START ###
 FUNCTION i102_bp(p_ud)
    DEFINE   p_ud   LIKE type_file.chr1
    
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
       RETURN
    END IF
    LET g_action_choice = " "
    LET g_bp_flag = "subjectlist"
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
 WHILE TRUE   
    DISPLAY ARRAY g_aag_l TO s_aag.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
 
       BEFORE DISPLAY
          IF g_curs_index<>0 AND g_curs_index <= g_row_count THEN
             CALL FGL_SET_ARR_CURR(g_curs_index)
          END IF
       BEFORE ROW
          LET l_ac1 = ARR_CURR()
          CALL cl_show_fld_cont()
  
       ON ACTION main
          LET g_bp_flag = 'main'
          LET l_ac1 = ARR_CURR()
          LET g_jump = l_ac1
          LET g_no_ask = TRUE
          IF g_rec_b1 >0 THEN
             #CALL i102_fetch('/')   #FUN-C50147 mark
             CALL i102_fetch('/',0)  #FUN-C50147 
          END IF
          CALL cl_set_comp_visible("page100", FALSE)
          CALL ui.interface.refresh()
          CALL cl_set_comp_visible("page100", TRUE)
          EXIT DISPLAY
  
       ON ACTION CONTROLS
          CALL cl_set_head_visible("","AUTO")
  
       ON ACTION subjectlist
          LET g_bp_flag ="subjectlist"
          EXIT DISPLAY
  
       ON ACTION help
          LET g_action_choice="help"
          EXIT DISPLAY
  
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
  
       ON ACTION exit
          EXIT PROGRAM 0
          LET g_action_choice="exit"
          EXIT WHILE
          EXIT DISPLAY
  
       ON ACTION controlg
          LET g_action_choice="controlg"
          CALL cl_cmdask()
          EXIT DISPLAY
  
       ON ACTION accept
          LET l_ac1 = ARR_CURR()
          LET g_jump = l_ac1
          LET g_no_ask = TRUE
          LET g_bp_flag = "main"   #NO.FUN-840018
          #CALL i102_fetch('/')   #FUN-C50147
          CALL i102_fetch('/',0)  #FUN-C50147
          CALL cl_set_comp_visible("page100", FALSE)   #no.FUN-840018 ADD
          CALL ui.interface.refresh()                  #NO.FUN-840018 ADD
          CALL cl_set_comp_visible("page100", TRUE)    #NO.FUN-840018 ADD
          EXIT DISPLAY
  
       ON ACTION cancel
          LET INT_FLAG=FALSE 		
          LET g_action_choice="exit"
          EXIT DISPLAY
  
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
  
       ON ACTION about
          CALL cl_about()
       
       ON ACTION related_document
         LET g_action_choice="related_document"
         IF cl_chk_act_auth() THEN
             IF g_aag.aag01 IS NOT NULL THEN
                LET g_doc.column1 = "aag00"
                LET g_doc.value1 = g_aag.aag00
                LET g_doc.column2 = "aag01"
                LET g_doc.value2 = g_aag.aag01
                CALL cl_doc()
             END IF
          END IF
         EXIT DISPLAY
  
       AFTER DISPLAY
          CONTINUE DISPLAY
  
    END DISPLAY
    IF g_bp_flag = "main" THEN   #NO.FUN-840018
       EXIT WHILE
    END IF
 END WHILE
 END FUNCTION
 ##FUN-A50010 mark END ###
#No.FUN-C50147  --End 去掉mark

FUNCTION i102_carry()
   DEFINE l_i       LIKE type_file.num10                                        
   DEFINE l_j       LIKE type_file.num10
 
   IF cl_null(g_aag.aag00) OR cl_null(g_aag.aag01) THEN RETURN END IF
   IF g_aag.aagacti <> 'Y' THEN
      CALL cl_err(g_aag.aag00,'aoo-090',1)
      RETURN
   END IF
   #input data center                                                           
   LET g_gev04 = NULL                                                           
 
   #是否為資料中心的拋轉DB                                                      
   SELECT gev04 INTO g_gev04 FROM gev_file WHERE gev01 = '6'                 
      AND gev02 = g_plant AND gev03 = 'Y'                 
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err(g_gev04,'aoo-036',1)                                          
      RETURN                                                                    
   END IF                                                                       
   IF cl_null(g_gev04) THEN RETURN END IF
                                                                             
   #開窗選擇拋轉的db清單         
   LET g_sql = "SELECT COUNT(*) FROM &aag_file WHERE aag00='",
               g_aag.aag00,"' AND aag01='",g_aag.aag01,"'"                  
   CALL s_dc_sel_db1(g_gev04,'6',g_sql)                             
   IF INT_FLAG THEN                                                             
      LET INT_FLAG=0                                                            
      RETURN                                                                    
   END IF
   CALL g_aagx.clear()                                                          
   LET g_aagx[1].sel   = 'Y'                                              
   LET g_aagx[1].aag01 = g_aag.aag01                               
   LET g_aagx[1].aag00 = g_aag.aag00                    
   
   FOR l_i = 1 TO g_azp1.getLength()                                                                                                
       LET g_azp[l_i].sel   = g_azp1[l_i].sel                                                                                       
       LET g_azp[l_i].azp01 = g_azp1[l_i].azp01                                                                                     
       LET g_azp[l_i].azp02 = g_azp1[l_i].azp02                                                                                     
       LET g_azp[l_i].azp03 = g_azp1[l_i].azp03                                                                                     
   END FOR
                                                         
   CALL s_showmsg_init()                                                        
   CALL s_agli102_carry_aag(g_aagx,g_azp,g_gev04,'0')                         
   CALL s_showmsg()
END FUNCTION
FUNCTION i102_a()
 
   MESSAGE ""
   CLEAR FORM                                   # 清螢墓欄位內容
   CALL g_mai.clear()
   INITIALIZE g_aag.* TO NULL
 
  #LET g_aag.aag19 = 31   #FUN-9C0113
   LET g_aag.aag19 = 30   #FUN-9C0113
   LET g_aag.aag21 = 'N'
   LET g_aag.aag23 = 'N'
   LET g_aag.aag42 = 'N'  #No.FUN-A30077
   LET g_aag.aag43 = 'N'  #FUN-C90061 add aag43
   LET g_aag.aag05 = 'N'
   LET g_aag.aag09 = 'Y'
   LET g_aag01_t = NULL
   LET g_aag00_t = NULL  #No.FUN-730020
   LET g_aag.aag44 = 'N'  #No.FUN-D40118  Add
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_aag.aagacti ='Y'                   #有效的資料
      LET g_aag.aaguser = g_user
      LET g_aag.aagoriu = g_user #FUN-980030
      LET g_aag.aagorig = g_grup #FUN-980030
      LET g_aag.aaggrup = g_grup               #使用者所屬群
      LET g_aag.aagdate = g_today
      LET g_aag.aag20 = 'N'
      LET g_aag.aag221 = 'F'
      LET g_aag.aag24 = 1
      LET g_aag.aag38 = 'N' #FUN-670032 add aag38
      LET g_aag.aag39 = g_plant  #FUN-820031
      IF NOT s_dc_ud_flag('6',g_aag.aag39,g_plant,'a') THEN                                                                            
         CALL cl_err(g_aag.aag39,'aoo-078',1)                                                                                         
         RETURN                                                                                                                       
      END IF   
      CALL i102_i("a")                      # 各欄位輸入
 
      IF INT_FLAG THEN                         # 若按了DEL鍵
         INITIALIZE g_aag.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         CALL g_mai.clear()
         EXIT WHILE
      END IF
 
      IF g_aag.aag01 IS NULL OR g_aag.aag00 IS NULL THEN  # KEY 不可空白  #No.FUN-730020
          CONTINUE WHILE
      END IF
 
      INSERT INTO aag_file VALUES(g_aag.*)       # DISK WRITE
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","aag_file",g_aag.aag00,g_aag.aag01,SQLCA.sqlcode,"","",1)  #No.FUN-660123  #No.FUN-730020
         CONTINUE WHILE
      ELSE
         LET g_aag_t.* = g_aag.*                # 保存上筆資料
         SELECT aag00 INTO g_aag.aag00 FROM aag_file
          WHERE aag01 = g_aag.aag01
            AND aag00 = g_aag.aag00   #No.FUN-730020
         CALL i102_tree_update()      #No.FUN-A50010
      END IF
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i102_i(p_cmd)
DEFINE p_cmd                       LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
       l_cmd                       LIKE abh_file.abh11,          #No.FUN-680098 VARCHAR(30)
       l_flag                      LIKE type_file.chr1,          #判斷必要欄位是否有輸入      #No.FUN-680098 VARCHAR(1)
       l_num                       LIKE type_file.num5,          #No.FUN-680098    SMALLINT
       l_aaeacti                   LIKE aae_file.aaeacti,
       l_aaaacti                   LIKE aaa_file.aaaacti,       #No.FUN-730020
       l_cntabb,l_cntabg,l_cntabh  LIKE type_file.num10,        #No.FUN-680098     INTEGER
       l_n                         LIKE type_file.num5          #No.FUN-680098     SMALLINT
DEFINE l_t1                        STRING                       #No.TQC-860012
DEFINE l_t2                        LIKE type_file.num5          #No.TQC-860012
DEFINE l_t3                        LIKE type_file.num5          #No.TQC-860012
DEFINE l_aag24                     LIKE aag_file.aag24          #No.TQC-860012
DEFINE l_aag03                     LIKE aag_file.aag03          #TQC-A50015 Add                                                     
DEFINE l_aag04                     LIKE aag_file.aag04          #TQC-A50015 Add                                                     
DEFINE l_aag05                     LIKE aag_file.aag05          #TQC-A50015 Add
 
   DISPLAY BY NAME g_aag.aag38,g_aag.aaguser,g_aag.aaggrup,#FUN-670032 add aag38
                   g_aag.aagdate,g_aag.aagacti,g_aag.aag39 #FUN-820031
 
   LET g_on_change_02 = TRUE   
   LET g_on_change_13 = TRUE   
   INPUT BY NAME g_aag.aagoriu,g_aag.aagorig,g_aag.aag00,g_aag.aag01,g_aag.aag02,g_aag.aag13,g_aag.aag03,g_aag.aag04,g_aag.aag06,    #No.FUN-6C0012  #No.FUN-730020
#                g_aag.aag09,g_aag.aag12,g_aag.aag38,g_aag.aag221,g_aag.aag223,g_aag.aag224, #FUN-670032 add aag38
#                g_aag.aag09,g_aag.aag12,g_aag.aag38,g_aag.aag41,g_aag.aag221,g_aag.aag223,g_aag.aag224, #FUN-670032 add aag38  FUN-A10088 add aag41
                 g_aag.aag09,g_aag.aag12,g_aag.aag38,g_aag.aag221,g_aag.aag223,g_aag.aag224, #FUN-670032 add aag38  TQC-A40089 del aag41
#                g_aag.aag225,g_aag.aag226,g_aag.aag19,g_aag.aag07,g_aag.aag08,
                 g_aag.aag225,g_aag.aag226,g_aag.aag19,g_aag.aag41,g_aag.aag07,g_aag.aag08,   #No.TQC-A40089 add aag41
                 g_aag.aag24,g_aag.aag05,g_aag.aag21,g_aag.aag23,
                 g_aag.aag42,    #No.FUN-A30077
                 g_aag.aag43,    #FUN-C90061 add aag43
                 g_aag.aag44,   #No.FUN-D40118   Add g_aag.aag44
                 g_aag.aag14 WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i102_set_entry(p_cmd)
         CALL i102_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD aag00
         IF NOT cl_null(g_aag.aag00) THEN                                      
            SELECT aaaacti INTO l_aaaacti FROM aaa_file                          
             WHERE aaa01=g_aag.aag00                                           
            IF SQLCA.SQLCODE=100 THEN                                            
               CALL cl_err3("sel","aaa_file",g_aag.aag00,"",100,"","",1)            
               NEXT FIELD aag00                                                 
            END IF                                                               
            IF l_aaaacti='N' THEN                                                
               CALL cl_err(g_aag.aag00,"9028",1)                                    
               NEXT FIELD aag00                                                 
            END IF                                                               
         END IF
         IF NOT cl_null(g_aag.aag01) AND NOT cl_null(g_aag.aag00) THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND (g_aag.aag01 != g_aag01_t
                                            OR  g_aag.aag00 != g_aag00_t)) THEN
               SELECT count(*) INTO l_n FROM aag_file
                WHERE aag01 = g_aag.aag01
                  AND aag00 = g_aag.aag00
               IF l_n > 0 THEN  # Duplicated
                  CALL cl_err(g_aag.aag01,-239,0)
                  LET g_aag.aag00 = g_aag00_t
                  LET g_aag.aag01 = g_aag01_t
                  DISPLAY BY NAME g_aag.aag01
                  DISPLAY BY NAME g_aag.aag00
                  NEXT FIELD aag00
               END IF
            END IF
         END IF
 
      AFTER FIELD aag01
         IF NOT cl_null(g_aag.aag01) AND NOT cl_null(g_aag.aag00) THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND (g_aag.aag01 != g_aag01_t
                                            OR  g_aag.aag00 != g_aag00_t)) THEN
               SELECT count(*) INTO l_n FROM aag_file
                WHERE aag01 = g_aag.aag01
                  AND aag00 = g_aag.aag00
               IF l_n > 0 THEN  # Duplicated
                  CALL cl_err(g_aag.aag01,-239,0)
                 #LET g_aag.aag00 = g_aag00_t      #MOD-C50115 mark
                  LET g_aag.aag01 = g_aag01_t
                  DISPLAY BY NAME g_aag.aag01
                 #DISPLAY BY NAME g_aag.aag00      #MOD-C50115 mark
                 #NEXT FIELD aag00                 #MOD-C50115 mark
                  NEXT FIELD aag01                 #MOD-C50115 add
               END IF
            END IF
         END IF
          IF NOT cl_null(g_aag.aag01) THEN                                             
             CALL s_field_chk(g_aag.aag01,'6',g_plant,'aag01') RETURNING g_flag2
             IF g_flag2 = '0' THEN                                            
                CALL cl_err(g_aag.aag01,'aoo-043',1)                          
                LET g_aag.aag01 = g_aag_o.aag01                               
                DISPLAY BY NAME g_aag.aag01                                   
                NEXT FIELD aag01 
#TQC-B90121 --begin--
             ELSE 
                IF p_cmd = 'u' AND NOT cl_null(g_aag01_t) AND g_aag01_t != g_aag.aag01 THEN             	  
                   LET g_chr_1 = 'Y'
                END IF 
#TQC-B90121 --end--                                                             
             END IF   
          END IF                                                        
      IF i102_chk_aag01(g_aag.aag01) THEN 
         NEXT FIELD aag01
      END IF 
#No.FUN-A10088 --begin
      AFTER FIELD aag41
         IF NOT cl_null(g_aag.aag41) THEN   
            IF p_cmd ='a' OR (p_cmd ='u' AND g_aag.aag41 <> g_aag_t.aag41) THEN        #No.TQC-A40089
               CALL i102_aag41(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aag.aag41,g_errno,0)
                  NEXT FIELD aag41
               END IF
            END IF         #No.TQC-A40089
         END IF
#No.FUN-A10088 --end

 
      ON CHANGE aag02
         IF cl_null(g_aag.aag00) THEN NEXT FIELD aag00 END IF   #No.FUN-730020
         IF cl_null(g_aag.aag01) THEN NEXT FIELD aag01 END IF 
         IF g_zx14 = "Y" AND g_on_change_02 THEN
            CALL p_itemname_update("aag_file","aag02",g_aag.aag00 || ',' || g_aag.aag01) #TQC-6C0060 mark  #No.FUN-730020
            CALL cl_show_fld_cont()   #TQC-6C0060 
         END IF
 
      ON CHANGE aag13
         IF cl_null(g_aag.aag00) THEN NEXT FIELD aag00 END IF   #No.FUN-730020
         IF cl_null(g_aag.aag01) THEN NEXT FIELD aag01 END IF 
         IF g_zx14 = "Y" AND g_on_change_13 THEN
            CALL p_itemname_update("aag_file","aag13",g_aag.aag00 || ',' || g_aag.aag01) #TQC-6C0060
            CALL cl_show_fld_cont()   #TQC-6C0060 
         END IF
 
      AFTER FIELD aag03
         IF NOT cl_null(g_aag.aag03) THEN
            IF g_aag.aag03 NOT MATCHES'[24]' THEN
               LET g_aag.aag03 = g_aag_o.aag03
               DISPLAY BY NAME g_aag.aag03
               NEXT FIELD aag03
            END IF
            LET g_aag_o.aag03 = g_aag.aag03
         END IF
 
      AFTER FIELD aag04
         IF NOT cl_null(g_aag.aag04) THEN
            IF g_aag.aag04 NOT MATCHES'[12]' THEN
               LET g_aag.aag04 = g_aag_o.aag04
               DISPLAY BY NAME g_aag.aag04
               NEXT FIELD aag04
            END IF
            LET g_aag_o.aag04 = g_aag.aag04
         END IF
 
      AFTER FIELD aag05
         IF NOT cl_null(g_aag.aag05) THEN
            IF g_aag.aag05 NOT MATCHES'[YN]' THEN
               LET g_aag.aag05 = g_aag_o.aag05
               NEXT FIELD aag05
            END IF
            LET g_aag_o.aag05 = g_aag.aag05
         END IF
 
      AFTER FIELD aag06
         IF NOT cl_null(g_aag.aag06) THEN
            IF g_aag.aag06 NOT MATCHES'[12]' THEN
               LET g_aag.aag06 = g_aag_o.aag06
               DISPLAY BY NAME g_aag.aag06
               NEXT FIELD aag06
            END IF
            LET g_aag_o.aag06 = g_aag.aag06
         END IF
 
       #統制明細別      
       BEFORE FIELD aag07
         CALL i102_set_entry(p_cmd)
 
      AFTER FIELD aag07
         IF NOT cl_null(g_aag.aag07) THEN
            IF g_aag.aag07 NOT MATCHES'[123]' THEN
               LET g_aag.aag07 = g_aag_o.aag07
               DISPLAY BY NAME g_aag.aag07
               NEXT FIELD aag07
            END IF
            IF (g_aag.aag21='Y' OR g_aag.aag23='Y') AND g_aag.aag07='1' THEN
               CALL cl_err(g_aag.aag07,'agl-137',1)
               LET g_aag.aag07 = g_aag_o.aag07
               DISPLAY BY NAME g_aag.aag07
               NEXT FIELD aag07
            END IF
           #No.FUN-A30077  --Begin                                              
            IF g_aag.aag42='Y' AND g_aag.aag07='1' THEN                         
               CALL cl_err(g_aag.aag07,'agl-196',1)                             
               LET g_aag.aag07 = g_aag_o.aag07                                  
               DISPLAY BY NAME g_aag.aag07                                      
               NEXT FIELD aag07                                                 
            END IF                                                              
           #No.FUN-A30077  --End 
            IF g_aag.aag07 != '2' AND p_cmd='a' THEN    #MOD-710206
               LET g_aag.aag08 = g_aag.aag01
               DISPLAY BY NAME g_aag.aag08
            END IF
#NO.MOD-A10143 --begin
            IF g_aag.aag07 ='1' THEN
            #  LET g_aag.aag07 = g_aag_o.aag07  #No.FUN-A40020                  
               LET g_aag_o.aag07 = g_aag.aag07  #No.FUN-A40020 
               LET g_success ='Y'
               CALL i102_chk_x()
               IF g_success = 'N' THEN
                  LET g_aag.aag07 = g_aag_o.aag07
                  DISPLAY BY NAME g_aag.aag07
                  NEXT FIELD aag07
               END IF
             END IF
#NO.MOD-A10143 --end

            LET g_aag_o.aag07 = g_aag.aag07
         END IF
         CALL i102_set_no_entry(p_cmd)
         IF p_cmd='a' THEN
         IF g_aag.aag07 <> '3' THEN
            LET l_t1 = g_aag.aag01 CLIPPED
            LET l_t2 = g_aaz.aaz107 + g_aaz.aaz108
            #IF l_t1.getlength() >= l_t2 THEN     #MOD-B30377
            IF NOT cl_null(g_aaz.aaz107) AND NOT cl_null(g_aaz.aaz108) AND l_t1.getlength() >= l_t2 THEN
               LET l_t3 = l_t1.getlength() - g_aaz.aaz108
               LET g_aag.aag08 = g_aag.aag01[1,l_t3]
               DISPLAY BY NAME g_aag.aag08
               LET l_aag24=''
               SELECT aag24 INTO l_aag24 FROM aag_file
                WHERE aag01 = g_aag.aag08
                 AND aag00 = g_aag.aag00  #No.FUN-730020
               IF cl_null(l_aag24) THEN
                  LET l_aag24 = 0
               END IF
               LET g_aag.aag24 = l_aag24 + 1
            ELSE
               LET g_aag.aag08 = g_aag.aag01
               DISPLAY BY NAME g_aag.aag08
               IF g_aag.aag07 = '1' THEN
                   LET g_aag.aag24 = 1
               ELSE
                   LET g_aag.aag24 = 99
               END IF
            END IF
         END IF
         END IF
         IF g_aag.aag07 MATCHES '[3]' THEN   #TQC-860012
#           LET g_aag.aag24 = 99      #No.FUN-A40020          #No.FUN-A60024 mark
            LET g_aag.aag24 = 1       #No.FUN-A40020          #No.FUN-A60024 freE
            LET g_aag.aag08 = g_aag.aag01    #TQC-A90149 
            DISPLAY BY NAME g_aag.aag08      #TQC-A90149
         END IF                              #TQC-860012
        
      BEFORE FIELD aag08
          #MOD-4A0252避免開窗結果無法顯示
         IF g_aag.aag07 = '2' AND p_cmd='a' THEN    #MOD-710206
            DISPLAY '                        ' TO aag08
         END IF
 
      AFTER FIELD aag08
         IF NOT cl_null(g_aag.aag08) THEN
            SELECT COUNT(*) INTO l_n FROM aaz_file 
             WHERE aaz00 ='0' AND (aaz107 IS NOT NULL AND aaz108 IS NOT NULL)
            IF l_n > 0 THEN 
               IF i102_chk(g_aag.aag01,g_aag.aag08) THEN 
                  #No.FUN-B10050  --Begin
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.default1 = g_aag.aag08
                  LET g_qryparam.arg1 = g_aag.aag00  #No.FUN-730070
                  LET g_qryparam.where =" aag07 ='1' AND aag03 ='2' AND aagacti = 'Y' AND aag01 LIKE '",g_aag.aag08 CLIPPED,"%'"
                  CALL cl_create_qry() RETURNING g_aag.aag08
                  DISPLAY BY NAME g_aag.aag08
                  #No.FUN-B10050  --End  
                  NEXT FIELD aag08
               END IF 
            END IF
         END IF
        #IF g_aag.aag07='2' AND NOT cl_null(g_aag.aag08) THEN                                            #MOD-A90141 mark
         IF g_aag.aag07='2' AND NOT cl_null(g_aag.aag08) OR (g_aag.aag07='1' AND g_aag.aag24 > 1) THEN   #MOD-A90141
            SELECT * FROM aag_file
             WHERE aag01=g_aag.aag08 AND aag07='1'
               AND aag00=g_aag.aag00  #No.FUN-730020
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","aag_file",g_aag.aag08,"","agl-001","","",1)  #No.FUN-660123
               #No.FUN-B10050  --Begin
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_aag.aag08
               LET g_qryparam.arg1 = g_aag.aag00  #No.FUN-730070
               LET g_qryparam.where =" aag07 ='1' AND aag03 ='2' AND aagacti = 'Y' AND aag01 LIKE '",g_aag.aag08 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_aag.aag08
               DISPLAY BY NAME g_aag.aag08
               #No.FUN-B10050  --End  
               NEXT FIELD aag08
            END IF
            #TQC-A50015-Add-Begin                                                                                                   
            SELECT aag03,aag04,aag05                                                                                                
              INTO l_aag03,l_aag04,l_aag05                                                                                          
              FROM aag_file                                                                                                         
             WHERE aag01=g_aag.aag08 AND aag07='1'                                                                                  
               AND aag00=g_aag.aag00                                                                                                
            IF p_cmd='a' THEN                                                                                                       
               LET g_aag.aag03 = l_aag03                                                                                            
               LET g_aag.aag04 = l_aag04                                                                                            
               LET g_aag.aag05 = l_aag05                                                                                            
               DISPLAY BY NAME g_aag.aag03,g_aag.aag04,g_aag.aag05                                                                  
            END IF                                                                                                                  
            IF p_cmd='u' AND g_aag.aag08 != g_aag_o.aag08 THEN                                                                      
               LET g_aag.aag03 = l_aag03                                                                                            
               LET g_aag.aag04 = l_aag04                                                                                            
               LET g_aag.aag05 = l_aag05                                                                                            
               DISPLAY BY NAME g_aag.aag03,g_aag.aag04,g_aag.aag05                                                                  
            END IF                                                                                                                  
            #TQC-A50015-Add-End
            LET g_aag_o.aag08 = g_aag.aag08
         END IF
         IF g_aag.aag07 MATCHES '[3]' THEN  
#           LET g_aag.aag24 = 99      #No.FUN-A40020    No.FUN-A60024 mark                            
            LET g_aag.aag24 = 1       #No.FUN-A40020    No.FUN-A60024 free
         END IF                            
         IF g_aag.aag07 MATCHES '[1]' THEN 
            SELECT aag24 INTO g_aag.aag24 FROM aag_file
             WHERE aag01 = g_aag.aag08
               AND aag00 = g_aag.aag00   #No.FUN-730020
            IF cl_null(g_aag.aag24) THEN
               LET g_aag.aag24 = 0
            END IF
            IF (g_aag.aag08 != g_aag.aag01)  THEN  #No.TQC-940134 
               LET g_aag.aag24 = g_aag.aag24 + 1
            ELSE                                   #MOD-A90141
               LET g_aag.aag24 = 1                 #MOD-A90141
            END IF
         END IF
         IF g_aag.aag07 = '2' THEN
            LET g_aag.aag24 = 99                                                
            DISPLAY BY NAME g_aag.aag24 
         END IF
         DISPLAY BY NAME g_aag.aag24
 
      AFTER FIELD aag24
         IF g_aag.aag24 <=0 THEN
            CALL cl_err('','ggl-816',0)
            NEXT FIELD aag24
         END IF
        #-MOD-A90141-add-
         IF g_aag.aag07 = '1' AND g_aag.aag24 = 1 THEN 
            LET g_aag.aag08 = g_aag.aag01
         END IF 
         IF g_aag.aag07 = '1' AND g_aag.aag24 > 1 THEN 
            SELECT * FROM aag_file
             WHERE aag01=g_aag.aag08 AND aag07='1'
               AND aag00=g_aag.aag00  
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","aag_file",g_aag.aag08,"","agl-001","","",1)  
               NEXT FIELD aag08
            END IF
         END IF
        #-MOD-A90141-end-
         #No.TQC-A30001  --Begin                                                
#        IF g_aag.aag07 MATCHES '[23]' AND NOT cl_null(g_aag.aag24) THEN        #No.FUN-A40020    No.FUN-A60024 mark
         IF g_aag.aag07 = '2' AND NOT cl_null(g_aag.aag24) THEN  #No.FUN-A40020                   No.FUN-A60024 free  
            IF g_aag.aag24 <> '99' THEN                                         
               LET g_aag.aag24 = '99'                                           
               DISPLAY BY NAME g_aag.aag24                                      
               NEXT FIELD aag24                                                 
            END IF                                                              
         END IF                                                                 
         #No.TQC-A30001  --End    
         #No.FUN-A40020  --Begin                                                
        #IF g_aag.aag07 = '3' AND NOT cl_null(g_aag.aag24) THEN           #MOD-BC0100 mark
         IF (g_aag.aag07 = '3' AND NOT cl_null(g_aag.aag24))              #MOD-BC0100 add
            OR (g_aag.aag07 = '1' AND g_aag.aag08 = g_aag.aag01) THEN     #MOD-BC0100 add
            IF g_aag.aag24 <> '1' THEN                                          
               LET g_aag.aag24 = '1'                                            
               DISPLAY BY NAME g_aag.aag24                                      
               NEXT FIELD aag24                                                 
            END IF                                                              
         END IF                                                                 
         #No.FUN-A40020  --End
         CALL s_field_chk(g_aag.aag24,'6',g_plant,'aag24') RETURNING g_flag2                                                  
         IF g_flag2 = '0' THEN                                                                                                
            CALL cl_err(g_aag.aag24,'aoo-043',1)                                                                              
            LET g_aag.aag24 = g_aag_o.aag24                                                                                   
            DISPLAY BY NAME g_aag.aag24                                                                                       
            NEXT FIELD aag24                                                                                                  
         END IF
 
      AFTER FIELD aag09
         LET g_aag_o.aag09 = g_aag.aag09
         #TQC-A50008--Add--Begin                                                                                                    
         IF g_aag.aag09 = 'Y' THEN                                                                                                  
            CALL cl_set_comp_entry("aag12",FALSE)                                                                                   
         ELSE                                                                                                                       
            CALL cl_set_comp_entry("aag12",TRUE)                                                                                    
         END IF                                                                                                                     
                                                                                                                                    
      ON CHANGE aag09                                                                                                               
         IF g_aag.aag09 = 'Y' THEN                                                                                                  
            CALL cl_set_comp_entry("aag12",FALSE)                                                                                   
         ELSE                                                                                                                       
            CALL cl_set_comp_entry("aag12",TRUE)                                                                                    
         END IF                                                                                                                     
                                                                                                                                    
      BEFORE FIELD aag12                                                                                                            
         IF g_aag.aag09 = 'Y' THEN                                                                                                  
            CALL cl_set_comp_entry("aag12",FALSE)                                                                                   
         ELSE                                                                                                                       
            CALL cl_set_comp_entry("aag12",TRUE)                                                                                    
         END IF                                                                                                                     
         #TQC-A50008--Add--End
 
      AFTER FIELD aag221         #費用固定變動否        
        LET g_aag_o.aag221 = g_aag.aag221
 
      AFTER FIELD aag223
         IF NOT cl_null(g_aag.aag223) THEN
            CALL i102_aae(p_cmd,g_aag.aag223)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_aag.aag223 = g_aag_t.aag223
               DISPLAY BY NAME g_aag.aag223
               NEXT FIELD aag223
            END IF
         END IF
 
      AFTER FIELD aag224
         IF NOT cl_null(g_aag.aag224) THEN
            CALL i102_aae(p_cmd,g_aag.aag224)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_aag.aag224 = g_aag_t.aag224
               DISPLAY BY NAME g_aag.aag224
               NEXT FIELD aag224
            END IF
         END IF
 
      AFTER FIELD aag225
         IF NOT cl_null(g_aag.aag225) THEN
            CALL i102_aae(p_cmd,g_aag.aag225)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_aag.aag225 = g_aag_t.aag225
               DISPLAY BY NAME g_aag.aag225
               NEXT FIELD aag225
            END IF
         END IF
 
      AFTER FIELD aag226
         IF NOT cl_null(g_aag.aag226) THEN
            CALL i102_aae(p_cmd,g_aag.aag226)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_aag.aag226 = g_aag_t.aag226
               DISPLAY BY NAME g_aag.aag226
               NEXT FIELD aag226
            END IF
         END IF

#MOD-A80111 --begin
#No.TQC-A40089 --begin 
#     BEFORE FIELD aag19
#        CALL cl_set_comp_required('aag41',FALSE)
#No.TQC-A40089 --end
#MOD-A80111 --end

      AFTER FIELD aag19
         IF g_aag.aag19 IS NOT NULL THEN
            IF g_aag.aag19 <0 OR g_aag.aag19 > 37 THEN
               LET g_aag.aag19 = g_aag_o.aag19
               DISPLAY BY NAME g_aag.aag19
               NEXT FIELD aag19
            END IF
            LET g_aag_o.aag19 = g_aag.aag19
#MOD-A80111 --begin
#No.TQC-A40089 --begin 
#           IF g_aag.aag19 <>'1' THEN
#              CALL cl_set_comp_required('aag41',TRUE)
#           END IF
#No.TQC-A40089 --end
#MOD-A80111 --end
         END IF
 
      AFTER FIELD aag21
         LET g_aag_o.aag21 = g_aag.aag21
 
      AFTER FIELD aag23
         LET g_aag_o.aag23 = g_aag.aag23

      #No.FUN-A30077  --Begin                                                   
      AFTER FIELD aag42                                                         
         LET g_aag_o.aag42 = g_aag.aag42                                        
      #No.FUN-A30077  --End
 
      # #FUN-C90061 add --begin--
      AFTER FIELD aag43
         LET g_aag_o.aag43 = g_aag.aag43
      #FUN-C90061 add -- end

      AFTER INPUT
         LET g_aag.aaguser = s_get_data_owner("aag_file") #FUN-C10039
         LET g_aag.aaggrup = s_get_data_group("aag_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
         IF cl_null(g_aag.aag02) THEN
            DISPLAY BY NAME g_aag.aag02
            NEXT FIELD aag02
         END IF
 
         IF cl_null(g_aag.aag03) OR g_aag.aag03 NOT MATCHES'[24]' THEN
            DISPLAY BY NAME g_aag.aag03
            NEXT FIELD aag03
         END IF
 
         IF cl_null(g_aag.aag04) OR g_aag.aag04 NOT MATCHES'[12]' THEN
            DISPLAY BY NAME g_aag.aag04
            NEXT FIELD aag04
         END IF
 
         IF cl_null(g_aag.aag05) OR g_aag.aag05 NOT MATCHES'[YN]' THEN
            DISPLAY BY NAME g_aag.aag05
            NEXT FIELD aag05
         END IF
 
         IF cl_null(g_aag.aag06) OR g_aag.aag06 NOT MATCHES'[12]' THEN
            DISPLAY BY NAME g_aag.aag06
            NEXT FIELD aag06
         END IF
 
         IF cl_null(g_aag.aag07) THEN
            DISPLAY BY NAME g_aag.aag07
            NEXT FIELD aag07
         END IF
#MOD-A80111 --begin
#No.TQC-A40089 --begin 
#        IF g_aag.aag19 <>'1' AND cl_null(g_aag.aag41) THEN
#           DISPLAY BY NAME g_aag.aag41
#           NEXT FIELD aag41
#        END IF
#No.TQC-A40089 --end
#MOD-A80111 --end
 
         IF g_aag.aag07='2' AND NOT cl_null(g_aag.aag08) THEN
            SELECT * FROM aag_file
             WHERE aag01=g_aag.aag08 AND aag07='1'
               AND aag00=g_aag.aag00   #No.FUN-730020
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","aag_file",g_aag.aag08,"","agl-001","","",0)  
               NEXT FIELD aag08
            ELSE
               IF g_aag.aag01 = g_aag.aag08 THEN
                  CALL cl_err3("sel","aag_file",g_aag.aag08,"","agl-001","","",0)  
                  NEXT FIELD aag08
               END IF
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(aag00)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               LET g_qryparam.default1 = g_aag.aag00
               CALL cl_create_qry() RETURNING g_aag.aag00
               DISPLAY BY NAME g_aag.aag00
               NEXT FIELD aag00  
            WHEN INFIELD(aag223)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aae"
               LET g_qryparam.default1 = g_aag.aag223
               CALL cl_create_qry() RETURNING g_aag.aag223
               DISPLAY BY NAME g_aag.aag223
               NEXT FIELD aag223
            WHEN INFIELD(aag224)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aae"
               LET g_qryparam.default1 = g_aag.aag224
               CALL cl_create_qry() RETURNING g_aag.aag224
               DISPLAY BY NAME g_aag.aag224
               NEXT FIELD aag224
            WHEN INFIELD(aag225)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aae"
               LET g_qryparam.default1 = g_aag.aag225
               CALL cl_create_qry() RETURNING g_aag.aag225
               DISPLAY BY NAME g_aag.aag225
               NEXT FIELD aag225
            WHEN INFIELD(aag226)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aae"
               LET g_qryparam.default1 = g_aag.aag226
               CALL cl_create_qry() RETURNING g_aag.aag226
               DISPLAY BY NAME g_aag.aag226
               NEXT FIELD aag226
            WHEN INFIELD(aag08)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.default1 = g_aag.aag08
               LET g_qryparam.arg1 = g_aag.aag00  #No.FUN-730070
               LET g_qryparam.where =" aag07 ='1' AND aag03 ='2' "
               CALL cl_create_qry() RETURNING g_aag.aag08
               DISPLAY BY NAME g_aag.aag08
               NEXT FIELD aag08
#No.FUN-A10088 --begin
            WHEN INFIELD(aag41)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nml"
               LET g_qryparam.default1 = g_aag.aag41
               CALL cl_create_qry() RETURNING g_aag.aag41
               NEXT FIELD aag41
#No.FUN-A10088 --end
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON ACTION account_extra_description
          LET g_cmd = "agli103 '",g_aag.aag00 CLIPPED,"' '",g_aag.aag01 CLIPPED,"'" #MOD-4C0171  #No.FUN-730020
         CALL cl_cmdrun(g_cmd)
 
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
 
       ON ACTION update_name
          CASE
             WHEN INFIELD(aag02)
                CALL GET_FLDBUF(aag02) RETURNING g_aag.aag02
                CALL p_itemname_update("aag_file","aag02",g_aag.aag00 || ',' || g_aag.aag01) #TQC-6C0060 mark  #No.FUN-730020
                LET g_on_change_02=FALSE
                CALL cl_show_fld_cont()   #TQC-6C0060 
             WHEN INFIELD(aag13)
                CALL GET_FLDBUF(aag13) RETURNING g_aag.aag13
                CALL p_itemname_update("aag_file","aag13",g_aag.aag00 || ',' || g_aag.aag01) #TQC-6C0060 mark  #No.FUN-730020
                LET g_on_change_13=FALSE
                CALL cl_show_fld_cont()   #TQC-6C0060 
          END CASE
    END INPUT
 
END FUNCTION
 
FUNCTION i102_set_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("aag00,aag01",TRUE)  #No.FUN-730020
   END IF
 
   IF INFIELD(aag07) OR ( NOT g_before_input_done ) THEN
 
      CALL cl_set_comp_entry("aag08,aag24,aag21,aag221,aag223,aag224,aag225,aag226,aag23",TRUE)
      CALL cl_set_comp_entry("aag42",TRUE)   #No.FUN-A30077
 
   END IF
 
END FUNCTION
 
FUNCTION i102_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("aag00,aag01",FALSE)  #No.FUN-730020
   END IF
 
   IF INFIELD(aag07) OR ( NOT g_before_input_done ) THEN
      IF g_aag.aag07 = "1" THEN
 
         CALL cl_set_comp_entry("aag21,aag221,aag223,aag224,aag225,aag226,aag23",FALSE)
         CALL cl_set_comp_entry("aag42",FALSE)       #No.FUN-A30077
      END IF
      #TQC-A70006--Add--Begin                                                                                                       
     #IF g_aag.aag07 = "1" OR g_aag.aag07 = "3" THEN  #MOD-A90141 mark 
      IF g_aag.aag07 = "3" THEN                       #MOD-A90141
         CALL cl_set_comp_entry("aag08",FALSE)                                                                                      
      END IF                                                                                                                        
      #TQC-A70006--Add--End
   END IF
 
END FUNCTION
FUNCTION i102_aae(p_cmd,p_type)
DEFINE   p_cmd       LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
         p_type      LIKE aag_file.aag223,
         l_aaeacti   LIKE aae_file.aaeacti
 
   LET g_errno = ' '
 
   SELECT aaeacti INTO l_aaeacti FROM aae_file
    WHERE aae01 = p_type
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = '100'
        WHEN l_aaeacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
 
END FUNCTION
 
FUNCTION i102_q(p_idx)
   DEFINE p_idx LIKE type_file.num5  #No.FUN-50010
   
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i102_cs(p_idx)          #No.FUN-50010
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      CALL g_mai.clear()
      RETURN
   END IF
 
   OPEN i102_count
   FETCH i102_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
 
   OPEN i102_cs                           # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aag.aag01,SQLCA.sqlcode,0)
      INITIALIZE g_aag.* TO NULL
   ELSE
      IF p_idx=0 THEN        
         CALL i102_fetch('F',0)                  # 讀出TEMP第一筆並顯示
         LET g_tree_focus_idx= 0
         CALL i102_tree_fill1(g_wc_o,NULL,0,NULL,NULL,NULL)   #Tree填充
      ELSE 
         CALL i102_fetch('T',p_idx) #讀出TEMP中，雙點Tree的指定節點並顯示
      END IF
      #No.FUN-A50010  --End 
      
      ###FUN-A50010 mark START ### 
       CALL i102_list_fill()  #No.FUN-820031  #FUN-C50147                                                                                     
       LET g_bp_flag = 'list' #No.FUN-820031  #FUN-C50147
      #CALL i102_fetch('F')                  # 讀出TEMP第一筆並顯示
      ###FUN-A50010 mark START ### 
   END IF
END FUNCTION

FUNCTION i102_list_fill()
   DEFINE l_aag01         LIKE aag_file.aag01
   DEFINE l_aag00         LIKE aag_file.aag00                                                                                        
   DEFINE l_i             LIKE type_file.num10                                                                                       
   
   CALL g_aag_l.clear()                                                                                                            
   LET l_i = 1                                                                                                                     
   FOREACH i102_list_cur INTO l_aag00,l_aag01
      IF SQLCA.sqlcode THEN                                                                                                        
          CALL cl_err('foreach list_cur',SQLCA.sqlcode,1)                                                                           
          CONTINUE FOREACH                                                                                                          
      END IF
      SELECT aag00,aag01,aag02,aag13,aag04,aag07,aag08,aag24,aag05,aag21,aag23,aagacti,aag39
         INTO g_aag_l[l_i].*
      FROM aag_file
      WHERE aag00 = l_aag00 AND aag01 = l_aag01
 
      LET l_i = l_i + 1                                                                                                            
      IF l_i > g_max_rec THEN                                                                                                      
         CALL cl_err( '', 9035, 0 )                                                                                                
         EXIT FOREACH                                                                                                              
      END IF
   END FOREACH
   LET g_rec_b1 = l_i - 1                                                                                                          
   DISPLAY ARRAY g_aag_l TO s_aag.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)                                                         
      BEFORE DISPLAY                                                                                                               
         EXIT DISPLAY                                                                                                              
   END DISPLAY
END FUNCTION

FUNCTION i102_fetch(p_flag , p_idx) #FUN-A50010 加參數p_idx
   DEFINE p_flag          LIKE type_file.chr1,         #No.FUN-680098    VARCHAR(1)
          l_abso           LIKE type_file.num10         #No.FUN-680098    INTEGER
   DEFINE p_idx     LIKE type_file.num5     #雙按Tree的節點index  #FUN-A50010
   DEFINE l_i       LIKE type_file.num5     #FUN-A50010
   DEFINE l_jump    LIKE type_file.num5     #跳到QBE中Tree的指定筆 #FUN-A50010
   ##FUN-A50010 START ###
    IF p_flag = 'T' AND p_idx <= 0 THEN      #Tree index錯誤就改讀取第一筆資料
       LET p_flag = 'F'
    END IF
   ##FUN-A50010 END ###
   CASE p_flag
      WHEN 'N' FETCH NEXT     i102_cs INTO g_aag.aag00,g_aag.aag01  #No.FUN-730020
      WHEN 'P' FETCH PREVIOUS i102_cs INTO g_aag.aag00,g_aag.aag01  #No.FUN-730020
      WHEN 'F' FETCH FIRST    i102_cs INTO g_aag.aag00,g_aag.aag01  #No.FUN-730020
      WHEN 'L' FETCH LAST     i102_cs INTO g_aag.aag00,g_aag.aag01  #No.FUN-730020
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
         FETCH ABSOLUTE g_jump i102_cs INTO g_aag.aag00,g_aag.aag01  #No.FUN-730020
         LET g_no_ask = FALSE
      ##FUN-A50010 START ###
      #Tree雙點指定筆     
      WHEN 'T'
         LET l_jump = 0
         CALL i102_jump(g_curs_index) RETURNING l_jump
         LET g_jump = l_jump
         IF g_chr_1 = 'N' OR cl_null(g_chr_1) THEN      #TQC-B90121
            FETCH ABSOLUTE g_jump i102_cs INTO g_aag.aag00,g_aag.aag01    
         END IF                     #TQC-B90121   
      ##FUN-A50010 END ###
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aag.aag01,SQLCA.sqlcode,0)
      INITIALIZE g_aag.* TO NULL              #No.FUN-6B0040
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
         WHEN 'T' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF

#TQC-B90121 --begin--
   IF g_chr_1 = 'Y' THEN 
      LET g_chr_1 = 'N'
      CALL i102_fetch('F',0)                  # 讀出TEMP第一筆並顯示   
      LET g_chr_1 = 'Y'  
   ELSE 
#TQC-B90121 --end--    
     SELECT * INTO g_aag.* FROM aag_file            # 重讀DB,因TEMP有不被更新特性   
      WHERE aag00 = g_aag.aag00 AND aag01 = g_aag.aag01
     IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","aag_file",g_aag.aag00,g_aag.aag01,SQLCA.sqlcode,"","",1)  #No.FUN-660123  #No.FUN-730020
     ELSE
        LET g_data_owner = g_aag.aaguser     #No.FUN-4C0048
        LET g_data_group = g_aag.aaggrup     #No.FUN-4C0048
 
        CALL i102_show()                      # 重新顯示
     END IF
   END IF   #TQC-B90121   
 
END FUNCTION
 
FUNCTION i102_show()
 
   LET g_aag_t.* = g_aag.*
   LET g_aag_o.* = g_aag.*
 
   DISPLAY BY NAME g_aag.aagoriu,g_aag.aagorig, g_aag.aag00,g_aag.aag01,g_aag.aag02,g_aag.aag03,g_aag.aag04,g_aag.aag05,  #No.FUN-730020
                   g_aag.aag06,g_aag.aag07,g_aag.aag08,g_aag.aag09,g_aag.aag12,
#                  g_aag.aag38,g_aag.aag19,g_aag.aag24,g_aag.aag221, #FUN-670032 add aag38
                   g_aag.aag38,g_aag.aag41,g_aag.aag19,g_aag.aag24,g_aag.aag221, #FUN-670032 add aag38   FUN-A10088 add aag41
                   g_aag.aag223,g_aag.aag224,g_aag.aag225,g_aag.aag226,
                   g_aag.aag21,g_aag.aag23,g_aag.aag13,g_aag.aag44,    #No.FUN-D40118   Add g_aag.aag44
                   g_aag.aag42,            #No.FUN-A30077
                   g_aag.aag43,            #FUN-C90061 add --
                   g_aag.aag14,g_aag.aaguser,g_aag.aaggrup,g_aag.aagdate,
                   g_aag.aagmodu,g_aag.aagacti,g_aag.aag39  #FUN-820031
 
   CALL cl_set_field_pic("","","","","",g_aag.aagacti)
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i102_u()
 
   IF g_aag.aag01 IS NULL OR g_aag.aag00 IS NULL THEN  #No.FUN-730020
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_aag.* FROM aag_file WHERE aag01=g_aag.aag01                                                                      
                                         AND aag00=g_aag.aag00  #No.FUN-730020 
 
   IF NOT s_dc_ud_flag('6',g_aag.aag39,g_plant,'u') THEN                                                                           
       CALL cl_err(g_aag.aag39,'aoo-045',1)                                                                                         
       RETURN                                                                                                                       
    END IF
 
   IF g_aag.aagacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_aag.aag01,'9027',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_aag01_t = g_aag.aag01
   LET g_aag00_t = g_aag.aag00  #No.FUN-730020
   LET g_aag_o.*=g_aag.*
   BEGIN WORK
 
   OPEN i102_cl USING g_aag.aag00,g_aag.aag01
   IF STATUS THEN
      CALL cl_err("OPEN i102_cl:", STATUS, 1)
      CLOSE i102_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i102_cl INTO g_aag.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aag.aag01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_aag.aagmodu=g_user                     #修改者
   LET g_aag.aagdate = g_today                  #修改日期
 
   CALL i102_show()                          # 顯示最新資料
 
   WHILE TRUE
      LET g_chr_1  = 'N'           #TQC-B90121   
      CALL i102_i("u")                      # 欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_aag.*=g_aag_t.*
         CALL i102_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      UPDATE aag_file SET aag_file.* = g_aag.*    # 更新DB
      #WHERE aag00 = g_aag.aag00 AND aag01 = g_aag.aag01             # COLAUTH?   #No.TQC-B90119
       WHERE aag00 = g_aag00_t   AND aag01 = g_aag01_t               # COLAUTH?   #No.TQC-B90119
 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","aag_file",g_aag.aag00,g_aag.aag01,SQLCA.sqlcode,"","",1)  #No.FUN-660123  #No.FUN-730020
         CONTINUE WHILE
      END IF
 
      #若更改KEY 值, 須同時更改額外說明之KEY 值
      IF g_aag.aag01 != g_aag01_t OR g_aag.aag00 != g_aag00_t THEN
         UPDATE aak_file SET aak01 = g_aag.aag01,
                             aak00 = g_aag.aag00
          WHERE aak01 = g_aag01_t
            AND aak00 = g_aag00_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","aak_file", g_aag00_t,g_aag01_t,SQLCA.sqlcode,"","update:",1)  #No.FUN-660123
         END IF
 
        #UPDATE aee_file SET aee01 = g_aag.aag01,aae00 = g_aag.aag00  #No.TQC-B90119
         UPDATE aee_file SET aee01 = g_aag.aag01,aee00 = g_aag.aag00  #No.TQC-B90119
          WHERE aee01 = g_aag01_t AND aee00 = g_aag00_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","aee_file",g_aag00_t,g_aag01_t,SQLCA.sqlcode,"","update:",1)  #No.FUN-660123
         END IF
 
         #若僅是修改科目,則把maj中相關科目編號修改即可
         #若修改得是帳套,則直接在maj中把相關科目DELETE
         IF g_aag.aag00 = g_aag00_t THEN
            UPDATE maj_file SET maj21 = g_aag.aag01
             WHERE maj21 = g_aag01_t AND maj01 IN (
                   SELECT mai01 FROM mai_file WHERE mai00= g_aag00_t)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","maj_file",g_aag00_t,g_aag01_t,SQLCA.sqlcode,"","update:",1)  #No.FUN-660123
            END IF
 
            UPDATE maj_file SET maj22 = g_aag.aag01
             WHERE maj22 = g_aag01_t AND maj01 IN (
                   SELECT mai01 FROM mai_file WHERE mai00= g_aag00_t)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","maj_file",g_aag00_t,g_aag01_t,SQLCA.sqlcode,"","update:",1)  #No.FUN-660123
            END IF
         ELSE
            DELETE FROM maj_file
             WHERE maj21 = g_aag01_t AND maj01 IN (
                   SELECT mai01 FROM mai_file WHERE mai00= g_aag00_t)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","maj_file",g_aag00_t,g_aag01_t,SQLCA.sqlcode,"","delete:",1)  #No.FUN-660123
            END IF
 
            DELETE FROM maj_file
             WHERE maj22 = g_aag01_t AND maj01 IN (
                   SELECT mai01 FROM mai_file WHERE mai00= g_aag00_t)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","maj_file",g_aag00_t,g_aag01_t,SQLCA.sqlcode,"","delete:",1)  #No.FUN-660123
            END IF
         END IF
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i102_cl
   COMMIT WORK
   #No.FUN-D40118 ---Add--- Start
   IF g_aag.aag44 = 'N' THEN
      DELETE FROM ahk_file WHERE ahk00 = g_aag.aag00 AND ahk01 = g_aag.aag01
   END IF
  #No.FUN-D40118 ---Add--- End
 
END FUNCTION
 
FUNCTION i102_x()
DEFINE l_chr LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
   IF g_aag.aag01 IS NULL OR g_aag.aag00 IS NULL THEN  #No.FUN-730020
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   IF NOT s_dc_ud_flag('6',g_aag.aag39,g_plant,'u') THEN                                                                           
      CALL cl_err(g_aag.aag07,'aoo-045',1)                                                                                         
      RETURN                                                                                                                       
   END IF                                                                                                                          
 
   BEGIN WORK
 
   OPEN i102_cl USING g_aag.aag00,g_aag.aag01
   IF STATUS THEN
      CALL cl_err("OPEN i102_cl:", STATUS, 1)
      CLOSE i102_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i102_cl INTO g_aag.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aag.aag01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   CALL i102_show()
 
   IF cl_exp(16,21,g_aag.aagacti) THEN        #確認一下
      LET g_chr=g_aag.aagacti
      IF g_aag.aagacti='Y' THEN
#NO.MOD-A10143  --begin
         LET g_success = 'Y'
         CALL i102_chk_x()
         IF g_success = 'N' THEN RETURN END IF
#NO.MOD-A10143 --end    
         LET g_aag.aagacti='N'
      ELSE
         LET g_aag.aagacti='Y'
      END IF
 
      UPDATE aag_file SET aagacti = g_aag.aagacti,
                          aagmodu = g_user,
                          aagdate = g_today
       WHERE aag00 = g_aag.aag00 AND aag01 = g_aag.aag01
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","aag_file",g_aag.aag00,g_aag.aag01,SQLCA.sqlcode,"","",1)  #No.FUN-660123  #No.FUN-730020
         LET g_aag.aagacti=g_chr
      END IF
      DISPLAY BY NAME g_aag.aagacti
      CALL i102_list_fill()  #FUN-820031
   END IF
 
   CLOSE i102_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i102_r()
DEFINE l_chr LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
DEFINE l_cnt LIKE type_file.num5   #MOD-6A0027
DEFINE l_aag01    LIKE aag_file.aag01     #CHI-D10015

    ###No.FUN-A50010 START ###
    DEFINE l_i      LIKE type_file.num5
    DEFINE l_prev   STRING  #前一個節點
    DEFINE l_next   STRING  #後一個節點
    ###No.FUN-A50010 END ###
    LET l_aag01 = g_aag.aag01             #CHI-D10015
    IF g_aag.aag01 IS NULL OR g_aag.aag00 IS NULL THEN  #No.FUN-730020
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    IF g_aag.aagacti = 'N' THEN CALL cl_err('','abm-950',0) RETURN END IF             #TQC-950033
 
    IF NOT s_dc_ud_flag('6',g_aag.aag39,g_plant,'r') THEN                                                                           
       CALL cl_err(g_aag.aag39,'aoo-044',1)                                                                                         
       RETURN                                                                                                                       
    END IF                                                                                                                          
 
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt FROM aag_file
       WHERE aag01 <> g_aag.aag01 AND aag08 = g_aag.aag01 AND aag00 = g_aag.aag00  #No.FUN-730020
    IF l_cnt > 0  THEN
       CALL cl_err(g_aag.aag01,'agl-302',0)
       RETURN
    END IF
 
    BEGIN WORK
 
    OPEN i102_cl USING g_aag.aag00,g_aag.aag01
    IF STATUS THEN
       CALL cl_err("OPEN i102_cl:", STATUS, 1)
       CLOSE i102_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i102_cl INTO g_aag.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aag.aag01,SQLCA.sqlcode,0)    #資料被他人LOCK
        RETURN
    END IF
    CALL i102_show()
    CALL i102_chk_x()   #MOD-B80030
    SELECT COUNT(*) INTO g_cnt FROM abb_file WHERE abb03 = g_aag.aag01
                                               AND abb00 = g_aag.aag00  #No.FUN-730020
    IF g_cnt > 0 THEN CALL cl_err(g_aag.aag01,'agl-220',0) RETURN END IF
#.........................................................
 
    IF cl_delete() THEN                    #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "aag00"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_aag.aag00      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "aag01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_aag.aag01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        ###No.FUN-A50010 START ###       
        #在Tree節點刪除之前先找出刪除後要focus的節點path
        CALL cl_str_sepcnt(g_tree_focus_path,".") RETURNING l_i  #依分隔符號分隔字串後的item數量
        #刪除子節點後，focus在它的父節點
        IF l_i > 1 THEN
           CALL cl_str_sepsub(g_tree_focus_path CLIPPED,".",1,l_i-1) RETURNING g_tree_focus_path #依分隔符號分隔字串後，截取指定起點至終點的item
        #刪除的是最上層節點，focus在它的後一個節點或前一個節點
        ELSE
           CALL i102_tree_idxbypath()               #依tree path指定focus節點
           LET l_i = g_tree[g_tree_focus_idx].id    #string to integer
           LET l_i = l_i + 1
           LET l_next = l_i
           
           LET l_i = g_tree[g_tree_focus_idx].id    #string to integer
           LET l_i = l_i - 1
           LET l_prev = l_i
           
           FOR l_i = g_tree.getlength() TO 1 STEP -1
              IF g_tree[l_i].id = l_next THEN       #後一個節點
                    LET g_tree_focus_path = g_tree[l_i].path
                    EXIT FOR
              END IF
              IF g_tree[l_i].id = l_prev THEN       #前一個節點
                    LET g_tree_focus_path = g_tree[l_i].path
                    EXIT FOR
              END IF
           END FOR
        END IF
        ###No.FUN-A50010 END ###
        DELETE FROM aag_file WHERE aag01 = g_aag.aag01
                                   AND aag00 = g_aag.aag00  #No.FUN-730020
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","aag_file",g_aag.aag00,g_aag.aag01,SQLCA.sqlcode,"","",1)  #No.FUN-660123  #No.FUN-730020
        ELSE 
           CLEAR FORM
           CALL g_mai.clear()
           CALL i102_tree_update() #Tree 資料有異動 #No.FUN-A50010
        END IF
        DELETE FROM aak_file WHERE aak01 = g_aag.aag01
                                   AND aak00 = g_aag.aag00  #No.FUN-730020
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","aak_file",g_aag.aag00,g_aag.aag01,SQLCA.sqlcode,"","",1)  #No.FUN-660123  #No.FUN-730020
        END IF
        DELETE FROM aee_file WHERE aee01 = g_aag.aag01
                                   AND aee00 = g_aag.aag00  #No.FUN-730020
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","aee_file",g_aag.aag00,g_aag.aag01,SQLCA.sqlcode,"","",1)  #No.FUN-660123  #No.FUN-730020
        END IF
        DELETE FROM maj_file WHERE maj21 = g_aag.aag01 #no.3412
                                   AND maj22 = g_aag.aag01 #NO.3412
                                   AND maj01 IN (                      #No.FUN-730020
        SELECT mai01 FROM mai_file WHERE mai00= g_aag.aag00)  #No.FUN-730020  #No.FUN-730070
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","maj_file",g_aag.aag00,g_aag.aag01,SQLCA.sqlcode,"","",1)  #No.FUN-660123  #No.FUN-730020
        END IF
        ###No.FUN-A50010 STRAT ###
        #OPEN i102_count
        #FETCH i102_count INTO g_row_count
        #DISPLAY g_row_count TO FORMONLY.cnt
        #OPEN i102_cs
        #IF g_curs_index = g_row_count + 1 THEN
        #    LET g_jump = g_row_count
        #    CALL i102_fetch('L')
        #ELSE
        #    LET g_jump = g_curs_index
        #    LET g_no_ask = TRUE
        #    CALL i102_fetch('/')
        #END IF
        #CALL i102_list_fill()  #FUN-820031
        ###No.FUN-A50010 mark END ###
       #CHI-D10015--str
        LET g_msg=TIME
        INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
        VALUES ('agli102',g_user,g_today,g_msg,l_aag01,'delete',g_plant,g_legal)
       #CHI-D10015--end  
    END IF
    CLOSE i102_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i102_copy()
   DEFINE l_aag             RECORD LIKE aag_file.*,
          l_aaaacti         LIKE aaa_file.aaaacti,       #No.FUN-730020
          l_oldno,l_newno   LIKE aag_file.aag01,
          l_oldno1,l_newno1 LIKE aag_file.aag00   #No.FUN-730020
 
    IF s_aglshut(0) THEN RETURN END IF
    IF g_aag.aag01 IS NULL OR g_aag.aag00 IS NULL THEN  #No.FUN-730020
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE
    CALL i102_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno1,l_newno FROM aag00,aag01
        BEFORE INPUT
           #若來源科目為3.獨立帳戶,所屬統制科目(aag08)應DEFAULT=NULL,
           #待輸入科目編號後再自動帶入其值=科目編號.
           IF g_aag.aag07='3' THEN    #獨立帳戶
              LET g_aag.aag08=' '
              DISPLAY BY NAME g_aag.aag08
           END IF
 
        AFTER FIELD aag00
           IF NOT cl_null(l_newno1) THEN                                      
              SELECT aaaacti INTO l_aaaacti FROM aaa_file                          
               WHERE aaa01=l_newno1
              IF SQLCA.SQLCODE=100 THEN                                            
                 CALL cl_err3("sel","aaa_file",l_newno1,"",100,"","",1)            
                 NEXT FIELD aag00                                                 
              END IF                                                               
              IF l_aaaacti='N' THEN                                                
                 CALL cl_err(l_newno1,"9028",1)                                    
                 NEXT FIELD aag00                                                 
              END IF                                                               
           END IF
        AFTER FIELD aag01
           #若來源科目為3.獨立帳戶,所屬統制科目(aag08)應DEFAULT=NULL,
           #待輸入科目編號後再自動帶入其值=科目編號.
           IF g_aag.aag07='3' THEN    #獨立帳戶
              LET g_aag.aag08=l_newno
              DISPLAY BY NAME g_aag.aag08
           END IF
           CALL s_field_chk(l_newno,'6',g_plant,'aag01') RETURNING g_flag2                                                      
           IF g_flag2 = '0' THEN                                                                                                
              CALL cl_err(l_newno,'aoo-043',1)                                                                                  
              NEXT FIELD aag01                                                                                                  
           END IF
        #TQC-A50019--Add--Begin                                                                                                     
          IF i102_chk_aag01(l_newno) THEN                                                                                           
             NEXT FIELD aag01                                                                                                       
          END IF                                                                                                                    
        #TQC-A50019--Add--End
        AFTER INPUT      
           IF INT_FLAG THEN
              EXIT INPUT
           END IF
           IF l_newno IS NOT NULL AND l_newno1 IS NOT NULL THEN
              SELECT count(*) INTO g_cnt FROM aag_file
                  WHERE aag01 = l_newno
                    AND aag00 = l_newno1
              IF g_cnt > 0 THEN
                  CALL cl_err(l_newno,-239,0)
                  NEXT FIELD aag00
              END IF
           END IF
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(aag00)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               LET g_qryparam.default1 = l_newno1
               CALL cl_create_qry() RETURNING l_newno1
               DISPLAY l_newno1 TO aag00
               NEXT FIELD aag00  
            OTHERWISE
               EXIT CASE
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
        LET INT_FLAG = 0
        DISPLAY BY NAME g_aag.aag01
        DISPLAY BY NAME g_aag.aag00  #No.FUN-730020
        CALL cl_set_comp_entry("aag08,aag24,aag21,aag221,aag223,aag224,aag225,aag226,aag23",FALSE)          #TQC-A40075
        RETURN
    END IF
    LET l_aag.* = g_aag.*
    LET l_aag.aag01  = l_newno   #資料鍵值
    LET l_aag.aag00  = l_newno1  #No.FUN-730020
    LET l_aag.aagacti ='Y'                   #有效的資料
    LET l_aag.aaguser = g_user
    LET l_aag.aaggrup = g_grup               #使用者所屬群
    LET l_aag.aagdate = g_today
    LET l_aag.aag39 = g_plant                #NO.FUN-820031
    LET l_aag.aagoriu = g_user      #No.FUN-980030 10/01/04
    LET l_aag.aagorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO aag_file VALUES (l_aag.*)
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","aag_file",l_newno1,l_newno,SQLCA.sqlcode,"","",1)  #No.FUN-660123  #No.FUN-730020
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_aag.aag01
        LET l_oldno1= g_aag.aag00  #No.FUN-730020
        SELECT aag_file.* INTO g_aag.* FROM aag_file
                       WHERE aag01 = l_newno
                         AND aag00 = l_newno1  #No.FUN-730020
        CALL i102_u()
        #FUN-C30027---begin
        #SELECT aag_file.* INTO g_aag.* FROM aag_file
        #               WHERE aag01 = l_oldno
        #                 AND aag00 = l_oldno1  #No.FUN-730020
        #FUN-C30027---end
        #MOD-D50042--begin
        LET g_wc= "((",g_wc,") OR ("," aag00='",g_aag.aag00,"' AND aag01='",g_aag.aag01,"' )) "
        # LET g_wc= " aag00='",g_aag.aag00,"' AND aag01='",g_aag.aag01,"'  "
         LET g_wc_o = g_wc
         CALL i102_tree_update()
        #MOD-D50042--end
    END IF
    CALL i102_show()
END FUNCTION
 
FUNCTION i102_g()
    DEFINE  old LIKE aag_file.aag01, #欲從事batch_copy的新舊科目結帳編號
            new1,new2,new3,new4,new5    LIKE type_file.chr20,      #No.FUN-680098   VARCHAR(10)
            d1,d2 LIKE type_file.num5,                             #No.FUN-680098   SMALLINT 
            d3    LIKE aag_file.aag02,                             #No.FUN-680098   VARCHAR(30)
            y     LIKE type_file.chr1,                             #No.FUN-680098   VARCHAR(1)   
            i,j   LIKE type_file.num5,                             #No.FUN-680098   SMALLINT
            l_aag RECORD LIKE aag_file.*
 
    IF s_aglshut(0) THEN RETURN END IF
 
 
    OPEN WINDOW i102_w3 AT 6,11
         WITH FORM "agl/42f/agli102_2"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("agli102_2")
 
 
    CALL cl_getmsg('agl-021',g_lang) RETURNING g_msg
    DISPLAY g_msg AT 2,1
 
    CONSTRUCT g_wc ON aag01 FROM old
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
    IF INT_FLAG  THEN LET INT_FLAG = 0 CLOSE WINDOW i102_w3 RETURN END IF
    LET y = 'Y'
    INPUT BY NAME new1,new2,new3,new4,new5,d1,d2,d3,y WITHOUT DEFAULTS
       AFTER FIELD d2
          IF d1 > d2 THEN NEXT FIELD d1 END IF
       AFTER FIELD y
          IF y NOT MATCHES "[YN]" THEN NEXT FIELD y END IF
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
    IF INT_FLAG  THEN LET INT_FLAG = 0 CLOSE WINDOW i102_w3 RETURN END IF
    IF cl_sure(19,17) THEN
       CALL cl_wait()
       LET g_sql = 'SELECT * FROM aag_file WHERE ',g_wc CLIPPED
       PREPARE i102_p6 FROM g_sql
       DECLARE i102_c6 CURSOR FOR i102_p6
       FOREACH i102_c6 INTO l_aag.*
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,0)
             EXIT FOREACH
          END IF
          IF new1 IS NOT NULL THEN
             LET i = 1
             LET j = g_aaz.aaz21
             LET l_aag.aag01[i,j] = new1
             IF y = 'Y' THEN LET l_aag.aag08[i,j] = new1 END IF
          END IF
          IF new2 IS NOT NULL THEN
             LET i = g_aaz.aaz21+1
             LET j = g_aaz.aaz21+g_aaz.aaz22
             LET l_aag.aag01[i,j] = new2
             IF y = 'Y' THEN LET l_aag.aag08[i,j] = new2 END IF
          END IF
          IF new3 IS NOT NULL THEN
             LET i = g_aaz.aaz21+g_aaz.aaz22+1
             LET j = g_aaz.aaz21+g_aaz.aaz22+g_aaz.aaz23
             LET l_aag.aag01[i,j] = new3
             IF y = 'Y' THEN LET l_aag.aag08[i,j] = new3 END IF
          END IF
          IF new4 IS NOT NULL THEN
             LET i = g_aaz.aaz21+g_aaz.aaz22+g_aaz.aaz23+1
             LET j = g_aaz.aaz21+g_aaz.aaz22+g_aaz.aaz23+g_aaz.aaz24
             LET l_aag.aag01[i,j] = new4
             IF y = 'Y' THEN LET l_aag.aag08[i,j] = new4 END IF
          END IF
          IF new5 IS NOT NULL THEN
             LET i = g_aaz.aaz21+g_aaz.aaz22+g_aaz.aaz23+g_aaz.aaz24+1
             LET j = 24
             LET l_aag.aag01[i,j] = new5
             IF y = 'Y' THEN LET l_aag.aag08[i,j] = new5 END IF
          END IF
          IF d1 IS NOT NULL AND d2 IS NOT NULL AND d1 <= d2 AND d1 > 0 THEN
             LET l_aag.aag02[d1,d2] = 3
          END IF
          LET l_aag.aaguser = g_user LET l_aag.aaggrup = g_grup
          LET l_aag.aagacti = 'Y'    LET l_aag.aagmodu = ''
          LET l_aag.aagdate = g_today
          MESSAGE 'Copy act no : ',l_aag.aag01
          LET l_aag.aagoriu = g_user      #No.FUN-980030 10/01/04
          LET l_aag.aagorig = g_grup      #No.FUN-980030 10/01/04
          INSERT INTO aag_file VALUES (l_aag.*)
          IF SQLCA.sqlcode THEN
             LET g_msg = 'insert act-no:',l_aag.aag01
             CALL cl_err3("ins","aag_file",l_aag.aag01,"",SQLCA.sqlcode,"","insert act-no:",1)  #No.FUN-660123
          END IF
       END FOREACH
       ERROR ''
    END IF
    CLOSE WINDOW i102_w3
END FUNCTION
 
FUNCTION i102_extra()
   DEFINE only_one   LIKE type_file.chr1     #CHAR(1)
   DEFINE l_aag01    LIKE aag_file.aag01
   DEFINE l_aag00    LIKE aag_file.aag00     #No.FUN-730020
   DEFINE l_aag13    LIKE aag_file.aag13
   
   SELECT * INTO g_aag.* FROM aag_file WHERE aag01=g_aag.aag01 AND aag00=g_aag.aag00                                                                                                            
   IF NOT s_dc_ud_flag('6',g_aag.aag39,g_plant,'u') THEN                                                                            
       CALL cl_err(g_aag.aag39,'aoo-045',1)                                                                                         
       RETURN                                                                                                                       
    END IF                                                                                                                          
  
   OPEN WINDOW i102_w4 AT 6,11                                                                                                     
        WITH FORM "agl/42f/agli102_1"                                                                                              
         ATTRIBUTE (STYLE = g_win_style CLIPPED)                                                                                   
                                                                                                                                   
   CALL cl_ui_locale("agli102_1")                                                                                                  
   CALL cl_getmsg('agl-021',g_lang) RETURNING g_msg                                                                                
   DISPLAY g_msg AT 2,1  
 
   LET only_one = '1'
   CALL cl_set_head_visible("","YES")
 
   INPUT BY NAME only_one WITHOUT DEFAULTS
      AFTER FIELD only_one
         IF NOT cl_null(only_one) THEN
            IF only_one NOT MATCHES "[12]" THEN
               NEXT FIELD only_one
            END IF
            IF only_one = '1' AND (g_aag.aag01 IS NULL OR g_aag.aag01= ' ' 
                               OR  g_aag.aag00 IS NULL OR g_aag.aag00= ' ') THEN
               NEXT FIELD only_one
            END IF
         END IF
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
      CLOSE WINDOW i102_w4
      RETURN
   END IF
   IF only_one = '1' THEN
      LET g_wc = " aag01 = '",g_aag.aag01,"' AND aag00 = '",g_aag.aag00,"'"  #No.FUN-730020
   ELSE
      CALL cl_set_head_visible("","YES")     
 
      CONSTRUCT BY NAME g_wc ON aag00,aag01  #No.FUN-730020
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
            ON ACTION CONTROLP
              CASE
                 WHEN INFIELD(aag00)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_aaa"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO aag00
                    NEXT FIELD aag00  
                 WHEN INFIELD(aag01) #科目編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_aag03"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO aag01
                    NEXT FIELD aag01
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
       IF INT_FLAG THEN
          LET INT_FLAG=0
          CLOSE WINDOW i102_w4
          RETURN
       END IF
   END IF
    IF cl_null(g_wc) THEN LET g_wc = '1=1' END IF 
    LET g_sql = "SELECT aag00,aag01 FROM aag_file ",  #No.FUN-730020
                " WHERE ",g_wc                                                                                                     
    PREPARE i102_p2 FROM g_sql                                                                                                      
    DECLARE i102_c2 CURSOR FOR i102_p2                                                                                              
                                                                                                                                    
    FOREACH i102_c2 INTO l_aag00,l_aag01  #No.FUN-730020
       IF SQLCA.sqlcode THEN                                                                                                        
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)                                                                                    
         EXIT FOREACH                                                                                                               
       END IF                                                                                                                       
       CALL s_sjkm(l_aag00,l_aag01) RETURNING l_aag13  #No.FUN-730020
       UPDATE aag_file SET aag13 = l_aag13                                                                                          
        WHERE aag01 = l_aag01                                                                                                       
          AND aag00 = l_aag00  #No.FUN-730020
       IF SQLCA.SQLERRD[3] = 0 THEN                                                                                                 
          CALL cl_err3("upd","aag_file",g_aag.aag00,g_aag.aag01,SQLCA.sqlcode,"","",1)  #No.FUN-730020
       END IF                                                                                                                       
    END FOREACH                                                                                                                     
    CLOSE i102_c2                                                                                                                   
    CLOSE WINDOW i102_w4                                                                                                            
    SELECT aag13 INTO g_aag.aag13                                                                                                   
      FROM aag_file                                                                                                                 
     WHERE aag01=g_aag.aag01                                                                                                        
       AND aag00=g_aag.aag00  #No.FUN-730020
    DISPLAY BY NAME g_aag.aag13  
END FUNCTION
FUNCTION i102_download()
  DEFINE l_path       LIKE ze_file.ze03
  DEFINE l_i          LIKE type_file.num10
  DEFINE l_j          LIKE type_file.num10
    
    IF cl_null(g_aag.aag00) OR cl_null(g_aag.aag01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    CALL s_dc_download_path() RETURNING l_path
    FOR l_i = 1 TO g_aag_l.getLength()                                                                                               
       LET g_aagx[l_i].sel   = 'Y'                                                                                                  
       LET g_aagx[l_i].aag01 = g_aag_l[l_i].aag01
       LET g_aagx[l_i].aag00 = g_aag_l[l_i].aag00                                                                                 
    END FOR
    CALL i102_download_files(l_path)
 
END FUNCTION
 
FUNCTION i102_download_files(p_path)
  DEFINE p_path            LIKE ze_file.ze03
  DEFINE l_download_file   LIKE ze_file.ze03
  DEFINE l_upload_file     LIKE ze_file.ze03
  DEFINE l_status          LIKE type_file.num5
  DEFINE l_tempdir         LIKE type_file.chr50
  DEFINE l_n               LIKE type_file.num5
  DEFINE l_i               LIKE type_file.num5
 
   LET l_tempdir=FGL_GETENV("TEMPDIR")
   LET l_n=LENGTH(l_tempdir)
   IF l_n>0 THEN
      IF l_tempdir[l_n,l_n]='/' THEN
         LET l_tempdir[l_n,l_n]=' '
      END IF
   END IF
   LET l_n=LENGTH(p_path)
   IF l_n>0 THEN
      IF p_path[l_n,l_n]='/' THEN
         LET p_path[l_n,l_n]=' '
      END IF
   END IF
 
   LET l_upload_file = l_tempdir CLIPPED,'/agli102_aag_file_6.txt'
   LET l_download_file = p_path CLIPPED,"/agli102_aag_file_6.txt"
   
   IF g_wc IS NULL AND NOT cl_null(g_aag.aag00) AND NOT cl_null(g_aag.aag01) THEN
      LET g_wc = "aag00='",g_aag.aag00,"' AND aag01='",g_aag.aag01,"'"
   END IF
   IF g_wc IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_sql = "SELECT * FROM aag_file WHERE ",g_wc
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload',SQLCA.sqlcode,1)
   END IF
 
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
END FUNCTION
FUNCTION i102_out()
   DEFINE l_i             LIKE type_file.num5,        #No.FUN-680098 SMALLINT
          l_name          LIKE type_file.chr20,       # External(Disk) file name     #No.FUN-680098 VARCHAR(20)
          l_aag   RECORD  LIKE aag_file.*,
          l_chr           LIKE type_file.chr1         #No.FUN-680098   VARCHAR(1)
   DEFINE l_cmd         LIKE type_file.chr1000,       #No.FUN-680098  VARCHAR(200)
          p_cmd         LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
          l_prog        LIKE zz_file.zz01,            #No.FUN-680098  VARCHAR(10) 
          l_wc,l_wc2    LIKE type_file.chr1000,       #No.FUN-680098  VARCHAR(100)
          l_prtway      LIKE type_file.chr1           #No.FUN-680098  VARCHAR(1) 
 
   IF g_wc IS NULL THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF
 
   MENU ""
        ON ACTION rep1
                 LET l_prog='agli102'
                 EXIT MENU
        ON ACTION rep2
                 LET l_prog='gglr001'
                 EXIT MENU
       ON ACTION exit
          EXIT MENU
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE MENU
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE
            LET g_action_choice = "exit"
            EXIT MENU
 
   END MENU
 
IF l_prog='agli102' THEN  #No.TQC-5B0097
   CALL cl_wait()
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog #No.FUN-760085
   LET g_sql = "SELECT * FROM aag_file ",          # 組合出 SQL 指令
               " WHERE ",g_wc CLIPPED
 
   IF g_zz05 = 'Y' THEN                                                         
       CALL cl_wcchp(g_wc,'aag00,aag01,aag02,aag13,aag03,aag04,aag06,aag09,
                     aag221,aag223,aag224,aag225,aag226,aag19,       
                     aag07,aag08,aag24,aag05,aag21,aag23,aag42,aag43)      #No.FUN-A30077  #FUN-C90061 add aag43
#                    aag13,aag14,aaguser,aaggrup')
            RETURNING g_str                                                      
   END IF                                                                       
   CALL cl_prt_cs1('agli102','agli102',g_sql,g_str)    
ELSE
   CALL cl_getmsg('agl-955',g_lang) RETURNING g_msg
 
   PROMPT g_msg FOR g_bookno
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
 
      ON ACTION about
        CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
   END PROMPT
   IF cl_null(g_bookno) THEN
      LET g_bookno = g_aza.aza81
   END IF
   LET l_prog = 'gglr001'
   LET l_wc=g_wc CLIPPED
   SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file
    WHERE zz01 = l_prog
   IF SQLCA.sqlcode OR cl_null(l_wc2) THEN
      LET l_wc2 = ' "N" '
   END IF
   LET l_cmd = l_prog CLIPPED,
           ' "',g_bookno CLIPPED,'" "',g_today CLIPPED,'" ""', #No.TQC-7B0102
           ' "',g_lang CLIPPED,'" "Y" "',l_prtway,'" "1"',
           ' "',l_wc CLIPPED,'"',
           ' ',l_wc2 CLIPPED,''
   CALL cl_cmdrun(l_cmd)
END IF
 
END FUNCTION
 
 
#函數說明:
#若采用科目編碼規範，則判斷用戶輸入的科目編碼是否符合科目規範
#判斷函數，有返回值，0-正確，1-錯誤
FUNCTION i102_chk_aag01(p_aag01)
DEFINE   p_aag01           LIKE aag_file.aag01
DEFINE   l_aaz107          LIKE aaz_file.aaz107
DEFINE   l_aaz108          LIKE aaz_file.aaz108 
DEFINE   l_aag01_length    LIKE type_file.num5   #編碼長度
DEFINE   l_length          LIKE type_file.num5   #其他段編碼長度
DEFINE   l_ret             LIKE type_file.chr1   #接收預設函數返回值
 
    #初始化各變量
     LET l_aaz107 = NULL
     LET l_aaz108 = NULL 
     LET l_aag01_length = 0
     LET l_length = 0    
     LET l_ret    = NULL 
       
     IF cl_null(p_aag01) THEN RETURN 0 END IF   #科目編號為空則返回0
 
    #找出科目編碼規範
     SELECT aaz107,aaz108 INTO l_aaz107,l_aaz108 FROM aaz_file WHERE aaz00 = '0'
     IF cl_null(l_aaz107) OR cl_null(l_aaz108) THEN  #沒有值，表示不采用編碼規範
        CALL cl_err('system message:','agl-241',0)
        RETURN 0       
     END IF 
     
     CALL LENGTH(p_aag01) RETURNING l_aag01_length
 
    #編碼長度小于首段長度
     IF l_aag01_length < l_aaz107 THEN 
        CALL cl_err(p_aag01,'agl-240',1) 
        RETURN 1
     END IF 
    
    #編碼長度大于首段長度
     IF l_aag01_length > l_aaz107 THEN 
        LET l_length = l_aag01_length - l_aaz107
        IF (l_length mod l_aaz108) <> 0 THEN 
           CALL cl_err(p_aag01,'agl-240',1)
           RETURN 1
        END IF 
     END IF 
 
    #若編碼符合規範，則調用預設函數i102_def()
     CALL i102_def(p_aag01,l_aaz107,l_aaz108,l_aag01_length) RETURNING l_ret
     IF l_ret <> 'Y' THEN 
       RETURN 1 
     END IF 
     
     RETURN 0
 
END FUNCTION 
 
#函數說明：
#根據科目編碼，預設統制明細別aag07，所屬統制科目aag08 和科目層級aag24
#功能函數，無返回值
FUNCTION i102_def(p_aag01,p_aaz107,p_aaz108,p_length)
DEFINE   p_aag01          LIKE aag_file.aag01
DEFINE   p_aaz107         LIKE aaz_file.aaz107      #首段編碼長度定義值
DEFINE   p_aaz108         LIKE aaz_file.aaz108      #其他段編碼長度定義值
DEFINE   p_length         LIKE type_file.num5       #當前科目編碼總長度
DEFINE   l_length         LIKE type_file.num5       
DEFINE   l_success        LIKE type_file.chr1    
DEFINE   l_i              LIKE type_file.num5    
DEFINE   l_buff           STRING 
DEFINE   l_aag01          LIKE aag_file.aag01
DEFINE   l_count          LIKE type_file.num5
 
    #初始化各變量
     LET l_success = 'Y'
     LET l_aag01 = NULL 
     LET l_count = 0
     
   #若科目編碼字段長度等于首段編碼定義長度，則預設為統制科目
    IF p_length = p_aaz107 THEN 
      #LET g_aag.aag07 = '1'        #MOD-D50041 mark
       LET g_aag.aag08 = p_aag01
       LET g_aag.aag24 = 1
       
       DISPLAY BY NAME g_aag.aag07,g_aag.aag08,g_aag.aag24
       RETURN l_success
    END IF 
   
   #若科目編碼字段長度大于首段編碼定義長度
    IF p_length > p_aaz107 THEN 
       LET l_length = p_length - p_aaz107    
       LET l_i = l_length / p_aaz108  
       LET l_buff  = p_aag01 
       LET l_aag01 = l_buff.substring(1,p_length-p_aaz108)
 
      #先確定帳套是否已經存在
      IF cl_null(g_aag.aag00) THEN 
         CALL cl_err('','anm-062',0)
         LET l_success = 'N' 
         RETURN l_success 
      END IF 
 
      #確定是否存在該科目上級統制科目
       SELECT COUNT(aag01) INTO l_count FROM aag_file 
        WHERE aag01 = l_aag01 AND aag24 = l_i
          AND aag00 = g_aag.aag00
       IF SQLCA.sqlcode THEN 
          CALL cl_err(p_aag01,SQLCA.sqlcode,1)
          LET l_success = 'N'
          RETURN l_success
       END IF            
       
       IF l_count = 0 THEN    
       	  #No.TQC-D70091  --Begin
          IF p_length <> p_aaz107 THEN     
             CALL cl_err(p_aag01,'agl-242',1)  
             LET l_success = 'N'
             RETURN l_success
            #IF cl_confirm('agl-243') THEN          
            #   LET g_aag.aag07 = '3'
            #   LET g_aag.aag08 = p_aag01
#           #   LET g_aag.aag24 = 99     #No.FUN-A40020               No.FUN-A60024 mark
            #   LET g_aag.aag24 = 1      #No.FUN-A40020               No.FUN-A60024 free
            #   
            #   DISPLAY BY NAME g_aag.aag07,g_aag.aag08,g_aag.aag24 
            #   RETURN l_success 
            #ELSE
            #   CALL cl_err(p_aag01,'agl-242',1)
            #   LET l_success = 'N'
            #   RETURN l_success
            #END IF  
          END IF
          #No.TQC-D70091  --End
       ELSE
          LET g_aag.aag07 = '2'
          LET g_aag.aag08 = l_aag01
          LET g_aag.aag24 = 99
          
          DISPLAY BY NAME g_aag.aag07,g_aag.aag08,g_aag.aag24
          RETURN l_success
       END IF 
    END IF 
     
    RETURN l_success 
 
END FUNCTION 
      
#函數說明：判斷編碼規範原則下，對上級統制科目設置是否正確。 
#判斷函數，有返回值，0-正確，1-錯誤
FUNCTION i102_chk(p_aag01,p_aag08)
DEFINE   p_aag01          LIKE aag_file.aag01
DEFINE   p_aag08          LIKE aag_file.aag08
DEFINE   l_aaz107         LIKE aaz_file.aaz107
DEFINE   l_aaz108         LIKE aaz_file.aaz108
DEFINE   l_buff1          STRING       
DEFINE   l_buff2          STRING     
DEFINE   l_length1        LIKE type_file.num5
DEFINE   l_length2        LIKE type_file.num5
DEFINE   l_length         STRING   #MOD-9C0350 add

    #例：科目        科目層級 
    #例：9999           1    -->科目編碼長度需等於aaz107
    #    999901         2    -->科目編碼長度需等於上層統制科目長度+aaz108
    #    99990101       3    -->同上
    #    9999010101     4    -->同上
    #    999901010101   5    -->同上
    #    ....

   #初始化各變量
    LET l_aaz107 = NULL
    LET l_aaz108 = NULL 
    LET l_buff1  = NULL
    LET l_buff2  = NULL 
 
    #aaz107:科目編號首段碼長 , aaz108:科目編號其它段碼長
    SELECT aaz107,aaz108 INTO l_aaz107,l_aaz108 FROM aaz_file
     WHERE aaz00 = '0'
 
    CALL LENGTH(p_aag01) RETURNING l_length1
    CALL LENGTH(p_aag08) RETURNING l_length2

   #上級統制科目的編碼長度是否正確
    IF g_aag.aag07 = '3' OR (g_aag.aag07 = '1' AND g_aag.aag24 = 1) THEN 
       LET l_buff1 = p_aag01 CLIPPED
       LET l_buff2 = p_aag08 CLIPPED
       #No.TQC-D70091  --Begin
       IF l_buff1 <> l_buff2 THEN
          CALL cl_err(p_aag01,'agl-241',1)             
          RETURN 1
       END IF
       IF LENGTH(p_aag01) <> l_aaz107 THEN
          CALL cl_err(p_aag01,'agl-241',1)             
          RETURN 1
       END IF
       #No.TQC-D70091  --End
    ELSE
       IF (l_length1 - l_aaz108 <> l_length2) THEN
          IF l_length2 > l_aaz107 THEN   #統制科目長度>科目編號首段碼長 
             LET l_length = (l_length1-l_aaz108) USING '###&'
             CALL cl_err_msg(NULL,"agl-254",l_length CLIPPED,1)
             RETURN 1
          ELSE
             CALL cl_err(p_aag01,'agl-244',1)   #MOD-9C0350 mod p_aag08->p_aag01
             RETURN 1
          END IF 
         #end MOD-9C0350 mod
       END IF 
       
       LET l_buff1 = p_aag01 CLIPPED
       LET l_buff1 = l_buff1.substring(1,l_length1-l_aaz108)
       LET l_buff2 = p_aag08 CLIPPED
    END IF
 
    IF NOT (l_buff1.equals(l_buff2)) THEN 
       CALL cl_err(p_aag08,'agl-245',1)
       RETURN 1
    END IF 
  
    RETURN 0  
END FUNCTION 
#No.FUN-9C0072 精簡程式碼
#No.FUN-A10088 --begin
FUNCTION i102_aag41(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_nmlacti  LIKE nml_file.nmlacti

   LET g_errno = ' '
   SELECT nmlacti INTO l_nmlacti
     FROM nml_file WHERE nml01 = g_aag.aag41
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-140'
        WHEN l_nmlacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
#No.FUN-A10088 --end
#No.MOD-A10143 --begin
FUNCTION i102_chk_x()
    DEFINE g_bookno1    LIKE aza_file.aza81    #No.TQC-B50084
    DEFINE g_bookno2    LIKE aza_file.aza82    #No.TQC-B50084
    DEFINE g_flag       LIKE type_file.chr1    #No.TQC-B50084
    
    #No.TQC-B50084  --Begin
    CALL s_get_bookno1(NULL,g_plant) RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag = '0' THEN       
       IF g_aag.aag00 = g_bookno1 THEN
          LET g_cnt = 0
          SELECT COUNT(npp01) INTO g_cnt FROM npp_file,npq_file
            WHERE npp00 = npq00
              AND npp01 = npq01
              AND npp011 = npq011
              AND nppsys = npqsys
              AND npptype = npqtype
              AND npq03 = g_aag.aag01
              AND nppglno IS NULL
              AND npqtype = '0'   
          IF g_cnt > 0 THEN
             LET g_success = 'N'
             CALL cl_err(g_aag.aag01,'agl-973',1)
             RETURN
          END IF
          SELECT COUNT(aba01) INTO g_cnt FROM aba_file,abb_file
            WHERE aba01 = abb01
              AND aba00 = g_aag.aag00
              AND abb03 = g_aag.aag01
              AND aba20 = '0'
              AND aba00=g_bookno1         #No.TQC-B50067
              AND (aba19 ='N' OR (aba19 = 'Y' AND abapost = 'N'))   
              AND abaacti = 'Y'           #MOD-B80030
          IF g_cnt > 0 THEN
             LET g_success = 'N'
             CALL cl_err(g_aag.aag01,'agl-973',1) 
             RETURN
          END IF      
       ELSE 
          IF g_aag.aag00 = g_bookno2 THEN
      	     LET g_cnt = 0
             SELECT COUNT(npp01) INTO g_cnt FROM npp_file,npq_file
               WHERE npp00 = npq00
                 AND npp01 = npq01
                 AND npp011 = npq011
                 AND nppsys = npqsys
                 AND npptype = npqtype
                 AND npq03 = g_aag.aag01
                 AND nppglno IS NULL
                 AND npqtype = '1'
             IF g_cnt > 0 THEN
                LET g_success = 'N'
                CALL cl_err(g_aag.aag01,'agl-973',1) 
                RETURN
             END IF
             SELECT COUNT(aba01) INTO g_cnt FROM aba_file,abb_file
               WHERE aba01 = abb01
                 AND aba00 = g_aag.aag00
                 AND abb03 = g_aag.aag01
                 AND aba20 = '0'
                 AND aba00=g_bookno2         #No.TQC-B50067
                 AND (aba19 ='N' OR (aba19 = 'Y' AND abapost = 'N'))   
                 AND abaacti = 'Y'           #MOD-B80030
             IF g_cnt > 0 THEN
                LET g_success = 'N'
                CALL cl_err(g_aag.aag01,'agl-973',1)
                RETURN
             END IF  
         END IF             
      END IF     
    ELSE  
      CALL cl_err(g_plant,'aoo-081',1) #抓不到帳別
    END IF	  
    #LET g_cnt = 0
    #SELECT COUNT(npp01) INTO g_cnt FROM npp_file,npq_file
    #  WHERE npp00 = npq00
    #    AND npp01 = npq01
    #    AND npp011 = npq011
    #    AND nppsys = npqsys
    #    AND npptype = npqtype
    #    AND npq03 = g_aag.aag01
    #    AND nppglno IS NULL
    #    AND npqtype = '0'
    #IF g_cnt > 0 THEN
    #   LET g_success = 'N'
    #   CALL cl_err(g_aag.aag01,'agl-973',1)
    #   RETURN
    #END IF 

    #LET g_cnt = 0
    #SELECT COUNT(aba01) INTO g_cnt FROM aba_file,abb_file
    #  WHERE aba01 = abb01
    #    AND aba00 = g_aag.aag00
    #    AND abb03 = g_aag.aag01
    #    AND aba20 = '0'
    #    AND aba19 ='N'
    #IF g_cnt > 0 THEN
    #   LET g_success ='N'
    #   CALL cl_err(g_aag.aag01,'agl-973',1)
    #   RETURN
    #END IF
    #No.TQC-B50084  --End  
END FUNCTION
#No.MOD-A10143 --end 
#No.FUN-A50010 --begin
##################################################
# Descriptions...: 依tree path指定focus節點
# Date & Author..: 09/10/14 By suncx1
# Input Parameter:
# Return code....:
##################################################
FUNCTION i102_tree_idxbypath()
   DEFINE l_i       LIKE type_file.num5
   LET g_tree_focus_idx = 1
   FOR l_i = 1 TO g_tree.getlength()
      IF g_tree[l_i].path = g_tree_focus_path THEN
            LET g_tree_focus_idx = l_i 
            EXIT FOR
      END IF
   END FOR
END FUNCTION
#No.FUN-A50010 --end 
#No.FUN-A50010 --begin
##################################################
# Descriptions...: 依key指定focus節點
##################################################
FUNCTION i102_tree_idxbykey()
   DEFINE l_idx   INTEGER
   LET g_tree_focus_idx = 1
   FOR l_idx = 1 TO g_tree.getLength()

      IF g_tree[l_idx].treekey1 == g_aag.aag01 AND g_tree[l_idx].treekey2 == g_aag.aag00 THEN 
         LET g_tree[l_idx].expanded = TRUE
         LET g_tree_focus_idx = l_idx 
      END IF
   END FOR
END FUNCTION
#No.FUN-A50010 --end 

FUNCTION i102_tree_fill1(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路弿   
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING

   DEFINE l_aag            DYNAMIC ARRAY OF RECORD
             aag00          LIKE aag_file.aag00
             END RECORD
   
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴嚿
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_child            LIKE type_file.num5 
   DEFINE l_prog_name        STRING
   DEFINE l_index            LIKE type_file.num5
   DEFINE l_idx              LIKE type_file.num5
   DEFINE l_child_pid        STRING

   LET max_level = 20 #設定最大階層數為20
   LET g_sql = "SELECT DISTINCT aag00",
                  "  FROM aag_file ",
                  "   WHERE ",g_wc,
                  "  ORDER BY aag00 "    						               
   PREPARE i102_tree_pre3 FROM g_sql
   DECLARE i102_tree_cs3 CURSOR FOR i102_tree_pre3  

   LET l_i = 1
   CALL g_tree.clear()
   LET p_level = 1
   LET g_idx = 0   
   FOREACH i102_tree_cs3 INTO l_aag[l_i].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF 
      LET g_idx = g_idx + 1
      LET g_tree[g_idx].pid = NULL
      LET g_tree[g_idx].id = g_idx 
      LET g_tree[g_idx].expanded = TRUE #TRUE:展開, FALSE:不展開
      LET g_tree[g_idx].name = get_field_name("aag00"),":",l_aag[l_i].aag00
      LET g_tree[g_idx].level = p_level
      LET g_tree[g_idx].path = l_aag[l_i].aag00
      LET g_tree[g_idx].treekey1 = l_aag[l_i].aag00
      LET g_tree[g_idx].has_children = TRUE
      CALL i102_tree_fill(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path, 
                                g_tree[g_idx].treekey1,NULL)
         
      LET l_i = l_i + 1
   END FOREACH            
   
END FUNCTION
#No.FUN-A50010 --begin
##################################################
# Descriptions...: Tree填充
# Date & Author..: 09/10/14 By suncx1
# Input Parameter: p_wc,p_pid,p_level,p_key1,p_key2
# Return code....:
##################################################
FUNCTION i102_tree_fill(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc STRING #查詢條件 
   DEFINE p_pid STRING #父節點id 
   DEFINE p_level LIKE type_file.num5 #階層 
   DEFINE p_path STRING #節點路徑
   DEFINE p_key1,p_key2 STRING
   DEFINE l_aag00 LIKE aag_file.aag00
   DEFINE l_aag DYNAMIC ARRAY OF RECORD
                aag00   LIKE aag_file.aag00,
                aag01   LIKE aag_file.aag01,
                aag02   LIKE aag_file.aag02,
                aag07   LIKE aag_file.aag07,  
                aag08   LIKE aag_file.aag08,
                aag24   LIKE aag_file.aag24,
                aagacti LIKE aag_file.aagacti
                END RECORD 
   DEFINE l_child_cnt LIKE type_file.num5 #子節點數
   
   DEFINE l_str STRING
   DEFINE l_sql STRING
   DEFINE max_level LIKE type_file.num5
   DEFINE l_i       LIKE type_file.num5
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_index   LIKE type_file.num5
   DEFINE l_str1    STRING #MOD-DB0144 add
   DEFINE l_aag01   LIKE aag_file.aag01 #TQC-DB0087 add
   DEFINE l_count   LIKE type_file.num5 #TQC-DB0087 add
   
   #No.TQC-A60039 --begin
   LET l_sql = "SELECT aag08 FROM aag_file WHERE aag08 NOT IN (",
               " SELECT UNIQUE aag08 FROM aag_file", 
               " WHERE aag24 IS NOT NULL AND aag08 IS NOT NULL", 
               " AND aag01 = aag08",
               " AND aag00 = '",p_key1,"'", #帳別 #TQC-DB0087 add
               " AND aag07 != '2' AND ",g_wc,")",
               " AND aag24 != 1", 
               " AND aag01 != aag08",  
               " AND aag00  = '",p_key1,"'", #帳別 #TQC-DB0087 add
               " AND ",g_wc
   #TQC-DB0087--add--str--
   LET l_str="  FROM aag_file ",
             " WHERE aag24 IS NOT NULL ",    #層級不可為空
             "    AND aag08 IS NOT NULL ",   #所屬統治科目不可為空
             "    AND aag01 != aag08 ",      #科目編號與所屬統製科目不相同者
             "    AND aag07 != '2' ",        #明細科目不單獨單印
             "    AND aag00 = '",p_key1,"'", #帳別
             "    AND aag01 IN (",l_sql,")",
             "    AND aag08 NOT IN (",
             "        SELECT UNIQUE aag01",
             "          FROM aag_file ",
             "         WHERE aag24 IS NOT NULL ",   #層級不可為空
             "           AND aag08 IS NOT NULL ",   #所屬統治科目不可為空
             "           AND aag01 = aag08 ",       #科目編號與所屬統製科目相同者
             "           AND aag07 != '2' ",        #明細科目不單獨單印
             "           AND aag00 = '",p_key1,"'",   #帳別
             "           AND ",g_wc,
             "         UNION ",
             "        SELECT UNIQUE aag01",
             "          FROM aag_file ",
             "         WHERE aag24 IS NOT NULL ",   #層級不可為空
             "           AND aag08 IS NOT NULL ",   #所屬統治科目不可為空
             "           AND aag01 = aag08 ",       #科目編號與所屬統製科目相同者
             "           AND aag07 != '2' ",        #明細科目不單獨單印
             "           AND aag00 = '",p_key1,"'", #帳別
             "           AND aag08 IN (",l_sql,")",
             "                     )"
   LET g_sql="SELECT COUNT(*) ",l_str
   LET l_count=0
   PREPARE i102_cnt_pr FROM g_sql
   EXECUTE i102_cnt_pr INTO l_count
   #TQC-DB0087--add--str--end
   LET g_sql = "SELECT UNIQUE aag00,aag01,aag02,aag07,aag08,aag24,aagacti",
               "  FROM aag_file ",
               " WHERE aag24 IS NOT NULL ",    #層級不可為空
               "    AND aag08 IS NOT NULL ",   #所屬統治科目不可為空
               "    AND aag01 = aag08 ",       #科目編號與所屬統製科目相同者
               "    AND aag07 != '2' ",        #明細科目不單獨單印
               "    AND aag00 = '",p_key1,"'",   #帳別
               "   AND ",g_wc,
               " UNION ",
               "SELECT UNIQUE aag00,aag01,aag02,aag07,aag08,aag24,aagacti", 
               "  FROM aag_file ",
               " WHERE aag24 IS NOT NULL ",    #層級不可為空
               "    AND aag08 IS NOT NULL ",   #所屬統治科目不可為空
               "    AND aag01 = aag08 ",       #科目編號與所屬統製科目相同者
               "    AND aag07 != '2' ",        #明細科目不單獨單印
               "    AND aag00 = '",p_key1,"'",   #帳別
               "    AND aag08 IN (",l_sql,")"
   #TQC-DB0087--add--str--
   IF g_wc<>'1=1' AND l_count>0 THEN
      LET g_sql=g_sql,
                " UNION ",
                "SELECT UNIQUE aag00,aag01,aag02,aag07,aag08,aag24,aagacti"
                ,l_str
   END IF
   LET g_sql=g_sql,
   #TQC-DB0087--add--end
               "  ORDER BY aag00,aag01,aag08" 
   #No.TQC-A60039 --END
   
   PREPARE i102_tree_pre1 FROM g_sql
   DECLARE i102_tree_cs1 CURSOR FOR i102_tree_pre1
   
   LET l_str1=''  #TQC-DB0087--add
   LET l_index = 0
   FOREACH i102_tree_cs1 INTO l_aag[l_index+1].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #TQC-DB0087--add--str--
      IF l_aag[l_index+1].aag07='1' AND l_count>0 THEN
         IF l_aag[l_index+1].aag24='1' 
            OR l_aag[l_index+1].aag01=l_aag[l_index+1].aag08 THEN
            IF cl_null(l_str1) THEN
               LET l_str1="'",l_aag[l_index+1].aag01,"'"
            ELSE
               LET l_str1=l_str1,",'",l_aag[l_index+1].aag01,"'"
            END IF
         ELSE
            #抓取最上層科目,切判斷最上層科目是否已存在于l_aag數組中,如果存在,則移除,如果不存在將這筆記錄改成最上層相關資料
            CALL i102_first(p_key1,l_aag[l_index+1].aag01) RETURNING l_aag01
            IF NOT cl_null(l_str1) THEN
               LET g_sql="SELECT COUNT(*) FROM aag_file ",
                         " WHERE aag00='",p_key1,"'", 
                         "   AND aag01='",l_aag01,"'",
                         "   AND aag01 IN (",l_str1,")"
               PREPARE sel_cnt_pr FROM g_sql
               EXECUTE sel_cnt_pr INTO l_cnt
               IF l_cnt>0 THEN
                  CALL l_aag.deleteElement(l_index+1)
                  CONTINUE FOREACH
               ELSE
                  LET l_str1=l_str1,",'",l_aag01,"'"
               END IF
            ELSE
               LET l_str1=l_str1,",'",l_aag01,"'"
            END IF
         END IF
      END IF
      #TQC-DB0087--add--end
      LET l_index = l_index + 1
   END FOREACH
   #TQC-DB0087--mark--str--
   ##MOD-DB0144--add--str--
   ##抓取上層不為最頂層科目
   #LET g_sql="SELECT UNIQUE aag00,aag01,aag02,aag07,aag08,aag24,aagacti",
   #          "  FROM aag_file ",
   #          " WHERE aag24 IS NOT NULL ",    #層級不可為空
   #          "    AND aag08 IS NOT NULL ",   #所屬統治科目不可為空
   #          "    AND aag01 != aag08 ",      #科目編號與所屬統製科目不相同者
   #          "    AND aag07 != '2' ",        #明細科目不單獨單印
   #          "    AND aag00 = '",p_key1,"'", #帳別
   #          "    AND aag01 IN (",l_sql,")",
   #          "    AND aag08 NOT IN (",
   #          "        SELECT UNIQUE aag01",
   #          "          FROM aag_file ",
   #          "         WHERE aag24 IS NOT NULL ",   #層級不可為空
   #          "           AND aag08 IS NOT NULL ",   #所屬統治科目不可為空
   #          "           AND aag01 = aag08 ",       #科目編號與所屬統製科目相同者
   #          "           AND aag07 != '2' ",        #明細科目不單獨單印
   #          "           AND aag00 = '",p_key1,"'",   #帳別
   #          "           AND ",g_wc,
   #          "         UNION ",
   #          "        SELECT UNIQUE aag01",
   #          "          FROM aag_file ",
   #          "         WHERE aag24 IS NOT NULL ",   #層級不可為空
   #          "           AND aag08 IS NOT NULL ",   #所屬統治科目不可為空
   #          "           AND aag01 = aag08 ",       #科目編號與所屬統製科目相同者
   #          "           AND aag07 != '2' ",        #明細科目不單獨單印
   #          "           AND aag00 = '",p_key1,"'", #帳別
   #          "           AND aag08 IN (",l_sql,")",
   #          "                     )",
   #          "  ORDER BY aag00,aag01,aag08" 
   #PREPARE i102_tree_pre4 FROM g_sql
   #DECLARE i102_tree_cs4 CURSOR FOR i102_tree_pre4
   #FOREACH i102_tree_cs4 INTO l_aag[l_index+1].*
   #   IF SQLCA.sqlcode THEN
   #      CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
   #      EXIT FOREACH
   #   END IF
   #   LET l_index = l_index + 1
   #END FOREACH
   ##MOD-DB0144--add--end
   #TQC-DB0087--mark--end
   
   FOR l_i=1 TO l_index
      #MOD-DB0144--add--str--
      IF l_aag[l_i].aag07='1' AND l_aag[l_i].aag01!=l_aag[l_i].aag08 THEN
         CALL i102_tree_fill3(p_pid,p_level,p_path,p_key1,l_aag[l_i].aag08)
         LET l_str=NULL
         LET l_str1=NULL
         CALL i102_tree_pid(p_key1,l_aag[l_i].aag08) RETURNING l_str,l_str1
         LET g_idx = g_idx + 1 
         LET g_tree[g_idx].pid = p_pid,l_str
         LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_aag[l_i].aag24
         LET g_tree[g_idx].path = p_path,l_str1,".",l_aag[l_i].aag01
      ELSE
      #MOD-DB0144--add--end
         LET g_idx = g_idx + 1 
         LET g_tree[g_idx].pid = p_pid CLIPPED
         LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_i
         LET g_tree[g_idx].path = p_path ,".",l_aag[l_i].aag01  #MOD-DB0144 add
      END IF  #MOD-DB0144 add
      LET g_tree[g_idx].expanded = FALSE #TRUE:展開, FALSE:不展開
      #LET g_tree[g_idx].name = get_field_name("aag01"),":",l_aag[l_i].aag01," ", #TQC-A60134  mark
      #                         get_field_name("aag02"),":",l_aag[l_i].aag02      #TQC-A60134  mark
      LET g_tree[g_idx].name = l_aag[l_i].aag01 CLIPPED," ",  #TQC-A60134  
                               l_aag[l_i].aag02      #TQC-A60134
      LET g_tree[g_idx].level = p_level
      #LET g_tree[g_idx].path = p_path ,".",l_aag[l_i].aag01  #MOD-DB0144 mark 
      IF l_aag[l_i].aag00 = g_aag.aag00 AND l_aag[l_i].aag01 = g_aag.aag01 THEN  #MOD-D10070
         LET g_tree_focus_path = g_tree[g_idx].path                              #MOD-D10070
      END IF                                                                     #MOD-D10070
      LET g_tree[g_idx].treekey1 = l_aag[l_i].aag01
      LET g_tree[g_idx].treekey2 = l_aag[l_i].aag00
      CALL i102_tree_fill2(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path, 
                             g_tree[g_idx].treekey1,g_tree[g_idx].treekey2)
   END FOR
   
END FUNCTION

FUNCTION i102_tree_fill2(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc STRING #查詢條件 
   DEFINE p_pid STRING #父節點id 
   DEFINE p_level LIKE type_file.num5 #階層 
   DEFINE p_path STRING #節點路徑
   DEFINE p_key1,p_key2 STRING
   DEFINE l_aag DYNAMIC ARRAY OF RECORD
                aag00   LIKE aag_file.aag00,
                aag01   LIKE aag_file.aag01,
                aag02   LIKE aag_file.aag02,
                aag07   LIKE aag_file.aag07,  
                aag08   LIKE aag_file.aag08,
                aag24   LIKE aag_file.aag24,
                aagacti LIKE aag_file.aagacti
                END RECORD 
   DEFINE l_i       LIKE type_file.num5
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_count   LIKE type_file.num5
   
   LET g_sql="SELECT unique aag00,aag01,aag02,aag07,aag08,aag24,aagacti ",
             "  FROM aag_file",
             " WHERE aag08  = '",p_key1,"' ",    #所屬統製科目代號
             "   AND aag24 != 1 ",              #科目層級
             "   AND aag01 != aag08 ", 
             "   AND aag00 = '",p_key2,"' ",   #帳別
             "   AND ",g_wc,
             " ORDER BY aag00,aag01,aag08 " 
   PREPARE i102_tree_pre2 FROM g_sql
   DECLARE i102_tree_cs2 CURSOR FOR i102_tree_pre2
   LET l_cnt = 0
   CALL l_aag.clear()
   FOREACH i102_tree_cs2 INTO l_aag[l_cnt+1].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH 
   IF l_cnt >0 THEN
     FOR l_i=1 TO l_cnt
         LET g_idx = g_idx + 1 
         LET g_tree[g_idx].pid = p_pid CLIPPED
         LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_i
         LET g_tree[g_idx].expanded = FALSE    #TRUE:展開, FALSE:不展開
         #LET g_tree[g_idx].name = get_field_name("aag01"),":",l_aag[l_i].aag01," ",      #TQC-A60134  mark
         #                         get_field_name("aag02"),":",l_aag[l_i].aag02           #TQC-A60134  mark
         LET g_tree[g_idx].name = l_aag[l_i].aag01 CLIPPED," ",  #TQC-A60134  
                                  l_aag[l_i].aag02      #TQC-A60134
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = p_path,".",l_aag[l_i].aag01
         LET g_tree[g_idx].treekey1 = l_aag[l_i].aag01
         LET g_tree[g_idx].treekey2 = l_aag[l_i].aag00
         SELECT COUNT(aag01) INTO l_count FROM aag_file 
         WHERE aag08 = l_aag[l_i].aag01
         AND aag00 = l_aag[l_i].aag00 
         AND aag24 != 1 
         AND aag01 != aag08
         IF l_count > 0 THEN
            LET g_tree[g_idx].has_children = TRUE
            CALL i102_tree_fill2(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,
                                 l_aag[l_i].aag01,l_aag[l_i].aag00)
         ELSE
            LET g_tree[g_idx].has_children = FALSE
         END IF 
     END FOR
   END IF
END FUNCTION
#No.FUN-A50010 --end 
#No.FUN-A50010 --begin
##################################################
# Descriptions...: 異動Tree資料
# Date & Author..: 09/12/22 By suncx1
# Input Parameter: 
# Return code....: 
##################################################
FUNCTION i102_tree_update()
   #Tree重查並展開focus節點
   CALL i102_tree_fill1(g_wc_o,NULL,0,NULL,NULL,NULL) #Tree填充
   CALL i102_tree_idxbypath()                        #依tree path指定focus節點
   CALL i102_tree_open(g_tree_focus_idx)             #展開節點
   #復原cursor，上下筆的按鈕才可以使用
   IF g_tree[g_tree_focus_idx].level = 1 THEN
      LET g_tree_b = "N"
   ELSE
      LET g_tree_b = "Y"
   END IF
   CALL i102_q(g_tree_focus_idx)
END FUNCTION
#No.FUN-A50010 --end 

##################################################
# Descriptions...: 展開節點
# Date & Author..: 10/55/05 By suncx1
# Input Parameter: p_idx
# Return code....:
##################################################
FUNCTION i102_tree_open(p_idx)
   DEFINE p_idx        LIKE type_file.num10  #index
   DEFINE l_pid        STRING                #父節id
   DEFINE l_openpidx   LIKE type_file.num10  #展開父index
   DEFINE l_arrlen     LIKE type_file.num5   #array length
   DEFINE l_i          LIKE type_file.num5

   LET l_openpidx = 0
   LET l_arrlen = g_tree.getLength()

   IF p_idx > 0 THEN
      IF g_tree[p_idx].has_children THEN
         LET g_tree[p_idx].expanded = TRUE   #TRUE:展開, FALSE:不展開
      END IF
      LET l_pid = g_tree[p_idx].pid
      IF p_idx > 1 THEN
         #找父節點的index
         FOR l_i=p_idx TO 1 STEP -1
            IF g_tree[l_i].id = l_pid THEN
               LET l_openpidx = l_i
               EXIT FOR
            END IF
         END FOR
         #展開父節點
         IF (l_openpidx > 0) AND (NOT cl_null(g_tree[p_idx].path)) THEN
            CALL i102_tree_open(l_openpidx)
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION get_field_name(p_field_code)
   DEFINE p_field_code STRING
   DEFINE l_sql        STRING,
          l_gaq03      LIKE gaq_file.gaq03

   LET l_sql = "SELECT gaq03 FROM gaq_file",
               " WHERE gaq01='",p_field_code,"' AND gaq02='",g_lang,"'"
   DECLARE gaq_curs SCROLL CURSOR FROM l_sql
   OPEN gaq_curs
   FETCH FIRST gaq_curs INTO l_gaq03
   CLOSE gaq_curs

   RETURN l_gaq03 CLIPPED
END FUNCTION

#No:FUN-A50010
##################################################
# Descriptions...: 獲取正確的g_jump和g_curs_index
# Date & Author..: 10/06/07 By suncx1
# Input Parameter: 
# Return code....: 
##################################################
FUNCTION i102_jump(p_curs_index)
    DEFINE l_idx   INTEGER
    DEFINE l_jump    LIKE type_file.num10
    DEFINE p_curs_index LIKE type_file.num10 
    IF p_curs_index <= 0 THEN
       LET l_jump = 1
    ELSE
       LET l_jump = p_curs_index
    END IF
    IF g_tree_focus_idx<=0 THEN
       LET g_tree_focus_idx = 1
    END IF
    FOR l_idx = 1 TO g_aag_a.getLength()
       IF g_aag_a[l_idx].aag01 == g_tree[g_tree_focus_idx].treekey1 
          AND g_aag_a[l_idx].aag00 == g_tree[g_tree_focus_idx].treekey2  THEN 
          LET l_jump = l_idx
       END IF
    END FOR  
    RETURN l_jump
END FUNCTION

#FUN-BC0067--Begin--
FUNCTION i102_batch_copy() 
DEFINE aag00_o    LIKE aag_file.aag00,
       aag00_n    LIKE aag_file.aag00,
       aag01      LIKE aag_file.aag01,
       cover      LIKE type_file.chr1,
       l_aaaacti  LIKE aaa_file.aaaacti,
       l_n        LIKE type_file.num5,
       l_cnt      LIKE type_file.num5,
       l_wc       STRING,
       l_sql      STRING
DEFINE x          RECORD LIKE aag_file.*
DEFINE l_success  LIKE type_file.chr1

   OPEN WINDOW i102_w1 AT 8,20
     WITH FORM "agl/42f/agli102_c"  ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("agli102_c")
   LET cover = 'N'   
    
   INPUT BY NAME aag00_o,aag00_n,cover WITHOUT DEFAULTS
       
      AFTER FIELD aag00_o
         IF NOT cl_null(aag00_o) THEN
            SELECT aaaacti INTO l_aaaacti FROM aaa_file
             WHERE aaa01=aag00_o
            IF SQLCA.SQLCODE=100 THEN
               CALL cl_err3("sel","aaa_file",aag00_o,"",100,"","",1)
               NEXT FIELD aag00_o
            END IF
            IF l_aaaacti='N' THEN
               CALL cl_err(aag00_o,"9028",1)
               NEXT FIELD aag00_o
            END IF
         END IF
      AFTER FIELD aag00_n
         IF NOT cl_null(aag00_n) THEN
            SELECT aaaacti INTO l_aaaacti FROM aaa_file
             WHERE aaa01=aag00_n
            IF SQLCA.SQLCODE=100 THEN
               CALL cl_err3("sel","aaa_file",aag00_n,"",100,"","",1)
               NEXT FIELD aag00_o
            END IF
            IF l_aaaacti='N' THEN
               CALL cl_err(aag00_n,"9028",1)
               NEXT FIELD aag00_n
            END IF
         END IF

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(aag00_o)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               LET g_qryparam.default1 = aag00_o
               CALL cl_create_qry() RETURNING aag00_o
               DISPLAY BY NAME aag00_o
               NEXT FIELD aag00_o

            WHEN INFIELD(aag00_n)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               LET g_qryparam.default1 = aag00_n
               CALL cl_create_qry() RETURNING aag00_n
               DISPLAY BY NAME aag00_n
               NEXT FIELD aag00_n
            OTHERWISE
               EXIT CASE
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
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW i102_w1 RETURN END IF

   CONSTRUCT  l_wc ON aag01
          FROM aag01
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(aag01) #科目編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_aag03"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aag01
               NEXT FIELD aag01
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
   IF INT_FLAG  THEN LET INT_FLAG = 0 CLOSE WINDOW i102_w1 RETURN END IF

   MESSAGE ' COPY.... '
   CALL s_showmsg_init()
   LET l_sql = " SELECT * FROM aag_file"
              ," WHERE aag00 ='",aag00_o,"' AND ",l_wc  CLIPPED
              ," ORDER BY aag07 "
   PREPARE i102_p1 FROM l_sql
   DECLARE i102_c1 CURSOR FOR i102_p1
   LET l_cnt = 0
   FOREACH i102_c1 INTO x.*
     #若明細科目,所屬上層統制科目如沒有複製到新帳別區,不予複製
      IF x.aag07 = '2' THEN
         LET l_sql = " SELECT count(*) FROM aag_file"
                    ," WHERE aag00 ='",aag00_n,"' AND aag01='",x.aag08,"'"
         PREPARE i102_p5 FROM l_sql
         DECLARE i102_c5 CURSOR FOR i102_p5
         OPEN i102_c5
         FETCH i102_c5 INTO l_n
         IF l_n = 0 THEN
            LET g_showmsg = aag00_n,"/",x.aag01
            CALL s_errmsg('aag00,aag01',g_showmsg,'',"agl1022",1)
            CONTINUE FOREACH
         END IF
      END IF

      LET x.aag00 = aag00_n
      LET x.aag39 = g_plant
      LET x.aaguser = g_user    #資料所有者
      LET x.aaggrup = g_grup    #資料所有者所屬群
      LET x.aagmodu = NULL      #資料修改日期
      LET x.aagdate = g_today   #資料建立日期
      LET x.aagacti = 'Y'       #有效資料
      LET x.aagoriu = g_user
      LET x.aagorig = g_grup

      LET l_sql = " SELECT count(*) FROM aag_file"
                 ," WHERE aag00 ='",x.aag00,"' AND aag01='",x.aag01,"'"
      PREPARE i102_p4 FROM l_sql
      DECLARE i102_c4 CURSOR FOR i102_p4
      OPEN i102_c4
      FETCH i102_c4 INTO l_n

      IF l_n = 0 THEN
         INSERT INTO aag_file VALUES (x.*)
         IF STATUS THEN
            LET g_showmsg = x.aag00,"/",x.aag01
            CALL s_errmsg('aag00,aag01',g_showmsg,'',STATUS,1)
            CONTINUE FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      ELSE
         IF cover = 'Y' THEN
            LET l_sql= " DELETE FROM aag_file "
                      ," WHERE aag00 = '",x.aag00,"' AND aag01 = '",x.aag01,"'"
            PREPARE i102_p3 FROM l_sql
            EXECUTE i102_p3
            INSERT INTO aag_file VALUES (x.*)
            IF STATUS THEN
               LET g_showmsg = x.aag00,"/",x.aag01
               CALL s_errmsg('aag00,aag01',g_showmsg,'',STATUS,1)
               CONTINUE FOREACH
            END IF
            LET l_cnt = l_cnt + 1
         ELSE
            LET g_showmsg = x.aag00,"/",x.aag01
            CALL s_errmsg('aag00,aag01',g_showmsg,'',"aec-009",1)
            CONTINUE FOREACH
         END IF
      END IF
   END FOREACH
   CALL cl_err_msg('','agl1023',l_cnt,1)
   CALL s_showmsg()
   CLOSE WINDOW i102_w1
END FUNCTION
#FUN-BC0067---End---  
#N0.FUN-D40118 ---Add--- Start
FUNCTION i102_acc()
   DEFINE l_cmd   STRING
   
   IF cl_null(g_aag.aag00) THEN RETURN END IF

  #IF g_aag.aag44 = 'N' THEN    #No.TQC-D50129   Mark
   IF g_aag.aag44 <> 'Y' THEN   #No.TQC-D50129   Mark
      CALL cl_err(g_aag.aag01,"agl-284",1)
      RETURN
   END IF

   LET l_cmd = "agli122 '",g_aag.aag00,"' ",
                       "'",g_aag.aag01,"' ",
                       "'detail' "
   CALL cl_cmdrun_wait(l_cmd)

END FUNCTION
#No.FUN-D40118 ---Add--- End

#MOD-DB0144--add--str--
#上層節點搜索
FUNCTION i102_tree_pid(p_aag00,p_aag01)
DEFINE p_aag00  LIKE aag_file.aag00,
       p_aag01  LIKE aag_file.aag01
DEFINE l_aag08  LIKE aag_file.aag08,
       l_aag24  LIKE aag_file.aag24,
       l_ret    STRING,
       l_ret1   STRING,
       l_str    STRING,
       l_str1   STRING
       
   SELECT aag08,aag24 INTO l_aag08,l_aag24 FROM aag_file 
    WHERE aag00=p_aag00 AND aag01=p_aag01
    
   LET l_ret=".",l_aag24
   LET l_ret1=".",p_aag01
   IF l_aag08!=p_aag01 THEN
      CALL i102_tree_pid(p_aag00,l_aag08) RETURNING l_str,l_str1
      LET l_ret=l_str,l_ret
      LET l_ret1=l_str1,l_ret1
   END IF
   RETURN l_ret,l_ret1
END FUNCTION 
#由下向上抓取上層科目
FUNCTION i102_tree_fill3(p_pid,p_level,p_path,p_aag00,p_aag08) 
   DEFINE p_pid STRING #父節點id 
   DEFINE p_level LIKE type_file.num5 #階層 
   DEFINE p_path  STRING #節點路徑
   DEFINE p_aag00 LIKE aag_file.aag00,
          #p_aag01 LIKE aag_file.aag01, #TQC-DB0087 mark
          p_aag08 LIKE aag_file.aag08
          #p_aag24 LIKE aag_file.aag24  #TQC-DB0087 mark
   DEFINE l_aag01 LIKE aag_file.aag01,
          l_aag02 LIKE aag_file.aag02,
          l_aag08 LIKE aag_file.aag08,
          l_aag24 LIKE aag_file.aag24,
          l_cnt   LIKE type_file.num5,
          l_str   STRING,
          l_str1  STRING
   #TQC-DB0087--add--str--
   DEFINE bst base.StringTokenizer,
          l_pid   STRING,
          l_path  STRING
   #TQC-DB0087--add--end
   
   #TQC-DB0087--mark--str--
   #SELECT aag01,aag02,aag08,aag24 INTO l_aag01,l_aag02,l_aag08,l_aag24 FROM aag_file
   # WHERE aag00=p_aag00 AND aag01=p_aag08
   
   #LET g_idx = g_idx + 1 
   #IF l_aag01!=l_aag08 AND l_aag24!=1 THEN
   #   CALL i102_tree_pid(p_aag00,p_aag01) RETURNING l_str,l_str1 
   #   LET g_tree[g_idx].pid = p_pid,l_str
   #   LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_aag24
   #   LET g_tree[g_idx].path = p_path,l_str1,".",l_aag01
   #ELSE
   #   LET g_tree[g_idx].pid = p_pid CLIPPED
   #   LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_aag24
   #   LET g_tree[g_idx].path = p_path,".",l_aag01
   #END IF
   #LET g_tree[g_idx].expanded = FALSE    #TRUE:展開, FALSE:不展開
   #LET g_tree[g_idx].name = l_aag01 CLIPPED," ",l_aag02      
   #LET g_tree[g_idx].level = p_level
   #LET g_tree[g_idx].treekey1 = l_aag01
   #LET g_tree[g_idx].treekey2 = p_aag00
   #LET g_tree[g_idx].has_children = TRUE
   #SELECT COUNT(aag01) INTO l_cnt FROM aag_file 
   #WHERE aag01 = l_aag08
   #AND aag00 = p_aag00  
   #AND aag01!=aag08 AND aag24!=1 
   #IF l_cnt > 0 THEN
   #   CALL i102_tree_fill3(p_pid,p_level,p_path,p_aag00,l_aag08)
   #END IF 
   #TQC-DB0087--mark--end
   
   #TQC-DB0087--add--str--
   LET l_pid=p_pid   
   LET l_path=p_path 
   CALL i102_tree_pid(p_aag00,p_aag08) RETURNING l_str,l_str1 
   LET bst= base.StringTokenizer.create(l_str1,'.')	
   WHILE bst.hasMoreTokens()	
      LET l_aag01=bst.nextToken()	
      SELECT aag02,aag24 INTO l_aag02,l_aag24 
        FROM aag_file
        WHERE aag00=p_aag00 AND aag01=l_aag01
      LET g_idx = g_idx + 1 
      LET g_tree[g_idx].pid = l_pid CLIPPED
      LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_aag24
      LET g_tree[g_idx].path = l_path,".",l_aag01
      LET g_tree[g_idx].expanded = FALSE    #TRUE:展開, FALSE:不展開
      LET g_tree[g_idx].name = l_aag01 CLIPPED," ",l_aag02      
      LET g_tree[g_idx].level = p_level
      LET g_tree[g_idx].treekey1 = l_aag01
      LET g_tree[g_idx].treekey2 = p_aag00
      LET g_tree[g_idx].has_children = TRUE
      LET l_pid=g_tree[g_idx].id
      LET l_path=g_tree[g_idx].path
   END WHILE	
   #TQC-DB0087--add--end
END FUNCTION
#MOD-DB0144--add--end

#TQC-DB0087--add--str--
FUNCTION i102_first(p_aag00,p_aag01)
DEFINE p_aag00  LIKE aag_file.aag00,
       p_aag01  LIKE aag_file.aag01
DEFINE l_aag07  LIKE aag_file.aag07,
       l_aag08  LIKE aag_file.aag08,
       l_aag24  LIKE aag_file.aag24,
       l_ret    LIKE aag_file.aag01
       
   SELECT aag07,aag08,aag24 INTO l_aag07,l_aag08,l_aag24 FROM aag_file 
    WHERE aag00=p_aag00 AND aag01=p_aag01
    
   LET l_ret=l_aag08 
   IF l_aag24>1 AND l_aag07='1' AND l_aag08!=p_aag01 THEN
      CALL i102_first(p_aag00,l_aag08) RETURNING l_ret
   END IF
   RETURN l_ret
END FUNCTION
#TQC-DB0087--add--end
