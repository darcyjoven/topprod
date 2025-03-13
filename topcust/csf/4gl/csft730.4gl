# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: csft730.4gl
# Descriptions...: Run Card 生產日報維護作業
# Date & Author..: 99/05/18 By Carol 
# Modify.........: #No:7516 03/07/16 By Mandy
#                  apmt730'1.轉報工單' 時, 
#                  IF  RUN CARD委外 THEN
#                      串csft730(Run Card 生產日報)
#                  ELSE
#                      串asft700(生產日報)
#                  END IF
# Modify.........: No:7829 03/08/18 Carol 單據程式中呼叫單據自動編號時,
#                                         應該是要包覆在 BEGIN WORK 中(transaction)
#                                         才會達到lock 的功能
# Modify.........: No:7842,8454 03/08/19 Mandy 在PQC檢驗後,如原拒收,後特採,則可以可報工量應加進來
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-4C0035 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-530548 05/03/29 By pengu  1. 輸入時員工編號需自動帶出輸入人員。  ==> _a 時 default g_user
                                          #         2. 輸入 RunCard 編號後，工單編號應不可修改。
# Modify.........: No.FUN-550067 05/05/31 By Trisy 單據編號加大
# Modify.........: No.MOD-540045 05/05/05 By pengu 新增一run card查詢: run card/作業編號/WIP量
# Modify.........: No.TQC-5A0018 05/10/13 By Claire 工單號碼INPUT Noentry
# Modify.........: No.FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.TQC-5C0033 05/12/07 By Claire 取消查詢下製程shb12的開窗
# Modify.........: NO.TQC-630066 06/03/07 By Kevin 流程訊息通知功能修改
# Modify.........: No.MOD-640338 06/04/10 By pengu Run Card欄位查詢時,不應出現無WIP量的Run Card.
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-630180 06/06/09 By Pengu 再計算wip量時不應將合併轉入與分割轉入量列入計算
# Modify.........: No.MOD-660020 06/06/14 By Joe 修正CONSTRUCT欄位重複情況
# Modify.........: NO.TQC-660088 06/06/21 By Claire 流程訊息通知功能修改
# Modify.........: No.FUN-660137 06/06/21 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-560052 06/06/22 By kim 生產日報當站報廢數量與缺點數量要與作勾機
# Modify.........: No.FUN-660128 06/06/28 By Xumin cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680050 06/08/28 By Rainy 開窗挑選 Run Card 時 , 後面已有作業編號，可於挑完 Run Card 後直接帶該 Run Card 的「作業編號」成預設值。
# Modify.........: No.FUN-680121 06/09/19 By huchenghao 類型轉換
# Modify.........: No.FUN-690022 06/09/22 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/10 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6A0164 06/11/22 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.MOD-730077 07/03/20 By pengu csft730有報數量不會回寫sfb12
# Modify.........: No.TQC-740145 07/04/20 By hongmei 錄入時，登錄單別輸入任何值沒管控
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760117 07/06/21 By rainy  1補MOD-640104 製程中委外,應修改報工單委外未入庫ok前應不可報工
# Modify.........: No.TQC-790064 07/09/11 By xiaofeizhu 查詢時，狀態攔位都是灰色的，不可使用
# Modify.........: No.TQC-790064 07/09/20 By sherry   點“委外報工錄入”，委外入庫單號要求開窗選擇，開窗選擇之后，自動退出作業
# Modify.........: No.MOD-7A0096 07/10/17 By Pengu 當分批報工且已有部分入庫時會無法刪除報工單
# Modify.........: No.MOD-7B0002 07/11/12 By Pengu 1.check之入庫數應check有效的完工入庫單,而非已過帳之工單的完工量。
#                                                  2.刪除時,若非最後一站,加檢查是否有製程委外採購已產生
# Modify.........: No.MOD-7B0119 07/11/13 By Pengu 開工日期不是報工當日,時間欄位中間的冒號":"會消失
# Modify.........: No.MOD-7C0144 07/12/26 By Pengu AFTER FIELD shb032在推開工日期時，若shb032是60倍數時推出的開工日會異常
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No:tina 08/03/12 By Carol 日期推算問題
# Modify.........: No.MOD-830153 08/03/20 By wujie 進入單身，然后點擊“確定”，程序無法在此跳過，會卡在缺點碼欄位，只有點退出才可以離開單身
# Modify.........: No.MOD-840064 08/04/08 By Pengu 刪除時會出現asf-681的錯誤
# Modify.........: No.MOD-860207 08/06/20 By Pengu 調整判斷工單是否發料的錯誤訊息
# Modify.........: No.MOD-870197 08/07/16 By kim 當重工轉出(shb113)數量大於0時則下製成欄位(shb12)強制要輸入
# Modify.........: No.MOD-880117 08/08/14 By chenl 通過runcard，工單號，作業編號及制稱序號四個值進行判斷，若在sgm_file表中存在sgm52='Y'，即委外否為'Y'，則不允許用戶直接錄入，必須通過委外報工錄入按鈕進行數據錄入。
# Modify.........: No.MOD-880128 08/08/18 By wujie 刪除后有變量沒清空，造成后續操作錯誤,runcard欄位應該不可輸入
# Modify.........: No.FUN-840089 08/09/03 By sherry 增加列印功能
# Modify.........: No.MOD-8C0203 08/12/22 By claire 刪除時不可存在有PQC單據
# Modify.........: No.FUN-910076 09/02/02 By jan 增加'投入機時'欄位
# Modify.........: No.FUN-930105 09/03/24 By lilingyu 增加工藝移轉功能
# Modify.........: No.MOD-940267 09/04/21 By lutingting 在單身下查詢條件,查出來得筆數有問題
# Modify.........: No.FUN-940113 09/04/22 By lilingyu modify FUN-930105 some bug
# Modify.........: No.MOD-940360 09/04/27 By sherry 已存在的報工資料須先清除再重新產生  
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9B0005 09/11/05 By liuxqa substr的修改。
# Modify.........: No.FUN-9C0072 10/01/12 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:MOD-A60022 10/06/03 By Sarah shb14的開窗應改成q_rvv1
# Modify.........: No.FUN-A60095 10/07/12 By jan 平行製程功能 新增shb012
# Modify.........: No:MOD-A70110 10/07/29 By Smapmin 由入庫單傳入的狀況下,輸入完資料後要能停留在畫面上
# Modify.........: No.FUN-A80102 10/09/20 By kim GP5.25號機管理
# Modify.........: No.FUN-A90057 10/09/23 By kim GP5.25號機管理
# Modify.........: No.FUN-AB0049 10/11/11 By zhangll 倉庫營運中心權限修改
# Modify.........: No:TQC-AB0389 10/12/03 By jan 檢查出錯后,不需清空畫面
# Modify.........: NO.TQC-AC0294 10/12/20 By liweie sfu01開窗/檢查要排除smy73='Y'的單據
# Modify.........: No.TQC-AC0374 10/12/29 By liweie 從ecu_file撈取資料時，制程料號改用s_schdat_sel_ima571()撈取
# Modify.........: No.FUN-B10056 11/02/15 By vealxu 修改制程段號的管控
# Modify.........: No.TQC-B20083 11/02/17 By jan 1.報工單檢查邏輯錯誤
# .............................................. 2.計算該站可報工量齊套數應再考慮該站的轉換率,目前沒有考慮
# Modify.........: No.FUN-B20079 11/03/11 By shenyang 改變作業編號，製成段號的邏輯
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No.FUN-A80128 11/04/29 By Mandy 因asft620 新增EasyFlow整合功能影響INSERT INTO sfu_file
# Modify.........: No.FUN-A70095 11/06/08 By lixh1 增加修改,確認,取消確認,作廢,取消作廢四个action及自定義欄位
# Modify.........: No.TQC-B60124 11/06/16 By lixh1 增加報錯信息
# Modify.........: No.TQC-B60127 11/06/16 By lixh1 asf-995 提示信息確認后回csft730界面
# Modify.........: No.TQC-B60129 11/06/17 By lixh1 如果工單是需要進行'FQC'在生成入庫單時如果沒有先生成'FQC'單應給出提示
# Modify.........: No:FUN-B70074 11/07/26 By fengrui 添加行業別表的新增於刪除
# Modify.........: No:MOD-B80291 11/08/25 By Carrier RUN CARD开窗后,NEXT FIELD到本身字段,平行工艺时,有带不出工单编号的现象
# Modify.........: No:FUN-B90055 11/09/06 By jason 製程移轉數量"可輸入"0
# Modify.........: No:TQC-BA0003 11/10/06 By jason 修正快速輸入的幾項問題
# Modify.........: No.FUN-BB0085 11/12/13 By xianghui 增加數量欄位小數取位
# Modify.........: No:FUN-BB0086 11/12/22 By tanxc 增加數量欄位小數取位
# Modify.........: No:TQC-BC0156 12/01/10 By destiny 作业编号开窗退出时不应做栏位检查 
# Modify.........: No.FUN-BC0104 12/01/11 By xianghui 增加是否依QC結果判定產生入庫單

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C20006 12/02/03 by zhangll 審核時增加可報工量控管
# Modify.........: No:TQC-C20196 12/02/17 By lixh1 mark回寫入庫單的邏輯&提示信息重複問題
# Modify.........: No:TQC-C20248 12/02/21 By lixh1 回寫入庫單號
# Modify.........: No.TQC-C20361 12/02/22 By lixh1 重新啟動asf-133提示信息
# Modify.........: No.TQC-C20465 12/02/24 By lixh1 INSERT INTO sfv_file 時如果倉儲批為null則給' '
# Modify.........: No.TQC-C20479 12/02/24 By fengrui 修正qcf22查詢條件
# Modify.........: No.TQC-C20244 12/02/27 By destiny 修改时可以自动带出工艺序
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No:TQC-C90003 12/09/04 By qiull sma541='N'且shb113>0時，關閉shb121欄位
# Modify.........: No:TQC-C90018 12/09/05 By qiull 將shb021的默認值取消，換成shb031給默認值,並且分別對shb021,shb031進行控管
# Modify.........: No:TQC-C90020 12/09/05 By qiull 已確認資料再按確認時，提示“此單據已確認”的信息 
# Modify.........: No:TQC-C80129 12/10/09 By fengrui 報錯信息改為0,非彈窗報錯 
# Modify.........: No.TQC-C90043 12/10/10 By chenjing 修改產生FQC單時，檢驗量沒帶出來問題
# Modify.........: No.TQC-CA0033 12/10/15 By chenjing 修改輸入委外報工資料時，良品轉出欄位不可輸問題
# Modify.........: No.FUN-CB0087 12/12/20 By fengrui 倉庫單據理由碼改善
# Modify.........: No.FUN-C30163 12/12/27 By pauline CALL q_sgm(時增加參數
# Modify.........: No:CHI-D20010 13/02/21 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.MOD-D60240 13/07/12 By suncx 管控責任工藝段和工藝序只能錄入當站或當站以前的
# Modify.........: No:TQC-D40100 13/08/14 By dongsz 修改抓取轉出單位sgm58的條件

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_argv1         LIKE rvv_file.rvv01, #入庫單與移轉單共用
    g_argv2         STRING,              #No.TQC-630066
    g_argv3         LIKE rvv_file.rvv02, #入庫單項次
    g_argv4         LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1),
    g_shb           RECORD LIKE shb_file.*,
    g_shb_t         RECORD LIKE shb_file.*,
    g_shb_o         RECORD LIKE shb_file.*,
    g_rvv           RECORD LIKE rvv_file.*,
    g_sgm           RECORD LIKE sgm_file.*,
    g_h1,g_h2,g_m1,g_m2,g_sum_m1,g_sum_m2      LIKE type_file.num5,    #No.FUN-680121 SMALLINT,              #
    b_shc           RECORD LIKE shc_file.*,
    g_sfb           RECORD LIKE sfb_file.*,
    m_shd           RECORD LIKE shd_file.*,
    g_ima02         LIKE ima_file.ima02,
    g_ima021        LIKE ima_file.ima021,
    g_shb01_t       LIKE shb_file.shb01,    #FUN-A70095 
    g_shc           DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
                    shc03     LIKE shc_file.shc03,
                    shc04     LIKE shc_file.shc04,
                    qce02     LIKE qce_file.qce02,
                    qce03     LIKE qce_file.qce03,
                    shc05     LIKE shc_file.shc05,
                    shc012    LIKE shc_file.shc012,   #FUN-A60095
                    shc06     LIKE shc_file.shc06,
                    sgm04     LIKE sgm_file.sgm04
                    END RECORD,
    g_shc_t         RECORD
                    shc03     LIKE shc_file.shc03,
                    shc04     LIKE shc_file.shc04,
                    qce02     LIKE qce_file.qce02,
                    qce03     LIKE qce_file.qce03,
                    shc05     LIKE shc_file.shc05,
                    shc012    LIKE shc_file.shc012,   #FUN-A60095
                    shc06     LIKE shc_file.shc06,
                    sgm04     LIKE sgm_file.sgm04
                    END RECORD,
     g_wc,g_wc2,g_wc3    string,  #No.FUN-580092 HCN
     g_sql               string,  #No.FUN-580092 HCN
    g_pmn18         LIKE pmn_file.pmn18,
    g_pmn32         LIKE pmn_file.pmn32,
    g_sgm04         LIKE sgm_file.sgm04,
    g_sgm05         LIKE sgm_file.sgm05,
    g_sgm58         LIKE sgm_file.sgm58,
    g_shbconf       LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1),
    g_t1            LIKE oay_file.oayslip,                     #No.FUN-550067   #No.FUN-680121 VARCHAR(05)
    g_t2            LIKE oay_file.oayslip,                     #NO.FUN-930105 
    g_buf           LIKE type_file.chr1000, #No.FUN-680121 VARCHAR(20)
#   issue_qty2      LIKE ima_file.ima26,    #No.FUN-680121 DEC(15,3),
    issue_qty2      LIKE type_file.num15_3, ###GP5.2  #NO.FUN-A20044
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-680121 SMALLINT
    g_cmd           LIKE type_file.chr1000, #No.FUN-680121 VARCHAR(100)
    p_row,p_col     LIKE type_file.num5,    #No.FUN-680121 SMALLINT
    g_sw            LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1), 
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680121 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680121 SMALLINT
DEFINE g_cnt           LIKE type_file.num10      #No.FUN-680121 INTEGER
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680121 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10   #No.FUN-680121 INTEGER
DEFINE g_curs_index   LIKE type_file.num10   #No.FUN-680121 INTEGER
DEFINE g_jump         LIKE type_file.num10   #No.FUN-680121 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5    #No.FUN-680121 SMALLINT
DEFINE   g_shb21        LIKE shb_file.shb21     
DEFINE   g_shb22        LIKE shb_file.shb22    
DEFINE   g_wh1          LIKE img_file.img02   
DEFINE   g_wh2          LIKE img_file.img03    
DEFINE   g_wh3          LIKE img_file.img04
DEFINE   g_emp          LIKE gen_file.gen01    
DEFINE   g_shb06        LIKE shb_file.shb06
DEFINE   g_shb07        LIKE shb_file.shb07
DEFINE   g_shb08        LIKE shb_file.shb08
DEFINE   g_shb081       LIKE shb_file.shb081
DEFINE   g_shb09        LIKE shb_file.shb09
DEFINE   g_shb_bak      RECORD LIKE shb_file.*     
DEFINE   g_gen02        LIKE gen_file.gen02
DEFINE   gg_ima02        LIKE ima_file.ima02
DEFINE   gg_ima021       LIKE ima_file.ima021
DEFINE   g_wip          LIKE shb_file.shb111
DEFINE   g_pqc          LIKE shb_file.shb111
DEFINE   g_tot_pqc      LIKE shb_file.shb111
DEFINE   g_sgm53        LIKE sgm_file.sgm53
DEFINE   g_sgm54        LIKE sgm_file.sgm54 
DEFINE   g_pmn012       LIKE pmn_file.pmn012   #FUN-A60095
DEFINE   g_min_set      LIKE sfb_file.sfb08    #FUN-A60095
DEFINE   g_void         LIKE type_file.chr1    #FUN-A70095
DEFINE   g_chr          LIKE shb_file.shbconf  #FUN-A70095
DEFINE   g_chr1         LIKE shb_file.shbacti  #FUN-A70095
DEFINE   g_yy           LIKE type_file.num5    #FUN-A70095
DEFINE   g_mm           LIKE type_file.num5    #FUN-A70095
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
    #可接收RunCard委外入庫單號與項次
    LET g_argv1=ARG_VAL(1)
    LET g_argv2=ARG_VAL(2)
    LET g_argv3=ARG_VAL(3) #No.TQC-630066
 
    LET p_row = 2 LET p_col = 10
    OPEN WINDOW t730_w AT p_row,p_col WITH FORM "csf/42f/csft730"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()

    CALL cl_set_comp_visible('shb012,ecu014,shb121,shc012',g_sma.sma541='Y')  #FUN-A60095
    #str-----add by guanyao160903
    IF g_user <>"tiptop" THEN 
       CALL cl_set_act_visible("gy_pro",FALSE)
    END IF 
    #end----add by guanyao160903

    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t730_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
                  CALL t730_a('','')        #NO.FUN-940113
            END IF
         OTHERWISE             #TQC-660088
               CALL t730_q()   #TQC-660088
      END CASE
    END IF
 
    CALL t730()
 
    CLOSE WINDOW t730_w                         #結束畫面
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
 
END MAIN
 
FUNCTION t730()
  DEFINE l_za05        LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(40)
 
    LET g_wc2 =' 1=1'
    LET g_wc3 =' 1=1'
 
    LET g_forupd_sql = "SELECT * FROM shb_file WHERE shb01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t730_cl CURSOR FROM g_forupd_sql
 
    #當參數不為空白時表由入庫單傳入
    IF cl_null(g_argv1) AND cl_null(g_argv3) THEN
       CALL t730_menu()
    ELSE
        LET g_action_choice="insert"
        IF NOT cl_chk_act_auth() THEN RETURN END IF 
 
        MESSAGE ""
        CLEAR FORM
        CALL g_shc.clear()
        SELECT COUNT(*) INTO g_cnt 
         FROM shb_file #check是否已產生報工單
        WHERE shb14 = g_argv1 
          AND shb15 =g_argv3 
        IF g_cnt > 0 THEN #已存在的報工資料須先清除再重新產生
          CALL t730_q()
          CALL cl_err('','asf-116',1)                                                                                               
        ELSE
          SELECT rvv_file.* INTO g_rvv.* 
            FROM rvv_file,rvu_file
           WHERE rvu01=g_argv1 
             AND rvuconf = 'Y'
             AND rvu01 = rvv01 
             AND rvv02=g_argv3 
          IF STATUS THEN 
              CALL cl_err3("sel","rvv_file",g_argv1,g_argv3,'asf-700',"","sel rvv",1)  #No.FUN-660128
          ELSE
              LET g_argv4='a'
          
              SELECT   pmn18,  pmn32,pmn012    #FUN-A60095
                INTO g_pmn18,g_pmn32,g_pmn012  #FUN-A60095
                FROM pmn_file,rvb_file  #讀取製程序號
               WHERE rvb01=g_rvv.rvv04 
                 AND rvb02=g_rvv.rvv05
                 AND rvb04=pmn01 
                 AND rvb03=pmn02
              IF STATUS THEN 
                  LET g_pmn32=NULL 
                  LET g_pmn012=NULL  #FUN-A60095
              ELSE
                  SELECT sgm04,sgm05,sgm58 
                    INTO g_sgm04,g_sgm05,g_sgm58
                    FROM sgm_file
                   WHERE sgm01=g_pmn18 
                     AND sgm03=g_pmn32
                     AND sgm012=g_pmn012 #FUN-A60095
                  IF STATUS THEN 
                      LET g_sgm04=NULL 
                      LET g_sgm05=NULL
                  END IF
              END IF
          END IF
          CALL t730_a('','')        #NO.FUN-940113
          #-----MOD-A70110---------
          CALL cl_set_act_visible("insert,query,delete,detail,
          fast_input,fqc2,trans_fqc,trans_store,
          input_sub_report,direct_st_in,shift_working_hours",FALSE)
          
          CALL t730_menu()  
          #-----END MOD-A70110-----
        END IF
    END IF
END FUNCTION
 
FUNCTION t730_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
  DEFINE l_buf   LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(600)
  DEFINE l_length,l_i LIKE type_file.num5     #No.FUN-680121 SMALLINT
 
     IF cl_null(g_argv1) THEN  
        CLEAR FORM                     #清除畫面
        CALL g_shc.clear()
        CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_shb.* TO NULL    #No.FUN-750051
        CONSTRUCT BY NAME g_wc ON shb01,shb04,shb16,shb05,shb012,shb081,shb082,shb06,shbconf,  #FUN-A60095  #FUN-A70095  add shbconf
                                  shb08,shb07,shb09,shb02,shb021,shb03,shb031,
                                  shb032,shb111,shb115,shb112,shb113,shb12,shb121,shb033,shb32,   #FUN-910076 add shb033 #FUN-A60095  #FUN-A70095  add shb32
                                  shbuser,shbmodu,shbgrup,shbdate,
                                  shb114,shb31,shb26,shb30,shb27,shb21,shb22,      #FUN-A80102
                                  shb28,shb29,shb14,shb15,shb13    #NO.FUN-930105 add shb21,shb22   #FUN-A80102
                                 ,shbud01,shbud02,shbud03,shbud04,shbud05,  #FUN-A70095
                                  shbud06,shbud07,shbud08,shbud09,shbud10,  #FUN-A70095
                                  shbud11,shbud12,shbud13,shbud14,shbud15   #FUN-A70095

               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
           ON ACTION controlp                  
              CASE WHEN INFIELD(shb01) #查詢單號
                        CALL cl_init_qry_var()
                        LET g_qryparam.state    = "c"
                        LET g_qryparam.form  = "q_shb"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO shb01 
                        NEXT FIELD shb01
                   WHEN INFIELD(shb04) 
                        CALL cl_init_qry_var()
                        LET g_qryparam.state    = "c"
                        LET g_qryparam.form  = "q_gen"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO shb04 
                        NEXT FIELD shb04
                   WHEN INFIELD(shb07) 
                        CALL q_eca(TRUE,TRUE,g_shb.shb07) RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO shb07 
                        NEXT FIELD shb07
                   WHEN INFIELD(shb09)                 #機械編號
                        CALL cl_init_qry_var()
                        LET g_qryparam.state    = "c"
                        LET g_qryparam.form  = "q_eci"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO shb09 
                        NEXT FIELD shb09
                   WHEN INFIELD(shb05) 
                        CALL cl_init_qry_var()
                        LET g_qryparam.state    = "c"
                        LET g_qryparam.form  = "q_sfb02"
                        LET g_qryparam.state = "c"
                        LET g_qryparam.arg1     = "2345"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO shb05 
                        NEXT FIELD shb05
                   WHEN INFIELD(shb08) 
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form  = "q_ecg"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO shb08 
                        NEXT FIELD shb08
                   WHEN INFIELD(shb081) 
                      #CALL q_sgm(TRUE,TRUE,g_shb.shb16,'','1')    #No.MOD-640138  #FUN-C30163 mark
                       CALL q_sgm(TRUE,TRUE,g_shb.shb16,'','1','','','')      #FUN-C30163 add
                             RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO shb081
                        NEXT FIELD shb081
                   WHEN INFIELD(shb16) 
                        CALL q_sgm2(TRUE,TRUE,'','')
                             RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO shb16
                        NEXT FIELD shb16
                  
                 WHEN INFIELD(shb21)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_shb21"
                     ##組合拆解的完工入庫單不顯示出來!                                                                                    #TQC-AC0294         
                    #LET g_qryparam.where = " substr(sfu01,1,",g_doc_len,") NOT IN (SELECT smy71 FROM smy_file WHERE smy71 IS NOT NULL) " #TQC-AC0294         
                     LET g_qryparam.where = " sfu01[1,",g_doc_len,"] NOT IN (SELECT smy71 FROM smy_file WHERE smy71 IS NOT NULL) "  #FUN-B40029  
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shb21
                     NEXT FIELD shb21
                  WHEN INFIELD(shb22)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_shb22"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shb22
                     NEXT FIELD shb22 
                  #FUN-A60095--begin--add----------    
                  WHEN INFIELD(shb012)   #工艺段号
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                   # LET g_qryparam.form     = "q_ecu012_1"            #FUN-B10056 mark
                     LET g_qryparam.form     = "q_sgm012_1"            #FUN-B10056
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shb012
                     NEXT FIELD shb012
                  #FUN-A60095--end--add----------- 
                  #FUN-A80102(S)
                  WHEN INFIELD(shb27)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_pmc18"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shb27
                     NEXT FIELD shb27     
                  WHEN INFIELD(shb28)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state= "c"
                     LET g_qryparam.form = "q_pmm9"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shb28
                     NEXT FIELD shb28
                  WHEN INFIELD(shb29)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state= "c"
                     LET g_qryparam.form = "q_rva05"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shb29
                     NEXT FIELD shb29
                  #FUN-A80102(E)
               END CASE
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
        
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
        END CONSTRUCT
        LET g_wc = g_wc CLIPPED,cl_get_extra_cond('shbuser', 'shbgrup') #FUN-980030
 
        IF INT_FLAG THEN RETURN END IF
   
        CONSTRUCT g_wc3 ON shc03,shc04,shc05,shc012,shc06   #FUN-A60095
             FROM s_shc[1].shc03,s_shc[1].shc04,s_shc[1].shc05,
                  s_shc[1].shc012,s_shc[1].shc06     #FUN-A60095
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
             ON ACTION controlp
                CASE WHEN INFIELD(shc04) 
                          CALL cl_init_qry_var()
                          LET g_qryparam.state = "c"
                          LET g_qryparam.form  = "q_qce"
                          CALL cl_create_qry() RETURNING g_qryparam.multiret
                          DISPLAY g_qryparam.multiret TO shc04 
                          NEXT FIELD shc04
                     #FUN-A60095--begin--add---------
                     WHEN INFIELD(shc012)   #工艺段号
                        CALL cl_init_qry_var()
                        LET g_qryparam.state    = "c"
                      # LET g_qryparam.form     = "q_ecu012_1"               #FUN-B10056 mark
                        LET g_qryparam.form     = "q_sgm012_1"               #FUN-B10056
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO shc012
                        NEXT FIELD shc012
                     #FUN-A60095--end--add-----------
                     WHEN INFIELD(shc06) 
                         #CALL q_sgm(TRUE,TRUE,g_shb.shb16,'','1')        #No.MOD-640138  #FUN-C30163 mark
                          CALL q_sgm(TRUE,TRUE,g_shb.shb16,'','1','','','')        #FUN-C30163  add
                               RETURNING g_shc[1].sgm04,g_shc[1].shc06
                          DISPLAY g_shc[1].shc06,g_shc[1].sgm04
                               TO s_shc[1].shc06,s_shc[1].sgm04
                          NEXT FIELD shc06
                END CASE
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
        
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
        END CONSTRUCT
 
        IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
        LET g_wc3 = g_wc3 CLIPPED
     ELSE 
        IF g_argv2="query" THEN
           LET g_wc ="shb01='",g_argv1,"'"  CLIPPED 
        ELSE
           LET g_wc ="shb14='",g_argv1,"' AND shb15=",g_argv3 CLIPPED
        END IF
        LET g_wc3 = " 1=1"  
     END IF  
 
     IF g_wc3 = " 1=1"  THEN 
        LET g_sql = "SELECT shb01 FROM shb_file",
                   " WHERE shb16 IS NOT NULL AND shb16!=' ' AND ", g_wc CLIPPED,
                   " ORDER BY 1"
     ELSE 
        LET g_sql = "SELECT UNIQUE shb01 ",
                    "  FROM shb_file, shc_file ",
                    " WHERE shb01 = shc01 ",
                    "  AND shb16 IS NOT NULL AND shb16!=' ' ", 
                    "  AND ", g_wc CLIPPED,
                    "  AND ", g_wc3 CLIPPED,
                    " ORDER BY 1"
     END IF
 
     PREPARE t730_prepare FROM g_sql
     DECLARE t730_cs                         #SCROLL CURSOR
         SCROLL CURSOR WITH HOLD FOR t730_prepare
     
     IF g_wc3 = " 1=1" THEN                                                                                                         
        LET g_sql="SELECT COUNT(*) FROM shb_file ",                                                                                 
                  "  WHERE shb16 IS NOT NULL AND shb16!=' ' ",                                                                      
                  "  AND ", g_wc CLIPPED                                                                                            
     ELSE                                                                                                                           
        LET g_sql="SELECT COUNT(DISTINCT shb01) FROM shb_file,shc_file ",                                                           
                  "  WHERE shb01=shc01 AND shb16 IS NOT NULL AND shb16!=' ' ",                                                      
                  "  AND ", g_wc CLIPPED," AND ",g_wc3 CLIPPED                                                                      
     END IF                                                                                                                         
     PREPARE t730_precount FROM g_sql
     DECLARE t730_count CURSOR FOR t730_precount
 
END FUNCTION
 
FUNCTION t730_menu()
DEFINE l_cmd     LIKE type_file.chr1000   #No.FUN-840089
DEFINE l_shbacti LIKE shb_file.shbacti    #NO.FUN-930105 
DEFINE l_str     STRING                   #NO.FUN-930105
DEFINE l_cnt     LIKE type_file.num10     #NO.FUN-930105
DEFINE l_sgm03   LIKE sgm_file.sgm03      #NO.FUN-940113
DEFINE l_sgm012  LIKE sgm_file.sgm012     #FUN-A60095
DEFINE l_shb01   LIKE shb_file.shb01      #FUN-A70095
DEFINE l_flag    LIKE type_file.num5      #FUN-A70095
 
   WHILE TRUE
      CALL t730_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
                  CALL t730_a('','')        #NO.FUN-940113
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t730_q() 
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t730_r() 
               LET g_argv1=''
               LET g_argv3=''
               LET g_argv4=''
            END IF
      #FUN-A70095 -----------Begin------------
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t730_u('','')
            END IF
         #str----add by guanyao160903
         WHEN "gy_pro"
            IF cl_chk_act_auth() THEN
               CALL t730_gy_pro()
            END IF  
         #end----add by guanyao160903
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t730_confirm()
            END IF 
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t730_unconfirm() 
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t730_x()   #CHI-D20010
               CALL t730_x(1)  #CHI-D20010
               IF g_shb.shbconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_shb.shbconf,"","","",g_void,"")
            END IF
         #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t730_x(2)
               IF g_shb.shbconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_shb.shbconf,"","","",g_void,"")
            END IF
         #CHI-D20010---end
      #FUN-A70095 -----------End--------------
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t730_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
         IF cl_chk_act_auth() THEN
            #LET l_cmd = "asfr832 '' '' '' '' '' '' '' '' '' '' '' '",g_shb.shb01,"'"  #FUN-C30085 mark
            LET l_cmd = "asfg832 '' '' '' '' '' '' '' '' '' '' '' '",g_shb.shb01,"'"  #FUN-C30085 add
            CALL cl_cmdrun_wait(l_cmd)
         END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "fast_input"
            LET g_shb_bak.* = g_shb.* 
            CALL t730_a('','F')                   
            
        WHEN "fqc2"
             IF cl_chk_act_auth() THEN 
                IF cl_null(g_shb.shb01) THEN 
                   CALL cl_err('','anm-803',1)                   
                ELSE
         #FUN-A70095 -----------Begin------------
                   IF g_shb.shbconf <> 'Y' THEN
                      IF g_shb.shbconf = 'N' THEN
                         CALL cl_err(g_shb.shb01,'asf-218',0)
                      END IF
                      IF g_shb.shbconf = 'X' THEN
                         CALL cl_err(g_shb.shb01,'asf-149',0)
                      END IF
                   ELSE
         #FUN-A70095 -----------End--------------
                      SELECT shbacti INTO l_shbacti FROM shb_file 
                       WHERE shb01 = g_shb.shb01
                      IF l_shbacti = 'N' OR cl_null(l_shbacti) THEN 
                         CALL cl_err('','mfg0301',1)                     
                      ELSE
                        #FUN-A60095--begin--modify------------------
                        #SELECT MAX(sgm03) INTO l_sgm03 FROM sgm_file 
                        # WHERE sgm02 = g_shb.shb05
                        #   AND sgm01 = g_shb.shb16
                        #IF g_shb.shb06 = l_sgm03 THEN  
                         CALL s_schdat_max_sgm03(g_shb.shb16) RETURNING l_sgm012,l_sgm03 #返回最終製程段最終製程序
                         IF g_shb.shb012=l_sgm012 AND g_shb.shb06=l_sgm03 THEN
                        #FUN-A60095--end--modify--------------------- 
                            CALL t730_1()
                            IF g_success  = 'Y' THEN 
                              CALL t730_show()                                                       
                            END IF   
                         ELSE                              #NO.FUN-940113
                            CALL cl_err('','asf-110',1)    #NO.FUN-940113
                         END IF 	  
                      END IF  	     	  
                   END IF      #FUN-A70095
                END IF     
             END IF          
        WHEN "trans_fqc"
              IF cl_chk_act_auth() THEN 
                IF cl_null(g_shb.shb01) THEN 
                   CALL cl_err('','anm-083',1)
                ELSE   
                  IF NOT cl_null(g_shb.shb22) THEN 
                     LET l_str= "aqct411 '",g_shb.shb22,"'"
                     CALL cl_cmdrun_wait(l_str)
                  END IF 
                END IF   
              END IF    
        WHEN "trans_store"
            IF cl_chk_act_auth() THEN
              IF cl_null(g_shb.shb01) THEN 
                  CALL cl_err('','anm-803',1)                   
              ELSE 
               IF NOT cl_null(g_shb.shb21) THEN                 
                   LET l_cnt=0
                   SELECT COUNT(*) INTO l_cnt FROM sfb_file
                    WHERE sfb01=g_shb.shb05
                      AND sfb02<> '11'
                   IF l_cnt>0 THEN
                        LET l_str= "asft623  '",g_shb.shb21,"'"
                        CALL cl_cmdrun_wait(l_str)
                   END IF                   
               END IF
              END IF  
            END IF   
           
         WHEN "input_sub_report"  
            IF cl_chk_act_auth() THEN 
               MESSAGE ""
               CLEAR FORM
               CALL g_shc.clear()
               IF NOT t730_i2() THEN 
                  CALL t730_a('','')        #NO.FUN-940113
               END IF
               LET g_argv1=''
               LET g_argv3=''
               LET g_argv4=''
            END IF
         WHEN "direct_st_in" 
            IF cl_chk_act_auth() AND g_shb.shb114 > 0 AND
               NOT cl_null(g_shb.shb114) THEN 
               IF g_shb.shbconf = 'X' THEN              #FUN-A70095
                  CALL cl_err(g_shb.shb01,'asf-149',0)  #FUN-A70095
               ELSE                                     #FUN-A70095 
                  CALL t701(g_shb.shb01) 
               END IF     #FUN-A70095
            END IF
         WHEN "shift_working_hours"
            IF cl_chk_act_auth() THEN 
               LET g_cmd="asft710 '",g_shb.shb03,"' '",g_shb.shb04,"'" 
               CALL cl_cmdrun_wait(g_cmd)  #FUN-660216 add
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_shc),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_shb.shb01 IS NOT NULL THEN
                 LET g_doc.column1 = "shb01"
                 LET g_doc.value1 = g_shb.shb01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
END FUNCTION
 
#FUN-A70095 ------------------------Begin--------------------------
FUNCTION t730_confirm()
   DEFINE l_cnt       LIKE type_file.num10
   DEFINE l_shb01     LIKE shb_file.shb01
   DEFINE l_flag      LIKE type_file.num5

   LET g_success = 'Y'
   CALL t730sub_y_chk(g_shb.shb01,TRUE)
   #TQC-C90020---add----s
   IF g_success = 'Y' THEN
      BEGIN WORK
   #TQC-C90020---add----e
   IF t730_accept_qty('c') THEN LET g_success = 'N' END IF  #TQC-C20006 add
   #IF g_success = 'Y' THEN    #TQC-C90020  mark
   #   BEGIN WORK              #TQC-C90020  mark
      IF NOT cl_confirm('axm-108') THEN
         LET g_success='N'
      ELSE
         IF g_success = 'Y' THEN    #add by guanyao160901
            CALL t730sub_confirm(g_shb.shb01,'')
         END IF                     #add by guanyao160901
      END IF
      IF g_success = 'Y' THEN  #for 號機管理
         IF g_sma.sma1431='Y' THEN
            CALL t730sub_shb081(g_shb.*,g_sgm.*,g_shb_t.*)  RETURNING l_flag,g_shb.*,g_sgm.*
            CALL t730sub_auto_report(g_shb.*,g_sgm.*)
         END IF
      END IF
      IF g_success='Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
   END IF
   CALL t730_show()
END FUNCTION   

FUNCTION t730_unconfirm()
   DEFINE l_cnt       LIKE type_file.num10
   DEFINE l_shb01     LIKE shb_file.shb01
   DEFINE l_flag      LIKE type_file.num5

   LET g_success = 'Y'
   CALL t730sub_y_chk(g_shb.shb01,FALSE)
   IF g_success = 'Y' THEN
      BEGIN WORK
      IF NOT cl_confirm('axm-108') THEN
        LET g_success='N'
      ELSE
         CALL t730sub_unconfirm(g_shb.shb01)
      END IF
      IF g_success='Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
   END IF
   CALL t730_show()
END FUNCTION
#FUN-A70095 ----------------------------End-----------------------------------

FUNCTION t730_a(l_flag,l_flag1)            
  DEFINE l_flag      LIKE type_file.chr1
  DEFINE l_flag1     LIKE type_file.chr1 
  DEFINE l_count    LIKE type_file.num5     
  DEFINE li_result   LIKE type_file.num5   #No.FUN-550067   #No.FUN-680121 SMALLINT
  #DEFINE l_shb021    LIKE shb_file.shb021  #No.FUN-680121 VARCHAR(8)  #TQC-C90018  mark
  DEFINE l_shb031    LIKE shb_file.shb031                              #TQC-C90018  add 
  DEFINE l_factor    LIKE ecm_file.ecm59   #No.FUN-680121 DEC(16,8)
  DEFINE g_sw        LIKE type_file.num5    #No.FUN-680121 SMALLINT 
  DEFINE l_pmc03     LIKE pmc_file.pmc03  #FUN-A80102

    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_shc.clear()
    INITIALIZE g_shb.* TO NULL
 
    LET g_shb_o.* = g_shb.*
    LET g_shb_t.* = g_shb.*
 
    IF l_flag1 = 'F' THEN 
       LET g_shb.* = g_shb_bak.*       
       #TQC-BA0003(S) #入庫項次若為0則清空
       IF g_shb.shb15=0 AND g_shb.shb14 IS NULL THEN
          LET g_shb.shb15 = NULL
       END IF
       #TQC-BA0003(E)
       LET g_shb.shb05 = NULL
       LET g_shb.shb16 = NULL    
       LET g_shb.shb21 = NULL
       LET g_shb.shb22 = NULL 
       LET g_shb.shb111 = ''
       LET g_shb.shb031 = ''
       LET g_shb.shb032 = ''       
       LET g_shb.shb033 = ''       
       LET g_shb.shbacti = 'Y'
       LET g_shb.shbmodu = NULL
       LET g_shb.shbdate = NULL 
       LET g_shb.shbinp = g_today
       LET g_shb.shbconf = 'N'   #TQC-BA0003
       IF g_aza.aza41 = '1' THEN 
          LET l_count = '3'
       ELSE
   	  IF g_aza.aza41 = '2' THEN 
   	     LET l_count = '4'
   	  ELSE 
   	         LET l_count = '5'
   	  END IF 
       END IF               
       LET g_shb.shb01 = g_shb.shb01[1,l_count]                               #CHI-9B0005 mod 
    END IF 
    
    CALL cl_opmsg('a')
    WHILE TRUE
      IF l_flag1 IS NULL OR l_flag1='F' THEN           #NO.FUN-940113 #TQC-BA0003          
        LET g_shb.shb02   = g_today
        LET g_shb.shb03   = g_today
         LET g_shb.shb04   = g_user    #---No.MOD-530548
        LET g_shb.shb111  = 0
        LET g_shb.shb113  = 0
        LET g_shb.shb115  = 0
        LET g_shb.shb112  = 0
        LET g_shb.shb114  = 0
        LET g_shb.shb17   = 0
        #LET l_shb021 = TIME                 #TQC-C90018  mark
        #LET g_shb.shb021  = l_shb021[1,5]   #TQC-C90018  mark
        LET l_shb031 = TIME                  #TQC-C90018  add
        LET g_shb.shb031  = l_shb031[1,5]    #TQC-C90018  add
        LET g_shb.shbinp  = g_today
        LET g_shb.shbacti = 'Y'  
        LET g_shb.shbuser = g_user 
        LET g_shb.shboriu = g_user #FUN-980030
        LET g_shb.shborig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_shb.shbgrup = g_grup 
        LET g_shb.shbmodu = '' 
        LET g_shb.shbdate = ''  
        IF g_sma.sma541 = 'N' THEN  #FUN-A60095
           LET g_shb.shb012 = ' '   #FUN-A60095
        END IF                      #FUN-A60095 
 
        LET g_shb.shbplant = g_plant #FUN-980008 add
        LET g_shb.shblegal = g_legal #FUN-980008 add
        LET g_shb.shbconf = 'N'      #FUN-A70095
        LET g_shb.shb32 = ''         #FUN-A70095
 
        IF NOT cl_null(g_argv1) THEN    #委外轉入
           LET g_shb.shb16 = g_pmn18
           LET g_shb.shb05 = g_rvv.rvv18 
           LET g_shb.shb06 = g_pmn32
           LET g_shb.shb012= g_pmn012   #FUN-A60095
           LET g_shb.shb081= g_sgm04 
           LET g_shb.shb082= g_sgm05 
           LET g_shb.shb14 = g_argv1
           LET g_shb.shb15 = g_argv3
           CALL t730_sfb() RETURNING g_i
 
           #---單位轉換
           CALL s_umfchk(g_shb.shb10,g_rvv.rvv35,g_sgm58) RETURNING g_sw,l_factor               
           IF l_factor IS NULL THEN LET l_factor=1 END IF
           LET g_shb.shb111 = g_rvv.rvv17*l_factor
           #No.FUN-BB0086--add--begin--
           SELECT sgm58 INTO g_shb.shb34 FROM sgm_file 
           #WHERE sgm01=g_shb.shb05             #TQC-D40100 mark
            WHERE sgm01=g_shb.shb16             #TQC-D40100 add  
              AND sgm03=g_shb.shb06
              AND sgm012=g_shb.shb012
           LET g_shb.shb111 = s_digqty(g_shb.shb111,g_shb.shb34)   
           #No.FUN-BB0086--add--end--
           DISPLAY BY NAME g_shb.shb05,g_shb.shb06,g_shb.shb111,
                           g_shb.shb14,g_shb.shb15,g_shb.shb012  #FUN-A60095
           #FUN-A80102(S)
           LET g_shb.shb28 = g_rvv.rvv36
           LET g_shb.shb29 = g_rvv.rvv04
           SELECT pmm09,pmc03 INTO g_shb.shb27,l_pmc03 
             FROM pmm_file LEFT OUTER JOIN pmc_file ON (pmm09=pmc01)
            WHERE pmm01=g_shb.shb28
           DISPLAY BY NAME g_shb.shb27,g_shb.shb28,g_shb.shb29
           DISPLAY l_pmc03 TO FORMONLY.pmc03
           #FUN-A80102(E)
           CALL t730_shb081_relation() RETURNING g_i  #FUN-A80102
           CALL t730_accept_qty('d') RETURNING g_i
        END IF  
        DISPLAY BY NAME g_shb.shbuser,g_shb.shbgrup,g_shb.shbmodu,g_shb.shbdate,g_shb.shbconf    #FUN-A70095 add shbconf 
    END IF 	          #NO.FUN-940113     
            
         #FUN-A80102(S)
         LET g_shb.shb30 ='N'  
         DISPLAY By NAME g_shb.shb30
         IF g_sma.sma1435='N' THEN
            LET g_shb.shb021 = "00:00"
            LET g_shb.shb031 = "00:00"
            DISPLAY BY NAME g_shb.shb021,g_shb.shb031
         END IF
         #FUN-A80102(E)
         CALL t730_i("a",l_flag1)                   #NO.FUN-940113   
        IF INT_FLAG THEN
           LET INT_FLAG=0 CALL cl_err('',9001,0)
           INITIALIZE g_shb.* TO NULL
           CLEAR FORM
           CALL g_shc.clear()
           EXIT WHILE
        END IF
        IF g_shb.shb01 IS NULL THEN CONTINUE WHILE END IF
 
        #FUN-A80102(S)
        SELECT * INTO g_sgm.* FROM sgm_file
         WHERE sgm01=g_shb.shb16 AND sgm03=g_shb.shb06
           AND sgm012=g_shb.shb012
        IF g_sma.sma1435='N' THEN
           LET g_shb.shb032 = (g_shb.shb111+g_shb.shb112+g_shb.shb113+g_shb.shb114+g_shb.shb115) * g_sgm.sgm14 / 60
           LET g_shb.shb033 = (g_shb.shb111+g_shb.shb112+g_shb.shb113+g_shb.shb114+g_shb.shb115) * g_sgm.sgm16 / 60
           DISPLAY BY NAME g_shb.shb032,g_shb.shb033
        END IF
        #FUN-A80102(E)
 
        BEGIN WORK   #No:7829
        CALL s_auto_assign_no("asf",g_shb.shb01,g_shb.shb03,"9","shb_file","shb01","","","") 
           RETURNING li_result,g_shb.shb01                                                    
        IF (NOT li_result) THEN                 
           ROLLBACK WORK   #No:7829
           CONTINUE WHILE
        END IF
	      DISPLAY BY NAME g_shb.shb01
        LET g_success='Y'
        IF cl_null(g_shb.shb012) THEN LET g_shb.shb012=' ' END IF #FUN-A60095
        IF cl_null(g_shb.shb06) THEN LET g_shb.shb06=0 END IF  #FUN-A60095
        IF cl_null(g_shb.shb26) THEN LET g_shb.shb26 ='N' END IF #FUN-A80102
        IF cl_null(g_shb.shb30) THEN LET g_shb.shb30 ='N' END IF #FUN-A80102
        IF cl_null(g_shb.shb31) THEN LET g_shb.shb31 ='N' END IF #FUN-A80102
        IF cl_null(g_shb.shbconf) THEN LET g_shb.shbconf = 'N' END IF   #FUN-A70095  
        INSERT INTO shb_file VALUES (g_shb.*)
        IF STATUS THEN 
           CALL cl_err3("ins","shb_file",g_shb.shb01,"",STATUS,"","",1)  #No.FUN-660128
           ROLLBACK WORK
           EXIT WHILE
        END IF
 
       #COMMIT WORK    #No:7829 #FUN-A90057 mark
        CALL cl_flow_notify(g_shb.shb01,'I')
    #FUN-A70095 -------------Begin---------------
       ##FUN-A80102(S)
       #IF g_sma.sma1431='Y' THEN
       #   CALL t730sub_auto_report(g_shb.*,g_sgm.*)
       #END IF
       ##FUN-A80102(E)
    #FUN-A70095 -------------End-----------------

        SELECT shb01 INTO g_shb.shb01 FROM shb_file WHERE shb01 = g_shb.shb01
        LET g_shb_t.* = g_shb.*
        LET g_shb_bak.* = g_shb.*                 #NO.FUN-940113
        
       #BEGIN WORK     #No:7829  #FUN-A90057 mark
       #CALL t730sub_upd_sgm('a',g_shb.*)    # Update 製程追蹤檔  #FUN-A80102 #FUN-A70095
       #   RETURNING g_shb.*        #FUN-A70095
        IF g_success='N' THEN 
       #FUN-A70095 -----Begin-----  
       #   CLEAR FORM
       #   CALL g_shc.clear()
       #   ROLLBACK WORK
       #   EXIT WHILE
           ROLLBACK WORK
       #FUN-A70095 -----End-------
        ELSE
       #FUN-A70095 ----------------Begin----------------------- 
       #   IF g_shb.shb112 > 0 THEN    #表示有報廢數量
       #     #update 工單單頭報廢量
       #      UPDATE sfb_file SET sfb12 = sfb12 + g_shb.shb112
       #       WHERE sfb01 = g_shb.shb05 
       #      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN 
       #         CALL cl_err(g_shb.shb05,'asf-861',1)
       #         ROLLBACK WORK
       #         CLEAR FORM
       #         CALL g_shc.clear()
       #      ELSE
       #         COMMIT WORK
       #      END IF
       #   ELSE
       #      COMMIT WORK
       #   END IF
       #FUN-A70095 ----------------End-------------------------
           COMMIT WORK    #FUN-A70095
        END IF
        IF g_shb.shb114 > 0 THEN CALL t701(g_shb.shb01) END IF
        CALL g_shc.clear()
        LET g_rec_b = 0 
        CALL t730_b() #輸入單身-shc
        EXIT WHILE
    END WHILE
END FUNCTION
 
 FUNCTION t730_i(p_cmd,l_flag1)                      #NO.FUN-940113   
  DEFINE l_flag1         LIKE type_file.chr1         #NO.FUN-940113 
  DEFINE li_result   LIKE type_file.num5          #No.FUN-550067   #No.FUN-680121 SMALLINT
  DEFINE p_cmd           LIKE type_file.chr1                 #a:輸入 u:更改  #No.FUN-680121 VARCHAR(1)
  DEFINE l_flag          LIKE type_file.chr1                 #判斷必要欄位是否有輸入  #No.FUN-680121 VARCHAR(1)
  DEFINE l_cnt           LIKE type_file.num5    #No.FUN-680121 SMALLINT
  DEFINE l_n             LIKE type_file.num5    #FUN-B20079
  DEFINE l_sgm04         LIKE sgm_file.sgm04
  DEFINE l_sgm45         LIKE sgm_file.sgm45
  DEFINE l_shm012        LIKE shm_file.shm012
  DEFINE A,b1,b2,c1,c2,c3     LIKE type_file.num5    #No.FUN-680121 SMALLINT             
  DEFINE g_c1,g_c11,g_c12     LIKE type_file.num5    #No.FUN-680121 SMALLINT 
  DEFINE l_close,l_open       LIKE type_file.dat     #No.FUN-680121 DATE
  DEFINE l_sfb93              LIKE sfb_file.sfb93    #FUN-A60095
  DEFINE l_sgm65              LIKE sgm_file.sgm65    #FUN-A60095
  DEFINE l_chk_time1          LIKE type_file.num10   #TQC-C90018  add
  
 
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   IF l_flag1 = 'F' THEN 
      DISPLAY BY NAME g_shb.shb01,g_shb.shb04,g_shb.shb16,g_shb.shb05,g_shb.shb081,
                      g_shb.shb06,g_shb.shb10,g_shb.shb08,g_shb.shb07,
                      g_shb.shb09,g_shb.shb02,g_shb.shb021,g_shb.shb03,g_shb.shb031,
                      g_shb.shb032,g_shb.shb033,g_shb.shb111,g_shb.shb115,g_shb.shb112,
                      g_shb.shb113,g_shb.shb12,g_shb.shb114,g_shb.shb14,g_shb.shb15,
                      g_shb.shb13,g_shb.shb012,g_shb.shb121  #FUN-A60095                                     
              DISPLAY g_gen02,gg_ima02,gg_ima021,g_wip,g_pqc,g_tot_pqc,g_sgm53,g_sgm54
                   TO FORMONLY.gen02,FORMONLY.ima02,FORMONLY.ima021,FORMONLY.wip,
                      FORMONLY.pqc,FORMONLY.tot_pqc,sgm53,sgm54   
   END IF 
    
   INPUT BY NAME g_shb.shb01,g_shb.shb04,g_shb.shb16,g_shb.shb05,g_shb.shb012, #FUN-A60095
                 g_shb.shb081, g_shb.shboriu,g_shb.shborig,
                 g_shb.shb082,g_shb.shb06,g_shb.shb08,g_shb.shb07,g_shb.shb09,
                 g_shb.shb02,g_shb.shb021,g_shb.shb03,g_shb.shb031,g_shb.shb032,g_shb.shb033,  #FUN-910076
                 g_shb.shb111,g_shb.shb115,g_shb.shb112,g_shb.shb113,g_shb.shb121,g_shb.shb12, #FUN-A60095  #FUN-A70095
                 g_shb.shb114,g_shb.shb34,g_shb.shb15,g_shb.shb13,        #-- No.MOD-530548 
                 g_shb.shbud01,g_shb.shbud02,g_shb.shbud03,g_shb.shbud04,g_shb.shbud05,   #FUN-A70095
                 g_shb.shbud06,g_shb.shbud07,g_shb.shbud08,g_shb.shbud09,g_shb.shbud10,   #FUN-A70095
                 g_shb.shbud11,g_shb.shbud12,g_shb.shbud13,g_shb.shbud14,g_shb.shbud15    #FUN-A70095
        WITHOUT DEFAULTS 
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t730_set_entry(p_cmd)
            CALL t730_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
         CALL cl_set_docno_format("shb01")                                                                                          
         CALL cl_set_docno_format("shb05")                                                                                          
         #FUN-A60095--begin--add-----------
         IF NOT cl_null(g_shb.shb05) THEN
            SELECT sfb93 INTO l_sfb93 FROM sfb_file
            WHERE sfb01=g_shb.shb05
         END IF
         #FUN-A60095--end--add------------   
           #No.FUN-BB0086--add--begin--
           SELECT sgm58 INTO g_shb.shb34 FROM sgm_file 
           #WHERE sgm01=g_shb.shb05                    #TQC-D40100 mark
            WHERE sgm01=g_shb.shb16                    #TQC-D40100 add
              AND sgm03=g_shb.shb06 
              AND sgm012=g_shb.shb012
           DISPLAY BY NAME g_shb.shb34
           #No.FUN-BB0086--add--end--
 
        AFTER FIELD shb01  
         IF NOT cl_null(g_shb.shb01) AND (g_shb.shb01 !=g_shb_t.shb01 OR g_shb_t.shb01 IS NULL) THEN   #TQC-740145
            CALL s_check_no("asf",g_shb.shb01, g_shb_t.shb01,"9","shb_file","shb01","")  
            RETURNING li_result,g_shb.shb01                                                   
            DISPLAY BY NAME g_shb.shb01                                                                                             
            IF (NOT li_result) THEN                                                                                                 
               LET g_shb.shb01=g_shb_o.shb01                                                                                        
               NEXT FIELD shb01                                                                                                     
            END IF                                                                                                                  
          END IF
 
        AFTER FIELD shb04  
            IF NOT cl_null(g_shb.shb04) THEN 
               SELECT COUNT(*) INTO g_cnt FROM gen_file 
               WHERE gen01= g_shb.shb04 
               IF cl_null(g_cnt) OR g_cnt = 0 THEN 
               #  CALL cl_err('不為作業員工',STATUS,1)    #TQC-B60124
                  LET g_shb.shb04 = NULL                  #TQC-B60124  
                  CALL cl_err(g_shb.shb04,'aap-038',0)    #TQC-B60124   
                  NEXT FIELD shb04 
               END IF 
               CALL t730_shb04('d')
            END IF 
 
        AFTER FIELD shb07  
            IF NOT cl_null(g_shb.shb07) THEN 
               SELECT COUNT(*) INTO g_cnt FROM eca_file 
               WHERE eca01 = g_shb.shb07 
               IF g_cnt = 0 THEN 
                  CALL cl_err(g_shb.shb07,100,0)
                  LET g_shb.shb07 = g_shb_t.shb07
                  DISPLAY BY NAME g_shb.shb07
                  NEXT FIELD shb07
               END IF
            END IF
 
        AFTER FIELD shb09
            IF NOT cl_null(g_shb.shb09) THEN
               SELECT COUNT(*) INTO g_cnt FROM eci_file
                WHERE eci01=g_shb.shb09
               IF g_cnt=0 THEN
                  CALL cl_err(g_shb.shb09,'aec-011',0) NEXT FIELD shb09
               END IF
            END IF
 
        AFTER FIELD shb16  
            IF NOT cl_null(g_shb.shb16) THEN
               SELECT shm012,shm18 INTO l_shm012,g_shb.shb25 FROM shm_file  #FUN-A90057
                 WHERE shm01 = g_shb.shb16
               IF SQLCA.sqlcode THEN 
                  CALL cl_err3("sel","shm_file",g_shb.shb16,"",STATUS,"","",1)  #No.FUN-660128
                  LET g_shb.shb16 = g_shb_t.shb16
                  DISPLAY BY NAME g_shb.shb16 
                  NEXT FIELD shb16
               END IF 
               DISPLAY BY NAME g_shb.shb25  #FUN-A90057
               LET g_shb.shb05 = l_shm012
               SELECT sfb05 INTO g_shb.shb10 FROM sfb_file 
                WHERE sfb01=g_shb.shb05  
                  AND ((sfb04 IN ('4','5','6','7') AND sfb39='1') OR
                      (sfb04 IN ('2','3','4','5','6','7') AND sfb39='2'))
                  AND (sfb28 <> '3' OR sfb28 IS NULL)
               IF SQLCA.sqlcode THEN   #資料不存在
                  CALL cl_err(g_shb.shb05,'asf-018',1)
                  LET g_shb.shb05 = g_shb_t.shb05
                  DISPLAY BY NAME g_shb.shb05 
                  NEXT FIELD shb16
               ELSE 
                  DISPLAY BY NAME g_shb.shb05,g_shb.shb10 
                  CALL t730_shb10('d')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_shb.shb10,g_errno,0)   
                     LET g_shb.shb10 = g_shb_t.shb10
                     DISPLAY BY NAME g_shb.shb10
                     NEXT FIELD shb16
                  END IF
               END IF
               SELECT COUNT(*) INTO l_cnt FROM sfb_file 
                WHERE sfb01=g_shb.shb05 AND sfb02='7'
               IF l_cnt > 0 THEN
                  CALL cl_err(g_shb.shb05,'asf-817',1) 
               END IF
                CALL t730_set_no_entry(p_cmd)    #--No.MOD-530548
               CALL t730_chk_runcard(g_shb.shb16,g_shb.shb05,g_shb.shb06,g_shb.shb081,g_shb.shb14,g_shb.shb012) #FUN-A60095
               IF NOT cl_null(g_errno) THEN          
                  CALL cl_err(g_shb.shb16,g_errno,1)   
                  NEXT FIELD shb16 
               END IF           
               SELECT sfb93 INTO l_sfb93 FROM sfb_file WHERE sfb01=g_shb.shb05  #FUN-A60095
            END IF
 
#FUN-A60095--begin--add------------------
        AFTER FIELD shb012
           IF NOT cl_null(g_shb.shb012) THEN
              LET l_cnt = 0
              SELECT    COUNT(*) INTO l_cnt FROM sgm_file
               WHERE sgm01=g_shb.shb16
                 AND sgm012=g_shb.shb012
              IF l_cnt = 0 THEN
                 CALL cl_err('','abm-214',1)
                 NEXT FIELD shb012
              END IF
              CALL t730_shb012('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('sel ecu:',g_errno,0)
                  LET g_shb.shb012=g_shb_t.shb012
                  NEXT FIELD shb012
               END IF
              IF cl_null(g_shb.shb081) THEN  #FUN-B20079
                 CALL t730_shb082('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('sel ecu:',g_errno,0)
                    LET g_shb.shb012=g_shb_t.shb012
                    NEXT FIELD shb012
                 END IF
        #FUN-B20079--add--begin
              ELSE
                 IF cl_null(g_shb.shb06) THEN
                    CALL t730_sgm03()
                 END IF
                 CALL t730_chk_sgm()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('sel sgm:',g_errno,0)
                    LET g_shb.shb012=g_shb_t.shb012
                    NEXT FIELD shb012
                 END IF
              END IF
        #FUN-B20079--add--end
           END IF
           #No.FUN-BB0086--add--begin--
           SELECT sgm58 INTO g_shb.shb34 FROM sgm_file
           #WHERE sgm01=g_shb.shb05                     #TQC-D40100 mark
            WHERE sgm01=g_shb.shb16                     #TQC-D40100 add
              AND sgm03=g_shb.shb06
              AND sgm012=g_shb.shb012
           LET g_shb.shb111 = s_digqty(g_shb.shb111,g_shb.shb34)
           LET g_shb.shb112 = s_digqty(g_shb.shb112,g_shb.shb34)
           LET g_shb.shb114 = s_digqty(g_shb.shb114,g_shb.shb34)
           DISPLAY BY NAME g_shb.shb34,g_shb.shb111,g_shb.shb112,g_shb.shb114
           #No.FUN-BB0086--add--end--

        AFTER FIELD shb06
           IF NOT cl_null(g_shb.shb06) THEN
              IF cl_null(g_shb.shb012) THEN LET g_shb.shb012=' ' END IF #FUN-A60095
              LET l_cnt = 0
              SELECT    COUNT(*) INTO l_cnt FROM sgm_file
               WHERE sgm01=g_shb.shb16
                 AND sgm012=g_shb.shb012
                 AND sgm03=g_shb.shb06
              IF l_cnt = 0 THEN
                 CALL cl_err('','abm-215',1)
                 NEXT FIELD shb06
              END IF
              IF cl_null(g_shb.shb081) THEN  #FUN-B20079
                 CALL t730_shb082('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('sel ecu:',g_errno,0)
                    LET g_shb.shb06=g_shb_t.shb06
                    NEXT FIELD shb06
                 END IF
     #FUN-B20079--add--begin
              ELSE 
                 CALL t730_chk_sgm()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('sel sgm:',g_errno,0)
                    LET g_shb.shb012=g_shb_t.shb012
                    NEXT FIELD shb06
                 END IF 
              END IF
     #FUN-B20079--add--end
           END IF
#FUN-A60095--end--add----------------------
           #No.FUN-BB0086--add--begin--
           SELECT sgm58 INTO g_shb.shb34 FROM sgm_file
           #WHERE sgm01=g_shb.shb05                    #TQC-D40100 mark
            WHERE sgm01=g_shb.shb16                    #TQC-D40100 add
              AND sgm03=g_shb.shb06
              AND sgm012=g_shb.shb012
           LET g_shb.shb111 = s_digqty(g_shb.shb111,g_shb.shb34)
           LET g_shb.shb112 = s_digqty(g_shb.shb112,g_shb.shb34)
           LET g_shb.shb114 = s_digqty(g_shb.shb114,g_shb.shb34)
           DISPLAY BY NAME g_shb.shb34,g_shb.shb111,g_shb.shb112,g_shb.shb114
           #No.FUN-BB0086--add--end--

#-----------由委外入庫轉入時,作業編號不可異動
        AFTER FIELD shb081  
            IF NOT cl_null(g_shb.shb081) THEN
        #FUN-B20079--add--begin
               LET l_cnt = 0
               IF g_shb.shb012 IS NOT NULL THEN
                  SELECT COUNT(*) INTO l_cnt FROM sgm_file
                   WHERE sgm01=g_shb.shb16 AND sgm012=g_shb.shb012
                     AND sgm04=g_shb.shb081
               ELSE
                  SELECT COUNT(*) INTO l_cnt FROM sgm_file
                   WHERE sgm01=g_shb.shb16 AND sgm04=g_shb.shb081
               END IF
               IF l_cnt = 0 THEN CALL cl_err('','aec-015',1) NEXT FIELD shb081 END IF
               CALL t730_shb081()
        #FUN-B20079--add--end
               IF p_cmd='a' THEN  #TQC-C20244
                  IF t730_shb081_relation() THEN NEXT FIELD shb081 END IF  #FUN-A80102
               #TQC-C20244--begin
               ELSE
                  LET g_shb_t.shb06=g_shb.shb06
                  LET g_shb.shb06=null
                  IF t730_shb081_relation() THEN NEXT FIELD shb081 END IF  
                  IF cl_null(g_shb.shb06) THEN
                     LET g_shb.shb06=g_shb_t.shb06
                     IF t730_shb081_relation() THEN NEXT FIELD shb081 END IF  
                  END IF 
               END IF 
               #TQC-C20244--end
              #此站為製程外包
               IF g_sgm.sgm52 = 'Y' THEN 
                 #檢查是否有入庫資料
                  CALL t730_ck_pmn(g_shb.shb05,g_shb.shb06)
                  IF NOT cl_null(g_errno) THEN 
                     CALL cl_err(g_shb.shb05,g_errno,1)
                     NEXT FIELD shb081
                  END IF
               END IF
               CALL t730_accept_qty('d') RETURNING g_i
               IF g_sma.sma897='N' THEN
                  SELECT COUNT(*) INTO g_cnt FROM shb_file
                   WHERE shb16 = g_shb.shb16 AND shb06 = g_shb.shb06
                     AND shb012 = g_shb.shb012  #FUN-A60095
                  IF g_cnt > 0 THEN
                     CALL cl_err('','asf-900',0)
                     NEXT FIELD shb081
                  END IF
               END IF
               CALL t730_chk_runcard(g_shb.shb16,g_shb.shb05,g_shb.shb06,g_shb.shb081,g_shb.shb14,g_shb.shb012) #FUN-A60095 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_shb.shb16,g_errno,1)
                  NEXT FIELD shb081 
               END IF
            END IF
        AFTER FIELD shb08
            IF NOT cl_null(g_shb.shb08) THEN 
               SELECT count(*) INTO g_cnt FROM ecg_file 
                WHERE ecg01 = g_shb.shb08
               IF g_cnt = 0  THEN
                  CALL cl_err(g_shb.shb08,100,0)
                  LET g_shb.shb08 = g_shb_t.shb08
                  DISPLAY BY NAME g_shb.shb08
                  NEXT FIELD shb08
               END IF
            END IF
 
        AFTER FIELD shb021
            IF NOT cl_null(g_shb.shb021) THEN
               LET g_h1=g_shb.shb021[1,2]
               LET g_m1=g_shb.shb021[4,5]
               LET g_h2=g_shb.shb031[1,2]
               LET g_m2=g_shb.shb031[4,5]
               IF cl_null(g_h1) OR cl_null(g_m1) OR g_h1>24 OR g_m1>=60
                  THEN
                  #CALL cl_err(g_shb.shb021,'!',0)        #TQC-C90018   mark
                  CALL cl_err(g_shb.shb021,'asf-807',0)   #TQC-C90018   add
                  NEXT FIELD shb021
               END IF
               LET g_sum_m1=g_h1*60+g_m1
               LET g_sum_m2=g_h2*60+g_m2
               #TQC-C90018----add----begin----
               LET l_chk_time1 = (g_shb.shb03-g_shb.shb02)* 24 * 60 + g_sum_m2-g_sum_m1
               IF l_chk_time1<0 THEN
                  CALL cl_err(g_shb.shb021,'asf-917',0)  #TQC-C80129 1->0
               END IF
               #TQC-C90018----add----end------
               LET g_shb.shb032=(g_shb.shb03-g_shb.shb02)*24*60+(g_sum_m2-g_sum_m1)
               IF g_shb.shb032 < 0 THEN LET g_shb.shb032=0 END IF #TQC-C90018 add
               LET g_shb.shb033=g_shb.shb032     #FUN-910076
               DISPLAY BY NAME g_shb.shb032 
               DISPLAY BY NAME g_shb.shb033      #FUN-910076
            END IF 
 
        AFTER FIELD shb03
            IF NOT cl_null(g_shb.shb03) THEN 
               SELECT sfb81,sfb37 INTO l_open,l_close 
                 FROM sfb_file WHERE sfb01=g_shb.shb05
               IF g_shb.shb03 < l_open OR g_shb.shb03 > l_close THEN
                  CALL cl_err('','asf-904',0)
                  NEXT FIELD shb03
               END IF
#bugno:5206 add check 成會關帳日期...................................
               IF g_shb.shb03 <= g_sma.sma53 THEN 
                  CALL cl_err('','axm-164',0)
                  NEXT FIELD shb03
               END IF
            END IF
 
        AFTER FIELD shb031
            IF NOT cl_null(g_shb.shb031) THEN 
               LET g_h1=g_shb.shb021[1,2]
               LET g_m1=g_shb.shb021[4,5]
               LET g_h2=g_shb.shb031[1,2]
               LET g_m2=g_shb.shb031[4,5]
               IF cl_null(g_h2) OR cl_null(g_m2) OR g_h2>24 OR g_m2>=60 THEN
                  #CALL cl_err(g_shb.shb031,'!',0)           #TQC-C90018  mark
                  CALL cl_err(g_shb.shb031,'asf-807',0)      #TQC-C90018  add
                  NEXT FIELD shb031
               END IF
               LET g_sum_m1=g_h1*60+g_m1
               LET g_sum_m2=g_h2*60+g_m2
               #TQC-C90018----add----begin----
               LET l_chk_time1 = (g_shb.shb03-g_shb.shb02)* 24 * 60 + g_sum_m2-g_sum_m1
               IF l_chk_time1<0 THEN
                  CALL cl_err(g_shb.shb031,'asf-917',0)  #TQC-C80129 1->0
               END IF
               #TQC-C90018----add----end------
               LET g_shb.shb032=(g_shb.shb03-g_shb.shb02)*24*60+(g_sum_m2-g_sum_m1)
               IF g_shb.shb032 < 0 THEN LET g_shb.shb032=0 END IF #TQC-C90018 add
               LET g_shb.shb033=g_shb.shb032     #FUN-910076
               DISPLAY BY NAME g_shb.shb032
               DISPLAY BY NAME g_shb.shb033      #FUN-910076
            END IF 
 
        BEFORE FIELD shb032
            IF g_shb.shb032 = 0 THEN 
               LET g_shb.shb032 = (g_shb.shb03-g_shb.shb02) * 8 +
                                  (g_shb.shb031-g_shb.shb021) 
               LET g_shb.shb033=g_shb.shb032     #FUN-910076
               DISPLAY BY NAME g_shb.shb032 
               DISPLAY BY NAME g_shb.shb033      #FUN-910076
            END IF 
	    IF g_shb.shb03 IS NULL OR g_shb.shb032 = 0 THEN
               LET g_shb.shb032 = g_shb_t.shb032
               LET g_shb.shb033=g_shb.shb032     #FUN-910076
               DISPLAY By NAME g_shb.shb032
               DISPLAY BY NAME g_shb.shb033      #FUN-910076
            END IF
 
        AFTER FIELD shb032
            IF NOT cl_null(g_shb.shb032) THEN 
               IF g_shb.shb032 < 0 THEN 
                  CALL cl_err(g_shb.shb032,'!',1) 
                  NEXT FIELD shb032 
               END IF 
               LET g_m1 = g_shb.shb031[1,2] 
               LET g_h1 = g_shb.shb031[4,5] 
               LET g_sum_m1 = g_m1*60+g_h1 
             
               #判斷滿一天否
               LET c1 = (g_shb.shb032/1440)       #天
               IF (c1 < 1) THEN    #不滿一天
                  IF (g_shb.shb032 > g_sum_m1) THEN  #大於報工時間,日期往前推
                     LET g_shb.shb02 = g_shb.shb03 - 1 
                     LET g_c1 =' ' 
                     LET g_c12=' ' 
                     LET g_c11=' '  
                     LET g_c1 = g_shb.shb032 - g_sum_m1 
                     
                     LET g_shb.shb021 ='00:00'
                     LET g_c11 = g_c1 /60    #小時
 
                     LET g_c12 = (g_c1 MOD 60)      
                     IF g_c12 = 0 THEN 
                        LET g_c11 = g_c11 - 1
                        LET g_c12 = 60
                     END IF
 
                     LET g_shb.shb021[1,2] = 23 - g_c11 
                     IF cl_null(g_shb.shb021[2,2]) THEN 
                       LET g_shb.shb021[1,1]='0'
                       LET g_shb.shb021[2,2] =23 - g_c11 
                     END IF 
                     LET g_shb.shb021[4,5] = 60 - g_c12 
                     IF cl_null(g_shb.shb021[5,5]) THEN 
                       LET g_shb.shb021[4,4]='0' 
                       LET g_shb.shb021[5,5]=60  - g_c12 
                     END IF 
                   ELSE 
                      LET g_shb.shb02 = g_shb.shb03 
                      LET g_c1 = ' ' 
                      LET g_c12= ' ' 
                      LET g_c11= ' ' 
                      LET g_c1 = g_shb.shb032- g_sum_m1  #分
                      IF g_c1 < 0 THEN 
                          LET g_c1 = -g_c1 
                      END IF 
                      LET g_c11 = g_c1 / 60
                      LET g_shb.shb021 ='00:00'
                      LET g_shb.shb021[1,2]=g_c11       
                      IF cl_null(g_shb.shb021[2,2]) THEN 
                         LET g_shb.shb021[1,1]='0'
                         LET g_shb.shb021[2,2]=g_c11 
                      END IF            
                      LET g_c12 = g_c1 MOD 60         
                      LET g_shb.shb021[4,5] = g_c12 
                      IF cl_null(g_shb.shb021[5,5]) THEN  
                         LET g_shb.shb021[4,4]='0' 
                         LET g_shb.shb021[5,5]=g_c12 
                      END IF 
                    END IF 
               ELSE       #超過一天
display 'g_shb.shb02->',g_shb.shb02
display 'g_shb.shb03->',g_shb.shb03
display 'c1->',c1
                 LET g_shb.shb02 = g_shb.shb03 - c1            
display 'g_shb.shb02->',g_shb.shb02
                 LET g_shb.shb021='00:00' 
                 LET c2 = (g_shb.shb032 MOD 1440)   #分
display 'c2->',c2
display 'g_shb.shb02->',g_shb.shb02
                 LET A =  (g_shb.shb03-g_shb.shb02)*24*60+g_sum_m1 - g_shb.shb032 
display 'A=(g_shb.shb03-g_shb.shb02)*24*60+g_sum_m1 - g_shb.shb032)->',A
display 'g_sum_m1->',g_sum_m1
                 IF A < 0 THEN LET A = -A END IF 
                 IF A > g_sum_m1 THEN   #大於報工時間,在往前推一天
                     LET g_shb.shb02 = g_shb.shb02 - 1 
                     LET g_c11 = ' ' 
                     LET g_c12 = ' ' 
                     LET b1  = A/ 60 
                     LET b2 = (A MOD 60)      
                     IF b2 = 0 THEN 
                        LET b1 = b1 - 1
                        LET b2 = 60
                     END IF
                     LET g_c11 = 23 - b1 
                     LET g_shb.shb021[1,2] = g_c11 
                     IF cl_null(g_shb.shb021[2,2]) THEN 
                       LET g_shb.shb021[1,1]='0' 
                       LET g_shb.shb021[2,2]=g_c11  
                     END IF 
                     LET g_c12 = 60 - b2 
                     LET g_shb.shb021[4,5]= g_c12  
                     IF cl_null(g_shb.shb021[5,5]) THEN 
                       LET g_shb.shb021[4,4]='0' 
                       LET g_shb.shb021[5,5]= g_c12  
                     END IF 
                 ELSE 
                     LET b1 = A/ 60 
                     LET g_shb.shb021='00:00' 
                     LET g_shb.shb021[1,2] = b1 
                     IF cl_null(g_shb.shb021[2,2]) THEN 
                        LET g_shb.shb021[1,1]='0'
                        LET g_shb.shb021[2,2]= b1 
                     END IF 
                     LET b2 = (A MOD 60) 
                     LET g_shb.shb021[4,5] = b2 
                     IF cl_null(g_shb.shb021[5,5]) THEN 
                       LET g_shb.shb021[4,4] ='0' 
                       LET g_shb.shb021[5,5] = b2 
                     END IF 
                  END IF  
              END IF  
              DISPLAY BY NAME g_shb.shb02  
              DISPLAY BY NAME g_shb.shb021 
 
           END IF 
      
        AFTER FIELD shb033
            IF NOT cl_null(g_shb.shb033) THEN 
               IF g_shb.shb033 < 0 THEN 
                  CALL cl_err(g_shb.shb033,'!',1) 
                  NEXT FIELD shb033
               END IF 
            END IF
 
        BEFORE FIELD shb111 
   #--------由委外入庫轉入時,數量不可異動
            CALL t730_accept_qty('d') RETURNING g_i
 
        AFTER FIELD shb111
           #No.FUN-BB0086--add--begin---
           SELECT sgm58 INTO g_shb.shb34 FROM sgm_file
           #WHERE sgm01=g_shb.shb05                        #TQC-D40100 mark
            WHERE sgm01=g_shb.shb16                        #TQC-D40100 add
              AND sgm03=g_shb.shb06
              AND sgm012=g_shb.shb012
           LET g_shb.shb111 = s_digqty(g_shb.shb111,g_shb.shb34)  
           DISPLAY BY NAME g_shb.shb111
           #No.FUN-BB0086--add--end---
            IF NOT cl_null(g_shb.shb111) THEN 
               IF g_shb.shb111 < 0  THEN 
                  NEXT FIELD shb111
               END IF
               ## 檢查可報工數量
               IF t730_accept_qty('c') THEN NEXT FIELD shb111 END IF
               #FUN-A60095--begin--add-------------
               LET g_cnt = 0
               IF g_sma.sma541 = 'Y' AND l_sfb93 = 'Y' THEN
                  SELECT COUNT(*) INTO g_cnt FROM sfa_file
                   WHERE sfa01=g_shb.shb05
                     AND sfa012=g_shb.shb012
                     AND sfa013=g_shb.shb06
               ELSE
                  SELECT COUNT(*) INTO g_cnt FROM sfa_file
                   WHERE sfa01=g_shb.shb05
                     AND sfa08=g_shb.shb081
               END IF
               IF g_cnt > 0 THEN
                  CALL t730_shb111_a()
                  IF g_success='N' THEN NEXT FIELD shb111 END IF
               ELSE
                  IF g_sma.sma541='Y' AND l_sfb93 = 'Y' THEN
                     SELECT sgm65 INTO l_sgm65 FROM sgm_file WHERE sgm01=g_shb.shb16
                        AND sgm03=g_shb.shb06 AND sgm012=g_shb.shb012
                     IF g_shb.shb111 > l_sgm65 THEN
                        CALL cl_err('','asf-139',1)
                        NEXT FIELD shb111
                     END IF
                  END IF
               END IF
               #FUN-A60095--end--add-----------------
            END IF
 
        AFTER FIELD shb112
           #No.FUN-BB0086--add--begin---
           SELECT sgm58 INTO g_shb.shb34 FROM sgm_file
           #WHERE sgm01=g_shb.shb05                      #TQC-D40100 mark
            WHERE sgm01=g_shb.shb16                      #TQC-D40100 add
              AND sgm03=g_shb.shb06
              AND sgm012=g_shb.shb012
           LET g_shb.shb112 = s_digqty(g_shb.shb112,g_shb.shb34)  
           DISPLAY BY NAME g_shb.shb112
           #No.FUN-BB0086--add--end---
            IF NOT cl_null(g_shb.shb112) THEN 
               IF g_shb.shb112 < 0  THEN 
                  NEXT FIELD shb112
               END IF
               ## 檢查可報工數量
               IF t730_accept_qty('c') THEN NEXT FIELD shb112 END IF
            END IF
 
        BEFORE FIELD shb113
            CALL t730_set_entry(p_cmd)
 
        AFTER FIELD shb113
           #No.FUN-BB0086--add--begin---
           SELECT sgm58 INTO g_shb.shb34 FROM sgm_file
           #WHERE sgm01=g_shb.shb05                       #TQC-D40100 mark
            WHERE sgm01=g_shb.shb16                       #TQC-D40100 add
              AND sgm03=g_shb.shb06
              AND sgm012=g_shb.shb012
           LET g_shb.shb113 = s_digqty(g_shb.shb113,g_shb.shb34)  
           DISPLAY BY NAME g_shb.shb113
           #No.FUN-BB0086--add--end---
            IF NOT cl_null(g_shb.shb113) THEN 
               IF g_shb.shb113 < 0  THEN 
                  NEXT FIELD shb113
               END IF
 
              #重工轉出數量=0不輸入下製程
               IF g_shb.shb113 = 0  THEN 
                  LET g_shb.shb12 =''
                  LET g_shb.shb121=''   #FUN-A60095
                  DISPLAY BY NAME g_shb.shb12,g_shb.shb121  #FUN-A60095
               END IF 
 
               ## 檢查可報工數量
               IF t730_accept_qty('c') THEN NEXT FIELD shb113 END IF
               CALL t730_set_no_entry(p_cmd)
            END IF
 
       AFTER FIELD shb114
           #No.FUN-BB0086--add--begin---
           SELECT sgm58 INTO g_shb.shb34 FROM sgm_file 
           #WHERE sgm01=g_shb.shb05                     #TQC-D40100 mark
            WHERE sgm01=g_shb.shb16                     #TQC-D40100 add 
              AND sgm03=g_shb.shb06
              AND sgm012=g_shb.shb012
           LET g_shb.shb114 = s_digqty(g_shb.shb114,g_shb.shb34)  
           DISPLAY BY NAME g_shb.shb114
           #No.FUN-BB0086--add--end---
            IF NOT cl_null(g_shb.shb114) THEN    #-- No.MOD-530548
              IF g_shb.shb114 < 0  THEN
                 NEXT FIELD shb114
              END IF
              IF g_shb.shb114 = 0 THEN
                 LET l_cnt = 0
                 SELECT COUNT(*) INTO l_cnt FROM shd_file
                  WHERE shd01=g_shb.shb01
                 IF l_cnt > 0  THEN
                    CALL cl_err('sel-shd','asf-671',1)
                    LET g_shb.shb114 = g_shb_t.shb114
                    DISPLAY BY NAME g_shb.shb114
                    NEXT FIELD shb114
                 END IF
              END IF
              ## 檢查可報工數量
              IF t730_accept_qty('c') THEN NEXT FIELD shb114 END IF
           END IF
#FUN-A70095 ---------------------Begin------------------------
        AFTER FIELD shbud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shbud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
#FUN-A70095 ---------------------End--------------------------
     
        AFTER FIELD shb12
#FUN-A60095--begin--modify---------------------
#           IF NOT cl_null(g_shb.shb12) THEN 
#              IF g_shb.shb12=g_shb.shb06 THEN 
#                 CALL cl_err(g_shb.shb12,'aec-086',0)
#                 NEXT FIELD shb12  
#              END IF 
#              ## 檢查是否有此下製程
#              SELECT count(*) INTO g_cnt FROM sgm_file 
#               WHERE sgm01 = g_shb.shb16  
#                 AND sgm03 = g_shb.shb12
#              IF g_cnt = 0  THEN
#                 CALL cl_err(g_shb.shb12,'aec-085',0)
#                 LET g_shb.shb12 = g_shb_t.shb12
#                 DISPLAY BY NAME g_shb.shb12
#                 NEXT FIELD shb12
#              END IF
#           END IF
            CALL t730_chk_shb12()
            IF g_success = 'N' THEN NEXT FIELD shb012 END IF
#FUN-A60095--end--modify-------------------------

#FUN-A60095--begin--add-----------
        AFTER FIELD shb121
            CALL t730_chk_shb12()
            IF g_success = 'N' THEN NEXT FIELD shb012 END IF
#FUN-A60095--end--add------------

     
        AFTER INPUT
 
           LET g_shb.shbuser = s_get_data_owner("shb_file") #FUN-C10039
           LET g_shb.shbgrup = s_get_data_group("shb_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
 
            #TQC-C90018----add----begin----
            LET l_chk_time1 = (g_shb.shb03-g_shb.shb02)* 24 * 60 + g_sum_m2-g_sum_m1
            IF l_chk_time1<0 THEN
               CALL cl_err('','asf-917',1)
               NEXT FIELD shb02
            END IF
            #TQC-C90018----add----end------
            IF cl_null(g_shb.shb111) THEN LET g_shb.shb111 = 0 END IF  
            IF cl_null(g_shb.shb112) THEN LET g_shb.shb112 = 0 END IF  
            IF cl_null(g_shb.shb113) THEN LET g_shb.shb113 = 0 END IF  
            IF cl_null(g_shb.shb114) THEN LET g_shb.shb114 = 0 END IF  
            IF cl_null(g_shb.shb115) THEN LET g_shb.shb115 = 0 END IF  
            IF g_shb.shb113 = 0  THEN  # 重工轉出數量=0不輸入下製程
               LET g_shb.shb12=''
               LET g_shb.shb121=''   #FUN-A60095
               DISPLAY BY NAME g_shb.shb12,g_shb.shb121  #FUN-A60095
            ELSE
## ---下製程不可等於本製程---
              #FUN-A60095--begin--modify------------
              #IF g_shb.shb12=g_shb.shb06 THEN 
              #   CALL cl_err(g_shb.shb12,'aec-086',0)
              #   NEXT FIELD shb12  
              #END IF 
               CALL t730_chk_shb12()
               IF g_success='N' THEN NEXT FIELD shb12 END IF
              #FUN-A60095--end--modify--------------
            END IF
 
           #FUN-B90055 --START mark--  
           #IF (g_shb.shb111+g_shb.shb113+g_shb.shb112+g_shb.shb114)=0
           #THEN CALL cl_err('','asf-810',0)
           #    #INITIALIZE g_shb.* TO NULL  #TQC-AB0389
           #     NEXT FIELD shb111 
           #END IF
           #FUN-B90055 --END mark--
           
            IF t730_accept_qty('c') THEN NEXT FIELD shb111 END IF
          
            CALL t730_chk_runcard(g_shb.shb16,g_shb.shb05,g_shb.shb06,g_shb.shb081,g_shb.shb14,g_shb.shb012) #FUN-A60095
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err(g_shb.shb16,g_errno,1)
               CONTINUE INPUT 
            END IF 
 
        ON ACTION controlp                  
           CASE WHEN INFIELD(shb01) #查詢單据
                     LET g_t1 = s_get_doc_no(g_shb.shb01)     #No.FUN-550067 
                     CALL q_smy(FALSE,TRUE,g_t1,'ASF','9') RETURNING g_t1  #TQC-670008
                      LET g_shb.shb01=g_t1    #No.FUN-550067  
                     DISPLAY BY NAME g_shb.shb01 
                     NEXT FIELD shb01
                WHEN INFIELD(shb04) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_gen"
                     LET g_qryparam.default1 = g_shb.shb04
                     CALL cl_create_qry() RETURNING g_shb.shb04
                     DISPLAY BY NAME g_shb.shb04
                     NEXT FIELD shb04
                WHEN INFIELD(shb07) 
                     CALL q_eca(FALSE,TRUE,g_shb.shb07) RETURNING g_shb.shb07
                      DISPLAY BY NAME g_shb.shb07    #No.MOD-490371
                     NEXT FIELD shb07
                WHEN INFIELD(shb09)                 #機械編號
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_eci"
                     LET g_qryparam.default1 = g_shb.shb09
                     CALL cl_create_qry() RETURNING g_shb.shb09
                     DISPLAY BY NAME g_shb.shb09
                     NEXT FIELD shb09
                WHEN INFIELD(shb05) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_sfb"
                     LET g_qryparam.default1 = g_shb.shb05
                     LET g_qryparam.arg1     = "2345"
                     IF g_qryparam.arg1 IS NOT NULL AND g_qryparam.arg1 != ' ' THEN
                        LET g_qryparam.where = g_qryparam.where CLIPPED," AND sfb04  IN ",cl_parse(g_qryparam.arg1 CLIPPED)
                     END IF
                     LET g_qryparam.where = g_qryparam.where CLIPPED, " ORDER BY 1"
                     CALL cl_create_qry() RETURNING g_shb.shb05
                     DISPLAY BY NAME g_shb.shb05
                     NEXT FIELD shb05
                WHEN INFIELD(shb08) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_ecg"
                     LET g_qryparam.default1 = g_shb.shb08
                     CALL cl_create_qry() RETURNING g_shb.shb08
                     DISPLAY BY NAME g_shb.shb08
                     NEXT FIELD shb08
                WHEN INFIELD(shb081) 
                    #CALL q_sgm(FALSE,FALSE,g_shb.shb16,'','1')       #No.MOD-640138   #FUN-C30163 mark
                     CALL q_sgm(FALSE,FALSE,g_shb.shb16,'','1','','','')       #FUN-C30163 add
                          RETURNING g_shb.shb081,g_shb.shb06
                    IF NOT cl_null(g_shb.shb081) THEN #TQC-BC0156
                    SELECT sgm03,sgm05,sgm45 
                      INTO g_shb.shb06,g_shb.shb09,g_shb.shb082 
                      FROM sgm_file
                     WHERE sgm01=g_shb.shb16 AND sgm04=g_shb.shb081
                       AND sgm03=g_shb.shb06
                       AND sgm012=g_shb.shb012  #FUN-A60095
                    IF STATUS THEN  #資料資料不存在
                       CALL cl_err3("sel","sgm_file",g_shb.shb16,g_shb.shb081,g_errno,"","",1)  #No.FUN-660128
                       LET g_shb.shb081 = g_shb_t.shb081
                       DISPLAY BY NAME g_shb.shb081
                       NEXT FIELD shb081
                    END IF
                    DISPLAY BY NAME g_shb.shb09,
                                    g_shb.shb081,g_shb.shb082,
                                    g_shb.shb06  #FUN-A80102
                    END IF #TQC-BC0156
                    NEXT FIELD shb081
               #FUN-A60095--begin--add----------------
               WHEN INFIELD(shb121)
                     CALL cl_init_qry_var()
                   # LET g_qryparam.form     = "q_shb121_1"      #FUN-B10056 mark
                     LET g_qryparam.form     = "q_shb121_2"      #FUN-B10056
                     LET g_qryparam.default1 = g_shb.shb121
                     LET g_qryparam.default2 = g_shb.shb12
                     LET g_qryparam.arg1     = g_shb.shb16
                     CALL cl_create_qry() RETURNING g_shb.shb121,g_shb.shb12
                     DISPLAY BY NAME g_shb.shb121,g_shb.shb12
                     NEXT FIELD shb121
              #FUN-A60095--end--add------------------- 
               WHEN INFIELD(shb12) 
                    #FUN-A60095--begin--add------------
                    IF g_sma.sma541='Y' AND l_sfb93='Y' THEN
                        CALL cl_init_qry_var()
                      # LET g_qryparam.form     = "q_shb121_1"      #FUN-B10056 mark
                        LET g_qryparam.form     = "q_shb121_2"      #FUN-B10056
                        LET g_qryparam.default1 = g_shb.shb121
                        LET g_qryparam.default2 = g_shb.shb12
                        LET g_qryparam.arg1     = g_shb.shb16
                        CALL cl_create_qry() RETURNING g_shb.shb121,g_shb.shb12
                        DISPLAY BY NAME g_shb.shb121,g_shb.shb12
                        NEXT FIELD shb12
                    ELSE
                    #FUN-A60095--end--add--------------
                       #CALL q_sgm(0,0,g_shb.shb16,'','1')         #No.MOD-640138  #FUN-C30163 mark
                        CALL q_sgm(0,0,g_shb.shb16,'','1','','','')         #FUN-C30163 add
                        RETURNING g_msg,g_shb.shb12
                        DISPLAY BY NAME g_shb.shb12
                    END IF
               #FUN-A60095--begin--add---------------
               WHEN INFIELD(shb012) OR INFIELD(shb06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_shb012_1"
                     LET g_qryparam.default1 = g_shb.shb012
                     LET g_qryparam.default2 = g_shb.shb06
                     LET g_qryparam.default3 = g_shb.shb081
                     LET g_qryparam.arg1     = g_shb.shb16
                     CALL cl_create_qry() RETURNING g_shb.shb012,g_shb.shb06,g_shb.shb081
                     DISPLAY BY NAME g_shb.shb012,g_shb.shb06,g_shb.shb081
                    NEXT FIELD CURRENT
               #FUN-A60095--end--add-----------------
   
               WHEN INFIELD(shb114) 
                    IF g_shb.shb114 > 0  THEN 
                       CALL t701(g_shb.shb01) 
                       NEXT FIELD shb114
                    END IF 
               WHEN INFIELD(shb16) 
                     CALL q_sgm3(FALSE,TRUE,'','')   #FUN-680050
                          RETURNING g_shb.shb16,g_shb.shb081 #FUN-680050
                     CALL FGL_DIALOG_SETBUFFER( g_shb.shb16 )
                    DISPLAY BY NAME g_shb.shb16,g_shb.shb081  #FUN-680050
                   #IF t730_shb081_relation() THEN NEXT FIELD shb081 END IF  #FUN-A80102  #No.MOD-B80291
                    IF t730_shb081_relation() THEN NEXT FIELD shb16  END IF  #FUN-A80102  #No.MOD-B80291
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
       
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
    
    END INPUT
 
END FUNCTION

#FUN-A70095 -----------------------Begin-----------------------
#FUNCTION t730_x()       #CHI-D20010
FUNCTION t730_x(p_type)  #CHI-D20010
   DEFINE l_sfb04   LIKE sfb_file.sfb04
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_flag    LIKE type_file.chr1  #CHI-D20010
   DEFINE p_type    LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_shb.* FROM shb_file WHERE shb01=g_shb.shb01
   IF cl_null(g_shb.shb01) THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT sfb04 INTO l_sfb04 FROM sfb_file WHERE sfb01 = g_shb.shb05
   IF l_sfb04 = '8' THEN
      CALL cl_err(l_sfb04,'aec-078',0)  #已結案 !!
      RETURN
   END IF
#-->已確認不可作廢  
   IF g_shb.shbconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF

   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_shb.shbconf ='X' THEN RETURN END IF
   ELSE
      IF g_shb.shbconf <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end

#-->已有當站下線和工單轉入資料不可以作廢
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM shd_file
    WHERE shd01=g_shb.shb01
   IF l_cnt>0 THEN
      CALL cl_err('','asf-225',0)
      RETURN
   END IF
   IF NOT t730_chk_sma() THEN RETURN END IF
   BEGIN WORK
   LET g_success='Y'

   OPEN t730_cl USING g_shb.shb01
   IF STATUS THEN
      CALL cl_err("OPEN t730_cl:", STATUS, 1)
      CLOSE t730_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t730_cl INTO g_shb.* #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_shb.shb01,SQLCA.sqlcode,0) #資料被他人LOCK
      CLOSE t730_cl
      ROLLBACK WORK
      RETURN
   END IF 
   IF g_shb.shbconf = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
  #IF cl_void(0,0,g_shb.shbconf) THEN #CHI-D20010
   IF cl_void(0,0,l_flag) THEN  #CHI-D20010
      LET g_chr = g_shb.shbconf
      LET g_chr1 = g_shb.shbacti
     #IF g_shb.shbconf = 'N' THEN  #CHI-D20010
      IF p_type = 1 THEN           #CHI-D20010
         LET g_shb.shbconf = 'X'
         LET g_shb.shbacti = 'N'
      ELSE
         LET g_shb.shbconf = 'N'
         LET g_shb.shbacti = 'Y'
      END IF
      UPDATE shb_file 
          SET shbconf = g_shb.shbconf,
              shbacti = g_shb.shbacti,
              shbmodu = g_user,
              shbdate = g_today
          WHERE shb01 = g_shb.shb01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("upd","shb_file",g_shb.shb01,"",SQLCA.sqlcode,"","",0)
          LET g_shb.shbconf = g_chr
          LET g_shb.shbacti = g_chr1
      END IF
      DISPLAY BY NAME g_shb.shbconf
   END IF
   CLOSE t730_cl
   COMMIT WORK
   CALL cl_flow_notify(g_shb.shb01,'V')
END FUNCTION

FUNCTION t730_chk_sma()
    IF g_sma.sma53 IS NOT NULL AND g_shb.shb03 <= g_sma.sma53 THEN
        CALL cl_err('','mfg9999',0)
        RETURN FALSE
    END IF
    CALL s_yp(g_shb.shb03) RETURNING g_yy,g_mm
    IF g_yy > g_sma.sma51 THEN # 與目前會計年度,期間比較
        CALL cl_err(g_yy,'mfg6090',0)
        RETURN FALSE
    ELSE
        IF g_yy=g_sma.sma51 AND g_mm > g_sma.sma52 THEN
            CALL cl_err(g_mm,'mfg6091',0)
            RETURN FALSE
        END IF
    END IF
    RETURN TRUE
END FUNCTION

#FUN-A70095 ----------------------------End---------------------------
#FUN-B20079--add--begin
FUNCTION t730_shb081()
   IF NOT cl_null(g_shb.shb06) THEN
      CALL t730_chk_sgm()
      IF NOT cl_null(g_errno) THEN
         CALL t730_sgm03()
      END IF
   ELSE
      CALL t730_sgm03()
   END IF
END FUNCTION

FUNCTION t730_chk_sgm()
DEFINE l_cnt       LIKE type_file.num10
   LET g_errno=''
   IF g_sma.sma541 = 'N' THEN LET g_shb.shb012=' ' END IF
   IF NOT cl_null(g_shb.shb05) AND NOT cl_null(g_shb.shb06) AND
      g_shb.shb012 IS NOT NULL AND NOT cl_null(g_shb.shb081) THEN
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM sgm_file
       WHERE sgm01=g_shb.shb16
         AND sgm012=g_shb.shb012
         AND sgm03=g_shb.shb06
         AND sgm04=g_shb.shb081
      IF l_cnt = 0 THEN
         LET g_errno='aec-049'
      END IF
    END IF
END FUNCTION

FUNCTION t730_sgm03()
     IF NOT cl_null(g_shb.shb012) AND NOT cl_null(g_shb.shb05) AND NOT cl_null(g_shb.shb081) THEN
        SELECT MIN(sgm03) INTO g_shb.shb06 FROM sgm_file
         WHERE sgm01=g_shb.shb16
           AND sgm012=g_shb.shb012
           AND sgm04=g_shb.shb081
         ORDER BY sgm03
         DISPLAY BY NAME g_shb.shb06
     END IF
    
END FUNCTION
#FUN-B20079--add--end 
FUNCTION t730_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    #  CALL cl_set_comp_entry("shb01,shb081,sfb111,shb12",TRUE)       #TQC-5A0018   #TQC-CA0033
       CALL cl_set_comp_entry("shb01,shb081,shb111,shb12",TRUE)       #TQC-5A0018   #TQC-CA0033
    END IF
 
    IF INFIELD(shb113) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("shb12,shb121",TRUE)  #FUN-A60095
    END IF
    CALL cl_set_comp_entry("shb012,shb081,shb06",FALSE)   #FUN-A60095
 
END FUNCTION
 
FUNCTION t730_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("shb01",FALSE)
    END IF
 
    IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("shb07",FALSE)
    END IF
 
    IF NOT cl_null(g_argv1) AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("shb05,shb081,shb111",FALSE)
       CALL cl_set_comp_entry("shb16",FALSE) 
    ELSE 
    	 CALL cl_set_comp_entry("shb16",TRUE)
    END IF
    IF NOT cl_null(g_shb.shb16) THEN
        CALL cl_set_comp_entry("shb05",FALSE)
    END IF
 
    IF INFIELD(shb113) OR (NOT g_before_input_done) THEN
       IF g_shb.shb113 = 0 THEN
          CALL cl_set_comp_entry("shb12,shb121",FALSE)  #FUN-A60095
       END IF
       IF g_shb.shb113 > 0 THEN
          IF g_sma.sma541 = 'Y' THEN                         #TQC-C90003
             CALL cl_set_comp_entry("shb12,shb121",TRUE)     #FUN-A60095
             CALL cl_set_comp_required("shb12,shb121",TRUE)  #FUN-A60095
          ELSE                                               #TQC-C90003
             CALL cl_set_comp_entry("shb12",TRUE)            #TQC-C90003
             CALL cl_set_comp_required("shb12",TRUE)         #TQC-C90003
          END IF                                             #TQC-C90003
       ELSE
          CALL cl_set_comp_required("shb12,shb121",FALSE) #FUN-A60095
       END IF
    END IF
    #FUN-A60095--begin--add--------------
    IF g_sma.sma541='Y' THEN
       CALL cl_set_comp_entry("shb012,shb06,shb081",TRUE)  #FUN-B20079
    ELSE
       CALL cl_set_comp_entry("shb081",TRUE)     #FUN-B20079
    END IF
    #FUN-A60095--end--add---------------   
 
END FUNCTION
 
FUNCTION t730_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_shb.* TO NULL              #NO.FUN-6A0164
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t730_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       INITIALIZE g_shb.* TO NULL 
       RETURN
    END IF
    MESSAGE " SEARCHING ! " 
    OPEN t730_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_shb.* TO NULL
    ELSE
        OPEN t730_count
        FETCH t730_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
        CALL t730_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t730_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-680121 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-680121 INTEGER
 
    CASE p_flag
         WHEN 'N' FETCH NEXT     t730_cs INTO g_shb.shb01
         WHEN 'P' FETCH PREVIOUS t730_cs INTO g_shb.shb01
         WHEN 'F' FETCH FIRST    t730_cs INTO g_shb.shb01
         WHEN 'L' FETCH LAST     t730_cs INTO g_shb.shb01
         WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
                
                END PROMPT
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
             END IF
             FETCH ABSOLUTE g_jump t730_cs INTO g_shb.shb01
             LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        INITIALIZE g_shb.* TO NULL
        CALL cl_err(g_shb.shb01,SQLCA.sqlcode,0)
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
    SELECT * INTO g_shb.* FROM shb_file WHERE shb01 = g_shb.shb01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","shb_file",g_shb.shb01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
       INITIALIZE g_shb.* TO NULL
    ELSE 
       LET g_data_owner = g_shb.shbuser      #FUN-4C0035
       LET g_data_group = g_shb.shbgrup      #FUN-4C0035
       LET g_data_plant = g_shb.shbplant #FUN-980030
       CALL t730_show()
    END IF
 
END FUNCTION
 
FUNCTION t730_show()
    DEFINE l_pmc03 LIKE pmc_file.pmc03  #FUN-A90057
   
    SELECT * INTO g_shb.* FROM shb_file WHERE shb01 = g_shb.shb01   #FUN-A70095
    LET g_shb_t.* = g_shb.*                #保存單頭舊值
    DISPLAY BY NAME g_shb.shboriu,g_shb.shborig,
        g_shb.shb01, g_shb.shb04, g_shb.shb16,g_shb.shb05, g_shb.shb08,
        g_shb.shb081,g_shb.shb082,g_shb.shb06,g_shb.shb07, g_shb.shb09,
        g_shb.shb03, g_shb.shb031,g_shb.shb02,g_shb.shb021,g_shb.shb032,g_shb.shb033,  #FUN-910076
        g_shb.shb111,g_shb.shb115,g_shb.shb10,
        g_shb.shb112,g_shb.shb113,g_shb.shb12,g_shb.shb114,
        g_shb.shb21,g_shb.shb22,                                        #NO.FUN-930105 
        g_shb.shb14 ,g_shb.shb15 ,g_shb.shb13,
        g_shb.shb012,g_shb.shb121,             #FUN-A60095
        g_shb.shbuser,g_shb.shbgrup,g_shb.shbmodu,g_shb.shbdate 
       ,g_shb.shbconf,g_shb.shb32,             #FUN-A70095   
        g_shb.shbud01,g_shb.shbud02,g_shb.shbud03,g_shb.shbud04,  #FUN-A70095
        g_shb.shbud05,g_shb.shbud06,g_shb.shbud07,g_shb.shbud08,  #FUN-A70095
        g_shb.shbud09,g_shb.shbud10,g_shb.shbud11,g_shb.shbud12,  #FUN-A70095
        g_shb.shbud13,g_shb.shbud14,g_shb.shbud15                 #FUN-A70095
       
    #FUN-A90057(S)
    DISPLAY BY NAME g_shb.shb26,g_shb.shb27,g_shb.shb28,
                    g_shb.shb29,g_shb.shb30,g_shb.shb31,g_shb.shb25
    SELECT pmc03 INTO l_pmc03 
      FROM pmc_file WHERE pmc01 = g_shb.shb27
    DISPLAY l_pmc03 TO FORMONLY.pmc03
    #FUN-A90057(E)
    CALL t730_shb04('d') 
    CALL t730_shb10('d') 
    CALL t730_shb012('d')     #FUN-A60095 
    CALL t730_accept_qty('d') RETURNING g_i
    CALL t730_b_fill(g_wc3) 
#FUN-A70095 --------Begin-----------
    IF g_shb.shbconf = 'X' THEN
       LET g_void = 'Y'
    ELSE
       LET g_void = 'N'
    END IF
    CALL cl_set_field_pic(g_shb.shbconf,"","","",g_void,"")  
#FUN-A70095 --------End-------------
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#FUN-A70095 -----------------Begin---------------------
FUNCTION t730_u(l_flag,l_flag1)

   DEFINE   l_flag   LIKE type_file.chr1
   DEFINE   l_flag1  LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF

   IF g_shb.shb01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_shb.*  FROM shb_file WHERE shb01 = g_shb.shb01
   IF g_shb.shbconf = 'Y' THEN
      CALL cl_err('','asf-146',0)
      RETURN
   END IF
   IF g_shb.shbconf = 'X' THEN
      CALL cl_err('','asf-147',0)
      RETURN
   END IF
   LET g_shb_o.* = g_shb.*
   LET g_shb01_t = g_shb.shb01
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
   OPEN t730_cl USING g_shb.shb01
   IF STATUS THEN
      CALL cl_err("OPEN t730_cl:", STATUS, 1)
      CLOSE t730_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t730_cl INTO g_shb.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock shb:',SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t730_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_shb.shbmodu = g_user
   LET g_shb.shbdate = g_today
   CALL t730_show()
   WHILE TRUE
      CALL t730_i("u",l_flag1)                      # 欄位更改
      IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_shb.*=g_shb_t.*
          CALL t730_show()
          CALL cl_err('',9001,0)
          EXIT WHILE
      END IF
      UPDATE shb_file SET shb_file.* = g_shb.*    # 更新DB
          WHERE shb01 = g_shb01_t
      IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","shb_file",g_shb01_t,'',SQLCA.sqlcode,"","",1)
          CONTINUE WHILE
      END IF
      EXIT WHILE
  END WHILE
  CLOSE t730_cl
  COMMIT WORK
END FUNCTION
#FUN-A70095 -----------------End-----------------------

FUNCTION t730_r()
  DEFINE l_chr,l_sure LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1),
         l_sgm03      LIKE sgm_file.sgm03,
         l_sum1       LIKE sgm_file.sgm311,
         l_sum2       LIKE sfb_file.sfb09,
         l_cnt        LIKE type_file.num5,         #No.MOD-7B0002 add
         l_shc        RECORD LIKE shc_file.*
  DEFINE l_sgm012     LIKE sgm_file.sgm012     #FUN-A60095
  DEFINE l_x          LIKE type_file.num5  #add by guanyao160819
  DEFINE  l_str       LIKE ima_file.ima01
    IF s_shut(0) THEN RETURN END IF
    IF g_shb.shb01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
#FUN-A70095 ------------Begin----------------
    IF g_shb.shbconf = 'Y' THEN
       CALL cl_err(g_shb.shb01,'asf-215',0)
       RETURN
    END IF
    IF g_shb.shbconf = 'X' THEN
       CALL cl_err(g_shb.shb01,'asf-149',0)
       RETURN
    END IF
#FUN-A70095 ------------End------------------

    SELECT COUNT(*) INTO g_cnt FROM shd_file
     WHERE shd01=g_shb.shb01
    IF g_cnt>0 THEN
       CALL cl_err('','asf-725',0)
       RETURN
    END IF
#FUN-A70095 ------------Begin----------------
#   LET g_cnt = 0
#   SELECT COUNT(*) INTO g_cnt FROM qcm_file
#    WHERE qcm03=g_shb.shb16  
#      AND qcm05>g_shb.shb06
#      AND qcm012=g_shb.shb012  #FUN-A60095
#      AND qcm14 <> 'X'
#   IF g_cnt>0 THEN
#      CALL cl_err('','asf-723',0)
#      RETURN
#   END IF
#FUN-A70095 ------------End----------------
 
   #FUN-A60095--begin--modify--------------
   #SELECT MAX(sgm03) INTO l_sgm03 FROM sgm_file
   # WHERE sgm01 = g_shb.shb16
   #   AND sgm02 = g_shb.shb05
   #IF l_sgm03 = g_shb.shb06 THEN   #最終站
#FUN-A70095 ------------------Begin----------------------
#   CALL s_schdat_max_sgm03(g_shb.shb16) RETURNING l_sgm012,l_sgm03
#   IF l_sgm012=g_shb.shb012 AND l_sgm03=g_shb.shb06 THEN
#  #FUN-A60095--end--modify---------------
#         SELECT (sgm311+sgm315) INTO l_sum1
#           FROM sgm_file
#          WHERE sgm01 = g_shb.shb16   #Run Card
#            AND sgm02 = g_shb.shb05   #工單編號
#            AND sgm03 = g_shb.shb06
#            AND sgm012= g_shb.shb012  #FUN-A60095
#
#         SELECT SUM(sfv09) INTO l_sum2
#           FROM sfv_file,sfu_file
#          WHERE sfv20 = g_shb.shb16
#            AND sfv11 = g_shb.shb05   #工單編號
#            AND sfv01 = sfu01 AND sfuconf <> 'X'
#
#         IF cl_null(l_sum1) THEN LET l_sum1 = 0  END IF
#         IF cl_null(l_sum2) THEN LET l_sum2 = 0  END IF
#         #當站報工量+bonus Qty須<=終站總良品轉出量+Bonus Qty-已入庫量
#         IF (g_shb.shb111+g_shb.shb115) > (l_sum1 - l_sum2) THEN
#            CALL cl_err('','asf-681',0)
#            RETURN
#         END IF
#     ELSE
#        LET l_cnt = 0
#        SELECT COUNT(*) INTO l_cnt FROM pmn_file,pmm_file
#            WHERE pmn01 = pmm01 AND pmm18 <> 'X' AND pmm02 = 'SUB'
#            AND   pmn32 > g_shb.shb06 #製程序號
#            AND   pmn18 = g_shb.shb16 #Run Card
#            AND   pmn41 = g_shb.shb05 #工單編號
#            AND   pmn012 = g_shb.shb012 #FUN-A60095
#        IF  l_cnt > 0 THEN
#            CALL cl_err('','asf-038',1)
#            RETURN
#        END IF
#   END IF
#FUN-A70095 --------------------End-----------------------
 
    LET g_argv1=g_shb.shb14
    LET g_argv3=g_shb.shb15
    LET g_argv4='r'
 
    IF NOT cl_delh(20,16) THEN RETURN END IF
    INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
    LET g_doc.column1 = "shb01"         #No.FUN-9B0098 10/02/24
    LET g_doc.value1 = g_shb.shb01      #No.FUN-9B0098 10/02/24
    CALL cl_del_doc()                                                              #No.FUN-9B0098 10/02/24
    SELECT * INTO g_shb.* FROM shb_file WHERE shb01=g_shb.shb01
 
  BEGIN WORK
 
    OPEN t730_cl USING g_shb.shb01
    IF STATUS THEN
       CALL cl_err("OPEN t730_cl:", STATUS, 1)   
       CLOSE t730_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t730_cl INTO g_shb.*
    IF SQLCA.sqlcode THEN 
       CALL cl_err(g_shb.shb01,SQLCA.sqlcode,0) 
       CLOSE t730_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    CALL t730_show()
 
    IF g_argv4 != 'r' THEN 
       IF NOT cl_delh(20,16) THEN 
          RETURN 
       END IF    #詢問 y/n 
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "shb01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_shb.shb01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()#No.FUN-9B0098 10/02/24
    ELSE
#......委外入庫重新確認且報工資料己存在     
       IF g_shbconf = 'Y' THEN   
          IF NOT cl_delh(20,16) THEN 
             LET g_shbconf='N'
             RETURN
          END IF   #不清除 
          INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
          LET g_doc.column1 = "shb01"         #No.FUN-9B0098 10/02/24
          LET g_doc.value1 = g_shb.shb01      #No.FUN-9B0098 10/02/24
          CALL cl_del_doc()#No.FUN-9B0098 10/02/24
       END IF 
    END IF 

    #str----add by guanyao160819
    LET l_x = ''
    SELECT COUNT(*) INTO l_x FROM tc_shb_file WHERE tc_shb17 = g_shb.shb01 
    IF l_x> 0 THEN 
       UPDATE tc_shb_file SET tc_shb17 =''
        WHERE tc_shb17 = g_shb.shb01 
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("upd","tc_shb_file",g_shb.shb01,"",SQLCA.SQLCODE,"","upd tc_shb",1)  #No.FUN-660128
           ROLLBACK WORK
           RETURN
       END IF
    END IF 
    #end----add by guanyao160819
    LET g_success='Y'
 
#FUN-A70095 -----------------Begin-------------------
#    MESSAGE "update sfb_file"
#   #還原工單單頭報廢量
#    UPDATE sfb_file SET sfb12 = sfb12 - g_shb.shb112
#     WHERE sfb01 = g_shb.shb05
#    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
#       CALL cl_err(g_shb.shb05,'asf-861',1)
#       ROLLBACK WORK
#       RETURN
#    END IF
#FUN-A70095 -----------------End--------------------
 
    MESSAGE "Delete shb,shc!"
    DELETE FROM shb_file WHERE shb01 = g_shb.shb01
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("del","shb_file",g_shb.shb01,"",SQLCA.SQLCODE,"","No shb deleted",1)  #No.FUN-660128
       ROLLBACK WORK
       RETURN
    END IF
 
    LET l_str=g_shb.shb01 CLIPPED,g_shb.shb16 CLIPPED,g_shb.shb06
    INSERT INTO azo_file VALUES ('csft730',g_user,g_today,'',l_str,'delete',g_plant,g_legal)


    DELETE FROM shc_file WHERE shc01 = g_shb.shb01
    IF SQLCA.SQLCODE  THEN
       CALL cl_err3("del","shc_file",g_shb.shb01,"",STATUS,"","del shc",1)  #No.FUN-660128
       ROLLBACK WORK
       RETURN
    END IF
 
#   CALL t730sub_upd_sgm('r',g_shb.*)    # Update 製程追蹤檔  #FUN-A80102   #FUN-A70095
#      RETURNING g_shb.*                 #FUN-A70095
    IF g_success='N'  THEN
       MESSAGE " "
       ROLLBACK WORK RETURN
    ELSE 
       CLEAR FORM
       CALL g_shc.clear()
       INITIALIZE g_shb.* TO NULL    #No.MOD-880128
       MESSAGE "Delete OK !"
       OPEN t730_count
       IF STATUS THEN   #hrh
          CLOSE t730_count
          CLOSE t730_cl
          COMMIT WORK
          RETURN
       END IF
       FETCH t730_count INTO g_row_count
       IF STATUS OR g_row_count=0 OR cl_null(g_row_count) THEN   #hrh
          CLOSE t730_count
          CLOSE t730_cl
          COMMIT WORK
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t730_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t730_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t730_fetch('/')
       END IF
 
    END IF
 
    CLOSE t730_cl
    COMMIT WORK
    CALL cl_flow_notify(g_shb.shb01,'D')
 
END FUNCTION
 
FUNCTION t730_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680121 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用  #No.FUN-680121 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-680121 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-680121 VARCHAR(1)
    l_b3            LIKE type_file.num5,    #No.FUN-680121 SMALLINT,
    no1             LIKE type_file.num10,   #No.FUN-680121 INTEGER,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680121 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-680121 SMALLINT
DEFINE l_sfb93      LIKE sfb_file.sfb93                 #FUN-A60095
 
    LET g_action_choice = ""
    IF g_shb.shb01 IS NULL THEN RETURN END IF
    SELECT * INTO g_shb.* FROM shb_file WHERE shb01=g_shb.shb01
 
#FUN-A70095 ------------Begin----------------
    IF g_shb.shbconf = 'Y' THEN
       CALL cl_err(g_shb.shb01,'asf-228',0)
       RETURN
    END IF
    IF g_shb.shbconf = 'X' THEN
       CALL cl_err(g_shb.shb01,'asf-229',0)
       RETURN
    END IF
#FUN-A70095 ------------End------------------

    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT * FROM shc_file ",
                       " WHERE shc01= ? AND shc03= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t730_bcl CURSOR FROM g_forupd_sql
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    #CKP
    IF g_rec_b=0 THEN CALL g_shc.clear() END IF
 
    INPUT ARRAY g_shc WITHOUT DEFAULTS FROM s_shc.* 
 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR() 
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
 
	    BEGIN WORK
 
            OPEN t730_cl USING g_shb.shb01
            IF STATUS THEN
               CALL cl_err("OPEN t730_cl:", STATUS, 1)
               CLOSE t730_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t730_cl INTO g_shb.*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_shb.shb01,SQLCA.sqlcode,0)
               ROLLBACK WORK
               RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_shc_t.* = g_shc[l_ac].*  #BACKUP
               OPEN t730_bcl USING g_shb.shb01,g_shc_t.shc03
               IF STATUS THEN
                  CALL cl_err("OPEN t730_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
               ELSE 
                  FETCH t730_bcl INTO b_shc.* 
                  IF SQLCA.sqlcode THEN
                      CALL cl_err('lock shc',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  ELSE
                      CALL t730_b_move_to()
                  END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            INITIALIZE g_shc_t.* TO NULL
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_shc[l_ac].* TO NULL      #900423
            LET b_shc.shc01=g_shb.shb01
            LET g_shc[l_ac].shc05=0
            LET g_shc[l_ac].shc012=' ' #FUN-A60095
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD shc03
 
        AFTER INSERT
            IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              INITIALIZE g_shc[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_shc[l_ac].* TO s_shc.*
              CALL g_shc.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
            END IF
 
            CALL t730_b_move_back(p_cmd)
            CALL t730_b_else()
            LET b_shc.shcoriu = g_user      #No.FUN-980030 10/01/04
            LET b_shc.shcorig = g_grup      #No.FUN-980030 10/01/04
            IF b_shc.shc012 IS NULL THEN LET b_shc.shc012 = ' ' END IF  #FUN-A60095
            INSERT INTO shc_file VALUES(b_shc.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","shc_file",b_shc.shc01,b_shc.shc03,SQLCA.sqlcode,"","ins shc",1)  #No.FUN-660128
               CANCEL INSERT
            ELSE 
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
            END IF
 
        BEFORE FIELD shc03                            #default 序號
            IF cl_null(g_shc[l_ac].shc03) THEN                          
               SELECT MAX(shc03)+1 INTO g_shc[l_ac].shc03              
                  FROM shc_file WHERE shc01 = g_shb.shb01             
               IF g_shc[l_ac].shc03 IS NULL THEN                     
                  LET g_shc[l_ac].shc03=1                           
               END IF                                              
            END IF                                   
 
        AFTER FIELD shc03                        #check 序號是否重複
            IF NOT cl_null(g_shc[l_ac].shc03) THEN 
               IF g_shc[l_ac].shc03 != g_shc_t.shc03 OR
                  g_shc_t.shc03 IS NULL THEN
                   SELECT count(*) INTO l_n FROM shc_file
                       WHERE shc01 = g_shb.shb01 AND shc03 = g_shc[l_ac].shc03
                   IF l_n > 0 THEN
                       LET g_shc[l_ac].shc03 = g_shc_t.shc03
                       CALL cl_err('',-239,0) NEXT FIELD shc03
                   END IF
               END IF
            END IF
 
        AFTER FIELD shc04
           IF NOT cl_null(g_shc[l_ac].shc04) THEN 
              CALL t730_shc04('d')
              IF NOT cl_null(g_errno)   THEN 
                 CALL cl_err('sel qce:',g_errno,0) NEXT FIELD shc04
                 LET g_shc[l_ac].shc04=g_shc_t.shc04
                 NEXT FIELD shc04 
              END IF
           END IF
 
        AFTER FIELD shc05
           IF cl_null(g_shc[l_ac].shc05) THEN 
              IF g_shc[l_ac].shc05 <=0 THEN 
                 NEXT FIELD shc05
              END IF 
           END IF 
 
#FUN-A60095--begin--add-----------------
        AFTER FIELD shc012
           IF NOT cl_null(g_shc[l_ac].shc012) THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM sgm_file
               WHERE sgm01=g_shb.shb16
                 AND sgm012=g_shc[l_ac].shc012
              IF l_cnt = 0  THEN
                 CALL cl_err(g_shc[l_ac].shc012,'abm-214',1)
                 NEXT FIELD shc012
              END IF
              CALL t700_shc06()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD shc012
              END IF
           END IF
#FUN-A60095--end--add---------------------

        AFTER FIELD shc06
           IF NOT cl_null(g_shc[l_ac].shc06) THEN 
#FUN-A60095--begin--modify------------------
#             SELECT sgm04 INTO g_shc[l_ac].sgm04 FROM sgm_file 
#              WHERE sgm01=g_shb.shb16 AND sgm03 = g_shc[l_ac].shc06 
#                AND sgm012=g_shb.shb012  #FUN-A60095
#             IF STATUS THEN
#                CALL cl_err3("sel","sgm_file",g_shb.shb16,g_shc[l_ac].shc06,STATUS,"","sel sgm",1)  #No.FUN-660128
#                LET g_shc[l_ac].shc06=g_shc_t.shc06
#                NEXT FIELD shc06 
#             END IF
              CALL t700_shc06()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD shc06
               END IF
#FUN-A60095--end--modify--------------------
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_shc_t.shc03 > 0 AND g_shc_t.shc03 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
 
               IF l_lock_sw = "Y" THEN 
                  CALL cl_err("", -263, 1) 
                  CANCEL DELETE 
               END IF 
 
               DELETE FROM shc_file
                WHERE shc01 = g_shb.shb01 AND shc03 = g_shc_t.shc03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","shc_file",g_shb.shb01,g_shc_t.shc03,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_shc[l_ac].* = g_shc_t.*
               CLOSE t730_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_shc[l_ac].shc04,-263,1)
               LET g_shc[l_ac].* = g_shc_t.*
            ELSE
               CALL t730_b_move_back(p_cmd)
               CALL t730_b_else()
               UPDATE shc_file SET * = b_shc.*
                  WHERE shc01=g_shb.shb01 AND shc03=g_shc_t.shc03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","shc_file",g_shb.shb01,g_shc_t.shc03,SQLCA.sqlcode,"","upd shc",1)  #No.FUN-660128
                  LET g_shc[l_ac].* = g_shc_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_shc[l_ac].* = g_shc_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_shc.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE t730_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D40030 Add
            CLOSE t730_bcl
            COMMIT WORK
           #CALL g_shc.deleteElement(g_rec_b+1)    #FUN-D40030 Mark
        ON ACTION CONTROLS
           CALL  cl_set_head_visible("","AUTO")
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(shc03) AND l_ac > 1 THEN
                LET g_shc[l_ac].shc03=g_shc[l_ac-1].shc03
                LET g_shc[l_ac].shc04=g_shc[l_ac-1].shc04
                LET g_shc[l_ac].qce02=g_shc[l_ac-1].qce02
                LET g_shc[l_ac].qce03=g_shc[l_ac-1].qce03
                LET g_shc[l_ac].shc05=g_shc[l_ac-1].shc05
                LET g_shc[l_ac].shc06=g_shc[l_ac-1].shc06
                LET g_shc[l_ac].shc012=g_shc[l_ac-1].shc012  #FUN-A60095
                NEXT FIELD shc03
            END IF
 
        ON ACTION controlp
           CASE WHEN INFIELD(shc04) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_qce"
                     LET g_qryparam.default1 = g_shc[l_ac].shc04
                     CALL cl_create_qry() RETURNING g_shc[l_ac].shc04
                     DISPLAY BY NAME g_shc[l_ac].shc04      #No.MOD-490371
                     NEXT FIELD shc04
                #FUN-A60095--begin--add-----------------
                WHEN INFIELD(shc012)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_shb012_1"
                   LET g_qryparam.default1 = g_shc[l_ac].shc012
                   LET g_qryparam.default2 = g_shc[l_ac].shc06
                   LET g_qryparam.default3 = g_shc[l_ac].sgm04
                   LET g_qryparam.arg1 = g_shb.shb16
                   CALL cl_create_qry() RETURNING g_shc[l_ac].shc012,g_shc[l_ac].shc06,g_shc[l_ac].sgm04
                   DISPLAY BY NAME g_shc[l_ac].shc012,g_shc[l_ac].shc06,g_shc[l_ac].sgm04
                   NEXT FIELD shc012
           #FUN-A60095--end--add-------------------
                WHEN INFIELD(shc06) 
                  #FUN-A60095--begin--add--------------
                  SELECT sfb93 INTO l_sfb93 FROM sfb_file WHERE sfb01=g_shb.shb05
                  IF g_sma.sma541='Y' AND l_sfb93='Y' THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_shb012_1"
                     LET g_qryparam.default1 = g_shc[l_ac].shc012
                     LET g_qryparam.default2 = g_shc[l_ac].shc06
                     LET g_qryparam.default3 = g_shc[l_ac].sgm04
                     LET g_qryparam.arg1 = g_shb.shb16
                     CALL cl_create_qry() RETURNING g_shc[l_ac].shc012,g_shc[l_ac].shc06,g_shc[l_ac].sgm04
                     DISPLAY BY NAME g_shc[l_ac].shc012,g_shc[l_ac].shc06,g_shc[l_ac].sgm04
                     NEXT FIELD shc06
                  ELSE
                  #FUN-A60095--end--add-------------------
                    #CALL q_sgm(0,0,g_shb.shb16,'','1')        #No.MOD-640138  #FUN-C30163 mark
                     CALL q_sgm(0,0,g_shb.shb16,'','1','','','')        #FUN-C30163 add
                          RETURNING g_shc[l_ac].sgm04,g_shc[l_ac].shc06
                     DISPLAY BY NAME g_shc[l_ac].sgm04,g_shc[l_ac].shc06  #No.MOD-490371
                     NEXT FIELD shc06
                  END IF 
           END CASE
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
    
    END INPUT
    
     LET g_shb.shbmodu = g_user
     LET g_shb.shbdate = g_today
     UPDATE shb_file SET shbmodu = g_shb.shbmodu,shbdate = g_shb.shbdate
      WHERE shb01 = g_shb.shb01
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
        CALL cl_err3("upd","shb_file", g_shb.shb01,"",SQLCA.SQLCODE,"","upd shb",1)  #No.FUN-660128
     END IF
     DISPLAY BY NAME g_shb.shbmodu,g_shb.shbdate
 
    SELECT COUNT(*) INTO g_cnt FROM shc_file WHERE shc01=g_shb.shb01
 
    CLOSE t730_bcl
    COMMIT WORK
    IF NOT t730_chk_shb112() THEN
       CALL cl_err('','asf-710',1)
    END IF
END FUNCTION
 
FUNCTION t730_b_move_to()
   LET g_shc[l_ac].shc03 = b_shc.shc03 
   LET g_shc[l_ac].shc04 = b_shc.shc04 
   LET g_shc[l_ac].shc05 = b_shc.shc05  
   LET g_shc[l_ac].shc06 = b_shc.shc06  
   LET g_shc[l_ac].shc012 = b_shc.shc012  #FUN-A60095
   CALL t730_shc04('d')
END FUNCTION
 
FUNCTION t730_b_move_back(p_cmd)
   DEFINE    p_cmd     LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
   LET b_shc.shc01 = g_shb.shb01
   LET b_shc.shc03 = g_shc[l_ac].shc03 
   LET b_shc.shc04 = g_shc[l_ac].shc04 
   LET b_shc.shc05 = g_shc[l_ac].shc05  
   LET b_shc.shc06 = g_shc[l_ac].shc06  
   LET b_shc.shc012 = g_shc[l_ac].shc012   #FUN-A60095
   LET b_shc.shc07=' ' 
   IF p_cmd = 'a'   THEN 
      LET b_shc.shcacti='Y'  
      LET b_shc.shcuser=g_user   
      LET b_shc.shcgrup=g_grup  
      LET b_shc.shcmodu=' '  
      LET b_shc.shcdate=g_today  
   ELSE 
      LET b_shc.shcmodu=g_user   
      LET b_shc.shcdate=g_today  
   END IF 
 
   LET b_shc.shcplant = g_plant #FUN-980008 add
   LET b_shc.shclegal = g_legal #FUN-980008 add
 
END FUNCTION
 
FUNCTION t730_b_else()
   IF g_shc[l_ac].shc03 IS NULL THEN LET g_shc[l_ac].shc03 =0   END IF
   IF g_shc[l_ac].shc04 IS NULL THEN LET g_shc[l_ac].shc04 =' ' END IF
END FUNCTION
 
FUNCTION t730_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON shc03,shc04,shc05,shc012,shc06   #FUN-A60095
            FROM s_shc[1].shc03, s_shc[1].shc04, s_shc[1].shc05, 
                 s_shc[1].shc012,s_shc[1].shc06    #FUN-A60095
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
    
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t730_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t730_b_fill(p_wc2)              #BODY FILL UP
    DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(300)
 
       LET g_sql = "SELECT shc03,shc04,qce02,qce03,shc05,shc012,shc06,sgm04 ",  #FUN-A60095
                   " FROM  shc_file, OUTER qce_file,OUTER sgm_file ",
                   " WHERE shc01 ='",g_shb.shb01,"' ",
                        "   AND shc_file.shc04= qce_file.qce01 ",
                   "   AND sgm_file.sgm01='",g_shb.shb16,"' ",
                   "   AND sgm_file.sgm03=shc_file.shc06",
                   "   AND sgm_file.sgm012=shc_file.shc012",  #FUN-A60095
                   "   AND ",p_wc2 CLIPPED,
                   " ORDER BY 1"
 
    PREPARE t730_pb FROM g_sql
    DECLARE shc_curs CURSOR FOR t730_pb
 
    CALL g_shc.clear()
 
    LET g_cnt = 1
    FOREACH shc_curs INTO g_shc[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_shc.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('fore shc:',STATUS,1) END IF
 
    LET g_rec_b=g_cnt - 1
 
END FUNCTION
 
FUNCTION t730_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_shc TO s_shc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()    #TQC-B60129
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                          
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
    #FUN-A70095 ---------Begin-----------
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
    #FUN-A70095 ---------End-------------
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION first 
         CALL t730_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL t730_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL t730_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL t730_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL t730_fetch('L')
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
#FUN-A70095 ---------------Begin-----------------
      #str----add by guanyao160903
     # ON ACTION gy_pro
     #    LET g_action_choice="gy_pro"
     #    EXIT DISPLAY
      #end----add by guanyao160903
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end
#FUN-A70095 ---------------End-------------------
#@    ON ACTION 委外報工輸入
      ON ACTION input_sub_report
         LET g_action_choice="input_sub_report"
         EXIT DISPLAY
#@    ON ACTION 當站入庫
      ON ACTION direct_st_in
         LET g_action_choice="direct_st_in"
         EXIT DISPLAY
#@    ON ACTION 轉稼工時維護
      ON ACTION shift_working_hours
         LET g_action_choice="shift_working_hours"
         EXIT DISPLAY
         
      ON ACTION fast_input
         LET g_action_choice = "fast_input"
         EXIT DISPLAY 
 
      ON ACTION fqc2
         LET g_action_choice = "fqc2"
         EXIT DISPLAY 
         
      ON ACTION trans_fqc
         LET g_action_choice = "trans_fqc"   
         EXIT DISPLAY 
         
      ON ACTION trans_store
         LET g_action_choice = "trans_store"
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

 
      ON ACTION related_document                #No.FUN-6A0164  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   
      &include "qry_string.4gl" 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION t730_shb04(p_cmd)  #員工編號
    DEFINE l_gen02    LIKE gen_file.gen02,
           l_genacti  LIKE gen_file.genacti,
           p_cmd      LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT gen02,genacti INTO l_gen02,l_genacti
      FROM gen_file WHERE gen01 = g_shb.shb04
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-038'
                            LET l_gen02 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd'  THEN 
       DISPLAY l_gen02  TO FORMONLY.gen02
       LET g_gen02 = l_gen02    #NO.FUN-940113
    END IF
END FUNCTION
 
FUNCTION t730_shb10(p_cmd)  #產品編號
    DEFINE l_ima02    LIKE ima_file.ima02,
           l_ima021   LIKE ima_file.ima021,
           l_imaacti  LIKE ima_file.imaacti,
           p_cmd      LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti
      FROM ima_file WHERE ima01 = g_shb.shb10
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                            LET l_ima02 = NULL
                            LET l_ima021 = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'  #No.FUN-690022 add
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd'
    THEN LET g_ima02  = l_ima02
         LET g_ima021 = l_ima021
         DISPLAY g_ima02  TO FORMONLY.ima02
         DISPLAY g_ima021 TO FORMONLY.ima021
         LET gg_ima02 = g_ima02         #NO.FUN-940113
         LET gg_ima021 = g_ima021       #NO.FUN-940113
    END IF
END FUNCTION
 
FUNCTION t730_shc04(p_cmd)  #缺點碼
    DEFINE l_qce02    LIKE qce_file.qce02,
           l_qce03    LIKE qce_file.qce03,
           l_qceacti  LIKE qce_file.qceacti,
           p_cmd      LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT qce02,qce03,qceacti INTO l_qce02,l_qce03,l_qceacti
      FROM qce_file WHERE qce01 = g_shc[l_ac].shc04
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aqc-023'
                            LET l_qce02 = NULL
                            LET l_qce03 = NULL
         WHEN l_qceacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd'
    THEN LET g_shc[l_ac].qce02 = l_qce02
         LET g_shc[l_ac].qce03 = l_qce03
    END IF
END FUNCTION
 
## 檢查可報工數量
FUNCTION t730_accept_qty(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)
       l_wip_qty  LIKE shb_file.shb111,
       l_pqc_qty  LIKE qcm_file.qcm091,   #良品數 
       l_sum_qty  LIKE qcm_file.qcm091    
DEFINE l_bn_ecm012 LIKE ecm_file.ecm012  #FUN-A80102
DEFINE l_bn_ecm03  LIKE ecm_file.ecm03   #FUN-A80102

#      WIP量=總投入量(a+b)-總轉出量(f+g)-報廢量(d)-入庫量(e)
#           -委外加工量(h)+委外完工量(i)
#      WIP量指目前在該站的在製量，
#      若系統參數定義要做Check-In時，WIP量尚可區
#      分為等待上線數量與上線處理數量。
#      上線處理數量=Check-In量(c)-總轉出量(f+g)-報廢量(d)-入庫量(e)
#                 -委外加工量(h)+委外完工量(i)
#      等待上線數量=線投入量(a+b)-Check-In量(c)
 
#      若該站允許做製程委外，則
#      可委外加工量=WIP量-委外加工量(h)
#      委外在外量=委外加工量(h)-委外完工量(i)
 
#      某站若要報工則其可報工數=WIP量(a+b-f-g-d-e-h+i)，
#      若要做Check-In則可報工數=c-f-g-d-e-h+i。
 
       IF cl_null(g_shb.shb012) THEN LET g_shb.shb012=' ' END IF #FUN-A60095
       SELECT * INTO g_sgm.* FROM sgm_file
        WHERE sgm01=g_shb.shb16 AND sgm03=g_shb.shb06
          AND sgm012=g_shb.shb012  #FUN-A60095
       IF STATUS THEN  #資料資料不存在
          CALL cl_err3("sel","sgm_file",g_shb.shb16,g_shb.shb06,STATUS,"","sel sgm_file",1)  #No.FUN-660128
          RETURN -1
       END IF
       #str-----add by guanyao160908
       IF g_shb.shb06 = g_shb.shb12 THEN   #返工当站的时候，更新下
          IF g_shb.shb113>0 THEN 
             LET g_sgm.sgm302 = g_sgm.sgm302+g_shb.shb113
          END IF 
       END IF 
       #end-----add by gaunyao160908
 
       IF g_sma.sma1431='N' OR cl_null(g_sma.sma1431) THEN   #FUN-A80102
          IF g_sgm.sgm54='Y' THEN   #check in 否
             LET l_wip_qty =  g_sgm.sgm291                #check in 
                            - g_sgm.sgm311 #*g_sgm.sgm59  #良品轉出     #FUN-A60095
                            - g_sgm.sgm312 #*g_sgm.sgm59  #重工轉出     #FUN-A60095
                            - g_sgm.sgm313 #*g_sgm.sgm59  #當站報廢     #FUN-A60095
                            - g_sgm.sgm314 #*g_sgm.sgm59  #當站下線     #FUN-A60095
                            - g_sgm.sgm316 #*g_sgm.sgm59                #FUN-A60095
                            - g_sgm.sgm317 #*g_sgm.sgm59                #FUN-A60095
          ELSE
             LET l_wip_qty =  g_sgm.sgm301                #良品轉入量
                            + g_sgm.sgm302                #重工轉入量
                            + g_sgm.sgm303 
                            + g_sgm.sgm304
                            - g_sgm.sgm311 #*g_sgm.sgm59    #良品轉出   #FUN-A60095
                            - g_sgm.sgm312 #*g_sgm.sgm59    #重工轉出   #FUN-A60095
                            - g_sgm.sgm313 #*g_sgm.sgm59    #當站報廢   #FUN-A60095
                            - g_sgm.sgm314 #*g_sgm.sgm59    #當站下線   #FUN-A60095
                            - g_sgm.sgm316 #*g_sgm.sgm59                #FUN-A60095
                            - g_sgm.sgm317 #*g_sgm.sgm59                #FUN-A60095
          END IF
       #FUN-A60102(S)
       ELSE
          CALL t730sub_check_auto_report(g_shb.shb05,g_shb.shb16,g_shb.shb012,g_shb.shb06) 
             RETURNING l_bn_ecm012,l_bn_ecm03,l_wip_qty 
       #FUN-A60102(E)
       END IF
       IF cl_null(l_wip_qty) THEN LET l_wip_qty=0 END IF
 
       LET l_sum_qty=(g_shb.shb111+g_shb.shb113+g_shb.shb112+g_shb.shb114) #*g_sgm.sgm59 #FUN-A60095
       IF l_sum_qty>l_wip_qty AND p_cmd<>'d' THEN
          LET g_msg="WIP:",l_wip_qty USING "<<<<.<<" CLIPPED
          CALL cl_err(g_msg,'asf-801',0)
          DISPLAY l_wip_qty,l_pqc_qty,g_sgm.sgm53,g_sgm.sgm54
               TO FORMONLY.wip,FORMONLY.pqc,sgm53,sgm54
          LET g_sgm53 = g_sgm.sgm53            #NO.FUN-940113     
          LET g_sgm54 = g_sgm.sgm54            #NO.FUN-940113  
          LET g_wip   = l_wip_qty              #NO.FUN-940113 
          LET g_pqc   = l_pqc_qty              #NO.FUN-940113           
          RETURN -1
       END IF
 
#      若該站製程追蹤檔中定義本站需要做PQC檢查，
#      則可報工數量尚需滿足以下條件:
#          可報工數量<=SUM(PQC Accept數量)-當站下線量(e)-良品轉出量(f)
       DISPLAY '' TO FORMONLY.tot_pqc
       #mark by donghy 160805 PQC取消检查
       IF g_sgm.sgm53='Y' THEN   #PQC
          LET l_pqc_qty = NULL
          #SELECT SUM(qcm091) INTO l_pqc_qty FROM qcm_file
          # WHERE qcm03 =g_shb.shb16   #Run Card 
          #   AND qcm05 =g_shb.shb06   #製程序號
          #   AND qcm14 ='Y'  #確認
          #   AND qcm012=g_shb.shb012  #FUN-BC0104
          #   AND ( qcm09 ='1' OR qcm09='3')  #判定結果(1.Accept  3.特採) #No:7842,8454
          #IF cl_null(l_pqc_qty) THEN LET l_pqc_qty=0 END IF
          #DISPLAY l_pqc_qty TO FORMONLY.tot_pqc
          #LET g_tot_pqc = l_pqc_qty           #NO.FUN-940113 
 
          #IF cl_null(g_sgm.sgm311) THEN LET g_sgm.sgm311=0 END IF
          #IF cl_null(g_sgm.sgm312) THEN LET g_sgm.sgm312=0 END IF
          #IF cl_null(g_sgm.sgm313) THEN LET g_sgm.sgm313=0 END IF
          #IF cl_null(g_sgm.sgm314) THEN LET g_sgm.sgm314=0 END IF
          #IF cl_null(g_sgm.sgm302) THEN LET g_sgm.sgm302=0 END IF
 
          #LET l_pqc_qty=l_pqc_qty - g_sgm.sgm311 #*g_sgm.sgm59    #良品轉出 #FUN-A60095
          #                        - g_sgm.sgm312 #*g_sgm.sgm59    #重工轉出 #FUN-A60095
          #                        - g_sgm.sgm314 #*g_sgm.sgm59    #當站下線 #FUN-A60095
          #                        + g_sgm.sgm302                  #重工轉入量
 
          #IF l_sum_qty-g_shb.shb112>l_pqc_qty AND p_cmd<>'d'
          #   THEN
          #   LET g_msg="WIP:",l_wip_qty USING "<<<<.<<" CLIPPED,
          #             "  PQC:",l_pqc_qty USING "<<<<.<<" CLIPPED
          #   CALL cl_err(g_msg,'asf-802',0)
          #   DISPLAY l_wip_qty,l_pqc_qty,g_sgm.sgm53,g_sgm.sgm54
          #        TO FORMONLY.wip,FORMONLY.pqc,sgm53,sgm54
          #    LET g_sgm53 = g_sgm.sgm53        #NO.FUN-940113    
          #    LET g_sgm54 = g_sgm.sgm54        #NO.FUN-940113                  
          #    LET g_wip   = l_wip_qty          #NO.FUN-940113
          #    LET g_pqc   = l_pqc_qty          #NO.FUN-940113                 
          #   RETURN -1
          #END IF
       END IF
       #str-----add by guanyao160908
       IF g_shb.shb06 = g_shb.shb12 THEN   #返工当站的时候，更新下
          IF g_shb.shb113>0 THEN 
             LET l_wip_qty = l_wip_qty-g_shb.shb113
          END IF 
       END IF 
       #end-----add by gaunyao160908
       DISPLAY l_wip_qty,l_pqc_qty,g_sgm.sgm53,g_sgm.sgm54
            TO FORMONLY.wip,FORMONLY.pqc,sgm53,sgm54
       LET g_sgm53 = g_sgm.sgm53               #NO.FUN-940113    
       LET g_sgm54 = g_sgm.sgm54               #NO.FUN-940113    
       LET g_wip   = l_wip_qty                 #NO.FUN-940113               
       LET g_pqc   = l_pqc_qty                 #NO.FUN-940113   
       RETURN 0
END FUNCTION

FUNCTION t730_i2()
 
    INPUT BY NAME
        g_shb.shb14,g_shb.shb15
 
        ON ACTION controlp                  
           CALL cl_init_qry_var()
           LET g_qryparam.form     = "q_rvv1"  #No:TQC-790064  #MOD-A60022 q_rvv31->q_rvv1
           LET g_qryparam.default1 = g_shb.shb14
           LET g_qryparam.default2 = g_shb.shb15
           CALL cl_create_qry() RETURNING g_shb.shb14,g_shb.shb15
           DISPLAY BY NAME g_shb.shb14,g_shb.shb15 
           NEXT FIELD shb14
 
     AFTER INPUT
        IF INT_FLAG THEN
           LET INT_FLAG=0 CALL cl_err('',9001,0)
           INITIALIZE g_shb.* TO NULL
           CLEAR FORM
           CALL g_shc.clear()
           RETURN -1
        END IF
        
        SELECT COUNT(*) INTO g_cnt FROM shb_file      #check是否已產生報工單
         WHERE shb14 = g_shb.shb14 AND shb15 = g_shb.shb15
        IF g_cnt > 0 THEN        #已存在的報工資料須先清除再重新產生
           CALL cl_err('','asf-815',0)
           NEXT FIELD shb14
        END IF
 
        SELECT * INTO g_rvv.* FROM rvv_file 
         WHERE rvv01=g_shb.shb14 AND rvv02=g_shb.shb15
       IF STATUS THEN 
          CALL cl_err3("sel","rvv_file",g_shb.shb14,g_shb.shb15,"asf-700","","sel rvv",1)  #No.FUN-660128
          NEXT FIELD shb14 END IF
 
        LET g_argv1=g_shb.shb14
        LET g_argv3=g_shb.shb15
        LET g_argv4='a'
 
        SELECT pmn18,pmn32,pmn012 INTO g_pmn18,g_pmn32,g_pmn012 FROM pmn_file,rvb_file  #讀取製程序號 #FUN-A60095
         WHERE rvb01=g_rvv.rvv04 AND rvb02=g_rvv.rvv05
           AND rvb04=pmn01 AND rvb03=pmn02
       IF STATUS THEN 
          CALL cl_err3("sel","pmn_file,rvb_file",g_rvv.rvv04,g_rvv.rvv05,STATUS,"","sel pmn",1)  #No.FUN-660128
          NEXT FIELD shb14 END IF
 
        SELECT sgm04,sgm05,sgm58 INTO g_sgm04,g_sgm05,g_sgm58 FROM sgm_file
         WHERE sgm01 = g_pmn18 AND sgm03=g_pmn32 
           AND sgm012 = g_pmn012  #FUN-A60095
       IF STATUS THEN 
          CALL cl_err3("sel","sgm_file",g_pmn18,g_pmn32,STATUS,"","sel sgm",1)  #No.FUN-660128
          NEXT FIELD shb14 END IF
 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
     
     END INPUT
 
     RETURN 0
 
END FUNCTION
 

FUNCTION t730_sfb()
  #.........委外產生時,讀取工單資料&sgm_file,且資料不可異動...............
   LET g_shb.shb05 = g_rvv.rvv18 
   SELECT sfb05 INTO g_shb.shb10 FROM sfb_file
    WHERE sfb01=g_shb.shb05
      AND sfb04 IN ('4','5','6','7')
      AND (sfb28 <> '3' OR sfb28 IS NULL)
   IF STATUS THEN   #資料不存在
      CALL cl_err3("sel","sfb_file",g_shb.shb05,"",STATUS,"","",1)  #No.FUN-660128
      RETURN -1
   ELSE
      DISPLAY BY NAME g_shb.shb10
      CALL t730_shb10('d')
      IF NOT cl_null(g_errno) THEN
        CALL cl_err(g_shb.shb10,g_errno,0)   
        LET g_shb.shb10 = g_shb_t.shb10
        DISPLAY BY NAME g_shb.shb10
        RETURN -1
      END IF 
   END IF 
   RETURN 0
END FUNCTION
 
FUNCTION t730_chk_shb112()
DEFINE l_shc05 LIKE shc_file.shc05
   LET l_shc05=0
   SELECT SUM(shc05) INTO l_shc05 FROM shc_file 
                                 WHERE shc01=g_shb.shb01
                                   AND shc05 IS NOT NULL
   IF cl_null(l_shc05) OR SQLCA.sqlcode THEN
      LET l_shc05=0
   END IF
   RETURN (g_shb.shb112=l_shc05)
END FUNCTION
 
 
FUNCTION t730_ck_pmn(p_shb05,p_shb06)
  DEFINE  
          p_shb05    LIKE shb_file.shb05,
          p_shb06    LIKE shb_file.shb06,
          l_pmn01    LIKE pmn_file.pmn01,
          l_pmn02    LIKE pmn_file.pmn02,
          l_cnt      LIKE type_file.num5    #No.FUN-680121 SMALLINT
 
#讀取委外工單的已發出採購單資料
    DECLARE t730_ck_pmn_cl CURSOR FOR
      SELECT pmn01,pmn02 FROM pmn_file,pmm_file
       WHERE pmn41 = p_shb05
         AND pmn43 = p_shb06
         AND pmn011= 'SUB'
         AND pmn16 NOT IN ('6','7','8','9')
         AND pmn01 = pmm01
         AND pmm25 = '2'
 
#check 製程委外應要有入庫資料才可以報工
    LET g_errno = ''
    LET l_cnt = 0
    LET g_success = 'N'    #表示沒有入庫資料
 
   #讀取委外工單的採購單資料
    FOREACH t730_ck_pmn_cl INTO l_pmn01,l_pmn02
      IF STATUS THEN 
         LET g_errno = STATUS
         EXIT FOREACH
      END IF
 
     #check採購單是否有入庫資料
      SELECT COUNT(*) INTO l_cnt FROM rvv_file,rvu_file
       WHERE rvv36 = l_pmn01
         AND rvv37 = l_pmn02
         AND rvv01 = rvu01 
         AND rvuconf = 'Y'
      IF l_cnt > 0 THEN 
         LET g_success = 'Y'
      END IF
    END FOREACH 
 
    IF cl_null(g_errno) THEN
       IF g_success = 'N' THEN         #表沒有入庫ok的資料
          LET g_errno = 'asf-860' 
       END IF
    END IF
 
END FUNCTION
 
FUNCTION t730_chk_runcard(p_shb16,p_shb05,p_shb06,p_shb081,p_shb14,p_shb012)  #FUN-A60095
DEFINE   p_shb16      LIKE shb_file.shb16      
DEFINE   p_shb06      LIKE shb_file.shb06      
DEFINE   p_shb05      LIKE shb_file.shb05      
DEFINE   p_shb081     LIKE shb_file.shb081     
DEFINE   p_shb012     LIKE shb_file.shb012 #FUN-A60095
DEFINE   l_sgm52      LIKE sgm_file.sgm52      
DEFINE   p_shb14      LIKE shb_file.shb14
 
    LET g_errno = ''
    IF NOT cl_null(p_shb14) THEN 
       RETURN
    END IF
    IF cl_null(p_shb16) OR cl_null(p_shb06) OR cl_null(p_shb05) OR cl_null(p_shb081) THEN 
       RETURN 
    END IF 
    
    SELECT sgm52 INTO l_sgm52 FROM sgm_file 
     WHERE sgm01 = p_shb16
       AND sgm02 = p_shb05
       AND sgm03 = p_shb06
       AND sgm04 = p_shb081
       AND sgm012 = p_shb012  #FUN-A60095
    IF SQLCA.sqlcode THEN 
       LET g_errno = SQLCA.sqlcode
       RETURN 
    END IF    
    
    IF l_sgm52 = 'Y' THEN 
       LET g_errno = 'asf-614'
       return
    END IF 
    
END FUNCTION 
 
FUNCTION t730_1()
DEFINE tm            RECORD
             choice1 LIKE type_file.chr1,  
             shb21   LIKE shb_file.shb21,
             shb22   LIKE shb_file.shb22,
             dt1     LIKE type_file.dat,   
             emp     LIKE gen_file.gen01,
             gen02   LIKE gen_file.gen02,
             choice2 LIKE type_file.chr1,  
             choice3 LIKE type_file.chr1,    #FUN-BC0104
             dt2     LIKE type_file.dat,    
             wh1     LIKE img_file.img02,
             wh2     LIKE img_file.img03,
             wh3     LIKE img_file.img04
                     END RECORD
DEFINE l_sfb        RECORD LIKE sfb_file.*,
       l_shb        RECORD LIKE shb_file.*,
       l_sfu        RECORD LIKE sfu_file.*,     
       l_cnt        LIKE type_file.num10,  
       l_gen02      LIKE gen_file.gen02,
       l_qcs091     LIKE qcs_file.qcs091,
       li_result    LIKE type_file.num5,   
       l_imd02      LIKE imd_file.imd02,
       l_sfv03      LIKE sfv_file.sfv03
DEFINE l_gaz03      LIKE gaz_file.gaz03
DEFINE l_qc_cnt     LIKE type_file.num10
DEFINE l_aza41      LIKE type_file.chr18
DEFINE l_count      LIKE type_file.num5
DEFINE l_smy67      LIKE smy_file.smy67
DEFINE l_smy68      LIKE smy_file.smy68
DEFINE l_smyacti    LIKE smy_file.smyacti
DEFINE l_smysys     LIKE smy_file.smysys
DEFINE l_smyslip    LIKE smy_file.smyslip
DEFINE l_smykind    LIKE smy_file.smykind 
DEFINE l_sfb94      LIKE sfb_file.sfb94 
DEFINE l_shb111     LIKE shb_file.shb111
DEFINE l_flag       LIKE type_file.chr1
DEFINE l_qcf22      LIKE qcf_file.qcf22 
DEFINE g_qcf22      LIKE qcf_file.qcf22 
DEFINE l_sgm311     LIKE sgm_file.sgm311
DEFINE l_minus      LIKE sgm_file.sgm311
DEFINE g_sfv09      LIKE sfv_file.sfv09 
DEFINE l_shm09      LIKE shm_file.shm09
DEFINE l_t          LIKE type_file.num5    #TQC-B60129
DEFINE l_shb21      LIKE shb_file.shb21    #FUN-BC0104
DEFINE l_msg        STRING                 #TQC-C20248
 
   OPEN WINDOW t730_1_w AT 2,2 WITH FORM "csf/42f/csft730_1"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("csft730_1")
 
   LET tm.choice1 = 'Y'
   LET tm.choice2 = 'Y'
   LET tm.choice3 = 'N'       #FUN-BC0104
   LET tm.dt1     = g_today
   LET tm.dt2     = g_today
   LET tm.emp     = g_user
   LET tm.shb21   = NULL  
   LET tm.shb22   = NULL
   
   IF g_aza.aza41 = '1' THEN 
      LET l_count = '3'
   ELSE
      IF g_aza.aza41 = '2' THEN 
         LET l_count = '4'
      ELSE 
         LET l_count = '5'
      END IF 
   END IF 
   #FUN-BC0104--add--str----
   SELECT qcz14 INTO g_qcz.qcz14 FROM qcz_file
   IF g_qcz.qcz14 = 'N' THEN 
      CALL cl_set_comp_visible("choice3",FALSE)
   END IF
   #FUN-BC0104--add--end----
   	 
   LET l_aza41 = g_shb.shb01[1,l_count]                              #CHI-9B0005 mark 	      
   SELECT smy67,smy68 INTO l_smy67,l_smy68 FROM smy_file
    WHERE smyslip = l_aza41
    
    LET tm.shb21 = l_smy67,'-'
    LET tm.shb22 = l_smy68,'-' 
   	  	      
   WHILE TRUE   
       INPUT BY NAME tm.choice1,tm.shb22,tm.dt1,tm.emp,tm.choice2,tm.choice3,      #FUN-BC0104 add choice3
                    tm.shb21,tm.dt2,tm.wh1,tm.wh2,tm.wh3 
                    WITHOUT DEFAULTS
       BEFORE INPUT 
          CALL cl_set_docno_format("shb21")
          CALL cl_set_docno_format("shb22")
              
          
        ON CHANGE choice1         
              CALL cl_set_comp_required("shb22",tm.choice1='Y')    
             IF tm.choice1 = 'N' THEN 
                 LET tm.shb22 = NULL
                 LET tm.dt1   = NULL
                 LET tm.emp   = NULL
              ELSE
              	 LET tm.dt1 = g_today
              	 LET tm.emp = g_user   
              END IF 
              DISPLAY BY NAME tm.shb22,tm.dt1,tm.emp      
      
        ON CHANGE choice2
           CALL cl_set_comp_required("shb21,dt2",tm.choice2='Y') 
            IF tm.choice2 = 'N' THEN 
                 LET tm.shb21 = NULL
                 LET tm.dt2   = NULL
                 LET tm.wh1   = NULL
                 LET tm.wh2   = NULL
                 LET tm.wh3   = NULL
             ELSE
             	  LET tm.dt2 = g_today                
                  LET tm.choice3 = 'N'    #FUN-BC0104
                  CALL cl_set_comp_entry("wh1,wh2,wh3",TRUE)   #FUN-BC0104
             END IF 
             DISPLAY BY NAME tm.shb21,tm.dt2,tm.wh1,tm.wh2,tm.wh3,tm.choice3    #FUN-BC0104 add choice3

        #FUN-BC0104-add-str--
        ON CHANGE choice3
           CALL cl_set_comp_entry("wh1,wh2,wh3",tm.choice3='N')
           IF tm.choice3 = 'Y' THEN 
              LET tm.choice2 = 'N'
           END IF
           DISPLAY BY NAME tm.choice2
        #FUN-BC0104-add-end--
      
        AFTER FIELD shb22
          IF NOT cl_null(tm.shb22) THEN
              LET g_t1 = s_get_doc_no(tm.shb22)
              CALL s_check_no("asf",g_t1,"","B","shb_file","shb22","")
                    RETURNING li_result,tm.shb22
              IF (NOT li_result) THEN
                NEXT FIELD shb22
              END IF
              SELECT smysys,smy68,smyacti,smykind INTO l_smysys,l_smy68,l_smyacti,l_smykind
                FROM smy_file
               WHERE smyslip = l_aza41          
              
            CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0014'  #無此單別
              WHEN l_smykind != '9'     LET g_errno = 'afa-095'  #單據性質不符,請重新輸入 !!
              WHEN l_smysys <> 'asf'    LET g_errno = 'asm-700'  #系統別不符,請重新輸入!!
              WHEN l_smyacti='N'        LET g_errno = '9028'
              OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
            END CASE      
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               NEXT FIELD shb22    
            ELSE
            	 DISPLAY BY NAME tm.shb22          	    
            END IF              
          END IF
        
        AFTER FIELD emp
           IF NOT cl_null(tm.emp) THEN
              LET l_gen02=''
              SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=tm.emp
              DISPLAY l_gen02 TO FORMONLY.gen02
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',100,0)
                 NEXT FIELD emp
              END IF
           ELSE
              LET l_gen02=''
              DISPLAY l_gen02 TO FORMONLY.gen02 
           END IF
      
        AFTER FIELD shb21
           IF NOT cl_null(tm.shb21) THEN
              LET g_t2 = s_get_doc_no(tm.shb21)
             #CALL s_check_no("asf",g_t2,'',"A","shb_file","shb21","") #FUN-A80128 mark
              CALL s_check_no("asf",g_t2,'',"A","sfu_file","sfu01","") #FUN-A80128 add
                     RETURNING li_result,tm.shb21
              IF (NOT li_result) THEN
                 NEXT FIELD shb21
              END IF              
              #TQC-AC0294-----start------------
              CALL t730_shb21()
              IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD shb21
              END IF
              #TQC-AC0294-----end-------------- 
              
              SELECT smysys,smy67,smyacti INTO l_smysys,l_smy67,l_smyacti FROM smy_file
               WHERE smyslip = l_aza41
           
            CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0014'  #無此單別      
              WHEN l_smykind != '9'     LET g_errno = 'afa-095'  #單據性質不符,請重新輸入 !!      
              WHEN l_smysys <> 'asf'    LET g_errno = 'asm-700'  #系統別不符,請重新輸入!!
              WHEN l_smyacti='N'        LET g_errno = '9028'
              OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
            END CASE      
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               NEXT FIELD shb21     
             ELSE
             	 DISPLAY BY NAME tm.shb21             
            END IF              
           END IF
 
        AFTER FIELD wh1
           IF tm.wh1 IS NOT NULL THEN
              SELECT imd02 INTO l_imd02 FROM imd_file WHERE imd01 = tm.wh1
              IF STATUS THEN
                 CALL cl_err('sel imd',STATUS,0)
                 NEXT FIELD wh1
              END IF
              #Add No.FUN-AB0049
              IF NOT s_chk_ware(tm.wh1) THEN  #检查仓库是否属于当前门店
                 NEXT FIELD wh1
              END IF
              #End Add No.FUN-AB0049
           END IF
 
    AFTER INPUT 
          IF NOT INT_FLAG THEN             
      	   IF NOT cl_null(tm.emp) THEN
              LET l_gen02=''
              SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=tm.emp
              DISPLAY l_gen02 TO FORMONLY.gen02
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',100,0)
                 NEXT FIELD emp
              END IF
           ELSE
              LET l_gen02=''
              DISPLAY l_gen02 TO FORMONLY.gen02
           END IF  
          END IF 
      
        ON ACTION controlp
           CASE
              WHEN INFIELD(shb22)                 
                   LET g_t1 = s_get_doc_no(tm.shb22)                   
                    CALL q_smy(FALSE,FALSE,g_t1,'ASF','B') RETURNING g_t1   #NO.FUN-940113 add
                   LET tm.shb22 = g_t1,'-'                            #NO.FUN-940113 add '-' 
                   DISPLAY BY NAME tm.shb22
                   NEXT FIELD shb22           
                WHEN INFIELD(emp)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   CALL cl_create_qry() RETURNING tm.emp
                   DISPLAY BY NAME tm.emp
                   NEXT FIELD emp
                WHEN INFIELD(shb21)                
                   LET g_t2 = s_get_doc_no(tm.shb21) 
                   LET g_sql = " (smy73 <> 'Y' OR smy73 is null)"  #TQC-AC0294 add
                   CALL smy_qry_set_par_where(g_sql)               #TQC-AC0294 add                
                    CALL q_smy( FALSE,TRUE,g_t2,'ASF','A') RETURNING g_t2 #NO.FUN-940113 add
                   LET tm.shb21=g_t2,'-'                       #NO.FUN-940113 add '-'
                    DISPLAY BY NAME tm.shb21
                    NEXT FIELD shb21    
                                            
                WHEN INFIELD(wh1)
                  #Mod No.FUN-AB0049
                  #CALL cl_init_qry_var()
                  #LET g_qryparam.form ="q_imd"
                  #LET g_qryparam.arg1 = 'SW'        #倉庫類別
                  #CALL cl_create_qry() RETURNING tm.wh1
                   CALL q_imd_1(FALSE,TRUE,"","",g_plant,"","")  #只能开当前门店的
                        RETURNING tm.wh1
                  #End Mod No.FUN-AB0049
                   DISPLAY BY NAME tm.wh1
                   NEXT FIELD wh1
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
         LET g_success='N'
         CLOSE WINDOW t730_1_w
         RETURN
      END IF
      
      BEGIN WORK 
      LET g_success = 'Y'     
      LET l_flag = 'Y'       
   
     IF tm.choice1='Y' THEN        
        SELECT COUNT(*) INTO l_qc_cnt FROM shb_file  
         WHERE shb01 = g_shb.shb01
           AND shb22 IS NOT NULL 
        IF l_qc_cnt > 0 THEN
           CALL cl_err('','asf-131',1)
           LET g_success = 'N'  
           CONTINUE WHILE                    
        END IF
       
        IF g_success = 'Y' THEN          
           DECLARE t300_w2_cur CURSOR FOR SELECT shb_file.*,sfb94 FROM shb_file,sfb_file
             WHERE shb01 = g_shb.shb01 
               AND sfb01 = g_shb.shb05
           FOREACH t300_w2_cur INTO l_shb.*,l_sfb94      
             IF g_success='N' THEN
                EXIT FOREACH
             END IF
            IF l_shb.shb111 <= 0 THEN 
               CALL cl_err('','asf-991',0)
               LET g_success = 'N'
               LET l_flag = 'N'               
               EXIT FOREACH 
            END IF 
           SELECT sgm311 INTO l_sgm311 FROM sgm_file
            WHERE sgm01 = g_shb.shb16
              AND sgm03 = g_shb.shb06
              AND sgm012 = g_shb.shb012  #FUN-A60095
           SELECT SUM(qcf22) INTO l_qcf22 FROM qcf_file
            WHERE qcf01 IS NOT NULL
              AND qcf02 = g_shb.shb05
              AND qcf03 = g_shb.shb16                        #TQC-C20479 add
              AND qcf14 = 'Y'
              AND qcf18 = '2'
    
          IF cl_null(l_sgm311) THEN 
             LET l_sgm311 = 0 
          END IF 
          IF cl_null(l_qcf22) THEN 
             LET l_qcf22 = 0
          END IF 
          IF cl_null(l_shb.shb111) THEN 
             LET l_shb.shb111 = 0 
          END IF             
          
         LET l_minus = l_sgm311 - l_qcf22 
         IF l_shb.shb111 < l_minus THEN 
            LET g_qcf22 = l_shb.shb111
         ELSE
    	      LET g_qcf22 = l_minus 
         END IF  	           
         IF g_qcf22 <= 0  THEN           
            CALL cl_err('','asf-993',0)
            LET g_success = 'N'
            LET l_flag = 'N'
            EXIT FOREACH 
         END IF                                   
             IF (l_sfb94 = 'Y') AND cl_null(l_shb.shb22) THEN              
                LET g_t1 = s_get_doc_no(tm.shb22)                
                CALL s_auto_assign_no("asf",g_t1,tm.dt1,"B","shb_file","shb22","","","")                      
                   RETURNING li_result,tm.shb22       
                IF (NOT li_result) THEN
                   CALL cl_err('shb22',"sub-143",1)                 
                   LET g_success ='N'
                   EXIT FOREACH
                 END IF
                 LET g_shb22 = tm.shb22
                 LET g_emp = tm.emp
                 CALL t300_w4(l_shb.*)  
             ELSE
            	 IF cl_null(l_sfb94) OR l_sfb94 = 'N' THEN  
            	    CALL cl_err('','asf-995',1)
                    IF tm.choice2 = 'N' THEN  #TQC-B60127
                       LET g_success = 'N'    #TQC-B60127
                    END IF                    #TQC-B60127
            	 END IF                  
             END IF              
          END FOREACH
        END IF
       IF l_flag = 'N' THEN 
           CONTINUE WHILE 
       END IF         
     END IF       
     
#TQC-B60129 ------------------------------Begin----------------------------------
     IF tm.choice1 = 'N' AND tm.choice2 = 'Y' THEN  
        CALL s_showmsg_init()
        DECLARE t300_w2_cur_1 CURSOR FOR SELECT shb_file.*,sfb94 FROM shb_file,sfb_file
          WHERE shb01 = g_shb.shb01
            AND sfb01 = g_shb.shb05
        FOREACH t300_w2_cur_1 INTO l_shb.*,l_sfb94
           IF g_success='N' THEN
              EXIT FOREACH
           END IF
           IF l_sfb94 = 'Y' THEN
              LET l_t = 0  
              SELECT COUNT(*) INTO l_t FROM qcf_file                               
               WHERE qcf01 IS NOT NULL
                 AND qcf02 = l_shb.shb05
                 AND qcf03 = l_shb.shb16                        #TQC-C20479 add
                 AND qcf14 = 'Y'
                 AND qcf18 = '2'
              IF l_t=0 THEN
                 CALL s_errmsg('shb05',l_shb.shb05,'','asr-055',1)
                 LET g_success='N' 
              END IF
           END IF
        END FOREACH
        CALL s_showmsg()
     END IF 

#TQC-B60129 ------------------------------End------------------------------------
    IF (tm.choice2='Y') AND (g_success='Y') THEN   ##如果FQC單有產生失敗,則入庫單就不操作執行
      SELECT COUNT(*) INTO l_qc_cnt FROM shb_file
       WHERE shb01 = g_shb.shb01
         AND shb21 IS NOT NULL 
      IF l_qc_cnt > 0 THEN 
         CALL cl_err('','asf-132',1)
         LET g_success = 'N'
         IF tm.choice1 = 'Y' THEN 
            LET g_shb.shb22 = NULL
            UPDATE shb_file SET shb22 = NULL WHERE shb01 = g_shb.shb01  
         END IF          
         CONTINUE WHILE 
      ELSE          
         IF cl_null(tm.wh2) THEN                     
            LET tm.wh2=' '
         END IF
         IF cl_null(tm.wh3) THEN
            LET tm.wh3=' '
         END IF
         SELECT shb111 INTO l_shb111 FROM shb_file
          WHERE shb01 = g_shb.shb01        
         IF l_shb111 <= 0 THEN 
            CALL cl_err('','asf-992',0)
            LET g_success = 'N' 
            CONTINUE WHILE 
         END IF  
   
        SELECT sgm311 INTO l_sgm311 FROM sgm_file
         WHERE sgm01 = g_shb.shb16
           AND sgm03 = g_shb.shb06 
           AND sgm012 = g_shb.shb012  #FUN-A60095
        SELECT shm09 INTO l_shm09 FROM shm_file
         WHERE shm01 = g_shb.shb16 
        IF cl_null(l_sgm311) THEN 
           LET l_sgm311 = 0 
        END IF 
        IF cl_null(l_shm09) THEN 
           LET l_shm09 = 0 
        END IF       
        IF cl_null(l_shb111) THEN 
           LET l_shb111 = 0 
        END IF    
   
      LET l_minus = l_sgm311 - l_shm09
      IF l_shb111 < l_minus THEN 
        LET g_sfv09 = l_shb111
      ELSE
   	    LET g_sfv09 = l_minus 
      END IF 	 
   
      IF g_sfv09 <= 0 THEN 
         CALL cl_err('','asf-994',0)
         LET g_success = 'N' 
         CONTINUE WHILE    
      END IF        
         LET l_cnt=0
          SELECT COUNT(*) INTO l_cnt FROM shb_file,shm_file   #sfb_file->shm_file
           WHERE shb01 = g_shb.shb01
             AND shm01 = g_shb.shb16
 
         IF l_cnt>0 THEN  #產生入庫單頭
            INITIALIZE l_sfu.* TO NULL
            LET g_t2 = s_get_doc_no(tm.shb21)           
           #CALL s_auto_assign_no("apm",g_t2,tm.dt2,"A","sfu_file","sfu01","","","") #FUN-A60095
            CALL s_auto_assign_no("asf",g_t2,tm.dt2,"A","sfu_file","sfu01","","","") #FUN-A60095
               RETURNING li_result,tm.shb21         
            IF (NOT li_result) THEN
               LET g_success='N'
               CALL cl_err('sfu01',"sub-143",1)
            END IF
 
            LET l_sfu.sfu00='1'    #工單完工入庫
            LET l_sfu.sfu01=tm.shb21    
            LET l_sfu.sfu02=tm.dt2
            LET l_sfu.sfu14=tm.dt2      
            LET l_sfu.sfu04=g_grup
            LET l_sfu.sfupost='N'
            LET l_sfu.sfuconf='N'       
            LET l_sfu.sfuuser=g_user
            LET l_sfu.sfugrup=g_grup
            LET l_sfu.sfumodu=''
            LET l_sfu.sfudate=g_today
            LET l_sfu.sfuplant = g_plant #FUN-980008 add
            LET l_sfu.sfulegal = g_legal #FUN-980008 add

        SELECT * INTO g_sgm.* FROM sgm_file
         WHERE sgm01=g_shb.shb16
           AND sgm03=g_shb.shb06
           AND sgm012=g_shb.shb012  #FUN-A60095
        IF STATUS THEN  #資料資料不存在
           CALL cl_err3("sel","sgm_file",g_shb.shb16,g_shb.shb06,STATUS,"","sel sgm_file",1) 
           LET g_success = 'N'
           CLOSE WINDOW t730_1_w
           EXIT WHILE 
        END IF  
        IF g_success  = 'Y' THEN              
            LET l_sfu.sfuoriu = g_user      #No.FUN-980030 10/01/04
            LET l_sfu.sfuorig = g_grup      #No.FUN-980030 10/01/04
            #FUN-A80128---add---str--
            LET l_sfu.sfu15   = '0'
            LET l_sfu.sfu16   = g_user
            LET l_sfu.sfumksg =  g_smy.smyapr
            #FUN-A80128---add---end--
            IF cl_null(l_sfu.sfumksg) THEN LET l_sfu.sfumksg='N' END IF #FUN-A70095
            INSERT INTO sfu_file VALUES (l_sfu.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err('ins sfu',SQLCA.sqlcode,1)
               LET g_success='N'
            END IF
        END IF     
      END IF
 
         LET l_sfv03=1
         SELECT shb_file.*,sfb94 INTO l_shb.*,l_sfb94
           FROM shb_file,shm_file,sfb_file  
          WHERE shb01 = g_shb.shb01
            AND shm01 = g_shb.shb16
            AND sfb01 = g_shb.shb05 
         IF (l_sfb94 = 'N') AND cl_null(l_shb.shb21) THEN   
             LET g_shb21  = tm.shb21
             LET g_wh1    = tm.wh1
             LET g_wh2    = tm.wh2
             LET g_wh3    = tm.wh3
             CALL t300_w3(l_shb.*,l_sfv03,l_shb.shb111)      
             UPDATE shb_file SET shb21 = tm.shb21
              WHERE shb01 = l_shb.shb01
              LET g_shb.shb21 = tm.shb21 
              IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                 CALL cl_err('upd shb21',SQLCA.sqlcode,1)  
                 LET g_success='N'
              END IF 
         END IF
         
         IF (l_sfb94 = 'Y') AND (NOT cl_null(l_shb.shb22) AND cl_null(l_shb.shb21)) THEN 
             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt FROM qcf_file 
              WHERE qcf01=l_shb.shb22
                AND qcf14='Y'
                AND (qcf09='1' OR qcf09='3')
             IF l_cnt>0 THEN
                LET l_qcs091=0
                SELECT qcf091 INTO l_qcs091 FROM qcf_file 
                 WHERE qcf01=l_shb.shb22
                IF cl_null(g_shb21) THEN LET g_shb21=tm.shb21 END IF #FUN-A60095
                 CALL t300_w3(l_shb.*,l_sfv03,l_qcs091)
                 UPDATE shb_file set shb21=tm.shb21
                  WHERE shb01=l_shb.shb01
                  LET g_shb.shb21 = tm.shb21
                  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                    CALL cl_err('upd shb21',SQLCA.sqlcode,1)
                    LET g_success='N'
                  END IF
              END IF
          END IF
     END IF         
 END IF   

   #FUN-BC0104----add----str----
   IF (tm.choice3 = 'Y') AND (g_success = 'Y') THEN
   #  LET g_msg = "aqcp107 '2' '",tm.shb21,"' '' '",tm.dt2,"' '' '' '",g_shb.shb05,"' '",g_shb.shb10,"' '",g_shb.shb16,"' 'Y'"
   #TQC-C20248 --------------Begin--------------
      LET l_msg = "%",g_shb.shb01,"$",g_shb.shb16 
      LET g_msg = "aqcp107 '2' '",tm.shb21,"' '' '",tm.dt2,"' '' '' '",g_shb.shb05,"' '",g_shb.shb10,"' '",l_msg,"' 'Y'"   
      CALL cl_cmdrun_wait(g_msg)    
   #TQC-C20248 --------------End----------------
   END IF
#TQC-B20196 --------------Begin---------------
#  SELECT sfv01 INTO l_shb21 FROM sfv_file
#   WHERE sfv11 = g_shb.shb05
#     AND sfv17 = g_shb.shb22
#     AND sfv20 = g_shb.shb16
#  UPDATE shb_file set shb21=l_shb21
#   WHERE shb01=l_shb.shb01
#   LET g_shb.shb21 = l_shb21
#   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#     CALL cl_err('upd shb21',SQLCA.sqlcode,1)
#     LET g_success='N'
#   END IF
#TQC-B20196 --------------End-----------------
   #FUN-BC0104----add----end----
 
   IF g_success = 'Y' THEN 
   #IF tm.choice1 = 'Y' OR tm.choice2 = 'Y' THEN                          #TQC-C20196  #TQC-C20361 mark
   #IF (tm.choice1 = 'Y' OR tm.choice2 = 'Y') AND tm.choice3 = 'N' THEN   #TQC-C20196  #TQC-C20361 mark
    IF tm.choice1 = 'Y' OR tm.choice2 = 'Y' OR tm.choice3 = 'Y' THEN      #TQC-C20361  add
      IF cl_confirm("asf-133") THEN 
         LET g_success = 'Y'
      ELSE
      	 SELECT COUNT(*) INTO l_qc_cnt FROM shb_file  
          WHERE shb01 = g_shb.shb01
            AND shb22 IS NOT NULL 
           IF l_qc_cnt > 0  AND tm.choice1 = 'Y' THEN   
            	LET g_shb.shb22 = ''
           END IF  
     
         SELECT COUNT(*) INTO l_qc_cnt FROM shb_file
          WHERE shb01 = g_shb.shb01
            AND shb21 IS NOT NULL            	
           IF l_qc_cnt > 0  AND tm.choice2 = 'Y' THEN   
             LET g_shb.shb21 = ''
          END IF 
               
          LET g_success  = 'N'        
      END IF       	   
   END IF   
  END IF     
 
    CLOSE WINDOW t730_1_w
    EXIT WHILE
  END WHILE
   
   CLOSE t730_cl
 
   IF g_success != 'Y' THEN 
      ROLLBACK WORK
      CALL cl_err('','9052',0)
    ELSE
    	  SELECT * INTO g_sgm.* FROM sgm_file
         WHERE sgm01=g_shb.shb16
           AND sgm03=g_shb.shb06
           AND sgm012=g_shb.shb012  #FUN-A60095
        IF STATUS THEN  #資料資料不存在
           CALL cl_err3("sel","sgm_file",g_shb.shb16,g_shb.shb06,STATUS,"","sel sgm_file",1) 
           ROLLBACK WORK
        ELSE       
    	     COMMIT WORK
    	  END IF 
    END IF  	   
END FUNCTION
 
FUNCTION t300_w3(l_shb,l_sfv03,l_sfv09)     
DEFINE l_shb RECORD    LIKE shb_file.*,
       l_sfv RECORD    LIKE sfv_file.*,
       l_sfv03         LIKE sfv_file.sfv03,
       l_sfv09         LIKE sfv_file.sfv09,
       l_ima906        LIKE ima_file.ima906,
       l_ima907        LIKE ima_file.ima907,
       l_factor        LIKE ima_file.ima31_fac,  
       l_flag          LIKE type_file.num5,
       l_ima25         LIKE ima_file.ima25,
       l_ima35         LIKE ima_file.ima35,
       l_ima36         LIKE ima_file.ima36,
       l_sfb98         LIKE sfb_file.sfb98        
DEFINE l_sgm311        LIKE sgm_file.sgm311
DEFINE l_shm09         LIKE shm_file.shm09
DEFINE l_minus         LIKE sgm_file.sgm311
DEFINE l_sfvi   RECORD LIKE sfvi_file.*      #FUN-B70074
DEFINE l_sfu04         LIKE sfu_file.sfu04   #FUN-CB0087 add
DEFINE l_sfu16         LIKE sfu_file.sfu16   #FUN-CB0087 add
 
   SELECT ima25,ima906,ima907,ima35,ima36 INTO l_ima25,l_ima906,l_ima907,l_ima35,l_ima36 
     FROM ima_file
    WHERE ima01 = l_shb.shb10 
   SELECT sfb98 INTO l_sfb98 FROM sfb_file WHERE sfb01 = g_shb.shb05 
    
   SELECT sgm311 INTO l_sgm311 FROM sgm_file
    WHERE sgm01 = g_shb.shb16
      AND sgm03 = g_shb.shb06 
      AND sgm012 = g_shb.shb012  #FUN-A60095
   SELECT shm09 INTO l_shm09 FROM shm_file
    WHERE shm01 = g_shb.shb16 
   IF cl_null(l_sgm311) THEN 
      LET l_sgm311 = 0 
   END IF 
   IF cl_null(l_shm09) THEN 
      LET l_shm09 = 0 
   END IF       
   IF cl_null(l_sfv09) THEN 
      LET l_sfv09 = 0 
   END IF 
       
   LET l_sfv.sfv01=g_shb21        
   LET l_sfv.sfv03=l_sfv03
   LET l_sfv.sfv04=l_shb.shb10    
   
   IF NOT cl_null(g_wh1) THEN     
     LET l_sfv.sfv05 = g_wh1           
   ELSE
   	 LET l_sfv.sfv05 = l_ima35
   END IF 	  
   IF NOT cl_null(g_wh2) THEN 
      LET l_sfv.sfv06 = g_wh2          
   ELSE
   	  LET l_sfv.sfv06 = l_ima36
   END IF 	     
   LET l_sfv.sfv07=g_wh3          
   LET l_sfv.sfv08=l_ima25 
   LET l_minus = l_sgm311 - l_shm09
   IF l_sfv09 < l_minus THEN 
       LET l_sfv.sfv09 = l_sfv09
   ELSE
   	   LET l_sfv.sfv09 = l_minus 
   END IF
   LET l_sfv.sfv09 = s_digqty(l_sfv.sfv09,l_sfv.sfv08)   #No.FUN-BB0086   
   LET l_sfv.sfv16='N'   
   LET l_sfv.sfv11=l_shb.shb05
   LET l_sfv.sfv17=l_shb.shb22
   LET l_sfv.sfv20=l_shb.shb16 
   LET l_sfv.sfv930=l_sfb98 
   LET l_sfv.sfvplant = g_plant #FUN-980008 add
   LET l_sfv.sfvlegal = g_legal #FUN-980008 add
 
   CASE
      WHEN l_ima906='1'
         LET l_sfv.sfv30=l_ima25          
         LET l_sfv.sfv31=1
         LET l_sfv.sfv32=l_shb.shb111 
         LET l_sfv.sfv33=''
         LET l_sfv.sfv34=''
         LET l_sfv.sfv35=''
      WHEN l_ima906 MATCHES '[2,3]'
         LET l_sfv.sfv30=l_ima25           
         LET l_sfv.sfv31=1
         LET l_sfv.sfv32=l_shb.shb111    
         LET l_sfv.sfv33=l_ima907
         CALL s_umfchk(l_sfv.sfv04,l_ima907,l_sfv.sfv08) RETURNING l_flag,l_factor
         IF l_flag=1 THEN
           LET l_factor=1
         END IF
         LET l_sfv.sfv34=l_factor
         LET l_sfv.sfv35=0
   END CASE
   LET l_sfv.sfv32 = s_digqty(l_sfv.sfv32,l_sfv.sfv30)   #No.FUN-BB0086
       SELECT * INTO g_sgm.* FROM sgm_file
         WHERE sgm01=g_shb.shb16
           AND sgm03=g_shb.shb06
           AND sgm012=g_shb.shb012  #FUN-A60095
        IF STATUS THEN  #資料資料不存在
           CALL cl_err3("sel","sgm_file",g_shb.shb16,g_shb.shb06,STATUS,"","sel sgm_file",1) 
           LET g_success  = 'N'
        END IF 
   IF g_success  = 'Y' THEN            
   #TQC-C20465 ---------Begin--------
      IF cl_null(l_sfv.sfv05) THEN LET l_sfv.sfv05 = ' ' END IF
      IF cl_null(l_sfv.sfv06) THEN LET l_sfv.sfv06 = ' ' END IF
      IF cl_null(l_sfv.sfv07) THEN LET l_sfv.sfv07 = ' ' END IF
   #TQC-C20465 ---------End----------  

      #FUN-CB0087---add---str---
      IF g_aza.aza115 = 'Y' THEN
         SELECT sfu04,sfu16 INTO l_sfu04,l_sfu16 FROM sfu_file WHERE sfu01 = l_sfv.sfv01
         CALL s_reason_code(l_sfv.sfv01,l_sfv.sfv11,'',l_sfv.sfv04,l_sfv.sfv05,l_sfu16,l_sfu04) RETURNING l_sfv.sfv44
         IF cl_null(l_sfv.sfv44) THEN
            CALL cl_err('','aim-425',1)
            LET g_success='N'
         END IF
      END IF
      #FUN-CB0087---add---end--
      INSERT INTO sfv_file VALUES (l_sfv.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err('ins sfv',SQLCA.sqlcode,1)
         LET g_success='N'
#FUN-B70074--add--insert--
      ELSE
         IF NOT s_industry('std') THEN
            INITIALIZE l_sfvi.* TO NULL
            LET l_sfvi.sfvi01 = l_sfv.sfv01
            LET l_sfvi.sfvi03 = l_sfv.sfv03
            IF NOT s_ins_sfvi(l_sfvi.*,l_sfv.sfvplant) THEN
               LET g_success = 'N'  
            END IF
         END IF 
#FUN-B70074--add--insert--
      END IF
   END IF    
END FUNCTION
 
FUNCTION t300_w4(l_shb) #工單生產報工產生FQC(aqct411)
DEFINE l_shb       RECORD LIKE shb_file.*,
       l_qcf       RECORD LIKE qcf_file.*,
       l_ima55     LIKE ima_file.ima55,
       l_ima102    LIKE ima_file.ima102,
       l_ima100    LIKE ima_file.ima100,
       l_ima906    LIKE ima_file.ima906,
       l_ima907    LIKE ima_file.ima907,
       l_factor    LIKE ima_file.ima31_fac, 
       l_flag      LIKE type_file.num5      
DEFINE l_sgm311    LIKE sgm_file.sgm311
DEFINE l_qcf22     LIKE qcf_file.qcf22
DEFINE l_minus     LIKE sgm_file.sgm311
 
    INITIALIZE l_qcf.* TO NULL
    SELECT ima102,ima100,ima906,ima907,ima55 INTO l_ima102,l_ima100,l_ima906,l_ima907,l_ima55
      FROM ima_file
     WHERE ima01=l_shb.shb10   
 
    SELECT sgm311 INTO l_sgm311 FROM sgm_file
     WHERE sgm01 = g_shb.shb16
       AND sgm03 = g_shb.shb06
       AND sgm012 = g_shb.shb012  #FUN-A60095
    SELECT SUM(qcf22) INTO l_qcf22 FROM qcf_file
     WHERE qcf01 IS NOT NULL
       AND qcf02 = g_shb.shb05
       AND qcf03 = g_shb.shb16                        #TQC-C20479 add
       AND qcf14 = 'Y'
       AND qcf18 = '2'
    
    IF cl_null(l_sgm311) THEN 
       LET l_sgm311 = 0 
    END IF 
    IF cl_null(l_qcf22) THEN 
       LET l_qcf22 = 0
    END IF 
    IF cl_null(l_shb.shb111) THEN 
       LET l_shb.shb111 = 0 
    END IF             
     
    LET l_qcf.qcf22=0
    LET l_qcf.qcf06=0
    LET l_qcf.qcf00='1'
    LET l_qcf.qcfuser=g_user
    LET l_qcf.qcfgrup=g_grup
    LET l_qcf.qcfdate=g_today
    LET l_qcf.qcfacti='Y'              #資料有效
    LET l_qcf.qcf041=TIME              #資料有效
    LET l_qcf.qcf04=g_today            #資料有效
    LET l_qcf.qcf05=1                 
    LET l_qcf.qcf14='N'
    LET l_qcf.qcf15=''
    LET l_qcf.qcf091=0
    LET l_qcf.qcf13 = g_emp
    LET l_qcf.qcf18 = '2'
    LET l_qcf.qcf03 = l_shb.shb16
    LET l_qcf.qcf01=g_shb22          
    LET l_qcf.qcf02=l_shb.shb05      
    LET l_qcf.qcf05=1
    LET l_qcf.qcf021=l_shb.shb10                     
    LET l_qcf.qcf21=l_ima100
    LET l_qcf.qcf17=l_ima102
    LET l_qcf.qcfplant = g_plant #FUN-980008 add
    LET l_qcf.qcflegal = g_legal #FUN-980008 add
    LET l_minus = l_sgm311 - l_qcf22 
    IF l_shb.shb111 < l_minus THEN 
       LET l_qcf.qcf22 = l_shb.shb111
    ELSE
    	 LET l_qcf.qcf22 = l_minus 
    END IF  	 
    LET l_qcf.qcf06=t300_t410_defqty(1,0,l_qcf.*)   
    LET l_qcf.qcfspc = '0'
    
   CASE
      WHEN l_ima906="1"
            LET l_qcf.qcf30=l_ima55      
            LET l_qcf.qcf31=1 
            LET l_qcf.qcf32=l_shb.shb111   
            LET l_qcf.qcf33=''
            LET l_qcf.qcf34=''
            LET l_qcf.qcf35=''
      WHEN l_ima906 MATCHES '[2,3]'
            LET l_qcf.qcf30=l_ima55      
            LET l_qcf.qcf31=1
            LET l_qcf.qcf32=l_shb.shb111  
            LET l_qcf.qcf33=l_ima907
            CALL s_umfchk(l_shb.shb10,l_ima907,l_ima55) RETURNING l_flag,l_factor                                
            IF l_flag=1 THEN
              LET l_factor=1
            END IF
            LET l_qcf.qcf34=l_factor
            LET l_qcf.qcf091= l_qcf.qcf22
            LET l_qcf.qcf35 = l_qcf.qcf22 / l_factor
            LET l_qcf.qcf36 = l_qcf.qcf30
            LET l_qcf.qcf37 = l_qcf.qcf31
            LET l_qcf.qcf38 = l_qcf.qcf22 / l_qcf.qcf37
            LET l_qcf.qcf39 = l_qcf.qcf33
            LET l_qcf.qcf40 = l_qcf.qcf34
            LET l_qcf.qcf41 = l_qcf.qcf35
   END CASE 
    SELECT * INTO g_sgm.* FROM sgm_file
     WHERE sgm01=g_shb.shb16
       AND sgm03=g_shb.shb06
       AND sgm012=g_shb.shb012  #FUN-A60095
     IF STATUS THEN  #資料資料不存在
        CALL cl_err3("sel","sgm_file",g_shb.shb16,g_shb.shb06,STATUS,"","sel sgm_file",1) 
        LET g_success = 'N'
     END IF 
    IF g_success = 'Y' THEN   
      LET l_qcf.qcforiu = g_user      #No.FUN-980030 10/01/04
      LET l_qcf.qcforig = g_grup      #No.FUN-980030 10/01/04
      #FUN-BB0085-add-str---
      LET l_qcf.qcf06 = s_digqty(l_qcf.qcf06,l_ima55)
      LET l_qcf.qcf091= s_digqty(l_qcf.qcf091,l_ima55)
      LET l_qcf.qcf22 = s_digqty(l_qcf.qcf22,l_ima55)
      LET l_qcf.qcf32 = s_digqty(l_qcf.qcf32,l_qcf.qcf30)
      LET l_qcf.qcf35 = s_digqty(l_qcf.qcf35,l_qcf.qcf33)
      LET l_qcf.qcf38 = s_digqty(l_qcf.qcf38,l_qcf.qcf36)
      LET l_qcf.qcf41 = s_digqty(l_qcf.qcf41,l_qcf.qcf39) 
      #FUN-BB0085-add-end---
      INSERT INTO qcf_file VALUES (l_qcf.*)      
      IF SQLCA.sqlcode THEN
         CALL cl_err('ins qcf',STATUS,1)
         LET g_success='N'
      END IF
    END IF  
   IF g_success='Y' THEN
      CALL t300_t410_g_b(l_qcf.*)
      UPDATE shb_file SET shb22 = l_qcf.qcf01
       WHERE shb01 = l_shb.shb01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err('upd shb22',SQLCA.sqlcode,1)    
         LET g_success='N'
      ELSE
      	 LET g_shb.shb22 = l_qcf.qcf01
      	 DISPLAY BY NAME g_shb.shb22    
      END IF
   END IF  
END FUNCTION
 
FUNCTION t300_t410_defqty(l_def,l_rate,l_qcf)
   DEFINE l_def     LIKE type_file.num5,    #   1:單頭入 2.單身入 
          l_rate    LIKE qcd_file.qcd04,
          l_qcb04   LIKE qcb_file.qcb04
   DEFINE l_pmh09   LIKE pmh_file.pmh09,
          l_pmh15   LIKE pmh_file.pmh15,
          l_pmh16   LIKE pmh_file.pmh16,
          l_qca03   LIKE qca_file.qca03,
          l_qca04   LIKE qca_file.qca04,
          l_qca05   LIKE qca_file.qca05,
          l_qca06   LIKE qca_file.qca06
   DEFINE l_qcf     RECORD LIKE qcf_file.*
 
   SELECT ima100,ima101,ima102
     INTO l_pmh09,l_pmh15,l_pmh16
     FROM ima_file
    WHERE ima01 = l_qcf.qcf021
 
   IF STATUS THEN
      LET l_pmh09 = ''
      LET l_pmh15 = ''
      LET l_pmh16 = ''
      RETURN 0
   END IF
 
   IF l_pmh09 IS NULL OR l_pmh09 = ' ' THEN
      RETURN 0
   END IF
 
   IF l_pmh15 IS NULL OR l_pmh15 = ' ' THEN
      RETURN 0
   END IF
 
   IF l_pmh16 IS NULL OR l_pmh16 = ' ' THEN
      RETURN 0
   END IF
 
   IF l_pmh15 = '1' THEN
     IF l_def = '1' THEN
         SELECT qca03,qca04,qca05,qca06
           INTO l_qca03,l_qca04,l_qca05,l_qca06
           FROM qca_file
     #    WHERE l_qcf22 BETWEEN qca01 AND qca02          #TQC-C90043 
          WHERE l_qcf.qcf22 BETWEEN qca01 AND qca02      #TQC-C90043 
            AND qca07 = l_qcf.qcf17
         IF STATUS THEN
            RETURN 0
         END IF
      ELSE
         SELECT qcb04 INTO l_qcb04 FROM qcb_file,qca_file
    #     WHERE (l_qcf22 BETWEEN qca01 AND qca02)        #TQC-C90043
          WHERE (l_qcf.qcf22 BETWEEN qca01 AND qca02)        #TQC-C90043
            AND qcb02 = l_rate
            AND qca03 = qcb03
            AND qca07 = l_qcf.qcf17
            AND qcb01 = l_qcf.qcf21
         IF NOT cl_null(l_qcb04) THEN
            SELECT UNIQUE qca03,qca04,qca05,qca06  
              INTO l_qca03,l_qca04,l_qca05,l_qca06
              FROM qca_file
             WHERE qca03 = l_qcb04
               AND qca07 = l_qcf.qcf17
            IF STATUS THEN
               LET l_qca03 = 0
               LET l_qca04 = 0
               LET l_qca05 = 0
               LET l_qca06 = 0
            END IF
          END IF
      END IF
   END IF
 
   IF l_pmh15='2' THEN
      IF l_def = '1' THEN
         SELECT qch03,qch04,qch05,qch06
           INTO l_qca03,l_qca04,l_qca05,l_qca06
           FROM qch_file
       #  WHERE l_qcf22 BETWEEN qch01 AND qch02         #TQC-C90043 
          WHERE l_qcf.qcf22 BETWEEN qch01 AND qch02     #TQC-C90043 
            AND qch07 = l_qcf.qcf17
         IF STATUS THEN
            RETURN 0
         END IF
      ELSE
         SELECT qcb04 INTO l_qcb04 FROM qcb_file,qch_file
       #  WHERE (l_qcf22 BETWEEN qch01 AND qch02)        #TQC-C90043  
          WHERE (l_qcf.qcf22 BETWEEN qch01 AND qch02)    #TQC-C90043  
            AND qcb02 = l_rate
            AND qch03 = qcb03
            AND qch07 = l_qcf.qcf17
            AND qcb01 = l_qcf.qcf21
      
        IF NOT cl_null(l_qcb04) THEN
            SELECT UNIQUE qch03,qch04,qch05,qch06      
              INTO l_qca03,l_qca04,l_qca05,l_qca06
              FROM qch_file
             WHERE qch03 = l_qcb04
               AND qch07 = l_qcf.qcf17
            IF STATUS THEN
               LET l_qca03 = 0
               LET l_qca04 = 0
               LET l_qca05 = 0
               LET l_qca06 = 0
            END IF
          END IF
      END IF
   END IF
 
   CASE l_pmh09
      WHEN 'N'
         RETURN l_qca04
      WHEN 'T'
         RETURN l_qca05
      WHEN 'R'
         RETURN l_qca06
      OTHERWISE
         RETURN 0
   END CASE
END FUNCTION
 
FUNCTION t300_t410_g_b(l_qcf)
   DEFINE l_qcf    RECORD LIKE qcf_file.*
   DEFINE l_cnt    LIKE type_file.num5              
   DEFINE l_yn     LIKE type_file.num5             
   DEFINE l_qcd    RECORD LIKE qcd_file.*
   DEFINE l_qcg11  LIKE qcg_file.qcg11
   DEFINE seq      LIKE type_file.num5              
   DEFINE l_ac_num,l_re_num  LIKE type_file.num5    
 
   LET seq=1
 
   SELECT COUNT(*) INTO l_cnt FROM qcg_file
    WHERE qcg01 = l_qcf.qcf01
 
   IF l_cnt = 0 THEN 
      SELECT COUNT(*) INTO l_yn FROM qcd_file
       WHERE qcd01=l_qcf.qcf021
         AND qcd08 IN ('2','9')            
      IF l_yn > 0 THEN  #--- 料件檢驗項目
         DECLARE qcd_cur2 CURSOR FOR SELECT * FROM qcd_file
                                     WHERE qcd01 = l_qcf.qcf021
                                       AND qcd08 IN ('2','9')             
                                     ORDER BY qcd02
 
         FOREACH qcd_cur2 INTO l_qcd.*
            IF l_qcd.qcd05='1' THEN
               #-------- Ac,Re 數量賦予
               CALL s_newaql(l_qcf.qcf021,' ',l_qcd.qcd04,l_qcf.qcf22,' ','1')  
                        RETURNING l_ac_num,l_re_num
               CALL t300_t410_defqty(2,l_qcd.qcd04,l_qcf.*)
                    RETURNING l_qcg11
            ELSE
               LET l_ac_num=0 LET l_re_num=1
               SELECT qcj05 INTO l_qcg11
                 FROM qcj_file
                WHERE (l_qcf.qcf22 BETWEEN qcj01 AND qcj02)
                  AND qcj03 = l_qcd.qcd04
               IF STATUS THEN
                  LET l_qcg11 = 0
               END IF
            END IF
 
            IF l_qcg11 > l_qcf.qcf22 THEN
               LET l_qcg11 = l_qcf.qcf22
            END IF
 
            IF cl_null(l_qcg11) THEN
               LET l_qcg11 = 0
            END IF
 
            INSERT INTO qcg_file (qcg01,qcg03,qcg04,qcg05,qcg06,qcg07, 
                                  qcg08,qcg09,qcg10,qcg11,qcg12,qcg131,qcg132,
                                  qcgplant,qcglegal) #FUN-980008 add
                 VALUES(l_qcf.qcf01,seq,l_qcd.qcd02,l_qcd.qcd03,l_qcd.qcd04,
                        0,'1',l_ac_num,l_re_num,l_qcg11,l_qcd.qcd05,
                        l_qcd.qcd061,l_qcd.qcd062,
                        g_plant,g_legal) #FUN-980008 add
            LET seq=seq+1
         END FOREACH
      ELSE            #--- 材料類別檢驗項目
         DECLARE qck_cur2 CURSOR FOR SELECT qck_file.*
                                      FROM qck_file,ima_file
                                     WHERE qck01 = ima109
                                       AND ima01 = l_qcf.qcf021
                                       AND qck08 IN ('2','9')           
                                     ORDER BY qck02
 
         FOREACH qck_cur2 INTO l_qcd.*
            IF l_qcd.qcd05='1' THEN
               #-------- Ac,Re 數量賦予
               CALL s_newaql(l_qcf.qcf021,' ',l_qcd.qcd04,l_qcf.qcf22,' ','1')  
                    RETURNING l_ac_num,l_re_num
               CALL t300_t410_defqty(2,l_qcd.qcd04,l_qcf.*)
                    RETURNING l_qcg11
            ELSE
               LET l_ac_num=0 LET l_re_num=1
               SELECT qcj05 INTO l_qcg11
                 FROM qcj_file
                WHERE (l_qcf.qcf22 BETWEEN qcj01 AND qcj02)
                  AND qcj03=l_qcd.qcd04
               IF STATUS THEN LET l_qcg11=0 END IF
            END IF
 
            IF l_qcg11 > l_qcf.qcf22 THEN
               LET l_qcg11 = l_qcf.qcf22
            END IF
 
            IF cl_null(l_qcg11) THEN
               LET l_qcg11 = 0
            END IF
 
            INSERT INTO qcg_file (qcg01,qcg03,qcg04,qcg05,qcg06,qcg07, 
                                  qcg08,qcg09,qcg10,qcg11,qcg12,qcg131,qcg132,
                                  qcgplant,qcglegal) #FUN-980008 add
                 VALUES(l_qcf.qcf01,seq,l_qcd.qcd02,l_qcd.qcd03,l_qcd.qcd04,
                        0,'1',l_ac_num,l_re_num,l_qcg11,l_qcd.qcd05,
                        l_qcd.qcd061,l_qcd.qcd062,
                        g_plant,g_legal) #FUN-980008 add
 
            LET seq = seq+1
         END FOREACH
      END IF
   END IF
 
END FUNCTION
 
#FUN-A60095--begin--add----------
FUNCTION t730_chk_shb12()
DEFINE l_sfb93   LIKE sfb_file.sfb93

  LET l_sfb93 = ''
  SELECT sfb93 INTO l_sfb93 FROM sfb_file WHERE sfb01=g_shb.shb05
  LET g_success='Y'
  IF g_sma.sma541 ='Y' AND l_sfb93='Y' THEN
     IF NOT cl_null(g_shb.shb121) AND NOT cl_null(g_shb.shb12) THEN
        IF g_shb.shb121=g_shb.shb012 AND  
           g_shb.shb12=g_shb.shb06 THEN
           CALL cl_err(g_shb.shb12,'aec-086',0)
           LET g_success='N' RETURN
        END IF
        ## 檢查是否有此下製程
        SELECT count(*) INTO g_cnt FROM sgm_file
         WHERE sgm01 = g_shb.shb16
           AND sgm03 = g_shb.shb12
           AND sgm012 = g_shb.shb121
        IF g_cnt = 0  THEN
           CALL cl_err(g_shb.shb12,'aec-085',0)
           LET g_shb.shb12 = g_shb_t.shb12
           DISPLAY BY NAME g_shb.shb12
           LET g_success='N' RETURN
        END IF
     END IF
 ELSE
    IF NOT cl_null(g_shb.shb12) THEN
       IF g_shb.shb12=g_shb.shb06 THEN
           CALL cl_err(g_shb.shb12,'aec-086',0)
           LET g_success='N' RETURN
        END IF
        ## 檢查是否有此下製程
        SELECT count(*) INTO g_cnt FROM sgm_file
         WHERE sgm01 = g_shb.shb16
           AND sgm03 = g_shb.shb12
           AND sgm012 =' '  
        IF g_cnt = 0  THEN
           CALL cl_err(g_shb.shb12,'aec-085',0)
           LET g_shb.shb12 = g_shb_t.shb12
           DISPLAY BY NAME g_shb.shb12
           LET g_success='N' RETURN
        END IF
    END IF
END IF
END FUNCTION

FUNCTION t730_shb012(p_cmd)  
    DEFINE l_ecu014    LIKE ecu_file.ecu014,
           l_ecuacti   LIKE ecu_file.ecuacti,
           l_sfb06     LIKE sfb_file.sfb06,
           p_cmd      LIKE type_file.chr1 
    DEFINE l_sfb05     LIKE sfb_file.sfb05          #TQC-AC0374  add
    DEFINE l_flag      LIKE type_file.num5          #TQC-AC0374  add
 
    LET g_errno = ' '    
    SELECT sfb06 INTO l_sfb06 FROM sfb_file WHERE sfb01=g_shb.shb05
    CALL s_schdat_sel_ima571(g_shb.shb05) RETURNING l_flag,l_sfb05    #TQC-AC0374 add
    
    LET l_ecu014=''  LET l_ecuacti=''
   #FUN-B10056 ----------mod start------------
   ##TQC-AC0374-----begin-------
   ##SELECT ecu014,ecuacti INTO l_ecu014,l_ecuacti   
   ##  FROM ecu_file WHERE ecu01 = g_shb.shb10  
   ##   AND ecu012=g_shb.shb012 AND ecu02=l_sfb06
   #SELECT ecu014,ecuacti INTO l_ecu014,l_ecuacti
   #  FROM ecu_file WHERE ecu01 = l_sfb05  
   #   AND ecu012=g_shb.shb012 AND ecu02=l_sfb06               
   ##TQC-AC0374-----end---------
   #
   #CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abm-214'
   #                        LET l_ecu014 = NULL
   #     WHEN l_ecuacti='N' LET g_errno = '9028'
   #     OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   #END CASE
    IF NOT s_runcard_sgm012(g_shb.shb16,g_shb.shb012) THEN
       LET g_errno = 'abm-214'
       LET l_ecu014 = NULL
    END IF      
   #FUN-B10056 ----------mod end-----------------
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       CALL s_runcard_sgm014(g_shb.shb16,g_shb.shb012) RETURNING l_ecu014       #FUN-B10056 
       DISPLAY l_ecu014 TO FORMONLY.ecu014
    END IF

END FUNCTION

FUNCTION t730_shb082(p_cmd)  
    DEFINE l_ecu014    LIKE ecu_file.ecu014,
           l_ecuacti   LIKE ecu_file.ecuacti,
           l_sfb06     LIKE sfb_file.sfb06,
           p_cmd      LIKE type_file.chr1   
    IF NOT cl_null(g_shb.shb012) AND NOT cl_null(g_shb.shb06) THEN
       SELECT sgm04,sgm45 INTO g_shb.shb081,g_shb.shb082 FROM sgm_file
        WHERE sgm01=g_shb.shb16
          AND sgm03=g_shb.shb06
          AND sgm012=g_shb.shb012
        CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aec-099'
                                       LET g_shb.shb081 = NULL
                                       LET g_shb.shb082 = NULL
             OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
        END CASE
        IF cl_null(g_errno) OR p_cmd = 'd' THEN
           DISPLAY BY NAME g_shb.shb081
           DISPLAY BY NAME g_shb.shb082
        END IF
    END IF 
END FUNCTION

FUNCTION t700_shc06()
    LET g_errno = ''
    IF NOT cl_null(g_shc[l_ac].shc06) AND g_shc[l_ac].shc012 IS NOT NULL THEN
       SELECT sgm04 INTO g_shc[l_ac].sgm04 FROM sgm_file
        WHERE sgm01=g_shb.shb16 AND sgm03 = g_shc[l_ac].shc06
          AND sgm012=g_shc[l_ac].shc012
       IF SQLCA.SQLCODE THEN
          LET g_errno = SQLCA.SQLCODE USING '-------'
          RETURN
       END IF
      #MOD-D60240 add begin-------------------
       IF g_sma.sma541 = 'N' THEN
          IF g_shc[l_ac].shc06 > g_shb.shb06 THEN
             LET g_errno = 'asf1052'
             RETURN
          END IF
       ELSE
          IF g_shc[l_ac].shc012 = g_shb.shb012 THEN
             IF g_shc[l_ac].shc06 > g_shb.shb06 THEN
                LET g_errno = 'asf1052'
                RETURN
             END IF
          ELSE
             IF NOT t730_shc012(g_shb.shb012) THEN
                LET g_errno = 'asf1053'
                RETURN
             END IF
          END IF
       END IF
      #MOD-D60240 add end---------------------
    END IF
END FUNCTION

#MOD-D60240 add begin-------------------
FUNCTION t730_shc012(p_ecm012)
DEFINE p_ecm012 LIKE ecm_file.ecm012
DEFINE l_ecm011 LIKE ecm_file.ecm011
DEFINE l_flag   BOOLEAN
   SELECT UNIQUE ecm011 INTO l_ecm011 FROM ecm_file
    WHERE ecm01=g_shb.shb05 AND ecm012=p_ecm012
   IF cl_null(l_ecm011) THEN
      RETURN 0
   ELSE
      IF l_ecm011 = g_shc[l_ac].shc012 THEN
         RETURN 1
      ELSE
         CALL t730_shc012(l_ecm011) RETURNING l_flag
      END IF
   END IF
   RETURN l_flag
END FUNCTION
#MOD-D60240 add end---------------------

FUNCTION t730_shb111_a()
DEFINE l_ima153     LIKE ima_file.ima153
DEFINE l_ecm62      LIKE ecm_file.ecm62  #TQC-B20083
DEFINE l_ecm63      LIKE ecm_file.ecm63  #TQC-B20083

    LET g_success = 'Y'
    IF cl_null(g_shb.shb012) THEN LET g_shb.shb012=' ' END IF #FUN-A60095
    CALL s_get_ima153(g_shb.shb10) RETURNING l_ima153 
   #CALL s_minp(g_shb.shb05,g_sma.sma73,l_ima153,g_shb.shb081,g_shb.shb012,g_shb.shb06)   #TQC-B20083
    CALL s_minp_routing(g_shb.shb05,g_sma.sma73,l_ima153,g_shb.shb081,g_shb.shb012,g_shb.shb06)  #TQC-B20083
    RETURNING g_cnt,g_min_set
    IF g_cnt !=0  THEN
       CALL cl_err(g_shb.shb05,'asf-549',1)
       LET g_success='N' RETURN
    END IF
    #TQC-B20083(S)
    SELECT ecm62,ecm63 INTO l_ecm62,l_ecm63 FROM ecm_file
     WHERE ecm01=g_shb.shb05 AND ecm03=g_shb.shb06
       AND ecm012=g_shb.shb012
    IF cl_null(l_ecm62) OR l_ecm62=0 THEN
       LET l_ecm62=1
    END IF
    IF cl_null(l_ecm63) OR l_ecm63=0 THEN
       LET l_ecm63=1
    END IF
    #TQC-B20083(E)
   #IF g_shb.shb111 > g_min_set THEN   #TQC-B20083
    IF g_shb.shb111 > g_min_set*l_ecm62/l_ecm63 THEN #TQC-B20083
       CALL cl_err(g_shb.shb05,'asf-670',1)
       LET g_success='N' RETURN
    END IF
END FUNCTION
#FUN-A60095--end--add-----------------
#NO.FUN-9C0072 精簡程式碼

#FUN-A80102(S)
FUNCTION t730_shb081_relation()
   DEFINE l_flag LIKE type_file.num5

   CALL t730sub_shb081(g_shb.*,g_sgm.*,g_shb_t.*) RETURNING l_flag,g_shb.*,g_sgm.*
   DISPLAY BY NAME g_shb.shb06 ,g_shb.shb09,
                   g_shb.shb081,g_shb.shb082,g_shb.shb07
   DISPLAY BY NAME g_shb.shb31,g_shb.shb26
   RETURN l_flag
END FUNCTION
#FUN-A80102(E)

#TQC-AC0294-------start------------
FUNCTION t730_shb21()      
   DEFINE l_smy73   LIKE smy_file.smy73
 
   LET g_errno = ' '
   IF cl_null(g_t2) THEN RETURN END IF
    
   SELECT smy73 INTO l_smy73 FROM smy_file
    WHERE smyslip = g_t2
   IF l_smy73 = 'Y' THEN
      LET g_errno = 'asf-876'
   END IF

END FUNCTION
#TQC-AC0294--------end----------------

#str-----add by guanyao160903
FUNCTION t730_gy_pro()
DEFINE l_sql,l_sql1    STRING 
DEFINE l_tc_shb02      LIKE tc_shb_file.tc_shb02
DEFINE l_tc_shb03      LIKE tc_shb_file.tc_shb03
DEFINE l_tc_shb06      LIKE tc_shb_file.tc_shb06
DEFINE l_tc_shb12      LIKE tc_shb_file.tc_shb12
DEFINE l_tc_shb12_a    LIKE tc_shb_file.tc_shb12
DEFINE l_success       LIKE type_file.chr1
DEFINE sr      RECORD 
        tc_shb02       LIKE tc_shb_file.tc_shb02,
        tc_shb03       LIKE tc_shb_file.tc_shb03,
        tc_shb06       LIKE tc_shb_file.tc_shb06,
        tc_shb12       LIKE tc_shb_file.tc_shb12
   END RECORD 

     LET l_success = 'Y'
     BEGIN WORK 
     LET l_sql =" SELECT tc_shb02,tc_shb03,tc_shb06,tc_shb12 ",
                "   FROM tc_shb_file ",
                "  WHERE tc_shbud02 IS NULL ",
                "    AND tc_shb01 = '2' ",
                "    AND tc_shb14>to_date('16/08/30','yy/mm/dd')",
                "  ORDER BY tc_shb02,tc_shb03,tc_shb06"
     PREPARE tc_shb_p FROM l_sql
     DECLARE tc_shb_c CURSOR WITH HOLD  FOR tc_shb_p
     FOREACH tc_shb_c INTO l_tc_shb02,l_tc_shb03,l_tc_shb06,l_tc_shb12 
      
        LET l_sql1 = "SELECT tc_shb02,tc_shb03,tc_shb06,tc_shb12 ",
                     "  FROM tc_shb_file ",
                     " WHERE tc_shb03 = '",l_tc_shb03,"'",
                     "   AND tc_shb06 = '",l_tc_shb06,"'",
                     "   AND tc_shb01 = '1' ",
                     " ORDER BY tc_shb02,tc_shb03,tc_shb06"
        PREPARE tc_shb_p1 FROM l_sql1
        DECLARE tc_shb_c1 CURSOR WITH HOLD FOR tc_shb_p1
        FOREACH tc_shb_c1 INTO sr.tc_shb02,sr.tc_shb03,sr.tc_shb06,sr.tc_shb12 
           LET l_tc_shb12_a = 0
           SELECT SUM(tc_shb12) INTO l_tc_shb12_a FROM tc_shb_file WHERE tc_shbud02 = sr.tc_shb02
           IF cl_null(l_tc_shb12_a) OR (l_tc_shb12_a+l_tc_shb02) <sr.tc_shb12  THEN 
              UPDATE tc_shb_file SET tc_shbud02 = sr.tc_shb02 WHERE tc_shb02 = l_tc_shb02
              IF sqlca.sqlcode THEN 
                 LET l_success = 'N'
                 EXIT FOREACH 
              END IF 
              EXIT FOREACH 
           ELSE 
              CONTINUE FOREACH 
           END IF 
        END FOREACH 
     END FOREACH 
     IF l_success = 'Y' THEN 
        COMMIT WORK 
        MESSAGE "成功"
     ELSE 
        ROLLBACK WORK 
        MESSAGE "失败"
     END IF 
    
     
END FUNCTION 
 
#end-----add by guanyao160903
