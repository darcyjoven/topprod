# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: aqct510.4gl
# Descriptions...: PQC 品質記錄維護作業
# Date & Author..: 99/05/11 By Melody
# Modify.........: No:7637 03/03/19 By Mandy 在FUNCTION t510_ii()中多了一行 INPUT,導致合格欄位代碼無法show出.
# Modify.........: No:7710 03/08/06 By Mandy 不良數量應 <= 檢驗量。
# Modify.........: No:7857 03/08/20 By Mandy  呼叫自動取單號時應在 Transction中
# Modify.........: No.MOD-470041 04/07/22 By Nicola 修改INSERT INTO 語法
# Modify ........: No.MOD-480059 04/08/26 By Nicola 如果是合格應該就不能做特材了
# Modify ........: No.MOD-490371 04/09/22 By Melody controlp ...display修改
# Modify.........: No.MOD-4A0248 04/10/19 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0038 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-520016 05/02/16 By Melody 合格量不可大於送驗量
# Modify.........: No.MOD-530670 05/03/29 By Mandy 有二項檢驗項目,第一項需維護測量值,其不良數為1,但到第二項之後,馬上點第一項之不良數量欄位,其值會被改變為0
# Modify.........: NO.FUN-550063 05/05/19 By jackie 單據編號加大
# Modify.........: No.FUN-570109 05/07/15 By vivien KEY值更改控制
# Modify.........: No.BUG-580011 05/08/24 By Nicola 修改MOD-4B0139修改點
# Modify.........: No.FUN-5B0136 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.TQC-610007 06/01/06 By Nicola 接收ze值的欄位型能改為LIKE
# Modify.........: No.FUN-630016 06/03/07 By ching  ADD p_flow功能
# Modify.........: No.MOD-640316 06/04/010 By pengu 1單頭輸入時,應先輸入製程序,才輸入送驗量,這樣可以自動帶出送驗量
                           #                        2輸入完後馬上按刪除單據要按二次才會刪除成功
# Modify.........: No.FUN-660115 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680010 06/09/08 by Joe SPC整合專案-自動新增 QC 單據
# Modify.........: No.FUN-680104 06/09/19 By czl 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0160 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0032 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6A0015 06/12/13 By pengu 選擇自行輸入,無法帶出料件之檢驗項目 
# Modify.........: No.CHI-6C0045 07/01/05 By rainy 送驗量=0時不可確認 
# Modify.........: No.MOD-710114 07/01/19 By jamie 針對送驗量的計算,只扣除尚未確認的PQC單(沒有扣除已確認的PQC單),
#                                                  會造成同樣的送驗量重複KEY單及確認
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-730130 07/03/28 By pengu 如判定為重工合格量應default為0
# Modify.........: No.TQC-740048 07/04/10 By pengu 不應該可以修改合格量，若要修改合格量時應該透過"特採"功能做修改
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-740116 07/06/07 By pengu 取到調整樣本後,再回對樣本字號時,毋需考慮級數
#                                                  當送驗量(qcf22)為 1 時, defqty() 應 return 1 毋需再比對 105E表
# Modify.........: No.CHI-740037 07/06/07 By pengu 單身判定結果為合格時應將缺點數乘上CR/MA/MI權數
# Modify.........: No.TQC-750209 07/06/07 By pengu 修正zl單CHI-740037的寫法
# Modify.........: No.TQC-750064 07/06/11 By pengu 拿掉單頭[檢驗量]欄位
# Modify.........: No.MOD-780149 07/08/21 By pengu 若判合格則單頭的合格量應與送驗量一致
# Modify.........: No.MOD-7C0061 07/12/10 By Pengu 在b_fill()中不應該在去呼叫s_newaql()
# Modify.........: No.MOD-7C0145 07/12/25 By Pengu 若單頭送驗量包含小數時會造成單身檢驗量為0
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-820049 08/02/14 By Pengu 檢驗方式為C=0時其推算抽驗量應考慮級數
# Modify.........: No.MOD-820021 08/02/14 By Pengu 送驗量應該扣除特採數量
# Modify.........: No.TQC-820019 08/02/25 By Carol 調整CALL cl_set_comp_visible()傳入的action名稱
# Modify.........: No.MOD-830124 08/03/19 By Pengu 調整MOD-820021
# Modify.........: No.MOD-840059 08/04/08 By Pengu 分批檢驗時送驗量default會異常
# Modify.........: No.FUN-840068 08/04/23 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.FUN-830110 08/06/27 By sherry 增加 參考asft700 輸入工單號碼后 asf-018 檢查段
# Modify.........: No.MOD-880246 08/08/28 By claire 單身雙擊二次,無法進入單身
# Modify.........: No.MOD-890154 08/09/18 By Pengu 調整FUN-680010寫法
# Modify.........: No.MOD-890223 08/09/23 By claire s_newaql加傳入pmh21,pmh22
# Modify.........: No.MOD-8A0131 08/10/15 By claire 資料重新查詢時,不應重取qcf17,qcf21
# Modify.........: No.MOD-8A0159 08/10/17 By liuxqa 進入單身,如果修改缺點數大于零,此時應該彈出對話框輸入缺點明細.
# Modify.........: No.MOD-8B0074 08/11/06 By claire 調整邏輯
# Modify.........: No.MOD-8C0206 08/12/22 By claire 當送驗量為0直接按確定,程式並未卡關:
# Modify.........: No.TQC-910004 09/01/05 By claire 分批檢驗時送驗量default會異常
# Modify.........: No.FUN-910079 09/02/20 By ve007 增加品管類型的邏輯
# Modify.........: No.TQC-960402 09/06/26 By lilingyu 修改工藝序為開窗按鈕
# Modify.........: No.FUN-980007 09/08/13 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980140 09/08/19 By Smapmin SQL語法錯誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990071 09/09/23 By chenmoyan 增加料件編號為'*'的情況
# Modify.........: No:MOD-9B0024 09/11/06 By Pengu 單身不允許新增
# Modify.........: No:TQC-9C0092 09/12/11 By Carrier 自行录入时,判定结果无法update至DB
# Modify.........: No:FUN-9C0071 10/01/13 By huangrh 精簡程式
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:CHI-A30031 10/04/14 By Summer 合格資料不能修改送驗量
# Modify.........: No.FUN-A60027 10/06/21 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.TQC-A60094 10/06/24 By houlia 單頭加上製程段號qcm012
# Modify.........: No.FUN-A80063 10/08/18 By wujie  品质管理功能改善修改
# Modify.........: No.TQC-A90055 10/09/29 By destiny 不走平行工艺时不显示工艺序字段
# Modify.........: No.FUN-AA0059 10/10/27 By huangtao 修改料號的管控
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No:FUN-A30045 10/11/15 By lixh1 新增Action"取消特採"
# Modify.........: No.TQC-AB0278 10/11/29 By jan qcm012給預設值
# Modify.........: No.TQC-AB0332 10/12/06 By jan 取消審核時檢查若合格量<已報工量,則不可取消審核
# Modify.........: No.FUN-B10056 11/02/12 By vealxu 修改制程段號的管控
# Modify.........: No.FUN-940103 11/05/10 By lixiang 增加規格顯示欄位
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No.TQC-B60148 11/06/16 By jan解決程式会出现btn_05到btn_20的多余按钮的問題
# Modify.........: No.FUN-B80066 11/08/05 By xuxz  AQC模組程序撰寫規範修正
# Modify.........: No.TQC-B80258 11/08/31 By lilingyu 單頭狀態頁簽,有欄位不可下查詢條件
# Modify.........: No:CHI-BC0018 11/12/15 By ck2yuan qcm17欄位帶出後面說明欄位
# Modify.........: No:FUN-BC0104 11/12/30 By lixh1 增加數量欄位小數取位
# Modify.........: No:MOD-BB0314 12/02/17 By bart 計算送驗量時應扣除當站報廢數量
# Modfiy.........: No.TQC-C20504 12/02/27 By xianghui 確認時要檢查QC料件維護的數量要等於QC單的送驗量
# Modfiy.........: No.TQC-C20524 12/02/28 By xianghui 回寫的合格量沒有及時顯示
# Modify.........: No.TQC-C30139 12/03/09 By xianghui qck09='N'時給出相應的提示信息
# Modify.........: NO.MOD-C30619 12/03/12 By fengrui RUN CARD工單提示運行aqct511作業走RUN CARD PQC檢驗
# Modify.........: No.MOD-C30557 12/03/13 By xianghui 確認時添加QC料件判定維護合格量的回寫
# Modify.........: No.MOD-C30634 12/03/16 By fengrui 取消不良數量小於等於檢驗量的控管
# Modify.........: No:FUN-C30231 12/03/19 By zhangll qcm22控管時增加考慮關鍵工序報工的功能
# Modify.........: No:MOD-C40055 12/04/10 By destiny qcm22不能超过齐料套数
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C30085 12/07/06 By lixiang 改CR報表串GR報表
# Modify.........: No:MOD-C70114 12/07/19 By ck2yuan 抓是否輸入測量值的選項,順序為qcc07->qcd07->qck07
# Modify.........: No:MOD-CB0183 12/11/20 By suncx 如果工單備料中無作業編號為空或無對應當前PQC作業編號的料件，則無需進行齐料套数的管控
# Modify.........: No:MOD-CB0153 12/11/23 By Elise 單身檢驗量不可輸入大於送驗量
# Modify.........: No.CHI-C80041 12/11/27 By bart 取消單頭資料控制
# Modify.........: No.FUN-C30163 12/12/27 By pauline 製程序開窗增加顯示待驗量欄位
# Modify.........: No.FUN-CC0013 13/01/11 By Lori aqci106移除性質3.驗退/重工(qcl05=3)選項
# Modify.........: No:FUN-D20025 13/02/21 By chenying 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.CHI-C80072 13/03/26 By fengrui 統一確認和取消確認時確認人員和確認日期的寫法
# Modify.........: No.MOD-D60233 13/06/28 By fengmy 帶出送驗量時未區分工藝段號

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_qcm           RECORD LIKE qcm_file.*,
    g_qcm_t         RECORD LIKE qcm_file.*,
    g_qcm_o         RECORD LIKE qcm_file.*,
    g_qcm22         LIKE qcm_file.qcm22,        #No.FUN-680104 DEC(12,0)  #bugno:7196
    g_qcm01_t       LIKE qcm_file.qcm01,
    g_qcn           DYNAMIC ARRAY OF RECORD
        qcn03       LIKE qcn_file.qcn03,
        qcn04       LIKE qcn_file.qcn04,
        azf03_1     LIKE azf_file.azf03,
        qcn05       LIKE qcn_file.qcn05,
        qcn06       LIKE qcn_file.qcn06,
        qcn09       LIKE qcn_file.qcn09,
        qcn10       LIKE qcn_file.qcn10,
#No.FUN-A80063 --begin
        qcn14       LIKE qcn_file.qcn14,
        qcn15       LIKE qcn_file.qcn15,
#No.FUN-A80063 --end
        qcn11       LIKE qcn_file.qcn11,
        qcn07       LIKE qcn_file.qcn07,
        qcn08       LIKE qcn_file.qcn08,
        qcn08_desc  LIKE ze_file.ze03    #No.TQC-610007
       ,qcnud01     LIKE qcn_file.qcnud01,
        qcnud02     LIKE qcn_file.qcnud02,
        qcnud03     LIKE qcn_file.qcnud03,
        qcnud04     LIKE qcn_file.qcnud04,
        qcnud05     LIKE qcn_file.qcnud05,
        qcnud06     LIKE qcn_file.qcnud06,
        qcnud07     LIKE qcn_file.qcnud07,
        qcnud08     LIKE qcn_file.qcnud08,
        qcnud09     LIKE qcn_file.qcnud09,
        qcnud10     LIKE qcn_file.qcnud10,
        qcnud11     LIKE qcn_file.qcnud11,
        qcnud12     LIKE qcn_file.qcnud12,
        qcnud13     LIKE qcn_file.qcnud13,
        qcnud14     LIKE qcn_file.qcnud14,
        qcnud15     LIKE qcn_file.qcnud15
                    END RECORD,
    g_qcn_t         RECORD
        qcn03       LIKE qcn_file.qcn03,
        qcn04       LIKE qcn_file.qcn04,
        azf03_1     LIKE azf_file.azf03,
        qcn05       LIKE qcn_file.qcn05,
        qcn06       LIKE qcn_file.qcn06,
        qcn09       LIKE qcn_file.qcn09,
        qcn10       LIKE qcn_file.qcn10,
#No.FUN-A80063 --begin
        qcn14       LIKE qcn_file.qcn14,
        qcn15       LIKE qcn_file.qcn15,
#No.FUN-A80063 --end
        qcn11       LIKE qcn_file.qcn11,
        qcn07       LIKE qcn_file.qcn07,
        qcn08       LIKE qcn_file.qcn08,
        qcn08_desc  LIKE ze_file.ze03    #No.TQC-610007
       ,qcnud01     LIKE qcn_file.qcnud01,
        qcnud02     LIKE qcn_file.qcnud02,
        qcnud03     LIKE qcn_file.qcnud03,
        qcnud04     LIKE qcn_file.qcnud04,
        qcnud05     LIKE qcn_file.qcnud05,
        qcnud06     LIKE qcn_file.qcnud06,
        qcnud07     LIKE qcn_file.qcnud07,
        qcnud08     LIKE qcn_file.qcnud08,
        qcnud09     LIKE qcn_file.qcnud09,
        qcnud10     LIKE qcn_file.qcnud10,
        qcnud11     LIKE qcn_file.qcnud11,
        qcnud12     LIKE qcn_file.qcnud12,
        qcnud13     LIKE qcn_file.qcnud13,
        qcnud14     LIKE qcn_file.qcnud14,
        qcnud15     LIKE qcn_file.qcnud15
                    END RECORD,
    g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-680104 SMALLINT
    g_void          LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(01)
    l_cmd           LIKE type_file.chr1000, #No.FUN-680104 VARCHAR(300)
    l_wc            LIKE type_file.chr1000, #No.FUN-680104 VARCHAR(300)
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680104 SMALLINT
 
DEFINE
    g_t1            LIKE oay_file.oayslip,    #No.FUN-550063  #No.FUN-680104 VARCHAR(05)
    m_gen02         LIKE gen_file.gen02,
    m_ima109        LIKE ima_file.ima109,     #No.FUN-680104 VARCHAR(4)
    qcm21_desc      LIKE ze_file.ze03,   #No.TQC-610007
    qcm17_desc       LIKE gae_file.gae04,         #CHI-BC0018
    des1,des2       LIKE ze_file.ze03,   #No.TQC-610007
    ma_num1,ma_num2,mi_num1,mi_num2 LIKE type_file.num10,        #No.FUN-680104 INTEGER
    g_max_qcm22     LIKE qcm_file.qcm22,        #No.FUN-680104 DEC(12,0)
    g_min_set       LIKE sfb_file.sfb08,
    un_post_qty     LIKE qcm_file.qcm22,        #No.FUN-680104 DEC(15,5)
    g_sfb39         LIKE sfb_file.sfb39,
    g_ecm           RECORD LIKE ecm_file.*
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5    #No.FUN-680104 SMALLINT
DEFINE g_chr                 LIKE type_file.chr1    #No.FUN-680104 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10   #No.FUN-680104 INTEGER
DEFINE g_i                   LIKE type_file.num5     #count/index for any purpose  #No.FUN-680104 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000 #No.FUN-680104 VARCHAR(72)
DEFINE g_row_count           LIKE type_file.num10   #No.FUN-680104 INTEGER
DEFINE g_curs_index          LIKE type_file.num10   #No.FUN-680104 INTEGER
DEFINE g_jump                LIKE type_file.num10   #No.FUN-680104 INTEGER
DEFINE mi_no_ask             LIKE type_file.num5    #No.FUN-680104 SMALLINT
DEFINE g_argv1               LIKE qcm_file.qcm01    #No.FUN-680104 VARCHAR(16) #No.FUN-4A0081
DEFINE g_argv2               STRING              #No.FUN-4A0081
DEFINE g_ima101              LIKE ima_file.ima101  #No.FUN-A80063

 
MAIN
DEFINE
    p_row,p_col   LIKE type_file.num5    #No.FUN-680104 SMALLINT
 
    IF FGL_GETENV("FGLGUI") <> "0" THEN
       OPTIONS                                #改變一些系統預設值
          INPUT NO WRAP
    END IF 
 
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
    
    WHENEVER ERROR CALL cl_err_msg_log
    
    IF (NOT cl_setup("AQC")) THEN
       EXIT PROGRAM
    END IF
    
    CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
    
    LET g_argv1=ARG_VAL(1)           #No.FUN-4A0081
    LET g_argv2=ARG_VAL(2)           #No.FUN-4A0081
 
    LET g_forupd_sql = "SELECT * FROM qcm_file WHERE qcm01 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t510_cl CURSOR FROM g_forupd_sql
 
    IF g_bgjob='N' OR cl_null(g_bgjob) THEN
 
       LET p_row = 2 LET p_col = 15
     
       OPEN WINDOW t510_w AT p_row,p_col   #顯示畫面
            WITH FORM "aqc/42f/aqct510"
             ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 #TQC-A60094  --begin
    IF g_sma.sma541 = 'Y' THEN 
       CALL cl_set_comp_visible("qcm012,ecu014",TRUE)
       CALL cl_set_comp_entry("qcm012,qcm05",TRUE)
    ELSE 
       CALL cl_set_comp_visible("qcm012,ecu014",FALSE)
       CALL cl_set_comp_entry("qcm012,qcm05",FALSE)
    END IF
 #TQC-A60094  --end
       CALL cl_ui_init()
 
    END IF
    #CALL cl_set_comp_visible("qcm05",g_sma.sma541='Y') #No.TQC-A90055 #TQC-AB0278

   #FUN-BC0104--(S)-----
    IF g_qcz.qcz14='Y' THEN
      CALL cl_set_act_visible("qc_item_maintain",TRUE)
    ELSE
      CALL cl_set_act_visible("qc_item_maintain",FALSE)
    END IF
    #FUN-BC0104--(E)-----
 
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t510_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL t510_a()
             END IF
 
          WHEN "SPC_upd"                    #SPC-更新QC資料
             CALL t510_q()
             CALL t510_spc_upd()            
             EXIT PROGRAM
 
          OTHERWISE 
             CALL t510_q()
       END CASE
    END IF
 
    IF fgl_getenv('SPC') = "1" THEN
       CALL cl_err(g_prog ,'aws-093',0)
       EXIT PROGRAM 
    END IF 
 
    CALL t510_menu()
    IF g_aza.aza64 matches '[ Nn]' OR g_aza.aza64 IS NULL THEN
       CALL cl_set_act_visible("trans_spc",TRUE)
       CALL cl_set_comp_visible("qcmspc",TRUE)       #TQC-820019-modify
    END IF
 
    CLOSE WINDOW t510_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
 
END MAIN
 
#QBE 查詢資料
FUNCTION t510_cs()
  DEFINE  l_ecm04      LIKE    ecm_file.ecm04
  DEFINE  lc_qbe_sn    LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
  CLEAR FORM                             #清除畫面
  CALL g_qcn.clear()
 
  IF cl_null(g_argv1) THEN   #FUN-4A0081
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_qcm.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        qcm00,qcm01,qcm02,qcm012,qcm05,qcm021,qcm04,qcm041,qcm22,qcm14,qcmspc,qcm15,   #No.MOD-640316 modify #FUN-680010 #No.TQC-750064 del qcm06 #TQC-A60094 add qcm012
        qcm091,qcm09,qcm13,qcmuser,qcmgrup,
        qcmoriu,qcmorig,                               #TQC-B80258 
       qcmmodu,qcmdate,qcmacti
       ,qcmud01,qcmud02,qcmud03,qcmud04,qcmud05,
        qcmud06,qcmud07,qcmud08,qcmud09,qcmud10,
        qcmud11,qcmud12,qcmud13,qcmud14,qcmud15
 
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(qcm01) #單號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_qcm2"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO qcm01
                   NEXT FIELD qcm01
              WHEN INFIELD(qcm021)
#FUN-AA0059---------mod------------str-----------------
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = "c"
#                  LET g_qryparam.form = "q_ima"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                   DISPLAY g_qryparam.multiret TO qcm021
                   NEXT FIELD qcm021
              WHEN INFIELD(qcm02) #工單單號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_sfb01"
                   LET g_qryparam.construct = "Y"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO qcm02
                   NEXT FIELD qcm02
   #TQC-A60094 --begin
                WHEN INFIELD(qcm012)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.form     = "q_qcm012_01"
                 LET g_qryparam.default1 = g_qcm.qcm012
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO qcm012
                 NEXT FIELD qcm012
   #TQC-A60094 --end
              WHEN INFIELD(qcm05) #製程序               
                  #CALL q_ecm(TRUE,TRUE,'','')       #FUN-C30163 mark
                   CALL q_ecm(TRUE,TRUE,'','','','N','','')  #FUN-C30163 add                 
                        RETURNING g_qryparam.multiret 
                   DISPLAY g_qryparam.multiret TO qcm05
                   NEXT FIELD qcm05
              WHEN INFIELD(qcm13) #員工編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_gen"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO qcm13
                   NEXT FIELD qcm13
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
	#No.FUN-580031 --end--       HCN
 
    END CONSTRUCT
 
    IF INT_FLAG THEN RETURN END IF
 
    CONSTRUCT g_wc2 ON qcn03,qcn04,qcn05,qcn10,qcn14,qcn15,qcn11,qcn07,qcn08 #螢幕上取單身條件           #No.FUN-A80063
             ,qcnud01,qcnud02,qcnud03,qcnud04,qcnud05
             ,qcnud06,qcnud07,qcnud08,qcnud09,qcnud10
             ,qcnud11,qcnud12,qcnud13,qcnud14,qcnud15
                  FROM s_qcn[1].qcn03,s_qcn[1].qcn04,s_qcn[1].qcn05,
                       s_qcn[1].qcn10,s_qcn[1].qcn14,s_qcn[1].qcn15,s_qcn[1].qcn11,                      #No.FUN-A80063
                       s_qcn[1].qcn07,s_qcn[1].qcn08
                      ,s_qcn[1].qcnud01,s_qcn[1].qcnud02,s_qcn[1].qcnud03
                      ,s_qcn[1].qcnud04,s_qcn[1].qcnud05,s_qcn[1].qcnud06
                      ,s_qcn[1].qcnud07,s_qcn[1].qcnud08,s_qcn[1].qcnud09
                      ,s_qcn[1].qcnud10,s_qcn[1].qcnud11,s_qcn[1].qcnud12
                      ,s_qcn[1].qcnud13,s_qcn[1].qcnud14,s_qcn[1].qcnud15
 
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
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
  ELSE
      LET g_wc =" qcm01 = '",g_argv1,"'"    #No.FUN-4A0081
      LET g_wc2=" 1=1"
  END IF
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('qcmuser', 'qcmgrup')
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT qcm01 FROM qcm_file ",
                   " WHERE qcm18='1' AND ", g_wc CLIPPED,
                   " ORDER BY qcm01"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE qcm_file.qcm01 ",
                   "  FROM qcm_file, qcn_file ",
                   " WHERE qcm01 = qcn01 AND qcm18='1' ",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY qcm01"
    END IF
 
    PREPARE t510_prepare FROM g_sql
    DECLARE t510_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t510_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM qcm_file ",
                  " WHERE qcm18='1' AND ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT qcm01) ",
                  "  FROM qcm_file,qcn_file WHERE ",
                  "qcn01=qcm01 AND qcm18='1' AND ",
                     g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t510_precount FROM g_sql
    DECLARE t510_count CURSOR FOR t510_precount
 
END FUNCTION
 
FUNCTION t510_menu()
   DEFINE l_qck09      LIKE qck_file.qck09   #FUN-BC0104

   WHILE TRUE
      CALL t510_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t510_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t510_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t510_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t510_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t510_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            CALL t510_out()
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "detail_flaw_reason"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_qcm.qcm01) THEN
                  LET g_msg="aqct111 '",g_qcm.qcm01,"' 0 0 3 "
                  CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
               END IF
            END IF
         WHEN "qry_detail_measure"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_qcm.qcm01) THEN
                  LET g_msg="aqcq112 '",g_qcm.qcm01,"' 0 0 3 "
                  CALL cl_cmdrun(g_msg)
               END IF
            END IF
         WHEN "memo"
            IF cl_chk_act_auth() THEN
               CALL t510_m()
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               LET g_success = 'Y'
               CALL t510_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t510_y_upd()       #CALL 原確認的 update 段
               END IF
 
               IF g_qcm.qcm14 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_qcm.qcm14,"","","",g_void,g_qcm.qcmacti)
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t510_z()
               IF g_qcm.qcm14 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_qcm.qcm14,"","","",g_void,g_qcm.qcmacti)
            END IF
         WHEN "special_purchase"
            IF cl_chk_act_auth() THEN
               CALL t510_3()
            END IF
#FUN-A30045 ------------Begin--------------
         WHEN  "cancel_special_purchase"
            IF cl_chk_act_auth() THEN
               CALL t510_4()
            END IF         
#FUN-A30045 ------------End----------------

#FUN-BC0104 ------------Begin--------------
         WHEN "qc_item_maintain"
            IF cl_chk_act_auth() THEN
                     LET l_qck09 = ''
                     SELECT DISTINCT qck09 INTO l_qck09 FROM ima_file,qck_file
                      WHERE qck01 = ima109 
                        AND ima01 = g_qcm.qcm021
                IF g_qcz.qcz14 = 'Y' AND l_qck09 = 'Y' THEN          
                  LET g_msg="aqci107 '",g_qcm.qcm01,"' 0 0 '3'"
                 #CALL cl_cmdrun(g_msg)         #TQC-C20524  mark
                  CALL cl_cmdrun_wait(g_msg)    #TQC-C20524
                 #CALL t510_qc_item_show()      #MOD-C30557
               ELSE                                       #TQC-C30139
                  CALL cl_err(m_ima109,'aqc-537',0)       #TQC-C30139
               END IF
            END IF
#FUN-BC0104 ------------End----------------

         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t510_x()    #FUN-D20025
               CALL t510_x(1)   #FUN-D20025
               IF g_qcm.qcm14 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_qcm.qcm14,"","","",g_void,g_qcm.qcmacti)
            END IF
         #FUN-D20025--add--str--  
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
              #CALL t510_x()    #FUN-D20025
               CALL t510_x(2)   #FUN-D20025
               IF g_qcm.qcm14 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_qcm.qcm14,"","","",g_void,g_qcm.qcmacti)
            END IF
         #FUN-D20025--add--str--  
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qcn),'','')
            END IF
         WHEN "trans_spc"         #FUN-680010
            IF cl_chk_act_auth() THEN
               CALL t510_spc()
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_qcm.qcm01 IS NOT NULL THEN
                 LET g_doc.column1 = "qcm01"
                 LET g_doc.value1 = g_qcm.qcm01
 #TQC-A60094 --begin
                 LET g_doc.column2 = "qcm012"
                 LET g_doc.value2 = g_qcm.qcm012
 #TQC-A60094  --end
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t510_a()
   DEFINE li_result   LIKE type_file.num5        #No.FUN-550063  #No.FUN-680104 SMALLINT
   DEFINE l_err       LIKE ze_file.ze01           #FUN-680010
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
 
    CLEAR FORM
    CALL g_qcn.clear()
    INITIALIZE g_qcm.* LIKE qcm_file.*             #DEFAULT 設定
    LET g_qcm01_t = NULL
    #預設值及將數值類變數清成零
    LET g_qcm_t.* = g_qcm.*
    LET g_qcm_o.* = g_qcm.*
 
    CALL cl_opmsg('a')
 
    WHILE TRUE
        LET m_gen02=' '
        LET m_ima109=' '
        LET qcm21_desc=' '
        LET qcm17_desc=' ' #CHI-BC0018
        LET des1=' '
        LET des2=' '
        LET ma_num1=0
        LET ma_num2=0
        LET mi_num1=0
        LET mi_num2=0
        LET g_qcm.qcm22=0
        LET g_qcm.qcm00='1'
        LET g_qcm.qcmuser=g_user
        LET g_qcm.qcmoriu = g_user #FUN-980030
        LET g_qcm.qcmorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_qcm.qcmgrup=g_grup
        LET g_qcm.qcmdate=g_today
        LET g_qcm.qcmacti='Y'              #資料有效
        LET g_qcm.qcm041=TIME              #資料有效
        LET g_qcm.qcm04=TODAY             #資料有效
        LET g_qcm.qcm14='N'
        LET g_qcm.qcmspc = '0'             #FUN-680010
        LET g_qcm.qcm15=''
        LET g_qcm.qcm091=0
        LET g_qcm.qcm13=g_user
        #NO.TQC-AB0278--begin
        IF g_sma.sma541='N' THEN
           LET g_qcm.qcm012=' '
        END IF
        #NO.TQC-AB0278--end
 
        CALL t510_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
           INITIALIZE g_qcm.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
 
        IF g_qcm.qcm01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
 
         #單頭輸入後直接按確認進單身,但此時送驗量=0
         IF g_qcm.qcm22 = 0 THEN
             CALL cl_err('','aqc-028',0)
             CONTINUE WHILE
         END IF
 
        BEGIN WORK #No:7857
 
        CALL s_auto_assign_no("asf",g_qcm.qcm01,g_qcm.qcm04,"D","qcm_file","qcm01","","","")
             RETURNING li_result,g_qcm.qcm01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_qcm.qcm01
 
        LET g_qcm.qcm18='1'
        LET g_qcm.qcm03=' '
 
        LET g_qcm.qcmplant = g_plant #FUN-980007
        LET g_qcm.qcmlegal = g_legal #FUN-980007

#TQC-A60094    --add
        IF cl_null(g_qcm.qcm012) THEN
           LET g_qcm.qcm012 = ' '
        END IF
#TQC-A60094    --end 

        INSERT INTO qcm_file VALUES (g_qcm.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
            CALL cl_err3("ins","qcm_file",g_qcm.qcm01,"",SQLCA.sqlcode,"","",1) #FUN-B80066
            ROLLBACK WORK #No:7857
            #CALL cl_err3("ins","qcm_file",g_qcm.qcm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115 #No.FUN-B80066
            CONTINUE WHILE
        ELSE
            COMMIT WORK #No:7857
            CALL cl_flow_notify(g_qcm.qcm01,'I')
        END IF
 
        SELECT qcm01 INTO g_qcm.qcm01 FROM qcm_file WHERE qcm01=g_qcm.qcm01      
 
        LET g_qcm01_t = g_qcm.qcm01        #保留舊值
        LET g_qcm_t.* = g_qcm.*
        CALL g_qcn.clear()
        LET g_rec_b = 0
 
        CALL t510_g_b()
        CALL t510_b()                   #輸入單身
        IF NOT cl_null(g_qcm.qcm01) THEN  #CHI-C30002 add
           CALL t510_ii('a')
        END IF        #CHI-C30002 add
 
        EXIT WHILE
    END WHILE
 
END FUNCTION
 
FUNCTION t510_u()
 
    IF s_shut(0) THEN RETURN END IF
    IF g_qcm.qcm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
    SELECT * INTO g_qcm.* FROM qcm_file WHERE qcm01=g_qcm.qcm01
 
    IF g_qcm.qcmacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_qcm.qcm01,9027,0)
       RETURN
    END IF
    IF g_qcm.qcm14 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_qcm.qcm14='Y' THEN RETURN END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
 
    LET g_qcm01_t = g_qcm.qcm01
    LET g_qcm_o.* = g_qcm.*
 
    BEGIN WORK
 
    OPEN t510_cl USING g_qcm.qcm01
    IF STATUS THEN
       CALL cl_err("OPEN t510_cl:", STATUS, 1)
       CLOSE t510_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t510_cl INTO g_qcm.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_qcm.qcm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t510_cl
        RETURN
    END IF
 
    CALL t510_show()
 
    WHILE TRUE
        LET g_qcm01_t = g_qcm.qcm01
        LET g_qcm.qcmmodu=g_user
        LET g_qcm.qcmdate=g_today
        CALL t510_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_qcm.*=g_qcm_t.*
            CALL t510_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
 
        IF g_qcm.qcm01 != g_qcm01_t THEN
            UPDATE qcn_file SET qcn01=g_qcm.qcm01 WHERE qcn01 = g_qcm01_t
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","qcn_file",g_qcm01_t,"",SQLCA.sqlcode,"","qcn",1)  #No.FUN-660115
                CONTINUE WHILE  
            END IF
        END IF
 
        UPDATE qcm_file SET qcm_file.* = g_qcm.*
         WHERE qcm01 = g_qcm01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","qcm_file",g_qcm01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
            CONTINUE WHILE
        END IF
 
        EXIT WHILE
    END WHILE
 
    CALL t510_ii('u')
 
    # CALL aws_spccli()
    #功能: 通知 SPC 端刪除此張單據
    # 傳入參數: (1) QC 程式代號, (2) QC 單頭資料,(3)功能選項：insert(新增),update(修改),delete(刪除)
    # 回傳值  : 0 傳送失敗; 1 傳送成功
    IF g_qcm.qcmspc = '1' THEN
       IF NOT aws_spccli(g_prog,base.TypeInfo.create(g_qcm),'update') THEN
          LET g_qcm.* = g_qcm_t.*
          CLOSE t510_cl
          ROLLBACK WORK
          RETURN
       END IF
    END IF
 
    CLOSE t510_cl
    COMMIT WORK
    CALL cl_flow_notify(g_qcm.qcm01,'U')
 
END FUNCTION
 
#處理INPUT
FUNCTION t510_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入  #No.FUN-680104 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改  #No.FUN-680104 VARCHAR(1)
    m_pmc03         LIKE pmc_file.pmc03,
    m_ima02         LIKE ima_file.ima02,
    m_ima021        LIKE ima_file.ima021,   #No.FUN-940103
    m_ima109        LIKE ima_file.ima109,
    m_azf03         LIKE azf_file.azf03,
    m_pmh05         LIKE pmh_file.pmh05,
    m_pmh05_desc    LIKE ze_file.ze03,   #No.TQC-610007
    l_rvb08         LIKE rvb_file.rvb08,
    l_qcm22         LIKE qcm_file.qcm22,        #No.FUN-680104 DEC(12,0)
    l_ecm04         LIKE ecm_file.ecm04
 
DEFINE li_result    LIKE type_file.num5                #No.FUN-550063  #No.FUN-680104 SMALLINT
DEFINE l_cnt        LIKE type_file.num5                #No.FUN-830110
DEFINE l_n          LIKE type_file.num5                #MOD-C30619 add
#MOD-C40055--begin
DEFINE l_ima153     LIKE ima_file.ima153
DEFINE l_ecm62      LIKE ecm_file.ecm62  
DEFINE l_ecm63      LIKE ecm_file.ecm63  
DEFINE l_ecm315     LIKE ecm_file.ecm315  
#MOD-C40055--end   
 
    DISPLAY BY NAME
       g_qcm.qcm00,g_qcm.qcm01,g_qcm.qcm02,g_qcm.qcm012,g_qcm.qcm05,g_qcm.qcm021,    #No.MOD-640316 modify  #TQC-A60094 --add qcm012
       g_qcm.qcm04,g_qcm.qcm041,g_qcm.qcm21,g_qcm.qcm17,
       g_qcm.qcm22,g_qcm.qcm091,g_qcm.qcm09,g_qcm.qcm13,    #No.TQC-750064 del qcm06
       g_qcm.qcm14,g_qcm.qcmspc,g_qcm.qcm15,     #FUN-680010
       g_qcm.qcmuser,g_qcm.qcmgrup,g_qcm.qcmmodu,g_qcm.qcmdate,g_qcm.qcmacti
      ,g_qcm.qcmud01,g_qcm.qcmud02,g_qcm.qcmud03,g_qcm.qcmud04,
       g_qcm.qcmud05,g_qcm.qcmud06,g_qcm.qcmud07,g_qcm.qcmud08,
       g_qcm.qcmud09,g_qcm.qcmud10,g_qcm.qcmud11,g_qcm.qcmud12,
       g_qcm.qcmud13,g_qcm.qcmud14,g_qcm.qcmud15               
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
 
    INPUT BY NAME g_qcm.qcmoriu,g_qcm.qcmorig,
       g_qcm.qcm00,g_qcm.qcm01,g_qcm.qcm02,g_qcm.qcm012,g_qcm.qcm05,g_qcm.qcm021,   #No.MOD-640316 modify #TQC-A60094 --add qcm012
       g_qcm.qcm04,g_qcm.qcm041,g_qcm.qcm21,g_qcm.qcm17,
       g_qcm.qcm22,              #No.TQC-750064 del qcm06
       g_qcm.qcmuser,g_qcm.qcmgrup,g_qcm.qcmmodu,g_qcm.qcmdate,g_qcm.qcmacti
      ,g_qcm.qcmud01,g_qcm.qcmud02,g_qcm.qcmud03,g_qcm.qcmud04,
       g_qcm.qcmud05,g_qcm.qcmud06,g_qcm.qcmud07,g_qcm.qcmud08,
       g_qcm.qcmud09,g_qcm.qcmud10,g_qcm.qcmud11,g_qcm.qcmud12,
       g_qcm.qcmud13,g_qcm.qcmud14,g_qcm.qcmud15               
 
       WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t510_set_entry(p_cmd)
            CALL t510_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_set_docno_format("qcm01")
            CALL cl_set_docno_format("qcm02")
 
        BEFORE FIELD qcm00
            CALL t510_set_entry(p_cmd)
 
        AFTER FIELD qcm00
            IF NOT cl_null(g_qcm.qcm00) THEN
               IF g_qcm.qcm00 NOT MATCHES '[12]' THEN
                  NEXT FIELD qcm00
               END IF
            END IF
            CALL t510_set_no_entry(p_cmd)
 
        AFTER FIELD qcm01              #PQC編號
            IF NOT cl_null(g_qcm.qcm01) THEN
               CALL s_check_no("asf",g_qcm.qcm01,g_qcm01_t,"D","qcm_file","qcm01","")
                 RETURNING li_result,g_qcm.qcm01
               DISPLAY BY NAME g_qcm.qcm01
               IF (NOT li_result) THEN
                  NEXT FIELD qcm01
               END IF
               LET g_qcm_o.qcm01=g_qcm.qcm01
            END IF
 
        AFTER FIELD qcm02
            IF NOT cl_null(g_qcm.qcm02) THEN
               #MOD-C30619--add--str--
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM shm_file
                WHERE shm012 = g_qcm.qcm02
               IF l_n > 0 THEN
                  CALL cl_err(g_qcm.qcm02,'aqc-070',0)
                  NEXT FIELD qcm02
               END IF
               #MOD-C30619--add--end--
               SELECT sfb05 INTO g_qcm.qcm021 FROM sfb_file
                WHERE sfb01=g_qcm.qcm02
                  AND ((sfb04 IN ('4','5','6','7') AND sfb39='1') OR
                      (sfb04 IN ('2','3','4','5','6','7') AND sfb39='2'))
                  AND sfb04 < '8'  AND sfb87!='X'
               IF STATUS THEN   #資料不存在
                  CALL cl_err(g_qcm.qcm02,'asf-018',0)
                  LET g_qcm.qcm02 = g_qcm_t.qcm02
                  DISPLAY BY NAME g_qcm.qcm02
                  NEXT FIELD qcm02
               ELSE
                  DISPLAY BY NAME g_qcm.qcm021
                  CALL t510_sfb('i') #MOD-8A0131 add 'i'
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_qcm.qcm021,g_errno,0)
                     LET g_qcm.qcm021 = g_qcm_t.qcm021
                     DISPLAY BY NAME g_qcm.qcm021
                     NEXT FIELD qcm02
                  END IF
               END IF
               
               SELECT * FROM sfb_file
                WHERE sfb01 = g_qcm.qcm02
                  AND sfb87 = 'Y'  #已確認
                  AND sfb04 <> '8' #未結案
               IF STATUS=100 THEN
                   LET g_msg=g_qcm.qcm01 CLIPPED,'+',g_qcm.qcm02
                   CALL cl_err3("sel","sfb_file",g_qcm.qcm02,"","aqc-014","","",1)  #No.FUN-660115
                   NEXT FIELD qcm02
               END IF
            END IF

#TQC-A60094 ---begin
       AFTER FIELD qcm012
            IF cl_null(g_qcm.qcm02) THEN NEXT FIELD qcm02 END IF 
            IF g_qcm.qcm012 IS NOT NULL THEN 
               CALL t510_ecm_chk(g_qcm.qcm02,g_qcm.qcm012,g_qcm.qcm05)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_qcm.qcm012,g_errno,0)
                  LET g_qcm.qcm012 = g_qcm_t.qcm012
                  DISPLAY BY NAME g_qcm.qcm012
                  NEXT FIELD qcm012
                ELSE
                   CALL t510_qcm_show()
               END IF
            ELSE
               LET g_qcm.qcm012 = ' '
            END IF
#TQC-A60094 --end
 
        AFTER FIELD qcm05
            IF NOT cl_null(g_qcm.qcm05) THEN
               CALL t510_ecm()
               IF NOT cl_null(g_errno) THEN
                  NEXT FIELD qcm05
               END IF
            END IF
 
        AFTER FIELD qcm021
            IF NOT cl_null(g_qcm.qcm021) THEN
#FUN-AA0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(g_qcm.qcm021,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_qcm.qcm021= g_qcm_t.qcm021
                  NEXT FIELD qcm021
               END IF
#FUN-AA0059 ---------------------end-------------------------------
               SELECT ima02,ima021,ima109,ima100,ima101,ima102  #FUN-A80063 add ima101     #No.FUN-940103 add ima021
                 INTO m_ima02,m_ima021,m_ima109,g_qcm.qcm21,g_ima101,g_qcm.qcm17   #FUN-A80063 add ima101  #No.FUN-940103 add ima021
                 FROM ima_file WHERE ima01=g_qcm.qcm021
               IF STATUS=100 THEN
                  LET m_ima02 = ' ' LET m_ima109=' '
                  LET m_ima021= ' '  #No.FUN-940103
                  LET g_qcm.qcm21=' ' LET g_qcm.qcm17=' '
                  CALL cl_err3("sel","ima_file",g_qcm.qcm021,"","mfg1201","","",1)  #No.FUN-660115
                  NEXT FIELD qcm021
               END IF
 
               DISPLAY m_ima02 TO FORMONLY.ima02
               DISPLAY m_ima021 TO FORMONLY.ima021   #No.FUN-940103
               DISPLAY m_ima109 TO FORMONLY.ima109
               DISPLAY g_ima101 TO ima101    #FUN-A80063 add ima101
               SELECT azf03 INTO m_azf03 FROM azf_file
                WHERE azf01=m_ima109 AND azf02='8'
               IF STATUS THEN LET m_azf03=' ' END IF
 
               DISPLAY m_azf03 TO FORMONLY.azf03
               DISPLAY g_qcm.qcm17 TO qcm17
 
               CASE g_qcm.qcm21
                    WHEN 'N' CALL cl_getmsg('aqc-001',g_lang) RETURNING qcm21_desc
                    WHEN 'T' CALL cl_getmsg('aqc-002',g_lang) RETURNING qcm21_desc
                    WHEN 'R' CALL cl_getmsg('aqc-003',g_lang) RETURNING qcm21_desc
               END CASE
 
               DISPLAY g_qcm.qcm21 TO qcm21
               DISPLAY g_qcm.qcm012 TO qcm012      #TQC-A60094 --add
               DISPLAY qcm21_desc TO FORMONLY.qcm21_desc
   #----------CHI-BC0018 str add-----------------
   CASE g_qcm.qcm17
      WHEN '1'
         SELECT gae04 INTO qcm17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_1' AND gae03=g_lang
      WHEN '2'
         SELECT gae04 INTO qcm17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_2' AND gae03=g_lang
      WHEN '3'
         SELECT gae04 INTO qcm17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_3' AND gae03=g_lang
      WHEN '4'
         SELECT gae04 INTO qcm17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_4' AND gae03=g_lang
      WHEN '5'
         SELECT gae04 INTO qcm17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_5' AND gae03=g_lang
      WHEN '6'
         SELECT gae04 INTO qcm17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_6' AND gae03=g_lang
      WHEN '7'
         SELECT gae04 INTO qcm17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_7' AND gae03=g_lang
      OTHERWISE
         LET qcm17_desc= ' ' 
   END CASE

   DISPLAY qcm17_desc TO FORMONLY.qcm17_desc
   #----------CHI-BC0018 end add-----------------

            END IF

        BEFORE FIELD qcm22
            CALL t510_qcm22() RETURNING l_qcm22     #檢查可送檢數
            DISPLAY BY NAME g_qcm.qcm22
 
        AFTER FIELD qcm22
            IF NOT cl_null(g_qcm.qcm22) THEN
               IF g_qcm.qcm22 < 0 THEN
                  CALL cl_err('','aqc-016',0)
                  NEXT FIELD qcm22
               END IF
               IF g_qcm.qcm22 = 0 THEN
                  CALL cl_err('','aqc-028',0)
                  NEXT FIELD qcm22
               END IF
 
               IF g_qcm.qcm22 > l_qcm22 THEN
                  CALL cl_err(g_qcm.qcm22,'aqc-021',0)
                  NEXT FIELD qcm22
               END IF
               #MOD-C40055--begin
               IF g_qcm.qcm00='1' THEN 
                  CALL s_get_ima153(g_qcm.qcm021) RETURNING l_ima153 
                  SELECT ecm62,ecm63,ecm04 INTO l_ecm62,l_ecm63,l_ecm04 FROM ecm_file
                   WHERE ecm01=g_qcm.qcm02 AND ecm03=g_qcm.qcm05
                     AND ecm012=g_qcm.qcm012
                  IF cl_null(l_ecm62) OR l_ecm62=0 THEN
                     LET l_ecm62=1
                  END IF
                  IF cl_null(l_ecm63) OR l_ecm63=0 THEN
                     LET l_ecm63=1
                  END IF
                  CALL s_minp_routing(g_qcm.qcm02,g_sma.sma73,l_ima153,l_ecm04,g_qcm.qcm012,g_qcm.qcm05)  
                  RETURNING g_cnt,g_min_set         
                                 
                  SELECT SUM(ecm315) INTO l_ecm315 FROM ecm_file
                   WHERE ecm01 = g_qcm.qcm02
                  IF cl_null(l_ecm315) OR l_ecm315 = 0 THEN
                     LET l_ecm315 = 0
                  END IF 
                  #MOD-CB0183 add begin---------------------------
                  IF g_sma.sma542 = 'Y' THEN
                     SELECT COUNT(*) INTO l_cnt FROM sfa_file
                      WHERE sfa01 = g_qcm.qcm02 AND (sfa08 = l_ecm04 OR sfa08 = ' ')
                        AND sfa012 = g_qcm.qcm012 AND sfa013 = g_qcm.qcm05
                        AND sfa161 > 0
                  ELSE
                     SELECT COUNT(*) INTO l_cnt FROM sfa_file
                      WHERE sfa01 = g_qcm.qcm02 AND (sfa08 = l_ecm04 OR sfa08 = ' ')
                        AND sfa161 > 0 
                  END IF
                  #MOD-CB0183 add end-----------------------------
                 #IF g_qcm.qcm22 > (g_min_set*l_ecm62/l_ecm63) + l_ecm315 THEN   #MOD-CB0183 mark
                  IF g_qcm.qcm22 > (g_min_set*l_ecm62/l_ecm63) + l_ecm315 AND l_cnt > 0 THEN #MOD-CB0183 add l_cnt > 0
                     CALL cl_err('','aqc-331',1)
                     NEXT FIELD qcm22
                  END IF        
               END IF 
               #MOD-C40055--end                  
               LET g_qcm22=g_qcm.qcm22       #bugno:7196
            END IF
 
        AFTER FIELD qcmud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcmud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcmud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcmud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcmud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcmud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcmud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcmud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcmud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcmud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcmud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcmud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcmud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcmud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD qcmud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(qcm01) #單號
                   LET g_t1 = s_get_doc_no(g_qcm.qcm01)       #No.FUN-550063
                   CALL q_smy(FALSE,FALSE,g_t1,'ASF','D') RETURNING g_t1 #TQC-670008
                   LET g_qcm.qcm01 = g_t1       #No.FUN-550063
                   DISPLAY BY NAME g_qcm.qcm01
                   NEXT FIELD qcm01
              WHEN INFIELD(qcm021)
#FUN-AA0059---------mod------------str-----------------
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ima"
#                  LET g_qryparam.default1 = g_qcm.qcm021
#                  CALL cl_create_qry() RETURNING g_qcm.qcm021
                   CALL q_sel_ima(FALSE, "q_ima","",g_qcm.qcm021,"","","","","",'' ) 
                      RETURNING g_qcm.qcm021  
#FUN-AA0059---------mod------------end-----------------
                   DISPLAY BY NAME g_qcm.qcm021
                   NEXT FIELD qcm021
              WHEN INFIELD(qcm02) #工單單號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_sfb01"
                   LET g_qryparam.construct = "Y"
                   LET g_qryparam.default1 = g_qcm.qcm02
                   CALL cl_create_qry() RETURNING g_qcm.qcm02
                   DISPLAY BY NAME g_qcm.qcm02
                   NEXT FIELD qcm02
#TQC-A60094 --add
              WHEN INFIELD(qcm012)    #工艺段号
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     ="q_qcm012"
                 LET g_qryparam.default1 = g_qcm.qcm012
                 LET g_qryparam.default2 = g_qcm.qcm05
                 LET g_qryparam.default3 = g_ecm.ecm04
                 LET g_qryparam.arg1     = g_qcm.qcm02
                 CALL cl_create_qry() RETURNING g_qcm.qcm012,g_qcm.qcm05,g_ecm.ecm04
                 DISPLAY BY NAME g_qcm.qcm012
                 DISPLAY BY NAME g_qcm.qcm05
                 DISPLAY g_ecm.ecm04 TO FORMONLY.ecm04
                 CALL t510_qcm_show()
                 NEXT FIELD qcm012
#TQC-A60094  --end
              WHEN INFIELD(qcm05) #製程序
                  #CALL q_ecm(FALSE,FALSE,g_qcm.qcm02,'') RETURNING l_ecm04,g_qcm.qcm05   #FUN-C30163 mark
                   CALL q_ecm(FALSE,FALSE,g_qcm.qcm02,'',' ecm53 = "Y" ','Y',g_qcm.qcm00,g_qcm.qcm01) RETURNING l_ecm04,g_qcm.qcm05   #FUN-C30163 add
                   DISPLAY BY NAME g_qcm.qcm05
                   NEXT FIELD qcm05
              WHEN INFIELD(qcm13) #員工編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.default1 = g_qcm.qcm13
                   CALL cl_create_qry() RETURNING g_qcm.qcm13
                   DISPLAY BY NAME g_qcm.qcm13
                   NEXT FIELD qcm13
           END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
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
 
#Query 查詢
FUNCTION t510_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_qcm.* TO NULL              #No.FUN-6A0160
    CALL cl_opmsg('q')
 
    MESSAGE ""
    CLEAR FORM
    CALL g_qcn.clear()
 
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t510_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t510_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_qcm.* TO NULL
    ELSE
       OPEN t510_count
       FETCH t510_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL t510_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
    MESSAGE ""
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t510_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-680104 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-680104 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t510_cs INTO g_qcm.qcm01
        WHEN 'P' FETCH PREVIOUS t510_cs INTO g_qcm.qcm01
        WHEN 'F' FETCH FIRST    t510_cs INTO g_qcm.qcm01
        WHEN 'L' FETCH LAST     t510_cs INTO g_qcm.qcm01
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
            FETCH ABSOLUTE g_jump t510_cs INTO g_qcm.qcm01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_qcm.qcm01,SQLCA.sqlcode,0)
        INITIALIZE g_qcm.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_qcm.* FROM qcm_file WHERE qcm01 = g_qcm.qcm01 
#      AND ecm012 = g_qcm.qcm012    #TQC-A60094 --add
 
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","qcm_file",g_qcm.qcm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
        INITIALIZE g_qcm.* TO NULL
    ELSE
        LET g_data_owner = g_qcm.qcmuser     #FUN-4C0038
        LET g_data_group = g_qcm.qcmgrup     #FUN-4C0038
        LET g_data_plant = g_qcm.qcmplant #FUN-980030
        CALL t510_show()
    END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t510_show()
   DEFINE m_ima02         LIKE ima_file.ima02,       #No.FUN-680104 VARCHAR(30)
          m_ima021        LIKE ima_file.ima021,
          m_azf03         LIKE azf_file.azf03,       #No.FUN-680104 VARCHAR(30)
          m_qcm091        LIKE qcm_file.qcm091,      #No.FUN-680104 DEC(12,3)
          l_qcm22         LIKE qcm_file.qcm22,
          m_eca02         LIKE eca_file.eca02,
          m_ecm04         LIKE ecm_file.ecm04,
          m_ecm06         LIKE ecm_file.ecm06,
          m_ecm45         LIKE ecm_file.ecm45
 
    LET g_qcm_t.* = g_qcm.*                #保存單頭舊值
    DISPLAY BY NAME g_qcm.qcmoriu,g_qcm.qcmorig,                              # 顯示單頭值
       g_qcm.qcm00,g_qcm.qcm01,g_qcm.qcm02,g_qcm.qcm05,g_qcm.qcm021,
       g_qcm.qcm04,g_qcm.qcm041,g_qcm.qcm21,g_qcm.qcm17,
       g_qcm.qcm22,g_qcm.qcm091,g_qcm.qcm09,g_qcm.qcm13,       #No.TQC-750064 del qcm06
       g_qcm.qcm14,g_qcm.qcmspc,g_qcm.qcm15,  #FUN-680010
       g_qcm.qcmuser,g_qcm.qcmgrup,g_qcm.qcmmodu,g_qcm.qcmdate,g_qcm.qcmacti
      ,g_qcm.qcmud01,g_qcm.qcmud02,g_qcm.qcmud03,g_qcm.qcmud04,
       g_qcm.qcmud05,g_qcm.qcmud06,g_qcm.qcmud07,g_qcm.qcmud08,
       g_qcm.qcmud09,g_qcm.qcmud10,g_qcm.qcmud11,g_qcm.qcmud12,
       g_qcm.qcmud13,g_qcm.qcmud14,g_qcm.qcmud15,g_qcm.qcm012     #TQC-A60094 --add qcm012
 
    SELECT ima02,ima021,ima109,ima101 INTO m_ima02,m_ima021,m_ima109,g_ima101 FROM ima_file     #No.FUN-A80063  #No.FUN-940103 add ima021
       WHERE ima01=g_qcm.qcm021
    IF STATUS=100 THEN 
       LET m_ima02 = ' ' LET m_ima109=' ' 
       LET m_ima021= ' '  #No.FUN-940103    
    END IF
    DISPLAY m_ima02 TO FORMONLY.ima02
    DISPLAY m_ima021 TO FORMONLY.ima021    #No.FUN-940103
    DISPLAY m_ima109 TO FORMONLY.ima109
    DISPLAY g_ima101 TO ima101   #No.FUN-A80063
 
    SELECT azf03 INTO m_azf03 FROM azf_file
       WHERE azf01=m_ima109 AND azf02='8'
    IF STATUS THEN LET m_azf03=' ' END IF
    DISPLAY m_azf03 TO FORMONLY.azf03
 
    LET des1 = NULL       #No:7637
    LET qcm21_desc = NULL #No:7637
    LET qcm17_desc = NULL #CHI-BC0018
    LET m_gen02    = NULL #No:7637
    CASE g_qcm.qcm09
         WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING des1
         WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING des1
         WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING des1 #BugNo:5046
    END CASE
    DISPLAY des1 TO FORMONLY.des1
 
    CASE g_qcm.qcm21
         WHEN 'N' CALL cl_getmsg('aqc-001',g_lang) RETURNING qcm21_desc
         WHEN 'T' CALL cl_getmsg('aqc-002',g_lang) RETURNING qcm21_desc
         WHEN 'R' CALL cl_getmsg('aqc-003',g_lang) RETURNING qcm21_desc
    END CASE
    DISPLAY qcm21_desc TO FORMONLY.qcm21_desc
  #----------CHI-BC0018 str add-----------------
   CASE g_qcm.qcm17
      WHEN '1'
         SELECT gae04 INTO qcm17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_1' AND gae03=g_lang
      WHEN '2'
         SELECT gae04 INTO qcm17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_2' AND gae03=g_lang
      WHEN '3'
         SELECT gae04 INTO qcm17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_3' AND gae03=g_lang
      WHEN '4'
         SELECT gae04 INTO qcm17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_4' AND gae03=g_lang
      WHEN '5'
         SELECT gae04 INTO qcm17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_5' AND gae03=g_lang
      WHEN '6'
         SELECT gae04 INTO qcm17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_6' AND gae03=g_lang
	  WHEN '7'
         SELECT gae04 INTO qcm17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_7' AND gae03=g_lang
      OTHERWISE
         LET qcm17_desc= ' '
   END CASE

   DISPLAY qcm17_desc TO FORMONLY.qcm17_desc
   #----------CHI-BC0018 end add----------------- 
    SELECT gen02 INTO m_gen02 FROM gen_file WHERE gen01=g_qcm.qcm13
    DISPLAY m_gen02 TO FORMONLY.gen02
 
    SELECT ecm04,ecm06,ecm45,eca02
      INTO m_ecm04,m_ecm06,m_ecm45,m_eca02
    FROM ecm_file,OUTER ima_file, OUTER eca_file
    WHERE ecm01 = g_qcm.qcm02
      AND ecm03 = g_qcm.qcm05
      AND ecm012 = g_qcm.qcm012      #FUN-A60027  #TQC-A60094
      AND ecm_file.ecm03_par = ima_file.ima01
      AND eca_file.eca01=ecm_file.ecm06
   DISPLAY m_ecm04 TO FORMONLY.ecm04    #作業編號
   DISPLAY m_ecm06 TO FORMONLY.ecm06    #工作站
   DISPLAY m_ecm45 TO FORMONLY.ecm45    #作業名稱
   DISPLAY m_eca02 TO FORMONLY.eca02    #料件名稱
 
   CALL t510_sfb('q')  #MOD-8A0131 add '1'
   IF g_qcm.qcm14 = 'X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
   CALL cl_set_field_pic(g_qcm.qcm14,"","","",g_void,g_qcm.qcmacti)
   CALL t510_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t510_r()
   DEFINE l_cnt1   LIKE type_file.num10        #FUN-BC0104
   IF s_shut(0) THEN RETURN END IF
   IF g_qcm.qcm01 IS NULL OR g_qcm.qcm012 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF   #TQC-A60094 --add qcm012
   SELECT * INTO g_qcm.* FROM qcm_file WHERE qcm01=g_qcm.qcm01 
      AND ecm012 = g_qcm.qcm012  #TQC-A60094 --add
   IF g_qcm.qcmacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_qcm.qcm01,9027,0)
      RETURN
   END IF
   IF g_qcm.qcm14 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_qcm.qcm14='Y' THEN RETURN END IF

#FUN-BC0104 -------------Begin-------------
   SELECT count(*) INTO l_cnt1 FROM qco_file
    WHERE qco01 = g_qcm.qcm01
      AND qco02 = 0
      AND qco05 = 0
   IF cl_null(l_cnt1) THEN
      LET l_cnt1 = 0
   END IF
   IF l_cnt1 > 0 THEN
      IF NOT cl_confirm('aqc-056') THEN
         RETURN
      END IF
   END IF
#FUN-BC0104 -------------End---------------
 
    BEGIN WORK
 
    OPEN t510_cl USING g_qcm.qcm01
    IF STATUS THEN
       CALL cl_err("OPEN t510_cl:", STATUS, 1)
       CLOSE t510_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t510_cl INTO g_qcm.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_qcm.qcm01,SQLCA.sqlcode,0)          #資料被他人LOCK
       CLOSE t510_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL t510_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "qcm01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_qcm.qcm01      #No.FUN-9B0098 10/02/24
#TQC-A60094 --add
        LET g_doc.column2 = "qcm012"
        LET g_doc.value2 = g_qcm.qcm012
#TQC-A60094 --end 
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       DELETE FROM qcm_file WHERE qcm01 = g_qcm.qcm01
                              AND qcm012 = g_qcm.qcm012  #TQC-A60094  -add
       #FUN-BC0104 --------------Begin---------------
       DELETE FROM qco_file WHERE qco01 = g_qcm.qcm01
                              AND qco02 = 0
                              AND qco05 = 0
       #FUN-BC0104 --------------End-----------------
       DELETE FROM qcn_file WHERE qcn01 = g_qcm.qcm01
       DELETE FROM qcu_file WHERE qcu01 = g_qcm.qcm01
 
       DELETE FROM qcnn_file WHERE qcnn01 = g_qcm.qcm01
       DELETE FROM qcv_file WHERE qcv01 = g_qcm.qcm01  
 
       IF g_aza.aza64 NOT matches '[ Nn]' THEN 
          # CALL aws_spccli()
          #功能: 通知 SPC 端刪除此張單據
          # 傳入參數: (1) QC 程式代號, (2) QC 單頭資料,(3)功能選項：insert(新增),delete(刪除)
          # 回傳值  : 0 傳送失敗; 1 傳送成功
          IF g_qcm.qcmspc = '1' THEN
             IF NOT aws_spccli(g_prog,base.TypeInfo.create(g_qcm),'delete') THEN
                CLOSE t510_cl
                ROLLBACK WORK
                RETURN
             END IF
          END IF
       END IF
       INITIALIZE g_qcm.* TO NULL
       CLEAR FORM
       CALL g_qcn.clear()
    END IF
 
    CLOSE t510_cl
    COMMIT WORK
    CALL cl_flow_notify(g_qcm.qcm01,'D')
 
END FUNCTION
 
#單身
FUNCTION t510_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680104 SMALLINT
    l_n,l_cnt,l_num,l_numcr,l_numma,l_nummi LIKE type_file.num5,         #No.FUN-680104 SMALLINT #檢查重複用
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-680104 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-680104 VARCHAR(1)
    l_qcc05         LIKE qcc_file.qcc05,
    l_qcc07         LIKE qcc_file.qcc07,
   #將l_qct07改宣告為整數形態，因為當缺點數乘上權數後
   #是以無條件捨去，取整數來作比較
    l_qcn07         LIKE qcn_file.qcn07,   #No.CHI-740037 add
    l_chkqty        LIKE type_file.num5,
    l_qcc061        LIKE qcc_file.qcc061,
    l_qcc062        LIKE qcc_file.qcc062,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680104 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-680104 SMALLINT
    DEFINE l_sql    STRING      #No.FUN-910079
    DEFINE l_length         LIKE type_file.num10               #No:MOD-9B0024 add
#No.FUN-A80130 --begin
DEFINE l_avg           LIKE qcnn_file.qcnn04
DEFINE l_qcnn04        LIKE qcnn_file.qcnn04
DEFINE l_sum           LIKE qcnn_file.qcnn04
DEFINE l_stddev        LIKE qcnn_file.qcnn04
DEFINE l_k_max         LIKE qcnn_file.qcnn04
DEFINE l_k_min         LIKE qcnn_file.qcnn04
DEFINE l_f             LIKE qcnn_file.qcnn04
DEFINE l_qcd           RECORD LIKE qcd_file.*
DEFINE l_qcd03         LIKE qcd_file.qcd03
DEFINE l_qcd04         LIKE qcd_file.qcd04
DEFINE l_count         LIKE type_file.num5     #FUN-BB0084
#No.FUN-A80130 --end 

    
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_qcm.qcm01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_qcm.* FROM qcm_file WHERE qcm01=g_qcm.qcm01
    IF g_qcm.qcmacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_qcm.qcm01,'aom-000',0)
       RETURN
    END IF
 
    IF g_qcm.qcm14 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_qcm.qcm14='Y' THEN RETURN END IF
 
#FUN-BC0104 ---------------Begin-----------------
    SELECT COUNT(*) INTO l_count FROM qco_file
     WHERE qco01 = g_qcm.qcm01
       AND qco02 = 0
       AND qco05 = 0
    IF cl_null(l_count) THEN LET l_count = 0 END IF
    IF l_count > 0 THEN
       CALL cl_err(g_qcm.qcm01,'aqc-402',0)
       RETURN
   END IF
#FUN-BC0104 ---------------End-------------------

    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT qcn03,qcn04,'',qcn05,qcn06,qcn09,qcn10,qcn14,qcn15,qcn11,qcn07,qcn08,'' ",       #No.FUN-A80063
        "       qcnud01,qcnud02,qcnud03,qcnud04,qcnud05,",
        "       qcnud06,qcnud07,qcnud08,qcnud09,qcnud10,",
        "       qcnud11,qcnud12,qcnud13,qcnud14,qcnud15 ",
        "FROM qcn_file ",
        " WHERE qcn01= ? AND qcn03= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t510_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = FALSE
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_qcn WITHOUT DEFAULTS FROM s_qcn.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN t510_cl USING g_qcm.qcm01
            IF STATUS THEN
               CALL cl_err("OPEN t510_cl:", STATUS, 1)
               CLOSE t510_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH t510_cl INTO g_qcm.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_qcm.qcm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE t510_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_qcn_t.* = g_qcn[l_ac].*  #BACKUP
 
               OPEN t510_bcl USING g_qcm.qcm01, g_qcn_t.qcn03
               IF STATUS THEN
                  CALL cl_err("OPEN t510_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t510_bcl INTO g_qcn[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_qcn_t.qcn03,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     SELECT azf03 INTO g_qcn[l_ac].azf03_1 FROM azf_file
                      WHERE azf01=g_qcn[l_ac].qcn04 AND azf02='6'
                     CASE g_qcn[l_ac].qcn08
                          WHEN '1' CALL cl_getmsg('aqc-004',g_lang)
                                        RETURNING g_qcn[l_ac].qcn08_desc
                          WHEN '2' CALL cl_getmsg('aqc-033',g_lang)
                                        RETURNING g_qcn[l_ac].qcn08_desc
                     END CASE
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_qcn[l_ac].* TO NULL      #900423
            LET g_qcn_t.* = g_qcn[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD qcn03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
 
            IF g_qcn[l_ac].qcn07=0 THEN
               DELETE FROM qcu_file
                WHERE qcu01=g_qcm.qcm01
                  AND qcu03=g_qcn[l_ac].qcn03
            END IF
             INSERT INTO qcn_file (qcn01,qcn03,qcn04,qcn05,qcn06,qcn07,  #No.MOD-470041
                                  qcn08,qcn09,qcn10,qcn11,qcn12,qcn131,qcn132,
                                  qcnud01,qcnud02,qcnud03,
                                  qcnud04,qcnud05,qcnud06,
                                  qcnud07,qcnud08,qcnud09,
                                  qcnud10,qcnud11,qcnud12,
                                  qcnud13,qcnud14,qcnud15,
                                  qcnplant,qcnlegal)  #FUN-980007
                 VALUES(g_qcm.qcm01,g_qcn[l_ac].qcn03,g_qcn[l_ac].qcn04,
                        g_qcn[l_ac].qcn05,g_qcn[l_ac].qcn06,g_qcn[l_ac].qcn07,
                        g_qcn[l_ac].qcn08,g_qcn[l_ac].qcn09, g_qcn[l_ac].qcn10,
                        g_qcn[l_ac].qcn11,l_qcc05,0,0,
                        g_qcn[l_ac].qcnud01,g_qcn[l_ac].qcnud02,
                        g_qcn[l_ac].qcnud03,g_qcn[l_ac].qcnud04,
                        g_qcn[l_ac].qcnud05,g_qcn[l_ac].qcnud06,
                        g_qcn[l_ac].qcnud07,g_qcn[l_ac].qcnud08,
                        g_qcn[l_ac].qcnud09,g_qcn[l_ac].qcnud10,
                        g_qcn[l_ac].qcnud11,g_qcn[l_ac].qcnud12,
                        g_qcn[l_ac].qcnud13,g_qcn[l_ac].qcnud14,
                        g_qcn[l_ac].qcnud15,
                        g_plant,g_legal)               #FUN-980007
 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","qcn_file",g_qcm.qcm01,g_qcn[l_ac].qcn03,SQLCA.sqlcode,"","",1)  #No.FUN-660115
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
        BEFORE FIELD qcn03                        #default 序號
            IF g_qcn[l_ac].qcn03 IS NULL OR
               g_qcn[l_ac].qcn03 = 0 THEN
                SELECT max(qcn03)+1
                   INTO g_qcn[l_ac].qcn03
                   FROM qcn_file
                   WHERE qcn01 = g_qcm.qcm01
                IF g_qcn[l_ac].qcn03 IS NULL THEN
                    LET g_qcn[l_ac].qcn03 = 1
                END IF
            END IF
 
        AFTER FIELD qcn11
            IF g_qcn[l_ac].qcn11 IS NULL THEN LET g_qcn[l_ac].qcn11=0 END IF
            IF g_qcn[l_ac].qcn11<=0 THEN NEXT FIELD qcn11 END IF
           #MOD-C70114 str mark-----
           #LET l_sql = " SELECT qcc05,qcc061,qcc062,qcc07 ", 
           #            " FROM qcc_file ",
           #            " WHERE qcc01=? AND qcc02=? ",
           #            " AND qcc08 in ('3','9')" 
           #PREPARE qcc_sel1 FROM l_sql
           #EXECUTE qcc_sel1 USING g_qcm.qcm021, g_qcn[l_ac].qcn04
           #     INTO l_qcc05,l_qcc061,l_qcc062,l_qcc07                     
           #IF STATUS=100 THEN
           #EXECUTE qcc_sel1 USING '*', g_qcn[l_ac].qcn04
           #     INTO l_qcc05,l_qcc061,l_qcc062,l_qcc07
           #IF STATUS=100 THEN
           #LET l_sql = " SELECT qck07,qck05,qck061,qck062 ",
           #            " FROM qck_file,ima_file ",
           #            " WHERE ima01=? AND qck01=ima109 AND qck02=? ",
           #            " AND qck08 in ('3','9')"
           #    PREPARE qck_sel1 FROM l_sql
           #    EXECUTE qck_sel1 USING g_qcm.qcm021, g_qcn[l_ac].qcn04
           #      INTO l_qcc07,l_qcc05,l_qcc061,l_qcc062                   
           #   IF STATUS=100 THEN
           #      LET l_qcc07='N'
           #   END IF
           #END IF                     #No.FUN-990071
           #END IF
           #MOD-C70114 end mark-----
            CALL t510_get_qcd07(g_qcn[l_ac].qcn04) RETURNING l_qcc07,l_qcc05,l_qcc061,l_qcc062   #MOD-C70114 add
            IF g_qcn[l_ac].qcn11>0 AND l_qcc07='Y' AND g_qcz.qcz01='Y' THEN
               CALL t510_more_b1(g_qcn[l_ac].qcn11,l_qcc05,l_qcc061,l_qcc062,
                                 g_qcn[l_ac].qcn03,g_qcn[l_ac].qcn04)
                DISPLAY BY NAME g_qcn[l_ac].qcn07 #MOD-530670
               #----- 測量值總數量是否符合應檢驗數
               SELECT COUNT(*) INTO g_cnt FROM qcnn_file
                WHERE qcnn01=g_qcm.qcm01
                  AND qcnn03=g_qcn[l_ac].qcn03
               IF g_cnt != g_qcn[l_ac].qcn11 THEN
                  LET g_msg=g_cnt,': ',g_qcn[l_ac].qcn11
                  CALL cl_err(g_msg,'aqc-038',0)
                  NEXT FIELD qcn11
               END IF
            END IF

           #MOD-CB0153---add---S
            IF g_qcn[l_ac].qcn11 > g_qcm.qcm22 THEN
               CALL cl_err(g_qcn[l_ac].qcn11,'aqc-888',1)
               NEXT FIELD qcn11
            END IF
           #MOD-CB0153---add---E
 
            IF g_qcn[l_ac].qcn07 IS NULL THEN LET g_qcn[l_ac].qcn07=0 END IF
 
        AFTER FIELD qcn07
            #MOD-C30634--mark--str--
            #IF g_qcn[l_ac].qcn07 > g_qcn[l_ac].qcn11 THEN
            #   #不良數量應<=檢驗量
            #   CALL cl_err(g_qcn[l_ac].qcn07,'aqc-112',0)
            #   LET g_qcn[l_ac].qcn07 = g_qcn_t.qcn07
            #   DISPLAY BY NAME g_qcn[l_ac].qcn07
            #   NEXT FIELD qcn07
            #END IF
            #MOD-C30634--mark--end--
            IF g_qcn[l_ac].qcn07>0 THEN
               CALL t510_more_b()
            END IF
#No.FUN-A80063 --begin
            #---- 項目判定
           #MOD-C70114 str mark-----
           #LET l_sql = " SELECT qcc01,qcc02,qcc03,qcc04,qcc05,qcc061,qcc062,qcc07, ",
           #            "        qccacti,qccuser,qccgrup,qccmodu,qccdate,qcc08,qccorig,qccoriu ",
           #            " FROM qcc_file ",
           #            " WHERE qcc01=? AND qcc02=? ",
           #            " AND qcc08 in ('3','9')" 
           #PREPARE qcc_sel11 FROM l_sql
           #EXECUTE qcc_sel11 USING g_qcm.qcm021, g_qcn[l_ac].qcn04
           #     INTO l_qcd.*                  
           #IF STATUS=100 THEN
           #   EXECUTE qcc_sel1 USING '*', g_qcn[l_ac].qcn04
           #        INTO l_qcd.*
           #   IF STATUS=100 THEN
           #      LET l_sql = " SELECT qck_file.* ",
           #                  " FROM qck_file,ima_file ",
           #                  " WHERE ima01=? AND qck01=ima109 AND qck02=? ",
           #                  " AND qck08 in ('3','9')"
           #      PREPARE qck_sel11 FROM l_sql
           #      EXECUTE qck_sel11 USING g_qcm.qcm021, g_qcn[l_ac].qcn04
           #        INTO l_qcd.*              
           #      IF STATUS=100 THEN
           #         LET l_qcc07='N'
           #      END IF
           #   END IF                     #No.FUN-990071
           #END IF
           #MOD-C70114 end mark
            CALL t510_get_qcd07(g_qcn[l_ac].qcn04) RETURNING l_qcd.qcd07,l_qcd.qcd05,l_qcd.qcd061,l_qcd.qcd062   #MOD-C70114 add
            IF l_qcd.qcd05 ='4' THEN 
               SELECT SUM(qcnn04) INTO l_qcnn04
                 FROM qcnn_file
                WHERE qcnn01 = g_qcm.qcm01
                  AND qcnn02 = g_qcm.qcm02
                  AND qcnn021= g_qcm.qcm05
                  AND qcnn03 = g_qcn[l_ac].qcn03
               IF cl_null(l_qcnn04) THEN 
                  LET l_qcnn04 = 0
               END IF  
               LET l_avg = l_qcnn04 / g_qcn[l_ac].qcn11
               
               LET l_sum = 0 
               DECLARE qcnn_sel CURSOR FOR 
                 SELECT qcnn04 FROM qcnn_file
                  WHERE qcnn01 = g_qcm.qcm01
                    AND qcnn02 = g_qcm.qcm02
                    AND qcnn021= g_qcm.qcm05
                    AND qcnn03 = g_qcn[l_ac].qcn03
               FOREACH qcnn_sel INTO l_qcnn04
                 LET l_sum = l_sum + ((l_qcnn04 - l_avg)*(l_qcnn04 - l_avg))
               END FOREACH 
               LET l_stddev = s_power(l_sum/(g_qcn[l_ac].qcn11 -1),2)
               LET l_k_max  = (l_qcd.qcd062 - l_avg)/l_stddev
               LET l_k_min  = (l_avg - l_qcd.qcd061)/l_stddev
               LET l_f      = l_stddev/(l_qcd.qcd062 - l_qcd.qcd061)
               IF cl_null(l_qcd.qcd061) OR cl_null(l_qcd.qcd061) THEN 
                  IF cl_null(l_qcd.qcd061) THEN 
                     IF l_k_max >= g_qcn[l_ac].qcn14 THEN 
                        LET g_qcn[l_ac].qcn08 ='1'
                     ELSE
                     	 LET g_qcn[l_ac].qcn08 ='2'
                     END IF  
                  ELSE 
                     IF l_k_min >= g_qcn[l_ac].qcn14 THEN 
                        LET g_qcn[l_ac].qcn08 ='1'
                     ELSE
                     	 LET g_qcn[l_ac].qcn08 ='2'
                     END IF 
                  END IF 
               ELSE 
               	 IF l_k_min >= g_qcn[l_ac].qcn14 AND l_k_max >= g_qcn[l_ac].qcn14 AND l_f >= g_qcn[l_ac].qcn15 THEN 
                     LET g_qcn[l_ac].qcn08 ='1'
                  ELSE 
                  	 LET g_qcn[l_ac].qcn08 ='2'
                  END IF 
               END IF 
            ELSE 
#No.FUN-A80063 --end  
             #在判定合格或驗退時，應先將缺點數乘上CR/MA/MI權數
               CASE g_qcn[l_ac].qcn05
                   WHEN "1"
                         LET l_chkqty = g_qcn[l_ac].qcn07*g_qcz.qcz02/g_qcz.qcz021   #No.TQC-750209 modify 
                   WHEN "2"
                         LET l_chkqty = g_qcn[l_ac].qcn07*g_qcz.qcz03/g_qcz.qcz031   #No.TQC-750209 modify  
                   WHEN "3"
                         LET l_chkqty = g_qcn[l_ac].qcn07*g_qcz.qcz04/g_qcz.qcz041   #No.TQC-750209 modify 
                   OTHERWISE
                         LET l_chkqty = g_qcn[l_ac].qcn07                            #No.TQC-750209 modify
               END CASE
               IF l_chkqty>=g_qcn[l_ac].qcn10 THEN          #No.TQC-750209 modify
                  LET g_qcn[l_ac].qcn08='2'
               ELSE
                  LET g_qcn[l_ac].qcn08='1'
               END IF
            END IF                             #No.FUN-A80063
 
            CASE g_qcn[l_ac].qcn08
                 WHEN '1' CALL cl_getmsg('aqc-004',g_lang)
                               RETURNING g_qcn[l_ac].qcn08_desc
                 WHEN '2' CALL cl_getmsg('aqc-033',g_lang)
                               RETURNING g_qcn[l_ac].qcn08_desc
            END CASE
            DISPLAY BY NAME g_qcn[l_ac].qcn08_desc
            DISPLAY BY NAME g_qcn[l_ac].qcn08
 
        BEFORE DELETE                            #是否取消單身
            IF g_qcn_t.qcn03 > 0 AND
               g_qcn_t.qcn03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM qcn_file
                 WHERE qcn01 = g_qcm.qcm01
                   AND qcn03 = g_qcn_t.qcn03
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","qcn_file",g_qcm.qcm01,g_qcn_t.qcn03,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                   ROLLBACK WORK
                   CANCEL DELETE
                ELSE
                    DELETE FROM qcu_file
                    WHERE qcu01 = g_qcm.qcm01
                      AND qcu03 = g_qcn_t.qcn03
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_qcn[l_ac].* = g_qcn_t.*
               CLOSE t510_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_qcn[l_ac].qcn03,-263,1)
               LET g_qcn[l_ac].* = g_qcn_t.*
            ELSE
               IF g_qcn[l_ac].qcn07=0 THEN
                  DELETE FROM qcu_file
                   WHERE qcu01=g_qcm.qcm01
                     AND qcu03=g_qcn[l_ac].qcn03
               END IF
               UPDATE qcn_file SET qcn03=g_qcn[l_ac].qcn03,
                                   qcn04=g_qcn[l_ac].qcn04,
                                   qcn05=g_qcn[l_ac].qcn05,
                                   qcn06=g_qcn[l_ac].qcn06,
                                   qcn07=g_qcn[l_ac].qcn07,
                                   qcn08=g_qcn[l_ac].qcn08,
                                   qcn09=g_qcn[l_ac].qcn09,
                                   qcn10=g_qcn[l_ac].qcn10,
                                   qcn11=g_qcn[l_ac].qcn11,
                                   qcn12=l_qcc05,
                                   qcnud01=g_qcn[l_ac].qcnud01,
                                   qcnud02=g_qcn[l_ac].qcnud02,
                                   qcnud03=g_qcn[l_ac].qcnud03,
                                   qcnud04=g_qcn[l_ac].qcnud04,
                                   qcnud05=g_qcn[l_ac].qcnud05,
                                   qcnud06=g_qcn[l_ac].qcnud06,
                                   qcnud07=g_qcn[l_ac].qcnud07,
                                   qcnud08=g_qcn[l_ac].qcnud08,
                                   qcnud09=g_qcn[l_ac].qcnud09,
                                   qcnud10=g_qcn[l_ac].qcnud10,
                                   qcnud11=g_qcn[l_ac].qcnud11,
                                   qcnud12=g_qcn[l_ac].qcnud12,
                                   qcnud13=g_qcn[l_ac].qcnud13,
                                   qcnud14=g_qcn[l_ac].qcnud14,
                                   qcnud15=g_qcn[l_ac].qcnud15
               WHERE qcn01=g_qcm.qcm01 AND
                     qcn03=g_qcn_t.qcn03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","qcn_file",g_qcm.qcm01,g_qcn_t.qcn03,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                 LET g_qcn[l_ac].* = g_qcn_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_qcn[l_ac].* = g_qcn_t.*
               END IF
               CLOSE t510_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE t510_bcl
            COMMIT WORK
            LET l_length = g_qcn.getlength()
            IF l_ac = l_length THEN 
                EXIT INPUT
            END IF
 
        ON ACTION reason
            IF g_qcn[l_ac].qcn07>0 THEN
               CALL t510_more_b()
            END IF
 
        ON ACTION memo
           CASE WHEN INFIELD(qcn11)
                     CALL t510_b_memo()
                OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLN
            CALL t510_b_askkey()
            EXIT INPUT
 
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
 
        ON ACTION controls                           #No.FUN-6B0032             
           CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    END INPUT
 
    LET g_qcm.qcmmodu = g_user
    LET g_qcm.qcmdate = g_today
    UPDATE qcm_file SET qcmmodu = g_qcm.qcmmodu,qcmdate = g_qcm.qcmdate
     WHERE qcm01 = g_qcm.qcm01
    DISPLAY BY NAME g_qcm.qcmmodu,g_qcm.qcmdate
 
    CLOSE t510_bcl
    COMMIT WORK
 
    #------------------------------------------------- 單身不良總合判定
    LET l_cnt=0 LET l_numcr=0 LET l_numma=0 LET l_nummi=0
 
    SELECT COUNT(*) INTO l_cnt FROM qcn_file
     WHERE qcn01=g_qcm.qcm01
       AND qcn08='2'
 
    IF l_cnt>0 THEN
       LET g_qcm.qcm09='2'
    ELSE
       LET g_qcm.qcm09='1'
    END IF
 
    #--------- CR 不良數
    SELECT SUM(qcn07) INTO l_numcr FROM qcn_file
     WHERE qcn01=g_qcm.qcm01 AND qcn05='1'
    IF l_numcr IS NULL THEN LET l_numcr=0 END IF
    #--------- MA 不良數
    SELECT SUM(qcn07) INTO l_numma FROM qcn_file
       WHERE qcn01=g_qcm.qcm01 AND qcn05='2'
    IF l_numma IS NULL THEN LET l_numma=0 END IF
    #--------- MI 不良數
    SELECT SUM(qcn07) INTO l_nummi FROM qcn_file
       WHERE qcn01=g_qcm.qcm01 AND qcn05='3'
    IF l_nummi IS NULL THEN LET l_nummi=0 END IF
 
    IF g_qcm.qcm09 = '1' THEN 
       LET g_qcm.qcm091=g_qcm.qcm22
    ELSE
         LET g_qcm.qcm091=0    #'2':重工=>合格量default為0 (即預設全退)
    END IF
 
    CASE g_qcm.qcm09
         WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING des1
         WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING des1
    END CASE
 
    DISPLAY des1 TO FORMONLY.des1
    DISPLAY BY NAME g_qcm.qcm091,g_qcm.qcm09,g_qcm.qcm13
 
    UPDATE qcm_file SET qcm091=g_qcm.qcm091,qcm09=g_qcm.qcm09                   
     WHERE qcm01=g_qcm.qcm01                                                    
    
    CALL t510_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t510_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_qcm.qcm01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM qcm_file ",
                  "  WHERE qcm01 LIKE '",l_slip,"%' ",
                  "    AND qcm01 > '",g_qcm.qcm01,"'"
      PREPARE t510_pb1 FROM l_sql 
      EXECUTE t510_pb1 INTO l_cnt
      
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
        #CALL t510_x()   #FUN-D20025
         CALL t510_x(1)  #FUN-D20025
         IF g_qcm.qcm14 = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_qcm.qcm14,"","","",g_void,g_qcm.qcmacti)
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM qco_file WHERE qco01 = g_qcm.qcm01
                                AND qco02 = 0
                                AND qco05 = 0
 
         DELETE FROM qcnn_file WHERE qcnn01 = g_qcm.qcm01
         DELETE FROM qcv_file WHERE qcv01 = g_qcm.qcm01  
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM qcm_file WHERE qcm01=g_qcm.qcm01
         INITIALIZE g_qcm.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t510_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-680104 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON qcn03,qcn04,qcn05,qcn06,qcn09,qcn10,qcn14,qcn15,qcn11,       #No.FUN-A80063
                       qcn07,qcn08
            FROM s_qcn[1].qcn03,s_qcn[1].qcn04,s_qcn[1].qcn05,
                 s_qcn[1].qcn06,s_qcn[1].qcn09,
                 s_qcn[1].qcn10,s_qcn[1].qcn14,s_qcn[1].qcn15,s_qcn[1].qcn11,       #No.FUN-A80063
                 s_qcn[1].qcn07,s_qcn[1].qcn08
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
 
    CALL t510_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION t510_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    l_qcn12         LIKE qcn_file.qcn12,
    p_wc2           LIKE type_file.chr1000 #No.FUN-680104 VARCHAR(200)
 
    IF p_wc2 IS NULL THEN LET p_wc2=" 1=1 " END IF
    LET g_sql =
        "SELECT qcn03,qcn04,azf03,qcn05,qcn06,qcn09,qcn10,qcn14,qcn15,qcn11,",   #No.FUN-A80063
        "       qcn07,qcn08,' ',", #qcn12 ",
        "       qcnud01,qcnud02,qcnud03,qcnud04,qcnud05,",
        "       qcnud06,qcnud07,qcnud08,qcnud09,qcnud10,",
        "       qcnud11,qcnud12,qcnud13,qcnud14,qcnud15,",
        "       qcn12",
        " FROM qcn_file, OUTER azf_file ",
        " WHERE qcn01 ='",g_qcm.qcm01,"'",
        "   AND qcn_file.qcn04 = azf_file.azf01 AND azf_file.azf02='6' ",
        "   AND ",p_wc2 CLIPPED,
        " ORDER BY 1"
    PREPARE t510_pb FROM g_sql
    DECLARE qcn_curs                       #SCROLL CURSOR
        CURSOR FOR t510_pb
 
    CALL g_qcn.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
 
    FOREACH qcn_curs INTO g_qcn[g_cnt].*   #單身 ARRAY 填充
        LET g_rec_b = g_rec_b + 1
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        CASE g_qcn[g_cnt].qcn08
             WHEN '1' CALL cl_getmsg('aqc-004',g_lang)
                           RETURNING g_qcn[g_cnt].qcn08_desc
             WHEN '2' CALL cl_getmsg('aqc-033',g_lang)
                           RETURNING g_qcn[g_cnt].qcn08_desc
        END CASE
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
 
    END FOREACH
    CALL g_qcn.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t510_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680104 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   IF g_aza.aza64 matches '[ Nn]' OR g_aza.aza64 IS NULL THEN
      CALL cl_set_act_visible("trans_spc",FALSE)
      CALL cl_set_comp_visible("qcmspc",FALSE)
   END IF
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qcn TO s_qcn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
         CALL t510_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t510_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t510_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t510_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t510_fetch('L')
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
         IF g_qcm.qcm14 = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_qcm.qcm14,"","","",g_void,g_qcm.qcmacti)
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#@    ON ACTION 單身不良原因
      ON ACTION detail_flaw_reason
         LET g_action_choice="detail_flaw_reason"
         EXIT DISPLAY
#@    ON ACTION 單身測量值查詢
      ON ACTION qry_detail_measure
         LET g_action_choice="qry_detail_measure"
         EXIT DISPLAY
#@    ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
#@    ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
#@    ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
#@    ON ACTION 特採
      ON ACTION special_purchase
         LET g_action_choice="special_purchase"
         EXIT DISPLAY
#FUN-A30045 --------------------Begin----------------
      ON ACTION cancel_special_purchase
         LET g_action_choice="cancel_special_purchase"
         EXIT DISPLAY                  
#FUN-A30045 --------------------End------------------

#FUN-BC0104 --------------------Begin----------------
      ON ACTION qc_item_maintain
         LET g_action_choice="qc_item_maintain"
         EXIT DISPLAY      
#FUN-BC0104 --------------------End------------------

#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
#FUN-D20025---add---str--
#@    ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
#FUN-D20025---add---str--
 
      ON ACTION accept
         LET g_action_choice="detail"           #MOD-880246  add
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
#@    ON ACTION 拋轉至SPC     #FUN-680010
      ON ACTION trans_spc
         LET g_action_choice="trans_spc"
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0160  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
#     &include "qry_string.4gl"    #TQC-B60148
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION t510_defqty(l_def,l_rate,l_level,l_type)       #No.FUN-A80063 add l_level l_type
    DEFINE l_def       LIKE type_file.num5,         #No.FUN-680104 SMALLINT #00-12-29   1:單頭入 2.單身入
           l_rate      LIKE qcc_file.qcc04,
           l_qcb04     LIKE qcb_file.qcb04
    DEFINE l_pmh09     LIKE pmh_file.pmh09,
           l_pmh15     LIKE pmh_file.pmh15,
           l_pmh16     LIKE pmh_file.pmh16,
           l_qca03     LIKE qca_file.qca03,
           l_qca04     LIKE qca_file.qca04,
           l_qca05     LIKE qca_file.qca05,
           l_qca06     LIKE qca_file.qca06
   DEFINE l_qty     LIKE type_file.num10          #No.MOD-7C0145 add
#No.FUN-A80063 --begin
   DEFINE l_level   LIKE qcd_file.qcd03
   DEFINE l_type    LIKE qcd_file.qcd05
   DEFINE l_qdg04   LIKE qdg_file.qdg04
   DEFINE l_qcd03   LIKE qcd_file.qcd03
   DEFINE l_qdf02   LIKE qdf_file.qdf02
#No.FUN-A80063 --end
 
   #對送驗量做四捨五入
    LET l_qty = g_qcm22
    LET g_qcm22 = l_qty
    SELECT ima100,ima101,ima102 INTO l_pmh09,l_pmh15,l_pmh16 FROM ima_file
     WHERE ima01=g_qcm.qcm021
    IF STATUS THEN
       IF STATUS THEN
          LET l_pmh09='' LET l_pmh15='' LET l_pmh16='' RETURN 0
       END IF
    END IF
    IF l_pmh09 IS NULL OR l_pmh09=' ' THEN RETURN 0 END IF
    IF l_pmh15 IS NULL OR l_pmh15=' ' THEN RETURN 0 END IF
    IF l_pmh16 IS NULL OR l_pmh16=' ' THEN RETURN 0 END IF
 
    IF l_pmh15='1' THEN
       IF l_def=1 THEN
          SELECT qca03,qca04,qca05,qca06
            INTO l_qca03,l_qca04,l_qca05,l_qca06 FROM qca_file
           WHERE g_qcm22 BETWEEN qca01 AND qca02        #bugno:7196
             AND qca07=g_qcm.qcm17
          IF STATUS THEN RETURN 0 END IF
       ELSE #單身入
          SELECT qcb04 INTO l_qcb04 FROM qca_file,qcb_file
           WHERE (g_qcm22 BETWEEN qca01 AND qca02)       #bugno:7196
             AND qcb02=l_rate
             AND qca03=qcb03
             AND qca07=g_qcm.qcm17
             AND qcb01=g_qcm.qcm21
           IF NOT cl_null(l_qcb04) THEN
              SELECT UNIQUE qca03,qca04,qca05,qca06    #No.FUN-740116 add unique
                INTO l_qca03,l_qca04,l_qca05,l_qca06 FROM qca_file
               WHERE qca03=l_qcb04
              IF STATUS THEN LET l_qca03=0 LET l_qca04=0
                             LET l_qca05=0 LET l_qca06=0
              END IF
           END IF
        END IF
    END IF
    IF l_pmh15='2' THEN
       IF l_def=1 THEN
          SELECT qch03,qch04,qch05,qch06
            INTO l_qca03,l_qca04,l_qca05,l_qca06 FROM qch_file
           WHERE g_qcm22 BETWEEN qch01 AND qch02       #bugno:7196
             AND qch07=g_qcm.qcm17
          IF STATUS THEN RETURN 0 END IF
       ELSE #單身入
          SELECT qcb04 INTO l_qcb04 FROM qch_file,qcb_file
           WHERE (g_qcm22 BETWEEN qch01 AND qch02)       #bugno:7196
             AND qcb02=l_rate
             AND qch03=qcb03
             AND qch07=g_qcm.qcm17
             AND qcb01=g_qcm.qcm21
           IF NOT cl_null(l_qcb04) THEN
              SELECT UNIQUE qch03,qch04,qch05,qch06      #No.FUN-740116 add unique
                INTO l_qca03,l_qca04,l_qca05,l_qca06 FROM qch_file
               WHERE qch03=l_qcb04
              IF STATUS THEN LET l_qca03=0 LET l_qca04=0
                             LET l_qca05=0 LET l_qca06=0
              END IF
           END IF
        END IF
    END IF
 
   IF g_qcm22 = 1 THEN
      LET l_qca04 = 1
      LET l_qca05 = 1
      LET l_qca06 = 1
   END IF

#No.FUN-A80063 --begin 
#   CASE l_pmh09
#      WHEN 'N'
#         RETURN l_qca04
#      WHEN 'T'
#         RETURN l_qca05
#      WHEN 'R'
#         RETURN l_qca06
#      OTHERWISE
#         RETURN 0
#   END CASE

  IF l_type ='1' OR l_type ='2' THEN 
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
  END IF 
  IF l_type ='3' OR l_type ='4' THEN 
      CASE l_pmh09
         WHEN 'N'
            LET l_qcd03 = l_level
         WHEN 'T'
            LET l_qcd03 = l_level+1
            IF l_qcd03 = 8 THEN 
               LET l_qcd03 ='T'
            END IF 
         WHEN 'R'
            LET l_qcd03 = l_level-1
            IF l_qcd03 = 0 THEN 
               LET l_qcd03 ='R'
            END IF 
         OTHERWISE
            RETURN 0
      END CASE  
      SELECT qdf02 INTO l_qdf02
        FROM qdf_file
       WHERE (g_qcf.qcf22 BETWEEN qdf03 AND qdf04) 
         AND qdf01 = l_qcd03
      SELECT qdg04 INTO l_qdg04
        FROM qdg_file
       WHERE qdg01 = g_ima101
         AND qdg02 = l_qcd03
         AND qdg03 = l_qdf02
      IF SQLCA.sqlcode THEN 
         LET l_qdg04 = 0
      END IF    
      RETURN l_qdg04
   END IF 
#No.FUN-A80063 --end 
 
END FUNCTION
 
FUNCTION t510_y()
 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_qcm.* FROM qcm_file WHERE qcm01=g_qcm.qcm01
   IF g_qcm.qcm14 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_qcm.qcm14 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
 
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
 
   BEGIN WORK
 
   OPEN t510_cl USING g_qcm.qcm01
   IF STATUS THEN
      CALL cl_err("OPEN t510_cl:", STATUS, 1)
      CLOSE t510_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t510_cl INTO g_qcm.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcm.qcm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t510_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
   UPDATE qcm_file SET qcm14='Y',
                       qcm15=g_today
    WHERE qcm01=g_qcm.qcm01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN LET g_success='N' END IF
 
   IF g_success = 'Y' THEN
      LET g_qcm.qcm14='Y'  LET g_qcm.qcm15=g_today
      COMMIT WORK
      CALL cl_flow_notify(g_qcm.qcm01,'Y')
      DISPLAY BY NAME g_qcm.qcm14,g_qcm.qcm15
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION t510_z()
  DEFINE l_outqty LIKE ecm_file.ecm311
  DEFINE l_qcm091 LIKE qcm_file.qcm091   #TQC-AB0332
  DEFINE l_qcm091_sum LIKE qcm_file.qcm091   #TQC-AB0332
 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_qcm.* FROM qcm_file WHERE qcm01=g_qcm.qcm01
   IF g_qcm.qcm14 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_qcm.qcm14 = 'N' THEN RETURN END IF
   IF g_qcm.qcm09 = '3' THEN
      CALL cl_err(g_qcm.qcm01,'aqc-410',0)
      RETURN
   END IF #BugNo:5046
 
   #-->已報工則不可取消確認
  #SELECT (ecm311+ecm312) INTO l_outqty FROM ecm_file  #TQC-AB0332
   SELECT (ecm311+ecm312+ecm313+ecm314+ecm316) INTO l_outqty FROM ecm_file #TQC-AB0332
    WHERE ecm01 = g_qcm.qcm02 AND ecm03 = g_qcm.qcm05
      AND ecm012 = g_qcm.qcm012                         #FUN-A60027
   IF STATUS OR cl_null(l_outqty) THEN  LET l_outqty = 0 END IF
  #TQC-ABO332--begin--add-------
   SELECT sum(qcm091) INTO l_qcm091 FROM qcm_file
    WHERE qcm02 = g_qcm.qcm02 AND qcm05 = g_qcm.qcm05
      AND qcm012 = g_qcm.qcm012  AND qcm14='Y'
   IF STATUS OR cl_null(l_qcm091) THEN  LET l_qcm091 = 0 END IF
   LET l_qcm091_sum=l_qcm091 - g_qcm.qcm091
   IF l_outqty > l_qcm091_sum AND g_qcm.qcm00 = '1' THEN     #MOD-C30557 add g_qcm.qcm00 = '1'
  #TQC-AB0332--end--add----
  #IF l_outqty > 0 THEN  #TQC-AB0332
      CALL cl_err(l_outqty,'aqc-024',0)
      RETURN
   END IF
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
   BEGIN WORK
 
   OPEN t510_cl USING g_qcm.qcm01
   IF STATUS THEN
      CALL cl_err("OPEN t510_cl:", STATUS, 1)
      CLOSE t510_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t510_cl INTO g_qcm.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcm.qcm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t510_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
   UPDATE qcm_file SET qcm14='N',
                       #qcm15=''      #CHI-C80072
                       qcm15=g_today  #CHI-C80072
    WHERE qcm01=g_qcm.qcm01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      LET g_qcm.qcm14='N'
      #LET g_qcm.qcm15=''      #CHI-C80072
      LET g_qcm.qcm15=g_today  #CHI-C80072
      DISPLAY BY NAME g_qcm.qcm14,g_qcm.qcm15
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
#FUNCTION t510_x()      #FUN-D20025
FUNCTION t510_x(p_type) #FUN-D20025
   DEFINE l_qcmspc        LIKE qcm_file.qcmspc     #FUN-680010
   DEFINE p_type    LIKE type_file.num5     #FUN-D20025
   DEFINE l_flag    LIKE type_file.chr1     #FUN-D20025
 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_qcm.* FROM qcm_file WHERE qcm01=g_qcm.qcm01
 
   IF g_qcm.qcm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_qcm.qcm14 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF

   #FUN-D20025--add--str--
   IF p_type = 1 THEN 
      IF g_qcm.qcm14='X' THEN RETURN END IF
   ELSE
      IF g_qcm.qcm14<>'X' THEN RETURN END IF
   END IF
   #FUN-D20025--add--end--
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t510_cl USING g_qcm.qcm01
   IF STATUS THEN
      CALL cl_err("OPEN t510_cl:", STATUS, 1)
      CLOSE t510_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t510_cl INTO g_qcm.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcm.qcm01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t510_cl ROLLBACK WORK RETURN
   END IF
 
#  IF cl_void(0,0,g_qcm.qcm14)   THEN   #FUN-D20025
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF  #FUN-D20025
   IF cl_void(0,0,l_flag) THEN         #FUN-D20025   
     #IF g_qcm.qcm14 ='N' THEN    #FUN-D20025
      IF p_type = 1 THEN          #FUN-D20025
         LET g_qcm.qcm14='X'
      ELSE
         LET g_qcm.qcm14='N'
      END IF
 
      LET l_qcmspc = '0'            #FUN-680010
 
      UPDATE qcm_file SET qcm14  = g_qcm.qcm14,
                          qcmspc = l_qcmspc,       #FUN-680010
                          qcmmodu=g_user,
                          qcmdate=TODAY,qcm15 = TODAY
       WHERE qcm01 = g_qcm.qcm01
      IF STATUS THEN
         CALL cl_err3("upd","qcm_file",g_qcm.qcm01,"",SQLCA.sqlcode,"","upd qcm14",1)  #No.FUN-660115
         LET g_success='N'  
      END IF
 
      IF g_aza.aza64 NOT matches '[ Nn]' THEN 
         # CALL aws_spccli()
         #功能: 通知 SPC 端刪除此張單據
         # 傳入參數: (1) QC 程式代號, (2) QC 單頭資料,(3)功能選項：insert(新增),delete(刪除)
         # 回傳值  : 0 傳送失敗; 1 傳送成功
         IF g_qcm.qcmspc = '1' THEN
            IF NOT aws_spccli(g_prog,base.TypeInfo.create(g_qcm),'delete')
            THEN
                 CLOSE t510_cl
                 ROLLBACK WORK
                 RETURN
            END IF
         END IF
      END IF
 
      IF g_success='Y' THEN
         COMMIT WORK
         CALL cl_flow_notify(g_qcm.qcm01,'V')
      ELSE
         ROLLBACK WORK
      END IF
 
   END IF
 
   SELECT qcm14,qcm15,qcmspc INTO g_qcm.qcm14,g_qcm.qcm15,g_qcm.qcmspc FROM qcm_file  #FUN-680010
    WHERE qcm01 = g_qcm.qcm01
   DISPLAY BY NAME g_qcm.qcm14,g_qcm.qcm15,g_qcm.qcmspc #FUN-680010
 
END FUNCTION
 
FUNCTION t510_g_b()
    DEFINE l_cnt    LIKE type_file.num5    #No.FUN-680104 SMALLINT
    DEFINE l_yn     LIKE type_file.num5    #No.FUN-680104 SMALLINT
    DEFINE l_qcc    RECORD LIKE qcc_file.*
    DEFINE l_qcd    RECORD LIKE qcd_file.*        #No.TQC-6A0015 add   
    DEFINE l_qck    RECORD LIKE qck_file.*        #No.TQC-6A0015 add
    DEFINE l_qcn11  LIKE qcn_file.qcn11
    DEFINE m_ecm04  LIKE ecm_file.ecm04
    DEFINE seq      LIKE type_file.num5         #No.FUN-680104 SMALLINT
    DEFINE l_ac_num,l_re_num  LIKE type_file.num5         #No.FUN-680104 SMALLINT
    DEFINE l_sql    STRING      #No.FUN-910079
    DEFINE l_qcc01  LIKE qcc_file.qcc01    #No.FUN-990071
#No.FUN-A80063 --begin
    DEFINE l_qdf02   LIKE qdf_file.qdf02
    DEFINE l_qcn14   LIKE qcn_file.qcn14
    DEFINE l_qcn15   LIKE qcn_file.qcn15
#No.FUN-A80063 --end 

 
    LET seq=1
    SELECT COUNT(*) INTO l_cnt FROM qcn_file WHERE qcn01=g_qcm.qcm01
    IF l_cnt=0 THEN
       SELECT ecm04 INTO m_ecm04 FROM ecm_file
        WHERE ecm01 = g_qcm.qcm02 AND ecm03 = g_qcm.qcm05
          AND ecm012 = g_qcm.qcm012                        #FUN-A60027    
       #-------------------------------------------------------
       #先抓"站別料件檢驗項目"，抓不到就抓"料件檢驗項目"
       #若再抓不到的話就抓"料件類別檢驗項目"
       #--------------------------------------------------------
            LET l_sql = "  SELECT COUNT(*)  FROM qcc_file WHERE qcc01=? ", 
                        " AND qcc011=?",
                        " AND qcc08 in ('3','9')" 
         
            PREPARE qcc_sel2 FROM l_sql
            EXECUTE qcc_sel2 USING g_qcm.qcm021,m_ecm04
                 INTO l_yn                              
        LET l_qcc01=g_qcm.qcm021
        IF l_yn<=0 THEN
          EXECUTE qcc_sel2 USING '*',m_ecm04
             INTO l_yn
          IF l_yn>0 THEN
             LET l_qcc01='*'
          END IF
        END IF
       IF l_yn > 0 THEN
          #-----------------
          #站別料件檢驗項目
          #-----------------
          LET l_sql = "SELECT * from qcc_file ",
                      " WHERE qcc01=? AND qcc011=? ",
                      " AND qcc08 in ('3','9') ORDER BY qcc02 "
            PREPARE qcc_cur1 FROM l_sql                       
            DECLARE qcc_cur CURSOR FOR qcc_cur1
           FOREACH qcc_cur  USING l_qcc01,m_ecm04 INTO l_qcc.*     #No.FUN-990071
#No.FUN-A80063 --begin
#              IF l_qcc.qcc05='1' THEN
#                 #-------- Ac,Re 數量賦予
#                 CALL s_newaql(g_qcm.qcm021,' ',l_qcc.qcc04,g_qcm.qcm22,' ','1')  #MOD-890223 add ' ','1'
#                      RETURNING l_ac_num,l_re_num
#                 CALL t510_defqty(2,l_qcc.qcc04)
#                      RETURNING l_qcn11
#              ELSE
#                 LET l_ac_num=0 LET l_re_num=1
#                 SELECT qcj05 INTO l_qcn11
#                   FROM qcj_file
#                  WHERE (g_qcm.qcm22 BETWEEN qcj01 AND qcj02)
#                    AND qcj03=l_qcc.qcc04
#                    AND qcj04=g_qcm.qcm17     #No.MOD-820049 add
#                 IF STATUS THEN LET l_qcn11=0 END IF
#                 IF g_qcm22 = 1 THEN
#                    LET l_qcn11 = 1
#                 END IF
#              END IF

              CASE l_qcc.qcc05
               WHEN '1'   #一般
                 CALL s_newaql(g_qcm.qcm021,' ',l_qcc.qcc04,g_qcm.qcm22,' ','1')  #MOD-890223 add ' ','1'
                      RETURNING l_ac_num,l_re_num
                 CALL t510_defqty(2,l_qcc.qcc04,l_qcc.qcc03,l_qcc.qcc05)
                      RETURNING l_qcn11
                 LET l_qcn14 =''
                 LET l_qcn15 =''
               WHEN '2'   #特殊
                 LET l_ac_num=0 LET l_re_num=1
                 SELECT qcj05 INTO l_qcn11
                   FROM qcj_file
                  WHERE (g_qcm.qcm22 BETWEEN qcj01 AND qcj02)
                    AND qcj03 = l_qcc.qcc04
                    AND qcj04 = g_qcm.qcm17   #No.MOD-820049 add
                 IF STATUS THEN
                    LET l_qcn11 = 0
                 END IF
                 IF g_qcm22 = 1 THEN
                    LET l_qcn11 = 1
                 END IF
                 LET l_qcn14 =''
                 LET l_qcn15 =''
               WHEN '3'   #1916 计数
                 LET l_ac_num =0
                 LET l_re_num =1
                 CALL t510_defqty(2,l_qcc.qcc04,l_qcc.qcc03,l_qcc.qcc05) RETURNING l_qcn11
                 LET l_qcn14 =''
                 LET l_qcn15 =''
              
               WHEN '4'   #1916 计量
                 LET l_ac_num =''
                 LET l_re_num =''
                 CALL t510_defqty(2,l_qcc.qcc04,l_qcc.qcc03,l_qcc.qcc05) RETURNING l_qcn11
                 SELECT qdf02 INTO l_qdf02
                   FROM qdf_file
                  WHERE (g_qcm.qcm22 BETWEEN qdf03 AND qdf04)
                    AND qdf01 = l_qcc.qcc03
                 SELECT qdg05,qdg06 INTO l_qcn14,l_qcn15
                   FROM qdg_file
                  WHERE qdg01 = g_ima101
                    AND qdg02 = l_qcc.qcc03
                    AND qdg03 = l_qdf02
                 IF SQLCA.sqlcode THEN 
                    LET l_qcn14 =0
                    LET l_qcn15 =0
                 END IF
              END CASE 
#No.FUN-A80063 --end           
              IF l_qcn11 > g_qcm.qcm22 THEN LET l_qcn11=g_qcm.qcm22 END IF
              IF cl_null(l_qcn11) THEN LET l_qcn11=0 END IF
          
               INSERT INTO qcn_file (qcn01,qcn03,qcn04,qcn05,qcn06,qcn07,  #No.MOD-470041
                                     qcn08,qcn09,qcn10,qcn11,qcn12,qcn131,qcn132,qcn14,qcn15,             #No.FUN-A80063
                                     qcnplant,qcnlegal)  #FUN-980007
                   VALUES(g_qcm.qcm01,seq,l_qcc.qcc02,l_qcc.qcc03,l_qcc.qcc04,
                          0,'1',l_ac_num,l_re_num,l_qcn11,l_qcc.qcc05,
                          l_qcc.qcc061,l_qcc.qcc062,l_qcn14,l_qcn15,             #No.FUN-A80063
                          g_plant,g_legal)               #FUN-980007
              LET seq=seq+1
          END FOREACH
       ELSE
            LET l_sql = "  SELECT COUNT(*)  FROM qcd_file WHERE qcd01=? ",
                        " AND qcd08 in ('3','9')"
            PREPARE qcd_sel2 FROM l_sql
            EXECUTE qcd_sel2 USING g_qcm.qcm021
                 INTO l_yn                              
          IF l_yn>0 THEN  #--- 料件檢驗項目
          #----------------
          #料件檢驗項目
          #----------------
          LET l_sql = "SELECT * from qcd_file ",
                      " WHERE qcd01=?  ",
                      " AND qcd08 in ('3','9') ORDER BY qcd02"
            PREPARE qcd_cur1 FROM l_sql                       
            DECLARE qcd_cur CURSOR FOR qcd_cur1
           FOREACH qcd_cur USING g_qcm.qcm021 INTO l_qcd.* 
#No.FUN-A80063 --begin
#                 IF l_qcd.qcd05='1' THEN
#                    #-------- Ac,Re 數量賦予
#                    CALL s_newaql(g_qcm.qcm021,' ',l_qcd.qcd04,g_qcm.qcm22,' ','1')  #MOD-890223 add ' ','1'
#                         RETURNING l_ac_num,l_re_num
#                    CALL t510_defqty(2,l_qcd.qcd04)
#                         RETURNING l_qcn11
#                 ELSE
#                    LET l_ac_num=0 LET l_re_num=1
#                    SELECT qcj05 INTO l_qcn11
#                      FROM qcj_file
#                     WHERE (g_qcm.qcm22 BETWEEN qcj01 AND qcj02)
#                       AND qcj03=l_qcd.qcd04
#                       AND qcj04=g_qcm.qcm17     #No.MOD-820049 add
#                    IF STATUS THEN LET l_qcn11=0 END IF
#                    IF g_qcm22 = 1 THEN
#                       LET l_qcn11 = 1
#                    END IF
#                 END IF

                 CASE l_qcd.qcd05
                  WHEN '1'   #一般
                    CALL s_newaql(g_qcm.qcm021,' ',l_qcd.qcd04,g_qcm.qcm22,' ','1')  #MOD-890223 add ' ','1'
                         RETURNING l_ac_num,l_re_num
                    CALL t510_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05)
                         RETURNING l_qcn11
                    LET l_qcn14 =''
                    LET l_qcn15 =''
                  WHEN '2'   #特殊
                    LET l_ac_num=0 LET l_re_num=1
                    SELECT qcj05 INTO l_qcn11
                      FROM qcj_file
                     WHERE (g_qcm.qcm22 BETWEEN qcj01 AND qcj02)
                       AND qcj03 = l_qcd.qcd04
                       AND qcj04 = g_qcm.qcm17   #No.MOD-820049 add
                    IF STATUS THEN
                       LET l_qcn11 = 0
                    END IF
                    IF g_qcm22 = 1 THEN
                       LET l_qcn11 = 1
                    END IF
                    LET l_qcn14 =''
                    LET l_qcn15 =''
                  WHEN '3'   #1916 计数
                    LET l_ac_num =0
                    LET l_re_num =1
                    CALL t510_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qcn11
                    LET l_qcn14 =''
                    LET l_qcn15 =''
                 
                  WHEN '4'   #1916 计量
                    LET l_ac_num =''
                    LET l_re_num =''
                    CALL t510_defqty(2,l_qcd.qcd04,l_qcd.qcd03,l_qcd.qcd05) RETURNING l_qcn11
                    SELECT qdf02 INTO l_qdf02
                      FROM qdf_file
                     WHERE (g_qcm.qcm22 BETWEEN qdf03 AND qdf04)
                       AND qdf01 = l_qcd.qcd03
                    SELECT qdg05,qdg06 INTO l_qcn14,l_qcn15
                      FROM qdg_file
                     WHERE qdg01 = g_ima101
                       AND qdg02 = l_qcd.qcd03
                       AND qdg03 = l_qdf02
                    IF SQLCA.sqlcode THEN 
                       LET l_qcn14 =0
                       LET l_qcn15 =0
                    END IF
                 END CASE 
#No.FUN-A80063 --end 
                 IF l_qcn11 > g_qcm.qcm22 THEN LET l_qcn11=g_qcm.qcm22 END IF
                 IF cl_null(l_qcn11) THEN LET l_qcn11=0 END IF
          
                 INSERT INTO qcn_file (qcn01,qcn03,qcn04,qcn05,qcn06,qcn07, 
                                      qcn08,qcn09,qcn10,qcn11,qcn12,qcn131,qcn132,qcn14,qcn15,                #No.FUN-A80063
                                      qcnplant,qcnlegal) #FUN-980007
                     VALUES(g_qcm.qcm01,seq,l_qcd.qcd02,l_qcd.qcd03,l_qcd.qcd04,
                            0,'1',l_ac_num,l_re_num,l_qcn11,l_qcd.qcd05,
                            l_qcc.qcc061,l_qcc.qcc062,l_qcn14,l_qcn15,             #No.FUN-A80063
                            g_plant,g_legal)             #FUN-980007 
                LET seq=seq+1
             END FOREACH
         ELSE
            #料件類別檢驗項目
            LET l_sql = " SELECT qck_file.* FROM qck_file,ima_file ",
                        " WHERE qck01=ima109 AND ima01=? ",
                        " AND qck08 in ('3','9') ORDER BY qck02 "   #TQC-980140
            PREPARE qck_cur1 FROM l_sql 
            DECLARE qck_cur CURSOR FOR qck_cur1            
             FOREACH qck_cur USING g_qcm.qcm021 INTO l_qck.* 
#                IF l_qck.qck05='1' THEN
#                   #-------- Ac,Re 數量賦予
#                   CALL s_newaql(g_qcm.qcm021,' ',l_qck.qck04,g_qcm.qcm22,' ','1')  #MOD-890223 add ' ','1'
#                        RETURNING l_ac_num,l_re_num
#                   CALL t510_defqty(2,l_qck.qck04)
#                        RETURNING l_qcn11
#                ELSE
#                   LET l_ac_num=0 LET l_re_num=1
#                   SELECT qcj05 INTO l_qcn11
#                     FROM qcj_file
#                    WHERE (g_qcm.qcm22 BETWEEN qcj01 AND qcj02)
#                      AND qcj03=l_qck.qck04
#                      AND qcj04=g_qcm.qcm17     #No.MOD-820049 add
#                   IF STATUS THEN LET l_qcn11=0 END IF
#                   IF g_qcm22 = 1 THEN
#                      LET l_qcn11 = 1
#                   END IF
#                END IF

                CASE l_qck.qck05
                 WHEN '1'   #一般
                   CALL s_newaql(g_qcm.qcm021,' ',l_qck.qck04,g_qcm.qcm22,' ','1')  #MOD-890223 add ' ','1'
                        RETURNING l_ac_num,l_re_num
                   CALL t510_defqty(2,l_qck.qck04,l_qck.qck03,l_qck.qck05)
                        RETURNING l_qcn11
                   LET l_qcn14 =''
                   LET l_qcn15 =''
                 WHEN '2'   #特殊
                   LET l_ac_num=0 LET l_re_num=1
                   SELECT qcj05 INTO l_qcn11
                     FROM qcj_file
                    WHERE (g_qcm.qcm22 BETWEEN qcj01 AND qcj02)
                      AND qcj03 = l_qck.qck04
                      AND qcj04 = g_qcm.qcm17   #No.MOD-820049 add
                   IF STATUS THEN
                      LET l_qcn11 = 0
                   END IF
                   IF g_qcm22 = 1 THEN
                      LET l_qcn11 = 1
                   END IF
                   LET l_qcn14 =''
                   LET l_qcn15 =''
                 WHEN '3'   #1916 计数
                   LET l_ac_num =0
                   LET l_re_num =1
                   CALL t510_defqty(2,l_qck.qck04,l_qck.qck03,l_qck.qck05) RETURNING l_qcn11
                   LET l_qcn14 =''
                   LET l_qcn15 =''
                
                 WHEN '4'   #1916 计量
                   LET l_ac_num =''
                   LET l_re_num =''
                   CALL t510_defqty(2,l_qck.qck04,l_qck.qck03,l_qck.qck05) RETURNING l_qcn11
                   SELECT qdf02 INTO l_qdf02
                     FROM qdf_file
                    WHERE (g_qcm.qcm22 BETWEEN qdf03 AND qdf04)
                      AND qdf01 = l_qck.qck03
                   SELECT qdg05,qdg06 INTO l_qcn14,l_qcn15
                     FROM qdg_file
                    WHERE qdg01 = g_ima101
                      AND qdg02 = l_qck.qck03
                      AND qdg03 = l_qdf02
                   IF SQLCA.sqlcode THEN 
                      LET l_qcn14 =0
                      LET l_qcn15 =0
                   END IF
                END CASE 
#No.FUN-A80063 --end  
                IF l_qcn11 > g_qcm.qcm22 THEN LET l_qcn11=g_qcm.qcm22 END IF
                IF cl_null(l_qcn11) THEN LET l_qcn11=0 END IF
 
                INSERT INTO qcn_file (qcn01,qcn03,qcn04,qcn05,qcn06,qcn07, 
                                      qcn08,qcn09,qcn10,qcn11,qcn12,qcn131,qcn132, 
                                      qcnplant,qcnlegal) #FUN-980007
                    VALUES(g_qcm.qcm01,seq,l_qck.qck02,l_qck.qck03,l_qck.qck04,
                           0,'1',l_ac_num,l_re_num,l_qcn11,l_qck.qck05,
                           l_qcc.qcc061,l_qcc.qcc062,
                           g_plant,g_legal)               #FUN-980007
                LET seq=seq+1
            END FOREACH
         END IF
      END IF
       CALL t510_show()
 
    END IF
 
END FUNCTION
 
FUNCTION t510_ii(p_cmd)
    DEFINE p_cmd                                 LIKE type_file.chr1    #No.FUN-680104 VARCHAR(1)
 
    DISPLAY BY NAME g_qcm.qcm091,g_qcm.qcm09,g_qcm.qcm13
 
    INPUT BY NAME g_qcm.qcm13 
        WITHOUT DEFAULTS
 
        AFTER FIELD qcm13
            IF cl_null(g_qcm.qcm13) THEN
               NEXT FIELD qcm13
            END IF
            SELECT gen02 INTO m_gen02 FROM gen_file WHERE gen01=g_qcm.qcm13
            IF STATUS THEN
               CALL cl_err3("sel","gen_file",g_qcm.qcm13,"","aoo-017","","",1)  #No.FUN-660115
               NEXT FIELD qcm13
            END IF
            DISPLAY m_gen02 TO FORMONLY.gen02
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(qcm13) #員工編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.default1 = g_qcm.qcm13
                   CALL cl_create_qry() RETURNING g_qcm.qcm13
                   DISPLAY BY NAME g_qcm.qcm13
                   NEXT FIELD qcm13
           END CASE
 
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
 
    UPDATE qcm_file SET qcm13=g_qcm.qcm13
     WHERE qcm01=g_qcm.qcm01
     IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
     END IF
 
END FUNCTION
 
FUNCTION t510_more_b()
  DEFINE l_qcu            DYNAMIC ARRAY OF RECORD
                          qcu04     LIKE qcu_file.qcu04,
                          qce03     LIKE qce_file.qce03,
                          qcu05     LIKE qcu_file.qcu05,  
                          qcuicd01  LIKE qcu_file.qcuicd01,  #No.MOD-8A0159 add by liuxqa
                          qcuicd02  LIKE qcu_file.qcuicd02,  #No.MOD-8A0159 add by liuxqa
                          icd03     LIKE type_file.chr1000   #No.MOD-8A0159 add by liuxqa
                          END RECORD
  DEFINE l_qcu05_t        LIKE qcu_file.qcu05
  DEFINE l_n,l_cnt        LIKE type_file.num5    #No.FUN-680104 SMALLINT
  DEFINE i,j,k            LIKE type_file.num5    #No.FUN-680104 SMALLINT
  DEFINE ls_tmp           STRING,
         l_rec_b          LIKE type_file.num5,    #No.FUN-680104 SMALLINT
         l_allow_insert   LIKE type_file.num5,                #可新增否  #No.FUN-680104 SMALLINT
         l_allow_delete   LIKE type_file.num5                 #可刪除否  #No.FUN-680104 SMALLINT
 
   OPEN WINDOW t510_mo AT 04,04 WITH FORM "aqc/42f/aqct1101"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aqct1101")
 
 
   DECLARE t510_mo CURSOR FOR
    SELECT qcu04,qce03,qcu05,
           qcuicd01,qcuicd02,''   #No.MOD-8A0159 add by liuxqa
     FROM qcu_file, OUTER qce_file
     WHERE qcu_file.qcu04=qce_file.qce01
       AND qcu01=g_qcm.qcm01
       AND qcu03=g_qcn[l_ac].qcn03
 
   CALL l_qcu.clear()
   LET i = 1
   LET l_rec_b = 1
 
   FOREACH t510_mo INTO l_qcu[i].*
      IF STATUS THEN CALL cl_err('foreach qcu',STATUS,0) EXIT FOREACH END IF
      LET i = i + 1
      IF i > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   LET l_rec_b = i - 1
   DISPLAY l_rec_b TO cn2
 
   SELECT SUM(qcu05) INTO l_qcu05_t FROM qcu_file
    WHERE qcu01=g_qcm.qcm01
      AND qcu03=g_qcn[l_ac].qcn03
   DISPLAY l_qcu05_t TO qcu05t
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY l_qcu WITHOUT DEFAULTS FROM s_qcu.*
         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
     BEFORE INPUT
        CALL fgl_set_arr_curr(l_ac)
 
     BEFORE ROW
        LET i=ARR_CURR()
        CALL cl_show_fld_cont()     #FUN-550037(smin)
 
     AFTER FIELD qcu04
        IF NOT cl_null(l_qcu[i].qcu04) THEN
           SELECT qce03 INTO l_qcu[i].qce03 FROM qce_file
            WHERE qce01=l_qcu[i].qcu04
           IF STATUS THEN NEXT FIELD qcu04 END IF
           DISPLAY l_qcu[i].qce03 TO s_qcu[j].qce03
        END IF
 
     AFTER FIELD qcu05
        IF l_qcu[i].qcu05<0 OR l_qcu[i].qcu05 IS NULL THEN
           LET l_qcu[i].qcu05=0
           DISPLAY l_qcu[i].qcu05 TO s_qcu[j].qcu05
        END IF
 
     AFTER ROW
        IF INT_FLAG THEN                 #900423
           CALL cl_err('',9001,0) LET INT_FLAG = 0 EXIT INPUT
        END IF
        LET l_qcu05_t=0
        FOR k = 1 TO l_qcu.getLength()
           IF l_qcu[k].qcu05 IS NOT NULL AND l_qcu[k].qcu05 <> 0 THEN
              LET l_qcu05_t = l_qcu05_t + l_qcu[k].qcu05
           END IF
        END FOR
        DISPLAY l_qcu05_t TO qcu05t
 
     AFTER INPUT
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(qcu04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_qce"
                   LET g_qryparam.default1 = l_qcu[i].qcu04
                   CALL cl_create_qry() RETURNING l_qcu[i].qcu04
                    DISPLAY l_qcu[i].qcu04 TO qcu04    #No.MOD-490371
                   NEXT FIELD qcu04
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
 
   CLOSE WINDOW t510_mo
 
   IF INT_FLAG THEN
      CALL cl_err('',9001,0)
      LET INT_FLAG = 0
      RETURN
   END IF
 
   DELETE FROM qcu_file
    WHERE qcu01=g_qcm.qcm01
      AND qcu03=g_qcn[l_ac].qcn03
 
   FOR i = 1 TO l_qcu.getLength()
       IF l_qcu[i].qcu05 IS NULL OR l_qcu[i].qcu05=0 THEN CONTINUE FOR END IF
        INSERT INTO qcu_file (qcu01,qcu02,qcu021,qcu03,qcu04,qcu05,
                              qcuicd01,qcuicd02,qcuplant,qculegal) #FUN-980007 
            VALUES(g_qcm.qcm01,0,0,g_qcn[l_ac].qcn03,l_qcu[i].qcu04,
                   l_qcu[i].qcu05,l_qcu[i].qcuicd01,l_qcu[i].qcuicd02,g_plant,g_legal)  #FUN-980007
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","qcu_file",g_qcm.qcm01,g_qcn[l_ac].qcn03,SQLCA.sqlcode,"","INS-qcu",1)  #No.FUN-660115
          LET g_success = 'N' EXIT FOR
       END IF
   END FOR
 
END FUNCTION
 
FUNCTION t510_ecm()
   DEFINE m_ecm04       LIKE ecm_file.ecm04,
          m_ecm06       LIKE ecm_file.ecm06,
          m_ecm45       LIKE ecm_file.ecm45,
          m_ecm53       LIKE ecm_file.ecm53,
          m_ecm03_par   LIKE ecm_file.ecm03_par,
          m_eca02       LIKE eca_file.eca02,
          m_ima02       LIKE ima_file.ima02,
          m_ima021      LIKE ima_file.ima021
 
   LET g_errno=' '
   SELECT ecm04,ecm06,ecm45,ecm03_par,ima02,ima021,ecm53,ecm03_par
     INTO m_ecm04,m_ecm06,m_ecm45,g_qcm.qcm021,m_ima02,
          m_ima021,m_ecm53,g_qcm.qcm021
    FROM ecm_file,OUTER ima_file
    WHERE ecm01 = g_qcm.qcm02
      AND ecm03 = g_qcm.qcm05
      AND ecm012 = g_qcm.qcm012            #FUN-A60027 
      AND ecm_file.ecm03_par = ima_file.ima01
 
   SELECT eca02 INTO m_eca02 FROM eca_file WHERE eca01=m_ecm06
   IF STATUS THEN LET m_eca02='' END IF
 
   CASE
      WHEN STATUS=100
           CALL cl_err('','aqc-018',0)
           LET g_errno='aqc-018'
      WHEN STATUS<>0
           CALL cl_err('',STATUS,0)
           LET g_errno=STATUS
      WHEN m_ecm53='N'
           CALL cl_err('','aqc-022',0)
          LET g_errno='aqc-022'
   END CASE
 
   DISPLAY m_ecm04 TO FORMONLY.ecm04    #作業編號
   DISPLAY m_ecm06 TO FORMONLY.ecm06    #工作站
   DISPLAY m_ecm45 TO FORMONLY.ecm45    #作業名稱
   DISPLAY m_ima02 TO FORMONLY.ima02    #料件名稱
   DISPLAY m_ima021 TO FORMONLY.ima021  #No.FUN-940103
   DISPLAY m_eca02 TO FORMONLY.eca02    #料件名稱
   DISPLAY BY NAME g_qcm.qcm021
 
END FUNCTION

#TQC-A60094 --begin
FUNCTION t510_ecm_chk(p_ecm01,p_ecm012,p_ecm03)
   DEFINE p_ecm01     LIKE ecm_file.ecm01
   DEFINE p_ecm012    LIKE ecm_file.ecm012
   DEFINE p_ecm03     LIKE ecm_file.ecm03
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_ecm53     LIKE ecm_file.ecm53
   DEFINE l_ecm55     LIKE ecm_file.ecm55

   LET g_errno = ''


   IF cl_null(g_qcm.qcm02) OR g_qcm.qcm012 IS NULL THEN RETURN END IF

  #FUN-B10056 ----------mod start------------------
  #LET l_cnt = 0
  #SELECT COUNT(*) INTO l_cnt FROM ecm_file
  # WHERE ecm01 = g_qcm.qcm02
  #   AND ecm012= g_qcm.qcm012
  ##当前工单的工艺追踪档中无此工艺段号信息,请检查!
  #IF l_cnt = 0 THEN
  #   LET g_errno = 'aec-311'
  #   RETURN
  #END IF
   IF NOT s_schdat_ecm012(g_qcm.qcm02,g_qcm.qcm012) THEN
      LET g_errno = 'aec-311'
      RETURN
   END IF
  #FUN-B10056 ---------mod end------------------

   IF cl_null(g_qcm.qcm05) THEN RETURN END IF

   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM ecm_file
    WHERE ecm01 = g_qcm.qcm02
      AND ecm012= g_qcm.qcm012
      AND ecm03 = g_qcm.qcm05
   #无此工艺序号
   IF l_cnt = 0 THEN
      LET g_errno = 'abm-215'
      RETURN
   END IF

   SELECT ecm53,ecm55 INTO l_ecm53,l_ecm55
     FROM ecm_file
    WHERE ecm01 = g_qcm.qcm02
      AND ecm012= g_qcm.qcm012
      AND ecm03 = g_qcm.qcm05
   #该工艺序设置为不使用工单PQC.!!
   IF l_ecm53 = 'N' THEN
      LET g_errno = 'aqc-022'
      RETURN
   END IF
   #本工艺有留置, 请利用质量异常处理作业取消留置
   IF NOT cl_null(l_ecm55)  THEN
      LET g_errno = 'asf-726'
      RETURN
   END IF

END FUNCTION

FUNCTION t510_qcm_show()
   DEFINE l_ecm04  LIKE ecm_file.ecm04
   DEFINE l_ecm45  LIKE ecm_file.ecm45
   DEFINE l_ecm06  LIKE ecm_file.ecm06
   DEFINE l_sfb06  LIKE sfb_file.sfb06
   DEFINE l_sfb05  LIKE sfb_file.sfb05
   DEFINE l_ecu014 LIKE ecu_file.ecu014

   SELECT ecm04,ecm06,ecm45
     INTO l_ecm04,l_ecm06,l_ecm45
     FROM ecm_file
    WHERE ecm01 = g_qcm.qcm02
      AND ecm012= g_qcm.qcm012
      AND ecm03 = g_qcm.qcm05

   LET g_ecm.ecm04 = l_ecm04

   SELECT sfb06,sfb05 INTO l_sfb06,l_sfb05 FROM sfb_file
    WHERE sfb01 = g_qcm.qcm02

  #FUN-B10056 --------mark start-------- 
  #SELECT ecu014 INTO l_ecu014
  #  FROM ecu_file
  # WHERE ecu01 = l_sfb05
  #   AND ecu02 = l_sfb06
  #   AND ecu012= g_qcm.qcm012
  #FUN-B10056 -------mark end---------- 
   CALL s_schdat_ecm014(g_qcm.qcm02,g_qcm.qcm012) RETURNING l_ecu014    #FUN-B10056
   DISPLAY l_ecm04 TO FORMONLY.ecm04
   DISPLAY l_ecm06 TO FORMONLY.ecm06
   DISPLAY l_ecm45 TO FORMONLY.ecm45
   DISPLAY l_ecu014 TO FORMONLY.ecu014


END FUNCTION

#TQC-A60094 --end
 
FUNCTION t510_qcm22()
 DEFINE l_qcm22    LIKE qcm_file.qcm22
 DEFINE l_qcm091    LIKE qcm_file.qcm091
 DEFINE l_post_qty     LIKE qcm_file.qcm22    #No.MOD-820021 add
 DEFINE l_un_post_qty  LIKE qcm_file.qcm22    #No.MOD-820021 add
 DEFINE l_wip_qty      LIKE qcm_file.qcm22    #FUN-C30231 add
 DEFINE l_bn_ecm012    LIKE ecm_file.ecm012   #FUN-C30231 add
 DEFINE l_bn_ecm03     LIKE ecm_file.ecm03    #FUN-C30231 add
#MOD-C40055--begin
DEFINE l_ima153     LIKE ima_file.ima153
DEFINE l_ecm04      LIKE ecm_file.ecm04  
DEFINE l_ecm62      LIKE ecm_file.ecm62  
DEFINE l_ecm63      LIKE ecm_file.ecm63  
DEFINE l_ecm315     LIKE ecm_file.ecm315  
#MOD-C40055--end 
DEFINE l_cnt        LIKE type_file.num5   #MOD-CB0183 add
 
   SELECT * INTO g_ecm.* FROM ecm_file
    WHERE ecm01=g_qcm.qcm02 AND ecm03=g_qcm.qcm05
      AND ecm012 = g_qcm.qcm012                       #FUN-A60027 
 
   SELECT SUM(qcm22) INTO l_un_post_qty FROM qcm_file
    WHERE qcm02 = g_qcm.qcm02
      AND qcm14 = 'N'   #未確認
      AND qcm01 <> g_qcm.qcm01
      AND qcm05 = g_qcm.qcm05      #No.MOD-830124 add
      AND qcm012 = g_qcm.qcm012    #No.MOD-D60233 add
 
   IF l_un_post_qty IS NULL THEN
      LET l_un_post_qty = 0
   END IF
 
   SELECT SUM(qcm091) INTO l_post_qty FROM qcm_file
    WHERE qcm02 = g_qcm.qcm02
      AND qcm14 = 'Y'   #確認
      AND qcm01 <> g_qcm.qcm01
      AND qcm05 = g_qcm.qcm05      #No.MOD-830124 add
      AND qcm012 = g_qcm.qcm012    #No.MOD-D60233 add
 
   IF l_post_qty IS NULL THEN
      LET l_post_qty = 0
   END IF
   LET l_qcm091 = l_post_qty + l_un_post_qty
   IF cl_null(l_qcm091) THEN LET l_qcm091 = 0 END IF
 
   IF g_ecm.ecm54='Y' THEN
      LET g_qcm.qcm22 = g_ecm.ecm291
                      + g_ecm.ecm322
                      - g_ecm.ecm313      #No:MOD-BB0314 
                      - l_qcm091
   ELSE
      IF g_sma.sma1431='N' OR cl_null(g_sma.sma1431) THEN  #FUN-C30231 add
         LET g_qcm.qcm22 = g_ecm.ecm301 + g_ecm.ecm302 + g_ecm.ecm303
                         + g_ecm.ecm322
                         - g_ecm.ecm313      #No:MOD-BB0314 
                         - l_qcm091
      #FUN-C30231 add
      ELSE
         CALL t700sub_check_auto_report(g_qcm.qcm02,'',g_qcm.qcm012,g_qcm.qcm05)
            RETURNING l_bn_ecm012,l_bn_ecm03,l_wip_qty
         LET g_qcm.qcm22 = l_wip_qty
                         + g_ecm.ecm322
                         - g_ecm.ecm313      #No:MOD-BB0314
                         - l_qcm091
         IF cl_null(l_wip_qty) THEN LET l_wip_qty = 0 END IF
      END IF
      #FUN-C30231 add--end
   END IF
 
   IF cl_null(g_qcm.qcm22) AND g_qcm.qcm00='1' THEN LET g_qcm.qcm22=0 END IF #MOD-8C0206
   
   #MOD-C40055--begin
   IF g_qcm.qcm00='1' THEN 
      CALL s_get_ima153(g_qcm.qcm021) RETURNING l_ima153 
      SELECT ecm62,ecm63,ecm04 INTO l_ecm62,l_ecm63,l_ecm04 FROM ecm_file
       WHERE ecm01=g_qcm.qcm02 AND ecm03=g_qcm.qcm05
         AND ecm012=g_qcm.qcm012
      IF cl_null(l_ecm62) OR l_ecm62=0 THEN
         LET l_ecm62=1
      END IF
      IF cl_null(l_ecm63) OR l_ecm63=0 THEN
         LET l_ecm63=1
      END IF
      CALL s_minp_routing(g_qcm.qcm02,g_sma.sma73,l_ima153,l_ecm04,g_qcm.qcm012,g_qcm.qcm05)  
      RETURNING g_cnt,g_min_set         
                     
      SELECT SUM(ecm315) INTO l_ecm315 FROM ecm_file
       WHERE ecm01 = g_qcm.qcm02
      IF cl_null(l_ecm315) OR l_ecm315 = 0 THEN
         LET l_ecm315 = 0
      END IF 
      #MOD-CB0183 add begin---------------------------
      IF g_sma.sma542 = 'Y' THEN
         SELECT COUNT(*) INTO l_cnt FROM sfa_file
          WHERE sfa01 = g_qcm.qcm02 AND (sfa08 = l_ecm04 OR sfa08 = ' ')
            AND sfa012 = g_qcm.qcm012 AND sfa013 = g_qcm.qcm05
            AND sfa161 > 0
      ELSE
         SELECT COUNT(*) INTO l_cnt FROM sfa_file
          WHERE sfa01 = g_qcm.qcm02 AND (sfa08 = l_ecm04 OR sfa08 = ' ')
            AND sfa161 > 0
      END IF
      #MOD-CB0183 add end-----------------------------
     #IF g_qcm.qcm22 > (g_min_set*l_ecm62/l_ecm63) + l_ecm315 THEN      #MOD-CB0183 mark
      IF g_qcm.qcm22 > (g_min_set*l_ecm62/l_ecm63) + l_ecm315 AND l_cnt > 0 THEN #MOD-CB0183 add l_cnt > 0
         LET g_qcm.qcm22=(g_min_set*l_ecm62/l_ecm63) + l_ecm315
      END IF        
   END IF 
   #MOD-C40055--end  
      
   RETURN g_qcm.qcm22
 
END FUNCTION
 
FUNCTION t510_sfb(p_cmd)  #MOD-8A0131 add p_cmd
   DEFINE m_sfb01       LIKE sfb_file.sfb01,
          p_cmd         LIKE type_file.chr1,            #MOD-8A0131 add   
          m_sfb07       LIKE sfb_file.sfb07,
          m_sfb82       LIKE sfb_file.sfb82,
          m_sfb22       LIKE sfb_file.sfb22,
          m_gem02       LIKE gem_file.gem02,
          m_oea04       LIKE oea_file.oea04,
          m_occ02       LIKE occ_file.occ02,
          m_sfb05       LIKE sfb_file.sfb05,
          m_azf03       LIKE azf_file.azf03,       #No.FUN-680104 VARCHAR(30)
          m_ima109      LIKE ima_file.ima109,
          m_ima02       LIKE ima_file.ima02,
          m_ima021      LIKE ima_file.ima021
 
   IF NOT cl_null(g_qcm.qcm02) THEN
      IF p_cmd='q' THEN
         LET g_qcm_o.qcm21 = g_qcm.qcm21
         LET g_qcm_o.qcm17 = g_qcm.qcm17
      END IF 
      SELECT sfb01,sfb07,sfb82,sfb22,sfb05,ima02,ima021,sfb39,
             ima100,ima102,ima109,ima101         #No.FUN-A80063 
        INTO m_sfb01,m_sfb07,m_sfb82,m_sfb22,m_sfb05,m_ima02,m_ima021,g_sfb39,
             g_qcm.qcm21,g_qcm.qcm17,m_ima109,g_ima101   #No.FUN-A80063 
       FROM sfb_file,ima_file WHERE sfb01 = g_qcm.qcm02 AND sfb05 = ima01
       LET g_qcm.qcm021 = m_sfb05
 
      IF p_cmd='q' THEN
         LET g_qcm.qcm21 = g_qcm_o.qcm21
         LET g_qcm.qcm17 = g_qcm_o.qcm17
      END IF 
 
       SELECT azf03 INTO m_azf03 FROM azf_file
        WHERE azf01=m_ima109 AND azf02='8'
       IF STATUS THEN LET m_azf03=' ' END IF
       DISPLAY m_azf03 TO FORMONLY.azf03    #---- 類別說明
 
       DISPLAY m_sfb07 TO FORMONLY.sfb07    #版本
       DISPLAY m_sfb05 TO qcm021            #料件編號
       DISPLAY m_ima02 TO FORMONLY.ima02    #料件名稱
       DISPLAY m_ima021 TO FORMONLY.ima021  #No.FUN-940103
       DISPLAY m_ima109 TO FORMONLY.ima109
       DISPLAY g_ima101 TO ima101     #No.FUN-A80063
 
       CASE g_qcm.qcm21
            WHEN 'N' CALL cl_getmsg('aqc-001',g_lang) RETURNING qcm21_desc
            WHEN 'T' CALL cl_getmsg('aqc-002',g_lang) RETURNING qcm21_desc
            WHEN 'R' CALL cl_getmsg('aqc-003',g_lang) RETURNING qcm21_desc
       END CASE
       DISPLAY BY NAME g_qcm.qcm21,g_qcm.qcm17
       DISPLAY qcm21_desc TO FORMONLY.qcm21_desc
  #----------CHI-BC0018 str add-----------------
   CASE g_qcm.qcm17
      WHEN '1'
         SELECT gae04 INTO qcm17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_1' AND gae03=g_lang
      WHEN '2'
         SELECT gae04 INTO qcm17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_2' AND gae03=g_lang
      WHEN '3'
         SELECT gae04 INTO qcm17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_3' AND gae03=g_lang
      WHEN '4'
         SELECT gae04 INTO qcm17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_4' AND gae03=g_lang
      WHEN '5'
         SELECT gae04 INTO qcm17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_5' AND gae03=g_lang
      WHEN '6'
         SELECT gae04 INTO qcm17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_6' AND gae03=g_lang
	  WHEN '7'
         SELECT gae04 INTO qcm17_desc
         FROM gae_file
         WHERE gae01='aimi103' AND gae02='ima102_7' AND gae03=g_lang
      OTHERWISE
         LET qcm17_desc= ' '
   END CASE

   DISPLAY qcm17_desc TO FORMONLY.qcm17_desc
   #----------CHI-BC0018 end add-----------------
   ELSE
       DISPLAY ' ' TO FORMONLY.sfb07    #版本
   END IF
 
END FUNCTION
 
FUNCTION t510_more_b1(p_qcn11,p_qcc05,p_qcc061,p_qcc062,p_qcn03,p_qcn04)
  DEFINE l_qcnn           DYNAMIC ARRAY OF RECORD
                          qcnn04    LIKE qcnn_file.qcnn04
                          END RECORD
  DEFINE l_n,l_cnt        LIKE type_file.num5    #No.FUN-680104 SMALLINT
  DEFINE i,j,k            LIKE type_file.num5    #No.FUN-680104 SMALLINT
  DEFINE p_qcn11          LIKE qcn_file.qcn11
  DEFINE p_qcc05          LIKE qcc_file.qcc05
  DEFINE p_qcc061         LIKE qcc_file.qcc061
  DEFINE p_qcc062         LIKE qcc_file.qcc062
  DEFINE p_qcn03          LIKE qcn_file.qcn03
  DEFINE p_qcn04          LIKE qcn_file.qcn04
  DEFINE l_azf03          LIKE azf_file.azf03
  DEFINE ls_tmp           STRING
  DEFINE l_rec_b          LIKE type_file.num5,    #No.FUN-680104 SMALLINT
         l_allow_insert   LIKE type_file.num5,                #可新增否  #No.FUN-680104 SMALLINT
         l_allow_delete   LIKE type_file.num5                 #可刪除否  #No.FUN-680104 SMALLINT
   DEFINE l_rowcount       LIKE type_file.num5         #No.FUN-680104 SMALLINT   #No.MOD-580011
   DEFINE l_i              LIKE type_file.num5     #No.MOD-580011  #No.FUN-680104 SMALLINT
 
 
   OPEN WINDOW t510_mo1 AT 04,04 WITH FORM "aqc/42f/aqct5102"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aqct5102")
 
 
   DISPLAY p_qcn03 TO FORMONLY.qcn03
   DISPLAY p_qcn04 TO FORMONLY.qcn04
   SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=p_qcn04 AND azf02='6'
   DISPLAY l_azf03 TO FORMONLY.azf03
   DISPLAY p_qcn11 TO FORMONLY.qcn11
   DISPLAY p_qcc05 TO FORMONLY.qcn12
   DISPLAY p_qcc061 TO FORMONLY.qcn131
   DISPLAY p_qcc062 TO FORMONLY.qcn132
 
   CALL l_qcnn.clear()
 
   LET i = 1
   LET k=1
   LET l_rec_b = 0
 
   DECLARE t510_mo1 CURSOR FOR
    SELECT qcnn04 FROM qcnn_file
     WHERE qcnn01=g_qcm.qcm01
       AND qcnn03=g_qcn[l_ac].qcn03
 
   FOREACH t510_mo1 INTO l_qcnn[k].*
      IF STATUS THEN CALL cl_err('foreach qcnn',STATUS,0) EXIT FOREACH END IF
      LET k = k + 1
 
      IF k > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
    CALL l_qcnn.deleteElement(k)   #No.MOD-580011
   LET l_rec_b=k-1
   DISPLAY l_rec_b TO cn2
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
    WHILE TRUE   #No.MOD-580011
   INPUT ARRAY l_qcnn WITHOUT DEFAULTS FROM s_qcnn.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
     BEFORE ROW
        LET i=ARR_CURR()
        LET l_rowcount = 0
        FOR l_i = 1 TO l_qcnn.getLength()
            IF l_qcnn[l_i].qcnn04 IS NULL THEN
               CONTINUE FOR
            END IF
            LET l_rowcount = l_rowcount + 1
        END FOR
        DISPLAY l_rowcount TO cn2
 
     AFTER ROW
        IF INT_FLAG THEN
           CALL cl_err('',9001,0) LET INT_FLAG = 0 EXIT INPUT
        END IF
        LET l_rowcount = 0
        FOR l_i = 1 TO l_qcnn.getLength()
             IF l_qcnn[l_i].qcnn04 IS NULL THEN
                CONTINUE FOR
             END IF
             LET l_rowcount = l_rowcount + 1
        END FOR
        DISPLAY l_rowcount TO cn2
 
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
     IF l_rowcount <> p_qcn11 THEN
         LET g_msg=l_rowcount,': ',p_qcn11
         CALL cl_err(g_msg,'aqc-038',1)
         CONTINUE WHILE
     END IF
     EXIT WHILE
 END WHILE
 
   CLOSE WINDOW t510_mo1
 
   IF INT_FLAG THEN CALL cl_err('',9001,0)
      LET INT_FLAG = 0 RETURN
   END IF
 
   DELETE FROM qcnn_file
    WHERE qcnn01=g_qcm.qcm01
      AND qcnn03=g_qcn[l_ac].qcn03
 
   LET g_qcn[l_ac].qcn07=0
 
   FOR i = 1 TO l_qcnn.getLength()
       IF l_qcnn[i].qcnn04 IS NULL THEN   #No.MOD-580011
         CONTINUE FOR
      END IF
       INSERT INTO qcnn_file(qcnn01,qcnn03,qcnn04,  #No.MOD-470041
                             qcnnplant,qcnnlegal)   #FUN-980007
           VALUES(g_qcm.qcm01,g_qcn[l_ac].qcn03,l_qcnn[i].qcnn04,
                  g_plant,g_legal)                  #FUN-980007
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","qcnn_file",g_qcm.qcm01,g_qcn[l_ac].qcn03,SQLCA.sqlcode,"","INS-qcnn",1)  #No.FUN-660115
         LET g_success = 'N' EXIT FOR
      ELSE
         IF l_qcnn[i].qcnn04<p_qcc061 OR l_qcnn[i].qcnn04>p_qcc062 THEN
            LET g_qcn[l_ac].qcn07=g_qcn[l_ac].qcn07+1
         END IF
      END IF
   END FOR
 
END FUNCTION
 
FUNCTION t510_out()
   DEFINE l_cmd        LIKE type_file.chr1000, #No.FUN-680104 VARCHAR(200)
          l_wc,l_wc2   LIKE type_file.chr1000, #No.FUN-680104 VARCHAR(50)
          l_prtway     LIKE type_file.chr1     #No.FUN-680104 VARCHAR(01)
 
   CALL cl_wait()
 
   LET l_wc='qcm01="',g_qcm.qcm01,'"'
 
  #SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'aqcr350' #FUN-C30085
   SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'aqcg350' #FUN-C30085 
 
  #LET l_cmd = 'aqcr350', #FUN-C30085
   LET l_cmd = 'aqcg350', #FUN-C30085
                " '",g_today CLIPPED,"' ''",
                " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
                " '",l_wc CLIPPED,"' "
   CALL cl_cmdrun(l_cmd)
 
   ERROR ' '
END FUNCTION
 
FUNCTION t510_b_memo()
  DEFINE ls_tmp           STRING
  DEFINE l_qcv            DYNAMIC ARRAY OF RECORD
         qcv04            LIKE qcv_file.qcv04
                          END RECORD
  DEFINE l_n,l_cnt        LIKE type_file.num5    #No.FUN-680104 SMALLINT
  DEFINE i,j,k            LIKE type_file.num5    #No.FUN-680104 SMALLINT
  DEFINE l_rec_b          LIKE type_file.num5,    #No.FUN-680104 SMALLINT
         l_allow_insert   LIKE type_file.num5,                #可新增否  #No.FUN-680104 SMALLINT
         l_allow_delete   LIKE type_file.num5                 #可刪除否  #No.FUN-680104 SMALLINT
 
   OPEN WINDOW t510_b_memo AT 04,04 WITH FORM "aqc/42f/aqct1103"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aqct1103")
 
   DECLARE t510_b_memo CURSOR FOR
    SELECT qcv04 FROM qcv_file
     WHERE qcv01=g_qcm.qcm01
       AND qcv03=g_qcn[l_ac].qcn03
 
   CALL l_qcv.clear()
   LET i = 1
   LET l_rec_b = 0
 
   FOREACH t510_b_memo INTO l_qcv[i].*
      IF STATUS THEN CALL cl_err('foreach qcv',STATUS,0) EXIT FOREACH END IF
      LET i = i + 1
      IF i > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
 
   END FOREACH
   LET l_rec_b = i - 1
   DISPLAY l_rec_b TO cn2
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY l_qcv WITHOUT DEFAULTS FROM s_qcv.*
         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
     BEFORE INPUT
         CALL fgl_set_arr_curr(l_ac)
 
     BEFORE ROW
        LET i=ARR_CURR()
        CALL cl_show_fld_cont()     #FUN-550037(smin)
 
     AFTER ROW
        IF INT_FLAG THEN
           CALL cl_err('',9001,0) LET INT_FLAG = 0 EXIT INPUT
        END IF
 
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
 
   CLOSE WINDOW t510_b_memo
 
   IF INT_FLAG THEN
      CALL cl_err('',9001,0)
      LET INT_FLAG = 0 RETURN
   END IF
 
   DELETE FROM qcv_file
    WHERE qcv01=g_qcm.qcm01
      AND qcv03=g_qcn[l_ac].qcn03
 
   FOR i = 1 TO l_qcv.getLength()
       IF cl_null(l_qcv[i].qcv04) THEN CONTINUE FOR END IF
        INSERT INTO qcv_file(qcv01,qcv02,qcv021,qcv03,qcv04,  #No.MOD-470041
                             qcvplant,qcvlegal)               #FUN-980007
            VALUES(g_qcm.qcm01,0,0,g_qcn[l_ac].qcn03,l_qcv[i].qcv04,
                   g_plant,g_legal)                           #FUN-980007
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","qcv_file",g_qcm.qcm01,"",SQLCA.sqlcode,"","INS-qcv",1)  #No.FUN-660115
          LET g_success = 'N' EXIT FOR
       END IF
   END FOR
 
END FUNCTION
 
FUNCTION t510_3()
   SELECT * INTO g_qcm.* FROM qcm_file
    WHERE qcm01 = g_qcm.qcm01
    IF g_qcm.qcm09='1' THEN   #No.MOD-480059
      RETURN
   END IF
   IF cl_null(g_qcm.qcm01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   IF g_qcm.qcm14 != 'Y' THEN
      CALL cl_err(g_qcm.qcm01,'anm-960',0)
      RETURN
   END IF
 
   LET g_qcm_t.*=g_qcm.*
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t510_cl USING g_qcm.qcm01
   IF STATUS THEN
      CALL cl_err("OPEN t510_cl:", STATUS, 1)
      CLOSE t510_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t510_cl INTO g_qcm.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcm.qcm01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t510_cl ROLLBACK WORK RETURN
   END IF
 
   #show特採
   CALL cl_getmsg('aqc-006',g_lang) RETURNING des1
   DISPLAY '3',des1 TO qcm09,FORMONLY.des1
 
   INPUT BY NAME g_qcm.qcm091 WITHOUT DEFAULTS
        AFTER FIELD qcm091
            IF g_qcm.qcm091 > g_qcm.qcm22 OR g_qcm.qcm091<0 THEN
               CALL cl_err('err qcm091','aqc-002',0)
               NEXT FIELD qcm091
            END IF
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
      LET g_qcm.*=g_qcm_t.*
      CALL t510_show()
      CALL cl_err('','9001',0)
      RETURN
   END IF
 
   UPDATE qcm_file SET qcm09  ='3', #特採
                       qcm091 =g_qcm.qcm091,
                       qcm15  =g_today,
                       qcmmodu=g_user,
                       qcmdate=g_today
    WHERE qcm01  =g_qcm.qcm01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","qcm_file",g_qcm.qcm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
      LET g_success = 'N'
   END IF
 
   IF g_success = 'Y' THEN
       COMMIT WORK
   ELSE
       ROLLBACK WORK
   END IF
 
   CLOSE t510_cl
 
   SELECT * INTO g_qcm.* FROM qcm_file
    WHERE qcm01 = g_qcm.qcm01
 
   CALL t510_show()
 
END FUNCTION
 
FUNCTION t510_m()
   IF g_qcm.qcm01 IS NULL THEN RETURN END IF
 
   LET g_action_choice="modify"
   IF NOT cl_chk_act_auth() THEN
      LET g_chr='d'
   ELSE
      LET g_chr='u'
   END IF
 
   CALL s_aqc_memo(g_qcm.qcm01,0,0,0,g_chr)
 
END FUNCTION

#FUN-A30045 ---------------------Begin------------------------------------------
FUNCTION t510_4()
   DEFINE l_n  LIKE type_file.num5
   
   SELECT * INTO g_qcm.* FROM qcm_file
    WHERE qcm01 = g_qcm.qcm01
    IF g_qcm.qcm09 <> '3' THEN   
      CALL cl_err(g_qcm.qcm09,'aqct1003',0)
      RETURN
   END IF
   IF cl_null(g_qcm.qcm01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_qcm.qcm14 != 'Y' THEN
      CALL cl_err(g_qcm.qcm01,'anm-960',0)
      RETURN
   END IF

   SELECT COUNT(*) INTO l_n FROM shb_file
       WHERE shb05 = g_qcm.qcm02
         AND shb06 = g_qcm.qcm05
         AND shbconf = 'Y'     #FUN-A70095  
         
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcm.qcm02,SQLCA.sqlcode,0)      
   END IF   
   IF l_n <> 0 THEN
      CALL cl_err(g_qcm.qcm01,'aqc1005',0)
      RETURN
   END IF   
   IF NOT cl_confirm('aqc1002') THEN
      RETURN
   END IF
   LET g_qcm_t.*=g_qcm.*

   BEGIN WORK

   LET g_success='Y'

   OPEN t510_cl USING g_qcm.qcm01
   IF STATUS THEN
      CALL cl_err("OPEN t510_cl:", STATUS, 1)
      CLOSE t510_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t510_cl INTO g_qcm.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcm.qcm01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t510_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   UPDATE qcm_file SET qcm09 = '2',
                       qcm091 = 0,
                       qcm15 = g_today,
                       qcmmodu = g_user,
                       qcmdate = g_today
       WHERE qcm01=g_qcm.qcm01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("upd","qcm_file",g_qcm.qcm01,g_qcm.qcm02,SQLCA.sqlcode,"","",1)  
      LET g_success = 'N'
   END IF

   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

   CLOSE t510_cl
   
   SELECT * INTO g_qcm.* FROM qcm_file
    WHERE qcm01 = g_qcm.qcm01
    
   CALL t510_show()       
   
END FUNCTION
#FUN-A30045 ---------------------End--------------------------------------------
 
FUNCTION t510_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680104 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("qcm00,qcm01,qcm02,qcm05",TRUE)
    END IF
 
    IF INFIELD(qcm00) OR ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("qcm02,qcm05,qcm021",TRUE)
    END IF
 
    #No.CHI-A30031 --start--
    IF g_qcm.qcm09<>'1' OR cl_null(g_qcm.qcm09) THEN
       CALL cl_set_comp_entry("qcm22",TRUE)
    END IF
    #No.CHI-A30031 --end--

END FUNCTION
 
FUNCTION t510_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680104 VARCHAR(1)
 
    IF p_cmd = 'u' AND ( NOT g_before_input_done )  AND g_chkey='N'  THEN  #No.FUN-570109
       CALL cl_set_comp_entry("qcm00,qcm01,qcm011,qcm012,qcm013,qcm02",FALSE)
    END IF
 
    IF INFIELD(qcm00) OR ( NOT g_before_input_done ) THEN
       IF g_qcm.qcm00='2' THEN
          CALL cl_set_comp_entry("qcm02,qcm05",FALSE)
       END IF
       IF g_qcm.qcm00='1' THEN
          CALL cl_set_comp_entry("qcm021",FALSE)
       END IF
    END IF
 
    #No.CHI-A30031 --start--
    IF p_cmd = 'u' AND g_qcm.qcm09='1' THEN
       CALL cl_set_comp_entry("qcm22",FALSE)
    END IF
    #No.CHI-A30031 --end--

END FUNCTION
 
FUNCTION t510_spc()
 
   LET g_success = 'Y'
 
   CALL t510_y_chk()          #CALL 原確認的 check 段
   IF g_success = "N" THEN
      RETURN
   END IF
 
   #檢查資料是否可拋轉至 SPC
   #CALL aws_spccli_qc_chk('單號','SPC拋轉碼','確認碼','有效碼')
   CALL aws_spccli_qc_chk(g_qcm.qcm01,g_qcm.qcmspc,g_qcm.qcm14,g_qcm.qcmacti)
   IF g_success = 'N' THEN
      RETURN
   END IF
 
   # CALL aws_spccli()
   #功能: 傳送此單號所有的 QC 單至 SPC 端
   # 傳入參數: (1) QC 程式代號, (2) QC 單頭資料,(3)功能選項：insert(新增),delete(刪除)
   # 回傳值  : 0 傳送失敗; 1 傳送成功
   IF aws_spccli(g_prog,base.TypeInfo.create(g_qcm),'insert') THEN 
      LET g_qcm.qcmspc = '1'
   ELSE
      LET g_qcm.qcmspc = '2'
   END IF
 
   DISPLAY BY NAME g_qcm.qcmspc
 
END FUNCTION
 
FUNCTION t510_spc_upd()
   BEGIN WORK
   IF NOT t510_spc_upd_process() THEN
      ROLLBACK WORK
      RETURN 
   END IF
   IF g_aza.aza65 = 'Y' THEN
      CALL t510_y_chk()              #CALL 原確認的 check 段
      IF g_success = "Y" THEN
         CALL t510_y_upd()           #CALL 原確認的 update 段
      END IF
      IF g_success = "N" THEN
         ROLLBACK WORK
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION t510_y_chk()
DEFINE l_n     LIKE type_file.num5  #FUN-BC0104
DEFINE l_sum   LIKE type_file.num10 #FUN-BC0104
DEFINE l_sum1  LIKE type_file.num10 #TQC-C20504
 
   LET g_success = 'Y'
 
#CHI-C30107 -------------- add -------------- begin
   IF g_qcm.qcm14 = 'Y' THEN
      CALL cl_err('',9023,0)
      LET g_success = 'N'
      RETURN
   END IF

   IF g_qcm.qcm14 = 'X' THEN
      CALL cl_err('','9024',0)
      LET g_success = 'N'
      RETURN
   END IF

   IF g_qcm.qcm22 = 0 THEN
      CALL cl_err('','aqc-027',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_action_choice CLIPPED = "confirm" THEN
     IF NOT cl_confirm('axm-108') THEN
        LET g_success='N'
        RETURN
     END IF
   END IF
#CHI-C30107 -------------- add -------------- end
   SELECT * INTO g_qcm.* FROM qcm_file WHERE qcm01=g_qcm.qcm01
 
   IF g_qcm.qcm14 = 'Y' THEN
      CALL cl_err('',9023,0)
      LET g_success = 'N'
      RETURN
   END IF
 
   IF g_qcm.qcm14 = 'X' THEN
      CALL cl_err('','9024',0)
      LET g_success = 'N'
      RETURN
   END IF
 
   IF g_qcm.qcm22 = 0 THEN
      CALL cl_err('','aqc-027',0)
      LET g_success = 'N'
      RETURN
   END IF
#FUN-BC0104----add----str----
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM qco_file
    WHERE qco01 = g_qcm.qcm01
   IF l_n > 0 THEN
      IF g_qcm.qcm09 = '1' THEN     #MOD-C30557
         SELECT SUM(qco11*qco19) INTO l_sum
           FROM qco_file,qcl_file
          WHERE qco01 = g_qcm.qcm01
            AND qco03 = qcl01
           #AND qcl05 <> '3'     #FUN-CC0013 mark
         IF l_sum != g_qcm.qcm091 THEN
            CALL cl_err(g_qcm.qcm01,'aqc-520',0)
            LET g_success = 'N'
            RETURN
         END IF
      END IF                        #MOD-C30557
      #TQC-C20504----Begin----
      SELECT SUM(qco11*qco19) INTO l_sum1
        FROM qco_file
       WHERE qco01 = g_qcm.qcm01
      IF l_sum1 != g_qcm.qcm22 THEN
         CALL cl_err(g_qcm.qcm01,'aqc-536',0)
         LET g_success ='N'
         RETURN
      END IF
      #TQC-C20504-----End-----
   END IF
#FUN-BC0104----add----end----
 
END FUNCTION
 
FUNCTION t510_y_upd()
 
   #若設定與 SPC 整合, 判斷是否已拋轉
   IF g_aza.aza64 NOT matches '[ Nn]' AND 
     ((g_qcm.qcmspc IS NULL ) OR g_qcm.qcmspc NOT matches '[1]'  )
   THEN
     CALL cl_err('','aqc-117',0)
     LET g_success='N'
     RETURN
   END IF
 
#CHI-C30107 --------------- add -------------- begin
#  IF g_action_choice CLIPPED = "confirm" THEN 
#    IF NOT cl_confirm('axm-108') THEN
#       LET g_success='N'
#       RETURN
#    END IF
#  END IF
#CHI-C30107 --------------- add -------------- end
 
   IF (g_argv2 <> "SPC_ins" AND g_argv2 <> "SPC_upd") OR g_argv2 IS NULL THEN
      BEGIN WORK
   END IF
 
   OPEN t510_cl USING g_qcm.qcm01
   IF STATUS THEN
      CALL cl_err("OPEN t510_cl:", STATUS, 1)
      CLOSE t510_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t510_cl INTO g_qcm.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcm.qcm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t510_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
   UPDATE qcm_file SET qcm14='Y',
                       qcm15=g_today
    WHERE qcm01=g_qcm.qcm01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN LET g_success='N' END IF
 
   IF g_qcm.qcm09 = '2' THEN      #MOD-C30557
      CALL t510_qc()              #MOD-C30557
   END IF                         #MOD-C30557

   IF g_success = 'Y' THEN
      LET g_qcm.qcm14='Y'  LET g_qcm.qcm15=g_today
      IF (g_argv2 <> "SPC_ins" AND g_argv2 <> "SPC_upd")      #FUN-680010
      OR g_argv2 IS NULL 
      THEN
         COMMIT WORK
      END IF
      CALL cl_flow_notify(g_qcm.qcm01,'Y')
      DISPLAY BY NAME g_qcm.qcm14,g_qcm.qcm15
      CALL t510_qc_item_show()                #MOD-C30557
   ELSE
      LET g_success = 'N'
      ROLLBACK WORK
   END IF
 
END FUNCTION

#MOD-C30557----add----str----
FUNCTION t510_qc()
DEFINE l_sum_qco11     LIKE type_file.num10,
       l_n             LIKE type_file.num5

   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM qco_file
    WHERE qco01 = g_qcm.qcm01
   IF l_n = 0 THEN RETURN END IF

   SELECT SUM(qco11*qco19) INTO l_sum_qco11
     FROM qco_file,qcl_file
    WHERE qco01 = g_qcm.qcm01
      AND qco03 = qcl01
     #AND qcl05 <> '3'    #FUN-CC0013 mark
   IF cl_null(l_sum_qco11) THEN LET l_sum_qco11 = 0 END IF
   IF l_sum_qco11 = 0 THEN RETURN END IF

   UPDATE qcm_file
      SET qcm09  = '1',
          qcm091 = l_sum_qco11
    WHERE qcm01  = g_qcm.qcm01
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
   END IF

END FUNCTION
#MOD-C30557----add----end----
 
FUNCTION t510_spc_upd_process()
DEFINE l_status    LIKE type_file.num5         #No.FUN-680104 SMALLINT
DEFINE l_qcm091    LIKE qcm_file.qcm091
DEFINE l_qcm22     LIKE qcm_file.qcm22
 
   # CALL aws_spcfld()
   #功能: 修改 QC 張資料
   # 傳入參數: (1) QC 程式代號, (2) TABLE 名稱,
   #           (3) 合格量欄位,  (4) 送驗量欄位
   # 回傳值  : (1)0 更改失敗; 1 更新成功
   #           (2) 合格量數量， (3)送驗量數量
   CALL aws_spcfld(g_prog,'qcm_file','qcm091','qcm22') 
     RETURNING l_status,l_qcm091,l_qcm22
   IF l_status = 0 THEN
      RETURN FALSE
   END IF
 
   RETURN TRUE 
END FUNCTION

#MOD-C70114 str add-----
FUNCTION t510_get_qcd07(p_qcn04)
   DEFINE l_sql         STRING
   DEFINE p_qcn04       LIKE qcn_file.qcn04
   DEFINE l_qcc05       LIKE qcc_file.qcc05
   DEFINE l_qcc07       LIKE qcc_file.qcc07
   DEFINE l_qcc061      LIKE qcc_file.qcc061
   DEFINE l_qcc062      LIKE qcc_file.qcc062

      LET l_sql = " SELECT qcc07,qcc05,qcc061,qcc062 ",
                  " FROM qcc_file ",
                  " WHERE qcc01=? AND qcc02=? ",
                  " AND qcc08 in ('3','9')"
      PREPARE qcc_sel11 FROM l_sql
      EXECUTE qcc_sel11 USING g_qcm.qcm021, p_qcn04
           INTO l_qcc07,l_qcc05,l_qcc061,l_qcc062
      IF STATUS=100 THEN
         EXECUTE qcc_sel11 USING '*', p_qcn04
           INTO l_qcc05,l_qcc061,l_qcc062,l_qcc07
         IF STATUS=100 THEN
            LET l_sql = " SELECT qcd07,qcd05,qcd061,qcd062 ",
                        " FROM qcd_file ",
                        " WHERE qcd01=? AND qcd02=? "
            PREPARE qcc_sel12 FROM l_sql
            EXECUTE qcc_sel12 USING g_qcm.qcm021, p_qcn04
              INTO l_qcc07,l_qcc05,l_qcc061,l_qcc062
            IF STATUS=100 THEN
               LET l_sql = " SELECT qck07,qck05,qck061,qck062 ",
                       " FROM qck_file,ima_file ",
                       " WHERE ima01=? AND qck01=ima109 AND qck02=? ",
                       " AND qck08 in ('3','9')"
               PREPARE qcc_sel13 FROM l_sql
               EXECUTE qcc_sel13 USING g_qcm.qcm021, p_qcn04
                 INTO l_qcc07,l_qcc05,l_qcc061,l_qcc062
               IF STATUS=100 THEN
                  LET l_qcc07  = 'N'
                  LET l_qcc05  = ''
                  LET l_qcc061 = ''
                  LET l_qcc062 = ''
               END IF
            END IF
         END IF
      END IF

   RETURN l_qcc07,l_qcc05,l_qcc061,l_qcc062

END FUNCTION
#MOD-C70114 end add-----
#FUN-BC0104-add-str--
FUNCTION t510_qc_item_show()
   SELECT qcm09,qcm091
     INTO g_qcm.qcm09,g_qcm.qcm091
     FROM qcm_file
    WHERE qcm01 = g_qcm.qcm01
   DISPLAY BY NAME g_qcm.qcm09,g_qcm.qcm091
   CASE g_qcm.qcm09
        WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING des1
        WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING des1
        WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING des1
   END CASE
   DISPLAY des1 TO FORMONLY.des1
END FUNCTION
#FUN-BC0104-add-end-
#No:FUN-9C0071--------精簡程式-----
