# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axmp865.4gl
# Descriptions...: 三角貿易銷退單拋轉作業(逆拋)
# Date & Author..: 01/10/17 BY DS/P
# Modify.........: No:8981 04/01/28 By ching 增加銷退單逆拋功能
# Modify.........: No:9508 04/05/05 By ching 取得多角貿易匯率程式段，移至_p2()
# Modify.........: No:9713 04/07/01 By ching 以 oha02 傳入 s_mchksma53
# Modify.........: No.MOD-4B0148 04/11/15 ching tlf11,tlf12 單位錯誤
# Modify.........: No.FUN-550070 05/05/26 By Will 單據編號放大
# Modify.........: NO.FUN-560043 05/07/07 By Smapmin 根據雙單位做調整,多角序號放大,單號放大
# Modify.........: No.MOD-590251 05/09/14 By Smapmin ins imgg 在 INSERT 的欄位數量與 VALUES 的數量不符合
# Modify.........: No.MOD-620050 06/02/21 By Nicola SQL修改
# Modify.........: NO.FUN-620024 06/02/22 By yoyo 增加代送出貨單
# Modify.........: NO.TQC-650089 06/05/24 By yoyo 單身不為返利時才拋轉
# Modify.........: No.FUN-660167 06/06/23 By Ray cl_err --> cl_err3
# Modify.........: No.MOD-660122 06/06/30 By Rayven 當ima25與img09的單位一樣時，imgg21及imgg211所存的轉換率，也應該要一樣
# Modify.........: NO.FUN-710019 06/07/26 BY yiting oaz32->oax01
# Modify.........: No.MOD-680058 06/08/18 By day 增加對ohb1005的預設
# Modify.........: NO.FUN-710019 06/09/07 by yiting 1.s_mutislip移到p860_azp()之後，加傳入流程代碼/站別
#                                                   2.依apmi000設定站別抓取資料
#                                                   3.如果有設定中斷點，只拋轉到中斷點營運中心，所設營運中心之後段工廠不拋
# Modify.........: No.FUN-680137 06/09/15 By bnlent 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0094 06/10/31 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0044 06/11/13 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: NO.TQC-690057 06/11/15 BY Claire img_file值要取自imd_file
# Modify.........: No.FUN-6B0065 06/11/21 By Ray atmi217并入aooi313(azf09,10,11,12,13取代tqe03,04,05,11,08)
# Modify.........: NO.TQC-6A0084 06/12/05 By Nicola 含稅金額、未稅金額調整
# Modify.........: NO.MOD-670115 06/12/06 BY Claire 修改成出庫-1 
# Modify.........: NO.MOD-680066 06/12/06 By Claire ohb13取位
# Modify.........: NO.MOD-6C0086 06/12/14 BY Claire 語法調整
# Modify.........: NO.MOD-680020 06/12/27 By Mandy 當單頭的出貨單沒有輸入時,抓單身任何一筆出貨單
# Modify.........: NO.MOD-680022 06/12/27 By Mandy 單身的出貨單號可能不同時,所以在新增銷退單前,多角序號跟據出貨單號再重抓
# Modify.........: No.FUN-710046 07/01/23 By Jackho 增加批處理錯誤統整功能
# Modify.........: NO.CHI-710059 07/02/02 By jamie ogb14應為ogb917*ogb13
# Modify.........: NO.TQC-760054 07/06/06 By xufeng azf_file的index是azf_01(azf01,azf02),但是在抓‘中文說明’內容時，WHERE條件卻只有 azf01 = g_xxx
# Modify.........: No.CHI-770019 07/07/26 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: No.TQC-750014 07/08/14 By pengu 庫存轉換率異常
# Modify.........: No.TQC-770010 07/08/28 By claire 未帶出項次
# Modify.........: NO.MOD-780191 07/08/29 by yiting 拋轉時需檢查單別設定資料
# Modify.........: No.MOD-780264 07/08/31 By Claire 未回寫呆滯日期 
# Modify.........: NO.TQC-790003 07/09/03 BY yiting insert into前給予預設值
# Modify.........: No.MOD-790015 07/09/05 By Claire 銷退單匯率取原來訂單的匯率
# Modify.........: No.TQC-7B0083 07/11/22 By Carrier rvv88給預設值
# Modify.........: No.MOD-7B0263 07/11/30 By Claire 合併出貨狀況造成採購單取資料錯誤
# Modify.........: No.TQC-7C0064 07/12/08 By Beryl 判斷單別在拋轉資料庫是否存在，如果不存在，則報錯，批處理運行不成功．提示user單據別無效或不存在其資料庫中
# Modify.........: NO.TQC-7C0148 07/12/17 BY Yiting 多角貿易在判斷中斷點的寫法時應統一
# Modify.........: NO.TQC-7C0157 07/12/20 BY yiting 單別取法應依站別資料抓取
# Modify.........: No.MOD-810231 08/01/28 By Claire 寫入rvv38t 誤寫為rvv39t
# Modify.........: No.FUN-7B0018 08/03/05 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-830251 08/03/31 By Claire 以單身取訂單單號
# Modify.........: No.MOD-840033 08/04/03 By Claire 更新pmn58條件調整
# Modify.........: No.MOD-850181 08/05/20 By Claire 不更新oeb25,因oha09='1'同一般銷退處理
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: NO.MOD-860078 08/06/06 BY Yiting ON IDLE 處理
# Modify.........: NO.FUN-8A0086 08/10/21 By lutingting完善錯誤訊息匯總
# Modify.........: NO.MOD-8B0240 08/11/24 By claire 來源站沒有銷退單故不需檢核                                          
# Modify.........: NO.MOD-920016 09/02/03 By claire rvv39取位有誤                                        
# Modify.........: NO.MOD-920265 09/02/03 By claire ohb930,rvv930沒有給值 :                                     
# Modify.........: NO.MOD-950075 09/05/08 By Dido 抓取中斷點邏輯調整                                     
# Modify.........: NO.FUN-940083 09/05/19 By zhaijie調整批處理賦值
# Modify.........: No.TQC-970347 09/07/30 By Dido 最終站邏輯調整
# Modify.........: No.FUN-870007 09/08/19 By Zhangyajun s_mupimg傳參修改營運中心改成機構別
# Modify.........: No.FUN-980010 09/08/31 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980020 09/09/02 By douzh    GP5.2架構,修改SUB相關傳入參數 
# Modify.........: No.FUN-980059 09/09/09 By arman    GP5.2架構重整，修改相關SUB傳入參數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/21 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.CHI-950020 09/10/21 By chenmoyan 将自定义栏位的值抛转各站
# Modify.........: No.CHI-9B0008 09/11/11 By Dido 增加拋轉 tlf930
# Modify.........: No:TQC-9B0013 09/11/27 By Dido 單別於建檔刪除後,應控卡不可產生拋轉
# Modify.........: No.FUN-A10036 10/01/18 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位
# Modify.........: No:FUN-9C0071 10/01/18 By huangrh 精簡程式
# Modify.........: No.CHI-990031 10/01/28 By shiwuying 拋轉銷退單時各站都產生批/序號資料
#                                                      調用s_mupimg時p_no改傳單號，p_line改傳單號項次
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No:FUN-A50102 10/06/12 by lixh1  跨庫統一用cl_get_target_table()實現
# Modify.........: No:MOD-A90183 10/10/22 By Smapmin 產生到各站銷退單的含稅金額與來源站不符
# Modify.........: No:MOD-AB0083 10/11/10 By Smapmin 修正MOD-A90183
# Modify.........: No:MOD-AB0122 10/11/16 By Smapmin 倉退單價來源應為收貨單
# Modify.........: No.FUN-AB0061 10/11/17 By chenying 銷退單加基礎單價字段ohb37
# Modify.........: No.FUN-AB0061 10/11/17 By shenyang 出貨單加基礎單價字段ogb37
# Modify.........: No.FUN-AB0096 10/11/25 By vealxu 因新增ohb71,ogb50的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No.FUN-AC0055 10/12/21 By suncx 取消預設ohb71值，新增oha55欄位預設值
# Modify.........: No.FUN-AC0055 10/12/21 By wangxin oga57,ogb50欄位預設值修正
# Modify.........: No.FUN-AB0023 11/03/17 By Lilan EF整合功能(EasyFlow)
# Modify.........: No:TQC-B60065 11/06/16 By shiwuying 增加虛擬類型rvu27
# Modify.........: No:FUN-B70074 11/07/20 By fengrui 添加行業別表的新增於刪除
# Modify.........: No:FUN-B90012 11/09/15 By lixh1 增加多角ICD行業
# Modify.........: No:TQC-B90236 11/10/28 By zhuhao 寫入axmt840的rvbs_file的rvbs09=1,寫入apmt742的rvbs_file的rvbs09=-l
#                                                   s_mupimg(的倒數第三個參數應該傳-1
# Modify.........: No.FUN-BB0084 11/11/24 By lixh1 增加數量欄位小數取位
# Modify.........: No.FUN-BB0001 12/01/11 By pauline 新增rvv22,INSERT/UPDATE rvb22時,同時INSERT/UPDATE rvv22
# Modify.........: No.FUN-BA0051 12/01/12 By jason 一批號多DATECODE功能
# Modify.........: No:MOD-BC0187 12/02/17 By bart 拋轉無資料時要顯示訊息，不可顯示執行成功
# Modify.........: No:MOD-C30663 12/03/14 By ck2yuan tlfs07單位應寫img09
# Modify.........: No:FUN-C40072 12/05/25 By Sakura 加入or oga09='8'與oga65='Y'不可執行的判斷
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52
# Modify.........: NO.FUN-C50136 12/08/10 BY xianghui 銷退單逆拋時，如果走信用管控則需進行oib_file和oic_file的更新與插入
# Modify.........: No.CHI-C80009 12/08/15 By Sakura 一批號多DATECODE功能時,FOREACH需多傳倉儲批
# Modify.........: No.TQC-C80177 12/08/29 By SunLM  INSERT INTO ogb_file少了3个"?"
# Modify.........: No.FUN-C80001 12/08/29 By bart 多角拋轉時，批號需一併拋轉sma96
# Modify.........: No.CHI-C80042 12/08/30 By Vampire 多角入/出庫,正逆拋都要更新 ima73, ima74, ima29
# Modify.........: No.FUN-CB0087 12/12/21 By xianghui 庫存理由碼改善
# Modify.........: No.MOD-CC0215 12/12/26 By SunLM 修正SQL错误
# Modify.........: No:MOD-CC0289 12/12/31 By SunLM 插入tlfcost时候,根据ccz28参数(成本计算方式)
# Modify.........: No.TQC-D20050 13/02/26 By xianghui 理由碼調整
# Modify.........: No.TQC-D20047 13/02/27 By xianghui 理由碼調整
# Modify.........: No.TQC-D20067 13/02/28 By xujing   理由碼調整
# Modify.........: No.TQC-D30018 13/03/06 By chenjing 銷退單號增加開窗
# Modify.........: No:FUN-BC0062 13/03/08 By lixh1 當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
# Modify.........: No.FUN-CC0157 13/03/20 By zm tlf920赋值(配合发出商品修改)
# Modify.........: No:FUN-D30099 13/03/29 By Elise 將asms230的sma96搬到apms010,欄位改為pod08
# Modify.........: No.MOD-D50139 13/05/16 By SunLM 尾差調整
# Modify.........: No.TQC-D40064 13/06/19 By fengrui 理由碼調整

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_cmd           LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(100)
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(72)
DEFINE   g_forupd_sql STRING
DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
DEFINE g_oea   RECORD LIKE oea_file.*
DEFINE g_oeb   RECORD LIKE oeb_file.*
DEFINE g_oha   RECORD LIKE oha_file.*
DEFINE g_ohb   RECORD LIKE ohb_file.*
DEFINE g_oga   RECORD LIKE oga_file.*
DEFINE g_ogb   RECORD LIKE ogb_file.*
DEFINE l_oha   RECORD LIKE oha_file.*
DEFINE l_ohb   RECORD LIKE ohb_file.*
DEFINE l_rvv   RECORD LIKE rvv_file.*
DEFINE l_rvb   RECORD LIKE rvb_file.*
DEFINE l_rvu   RECORD LIKE rvu_file.*
DEFINE l_oga   RECORD LIKE oga_file.*
DEFINE l_ogb   RECORD LIKE ogb_file.*
DEFINE g_pmm   RECORD LIKE pmm_file.*
DEFINE g_pmn   RECORD LIKE pmn_file.*
DEFINE g_oan   RECORD LIKE oan_file.*
DEFINE g_poz   RECORD LIKE poz_file.*    #流程代碼資料(單頭) No.8047
DEFINE g_poy   RECORD LIKE poy_file.*    #流程代碼資料(單身) No.8047
DEFINE s_poy   RECORD LIKE poy_file.*    #來源流程資料(單身) No.8047
      ,g_imd10      LIKE imd_file.imd10,    #倉儲類別
       g_imd11      LIKE imd_file.imd11,    #是否為可用倉儲
       g_imd12      LIKE imd_file.imd12,    #MRP倉否
       g_imd13      LIKE imd_file.imd13,    #保稅否
       g_imd14      LIKE imd_file.imd14,    #生產發料順序
       g_imd15      LIKE imd_file.imd15     #銷售出貨順序
DEFINE tm RECORD
          oha05 LIKE oha_file.oha05, #No.FUN-680137 VARCHAR(01)
       #  wc  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)   #TQC-D30018
          wc  STRING                 #TQC-D30018
       END RECORD
DEFINE p_pmm09  LIKE pmm_file.pmm09     #廠商代號
DEFINE p_oea03  LIKE oea_file.oea03     #客戶代號
DEFINE p_imd01  LIKE imd_file.imd01     #各廠預設倉庫
DEFINE s_imd01  LIKE imd_file.imd01     #各廠預設倉庫(來源)
DEFINE g_flow99        LIKE oga_file.oga99 #No.FUN-680137 VARCHAR(17)  #多角序號   #FUN-560043
DEFINE g_oaz32         LIKE oaz_file.oaz32 #No.FUN-680137 VARCHAR(1)   #匯率方式
DEFINE s_dbs_new       LIKE type_file.chr21  #No.FUN-680137 VARCHAR(21)    #來源工廠
DEFINE l_dbs_new       LIKE type_file.chr21  #No.FUN-680137 VARCHAR(21)    #New DataBase Name
DEFINE l_dbs_tra       LIKE type_file.chr21  #FUN-980092 
DEFINE l_plant_new     LIKE type_file.chr21  #No.FUN-980020
DEFINE l_aza   RECORD LIKE aza_file.*
DEFINE l_azp   RECORD LIKE azp_file.*
DEFINE s_aza   RECORD LIKE aza_file.*
DEFINE s_azp   RECORD LIKE azp_file.*
DEFINE l_azi   RECORD LIKE azi_file.*
DEFINE g_sw    LIKE oaz_file.oaz32 #No.FUN-680137 VARCHAR(1)
DEFINE g_argv1  LIKE oha_file.oha01
DEFINE g_argv2  LIKE oha_file.oha04
DEFINE p_last   LIKE type_file.num5   #No.FUN-680137 SMALLINT                #流程之最後家數
DEFINE p_last_plant LIKE imd_file.imd01 #No.FUN-680137 VARCHAR(10)
DEFINE g_t1     LIKE oay_file.oayslip                #No.FUN-550070  #No.FUN-680137 VARCHAR(05)
DEFINE oga_t1   LIKE oay_file.oayslip #No.FUN-680137 VARCHAR(5)
DEFINE oha_t1   LIKE oay_file.oayslip #No.FUN-680137 VARCHAR(5)
DEFINE rva_t1   LIKE oay_file.oayslip #No.FUN-680137 VARCHAR(5)
DEFINE rvu_t1   LIKE oay_file.oayslip #No.FUN-680137 VARCHAR(5)
DEFINE l_oeb25  LIKE oeb_file.oeb25
DEFINE l_x      LIKE oay_file.oayslip #No.FUN-680137 VARCHAR(5)
DEFINE g_ima906 LIKE ima_file.ima906   #FUN-560043
DEFINE l_oay19  LIKE oay_file.oay19   #NO.FUN-620024
DEFINE l_oga01  LIKE oga_file.oga01   #No.FUN-620024
DEFINE l_azf10  LIKE azf_file.azf10   #NO.FUN-620024      #No.FUN-6B0065
DEFINE g_oga99  LIKE oga_file.oga99 #MOD-680022 add
DEFINE gp_legal   LIKE azw_file.azw02    #FUN-980010 add
DEFINE gp_plant   LIKE azp_file.azp01    #FUN-980010 add
 
MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM 
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN EXIT PROGRAM  END IF
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
    #若有傳參數則不用輸入畫面
    IF cl_null(g_argv1) THEN
       CALL p865_p1()
    ELSE
       LET tm.wc   = " oha01='",g_argv1,"' "
       LET tm.oha05= g_argv2
       CALL p865_p2()
    END IF
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION p865_p1()
 DEFINE l_i,l_flag LIKE type_file.num5   #No.FUN-680137 SMALLINT	
 
    OPEN WINDOW p865_w WITH FORM "axm/42f/axmp865"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
    CALL cl_opmsg('z')
 
 WHILE TRUE
    LET g_action_choice = ''
    LET tm.oha05='2'
    DISPLAY BY NAME tm.oha05
    CONSTRUCT BY NAME tm.wc ON oha01,oha02 HELP 1
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()

     #TQC-D30018--add--str--
        ON ACTION controlp
           CASE
              WHEN INFIELD(oha01)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_oha"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oha01
                NEXT FIELD oha01
           END CASE
     #TQC-D30018--add--end-- 
        ON ACTION locale
           LET g_action_choice='locale'
           EXIT CONSTRUCT
        ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
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
 
    END CONSTRUCT
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ohauser', 'ohagrup') #FUN-980030
    IF g_action_choice = 'locale' THEN
       CALL cl_dynamic_locale()
       CALL cl_show_fld_cont()   #FUN-550037(smin)
       CONTINUE WHILE
    END IF
    IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
    INPUT BY NAME tm.oha05 WITHOUT DEFAULTS HELP 1
        AFTER FIELD oha05
           IF cl_null(tm.oha05) THEN NEXT FIELD oha05 END IF
           IF tm.oha05 NOT MATCHES '[23]' THEN NEXT FIELD oha05 END IF
           #取得三角貿易使用匯率
           IF tm.oha05 = '2' THEN
              LET g_oaz32 = g_oax.oax01     #NO.FUN-710019
           ELSE
              SELECT pod01 INTO g_oaz32 FROM pod_file
               WHERE pod00 = '0'
           END IF
           IF cl_null(g_oaz32) THEN LET g_oaz32 = 'S' END IF
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
           call cl_cmdask()
        ON ACTION locale
           LET g_action_choice='locale'
           EXIT INPUT
        ON ACTION exit
           LET INT_FLAG = 1
           EXIT INPUT
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
    END INPUT
    IF g_action_choice = 'locale' THEN
       CALL cl_dynamic_locale()
       CALL cl_show_fld_cont()   #FUN-550037(smin)
       CONTINUE WHILE
    END IF
    IF INT_FLAG THEN LET INT_FLAG=0 EXIT WHILE END IF
    IF cl_sure(0,0) THEN
       CALL p865_p2()
       IF g_success = 'Y' THEN
          CALL cl_end2(1) RETURNING l_flag
       ELSE
          CALL cl_end2(2) RETURNING l_flag
       END IF
       IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
    END IF
 END WHILE
 CLOSE WINDOW p865_w
END FUNCTION
 
FUNCTION p865_p2()
# DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200) #TQC-D30018 
# DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600) #TQC-D30018
# DEFINE l_sql2  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)#TQC-D30018
  DEFINE l_sql   STRING        #TQC-D30018
  DEFINE l_sql1  STRING        #TQC-D30018
  DEFINE l_sql2  STRING        #TQC-D30018
  DEFINE i,l_i    LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_j    LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_msg  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(60)
  DEFINE l_poy04_last  LIKE poy_file.poy04 #NO.FUN-710019
  DEFINE l_c           LIKE type_file.num5    #No.FUN-680137 SMALLINT  #NO.FUN-710019
  DEFINE l_cnt         LIKE type_file.num5    #No.TQC-7C0064 SMALLINT
  DEFINE l_poy02       LIKE poy_file.poy02    #no.TQC-7C0148
  DEFINE k             LIKE type_file.num5    #no.TQC-7C0157 add
  DEFINE l_err         LIKE type_file.chr1    #MOD-950075
  DEFINE l_cnt0        LIKE type_file.num5    #MOD-BC0187 add
  
  #取得三角貿易使用匯率
  IF tm.oha05 = '2' THEN
     LET g_oaz32 = g_oax.oax01    #NO.FUN-710019
  ELSE
     SELECT pod01 INTO g_oaz32 FROM pod_file
      WHERE pod00 = '0'
  END IF
  IF cl_null(g_oaz32) THEN LET g_oaz32 = 'S' END IF
 
  CALL cl_wait()
  BEGIN WORK
  LET g_success='Y'
  LET l_cnt0 = 0  #MOD-BC0187 add
  #讀取符合條件之三角貿易銷退單資料
  LET l_sql="SELECT * FROM oha_file ",
            " WHERE oha41='Y' ",   #三角貿易銷退單
             " AND oha44='N'  ",   #拋轉否
             " AND oha43='Y' ",    #必須為起始銷退單
             " AND ohaconf = 'Y' ", #01/08/17 mandy
             " AND ohapost = 'Y' ",
             " AND ",tm.wc CLIPPED
  LET l_sql = l_sql CLIPPED, " AND oha05 IN ('4','",tm.oha05,"')"  #No.8047  #No.FUN-620024
  PREPARE p865_p1 FROM l_sql
  IF STATUS THEN CALL cl_err('pre1',STATUS,1) END IF
  DECLARE p865_curs1 CURSOR FOR p865_p1
  CALL s_showmsg_init()   #No.FUN-710046
  FOREACH p865_curs1 INTO g_oha.*
     IF SQLCA.SQLCODE <> 0 THEN
        LET g_success = 'N'          #No.FUN-8A0086
        EXIT FOREACH
     END IF
     IF g_success='N' THEN                                                                                                          
        LET g_totsuccess='N'                                                                                                       
        LET g_success="Y"                                                                                                          
     END IF             
     IF cl_null(g_oha.oha16) THEN 
         #抓單身任何一筆出貨單號
         SELECT MAX(ohb31) INTO g_oha.oha16 FROM ohb_file
          WHERE ohb01 = g_oha.oha01
     END IF
     #讀取該銷退單之出貨單資料
     SELECT * INTO g_oga.*
       FROM oga_file
      WHERE oga01 = g_oha.oha16
        DECLARE oea_cs CURSOR FOR
         SELECT * FROM oea_file,ohb_file
          WHERE ohb33 = oea01
            AND ohb01 = g_oha.oha01
            AND oeaconf = 'Y'
          ORDER BY ohb03
     FOREACH oea_cs INTO g_oea.*
          IF SQLCA.sqlcode <> 0 THEN EXIT FOREACH END IF
     IF g_oea.oea902 = 'N' THEN
        LET g_showmsg=g_oga.oga16,"/",'Y'
        CALL s_errmsg('oea01,oeaconf',g_showmsg,'','tri-022',1)
        LET g_success = 'N'
        CONTINUE FOREACH  
     END IF
     #檢查各工廠關帳日(sma53)
     IF s_mchksma53(g_oea.oea904,g_oha.oha02) THEN #No.9713
        LET g_success='N' EXIT FOREACH
     END IF
     END FOREACH  #MOD-830251
     #讀取三角貿易流程代碼資料
     SELECT * INTO g_poz.* FROM poz_file WHERE poz01=g_oea.oea904
     IF SQLCA.sqlcode THEN
         CALL s_errmsg('poz01',g_oea.oea904,g_oea.oea904,'axm-318',1)
         LET g_success = 'N'
         CONTINUE FOREACH  
     END IF
     IF tm.oha05 = '2' AND g_poz.poz00='2' THEN
        CALL s_errmsg('','',g_oea.oea904,'tri-008',1)
        LET g_success = 'N'
        CONTINUE FOREACH  
     END IF
     IF tm.oha05 = '3' AND g_poz.poz00='1' THEN
        CALL s_errmsg('','',g_oea.oea904,'tri-008',1)
        LET g_success = 'N'
        CONTINUE FOREACH  
     END IF
     IF g_poz.pozacti = 'N' THEN
        CALL s_errmsg('','',g_oea.oea904,'tri-009',1)
        LET g_success = 'N'
        CONTINUE FOREACH  
     END IF
     IF g_poz.poz011 = '1' THEN
        CALL s_errmsg('','','','tri-023',1)
        LET g_success = 'N'
        CONTINUE FOREACH  
     END IF
     CALL p865_flow99()                           #No.8047 取得多角序號
     CALL p865_last() RETURNING l_err
     IF l_err = '1' THEN
        CALL s_errmsg('','','','axm-410',1) 
        CONTINUE FOREACH  
     END IF
     #依流程代碼最多6層
     FOR i = p_last TO 0 STEP -1
           IF i=p_last THEN CONTINUE FOR END IF   #最後一家不拋轉
           LET k = i+1                            #NO.TQC-7C0157 add
           #得到廠商/客戶代碼及database
           CALL p865_azp(i)
 
           LET g_t1 = s_get_doc_no(g_oha.oha01)       #No.FUN-550070
           CALL s_mutislip('2','1',g_t1,g_poz.poz01,i)
                RETURNING g_sw,oha_t1,l_x,l_x,l_x,l_x       #no.TQC-7C0157 modify
           IF g_sw THEN
              LET g_success = 'N' 
              EXIT FOR                   #No.FUN-710046
           END IF
 
           #--- 抓取倉退單單別-----------------
           CALL s_mutislip('2','1',g_t1,g_poz.poz01,k)
                RETURNING g_sw,l_x,rvu_t1,l_x,l_x,l_x  
           IF g_sw THEN
              LET g_success = 'N' 
              EXIT FOR      
           END IF
 
          IF tm.oha05='2' THEN  #MOD-8B0240 add
           IF cl_null(oha_t1) THEN
               CALL cl_err('','axm4019',1)
               LET g_success = 'N'
               EXIT FOREACH
           ELSE                                                                                                                     
              LET l_cnt = 0                                                                                                        
              #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs_new,"oay_file ",     #FUN-A50102
              LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table( l_plant_new, 'oay_file' ),   #FUN-A50102
                          " WHERE oayslip = '",oha_t1,"'"                                                                           
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, l_plant_new ) RETURNING l_sql   #FUN-A50102
              PREPARE oay_pre1 FROM l_sql                                                                                           
              EXECUTE oay_pre1 INTO l_cnt                                                                                          
              IF l_cnt = 0 THEN                                                                                                    
                 LET g_msg = l_dbs_new CLIPPED,oha_t1 CLIPPED                                                                       
                 CALL cl_err3("","","","",'axm-931',"","g_msg",1)                                                                   
                 LET g_success = 'N'                                                                                                
                 EXIT FOREACH                                                                                                       
              END IF                                                                                                                
           END IF
          END IF  #MOD-8B0240 add
           IF cl_null(rvu_t1) THEN
               CALL cl_err('','axm4020',1)
               LET g_success = 'N'
               EXIT FOREACH
           ELSE                                                                                                                     
              LET l_cnt = 0                                                                                                        
             # LET l_sql = "SELECT COUNT(*) FROM ",l_dbs_new,"smy_file ",    #FUN-A50102
              LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table( l_plant_new, 'smy_file' ),   #FUN-A50102
                          " WHERE smyslip = '",rvu_t1,"'"                                                                           
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, l_plant_new ) RETURNING l_sql   #FUN-A50102
              PREPARE smy_pre2 FROM l_sql                                                                                           
              EXECUTE smy_pre2 INTO l_cnt                                                                                          
              IF l_cnt = 0 THEN                                                                                                    
                 LET g_msg = l_dbs_new CLIPPED,rvu_t1 CLIPPED                                                                       
                 CALL cl_err3("","","","",'axm-931',"","g_msg",1)                                                                   
                 LET g_success = 'N'                                                                                                
                 EXIT FOREACH                                                                                                       
              END IF                                                                                                                
           LET l_cnt = 0             #TQC-7C0064            
           END IF
           CALL p865_chk99()            #No.8047
           CALL p865_azi(g_oea.oea23)   #讀取幣別資料
#No.CHI-990031 --Begin
         #  LET l_sql2 = "INSERT INTO ",l_dbs_new CLIPPED,"rvbs_file",  #FUN-A50102
           LET l_sql2 = "INSERT INTO ",cl_get_target_table( l_plant_new, 'rvbs_file' ),   #FUN-A50102
             "(rvbs00,rvbs01,rvbs02,rvbs021,rvbs022,rvbs03,",
             " rvbs04,rvbs05,rvbs06,rvbs07,rvbs08,rvbs09,rvbs13) ",
             " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?) "
           CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
           CALL cl_parse_qry_sql( l_sql2, l_plant_new ) RETURNING l_sql2   #FUN-A50102
           PREPARE ins_rvbs FROM l_sql2
#No.CHI-990031 --End
 
           #讀取該流程代碼之採購單資料
              LET l_sql1 = "SELECT * ",
                         #  " FROM ",l_dbs_tra CLIPPED,"pmm_file ",  #FUN-980092    #FUN-A50102
                           " FROM ",cl_get_target_table( l_plant_new, 'pmm_file' ),   #FUN-A50102
                           " WHERE pmm99='",g_oea.oea99,"' AND pmm18 <> 'X'"
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
           PREPARE pmm_p1 FROM l_sql1
           IF SQLCA.SQLCODE THEN 
              CALL s_errmsg('pmm99',g_oea.oea99,'pmm_p1',SQLCA.SQLCODE,0)
           END IF
           DECLARE pmm_c1 CURSOR FOR pmm_p1
           OPEN pmm_c1
           FETCH pmm_c1 INTO g_pmm.*
           IF SQLCA.SQLCODE <> 0 THEN
              CALL s_errmsg('pmm99',g_oea.oea99,'sel pmm',status,1)
              LET g_success='N' 
              EXIT FOR
           END IF
           CLOSE pmm_c1
 
#--找出最尾站別的營運中心
         LET l_c = 0
         SELECT COUNT(*) INTO l_c   #check poz18設定的中斷營運中心是否存在單身設>
           FROM poy_file
         WHERE poy01 = g_poz.poz01
           AND poy04 = g_poz.poz18
 
         SELECT poy02 INTO l_poy02
           FROM poy_file
          WHERE poy01 = g_poz.poz01
            AND poy04 = g_poz.poz18
         IF g_poz.poz19 = 'Y' AND l_c > 0  THEN
             IF i < =l_poy02 THEN    #目前站別小於等於設定中斷點的營運中心時
                 EXIT FOR 
             END IF
         END IF
 
             #新增銷退單單頭檔(oha_file)
             IF g_oha.oha05 = '4' OR tm.oha05 = '2' OR (tm.oha05='3' AND i <> 0) THEN  ##No.FUN-620024
                CALL p865_ohains()
             END IF
             #新增倉退單單頭檔(rvu_file)-->l_dbs_new
             CALL p865_rvuins()
             IF g_success='N' THEN EXIT FOR END IF
             #讀取銷退單身檔(ohb_file)
             DECLARE  ohb_cus CURSOR FOR
                SELECT * FROM ohb_file WHERE ohb01 = g_oha.oha01
             FOREACH ohb_cus INTO g_ohb.*
                 IF g_ohb.ohb1005='2' THEN
                    CONTINUE FOREACH
                 END IF
                 IF SQLCA.SQLCODE <>0 THEN
                    CALL s_errmsg('ohb01',g_oha.oha01,'foreach ohb:',SQLCA.SQLCODE,1)   #No.FUN-710046
                    LET g_success='N'  EXIT FOREACH
                 END IF
                 SELECT ima906 INTO g_ima906 FROM ima_file
                         WHERE ima01 = g_ohb.ohb04
                #No.CHI-990031 --Begin
                 DECLARE p860_g_rvbs CURSOR FOR SELECT * FROM rvbs_file
                   WHERE rvbs01 = g_oha.oha01
                     AND rvbs02 = g_ohb.ohb03
                #No.CHI-990031 --End
          #FUN-B90012 -----------Begin-------------
                 IF s_industry('icd') THEN
                    DECLARE p865_g_idd CURSOR FOR SELECT * FROM idd_file
                                        WHERE idd10 = g_oha.oha01
                                          AND idd11 = g_ohb.ohb03
                 END IF 
          #FUN-B90012 -----------End---------------
                 LET g_oga99 = NULL
                 SELECT oga99 INTO g_oga99
                   FROM oga_file
                  WHERE oga01= g_ohb.ohb31
 
               LET l_sql1 = "SELECT oea99 ",
                            " FROM oea_file ",                #no.MOD-7B0263 銷退單單身訂單只要抓本站就好 
                            " WHERE oea01='",g_ohb.ohb33,"' "
               
               PREPARE oea_p11 FROM l_sql1
               IF SQLCA.SQLCODE THEN CALL cl_err('oea_p11',SQLCA.SQLCODE,1) END IF
               DECLARE oea_c11 CURSOR FOR oea_p11
               OPEN oea_c11
               FETCH oea_c11 INTO g_oea.oea99
               IF SQLCA.SQLCODE <> 0 THEN
                  CALL cl_err('sel oea',status,1) LET g_success='N' RETURN
                END IF
               CLOSE oea_c11
                
                LET l_sql1 = "SELECT * ",
                       #      " FROM ",l_dbs_tra CLIPPED,"pmm_file ",  #FUN-980092  #FUN-A50102
                             " FROM ",cl_get_target_table( l_plant_new, 'pmm_file' ),   #FUN-A50102
                       
                             " WHERE pmm99='",g_oea.oea99,"' AND pmm18 <> 'X'"
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
                PREPARE pmm_p11 FROM l_sql1
                IF SQLCA.SQLCODE THEN CALL cl_err('pmm_p1',SQLCA.SQLCODE,1) END IF
                DECLARE pmm_c11 CURSOR FOR pmm_p11
                OPEN pmm_c11
                FETCH pmm_c11 INTO g_pmm.*
                IF SQLCA.SQLCODE <> 0 THEN
                   CALL cl_err('sel pmm',status,1) LET g_success='N' RETURN
                END IF
                CLOSE pmm_c11
 
                 #新增銷退單單身檔(ohb_file)
                 IF g_oha.oha05='4' OR tm.oha05 = '2' OR (tm.oha05='3' AND i <> 0)  THEN #No.8047   #No.FUN-620024
                    CALL p865_ohbins(i)
                    IF g_success='N' THEN 
                       EXIT FOREACH
                    END IF
                    CALL p865_log(l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,
                                  l_ohb.ohb092,l_ohb.ohb12,'1')
                    IF g_success='N' THEN EXIT FOREACH END IF
                 END IF
                 #新增倉退單單身檔(rvv_file)
                 CALL p865_rvvins(i)
                 IF g_success='N' THEN EXIT FOREACH END IF
                 CALL p865_log(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                               l_rvv.rvv17,'3')
                 IF g_success='N' THEN EXIT FOREACH END IF
                 # 代採買替來源廠做出庫更新
                 IF tm.oha05 = '3' AND i = 0 THEN
                      CALL s_mupimg(-1,l_rvv.rvv31,   #MOD-670115
                                    l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                                    l_rvv.rvv17*l_rvv.rvv35_fac,  #MOD-4B0148
                                   #g_oha.oha02,l_plant_new,0,'','')  #FUN-980092 #No.CHI-990031
                                   #g_oha.oha02,l_plant_new,0,l_rvv.rvv01,l_rvv.rvv02)#No.CHI-990031    #TQC-B90236
                                    g_oha.oha02,l_plant_new,-1,l_rvv.rvv01,l_rvv.rvv02)#No.CHI-990031   #TQC-B90236
                    IF g_ima906 = '2' THEN
                          CALL s_mupimgg(-1,l_rvv.rvv31,  #MOD-670115
                                           l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                                           l_rvv.rvv80,l_rvv.rvv82,
                                           g_oha.oha02,
                                           l_plant_new)   #FUN-980092
                          CALL s_mupimgg(-1,l_rvv.rvv31,  #MOD-670115
                                           l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                                           l_rvv.rvv83,l_rvv.rvv85,
                                           g_oha.oha02,
                                           l_plant_new)   #FUN-980092
                    END IF
                    IF g_ima906='3' THEN
                          CALL s_mupimgg(-1,l_rvv.rvv31,  #MOD-670115
                                           l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                                           l_rvv.rvv83,l_rvv.rvv85,
                                           g_oha.oha02,
                                           l_plant_new)     #FUN-980092
                    END IF
                    CALL s_mudima(l_rvv.rvv31,l_plant_new)  #FUN-980092
                 END IF
                 IF g_success='N' THEN EXIT FOREACH END IF
 
                # LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"pmn_file",  #FUN-980092   #FUN-A50102
                 LET l_sql2="UPDATE ",cl_get_target_table( l_plant_new, 'pmn_file' ),   #FUN-A50102
                         "     SET pmn58 = pmn58 + ? ",
                         " WHERE pmn01 = ? AND pmn02 = ? "  #MOD-840033
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                 PREPARE upd_pmn FROM l_sql2
                 EXECUTE upd_pmn USING
                     l_ohb.ohb12,
                     g_pmm.pmm01,l_ohb.ohb34                #MOD-840033
                 IF SQLCA.sqlcode<>0 THEN
                    LET g_showmsg=l_ohb.ohb33,"/",l_ohb.ohb34
                    CALL s_errmsg('pmn24,pmn25',g_showmsg,'upd pmn:',SQLCA.sqlcode,1)
                  LET g_success = 'N' EXIT FOREACH
                 END IF
 
                 IF l_aza.aza50='Y' THEN   #使用分銷功能
                    IF l_oha.oha05='4' THEN
                        CALL p865_log(l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,
                                      l_ohb.ohb092,l_ohb.ohb12,'2') 
                    END IF
                 END IF 
             END FOREACH {ohb_cus}
             IF g_success='N' THEN EXIT FOREACH END IF
 
 
     END FOR  {一個訂單流程代碼結束}
 
     MESSAGE ''
 
     #更新起始銷退單單頭檔之拋轉否='Y'
     UPDATE oha_file
        SET oha44='Y'
      WHERE oha01=g_oha.oha01
     IF SQLCA.SQLCODE <> 0 THEN
        CALL cl_err3("upd","oha_file",g_oha.oha01,"",STATUS,"","upd oha44",1)   #No.FUN-660167
        LET g_success='N'
     END IF
     LET l_cnt0 = l_cnt0 + 1  #MOD-BC0187 add
  END FOREACH
  IF g_totsuccess="N" THEN                                                                                                         
     LET g_success="N"                                                                                                             
  END IF 
  CALL s_showmsg()   
  #MOD-BC0187 add --start--
  IF l_cnt0 = 0 THEN
     CALL cl_err('','mfg3160',1)
     LET g_success = 'N'
  END IF
  #MOD-BC0187 add --end--  
  IF g_success = 'Y'
      THEN COMMIT WORK
      ELSE ROLLBACK WORK
  END IF
END FUNCTION
 
#檢查最終站
FUNCTION p865_last()
DEFINE l_last        LIKE poy_file.poy02
DEFINE l_last_plant  LIKE poy_file.poy04
DEFINE l_poz18       LIKE poz_file.poz18   
DEFINE l_poz19       LIKE poz_file.poz19   
DEFINE l_break       LIKE poy_file.poy02   
DEFINE l_now         LIKE poy_file.poy02   
DEFINE l_err         LIKE type_file.chr1   
 
  LET l_err = "0"   
 
  SELECT MAX(poy02) INTO l_last FROM poy_file
   WHERE poy01 = g_poz.poz01 			#TQC-970347
     AND poy02 <> 99   
  IF STATUS THEN
     CALL cl_err3("sel","poy_file",g_poz.poz01,"","axm-318","","",1)  	#TQC-970347
     RETURN ''
  END IF
  LET p_last = l_last 					#TQC-970347
 
  SELECT poy04 INTO l_last_plant FROM poy_file
   WHERE poy01 = g_poz.poz01 AND poy02 = l_last		#TQC-970347
   IF cl_null(l_last_plant) THEN
      LET l_err ="1"
      CALL cl_err('','axm-318',1)
   END IF
 
   SELECT poz18,poz19 INTO l_poz18,l_poz19 FROM poz_file
    WHERE poz01 = g_poz.poz01				#TQC-970347
   IF l_poz19 = "Y" THEN
      SELECT poy02 INTO l_break FROM poy_file
       WHERE poy04 = l_poz18
 
      SELECT poy02 INTO l_now FROM poy_file
       WHERE poy04 = g_plant
 
      IF l_last_plant != l_now THEN
         IF l_now > l_break THEN
            LET l_err ="1"
            CALL cl_err(g_plant,'axm-410',1)
         ELSE
            LET g_oga.oga906 ='Y'
         END IF
      END IF
   ELSE
      IF l_last_plant != g_plant THEN
         LET l_err ="1"
         CALL cl_err(g_plant,'axm-410',1)
      END IF
   END IF
 
   RETURN l_err
 
END FUNCTION
 
FUNCTION p865_azp(l_n)
  DEFINE l_source LIKE type_file.num5,    #No.FUN-680137 SMALLINT    #來源站別
         l_n      LIKE type_file.num5,      #當站站別  #No.FUN-680137 SMALLINT
         l_n2     LIKE type_file.num5,      #前一站別  #No.FUN-680137 SMALLINT
         l_sql1   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(800)
  DEFINE l_poy11  LIKE poy_file.poy11
  DEFINE l_poy03  LIKE poy_file.poy03    #FUN-710019
 
     LET l_poy11=''
     INITIALIZE s_poy.* TO NULL
     INITIALIZE g_poy.* TO NULL
     ##-------------取得下一站資料庫----------------------
      LET l_n2     = l_n + 1             #前一站別
      LET l_source = l_n - 1             #來源站別
        SELECT * INTO s_poy.* FROM poy_file
         WHERE poy01 = g_poz.poz01 AND poy02 = l_n2            
        SELECT * INTO s_azp.* FROM azp_file WHERE azp01=s_poy.poy04   #FUN-710019
        LET s_dbs_new = s_dbstring(s_azp.azp03)  #TQC-950032  ADD
 
     ##-------------取得當站資料庫----------------------
      SELECT * INTO g_poy.* FROM poy_file               #取得當站流程設定
       WHERE poy01 = g_poz.poz01 AND poy02 = l_n
 
      SELECT * INTO l_azp.* FROM azp_file WHERE azp01=g_poy.poy04
      LET l_plant_new = l_azp.azp01                            #FUN-980020
      LET l_dbs_new = s_dbstring(l_azp.azp03)  #TQC-950032  ADD
 
      LET gp_plant = g_poy.poy04            
      CALL s_getlegal(gp_plant) RETURNING gp_legal 
 
     #------GP5.2 Modify #改抓Transaction DB
     LET l_plant_new = g_poy.poy04
     LET g_plant_new = l_azp.azp01
#     CALL s_gettrandbs()        #FUN-A50102
#     LET l_dbs_tra = g_dbs_tra  #FUN-A50102
 
      LET l_sql1 = "SELECT * ",
                 #  " FROM ",l_dbs_new CLIPPED,"aza_file ", #FUN-A50102
                   " FROM ",cl_get_target_table( l_plant_new, 'aza_file' ),   #FUN-A50102
                   " WHERE aza01 = '0' "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql( l_sql1, l_plant_new ) RETURNING l_sql1   #FUN-A50102
      PREPARE aza_p2 FROM l_sql1
      IF SQLCA.SQLCODE THEN 
         CALL s_errmsg('azp',g_poy.poy04,'aza_p2',SQLCA.SQLCODE,1)
      END IF
      DECLARE aza_c2 CURSOR FOR aza_p2
      OPEN aza_c2
      FETCH aza_c2 INTO l_aza.*
      CLOSE aza_c2
      LET p_pmm09 = g_poy.poy03    #供應廠商
      LET p_imd01 = g_poy.poy11    #倉庫別
      LET s_imd01 = s_poy.poy11    #倉庫別 #No.8858    #FUN-710019 
 
 
      #若為來源廠
      IF l_n = 0 THEN
        # LET l_sql1= " SELECT oea03 FROM ",l_dbs_tra,"oea_file",  #FUN-980092  #FUN-A50102
         LET l_sql1= " SELECT oea03 FROM ",cl_get_target_table( l_plant_new, 'oea_file' ),   #FUN-A50102
                     "  WHERE oea01 = '",g_oea.oea01,"'"
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
         PREPARE oea03_pre FROM l_sql1
         DECLARE oea03_cs CURSOR FOR oea03_pre
         OPEN oea03_cs FETCH oea03_cs INTO p_oea03
         SELECT poy03 INTO p_pmm09 FROM poy_file
          WHERE poy01 = g_poz.poz01 AND poy02 = 1  
      END IF
END FUNCTION
 
FUNCTION p865_ohains()
  DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)
  DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)
  DEFINE l_sql2  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)
  DEFINE i,l_i    LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE li_result LIKE type_file.num5     #FUN-560043  #No.FUN-680137 SMALLINT
 
  #讀取該流程代碼之出資單資料
   LET l_sql1 = "SELECT * ",
               # " FROM ",l_dbs_tra CLIPPED,"oga_file ",   #FUN-980092   #FUN-A50102
                " FROM ",cl_get_target_table( l_plant_new, 'oga_file' ),   #FUN-A50102
                " WHERE oga99='",g_oga.oga99,"' ",  #No.9379
               #"   AND (oga09='4' OR oga09='6')"   #No.MOD-620050  #FUN-C40072 mark
                "   AND (oga09='4' OR oga09='6' OR oga09='8')",     #FUN-C40072 add
                "   AND oga65 = 'N'"                                #FUN-C40072 add
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
   PREPARE oga_p1 FROM l_sql1
   IF STATUS THEN
      CALL s_errmsg('oga99',g_oga.oga99,'oga_p1',STATUS,0)           #No.FUN-710046
   END IF
   DECLARE oga_c1 CURSOR FOR oga_p1
   OPEN oga_c1
   FETCH oga_c1 INTO l_oga.*
   IF SQLCA.SQLCODE <> 0 THEN
      CALL s_errmsg('oga99',g_oga.oga99,'fetch oga',SQLCA.SQLCODE,1)           #No.FUN-710046
      LET g_success='N'
      RETURN
   END IF
   CLOSE oga_c1
   #新增銷退單單頭檔(oha_file)
      CALL s_auto_assign_no("axm",oha_t1,g_oha.oha02,"","","",l_plant_new,"","") #FUN-980092
         RETURNING li_result,l_oha.oha01
      IF (NOT li_result) THEN 
         LET g_msg = l_plant_new CLIPPED,l_oha.oha01
         CALL s_errmsg("oha01",l_oha.oha01,g_msg CLIPPED,"mfg3046",1) 
         LET g_success ='N'
         RETURN
      END IF   
      IF l_aza.aza50='Y' THEN
         IF l_oga.oga00='6' THEN
            LET l_oha.oha05='4' 
           ELSE
            LET l_oha.oha05='2'
         END IF
         LET l_oha.oha1001=l_oga.oga18
         LET l_oha.oha1003=l_oga.oga1003
         IF g_poy.poy31 IS NOT NULL THEN
            LET l_oha.oha1004=g_poy.poy31  
            LET l_oha.oha1002=l_oga.oga1002
         ELSE 
            LET l_oha.oha1004=g_oha.oha1004
            LET l_oha.oha1002=g_oha.oha1002
         END IF
         LET l_oha.oha1005=g_oea.oea1005
         LET l_oha.oha1006=0
         LET l_oha.oha1007=0
         LET l_oha.oha1008=0
         LET l_oha.oha1009=l_oga.oga1009
         LET l_oha.oha1010=l_oga.oga1010
         LET l_oha.oha1011=l_oga.oga1011
         LET l_oha.oha1012=' '
         LET l_oha.oha1013=' '
         LET l_oha.oha1014=l_oga.oga1004
         LET l_oha.oha1015='N'
         LET l_oha.oha1016=l_oga.oga1001
         LET l_oha.oha1017='0'
         LET l_oha.oha1018=' '
      ELSE 
         LET l_oha.oha05 = g_oha.oha05
         LET l_oha.oha1001=' '                                                                                      
         LET l_oha.oha1002=' '                                                                                                      
         LET l_oha.oha1003=' '                                                                                                      
         LET l_oha.oha1004=' '                                                                                                      
         LET l_oha.oha1005=' '                                                                                                      
         LET l_oha.oha1006=0                                                                                                        
         LET l_oha.oha1007=0                                                                                                        
         LET l_oha.oha1008=0                                                                                                        
         LET l_oha.oha1009=' '                                                                                                      
         LET l_oha.oha1010=' '                                                                                                      
         LET l_oha.oha1011=' '                                                                                                      
         LET l_oha.oha1012=' '                                                                                                      
         LET l_oha.oha1013=' '                                                                                                      
         LET l_oha.oha1014=' '                                                                                                      
         LET l_oha.oha1015=' '                                                                                                      
         LET l_oha.oha1016=' '                                                                                                      
         LET l_oha.oha1017='0'                                                                                                      
         LET l_oha.oha1018=' '      
      END IF
      IF cl_null(l_oha.oha1004) THEN LET l_oha.oha1004=g_poy.poy31 END IF  #TQC-D40064 add
      LET l_oha.oha02 = g_oha.oha02        #銷退日期
      LET l_oha.oha03 = l_oga.oga03        #帳款客戶
      LET l_oha.oha032= l_oga.oga032       #帳款客戶簡稱
      LET l_oha.oha04 = l_oga.oga04       #退貨客戶編號
      LET l_oha.oha08 = l_oga.oga08       #內/外銷
      LET l_oha.oha09 = g_oha.oha09        #銷退處理方式
      LET l_oha.oha10 = null               #帳單編號
      LET l_oha.oha14 = l_oga.oga14        #人員編號
      LET l_oha.oha15 = l_oga.oga15        #部門編號
      LET l_oha.oha16 = l_oga.oga01        #出貨單號
      LET l_oha.oha21 = l_oga.oga21        #稅別
      LET l_oha.oha211= l_oga.oga211       #稅率
      LET l_oha.oha212= l_oga.oga212       #聯數
      LET l_oha.oha213= l_oga.oga213       #含稅否
      LET l_oha.oha23 = l_oga.oga23        #幣別
      LET l_oha.ohaud01 = l_oga.ogaud01
      LET l_oha.ohaud02 = l_oga.ogaud02
      LET l_oha.ohaud03 = l_oga.ogaud03
      LET l_oha.ohaud04 = l_oga.ogaud04
      LET l_oha.ohaud05 = l_oga.ogaud05
      LET l_oha.ohaud06 = l_oga.ogaud06
      LET l_oha.ohaud07 = l_oga.ogaud07
      LET l_oha.ohaud08 = l_oga.ogaud08
      LET l_oha.ohaud09 = l_oga.ogaud09
      LET l_oha.ohaud10 = l_oga.ogaud10
      LET l_oha.ohaud11 = l_oga.ogaud11
      LET l_oha.ohaud12 = l_oga.ogaud12
      LET l_oha.ohaud13 = l_oga.ogaud13
      LET l_oha.ohaud14 = l_oga.ogaud14
      LET l_oha.ohaud15 = l_oga.ogaud15
       IF l_oga.oga24=0 OR l_oga.oga24 IS NULL THEN
          CALL s_currm(l_oha.oha23,l_oha.oha02,g_oaz32,l_plant_new)  #FUN-980020
                 RETURNING l_oha.oha24
       ELSE
          LET l_oha.oha24 = l_oga.oga24
       END IF
      #若出貨單頭之幣別=本幣幣別, 則匯率給1, (COI美金立帳, 99.03.05)
      IF l_oha.oha23 = l_aza.aza17 THEN
         LET l_oha.oha24=1
      END IF
      IF cl_null(l_oha.oha24) THEN LET l_oha.oha24=l_oga.oga24 END IF
      LET l_oha.oha25 = l_oga.oga25        #銷售分類一
      LET l_oha.oha26 = l_oga.oga26        #銷售分類二
      LET l_oha.oha31 = l_oga.oga31        #價格條件
      LET l_oha.oha41 = 'Y'                #三角貿易銷退否
      LET l_oha.oha42 = 'Y'                #是否入庫存
      LET l_oha.oha43 = 'N'                #起始銷退單否
      LET l_oha.oha44 = 'Y'                #拋轉否
      LET l_oha.oha45 = null               #No Use
      LET l_oha.oha46 = null               #No Use
      LET l_oha.oha47 = null               #運送車號
      LET l_oha.oha48 = g_oha.oha48        #備註
      LET l_oha.oha50 = 0                  #原幣銷退總未稅金額
      LET l_oha.oha53 = 0                  #原幣銷退應開折讓未稅金額
      LET l_oha.oha54 = 0                  #原幣銷退已開折讓未稅金額
      LET l_oha.oha99 = g_flow99           #
      LET l_oha.ohaconf='Y'                #確認否
      LET l_oha.ohapost='Y'                #庫存入帳否
      LET l_oha.ohaprsw=0                  #列印次數
      LET l_oha.ohauser=g_user             #資料所有者
      LET l_oha.ohagrup=g_grup             #資料所有部門
      LET l_oha.ohamodu=null               #資料修改者
      LET l_oha.ohadate=null               #最近修改日
      IF cl_null(l_oha.oha57) THEN LET l_oha.oha57 = '1' END IF #FUN-AC0055 add
 
         #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"oha_file",  #FUN-980092  #FUN-A50102
         LET l_sql2="INSERT INTO ",cl_get_target_table( l_plant_new, 'oha_file' ),   #FUN-A50102
             "( oha01,oha02,oha03,oha032, ",
             "  oha04,oha05,oha08,oha09,",
             "  oha10,oha14,oha15,oha16,",
             "  oha21,oha211,oha212,oha213,",
             "  oha23,oha24,oha25,oha26,",
             "  oha31,oha41,oha42,oha43,",
             "  oha44,oha45,oha46,oha47,",
             "  oha48,oha50,oha53,oha54,oha99,",
             "oha1001,oha1002,oha1003,oha1004,oha1005,",
             "oha1006,oha1007,oha1008,oha1009,oha1010,",
             "oha1011,oha1012,oha1013,oha1014,oha1015,oha1016,oha1017,oha1018,",
             "  ohaconf,ohapost,ohaprsw,ohauser,",
             "  ohagrup,ohamodu,ohadate, ohaplant,ohalegal, ",
             "  ohaud01,ohaud02,ohaud03,ohaud04,ohaud05,",
             "  ohaud06,ohaud07,ohaud08,ohaud09,ohaud10,",
             "  ohaud11,ohaud12,ohaud13,ohaud14,ohaud15,ohaoriu,ohaorig,oha57)",  #FUN-A10036 #FUN-AC0055 add oha57
             " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                      "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,",
                      "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",      #No.CHI-950020
                      "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,",
                      "?,?,?,?, ?,?,?,?, ?,?,?,?,?)"   #FUN-980010  #FUN-A10036
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql( l_sql2, l_plant_new ) RETURNING l_sql2   #FUN-A50102
         PREPARE ins_oha FROM l_sql2
         EXECUTE ins_oha USING
               l_oha.oha01,l_oha.oha02,l_oha.oha03,l_oha.oha032,
               l_oha.oha04,l_oha.oha05,l_oha.oha08,l_oha.oha09,
               l_oha.oha10,l_oha.oha14,l_oha.oha15,l_oha.oha16,
               l_oha.oha21,l_oha.oha211,l_oha.oha212,l_oha.oha213,
               l_oha.oha23,l_oha.oha24,l_oha.oha25,l_oha.oha26,
               l_oha.oha31,l_oha.oha41,l_oha.oha42,l_oha.oha43,
               l_oha.oha44,l_oha.oha45,l_oha.oha46,l_oha.oha47,
               l_oha.oha48,l_oha.oha50,l_oha.oha53,l_oha.oha54,l_oha.oha99,
               l_oha.oha1001,l_oha.oha1002,l_oha.oha1003,l_oha.oha1004,l_oha.oha1005,
               l_oha.oha1006,l_oha.oha1007,l_oha.oha1008,l_oha.oha1009,l_oha.oha1010,
               l_oha.oha1011,l_oha.oha1012,l_oha.oha1013,l_oha.oha1014,l_oha.oha1015,
               l_oha.oha1016,l_oha.oha1017,l_oha.oha1018,
               l_oha.ohaconf,l_oha.ohapost,l_oha.ohaprsw,l_oha.ohauser,
               l_oha.ohagrup,l_oha.ohamodu,l_oha.ohadate,
               gp_plant,gp_legal   #FUN-980010
              ,l_oha.ohaud01,l_oha.ohaud02,l_oha.ohaud03,
               l_oha.ohaud04,l_oha.ohaud05,l_oha.ohaud06,
               l_oha.ohaud07,l_oha.ohaud08,l_oha.ohaud09,
               l_oha.ohaud10,l_oha.ohaud11,l_oha.ohaud12,
               l_oha.ohaud13,l_oha.ohaud14,l_oha.ohaud15,g_user,g_grup,  #FUN-A10036
               l_oha.oha57    #FUN-AC0055 add oha57
         IF SQLCA.sqlcode<>0 THEN
             CALL s_errmsg('oha01',l_oha.oha01,'ins oha:',SQLCA.sqlcode,1)
             LET g_success = 'N'
         END IF
         IF l_aza.aza50='Y' AND l_oga.oga00='6' THEN
            CALL p865_ogains(' ')
         END IF 
END FUNCTION
 
 
FUNCTION p865_azi(l_oga23)
  DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)
  DEFINE l_oga23  LIKE oga_file.oga23
 
   #讀取l_dbs_new 之原幣資料
   LET l_sql1 =" SELECT * ",
             #  "   FROM ",l_dbs_new CLIPPED,"azi_file ",   #FUN-A50102
               "   FROM ",cl_get_target_table( l_plant_new, 'azi_file' ),   #FUN-A50102
               "  WHERE azi01='",l_oga23,"' "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql( l_sql1, l_plant_new ) RETURNING l_sql1   #FUN-A50102
   PREPARE azi_p2 FROM l_sql1
   IF STATUS THEN CALL cl_err('azi_p2',STATUS,1) END IF
   DECLARE azi_c2 CURSOR FOR azi_p2
   OPEN azi_c2
   FETCH azi_c2 INTO l_azi.*
   CLOSE azi_c2
END FUNCTION
 
 
#銷退單單身檔
FUNCTION p865_ohbins(p_i)
   DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)
   DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)
   DEFINE l_sql2  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)
   DEFINE l_sql3  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)
   DEFINE l_sql4  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)
   DEFINE l_sql5  LIKE type_file.chr1000  #No.FUN-620024  #No.FUN-680137 VARCHAR(1200)
   DEFINE i,l_i    LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE p_i      LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_ima02 LIKE ima_file.ima02
   DEFINE l_ima25 LIKE ima_file.ima25
#DEFINE l_imaqty   LIKE ima_file.ima262 #FUN-A20044
   DEFINE l_imaqty   LIKE type_file.num15_3 #FUN-A20044
   DEFINE l_ima86 LIKE ima_file.ima86
   DEFINE l_ima39 LIKE ima_file.ima39
   DEFINE l_ima35 LIKE ima_file.ima35
   DEFINE l_ima36 LIKE ima_file.ima36
   DEFINE l_oga00 LIKE oga_file.oga00      #No.FUN-620024
#No.CHI-990031 --Begin
   DEFINE l_ima921 LIKE ima_file.ima921
   DEFINE l_ima918 LIKE ima_file.ima918
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_rvbs RECORD LIKE rvbs_file.*
#No.CHI-990031 --End
   DEFINE l_ohbi   RECORD LIKE ohbi_file.*  #FUN-B70074 add
   DEFINE l_idd    RECORD LIKE idd_file.*   #FUN-B90012
   #DEFINE l_imaicd08      LIKE imaicd_file.imaicd08   #FUN-B90012 #FUN-BA0051 mark
   DEFINE l_flag          LIKE type_file.num10        #FUN-B90012
   DEFINE l_ohbiicd028    LIKE ohbi_file.ohbiicd028   #FUN-B90012
   DEFINE l_ohbiicd029    LIKE ohbi_file.ohbiicd029   #FUN-B90012
#  DEFINE l_oia07   LIKE oia_file.oia07   #FUN-C50136
   DEFINE l_ima29   LIKE ima_file.ima29               #CHI-C80042 add
   DEFINE l_oha14         LIKE oha_file.oha14   #FUN-CB0087
   DEFINE l_oha15         LIKE oha_file.oha15   #FUN-CB0087

     #讀取出貨單身檔(ogb_file)
     #LET l_sql1 ="SELECT ",l_dbs_tra CLIPPED,"ogb_file.*, ",       #FUN-980092   #FUN-A50102
     LET l_sql1 ="SELECT ",cl_get_target_table( l_plant_new, 'ogb_file.*' ), ",",  #FUN-A50102
                           #l_dbs_tra CLIPPED,"oga_file.oga00 ",   #FUN-A50102
                           cl_get_target_table( l_plant_new, 'oga_file.oga00' ),   #FUN-A50102     
                 #" FROM ",l_dbs_tra CLIPPED,"oga_file, ",     #FUN-A50102    
                 " FROM ",cl_get_target_table( l_plant_new, 'oga_file' ),",",   #FUN-A50102    
                 #"      ",l_dbs_tra CLIPPED,"ogb_file ",
                 "      ",cl_get_target_table( l_plant_new, 'ogb_file' ),   #FUN-A50102
                 " WHERE oga01=ogb01             " ,
                 "   AND oga99='",g_oga99,"' " ,               #MOD-680022 mod
                 "  AND ogb03 =",g_ohb.ohb32,
                #"   AND (oga09='4' OR oga09='6')"   #No.MOD-620050  #FUN-C40072 mark
                 "   AND (oga09='4' OR oga09='6' OR oga09='8')",     #FUN-C40072 add
                 "   AND oga65 = 'N' "                               #FUN-C40072 add
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
     PREPARE ogb_p1 FROM l_sql1
     IF STATUS THEN
        CALL s_errmsg('ogb03',g_ohb.ohb32,'ogb_p1',STATUS,1) 
        LET g_success='N' RETURN
     END IF
     DECLARE ogb_c1 CURSOR FOR ogb_p1
     OPEN ogb_c1
     FETCH ogb_c1 INTO l_ogb.*,l_oga00   #NO.FUN-620024
     IF SQLCA.SQLCODE <> 0 THEN
        CALL s_errmsg('ogb03',g_ohb.ohb32,'sel ogb',STATUS,1) 
        LET g_success='N' RETURN
     END IF
     CLOSE ogb_c1
     IF l_aza.aza50='Y' THEN    #FUN-710019 流通配銷才要處理
         #LET l_sql5 = "SELECT ",l_dbs_new CLIPPED,"azf_file.azf10 ",     #FUN-A50102
         LET l_sql5 = "SELECT ",cl_get_target_table( l_plant_new, 'azf_file.azf10' ),   #FUN-A50102
                    #  "  FROM ",l_dbs_new CLIPPED,"azf_file ",          #FUN-A50102
                      "  FROM ",cl_get_target_table( l_plant_new, 'azf_file' ),   #FUN-A50102
                      " WHERE azf01='",l_oha.oha1004,"' ",
                      "   AND azf02='2'"     #No.TQC-760054                                                                                 
 	 CALL cl_replace_sqldb(l_sql5) RETURNING l_sql5        #FUN-920032
     CALL cl_parse_qry_sql( l_sql5, l_plant_new ) RETURNING l_sql5   #FUN-A50102
         PREPARE azf_04 FROM l_sql5                                                                                                     
         EXECUTE azf_04 INTO l_azf10                                                                                                    
         IF STATUS THEN                                                                                                                 
             CALL s_errmsg('azf01',l_oha.oha1004,'azf10',STATUS,1)
             LET g_success='N'                                                                                                           
             RETURN                                                                                                                      
         END IF                 
        #新增銷退單身檔[ohb_file]
         LET l_ohb.ohb50 = l_oha.oha1004
         LET l_ohb.ohb1001=l_ogb.ogb1002
         LET l_ohb.ohb1002=' '
         LET l_ohb.ohb1003=l_ogb.ogb1006
         LET l_ohb.ohb1004=l_azf10     #No.FUN-6B0065
     ELSE 
         LET l_ohb.ohb50=g_ohb.ohb50
         LET l_ohb.ohb1001=' '                
         LET l_ohb.ohb1002=' '
         LET l_ohb.ohb1003=100
         LET l_ohb.ohb1004=' '
     END IF
      IF cl_null(l_ohb.ohb50) THEN LET l_ohb.ohb50 = g_poy.poy31   END IF   #TQC-D40064 add
      LET l_ohb.ohb01 = l_oha.oha01        #銷退單號
      LET l_ohb.ohb03 = g_ohb.ohb03        #項次
      LET l_ohb.ohb04 = g_ohb.ohb04        #產品編號
      LET l_ohb.ohb05 = g_ohb.ohb05        #銷售單位
      LET l_ohb.ohb05_fac= g_ohb.ohb05_fac #銷售/庫存單位換算率
      LET l_ohb.ohb06 = g_ohb.ohb06        #品名規格
      LET l_ohb.ohb07 = g_ohb.ohb07        #額外品名編號
      LET l_ohb.ohb08 = g_ohb.ohb08        #銷退入庫工廠編號
      CALL p865_ima(g_ohb.ohb04)
      RETURNING l_ima02,l_ima25,l_imaqty,l_ima86,l_ima39,l_ima35,l_ima36
      IF cl_null(l_ima35) THEN LET l_ima35=' ' END IF
      IF cl_null(l_ima36) THEN LET l_ima36=' ' END IF
      IF NOT cl_null(p_imd01) THEN
         #CALL p865_imd(p_imd01,l_dbs_new)      #FUN-A50102
         CALL p865_imd(p_imd01,l_plant_new)     #FUN-A50102         
         LET l_ohb.ohb09 = p_imd01          #出貨倉庫
         LET l_ohb.ohb091= ' '              #出貨儲位
         LET l_ohb.ohb092= ' '              #出貨批號
      ELSE
         IF NOT cl_null(l_ima35) THEN
            LET l_ohb.ohb09 = l_ima35          #出貨倉庫
            LET l_ohb.ohb091= l_ima36          #出貨儲位
            LET l_ohb.ohb092= ' '              #出貨批號
         ELSE
            LET l_ohb.ohb09 = g_ohb.ohb09
            LET l_ohb.ohb091= g_ohb.ohb091
            LET l_ohb.ohb092= g_ohb.ohb092
         END IF
      END IF
     #IF g_sma.sma96 = 'Y' THEN         #FUN-C80001 #FUN-D30099 mark
      IF g_pod.pod08 = 'Y' THEN         #FUN-D30099
         LET l_ohb.ohb092= g_ohb.ohb092 #FUN-C80001
      END IF                            #FUN-C80001
      LET l_ohb.ohb11 = g_ogb.ogb11        #客戶產品編號
      LET l_ohb.ohb12 = g_ohb.ohb12        #數量
      LET l_ohb.ohb13 = l_ogb.ogb13       #原幣單價
      LET l_ohb.ohb14 = g_ohb.ohb14
      LET l_ohb.ohb14t= g_ohb.ohb14t
      CALL cl_digcut(l_ohb.ohb13,l_azi.azi03) RETURNING l_ohb.ohb13  #MOD-680066 add
      LET l_ohb.ohb910 = g_ohb.ohb910
      LET l_ohb.ohb911 = g_ohb.ohb911
      LET l_ohb.ohb912 = g_ohb.ohb912
      LET l_ohb.ohb913 = g_ohb.ohb913
      LET l_ohb.ohb914 = g_ohb.ohb914
      LET l_ohb.ohb915 = g_ohb.ohb915
      LET l_ohb.ohb916 = g_ohb.ohb916
      LET l_ohb.ohb917 = g_ohb.ohb917
      LET l_ohb.ohb1005 = g_ohb.ohb1005  #No.MOD-680058
      LET l_ohb.ohbud01 = g_ohb.ohbud01
      LET l_ohb.ohbud02 = g_ohb.ohbud02
      LET l_ohb.ohbud03 = g_ohb.ohbud03
      LET l_ohb.ohbud04 = g_ohb.ohbud04
      LET l_ohb.ohbud05 = g_ohb.ohbud05
      LET l_ohb.ohbud06 = g_ohb.ohbud06
      LET l_ohb.ohbud07 = g_ohb.ohbud07
      LET l_ohb.ohbud08 = g_ohb.ohbud08
      LET l_ohb.ohbud09 = g_ohb.ohbud09
      LET l_ohb.ohbud10 = g_ohb.ohbud10
      LET l_ohb.ohbud11 = g_ohb.ohbud11
      LET l_ohb.ohbud12 = g_ohb.ohbud12
      LET l_ohb.ohbud13 = g_ohb.ohbud13
      LET l_ohb.ohbud14 = g_ohb.ohbud14
      LET l_ohb.ohbud15 = g_ohb.ohbud15
      #未稅金額/含稅金額 :
     IF l_oha.oha1004='Y' THEN
      LET l_ohb.ohb14=0
      LET l_ohb.ohb14t=0
     ELSE
      #-----MOD-AB0083---------取消mark 
      #-----MOD-A90183---------
      IF l_oha.oha213 = 'N' THEN
         LET l_ohb.ohb14=l_ohb.ohb917*l_ohb.ohb13  #No.TQC-6A0084
         CALL cl_digcut(l_ohb.ohb14,l_azi.azi04) RETURNING l_ohb.ohb14   #MOD-AB0083
         LET l_ohb.ohb14t=l_ohb.ohb14*(1+l_oha.oha211/100)
         CALL cl_digcut(l_ohb.ohb14t,l_azi.azi04)RETURNING l_ohb.ohb14t   #MOD-AB0083
      ELSE
         LET l_ohb.ohb14t=l_ohb.ohb917*l_ohb.ohb13  #No.TQC-6A0084
         CALL cl_digcut(l_ohb.ohb14t,l_azi.azi04)RETURNING l_ohb.ohb14t   #MOD-AB0083
         LET l_ohb.ohb14=l_ohb.ohb14t/(1+l_oha.oha211/100)
         CALL cl_digcut(l_ohb.ohb14,l_azi.azi04) RETURNING l_ohb.ohb14   #MOD-AB0083
      END IF
      #-----END MOD-A90183-----
      #-----END MOD-AB0083-----取消mark
    END IF
      LET l_ohb.ohb15 = g_ohb.ohb15           #庫存明細單位
      LET l_ohb.ohb15_fac = g_ohb.ohb15_fac   #銷售/庫存明細單位換算率
      LET l_ohb.ohb16 = g_ohb.ohb12           #數量
      LET l_ohb.ohb30 = g_ohb.ohb30           #原出貨發票號
      LET l_ohb.ohb31 = l_ogb.ogb01           #出貨單號
      LET l_ohb.ohb32 = l_ogb.ogb03           #出貨項次
      LET l_ohb.ohb33 = l_ogb.ogb31
      LET l_ohb.ohb34 = l_ogb.ogb32
      LET l_ohb.ohb51 = g_ohb.ohb51           #報單號碼
      LET l_ohb.ohb60 =0                      #已開折讓數量
     #-----MOD-AB0083---------
     #取位動作往前移 
     #CALL cl_digcut(l_ohb.ohb14,l_azi.azi04) RETURNING l_ohb.ohb14
     #CALL cl_digcut(l_ohb.ohb14t,l_azi.azi04)RETURNING l_ohb.ohb14t
     #-----END MOD-AB0083-----
     # 備品時金額、單價應為零
     IF p865_chkoeo(l_ohb.ohb33,l_ohb.ohb34,l_ohb.ohb04) THEN
        LET l_ohb.ohb13 = 0
        LET l_ohb.ohb14 = 0
        LET l_ohb.ohb14t= 0
     END IF
     IF l_aza.aza50='Y' THEN
        LET l_oha.oha1008 =l_oha.oha1008 + l_ohb.ohb14t             
       # LET l_sql4="UPDATE ",l_dbs_tra CLIPPED,"oha_file",    #FUN-980092     #FUN-A50102
        LET l_sql4="UPDATE ",cl_get_target_table( l_plant_new, 'oha_file' ),   #FUN-A50102
                   "   SET oha1008 = ? ",                                            
                   " WHERE oha01 = ? "                                             
 	     CALL cl_replace_sqldb(l_sql4) RETURNING l_sql4        #FUN-920032
         CALL cl_parse_qry_sql(l_sql4,l_plant_new) RETURNING l_sql4 #FUN-980092
        PREPARE upd_oha1008 FROM l_sql4                                              
        EXECUTE upd_oha1008 USING l_oha.oha1008,l_oha.oha01                            
        IF SQLCA.sqlcode<>0 THEN                                                   
           CALL s_errmsg('oha01',l_oha.oha01,'upd oha:',SQLCA.sqlcode,1) 
           LET g_success = 'N'                                                     
        END IF
     END IF
     LET l_ohb.ohb930 = l_ogb.ogb930  #MOD-920265 
     #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"ohb_file",  #FUN-980092   #FUN-A50102
     #FUN-AB0061----------add---------------str----------------
     IF cl_null(l_ohb.ohb37) OR l_ohb.ohb37 = 0 THEN
        LET l_ohb.ohb37 = l_ohb.ohb13
     END IF
     #FUN-AB0061----------add---------------end----------------
     #FUN-AB0096 ---------------add start------------------------
     #IF cl_null(l_ohb.ohb71) THEN   #FUN-AC0055 mark
     #   LET l_ohb.ohb71 = '1'
     #END IF 
     #FUN-AB0096 -----------add end-----------------------------
     #FUN-CB0087--add--str--
     #IF l_aza.aza115 ='Y' AND l_aza.aza50 ='Y' THEN  #TQC-D20067 mark
     IF l_aza.aza115 ='Y' THEN       #TQC-D20067 
        IF cl_null(l_ohb.ohb50) THEN #TQC-D20067 mark #TQC-D40064 remark
           #TQC-D20050--mod--str--
           #SELECT oha14,oha15 INTO l_oha14,l_oha15 FROM oha_file WHERE oha01 = l_ohb.ohb01
           #CALL s_reason_code(l_ohb.ohb01,l_ohb.ohb31,'',l_ohb.ohb04,l_ohb.ohb09,l_oha14,l_oha15) RETURNING l_ohb.ohb50
           LET l_sql2="SELECT oha14,oha15 FROM ",cl_get_target_table( l_plant_new,'oha_file')," WHERE oha01 ='",l_ohb.ohb01,"'"
           PREPARE ohb50_pr FROM l_sql2
           EXECUTE ohb50_pr INTO l_oha14,l_oha15
           CALL s_reason_code1(l_ohb.ohb01,l_ohb.ohb31,'',l_ohb.ohb04,l_ohb.ohb09,l_oha14,l_oha15,l_plant_new) RETURNING l_ohb.ohb50 
           #TQC-D20050--mod--end--
           IF cl_null(l_ohb.ohb50) THEN
              CALL cl_err(l_ohb.ohb50,'aim-425',1)
              LET g_success="N"
              RETURN
           END IF
        END IF
     END IF
     #FUN-CB0087--add--end--
     LET l_sql2="INSERT INTO ",cl_get_target_table( l_plant_new, 'ohb_file' ),   #FUN-A50102
      "(ohb01,ohb03,ohb04,ohb05, ",
      " ohb05_fac,ohb06,ohb07,ohb08, ",
      " ohb09,ohb091,ohb092,ohb11, ",
      " ohb12,ohb37,ohb13,ohb14,ohb14t,",   #FUN-AB0061 add ohb37
      " ohb15,ohb15_fac,ohb16,ohb30, ",
      " ohb31,ohb32,ohb33,ohb34,",
      " ohb50,ohb51,ohb60,ohb910,",
      " ohb911,ohb912,ohb913,ohb914,ohb930,",  #MOD-920265 add ohb930
      " ohb915,ohb916,ohb917,ohb1001,ohb1002,ohb1003,ohb1004,ohb1005, ", #No.MOD-680058
      " ohbplant,ohblegal , ",
      " ohbud01,ohbud02,ohbud03,ohbud04,ohbud05,",
      " ohbud06,ohbud07,ohbud08,ohbud09,ohbud10,",
      #" ohbud11,ohbud12,ohbud13,ohbud14,ohbud15,ohb71)",    #FUN-AB0096 add ohb71
      " ohbud11,ohbud12,ohbud13,ohbud14,ohbud15)",   #FUN-AC0055 remove ohb71
      " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,",     #FUN-AB0061 add ?
      "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",                          #No.CHI-950020
      "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?, ",  #FUN-560043 #No.MOD-680058  #MOD-920265 add ?
      "         ?,?) "  #FUN-980010               #FUN-AB0096 add?
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql( l_sql2, l_plant_new ) RETURNING l_sql2   #FUN-A50102
     PREPARE ins_ohb FROM l_sql2
     EXECUTE ins_ohb USING
       l_ohb.ohb01,l_ohb.ohb03,l_ohb.ohb04,l_ohb.ohb05,
       l_ohb.ohb05_fac,l_ohb.ohb06,l_ohb.ohb07,l_ohb.ohb08,
       l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,l_ohb.ohb11,
       l_ohb.ohb12,l_ohb.ohb37,l_ohb.ohb13,l_ohb.ohb14,l_ohb.ohb14t,   #FUN-AB0061 add ohb37
       l_ohb.ohb15,l_ohb.ohb15_fac,l_ohb.ohb16,l_ohb.ohb30,
       l_ohb.ohb31,l_ohb.ohb32,l_ohb.ohb33,l_ohb.ohb34,
       l_ohb.ohb50,l_ohb.ohb51,l_ohb.ohb60,l_ohb.ohb910,
       l_ohb.ohb911,l_ohb.ohb912,l_ohb.ohb913,l_ohb.ohb914,l_ohb.ohb930, #MOD-920265 add ohb930
       l_ohb.ohb915,l_ohb.ohb916,l_ohb.ohb917,l_ohb.ohb1001,l_ohb.ohb1002,l_ohb.ohb1003,l_ohb.ohb1004,l_ohb.ohb1005, #No.MOD-680058
       gp_plant,gp_legal   #FUN-980010
      ,l_ohb.ohbud01,l_ohb.ohbud02,l_ohb.ohbud03,
       l_ohb.ohbud04,l_ohb.ohbud05,l_ohb.ohbud06,
       l_ohb.ohbud07,l_ohb.ohbud08,l_ohb.ohbud09,
       l_ohb.ohbud10,l_ohb.ohbud11,l_ohb.ohbud12,
       #l_ohb.ohbud13,l_ohb.ohbud14,l_ohb.ohbud15,l_ohb.ohb71   #FUN-AB0096 add ohb71
       l_ohb.ohbud13,l_ohb.ohbud14,l_ohb.ohbud15  #FUN-AB0096 add ohb71 #FUN-AC0055 remove ohb71
     IF SQLCA.sqlcode<>0 THEN
        LET g_showmsg=l_ohb.ohb01,"/",l_ohb.ohb03
        CALL s_errmsg('ohb01,ohb03',g_showmsg,'upd oha:',SQLCA.sqlcode,1) 
        LET g_success = 'N'
#FUN-B70074--add--insert--
     ELSE
        IF NOT s_industry('std') THEN
           INITIALIZE l_ohbi.* TO NULL
           LET l_ohbi.ohbi01 = l_ohb.ohb01
           LET l_ohbi.ohbi03 = l_ohb.ohb03
           IF NOT s_ins_ohbi(l_ohbi.*,l_plant_new ) THEN
              LET g_success = 'N'  
           END IF
        END IF 
#FUN-B70074--add--insert--
#       #FUN-C50136----add----str----
#       IF g_oaz.oaz96 ='Y' THEN
#          CALL s_ccc_oia07('G',l_oha.oha03) RETURNING l_oia07
#          IF l_oia07 = '0' THEN
#             CALL s_ccc_oia(l_oha.oha03,'G',l_oha.oha01,0,l_plant_new)
#          END IF
#       END IF
#       #FUN-C50136----add----end----
     END IF
#No.CHI-990031 --Begin
     #LET l_sql2 = "SELECT ima918,ima921 FROM ",l_dbs_tra CLIPPED,"ima_file",   #FUN-A50102
     LET l_sql2 = "SELECT ima918,ima921 FROM ",cl_get_target_table( l_plant_new, 'ima_file' ),   #FUN-A50102
                  " WHERE ima01 = '",l_ohb.ohb04,"'",
                  "   AND imaacti = 'Y'"
           
     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
     CALL cl_parse_qry_sql( l_sql2, l_plant_new ) RETURNING l_sql2   #FUN-A50102
     PREPARE ima_rvv1 FROM l_sql2
     EXECUTE ima_rvv1 INTO l_ima918,l_ima921

     IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
        LET l_cnt = 0    
        FOREACH p860_g_rvbs INTO l_rvbs.*
           IF STATUS THEN
              CALL cl_err('rvbs',STATUS,1)
           END IF
           LET l_rvbs.rvbs00 = "axmt840"
           LET l_rvbs.rvbs01 = l_ohb.ohb01
           LET l_cnt = l_cnt + 1
           LET l_rvbs.rvbs022 = l_cnt
           LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * l_ohb.ohb05_fac
           IF cl_null(l_rvbs.rvbs06) THEN
              LET l_rvbs.rvbs06 = 0
           END IF
          #LET l_rvbs.rvbs09 = -1    #TQC-B90236
           LET l_rvbs.rvbs09 = 1    #TQC-B90236
           LET l_rvbs.rvbs13 = 0
           #新增批/序號資料
           EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02,
                                  l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                  l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                  l_rvbs.rvbs07,l_rvbs.rvbs08,l_rvbs.rvbs09,
                                  l_rvbs.rvbs13
           IF STATUS OR SQLCA.SQLCODE THEN
              LET g_showmsg = l_rvbs.rvbs01,"/",l_rvbs.rvbs03
              CALL s_errmsg('rvbs01,rvbs03',g_showmsg,'ins rvbs:',SQLCA.sqlcode,1)
              LET g_success='N'
           END IF
           CALL p865_imgs(l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,l_oha.oha02,l_rvbs.*)
        END FOREACH
     END IF
#No.CHI-990031 --End

#FUN-B90012 -----------------------Begin--------------------------
     IF s_industry('icd') THEN
        #FUN-BA0051 --START mark-- 
        #LET l_sql2 = "SELECT imaicd08 FROM ",cl_get_target_table(l_plant_new,'imaicd_file'),",",
        #                                     cl_get_target_table(l_plant_new,'ima_file'),
        #             " WHERE imaicd00 = '",l_ohb.ohb04,"'",
        #             "   AND ima01 = imaicd00 ",
        #             "   AND imaacti = 'Y'"
        #          
        #CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
        #CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
        #PREPARE p865_ohb_imaicd08 FROM l_sql2
        #   
        #EXECUTE p865_ohb_imaicd08 INTO l_imaicd08 
        # 
        #IF l_imaicd08 = 'Y' THEN
        #FUN-BA0051 --END mark--
        IF s_icdbin_multi(l_ohb.ohb04,l_plant_new) THEN   #FUN-BA0051                
           FOREACH p865_g_idd INTO l_idd.*
              LET l_idd.idd10 = l_ohb.ohb01
              LET l_idd.idd11 = l_ohb.ohb03
        #CHI-C80009---add---START
              LET l_idd.idd02 = l_ohb.ohb09
              LET l_idd.idd03 = l_ohb.ohb091
              LET l_idd.idd04 = l_ohb.ohb092
        #CHI-C80009---add-----END
              CALL icd_ida(1,l_idd.*,l_plant_new)
           END FOREACH
        END IF
        LET l_sql1 = "SELECT ohbiicd028,ohbiicd029 FROM ",cl_get_target_table(l_plant_new,'ohbi_file'),
                     " WHERE ohbi01 = '",l_ohb.ohb01,"'",
                     "   AND ohbi03 =  ",l_ohb.ohb03
        CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
        CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1
        PREPARE p865_ohbi FROM l_sql1
        EXECUTE p865_ohbi INTO l_ohbiicd028,l_ohbiicd029
        CALL s_icdpost(11,l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,l_ohb.ohb05,l_ohb.ohb12,l_ohb.ohb01,l_ohb.ohb03,
                       l_oha.oha02,'Y',l_ohb.ohb31,l_ohb.ohb32,l_ohbiicd029,l_ohbiicd028,l_plant_new)
             RETURNING l_flag
        IF l_flag = 0 THEN
           LET g_success = 'N'
        END IF           
     END IF    
#FUN-B90012 -----------------------End----------------------------

     IF l_aza.aza50='Y' AND  l_oga00='6' THEN
        CALL p865_ogbins(' ')
     END IF
     #單頭之銷退金額
     LET l_oha.oha50 =l_oha.oha50 + l_ohb.ohb14   #原幣銷退總未稅金額
     LET l_oha.oha53 =l_oha.oha53 + l_ohb.ohb14   #原幣銷退應開折讓未稅金額
 
    # LET l_sql3="UPDATE ",l_dbs_tra CLIPPED,"oha_file", #FUN-980092  #FUN-A50102
     LET l_sql3="UPDATE ",cl_get_target_table( l_plant_new, 'oha_file' ),   #FUN-A50102
                "   SET oha50 = ? ,",
                "       oha53 = ? ",
                " WHERE oha01 = ? "
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
         CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-980092
     PREPARE upd_oha50 FROM l_sql3
     EXECUTE upd_oha50 USING l_oha.oha50,l_oha.oha53,l_oha.oha01
     IF SQLCA.sqlcode<>0 THEN
        CALL s_errmsg('oha01',l_oha.oha01,'upd oha:',SQLCA.sqlcode,1)
        LET g_success = 'N'
     END IF
     #CHI-C80042 add start -----
     #回寫最近入庫日 ima73
     LET l_sql = "SELECT ima29 FROM ",cl_get_target_table(l_plant_new,'ima_file'),
                  " WHERE ima01='",l_ohb.ohb04,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
     PREPARE ima_p2 FROM l_sql
     IF SQLCA.SQLCODE THEN
       IF g_bgerr THEN
          CALL s_errmsg("ima01",l_ohb.ohb04,"",SQLCA.sqlcode,1)
       ELSE
          CALL cl_err3("","","","",SQLCA.sqlcode,"","",1)
       END IF
     END IF
     DECLARE ima_c2 CURSOR FOR ima_p2
     OPEN ima_c2
     FETCH ima_c2 INTO l_ima29
     #異動日期需大於原來的異動日期才可
     #必須判斷null,否則新料不會update
     IF (l_oha.oha02 > l_ima29 OR l_ima29 IS NULL) THEN
        LET l_sql = "UPDATE ",cl_get_target_table(l_plant_new,'ima_file'),
                    " SET ima73 = ? , ima29 = ? WHERE ima01 = ?  "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
        PREPARE upd_ima2 FROM l_sql
        EXECUTE upd_ima2 USING l_oha.oha02,l_oha.oha02,l_ohb.ohb04
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
           IF g_bgerr THEN
              CALL s_errmsg('ima01',l_ohb.ohb04,'upd ima',STATUS,1)
           ELSE
              CALL cl_err('upd ima:',STATUS,1)
           END IF
           LET g_success='N'
        END IF
     END IF
     #CHI-C80042 add end   -----
 
END FUNCTION
 
#FUNCTION p865_imd(p_imd01,p_dbs)     #FUN-A50102
FUNCTION p865_imd(p_imd01,p_plant)    #FUN-A50102
 DEFINE p_imd01   LIKE imd_file.imd01,
        l_imd11   LIKE imd_file.imd11,
#        p_dbs     LIKE type_file.chr21,   #No.FUN-680137 VARCHAR(21)   #FUN-A50102
        p_plant   LIKE azp_file.azp01,     #FUN-A50102 
        l_sql     LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(400)

  LET g_errno=''
 # LET l_sql="SELECT imd10,imd11,imd12,imd13,imd14,imd15  FROM ",p_dbs CLIPPED,"imd_file",  #MOD-6C0086 modify  #FUN-A50102
   LET l_sql="SELECT imd10,imd11,imd12,imd13,imd14,imd15  FROM ",cl_get_target_table( p_plant, 'imd_file' ),   #FUN-A50102
             " WHERE imd01 = '",p_imd01,"'",
             "   AND imd10 = 'S' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, p_plant ) RETURNING l_sql   #FUN-A50102
  PREPARE imd_pre FROM l_sql
  DECLARE imd_cs CURSOR FOR imd_pre
  OPEN imd_cs
   FETCH imd_cs INTO g_imd10,g_imd11,g_imd12,g_imd13,g_imd14,g_imd15
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4020'
       WHEN g_imd11 ='N'         LET g_errno = 'mfg6080'    #TQC-690057 modify l_imd11->g_imd11
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF NOT cl_null(g_errno) THEN
     #CALL s_errmsg('imd01','p_imd01',p_dbs,g_errno,1)    #FUN-A50102
     CALL s_errmsg('imd01','p_imd01',p_plant,g_errno,1)   #FUN-A50102    
     LET g_success = 'N'
  END IF
  CLOSE imd_cs
END FUNCTION
 
FUNCTION p865_log(p_part,p_ware,p_loca,p_lot,p_qty,p_sta)
  DEFINE p_part      LIKE ima_file.ima01,       #料號
         p_ware      LIKE ogb_file.ogb09,       #倉
         p_loca      LIKE ogb_file.ogb091,      #儲
         p_lot       LIKE ogb_file.ogb092,      #批
         p_qty       LIKE ogb_file.ogb12 ,      #異動數量
         l_img       RECORD LIKE img_file.*,
         l_imgg      RECORD LIKE imgg_file.*,   #FUN-560043
         p_sta       LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(01)  #1.銷退單          3.倉退單
         l_flag      LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
         l_img09     LIKE img_file.img09,       #庫存單位
         l_img10     LIKE img_file.img10,       #庫存數量
         l_imgg10    LIKE imgg_file.imgg10,     #庫存數量   #FUN-560043
         l_img26     LIKE img_file.img26,
         l_ima39     LIKE ima_file.ima39,
         l_ima86     LIKE ima_file.ima86,
         l_ima25     LIKE ima_file.ima25,
         l_ima35     LIKE ima_file.ima35,
         l_ima36     LIKE ima_file.ima36,
        # l_qoh       LIKE ima_file.ima262, #FUN-A20044
         l_qoh       LIKE type_file.num15_3, #FUN-A20044
         t_dbs       LIKE type_file.chr21,   #No.FUN-680137 VARCHAR(21)
         l_ima02     LIKE ima_file.ima02,
         l_sql1      LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(600)
         l_sql2      LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(1600)
         l_msg       LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(50)
         l_chr       LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
         l_n         LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_n3        LIKE type_file.num5,      #FUN-620024  #No.FUN-680137 SMALLINT
         l_sql3      LIKE type_file.chr1000,  #FUN-560043  #No.FUN-680137 VARCHAR(600)
         l_sql4      LIKE type_file.chr1000, #FUN-560043  #No.FUN-680137 VARCHAR(1600)
         l_sql5      LIKE type_file.chr1000, #FUN-560043  #No.FUN-680137 VARCHAR(1600)
         p_unit      LIKE ima_file.ima25, #No.FUN-620024
         p_unit2     LIKE ima_file.ima25, #No.FUN-620024
         l_i,l_j,l_n2 LIKE type_file.num5,     #FUN-560043  #No.FUN-680137 SMALLINT
         l_sw        LIKE type_file.num5     #No.FUN-680137 SMALLINT    #No.TQC-660122
       # l_azp03     LIKE azp_file.azp03,    #No.TQC-660122  #FUN-B90012
       # l_azp01     LIKE azp_file.azp01     #No.FUN-980059  #FUN-B90012
  DEFINE l_ccz28       LIKE ccz_file.ccz28  #MOD-CC0289 add
 
   IF p_part[1,4]='MISC' THEN RETURN END IF  #No.8743
 
   IF p_loca IS NULL THEN LET p_loca=' ' END IF
   IF p_lot  IS NULL THEN LET p_lot =' ' END IF
 
  CALL p865_ima(p_part)
  RETURNING l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,l_ima35,l_ima36
 
  LET l_sql1 = "SELECT COUNT(*) ",
               #" FROM ",l_dbs_tra CLIPPED,"img_file ",  #FUN-980092    #FUN-A50102
               " FROM ",cl_get_target_table( l_plant_new, 'img_file' ),   #FUN-A50102
               " WHERE img01='",p_part,"' ",
               "   AND img02='",p_ware,"'",
               "   AND img03='",p_loca,"'",
               "   AND img04='",p_lot,"'"
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
     PREPARE img_pre1 FROM l_sql1
     IF SQLCA.SQLCODE THEN
        LET g_showmsg=p_part,"/",p_ware,"/",p_loca,"/",p_lot
        CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'img_pre',SQLCA.SQLCODE,1) 
     END IF
     DECLARE img_cs CURSOR FOR img_pre1
     OPEN img_cs
     FETCH img_cs INTO l_n
  IF l_n = 0 THEN
     CALL cl_getmsg('axm-995',g_lang) RETURNING l_msg
     LET l_msg ="(",l_dbs_tra CLIPPED,"-",p_part CLIPPED,'-',p_ware CLIPPED,")",
                     l_msg CLIPPED
     PROMPT l_msg FOR CHAR l_chr
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       ON ACTION about        
          CALL cl_about()     
 
       ON ACTION help         
          CALL cl_show_help() 
 
       ON ACTION controlg     
          CALL cl_cmdask()    
 
     END PROMPT
     IF l_chr MATCHES '[Nn]' THEN LET g_success = 'N' RETURN END IF  #No.8047
     IF l_chr MATCHES '[Yy]' THEN
        LET l_img.img01 = p_part
        LET l_img.img02 = p_ware
        LET l_img.img03 = p_loca
        LET l_img.img04 = p_lot
        LET l_img.img05 = g_ohb.ohb01
        LET l_img.img06 = g_ohb.ohb03
        LET l_img.img09 = l_ima25
        LET l_img.img10 = 0
        LET l_img.img13 = null   #No.7304
        LET l_img.img17 = g_today
        LET l_img.img18 = g_lastdat
        LET l_img.img20 = 1
        LET l_img.img21 = 1
        LET l_img.img22 = g_imd10
        LET l_img.img23 = g_imd11
        LET l_img.img24 = g_imd12
        LET l_img.img25 = g_imd13
        LET l_img.img27 = g_imd14
        LET l_img.img28 = g_imd15
      #  LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"img_file", #FUN-980092    #FUN-A50102
       LET l_sql2="INSERT INTO ",cl_get_target_table( l_plant_new, 'img_file' ),   #FUN-A50102
          "(img01,img02,img03,img04,img05,img06,",
          " img09,img10,img13,img17,img18,",
          " img20,img21,img22,img23,img24,",
          " img25,img27,img28,imgplant,imglegal)",   #TQC-690057 add img27,img28  #FUN-980010
          " VALUES( ?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?, ?,?)"  #TQC-690057  #FUN-980010
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql( l_sql2, l_plant_new ) RETURNING l_sql2   #FUN-A50102
        PREPARE ins_img FROM l_sql2
        EXECUTE ins_img USING l_img.img01,l_img.img02,l_img.img03,l_img.img04,
                              l_img.img05,l_img.img06,
                              l_img.img09,l_img.img10,l_img.img13,l_img.img17,
                              l_img.img18,
                              l_img.img20,l_img.img21,l_img.img22,l_img.img23,
                              l_img.img24,l_img.img25,l_img.img27,l_img.img28, #TQC-690057
                              gp_plant,gp_legal   #FUN-980010
 
           IF SQLCA.sqlcode<>0 THEN
              LET g_msg = l_dbs_tra CLIPPED,'ins img'
              LET g_showmsg=l_img.img01,"/",l_img.img02,"/",l_img.img03,"/",l_img.img04
              CALL s_errmsg('img01,img02,img03,img04',g_showmsg,g_msg,SQLCA.sqlcode,1)
              LET g_success = 'N'
           END IF
       END IF
  END IF
 IF g_ima906 = '2' OR g_ima906 = '3' THEN
  IF g_ima906='2' THEN 
     LET l_n3=1
  END IF
  IF g_ima906='3' THEN
     LET l_n3=2
  END IF
  FOR l_i = l_n3 TO 2
  LET l_sql3 = "SELECT COUNT(*) ",
             #  " FROM ",l_dbs_tra CLIPPED,"imgg_file ",  #FUN-980092   #FUN-A50102
               " FROM ",cl_get_target_table( l_plant_new, 'imgg_file' ),   #FUN-A50102
               " WHERE imgg01='",p_part,"' ",
               "   AND imgg02='",p_ware,"'",
               "   AND imgg03='",p_loca,"'",
               "   AND imgg04='",p_lot,"'"
     IF l_i = 1 THEN
        LET l_sql3 = l_sql3,"   AND imgg09='",g_ohb.ohb910,"'"
     ELSE
        LET l_sql3 = l_sql3,"   AND imgg09='",g_ohb.ohb913,"'"
     END IF
 
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
         CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-980092
     PREPARE imgg_pre1 FROM l_sql3
     IF SQLCA.SQLCODE THEN 
        LET g_showmsg=p_part,"/",p_ware,"/",p_loca,"/",p_lot
        CALL s_errmsg('imgg01,imgg02,imgg03,imgg04',g_showmsg,'imgg_pre',SQLCA.SQLCODE,1)
     END IF
     DECLARE imgg_cs CURSOR FOR imgg_pre1
     OPEN imgg_cs
     FETCH imgg_cs INTO l_n2
 
  IF l_n2 = 0 THEN
     CALL cl_getmsg('axm-995',g_lang) RETURNING l_msg
     LET l_msg ="(",l_dbs_tra CLIPPED,"-",p_part CLIPPED,'-',p_ware CLIPPED,")",
                     l_msg CLIPPED
     PROMPT l_msg FOR CHAR l_chr
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       ON ACTION about        
          CALL cl_about()     
 
       ON ACTION help         
          CALL cl_show_help() 
 
       ON ACTION controlg     
          CALL cl_cmdask()    
 
     END PROMPT
     IF l_chr MATCHES '[Nn]' THEN LET g_success = 'N' RETURN END IF  #No.8047
     IF l_chr MATCHES '[Yy]' THEN
        LET l_imgg.imgg01 = p_part
        LET l_imgg.imgg02 = p_ware
        LET l_imgg.imgg03 = p_loca
        LET l_imgg.imgg04 = p_lot
        LET l_imgg.imgg05 = g_ohb.ohb01
        LET l_imgg.imgg06 = g_ohb.ohb03
        IF l_i = 1 THEN
           LET l_imgg.imgg09 = g_ohb.ohb910
        ELSE
           LET l_imgg.imgg09 = g_ohb.ohb913
        END IF
        LET l_imgg.imgg10 = 0
        LET l_imgg.imgg17 = g_today
        LET l_imgg.imgg18 = g_lastdat
      # LET l_azp03 = s_madd_img_catstr(l_azp.azp03)  #FUN-B90012 
      # LET l_azp01 = s_madd_img_catstr(l_azp.azp01)  #No.FUN-980059  #FUN-B90012
      # CALL s_umfchk1(l_imgg.imgg01,l_imgg.imgg09,l_ima25,l_azp01)   #No.FUN-980059  #FUN-B90012                                                      
        CALL s_umfchk1(l_imgg.imgg01,l_imgg.imgg09,l_ima25,l_plant_new)   #FUN-B90012
             RETURNING l_sw,l_imgg.imgg21                                                                                        
        IF l_sw = 1 THEN                                  
           CALL s_errmsg('','','','mfg3075',0)                                                                                    
           LET l_imgg.imgg21 = 1                                                                                                 
        END IF
        LET l_imgg.imgg22 = 'S'
        LET l_imgg.imgg23 = 'Y'
        LET l_imgg.imgg24 = 'N'
        LET l_imgg.imgg25 = 'N'
      # CALL s_umfchk1(l_imgg.imgg01,l_imgg.imgg09,l_img.img09,l_azp01)  #No.FUN-980059  #FUN-B90012                                                    
        CALL s_umfchk1(l_imgg.imgg01,l_imgg.imgg09,l_img.img09,l_plant_new)   #FUN-B90012
             RETURNING l_sw,l_imgg.imgg211                                                                                       
        IF l_sw = 1 THEN                                                                                                         
           CALL s_errmsg('','','','mfg3075',0)                                                                                    
           LET l_imgg.imgg211 = 1                                                                                                
        END IF
       # LET l_sql4="INSERT INTO ",l_dbs_tra CLIPPED,"imgg_file",  #FUN-980092     #FUN-A50102
        LET l_sql4="INSERT INTO ",cl_get_target_table( l_plant_new, 'imgg_file' ),   #FUN-A50102
          "(imgg01,imgg02,imgg03,imgg04,imgg05,imgg06,",
          " imgg09,imgg10,imgg17,imgg18,",   #MOD-590251
          " imgg21,imgg22,imgg23,imgg24,",    #MOD-590251
          " imgg25,imgg211,imggplant,imggleagal)",    #FUN-980010
          " VALUES(","'",l_imgg.imgg01,"',","'",l_imgg.imgg02,"',","'",l_imgg.imgg03,"',","'",l_imgg.imgg04,"',",
                     "'",l_imgg.imgg05,"',",l_imgg.imgg06,",","'",l_imgg.imgg09,"',",l_imgg.imgg10,",",
                     "'",l_imgg.imgg17,"',","'",l_imgg.imgg18,"',",l_imgg.imgg21,",","'",l_imgg.imgg22,"',",
                     "'",l_imgg.imgg23,"',","'",l_imgg.imgg24,"',","'",l_imgg.imgg25,"',",l_imgg.imgg211,",",
                     "'",  gp_plant,   "',","'",     gp_legal,"',",")"   #FUN-980010
 	 CALL cl_replace_sqldb(l_sql4) RETURNING l_sql4        #FUN-920032
     CALL cl_parse_qry_sql( l_sql4, l_plant_new ) RETURNING l_sql4   #FUN-A50102
        PREPARE ins_imgg FROM l_sql4
        EXECUTE ins_imgg
           IF SQLCA.sqlcode<>0 THEN
              LET g_msg = l_dbs_tra CLIPPED,'ins imgg'
              LET g_showmsg=l_imgg.imgg01,"/",l_imgg.imgg02,"/",l_imgg.imgg03,"/",l_imgg.imgg04 
              CALL s_errmsg('img01,img02,img03,img04',g_showmsg,g_msg,'mfg3075',1)                                                                                    
              LET g_success = 'N'
           END IF
       END IF
  END IF
  END FOR
 END IF  
   LET g_tlf.tlf01=p_part               #異動料件編號
   #----來源----
   IF p_sta = '1' THEN
      LET g_tlf.tlf02 =731           #'Stock'
      LET g_tlf.tlf020=l_azp.azp01
      LET g_tlf.tlf021=' '           #倉庫
      LET g_tlf.tlf022=' '           #儲位
      LET g_tlf.tlf023=' '           #批號
      LET g_tlf.tlf024=0             #異動後數量
      LET g_tlf.tlf025=l_ima25       #庫存單位(ima_file or img_file)
   ELSE
    IF p_sta='2' THEN
      LET g_tlf.tlf02 = 50
      LET g_tlf.tlf020 = l_ogb.ogb08
      LET g_tlf.tlf021 = p_ware
      LET g_tlf.tlf022 = p_loca
      LET g_tlf.tlf023 = p_lot
      LET g_tlf.tlf024 = 0  
      LET g_tlf.tlf025 = l_ima25
    ELSE   
      LET g_tlf.tlf02 =50            #'Stock'
      LET g_tlf.tlf020=l_azp.azp01
      LET g_tlf.tlf021=p_ware        #倉庫
      LET g_tlf.tlf022=p_loca        #儲位
      LET g_tlf.tlf023=p_lot         #批號
      LET g_tlf.tlf024=''            #異動後數量
      LET g_tlf.tlf025=l_ima25       #庫存單位(ima_file or img_file)
    END IF
   END IF
   CASE p_sta
     WHEN '1'  #銷退單
          LET g_tlf.tlf026=l_ohb.ohb01       #異動單號 No.8047
          LET g_tlf.tlf027=l_ohb.ohb03       #異動項次 No.8047
     WHEN '2'
          LET g_tlf.tlf026 = l_oga01           
          LET g_tlf.tlf027 = l_ogb.ogb03       
     WHEN '3'  #倉退單
          LET g_tlf.tlf026=l_rvv.rvv01       #異動單號 No.6178
          LET g_tlf.tlf027=l_rvv.rvv02       #異動項次 No.6178
   END CASE
   #---目的----
   IF p_sta = '1' THEN
      LET g_tlf.tlf03=50
      LET g_tlf.tlf030=l_azp.azp01
      LET g_tlf.tlf031=p_ware
      LET g_tlf.tlf032=p_loca
      LET g_tlf.tlf033=p_lot
      LET g_tlf.tlf034=' '
      LET g_tlf.tlf035=l_ima25
   ELSE
    IF p_sta='2' THEN
      LET g_tlf.tlf03 = 724 
      LET g_tlf.tlf030 = ' '
      LET g_tlf.tlf031 = ' '
      LET g_tlf.tlf032 = ' '
      LET g_tlf.tlf033 = ' '
      LET g_tlf.tlf034 = ' '
      LET g_tlf.tlf035 = ' '
    ELSE
      LET g_tlf.tlf03=31
      LET g_tlf.tlf030=l_azp.azp01
      LET g_tlf.tlf031=' '            #倉庫
      LET g_tlf.tlf032=' '            #儲位
      LET g_tlf.tlf033=' '            #批號
      LET g_tlf.tlf034=' '            #異動後庫存數量
      LET g_tlf.tlf035=l_ima25        #庫存單位(ima_file or img_file)
    END IF 
   END IF
   CASE p_sta
     WHEN '1'  #銷退單
          LET g_tlf.tlf036=l_ohb.ohb01       #異動單號
          LET g_tlf.tlf037=l_ohb.ohb03       #異動項次
     WHEN '2' 
          LET g_tlf.tlf036 = l_oga01
          LET g_tlf.tlf037 = l_ogb.ogb03
     WHEN '3'  #倉退單
          LET g_tlf.tlf036=l_rvv.rvv01       #異動單號
          LET g_tlf.tlf037=l_rvv.rvv02       #異動項次
   END CASE
   #-->異動數量
   LET g_tlf.tlf04= ' '                #工作站
   LET g_tlf.tlf05= ' '                #作業序號
   LET g_tlf.tlf06=g_oha.oha02         #發料日期 no.6178
   LET g_tlf.tlf07=g_today             #異動資料產生日期
   LET g_tlf.tlf08=TIME                #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user              #產生人
   LET g_tlf.tlf10=p_qty               #異動數量
 
   CASE p_sta
     WHEN '1'
           LET g_tlf.tlf11=l_ohb.ohb05         #MOD-4B0148
           LET g_tlf.tlf12=l_ohb.ohb15_fac     #MOD-4B0148  #No.TQC-750014 modify
     WHEN '2' 
           LET g_tlf.tlf11 = l_ogb.ogb05        
           LET g_tlf.tlf12 = l_ogb.ogb15_fac   #No.TQC-750014 modify
     WHEN '3'
           LET g_tlf.tlf11=l_rvv.rvv35         #MOD-4B0148
           LET g_tlf.tlf12=l_rvv.rvv35_fac     #MOD-4B0148
   END CASE
 
   CASE p_sta
        WHEN '1' LET g_tlf.tlf13='aomt800'
        WHEN '2' 
                 LET g_tlf.tlf13 = 'axmt620'
                 LET g_tlf.tlf19 = l_oga.oga03
                 LET g_tlf.tlf60 = l_ogb.ogb05_fac
        WHEN '3' LET g_tlf.tlf13='apmt1072'
   END CASE
   LET g_tlf.tlf14=' '              #異動原因
 
   LET g_tlf.tlf17=' '              #非庫存性料件編號
   LET g_tlf.tlf18=l_qoh
   CASE p_sta
        WHEN '1' LET g_tlf.tlf19=g_oha.oha04  #no.6178
        WHEN '3' LET g_tlf.tlf19=g_pmm.pmm09
   END CASE
   LET g_tlf.tlf20= ' '
 
   CASE p_sta
     WHEN '1'
           LET g_tlf.tlf60=l_ohb.ohb05_fac     #MOD-4B0148
     WHEN '3'
           LET g_tlf.tlf60=l_rvv.rvv35_fac     #MOD-4B0148
   END CASE
 
   LET g_tlf.tlf62=g_ohb.ohb33    #參考單號(訂單)
   LET g_tlf.tlf63=g_ohb.ohb34    #訂單項次
   CASE WHEN  g_tlf.tlf02=50
              LET g_tlf.tlf902=g_tlf.tlf021
              LET g_tlf.tlf903=g_tlf.tlf022
              LET g_tlf.tlf904=g_tlf.tlf023
              LET g_tlf.tlf905=g_tlf.tlf026
              LET g_tlf.tlf906=g_tlf.tlf027
              LET g_tlf.tlf907=-1
        WHEN  g_tlf.tlf03=50
              LET g_tlf.tlf902=g_tlf.tlf031
              LET g_tlf.tlf903=g_tlf.tlf032
              LET g_tlf.tlf904=g_tlf.tlf033
              LET g_tlf.tlf905=g_tlf.tlf036
              LET g_tlf.tlf906=g_tlf.tlf037
              LET g_tlf.tlf907=1
        OTHERWISE
              LET g_tlf.tlf902=' '
              LET g_tlf.tlf903=' '
              LET g_tlf.tlf904=' '
              LET g_tlf.tlf905=' '
              LET g_tlf.tlf906=' '
              LET g_tlf.tlf907=0
   END CASE
   LET g_tlf.tlf99 = g_flow99  #No.8047
   IF g_tlf.tlf902 IS NULL THEN LET g_tlf.tlf902 = ' ' END IF
   IF g_tlf.tlf903 IS NULL THEN LET g_tlf.tlf903 = ' ' END IF
   IF g_tlf.tlf904 IS NULL THEN LET g_tlf.tlf904 = ' ' END IF
   LET g_tlf.tlf61 = s_get_doc_no(g_tlf.tlf905)   #FUN-560043
   CASE p_sta
     WHEN '1'  #銷退單
          LET g_tlf.tlf930 = l_ohb.ohb930  
     WHEN '2' 
          LET g_tlf.tlf930 = l_ogb.ogb930  
     WHEN '3'  #倉退單
          LET g_tlf.tlf930 = l_rvv.rvv930  
   END CASE
 
   IF (g_tlf.tlf02=50 OR g_tlf.tlf03=50) THEN
      IF NOT s_tlfidle(l_plant_new,g_tlf.*) THEN      #FUN-980092  
         CALL cl_err('upd ima902:','9050',1)
         LET g_success='N'
      END IF
   END IF

     #TQC-D20047--add--str--
     LET l_sql2 = "SELECT aza115 FROM ",cl_get_target_table(l_plant_new,'aza_file')," WHERE aza01 = '0' "
     PREPARE aza115_pr FROM l_sql2
     EXECUTE aza115_pr INTO g_aza.aza115   
     #TQC-D20047--add--end--
    #FUN-CB0087--add--str--
    IF g_aza.aza115 ='Y' THEN
       IF cl_null(g_tlf.tlf14) THEN  #TQC-D20067 mark  #TQC-D40064 add
          #CALL s_reason_code(g_tlf.tlf036,g_tlf.tlf026,'',g_tlf.tlf01,g_tlf.tlf031,'','') RETURNING g_tlf.tlf14             #TQC-D20050
          CALL s_reason_code1(g_tlf.tlf036,g_tlf.tlf026,'',g_tlf.tlf01,g_tlf.tlf031,'','',l_plant_new) RETURNING g_tlf.tlf14  #TQC-D20050
          IF cl_null(g_tlf.tlf14) THEN
             CALL cl_err(g_tlf.tlf14,'aim-425',1)
             LET g_success="N"
             RETURN
          END IF
       END IF
    END IF
    #FUN-CB0087--add--end-- 
#MOD-CC0289 add begin---------------------------------------------- 
    #依參考成本參數檔(ccz_file)中ccz28的值更新tlfcost的值  
    #當ccz28='1' OR '2'時,tlfcost=' '
    #當ccz28='3'時       ,tlfcost=批號 tlf904(tlf023/tlf033)
    #當ccz28='4'時       ,tlfcost=專案號 tlf20
    #當ccz28='5'時       ,tlfcost=倉庫
    SELECT ccz28 INTO l_ccz28 FROM ccz_file WHERE ccz00='0'
    CASE 
       WHEN l_ccz28='1' OR l_ccz28='2'
          LET g_tlf.tlfcost=' '
       WHEN l_ccz28='3'   #批號
          IF g_tlf.tlf904 IS NULL THEN LET g_tlf.tlf904=' ' END IF
          LET g_tlf.tlfcost=g_tlf.tlf904
       WHEN l_ccz28='4'   #專案編號
          IF g_tlf.tlf20 IS NULL THEN LET g_tlf.tlf20=' ' END IF
          LET g_tlf.tlfcost=g_tlf.tlf20
       WHEN l_ccz28='5'   #倉庫
          IF g_tlf.tlf901 IS NULL THEN LET g_tlf.tlf901=' ' END IF 
          LET g_tlf.tlfcost=g_tlf.tlf901                         
    END CASE
#MOD-CC0289 add end----------------------------------------------      

   #No.FUN-CC0157(S)
   CASE
      WHEN g_tlf.tlf13 MATCHES 'axmt*'
           CALL s_tlf920('1',g_tlf.tlf905) RETURNING g_tlf.tlf920
      WHEN g_tlf.tlf13 MATCHES 'aomt*' 
           CALL s_tlf920('2',g_tlf.tlf905) RETURNING g_tlf.tlf920
    END CASE
   #No.FUN-CC0157(E)

    #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"tlf_file",  #FUN-980092   #FUN-A50102
    LET l_sql2="INSERT INTO ",cl_get_target_table( l_plant_new, 'tlf_file' ),   #FUN-A50102
      "(tlf01,tlf020,tlf030,tlf02,tlf021,tlf022,",
      " tlf023,tlf024,tlf025,tlf026,tlf027,",
      " tlf03,tlf031,tlf032,tlf033,tlf034,",
      " tlf035,tlf036,tlf037,tlf04,tlf05,",
      " tlf06,tlf07,tlf08,tlf09,tlf10,",
      " tlf11,tlf12,tlf13,tlf14,tlf15,",
      " tlf16,tlf17,tlf18,tlf19,tlf20,",
      " tlf60,tlf61,tlf62,tlf63,tlf99, ",
      " tlf902,tlf903,tlf904,tlf905,tlf906,",
      " tlf907,tlf930,tlfplant,tlflegal,tlfcost,tlf920 )",   #MOD-CC0289 add tlfcost    #FUN-980010 #CHI-9B0008 add tlf930 #FUN-CC0157 add tlf920
      " VALUES( ?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
      "         ?,?,?,?,?,   ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
      "         ?,?,?,?,?,   ?,?,?,?,?,? ) "   #MOD-CC0289 add tlfcost #FUN-980010 #CHI-9B0008 #FUN-CC0157 
    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
    CALL cl_parse_qry_sql( l_sql2, l_plant_new ) RETURNING l_sql2   #FUN-A50102
    PREPARE ins_tlf FROM l_sql2
    EXECUTE ins_tlf USING
       g_tlf.tlf01,g_tlf.tlf020,g_tlf.tlf030,g_tlf.tlf02,g_tlf.tlf021,g_tlf.tlf022,
       g_tlf.tlf023,g_tlf.tlf024,g_tlf.tlf025,g_tlf.tlf026,g_tlf.tlf027,
       g_tlf.tlf03,g_tlf.tlf031,g_tlf.tlf032,g_tlf.tlf033,g_tlf.tlf034,
       g_tlf.tlf035,g_tlf.tlf036,g_tlf.tlf037,g_tlf.tlf04,g_tlf.tlf05,
       g_tlf.tlf06,g_tlf.tlf07,g_tlf.tlf08,g_tlf.tlf09,g_tlf.tlf10,
       g_tlf.tlf11,g_tlf.tlf12,g_tlf.tlf13,g_tlf.tlf14,g_tlf.tlf15,
       g_tlf.tlf16,g_tlf.tlf17,g_tlf.tlf18,g_tlf.tlf19,g_tlf.tlf20,
       g_tlf.tlf60,g_tlf.tlf61,g_tlf.tlf62,g_tlf.tlf63,g_tlf.tlf99, #No.8047
       g_tlf.tlf902,g_tlf.tlf903,g_tlf.tlf904,g_tlf.tlf905,g_tlf.tlf906,
       g_tlf.tlf907,g_tlf.tlf930,gp_plant,gp_legal,g_tlf.tlfcost,g_tlf.tlf920  #FUN-980010 #CHI-9B0008 add tlf930 #FUN-CC0157 add tlf920
    IF SQLCA.sqlcode<>0 THEN   #MOD-CC0289 add tlfcost
       LET g_showmsg=g_tlf.tlf01,"/",g_tlf.tlf06
       CALL s_errmsg('tlf01,tlf06',g_showmsg,'ins tlf:',SQLCA.sqlcode,1)
       LET g_success = 'N'
    END IF
#FUN-BC0062 ------------Begin-----------		
    #計算異動加權平均成本		
    IF NOT s_tlf_mvcost(l_plant_new) THEN		
       LET g_showmsg=g_tlf.tlf01,"/",g_tlf.tlf06
       CALL s_errmsg('tlf01,tlf06',g_showmsg,'ins cfa:',SQLCA.sqlcode,1)
       LET g_success = 'N'
    END IF		
#FUN-BC0062 ------------End-------------		

  IF g_ima906 = '2' OR g_ima906 = '3' THEN
  FOR l_j = 1 TO 2
     IF l_j = 1 AND g_ima906 = '3' THEN
        CONTINUE FOR
     END IF
   LET g_tlff.tlff01=p_part               #異動料件編號
   #----來源----
   IF p_sta = '1' THEN
      LET g_tlff.tlff02 =731           #'Stock'
      LET g_tlff.tlff020=l_azp.azp01
      LET g_tlff.tlff021=' '           #倉庫
      LET g_tlff.tlff022=' '           #儲位
      LET g_tlff.tlff023=' '           #批號
      LET g_tlff.tlff024=0             #異動後數量
      IF l_j = 1 THEN
         LET g_tlff.tlff025 = g_ohb.ohb910
         LET g_tlff.tlff219 = 2                                 #No.FUN-620024
         LET g_tlff.tlff220 = g_ohb.ohb910                      #No.FUN-620024
      ELSE
         LET g_tlff.tlff025 = g_ohb.ohb913
         LET g_tlff.tlff219 = 1                                 #No.FUN-620024
         LET g_tlff.tlff220 = g_ohb.ohb913                      #No.FUN-620024 
      END IF
   ELSE
    IF p_sta='2' THEN
       LET g_tlff.tlff02 = 50             #'Stock'
       LET g_tlff.tlff021 = p_ware        
       LET g_tlff.tlff022 = p_loca       
       LET g_tlff.tlff023 = p_lot        
       LET g_tlff.tlff020 = l_ogb.ogb08   
       LET g_tlff.tlff024 = ' '          
       IF l_j = 1 THEN 
          LET g_tlff.tlff025=l_ogb.ogb910   
          LET g_tlff.tlff219=2
          LET g_tlff.tlff220=l_ogb.ogb910
       ELSE
          LET g_tlff.tlff025=l_ogb.ogb913
          LET g_tlff.tlff219=1
          LET g_tlff.tlff220=l_ogb.ogb913
       END IF
     ELSE  
      LET g_tlff.tlff02 =50            #'Stock'
      LET g_tlff.tlff020=l_azp.azp01
      LET g_tlff.tlff021=p_ware        #倉庫
      LET g_tlff.tlff022=p_loca        #儲位
      LET g_tlff.tlff023=p_lot         #批號
      LET g_tlff.tlff024=''            #異動後數量
      IF l_j = 1 THEN
         LET g_tlff.tlff025 = g_ohb.ohb910
         LET g_tlff.tlff219 = 2
         LET g_tlff.tlff220 = g_ohb.ohb910
      ELSE
         LET g_tlff.tlff025 = g_ohb.ohb913
         LET g_tlff.tlff219 = 1
         LET g_tlff.tlff220 = g_ohb.ohb913
      END IF
     END IF
   END IF
   CASE p_sta
     WHEN '1'  #銷退單
          LET g_tlff.tlff026=l_ohb.ohb01       #異動單號
          LET g_tlff.tlff027=l_ohb.ohb03       #異動項
     WHEN '2'
          LET g_tlff.tlff026 = l_oga01           
          LET g_tlff.tlff027 = l_ogb.ogb03  
     WHEN '3'  #倉退單
          LET g_tlff.tlff026=l_rvv.rvv01       #異動單號
          LET g_tlff.tlff027=l_rvv.rvv02       #異動項次
   END CASE
   #---目的----
   IF p_sta = '1' THEN
      LET g_tlff.tlff03=50
      LET g_tlff.tlff030=l_azp.azp01
      LET g_tlff.tlff031=p_ware
      LET g_tlff.tlff032=p_loca
      LET g_tlff.tlff033=p_lot
      LET g_tlff.tlff034=''
      IF l_j = 1 THEN
         LET g_tlff.tlff035 = g_ohb.ohb910
      ELSE
         LET g_tlff.tlff035 = g_ohb.ohb913
      END IF
   ELSE
    IF p_sta='2' THEN
      LET g_tlff.tlff03 = 724 
      LET g_tlff.tlff030 = ' '
      LET g_tlff.tlff031 = ''
      LET g_tlff.tlff032 = ''
      LET g_tlff.tlff033 = ''
      LET g_tlff.tlff034 = ''
      LET g_tlff.tlff035 = ''
    ELSE
      LET g_tlff.tlff03=31
      LET g_tlff.tlff030=l_azp.azp01
      LET g_tlff.tlff031=' '            #倉庫
      LET g_tlff.tlff032=' '            #儲位
      LET g_tlff.tlff033=' '            #批號
      LET g_tlff.tlff034=' '            #異動後庫存數量
      IF l_j = 1 THEN
         LET g_tlff.tlff035 = g_ohb.ohb910
      ELSE
         LET g_tlff.tlff035 = g_ohb.ohb913
      END IF
    END IF
   END IF
   CASE p_sta
     WHEN '1'  #銷退單
          LET g_tlff.tlff036=l_ohb.ohb01       #異動單號
          LET g_tlff.tlff037=l_ohb.ohb03       #異動項次
     WHEN '2'
          LET g_tlff.tlff036 = l_oga01
          LET g_tlff.tlff037 = l_ogb.ogb03  
     WHEN '3'  #倉退單
          LET g_tlff.tlff036=l_rvv.rvv01       #異動單號
          LET g_tlff.tlff037=l_rvv.rvv02       #異動項次
   END CASE
   #-->異動數量
   LET g_tlff.tlff04= ' '                #工作站
   LET g_tlff.tlff05= ' '                #作業序號
   LET g_tlff.tlff06=g_oha.oha02         #發料日期 no.6178
   LET g_tlff.tlff07=g_today             #異動資料產生日期
   LET g_tlff.tlff08=TIME                #異動資料產生時:分:秒
   LET g_tlff.tlff09=g_user              #產生人
   IF l_j = 1 THEN
     LET g_tlff.tlff10 = g_ohb.ohb912
   ELSE
      LET g_tlff.tlff10 = g_ohb.ohb915
   END IF
   CASE p_sta
     WHEN '1'
          IF l_j = 1 THEN
             LET g_tlff.tlff11=g_ohb.ohb910
             LET g_tlff.tlff12=g_ohb.ohb911
          ELSE
             LET g_tlff.tlff11=g_ohb.ohb913
             LET g_tlff.tlff12=g_ohb.ohb914
          END IF
     WHEN '2'
          IF l_j = 1 THEN
             LET g_tlff.tlff11=l_ogb.ogb910
             LET g_tlff.tlff12=l_ogb.ogb911
          ELSE
             LET g_tlff.tlff11=l_ogb.ogb913
             LET g_tlff.tlff12=l_ogb.ogb914
          END IF
     WHEN '3'
          IF l_j = 1 THEN
             LET g_tlff.tlff11=g_ohb.ohb910
             LET g_tlff.tlff12=g_ohb.ohb911
          ELSE
             LET g_tlff.tlff11=g_ohb.ohb913
             LET g_tlff.tlff12=g_ohb.ohb914
          END IF
   END CASE
 
   CASE p_sta
        WHEN '1' LET g_tlff.tlff13='aomt800'
        WHEN '2' LET g_tlff.tlff13='axmt620'
                 LET g_tlff.tlff19=l_oga.oga04
                 LET g_tlff.tlff60=1
        WHEN '3' LET g_tlff.tlff13='apmt1072'
   END CASE
   LET g_tlff.tlff14=' '              #異動原因
 
   LET g_tlff.tlff17=' '              #非庫存性料件編號
   IF l_j = 1 THEN
      SELECT imgg10 INTO l_imgg10 FROM imgg_file
             WHERE imgg01= p_part AND imgg02 = p_ware AND imgg03 = p_loca AND
                   imgg04 = p_lot AND imgg09 = g_ohb.ohb910
   ELSE
      SELECT imgg10 INTO l_imgg10 FROM imgg_file
             WHERE imgg01= p_part AND imgg02 = p_ware AND imgg03 = p_loca AND
                   imgg04 = p_lot AND imgg09 = g_ohb.ohb913
   END IF
 
   CASE p_sta
        WHEN '1'
          IF l_j = 1 THEN
             LET l_imgg10 = l_imgg10 + g_ohb.ohb912
          ELSE
             LET l_imgg10 = l_imgg10 + g_ohb.ohb915
          END IF
        WHEN '2' 
          IF l_j = 1 THEN 
             LET l_imgg10 = l_imgg10 - l_ogb.ogb912      
          ELSE
             LET l_imgg10 = l_imgg10 - l_ogb.ogb915      
          END IF
        WHEN '3'
          IF l_j = 1 THEN
             LET l_imgg10 = l_imgg10 - g_ohb.ohb912
          ELSE
             LET l_imgg10 = l_imgg10 - g_ohb.ohb915
          END IF
   END CASE
   LET g_tlff.tlff18=l_imgg10
   CASE p_sta
        WHEN '1' LET g_tlff.tlff19=g_oha.oha04
        WHEN '3' LET g_tlff.tlff19=g_pmm.pmm09
   END CASE
   LET g_tlff.tlff20= ' '
   CASE p_sta
     WHEN '1'
          LET g_tlff.tlff60=l_ohb.ohb05_fac
     WHEN '3'
          LET g_tlff.tlff60=l_rvv.rvv35_fac
   END CASE
 
   LET g_tlff.tlff62=g_ohb.ohb33    #參考單號(訂單)
   LET g_tlff.tlff63=g_ohb.ohb34    #訂單項次
   CASE WHEN  g_tlff.tlff02=50
              LET g_tlff.tlff902=g_tlff.tlff021
              LET g_tlff.tlff903=g_tlff.tlff022
              LET g_tlff.tlff904=g_tlff.tlff023
              LET g_tlff.tlff905=g_tlff.tlff026
              LET g_tlff.tlff906=g_tlff.tlff027
              LET g_tlff.tlff907=-1
        WHEN  g_tlff.tlff03=50
              LET g_tlff.tlff902=g_tlff.tlff031
              LET g_tlff.tlff903=g_tlff.tlff032
              LET g_tlff.tlff904=g_tlff.tlff033
              LET g_tlff.tlff905=g_tlff.tlff036
              LET g_tlff.tlff906=g_tlff.tlff037
              LET g_tlff.tlff907=1
        OTHERWISE
              LET g_tlff.tlff902=' '
              LET g_tlff.tlff903=' '
              LET g_tlff.tlff904=' '
              LET g_tlff.tlff905=' '
              LET g_tlff.tlff906=' '
              LET g_tlff.tlff907=0
   END CASE
   LET g_tlff.tlff99 = g_flow99
   IF g_tlff.tlff902 IS NULL THEN LET g_tlff.tlff902 = ' ' END IF
   IF g_tlff.tlff903 IS NULL THEN LET g_tlff.tlff903 = ' ' END IF
   IF g_tlff.tlff904 IS NULL THEN LET g_tlff.tlff904 = ' ' END IF
   IF g_tlff.tlff906 IS NULL THEN LET g_tlff.tlff906 = 0   END IF
   LET g_tlff.tlff61 = s_get_doc_no(g_tlff.tlff905)
   CASE p_sta
     WHEN '1'  #銷退單
          LET g_tlff.tlff930 = l_ohb.ohb930  
     WHEN '2' 
          LET g_tlff.tlff930 = l_ogb.ogb930  
     WHEN '3'  #倉退單
          LET g_tlff.tlff930 = l_rvv.rvv930  
   END CASE
 
   IF g_tlff.tlff10 IS NULL OR g_tlff.tlff10 = 0 OR
      g_tlff.tlff11 IS NULL  THEN 
        CONTINUE FOR
   END IF  
   IF l_j = 1 THEN
      LET p_unit = g_tlff.tlff11
   ELSE
      LET p_unit2 = g_tlff.tlff11
   END IF
    IF cl_null(g_tlff.tlff012) THEN LET g_tlff.tlff012 = ' ' END IF    #FUN-B90012
    IF cl_null(g_tlff.tlff013) THEN LET g_tlff.tlff013 = 0   END IF    #FUN-B90012
    #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"tlff_file",   #FUN-980092   #FUN-A50102
    LET l_sql2="INSERT INTO ",cl_get_target_table( l_plant_new, 'tlff_file' ),   #FUN-A50102
      "(tlff01,tlff020,tlff030,tlff02,tlff021,tlff022,",
      " tlff023,tlff024,tlff025,tlff026,tlff027,",
      " tlff03,tlff031,tlff032,tlff033,tlff034,",
      " tlff035,tlff036,tlff037,tlff04,tlff05,",
      " tlff06,tlff07,tlff08,tlff09,tlff10,",
      " tlff11,tlff12,tlff13,tlff14,tlff15,",
      " tlff16,tlff17,tlff18,tlff19,tlff20,",
      " tlff60,tlff61,tlff62,tlff63,tlff99, ",
      " tlff902,tlff903,tlff904,tlff905,tlff906,",
      " tlff907,tlff219,tlff220,tlff930,tlffplant,",     #No.FUN-620024 #FUN-980010 #CHI-9B0008 add tlff930
      " tlfflegal,tlff012,tlff013 )",                    #FUN-980010    #FUN-B90012 add tlff012,tlff013
      " VALUES( ?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
      "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
      "         ?,?,?,?,?, ?,?,?,?,?, ?,?,? ) "                         #FUN-980010 #CHI-9B0008   #FUN-B90012 add ?,?
    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
    CALL cl_parse_qry_sql( l_sql2, l_plant_new ) RETURNING l_sql2   #FUN-A50102
    PREPARE ins_tlff FROM l_sql2
    EXECUTE ins_tlff USING
     g_tlff.tlff01,g_tlff.tlff020,g_tlff.tlff030,g_tlff.tlff02,g_tlff.tlff021,g_tlff.tlff022,
     g_tlff.tlff023,g_tlff.tlff024,g_tlff.tlff025,g_tlff.tlff026,g_tlff.tlff027,
     g_tlff.tlff03,g_tlff.tlff031,g_tlff.tlff032,g_tlff.tlff033,g_tlff.tlff034,
     g_tlff.tlff035,g_tlff.tlff036,g_tlff.tlff037,g_tlff.tlff04,g_tlff.tlff05,
     g_tlff.tlff06,g_tlff.tlff07,g_tlff.tlff08,g_tlff.tlff09,g_tlff.tlff10,
     g_tlff.tlff11,g_tlff.tlff12,g_tlff.tlff13,g_tlff.tlff14,g_tlff.tlff15,
     g_tlff.tlff16,g_tlff.tlff17,g_tlff.tlff18,g_tlff.tlff19,g_tlff.tlff20,
     g_tlff.tlff60,g_tlff.tlff61,g_tlff.tlff62,g_tlff.tlff63,g_tlff.tlff99, #No.8047
     g_tlff.tlff902,g_tlff.tlff903,g_tlff.tlff904,g_tlff.tlff905,g_tlff.tlff906,  
     g_tlff.tlff907,g_tlff.tlff219,g_tlff.tlff220,g_tlff.tlff930,gp_plant,        #No.FUN-620024 #FUN-980010 #CHI-9B0008 add tlff930
     gp_legal,g_tlff.tlff012,g_tlff.tlff013                                       #FUN-980010    #FUN-B90012 add tlff012,tlff013
     IF SQLCA.sqlcode<>0 THEN
        LET g_showmsg=g_tlff.tlff01,"/",g_tlff.tlff06
        CALL s_errmsg('tlff01,tlff06',g_showmsg,'ins tlff:',SQLCA.sqlcode,1)
        LET g_success = 'N'
     END IF
  END FOR
  CALL s_tlff3(p_unit,p_unit2,l_plant_new)             #FUN-980092 
  END IF                      
END FUNCTION
 
FUNCTION p865_ima(p_part)
 DEFINE p_part  LIKE ima_file.ima01
 DEFINE l_ima02 LIKE ima_file.ima02
 DEFINE l_ima25 LIKE ima_file.ima25
# DEFINE l_qoh   LIKE ima_file.ima262 #FUN-A20044
 DEFINE l_qoh   LIKE type_file.num15_3 #FUN-A20044
 DEFINE l_ima86 LIKE ima_file.ima86
 DEFINE l_ima39 LIKE ima_file.ima39
 DEFINE l_ima35 LIKE ima_file.ima35
 DEFINE l_ima36 LIKE ima_file.ima36
 DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)
 DEFINE l_msg   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(50)
 DEFINE l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk LIKE type_file.num15_3 #FUN-A20044 
     #抓取料件相關資料
   #  LET l_sql1 = "SELECT ima02,ima25,ima261+ima262,ima86,ima39,", #FUN-A20044
     LET l_sql1 = "SELECT ima02,ima25,' ',ima86,ima39,", #FUN-A20044  #MOD-CC0215 add ' '
                  "       ima35,ima36 ",
                 #" FROM ",l_dbs_new CLIPPED,"ima_file ",    #FUN-A50102
                  " FROM ",cl_get_target_table( l_plant_new, 'ima_file' ),   #FUN-A50102
                  " WHERE ima01='",p_part,"' "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql( l_sql1, l_plant_new ) RETURNING l_sql1   #FUN-A50102
     PREPARE ima_pre FROM l_sql1
     IF SQLCA.SQLCODE THEN 
        CALL s_errmsg('','','ima_pre',SQLCA.SQLCODE,0)  
     END IF
     DECLARE ima_cs CURSOR FOR ima_pre
     OPEN ima_cs
     FETCH ima_cs INTO l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,l_ima35,l_ima36
     CALL s_getstock(p_part,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
     LET l_qoh = l_unavl_stk + l_avl_stk #FUN-A20044
     IF SQLCA.SQLCODE <> 0 THEN
        LET l_msg = l_dbs_new,"=>",p_part
        CALL s_errmsg('ima01',p_part,l_msg,'axm-297',1)  
        LET g_success='N'
     END IF
     CLOSE ima_cs
     RETURN l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,l_ima35,l_ima36
END FUNCTION
 
FUNCTION p865_rvuins()
  DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)
  DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)
  DEFINE l_sql2  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1600)
  DEFINE i,l_i    LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_cmd   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(100)
  DEFINE li_result LIKE type_file.num5     #FUN-560043  #No.FUN-680137 SMALLINT
 
  #新增倉退單單頭檔(rvu_file)
    LET l_rvu.rvu00 = '3'                #異動別
    LET l_rvu.rvu01 = g_oha.oha01        #倉退單號
    CALL s_auto_assign_no("apm",rvu_t1,g_oha.oha02,"","","",l_plant_new,"","")  #FUN-980092
     RETURNING li_result,l_rvu.rvu01
    IF (NOT li_result) THEN 
       LET g_msg = l_plant_new CLIPPED,l_rvu.rvu01
       CALL s_errmsg("rvu01",l_rvu.rvu01,g_msg CLIPPED,"mfg3046",1) 
       LET g_success ='N'
       RETURN
    END IF   
 
    LET l_cmd = " SELECT rva01 ",
                #" FROM ",l_dbs_tra CLIPPED," rva_file",   #FUN-980092   #FUN-A50102
                " FROM ",cl_get_target_table( l_plant_new, 'rva_file' ),   #FUN-A50102
                " WHERE rva99='",g_oga.oga99,"'"
 	 CALL cl_replace_sqldb(l_cmd) RETURNING l_cmd        #FUN-920032
         CALL cl_parse_qry_sql(l_cmd,l_plant_new) RETURNING l_cmd #FUN-980092
    PREPARE rva01_pre FROM l_cmd
    DECLARE rva01_c1 CURSOR FOR rva01_pre
    OPEN rva01_c1
    FETCH rva01_c1 INTO l_rvu.rvu02
    CLOSE rva01_c1
 
    LET l_rvu.rvu03 = g_oha.oha02        #異動日期
    LET l_rvu.rvu04 = g_pmm.pmm09        #廠商編號
    #廠商簡稱
    LET l_cmd = " SELECT pmc03 ",
                #" FROM ",l_dbs_new CLIPPED," pmc_file",    #FUN-A50102
                " FROM ",cl_get_target_table( l_plant_new, 'pmc_file' ),   #FUN-A50102
                " WHERE pmc01='",l_rvu.rvu04,"'"
 	 CALL cl_replace_sqldb(l_cmd) RETURNING l_cmd        #FUN-920032
     CALL cl_parse_qry_sql( l_cmd, l_plant_new ) RETURNING l_cmd   #FUN-A50102
    PREPARE pmc_pre FROM l_cmd
    DECLARE pmc_c1 CURSOR FOR pmc_pre
    OPEN pmc_c1
    FETCH pmc_c1 INTO l_rvu.rvu05
    CLOSE pmc_c1
 
    LET l_rvu.rvu06 = g_pmm.pmm13        #採購部門
    LET l_rvu.rvu07 = g_pmm.pmm15        #人員
    LET l_rvu.rvu08 = g_pmm.pmm02        #採購性質
    LET l_rvu.rvu09 = null
    LET l_rvu.rvu11 = null
    LET l_rvu.rvu12 = null       
    LET l_rvu.rvu20 = 'Y'                #
    LET l_rvu.rvu99 = g_flow99           #
    LET l_rvu.rvuconf= 'Y'
    LET l_rvu.rvuacti= 'Y'
    LET l_rvu.rvu17  = '1'         #簽核狀況:1.已核准  #FUN-AB0023 add
    LET l_rvu.rvumksg= 'N'         #是否簽核           #FUN-AB0023 add
    LET l_rvu.rvuuser= g_user
    LET l_rvu.rvugrup= g_grup
    LET l_rvu.rvumodu= null
    LET l_rvu.rvudate= null
    LET l_rvu.rvuud01 = g_oha.ohaud01
    LET l_rvu.rvuud02 = g_oha.ohaud02
    LET l_rvu.rvuud03 = g_oha.ohaud03
    LET l_rvu.rvuud04 = g_oha.ohaud04
    LET l_rvu.rvuud05 = g_oha.ohaud05
    LET l_rvu.rvuud06 = g_oha.ohaud06
    LET l_rvu.rvuud07 = g_oha.ohaud07
    LET l_rvu.rvuud08 = g_oha.ohaud08
    LET l_rvu.rvuud09 = g_oha.ohaud09
    LET l_rvu.rvuud10 = g_oha.ohaud10
    LET l_rvu.rvuud11 = g_oha.ohaud11
    LET l_rvu.rvuud12 = g_oha.ohaud12
    LET l_rvu.rvuud13 = g_oha.ohaud13
    LET l_rvu.rvuud14 = g_oha.ohaud14
    LET l_rvu.rvuud15 = g_oha.ohaud15
    LET l_rvu.rvu27   = '1'            #TQC-B60065
    #新增倉退單頭
     #LET l_sql="INSERT INTO ",l_dbs_tra CLIPPED,"rvu_file",  #FUN-980092   #FUN-A50102
     LET l_sql="INSERT INTO ",cl_get_target_table( l_plant_new, 'rvu_file' ),   #FUN-A50102
      "(rvu00  ,rvu01  ,rvu02  ,rvu03  ,rvu04  ,",
      " rvu05  ,rvu06  ,rvu07  ,rvu08  ,rvu09  ,",
      " rvu10  ,rvu11  ,rvu12  ,rvu13  ,rvu14  ,",
      " rvu15  ,rvu20  ,rvu99  ,rvuconf,rvuacti,rvuuser,rvugrup,",
      " rvu17  ,rvumksg,",                          #FUN-AB0023 add
      " rvu27  ,",                                  #TQC-B60065
      " rvumodu,rvudate,  rvuplant,rvulegal,",
      " rvuud01,rvuud02,rvuud03,rvuud04,rvuud05,",
      " rvuud06,rvuud07,rvuud08,rvuud09,rvuud10,",
      " rvuud11,rvuud12,rvuud13,rvuud14,rvuud15,rvuoriu,rvuorig)",  #FUN-A10036
      " VALUES( ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",
      "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",             #No.CHI-950020 
      "         ?,?, ?,?,?,?,?,  ?,?,   ?,?,?,?,?,?, ?)"    #FUN-980010  #FUN-A10036 #TQC-B60065
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, l_plant_new ) RETURNING l_sql   #FUN-A50102
     PREPARE ins_rvu FROM l_sql
     EXECUTE ins_rvu USING
         l_rvu.rvu00,l_rvu.rvu01,l_rvu.rvu02,l_rvu.rvu03,l_rvu.rvu04,
         l_rvu.rvu05,l_rvu.rvu06,l_rvu.rvu07,l_rvu.rvu08,l_rvu.rvu09,
         l_rvu.rvu10,l_rvu.rvu11,l_rvu.rvu12,l_rvu.rvu13,l_rvu.rvu14,
         l_rvu.rvu15,
         l_rvu.rvu20,
         l_rvu.rvu99,
         l_rvu.rvuconf,l_rvu.rvuacti,l_rvu.rvuuser,l_rvu.rvugrup,
         l_rvu.rvu17,l_rvu.rvumksg,                                      #FUN-AB0023 add
         l_rvu.rvu27,                                                    #TQC-B60065
         l_rvu.rvumodu,l_rvu.rvudate,
         gp_plant,gp_legal   #FUN-980010
        ,l_rvu.rvuud01,l_rvu.rvuud02,l_rvu.rvuud03,l_rvu.rvuud04,l_rvu.rvuud05,
         l_rvu.rvuud06,l_rvu.rvuud07,l_rvu.rvuud08,l_rvu.rvuud09,l_rvu.rvuud10,
         l_rvu.rvuud11,l_rvu.rvuud12,l_rvu.rvuud13,l_rvu.rvuud14,l_rvu.rvuud15,g_user,g_grup #FUN-A10036
     IF SQLCA.sqlcode<>0 THEN
         CALL s_errmsg('rvu01',l_rvu.rvu01,'ins rvu:',SQLCA.sqlcode,1) 
         LET g_success = 'N'
     END IF
END FUNCTION
 
#倉退單單身檔
FUNCTION p865_rvvins(p_i)
  DEFINE l_sql   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)
  DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)
  DEFINE l_sql2  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1600)
  DEFINE p_i     LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_no    LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_price LIKE ogb_file.ogb13
  DEFINE i,l_i   LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_flag  LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_msg   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(80)
  DEFINE l_chr   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
 # DEFINE l_qoh   LIKE ima_file.ima262 #FUN-A20044
  DEFINE l_qoh   LIKE type_file.num15_3 #FUN-A20044
  DEFINE l_ima86 LIKE ima_file.ima86
  DEFINE l_ima39 LIKE ima_file.ima39
  DEFINE l_ima35 LIKE ima_file.ima35
  DEFINE l_ima36 LIKE ima_file.ima36
  DEFINE l_rvvi  RECORD LIKE rvvi_file.* #NO.FUN-7B0018
#No.CHI-990031 --Begin
   DEFINE l_ima921 LIKE ima_file.ima921
   DEFINE l_ima918 LIKE ima_file.ima918
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_rvbs RECORD LIKE rvbs_file.*
#No.CHI-990031 --End
   #DEFINE l_imaicd08    LIKE imaicd_file.imaicd08   #FUN-B90012 #FUN-BA0051 mark
   DEFINE l_idd  RECORD LIKE idd_file.*             #FUN-B90012           
   DEFINE l_flag1       LIKE type_file.num10        #FUN-B90012
   DEFINE l_rvviicd02    LIKE rvvi_file.rvviicd02   #FUN-B90012
   DEFINE l_rvviicd05    LIKE rvvi_file.rvviicd05   #FUN-B90012
   DEFINE l_ima29   LIKE ima_file.ima29             #CHI-C80042 add
   DEFINE l_rvu06        LIKE rvu_file.rvu06        #FUN-CB0087
   DEFINE l_rvu07        LIKE rvu_file.rvu07        #FUN-CB0087
 
     #新增入庫單身檔[rvv_file]
     #LET l_sql = "SELECT * FROM ",l_dbs_tra CLIPPED,"pmn_file ",  #FUN-980092  #FUN-A50102
     LET l_sql = "SELECT * FROM ",cl_get_target_table( l_plant_new, 'pmn_file' ),   #FUN-A50102
                 " WHERE pmn01='",g_pmm.pmm01,"'",
                 "  AND pmn02 =",g_ohb.ohb34     #MOD-7B0263-modiry      
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
     PREPARE sel_pmn FROM l_sql
     EXECUTE sel_pmn INTO g_pmn.*
     LET l_rvv.rvv01 = l_rvu.rvu01     #入庫單號
     LET l_rvv.rvv02 = g_ohb.ohb03     #項次
     LET l_rvv.rvv03 = '3'             #異動類別
     LET l_rvv.rvv04 = l_rvu.rvu02     #驗收單號   #MOD-830251 
     LET l_rvv.rvv05 = g_ohb.ohb32     #項次       #TQC-770010 
     LET l_rvv.rvv06 = g_pmm.pmm09     #廠商編號
     LET l_rvv.rvv09 = g_oha.oha02     #異動日期
     LET l_rvv.rvv17 = g_ohb.ohb12     #數量
     LET l_rvv.rvv23 = 0               #已請款匹配量
     LET l_rvv.rvv88 = 0               #暫估數量   #No.TQC-7B0083
     LET l_rvv.rvv25 = 'N'             #樣品否
     #IF l_aza.aza50='Y' THEN          #TQC-D40064 mark 
     LET l_rvv.rvv26=g_poy.poy30                                            
     #END IF                           #TQC-D40064 mark                          
     LET l_rvv.rvv31 = g_ohb.ohb04     #料件編號
     CALL p865_ima(l_rvv.rvv31)
     RETURNING l_rvv.rvv031,l_rvv.rvv35,l_qoh,l_ima86,l_ima39,l_ima35,l_ima36
     IF NOT cl_null(p_imd01) THEN
        #CALL p865_imd(p_imd01,l_dbs_new)     #FUN-A50102
        CALL p865_imd(p_imd01,l_plant_new)    #FUN-A50102        
        LET l_rvv.rvv32 = p_imd01          #出貨倉庫
        LET l_rvv.rvv33 = ' '              #出貨儲位
        LET l_rvv.rvv34 = ' '              #出貨批號
     ELSE
        IF NOT cl_null(l_ima35) THEN
           LET l_rvv.rvv32 = l_ima35          #出貨倉庫
           LET l_rvv.rvv33 = l_ima36          #出貨儲位
           LET l_rvv.rvv34 = ' '              #出貨批號
        ELSE
           LET l_rvv.rvv32 = g_ohb.ohb09
           LET l_rvv.rvv33 = g_ohb.ohb091
           LET l_rvv.rvv34 = g_ohb.ohb092
        END IF
     END IF
    #IF g_sma.sma96 = 'Y' THEN         #FUN-C80001 #FUN-D30099 mark
     IF g_pod.pod08 = 'Y' THEN         #FUN-D30099 
        LET l_rvv.rvv34 = g_ohb.ohb092 #FUN-C80001
     END IF                            #FUN-C80001
     CALL s_umfchkm(l_rvv.rvv31,g_ohb.ohb05,l_rvv.rvv35,l_plant_new)  #FUN-980092
     RETURNING l_flag,l_rvv.rvv35_fac
     LET l_rvv.rvv35 = g_ohb.ohb05
     LET l_rvv.rvv17 = s_digqty(l_rvv.rvv17,l_rvv.rvv35)    #FUN-BB0084  
 
     LET l_rvv.rvv36 = g_pmm.pmm01
     LET l_rvv.rvv37 = g_ohb.ohb34     #採購序號
 
     LET l_rvv.rvv80 = g_ohb.ohb910
     LET l_rvv.rvv81 = g_ohb.ohb911
     LET l_rvv.rvv82 = g_ohb.ohb912
     LET l_rvv.rvv83 = g_ohb.ohb913
     LET l_rvv.rvv84 = g_ohb.ohb914
     LET l_rvv.rvv85 = g_ohb.ohb915
     LET l_rvv.rvv86 = g_ohb.ohb916
     LET l_rvv.rvv87 = g_ohb.ohb917
     LET l_rvv.rvvud01 = g_ohb.ohbud01
     LET l_rvv.rvvud02 = g_ohb.ohbud02
     LET l_rvv.rvvud03 = g_ohb.ohbud03
     LET l_rvv.rvvud04 = g_ohb.ohbud04
     LET l_rvv.rvvud05 = g_ohb.ohbud05
     LET l_rvv.rvvud06 = g_ohb.ohbud06
     LET l_rvv.rvvud07 = g_ohb.ohbud07
     LET l_rvv.rvvud08 = g_ohb.ohbud08
     LET l_rvv.rvvud09 = g_ohb.ohbud09
     LET l_rvv.rvvud10 = g_ohb.ohbud10
     LET l_rvv.rvvud11 = g_ohb.ohbud11
     LET l_rvv.rvvud12 = g_ohb.ohbud12
     LET l_rvv.rvvud13 = g_ohb.ohbud13
     LET l_rvv.rvvud14 = g_ohb.ohbud14
     LET l_rvv.rvvud15 = g_ohb.ohbud15
     #-----MOD-AB0122---------
     #LET l_rvv.rvv38t=g_pmn.pmn31t
     #LET l_rvv.rvv38 =g_pmn.pmn31
     #流通代銷無收貨單,將發票記錄rvb22同時新增到rvv22內
     LET l_sql1 = "SELECT rvb10,rvb10t,rvb22 FROM ",cl_get_target_table(l_plant_new,'rvb_file'),  #FUN-BB0001 add rvb22 
                  " WHERE rvb01 = '",l_rvv.rvv04,"'",      
                  "   AND rvb02 = ",l_rvv.rvv05
     CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1     
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 
     PREPARE rvb10_pre FROM l_sql1
     DECLARE rvb10_cs CURSOR FOR rvb10_pre
     OPEN rvb10_cs 
     FETCH rvb10_cs INTO l_rvv.rvv38,l_rvv.rvv38t ,l_rvv.rvv22  #FUN-BB0001 add rvv22 
     IF STATUS THEN
        LET g_success='N'
        CALL s_errmsg("","","sel rvb10:",STATUS,1)
     END IF
     CLOSE rvb10_cs
     #-----END MOD-AB0122-----
     CALL cl_digcut(l_rvv.rvv38t,l_azi.azi03) RETURNING l_rvv.rvv38t
     CALL cl_digcut(l_rvv.rvv38,l_azi.azi03) RETURNING l_rvv.rvv38
     LET  l_rvv.rvv39t=g_ohb.ohb14t #MOD-D50139
     LET  l_rvv.rvv39=g_ohb.ohb14   #MOD-D50139      
     #LET l_rvv.rvv39t=l_rvv.rvv38t* l_rvv.rvv87  #No.TQC-6A0084 #MOD-D50139
     CALL cl_digcut(l_rvv.rvv39t,l_azi.azi04) RETURNING l_rvv.rvv39t
     #LET l_rvv.rvv39 =l_rvv.rvv38 * l_rvv.rvv87  #No.TQC-6A0084 #MOD-D50139
     
     CALL cl_digcut(l_rvv.rvv39,l_azi.azi04) RETURNING l_rvv.rvv39   #MOD-920016 modify azi03->azi04
     LET l_rvv.rvv930 = g_pmn.pmn930 #MOD-920265 add
     IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02 = 1 END IF  #no.TQC-790003
     #FUN-CB0087--add--str--
     IF l_aza.aza115 ='Y' THEN
        IF cl_null(l_rvv.rvv26) THEN  #TQC-D20067 mark  #TQC-D40064 remark
           #TQC-D20050--mod--str--
           #SELECT rvu06,rvu07 INTO l_rvu06,l_rvu07 FROM rvu_file WHERE rvu01 = l_rvv.rvv01
           #CALL s_reason_code(l_rvv.rvv01,l_rvv.rvv04,'',l_rvv.rvv31,l_rvv.rvv32,l_rvu07,l_rvu06) RETURNING l_rvv.rvv26
           LET l_sql2="SELECT rvu06,rvu07 FROM ",cl_get_target_table( l_plant_new, 'rvu_file')," WHERE rvu01 ='",l_rvv.rvv01,"'"
           PREPARE rvv26_pr FROM l_sql2
           EXECUTE rvv26_pr INTO l_rvu06,l_rvu07
           CALL s_reason_code1(l_rvv.rvv01,l_rvv.rvv04,'',l_rvv.rvv31,l_rvv.rvv32,l_rvu07,l_rvu06,l_plant_new) RETURNING l_rvv.rvv26
           #TQC-D20050--mod--end--
           IF cl_null(l_rvv.rvv26) THEN
              CALL cl_err(l_rvv.rvv26,'aim-425',1)
              LET g_success="N"
              RETURN
           END IF
        END IF
     END IF
     #FUN-CB0087--add--end--
     #新增倉退單單身檔
    # LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"rvv_file",  #FUN-980092   #FUN-A50102
     LET l_sql2="INSERT INTO ",cl_get_target_table( l_plant_new, 'rvv_file' ),   #FUN-A50102
      "(rvv01,rvv02,rvv03,rvv04,rvv05, ",
      " rvv06,rvv09,rvv17,rvv18,rvv23, ",
      " rvv24,rvv25,rvv26,rvv31,rvv031, ",
      " rvv32,rvv33,rvv34,rvv35,rvv35_fac,",
      " rvv36,rvv37,rvv38,rvv39,rvv40, ",
      " rvv41,rvv42,rvv43,rvv80,rvv81,",
      " rvv82,rvv83,rvv84,rvv85,rvv86,",
      " rvv87,rvv38t,rvv39t,rvv88,rvv930,",  #No.FUN-620024  #No.TQC-7B0083   #MOD-920265 add rvv930 #FUN-940083 add rvv89
      " rvvplant,rvvlegal, ",
      " rvvud01,rvvud02,rvvud03,rvvud04,rvvud05,",
      " rvvud06,rvvud07,rvvud08,rvvud09,rvvud10,",
      " rvvud11,rvvud12,rvvud13,rvvud14,rvvud15,",
      " rvv22 )",  #FUN-BB0001 add
      " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
      "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",              #No.CHI-950020
      "         ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",  #FUN-560043  #No.FUN-620024  #No.TQC-7B0083  #MOD-920265 add ? #FUN-940083
      "         ?,?,? ) "     #FUN-980010  #FUN-BB0001 add ?
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql( l_sql2, l_plant_new ) RETURNING l_sql2   #FUN-A50102
     PREPARE ins_rvv FROM l_sql2
     EXECUTE ins_rvv USING
       l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv03,l_rvv.rvv04,l_rvv.rvv05,
       l_rvv.rvv06,l_rvv.rvv09,l_rvv.rvv17,l_rvv.rvv18,l_rvv.rvv23,
       l_rvv.rvv24,l_rvv.rvv25,l_rvv.rvv26,l_rvv.rvv31,l_rvv.rvv031,
       l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv35,l_rvv.rvv35_fac,
       l_rvv.rvv36,l_rvv.rvv37,l_rvv.rvv38,l_rvv.rvv39,l_rvv.rvv40,
       l_rvv.rvv41,l_rvv.rvv42,l_rvv.rvv43,l_rvv.rvv80,l_rvv.rvv81,
       l_rvv.rvv82,l_rvv.rvv83,l_rvv.rvv84,l_rvv.rvv85,l_rvv.rvv86,
       l_rvv.rvv87,l_rvv.rvv38t,l_rvv.rvv39t,l_rvv.rvv88,l_rvv.rvv930, #No.FUN-620024  #MOD-810231   #MOD-920265 add rvv930
       gp_plant,gp_legal   #FUN-980010
      ,l_rvv.rvvud01,l_rvv.rvvud02,l_rvv.rvvud03,l_rvv.rvvud04,l_rvv.rvvud05,
       l_rvv.rvvud06,l_rvv.rvvud07,l_rvv.rvvud08,l_rvv.rvvud09,l_rvv.rvvud10,
       l_rvv.rvvud11,l_rvv.rvvud12,l_rvv.rvvud13,l_rvv.rvvud14,l_rvv.rvvud15,
       l_rvv.rvv22       #FUN-BB0001 add
     IF SQLCA.sqlcode<>0 THEN
         LET g_showmsg=l_rvv.rvv01,"/",l_rvv.rvv02
         CALL s_errmsg('rvv01,rvv02',g_showmsg,'ins rvv:',SQLCA.sqlcode,1)
         LET g_success = 'N'
     ELSE
        IF NOT s_industry('std') THEN
           INITIALIZE l_rvvi.* TO NULL
           LET l_rvvi.rvvi01 = l_rvv.rvv01
           LET l_rvvi.rvvi02 = l_rvv.rvv02
           IF NOT s_ins_rvvi(l_rvvi.*,l_plant_new) THEN  #FUN-980092
              LET g_success = 'N'
           END IF
        END IF
     END IF
#No.CHI-990031 --Begin
   #LET l_sql2 = "SELECT ima918,ima921 FROM ",l_dbs_tra CLIPPED,"ima_file",   #FUN-A50102
   LET l_sql2 = "SELECT ima918,ima921 FROM ",cl_get_target_table( l_plant_new, 'ima_file' ),   #FUN-A50102
                " WHERE ima01 = '",l_rvv.rvv31,"'",
                "   AND imaacti = 'Y'"
   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
   CALL cl_parse_qry_sql( l_sql2, l_plant_new ) RETURNING l_sql2   #FUN-A50102
   PREPARE ima_rvv2 FROM l_sql2
   EXECUTE ima_rvv2 INTO l_ima918,l_ima921
   IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
      LET l_cnt = 0    
      FOREACH p860_g_rvbs INTO l_rvbs.*
         IF STATUS THEN
            CALL cl_err('rvbs',STATUS,1)
         END IF
         LET l_rvbs.rvbs00 = "apmt742"
         LET l_rvbs.rvbs01 = l_rvv.rvv01
         LET l_cnt = l_cnt + 1  
         LET l_rvbs.rvbs022 = l_cnt  
         LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * l_rvv.rvv35_fac
         IF cl_null(l_rvbs.rvbs06) THEN
            LET l_rvbs.rvbs06 = 0
         END IF
        #LET l_rvbs.rvbs09 = 1    #TQC-B90236
         LET l_rvbs.rvbs09 = -1    #TQC-B90236
         LET l_rvbs.rvbs13 = 0
         #新增批/序號資料
         EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02,
                                l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                l_rvbs.rvbs07,l_rvbs.rvbs08,l_rvbs.rvbs09,
                                l_rvbs.rvbs13
         IF STATUS OR SQLCA.SQLCODE THEN
            LET g_showmsg = l_rvbs.rvbs01,"/",l_rvbs.rvbs03
            CALL s_errmsg('rvbs01,rvbs03',g_showmsg,'ins rvbs:',SQLCA.sqlcode,1)
            LET g_success='N'
         END IF
         CALL p865_imgs(l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvu.rvu03,l_rvbs.*)
      END FOREACH
   END IF
#No.CHI-990031 --End

#FUN-B90012 -------------------Begin---------------------
   IF s_industry('icd') THEN
      #FUN-BA0051 --START mark--
      #LET l_sql2 = "SELECT imaicd08 FROM ",cl_get_target_table(l_plant_new,'imaicd_file'),",",
      #                                     cl_get_target_table(l_plant_new,'ima_file'),
      #             " WHERE imaicd00 = '",l_rvv.rvv31,"'",
      #             "   AND ima01 = imaicd00 ",
      #             "   AND imaacti = 'Y'"
      #          
      #CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
      #CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
      #PREPARE p865_rvv_imaicd08 FROM l_sql2 
      #
      #EXECUTE p865_rvv_imaicd08 INTO l_imaicd08 
      #
      #IF l_imaicd08 = 'Y' THEN
      #FUN-BA0051 --END mark--
      IF s_icdbin_multi(l_rvv.rvv31,l_plant_new) THEN   #FUN-BA0051
         FOREACH p865_g_idd INTO l_idd.*
            LET l_idd.idd10 = l_rvv.rvv01
            LET l_idd.idd11 = l_rvv.rvv02
         #CHI-C80009---add---START
            LET l_idd.idd02 = l_rvv.rvv32
            LET l_idd.idd03 = l_rvv.rvv33
            LET l_idd.idd04 = l_rvv.rvv34
         #CHI-C80009---add-----END
            CALL icd_idb(l_idd.*,l_plant_new)
         END FOREACH
      END IF
      LET l_sql1 = "SELECT rvviicd02,rvviicd05 FROM ",cl_get_target_table(l_plant_new,'rvvi_file'),
                   " WHERE rvvi01 = '",l_rvv.rvv01,"'",
                   "   AND rvvi02 =  ",l_rvv.rvv02
      CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
      CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1
      PREPARE p865_rvvi FROM l_sql1
      EXECUTE p865_rvvi INTO l_rvviicd02,l_rvviicd05
      CALL s_icdpost(12,l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv35,l_rvv.rvv17,l_rvv.rvv01,l_rvv.rvv02,
                     l_rvu.rvu03,'Y',l_rvv.rvv04,l_rvv.rvv05,l_rvviicd05,l_rvviicd02,l_plant_new)
           RETURNING l_flag1
      IF l_flag1 = 0 THEN
         LET g_success = 'N'
      END IF
   END IF
#FUN-B90012 -------------------End-----------------------
   #CHI-C80042 add start -----
   #回寫最近出庫日 ima74
   LET l_sql = "SELECT ima29 FROM ",cl_get_target_table(l_plant_new,'ima_file'),
                " WHERE ima01='",l_rvv.rvv31,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
   PREPARE ima_p1 FROM l_sql
   IF SQLCA.SQLCODE THEN
     IF g_bgerr THEN
        CALL s_errmsg("ima01",l_rvv.rvv31,"",SQLCA.sqlcode,1)
     ELSE
        CALL cl_err3("","","","",SQLCA.sqlcode,"","",1)
     END IF
   END IF
   DECLARE ima_c1 CURSOR FOR ima_p1
   OPEN ima_c1
   FETCH ima_c1 INTO l_ima29
   #異動日期需大於原來的異動日期才可
   #必須判斷null,否則新料不會update
   IF (l_rvu.rvu03 > l_ima29 OR l_ima29 IS NULL)  THEN
      LET l_sql = "UPDATE ",cl_get_target_table(l_plant_new,'ima_file'),
                  " SET ima74 = ? , ima29 = ? WHERE ima01 = ?  "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql
      PREPARE upd_ima1 FROM l_sql
      EXECUTE upd_ima1 USING l_rvu.rvu03,l_rvu.rvu03,l_rvv.rvv31
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
         IF g_bgerr THEN
            CALL s_errmsg('ima01',l_rvv.rvv31,'upd ima',STATUS,1)
         ELSE
            CALL cl_err('upd ima:',STATUS,1)
         END IF
         LET g_success='N'
      END IF
   END IF
   #CHI-C80042 add end  -----

END FUNCTION
 
FUNCTION p865_chkoeo(p_oeo01,p_oeo03,p_oeo04)
 DEFINE p_oeo01 LIKE oeo_file.oeo01
 DEFINE p_oeo03 LIKE oeo_file.oeo03
 DEFINE p_oeo04 LIKE oeo_file.oeo04
 DEFINE l_sql   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)
 
 #LET l_sql=" SELECT COUNT(*) FROM ",l_dbs_tra,"oeo_file ",  #FUN-980092   #FUN-A50102
 LET l_sql=" SELECT COUNT(*) FROM ",cl_get_target_table( l_plant_new, 'oeo_file' ),   #FUN-A50102
           "  WHERE oeo01 = '",p_oeo01,"'",
           "    AND oeo03 = '",p_oeo03,"'",
           "    AND oeo04 = '",p_oeo04,"'",
           "    AND oeo08 = '2' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
 PREPARE chkoeo_pre FROM l_sql
 DECLARE chkoeo_cs CURSOR FOR chkoeo_pre
 OPEN chkoeo_cs FETCH chkoeo_cs INTO g_cnt
 IF g_cnt > 0 THEN RETURN 1 ELSE RETURN 0 END IF
END FUNCTION
 
# 取得多角序號
FUNCTION p865_flow99()
 
     IF cl_null(g_oha.oha99) THEN
        CALL s_flowauno('oha',g_oea.oea904,g_oha.oha02)
             RETURNING g_sw,g_flow99
        IF g_sw THEN
           CALL s_errmsg('','','','tri-011',1)
           LET g_success = 'N' RETURN
        END IF
        UPDATE oha_file SET oha99 = g_flow99 WHERE oha01 = g_oha.oha01
        IF SQLCA.SQLCODE THEN
           CALL s_errmsg('oha01',g_oha.oha01,'upd oha99',SQLCA.SQLCODE,1)
           LET g_success = 'N' RETURN
        END IF
        #馬上檢查是否有搶號
        LET g_cnt = 0
        SELECT COUNT(*) INTO g_cnt FROM oha_file
         WHERE oha99 = g_flow99 AND oha05 IN (tm.oha05,'4')   #NO.FUN-620024
        IF g_cnt > 1 THEN
           CALL s_errmsg('oha99',g_flow99,'','tri-011',1)
           LET g_success = 'N' RETURN
        END IF
     END IF
END FUNCTION
 
#因為各單據的xxx99欄位在資料庫非Unique,
#所以為了安全還是給它檢查一下
FUNCTION p865_chk99()
DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)
 
        # LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_tra CLIPPED,"rvu_file ",  #FUN-980092  #FUN-A50102
         LET l_sql = " SELECT COUNT(*) FROM ", cl_get_target_table( l_plant_new, 'rvu_file' ),   #FUN-A50102
                     "  WHERE rvu99 ='",g_flow99,"'",
                     "    AND rvu00 = '3' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
         PREPARE rvucnt_pre FROM l_sql
         DECLARE rvucnt_cs CURSOR FOR rvucnt_pre
         OPEN rvucnt_cs
         FETCH rvucnt_cs INTO g_cnt                                #倉退單
         IF g_cnt > 0 THEN
            LET g_msg = l_dbs_tra CLIPPED,'-',g_flow99,' rvu99 duplicate'
            CALL s_errmsg('','',g_msg,'tri-011',1)
            LET g_success = 'N'
            RETURN
         END IF
       #  LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_tra CLIPPED,"oha_file ",  #FUN-980092   #FUN-A50102
         LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table( l_plant_new, 'oha_file' ),   #FUN-A50102
                     "  WHERE oha99 ='",g_flow99,"'",
                     "    AND oha05 IN ('4', '",tm.oha05,"')"    
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
         PREPARE ohacnt_pre FROM l_sql
         DECLARE ohacnt_cs CURSOR FOR ohacnt_pre
         OPEN ohacnt_cs
         FETCH ohacnt_cs INTO g_cnt                                #銷退單
         IF g_cnt > 0 THEN
            LET g_msg = l_dbs_tra CLIPPED,'-',g_flow99,' oha99 duplicate'
            CALL s_errmsg('','',g_msg,'tri-011',1)
            LET g_success = 'N'
            RETURN
         END IF
END FUNCTION
FUNCTION p865_ogains(p_i)
      DEFINE l_oayauno LIKE oay_file.oayauno
      DEFINE l_oay16   LIKE oay_file.oay16  
      DEFINE l_oay20   LIKE oay_file.oay20  
      DEFINE l_tqk04   LIKE tqk_file.tqk04  
      DEFINE l_occ02   LIKE occ_file.occ02
      DEFINE l_occ07   LIKE occ_file.occ07
      DEFINE l_occ11   LIKE occ_file.occ11
      DEFINE l_occ08   LIKE occ_file.occ08
      DEFINE l_occ09   LIKE occ_file.occ09
      DEFINE l_occ1023 LIKE occ_file.occ1023
      DEFINE l_occ1022 LIKE occ_file.occ1022
      DEFINE l_occ1005 LIKE occ_file.occ1005
      DEFINE l_occ1006 LIKE occ_file.occ1006
      DEFINE l_oha1015 LIKE oha_file.oha1015
      DEFINE l_oha1018 LIKE oha_file.oha1018
      DEFINE l_t       LIKE type_file.chr5    #No.FUN-680137 VARCHAR(5)
      DEFINE l_sql     STRING                 #No.CHI-950020
      DEFINE l_sql1    LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1000)
      DEFINE p_i       LIKE type_file.num5    #No.FUN-680137 SMALLINT
      DEFINE li_result LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
      INITIALIZE l_oga.* TO NULL 
 
      LET l_t=s_get_doc_no(g_oha.oha01)
      LET l_sql1="SELECT oayauno,oay16,oay19,oay20",                            
                # "  FROM ",l_dbs_new CLIPPED,"oay_file",    #FUN-A50102
                 "  FROM ",cl_get_target_table( l_plant_new, 'oay_file' ),   #FUN-A50102
                 " WHERE oayslip = ?"                                           
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql( l_sql1, l_plant_new ) RETURNING l_sql1   #FUN-A50102
      PREPARE sel_oay FROM l_sql1                                               
      EXECUTE sel_oay USING l_t             
      INTO l_oayauno,l_oay16,l_oay19,l_oay20
      IF SQLCA.sqlcode THEN 
         CALL s_errmsg('oayslip',l_t,'','axm-920',1)
         LET g_success = 'N'
         RETURN
      END IF 
      CALL s_auto_assign_no("axm",l_oay16,g_oha.oha02,"","","",l_plant_new,"","")   #FUN-980092 
           RETURNING li_result,l_oga01    
      IF li_result =0 THEN
         LET g_msg = l_plant_new CLIPPED,l_oga01                      #TQC-9B0013
         CALL s_errmsg("oga01",l_oga01,g_msg CLIPPED,"mfg3046",1)     #TQC-9B0013 
         LET g_success = 'N'
         RETURN
      END IF
      LET l_sql1="SELECT occ07,occ08,occ09,occ1023,occ1005,occ1006,occ1022 ",
                # "  FROM ",l_dbs_new CLIPPED,"occ_file",    #FUN-A50102
                 "  FROM ",cl_get_target_table( l_plant_new, 'occ_file' ),   #FUN-A50102
                 " WHERE occ01= '",l_oha.oha1014,"'"
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql( l_sql1, l_plant_new ) RETURNING l_sql1   #FUN-A50102
      PREPARE sel_occ FROM l_sql1
      EXECUTE sel_occ INTO l_occ07,l_occ08,l_occ09,l_occ1023,l_occ1005,l_occ1006,l_occ1022
      IF cl_null(l_occ07) THEN LET l_occ07=' ' END IF
      IF cl_null(l_occ08) THEN LET l_occ08=' ' END IF
      IF cl_null(l_occ09) THEN LET l_occ09=' ' END IF
      IF cl_null(l_occ1005) THEN LET l_occ1005=' ' END IF
      IF cl_null(l_occ1006) THEN LET l_occ1006=' ' END IF
      IF cl_null(l_occ1023) THEN LET l_occ1023=' ' END IF
      IF cl_null(l_occ1022) THEN LET l_occ1022=' ' END IF
      LET l_sql1="SELECT occ02,occ11 ",
                # "  FROM ",s_dbs_new CLIPPED,"occ_file",    #FUN-A50102
                 "  FROM ",cl_get_target_table( s_poy.poy04, 'occ_file' ),   #FUN-A50102
                 " WHERE occ01='",l_occ07,"'"
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql( l_sql1, s_poy.poy04 ) RETURNING l_sql1   #FUN-A50102
      PREPARE sel_occ1 FROM l_sql1
      EXECUTE sel_occ1 INTO l_occ02,l_occ11
      IF cl_null(l_occ02) THEN LET l_occ02=' ' END IF
      IF cl_null(l_occ11) THEN LET l_occ11=' ' END IF
      LET l_sql1="SELECT tqk04", 
                # "  FROM ",l_dbs_new CLIPPED,"tqk_file",   #FUN-A50102
                 "  FROM ",cl_get_target_table( l_plant_new, 'tqk_file' ),   #FUN-A50102
                 " WHERE tqk01='",l_oha.oha1014,"'",
                 "   AND tqk02='",l_oha.oha1002,"'",
                 "   AND tqk03='",l_occ1023,"'"  
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql( l_sql1, l_plant_new ) RETURNING l_sql1   #FUN-A50102
      PREPARE sel_tqk FROM l_sql1
      EXECUTE sel_tqk INTO l_tqk04
      IF cl_null(l_tqk04) THEN  LET l_tqk04=''  END IF
      LET  l_oga.oga00 = '1'               
      LET  l_oga.oga01 = l_oga01       
      LET  l_oga.oga02 = l_oha.oha02       
      LET l_oga.oga021= g_today
      LET l_oga.oga03 = l_occ07  
      LET l_oga.oga032 = l_occ02   
      LET l_oga.oga033 = l_occ11  
      LET l_oga.oga04 = l_occ09   
      LET l_oga.oga05 = l_occ08
      LET l_oga.oga07 = 'N'               
      LET l_oga.oga08 = '1'                
      LET l_oga.oga09 = '2'               
      LET l_oga.oga14 = l_oha.oha14        
      LET l_oga.oga15 = l_oha.oha15       
      LET l_oga.oga161 = 0                 
      LET l_oga.oga162 = 100               
      LET l_oga.oga163 = 0                 
      LET l_oga.oga18 = l_occ1023 
      LET l_oga.oga20 = 'Y'                
      LET l_oga.oga21 = l_oha.oha21       
      LET l_oga.oga211 = l_oha.oha211      
      LET l_oga.oga212 = l_oha.oha212      
      LET l_oga.oga213 = l_oha.oha213     
      LET l_oga.oga23 = l_oha.oha23       
      LET l_oga.oga24 = l_oha.oha24        
      LET l_oga.oga25 = l_oha.oha25        
      LET l_oga.oga26 = l_oha.oha26        
      LET l_oga.oga30 = 'N'               
      LET l_oga.oga31 = l_oha.oha31        
      LET l_oga.oga32 = l_tqk04            
      LET l_oga.oga50 = 0                  
      LET l_oga.oga501 = 0                 
      LET l_oga.oga51 = 0                  
      LET l_oga.oga511 = 0                 
      LET l_oga.oga52 = 0                 
      LET l_oga.oga53 = 0                 
      LET l_oga.oga54 = 0                  
      LET l_oga.oga57 = '1'    #FUN-AC0055 add
      LET l_oga.ogaconf = 'Y'              
      LET l_oga.ogapost = 'Y'              
      LET l_oga.ogaprsw = 0                
      LET l_oga.ogauser = g_user          
      LET l_oga.ogagrup = g_grup           
      LET l_oga.ogadate = g_today          
      LET l_oga.oga1001= l_oha.oha1014     
      LET l_oga.oga1002 = l_oay20          
      LET l_oga.oga1003 = l_oha.oha1003     
      LET l_oga.oga1004 = ''                
      LET l_oga.oga1005 = l_oha.oha1005     
      LET l_oga.oga1006 = 0                 
      LET l_oga.oga1007 = 0                 
      LET l_oga.oga1008 = 0                  
      LET l_oga.oga1009 = l_occ1005
      LET l_oga.oga1010 = l_occ1006
      LET l_oga.oga1011 = l_occ1022
      LET l_oga.oga1012 = l_oha.oha01                
      LET l_oga.oga1013 = 'N'               
      LET l_oga.oga1014 = 'Y'               
      LET l_oga.oga1015 = '0' 
      LET l_oga.ogaud01 = l_oha.ohaud01
      LET l_oga.ogaud02 = l_oha.ohaud02
      LET l_oga.ogaud03 = l_oha.ohaud03
      LET l_oga.ogaud04 = l_oha.ohaud04
      LET l_oga.ogaud05 = l_oha.ohaud05
      LET l_oga.ogaud06 = l_oha.ohaud06
      LET l_oga.ogaud07 = l_oha.ohaud07
      LET l_oga.ogaud08 = l_oha.ohaud08
      LET l_oga.ogaud09 = l_oha.ohaud09
      LET l_oga.ogaud10 = l_oha.ohaud10
      LET l_oga.ogaud11 = l_oha.ohaud11
      LET l_oga.ogaud12 = l_oha.ohaud12
      LET l_oga.ogaud13 = l_oha.ohaud13
      LET l_oga.ogaud14 = l_oha.ohaud14
      LET l_oga.ogaud15 = l_oha.ohaud15
              
      #LET l_sql="INSERT INTO ",l_dbs_tra CLIPPED,"oga_file ",      #FUN-980092      #FUN-A50102
      LET l_sql="INSERT INTO ",cl_get_target_table( l_plant_new, 'oga_file' ),   #FUN-A50102
                "( oga00,oga01,oga02,oga021,oga03,oga032,oga033,oga04, ",              
                "    oga05,oga07,oga08,oga09,oga14,oga15,oga161,   ",           
                "    oga162,oga163,oga18,oga20,oga21,oga211,oga212,oga213,",    
                "    oga23,oga24,oga25,oga26,oga30,oga31,oga32, ",              
                "    oga50,oga501,oga51,oga511,oga52,oga53,oga54,oga57,ogaconf,",  #FUN-AC0055 add oga57
                "    ogapost,ogaprsw,ogauser,ogagrup,ogadate,oga1001,",         
                "    oga1002,oga1003,oga1004,oga1005,oga1006,oga1007,",         
                "    oga1008,oga1009,oga1010,oga1011,oga1012,oga1013,",         
                "    oga1014,oga1015,ogaplant,ogalegal , ",
                "    ogaud01,ogaud02,ogaud03,ogaud04,ogaud05,",
                "    ogaud06,ogaud07,ogaud08,ogaud09,ogaud10,",
                "    ogaud11,ogaud12,ogaud13,ogaud14,ogaud15,ogaoriu,ogaorig)", #FUN-A10036
                "    VALUES ( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                "             ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",#No.CHI-950020
                "             ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                "             ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?, ?,?,?,? )"   #FUN-980010 #FUN-A10036
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, l_plant_new ) RETURNING l_sql   #FUN-A50102
      PREPARE ins_oga FROM l_sql                                                
      EXECUTE ins_oga USING          
              l_oga.oga00,l_oga.oga01,l_oga.oga02,l_oga.oga021,                              
              l_oga.oga03,l_oga.oga032,l_oga.oga033,l_oga.oga04,                
              l_oga.oga05,l_oga.oga07,l_oga.oga08,                              
              l_oga.oga09,l_oga.oga14,l_oga.oga15,l_oga.oga161,                 
              l_oga.oga162,l_oga.oga163,l_oga.oga18,                            
              l_oga.oga20,l_oga.oga21,l_oga.oga211,l_oga.oga212,                
              l_oga.oga213,l_oga.oga23,l_oga.oga24,l_oga.oga25,                 
              l_oga.oga26,l_oga.oga30,l_oga.oga31,                              
              l_oga.oga32,l_oga.oga50,l_oga.oga501,l_oga.oga51,                 
              l_oga.oga511,l_oga.oga52,l_oga.oga53,l_oga.oga54,l_oga.oga57,  #FUN-AC0055 add l_oga.oga57
              l_oga.ogaconf,l_oga.ogapost,l_oga.ogaprsw,                        
              l_oga.ogauser,l_oga.ogagrup,l_oga.ogadate,                        
              l_oga.oga1001,l_oga.oga1002,l_oga.oga1003,                        
              l_oga.oga1004,l_oga.oga1005,l_oga.oga1006,                        
              l_oga.oga1007,l_oga.oga1008,l_oga.oga1009,                        
              l_oga.oga1010,l_oga.oga1011,l_oga.oga1012,                        
              l_oga.oga1013,l_oga.oga1014,l_oga.oga1015,
              gp_plant,gp_legal   #FUN-980010
             ,l_oga.ogaud01,l_oga.ogaud02,l_oga.ogaud03,
              l_oga.ogaud04,l_oga.ogaud05,l_oga.ogaud06,
              l_oga.ogaud07,l_oga.ogaud08,l_oga.ogaud09,
              l_oga.ogaud10,l_oga.ogaud11,l_oga.ogaud12,
              l_oga.ogaud13,l_oga.ogaud14,l_oga.ogaud15,g_user,g_grup  #FUN-A10036
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('oga01',l_oga.oga01,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF  
      
END FUNCTION
 
FUNCTION p865_ogbins(p_i)
      DEFINE l_occ1027  LIKE occ_file.occ1027
      DEFINE l_ogb1002  LIKE ogb_file.ogb1002
      DEFINE l_ogb03    LIKE ogb_file.ogb03  
      DEFINE l_ogb14    LIKE ogb_file.ogb14  
      DEFINE l_ogb13    LIKE ogb_file.ogb13  
      DEFINE l_ogb13t   LIKE ogb_file.ogb13  
      DEFINE l_ogb14t   LIKE ogb_file.ogb14t 
      DEFINE l_oga50    LIKE oga_file.oga50  
      DEFINE l_oga51    LIKE oga_file.oga51  
      DEFINE l_oga53    LIKE oga_file.oga53  
      DEFINE l_oga501   LIKE oga_file.oga501 
      DEFINE l_oga511   LIKE oga_file.oga511 
      DEFINE p_success  LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1) 
      DEFINE p_i        LIKE type_file.num5    #No.FUN-680137 SMALLINT
      DEFINE l_unit     LIKE gfe_file.gfe01    #No.FUN-680137 VARCHAR(4)
      DEFINE l_sql      LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1000)
      DEFINE l_sql1     LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1000)
      DEFINE l_ogbi     RECORD LIKE ogbi_file.* #No.FUN-7B0018 
#     DEFINE l_oia07   LIKE oia_file.oia07   #FUN-C50136
      DEFINE l_oga14    LIKE oga_file.oga14  #FUN-CB0087
      DEFINE l_oga15    LIKE oga_file.oga15  #FUN-CB0087
 
      INITIALIZE l_ogb.* TO NULL
 
      LET l_sql= "SELECT MAX(ogb03)+1",
                 #"  FROM ",l_dbs_tra CLIPPED,"ogb_file",     #FUN-980092   #FUN-A50102
                 "  FROM ",cl_get_target_table( l_plant_new, 'ogb_file' ),   #FUN-A50102
                 " WHERE ogb01 = '",l_oga01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
      PREPARE sel_ogb03 FROM l_sql
      EXECUTE sel_ogb03 INTO l_ogb03
      IF cl_null(l_ogb03) OR l_ogb03 = 0 THEN
         LET l_ogb03 = 1
      END IF  
      LET l_sql1=" SELECT occ1027 ", 
                # "   FROM ",l_dbs_new CLIPPED,"occ_file ",     #FUN-A50102
                 "   FROM ",cl_get_target_table( l_plant_new, 'occ_file' ),   #FUN-A50102
                 "  WHERE occ01='",g_oha.oha1014,"'",  
                 "    AND occ1014='3'"    
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql( l_sql1, l_plant_new ) RETURNING l_sql1   #FUN-A50102
      PREPARE sel_occ2 FROM l_sql1
      EXECUTE sel_occ2 INTO l_occ1027
      IF l_occ1027 ='Y' THEN
         CALL s_errmsg('occ01',g_oha.oha1014,g_oha.oha1014,'atm-255',1)
         LET g_success='N'   
         RETURN
      END IF
     # LET l_sql1 = "SELECT ",l_dbs_new CLIPPED,"azf_file.azf10 ",    #FUN-A50102
      LET l_sql1 = "SELECT ",cl_get_target_table( l_plant_new, 'azf_file.azf10' ),   #FUN-A50102
                   #"  FROM ",l_dbs_new CLIPPED,"azf_file ",         #FUN-A50102
                   "  FROM ",cl_get_target_table( l_plant_new, 'azf_file' ),   #FUN-A50102
                   " WHERE azf01='",l_oay19,"'",                                                                                     
                   "   AND azf02='2'"     #No.TQC-760054                                                                                 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql( l_sql1, l_plant_new ) RETURNING l_sql1   #FUN-A50102
      PREPARE azf_05 FROM l_sql1                                                                                                    
      EXECUTE azf_05 INTO l_azf10                                                                                                   
      IF STATUS THEN                                                                                                                
         CALL s_errmsg('azf01',l_oay19,'azf10',STATUS,1)
        LET g_success='N'                                                                                                           
        RETURN                                                                                                                      
      END IF                
      
      IF g_sma.sma116 ='2' OR g_sma.sma116='3' THEN
         LET l_unit=g_ohb.ohb916
      ELSE 
         LET l_unit=g_ohb.ohb05
      END IF
      CALL s_fetch_price2(l_oha.oha1014,l_ohb.ohb04,l_unit,l_oha.oha02, '1',
                         l_plant_new ,l_oha.oha23)   #No.FUN-980059
           RETURNING l_ogb1002,l_ogb13,p_success        
      IF p_success ='N' THEN                                             
         CALL s_errmsg('','','fetch price','atm-257',1)
         LET  g_success='N'
         RETURN                                              
      END IF 
         
    IF l_azf10='Y' THEN     #No.FUN-6B0065
     LET l_ogb14=0
     LET l_ogb14t=0
    ELSE
     IF l_oga.oga213='N' THEN
        LET l_ogb14  = l_ogb13*l_ohb.ohb917     #CHI-710059 mod
        LET l_ogb13t = l_ogb13*(1+l_oha.oha211/100)
        LET l_ogb14t = l_ogb13t*l_ohb.ohb917    #CHI-710059 mod
     ELSE
        LET l_ogb13t = l_ogb13*(1+l_oha.oha211/100)
        LET l_ogb14  = l_ogb13 *l_ohb.ohb917    #CHI-710059 mod     
        LET l_ogb14t = l_ogb13t*l_ohb.ohb917    #CHI-710059 mod    
     END IF
    END IF
     LET l_ogb.ogb01 = l_oga.oga01            
     LET l_ogb.ogb03 = l_ogb03                 
     LET l_ogb.ogb04 = l_ohb.ohb04             
     LET l_ogb.ogb05 = l_ohb.ohb05             
     LET l_ogb.ogb05_fac = l_ohb.ohb05_fac     
     LET l_ogb.ogb910    = l_ohb.ohb910        
     LET l_ogb.ogb911    = l_ohb.ohb911       
     LET l_ogb.ogb912    = l_ohb.ohb912        
     LET l_ogb.ogb913    = l_ohb.ohb913        
     LET l_ogb.ogb914    = l_ohb.ohb914       
     LET l_ogb.ogb915    = l_ohb.ohb915       
     LET l_ogb.ogb916    = l_ohb.ohb916        
     LET l_ogb.ogb917    = l_ohb.ohb917        
     LET l_ogb.ogb930    = l_ohb.ohb930  #MOD-920265 add        
     LET l_ogb.ogb06     = l_ohb.ohb06        
     LET l_ogb.ogb07     = l_ohb.ohb07         
     LET l_ogb.ogb08     = l_ohb.ohb08         
     LET l_ogb.ogb09     = l_ohb.ohb09        
     LET l_ogb.ogb091    = l_ohb.ohb091       
     LET l_ogb.ogb092    = l_ohb.ohb092       
     LET l_ogb.ogb11     = l_ohb.ohb11         
     LET l_ogb.ogb12     = l_ohb.ohb12        
     LET l_ogb.ogb13     = l_ogb13             
     LET l_ogb.ogb14     = l_ogb14             
     LET l_ogb.ogb14t    = l_ogb14t            
     LET l_ogb.ogb15     = l_ohb.ohb15         
     LET l_ogb.ogb15_fac = l_ohb.ohb15_fac    
     LET l_ogb.ogb16     = l_ohb.ohb16        
     LET l_ogb.ogb17     = 'N'               
     LET l_ogb.ogb18     = l_ohb.ohb12         
     LET l_ogb.ogb60     = 0                   
     LET l_ogb.ogb63     = 0                  
     LET l_ogb.ogb64     = 0                 
     LET l_ogb.ogb1001   = l_oay19           
     IF cl_null(l_ogb.ogb1001) THEN LET l_ogb.ogb1001 = g_poy.poy28 END IF  #TQC-D40064 add
     LET l_ogb.ogb1002   = l_ogb1002        
     LET l_ogb.ogb1003   = l_oha.oha02        
     LET l_ogb.ogb1004   = ''                  
     LET l_ogb.ogb1005   = '1'                
     LET l_ogb.ogb1006   = l_ohb.ohb1003
     LET l_ogb.ogb1007   = ''                  
     LET l_ogb.ogb1008   = ''                 
     LET l_ogb.ogb1009   = ''                  
     LET l_ogb.ogb1010   = ''                  
     LET l_ogb.ogb1011   = ''                  
     LET l_ogb.ogb1012   = l_azf10     #No.FUN-6B0065
     LET l_ogb.ogbud01   = l_ohb.ohbud01
     LET l_ogb.ogbud02   = l_ohb.ohbud02
     LET l_ogb.ogbud03   = l_ohb.ohbud03
     LET l_ogb.ogbud04   = l_ohb.ohbud04
     LET l_ogb.ogbud05   = l_ohb.ohbud05
     LET l_ogb.ogbud06   = l_ohb.ohbud06
     LET l_ogb.ogbud07   = l_ohb.ohbud07
     LET l_ogb.ogbud08   = l_ohb.ohbud08
     LET l_ogb.ogbud09   = l_ohb.ohbud09
     LET l_ogb.ogbud10   = l_ohb.ohbud10
     LET l_ogb.ogbud11   = l_ohb.ohbud11
     LET l_ogb.ogbud12   = l_ohb.ohbud12
     LET l_ogb.ogbud13   = l_ohb.ohbud13
     LET l_ogb.ogbud14   = l_ohb.ohbud14
     LET l_ogb.ogbud15   = l_ohb.ohbud15
     LET l_ogb.ogb1014   ='N' #保稅放行否 #FUN-6B0044
#FUN-AB0061 -----------add start----------------  
     IF cl_null(l_ogb.ogb37) OR l_ogb.ogb37=0 THEN           
        LET l_ogb.ogb37=l_ogb.ogb13                         
     END IF                                                                             
#FUN-AB0061 -----------add end----------------   
#FUN-AC0055 mark ---------------------begin-----------------------
##FUN-AB0096 -----------add start----------------
#     IF cl_null(l_ogb.ogb50) THEN
#        LET l_ogb.ogb50 = '1'
#     END IF
##FUN-AB0096 ----------add end------------------
#FUN-AC0055 mark ----------------------end------------------------
     #FUN-C50097 ADD BEGIN-----
     IF cl_null(l_ogb.ogb50) THEN 
       LET l_ogb.ogb50 = 0
     END IF 
     IF cl_null(l_ogb.ogb51) THEN 
       LET l_ogb.ogb51 = 0
     END IF 
     IF cl_null(l_ogb.ogb52) THEN 
       LET l_ogb.ogb52 = 0
     END IF
     IF cl_null(l_ogb.ogb53) THEN 
       LET l_ogb.ogb53 = 0
     END IF 
     IF cl_null(l_ogb.ogb54) THEN 
       LET l_ogb.ogb54 = 0
     END IF 
     IF cl_null(l_ogb.ogb55) THEN 
       LET l_ogb.ogb55 = 0
     END IF                                           
     #FUN-C50097 ADD END------- 

     #TQC-D20047--add--str--
     LET l_sql = "SELECT aza115 FROM ",cl_get_target_table(l_plant_new,'aza_file')," WHERE aza01 = '0' "
     PREPARE aza115_pr2 FROM l_sql
     EXECUTE aza115_pr2 INTO g_aza.aza115   
     #TQC-D20047--add--end--
     #FUN-CB0087--add--str--
     #IF g_aza.aza115='Y' THEN                            #TQC-D40064 mark
     IF g_aza.aza115='Y' AND cl_null(l_ogb.ogb1001) THEN  #TQC-D40064 add
        #TQC-D20050--mod--str--
        #SELECT oga14,oga15 INTO l_oga14,l_oga15 FROM oga_file WHERE oga01 = l_ogb.ogb01
        #CALL s_reason_code(l_ogb.ogb01,l_ogb.ogb31,'',l_ogb.ogb04,l_ogb.ogb09,l_oga14,l_oga15) RETURNING l_ogb.ogb1001
        LET l_sql="SELECT oga14,oga15 FROM ",cl_get_target_table(l_plant_new,'oga_file')," WHERE oga01 ='",l_ogb.ogb01,"'"
        PREPARE ohb1001_pr FROM l_sql
        EXECUTE ohb1001_pr INTO l_oga14,l_oga15
        CALL s_reason_code1(l_ogb.ogb01,l_ogb.ogb31,'',l_ogb.ogb04,l_ogb.ogb09,l_oga14,l_oga15,l_plant_new) RETURNING l_ogb.ogb1001 
        #TQC-D20050--mod--end--
        IF cl_null(l_ogb.ogb1001) THEN
           CALL cl_err(l_ogb.ogb1001,'aim-425',1)
           LET g_success="N"
           RETURN
        END IF
     END IF
     #FUN-CB0087--add--end--
     #LET l_sql="INSERT INTO ",l_dbs_tra CLIPPED," ogb_file ",     #FUN-980092  #FUN-A50102
     LET l_sql="INSERT INTO ",cl_get_target_table( l_plant_new, 'ogb_file' ),   #FUN-A50102
               "( ogb01,ogb03,ogb04,ogb05,ogb05_fac,ogb910,ogb911,ogb912,ogb913,",
               "  ogb914,ogb915,ogb916,ogb917,ogb06,ogb07,ogb08,ogb09,ogb091, ",
               "  ogb092,ogb11,ogb12,ogb37,ogb13,ogb14,ogb14t,ogb15,ogb15_fac,ogb16, ",#FUN-AB0061
               "  ogb17,ogb18,ogb60,ogb63,ogb64,ogb1001,ogb1002,ogb1003,ogb1004,",
               "  ogb1005,ogb1006,ogb1007,ogb1008,ogb1009,ogb1010,ogb1011,ogb1012,ogb1014,ogb930 ,",  #FUN-6B0044  #MOD-920265 add ogb930
               "  ogbplant,,ogblegal , ",
               "  ogbud01,ogbud02,ogbud03,ogbud04,ogbud05,",
               "  ogbud06,ogbud07,ogbud08,ogbud09,ogbud10,",
               "  ogbud11,ogbud12,ogbud13,ogbud14,ogbud15,ogb50,ogb51,ogb52,ogb53,ogb54,ogb55)",      #FUN-C50097 ADD 50,51,52 ,ogb50,ogb51,ogb52 
               "  VALUES ( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "           ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",   #No.CHI-950020
                         " ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?, ",  #MOD-920265 add ?  
                         " ?,?,? ,?,?,?  ,?,?,?) "    #FUN-980010#FUN-AB0061     #FUN-C50097 ADD 50,51,52 ,?,?,?  #TQC-C80177 add ?,?,?  
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, l_plant_new ) RETURNING l_sql   #FUN-A50102
     PREPARE ins_ogb FROM l_sql                                                 
     EXECUTE ins_ogb USING 
             l_ogb.ogb01,l_ogb.ogb03,l_ogb.ogb04,l_ogb.ogb05,                   
             l_ogb.ogb05_fac,l_ogb.ogb910,l_ogb.ogb911,l_ogb.ogb912,l_ogb.ogb913,
             l_ogb.ogb914,l_ogb.ogb915,l_ogb.ogb916,l_ogb.ogb917,               
             l_ogb.ogb06,l_ogb.ogb07,l_ogb.ogb08,l_ogb.ogb09,l_ogb.ogb091,      
             l_ogb.ogb092,l_ogb.ogb11,l_ogb.ogb12,l_ogb.ogb37,l_ogb.ogb13,l_ogb.ogb14,#FUN-AB0061       
             l_ogb.ogb14t,l_ogb.ogb15,l_ogb.ogb15_fac,l_ogb.ogb16,              
             l_ogb.ogb17,l_ogb.ogb18,l_ogb.ogb60,l_ogb.ogb63,l_ogb.ogb64,       
             l_ogb.ogb1001,l_ogb.ogb1002,l_ogb.ogb1003,l_ogb.ogb1004,           
             l_ogb.ogb1005,l_ogb.ogb1006,l_ogb.ogb1007,l_ogb.ogb1008,l_ogb.ogb1009,           
             l_ogb.ogb1010,l_ogb.ogb1011,l_ogb.ogb1012,l_ogb.ogb1014   #FUN-6B0044         
            ,l_ogb.ogb930, #MOD-920265
             gp_plant,gp_legal   #FUN-980010
            ,l_ogb.ogbud01,l_ogb.ogbud02,l_ogb.ogbud03,
             l_ogb.ogbud04,l_ogb.ogbud05,l_ogb.ogbud06,
             l_ogb.ogbud07,l_ogb.ogbud08,l_ogb.ogbud09,
             l_ogb.ogbud10,l_ogb.ogbud11,l_ogb.ogbud12,
             l_ogb.ogbud13,l_ogb.ogbud14,l_ogb.ogbud15,
             l_ogb.ogb50,l_ogb.ogb51,l_ogb.ogb52,l_ogb.ogb53,l_ogb.ogb54,l_ogb.ogb55  #FUN-C50097 ADD 50,51,52 
     IF SQLCA.sqlcode THEN
        LET g_showmsg=l_ogb.ogb01,"/",l_ogb.ogb03  
        CALL s_errmsg('ogb01,ogb03',g_showmsg,'',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
     ELSE
        IF NOT s_industry('std') THEN
           INITIALIZE l_ogbi.* TO NULL
           LET l_ogbi.ogbi01 = l_ogb.ogb01
           LET l_ogbi.ogbi03 = l_ogb.ogb03
           IF NOT s_ins_ogbi(l_ogbi.*,l_plant_new) THEN   #FUN-980092
              LET g_success = 'N'
              RETURN
           END IF
        END IF
#       #FUN-C50136----add----str----
#       IF g_oaz.oaz96 ='Y' THEN
#          CALL s_ccc_oia07('D',l_oga.oga03) RETURNING l_oia07
#          IF l_oia07 = '0' THEN
#             CALL s_ccc_oia(l_oga.oga03,'D',l_oga.oga01,0,l_plant_new)
#          END IF
#       END IF
#       #FUN-C50136----add----end----
     END IF
 
     LET l_oga50=l_oga.oga50+l_ohb.ohb14
     LET l_oga51=l_oga.oga51+l_ohb.ohb14t
     LET l_oga53=l_oga.oga53+l_ohb.ohb14
     LET l_oga501=l_oga.oga501+l_ohb.ohb14*l_oha.oha24
     LET l_oga511=l_oga.oga511+l_ohb.ohb14t*l_oha.oha24
     LET l_oga.oga1008 =l_oga.oga1008 + l_ogb.ogb14t   
     UPDATE oga_file SET oga50=l_oga50,oga51=l_oga51,
                         oga53=l_oga53,oga501=l_oga501,
                         oga511=l_oga511,oga1008=l_oga.oga1008
      WHERE oga01=l_oga.oga01
     IF SQLCA.SQLCODE THEN
        CALL s_errmsg('oga01',l_oga.oga01,'upd oga_file:',SQLCA.sqlcode,1)      #No.FUN-710046
        LET g_success='N'
        RETURN
     END IF 
 
END FUNCTION
#No:FUN-9C0071--------精簡程式----- 

#No.CHI-990031 --Begin
FUNCTION p865_imgs(p_ware,p_loca,p_lot,p_date,p_rvbs)
   DEFINE p_rvbs   RECORD LIKE rvbs_file.*
   DEFINE p_ware   LIKE imgs_file.imgs02
   DEFINE p_loca   LIKE imgs_file.imgs03            
   DEFINE p_lot    LIKE imgs_file.imgs04            
   DEFINE p_date   LIKE tlfs_file.tlfs111 
   DEFINE l_imgs   RECORD LIKE imgs_file.*
   DEFINE l_tlfs   RECORD LIKE tlfs_file.*
   DEFINE l_ima25  LIKE ima_file.ima25
   DEFINE l_sql1   LIKE type_file.chr1000 
   DEFINE l_sql2   LIKE type_file.chr1000 
   DEFINE l_n      LIKE type_file.num5

   LET l_sql1 = "SELECT COUNT(*) ",
               # "  FROM ",l_dbs_tra CLIPPED,"imgs_file ",   #FUN-A50102
                "  FROM ",cl_get_target_table( l_plant_new, 'imgs_file' ),   #FUN-A50102
                " WHERE imgs01='",p_rvbs.rvbs021,"' ", 
                "   AND imgs02='",p_ware,"'",
                "   AND imgs03='",p_loca,"'",
                "   AND imgs04='",p_lot,"'",
                "   AND imgs05='",p_rvbs.rvbs03,"'",
                "   AND imgs06='",p_rvbs.rvbs04,"'",
                "   AND imgs11='",p_rvbs.rvbs08,"'"

        CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
        CALL cl_parse_qry_sql( l_sql1, l_plant_new ) RETURNING l_sql1   #FUN-A50102
   PREPARE imgs_pre1 FROM l_sql1
   IF SQLCA.SQLCODE THEN
      IF g_bgerr THEN
         LET  g_showmsg=p_rvbs.rvbs021,"/",p_ware,"/",p_loca,"/",p_lot,"/",p_rvbs.rvbs03,"/",p_rvbs.rvbs04
         CALL s_errmsg('imgs01,imgs02,imgs03,imgs04,imgs05,imgs06',g_showmsg,'imgs_pre',SQLCA.SQLCODE,1)
      ELSE
        CALL cl_err('imgs_pre',SQLCA.SQLCODE,1)
      END IF
   END IF

   DECLARE imgs_cs CURSOR FOR imgs_pre1

   OPEN imgs_cs
   FETCH imgs_cs INTO l_n

   IF l_n = 0 THEN
      LET l_imgs.imgs01 = p_rvbs.rvbs021
      LET l_imgs.imgs02 = p_ware
      LET l_imgs.imgs03 = p_loca
      LET l_imgs.imgs04 = p_lot
      LET l_imgs.imgs05 = p_rvbs.rvbs03
      LET l_imgs.imgs06 = p_rvbs.rvbs04
      LET l_imgs.imgs07 = l_ima25
      LET l_imgs.imgs08 = 0
      LET l_imgs.imgs09 = p_rvbs.rvbs05
      LET l_imgs.imgs10 = p_rvbs.rvbs07
      LET l_imgs.imgs11 = p_rvbs.rvbs08

      #LET l_sql2 = "INSERT INTO ",l_dbs_tra CLIPPED,"imgs_file",    #FUN-A50102
      LET l_sql2 = "INSERT INTO ",cl_get_target_table( l_plant_new, 'imgs_file' ),   #FUN-A50102
                   "(imgs01,imgs02,imgs03,imgs04,imgs05,imgs06,",
                   " imgs07,imgs08,imgs09,imgs10,imgs11)",
                   " VALUES( ?,?,?,?,?,?, ?,?,?,?,?)"

        CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
        CALL cl_parse_qry_sql( l_sql2, l_plant_new ) RETURNING l_sql2   #FUN-A50102
      PREPARE ins_imgs FROM l_sql2

      EXECUTE ins_imgs USING l_imgs.imgs01,l_imgs.imgs02,l_imgs.imgs03,
                             l_imgs.imgs04,l_imgs.imgs05,l_imgs.imgs06,
                             l_imgs.imgs07,l_imgs.imgs08,l_imgs.imgs09,
                             l_imgs.imgs10,l_imgs.imgs11
      IF SQLCA.sqlcode<>0 THEN
         LET g_msg = l_dbs_new CLIPPED,'ins imgs'
         IF g_bgerr THEN
            LET g_showmsg=p_rvbs.rvbs021,"/",p_ware,"/",p_loca,"/",p_lot,"/",p_rvbs.rvbs03,"/",p_rvbs.rvbs04
            CALL s_errmsg('imgs01,imgs02,imgs03,imgs04,imgs05,imgs06',g_showmsg,'imgs_ins',SQLCA.SQLCODE,1)
         ELSE
            CALL cl_err("imgs_ins",SQLCA.sqlcode,1)
         END IF
         LET g_success = 'N'
      END IF
   END IF  
      
   LET l_tlfs.tlfs01=p_rvbs.rvbs021       #異動料件編號
   LET l_tlfs.tlfs02=p_ware                #倉庫
   LET l_tlfs.tlfs03=p_loca                #儲位
   LET l_tlfs.tlfs04=p_lot                 #批號
   LET l_tlfs.tlfs05=p_rvbs.rvbs03         #序號
   LET l_tlfs.tlfs06=p_rvbs.rvbs04         #外部批號
  #MOD-C30663 str------
  #LET l_tlfs.tlfs07=l_ima25
   SELECT img09 INTO l_tlfs.tlfs07 FROM img_file
    WHERE img01 = l_tlfs.tlfs01 AND img02 = l_tlfs.tlfs02
      AND img03 = l_tlfs.tlfs03 AND img04 = l_tlfs.tlfs04
  #MOD-C30663 end------
   LET l_tlfs.tlfs08=p_rvbs.rvbs00
                   
   CASE l_tlfs.tlfs08
      WHEN "apmt742" 
         LET l_tlfs.tlfs09=-1
      WHEN "axmt840"
         LET l_tlfs.tlfs09=1
   END CASE
      
   LET l_tlfs.tlfs10=p_rvbs.rvbs01
   LET l_tlfs.tlfs11=p_rvbs.rvbs02
   LET l_tlfs.tlfs111=p_date
   LET l_tlfs.tlfs12=g_today
   LET l_tlfs.tlfs13=p_rvbs.rvbs06
   LET l_tlfs.tlfs14=p_rvbs.rvbs07
   LET l_tlfs.tlfs15=p_rvbs.rvbs08

   #LET l_sql2 = "INSERT INTO ",l_dbs_tra CLIPPED,"tlfs_file",     #FUN-A50102
   LET l_sql2 = "INSERT INTO ",cl_get_target_table( l_plant_new, 'tlfs_file' ),   #FUN-A50102
                "(tlfs01,tlfs02,tlfs03,tlfs04,tlfs05,tlfs06,tlfs07,",
                " tlfs08,tlfs09,tlfs10,tlfs11,tlfs12,tlfs13,tlfs14,",
                " tlfs15,tlfs111)",
                " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"

        CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
        CALL cl_parse_qry_sql( l_sql2, l_plant_new ) RETURNING l_sql2   #FUN-A50102
   PREPARE ins_tlfs FROM l_sql2

   EXECUTE ins_tlfs USING l_tlfs.tlfs01,l_tlfs.tlfs02,l_tlfs.tlfs03,
                          l_tlfs.tlfs04,l_tlfs.tlfs05,l_tlfs.tlfs06,
                          l_tlfs.tlfs07,l_tlfs.tlfs08,l_tlfs.tlfs09,
                          l_tlfs.tlfs10,l_tlfs.tlfs11,l_tlfs.tlfs12,
                          l_tlfs.tlfs13,l_tlfs.tlfs14,l_tlfs.tlfs15,
                          l_tlfs.tlfs111

   IF SQLCA.sqlcode<>0 THEN
      IF g_bgerr THEN
        LET g_showmsg=l_tlfs.tlfs01,"/",l_tlfs.tlfs12
        CALL s_errmsg('tlfs01,tlfs06',g_showmsg,'ins tlfs:',SQLCA.sqlcode,1)
      ELSE
        CALL cl_err('ins tlfs:',SQLCA.sqlcode,1)
      END IF
      LET g_success = 'N'
   END IF
END FUNCTION
#No.CHI-990031 --End
