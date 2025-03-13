# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asfi500.4gl
# Descriptions...: 製造通知維護作業
# Date & Author..: 00/03/14 By Apple 
# Modify.........: No.B255 010515 mod by linda 原 sfb222 --> sfb91
#                  sfb223--> sfb92
# Modify.........: No:7829 03/08/18 Carol 單據程式中呼叫單據自動編號時,
#                                         應該是要包覆在 BEGIN WORK 中(transaction)
#                                         才會達到lock 的功能
# Modify.........: No:7055 03/10/06 Melody 計算已開工單數量,應排除結案的狀況
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-4C0035 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: NO.FUN-510040 05/02/03 By Echo 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.MOD-530398 05/03/31 By pengu  1.單身輸入應增加列印備註均應增加列印。
                                             #      2.單身完工日期及有效日期，應預設值為 Today
                                             #      3.新增一筆資料後，可以列該筆資料
# Modify.........: No.FUN-550067 05/05/30 By Trisy 單據編號加大
# Modify.........: No.FUN-560060 05/06/14 By day  單據編號修改
# Modify.........: No.FUN-560135 05/06/20 By pengu  1.單據名稱應該顯示。
                                                   #2.用 QBE 查詢出所有單據後，選擇列印，應只列印目前單據。
                                                   #3.A19開窗查詢製造通知單號時卻開啟"單據性質查詢"
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-5A0140 05/10/21 By Claire 報表調整
# Modify.........: No.FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.MOD-5B0269 05/12/14 By Pengu 抓取工單入庫的資料時，忽略了委外工單採購入庫的部分 (rvv_file)
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-630068 06/03/07 By Sarah 指定單據編號、執行功能
# Modify.........: No.MOD-640193 06/04/09 By kim 製造通知單應檢查是否為重覆性生產料件
# Modify.........: No.TQC-660067 06/06/14 By Sarah p_flow功能補強
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.MOD-660086 06/07/05 By Sarah 查詢一筆未確認的單號後按新增再放棄,再按作廢,之前查詢的那筆會被作廢掉
# Modify.........: No.FUN-670103 06/07/31 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-690022 06/09/20 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/10 By yjkhero 新增動態切換單頭部份顯示的功能 
# Modify.........: No.FUN-6A0164 06/11/22 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6C0095 07/01/08 By kim 單頭部門應可為任一部門,不一定是成立中心,開窗應show 所有部門
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740137 07/04/19 By Carrier 筆數統計有問題,沒有納入單身查詢條件g_wc2
#                                                    CONSTRUCT時加入ksfuser,ksfdate,ksfmodu,ksfmodd字段
# Modify.........: No.TQC-750041 07/04/24 By johnray 單身"計劃產量"不能為負
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-830152 08/08/01 By baofei 報表打印改為CR輸出
# Modify.........: No.MOD-8B0049 08/11/06 By claire p_wc2 給值
# Modify.........: No.MOD-910028 09/01/05 By claire 入庫數量為空值
# Modify.........: No.MOD-930306 09/04/03 By Pengu 1.列印時應只印畫面顯示的那一筆製造通知單
#                                                  2.按列印，第一次列印成功，第二次會出現無報表。
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-980019 09/11/05 By jan 虛擬料件不可做任何單據 
# Modify.........: No:TQC-9B0231 09/11/30 By Carrier SQL STANDARDIZE
# Modify.........: No:MOD-9C0041 09/12/25 By Pengu 有效日期default g_today
# Modify.........: No:TQC-9C0191 09/12/30 By lilingyu 查詢時,狀態頁簽有欄位無法下查詢條件
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造
#                                                   成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.TQC-A90020 10/09/07 by destiny 新增时资料建立者未给值 
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No.TQC-AB0146 10/11/30 By chenying 控卡單身計畫量不可小於或等於0
# Modify.........: No:MOD-AC0241 10/12/21 By sabrina asf-906訊息檢查段之SQL需排除作廢工單 
# Modify.........: No:FUN-990078 11/03/28 By jason 品名下面加列印規格(ima021) 
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60037 11/06/08 By lixia 查詢時ksforiu有值但未顯示
# Modify.........: No.TQC-B60039 11/06/08 By lixia 單身計畫量不可小於或等於0
# Modify.........: No.FUN-B60116 11/07/21 By Abby 新增EF整合功能
# Modify.........: No.MOD-B80163 11/08/19 By lilingyu 手工錄入時,未依照最小生產量和生產批量來進行,導致專成工單時報錯
# Modify.........: No:FUN-BA0078 11/11/04 By huangtao CR報表列印EF簽核圖檔 OR TIPTOP自訂簽核欄位
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C20027 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No.MOD-C30277 12/03/10 By fengrui 添加對BOM已確認、已發放的檢查
# Modify.........: No:FUN-C30150 12/03/13 by destiny 画面增加orig
# Modify.........: No:FUN-C30293 12/03/29 By Abby  執行[單身],按"確定",狀況碼才能變成0.開立
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:TQC-C60207 12/06/28 By lixh1 審核時控管廠商是否可用
# Modify.........: No.MOD-C60173 12/06/29 By bart 加上UNIQUE
# Modify.........: No:MOD-C70233 12/07/25 By ck2yuan 料號開窗應只看見有BOM之料號
# Modify.........: No:TQC-C80179 12/08/29 By qiull 審核時控管人員是否可用
# Modify.........: No:MOD-CA0114 12/10/29 By Elise 修正TQC-C40168於bom_chk funtion的修改
# Modify.........: No.FUN-CB0014 12/11/08 By xujing 增加資料清單
# Modify.........: No:MOD-CB0080 12/11/23 By Elise 撈委外入庫量的sql條件加上sfb02=7(需為委外工單)
# Modify.........: No:MOD-CC0186 13/01/11 By Elise 調整結案導致程式關閉的問題
# Modify.........: No.TQC-D10084 13/01/28 By xujing  資料清單頁簽不可點擊單身按鈕
# Modify.........: No:CHI-C80041 13/02/04 By bart 無單身刪除單頭
# Modify.........: No:CHI-D20010 13/02/21 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ksf   RECORD LIKE ksf_file.*,
    g_ksf_t RECORD LIKE ksf_file.*,
    g_ksf_o RECORD LIKE ksf_file.*,
    g_ksf01_t LIKE ksf_file.ksf01,
    g_rvv17 LIKE rvv_file.rvv17,     #No.MOD-5B0269 add
    b_ksg   RECORD LIKE ksg_file.*,
    g_ima   RECORD LIKE ima_file.*,
    g_wc,g_wc2,g_sql    STRING,#TQC-630166
 
    g_ksg           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        ksg02           LIKE ksg_file.ksg02,   #項次
        ksg03           LIKE ksg_file.ksg03,   #生產料號
        ima02           LIKE ima_file.ima02,   #品名規格
        ima021          LIKE ima_file.ima021,   #品名規格
        ima55           LIKE ima_file.ima55,   #生產單位
        ksg04           LIKE ksg_file.ksg04,   #完工日期
        ksg07           LIKE ksg_file.ksg07,   #成品完工日
        ksg05           LIKE ksg_file.ksg05,   #計劃產量
        sfb08           LIKE sfb_file.sfb08,   #No.FUN-680121 DECIMAL(15,3) #已開工單量
        sfv09           LIKE sfv_file.sfv09,   #No.FUN-680121 DECIMAL(15,3) #入庫數量
        ksg09           LIKE ksg_file.ksg09,   #結案否
        ksg11           LIKE ksg_file.ksg11,   #備註 
        ksg930          LIKE ksg_file.ksg930, #FUN-670103
        gem02c          LIKE gem_file.gem02   #FUN-670103
                    END RECORD,
    g_ksg_t         RECORD                 #程式變數 (舊值)
        ksg02           LIKE ksg_file.ksg02,   #項次
        ksg03           LIKE ksg_file.ksg03,   #生產料號
        ima02           LIKE ima_file.ima02,   #品名規格
        ima021          LIKE ima_file.ima021,   #品名規格
        ima55           LIKE ima_file.ima55,   #生產單位
        ksg04           LIKE ksg_file.ksg04,   #完工日期
        ksg07           LIKE ksg_file.ksg07,   #成品完工日
        ksg05           LIKE ksg_file.ksg05,   #計劃產量
        sfb08           LIKE sfb_file.sfb08,   #No.FUN-680121 DECIMAL(15,3) #已開工單量
        sfv09           LIKE sfv_file.sfv09,   #No.FUN-680121 DECIMAL(15,3) #入庫數量
        ksg09           LIKE ksg_file.ksg09,   #結案否
        ksg11           LIKE ksg_file.ksg11,   #備註 
        ksg930          LIKE ksg_file.ksg930, #FUN-670103
        gem02c          LIKE gem_file.gem02   #FUN-670103
                    END RECORD,
    ksg05t,sfb08t        LIKE ksg_file.ksg05,   #No.FUN-680121 DECIMAL(15,3) #TQC-840066
    l_za05          LIKE za_file.za05,
    g_buf           LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(78)
    g_mxno          LIKE oea_file.oea01,          #No.FUN-680121 VARCHAR(16) #No.FUN-550060
   #g_argv1         LIKE oea_file.oea01,          #No.FUN-680121 VARCHAR(16) #No.FUN-550060  #FUN-B60116 mark
    g_argv1         LIKE ksf_file.ksf01,          #No.FUN-680121 VARCHAR(16) #No.FUN-550060  #FUN-B60116 add
    g_argv2         STRING,             #TQC-630068   #執行功能
    g_t1            LIKE oay_file.oayslip,           #No.FUN-550060        #No.FUN-680121 VARCHAR(05)
    l_sfb09         LIKE type_file.num10,         #No.FUN-680121 INTEGR
    l_ksg08         LIKE ksg_file.ksg08,
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680121 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680121 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680121 INTEGER
#DEFINE   g_dash          VARCHAR(400)   #Dash line
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(72)
#DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE   g_confirm       LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_approve       LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_post          LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_close         LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_void          LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_valid         LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_laststage     LIKE type_file.chr1          #No.FUN-B60116 VARCHAR(1)
#No.FUN-830152---Begin                                                                                                              
 DEFINE l_table        STRING,                                                                                                      
        g_str          STRING                                                                                                       
#No.FUN-830152---End 

#FUN-CB0014---add---str---
DEFINE g_rec_b1     LIKE type_file.num5
DEFINE g_ksf_l      DYNAMIC ARRAY OF RECORD
                    ksf01   LIKE ksf_file.ksf01,
                    smydesc LIKE smy_file.smydesc,
                    ksf02   LIKE ksf_file.ksf02,
                    ksf08   LIKE ksf_file.ksf08,
                    gem02   LIKE gem_file.gem02,
                    ksf10   LIKE ksf_file.ksf10,
                    gen02   LIKE gen_file.gen02,
                    ksf05   LIKE ksf_file.ksf05,
                    ksfconf LIKE ksf_file.ksfconf,
                    ksfmksg LIKE ksf_file.ksfmksg,
                    ksf09   LIKE ksf_file.ksf09
                    END RECORD
DEFINE  l_ac1         LIKE type_file.num5
DEFINE  g_action_flag  STRING
DEFINE   w    ui.Window
DEFINE   f    ui.Form
DEFINE   page om.DomNode
#FUN-CB0014---add---end---
MAIN
#DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0090
 DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680121 SMALLINT

   IF FGL_GETENV("FGLGUI") <> "0" THEN  #FUN-B60116 add 
      OPTIONS
          INPUT NO WRAP,
          FIELD ORDER FORM
      DEFER INTERRUPT
   END IF                               #FUN-B60116 add
 
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)   #TQC-630068

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
#No.FUN-830152---Begin                                                                                                              
    LET g_sql = " ksf01.ksf_file.ksf01,",                                                                                           
                " ksf02.ksf_file.ksf02,",                                                                                           
                " ksf05.ksf_file.ksf05,",                                                                                           
                " ksg02.ksg_file.ksg02,",                                                                                           
                " ksg03.ksg_file.ksg03,",                                                                                           
                " ksg04.ksg_file.ksg04,",                                                                                           
                " ksg05.ksg_file.ksg05,",                                                                                           
                " ksg07.ksg_file.ksg07,",                                                                                           
                " ksg09.ksg_file.ksg09,",                                                                                           
                " ksg11.ksg_file.ksg11,",                                                                                           
                " ima02.ima_file.ima02,",
                " ima021.ima_file.ima021,", #NO.FUN-990078                                                                                                           
                " sfb08.sfb_file.sfb08,",                                                                                           
                " sfv09.sfv_file.sfv09,", 
                "sign_type.type_file.chr1,", #FUN-BA0078 add
                "sign_img.type_file.blob,",  #FUN-BA0078 add
                "sign_show.type_file.chr1"   #FUN-BA0078 add                    
   LET l_table = cl_prt_temptable('asfi500',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?) "   #FUN-BA0078 add 3?   #NO.FUN-990078                                                                              
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
#No.FUN-830152---End        

    IF g_bgjob = 'N' OR cl_null(g_bgjob) THEN  #FUN-B60116 add
       LET p_row = 2 LET p_col = 6
       OPEN WINDOW i500_w AT p_row,p_col WITH FORM "asf/42f/asfi500" 
             ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
       
       CALL cl_ui_init()
    END IF                                     #FUN-B60116 add

    #FUN-B60116 add str---
    IF fgl_getenv('EASYFLOW') = "1" THEN   #判斷是否為簽核模式
       LET g_argv1 = aws_efapp_wsk(1)   #取得單號
    END IF
    #FUN-B60116 add end---
    
    #FUN-670103...............begin
    IF g_aaz.aaz90='Y' THEN
       CALL cl_set_comp_required("ksf08",TRUE)
    END IF
    CALL cl_set_comp_visible("ksg930,gem02c",g_aaz.aaz90='Y')
    #FUN-670103...............end
 
    #FUN-B60116 add str---
    #當為 EasyFlow 簽核時, 加入 EasyFlow 簽核 toolbar icon
    CALL aws_efapp_toolbar() 
    #FUN-B60116 add end---

   #start TQC-630068
    # 先以g_argv2判斷直接執行哪種功能：
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL i500_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL i500_a()
             END IF
          #FUN-B60116 add str---
          WHEN "efconfirm"
             CALL i500_q()
             CALL i500_y_chk()          #CALL 原確認的 check 段
             IF g_success = "Y" THEN
                CALL i500_y_upd()       #CALL 原確認的 update 段
             END IF
             EXIT PROGRAM
          #FUN-B60116 add end---
          OTHERWISE          #TQC-660067 add
             CALL i500_q()   #TQC-660067 add
       END CASE
    END IF
   #end TQC-630068
 
   #FUN-B60116 add str---
   #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
    CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, detail_close, query, locale, void, undo_void, confirm,undo_confirm, easyflow_approval")  #CHI-D20010 add undo_void
       RETURNING g_laststage
   #FUN-B60116 add end---

    CALL i500()
    CLOSE WINDOW i500_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
END MAIN
 
FUNCTION i500()
    INITIALIZE g_ksf.* TO NULL
    INITIALIZE g_ksf_t.* TO NULL
    INITIALIZE g_ksf_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM ksf_file WHERE ksf01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i500_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    CALL i500_menu()
 
END FUNCTION
 
FUNCTION i500_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM
    CALL g_ksg.clear()
 
 #start TQC-630068
  IF NOT cl_null(g_argv1) THEN
     LET g_wc = " ksf01 = '",g_argv1,"'"
     LET g_wc2= " 1=1"
  ELSE
 #end TQC-630068
    CALL cl_set_head_visible("","YES")        #NO.FUN-6B0031  
   INITIALIZE g_ksf.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON ksf01,ksf02,ksf08,ksf10,ksf05,ksfconf,ksfmksg,ksf09, #FUN-670103  #FUN-B60116 add ksf10,ksfmksg,ksf09
                              ksfuser,ksfdate,ksfmodu,ksfmodd  #No.TQC-740137
                              ,ksforiu                         #TQC-9C0191 
                              ,ksforig                         #FUN-C30150    
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE WHEN INFIELD(ksf01) #查詢單据
                  #--No.FUN-560135
                     CALL cl_init_qry_var()
                     LET g_qryparam.state  = "c"
                     LET g_qryparam.form = "q_ksf1"
                     LET g_qryparam.default1 = g_ksf.ksf01
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ksf01
#                    LET g_t1=g_ksf.ksf01[1,3]
#                    LET g_t1 = s_get_doc_no(g_ksf.ksf01)     #No.FUN-550067  
#                    CALL q_smy(TRUE,TRUE,g_t1,'asf','7') RETURNING g_t1
#                    LET g_ksf.ksf01[1,3]=g_t1
#                    LET g_ksf.ksf01 = g_t1                 #No.FUN-550067 
#                    DISPLAY BY NAME g_ksf.ksf01 
                     NEXT FIELD ksf01
                   #--end
                #FUN-670103...............begin   
                WHEN INFIELD(ksf08)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_gem" #TQC-6C0095
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ksf08
                     NEXT FIELD ksf08
                #FUN-670103...............end
               #FUN-B60116 add str--------
                WHEN INFIELD(ksf10) #申請人
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_gen"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ksf10
                     NEXT FIELD ksf10
               #FUN-B60116 add end--------
               OTHERWISE
            END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT 
   # LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ksfuser', 'ksfgrup') #FUN-980030
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ksfuser', 'ksforig') #FUN-C30150

    IF INT_FLAG THEN RETURN END IF
 
    CONSTRUCT g_wc2 ON ksg02,ksg03,ksg04,ksg07,ksg05,ksg09,ksg11,ksg930 #FUN-670103
                  FROM s_ksg[1].ksg02,s_ksg[1].ksg03,s_ksg[1].ksg04,
                       s_ksg[1].ksg07,s_ksg[1].ksg05,s_ksg[1].ksg09,s_ksg[1].ksg11,
                       s_ksg[1].ksg930 #FUN-670103
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE WHEN INFIELD(ksg03)
#FUN-AA0059---------mod------------str-----------------           
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.state    = "c"
#                    #LET g_qryparam.form     = "q_ima" #MOD-640193
#                     LET g_qryparam.form     = "q_ima18" #MOD-640193
#                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima(TRUE, "q_ima51","","","","","","","",'')  RETURNING  g_qryparam.multiret  #MOD-C70233 q_ima18->q_imq51
#FUN-AA0059---------mod------------end-----------------
                     DISPLAY g_qryparam.multiret TO s_ksg[1].ksg03
                     NEXT FIELD ksg03
                #FUN-670103...............begin
                WHEN INFIELD(ksg930)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_gem4"
                   LET g_qryparam.state = "c"   #多選
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ksg930
                   NEXT FIELD ksg930
                #FUN-670103...............end
               OTHERWISE
           END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
    
		#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT 
  END IF   #TQC-630068
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND ksfuser = '",g_user,"'"
    #    END IF
    IF g_wc2=' 1=1'
       THEN LET g_sql="SELECT ksf01 FROM ksf_file ",
                      " WHERE ",g_wc CLIPPED, " ORDER BY ksf01"
       ELSE LET g_sql="SELECT UNIQUE ksf01",  #MOD-C60173
                      "  FROM ksf_file,ksg_file ",
                      " WHERE ksf01=ksg01",
                      "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                      " ORDER BY ksf01"
    END IF
    PREPARE i500_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE i500_cs SCROLL CURSOR WITH HOLD FOR i500_prepare
    DECLARE i500_fill_cs CURSOR FOR i500_prepare  #FUN-CB0014
    #No.TQC-740137  --Begin
#   LET g_sql= "SELECT COUNT(*) FROM ksf_file WHERE ",g_wc CLIPPED
    IF g_wc2=' 1=1'
       THEN LET g_sql="SELECT COUNT(*) FROM ksf_file ",
                      " WHERE ",g_wc CLIPPED
       ELSE LET g_sql="SELECT COUNT(UNIQUE ksf01)",
                      "  FROM ksf_file,ksg_file ",
                      " WHERE ksf01=ksg01",
                      "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    #No.TQC-740137  --End  
    PREPARE i500_precount FROM g_sql
    DECLARE i500_count CURSOR FOR i500_precount
END FUNCTION
 
FUNCTION i500_menu()
 DEFINE l_creator      LIKE type_file.chr1    #No.FUN-B60116  VARCHAR(1)  #是否退回填表人
 DEFINe l_flowuser     LIKE type_file.chr1    #No.FUN-B60116  VARCHAR(1)  #是否有指定加簽人員

   LET l_flowuser = "N"  #FUN-B60116 add
   WHILE TRUE
      IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN   #FUN-CB0014 add
         CALL i500_bp("G")
      #FUN-CB0014---add---str---
      ELSE                           
         CALL i500_list_fill()
         CALL i500_bp2("G")           
         IF NOT cl_null(g_action_choice) AND l_ac1>0 THEN #將清單的資料回傳到主畫面
            SELECT ksf_file.* INTO g_ksf.*
              FROM ksf_file
             WHERE ksf01=g_ksf_l[l_ac1].ksf01
         END IF
         IF g_action_choice!= "" THEN
            LET g_action_flag = "page_main"
            LET l_ac1 = ARR_CURR()
            LET g_jump = l_ac1
            LET mi_no_ask = TRUE
            IF g_rec_b1 >0 THEN
               CALL i500_fetch('/')
            END IF
            CALL cl_set_comp_visible("page_info", FALSE)
            CALL cl_set_comp_visible("info", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page_info", TRUE)
            CALL cl_set_comp_visible("info", TRUE)
          END IF               
      END IF  
      #FUN-CB0014---add---str--
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ') THEN
               CALL i500_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i500_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ')
               THEN CALL i500_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ')
               THEN CALL i500_u()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ') THEN
               CALL i500_b('0')
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"    #No.B255 010515 add
            IF cl_chk_act_auth()
               THEN CALL i500_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "confirm" 
            IF cl_chk_act_auth() THEN
              #FUN-B60116 mod str--- 
              #CALL i500_y() 
               CALL i500_y_chk()
               IF g_success = 'Y' THEN
                  CALL i500_y_upd()
#                 CALL i500_list_fill()      #FUN-CB0014
                  CALL i500_refresh() RETURNING g_ksf.*
                  CALL i500_show()
               END IF
              #FUN-B60116 mod end---
            END IF
            CASE g_ksf.ksfconf
                 WHEN 'Y'   LET g_confirm = 'Y'
                            LET g_void = ''
                 WHEN 'N'   LET g_confirm = 'N'
                            LET g_void = ''
                 WHEN 'X'   LET g_confirm = ''
                            LET g_void = 'Y'
              OTHERWISE     LET g_confirm = ''
                            LET g_void = ''
            END CASE
            #圖形顯示
            CALL cl_set_field_pic(g_confirm,"","","",g_void,'')
         WHEN "undo_confirm" 
            IF cl_chk_act_auth() THEN
               CALL i500_z() 
#              CALL i500_list_fill()    #FUN-CB0014
               CALL i500_show() #FUN-CB0014
            END IF
            CASE g_ksf.ksfconf
                 WHEN 'Y'   LET g_confirm = 'Y'
                            LET g_void = ''
                 WHEN 'N'   LET g_confirm = 'N'
                            LET g_void = ''
                 WHEN 'X'   LET g_confirm = ''
                            LET g_void = 'Y'
              OTHERWISE     LET g_confirm = ''
                            LET g_void = ''
            END CASE
            #圖形顯示
            CALL cl_set_field_pic(g_confirm,"","","",g_void,'')

        #FUN-B60116 add str---
        #@WHEN "簽核狀況"
         WHEN "approval_status"     
            IF cl_chk_act_auth() THEN      
               IF aws_condition2() THEN
                  CALL aws_efstat2()
               END IF
            END IF
        #@WHEN "EasyFlow送簽"
         WHEN "easyflow_approval"      
            IF cl_chk_act_auth() THEN
              #FUN-C20027 add str---
               SELECT * INTO g_ksf.* FROM ksf_file
                WHERE ksf01 = g_ksf.ksf01
               CALL i500_show()
               CALL i500_b_fill(' 1=1')
              #FUN-C20027 add end---
               CALL i500_ef()
               CALL i500_show()  #FUN-C20027 add
#              CALL i500_list_fill() #FUN-CB0014 add
            END IF

        #@WHEN "准"
         WHEN "agree"
            IF g_laststage = "Y" AND l_flowuser = "N" THEN #最後一關且無加簽
                 CALL i500_y_upd()      #CALL 原確認的 update 段
               CALL i500_refresh() RETURNING g_ksf.*
               CALL i500_show()
#              CALL i500_list_fill()    #FUN-CB0014
              ELSE
                 LET g_success = "Y"
               IF NOT aws_efapp_formapproval() THEN        #執行EF簽核
                    LET g_success = "N"
                 END IF
              END IF
              IF g_success = 'Y' THEN
               IF cl_confirm('aws-081') THEN            #詢問是否繼續下一筆資料的簽核
                  IF aws_efapp_getnextforminfo() THEN   #取得下一筆簽核單號
                          LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                     IF NOT cl_null(g_argv1) THEN       #自動query帶出資料
                                CALL i500_q()
                        #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                        CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void, confirm,undo_confirm,easyflow_approval")  #CHI-D20010 add undo_void
                           RETURNING g_laststage
                          ELSE
                              EXIT WHILE
                          END IF
                        ELSE
                              EXIT WHILE
                        END IF
                    ELSE
                       EXIT WHILE
                    END IF
              END IF
 
         #@WHEN "不准"
         WHEN "deny"
            IF (l_creator := aws_efapp_backflow()) IS NOT NULL THEN   #退回關卡
               IF aws_efapp_formapproval() THEN                       #執行EF簽核
                  IF l_creator = "Y" THEN                             #當退回填表人時
                     LET g_ksf.ksf09 = 'R'                            #顯示狀態碼為"R"送簽退回
                      DISPLAY BY NAME g_ksf.ksf09
                   END IF
                  IF cl_confirm('aws-081') THEN                       #詢問是否繼續下一筆資料的簽核
                     IF aws_efapp_getnextforminfo() THEN              #取得下一筆簽核單號
                          LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                        IF NOT cl_null(g_argv1) THEN                  #自動query帶出資料
                                CALL i500_q()
                           #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                           CALL aws_efapp_flowaction("insert, modify, delete,reproduce, detail, query, locale,void, undo_void, confirm,undo_confirm, undo_confirm,easyflow_approval")  #CHI-D20010 add undo_void
                              RETURNING g_laststage
                          ELSE
                                EXIT WHILE
                          END IF
                      ELSE
                            EXIT WHILE
                      END IF
                   ELSE
                      EXIT WHILE
                   END IF
                END IF
              END IF
 
         #@WHEN "加簽"
         WHEN "modify_flow"
              IF aws_efapp_flowuser() THEN   #選擇欲加簽人員
                 LET l_flowuser = 'Y'
              ELSE
                 LET l_flowuser = 'N'
              END IF
 
         #@WHEN "撤簽"
         WHEN "withdraw"
              IF cl_confirm("aws-080") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF
 
         #@WHEN "抽單"
         WHEN "org_withdraw"
              IF cl_confirm("aws-079") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF
 
        #@WHEN "簽核意見"
         WHEN "phrase"
              CALL aws_efapp_phrase()
        #FUN-B60116 add end---
          
         WHEN "detail_close" 
            IF cl_chk_act_auth() THEN
               CALL i500_b('1')
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "void" 
            IF cl_chk_act_auth() THEN
              #CALL i500_x()      #CHI-D20010
               CALL i500_x(1)     #CHI-D20010
            END IF
            CASE g_ksf.ksfconf
                 WHEN 'Y'   LET g_confirm = 'Y'
                            LET g_void = ''
                 WHEN 'N'   LET g_confirm = 'N'
                            LET g_void = ''
                 WHEN 'X'   LET g_confirm = ''
                            LET g_void = 'Y'
              OTHERWISE     LET g_confirm = ''
                            LET g_void = ''
            END CASE
            #圖形顯示
            CALL cl_set_field_pic(g_confirm,"","","",g_void,'')

         #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL i500_x(2)
            END IF
            CASE g_ksf.ksfconf
                 WHEN 'Y'   LET g_confirm = 'Y'
                            LET g_void = ''
                 WHEN 'N'   LET g_confirm = 'N'
                            LET g_void = ''
                 WHEN 'X'   LET g_confirm = ''
                            LET g_void = 'Y'
              OTHERWISE     LET g_confirm = ''
                            LET g_void = ''
            END CASE
            #圖形顯示
            CALL cl_set_field_pic(g_confirm,"","","",g_void,'')
         #CHI-D20010---end
 
#FUN-4B0011
         WHEN "exporttoexcel"
            LET w = ui.Window.getCurrent()   #FUN-CB0014 add
            LET f = w.getForm()              #FUN-CB0014 add
            IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN   #FUN-CB0014 add
               LET page = f.FindNode("Page","page_main")  #FUN-CB0014 add
               IF cl_chk_act_auth() THEN
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_ksg),'','')
               END IF
            #FUN-CB0014---add---str---
            END IF                   
            IF g_action_flag = "page_info" THEN 
               LET page = f.FindNode("Page","page_info")
               IF cl_chk_act_auth() THEN
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_ksf_l),'','')
               END IF
            END IF
            #FUN-CB0014---add---end---
## 
         #No.FUN-6A0164-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_ksf.ksf01 IS NOT NULL THEN
                 LET g_doc.column1 = "ksf01"
                 LET g_doc.value1 = g_ksf.ksf01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0164-------add--------end----
      END CASE
   END WHILE
   CLOSE i500_cs
END FUNCTION
 
FUNCTION i500_a()
    DEFINE li_result   LIKE type_file.num5          #No.FUN-550067         #No.FUN-680121 SMALLINT
    IF s_shut(0) THEN RETURN END IF
   #MESSAGE ""                                   #FUN-B60116 mark
    CALL cl_msg("")                              #FUN-B60116 add
    CLEAR FORM                                   # 清螢幕欄位內容
    CALL g_ksg.clear()
    INITIALIZE g_ksf.* LIKE ksf_file.*
    LET g_ksf01_t = NULL
    LET g_ksf.ksfuser = g_user
    LET g_ksf.ksfdate = g_today
    LET g_ksf.ksfconf = 'N'
    LET g_ksf.ksf08 = g_grup #FUN-670103
    LET g_ksf.ksfplant = g_plant #FUN-980008 add
    LET g_ksf.ksflegal = g_legal #FUN-980008 add
    LET g_ksf.ksforiu = g_user #No.TQC-A90020 add
    LET g_ksf.ksf09 = '0'    #FUN-B60116 add
    LET g_ksf.ksfmksg = 'N'  #FUN-B60116 add
    LET g_ksf.ksf10 = g_user #FUN-B60116 add
    CALL i500_ksf10()        #FUN-B60116 add
    LET g_ksf.ksforig = g_grup #FUN-C30150 add
    DISPLAY s_costcenter_desc(g_ksf.ksf08) TO FORMONLY.gem02 #TQC-6C0095
    DISPLAY BY NAME g_ksf.ksforig  #FUN-C30150
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i500_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           CALL g_ksg.clear()
           EXIT WHILE
        END IF
        IF cl_null(g_ksf.ksf01) THEN             # KEY 不可空白
           CONTINUE WHILE
        END IF
 
        BEGIN WORK   #No:7829
       #No.FUN-550067 --start--                                                                                                       
        CALL s_auto_assign_no("asf",g_ksf.ksf01,g_today,"7","ksf_file","ksf01","","","") 
        RETURNING li_result,g_ksf.ksf01                                                    
      IF (NOT li_result) THEN
         ROLLBACK WORK   #No:7829    #No.FUN-560060
         CONTINUE WHILE                                                                                                             
      END IF                                                                                                                        
      DISPLAY BY NAME g_ksf.ksf01 
 
#      IF g_smy.smyauno='Y' THEN
#	   CALL s_smyauno(g_ksf.ksf01,g_today) RETURNING g_i,g_ksf.ksf01
#          IF g_i THEN #有問題
#             ROLLBACK WORK   #No:7829
#             CONTINUE WHILE
#          END IF
#          DISPLAY BY NAME g_ksf.ksf01
#       END IF
       #No.FUN-550067 --end--                                                                                                       
        LET g_ksf.ksforiu = g_user      #No.FUN-980030 10/01/04
        LET g_ksf.ksforig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO ksf_file VALUES(g_ksf.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_ksf.ksf01,SQLCA.sqlcode,0)   #No.FUN-660128
           CALL cl_err3("ins","ksf_file",g_ksf.ksf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
           ROLLBACK WORK   #No:7829
           CONTINUE WHILE
        ELSE
           COMMIT WORK     #No:7829 
 
           CALL cl_flow_notify(g_ksf.ksf01,'I')
 
           LET g_ksf_t.* = g_ksf.*               # 保存上筆資料
           SELECT ksf01 INTO g_ksf.ksf01 FROM ksf_file
                  WHERE ksf01 = g_ksf.ksf01
        END IF
 
        CALL g_ksg.clear()
 
        LET g_rec_b = 0 
        CALL i500_b('0')
 
       #FUN-B60116 add str----
        IF NOT cl_null(g_ksf.ksf01) AND g_smy.smydmy4='Y' AND g_smy.smyapr <> 'Y' THEN  #確認
           LET g_action_choice = "insert"     
      
           CALL i500_y_chk()          #CALL 原確認的 check 段
           IF g_success = "Y" THEN
               CALL i500_y_upd()      #CALL 原確認的 update 段
               CALL i500_refresh() RETURNING g_ksf.*
               CALL i500_show()    
#              CALL i500_list_fill()   #FUN-CB0014               
           END IF
        END IF
       #FUN-B60116 add end----
 
        EXIT WHILE
    END WHILE
      LET g_wc=' '    #No.MOD-530398
END FUNCTION
 
FUNCTION i500_i(p_cmd)
    DEFINE li_result   LIKE type_file.num5          #No.FUN-550067         #No.FUN-680121 SMALLINT
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
        l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入        #No.FUN-680121 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680121 SMALLINT
    DEFINE l_smydesc    LIKE smy_file.smydesc        #No.FUN-680121 VARCHAR(20) #No.FUN-560135 
    DEFINE l_gemacti    LIKE gem_file.gemacti #TQC-6C0095
   
    CALL cl_set_head_visible("","YES")        #NO.FUN-6B0031  
    DISPLAY BY NAME g_ksf.ksforiu           #No.TQC-A90020  
    INPUT BY NAME
           g_ksf.ksf01,g_ksf.ksf02,g_ksf.ksf08,g_ksf.ksf10,g_ksf.ksf05,g_ksf.ksfconf,g_ksf.ksfmksg,g_ksf.ksf09, #FUN-670103  #FUN-B60116 add ksf10,ksfmksg,ksf09
           g_ksf.ksfuser,g_ksf.ksfdate,g_ksf.ksfmodu,g_ksf.ksfmodd
        WITHOUT DEFAULTS
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i500_set_entry(p_cmd)
          CALL i500_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
         #No.FUN-550067 --start--                                                                                                   
         CALL cl_set_docno_format("ksf01")                                                                                          
         CALL cl_set_docno_format("ksf05")                                                                                          
         #No.FUN-550067 ---end---         
 
        AFTER FIELD ksf01  
        #No.FUN-550067 --start-- 
         IF g_ksf.ksf01 != g_ksf01_t OR g_ksf01_t IS NULL THEN                                                                                             
            CALL s_check_no("asf",g_ksf.ksf01,g_ksf01_t,"7","ksf_file","ksf01","")  
            RETURNING li_result,g_ksf.ksf01                                                   
            LET g_ksf.ksfmksg=g_smy.smyapr  #FUN-B60116 add
            DISPLAY BY NAME g_ksf.ksf01                                                                                             
            DISPLAY BY NAME g_ksf.ksfmksg   #FUN-B60116 add
            IF (NOT li_result) THEN                                                                                                 
               LET g_ksf.ksf01=g_ksf_o.ksf01                                                                                        
               NEXT FIELD ksf01                                                                                                     
            END IF                                                                                                                  
#         IF NOT cl_null(g_ksf.ksf01) THEN 
#            LET g_t1=g_ksf.ksf01[1,3]
#            CALL s_mfgslip(g_t1,'asf','7')
#            IF NOT cl_null(g_errno) THEN                  #抱歉, 有問題
#               CALL cl_err(g_t1,g_errno,0) NEXT FIELD ksf01
#            END IF
#            IF p_cmd = 'a' AND cl_null(g_ksf.ksf01[5,10]) AND 
#               g_smy.smyauno = 'N' THEN 
#                 NEXT FIELD ksf01
#            END IF
#           
#            #---->check 自動編號
#            IF g_smy.smyauno MATCHES '[nN]' THEN 
#                 IF cl_null(g_ksf.ksf01[5,10]) THEN 
#                    CALL cl_err(g_ksf.ksf01,'mfg6089',0)
#                    NEXT FIELD ksf01
#                 END IF
#                 IF NOT cl_chk_data_continue(g_ksf.ksf01[5,10]) THEN
#                      CALL cl_err('','9056',0)
#                      NEXT FIELD ksf01
#                 END IF
#            END IF
#           
#            #---->check 鍵值重複
#            IF g_ksf.ksf01 != g_ksf_t.ksf01 OR g_ksf_t.ksf01 IS NULL THEN
#               IF g_smy.smyauno = 'Y' AND NOT cl_chk_data_continue(g_ksf.ksf01[5,10]) THEN
#                  CALL cl_err('','9056',0) NEXT FIELD ksf01
#               END IF
#               SELECT count(*) INTO g_cnt FROM ksf_file WHERE ksf01 = g_ksf.ksf01
#               IF g_cnt > 0 THEN   #資料重複
#                  CALL cl_err(g_ksf.ksf01,-239,0)
#                  LET g_ksf.ksf01 = g_ksf_t.ksf01
#                  DISPLAY BY NAME g_ksf.ksf01
#                  NEXT FIELD ksf01
#               END IF
             #--No.FUN-560135
                LET g_t1 = s_get_doc_no(g_ksf.ksf01)     
                SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip=g_t1
                DISPLAY l_smydesc TO smydesc
             #--end
                
#     END IF
         #No.FUN-550067 ---end---    
          END IF
          CALL i500_set_no_entry(p_cmd)
 
        #FUN-670103...............begin
        AFTER FIELD ksf08
           IF NOT cl_null(g_ksf.ksf08) THEN
             #TQC-6C0095............begin
                 LET g_errno=NULL
                 SELECT gemacti INTO l_gemacti FROM gem_file
                                              WHERE gem01=g_ksf.ksf08
                 CASE
                    WHEN SQLCA.sqlcode
                       LET g_errno=SQLCA.sqlcode
                    WHEN l_gemacti='N'
                       LET g_errno='9028'
                 END CASE
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err3("sel","gem_file",g_ksf.ksf08,"",g_errno,"","",1)
                    LET g_ksf.ksf08=g_ksf_t.ksf08
                    DISPLAY BY NAME g_ksf.ksf08
                    DISPLAY s_costcenter_desc(g_ksf.ksf08) TO FORMONLY.gem02
                    NEXT FIELD ksf08
                 ELSE
                    DISPLAY s_costcenter_desc(g_ksf.ksf08) TO FORMONLY.gem02
                 END IF
             #TQC-6C0095............end
           ELSE
              DISPLAY NULL TO FORMONLY.gem02
           END IF
        #FUN-670103...............end
 
       #FUN-B60116 add str------
        AFTER FIELD ksf10
          IF NOT cl_null(g_ksf.ksf10) THEN
             CALL i500_ksf10()
             IF NOT cl_null(g_errno) THEN
                LET g_ksf.ksf10 = g_ksf_t.ksf10
                CALL cl_err(g_ksf.ksf10,g_errno,0)
                DISPLAY BY NAME g_ksf.ksf10 
                NEXT FIELD ksf10
             END IF
          ELSE
             DISPLAY '' TO FORMONLY.gen02
          END IF
       #FUN-B60116 add end------
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_ksf.ksfuser = s_get_data_owner("ksf_file") #FUN-C10039
          IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION controlp
           CASE WHEN INFIELD(ksf01) #查詢單据
#                    LET g_t1=g_ksf.ksf01[1,3]
                     LET g_t1 = s_get_doc_no(g_ksf.ksf01)     #No.FUN-550067
                    #CALL q_smy(FALSE,TRUE,g_t1,'asf','7') RETURNING g_t1  #TQC-670008
                     CALL q_smy(FALSE,TRUE,g_t1,'ASF','7') RETURNING g_t1  #TQC-670008
#                     CALL FGL_DIALOG_SETBUFFER( g_t1 )
#                    LET g_ksf.ksf01[1,3]=g_t1
                     LET g_ksf.ksf01 = g_t1                 #No.FUN-550067 
                     DISPLAY BY NAME g_ksf.ksf01 
                     NEXT FIELD ksf01
               #FUN-670103...............begin
               WHEN INFIELD(ksf08)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem" #TQC-6C0095
                    LET g_qryparam.default1 = g_ksf.ksf08
                    CALL cl_create_qry() RETURNING g_ksf.ksf08
                    DISPLAY BY NAME g_ksf.ksf08
                    NEXT FIELD ksf08
               #FUN-670103...............end

              #FUN-B60116 add str------
               WHEN INFIELD(ksf10)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.default1 = g_ksf.ksf10
                    CALL cl_create_qry() RETURNING g_ksf.ksf10
                    DISPLAY BY NAME g_ksf.ksf10
                    NEXT FIELD ksf10
              #FUN-B60116 add end------

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
    
    END INPUT
END FUNCTION
 
FUNCTION i500_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ksf01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i500_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ksf01",FALSE)
    END IF
END FUNCTION
 
FUNCTION i500_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ksf.* TO NULL              #No.FUN-6A0164
    CALL cl_opmsg('q')
   #MESSAGE ""                                   #FUN-B60116 mark
    CALL cl_msg("")                              #FUN-B60116 add
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i500_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_ksg.clear()
        RETURN
    END IF
   #MESSAGE " SEARCHING ! "                      #FUN-B60116 mark
    CALL cl_msg(" SEARCHING ! ")                 #FUN-B60116 add
 
    OPEN i500_count
    FETCH i500_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
 
    OPEN i500_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ksf.ksf01,SQLCA.sqlcode,0)
        INITIALIZE g_ksf.* TO NULL
    ELSE
        CALL i500_fetch('F')                # 讀出TEMP第一筆並顯示
#       CALL i500_list_fill()  #FUN-CB0014
    END IF
   #MESSAGE ""                                   #FUN-B60116 mark
    CALL cl_msg("")                              #FUN-B60116 add
END FUNCTION
 
FUNCTION i500_fetch(p_flksf)
    DEFINE
        p_flksf         LIKE type_file.chr1,         #No.FUN-680121 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680121 INTEGER
 
    CASE p_flksf
        WHEN 'N' FETCH NEXT     i500_cs INTO g_ksf.ksf01
        WHEN 'P' FETCH PREVIOUS i500_cs INTO g_ksf.ksf01
        WHEN 'F' FETCH FIRST    i500_cs INTO g_ksf.ksf01
        WHEN 'L' FETCH LAST     i500_cs INTO g_ksf.ksf01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
               
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i500_cs INTO g_ksf.ksf01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ksf.ksf01,SQLCA.sqlcode,0)
        INITIALIZE g_ksf.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flksf
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ksf.* FROM ksf_file       # 重讀DB,因TEMP有不被更新特性
     WHERE ksf01 = g_ksf.ksf01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ksf.ksf01,SQLCA.sqlcode,1)   #No.FUN-660128
       CALL cl_err3("sel","ksf_file",g_ksf.ksf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
       INITIALIZE g_ksf.* TO NULL 
    ELSE
       LET g_data_owner = g_ksf.ksfuser      #FUN-4C0035
       LET g_data_group = ''                 #FUN-4C0035
       CALL i500_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i500_show()
    DEFINE l_smydesc   LIKE smy_file.smydesc        #No.FUN-680121 VARCHAR(20)
    LET g_ksf_t.* = g_ksf.*
    DISPLAY BY NAME
           g_ksf.ksf01,g_ksf.ksf02,g_ksf.ksf05,g_ksf.ksf08,g_ksf.ksf10,g_ksf.ksfconf,g_ksf.ksfmksg,g_ksf.ksf09, #FUN-670103  #FUN-B60116 add ksf10,ksfmksg,ksf09
           g_ksf.ksfuser,g_ksf.ksfdate,g_ksf.ksfmodu,g_ksf.ksfmodd,g_ksf.ksforiu #TQC-B60037add ksforiu
 
    #--No.FUN-560135
       LET g_t1 = s_get_doc_no(g_ksf.ksf01)     
       SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip=g_t1
       DISPLAY l_smydesc TO smydesc
    #--end
    SELECT gem02 INTO g_buf FROM gem_file WHERE gem01=g_ksf.ksf08 #FUN-670103
    DISPLAY g_buf TO gem02
    CALL i500_ksf10()      #FUN-B60116 add
    CASE g_ksf.ksfconf
         WHEN 'Y'   LET g_confirm = 'Y'
                    LET g_void = ''
         WHEN 'N'   LET g_confirm = 'N'
                    LET g_void = ''
         WHEN 'X'   LET g_confirm = ''
                    LET g_void = 'Y'
      OTHERWISE     LET g_confirm = ''
                    LET g_void = ''
    END CASE
    #圖形顯示
    CALL cl_set_field_pic(g_confirm,"","","",g_void,'')
 
    CALL i500_b_fill(g_wc2)
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i500_u()
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_ksf.ksf01) THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_ksf.ksfconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_ksf.ksfconf = 'X'   THEN CALL cl_err('','9024',0) RETURN END IF
   #FUN-B60116 add str---
    IF g_ksf.ksf09 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
   #FUN-B60116 add end---

   #MESSAGE ""                                   #FUN-B60116 mark
    CALL cl_msg("")                              #FUN-B60116 add
    CALL cl_opmsg('u')
    BEGIN WORK
 
    OPEN i500_cl USING g_ksf.ksf01
    IF STATUS THEN
       CALL cl_err("OPEN i500_cl:", STATUS, 1)
       CLOSE i500_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i500_cl INTO g_ksf.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ksf.ksf01,SQLCA.sqlcode,0) 
       CLOSE i500_cl
       ROLLBACK WORK
       RETURN
    END IF
    LET g_ksf01_t = g_ksf.ksf01
    LET g_ksf_o.*=g_ksf.*
    LET g_ksf.ksfmodu = g_user
    LET g_ksf.ksfmodd = g_today                  #修改日期
    CALL i500_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i500_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ksf.*=g_ksf_t.*
            CALL i500_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_ksf.ksf09 = '0'                 #FUN-B60116 add
        UPDATE ksf_file SET ksf_file.* = g_ksf.*    # 更新DB
            WHERE ksf01 = g_ksf_t.ksf01             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ksf.ksf01,SQLCA.sqlcode,0)   #No.FUN-660128
            CALL cl_err3("upd","ksf_file",g_ksf01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
 
    CLOSE i500_cl
    DISPLAY BY NAME g_ksf.ksf09  #FUN-B60116 add
    COMMIT WORK
#   CALL i500_list_fill()    #FUN-CB0014
    CALL cl_flow_notify(g_ksf.ksf01,'U')
 
END FUNCTION
 
FUNCTION i500_r()
    DEFINE l_chr   LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
           l_cnt   LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_ksf.ksf01) THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_ksf.ksfconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_ksf.ksfconf = 'X'   THEN CALL cl_err('','9024',0) RETURN END IF
   #FUN-B60116 add str---
    IF g_ksf.ksf09 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
   #FUN-B60116 add end---

  # SELECT count(*) INTO l_cnt FROM sfb_file WHERE sfb222= g_ksf.ksf01
  #No.B255 010515 mod by linda 
    SELECT count(*) INTO l_cnt FROM sfb_file WHERE sfb91= g_ksf.ksf01
    IF l_cnt > 0 THEN
       CALL cl_err(g_ksf.ksf01,'asf-330',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN i500_cl USING g_ksf.ksf01
    IF STATUS THEN
       CALL cl_err("OPEN i500_cl:", STATUS, 1)
       CLOSE i500_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i500_cl INTO g_ksf.*
    IF SQLCA.sqlcode THEN 
       CALL cl_err(g_ksf.ksf01,SQLCA.sqlcode,0)
       CLOSE i500_cl
       ROLLBACK WORK
       RETURN
    END IF 
    CALL i500_show()
    IF cl_delh(15,21) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ksf01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ksf.ksf01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        DELETE FROM ksf_file WHERE ksf01 =g_ksf.ksf01
        IF STATUS THEN 
  #       CALL cl_err('del ksf:',STATUS,0)  #No.FUN-660128
          CALL cl_err3("del","ksf_file",g_ksf.ksf01,"",STATUS,"","del ksf:",1)  #No.FUN-660128 
         RETURN END IF
 
        DELETE FROM ksg_file WHERE ksg01 = g_ksf.ksf01
        IF STATUS THEN
  #        CALL cl_err('del ksg:',STATUS,0)  #No.FUN-660128
           CALL cl_err3("del","ksg_file",g_ksf.ksf01,"",STATUS,"","del ksg:",1)  #No.FUN-660128
         RETURN END IF
 
        INITIALIZE g_ksf.* TO NULL
        CLEAR FORM
        CALL g_ksg.clear()
        OPEN i500_count
        #FUN-B50064-add-start--
        IF STATUS THEN
           CLOSE i500_cs
           CLOSE i500_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50064-add-end-- 
        FETCH i500_count INTO g_row_count
        #FUN-B50064-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE i500_cs
           CLOSE i500_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50064-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN i500_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i500_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL i500_fetch('/')
        END IF
    END IF
 
    CLOSE i500_cl
    COMMIT WORK
    CALL cl_flow_notify(g_ksf.ksf01,'D')
#   CALL i500_list_fill()     #FUN-CB0014
 
END FUNCTION
 
   
FUNCTION i500_b(p_mod_seq)
DEFINE
    p_mod_seq       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1) #修改次數 (0表開狀)
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680121 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680121 SMALLINT
    l_i             LIKE type_file.num5,          #TQC-B60039   
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680121 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680121 VARCHAR(1)
    l_sfb38         LIKE type_file.dat,           #No.FUN-680121 DATE
    l_jump          LIKE type_file.num5,          #No.FUN-680121 #判斷是否跳過AFTER ROW的處理
#   l_sgt05         LIKE ima_file.ima26,          #No.FUN-680121 DEC(15,3)
#   l_sksg05        LIKE ima_file.ima26,          #No.FUN-680121 DEC(15,3)
    l_sgt05         LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
    l_sksg05        LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
    l_weeks         LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    l_years         LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    l_date1,l_date2 LIKE type_file.dat,           #No.FUN-680121 DATE
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680121 SMALLINT
#MOD-B80163 --begin--
DEFINE l_ima56      LIKE ima_file.ima56
DEFINE l_ima561     LIKE ima_file.ima561
DEFINE l_qty1       LIKE ksg_file.ksg05
DEFINE l_qty2       LIKE ima_file.ima56
#MOD-B80163 --end--
DEFINE l_ksf09_FLAG  LIKE type_file.chr1       #FUN-C30293  #判斷執行單身並確定才將狀況碼改為0:已開立(FLAG=Y)，放棄則不改變狀況碼(FLAG=N)
 
    LET g_action_choice = ""
    LET l_ksf09_FLAG = 'Y'  #FUN-C30293
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_ksf.ksf01) THEN RETURN END IF
 
    IF p_mod_seq='0' THEN
       IF g_ksf.ksfconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    END IF
    IF g_ksf.ksfconf = 'X'   THEN CALL cl_err('','9024',0) RETURN END IF
   #FUN-B60116 add str---
    IF g_ksf.ksf09 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
   #FUN-B60116 add end---
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = 
        "SELECT ksg02,ksg03,'','','',ksg04,ksg07,ksg05,0,0,ksg09,ksg11,ksg930,'' ", #FUN-670103
        " FROM ksg_file",
        " WHERE ksg01= ? AND ksg02= ? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i500_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ksg WITHOUT DEFAULTS FROM s_ksg.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL i500_set_no_entry_b('N',p_mod_seq)
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN i500_cl USING g_ksf.ksf01
            IF STATUS THEN
               CALL cl_err("OPEN i500_cl:", STATUS, 1)
               CLOSE i500_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i500_cl INTO g_ksf.*               # 對DB鎖定
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ksf.ksf01,SQLCA.sqlcode,0) 
               CLOSE i500_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            CALL i500_set_entry_b()
 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_ksg_t.* = g_ksg[l_ac].*  #BACKUP
                OPEN i500_bcl USING g_ksf.ksf01,g_ksg_t.ksg02
                IF STATUS THEN
                   CALL cl_err("OPEN i500_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE 
                   FETCH i500_bcl INTO g_ksg[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_ksg_t.ksg02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   LET g_ksg[l_ac].sfb08 = g_ksg_t.sfb08
                   LET g_ksg[l_ac].sfv09 = g_ksg_t.sfv09
                   CALL i500_ksg03('d')
                   LET g_ksg[l_ac].gem02c=s_costcenter_desc(g_ksg[l_ac].ksg930) #FUN-670103
                END IF
                CALL i500_set_no_entry_b(g_ksg[l_ac].ksg09,p_mod_seq)
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            IF l_ac <= l_n THEN                   #DISPLAY NEWEST
                CALL i500_ksg03('d')
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET l_ksf09_FLAG = 'N'  #FUN-C3029
               CANCEL INSERT
            END IF
 
            INSERT INTO ksg_file
                   (ksg01,ksg02,ksg03,ksg04,ksg05,ksg09,ksg11,ksg07,ksg930, #FUN-670103
                    ksgplant,ksglegal) #FUN-980008 add
             VALUES(g_ksf.ksf01,g_ksg[l_ac].ksg02,g_ksg[l_ac].ksg03,
                    g_ksg[l_ac].ksg04,g_ksg[l_ac].ksg05,g_ksg[l_ac].ksg09,
                    g_ksg[l_ac].ksg11,g_ksg[l_ac].ksg07,g_ksg[l_ac].ksg930, #FUN-670103
                    g_plant,g_legal)  #FUN-980008 add
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_ksg[l_ac].ksg02,SQLCA.sqlcode,0)   #No.FUN-660128
               CALL cl_err3("ins","ksg_file",g_ksf.ksf01,g_ksg[l_ac].ksg02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
               CANCEL INSERT
            ELSE
              #MESSAGE 'INSERT O.K'                                   #FUN-B60116 mark
               CALL cl_msg('INSERT O.K')                              #FUN-B60116 add
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ksg[l_ac].* TO NULL      #900423
            LET g_ksg[l_ac].ksg05 = 0
            LET g_ksg[l_ac].ksg09 = 'N'
            LET g_ksg[l_ac].ksg07 = g_today    #No:MOD-9C0041 add
            LET g_ksg[l_ac].ksg930=s_costcenter(g_ksf.ksf08) #FUN-670103
            LET g_ksg[l_ac].gem02c=s_costcenter_desc(g_ksg[l_ac].ksg930) #FUN-670103
            LET g_ksg_t.* = g_ksg[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ksg02
 
        BEFORE FIELD ksg02                        #default 序號
            IF g_ksg[l_ac].ksg02 IS NULL OR
               g_ksg[l_ac].ksg02 = 0 THEN
                SELECT max(ksg02)+1 INTO g_ksg[l_ac].ksg02
                   FROM ksg_file
                   WHERE ksg01 = g_ksf.ksf01
                IF g_ksg[l_ac].ksg02 IS NULL THEN
                    LET g_ksg[l_ac].ksg02 = 1
                END IF
            END IF
 
        AFTER FIELD ksg02                        #check 序號是否重複
            IF NOT cl_null(g_ksg[l_ac].ksg02) THEN
               IF g_ksg[l_ac].ksg02 != g_ksg_t.ksg02 OR
                  g_ksg_t.ksg02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM ksg_file
                    WHERE ksg01 = g_ksf.ksf01
                      AND ksg02 = g_ksg[l_ac].ksg02
                   IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      LET g_ksg[l_ac].ksg02 = g_ksg_t.ksg02
                      NEXT FIELD ksg02
                   END IF
               END IF
            END IF
            CALL i500_set_no_entry_b(g_ksg[l_ac].ksg09,p_mod_seq)
 
        BEFORE FIELD ksg03
display "AFTER FEILD ksg03_old:",g_ksg[l_ac].ksg03 
        AFTER FIELD ksg03
            IF NOT cl_null(g_ksg[l_ac].ksg03) THEN 
#FUN-AA0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(g_ksg[l_ac].ksg03,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_ksg[l_ac].ksg03= g_ksg_t.ksg03
                  NEXT FIELD ksg03
               END IF
#FUN-AA0059 ---------------------end-------------------------------
               IF NOT i500_bom_chk() THEN NEXT FIELD ksg03 END IF   #MOD-C30277 add
               CALL i500_ksg03('a')  
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_ksg[l_ac].ksg03=g_ksg_t.ksg03
                  NEXT FIELD ksg03
               END IF
              #CHI-980019--begin--add---- 
               IF NOT s_chkima08(g_ksg[l_ac].ksg03) THEN
                  NEXT FIELD CURRENT
               END IF 
               #CHI-980019--end--add--------
            END IF
#No.TQC-750041 -- begin --
        AFTER FIELD ksg05
#TQC-AB0146----mod----------str-----------------------------------------
#          IF NOT cl_null(g_ksg[l_ac].ksg05) AND g_ksg[l_ac].ksg05 < 0 THEN
#          
#             NEXT FIELD ksg05
#          END IF
           IF NOT cl_null(g_ksg[l_ac].ksg05) THEN
              IF g_ksg[l_ac].ksg05 < 0 OR g_ksg[l_ac].ksg05 = 0 THEN
                 CALL cl_err('','asf1018',0)
                 NEXT FIELD ksg05
              END IF
#MOD-B80163 --begin--
              IF NOT cl_null(g_ksg[l_ac].ksg03) THEN
                 SELECT ima56,ima561 INTO l_ima56,l_ima561 FROM ima_file
                  WHERE ima01 = g_ksg[l_ac].ksg03

                 IF l_ima561 > 0 THEN                           #生產單位批量&最少生產數量
                   IF g_ksg[l_ac].ksg05 < l_ima561 THEN
                      CALL cl_err('','asf-307',0)
                      NEXT FIELD ksg05
                   END IF
                 END IF

                 IF NOT cl_null(l_ima56) AND l_ima56>0  THEN   #生產單位批量
                    LET l_qty1 = g_ksg[l_ac].ksg05 * 1000
                    LET l_qty2 = l_ima56 * 1000
                    IF (l_qty1 MOD l_qty2) > 0 THEN
                       CALL cl_err('','asf-308',0)
                       NEXT FIELD ksg05
                    END IF
                 END IF

              END IF
#MOD-B80163 --end--

           END IF
#TQC-AB0146----mod--------end-------------
#No.TQC-750041 -- end --
 
         #FUN-670103...............begin
         AFTER FIELD ksg930 
            IF NOT s_costcenter_chk(g_ksg[l_ac].ksg930) THEN
               LET g_ksg[l_ac].ksg930=g_ksg_t.ksg930
               LET g_ksg[l_ac].gem02c=g_ksg_t.gem02c
               DISPLAY BY NAME g_ksg[l_ac].ksg930,g_ksg[l_ac].gem02c
               NEXT FIELD ksg930
            ELSE
               LET g_ksg[l_ac].gem02c=s_costcenter_desc(g_ksg[l_ac].ksg930)
               DISPLAY BY NAME g_ksg[l_ac].gem02c
            END IF
         #FUN-670103...............end
 
        BEFORE DELETE                            #是否取消單身
            IF g_ksg_t.ksg02 > 0 AND g_ksg_t.ksg02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                # genero shell add end
                DELETE FROM ksg_file
                 WHERE ksg01 = g_ksf.ksf01
                   AND ksg02 = g_ksg_t.ksg02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_ksg_t.ksg02,SQLCA.sqlcode,0)   #No.FUN-660128
                    CALL cl_err3("del","ksg_file",g_ksf.ksf01,g_ksg_t.ksg02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                COMMIT WORK
                CALL i500_b_tot()
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET l_ksf09_FLAG = 'N'  #FUN-C30293
               LET g_ksg[l_ac].* = g_ksg_t.*
               CLOSE i500_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ksg[l_ac].ksg02,-263,1)
               LET g_ksg[l_ac].* = g_ksg_t.*
            ELSE
               UPDATE ksg_file SET ksg02=g_ksg[l_ac].ksg02,
                                   ksg03=g_ksg[l_ac].ksg03,
                                   ksg04=g_ksg[l_ac].ksg04,
                                   ksg05=g_ksg[l_ac].ksg05,
                                   ksg11=g_ksg[l_ac].ksg11,
                                   ksg07=g_ksg[l_ac].ksg07,
                                   ksg09=g_ksg[l_ac].ksg09,
                                   ksg930=g_ksg[l_ac].ksg930 #FUN-670103
                WHERE ksg01=g_ksf.ksf01
                  AND ksg02=g_ksg_t.ksg02
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_ksg[l_ac].ksg02,SQLCA.sqlcode,0)   #No.FUN-660128
                   CALL cl_err3("upd","ksg_file",g_ksf.ksf01,g_ksg_t.ksg02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                   LET g_ksg[l_ac].* = g_ksg_t.*
               ELSE
                  #MESSAGE 'INSERT O.K'                                   #FUN-B60116 mark
                   CALL cl_msg('INSERT O.K')                              #FUN-B60116 add
                   COMMIT WORK
               END IF
               CALL i500_b_tot()
            END IF
display "ON ROW CHANGE ok"
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET l_ksf09_FLAG = 'N'  #FUN-C30293
               IF p_cmd='u' THEN
                  LET g_ksg[l_ac].* = g_ksg_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_ksg.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i500_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D40030 Add
            CALL i500_b_tot()
            CLOSE i500_bcl
            COMMIT WORK

         #TQC-B60039--add--str--
         AFTER INPUT 
            FOR l_i = 1 TO g_rec_b
                IF NOT cl_null(g_ksg[l_i].ksg05) THEN
                   IF g_ksg[l_i].ksg05 = 0 THEN
                      LET l_ac = l_i
                      CALL cl_err('','asf1018',0)
                      CALL fgl_set_arr_curr(l_ac)
                      NEXT FIELD ksg05
                   END IF
                END IF
            END FOR
         #TQC-B60039--add--end-- 

#NO.FUN-6B0031--BEGIN                                                                                           
      ON ACTION controls                                                                                    
       CALL cl_set_head_visible("","AUTO")                                                          
#NO.FUN-6B0031--END     
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
           CASE WHEN INFIELD(ksg03)
#FUN-AA0059---------mod------------str-----------------           
#                     CALL cl_init_qry_var()
#                    #LET g_qryparam.form     = "q_ima" #MOD-640193
#                     LET g_qryparam.form     = "q_ima18" #MOD-640193
#                     LET g_qryparam.default1 = g_ksg[l_ac].ksg03
#                     CALL cl_create_qry() RETURNING g_ksg[l_ac].ksg03
                      CALL q_sel_ima(FALSE, "q_ima51","",g_ksg[l_ac].ksg03,"","","","","",'' )   #MOD-C70233 q_ima18->q_imq51
                        RETURNING  g_ksg[l_ac].ksg03
#FUN-AA0059---------mod------------end-----------------
#                     CALL FGL_DIALOG_SETBUFFER( g_ksg[l_ac].ksg03 )
                      DISPLAY BY NAME g_ksg[l_ac].ksg03   #No.MOD-490371
                     NEXT FIELD ksg03
                #FUN-670103...............begin
                WHEN INFIELD(ksg930)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gem4"
                   CALL cl_create_qry() RETURNING g_ksg[l_ac].ksg930
                   DISPLAY BY NAME g_ksg[l_ac].ksg930
                   NEXT FIELD ksg930
                #FUN-670103...............end 
            END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
    
    END INPUT
 
    #FUN-5B0113-begin
     LET g_ksf.ksfmodu = g_user
     LET g_ksf.ksfmodd = g_today
     IF l_ksf09_FLAG = 'Y' THEN  #FUN-C30293
        LET g_ksf.ksf09 = '0'                                  #FUN-B60116 add
     END IF  #FUN-C30293
     UPDATE ksf_file SET ksfmodu = g_ksf.ksfmodu,ksfmodd = g_ksf.ksfmodd,ksf09 = g_ksf.ksf09  #FUN-B60116 add ksf09
      WHERE ksf01 = g_ksf.ksf01
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#       CALL cl_err('upd ksf',SQLCA.SQLCODE,1)   #No.FUN-660128
        CALL cl_err3("upd","ksf_file",g_ksf01_t,"",SQLCA.sqlcode,"","upd ksf",1)  #No.FUN-660128
     END IF
     DISPLAY BY NAME g_ksf.ksfmodu,g_ksf.ksfmodd,g_ksf.ksf09  #FUN-B60116 add ksf09
    #FUN-5B0113-end
 
    CLOSE i500_bcl
    COMMIT WORK
    CALL i500_delHeader()     #CHI-C30002 add
END FUNCTION
   

#CHI-C30002 -------- add -------- begin
FUNCTION i500_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_ksf.ksf01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM ksf_file ",
                  "  WHERE ksf01 LIKE '",l_slip,"%' ",
                  "    AND ksf01 > '",g_ksf.ksf01,"'"
      PREPARE i500_pb1 FROM l_sql 
      EXECUTE i500_pb1 INTO l_cnt      
      
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
        #CALL i500_x()   #CHI-D20010
         CALL i500_x(1)  #CHI-D20010 
         CASE g_ksf.ksfconf
              WHEN 'Y'   LET g_confirm = 'Y'
                         LET g_void = ''
              WHEN 'N'   LET g_confirm = 'N'
                         LET g_void = ''
              WHEN 'X'   LET g_confirm = ''
                         LET g_void = 'Y'
           OTHERWISE     LET g_confirm = ''
                         LET g_void = ''
         END CASE
         #圖形顯示
         CALL cl_set_field_pic(g_confirm,"","","",g_void,'')
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM  ksf_file WHERE ksf01 = g_ksf.ksf01
         INITIALIZE g_ksf.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION i500_set_entry_b()
   
    CALL cl_set_comp_entry("ksg02,ksg03,ksg04,ksg07,ksg05,ksg09,ksg11",TRUE)
 
    IF INFIELD(ksg02) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("ksg02,ksg03,ksg04,ksg07,ksg05,ksg09,ksg11",TRUE)
    END IF
   
END FUNCTION
 
FUNCTION i500_set_no_entry_b(p_ksg09,p_mod_seq)
 DEFINE p_ksg09     LIKE ksg_file.ksg09
 DEFINE p_mod_seq   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF p_mod_seq='1' THEN 
      #CALL cl_set_comp_entry("ksg02,ksg03,ksg04,ksg07,ksg05,ksg11",FALSE)  #MOD-CC0186 mark
       CALL cl_set_comp_entry("ksg03,ksg04,ksg07,ksg05,ksg11",FALSE)        #MOD-CC0186
    ELSE 
       CALL cl_set_comp_entry("ksg09",FALSE)
    END IF
    
    IF p_ksg09='Y' THEN 
      #CALL cl_set_comp_entry("ksg02,ksg03,ksg04,ksg07,ksg05,ksg11",FALSE)  #MOD-CC0186 mark
       CALL cl_set_comp_entry("ksg03,ksg04,ksg07,ksg05,ksg11",FALSE)        #MOD-CC0186
    END IF 
 
END FUNCTION
 
FUNCTION i500_ksg03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    l_ima911        LIKE ima_file.ima911, #MOD-640193
    l_imaacti       LIKE ima_file.imaacti
 
    LET g_errno = ' '
        SELECT ima02,ima021,ima55,imaacti,ima911 #MOD-640193 add ima911
          INTO g_ksg[l_ac].ima02,g_ksg[l_ac].ima021,
               g_ksg[l_ac].ima55,l_imaacti,
               l_ima911 #MOD-640193
          FROM ima_file
         WHERE ima01=g_ksg[l_ac].ksg03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET g_ksg[l_ac].ima02 = NULL
                                   LET g_ksg[l_ac].ima021= NULL
                                   LET g_ksg[l_ac].ima55 = NULL
                                   LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'  #NO.FUN-690022
         WHEN l_ima911='Y'  LET g_errno = 'asr-040' #MOD-640193
                            LET g_ksg[l_ac].ima02 = NULL
                            LET g_ksg[l_ac].ima021= NULL
                            LET g_ksg[l_ac].ima55 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION 
   
FUNCTION i500_b_tot()
   SELECT SUM(ksg05) INTO ksg05t FROM ksg_file WHERE ksg01 = g_ksf.ksf01
   IF ksg05t IS NULL THEN LET ksg05t = 0 END IF
   DISPLAY BY NAME ksg05t
END FUNCTION
 
FUNCTION i500_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(200)
 
    CONSTRUCT g_wc2 ON ksg02,ksg03,ksg04,ksg07,ksg05,ksg11,ksg09
            FROM s_ksg[1].ksg02,s_ksg[1].ksg03,s_ksg[1].ksg04,
                 s_ksg[1].ksg07,s_ksg[1].ksg05,
                 s_ksg[1].ksg11,s_ksg[1].ksg09
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i500_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i500_b_fill(p_wc2)              #BODY FILL UP
DEFINE   p_wc2           LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(200)
DEFINE   l_imnnum        LIKE ade_file.ade05,        #No.FUN-680121 DEC(15,3)
         l_inbnum        LIKE ade_file.ade05         #No.FUN-680121 DEC(15,3)
DEFINE   l_rvv17         LIKE rvv_file.rvv17     #No.MOD-5B0269 add
DEFINE   l_rvv35         LIKE rvv_file.rvv35     #No.MOD-5B0269 add
DEFINE   l_factor        LIKE pml_file.pml09     #No.FUN-680121 DEC(16,8) #No.MOD-5B0269 add
DEFINE   l_cnt           LIKE type_file.num5                  #No.MOD-5B0269 add        #No.FUN-680121 SMALLINT
 
    IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF  #MOD-8B0049
 
    LET g_sql =
        "SELECT ksg02,ksg03,ima02,ima021,ima55,ksg04,ksg07,ksg05,0,0,ksg09,ksg11,ksg930,''", #FUN-670103
        " FROM ksg_file LEFT OUTER JOIN ima_file ON ksg03 = ima01",
        " WHERE ksg01 ='",g_ksf.ksf01,"'",
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
 
    PREPARE i500_pb FROM g_sql
    DECLARE ksg_curs CURSOR FOR i500_pb
 
    CALL g_ksg.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    LET ksg05t=0 
    LET sfb08t=0 
 
    FOREACH ksg_curs INTO g_ksg[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
        #-->已開工單數量
        SELECT SUM(sfb08) INTO g_ksg[g_cnt].sfb08
           FROM sfb_file
           WHERE sfb91=g_ksf.ksf01 AND sfb92=g_ksg[g_cnt].ksg02
             AND sfb05=g_ksg[g_cnt].ksg03 AND sfb87!='X'    #No:7055
        IF cl_null(g_ksg[g_cnt].sfb08) THEN LET g_ksg[g_cnt].sfb08 = 0 END IF
 
        #-->入庫量
        SELECT SUM(sfv09) INTO g_ksg[g_cnt].sfv09  
           FROM sfb_file,sfv_file,sfu_file
         # WHERE sfb222= g_ksf.ksf01  
         #   AND sfb223= g_ksg[g_cnt].ksg02
           WHERE sfb91= g_ksf.ksf01  
             AND sfb92= g_ksg[g_cnt].ksg02
             AND sfv04 = g_ksg[g_cnt].ksg03
             AND sfb01 = sfv11
             AND sfu01 = sfv01
             AND sfupost= 'Y'
        IF cl_null(g_ksg[g_cnt].sfv09) THEN LET g_ksg[g_cnt].sfv09 = 0 END IF
      #---------------------No.MOD-5B0269 begin-------------------------
        LET g_rvv17 = 0
        DECLARE i500_c2 CURSOR FOR
           SELECT rvv17,rvv35
              FROM sfb_file,rvv_file,rvu_file
              WHERE sfb91= g_ksf.ksf01
                AND sfb92= g_ksg[g_cnt].ksg02
                AND rvv31 = g_ksg[g_cnt].ksg03
                AND rvv03 = '1'
                AND sfb01 = rvv18
                AND rvu01 = rvv01
                AND rvuconf= 'Y'
                AND sfb02 ='7'    #MOD-CB0080 add
        FOREACH i500_c2 INTO l_rvv17,l_rvv35
          IF STATUS THEN EXIT FOREACH END IF
          IF cl_null(l_rvv17) THEN LET l_rvv17 = 0 END IF
          CALL s_umfchk(g_ksg[g_cnt].ksg03,l_rvv35,g_ksg[g_cnt].ima55)
               RETURNING l_cnt,l_factor
          IF l_cnt = 1 THEN LET l_factor=1 END IF
          LET l_rvv17 = l_rvv17 * l_factor
          LET g_rvv17 = g_rvv17 + l_rvv17
        END FOREACH
        LET g_ksg[g_cnt].sfv09 = g_ksg[g_cnt].sfv09 + g_rvv17
    #----------------------No.MOD-5B0269 end --------------------------
 
        LET ksg05t=ksg05t+g_ksg[g_cnt].ksg05
        LET sfb08t=sfb08t+g_ksg[g_cnt].sfb08
        LET g_ksg[g_cnt].gem02c=s_costcenter_desc(g_ksg[g_cnt].ksg930) #FUN-670103
        LET g_cnt = g_cnt + 1
 
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_ksg.deleteElement(g_cnt)
    LET g_rec_b=(g_cnt-1)
 
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
    DISPLAY BY NAME ksg05t
    DISPLAY BY NAME sfb08t
 
END FUNCTION
 
FUNCTION i500_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ksg TO s_ksg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ON ACTION page_info                 #FUN-CB0014 add
         LET g_action_flag = "page_info"  #FUN-CB0014 add
         EXIT DISPLAY                     #FUN-CB0014 add
#NO.FUN-6B0031--BEGIN                                                                                           
      ON ACTION controls                                                                                    
         CALL cl_set_head_visible("","AUTO")                                                          
#NO.FUN-6B0031--END     
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
         CALL i500_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL i500_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL i500_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL i500_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL i500_fetch('L')
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
            CASE g_ksf.ksfconf
                 WHEN 'Y'   LET g_confirm = 'Y'
                            LET g_void = ''
                 WHEN 'N'   LET g_confirm = 'N'
                            LET g_void = ''
                 WHEN 'X'   LET g_confirm = ''
                            LET g_void = 'Y'
              OTHERWISE     LET g_confirm = ''
                            LET g_void = ''
            END CASE
            #圖形顯示
            CALL cl_set_field_pic(g_confirm,"","","",g_void,'')
 
      ON ACTION exit 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      ON ACTION detail_close
         LET g_action_choice="detail_close"
         EXIT DISPLAY
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY

      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end
 
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
   
#FUN-4B0011
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0164  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY

      #FUN-B60116 add str---
    #@ON ACTION 簽核狀況
      ON ACTION approval_status
         LET g_action_choice="approval_status"
         EXIT DISPLAY
            
    #@ON ACTION easyflow送簽
      ON ACTION easyflow_approval
         LET g_action_choice = "easyflow_approval"
         EXIT DISPLAY

      ON ACTION agree
         LET g_action_choice = 'agree'
         EXIT DISPLAY
 
      ON ACTION deny
         LET g_action_choice = 'deny'
         EXIT DISPLAY
 
      ON ACTION modify_flow
         LET g_action_choice = 'modify_flow'
         EXIT DISPLAY
 
      ON ACTION withdraw
         LET g_action_choice = 'withdraw'
         EXIT DISPLAY
 
      ON ACTION org_withdraw
         LET g_action_choice = 'org_withdraw'
         EXIT DISPLAY
 
      ON ACTION phrase
         LET g_action_choice = 'phrase'
         EXIT DISPLAY
      #FUN-B60116 add end---
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
##
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#FUN-B60116 mark str--- 
#FUNCTION i500_y()
#    DEFINE ans          LIKE type_file.num5,         #No.FUN-680121 SMALLINT
#           l_cnt        LIKE type_file.num5          #No.FUN-680121 SMALLINT
# 
#    IF s_shut(0) THEN RETURN END IF
#    IF g_ksf.ksf01 IS NULL THEN RETURN END IF
#    SELECT * INTO g_ksf.* FROM ksf_file WHERE ksf01 = g_ksf.ksf01
#    IF g_ksf.ksfconf='Y' THEN RETURN END IF
#    IF g_ksf.ksfconf = 'X'   THEN CALL cl_err('','9024',0) RETURN END IF
##bugno:7338 add.................................................
#    SELECT COUNT(*) INTO l_cnt FROM ksg_file WHERE ksg01 = g_ksf.ksf01
#    IF l_cnt = 0 THEN 
#       CALL cl_err('','mfg-009',0)
#       RETURN 
#    END IF 
##bugno:7338 end.................................................
#    
#    IF NOT cl_confirm('axm-108') THEN RETURN END IF
# 
#    BEGIN WORK 
# 
#      OPEN i500_cl USING g_ksf.ksf01
#      IF STATUS THEN
#         CALL cl_err("OPEN i500_cl:", STATUS, 1)
#         CLOSE i500_cl
#         ROLLBACK WORK
#         RETURN
#      END IF
#      FETCH i500_cl INTO g_ksf.*               # 對DB鎖定
#      IF SQLCA.sqlcode THEN
#         CALL cl_err(g_ksf.ksf01,SQLCA.sqlcode,0) 
#         CLOSE i500_cl
#         ROLLBACK WORK
#         RETURN
#      END IF
# 
#      LET g_success = 'Y'
#      UPDATE ksf_file SET ksfconf = 'Y' WHERE ksf01 = g_ksf.ksf01
#      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
##        CALL cl_err('upd ksfconf',STATUS,1)   #No.FUN-660128
#         CALL cl_err3("upd","ksf_file",g_ksf01_t,"",STATUS,"","upd ksfconf",1)  #No.FUN-660128
#         LET g_success = 'N'
#         RETURN
#      END IF
#      IF g_success = 'Y' THEN
#        LET g_ksf.ksfconf='Y' 
#        COMMIT WORK
#        CALL cl_flow_notify(g_ksf.ksf01,'Y')
#        DISPLAY BY NAME g_ksf.ksfconf 
#      ELSE 
#        LET g_ksf.ksfconf='N'
#        ROLLBACK WORK
#      END IF
#END FUNCTION
#FUN-B60116 mark end---

#FUN-B60116 add str--- 
FUNCTION i500_y_chk()
    DEFINE ans          LIKE type_file.num5,         #No.FUN-680121 SMALLINT
           l_cnt        LIKE type_file.num5          #No.FUN-680121 SMALLINT
    DEFINE l_gem01      LIKE gem_file.gem01          #TQC-C60207 

    LET g_success = 'Y' 
    IF s_shut(0) THEN RETURN END IF
    IF g_ksf.ksf01 IS NULL THEN RETURN END IF
#CHI-C30107 ------------- add ------------- begin
    IF g_ksf.ksfconf = 'Y' THEN
       CALL cl_err('','9023',0)
       LET g_success = 'N'
       RETURN
    END IF
    IF g_ksf.ksfconf = 'X' THEN
       CALL cl_err('','9024',0)
       LET g_success = 'N'
       RETURN
    END IF
    IF g_action_choice CLIPPED = "confirm" OR g_action_choice CLIPPED = "insert" THEN
       IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF
    END IF
#CHI-C30107 ------------- add ------------- end
    SELECT * INTO g_ksf.* FROM ksf_file WHERE ksf01 = g_ksf.ksf01
    IF g_ksf.ksfconf = 'Y' THEN 
       CALL cl_err('','9023',0)
       LET g_success = 'N'
       RETURN 
    END IF
    IF g_ksf.ksfconf = 'X' THEN 
       CALL cl_err('','9024',0) 
       LET g_success = 'N'
       RETURN 
    END IF

#TQC-C60207 --------------------Begin----------------------
    IF NOT cl_null(g_ksf.ksf08) THEN
       SELECT gem01 INTO l_gem01 FROM gem_file
        WHERE gem01 = g_ksf.ksf08
          AND gemacti = 'Y'
       IF STATUS THEN     
          CALL cl_err(g_ksf.ksf08,'asf-683',0)
          LET g_success = 'N'
          RETURN
       END IF
    END IF
#TQC-C60207 --------------------End------------------------
#TQC-C80179 --------------------Begin----------------------
    IF NOT cl_null(g_ksf.ksf10) THEN
       CALL i500_ksf10()
       IF NOT cl_null(g_errno) THEN
          CALL cl_err(g_ksf.ksf10,g_errno,0)
          LET g_success = 'N'
          RETURN
       END IF
    END IF
#TQC-C80179 --------------------End------------------------

   #bugno:7338 add.................................................
    SELECT COUNT(*) INTO l_cnt FROM ksg_file WHERE ksg01 = g_ksf.ksf01
    IF l_cnt = 0 THEN 
       CALL cl_err('','mfg-009',0)
       LET g_success = 'N'
       RETURN 
    END IF 
   #bugno:7338 end.................................................
    
END FUNCTION
 
FUNCTION i500_y_upd()
    LET g_success = 'Y'
    IF g_action_choice CLIPPED = "confirm" OR g_action_choice CLIPPED = "insert" THEN      #按「確認」時
       IF g_ksf.ksfmksg='Y' THEN
          IF g_ksf.ksf09 != '1' THEN
             CALL cl_err('','aws-078',1)
             LET g_success = 'N'
             RETURN
          END IF
       END IF
#      IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
    END IF
    BEGIN WORK 
 
    IF g_argv2 = "efconfirm" THEN
       LET g_forupd_sql = "SELECT * FROM ksf_file WHERE ksf01 = ? FOR UPDATE"
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       DECLARE i500_ef_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
       OPEN i500_ef_cl USING g_ksf.ksf01
       IF STATUS THEN
          LET g_success = 'N'
          CALL cl_err("OPEN i500_ef_cl:", STATUS, 1)
          CLOSE i500_ef_cl
          ROLLBACK WORK
          RETURN
       END IF
       FETCH i500_ef_cl INTO g_ksf.*               # 對DB鎖定
       IF SQLCA.sqlcode THEN
          LET g_success = 'N'
          CALL cl_err(g_ksf.ksf01,SQLCA.sqlcode,0)
          CLOSE i500_ef_cl
          ROLLBACK WORK
          RETURN
       END IF
    ELSE
    OPEN i500_cl USING g_ksf.ksf01
    IF STATUS THEN
       LET g_success = 'N'
       CALL cl_err("OPEN i500_cl:", STATUS, 1)
       CLOSE i500_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i500_cl INTO g_ksf.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       LET g_success = 'N'
       CALL cl_err(g_ksf.ksf01,SQLCA.sqlcode,0) 
       CLOSE i500_cl
       ROLLBACK WORK
       RETURN
    END IF
    END IF  
    LET g_success = 'Y'
    UPDATE ksf_file SET ksfconf = 'Y',ksf09 = '1' WHERE ksf01 = g_ksf.ksf01
    IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      #CALL cl_err('upd ksfconf',STATUS,1)   #No.FUN-660128
       CALL cl_err3("upd","ksf_file",g_ksf01_t,"",STATUS,"","upd ksfconf",1)  #No.FUN-660128
       LET g_success = 'N'
       RETURN
    END IF
    IF g_success = 'Y' THEN
       IF g_ksf.ksfmksg = 'Y' THEN
          CASE aws_efapp_formapproval()
                WHEN 0  #呼叫 EasyFlow 簽核失敗
                     LET g_ksf.ksfconf = "N"
                     LET g_success = "N"
                     ROLLBACK WORK
                     RETURN
                WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                     LET g_ksf.ksfconf = "N"
                     ROLLBACK WORK
                     RETURN
           END CASE
       END IF
       IF g_success = 'Y' THEN
          LET g_ksf.ksf09 = '1'
          LET g_ksf.ksfconf = 'Y'
          DISPLAY BY NAME g_ksf.ksf09
          DISPLAY BY NAME g_ksf.ksfconf
          COMMIT WORK
          CALL cl_flow_notify(g_ksf.ksf01,'Y')
       ELSE 
         LET g_ksf.ksfconf='N'
         LET g_success = 'N'
         ROLLBACK WORK
       END IF
    ELSE 
      LET g_ksf.ksfconf='N'
      LET g_success = 'N'
      ROLLBACK WORK
    END IF
END FUNCTION
#FUN-B60116 add end--- 
 
   
FUNCTION i500_z()
    DEFINE ans  LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_ksf.* FROM ksf_file WHERE ksf01 = g_ksf.ksf01
    IF g_ksf.ksfconf='N' THEN RETURN END IF
    IF g_ksf.ksfconf = 'X'   THEN CALL cl_err('','9024',0) RETURN END IF
    IF NOT cl_confirm('axm-109') THEN RETURN END IF
   #FUN-B60116 add str---
    IF g_ksf.ksf09 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
   #FUN-B60116 add end---

    BEGIN WORK 
 
 
    OPEN i500_cl USING g_ksf.ksf01
    IF STATUS THEN
       CALL cl_err("OPEN i500_cl:", STATUS, 1)
       CLOSE i500_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i500_cl INTO g_ksf.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ksf.ksf01,SQLCA.sqlcode,0) 
       CLOSE i500_cl
       ROLLBACK WORK
       RETURN
    END IF
 
      LET g_success = 'Y'
      SELECT COUNT(*) INTO g_cnt FROM ksg_file,sfb_file 
         WHERE sfb91=ksg01 AND sfb92=ksg02
           AND ksg01=g_ksf.ksf01            
           AND sfb87 != 'X'           #MOD-AC0241 add
      IF g_cnt>0 THEN 
         CALL cl_err(g_ksf.ksf01,'asf-906',0)
         LET g_success='N' 
      END IF
      IF g_success = 'Y' THEN
         LET g_ksf.ksfconf='N'
         LET g_ksf.ksf09 = '0'   #FUN-B60116 add
         UPDATE ksf_file SET ksfconf = 'N', ksf09 = '0' WHERE ksf01 = g_ksf.ksf01  #FUN-B60116 add ksf09
         COMMIT WORK
         DISPLAY BY NAME g_ksf.ksfconf,g_ksf.ksf09  #FUN-B60116 add ksf09 
      ELSE 
         LET g_ksf.ksfconf='Y'
         LET g_ksf.ksf09 = '1'  #FUN-B60116 add
         ROLLBACK WORK
      END IF
END FUNCTION
 
#No.B255 010515 by linda add 報表功能
FUNCTION i500_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    l_rvv17         LIKE rvv_file.rvv17,   #No.MOD-5B0269 add
    l_rvv35         LIKE rvv_file.rvv35,   #No.MOD-5B0269 add
    l_factor        LIKE pml_file.pml09,   #No.FUN-680121 DEC(16,8) #No.MOD-5B0269 add
    l_cnt           LIKE type_file.num5,                #No.MOD-5B0269 add        #No.FUN-680121 SMALLINT
    l_sql           STRING,                #NO.FUN-830152 
    l_wc            STRING,                #No.MOD-930306 add
    sr              RECORD
        ksf01       LIKE ksf_file.ksf01,   #製造單單號
        ksf02       LIKE ksf_file.ksf02,   #項次
        ksf05       LIKE ksf_file.ksf05,   #
        ksg02       LIKE ksg_file.ksg02,   #
        ksg03       LIKE ksg_file.ksg03,   #
        ksg04       LIKE ksg_file.ksg04,   #
        ksg05       LIKE ksg_file.ksg05,   #
        ksg07       LIKE ksg_file.ksg07,   #
        ksg09       LIKE ksg_file.ksg09,   #
        ksg11       LIKE ksg_file.ksg11,   #
        ima02       LIKE ima_file.ima02,   #
        ima021      LIKE ima_file.ima021,  #NO.FUN-990078
        ima55       LIKE ima_file.ima55,   #
        sfb08       LIKE sfb_file.sfb08,   #己開工單
        sfv09       LIKE sfv_file.sfv09    #入庫量
                    END RECORD,
        l_name      LIKE type_file.chr20         #No.FUN-680121 VARCHAR(20) #External(Disk) file name

     #FUN-BA0078 START
     DEFINE l_img_blob         LIKE type_file.blob
     DEFINE l_ii               INTEGER 
     DEFINE l_key              RECORD 
            v1                 LIKE rvu_file.rvu01
            END RECORD 
     #FUN-BA0078 END 
     
#   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'asfi500' #No:8462
#   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
    CALL cl_del_data(l_table)      #No.FUN-830152 
    
    LOCATE l_img_blob IN MEMORY      #FUN-BA0078 add   
 
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-830152   
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     IF cl_null(g_wc) THEN LET g_wc = " ksf01='",g_ksf.ksf01,"'" END IF  #No.MOD-530398
    LET g_sql =
        "SELECT ksf01,ksf02,ksf05,ksg02,ksg03,ksg04,ksg05,ksg07,ksg09,ksg11,",
        "       ima02,ima021,ima55,0,0 ", #NO.FUN-990078
   #    " FROM ksf_file,ksg_file LEFT OUTER ima_file ON ksg03 = ima01",  #No.TQC-9B0231
        " FROM ksf_file,ksg_file LEFT OUTER JOIN ima_file ON ksg03 = ima01",  #No.TQC-9B0231
        " WHERE ksf01=ksg01 ",
       #--------------No.MOD-930306 modify
       #"   AND ",g_wc CLIPPED,                     #單身
        "   AND ksf01 = '",g_ksf.ksf01,"'",                #單身
       #--------------No.MOD-930306 end
        " ORDER BY 1"
 
    PREPARE i500_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i500_co                         # SCROLL CURSOR
        CURSOR FOR i500_p1
 
#    CALL cl_outnam('asfi500') RETURNING l_name   #No.FUN-830152  
#    START REPORT i500_rep TO l_name              #No.FUN-830152  

    #FUN-BA0078  START
    LET g_sql =
        "SELECT ksf01",
        " FROM ksf_file,ksg_file LEFT OUTER JOIN ima_file ON ksg03 = ima01",  #No.TQC-9B0231
        " WHERE ksf01=ksg01 ",
        "   AND ksf01 = '",g_ksf.ksf01,"'",
        " ORDER BY ksf01"
 
    PREPARE i500_p4 FROM g_sql                
    DECLARE i500_cs4 CURSOR FOR i500_p4
    #FUN-BA0078  END
    
    FOREACH i500_co INTO sr.*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
        #-->已開工單數量
        SELECT SUM(sfb08) INTO sr.sfb08
           FROM sfb_file
           WHERE sfb91=sr.ksf01 AND sfb92=sr.ksg02
             AND sfb05=sr.ksg03 AND sfb87!='X'
        IF cl_null(sr.sfb08) THEN LET sr.sfb08 = 0 END IF
 
        #-->入庫量
        SELECT SUM(sfv09) INTO sr.sfv09  
           FROM sfb_file,sfv_file,sfu_file
           WHERE sfb91= sr.ksf01  
             AND sfb92= sr.ksg02
             AND sfv04 = sr.ksg03
             AND sfb01 = sfv11
             AND sfu01 = sfv01
             AND sfupost= 'Y'
        IF cl_null(sr.sfv09) THEN LET sr.sfv09 = 0 END IF
      #--------------------No.MOD-5B0269 begin----------------------
        LET g_rvv17 = 0
        DECLARE i500_c3 CURSOR FOR
           SELECT rvv17,rvv35
           FROM sfb_file,rvv_file,rvu_file
           WHERE sfb91= sr.ksf01
             AND sfb92= sr.ksg02
             AND rvv31 = sr.ksg03
             AND sfb01 = rvv18
             AND rvv03 = '1'
             AND rvu01 = rvv01
             AND rvuconf= 'Y'
             AND sfb02 ='7'    #MOD-CB0080 add
        FOREACH i500_c3 INTO l_rvv17,l_rvv35
          IF STATUS THEN EXIT FOREACH END IF
          IF cl_null(l_rvv17) THEN LET l_rvv17 = 0 END IF
          CALL s_umfchk(sr.ksg03,l_rvv35,sr.ima55)
               RETURNING l_cnt,l_factor
          IF l_cnt = 1 THEN LET l_factor=1 END IF
          LET l_rvv17 = l_rvv17 * l_factor
          LET g_rvv17 = g_rvv17 + l_rvv17
        END FOREACH
       #LET sr.sfv09 = sr.sfv09 + l_rvv17  #MOD-910028 mark
        LET sr.sfv09 = sr.sfv09 + g_rvv17  #MOD-910028
    #--------------------No.MOD-5B0269 end-----------------------
#No.FUN-830152---Begin                                                                                                              
#        OUTPUT TO REPORT i500_rep(sr.*)                                                                                            
         EXECUTE insert_prep USING sr.ksf01,sr.ksf02,sr.ksf05,sr.ksg02,sr.ksg03,                                                    
                                   sr.ksg04,sr.ksg05,sr.ksg07,sr.ksg09,sr.ksg11,                                                    
                                   sr.ima02,sr.ima021,sr.sfb08,sr.sfv09,"",l_img_blob,"N"  #FUN-BA0078 #NO.FUN-990078                                                             
#No.FUN-830152---End   
    END FOREACH
#No.FUN-830152---Begin
#    FINISH REPORT i500_rep
    IF g_zz05 = 'Y' THEN                                                                                                            
         CALL cl_wcchp(g_wc,'ksf01,ksf02,ksf08,ksf05,ksfconf,                                                                       
                              ksfuser,ksfdate,ksfmodu,ksfmodd,                                                                      
                              ksg02,ksg03,ksg04,ksg07,ksg05,ksg09,ksg11,ksg930 ')                                                   
             #RETURNING g_wc     #No.MOD-930306 mark                                                                                                        
              RETURNING l_wc     #No.MOD-930306 add                                                                                                   
      END IF                                                                                                                        
     #LET g_str=g_wc             #No.MOD-930306 mark                                                                                                                
      LET g_str=l_wc             #No.MOD-930306 add                                                                                                   
                                                                                                                                    
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED  

     #FUN-BA0078  START
     LET g_cr_table = l_table
     LET g_cr_gcx01 = "asmi300"
     LET g_cr_apr_key_f = "ksf01"

     LET l_ii = 1

     CALL g_cr_apr_key.clear()  

     FOREACH i500_cs4 INTO l_key.* 
       LET g_cr_apr_key[l_ii].v1 = l_key.v1
       LET l_ii = l_ii + 1 
     END FOREACH

     #FUN-BA0078  END  
     
     CALL cl_prt_cs3('asfi500','asfi500',l_sql,g_str)  
#    CLOSE i500_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#No.FUN-830152---End
END FUNCTION
#No.FUN-830152---Begin
#REPORT i500_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#   l_sw            LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#   l_i             LIKE type_file.num5,          #No.FUN-680121 SMALLINT
#   sr              RECORD
#       ksf01       LIKE ksf_file.ksf01,   #製造單單號
#       ksf02       LIKE ksf_file.ksf02,   #項次
#       ksf05       LIKE ksf_file.ksf05,   #
#       ksg02       LIKE ksg_file.ksg02,   #
#       ksg03       LIKE ksg_file.ksg03,   #
#       ksg04       LIKE ksg_file.ksg04,   #
#       ksg05       LIKE ksg_file.ksg05,   #
#       ksg07       LIKE ksg_file.ksg07,   #
#       ksg09       LIKE ksg_file.ksg09,   #
#       ksg11       LIKE ksg_file.ksg11,   #
#       ima02       LIKE ima_file.ima02,   #
#       ima55       LIKE ima_file.ima55,   #
#       sfb08       LIKE sfb_file.sfb08,   #己開工單
#       sfv09       LIKE sfv_file.sfv09    #入庫量
#                   END RECORD 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line   #No.MOD-580242
 
#   ORDER BY sr.ksf01,sr.ksg02
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED, pageno_total
#           PRINT ' '
#           PRINT g_dash
#           PRINT g_x[8] CLIPPED,sr.ksf01,"  ",
#                 g_x[9] CLIPPED,sr.ksf02,"  ",
#                 g_x[10] CLIPPED,sr.ksf05
#           PRINT " "
#           #FUN-5A0140-begin
#           # PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39] #No.MOD-530398
#           PRINTX name=H1 g_x[31],g_x[32]
#           PRINTX name=H2 g_x[41],g_x[40]
#           PRINTX name=H3 g_x[42],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39]
#           #FUN-5A0140-end
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       BEFORE GROUP OF sr.ksf01  
#           SKIP TO TOP OF PAGE
#      
#       ON EVERY ROW
#          #FUN-5A0140-begin
#          #PRINT COLUMN g_c[31],sr.ksg02 using "##&",
#          #      COLUMN g_c[32],sr.ksg03 CLIPPED,
#          #      COLUMN g_c[33],sr.ksg04 CLIPPED,
#          #      COLUMN g_c[34],sr.ksg07 CLIPPED,
#          #      COLUMN g_c[35],sr.ksg05 USING "--------------&",
#          #      COLUMN g_c[36],sr.sfb08 USING "--------------&",
#          #      COLUMN g_c[37],sr.sfv09 USING "--------------&",
#          #      COLUMN g_c[38],sr.ksg09 CLIPPED,
#          #      COLUMN g_c[39],sr.ksg11 CLIPPED   #--No.MOD-530398
#          PRINTX name=D1 COLUMN g_c[31],sr.ksg02 using "###&", #FUN-590118
#                        COLUMN g_c[32],sr.ksg03 CLIPPED
#          PRINTX name=D2 COLUMN g_c[40],sr.ima02
#          PRINTX name=D3 COLUMN g_c[33],sr.ksg04 CLIPPED,
#                        COLUMN g_c[34],sr.ksg07 CLIPPED,
#                        COLUMN g_c[35],sr.ksg05 USING "--------------&",
#                        COLUMN g_c[36],sr.sfb08 USING "--------------&",
#                        COLUMN g_c[37],sr.sfv09 USING "--------------&",
#                        COLUMN g_c[38],sr.ksg09 CLIPPED,
#                        COLUMN g_c[39],sr.ksg11 CLIPPED   #--No.MOD-530398
#          #FUN-5A0140-end 
 
#       AFTER GROUP OF sr.ksf01  #單據別
#           #FUN-5A0140-begin
#           #PRINT COLUMN g_c[34],g_x[11] CLIPPED,
#           PRINTX name=D3 COLUMN g_c[34],g_x[11] CLIPPED,
#           #FUN-5A0140-end
#                 COLUMN g_c[35],GROUP SUM(sr.ksg05) USING "--------------&",
#                 COLUMN g_c[36],GROUP SUM(sr.sfb08) USING "--------------&"
 
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           IF g_zz05 = 'Y' THEN         # 80:70,140,210      132:120,240
#              CALL cl_wcchp(g_wc,'ksf01,ksf02,ksf03,ksf04,ksf07,ksf09')
#                   RETURNING g_sql
#           #TQC-630166
#           {
#              IF g_sql[001,080] > ' ' THEN
#       	       PRINT column 10,     g_sql[001,070] CLIPPED END IF
#              IF g_sql[071,140] > ' ' THEN
#       	       PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
#              IF g_sql[141,210] > ' ' THEN
#       	       PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
#           }
#             CALL cl_prt_pos_wc(g_sql)
#           #END TQC-630166
#              PRINT g_dash
#           END IF
#           PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.B255 end----
#No.FUN-830152---End
#FUNCTION i500_x()   #CHI-D20010
FUNCTION i500_x(p_type)   #CHI-D20010
DEFINE l_flag    LIKE type_file.chr1  #CHI-D20010
DEFINE p_type    LIKE type_file.chr1  #CHI-D20010
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_ksf.ksf01) THEN CALL cl_err('',-400,0) RETURN END IF   #MOD-660086 add
  #FUN-B60116 add str---
   IF g_ksf.ksf09 matches '[Ss]' THEN
      CALL cl_err('','apm-030',0)
      RETURN
   END IF
  #FUN-B60116 add end---
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_ksf.ksfconf ='X' THEN RETURN END IF
   ELSE
      IF g_ksf.ksfconf <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end
   BEGIN WORK
   LET g_success='Y'
 
   OPEN i500_cl USING g_ksf.ksf01
   IF STATUS THEN
      CALL cl_err("OPEN i500_cl:", STATUS, 1)
      CLOSE i500_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i500_cl INTO g_ksf.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ksf.ksf01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE i500_cl
      ROLLBACK WORK
      RETURN
   END IF
   IF cl_null(g_ksf.ksf01) THEN CALL cl_err('',-400,0) RETURN END IF
   #-->確認不可作廢
   IF g_ksf.ksfconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_ksf.ksfconf = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
  #IF cl_void(0,0,g_ksf.ksfconf)   THEN   #CHI-D20010
   IF cl_void(0,0,l_flag)   THEN          #CHI-D20010
        LET g_chr=g_ksf.ksfconf  
       #IF g_ksf.ksfconf ='N' THEN  #CHI-D20010
        IF p_type = 1 THEN          #CHI-D20010
            LET g_ksf.ksfconf='X'
        ELSE
            LET g_ksf.ksfconf='N'
        END IF
        UPDATE ksf_file                
            SET ksfconf=g_ksf.ksfconf,
                ksfmodu=g_user,
                ksfdate=g_today
            WHERE ksf01  =g_ksf.ksf01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_ksf.ksfconf,SQLCA.sqlcode,0)   #No.FUN-660128
            CALL cl_err3("upd","ksf_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660128
            LET g_ksf.ksfconf=g_chr
        END IF
        DISPLAY BY NAME g_ksf.ksfconf   
   END IF 
   CLOSE i500_cl  
   COMMIT WORK
   CALL cl_flow_notify(g_ksf.ksf01,'V')
END FUNCTION

#FUN-B60116 add str---
FUNCTION i500_ef()
   CALL i500_y_chk()          #CALL 原確認的 check 段  
   IF g_success = "N" THEN
       RETURN
   END IF

   CALL aws_condition()      #判斷送簽資料
   IF g_success = 'N' THEN
       RETURN
   END IF
##########
# CALL aws_efcli2()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
##########

 IF aws_efcli2(base.TypeInfo.create(g_ksf),base.TypeInfo.create(g_ksg),'','','','')
 THEN
   LET g_success='Y'
   LET g_ksf.ksf09='S'
   DISPLAY BY NAME g_ksf.ksf09
 ELSE
   LET g_success='N'
 END IF
END FUNCTION
#FUN-B60116 add end---

#FUN-B60116 add str---
FUNCTION i500_ksf10()
DEFINE p_cmd      LIKE type_file.chr1,     
       l_gen02    LIKE gen_file.gen02,
       l_gen03    LIKE gen_file.gen03,   
       l_genacti  LIKE gen_file.genacti

    LET g_errno = ' '
    SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti   
      FROM gen_file
     WHERE gen01 = g_ksf.ksf10
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg1312'
                                LET l_gen02 = NULL
                                LET l_genacti = NULL
       WHEN l_genacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) THEN
       DISPLAY l_gen02 TO FORMONLY.gen02
    END IF
END FUNCTION

FUNCTION i500_refresh()
  DEFINE l_ksf RECORD LIKE ksf_file.*

  SELECT * INTO l_ksf.* FROM ksf_file WHERE ksf01=g_ksf.ksf01
  RETURN l_ksf.*
END FUNCTION

#FUN-B60116 add end---

#MOD-C30277--add--str--
FUNCTION i500_bom_chk()
DEFINE   l_cnt        LIKE type_file.num10         

   LET l_cnt =0 
   SELECT COUNT(*) INTO l_cnt FROM bma_file
    WHERE bma01=g_ksg[l_ac].ksg03 AND bmaacti='Y'
   IF l_cnt =0 THEN
      CALL cl_err(g_ksg[l_ac].ksg03,'abm-742',0)
      RETURN FALSE
   ELSE
      LET l_cnt =0 
      SELECT COUNT(*) INTO l_cnt FROM bma_file
      #WHERE (bma05 IS NULL OR bma05 >g_ksg[l_ac].ksg07)  #MOD-CA0114 mark
       WHERE  bma05 <= g_ksg[l_ac].ksg07                  #MOD-CA0114
         AND bma01 = g_ksg[l_ac].ksg03
      IF l_cnt =0 THEN                                    #MOD-CA0114 mod 
         CALL cl_err(g_ksg[l_ac].ksg03,'abm-005',0)
         RETURN FALSE
      END IF
   END IF

   RETURN TRUE
END FUNCTION
#MOD-C30277--add--end--
#FUN-CB0014---add---str---
FUNCTION i500_list_fill()
  DEFINE l_ksf01         LIKE oea_file.oea01
  DEFINE l_i             LIKE type_file.num10

    CALL g_ksf_l.clear()
    LET l_i = 1
    FOREACH i500_fill_cs INTO l_ksf01
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT ksf01,'',ksf02,ksf08,gem02,ksf10,gen02,ksf05,
              ksfconf,ksfmksg,ksf09
         INTO g_ksf_l[l_i].*
         FROM ksf_file
              LEFT OUTER JOIN gen_file ON ksf10 = gen01
              LEFT OUTER JOIN gem_file ON ksf08 = gem01
        WHERE ksf01=l_ksf01
       LET g_t1 = s_get_doc_no(l_ksf01)
       SELECT smydesc INTO g_ksf_l[l_i].smydesc FROM smy_file WHERE smyslip=g_t1
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN  
            CALL cl_err( '', 9035, 0 )
          END IF                             
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_t1 = NULL 
    LET g_rec_b1 = l_i - 1
    DISPLAY ARRAY g_ksf_l TO s_ksf.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY

END FUNCTION

FUNCTION i500_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ksf_l TO s_ksf.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL fgl_set_arr_curr(g_curs_index) 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         LET g_curs_index = l_ac1
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ON ACTION page_main
         LET g_action_flag = "page_main"
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET mi_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL i500_fetch('/')
         END IF
         CALL cl_set_comp_visible("page_info", FALSE)
         CALL cl_set_comp_visible("info", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_info", TRUE)
         CALL cl_set_comp_visible("info", TRUE)
         EXIT DISPLAY

      ON ACTION ACCEPT
         LET g_action_flag = "page_main"
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET mi_no_ask = TRUE
         CALL i500_fetch('/')
         CALL cl_set_comp_visible("info", FALSE)
         CALL cl_set_comp_visible("info", TRUE)
         CALL cl_set_comp_visible("page_info", FALSE) 
         CALL ui.interface.refresh()                 
         CALL cl_set_comp_visible("page_info", TRUE)    
         EXIT DISPLAY                     #FUN-CB0014 add
#NO.FUN-6B0031--BEGIN                                                                                           
      ON ACTION controls                                                                                    
         CALL cl_set_head_visible("","AUTO")                                                          
#NO.FUN-6B0031--END     
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
         CALL i500_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b1 != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL i500_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 04051s
           IF g_rec_b1 != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL i500_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b1 != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL i500_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b1 != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL i500_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b1 != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
#TQC-D10084---mark---str--- 
#     ON ACTION detail
#        LET g_action_choice="detail"
#        LET l_ac = 1
#        EXIT DISPLAY
#TQC-D10084---mark---end---
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            CASE g_ksf.ksfconf
                 WHEN 'Y'   LET g_confirm = 'Y'
                            LET g_void = ''
                 WHEN 'N'   LET g_confirm = 'N'
                            LET g_void = ''
                 WHEN 'X'   LET g_confirm = ''
                            LET g_void = 'Y'
              OTHERWISE     LET g_confirm = ''
                            LET g_void = ''
            END CASE
            #圖形顯示
            CALL cl_set_field_pic(g_confirm,"","","",g_void,'')
 
      ON ACTION exit 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      ON ACTION detail_close
         LET g_action_choice="detail_close"
         EXIT DISPLAY
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
#FUN-4B0011
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0164  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY

      #FUN-B60116 add str---
    #@ON ACTION 簽核狀況
      ON ACTION approval_status
         LET g_action_choice="approval_status"
         EXIT DISPLAY
            
    #@ON ACTION easyflow送簽
      ON ACTION easyflow_approval
         LET g_action_choice = "easyflow_approval"
         EXIT DISPLAY

      ON ACTION agree
         LET g_action_choice = 'agree'
         EXIT DISPLAY
 
      ON ACTION deny
         LET g_action_choice = 'deny'
         EXIT DISPLAY
 
      ON ACTION modify_flow
         LET g_action_choice = 'modify_flow'
         EXIT DISPLAY
 
      ON ACTION withdraw
         LET g_action_choice = 'withdraw'
         EXIT DISPLAY
 
      ON ACTION org_withdraw
         LET g_action_choice = 'org_withdraw'
         EXIT DISPLAY
 
      ON ACTION phrase
         LET g_action_choice = 'phrase'
         EXIT DISPLAY
      #FUN-B60116 add end---
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
##
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-CB0014---add---end---
