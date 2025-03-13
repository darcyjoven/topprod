# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# PATTERN NAME...: scpmq003.4gl
# DESCRIPTIONS...: 狀態查詢作業
# DATE & AUTHOR..: No.FUN-C90076 12/10/27 By fengrui
# Modify.........: No.TQC-CC0141 12/12/27 By fengrui 委外工單延期調整,項目編號匯總調整 

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
   DEFINE tm  RECORD                                              
                 wc2 STRING,                                     
                 a   LIKE type_file.chr1,       #小計選項
                 b   LIKE type_file.chr1, 
                 c   LIKE type_file.chr1, 
                 d   LIKE type_file.chr1, 
                 h   LIKE type_file.chr1,
                 g   LIKE type_file.chr1
              END RECORD     
   DEFINE g_filter_wc     STRING              
   DEFINE g_msg     LIKE type_file.chr1000                                                                                           
   DEFINE g_sql     STRING                                                                                    
   DEFINE g_str     STRING    
   DEFINE l_table   STRING
   DEFINE g_rec_b   LIKE type_file.num10
   DEFINE g_cnt     LIKE type_file.num10      
   DEFINE g_pname   LIKE type_file.chr1   
   DEFINE g_pmk,g_pmk_excel    DYNAMIC ARRAY OF RECORD  #48
                speed     LIKE type_file.chr1,
                state     LIKE type_file.chr1,
                pmk01     LIKE pmk_file.pmk01,
                pmk02     LIKE pmk_file.pmk02,
                pmk04     LIKE pmk_file.pmk04,
                pmk12     LIKE pmk_file.pmk12,
                gen02     LIKE gen_file.gen02,
                pmk13     LIKE pmk_file.pmk13,
                gem02     LIKE gem_file.gem02,
                pmk09     LIKE pmk_file.pmk09,
                pmc03     LIKE pmc_file.pmc03,
                pmk18     LIKE pmk_file.pmk18,
                pml02     LIKE pml_file.pml02,
                pml04     LIKE pml_file.pml04,
                pml041    LIKE pml_file.pml041,
                ima021    LIKE ima_file.ima021,
                pml07     LIKE pml_file.pml07,
                pml20     LIKE pml_file.pml20,
                pml86     LIKE pml_file.pml86,
                pml87     LIKE pml_file.pml87,
                pml21     LIKE pml_file.pml21,
                pmn31     LIKE pmn_file.pmn31,
                pmn31t_1  LIKE pmn_file.pmn31t,
                pmn88     LIKE pmn_file.pmn88,
                pmn88t    LIKE pmn_file.pmn88t,
                pmn50     LIKE pmn_file.pmn50,
                pmn55     LIKE pmn_file.pmn55,
                pmn50a    LIKE pmn_file.pmn50,
                pmn53     LIKE pmn_file.pmn53,
                pmnud07    LIKE pmn_file.pmnud07,
                rvv39     LIKE rvv_file.rvv39,
                rvv39t    LIKE rvv_file.rvv39t,
                rvv17     LIKE rvv_file.rvv17,
                apb09     LIKE apb_file.apb09,
                apb24     LIKE apb_file.apb24,
                pmm21     LIKE pmm_file.pmm21,
                pmm43     LIKE pmm_file.pmm43,
                gec07     LIKE gec_file.gec07,
                pmm22     LIKE pmm_file.pmm22,
                pmm42     LIKE pmm_file.pmm42,
                pmm99     LIKE pmm_file.pmm99,
                pml35     LIKE pml_file.pml35,
                pml34     LIKE pml_file.pml34,
                pml33     LIKE pml_file.pml33,
                pml41     LIKE pml_file.pml41,
                pml16     LIKE pml_file.pml16,
                pml24     LIKE pml_file.pml24,
                pml25     LIKE pml_file.pml25,
                pml12     LIKE pml_file.pml12,
                pja02     LIKE pja_file.pja02,
                pml121    LIKE pml_file.pml121,
                pjb03     LIKE pjb_file.pjb03 
                ,pml06    like pml_file.pml06 #darcy:2022/11/04 add
                         END RECORD 
    DEFINE g_pmk_1,g_pmk_1_excel   DYNAMIC ARRAY OF RECORD   #29
                pmk01_1   LIKE pmk_file.pmk01,  #单号
                pmk02_1   LIKE pmk_file.pmk02,  #性质
                pmk04_1   LIKE pmk_file.pmk04,  #日期
                pmk12_1   LIKE pmk_file.pmk12,  #人员
                gen02_1   LIKE gen_file.gen02,
                pmk13_1   LIKE pmk_file.pmk13,  #部门
                gem02_1   LIKE gem_file.gem02,  
                pmk09_1   LIKE pmk_file.pmk09,  #厂商
                pmc03_1   LIKE pmc_file.pmc03,
                pml04_1   LIKE pml_file.pml04,  #料号
                pml041_1  LIKE pml_file.pml041,
                ima021_1  LIKE ima_file.ima021,
                pml12_1   LIKE pml_file.pml12,  #项目编号
                pja02_1   LIKE pja_file.pja02,
                pml121_1  LIKE pml_file.pml121, #WBS
                pjb03_1   LIKE pjb_file.pjb03,
                pmm22_1   LIKE pmm_file.pmm22,  #币别
                pml20_1   LIKE pml_file.pml20,  #数量 [订购量-请购数量]
                pml87_1   LIKE pml_file.pml87,  #数量 [请购量-计价数量]
                pml21_1   LIKE pml_file.pml21,  #数量 [采购量]
                pmn88_1   LIKE pmn_file.pmn88,  #金额 [采购未税金额]
                pmn88t_1  LIKE pmn_file.pmn88t, #金额 [采购含税金额]
                pmn50_1   LIKE pmn_file.pmn50,  #数量 [收货数量]
                pmn55_1   LIKE pmn_file.pmn55,  #数量 [验退量]
                pmn50a_1  LIKE pmn_file.pmn50,  #数量 [未交量]
                pmn53_1   LIKE pmn_file.pmn53,  #数量 [已入库量]
                pmnud07_1   LIKE pmn_file.pmnud07,  #数量 [已入库量]
                rvv39_1   LIKE rvv_file.rvv39,  #金额 [入库未税金额]
                rvv39t_1  LIKE rvv_file.rvv39t, #金额 [入库含税金额]
                rvv17_1   LIKE rvv_file.rvv17,  #数量 [退货量]
                apb09_1   LIKE apb_file.apb09,  #数量 [已请款数量]
                apb24_1   LIKE apb_file.apb24   #金额 [已请款金额]
                         END RECORD
   DEFINE g_row_count    LIKE type_file.num10  
   DEFINE g_curs_index   LIKE type_file.num10  
   DEFINE g_jump         LIKE type_file.num10  
   DEFINE mi_no_ask      LIKE type_file.num5
   DEFINE g_no_ask       LIKE type_file.num5  
   DEFINE l_ac,l_ac1     LIKE type_file.num5                                                                                        
   DEFINE g_pmk_qty      LIKE type_file.num20_6      #訂單數量總計
   DEFINE g_pmk_sum      LIKE type_file.num20_6      #訂單本幣金額總計
   DEFINE g_pmk_sum1     LIKE type_file.num20_6      #訂單原幣金額總計
   DEFINE g_cmd          LIKE type_file.chr1000  
   DEFINE g_rec_b2       LIKE type_file.num10   
   DEFINE g_flag         LIKE type_file.chr1 
   DEFINE g_action_flag  LIKE type_file.chr100   
   DEFINE w              ui.Window
   DEFINE f              ui.Form
   DEFINE page om.DomNode  
   DEFINE
    g_head          RECORD  #18
        pmk01_2     LIKE pmk_file.pmk01,
        pmk02_2     LIKE pmk_file.pmk02,
        pmk09_2     LIKE pmk_file.pmk09,
        pmc03_2     LIKE pmc_file.pmc03,
        pmk04_2     LIKE pmk_file.pmk04,
        pmk18_2     LIKE pmk_file.pmk18,
        pmk12_2     LIKE pmk_file.pmk12,
        gen02_2     LIKE gen_file.gen02,
        pmk13_2     LIKE pmk_file.pmk13,
        gem02_2     LIKE gem_file.gem02,
        pmm22_2     LIKE pmm_file.pmm22,
        pmm42_2     LIKE pmm_file.pmm42,
        pmm43_2     LIKE pmm_file.pmm42,
        gec07_2     LIKE gec_file.gec07,
        pml87_2     LIKE pml_file.pml87,
        pmn53_2     LIKE pmn_file.pmn53,
        pmkpro_2    LIKE type_file.num5,
        pml02_2     LIKE pml_file.pml02  #free 串查主键
                    END RECORD,
    g_head_pml      RECORD
        pml01       LIKE pml_file.pml01,
        pmk04_pml   LIKE pmk_file.pmk04,
        pmk09_pml   LIKE pmk_file.pmk09,
        pmc03_pml   LIKE pmc_file.pmc03,
        pmk12_pml   LIKE pmk_file.pmk12,
        gen02_pml   LIKE gen_file.gen02
                    END RECORD,
    g_head_pmn      RECORD
        pmm01_pmn   LIKE pmm_file.pmm01,
        pmm04_pmn   LIKE pmm_file.pmm04,
        pmm09_pmn   LIKE pmm_file.pmm09,
        pmc03_pmn   LIKE pmc_file.pmc03,
        pmm12_pmn   LIKE pmm_file.pmm12,
        gen02_pmn   LIKE gen_file.gen02
                    END RECORD,
    g_head_rvb      RECORD
        rva01_rvb   LIKE rva_file.rva01,  #单号
        rva05_rvb   LIKE rva_file.rva05,  #厂商
        pmc03_rvb   LIKE pmc_file.pmc03,
        rva06_rvb   LIKE rva_file.rva06,  #日期
        rva33_rvb   LIKE rva_file.rva33,  #申请人
        gen02_rvb   LIKE gen_file.gen02,  
        rvaconf_rvb LIKE rva_file.rvaconf #审核
                    END RECORD,
    g_head_qct      RECORD 
        qcs01_qct   LIKE qcs_file.qcs01,    #來源單號
        qcs02_qct   LIKE qcs_file.qcs02,    #來源項次
        qcs05_qct   LIKE qcs_file.qcs05,    #
        qcs021_qct  LIKE qcs_file.qcs021,   #料件編號
        ima02_qct   LIKE ima_file.ima02,    #
        ima021_qct  LIKE ima_file.ima02,    #
        qcs03_qct   LIKE qcs_file.qcs03,    #廠商編號
        pmc03_qct   LIKE pmc_file.pmc03,    #
        qcs091_qct  LIKE qcs_file.qcs091,
        qcs09_qct   LIKE qcs_file.qcs09,
        des_qct     LIKE qcs_file.qcs021,
        qcs13_qct   LIKE qcs_file.qcs13,    #檢驗員
        gen02_qct   LIKE gen_file.gen02,    #
        qcs14_qct   LIKE qcs_file.qcs14     #審核否
                    END RECORD, 
     g_head_rvv     RECORD 
        rvu01_rvv   LIKE rvu_file.rvu01,    #入庫單號
        rvu02_rvv   LIKE rvu_file.rvu01,    #出货单号
        rvu03_rvv   LIKE rvu_file.rvu03,    #異動日期
        rvu04_rvv   LIKE rvu_file.rvu04,    #廠商編號
        rvu05_rvv   LIKE rvu_file.rvu05,    #廠商簡稱
        rvu06_rvv   LIKE rvu_file.rvu06,    #部門編號
        gem02_rvv   LIKE gem_file.gem02,    #部門簡稱
        rvu07_rvv   LIKE rvu_file.rvu07,    #人員編號
        gen02_rvv   LIKE gen_file.gen02,    #人員名稱
        rvuconf_rvv LIKE rvu_file.rvuconf   #審核
                    END RECORD,
     g_head_rvv_y   RECORD                  #验退
        rvu01_rvv_y   LIKE rvu_file.rvu01,    #入庫單號
        rvu02_rvv_y   LIKE rvu_file.rvu01,    #出货单号
        rvu03_rvv_y   LIKE rvu_file.rvu03,    #異動日期
        rvu04_rvv_y   LIKE rvu_file.rvu04,    #廠商編號
        rvu05_rvv_y   LIKE rvu_file.rvu05,    #廠商簡稱
        rvu06_rvv_y   LIKE rvu_file.rvu06,    #部門編號
        gem02_rvv_y   LIKE gem_file.gem02,    #部門簡稱
        rvu07_rvv_y   LIKE rvu_file.rvu07,    #人員編號
        gen02_rvv_y   LIKE gen_file.gen02,    #人員名稱
        rvuconf_rvv_y LIKE rvu_file.rvuconf   #審核
                    END RECORD,
     g_head_rvv_c   RECORD                  #仓退
        rvu01_rvv_c   LIKE rvu_file.rvu01,    #入庫單號
        rvu02_rvv_c   LIKE rvu_file.rvu01,    #出货单号
        rvu03_rvv_c   LIKE rvu_file.rvu03,    #異動日期
        rvu04_rvv_c   LIKE rvu_file.rvu04,    #廠商編號
        rvu05_rvv_c   LIKE rvu_file.rvu05,    #廠商簡稱
        rvu06_rvv_c   LIKE rvu_file.rvu06,    #部門編號
        gem02_rvv_c   LIKE gem_file.gem02,    #部門簡稱
        rvu07_rvv_c   LIKE rvu_file.rvu07,    #人員編號
        gen02_rvv_c   LIKE gen_file.gen02,    #人員名稱
        rvuconf_rvv_c LIKE rvu_file.rvuconf   #審核
                    END RECORD,
     g_head_apb     RECORD 
        apa01_apb   LIKE apa_file.apa01,    #帐款编号
        apa02_apb   LIKE apa_file.apa02,    #帐款日期 
        apa05_apb   LIKE apa_file.apa05,    #送货厂商编号 
        pmc03_apb   LIKE pmc_file.pmc03,    #送货厂商名称
        apa06_apb   LIKE apa_file.apa06,    #付款厂商编号
        apa07_apb   LIKE apa_file.apa07,    #付款厂商简称 
        apa41_apb   LIKE apa_file.apa41,    #确认码 
        apa42_apb   LIKE apa_file.apa42,    #作废码
        apamksg_apb LIKE apa_file.apamksg   #是否签核
                    END RECORD,
    g_pmk_2         DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        pmk18       LIKE pmk_file.pmk18,    #確認否
        pmk01       LIKE pmk_file.pmk01,    #請購單號
        spml20      LIKE pml_file.pml20,    #縂請購量
        spml21      LIKE pml_file.pml21,    #轉採購量
        pmkpro      LIKE type_file.num5,    #進度
        pmk04       LIKE pmk_file.pmk04,    #請購日期
        mpml33      LIKE pml_file.pml33,    #交貨日
        pmk09       LIKE pmk_file.pmk09,    #供應商
        pmc03_pmk   LIKE pmc_file.pmc03,    #名稱
        pmk12       LIKE pmk_file.pmk12,    #請購員
        gen02_pmk   LIKE gen_file.gen02,    #姓名
        pmk25       LIKE pmk_file.pmk25     #狀況碼
                    END RECORD,
    g_pml           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        pml02       LIKE pml_file.pml02,    #項次
        pml04       LIKE pml_file.pml04,    #料件編號
        pml041      LIKE pml_file.pml041,   #品名
        ima021_pr   LIKE ima_file.ima021,   #規格
        pml07       LIKE pml_file.pml07,    #請購單位
        pml20       LIKE pml_file.pml20,    #訂購量
        pml21a      LIKE pml_file.pml21,    #轉採購量
        pmlpro      LIKE type_file.num5,    #請購進度
        pml33       LIKE pml_file.pml33,    #交貨日
        pml16       LIKE pml_file.pml16     #狀況碼
                    END RECORD,
    g_pmm           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        pmm18       LIKE pmm_file.pmm18,    #確認否
        pmm01       LIKE pmm_file.pmm01,    #採購單號
        spmn20      LIKE pmn_file.pmn20,    #
        spmn53      LIKE pmn_file.pmn53,    #
        pmmpro      LIKE type_file.num5,    #
        pmm04       LIKE pmm_file.pmm04,    #採購日期
        mpmn33      LIKE pmn_file.pmn33,    #
        pmm09       LIKE pmm_file.pmm09,    #供應商
        pmc03_pmm   LIKE pmc_file.pmc03,    #供應商簡稱
        pmm12       LIKE pmm_file.pmm12,    #採購員
        gen02_pmm   LIKE gen_file.gen02,    #姓名
        pmm25       LIKE pmm_file.pmm25     #狀況碼
                    END RECORD,
    g_pmn           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        pmn02       LIKE pmn_file.pmn02,    #項次
        pmn04       LIKE pmn_file.pmn04,    #料件編號
        pmn041      LIKE pmn_file.pmn041,   #品名
        ima021_po   LIKE ima_file.ima021,   #規格
        pmn07       LIKE pmn_file.pmn07,    #請購單位
        pmn20       LIKE pmn_file.pmn20,    #訂購量
        pmn53       LIKE pmn_file.pmn53,    #轉採購量
        pmnpro      LIKE type_file.num5,    #請購進度
        pmn33       LIKE pmn_file.pmn33,    #原始交貨日期
        pmn31       LIKE pmn_file.pmn31,    #單價
        pmn31t      LIKE pmn_file.pmn31t,   #含稅單價
        pmn88       LIKE pmn_file.pmn88,    #金額
        pmn88t      LIKE pmn_file.pmn88t,   #含稅金額
        pmn16       LIKE pmn_file.pmn16,    #狀況碼
        pmn24       LIKE pmn_file.pmn24,    #請購單號
        pmn25       LIKE pmn_file.pmn25     #請購單項次
                    END RECORD,
    g_rva           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        rvaconf     LIKE rva_file.rvaconf,  #审核
        rva01       LIKE rva_file.rva01,    #编号
        rva05       LIKE rva_file.rva05,    #厂商
        pmc03_rva   LIKE pmc_file.pmc03,    #
        rva06       LIKE rva_file.rva06,    #日期
        rva33       LIKE rva_file.rva33,    #申请人
        gen02_rva   LIKE gen_file.gen02     
                    END RECORD,
    g_rvb           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        rvb02       LIKE rvb_file.rvb02,    #項次
        rvb05       LIKE rvb_file.rvb05,    #料號
        rvb051      LIKE rvb_file.rvb051,   #品名
        ima021_rvb  LIKE ima_file.ima021,   #規格
        rvb06       LIKE rvb_file.rvb06,    #已請款量
        rvb07       LIKE rvb_file.rvb07,    #實收數量
        rvb08       LIKE rvb_file.rvb08,    #收貨數量
        rvb09       LIKE rvb_file.rvb09,    #允請數量
        rvb10       LIKE rvb_file.rvb10,    #收料單價
        rvb29       LIKE rvb_file.rvb29,    #退貨量
        rvb30       LIKE rvb_file.rvb30,    #入庫量
        rvb31       LIKE rvb_file.rvb31,    #可入庫量
        rvb32       LIKE rvb_file.rvb32,    #退扣
        rvb33       LIKE rvb_file.rvb33     #允收數量
                    END RECORD, 
    g_qcs           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        qcs01       LIKE qcs_file.qcs01,    #來源單號
        qcs02       LIKE qcs_file.qcs02,    #來源項次
        qcs021      LIKE qcs_file.qcs021,   #料件編號
        ima02_qcs   LIKE ima_file.ima02,    #
        ima021_qcs  LIKE ima_file.ima021,   #
        qcs03       LIKE qcs_file.qcs03,    #廠商編號
        pmc03_qcs   LIKE pmc_file.pmc03,    #
        qcs04       LIKE qcs_file.qcs04,    #檢驗日期
        qcs041      LIKE qcs_file.qcs041,   #檢驗時間
        qcs05       LIKE qcs_file.qcs05,    #檢驗批號
        qcs09       LIKE qcs_file.qcs09,    #判斷結果
        qcs091      LIKE qcs_file.qcs091,   #合格數量
        qcs13       LIKE qcs_file.qcs13,    #檢驗員
        gen02_qcs   LIKE gen_file.gen02,    #
        qcs14       LIKE qcs_file.qcs14     #審核否
                    END RECORD, 
    g_qct           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        qct03       LIKE qct_file.qct03,
        qct04       LIKE qct_file.qct04,
        qct05       LIKE qct_file.qct05,
        qct06       LIKE qct_file.qct06,
        qct07       LIKE qct_file.qct07,
        qct08       LIKE qct_file.qct08,
        qct09       LIKE qct_file.qct09,
        qct10       LIKE qct_file.qct10,
        qct11       LIKE qct_file.qct11
                    END RECORD, 
    g_rvu           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        rvuconf     LIKE rvu_file.rvuconf,  #審核
        rvu01       LIKE rvu_file.rvu01,    #入庫單號
        rvu02       LIKE rvu_file.rvu02,    #收貨單號
        rvu03       LIKE rvu_file.rvu03,    #異動日期
        rvu04       LIKE rvu_file.rvu04,    #廠商編號
        rvu05       LIKE rvu_file.rvu05,    #廠商簡稱
        rvu06       LIKE rvu_file.rvu06,    #部門編號
        gem02_rvu   LIKE gem_file.gem02,    #部門簡稱
        rvu07       LIKE rvu_file.rvu07,    #人員編號
        gen02_rvu   LIKE gen_file.gen02     #人員名稱
                    END RECORD, 
    g_rvv           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        rvv02       LIKE rvv_file.rvv02,    #项次
        rvv05       LIKE rvv_file.rvv05,    #出货项次
        rvv31       LIKE rvv_file.rvv31,    #料件
        rvv031      LIKE rvv_file.rvv031,   #品名
        ima021_rvv   LIKE ima_file.ima021,  #规格
        rvv35       LIKE rvv_file.rvv35,    #单位
        rvv35_fac   LIKE rvv_file.rvv35_fac, #换算率
        rvv36       LIKE rvv_file.rvv36,    #采购单号
        rvv37       LIKE rvv_file.rvv37,    #采购项次
        rvv25       LIKE rvv_file.rvv25,    #样品否
        rvv17       LIKE rvv_file.rvv17,    #异动数量  ##
        rvv32       LIKE rvv_file.rvv32,    #仓库
        rvv33       LIKE rvv_file.rvv33,    #储位
        rvv34       LIKE rvv_file.rvv34,    #批号
        rvv38       LIKE rvv_file.rvv38,    #税前单价
        rvv38t      LIKE rvv_file.rvv38,    #含税单价
        rvv39       LIKE rvv_file.rvv39 ,   #税前金额   ##
        rvv39t      LIKE rvv_file.rvv39     #含税金额   ##
                    END RECORD,
    g_rvu_y         DYNAMIC ARRAY OF RECORD #程式變數 (舊值) #验退
        rvuconf     LIKE rvu_file.rvuconf,  #審核
        rvu01       LIKE rvu_file.rvu01,    #入庫單號
        rvu02       LIKE rvu_file.rvu02,    #收貨單號
        rvu03       LIKE rvu_file.rvu03,    #異動日期
        rvu04       LIKE rvu_file.rvu04,    #廠商編號
        rvu05       LIKE rvu_file.rvu05,    #廠商簡稱
        rvu06       LIKE rvu_file.rvu06,    #部門編號
        gem02_rvu   LIKE gem_file.gem02,    #部門簡稱
        rvu07       LIKE rvu_file.rvu07,    #人員編號
        gen02_rvu   LIKE gen_file.gen02     #人員名稱
                    END RECORD, 
    g_rvv_y         DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        rvv02       LIKE rvv_file.rvv02,    #项次
        rvv05       LIKE rvv_file.rvv05,    #出货项次
        rvv31       LIKE rvv_file.rvv31,    #料件
        rvv031      LIKE rvv_file.rvv031,   #品名
        ima021_rvv   LIKE ima_file.ima021,  #规格
        rvv35       LIKE rvv_file.rvv35,    #单位
        rvv35_fac   LIKE rvv_file.rvv35_fac, #换算率
        rvv36       LIKE rvv_file.rvv36,    #采购单号
        rvv37       LIKE rvv_file.rvv37,    #采购项次
        rvv25       LIKE rvv_file.rvv25,    #样品否
        rvv17       LIKE rvv_file.rvv17,    #异动数量  ##
        rvv32       LIKE rvv_file.rvv32,    #仓库
        rvv33       LIKE rvv_file.rvv33,    #储位
        rvv34       LIKE rvv_file.rvv34,    #批号
        rvv38       LIKE rvv_file.rvv38,    #税前单价
        rvv38t      LIKE rvv_file.rvv38,    #含税单价
        rvv39       LIKE rvv_file.rvv39 ,   #税前金额   ##
        rvv39t      LIKE rvv_file.rvv39     #含税金额   ##
                    END RECORD,
    g_rvu_c         DYNAMIC ARRAY OF RECORD #程式變數 (舊值) #仓退
        rvuconf     LIKE rvu_file.rvuconf,  #審核
        rvu01       LIKE rvu_file.rvu01,    #入庫單號
        rvu02       LIKE rvu_file.rvu02,    #收貨單號
        rvu03       LIKE rvu_file.rvu03,    #異動日期
        rvu04       LIKE rvu_file.rvu04,    #廠商編號
        rvu05       LIKE rvu_file.rvu05,    #廠商簡稱
        rvu06       LIKE rvu_file.rvu06,    #部門編號
        gem02_rvu   LIKE gem_file.gem02,    #部門簡稱
        rvu07       LIKE rvu_file.rvu07,    #人員編號
        gen02_rvu   LIKE gen_file.gen02     #人員名稱
                    END RECORD, 
    g_rvv_c         DYNAMIC ARRAY OF RECORD #程式變數 (舊值) #仓退
        rvv02       LIKE rvv_file.rvv02,    #项次
        rvv05       LIKE rvv_file.rvv05,    #出货项次
        rvv31       LIKE rvv_file.rvv31,    #料件
        rvv031      LIKE rvv_file.rvv031,   #品名
        ima021_rvv   LIKE ima_file.ima021,  #规格
        rvv35       LIKE rvv_file.rvv35,    #单位
        rvv35_fac   LIKE rvv_file.rvv35_fac, #换算率
        rvv36       LIKE rvv_file.rvv36,    #采购单号
        rvv37       LIKE rvv_file.rvv37,    #采购项次
        rvv25       LIKE rvv_file.rvv25,    #样品否
        rvv17       LIKE rvv_file.rvv17,    #异动数量  ##
        rvv32       LIKE rvv_file.rvv32,    #仓库
        rvv33       LIKE rvv_file.rvv33,    #储位
        rvv34       LIKE rvv_file.rvv34,    #批号
        rvv38       LIKE rvv_file.rvv38,    #税前单价
        rvv38t      LIKE rvv_file.rvv38,    #含税单价
        rvv39       LIKE rvv_file.rvv39 ,   #税前金额   ##
        rvv39t      LIKE rvv_file.rvv39     #含税金额   ##
                    END RECORD,
    g_apa           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        apa41       LIKE apa_file.apa41,    #确认码 
        apa42       LIKE apa_file.apa42,    #作废码 
        apamksg     LIKE apa_file.apamksg,  #签核否 
        apa01       LIKE apa_file.apa01,    #账款编号
        apa02       LIKE apa_file.apa02,    #账款日期
        apa05       LIKE apa_file.apa05,    #请款厂商  
        pmc03_apa   LIKE pmc_file.pmc03,    #简称 
        apa06       LIKE apa_file.apa06,    #付款厂商
        apa07       LIKE apa_file.apa07,    #简称
        apa21       LIKE apa_file.apa21,    #人员
        gen02_apa   LIKE gen_file.gen02,
        apa22       LIKE apa_file.apa22,    #部门
        gem02_apa   LIKE gem_file.gem02
                    END RECORD,

    g_apb           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        apb02       LIKE apb_file.apb02,    #项次 
        apb29       LIKE apb_file.apb29,    #类型 
        apb21       LIKE apb_file.apb04,    #入库单号
        apb22       LIKE apb_file.apb05,    #入库项次
        apb34       LIKE apb_file.apb34,    #冲暂估
        apb01_apb   LIKE apb_file.apb01,    #暂估账款单号
        apb06       LIKE apb_file.apb06,    #采购单号
        apb07       LIKE apb_file.apb07,    #采购单项次
        apb12       LIKE apb_file.apb12,    #料号
        apb27       LIKE apb_file.apb27,    #品名
        ima021_apb  LIKE ima_file.ima021,   #规格
        apb28       LIKE apb_file.apb28,    #单位
        apb09       LIKE apb_file.apb09,    #数量
        apb23       LIKE apb_file.apb23,    #原币单价
        apb24       LIKE apb_file.apb24,    #原币金额
        apb08       LIKE apb_file.apb08,    #本币单价  
        apb10       LIKE apb_file.apb10     #本币金额
                    END RECORD,
    g_rec_b_pmk     LIKE type_file.num5,    #單身筆數
    g_rec_b_pml     LIKE type_file.num5,    #單身筆數
    g_rec_b_pmm     LIKE type_file.num5,    #單身筆數
    g_rec_b_pmn     LIKE type_file.num5,    #單身筆數
    g_rec_b_rva     LIKE type_file.num5,    #單身筆數
    g_rec_b_rvb     LIKE type_file.num5,    #單身筆數
    g_rec_b_qcs     LIKE type_file.num5,    #單身筆數
    g_rec_b_qct     LIKE type_file.num5,    #單身筆數 
    g_rec_b_rvu     LIKE type_file.num5,    #單身筆數
    g_rec_b_rvv     LIKE type_file.num5,    #單身筆數
    g_rec_b_rvu_y   LIKE type_file.num5,    #單身筆數
    g_rec_b_rvv_y   LIKE type_file.num5,    #單身筆數
    g_rec_b_rvu_c   LIKE type_file.num5,    #單身筆數
    g_rec_b_rvv_c   LIKE type_file.num5,    #單身筆數
    g_rec_b_apa     LIKE type_file.num5,    #單身筆數
    g_rec_b_apb     LIKE type_file.num5,    #單身筆數 
    l_ac_pmk        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_pml        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_pmm        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_pmn        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_rva       LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_rvb       LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_qcs        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_qct        LIKE type_file.num5,    #目前處理的ARRAY CNT 
    l_ac_rvu       LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_rvv       LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_rvu_y     LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_rvv_y     LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_rvu_c     LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_rvv_c     LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_apa       LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_apb       LIKE type_file.num5     #目前處理的ARRAY CNT
DEFINE g_b_flag     LIKE type_file.num5
DEFINE g_b_flag2    LIKE type_file.num5
DEFINE g_b_flag3    LIKE type_file.num5
DEFINE g_b_flag4    LIKE type_file.num5
DEFINE g_int_flag   LIKE type_file.chr1
DEFINE g_pmk01_o    LIKE pmk_file.pmk01
DEFINE g_pml02_o    LIKE pml_file.pml02
DEFINE g_pmk01_change_pml LIKE type_file.chr1
DEFINE g_pmk01_change_pmn LIKE type_file.chr1
DEFINE g_pmk01_change_rvb LIKE type_file.chr1
DEFINE g_pmk01_change_qct LIKE type_file.chr1
DEFINE g_pmk01_change_rvv LIKE type_file.chr1
DEFINE g_pmk01_change_rvv_y LIKE type_file.chr1
DEFINE g_pmk01_change_rvv_c LIKE type_file.chr1
DEFINE g_pmk01_change_apb LIKE type_file.chr1
DEFINE g_pml02_change_pml LIKE type_file.chr1
DEFINE g_pml02_change_pmn LIKE type_file.chr1

    
FUNCTION scpmq003(p_prog)
   DEFINE p_prog LIKE type_file.chr20

   OPEN WINDOW q003_w AT 5,10                        #str---add by huanglf160806
        WITH FORM "cpm/42f/cpmq003" ATTRIBUTE(STYLE = g_win_style)  
   CASE p_prog
      WHEN 'cpmq003' 
         LET g_prog = p_prog
         LET g_pname = '1'
         CALL cl_set_locale_frm_name("cpmq003")
      WHEN 'cpmq004'
         LET g_prog = p_prog
         LET g_pname = '2'
         CALL cl_set_locale_frm_name("cpmq004")
      WHEN 'apmq003'
         LET g_prog = p_prog
         LET g_pname = '3'
         CALL cl_set_locale_frm_name("apmq003")
   END CASE 
   CALL cl_ui_init() 
   CALL cl_set_act_visible("revert_filter",FALSE)
   CALL q003_table()   #free
   DELETE FROM cpmq003_tmp
   DELETE FROM cpmq003_tmp1
   CALL q003_additem()
   CALL q003_q()   
   CALL q003_menu()

   DROP TABLE cpmq003_tmp;
   CLOSE WINDOW q003_w  
END FUNCTION 

FUNCTION q003_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       
   DEFINE   l_msg   STRING   
   DEFINE   l_wc    STRING
   DEFINE   l_action_page3    LIKE type_file.chr1

   WHILE TRUE
      IF g_action_choice = "exit"  THEN
         EXIT WHILE
      END IF
      LET l_action_page3 = 'Y'
      IF cl_null(g_action_choice) THEN 
         IF g_action_flag = "page1" THEN  
            CALL q003_bp("G")
            LET l_action_page3 = 'N'
         END IF
         IF g_action_flag = "page2" THEN  
            CALL q003_bp2()
            LET l_action_page3 = 'N'
         END IF
         IF g_action_flag = "page3" AND l_action_page3 = 'Y' THEN
            CALL q003_bp3()
         END IF
      END IF 
      CASE g_action_choice
         WHEN "page1"
            CALL q003_bp("G")
         
         WHEN "page2"
            CALL q003_bp2()
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q003_q()    
            END IF   
            LET g_action_choice = " " 
         WHEN "data_filter"
            IF cl_chk_act_auth() THEN
               CALL q003_filter_askkey()
               CALL q003()
               CALL q003_show()
            END IF 
            LET g_action_choice = " "           
         WHEN "revert_filter"
            IF cl_chk_act_auth() THEN
               LET g_filter_wc = ''
               CALL cl_set_act_visible("revert_filter",FALSE) 
               CALL q003()
               CALL q003_show() 
            END IF             
            LET g_action_choice = " "
         WHEN "help"
            CALL cl_show_help()
            LET g_action_choice = " "
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            LET g_action_choice = " "
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               IF g_action_flag = "page1" THEN
                  LET page = f.FindNode("Page","page1")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_pmk_excel),'','')
               END IF
               IF g_action_flag = "page2" THEN
                  LET page = f.FindNode("Page","page2")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_pmk_1),'','')
               END IF
               IF g_action_flag = "page3" THEN
                  CALL q003_excel()
               END IF
            END IF
            LET g_action_choice = " "
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               LET g_doc.column1 = "pmk01"
               LET g_doc.value1 = ''
               CALL cl_doc()
            END IF
            LET g_action_choice = " "
         WHEN "pmk"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_head.pmk01_2) THEN
                  CALL q003_b_fill_pmk()
               ELSE
                  CALL g_pmk_2.clear()
                  CALL g_pml.clear()
               END IF
            END IF
            LET g_action_choice = " "
         WHEN "pml"
            IF cl_chk_act_auth() THEN
               CALL q003_b_fill_pml()
            END IF
            LET g_action_choice = " "
         WHEN "pmm"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_head.pmk01_2) THEN
                 CALL q003_b_fill_pmm()
               ELSE
                  CALL g_pmm.clear()
               END IF
            END IF
            LET g_action_choice = " "
         WHEN "pmn"
            IF cl_chk_act_auth() THEN
               #待处理
               CALL q003_b_fill_pmn() 
            END IF
            LET g_action_choice = " "
         WHEN "rva"
            IF cl_chk_act_auth() THEN
               CALL q003_b_fill_rva()
            END IF
            LET g_action_choice = " "   
         WHEN "rvb"
            IF cl_chk_act_auth() THEN
               CALL q003_b_fill_rvb()
            END IF
            LET g_action_choice = " "  
         WHEN "qcs"
            IF cl_chk_act_auth() THEN
               CALL q003_b_fill_qcs()
            END IF
            LET g_action_choice = " "
         WHEN "qct"
            IF cl_chk_act_auth() THEN
               CALL q003_b_fill_qct()
            END IF
            LET g_action_choice = " "
         WHEN "rvu"
            IF cl_chk_act_auth() THEN
               CALL q003_b_fill_rvu()
            END IF
            LET g_action_choice = " "
         WHEN "rvv"
            IF cl_chk_act_auth() THEN
               CALL q003_b_fill_rvv()
            END IF
            LET g_action_choice = " "
         WHEN "rvu_y"
            IF cl_chk_act_auth() THEN
               CALL q003_b_fill_rvu_y()
            END IF
            LET g_action_choice = " "
         WHEN "rvv_y"
            IF cl_chk_act_auth() THEN
               CALL q003_b_fill_rvv_y()
            END IF
            LET g_action_choice = " "
         WHEN "rvu_c"
            IF cl_chk_act_auth() THEN
               CALL q003_b_fill_rvu_c()
            END IF
            LET g_action_choice = " "
         WHEN "rvv_c"
            IF cl_chk_act_auth() THEN
               CALL q003_b_fill_rvv_c()
            END IF
            LET g_action_choice = " "
         WHEN "apa"
            IF cl_chk_act_auth() THEN
               CALL q003_b_fill_apa()
            END IF
            LET g_action_choice = " "
         WHEN "apb"
            IF cl_chk_act_auth() THEN
               CALL q003_b_fill_apb()
            END IF
            LET g_action_choice = " "
      END CASE
   END WHILE
END FUNCTION

FUNCTION q003_b_fill()
DEFINE l_wc    STRING
DEFINE l_wc1   STRING 

   CALL g_pmk.clear()
   CALL g_pmk_excel.clear()   
   LET g_cnt = 1
   LET g_rec_b = 0
   IF tm.b ='N' AND tm.c = 'N' AND tm.d = 'N' THEN
      CALL g_pmk.clear()
      CALL g_pmk_1.clear()
      LET l_wc1=' 1=2'
   ELSE 
      LET l_wc1='1=1'
   END IF    
   
   LET g_sql = "SELECT speed,state,pmk01,pmk02,pmk04,pmk12,gen02,pmk13,gem02,pmk09, ", 
                      "pmc03,pmk18,pml02,pml04,pml041,ima021,pml07,pml20,pml86,pml87, ",     
                      "pml21,pmn31,pmn31t,pmn88,pmn88t,pmn50,pmn55,pmn50a,pmn53,pmnud07,rvv39, ",  #str---add by huanglf160806   
                      "rvv39t,rvv17,apb09,apb24,pmm21,pmm43,gec07,pmm22,pmm42,pmm99, ",
                      "pml35,pml34,pml33,pml41,pml16,pml24,pml25,pml12,pja02,pml121,pjb03 ",
                      ",pml06", #darcy:2022/11/04 add
               "  FROM cpmq003_tmp WHERE 1=1 AND ",l_wc1
      
   LET g_sql = g_sql," ORDER BY pmk01,pmk02,pmk04,pmk12,pmk13,pmk09,pml04,pml12 "
  
   
   PREPARE cpmq003_pb_cs FROM g_sql
   DECLARE pmk_curs  CURSOR FOR cpmq003_pb_cs        #CURSOR

   LET g_pmk_qty =0
   LET g_pmk_sum =0
   LET g_pmk_sum1=0
   FOREACH pmk_curs INTO g_pmk_excel[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(g_pmk_excel[g_cnt].pml20) THEN  LET g_pmk_excel[g_cnt].pml20=0 END IF 
      IF cl_null(g_pmk_excel[g_cnt].pmn88) THEN  LET g_pmk_excel[g_cnt].pmn88=0 END IF 
      IF cl_null(g_pmk_excel[g_cnt].pmn88t) THEN LET g_pmk_excel[g_cnt].pmn88t=0 END IF 
      LET g_pmk_qty =g_pmk_qty + g_pmk_excel[g_cnt].pml20
      LET g_pmk_sum =g_pmk_sum + g_pmk_excel[g_cnt].pmn88
      LET g_pmk_sum1=g_pmk_sum1+ g_pmk_excel[g_cnt].pmn88t
      IF g_cnt <= g_max_rec THEN
         LET g_pmk[g_cnt].* = g_pmk_excel[g_cnt].*
      END IF
      LET g_cnt = g_cnt + 1
   END FOREACH
   IF g_cnt <= g_max_rec THEN
      CALL g_pmk.deleteElement(g_cnt)
   END IF
   CALL g_pmk_excel.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF g_rec_b > g_max_rec THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b = g_max_rec
   END IF
   DISPLAY g_rec_b    TO FORMONLY.cnt
   DISPLAY g_pmk_qty  TO FORMONLY.tot_qty
   DISPLAY g_pmk_sum  TO FORMONLY.tot_sum
   DISPLAY g_pmk_sum1 TO FORMONLY.tot_sum1
END FUNCTION

FUNCTION q003_b_fill_2()
DEFINE l_wc,l_sql    STRING

   CALL g_pmk_1.clear()
   LET g_rec_b2 = 0
   LET g_cnt = 1
   LET g_pmk_qty = 0
   LET g_pmk_sum = 0
   LET g_pmk_sum1 = 0
   IF tm.b ='N' AND tm.c = 'N' AND tm.d = 'N' THEN
      CLEAR FORM 
      INITIALIZE g_head.* TO NULL
      CALL g_pmk_2.clear()
      CALL g_pmm.clear()
      CALL g_rva.clear()
      CALL g_qcs.clear()
      CALL g_rvu.clear()
      CALL g_rvu_y.clear()
      CALL g_rvu_c.clear()
      CALL g_apa.clear()
      RETURN
   END IF 

   CALL q003_get_sum()
     
END FUNCTION

FUNCTION q003_b_fill_pmk()              #BODY FILL UP

    IF cl_null(g_head.pmk01_2) THEN LET g_head.pmk01_2='' END IF  
    CASE g_pname
       WHEN '2' 
          LET g_sql = 
              "SELECT pmk18,pmk01,SUM(pml20),SUM(pml21),'',pmk04,MIN(pml33),pmk09,'',pmk12,'',pmk25",
              " FROM pml_file,pmk_file,pmn_file",
              " WHERE pmk01 = pml01 AND pml01=pmn24 AND pml02=pmn25 ",
              "   AND pmn01 ='", g_head.pmk01_2 CLIPPED ,"' ",
              " GROUP BY pmk18,pmk01,pmk04,pmk09,pmk12,pmk25 ",
              " ORDER BY 1"
       WHEN '3'
          LET g_sql = 
              "SELECT pmk18,pmk01,SUM(pml20),SUM(pml21),'',pmk04,MIN(pml33),pmk09,'',pmk12,'',pmk25",
              " FROM pml_file,pmk_file,pmn_file,rvb_file",
              " WHERE pmk01 = pml01 AND pml01=pmn24 AND pml02=pmn25 ",
              "   AND pmn01 = rvb04 AND pmn02 = rvb03 ",
              "   AND rvb01 ='", g_head.pmk01_2 CLIPPED ,"' ",
              " GROUP BY pmk18,pmk01,pmk04,pmk09,pmk12,pmk25 ",
              " ORDER BY 1"
       OTHERWISE 
          IF g_head.pmk02_2='7' THEN
             LET g_sql = 
                 "SELECT sfb87,sfb01,SUM(sfb08),SUM(pmn20),'',sfb81,MIN(sfb15),sfb82,'',sfb44,'','' ",
                 " FROM sfb_file LEFT OUTER JOIN pmn_file ON pmn41=sfb01 ",
                 " WHERE sfb02='7' ",
                 "   AND sfb01='", g_head.pmk01_2 CLIPPED ,"'",
                 " GROUP BY sfb87,sfb01,sfb81,sfb82,sfb44 ",
                 " ORDER BY 1"
          ELSE 
             LET g_sql = 
                 "SELECT pmk18,pmk01,SUM(pml20),SUM(pml21),'',pmk04,MIN(pml33),pmk09,'',pmk12,'',pmk25",
                 " FROM pml_file,pmk_file",
                 " WHERE pmk01 = pml01",
                 "   AND pmk01='", g_head.pmk01_2 CLIPPED ,"'",
                 " GROUP BY pmk18,pmk01,pmk04,pmk09,pmk12,pmk25 ",
                 " ORDER BY 1"
          END IF 
    END CASE 
    
    PREPARE q003_pmk1 FROM g_sql
    DECLARE pmk_curs1 CURSOR FOR q003_pmk1

    CALL g_pmk_2.clear()
    LET g_cnt = 1
    LET g_rec_b_pmk = 0
    MESSAGE "Searching!"
    FOREACH pmk_curs1 INTO g_pmk_2[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT pmc03 INTO g_pmk_2[g_cnt].pmc03_pmk FROM pmc_file
        WHERE pmc01 = g_pmk_2[g_cnt].pmk09
       SELECT gen02 INTO g_pmk_2[g_cnt].gen02_pmk FROM gen_file
        WHERE gen01 = g_pmk_2[g_cnt].pmk12
       LET g_pmk_2[g_cnt].pmkpro = g_pmk_2[g_cnt].spml21/g_pmk_2[g_cnt].spml20*100
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_pmk_2.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_pmk = g_cnt-1
    DISPLAY g_rec_b_pmk TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION q003_b_fill_pml()              #BODY FILL UP

    IF cl_null(g_head_pml.pml01) THEN LET g_head_pml.pml01='' END IF 
    IF g_head.pmk02_2='7' THEN 
       LET g_sql =
           "SELECT DISTINCT '',sfb05,ima02,ima021,ima55,sfb08,pmn20,'',sfb15,'' ",
           " FROM sfb_file LEFT OUTER JOIN ima_file on sfb05=ima01 ",
           "               LEFT OUTER JOIN pmn_file on sfb01=pmn41 ",
           " WHERE sfb01 ='", g_head_pml.pml01 CLIPPED ,"'",
           " ORDER BY 1"
    ELSE 
       LET g_sql =
           "SELECT DISTINCT pml02,pml04,pml041,ima021,pml07,pml20,pml21,'',pml33,pml16 ",
           " FROM pml_file LEFT OUTER JOIN ima_file on pml04=ima01 ",
           " WHERE pml01 ='", g_head_pml.pml01 CLIPPED ,"'",
           " ORDER BY 1"
    END IF 
    PREPARE q003_pml FROM g_sql
    DECLARE pml_curs CURSOR FOR q003_pml

    CALL g_pml.clear()
    LET g_cnt = 1
    LET g_rec_b_pml = 0
    MESSAGE "Searching!"
    FOREACH pml_curs INTO g_pml[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_pml[g_cnt].pmlpro = g_pml[g_cnt].pml21a/g_pml[g_cnt].pml20*100
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_pml.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_pml = g_cnt-1
    DISPLAY g_rec_b_pml TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION q003_b_fill_pmm()              #BODY FILL UP

    IF cl_null(g_head.pmk01_2) THEN LET g_head.pmk01_2='' END IF 
    CASE g_pname
       WHEN '2'
          LET g_sql =
              "SELECT pmm18,pmm01,SUM(pmn20),SUM(pmn53),'',pmm04,",
              "       MIN(pmn33),pmm09,'',pmm12,'',pmm25 ",
              " FROM pmn_file,pmm_file",
              " WHERE pmm01 = pmn01",
              "   AND pmn01 ='", g_head.pmk01_2 CLIPPED,"' ",
              " GROUP BY pmm18,pmm01,pmm04,pmm09,pmm12,pmm25",
              " ORDER BY 1"
       WHEN '3'
          LET g_sql =
              "SELECT pmm18,pmm01,SUM(pmn20),SUM(pmn53),'',pmm04,",
              "       MIN(pmn33),pmm09,'',pmm12,'',pmm25 ",
              " FROM pmm_file,pmn_file,rvb_file",
              " WHERE pmm01 = rvb04 AND pmn02=rvb03 ",
              "   AND pmm01 = pmn01 ",
              "   AND rvb01 ='", g_head.pmk01_2 CLIPPED,"' ",
              " GROUP BY pmm18,pmm01,pmm04,pmm09,pmm12,pmm25",
              " ORDER BY 1"
       OTHERWISE 
          IF g_head.pmk02_2='7' THEN 
             LET g_sql =
                 "SELECT pmm18,pmm01,SUM(pmn20),SUM(pmn53),'',pmm04,",
                 "       MIN(pmn33),pmm09,'',pmm12,'',pmm25 ",
                 " FROM pmn_file,pmm_file",
                 " WHERE pmm01 = pmn01",
                 "   AND pmn41 ='", g_head.pmk01_2 CLIPPED,"' ",
                 " GROUP BY pmm18,pmm01,pmm04,pmm09,pmm12,pmm25",
                 " ORDER BY 1"
          ELSE 
             LET g_sql =
                 "SELECT pmm18,pmm01,SUM(pmn20),SUM(pmn53),'',pmm04,",
                 "       MIN(pmn33),pmm09,'',pmm12,'',pmm25 ",
                 " FROM pmn_file,pmm_file",
                 " WHERE pmm01 = pmn01",
                 "   AND pmn24 ='", g_head.pmk01_2 CLIPPED,"' ",
                 " GROUP BY pmm18,pmm01,pmm04,pmm09,pmm12,pmm25",
                 " ORDER BY 1"
          END IF 
    END CASE 

    PREPARE q003_pmm FROM g_sql
    DECLARE pmm_curs CURSOR FOR q003_pmm

    CALL g_pmm.clear()
    LET g_cnt = 1
    LET g_rec_b_pmm = 0
    MESSAGE "Searching!"
    FOREACH pmm_curs INTO g_pmm[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT pmc03 INTO g_pmm[g_cnt].pmc03_pmm FROM pmc_file
        WHERE pmc01 = g_pmm[g_cnt].pmm09
       SELECT gen02 INTO g_pmm[g_cnt].gen02_pmm FROM gen_file
        WHERE gen01 = g_pmm[g_cnt].pmm12
       LET g_pmm[g_cnt].pmmpro = g_pmm[g_cnt].spmn53/g_pmm[g_cnt].spmn20*100
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_pmm.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_pmm = g_cnt-1
    DISPLAY g_rec_b_pmm TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION q003_b_fill_pmn()              #BODY FILL UP

    IF cl_null(g_head_pmn.pmm01_pmn) THEN LET g_head_pmn.pmm01_pmn='' END IF
    CASE g_pname 
       WHEN '2'
          LET g_sql =
              "SELECT DISTINCT pmn02,pmn04,pmn041,'',pmn07,pmn20,pmn53,'',",
              "       pmn33,pmn31,pmn31t,pmn88,pmn88t,pmn16,pmn24,pmn25 ",
              " FROM pmn_file",
              " WHERE pmn01 ='", g_head_pmn.pmm01_pmn CLIPPED,"'",
              " ORDER BY 1"
       WHEN '3'
          LET g_sql =
              "SELECT DISTINCT pmn02,pmn04,pmn041,'',pmn07,pmn20,pmn53,'',",
              "       pmn33,pmn31,pmn31t,pmn88,pmn88t,pmn16,pmn24,pmn25 ",
              " FROM pmn_file,rvb_file ",
              " WHERE pmn01=rvb04 AND pmn02=rvb03 ",
              "   AND pmn01 ='", g_head_pmn.pmm01_pmn CLIPPED,"'",
              "   AND rvb01 ='", g_head.pmk01_2 CLIPPED,"'",
              " ORDER BY 1"
       OTHERWISE 
          IF g_head.pmk02_2='7' THEN 
             LET g_sql =
                 "SELECT DISTINCT pmn02,pmn04,pmn041,'',pmn07,pmn20,pmn53,'',",
                 "       pmn33,pmn31,pmn31t,pmn88,pmn88t,pmn16,pmn24,pmn25 ",
                 " FROM pmn_file",
                 " WHERE pmn01 ='", g_head_pmn.pmm01_pmn CLIPPED,"'",
                 "   AND pmn41 ='", g_head.pmk01_2 CLIPPED,"'",
                 " ORDER BY 1"
          ELSE 
             LET g_sql =
                 "SELECT DISTINCT pmn02,pmn04,pmn041,'',pmn07,pmn20,pmn53,'',",
                 "       pmn33,pmn31,pmn31t,pmn88,pmn88t,pmn16,pmn24,pmn25 ",
                 " FROM pmn_file",
                 " WHERE pmn01 ='", g_head_pmn.pmm01_pmn CLIPPED,"'",
                 "   AND pmn24 ='", g_head.pmk01_2 CLIPPED,"'",
                 " ORDER BY 1"
          END IF 
    END CASE 
    PREPARE q003_pmn FROM g_sql
    DECLARE pmn_curs CURSOR FOR q003_pmn

    CALL g_pmn.clear()
    LET g_cnt = 1
    LET g_rec_b_pmn = 0
    MESSAGE "Searching!"
    FOREACH pmn_curs INTO g_pmn[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT ima021 INTO g_pmn[g_cnt].ima021_po FROM ima_file
        WHERE ima01 = g_pmn[g_cnt].pmn04
       LET g_pmn[g_cnt].pmnpro = g_pmn[g_cnt].pmn53/g_pmn[g_cnt].pmn20*100
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_pmn.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_pmn = g_cnt-1
    DISPLAY g_rec_b_pmn TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION q003_b_fill_rva()              #BODY FILL UP

    IF cl_null(g_head.pmk01_2) THEN LET g_head.pmk01_2='' END IF 
    CASE g_pname
       WHEN '2'
          LET g_sql = 
              "SELECT DISTINCT rvaconf,rva01,rva05,pmc03,rva06,rva33,gen02 ",
              "  FROM rva_file LEFT OUTER JOIN pmc_file ON rva05=pmc01 ",
              "                LEFT OUTER JOIN gen_file ON rva33=gen01,rvb_file ",
              " WHERE rva01=rvb01 AND rvb04 ='", g_head.pmk01_2 CLIPPED,"'",
              " ORDER BY 2 "
       WHEN '3'
          LET g_sql = 
              "SELECT DISTINCT rvaconf,rva01,rva05,pmc03,rva06,rva33,gen02 ",
              "  FROM rva_file LEFT OUTER JOIN pmc_file ON rva05=pmc01 ",
              "                LEFT OUTER JOIN gen_file ON rva33=gen01",
              " WHERE rva01 ='", g_head.pmk01_2 CLIPPED,"'",
              " ORDER BY 2 "
       OTHERWISE 
          IF g_head.pmk02_2='7' THEN 
             LET g_sql = 
                 "SELECT DISTINCT rvaconf,rva01,rva05,pmc03,rva06,rva33,gen02 ",
                 "  FROM rva_file LEFT OUTER JOIN pmc_file ON rva05=pmc01 ",
                 "                LEFT OUTER JOIN gen_file ON rva33=gen01,",
                 "       pmn_file,rvb_file ",
                 " WHERE pmn01=rvb04 AND pmn02=rvb03 AND rvb01=rva01 ",
                 "   AND pmn41 ='", g_head.pmk01_2 CLIPPED,"' ",
                 " ORDER BY 2 "
          ELSE 
             LET g_sql = 
                 "SELECT DISTINCT rvaconf,rva01,rva05,pmc03,rva06,rva33,gen02 ",
                 "  FROM rva_file LEFT OUTER JOIN pmc_file ON rva05=pmc01 ",
                 "                LEFT OUTER JOIN gen_file ON rva33=gen01,",
                 "       pmn_file,rvb_file ",
                 " WHERE pmn01=rvb04 AND pmn02=rvb03 AND rvb01=rva01  ",
                 "   AND pmn24 ='", g_head.pmk01_2 CLIPPED,"' ",
                 " ORDER BY 2 "
          END IF 
    END CASE 

    PREPARE q003_rva FROM g_sql
    DECLARE rva_curs CURSOR FOR q003_rva

    CALL g_rva.clear()
    LET g_cnt = 1
    LET g_rec_b_rva = 0
    MESSAGE "Searching!"
    FOREACH rva_curs INTO g_rva[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_rva.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_rva = g_cnt-1
    DISPLAY g_rec_b_rva TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION q003_b_fill_rvb()              #BODY FILL UP

    IF cl_null(g_head_rvb.rva01_rvb) THEN LET g_head_rvb.rva01_rvb='' END IF 
    CASE g_pname
       WHEN '2'
          LET g_sql = "SELECT DISTINCT rvb02,rvb05,rvb051,ima021,rvb06,rvb07,rvb08,",
                      "       rvb09,rvb10,rvb29,rvb30 ,rvb31,rvb32,rvb33 ",
                      "  FROM rvb_file LEFT OUTER JOIN ima_file ON rvb05=ima01 ",
                      " WHERE rvb01 ='", g_head_rvb.rva01_rvb CLIPPED ,"'",
                      "   AND rvb04 ='", g_head.pmk01_2 CLIPPED,"'", 
                      " ORDER BY 1"
       WHEN '3'
          LET g_sql = "SELECT DISTINCT rvb02,rvb05,rvb051,ima021,rvb06,rvb07,rvb08,",
                      "       rvb09,rvb10,rvb29,rvb30 ,rvb31,rvb32,rvb33 ",
                      "  FROM rvb_file LEFT OUTER JOIN ima_file ON rvb05=ima01 ",
                      " WHERE rvb01 ='", g_head_rvb.rva01_rvb CLIPPED ,"'",
                      " ORDER BY 1"
       OTHERWISE 
          IF g_head.pmk02_2='7' THEN 
             LET g_sql = "SELECT DISTINCT rvb02,rvb05,rvb051,ima021,rvb06,rvb07,rvb08,",
                         "       rvb09,rvb10,rvb29,rvb30 ,rvb31,rvb32,rvb33 ",
                         "  FROM rvb_file LEFT OUTER JOIN ima_file ON rvb05=ima01 ",
                         " WHERE rvb01 ='", g_head_rvb.rva01_rvb CLIPPED ,"'",
                         "   AND rvb34 ='", g_head.pmk01_2 CLIPPED,"'", 
                         " ORDER BY 1"
          ELSE 
             LET g_sql = "SELECT DISTINCT rvb02,rvb05,rvb051,ima021,rvb06,rvb07,rvb08,",
                      "       rvb09,rvb10,rvb29,rvb30 ,rvb31,rvb32,rvb33 ",
                      "  FROM rvb_file LEFT OUTER JOIN ima_file ON rvb05=ima01 ",
                      "      ,pmn_file ",
                      " WHERE pmn01=rvb04 AND pmn02=rvb03 ",
                      "   AND rvb01 ='", g_head_rvb.rva01_rvb CLIPPED ,"'",
                      "   AND pmn24 ='", g_head.pmk01_2 CLIPPED,"'", 
                      " ORDER BY 1"
          END IF 
       
    END CASE 

    PREPARE q003_rvb FROM g_sql
    DECLARE rvb_curs CURSOR FOR q003_rvb

    CALL g_rvb.clear()
    LET g_cnt = 1
    LET g_rec_b_rvb = 0
    MESSAGE "Searching!"
    FOREACH rvb_curs INTO g_rvb[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_rvb.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_rvb = g_cnt-1
    DISPLAY g_rec_b_rvb TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION q003_b_fill_qcs()              #BODY FILL UP
    DEFINE l_ima02  LIKE ima_file.ima02
    
    IF cl_null(g_head.pmk01_2) THEN LET g_head.pmk01_2='' END IF 
    CASE g_pname
       WHEN '2'
          LET g_sql = 
              "SELECT DISTINCT qcs01,qcs02,qcs021,ima02,ima021,qcs03,pmc03,",
              "       qcs04,qcs041,qcs05,qcs09,qcs091,qcs13,gen02,qcs14 ",
              "  FROM qcs_file LEFT OUTER JOIN ima_file ON qcs021=ima01 ",
              "                LEFT OUTER JOIN pmc_file ON qcs03 =pmc01 ",
              "                LEFT OUTER JOIN gen_file ON qcs13 =gen01 ",
              "      ,rvb_file ",
              " WHERE qcs01=rvb01 AND qcs02=rvb02 ",
              "   AND rvb04 ='",g_head.pmk01_2 CLIPPED,"' ",
              " ORDER BY 1,2,3"
       WHEN '3'
          LET g_sql = 
              "SELECT DISTINCT qcs01,qcs02,qcs021,ima02,ima021,qcs03,pmc03,",
              "       qcs04,qcs041,qcs05,qcs09,qcs091,qcs13,gen02,qcs14 ",
              "  FROM qcs_file LEFT OUTER JOIN ima_file ON qcs021=ima01 ",
              "                LEFT OUTER JOIN pmc_file ON qcs03 =pmc01 ",
              "                LEFT OUTER JOIN gen_file ON qcs13 =gen01 ",
              " WHERE qcs01='",g_head.pmk01_2 CLIPPED,"' ",
              " ORDER BY 1,2,3"
       OTHERWISE 
          IF g_head.pmk02_2='7' THEN 
             LET g_sql = 
                 "SELECT DISTINCT qcs01,qcs02,qcs021,ima02,ima021,qcs03,pmc03,",
                 "       qcs04,qcs041,qcs05,qcs09,qcs091,qcs13,gen02,qcs14 ",
                 "  FROM qcs_file LEFT OUTER JOIN ima_file ON qcs021=ima01 ",
                 "                LEFT OUTER JOIN pmc_file ON qcs03 =pmc01 ",
                 "                LEFT OUTER JOIN gen_file ON qcs13 =gen01 ",
                 "      ,rvb_file,pmn_file ",
                 " WHERE qcs01=rvb01 AND qcs02=rvb02 AND rvb03=pmn02 AND rvb04=pmn01 ",
                 "   AND pmn41 ='",g_head.pmk01_2 CLIPPED,"' ",
                 " ORDER BY 1,2,3"
          ELSE 
             LET g_sql = 
                 "SELECT DISTINCT qcs01,qcs02,qcs021,ima02,ima021,qcs03,pmc03,",
                 "       qcs04,qcs041,qcs05,qcs09,qcs091,qcs13,gen02,qcs14 ",
                 "  FROM qcs_file LEFT OUTER JOIN ima_file ON qcs021=ima01 ",
                 "                LEFT OUTER JOIN pmc_file ON qcs03 =pmc01 ",
                 "                LEFT OUTER JOIN gen_file ON qcs13 =gen01 ",
                 "      ,rvb_file,pmn_file ",
                 " WHERE qcs01=rvb01 AND qcs02=rvb02 AND rvb03=pmn02 AND rvb04=pmn01 ",
                 "   AND pmn24 ='",g_head.pmk01_2 CLIPPED,"' ",
                 " ORDER BY 1,2,3"
          END IF 
    END CASE 

    PREPARE q003_qcs FROM g_sql
    DECLARE qcs_curs CURSOR FOR q003_qcs

    CALL g_qcs.clear()
    LET g_cnt = 1
    LET g_rec_b_qcs = 0
    MESSAGE "Searching!"
    FOREACH qcs_curs INTO g_qcs[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET l_ima02 = ''
       SELECT pmn041 INTO l_ima02 FROM pmn_file,rvb_file 
        WHERE pmn01=rvb04 AND pmn02=rvb03 
          AND rvb01=g_qcs[g_cnt].qcs01 AND rvb02=g_qcs[g_cnt].qcs02
       IF NOT cl_null(l_ima02) THEN 
          LET g_qcs[g_cnt].ima02_qcs = l_ima02
       END IF 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_qcs.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_qcs = g_cnt-1
    DISPLAY g_rec_b_qcs TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION q003_b_fill_qct()              #BODY FILL UP

    IF cl_null(g_head_qct.qcs01_qct) THEN LET g_head_qct.qcs01_qct='' END IF 
    LET g_sql = "SELECT DISTINCT qct03,qct04,qct05,qct06,qct07,qct08,qct09,qct10,qct11",
                "  FROM qct_file ",
                " WHERE qct01 ='", g_head_qct.qcs01_qct CLIPPED,"' AND qct02 ='", g_head_qct.qcs02_qct CLIPPED,"'",
                " ORDER BY 1"
   
    PREPARE q003_qct FROM g_sql
    DECLARE qct_curs CURSOR FOR q003_qct

    CALL g_qct.clear()
    LET g_cnt = 1
    LET g_rec_b_qct = 0
    MESSAGE "Searching!"
    FOREACH qct_curs INTO g_qct[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_qct.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_qct = g_cnt-1
    DISPLAY g_rec_b_qct TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION q003_b_fill_rvu()              #BODY FILL UP

    IF cl_null(g_head.pmk01_2) THEN LET g_head.pmk01_2='' END IF 
    CASE g_pname
       WHEN '2'
          LET g_sql = 
              "SELECT DISTINCT rvuconf,rvu01,rvu02,rvu03,rvu04,rvu05,",
              "       rvu06,gem02,rvu07,gen02",
              "  FROM rvu_file LEFT OUTER JOIN gem_file ON rvu06=gem01 ",
              "                LEFT OUTER JOIN gen_file ON rvu07=gen01 ",
              "       ,rvv_file",
              " WHERE rvv01=rvu01 AND rvu00='1' ", 
              "   AND rvv36 ='", g_head.pmk01_2 CLIPPED,"' ",
              " ORDER BY 1"
       WHEN '3'
          LET g_sql = 
              "SELECT DISTINCT rvuconf,rvu01,rvu02,rvu03,rvu04,rvu05,",
              "       rvu06,gem02,rvu07,gen02",
              "  FROM rvu_file LEFT OUTER JOIN gem_file ON rvu06=gem01 ",
              "                LEFT OUTER JOIN gen_file ON rvu07=gen01 ",
              " WHERE rvu00='1' ", 
              "   AND rvu02 ='", g_head.pmk01_2 CLIPPED,"'",
              " ORDER BY 1"
       OTHERWISE 
          IF g_head.pmk02_2='7' THEN 
             LET g_sql = 
                 "SELECT DISTINCT rvuconf,rvu01,rvu02,rvu03,rvu04,rvu05,",
                 "       rvu06,gem02,rvu07,gen02",
                 "  FROM rvu_file LEFT OUTER JOIN gem_file ON rvu06=gem01 ",
                 "                LEFT OUTER JOIN gen_file ON rvu07=gen01 ",
                 "       ,pmn_file,rvv_file",
                 " WHERE rvv01=rvu01 AND rvu00='1' ", 
                 "   AND pmn01=rvv36 AND pmn02=rvv37 ",
                 "   AND pmn41 ='", g_head.pmk01_2 CLIPPED,"' ",
                 " ORDER BY 1"
          ELSE 
             LET g_sql = 
                 "SELECT DISTINCT rvuconf,rvu01,rvu02,rvu03,rvu04,rvu05,",
                 "       rvu06,gem02,rvu07,gen02",
                 "  FROM rvu_file LEFT OUTER JOIN gem_file ON rvu06=gem01 ",
                 "                LEFT OUTER JOIN gen_file ON rvu07=gen01 ",
                 "       ,pmn_file,rvv_file",
                 " WHERE rvv01=rvu01 AND rvu00='1' ", 
                 "   AND pmn01=rvv36 AND pmn02=rvv37 ",
                 "   AND pmn24 ='", g_head.pmk01_2 CLIPPED,"' ",
                 " ORDER BY 1"
          END IF 
    END CASE 
                
    PREPARE q003_rvu FROM g_sql
    DECLARE rvu_curs CURSOR FOR q003_rvu

    CALL g_rvu.clear()
    LET g_cnt = 1
    LET g_rec_b_rvu = 0
    MESSAGE "Searching!"
    FOREACH rvu_curs INTO g_rvu[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_rvu.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_rvu = g_cnt-1
    DISPLAY g_rec_b_rvu TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION q003_b_fill_rvv()              #BODY FILL UP

    IF cl_null(g_head_rvv.rvu01_rvv) THEN LET g_head_rvv.rvu01_rvv='' END IF 
    CASE g_pname
       WHEN '2'
          LET g_sql = "SELECT DISTINCT rvv02,rvv05,rvv31,rvv031,ima021,rvv35,rvv35_fac,",
                      "       rvv36,rvv37,rvv25,rvv17,rvv32,rvv33,rvv34,rvv38,rvv38t,rvv39,rvv39t ",
                      "  FROM rvv_file LEFT OUTER JOIN ima_file ON ima01=rvv31 ",
                      " WHERE rvv01 ='", g_head_rvv.rvu01_rvv CLIPPED ,"'",
                      "   AND rvv36 ='", g_head.pmk01_2 CLIPPED ,"'",
                      " ORDER BY 1"
       WHEN '3'
          LET g_sql = "SELECT DISTINCT rvv02,rvv05,rvv31,rvv031,ima021,rvv35,rvv35_fac,",
                      "       rvv36,rvv37,rvv25,rvv17,rvv32,rvv33,rvv34,rvv38,rvv38t,rvv39,rvv39t ",
                      "  FROM rvv_file LEFT OUTER JOIN ima_file ON ima01=rvv31 ",
                      " WHERE rvv01 ='", g_head_rvv.rvu01_rvv CLIPPED ,"'",
                      "   AND rvv04 ='", g_head.pmk01_2 CLIPPED ,"'",
                      " ORDER BY 1"
       OTHERWISE 
          IF g_head.pmk02_2='7' THEN 
             LET g_sql = "SELECT DISTINCT rvv02,rvv05,rvv31,rvv031,ima021,rvv35,rvv35_fac,",
                         "       rvv36,rvv37,rvv25,rvv17,rvv32,rvv33,rvv34,rvv38,rvv38t,rvv39,rvv39t ",
                         "  FROM rvv_file LEFT OUTER JOIN ima_file ON ima01=rvv31 ",
                         " WHERE rvv01 ='", g_head_rvv.rvu01_rvv CLIPPED ,"'",
                         "   AND rvv18 ='", g_head.pmk01_2 CLIPPED ,"'",
                         " ORDER BY 1"
          ELSE 
             LET g_sql = "SELECT DISTINCT rvv02,rvv05,rvv31,rvv031,ima021,rvv35,rvv35_fac,",
                         "       rvv36,rvv37,rvv25,rvv17,rvv32,rvv33,rvv34,rvv38,rvv38t,rvv39,rvv39t ",
                         "  FROM rvv_file LEFT OUTER JOIN ima_file ON ima01=rvv31 ",
                         "      ,pmn_file ",
                         " WHERE pmn01=rvv36 AND pmn02=rvv37 ",
                         "   AND rvv01 ='", g_head_rvv.rvu01_rvv CLIPPED ,"'",
                         "   AND pmn24 ='", g_head.pmk01_2 CLIPPED ,"'",
                         " ORDER BY 1"
          END IF 
    END CASE 

    PREPARE q003_rvv FROM g_sql
    DECLARE rvv_curs CURSOR FOR q003_rvv

    CALL g_rvv.clear()
    LET g_cnt = 1
    LET g_rec_b_rvv = 0
    MESSAGE "Searching!"
    FOREACH rvv_curs INTO g_rvv[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_rvv.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_rvv = g_cnt-1
    DISPLAY g_rec_b_rvv TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

#add str
FUNCTION q003_b_fill_rvu_y()              #BODY FILL UP

    IF cl_null(g_head.pmk01_2) THEN LET g_head.pmk01_2='' END IF 
    CASE g_pname
       WHEN '2'
          LET g_sql = 
              "SELECT DISTINCT rvuconf,rvu01,rvu02,rvu03,rvu04,rvu05,",
              "       rvu06,gem02,rvu07,gen02",
              "  FROM rvu_file LEFT OUTER JOIN gem_file ON rvu06=gem01 ",
              "                LEFT OUTER JOIN gen_file ON rvu07=gen01 ",
              "       ,rvv_file",
              " WHERE rvv01=rvu01 AND rvu00='2' ", 
              "   AND rvv36 ='", g_head.pmk01_2 CLIPPED,"' ",
              " ORDER BY 1"
       WHEN '3'
          LET g_sql = 
              "SELECT DISTINCT rvuconf,rvu01,rvu02,rvu03,rvu04,rvu05,",
              "       rvu06,gem02,rvu07,gen02",
              "  FROM rvu_file LEFT OUTER JOIN gem_file ON rvu06=gem01 ",
              "                LEFT OUTER JOIN gen_file ON rvu07=gen01 ",
              " WHERE rvu00='2' ", 
              "   AND rvu02 ='", g_head.pmk01_2 CLIPPED,"'",
              " ORDER BY 1"
       OTHERWISE 
          IF g_head.pmk02_2='7' THEN 
             LET g_sql = 
                 "SELECT DISTINCT rvuconf,rvu01,rvu02,rvu03,rvu04,rvu05,",
                 "       rvu06,gem02,rvu07,gen02",
                 "  FROM rvu_file LEFT OUTER JOIN gem_file ON rvu06=gem01 ",
                 "                LEFT OUTER JOIN gen_file ON rvu07=gen01 ",
                 "       ,pmn_file,rvv_file",
                 " WHERE rvv01=rvu01 AND rvu00='2' ", 
                 "   AND pmn01=rvv36 AND pmn02=rvv37 ",
                 "   AND pmn41 ='", g_head.pmk01_2 CLIPPED,"' ",
                 " ORDER BY 1"
          ELSE 
             LET g_sql = 
                 "SELECT DISTINCT rvuconf,rvu01,rvu02,rvu03,rvu04,rvu05,",
                 "       rvu06,gem02,rvu07,gen02",
                 "  FROM rvu_file LEFT OUTER JOIN gem_file ON rvu06=gem01 ",
                 "                LEFT OUTER JOIN gen_file ON rvu07=gen01 ",
                 "       ,pmn_file,rvv_file",
                 " WHERE rvv01=rvu01 AND rvu00='2' ", 
                 "   AND pmn01=rvv36 AND pmn02=rvv37 ",
                 "   AND pmn24 ='", g_head.pmk01_2 CLIPPED,"' ",
                 " ORDER BY 1"
          END IF 
    END CASE 
                
    PREPARE q003_rvu_y FROM g_sql
    DECLARE rvu_y_curs CURSOR FOR q003_rvu_y

    CALL g_rvu_y.clear()
    LET g_cnt = 1
    LET g_rec_b_rvu_y = 0
    MESSAGE "Searching!"
    FOREACH rvu_y_curs INTO g_rvu_y[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_rvu_y.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_rvu_y = g_cnt-1
    DISPLAY g_rec_b_rvu_y TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION q003_b_fill_rvv_y()              #BODY FILL UP

    IF cl_null(g_head_rvv_y.rvu01_rvv_y) THEN LET g_head_rvv_y.rvu01_rvv_y='' END IF 
    CASE g_pname
       WHEN '2'
          LET g_sql = "SELECT DISTINCT rvv02,rvv05,rvv31,rvv031,ima021,rvv35,rvv35_fac,",
                      "       rvv36,rvv37,rvv25,rvv17,rvv32,rvv33,rvv34,rvv38,rvv38t,rvv39,rvv39t ",
                      "  FROM rvv_file LEFT OUTER JOIN ima_file ON ima01=rvv31 ",
                      " WHERE rvv01 ='", g_head_rvv_y.rvu01_rvv_y CLIPPED ,"'",
                      "   AND rvv36 ='", g_head.pmk01_2 CLIPPED ,"'",
                      " ORDER BY 1"
       WHEN '3'
          LET g_sql = "SELECT DISTINCT rvv02,rvv05,rvv31,rvv031,ima021,rvv35,rvv35_fac,",
                      "       rvv36,rvv37,rvv25,rvv17,rvv32,rvv33,rvv34,rvv38,rvv38t,rvv39,rvv39t ",
                      "  FROM rvv_file LEFT OUTER JOIN ima_file ON ima01=rvv31 ",
                      " WHERE rvv01 ='", g_head_rvv_y.rvu01_rvv_y CLIPPED ,"'",
                      "   AND rvv04 ='", g_head.pmk01_2 CLIPPED ,"'",
                      " ORDER BY 1"
       OTHERWISE 
          IF g_head.pmk02_2='7' THEN 
             LET g_sql = "SELECT DISTINCT rvv02,rvv05,rvv31,rvv031,ima021,rvv35,rvv35_fac,",
                         "       rvv36,rvv37,rvv25,rvv17,rvv32,rvv33,rvv34,rvv38,rvv38t,rvv39,rvv39t ",
                         "  FROM rvv_file LEFT OUTER JOIN ima_file ON ima01=rvv31 ",
                         " WHERE rvv01 ='", g_head_rvv_y.rvu01_rvv_y CLIPPED ,"'",
                         "   AND rvv18 ='", g_head.pmk01_2 CLIPPED ,"'",
                         " ORDER BY 1"
          ELSE 
             LET g_sql = "SELECT DISTINCT rvv02,rvv05,rvv31,rvv031,ima021,rvv35,rvv35_fac,",
                         "       rvv36,rvv37,rvv25,rvv17,rvv32,rvv33,rvv34,rvv38,rvv38t,rvv39,rvv39t ",
                         "  FROM rvv_file LEFT OUTER JOIN ima_file ON ima01=rvv31 ",
                         "      ,pmn_file ",
                         " WHERE pmn01=rvv36 AND pmn02=rvv37 ",
                         "   AND rvv01 ='", g_head_rvv_y.rvu01_rvv_y CLIPPED ,"'",
                         "   AND pmn24 ='", g_head.pmk01_2 CLIPPED ,"'",
                         " ORDER BY 1"
          END IF 
    END CASE 

    PREPARE q003_rvv_y FROM g_sql
    DECLARE rvv_y_curs CURSOR FOR q003_rvv_y

    CALL g_rvv_y.clear()
    LET g_cnt = 1
    LET g_rec_b_rvv_y = 0
    MESSAGE "Searching!"
    FOREACH rvv_y_curs INTO g_rvv_y[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_rvv_y.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_rvv_y = g_cnt-1
    DISPLAY g_rec_b_rvv_y TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q003_b_fill_rvu_c()              #BODY FILL UP

    IF cl_null(g_head.pmk01_2) THEN LET g_head.pmk01_2='' END IF 
    CASE g_pname
       WHEN '2'
          LET g_sql = 
              "SELECT DISTINCT rvuconf,rvu01,rvu02,rvu03,rvu04,rvu05,",
              "       rvu06,gem02,rvu07,gen02",
              "  FROM rvu_file LEFT OUTER JOIN gem_file ON rvu06=gem01 ",
              "                LEFT OUTER JOIN gen_file ON rvu07=gen01 ",
              "       ,rvv_file",
              " WHERE rvv01=rvu01 AND rvu00='3' ", 
              "   AND rvv36 ='", g_head.pmk01_2 CLIPPED,"' ",
              " ORDER BY 1"
       WHEN '3'
          LET g_sql = 
              "SELECT DISTINCT rvuconf,rvu01,rvu02,rvu03,rvu04,rvu05,",
              "       rvu06,gem02,rvu07,gen02",
              "  FROM rvu_file LEFT OUTER JOIN gem_file ON rvu06=gem01 ",
              "                LEFT OUTER JOIN gen_file ON rvu07=gen01 ",
              " WHERE rvu00='3' ", 
              "   AND rvu02 ='", g_head.pmk01_2 CLIPPED,"'",
              " ORDER BY 1"
       OTHERWISE 
          IF g_head.pmk02_2='7' THEN 
             LET g_sql = 
                 "SELECT DISTINCT rvuconf,rvu01,rvu02,rvu03,rvu04,rvu05,",
                 "       rvu06,gem02,rvu07,gen02",
                 "  FROM rvu_file LEFT OUTER JOIN gem_file ON rvu06=gem01 ",
                 "                LEFT OUTER JOIN gen_file ON rvu07=gen01 ",
                 "       ,pmn_file,rvv_file",
                 " WHERE rvv01=rvu01 AND rvu00='3' ", 
                 "   AND pmn01=rvv36 AND pmn02=rvv37 ",
                 "   AND pmn41 ='", g_head.pmk01_2 CLIPPED,"' ",
                 " ORDER BY 1"
          ELSE 
             LET g_sql = 
                 "SELECT DISTINCT rvuconf,rvu01,rvu02,rvu03,rvu04,rvu05,",
                 "       rvu06,gem02,rvu07,gen02",
                 "  FROM rvu_file LEFT OUTER JOIN gem_file ON rvu06=gem01 ",
                 "                LEFT OUTER JOIN gen_file ON rvu07=gen01 ",
                 "       ,pmn_file,rvv_file",
                 " WHERE rvv01=rvu01 AND rvu00='3' ", 
                 "   AND pmn01=rvv36 AND pmn02=rvv37 ",
                 "   AND pmn24 ='", g_head.pmk01_2 CLIPPED,"' ",
                 " ORDER BY 1"
          END IF 
    END CASE 
                
    PREPARE q003_rvu_c FROM g_sql
    DECLARE rvu_c_curs CURSOR FOR q003_rvu_c

    CALL g_rvu_c.clear()
    LET g_cnt = 1
    LET g_rec_b_rvu_c = 0
    MESSAGE "Searching!"
    FOREACH rvu_c_curs INTO g_rvu_c[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_rvu_c.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_rvu_c = g_cnt-1
    DISPLAY g_rec_b_rvu_c TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q003_b_fill_rvv_c()              #BODY FILL UP

    IF cl_null(g_head_rvv_c.rvu01_rvv_c) THEN LET g_head_rvv_c.rvu01_rvv_c='' END IF 
    CASE g_pname
       WHEN '2'
          LET g_sql = "SELECT DISTINCT rvv02,rvv05,rvv31,rvv031,ima021,rvv35,rvv35_fac,",
                      "       rvv36,rvv37,rvv25,rvv17,rvv32,rvv33,rvv34,rvv38,rvv38t,rvv39,rvv39t ",
                      "  FROM rvv_file LEFT OUTER JOIN ima_file ON ima01=rvv31 ",
                      " WHERE rvv01 ='", g_head_rvv_c.rvu01_rvv_c CLIPPED ,"'",
                      "   AND rvv36 ='", g_head.pmk01_2 CLIPPED ,"'",
                      " ORDER BY 1"
       WHEN '3'
          LET g_sql = "SELECT DISTINCT rvv02,rvv05,rvv31,rvv031,ima021,rvv35,rvv35_fac,",
                      "       rvv36,rvv37,rvv25,rvv17,rvv32,rvv33,rvv34,rvv38,rvv38t,rvv39,rvv39t ",
                      "  FROM rvv_file LEFT OUTER JOIN ima_file ON ima01=rvv31 ",
                      " WHERE rvv01 ='", g_head_rvv_c.rvu01_rvv_c CLIPPED ,"'",
                      "   AND rvv04 ='", g_head.pmk01_2 CLIPPED ,"'",
                      " ORDER BY 1"
       OTHERWISE 
          IF g_head.pmk02_2='7' THEN 
             LET g_sql = "SELECT DISTINCT rvv02,rvv05,rvv31,rvv031,ima021,rvv35,rvv35_fac,",
                         "       rvv36,rvv37,rvv25,rvv17,rvv32,rvv33,rvv34,rvv38,rvv38t,rvv39,rvv39t ",
                         "  FROM rvv_file LEFT OUTER JOIN ima_file ON ima01=rvv31 ",
                         " WHERE rvv01 ='", g_head_rvv_c.rvu01_rvv_c CLIPPED ,"'",
                         "   AND rvv18 ='", g_head.pmk01_2 CLIPPED ,"'",
                         " ORDER BY 1"
          ELSE 
             LET g_sql = "SELECT DISTINCT rvv02,rvv05,rvv31,rvv031,ima021,rvv35,rvv35_fac,",
                         "       rvv36,rvv37,rvv25,rvv17,rvv32,rvv33,rvv34,rvv38,rvv38t,rvv39,rvv39t ",
                         "  FROM rvv_file LEFT OUTER JOIN ima_file ON ima01=rvv31 ",
                         "      ,pmn_file ",
                         " WHERE pmn01=rvv36 AND pmn02=rvv37 ",
                         "   AND rvv01 ='", g_head_rvv_c.rvu01_rvv_c CLIPPED ,"'",
                         "   AND pmn24 ='", g_head.pmk01_2 CLIPPED ,"'",
                         " ORDER BY 1"
          END IF 
    END CASE 

    PREPARE q003_rvv_c FROM g_sql
    DECLARE rvv_c_curs CURSOR FOR q003_rvv_c

    CALL g_rvv_c.clear()
    LET g_cnt = 1
    LET g_rec_b_rvv_c = 0
    MESSAGE "Searching!"
    FOREACH rvv_c_curs INTO g_rvv_c[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_rvv_c.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_rvv_c = g_cnt-1
    DISPLAY g_rec_b_rvv_c TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION
#add end
FUNCTION q003_b_fill_apa()              #BODY FILL UP

    IF cl_null(g_head.pmk01_2) THEN LET g_head.pmk01_2='' END IF 

    CASE g_pname
       WHEN '2'
          LET g_sql = 
              "SELECT DISTINCT apa41,apa42,apamksg,apa01,apa02,apa05,pmc03,apa06,",
              "       apa07,apa21,gen02,apa22,gem02",
              "  FROM apa_file LEFT OUTER JOIN pmc_file ON apa05=pmc01 ",
              "                LEFT OUTER JOIN gen_file ON apa21=gen01 ",
              "                LEFT OUTER JOIN gem_file ON apa22=gem01 ",
              "      ,apb_file ",
              " WHERE apa01=apb01 ",
              "   AND apb06 ='", g_head.pmk01_2 CLIPPED,"' ",
              " ORDER BY 4"
       WHEN '3'
          LET g_sql = 
              "SELECT DISTINCT apa41,apa42,apamksg,apa01,apa02,apa05,pmc03,apa06,",
              "       apa07,apa21,gen02,apa22,gem02",
              "  FROM apa_file LEFT OUTER JOIN pmc_file ON apa05=pmc01 ",
              "                LEFT OUTER JOIN gen_file ON apa21=gen01 ",
              "                LEFT OUTER JOIN gem_file ON apa22=gem01 ",
              "      ,apb_file ",
              " WHERE apa01=apb01 ",
              "   AND apb04 ='", g_head.pmk01_2 CLIPPED,"' ",
              " ORDER BY 4"
       OTHERWISE 
          IF g_head.pmk02_2='7' THEN 
             LET g_sql = 
                 "SELECT DISTINCT apa41,apa42,apamksg,apa01,apa02,apa05,pmc03,apa06,",
                 "       apa07,apa21,gen02,apa22,gem02",
                 "  FROM apa_file LEFT OUTER JOIN pmc_file ON apa05=pmc01 ",
                 "                LEFT OUTER JOIN gen_file ON apa21=gen01 ",
                 "                LEFT OUTER JOIN gem_file ON apa22=gem01 ",
                 "      ,apb_file,pmn_file ",
                 " WHERE apa01=apb01 AND apb06=pmn01 AND apb07=pmn02 ",
                 "   AND pmn41 ='", g_head.pmk01_2 CLIPPED,"' ",
                 " ORDER BY 4"
          ELSE 
             LET g_sql = 
                 "SELECT DISTINCT apa41,apa42,apamksg,apa01,apa02,apa05,pmc03,apa06,",
                 "       apa07,apa21,gen02,apa22,gem02",
                 "  FROM apa_file LEFT OUTER JOIN pmc_file ON apa05=pmc01 ",
                 "                LEFT OUTER JOIN gen_file ON apa21=gen01 ",
                 "                LEFT OUTER JOIN gem_file ON apa22=gem01 ",
                 "      ,apb_file,pmn_file ",
                 " WHERE apa01=apb01 AND apb06=pmn01 AND apb07=pmn02 ",
                 "   AND pmn24 ='", g_head.pmk01_2 CLIPPED,"' ",
                 " ORDER BY 4"
          END IF 
    END CASE 

    PREPARE q003_apa FROM g_sql
    DECLARE apa_curs CURSOR FOR q003_apa

    CALL g_apa.clear()
    LET g_cnt = 1
    LET g_rec_b_apa = 0
    MESSAGE "Searching!"
    FOREACH apa_curs INTO g_apa[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_apa.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_apa = g_cnt-1
    DISPLAY g_rec_b_apa TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q003_b_fill_apb()              #BODY FILL UP

    IF cl_null(g_head_apb.apa01_apb) THEN LET g_head_apb.apa01_apb='' END IF 
    CASE g_pname 
       WHEN '2'
          LET g_sql =
              "SELECT DISTINCT apb02,apb29,apb21,apb22,apb34,'',apb06, ",
              "       apb07,apb12,apb27,ima021,apb28,apb09, ",
              "       apb23,apb24,apb08,apb10 ",
              " FROM apb_file LEFT OUTER JOIN ima_file ON ima01=apb12 ",
              " WHERE apb01 ='", g_head_apb.apa01_apb CLIPPED ,"'",
              "   AND apb06 ='", g_head.pmk01_2 CLIPPED ,"'",
              " ORDER BY 1"
       WHEN '3'
          LET g_sql =
              "SELECT DISTINCT apb02,apb29,apb21,apb22,apb34,'',apb06, ",
              "       apb07,apb12,apb27,ima021,apb28,apb09, ",
              "       apb23,apb24,apb08,apb10 ",
              " FROM apb_file LEFT OUTER JOIN ima_file ON ima01=apb12 ",
              " WHERE apb01 ='", g_head_apb.apa01_apb CLIPPED ,"'",
              "   AND apb04 ='", g_head.pmk01_2 CLIPPED ,"'",
              " ORDER BY 1"
       OTHERWISE
          IF g_head.pmk02_2='7' THEN 
             LET g_sql =
                 "SELECT DISTINCT apb02,apb29,apb21,apb22,apb34,'',apb06, ",
                 "       apb07,apb12,apb27,ima021,apb28,apb09, ",
                 "       apb23,apb24,apb08,apb10 ",
                 " FROM apb_file LEFT OUTER JOIN ima_file ON ima01=apb12 ",
                 "     ,pmn_file ",
                 " WHERE pmn01 = apb06 AND pmn02 = apb07 ",
                 "   AND apb01 ='", g_head_apb.apa01_apb CLIPPED ,"'",
                 "   AND pmn41 ='", g_head.pmk01_2 CLIPPED ,"'",
                 " ORDER BY 1"
          ELSE 
             LET g_sql =
                 "SELECT DISTINCT apb02,apb29,apb21,apb22,apb34,'',apb06, ",
                 "       apb07,apb12,apb27,ima021,apb28,apb09, ",
                 "       apb23,apb24,apb08,apb10 ",
                 " FROM apb_file LEFT OUTER JOIN ima_file ON ima01=apb12 ",
                 "     ,pmn_file ",
                 " WHERE pmn01 = apb06 AND pmn02 = apb07 ",
                 "   AND apb01 ='", g_head_apb.apa01_apb CLIPPED ,"'",
                 "   AND pmn24 ='", g_head.pmk01_2 CLIPPED ,"'",
                 " ORDER BY 1"
          END IF 
    END CASE    
    PREPARE q003_apb FROM g_sql
    DECLARE apb_curs CURSOR FOR q003_apb

    CALL g_apb.clear()
    LET g_cnt = 1
    LET g_rec_b_apb = 0
    MESSAGE "Searching!"
    FOREACH apb_curs INTO g_apb[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_apb[g_cnt].apb01_apb=q110_set_apb01_unap(g_apb[g_cnt].apb21,g_apb[g_cnt].apb22,g_apb[g_cnt].apb34) 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_apb.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_apb = g_cnt-1
    DISPLAY g_rec_b_apb TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q003_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1,
            l_cutwip        LIKE ecm_file.ecm315,
            l_packwip       LIKE ecm_file.ecm315,
            l_completed     LIKE ecm_file.ecm315,
            l_sfb08         LIKE sfb_file.sfb08   


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_flag = 'page1' 

   IF g_action_choice = "page1"  AND NOT cl_null(tm.a) AND g_flag != '1' THEN
      CALL q003_b_fill()
   END IF
   
   LET g_action_choice = " "
   LET g_flag = ' '
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY BY NAME tm.a
   DISPLAY g_pmk_qty TO FORMONLY.tot_qty_1
   DISPLAY g_pmk_sum TO FORMONLY.tot_sum_1
   DISPLAY g_pmk_sum1 TO FORMONLY.tot_sum1_1
   DISPLAY ARRAY g_pmk TO s_pmk.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.h,tm.g
      FROM a,b,c,d,h,g ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q003_b_fill_2()
            CALL q003_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q003_b_fill()
            CALL g_pmk_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG

      ON CHANGE b,c,d,h,g
         CALL q003()
         CALL q003_b_fill()
         CALL q003_b_fill_2()
         LET g_action_choice = "page1"
         EXIT DIALOG 
   END INPUT
   DISPLAY ARRAY g_pmk TO s_pmk.* ATTRIBUTE(COUNT=g_rec_b)
       BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

   END DISPLAY

   ON ACTION page2
      LET g_action_choice = 'page2'
      EXIT DIALOG

   ON ACTION query
      LET g_action_choice="query"
      EXIT DIALOG      
 
   ON ACTION ACCEPT
      LET l_ac = ARR_CURR()
      CASE g_pname 
         WHEN '2'
            LET g_b_flag2 = 2  LET g_b_flag3 = 1
            CALL cl_set_comp_visible("pr,chu,qc,rv,rv_y,rv_c,ap,pmn", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("pr,chu,qc,rv,rv_y,rv_c,ap,pmn", TRUE)
         WHEN '3'
            LET g_b_flag2 = 3  LET g_b_flag3 = 1
            CALL cl_set_comp_visible("pr,po,qc,rv,rv_y,rv_c,ap,rvb", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("pr,po,qc,rv,rv_y,rv_c,ap,rvb", TRUE)
         OTHERWISE 
            LET g_b_flag2 = 1  LET g_b_flag3 = 1
            CALL cl_set_comp_visible("po,chu,qc,rv,rv_y,rv_c,ap,pml", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("po,chu,qc,rv,rv_y,rv_c,ap,pml", TRUE)
      END CASE 
      CALL act_page3()
      EXIT DIALOG

   ON ACTION data_filter
      LET g_action_choice="data_filter"
      EXIT DIALOG     

   ON ACTION revert_filter         
      LET g_action_choice="revert_filter"
      EXIT DIALOG 

   ON ACTION refresh_detail
      CALL q003()
      CALL q003_b_fill()
      CALL cl_set_comp_visible("page2", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page2", TRUE)
      LET g_action_choice = 'page1' 
      EXIT DIALOG

   ON ACTION page3
      LET l_ac = ARR_CURR()
      CASE g_pname 
         WHEN '2'
            LET g_b_flag2 = 2  LET g_b_flag3 = 1
            CALL cl_set_comp_visible("pr,chu,qc,rv,rv_y,rv_c,ap,pmn", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("pr,chu,qc,rv,rv_y,rv_c,ap,pmn", TRUE)
         WHEN '3'
            LET g_b_flag2 = 3  LET g_b_flag3 = 1
            CALL cl_set_comp_visible("pr,po,qc,rv,rv_y,rv_c,ap,rvb", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("pr,po,qc,rv,rv_y,rv_c,ap,rvb", TRUE)
         OTHERWISE 
            LET g_b_flag2 = 1  LET g_b_flag3 = 1
            CALL cl_set_comp_visible("po,chu,qc,rv,rv_y,rv_c,ap,pml", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("po,chu,qc,rv,rv_y,rv_c,ap,pml", TRUE)
      END CASE 
      CALL act_page3()
      EXIT DIALOG
    
   ON ACTION HELP
      LET g_action_choice="help"
      EXIT DIALOG

   ON ACTION locale
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   

   ON ACTION EXIT
      LET g_action_choice="exit"
      EXIT DIALOG

   ON ACTION controlg
      LET g_action_choice="controlg"
      EXIT DIALOG

   ON ACTION CANCEL
      LET INT_FLAG=FALSE
      LET g_action_choice="exit"
      EXIT DIALOG

   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE DIALOG
 
   ON ACTION about         
      CALL cl_about()      
 
   ON ACTION exporttoexcel
      LET g_action_choice = 'exporttoexcel'
      EXIT DIALOG

   ON ACTION related_document 
      LET g_action_choice="related_document"          
      EXIT DIALOG

   AFTER DIALOG
      CONTINUE DIALOG

   ON ACTION controls                    
      CALL cl_set_head_visible("","AUTO")
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q003_bp2()
DEFINE l_cutwip        LIKE ecm_file.ecm315,
       l_packwip       LIKE ecm_file.ecm315,
       l_completed     LIKE ecm_file.ecm315,
       l_sfb08         LIKE sfb_file.sfb08 
   LET g_flag = ' '
   LET g_action_flag = 'page2' 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY  tm.a TO a
   DISPLAY ARRAY g_pmk_1 TO s_pmk_1.* ATTRIBUTE(COUNT=g_rec_b2)
       BEFORE DISPLAY
          EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.h,tm.g
      FROM a,b,c,d,h,g ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q003_b_fill_2()
            CALL q003_set_visible()
            LET g_action_choice = "page2"
         ELSE
            CALL q003_b_fill()
            CALL cl_set_comp_visible("page2", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page2", TRUE)
            LET g_action_choice = "page1"
            CALL g_pmk_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY  tm.a TO a
         EXIT DIALOG
      ON CHANGE b,c,d,h,g
         CALL q003()
         CALL q003_b_fill()
         CALL q003_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_pmk_1 TO s_pmk_1.* ATTRIBUTE(COUNT=g_rec_b2)
       BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

   END DISPLAY

   ON ACTION page1
      LET g_action_choice="page1"
      EXIT DIALOG

   ON ACTION query
      LET g_action_choice="query"
      EXIT DIALOG      
 
   ON ACTION ACCEPT
      LET l_ac1 = ARR_CURR()
      IF l_ac1 > 0  THEN
         CALL q003_detail_fill(l_ac1)
         CALL cl_set_comp_visible("page2", FALSE)
         CALL cl_set_comp_visible("page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2", TRUE)
         CALL cl_set_comp_visible("page3", TRUE)
         LET g_action_choice= "page1"  
         LET g_flag = '1'              
         EXIT DIALOG 
      END IF
   

   ON ACTION refresh_detail
      CALL q003()
      CALL q003_b_fill()
      CALL cl_set_comp_visible("page2,page3", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page2,page3", TRUE)
      LET g_action_choice = 'page1' 
      EXIT DIALOG
   ON ACTION page3
      LET l_ac = g_pmk.getLength()
      IF l_ac > 0 THEN
         LET l_ac = 1
      END IF
      CASE g_pname 
         WHEN '2'
            LET g_b_flag2 = 2  LET g_b_flag3 = 1
            CALL cl_set_comp_visible("pr,chu,qc,rv,rv_y,rv_c,ap,pmn", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("pr,chu,qc,rv,rv_y,rv_c,ap,pmn", TRUE)
         WHEN '3'
            LET g_b_flag2 = 3  LET g_b_flag3 = 1
            CALL cl_set_comp_visible("pr,po,qc,rv,rv_y,rv_c,ap,rvb", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("pr,po,qc,rv,rv_y,rv_c,ap,rvb", TRUE)
         OTHERWISE 
            LET g_b_flag2 = 1  LET g_b_flag3 = 1
            CALL cl_set_comp_visible("po,chu,qc,rv,rv_y,rv_c,ap,pml", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("po,chu,qc,rv,rv_y,rv_c,ap,pml", TRUE)
      END CASE 
      CALL act_page3()
      EXIT DIALOG
   ON ACTION HELP
      LET g_action_choice="help"
      EXIT DIALOG

   ON ACTION locale
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   

   ON ACTION EXIT
      LET g_action_choice="exit"
      EXIT DIALOG

   ON ACTION controlg
      LET g_action_choice="controlg"
      EXIT DIALOG

   ON ACTION CANCEL
      LET INT_FLAG=FALSE
      LET g_action_choice="exit"
      EXIT DIALOG

   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE DIALOG
 
   ON ACTION about         
      CALL cl_about()      
 
   ON ACTION exporttoexcel
      LET g_action_choice = 'exporttoexcel'
      EXIT DIALOG

   ON ACTION related_document 
      LET g_action_choice="related_document"          
      EXIT DIALOG

   AFTER DIALOG
      CONTINUE DIALOG

   ON ACTION controls                    
      CALL cl_set_head_visible("","AUTO")
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q003_cs()
   DEFINE  l_cnt LIKE type_file.num5   
 
   CLEAR FORM #清除畫面
   CALL g_pmk.clear()
   CALL g_pmk_1.clear() 
   CALL g_pmk_2.clear()
   CALL g_pml.clear() 
   CALL g_pmm.clear()
   CALL g_pmn.clear() 
   CALL g_rva.clear()
   CALL g_rvb.clear() 
   CALL g_qcs.clear() 
   CALL g_qct.clear() 
   CALL g_rvu.clear() 
   CALL g_rvv.clear() 
   CALL g_rvu_y.clear() 
   CALL g_rvv_y.clear() 
   CALL g_rvu_c.clear() 
   CALL g_rvv_c.clear() 
   CALL g_apa.clear() 
   CALL g_apb.clear()     
   LET g_rec_b_pmk = 0 
   LET g_rec_b_pml = 0 
   LET g_rec_b_pmm = 0 
   LET g_rec_b_pmn = 0 
   LET g_rec_b_rva = 0 
   LET g_rec_b_rvb = 0 
   LET g_rec_b_qcs = 0 
   LET g_rec_b_qct = 0 
   LET g_rec_b_rvu = 0 
   LET g_rec_b_rvv = 0 
   LET g_rec_b_rvu_y=0 
   LET g_rec_b_rvv_y=0
   LET g_rec_b_rvu_c=0 
   LET g_rec_b_rvv_c=0
   LET g_rec_b_apa = 0 
   LET g_rec_b_apb = 0 
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL                   # Default condition 
   LET g_filter_wc = ''
   LET g_b_flag2 = ''
   LET tm.a = '6'   
   LET tm.b = 'Y'
   LET tm.c = 'Y'
   LET tm.d = 'Y'
   LET tm.h = '2'
   LET tm.g = '3'
   LET g_int_flag = '0'
   LET g_pmk01_change_pml = '0'
   LET g_pmk01_change_pmn = '0'
   LET g_pmk01_change_rvb = '0'
   LET g_pmk01_change_qct = '0'
   LET g_pmk01_change_rvv = '0'
   LET g_pmk01_change_rvv_y='0'
   LET g_pmk01_change_rvv_c='0'
   LET g_pmk01_change_apb = '0'

   LET g_pml02_change_pml = '0'
   LET g_pml02_change_pmn = '0'
   CALL cl_set_comp_visible("page2", FALSE)
   CALL cl_set_comp_visible("page3", FALSE)
   CALL ui.interface.refresh()
   CALL cl_set_comp_visible("page2", TRUE)
   CALL cl_set_comp_visible("page3", TRUE)

IF cl_null(g_pname) OR g_pname <> '3' THEN 
  IF g_pname='2' THEN 
   DIALOG ATTRIBUTE(UNBUFFERED)    
      INPUT BY NAME tm.a,tm.b,tm.c,tm.d,tm.h,tm.g ATTRIBUTE(WITHOUT DEFAULTS)
         BEFORE INPUT 
            CALL q003_set_visible()
         ON CHANGE a
            CALL q003_set_visible()
      END INPUT
 
      CONSTRUCT tm.wc2 ON pmm01,pmm02,pmm04,pmm12,pmm13,pmm09,pmm18,pml02,
                          pmn04,pmn041,pmn07,pmn20,pmn86,pmn87,
                          pmn31,pmn88,pmn88t,pmn50,pmn55,pmn53,pmnud07,
                          pmm21,pmm43,pmm22,pmm42,pmm99,
                          pmn35,pmn34,pmn33,pmn16,pmn24,pmn25,pmn122,pmn96
                   FROM s_pmk[1].pmk01,s_pmk[1].pmk02,s_pmk[1].pmk04,s_pmk[1].pmk12,s_pmk[1].pmk13, 
                        s_pmk[1].pmk09,s_pmk[1].pmk18,s_pmk[1].pml02,s_pmk[1].pml04,s_pmk[1].pml041,
                        s_pmk[1].pml07,s_pmk[1].pml20,s_pmk[1].pml86,s_pmk[1].pml21,
                        s_pmk[1].pmn31,s_pmk[1].pmn88,s_pmk[1].pmn88t,s_pmk[1].pmn50,s_pmk[1].pmn55,
                        s_pmk[1].pmn53,s_pmk[1].pmnud07,s_pmk[1].pmm21,s_pmk[1].pmm43,s_pmk[1].pmm22,s_pmk[1].pmm42,
                        s_pmk[1].pmm99,s_pmk[1].pml35,s_pmk[1].pml34,s_pmk[1].pml33,s_pmk[1].pml16,
                        s_pmk[1].pml24,s_pmk[1].pml25,s_pmk[1].pml12,s_pmk[1].pml121
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      END CONSTRUCT

       ON ACTION controlp
          CASE
             WHEN INFIELD(pmk01)
                  CALL cl_init_qry_var()
                  CASE g_pname
                     WHEN '2'
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_pmm01b"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO pmk01
                     OTHERWISE 
                        CALL q_pmk01a(TRUE,TRUE,'','') RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO pmk01
                  END CASE 
                  NEXT FIELD pmk01
 
             WHEN INFIELD(pmk12)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmk12
                  NEXT FIELD pmk12      
         
            WHEN INFIELD(pmk13)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gem"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmk13
                 NEXT FIELD pmk13 

            WHEN INFIELD(pmk09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_pmc"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmk09
                 NEXT FIELD pmk09 

            WHEN INFIELD(pml04)
                 CALL cl_init_qry_var() 
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_ima"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pml04
                 NEXT FIELD pml04
            WHEN INFIELD(pml07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pml07
                 NEXT FIELD pml07
            WHEN INFIELD(pml86)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pml86
                 NEXT FIELD pml86
            WHEN INFIELD(pmm21)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 IF g_aza.aza26 = '2' THEN      
                    LET g_qryparam.form ="q_gec9"
                 ELSE                           
                    LET g_qryparam.form ="q_gec"
                 END IF                        
                 LET g_qryparam.arg1 = '2'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmm21
                 NEXT FIELD pmm21

            WHEN INFIELD(pmm22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azi"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmm22
                 NEXT FIELD pmm22
          END CASE
       ON ACTION locale
          CALL cl_show_fld_cont()
          LET g_action_choice = "locale"
          EXIT DIALOG
       ON ACTION CONTROLZ
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG 

       ON ACTION about
          CALL cl_about()

       ON ACTION HELP
          CALL cl_show_help()

       ON ACTION EXIT
          LET INT_FLAG = 1
          EXIT DIALOG 

       ON ACTION qbe_save
          CALL cl_qbe_save()

       ON ACTION qbe_select
    	  CALL cl_qbe_select() 

       ON ACTION ACCEPT
          ACCEPT DIALOG 

       ON ACTION CANCEL
          LET INT_FLAG=1
          EXIT DIALOG    
   END DIALOG          
  ELSE 
   DIALOG ATTRIBUTE(UNBUFFERED)    
      INPUT BY NAME tm.a,tm.b,tm.c,tm.d,tm.h,tm.g ATTRIBUTE(WITHOUT DEFAULTS)
         BEFORE INPUT 
            CALL q003_set_visible()
         ON CHANGE a
            CALL q003_set_visible()
      END INPUT
 
      CONSTRUCT tm.wc2 ON pmk01,pmk02,pmk04,pmk12,pmk13,pmk09,pmk18,pml02,
                          pml04,pml041,pml07,pml20,pml86,pml87,pml21,pml35,
                          pml34,pml33,pml41,pml16,pml24,pml25,pml12,pml121
                   FROM s_pmk[1].pmk01,s_pmk[1].pmk02,s_pmk[1].pmk04,s_pmk[1].pmk12,s_pmk[1].pmk13, 
                        s_pmk[1].pmk09,s_pmk[1].pmk18,s_pmk[1].pml02,s_pmk[1].pml04,s_pmk[1].pml041,
                        s_pmk[1].pml07,s_pmk[1].pml20,s_pmk[1].pml86,s_pmk[1].pml87,s_pmk[1].pml21,
                        s_pmk[1].pml35,s_pmk[1].pml34,s_pmk[1].pml33,s_pmk[1].pml41,s_pmk[1].pml16,
                        s_pmk[1].pml24,s_pmk[1].pml25,s_pmk[1].pml12,s_pmk[1].pml121
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      END CONSTRUCT

       ON ACTION controlp
          CASE
             WHEN INFIELD(pmk01)
                  CALL cl_init_qry_var()
                  CASE g_pname
                     WHEN '2'
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_pmm01b"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO pmk01
                     OTHERWISE 
                        CALL q_pmk01a(TRUE,TRUE,'','') RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO pmk01
                  END CASE 
                  NEXT FIELD pmk01
 
             WHEN INFIELD(pmk12)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmk12
                  NEXT FIELD pmk12      
         
            WHEN INFIELD(pmk13)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gem"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmk13
                 NEXT FIELD pmk13 

            WHEN INFIELD(pmk09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_pmc"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmk09
                 NEXT FIELD pmk09 

            WHEN INFIELD(pml04)
                 CALL cl_init_qry_var() 
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_ima"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pml04
                 NEXT FIELD pml04
            WHEN INFIELD(pml07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pml07
                 NEXT FIELD pml07
            WHEN INFIELD(pml86)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pml86
                 NEXT FIELD pml86
            WHEN INFIELD(pmm21)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 IF g_aza.aza26 = '2' THEN      
                    LET g_qryparam.form ="q_gec9"
                 ELSE                           
                    LET g_qryparam.form ="q_gec"
                 END IF                        
                 LET g_qryparam.arg1 = '2'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmm21
                 NEXT FIELD pmm21

            WHEN INFIELD(pmm22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azi"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmm22
                 NEXT FIELD pmm22
          END CASE
       ON ACTION locale
          CALL cl_show_fld_cont()
          LET g_action_choice = "locale"
          EXIT DIALOG
       ON ACTION CONTROLZ
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG 

       ON ACTION about
          CALL cl_about()

       ON ACTION HELP
          CALL cl_show_help()

       ON ACTION EXIT
          LET INT_FLAG = 1
          EXIT DIALOG 

       ON ACTION qbe_save
          CALL cl_qbe_save()

       ON ACTION qbe_select
    	  CALL cl_qbe_select() 

       ON ACTION ACCEPT
          ACCEPT DIALOG 

       ON ACTION CANCEL
          LET INT_FLAG=1
          EXIT DIALOG    
   END DIALOG          
   
  END IF 

ELSE 
   DIALOG ATTRIBUTE(UNBUFFERED)    
      INPUT BY NAME tm.a,tm.b,tm.c,tm.d,tm.h,tm.g
         ATTRIBUTE(WITHOUT DEFAULTS)
         BEFORE INPUT 
            CALL q003_set_visible()
         ON CHANGE a
            CALL q003_set_visible()
      END INPUT
 
      CONSTRUCT tm.wc2 ON rva01,rva10,rva06,rva33,
                          rva05,rvaconf,rvb02,rvb05,
                          rvb051,rvb90,rvb07,rvb86,
                          rvb10,rvb88,rvb88t,rvb29,
                          rvb30,
                          #rva115,rva116,rva113,rva114,
                          rva99,rvb18,rvb04,
                          rvb03
                   FROM s_pmk[1].pmk01,s_pmk[1].pmk02,s_pmk[1].pmk04,s_pmk[1].pmk12, 
                        s_pmk[1].pmk09,s_pmk[1].pmk18,s_pmk[1].pml02,s_pmk[1].pml04,
                        s_pmk[1].pml041,s_pmk[1].pml07,s_pmk[1].pml20,s_pmk[1].pml86,
                        s_pmk[1].pmn31,s_pmk[1].pmn88,s_pmk[1].pmn88t,s_pmk[1].pmn55,
                        s_pmk[1].pmn53,
                        #s_pmk[1].pmm21,s_pmk[1].pmm43,s_pmk[1].pmm22,s_pmk[1].pmm42,
                        s_pmk[1].pmm99,s_pmk[1].pml16,s_pmk[1].pml24,
                        s_pmk[1].pml25
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      END CONSTRUCT

       ON ACTION controlp
          CASE
             WHEN INFIELD(pmk01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_rva" 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmk01
                  NEXT FIELD pmk01
 
             WHEN INFIELD(pmk12)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmk12
                  NEXT FIELD pmk12      

            WHEN INFIELD(pmk09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_pmc"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmk09
                 NEXT FIELD pmk09 

            WHEN INFIELD(pml04)
                 CALL cl_init_qry_var() 
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_ima"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pml04
                 NEXT FIELD pml04
            WHEN INFIELD(pml07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pml07
                 NEXT FIELD pml07
            WHEN INFIELD(pml86)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pml86
                 NEXT FIELD pml86
            WHEN INFIELD(pmm21)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 IF g_aza.aza26 = '2' THEN      
                    LET g_qryparam.form ="q_gec9"
                 ELSE                           
                    LET g_qryparam.form ="q_gec"
                 END IF                        
                 LET g_qryparam.arg1 = '2'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmm21
                 NEXT FIELD pmm21

            WHEN INFIELD(pmm22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azi"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmm22
                 NEXT FIELD pmm22
          END CASE
       ON ACTION locale
          CALL cl_show_fld_cont()
          LET g_action_choice = "locale"
          EXIT DIALOG
       ON ACTION CONTROLZ
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG 

       ON ACTION about
          CALL cl_about()

       ON ACTION HELP
          CALL cl_show_help()

       ON ACTION EXIT
          LET INT_FLAG = 1
          EXIT DIALOG 

       ON ACTION qbe_save
          CALL cl_qbe_save()

       ON ACTION qbe_select
    	  CALL cl_qbe_select() 

       ON ACTION ACCEPT
          ACCEPT DIALOG 

       ON ACTION CANCEL
          LET INT_FLAG=1
          EXIT DIALOG    
   END DIALOG          
END IF 
   IF INT_FLAG THEN 
      LET INT_FLAG = 0
      LET g_int_flag = '1'
      DELETE FROM cpmq003_tmp
      RETURN 
   END IF
   CALL q003()
         
END FUNCTION 

FUNCTION q003_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q003_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "SERCHING!"

    MESSAGE ""
    CALL q003_show()
END FUNCTION


FUNCTION q003_show()
   DISPLAY tm.a TO a
   CALL q003_b_fill()  
   CALL q003_b_fill_2()
   IF cl_null(tm.a)  THEN   
      LET g_action_choice = "page1" 
      CALL cl_set_comp_visible("page2", FALSE)
      CALL cl_set_comp_visible("page3", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page2", TRUE)
      CALL cl_set_comp_visible("page3", TRUE)
      LET g_action_flag = "page1"
   ELSE
      #IF g_int_flag = '0' THEN
         LET g_action_choice = "page2"
         CALL cl_set_comp_visible("page1", FALSE)
         CALL cl_set_comp_visible("page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page1", TRUE)
         CALL cl_set_comp_visible("page3", TRUE)
         LET g_action_flag = "page2"
      #ELSE
      #   LET g_action_choice = "page1"
      #   CALL cl_set_comp_visible("page2", FALSE)
      #   CALL cl_set_comp_visible("page3", FALSE)
      #   CALL ui.interface.refresh()
      #   CALL cl_set_comp_visible("page2", TRUE) 
      #   CALL cl_set_comp_visible("page3", TRUE) 
      #   LET g_action_flag = "page1"
      #END IF
   END IF

   CALL q003_set_visible()
   CALL cl_show_fld_cont()                   
END FUNCTION

FUNCTION q003_filter_askkey()
DEFINE l_wc   STRING
   CLEAR FORM
IF cl_null(g_pname) OR g_pname <> '3' THEN 
  IF g_pname='2' THEN 
     CONSTRUCT l_wc ON pmm01,pmm02,pmm04,pmm12,pmm13,pmm09,pmm18,pml02,
                       pmn04,pmn041,pmn07,pmn20,pmn86,pmn87,
                       pmn31,pmn88,pmn88t,pmn50,pmn55,pmn53,pmnud07,
                       pmm21,pmm43,pmm22,pmm42,pmm99,
                       pmn35,pmn34,pmn33,pmn16,pmn24,pmn25,pmn122,pmn96
                  FROM s_pmk[1].pmk01,s_pmk[1].pmk02,s_pmk[1].pmk04,s_pmk[1].pmk12,s_pmk[1].pmk13, 
                       s_pmk[1].pmk09,s_pmk[1].pmk18,s_pmk[1].pml02,s_pmk[1].pml04,s_pmk[1].pml041,
                       s_pmk[1].pml07,s_pmk[1].pml20,s_pmk[1].pml86,s_pmk[1].pml21,
                       s_pmk[1].pmn31,s_pmk[1].pmn88,s_pmk[1].pmn88t,s_pmk[1].pmn50,s_pmk[1].pmn55,
                       s_pmk[1].pmn53,s_pmk[1].pmnud07,s_pmk[1].pmm21,s_pmk[1].pmm43,s_pmk[1].pmm22,s_pmk[1].pmm42,
                       s_pmk[1].pmm99,s_pmk[1].pml35,s_pmk[1].pml34,s_pmk[1].pml33,s_pmk[1].pml16,
                       s_pmk[1].pml24,s_pmk[1].pml25,s_pmk[1].pml12,s_pmk[1].pml121
       BEFORE CONSTRUCT
          CALL cl_qbe_init()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT

       ON ACTION controlp
          CASE
             WHEN INFIELD(pmk01)
                  CALL cl_init_qry_var()
                  CASE g_pname
                     WHEN '2'
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_pmm01b"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO pmk01
                     OTHERWISE 
                        CALL q_pmk01a(TRUE,TRUE,'','') RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO pmk01
                  END CASE 
                  NEXT FIELD pmk01
 
             WHEN INFIELD(pmk12)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmk12
                  NEXT FIELD pmk12      
         
            WHEN INFIELD(pmk13)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gem"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmk13
                 NEXT FIELD pmk13 

            WHEN INFIELD(pmk09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_pmc"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmk09
                 NEXT FIELD pmk09 

            WHEN INFIELD(pml04)
                 CALL cl_init_qry_var() 
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_ima"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pml04
                 NEXT FIELD pml04
            WHEN INFIELD(pml07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pml07
                 NEXT FIELD pml07
            WHEN INFIELD(pml86)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pml86
                 NEXT FIELD pml86
            WHEN INFIELD(pmm21)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 IF g_aza.aza26 = '2' THEN      
                    LET g_qryparam.form ="q_gec9"
                 ELSE                           
                    LET g_qryparam.form ="q_gec"
                 END IF                        
                 LET g_qryparam.arg1 = '2'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmm21
                 NEXT FIELD pmm21

            WHEN INFIELD(pmm22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azi"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmm22
                 NEXT FIELD pmm22
           END CASE 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION HELP          
         CALL cl_show_help()   
 
      ON ACTION controlg      
         CALL cl_cmdask()    
		 
      ON ACTION qbe_select
    	 CALL cl_qbe_select() 
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT

  ELSE 
      CONSTRUCT l_wc ON pmk01,pmk02,pmk04,pmk12,pmk13,pmk09,pmk18,pml02,
                          pml04,pml041,pml07,pml20,pml86,pml87,pml21,pml35,
                          pml34,pml33,pml41,pml16,pml24,pml25,pml12,pml121
                   FROM s_pmk[1].pmk01,s_pmk[1].pmk02,s_pmk[1].pmk04,s_pmk[1].pmk12,s_pmk[1].pmk13, 
                        s_pmk[1].pmk09,s_pmk[1].pmk18,s_pmk[1].pml02,s_pmk[1].pml04,s_pmk[1].pml041,
                        s_pmk[1].pml07,s_pmk[1].pml20,s_pmk[1].pml86,s_pmk[1].pml87,s_pmk[1].pml21,
                        s_pmk[1].pml35,s_pmk[1].pml34,s_pmk[1].pml33,s_pmk[1].pml41,s_pmk[1].pml16,
                        s_pmk[1].pml24,s_pmk[1].pml25,s_pmk[1].pml12,s_pmk[1].pml121
                        
       BEFORE CONSTRUCT
          CALL cl_qbe_init()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT

       ON ACTION controlp
          CASE
             WHEN INFIELD(pmk01)
                  CALL cl_init_qry_var()
                  CASE g_pname
                     WHEN '2'
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_pmm01b"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO pmk01
                     OTHERWISE 
                        CALL q_pmk01a(TRUE,TRUE,'','') RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO pmk01
                  END CASE 
                  NEXT FIELD pmk01
 
             WHEN INFIELD(pmk12)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmk12
                  NEXT FIELD pmk12      
         
            WHEN INFIELD(pmk13)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gem"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmk13
                 NEXT FIELD pmk13 

            WHEN INFIELD(pmk09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_pmc"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmk09
                 NEXT FIELD pmk09 

            WHEN INFIELD(pml04)
                 CALL cl_init_qry_var() 
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_ima"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pml04
                 NEXT FIELD pml04
            WHEN INFIELD(pml07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pml07
                 NEXT FIELD pml07
            WHEN INFIELD(pml86)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pml86
                 NEXT FIELD pml86
            WHEN INFIELD(pmm21)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 IF g_aza.aza26 = '2' THEN      
                    LET g_qryparam.form ="q_gec9"
                 ELSE                           
                    LET g_qryparam.form ="q_gec"
                 END IF                        
                 LET g_qryparam.arg1 = '2'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmm21
                 NEXT FIELD pmm21

            WHEN INFIELD(pmm22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azi"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmm22
                 NEXT FIELD pmm22
           END CASE 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION HELP          
         CALL cl_show_help()   
 
      ON ACTION controlg      
         CALL cl_cmdask()    
		 
      ON ACTION qbe_select
    	 CALL cl_qbe_select() 
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
  END IF 
ELSE 
   CONSTRUCT l_wc   ON rva01,rva10,rva06,rva33,
                       rva05,rvaconf,rvb02,rvb05,
                       rvb051,rvb90,rvb07,rvb86,
                       rvb10,rvb88,rvb88t,rvb29,
                       rvb30,
                       #rva115,rva116,rva113,rva114,
                       rva99,rvb18,rvb04,
                       rvb03
                FROM s_pmk[1].pmk01,s_pmk[1].pmk02,s_pmk[1].pmk04,s_pmk[1].pmk12, 
                     s_pmk[1].pmk09,s_pmk[1].pmk18,s_pmk[1].pml02,s_pmk[1].pml04,
                     s_pmk[1].pml041,s_pmk[1].pml07,s_pmk[1].pml20,s_pmk[1].pml86,
                     s_pmk[1].pmn31,s_pmk[1].pmn88,s_pmk[1].pmn88t,s_pmk[1].pmn55,
                     s_pmk[1].pmn53, 
                     #s_pmk[1].pmm21,s_pmk[1].pmm43,s_pmk[1].pmm22,s_pmk[1].pmm42,
                     s_pmk[1].pmm99,s_pmk[1].pml16,s_pmk[1].pml24,
                     s_pmk[1].pml25
       BEFORE CONSTRUCT
          CALL cl_qbe_init()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT

       ON ACTION controlp
          CASE
             WHEN INFIELD(pmk01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_rva" 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmk01
                  NEXT FIELD pmk01
 
             WHEN INFIELD(pmk12)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmk12
                  NEXT FIELD pmk12      
         
            WHEN INFIELD(pmk13)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gem"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmk13
                 NEXT FIELD pmk13 

            WHEN INFIELD(pmk09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_pmc"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmk09
                 NEXT FIELD pmk09 
                 
            WHEN INFIELD(pml04)
                 CALL cl_init_qry_var() 
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_ima"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pml04
                 NEXT FIELD pml04
            WHEN INFIELD(pml07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pml07
                 NEXT FIELD pml07
            WHEN INFIELD(pml86)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pml86
                 NEXT FIELD pml86
            WHEN INFIELD(pmm21)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 IF g_aza.aza26 = '2' THEN      
                    LET g_qryparam.form ="q_gec9"
                 ELSE                           
                    LET g_qryparam.form ="q_gec"
                 END IF                        
                 LET g_qryparam.arg1 = '2'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmm21
                 NEXT FIELD pmm21

            WHEN INFIELD(pmm22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azi"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmm22
                 NEXT FIELD pmm22
           END CASE 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION HELP          
         CALL cl_show_help()   
 
      ON ACTION controlg      
         CALL cl_cmdask()    
		 
      ON ACTION qbe_select
    	 CALL cl_qbe_select() 
      ON ACTION qbe_save
         CALL cl_qbe_save()
	 
   END CONSTRUCT
                        
END IF 
   IF INT_FLAG THEN 
      LET g_filter_wc = ''
      CALL cl_set_act_visible("revert_filter",FALSE)
      LET INT_FLAG = 0
      RETURN 
   END IF
   IF l_wc !=" 1=1" THEN
      CALL cl_set_act_visible("revert_filter",TRUE)
   END IF
  
   IF cl_null(g_filter_wc) THEN LET g_filter_wc = " 1=1" END IF
   LET g_filter_wc = g_filter_wc CLIPPED," AND ",l_wc CLIPPED
END FUNCTION

FUNCTION q003_table()
   DEFINE l_sql  STRING
   LET l_sql = 
   "CREATE TEMP TABLE cpmq003_tmp( ",
             "   speed     LIKE type_file.chr1, ",
             "   state     LIKE type_file.chr1, ",
             "   pmk01     LIKE pmk_file.pmk01, ",
             "   pmk02     LIKE pmk_file.pmk02, ",
             "   pmk04     LIKE pmk_file.pmk04, ",
             "   pmk12     LIKE pmk_file.pmk12, ",
             "   gen02     LIKE gen_file.gen02, ",
             "   pmk13     LIKE pmk_file.pmk13, ",
             "   gem02     LIKE gem_file.gem02, ",
             "   pmk09     LIKE pmk_file.pmk09, ",
             "   pmc03     LIKE pmc_file.pmc03, ",
             "   pmk18     LIKE pmk_file.pmk18, ",
             "   pml02     LIKE pml_file.pml02, ",
             "   pml04     LIKE pml_file.pml04, ",
             "   pml041    LIKE pml_file.pml041, ",
             "   ima021    LIKE ima_file.ima021, ",
             "   pml07     LIKE pml_file.pml07, ",
             "   pml20     LIKE pml_file.pml20, ",
             "   pml86     LIKE pml_file.pml86, ",
             "   pml87     LIKE pml_file.pml87, ",
             "   pml21     LIKE pml_file.pml21, ",
             "   pmn31     LIKE pmn_file.pmn31, ",
             "   pmn31t    LIKE pmn_file.pmn31, ",   
             "   pmn88     LIKE pmn_file.pmn88, ",
             "   pmn88t    LIKE pmn_file.pmn88t, ",
             "   pmn50     LIKE pmn_file.pmn50, ",
             "   pmn55     LIKE pmn_file.pmn55, ",
             "   pmn50a    LIKE pmn_file.pmn50, ",
             "   pmn53     LIKE pmn_file.pmn53, ",
             "   pmnud07   LIKE pmn_file.pmnud07, ",
             "   rvv39     LIKE rvv_file.rvv39, ",
             "   rvv39t    LIKE rvv_file.rvv39t, ",
             "   rvv17     LIKE rvv_file.rvv17, ",
             "   apb09     LIKE apb_file.apb09, ",
             "   apb24     LIKE apb_file.apb24, ",
             "   pmm21     LIKE pmm_file.pmm21, ",
             "   pmm43     LIKE pmm_file.pmm43, ",
             "   gec07     LIKE gec_file.gec07, ",
             "   pmm22     LIKE pmm_file.pmm22, ",
             "   pmm42     LIKE pmm_file.pmm42, ",
             "   pmm99     LIKE pmm_file.pmm99, ",
             "   pml35     LIKE pml_file.pml35, ",
             "   pml34     LIKE pml_file.pml34, ",
             "   pml33     LIKE pml_file.pml33, ",
             "   pml41     LIKE pml_file.pml41, ",
             "   pml16     LIKE rvb_file.rvb18, ",
             "   pml24     LIKE pml_file.pml24, ",
             "   pml25     LIKE pml_file.pml25, ",
             "   pml12     LIKE pml_file.pml12, ",
             "   pja02     LIKE pja_file.pja02, ",
             "   pml121    LIKE pml_file.pml121, ",
             "   pjb03     LIKE pjb_file.pjb03, ",
             "   pml06     varchar(255)         ", #darcy:2022/11/04 add
             " ) "
             #str---add pmn31t by huanglf160806

   PREPARE q003_tab FROM l_sql
   EXECUTE q003_tab

   LET l_sql = 
   "CREATE TEMP TABLE cpmq003_tmp1( ",
             "   speed     LIKE type_file.chr1, ",
             "   state     LIKE type_file.chr1, ",
             "   pmk01     LIKE pmk_file.pmk01, ",
             "   pmk02     LIKE pmk_file.pmk02, ",
             "   pmk04     LIKE pmk_file.pmk04, ",
             "   pmk12     LIKE pmk_file.pmk12, ",
             "   gen02     LIKE gen_file.gen02, ",
             "   pmk13     LIKE pmk_file.pmk13, ",
             "   gem02     LIKE gem_file.gem02, ",
             "   pmk09     LIKE pmk_file.pmk09, ",
             "   pmc03     LIKE pmc_file.pmc03, ",
             "   pmk18     LIKE pmk_file.pmk18, ",
             "   pml02     LIKE pml_file.pml02, ",
             "   pml04     LIKE pml_file.pml04, ",
             "   pml041    LIKE pml_file.pml041, ",
             "   ima021    LIKE ima_file.ima021, ",
             "   pml07     LIKE pml_file.pml07, ",
             "   pml20     LIKE pml_file.pml20, ",
             "   pml86     LIKE pml_file.pml86, ",
             "   pml87     LIKE pml_file.pml87, ",
             "   pml21     LIKE pml_file.pml21, ",
             "   pmn31     LIKE pmn_file.pmn31, ",
             "   pmn31t    LIKE pmn_file.pmn31, ",
             "   pmn88     LIKE pmn_file.pmn88, ",
             "   pmn88t    LIKE pmn_file.pmn88t, ",
             "   pmn50     LIKE pmn_file.pmn50, ",
             "   pmn55     LIKE pmn_file.pmn55, ",
             "   pmn50a    LIKE pmn_file.pmn50, ",
             "   pmn53     LIKE pmn_file.pmn53, ",
             "   pmnud07     LIKE pmn_file.pmnud07, ",
             "   rvv39     LIKE rvv_file.rvv39, ",
             "   rvv39t    LIKE rvv_file.rvv39t, ",
             "   rvv17     LIKE rvv_file.rvv17, ",
             "   apb09     LIKE apb_file.apb09, ",
             "   apb24     LIKE apb_file.apb24, ",
             "   pmm21     LIKE pmm_file.pmm21, ",
             "   pmm43     LIKE pmm_file.pmm43, ",
             "   gec07     LIKE gec_file.gec07, ",
             "   pmm22     LIKE pmm_file.pmm22, ",
             "   pmm42     LIKE pmm_file.pmm42, ",
             "   pmm99     LIKE pmm_file.pmm99, ",
             "   pml35     LIKE pml_file.pml35, ",
             "   pml34     LIKE pml_file.pml34, ",
             "   pml33     LIKE pml_file.pml33, ",
             "   pml41     LIKE pml_file.pml41, ",
             "   pml16     LIKE rvb_file.rvb18, ",
             "   pml24     LIKE pml_file.pml24, ",
             "   pml25     LIKE pml_file.pml25, ",
             "   pml12     LIKE pml_file.pml12, ",
             "   pja02     LIKE pja_file.pja02, ",
             "   pml121    LIKE pml_file.pml121, ",
             "   pjb03     LIKE pjb_file.pjb03, ",
             "   pml06     varchar(255)         ", #darcy:2022/11/04 add
             " ) "
             #str---add pmn31t by huanglf160806

   PREPARE q003_tab1 FROM l_sql
   EXECUTE q003_tab1

END FUNCTION 

FUNCTION q003()
   DEFINE l_name      LIKE type_file.chr20,           
          l_sql       STRING,                
          l_chr       LIKE type_file.chr1,          
          l_i         LIKE type_file.num5,                    
          l_cnt       LIKE type_file.num5              
   DEFINE l_wc,l_msg,l_wc1 STRING 
   DEFINE l_num    LIKE type_file.num5
   DEFINE l_apb09  LIKE apb_file.apb09
   DEFINE l_apb24  LIKE apb_file.apb24
   DEFINE l_day    LIKE type_file.dat
   DEFINE l_wc_sfb         STRING 
   DEFINE l_wc_tmp         STRING 
   DEFINE l_wc_tmp_1       STRING 
   DEFINE l_filter_wc      STRING 
   DEFINE g_filter_wc_sfb  STRING 
   DEFINE l_n      LIKE type_file.num5
                  
   LET tm.wc2 = tm.wc2 CLIPPED,cl_get_extra_cond('pmkuser', 'pmkgrup')
   DELETE FROM cpmq003_tmp
   DELETE FROM cpmq003_tmp1

   LET l_wc = ''
   IF cl_null(tm.wc2) THEN LET tm.wc2=" 1=1" END IF 
   IF cl_null(g_filter_wc) THEN LET g_filter_wc=" 1=1" END IF 
   IF tm.b ='N' AND tm.c = 'N' AND tm.d = 'N' THEN
      CALL g_pmk.clear()
      CALL g_pmk_2.clear()
      LET l_wc1 =' 1=2' 
   ELSE 
      LET l_wc1 =' 1=1'
   END IF 
   CASE g_pname 
      WHEN '2'
         #speed,state,pmm01,pmm02,pmm04,pmm12,gen02,pmm13,gem02,pmm09,
         #pmc03,pmm18,pmn02,pmn04,pmn041,ima021,pmn07,pmn20,pmn86,'',
         #pmn87,pmn31,pmn88,pmn88t,pmn50,pmn55,pmn50a,pmn53,rvv39,
         #rvv39t,rvv17,apb09,apb24,pmm21,pmm43,gec07,pmm22,pmm42,pmm99,
         #pmn35,pmn34,pmn33,''   ,pmn16,pmn24,pmn25,pmn122,pmn96

         #speed,state,pmk01,pmk02,pmk04,pmk12,gen02,pmk13,gem02,pmk09,
         #pmc03,pmk18,pml02,pml04,pml041,ima021,pml07,pml20,pml86,pml87,
         #pml21,pmn31,pmn88,pmn88t,pmn50,pmn55,pmn50a,pmn53,rvv39,
         #rvv39t,rvv17,apb09,apb24,pmm21,pmm43,gec07,pmm22,pmm42,pmm99,
         #pml35,pml34,pml33,pml41,pml16,pml24,pml25,pml12,pml121  #str--add by huanglf160806
         LET l_sql ="SELECT '' speed,'' state,pmm01 pmk01,pmm02 pmk02,pmm04 pmk04,trim(nvl(pmm12,'')) pmk12,gen02,trim(nvl(pmm13,'')) pmk13,gem02,trim(nvl(pmm09,'')) pmk09,", 
                          " pmc03,pmm18 pmk18,pmn02 pml02,pmn04 pml04,pmn041 pml041,ima021,pmn07 pml07,nvl(pmn20,0) pml20,pmn86 pml86,0 pml87,",
                          " nvl(pmn87,0) pml21,nvl(pmn31,0) pmn31,pmn31t,nvl(pmn88,0) pmn88,nvl(pmn88t,0) pmn88t,nvl(pmn50,0) pmn50,nvl(pmn55,0) pmn55,nvl(pmn20-(pmn50-pmn55-pmn58),0) pmn50a,nvl(pmn53-pmn58,0) pmn53,pmnud07,0 rvv39,", #mod pmn53->pmn53-pmn58 by liy210615  #谢宇彬要求退货换货未收货入库的要去掉
                          " 0 rvv39t,0 rvv17,0 apb09,0 apb24,pmm21,pmm43,gec07,pmm22,pmm42,pmm99,",
                          " pmn35 pml35,pmn34 pml34,pmn33 pml33,'' pml41,pmn16 pml16,pmn24 pml24,pmn25 pml25,trim(nvl(pmn122,'')) pml12,pja02,trim(nvl(pmn96,'')) pml121,pjb03 ",  #TQC-CC0141
                          " ,pmnud01 pml06 ", #darcy:2022/11/04 add
                    "  FROM pmm_file LEFT OUTER JOIN gen_file ON pmm12=gen01 ", 
                    "                LEFT OUTER JOIN gem_file ON pmm13=gem01 ",
                    "                LEFT OUTER JOIN pmc_file ON pmm09=pmc01 ",
                    "                LEFT OUTER JOIN gec_file ON pmm21=gec01,", 
                    "       pmn_file LEFT OUTER JOIN ima_file ON pmn04=ima01 ",
                    "                LEFT OUTER JOIN pja_file ON pmn122=pja01 ",
                    "                LEFT OUTER JOIN pjb_file ON pmn122=pjb01 AND pmn96=pjb02 ",
                    " WHERE pmm01=pmn01 AND ",l_wc1,
                    "   AND ",tm.wc2 CLIPPED," AND ",g_filter_wc CLIPPED,
                    " AND ("
         IF tm.b = 'Y' THEN 
            LET l_wc = " nvl(pmn87,0) < nvl(pmn53,0)" 
         END IF
         IF tm.c = 'Y' THEN 
            IF tm.b = 'Y' THEN 
               LET l_wc = l_wc," OR nvl(pmn87,0) = nvl(pmn53,0)"
            ELSE
               LET l_wc = l_wc," nvl(pmn87,0) = nvl(pmn53,0)"
            END IF 
         END IF
         IF tm.d = 'Y' THEN 
            IF tm.b = 'Y' OR tm.c = 'Y' THEN
               LET l_wc = l_wc," OR nvl(pmn87,0) > nvl(pmn53,0)" 
            END IF
            IF tm.b = 'N' AND tm.c = 'N' THEN
               LET l_wc = l_wc," nvl(pmn87,0) > nvl(pmn53,0)"
            END IF
         END IF
         IF cl_null(l_wc) THEN LET l_wc=' 1=1' END IF 
         LET l_sql = l_sql,l_wc,")"
      WHEN '3'
         #speed,state,rva01,rva10,rva06,rva33,gen02,'','',rva05,
         #pmc03,rvaconf,rvb02,rvb05,ima02,ima021,rvb90,rvb07,rvb86,'',
         #'','','','','','','',rvb30,rvv39,
         #rvv39t,rvv17,apb09,apb24,rva115,rva116,gec07,rva113,rva114,rva99,
         #'','','','',rvb18,rvb04,rvb03,'',''

         #speed,state,pmk01,pmk02,pmk04,pmk12,gen02,pmk13,gem02,pmk09,
         #pmc03,pmk18,pml02,pml04,pml041,ima021,pml07,pml20,pml86,pml87,
         #pml21,pmn31,pmn88,pmn88t,pmn50,pmn55,pmn50a,pmn53,rvv39,
         #rvv39t,rvv17,apb09,apb24,pmm21,pmm43,gec07,pmm22,pmm42,pmm99,
         #pml35,pml34,pml33,pml41,pml16,pml24,pml25,pml12,pml121

                          
         LET l_sql ="SELECT '' speed,'' state,rva01 pmk01,rva10 pmk02,rva06 pmk04,trim(nvl(pmm12,'')) pmk12,gen02,'' pmk13,'' gem02,trim(nvl(rva05,'')) pmk09,", 
                          " pmc03,rvaconf pmk18,rvb02 pml02,rvb05 pml04,rvb051 pml041,ima021,rvb90 pml07,nvl(rvb07,0) pml20,rvb86 pml86,0 pml87,",
                          " nvl(pmn87,0) pml21,nvl(rvb10,0) pmn31,pmn31t,nvl(rvb88,0) pmn88,nvl(rvb88t,0) pmn88t,nvl(pmn50,0) pmn50,nvl(rvb29,0) pmn55,nvl(rvb07-rvb30,0) pmn50a,nvl(rvb30,0) pmn53, pmnud07,0 rvv39,",
                          " 0 rvv39t,0 rvv17,0 apb09,0 apb24,pmm21,pmm43,gec07,pmm22,pmm42,rva99 pmm99,",
                          " pmn35 pml35,pmn34 pml34,pmn33 pml33,'' pml41,rvb18 pml16,rvb04 pml24,rvb03 pml25,'' pml12,'' pja02,'' pml121,'' pjb03 ",
                          " ,pmnud01 pml06 ", #darcy:2022/11/04 add
                    "  FROM rva_file LEFT OUTER JOIN pmc_file ON rva05=pmc01,",
                    "       rvb_file LEFT OUTER JOIN ima_file ON rvb05=ima01 ",
                    "                LEFT OUTER JOIN pmn_file ON rvb04=pmn01 AND rvb03=pmn02 ",
                    "                LEFT OUTER JOIN pmm_file ON pmn01=pmm01 ",
                    "                LEFT OUTER JOIN gen_file ON pmm12=gen01 ",
                    "                LEFT OUTER JOIN gec_file ON pmm21=gec01 ", 
                    " WHERE rva01=rvb01 AND ",l_wc1,
                    "   AND ",tm.wc2 CLIPPED," AND ",g_filter_wc CLIPPED,
                    " AND ("
         IF tm.b = 'Y' THEN 
            LET l_wc = " rvb07 < rvb30" 
         END IF
         IF tm.c = 'Y' THEN 
            IF tm.b = 'Y' THEN 
               LET l_wc = l_wc," OR rvb07 = rvb30"
            ELSE
               LET l_wc = l_wc," rvb07 = rvb30"
            END IF 
         END IF
         IF tm.d = 'Y' THEN 
            IF tm.b = 'Y' OR tm.c = 'Y' THEN
               LET l_wc = l_wc," OR rvb07 > rvb30" 
            END IF
            IF tm.b = 'N' AND tm.c = 'N' THEN
               LET l_wc = l_wc," rvb07 > rvb30"
            END IF
         END IF
         IF cl_null(l_wc) THEN LET l_wc=' 1=1' END IF 
         LET l_sql = l_sql,l_wc,")"
      OTHERWISE    
         #speed,state,pmk01,pmk02,pmk04,pmk12,gen02,pmk13,gem02,pmk09,
         #pmc03,pmk18,pml02,pml04,pml041,ima021,pml07,pml20,pml86,pml87,
         #pml21,pmn31,pmn88,pmn88t,pmn50,pmn55,pmn50a,pmn53,rvv39,
         #rvv39t,rvv17,apb09,apb24,pmm21,pmm43,gec07,pmm22,pmm42,pmm99,
         #pml35,pml34,pml33,pml41,pml16,pml24,pml25,pml12,pml121
         IF cl_null(l_wc) THEN LET l_wc =' 1=1' END IF 
         LET l_sql ="SELECT '' speed,'' state,pmk01,pmk02,pmk04,trim(nvl(pmk12,'')) pmk12,gen02,trim(nvl(pmk13,'')) pmk13,gem02,trim(nvl(pmk09,'')) pmk09,", 
                          " pmc03,pmk18,pml02,pml04,pml041,ima021,pml07,nvl(pml20,0) pml20,pml86,nvl(pml87,0) pml87,",
                          " nvl(pml21,0) pml21,nvl(pmn31,0) pmn31,nvl(pmn31t,0) pmn31t,nvl(pmn88,0) pmn88,nvl(pmn88t,0) pmn88t,nvl(pmn50,0) pmn50,nvl(pmn55,0) pmn55,nvl(pmn20-(pmn50-pmn55-pmn58),0) pmn50a,nvl(pmn53,0) pmn53,pmnud07,0 rvv39,",
                          " 0 rvv39t,0 rvv17,0 apb09,0 apb24,pmm21,pmm43,gec07,pmm22,pmm42,pmm99,",
                          " pml35,pml34,pml33,pml41,pml16,pml24,pml25,trim(nvl(pml12,'')) pml12,pja02,trim(nvl(pml121,'')) pml121,pjb03 ",  #TQC-CC0141
                          " ,pml06 ", #darcy:2022/11/04 add
                    "  FROM pmk_file LEFT OUTER JOIN gen_file ON pmk12=gen01 ", 
                    "                LEFT OUTER JOIN gem_file ON pmk13=gem01 ",
                    "                LEFT OUTER JOIN pmc_file ON pmk09=pmc01,", 
                    "       pml_file LEFT OUTER JOIN ima_file ON pml04=ima01 ",
                    "                LEFT OUTER JOIN pmn_file ON pml01=pmn24 AND pml02=pmn25 ",
                    "                LEFT OUTER JOIN pmm_file ON pmm01=pmn01 ",
                    "                LEFT OUTER JOIN gec_file ON pmm21=gec01 ",
                    "                LEFT OUTER JOIN pja_file ON pml12=pja01 ",
                    "                LEFT OUTER JOIN pjb_file ON pml12=pjb01 AND pml121=pjb02 ",
                    " WHERE pmk01=pml01 AND ",l_wc1,
                    "   AND ",tm.wc2 CLIPPED," AND ",g_filter_wc CLIPPED

         IF tm.b = 'Y' THEN 
            LET l_wc = " nvl(pml20,0) < nvl(pmn53,0)" 
         END IF
         IF tm.c = 'Y' THEN 
            IF tm.b = 'Y' THEN 
               LET l_wc = l_wc," OR nvl(pml20,0) = nvl(pmn53,0)"
            ELSE
               LET l_wc = l_wc," nvl(pml20,0) = nvl(pmn53,0)"
            END IF 
         END IF
         IF tm.d = 'Y' THEN 
            IF tm.b = 'Y' OR tm.c = 'Y' THEN
               LET l_wc = l_wc," OR nvl(pml20,0) > nvl(pmn53,0)" 
            END IF
            IF tm.b = 'N' AND tm.c = 'N' THEN
               LET l_wc = l_wc," nvl(pml20,0) > nvl(pmn53,0)"
            END IF
         END IF
         IF cl_null(l_wc) THEN LET l_wc=' 1=1' END IF 
   END CASE 


   LET l_sql = " INSERT INTO cpmq003_tmp ",l_sql CLIPPED
   PREPARE q003_ins FROM l_sql
   EXECUTE q003_ins

   CASE g_pname
      WHEN '2'
         #rvv39,39t
         LET l_sql = 
             " MERGE INTO cpmq003_tmp o ",
             "      USING (SELECT rvv36,rvv37,SUM(rvv39) rvv39_sum,SUM(rvv39t) rvv39t_sum ",
             "               FROM rvv_file,rvu_file ", 
             "              WHERE rvu01=rvv01 AND rvuconf='Y' AND rvu00='1'  ",
             "              GROUP BY rvv36,rvv37 ) n ",
             "         ON (o.pmk01 = n.rvv36 AND o.pml02 = n.rvv37 ) ", #pmn01/pmn02
             " WHEN MATCHED ",
             " THEN ",
             "    UPDATE ",
             "       SET o.rvv39 = NVL(n.rvv39_sum,0) ,",
             "           o.rvv39t =NVL(n.rvv39t_sum,0)  "
         PREPARE q775_pre1 FROM l_sql
         EXECUTE q775_pre1

         #rvv17
         LET l_sql = 
             " MERGE INTO cpmq003_tmp o ",
             "      USING (SELECT rvv36,rvv37,SUM(rvv17) rvv17_sum ",
             "               FROM rvv_file,rvu_file ", 
             "              WHERE rvu01=rvv01 AND rvuconf='Y' AND rvu00='3' ",
             "              GROUP BY rvv36,rvv37 ) n ",
             "         ON (o.pmk01 = n.rvv36 AND o.pml02 = n.rvv37 ) ", #pmn01/pmn02
             " WHEN MATCHED ",
             " THEN ",
             "    UPDATE ",
             "       SET o.rvv17 = NVL(n.rvv17_sum,0) "
         PREPARE q775_pre2 FROM l_sql
         EXECUTE q775_pre2

         #apb09
         LET l_sql = 
             " MERGE INTO cpmq003_tmp o ",
             "      USING (SELECT apb06,apb07,SUM(apb09) apb09_sum,SUM(apb24) apb24_sum ",
             "               FROM apb_file,apa_file ", 
             "              WHERE apa01=apb01 AND apa41='Y' AND apa00='11' ",
             "           GROUP BY apb06,apb07 ) n ",
             "         ON (o.pmk01 = n.apb06 AND o.pml02 = n.apb07 ) ", #pmn01/pmn02
             " WHEN MATCHED ",
             " THEN ",
             "    UPDATE ",
             "       SET o.apb09 = NVL(n.apb09_sum,0),",
             "           o.apb24 = NVL(n.apb24_sum,0)"
         PREPARE q775_pre3 FROM l_sql
         EXECUTE q775_pre3

         LET l_sql = 
             " MERGE INTO cpmq003_tmp o ",
             "      USING (SELECT apb06,apb07,SUM(apb09) apb09_sum,SUM(apb24) apb24_sum ",
             "               FROM apb_file,apa_file ", 
             "              WHERE apa01=apb01 AND apa41='Y' AND apa00='21' ",
             "           GROUP BY apb06,apb07 ) n ",
             "         ON (o.pmk01 = n.apb06 AND o.pml02 = n.apb07 ) ", #pmn01/pmn02
             " WHEN MATCHED ",
             " THEN ",
             "    UPDATE ",
             "       SET o.apb09 =o.apb09-NVL(n.apb09_sum,0),",
             "           o.apb24 =o.apb24-NVL(n.apb24_sum,0)"
         PREPARE q775_pre4 FROM l_sql
         EXECUTE q775_pre4
          
         #state
         #已完成:入库数量>=采购数量或pml16='678'
         LET l_sql = 
             " UPDATE cpmq003_tmp  ",
             "    SET state='2' ",
             "  WHERE pml21<=pmn53 OR pml16 IN ('6','7','8') "  
         PREPARE q775_pre5 FROM l_sql
         EXECUTE q775_pre5

         LET l_sql = 
             " UPDATE cpmq003_tmp  ",
             "    SET state='0' ",
             "  WHERE pml21>pmn53 AND pml16 NOT IN ('2','6','7','8') " 
         PREPARE q775_pre6 FROM l_sql
         EXECUTE q775_pre6

         LET l_sql = 
             " UPDATE cpmq003_tmp  ",
             "    SET state='1' ",
             "  WHERE pml21>pmn53 AND pml16 IN ('2') "
         PREPARE q775_pre7 FROM l_sql
         EXECUTE q775_pre7

         #speed
         LET l_sql = 
             " UPDATE cpmq003_tmp  ",
             "    SET  speed = '3' "
         PREPARE q775_pre8 FROM l_sql
         EXECUTE q775_pre8
         
         LET l_sql = 
             " UPDATE cpmq003_tmp  ",
             "    SET  speed = '0' ",
             "  WHERE state<>'2' AND pml35>= '",g_today ,"' "
         PREPARE q775_pre9 FROM l_sql
         EXECUTE q775_pre9

         LET l_sql = 
             " UPDATE cpmq003_tmp  ",
             "    SET  speed = '1' ",
             "  WHERE state<>'2' AND  pml35< '",g_today ,"' "  #TQC-CC0141 
         PREPARE q775_pre10 FROM l_sql
         EXECUTE q775_pre10

         LET l_sql = 
             " MERGE INTO cpmq003_tmp o ",
             "      USING (SELECT rvv36,rvv37,MAX(rvv09) rvv09_max FROM rvv_file,rvu_file ",
             "              WHERE rvu01=rvv01 AND rvuconf='Y' AND rvu00='1' ",
             "              GROUP BY rvv36,rvv37 ) n ",
             "         ON (o.pmk01 = n.rvv36 AND o.pml02 = n.rvv37 ) ", #pmn01/pmn02
             " WHEN MATCHED ",
             " THEN ",
             "    UPDATE ",
             "       SET o.speed = '0' ",
             "     WHERE o.pml35>=n.rvv09_max  ",
             "       AND o.speed = '3' "
             
         PREPARE q775_pre11 FROM l_sql
         EXECUTE q775_pre11

         LET l_sql = 
             " UPDATE cpmq003_tmp  ",
             "    SET speed = '1' ",
             "  WHERE speed = '3' "
         PREPARE q775_pre12 FROM l_sql
         EXECUTE q775_pre12         

         IF tm.b = 'N' THEN
            LET l_sql =
                " DELETE FROM cpmq003_tmp  ",
                "  WHERE nvl(pml21,0)<nvl(pmn53,0) "
            PREPARE q775_del01 FROM l_sql
            EXECUTE q775_del01
         END IF
         IF tm.c = 'N' THEN 
            LET l_sql =
                " DELETE FROM cpmq003_tmp  ",
                "  WHERE nvl(pml21,0)=nvl(pmn53,0) "
            PREPARE q775_del02 FROM l_sql
            EXECUTE q775_del02 
         END IF
         IF tm.d = 'N' THEN 
            LET l_sql =
                " DELETE FROM cpmq003_tmp  ",
                "  WHERE nvl(pml21,0)>nvl(pmn53,0) "
            PREPARE q775_del03 FROM l_sql
            EXECUTE q775_del03 
         END IF
            
      WHEN '3'
         #rva115,rva116,gec07,rva113,rva114
         LET l_sql = 
             " MERGE INTO cpmq003_tmp o ",
             "      USING (SELECT rva01,rva115,rva116,gec07,rva113,rva114 ",
             "       FROM rva_file LEFT OUTER JOIN gec_file ON gec01=rva115 ) n ",
             "         ON (o.pmk01 = n.rva01 ) ", 
             " WHEN MATCHED ",
             " THEN ",
             "    UPDATE ",
             "       SET o.pmm21 = n.rva115 ,",
             "           o.pmm43 = n.rva116 ,",
             "           o.gec07  = n.gec07  ,",  
             "           o.pmm22 = n.rva113 ,",
             "           o.pmm42 = n.rva114  ",
             "     WHERE 1<=(SELECT COUNT(x.rva01) FROM rva_file x  ",
             "                WHERE x.rva00='2' AND x.rva01=o.pmk01)"
         PREPARE q775_pre13 FROM l_sql
         EXECUTE q775_pre13

         #rvv39,39t
         LET l_sql = 
             " MERGE INTO cpmq003_tmp o ",
             "      USING (SELECT  rvv04,rvv05,SUM(rvv39) rvv39_sum,SUM(rvv39t) rvv39t_sum ",
             "               FROM rvv_file,rvu_file ", 
             "              WHERE rvu01=rvv01 AND rvuconf='Y' AND rvu00='1' ",
             "           GROUP BY rvv04,rvv05 ) n ",
             "         ON (o.pmk01 = n.rvv04 AND o.pml02 = n.rvv05 ) ",  #rvb01/rvb02
             " WHEN MATCHED ",
             " THEN ",
             "    UPDATE ",
             "       SET o.rvv39 =NVL(n.rvv39_sum,0),",
             "           o.rvv39t=NVL(n.rvv39t_sum,0)"
         PREPARE q775_pre14 FROM l_sql
         EXECUTE q775_pre14
         
         #rvv17
         LET l_sql = 
             " MERGE INTO cpmq003_tmp o ",
             "      USING (SELECT  rvv04,rvv05,SUM(rvv17) rvv17_sum ",
             "               FROM rvv_file,rvu_file ", 
             "              WHERE rvu01=rvv01 AND rvuconf='Y' AND (rvu00='2' OR rvu00='3') ",
             "           GROUP BY rvv04,rvv05 ) n ",
             "         ON (o.pmk01 = n.rvv04 AND o.pml02 = n.rvv05 ) ",  #rvb01/rvb02
             " WHEN MATCHED ",
             " THEN ",
             "    UPDATE ",
             "       SET o.rvv17 =NVL(n.rvv17_sum,0) "
         PREPARE q775_pre15 FROM l_sql
         EXECUTE q775_pre15
         #apb09
         LET l_sql = 
             " MERGE INTO cpmq003_tmp o ",
             "      USING (SELECT apb04,apb05,SUM(apb09) apb09_sum,SUM(apb24) apb24_sum ",
             "               FROM apb_file,apa_file ", 
             "              WHERE apa01=apb01 AND apa41='Y' AND apa00='11' ",
             "           GROUP BY apb04,apb05 ) n ",
             "         ON (o.pmk01 = n.apb04 AND o.pml02 = n.apb05 ) ", #rvb01/rvb02
             " WHEN MATCHED ",
             " THEN ",
             "    UPDATE ",
             "       SET o.apb09 = NVL(n.apb09_sum,0),",
             "           o.apb24 = NVL(n.apb24_sum,0)"
         PREPARE q775_pre16 FROM l_sql
         EXECUTE q775_pre16

         LET l_sql = 
             " MERGE INTO cpmq003_tmp o ",
             "      USING (SELECT apb04,apb05,SUM(apb09) apb09_sum,SUM(apb24) apb24_sum ",
             "               FROM apb_file,apa_file ", 
             "              WHERE apa01=apb01 AND apa41='Y' AND apa00='21' ",
             "           GROUP BY apb04,apb05 ) n ",
             "         ON (o.pmk01 = n.apb04 AND o.pml02 = n.apb05 ) ", #rvb01/rvb02
             " WHEN MATCHED ",
             " THEN ",
             "    UPDATE ",
             "       SET o.apb09 =o.apb09-NVL(n.apb09_sum,0),",
             "           o.apb24 =o.apb24-NVL(n.apb24_sum,0)"
         PREPARE q775_pre17 FROM l_sql
         EXECUTE q775_pre17
         #state
         #已完成:入库数量>=收货数量或pmk18='X'
         LET l_sql = 
             " UPDATE cpmq003_tmp  ",
             "    SET state='2' ",
             "  WHERE pml20<=pmn53 OR pmk18='X' " 
         PREPARE q775_pre18 FROM l_sql
         EXECUTE q775_pre18

         LET l_sql = 
             " UPDATE cpmq003_tmp  ",
             "    SET state='0' ",
             "  WHERE pmn53=0 AND pml20>pmn53 AND pmk18<>'X' " 
         PREPARE q775_pre19 FROM l_sql
         EXECUTE q775_pre19

         LET l_sql =
             " UPDATE cpmq003_tmp  ",
             "    SET state='1' ",
             "  WHERE pmn53=0 AND pml20>pmn53 AND pmk18<>'X' ",
             "    AND (SELECT COUNT(*) FROM qcs_file ",
             "          WHERE qcs01=pmk01 AND qcs14='Y')>=1 " 
         PREPARE q775_pre19_1 FROM l_sql
         EXECUTE q775_pre19_1

         LET l_sql = 
             " UPDATE cpmq003_tmp  ",
             "    SET state='1' ",
             "  WHERE pmn53<>0 AND pml20>pmn53 AND pmk18<>'X' " 
         PREPARE q775_pre20 FROM l_sql
         EXECUTE q775_pre20

         #speed
         LET l_sql = 
             " UPDATE cpmq003_tmp  ",
             "    SET  speed = '3' "
         PREPARE q775_pre21 FROM l_sql
         EXECUTE q775_pre21
         
         LET l_sql = 
             " UPDATE cpmq003_tmp  ",
             "    SET  speed = '0' ",
             "  WHERE state<>'2' AND pml35>= '",g_today ,"' "
         PREPARE q775_pre22 FROM l_sql
         EXECUTE q775_pre22

         LET l_sql = 
             " UPDATE cpmq003_tmp  ",
             "    SET  speed = '1' ",
             "  WHERE state<>'2' AND  pml35< '",g_today ,"' "  #TQC-CC0141 
         PREPARE q775_pre23 FROM l_sql
         EXECUTE q775_pre23

         LET l_sql = 
             " MERGE INTO cpmq003_tmp o ",
             "      USING (SELECT rvv04,rvv05,MAX(rvv09) rvv09_max FROM rvv_file,rvu_file ",
             "              WHERE rvu01=rvv01 AND rvuconf='Y' AND rvu00='1' ",
             "              GROUP BY rvv04,rvv05 ) n ",
             "         ON (o.pmk01 = n.rvv04 AND o.pml02 = n.rvv05 ) ", 
             " WHEN MATCHED ",
             " THEN ",
             "    UPDATE ",
             "       SET o.speed = '0' ",
             "     WHERE o.pml35>=n.rvv09_max  ",
             "       AND o.speed = '3' "
             
         PREPARE q775_pre24 FROM l_sql
         EXECUTE q775_pre24

         LET l_sql = 
             " UPDATE cpmq003_tmp  ",
             "    SET speed = '1' ",
             "  WHERE speed = '3' "
         PREPARE q775_pre25 FROM l_sql
         EXECUTE q775_pre25  

         IF tm.b = 'N' THEN
            LET l_sql =
                " DELETE FROM cpmq003_tmp  ",
                "  WHERE nvl(pml20,0)<nvl(pmn53,0) "
            PREPARE q775_del04 FROM l_sql
            EXECUTE q775_del04
         END IF
         IF tm.c = 'N' THEN 
            LET l_sql =
                " DELETE FROM cpmq003_tmp  ",
                "  WHERE nvl(pml20,0)=nvl(pmn53,0) "
            PREPARE q775_del05 FROM l_sql
            EXECUTE q775_del05 
         END IF
         IF tm.d = 'N' THEN 
            LET l_sql =
                " DELETE FROM cpmq003_tmp  ",
                "  WHERE nvl(pml20,0)>nvl(pmn53,0) "
            PREPARE q775_del06 FROM l_sql
            EXECUTE q775_del06 
         END IF
         
      OTHERWISE 
         #rvv39,39t
         LET l_sql = 
             " MERGE INTO cpmq003_tmp o ",
             "      USING (SELECT pmn24,pmn25,SUM(rvv39) rvv39_sum,SUM(rvv39t) rvv39t_sum ",
             "               FROM rvv_file,rvu_file,pmn_file ", 
             "               WHERE rvu01=rvv01 AND rvv36=pmn01 AND rvv37=pmn02 AND rvuconf='Y' AND rvu00='1'  ",
             "              GROUP BY pmn24,pmn25 ) n ",
             "         ON (o.pmk01 = n.pmn24 AND o.pml02 = n.pmn25 ) ", 
             " WHEN MATCHED ",
             " THEN ",
             "    UPDATE ",
             "       SET o.rvv39 = NVL(n.rvv39_sum,0) ,",
             "           o.rvv39t =NVL(n.rvv39t_sum,0)  "
         PREPARE q775_pre26 FROM l_sql
         EXECUTE q775_pre26
         #rvv17
         LET l_sql = 
             " MERGE INTO cpmq003_tmp o ",
             "      USING (SELECT pmn24,pmn25,SUM(rvv17) rvv17_sum ",
             "               FROM rvv_file,rvu_file,pmn_file ", 
             "              WHERE rvu01=rvv01 AND rvv36=pmn01 AND rvv37=pmn02 AND rvuconf='Y' AND rvu00='3' ",
             "              GROUP BY pmn24,pmn25 ) n ",
             "         ON (o.pmk01 = n.pmn24 AND o.pml02 = n.pmn25 ) ", #pmn01/pmn02
             " WHEN MATCHED ",
             " THEN ",
             "    UPDATE ",
             "       SET o.rvv17 = NVL(n.rvv17_sum,0) "
         PREPARE q775_pre27 FROM l_sql
         EXECUTE q775_pre27

         #apb09
         LET l_sql = 
             " MERGE INTO cpmq003_tmp o ",
             "      USING (SELECT pmn24,pmn25,SUM(apb09) apb09_sum,SUM(apb24) apb24_sum ",
             "               FROM apb_file,apa_file,pmn_file ", 
             "              WHERE apa01=apb01 AND apb06=pmn01 AND apb07=pmn02 AND apa41='Y' AND apa00='11' ",
             "           GROUP BY pmn24,pmn25 ) n ",
             "         ON (o.pmk01 = n.pmn24 AND o.pml02 = n.pmn25 ) ", 
             " WHEN MATCHED ",
             " THEN ",
             "    UPDATE ",
             "       SET o.apb09 = NVL(n.apb09_sum,0),",
             "           o.apb24 = NVL(n.apb24_sum,0)"
         PREPARE q775_pre28 FROM l_sql
         EXECUTE q775_pre28

         LET l_sql = 
             " MERGE INTO cpmq003_tmp o ",
             "      USING (SELECT pmn24,pmn25,SUM(apb09) apb09_sum,SUM(apb24) apb24_sum ",
             "               FROM apb_file,apa_file,pmn_file ", 
             "              WHERE apa01=apb01 AND apb06=pmn01 AND apb07=pmn02 AND apa41='Y' AND apa00='21' ",
             "           GROUP BY pmn24,pmn25 ) n ",
             "         ON (o.pmk01 = n.pmn24 AND o.pml02 = n.pmn25 ) ", #pmn01/pmn02
             " WHEN MATCHED ",
             " THEN ",
             "    UPDATE ",
             "       SET o.apb09 =o.apb09-NVL(n.apb09_sum,0),",
             "           o.apb24 =o.apb24-NVL(n.apb24_sum,0)"
         PREPARE q775_pre29 FROM l_sql
         EXECUTE q775_pre29

         #state
         #已完成:入库数量>=采购数量或pml16='678'
         LET l_sql = 
             " UPDATE cpmq003_tmp  ",
             "    SET state='2' ",
             "  WHERE pml87<=pmn53 OR pml16 IN ('6','7','8') " 
         PREPARE q775_pre30 FROM l_sql
         EXECUTE q775_pre30

         LET l_sql = 
             " UPDATE cpmq003_tmp  ",
             "    SET state='0' ",
             "  WHERE pml87>pmn53 AND pml16 NOT IN ('2','6','7','8') " 
         PREPARE q775_pre31 FROM l_sql
         EXECUTE q775_pre31

         LET l_sql = 
             " UPDATE cpmq003_tmp  ",
             "    SET state='1' ",
             "  WHERE pml87>pmn53 AND pml16 IN ('2') " 
         PREPARE q775_pre32 FROM l_sql
         EXECUTE q775_pre32
         
         #speed
         LET l_sql = 
             " UPDATE cpmq003_tmp  ",
             "    SET  speed = '3' "
         PREPARE q775_pre33 FROM l_sql
         EXECUTE q775_pre33
         
         LET l_sql = 
             " UPDATE cpmq003_tmp  ",
             "    SET  speed = '0' ",
             "  WHERE state<>'2' AND pml35>= '",g_today ,"' "
         PREPARE q775_pre34 FROM l_sql
         EXECUTE q775_pre34

         LET l_sql = 
             " UPDATE cpmq003_tmp  ",
             "    SET  speed = '1' ",
             "  WHERE state<>'2' AND  pml35< '",g_today ,"' "  #TQC-CC0141 
         PREPARE q775_pre35 FROM l_sql
         EXECUTE q775_pre35

         LET l_sql = 
             " MERGE INTO cpmq003_tmp o ",
             "      USING (SELECT pmn24,pmn25,MAX(rvv09) rvv09_max FROM rvv_file,rvu_file,pmn_file ",
             "              WHERE rvu01=rvv01 AND pmn01=rvv36 AND pmn02=rvv37 AND rvuconf='Y' AND rvu00='1' ",
             "              GROUP BY pmn24,pmn25 ) n ",
             "         ON (o.pmk01 = n.pmn24 AND o.pml02 = n.pmn25 ) ", #pmn01/pmn02
             " WHEN MATCHED ",
             " THEN ",
             "    UPDATE ",
             "       SET o.speed = '0' ",
             "     WHERE o.pml35>=n.rvv09_max  ",
             "       AND o.speed = '3' "
             
         PREPARE q775_pre36 FROM l_sql
         EXECUTE q775_pre36

         LET l_sql = 
             " UPDATE cpmq003_tmp  ",
             "    SET speed = '1' ",
             "  WHERE speed = '3' "
         PREPARE q775_pre37 FROM l_sql
         EXECUTE q775_pre37      

      END CASE 

   #free--mark--str--
   #PREPARE q003_prepare FROM l_sql
   #DECLARE q003_curs CURSOR FOR q003_prepare
               
   #DECLARE q003_cs                         #SCROLL CURSOR
   #        SCROLL CURSOR FOR q003_prepare
   #OPEN q003_cs
   #FETCH FIRST q003_cs INTO sr.*
   #IF SQLCA.SQLCODE THEN 
   #   LET g_int_flag = '1'
   #END IF   
   #INITIALIZE sr.* TO NULL
  
   #FOREACH q003_curs INTO sr.*
   #   IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
   #   IF cl_null(sr.pmk01) THEN LET sr.pmk01='' END IF 
   #   IF cl_null(sr.pmk02) THEN LET sr.pmk02='' END IF 
   #   IF cl_null(sr.pmk04) THEN LET sr.pmk04='' END IF 
   #   IF cl_null(sr.pmk12) THEN LET sr.pmk12='' END IF 
   #   IF cl_null(sr.gen02) THEN LET sr.gen02='' END IF 
   #   IF cl_null(sr.pmk13) THEN LET sr.pmk13='' END IF 
   #   IF cl_null(sr.gem02) THEN LET sr.gem02='' END IF 
   #   IF cl_null(sr.pmk09) THEN LET sr.pmk09='' END IF 
   #   IF cl_null(sr.pmc03) THEN LET sr.pmc03='' END IF 
   #   IF cl_null(sr.pml04) THEN LET sr.pml04='' END IF 
   #   IF cl_null(sr.pml041) THEN LET sr.pml041='' END IF 
   #   IF cl_null(sr.ima021) THEN LET sr.ima021='' END IF 
   #   IF cl_null(sr.pml12) THEN LET sr.pml12='' END IF 
   #   IF cl_null(sr.pml121) THEN LET sr.pml121='' END IF 
   #   CASE g_pname
   #      WHEN '2'

   #         #rvv39,39t
   #         SELECT SUM(rvv39),SUM(rvv39t) INTO sr.rvv39,sr.rvv39t 
   #           FROM rvv_file,rvu_file
   #          WHERE rvu01=rvv01 
   #            AND rvu00='1' AND rvuconf='Y'
   #            AND rvv36=sr.pmk01 AND rvv37=sr.pml02  #pmn01/pmn02
   #         #rvv17
   #         SELECT SUM(rvv17) INTO sr.rvv17
   #           FROM rvv_file,rvu_file
   #          WHERE rvu01=rvv01 
   #            AND rvu00='3' AND rvuconf='Y' 
   #            AND rvv36=sr.pmk01 AND rvv37=sr.pml02  #pmn01/pmn02
   #         #apb09
   #         SELECT SUM(apb09),SUM(apb24) INTO sr.apb09,sr.apb24
   #           FROM apb_file,apa_file
   #          WHERE apa01=apb01 
   #            AND apa00='11' AND apa41='Y'
   #            AND apb06=sr.pmk01 AND apb07=sr.pml02  #pmn01/pmn02
   #         SELECT SUM(apb09),SUM(apb24) INTO l_apb09,l_apb24
   #           FROM apb_file,apa_file
   #          WHERE apa01=apb01 
   #            AND apa00='21' AND apa41='Y'
   #            AND apb06=sr.pmk01 AND apb07=sr.pml02  #pmn01/pmn02
   #         IF cl_null(sr.apb09) THEN LET sr.apb09=0 END IF 
   #         IF cl_null(sr.apb24) THEN LET sr.apb24=0 END IF 
   #         IF cl_null(l_apb09) THEN LET l_apb09=0 END IF 
   #         IF cl_null(l_apb24) THEN LET l_apb24=0 END IF 
   #         LET sr.apb09=sr.apb09-l_apb09
   #         LET sr.apb24=sr.apb24-l_apb24
   #         #state
   #         #已完成:入库数量>=采购数量或pml16='678'
   #         IF sr.pml21<=sr.pmn53 OR sr.pml16 MATCHES '[678]' THEN  
   #            LET sr.state = '2'
   #         ELSE 
   #            #未开始:未转采购单且未结案
   #           IF sr.pml16 NOT MATCHES '[2678]' THEN 
   #               LET sr.state = '0'
   #           ELSE 
   #              LET sr.state = '1'
   #           END IF 
   #         END IF 
   #         #speed
   #         IF sr.state<>'2' THEN 
   #            IF sr.pml35>=g_today THEN
   #              LET sr.speed = '0'
   #            ELSE 
   #              LET sr.speed = '1'
   #            END IF 
   #         ELSE  
   #            LET l_day = ''
   #            SELECT MAX(rvv09) INTO l_day FROM rvv_file,rvu_file
   #             WHERE rvu01=rvv01
   #               AND rvu00='1' AND rvuconf='Y'
   #               AND rvv36=sr.pmk01 AND rvv37=sr.pml02
   #            IF NOT cl_null(l_day) AND l_day<=sr.pml35 THEN 
   #               LET sr.speed = '0'
   #            ELSE 
   #               LET sr.speed = '1'
   #            END IF 
   #         END IF 
   #         
   #      WHEN '3'
   #         #rva115,rva116,gec07,rva113,rva114
   #         LET l_n=0
   #         SELECT COUNT(*) INTO l_n FROM rva_file WHERE rva01=sr.pmk01 AND rva00='2'
   #         IF l_n>=1 THEN
   #            LET sr.pmm21=''  LET sr.pmm43=''  LET sr.gec07=''
   #            LET sr.pmm22=''  LET sr.pmm42=''
   #            SELECT DISTINCT rva115,rva116,gec07,rva113,rva114
   #              INTO sr.pmm21,sr.pmm43,sr.gec07,sr.pmm22,sr.pmm42
   #              FROM rva_file LEFT OUTER JOIN gec_file ON rva115=gec01
   #             WHERE rva01=sr.pmk01 
   #         END IF
   #         #rvv39,39t
   #         SELECT SUM(rvv39),SUM(rvv39t) INTO sr.rvv39,sr.rvv39t 
   #           FROM rvv_file,rvu_file
   #          WHERE rvu01=rvv01 
   #            AND rvu00='1' AND rvuconf='Y'
   #            AND rvv04=sr.pmk01 AND rvv05=sr.pml02  #rvb01/rvb02
   #         #rvv17
   #         SELECT SUM(rvv17) INTO sr.rvv17
   #           FROM rvv_file,rvu_file
   #          WHERE rvu01=rvv01 
   #            AND (rvu00='2' OR rvu00='3') AND rvuconf='Y' 
   #            AND rvv04=sr.pmk01 AND rvv05=sr.pml02  #rvb01/rvb02
   #         #apb09
   #         SELECT SUM(apb09),SUM(apb24) INTO sr.apb09,sr.apb24
   #           FROM apb_file,apa_file
   #          WHERE apa01=apb01 
   #            AND apa00='11' AND apa41='Y'
   #            AND apb04=sr.pmk01 AND apb05=sr.pml02  #rvb01/rvb02
   #         SELECT SUM(apb09),SUM(apb24) INTO l_apb09,l_apb24
   #           FROM apb_file,apa_file
   #          WHERE apa01=apb01 
   #            AND apa00='21' AND apa41='Y'
   #            AND apb04=sr.pmk01 AND apb05=sr.pml02  #rvb01/rvb02
   #         IF cl_null(sr.apb09) THEN LET sr.apb09=0 END IF 
   #         IF cl_null(sr.apb24) THEN LET sr.apb24=0 END IF 
   #         IF cl_null(l_apb09) THEN LET l_apb09=0 END IF 
   #         IF cl_null(l_apb24) THEN LET l_apb24=0 END IF 
   #         LET sr.apb09=sr.apb09-l_apb09
   #         LET sr.apb24=sr.apb24-l_apb24
   #         #state
   #         #已完成:入库数量>=收货数量或pml16='678'
   #         IF sr.pml20<=sr.pmn53 OR sr.pmk18 MATCHES '[X]' THEN  
   #            LET sr.state = '2'
   #         ELSE 
   #            #未开始:未转采购单且未结案
   #            IF sr.pmn53=0 THEN 
   #               LET sr.state = '0'
   #            ELSE 
   #               LET sr.state = '1'
   #            END IF 
   #         END IF 
   #         #speed
   #         IF sr.state<>'2' THEN 
   #            IF sr.pml35>=g_today THEN
   #              LET sr.speed = '0'
   #            ELSE 
   #              LET sr.speed = '1'
   #            END IF 
   #         ELSE  
   #            LET l_day = ''
   #            SELECT MAX(rvv09) INTO l_day FROM rvv_file,rvu_file
   #             WHERE rvu01=rvv01
   #               AND rvu00='1' AND rvuconf='Y'
   #               AND rvv04=sr.pmk01 AND rvv05=sr.pml02
   #            IF NOT cl_null(l_day) AND l_day<=sr.pml35 THEN 
   #               LET sr.speed = '0'
   #            ELSE 
   #               LET sr.speed = '1'
   #            END IF 
   #         END IF 
   #         
   #      OTHERWISE 
   #         #rvv39,39t
   #         SELECT SUM(rvv39),SUM(rvv39t) INTO sr.rvv39,sr.rvv39t 
   #           FROM rvv_file,rvu_file,pmn_file
   #          WHERE rvu01=rvv01 AND rvv36=pmn01 AND rvv37=pmn02
   #            AND rvu00='1' AND rvuconf='Y'
   #            AND pmn24=sr.pmk01 AND pmn25=sr.pml02
   #         #rvv17
   #         SELECT SUM(rvv17) INTO sr.rvv17
   #           FROM rvv_file,rvu_file,pmn_file
   #          WHERE rvu01=rvv01 AND rvv36=pmn01 AND rvv37=pmn02
   #            AND rvu00='3' AND rvuconf='Y' 
   #            AND pmn24=sr.pmk01 AND pmn25=sr.pml02
   #         #apb09
   #         SELECT SUM(apb09),SUM(apb24) INTO sr.apb09,sr.apb24
   #           FROM apb_file,apa_file,pmn_file
   #          WHERE apa01=apb01 AND apb06=pmn01 AND apb07=pmn02
   #            AND apa00='11' AND apa41='Y'
   #            AND pmn24=sr.pmk01 AND pmn25=sr.pml02
   #         SELECT SUM(apb09),SUM(apb24) INTO l_apb09,l_apb24
   #           FROM apb_file,apa_file,pmn_file
   #          WHERE apa01=apb01 AND apb06=pmn01 AND apb07=pmn02
   #            AND apa00='21' AND apa41='Y'
   #            AND pmn24=sr.pmk01 AND pmn25=sr.pml02
   #         IF cl_null(sr.apb09) THEN LET sr.apb09=0 END IF 
   #         IF cl_null(sr.apb24) THEN LET sr.apb24=0 END IF 
   #         IF cl_null(l_apb09) THEN LET l_apb09=0 END IF 
   #         IF cl_null(l_apb24) THEN LET l_apb24=0 END IF 
   #         LET sr.apb09=sr.apb09-l_apb09
   #         LET sr.apb24=sr.apb24-l_apb24
   #         #state
   #         #已完成:入库数量>=请购数量或pml16='678'
   #         IF sr.pml87<=sr.pmn53 OR sr.pml16 MATCHES '[678]' THEN  
   #            LET sr.state = '2'
   #         ELSE 
   #            #未开始:未转采购单且未结案
   #           IF sr.pml16 NOT MATCHES '[2678]' THEN 
   #               LET sr.state = '0'
   #            ELSE 
   #               LET sr.state = '1'
   #            END IF 
   #         END IF 
   #         #speed
   #         IF sr.state<>'2' THEN 
   #            IF sr.pml35>=g_today THEN
   #              LET sr.speed = '0'
   #            ELSE 
   #              LET sr.speed = '1'
   #            END IF 
   #         ELSE  
   #            LET l_day = ''
   #            SELECT MAX(rvv09) INTO l_day FROM rvv_file,rvu_file,pmn_file 
   #             WHERE rvu01=rvv01
   #               AND pmn01=rvv36 AND pmn02=rvv37
   #               AND rvu00='1' AND rvuconf='Y'
   #               AND pmn24=sr.pmk01 AND pmn25=sr.pml02
   #            IF NOT cl_null(l_day) AND l_day<=sr.pml35 THEN 
   #               LET sr.speed = '0'
   #            ELSE 
   #               LET sr.speed = '1'
   #            END IF 
   #         END IF 
   #      IF cl_null(sr.pml20) THEN LET sr.pml20=0 END IF  
   #      IF cl_null(sr.pmn53) THEN LET sr.pmn53=0 END IF 
   #      IF tm.b = 'N' THEN
   #         IF sr.pml20<sr.pmn53 THEN 
   #            CONTINUE FOREACH 
   #         END IF 
   #      END IF
   #      IF tm.c = 'N' THEN 
   #         IF sr.pml20=sr.pmn53 THEN 
   #            CONTINUE FOREACH 
   #         END IF 
   #      END IF
   #      IF tm.d = 'N' THEN 
   #         IF sr.pml20>sr.pmn53 THEN 
   #            CONTINUE FOREACH 
   #         END IF 
   #      END IF
   #   END CASE 
   #   IF tm.h<>'2' AND tm.h<>sr.speed THEN 
   #      CONTINUE FOREACH 
   #   END IF
   #   IF tm.g<>'3' AND tm.g<>sr.state THEN 
   #      CONTINUE FOREACH 
   #   END IF
   #   
   #   IF cl_null(sr.pml20) THEN LET sr.pml20=0 END IF 
   #   IF cl_null(sr.pml87) THEN LET sr.pml87=0 END IF 
   #   IF cl_null(sr.pml21) THEN LET sr.pml21=0 END IF 
   #   IF cl_null(sr.pmn88) THEN LET sr.pmn88=0 END IF 
   #   IF cl_null(sr.pmn88t) THEN LET sr.pmn88t=0 END IF 
   #   IF cl_null(sr.pmn50) THEN LET sr.pmn50=0 END IF 
   #   IF cl_null(sr.pmn55) THEN LET sr.pmn55=0 END IF 
   #   IF cl_null(sr.pmn50a) THEN LET sr.pmn50a=0 END IF 
   #   IF cl_null(sr.pmn53) THEN LET sr.pmn53=0 END IF 
   #   IF cl_null(sr.rvv39) THEN LET sr.rvv39=0 END IF 
   #   IF cl_null(sr.rvv39t) THEN LET sr.rvv39t=0 END IF 
   #   IF cl_null(sr.rvv17) THEN LET sr.rvv17=0 END IF 
   #   IF cl_null(sr.apb09) THEN LET sr.apb09=0 END IF 
   #   IF cl_null(sr.apb24) THEN LET sr.apb24=0 END IF 
   #   INSERT INTO cpmq003_tmp VALUES(sr.*)
   #END FOREACH 
   #free--mark--end--
   IF g_pname='1' THEN 

      LET l_wc_sfb = tm.wc2
      IF cl_null(l_wc_sfb) THEN LET l_wc_sfb = ' 1=1' END IF 
      IF l_wc_sfb <>' 1=1' THEN 
         #pmk01,pmk02,pmk04,pmk12,pmk13,pmk09,pmk18,pml02,
        ##sfb01,sfb02,sfb81,sfb44,''   ,sfb82,sfb87,'',
         #pml04,pml07,pml20,pml86,pml87,pml21,pml35,
        ##sfb05,''   ,sfb08,''   ,sfb08,''   ,sfb15   ,
         #pml34,pml33,pml16,pml24,pml25
        ##sfb15,sfb15,''   ,''   ,''  
         IF l_wc_sfb.getIndexOf("pmk13",1)>=1 THEN LET l_wc_sfb='' END IF 
         IF l_wc_sfb.getIndexOf("pml02",1)>=1 THEN LET l_wc_sfb='' END IF 
         IF l_wc_sfb.getIndexOf("pml07",1)>=1 THEN LET l_wc_sfb='' END IF 
         IF l_wc_sfb.getIndexOf("pml86",1)>=1 THEN LET l_wc_sfb='' END IF 
         IF l_wc_sfb.getIndexOf("pml21",1)>=1 THEN LET l_wc_sfb='' END IF 
         IF l_wc_sfb.getIndexOf("pml16",1)>=1 THEN LET l_wc_sfb='' END IF 
         IF l_wc_sfb.getIndexOf("pml24",1)>=1 THEN LET l_wc_sfb='' END IF 
         IF l_wc_sfb.getIndexOf("pml25",1)>=1 THEN LET l_wc_sfb='' END IF 
         IF l_wc_sfb.getIndexOf("pml041",1)>=1 THEN LET l_wc_sfb='' END IF 
         IF l_wc_sfb.getIndexOf("pml12",1)>=1 THEN LET l_wc_sfb='' END IF 
         IF l_wc_sfb.getIndexOf("pml121",1)>=1 THEN LET l_wc_sfb='' END IF 
         IF cl_null(l_wc_sfb) THEN 
            LET l_wc_sfb=' 1=2'
         ELSE
            LET l_wc_sfb=cl_replace_str(l_wc_sfb,'pmk01','sfb01')
            LET l_wc_sfb=cl_replace_str(l_wc_sfb,'pmk02','sfb02')
            LET l_wc_sfb=cl_replace_str(l_wc_sfb,'pmk04','sfb81')
            LET l_wc_sfb=cl_replace_str(l_wc_sfb,'pmk12','sfb44')
            LET l_wc_sfb=cl_replace_str(l_wc_sfb,'pmk09','sfb82')
            LET l_wc_sfb=cl_replace_str(l_wc_sfb,'pmk18','sfb87')
            LET l_wc_sfb=cl_replace_str(l_wc_sfb,'pml04','sfb05')
            LET l_wc_sfb=cl_replace_str(l_wc_sfb,'pml20','sfb08')
            LET l_wc_sfb=cl_replace_str(l_wc_sfb,'pml87','sfb08')
            LET l_wc_sfb=cl_replace_str(l_wc_sfb,'pml35','sfb15')
            LET l_wc_sfb=cl_replace_str(l_wc_sfb,'pml34','sfb15')
            LET l_wc_sfb=cl_replace_str(l_wc_sfb,'pml33','sfb15')
            IF l_wc_sfb.getIndexOf("sfb02",1)>=1 THEN 
               LET l_wc_tmp = l_wc_sfb.subString(1,l_wc_sfb.getIndexOf("sfb02",1)-1)
               IF l_wc_sfb.getIndexOf("and",l_wc_sfb.getIndexOf("sfb02",1))>1 THEN 
                  LET l_wc_tmp_1 = l_wc_sfb.subString(l_wc_sfb.getIndexOf("sfb02",1),l_wc_sfb.getIndexOf("and",l_wc_sfb.getIndexOf("sfb02",1))-1)
                  IF l_wc_tmp_1.getIndexOf("'7'",1)>=1 THEN
                     LET l_wc_tmp = l_wc_tmp ," sfb02='7' "
                  ELSE 
                     LET l_wc_tmp = l_wc_tmp ,' 1=2 '
                  END IF 
                  LET l_wc_sfb= l_wc_tmp , l_wc_sfb.subString(l_wc_sfb.getIndexOf("and",l_wc_sfb.getIndexOf("sfb02",1))-1,l_wc_sfb.getLength())
               ELSE 
                  LET l_wc_tmp_1 = l_wc_sfb.subString(l_wc_sfb.getIndexOf("sfb02",1),l_wc_sfb.getLength())
                  IF l_wc_tmp_1.getIndexOf("'7'",1)>=1 THEN
                     LET l_wc_tmp = l_wc_tmp ," sfb02='7' "
                  ELSE 
                     LET l_wc_tmp = l_wc_tmp ,' 1=2 '
                  END IF 
                  LET l_wc_sfb = l_wc_tmp
               END IF 
            END IF 
         END IF 
      END IF 
      LET g_filter_wc_sfb = g_filter_wc
      IF cl_null(g_filter_wc_sfb) THEN LET g_filter_wc_sfb = ' 1=1' END IF 
      IF g_filter_wc_sfb <>' 1=1' THEN 
         #pmk01,pmk02,pmk04,pmk12,pmk13,pmk09,pmk18,pml02,
        ##sfb01,sfb02,sfb81,sfb44,''   ,sfb82,sfb87,'',
         #pml04,pml07,pml20,pml86,pml87,pml21,pml35,
        ##sfb05,''   ,sfb08,''   ,sfb08,''   ,sfb15   ,
         #pml34,pml33,pml16,pml24,pml25
        ##sfb15,sfb15,''   ,''   ,''   
         IF g_filter_wc_sfb.getIndexOf("pmk13",1)>=1 THEN LET g_filter_wc_sfb='' END IF 
         IF g_filter_wc_sfb.getIndexOf("pml02",1)>=1 THEN LET g_filter_wc_sfb='' END IF 
         IF g_filter_wc_sfb.getIndexOf("pml07",1)>=1 THEN LET g_filter_wc_sfb='' END IF 
         IF g_filter_wc_sfb.getIndexOf("pml86",1)>=1 THEN LET g_filter_wc_sfb='' END IF 
         IF g_filter_wc_sfb.getIndexOf("pml21",1)>=1 THEN LET g_filter_wc_sfb='' END IF 
         IF g_filter_wc_sfb.getIndexOf("pml16",1)>=1 THEN LET g_filter_wc_sfb='' END IF 
         IF g_filter_wc_sfb.getIndexOf("pml24",1)>=1 THEN LET g_filter_wc_sfb='' END IF 
         IF g_filter_wc_sfb.getIndexOf("pml25",1)>=1 THEN LET g_filter_wc_sfb='' END IF 
         IF g_filter_wc_sfb.getIndexOf("pml041",1)>=1 THEN LET g_filter_wc_sfb='' END IF 
         IF g_filter_wc_sfb.getIndexOf("pml12",1)>=1 THEN LET g_filter_wc_sfb='' END IF 
         IF g_filter_wc_sfb.getIndexOf("pml121",1)>=1 THEN LET g_filter_wc_sfb='' END IF  
         IF cl_null(g_filter_wc_sfb) THEN 
            LET g_filter_wc_sfb=' 1=2'
         ELSE
            LET g_filter_wc_sfb=cl_replace_str(g_filter_wc_sfb,'pmk01','sfb01')
            LET g_filter_wc_sfb=cl_replace_str(g_filter_wc_sfb,'pmk02','sfb02')
            LET g_filter_wc_sfb=cl_replace_str(g_filter_wc_sfb,'pmk04','sfb81')
            LET g_filter_wc_sfb=cl_replace_str(g_filter_wc_sfb,'pmk12','sfb44')
            LET g_filter_wc_sfb=cl_replace_str(g_filter_wc_sfb,'pmk09','sfb82')
            LET g_filter_wc_sfb=cl_replace_str(g_filter_wc_sfb,'pmk18','sfb87')
            LET g_filter_wc_sfb=cl_replace_str(g_filter_wc_sfb,'pml04','sfb05')
            LET g_filter_wc_sfb=cl_replace_str(g_filter_wc_sfb,'pml20','sfb08')
            LET g_filter_wc_sfb=cl_replace_str(g_filter_wc_sfb,'pml87','sfb08')
            LET g_filter_wc_sfb=cl_replace_str(g_filter_wc_sfb,'pml35','sfb15')
            LET g_filter_wc_sfb=cl_replace_str(g_filter_wc_sfb,'pml34','sfb15')
            LET g_filter_wc_sfb=cl_replace_str(g_filter_wc_sfb,'pml33','sfb15')
            LET g_filter_wc_sfb=cl_replace_str(g_filter_wc_sfb,'and','AND')
            #free
            LET l_filter_wc=g_filter_wc_sfb
            LET g_filter_wc_sfb=''
            WHILE l_filter_wc.getIndexOf("sfb02",1)>=1
               LET l_wc_tmp = l_filter_wc.subString(1,l_filter_wc.getIndexOf("sfb02",1)-1)
               IF l_filter_wc.getIndexOf("AND",l_filter_wc.getIndexOf("sfb02",1))>=1 THEN 
                  LET l_wc_tmp_1 = l_filter_wc.subString(l_filter_wc.getIndexOf("sfb02",1),l_filter_wc.getIndexOf("AND",l_filter_wc.getIndexOf("sfb02",1)))
                  IF l_wc_tmp_1.getIndexOf("7",1)>=1 THEN
                     LET l_wc_tmp = l_wc_tmp ," sfb02='7' "
                  ELSE 
                     LET l_wc_tmp = l_wc_tmp ,' 1=2 '
                  END IF 
                  LET g_filter_wc_sfb=g_filter_wc_sfb,l_wc_tmp
                  LET l_filter_wc=l_filter_wc.subString(l_filter_wc.getIndexOf("AND",l_filter_wc.getIndexOf("sfb02",1))-1,l_filter_wc.getLength())
               ELSE 
                  LET l_wc_tmp_1 = l_filter_wc.subString(l_filter_wc.getIndexOf("sfb02",1),l_filter_wc.getLength())
                  IF l_wc_tmp_1.getIndexOf("7",1)>=1 THEN
                     LET l_wc_tmp = l_wc_tmp ," sfb02='7' "
                  ELSE 
                     LET l_wc_tmp = l_wc_tmp ,' 1=2 '
                  END IF 
                  LET g_filter_wc_sfb=g_filter_wc_sfb,l_wc_tmp
                  LET l_filter_wc=' '
               END IF 
            END WHILE 
            LET g_filter_wc_sfb = g_filter_wc_sfb,l_filter_wc
         END IF 
      END IF 
         #speed,state,pmk01,pmk02,pmk04,pmk12,gen02,pmk13,gem02,pmk09,
        ##speed,state,sfb01,sfb02,sfb81,sfb44,gen02,'','','sfb82',
         #pmc03,pmk18,pml02,pml04,pml041,ima021,pml07,pml20,pml86,pml87,
        ##pmc03,sfb87,''   ,sfb05,ima02 ,ima021,ima55,sfb08,'ima55','sfb08',
         #pml21,pmn31,pmn88,pmn88t,pmn50,pmn55,pmn50a,pmn53,rvv39,
        ##'pmn20',pmm31,pmn88,pmn88t,pmn50,pmn55,pmn50a,pmn53,rvv39,
         #rvv39t,rvv17,apb09,apb24,pmm21,pmm43,gec07,pmm22,pmm42,pmm99,
        ##rvv39t,rvv17,apb09,apb24,pmm21,pmm43,gec07,pmm22,pmm42,pmm99,
         #pml35,pml34,pml33,pml41,pml16,pml24,pml25,pml12,pml121
        ##sfb15,sfb15,sfb15,'','','','','',''
        
      LET l_sql ="SELECT '' speed,'' state,sfb01 pmk01,sfb02 pmk02,sfb81 pmk04,trim(nvl(sfb44,'')) pmk12,gen02,'' pmk13,'' gem02,trim(nvl(sfb82,'')) pmk09,", 
                       " pmc03,sfb87 pmk18,'' pml02,sfb05 pml04,ima02 pml041,ima021,ima55 pml07,nvl(sfb08,0) pml20,ima55 pml86,nvl(sfb08,0) pml87,",
                       " nvl(pmn20,0) pml21,nvl(pmn31,0) pmn31,nvl(pmn31t,0) pmn31,nvl(pmn88,0) pmn88,nvl(pmn88t,0) pmn88t,nvl(pmn50,0) pmn50,nvl(pmn55,0) pmn55,nvl(pmn20-(pmn50-pmn55-pmn58),0) pmn50a,nvl(pmn53-pmn58,0) pmn53,pmnud07,0 rvv39,",#add by pmn31t by guanyao160912 #mod pmn53 ->pmn53-pmn58 by liy210615  #谢宇彬要求退货换货未收货入库的要去掉
                       " 0 rvv39t,0 rvv17,0 apb09,0 apb24,pmm21,pmm43,gec07,pmm22,pmm42,pmm99,", 
                       " sfb15 pml35,sfb15 pml34,sfb15 pml33,'' pml41,'' pml16,'' pml24,'' pml25,'' pml12,'' pja02,'' pml121,'' pjb03 ",
                       " ,'' pml06 ", #darcy:2022/11/04 add
                 "  FROM sfb_file LEFT OUTER JOIN gen_file ON sfb44=gen01 ", 
                 "                LEFT OUTER JOIN gem_file ON gen03=gem01 ", 
                 "                LEFT OUTER JOIN pmc_file ON sfb82=pmc01 ", 
                 "                LEFT OUTER JOIN ima_file ON sfb05=ima01 ",
                 "                LEFT OUTER JOIN pmn_file ON pmn41=sfb01 ",
                 "                LEFT OUTER JOIN pmm_file ON pmm01=pmn01 ",
                 "                LEFT OUTER JOIN gec_file ON pmm21=gec01 ",
                 " WHERE sfb02='7' AND ",l_wc1,
                 "   AND ",l_wc_sfb CLIPPED," AND ",g_filter_wc_sfb CLIPPED

      LET l_sql = " INSERT INTO cpmq003_tmp1 ",l_sql CLIPPED
      PREPARE q003_ins1 FROM l_sql
      EXECUTE q003_ins1

      #rvv39,39t
      LET l_sql = 
          " MERGE INTO cpmq003_tmp1 o ",
          "      USING (SELECT pmn41,SUM(rvv39) rvv39_sum,SUM(rvv39t) rvv39t_sum ",
          "               FROM rvv_file,rvu_file,pmn_file ", 
          "              WHERE rvu01=rvv01 AND rvv36=pmn01 AND rvv37=pmn02 AND rvuconf='Y' AND rvu00='1' ",
          "              GROUP BY pmn41 ) n ",
          "         ON (o.pmk01 = n.pmn41 ) ", 
          " WHEN MATCHED ",
          " THEN ",
          "    UPDATE ",
          "       SET o.rvv39 = NVL(n.rvv39_sum,0) ,",
          "           o.rvv39t =NVL(n.rvv39t_sum,0)  "
      PREPARE q775_pre40 FROM l_sql
      EXECUTE q775_pre40

      #rvv17
      LET l_sql = 
          " MERGE INTO cpmq003_tmp1 o ",
          "      USING (SELECT pmn41,SUM(rvv17) rvv17_sum ",
          "               FROM rvv_file,rvu_file,pmn_file ", 
          "              WHERE rvu01=rvv01 AND rvv36=pmn01 AND rvv37=pmn02 AND rvuconf='Y' AND rvu00='3' ",
          "              GROUP BY pmn41 ) n ",
          "         ON (o.pmk01 = n.pmn41 ) ", 
          " WHEN MATCHED ",
          " THEN ",
          "    UPDATE ",
          "       SET o.rvv17 = NVL(n.rvv17_sum,0) "
      PREPARE q775_pre41 FROM l_sql
      EXECUTE q775_pre41

      #apb09
      LET l_sql = 
          " MERGE INTO cpmq003_tmp1 o ",
          "      USING (SELECT pmn41,SUM(apb09) apb09_sum,SUM(apb24) apb24_sum ",
          "               FROM apb_file,apa_file,pmn_file ", 
          "              WHERE apa01=apb01 AND apb06=pmn01 AND apb07=pmn02 AND apa41='Y' AND apa00='11' ",
          "           GROUP BY pmn41 ) n ",
          "         ON (o.pmk01 = n.pmn41 ) ", 
          " WHEN MATCHED ",
          " THEN ",
          "    UPDATE ",
          "       SET o.apb09 = NVL(n.apb09_sum,0),",
          "           o.apb24 = NVL(n.apb24_sum,0)"
      PREPARE q775_pre42 FROM l_sql
      EXECUTE q775_pre42

      LET l_sql = 
          " MERGE INTO cpmq003_tmp1 o ",
          "      USING (SELECT pmn41,SUM(apb09) apb09_sum,SUM(apb24) apb24_sum ",
          "               FROM apb_file,apa_file,pmn_file ", 
          "              WHERE apa01=apb01 AND apb06=pmn01 AND apb07=pmn02 AND apa41='Y' AND apa00='21' ",
          "           GROUP BY pmn41 ) n ",
          "         ON (o.pmk01 = n.pmn41 ) ", 
          " WHEN MATCHED ",
          " THEN ",
          "    UPDATE ",
          "       SET o.apb09 =o.apb09-NVL(n.apb09_sum,0),",
          "           o.apb24 =o.apb24-NVL(n.apb24_sum,0)"
      PREPARE q775_pre43 FROM l_sql
      EXECUTE q775_pre43

      #state
      #已完成:入库数量>=采购数量
      LET l_sql = 
          " UPDATE cpmq003_tmp1  ",
          "    SET state='2' ",
          "  WHERE pml21<=pmn53  " 
      PREPARE q775_pre44 FROM l_sql
      EXECUTE q775_pre44

      LET l_sql = 
          " UPDATE cpmq003_tmp1  ",
          "    SET state='0' ",
          "  WHERE pmn53=0 " 
      PREPARE q775_pre45 FROM l_sql
      EXECUTE q775_pre45

      LET l_sql = 
          " UPDATE cpmq003_tmp1  ",
          "    SET state='1' ",
          "  WHERE pml21>pmn53 AND pmn53<>0  " 
      PREPARE q775_pre46 FROM l_sql
      EXECUTE q775_pre46

      #speed
      LET l_sql = 
          " UPDATE cpmq003_tmp1  ",
          "    SET  speed = '3' "
      PREPARE q775_pre47 FROM l_sql
      EXECUTE q775_pre47
      
      LET l_sql = 
          " UPDATE cpmq003_tmp1  ",
          "    SET  speed = '0' ",
          "  WHERE state<>'2' AND pml35>= '",g_today ,"' "
      PREPARE q775_pre48 FROM l_sql
      EXECUTE q775_pre48

      LET l_sql = 
          " UPDATE cpmq003_tmp1  ",
          "    SET  speed = '1' ",
          "  WHERE state<>'2' AND  pml35< '",g_today ,"' "  #TQC-CC0141
      PREPARE q775_pre49 FROM l_sql
      EXECUTE q775_pre49

      LET l_sql = 
          " MERGE INTO cpmq003_tmp1 o ",
          "      USING (SELECT pmn41,MAX(rvv09) rvv09_max FROM rvv_file,rvu_file,pmn_file ",
          "              WHERE rvu01=rvv01 AND pmn01=rvv36 AND pmn02=rvv37 AND rvuconf='Y' AND rvu00='1' ",
          "              GROUP BY pmn41 ) n ",
          "         ON (o.pmk01 = n.pmn41 ) ", 
          " WHEN MATCHED ",
          " THEN ",
          "    UPDATE ",
          "       SET o.speed = '0' ",
          "     WHERE o.pml35>=n.rvv09_max  ",
          "       AND o.speed = '3' "           
      PREPARE q775_pre50 FROM l_sql
      EXECUTE q775_pre50

      LET l_sql = 
          " UPDATE cpmq003_tmp1  ",
          "    SET speed = '1' ",
          "  WHERE speed = '3' "
      PREPARE q775_pre51 FROM l_sql
      EXECUTE q775_pre51         

      LET l_sql = " INSERT INTO cpmq003_tmp ",
                  " SELECT * FROM cpmq003_tmp1 "
      PREPARE q003_ins2 FROM l_sql
      EXECUTE q003_ins2

      IF tm.b = 'N' THEN
         LET l_sql =
             " DELETE FROM cpmq003_tmp  ",
             "  WHERE nvl(pml20,0)<nvl(pmn53,0) "
         PREPARE q775_del07 FROM l_sql
         EXECUTE q775_del07
      END IF
      IF tm.c = 'N' THEN 
         LET l_sql =
             " DELETE FROM cpmq003_tmp  ",
             "  WHERE nvl(pml20,0)=nvl(pmn53,0) "
         PREPARE q775_del08 FROM l_sql
         EXECUTE q775_del08 
      END IF
      IF tm.d = 'N' THEN 
         LET l_sql =
             " DELETE FROM cpmq003_tmp  ",
             "  WHERE nvl(pml20,0)>nvl(pmn53,0) "
         PREPARE q775_del09 FROM l_sql
         EXECUTE q775_del09 
      END IF
   #free--mark--str--
   #   PREPARE q003_prepare_sfb FROM l_sql
   #   DECLARE q003_curs_sfb CURSOR FOR q003_prepare_sfb
               
   #   DECLARE q003_cs_sfb                         #SCROLL CURSOR
   #           SCROLL CURSOR FOR q003_prepare_sfb
   #   OPEN q003_cs_sfb
   #   FETCH FIRST q003_cs_sfb INTO sr.*
   #   IF SQLCA.SQLCODE THEN 
   #      LET g_int_flag = '1'
   #   END IF   
   #   INITIALIZE sr.* TO NULL 
   #   FOREACH q003_curs_sfb INTO sr.*
   #      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
   #         IF cl_null(sr.pmk01) THEN LET sr.pmk01='' END IF 
   #         IF cl_null(sr.pmk02) THEN LET sr.pmk02='' END IF 
   #         IF cl_null(sr.pmk04) THEN LET sr.pmk04='' END IF 
   #         IF cl_null(sr.pmk12) THEN LET sr.pmk12='' END IF 
   #         IF cl_null(sr.gen02) THEN LET sr.gen02='' END IF 
   #         IF cl_null(sr.pmk13) THEN LET sr.pmk13='' END IF 
   #         IF cl_null(sr.gem02) THEN LET sr.gem02='' END IF 
   #         IF cl_null(sr.pmk09) THEN LET sr.pmk09='' END IF 
   #         IF cl_null(sr.pmc03) THEN LET sr.pmc03='' END IF 
   #         IF cl_null(sr.pml04) THEN LET sr.pml04='' END IF 
   #         IF cl_null(sr.pml041) THEN LET sr.pml041='' END IF 
   #         IF cl_null(sr.ima021) THEN LET sr.ima021='' END IF 
   #         IF cl_null(sr.pml12) THEN LET sr.pml12='' END IF 
   #         IF cl_null(sr.pml121) THEN LET sr.pml121='' END IF 
   #         SELECT SUM(rvv39),SUM(rvv39t) INTO sr.rvv39,sr.rvv39t 
   #           FROM rvv_file,rvu_file,pmn_file
   #          WHERE rvu01=rvv01 AND rvv36=pmn01 AND rvv37=pmn02
   #            AND rvu00='1' AND rvuconf='Y'
   #            AND pmn41=sr.pmk01 
   #         #rvv17
   #         SELECT SUM(rvv17) INTO sr.rvv17
   #           FROM rvv_file,rvu_file,pmn_file
   #          WHERE rvu01=rvv01 AND rvv36=pmn01 AND rvv37=pmn02
   #            AND (rvu00='2' OR rvu00='3') AND rvuconf='Y' 
   #            AND pmn41=sr.pmk01 
   #         #apb09
   #         SELECT SUM(apb09),SUM(apb24) INTO sr.apb09,sr.apb24
   #           FROM apb_file,apa_file,pmn_file
   #          WHERE apa01=apb01 AND apb06=pmn01 AND apb07=pmn02
   #            AND apa00='11' AND apa41='Y'
   #            AND pmn41=sr.pmk01 
   #         SELECT SUM(apb09),SUM(apb24) INTO l_apb09,l_apb24
   #           FROM apb_file,apa_file,pmn_file
   #          WHERE apa01=apb01 AND apb06=pmn01 AND apb07=pmn02
   #            AND apa00='21' AND apa41='Y'
   #            AND pmn41=sr.pmk01 
   #         IF cl_null(sr.apb09) THEN LET sr.apb09=0 END IF 
   #         IF cl_null(sr.apb24) THEN LET sr.apb24=0 END IF 
   #         IF cl_null(l_apb09) THEN LET l_apb09=0 END IF 
   #         IF cl_null(l_apb24) THEN LET l_apb24=0 END IF 
   #         LET sr.apb09=sr.apb09-l_apb09
   #         LET sr.apb24=sr.apb24-l_apb24
   #         IF cl_null(sr.pml20) THEN LET sr.pml20=0 END IF 
   #         IF cl_null(sr.pml87) THEN LET sr.pml87=0 END IF 
   #         IF cl_null(sr.pml21) THEN LET sr.pml21=0 END IF 
   #         IF cl_null(sr.pmn88) THEN LET sr.pmn88=0 END IF 
   #         IF cl_null(sr.pmn88t) THEN LET sr.pmn88t=0 END IF 
   #         IF cl_null(sr.pmn50) THEN LET sr.pmn50=0 END IF 
   #         IF cl_null(sr.pmn55) THEN LET sr.pmn55=0 END IF 
   #         IF cl_null(sr.pmn50a) THEN LET sr.pmn50a=0 END IF 
   #         IF cl_null(sr.pmn53) THEN LET sr.pmn53=0 END IF 
   #         IF cl_null(sr.rvv39) THEN LET sr.rvv39=0 END IF 
   #         IF cl_null(sr.rvv39t) THEN LET sr.rvv39t=0 END IF 
   #         IF cl_null(sr.rvv17) THEN LET sr.rvv17=0 END IF 
   #         IF cl_null(sr.apb09) THEN LET sr.apb09=0 END IF 
   #         IF cl_null(sr.apb24) THEN LET sr.apb24=0 END IF 
   #         #state
   #         #已完成:入库数量>=请购数量或pml16='678'
   #         IF sr.pml20<=sr.pmn53 THEN  
   #            LET sr.state = '2'
   #         ELSE 
   #            #未开始:未转采购单且未结案
   #           IF sr.pmn53=0 THEN 
   #               LET sr.state = '0'
   #            ELSE 
   #               LET sr.state = '1'
   #            END IF 
   #         END IF 
   #         #speed
   #         IF sr.state<>'2' THEN 
   #            IF sr.pml35>=g_today THEN
   #              LET sr.speed = '0'
   #            ELSE 
   #              LET sr.speed = '1'
   #            END IF 
   #         ELSE  
   #            LET l_day = ''
   #            SELECT MAX(rvv09) INTO l_day FROM rvv_file,rvu_file,pmn_file 
   #             WHERE rvu01=rvv01
   #               AND pmn01=rvv36 AND pmn02=rvv37
   #               AND rvu00='1' AND rvuconf='Y'
   #               AND pmn41=sr.pmk01 
   #            IF NOT cl_null(l_day) AND l_day<=sr.pml35 THEN 
   #               LET sr.speed = '0'
   #            ELSE 
   #               LET sr.speed = '1'
   #            END IF 
   #         END IF 
   #      IF tm.b = 'N' THEN
   #         IF sr.pml20<sr.pmn53 THEN 
   #            CONTINUE FOREACH 
   #         END IF 
   #      END IF
   #      IF tm.c = 'N' THEN 
   #         IF sr.pml20=sr.pmn53 THEN 
   #            CONTINUE FOREACH 
   #         END IF 
   #      END IF
   #      IF tm.d = 'N' THEN 
   #         IF sr.pml20>sr.pmn53 THEN 
   #            CONTINUE FOREACH 
   #         END IF 
   #      END IF
   #      IF tm.h<>'2' AND tm.h<>sr.speed THEN 
   #         CONTINUE FOREACH 
   #      END IF
   #      IF tm.g<>'3' AND tm.g<>sr.state THEN 
   #         CONTINUE FOREACH 
   #      END IF
   #      INSERT INTO cpmq003_tmp VALUES(sr.*)
   #   END FOREACH 
   #free--mark--end--
   END IF 
      IF tm.h <> '2' THEN
         LET l_sql = " DELETE FROM cpmq003_tmp o ",
                     "  WHERE o.speed != '",tm.h,"' "
         PREPARE q775_pre38 FROM l_sql
         EXECUTE q775_pre38   
      END IF 
      IF tm.g <> '3' THEN
         LET l_sql = " DELETE FROM cpmq003_tmp o ",
                     "  WHERE o.state != '",tm.g,"' "
         PREPARE q775_pre39 FROM l_sql
         EXECUTE q775_pre39   
      END IF 
END FUNCTION 

FUNCTION q003_get_sum()
DEFINE     l_wc     STRING
DEFINE     l_sql    STRING
 
   CASE tm.a
      WHEN '1'   #单号
         LET l_sql = "SELECT pmk01,'','','','','','','','','','','', ",   
                     "       '','','','',pmm22, ",                   
                     "SUM(pml20),SUM(pml87),SUM(pml21),SUM(pmn88),SUM(pmn88t),SUM(pmn50),SUM(pmn55), ",
                     "SUM(pmn50a),SUM(pmn53),SUM(pmnud07),SUM(rvv39),SUM(rvv39t),SUM(rvv17),SUM(apb09),SUM(apb24) ",
                     " FROM cpmq003_tmp ",
                     " GROUP BY pmk01,pmm22",
                     " ORDER BY pmk01,pmm22 "
      WHEN '2'   #性质
         LET l_sql = "SELECT '',pmk02,'','','','','','','','','','', ",   
                     "       '','','','',pmm22, ",                   
                     "SUM(pml20),SUM(pml87),SUM(pml21),SUM(pmn88),SUM(pmn88t),SUM(pmn50),SUM(pmn55), ",
                     "SUM(pmn50a),SUM(pmn53),SUM(pmnud07),SUM(rvv39),SUM(rvv39t),SUM(rvv17),SUM(apb09),SUM(apb24) ",
                     " FROM cpmq003_tmp ",
                     " GROUP BY pmk02,pmm22",
                     " ORDER BY pmk02,pmm22 "
      WHEN '3'   #日期
         LET l_sql = "SELECT '','',pmk04,'','','','','','','','','', ",   
                     "       '','','','',pmm22, ",                   
                     "SUM(pml20),SUM(pml87),SUM(pml21),SUM(pmn88),SUM(pmn88t),SUM(pmn50),SUM(pmn55), ",
                     "SUM(pmn50a),SUM(pmn53),SUM(pmnud07),SUM(rvv39),SUM(rvv39t),SUM(rvv17),SUM(apb09),SUM(apb24) ",
                     " FROM cpmq003_tmp ",
                     " GROUP BY pmk04,pmm22",
                     " ORDER BY pmk04,pmm22 "
      WHEN '4'   #人员
         LET l_sql = "SELECT '','','',pmk12,gen02,'','','','','','','', ",   
                     "       '','','','',pmm22, ",                   
                     "SUM(pml20),SUM(pml87),SUM(pml21),SUM(pmn88),SUM(pmn88t),SUM(pmn50),SUM(pmn55), ",
                     "SUM(pmn50a),SUM(pmn53),SUM(pmnud07),SUM(rvv39),SUM(rvv39t),SUM(rvv17),SUM(apb09),SUM(apb24) ",
                     " FROM cpmq003_tmp ",
                     " GROUP BY pmk12,gen02,pmm22",
                     " ORDER BY pmk12,gen02,pmm22 "
      WHEN '5'   #部门
         LET l_sql = "SELECT '','','','','',pmk13,gem02,'','','','','', ",   
                     "       '','','','',pmm22, ",                   
                     "SUM(pml20),SUM(pml87),SUM(pml21),SUM(pmn88),SUM(pmn88t),SUM(pmn50),SUM(pmn55), ",
                     "SUM(pmn50a),SUM(pmn53),SUM(pmnud07),SUM(rvv39),SUM(rvv39t),SUM(rvv17),SUM(apb09),SUM(apb24) ",
                     " FROM cpmq003_tmp ",
                     " GROUP BY pmk13,gem02,pmm22",
                     " ORDER BY pmk13,gem02,pmm22 "
      WHEN '6'   #厂商
         LET l_sql = "SELECT '','','','','','','',pmk09,pmc03,'','','', ",   
                     "       '','','','',pmm22, ",                   
                     "SUM(pml20),SUM(pml87),SUM(pml21),SUM(pmn88),SUM(pmn88t),SUM(pmn50),SUM(pmn55), ",
                     "SUM(pmn50a),SUM(pmn53),SUM(pmnud07),SUM(rvv39),SUM(rvv39t),SUM(rvv17),SUM(apb09),SUM(apb24) ",
                     " FROM cpmq003_tmp ",
                     " GROUP BY pmk09,pmc03,pmm22 ",
                     " ORDER BY pmk09,pmc03,pmm22 "
      WHEN '7'   #料号
         LET l_sql = "SELECT '','','','','','','','','',pml04, ",   
                     "       pml041,ima021,'','','','',pmm22, ",                   
                     "SUM(pml20),SUM(pml87),SUM(pml21),SUM(pmn88),SUM(pmn88t),SUM(pmn50),SUM(pmn55), ",
                     "SUM(pmn50a),SUM(pmn53),SUM(pmnud07),SUM(rvv39),SUM(rvv39t),SUM(rvv17),SUM(apb09),SUM(apb24) ",
                     " FROM cpmq003_tmp ",
                     " GROUP BY pml04,pml041,ima021,pmm22",
                     " ORDER BY pml04,pml041,ima021,pmm22 "
      WHEN '8'   #项目编号
         LET l_sql = "SELECT '','','','','','','','','','', ",   
                     "       '','',pml12,pja02,'','',pmm22, ",  #TQC-CC0141 刪除pml121,pjb03                 
                     "SUM(pml20),SUM(pml87),SUM(pml21),SUM(pmn88),SUM(pmn88t),SUM(pmn50),SUM(pmn55), ",
                     "SUM(pmn50a),SUM(pmn53),SUM(pmnud07),SUM(rvv39),SUM(rvv39t),SUM(rvv17),SUM(apb09),SUM(apb24) ",
                     " FROM cpmq003_tmp ",
                     " GROUP BY pml12,pja02,pmm22 ",            #TQC-CC0141 刪除pml121,pjb03
                     " ORDER BY pml12,pja02,pmm22 "             #TQC-CC0141 刪除pml121,pjb03
   END CASE 

   PREPARE q003_pb FROM l_sql
   DECLARE q003_curs1 CURSOR FOR q003_pb
   FOREACH q003_curs1 INTO g_pmk_1[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(g_pmk_1[g_cnt].pml20_1)  THEN LET g_pmk_1[g_cnt].pml20_1=0 END IF 
      IF cl_null(g_pmk_1[g_cnt].pmn88_1)  THEN LET g_pmk_1[g_cnt].pmn88_1=0 END IF 
      IF cl_null(g_pmk_1[g_cnt].pmn88t_1) THEN LET g_pmk_1[g_cnt].pmn88t_1=0 END IF 
      LET g_pmk_qty =g_pmk_qty + g_pmk_1[g_cnt].pml20_1
      LET g_pmk_sum =g_pmk_sum + g_pmk_1[g_cnt].pmn88_1
      LET g_pmk_sum1=g_pmk_sum1+ g_pmk_1[g_cnt].pmn88t_1
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pmk_1.deleteElement(g_cnt)
   LET g_cnt = g_cnt - 1
   DISPLAY ARRAY g_pmk_1 TO s_pmk_1.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
 
   LET g_rec_b2 = g_cnt 
   DISPLAY g_rec_b2   TO FORMONLY.cnt1 
   DISPLAY g_pmk_qty  TO FORMONLY.tot_qty
   DISPLAY g_pmk_sum  TO FORMONLY.tot_sum
   DISPLAY g_pmk_sum1 TO FORMONLY.tot_sum1
END FUNCTION  

FUNCTION q003_detail_fill(p_ac)
DEFINE p_ac         LIKE type_file.num5,
       l_sql        STRING,
       l_tmp        STRING,  
       l_tmp2       STRING 

   IF cl_null(g_pmk_1[p_ac].pmm22_1) THEN 
      LET g_pmk_1[p_ac].pmm22_1=''
      LET l_tmp = " OR pmm22 IS NULL "
   ELSE 
      LET l_tmp = ''
   END IF 
   CASE tm.a 
      WHEN "1" 
         IF cl_null(g_pmk_1[p_ac].pmk01_1) THEN 
            LET g_pmk_1[p_ac].pmk01_1 = ''
            LET l_tmp2 = " OR pmk01 IS NULL "
         ELSE 
            LET l_tmp2 = ''
         END IF 
         LET l_sql = "SELECT * FROM cpmq003_tmp WHERE (pmk01='",g_pmk_1[p_ac].pmk01_1,"' ",l_tmp2," )",
                     " AND (pmm22 = '",g_pmk_1[p_ac].pmm22_1 CLIPPED ,"'",l_tmp," )", 
                     " ORDER BY pmk01,pmm22"
      WHEN "2"
         IF cl_null(g_pmk_1[p_ac].pmk02_1) THEN 
            LET g_pmk_1[p_ac].pmk02_1 = ''
            LET l_tmp2 = " OR pmk02 IS NULL "
         ELSE 
            LET l_tmp2 = ''
         END IF 
         LET l_sql = "SELECT * FROM cpmq003_tmp WHERE (pmk02='",g_pmk_1[p_ac].pmk02_1,"' ",l_tmp2," )",
                     " AND (pmm22 = '",g_pmk_1[p_ac].pmm22_1 CLIPPED ,"'",l_tmp," )",
                     " ORDER BY pmk02,pmm22"
      WHEN "3"
         IF cl_null(g_pmk_1[p_ac].pmk04_1) THEN 
            LET g_pmk_1[p_ac].pmk04_1 = ''
            LET l_tmp2 = " OR pmk04 IS NULL "
         ELSE 
            LET l_tmp2 = ''
         END IF 
         LET l_sql = "SELECT * FROM cpmq003_tmp WHERE (pmk04='",g_pmk_1[p_ac].pmk04_1,"' ",l_tmp2," )",
                     " AND (pmm22 = '",g_pmk_1[p_ac].pmm22_1 CLIPPED ,"'",l_tmp," )",
                     " ORDER BY pmk04,pmm22"
      WHEN "4"
         IF cl_null(g_pmk_1[p_ac].pmk12_1) THEN 
            LET g_pmk_1[p_ac].pmk12_1 = ''
            LET l_tmp2 = " OR pmk12 IS NULL "
         ELSE 
            LET l_tmp2 = ''
         END IF 
         LET l_sql = "SELECT * FROM cpmq003_tmp WHERE (pmk12='",g_pmk_1[p_ac].pmk12_1,"' ",l_tmp2," )",
                     " AND (pmm22 = '",g_pmk_1[p_ac].pmm22_1 CLIPPED ,"'",l_tmp," )",
                     " ORDER BY pmk12,pmm22"
      WHEN "5"
         IF cl_null(g_pmk_1[p_ac].pmk13_1) THEN 
            LET g_pmk_1[p_ac].pmk13_1 = ''
            LET l_tmp2 = " OR pmk13 IS NULL "
         ELSE 
            LET l_tmp2 = ''
         END IF 
         LET l_sql = "SELECT * FROM cpmq003_tmp WHERE (pmk13 = '",g_pmk_1[p_ac].pmk13_1,"' ",l_tmp2," )",
                     " AND (pmm22 = '",g_pmk_1[p_ac].pmm22_1 CLIPPED ,"'",l_tmp," )",
                     " ORDER BY pmk13,pmm22"
      WHEN "6"
         IF cl_null(g_pmk_1[p_ac].pmk09_1) THEN 
            LET g_pmk_1[p_ac].pmk09_1 = ''
            LET l_tmp2 = " OR pmk09 IS NULL "
         ELSE 
            LET l_tmp2 = ''
         END IF 
         LET l_sql = "SELECT * FROM cpmq003_tmp WHERE (pmk09 = '",g_pmk_1[p_ac].pmk09_1,"' ",l_tmp2," )",
                     " AND (pmm22 = '",g_pmk_1[p_ac].pmm22_1 CLIPPED ,"'",l_tmp," )",
                     " ORDER BY pmk09,pmm22"
      WHEN "7"
         IF cl_null(g_pmk_1[p_ac].pml04_1) THEN 
            LET g_pmk_1[p_ac].pml04_1 = ''
            LET l_tmp2 = " OR pml04 IS NULL "
         ELSE 
            LET l_tmp2 = ''
         END IF 
         LET l_sql = "SELECT * FROM cpmq003_tmp WHERE (pml04 = '",g_pmk_1[p_ac].pml04_1,"' ",l_tmp2," )",
                     " AND (pmm22 = '",g_pmk_1[p_ac].pmm22_1 CLIPPED ,"'",l_tmp," )",
                     " ORDER BY pml04,pmm22"
      WHEN "8"
         IF cl_null(g_pmk_1[p_ac].pml12_1) THEN 
            LET g_pmk_1[p_ac].pml12_1 = ''
            LET l_tmp2 = " OR pml12 IS NULL "
         ELSE 
            LET l_tmp2 = ''
         END IF 
         LET l_sql = "SELECT * FROM cpmq003_tmp WHERE (pml12 = '",g_pmk_1[p_ac].pml12_1,"' ",l_tmp2," )",
                     " AND (pmm22 = '",g_pmk_1[p_ac].pmm22_1 CLIPPED ,"'",l_tmp," )",
                     " ORDER BY pml12,pmm22"
   END CASE

      PREPARE cpmq003_pb_detail FROM l_sql
      DECLARE pmk_curs_detail  CURSOR FOR cpmq003_pb_detail        #CURSOR
      CALL g_pmk.clear()
      CALL g_pmk_excel.clear()
      LET g_cnt = 1
      LET g_rec_b = 0
      LET g_pmk_qty =0
      LET g_pmk_sum =0
      LET g_pmk_sum1=0
      FOREACH pmk_curs_detail INTO g_pmk_excel[g_cnt].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF cl_null(g_pmk_excel[g_cnt].pml20) THEN LET g_pmk_excel[g_cnt].pml20=0 END IF
         IF cl_null(g_pmk_excel[g_cnt].pmn88) THEN LET g_pmk_excel[g_cnt].pmn88=0 END IF
         IF cl_null(g_pmk_excel[g_cnt].pmn88t) THEN LET g_pmk_excel[g_cnt].pmn88t=0 END IF 
         LET g_pmk_qty =g_pmk_qty + g_pmk_excel[g_cnt].pml20
         LET g_pmk_sum =g_pmk_sum + g_pmk_excel[g_cnt].pmn88
         LET g_pmk_sum1=g_pmk_sum1+ g_pmk_excel[g_cnt].pmn88t
         IF g_cnt <= g_max_rec THEN
            LET g_pmk[g_cnt].* = g_pmk_excel[g_cnt].*
         END IF
         LET g_cnt = g_cnt + 1  
      END FOREACH
      IF g_cnt <= g_max_rec THEN
         CALL g_pmk.deleteElement(g_cnt)
      END IF
      CALL g_pmk_excel.deleteElement(g_cnt)
      LET g_rec_b = g_cnt -1
      IF g_rec_b > g_max_rec THEN
         CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
         LET g_rec_b = g_max_rec
      END IF
      DISPLAY g_rec_b TO FORMONLY.cnt  
END FUNCTION 

FUNCTION q003_set_visible()
CALL cl_set_comp_visible("pmk01_1,pmk02_1,pmk04_1,pmk12_1,gen02_1,pmk13_1,gem02_1,",TRUE)
CALL cl_set_comp_visible("pmk09_1,pmc03_1,pml04_1,pml041_1,ima021_1,pml12_1,pja02_1,pml121_1,pjb03_1",TRUE)
CALL cl_set_comp_visible("pml87,pml87_1,pml41,pml41_1",TRUE)
CALL cl_set_comp_visible("pmk13,gem02,pml87,pml41,pml16,pml12,pml121",TRUE)
CALL cl_set_comp_visible("pmk13_1,gem02_1,pml87_1,pml41_1",TRUE)
CALL cl_set_comp_visible("pmk13_2,gem02_2",TRUE)


IF cl_null(tm.a) THEN LET tm.a = 6 END IF 
CASE tm.a 
   WHEN "1"
      CALL cl_set_comp_visible("pmk02_1,pmk04_1,pmk12_1,gen02_1,pmk13_1,gem02_1,",FALSE)
      CALL cl_set_comp_visible("pmk09_1,pmc03_1,pml04_1,pml041_1,ima021_1,pml12_1,pja02_1,pml121_1,pjb03_1",FALSE)
   WHEN "2"
      CALL cl_set_comp_visible("pmk01_1,pmk04_1,pmk12_1,gen02_1,pmk13_1,gem02_1,",FALSE)
      CALL cl_set_comp_visible("pmk09_1,pmc03_1,pml04_1,pml041_1,ima021_1,pml12_1,pja02_1,pml121_1,pjb03_1",FALSE)
   WHEN "3"
      CALL cl_set_comp_visible("pmk01_1,pmk02_1,pmk12_1,gen02_1,pmk13_1,gem02_1,",FALSE)
      CALL cl_set_comp_visible("pmk09_1,pmc03_1,pml04_1,pml041_1,ima021_1,pml12_1,pja02_1,pml121_1,pjb03_1",FALSE)
   WHEN "4"
      CALL cl_set_comp_visible("pmk01_1,pmk02_1,pmk04_1,pmk13_1,gem02_1,",FALSE)
      CALL cl_set_comp_visible("pmk09_1,pmc03_1,pml04_1,pml041_1,ima021_1,pml12_1,pja02_1,pml121_1,pjb03_1",FALSE)
   WHEN "5"
      CALL cl_set_comp_visible("pmk01_1,pmk02_1,pmk04_1,pmk12_1,gen02_1,",FALSE)
      CALL cl_set_comp_visible("pmk09_1,pmc03_1,pml04_1,pml041_1,ima021_1,pml12_1,pja02_1,pml121_1,pjb03_1",FALSE)
   WHEN "6"
      CALL cl_set_comp_visible("pmk01_1,pmk02_1,pmk04_1,pmk12_1,gen02_1,pmk13_1,gem02_1,",FALSE)
      CALL cl_set_comp_visible("pml04_1,pml041_1,ima021_1,pml12_1,pja02_1,pml121_1,pjb03_1",FALSE)
   WHEN "7"
      CALL cl_set_comp_visible("pmk01_1,pmk02_1,pmk04_1,pmk12_1,gen02_1,pmk13_1,gem02_1,",FALSE)
      CALL cl_set_comp_visible("pmk09_1,pmc03_1,pml12_1,pja02_1,pml121_1,pjb03_1",FALSE)
   WHEN "8"
      CALL cl_set_comp_visible("pmk01_1,pmk02_1,pmk04_1,pmk12_1,gen02_1,pmk13_1,gem02_1,",FALSE)
      CALL cl_set_comp_visible("pmk09_1,pmc03_1,pml04_1,pml041_1,ima021_1,pml121_1,pjb03_1",FALSE)  #TQC-CC0141
END CASE

CASE g_pname
   WHEN '2'
      CALL cl_set_comp_visible("pml87,pml87_1,pml41,pml41_1",FALSE)
   WHEN '3'
      CALL cl_set_comp_visible("pmk13,gem02,pml87,pml41,pml16,pml12,pml121",FALSE)
      CALL cl_set_comp_visible("pmk13_1,gem02_1,pml87_1,pml41_1",FALSE)
      CALL cl_set_comp_visible("pmk13_2,gem02_2,pja02,pjb03",FALSE)
   OTHERWISE EXIT CASE 
END CASE 

#add  显示控制 ly180502
 IF  g_grup<>'B05'   THEN 
    CALL cl_set_comp_visible("pmn31t_1,rvv39_1,rvv39t_1,apb24_1",FALSE)
 END IF 
END FUNCTION 

FUNCTION q003_bp3()
   DEFINE   p_ud   LIKE type_file.chr1        

   LET g_action_choice = " "
   LET g_action_flag = "page3"
   DISPLAY BY NAME g_head.pmk01_2,g_head.pmk02_2,g_head.pmk09_2,g_head.pmc03_2,
                   g_head.pmk04_2,g_head.pmk18_2,g_head.pmk12_2,g_head.gen02_2,
                   g_head.pmk13_2,g_head.gem02_2,g_head.pmm22_2,g_head.pmm42_2,   
                   g_head.pmm43_2,g_head.gec07_2,g_head.pml87_2,g_head.pmn53_2, 
                   g_head.pmkpro_2
   CASE g_b_flag2
      WHEN 1
        CALL q003_bp_pr()
      WHEN 2
        CALL q003_bp_po()
      WHEN 3
        CALL q003_bp_chu()
      WHEN 4
        CALL q003_bp_qc()
      WHEN 5
        CALL q003_bp_rv()
      WHEN 6
        CALL q003_bp_rv_y()
      WHEN 7
        CALL q003_bp_rv_c()
      WHEN 8
        CALL q003_bp_ap()
      OTHERWISE
         CASE g_pname 
            WHEN '2'  CALL q003_bp_po()
            WHEN '3'  CALL q003_bp_chu()
            OTHERWISE CALL q003_bp_pr()
         END CASE 
   END CASE

END FUNCTION

FUNCTION q003_bp_pr()
   LET g_action_choice = " "
   CASE g_b_flag3
      WHEN 1
        CALL q003_bp_pmk()
      WHEN 2
        CALL q003_bp_pml()
      OTHERWISE
        CALL q003_bp_pmk()
   END CASE

END FUNCTION

FUNCTION q003_bp_po()
   LET g_action_choice = " "
   CASE g_b_flag3
      WHEN 1
        CALL q003_bp_pmm()
      WHEN 2
        CALL q003_bp_pmn()
      OTHERWISE
        CALL q003_bp_pmm()
   END CASE

END FUNCTION

FUNCTION q003_bp_chu()
   LET g_action_choice = " "
   CASE g_b_flag3
      WHEN 1
        CALL q003_bp_rva()
      WHEN 2
        CALL q003_bp_rvb()
      OTHERWISE
        CALL q003_bp_rva()
   END CASE

END FUNCTION

FUNCTION q003_bp_qc()
   LET g_action_choice = " "
   CASE g_b_flag3
      WHEN 1
        CALL q003_bp_qcs()
      WHEN 2
        CALL q003_bp_qct()
      OTHERWISE
        CALL q003_bp_qcs()
   END CASE

END FUNCTION

FUNCTION q003_bp_rv()
   LET g_action_choice = " "
   CASE g_b_flag3
      WHEN 1
        CALL q003_bp_rvu()
      WHEN 2
        CALL q003_bp_rvv()
      OTHERWISE
        CALL q003_bp_rvu()
   END CASE

END FUNCTION

FUNCTION q003_bp_rv_y()
   LET g_action_choice = " "
   CASE g_b_flag3
      WHEN 1
        CALL q003_bp_rvu_y()
      WHEN 2
        CALL q003_bp_rvv_y()
      OTHERWISE
        CALL q003_bp_rvu_y()
   END CASE

END FUNCTION

FUNCTION q003_bp_rv_c()
   LET g_action_choice = " "
   CASE g_b_flag3
      WHEN 1
        CALL q003_bp_rvu_c()
      WHEN 2
        CALL q003_bp_rvv_c()
      OTHERWISE
        CALL q003_bp_rvu_c()
   END CASE

END FUNCTION

FUNCTION q003_bp_ap()
   LET g_action_choice = " "
   CASE g_b_flag3
      WHEN 1
        CALL q003_bp_apa()
      WHEN 2
        CALL q003_bp_apb()
      OTHERWISE
        CALL q003_bp_apa()
   END CASE

END FUNCTION

FUNCTION q003_bp_pmk()
   LET g_action_choice = " "
   DISPLAY g_rec_b_pmk TO FORMONLY.cn2
   CALL cl_set_comp_visible("pml", FALSE)
   CALL ui.interface.refresh()
   CALL cl_set_comp_visible("pml", TRUE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_pmk01_change_pml = '1' OR g_pml02_change_pml = '1' THEN
      LET g_pmk01_change_pml = '0' 
      LET g_pml02_change_pml = '0'
      #CALL cl_set_comp_visible("page8", FALSE)
      CALL  g_pml.clear()
      INITIALIZE g_head_pml.* TO NULL 
      LET g_rec_b_pml = ''
      #DISPLAY g_rec_b_pml TO FORMONLY.cn2
      DISPLAY g_head_pml.pml01 TO FORMONLY.pml01
      DISPLAY g_head_pml.pmk04_pml TO FORMONLY.pmk04_pml
      DISPLAY g_head_pml.pmk09_pml TO FORMONLY.pmk09_pml
      DISPLAY g_head_pml.pmc03_pml TO FORMONLY.pmc03_pml
      DISPLAY g_head_pml.pmk12_pml TO FORMONLY.pmk12_pml
      DISPLAY ARRAY g_pml TO s_pml.* ATTRIBUTE(COUNT=g_rec_b_pml)
         BEFORE DISPLAY
            EXIT DISPLAY 
      END DISPLAY
      #CALL ui.interface.refresh()
      #CALL cl_set_comp_visible("page8", TRUE)
   END IF
   DISPLAY ARRAY g_pmk_2 TO s_pmk_2.* ATTRIBUTE(COUNT=g_rec_b_pmk)

      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY 
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.h,tm.g
      FROM a,b,c,d,h,g ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q003_b_fill_2()
            CALL q003_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q003_b_fill()
            CALL g_pmk_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,h,g
         CALL q003()
         CALL q003_b_fill()
         CALL q003_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_pmk_2 TO s_pmk_2.* ATTRIBUTE(COUNT=g_rec_b_pmk)

      BEFORE DISPLAY
         IF l_ac_pmk != 0 THEN
            CALL fgl_set_arr_curr(l_ac_pmk)
         END IF

      BEFORE ROW
        LET l_ac_pmk = ARR_CURR()
      CALL cl_show_fld_cont()
   END DISPLAY 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()     
         EXIT DIALOG
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION cancel
             LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about    
         CALL cl_about() 
      ON ACTION page1
         LET g_action_choice = "page1"
         EXIT DIALOG
      ON ACTION page2
         LET g_action_choice = "page2"
         EXIT DIALOG
      ON ACTION pml
         LET l_ac_pmk = ARR_CURR()
         IF l_ac_pmk > 0 THEN
            LET g_head_pml.pml01 = g_pmk_2[l_ac_pmk].pmk01
            LET g_head_pml.pmk04_pml = g_pmk_2[l_ac_pmk].pmk04
            LET g_head_pml.pmk09_pml = g_pmk_2[l_ac_pmk].pmk09
            LET g_head_pml.pmc03_pml = g_pmk_2[l_ac_pmk].pmc03_pmk
            LET g_head_pml.pmk12_pml = g_pmk_2[l_ac_pmk].pmk12
            LET g_head_pml.gen02_pml = g_pmk_2[l_ac_pmk].gen02_pmk
            LET g_b_flag3 = 2
            LET g_action_choice = "pml"
         END IF
         EXIT DIALOG

      ON ACTION po
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG

      ON ACTION chu
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "rva"
         EXIT DIALOG
      ON ACTION qc
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "qcs"
         EXIT DIALOG 
      ON ACTION rv
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu"
         EXIT DIALOG  
      ON ACTION rv_y
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_y"
         EXIT DIALOG  
      ON ACTION rv_c
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_c"
         EXIT DIALOG  
      ON ACTION ap
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "apa"
         EXIT DIALOG    
      AFTER DIALOG
         CONTINUE DIALOG

END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q003_bp_pml()
   LET g_action_choice = " "
   DISPLAY g_rec_b_pml TO FORMONLY.cn2
   DISPLAY g_head_pml.pml01 TO FORMONLY.pml01
   DISPLAY g_head_pml.pmk04_pml TO FORMONLY.pmk04_pml
   DISPLAY g_head_pml.pmk09_pml TO FORMONLY.pmk09_pml
   DISPLAY g_head_pml.pmc03_pml TO FORMONLY.pmc03_pml
   DISPLAY g_head_pml.pmk12_pml TO FORMONLY.pmk12_pml
   DISPLAY g_head_pml.gen02_pml TO FORMONLY.gen02_pml
      CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pml TO s_pml.* ATTRIBUTE(COUNT=g_rec_b_pml)

      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.h,tm.g
      FROM a,b,c,d,h,g ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q003_b_fill_2()
            CALL q003_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q003_b_fill()
            CALL g_pmk_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,h,g
         CALL q003()
         CALL q003_b_fill()
         CALL q003_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_pml TO s_pml.* ATTRIBUTE(COUNT=g_rec_b_pml)

      BEFORE DISPLAY
         IF l_ac_pml != 0 THEN
            CALL fgl_set_arr_curr(l_ac_pml)
         END IF

      BEFORE ROW
        LET l_ac_pml = ARR_CURR()
      CALL cl_show_fld_cont()
   END DISPLAY 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()  
         EXIT DIALOG
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION cancel
             LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about      
         CALL cl_about()   
      ON ACTION page1
         LET g_action_choice = "page1"
         EXIT DIALOG
      ON ACTION page2
         LET g_action_choice = "page2"
         EXIT DIALOG
      ON ACTION pmk
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG

      ON ACTION po
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG

      ON ACTION chu
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "rva"
         EXIT DIALOG
      ON ACTION qc
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "qcs"
         EXIT DIALOG  
      ON ACTION rv
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu"
         EXIT DIALOG  
      ON ACTION rv_y
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_y"
         EXIT DIALOG  
      ON ACTION rv_c
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_c"
         EXIT DIALOG  
      ON ACTION ap
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "apa"
         EXIT DIALOG    
      AFTER DIALOG
         CONTINUE DIALOG

END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q003_bp_pmm()
   LET g_action_choice = " "
   DISPLAY g_rec_b_pmm TO FORMONLY.cn2
   CALL cl_set_comp_visible("pmn", FALSE)
   CALL ui.interface.refresh()
   CALL cl_set_comp_visible("pmn", TRUE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_pmk01_change_pmn = '1' OR g_pml02_change_pmn = '1' THEN
      LET g_pmk01_change_pmn = '0' 
      LET g_pml02_change_pmn = '0'
      #CALL cl_set_comp_visible("page11", FALSE)
      CALL  g_pmn.clear()
      INITIALIZE g_head_pmn.* TO NULL 
      LET g_rec_b_pmn = ''
      #DISPLAY g_rec_b_pmn TO FORMONLY.cn2
      DISPLAY g_head_pmn.pmm01_pmn TO FORMONLY.pmm01_pmn
      DISPLAY g_head_pmn.pmm04_pmn TO FORMONLY.pmm04_pmn
      DISPLAY g_head_pmn.pmm09_pmn TO FORMONLY.pmm09_pmn
      DISPLAY g_head_pmn.pmc03_pmn TO FORMONLY.pmc03_pmn
      DISPLAY g_head_pmn.pmm12_pmn TO FORMONLY.pmm12_pmn
      DISPLAY g_head_pmn.gen02_pmn TO FORMONLY.gen02_pmn
      DISPLAY ARRAY g_pmn TO s_pmn.* ATTRIBUTE(COUNT=g_rec_b_pmn)
      BEFORE DISPLAY
         EXIT DISPLAY 
      END DISPLAY
      #CALL ui.interface.refresh()
      #CALL cl_set_comp_visible("page11", TRUE)
   END IF
   DISPLAY ARRAY g_pmm TO s_pmm.* ATTRIBUTE(COUNT=g_rec_b_pmm)

      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.h,tm.g
      FROM a,b,c,d,h,g ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q003_b_fill_2()
            CALL q003_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q003_b_fill()
            CALL g_pmk_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,h,g
         CALL q003()
         CALL q003_b_fill()
         CALL q003_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_pmm TO s_pmm.* ATTRIBUTE(COUNT=g_rec_b_pmm)

      BEFORE DISPLAY
         IF l_ac_pmm != 0 THEN
            CALL fgl_set_arr_curr(l_ac_pmm)
         END IF

      BEFORE ROW
        LET l_ac_pmm = ARR_CURR()
      CALL cl_show_fld_cont()
   END DISPLAY 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()    
         EXIT DIALOG
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION cancel
             LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about       
         CALL cl_about()   
      ON ACTION page1
         LET g_action_choice = "page1"
         EXIT DIALOG
      ON ACTION page2
         LET g_action_choice = "page2"
         EXIT DIALOG
      ON ACTION pmn
         LET l_ac_pmm = ARR_CURR()
         IF l_ac_pmm > 0 THEN
            LET g_head_pmn.pmm01_pmn = g_pmm[l_ac_pmm].pmm01
            LET g_head_pmn.pmm04_pmn = g_pmm[l_ac_pmm].pmm04
            LET g_head_pmn.pmm09_pmn = g_pmm[l_ac_pmm].pmm09
            LET g_head_pmn.pmc03_pmn = g_pmm[l_ac_pmm].pmc03_pmm
            LET g_head_pmn.pmm12_pmn = g_pmm[l_ac_pmm].pmm12
            LET g_head_pmn.gen02_pmn = g_pmm[l_ac_pmm].gen02_pmm
            LET g_b_flag3 = 2
            LET g_action_choice = "pmn"
         END IF
         EXIT DIALOG

      ON ACTION pr
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG

      ON ACTION chu
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "rva"
         EXIT DIALOG
      ON ACTION qc
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "qcs"
         EXIT DIALOG    
      ON ACTION rv
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu"
         EXIT DIALOG  
      ON ACTION rv_y
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_y"
         EXIT DIALOG  
      ON ACTION rv_c
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_c"
         EXIT DIALOG  
      ON ACTION ap
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "apa"
         EXIT DIALOG    
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q003_bp_pmn()
   LET g_action_choice = " "
   DISPLAY g_rec_b_pmn TO FORMONLY.cn2
   DISPLAY g_head_pmn.pmm01_pmn TO FORMONLY.pmm01_pmn
   DISPLAY g_head_pmn.pmm04_pmn TO FORMONLY.pmm04_pmn
   DISPLAY g_head_pmn.pmm09_pmn TO FORMONLY.pmm09_pmn
   DISPLAY g_head_pmn.pmc03_pmn TO FORMONLY.pmc03_pmn
   DISPLAY g_head_pmn.pmm12_pmn TO FORMONLY.pmm12_pmn
   DISPLAY g_head_pmn.gen02_pmn TO FORMONLY.gen02_pmn
      CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmn TO s_pmn.* ATTRIBUTE(COUNT=g_rec_b_pmn)

      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.h,tm.g
      FROM a,b,c,d,h,g ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q003_b_fill_2()
            CALL q003_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q003_b_fill()
            CALL g_pmk_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,h,g
         CALL q003()
         CALL q003_b_fill()
         CALL q003_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_pmn TO s_pmn.* ATTRIBUTE(COUNT=g_rec_b_pmn)

      BEFORE DISPLAY
         IF l_ac_pmn != 0 THEN
            CALL fgl_set_arr_curr(l_ac_pmn)
         END IF

      BEFORE ROW
        LET l_ac_pmn = ARR_CURR()
      CALL cl_show_fld_cont()
   END DISPLAY 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()              
         EXIT DIALOG
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION cancel
             LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about      
         CALL cl_about()    
      ON ACTION page1
         LET g_action_choice = "page1"
         EXIT DIALOG
      ON ACTION page2
         LET g_action_choice = "page2"
         EXIT DIALOG
      ON ACTION pmm
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG

      ON ACTION pr
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG

      ON ACTION chu
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "rva"
         EXIT DIALOG
      ON ACTION qc
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "qcs"
         EXIT DIALOG 
      ON ACTION rv
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu"
         EXIT DIALOG  
      ON ACTION rv_y
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_y"
         EXIT DIALOG  
      ON ACTION rv_c
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_c"
         EXIT DIALOG  
      ON ACTION ap
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "apa"
         EXIT DIALOG    
      AFTER DIALOG
         CONTINUE DIALOG

END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q003_bp_rva()
   LET g_action_choice = " "
   DISPLAY g_rec_b_rva TO FORMONLY.cn2
   CALL cl_set_comp_visible("rvb", FALSE)
   CALL ui.interface.refresh()
   CALL cl_set_comp_visible("rvb", TRUE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_pmk01_change_rvb = '1' THEN
      LET g_pmk01_change_rvb = '0' 
      #CALL cl_set_comp_visible("page21_1", FALSE)
      CALL  g_rvb.clear()   
      INITIALIZE g_head_rvb.* TO NULL
      LET g_rec_b_rvb = ''
      #DISPLAY g_rec_b_rvb TO FORMONLY.cn2
      DISPLAY g_head_rvb.rva01_rvb TO FORMONLY.rva01_rvb
      DISPLAY g_head_rvb.rva05_rvb TO FORMONLY.rva05_rvb
      DISPLAY g_head_rvb.pmc03_rvb TO FORMONLY.pmc03_rvb
      DISPLAY g_head_rvb.rva06_rvb TO FORMONLY.rva06_rvb
      DISPLAY g_head_rvb.rva33_rvb TO FORMONLY.rva33_rvb
      DISPLAY g_head_rvb.gen02_rvb TO FORMONLY.gen02_rvb
      DISPLAY g_head_rvb.rvaconf_rvb TO FORMONLY.rvaconf_rvb 
      DISPLAY ARRAY g_rvb TO s_rvb.* ATTRIBUTE(COUNT=g_rec_b_rvb)
         BEFORE DISPLAY
            EXIT DISPLAY 
      END DISPLAY
      #CALL ui.interface.refresh()
      #CALL cl_set_comp_visible("page21_1", TRUE)
   END IF
   DISPLAY ARRAY g_rva TO s_rva.* ATTRIBUTE(COUNT=g_rec_b_rva)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.h,tm.g
      FROM a,b,c,d,h,g ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q003_b_fill_2()
            CALL q003_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q003_b_fill()
            CALL g_pmk_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,h,g
         CALL q003()
         CALL q003_b_fill()
         CALL q003_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_rva TO s_rva.* ATTRIBUTE(COUNT=g_rec_b_rva)

      BEFORE DISPLAY
         IF l_ac_rva != 0 THEN
            CALL fgl_set_arr_curr(l_ac_rva)
         END IF

      BEFORE ROW
        LET l_ac_rva = ARR_CURR()
      CALL cl_show_fld_cont()
   END DISPLAY 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()             
         EXIT DIALOG
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION cancel
             LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about    
         CALL cl_about() 
      ON ACTION page1
         LET g_action_choice = "page1"
         EXIT DIALOG
      ON ACTION page2
         LET g_action_choice = "page2"
         EXIT DIALOG
      ON ACTION rvb
         LET l_ac_rva = ARR_CURR()
         IF l_ac_rva > 0 THEN
            LET g_head_rvb.rva01_rvb = g_rva[l_ac_rva].rva01
            LET g_head_rvb.rva05_rvb = g_rva[l_ac_rva].rva05
            LET g_head_rvb.pmc03_rvb = g_rva[l_ac_rva].pmc03_rva
            LET g_head_rvb.rva06_rvb = g_rva[l_ac_rva].rva06
            LET g_head_rvb.rva33_rvb = g_rva[l_ac_rva].rva33
            LET g_head_rvb.gen02_rvb = g_rva[l_ac_rva].gen02_rva
            LET g_head_rvb.rvaconf_rvb = g_rva[l_ac_rva].rvaconf
            LET g_b_flag3 = 2
            LET g_action_choice = "rvb"
         END IF
         EXIT DIALOG

      ON ACTION pr
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG

      ON ACTION qc
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "qcs"
         EXIT DIALOG   
      ON ACTION rv
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu"
         EXIT DIALOG  
      ON ACTION rv_y
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_y"
         EXIT DIALOG  
      ON ACTION rv_c
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_c"
         EXIT DIALOG  
      ON ACTION ap
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "apa"
         EXIT DIALOG    
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q003_bp_rvb()
   LET g_action_choice = " "
   DISPLAY g_rec_b_rvb TO FORMONLY.cn2
      DISPLAY g_head_rvb.rva01_rvb TO FORMONLY.rva01_rvb
      DISPLAY g_head_rvb.rva05_rvb TO FORMONLY.rva05_rvb
      DISPLAY g_head_rvb.pmc03_rvb TO FORMONLY.pmc03_rvb
      DISPLAY g_head_rvb.rva06_rvb TO FORMONLY.rva06_rvb
      DISPLAY g_head_rvb.rva33_rvb TO FORMONLY.rva33_rvb
      DISPLAY g_head_rvb.gen02_rvb TO FORMONLY.gen02_rvb
      DISPLAY g_head_rvb.rvaconf_rvb TO FORMONLY.rvaconf_rvb 
      CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvb TO s_rvb.* ATTRIBUTE(COUNT=g_rec_b_rvb)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.h,tm.g
      FROM a,b,c,d,h,g ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q003_b_fill_2()
            CALL q003_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q003_b_fill()
            CALL g_pmk_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,h,g
         CALL q003()
         CALL q003_b_fill()
         CALL q003_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_rvb TO s_rvb.* ATTRIBUTE(COUNT=g_rec_b_rvb)

      BEFORE DISPLAY
         IF l_ac_rvb != 0 THEN
            CALL fgl_set_arr_curr(l_ac_rvb)
         END IF

      BEFORE ROW
        LET l_ac_rvb = ARR_CURR()
      CALL cl_show_fld_cont()
   END DISPLAY 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()     
         EXIT DIALOG
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION cancel
             LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about      
         CALL cl_about()    
      ON ACTION page1
         LET g_action_choice = "page1"
         EXIT DIALOG
      ON ACTION page2
         LET g_action_choice = "page2"
         EXIT DIALOG
      ON ACTION rva
         LET g_b_flag3 = 1
         LET g_action_choice = "rva"
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION qc
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "qcs"
         EXIT DIALOG
      ON ACTION rv
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu"
         EXIT DIALOG  
      ON ACTION rv_y
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_y"
         EXIT DIALOG  
      ON ACTION rv_c
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_c"
         EXIT DIALOG  
      ON ACTION ap
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "apa"
         EXIT DIALOG    
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q003_bp_qcs()
   LET g_action_choice = " "
   DISPLAY g_rec_b_qcs TO FORMONLY.cn2
   CALL cl_set_comp_visible("qct", FALSE)
   CALL ui.interface.refresh()
   CALL cl_set_comp_visible("qct", TRUE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_pmk01_change_qct = '1' THEN
      LET g_pmk01_change_qct = '0' 
      #CALL cl_set_comp_visible("page28", FALSE)
      CALL  g_qct.clear()   
      INITIALIZE g_head_qct.* TO NULL
      LET g_rec_b_qct = ''
      #DISPLAY g_rec_b_qct TO FORMONLY.cn2
      DISPLAY g_head_qct.qcs01_qct TO FORMONLY.qcs01_qct
      DISPLAY g_head_qct.qcs02_qct TO FORMONLY.qcs02_qct
      DISPLAY g_head_qct.qcs05_qct TO FORMONLY.qcs05_qct
      DISPLAY g_head_qct.qcs021_qct TO FORMONLY.qcs021_qct
      DISPLAY g_head_qct.ima02_qct TO FORMONLY.ima02_qct
      DISPLAY g_head_qct.ima021_qct TO FORMONLY.ima021_qct
      DISPLAY g_head_qct.qcs03_qct TO FORMONLY.qcs03_qct
      DISPLAY g_head_qct.pmc03_qct TO FORMONLY.pmc03_qct
      DISPLAY g_head_qct.qcs091_qct TO FORMONLY.qcs091_qct
      DISPLAY g_head_qct.qcs09_qct TO FORMONLY.qcs09_qct
      DISPLAY g_head_qct.des_qct   TO FORMONLY.des_qct
      DISPLAY g_head_qct.qcs13_qct TO FORMONLY.qcs13_qct
      DISPLAY g_head_qct.gen02_qct TO FORMONLY.gen02_qct
      DISPLAY g_head_qct.qcs14_qct TO FORMONLY.qcs14_qct
      DISPLAY ARRAY g_qct TO s_qct.* ATTRIBUTE(COUNT=g_rec_b_qct)
         BEFORE DISPLAY
            EXIT DISPLAY 
      END DISPLAY
      #CALL ui.interface.refresh()
      #CALL cl_set_comp_visible("page28", TRUE)
   END IF
   DISPLAY ARRAY g_qcs TO s_qcs.* ATTRIBUTE(COUNT=g_rec_b_qcs)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.h,tm.g
      FROM a,b,c,d,h,g ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q003_b_fill_2()
            CALL q003_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q003_b_fill()
            CALL g_pmk_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,h,g
         CALL q003()
         CALL q003_b_fill()
         CALL q003_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_qcs TO s_qcs.* ATTRIBUTE(COUNT=g_rec_b_qcs)

      BEFORE DISPLAY
         IF l_ac_qcs != 0 THEN
            CALL fgl_set_arr_curr(l_ac_qcs)
         END IF

      BEFORE ROW
        LET l_ac_qcs = ARR_CURR()
      CALL cl_show_fld_cont()
   END DISPLAY 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                
         EXIT DIALOG
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION cancel
             LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about      
         CALL cl_about()   
      ON ACTION page1
         LET g_action_choice = "page1"
         EXIT DIALOG
      ON ACTION page2
         LET g_action_choice = "page2"
         EXIT DIALOG
      ON ACTION qct
         LET l_ac_qcs = ARR_CURR()
         IF l_ac_qcs > 0 THEN
            LET g_head_qct.qcs01_qct = g_qcs[l_ac_qcs].qcs01
            LET g_head_qct.qcs02_qct = g_qcs[l_ac_qcs].qcs02
            LET g_head_qct.qcs05_qct = g_qcs[l_ac_qcs].qcs05
            LET g_head_qct.qcs021_qct= g_qcs[l_ac_qcs].qcs021
            LET g_head_qct.ima02_qct = g_qcs[l_ac_qcs].ima02_qcs
            LET g_head_qct.ima021_qct = g_qcs[l_ac_qcs].ima021_qcs
            LET g_head_qct.qcs03_qct = g_qcs[l_ac_qcs].qcs03
            LET g_head_qct.pmc03_qct = g_qcs[l_ac_qcs].pmc03_qcs
            LET g_head_qct.qcs091_qct = g_qcs[l_ac_qcs].qcs091
            LET g_head_qct.qcs09_qct = g_qcs[l_ac_qcs].qcs09
            LET g_head_qct.qcs13_qct = g_qcs[l_ac_qcs].qcs13
            LET g_head_qct.gen02_qct = g_qcs[l_ac_qcs].gen02_qcs
            LET g_head_qct.qcs14_qct = g_qcs[l_ac_qcs].qcs14
            CASE g_head_qct.qcs09_qct
               WHEN '1' 
                  CALL cl_getmsg('aqc-004',g_lang) RETURNING g_head_qct.des_qct
               WHEN '2'
                  CALL cl_getmsg('apm-244',g_lang) RETURNING g_head_qct.des_qct
               WHEN '3'
                  CALL cl_getmsg('aqc-006',g_lang) RETURNING g_head_qct.des_qct
            END CASE
            LET g_b_flag3 = 2
            LET g_action_choice = "qct"
         END IF
         EXIT DIALOG

      ON ACTION pr
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG

      ON ACTION chu
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "rva"
         EXIT DIALOG    
      ON ACTION rv
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu"
         EXIT DIALOG  
      ON ACTION rv_y
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_y"
         EXIT DIALOG  
      ON ACTION rv_c
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_c"
         EXIT DIALOG  
      ON ACTION ap
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "apa"
         EXIT DIALOG    
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q003_bp_qct()
   LET g_action_choice = " "
   DISPLAY g_rec_b_qct TO FORMONLY.cn2
   DISPLAY g_head_qct.qcs01_qct TO FORMONLY.qcs01_qct
   DISPLAY g_head_qct.qcs02_qct TO FORMONLY.qcs02_qct
   DISPLAY g_head_qct.qcs05_qct TO FORMONLY.qcs05_qct
   DISPLAY g_head_qct.qcs021_qct TO FORMONLY.qcs021_qct
   DISPLAY g_head_qct.ima02_qct TO FORMONLY.ima02_qct
   DISPLAY g_head_qct.ima021_qct TO FORMONLY.ima021_qct
   DISPLAY g_head_qct.qcs03_qct TO FORMONLY.qcs03_qct
   DISPLAY g_head_qct.pmc03_qct TO FORMONLY.pmc03_qct
   DISPLAY g_head_qct.qcs091_qct TO FORMONLY.qcs091_qct
   DISPLAY g_head_qct.qcs09_qct TO FORMONLY.qcs09_qct
   DISPLAY g_head_qct.des_qct   TO FORMONLY.des_qct
   DISPLAY g_head_qct.qcs13_qct TO FORMONLY.qcs13_qct
   DISPLAY g_head_qct.gen02_qct TO FORMONLY.gen02_qct
   DISPLAY g_head_qct.qcs14_qct TO FORMONLY.qcs14_qct
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qct TO s_qct.* ATTRIBUTE(COUNT=g_rec_b_qct)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.h,tm.g
      FROM a,b,c,d,h,g ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q003_b_fill_2()
            CALL q003_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q003_b_fill()
            CALL g_pmk_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,h,g
         CALL q003()
         CALL q003_b_fill()
         CALL q003_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_qct TO s_qct.* ATTRIBUTE(COUNT=g_rec_b_qct)

      BEFORE DISPLAY
         IF l_ac_qct != 0 THEN
            CALL fgl_set_arr_curr(l_ac_qct)
         END IF

      BEFORE ROW
        LET l_ac_qct = ARR_CURR()
      CALL cl_show_fld_cont()
   END DISPLAY 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()               
         EXIT DIALOG
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION cancel
             LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about       
         CALL cl_about()   
      ON ACTION page1
         LET g_action_choice = "page1"
         EXIT DIALOG
      ON ACTION page2
         LET g_action_choice = "page2"
         EXIT DIALOG
      ON ACTION qcs
         LET g_b_flag3 = 1
         LET g_action_choice = "qcs"
         EXIT DIALOG

      ON ACTION pr
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG

      ON ACTION chu
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "rva"
         EXIT DIALOG   
      ON ACTION rv
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu"
         EXIT DIALOG  
      ON ACTION rv_y
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_y"
         EXIT DIALOG  
      ON ACTION rv_c
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_c"
         EXIT DIALOG  
      ON ACTION ap
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "apa"
         EXIT DIALOG    
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q003_bp_rvu()
   LET g_action_choice = " "
   DISPLAY g_rec_b_rvu TO FORMONLY.cn2
   CALL cl_set_comp_visible("rvv", FALSE)
   CALL ui.interface.refresh()
   CALL cl_set_comp_visible("rvv", TRUE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_pmk01_change_rvv = '1' THEN
      LET g_pmk01_change_rvv = '0' 
      #CALL cl_set_comp_visible("page21_2", FALSE)
      CALL  g_rvv.clear()
      
      INITIALIZE g_head_rvv.* TO NULL 
      DISPLAY g_head_rvv.rvu01_rvv TO FORMONLY.rvu01_rvv
      DISPLAY g_head_rvv.rvu02_rvv TO FORMONLY.rvu02_rvv
      DISPLAY g_head_rvv.rvu03_rvv TO FORMONLY.rvu03_rvv
      DISPLAY g_head_rvv.rvu04_rvv TO FORMONLY.rvu04_rvv
      DISPLAY g_head_rvv.rvu05_rvv TO FORMONLY.rvu05_rvv
      DISPLAY g_head_rvv.rvu06_rvv TO FORMONLY.rvu06_rvv
      DISPLAY g_head_rvv.gem02_rvv TO FORMONLY.gem02_rvv
      DISPLAY g_head_rvv.rvu07_rvv TO FORMONLY.rvu07_rvv
      DISPLAY g_head_rvv.gen02_rvv TO FORMONLY.gen02_rvv
      DISPLAY g_head_rvv.rvuconf_rvv TO FORMONLY.rvuconf_rvv
      DISPLAY ARRAY g_rvv TO s_rvv.* ATTRIBUTE(COUNT=g_rec_b_rvv)
         BEFORE DISPLAY
            EXIT DISPLAY 
      END DISPLAY
      #CALL ui.interface.refresh()
      #CALL cl_set_comp_visible("page21_2", TRUE)
   END IF
   DISPLAY ARRAY g_rvu TO s_rvu.* ATTRIBUTE(COUNT=g_rec_b_rvu)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.h,tm.g
      FROM a,b,c,d,h,g ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q003_b_fill_2()
            CALL q003_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q003_b_fill()
            CALL g_pmk_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,h,g
         CALL q003()
         CALL q003_b_fill()
         CALL q003_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_rvu TO s_rvu.* ATTRIBUTE(COUNT=g_rec_b_rvu)

      BEFORE DISPLAY
         IF l_ac_rvu != 0 THEN
            CALL fgl_set_arr_curr(l_ac_rvu)
         END IF

      BEFORE ROW
        LET l_ac_rvu = ARR_CURR()
      CALL cl_show_fld_cont()
   END DISPLAY 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()             
         EXIT DIALOG
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION cancel
             LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about    
         CALL cl_about() 
      ON ACTION page1
         LET g_action_choice = "page1"
         EXIT DIALOG
      ON ACTION page2
         LET g_action_choice = "page2"
         EXIT DIALOG
      ON ACTION rvv
         LET l_ac_rvu = ARR_CURR()
         IF l_ac_rvu > 0 THEN
            LET g_head_rvv.rvu01_rvv = g_rvu[l_ac_rvu].rvu01
            LET g_head_rvv.rvu02_rvv = g_rvu[l_ac_rvu].rvu02
            LET g_head_rvv.rvu03_rvv = g_rvu[l_ac_rvu].rvu03
            LET g_head_rvv.rvu04_rvv = g_rvu[l_ac_rvu].rvu04
            LET g_head_rvv.rvu05_rvv = g_rvu[l_ac_rvu].rvu05
            LET g_head_rvv.rvu06_rvv = g_rvu[l_ac_rvu].rvu06
            LET g_head_rvv.gem02_rvv = g_rvu[l_ac_rvu].gem02_rvu
            LET g_head_rvv.rvu07_rvv = g_rvu[l_ac_rvu].rvu07
            LET g_head_rvv.gen02_rvv = g_rvu[l_ac_rvu].gen02_rvu
            LET g_head_rvv.rvuconf_rvv = g_rvu[l_ac_rvu].rvuconf
            LET g_b_flag3 = 2
            LET g_action_choice = "rvv"
         END IF
         EXIT DIALOG

      ON ACTION pr
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG

      ON ACTION chu
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "rva"
         EXIT DIALOG
      ON ACTION qc
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "qcs"
         EXIT DIALOG    
      ON ACTION rv_y
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_y"
         EXIT DIALOG  
      ON ACTION rv_c
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_c"
         EXIT DIALOG  
      ON ACTION ap
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "apa"
         EXIT DIALOG    
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q003_bp_rvv()
   LET g_action_choice = " "
   DISPLAY g_rec_b_rvv TO FORMONLY.cn2
   DISPLAY g_head_rvv.rvu01_rvv TO FORMONLY.rvu01_rvv
   DISPLAY g_head_rvv.rvu02_rvv TO FORMONLY.rvu02_rvv
   DISPLAY g_head_rvv.rvu03_rvv TO FORMONLY.rvu03_rvv
   DISPLAY g_head_rvv.rvu04_rvv TO FORMONLY.rvu04_rvv
   DISPLAY g_head_rvv.rvu05_rvv TO FORMONLY.rvu05_rvv
   DISPLAY g_head_rvv.rvu06_rvv TO FORMONLY.rvu06_rvv
   DISPLAY g_head_rvv.gem02_rvv TO FORMONLY.gem02_rvv
   DISPLAY g_head_rvv.rvu07_rvv TO FORMONLY.rvu07_rvv
   DISPLAY g_head_rvv.gen02_rvv TO FORMONLY.gen02_rvv
   DISPLAY g_head_rvv.rvuconf_rvv TO FORMONLY.rvuconf_rvv
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvv TO s_rvv.* ATTRIBUTE(COUNT=g_rec_b_rvv)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.h,tm.g
      FROM a,b,c,d,h,g ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q003_b_fill_2()
            CALL q003_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q003_b_fill()
            CALL g_pmk_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,h,g
         CALL q003()
         CALL q003_b_fill()
         CALL q003_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_rvv TO s_rvv.* ATTRIBUTE(COUNT=g_rec_b_rvv)

      BEFORE DISPLAY
         IF l_ac_rvv != 0 THEN
            CALL fgl_set_arr_curr(l_ac_rvv)
         END IF

      BEFORE ROW
        LET l_ac_rvv = ARR_CURR()
      CALL cl_show_fld_cont()
   END DISPLAY 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()     
         EXIT DIALOG
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION cancel
             LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about      
         CALL cl_about()    
      ON ACTION page1
         LET g_action_choice = "page1"
         EXIT DIALOG
      ON ACTION page2
         LET g_action_choice = "page2"
         EXIT DIALOG
      ON ACTION rvu
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu"
         EXIT DIALOG

      ON ACTION pr
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION chu
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "rva"
         EXIT DIALOG
      ON ACTION qc
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "qcs"
         EXIT DIALOG 
      ON ACTION rv_y
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_y"
         EXIT DIALOG  
      ON ACTION rv_c
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_c"
         EXIT DIALOG  
      ON ACTION ap
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "apa"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#add str
FUNCTION q003_bp_rvu_y()
   LET g_action_choice = " "
   DISPLAY g_rec_b_rvu_y TO FORMONLY.cn2
   CALL cl_set_comp_visible("rvv_y", FALSE)
   CALL ui.interface.refresh()
   CALL cl_set_comp_visible("rvv_y", TRUE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_pmk01_change_rvv_y = '1' THEN
      LET g_pmk01_change_rvv_y = '0' 
      CALL  g_rvv_y.clear()
      
      INITIALIZE g_head_rvv.* TO NULL 
      DISPLAY g_head_rvv_y.rvu01_rvv_y TO FORMONLY.rvu01_rvv_y
      DISPLAY g_head_rvv_y.rvu02_rvv_y TO FORMONLY.rvu02_rvv_y
      DISPLAY g_head_rvv_y.rvu03_rvv_y TO FORMONLY.rvu03_rvv_y
      DISPLAY g_head_rvv_y.rvu04_rvv_y TO FORMONLY.rvu04_rvv_y
      DISPLAY g_head_rvv_y.rvu05_rvv_y TO FORMONLY.rvu05_rvv_y
      DISPLAY g_head_rvv_y.rvu06_rvv_y TO FORMONLY.rvu06_rvv_y
      DISPLAY g_head_rvv_y.gem02_rvv_y TO FORMONLY.gem02_rvv_y
      DISPLAY g_head_rvv_y.rvu07_rvv_y TO FORMONLY.rvu07_rvv_y
      DISPLAY g_head_rvv_y.gen02_rvv_y TO FORMONLY.gen02_rvv_y
      DISPLAY g_head_rvv_y.rvuconf_rvv_y TO FORMONLY.rvuconf_rvv_y
      DISPLAY ARRAY g_rvv_y TO s_rvv_y.* ATTRIBUTE(COUNT=g_rec_b_rvv_y)
         BEFORE DISPLAY
            EXIT DISPLAY 
      END DISPLAY
   END IF
   DISPLAY ARRAY g_rvu_y TO s_rvu_y.* ATTRIBUTE(COUNT=g_rec_b_rvu_y)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.h,tm.g
      FROM a,b,c,d,h,g ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q003_b_fill_2()
            CALL q003_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q003_b_fill()
            CALL g_pmk_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,h,g
         CALL q003()
         CALL q003_b_fill()
         CALL q003_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_rvu_y TO s_rvu_y.* ATTRIBUTE(COUNT=g_rec_b_rvu_y)

      BEFORE DISPLAY
         IF l_ac_rvu_y != 0 THEN
            CALL fgl_set_arr_curr(l_ac_rvu_y)
         END IF

      BEFORE ROW
        LET l_ac_rvu_y = ARR_CURR()
        CALL cl_show_fld_cont()
   END DISPLAY 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()             
         EXIT DIALOG
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION cancel
             LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about    
         CALL cl_about() 
      ON ACTION page1
         LET g_action_choice = "page1"
         EXIT DIALOG
      ON ACTION page2
         LET g_action_choice = "page2"
         EXIT DIALOG
      ON ACTION rvv_y
         LET l_ac_rvu_y = ARR_CURR()
         IF l_ac_rvu_y > 0 THEN
            LET g_head_rvv_y.rvu01_rvv_y = g_rvu_y[l_ac_rvu_y].rvu01
            LET g_head_rvv_y.rvu02_rvv_y = g_rvu_y[l_ac_rvu_y].rvu02
            LET g_head_rvv_y.rvu03_rvv_y = g_rvu_y[l_ac_rvu_y].rvu03
            LET g_head_rvv_y.rvu04_rvv_y = g_rvu_y[l_ac_rvu_y].rvu04
            LET g_head_rvv_y.rvu05_rvv_y = g_rvu_y[l_ac_rvu_y].rvu05
            LET g_head_rvv_y.rvu06_rvv_y = g_rvu_y[l_ac_rvu_y].rvu06
            LET g_head_rvv_y.gem02_rvv_y = g_rvu_y[l_ac_rvu_y].gem02_rvu
            LET g_head_rvv_y.rvu07_rvv_y = g_rvu_y[l_ac_rvu_y].rvu07
            LET g_head_rvv_y.gen02_rvv_y = g_rvu_y[l_ac_rvu_y].gen02_rvu
            LET g_head_rvv_y.rvuconf_rvv_y = g_rvu_y[l_ac_rvu_y].rvuconf
            LET g_b_flag3 = 2
            LET g_action_choice = "rvv_y"
         END IF
         EXIT DIALOG

      ON ACTION pr
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG

      ON ACTION chu
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "rva"
         EXIT DIALOG
      ON ACTION qc
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "qcs"
         EXIT DIALOG    
      ON ACTION rv
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu"
         EXIT DIALOG  
      ON ACTION rv_c
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_c"
         EXIT DIALOG  
      ON ACTION ap
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "apa"
         EXIT DIALOG    
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q003_bp_rvv_y()
   LET g_action_choice = " "
   DISPLAY g_rec_b_rvv_y TO FORMONLY.cn2
   DISPLAY g_head_rvv_y.rvu01_rvv_y TO FORMONLY.rvu01_rvv_y
   DISPLAY g_head_rvv_y.rvu02_rvv_y TO FORMONLY.rvu02_rvv_y
   DISPLAY g_head_rvv_y.rvu03_rvv_y TO FORMONLY.rvu03_rvv_y
   DISPLAY g_head_rvv_y.rvu04_rvv_y TO FORMONLY.rvu04_rvv_y
   DISPLAY g_head_rvv_y.rvu05_rvv_y TO FORMONLY.rvu05_rvv_y
   DISPLAY g_head_rvv_y.rvu06_rvv_y TO FORMONLY.rvu06_rvv_y
   DISPLAY g_head_rvv_y.gem02_rvv_y TO FORMONLY.gem02_rvv_y
   DISPLAY g_head_rvv_y.rvu07_rvv_y TO FORMONLY.rvu07_rvv_y
   DISPLAY g_head_rvv_y.gen02_rvv_y TO FORMONLY.gen02_rvv_y
   DISPLAY g_head_rvv_y.rvuconf_rvv_y TO FORMONLY.rvuconf_rvv_y
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvv_y TO s_rvv_y.* ATTRIBUTE(COUNT=g_rec_b_rvv_y)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.h,tm.g
      FROM a,b,c,d,h,g ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q003_b_fill_2()
            CALL q003_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q003_b_fill()
            CALL g_pmk_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,h,g
         CALL q003()
         CALL q003_b_fill()
         CALL q003_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_rvv_y TO s_rvv_y.* ATTRIBUTE(COUNT=g_rec_b_rvv_y)

      BEFORE DISPLAY
         IF l_ac_rvv_y != 0 THEN
            CALL fgl_set_arr_curr(l_ac_rvv_y)
         END IF

      BEFORE ROW
        LET l_ac_rvv_y = ARR_CURR()
      CALL cl_show_fld_cont()
   END DISPLAY 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()     
         EXIT DIALOG
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION cancel
             LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about      
         CALL cl_about()    
      ON ACTION page1
         LET g_action_choice = "page1"
         EXIT DIALOG
      ON ACTION page2
         LET g_action_choice = "page2"
         EXIT DIALOG
      ON ACTION rvu_y
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_y"
         EXIT DIALOG

      ON ACTION pr
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION chu
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "rva"
         EXIT DIALOG
      ON ACTION qc
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "qcs"
         EXIT DIALOG 
      ON ACTION rv
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu"
         EXIT DIALOG  
      ON ACTION rv_c
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_c"
         EXIT DIALOG  
      ON ACTION ap
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "apa"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q003_bp_rvu_c()
   LET g_action_choice = " "
   DISPLAY g_rec_b_rvu_c TO FORMONLY.cn2
   CALL cl_set_comp_visible("rvv_c", FALSE)
   CALL ui.interface.refresh()
   CALL cl_set_comp_visible("rvv_c", TRUE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_pmk01_change_rvv_c = '1' THEN
      LET g_pmk01_change_rvv_c = '0' 
      #CALL cl_set_comp_visible("page21_2", FALSE)
      CALL  g_rvv_c.clear()
      
      INITIALIZE g_head_rvv_c.* TO NULL 
      DISPLAY g_head_rvv_c.rvu01_rvv_c TO FORMONLY.rvu01_rvv_c
      DISPLAY g_head_rvv_c.rvu02_rvv_c TO FORMONLY.rvu02_rvv_c
      DISPLAY g_head_rvv_c.rvu03_rvv_c TO FORMONLY.rvu03_rvv_c
      DISPLAY g_head_rvv_c.rvu04_rvv_c TO FORMONLY.rvu04_rvv_c
      DISPLAY g_head_rvv_c.rvu05_rvv_c TO FORMONLY.rvu05_rvv_c
      DISPLAY g_head_rvv_c.rvu06_rvv_c TO FORMONLY.rvu06_rvv_c
      DISPLAY g_head_rvv_c.gem02_rvv_c TO FORMONLY.gem02_rvv_c
      DISPLAY g_head_rvv_c.rvu07_rvv_c TO FORMONLY.rvu07_rvv_c
      DISPLAY g_head_rvv_c.gen02_rvv_c TO FORMONLY.gen02_rvv_c
      DISPLAY g_head_rvv_c.rvuconf_rvv_c TO FORMONLY.rvuconf_rvv_c
      DISPLAY ARRAY g_rvv_c TO s_rvv_c.* ATTRIBUTE(COUNT=g_rec_b_rvv_c)
         BEFORE DISPLAY
            EXIT DISPLAY 
      END DISPLAY
      #CALL ui.interface.refresh()
      #CALL cl_set_comp_visible("page21_2", TRUE)
   END IF
   DISPLAY ARRAY g_rvu_c TO s_rvu_c.* ATTRIBUTE(COUNT=g_rec_b_rvu_c)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.h,tm.g
      FROM a,b,c,d,h,g ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q003_b_fill_2()
            CALL q003_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q003_b_fill()
            CALL g_pmk_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,h,g
         CALL q003()
         CALL q003_b_fill()
         CALL q003_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_rvu_c TO s_rvu_c.* ATTRIBUTE(COUNT=g_rec_b_rvu_c)

      BEFORE DISPLAY
         IF l_ac_rvu_c != 0 THEN
            CALL fgl_set_arr_curr(l_ac_rvu_c)
         END IF

      BEFORE ROW
        LET l_ac_rvu_c = ARR_CURR()
      CALL cl_show_fld_cont()
   END DISPLAY 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()             
         EXIT DIALOG
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION cancel
             LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about    
         CALL cl_about() 
      ON ACTION page1
         LET g_action_choice = "page1"
         EXIT DIALOG
      ON ACTION page2
         LET g_action_choice = "page2"
         EXIT DIALOG
      ON ACTION rvv_c
         LET l_ac_rvu_c = ARR_CURR()
         IF l_ac_rvu_c > 0 THEN
            LET g_head_rvv_c.rvu01_rvv_c = g_rvu_c[l_ac_rvu_c].rvu01
            LET g_head_rvv_c.rvu02_rvv_c = g_rvu_c[l_ac_rvu_c].rvu02
            LET g_head_rvv_c.rvu03_rvv_c = g_rvu_c[l_ac_rvu_c].rvu03
            LET g_head_rvv_c.rvu04_rvv_c = g_rvu_c[l_ac_rvu_c].rvu04
            LET g_head_rvv_c.rvu05_rvv_c = g_rvu_c[l_ac_rvu_c].rvu05
            LET g_head_rvv_c.rvu06_rvv_c = g_rvu_c[l_ac_rvu_c].rvu06
            LET g_head_rvv_c.gem02_rvv_c = g_rvu_c[l_ac_rvu_c].gem02_rvu
            LET g_head_rvv_c.rvu07_rvv_c = g_rvu_c[l_ac_rvu_c].rvu07
            LET g_head_rvv_c.gen02_rvv_c = g_rvu_c[l_ac_rvu_c].gen02_rvu
            LET g_head_rvv_c.rvuconf_rvv_c = g_rvu_c[l_ac_rvu_c].rvuconf
            LET g_b_flag3 = 2
            LET g_action_choice = "rvv_c"
         END IF
         EXIT DIALOG

      ON ACTION pr
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION chu
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "rva"
         EXIT DIALOG
      ON ACTION qc
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "qcs"
         EXIT DIALOG    
      ON ACTION rv_y
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_y"
         EXIT DIALOG  
      ON ACTION rv
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu"
         EXIT DIALOG  
      ON ACTION ap
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "apa"
         EXIT DIALOG    
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q003_bp_rvv_c()
   LET g_action_choice = " "
   DISPLAY g_rec_b_rvv_c TO FORMONLY.cn2
   DISPLAY g_head_rvv_c.rvu01_rvv_c TO FORMONLY.rvu01_rvv_c
   DISPLAY g_head_rvv_c.rvu02_rvv_c TO FORMONLY.rvu02_rvv_c
   DISPLAY g_head_rvv_c.rvu03_rvv_c TO FORMONLY.rvu03_rvv_c
   DISPLAY g_head_rvv_c.rvu04_rvv_c TO FORMONLY.rvu04_rvv_c
   DISPLAY g_head_rvv_c.rvu05_rvv_c TO FORMONLY.rvu05_rvv_c
   DISPLAY g_head_rvv_c.rvu06_rvv_c TO FORMONLY.rvu06_rvv_c
   DISPLAY g_head_rvv_c.gem02_rvv_c TO FORMONLY.gem02_rvv_c
   DISPLAY g_head_rvv_c.rvu07_rvv_c TO FORMONLY.rvu07_rvv_c
   DISPLAY g_head_rvv_c.gen02_rvv_c TO FORMONLY.gen02_rvv_c
   DISPLAY g_head_rvv_c.rvuconf_rvv_c TO FORMONLY.rvuconf_rvv_c
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvv_c TO s_rvv_c.* ATTRIBUTE(COUNT=g_rec_b_rvv_c)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.h,tm.g
      FROM a,b,c,d,h,g ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q003_b_fill_2()
            CALL q003_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q003_b_fill()
            CALL g_pmk_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,h,g
         CALL q003()
         CALL q003_b_fill()
         CALL q003_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_rvv_c TO s_rvv_c.* ATTRIBUTE(COUNT=g_rec_b_rvv_c)

      BEFORE DISPLAY
         IF l_ac_rvv_c != 0 THEN
            CALL fgl_set_arr_curr(l_ac_rvv_c)
         END IF

      BEFORE ROW
        LET l_ac_rvv_c = ARR_CURR()
      CALL cl_show_fld_cont()
   END DISPLAY 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()     
         EXIT DIALOG
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION cancel
             LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about      
         CALL cl_about()    
      ON ACTION page1
         LET g_action_choice = "page1"
         EXIT DIALOG
      ON ACTION page2
         LET g_action_choice = "page2"
         EXIT DIALOG
      ON ACTION rvu_c
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_c"
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION chu
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "rva"
         EXIT DIALOG
      ON ACTION qc
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "qcs"
         EXIT DIALOG 
      ON ACTION rv_y
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_y"
         EXIT DIALOG  
      ON ACTION rv
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu"
         EXIT DIALOG  
      ON ACTION ap
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "apa"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#add end 

FUNCTION q003_bp_apa()
   LET g_action_choice = " "
   DISPLAY g_rec_b_apa TO FORMONLY.cn2
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL cl_set_comp_visible("apb", FALSE)
   CALL ui.interface.refresh()
   CALL cl_set_comp_visible("apb", TRUE)
   IF g_pmk01_change_apb = '1' THEN
      LET g_pmk01_change_apb = '0' 
      #CALL cl_set_comp_visible("page21_3", FALSE)
      CALL  g_apb.clear()   
      INITIALIZE g_head_apb.* TO NULL
      LET g_rec_b_apb = ''
      #DISPLAY g_rec_b_apb TO FORMONLY.cn2
      DISPLAY g_head_apb.apa01_apb TO FORMONLY.apa01_apb
      DISPLAY g_head_apb.apa02_apb TO FORMONLY.apa02_apb
      DISPLAY g_head_apb.apa05_apb TO FORMONLY.apa05_apb
      DISPLAY g_head_apb.pmc03_apb TO FORMONLY.pmc03_apb
      DISPLAY g_head_apb.apa06_apb TO FORMONLY.apa06_apb
      DISPLAY g_head_apb.apa07_apb TO FORMONLY.apa07_apb
      DISPLAY g_head_apb.apa41_apb TO FORMONLY.apa41_apb
      DISPLAY g_head_apb.apa42_apb TO FORMONLY.apa42_apb
      DISPLAY g_head_apb.apamksg_apb TO FORMONLY.apamksg_apb
      DISPLAY ARRAY g_apb TO s_apb.* ATTRIBUTE(COUNT=g_rec_b_apb)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
      #CALL ui.interface.refresh()
      #CALL cl_set_comp_visible("page21_3", TRUE)
   END IF
   DISPLAY ARRAY g_apa TO s_apa.* ATTRIBUTE(COUNT=g_rec_b_apa)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.h,tm.g
      FROM a,b,c,d,h,g ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q003_b_fill_2()
            CALL q003_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q003_b_fill()
            CALL g_pmk_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,h,g
         CALL q003()
         CALL q003_b_fill()
         CALL q003_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_apa TO s_apa.* ATTRIBUTE(COUNT=g_rec_b_apa)

      BEFORE DISPLAY
         IF l_ac_apa != 0 THEN
            CALL fgl_set_arr_curr(l_ac_apa)
         END IF

      BEFORE ROW
        LET l_ac_apa = ARR_CURR()
      CALL cl_show_fld_cont()
   END DISPLAY 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()             
         EXIT DIALOG
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION cancel
             LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about    
         CALL cl_about() 
     ON ACTION page1
         LET g_action_choice = "page1"
         EXIT DIALOG
      ON ACTION page2
         LET g_action_choice = "page2"
         EXIT DIALOG
      ON ACTION apb
         LET l_ac_apa = ARR_CURR()
         IF l_ac_apa > 0 THEN
            LET g_head_apb.apa01_apb = g_apa[l_ac_apa].apa01
            LET g_head_apb.apa02_apb = g_apa[l_ac_apa].apa02
            LET g_head_apb.apa05_apb = g_apa[l_ac_apa].apa05
            LET g_head_apb.pmc03_apb = g_apa[l_ac_apa].pmc03_apa
            LET g_head_apb.apa06_apb = g_apa[l_ac_apa].apa06
            LET g_head_apb.apa07_apb = g_apa[l_ac_apa].apa07
            LET g_head_apb.apa41_apb = g_apa[l_ac_apa].apa41
            LET g_head_apb.apa42_apb = g_apa[l_ac_apa].apa42
            LET g_head_apb.apamksg_apb = g_apa[l_ac_apa].apamksg
            LET g_b_flag3 = 2
            LET g_action_choice = "apb"
         END IF
         EXIT DIALOG

      ON ACTION pr
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION chu
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "rva"
         EXIT DIALOG
      ON ACTION qc
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "qcs"
         EXIT DIALOG  
      ON ACTION rv
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu"
         EXIT DIALOG       
      ON ACTION rv_y
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_y"
         EXIT DIALOG  
      ON ACTION rv_c
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_c"
         EXIT DIALOG  
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION q003_bp_apb()
   LET g_action_choice = " "
   DISPLAY g_rec_b_apb TO FORMONLY.cn2
   DISPLAY g_head_apb.apa01_apb TO FORMONLY.apa01_apb
   DISPLAY g_head_apb.apa02_apb TO FORMONLY.apa02_apb
   DISPLAY g_head_apb.apa05_apb TO FORMONLY.apa05_apb
   DISPLAY g_head_apb.pmc03_apb TO FORMONLY.pmc03_apb
   DISPLAY g_head_apb.apa06_apb TO FORMONLY.apa06_apb
   DISPLAY g_head_apb.apa07_apb TO FORMONLY.apa07_apb
   DISPLAY g_head_apb.apa41_apb TO FORMONLY.apa41_apb
   DISPLAY g_head_apb.apa42_apb TO FORMONLY.apa42_apb
   DISPLAY g_head_apb.apamksg_apb TO FORMONLY.apamksg_apb
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_apb TO s_apb.* ATTRIBUTE(COUNT=g_rec_b_apb)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.h,tm.g
      FROM a,b,c,d,h,g ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q003_b_fill_2()
            CALL q003_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q003_b_fill()
            CALL g_pmk_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,h,g
         CALL q003()
         CALL q003_b_fill()
         CALL q003_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_apb TO s_apb.* ATTRIBUTE(COUNT=g_rec_b_apb)

      BEFORE DISPLAY
         IF l_ac_apb != 0 THEN
            CALL fgl_set_arr_curr(l_ac_apb)
         END IF

      BEFORE ROW
        LET l_ac_apb = ARR_CURR()
      CALL cl_show_fld_cont()
   END DISPLAY 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()     
         EXIT DIALOG
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION cancel
             LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about      
         CALL cl_about()    
      ON ACTION page1
         LET g_action_choice = "page1"
         EXIT DIALOG
      ON ACTION page2
         LET g_action_choice = "page2"
         EXIT DIALOG
      ON ACTION apa
         LET g_b_flag3 = 1
         LET g_action_choice = "apa"
         EXIT DIALOG

      ON ACTION pr
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG

      ON ACTION chu
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "rva"
         EXIT DIALOG
      ON ACTION qc
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "qcs"
         EXIT DIALOG 
      ON ACTION rv
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu"
         EXIT DIALOG 
      ON ACTION rv_y
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_y"
         EXIT DIALOG  
      ON ACTION rv_c
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "rvu_c"
         EXIT DIALOG  
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION act_page3()
DEFINE l_cutwip        LIKE ecm_file.ecm315,
       l_packwip       LIKE ecm_file.ecm315,
       l_completed     LIKE ecm_file.ecm315,
       l_sfb08         LIKE sfb_file.sfb08 
      IF l_ac > 0 THEN
         IF NOT cl_null(g_pmk01_o) AND g_pmk01_o != g_pmk[l_ac].pmk01 THEN
            LET g_pmk01_change_pml = '1'
            LET g_pmk01_change_pmn = '1'
            LET g_pmk01_change_rvb = '1'
            LET g_pmk01_change_qct = '1'
            LET g_pmk01_change_rvv = '1'
            LET g_pmk01_change_rvv_y='1'
            LET g_pmk01_change_rvv_c='1'
            LET g_pmk01_change_apb = '1'
         END IF
            IF NOT cl_null(g_pml02_o) AND g_pml02_o != g_pmk[l_ac].pml02 THEN
               LET g_pml02_change_pml = '1'
               LET g_pml02_change_pmn = '1'
            END IF  
            LET g_pmk01_o = g_pmk[l_ac].pmk01
            LET g_pml02_o = g_pmk[l_ac].pml02       
            LET g_head.pmk01_2 = g_pmk[l_ac].pmk01
            LET g_head.pmk02_2 = g_pmk[l_ac].pmk02  
            LET g_head.pmk09_2 = g_pmk[l_ac].pmk09
            LET g_head.pmc03_2 = g_pmk[l_ac].pmc03 
            LET g_head.pmk04_2 = g_pmk[l_ac].pmk04 
            LET g_head.pmk18_2 = g_pmk[l_ac].pmk18 
            LET g_head.pmk12_2 = g_pmk[l_ac].pmk12 
            LET g_head.gen02_2 = g_pmk[l_ac].gen02 
            LET g_head.pmk13_2 = g_pmk[l_ac].pmk13 
            LET g_head.gem02_2 = g_pmk[l_ac].gem02 
            LET g_head.pmm22_2 = g_pmk[l_ac].pmm22 
            LET g_head.pmm42_2 = g_pmk[l_ac].pmm42 
            LET g_head.pmm43_2 = g_pmk[l_ac].pmm43 
            LET g_head.gec07_2 = g_pmk[l_ac].gec07 
            CASE g_pname
               WHEN '2'
                  SELECT SUM(pmn87),SUM(pmn53) INTO g_head.pml87_2,g_head.pmn53_2 
                    FROM pmn_file 
                   WHERE pmn01=g_pmk[l_ac].pmk01 
               WHEN '3' 
                  SELECT SUM(rvb07),SUM(rvb30) INTO  g_head.pml87_2,g_head.pmn53_2 
                    FROM rvb_file 
                   WHERE rvb01=g_pmk[l_ac].pmk01 
               OTHERWISE 
                  IF g_head.pmk02_2='7' THEN 
                     SELECT SUM(sfb08) INTO g_head.pml87_2 FROM sfb_file 
                      WHERE sfb01=g_pmk[l_ac].pmk01 
                     SELECT SUM(pmn53) INTO g_head.pml87_2 FROM pmn_file 
                      WHERE pmn41=g_pmk[l_ac].pmk01 
                  ELSE 
                     SELECT SUM(pml87) INTO g_head.pml87_2 FROM pml_file 
                      WHERE pml01=g_pmk[l_ac].pmk01 
                     SELECT SUM(pmn53) INTO g_head.pmn53_2 FROM pmn_file 
                      WHERE pmn24=g_pmk[l_ac].pmk01
                  END IF 
            END CASE 
            LET g_head.pmkpro_2= g_head.pmn53_2/g_head.pml87_2*100
            IF cl_null(g_head.pml87_2) THEN LET g_head.pml87_2=0 END IF 
            IF cl_null(g_head.pmn53_2) THEN LET g_head.pmn53_2=0 END IF 
         ELSE
             INITIALIZE g_head.* TO NULL 
             LET g_head.pmk01_2 = ' '
             LET g_pmk01_change_pml = '1'
             LET g_pmk01_change_pmn = '1'
             LET g_pmk01_change_rvb = '1'
             LET g_pmk01_change_qct = '1'
             LET g_pmk01_change_rvv = '1'
             LET g_pmk01_change_rvv_y='1'
             LET g_pmk01_change_rvv_c='1'
             LET g_pmk01_change_apb = '1'
             LET g_pml02_change_pml = '1'
             LET g_pml02_change_pmn = '1'
         END IF
         LET g_action_flag = "page3"
         LET g_b_flag3 = 1
         CALL cl_set_comp_visible("page1", FALSE)
         CALL cl_set_comp_visible("page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page1", TRUE)
         CALL cl_set_comp_visible("page2", TRUE)
         CASE g_b_flag2
            WHEN 1
               LET g_action_choice="pmk"
            WHEN 2
               LET g_action_choice="pmm"
            WHEN 3 
               LET g_action_choice="rva"
            WHEN 4
               LET g_action_choice="qcs"   
            WHEN 5
               LET g_action_choice="rvu" 
            WHEN 6
               LET g_action_choice="rvu_y" 
            WHEN 7
               LET g_action_choice="rvu_c" 
            WHEN 8
               LET g_action_choice="apa"
            OTHERWISE
               CASE g_pname
                  WHEN '2'  LET g_action_choice="pmm" LET g_b_flag2=2
                  WHEN '3'  LET g_action_choice="rva" LET g_b_flag2=3
                  OTHERWISE LET g_action_choice="pmk" LET g_b_flag2=1
               END CASE 
         END CASE
END FUNCTION
      
FUNCTION q003_excel()
CASE 
   WHEN (g_b_flag2 = 0 OR g_b_flag2 = 1) AND g_b_flag3 = 1
       LET page = f.FindNode("Page","pmk")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_pmk_2),'','')
       
   WHEN (g_b_flag2 = 0 OR g_b_flag2 = 1) AND g_b_flag3 = 2
       LET page = f.FindNode("Page","pml")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_pml),'','')
 
   WHEN g_b_flag2 = 2 AND g_b_flag3 = 1 
       LET page = f.FindNode("Page","pmm")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_pmm),'','')  

   WHEN g_b_flag2 = 2 AND g_b_flag3 = 2 
       LET page = f.FindNode("Page","pmn")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_pmn),'','') 

   WHEN g_b_flag2 = 3 AND g_b_flag3 = 1 
       LET page = f.FindNode("Page","rva")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_rva),'','')

   WHEN g_b_flag2 = 3 AND g_b_flag3 = 2 
       LET page = f.FindNode("Page","rvb")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_rvb),'','')

   WHEN g_b_flag2 = 4 AND g_b_flag3 = 1 
       LET page = f.FindNode("Page","qcs")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_qcs),'','')

   WHEN g_b_flag2 = 4 AND g_b_flag3 = 2 
       LET page = f.FindNode("Page","qct")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_qct),'','')

   WHEN g_b_flag2 = 5 AND g_b_flag3 = 1 
       LET page = f.FindNode("Page","rvu")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_rvu),'','')

   WHEN g_b_flag2 = 5 AND g_b_flag3 = 2 
       LET page = f.FindNode("Page","rvv")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_rvv),'','')

   WHEN g_b_flag2 = 6 AND g_b_flag3 = 1 
       LET page = f.FindNode("Page","rvu_y")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_rvu_y),'','')

   WHEN g_b_flag2 = 6 AND g_b_flag3 = 2 
       LET page = f.FindNode("Page","rvv_y")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_rvv_y),'','')

   WHEN g_b_flag2 = 7 AND g_b_flag3 = 1 
       LET page = f.FindNode("Page","rvu_c")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_rvu_c),'','')

   WHEN g_b_flag2 = 7 AND g_b_flag3 = 2 
       LET page = f.FindNode("Page","rvv_c")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_rvv_c),'','')
       
   WHEN g_b_flag2 = 8 AND g_b_flag3 = 1 
       LET page = f.FindNode("Page","apa")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_apa),'','')

   WHEN g_b_flag2 = 8 AND g_b_flag3 = 2 
       LET page = f.FindNode("Page","apb")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_apb),'','')
END CASE
END FUNCTION 

FUNCTION q003_additem()
   DEFINE l_pmk02_target  ui.ComboBox
   DEFINE l_pmk02_target1 ui.ComboBox
   DEFINE l_a_target      ui.ComboBox
   
   LET l_pmk02_target = ui.ComboBox.forName("pmk02")
   LET l_pmk02_target1= ui.ComboBox.forName("pmk02_1")
   LET l_a_target = ui.ComboBox.forName("a")
   
   CASE g_pname
      WHEN '2'
         CALL l_pmk02_target.RemoveItem("7")
         CALL l_pmk02_target1.RemoveItem("7")
      WHEN '3'
         CALL l_pmk02_target.RemoveItem("7")
         CALL l_pmk02_target1.RemoveItem("7")
         CALL l_a_target.RemoveItem("5")
         CALL l_a_target.RemoveItem("8")
      OTHERWISE 
         CALL l_pmk02_target.RemoveItem("SUB")
         CALL l_pmk02_target.RemoveItem("TRI")
         CALL l_pmk02_target1.RemoveItem("SUB")
         CALL l_pmk02_target1.RemoveItem("TRI")
   END CASE 
END FUNCTION 

FUNCTION q110_set_apb01_unap(p_apb21,p_apb22,p_apb34)  
DEFINE  p_apb21  LIKE apb_file.apb21,
        p_apb22  LIKE apb_file.apb22,
        p_apb34  LIKE apb_file.apb34,     
        l_apb01  LIKE apb_file.apb01,     
        l_apa58  LIKE apa_file.apa58,
        l_apb    RECORD LIKE apb_file.*   

   IF p_apb34 = 'N' THEN
      RETURN NULL
   END IF

   IF cl_null(p_apb21) OR cl_null(p_apb22) THEN
      RETURN NULL
   END IF
   #抓暫估單號
   SELECT * INTO l_apa58 FROM apa_file WHERE apa01 = g_head_apb.apa01_apb
   IF l_apa58 ='3' THEN
      LET l_apb01=p_apb21
   ELSE
      SELECT apb01 INTO l_apb01 FROM apb_file,apa_file
       WHERE apb21=p_apb21 AND apb22=p_apb22
         AND (apa00='16' OR apa00='26')
         AND apb01=apa01
         AND apa42 = 'N'  
         AND apa41 = 'Y'  
   END IF   
   IF SQLCA.sqlcode THEN
      LET l_apb01=NULL
   END IF
   RETURN l_apb01
END FUNCTION
#FUN-C90076
