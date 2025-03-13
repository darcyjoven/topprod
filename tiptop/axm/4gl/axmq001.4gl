# Prog. Version..: '5.30.06-13.03.12(00003)'     #
# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# PATTERN NAME...: axmq001
# DESCRIPTIONS...: 訂單狀態查詢作業
# DATE & AUTHOR..: 12/09/17 FUN-C90076 By  xujing 
# Modify.........: No.FUN-D10105 13/01/22 By xujing axmq001增加客戶分類(occ03)和產品分類(ima131)
# Modify.........: No.MOD-D10190 13/02/22 By SunLM 僅為"9"時,才顯示匯總數量的庫存數量,其他時候隱藏 
# Modify.........: No.FUN-D50044 13/05/14 By fengrui 單身添加oea901多角貿易否,區分一般訂單、多角訂單
# Modify.........: No.MOD-D60163 13/06/18 By SunLM 一張订单-->多筆请购单-->多筆采购单,采购单资料无显示
# Modify.........: No.TQC-D60042 13/06/07 By wangrr 匯總時"庫存數量"求和,分組中去除img10

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                              
                 wc2 STRING,                                     
                 a   LIKE type_file.chr10,       #小計選項     #FUN-D10105 chr1==>chr10
                 b   LIKE type_file.chr1, 
                 c   LIKE type_file.chr1, 
                 d   LIKE type_file.chr1, 
                 e   LIKE type_file.chr1, 
                 f   LIKE type_file.chr1, 
                 g   LIKE type_file.chr1, 
                 h   LIKE type_file.chr1
              END RECORD     
   DEFINE g_filter_wc     STRING              
   DEFINE g_msg     LIKE type_file.chr1000                                                                                           
   DEFINE g_sql     STRING                                                                                    
   DEFINE g_str     STRING    
   DEFINE l_table   STRING
   DEFINE g_rec_b        LIKE type_file.num10
   DEFINE g_cnt          LIKE type_file.num10                  
   DEFINE g_oea,g_oea_excel    DYNAMIC ARRAY OF RECORD 
                h_b       LIKE type_file.chr1, 
                oea00     LIKE oea_file.oea00,
                oea01     LIKE oea_file.oea01,
                oea08     LIKE oea_file.oea08,
                oea901    LIKE oea_file.oea901,     #FUN-D50044 add
                oea03     LIKE oea_file.oea03,
                oea032    LIKE oea_file.oea032,
                oea04     LIKE oea_file.oea04,
                occ02     LIKE occ_file.occ02,
                occ03     LIKE occ_file.occ03,      #FUN-D10105
                oca02     LIKE oca_file.oca02,      #FUN-D10105
                oea02     LIKE oea_file.oea02,
                oea14     LIKE oea_file.oea14,
                gen02     LIKE gen_file.gen02,
                oea15     LIKE oea_file.oea15,
                gem02     LIKE gem_file.gem02,
                oea23     LIKE oea_file.oea23,
                oea21     LIKE oea_file.oea21,
                oea211    LIKE oea_file.oea211,
                oea213    LIKE oea_file.oea213,
                oea10     LIKE oea_file.oea10,
                oeaconf   LIKE oea_file.oeaconf,
                oea72     LIKE oea_file.oea72,
                oea49     LIKE oea_file.oea49,
                oeb03     LIKE oeb_file.oeb03,
                oeb04     LIKE oeb_file.oeb04,
                oeb06     LIKE oeb_file.oeb06,
                ima021    LIKE ima_file.ima021,
                oeb11     LIKE oeb_file.oeb11,
                ima131    LIKE ima_file.ima131,       #FUN-D10105
                oba02     LIKE oba_file.oba02,        #FUN-D10105
                oeb05     LIKE oeb_file.oeb05,
                img10     LIKE img_file.img10,
                oeb905    LIKE oeb_file.oeb905,
                oeb12     LIKE oeb_file.oeb12,
                oeb13     LIKE oeb_file.oeb13,
                oeb14     LIKE oeb_file.oeb14,
                oeb14t    LIKE oeb_file.oeb14t,
                oeb15     LIKE oeb_file.oeb15,
                ogb12     LIKE ogb_file.ogb12,
                oeb24     LIKE oeb_file.oeb24,
                ogb13     LIKE ogb_file.ogb13,
                ogb14t    LIKE ogb_file.ogb14t,
                ohb12     LIKE ohb_file.ohb12,
                ohb13     LIKE ohb_file.ohb13,
                ohb14t    LIKE ohb_file.ohb14t,
                ogb16     LIKE ogb_file.ogb16,
                ogb18     LIKE ogb_file.ogb18,
                omb12     LIKE omb_file.omb12,
                omb14t    LIKE omb_file.omb14t,
                sfb_count LIKE type_file.chr1,
                sfb09     LIKE sfb_file.sfb09
                ,oebud01  like oeb_file.oebud01 #darcy:2023/02/22
                         END RECORD
    DEFINE g_oea_1,g_oea_1_excel   DYNAMIC ARRAY OF RECORD  
                oea00     LIKE oea_file.oea00,
                oea08     LIKE oea_file.oea08,
                oea02     LIKE oea_file.oea02,
                oea03     LIKE oea_file.oea03,
                oea032    LIKE oea_file.oea032,
                oea04     LIKE oea_file.oea04,
                occ02     LIKE occ_file.occ02,
                occ03     LIKE occ_file.occ03,      #FUN-D10105
                oca02     LIKE oca_file.oca02,      #FUN-D10105
                oea14     LIKE oea_file.oea14,
                gen02     LIKE gen_file.gen02,
                oea15     LIKE oea_file.oea15,
                gem02     LIKE gem_file.gem02,
                oea10     LIKE oea_file.oea10,
                oeb04     LIKE oeb_file.oeb04,
                oeb06     LIKE oeb_file.oeb06,
                ima021    LIKE ima_file.ima021,
                ima131    LIKE ima_file.ima131,       #FUN-D10105
                oba02     LIKE oba_file.oba02,        #FUN-D10105
                oea01     LIKE oea_file.oea01,
                oea23     LIKE oea_file.oea23,
                oea21     LIKE oea_file.oea21,
                oea211    LIKE oea_file.oea211,
                oea213    LIKE oea_file.oea213,
                oeaconf   LIKE oea_file.oeaconf,
                oea49     LIKE oea_file.oea49,
                oeb03     LIKE oeb_file.oeb03,               
                oeb11     LIKE oeb_file.oeb11,
                oeb05     LIKE oeb_file.oeb05,
                img10     LIKE img_file.img10,
                oeb905    LIKE oeb_file.oeb905,
                oeb12     LIKE oeb_file.oeb12,
                oeb13     LIKE oeb_file.oeb13,
                oeb14     LIKE oeb_file.oeb14,
                oeb14t    LIKE oeb_file.oeb14t,
                oeb15     LIKE oeb_file.oeb15,
                ogb12     LIKE ogb_file.ogb12,
                oeb24     LIKE oeb_file.oeb24,
                ogb13     LIKE ogb_file.ogb13,
                ogb14t    LIKE ogb_file.ogb14t,
                ohb12     LIKE ohb_file.ohb12,
                ohb13     LIKE ohb_file.ohb13,
                ohb14t    LIKE ohb_file.ohb14t,
                ogb16     LIKE ogb_file.ogb16,
                ogb18     LIKE ogb_file.ogb18,
                omb12     LIKE omb_file.omb12,
                omb14t    LIKE omb_file.omb14t,
                sfb09     LIKE sfb_file.sfb09
                         END RECORD
   TYPE sr1_t            RECORD  
                h_b       LIKE type_file.chr1,
                oea00     LIKE oea_file.oea00,
                oea01     LIKE oea_file.oea01,
                oea08     LIKE oea_file.oea08,
                oea901    LIKE oea_file.oea901,     #FUN-D50044 add
                oea03     LIKE oea_file.oea03,
                oea032    LIKE oea_file.oea032,
                oea04     LIKE oea_file.oea04,
                occ02     LIKE occ_file.occ02,
                oea02     LIKE oea_file.oea02,
                oea14     LIKE oea_file.oea14,
                gen02     LIKE gen_file.gen02,
                oea15     LIKE oea_file.oea15,
                gem02     LIKE gem_file.gem02,
                oea23     LIKE oea_file.oea23,
                oea21     LIKE oea_file.oea21,
                oea211    LIKE oea_file.oea211,
                oea213    LIKE oea_file.oea213,
                oea10     LIKE oea_file.oea10,
                oeaconf   LIKE oea_file.oeaconf,
                oea72     LIKE oea_file.oea72,
                oea49     LIKE oea_file.oea49,
                oeb03     LIKE oeb_file.oeb03,
                oeb04     LIKE oeb_file.oeb04,
                oeb06     LIKE oeb_file.oeb06,
                ima021    LIKE ima_file.ima021,
                oeb11     LIKE oeb_file.oeb11,
                oeb05     LIKE oeb_file.oeb05,
                img10     LIKE img_file.img10,
                oeb905    LIKE oeb_file.oeb905,
                oeb12     LIKE oeb_file.oeb12,
                oeb13     LIKE oeb_file.oeb13,
                oeb14     LIKE oeb_file.oeb14,
                oeb14t    LIKE oeb_file.oeb14t,
                oeb15     LIKE oeb_file.oeb15,
                ogb12     LIKE ogb_file.ogb12,
                oeb24     LIKE oeb_file.oeb24,
                ogb13     LIKE ogb_file.ogb13,
                ogb14t    LIKE ogb_file.ogb14t,
                ohb12     LIKE ohb_file.ohb12,
                ohb13     LIKE ohb_file.ohb13,
                ohb14t    LIKE ohb_file.ohb14t,
                ogb16     LIKE ogb_file.ogb16,
                ogb18     LIKE ogb_file.ogb18,
                omb12     LIKE omb_file.omb12,
                omb14t    LIKE omb_file.omb14t,
                oea65     LIKE type_file.chr1,
                sfb_count LIKE type_file.chr1,
                sfb09     LIKE sfb_file.sfb09
                ,oebud01  like oeb_file.oebud01 #darcy:2023/02/22
                         END RECORD
   DEFINE g_row_count    LIKE type_file.num10  
   DEFINE g_curs_index   LIKE type_file.num10  
   DEFINE g_jump         LIKE type_file.num10  
   DEFINE mi_no_ask      LIKE type_file.num5
   DEFINE g_no_ask       LIKE type_file.num5    #FUN-C80102 
   DEFINE l_ac,l_ac1     LIKE type_file.num5                                                                                        
   DEFINE g_oea_qty      LIKE type_file.num20_6      #訂單數量總計
   DEFINE g_oea_sum      LIKE type_file.num20_6      #訂單本幣金額總計
   DEFINE g_oea_sum1     LIKE type_file.num20_6      #訂單原幣金額總計
   DEFINE g_cmd          LIKE type_file.chr1000  
   DEFINE   g_rec_b2     LIKE type_file.num10   
   DEFINE   g_flag       LIKE type_file.chr1 
   DEFINE   g_action_flag  LIKE type_file.chr100   
   DEFINE   w    ui.Window
   DEFINE   f    ui.Form
   DEFINE   page om.DomNode  
   DEFINE
    g_head          RECORD
        oea01_2     LIKE oea_file.oea01,
        oea02_2     LIKE oea_file.oea02,
        oea03_2     LIKE oea_file.oea03,
        occ02_2     LIKE occ_file.occ02,
        oea14_2     LIKE oea_file.oea14,
        gen02_2     LIKE gen_file.gen02,
        moeb15_2    LIKE oeb_file.oeb15,
        oeb12_2    LIKE oeb_file.oeb12,
        oeb24_2    LIKE oeb_file.oeb24,
        oebislk01_2 LIKE oebi_file.oebislk01,
        workpro_2   LIKE type_file.num5,
        oeapro_2    LIKE type_file.num5
                    END RECORD,
    g_head_bmb      RECORD
        bmb01       LIKE bmb_file.bmb01,
        ima02_bma   LIKE ima_file.ima02,
        ima05_bma   LIKE ima_file.ima05
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
    g_head_ecm      RECORD
        sfb01_ecm   LIKE sfb_file.sfb01,
        sfb05_ecm   LIKE sfb_file.sfb05,
        ima02_ecm   LIKE ima_file.ima02,
        ima05_ecm   LIKE ima_file.ima05,
        sfb08_ecm   LIKE sfb_file.sfb08,
        sfb09_ecm   LIKE sfb_file.sfb09,
        sfbpro_ecm  LIKE type_file.num5
                    END RECORD,
    g_head_sfa      RECORD
        sfb01_sfa   LIKE sfb_file.sfb01,
        sfb05_sfa   LIKE sfb_file.sfb05,
        ima02_sfa   LIKE ima_file.ima02,
        ima05_sfa   LIKE ima_file.ima05,
        sfb08_sfa   LIKE sfb_file.sfb08,
        sfb081_sfa  LIKE sfb_file.sfb081
                    END RECORD,
    g_head_ogb      RECORD
        oga01_ogb   LIKE oga_file.oga01,
        oga02_ogb   LIKE oga_file.oga02,
        oga03_ogb   LIKE oga_file.oga03,
        oga032_ogb  LIKE oga_file.oga032,
        oga14_ogb   LIKE oga_file.oga14,
        gen02_ogb   LIKE gen_file.gen02,
        ogaconf_ogb LIKE oga_file.ogaconf,
        ogapost_ogb LIKE oga_file.ogapost
                    END RECORD,
    g_head_ogbb     RECORD
        oga01_ogbb  LIKE oga_file.oga01,
        oga02_ogbb  LIKE oga_file.oga02,
        oga03_ogbb  LIKE oga_file.oga03,
        oga032_ogbb LIKE oga_file.oga032,
        oga14_ogbb  LIKE oga_file.oga14,
        gen02_ogbb  LIKE gen_file.gen02,
        ogaconf_ogbb LIKE oga_file.ogaconf,
        ogapost_ogbb LIKE oga_file.ogapost
                    END RECORD,
    g_head_inb      RECORD
        ina00_inb   LIKE ina_file.ina00,
        ina01_inb   LIKE ina_file.ina01,
        ina11_inb   LIKE ina_file.ina11,
        gen02_inb   LIKE gen_file.gen02,
        ina04_inb   LIKE ina_file.ina04,
        gem02_inb   LIKE gem_file.gem02,
        inaconf_inb LIKE ina_file.inaconf,
        inapost_inb LIKE ina_file.inapost,
        ina02_inb   LIKE ina_file.ina03,
        ina03_inb   LIKE ina_file.ina03
                    END RECORD,
     g_head_ogbc     RECORD
        oga01_ogbc  LIKE oga_file.oga01,
        oga02_ogbc  LIKE oga_file.oga02,
        oga03_ogbc  LIKE oga_file.oga03,
        oga032_ogbc LIKE oga_file.oga032,
        oga14_ogbc  LIKE oga_file.oga14,
        gen02_ogbc  LIKE gen_file.gen02,
        ogaconf_ogbc LIKE oga_file.ogaconf,
        ogapost_ogbc LIKE oga_file.ogapost
                    END RECORD,
     g_head_ogbd     RECORD
        oga01_ogbd  LIKE oga_file.oga01,
        oga02_ogbd  LIKE oga_file.oga02,
        oga03_ogbd  LIKE oga_file.oga03,
        oga032_ogbd LIKE oga_file.oga032,
#       oga14_ogbd  LIKE oga_file.oga14,
#       gen02_ogbd  LIKE gen_file.gen02,
        ogaconf_ogbd LIKE oga_file.ogaconf,
        ogapost_ogbd LIKE oga_file.ogapost
                    END RECORD,
      g_head_ohb      RECORD
        oha01_ohb   LIKE oha_file.oha01,
        oha05_ohb   LIKE oha_file.oha05,
        oha02_ohb   LIKE oha_file.oha02,
        oha03_ohb   LIKE oha_file.oha03,
        oha032_ohb  LIKE oha_file.oha032,
        oha14_ohb   LIKE oha_file.oha14,
        gen02_ohb   LIKE gen_file.gen02,
        ohaconf_ohb LIKE oha_file.ohaconf,
        ohapost_ohb LIKE oha_file.ohapost
                    END RECORD,
      g_head_omb      RECORD
        oma01_omb   LIKE oma_file.oma01,
        oma02_omb   LIKE oma_file.oma02,
        oma03_omb   LIKE oma_file.oma03,
        oma032_omb  LIKE oma_file.oma032,
        oma70_omb   LIKE oma_file.oma70,
        omaconf_omb LIKE oma_file.omaconf,
        omavoid_omb LIKE oma_file.omavoid,
        omamksg_omb LIKE oma_file.omamksg
                    END RECORD,
     g_oeb           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        oeb03       LIKE oeb_file.oeb03,    #項次
        oeb04       LIKE oeb_file.oeb04,    #產品編號
        ima02       LIKE ima_file.ima02,    #品名規格
        ima021      LIKE ima_file.ima021,   #規格
        ima05       LIKE ima_file.ima05,    #款號
        oeb05       LIKE oeb_file.oeb05,    #銷售單位
        oeb12       LIKE oeb_file.oeb12,    #數量
        oeb24       LIKE oeb_file.oeb24,    #出貨量
        oebpro      LIKE type_file.num5,    #訂單進度
        oeb15       LIKE oeb_file.oeb15,    #約定交貨日
        oeb13       LIKE oeb_file.oeb13,    #單價
        oeb14       LIKE oeb_file.oeb14,    #稅前金額
        oeb14t      LIKE oeb_file.oeb14t,   #含稅金額
        oeb70       LIKE oeb_file.oeb70,    #結案否
        oeb70d      LIKE oeb_file.oeb70d    #結案日期
                    END RECORD,
    g_bmb           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        bmb02       LIKE bmb_file.bmb02,    #項次
        bmb03       LIKE bmb_file.bmb03,    #元件料號
        ima02_bom   LIKE ima_file.ima02,    #品名
        ima021_bom  LIKE ima_file.ima021,   #規格
        bmb06       LIKE bmb_file.bmb06,    #組成用量
        bmb07       LIKE bmb_file.bmb07,    #組件底數
        bmb10       LIKE bmb_file.bmb10,    #發料單位
        bmb08       LIKE bmb_file.bmb08     #損耗率
                    END RECORD,
    g_pmk           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
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
        pml21       LIKE pml_file.pml21,    #轉採購量
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
    g_sfb           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        sfb87       LIKE sfb_file.sfb87,    #
        sfb01       LIKE sfb_file.sfb01,    #
        sfb85       LIKE sfb_file.sfb85,    #
        sfb02       LIKE sfb_file.sfb02,    #
        sfb05       LIKE sfb_file.sfb05,    #
        ima02_sfb   LIKE ima_file.ima02,    #
        ima021_sfb  LIKE ima_file.ima021,   #規格
        ima05_sfb   LIKE ima_file.ima05,    #
        sfb08       LIKE sfb_file.sfb08,    #
        sfb081      LIKE sfb_file.sfb081,   #
        sfbpro      LIKE type_file.num5,    #
        sfb09       LIKE sfb_file.sfb09,    #
        sfbih       LIKE type_file.num5,    #
        sfb13       LIKE sfb_file.sfb13,    #
        sfb15       LIKE sfb_file.sfb15,    #
        sfb82       LIKE sfb_file.sfb82,    #
        gem02_sfb   LIKE gem_file.gem02,    #
        sfb04       LIKE sfb_file.sfb04     #
                    END RECORD,
    g_ecm           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        ecm03       LIKE ecm_file.ecm03,    #
        ecm04       LIKE ecm_file.ecm04,    #
        ecm45       LIKE ecm_file.ecm45,    #
        ecmwip      LIKE ecm_file.ecm315,   #
        ecmpro      LIKE type_file.num5,    #
        ecm301      LIKE ecm_file.ecm301,   #
        ecm302      LIKE ecm_file.ecm302,   #
        ecm303      LIKE ecm_file.ecm303,   #
        ecm311      LIKE ecm_file.ecm311,   #
        ecm312      LIKE ecm_file.ecm312,   #
        ecm313      LIKE ecm_file.ecm313,   #
        ecm314      LIKE ecm_file.ecm314,   #
        ecm315      LIKE ecm_file.ecm315,   #
        ecm316      LIKE ecm_file.ecm316    #
                    END RECORD,
    g_sgd           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        sgdslk05    LIKE sgd_file.sgdslk05, #
        sgd05       LIKE sgd_file.sgd05,    #
        sga02_sgd   LIKE sga_file.sga02,    #
        sgd06       LIKE sgd_file.sgd06,    #
        sgdslk04    LIKE sgd_file.sgdslk04, #
        sgl08_sgd   LIKE sgl_file.sgl08,    #
        skg09_sgd   LIKE skg_file.skg09,    #
        sgdpro      LIKE type_file.num5,    #
        sgd14       LIKE sgd_file.sgd14     #
                    END RECORD,
    g_sfa           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        sfa03       LIKE sfa_file.sfa03,    #
        ima02_sfa2  LIKE ima_file.ima02,    #
        ima021_sfa2 LIKE ima_file.ima021,   #規格
        sfa161      LIKE sfa_file.sfa161,   #
        sfa12       LIKE sfa_file.sfa12,    #
        sfa05       LIKE sfa_file.sfa05,    #
        sfa06       LIKE sfa_file.sfa06,    #
        sfapro      LIKE type_file.num5,    #
        sfa07       LIKE sfa_file.sfa07,    #
        sfa062      LIKE sfa_file.sfa062    #
                    END RECORD,
    g_oga           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        ogaconf     LIKE oga_file.ogaconf,  #
        ogapost     LIKE oga_file.ogapost,  #
        oga01       LIKE oga_file.oga01,    #
        oga02       LIKE oga_file.oga02,    #
        oga03       LIKE oga_file.oga03,    #
        oga032      LIKE oga_file.oga032,   #
        oga14       LIKE oga_file.oga14,    #
        gen02_oga   LIKE gen_file.gen02,    #
        oga011      LIKE oga_file.oga011    #
                    END RECORD,
    g_ogb           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        ogb03       LIKE ogb_file.ogb03,    #
        ogb04       LIKE ogb_file.ogb04,    #
        ogb06       LIKE ogb_file.ogb06,    #
        ima021_ogb  LIKE ima_file.ima021,   #規格
        ogb05       LIKE ogb_file.ogb05,    #
        ogb12       LIKE ogb_file.ogb12,    #
        ogb13       LIKE ogb_file.ogb13,    #
        ogb14       LIKE ogb_file.ogb14,    #
        ogb14t      LIKE ogb_file.ogb14t    #
                    END RECORD,
    g_ogab          DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        ogaconfb    LIKE oga_file.ogaconf,  #
        ogapostb    LIKE oga_file.ogapost,  #
        oga01b      LIKE oga_file.oga01,    #
        oga02b      LIKE oga_file.oga02,    #
        oga03b      LIKE oga_file.oga03,    #
        oga032b     LIKE oga_file.oga032,   #
        oga14b      LIKE oga_file.oga14,    #
        gen02_ogab  LIKE gen_file.gen02,    #
        oga011b     LIKE oga_file.oga011    #
                    END RECORD,
    g_ogbb          DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        ogb03b      LIKE ogb_file.ogb03,    #
        ogb04b      LIKE ogb_file.ogb04,    #
        ogb06b      LIKE ogb_file.ogb06,    #
        ima021_ogbb LIKE ima_file.ima021,   #規格
        ogb05b      LIKE ogb_file.ogb05,    #
        ogb12b      LIKE ogb_file.ogb12,    #
        ogb13b      LIKE ogb_file.ogb13,    #
        ogb14b      LIKE ogb_file.ogb14,    #
        ogb14tb     LIKE ogb_file.ogb14t    #
                    END RECORD,
    g_ina           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        ina00       LIKE ina_file.ina00,    #
        ina01       LIKE ina_file.ina01,    #
        ina02       LIKE ina_file.ina02,    #
        ina03       LIKE ina_file.ina03,    #
        ina04       LIKE ina_file.ina04,    #
        gem02_ina   LIKE gem_file.gem02,    #
        ina11       LIKE ina_file.ina11,    #
        gen02_ina   LIKE gen_file.gen02,    #
        inaconf     LIKE ina_file.inaconf,  #
        inapost     LIKE ina_file.inapost   #
                    END RECORD,
    g_inb           DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        inb03       LIKE inb_file.inb03,    #
        inb04       LIKE inb_file.inb04,    #
        ima02_inb   LIKE ima_file.ima02,    #
        ima021_inb  LIKE ima_file.ima021,   #規格
        ima05_inb   LIKE ima_file.ima05,    #
        inb05       LIKE inb_file.inb05,    #
        imd02_inb   LIKE imd_file.imd02,
        inb06       LIKE inb_file.inb06,    #
        ime03_inb   LIKE ime_file.ime03,
        inb07       LIKE inb_file.inb07,    #
        inb08       LIKE inb_file.inb08,    #
        inb09       LIKE inb_file.inb09,    #
        inb13       LIKE inb_file.inb13,    #
        inb14       LIKE inb_file.inb14,    #
        inb15       LIKE inb_file.inb15,    #
        azf03_inb   LIKE azf_file.azf03     # 
                    END RECORD,
     g_ogac          DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        ogaconfc    LIKE oga_file.ogaconf,  #
        ogapostc    LIKE oga_file.ogapost,  #
        oga01c      LIKE oga_file.oga01,    #
        oga02c      LIKE oga_file.oga02,    #
        oga03c      LIKE oga_file.oga03,    #
        oga032c     LIKE oga_file.oga032,   #
        oga14c      LIKE oga_file.oga14,    #
        gen02_ogac  LIKE gen_file.gen02,    #
        oga011c     LIKE oga_file.oga011    #
                    END RECORD,
    g_ogbc          DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        ogb03c      LIKE ogb_file.ogb03,    #
        ogb04c      LIKE ogb_file.ogb04,    #
        ogb06c      LIKE ogb_file.ogb06,    #
        ima021_ogbc LIKE ima_file.ima021,   #規格
        ogb05c      LIKE ogb_file.ogb05,    #
        ogb12c      LIKE ogb_file.ogb12,    #
        ogb13c      LIKE ogb_file.ogb13,    #
        ogb14c      LIKE ogb_file.ogb14,    #
        ogb14tc     LIKE ogb_file.ogb14t    #
                    END RECORD,
    g_ogad          DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        ogaconfd    LIKE oga_file.ogaconf,  #
        ogapostd    LIKE oga_file.ogapost,  #
        oga01d      LIKE oga_file.oga01,    #
        oga02d      LIKE oga_file.oga02,    #
        oga03d      LIKE oga_file.oga03,    #
        oga032d     LIKE oga_file.oga032,   #
#       oga14d      LIKE oga_file.oga14,    #
#       gen02_ogad  LIKE gen_file.gen02,    #
        oga011d     LIKE oga_file.oga011    #
                    END RECORD,
    g_ogbd          DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        ogb03d      LIKE ogb_file.ogb03,    #
        ogb04d      LIKE ogb_file.ogb04,    #
        ogb06d      LIKE ogb_file.ogb06,    #
        ima021_ogbd LIKE ima_file.ima021,   #規格
        ogb05d      LIKE ogb_file.ogb05,    #
        ogb12d      LIKE ogb_file.ogb12,    #
        ogb13d      LIKE ogb_file.ogb13,    #
        ogb14d      LIKE ogb_file.ogb14,    #
        ogb14td     LIKE ogb_file.ogb14t    #
                    END RECORD,
    g_oha          DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        ohaconf    LIKE oha_file.ohaconf,  #
        ohapost    LIKE oha_file.ohapost,  #
        oha01      LIKE oha_file.oha01,    #
        oha02      LIKE oha_file.oha02,    #
        oha05      LIKE oha_file.oha05,
        oha03      LIKE oha_file.oha03,    #
        oha032     LIKE oha_file.oha032,   #
        oha14      LIKE oha_file.oha14,    #
        gen02_oha  LIKE gen_file.gen02     #
                    END RECORD,
    g_ohb          DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        ohb03      LIKE ohb_file.ohb03,    #
        ohb04      LIKE ohb_file.ohb04,    #
        ohb06      LIKE ohb_file.ohb06,    #
        ima021_ohb LIKE ima_file.ima021,   #規格
        ohb05      LIKE ohb_file.ohb05,    #
        ohb12      LIKE ohb_file.ohb12,    #
        ohb13      LIKE ohb_file.ohb13,    #
        ohb14      LIKE ohb_file.ohb14,    #
        ohb14t     LIKE ohb_file.ohb14t    #
                    END RECORD,
     g_oma          DYNAMIC ARRAY OF RECORD 
        omaconf    LIKE oma_file.omaconf,  #
        omavoid    LIKE oma_file.omavoid,  #
        omamksg    LIKE oma_file.omamksg,  #
        oma01      LIKE oma_file.oma01,    #
        oma02      LIKE oma_file.oma02,    #
        oma70      LIKE oma_file.oma70,    #
        oma03      LIKE oma_file.oma03,    #
        oma032     LIKE oma_file.oma032    #
                    END RECORD,
     g_omb          DYNAMIC ARRAY OF RECORD #程式變數 (舊值)
        omb01      LIKE omb_file.omb01,
        omb03      LIKE omb_file.omb03,    #
        omb38      LIKE omb_file.omb38,
        omb31      LIKE omb_file.omb31,
        omb32      LIKE omb_file.omb32,
        omb04      LIKE omb_file.omb04,    #
        omb06      LIKE omb_file.omb06,    #
        ima021_omb LIKE ima_file.ima021,   #規格
        omb05      LIKE omb_file.omb05,    #
        omb12b     LIKE omb_file.omb12,    #
        omb13      LIKE omb_file.omb13,    #
        omb14      LIKE omb_file.omb14,    #
        omb14tb    LIKE omb_file.omb14t    #
                    END RECORD,
    g_rec_b_oeb     LIKE type_file.num5,    #單身筆數
    g_rec_b_bmb     LIKE type_file.num5,    #單身筆數
    g_rec_b_pmk     LIKE type_file.num5,    #單身筆數
    g_rec_b_pml     LIKE type_file.num5,    #單身筆數
    g_rec_b_pmm     LIKE type_file.num5,    #單身筆數
    g_rec_b_pmn     LIKE type_file.num5,    #單身筆數
    g_rec_b_sfb     LIKE type_file.num5,    #單身筆數
    g_rec_b_ecm     LIKE type_file.num5,    #單身筆數
    g_rec_b_sgd     LIKE type_file.num5,    #單身筆數
    g_rec_b_sfa     LIKE type_file.num5,    #單身筆數
    g_rec_b_oga     LIKE type_file.num5,    #單身筆數
    g_rec_b_ogb     LIKE type_file.num5,    #單身筆數
    g_rec_b_ogab    LIKE type_file.num5,    #單身筆數
    g_rec_b_ogbb    LIKE type_file.num5,    #單身筆數
    g_rec_b_ina     LIKE type_file.num5,    #單身筆數
    g_rec_b_inb     LIKE type_file.num5,    #單身筆數 
    g_rec_b_ogac    LIKE type_file.num5,    #單身筆數
    g_rec_b_ogbc    LIKE type_file.num5,    #單身筆數
    g_rec_b_ogad    LIKE type_file.num5,    #單身筆數
    g_rec_b_ogbd    LIKE type_file.num5,    #單身筆數 
    g_rec_b_oha     LIKE type_file.num5,    #單身筆數
    g_rec_b_ohb     LIKE type_file.num5,    #單身筆數
    g_rec_b_oma     LIKE type_file.num5,    #單身筆數
    g_rec_b_omb     LIKE type_file.num5,    #單身筆數
    l_ac_oeb        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_bmb        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_pmk        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_pml        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_pmm        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_pmn        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_sfb        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_ecm        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_sgd        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_sfa        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_oga        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_ogb        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_ogab       LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_ogbb       LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_ina        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_inb        LIKE type_file.num5,    #目前處理的ARRAY CNT 
    l_ac_ogac       LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_ogbc       LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_ogad       LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_ogbd       LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_oha        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_ohb        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_oma        LIKE type_file.num5,    #目前處理的ARRAY CNT
    l_ac_omb        LIKE type_file.num5     #目前處理的ARRAY CNT
DEFINE g_b_flag     LIKE type_file.num5
DEFINE g_b_flag2    LIKE type_file.num5
DEFINE g_b_flag3    LIKE type_file.num5
DEFINE g_b_flag4    LIKE type_file.num5
DEFINE g_int_flag   LIKE type_file.chr1
DEFINE g_oea01_o    LIKE oea_file.oea01
DEFINE g_oeb03_o    LIKE oeb_file.oeb03
DEFINE g_oea01_change_bmb LIKE type_file.chr1
DEFINE g_oea01_change_pml LIKE type_file.chr1
DEFINE g_oea01_change_pmn LIKE type_file.chr1
DEFINE g_oea01_change_ecm LIKE type_file.chr1
DEFINE g_oea01_change_sgd LIKE type_file.chr1
DEFINE g_oea01_change_sfa LIKE type_file.chr1
DEFINE g_oea01_change_ogb LIKE type_file.chr1
DEFINE g_oea01_change_ogbb LIKE type_file.chr1
DEFINE g_oea01_change_inb LIKE type_file.chr1
DEFINE g_oea01_change_ogbc LIKE type_file.chr1
DEFINE g_oea01_change_ogbd LIKE type_file.chr1
DEFINE g_oea01_change_ohb LIKE type_file.chr1
DEFINE g_oea01_change_omb LIKE type_file.chr1

DEFINE g_oeb03_change_pml LIKE type_file.chr1
DEFINE g_oeb03_change_pmn LIKE type_file.chr1
    
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("axm")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   OPEN WINDOW q001_w AT 5,10
        WITH FORM "axm/42f/axmq001" ATTRIBUTE(STYLE = g_win_style)  

   CALL cl_ui_init()
   CALL cl_set_act_visible("revert_filter",FALSE)
   CALL q001_q()   #FUN-C80102
   CALL q001_menu()
   DROP TABLE axmq001_tmp;
   CLOSE WINDOW q001_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q001_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       
   DEFINE   l_msg   STRING   
   DEFINE   l_wc    STRING
   DEFINE   l_action_page3    LIKE type_file.chr1


   WHILE TRUE
    #121016-----add----str
      IF g_action_choice = "exit"  THEN
         EXIT WHILE
      END IF
    #121016----add---end
      LET l_action_page3 = 'Y'
      IF cl_null(g_action_choice) THEN 
         IF g_action_flag = "page1" THEN  
            CALL q001_bp("G")
         END IF
         IF g_action_flag = "page2" THEN  
            CALL q001_bp2()
            IF g_action_flag = "page3" THEN
               LET l_action_page3 = 'N'             #如果从page2切到page3  则不直接进bp3()
            END IF
         END IF
         #121016---add---str
         IF g_action_flag = "page3" AND l_action_page3 = 'Y' THEN
            CALL q001_bp3()
         END IF
         #121016---add---end
      END IF 
      CASE g_action_choice
         WHEN "page1"
            CALL q001_bp("G")
         
         WHEN "page2"
            CALL q001_bp2()
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q001_q()    
            END IF   
            LET g_action_choice = " " 
#         WHEN "order_track"
#            IF cl_chk_act_auth() AND NOT cl_null(g_oea[l_ac].oea01) AND NOT cl_null(g_oea[l_ac].oeb03) THEN
#               LET l_msg = "axmq200 '",g_oea[l_ac].oea01,"' '",g_oea[l_ac].oeb03,"' "
#               CALL cl_cmdrun_wait(l_msg)
#            END IF     
#            LET g_action_choice = " "
#         WHEN "order_protect" 
#            IF cl_chk_act_auth() AND NOT cl_null(g_oea[l_ac].oea01) THEN
#               LET l_msg = "axmt410 '",g_oea[l_ac].oea01,"' 'query'"
#               CALL cl_cmdrun_wait(l_msg)
#            END IF
#            LET g_action_choice = " "
         WHEN "data_filter"
            IF cl_chk_act_auth() THEN
               CALL q001_filter_askkey()
               CALL q001()
               CALL q001_show()
            END IF 
            LET g_action_choice = " "           
         WHEN "revert_filter"
            IF cl_chk_act_auth() THEN
               LET g_filter_wc = ''
               CALL cl_set_act_visible("revert_filter",FALSE) 
               CALL q001()
               CALL q001_show() 
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
#              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oea_excel),base.TypeInfo.create(g_oea_1),'')
               LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               IF g_action_flag = "page1" THEN
                  LET page = f.FindNode("Page","page1")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_oea_excel),'','')
               END IF
               IF g_action_flag = "page2" THEN
                  LET page = f.FindNode("Page","page2")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_oea_1),'','')
               END IF
               IF g_action_flag = "page3" THEN
                  CALL q001_excel()
               END IF 
            END IF
            LET g_action_choice = " "
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               LET g_doc.column1 = "oea01"
               LET g_doc.value1 = ''
               CALL cl_doc()
            END IF
            LET g_action_choice = " "
        WHEN "oeb"
            IF cl_chk_act_auth() THEN
               CALL q001_b_fill_oeb('oeb01 ="'|| g_head.oea01_2||'"')
            END IF
            LET g_action_choice = " "
         WHEN "bmb"
            IF cl_chk_act_auth() THEN
               CALL q001_b_fill_bmb('bmb01 ="'|| g_head_bmb.bmb01||'"')
            END IF
            LET g_action_choice = " "
         WHEN "pmk"
            IF cl_chk_act_auth() THEN
#              IF NOT cl_null(g_head.oebislk01_2) THEN
#                 CALL q001_b_fill_pmk('pmlislk01 ="'|| g_head.oebislk01_2||'"')
#              ELSE
#                 CALL g_pmk.clear()
#              END IF
               CALL q001_b_fill_pmk('pml24 ="'|| g_head.oea01_2||'"')
            END IF
            LET g_action_choice = " "
         WHEN "pml"
            IF cl_chk_act_auth() THEN
               CALL q001_b_fill_pml('pml01 ="'|| g_head_pml.pml01||'"')
            END IF
            LET g_action_choice = " "
         WHEN "pmm"
            IF cl_chk_act_auth() THEN
#              IF NOT cl_null(g_head.oebislk01_2) THEN
#                 CALL q001_b_fill_pmm('pmnislk01 ="'|| g_head.oebislk01_2||'"')
#              ELSE
#                 CALL g_pmm.clear()
#              END IF
               CALL q001_b_fill_pmm('pmn24 ="'|| g_head.oea01_2||'"')   
            END IF
            LET g_action_choice = " "
         WHEN "pmn"
            IF cl_chk_act_auth() THEN
               CALL q001_b_fill_pmn('pmn01 ="'|| g_head_pmn.pmm01_pmn||'"')
            END IF
            LET g_action_choice = " "
         WHEN "sfb"
            IF cl_chk_act_auth() THEN
               CALL q001_b_fill_sfb('sfb22 ="'|| g_head.oea01_2||'"')
            END IF
            LET g_action_choice = " "
         WHEN "ecm"
            IF cl_chk_act_auth() THEN
               CALL q001_b_fill_ecm('ecm01 ="'|| g_head_ecm.sfb01_ecm||'"')
            END IF
            LET g_action_choice = " "
         WHEN "sgd"
            IF cl_chk_act_auth() THEN
               CALL q001_b_fill_sgd('sgd03 ="'|| g_ecm[l_ac_ecm].ecm03||'"')
            END IF
            LET g_action_choice = " "
         WHEN "sfa"
            IF cl_chk_act_auth() THEN
               CALL q001_b_fill_sfa('sfa01 ="'|| g_head_sfa.sfb01_sfa||'"')
            END IF
            LET g_action_choice = " "
         WHEN "oga"
            IF cl_chk_act_auth() THEN
               CALL q001_b_fill_oga('ogb31 ="'|| g_head.oea01_2||'"')
            END IF
            LET g_action_choice = " "
         WHEN "ogb"
            IF cl_chk_act_auth() THEN
               CALL q001_b_fill_ogb('ogb01 ="'|| g_head_ogb.oga01_ogb||'"')
            END IF
            LET g_action_choice = " "
         WHEN "ogab"
            IF cl_chk_act_auth() THEN
               CALL q001_b_fill_ogab('ogb31 ="'|| g_head.oea01_2||'"')
            END IF
            LET g_action_choice = " "
         WHEN "ogbb"
            IF cl_chk_act_auth() THEN
               CALL q001_b_fill_ogbb('ogb01 ="'|| g_head_ogbb.oga01_ogbb||'"')
            END IF
            LET g_action_choice = " "
         WHEN "ina"
            IF cl_chk_act_auth() THEN
#              CALL q001_b_fill_ina('ina10 ="'|| g_head.oea01_2||'"')
               CALL q001_b_fill_ina(g_head.oea01_2)   #1030 add
            END IF
            LET g_action_choice = " "
         WHEN "inb"
            IF cl_chk_act_auth() THEN
               CALL q001_b_fill_inb('inb01 ="'|| g_head_inb.ina01_inb||'"')
            END IF 
           LET g_action_choice = " "    
         WHEN "ogac"
            IF cl_chk_act_auth() THEN
               CALL q001_b_fill_ogac('ogb31 ="'|| g_head.oea01_2||'"')
            END IF
            LET g_action_choice = " "
         WHEN "ogbc"
            IF cl_chk_act_auth() THEN
               CALL q001_b_fill_ogbc('ogb01 ="'|| g_head_ogbc.oga01_ogbc||'"')
            END IF
            LET g_action_choice = " "
         WHEN "ogad"
            IF cl_chk_act_auth() THEN
               CALL q001_b_fill_ogad('ogb31 ="'|| g_head.oea01_2||'"')
            END IF
            LET g_action_choice = " "
         WHEN "ogbd"
            IF cl_chk_act_auth() THEN
               CALL q001_b_fill_ogbd('ogb01 ="'|| g_head_ogbd.oga01_ogbd||'"')
            END IF
            LET g_action_choice = " "
         WHEN "oha"
            IF cl_chk_act_auth() THEN
               LET l_wc = "ohb33 ='",g_head.oea01_2 CLIPPED,"'"
               CALL q001_b_fill_oha(l_wc)
            END IF
            LET g_action_choice = " "
        WHEN "ohb"
            IF cl_chk_act_auth() THEN
               CALL q001_b_fill_ohb('ohb01 ="'|| g_head_ohb.oha01_ohb||'"')
            END IF
            LET g_action_choice = " "
        WHEN "oma"
            IF cl_chk_act_auth() THEN
               LET l_wc = "ogb31 ='",g_head.oea01_2 CLIPPED,"'"
               CALL q001_b_fill_oma(l_wc)
            END IF
            LET g_action_choice = " "
        WHEN "omb"
            IF cl_chk_act_auth() THEN
               LET l_wc = "omb01 ='",g_head_omb.oma01_omb CLIPPED,"'"
               CALL q001_b_fill_omb(l_wc)
            END IF
            LET g_action_choice = " "
      END CASE
   END WHILE
END FUNCTION

FUNCTION q001_b_fill()
DEFINE l_wc    STRING
   LET g_sql = "SELECT h_b,oea00,oea01,oea08,oea901,oea03,oea032,oea04,occ02,occ03,oca02,oea02,oea14,gen02,", #FUN-D10105 add occ03,oca02  #FUN-D50044 add oea901
                       "oea15,gem02,oea23,oea21,oea211,oea213,oea10,oeaconf,oea72,oea49,oeb03,oeb04,",     
                       "oeb06,ima021,oeb11,ima131,oba02,oeb05,img10,oeb905,oeb12,oeb13,oeb14,oeb14t,oeb15,ogb12,",#FUN-D10105 add ima131,oba02   
                       "oeb24,ogb13,ogb14t,ohb12,ohb13,ohb14t,ogb16,ogb18,omb12,omb14t,sfb_count,sfb09,oebud01",  #darcy:2023/02/22
               "  FROM axmq001_tmp WHERE 1=1 AND (("
   
#   LET l_wc = ''  
#   IF tm.b ='N' AND tm.c = 'N' AND tm.d = 'N' THEN
#      RETURN
#   END IF          
   CALL q001_tmp_wc2() RETURNING l_wc
   IF NOT cl_null(l_wc) THEN
      LET g_sql = g_sql,l_wc,") OR oea65 = 'N' )"
   ELSE 
      LET g_sql = g_sql," oea65 = 'N' ))"
   END IF 
   
   LET g_sql = g_sql," ORDER BY oea00,oea01,oea08,",
                          "oea03,oea032,oea04,occ02,oea02,",
                          "oea14,gen02,oea15,gem02"
                          
   PREPARE axmq001_pb FROM g_sql
   DECLARE oea_curs  CURSOR FOR axmq001_pb        #CURSOR

   CALL g_oea.clear()
   CALL g_oea_excel.clear()    #add excel
   LET g_cnt = 1
   LET g_rec_b = 0
   #xj-add--1029---15:44
   LET g_oea_qty = 0
   LET g_oea_sum = 0
   LET g_oea_sum1= 0
   #xj-add--1029---15:44
   FOREACH oea_curs INTO g_oea_excel[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF g_cnt <= g_max_rec THEN
         LET g_oea[g_cnt].* = g_oea_excel[g_cnt].*
      END IF
      #xj-add--1029---15:36
      LET g_oea_qty = g_oea_qty + g_oea_excel[g_cnt].oeb12
      LET g_oea_sum = g_oea_sum + g_oea_excel[g_cnt].oeb14t
      LET g_oea_sum1= g_oea_sum1+ g_oea_excel[g_cnt].oeb14
      #xj-add--1029---15:36
      LET g_cnt = g_cnt + 1

#      IF g_cnt > g_max_rec THEN
#         CALL cl_err( '', 9035, 0 )
#         EXIT FOREACH
#      END IF
   END FOREACH
   IF g_cnt <= g_max_rec THEN
      CALL g_oea.deleteElement(g_cnt)
   END IF
   CALL g_oea_excel.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF g_rec_b > g_max_rec THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b = g_max_rec
   END IF
   DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION

FUNCTION q001_b_fill_2()
DEFINE l_wc,l_sql    STRING

   CALL g_oea_1.clear()
   LET g_rec_b2 = 0
   LET g_cnt = 1
   LET g_oea_qty = 0
   LET g_oea_sum = 0
   LET g_oea_sum1 = 0
   IF tm.b ='N' AND tm.c = 'N' AND tm.d = 'N' THEN
      RETURN
   END IF 
#  CALL q001_tmp_wc() RETURNING l_wc
#  LET l_sql = "SELECT SUM(oeb12),SUM(oeb14t),SUM(oeb14)",
#              " FROM axmq001_tmp WHERE (",l_wc,")"
#  PREPARE tmp_sum_prep FROM l_sql
#  EXECUTE tmp_sum_prep INTO g_oea_qty,g_oea_sum,g_oea_sum1

   CALL q001_get_sum()
     
END FUNCTION

FUNCTION q001_b_fill_oeb(p_wc)              #BODY FILL UP
DEFINE
    p_wc           LIKE type_file.chr1000

    LET g_sql =
        "SELECT oeb03,oeb04,'','','',oeb05,oeb12,oeb24,'',oeb15,oeb13,oeb14,oeb14t,oeb70,oeb70d ",
        " FROM oeb_file",
        " WHERE ", p_wc CLIPPED,
        " ORDER BY 1"
    PREPARE q001_oeb FROM g_sql
    DECLARE oeb_curs CURSOR FOR q001_oeb

    CALL g_oeb.clear()
    LET g_cnt = 1
    LET g_rec_b_oeb = 0
    MESSAGE "Searching!"
    FOREACH oeb_curs INTO g_oeb[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT ima02,ima021,ima05 INTO g_oeb[g_cnt].ima02,g_oeb[g_cnt].ima021,g_oeb[g_cnt].ima05 FROM ima_file
        WHERE ima01 = g_oeb[g_cnt].oeb04
       LET g_oeb[g_cnt].oebpro = g_oeb[g_cnt].oeb24/g_oeb[g_cnt].oeb12*100
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_oeb.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_oeb = g_cnt-1
    DISPLAY g_rec_b_oeb TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q001_b_fill_bmb(p_wc)              #BODY FILL UP
DEFINE
    p_wc           LIKE type_file.chr1000

    LET g_sql =
        "SELECT bmb02,bmb03,'','',bmb06,bmb07,bmb10,bmb08 ",
        " FROM bmb_file",
        " WHERE (bmb04 <='", g_today,"'"," OR bmb04 IS NULL )",
        "   AND (bmb05 >  '",g_today,"'"," OR bmb05 IS NULL )",
        "   AND ", p_wc CLIPPED,
        " ORDER BY 1"
    PREPARE q001_bmb FROM g_sql
    DECLARE bmb_curs CURSOR FOR q001_bmb

    CALL g_bmb.clear()
    LET g_cnt = 1
    LET g_rec_b_bmb = 0
    MESSAGE "Searching!"
    FOREACH bmb_curs INTO g_bmb[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT ima02,ima021 INTO g_bmb[g_cnt].ima02_bom,g_bmb[g_cnt].ima021_bom FROM ima_file
        WHERE ima01 = g_bmb[g_cnt].bmb03
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_bmb.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_bmb = g_cnt-1
    DISPLAY g_rec_b_bmb TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q001_b_fill_pmk(p_wc)              #BODY FILL UP
DEFINE
    p_wc           LIKE type_file.chr1000

    LET g_sql =
        "SELECT pmk18,pmk01,SUM(pml20),SUM(pml21),'',pmk04,MIN(pml33),pmk09,'',",
        "       pmk12,'',pmk25 ",
        " FROM pml_file,pmk_file",
        " WHERE pmk01 = pml01",
#       "   AND pml01 = pmli_file.pmli01(+)",
#       "   AND pml02 = pmli_file.pmli02(+)",
        "   AND ",p_wc CLIPPED,
        " GROUP BY pmk18,pmk01,pmk04,pmk09,pmk12,pmk25",
        " ORDER BY 1"
    PREPARE q001_pmk FROM g_sql
    DECLARE pmk_curs CURSOR FOR q001_pmk

    CALL g_pmk.clear()
    LET g_cnt = 1
    LET g_rec_b_pmk = 0
    MESSAGE "Searching!"
    FOREACH pmk_curs INTO g_pmk[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT pmc03 INTO g_pmk[g_cnt].pmc03_pmk FROM pmc_file
        WHERE pmc01 = g_pmk[g_cnt].pmk09
       SELECT gen02 INTO g_pmk[g_cnt].gen02_pmk FROM gen_file
        WHERE gen01 = g_pmk[g_cnt].pmk12
       LET g_pmk[g_cnt].pmkpro = g_pmk[g_cnt].spml21/g_pmk[g_cnt].spml20*100
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_pmk.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_pmk = g_cnt-1
    DISPLAY g_rec_b_pmk TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q001_b_fill_pml(p_wc)              #BODY FILL UP
DEFINE
    p_wc           LIKE type_file.chr1000

    LET g_sql =
        "SELECT pml02,pml04,pml041,'',pml07,pml20,pml21,'',pml33,pml16 ",
        " FROM pml_file",
        " WHERE ", p_wc CLIPPED,
        " ORDER BY 1"
    PREPARE q001_pml FROM g_sql
    DECLARE pml_curs CURSOR FOR q001_pml

    CALL g_pml.clear()
    LET g_cnt = 1
    LET g_rec_b_pml = 0
    MESSAGE "Searching!"
    FOREACH pml_curs INTO g_pml[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT ima021 INTO g_pml[g_cnt].ima021_pr FROM ima_file
        WHERE ima01 = g_pml[g_cnt].pml04
       LET g_pml[g_cnt].pmlpro = g_pml[g_cnt].pml21/g_pml[g_cnt].pml20*100
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

FUNCTION q001_b_fill_pmm(p_wc)              #BODY FILL UP
DEFINE
    p_wc           LIKE type_file.chr1000
DEFINE l_cnt   LIKE type_file.num5,#MOD-D60163 
       l_cnt2  LIKE type_file.num5 #MOD-D60163   

    LET p_wc = p_wc," AND pmm909 ='3'"
    LET g_sql =
        "SELECT pmm18,pmm01,SUM(pmn20),SUM(pmn53),'',pmm04,",
        "       MIN(pmn33),pmm09,'',pmm12,'',pmm25 ",
        " FROM pmn_file,pmm_file",
        " WHERE pmm01 = pmn01",
#       "   AND pmn01 = pmni_file.pmni01(+)",
#       "   AND pmn02 = pmni_file.pmni02(+)",
        "   AND ",p_wc CLIPPED,
        " GROUP BY pmm18,pmm01,pmm04,pmm09,pmm12,pmm25",
        " ORDER BY 1"
    #MOD-D60163 add begin----------------
    SELECT COUNT(*) INTO l_cnt FROM pmn_file WHERE pmn24 =  g_head.oea01_2
       IF l_cnt = 0 THEN 
          SELECT COUNT(*) INTO l_cnt2 FROM pml_file WHERE pml24 =  g_head.oea01_2
          IF l_cnt2 > 0 THEN 
             LET g_sql = 
            "SELECT pmm18,pmm01,SUM(pmn20),SUM(pmn53),'',pmm04,",
            "       MIN(pmn33),pmm09,'',pmm12,'',pmm25 ",
            " FROM pmn_file,pmm_file",
            " WHERE pmm01 = pmn01",
            " AND  pmm909 IN ('3','1','2')",
            " AND pmn24 IN (SELECT DISTINCT pml01 FROM pml_file WHERE pml24 ='", g_head.oea01_2, "')",
            " GROUP BY pmm18,pmm01,pmm04,pmm09,pmm12,pmm25",
            " ORDER BY 1"             
          END IF   
       END IF    
    #MOD-D60163 add end----------    
    PREPARE q001_pmm FROM g_sql
    DECLARE pmm_curs CURSOR FOR q001_pmm

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

FUNCTION q001_b_fill_pmn(p_wc)              #BODY FILL UP
DEFINE
    p_wc           LIKE type_file.chr1000

    LET g_sql =
        "SELECT pmn02,pmn04,pmn041,'',pmn07,pmn20,pmn53,'',",
        "       pmn33,pmn31,pmn31t,pmn88,pmn88t,pmn16,pmn24,pmn25 ",
        " FROM pmn_file",
        " WHERE ", p_wc CLIPPED,
        " ORDER BY 1"
    PREPARE q001_pmn FROM g_sql
    DECLARE pmn_curs CURSOR FOR q001_pmn

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

FUNCTION q001_b_fill_sfb(p_wc)              #BODY FILL UP
DEFINE
    p_wc           LIKE type_file.chr1000,
    l_cutwip       LIKE ecm_file.ecm315,
    l_packwip      LIKE ecm_file.ecm315,
    l_completed    LIKE ecm_file.ecm315,
    l_sfb93        LIKE sfb_file.sfb93,
    l_n            LIKE type_file.num5

    LET g_sql =
        "SELECT sfb87,sfb01,sfb85,sfb02,sfb05,'','','',sfb08,sfb081,'',sfb09,'',",
        "       sfb13,sfb15,sfb82,'',sfb04 ",
        " FROM sfb_file",
        " WHERE ",p_wc CLIPPED,
        " ORDER BY 3,2"
    PREPARE q001_sfb FROM g_sql
    DECLARE sfb_curs CURSOR FOR q001_sfb

    CALL g_sfb.clear()
    LET g_cnt = 1
    LET g_rec_b_sfb = 0
    MESSAGE "Searching!"
    FOREACH sfb_curs INTO g_sfb[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT ima02,ima021,ima05 INTO g_sfb[g_cnt].ima02_sfb,g_sfb[g_cnt].ima021_sfb,g_sfb[g_cnt].ima05_sfb FROM ima_file
        WHERE ima01 = g_sfb[g_cnt].sfb05
       SELECT gem02 INTO g_sfb[g_cnt].gem02_sfb FROM gem_file
        WHERE gem01 = g_sfb[g_cnt].sfb82
       IF cl_null(g_sfb[g_cnt].gem02_sfb) THEN
          SELECT pmc03 INTO g_sfb[g_cnt].gem02_sfb FROM pmc_file
           WHERE pmc01 = g_sfb[g_cnt].sfb82
       END IF

#      SELECT ecm301+ecm302+ecm303-ecm311-ecm312-ecm313-ecm314-ecm316 INTO l_cutwip
#        FROM ecm_file
#       WHERE ecm01 = g_sfb[g_cnt].sfb01
#         AND ecm03 = '2'
#      SELECT ecm301+ecm302+ecm303-ecm311-ecm312-ecm313-ecm314-ecm316 INTO l_packwip
#        FROM ecm_file
#       WHERE ecm01 = g_sfb[g_cnt].sfb01
#         AND ecm03 = '3'
#      SELECT ecm311+ecm312+ecm313+ecm314+ecm315+ecm316 INTO l_completed
#        FROM ecm_file
#       WHERE ecm01 = g_sfb[g_cnt].sfb01
#         AND ecm03 = '3'
#
#      LET g_sfb[g_cnt].sfbpro = (l_cutwip*0.2+l_packwip*0.8+l_completed)/g_sfb[g_cnt].sfb08*100
       SELECT sfb93 INTO l_sfb93 FROM sfb_file WHERE sfb01 = g_sfb[g_cnt].sfb01
       IF l_sfb93 = 'N' THEN  
          LET g_sfb[g_cnt].sfbpro =  g_sfb[g_cnt].sfb09 / g_sfb[g_cnt].sfb08 * 100
       ELSE
          LET l_n = 0
          SELECT COUNT(*) INTO l_n FROM ecm_file
             WHERE ecm01 = g_sfb[g_cnt].sfb01 
          SELECT SUM(ecm311*(ecm63/ecm62)) INTO l_cutwip FROM ecm_file
             WHERE ecm01 = g_sfb[g_cnt].sfb01 
          LET l_packwip = g_sfb[g_cnt].sfb08 * l_n
          LET g_sfb[g_cnt].sfbpro = l_cutwip / l_packwip * 100
       END IF
       LET g_sfb[g_cnt].sfbih = g_sfb[g_cnt].sfb09/g_sfb[g_cnt].sfb08*100
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_sfb.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_sfb = g_cnt-1
    DISPLAY g_rec_b_sfb TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q001_b_fill_ecm(p_wc)              #BODY FILL UP
DEFINE
    p_wc           LIKE type_file.chr1000

    LET g_sql =
        "SELECT ecm03,ecm04,ecm45,'','',ecm301,ecm302,ecm303,ecm311,",
        "       ecm312,ecm313,ecm314,ecm315,ecm316 ",
        " FROM ecm_file",
        " WHERE ",p_wc CLIPPED,
        " ORDER BY 1"
    PREPARE q001_ecm FROM g_sql
    DECLARE ecm_curs CURSOR FOR q001_ecm

    CALL g_ecm.clear()
    LET g_cnt = 1
    LET g_rec_b_ecm = 0
    MESSAGE "Searching!"
    FOREACH ecm_curs INTO g_ecm[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_ecm[g_cnt].ecmwip = g_ecm[g_cnt].ecm301
                               + g_ecm[g_cnt].ecm302
                               + g_ecm[g_cnt].ecm303
                               - g_ecm[g_cnt].ecm311
                               - g_ecm[g_cnt].ecm312
                               - g_ecm[g_cnt].ecm313
                               - g_ecm[g_cnt].ecm314
                               - g_ecm[g_cnt].ecm316
       LET g_ecm[g_cnt].ecmpro = g_ecm[g_cnt].ecmwip/g_head_ecm.sfb08_ecm*100
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ecm.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_ecm = g_cnt-1
    DISPLAY g_rec_b_ecm TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q001_b_fill_sgd(p_wc)              #BODY FILL UP
DEFINE
    p_wc           LIKE type_file.chr1000

#    LET g_sql =
#        "SELECT A.sgdslk05,sgd05,'',sgd06,sgdslk04,A.sgl08,SUM(skg09),'',sgd14",
#        "  FROM sgd_file,skg_file,",
#        "      (SELECT sgdslk05,SUM(sgl08) as sgl08 FROM sgd_file,sgl_file",
#        "      WHERE sgd00 = sgl_file.sgl04(+)",
#        "        AND sgd03 = sgl_file.sgl06(+)",
#        "        AND sgd05 = sgl_file.sgl07(+)",
#        "        AND ",p_wc CLIPPED,
#        "        AND sgd00 = '",g_head_ecm.sfb01_ecm,"'",
#        "      GROUP BY sgdslk05)A",
#        " WHERE A.sgdslk05 = sgd_file.sgdslk05",
#        "   AND sgd00 = skg_file.skg12(+)",
#        "   AND ",p_wc CLIPPED,
#        "   AND sgd00 = '",g_head_ecm.sfb01_ecm,"'",
#        " GROUP BY A.sgdslk05,sgd05,sgd06,sgdslk04,A.sgl08,sgd14",
#        " ORDER BY 1"
    LET g_sql =                                                                 #xj sql mod
        "SELECT A.sgdslk05,sgd05,'',sgd06,sgdslk04,A.sgl08,SUM(skg09),'',sgd14",
        "  FROM sgd_file LEFT OUTER JOIN skg_file ON sgd00=skg12,",
        "      (SELECT sgdslk05,SUM(sgl08) as sgl08 FROM sgd_file",
        "       LEFT OUTER JOIN sgl_file ON sgd00 = sgl04",
        "                               AND sgd03 = sgl06",
        "                               AND sgd05 = sgl07",
        "                             WHERE ",p_wc CLIPPED,
        "                               AND sgd00 = '",g_head_ecm.sfb01_ecm,"'",
        "                             GROUP BY sgdslk05) A",
        " WHERE A.sgdslk05 = sgd_file.sgdslk05",
        "   AND ",p_wc CLIPPED,
        "   AND sgd00 = '",g_head_ecm.sfb01_ecm,"'",
        " GROUP BY A.sgdslk05,sgd05,sgd06,sgdslk04,A.sgl08,sgd14",
        " ORDER BY 1"

    PREPARE q001_sgd FROM g_sql
    DECLARE sgd_curs CURSOR FOR q001_sgd

    CALL g_sgd.clear()
    LET g_cnt = 1
    LET g_rec_b_sgd = 0
    MESSAGE "Searching!"
    FOREACH sgd_curs INTO g_sgd[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT sga02 INTO g_sgd[g_cnt].sga02_sgd FROM sga_file
        WHERE sga01 = g_sgd[g_cnt].sgd05
       LET g_sgd[g_cnt].sgdpro = g_sgd[g_cnt].sgl08_sgd/g_sgd[g_cnt].skg09_sgd*100
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_sgd.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_sgd = g_cnt-1
    DISPLAY g_rec_b_sgd TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q001_b_fill_sfa(p_wc)              #BODY FILL UP
DEFINE
    p_wc           LIKE type_file.chr1000

    LET g_sql =
        "SELECT sfa03,'','',sfa161,sfa12,sfa05,sfa06,'',sfa07,sfa062",
        " FROM sfa_file",
        " WHERE ",p_wc CLIPPED,
        " ORDER BY 1"
    PREPARE q001_sfa FROM g_sql
    DECLARE sfa_curs CURSOR FOR q001_sfa

    CALL g_sfa.clear()
    LET g_cnt = 1
    LET g_rec_b_sfa = 0
    MESSAGE "Searching!"
    FOREACH sfa_curs INTO g_sfa[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT ima02,ima021 INTO g_sfa[g_cnt].ima02_sfa2,g_sfa[g_cnt].ima021_sfa2 FROM ima_file
        WHERE ima01 = g_sfa[g_cnt].sfa03
       LET g_sfa[g_cnt].sfapro = g_sfa[g_cnt].sfa06/g_sfa[g_cnt].sfa05*100
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_sfa.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_sfa = g_cnt-1
    DISPLAY g_rec_b_sfa TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q001_b_fill_oga(p_wc)              #BODY FILL UP
DEFINE
    p_wc           LIKE type_file.chr1000

    LET g_sql =
        "SELECT ogaconf,ogapost,oga01,oga02,oga03,oga032,oga14,'',oga011",
        "  FROM oga_file,ogb_file ",
        " WHERE oga01=ogb01 AND ( oga09='1'  OR oga09='5')",
        "   AND ",p_wc CLIPPED,
        " ORDER BY 3"
    PREPARE q001_oga FROM g_sql
    DECLARE oga_curs CURSOR FOR q001_oga

    CALL g_oga.clear()
    LET g_cnt = 1
    LET g_rec_b_oga = 0
    MESSAGE "Searching!"
    FOREACH oga_curs INTO g_oga[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT gen02 INTO g_oga[g_cnt].gen02_oga FROM gen_file
        WHERE gen01 = g_oga[g_cnt].oga14
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_oga.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_oga = g_cnt-1
    DISPLAY g_rec_b_oga TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q001_b_fill_ogb(p_wc)              #BODY FILL UP
DEFINE
    p_wc           LIKE type_file.chr1000

    LET g_sql =
        "SELECT ogb03,ogb04,ogb06,'',ogb05,ogb12,ogb13,ogb14,ogb14t",
        " FROM ogb_file",
        " WHERE ",p_wc CLIPPED,
        " ORDER BY 1"
    PREPARE q001_ogb FROM g_sql
    DECLARE ogb_curs CURSOR FOR q001_ogb

    CALL g_ogb.clear()
    LET g_cnt = 1
    LET g_rec_b_ogb = 0
    MESSAGE "Searching!"
    FOREACH ogb_curs INTO g_ogb[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT ima021 INTO g_ogb[g_cnt].ima021_ogb FROM ima_file
        WHERE ima01 = g_ogb[g_cnt].ogb04
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ogb.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_ogb = g_cnt-1
    DISPLAY g_rec_b_ogb TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q001_b_fill_ogab(p_wc)              #BODY FILL UP
DEFINE
    p_wc           LIKE type_file.chr1000

    LET g_sql =
        "SELECT ogaconf,ogapost,oga01,oga02,oga03,oga032,oga14,'',oga011",
        "  FROM oga_file,ogb_file ",
        " WHERE oga01=ogb01 AND (oga09 = '2' OR oga09='4' OR oga09 = '3' OR oga09 = '6' OR oga09 = 'A')",
        "   AND ",p_wc CLIPPED,
        " ORDER BY 3"
    PREPARE q001_ogab FROM g_sql
    DECLARE ogab_curs CURSOR FOR q001_ogab

    CALL g_ogab.clear()
    LET g_cnt = 1
    LET g_rec_b_ogab = 0
    MESSAGE "Searching!"
    FOREACH ogab_curs INTO g_ogab[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT gen02 INTO g_ogab[g_cnt].gen02_ogab FROM gen_file
        WHERE gen01 = g_ogab[g_cnt].oga14b
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ogab.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_ogab = g_cnt-1
    DISPLAY g_rec_b_ogab TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q001_b_fill_ogbb(p_wc)              #BODY FILL UP
DEFINE
    p_wc           LIKE type_file.chr1000

    LET g_sql =
        "SELECT ogb03,ogb04,ogb06,'',ogb05,ogb12,ogb13,ogb14,ogb14t",
        " FROM ogb_file",
        " WHERE ",p_wc CLIPPED,
        " ORDER BY 1"
    PREPARE q001_ogbb FROM g_sql
    DECLARE ogbb_curs CURSOR FOR q001_ogbb

    CALL g_ogbb.clear()
    LET g_cnt = 1
    LET g_rec_b_ogbb = 0
    MESSAGE "Searching!"
    FOREACH ogbb_curs INTO g_ogbb[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT ima021 INTO g_ogbb[g_cnt].ima021_ogbb FROM ima_file
        WHERE ima01 = g_ogbb[g_cnt].ogb04b
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ogbb.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_ogbb = g_cnt-1
    DISPLAY g_rec_b_ogbb TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q001_b_fill_ina(p_sfb22)              #BODY FILL UP
DEFINE
#   p_wc           LIKE type_file.chr1000
    p_sfb22        LIKE sfb_file.sfb22,
    l_sfb01        LIKE sfb_file.sfb01

    SELECT DISTINCT sfb01 INTO l_sfb01 
     FROM sfb_file WHERE sfb22 = p_sfb22
                    	
    LET g_sql =
        "SELECT ina00,ina01,ina02,ina03,ina04,'',ina11,'',inaconf,inapost ",
        " FROM ina_file",
#       " WHERE ", p_wc CLIPPED,
        " WHERE ina10 = '",l_sfb01 CLIPPED,"'",
        " ORDER BY 1"
    PREPARE q001_ina FROM g_sql
    DECLARE ina_curs CURSOR FOR q001_ina

    CALL g_ina.clear()
    LET g_cnt = 1
    LET g_rec_b_ina = 0
    MESSAGE "Searching!"
    FOREACH ina_curs INTO g_ina[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT gem02 INTO g_ina[g_cnt].gem02_ina FROM gem_file
        WHERE gem01 = g_ina[g_cnt].ina04
       SELECT gen02 INTO g_ina[g_cnt].gen02_ina FROM gen_file
        WHERE gen01 = g_ina[g_cnt].ina11
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ina.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_ina = g_cnt-1
    DISPLAY g_rec_b_ina TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q001_b_fill_inb(p_wc)              #BODY FILL UP
DEFINE
    p_wc           LIKE type_file.chr1000

    LET g_sql =
        "SELECT inb03,inb04,'','','',inb05,'',inb06,'',inb07,inb08,inb09,inb13,inb14,inb15,'' ",
        " FROM inb_file",
        " WHERE ", p_wc CLIPPED,
        " ORDER BY 1"
    PREPARE q001_inb FROM g_sql
    DECLARE inb_curs CURSOR FOR q001_inb

    CALL g_inb.clear()
    LET g_cnt = 1
    LET g_rec_b_inb = 0
    MESSAGE "Searching!"
    FOREACH inb_curs INTO g_inb[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT ima02,ima021,ima05 INTO g_inb[g_cnt].ima02_inb,g_inb[g_cnt].ima021_inb,g_inb[g_cnt].ima05_inb
         FROM ima_file
        WHERE ima01 = g_inb[g_cnt].inb04
       SELECT azf03 INTO g_inb[g_cnt].azf03_inb FROM azf_file
        WHERE azf01 = g_inb[g_cnt].inb15
          AND azf02 = '2'
       SELECT imd02 INTO g_inb[g_cnt].imd02_inb FROM imd_file
        WHERE imd01 = g_inb[g_cnt].inb05
       SELECT ime03 INTO g_inb[g_cnt].ime03_inb FROM ime_file
        WHERE ime01 = g_inb[g_cnt].inb05 
          AND ime02 = g_inb[g_cnt].inb06
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_inb.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_inb = g_cnt-1
    DISPLAY g_rec_b_inb TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q001_b_fill_ogac(p_wc)              #BODY FILL UP
DEFINE
    p_wc           LIKE type_file.chr1000

    LET g_sql =
        "SELECT ogaconf,ogapost,oga01,oga02,oga03,oga032,oga14,'',oga011",
        "  FROM oga_file,ogb_file ",
        " WHERE oga01=ogb01 AND oga09='8'",
        "   AND ",p_wc CLIPPED,
        " ORDER BY 3"
    PREPARE q001_ogac FROM g_sql
    DECLARE ogac_curs CURSOR FOR q001_ogac

    CALL g_ogac.clear()
    LET g_cnt = 1
    LET g_rec_b_ogac = 0
    MESSAGE "Searching!"
    FOREACH ogac_curs INTO g_ogac[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT gen02 INTO g_ogac[g_cnt].gen02_ogac FROM gen_file
        WHERE gen01 = g_ogac[g_cnt].oga14c
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ogac.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_ogac = g_cnt-1
    DISPLAY g_rec_b_ogac TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q001_b_fill_ogbc(p_wc)              #BODY FILL UP
DEFINE
    p_wc           LIKE type_file.chr1000

    LET g_sql =
        "SELECT ogb03,ogb04,ogb06,'',ogb05,ogb12,ogb13,ogb14,ogb14t",
        " FROM ogb_file",
        " WHERE ",p_wc CLIPPED,
        " ORDER BY 1"
    PREPARE q001_ogbc FROM g_sql
    DECLARE ogbc_curs CURSOR FOR q001_ogbc

    CALL g_ogbc.clear()
    LET g_cnt = 1
    LET g_rec_b_ogbc = 0
    MESSAGE "Searching!"
    FOREACH ogbc_curs INTO g_ogbc[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT ima021 INTO g_ogbc[g_cnt].ima021_ogbc FROM ima_file
        WHERE ima01 = g_ogbc[g_cnt].ogb04c
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ogbc.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_ogbc = g_cnt-1
    DISPLAY g_rec_b_ogbc TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q001_b_fill_ogad(p_wc)              #BODY FILL UP
DEFINE
    p_wc           LIKE type_file.chr1000

    LET g_sql =
        "SELECT ogaconf,ogapost,oga01,oga02,oga03,oga032,oga011",
        "  FROM oga_file,ogb_file",
        " WHERE oga01=ogb01 AND oga09='9'",
        "   AND ",p_wc CLIPPED,
        " ORDER BY 3"
    PREPARE q001_ogad FROM g_sql
    DECLARE ogad_curs CURSOR FOR q001_ogad

    CALL g_ogad.clear()
    LET g_cnt = 1
    LET g_rec_b_ogad = 0
    MESSAGE "Searching!"
    FOREACH ogad_curs INTO g_ogad[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#      SELECT gen02 INTO g_ogad[g_cnt].gen02_ogad FROM gen_file
#       WHERE gen01 = g_ogad[g_cnt].oga14d
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ogad.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_ogad = g_cnt-1
    DISPLAY g_rec_b_ogad TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q001_b_fill_ogbd(p_wc)              #BODY FILL UP
DEFINE
    p_wc           LIKE type_file.chr1000

    LET g_sql =
        "SELECT ogb03,ogb04,ogb06,'',ogb05,ogb12,ogb13,ogb14,ogb14t",
        " FROM ogb_file",
        " WHERE ",p_wc CLIPPED,
        " ORDER BY 1"
    PREPARE q001_ogbd FROM g_sql
    DECLARE ogbd_curs CURSOR FOR q001_ogbd

    CALL g_ogbd.clear()
    LET g_cnt = 1
    LET g_rec_b_ogbd = 0
    MESSAGE "Searching!"
    FOREACH ogbd_curs INTO g_ogbd[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT ima021 INTO g_ogbd[g_cnt].ima021_ogbd FROM ima_file
        WHERE ima01 = g_ogbd[g_cnt].ogb04d
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ogbd.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_ogbd = g_cnt-1
    DISPLAY g_rec_b_ogbd TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q001_b_fill_oha(p_wc)              #BODY FILL UP
DEFINE
    p_wc           STRING

    LET g_sql =
        "SELECT DISTINCT ohaconf,ohapost,oha01,oha02,oha05,oha03,oha032,oha14,''",
        " FROM oha_file,ohb_file",
        " WHERE  oha01=ohb01 AND ",p_wc CLIPPED,
        " ORDER BY 3"
    PREPARE q001_oha FROM g_sql
    DECLARE oha_curs CURSOR FOR q001_oha

    CALL g_oha.clear()
    LET g_cnt = 1
    LET g_rec_b_oha = 0
    MESSAGE "Searching!"
    FOREACH oha_curs INTO g_oha[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT gen02 INTO g_oha[g_cnt].gen02_oha FROM gen_file
        WHERE gen01 = g_oha[g_cnt].oha14
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_oha.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_oha = g_cnt-1
    DISPLAY g_rec_b_oha TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q001_b_fill_ohb(p_wc)              #BODY FILL UP
DEFINE
    p_wc           LIKE type_file.chr1000

    LET g_sql =
        "SELECT ohb03,ohb04,ohb06,'',ohb05,ohb12,ohb13,ohb14,ohb14t",
        " FROM ohb_file",
        " WHERE ",p_wc CLIPPED,
        " ORDER BY 1"
    PREPARE q001_ohb FROM g_sql
    DECLARE ohb_curs CURSOR FOR q001_ohb

    CALL g_ohb.clear()
    LET g_cnt = 1
    LET g_rec_b_ohb = 0
    MESSAGE "Searching!"
    FOREACH ohb_curs INTO g_ohb[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT ima021 INTO g_ohb[g_cnt].ima021_ohb FROM ima_file
        WHERE ima01 = g_ohb[g_cnt].ohb04
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ohb.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_ohb = g_cnt-1
    DISPLAY g_rec_b_ohb TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q001_b_fill_oma(p_wc)              #BODY FILL UP
DEFINE
    p_wc           STRING

    LET g_sql =
        "SELECT DISTINCT omaconf,omavoid,omamksg,oma01,oma02,oma70,oma03,oma032",
        " FROM oma_file,omb_file,oga_file,ogb_file",
        " WHERE  oma01 = omb01 AND omb01 = oga10",
        "   AND  oga01 = ogb01 AND omb31 = ogb01",
        "   AND  omb32 = ogb03 AND ",p_wc CLIPPED,
        " ORDER  BY 3"
    PREPARE q001_oma FROM g_sql
    DECLARE oma_curs CURSOR FOR q001_oma

    CALL g_oma.clear()
    LET g_cnt = 1
    LET g_rec_b_oma = 0
    MESSAGE "Searching!"
    FOREACH oma_curs INTO g_oma[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_oma.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_oma = g_cnt-1
    DISPLAY g_rec_b_oma TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q001_b_fill_omb(p_wc)              #BODY FILL UP
DEFINE
    p_wc           STRING

    LET g_sql =
        "SELECT omb01,omb03,omb38,omb31,omb32,omb04,omb06,'',omb05,omb12,omb13,omb14,omb14t",
        " FROM omb_file WHERE ",p_wc CLIPPED,
        " ORDER BY 1"
    PREPARE q001_omb FROM g_sql
    DECLARE omb_curs CURSOR FOR q001_omb

    CALL g_omb.clear()
    LET g_cnt = 1
    LET g_rec_b_omb = 0
    MESSAGE "Searching!"
    FOREACH omb_curs INTO g_omb[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT ima021 INTO g_omb[g_cnt].ima021_omb FROM ima_file
        WHERE ima01 = g_omb[g_cnt].omb04
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_omb.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b_omb = g_cnt-1
    DISPLAY g_rec_b_omb TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q001_bp(p_ud)
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
      CALL q001_b_fill()
   END IF
   
   LET g_action_choice = " "
   LET g_flag = ' '
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY BY NAME tm.a
   DISPLAY g_oea_qty TO FORMONLY.tot_qty_1
   DISPLAY g_oea_sum TO FORMONLY.tot_sum_1
   DISPLAY g_oea_sum1 TO FORMONLY.tot_sum1_1
   DISPLAY ARRAY g_oea TO s_oea.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG

      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
         LET g_action_choice = "page1"
         EXIT DIALOG 
   END INPUT
   DISPLAY ARRAY g_oea TO s_oea.* ATTRIBUTE(COUNT=g_rec_b)
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
      CALL act_page3()
      EXIT DIALOG
   
#  ON ACTION order_track
#     LET l_ac = ARR_CURR()
#     LET g_action_choice="order_track"
#     EXIT DIALOG

#  ON ACTION order_protect
#     LET l_ac = ARR_CURR()
#     LET g_action_choice="order_protect"
#     EXIT DIALOG 

   ON ACTION data_filter
      LET g_action_choice="data_filter"
      EXIT DIALOG     

   ON ACTION revert_filter         
      LET g_action_choice="revert_filter"
      EXIT DIALOG 

   ON ACTION refresh_detail
      CALL q001_b_fill()
      CALL cl_set_comp_visible("page2", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page2", TRUE)
      LET g_action_choice = 'page1' 
      EXIT DIALOG

   #121016---xj--add-----str
      ON ACTION page3
         LET l_ac = ARR_CURR()
         CALL act_page3()
         EXIT DIALOG
   #121016---xj---add---end
    
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

      &include "qry_string.4gl"
   
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp2()
DEFINE l_cutwip        LIKE ecm_file.ecm315,
       l_packwip       LIKE ecm_file.ecm315,
       l_completed     LIKE ecm_file.ecm315,
       l_sfb08         LIKE sfb_file.sfb08 
   LET g_flag = ' '
   LET g_action_flag = 'page2' 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY  tm.a TO a
   DISPLAY ARRAY g_oea_1 TO s_oea_1.* ATTRIBUTE(COUNT=g_rec_b2)
       BEFORE DISPLAY
           EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL cl_set_comp_visible("page2", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page2", TRUE)
            LET g_action_choice = "page1"
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY  tm.a TO a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_oea_1 TO s_oea_1.* ATTRIBUTE(COUNT=g_rec_b2)
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
      IF NOT cl_null(g_action_choice) AND l_ac1 > 0  THEN
         CALL q001_detail_fill(l_ac1)
         CALL cl_set_comp_visible("page2", FALSE)
         CALL cl_set_comp_visible("page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2", TRUE)
         CALL cl_set_comp_visible("page3", TRUE)
         LET g_action_choice= "page1"  #0921
         LET g_flag = '1'              #0921 
         EXIT DIALOG 
      END IF
   

   ON ACTION refresh_detail
      CALL q001_b_fill()
      CALL cl_set_comp_visible("page2,page3", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page2,page3", TRUE)
      LET g_action_choice = 'page1' 
      EXIT DIALOG
   #121016---xj--add-----str
      ON ACTION page3
         LET l_ac = g_oea.getLength()
         IF l_ac > 0 THEN
            LET l_ac = 1
         END IF
         CALL act_page3()
         EXIT DIALOG
   #121016---xj---add---end      
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

FUNCTION q001_cs()
   DEFINE  l_cnt LIKE type_file.num5   
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01     
   DEFINE li_chk_bookno  LIKE type_file.num5
 
   CLEAR FORM #清除畫面
   CALL g_oea.clear()
   CALL g_oea_1.clear() 
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL                   # Default condition 
   LET g_filter_wc = ''
   CALL cl_set_act_visible("revert_filter",FALSE)     #FUN-D10105 add 
   LET tm.a = '4'   
   LET tm.b = 'Y'
   LET tm.c = 'Y'
   LET tm.d = 'Y'
   LET tm.e = 'Y'
   LET tm.f = 'Y'
   LET tm.g = 'Y'
   LET tm.h = '3'
   LET g_int_flag = '0'
   LET g_oea01_change_bmb = '0'
   LET g_oea01_change_pml = '0'
   LET g_oea01_change_pmn = '0'
   LET g_oea01_change_ecm = '0'
   LET g_oea01_change_sgd = '0'
   LET g_oea01_change_sfa = '0'
   LET g_oea01_change_ogb = '0'
   LET g_oea01_change_ogbb = '0'
   LET g_oea01_change_inb = '0'
   LET g_oea01_change_ogbc = '0'
   LET g_oea01_change_ogbd = '0'
   LET g_oea01_change_ohb = '0'
   LET g_oea01_change_omb = '0'

   LET g_oeb03_change_pml = '0'
   LET g_oeb03_change_pmn = '0'
   CALL cl_set_comp_visible("page2", FALSE)
   CALL cl_set_comp_visible("page3", FALSE)
   CALL ui.interface.refresh()
   CALL cl_set_comp_visible("page2", TRUE)
   CALL cl_set_comp_visible("page3", TRUE)
DIALOG ATTRIBUTE(UNBUFFERED)    
   INPUT BY NAME tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
        ATTRIBUTE(WITHOUT DEFAULTS)
        
#      BEFORE INPUT
#         CALL cl_qbe_display_condition(lc_qbe_sn)  
        
   END INPUT

      CONSTRUCT tm.wc2 ON oea00,oea01,oea08,oea901,oea03,oea032,oea04,occ03,oea02,oea14,oea15,  #FUN-D10105 occ03  #FUN-D50044 oea901
                       oea23,oea21,oea211,oea213,oea10,oeaconf,oea72,oea49,oeb03,oeb04,oeb06,
                       oeb11,ima131,oeb05,oeb905,oeb12,oeb13,oeb14,oeb14t,oeb15,         #FUN-D10105 ima131
                       oeb24 
                  FROM s_oea[1].oea00, s_oea[1].oea01,s_oea[1].oea08, s_oea[1].oea901, s_oea[1].oea03, s_oea[1].oea032,  #FUN-D50044 oea901
                       s_oea[1].oea04, s_oea[1].occ03,s_oea[1].oea02, s_oea[1].oea14,     #FUN-D10105 occ03
                       s_oea[1].oea15, s_oea[1].oea23,s_oea[1].oea21, s_oea[1].oea211,
                       s_oea[1].oea213,s_oea[1].oea10,s_oea[1].oeaconf,s_oea[1].oea72,s_oea[1].oea49,s_oea[1].oeb03,
                       s_oea[1].oeb04, s_oea[1].oeb06,s_oea[1].oeb11, s_oea[1].ima131,   #FUN-D10105 ima131
                       s_oea[1].oeb05, s_oea[1].oeb905,s_oea[1].oeb12, s_oea[1].oeb13, s_oea[1].oeb14,  
                       s_oea[1].oeb14t,s_oea[1].oeb15,s_oea[1].oeb24
              
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
	 
      END CONSTRUCT

       ON ACTION controlp
          CASE
             WHEN INFIELD(oea01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_oea03" 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea01
                  NEXT FIELD oea01
 
       #     WHEN INFIELD(oea03)             
       #          CALL cl_init_qry_var()
       #          LET g_qryparam.state = "c"
       #          LET g_qryparam.form ="q_oea03_1" 
       #          CALL cl_create_qry() RETURNING g_qryparam.multiret
       #          DISPLAY g_qryparam.multiret TO oea03            
       #          NEXT FIELD oea03      
           
             WHEN INFIELD(oea03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  IF g_aza.aza50='Y' THEN
                     LET g_qryparam.form ="q_occ3"
                  ELSE
                     LET g_qryparam.form ="q_occ"
                  END IF
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea03
                  NEXT FIELD oea03      
 
      #     WHEN INFIELD(oea04)
      #          CALL cl_init_qry_var()
      #          LET g_qryparam.state = "c"
      #          LET g_qryparam.form ="q_oea04_1"
      #          CALL cl_create_qry() RETURNING g_qryparam.multiret
      #          DISPLAY g_qryparam.multiret TO oea04
      #          NEXT FIELD oea04            
            WHEN INFIELD(oea04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 IF g_aza.aza50='Y' THEN
                    LET g_qryparam.form ="q_occ4"
                 ELSE
                    LET g_qryparam.form ="q_occ" 
                 END IF
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea04
                 NEXT FIELD oea04 

            WHEN INFIELD(oea14)
                 CALL cl_init_qry_var() 
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gen"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea14
                 NEXT FIELD oea14

            WHEN INFIELD(oea15)
                 CALL cl_init_qry_var() 
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gem"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea15
                 NEXT FIELD oea15

            WHEN INFIELD(oea21)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 IF g_aza.aza26 = '2' THEN      
                    LET g_qryparam.form ="q_gec9"
                 ELSE                           
                    LET g_qryparam.form ="q_gec"
                 END IF                        
                 LET g_qryparam.arg1 = '2'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea21
                 NEXT FIELD oea21

            WHEN INFIELD(oea23)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azi"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea23
                 NEXT FIELD oea23

            WHEN INFIELD(oea10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_oea10_1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea10
                 NEXT FIELD oea10
          
            WHEN INFIELD(oeb04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_oeb04_1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oeb04
                 NEXT FIELD oeb04
            WHEN INFIELD(oeb05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oeb05
                 NEXT FIELD oeb05
           #FUN-D10105---add---str---
            WHEN INFIELD(occ03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_occ03_1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occ03
                 NEXT FIELD occ03
            WHEN INFIELD(ima131)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_ima131_1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima131
                 NEXT FIELD ima131
           #FUN-D10105---add---end---
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
      IF INT_FLAG THEN 
         LET INT_FLAG = 0
         LET g_int_flag = '1'
         DELETE FROM axmq001_tmp
#        CALL  cl_used(g_prog,g_time,2) RETURNING g_time
         RETURN 
#        EXIT PROGRAM
      END IF

      CALL q001()
         
END FUNCTION 

FUNCTION q001_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q001_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "SERCHING!"

    MESSAGE ""
    CALL q001_show()
END FUNCTION


FUNCTION q001_show()
   DISPLAY tm.a TO a
   CALL q001_b_fill()  
   CALL q001_b_fill_2()
   IF cl_null(tm.a)  THEN   
      LET g_action_choice = "page1" 
      CALL cl_set_comp_visible("page2", FALSE)
      CALL cl_set_comp_visible("page3", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page2", TRUE)
      CALL cl_set_comp_visible("page3", TRUE)
      LET g_action_flag = "page1"
   ELSE
      IF g_int_flag = '0' THEN
         LET g_action_choice = "page2"
         CALL cl_set_comp_visible("page1", FALSE)
         CALL cl_set_comp_visible("page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page1", TRUE)
         CALL cl_set_comp_visible("page3", TRUE)
         LET g_action_flag = "page2"
      ELSE
         LET g_action_choice = "page1"
         CALL cl_set_comp_visible("page2", FALSE)
         CALL cl_set_comp_visible("page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2", TRUE) 
         CALL cl_set_comp_visible("page3", TRUE) 
         LET g_action_flag = "page1"
      END IF
   END IF

   CALL q001_set_visible()
   CALL cl_show_fld_cont()                   
END FUNCTION

FUNCTION q001_filter_askkey()
DEFINE l_wc   STRING
   CLEAR FORM
   CONSTRUCT l_wc ON oea00,oea01,oea08,oea03,oea032,oea04,occ02,occ03,oea02,oea14,gen02,oea15,   #FUN-D10105 occ03
                       gem02,oea23,oea21,oea211,oea213, oea10,oeaconf,oea72,oea49,oeb03,oeb04,oeb06,
                       ima021,oeb11,ima131,oeb05,img10,oeb905,oeb12,oeb13,oeb14,oeb14t,oeb15,    #FUN-D10105 ima131
                       oeb24 
                  FROM s_oea[1].oea00, s_oea[1].oea01,s_oea[1].oea08,  s_oea[1].oea03, s_oea[1].oea032,
                       s_oea[1].oea04, s_oea[1].occ02,s_oea[1].occ03,  s_oea[1].oea02, s_oea[1].oea14, s_oea[1].gen02,   #FUN-D10105 occ03
                       s_oea[1].oea15, s_oea[1].gem02,s_oea[1].oea23,  s_oea[1].oea21, s_oea[1].oea211,
                       s_oea[1].oea213,s_oea[1].oea10,s_oea[1].oeaconf,s_oea[1].oea72, s_oea[1].oea49, s_oea[1].oeb03,
                       s_oea[1].oeb04, s_oea[1].oeb06,s_oea[1].ima021, s_oea[1].oeb11, s_oea[1].ima131,s_oea[1].oeb05,s_oea[1].img10,  #FUN-D10105 ima131
                       s_oea[1].oeb905,s_oea[1].oeb12,s_oea[1].oeb13, s_oea[1].oeb14,
                       s_oea[1].oeb14t,s_oea[1].oeb15,s_oea[1].oeb24
              
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

    
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
         
      ON ACTION controlp
          CASE
             WHEN INFIELD(oea01)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_oea03" 
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oea01
                NEXT FIELD oea01
 
       #     WHEN INFIELD(oea03)             
       #        CALL cl_init_qry_var()
       #        LET g_qryparam.state = "c"
       #        LET g_qryparam.form ="q_oea03_1" 
       #        CALL cl_create_qry() RETURNING g_qryparam.multiret
       #        DISPLAY g_qryparam.multiret TO oea03            
       #        NEXT FIELD oea03      
           
             WHEN INFIELD(oea03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  IF g_aza.aza50='Y' THEN
                     LET g_qryparam.form ="q_occ3"
                  ELSE
                     LET g_qryparam.form ="q_occ"
                  END IF
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea03
                  NEXT FIELD oea03      
 
       #     WHEN INFIELD(oea04)
       #        CALL cl_init_qry_var()
       #        LET g_qryparam.state = "c"
       #        LET g_qryparam.form ="q_oea04_1"
       #        CALL cl_create_qry() RETURNING g_qryparam.multiret
       #        DISPLAY g_qryparam.multiret TO oea04
       #        NEXT FIELD oea04            
             WHEN INFIELD(oea04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  IF g_aza.aza50='Y' THEN
                     LET g_qryparam.form ="q_occ4"
                  ELSE
                     LET g_qryparam.form ="q_occ" 
                  END IF
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea04
                  NEXT FIELD oea04 

             WHEN INFIELD(oea14)
                CALL cl_init_qry_var() 
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_gen"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oea14
                NEXT FIELD oea14

             WHEN INFIELD(oea15)
                CALL cl_init_qry_var() 
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_gem"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oea15
                NEXT FIELD oea15

             WHEN INFIELD(oea21)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 IF g_aza.aza26 = '2' THEN      
                    LET g_qryparam.form ="q_gec9"
                 ELSE                           
                    LET g_qryparam.form ="q_gec"
                 END IF                        
                 LET g_qryparam.arg1 = '2'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea21
                 NEXT FIELD oea21

             WHEN INFIELD(oea23)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_azi"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea23
                  NEXT FIELD oea23

             WHEN INFIELD(oea10)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_oea10_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea10
                  NEXT FIELD oea10
          
             WHEN INFIELD(oeb04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_oeb04_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb04
                  NEXT FIELD oeb04
             WHEN INFIELD(oeb05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gfe"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb05
                  NEXT FIELD oeb05
            #FUN-D10105---add---str---
             WHEN INFIELD(occ03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_occ03_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ03
                  NEXT FIELD occ03
             WHEN INFIELD(ima131)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_ima131_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima131
                  NEXT FIELD ima131
            #FUN-D10105---add---end---
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

FUNCTION q001_table()
   DROP TABLE axmq001_tmp;
   CREATE TEMP TABLE axmq001_tmp(
                h_b       LIKE type_file.chr1,
                oea00     LIKE oea_file.oea00,
                oea01     LIKE oea_file.oea01,
                oea08     LIKE oea_file.oea08,
                oea901    LIKE oea_file.oea901,  #FUN-D50044 add
                oea03     LIKE oea_file.oea03,
                oea032    LIKE oea_file.oea032,
                oea04     LIKE oea_file.oea04,
                occ02     LIKE occ_file.occ02,
                oea02     LIKE oea_file.oea02,
                oea14     LIKE oea_file.oea14,
                gen02     LIKE gen_file.gen02,
                oea15     LIKE oea_file.oea15,
                gem02     LIKE gem_file.gem02,
                oea23     LIKE oea_file.oea23,
                oea21     LIKE oea_file.oea21,
                oea211    LIKE oea_file.oea211,
                oea213    LIKE oea_file.oea213,
                oea10     LIKE oea_file.oea10,
                oeaconf   LIKE oea_file.oeaconf,
                oea72     LIKE oea_file.oea72,
                oea49     LIKE oea_file.oea49,
                oeb03     LIKE oeb_file.oeb03,
                oeb04     LIKE oeb_file.oeb04,
                oeb06     LIKE oeb_file.oeb06,
                ima021    LIKE ima_file.ima021,
                oeb11     LIKE oeb_file.oeb11,
                oeb05     LIKE oeb_file.oeb05,
                img10     LIKE img_file.img10,
                oeb905    LIKE oeb_file.oeb905,
                oeb12     LIKE oeb_file.oeb12,
                oeb13     LIKE oeb_file.oeb13,
                oeb14     LIKE oeb_file.oeb14,
                oeb14t    LIKE oeb_file.oeb14t,
                oeb15     LIKE oeb_file.oeb15,
                ogb12     LIKE ogb_file.ogb12,
                oeb24     LIKE oeb_file.oeb24,
                ogb13     LIKE ogb_file.ogb13,
                ogb14t    LIKE ogb_file.ogb14t,
                ohb12     LIKE ohb_file.ohb12,
                ohb13     LIKE ohb_file.ohb13,
                ohb14t    LIKE ohb_file.ohb14t,
                ogb16     LIKE ogb_file.ogb16,
                ogb18     LIKE ogb_file.ogb18,
                omb12     LIKE omb_file.omb12,
                omb14t    LIKE omb_file.omb14t, 
                oea65     LIKE oea_file.oea65,
                sfb_count LIKE type_file.chr1,
                sfb09     LIKE sfb_file.sfb09,
                oebud01   LIKE oeb_file.oebud01,  #darcy:2023/02/22
                occ03     LIKE occ_file.occ03,    #FUN-D10105 add
                oca02     LIKE oca_file.oca02,    #FUN-D10105 add
                ima131    LIKE ima_file.ima131,   #FUN-D10105 add
                oba02     LIKE oba_file.oba02);   #FUN-D10105 add
END FUNCTION 

FUNCTION q001()
 DEFINE l_name      LIKE type_file.chr20,           
          l_sql       STRING,                
          l_chr       LIKE type_file.chr1,         
          l_order     ARRAY[5] OF LIKE abb_file.abb11,   #排列順序    
          l_i         LIKE type_file.num5,                    
          l_cnt       LIKE type_file.num5      #FUN-C80102              
   DEFINE sr,sr_t  sr1_t
   DEFINE l_wc,l_msg   STRING 
   DEFINE l_sic06a,l_sic06b  LIKE sic_file.sic06
   DEFINE l_order1  LIKE type_file.chr100
   DEFINE l_num    LIKE type_file.num5
   DEFINE l_ogb12   LIKE ogb_file.ogb12
   DEFINE l_ogb12a  LIKE ogb_file.ogb12
   DEFINE l_oga02   LIKE oga_file.oga02
   

   DISPLAY TIME   #add by zhangym 121122                       
   LET tm.wc2 = tm.wc2 CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
   CALL q001_table()
   DELETE FROM axmq001_tmp
#mark by zhangym 121122 begin-----
#   LET g_sql = "INSERT INTO axmq001_tmp",
#               " VALUES(?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,",
#               "        ?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,?)"
#   PREPARE insert_prep FROM g_sql
#   IF STATUS THEN                                                                                                                   
#      CALL cl_err('insert_prep:',status,1)
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time        
#      EXIT PROGRAM                                                                                                                 
#   END IF
#mark by zhangym 121122 end-----

   IF cl_null(g_filter_wc) THEN LET g_filter_wc=" 1=1" END IF
#mod by zhangym 121122 begin------    
#   LET l_sql ="SELECT '',oea00,oea01,oea08,oea03,oea032,oea04,'',oea02,oea14,'',oea15,",
#                      "'',oea23,oea21,oea211,oea213,oea10,oeaconf,oea72,oea49,oeb03,oeb04,oeb06,'',",
#                      "oeb11,oeb05,'','',oeb12,oeb13,oeb14t,(oeb14t*oea24),oeb15,'','','','','','','','','','','',oea65,'',''",
#                      " FROM oea_file,oeb_file",
#                      " WHERE oea01=oeb01  AND ",tm.wc2 CLIPPED," AND ",g_filter_wc CLIPPED,
#                      " AND ("
   LET l_sql ="SELECT '2' h_b,nvl(trim(oea00),'') oea00,oea01,nvl(trim(oea08),'') oea08,oea901,nvl(trim(oea03),'') oea03,nvl(trim(oea032),'') oea032,nvl(trim(oea04),'') oea04,",  #FUN-D50044 oea901
                      "nvl(trim(occ02),'') occ02,oea02,nvl(trim(oea14),'') oea14,nvl(trim(gen02),'') gen02,nvl(trim(oea15),'') oea15,",
                      " nvl(trim(gem02),'') gem02,nvl(trim(oea23),'') oea23,oea21,oea211,oea213,nvl(trim(oea10),'') oea10,oeaconf,oea72,oea49,oeb03,nvl(trim(oeb04),'') oeb04,",
                      "nvl(trim(oeb06),'') oeb06,nvl(trim(ima021),'') ima021,",
                      "oeb11,oeb05,0 img10,0 oeb905,oeb12,oeb13,oeb14t,(oeb14t*oea24),oeb15,0 ogb12,0 oeb24,0 ogb13,0 ogb14t,0 ohb12,",
                      " 0 ohb13,0 ohb14t,0 ogb16,0 ogb18,0 omb12,0 omb14t,oea65,'N' sfb_count,0 sfb09,oebud01",
                      ",nvl(trim(occ03),'') occ03,nvl(trim(oca02),'') oca02,nvl(trim(ima131),'') ima131,nvl(trim(oba02),'') oba02",                                                        #FUN-D10105 add
                      " FROM oea_file LEFT JOIN occ_file ON occ01 = oea04 ",
                                    " LEFT JOIN oca_file ON oca01 = occ03 ",      #FUN-D10105 add
                                    " LEFT JOIN gen_file ON gen01 = oea14 ",
                                    " LEFT JOIN gem_file ON gem01 = oea15 ",
                      "   ,  oeb_file LEFT JOIN ima_file ON ima01 = oeb04 ",
                                    " LEFT JOIN oba_file ON ima131= oba01 ",      #FUN-D10105 add
                      " WHERE oea01=oeb01  AND ",tm.wc2 CLIPPED," AND ",g_filter_wc CLIPPED,
                      "   AND (oea01 NOT LIKE 'FPC%' OR oeaud02<>'Y')",  #add by guanyaoo160810
                      " AND ("
#mod by zhangym 121122 end-----                                            
   CALL q001_tmp_wc() RETURNING l_wc
   IF NOT cl_null(l_wc) THEN
      LET l_sql = l_sql,l_wc,")"
   ELSE
      LET l_sql = l_sql," 1=2 )"
   END IF

#mark by zhangym 121122 begin----- 
#   PREPARE q001_prepare FROM l_sql
#   DECLARE q001_curs CURSOR FOR q001_prepare
#               
#   DECLARE q001_cs                         #SCROLL CURSOR
#           SCROLL CURSOR FOR q001_prepare
#   OPEN q001_cs
#   FETCH FIRST q001_cs INTO sr.*
#   IF SQLCA.SQLCODE THEN 
#      LET g_int_flag = '1'
#      CALL cl_err('',SQLCA.sqlcode,0)
#   END IF   
#   INITIALIZE sr.* TO NULL
#  
#
#   FOREACH q001_curs INTO sr.*
#      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#
#      SELECT occ02 INTO sr.occ02 FROM occ_file WHERE occ01 = sr.oea04
#
#      SELECT gen02 INTO sr.gen02 FROM gen_file WHERE gen01 = sr.oea14
#
#      SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01 = sr.oea15
#
#      SELECT ima021 INTO sr.ima021 FROM ima_file WHERE ima01 = sr.oeb04
#      #可用倉庫存數量
#      SELECT SUM(img10*img21) INTO sr.img10 FROM img_file 
#         WHERE img01=sr.oeb04 AND img23='Y'
#      IF cl_null(sr.img10) THEN LET sr.img10 = 0 END IF 
#      #从axmi611抓该订单号+项次的已备置量-退备置量
#      SELECT SUM(sic06) INTO l_sic06a FROM sia_file,sic_file
#         WHERE sia01 = sic01 AND sia04='1' AND sic03=sr.oea01
#            AND sic15=sr.oeb03
#      IF cl_null(l_sic06a) THEN LET l_sic06a = 0 END IF 
#      SELECT SUM(sic06) INTO l_sic06b FROM sia_file,sic_file
#         WHERE sia01 = sic01 AND sia04='2' AND sic03=sr.oea01
#            AND sic15=sr.oeb03
#      IF cl_null(l_sic06b) THEN LET l_sic06b = 0 END IF 
#      LET sr.oeb905 = l_sic06a - l_sic06b
#      #已出貨通知數量
#      SELECT SUM(ogb12) INTO sr.ogb12 FROM ogb_file,oga_file 
#         WHERE ogb31=sr.oea01 AND ogb32=sr.oeb03 
#           AND ogb01=oga01 AND ogaconf='Y' AND oga09 IN ('1','5')
#      IF cl_null(sr.ogb12) THEN LET sr.ogb12 = 0 END IF 
#      
#      #出貨單價
#      SELECT ogb13 INTO sr.ogb13 FROM ogb_file,oga_file
#         WHERE ogb31=sr.oea01 AND ogb32=sr.oeb03   
#           AND ogb01=oga01 AND ogapost='Y' AND oga09 IN ('2','3','4','6','A') 
#      IF cl_null(sr.ogb13) THEN LET sr.ogb13 = 0 END IF
#      
#      #出貨金額
#      SELECT SUM(ogb14t),SUM(ogb12) INTO sr.ogb14t,l_ogb12 FROM ogb_file,oga_file
#         WHERE ogb31=sr.oea01 AND ogb32=sr.oeb03   
#           AND ogb01=oga01 AND ogapost='Y' AND oga09 IN ('2','3','4','6','A') 
#      IF cl_null(sr.ogb14t) THEN LET sr.ogb14t = 0 END IF
#      IF cl_null(l_ogb12) THEN LET l_ogb12 = 0 END IF
#
#      #已出貨數量
#      SELECT SUM(ogb12) INTO sr.oeb24 FROM ogb_file,oga_file
#         WHERE ogb31=sr.oea01 AND ogb32=sr.oeb03
#           AND ogb01=oga01 AND ogapost='Y' AND oga09 IN ('2','4','6')
#      IF cl_null(sr.oeb24) THEN LET sr.oeb24 = 0 END IF
#
#      #銷退數量
#      SELECT SUM(ohb12) INTO sr.ohb12 FROM ohb_file,oha_file
#         WHERE ohb33=sr.oea01 AND ohb34=sr.oeb03
#           AND ohb01=oha01 AND ohapost='Y'
#      IF cl_null(sr.ohb12) THEN LET sr.ohb12 = 0 END IF 
#      
#      #銷退單價
#      SELECT ohb13 INTO sr.ohb13 FROM ohb_file,oha_file
#         WHERE ohb33=sr.oea01 AND ohb34=sr.oeb03
#           AND ohb01=oha01 AND ohapost='Y'
#      IF cl_null(sr.ohb13) THEN LET sr.ohb13 = 0 END IF
#      
#      #銷退金額
#      SELECT SUM(ohb14t) INTO sr.ohb14t FROM ohb_file,oha_file
#         WHERE ohb33=sr.oea01 AND ohb34=sr.oeb03
#           AND ohb01=oha01 AND ohapost='Y'
#      IF cl_null(sr.ohb14t) THEN LET sr.ohb14t = 0 END IF
#      
#      #已簽收數量
#      SELECT SUM(ogb12) INTO sr.ogb16 FROM ogb_file,oga_file
#         WHERE ogb31=sr.oea01 AND ogb32=sr.oeb03
#           AND ogb01=oga01 AND ogapost='Y' AND oga09='8'
#      IF cl_null(sr.ogb16) THEN LET sr.ogb16=0 END IF 
#
#      #已簽退數量
#      SELECT SUM(ogb12) INTO sr.ogb18 FROM ogb_file,oga_file
#         WHERE ogb31=sr.oea01 AND ogb32=sr.oeb03
#           AND ogb01=oga01 AND ogapost='Y' AND oga09='9'
#      IF cl_null(sr.ogb18) THEN LET sr.ogb18=0 END IF
##     LET l_ogb12a = 0
##     LET l_ogb12a = sr.ogb16 - sr.ogb18
#      #立賬數量
#      SELECT SUM(omb12) INTO sr.omb12 FROM omb_file,oma_file
#         WHERE omb31=sr.oea01 AND omb32=sr.oeb03
#           AND omb01=oma01 AND omaconf='Y' 
#      IF cl_null(sr.omb12) THEN LET sr.omb12=0 END IF
#
#      #立賬金額
#      SELECT SUM(omb14t) INTO sr.omb14t FROM omb_file,oma_file
#         WHERE omb31=sr.oea01 AND omb32=sr.oeb03
#           AND omb01=oma01 AND omaconf='Y' 
#      IF cl_null(sr.omb14t) THEN LET sr.omb14t=0 END IF
#
#      #工单完工入库数量
#      SELECT SUM(sfb09) INTO sr.sfb09 FROM sfb_file
#         WHERE sfb22=sr.oea01 AND sfb221=sr.oeb03
#           AND sfb05=sr.oeb04
#      IF cl_null(sr.sfb09) THEN LET sr.sfb09=0 END IF
#
#      #是否已开立工单
#      LET l_cnt = 0 
#      SELECT COUNT(*) INTO l_cnt FROM sfb_file
#         WHERE sfb22=sr.oea01 AND sfb221=sr.oeb03
#           AND sfb05=sr.oeb04
#      IF l_cnt >=1 THEN
#         LET sr.sfb_count = 'Y'
#      ELSE
#         LET sr.sfb_count = 'N'
#      END IF 
#
##     LET sr.h_b = '3'
##     IF l_ogb12 >= sr.oeb12 AND sr.oeb15 < l_oga02 THEN
##        LET sr.h_b = '1'
##     END IF 
##     IF sr.oeb15 < g_today AND l_ogb12 < sr.oeb12 THEN 
##        LET sr.h_b = '2'  
##     END IF
#      IF l_ogb12 >= sr.oeb12 THEN         #已完成(出货量>=订单量)
#         IF sr.oeb12 = 0 THEN
#            LET sr.h_b = '1'
#         ELSE
#            DECLARE oga02_curs SCROLL CURSOR FOR 
#               SELECT oga02 FROM oga_file,ogb_file
#                WHERE oga01 = ogb01 AND ogb31 = sr.oea01
#                  AND ogb32 = sr.oeb03 AND ogapost = 'Y'
#            OPEN oga02_curs
#            FETCH LAST oga02_curs INTO l_oga02
#            IF sr.oeb15 < l_oga02 THEN
#               LET sr.h_b = '2'
#            ELSE
#               LET sr.h_b = '1'
#            END IF
#         END IF
#      END IF
#
#      IF l_ogb12 < sr.oeb12 THEN       #非已完成(出货量<订单量)
#         IF sr.oeb15 < g_today THEN 
#            LET sr.h_b = '2' 
#         ELSE
#            LET sr.h_b = '1'
#         END IF
#      END IF
#      IF tm.h != sr.h_b AND tm.h != '3' THEN 
#         CONTINUE FOREACH 
#      END IF
#
#      EXECUTE insert_prep USING sr.*
#      
#   END FOREACH 
#mark by zhangym 121122 end----- 

#add by zhangym 121122 begin------
   LET l_sql = " INSERT INTO axmq001_tmp ",
               "   SELECT x.* ",
               "     FROM (",l_sql CLIPPED,") x "
   PREPARE q001_ins FROM l_sql
   EXECUTE q001_ins  

   LET l_sql = " MERGE INTO axmq001_tmp o ",
               "      USING (SELECT img01,SUM(img10*img21) img10_sum ", 
               "               FROM img_file ",
               "              WHERE img23 = 'Y' ",
               "              GROUP BY img01) n ",
               "         ON (o.oeb04 = n.img01) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.img10 = NVL(n.img10_sum,0) "
   PREPARE q001_pre1 FROM l_sql
   EXECUTE q001_pre1

   LET l_sql = " MERGE INTO axmq001_tmp o ",
#               "      USING (SELECT sic03,sic15,SUM(DECODE(sia04,'1',1,-1)*sic06) sic06_sum ",      #xj sql mod
               "      USING (SELECT sic03,sic15,",
               "                    SUM((CASE WHEN sia04='1' THEN 1 ELSE -1 END)*sic06) sic06_sum ",
               "               FROM sia_file,sic_file ",
               "              WHERE sia01 = sic01 ",
               "              GROUP BY sic03,sic15) n ",
               "         ON (o.oea01 = n.sic03 AND o.oeb03 = n.sic15) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.oeb905 = NVL(n.sic06_sum,0) "
   PREPARE q001_pre5 FROM l_sql
   EXECUTE q001_pre5
   
#   LET l_sql = " MERGE INTO axmq001_tmp o ",            
#               "      USING (SELECT sic03,sic15,SUM(sic06) sic06_sum ",
#               "               FROM sia_file,sic_file ",
#               "              WHERE sia01 = sic01 ",
#               "                AND sia04 = '2' ",
#               "              GROUP BY sic03,sic15) n ",
#               "         ON (o.oea01 = n.sic03 AND o.oeb03 = n.sic15) ",
#               " WHEN MATCHED ",
#               " THEN ",
#               "    UPDATE ",
#               "       SET o.oeb905 = o.oeb905 - NVL(n.sic06_sum,0) "
#   PREPARE q001_pre51 FROM l_sql
#   EXECUTE q001_pre51
   
   LET l_sql = " MERGE INTO axmq001_tmp o ",
               "      USING (SELECT ogb31,ogb32,SUM(ogb12) ogb12_sum ", 
               "               FROM oga_file,ogb_file ",
               "              WHERE oga01 = ogb01 ",
               "                AND ogaconf = 'Y' AND oga09 IN ('1','5') ",
               "              GROUP BY ogb31,ogb32) n ",
               "         ON (o.oea01 = n.ogb31 AND o.oeb03 = n.ogb32) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.ogb12 = NVL(n.ogb12_sum,0) "
   PREPARE q001_pre4 FROM l_sql
   EXECUTE q001_pre4     

   LET l_sql = "UPDATE axmq001_tmp o SET o.ogb13 = (SELECT nvl(b.ogb13,0) FROM oga_file a,ogb_file b  ",
               " WHERE a.oga01 = b.ogb01 AND a.ogapost = 'Y' AND a.oga09 IN ('2','3','4','6','A') ",
               "   AND o.oea01 = b.ogb31 AND o.oeb03 = b.ogb32) "                 
   PREPARE q001_pre41 FROM l_sql
   EXECUTE q001_pre41
   
   LET l_sql = " MERGE INTO axmq001_tmp o ",
               "      USING (SELECT ogb31,ogb32,SUM(ogb14t) ogb14t_sum ", 
               "               FROM oga_file,ogb_file ",
               "              WHERE oga01 = ogb01 ",
               "                AND ogapost = 'Y' AND oga09 IN ('2','3','4','6','A') ",
               "              GROUP BY ogb31,ogb32) n ",
               "         ON (o.oea01 = n.ogb31 AND o.oeb03 = n.ogb32) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.ogb14t = NVL(n.ogb14t_sum,0) "
   PREPARE q001_pre42 FROM l_sql
   EXECUTE q001_pre42  
   
   LET l_sql = " MERGE INTO axmq001_tmp o ",
               "      USING (SELECT ogb31,ogb32,SUM(ogb12) ogb12_sum ", 
               "               FROM oga_file,ogb_file ",
               "              WHERE oga01 = ogb01 ",
               "                AND ogapost = 'Y' AND oga09 IN ('2','4','6') ",
               "              GROUP BY ogb31,ogb32) n ",
               "         ON (o.oea01 = n.ogb31 AND o.oeb03 = n.ogb32) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.oeb24 = NVL(n.ogb12_sum,0) "
   PREPARE q001_pre43 FROM l_sql
   EXECUTE q001_pre43 
   
   LET l_sql = " MERGE INTO axmq001_tmp o ",
               "      USING (SELECT ohb33,ohb34,SUM(ohb12) ohb12_sum ", 
               "               FROM oha_file,ohb_file ",
               "              WHERE oha01 = ohb01 ",
               "                AND ohapost = 'Y' ",
               "              GROUP BY ohb33,ohb34) n ",
               "         ON (o.oea01 = n.ohb33 AND o.oeb03 = n.ohb34) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.ohb12 = NVL(n.ohb12_sum,0) "
   PREPARE q001_pre44 FROM l_sql
   EXECUTE q001_pre44    

   LET l_sql = "UPDATE axmq001_tmp o SET o.ohb13 = (SELECT nvl(ohb13,0) FROM oha_file,ohb_file   ",
               " WHERE oha01 = ohb01 AND ohapost = 'Y' ",
               "   AND o.oea01 = ohb33 AND o.oeb03 = ohb34) "     
   PREPARE q001_pre45 FROM l_sql
   EXECUTE q001_pre45
   
   LET l_sql = " MERGE INTO axmq001_tmp o ",
               "      USING (SELECT ohb33,ohb34,SUM(ohb14t) ohb14t_sum ", 
               "               FROM oha_file,ohb_file ",
               "              WHERE oha01 = ohb01 ",
               "                AND ohapost = 'Y' ",
               "              GROUP BY ohb33,ohb34) n ",
               "         ON (o.oea01 = n.ohb33 AND o.oeb03 = n.ohb34) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.ohb14t = NVL(n.ohb14t_sum,0) "
   PREPARE q001_pre46 FROM l_sql
   EXECUTE q001_pre46 
   
   LET l_sql = " MERGE INTO axmq001_tmp o ",
               "      USING (SELECT ogb31,ogb32,SUM(ogb12) ogb16 ", 
               "               FROM oga_file,ogb_file ",
               "              WHERE oga01 = ogb01 ",
               "                AND ogapost = 'Y' AND oga09 ='8' ",
               "              GROUP BY ogb31,ogb32) n ",
               "         ON (o.oea01 = n.ogb31 AND o.oeb03 = n.ogb32) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.ogb16 = NVL(n.ogb16,0) "
   PREPARE q001_pre47 FROM l_sql
   EXECUTE q001_pre47    
   
   LET l_sql = " MERGE INTO axmq001_tmp o ",
               "      USING (SELECT ogb31,ogb32,SUM(ogb12) ogb18 ", 
               "               FROM oga_file,ogb_file ",
               "              WHERE oga01 = ogb01 ",
               "                AND ogapost = 'Y' AND oga09 ='9' ",
               "              GROUP BY ogb31,ogb32) n ",
               "         ON (o.oea01 = n.ogb31 AND o.oeb03 = n.ogb32) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.ogb18 = NVL(n.ogb18,0) "
   PREPARE q001_pre48 FROM l_sql
   EXECUTE q001_pre48                              
   
   LET l_sql = " MERGE INTO axmq001_tmp o ",
               "      USING (SELECT omb31,omb32,SUM(omb12) omb12_sum ",
               "               FROM oma_file,omb_file ",
               "              WHERE oma01 = omb01 ",
               "                AND omaconf = 'Y' ",
               "              GROUP BY omb31,omb32) n ",
               "         ON (o.oea01 = n.omb31 AND o.oeb03 = n.omb32) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.omb12 = NVL(n.omb12_sum,0) "
   PREPARE q001_pre6 FROM l_sql
   EXECUTE q001_pre6
   
   LET l_sql = " MERGE INTO axmq001_tmp o ",
               "      USING (SELECT omb31,omb32,SUM(omb14t) omb14t_sum ",
               "               FROM oma_file,omb_file ",
               "              WHERE oma01 = omb01 ",
               "                AND omaconf = 'Y' ",
               "              GROUP BY omb31,omb32) n ",
               "         ON (o.oea01 = n.omb31 AND o.oeb03 = n.omb32) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.omb14t = NVL(n.omb14t_sum,0) "
   PREPARE q001_pre61 FROM l_sql
   EXECUTE q001_pre61  
   
   LET l_sql = " MERGE INTO axmq001_tmp o ",
               "      USING (SELECT sfb22,sfb221,sfb05,SUM(sfb09) sfb09_sum ",
               "               FROM sfb_file ",
               "              GROUP BY sfb22,sfb221,sfb05) n ",
               "         ON (o.oea01 = n.sfb22 AND o.oeb03 = n.sfb221 AND o.oeb04 = n.sfb05) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.sfb09 = NVL(n.sfb09_sum,0) "
   PREPARE q001_pre62 FROM l_sql
   EXECUTE q001_pre62   
   
   LET l_sql = " MERGE INTO axmq001_tmp o ",
               "      USING (SELECT sfb22,sfb221,sfb05,COUNT(*) cnt ",
               "               FROM sfb_file ",
               "              GROUP BY sfb22,sfb221,sfb05) n ",
               "         ON (o.oea01 = n.sfb22 AND o.oeb03 = n.sfb221 AND o.oeb04 = n.sfb05) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.sfb_count = 'Y' ",
               "     WHERE n.cnt >= 1 "
   PREPARE q001_pre63 FROM l_sql
   EXECUTE q001_pre63 
   
   LET l_sql = " MERGE INTO axmq001_tmp o ",
               "      USING (SELECT sfb22,sfb221,sfb05,COUNT(*) cnt ",
               "               FROM sfb_file ",
               "              GROUP BY sfb22,sfb221,sfb05) n ",
               "         ON (o.oea01 = n.sfb22 AND o.oeb03 = n.sfb221 AND o.oeb04 = n.sfb05) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.sfb_count = 'N' ",
               "     WHERE n.cnt < 1 "
   PREPARE q001_pre64 FROM l_sql
   EXECUTE q001_pre64             

   LET l_sql = " MERGE INTO axmq001_tmp o ",
               "      USING (SELECT ogb31,ogb32,SUM(ogb12) ogb12_sum ", 
               "               FROM oga_file,ogb_file ",
               "              WHERE oga01 = ogb01 ",
               "                AND ogapost = 'Y' AND oga09 IN ('2','3','4','6','A') ",
               "              GROUP BY ogb31,ogb32) n ",
               "         ON (o.oea01 = n.ogb31 AND o.oeb03 = n.ogb32) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.h_b = '2' ",
               "     WHERE n.ogb12_sum < o.oeb12 ",
               "       AND o.oeb15 < '",g_today,"' "
   PREPARE q001_pre7 FROM l_sql
   EXECUTE q001_pre7 
   
   LET l_sql = " MERGE INTO axmq001_tmp o ",
               "      USING (SELECT ogb31,ogb32,SUM(ogb12) ogb12_sum ", 
               "               FROM oga_file,ogb_file ",
               "              WHERE oga01 = ogb01 ",
               "                AND ogapost = 'Y' AND oga09 IN ('2','3','4','6','A') ",
               "              GROUP BY ogb31,ogb32) n ",
               "         ON (o.oea01 = n.ogb31 AND o.oeb03 = n.ogb32) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.h_b = '1' ",
               "     WHERE n.ogb12_sum < o.oeb12 ",
               "       AND (o.oeb15 >= '",g_today,"') "
   PREPARE q001_pre71 FROM l_sql
   EXECUTE q001_pre71   
   
   LET l_sql = " MERGE INTO axmq001_tmp o ",
               "      USING (SELECT ogb31,ogb32,SUM(ogb12) ogb12_sum ", 
               "               FROM oga_file,ogb_file ",
               "              WHERE oga01 = ogb01 ",
               "                AND ogapost = 'Y' AND oga09 IN ('2','3','4','6','A') ",
               "              GROUP BY ogb31,ogb32) n ",
               "         ON (o.oea01 = n.ogb31 AND o.oeb03 = n.ogb32) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.h_b = '1' ",
               "     WHERE n.ogb12_sum >= o.oeb12 ",
               "       AND o.oeb12 = 0 "
   PREPARE q001_pre72 FROM l_sql
   EXECUTE q001_pre72    
   
   LET l_sql = " MERGE INTO axmq001_tmp o ",
               "      USING (SELECT ogb31,ogb32,SUM(ogb12) ogb12_sum ", 
               "               FROM oga_file,ogb_file ",
               "              WHERE oga01 = ogb01 ",
               "                AND ogapost = 'Y' AND oga09 IN ('2','3','4','6','A') ",
               "              GROUP BY ogb31,ogb32) n ",
               "         ON (o.oea01 = n.ogb31 AND o.oeb03 = n.ogb32) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.h_b = '2' ",
               "     WHERE n.ogb12_sum >= o.oeb12 ",
               "       AND o.oeb12 <> 0 ",
               "       AND o.oeb15 < (SELECT MAX(oga02) FROM oga_file,ogb_file WHERE oga01 = ogb01 AND ogb31 = o.oea01 AND ogb32 = o.oeb03 AND ogapost = 'Y') "
   PREPARE q001_pre731 FROM l_sql
   EXECUTE q001_pre731   
   
   LET l_sql = " MERGE INTO axmq001_tmp o ",
               "      USING (SELECT ogb31,ogb32,SUM(ogb12) ogb12_sum ", 
               "               FROM oga_file,ogb_file ",
               "              WHERE oga01 = ogb01 ",
               "                AND ogapost = 'Y' AND oga09 IN ('2','3','4','6','A') ",
               "              GROUP BY ogb31,ogb32) n ",
               "         ON (o.oea01 = n.ogb31 AND o.oeb03 = n.ogb32) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.h_b = '1' ",
               "     WHERE n.ogb12_sum >= o.oeb12 ",
               "       AND o.oeb12 <> 0 ",
               "       AND (o.oeb15 >= (SELECT MAX(oga02) FROM oga_file,ogb_file WHERE oga01 = ogb01 AND ogb31 = o.oea01 AND ogb32 = o.oeb03 AND ogapost = 'Y')) "
   PREPARE q001_pre73 FROM l_sql
   EXECUTE q001_pre73            

   IF tm.h != '3' THEN 
      LET l_sql = " DELETE FROM axmq001_tmp o ",
                  "  WHERE o.h_b != '",tm.h,"' "
      PREPARE q001_pre8 FROM l_sql
      EXECUTE q001_pre8                      
   END IF 
#add by zhangym 121122 end-----

   DISPLAY TIME   #add by zhangym 121122   
   
END FUNCTION 

FUNCTION q001_get_sum()
DEFINE     l_wc     STRING
DEFINE     l_sql    STRING

   CALL q001_tmp_wc2() RETURNING l_wc
   IF NOT cl_null(l_wc) THEN
      LET l_wc = l_wc,") OR oea65 = 'N' "
   ELSE
      LET l_wc = l_wc," oea65 = 'N') "
   END IF
   CASE tm.a
      WHEN '1'
         LET l_sql = "SELECT oea00,'','','','','','','','',",
                     "'','','','','','','','','','','',oea23,'',",    #FUN-D10105 '','','',''
                     "'','','','','','','',",             
                     "SUM(img10),SUM(oeb905),SUM(oeb12),'',SUM(oeb14),", #TQC-D60042 unmark
                     #"img10,SUM(oeb905),SUM(oeb12),'',SUM(oeb14),", #MOD-D10190 #TQC-D60042 mark
                     "SUM(oeb14t),'',SUM(ogb12),SUM(oeb24),'',SUM(ogb14t),SUM(ohb12),'',SUM(ohb14t),",
                     "SUM(ogb16),SUM(ogb18),SUM(omb12),SUM(omb14t),SUM(sfb09) FROM axmq001_tmp WHERE ((",l_wc,")",
                     #" GROUP BY oea00,oea23,img10 ", #MOD-D10190 add img10 #TQC-D60042 mark
                     " GROUP BY oea00,oea23 ", #TQC-D60042
                     " ORDER BY oea00,oea23 "
      WHEN '2'
         LET l_sql = "SELECT '',oea08,'','','','','','','',",
                     "'','','','','','','','','','','',oea23,'',",    #FUN-D10105 '','','',''
                     "'','','','','','','',",           
                     "SUM(img10),SUM(oeb905),SUM(oeb12),'',SUM(oeb14),",  #TQC-D60042 unmark 
                     #"img10,SUM(oeb905),SUM(oeb12),'',SUM(oeb14),", #MOD-D10190 #TQC-D60042 mark
                     "SUM(oeb14t),'',SUM(ogb12),SUM(oeb24),'',SUM(ogb14t),SUM(ohb12),'',SUM(ohb14t),",
                     "SUM(ogb16),SUM(ogb18),SUM(omb12),SUM(omb14t),SUM(sfb09) FROM axmq001_tmp WHERE ((",l_wc,")",
                     #" GROUP BY oea08,oea23,img10 ", #MOD-D10190 add img10 #TQC-D60042 mark
                     " GROUP BY oea08,oea23 ", #TQC-D60042
                     " ORDER BY oea08,oea23 "
      WHEN '3'
         LET l_sql = "SELECT '','',oea02,'','','','','','',",
                     "'','','','','','','','','','','',oea23,'',",    #FUN-D10105 '','','',''
                     "'','','','','','','',",            
                     "SUM(img10),SUM(oeb905),SUM(oeb12),'',SUM(oeb14),", #TQC-D60042 unmark 
                     #"img10,SUM(oeb905),SUM(oeb12),'',SUM(oeb14),", #MOD-D10190 #TQC-D60042 mark
                     "SUM(oeb14t),'',SUM(ogb12),SUM(oeb24),'',SUM(ogb14t),SUM(ohb12),'',SUM(ohb14t),",
                     "SUM(ogb16),SUM(ogb18),SUM(omb12),SUM(omb14t),SUM(sfb09) FROM axmq001_tmp WHERE ((",l_wc,")",
                     #" GROUP BY oea02,oea23,img10 ", #MOD-D10190 add img10 #TQC-D60042 mark
                     " GROUP BY oea02,oea23 ", #TQC-D60042
                     " ORDER BY oea02,oea23 "
      WHEN '4'
         LET l_sql = "SELECT '','','',oea03,oea032,'','','','',",
                     "'','','','','','','','','','','',oea23,'',",    #FUN-D10105 '','','',''
                     "'','','','','','','',",             
                     "SUM(img10),SUM(oeb905),SUM(oeb12),'',SUM(oeb14),", #TQC-D60042 unmark 
                     #"img10,SUM(oeb905),SUM(oeb12),'',SUM(oeb14),", #MOD-D10190 #TQC-D60042 mark
                     "SUM(oeb14t),'',SUM(ogb12),SUM(oeb24),'',SUM(ogb14t),SUM(ohb12),'',SUM(ohb14t),",
                     "SUM(ogb16),SUM(ogb18),SUM(omb12),SUM(omb14t),SUM(sfb09) FROM axmq001_tmp WHERE ((",l_wc,")",
                     #" GROUP BY oea03,oea032,oea23,img10  ", #MOD-D10190 add img10 #TQC-D60042 mark
                     " GROUP BY oea03,oea032,oea23 ", #TQC-D60042
                     " ORDER BY oea03,oea032,oea23 "
      WHEN '5'
         LET l_sql = "SELECT '','','','','',oea04,occ02,'','',",
                     "'','','','','','','','','','','',oea23,'',",    #FUN-D10105 '','','',''
                     "'','','','','','','',",            
                     "SUM(img10),SUM(oeb905),SUM(oeb12),'',SUM(oeb14),", #TQC-D60042 unmark 
                     #"img10,SUM(oeb905),SUM(oeb12),'',SUM(oeb14),", #MOD-D10190 #TQC-D60042 mark
                     "SUM(oeb14t),'',SUM(ogb12),SUM(oeb24),'',SUM(ogb14t),SUM(ohb12),'',SUM(ohb14t),",
                     "SUM(ogb16),SUM(ogb18),SUM(omb12),SUM(omb14t),SUM(sfb09) FROM axmq001_tmp WHERE ((",l_wc,")",
                     #" GROUP BY oea04,occ02,oea23,img10  ", #MOD-D10190 add img10 #TQC-D60042 mark
                     " GROUP BY oea04,occ02,oea23 ",  #TQC-D60042
                     " ORDER BY oea04,occ02,oea23 "
      WHEN '6'
         LET l_sql = "SELECT '','','','','','','','','',oea14,gen02,",
                     "'','','','','','','','','',oea23,'',",    #FUN-D10105 '','','',''
                     "'','','','','','','',",          
                     "SUM(img10),SUM(oeb905),SUM(oeb12),'',SUM(oeb14),", #TQC-D60042 unmark
                     #"img10,SUM(oeb905),SUM(oeb12),'',SUM(oeb14),", #MOD-D10190 #TQC-D60042 mark
                     "SUM(oeb14t),'',SUM(ogb12),SUM(oeb24),'',SUM(ogb14t),SUM(ohb12),'',SUM(ohb14t),",
                     "SUM(ogb16),SUM(ogb18),SUM(omb12),SUM(omb14t),SUM(sfb09) FROM axmq001_tmp WHERE ((",l_wc,")",
                     #" GROUP BY oea14,gen02,oea23,img10  ", #MOD-D10190 add img10 #TQC-D60042 mark
                     " GROUP BY oea14,gen02,oea23 ", #TQC-D60042
                     " ORDER BY oea14,gen02,oea23 "
      WHEN '7'
         LET l_sql = "SELECT '','','','','','','','','','','',",
                     "oea15,gem02,'','','','','','','',oea23,'',",#FUN-D10105 '','','',''
                     "'','','','','','','',",           
                     "SUM(img10),SUM(oeb905),SUM(oeb12),'',SUM(oeb14),", #TQC-D60042 unmark
                     #"img10,SUM(oeb905),SUM(oeb12),'',SUM(oeb14),", #MOD-D10190 #TQC-D60042 mark
                     "SUM(oeb14t),'',SUM(ogb12),SUM(oeb24),'',SUM(ogb14t),SUM(ohb12),'',SUM(ohb14t),",
                     "SUM(ogb16),SUM(ogb18),SUM(omb12),SUM(omb14t),SUM(sfb09) FROM axmq001_tmp WHERE ((",l_wc,")",
                     #" GROUP BY oea15,gem02,oea23,img10  ", #MOD-D10190 add img10 #TQC-D60042 mark
                     " GROUP BY oea15,gem02,oea23 ", #TQC-D60042
                     " ORDER BY oea15,gem02,oea23 "
      WHEN '8'
         LET l_sql = "SELECT '','','','','','','','','','','',",
                     "'','',oea10,'','','','','','',oea23,'',",   #FUN-D10105 '','','',''
                     "'','','','','','','',",              
                     "SUM(img10),SUM(oeb905),SUM(oeb12),'',SUM(oeb14),", #TQC-D60042 unmark
                     #"img10,SUM(oeb905),SUM(oeb12),'',SUM(oeb14),", #MOD-D10190 #TQC-D60042 mark
                     "SUM(oeb14t),'',SUM(ogb12),SUM(oeb24),'',SUM(ogb14t),SUM(ohb12),'',SUM(ohb14t),",
                     "SUM(ogb16),SUM(ogb18),SUM(omb12),SUM(omb14t),SUM(sfb09) FROM axmq001_tmp WHERE ((",l_wc,")",
                     #" GROUP BY oea10,oea23,img10  ", #MOD-D10190 add img10 #TQC-D60042 mark
                     " GROUP BY oea10,oea23 ",  #TQC-D60042
                     " ORDER BY oea10,oea23 "
      WHEN '9'
         LET l_sql = "SELECT '','','','','','','','','',",
                     "'','','','','',oeb04,oeb06,ima021,'','','',oea23,'',",  #FUN-D10105 '','','',''
                     "'','','','','','','',",                   
                     "SUM(img10),SUM(oeb905),SUM(oeb12),'',SUM(oeb14),", #TQC-D60042 unmark
                     #"img10,SUM(oeb905),SUM(oeb12),'',SUM(oeb14),", #MOD-D10190 #TQC-D60042 mark
                     "SUM(oeb14t),'',SUM(ogb12),SUM(oeb24),'',SUM(ogb14t),SUM(ohb12),'',SUM(ohb14t),",
                     "SUM(ogb16),SUM(ogb18),SUM(omb12),SUM(omb14t),SUM(sfb09) FROM axmq001_tmp WHERE ((",l_wc,")",
                     #" GROUP BY oeb04,oeb06,ima021,oea23,img10  ", #MOD-D10190 add img10 #TQC-D60042 mark
                     " GROUP BY oeb04,oeb06,ima021,oea23 ", #TQC-D60042
                     " ORDER BY oeb04,oeb06,ima021,oea23 "
     #FUN-D10105---add---str---
      WHEN '10'
         LET l_sql = "SELECT '','','','','','','',occ03,oca02,",
                     "'','','','','','','','','','','',oea23,'',",    
                     "'','','','','','','',",             
                     "SUM(img10),SUM(oeb905),SUM(oeb12),'',SUM(oeb14),", #TQC-D60042 unmark
                     #"img10,SUM(oeb905),SUM(oeb12),'',SUM(oeb14),", #MOD-D10190 #TQC-D60042 mark
                     "SUM(oeb14t),'',SUM(ogb12),SUM(oeb24),'',SUM(ogb14t),SUM(ohb12),'',SUM(ohb14t),",
                     "SUM(ogb16),SUM(ogb18),SUM(omb12),SUM(omb14t),SUM(sfb09) FROM axmq001_tmp WHERE ((",l_wc,")",
                     #" GROUP BY occ03,oca02,oea23,img10  ", #MOD-D10190 add img10 #TQC-D60042 mark
                     " GROUP BY occ03,oca02,oea23 ", #TQC-D60042
                     " ORDER BY occ03,oca02,oea23 "
      WHEN '11'
         LET l_sql = "SELECT '','','','','','','','','',",
                     "'','','','','','','','',ima131,oba02,'',oea23,'',",    
                     "'','','','','','','',",             
                     "SUM(img10),SUM(oeb905),SUM(oeb12),'',SUM(oeb14),", #TQC-D60042 unmark
                     #"img10,SUM(oeb905),SUM(oeb12),'',SUM(oeb14),", #MOD-D10190 #TQC-D60042 mark
                     "SUM(oeb14t),'',SUM(ogb12),SUM(oeb24),'',SUM(ogb14t),SUM(ohb12),'',SUM(ohb14t),",
                     "SUM(ogb16),SUM(ogb18),SUM(omb12),SUM(omb14t),SUM(sfb09) FROM axmq001_tmp WHERE ((",l_wc,")",
                     #" GROUP BY ima131,oba02,oea23,img10  ",  #MOD-D10190 add img10 #TQC-D60042 mark
                     " GROUP BY ima131,oba02,oea23 ", #TQC-D60042
                     " ORDER BY ima131,oba02,oea23 "
     #FUN-D10105---add---end---
   END CASE 
              
   PREPARE q001_pb FROM l_sql
   DECLARE q001_curs1 CURSOR FOR q001_pb
   FOREACH q001_curs1 INTO g_oea_1[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_oea_qty = g_oea_qty + g_oea_1[g_cnt].oeb12
      LET g_oea_sum = g_oea_sum + g_oea_1[g_cnt].oeb14t
      LET g_oea_sum1= g_oea_sum1+ g_oea_1[g_cnt].oeb14
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_oea_1.deleteElement(g_cnt)
   LET g_cnt = g_cnt - 1
   DISPLAY ARRAY g_oea_1 TO s_oea_1.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
 
   LET g_rec_b2 = g_cnt 
   DISPLAY g_rec_b2 TO FORMONLY.cnt1 
   DISPLAY g_oea_qty TO FORMONLY.tot_qty
   DISPLAY g_oea_sum TO FORMONLY.tot_sum
   DISPLAY g_oea_sum1 TO FORMONLY.tot_sum1
END FUNCTION  

FUNCTION q001_detail_fill(p_ac)
DEFINE p_ac         LIKE type_file.num5,
       l_sql   STRING,
       l_wc    STRING, 
       l_wc1   STRING
   
   LET l_sql = "SELECT h_b,oea00,oea01,oea08,oea901,oea03,oea032,oea04,occ02,occ03,oca02,oea02,oea14,gen02,",  #FUN-D10105 add occ03,oca02  #FUN-D50044 add oea901
               "oea15,gem02,oea23,oea21,oea211,oea213,oea10,oeaconf,oea72,oea49,oeb03,oeb04,",
               "oeb06,ima021,oeb11,ima131,oba02,oeb05,img10,oeb905,oeb12,oeb13,oeb14,oeb14t,oeb15,ogb12,", #FUN-D10105 add ima131,oba02
               "oeb24,ogb13,ogb14t,ohb12,ohb13,ohb14t,ogb16,ogb18,omb12,omb14t,sfb_count,sfb09,oebud01",
               " FROM axmq001_tmp WHERE "
   CASE tm.a 
      WHEN "1" 
         IF cl_null(g_oea_1[p_ac].oea00) THEN
            LET l_wc = " OR oea00 IS NULL"
         ELSE 
            LET l_wc = ''
         END IF
         IF cl_null(g_oea_1[p_ac].oea23) THEN
            LET l_wc1 = " OR oea23 IS NULL"
         ELSE
            LET l_wc1 = ''
         END IF 
         LET l_sql = l_sql,"(oea00 = '",g_oea_1[p_ac].oea00,"'",l_wc,")",
                           " AND (oea23 = '",g_oea_1[p_ac].oea23,"'",l_wc1,")",
                           " ORDER BY oea00,oea23"
      WHEN "2"
         IF cl_null(g_oea_1[p_ac].oea08) THEN
            LET l_wc = " OR oea08 IS NULL"
         ELSE 
            LET l_wc = ''
         END IF
         IF cl_null(g_oea_1[p_ac].oea23) THEN
            LET l_wc1 = " OR oea23 IS NULL"
         ELSE
            LET l_wc1 = ''
         END IF 
         LET l_sql = l_sql,"(oea08 = '",g_oea_1[p_ac].oea08,"'",l_wc,")",
                           " AND (oea23 = '",g_oea_1[p_ac].oea23,"'",l_wc1,")", 
                           " ORDER BY oea08,oea23"
      WHEN "3"
         IF cl_null(g_oea_1[p_ac].oea02) THEN
            LET l_wc = " OR oea02 IS NULL"
         ELSE 
            LET l_wc = ''
         END IF
         IF cl_null(g_oea_1[p_ac].oea23) THEN
            LET l_wc1 = " OR oea23 IS NULL"
         ELSE
            LET l_wc1 = ''
         END IF
         LET l_sql = l_sql,"(oea02 = '",g_oea_1[p_ac].oea02,"'",l_wc,")",
                           " AND (oea23 = '",g_oea_1[p_ac].oea23,"'",l_wc1,")",
                           " ORDER BY oea02,oea23"
      WHEN "4"
         IF cl_null(g_oea_1[p_ac].oea03) THEN
            LET l_wc = " OR oea03 IS NULL"
         ELSE 
            LET l_wc = ''
         END IF
         IF cl_null(g_oea_1[p_ac].oea23) THEN
            LET l_wc1 = " OR oea23 IS NULL"
         ELSE
            LET l_wc1 = ''
         END IF
         LET l_sql = l_sql,"(oea03 = '",g_oea_1[p_ac].oea03,"'",l_wc,")",
                           " AND (oea23 = '",g_oea_1[p_ac].oea23,"'",l_wc1,")",
                           " ORDER BY oea03,oea23"
      WHEN "5"
         IF cl_null(g_oea_1[p_ac].oea04) THEN
            LET l_wc = " OR oea04 IS NULL"
         ELSE 
            LET l_wc = ''
         END IF
         IF cl_null(g_oea_1[p_ac].oea23) THEN
            LET l_wc1 = " OR oea23 IS NULL"
         ELSE
            LET l_wc1 = ''
         END IF
         LET l_sql = l_sql,"(oea04 = '",g_oea_1[p_ac].oea04,"'",l_wc,")",
                           " AND (oea23 = '",g_oea_1[p_ac].oea23,"'",l_wc1,")",
                           " ORDER BY oea04,oea23"
      WHEN "6"
         IF cl_null(g_oea_1[p_ac].oea14) THEN
            LET l_wc = " OR oea14 IS NULL"
         ELSE 
            LET l_wc = ''
         END IF
         IF cl_null(g_oea_1[p_ac].oea23) THEN
            LET l_wc1 = " OR oea23 IS NULL"
         ELSE
            LET l_wc1 = ''
         END IF
         LET l_sql = l_sql,"(oea14 = '",g_oea_1[p_ac].oea14,"'",l_wc,")",
                           " AND (oea23 = '",g_oea_1[p_ac].oea23,"'",l_wc1,")",
                           " ORDER BY oea03,oea23"
      WHEN "7"
         IF cl_null(g_oea_1[p_ac].oea15) THEN
            LET l_wc = " OR oea15 IS NULL"
         ELSE 
            LET l_wc = ''
         END IF
         IF cl_null(g_oea_1[p_ac].oea23) THEN
            LET l_wc1 = " OR oea23 IS NULL"
         ELSE
            LET l_wc1 = ''
         END IF
         LET l_sql = l_sql,"(oea15 = '",g_oea_1[p_ac].oea15,"'",l_wc,")",
                           " AND (oea23 = '",g_oea_1[p_ac].oea23,"'",l_wc1,")",
                           " ORDER BY oea15,oea23"
      WHEN "8"
         IF cl_null(g_oea_1[p_ac].oea10) THEN
            LET l_wc = " OR oea10 IS NULL"
         ELSE 
            LET l_wc = ''
         END IF
         IF cl_null(g_oea_1[p_ac].oea23) THEN
            LET l_wc1 = " OR oea23 IS NULL"
         ELSE
            LET l_wc1 = ''
         END IF
         LET l_sql = l_sql,"(oea10 = '",g_oea_1[p_ac].oea10,"'",l_wc,")",
                           " AND (oea23 = '",g_oea_1[p_ac].oea23,"'",l_wc1,")",
                           " ORDER BY oea10,oea23"
      WHEN "9"
         IF cl_null(g_oea_1[p_ac].oeb04) THEN
            LET l_wc = " OR oeb04 IS NULL"
         ELSE 
            LET l_wc = ''
         END IF
         IF cl_null(g_oea_1[p_ac].oea23) THEN
            LET l_wc1 = " OR oea23 IS NULL"
         ELSE
            LET l_wc1 = ''
         END IF
         LET l_sql = l_sql,"(oeb04 = '",g_oea_1[p_ac].oeb04,"'",l_wc,")",
                           " AND (oea23 = '",g_oea_1[p_ac].oea23,"'",l_wc1,")",
                           " ORDER BY oeb04,oea23"
     #FUN-D10105---add---str---
      WHEN "10"
         IF cl_null(g_oea_1[p_ac].occ03) THEN
            LET l_wc = " OR occ03 IS NULL"
         ELSE 
            LET l_wc = ''
         END IF
         IF cl_null(g_oea_1[p_ac].oea23) THEN
            LET l_wc1 = " OR oea23 IS NULL"
         ELSE
            LET l_wc1 = ''
         END IF
         LET l_sql = l_sql,"(occ03 = '",g_oea_1[p_ac].occ03,"'",l_wc,")",
                           " AND (oea23 = '",g_oea_1[p_ac].oea23,"'",l_wc1,")",
                           " ORDER BY occ03,oea23"
      WHEN "11"
         IF cl_null(g_oea_1[p_ac].ima131) THEN
            LET l_wc = " OR ima131 IS NULL"
         ELSE 
            LET l_wc = ''
         END IF
         IF cl_null(g_oea_1[p_ac].oea23) THEN
            LET l_wc1 = " OR oea23 IS NULL"
         ELSE
            LET l_wc1 = ''
         END IF
         LET l_sql = l_sql,"(ima131 = '",g_oea_1[p_ac].ima131,"'",l_wc,")",
                           " AND (oea23 = '",g_oea_1[p_ac].oea23,"'",l_wc1,")",
                           " ORDER BY ima131,oea23"
     #FUN-D10105---add---end---
   END CASE

      PREPARE axmq001_pb_detail FROM l_sql
      DECLARE oea_curs_detail  CURSOR FOR axmq001_pb_detail        #CURSOR
      CALL g_oea.clear()
      LET g_cnt = 1
      LET g_rec_b = 0
     #xj-add--1029 pm 15:36
      LET g_oea_qty = 0
      LET g_oea_sum = 0
      LET g_oea_sum1= 0
     #xj-add--1029 pm 15:36
      FOREACH oea_curs_detail INTO g_oea_excel[g_cnt].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF g_cnt <= g_max_rec THEN
            LET g_oea[g_cnt].* = g_oea_excel[g_cnt].*
         END IF
        #xj-add--1029 pm 15:36
         LET g_oea_qty = g_oea_qty + g_oea_excel[g_cnt].oeb12
         LET g_oea_sum = g_oea_sum + g_oea_excel[g_cnt].oeb14t
         LET g_oea_sum1= g_oea_sum1+ g_oea_excel[g_cnt].oeb14
        #xj-add--1029 pm 15:36
         LET g_cnt = g_cnt + 1  
      END FOREACH
      IF g_cnt <= g_max_rec THEN
         CALL g_oea.deleteElement(g_cnt)
      END IF
      CALL g_oea_excel.deleteElement(g_cnt)
      LET g_rec_b = g_cnt -1
      IF g_rec_b > g_max_rec THEN
         CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
         LET g_rec_b = g_max_rec
      END IF
      DISPLAY g_rec_b TO FORMONLY.cnt  
END FUNCTION 

FUNCTION q001_set_visible()
DEFINE l_wc     LIKE type_file.chr20
CALL cl_set_comp_visible("oea00_11,oea08_11,oea02_1,oea03_1,oea032_1,oea04_1,occ02_1",TRUE)
CALL cl_set_comp_visible("oea14_1,gen02_1,oea15_1,gem02_1,oea10_1,oeb04_1,oeb06_1,ima021_1",TRUE)
CALL cl_set_comp_visible("oea01_1,oea21_1,oea211_1,oea213_1,oeaconf_1,oea49_11,oeb03_1,oeb11_1",TRUE)
CALL cl_set_comp_visible("oeb05,oeb13_1,oeb15_1,ogb13_1,ohb13_1,occ03_1,oca02_1,ima131_1,oba02_1",TRUE)    #FUN-D10105 occ03_1,oca02_1,ima131_1,oba02_1
CALL cl_set_comp_visible("img10_1",FALSE) #MOD-D10190

CASE tm.a 
   WHEN "1"
      CALL cl_set_comp_visible("oea08_11,oea02_1,oea03_1,oea032_1,oea04_1,occ02_1,oea14_1",FALSE)
      CALL cl_set_comp_visible("gen02_1,oea15_1,gem02_1,oea10_1,oeb04_1,oeb06_1,ima021_1",FALSE)
      CALL cl_set_comp_visible("oea01_1,oea21_1,oea211_1,oea213_1,oeaconf_1,oea49_11,oeb03_1,oeb11_1",FALSE)
      CALL cl_set_comp_visible("oeb05_1,oeb13_1,oeb15_1,ogb13_1,ohb13_1,occ03_1,oca02_1,ima131_1,oba02_1",FALSE)
   WHEN "2"
      CALL cl_set_comp_visible("oea00_11,oea02_1,oea03_1,oea032_1,oea04_1,occ02_1",FALSE)
      CALL cl_set_comp_visible("oea14_1,gen02_1,oea15_1,gem02_1,oea10_1,oeb04_1,oeb06_1,ima021_1",FALSE)
      CALL cl_set_comp_visible("oea01_1,oea21_1,oea211_1,oea213_1,oeaconf_1,oea49_11,oeb03_1,oeb11_1",FALSE)
      CALL cl_set_comp_visible("oeb05_1,oeb13_1,oeb15_1,ogb13_1,ohb13_1,occ03_1,oca02_1,ima131_1,oba02_1",FALSE)
   WHEN "3"
      CALL cl_set_comp_visible("oea00_11,oea08_11,oea03_1,oea032_1,oea04_1,occ02_1",FALSE)
      CALL cl_set_comp_visible("oea14_1,gen02_1,oea15_1,gem02_1,oea10_1,oeb04_1,oeb06_1,ima021_1",FALSE)
      CALL cl_set_comp_visible("oea01_1,oea21_1,oea211_1,oea213_1,oeaconf_1,oea49_11,oeb03_1,oeb11_1",FALSE)
      CALL cl_set_comp_visible("oeb05_1,oeb13_1,oeb15_1,ogb13_1,ohb13_1,occ03_1,oca02_1,ima131_1,oba02_1",FALSE)
   WHEN "4"
      CALL cl_set_comp_visible("oea00_11,oea08_11,oea02_1,oea04_1,occ02_1,oea14_1",FALSE)
      CALL cl_set_comp_visible("gen02_1,oea15_1,gem02_1,oea10_1,oeb04_1,oeb06_1,ima021_1",FALSE)
      CALL cl_set_comp_visible("oea01_1,oea21_1,oea211_1,oea213_1,oeaconf_1,oea49_11,oeb03_1,oeb11_1",FALSE)
      CALL cl_set_comp_visible("oeb05_1,oeb13_1,oeb15_1,ogb13_1,ohb13_1,occ03_1,oca02_1,ima131_1,oba02_1",FALSE)
   WHEN "5"
      CALL cl_set_comp_visible("oea00_11,oea08_11,oea02_1,oea03_1,oea032_1",FALSE)
      CALL cl_set_comp_visible("oea14_1,gen02_1,oea15_1,gem02_1,oea10_1,oeb04_1,oeb06_1,ima021_1",FALSE)
      CALL cl_set_comp_visible("oea01_1,oea21_1,oea211_1,oea213_1,oeaconf_1,oea49_11,oeb03_1,oeb11_1",FALSE)
      CALL cl_set_comp_visible("oeb05_1,oeb13_1,oeb15_1,ogb13_1,ohb13_1,occ03_1,oca02_1,ima131_1,oba02_1",FALSE)
   WHEN "6"
      CALL cl_set_comp_visible("oea00_11,oea08_11,oea02_1,oea03_1,oea032_1,oea04_1,occ02_1",FALSE)
      CALL cl_set_comp_visible("oea15_1,gem02_1,oea10_1,oeb04_1,oeb06_1,ima021_1",FALSE)
      CALL cl_set_comp_visible("oea01_1,oea21_1,oea211_1,oea213_1,oeaconf_1,oea49_11,oeb03_1,oeb11_1",FALSE)
      CALL cl_set_comp_visible("oeb05_1,oeb13_1,oeb15_1,ogb13_1,ohb13_1,occ03_1,oca02_1,ima131_1,oba02_1",FALSE)
   WHEN "7"
      CALL cl_set_comp_visible("oea00_11,oea08_11,oea02_1,oea03_1,oea032_1,oea04_1,occ02_1",FALSE)
      CALL cl_set_comp_visible("oea14_1,gen02_1,oea10_1,oeb04_1,oeb06_1,ima021_1",FALSE)
      CALL cl_set_comp_visible("oea01_1,oea21_1,oea211_1,oea213_1,oeaconf_1,oea49_11,oeb03_1,oeb11_1",FALSE)
      CALL cl_set_comp_visible("oeb05_1,oeb13_1,oeb15_1,ogb13_1,ohb13_1,occ03_1,oca02_1,ima131_1,oba02_1",FALSE)
   WHEN "8"
      CALL cl_set_comp_visible("oea00_11,oea08_11,oea02_1,oea03_1,oea032_1,oea04_1,occ02_1",FALSE)
      CALL cl_set_comp_visible("oea14_1,gen02_1,oea15_1,gem02_1,oeb04_1,oeb06_1,ima021_1",FALSE)
      CALL cl_set_comp_visible("oea01_1,oea21_1,oea211_1,oea213_1,oeaconf_1,oea49_11,oeb03_1,oeb11_1",FALSE)
      CALL cl_set_comp_visible("oeb05_1,oeb13_1,oeb15_1,ogb13_1,ohb13_1,occ03_1,oca02_1,ima131_1,oba02_1",FALSE)
   WHEN "9"
      CALL cl_set_comp_visible("oea00_11,oea08_11,oea02_1,oea03_1,oea032_1,oea04_1,occ02_1",FALSE)
      CALL cl_set_comp_visible("oea14_1,gen02_1,oea15_1,gem02_1,oea01_1,oea10_1",FALSE)
      CALL cl_set_comp_visible("oea21_1,oea211_1,oea213_1,oeaconf_1,oea49_11,oeb03_1,oeb11_1",FALSE)
      CALL cl_set_comp_visible("oeb05_1,oeb13_1,oeb15_1,ogb13_1,ohb13_1,occ03_1,oca02_1,ima131_1,oba02_1",FALSE) 
      CALL cl_set_comp_visible("img10_1",TRUE) #MOD-D10190 
   #FUN-D10105---add---str---   
   WHEN "10"
      CALL cl_set_comp_visible("oea00_11,oea08_11,oea02_1,oea03_1,oea032_1,oea04_1,occ02_1",FALSE)
      CALL cl_set_comp_visible("oea14_1,gen02_1,oea15_1,gem02_1,oea10_1,oeb04_1,oeb06_1,ima021_1",FALSE)
      CALL cl_set_comp_visible("oea01_1,oea21_1,oea211_1,oea213_1,oeaconf_1,oea49_11,oeb03_1,oeb11_1",FALSE)
      CALL cl_set_comp_visible("oeb05,oeb13_1,oeb15_1,ogb13_1,ohb13_1,ima131_1,oba02_1",FALSE)
   WHEN "11"
      CALL cl_set_comp_visible("oea00_11,oea08_11,oea02_1,oea03_1,oea032_1,oea04_1,occ02_1",FALSE)
      CALL cl_set_comp_visible("oea14_1,gen02_1,oea15_1,gem02_1,oea10_1,oeb04_1,oeb06_1,ima021_1",FALSE)
      CALL cl_set_comp_visible("oea01_1,oea21_1,oea211_1,oea213_1,oeaconf_1,oea49_11,oeb03_1,oeb11_1",FALSE)
      CALL cl_set_comp_visible("oeb05,oeb13_1,oeb15_1,ogb13_1,ohb13_1,occ03_1,oca02_1",FALSE)
   #FUN-D10105---add---end---    
END CASE
END FUNCTION 

FUNCTION q001_bp3()
   DEFINE   p_ud   LIKE type_file.chr1        

   LET g_action_choice = " "
   LET g_action_flag = "page3"
   DISPLAY BY NAME g_head.oea01_2,g_head.oea02_2,
                   g_head.oea03_2,g_head.oebislk01_2,
                   g_head.occ02_2,g_head.gen02_2,
                   g_head.oea14_2,g_head.moeb15_2,
                   g_head.oeb12_2,g_head.oeb24_2,
                   g_head.workpro_2,g_head.oeapro_2
   CASE g_b_flag2
      WHEN 1
        CALL q001_bp_so()
      WHEN 2
        CALL q001_bp_pr()
      WHEN 3
        CALL q001_bp_po()
      WHEN 4
        CALL q001_bp_wo()
      WHEN 5
        CALL q001_bp_sn()
      WHEN 6
        CALL q001_bp_sho()
      WHEN 7
        CALL q001_bp_misc()
      WHEN 8
        CALL q001_bp_qs()
      WHEN 9
        CALL q001_bp_qt()
      WHEN 10
        CALL q001_bp_xt()
      WHEN 11
        CALL q001_bp_ys()
      OTHERWISE
        CALL q001_bp_so()
   END CASE

END FUNCTION

FUNCTION q001_bp_so()
   LET g_action_choice = " "
   CASE g_b_flag3
      WHEN 1
        CALL q001_bp_oeb()
      WHEN 2
        CALL q001_bp_bmb()
      OTHERWISE
        CALL q001_bp_oeb()
   END CASE

END FUNCTION

FUNCTION q001_bp_pr()
   LET g_action_choice = " "
   CASE g_b_flag3
      WHEN 1
        CALL q001_bp_pmk()
      WHEN 2
        CALL q001_bp_pml()
      OTHERWISE
        CALL q001_bp_pmk()
   END CASE

END FUNCTION

FUNCTION q001_bp_po()
   LET g_action_choice = " "
   CASE g_b_flag3
      WHEN 1
        CALL q001_bp_pmm()
      WHEN 2
        CALL q001_bp_pmn()
      OTHERWISE
        CALL q001_bp_pmm()
   END CASE

END FUNCTION

FUNCTION q001_bp_wo()
   LET g_action_choice = " "
   CASE g_b_flag3
      WHEN 1
        CALL q001_bp_sfb()
      WHEN 2
        CALL q001_bp_ro()
      WHEN 3
        CALL q001_bp_sfa()
      OTHERWISE
        CALL q001_bp_pmm()
   END CASE

END FUNCTION

FUNCTION q001_bp_sn()
   LET g_action_choice = " "
   CASE g_b_flag3
      WHEN 1
        CALL q001_bp_oga()
      WHEN 2
        CALL q001_bp_ogb()
      OTHERWISE
        CALL q001_bp_oga()
   END CASE

END FUNCTION

FUNCTION q001_bp_sho()
   LET g_action_choice = " "
   CASE g_b_flag3
      WHEN 1
        CALL q001_bp_ogab()
      WHEN 2
        CALL q001_bp_ogbb()
      OTHERWISE
        CALL q001_bp_ogab()
   END CASE

END FUNCTION

FUNCTION q001_bp_misc()
   LET g_action_choice = " "
   CASE g_b_flag3
      WHEN 1
        CALL q001_bp_ina()
      WHEN 2
        CALL q001_bp_inb()
      OTHERWISE
        CALL q001_bp_ina()
   END CASE

END FUNCTION

FUNCTION q001_bp_qs()
   LET g_action_choice = " "
   CASE g_b_flag3
      WHEN 1
        CALL q001_bp_ogac()
      WHEN 2
        CALL q001_bp_ogbc()
      OTHERWISE
        CALL q001_bp_ogac()
   END CASE

END FUNCTION

FUNCTION q001_bp_qt()
   LET g_action_choice = " "
   CASE g_b_flag3
      WHEN 1
        CALL q001_bp_ogad()
      WHEN 2
        CALL q001_bp_ogbd()
      OTHERWISE
        CALL q001_bp_ogad()
   END CASE

END FUNCTION

FUNCTION q001_bp_xt()
   LET g_action_choice = " "
   CASE g_b_flag3
      WHEN 1
        CALL q001_bp_oha()
      WHEN 2
        CALL q001_bp_ohb()
      OTHERWISE
        CALL q001_bp_oha()
   END CASE

END FUNCTION

FUNCTION q001_bp_ys()
   LET g_action_choice = " "
   CASE g_b_flag3
      WHEN 1
        CALL q001_bp_oma()
      WHEN 2
        CALL q001_bp_omb()
      OTHERWISE
        CALL q001_bp_oma()
   END CASE

END FUNCTION

FUNCTION q001_bp_ro()
   LET g_action_choice = " "

   DISPLAY g_head_ecm.sfb01_ecm TO FORMONLY.sfb01_ecm
   DISPLAY g_head_ecm.sfb05_ecm TO FORMONLY.sfb05_ecm
   DISPLAY g_head_ecm.ima02_ecm TO FORMONLY.ima02_ecm
   DISPLAY g_head_ecm.ima05_ecm TO FORMONLY.ima05_ecm
   DISPLAY g_head_ecm.sfb08_ecm TO FORMONLY.sfb08_ecm
   DISPLAY g_head_ecm.sfb09_ecm TO FORMONLY.sfb09_ecm
   DISPLAY g_head_ecm.sfbpro_ecm TO FORMONLY.sfbpro_ecm

   CASE g_b_flag4
      WHEN 1
        CALL q001_bp_ecm()
      WHEN 2
        CALL q001_bp_sgd()
      OTHERWISE
        CALL q001_bp_ecm()
   END CASE

END FUNCTION

FUNCTION q001_bp_oeb()
   LET g_action_choice = " "
   DISPLAY g_rec_b_oeb TO FORMONLY.cn2
      CALL cl_set_act_visible("accept,cancel", FALSE)
    IF g_oea01_change_bmb = '1' THEN
       LET g_oea01_change_bmb = '0' 
       CALL cl_set_comp_visible("page6", FALSE)
       CALL  g_bmb.clear()
       INITIALIZE g_head_bmb.* TO NULL 
       LET g_rec_b_bmb = ''
       DISPLAY g_rec_b_bmb TO FORMONLY.cn2
       DISPLAY g_head_bmb.bmb01 TO FORMONLY.bmb01
       DISPLAY g_head_bmb.ima02_bma TO FORMONLY.ima02_bma
       DISPLAY g_head_bmb.ima05_bma TO FORMONLY.ima05_bma
       DISPLAY ARRAY g_bmb TO s_bmb.* ATTRIBUTE(COUNT=g_rec_b_bmb)
         BEFORE DISPLAY
            EXIT DISPLAY 
      END DISPLAY
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page6", TRUE)
   END IF
       DISPLAY ARRAY g_oeb TO s_oeb.* ATTRIBUTE(COUNT=g_rec_b_oeb)
          BEFORE DISPLAY
             EXIT DISPLAY 
       END DISPLAY 
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_oeb TO s_oeb.* ATTRIBUTE(COUNT=g_rec_b_oeb)

      BEFORE DISPLAY
         IF l_ac_oeb != 0 THEN
            CALL fgl_set_arr_curr(l_ac_oeb)
         END IF
   
      BEFORE ROW
        LET l_ac_oeb = ARR_CURR()
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
      ON ACTION bmb
         LET l_ac_oeb = ARR_CURR()
         IF l_ac_oeb > 0 THEN
            LET g_head_bmb.bmb01 = g_oeb[l_ac_oeb].oeb04
            LET g_head_bmb.ima02_bma = g_oeb[l_ac_oeb].ima02
            LET g_head_bmb.ima05_bma = g_oeb[l_ac_oeb].ima05
            LET g_b_flag3 = 2
            LET g_action_choice = "bmb"
         END IF
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION wo
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION sn
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "oga"
         EXIT DIALOG
      ON ACTION sho
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "ogab"
         EXIT DIALOG
      ON ACTION misc
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "ina"
         EXIT DIALOG  
      ON ACTION qs
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "ogac"
         EXIT DIALOG  
      ON ACTION qt
         LET g_b_flag2 = 9
         LET g_b_flag3 = 1
         LET g_action_choice = "ogad"
         EXIT DIALOG    
      ON ACTION xt
         LET g_b_flag2 = 10
         LET g_b_flag3 = 1
         LET g_action_choice = "oha"
         EXIT DIALOG   
      ON ACTION ys
         LET g_b_flag2 = 11
         LET g_b_flag3 = 1
         LET g_action_choice = "oma"
         EXIT DIALOG
      AFTER  DIALOG
         CONTINUE  DIALOG
END DIALOG
   
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp_bmb()
   LET g_action_choice = " "
   DISPLAY g_rec_b_bmb TO FORMONLY.cn2
   DISPLAY g_head_bmb.bmb01 TO FORMONLY.bmb01
   DISPLAY g_head_bmb.ima02_bma TO FORMONLY.ima02_bma
   DISPLAY g_head_bmb.ima05_bma TO FORMONLY.ima05_bma
      CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmb TO s_bmb.* ATTRIBUTE(COUNT=g_rec_b_bmb)

      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY 
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_bmb TO s_bmb.* ATTRIBUTE(COUNT=g_rec_b_bmb)

      BEFORE DISPLAY
         IF l_ac_bmb != 0 THEN
            CALL fgl_set_arr_curr(l_ac_bmb)
         END IF

      BEFORE ROW
        LET l_ac_bmb = ARR_CURR()
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
      ON ACTION oeb
         LET g_b_flag3 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION wo
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION sn
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "oga"
         EXIT DIALOG
      ON ACTION sho
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "ogab"
         EXIT DIALOG
      ON ACTION misc
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "ina"
         EXIT DIALOG   
      ON ACTION qs
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "ogac"
         EXIT DIALOG  
      ON ACTION qt
         LET g_b_flag2 = 9
         LET g_b_flag3 = 1
         LET g_action_choice = "ogad"
         EXIT DIALOG    
      ON ACTION xt
         LET g_b_flag2 = 10
         LET g_b_flag3 = 1
         LET g_action_choice = "oha"
         EXIT DIALOG        
      ON ACTION ys
         LET g_b_flag2 = 11
         LET g_b_flag3 = 1
         LET g_action_choice = "oma"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp_pmk()
   LET g_action_choice = " "
   DISPLAY g_rec_b_pmk TO FORMONLY.cn2
      CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_oea01_change_pml = '1' OR g_oeb03_change_pml = '1' THEN
      LET g_oea01_change_pml = '0' 
      LET g_oeb03_change_pml = '0'
      CALL cl_set_comp_visible("page8", FALSE)
      CALL  g_pml.clear()
      INITIALIZE g_head_pml.* TO NULL 
      LET g_rec_b_pml = ''
      DISPLAY g_rec_b_pml TO FORMONLY.cn2
      DISPLAY g_head_pml.pml01 TO FORMONLY.pml01
      DISPLAY g_head_pml.pmk04_pml TO FORMONLY.pmk04_pml
      DISPLAY g_head_pml.pmk09_pml TO FORMONLY.pmk09_pml
      DISPLAY g_head_pml.pmc03_pml TO FORMONLY.pmc03_pml
      DISPLAY g_head_pml.pmk12_pml TO FORMONLY.pmk12_pml
      DISPLAY ARRAY g_pml TO s_pml.* ATTRIBUTE(COUNT=g_rec_b_pml)
         BEFORE DISPLAY
            EXIT DISPLAY 
      END DISPLAY
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page8", TRUE)
   END IF
   DISPLAY ARRAY g_pmk TO s_pmk.* ATTRIBUTE(COUNT=g_rec_b_pmk)

      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY 
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_pmk TO s_pmk.* ATTRIBUTE(COUNT=g_rec_b_pmk)

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
            LET g_head_pml.pml01 = g_pmk[l_ac_pmk].pmk01
            LET g_head_pml.pmk04_pml = g_pmk[l_ac_pmk].pmk04
            LET g_head_pml.pmk09_pml = g_pmk[l_ac_pmk].pmk09
            LET g_head_pml.pmc03_pml = g_pmk[l_ac_pmk].pmc03_pmk
            LET g_head_pml.pmk12_pml = g_pmk[l_ac_pmk].pmk12
            LET g_head_pml.gen02_pml = g_pmk[l_ac_pmk].gen02_pmk
            LET g_b_flag3 = 2
            LET g_action_choice = "pml"
         END IF
         EXIT DIALOG
      ON ACTION so
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION wo
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION sn
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "oga"
         EXIT DIALOG
      ON ACTION sho
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "ogab"
         EXIT DIALOG
      ON ACTION misc
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "ina"
         EXIT DIALOG 
      ON ACTION qs
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "ogac"
         EXIT DIALOG  
      ON ACTION qt
         LET g_b_flag2 = 9
         LET g_b_flag3 = 1
         LET g_action_choice = "ogad"
         EXIT DIALOG    
      ON ACTION xt
         LET g_b_flag2 = 10
         LET g_b_flag3 = 1
         LET g_action_choice = "oha"
         EXIT DIALOG          
      ON ACTION ys
         LET g_b_flag2 = 11
         LET g_b_flag3 = 1
         LET g_action_choice = "oma"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG

END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp_pml()
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
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
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
      ON ACTION so
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION wo
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION sn
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "oga"
         EXIT DIALOG
      ON ACTION sho
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "ogab"
         EXIT DIALOG
      ON ACTION misc
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "ina"
         EXIT DIALOG  
      ON ACTION qs
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "ogac"
         EXIT DIALOG  
      ON ACTION qt
         LET g_b_flag2 = 9
         LET g_b_flag3 = 1
         LET g_action_choice = "ogad"
         EXIT DIALOG    
      ON ACTION xt
         LET g_b_flag2 = 10
         LET g_b_flag3 = 1
         LET g_action_choice = "oha"
         EXIT DIALOG         
      ON ACTION ys
         LET g_b_flag2 = 11
         LET g_b_flag3 = 1
         LET g_action_choice = "oma"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG

END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp_pmm()
   LET g_action_choice = " "
   DISPLAY g_rec_b_pmm TO FORMONLY.cn2
      CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_oea01_change_pmn = '1' OR g_oeb03_change_pmn = '1' THEN
      LET g_oea01_change_pmn = '0' 
      LET g_oeb03_change_pmn = '0'
      CALL cl_set_comp_visible("page11", FALSE)
      CALL  g_pmn.clear()
      INITIALIZE g_head_pmn.* TO NULL 
      LET g_rec_b_pmn = ''
      DISPLAY g_rec_b_pmn TO FORMONLY.cn2
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
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page11", TRUE)
   END IF
   DISPLAY ARRAY g_pmm TO s_pmm.* ATTRIBUTE(COUNT=g_rec_b_pmm)

      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
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
      ON ACTION so
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION wo
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION sn
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "oga"
         EXIT DIALOG
      ON ACTION sho
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "ogab"
         EXIT DIALOG
      ON ACTION misc
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "ina"
         EXIT DIALOG    
      ON ACTION qs
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "ogac"
         EXIT DIALOG  
      ON ACTION qt
         LET g_b_flag2 = 9
         LET g_b_flag3 = 1
         LET g_action_choice = "ogad"
         EXIT DIALOG    
      ON ACTION xt
         LET g_b_flag2 = 10
         LET g_b_flag3 = 1
         LET g_action_choice = "oha"
         EXIT DIALOG        
      ON ACTION ys
         LET g_b_flag2 = 11
         LET g_b_flag3 = 1
         LET g_action_choice = "oma"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp_pmn()
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
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
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
      ON ACTION so
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION wo
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION sn
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "oga"
         EXIT DIALOG
      ON ACTION sho
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "ogab"
         EXIT DIALOG
      ON ACTION misc
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "ina"
         EXIT DIALOG 
      ON ACTION qs
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "ogac"
         EXIT DIALOG  
      ON ACTION qt
         LET g_b_flag2 = 9
         LET g_b_flag3 = 1
         LET g_action_choice = "ogad"
         EXIT DIALOG    
      ON ACTION xt
         LET g_b_flag2 = 10
         LET g_b_flag3 = 1
         LET g_action_choice = "oha"
         EXIT DIALOG      
      ON ACTION ys
         LET g_b_flag2 = 11
         LET g_b_flag3 = 1
         LET g_action_choice = "oma"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG

END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp_sfb()
   LET g_action_choice = " "
   DISPLAY g_rec_b_sfb TO FORMONLY.cn2
      CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_oea01_change_ecm = '1' OR g_oea01_change_sfa = '1'THEN
      LET g_oea01_change_ecm = '0'
      LET g_oea01_change_sfa = '0'
      CALL cl_set_comp_visible("page14,allotment", FALSE)
      CALL  g_ecm.clear()
      CALL  g_sfa.clear()     
      INITIALIZE g_head_sfa.* TO NULL 
      INITIALIZE g_head_ecm.* TO NULL 
      LET g_rec_b_ecm = ''
      LET g_rec_b_sfa = ''
      DISPLAY g_rec_b_ecm TO FORMONLY.cn2
      DISPLAY g_head_ecm.sfb01_ecm TO FORMONLY.sfb01_ecm
      DISPLAY g_head_ecm.sfb05_ecm TO FORMONLY.sfb05_ecm 
      DISPLAY g_head_ecm.ima02_ecm TO FORMONLY.ima02_ecm
      DISPLAY g_head_ecm.ima05_ecm TO FORMONLY.ima05_ecm 
      DISPLAY g_head_ecm.sfb08_ecm TO FORMONLY.sfb08_ecm 
      DISPLAY g_head_ecm.sfb09_ecm TO FORMONLY.sfb09_ecm 
      DISPLAY g_head_ecm.sfbpro_ecm TO FORMONLY.sfbpro_ecm 
      DISPLAY g_rec_b_sfa TO FORMONLY.cn2
      DISPLAY g_head_sfa.sfb01_sfa TO FORMONLY.sfb01_sfa
      DISPLAY g_head_sfa.sfb05_sfa TO FORMONLY.sfb05_sfa
      DISPLAY g_head_sfa.ima02_sfa TO FORMONLY.ima02_sfa
      DISPLAY g_head_sfa.ima05_sfa TO FORMONLY.ima05_sfa
      DISPLAY g_head_sfa.sfb08_sfa TO FORMONLY.sfb08_sfa
      DISPLAY g_head_sfa.sfb081_sfa TO FORMONLY.sfb081_sfa
      DISPLAY ARRAY g_ecm TO s_ecm.* ATTRIBUTE(COUNT=g_rec_b_ecm)
         BEFORE DISPLAY
            EXIT DISPLAY 
      END DISPLAY
      DISPLAY ARRAY g_sfa TO s_sfa.* ATTRIBUTE(COUNT=g_rec_b_sfa)
         BEFORE DISPLAY
            EXIT DISPLAY 
      END DISPLAY
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page14,allotment", TRUE)
   END IF
   DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b_sfb)

      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b_sfb)

      BEFORE DISPLAY
         IF l_ac_sfb != 0 THEN
            CALL fgl_set_arr_curr(l_ac_sfb)
         END IF

      BEFORE ROW
        LET l_ac_sfb = ARR_CURR()
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
      ON ACTION ro
         LET l_ac_sfb = ARR_CURR()
         IF l_ac_sfb > 0 THEN
            LET g_head_ecm.sfb01_ecm = g_sfb[l_ac_sfb].sfb01
            LET g_head_ecm.sfb05_ecm = g_sfb[l_ac_sfb].sfb05
            LET g_head_ecm.ima02_ecm = g_sfb[l_ac_sfb].ima02_sfb
            LET g_head_ecm.ima05_ecm = g_sfb[l_ac_sfb].ima05_sfb
            LET g_head_ecm.sfb08_ecm = g_sfb[l_ac_sfb].sfb08
            LET g_head_ecm.sfb09_ecm = g_sfb[l_ac_sfb].sfb09
            LET g_head_ecm.sfbpro_ecm = g_sfb[l_ac_sfb].sfbpro
            LET g_b_flag3 = 2
            LET g_b_flag4 = 1
            LET g_action_choice = "ecm"
         END IF
         EXIT DIALOG
      ON ACTION sfa
         LET l_ac_sfb = ARR_CURR()
         IF l_ac_sfb > 0 THEN
            LET g_head_sfa.sfb01_sfa = g_sfb[l_ac_sfb].sfb01
            LET g_head_sfa.sfb05_sfa = g_sfb[l_ac_sfb].sfb05
            LET g_head_sfa.ima02_sfa = g_sfb[l_ac_sfb].ima02_sfb
            LET g_head_sfa.ima05_sfa = g_sfb[l_ac_sfb].ima05_sfb
            LET g_head_sfa.sfb08_sfa = g_sfb[l_ac_sfb].sfb08
            LET g_head_sfa.sfb081_sfa = g_sfb[l_ac_sfb].sfb081
            LET g_b_flag3 = 3
            LET g_action_choice = "sfa"
         END IF
         EXIT DIALOG
      ON ACTION so
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION sn
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "oga"
         EXIT DIALOG
      ON ACTION sho
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "ogab"
         EXIT DIALOG
      ON ACTION misc
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "ina"
         EXIT DIALOG             
      ON ACTION qs
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "ogac"
         EXIT DIALOG  
      ON ACTION qt
         LET g_b_flag2 = 9
         LET g_b_flag3 = 1
         LET g_action_choice = "ogad"
         EXIT DIALOG    
      ON ACTION xt
         LET g_b_flag2 = 10
         LET g_b_flag3 = 1
         LET g_action_choice = "oha"
         EXIT DIALOG 
      ON ACTION ys
         LET g_b_flag2 = 11
         LET g_b_flag3 = 1
         LET g_action_choice = "oma"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp_ecm()
   LET g_action_choice = " "
   DISPLAY g_rec_b_ecm TO FORMONLY.cn2
      CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_oea01_change_sgd = '1' THEN
      LET g_oea01_change_sgd = '0' 
      CALL cl_set_comp_visible("page16", FALSE)
      CALL  g_sgd.clear()   
      LET g_rec_b_sgd = ''
      DISPLAY g_rec_b_sgd TO FORMONLY.cn2  
      DISPLAY ARRAY g_sgd TO s_sgd.* ATTRIBUTE(COUNT=g_rec_b_sgd)
         BEFORE DISPLAY
            EXIT DISPLAY 
      END DISPLAY
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page16", TRUE)
   END IF
   DISPLAY ARRAY g_ecm TO s_ecm.* ATTRIBUTE(COUNT=g_rec_b_ecm)

      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_ecm TO s_ecm.* ATTRIBUTE(COUNT=g_rec_b_ecm)

      BEFORE DISPLAY
         IF l_ac_ecm != 0 THEN
            CALL fgl_set_arr_curr(l_ac_ecm)
         END IF

      BEFORE ROW
        LET l_ac_ecm = ARR_CURR()
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
      ON ACTION sfa
            LET g_head_sfa.sfb01_sfa = g_sfb[l_ac_sfb].sfb01
            LET g_head_sfa.sfb05_sfa = g_sfb[l_ac_sfb].sfb05
            LET g_head_sfa.ima02_sfa = g_sfb[l_ac_sfb].ima02_sfb
            LET g_head_sfa.ima05_sfa = g_sfb[l_ac_sfb].ima05_sfb
            LET g_head_sfa.sfb08_sfa = g_sfb[l_ac_sfb].sfb08
            LET g_head_sfa.sfb081_sfa = g_sfb[l_ac_sfb].sfb081
            LET g_b_flag3 = 3
            LET g_action_choice = "sfa"
         EXIT DIALOG
      ON ACTION sgd
         LET l_ac_ecm = ARR_CURR()
         IF l_ac_ecm > 0 THEN
            LET g_b_flag4 = 2
            LET g_action_choice = "sgd"
         END IF
         EXIT DIALOG
      ON ACTION sfb
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION so
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION sn
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "oga"
         EXIT DIALOG
      ON ACTION sho
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "ogab"
         EXIT DIALOG
      ON ACTION misc
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "ina"
         EXIT DIALOG  
      ON ACTION qs
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "ogac"
         EXIT DIALOG  
      ON ACTION qt
         LET g_b_flag2 = 9
         LET g_b_flag3 = 1
         LET g_action_choice = "ogad"
         EXIT DIALOG    
      ON ACTION xt
         LET g_b_flag2 = 10
         LET g_b_flag3 = 1
         LET g_action_choice = "oha"
         EXIT DIALOG    
      ON ACTION ys
         LET g_b_flag2 = 11
         LET g_b_flag3 = 1
         LET g_action_choice = "oma"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp_sgd()
   LET g_action_choice = " "
   DISPLAY g_rec_b_sgd TO FORMONLY.cn2
      CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sgd TO s_sgd.* ATTRIBUTE(COUNT=g_rec_b_sgd)

      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_sgd TO s_sgd.* ATTRIBUTE(COUNT=g_rec_b_sgd)

      BEFORE DISPLAY
         IF l_ac_sgd != 0 THEN
            CALL fgl_set_arr_curr(l_ac_sgd)
         END IF

      BEFORE ROW
        LET l_ac_sgd = ARR_CURR()
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
      ON ACTION sfa
         LET g_head_sfa.sfb01_sfa = g_sfb[l_ac_sfb].sfb01
         LET g_head_sfa.sfb05_sfa = g_sfb[l_ac_sfb].sfb05
         LET g_head_sfa.ima02_sfa = g_sfb[l_ac_sfb].ima02_sfb
         LET g_head_sfa.ima05_sfa = g_sfb[l_ac_sfb].ima05_sfb
         LET g_head_sfa.sfb08_sfa = g_sfb[l_ac_sfb].sfb08
         LET g_head_sfa.sfb081_sfa = g_sfb[l_ac_sfb].sfb081
         LET g_b_flag3 = 3
         LET g_b_flag4 = 1
         LET g_action_choice = "sfa"
         EXIT DIALOG
      ON ACTION ecm
         LET g_b_flag4 = 1
         LET g_action_choice = "ecm"
         EXIT DIALOG
      ON ACTION sfb
         LET g_b_flag3 = 1
         LET g_b_flag4 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION so
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_b_flag4 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_b_flag4 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_b_flag4 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION sn
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "oga"
         EXIT DIALOG
      ON ACTION sho
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "ogab"
         EXIT DIALOG
      ON ACTION misc
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "ina"
         EXIT DIALOG 
      ON ACTION qs
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "ogac"
         EXIT DIALOG  
      ON ACTION qt
         LET g_b_flag2 = 9
         LET g_b_flag3 = 1
         LET g_action_choice = "ogad"
         EXIT DIALOG    
      ON ACTION xt
         LET g_b_flag2 = 10
         LET g_b_flag3 = 1
         LET g_action_choice = "oha"
         EXIT DIALOG        
      ON ACTION ys
         LET g_b_flag2 = 11
         LET g_b_flag3 = 1
         LET g_action_choice = "oma"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp_sfa()
   LET g_action_choice = " "
   DISPLAY g_rec_b_sfa TO FORMONLY.cn2
   DISPLAY g_head_sfa.sfb01_sfa TO FORMONLY.sfb01_sfa
   DISPLAY g_head_sfa.sfb05_sfa TO FORMONLY.sfb05_sfa
   DISPLAY g_head_sfa.ima02_sfa TO FORMONLY.ima02_sfa
   DISPLAY g_head_sfa.ima05_sfa TO FORMONLY.ima05_sfa
   DISPLAY g_head_sfa.sfb08_sfa TO FORMONLY.sfb08_sfa
   DISPLAY g_head_sfa.sfb081_sfa TO FORMONLY.sfb081_sfa
      CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfa TO s_sfa.* ATTRIBUTE(COUNT=g_rec_b_sfa)

      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_sfa TO s_sfa.* ATTRIBUTE(COUNT=g_rec_b_sfa)

      BEFORE DISPLAY
         IF l_ac_sfa != 0 THEN
            CALL fgl_set_arr_curr(l_ac_sfa)
         END IF

      BEFORE ROW
        LET l_ac_sfa = ARR_CURR()
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
      ON ACTION ro
         LET g_head_ecm.sfb01_ecm = g_sfb[l_ac_sfb].sfb01
         LET g_head_ecm.sfb05_ecm = g_sfb[l_ac_sfb].sfb05
         LET g_head_ecm.ima02_ecm = g_sfb[l_ac_sfb].ima02_sfb
         LET g_head_ecm.ima05_ecm = g_sfb[l_ac_sfb].ima05_sfb
         LET g_head_ecm.sfb08_ecm = g_sfb[l_ac_sfb].sfb08
         LET g_head_ecm.sfb09_ecm = g_sfb[l_ac_sfb].sfb09
         LET g_head_ecm.sfbpro_ecm = g_sfb[l_ac_sfb].sfbpro
         LET g_b_flag3 = 2
         LET g_b_flag4 = 1
         LET g_action_choice = "ecm"
         EXIT DIALOG
      ON ACTION sfb
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION so
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION sn
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "oga"
         EXIT DIALOG
      ON ACTION sho
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "ogab"
         EXIT DIALOG
      ON ACTION misc
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "ina"
         EXIT DIALOG      
      ON ACTION qs
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "ogac"
         EXIT DIALOG  
      ON ACTION qt
         LET g_b_flag2 = 9
         LET g_b_flag3 = 1
         LET g_action_choice = "ogad"
         EXIT DIALOG    
      ON ACTION xt
         LET g_b_flag2 = 10
         LET g_b_flag3 = 1
         LET g_action_choice = "oha"
         EXIT DIALOG        
      ON ACTION ys
         LET g_b_flag2 = 11
         LET g_b_flag3 = 1
         LET g_action_choice = "oma"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp_oga()
   LET g_action_choice = " "
   DISPLAY g_rec_b_oga TO FORMONLY.cn2
      CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_oea01_change_ogb = '1' THEN
      LET g_oea01_change_ogb = '0' 
      CALL cl_set_comp_visible("page21", FALSE)
      CALL  g_ogb.clear()   
      INITIALIZE g_head_ogb.* TO NULL 
      LET g_rec_b_ogb = ''
      DISPLAY g_rec_b_ogb TO FORMONLY.cn2
      DISPLAY g_head_ogb.oga01_ogb TO FORMONLY.oga01_ogb
      DISPLAY g_head_ogb.oga02_ogb TO FORMONLY.oga02_ogb
      DISPLAY g_head_ogb.oga03_ogb TO FORMONLY.oga03_ogb
      DISPLAY g_head_ogb.oga032_ogb TO FORMONLY.oga032_ogb
      DISPLAY g_head_ogb.oga14_ogb TO FORMONLY.oga14_ogb
      DISPLAY g_head_ogb.gen02_ogb TO FORMONLY.gen02_ogb
      DISPLAY g_head_ogb.ogaconf_ogb TO FORMONLY.ogaconf_ogb
      DISPLAY g_head_ogb.ogapost_ogb TO FORMONLY.ogapost_ogb  
      DISPLAY ARRAY g_ogb TO s_ogb.* ATTRIBUTE(COUNT=g_rec_b_ogb)
         BEFORE DISPLAY
            EXIT DISPLAY 
      END DISPLAY
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page21", TRUE)
   END IF
   DISPLAY ARRAY g_oga TO s_oga.* ATTRIBUTE(COUNT=g_rec_b_oga)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_oga TO s_oga.* ATTRIBUTE(COUNT=g_rec_b_oga)

      BEFORE DISPLAY
         IF l_ac_oga != 0 THEN
            CALL fgl_set_arr_curr(l_ac_oga)
         END IF

      BEFORE ROW
        LET l_ac_oga = ARR_CURR()
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
      ON ACTION ogb
         LET l_ac_oga = ARR_CURR()
         IF l_ac_oga > 0 THEN
            LET g_head_ogb.oga01_ogb = g_oga[l_ac_oga].oga01
            LET g_head_ogb.oga02_ogb = g_oga[l_ac_oga].oga02
            LET g_head_ogb.oga03_ogb = g_oga[l_ac_oga].oga03
            LET g_head_ogb.oga032_ogb = g_oga[l_ac_oga].oga032
            LET g_head_ogb.oga14_ogb = g_oga[l_ac_oga].oga14
            LET g_head_ogb.gen02_ogb = g_oga[l_ac_oga].gen02_oga
            LET g_head_ogb.ogaconf_ogb = g_oga[l_ac_oga].ogaconf
            LET g_head_ogb.ogapost_ogb = g_oga[l_ac_oga].ogapost
            LET g_b_flag3 = 2
            LET g_action_choice = "ogb"
         END IF
         EXIT DIALOG
      ON ACTION so
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION wo
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION sho
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "ogab"
         EXIT DIALOG
      ON ACTION misc
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "ina"
         EXIT DIALOG    
      ON ACTION qs
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "ogac"
         EXIT DIALOG  
      ON ACTION qt
         LET g_b_flag2 = 9
         LET g_b_flag3 = 1
         LET g_action_choice = "ogad"
         EXIT DIALOG    
      ON ACTION xt
         LET g_b_flag2 = 10
         LET g_b_flag3 = 1
         LET g_action_choice = "oha"
         EXIT DIALOG     
      ON ACTION ys
         LET g_b_flag2 = 11
         LET g_b_flag3 = 1
         LET g_action_choice = "oma"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp_ogb()
   LET g_action_choice = " "
   DISPLAY g_rec_b_ogb TO FORMONLY.cn2
   DISPLAY g_head_ogb.oga01_ogb TO FORMONLY.oga01_ogb
   DISPLAY g_head_ogb.oga02_ogb TO FORMONLY.oga02_ogb
   DISPLAY g_head_ogb.oga03_ogb TO FORMONLY.oga03_ogb
   DISPLAY g_head_ogb.oga032_ogb TO FORMONLY.oga032_ogb
   DISPLAY g_head_ogb.oga14_ogb TO FORMONLY.oga14_ogb
   DISPLAY g_head_ogb.gen02_ogb TO FORMONLY.gen02_ogb
   DISPLAY g_head_ogb.ogaconf_ogb TO FORMONLY.ogaconf_ogb
   DISPLAY g_head_ogb.ogapost_ogb TO FORMONLY.ogapost_ogb
      CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ogb TO s_ogb.* ATTRIBUTE(COUNT=g_rec_b_ogb)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_ogb TO s_ogb.* ATTRIBUTE(COUNT=g_rec_b_ogb)

      BEFORE DISPLAY
         IF l_ac_ogb != 0 THEN
            CALL fgl_set_arr_curr(l_ac_ogb)
         END IF

      BEFORE ROW
        LET l_ac_ogb = ARR_CURR()
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
      ON ACTION oga
         LET g_b_flag3 = 1
         LET g_action_choice = "oga"
         EXIT DIALOG
      ON ACTION so
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION wo
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION sho
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "ogab"
         EXIT DIALOG
      ON ACTION misc
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "ina"
         EXIT DIALOG
      ON ACTION qs
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "ogac"
         EXIT DIALOG  
      ON ACTION qt
         LET g_b_flag2 = 9
         LET g_b_flag3 = 1
         LET g_action_choice = "ogad"
         EXIT DIALOG    
      ON ACTION xt
         LET g_b_flag2 = 10
         LET g_b_flag3 = 1
         LET g_action_choice = "oha"
         EXIT DIALOG
      ON ACTION ys
         LET g_b_flag2 = 11
         LET g_b_flag3 = 1
         LET g_action_choice = "oma"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp_ogab()
   LET g_action_choice = " "
   DISPLAY g_rec_b_ogab TO FORMONLY.cn2
      CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_oea01_change_ogbb = '1' THEN
      LET g_oea01_change_ogbb = '0' 
      CALL cl_set_comp_visible("page21_1", FALSE)
      CALL  g_ogbb.clear()   
      INITIALIZE g_head_ogbb.* TO NULL
      LET g_rec_b_ogbb = ''
      DISPLAY g_rec_b_ogbb TO FORMONLY.cn2
      DISPLAY g_head_ogbb.oga01_ogbb TO FORMONLY.oga01_ogbb
      DISPLAY g_head_ogbb.oga02_ogbb TO FORMONLY.oga02_ogbb
      DISPLAY g_head_ogbb.oga03_ogbb TO FORMONLY.oga03_ogbb
      DISPLAY g_head_ogbb.oga032_ogbb TO FORMONLY.oga032_ogbb
      DISPLAY g_head_ogbb.oga14_ogbb TO FORMONLY.oga14_ogbb
      DISPLAY g_head_ogbb.gen02_ogbb TO FORMONLY.gen02_ogbb
      DISPLAY g_head_ogbb.ogaconf_ogbb TO FORMONLY.ogaconf_ogbb
      DISPLAY g_head_ogbb.ogapost_ogbb TO FORMONLY.ogapost_ogbb 
      DISPLAY ARRAY g_ogbb TO s_ogbb.* ATTRIBUTE(COUNT=g_rec_b_ogbb)
         BEFORE DISPLAY
            EXIT DISPLAY 
      END DISPLAY
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page21_1", TRUE)
   END IF
   DISPLAY ARRAY g_ogab TO s_ogab.* ATTRIBUTE(COUNT=g_rec_b_ogab)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_ogab TO s_ogab.* ATTRIBUTE(COUNT=g_rec_b_ogab)

      BEFORE DISPLAY
         IF l_ac_ogab != 0 THEN
            CALL fgl_set_arr_curr(l_ac_ogab)
         END IF

      BEFORE ROW
        LET l_ac_ogab = ARR_CURR()
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
      ON ACTION ogbb
         LET l_ac_ogab = ARR_CURR()
         IF l_ac_ogab > 0 THEN
            LET g_head_ogbb.oga01_ogbb = g_ogab[l_ac_ogab].oga01b
            LET g_head_ogbb.oga02_ogbb = g_ogab[l_ac_ogab].oga02b
            LET g_head_ogbb.oga03_ogbb = g_ogab[l_ac_ogab].oga03b
            LET g_head_ogbb.oga032_ogbb = g_ogab[l_ac_ogab].oga032b
            LET g_head_ogbb.oga14_ogbb = g_ogab[l_ac_ogab].oga14b
            LET g_head_ogbb.gen02_ogbb = g_ogab[l_ac_ogab].gen02_ogab
            LET g_head_ogbb.ogaconf_ogbb = g_ogab[l_ac_ogab].ogaconfb
            LET g_head_ogbb.ogapost_ogbb = g_ogab[l_ac_ogab].ogapostb
            LET g_b_flag3 = 2
            LET g_action_choice = "ogbb"
         END IF
         EXIT DIALOG
      ON ACTION so
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION wo
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION sn
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "oga"
         EXIT DIALOG
      ON ACTION misc
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "ina"
         EXIT DIALOG   
      ON ACTION qs
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "ogac"
         EXIT DIALOG  
      ON ACTION qt
         LET g_b_flag2 = 9
         LET g_b_flag3 = 1
         LET g_action_choice = "ogad"
         EXIT DIALOG    
      ON ACTION xt
         LET g_b_flag2 = 10
         LET g_b_flag3 = 1
         LET g_action_choice = "oha"
         EXIT DIALOG    
      ON ACTION ys
         LET g_b_flag2 = 11
         LET g_b_flag3 = 1
         LET g_action_choice = "oma"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp_ogbb()
   LET g_action_choice = " "
   DISPLAY g_rec_b_ogbb TO FORMONLY.cn2
   DISPLAY g_head_ogbb.oga01_ogbb TO FORMONLY.oga01_ogbb
   DISPLAY g_head_ogbb.oga02_ogbb TO FORMONLY.oga02_ogbb
   DISPLAY g_head_ogbb.oga03_ogbb TO FORMONLY.oga03_ogbb
   DISPLAY g_head_ogbb.oga032_ogbb TO FORMONLY.oga032_ogbb
   DISPLAY g_head_ogbb.oga14_ogbb TO FORMONLY.oga14_ogbb
   DISPLAY g_head_ogbb.gen02_ogbb TO FORMONLY.gen02_ogbb
   DISPLAY g_head_ogbb.ogaconf_ogbb TO FORMONLY.ogaconf_ogbb
   DISPLAY g_head_ogbb.ogapost_ogbb TO FORMONLY.ogapost_ogbb
      CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ogbb TO s_ogbb.* ATTRIBUTE(COUNT=g_rec_b_ogbb)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_ogbb TO s_ogbb.* ATTRIBUTE(COUNT=g_rec_b_ogbb)

      BEFORE DISPLAY
         IF l_ac_ogbb != 0 THEN
            CALL fgl_set_arr_curr(l_ac_ogbb)
         END IF

      BEFORE ROW
        LET l_ac_ogbb = ARR_CURR()
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
      ON ACTION ogab
         LET g_b_flag3 = 1
         LET g_action_choice = "ogab"
         EXIT DIALOG
      ON ACTION so
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION wo
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION sn
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "oga"
         EXIT DIALOG
      ON ACTION misc
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "ina"
         EXIT DIALOG
      ON ACTION qs
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "ogac"
         EXIT DIALOG  
      ON ACTION qt
         LET g_b_flag2 = 9
         LET g_b_flag3 = 1
         LET g_action_choice = "ogad"
         EXIT DIALOG    
      ON ACTION xt
         LET g_b_flag2 = 10
         LET g_b_flag3 = 1
         LET g_action_choice = "oha"
         EXIT DIALOG
      ON ACTION ys
         LET g_b_flag2 = 11
         LET g_b_flag3 = 1
         LET g_action_choice = "oma"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp_ina()
   LET g_action_choice = " "
   DISPLAY g_rec_b_ina TO FORMONLY.cn2
      CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_oea01_change_inb = '1' THEN
      LET g_oea01_change_inb = '0' 
      CALL cl_set_comp_visible("page28", FALSE)
      CALL  g_inb.clear()   
      INITIALIZE g_head_inb.* TO NULL
      LET g_rec_b_inb = ''
      DISPLAY g_rec_b_inb TO FORMONLY.cn2
      DISPLAY g_head_inb.ina00_inb TO FORMONLY.ina00_inb
      DISPLAY g_head_inb.ina01_inb TO FORMONLY.ina01_inb
      DISPLAY g_head_inb.ina11_inb TO FORMONLY.ina11_inb
      DISPLAY g_head_inb.gen02_inb TO FORMONLY.gen02_inb
      DISPLAY g_head_inb.ina04_inb TO FORMONLY.ina04_inb
      DISPLAY g_head_inb.gem02_inb TO FORMONLY.gem02_inb
      DISPLAY g_head_inb.ina02_inb TO FORMONLY.ina02_inb
      DISPLAY g_head_inb.ina03_inb TO FORMONLY.ina03_inb
      DISPLAY g_head_inb.inaconf_inb TO FORMONLY.inaconf_inb
      DISPLAY g_head_inb.inapost_inb TO FORMONLY.inapost_inb
      DISPLAY ARRAY g_inb TO s_inb.* ATTRIBUTE(COUNT=g_rec_b_inb)
         BEFORE DISPLAY
            EXIT DISPLAY 
      END DISPLAY
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page28", TRUE)
   END IF
   DISPLAY ARRAY g_ina TO s_ina.* ATTRIBUTE(COUNT=g_rec_b_ina)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_ina TO s_ina.* ATTRIBUTE(COUNT=g_rec_b_ina)

      BEFORE DISPLAY
         IF l_ac_ina != 0 THEN
            CALL fgl_set_arr_curr(l_ac_ina)
         END IF

      BEFORE ROW
        LET l_ac_ina = ARR_CURR()
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
      ON ACTION inb
         LET l_ac_ina = ARR_CURR()
         IF l_ac_ina > 0 THEN
            LET g_head_inb.ina00_inb = g_ina[l_ac_ina].ina00
            LET g_head_inb.ina01_inb = g_ina[l_ac_ina].ina01
            LET g_head_inb.ina11_inb = g_ina[l_ac_ina].ina11
            LET g_head_inb.gen02_inb = g_ina[l_ac_ina].gen02_ina
            LET g_head_inb.ina04_inb = g_ina[l_ac_ina].ina04
            LET g_head_inb.gem02_inb = g_ina[l_ac_ina].gem02_ina
            LET g_head_inb.ina02_inb = g_ina[l_ac_ina].ina02
            LET g_head_inb.ina03_inb = g_ina[l_ac_ina].ina03
            LET g_head_inb.inaconf_inb = g_ina[l_ac_ina].inaconf
            LET g_head_inb.inapost_inb = g_ina[l_ac_ina].inapost
            LET g_b_flag3 = 2
            LET g_action_choice = "inb"
         END IF
         EXIT DIALOG
      ON ACTION so
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION wo
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION sn
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "oga"
         EXIT DIALOG
      ON ACTION sho
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "ogab"
         EXIT DIALOG    
      ON ACTION qs
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "ogac"
         EXIT DIALOG  
      ON ACTION qt
         LET g_b_flag2 = 9
         LET g_b_flag3 = 1
         LET g_action_choice = "ogad"
         EXIT DIALOG    
      ON ACTION xt
         LET g_b_flag2 = 10
         LET g_b_flag3 = 1
         LET g_action_choice = "oha"
         EXIT DIALOG    
      ON ACTION ys
         LET g_b_flag2 = 11
         LET g_b_flag3 = 1
         LET g_action_choice = "oma"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp_inb()
   LET g_action_choice = " "
   DISPLAY g_rec_b_inb TO FORMONLY.cn2
   DISPLAY g_head_inb.ina00_inb TO FORMONLY.ina00_inb
   DISPLAY g_head_inb.ina01_inb TO FORMONLY.ina01_inb
   DISPLAY g_head_inb.ina11_inb TO FORMONLY.ina11_inb
   DISPLAY g_head_inb.gen02_inb TO FORMONLY.gen02_inb
   DISPLAY g_head_inb.ina04_inb TO FORMONLY.ina04_inb
   DISPLAY g_head_inb.gem02_inb TO FORMONLY.gem02_inb
   DISPLAY g_head_inb.ina02_inb TO FORMONLY.ina02_inb
   DISPLAY g_head_inb.ina03_inb TO FORMONLY.ina03_inb
   DISPLAY g_head_inb.inaconf_inb TO FORMONLY.inaconf_inb
   DISPLAY g_head_inb.inapost_inb TO FORMONLY.inapost_inb
      CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_inb TO s_inb.* ATTRIBUTE(COUNT=g_rec_b_inb)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_inb TO s_inb.* ATTRIBUTE(COUNT=g_rec_b_inb)

      BEFORE DISPLAY
         IF l_ac_inb != 0 THEN
            CALL fgl_set_arr_curr(l_ac_inb)
         END IF

      BEFORE ROW
        LET l_ac_inb = ARR_CURR()
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
      ON ACTION ina
         LET g_b_flag3 = 1
         LET g_action_choice = "ina"
         EXIT DIALOG
      ON ACTION so
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION wo
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION sn
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "oga"
         EXIT DIALOG
      ON ACTION sho
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "ogab"
         EXIT DIALOG   
      ON ACTION qs
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "ogac"
         EXIT DIALOG  
      ON ACTION qt
         LET g_b_flag2 = 9
         LET g_b_flag3 = 1
         LET g_action_choice = "ogad"
         EXIT DIALOG    
      ON ACTION xt
         LET g_b_flag2 = 10
         LET g_b_flag3 = 1
         LET g_action_choice = "oha"
         EXIT DIALOG      
      ON ACTION ys
         LET g_b_flag2 = 11
         LET g_b_flag3 = 1
         LET g_action_choice = "oma"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp_ogac()
   LET g_action_choice = " "
   DISPLAY g_rec_b_ogac TO FORMONLY.cn2
      CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_oea01_change_ogbc = '1' THEN
      LET g_oea01_change_ogbc = '0' 
      CALL cl_set_comp_visible("page21_2", FALSE)
      CALL  g_ogbc.clear()
      INITIALIZE g_head_ogbc.* TO NULL 
      DISPLAY g_head_ogbc.oga01_ogbc TO FORMONLY.oga01_ogbc
      DISPLAY g_head_ogbc.oga02_ogbc TO FORMONLY.oga02_ogbc
      DISPLAY g_head_ogbc.oga03_ogbc TO FORMONLY.oga03_ogbc
      DISPLAY g_head_ogbc.oga032_ogbc TO FORMONLY.oga032_ogbc
      DISPLAY g_head_ogbc.oga14_ogbc TO FORMONLY.oga14_ogbc
      DISPLAY g_head_ogbc.gen02_ogbc TO FORMONLY.gen02_ogbc
      DISPLAY g_head_ogbc.ogaconf_ogbc TO FORMONLY.ogaconf_ogbc
      DISPLAY g_head_ogbc.ogapost_ogbc TO FORMONLY.ogapost_ogbc
      DISPLAY ARRAY g_ogbc TO s_ogbc.* ATTRIBUTE(COUNT=g_rec_b_ogbc)
         BEFORE DISPLAY
            EXIT DISPLAY 
      END DISPLAY
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page21_2", TRUE)
   END IF
   DISPLAY ARRAY g_ogac TO s_ogac.* ATTRIBUTE(COUNT=g_rec_b_ogac)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_ogac TO s_ogac.* ATTRIBUTE(COUNT=g_rec_b_ogac)

      BEFORE DISPLAY
         IF l_ac_ogac != 0 THEN
            CALL fgl_set_arr_curr(l_ac_ogac)
         END IF

      BEFORE ROW
        LET l_ac_ogac = ARR_CURR()
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
      ON ACTION ogbc
         LET l_ac_ogac = ARR_CURR()
         IF l_ac_ogac > 0 THEN
            LET g_head_ogbc.oga01_ogbc = g_ogac[l_ac_ogac].oga01c
            LET g_head_ogbc.oga02_ogbc = g_ogac[l_ac_ogac].oga02c
            LET g_head_ogbc.oga03_ogbc = g_ogac[l_ac_ogac].oga03c
            LET g_head_ogbc.oga032_ogbc = g_ogac[l_ac_ogac].oga032c
            LET g_head_ogbc.oga14_ogbc = g_ogac[l_ac_ogac].oga14c
            LET g_head_ogbc.gen02_ogbc = g_ogac[l_ac_ogac].gen02_ogac
            LET g_head_ogbc.ogaconf_ogbc = g_ogac[l_ac_ogac].ogaconfc
            LET g_head_ogbc.ogapost_ogbc = g_ogac[l_ac_ogac].ogapostc
            LET g_b_flag3 = 2
            LET g_action_choice = "ogbc"
         END IF
         EXIT DIALOG
      ON ACTION so
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION wo
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION sn
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "oga"
         EXIT DIALOG
      ON ACTION sho
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "ogab"
         EXIT DIALOG
      ON ACTION misc
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "ina"
         EXIT DIALOG    
      ON ACTION qt
         LET g_b_flag2 = 9
         LET g_b_flag3 = 1
         LET g_action_choice = "ogad"
         EXIT DIALOG    
      ON ACTION xt
         LET g_b_flag2 = 10
         LET g_b_flag3 = 1
         LET g_action_choice = "oha"
         EXIT DIALOG  
      ON ACTION ys
         LET g_b_flag2 = 11
         LET g_b_flag3 = 1
         LET g_action_choice = "oma"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp_ogbc()
   LET g_action_choice = " "
   DISPLAY g_rec_b_ogbc TO FORMONLY.cn2
   DISPLAY g_head_ogbc.oga01_ogbc TO FORMONLY.oga01_ogbc
   DISPLAY g_head_ogbc.oga02_ogbc TO FORMONLY.oga02_ogbc
   DISPLAY g_head_ogbc.oga03_ogbc TO FORMONLY.oga03_ogbc
   DISPLAY g_head_ogbc.oga032_ogbc TO FORMONLY.oga032_ogbc
   DISPLAY g_head_ogbc.oga14_ogbc TO FORMONLY.oga14_ogbc
   DISPLAY g_head_ogbc.gen02_ogbc TO FORMONLY.gen02_ogbc
   DISPLAY g_head_ogbc.ogaconf_ogbc TO FORMONLY.ogaconf_ogbc
   DISPLAY g_head_ogbc.ogapost_ogbc TO FORMONLY.ogapost_ogbc
      CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ogbc TO s_ogbc.* ATTRIBUTE(COUNT=g_rec_b_ogbc)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_ogbc TO s_ogbc.* ATTRIBUTE(COUNT=g_rec_b_ogbc)

      BEFORE DISPLAY
         IF l_ac_ogbc != 0 THEN
            CALL fgl_set_arr_curr(l_ac_ogbc)
         END IF

      BEFORE ROW
        LET l_ac_ogbc = ARR_CURR()
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
      ON ACTION ogac
         LET g_b_flag3 = 1
         LET g_action_choice = "ogac"
         EXIT DIALOG
      ON ACTION so
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION wo
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION sn
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "oga"
         EXIT DIALOG
      ON ACTION sho
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "ogab"
         EXIT DIALOG
      ON ACTION misc
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "ina"
         EXIT DIALOG 
      ON ACTION qt
         LET g_b_flag2 = 9
         LET g_b_flag3 = 1
         LET g_action_choice = "ogad"
         EXIT DIALOG    
      ON ACTION xt
         LET g_b_flag2 = 10
         LET g_b_flag3 = 1
         LET g_action_choice = "oha"
         EXIT DIALOG
      ON ACTION ys
         LET g_b_flag2 = 11
         LET g_b_flag3 = 1
         LET g_action_choice = "oma"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp_ogad()
   LET g_action_choice = " "
   DISPLAY g_rec_b_ogad TO FORMONLY.cn2
      CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_oea01_change_ogbd = '1' THEN
      LET g_oea01_change_ogbd = '0' 
      CALL cl_set_comp_visible("page21_3", FALSE)
      CALL  g_ogbd.clear()   
      INITIALIZE g_head_ogbd.* TO NULL
      LET g_rec_b_ogbd = ''
      DISPLAY g_rec_b_ogbd TO FORMONLY.cn2
      DISPLAY g_head_ogbd.oga01_ogbd TO FORMONLY.oga01_ogbd
      DISPLAY g_head_ogbd.oga02_ogbd TO FORMONLY.oga02_ogbd
      DISPLAY g_head_ogbd.oga03_ogbd TO FORMONLY.oga03_ogbd
      DISPLAY g_head_ogbd.oga032_ogbd TO FORMONLY.oga032_ogbd
#     DISPLAY g_head_ogbd.oga14_ogbd TO FORMONLY.oga14_ogbd
#     DISPLAY g_head_ogbd.gen02_ogbd TO FORMONLY.gen02_ogbd
      DISPLAY g_head_ogbd.ogaconf_ogbd TO FORMONLY.ogaconf_ogbd
      DISPLAY g_head_ogbd.ogapost_ogbd TO FORMONLY.ogapost_ogbd
      DISPLAY ARRAY g_ogbd TO s_ogbd.* ATTRIBUTE(COUNT=g_rec_b_ogbd)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page21_3", TRUE)
   END IF
   DISPLAY ARRAY g_ogad TO s_ogad.* ATTRIBUTE(COUNT=g_rec_b_ogad)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_ogad TO s_ogad.* ATTRIBUTE(COUNT=g_rec_b_ogad)

      BEFORE DISPLAY
         IF l_ac_ogad != 0 THEN
            CALL fgl_set_arr_curr(l_ac_ogad)
         END IF

      BEFORE ROW
        LET l_ac_ogad = ARR_CURR()
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
      ON ACTION ogbd
         LET l_ac_ogad = ARR_CURR()
         IF l_ac_ogad > 0 THEN
            LET g_head_ogbd.oga01_ogbd = g_ogad[l_ac_ogad].oga01d
            LET g_head_ogbd.oga02_ogbd = g_ogad[l_ac_ogad].oga02d
            LET g_head_ogbd.oga03_ogbd = g_ogad[l_ac_ogad].oga03d
            LET g_head_ogbd.oga032_ogbd = g_ogad[l_ac_ogad].oga032d
#           LET g_head_ogbd.oga14_ogbd = g_ogad[l_ac_ogad].oga14d
#           LET g_head_ogbd.gen02_ogbd = g_ogad[l_ac_ogad].gen02_ogad
            LET g_head_ogbd.ogaconf_ogbd = g_ogad[l_ac_ogad].ogaconfd
            LET g_head_ogbd.ogapost_ogbd = g_ogad[l_ac_ogad].ogapostd
            LET g_b_flag3 = 2
            LET g_action_choice = "ogbd"
         END IF
         EXIT DIALOG
      ON ACTION so
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION wo
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION sn
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "oga"
         EXIT DIALOG
      ON ACTION sho
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "ogab"
         EXIT DIALOG
      ON ACTION misc
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "ina"
         EXIT DIALOG  
      ON ACTION qs
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "ogac"
         EXIT DIALOG       
      ON ACTION xt
         LET g_b_flag2 = 10
         LET g_b_flag3 = 1
         LET g_action_choice = "oha"
         EXIT DIALOG      
      ON ACTION ys
         LET g_b_flag2 = 11
         LET g_b_flag3 = 1
         LET g_action_choice = "oma"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION q001_bp_ogbd()
   LET g_action_choice = " "
   DISPLAY g_rec_b_ogbd TO FORMONLY.cn2
   DISPLAY g_head_ogbd.oga01_ogbd TO FORMONLY.oga01_ogbd
   DISPLAY g_head_ogbd.oga02_ogbd TO FORMONLY.oga02_ogbd
   DISPLAY g_head_ogbd.oga03_ogbd TO FORMONLY.oga03_ogbd
   DISPLAY g_head_ogbd.oga032_ogbd TO FORMONLY.oga032_ogbd
#  DISPLAY g_head_ogbd.oga14_ogbd TO FORMONLY.oga14_ogbd
#  DISPLAY g_head_ogbd.gen02_ogbd TO FORMONLY.gen02_ogbd
   DISPLAY g_head_ogbd.ogaconf_ogbd TO FORMONLY.ogaconf_ogbd
   DISPLAY g_head_ogbd.ogapost_ogbd TO FORMONLY.ogapost_ogbd
      CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ogbd TO s_ogbd.* ATTRIBUTE(COUNT=g_rec_b_ogbd)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_ogbd TO s_ogbd.* ATTRIBUTE(COUNT=g_rec_b_ogbd)

      BEFORE DISPLAY
         IF l_ac_ogbd != 0 THEN
            CALL fgl_set_arr_curr(l_ac_ogbd)
         END IF

      BEFORE ROW
        LET l_ac_ogbd = ARR_CURR()
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
      ON ACTION ogad
         LET g_b_flag3 = 1
         LET g_action_choice = "ogad"
         EXIT DIALOG
      ON ACTION so
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION wo
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION sn
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "oga"
         EXIT DIALOG
      ON ACTION sho
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "ogab"
         EXIT DIALOG
      ON ACTION misc
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "ina"
         EXIT DIALOG 
      ON ACTION qs
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "ogac"
         EXIT DIALOG 
      ON ACTION xt
         LET g_b_flag2 = 10
         LET g_b_flag3 = 1
         LET g_action_choice = "oha"
         EXIT DIALOG
      ON ACTION ys
         LET g_b_flag2 = 11
         LET g_b_flag3 = 1
         LET g_action_choice = "oma"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp_oha()
   LET g_action_choice = " "
   DISPLAY g_rec_b_oha TO FORMONLY.cn2
      CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_oea01_change_ohb = '1' THEN
      LET g_oea01_change_ohb = '0' 
      CALL cl_set_comp_visible("page21_4", FALSE)
      CALL  g_ohb.clear()   
      INITIALIZE g_head_ohb.* TO NULL
      LET g_rec_b_ohb = ''
      DISPLAY g_rec_b_ohb TO FORMONLY.cn2
      DISPLAY g_head_ohb.oha01_ohb TO FORMONLY.oha01_ohb
      DISPLAY g_head_ohb.oha02_ohb TO FORMONLY.oha02_ohb
      DISPLAY g_head_ohb.oha05_ohb TO FORMONLY.oha05_ohb
      DISPLAY g_head_ohb.oha03_ohb TO FORMONLY.oha03_ohb
      DISPLAY g_head_ohb.oha032_ohb TO FORMONLY.oha032_ohb
      DISPLAY g_head_ohb.oha14_ohb TO FORMONLY.oha14_ohb
      DISPLAY g_head_ohb.gen02_ohb TO FORMONLY.gen02_ohb
      DISPLAY g_head_ohb.ohaconf_ohb TO FORMONLY.ohaconf_ohb
      DISPLAY g_head_ohb.ohapost_ohb TO FORMONLY.ohapost_ohb
      DISPLAY ARRAY g_ohb TO s_ohb.* ATTRIBUTE(COUNT=g_rec_b_ohb)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page21_4", TRUE)
   END IF
   DISPLAY ARRAY g_oha TO s_oha.* ATTRIBUTE(COUNT=g_rec_b_oha)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_oha TO s_oha.* ATTRIBUTE(COUNT=g_rec_b_oha)

      BEFORE DISPLAY
         IF l_ac_oha != 0 THEN
            CALL fgl_set_arr_curr(l_ac_oha)
         END IF

      BEFORE ROW
        LET l_ac_oha = ARR_CURR()
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
      ON ACTION ohb
         LET l_ac_oha = ARR_CURR()
         IF l_ac_oha > 0 THEN
            LET g_head_ohb.oha01_ohb = g_oha[l_ac_oha].oha01
            LET g_head_ohb.oha02_ohb = g_oha[l_ac_oha].oha02
            LET g_head_ohb.oha05_ohb = g_oha[l_ac_oha].oha05
            LET g_head_ohb.oha03_ohb = g_oha[l_ac_oha].oha03
            LET g_head_ohb.oha032_ohb = g_oha[l_ac_oha].oha032
            LET g_head_ohb.oha14_ohb = g_oha[l_ac_oha].oha14
            LET g_head_ohb.gen02_ohb = g_oha[l_ac_oha].gen02_oha
            LET g_head_ohb.ohaconf_ohb = g_oha[l_ac_oha].ohaconf
            LET g_head_ohb.ohapost_ohb = g_oha[l_ac_oha].ohapost
            LET g_b_flag3 = 2
            LET g_action_choice = "ohb"
         END IF
         EXIT DIALOG
      ON ACTION so
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION wo
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION sn
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "oga"
         EXIT DIALOG
      ON ACTION sho
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "ogab"
         EXIT DIALOG
      ON ACTION misc
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "ina"
         EXIT DIALOG 
      ON ACTION qs
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "ogac"
         EXIT DIALOG  
      ON ACTION qt
         LET g_b_flag2 = 9
         LET g_b_flag3 = 1
         LET g_action_choice = "ogad"
         EXIT DIALOG  
      ON ACTION ys
         LET g_b_flag2 = 11
         LET g_b_flag3 = 1
         LET g_action_choice = "oma"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp_ohb()
   LET g_action_choice = " "
   DISPLAY g_rec_b_ohb TO FORMONLY.cn2
   DISPLAY g_head_ohb.oha01_ohb TO FORMONLY.oha01_ohb
   DISPLAY g_head_ohb.oha02_ohb TO FORMONLY.oha02_ohb
   DISPLAY g_head_ohb.oha05_ohb TO FORMONLY.oha05_ohb
   DISPLAY g_head_ohb.oha03_ohb TO FORMONLY.oha03_ohb
   DISPLAY g_head_ohb.oha032_ohb TO FORMONLY.oha032_ohb
   DISPLAY g_head_ohb.oha14_ohb TO FORMONLY.oha14_ohb
   DISPLAY g_head_ohb.gen02_ohb TO FORMONLY.gen02_ohb
   DISPLAY g_head_ohb.ohaconf_ohb TO FORMONLY.ohaconf_ohb
   DISPLAY g_head_ohb.ohapost_ohb TO FORMONLY.ohapost_ohb
      CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ohb TO s_ohb.* ATTRIBUTE(COUNT=g_rec_b_ohb)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_ohb TO s_ohb.* ATTRIBUTE(COUNT=g_rec_b_ohb)

      BEFORE DISPLAY
         IF l_ac_ohb != 0 THEN
            CALL fgl_set_arr_curr(l_ac_ohb)
         END IF

      BEFORE ROW
        LET l_ac_ohb = ARR_CURR()
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
     ON ACTION oha
        LET g_b_flag3 = 1
        LET g_action_choice = "oha"
        EXIT DIALOG
      ON ACTION so
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION wo
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION sn
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "oga"
         EXIT DIALOG
      ON ACTION sho
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "ogab"
         EXIT DIALOG
      ON ACTION misc
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "ina"
         EXIT DIALOG 
      ON ACTION qs
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "ogac"
         EXIT DIALOG 
      ON ACTION qt
         LET g_b_flag2 = 9
         LET g_b_flag3 = 1
         LET g_action_choice = "ogad"
         EXIT DIALOG 
      ON ACTION ys
         LET g_b_flag2 = 11
         LET g_b_flag3 = 1
         LET g_action_choice = "oma"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp_oma()
   LET g_action_choice = " "
   DISPLAY g_rec_b_oma TO FORMONLY.cn2
      CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_oea01_change_omb = '1' THEN
      LET g_oea01_change_omb = '0' 
      CALL cl_set_comp_visible("page19", FALSE)
      CALL  g_omb.clear()   
      INITIALIZE g_head_omb.* TO NULL
      LET g_rec_b_omb = ''
      DISPLAY g_rec_b_omb TO FORMONLY.cn2
      DISPLAY g_head_omb.oma01_omb TO FORMONLY.oma01_omb
      DISPLAY g_head_omb.oma02_omb TO FORMONLY.oma02_omb
      DISPLAY g_head_omb.oma70_omb TO FORMONLY.oma70_omb
      DISPLAY g_head_omb.oma03_omb TO FORMONLY.oma03_omb
      DISPLAY g_head_omb.oma032_omb TO FORMONLY.oma032_omb
      DISPLAY g_head_omb.omaconf_omb TO FORMONLY.omaconf_omb
      DISPLAY g_head_omb.omavoid_omb TO FORMONLY.omavoid_omb
      DISPLAY g_head_omb.omamksg_omb TO FORMONLY.omamksg_omb
      DISPLAY ARRAY g_omb TO s_omb.* ATTRIBUTE(COUNT=g_rec_b_omb)
         BEFORE DISPLAY
            EXIT DISPLAY 
      END DISPLAY
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page19", TRUE)
   END IF
   DISPLAY ARRAY g_oma TO s_oma.* ATTRIBUTE(COUNT=g_rec_b_oma)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_oma TO s_oma.* ATTRIBUTE(COUNT=g_rec_b_oma)

      BEFORE DISPLAY
         IF l_ac_oma != 0 THEN
            CALL fgl_set_arr_curr(l_ac_oma)
         END IF

      BEFORE ROW
        LET l_ac_oma = ARR_CURR()
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
      ON ACTION omb
         LET l_ac_oma = ARR_CURR()
         IF l_ac_oma > 0 THEN
            LET g_head_omb.oma01_omb = g_oma[l_ac_oma].oma01
            LET g_head_omb.oma02_omb = g_oma[l_ac_oma].oma02
            LET g_head_omb.oma70_omb = g_oma[l_ac_oma].oma70
            LET g_head_omb.oma03_omb = g_oma[l_ac_oma].oma03
            LET g_head_omb.oma032_omb = g_oma[l_ac_oma].oma032
            LET g_head_omb.omaconf_omb = g_oma[l_ac_oma].omaconf
            LET g_head_omb.omavoid_omb = g_oma[l_ac_oma].omavoid
            LET g_head_omb.omamksg_omb = g_oma[l_ac_oma].omamksg
            LET g_b_flag3 = 2
            LET g_action_choice = "omb"
         END IF
         EXIT DIALOG
      ON ACTION so
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION wo
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION sn
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "oga"
         EXIT DIALOG
      ON ACTION sho
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "ogab"
         EXIT DIALOG
      ON ACTION misc
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "ina"
         EXIT DIALOG 
      ON ACTION qs
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "ogac"
         EXIT DIALOG  
      ON ACTION qt
         LET g_b_flag2 = 9
         LET g_b_flag3 = 1
         LET g_action_choice = "ogad"
         EXIT DIALOG  
      ON ACTION xt
         LET g_b_flag2 = 10
         LET g_b_flag3 = 1
         LET g_action_choice = "oha"
         EXIT DIALOG 

      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_bp_omb()
   LET g_action_choice = " "
   DISPLAY g_rec_b_omb TO FORMONLY.cn2
   DISPLAY g_head_omb.oma01_omb TO FORMONLY.oma01_omb
   DISPLAY g_head_omb.oma02_omb TO FORMONLY.oma02_omb
   DISPLAY g_head_omb.oma70_omb TO FORMONLY.oma70_omb
   DISPLAY g_head_omb.oma03_omb TO FORMONLY.oma03_omb
   DISPLAY g_head_omb.oma032_omb TO FORMONLY.oma032_omb
   DISPLAY g_head_omb.omaconf_omb TO FORMONLY.omaconf_omb
   DISPLAY g_head_omb.omavoid_omb TO FORMONLY.omavoid_omb
   DISPLAY g_head_omb.omamksg_omb TO FORMONLY.omamksg_omb
      CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_omb TO s_omb.* ATTRIBUTE(COUNT=g_rec_b_omb)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY
DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h
      FROM a,b,c,d,e,f,g,h ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE a
         IF NOT cl_null(tm.a)  THEN 
            CALL q001_b_fill_2()
            CALL q001_set_visible()
            CALL cl_set_comp_visible("page1,page3", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page1,page3", TRUE)
            LET g_action_choice = "page2"
         ELSE
            CALL q001_b_fill()
            CALL g_oea_1.clear()
            DISPLAY 0 TO FORMONLY.cnt1
         END IF
         DISPLAY BY NAME tm.a
         EXIT DIALOG
      ON CHANGE b,c,d,e,f,g,h
         CALL q001()
         CALL q001_b_fill()
         CALL q001_b_fill_2()
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2,page3", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG
   END INPUT
   DISPLAY ARRAY g_omb TO s_omb.* ATTRIBUTE(COUNT=g_rec_b_omb)

      BEFORE DISPLAY
         IF l_ac_omb != 0 THEN
            CALL fgl_set_arr_curr(l_ac_omb)
         END IF

      BEFORE ROW
        LET l_ac_omb = ARR_CURR()
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
     ON ACTION oma
        LET g_b_flag3 = 1
        LET g_action_choice = "oma"
        EXIT DIALOG
      ON ACTION so
         LET g_b_flag2 = 1
         LET g_b_flag3 = 1
         LET g_action_choice = "oeb"
         EXIT DIALOG
      ON ACTION pr
         LET g_b_flag2 = 2
         LET g_b_flag3 = 1
         LET g_action_choice = "pmk"
         EXIT DIALOG
      ON ACTION po
         LET g_b_flag2 = 3
         LET g_b_flag3 = 1
         LET g_action_choice = "pmm"
         EXIT DIALOG
      ON ACTION wo
         LET g_b_flag2 = 4
         LET g_b_flag3 = 1
         LET g_action_choice = "sfb"
         EXIT DIALOG
      ON ACTION sn
         LET g_b_flag2 = 5
         LET g_b_flag3 = 1
         LET g_action_choice = "oga"
         EXIT DIALOG
      ON ACTION sho
         LET g_b_flag2 = 6
         LET g_b_flag3 = 1
         LET g_action_choice = "ogab"
         EXIT DIALOG
      ON ACTION misc
         LET g_b_flag2 = 7
         LET g_b_flag3 = 1
         LET g_action_choice = "ina"
         EXIT DIALOG 
      ON ACTION qs
         LET g_b_flag2 = 8
         LET g_b_flag3 = 1
         LET g_action_choice = "ogac"
         EXIT DIALOG 
      ON ACTION qt
         LET g_b_flag2 = 9
         LET g_b_flag3 = 1
         LET g_action_choice = "ogad"
         EXIT DIALOG 
      ON ACTION xt
         LET g_b_flag2 = 10
         LET g_b_flag3 = 1
         LET g_action_choice = "oha"
         EXIT DIALOG
      AFTER DIALOG
         CONTINUE DIALOG
END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q001_tmp_wc2()
DEFINE l_wc    STRING

   LET l_wc = ''
   IF tm.e = 'Y' THEN 
      LET l_wc = " (oeb12 < ogb16 AND oea65 = 'Y')" 
   END IF
   IF tm.f = 'Y' THEN 
      IF tm.e = 'Y' THEN 
         LET l_wc = l_wc," OR (oeb12 = ogb16 AND oea65 = 'Y')"
      ELSE
         LET l_wc = l_wc," (oeb12 = ogb16 AND oea65 = 'Y')"
      END IF 
   END IF
   IF tm.g = 'Y' THEN 
      IF tm.e = 'Y' OR tm.f = 'Y' THEN
         LET l_wc = l_wc," OR (oeb12 > ogb16 AND oea65 = 'Y')" 
      END IF
      IF tm.e = 'N' AND tm.f = 'N' THEN
         LET l_wc = l_wc," (oeb12 > ogb16 AND oea65 = 'Y')"
      END IF
   END IF

   RETURN l_wc
END FUNCTION 

FUNCTION q001_tmp_wc()
DEFINE l_wc   STRING
   LET l_wc = ''
   IF tm.b = 'Y' THEN 
      LET l_wc = " oeb12 < oeb24" 
   END IF
   IF tm.c = 'Y' THEN 
      IF tm.b = 'Y' THEN 
         LET l_wc = l_wc," OR oeb12 = oeb24"
      ELSE
         LET l_wc = l_wc," oeb12 = oeb24"
      END IF 
   END IF
   IF tm.d = 'Y' THEN 
      IF tm.b = 'Y' OR tm.c = 'Y' THEN
         LET l_wc = l_wc," OR oeb12 > oeb24" 
      END IF
      IF tm.b = 'N' AND tm.c = 'N' THEN
         LET l_wc = l_wc," oeb12 > oeb24"
      END IF
   END IF
RETURN l_wc
END FUNCTION  

FUNCTION act_page3()
DEFINE l_cutwip        LIKE ecm_file.ecm315,
       l_packwip       LIKE ecm_file.ecm315,
       l_completed     LIKE ecm_file.ecm315,
       l_sfb08         LIKE sfb_file.sfb08, 
       l_sfb01         LIKE sfb_file.sfb01,
       l_sfb09         LIKE sfb_file.sfb09,
       l_sfb93         LIKE sfb_file.sfb93,
       l_ecm311        LIKE ecm_file.ecm311,
       l_n             LIKE type_file.num5,
       l_sql           STRING
DEFINE l_ta            DYNAMIC ARRAY OF RECORD
                       workpro       LIKE ecm_file.ecm315,
                       no            LIKE ecm_file.ecm315
                       END RECORD
DEFINE i,l_cnt         LIKE type_file.num5
DEFINE l_tot           LIKE sfb_file.sfb08
       
      IF l_ac > 0 THEN
         IF NOT cl_null(g_oea01_o) AND g_oea01_o != g_oea[l_ac].oea01 THEN
            LET g_oea01_change_bmb = '1'
            LET g_oea01_change_pml = '1'
            LET g_oea01_change_pmn = '1'
            LET g_oea01_change_ecm = '1'
            LET g_oea01_change_sgd = '1'
            LET g_oea01_change_sfa = '1'
            LET g_oea01_change_ogb = '1'
            LET g_oea01_change_ogbb = '1'
            LET g_oea01_change_inb = '1'
            LET g_oea01_change_ogbc = '1'
            LET g_oea01_change_ogbd = '1'
            LET g_oea01_change_ohb = '1'
            LET g_oea01_change_omb = '1'
            END IF
            IF NOT cl_null(g_oeb03_o) AND g_oeb03_o != g_oea[l_ac].oeb03 THEN
               LET g_oeb03_change_pml = '1'
               LET g_oeb03_change_pmn = '1'
            END IF  
            LET g_oea01_o = g_oea[l_ac].oea01
            LET g_oeb03_o = g_oea[l_ac].oeb03       
            LET g_head.oea01_2 = g_oea[l_ac].oea01
            LET g_head.oea02_2 = g_oea[l_ac].oea02
            LET g_head.oea03_2 = g_oea[l_ac].oea03
            LET g_head.occ02_2 = g_oea[l_ac].occ02
            LET g_head.oea14_2 = g_oea[l_ac].oea14
            LET g_head.gen02_2 = g_oea[l_ac].gen02
            LET g_head.moeb15_2 = g_oea[l_ac].oeb15
            SELECT SUM(oeb12),SUM(oeb24) - SUM(oeb25) INTO g_head.oeb12_2,g_head.oeb24_2
               FROM oeb_file WHERE oeb01 = g_oea[l_ac].oea01  #add by huanglf161201


            SELECT oebislk01 INTO g_head.oebislk01_2 FROM oebi_file
              WHERE oebi01 = g_oea[l_ac].oea01
                AND oebi03 = g_oea[l_ac].oeb03
#            SELECT SUM(ecm301+ecm302+ecm303-ecm311-ecm312-ecm313-ecm314-ecm316) INTO l_cutwip
#              FROM ecm_file,sfb_file
#             WHERE ecm01 = sfb01
#               AND sfb22 = g_oea[l_ac].oea01
#               AND ecm03 = '2'
#            SELECT SUM(ecm301+ecm302+ecm303-ecm311-ecm312-ecm313-ecm314-ecm316) INTO l_packwip
#              FROM ecm_file,sfb_file
#             WHERE ecm01 = sfb01
#               AND sfb22 = g_oea[l_ac].oea01
#               AND ecm03 = '3'
#            SELECT SUM(ecm311+ecm312+ecm313+ecm314+ecm315+ecm316) INTO l_completed
#              FROM ecm_file,sfb_file
#             WHERE ecm01 = sfb01
#               AND sfb22 = g_oea[l_ac].oea01
#               AND ecm03 = '3'
#            SELECT SUM(sfb08) INTO l_sfb08 FROM sfb_file
#             WHERE sfb22 = g_oea[l_ac].oea01
#            LET g_head.workpro_2 = (l_cutwip*0.2+l_packwip*0.8+l_completed)/l_sfb08*100
            LET l_sql = "SELECT DISTINCT sfb01,sfb08,sfb09,sfb93 FROM sfb_file",
                        " WHERE sfb22 = '",g_oea[l_ac].oea01,"'" 
            PREPARE sfb_prep1 FROM l_sql
            DECLARE sfb_curs1 CURSOR FOR sfb_prep1
            SELECT SUM(sfb08) INTO l_tot FROM sfb_file WHERE sfb22=g_oea[l_ac].oea01
            IF cl_null(l_tot) THEN LET l_tot=0 END IF
            LET l_cnt=1
            FOREACH sfb_curs1 INTO l_sfb01,l_sfb08,l_sfb09,l_sfb93
               IF STATUS THEN EXIT FOREACH END IF 
               LET l_cutwip = 0
               LET l_completed = 0
               IF l_sfb93 = 'N' THEN 
                  LET l_cutwip = l_cutwip + l_sfb08                #生产量
                  LET l_completed = l_completed + l_sfb09          #完工量
               ELSE
                  LET l_n = 0
                  SELECT COUNT(*) INTO l_n FROM ecm_file 
                    WHERE ecm01 = l_sfb01
                  SELECT SUM(ecm311*(ecm63/ecm62)) INTO l_ecm311 FROM ecm_file
                    WHERE ecm01 = l_sfb01 
                  IF cl_null(l_ecm311) THEN LET l_ecm311 = 0 END IF
                  LET l_packwip = l_sfb08 * l_n
                  LET l_cutwip = l_cutwip + l_packwip              #生产量
                  LET l_completed = l_completed + l_ecm311         #完工量
              END IF 
              LET l_ta[l_cnt].workpro=(l_completed / l_cutwip) * 100 #每张工单生产进度
              LET l_ta[l_cnt].no=l_sfb08/l_tot                       #每张工单占比重
              IF cl_null(l_ta[l_cnt].workpro) THEN LET l_ta[l_cnt].workpro=0 END IF
              IF cl_null(l_ta[l_cnt].no) THEN LET l_ta[l_cnt].no=0 END IF
              LET l_cnt=l_cnt+1
            END FOREACH
            LET g_head.workpro_2 = 0
            FOR i=1 TO l_cnt - 1
                LET g_head.workpro_2=g_head.workpro_2+l_ta[i].workpro*l_ta[i].no
            END FOR
           #LET g_head.workpro_2 = (l_completed / l_cutwip) * 100
            LET g_head.oeapro_2 = g_head.oeb24_2/g_head.oeb12_2*100
#           LET g_b_flag = 2
         ELSE
             INITIALIZE g_head.* TO NULL 
             LET g_head.oea01_2 = ' '
             LET g_head.oebislk01_2 = ' '
             LET g_oea01_change_bmb = '1'
             LET g_oea01_change_pml = '1'
             LET g_oea01_change_pmn = '1'
             LET g_oea01_change_ecm = '1'
             LET g_oea01_change_sgd = '1'
             LET g_oea01_change_sfa = '1'
             LET g_oea01_change_ogb = '1'
             LET g_oea01_change_ogbb = '1'
             LET g_oea01_change_inb = '1'
             LET g_oea01_change_ogbc = '1'
             LET g_oea01_change_ogbd = '1'
             LET g_oea01_change_ohb = '1'
             LET g_oea01_change_omb = '1'
             LET g_oeb03_change_pml = '1'
             LET g_oeb03_change_pmn = '1'
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
               LET g_action_choice="oeb"
            WHEN 2
               LET g_action_choice="pmk"
            WHEN 3
               LET g_action_choice="pmm"
            WHEN 4
               LET g_action_choice="sfb"
            WHEN 5
               LET g_action_choice="oga"
            WHEN 6
               LET g_action_choice="ogab"
            WHEN 7
               LET g_action_choice="ina"   
            WHEN 8
               LET g_action_choice="ogac" 
            WHEN 9
               LET g_action_choice="ogad"
            WHEN 10
               LET g_action_choice="oha"  
            WHEN 11
               LET g_action_choice="oma"    
            OTHERWISE
               LET g_action_choice="oeb"
         END CASE
END FUNCTION

FUNCTION q001_excel()
CASE 
   WHEN (g_b_flag2 = 0 OR g_b_flag2 = 1) AND g_b_flag3 = 1
       LET page = f.FindNode("Page","page5")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_oeb),'','')
       
   WHEN (g_b_flag2 = 0 OR g_b_flag2 = 1) AND g_b_flag3 = 2
       LET page = f.FindNode("Page","page6")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_bmb),'','')
 
   WHEN g_b_flag2 = 2 AND g_b_flag3 = 1 
       LET page = f.FindNode("Page","page7")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_pmk),'','')  

   WHEN g_b_flag2 = 2 AND g_b_flag3 = 2 
       LET page = f.FindNode("Page","page8")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_pml),'','') 

   WHEN g_b_flag2 = 3 AND g_b_flag3 = 1 
       LET page = f.FindNode("Page","page10")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_pmm),'','')

   WHEN g_b_flag2 = 3 AND g_b_flag3 = 2 
       LET page = f.FindNode("Page","page11")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_pmn),'','')

   WHEN g_b_flag2 = 4 AND g_b_flag3 = 1 
       LET page = f.FindNode("Page","page13")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_sfb),'','')

   WHEN g_b_flag2 = 4 AND g_b_flag3 = 3 
       LET page = f.FindNode("Page","allotment")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_sfa),'','')

   WHEN g_b_flag2 = 4 AND g_b_flag3 = 2  AND (g_b_flag4=0 OR g_b_flag4=1)
       LET page = f.FindNode("Page","page15")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_ecm),'','')

   WHEN g_b_flag2 = 4 AND g_b_flag3 = 2  AND  g_b_flag4 = 2
       LET page = f.FindNode("Page","page16")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_sgd),'','')

   WHEN g_b_flag2 = 5 AND g_b_flag3 = 1 
       LET page = f.FindNode("Page","page20")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_oga),'','')

   WHEN g_b_flag2 = 5 AND g_b_flag3 = 2 
       LET page = f.FindNode("Page","page21")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_ogb),'','')

   WHEN g_b_flag2 = 6 AND g_b_flag3 = 1 
       LET page = f.FindNode("Page","page20_1")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_ogab),'','')

   WHEN g_b_flag2 = 6 AND g_b_flag3 = 2 
       LET page = f.FindNode("Page","page21_1")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_ogbb),'','')

   WHEN g_b_flag2 = 7 AND g_b_flag3 = 1 
       LET page = f.FindNode("Page","page27")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_ina),'','')

   WHEN g_b_flag2 = 7 AND g_b_flag3 = 2 
       LET page = f.FindNode("Page","page28")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_inb),'','')

   WHEN g_b_flag2 = 8 AND g_b_flag3 = 1 
       LET page = f.FindNode("Page","page20_2")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_ogac),'','')

   WHEN g_b_flag2 = 8 AND g_b_flag3 = 2 
       LET page = f.FindNode("Page","page21_2")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_ogbc),'','')

   WHEN g_b_flag2 = 9 AND g_b_flag3 = 1 
       LET page = f.FindNode("Page","page20_3")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_ogad),'','')

   WHEN g_b_flag2 = 9 AND g_b_flag3 = 2 
       LET page = f.FindNode("Page","page21_3")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_ogbd),'','')

   WHEN g_b_flag2 = 10 AND g_b_flag3 = 1 
       LET page = f.FindNode("Page","page17")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_oha),'','')

   WHEN g_b_flag2 = 10 AND g_b_flag3 = 2 
       LET page = f.FindNode("Page","page21_4")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_ohb),'','')

   WHEN g_b_flag2 = 11 AND g_b_flag3 = 1 
       LET page = f.FindNode("Page","page18")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_oma),'','')

   WHEN g_b_flag2 = 11 AND g_b_flag3 = 2 
       LET page = f.FindNode("Page","page19")
       CALL cl_export_to_excel(page,base.TypeInfo.create(g_omb),'','')
END CASE
END FUNCTION 

#FUN-C90076
