# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asfi310.4gl
# Descriptions...: RUN CARD 維護作業
# Date & Author..: 00/04/25 By Carol
# Modify.........: No:7829 03/08/18 Carol 單據程式中呼叫單據自動編號時,
#                                         應該是要包覆在 BEGIN WORK 中(transaction)
#                                         才會達到lock 的功能
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........; No.MOD-4A0252 04/10/21 By Smapmin 修正工單號碼不能帶回的問題
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-4C0035 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-520037 05/02/14 By ching 結案 action is close_the_case
# Modify.........: No.MOD-510117 05/02/15 By ching 有報工不可刪除,更改
# Modify.........: No.FUN-550067 05/05/30 By Trisy 單據編號加大`
# Modify.........: No.TQC-630068 06/03/07 By Sarah 指定單據編號、執行功能
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-660067 06/06/14 By Sarah p_flow功能補強
# Modify.........: No.MOD-660066 06/06/19 By Pengu 無法往下產生Run Card 製程追蹤檔(sgm_file)的資料
# Modify.........: No.FUN-660128 06/06/28 By Xumin cl_err --> cl_err3
# Modify.........: No.MOD-670003 06/07/03 By day INSERT sgm02,sgm03_par,否則產生不到采購單
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-690022 06/09/20 By jamie 判斷imaacti
# Modify.........: No.FUN-690024 06/09/20 By jamie 判斷pmcacti
# Modify.........: No.FUN-680064 06/10/18 By huchenghao 初始化g_rec_b
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/10 By yjkhero 新增動態切換單頭部份顯示的功能 
# Modify.........: No.FUN-6A0164 06/11/22 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-680160 06/12/06 By pengu 1.查詢時,Run Card的開窗,應該是帶現有shm01的單號,而不是開單據編碼 
                                    #              2.由asfi301串asfi310帶出資料後,再按"查詢"會出現"(-201)語法錯誤的訊息"
# Modify.........: No.TQC-690002 06/12/06 By pengu 單頭確認的圖形未即時show在畫面上
# Modify.........: No.CHI-690066 06/12/13 By rainy CALL s_daywk() 要判斷未設定或非工作日
# Modify.........: No.TQC-6C0230 06/12/31 By ray 增加控管完工日期不可小于開工日期
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740020 07/04/05 By Xufeng  控管預計開工和預計完工日期
# Modify.........: No.TQC-740145 07/04/20 By hongmei 控管單身工時不能為負數
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: NO.MOD-7A0162 07/10/30 BY yiting 單據號碼為自行輸入時，會被自動產生單號取代
# Modify.........: No.FUN-710073 07/12/03 By jamie 1.UI將 '天' -> '天/生產批量'
#                                                  2.將程式有用到 'XX前置時間'改為乘以('XX前置時間' 除以 '生產單位批量(ima56)')
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.CHI-810015 08/01/17 By jamie 將FUN-710073修改部份還原
# Modify.........: No.FUN-840194 08/06/24 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.FUN-840235 08/09/05 By sherry 加上列印功能
# Modify.........: No.FUN-8B0094 08/09/05 By jan 增加"取消結案"的action
# Modify.........: No.MOD-910154 09/01/15 By claire 刪除單身製程時,若為第一道製程須做良品轉入數移轉
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-970010 09/11/27 By sabrina 單身的作業編號,點開窗查詢多個作業編號時，再按確定，整支作業就關掉了
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造成 ima26* 角色混亂的狀況，因此对ima26的调整 
# Modify.........: No:TQC-A50126 10/05/21 By lilingyu 查詢狀態下,審核碼無法查詢
# Modify.........: No:FUN-A60095 10/07/06 By jan 平行製程單身增加sgm011/sgm012/ecu014/sgm62/sgm63/sgm65/sgm12/sgm34/sgm64
#                                                單身移除sgm57/sgm59
# Modify.........: No.FUN-A70131 10/07/29 By destiny 平行工藝
# Modify.........: No.FUN-A80150 10/09/03 By sabrina 單頭新增"號機"欄位，單身新增"報工點否"、"委外廠商"欄位
# Modify.........: No.TQC-AB0411 10/11/30 By chenying 單身沒有資料，自動刪除單頭資料成功,但提示刪除失敗
#                                                     單身下條件查詢筆數顯示異常
# Modify.........: No.MOD-AC0336 10/12/28 By jan重抓製程料號
# Modify.........: No.TQC-B10171 11/01/18 By vealxu 走號機管理(sma1421='Y')時，shm18新增時應該開放手動輸入，但修改時不可以提供修改
# Modify.........: No.FUN-B10056 11/02/15 By lixh1  新增'檢查製程段’action,更改製程段控管
# Modify.........: No.FUN-B20078 11/03/02 By lixh1  製程段資料的捞取和控管直接對基本檔ecr_file操作 
# Modify.........: No.FUN-B30011 11/03/03 By lixh1  更改製程段邏輯
# Modify.........: No.MOD-B30427 11/03/14 By lixh1  拿掉不必要的報錯信息
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正
# Modify.........: No:TQC-B80252 11/08/31 By houlia 根據作業編號帶出相應的default工作站
# Modify.........: No.FUN-BB0085 11/12/06 By xianghui 增加數量欄位小樹取位
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.TQC-CA0018 12/10/10 By chenjing 查詢時確認碼下條件時筆數錯誤問題
# Modify.........: No:CHI-C80041 12/11/29 By bart 刪除單頭時，一併刪除相關table
# Modify.........: No.MOD-CC0224 13/01/08 By Elise sgm301轉到下一站時，數量應考慮轉換率
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_shm   RECORD LIKE shm_file.*,
    g_shm_t RECORD LIKE shm_file.*,
    g_shm_o RECORD LIKE shm_file.*,
    g_ima   RECORD LIKE ima_file.*,
    g_sfb   RECORD LIKE sfb_file.*,
#   g_t1                VARCHAR(3),
    g_t1                LIKE oay_file.oayslip,                     #No.FUN-550067        #No.FUN-680121 VARCHAR(05)
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_sgm           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        sgm03		LIKE sgm_file.sgm03,  #製程序
        #FUN-A60095--begin--add------------
        sgm011          LIKE sgm_file.sgm011, #上製程段
        sgm012          LIKE sgm_file.sgm012, #製程段號
    #   ecu014          LIKE ecu_file.ecu014, #製程段說明  #FUN-B10056
        sgm014          LIKE sgm_file.sgm014, #FUN-B10056
        sgm015          LIKE sgm_file.sgm015, #FUN-B10056  add
        ecr02           LIKE ecr_file.ecr02,  #FUN-B20078  add  
        #FUN-A60095--end--add--------------
        sgm04		LIKE sgm_file.sgm04,  #作業編號
        sgm45		LIKE sgm_file.sgm45,  #作業名稱
        sgm05		LIKE sgm_file.sgm05,  #機械編號
        eca02		LIKE eca_file.eca02,  #站別說明
        sgm66		LIKE sgm_file.sgm66,  #報工點否    #FUN-A80150 add
        sgm52		LIKE sgm_file.sgm52,  #委外否
        sgm321          LIKE sgm_file.sgm321, #委外加工量 #FUN-A60095
        sgm53		LIKE sgm_file.sgm53,  #PQC否
        sgm54		LIKE sgm_file.sgm54,  #check in
        sgm67		LIKE sgm_file.sgm67,  #委外廠商    #FUN-A80150 add
        sgm06		LIKE sgm_file.sgm06,  #生產站別
        sgm13		LIKE sgm_file.sgm13,  #固定工時
        sgm14		LIKE sgm_file.sgm14,  #標準工時
        sgm15		LIKE sgm_file.sgm15,  #固定機時
        sgm16		LIKE sgm_file.sgm16,  #標準機時
        sgm49		LIKE sgm_file.sgm49,  #製程人力
        sgm50		LIKE sgm_file.sgm50,  #開工日
        sgm51		LIKE sgm_file.sgm51,  #完工日
        sgm55           LIKE sgm_file.sgm55,  #Hold for check in
        sgm56           LIKE sgm_file.sgm56,  #Hold for check out(報工)
       #FUN-A60095--begin--modify----------
       #sgm57           LIKE sgm_file.sgm57,
        sgm58           LIKE sgm_file.sgm58,
       #sgm59           LIKE sgm_file.sgm59
        sgm62           LIKE sgm_file.sgm62,  #组成用量
        sgm63           LIKE sgm_file.sgm63,  #底数
        sgm65           LIKE sgm_file.sgm65,  #标准产出量
        sgm12           LIKE sgm_file.sgm12,  #固定损耗量
        sgm34           LIKE sgm_file.sgm34,  #变动损耗率
        sgm64           LIKE sgm_file.sgm64,  #损耗批量
       #FUN-A60095--end--modify------------
       #str—add by huanglf 160713
        ta_sgm01        LIKE sgm_file.ta_sgm01,
        ta_sgm02        LIKE sgm_file.ta_sgm02,
        ta_sgm03        LIKE sgm_file.ta_sgm03,
        ta_sgm06        LIKE sgm_file.ta_sgm06   #tianry   161214
       #end—add by huanglf 160713
                    END RECORD,
    g_sgm_t         RECORD                 #程式變數 (舊值)
        sgm03		LIKE sgm_file.sgm03,  #製程序
        #FUN-A60095--begin--add------------
        sgm011          LIKE sgm_file.sgm011, #上製程段
        sgm012          LIKE sgm_file.sgm012, #製程段號
    #   ecu014          LIKE ecu_file.ecu014, #製程段說明  #FUN-B10056
        sgm014          LIKE sgm_file.sgm014, #FUN-B10056
        sgm015          LIKE sgm_file.sgm015, #FUN-B10056 add
        ecr02           LIKE ecr_file.ecr02,  #FUN-B20078 add
        #FUN-A60095--end--add--------------
        sgm04		LIKE sgm_file.sgm04,  #作業編號
        sgm45		LIKE sgm_file.sgm45,  #作業名稱
        sgm05		LIKE sgm_file.sgm05,  #機械編號
        eca02		LIKE eca_file.eca02,  #站別說明
        sgm66		LIKE sgm_file.sgm66,  #報工點否    #FUN-A80150 add
        sgm52		LIKE sgm_file.sgm52,  #委外否
        sgm321          LIKE sgm_file.sgm321, #委外加工量 #FUN-A60095
        sgm53		LIKE sgm_file.sgm53,  #PQC否
        sgm54		LIKE sgm_file.sgm54,  #check in
        sgm67		LIKE sgm_file.sgm67,  #委外廠商    #FUN-A80150 add
        sgm06		LIKE sgm_file.sgm06,  #生產站別
        sgm13		LIKE sgm_file.sgm13,  #固定工時
        sgm14		LIKE sgm_file.sgm14,  #標準工時
        sgm15		LIKE sgm_file.sgm15,  #固定機時
        sgm16		LIKE sgm_file.sgm16,  #標準機時
        sgm49		LIKE sgm_file.sgm49,  #製程人力
        sgm50		LIKE sgm_file.sgm50,  #開工日
        sgm51		LIKE sgm_file.sgm51,  #完工日
        sgm55           LIKE sgm_file.sgm55,  #Hold for check in
        sgm56           LIKE sgm_file.sgm56,  #Hold for check out(報工)
       #FUN-A60095--begin--modify----------
       #sgm57           LIKE sgm_file.sgm57,
        sgm58           LIKE sgm_file.sgm58,
       #sgm59           LIKE sgm_file.sgm59
        sgm62           LIKE sgm_file.sgm62,  #组成用量
        sgm63           LIKE sgm_file.sgm63,  #底数
        sgm65           LIKE sgm_file.sgm65,  #标准产出量
        sgm12           LIKE sgm_file.sgm12,  #固定损耗量
        sgm34           LIKE sgm_file.sgm34,  #变动损耗率
        sgm64           LIKE sgm_file.sgm64,  #损耗批量
       #FUN-A60095--end--modify------------
      #str—add by huanglf 160713
        ta_sgm01        LIKE sgm_file.ta_sgm01,
        ta_sgm02        LIKE sgm_file.ta_sgm02,
        ta_sgm03        LIKE sgm_file.ta_sgm03,
        ta_sgm06        LIKE sgm_file.ta_sgm06    #tianry add 161214
       #end—add by huanglf 160713
                    END RECORD,
    l_sgm45             LIKE sgm_file.sgm45,
    l_sgm14a            LIKE sgm_file.sgm14,
    l_sgm14             LIKE sgm_file.sgm14,
    l_sgm49a            LIKE sgm_file.sgm49,
    l_sgm49             LIKE sgm_file.sgm49,
    l_sgm06             LIKE sgm_file.sgm06,
    g_sw            LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(01)
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680121 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680121 SMALLINT
    l_ac1           LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    g_cmd           LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(100)
    g_argv1         LIKE shm_file.shm01,   # Run Card
    g_argv2         STRING,                # 執行功能   #TQC-630068
    g_argv3         LIKE shm_file.shm012   # 工單編號   #TQC-630068 將工單號碼從g_argv2->g_argv3
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_i                   LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(72)
DEFINE g_row_count           LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_curs_index          LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_jump                LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE mi_no_ask             LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE g_confirm             LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_approve             LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_post                LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_close               LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_void                LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_valid               LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
#No.FUN-840235   --begin
DEFINE l_table             STRING
DEFINE g_str               STRING
#No.FUN-840235   --end 
#FUN-B10056 -------------------Begin-------------------------
DEFINE g_flag_i310           LIKE type_file.chr1             
DEFINE g_sgm012_a            ARRAY[100] OF LIKE sgm_file.sgm012
DEFINE g_max                 LIKE type_file.num5
DEFINE g_cnt_i310            LIKE type_file.num5
DEFINE g_chr_i310            LIKE type_file.chr1
#FUN-B10056 -------------------End---------------------------
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0090
    DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680121 SMALLINT
    OPTIONS
        INPUT NO WRAP,
        FIELD ORDER FORM                   #整個畫面會依照p_per所設定的欄位順序(忽略4gl寫的順序)  #FUN-A80150 add
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
   #No.FUN-840235  --begin
   LET g_sql= "shm01.shm_file.shm01,",   
              "shm012.shm_file.shm012,",
              "shm05.shm_file.shm05,",
              "ima55.ima_file.ima55,",
              "ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,",
              "shm06.shm_file.shm06,",
              "shm13.shm_file.shm13,",
              "shm15.shm_file.shm15,",
              "shm08.shm_file.shm08,",
              "shm09.shm_file.shm09,",
              "shm86.shm_file.shm86,",
              "sfb87.sfb_file.sfb87,",
              "shm28.shm_file.shm28,",
              "sgm03.sgm_file.sgm03,",
              "sgm04.sgm_file.sgm04,",
              "sgm45.sgm_file.sgm45,",
              "sgm05.sgm_file.sgm05,",
              "eca02.eca_file.eca02,",
              "sgm52.sgm_file.sgm52,",
              "sgm53.sgm_file.sgm53,",
              "sgm54.sgm_file.sgm54,",
              "sgm06.sgm_file.sgm06,",
              "sgm13.sgm_file.sgm13,",
              "sgm14.sgm_file.sgm14,",
              "sgm15.sgm_file.sgm15,",
              "sgm16.sgm_file.sgm16,",
              "sgm49.sgm_file.sgm49,",
              "sgm50.sgm_file.sgm50,",
              "sgm51.sgm_file.sgm51,",
              "sgm55.sgm_file.sgm55,",
              "sgm56.sgm_file.sgm56,",
             #FUN-A60095--begin--modify-----
             #"sgm57.sgm_file.sgm57,",
              "sgm58.sgm_file.sgm58,",
             #"sgm59.sgm_file.sgm59 "
              "sgm011.sgm_file.sgm011,",
              "sgm012.sgm_file.sgm012,",
              "ecu014.ecu_file.ecu014,",
              "sgm015.sgm_file.sgm015,",    #FUN-B10056
              "sgm321.sgm_file.sgm321,",
              "sgm62.sgm_file.sgm62,",
              "sgm63.sgm_file.sgm63,",
              "sgm65.sgm_file.sgm65,",
              "sgm12.sgm_file.sgm12,",
              "sgm34.sgm_file.sgm34,",
              "sgm64.sgm_file.sgm64"
             #FUN-A60095--end--modify------
   LET l_table = cl_prt_temptable('asfi310',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)" #FUN-A60095  #FUN-B10056 add ?
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
    END IF
   #No.FUN-840235  --end 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
 
   LET p_row = 2 LET p_col = 2
   OPEN WINDOW i310_w AT p_row,p_col WITH FORM "asf/42f/asfi310"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
  
#FUN-B10056 -------------------------------Begin------------------------------------
#  CALL cl_set_comp_visible("sgm011,sgm012,ecu014",g_sma.sma541='Y') #FUN-A60095 
#  CALL cl_set_comp_visible("sgm011,sgm012,sgm014,sgm015",g_sma.sma541='Y')        #FUN-B20078
   CALL cl_set_comp_visible("sgm011,sgm012,sgm014,sgm015,ecr02",g_sma.sma541='Y')  #FUN-B20078
   IF g_sma.sma541 = 'Y' THEN
      CALL cl_set_act_visible("chkbom",TRUE)
   ELSE
      CALL cl_set_act_visible("chkbom",FALSE)
   END IF
#FUN-B10056 -------------------------------End--------------------------------------
   CALL cl_set_comp_visible("shm18",g_sma.sma1421='Y')               #FUN-A80150 add
   CALL cl_set_comp_visible("sgm66",g_sma.sma1431='Y')               #FUN-A80150 add

# CALL cl_set_comp_entry("ta_shm01",FALSE) 
   
   CALL i310()
 
   CLOSE WINDOW i310_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
END MAIN
 
FUNCTION i310()
 
    INITIALIZE g_shm.* TO NULL
    INITIALIZE g_shm_t.* TO NULL
    INITIALIZE g_shm_o.* TO NULL
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)   #TQC-630068
 
   #start TQC-630068
    # 先以g_argv2判斷直接執行哪種功能：
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL i310_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL i310_a()
             END IF
          OTHERWISE          #TQC-660067 add
             CALL i310_q()   #TQC-660067 add
       END CASE
    END IF
   #end TQC-630068

   #IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv2) THEN   #TQC-630068 mark
    IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv3) THEN   #TQC-630068
       CALL  i310_q()
    END IF
 
    LET g_forupd_sql = "SELECT * FROM shm_file WHERE shm01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i310_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    CALL i310_menu()
 
END FUNCTION
 
FUNCTION i310_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    LET  g_wc2=' 1=1'
    CLEAR FORM
    INITIALIZE g_shm.* TO NULL
    CALL g_sgm.clear()
   #IF cl_null(g_argv1) AND cl_null(g_argv2) THEN   #TQC-630068 mark
    IF cl_null(g_argv1) AND cl_null(g_argv3) THEN   #TQC-630068
    CALL cl_set_head_visible("","YES")              #FUN-6B0031   
   INITIALIZE g_shm.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON
                    shm01,shm012,shm05,shm06,shm18,shm13,shm15,shm08,shm09,shm86,sfb87,    #TQC-A50126 add sfb87  #FUN-A80150 add shm18
                    shm28,shmuser,shmgrup,shmmodu,shmdate,shmacti  #bugno:7507 modify
                    ,ta_shm03,ta_shm05,ta_shm06     #add by guanyao160802 #add by huanglf160809
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE WHEN INFIELD(shm01) #Run Card
                   #-----------No.TQC-680160 modify
#                   #LET g_t1=g_shm.shm01[1,3]
                    #LET g_t1 = s_get_doc_no(g_shm.shm01)     #No.FUN-550067
                    ##CALL q_smy( FALSE,TRUE,g_t1,'asf','2') RETURNING g_t1 #TQC-670008
                    #CALL q_smy( FALSE,TRUE,g_t1,'ASF','2') RETURNING g_t1  #TQC-670008
#                   #LET g_shm.shm01[1,3]=g_t1
                    #LET g_shm.shm01 = g_t1                 #No.FUN-550067
                    #DISPLAY BY NAME g_shm.shm01
                     
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_shm1"
                     LET g_qryparam.construct= "Y"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shm01
                   #-----------No.TQC-680160 end
                WHEN INFIELD(shm012) #工單
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_sfb02"
                     LET g_qryparam.construct= "Y"
                     LET g_qryparam.arg1     = "12345"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO shm012   #MOD-4A0252
                     NEXT FIELD shm012
                WHEN INFIELD(shm06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_ecu"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO g_shm.shm06
                     NEXT FIELD shm06
#str----add by huanglf160809
                 WHEN INFIELD(ta_shm05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "cq_ta_shm05"
                     CALL cl_create_qry() RETURNING g_shm.ta_shm05
                     DISPLAY BY NAME  g_shm.ta_shm05
                     NEXT FIELD ta_shm05
#str----end by huanlf160809
                OTHERWISE EXIT CASE
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
 
       IF INT_FLAG THEN RETURN END IF
 
       CONSTRUCT g_wc2 ON sgm03,sgm011,sgm012,  #FUN-A60095
                          sgm014,sgm015,        #FUN-B10056
                          sgm04,sgm45,sgm67,sgm06,sgm14,sgm13,sgm16,sgm15,       #FUN-A80150 add sgm67
                          sgm49,sgm50,sgm51,sgm05,sgm66,sgm52,sgm321,sgm53,sgm54,sgm55, #FUN-A60055  #FUN-A80150 add sgm66
                         #sgm56,sgm57,sgm58,sgm59 #FUN-A60095
                          sgm56,sgm58,            #FUN-A60095
                          sgm62,sgm63,sgm65,sgm12,sgm34,sgm64 #FUN-A60095
            FROM s_sgm[1].sgm03,
                 s_sgm[1].sgm011,s_sgm[1].sgm012, #FUN-A60095
                 s_sgm[1].sgm014,s_sgm[1].sgm015, #FUN-B10056
                 s_sgm[1].sgm04,s_sgm[1].sgm45,s_sgm[1].sgm67,s_sgm[1].sgm06,       #FUN-A80150 add sgm67
                 s_sgm[1].sgm14,s_sgm[1].sgm13,s_sgm[1].sgm16,
                 s_sgm[1].sgm15,s_sgm[1].sgm49,
                 s_sgm[1].sgm50,s_sgm[1].sgm51,s_sgm[1].sgm05,s_sgm[1].sgm66,s_sgm[1].sgm52,s_sgm[1].sgm321, #FUN-A60055   #FUN-A80150 add sgm66
                 s_sgm[1].sgm53,s_sgm[1].sgm54,s_sgm[1].sgm55,s_sgm[1].sgm56,
                #s_sgm[1].sgm57,s_sgm[1].sgm58,s_sgm[1].sgm59    #FUN-A60095
                 s_sgm[1].sgm58,s_sgm[1].sgm62,s_sgm[1].sgm63,s_sgm[1].sgm65, #FUN-A60095
                 s_sgm[1].sgm12,s_sgm[1].sgm34,s_sgm[1].sgm64    #FUN-A60095  
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
                WHEN INFIELD(sgm05)                 #機械編號
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_eci"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sgm05
                     NEXT FIELD sgm05
#FUN-B20078 -------------------------Begin-----------------------------
                WHEN INFIELD(sgm012)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form     = "q_ecr"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sgm012
                   NEXT FIELD sgm012                
                WHEN INFIELD(sgm015)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form     = "q_ecr"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sgm015
                   NEXT FIELD sgm015
#FUN-B20078 -------------------------End-------------------------------
               #FUN-A80150---add---start---
                WHEN INFIELD(sgm67) #廠商編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_pmc"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret 
                   DISPLAY g_qryparam.multiret TO sgm67 
                   NEXT FIELD sgm67
               #FUN-A80150---add---end---
                WHEN INFIELD(sgm06)                 #生產站別
                     CALL q_eca(TRUE,TRUE,g_sgm[1].sgm06)
                     RETURNING g_qryparam.multiret         #No:MOD-970010 modify
                     DISPLAY g_qryparam.multiret TO sgm06  #No:MOD-970010 modify
                     NEXT FIELD sgm06
 
                WHEN INFIELD(sgm04)                 #作業編號
                     CALL q_ecd(TRUE,TRUE,g_sgm[1].sgm04)
                     RETURNING g_qryparam.multiret         #No:MOD-970010 modify
                     DISPLAY g_qryparam.multiret TO sgm04  #No:MOD-970010 modify
                    #MOD-970010---mark---start---
                    #CALL i310_sgm04('a')
                    #IF NOT cl_null(g_errno) THEN
                    #   CALL cl_err('',g_errno,0)
                    #END IF
                    #MOD-970010---mark---end---
                     NEXT FIELD sgm04
 
                WHEN INFIELD(sgm55)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_sgg"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sgm55
                     NEXT FIELD sgm55
                WHEN INFIELD(sgm56)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_sgg"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sgm56
                     NEXT FIELD sgm56
               #FUN-A60095--begin--mark-----------
               #WHEN INFIELD(sgm57)
               #     CALL cl_init_qry_var()
               #     LET g_qryparam.state    = "c"
               #     LET g_qryparam.form     = "q_gfe"
               #     CALL cl_create_qry() RETURNING g_qryparam.multiret
               #     DISPLAY g_qryparam.multiret TO sgm57
               #     NEXT FIELD sgm57
               #FUN-A60095--end--mark-------------
                WHEN INFIELD(sgm58)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_gfe"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sgm58
                     NEXT FIELD sgm58
                 #FUN-A60095--begin--add---------------
                 WHEN INFIELD(sgm011)                #上工艺段号
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                    # LET g_qryparam.form     = "q_ecu012_1"    #FUN-B10056 mark
                      LET g_qryparam.form     = "q_sgm012_1"    #FUN-B10056
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO sgm011
                 WHEN INFIELD(sgm012)                #工艺段号
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                    # LET g_qryparam.form     = "q_ecu012_1"    #FUN-B10056 mark
                      LET g_qryparam.form     = "q_sgm012_1"    #FUN-B10056
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO sgm012
                 #FUN-A60095--end--add-----------------
           END CASE
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
       END CONSTRUCT
 
       IF INT_FLAG THEN RETURN END IF
    ELSE
       LET g_wc = NULL    #No.TQC-680160 add
       IF not cl_null(g_argv1) THEN
          LET g_wc=" shm01='",g_argv1,"'"
       END IF
      #start TQC-630068
      #IF not cl_null(g_argv2) THEN
      #   IF not cl_null(g_argv1) THEN LET g_wc = " AND " END IF
      #   LET g_wc= g_wc clipped," shm012='",g_argv2,"'"
      #END IF
       IF not cl_null(g_argv3) THEN
          IF not cl_null(g_argv1) THEN LET g_wc = " AND " END IF
          LET g_wc= g_wc clipped," shm012='",g_argv3,"'"
       END IF
      #end TQC-630068
    END IF
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND shmuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND shmgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND shmgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('shmuser', 'shmgrup')
    #End:FUN-980030
 
    IF g_wc2=' 1=1' OR g_wc2 IS NULL
      #THEN LET g_sql="SELECT shm01 FROM shm_file ",     #FUN-A80150 mark
      #THEN LET g_sql="SELECT shm01 FROM shm_file LEFT JOIN sfb_file ON sfb_file.sfb01 = shm_file.shm012 ",   #FUN-A80150 add #TQC-AB0411 mark
       THEN LET g_sql="SELECT DISTINCT shm01 FROM shm_file LEFT JOIN sfb_file ON sfb_file.sfb01 = shm_file.shm012 ",  #TQC-AB0411 add 
                      " WHERE ",g_wc CLIPPED, " ORDER BY shm01"
      #ELSE LET g_sql="SELECT shm01",             #TQC-AB0411 mark  
       ELSE LET g_sql="SELECT DISTINCT shm01",    #TQC-AB0411 add
                     #"  FROM shm_file,sgm_file ",      #FUN-A80150 mark
                      "  FROM shm_file LEFT JOIN sfb_file ON sfb_file.sfb01 = shm_file.shm012 ,sgm_file ",   #FUN-A80150 add
                      " WHERE shm01=sgm01 ",
                      "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                      " ORDER BY shm01"
    END IF
    PREPARE i310_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE i310_cs SCROLL CURSOR WITH HOLD FOR i310_prepare
   #LET g_sql= "SELECT COUNT(*) FROM shm_file WHERE ",g_wc CLIPPED     #FUN-A80150 mark
   #LET g_sql= "SELECT COUNT(*) FROM shm_file LEFT JOIN sfb_file ON sfb_file.sfb01 = shm_file.shm012 WHERE ",g_wc CLIPPED   #FUN-A80150 add   #TQC-AB0411 mark
    #TQC-AB0411-------add----------end--------------------------
    IF g_wc2=' 1=1' OR g_wc2 IS NULL THEN     
   #   LET g_sql= "SELECT COUNT(*) FROM shm_file WHERE ",g_wc CLIPPED      #TQC-CA0018 mark
       LET g_sql= "SELECT COUNT(*) FROM shm_file LEFT JOIN sfb_file ON sfb_file.sfb01 = shm_file.shm012 WHERE ",g_wc CLIPPED       #TQC-CA0018 add
    ELSE
   #  LET g_sql= "SELECT COUNT(DISTINCT shm01) FROM shm_file,sgm_file ",   #TQC-CA0018 mark
       LET g_sql= "SELECT COUNT(DISTINCT shm01) FROM shm_file LEFT JOIN sfb_file ON sfb_file.sfb01 = shm_file.shm012,sgm_file ",   #TQC-CA0018 add
                  " WHERE shm01=sgm01 ",
                  "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    #TQC-AB0411-------add----------str--------------------------
    PREPARE i310_precount FROM g_sql
    DECLARE i310_count CURSOR FOR i310_precount
END FUNCTION
 
FUNCTION i310_menu()
 
   WHILE TRUE
      CALL i310_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i310_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i310_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i310_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i310_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i310_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         #No.FUN-840235---Begin
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i310_out()
            END IF
         #No.FUN-840235---End
   #str---add by ly 180328    BLOCK
         WHEN "bolck"
           IF cl_chk_act_auth() THEN 
             UPDATE  shm_file SET ta_shm06= 'Y' WHERE shm01=g_shm.shm01
             SELECT  ta_shm06 into g_shm.ta_shm06 FROM shm_file WHERE  shm01=g_shm.shm01   
           DISPLAY BY NAME g_shm.ta_shm06
              #CALL i310_show()
              CALL cl_msg("block  ok") 
           END IF
           
         WHEN "undo_bolck"
           IF cl_chk_act_auth() THEN 
             UPDATE shm_file SET ta_shm06='N' WHERE shm01=g_shm.shm01
             SELECT  ta_shm06 into g_shm.ta_shm06 FROM shm_file WHERE  shm01=g_shm.shm01
             DISPLAY BY NAME g_shm.ta_shm06
             #CALL i310_show() 
             CALL cl_msg("undo block  ok") 
           END IF
           
         #str-----mark by guanyao161013
         #str----add by jixf 160802
         WHEN "ins_sgm"
            IF cl_chk_act_auth() THEN
               CALL i310_ins_sgm()
            END IF 
         #end----add by jixf 160802

        #str----add by huanglf170320
         WHEN "upd_ta_shm05"
            IF cl_chk_act_auth() THEN
               CALL i310_ta_shm05()
            END IF 

        #str----end by huanglf170320


          #str---add by ly 180328    BLOCK
         WHEN "bolck"
           IF cl_chk_act_auth() THEN 
             UPDATE sfb_file SET sfbud06= 'Y' WHERE sfb01=g_sfb.sfb01
              DISPLAY BY NAME g_sfb.sfbud06
              CALL cl_msg("block  ok") 
           END IF
           
         WHEN "undo_bolck"
           IF cl_chk_act_auth() THEN 
             UPDATE sfb_file SET sfbud06='N' WHERE sfb01=g_sfb.sfb01
             DISPLAY BY NAME g_sfb.sfbud06
              CALL cl_msg("undo block  ok") 
           END IF
           ---end by ly 
        #WHEN "dhy_pro"
        #    IF cl_chk_act_auth() THEN
        #       CALL dhy_pro()
        #    END IF 
        #end-----mark by guanyao161013
      
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-B10056 ----------------------Begin-------------------------
         WHEN "chkbom"
            IF cl_chk_act_auth() THEN
               CALL i310_chkbom()
            END IF
#FUN-B10056 ----------------------End---------------------------
         WHEN "routing_qt_status"
            IF cl_chk_act_auth() THEN
               LET g_cmd = "aecq710 '",g_shm.shm01,"'"
               CALL cl_cmdrun(g_cmd)
            END IF
         WHEN "cell_details"
            IF NOT cl_null(g_shm.shm01) AND NOT cl_null(g_shm.shm05) THEN
               LET g_cmd = "aeci711 '",g_shm.shm01,"' '",
                            g_shm.shm05 clipped,"'"
               CALL cl_cmdrun(g_cmd)
            END IF
          WHEN "close_the_case"  #MOD-520037
            IF cl_chk_act_auth() THEN
               CALL i310_c()
            END IF
            CASE g_sfb.sfb87
                 WHEN 'Y'   LET g_confirm = 'Y'
                            LET g_void = ''
                 WHEN 'N'   LET g_confirm = 'N'
                            LET g_void = ''
                 WHEN 'X'   LET g_confirm = ''
                            LET g_void = 'Y'
              OTHERWISE     LET g_confirm = ''
                            LET g_void = ''
            END CASE
            IF g_shm.shm28='Y' THEN
               LET g_close = 'Y'
            ELSE
               LET g_close = 'N'
            END IF
            #圖形顯示
            CALL cl_set_field_pic(g_confirm,"","",g_close,g_void,g_shm.shmacti)
#FUN-4B0011
          #FUN-8B0094--BEGIN--
          WHEN "cance_close_the_case"  #MOD-520037
            IF cl_chk_act_auth() THEN
               CALL i310_cc()
            END IF
            CASE g_sfb.sfb87
                 WHEN 'Y'   LET g_confirm = 'Y'
                            LET g_void = ''
                 WHEN 'N'   LET g_confirm = 'N'
                            LET g_void = ''
                 WHEN 'X'   LET g_confirm = ''
                            LET g_void = 'Y'
              OTHERWISE     LET g_confirm = ''
                            LET g_void = ''
            END CASE
            IF g_shm.shm28='Y' THEN
               LET g_close = 'Y'
            ELSE
               LET g_close = 'N'
            END IF
            #圖形顯示
            CALL cl_set_field_pic(g_confirm,"","",g_close,g_void,g_shm.shmacti)
         #FUN-8B0094--END--
 
         #FUN-A60095--begin--add---------
         WHEN "subcontract"
               CALL i310_subcontract()
         #FUN-A60095--end--add----------- 

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sgm),'','')
            END IF
##
         #No.FUN-6A0164-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_shm.shm01 IS NOT NULL THEN
                 LET g_doc.column1 = "shm01"
                 LET g_doc.value1 = g_shm.shm01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0164-------add--------end----
      END CASE
   END WHILE
    CLOSE i310_cs
END FUNCTION
 
FUNCTION i310_a()
    DEFINE li_result  LIKE type_file.num5          #No.FUN-550067        #No.FUN-680121 SMALLINT
    DEFINE    l_cnt   LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_sgm.clear()
    INITIALIZE g_shm.* TO NULL
    LET g_shm_o.* = g_shm.*
    LET g_shm_t.* = g_shm.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_shm.shm08=0 LET g_shm.shm09=0 LET g_shm.shm10=0
        LET g_shm.shm11=0 LET g_shm.shm111=0
        LET g_shm.shm12=0 LET g_shm.shm121=0
        LET g_shm.shm28='N'
        LET g_shm.shmacti='Y'
        LET g_shm.shmuser=g_user
        LET g_shm.shmoriu = g_user #FUN-980030
        LET g_shm.shmorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_shm.shmgrup=g_grup
        LET g_shm.shmdate=TODAY
        LET g_shm.shmplant = g_plant #FUN-980008 add
        LET g_shm.shmlegal = g_legal #FUN-980008 add
       #start TQC-630068
        IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
           LET g_shm.shm012 = g_argv1
        END IF
       #end TQC-630068
        CALL i310_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0 CALL cl_err('',9001,0)
           INITIALIZE g_shm.* TO NULL
           ROLLBACK WORK EXIT WHILE
        END IF
        IF g_shm.shm01 IS NULL THEN CONTINUE WHILE END IF
        BEGIN WORK  #No:7829
       #No.FUN-550067 --start--
        CALL s_auto_assign_no("asf",g_shm.shm01,TODAY,"2","shm_file","shm01","","Y","")
        RETURNING li_result,g_shm.shm01
        IF (NOT li_result) THEN
#       IF g_smy.smyauno='Y' THEN
#          CALL s_shmauno(g_shm.shm01,TODAY) RETURNING g_i,g_shm.shm01
#          IF g_i THEN #有問題
         #No.FUN-550067 ---end---
              ROLLBACK WORK   #No:7829
              CONTINUE WHILE
           END IF
	   DISPLAY BY NAME g_shm.shm01
#       END IF        #No.FUN-550067
        INSERT INTO shm_file VALUES (g_shm.*)
        IF STATUS THEN
#          CALL cl_err('ins shm:',STATUS,1)   #No.FUN-660128
           CALL cl_err3("ins","shm_file",g_shm.shm01,"",STATUS,"","ins shm",1)  #No.FUN-660128
           ROLLBACK WORK   #No:7829
           CONTINUE WHILE
        END IF
 
        COMMIT WORK
 
        CALL cl_flow_notify(g_shm.shm01,'I')
 
        SELECT shm01 INTO g_shm.shm01 FROM shm_file WHERE shm01 = g_shm.shm01
        LET g_shm_t.* = g_shm.*
        LET g_rec_b=0                   #No.FUN-680064
        CALL i310_process_b()   #check是否自動產生單身資料
        CALL i310_b_fill(' 1=1')
        CALL i310_b()
        EXIT WHILE
    END WHILE
END FUNCTION
 

#CHI-C30002 -------- add -------- begin
FUNCTION i310_delHeader()
   DEFINE l_cnt   LIKE type_file.num5  
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041   
   #darcy:2025/02/26 add s---
   define l_ok   varchar(1)
   define l_response string
   #darcy:2025/02/26 add e---

   SELECT COUNT(*) INTO l_cnt FROM sgm_file WHERE sgm01=g_shm.shm01
   IF l_cnt = 0 THEN
      DELETE FROM sgn_file WHERE sgn00 = g_shm.shm01  #CHI-C80041
      DELETE FROM shm_file  WHERE shm01=g_shm.shm01
      call DelMESLotNoR(g_shm.shm01) returning l_ok,l_response #darcy:2025/02/26 add
      INITIALIZE  g_shm.*  TO NULL
      CLEAR FORM
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i310_delall()
#   DEFINE l_cnt   LIKE type_file.num5          #No.FUN-680121 SMALLINT
#   SELECT COUNT(*) INTO l_cnt FROM sgm_file WHERE sgm01=g_shm.shm01
#   IF l_cnt = 0  THEN
#      DELETE FROM shm_file  WHERE shm01=g_shm.shm01
#      IF STATUS=0 THEN          #TQC-AB0411 mark
#      IF SQLCA.sqlcode  THEN    #TQC-AB0411 add 
#         CALL cl_err('del shm:','9044',1)   #No.FUN-660128
#         CALL cl_err3("del","shm_file",g_shm.shm01,"","9044","","del shm:",1)  #No.FUN-660128
#      END IF
#      CLEAR FORM
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i310_u()
    DEFINE  l_cnt   LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_shm.shm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_shm.* FROM shm_file WHERE shm01 = g_shm.shm01
    IF g_sfb.sfb04 = '8'   THEN CALL cl_err('','aap-730',0) RETURN END IF
    IF g_shm.shm28 = 'Y'   THEN CALL cl_err('','aap-730',1) RETURN END IF
 
     #MOD-510117
   #IF g_sfb.sfb87 = 'Y'   THEN CALL cl_err('','asf-923',0) RETURN END IF
    SELECT COUNT(*) INTO g_cnt FROM sha_file
     WHERE sha08=g_shm.shm01
    IF g_cnt > 0 THEN CALL cl_err('exists sha','asf-938',0) RETURN END IF
 
    SELECT COUNT(*) INTO g_cnt FROM shb_file
     WHERE shb16=g_shm.shm01
       AND shbconf = 'Y'    #FUN-A70095
    IF g_cnt > 0 THEN CALL cl_err('exists shb','asf-938',0) RETURN END IF
    #--
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_shm_o.* = g_shm.*
 
    BEGIN WORK
 
    OPEN i310_cl USING g_shm.shm01
    IF STATUS THEN
       CALL cl_err("OPEN i310_cl:", STATUS, 1)
       CLOSE i310_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i310_cl INTO g_shm.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err('lock shm:',SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE i310_cl ROLLBACK WORK RETURN
    END IF
    CALL i310_show()
    WHILE TRUE
        LET g_shm.shm28='N'
        LET g_shm.shmmodu=g_user
        LET g_shm.shmdate=g_today
        CALL i310_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_shm.*=g_shm_t.*
            CALL i310_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE shm_file SET * = g_shm.* WHERE shm01 = g_shm_t.shm01
        IF STATUS THEN
 #           CALL cl_err(g_shm.shm01,STATUS,0)  #No.FUN-660128
 
            CALL cl_err3("upd","shm_file",g_shm_t.shm01,"",STATUS,"","",1)  #No.FUN-660128
        CONTINUE WHILE END IF
        IF g_shm.shm01 != g_shm_t.shm01 THEN CALL i310_chkkey() END IF
#       CALL i310_delall() #CHI-C30002 mark
        CALL i310_delHeader()     #CHI-C30002 add
        EXIT WHILE
    END WHILE
    CLOSE i310_cl
    COMMIT WORK
    CALL cl_flow_notify(g_shm.shm01,'U')
 
END FUNCTION
 
FUNCTION i310_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
    DEFINE l_tc_pmm03   LIKE tc_pmm_file.tc_pmm03
    DEFINE l_tc_pmm08   LIKE tc_pmm_file.tc_pmm08
    DEFINE l_sql        LIKE type_file.chr1000
    DEFINE l_x          LIKE type_file.num5    #add by guanyao160808
    #darcy:2025/02/26 add s---
    define l_ok      varchar(1),
           l_response string
    #darcy:2025/02/26 add e---
    
    IF s_shut(0) THEN RETURN END IF
    IF g_shm.shm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_shm.* FROM shm_file WHERE shm01 = g_shm.shm01
    IF g_shm.shm28='Y'    THEN CALL cl_err('','9004',0) RETURN END IF

    #str----add by guanyao160808
    LET l_x = 0
    SELECT COUNT(*) INTO l_x FROM tc_shc_file WHERE tc_shc03 = g_shm.shm01 
    IF l_x >0 THEN
       CALL cl_err('','csf-071',0) 
       RETURN 
    END IF 
    LET l_x = 0
    SELECT COUNT(*) INTO l_x FROM tc_shb_file WHERE tc_shb03 = g_shm.shm01 
    IF g_user='tiptop'  THEN LET l_x=0 END IF   #ly18014
    IF g_user='20233'   THEN LET  l_x=0 END IF  #ly180614
    IF l_x > 0 THEN 
       CALL cl_err('','csf-071',0) 
       RETURN 
    END IF 
    #end----add by guanyao160808
 
     #MOD-510117
   #IF g_sfb.sfb87 = 'Y'   THEN CALL cl_err('','asf-923',0) RETURN END IF
    SELECT COUNT(*) INTO g_cnt FROM sha_file
     WHERE sha08=g_shm.shm01
    IF g_cnt > 0 THEN CALL cl_err('exists sha','asf-938',0) RETURN END IF
 
    SELECT COUNT(*) INTO g_cnt FROM shb_file
     WHERE shb16=g_shm.shm01
       AND shbconf = 'Y'    #FUN-A70095
    IF g_cnt > 0 THEN CALL cl_err('exists shb','asf-938',0) RETURN END IF
  
    #str---add by huanglf160721
     LET l_sql = " SELECT tc_pmm03,tc_pmm08 FROM tc_pmm_file ",
                     "  WHERE tc_pmm03 = '",g_shm.shm01,"'"
         PREPARE i310_confirm_pb FROM l_sql
         DECLARE i310_confirm_cs CURSOR FOR i310_confirm_pb
         LET l_tc_pmm03 = ''
         LET l_tc_pmm08 = ''
         FOREACH i310_confirm_cs INTO l_tc_pmm03,l_tc_pmm08
            SELECT COUNT(*) INTO g_cnt FROM tc_pmm_file
                WHERE tc_pmm03 = l_tc_pmm03
                  AND tc_pmm08 = l_tc_pmm08
               IF g_cnt>0 THEN
                  CALL cl_err('exists tc_pmm','asf-938',0)
                  RETURN
                  EXIT FOREACH 
               END IF 
         END FOREACH 
    #end---add by hunaglf160721
    BEGIN WORK
 
    OPEN i310_cl USING g_shm.shm01
    IF STATUS THEN
       CALL cl_err("OPEN i310_cl:", STATUS, 1)
       CLOSE i310_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i310_cl INTO g_shm.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_shm.shm01,SQLCA.sqlcode,0) ROLLBACK WORK RETURN
    END IF
    CALL i310_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "shm01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_shm.shm01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
       MESSAGE "Delete shm,sgm!"
       DELETE FROM shm_file WHERE shm01 = g_shm.shm01
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err('No shm deleted',SQLCA.SQLCODE,0)    #No.FUN-660128
          CALL cl_err3("del","shm_file",g_shm.shm01,"",SQLCA.SQLCODE,"","No shm deleted",1)  #No.FUN-660128
          ROLLBACK WORK RETURN
       END IF
       call DelMESLotNoR(g_shm.shm01) returning l_ok,l_response #darcy:2025/02/26 add
       DELETE FROM sgm_file WHERE sgm01 = g_shm.shm01
       IF SQLCA.sqlcode THEN
#         CALL cl_err('del sgm',STATUS,0)    #No.FUN-660128
          CALL cl_err3("del","sgm_file",g_shm.shm01,"",STATUS,"","del sgm",1)  #No.FUN-660128
          ROLLBACK WORK RETURN
       END IF
       DELETE FROM sgn_file WHERE sgn00 = g_shm.shm01
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  #FUN-980008 add
       VALUES ('asfi310',g_user,g_today,g_msg,g_shm.shm01,'delete',g_plant,g_legal) #FUN-980008 add
       CLEAR FORM
       CALL g_sgm.clear()
       INITIALIZE g_shm.* TO NULL
       MESSAGE ""
       OPEN i310_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE i310_cs
          CLOSE i310_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH i310_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i310_cs
          CLOSE i310_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i310_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i310_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i310_fetch('/')
       END IF
    END IF
    CLOSE i310_cl
    COMMIT WORK
    CALL cl_flow_notify(g_shm.shm01,'D')
 
END FUNCTION
 
FUNCTION i310_chkkey()
    UPDATE sgm_file SET sgm01=g_shm.shm01 WHERE sgm01=g_shm_t.shm01
    IF STATUS THEN
#      CALL cl_err('upd sgm01',STATUS,1)   #No.FUN-660128
       CALL cl_err3("upd","sgm_file",g_shm_t.shm01,"",STATUS,"","upd sgm01",1)  #No.FUN-660128
       CALL i310_show()
       ROLLBACK WORK RETURN
    END IF
END FUNCTION
 
FUNCTION i310_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_shm.* TO NULL              #No.FUN-6A0164
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i310_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_sgm.clear()
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
 
    OPEN i310_count
    FETCH i310_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
 
    OPEN i310_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_shm.shm01,SQLCA.sqlcode,0)
        INITIALIZE g_shm.* TO NULL
    ELSE
        CALL i310_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i310_fetch(p_flshm)
    DEFINE
        p_flshm         LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
        l_abso          LIKE type_file.num10          #No.FUN-680121 INTEGER
 
    CASE p_flshm
        WHEN 'N' FETCH NEXT     i310_cs INTO g_shm.shm01
        WHEN 'P' FETCH PREVIOUS i310_cs INTO g_shm.shm01
        WHEN 'F' FETCH FIRST    i310_cs INTO g_shm.shm01
        WHEN 'L' FETCH LAST     i310_cs INTO g_shm.shm01
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
            FETCH ABSOLUTE g_jump i310_cs INTO g_shm.shm01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_shm.shm01,SQLCA.sqlcode,0)
        INITIALIZE g_shm.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flshm
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_shm.* FROM shm_file       # 重讀DB,因TEMP有不被更新特性
       WHERE shm01 = g_shm.shm01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_shm.shm01,SQLCA.sqlcode,0)   #No.FUN-660128
       CALL cl_err3("sel","shm_file",g_shm.shm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
    ELSE
       LET g_data_owner = g_shm.shmuser      #FUN-4C0035
       LET g_data_group = g_shm.shmgrup      #FUN-4C0035
       LET g_data_plant = g_shm.shmplant #FUN-980030
       CALL i310_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i310_show()
 DEFINE l_n   LIKE type_file.num5
 DEFINE l_ima55 LIKE ima_file.ima55
 DEFINE l_ima02 LIKE ima_file.ima02
 DEFINE l_ima021 LIKE ima_file.ima021
 DEFINE l_num    LIKE shm_file.shm08   #add by jixf 160810
 
    LET g_shm_t.* = g_shm.*
    DISPLAY BY NAME g_shm.shmoriu,g_shm.shmorig,
        g_shm.shm01, g_shm.shm012, g_shm.shm06,g_shm.shm18,g_shm.shm05, g_shm.shm13,   #FUN-A80150 add shm18
        g_shm.shm15, g_shm.shm08, g_shm.shm09,g_shm.shm86,g_shm.shm28,
        g_shm.shmuser,g_shm.shmgrup,g_shm.shmmodu,g_shm.shmdate,g_shm.shmacti,
        g_sfb.sfb87
        ,g_shm.ta_shm01   #add by guanyao160715 
        ,g_shm.ta_shm02#add by huanglf160720
        ,g_shm.ta_shm03#add by huanglf160801
        ,g_shm.ta_shm05,g_shm.ta_shm06

    #str---add by jixf 160810
    IF cl_null(g_shm.ta_shm06) THEN LET g_shm.ta_shm06='N' END IF 
    SELECT SUM(shm08) INTO l_num FROM shm_file WHERE ta_shm05=g_shm.ta_shm05 AND shm012=g_shm.shm012
    DISPLAY l_num TO num
    #end---add by jixf 160810
    SELECT ima55,ima02,ima021 INTO l_ima55,l_ima02,l_ima021 FROM ima_file WHERE ima01 = g_shm.shm05
    DISPLAY l_ima02 TO FORMONLY.ima02
    DISPLAY l_ima021 TO FORMONLY.ima021
    DISPLAY l_ima55 TO FORMONLY.ima55
    
       #----------No.TQC-690002 add
        CALL i310_shm012('d')
        CALL i310_b_fill(g_wc2)
       #----------No.TQC-690002 end
        CASE g_sfb.sfb87
             WHEN 'Y'   LET g_confirm = 'Y'
                        LET g_void = ''
             WHEN 'N'   LET g_confirm = 'N'
                        LET g_void = ''
             WHEN 'X'   LET g_confirm = ''
                        LET g_void = 'Y'
          OTHERWISE     LET g_confirm = ''
                        LET g_void = ''
        END CASE
        IF g_shm.shm28='Y' THEN
           LET g_close = 'Y'
        ELSE
           LET g_close = 'N'
        END IF
        #圖形顯示
        CALL cl_set_field_pic(g_confirm,"","",g_close,g_void,g_shm.shmacti)
 
       #----------No.TQC-690002 mark
       #CALL i310_shm012('d')
       #CALL i310_b_fill(g_wc2)
       #----------No.TQC-690002 end
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i310_shm012(p_cmd)
    DEFINE p_cmd      LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
           l_smy58    LIKE smy_file.smy58,
#          l_t1       VARCHAR(03)
           l_t1       LIKE oay_file.oayslip         #No.FUN-680121 #No.FUN-550067 VARCHAR(5)
    LET g_errno=' '
    SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01=g_shm.shm012
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno='asf-523'
         WHEN g_sfb.sfbacti='N'    LET g_errno = '9028'
        #WHEN g_sfb.sfb87='Y'      LET g_errno = '9022'
         WHEN g_sfb.sfb87='N'      LET g_errno = 'asf-104'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
    IF p_cmd = 'a' THEN
       IF cl_null(g_shm.shm13) THEN LET g_shm.shm13=g_sfb.sfb13 END IF
       IF cl_null(g_shm.shm15) THEN LET g_shm.shm15=g_sfb.sfb15 END IF
       IF cl_null(g_shm.shm18) THEN LET g_shm.shm18=g_sfb.sfb919 END IF     #FUN-A80150 add
       DISPLAY BY NAME g_shm.shm13,g_shm.shm15,g_shm.shm18                  #FUN-A80150 add shm18
#      LET l_t1 = g_shm.shm012[1,3]
       LET l_t1 = s_get_doc_no(g_shm.shm012)        #No.FUN-550067
       DISPLAY "l_t1=",l_t1
       SELECT smy58 INTO l_smy58 FROM smy_file WHERE smyslip = l_t1
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno ='mfg0014'
            WHEN l_smy58 = 'N'        LET g_errno ='asf-822'
            OTHERWISE           LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
    END IF
    IF cl_null(g_errno) OR p_cmd='d' THEN
       LET g_shm.shm05=g_sfb.sfb05 LET g_shm.shm06=g_sfb.sfb06
       DISPLAY BY NAME g_shm.shm05,g_shm.shm06,g_sfb.sfb87
       CALL i310_shm05('d')
    END IF
END FUNCTION
 
FUNCTION i310_i(p_cmd)
  DEFINE li_result   LIKE type_file.num5          #No.FUN-550067        #No.FUN-680121 SMALLINT
  DEFINE p_cmd          LIKE type_file.chr1                 #a:輸入 u:更改        #No.FUN-680121 VARCHAR(1)
  DEFINE l_flag         LIKE type_file.chr1                 #判斷必要欄位是否有輸入        #No.FUN-680121 VARCHAR(1)
  DEFINE l_part		LIKE type_file.chr20         #No.FUN-680121 VARCHAR(20)
# DEFINE l_qty		LIKE ima_file.ima26          #No.FUN-680121 DEC(15,3)
  DEFINE l_qty          LIKE type_file.num15_3       ###GP5.2  #NO.FUN-A20044
  DEFINE l_ver		LIKE aba_file.aba18          #No.FUN-680121 VARCHAR(2)
  DEFINE l_n,l_cnt      LIKE type_file.num5          #No.FUN-680121 SMALLINT
  DEFINE l_sum          LIKE shm_file.shm08


    DISPLAY BY NAME
       g_shm.shm01,g_shm.shm012,g_shm.shm06,g_shm.shm18,g_shm.shm05,   #FUN-A80150 add shm18
       g_shm.shm13 ,g_shm.shm15,g_shm.shm08,g_shm.shm09,g_shm.shm28,g_shm.ta_shm02,
       g_shm.shmuser,g_shm.shmgrup,g_shm.shmdate,g_shm.shmacti,g_sfb.sfb87,g_shm.ta_shm03
    CALL i310_shm05('d')
      
    CALL cl_set_head_visible("","YES")              #FUN-6B0031 
    INPUT BY NAME g_shm.shmoriu,g_shm.shmorig,
       g_shm.shm01,g_shm.shm012,g_shm.shm18,        #TQC-B10171 add shm18
       g_shm.shm13 ,g_shm.shm15,g_shm.shm08,g_shm.shm09
       WITHOUT DEFAULTS
   
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i310_set_entry(p_cmd)
            CALL i310_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
         #No.FUN-550067 --start--
         CALL cl_set_docno_format("shm012")
         #No.FUN-550067 ---end---
 
        AFTER FIELD shm01
        #No.FUN-550067 --start--
         #IF NOT cl_null(g_shm.shm01) AND g_shm.shm01 != g_shm_t.shm01 THEN   #NO.MOD-7A0162 mark
         #IF p_cmd = "a" AND NOT cl_null(g_shm.shm01) THEN                    #NO.MOD-7A0162
          IF NOT cl_null(g_shm.shm01) AND (g_shm.shm01 != g_shm_t.shm01 OR g_shm_t.shm01 IS NULL) THEN   #NO.MOD-7A0162  #FUN-B50026 mod
            CALL s_check_no("asf",g_shm.shm01,g_shm_t.shm01,"2","shm_file","shm01","")
            RETURNING li_result,g_shm.shm01
            DISPLAY BY NAME g_shm.shm01
            IF (NOT li_result) THEN
               NEXT FIELD shm01
            END IF
#            DISPLAY g_smy.smydesc TO smydesc
#           IF NOT cl_null(g_shm.shm01) THEN
#              LET g_t1=g_shm.shm01[1,3]
#              CALL s_mfgslip(g_t1,'asf','2')
#       IF NOT cl_null(g_errno) THEN	 		#抱歉,有問題
#           CALL cl_err(g_t1,g_errno,0) NEXT FIELD shm01
#       END IF
#              IF p_cmd = 'a' AND cl_null(g_shm.shm01[5,10]) AND g_smy.smyauno = 'N'
#           THEN NEXT FIELD shm01
#              END IF
#              IF g_shm.shm01 != g_shm_t.shm01 OR g_shm_t.shm01 IS NULL THEN
#                  IF g_smy.smyauno = 'Y' AND NOT cl_chk_data_continue(g_shm.shm01[5,10]) THEN
#                     CALL cl_err('','9056',0) NEXT FIELD shm01
#                  END IF
#                  SELECT COUNT(*) INTO l_cnt FROM shm_file
#                      WHERE shm01 = g_shm.shm01
#                  IF l_cnt > 0 THEN   #資料重複
#                      CALL cl_err(g_shm.shm01,-239,0)
#                      LET g_shm.shm01 = g_shm_t.shm01
#                      DISPLAY BY NAME g_shm.shm01
#                      NEXT FIELD shm01
#                  END IF
#              END IF
         #No.FUN-550067 ---end---
            END IF
#----------------------No.MOD-660066 modify
#{       AFTER FIELD shm012
         AFTER FIELD shm012
#----------------------No.MOD-660066 end
            IF NOT cl_null(g_shm.shm012) THEN
               CALL i310_shm012('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_shm.shm012,g_errno,0)
                  LET g_shm.shm012 = g_shm_t.shm012
                  DISPLAY BY NAME g_shm.shm012
                  NEXT FIELD shm012
               END IF
            END IF
#}               #No.MOD-660066 mark
        AFTER FIELD shm13
            IF not cl_null(g_shm.shm13) THEN
              #CHI-690066--begin 
               #IF NOT s_daywk(g_shm.shm13) THEN NEXT FIELD shm13 END IF
               LET li_result = 0
               CALL s_daywk(g_shm.shm13) RETURNING li_result
               IF li_result = 0 THEN   #0:非工作日
                  CALL cl_err(g_shm.shm13,'mfg3152',0)
                  NEXT FIELD shm13
               END IF
               IF li_result = 2 THEN   #2:未設定
                  CALL cl_err(g_shm.shm13,'mfg3153',0)
                  NEXT FIELD shm13
               END IF
              #CHI-690066--end
               IF g_shm.shm15 IS NULL THEN
                  LET g_shm.shm15=g_shm.shm13+
                              #(g_ima.ima59+g_ima.ima60*g_shm.shm08+g_ima.ima61)  #No.FUN-840194 #CHI-810015 mark還原 
                              (g_ima.ima59+g_ima.ima60/g_ima.ima601*g_shm.shm08+g_ima.ima61)  #No.FUN-840194 #CHI-810015 mark還原 
                            #CHI-810015---mark---str---
                            ##FUN-710073---mod---str---
                            # ((g_ima.ima59/g_ima.ima56)+
                            #  (g_ima.ima60/g_ima.ima56)*g_shm.shm08+
                            #  (g_ima.ima61/g_ima.ima56))                         
                            ##(g_ima.ima59+g_ima.ima60*g_shm.shm08+g_ima.ima61)   
                            ##FUN-710073---mod---end---
                            #CHI-810015---mark---end---
 
                  DISPLAY BY NAME g_shm.shm15
               END IF
               IF g_shm.shm15 < g_shm.shm13 THEN  CALL cl_err('','asf1002',0) NEXT FIELD shm13 END IF  #No.TQC-740020
            END IF
 
        AFTER FIELD shm15
            IF NOT cl_null(g_shm.shm15) THEN
             #CHI-690066--begin
               #IF NOT s_daywk(g_shm.shm15) THEN NEXT FIELD shm15 END IF
               LET li_result = 0
               CALL s_daywk(g_shm.shm15) RETURNING li_result
               IF li_result = 0 THEN   #0:非工作日
                  CALL cl_err(g_shm.shm15,'mfg3152',0)
                  NEXT FIELD shm15
               END IF
               IF li_result = 2 THEN   #2:未設定
                  CALL cl_err(g_shm.shm15,'mfg3153',0)
                  NEXT FIELD shm15
               END IF
              #CHI-690066--end
              #IF g_shm.shm15 < g_shm.shm13 THEN NEXT FIELD shm13 END IF  #No.TQC-740020
               IF g_shm.shm15 < g_shm.shm13 THEN CALL cl_err('','asf1002',0) NEXT FIELD shm15 END IF  #No.TQC-740020
               IF g_shm.shm13 IS NULL THEN
                  IF g_sfb.sfb93<>'Y' THEN   #使用製程
                     LET g_shm.shm13=g_shm.shm15-
                                (g_ima.ima59+g_ima.ima60*g_shm.shm08+g_ima.ima61)   #CHI-810015 mark還原 
                               #CHI-810015---mark---str---
                               ##FUN-710073---mod---str---
                               # ((g_ima.ima59/g_ima.ima56)+
                               #  (g_ima.ima60/g_ima.ima56)*g_shm.shm08+
                               #  (g_ima.ima61/g_ima.ima56))                
                               ##(g_ima.ima59+g_ima.ima60*g_shm.shm08+g_ima.ima61)    
                               ##FUN-710073---mod---end---
                               #CHI-810015---mark---end---
                     DISPLAY BY NAME g_shm.shm13
                  END IF
               END IF
            END IF
 
        AFTER FIELD shm08
            IF NOT cl_null(g_shm.shm08) THEN
               IF g_shm.shm08 <=0 THEN NEXT FIELD shm08  END IF
           #-->相同工單其Run Card 總計不可大於工單生產數量
               SELECT sum(shm08) INTO l_sum FROM shm_file
                 WHERE shm012 = g_shm.shm012
                   AND shm01 != g_shm.shm01
               IF l_sum IS NULL THEN LET l_sum=0 END IF
               IF g_shm.shm08 IS NULL THEN LET g_shm.shm08=0 END IF
               IF (l_sum + g_shm.shm08)  > g_sfb.sfb08 THEN
                  CALL cl_err(g_shm.shm08,'asf-742',0)
                  LET g_shm.shm08 = g_shm_t.shm08
                  DISPLAY BY NAME g_shm.shm08
                  NEXT FIELD shm08
               END IF
            END IF
 
        ON ACTION controlp
           CASE WHEN INFIELD(shm01) #Run Card
#                    LET g_t1=g_shm.shm01[1,3]
                     LET g_t1 = s_get_doc_no(g_shm.shm01)     #No.FUN-550067
                    #CALL q_smy( FALSE,TRUE,g_t1,'asf','2') RETURNING g_t1  #TQC-670008
                     CALL q_smy( FALSE,TRUE,g_t1,'ASF','2') RETURNING g_t1  #TQC-670008
#                     CALL FGL_DIALOG_SETBUFFER( g_t1 )
#                    LET g_shm.shm01[1,3]=g_t1
                     LET g_shm.shm01 = g_t1                 #No.FUN-550067
                     DISPLAY BY NAME g_shm.shm01
                     NEXT FIELD shm01
                WHEN INFIELD(shm012) #工單
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_sfb02"
                     LET g_qryparam.construct= "Y"
                     LET g_qryparam.default1 = g_shm.shm012
                     LET g_qryparam.arg1     = "12345"
                     CALL cl_create_qry() RETURNING g_shm.shm012
                     DISPLAY BY NAME g_shm.shm012
                     NEXT FIELD shm012
#                    CALL FGL_DIALOG_SETBUFFER( g_shm.shm012 )
                WHEN INFIELD(shm06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_ecu"
                     LET g_qryparam.default1 = g_shm.shm06
                     CALL cl_create_qry() RETURNING g_shm.shm06
#                     CALL FGL_DIALOG_SETBUFFER( g_shm.shm06 )
                     DISPLAY g_shm.shm06 TO s_shm.shm06
                     NEXT FIELD shm06
                OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       #MOD-650015 --start
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(shm01) THEN
       #         LET g_shm.* = g_shm_t.*
       #         CALL i310_show()
       #         NEXT FIELD shm01
       #     END IF
       #MOD-650015 --end
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
    END INPUT
END FUNCTION
#FUN-B10056 -----------------------Begin--------------------------------
FUNCTION i310_chkbom()
   DEFINE l_sql        STRING
   DEFINE l_cnt        LIKE type_file.num10
   DEFINE l_count      LIKE type_file.num10
   DEFINE i            LIKE type_file.num10   
   DEFINE l_n          LIKE type_file.num10
   DEFINE l_sgm012     LIKE sgm_file.sgm012    #FUN-B30011
   DEFINE l_sgm015     LIKE sgm_file.sgm015    #FUN-B30011
   DEFINE m_sgm015     LIKE sgm_file.sgm015    #FUN-B20078
 
   LET g_success = 'Y'
   LET l_sql = "SELECT DISTINCT sgm012,sgm015 FROM sgm_file WHERE sgm01 = '",g_shm.shm01,"'"  
     
   PREPARE p310_pb FROM l_sql
   DECLARE p310_pb_cs CURSOR FOR p310_pb
   LET g_flag_i310 = 'N'
   LET l_count = 0 
#FUN-B20078 ----------------------Begin-------------------------
   DECLARE i310_sgm015_cs CURSOR FOR
      SELECT DISTINCT sgm015 FROM sgm_file
       WHERE sgm01 = g_shm.shm01
         AND (sgm015 IS NOT NULL OR sgm015 <> ' ')
   FOREACH i310_sgm015_cs INTO m_sgm015
      LET l_n = 0
      IF cl_null(m_sgm015) THEN
          CONTINUE FOREACH
      END IF
      SELECT COUNT(*) INTO l_n FROM sgm_file
       WHERE sgm012 = m_sgm015
         AND sgm01 = g_shm.shm01
      IF l_n < 1 THEN
         CALL cl_err(m_sgm015,'aec-066',1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH
#FUN-B20078 ----------------------End---------------------------
   SELECT COUNT(DISTINCT sgm012) INTO l_count FROM sgm_file
    WHERE sgm01=g_shm.shm01
      AND (sgm015 IS NOT NULL OR sgm015 <> ' ')
   IF l_count = 0  THEN
      SELECT COUNT(DISTINCT sgm012) INTO l_count FROM sgm_file WHERE sgm01=g_shm.shm01
      IF l_count > 1 THEN
         CALL cl_err('','aec-045',1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   LET l_cnt = 0
   DECLARE i310_cs1 CURSOR FOR
    SELECT COUNT(DISTINCT sgm015),sgm012 FROM sgm_file
     WHERE sgm01=g_shm.shm01
     GROUP BY sgm012
   FOREACH i310_cs1 INTO l_cnt,l_sgm012
     IF l_cnt > 1 THEN
        CALL cl_err(l_sgm012,'aec-064',1)
        LET g_success = 'N'
        RETURN
     END IF
   END FOREACH

   INITIALIZE l_sgm012 TO NULL 
   INITIALIZE l_sgm015 TO NULL 
   FOREACH p310_pb_cs INTO l_sgm012,l_sgm015 
      LET g_flag_i310='Y'
      IF g_success = 'Y' THEN 
         LET g_max = 1 
         LET g_sgm012_a[1] = l_sgm012  
         CALL i310_bom(0,g_shm.shm01,l_sgm012,l_sgm015)  
      ELSE
         EXIT FOREACH 
      END IF    
   END FOREACH 
   LET l_cnt = 0 
        SELECT COUNT(DISTINCT sgm012) INTO l_cnt FROM sgm_file
         WHERE sgm01 = g_shm.shm01     
           AND (sgm015 IS NULL OR sgm015 = ' ')
        IF l_cnt > 1 THEN
           CALL cl_err('','aec-045',1)
           LET g_success = 'N'
        END IF
        IF l_cnt = 0 THEN
           CALL cl_err('','aec-041',1)
           LET g_success = 'N'
        END IF

   IF g_flag_i310 = 'N' THEN
      CALL cl_err('','aec-049',1)
      LET g_success  = 'N'
   END IF
   IF g_success = 'Y' THEN
      CALL cl_err('','aec-046',1)
   END IF
END FUNCTION

FUNCTION i310_bom(p_level,p_sgm01,p_sgm012,p_sgm015)
DEFINE p_level  LIKE type_file.num5
DEFINE p_key    LIKE sgm_file.sgm012
DEFINE l_ac,i   LIKE type_file.num5
DEFINE arrno    LIKE type_file.num5
DEFINE l_sql    STRING
DEFINE sr       DYNAMIC ARRAY OF RECORD
                  sgm012 LIKE sgm_file.sgm012,
                  sgm015 LIKE sgm_file.sgm015
                END RECORD
DEFINE l_tot    LIKE type_file.num5
DEFINE l_times  LIKE type_file.num5
DEFINE p_sgm01  LIKE sgm_file.sgm01   #FUN-B30011
DEFINE p_sgm012 LIKE sgm_file.sgm012  #FUN-B30011
DEFINE p_sgm015 LIKE sgm_file.sgm015  #FUN-B30011

   LET g_chr_i310 = 'Y'
   LET p_level = p_level + 1
   IF p_level=1 THEN
       LET sr[1].sgm015 = p_sgm012  
   END IF

   LET arrno = 600

 WHILE TRUE
   LET l_sql="SELECT DISTINCT sgm012,sgm015 FROM sgm_file",
             " WHERE sgm01 = '",p_sgm01,"'",
             "   AND sgm015= '",p_sgm012,"'"

   PREPARE p310_pb_1 FROM l_sql
   DECLARE p310_pb_1_cs CURSOR FOR p310_pb_1
   LET l_times=1
   LET l_ac = 1
   FOREACH p310_pb_1_cs INTO sr[l_ac].*
      LET l_ac = l_ac + 1
      IF l_ac > arrno THEN
         EXIT FOREACH
      END IF
   END FOREACH

   LET l_tot = l_ac - 1
   FOR i = 1 TO l_tot
      FOR g_cnt_i310=1 TO g_max
          IF sr[i].sgm012 = p_sgm015 THEN     
             CALL cl_err('','aec-047',1)   
              LET g_chr_i310 = 'N'
              LET g_success = 'N'
              EXIT FOR
           END IF
      END FOR
      IF g_chr_i310 = 'N' THEN
         EXIT FOR
      END IF
      IF sr[i].sgm015 IS NOT NULL THEN
         LET g_max = g_max + 1
      END IF
      LET g_sgm012_a[g_max] = sr[i].sgm012
      CALL i310_bom(p_level,g_shm.shm01,sr[i].sgm012,p_sgm015)
   END FOR

   IF l_tot < arrno OR l_tot=0 THEN
      EXIT WHILE
   END IF

   END WHILE
   LET g_max = g_max - 1
END FUNCTION
#FUN-B10056 -----------------------End----------------------------------
 
FUNCTION i310_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("shm01,shm012,shm08",TRUE)
       CALL cl_set_comp_entry("shm18",TRUE)             #TQC-B10171 
    END IF
 
END FUNCTION
 
FUNCTION i310_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("shm01,shm012,shm08",FALSE)
       CALL cl_set_comp_entry("shm18",FALSE)         #TQC-B10171
    END IF
 
END FUNCTION
 
FUNCTION i310_process_b()   #新增時給予單身default值
   DEFINE  l_chr        LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
  #IF g_sfb.sfb87 = 'Y'   THEN CALL cl_err('','asf-923',0) RETURN END IF
   IF g_sfb.sfb87 = 'N'   THEN CALL cl_err('','asf-104',0) RETURN END IF
   IF cl_null(g_shm.shm06)  THEN RETURN END IF
   #-->產生Run Card 製程追蹤檔(sgm_file)
    CALL s_runcard(g_shm.shm01,g_shm.shm012,g_shm.shm06,
                   g_shm.shm05,g_shm.shm08)
       RETURNING g_errno
       IF not cl_null(g_errno)  THEN
          CALL cl_err(g_shm.shm01,g_errno,0)
          LET g_success = 'N' RETURN
       END IF
END FUNCTION
 
FUNCTION i310_b()
DEFINE
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680121 VARCHAR(1)
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680121 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用        #No.FUN-680121 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680121 VARCHAR(1)
    l_sgm03         LIKE type_file.num10,               #No.FUN-680121  INTEGER
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680121 SMALLINT
DEFINE l_sgm02      LIKE sgm_file.sgm02     #No.MOD-670003
DEFINE l_sgm03_par  LIKE sgm_file.sgm03_par #No.MOD-670003
DEFINE l_sgm03_s    LIKE sgm_file.sgm03     #MOD-910154
DEFINE l_sgm301     LIKE sgm_file.sgm301    #MOD-910154
DEFINE l_sgm012_n   LIKE sgm_file.sgm012    #FUN-A60095
DEFINE l_sgm03_n    LIKE sgm_file.sgm03     #FUN-A60095
DEFINE l_cnt1       LIKE type_file.num5     #FUN-B20078 
DEFINE l_sgm62_b    LIKE sgm_file.sgm62,    #MOD-CC0224 add
       l_sgm63_b    LIKE sgm_file.sgm63     #MOD-CC0224 add
DEFINE l_x          LIKE type_file.num5     #add by guanyao160808
 
    LET g_action_choice = ""
 
    IF g_shm.shm01 IS NULL THEN RETURN END IF
    IF g_sfb.sfb04 ='8' THEN CALL cl_err('','aap-730',0) RETURN END IF
    #str----add by guanyao160808
    LET l_x = 0
    SELECT COUNT(*) INTO l_x FROM tc_shc_file WHERE tc_shc03 = g_shm.shm01 
    IF l_x >0 THEN
       CALL cl_err('','csf-071',0) 
       RETURN 
    END IF 
    LET l_x = 0
    SELECT COUNT(*) INTO l_x FROM tc_shb_file WHERE tc_shb03 = g_shm.shm01 
 
  IF g_user='tiptop'  THEN LET l_x=0 END IF   #ly18014
  IF g_user='20233'   THEN LET  l_x=0 END IF  #ly180614
 
   IF l_x > 0 THEN 
       CALL cl_err('','csf-071',0) 
       RETURN 
    END IF 
    #end----add by guanyao160808
     #MOD-510117
   #IF g_sfb.sfb87 = 'Y'   THEN CALL cl_err('','asf-923',0) RETURN END IF
    SELECT COUNT(*) INTO g_cnt FROM sha_file
     WHERE sha08=g_shm.shm01
  IF g_user='tiptop'  THEN LET g_cnt=0 END IF   #ly18014
  IF g_user='20233'   THEN LET g_cnt=0 END IF  #ly180614

    IF g_cnt > 0 THEN CALL cl_err('exists sha','asf-938',0) RETURN END IF
 
    SELECT COUNT(*) INTO g_cnt FROM shb_file
     WHERE shb16=g_shm.shm01
       AND shbconf = 'Y'    #FUN-A70095
  IF g_user='tiptop'  THEN LET  g_cnt=0 END IF   #ly18014
  IF g_user='20233'   THEN LET  g_cnt=0 END IF  #ly180614

    IF g_cnt > 0 THEN CALL cl_err('exists shb','asf-938',0) RETURN END IF
    #--
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
    #   "SELECT sgm03,sgm011,sgm012,'',sgm04,sgm45,sgm05,'',sgm66,sgm52,", #FUN-A60095    #FUN-A80150 add sgm66    #FUN-B10056 mark
    #   "SELECT sgm03,sgm011,sgm012,sgm014,sgm015,sgm04,sgm45,sgm05,'',sgm66,sgm52,",     #FUN-B10056 add sgm015   #FUN-B20078 mark
        "SELECT sgm03,sgm011,sgm012,sgm014,sgm015,'',sgm04,sgm45,sgm05,'',sgm66,sgm52,",  #FUN-B20078
        " sgm321,sgm53,sgm54,sgm67,sgm06,sgm13,",  #FUN-A60095      #FUN-A80150 add sgm67
        " sgm14,sgm15,sgm16,sgm49,sgm50,sgm51,sgm55,sgm56,sgm58,",   #FUN-A60095
        " sgm62,sgm63,sgm65,sgm12,sgm34,sgm64,ta_sgm01,ta_sgm02,ta_sgm03,ta_sgm06 ",  #FUN-A60095   #str—add by huanglf 160713
        " FROM sgm_file",
        " WHERE sgm01  = ?  AND sgm03 = ?  AND sgm012 = ? FOR UPDATE" #FUN-A60095
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i310_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    #CKP
    IF g_rec_b=0 THEN CALL g_sgm.clear() END IF
 
    INPUT ARRAY g_sgm WITHOUT DEFAULTS FROM s_sgm.*
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
 
            OPEN i310_cl USING g_shm.shm01
            IF STATUS THEN
               CALL cl_err("OPEN i310_cl:", STATUS, 1)
               CLOSE i310_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i310_cl INTO g_shm.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err('lock shm:',SQLCA.sqlcode,0)     # 資料被他人LOCK
                CLOSE i310_cl ROLLBACK WORK RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_sgm_t.* = g_sgm[l_ac].*  #BACKUP
                OPEN i310_bcl USING g_shm.shm01,g_sgm_t.sgm03,g_sgm_t.sgm012 #FUN-A60095
                IF STATUS THEN
                   CALL cl_err("OPEN i310_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                END IF
                FETCH i310_bcl INTO g_sgm[l_ac].*
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_sgm_t.sgm03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                END IF
                CALL i310_sgm06('d',l_ac)
                CALL i310_sgm014(g_sgm[l_ac].sgm015) RETURNING g_sgm[l_ac].ecr02     #FUN-B20078
            #   CALL i310_sgm012('d')  　　 #FUN-A60095     #FUN-B10056
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            IF l_ac <= l_n THEN
               CALL i310_sgm06('d',l_ac)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_sgm[l_ac].* TO NULL      #900423
            LET l_sgm02     = g_shm.shm012   #No.MOD-670003
            LET l_sgm03_par = g_shm.shm05    #No.MOD-670003
            LET g_sgm[l_ac].sgm14 = 0
            LET g_sgm[l_ac].sgm13 = 0
            LET g_sgm[l_ac].sgm49 = 0
            LET g_sgm[l_ac].sgm66 = 'Y'    #FUN-A80150 add
            #FUN-A60095--begin--add--------
            LET g_sgm[l_ac].sgm52 = 'N'
            LET g_sgm[l_ac].sgm53 = 'N'
            LET g_sgm[l_ac].sgm54 = 'N'
            LET g_sgm[l_ac].sgm62 = 1
            LET g_sgm[l_ac].sgm63 = 1
            LET g_sgm[l_ac].sgm321= 0
            LET g_sgm[l_ac].sgm65 = 0
            LET g_sgm[l_ac].sgm12 = 0
            LET g_sgm[l_ac].sgm34 = 0
            LET g_sgm[l_ac].sgm64 = 1
            #FUN-A60095--end--add----------
            LET g_sgm_t.* = g_sgm[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD sgm03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF cl_null(g_sgm[l_ac].sgm012) THEN LET g_sgm[l_ac].sgm012 = ' ' END IF #FUN-A60095
            IF cl_null(g_sgm[l_ac].sgm03) THEN LET g_sgm[l_ac].sgm03 = 0 END IF #No.FUN-A70131
            IF cl_null(g_sgm[l_ac].sgm66) THEN LET g_sgm[l_ac].sgm66 = 'Y' END IF #FUN-A80150 add
#FUN-B10056 -----------------------Begin----------------------             
            IF g_sgm[l_ac].sgm015 IS NULL THEN
               LET g_sgm[l_ac].sgm015 = ' '
            END IF
#FUN-B10056 -----------------------End------------------------
            INSERT INTO sgm_file(sgm01,sgm03,sgm04,sgm45,sgm67,sgm06,sgm14,     #FUN-A80150 add sgm67
                                 sgm13,sgm16,sgm15,sgm49,
                                 sgm50,sgm51,sgm05,sgm66,        #FUN-A80150 add sgm66
                                 sgm52,sgm53,sgm54,sgm55,sgm56,
                                 sgm58,  #FUN-A60095
                                 sgm014, #FUN-B10056
                                 sgm015, #FUN-B10056
                                 sgm301,sgm302,sgm303,sgm304,
                                 sgm311,sgm312,sgm313,sgm314,
                                 sgm315,sgm316,sgm317, #sgm321,        #FUN-A60095
                                 sgm322,sgm291,sgm292,sgm02,sgm03_par, #No.MOD-670003
                                 sgmplant,sgmlegal,sgmoriu,sgmorig,    #FUN-980008 add
                                 sgm011,sgm012,sgm62,sgm63,sgm321,sgm65,sgm12,sgm34,sgm64,
                                 ta_sgm01,ta_sgm02,ta_sgm03,ta_sgm06) #FUN-A60095 #str—add by huanglf 160713
                          VALUES(g_shm.shm01,g_sgm[l_ac].sgm03,
                                 g_sgm[l_ac].sgm04,g_sgm[l_ac].sgm45,
                                 g_sgm[l_ac].sgm67,                    #FUN-A80150 add
                                 g_sgm[l_ac].sgm06,g_sgm[l_ac].sgm14,
                                 g_sgm[l_ac].sgm13,g_sgm[l_ac].sgm16,
                                 g_sgm[l_ac].sgm15,
                                 g_sgm[l_ac].sgm49,g_sgm[l_ac].sgm50,
                                 g_sgm[l_ac].sgm51,g_sgm[l_ac].sgm05,
                                 g_sgm[l_ac].sgm66,          #FUN-A80150 add
                                 g_sgm[l_ac].sgm52,g_sgm[l_ac].sgm53,
                                 g_sgm[l_ac].sgm54,g_sgm[l_ac].sgm55,
                                 g_sgm[l_ac].sgm56,  #FUN-A60095
                                 g_sgm[l_ac].sgm58,  #FUN-A60095
                                 g_sgm[l_ac].sgm014, #FUN-B10056
                                 g_sgm[l_ac].sgm015, #FUN-B10056
                                 0,0,0,0,0,0,0,0,0,0,0,0,0,0,l_sgm02,l_sgm03_par, #No.MOD-670003 #FUN-A60095
                                 g_plant,g_legal, g_user, g_grup, #FUN-980008 add      #No.FUN-980030 10/01/04  insert columns oriu, orig
                                 g_sgm[l_ac].sgm011,g_sgm[l_ac].sgm012,g_sgm[l_ac].sgm62, #FUN-A60095
                                 g_sgm[l_ac].sgm63,g_sgm[l_ac].sgm321,g_sgm[l_ac].sgm65,  #FUN-A60095
                                 g_sgm[l_ac].sgm12,g_sgm[l_ac].sgm34,g_sgm[l_ac].sgm64,
                                 g_sgm[l_ac].ta_sgm01,g_sgm[l_ac].ta_sgm02,g_sgm[l_ac].ta_sgm03,g_sgm[l_ac].ta_sgm06)   #FUN-A60095 #str—add by huanglf 160713
            IF SQLCA.sqlcode THEN
#               CALL cl_err('ins sgm:',SQLCA.sqlcode,0)   #No.FUN-660128
                CALL cl_err3("ins","sgm_file",g_shm.shm01,g_sgm[l_ac].sgm03,SQLCA.sqlcode,"","ins sgm",1)  #No.FUN-660128
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                CALL i310_chk_sgm011()    #FUN-B10056
            END IF
 
        BEFORE FIELD sgm03                        #default 序號
            IF g_sgm[l_ac].sgm03 IS NULL OR
               g_sgm[l_ac].sgm03 = 0 THEN
               SELECT max(sgm03) INTO g_sgm[l_ac].sgm03 FROM sgm_file
                WHERE sgm01 = g_shm.shm01
                IF g_sgm[l_ac].sgm03 IS NULL THEN
                    LET g_sgm[l_ac].sgm03 = 0
                END IF
                LET g_sgm[l_ac].sgm03 = g_sgm[l_ac].sgm03 + g_sma.sma849
            END IF
 
        AFTER FIELD sgm03
            IF NOT cl_null(g_sgm[l_ac].sgm03) THEN
               IF g_sgm[l_ac].sgm03 != g_sgm_t.sgm03 OR g_sgm_t.sgm03 IS NULL OR
                  g_sgm[l_ac].sgm012 != g_sgm_t.sgm012 OR g_sgm_t.sgm012 IS NULL THEN #FUN-A60095
                   SELECT MAX(sgm03) INTO l_sgm03 FROM sgm_file
                    WHERE sgm01 = g_shm.shm01
                   SELECT COUNT(*) INTO l_n FROM sgm_file
                    WHERE sgm03 = g_sgm[l_ac].sgm03
                      AND sgm01 = g_shm.shm01
                      AND sgm012= g_sgm[l_ac].sgm012 #FUN-A60095
                   IF l_n > 0 THEN CALL cl_err('','100',0) NEXT FIELD sgm03 END IF
               END IF
            END IF

#FUN-B10056 ------------------------------Begin---------------------------------
        AFTER FIELD sgm015
           IF NOT cl_null(g_sgm[l_ac].sgm015) THEN
#FUN-B20078 ------------------------------Begin---------------------------------
           #  IF NOT s_runcard_sgm012(g_shm.shm01,g_sgm[l_ac].sgm015) THEN   
           #      NEXT FIELD sgm015  
           #   END IF               
              SELECT COUNT(*) INTO l_cnt1 FROM ecr_file
               WHERE ecr01 = g_sgm[l_ac].sgm015
                 AND ecracti = 'Y'
              IF l_cnt1 < = 0 THEN
                 CALL cl_err(g_sgm[l_ac].sgm015,'aec-050',0)
                 NEXT FIELD sgm015
              END IF
              CALL i310_sgm014(g_sgm[l_ac].sgm015) RETURNING g_sgm[l_ac].ecr02 
              DISPLAY BY NAME g_sgm[l_ac].ecr02   
           END IF           
#FUN-B10056 ------------------------------End-----------------------------------
#FUN-A60095--begin--add---------------
        AFTER FIELD sgm012
            IF NOT cl_null(g_sgm[l_ac].sgm012) THEN
               IF g_sgm[l_ac].sgm03 != g_sgm_t.sgm03  OR g_sgm_t.sgm03  IS NULL OR
                  g_sgm[l_ac].sgm012!= g_sgm_t.sgm012 OR g_sgm_t.sgm012 IS NULL THEN
                   SELECT COUNT(*) INTO l_n FROM sgm_file
                    WHERE sgm03 = g_sgm[l_ac].sgm03
                      AND sgm012= g_sgm[l_ac].sgm012
                      AND sgm01 = g_shm.shm01
                   IF l_n > 0 THEN CALL cl_err('','aec-313',0)
                      NEXT FIELD sgm012
                   END IF
#FUN-B20078 --------------------Begin---------------------------
            IF g_sgm[l_ac].sgm012 != g_sgm_t.sgm012 OR g_sgm_t.sgm012 IS NULL THEN 
               SELECT COUNT(*) INTO l_cnt1 FROM ecr_file
                WHERE ecr01 = g_sgm[l_ac].sgm012
                  AND ecracti = 'Y'
               IF l_cnt1 < = 0 THEN
                  CALL cl_err(g_sgm[l_ac].sgm012,'aec-050',0)
                  NEXT FIELD sgm012
               END IF
               CALL i310_sgm014(g_sgm[l_ac].sgm012) RETURNING g_sgm[l_ac].sgm014
            END IF
            DISPLAY BY NAME g_sgm[l_ac].sgm014
#FUN-B20078 --------------------End-----------------------------
               END IF
#FUN-B10056 --------------------Begin---------------------------
           #CALL i310_sgm012('a')
            SELECT sgm014,sgm015 INTO g_sgm[l_ac].sgm014,g_sgm[l_ac].sgm015 FROM sgm_file             
            WHERE sgm01 = g_shm.shm01
              AND sgm03 = g_sgm[l_ac].sgm03
              AND sgm012 = g_sgm[l_ac].sgm012
            IF g_sgm[l_ac].sgm015 IS NULL THEN
               LET g_sgm[l_ac].sgm015 = ' '
            END IF  
#FUN-B10056 --------------------End-----------------------------                 
               IF NOT cl_null(g_errno) THEN
                  LET g_sgm[l_ac].sgm012 = g_sgm_t.sgm012
                  NEXT FIELD sgm012
               END IF
            END IF  
 
        AFTER FIELD sgm62
            IF NOT cl_null(g_sgm[l_ac].sgm62) THEN
               IF g_sgm[l_ac].sgm62 <= 0 THEN
                  CALL cl_err(g_sgm[l_ac].sgm62,'axr-034',1)
                  NEXT FIELD sgm62
               END IF
            END IF

        AFTER FIELD sgm63
            IF NOT cl_null(g_sgm[l_ac].sgm63) THEN
               IF g_sgm[l_ac].sgm63 <= 0 THEN
                  CALL cl_err(g_sgm[l_ac].sgm63,'axr-034',1)
                  NEXT FIELD sgm63
               END IF
            END IF

        AFTER FIELD sgm64
            IF NOT cl_null(g_sgm[l_ac].sgm64) THEN
               IF g_sgm[l_ac].sgm64 <= 0 THEN
                  CALL cl_err(g_sgm[l_ac].sgm64,'axr-034',1)
                  NEXT FIELD sgm64
               END IF
            END IF

        AFTER FIELD sgm12
            IF NOT cl_null(g_sgm[l_ac].sgm12) THEN
               IF g_sgm[l_ac].sgm12 < 0 THEN
                  CALL cl_err(g_sgm[l_ac].sgm12,'axm-179',1)
                  NEXT FIELD sgm12
               END IF
            END IF

        AFTER FIELD sgm34
            IF NOT cl_null(g_sgm[l_ac].sgm34) THEN
               IF g_sgm[l_ac].sgm34 < 0 THEN
                  CALL cl_err(g_sgm[l_ac].sgm34,'axm-179',1)
                  NEXT FIELD sgm34
               END IF
            END IF
#FUN-A60095--end--add-------------

        AFTER FIELD sgm04
            IF NOT cl_null(g_sgm[l_ac].sgm04) THEN
               CALL i310_sgm04('a')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('sel sgd',g_errno,0)
                  NEXT FIELD sgm04
               END IF
            END IF
 
       #FUN-A80150---add---start---
        AFTER FIELD sgm67 
            IF NOT cl_null(g_sgm[l_ac].sgm67) THEN
               CALL i310_sgm67()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_sgm[l_ac].sgm67,g_errno,0)
                  NEXT FIELD sgm67
               END IF
            END IF
       #FUN-A80150---add---end---

        AFTER FIELD sgm06                  #check 序號是否重複
            IF NOT cl_null(g_sgm[l_ac].sgm06) THEN
               CALL i310_sgm06('a',l_ac)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_sgm[l_ac].sgm06 = g_sgm_t.sgm06
                  NEXT FIELD sgm06
               END IF
            END IF
 
        AFTER FIELD sgm05
            IF NOT cl_null(g_sgm[l_ac].sgm05) THEN
               SELECT COUNT(*) INTO l_cnt FROM eci_file
                WHERE eci01 = g_sgm[l_ac].sgm05
               IF cl_null(l_cnt) OR l_cnt = 0  THEN
                  CALL cl_err('','mfg4010',0)
                  LET g_sgm[l_ac].sgm05 = g_sgm_t.sgm05
                  NEXT FIELD sgm05
               END IF
            END IF
 
#genero
#            IF NOT cl_prich3(g_shm.shmuser,g_shm.shmgrup,'R') THEN
#               NEXT FIELD sgm13
#            END IF
 
#No.TQC-6C0230 --begin
        AFTER FIELD sgm50
            IF NOT cl_null(g_sgm[l_ac].sgm50) AND NOT cl_null(g_sgm[l_ac].sgm51) THEN
               IF g_sgm[l_ac].sgm50 > g_sgm[l_ac].sgm51 THEN
                  CALL cl_err(g_sgm[l_ac].sgm50,'asf-105',0)
                  NEXT FIELD sgm50
               END IF
            END IF
 
        AFTER FIELD sgm51
            IF NOT cl_null(g_sgm[l_ac].sgm50) AND NOT cl_null(g_sgm[l_ac].sgm51) THEN
               IF g_sgm[l_ac].sgm50 > g_sgm[l_ac].sgm51 THEN
                  CALL cl_err(g_sgm[l_ac].sgm50,'asf-105',0)
                  NEXT FIELD sgm51
               END IF
            END IF
#No.TQC-6C0230 --end

       #FUN-A80150---add---start---
        AFTER FIELD sgm66 
           IF NOT cl_null(g_sgm[l_ac].sgm66) THEN
              IF g_sgm[l_ac].sgm66 NOT MATCHES '[YN]' THEN
                 CALL cl_err('','aec-079',0)
                 NEXT FIELD sgm66
              END IF 
           ELSE
              NEXT FIELD sgm66
           END IF
       #FUN-A80150---add---end---

        AFTER FIELD sgm52
            IF NOT cl_null(g_sgm[l_ac].sgm52) THEN
               IF g_sgm[l_ac].sgm52 NOT MATCHES '[YN]' THEN
                  CALL cl_err('','aec-079',0)
                  NEXT FIELD sgm52
               END IF
            END IF
 
        AFTER FIELD sgm53
            IF NOT cl_null(g_sgm[l_ac].sgm53) THEN
               IF g_sgm[l_ac].sgm53 NOT MATCHES '[YN]' THEN
                  CALL cl_err('','aec-079',0)
                  NEXT FIELD sgm53
               END IF
            END IF
 
        BEFORE FIELD sgm54
 
            CALL i310_set_entry_b()
 
        AFTER FIELD sgm54
            IF cl_null(g_sgm[l_ac].sgm54) THEN
               IF g_sgm[l_ac].sgm54 NOT MATCHES '[YN]' THEN
                  CALL cl_err('','aec-079',0)
                  NEXT FIELD sgm54
               END IF
               IF g_sgm[l_ac].sgm54 ='Y' THEN
                  NEXT FIELD sgm55
               ELSE
                  LET g_sgm[l_ac].sgm55 = ' '
                  NEXT FIELD sgm56
               END IF
               CALL i310_set_no_entry_b()
            END IF
#No.TQC-740145---Begin
        AFTER FIELD sgm13
           IF g_sgm[l_ac].sgm13<0 THEN
              CALL cl_err('','afa1001',0)
              NEXT FIELD sgm13
           END IF
 
        AFTER FIELD sgm14                                                                                                           
           IF g_sgm[l_ac].sgm14<0 THEN                                                                                              
              CALL cl_err('','afa1001',0)                                                                                           
              NEXT FIELD sgm14                                                                                                      
           END IF
 
        AFTER FIELD sgm15                                                                                                           
           IF g_sgm[l_ac].sgm15<0 THEN                                                                                              
              CALL cl_err('','afa1001',0)                                                                                           
              NEXT FIELD sgm15                                                                                                      
           END IF                                                                                                                   
                                                                                                                                    
        AFTER FIELD sgm16                                                                                                           
           IF g_sgm[l_ac].sgm16<0 THEN                                                                                              
              CALL cl_err('','afa1001',0)                                                                                           
              NEXT FIELD sgm16                                                                                                      
           END IF
#No.TQC-740145 ---End
 
        AFTER FIELD sgm55
 
            IF NOT cl_null(g_sgm[l_ac].sgm55) THEN
               CALL i310_sgg(g_sgm[l_ac].sgm55)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_sgm[l_ac].sgm55=g_sgm_t.sgm55
                  NEXT FIELD sgm55
               END IF
            END IF
 
        AFTER FIELD sgm56
            IF NOT cl_null(g_sgm[l_ac].sgm56) THEN
               CALL i310_sgg(g_sgm[l_ac].sgm56)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_sgm[l_ac].sgm56=g_sgm_t.sgm56
                  NEXT FIELD sgm56
               END IF
            END IF
 
#FUN-A60095--begin--mark-------------
#       AFTER FIELD sgm57
#           IF NOT cl_null(g_sgm[l_ac].sgm57) THEN
#              SELECT COUNT(*) INTO g_cnt FROM gfe_file
#                 WHERE gfe01=g_sgm[l_ac].sgm57
#              IF g_cnt=0 THEN
#                 CALL cl_err(g_sgm[l_ac].sgm57,'mfg2605',0)
#                 NEXT FIELD sgm57
#              END IF
#              IF NOT cl_null(g_sgm[l_ac].sgm58) THEN
#                 IF g_sgm[l_ac].sgm57 = g_sgm[l_ac].sgm58 THEN
#                    LET g_sgm[l_ac].sgm59=1
#                 ELSE
#                    CALL s_umfchk(g_shm.shm05,g_sgm[l_ac].sgm58,g_sgm[l_ac].sgm57)
#                         RETURNING g_sw,g_sgm[l_ac].sgm59
#                    IF g_sw = '1' THEN
#                       CALL cl_err(g_sgm[l_ac].sgm58,'mfg1206',0)
#                       NEXT FIELD sgm58
#                    END IF
#                 END IF
#              END IF
#           END IF
#FUN-A60095--end--mark-------------
 
        AFTER FIELD sgm58
            IF NOT cl_null(g_sgm[l_ac].sgm58) THEN
               SELECT COUNT(*) INTO g_cnt FROM gfe_file
                  WHERE gfe01=g_sgm[l_ac].sgm58
               IF g_cnt=0 THEN
                  CALL cl_err(g_sgm[l_ac].sgm58,'mfg2605',0)
                  NEXT FIELD sgm58
               END IF
              #FUN-A60095--begin--mark-------------
              #IF g_sgm[l_ac].sgm57 = g_sgm[l_ac].sgm58 THEN
              #   LET g_sgm[l_ac].sgm59=1
              #ELSE
              #   CALL s_umfchk(g_shm.shm05,g_sgm[l_ac].sgm58,g_sgm[l_ac].sgm57)
              #        RETURNING g_sw,g_sgm[l_ac].sgm59
              #   IF g_sw = '1' THEN
              #      CALL cl_err(g_sgm[l_ac].sgm58,'mfg1206',0)
              #      NEXT FIELD sgm58
              #   END IF
              #END IF
              #FUN-A60095--end--mark---------------
              LET g_sgm[l_ac].sgm321 = s_digqty(g_sgm[l_ac].sgm321,g_sgm[l_ac].sgm58)    #FUN-BB0085
              DISPLAY BY NAME g_sgm[l_ac].sgm321                                         #FUN-BB0085
              LET g_sgm[l_ac].sgm65  = s_digqty(g_sgm[l_ac].sgm65,g_sgm[l_ac].sgm58)     #FUN-BB0085
              DISPLAY BY NAME g_sgm[l_ac].sgm65                                          #FUN-BB0085
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_sgm_t.sgm03 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
               #MOD-910154-begin-add       
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM sgm_file
                   WHERE sgm01 = g_shm.shm01
               IF  l_cnt <=1 THEN
                   CALL cl_err(g_shm.shm01,'asf-150',1)
                   ROLLBACK WORK CANCEL DELETE
               ELSE
                   LET l_cnt = 0
                  #FUN-A60095--begin--modify-------------- 
                  #SELECT MIN(sgm03) INTO l_sgm03_s FROM sgm_file
                  #    WHERE sgm01 = g_shm.shm01
                  #IF NOT cl_null(l_sgm03_s) AND l_sgm03_s = g_sgm_t.sgm03 THEN
                   IF NOT s_schdat_chk_min_sgm03(g_shm.shm01,g_sgm_t.sgm012,g_sgm_t.sgm03) THEN
                  #FUN-A60095--end--modify---------------- 
                      SELECT sgm301 INTO l_sgm301 FROM sgm_file
                       WHERE sgm01 = g_shm.shm01 AND sgm03 = g_sgm_t.sgm03 #FUN-A60095
                         AND sgm012= g_sgm_t.sgm012  #FUN-A60095
                      CALL i310_next_sgm03() RETURNING l_sgm012_n,l_sgm03_n #FUN-A60095
                     #MOD-CC0224---S
                      SELECT sgm62,sgm63 INTO l_sgm62_b,l_sgm63_b FROM sgm_file
                       WHERE sgm01 = g_shm.shm01 AND sgm03=l_sgm03_n AND sgm012=l_sgm012_n
                      LET l_sgm301 = l_sgm301 /(g_sgm[l_ac].sgm62/g_sgm[l_ac].sgm63) * (l_sgm62_b/l_sgm63_b)
                     #MOD-CC0224---E
                      UPDATE sgm_file SET sgm301 = l_sgm301
                       WHERE sgm01 = g_shm.shm01
                      #FUN-A60095--begin--modify-------  
                      #  AND sgm03 = (SELECT MIN(sgm03) FROM sgm_file
                      #                WHERE sgm01 = g_shm.shm01
                      #                  AND   sgm03 <> l_sgm03_s)
                         AND sgm03 = l_sgm03_n
                         AND sgm012= l_sgm012_n
                      #FUN-A60095--end--modify---------
                       IF  SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                           CALL cl_err3("del","sgm_file",g_shm.shm01,g_sgm_t.sgm03,SQLCA.sqlcode,"","",1)
                           ROLLBACK WORK CANCEL DELETE
                       END IF   
                   END IF
               END IF

    #str---add by huanglf160721

            SELECT COUNT(*) INTO g_cnt FROM tc_pmm_file
                WHERE tc_pmm03 = g_shm.shm01
                  AND tc_pmm08 = g_sgm_t.sgm03
               IF g_cnt>0 THEN
                  CALL cl_err('exists tc_pmm','asf-938',0)
                  ROLLBACK WORK CANCEL DELETE
                  END IF 
    #end---add by hunaglf160721     
               #MOD-910154-end-add       
               DELETE FROM sgm_file
                WHERE sgm01 = g_shm.shm01
                  AND sgm03 = g_sgm_t.sgm03
                  AND sgm012= g_sgm_t.sgm012 #FUN-A60095
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_sgm_t.sgm03,SQLCA.sqlcode,0)   #No.FUN-660128
                  CALL cl_err3("del","sgm_file",g_shm.shm01,g_sgm_t.sgm03,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
 
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
               CALL i310_chk_sgm011()      #FUN-B10056
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_sgm[l_ac].* = g_sgm_t.*
               CLOSE i310_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_sgm[l_ac].sgm03,-263,1)
               LET g_sgm[l_ac].* = g_sgm_t.*
            ELSE
               UPDATE sgm_file SET sgm03=g_sgm[l_ac].sgm03,
                                   sgm04=g_sgm[l_ac].sgm04,
                                   sgm45=g_sgm[l_ac].sgm45,
                                   sgm67=g_sgm[l_ac].sgm67,      #FUN-A80150 add
                                   sgm06=g_sgm[l_ac].sgm06,
                                   sgm14=g_sgm[l_ac].sgm14,
                                   sgm13=g_sgm[l_ac].sgm13,
                                   sgm16=g_sgm[l_ac].sgm16,
                                   sgm15=g_sgm[l_ac].sgm15,
                                   sgm49=g_sgm[l_ac].sgm49,
                                   sgm50=g_sgm[l_ac].sgm50,
                                   sgm51=g_sgm[l_ac].sgm51,
                                   sgm05=g_sgm[l_ac].sgm05,
                                   sgm66=g_sgm[l_ac].sgm66,     #FUN-A80150 add
                                   sgm52=g_sgm[l_ac].sgm52,
                                   sgm53=g_sgm[l_ac].sgm53,
                                   sgm54=g_sgm[l_ac].sgm54,
                                   sgm55=g_sgm[l_ac].sgm55,
                                   sgm56=g_sgm[l_ac].sgm56,
                                  #FUN--A60095--begin--modify---
                                  #sgm57=g_sgm[l_ac].sgm57,
                                   sgm58=g_sgm[l_ac].sgm58,
                                  #sgm59=g_sgm[l_ac].sgm59
                                   sgm011=g_sgm[l_ac].sgm011,
                                   sgm012=g_sgm[l_ac].sgm012,
                                   sgm321=g_sgm[l_ac].sgm321,
                                   sgm62=g_sgm[l_ac].sgm62,
                                   sgm63=g_sgm[l_ac].sgm63,
                                   sgm64=g_sgm[l_ac].sgm64,
                                   #str—add by huanglf 160713
                                   ta_sgm01=g_sgm[l_ac].ta_sgm01,
                                   ta_sgm02=g_sgm[l_ac].ta_sgm02,
                                   ta_sgm03=g_sgm[l_ac].ta_sgm03,
                                   ta_sgm06=g_sgm[l_ac].ta_sgm06,
                                   #end—add by huanglf 160713
                                   sgm65=g_sgm[l_ac].sgm65,
                                   sgm12=g_sgm[l_ac].sgm12,
                                   sgm34=g_sgm[l_ac].sgm34
                                  #FUN-A60095--end--modify------
                                  ,sgm014 = g_sgm[l_ac].sgm014, #FUN-B10056       
                                   sgm015 = g_sgm[l_ac].sgm015  #FUN-B10056
                 WHERE sgm01=g_shm.shm01
                   AND sgm03=g_sgm_t.sgm03
                   AND sgm012=g_sgm_t.sgm012 #FUN-A60095
                 IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_sgm[l_ac].sgm03,SQLCA.sqlcode,0)   #No.FUN-660128
                    CALL cl_err3("upd","sgm_file",g_shm.shm01,g_sgm_t.sgm03,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                    LET g_sgm[l_ac].* = g_sgm_t.*
                 ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                 END IF
#FUN-B10056 ---------------------Begin-----------------------------
                 IF (g_sgm[l_ac].sgm012 <> g_sgm_t.sgm012) OR
                    (g_sgm[l_ac].sgm015 <> g_sgm_t.sgm015) OR
                    (cl_null(g_sgm_t.sgm015) AND NOT cl_null(g_sgm[l_ac].sgm015)) OR
                    (NOT cl_null(g_sgm_t.sgm015) AND cl_null(g_sgm[l_ac].sgm015)) THEN 
                    CALL i310_chk_sgm011()  
                 END IF
#FUN-B10056 ---------------------End-------------------------------
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_sgm[l_ac].* = g_sgm_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_sgm.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i310_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D40030 Add
            CLOSE i310_bcl
            COMMIT WORK
#NO.FUN-6B0031--BEGIN
        ON ACTION CONTROLS           
         CALL cl_set_head_visible("","AUTO")           
#NO.FUN-6B0031--END
#       ON ACTION CONTROLN
#           CALL i310_b_askkey()
#           EXIT INPUT
 
        ON ACTION controlp
           CASE WHEN INFIELD(sgm05)                 #機械編號
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_eci"
                     LET g_qryparam.default1 = g_sgm[l_ac].sgm05
                     CALL cl_create_qry() RETURNING g_sgm[l_ac].sgm05
#                     CALL FGL_DIALOG_SETBUFFER( g_sgm[l_ac].sgm05 )
                      DISPLAY BY NAME g_sgm[l_ac].sgm05  #No.MOD-490371
                     NEXT FIELD sgm05
#FUN-B20078 -------------------------Begin-------------------------------
                WHEN INFIELD(sgm012)                 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_ecr"
                   LET g_qryparam.default1 = g_sgm[l_ac].sgm012
                   CALL cl_create_qry() RETURNING g_sgm[l_ac].sgm012
                   CALL i310_sgm014(g_sgm[l_ac].sgm012) RETURNING g_sgm[l_ac].sgm014
                   DISPLAY BY NAME g_sgm[l_ac].sgm012  
                   NEXT FIELD sgm012
                WHEN INFIELD(sgm015)          
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_ecr"
                   LET g_qryparam.default1 = g_sgm[l_ac].sgm015
                   CALL cl_create_qry() RETURNING g_sgm[l_ac].sgm015
                   CALL i310_sgm014(g_sgm[l_ac].sgm015) RETURNING g_sgm[l_ac].ecr02
                   DISPLAY BY NAME g_sgm[l_ac].sgm015
                   NEXT FIELD sgm015
#FUN-B20078 -------------------------End---------------------------------
               #FUN-A80150---add---start---
                WHEN INFIELD(sgm67) #廠商編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pmc"
                   LET g_qryparam.default1 = g_sgm[l_ac].sgm67
                   CALL cl_create_qry() RETURNING g_sgm[l_ac].sgm67
                   DISPLAY g_sgm[l_ac].sgm67 TO s_sgm[l_ac].sgm67
                   NEXT FIELD sgm67 
               #FUN-A80150---add---end---
                WHEN INFIELD(sgm06)                 #生產站別
                     CALL q_eca(FALSE,TRUE,g_sgm[l_ac].sgm06)
                     RETURNING g_sgm[l_ac].sgm06
#                     CALL FGL_DIALOG_SETBUFFER( g_sgm[l_ac].sgm06 )
                      DISPLAY BY NAME g_sgm[l_ac].sgm06  #No.MOD-490371
                     NEXT FIELD sgm06
 
                WHEN INFIELD(sgm04)                 #作業編號
                     CALL q_ecd( FALSE,TRUE,g_sgm[l_ac].sgm04) RETURNING g_sgm[l_ac].sgm04
#                     CALL FGL_DIALOG_SETBUFFER( g_sgm[l_ac].sgm04 )
                     CALL i310_sgm04('a')
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                     END IF
                      DISPLAY BY NAME g_sgm[l_ac].sgm04   #No.MOD-490371
                     NEXT FIELD sgm04
 
                WHEN INFIELD(sgm55)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_sgg"
                     LET g_qryparam.default1 = g_sgm[l_ac].sgm55
                     CALL cl_create_qry() RETURNING g_sgm[l_ac].sgm55
#                     CALL FGL_DIALOG_SETBUFFER( g_sgm[l_ac].sgm55 )
                      DISPLAY BY NAME g_sgm[l_ac].sgm55    #No.MOD-490371
                     NEXT FIELD sgm55
                WHEN INFIELD(sgm56)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_sgg"
                     LET g_qryparam.default1 = g_sgm[l_ac].sgm56
                     CALL cl_create_qry() RETURNING g_sgm[l_ac].sgm56
#                     CALL FGL_DIALOG_SETBUFFER( g_sgm[l_ac].sgm56 )
                      DISPLAY BY NAME g_sgm[l_ac].sgm56     #No.MOD-490371
                     NEXT FIELD sgm56
               #FUN-A60095--begin--mark------- 
               #WHEN INFIELD(sgm57)
               #     CALL cl_init_qry_var()
               #     LET g_qryparam.form     = "q_gfe"
               #     LET g_qryparam.default1 = g_sgm[l_ac].sgm57
               #     CALL cl_create_qry() RETURNING g_sgm[l_ac].sgm57
#              #      CALL FGL_DIALOG_SETBUFFER( g_sgm[l_ac].sgm57 )
               #      DISPLAY BY NAME g_sgm[l_ac].sgm57      #No.MOD-490371
               #     NEXT FIELD sgm57
               #FUN-A60095--end--mark--------
                WHEN INFIELD(sgm58)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_gfe"
                     LET g_qryparam.default1 = g_sgm[l_ac].sgm58
                     CALL cl_create_qry() RETURNING g_sgm[l_ac].sgm58
#                     CALL FGL_DIALOG_SETBUFFER( g_sgm[l_ac].sgm58 )
                      DISPLAY BY NAME g_sgm[l_ac].sgm58      #No.MOD-490371
                     NEXT FIELD sgm58
                #FUN-A60095--begin--add-----
                WHEN INFIELD(sgm012)                #工艺段号
                   CALL cl_init_qry_var()
                 # LET g_qryparam.form = 'q_ecu012_1'      #FUN-B10056 mark
                   LET g_qryparam.form = 'q_sgm012_1'      #FUN-B10056
                 # LET g_qryparam.arg1 = g_shm.shm05       #FUN-B10056 mark
                 # LET g_qryparam.arg2 = g_shm.shm06       #FUN-B10056 mark
                   LET g_qryparam.arg1 = g_shm.shm012      #FUN-B10056
                   LET g_qryparam.arg2 = g_shm.shm05       #FUN-B10056
                   LET g_qryparam.default1 = g_sgm[l_ac].sgm012
                   CALL cl_create_qry() RETURNING g_sgm[l_ac].sgm012
                   NEXT FIELD sgm012
                 #FUN-A60095--end--add--------
           END CASE
 
        ON ACTION qry_vender
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_pmc"
                     LET g_qryparam.default1 = g_sgm[l_ac].sgm06
                     CALL cl_create_qry() RETURNING g_sgm[l_ac].sgm06
#                     CALL FGL_DIALOG_SETBUFFER( g_sgm[l_ac].sgm06 )
                     NEXT FIELD sgm06
 
        ON ACTION CONTROLO   #沿用所有欄位
            IF INFIELD(sgm03) AND l_ac > 1 THEN
                LET g_sgm[l_ac].* = g_sgm[l_ac-1].*
                NEXT FIELD sgm03
            END IF
 
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
 
    END INPUT
 
    UPDATE shm_file SET shmmodu= g_user,
                        shmdate= TODAY
     WHERE shm01=g_shm.shm01
 
    CLOSE i310_bcl
 
#   CALL i310_delall() #CHI-C30002 mark
    CALL i310_delHeader()     #CHI-C30002 add
 
END FUNCTION
#FUN-B20078 ---------------------Begin------------------------
FUNCTION i310_sgm014(p_ecr01)
DEFINE   p_ecr01     LIKE ecr_file.ecr01
DEFINE   l_ecr02     LIKE ecr_file.ecr02
   SELECT DISTINCT sgm014 INTO l_ecr02 FROM sgm_file
    WHERE sgm01 = g_shm.shm01
      AND sgm012 = p_ecr01
   IF cl_null(l_ecr02) THEN 
      SELECT ecr02 INTO l_ecr02 FROM ecr_file
       WHERE ecr01 = p_ecr01
         AND ecracti = 'Y'
#MOD-B30427 ------------------Begin------------------
#       IF SQLCA.sqlcode THEN
#          CALL cl_err(p_ecr01,SQLCA.sqlcode,0)
#       END IF
#MOD-B30427 ------------------End--------------------
   END IF
   RETURN l_ecr02
END FUNCTION
#FUN-B20078 ---------------------End--------------------------
#FUN-B10056 --------------------------Begin-------------------------------
FUNCTION i310_chk_sgm011()
   DEFINE l_sql     STRING
   DEFINE l_cnt     LIKE type_file.num10
   DEFINE l_cnt1    LIKE type_file.num10
   DEFINE l_sgm012  LIKE sgm_file.sgm012
   DEFINE m_sgm012  LIKE sgm_file.sgm012
   DEFINE m_sgm     DYNAMIC  ARRAY OF RECORD
            sgm01   LIKE sgm_file.sgm01,
            sgm03   LIKE sgm_file.sgm03,
            sgm012  LIKE sgm_file.sgm012,
            sgm011  LIKE sgm_file.sgm011,
            sgm015  LIKE sgm_file.sgm015
                    END RECORD
   DEFINE l_sgm     DYNAMIC  ARRAY OF RECORD 
            sgm01   LIKE sgm_file.sgm01,
            sgm03   LIKE sgm_file.sgm03,    
            sgm012  LIKE sgm_file.sgm012,
            sgm011  LIKE sgm_file.sgm011,
            sgm015  LIKE sgm_file.sgm015   
                    END RECORD

   LET l_sql = "SELECT DISTINCT sgm012",
               "  FROM sgm_file ",
               " WHERE sgm01 = '",g_shm.shm01,"'", 
               " ORDER BY sgm012"
   PREPARE i310_chk FROM l_sql
   DECLARE i310_chk_cs CURSOR FOR i310_chk

   LET l_sql = " SELECT sgm012 FROM sgm_file ",
               "  WHERE sgm01 ='",g_shm.shm01,"'",
               "    AND sgm015 = ? ",
               "  ORDER BY sgm012"
   PREPARE i310_chk_pre FROM l_sql
   DECLARE i310_chk_cs2 CURSOR FOR i310_chk_pre 

   FOREACH i310_chk_cs INTO l_sgm012 
      IF SQLCA.sqlcode  THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,0)
      END IF   
      INITIALIZE m_sgm012 TO NULL 
      FOREACH i310_chk_cs2 USING l_sgm012 INTO m_sgm012
         IF NOT cl_null(m_sgm012) THEN
            EXIT FOREACH
         END IF
      END FOREACH   
      UPDATE sgm_file set sgm011 = m_sgm012
       WHERE sgm01 = g_shm.shm01
         AND sgm012 = l_sgm012  
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","sgm_file",g_shm.shm01,"",STATUS,"","",1)
      END IF
      INITIALIZE m_sgm012 TO NULL 
   END FOREACH
   CALL i310_b_fill(' 1=1')  
END FUNCTION
#FUN-B10056 --------------------------End--------------------------------
 
FUNCTION i310_set_entry_b()
 
    IF INFIELD(sgm54) THEN
       CALL cl_set_comp_entry("sgm55",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i310_set_no_entry_b()
 
    IF INFIELD(sgm54) THEN
       IF g_sgm[l_ac].sgm54 ! = 'Y' THEN
          CALL cl_set_comp_entry("sgm55",FALSE)
       END IF
    END IF
 
END FUNCTION
 
FUNCTION i310_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(200)
#   CONSTRUCT g_wc2 ON sgm03,sgm011,sgm012,sgm04,sgm45,sgm67,sgm06,sgm14,sgm13,sgm16,sgm15, #FUN-A60095  #FUN-A80150 add sgm67   #FUN-B10056
    CONSTRUCT g_wc2 ON sgm03,sgm011,sgm012,sgm014,sgm015,sgm04,sgm45,sgm67,sgm06,sgm14,sgm13,sgm16,sgm15, #FUN-B10056
                       sgm49,sgm50,sgm51,sgm05,sgm66,sgm52,sgm53,sgm54,sgm55,      #FUN-A80150 add sgm66
                       sgm56,sgm58   #FUN-A60095
            FROM s_sgm[1].sgm03,s_sgm[1].sgm011,s_sgm[1].sgm012, #FUN-A60095
                 s_sgm[1].sgm014,s_sgm[1].sgm015,                #FUN-B10056 add
                 s_sgm[1].sgm04,s_sgm[1].sgm45,s_sgm[1].sgm67,s_sgm[1].sgm06,   #FUN-A80150 add sgm67
                 s_sgm[1].sgm14,s_sgm[1].sgm13,s_sgm[1].sgm16,
                 s_sgm[1].sgm15,s_sgm[1].sgm49,
                 s_sgm[1].sgm50,s_sgm[1].sgm51,s_sgm[1].sgm05,s_sgm[1].sgm66,s_sgm[1].sgm52,    #FUN-A80150 add sgm66
                 s_sgm[1].sgm53,s_sgm[1].sgm54,s_sgm[1].sgm55,s_sgm[1].sgm56,
                 s_sgm[1].sgm58      #FUN-A60095
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
    CALL i310_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i310_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(200)
DEFINE l_shm05      LIKE shm_file.shm05          #MOD-AC0336
DEFINE l_flag       LIKE type_file.num5          #MOD-AC0336
 
 
    LET g_sql =
       #"SELECT sgm03,sgm011,sgm012,'',sgm04,sgm45,sgm05,eca02,sgm66,sgm52,sgm321,sgm53,", #FUN-A60095  #FUN-A80150 add sgm66   #FUN-B10056 mark
       #"SELECT sgm03,sgm011,sgm012,sgm014,sgm015,sgm04,sgm45,sgm05,eca02,sgm66,sgm52,sgm321,sgm53,",    #FUN-B10056  #FUN-B20078 mark 
        "SELECT sgm03,sgm011,sgm012,sgm014,sgm015,'',sgm04,sgm45,sgm05,eca02,sgm66,sgm52,sgm321,sgm53,", #FUN-B20078 
        " sgm54,sgm67,sgm06,sgm13,sgm14,sgm15,sgm16,sgm49,",   #FUN-A80150 add sgm67
       #" sgm50,sgm51,sgm55,sgm56,sgm57,sgm58,sgm59",   #FUN-A60095
        " sgm50,sgm51,sgm55,sgm56,sgm58,",              #FUN-A60095  
        " sgm62,sgm63,sgm65,sgm12,sgm34,sgm64,ta_sgm01,ta_sgm02,ta_sgm03,ta_sgm06 ",        #FUN-A60095  #str—add by huanglf 160713
        " FROM sgm_file LEFT OUTER JOIN eca_file ON sgm06 = eca01",
        " WHERE sgm01 ='",g_shm.shm01,"' ",
        "   AND ",p_wc2 CLIPPED,
        " ORDER BY sgm012,sgm03"   #FUN-A60095
    PREPARE i310_pb FROM g_sql
    DECLARE sgm_curs CURSOR FOR i310_pb
 
    CALL g_sgm.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH sgm_curs INTO g_sgm[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
       #FUN-A60095--begin--add------------
        CALL s_schdat_sel_ima571(g_shm.shm012) RETURNING l_flag,l_shm05  #MOD-AC0336
       #FUN-B10056 ------mod start--------- 
       #SELECT ecu014 INTO g_sgm[g_cnt].ecu014 FROM ecu_file
       # WHERE ecu01 = l_shm05       #MOD-AC0336
       #   AND ecu02 = g_shm.shm06
       #   AND ecu012= g_sgm[g_cnt].sgm012
       #FUN-B10056 ------mod end-----------
       #FUN-A60095--end--add--------------
       CALL i310_sgm014(g_sgm[g_cnt].sgm015) RETURNING g_sgm[g_cnt].ecr02    #FUN-B20078
       LET g_cnt = g_cnt + 1
 
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_sgm.deleteElement(g_cnt)
    LET g_rec_b=(g_cnt-1)
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
    LET l_ac=0
 
END FUNCTION
 
FUNCTION i310_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_sgm TO s_sgm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
      #No.FUN-840235---Begin
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY  
      #No.FUN-840235---End

      #str-----mark by guanyao161013
      #str----add by jixf 160802
      ON ACTION ins_sgm
         LET g_action_choice="ins_sgm"
         EXIT DISPLAY 
      #end----add by jixf 160802

     #str-----add by huanglf170320
      ON ACTION upd_ta_shm05
         LET g_action_choice="upd_ta_shm05"
         EXIT DISPLAY        
     #str-----end by huanglf170320 
      #ON ACTION dhy_pro
      #   LET g_action_choice="dhy_pro"
      #   EXIT DISPLAY 
      #end-----mark by guanyao161013

             #str---add by ly 180328 BLOCK
      ON ACTION undo_bolck
         LET g_action_choice = 'undo_bolck'
         EXIT DISPLAY 
      #end---add by ly 180328

        #str---add by ly 180328 BLOCK
      ON ACTION bolck
         LET g_action_choice = 'bolck'
         EXIT DISPLAY 
    
      
      ON ACTION first
         CALL i310_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i310_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i310_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i310_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i310_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            CASE g_sfb.sfb87
                 WHEN 'Y'   LET g_confirm = 'Y'
                            LET g_void = ''
                 WHEN 'N'   LET g_confirm = 'N'
                            LET g_void = ''
                 WHEN 'X'   LET g_confirm = ''
                            LET g_void = 'Y'
              OTHERWISE     LET g_confirm = ''
                            LET g_void = ''
            END CASE
            IF g_shm.shm28='Y' THEN
               LET g_close = 'Y'
            ELSE
               LET g_close = 'N'
            END IF
            #圖形顯示
            CALL cl_set_field_pic(g_confirm,"","",g_close,g_void,g_shm.shmacti)
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#FUN-B10056 ------------------------Begin--------------------------
      ON ACTION chkbom
         LET g_action_choice = "chkbom"
         EXIT DISPLAY
#FUN-B10056 ------------------------End----------------------------
 
      ON ACTION routing_qt_status #Run Card製程數量狀態查詢
         LET g_action_choice="routing_qt_status"
         EXIT DISPLAY
 
      ON ACTION cell_details   #單元明細查詢
         LET g_action_choice="cell_details"
         EXIT DISPLAY
 
      #MOD-520037
      ON ACTION close_the_case  #結案
         LET g_action_choice="close_the_case"
         EXIT DISPLAY
      #--
 
      #No.FUN-8B0094--BEGIN--
      ON ACTION cance_close_the_case  #取消結案
         LET g_action_choice="cance_close_the_case"
         EXIT DISPLAY
      #No.FUN-8B0094--END--
 
      #FUN-A60095--begin--add--
      ON ACTION subcontract
         LET g_action_choice="subcontract"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      #FUN-A60095--end--add--

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
      ##
 
      ON ACTION related_document                #No.FUN-6A0164  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
      END DISPLAY
      CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
#FUN-B10056 ---------mark start--------------- 
#FUN-A60095--begin--add----------
#FUNCTION i310_sgm012(p_cmd)
#DEFINE p_cmd           LIKE type_file.chr1
#DEFINE l_ecuacti       LIKE ecu_file.ecuacti
#DEFINE l_ecu10         LIKE ecu_file.ecu10
#DEFINE l_ecu014        LIKE ecu_file.ecu014
#DEFINE l_ecu015        LIKE ecu_file.ecu015
#DEFINE l_flag          LIKE type_file.num5  #MOD-AC0336
#DEFINE l_shm05         LIKE shm_file.shm05  #MOD-AC0336
#DEFINE l_ecm014        LIKE ecm_file.ecm014,
#       l_ecm015        LIKE ecm_file.ecm015,
#       l_ecmacti       LIKE sgm_file.sgmacti,  #FUN-B10056
#       l_ecm011        LIKE sgm_file.sgm011    #FUN-B10056  

#   LET g_errno = ' '
#   CALL s_schdat_sel_ima571(g_shm.shm012) RETURNING l_flag,l_shm05 #MOD-AC0336
  #SELECT ecu014,ecu10,ecuacti INTO l_ecu014,l_ecu10,l_ecuacti
  #  FROM ecu_file
  # WHERE ecu01 = l_shm05  #MOD-AC0336
  #   AND ecu02 = g_shm.shm06
  #   AND ecu012= g_sgm[l_ac].sgm012
  #
  #CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abm-214'
  #                               LET l_ecu014 = NULL
  #                               LET l_ecu015 = NULL
  #     WHEN l_ecuacti='N'        LET g_errno = '9028'
  #     WHEN l_ecu10 <> 'Y'       LET g_errno = '9029'
  #     OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  #END CASE
  #IF cl_null(g_errno) OR p_cmd = 'd' THEN
  #   #找上工艺段号
  #   SELECT ecu012 INTO l_ecu015 FROM ecu_file
  #    WHERE ecu01 = l_shm05  #TQC-AC0336
  #      AND ecu02 = g_shm.shm06
  #      AND ecu015= g_sgm[l_ac].sgm012
  #   IF SQLCA.sqlcode THEN
  #      LET l_ecu015 = ' '
  #   END IF

#      IF p_cmd <> 'd' THEN
#         LET g_sgm[l_ac].sgm011 = l_ecu015  
#      END IF                               
#      LET g_sgm[l_ac].ecu014 = l_ecu014   
#   END IF

#END FUNCTION
#FUN-A60095--end--add-----------
#FUN-B10056 ---------mark end-------------- 
FUNCTION i310_sgm06(p_cmd,p_ac)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    l_ecaacti       LIKE eca_file.ecaacti,
    l_pmcacti       LIKE pmc_file.pmcacti,
    l_pmc03         LIKE pmc_file.pmc03,
    l_eca02         LIKE eca_file.eca02,
    p_ac            LIKE type_file.num5           #No.FUN-680121 SMALLINT
 
    LET g_errno = ' '
    SELECT eca02,ecaacti INTO l_eca02,l_ecaacti FROM eca_file
     WHERE eca01 = g_sgm[p_ac].sgm06
    IF SQLCA.SQLCODE = 100 THEN # 找不到就找廠商了 #
        SELECT pmc03,pmcacti INTO l_pmc03,l_ecaacti FROM pmc_file
         WHERE pmc01 = g_sgm[p_ac].sgm06
         CASE WHEN SQLCA.SQLCODE=100 LET g_errno='asf-676'
              WHEN l_pmcacti='N'     LET g_errno='9028'
  #FUN-690024------mod-------
              WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
  #FUN-690024------mod-------              
              OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
         END CASE
         IF cl_null(g_errno) OR p_cmd='d' THEN
            LET g_sgm[p_ac].eca02 =l_pmc03
         END IF
     ELSE
         IF l_ecaacti='N' THEN LET g_errno = '9028' END IF
         IF STATUS  THEN LET g_errno=SQLCA.SQLCODE USING '-------' END IF
         IF cl_null(g_errno) OR p_cmd='d' THEN
            LET g_sgm[p_ac].eca02 =l_eca02
         END IF
     END IF
END FUNCTION
 
FUNCTION i310_sgm04(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    LET g_errno=''
#TQC-B80252  --begin
  # SELECT ecd01,ecd02 INTO g_sgm[l_ac].sgm04,g_sgm[l_ac].sgm45 FROM ecd_file
  #  WHERE ecd01 = g_sgm[l_ac].sgm04
    SELECT ecd01,ecd02,ecd07 INTO g_sgm[l_ac].sgm04,g_sgm[l_ac].sgm45,g_sgm[l_ac].sgm06 FROM ecd_file
     WHERE ecd01 = g_sgm[l_ac].sgm04
#TQC-B80252  --end 

    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4009'
                                   LET g_sgm[l_ac].sgm04 = ' '
                                   LET g_sgm[l_ac].sgm45 = ' '
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i310_shm05(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    l_imaacti       LIKE ima_file.imaacti,
    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021,
    l_ima55         LIKE ima_file.ima55
 
    LET g_errno = ''
   #SELECT ima02,ima021,ima55,imaacti INTO l_ima02,l_ima021,l_ima55,l_imaacti FROM ima_file  #FUN-710073 mark
    SELECT ima02,ima021,ima55,imaacti,ima_file.*          #FUN-710073 mod
      INTO l_ima02,l_ima021,l_ima55,l_imaacti,g_ima.*     #FUN-710073 mod
      FROM ima_file
     WHERE ima01 = g_shm.shm05
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'ams-003'
                                   LET g_shm.shm05 = NULL
         WHEN l_imaacti='N'        LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'   LET g_errno = '9038'   #FUN-690022 add
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd='d' THEN
       DISPLAY l_ima02 TO FORMONLY.ima02
       DISPLAY l_ima021 TO FORMONLY.ima021
       DISPLAY l_ima55 TO FORMONLY.ima55
    END IF
END FUNCTION
 
FUNCTION i310_sgg(p_key)
DEFINE
    p_key          LIKE sgg_file.sgg01,
    l_sgg01        LIKE sgg_file.sgg01,
    l_sggacti      LIKE sgg_file.sggacti
 
    LET g_errno=''
    SELECT sgg01,sggacti INTO l_sgg01,l_sggacti FROM sgg_file WHERE sgg01=p_key
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-003'
                                   LET l_sggacti = NULL
         WHEN l_sggacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i310_c()
    DEFINE l_chr     LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_shm.shm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_shm.* FROM shm_file WHERE shm01 = g_shm.shm01
   #IF g_sfb.sfb87='Y'    THEN CALL cl_err('','9026',1) RETURN END IF
    IF g_shm.shm28='Y'    THEN CALL cl_err('','aec-078',1) RETURN END IF
 
    BEGIN WORK
 
    OPEN i310_cl USING g_shm.shm01
    IF STATUS THEN
       CALL cl_err("OPEN i310_cl:", STATUS, 1)
       CLOSE i310_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i310_cl INTO g_shm.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_shm.shm01,SQLCA.sqlcode,0) ROLLBACK WORK RETURN
    END IF
    CALL i310_show()
 
   IF NOT cl_confirm('asf-029') THEN ROLLBACK WORK RETURN END IF
 
   UPDATE shm_file SET shm28='Y'  WHERE shm01=g_shm.shm01


   IF SQLCA.SQLERRD[3]=0 THEN
#     CALL cl_err('No shm deleted',SQLCA.SQLCODE,0)    #No.FUN-660128
      CALL cl_err3("upd","shm_file",g_shm.shm01,"",SQLCA.SQLCODE,"","No shm deleted",1)   #No.FUN-660128
      ROLLBACK WORK RETURN   #No.FUN-660128
   ELSE
      LET g_shm.shm28='Y'
      DISPLAY BY NAME g_shm.shm28
   END IF
 
   MESSAGE ""
   CLOSE i310_cl
   COMMIT WORK
END FUNCTION
 
#No.FUN-8B0094--BEGIN--
FUNCTION i310_cc()
    DEFINE l_chr     LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_shm.shm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_shm.* FROM shm_file WHERE shm01 = g_shm.shm01
    IF g_shm.shm28='N'    THEN CALL cl_err('','aec-076',1) RETURN END IF
 
    BEGIN WORK
 
    OPEN i310_cl USING g_shm.shm01
    IF STATUS THEN
       CALL cl_err("OPEN i310_cl:", STATUS, 1)
       CLOSE i310_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i310_cl INTO g_shm.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_shm.shm01,SQLCA.sqlcode,0) ROLLBACK WORK RETURN
    END IF
    CALL i310_show()





 
   IF NOT cl_confirm('asf-028') THEN ROLLBACK WORK RETURN END IF
 
   UPDATE shm_file SET shm28='N'  WHERE shm01=g_shm.shm01



   IF SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","shm_file",g_shm.shm01,"",SQLCA.SQLCODE,"","No shm deleted",1)
      ROLLBACK WORK RETURN 
   ELSE
      LET g_shm.shm28='N'
      DISPLAY BY NAME g_shm.shm28
   END IF

 
   MESSAGE ""
   CLOSE i310_cl
   COMMIT WORK
END FUNCTION
#No.FUN-8B0094--END--



FUNCTION i310_out()
 DEFINE l_wc LIKE type_file.chr1000            #No:TQC-610089 add    #No.FUN-680137 VARCHAR(100)
 DEFINE l_no LIKE oga_file.oga01 #FUN-560176
 IF g_shm.shm01 IS NULL THEN RETURN END IF

 LET l_no=g_shm.shm01 
 LET l_wc='shm01="',l_no,'"'   
 LET g_msg = "csfr006", 
             " '",g_today CLIPPED,"' ''",
             " '",g_lang CLIPPED,"' '",g_bgjob CLIPPED,"'  '' '1'",
             " '",l_wc CLIPPED,"' '' 'N' "   
CALL cl_cmdrun(g_msg)


END FUNCTION

#str—add by huanglf 160713
#No.FUN-840235---Begin
--FUNCTION i310_out()
--DEFINE
    --l_i             LIKE type_file.num5,    #
    --sr              RECORD
        --shm01       LIKE shm_file.shm01,   
        --shm012      LIKE shm_file.shm012,
        --shm05       LIKE shm_file.shm05,
        --ima55       LIKE ima_file.ima55,
        --ima02       LIKE ima_file.ima02,
        --ima021      LIKE ima_file.ima021,
        --shm06       LIKE shm_file.shm06,
        --shm13       LIKE shm_file.shm13,
        --shm15       LIKE shm_file.shm15,
        --shm08       LIKE shm_file.shm08,
        --shm09       LIKE shm_file.shm09,
        --shm86       LIKE shm_file.shm86,
        --sfb87       LIKE sfb_file.sfb87,
        --shm28       LIKE shm_file.shm28,
        --sgm03       LIKE sgm_file.sgm03,
        --sgm04       LIKE sgm_file.sgm04,
        --sgm45       LIKE sgm_file.sgm45,
        --sgm05       LIKE sgm_file.sgm05,
        --eca02       LIKE eca_file.eca02,
        --sgm52       LIKE sgm_file.sgm52,
        --sgm53       LIKE sgm_file.sgm53,
        --sgm54       LIKE sgm_file.sgm54,
        --sgm06       LIKE sgm_file.sgm06,
        --sgm13       LIKE sgm_file.sgm13,
        --sgm14       LIKE sgm_file.sgm14,
        --sgm15       LIKE sgm_file.sgm15,
        --sgm16       LIKE sgm_file.sgm16,
        --sgm49       LIKE sgm_file.sgm49,
        --sgm50       LIKE sgm_file.sgm50,
        --sgm51       LIKE sgm_file.sgm51,
        --sgm55       LIKE sgm_file.sgm55,
        --sgm56       LIKE sgm_file.sgm56,
       #FUN-A60095--begin-------------
       #sgm57       LIKE sgm_file.sgm57,
        --sgm58       LIKE sgm_file.sgm58,
       #sgm59       LIKE sgm_file.sgm59
        --sgm011      LIKE sgm_file.sgm011,
        --sgm012      LIKE sgm_file.sgm012,
        --ecu014      LIKE ecu_file.ecu014,   
        --sgm015      LIKE sgm_file.sgm015,    #FUN-B10056
        --sgm321      LIKE sgm_file.sgm321,
        --sgm62       LIKE sgm_file.sgm62,
        --sgm63       LIKE sgm_file.sgm63,
        --sgm65       LIKE sgm_file.sgm65,
        --sgm12       LIKE sgm_file.sgm12,
        --sgm34       LIKE sgm_file.sgm34,
        --sgm64       LIKE sgm_file.sgm64
       #FUN-A60095--end----------------
       --END RECORD,
    --l_name          STRING,  #External(Disk) file name  
    --l_za05          LIKE za_file.za05,     
    --l_wc            STRING                 
--DEFINE l_flag       LIKE type_file.num5  #MOD-AC0336
--DEFINE l_shm05      LIKE shm_file.shm05  #MOD-AC0336
--
    --IF cl_null(g_shm.shm01) THEN
       --CALL cl_err('','9057',0) RETURN
    --END IF
    --IF cl_null(g_wc) THEN
       --LET g_wc =" shm01='",g_shm.shm01,"'"       
       --LET g_wc2=" 1=1 "   
    --END IF
    --
    --CALL cl_wait()
    --SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    --SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   
   --
    --CALL cl_del_data(l_table)
     --
    --
 --
    --LET g_sql = "SELECT shm01,shm012,shm05,ima55,ima02,ima021,shm06,shm13,",
                --" shm15,shm08,shm09,shm86,sfb87,shm28,sgm03,sgm04,sgm45,",
                --" sgm05,eca02,sgm52,sgm53,sgm54,sgm06,sgm13,sgm14,sgm15,",
               #" sgm16,sgm49,sgm50,sgm51,sgm55,sgm56,sgm57,sgm58,sgm59 ", #FUN-A60095
                --" sgm16,sgm49,sgm50,sgm51,sgm55,sgm56,sgm58,",             #FUN-A60095 
               #" sgm011,sgm012,'',sgm321,sgm62,sgm63,sgm65,sgm12,sgm34,sgm64 ",   #FUN-A60095 #FUN-B10056 
                --" sgm011,sgm012,sgm014,sgm015,sgm321,sgm62,sgm63,sgm65,sgm12,sgm34,sgm64 ",    #FUN-B10056 add sgm014,sgm015 
                --"  FROM sgm_file,shm_file, OUTER ima_file,OUTER sfb_file,",
                --"  OUTER eca_file ",
                --" WHERE shm01 = sgm01 AND shm05 = ima_file.ima01 ",
                --"   AND shm012 = sfb_file.sfb01 ",
                --"   AND ",g_wc CLIPPED,
                --"   AND sgm06  = eca_file.eca01 ",
                --"   AND ",g_wc2 CLIPPED
    --PREPARE i310_p1 FROM g_sql                # RUNTIME 編譯
    --IF STATUS THEN CALL cl_err('i310_p1',STATUS,0) END IF
    --
    --DECLARE i310_co                         # CURSOR
        --CURSOR FOR i310_p1
 --
    --FOREACH i310_co INTO sr.*
        --IF SQLCA.sqlcode THEN
            --CALL cl_err('foreach:',SQLCA.sqlcode,1)
            --EXIT FOREACH
        --END IF
        #FUN-A60095--begin--add----
        --CALL s_schdat_sel_ima571(sr.shm012) RETURNING l_flag,l_shm05 #MOD-AC0336
#FUN-B10056 -------------------Begin-------------------
#        SELECT ecu014 INTO sr.ecu014
#          FROM ecu_file
#         WHERE ecu01 = l_shm05   #MOD-AC0336
#           AND ecu02 = sr.shm06
#           AND ecu012= sr.sgm012
#FUN-B10056 -------------------End---------------------
        #FUN-A60095--end--add------
        --IF sr.sgm13 IS NULL THEN LET sr.sgm13 = 0 END IF
        --IF sr.sgm14 IS NULL THEN LET sr.sgm14 = 0 END IF
        --IF sr.sgm15 IS NULL THEN LET sr.sgm15 = 0 END IF
        --IF sr.sgm16 IS NULL THEN LET sr.sgm16 = 0 END IF
        --IF sr.sgm49 IS NULL THEN LET sr.sgm49 = 0 END IF 
       #IF sr.sgm59 IS NULL THEN LET sr.sgm59 = 0 END IF #FUN-A60095
        --IF sr.sgm015 IS NULL THEN LET sr.sgm015 = ' ' END IF #FUN-B10056
        --EXECUTE insert_prep USING sr.*
    --END FOREACH
 --
    #是否列印選擇條件
    #將cl_wcchp轉換後的g_wc放到l_wc,不要改變原來g_wc的值,不然第二次執行會有問題
    --IF g_zz05 = 'Y' THEN
       --CALL cl_wcchp(g_wc,'shm01,shm012,shm05,shm06,shm13,shm15,shm08,shm09,shm86,
                           --shm28,shmuser,shmgrup,shmmodu,shmdate,shmacti')                 
            --RETURNING l_wc
    --ELSE
       --LET l_wc = ' '
    --END IF
 --
    --LET g_str = l_wc CLIPPED ,";",g_prog CLIPPED        
    --LET g_sql ="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    #FUN-A60095--begin--------------------------
    --IF g_sma.sma541 = 'N' THEN
       --LET l_name = 'asfi310'
    --ELSE
       --LET l_name = 'asfi310_1'
    --END IF
    --CALL cl_prt_cs3('asfi310',l_name,g_sql,g_str)
    #FUN-A60095--end-----------------------------
    --
    --CLOSE i310_co
    --ERROR ""
--END FUNCTION
#No.FUN-840235---End

#FUN-A60095--begin--add-------------
FUNCTION i310_subcontract()
   DEFINE l_str       STRING
   DEFINE l_i         LIKE type_file.num5
   DEFINE l_flag      LIKE type_file.num5
   DEFINE l_sw        LIKE type_file.num5
   DEFINE l_wip       LIKE sgm_file.sgm321
   DEFINE l_sfb04     LIKE sfb_file.sfb04
   DEFINE l_sfb87     LIKE sfb_file.sfb87

   IF g_rec_b <= 0 THEN RETURN END IF
   IF l_ac <= 0 THEN RETURN END IF

   IF cl_null(g_shm.shm012) OR cl_null(g_sgm[l_ac].sgm03) OR g_sgm[l_ac].sgm012 IS NULL THEN
      RETURN
   END IF

   SELECT sfb04,sfb87 INTO l_sfb04,l_sfb87 FROM sfb_file
    WHERE sfb01 = g_shm.shm012
   IF l_sfb04 = '8' THEN
      CALL cl_err(g_shm.shm012,'axr-369',0)
      RETURN
   END IF
   IF l_sfb87 <> 'Y' THEN
      CALL cl_err(g_shm.shm012,'axm-445',0)
      RETURN
   END IF

   #check是否可以有委外量调用asfp710处理
   LET l_flag = FALSE
   FOR l_i = 1 TO g_rec_b
       IF cl_null(g_sgm[l_ac].sgm03) OR g_sgm[l_ac].sgm012 IS NULL THEN
          CONTINUE FOR
       END IF
       CALL s_subcontract_sgm_qty(g_shm.shm01,g_sgm[l_i].sgm012,g_sgm[l_i].sgm03)
            RETURNING l_sw,l_wip
       IF l_sw = FALSE OR l_wip <= 0 THEN
          CONTINUE FOR
       END IF
       LET l_flag = TRUE
       EXIT FOR
   END FOR

   IF l_flag = FALSE THEN
      CALL ui.Interface.refresh()
      CALL cl_err(g_sfb.sfb01,'aec-310',0)
      RETURN
   END IF

   LET l_str = 'sgm01 = "',g_shm.shm01,'" AND sgm012 = "',g_sgm[l_ac].sgm012,'" AND sgm03 = ',g_sgm[l_ac].sgm03
   LET g_cmd = "asfp710 '",l_str CLIPPED,"'"
   CALL cl_cmdrun_wait(g_cmd)

   SELECT sgm321,sgm52 INTO g_sgm[l_ac].sgm321,g_sgm[l_ac].sgm52 FROM sgm_file
    WHERE sgm01 = g_shm.shm01
      AND sgm012= g_sgm[l_ac].sgm012
      AND sgm03 = g_sgm[l_ac].sgm03
   CALL i310_refresh()

END FUNCTION

FUNCTION i310_refresh()

   DISPLAY ARRAY g_sgm TO s_sgm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY

END FUNCTION

FUNCTION i310_next_sgm03()
DEFINE l_sfb93   LIKE sfb_file.sfb93
DEFINE l_sgm03   LIKE sgm_file.sgm03
DEFINE l_ecu015  LIKE ecu_file.ecu015
DEFINE l_flag          LIKE type_file.num5  #MOD-AC0336
DEFINE l_shm05         LIKE shm_file.shm05  #MOD-AC0336
DEFINE l_sgm015        LIKE sgm_file.sgm015 #FUN-B10056
 
 SELECT sfb93 INTO l_sfb93 FROM sfb_file WHERE sfb01=g_shm.shm012
 IF l_sfb93 = 'Y' AND g_sma.sma541 = 'Y' THEN  
    SELECT MIN(sgm03) INTO l_sgm03 FROM sgm_file
     WHERE sgm01=g_shm.shm01
       AND sgm03 > g_sgm_t.sgm03
       AND sgm012 = g_sgm_t.sgm012
    IF cl_null(l_sgm03) THEN
       CALL s_schdat_sel_ima571(g_shm.shm012) RETURNING l_flag,l_shm05  #MOD-AC0336
      #FUN-B10056 ---------mod start----------
      #SELECT ecu015 INTO l_ecu015 FROM ecu_file
      # WHERE ecu01=l_shm05  #MOD-AC0336
      #   AND ecu02=g_shm.shm06
      #   AND ecu012=g_sgm_t.sgm012
       SELECT sgm015 INTO l_sgm015 FROM sgm_file
        WHERE sgm01 = g_shm.shm01
          AND sgm03 = l_shm05
          AND sgm012 = g_sgm_t.sgm012
      #FUN-B10056 ---------mod end----------
       SELECT MIN(sgm03) INTO l_sgm03 FROM sgm_file
        WHERE sgm01=g_shm.shm01
        # AND sgm012 = l_ecu015     #FUN-B10056 mark
          AND sgm012 = l_ecm015     #FUN-B10056
       RETURN l_ecu015,l_sgm03
    ELSE
       RETURN g_sgm_t.sgm012,l_sgm03
    END IF
 ELSE
    IF g_sgm_t.sgm012 IS NULL THEN LET g_sgm_t.sgm012 =' ' END IF
    LET l_sgm03=NULL
    SELECT MIN(sgm03) INTO l_sgm03 FROM sgm_file
     WHERE sgm01 = g_shm.shm01
       AND sgm012 = g_sgm_t.sgm012
       AND sgm03 > g_sgm_t.sgm03
     RETURN g_sgm_t.sgm012,l_sgm03
 END IF
 RETURN g_sgm_t.sgm012,l_sgm03
END FUNCTION
#FUN-A60095--end--add----------------
#FUN-A80150---add---start---
FUNCTION i310_sgm67()   #供應商check
   DEFINE l_pmcacti   LIKE pmc_file.pmcacti,
          l_pmc05     LIKE pmc_file.pmc05 
 
   LET g_errno=' '
   SELECT pmcacti,pmc05
     INTO l_pmcacti,l_pmc05
     FROM pmc_file
    WHERE pmc01=g_sgm[l_ac].sgm67
   CASE WHEN SQLCA.sqlcode=100  LET g_errno='mfg3014'
        WHEN l_pmcacti='N'      LET g_errno='9028'
        WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
        WHEN l_pmc05='0'        LET g_errno='aap-032'
        WHEN l_pmc05='3'        LET g_errno='aap-033'
   END CASE
END FUNCTION
#FUN-A80150---add---end---
#FUN-B80086

#str---add by jixf 160802
FUNCTION i310_ins_sgm()
DEFINE l_sgm   RECORD LIKE sgm_file.*
DEFINE l_count        LIKE type_file.num5
DEFINE l_ecm   RECORD LIKE ecm_file.*
DEFINE l_sql   STRING 
DEFINE l_i     LIKE type_file.num5

   IF cl_null(g_shm.shm01) THEN 
      RETURN 
   END IF 
   
   SELECT COUNT(*) INTO l_count FROM sgm_file WHERE sgm01=g_shm.shm01
   IF l_count>0 THEN 
      CALL cl_err('','i310-22',1)
      RETURN 
   END IF 

   LET g_success='Y'
   CALL s_showmsg_init()
   BEGIN WORK 

   LET l_i=1
   LET l_sql=" SELECT * FROM ecm_file where ecm01='",g_shm.shm012,"' ORDER BY ecm03 ASC "
   PREPARE l_pre221 FROM l_sql
   DECLARE l_cur22 CURSOR FOR l_pre221
   FOREACH l_cur22 INTO l_ecm.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET l_sgm.sgm01=g_shm.shm01
      LET l_sgm.sgm02=g_shm.shm012
      LET l_sgm.sgm03_par=g_shm.shm05
      LET l_sgm.sgm03=l_ecm.ecm03
      LET l_sgm.sgm04=l_ecm.ecm04
      LET l_sgm.sgm05=l_ecm.ecm05
      LET l_sgm.sgm06=l_ecm.ecm06
      LET l_sgm.sgm07=l_ecm.ecm07
      LET l_sgm.sgm08=l_ecm.ecm08
      LET l_sgm.sgm09=l_ecm.ecm09
      LET l_sgm.sgm10=l_ecm.ecm10
      LET l_sgm.sgm11=l_ecm.ecm11
      LET l_sgm.sgm121=l_ecm.ecm121
      LET l_sgm.sgm13=l_ecm.ecm13
      LET l_sgm.sgm14=l_ecm.ecm14
      LET l_sgm.sgm15=l_ecm.ecm15
      LET l_sgm.sgm16=l_ecm.ecm16
      LET l_sgm.sgm17=l_ecm.ecm17
      LET l_sgm.sgm18=l_ecm.ecm18
      LET l_sgm.sgm19=l_ecm.ecm19
      LET l_sgm.sgm20=l_ecm.ecm20
      LET l_sgm.sgm21=l_ecm.ecm21
      LET l_sgm.sgm22=l_ecm.ecm22
      LET l_sgm.sgm23=l_ecm.ecm23
      LET l_sgm.sgm24=l_ecm.ecm24
      LET l_sgm.sgm291=l_ecm.ecm291
      LET l_sgm.sgm292=l_ecm.ecm292
      IF l_i=1 THEN 
         LET l_sgm.sgm301=g_shm.shm08
      ELSE 
         LET l_sgm.sgm301=0
      END IF 
      LET l_sgm.sgm302=0
      LET l_sgm.sgm303=0
      LET l_sgm.sgm304=0
      LET l_sgm.sgm311=0
      LET l_sgm.sgm312=0
      LET l_sgm.sgm313=0
      LET l_sgm.sgm314=0
      LET l_sgm.sgm315=0
      LET l_sgm.sgm316=0
      LET l_sgm.sgm317=0
      LET l_sgm.sgm321=l_ecm.ecm321
      LET l_sgm.sgm322=l_ecm.ecm322
      LET l_sgm.sgm34=l_ecm.ecm34
      LET l_sgm.sgm35=l_ecm.ecm35
      LET l_sgm.sgm36=l_ecm.ecm36
      LET l_sgm.sgm37=l_ecm.ecm37
      LET l_sgm.sgm38=l_ecm.ecm38
      LET l_sgm.sgm39=l_ecm.ecm39
      LET l_sgm.sgm40=l_ecm.ecm40
      LET l_sgm.sgm41=l_ecm.ecm41
      LET l_sgm.sgm42=l_ecm.ecm42
      LET l_sgm.sgm43=l_ecm.ecm43
      LET l_sgm.sgm45=l_ecm.ecm45
      LET l_sgm.sgm49=l_ecm.ecm49
      LET l_sgm.sgm50=l_ecm.ecm50
      LET l_sgm.sgm51=l_ecm.ecm51
      LET l_sgm.sgm52=l_ecm.ecm52
      LET l_sgm.sgm53=l_ecm.ecm53
      LET l_sgm.sgm54=l_ecm.ecm54
      LET l_sgm.sgm55=l_ecm.ecm55
      LET l_sgm.sgm56=l_ecm.ecm56
      LET l_sgm.sgm57=l_ecm.ecm58
      LET l_sgm.sgm58=l_ecm.ecm58
      LET l_sgm.sgm59=1
      LET l_sgm.sgmacti='Y'
      LET l_sgm.sgmuser=g_user
      SELECT gen03 INTO l_sgm.sgmgrup FROM gen_file WHERE gen01=g_user
      LET l_sgm.sgmplant=g_plant
      LET l_sgm.sgmlegal=g_plant
      LET l_sgm.sgmorig=l_sgm.sgmgrup
      LET l_sgm.sgmoriu=g_user
      LET l_sgm.sgm012=l_ecm.ecm012
      LET l_sgm.sgm011=l_ecm.ecm011
      LET l_sgm.sgm62=l_ecm.ecm62
      LET l_sgm.sgm63=l_ecm.ecm63
      LET l_sgm.sgm64=l_ecm.ecm64
      LET l_sgm.sgm65=l_ecm.ecm65
      LET l_sgm.sgm66=l_ecm.ecm66
      LET l_sgm.sgm67=l_ecm.ecm67
      LET l_sgm.sgm014=l_ecm.ecm014
      LET l_sgm.sgm015=l_ecm.ecm015
      LET l_sgm.ta_sgm01=l_ecm.ta_ecm01
      LET l_sgm.ta_sgm02=l_ecm.ta_ecm02
      LET l_sgm.ta_sgm03=l_ecm.ta_ecm03
      #tianry add 161214
      SELECT ecbud06 INTO l_sgm.ta_sgm06 FROM ecb_file WHERE ecb01=l_sgm.sgm03_par 
      AND ecb02=l_sgm.sgm11 AND ecb03=l_sgm.sgm03 AND ecb012=l_sgm.sgm012
      IF cl_null(l_sgm.ta_sgm06) THEN LET l_sgm.ta_sgm06='N' END IF
      #tianry add end 
      INSERT INTO sgm_file VALUES (l_sgm.*)
      IF STATUS THEN
         LET g_success='N'
         CALL s_errmsg('sgm01||sgm03',l_sgm.sgm01||'-'||l_sgm.sgm03,'ins sgm',STATUS,1)
      END IF

      LET l_i=l_i+1
   END FOREACH 

   IF g_success='Y' THEN 
      COMMIT WORK 
      CALL s_showmsg()
   ELSE 
      ROLLBACK WORK 
      CALL s_showmsg()
   END IF 

   CALL i310_b_fill('1=1')
END FUNCTION 
#end---add by jixf 160802

#批处理
FUNCTION dhy_pro()
   DEFINE l_sgm04       LIKE sgm_file.sgm04
   DEFINE l_sgm65       LIKE sgm_file.sgm65
   DEFINE l_sgm301      LIKE sgm_file.sgm301
   DEFINE l_sgm311      LIKE sgm_file.sgm311
   DEFINE l_sgm313      LIKE sgm_file.sgm313
   DEFINE l_shm08       LIKE shm_file.shm08
   DEFINE l_sgm01       LIKE sgm_file.sgm01
   DEFINE l_sgm03       LIKE sgm_file.sgm03
   DEFINE l_min         LIKE sgm_file.sgm03
   DEFINE l_max         LIKE sgm_file.sgm03   
   DEFINE l_smg311_next LIKE sgm_file.sgm311 
   DEFINE l_sql         STRING
   DEFINE l_shb01       LIKE shb_file.shb01
   DEFINE l_shb16       LIKE shb_file.shb16
   DEFINE l_shb06       LIKE shb_file.shb06
   DEFINE l_shb081      LIKE shb_file.shb081
   DEFINE l_shb111      LIKE shb_file.shb111
   DEFINE i             SMALLINT
   DEFINE l_shm012      LIKE shm_file.shm012
   DEFINE l_sfb05       LIKE sfb_file.sfb05 
   DEFINE l_sfb06       LIKE sfb_file.sfb06   
   DEFINE l_sgm06       LIKE sgm_file.sgm06
   DEFINE l_sgm58       LIKE sgm_file.sgm58
   DEFINE l_tc_shc03    LIKE tc_shc_file.tc_shc03
   DEFINE l_tc_shc06    LIKE tc_shc_file.tc_shc06

   LET l_sql=" SELECT DISTINCT tc_shc03,tc_shc06 FROM tc_shc_file WHERE tc_shc04 IS NULL "
   LET i =0   
   PREPARE l_dhy_pre1 FROM l_sql
   DECLARE l_dhy_cur1 CURSOR FOR l_dhy_pre1
   FOREACH l_dhy_cur1 INTO l_tc_shc03,l_tc_shc06
      SELECT shm012,shm05,shm06 INTO l_shm012,l_sfb05,l_sfb06 
      FROM shm_file WHERE shm01=l_tc_shc03
      UPDATE tc_shc_file SET tc_shc04=l_shm012,tc_shc05=l_sfb05,tc_shc07=l_sfb06 WHERE tc_shc03 = l_tc_shc03
      SELECT sgm04,sgm06,sgm58 INTO l_sgm04,l_sgm06,l_sgm58  FROM sgm_file WHERE sgm01=l_tc_shc03 AND sgm03=l_tc_shc06
      UPDATE tc_shc_file SET tc_shc08=l_sgm04,tc_shc09=l_sgm06,
        tc_shc10='N',tc_shc16=l_sgm58 WHERE tc_shc03 = l_tc_shc03 AND tc_shc06=l_tc_shc06
      
   END FOREACH
   
   --BEGIN WORK 
   #step 2 更新sgm  sgm301 <> sgm311 AND sgm311 <>0
   #LET i =0
   #LET l_sql=" SELECT sgm01 FROM sgm_file WHERE sgm02='WRK-16070318'"
   #PREPARE l_dhy_pre1 FROM l_sql
   #DECLARE l_dhy_cur1 CURSOR FOR l_dhy_pre1
   #FOREACH l_dhy_cur1 INTO g_shm.shm01
   #   SELECT MIN(sgm03) INTO l_min FROM sgm_file WHERE sgm01=g_shm.shm01 AND sgm311 >0
   #   LET l_sql=" SELECT sgm04,sgm65,sgm301,sgm311,sgm313,shm08,sgm01,sgm03,sgm313 FROM sgm_file,shm_file ",
   #   "where sgm01='",g_shm.shm01,"' and sgm311 >0 AND sgm01=shm01 order by sgm03"    
   #   PREPARE l_dhy_pre FROM l_sql
   #   DECLARE l_dhy_cur CURSOR FOR l_dhy_pre
   #   FOREACH l_dhy_cur INTO l_sgm04,l_sgm65,l_sgm301,l_sgm311,l_sgm313,l_shm08,l_sgm01,l_sgm03,l_sgm313      
   #      IF l_min = l_sgm03 THEN         
   #         UPDATE sgm_file SET sgm301=l_shm08,sgm311=l_shm08-l_sgm313 WHERE sgm01=l_sgm01 AND sgm03=l_sgm03
   #      
   #      ELSE
   #         SELECT MAX(sgm03) INTO l_max FROM sgm_file WHERE sgm01=l_sgm01 AND sgm03<l_sgm03
   #         SELECT sgm311 INTO l_smg311_next FROM sgm_file WHERE sgm01=l_sgm01 AND sgm03=l_max
   #         UPDATE sgm_file SET sgm301=l_smg311_next,sgm311=l_smg311_next-l_sgm313 WHERE sgm01=l_sgm01 AND sgm03=l_sgm03
   #      END IF
   #      LET l_min = l_sgm03
   #      LET i = i + 1
   #      DISPLAY i
   #   END FOREACH
   # END FOREACH
   
   #step 1 更新shb_file
   #LET i =0
   #LET l_sql="SELECT shb16 FROM shb_file WHERE shbconf='N' "
   #PREPARE l_dhy_pre1 FROM l_sql
   #DECLARE l_dhy_cur1 CURSOR FOR l_dhy_pre1
   #FOREACH l_dhy_cur1 INTO g_shm.shm01      
   #   LET l_sql=" SELECT shb01,shb16,shb06,shb081,shb111,sgm301,sgm311,sgm313 FROM sgm_file,shb_file ",
   #   "where sgm01='",g_shm.shm01,"' and sgm01=shb16 AND sgm03=shb06 AND shbconf='N' AND sgm301-sgm311 <> shb111"    
   #   PREPARE l_dhy_pre FROM l_sql
   #   DECLARE l_dhy_cur CURSOR FOR l_dhy_pre
   #   FOREACH l_dhy_cur INTO l_shb01,l_shb16,l_shb06,l_shb081,l_shb111,l_sgm301,l_sgm311,l_sgm313 
   #     UPDATE sgm_file SET sgm311= l_sgm301 - l_shb111 - l_sgm313 WHERE sgm01=l_shb16 AND sgm03=l_shb06
   #     LET i = i + 1
   #     DISPLAY i
   #   END FOREACH
   # END FOREACH
   
   
END FUNCTION 


#str----add by huanglf170320
FUNCTION i310_ta_shm05()
   DEFINE p_cmd       LIKE type_file.chr1,    #No.FUN-680104 VARCHAR(1)
          l_ima903    LIKE ima_file.ima903

 
   INPUT BY NAME g_shm.ta_shm05 WITHOUT DEFAULTS    
 
      AFTER FIELD ta_shm05
         IF cl_null(g_shm.ta_shm05) THEN
            NEXT FIELD ta_shm05
         END IF

 
      ON ACTION CONTROLP

 
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

   #TQC-AB0306-------add---------str--------------------------
   IF INT_FLAG THEN
      CALL cl_err('',9001,0)
      LET INT_FLAG = 0
      RETURN
   END IF
   #TQC-AB0306-------add---------end--------------------------
 
   UPDATE shm_file SET ta_shm05 = g_shm.ta_shm05
    WHERE shm01 = g_shm.shm01
 

END FUNCTION
#str----end by huanglf170320 
