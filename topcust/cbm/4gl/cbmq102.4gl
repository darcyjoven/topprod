# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: cbmq102.4gl
# Descriptions...: 料件数量明细查询
# Date & Author..: darcy:2023/05/08 add

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"
GLOBALS "../../../tiptop/sub/4gl/s_data_center.global"   #No.FUN-7C0010

#模組變數(Module Variables)
DEFINE
    tm              RECORD
        plant       ARRAY[20]  OF LIKE azp_file.azp01,   #No.FUN-680096 VARCHAR(10),
        dbs         ARRAY[20]  OF LIKE type_file.chr21   #No.FUN-680096 VARCHAR(21)
                    END RECORD,
    g_bma           RECORD LIKE bma_file.*,       #主件料件(假單頭)
    g_bma_t         RECORD LIKE bma_file.*,       #主件料件(舊值)
    g_bma_o         RECORD LIKE bma_file.*,       #主件料件(舊值)
    g_bma01_t       LIKE bma_file.bma01,   #(舊值)#單頭KEY值
    g_bma06_t       LIKE bma_file.bma06,   #(舊值)#單頭KEY值#FUN-550014
    g_bmb10_fac_t   LIKE bmb_file.bmb10_fac,   #(舊值)
    g_ima08_h       LIKE ima_file.ima08,   #來源碼
    g_ima37_h       LIKE ima_file.ima37,   #補貨政策
    g_ima08_b       LIKE ima_file.ima08,   #來源碼
    g_ima37_b       LIKE ima_file.ima37,   #補貨政策
    g_ima25_b       LIKE ima_file.ima25,   #庫存單位
    g_ima63_b       LIKE ima_file.ima63,   #發料單位
    g_ima70_b       LIKE ima_file.ima63,   #消耗料件
    g_ima86_b       LIKE ima_file.ima86,   #成本單位
    g_ima107_b      LIKE ima_file.ima107,  #LOCATION
    g_ima04         LIKE ima_file.ima04,   #
    g_db_type       LIKE type_file.chr3,    #No.FUN-680096  VARCHAR(3),               #MOD-560037
    g_bmb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    bmb02    LIKE bmb_file.bmb02,       #元件項次
                    bmb30    LIKE bmb_file.bmb30,       #計算方式 #FUN-550014#FUN-610022調換順序
                    bmb03    LIKE bmb_file.bmb03,       #元件料件
                    ima02_b  LIKE ima_file.ima02,       #品名
                    ima021_b LIKE ima_file.ima021,      #規格
                    ima08_b  LIKE ima_file.ima08,       #來源
                    bmb09    LIKE bmb_file.bmb09,       #作業編號
                    bmb16    LIKE bmb_file.bmb16,       #UTE/SUB
                    bmb14    LIKE bmb_file.bmb14,       #Required/Optional
                    bmb04    LIKE bmb_file.bmb04,       #生效日
                    bmb05    LIKE bmb_file.bmb05,       #失效日
                    bmb06    LIKE bmb_file.bmb06,       #組成用量
                    bmb07    LIKE bmb_file.bmb07,       #底數
                    bmb10    LIKE bmb_file.bmb10,       #發料單位
                    bmb08    LIKE bmb_file.bmb08,       #損耗率
                    bmb081   LIKE bmb_file.bmb081,      #No.FUN-A50089
                    bmb082   LIKE bmb_file.bmb082,      #No.FUN-A50089
                    bmb19    LIKE bmb_file.bmb19,
                    bmb24    LIKE bmb_file.bmb24,       #工程變異單號
                    bmb13    LIKE bmb_file.bmb13,       #insert_loc
                    bmb31    LIKE bmb_file.bmb31,       #代買料否  FUN-690019
                    bmb15    LIKE bmb_file.bmb15,       #add by donghy 161121
                    bmb36    LIKE bmb_file.bmb36,       #FUN-D10093 add
                    bmb37    LIKE bmb_file.bmb37,       #FUN-D10093 add
                    bmbud01  LIKE bmb_file.bmbud01,
                    bmbud02  LIKE bmb_file.bmbud02,
                    bmbud03  LIKE bmb_file.bmbud03,
                    bmbud04  LIKE bmb_file.bmbud04,
                    bmbud05  LIKE bmb_file.bmbud05,
                    bmbud06  LIKE bmb_file.bmbud06,
                    bmbud07  LIKE bmb_file.bmbud07,
                    bmbud08  LIKE bmb_file.bmbud08,
                    bmbud09  LIKE bmb_file.bmbud09,
                    bmbud10  LIKE bmb_file.bmbud10,
                    bmbud11  LIKE bmb_file.bmbud11,
                    bmbud12  LIKE bmb_file.bmbud12,
                    bmbud13  LIKE bmb_file.bmbud13,
                    bmbud14  LIKE bmb_file.bmbud14,
                    bmbud15  LIKE bmb_file.bmbud15
                    END RECORD,
    g_bmb_t         RECORD                 #程式變數 (舊值)
                    bmb02    LIKE bmb_file.bmb02,       #元件項次
                    bmb30    LIKE bmb_file.bmb30,       #計算方式 #FUN-550014#FUN-610022調換順序
                    bmb03    LIKE bmb_file.bmb03,       #元件料件
                    ima02_b  LIKE ima_file.ima02,       #品名
                    ima021_b LIKE ima_file.ima021,      #規格
                    ima08_b  LIKE ima_file.ima08,       #來源
                    bmb09    LIKE bmb_file.bmb09,       #作業編號
                    bmb16    LIKE bmb_file.bmb16,       #UTE/SUB
                    bmb14    LIKE bmb_file.bmb14,       #Required/Optional
                    bmb04    LIKE bmb_file.bmb04,       #生效日
                    bmb05    LIKE bmb_file.bmb05,       #失效日
                    bmb06    LIKE bmb_file.bmb06,       #組成用量
                    bmb07    LIKE bmb_file.bmb07,       #底數
                    bmb10    LIKE bmb_file.bmb10,       #發料單位
                    bmb08    LIKE bmb_file.bmb08,       #損耗率
                    bmb081   LIKE bmb_file.bmb081,      #No.FUN-A50089
                    bmb082   LIKE bmb_file.bmb082,      #No.FUN-A50089
                    bmb19    LIKE bmb_file.bmb19,
                    bmb24    LIKE bmb_file.bmb24,       #工程變異單號
                    bmb13    LIKE bmb_file.bmb13,       #insert_loc
                    bmb31    LIKE bmb_file.bmb31,       #代買料否  FUN-690019
                    bmb15    LIKE bmb_file.bmb15,       #add by donghy 161121
                    bmb36    LIKE bmb_file.bmb36,       #FUN-D10093 add
                    bmb37    LIKE bmb_file.bmb37,       #FUN-D10093 add
                    bmbud01  LIKE bmb_file.bmbud01,
                    bmbud02  LIKE bmb_file.bmbud02,
                    bmbud03  LIKE bmb_file.bmbud03,
                    bmbud04  LIKE bmb_file.bmbud04,
                    bmbud05  LIKE bmb_file.bmbud05,
                    bmbud06  LIKE bmb_file.bmbud06,
                    bmbud07  LIKE bmb_file.bmbud07,
                    bmbud08  LIKE bmb_file.bmbud08,
                    bmbud09  LIKE bmb_file.bmbud09,
                    bmbud10  LIKE bmb_file.bmbud10,
                    bmbud11  LIKE bmb_file.bmbud11,
                    bmbud12  LIKE bmb_file.bmbud12,
                    bmbud13  LIKE bmb_file.bmbud13,
                    bmbud14  LIKE bmb_file.bmbud14,
                    bmbud15  LIKE bmb_file.bmbud15
                    END RECORD,
    g_bmb_o         RECORD                 #程式變數 (舊值)
                    bmb02    LIKE bmb_file.bmb02,       #元件項次
                    bmb30    LIKE bmb_file.bmb30,       #計算方式 #FUN-550014
                    bmb03    LIKE bmb_file.bmb03,       #元件料件
                    ima02_b  LIKE ima_file.ima02,       #品名
                    ima021_b LIKE ima_file.ima021,      #規格
                    ima08_b  LIKE ima_file.ima08,       #來源
                    bmb09    LIKE bmb_file.bmb09,       #作業編號
                    bmb16    LIKE bmb_file.bmb16,       #UTE/SUB
                    bmb14    LIKE bmb_file.bmb14,       #Required/Optional
                    bmb04    LIKE bmb_file.bmb04,       #生效日
                    bmb05    LIKE bmb_file.bmb05,       #失效日
                    bmb06    LIKE bmb_file.bmb06,       #組成用量
                    bmb07    LIKE bmb_file.bmb07,       #底數
                    bmb10    LIKE bmb_file.bmb10,       #發料單位
                    bmb08    LIKE bmb_file.bmb08,       #損耗率
                    bmb081   LIKE bmb_file.bmb081,      #No.FUN-A50089
                    bmb082   LIKE bmb_file.bmb082,      #No.FUN-A50089
                    bmb19    LIKE bmb_file.bmb19,
                    bmb24    LIKE bmb_file.bmb24,       #工程變異單號
                    bmb13    LIKE bmb_file.bmb13,       #insert_loc
                    bmb31    LIKE bmb_file.bmb31,        #代買料否  FUN-690019
                    bmb15    LIKE bmb_file.bmb15,       #add by donghy 161121
                    bmb36    LIKE bmb_file.bmb36,       #FUN-D10093 add
                    bmb37    LIKE bmb_file.bmb37,       #FUN-D10093 add
                    bmbud01  LIKE bmb_file.bmbud01,
                    bmbud02  LIKE bmb_file.bmbud02,
                    bmbud03  LIKE bmb_file.bmbud03,
                    bmbud04  LIKE bmb_file.bmbud04,
                    bmbud05  LIKE bmb_file.bmbud05,
                    bmbud06  LIKE bmb_file.bmbud06,
                    bmbud07  LIKE bmb_file.bmbud07,
                    bmbud08  LIKE bmb_file.bmbud08,
                    bmbud09  LIKE bmb_file.bmbud09,
                    bmbud10  LIKE bmb_file.bmbud10,
                    bmbud11  LIKE bmb_file.bmbud11,
                    bmbud12  LIKE bmb_file.bmbud12,
                    bmbud13  LIKE bmb_file.bmbud13,
                    bmbud14  LIKE bmb_file.bmbud14,
                    bmbud15  LIKE bmb_file.bmbud15
                    END RECORD,
    g_bmb11         LIKE  bmb_file.bmb11,
    g_bmb13         LIKE  bmb_file.bmb13,
    g_bmb31         LIKE  bmb_file.bmb31,   #no.FUN-690019
    g_bmb23         LIKE  bmb_file.bmb23,
    g_bmb10_fac     LIKE  bmb_file.bmb10_fac,
    g_bmb10_fac2    LIKE  bmb_file.bmb10_fac2,
    g_bmb15         LIKE  bmb_file.bmb15,
    g_bmb18         LIKE  bmb_file.bmb18,
    g_bmb17         LIKE  bmb_file.bmb17,
    g_bmb27         LIKE  bmb_file.bmb27,
    g_bmb28         LIKE  bmb_file.bmb28,
    g_bmb20         LIKE  bmb_file.bmb20,
    g_bmb19         LIKE  bmb_file.bmb19,
    g_bmb21         LIKE  bmb_file.bmb21,
    g_bmb22         LIKE  bmb_file.bmb22,
    g_bmb25         LIKE  bmb_file.bmb25,
    g_bmb26         LIKE  bmb_file.bmb26,
    g_bmb11_o       LIKE  bmb_file.bmb11,
    g_bmb13_o       LIKE  bmb_file.bmb13,
    g_bmb31_o       LIKE  bmb_file.bmb31,   #no.FUN-690019
    g_bmb23_o       LIKE  bmb_file.bmb23,
    g_bmb25_o       LIKE  bmb_file.bmb23,
    g_bmb26_o       LIKE  bmb_file.bmb23,
    g_bmb10_fac_o   LIKE  bmb_file.bmb10_fac,
    g_bmb10_fac2_o  LIKE  bmb_file.bmb10_fac2,
    g_bmb15_o       LIKE  bmb_file.bmb15,
    g_bmb18_o       LIKE  bmb_file.bmb18,
    g_bmb17_o       LIKE  bmb_file.bmb17,
    g_bmb27_o       LIKE  bmb_file.bmb27,
    g_bmb20_o       LIKE  bmb_file.bmb20,
    g_bmb19_o       LIKE  bmb_file.bmb19,
    g_bmb21_o       LIKE  bmb_file.bmb21,
    g_bmb22_o       LIKE  bmb_file.bmb22,
    g_ima01         LIKE  ima_file.ima01,
    g_sql           string,                  #No.FUN-580092 HCN
    g_wc,g_wc2      string,                  #No.FUN-580092 HCN
    g_vdate         LIKE type_file.dat,      #No.FUN-680096 DATE,
    g_sw            LIKE type_file.num5,     #No.FUN-680096 SMALLINT,  #單位是否可轉換
    g_factor        LIKE ima_file.ima31_fac, #No.FUN-680096 DECIMAL(16,8),         #單位換算率
    g_cmd           LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(60),
    g_aflag         LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(01),
    g_modify_flag   LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(01),

    g_tipstr        LIKE ze_file.ze03,       #FUN-610022 Add,顯示內容為"<依公式生成>"的字符串

    g_ecd02         LIKE ecd_file.ecd02,
    g_rec_b         LIKE type_file.num5,     #No.FUN-680096 SMALLINT,  #單身筆數
    l_ac            LIKE type_file.num5,     #No.FUN-680096 SMALLINT,  #目前處理的ARRAY CNT
    l_sl            LIKE type_file.num5      #No.FUN-680096 SMALLINT   #目前處理的SCREEN LINE
DEFINE p_row,p_col  LIKE type_file.num5      #No.FUN-680096 SMALLINT
DEFINE g_bmt_tmp    DYNAMIC ARRAY OF RECORD LIKE bmt_file.*   #insert_loc的暫存檔 BugNo:6754
DEFINE  g_bma_l       DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                      bma01_l     LIKE bma_file.bma01,
                      bma06_l     LIKE bma_file.bma06,
                      ima02_l     LIKE ima_file.ima02,
                      ima021_l    LIKE ima_file.ima021,
                      ima55_l     LIKE ima_file.ima55,
                      ima05_l     LIKE ima_file.ima05,
                      ima08_l     LIKE ima_file.ima08,
                      bma05_l     LIKE bma_file.bma05,
                      bma08_l     LIKE bma_file.bma08
                      END RECORD
DEFINE  g_bmax        DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                      sel         LIKE type_file.chr1,
                      bma01       LIKE bma_file.bma01,
                      bma06       LIKE bma_file.bma06
                      END RECORD
DEFINE g_gev04        LIKE gev_file.gev04
DEFINE l_ac1          LIKE type_file.num10
DEFINE g_rec_b1       LIKE type_file.num10
DEFINE g_bp_flag      LIKE type_file.chr10
DEFINE g_flag2        LIKE type_file.chr1
DEFINE g_gew06        LIKE gew_file.gew06
DEFINE g_gew07        LIKE gew_file.gew07
DEFINE g_argv1        LIKE bma_file.bma01
DEFINE g_argv2        LIKE bma_file.bma02
DEFINE g_argv3        STRING            #NO.FUN-84 0033 add

#darcy:2023/05/08 add s---
define   g_ima  RECORD
                 ima01    LIKE ima_file.ima01, # 料件編號
                 ima02    LIKE ima_file.ima02, # 品名規格
                 ima021   LIKE ima_file.ima02, # 品名規格
                 ima25    LIKE ima_file.ima25, #
                 ima05    LIKE ima_file.ima05, # 版本
                 ima06    LIKE ima_file.ima06, # 分群碼
                 ima08    LIKE ima_file.ima08, # 來源碼
                 ima37    LIKE ima_file.ima37, #
                 ima70    LIKE ima_file.ima70, #
                 ima15    LIKE ima_file.ima15, #
                 ima906   LIKE ima_file.ima906, #單位管制方式   #FUN-5C0086
                 ima907   LIKE ima_file.ima907, #第二單位       #FUN-5C0086
#                ima261   LIKE ima_file.ima261, #MOD-530179
#                ima262   LIKE ima_file.ima262, #MOD-530179
#                oeb_q    LIKE ima_file.ima262, #MOD-530179
#                sfa_q1   LIKE ima_file.ima262, #MOD-530179
#                sfa_q2   LIKE ima_file.ima262, #MOD-530179
#                pml_q    LIKE ima_file.ima262, #MOD-530179
#                pmn_q    LIKE ima_file.ima262, #MOD-530179
#                rvb_q2   LIKE ima_file.ima262, #FUN-5A0062
#                rvb_q    LIKE ima_file.ima262, #MOD-530179
#                sfb_q1   LIKE ima_file.ima262, #MOD-530179
#                sfb_q2   LIKE ima_file.ima262, #MOD-530179
#                qcf_q    LIKE ima_file.ima262, #MOD-530179
#                alocated LIKE ima_file.ima262, #MOD-530179
#                atp_qty  LIKE ima_file.ima262  #MOD-530179
                 unavl_stk  LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
                 avl_stk    LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
                 oeb_q      LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
                 sfa_q1     LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
                 sfa_q2     LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
                 sie_q      LIKE type_file.num15_3,   #No.FUN-A20048 add 
                 pml_q      LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
                 pmn_q      LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
                 rvb_q2     LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
                 rvb_q      LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
                 sfb_q1     LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
                 sfb_q2     LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
                 qcf_q      LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
            #    alocated   LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044  #FUN-AC0074
                 atp_qty    LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
                 img_q      LIKE type_file.num15_3,   #add by huanglf170314
                 sfe_c      LIKE type_file.num15_3    #add by donghy170420 超领未扣帐数量
                 ,sfa_xiaban LIKE type_file.num15_3  #darcy:2022/05/20 add
                 ,sfa_liuzhi LIKE type_file.num15_3  #darcy:2022/05/20 add
                 ,ima27      like ima_file.ima27   #darcy:2023/04/03 add
                 
              END RECORD,
       g_img  DYNAMIC ARRAY OF RECORD
                 img02    LIKE img_file.img02,   #倉庫編號 #No.FUN-850153
                 imd02    LIKE imd_file.imd02,   #TQC-CC0092--add
                 img03    LIKE img_file.img03,   #儲位   #No:FUN-850153
                 ime03    LIKE ime_file.ime03,   #TQC-CC0092--add
                 img04    LIKE img_file.img04,   #批號   #No.FUN-850153
                 img23    LIKE img_file.img23,   #是否為可用倉庫
                 img10    LIKE img_file.img10,   #庫存數量
                 img18    LIKE img_file.img18,    #add by huanglf170314
                 sig05    LIKE sig_file.sig05,   #FUN-AC0074
                 img09    LIKE img_file.img09,   #庫存單位
                 img38    LIKE img_file.img38    #備註 #CHI-A40004 add
            end record
DEFINE g_imgs   DYNAMIC ARRAY OF RECORD        #批序號明細單身變量
                  imgs02  LIKE imgs_file.imgs02,
                  im02    LIKE imd_file.imd02,   #TQC-CC0092--add
                  imgs03  LIKE imgs_file.imgs03,
                  im03    LIKE ime_file.ime03,   #TQC-CC0092--add
                  imgs04  LIKE imgs_file.imgs04,
                  imgs06  LIKE imgs_file.imgs06,
                  imgs05  LIKE imgs_file.imgs05,
                  imgs09  LIKE imgs_file.imgs09,
                  imgs07  LIKE imgs_file.imgs07,
                  imgs08  LIKE imgs_file.imgs08,
                  imgs10  LIKE imgs_file.imgs10,
                  imgs11  LIKE imgs_file.imgs11                  
                END RECORD,
       g_imgs_t RECORD
                  imgs02  LIKE imgs_file.imgs02,
                  im02    LIKE imd_file.imd02,   #TQC-CC0092--add
                  imgs03  LIKE imgs_file.imgs03,
                  im03    LIKE ime_file.ime03,   #TQC-CC0092--add
                  imgs04  LIKE imgs_file.imgs04,
                  imgs06  LIKE imgs_file.imgs06,
                  imgs05  LIKE imgs_file.imgs05,
                  imgs09  LIKE imgs_file.imgs09,
                  imgs07  LIKE imgs_file.imgs07,
                  imgs08  LIKE imgs_file.imgs08,
                  imgs10  LIKE imgs_file.imgs10,
                  imgs11  LIKE imgs_file.imgs11                  
                END RECORD,
      g_bbb1 DYNAMIC ARRAY OF RECORD
                 tlf06    LIKE tlf_file.tlf06,
                 tlf026   LIKE tlf_file.tlf026,
                 tlf036   LIKE tlf_file.tlf036,
                 msg      LIKE ze_file.ze03,     #MOD-5B0174 #No.FUN-690026 VARCHAR(14)
                 tlf19    LIKE tlf_file.tlf19,
                 gem02    LIKE gem_file.gem02,   #CHI-B40048 add
                 tlf902   LIKE tlf_file.tlf902,
                 tlf903   LIKE tlf_file.tlf903,
                 tlf904   LIKE tlf_file.tlf904,
                 tlf10    LIKE tlf_file.tlf10,
                 tlf11    LIKE tlf_file.tlf11
              END RECORD,
       g_bbb2 DYNAMIC ARRAY OF RECORD
                 pmm04    LIKE pmm_file.pmm04,
                 pmm01    LIKE pmm_file.pmm01,
                 pmc03    LIKE pmc_file.pmc03,
                 pmm22    LIKE pmm_file.pmm22,
                 pmn20    LIKE pmn_file.pmn20,
                 pmn07    LIKE pmn_file.pmn07,
                 pmn86    LIKE pmn_file.pmn86, #FUN-610086
                 pmn31    LIKE pmn_file.pmn31,
                 pmn33    LIKE pmn_file.pmn33,
                 pmm20    LIKE pmm_file.pmm20
              END RECORD,
       g_bbb3 DYNAMIC ARRAY OF RECORD
                 bmx07    LIKE bmx_file.bmx07,
                 bmx01    LIKE bmx_file.bmx01,
                 bmz03    LIKE bmz_file.bmz03,
                 bmz02    LIKE bmz_file.bmz02,
                 bmg03    LIKE bmg_file.bmg03,
                 bmy03    LIKE bmy_file.bmy03,
                 bmy19    LIKE bmy_file.bmy19,
                 bmy06    LIKE bmy_file.bmy06
              END RECORD,
       g_bbb4 DYNAMIC ARRAY OF RECORD
                 bmb01    LIKE bmb_file.bmb01,
                 ima02    LIKE ima_file.ima02,  #TQC-CC0001--add
                 ima021   LIKE ima_file.ima021,
                 bmb02    LIKE bmb_file.bmb02,
                 bmb04    LIKE bmb_file.bmb04,
                 bmb05    LIKE bmb_file.bmb05,
                 bmb16    LIKE bmb_file.bmb16,
                 bmb06    LIKE bmb_file.bmb06,
                 bmb08    LIKE bmb_file.bmb08
              END RECORD,
       g_bbb5 DYNAMIC ARRAY OF RECORD
                 imm01    LIKE imm_file.imm01,
                 imm02    LIKE imm_file.imm02,
                 imn04    LIKE imn_file.imn04,
                 imn05    LIKE imn_file.imn05,
                 imn06    LIKE imn_file.imn06,
                 imn15    LIKE imn_file.imn15,
                 imn16    LIKE imn_file.imn16,
                 imn17    LIKE imn_file.imn17,
                 imn10    LIKE imn_file.imn10,
                 imn09    LIKE imn_file.imn09
              END RECORD
DEFINE g_avl_stk          LIKE type_file.num15_3
DEFINE g_unavl_stk        LIKE type_file.num15_3

#darcy:2023/05/08 add e---

DEFINE
   g_value ARRAY[20] OF RECORD
            fname     LIKE type_file.chr5,  #No.FUN-680096 VARCHAR(5),  #欄位名稱，從'att01'~'att10'
            imx000    LIKE imx_file.imx000, #No.FUN-680096 VARCHAR(8),  #該欄位在imx_file中對應的欄位名稱
            visible   LIKe type_file.chr1,  #No.FUN-680096 VARCHAR(1),  #是否可見，'Y'或'N'
            nvalue    STRING,
            value     STRING  #存放當前當前組
            END RECORD,
    g_att  DYNAMIC ARRAY OF RECORD
            att01   LIKE imx_file.imx01, # 明細屬性欄位
            att02   LIKE imx_file.imx01, # 明細屬性欄位
            att03   LIKE imx_file.imx01, # 明細屬性欄位
            att04   LIKE imx_file.imx01, # 明細屬性欄位
            att05   LIKE imx_file.imx01, # 明細屬性欄位
            att06   LIKE imx_file.imx01, # 明細屬性欄位
            att07   LIKE imx_file.imx01, # 明細屬性欄位
            att08   LIKE imx_file.imx01, # 明細屬性欄位
            att09   LIKE imx_file.imx01, # 明細屬性欄位
            att10   LIKE imx_file.imx01, # 明細屬性欄位
            att11   LIKE imx_file.imx01, # 明細屬性欄位
            att12   LIKE imx_file.imx01, # 明細屬性欄位
            att13   LIKE imx_file.imx01, # 明細屬性欄位
            att14   LIKE imx_file.imx01, # 明細屬性欄位
            att15   LIKE imx_file.imx01, # 明細屬性欄位
            att16   LIKE imx_file.imx01, # 明細屬性欄位
            att17   LIKE imx_file.imx01, # 明細屬性欄位
            att18   LIKE imx_file.imx01, # 明細屬性欄位
            att19   LIKE imx_file.imx01, # 明細屬性欄位
            att20   LIKE imx_file.imx01  # 明細屬性欄位
        END RECORD

DEFINE   lr_agc        DYNAMIC ARRAY OF RECORD LIKE agc_file.* #No.FUN-640139 Add

DEFINE   l_chk_boa     LIKE type_file.chr1,      #FUN-6A0053 add
         l_chk_bob     LIKE type_file.chr1       #FUN-6A0053 add
DEFINE   g_wsw03       LIKE wsw_file.wsw03       #FUN-890113

#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_chr           LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_level         LIKE type_file.num5     #No.FUN-680096 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03       #No.FUN-680096 VARCHAR(72)
DEFINE   g_status        LIKE type_file.num5     #No.FUN-680096 SMALLINT

DEFINE   g_row_count     LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_jump          LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5     #No.FUN-680096 SMALLINT
DEFINE   g_before_input_done   LIKE type_file.num5    #No.FUN-680096 SMALLINT
DEFINE   g_itm DYNAMIC ARRAY OF RECORD #FUN-5A0051
                  db      LIKE type_file.chr20,  #No.FUN-680096 VARCHAR(20),
                  tblname LIKE cre_file.cre08,   #No.FUN-680096 VARCHAR(10),
                  ima01   LIKE ima_file.ima01,
                  ima02   LIKE ima_file.ima02
               END RECORD
DEFINE   b_bmb           RECORD LIKE bmb_file.*
DEFINE p_md         LIKE type_file.chr1        #No.FUN-810014
DEFINE p_bma06      LIKE bma_file.bma06        #No.FUN-810014
DEFINE  g_confirm LIKE type_file.chr1           #No.FUN-830121

###FUN-A50010 START ###
DEFINE g_wc_o            STRING                #g_wc舊值備份
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
DEFINE g_tree_focus_idx  STRING                  #focus節點idx
DEFINE g_tree_focus_path STRING                  #focus節點path
DEFINE g_tree_reload     LIKE type_file.chr1     #tree是否要重新整理 Y/N
DEFINE g_tree_b          LIKE type_file.chr1     #tree是否進入單身 Y/N
DEFINE g_path_self       DYNAMIC ARRAY OF STRING #tree加節點者至root的路徑(check loop)
DEFINE g_path_add        DYNAMIC ARRAY OF STRING #tree要增加的節點底層路徑(check loop)
DEFINE l_table           STRING                  #No:FUN-B70096
DEFINE l_table2          STRING                  #No:FUN-B70096
DEFINE g_str             STRING                  #No:FUN-B70096
###FUN-A50010 END ###

#FUN-B90117--BEGIN--  新增加页签前面的树结构
DEFINE g_tree1    DYNAMIC ARRAY OF RECORD
          name1           STRING,                 #節點名稱
          s1              LIKE type_file.num20_6,
          s2              LIKE type_file.num20_6,
          s3              LIKE type_file.chr20,
          pid1            STRING,                 #父節點id
          id1            STRING,                 #節點id
          has_children1   BOOLEAN,                #TRUE:有子節點, FALSE:無子節點
          expanded1       BOOLEAN,                #TRUE:展開, FALSE:不展開
          level1          LIKE type_file.num5,    #階層
          path1           STRING,                 #節點路徑，以"."隔開
          #各程式key的數量會不同，單身和單頭的key都要記錄
          #若key是數值，要先轉字串，避免數值型態放到Tree有多餘空白
          treekey3       STRING,
          treekey4       STRING 
       #  img            STRING         #图标   #FUN-CB0078 mark
                               END RECORD
DEFINE g_tree_sel        LIKE type_file.chr1   # 用来判断填充哪个树的变量，1表示前页的树，2表示后面的树
DEFINE g_tree_arr_curr   LIKE type_file.num5
DEFINE g_bma01_tree      LIKE bma_file.bma01
#FUN-B90117--END--
DEFINE g_bmb10_t         LIKE bmb_file.bmb10    #FUN-910088--add--
#DEFINE g_lock            LIKE type_file.chr1   #FUN-C20105      #FUN-CB0078
DEFINE g_tree_item       LIKE bma_file.bma01    #FUN-C30036
DEFINE g_hide            LIKE type_file.chr1    #FUN-C30028
#FUN-CB0078 -----begin---add----
DEFINE g_tree_upd        LIKE bma_file.bma01
DEFINE g_tree_bma01      LIKE bma_file.bma01
DEFINE g_show_flag       LIKE type_file.chr1
DEFINE g_a_flag          LIKE type_file.chr1
#FUN-CB0078 -----end-----add----

define flag_list         like type_file.chr1

MAIN
DEFINE  p_sma124  LIKE sma_file.sma121          #No.FUN-810014
DEFINE  l_bmb13   LIKE ze_file.ze03             #No.FUN-810014

    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730075
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("CBM")) THEN
      EXIT PROGRAM
   END IF
   let flag_list = 'N'
   #No:FUN-B70096 --START--
   LET g_sql = "bma01_g.bma_file.bma01,",
               "bma01.bma_file.bma01,",
               "ima02.ima_file.ima02,",
               "bma06.bma_file.bma06,",
               "ima55.ima_file.ima55,",
               "bmb02.bmb_file.bmb02,",
               "bmb03.bmb_file.bmb03,",
               "ima02_1.ima_file.ima02,",
               "bmb09.bmb_file.bmb09,",
               "bmb06.bmb_file.bmb06,",
               "bmb07.bmb_file.bmb07,",
               "bmb10.bmb_file.bmb10,",     #CHI-C90013 add ,
               "id.type_file.num10,",       #CHI-C90013 add
               "pid.type_file.num10"        #CHI-C90013 add   

   LET l_table = cl_prt_temptable('cbmq102',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF

   #temp
   LET g_sql = "bma01.bma_file.bma01,",
               "bma06.bma_file.bma06,",    #CHI-C90013 add,
               "id.type_file.num10"            #CHI-C90013 add
   #LET l_table2 = cl_prt_temptable('cbmq102',g_sql) CLIPPED  #TQC-C70178 mark
   LET l_table2 = cl_prt_temptable('cbmq1021',g_sql) CLIPPED  #TQC-C70178 add
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
   #No:FUN-B70096 --END--

#  LET g_lock = 'N'          #FUN-C20105
   LET g_hide = 'N'          #FUN-C30028
   
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   LET g_argv3 = ARG_VAL(3)    #no.FUN-84 0033 add

     LET g_db_type=cl_db_get_database_type() #MOD-560037
    LET g_wc2=' 1=1'

    LET g_forupd_sql =
       "SELECT * FROM bma_file WHERE bma01=? AND bma06=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE cbmq102_cl CURSOR FROM g_forupd_sql

   #  CALL s_decl_bmb()

      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060

    LET p_row = 3 LET p_col = 2
    OPEN WINDOW cbmq102_w AT p_row,p_col WITH FORM "cbm/42f/cbmq102"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()

    LET g_tree_reload = "N"      #tree是否要重新整理 Y/N  #FUN-A50010
    LET g_tree_b = "N"           #tree是否進入單身 Y/N    #FUN-A50010
    LET g_tree_focus_idx = 0     #focus節點index       #FUN-A50010
    LET g_show_flag = 'N'        #FUN-CB0078   add
    LET g_a_flag = 'N'           #FUN-CB0078   add
    #darcy:2022/03/30 s---
    #IF g_user <>'tiptop' THEN 
    #  CALL cl_set_act_visible("confirmp",FALSE)
    #END IF 
    #darcy:2022/03/30 s---

    CALL cl_set_comp_visible("bmb36,bmb37",g_aza.aza121='Y') #FUN-D10093 add #當aoos010欄位"是否與PLM整合[aza121=Y]"打勾時,才show出bmb36/bmb37欄位
    IF s_industry('slk') THEN
        CALL cl_set_comp_visible("bma06",g_sma.sma118='Y') #FUN-560115
        CALL cl_set_comp_visible("bma06_l",g_sma.sma118='Y')     #No.FUN-7C0010
    ELSE
        CALL cl_set_comp_visible("bma06,bmb30",g_sma.sma118='Y') #FUN-560115
        CALL cl_set_comp_visible("bma06_l",g_sma.sma118='Y')     #No.FUN-7C0010
    END IF
    IF s_industry('slk') THEN
        SELECT  ze03  INTO l_bmb13 FROM ze_file WHERE ze01 = 'cbmq102' AND ze02 = g_lang
        CALL cl_set_comp_att_text("bmb13",l_bmb13)
        CALL cbmq102_set_bmb30()
    END IF
    IF NOT s_industry('slk') THEN
        CALL cbmq102_set_bmb30_1()
    END IF

#FUN-B90117 --BEGIN--
  #FUN-C20094 mark START
  #IF g_sma.sma541 = 'Y' THEN
  #  CALL cl_set_comp_visible("tree1",TRUE)
  #ELSE
  #	 CALL cl_set_comp_visible("tree1",FALSE)
  #END IF
  #FUN-C20094 mark END
  CALL cl_set_comp_visible("tree1",TRUE) #FUN-C20094 add 
#FUN-B90117 --END--

    SELECT ze03 INTO g_tipstr FROM ze_file WHERE
      ze01 = 'lib-294' AND ze02 = g_lang

    --IF NOT cl_null(g_argv1) THEN
       --CALL cbmq102_q()
    --END IF
    #TQC-C20444-add-str--
    IF NOT cl_null(g_argv1) THEN 
       CALL cbmq102_q(0)
    END IF
    #TQC-C20444-add-end--
    LET g_action_choice = ''

    CALL cbmq102_menu()

    CLOSE WINDOW cbmq102_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
END MAIN

#QBE 查詢資料
FUNCTION cbmq102_curs(p_idx)  #FUN-9A50010 加參數p_idx
DEFINE l_flag      LIKE type_file.chr1    #No.FUN-680096  VARCHAR(01)   #判斷單身是否給條件
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE p_idx  LIKE type_file.num5   #雙按Tree的節點index     #FUN-9A50010
DEFINE l_wc   STRING                #雙按Tree的節點時的查詢條件 #FUN-9A50010

###FUN-A50010 START ###
   LET l_wc = NULL
   IF p_idx > 0 THEN
      IF g_tree_b = "N" THEN
         LET l_wc = g_wc_o             #還原QBE的查詢條件
      ELSE
         IF g_tree[p_idx].level = 1 THEN
           LET l_wc = "ima01='",g_tree[p_idx].treekey2 CLIPPED,"'"
         ELSE
            IF g_tree[p_idx].has_children THEN
              LET l_wc = "ima01='",g_tree[p_idx].treekey2 CLIPPED,"'"
            ELSE
               LET l_wc = "ima01='",g_tree[p_idx].treekey2 CLIPPED,"'"

            END IF
         END IF
      END IF
#FUN-C20105 --begin--      
##FUN-B90117--BEGIN--
#   ELSE
#   	  IF g_action_choice = "tree" THEN
#   	     LET l_wc = "bma01='",g_tree1[g_tree_arr_curr].treekey4 CLIPPED,"'"
#   	  END IF
##FUN-B90117--END--
#FUN-C20105 --end--
   END IF
   ###FUN-A50010 END ###

    CLEAR FORM                            #清除畫面
    CALL g_bmb.clear()
    LET l_flag = 'N'
    LET g_vdate = g_today
  
   #IF NOT cl_null(g_argv1) OR g_lock = 'Y' THEN                          #FUN-C20105  #FUN-C30036   
   #IF NOT cl_null(g_argv1) OR g_lock = 'Y' OR NOT cl_null(g_tree_item) THEN  #FUN-C30036  #FUN-CB0078  mark
    IF NOT cl_null(g_argv1) OR NOT cl_null(g_tree_item) THEN              #FUN-CB0078  add
       IF NOT cl_null(g_argv1) THEN                                        #FUN-C20105 
          LET g_wc = " ima01 = '",g_argv1,"' AND bma06 = '",g_argv2,"'"
          LET g_tree_bma01 = g_argv1     #FUN-CB0078  add
       END IF                                                              #FUN-C20105

#FUN-C20105 --begin--
    #  IF g_lock='Y' AND g_tree_arr_curr > 0 THEN                          #FUN-CB0078  mark 
       IF NOT cl_null(g_tree_item) AND g_tree_arr_curr > 0 THEN            #FUN-CB0078  add
          LET g_wc = " ima01 = '",g_tree1[g_tree_arr_curr].treekey4,"'" 
          LET g_tree_bma01 = g_tree1[1].treekey4                           #FUN-CB0078  add 
       END IF 
#FUN-C20105 --end--
       #FUN-C30036---begin
       IF NOT cl_null(g_tree_item) THEN
          LET g_wc = " ima01 = '",g_tree_item,"'"
       END if
       #FUN-C30036---end
       
       LET g_wc2= " 1=1" 

    ELSE
      # IF g_wc IS NULL THEN #MOD-530690
          CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
          INITIALIZE g_bma.* TO NULL    #No.FUN-750051

#FUN-C20105 --begin--          
##FUN-B90117--BEGIN--
##       IF p_idx = 0 THEN   #FUN-9A50010
#        IF p_idx = 0 AND g_action_choice = "tree" THEN
#           LET g_wc = " bma01 = '",g_tree1[g_tree_arr_curr].treekey4 CLIPPED,"'"
#        ELSE
##FUN-B90117 --END--

        IF p_idx = 0 THEN 
#FUN-C20105 --end--
         Dialog
             CONSTRUCT g_wc on ima01,ima02,ima021 from bma01,ima02,ima021 
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
             end CONSTRUCT
             construct g_wc2 on img02,img03,img04,img10,img18
                  from  s_img[1].img02,s_img[1].img03,s_img[1].img04,s_img[1].img10,s_img[1].img18
             end construct
             before dialog
               next field bma01
            ON ACTION CONTROLP
                  CASE
                     WHEN INFIELD(bma01) 
                        CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO bma01
                        NEXT FIELD bma01
                     WHEN INFIELD(bma08)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form  = "q_azp"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO bma08
                        NEXT FIELD bma08
                     OTHERWISE EXIT CASE
                   END CASE

              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE dialog

              ON ACTION about         #MOD-4C0121
                 CALL cl_about()      #MOD-4C0121

              ON ACTION help          #MOD-4C0121
                 CALL cl_show_help()  #MOD-4C0121

              ON ACTION controlg      #MOD-4C0121
                 CALL cl_cmdask()     #MOD-4C0121

              ON ACTION qbe_select
                 CALL cl_qbe_list() RETURNING lc_qbe_sn
                 CALL cl_qbe_display_condition(lc_qbe_sn)
              on action accept
               exit dialog

              on action cancel
               let g_wc = ''
               let g_wc2 = ''
               let INT_FLAG = true
               exit dialog
              
         end Dialog 

          IF INT_FLAG THEN
             RETURN
           END IF

         #  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup')
 
          CALL cl_set_head_visible("","YES")            #No.FUN-6B0033  
        ###FUN-9A50010 START ###
       ELSE                                 #FUN-B90117         #FUN-C20105 unmark
          LET g_wc = l_wc CLIPPED           #FUN-B90117         #FUN-C20105 unmark
       END IF
      #  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup') #FUN-980030
# 
    #  IF p_idx = 0 THEN   #不是從tree點進來的，而是重新查詢時CONSTRUCT產生的原始查詢條件要備份  #FUN-CB0078
       IF p_idx = 0 AND g_action_choice = "query" THEN    #FUN-CB0078
          LET g_wc_o = cl_replace_str(g_wc,'ima01','bma01') clipped
       END IF
          ###FUN-9A50010 END ###

    END IF
    
    
#FUN-C20105 --begin--
     IF cl_null(g_wc) THEN
        LET g_wc = " 1=1"
     END IF 
#FUN-C20105 --end--
    
    IF g_wc =' 1=1' OR (g_wc2 IS NULL OR g_wc2 =' 1=1')THEN
      LET g_sql=" SELECT unique ima01,' ' FROM ima_file",
                " WHERE ",g_wc CLIPPED,
                "   AND imaacti='Y'"  #CHI-C10003 add
    ELSE
      LET g_sql=" SELECT unique ima01,' ' ",
                "  FROM ima_file,img_file",
                " WHERE ima_file.ima01=img_file.img01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                "   AND img10<>0", #FUN-620040
                "   AND imaacti='Y'"  #CHI-C10003 add
   END IF
 
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
 
   LET g_sql = g_sql clipped," ORDER BY ima01"

    PREPARE cbmq102_prepare FROM g_sql
    DECLARE cbmq102_curs SCROLL CURSOR WITH HOLD FOR cbmq102_prepare
    DECLARE cbmq102_list_cur CURSOR FOR cbmq102_prepare

    IF l_flag = 'N' THEN   # 取合乎條件筆數
        LET g_sql="SELECT count(unique ima01) FROM ima_file WHERE ",g_wc CLIPPED   #MOD-9A0202
    ELSE
        LET g_sql="SELECT count(unique ima01) FROM ima_file,img_file   ",  #MOD-9A0202
                  " WHERE ima_file.ima01=img_file.img01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                  "   AND img10<>0 AND imaacti='Y' "
    END IF

    PREPARE cbmq102_precount FROM g_sql
    DECLARE cbmq102_count CURSOR FOR cbmq102_precount
END FUNCTION

FUNCTION cbmq102_menu()

   DEFINE
      l_cmd           LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(100),
      l_priv1         LIKE zy_file.zy03,       # 使用者執行權限
      l_priv2         LIKE zy_file.zy04,       # 使用者資料權限
      l_priv3         LIKE zy_file.zy05,       # 使用部門資料權限
      l_ima903        LIKE ima_file.ima903,
      l_imaud10       LIKE ima_file.imaud10,
      l_imaud07       LIKE ima_file.imaud07

  #MOD-C40062 str add-----
   DEFINE w ui.Window
   DEFINE f ui.Form
   DEFINE page om.DomNode
  #MOD-C40062 end add-----

   ###FUN-9A50010 START ###
   --DEFINE l_wc               STRING
   --DEFINE l_tree_arr_curr    LIKE type_file.num5
   --DEFINE l_curs_index       STRING               #focus的資料是在第幾筆
   --DEFINE l_i                LIKE type_file.num5
   --DEFINE l_tok              base.StringTokenizer
   ###FUN-9A50010 END ###
    IF s_industry("slk") THEN
      CALL cl_getmsg("abm-603",2) RETURNING g_msg
      CALL cbmq102_set_act_title("insert_loc",g_msg)
      CALL cbmq102_set_act_title("create_loc_data",g_msg)
    END IF

   WHILE TRUE

      IF cl_null(g_bp_flag) OR g_bp_flag <> 'list' THEN
         CALL cbmq102_bp("G")
      ELSE
         CALL cbmq102_bp1("G")
      END IF

      IF g_bp_flag = 'list' AND l_ac1>0 THEN #將清單的資料回傳到主畫面
         SELECT bma_file.*
           INTO g_bma.*
           FROM bma_file
          WHERE bma01=g_bma_l[l_ac1].bma01_l
            AND bma06=g_bma_l[l_ac1].bma06_l
      END IF


      CASE g_action_choice

         WHEN "query"
            IF cl_chk_act_auth() THEN
               LET g_wc=''  
               let flag_list = 'N'
               CALL cbmq102_q(0)     #FUN-CB0078 add
            END IF 
          WHEN "tree"
            CALL cbmq102_q(0)
            LET g_tree_item = ''      #FUN-CB0078 add
            LET g_action_choice=''  
            
         WHEN "help"
            CALL cl_show_help()
            LET g_bp_flag = "main"
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            LET g_bp_flag = "main"
         WHEN "bom_release"
            IF cl_chk_act_auth() THEN
              #FUN-AA0018---mod---str---
              #CALL cbmq102_j()
               CALL i600sub_j_chk(g_bma.bma01,g_bma.bma06)
               IF g_success = 'Y' THEN
                   CALL i600sub_j_input() RETURNING g_bma.bma05
                   IF INT_FLAG THEN
                      LET g_bma.bma05=NULL
                      DISPLAY BY NAME g_bma.bma05
                      LET INT_FLAG=0
                      #RETURN   #TQC-C20149   mark
                   #END IF      #TQC-C20149   mark
                   ELSE         #TQC-C20149
                      DISPLAY BY NAME g_bma.bma05
                      BEGIN WORK
                      CALL i600sub_j_upd(g_bma.bma01,g_bma.bma06,g_bma.bma05)
                      IF g_success = 'Y' THEN
                          COMMIT WORK
                          CALL i600sub_refresh(g_bma.bma01,g_bma.bma06) RETURNING g_bma.*
                      ELSE
                          ROLLBACK WORK
                      END IF
                   END IF       #TQC-C20149
                   CALL i600sub_carry(g_bma.bma01,g_bma.bma06)
               END IF
              #FUN-AA0018---mod---end---
               CALL cbmq102_show()     #MOD-840104 add
               LET g_bp_flag = "main"
            END IF
       
         WHEN "hide_tree"
            IF g_hide = 'N' THEN
               CALL cl_set_comp_visible("tree1",FALSE)
               LET g_hide = 'Y'
            ELSE
               CALL cl_set_comp_visible("tree1",TRUE)
               LET g_hide = 'N'
            END IF 
         #FUN-C30028---end 

         WHEN "preview_bom"
            IF cl_chk_act_auth() THEN
              CALL preview_bom_test()
              LET g_bp_flag = "main"
            END IF
         
         when "bpm_todo"
            if cl_chk_act_auth() then
               if g_user = "55758" then
                  run "/u1/usr/tiptop/bpm/bpmtodo --config /u1/usr/tiptop/bpm/config.xml --user 55758 --mail wenjing.zheng@forewin-sz.com.cn"
               end if
            end if

         WHEN "edit_formula"
            CALL cl_set_act_visible("edit_formula", FALSE)
            LET g_bp_flag = "main"


         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
             #MOD-C40062 str add------
             #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmb),'','')
              LET w = ui.Window.getCurrent()
              LET f = w.getForm()
              LET page = f.FindNode("Table","s_bmb")
              CALL cl_export_to_excel(page,base.TypeInfo.create(g_bmb),'','')
             #MOD-C40062 end add-----
              LET g_bp_flag = "main"
            END IF
         
         WHEN "period_tran"
            IF cl_chk_act_auth() THEN
               CALL s_aimq102_q1(g_ima.ima01,'','','1')   #FUN-B80153 add
            END IF
#@         WHEN "最近採購"
         WHEN "latest_pur"
            IF cl_chk_act_auth() THEN
               CALL q102_q2()
            END IF
#@         WHEN "在途調撥"
         WHEN "transfer_in_transit"
            CALL q102_q5()
#@         WHEN "合格供應商"
         WHEN "approved_vender"
            LET g_msg='apmi254 "',g_ima.ima01,'"'
            CALL cl_cmdrun(g_msg)
#@         WHEN "取替代"
         WHEN "rep_sub"
            LET g_msg='abmi604 "',g_ima.ima01,'"'
            CALL cl_cmdrun(g_msg)
#@         WHEN "BOM用途"
         WHEN "bom_usage"
            IF cl_chk_act_auth() THEN
               CALL q102_q4()
            END IF
#@         WHEN "ECN"
         WHEN "ecn"
            IF cl_chk_act_auth() THEN
               CALL q102_q3()
            END IF
#@         WHEN "BIN卡"
         WHEN "bin_card"
            LET g_msg='aimq231 "',g_ima.ima01,'"'
            CALL cl_cmdrun(g_msg)
#@         WHEN "供需明細"
         WHEN "demand_Supply"
            LET g_msg='aimq841 "1" "',g_ima.ima01,'"'
            CALL cl_cmdrun(g_msg)
#@         WHEN "細項查詢"
         WHEN "query_detail"
            CALL cbmq102_d('0')
         WHEN "query_lot_data"  #查詢批/序號資料
            IF l_ac > 0 THEN
               CALL q102_q_imgs()
            END IF
 #FUN-AC0074--add--begin
         WHEN "Stocks_detail"
            IF cl_chk_act_auth() THEN
               IF g_ima.sie_q>0 THEN 
                  CALL cbmq102_detail()
               ELSE
                  CALL cl_err('','aim-050',0)
               END IF
            END IF 
         WHEN "du_detail"
            LET g_cmd = "aimq410 '",g_ima.ima01,"'"
            CALL cl_cmdrun(g_cmd CLIPPED)
         WHEN "1"
            CALL cbmq102_d('1')
         WHEN "2"
            CALL cbmq102_d('2')
         WHEN "3"
            CALL cbmq102_d('3')
         WHEN "4"
            CALL cbmq102_d('4')
         WHEN "5"
            CALL cbmq102_d('5')
         WHEN "6"
            CALL cbmq102_d('6')
         WHEN "7"
            CALL cbmq102_d('7')
         WHEN "8"
            CALL cbmq102_d('8')
      END CASE
   END WHILE
END FUNCTION




FUNCTION cbmq102_bma01(p_cmd)  #主件料件
    DEFINE p_cmd     LIKE type_file.chr1,   #No.FUN-680096  VARCHAR(01),
           l_bmz01   LIKE bmz_file.bmz01,
           l_bmz03   LIKE bmz_file.bmz03,
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima55   LIKE ima_file.ima55,
           l_ima05   LIKE ima_file.ima05,
           l_imaacti LIKE ima_file.imaacti,
           l_imaud07 LIKE ima_file.imaud07,
           l_imaud10 LIKE ima_file.imaud10,
           l_imaud06  LIKE ima_file.imaud06

    LET g_errno = ' '
    SELECT  ima02,ima021,ima55, ima08,imaacti,ima05,imaud07,imaud10,imaud06
       INTO l_ima02,l_ima021,l_ima55, g_ima08_h,l_imaacti,
            l_ima05,l_imaud07,l_imaud10,l_imaud06
       FROM ima_file
      WHERE ima01 = g_bma.bma01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2602'
                            LET l_ima02 = NULL LET l_ima021 = NULL
                            LET l_ima55 = NULL LET g_ima08_h = NULL
                            LET l_imaacti = NULL
                            LET l_ima05=NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
        WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE

    #--->來源碼為'Z':雜項料件
    IF g_ima08_h ='Z'
    THEN LET g_errno = 'mfg2752'
         RETURN
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd'
      THEN DISPLAY l_ima02   TO FORMONLY.ima02_h
           DISPLAY l_ima021  TO FORMONLY.ima021_h
           DISPLAY g_ima08_h TO FORMONLY.ima08_h
           DISPLAY l_ima55   TO FORMONLY.ima55
           DISPLAY l_ima05   TO FORMONLY.ima05_h
           DISPLAY l_imaud07  TO FORMONLY.imaud07
           DISPLAY l_imaud10  TO FORMONLY.imaud10
           DISPLAY l_imaud06  TO FORMONLY.imaud06
    END IF
END FUNCTION

#Query 查詢
FUNCTION cbmq102_q(p_idx)   #FUN-9A50010 加參數p_idx
    DEFINE p_idx  LIKE type_file.num5    #雙按Tree的節點index  #FUN-9A50010
   
    #TQC-C70069--mark--str--
    ##MOD-C30530--add--str--
    #IF g_lock = 'Y' THEN
    #   CALL cl_err('','abm-094',0)   
    #   RETURN
    #END IF             
    ##MOD-C30530--add--end--
    #TQC-C70069--mark--end--
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bma.* TO NULL             #No.FUN-6A0002
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_bmb.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL cl_getmsg('mfg2618',g_lang) RETURNING g_msg
    CALL cbmq102_curs(p_idx)      #取得查詢條件   #FUN-9A50010傳入參數p_idx
    IF INT_FLAG THEN
        INITIALIZE g_bma.* TO NULL
        CALL g_bma_l.clear()
	CALL g_tree.clear()
        CALL g_tree1.clear()       #MOD-C30561
        LET g_tree_focus_idx =0
        LET INT_FLAG = 0
        LET g_bp_flag ="main"
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN cbmq102_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bma.* TO NULL
    ELSE
        OPEN cbmq102_count
        FETCH cbmq102_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt

        ###FUN-9A50010 START ###
        IF p_idx = 0 THEN
           CALL cbmq102_fetch2('F',0)        #讀出TEMP第一筆並顯示
           #CALL cbmq102_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL)   #Tree填充
        ELSE
           #Tree的最上層是QBE結果，才可以指定jump
           IF g_tree[p_idx].level = 1 THEN
              CALL cbmq102_fetch2('T',p_idx) #讀出TEMP中，雙點Tree的指定節點並顯示
           ELSE
              CALL cbmq102_fetch2('F',0)
           END IF
        END IF
        ###FUN-9A50010 END ###
        if flag_list = 'N' then
         CALL cbmq102_list_fill()      #No.FUN-7C0010
         let flag_list = 'Y'
        end if
        LET g_bp_flag = NULL       #CHI-880031
        #CALL cbmq102_fetch('F',0)                  # 讀出TEMP第一筆并顯示  #TQC-C60239 mark
    END IF


    MESSAGE " "
END FUNCTION

FUNCTION cbmq102_list_fill()
  DEFINE l_bma01         LIKE bma_file.bma01
  DEFINE l_bma06         LIKE bma_file.bma06
  DEFINE l_i             LIKE type_file.num10

    CALL g_bma_l.clear()
    LET l_i = 1
    FOREACH cbmq102_list_cur INTO l_bma01,l_bma06
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach list_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT bma01,bma06,ima02,ima021,ima55,ima05,ima08,bma05,bma08
         INTO g_bma_l[l_i].*
         FROM bma_file, ima_file
        WHERE bma01=l_bma01
          AND bma06=l_bma06
          AND bma01=ima_file.ima01
       if cl_null(g_bma_l[l_i].bma01_l) then
         continue foreach
       end if
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN   #CHI-BB0034 add
            CALL cl_err( '', 9035, 0 )
          END IF                              #CHI-BB0034 add
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b1 = l_i - 1
    DISPLAY ARRAY g_bma_l TO s_bma_l.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY

END FUNCTION

FUNCTION cbmq102_fetch(p_flag,p_idx)    #FUN-9A50010 加參數p_idx
DEFINE
    p_flag     LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)      #處理方式

DEFINE p_idx     LIKE type_file.num5     #雙按Tree的節點index  #FUN-9A50010
DEFINE l_i       LIKE type_file.num5     #FUN-9A50010
DEFINE l_jump    LIKE type_file.num5     #跳到QBE中Tree的指定筆 #FUN-9A50010
DEFINE   l_n1       LIKE type_file.num15_3
DEFINE   l_n2       LIKE type_file.num15_3
DEFINE   l_n3       LIKE type_file.num15_3

    MESSAGE ""
    ##FUN-9A50010 START ###
    IF p_flag = 'T' AND p_idx <= 0 THEN      #Tree index錯誤就改讀取第一筆資料
       LET p_flag = 'F'
    END IF
    ##FUN-9A50010 END ###
   CASE p_flag
        WHEN 'N' FETCH NEXT     cbmq102_curs INTO g_bma.bma01,g_bma.bma06
        WHEN 'P' FETCH PREVIOUS cbmq102_curs INTO g_bma.bma01,g_bma.bma06
        WHEN 'F' FETCH FIRST    cbmq102_curs INTO g_bma.bma01,g_bma.bma06
        WHEN 'L' FETCH LAST     cbmq102_curs INTO g_bma.bma01,g_bma.bma06
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump cbmq102_curs INTO g_bma.bma01,g_bma.bma06

              ##FUN-9A50010 START ###
        #Tree雙點指定筆
        WHEN 'T'
           #讀出TEMP中，雙點Tree的指定節點並顯示
           LET l_jump = 0
           IF g_tree[p_idx].level = 1 THEN   #最高層
              LET l_jump = g_tree[p_idx].id  #ex:當id=5，表示要跳到第5筆
           END IF
           IF l_jump <= 0 THEN
              LET l_jump = 1
           END IF
           LET g_jump = l_jump
           FETCH ABSOLUTE g_jump cbmq102_curs INTO g_bma.bma01,g_bma.bma06
        ##FUN-9A50010 END ###

    END CASE

    IF SQLCA.sqlcode THEN
       CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0)
       INITIALIZE g_bma.* TO NULL   #No.TQC-6B0105
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
     
    # TODO:直接查询栏位
    SELECT ima01, ima02, ima021, ima25, ima05, ima06,
#          ima08, ima37, ima70, ima15, ima906,ima907,ima261,ima262   #FUN-5C0086
           ima08, ima37, ima70, ima15, ima906,ima907,0,0             #NO.FUN-A20044
      INTO g_ima.ima01,g_ima.ima02,g_ima.ima021,g_ima.ima25,g_ima.ima05,
           g_ima.ima06,g_ima.ima08,g_ima.ima37,g_ima.ima70,g_ima.ima15,
           g_ima.ima906,g_ima.ima907,   #FUN-5C0086
#          g_ima.ima261,g_ima.ima262                                 #NO.FUN-A20044 
           g_unavl_stk,g_avl_stk                                     #NO.FUN-A20044         
        FROM ima_file
       WHERE ima01 = g_bma.bma01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"",
                    "",0)   #No.FUN-660156
        RETURN
    END IF
    CALL s_getstock(g_ima.ima01,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
    LET g_unavl_stk = l_n2                                  #NO.FUN-A20044
    LET g_avl_stk = l_n3                                    #NO.FUN-A20044  
    CALL cbmq102_show()

END FUNCTION

#將資料顯示在畫面上
FUNCTION cbmq102_show()
DEFINE l_count    LIKE type_file.num5    #No.FUN-680096 SMALLINT
DEFINE l_wc_new1  STRING                 #FUN-CB0078
DEFINE l_wc_new2  STRING                 #FUN-CB0078
DEFINE l_ecu02    LIKE ecu_file.ecu02     

  
      display by name  g_bma.bma01
      DISPLAY BY NAME g_ima.ima02, g_ima.ima021,
           g_ima.ima25, g_ima.ima05, g_ima.ima06,
           g_ima.ima08, g_ima.ima37, g_ima.ima70, g_ima.ima15,
           g_ima.ima906,g_ima.ima907    #FUN-5C0086
#          g_ima.ima261,g_ima.ima262    #NO.FUN-A20044
      DISPLAY g_unavl_stk to FORMONLY.unavl_stk      #NO.FUN-A20044    
      DISPLAY g_avl_stk to FORMONLY.avl_stk          #NO.FUN-A20044    
 
   #  CALL cbmq102_pic()  #MOD-840435

#FUN-B90117 --BEGIN--
   #IF g_lock='N' AND cl_null(g_tree_item) THEN   #只有在非锁定状态才会刷新树状图           #FUN-C20105 #FUN-C30036	
    IF g_show_flag = 'N' AND (cl_null(g_tree_item) OR  g_tree_arr_curr < = 0                #FUN-CB0078
         OR g_action_choice = "query"                                                       #FUN-CB0078
         OR g_action_choice = "modify") THEN                                                #FUN-CB0078
       LET g_tree_sel='1'
       CALL g_tree1.clear()
    #  CALL cbmq102_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_bma.bma01)    #FUN-CB0078 mark
       #FUN-CB0078 --begin--
       IF g_action_choice = "modify" THEN
          IF g_bma01_t <> g_tree_upd THEN
             LET l_wc_new1 = "bma01 = '",g_tree_upd,"'"
             CALL cbmq102_tree_fill(l_wc_new1,NULL,0,NULL,NULL,NULL,g_tree_upd)
          ELSE
             LET l_wc_new2 = "bma01 = '",g_bma.bma01,"'"
             CALL cbmq102_tree_fill(l_wc_new2,NULL,0,NULL,NULL,NULL,g_bma.bma01)
          END IF
       ELSE
          CALL cbmq102_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_bma.bma01)
       END IF
      #FUN-CB0078 --end--       
    END IF                                                              #FUN-C20105 
#FUN-B90117--END--

    CALL cbmq102_bma01('d')
    CALL cbmq102_b_fill(g_wc2)                 #單身
    call cbmq102_show2()  
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION


 
 
#CHI-C30002 ------- add  -------- begin
FUNCTION cbmq102_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         #CHI-C80041---begin
         DELETE FROM bml_file WHERE bml02=g_bma.bma01
         DELETE FROM bmm_file WHERE bmm01=g_bma.bma01
         #CHI-C80041---end
         DELETE FROM bma_file WHERE bma01 = g_bma.bma01
                                AND bma06 = g_bma.bma06
         INITIALIZE g_bma.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION

 
FUNCTION cbmq102_bmb03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-680096  VARCHAR(1),
    l_ima110        LIKE ima_file.ima110,
    l_ima140        LIKE ima_file.ima140,
    l_ima1401       LIKE ima_file.ima1401,  #FUN-6A0036 add
    l_imaacti       LIKE ima_file.imaacti


    LET g_errno = ' '
    SELECT ima02,ima021,ima08,ima37,ima25,ima63,ima70,ima86,ima105,ima107,  #No.MOD-5A0193 add ima86
           ima110,ima140,ima1401,imaacti #FUN-6A0036 add ima1401
        INTO g_bmb[l_ac].ima02_b,g_bmb[l_ac].ima021_b,
             g_ima08_b,g_ima37_b,g_ima25_b,g_ima63_b,
             g_ima70_b,g_ima86_b,g_bmb27,g_ima107_b,l_ima110,l_ima140,l_ima1401,l_imaacti  #No.MOD-5A0193 add ima86 #FUN-6A0036 add(ima1401)
        FROM ima_file
        WHERE ima01 = g_bmb[l_ac].bmb03

    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET g_bmb[l_ac].ima02_b = NULL
                                   LET g_bmb[l_ac].ima021_b = NULL
                                   LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF g_ima70_b IS NULL OR g_ima70_b = ' ' THEN
       LET g_ima70_b = 'N'
    END IF
    LET g_bmb[l_ac].bmb15 = g_ima70_b
    #--->來源碼為'Z':雜項料件
    IF g_ima08_b ='Z'
    THEN LET g_errno = 'mfg2752'
         RETURN
    END IF
    #CHI-C30130---begin mark
    #IF l_ima140  ='Y' AND l_ima1401 <= g_vdate THEN #FUN-6A0036
    #   LET g_errno = 'aim-809'
    #   RETURN
    #END IF
    #CHI-C30130---end
    IF g_bmb27 IS NULL OR g_bmb27 = ' ' THEN LET g_bmb27 = 'N' END IF
    IF cl_null(l_ima110) THEN LET l_ima110='1' END IF
    IF p_cmd = 'a' THEN
       LET g_bmb[l_ac].bmb19 = l_ima110
       DISPLAY g_bmb[l_ac].bmb19 TO s_bmb[l_sl].bmb19       
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
        DISPLAY g_bmb[l_ac].ima02_b TO s_bmb[l_sl].ima02_b
        DISPLAY g_bmb[l_ac].ima021_b TO s_bmb[l_sl].ima021_b
        LET g_bmb[l_ac].ima08_b = g_ima08_b
        DISPLAY g_bmb[l_ac].ima08_b TO s_bmb[l_sl].ima08_b

    END IF
END FUNCTION

FUNCTION  cbmq102_bdate(p_cmd)
  DEFINE   l_bmb04_a,l_bmb04_i LIKE bmb_file.bmb04,
           l_bmb05_a,l_bmb05_i LIKE bmb_file.bmb05,
           p_cmd     LIKE type_file.chr1,     #No.FUN-680096  VARCHAR(01),
           l_n       LIKE type_file.num10     #No.FUN-680096 INTEGER

    LET g_errno = " "
    IF p_cmd = 'a' THEN
       SELECT COUNT(*) INTO l_n FROM bmb_file
                             WHERE bmb01 = g_bma.bma01         #主件
                               AND bmb29 = g_bma.bma06         #FUN-550014 add
                               AND bmb02 = g_bmb[l_ac].bmb02  #項次
                               AND bmb04 = g_bmb[l_ac].bmb04
       IF l_n >= 1 THEN  LET g_errno = 'mfg2737' RETURN END IF
    END IF
    IF p_cmd = 'u' THEN
       SELECT count(*) INTO l_n FROM bmb_file
                      WHERE bmb01 = g_bma.bma01         #主件
                        AND bmb29 = g_bma.bma06         #FUN-550014 add
                        AND bmb02 = g_bmb[l_ac].bmb02   #項次
       IF l_n = 1 THEN RETURN END IF
    END IF
    SELECT MAX(bmb04),MAX(bmb05) INTO l_bmb04_a,l_bmb05_a
                       FROM bmb_file
                      WHERE bmb01 = g_bma.bma01         #主件
                       AND  bmb29 = g_bma.bma06         #FUN-550014 add
                       AND  bmb02 = g_bmb[l_ac].bmb02   #項次
                       AND  bmb04 < g_bmb[l_ac].bmb04   #生效日
    IF l_bmb04_a IS NOT NULL AND l_bmb05_a IS NOT NULL
    THEN IF (g_bmb[l_ac].bmb04 > l_bmb04_a )
            AND (g_bmb[l_ac].bmb04 < l_bmb05_a)
         THEN LET g_errno = 'mfg2737'
              RETURN
         END IF
    END IF
    IF g_bmb[l_ac].bmb04 <  l_bmb04_a THEN
        LET g_errno = 'mfg2737'
    END IF
    IF l_bmb04_a IS NULL AND l_bmb05_a IS NULL THEN
       RETURN
    END IF

    SELECT MIN(bmb04),MIN(bmb05) INTO l_bmb04_i,l_bmb05_i
                       FROM bmb_file
                      WHERE bmb01 = g_bma.bma01         #主件
                       AND  bmb29 = g_bma.bma06         #FUN-550014
                       AND  bmb02 = g_bmb[l_ac].bmb02   #項次
                       AND  bmb04 > g_bmb[l_ac].bmb04   #生效日
    IF l_bmb04_i IS NULL AND l_bmb05_i IS NULL THEN RETURN END IF
    IF l_bmb04_a IS NULL AND l_bmb05_a IS NULL THEN
       IF g_bmb[l_ac].bmb04 < l_bmb04_i THEN
          LET g_errno = 'mfg2737'
       END IF
    END IF
    IF g_bmb[l_ac].bmb04 > l_bmb04_i THEN LET g_errno = 'mfg2737' END IF
END FUNCTION

FUNCTION  cbmq102_edate(p_cmd)
  DEFINE   l_bmb04_i   LIKE bmb_file.bmb04,
           l_bmb04_a   LIKE bmb_file.bmb04,
           p_cmd       LIKE type_file.chr1,    #No.FUN-680096  VARCHAR(01),
           l_n         LIKE type_file.num5     #No.FUN-680096 SMALLINT

    IF p_cmd = 'u' THEN
       SELECT COUNT(*) INTO l_n FROM bmb_file
                      WHERE bmb01 = g_bma.bma01         #主件
                        AND bmb29 = g_bma.bma06         #FUN-550014
                        AND bmb02 = g_bmb[l_ac].bmb02   #項次
       IF l_n =1 THEN RETURN END IF
    END IF
    LET g_errno = " "
    SELECT MIN(bmb04) INTO l_bmb04_i
                       FROM bmb_file
                      WHERE bmb01 = g_bma.bma01         #主件
                        AND bmb29 = g_bma.bma06         #FUN-550014
                       AND  bmb02 = g_bmb[l_ac].bmb02   #項次
                       AND  bmb04 > g_bmb[l_ac].bmb04   #生效日
   SELECT MAX(bmb04) INTO l_bmb04_a
                       FROM bmb_file
                      WHERE bmb01 = g_bma.bma01         #主件
                       AND  bmb29 = g_bma.bma06         #FUN-550014
                       AND  bmb02 = g_bmb[l_ac].bmb02   #項次
                       AND  bmb04 > g_bmb[l_ac].bmb04   #生效日
   IF l_bmb04_i IS NULL THEN RETURN END IF
   IF g_bmb[l_ac].bmb05 > l_bmb04_i THEN LET g_errno = 'mfg2738' END IF
END FUNCTION

FUNCTION  cbmq102_bmb10()
DEFINE l_gfeacti       LIKE gfe_file.gfeacti

LET g_errno = ' '

     SELECT gfeacti INTO l_gfeacti FROM gfe_file
       WHERE gfe01 = g_bmb[l_ac].bmb10

    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2605'
         WHEN l_gfeacti='N'       LET g_errno = '9028'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

 
 
 
FUNCTION cbmq102_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2      LIKE type_file.chr1000    
   DEFINE l_sql          LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
   DEFINE l_img10        LIKE img_file.img10   #add by huanglf170314
   IF g_wc2 IS NULL OR g_wc2=' ' THEN LET g_wc2=" 1=1" END IF

   LET l_img10 = 0 #add by huanglf170314
   LET g_ima.img_q = 0 #add by huanglf170314
   LET l_sql =
        "SELECT img02,'',img03,'',img04,img23,img10,img18,'',img09,img38", #img18 add by huanglf170314 #No.FUN-850153 #CHI-A40004 add img38#FUN-AC0074
        " FROM  img_file",
        " WHERE img01 = '",g_ima.ima01,"'",
        "   AND img10<>0",
        "   AND ",g_wc2, #FUN-620040
        " ORDER BY img02,img03,img04"
    PREPARE cbmq102_pb FROM l_sql
    DECLARE cbmq102_bcs CURSOR FOR cbmq102_pb
 
    CALL g_img.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH cbmq102_bcs INTO g_img[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
      #---TQC-CC0092--add--star--
        SELECT imd02 INTO g_img[g_cnt].imd02 FROM imd_file WHERE imd01=g_img[g_cnt].img02
        #SELECT ime03 INTO g_img[g_cnt].ime03 FROM ime_file WHERE ime01=g_img[g_cnt].img03 #TQC-DB0050 mark
        SELECT ime03 INTO g_img[g_cnt].ime03 FROM ime_file          #TQC-DB0050
        WHERE ime01=g_img[g_cnt].img02 AND ime02=g_img[g_cnt].img03 #TQC-DB0050
      #---TQC-CC0092--add--end--
#FUN-AC0074--add--begin
       SELECT sig05 INTO g_img[g_cnt].sig05 FROM sig_file
         WHERE sig01 = g_ima.ima01 AND sig02 = g_img[g_cnt].img02
           AND sig03 = g_img[g_cnt].img03         #MOD-D80023 add
           AND sig04 = g_img[g_cnt].img04
#FUN-AC0074--add--end

#str----add by huanglf170314
      SELECT NVL(SUM(img10),0) INTO l_img10 FROM img_file WHERE img01 = g_ima.ima01 
        AND img02 = g_img[g_cnt].img02 AND img03 = g_img[g_cnt].img03 AND img04 = g_img[g_cnt].img04
        AND img18 < g_today
       LET  g_ima.img_q = g_ima.img_q + l_img10 
#str----end by huanglf170314
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
     CALL g_img.deleteElement(g_cnt)    #No.MOD-480150
    LET g_rec_b=(g_cnt-1)
    DISPLAY g_rec_b TO FORMONLY.cn2
    DISPLAY BY NAME g_ima.img_q   #add by huanglf170314


    #FUN-B80137 add begin-------------------------
    LET g_sql = " SELECT imgs02,'',imgs03,'',imgs04,imgs06,imgs05,imgs09,imgs07,imgs08,imgs10,imgs11",
                "  FROM imgs_file ",
                "  WHERE imgs01 = '",g_ima.ima01,"' ",
                "  ORDER BY imgs02,imgs03,imgs04 "
    PREPARE sel_imgs_pre FROM g_sql
    DECLARE imgs_curs CURSOR FOR sel_imgs_pre

    CALL g_imgs.clear()

    LET g_cnt = 1
    FOREACH imgs_curs INTO g_imgs[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      #---TQC-CC0092--add--star--
        SELECT imd02 INTO g_imgs[g_cnt].im02 FROM imd_file WHERE imd01=g_imgs[g_cnt].imgs02
        #SELECT ime03 INTO g_imgs[g_cnt].im03 FROM ime_file WHERE ime01=g_imgs[g_cnt].imgs03 #TQC-DB0050 mark
        SELECT ime03 INTO g_imgs[g_cnt].im03 FROM ime_file              #TQC-DB0050
        WHERE ime01=g_imgs[g_cnt].imgs02 AND ime02=g_imgs[g_cnt].imgs03 #TQC-DB0050
      #---TQC-CC0092--add--end--
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_imgs.deleteElement(g_cnt)

END FUNCTION

FUNCTION cbmq102_bp(p_ud)
   DEFINE   p_ud     LIKE type_file.chr1    #No.FUN-680096 VARCHAR(1)
   DEFINE   l_count  LIKE type_file.num5    #No.FUN-680096 SMALLINT  #No.FUN-610022
   DEFINE   l_t      LIKE type_file.num10   #No.FUN-680096 INTEGER  #FUN-610095
   DEFINE   l_cnt    LIKE type_file.num5    #FUN-C30036

    ###FUN-9A50010 START ###
   DEFINE l_wc               STRING
   DEFINE l_tree_arr_curr    LIKE type_file.num5
   DEFINE l_curs_index       STRING               #focus的資料是在第幾筆
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_tok              base.StringTokenizer
   ###FUN-9A50010 END ###
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)


   SELECT count(*)
      INTO l_count
      FROM bmb_file
    WHERE bmb01 = g_bma.bma01
       AND bmb30='3'

    IF l_count = 0 THEN
       CALL cl_set_act_visible("preview_bom", FALSE)
       CALL cl_set_act_visible("edit_formula",FALSE)  #No.FUN-640139 Add
    ELSE
       CALL cl_set_act_visible("preview_bom", TRUE)
       CALL cl_set_act_visible("edit_formula",FALSE)  #No.FUN-640139 Add
    END IF

    IF NOT s_industry('slk') THEN
        CALL cl_set_act_visible("fix",FALSE)
    END IF

      ###FUN-9A50010 START ###

      #讓各個交談指令可以互動
      DIALOG ATTRIBUTES(UNBUFFERED)


#FUN-B90117 --add BEGIN--
        DISPLAY ARRAY g_tree1 TO tree1.*
          BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )     #FUN-CB0078 lixh1
            IF g_tree_focus_idx <= 0 THEN
               LET g_tree_focus_idx = ARR_CURR()
            END IF

            BEFORE ROW
               LET l_tree_arr_curr = ARR_CURR() #目前在tree的row
               LET g_tree_arr_curr = ARR_CURR()
               LET g_tree_focus_path = g_tree1[l_tree_arr_curr].path1
               #有子節點就focus在此，沒有子節點就focus在它的父節點
               IF g_tree1[l_tree_arr_curr].has_children1 THEN
                  LET g_tree_focus_idx = l_tree_arr_curr CLIPPED
               ELSE
                  CALL cl_str_sepcnt(g_tree_focus_path,".") RETURNING l_i  #依分隔符號分隔字串後的item數量
                  IF l_i > 1 THEN
                     CALL cl_str_sepsub(g_tree_focus_path CLIPPED,".",1,l_i-1) RETURNING g_tree_focus_path #依分隔符號分隔字串後，截取指定起點至終點的item
                  END IF
                  CALL cbmq102_tree_idxbypath()   #依tree path指定focus節點
               END IF

               #IF g_tree1[l_tree_arr_curr].has_children1 THEN                     #FUN-C20105   #FUN-CB0078 unmark 
          #    IF g_tree1[l_tree_arr_curr].has_children1 AND g_lock = 'Y' THEN    #FUN-C20105   #FUN-CB0078 mark 
          #       LET g_tree_item = g_tree1[1].treekey4                 #FUN-CB0078
                  LET g_tree_item = g_tree1[l_tree_arr_curr].treekey4   #FUN-CB0078
                # LET g_action_choice="tree"          #FUN-CB0078   mark
                # EXIT DIALOG                         #FUN-CB0078   mark
                  CALL cbmq102_q(0)    #FUN-CB0078 add
                #FUN-CB0078 -------Begin------
                  DISPLAY ARRAY g_tree1 TO tree1.*
                     BEFORE DISPLAY
                        EXIT DISPLAY
                  END DISPLAY
                  LET g_tree_item = ''
                #FUN-CB0078 -------End--------

                CALL cbmq102_show_pic(l_tree_arr_curr)

            ON ACTION accept             #双击时如果是锁定状态并且是尾阶料号，则让用户输入状态
                #FUN-C30036---begin
                LET g_tree_item = g_tree1[l_tree_arr_curr].treekey4
                LET l_cnt = 0
                SELECT COUNT(*) INTO l_cnt FROM bma_file
                 WHERE bma01 = g_tree_item
                IF l_cnt > 0 THEN  
                   CALL cbmq102_q(0)
                   
                   DISPLAY ARRAY g_tree1 TO tree1.*
                      BEFORE DISPLAY
                         EXIT DISPLAY
                   END DISPLAY
                ELSE
                   INITIALIZE g_bma.* TO NULL
                   CALL g_bmb.clear()
                   CALL cbmq102_show()
                END IF 
                
                LET g_tree_item = '' 
                
         END DISPLAY
         

          DISPLAY ARRAY g_img TO s_img.* ATTRIBUTE(COUNT=g_rec_b)              #FUN-B80137 add

            BEFORE DISPLAY
               #當使用雙單位時,才顯示"多單位庫存明細查詢"這個ACTION
               IF g_sma.sma115 = 'N' THEN
                  CALL cl_set_act_visible("du_detail",FALSE)
               ELSE
                  CALL cl_set_act_visible("du_detail",TRUE)
               END IF
               CALL cl_navigator_setting( g_curs_index, g_row_count )

            BEFORE ROW                                #No.MOD-590279
               LET l_ac = ARR_CURR() 
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

            AFTER DISPLAY         #FUN-B80137 add
               CONTINUE DIALOG     #FUN-B80137 add
         END DISPLAY             #FUN-B80137 add

        DISPLAY ARRAY g_imgs TO s_imgs.* ATTRIBUTE(COUNT=g_rec_b1)              #FUN-B80137 add

          BEFORE DISPLAY
            #當使用雙單位時,才顯示"多單位庫存明細查詢"這個ACTION
             IF g_sma.sma115 = 'N' THEN
                CALL cl_set_act_visible("du_detail",FALSE)
             ELSE
                CALL cl_set_act_visible("du_detail",TRUE)
             END IF
             CALL cl_navigator_setting( g_curs_index, g_row_count )

          BEFORE ROW                                #No.MOD-590279
              LET l_ac1 = ARR_CURR() 
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

          AFTER DISPLAY         #FUN-B80137 add
            CONTINUE DIALOG     #FUN-B80137 add
        END DISPLAY             #FUN-B80137 add        

#           DISPLAY ARRAY g_bma_l TO s_bma_l.* ATTRIBUTE(COUNT=g_rec_b1)
#              BEFORE DISPLAY
#                CALL cl_navigator_setting( g_curs_index, g_row_count )

#             BEFORE ROW
#                LET l_ac = ARR_CURR()
#                CALL cl_show_fld_cont()
#                LET g_tree_sel='2'              #FUN-B90117
# #              CALL cbmq102_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL)   #FUN-B90117
#                CALL cbmq102_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_bma_l[l_ac].bma01_l) #FUN-B90117
#                CONTINUE DIALOG

#             AFTER DISPLAY
#                CONTINUE DIALOG   #因為外層是DIALOG


#          END DISPLAY


         BEFORE DIALOG
            #No.FUN-A30120 add by tommas   判斷是否要focus到tree的正確row
          # IF g_tree_focus_idx > 0 THEN
          #    CALL Dialog.nextField("tree.name")                   #No.FUN-A30120 add by tommas   利用NEXT FIELD達到focus另一個table
          #    CALL Dialog.setCurrentRow("tree", g_tree_focus_idx)   #No.FUN-A30120 add by tommas   指定tree要focus的row
          # END IF   
            LET l_tree_arr_curr = 1
            LET l_ac = 1

          
         
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
         

         ON ACTION first
            CALL cbmq102_fetch('F',0)
            CALL cbmq102_tree_idxbykey()
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
            END IF
         EXIT DIALOG              #TQC-A60039 add  

         ON ACTION previous
            CALL cbmq102_fetch('P',0)
            CALL cbmq102_tree_idxbykey()
            CALL cl_navigator_setting(g_curs_index, g_row_count)
              IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
              END IF
           EXIT DIALOG            #TQC-A60039 add

         ON ACTION jump
            CALL cbmq102_fetch('/',0)
            CALL cbmq102_tree_idxbykey()
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(1)
            END IF
           EXIT DIALOG             #TQC-A60039 add

         ON ACTION next
            CALL cbmq102_fetch('N',0)
            CALL cbmq102_tree_idxbykey()
            CALL cl_navigator_setting(g_curs_index, g_row_count)
              IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
              END IF
           EXIT DIALOG

         ON ACTION last
            CALL cbmq102_fetch('L',0)
            CALL cbmq102_tree_idxbykey()
            CALL cl_navigator_setting(g_curs_index, g_row_count)
              IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
              END IF
         EXIT DIALOG 

         ON ACTION hide_tree
            LET g_action_choice="hide_tree"
            EXIT DIALOG
         
         on action bpm_todo
            let g_action_choice = "bpm_todo"
            exit dialog

        ON ACTION list_pg
           LET g_bp_flag = 'list'
          EXIT DIALOG


      
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

         ON ACTION close                #視窗右上角的"x"
            LET INT_FLAG=FALSE
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG

         ON ACTION about
            CALL cl_about()
            EXIT DIALOG


         ON ACTION exporttoexcel
            LET g_action_choice = 'exporttoexcel'
            EXIT DIALOG
        ON ACTION preview_bom
           LET g_action_choice = 'preview_bom'
           EXIT DIALOG

        ON ACTION edit_formula
           LET g_action_choice = 'edit_formula'
           EXIT DIALOG

         ON ACTION controls
            CALL cl_set_head_visible("","AUTO")
            EXIT DIALOG
        
         ON ACTION OUTPUT
            LET g_action_choice = 'output'
            EXIT DIALOG
         #No:FUN-B70096 --END--

         #@      ON ACTION 依工單查詢
      ON ACTION query_by_w_o
         LET g_action_choice="query_by_w_o"
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
#@      ON ACTION 依訂單查詢
      ON ACTION query_by_order
         LET g_action_choice="query_by_order"
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
#@      ON ACTION 依BOM查詢
      ON ACTION query_by_bom
         LET g_action_choice="query_by_bom"
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
#@      ON ACTION 期間異動
      ON ACTION period_tran
         LET g_action_choice="period_tran"
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
#@      ON ACTION 最近採購
      ON ACTION latest_pur
         LET g_action_choice="latest_pur"
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
#@      ON ACTION 在途調撥
      ON ACTION transfer_in_transit
         LET g_action_choice="transfer_in_transit"
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
#@      ON ACTION 合格供應商
      ON ACTION approved_vender
         LET g_action_choice="approved_vender"
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
#@      ON ACTION 取替代
      ON ACTION rep_sub
         LET g_action_choice="rep_sub"
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
#@      ON ACTION BOM用途
      ON ACTION bom_usage
         LET g_action_choice="bom_usage"
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
#@      ON ACTION ECN
      ON ACTION ecn
         LET g_action_choice="ecn"
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
#@      ON ACTION BIN卡
      ON ACTION bin_card
         LET g_action_choice="bin_card"
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
#@      ON ACTION 供需明細
      ON ACTION demand_Supply
         LET g_action_choice="demand_Supply"
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
#FUN-AC0074--add--begin
      ON ACTION Stocks_detail
         LET g_action_choice="Stocks_detail"
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
#FUN-AC0074--add--end
#@      ON ACTION 細項查詢
      ON ACTION query_detail
         LET g_action_choice="query_detail"
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
#@      ON ACTION 工廠切換
      #--FUN-B10030--start--
      # ON ACTION switch_plant
      #   LET g_action_choice="switch_plant"
      #   EXIT DISPLAY
      #--FUN-B10030--end--
#@    ON ACTION 多單位庫存明細查詢
      ON ACTION du_detail
         LET g_action_choice = 'du_detail'
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
      ON ACTION query_lot_data  #查詢批/序號資料
         LET g_action_choice = 'query_lot_data'
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add 

#FUN-CB0078 -----Begin-----
##FUN-C20105 --begin--
#        ON ACTION lock
#           LET g_action_choice = 'lock'
#           EXIT DIALOG           
##FUN-C20105 --end--
#FUN-CB0078 -----End-------
#MOD-C90170 add &include "qry_string.4gl"
&include "qry_string.4gl" 
         
      END DIALOG
      CALL cl_set_act_visible("accept,cancel", TRUE)
      ###FUN-9A50010 END ###

END FUNCTION

FUNCTION cbmq102_bp1(p_ud)
   DEFINE   p_ud     LIKE type_file.chr1    #No.FUN-680096 VARCHAR(1)
   DEFINE   l_count  LIKE type_file.num5    #No.FUN-680096 SMALLINT  #No.FUN-610022
   DEFINE   l_t      LIKE type_file.num10   #No.FUN-680096 INTEGER  #FUN-610095

    ###FUN-9A50010 START ###
   DEFINE l_wc               STRING
   DEFINE l_tree_arr_curr    LIKE type_file.num5
   DEFINE l_curs_index       STRING               #focus的資料是在第幾筆
   DEFINE l_i,l_j            LIKE type_file.num5
   DEFINE l_tok              base.StringTokenizer
   define l_bma01            like bma_file.bma01
   ###FUN-9A50010 END ###
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   #判斷是否需要隱藏Ring Menu中的“BOM預覽”和“編輯自定義公式”兩個按鈕
   #被迫做這一切，只因為上面加的那個cl_load_act_list
   SELECT count(*)
     INTO l_count
     FROM bmb_file
    WHERE bmb01 = g_bma.bma01
      AND bmb30='3'

   IF l_count = 0 THEN
      CALL cl_set_act_visible("preview_bom", FALSE)
      CALL cl_set_act_visible("edit_formula",FALSE)  #No.FUN-640139 Add
   ELSE
      CALL cl_set_act_visible("preview_bom", TRUE)
      CALL cl_set_act_visible("edit_formula",FALSE)  #No.FUN-640139 Add
   END IF
    IF NOT s_industry('slk') THEN
       CALL cl_set_act_visible("fix",FALSE)
    END IF
    IF s_industry('slk') THEN
       CALL cl_getmsg("abm-603",2) RETURNING g_msg
       CALL cbmq102_set_act_title("insert_loc",g_msg)
       CALL cbmq102_set_act_title("create_loc_data",g_msg)
    END IF

    CALL cl_set_act_visible("accept,cancel", FALSE)

    ###FUN-9A50010 START ###

      #讓各個交談指令可以互動
      DIALOG ATTRIBUTES(UNBUFFERED)
         DISPLAY ARRAY g_tree TO tree.*
            BEFORE DISPLAY
               #重算g_curs_index，按上下筆按鈕才會正確
               #因為double click tree node後,focus tree的節點會改變
               CALL cl_navigator_setting( g_curs_index, g_row_count )  #FUN-CB0078 lixh1 
               IF g_tree_focus_idx <= 0 THEN
                  LET g_tree_focus_idx = ARR_CURR()
               END IF


             #  以最上層的id當作單頭的g_curs_index
               IF g_tree_focus_idx > 0  THEN
               CALL cl_str_sepsub(g_tree[g_tree_focus_idx].id CLIPPED,".",1,1) RETURNING l_curs_index #依分隔符號分隔字串後，截取指定起點至終點的item
               LET g_curs_index = l_curs_index
               CALL cl_navigator_setting( g_curs_index, g_row_count )
               END IF

            BEFORE ROW
               LET l_tree_arr_curr = ARR_CURR() #目前在tree的row
#FUN-A50010  add by dxfwo
               let l_bma01 = g_tree[l_tree_arr_curr].treekey2
               LET g_tree_focus_path = g_tree[l_tree_arr_curr].path
               #有子節點就focus在此，沒有子節點就focus在它的父節點
               IF g_tree[l_tree_arr_curr].has_children THEN
                  LET g_tree_focus_idx = l_tree_arr_curr CLIPPED
               ELSE
                  CALL cl_str_sepcnt(g_tree_focus_path,".") RETURNING l_i  #依分隔符號分隔字串後的item數量
                  IF l_i > 1 THEN
                     CALL cl_str_sepsub(g_tree_focus_path CLIPPED,".",1,l_i-1) RETURNING g_tree_focus_path #依分隔符號分隔字串後，截取指定起點至終點的item
                  END IF
                  CALL cbmq102_tree_idxbypath()   #依tree path指定focus節點
               END IF

               LET g_tree_b = "Y"             #tree是否進入單身 Y/N
                CALL cbmq102_show_pic(l_tree_arr_curr)
#FUN-A50010  add by dxfwo


            #double click tree node
            
#FUN-A50010  mark by dxfwo
#              ON ACTION accept
#              LET g_tree_focus_path = g_tree[l_tree_arr_curr].path
#              #有子節點就focus在此，沒有子節點就focus在它的父節點
#              IF g_tree[l_tree_arr_curr].has_children THEN
#                 LET g_tree_focus_idx = l_tree_arr_curr CLIPPED
#              ELSE
#                 CALL cl_str_sepcnt(g_tree_focus_path,".") RETURNING l_i  #依分隔符號分隔字串後的item數量
#                 IF l_i > 1 THEN
#                    CALL cl_str_sepsub(g_tree_focus_path CLIPPED,".",1,l_i-1) RETURNING g_tree_focus_path #依分隔符號分隔字串後，截取指定起點至終點的item
#                 END IF
#                 CALL cbmq102_tree_idxbypath()   #依tree path指定focus節點
#              END IF
#
#              LET g_tree_b = "Y"             #tree是否進入單身 Y/N
#               CALL cbmq102_show_pic(l_tree_arr_curr)
         END DISPLAY


    DISPLAY ARRAY g_bma_l TO s_bma_l.* ATTRIBUTE(COUNT=g_rec_b1)
            BEFORE DISPLAY
               CALL cl_navigator_setting( g_curs_index, g_row_count )
                IF g_sma.sma901 != 'Y' THEN
                   CALL cl_set_act_visible("aps_related_data",FALSE)
                END IF
                IF g_sma.sma104 != 'Y' THEN
                   CALL cl_set_act_visible("contract_product",FALSE)
                END IF
            BEFORE ROW
               LET l_ac = ARR_CURR()
               let l_bma01 = g_bma_l[l_ac].bma01_l
               CALL cl_show_fld_cont()
               LET g_tree_sel='2'             #FUN-B90117
#              CALL cbmq102_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL)   #FUN-B90117
               CALL i600sub_refresh(g_bma_l[l_ac].bma01_l,g_bma_l[l_ac].bma06_l) RETURNING g_bma.*  #MOD-D80170
               CALL cbmq102_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_bma_l[l_ac].bma01_l) #FUN-B90117
               CONTINUE DIALOG

            AFTER DISPLAY
               CONTINUE DIALOG   #因為外層是DIALOG

    END DISPLAY

#MOD-A50010 mark---start---
      --BEFORE DIALOG
        #No.FUN-A30120 add by tommas   判斷是否要focus到tree的正確row
          --IF g_tree_focus_idx > 0 THEN
             --CALL Dialog.nextField("tree.name")                   #No.FUN-A30120 add by tommas   利用NEXT FIELD達到focus另一個table
             --CALL Dialog.setCurrentRow("tree", g_tree_focus_idx)   #No.FUN-A30120 add by tommas   指定tree要focus的row
          --END IF
#MOD-A50010 mark---end---

      


      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG



      ON ACTION first
         CALL cbmq102_fetch('F',0)
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         EXIT DIALOG  
         
         ON ACTION previous
         CALL cbmq102_fetch('P',0)
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
	 EXIT DIALOG

      ON ACTION jump
         CALL cbmq102_fetch('/',0)
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
	 EXIT DIALOG

      ON ACTION next
         CALL cbmq102_fetch('N',0)
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
	 EXIT DIALOG
      ON ACTION last
         CALL cbmq102_fetch('L',0)
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
	 EXIT DIALOG

      

    
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

      on action bpm_todo
            let g_action_choice = "bpm_todo"
            exit dialog

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_ac = ARR_CURR()
       LET g_tree_sel='2'         #FUN-B90117
         CALL cbmq102_tree_fill(g_wc_o,NULL,0,NULL,
#                            g_bma_l[l_ac].bma01_l,NULL)          #FUN-B90117
                             g_bma_l[l_ac].bma01_l,NULL,NULL)     #FUN-B90117
         # CALL cbmq102_pic() #MOD-840435
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG



      ON ACTION hide_tree
         LET g_action_choice="hide_tree"
         EXIT DIALOG

       


      ON ACTION info_pg
         LET g_bp_flag = NULL
         EXIT DIALOG

      ON ACTION main
         LET g_bp_flag = 'main'
         --LET l_ac1 = ARR_CURR()
         --LET g_jump = l_ac1
         --LET mi_no_ask = TRUE
         --IF g_rec_b1 >0 THEN
         --CALL cbmq102_fetch('/',0)
         --END IF
         CALL cbmq102_bp("G")
         --CALL cl_set_comp_visible("page5", FALSE)
         --CALL cl_set_comp_visible("info", FALSE)
         --CALL ui.interface.refresh()
         --CALL cl_set_comp_visible("page5", TRUE)
         --CALL cl_set_comp_visible("info", TRUE)
         EXIT DIALOG

      ON ACTION accept
         --LET l_ac = ARR_CURR()
         --CALL cl_show_fld_cont()
         --CALL cbmq102_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL)
         --CONTINUE DIALOG
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET mi_no_ask = TRUE
         LET g_bp_flag = NULL
         let g_bma.bma01 = l_bma01
         let g_bma.bma06 = ' '
         CALL cbmq102_fetch2('/',0)
         CALL cl_set_comp_visible("info", FALSE)
         CALL cl_set_comp_visible("info", TRUE)
         CALL cl_set_comp_visible("page5", FALSE)   #NO.FUN-840018 ADD
         CALL ui.interface.refresh()                #NO.FUN-840018 ADD
         CALL cl_set_comp_visible("page5", TRUE)
         #CONTINUE DIALOG     #NO.FUN-840018 ADD    #MOD-B50076
         EXIT DIALOG                                #MOD-B50076

    

      ON ACTION cancel
             LET INT_FLAG=FALSE   #MOD-570244 mars
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about          #TQC-860021
         CALL cl_about()       #TQC-860021

     
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

      ON ACTION preview_bom
         LET g_action_choice = 'preview_bom'
         EXIT DIALOG


      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 

      #No:FUN-B70096 --START--
      ON ACTION OUTPUT
         LET g_action_choice = 'output'
         EXIT DIALOG
      #No:FUN-B70096 --END--

      &include "qry_string.4gl"

   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION

FUNCTION cbmq102c(p_bmb03)                                     #No:TQC-990023 add
   DEFINE  p_bmb03   LIKE bmb_file.bmb03
   IF p_bmb03 IS NULL THEN RETURN END IF
  #LET g_cmd = "abmq500 ","'",p_bmb03 CLIPPED,"'"  # 物料編號 #FUN-950065                   #No:TQC-990023 取消mark  #MOD-A30161 mark
   LET g_cmd = "abmq500 ","'",p_bmb03 CLIPPED,"' ","'",g_vdate,"'"  # 物料編號 #FUN-950065   #No:MOD-A30161 modify
   CALL cl_cmdrun(g_cmd)

END FUNCTION
 
FUNCTION cbmq1022_prompt()
    DEFINE l_cmd    LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(200),
           l_chr    LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(01),
           l_n      LIKE type_file.num5,    #No.FUN-680096 SMALLINT
           l_bmd02  LIKE bmd_file.bmd02     #MOD-9A0084
    DEFINE l_bmb16  LIKE bmb_file.bmb16     #TQC-C20419 add

  IF g_bmb[l_ac].bmb16 matches'[129]' THEN  #TQC-B90236
#TQC-C20419 ----- add ----- begin
     IF g_bmb[l_ac].bmb16 = '9' THEN
        LET l_bmb16 = '3'
     ELSE
        LET l_bmb16 = g_bmb[l_ac].bmb16
     END IF
#TQC-C20419 ----- add ----- end
     SELECT COUNT(*) INTO l_n FROM bmd_file
      WHERE bmd01 = g_bmb[l_ac].bmb03
        AND bmd02 = l_bmb16                 #TQC-C20419 modify 
        AND (bmd08 = 'ALL'
        OR bmd08 = g_bma.bma01)
        AND bmdacti = 'Y'                                           #CHI-910021
     IF l_n > 0 THEN
        IF NOT cl_confirm('abm-100') THEN RETURN END IF
     ELSE
        IF NOT cl_confirm('abm-200') THEN RETURN END IF
     END IF

     LET l_cmd = "abmi604 '",g_bmb[l_ac].bmb03,"' ",
                           "'",g_bma.bma01,      "' ",
                           "'",g_bmb[l_ac].bmb16,"' "
     CALL cl_cmdrun_wait(l_cmd)

     LET l_n = 0
     SELECT COUNT(*) INTO l_n FROM bmd_file
      WHERE bmd01=g_bmb[l_ac].bmb03
        AND bmdacti = 'Y'
     IF l_n = 0 THEN
        UPDATE bmb_file SET bmb16 = '0',
                            bmbdate=g_today     #FUN-C40007 add
         WHERE bmb01=g_bma.bma01 AND bmb03=g_bmb[l_ac].bmb03
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","bmb_file",g_bma.bma01,g_bmb[l_ac].bmb03,SQLCA.sqlcode,"","",0)
         END IF
     ELSE
        LET l_bmd02 = ''
        SELECT DISTINCT bmd02 INTO l_bmd02 FROM bmd_file
           WHERE bmd01=g_bmb[l_ac].bmb03 AND bmd08 = g_bma.bma01
             AND bmdacti = 'Y'
        IF NOT cl_null(l_bmd02) THEN
#TQC-C20419 ----- add ----- begin
           IF l_bmd02 = '3' THEN
              LET l_bmd02 = '9'
           END IF
#TQC-C20419 ----- add ----- end
           UPDATE bmb_file SET bmb16 = l_bmd02,
                               bmbdate=g_today     #FUN-C40007 add
            WHERE bmb01=g_bma.bma01 AND bmb03=g_bmb[l_ac].bmb03
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","bmb_file",g_bma.bma01,g_bmb[l_ac].bmb03,SQLCA.sqlcode,"","",0)
           END IF
        ELSE
           LET l_bmd02 = ''
           SELECT DISTINCT bmd02 INTO l_bmd02 FROM bmd_file
              WHERE bmd01=g_bmb[l_ac].bmb03 AND bmd08 = 'ALL'
                AND bmdacti = 'Y'
           IF NOT cl_null(l_bmd02) THEN
#TQC-C20419 ----- add ----- begin
              IF l_bmd02 = '3' THEN
                 LET l_bmd02 = '9'
              END IF
#TQC-C20419 ----- add ----- end
              UPDATE bmb_file SET bmb16 = l_bmd02,
                                  bmbdate=g_today     #FUN-C40007 add
               WHERE bmb01=g_bma.bma01 AND bmb03=g_bmb[l_ac].bmb03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","bmb_file",g_bma.bma01,g_bmb[l_ac].bmb03,SQLCA.sqlcode,"","",0)
              END IF
           END IF
        END IF
     END IF
     SELECT bmb16 INTO g_bmb[l_ac].bmb16 FROM bmb_file
       WHERE bmb01 = g_bma.bma01
         AND bmb29 = g_bma.bma06
         AND bmb02 = g_bmb[l_ac].bmb02
         AND bmb03 = g_bmb[l_ac].bmb03
         AND bmb04 = g_bmb[l_ac].bmb04
     DISPLAY BY NAME g_bmb[l_ac].bmb16
  ELSE
#FUN-A40058 --begin--
     IF g_bmb[l_ac].bmb16 matches'[7]' THEN
        SELECT COUNT(ima01) INTO l_n FROM ima_file,bon_file,bmb_file
         WHERE imaacti = 'Y'
           AND bmb03 = g_bmb[l_ac].bmb03
           AND bmb03 = bon01
           AND bmb01 = g_bma.bma01
           AND (bmb01 = bon02 or bon02 = '*')
           AND bmb16 = '7'
           AND bonacti = 'Y'
           AND ima251 = bon06
           AND ima109 = bon07
           AND ima54  = bon08
           AND ima022 BETWEEN bon04 AND bon05
           AND ima01 != bon01
         ORDER BY ima01

        IF l_n > 0 THEN
           IF NOT cl_confirm('abm-100') THEN RETURN END IF
        ELSE
           IF NOT cl_confirm('abm-200') THEN RETURN END IF
        END IF

        LET l_cmd = "abmi6043  "
        CALL cl_cmdrun_wait(l_cmd)
     END IF
#FUN-A40058 --end--
     IF g_bmb[l_ac].bmb16 = '5' THEN
        LET l_cmd = "abmi610 '",g_bma.bma01 CLIPPED,"' "
        CALL cl_cmdrun(l_cmd)
     END IF
  END IF
END FUNCTION

FUNCTION cbmq102_viewcad(p_path)
    DEFINE p_path          LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(256),
           l_viewcad_cmd   LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(512)

    IF NOT cl_null(p_path) THEN
       LET l_viewcad_cmd = "viewcad '",p_path,"'"
       RUN l_viewcad_cmd
    END IF
END FUNCTION
 
FUNCTION cbmq102_set_required(p_ans_1)
  DEFINE    p_ans_1       LIKE type_file.chr1      #No.FUN-680096   VARCHAR(1)
    IF p_ans_1 = '3' THEN
        CALL cl_set_comp_required("ef_date",TRUE)
    END IF
END FUNCTION

FUNCTION cbmq102_set_no_required(p_ans_1)
  DEFINE   p_ans_1        LIKE type_file.chr1      #No.FUN-680096  VARCHAR(1)
    CALL cl_set_comp_required("ef_date",FALSE)
END FUNCTION


#目標資料庫中若有不存在于來源資料庫的BOM結構,則輸出到Excel
FUNCTION cbmq102_err_msg(p_sql,p_tblname,p_dbname)
DEFINE p_tblname LIKE cre_file.cre08     #No.FUN-680096 VARCHAR(10)
DEFINE p_dbname  LIKE type_file.chr20    #No.FUN-680096 VARCHAR(20)
DEFINE p_sql     STRING
DEFINE l_ima01   LIKE ima_file.ima01
DEFINE l_ima02   LIKE ima_file.ima02
DEFINE l_n       LIKE type_file.num10    #No.FUN-680096 INTEGER

   IF cl_null(p_sql) THEN
      RETURN
   END IF
   PREPARE cbmq102_err_msg_p FROM p_sql
   DECLARE cbmq102_err_msg_c CURSOR FOR cbmq102_err_msg_p
   FOREACH cbmq102_err_msg_c INTO l_ima01,l_ima02
      IF cl_null(l_ima01) THEN
         CONTINUE FOREACH
      END IF
      LET l_n=g_itm.getlength()+1
      LET g_itm[l_n].db=p_dbname
      LET g_itm[l_n].tblname=p_tblname
      LET g_itm[l_n].ima01=l_ima01
      LET g_itm[l_n].ima02=l_ima02
   END FOREACH
   CLOSE cbmq102_err_msg_c
END FUNCTION  

FUNCTION preview_bom()
 DEFINE l_sql        STRING     #LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(400)  #MOD-6A0145
 DEFINE l_bma01      LIKE bma_file.bma01
 DEFINE l_ima01      LIKE ima_file.ima01
 DEFINE l_imaag      LIKE ima_file.imaag
 DEFINE l_imaag1     LIKE ima_file.imaag1
 DEFINE i,j          LIKE type_file.num10     #No.FUN-680096 INTEGER
 DEFINE l_name       LIKE agc_file.agc01
 DEFINE l_bom_str    STRING
 DEFINE l_bom_str1   STRING
 DEFINE l_bom_str2   STRING
 DEFINE l_result     STRING
 DEFINE l_result1    STRING
 DEFINE l_result2    STRING
 DEFINE bom_tmp1     DYNAMIC ARRAY OF RECORD
                     tmp1_agb03 LIKE agb_file.agb03
                     END RECORD
 DEFINE bom_arr      DYNAMIC ARRAY OF RECORD
                     name   LIKE agc_file.agc01,
                     value  LIKE type_file.chr20,  #No.FUN-680096 VARCHAR(20),
                     value1 LIKE type_file.chr20,  #No.FUN-680096 VARCHAR(20),
                     valued LIKE type_file.chr20   #No.FUN-680096 VARCHAR(20)
                     END RECORD
 DEFINE l_agb03      LIKE agb_file.agb03
 DEFINE l_agd03      LIKE agd_file.agd03
 DEFINE l_agd02      LIKE agd_file.agd02
 DEFINE l_agc01      LIKE agc_file.agc01,
        lsb_item     base.StringBuffer,
        lsb_value    base.StringBuffer,
        l_n          LIKE type_file.num5      #No.FUN-680096 SMALLINT
 DEFINE l_msg        STRING,
        l_msg1       STRING
 DEFINE l_agc02      LIKE agc_file.agc02
 DEFINE l_child      LIKE ima_file.ima01    #FUN-640139 Add

     OPEN WINDOW cl_fml_input_w2 WITH FORM "abm/42f/cbmq102_1"
                 ATTRIBUTE(STYLE = "report")
     CALL cl_ui_init()
     CALL cl_ui_locale("cbmq102_1")

     FOR i = 1 TO 10
         LET l_msg = 'att',2*i-1 USING '&&'
         LET l_msg1 = 'att',2*i USING '&&'
         CALL cl_set_comp_visible(l_msg,FALSE)
         CALL cl_set_comp_visible(l_msg1,FALSE)
     END FOR

     SELECT ima01,imaag,imaag1
       INTO l_ima01,l_imaag,l_imaag1
       FROM ima_file
      WHERE ima01 = g_bma.bma01


     IF (cl_null(l_imaag))OR(l_imaag = '@CHILD') THEN RETURN END IF

     LET l_sql = "SELECT agb03,agc01,agc02 from agb_file,aga_file,agc_file ",
                      " WHERE agb01 = aga01",
                      "   AND agb01 = '",l_imaag,"'",
                      "   AND agb03 = agc01 "


     PREPARE cbmq1021_tmp1 FROM l_sql
     DECLARE tmp1_lcur CURSOR FOR cbmq1021_tmp1


     LET i=1
     CALL g_att.clear()

     FOREACH tmp1_lcur INTO l_agb03,l_agc01,l_agc02
         #判斷循環的正確性
        IF STATUS THEN
           CALL cl_err('foreach agb',STATUS,0)
           EXIT FOREACH
        END IF

        #這些是我添加的填充lr_agc數組的代碼，該數組會在后面INPUT ARRAY調用的
        SELECT * INTO lr_agc[i].* FROM agc_file WHERE agc01 = l_agb03

        SELECT count(*) INTO l_n
          FROM agd_file
         WHERE agd01 = l_agc01

        IF l_n >0 THEN
          LET l_msg = 'att',2*i-1 USING '&&'
          LET l_msg1 = 'att',2*i USING '&&'
          CALL cl_set_comp_att_text(l_msg,l_agc02)
          CALL cl_set_comp_visible(l_msg,TRUE)
          CALL cl_set_comp_visible(l_msg1,FALSE)

          LET g_value[2*i-1].fname = l_msg
          LET g_value[2*i-1].visible = 'Y'
          LET g_value[2*i-1].imx000 = 'imx',i USING '&&'   #No.TQC-660059
          LET g_value[2*i-1].nvalue = l_agc01
          LET g_value[2*i].fname = l_msg1
          LET g_value[2*i].visible = 'N'
          LET g_value[2*i].imx000 = 'imx',i USING '&&'   #No.TQC-660059
          LET g_value[2*i].nvalue = ''
          #填充組合框中的選項
          LET lsb_item  = base.StringBuffer.create()
          LET lsb_value = base.StringBuffer.create()
          DECLARE agd_cur CURSOR FOR
          SELECT agd02,agd03 FROM agd_file
           WHERE agd01 = l_agb03
          FOREACH agd_cur INTO l_agd02,l_agd03
            IF STATUS THEN
               CALL cl_err('foreach agb',STATUS,0)
               EXIT FOREACH
            END IF
            IF lsb_value IS NULL THEN
                CALL lsb_value.append(l_agd03 CLIPPED || ":" ||l_agd03 CLIPPED || ",")
            ELSE
                CALL lsb_value.append(lsb_value || "," ||l_agd02|| ":" ||l_agd03 CLIPPED || ",")
            END IF
            IF lsb_item IS NULL THEN
                CALL lsb_item.append(l_agd02 CLIPPED || ",")
            ELSE
                CALL lsb_item.append(lsb_item || "," ||l_agd02 CLIPPED || ",")
            END IF
          END FOREACH
          CALL cl_set_combo_items(l_msg,lsb_item.toString(),
                                   lsb_value.toString())
        ELSE
          LET l_msg = 'att',2*i USING '&&'
          LET l_msg1= 'att',2*i-1 USING '&&'
          CALL cl_set_comp_att_text(l_msg ,l_agc02)
          CALL cl_set_comp_visible(l_msg,TRUE)
          CALL cl_set_comp_visible(l_msg1,FALSE)
          LET g_value[2*i].fname = l_msg
          LET g_value[2*i].visible = 'Y'
          LET g_value[2*i].imx000 = 'imx',i USING '&&'  #No.TQC-660059
          LET g_value[2*i].nvalue = l_agc01
          LET g_value[2*i-1].fname = l_msg1
          LET g_value[2*i-1].visible = 'N'
          LET g_value[2*i-1].imx000 = 'imx',i USING '&&'  #No.TQC-660059
          LET g_value[2*i-1].nvalue = ''
        END IF

        LET i = i + 1
        #這里防止下標溢出導致錯誤
        IF i = 11 THEN EXIT FOREACH END IF
     END FOREACH

     FOR i = i TO 10
        LET l_msg = 'att',2*i-1 USING '&&'
        LET l_msg1= 'att',2*i USING '&&'
        CALL cl_set_comp_visible(l_msg,FALSE)
        CALL cl_set_comp_visible(l_msg1,FALSE)
        LET g_value[2*i-1].fname = l_msg
        LET g_value[2*i-1].visible = 'N'
        LET g_value[2*i-1].imx000 = 'imx000',i USING '&&'  #No.TQC-660059
        LET g_value[2*i-1].nvalue = ''
        LET g_value[2*i].fname = l_msg1
        LET g_value[2*i].visible = 'N'
        LET g_value[2*i].imx000 = 'imx',i USING '&&'  #No.TQC-660059
        LET g_value[2*i].nvalue = ''
     END FOR

     INPUT ARRAY g_att WITHOUT DEFAULTS FROM s_arr.*
         ATTRIBUTE(COUNT=1,APPEND ROW=FALSE,INSERT ROW=FALSE,DELETE ROW=FALSE,
                   UNBUFFERED)

     BEFORE ROW
         LET l_ac = ARR_CURR()


   #因為修改太多處而且基本上都差不多，所以不單獨注釋了
   #原來的輸入型欄位att01,att03...att19都沒有加欄位檢核，這樣用戶可以亂輸并
   #生成不符合系統要求的料件，現在增加一個函數cbmq102_check_att0x來做檢核，并
   #在這些輸入型欄位的AFTER FIELD中進行調用

   #唯一需要注意的是p_index參數賦的值不是1,3,5...19，而是1,2,3...9


    AFTER FIELD att01
       IF NOT cl_null(g_att[l_ac].att01) THEN
          LET g_value[1].value = g_att[l_ac].att01 END IF

    AFTER FIELD att02
       IF NOT cl_null(g_att[l_ac].att02) THEN
          IF cbmq102_check_att0x(g_att[l_ac].att02,1) THEN
             LET g_value[2].value = g_att[l_ac].att02
          ELSE
             NEXT FIELD att02
          END IF
       END IF

    AFTER FIELD att03
       IF NOT cl_null(g_att[l_ac].att03) THEN
          LET g_value[3].value = g_att[l_ac].att03 END IF

    AFTER FIELD att04
       IF NOT cl_null(g_att[l_ac].att04) THEN
          IF cbmq102_check_att0x(g_att[l_ac].att04,2) THEN
             LET g_value[4].value = g_att[l_ac].att04
          ELSE
             NEXT FIELD att04
          END IF
       END IF

    AFTER FIELD att05
       IF NOT cl_null(g_att[l_ac].att05) THEN
          LET g_value[5].value = g_att[l_ac].att05 END IF

    AFTER FIELD att06
       IF NOT cl_null(g_att[l_ac].att06) THEN
          IF cbmq102_check_att0x(g_att[l_ac].att06,3) THEN
             LET g_value[6].value = g_att[l_ac].att06
          ELSE
             NEXT FIELD att06
          END IF
       END IF

    AFTER FIELD att07
       IF NOT cl_null(g_att[l_ac].att07) THEN
          LET g_value[7].value = g_att[l_ac].att07 END IF

    AFTER FIELD att08
       IF NOT cl_null(g_att[l_ac].att08) THEN
          IF cbmq102_check_att0x(g_att[l_ac].att08,4) THEN
             LET g_value[8].value = g_att[l_ac].att08
          ELSE
             NEXT FIELD att08
          END IF
       END IF

    AFTER FIELD att09
       IF NOT cl_null(g_att[l_ac].att09) THEN
          LET g_value[9].value = g_att[l_ac].att09 END IF

    AFTER FIELD att10
       IF NOT cl_null(g_att[l_ac].att10) THEN
          IF cbmq102_check_att0x(g_att[l_ac].att10,5) THEN
             LET g_value[10].value = g_att[l_ac].att10
          ELSE
             NEXT FIELD att10
          END IF
       END IF

    AFTER FIELD att11
       IF NOT cl_null(g_att[l_ac].att11) THEN
          LET g_value[11].value = g_att[l_ac].att11 END IF

    AFTER FIELD att12
       IF NOT cl_null(g_att[l_ac].att12) THEN
          IF cbmq102_check_att0x(g_att[l_ac].att12,6) THEN
             LET g_value[12].value = g_att[l_ac].att12
          ELSE
             NEXT FIELD att12
          END IF
       END IF

    AFTER FIELD att13
       IF NOT cl_null(g_att[l_ac].att13) THEN
          LET g_value[13].value = g_att[l_ac].att13 END IF

    AFTER FIELD att14
       IF NOT cl_null(g_att[l_ac].att14) THEN
          IF cbmq102_check_att0x(g_att[l_ac].att14,7) THEN
             LET g_value[14].value = g_att[l_ac].att14
          ELSE
             NEXT FIELD att14
          END IF
       END IF

    AFTER FIELD att15
       IF NOT cl_null(g_att[l_ac].att15) THEN
          LET g_value[15].value = g_att[l_ac].att15 END IF

    AFTER FIELD att16
       IF NOT cl_null(g_att[l_ac].att16) THEN
          IF cbmq102_check_att0x(g_att[l_ac].att16,8) THEN
             LET g_value[16].value = g_att[l_ac].att16
          ELSE
             NEXT FIELD att16
          END IF
       END IF

    AFTER FIELD att17
       IF NOT cl_null(g_att[l_ac].att17) THEN
          LET g_value[17].value = g_att[l_ac].att17 END IF

    AFTER FIELD att18
       IF NOT cl_null(g_att[l_ac].att18) THEN
          IF cbmq102_check_att0x(g_att[l_ac].att18,9) THEN
             LET g_value[18].value = g_att[l_ac].att18
          ELSE
             NEXT FIELD att18
          END IF
       END IF

    AFTER FIELD att19
       IF NOT cl_null(g_att[l_ac].att19) THEN
          LET g_value[19].value = g_att[l_ac].att19 END IF

    AFTER FIELD att20
       IF NOT cl_null(g_att[l_ac].att20) THEN
          IF cbmq102_check_att0x(g_att[l_ac].att20,10) THEN
             LET g_value[20].value = g_att[l_ac].att20
          ELSE
             NEXT FIELD att20
          END IF
       END IF


    AFTER INPUT
       IF INT_FLAG THEN
          EXIT INPUT
       END IF
       IF (cl_null(g_att[l_ac].att01) AND g_value[1].visible= 'Y') OR
          (cl_null(g_att[l_ac].att02) AND g_value[2].visible= 'Y') OR
          (cl_null(g_att[l_ac].att03) AND g_value[3].visible= 'Y') OR
          (cl_null(g_att[l_ac].att04) AND g_value[4].visible= 'Y') OR
          (cl_null(g_att[l_ac].att05) AND g_value[5].visible= 'Y') OR
          (cl_null(g_att[l_ac].att06) AND g_value[6].visible= 'Y') OR
          (cl_null(g_att[l_ac].att07) AND g_value[7].visible= 'Y') OR
          (cl_null(g_att[l_ac].att08) AND g_value[8].visible= 'Y') OR
          (cl_null(g_att[l_ac].att09) AND g_value[9].visible= 'Y') OR
          (cl_null(g_att[l_ac].att10) AND g_value[10].visible= 'Y') OR
          (cl_null(g_att[l_ac].att11) AND g_value[11].visible= 'Y') OR
          (cl_null(g_att[l_ac].att12) AND g_value[12].visible= 'Y') OR
          (cl_null(g_att[l_ac].att13) AND g_value[13].visible= 'Y') OR
          (cl_null(g_att[l_ac].att14) AND g_value[14].visible= 'Y') OR
          (cl_null(g_att[l_ac].att15) AND g_value[15].visible= 'Y') OR
          (cl_null(g_att[l_ac].att16) AND g_value[16].visible= 'Y') OR
          (cl_null(g_att[l_ac].att17) AND g_value[17].visible= 'Y') OR
          (cl_null(g_att[l_ac].att18) AND g_value[18].visible= 'Y') OR
          (cl_null(g_att[l_ac].att19) AND g_value[19].visible= 'Y') OR
          (cl_null(g_att[l_ac].att20) AND g_value[20].visible= 'Y')
       THEN
          CALL cl_err('','abm-997',0)
          IF g_value[1].visible = 'Y' THEN
              NEXT FIELD att01
          ELSE
              NEXT FIELD att02
          END IF
       END IF

    ON ACTION controlg       #TQC-860021
       CALL cl_cmdask()      #TQC-860021

    ON IDLE g_idle_seconds   #TQC-860021
       CALL cl_on_idle()     #TQC-860021
       CONTINUE INPUT        #TQC-860021

    ON ACTION about          #TQC-860021
       CALL cl_about()       #TQC-860021

    ON ACTION help           #TQC-860021
       CALL cl_show_help()   #TQC-860021
     END INPUT

     IF INT_FLAG THEN
        LET INT_FLAG = 0
     ELSE
        LET i = 1
        FOR i = 1 TO 20
            IF g_value[i].visible = 'Y' THEN
               LET l_bom_str = g_value[i].value
               LET l_bom_str = l_bom_str.trim()
               LET l_bom_str1 = g_value[i].nvalue
               LET l_bom_str1= l_bom_str1.trim()
               LET l_bom_str2= '#',l_bom_str1,'#'
               LET l_result1 = l_result1,g_sma.sma46,l_bom_str
               LET l_sql = "SELECT agd03,agc01",
                           "  FROM agd_file,agc_file",
                           " WHERE agd02 = '",l_bom_str,"'",
                           "   AND agd01 = agc01 ",
                           "   AND agc01 = '",l_bom_str1,"'"
               PREPARE cbmq1021_tmp3 FROM l_sql
               DECLARE tmp3_lcur CURSOR FOR cbmq1021_tmp3
               LET l_agd03 = ''
               LET l_agc01 = ''
               FOREACH tmp3_lcur INTO l_agd03,l_agc01
                  LET l_result2 = l_result2,g_sma.sma46,l_agd03
                  LET l_result = l_result,l_bom_str2,'|',l_bom_str,'|'
               END FOREACH
               IF SQLCA.sqlcode=100 OR cl_null(l_agc01) THEN
                  LET l_result2 = l_result2,g_sma.sma46,l_bom_str
                  LET l_sql = " SELECT agc01 FROM agc_file ",
                              "  WHERE agc01='",l_bom_str1,"'"
                  PREPARE cbmq1021_tmp4 FROM l_sql
                  DECLARE tmp4_lcur CURSOR FOR cbmq1021_tmp4
                  FOREACH tmp4_lcur INTO l_agc01
                     LET l_result = l_result,'#',l_agc01,'#|',l_bom_str,'|'
                  END FOREACH
               END IF
           END IF
        END FOR
        LET l_result = l_result.substring(1,length(l_result)-1)
        LET l_bma01 = g_bma.bma01

        #這里增加一個判斷，如果該多屬性子料件已經存在BOM并已經發放，則不允許后面的操作
        LET l_child = l_bma01 CLIPPED || l_result1.trim()
        SELECT COUNT(*) INTO l_n FROM bma_file WHERE bma01 = l_child AND NOT( bma05 IS NULL )
        IF l_n > 0 THEN
           CALL cl_err('','abm-989',1)
        ELSE
         #   CALL cbmq102_2(l_bma01,l_result,l_result1,l_result2)  #這一句是原來的
        END IF

     END IF
     CLOSE WINDOW cl_fml_input_w2

END FUNCTION

FUNCTION preview_bom_test()
DEFINE
       l_sql       STRING      #NO.FUN-910082
DEFINE l_count    LIKE type_file.num5     #No.FUN-680096 SMALLINT

     SELECT count(*)
       INTO l_count
       FROM bmb_file
      WHERE bmb01 = g_bma.bma01
        AND bmb30='3'

    IF l_count = 0 THEN
        CALL cl_set_act_visible("preview_bom", FALSE)
    ELSE
       CALL preview_bom()
    END IF
END FUNCTION

#用于att01,att03...att19這十個輸入型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att19)
#如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE
#該函數從saxmt400的t400_check_att0x函數拷貝而來，因為只是單行輸入，且不需要合成
#imx_file資料，所以進行了相應簡化
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION cbmq102_check_att0x(p_value,p_index)
DEFINE
  p_value      LIKE imx_file.imx01,
  p_index      LIKE type_file.num5,       #No.FUN-680096  SMALLINT,
  li_min_num   LIKE agc_file.agc05,
  li_max_num   LIKE agc_file.agc06,
  l_index      STRING,

  l_imaacti       LIKE ima_file.imaacti,
  l_ima130        LIKE ima_file.ima130,   #No.FUN-680096  VARCHAR(1),
  l_ima131        LIKE ima_file.ima131,   #No.FUN-680096  VARCHAR(10),
  l_ima25         LIKE ima_file.ima25

  #這里使用到了一個用于存放當前屬性組包含的所有屬性信息的全局數組lr_agc
  #該數組會由preview_bom()函數在窗體show出來之前填充

  #判斷長度與定義的使用位數是否相等
  IF LENGTH(p_value CLIPPED) <> lr_agc[p_index].agc03 THEN
     CALL cl_err_msg("","aim-911",lr_agc[p_index].agc03,1)
     RETURN FALSE
  END IF
  #比較大小是否在合理范圍之內
  LET li_min_num = lr_agc[p_index].agc05
  LET li_max_num = lr_agc[p_index].agc06
  IF (lr_agc[p_index].agc05 IS NOT NULL) AND
     (p_value < li_min_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE
  END IF
  IF (lr_agc[p_index].agc06 IS NOT NULL) AND
     (p_value > li_max_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE
  END IF
  RETURN TRUE
END FUNCTION
 
FUNCTION cbmq102_set_bmb30()
   DEFINE lcbo_target ui.ComboBox

   LET lcbo_target = ui.ComboBox.forName("bmb30")
   CALL lcbo_target.RemoveItem("2")
   CALL lcbo_target.RemoveItem("3")
END FUNCTION
FUNCTION cbmq102_set_bmb30_1()
   DEFINE lcbo_target ui.ComboBox

   LET lcbo_target = ui.ComboBox.forName("bmb30")
   CALL lcbo_target.RemoveItem("4")
END FUNCTION
 

FUNCTION cbmq102_bmb30(p_bmb30,p_bmb03)
DEFINE p_bmb30    LIKE bmb_file.bmb30,
       p_bmb03    LIKE bmb_file.bmb03,
       l_success  LIKE type_file.chr1,
       l_ima151   LIKE ima_file.ima151,
       r_ima151   LIKE ima_file.ima151

       LET l_success ='Y'

      SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_bma.bma01
      SELECT ima151 INTO r_ima151 FROM ima_file WHERE ima01 = g_bmb[l_ac].bmb03
      IF l_ima151<>'Y' THEN
            IF g_bmb[l_ac].bmb30<>'1' OR  (NOT cl_null(r_ima151) AND r_ima151 = 'Y'  )THEN
              CALL cl_err('','abm-326',0)
              LET l_success = 'N'
              RETURN l_success
            END IF
      ELSE
          IF NOT cl_null(r_ima151) AND r_ima151 <> 'Y'  THEN
             IF g_bmb[l_ac].bmb30 = '4' THEN
                CALL cl_err('','abm-000',0)
                LET l_success ='N'
                RETURN l_success
             END IF
          ELSE
               IF g_bmb[l_ac].bmb30 = '1' THEN
                  CALL cl_err('','abm-325',0)
                  LET l_success ='N'
                  RETURN l_success
               END IF
           END IF
        END IF

       RETURN l_success
END FUNCTION

#根據不同的行業動態顯示按鈕名稱
FUNCTION cbmq102_set_act_title(ps_act_names, pi_title)
   DEFINE   ps_act_names    STRING,
            pi_title        STRING
   DEFINE   la_act_type     DYNAMIC ARRAY OF STRING,
            lnode_root      om.DomNode,
            li_i            LIKE type_file.num5,
            lst_act_names   base.StringTokenizer,
            ls_act_name     STRING,
            llst_items      om.NodeList,
            li_j            LIKE type_file.num5,
            lnode_item      om.DomNode,
            ls_item_name    STRING,
            ls_item_tag     STRING

   IF g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]"  THEN
      RETURN
   END IF

   IF (ps_act_names IS NULL) THEN
      RETURN
   ELSE
      LET ps_act_names = ps_act_names.toLowerCase()
   END IF


   LET la_act_type[1] = "ActionDefault"
   LET la_act_type[2] = "LocalAction"
   LET la_act_type[3] = "Action"
   LET la_act_type[4] = "MenuAction"
   LET lnode_root = ui.Interface.getRootNode()
   FOR li_i = 1 TO la_act_type.getLength()
      LET lst_act_names = base.StringTokenizer.create(ps_act_names, ",")
      WHILE lst_act_names.hasMoreTokens()
         LET ls_act_name = lst_act_names.nextToken()
         LET ls_act_name = ls_act_name.trim()
         LET llst_items = lnode_root.selectByTagName(la_act_type[li_i])

         FOR li_j = 1 TO llst_items.getLength()
            LET lnode_item = llst_items.item(li_j)
            LET ls_item_name = lnode_item.getAttribute("name")
            IF (ls_item_name IS NULL) THEN
               CONTINUE FOR
            END IF

            IF (ls_item_name.equals(ls_act_name)) THEN
                CALL lnode_item.setAttribute("text",pi_title)
               EXIT FOR
            END IF
         END FOR
      END WHILE
   END FOR
END FUNCTION
#No:FUN-9C0077

###FUN-9A50010 START ###
##################################################
# Descriptions...: Tree填充
# Date & Author..: 10/05/05 By huangtao
# Input Parameter: p_wc,p_pid,p_level,p_key1,p_key2
# Return code....:
##################################################
#FUNCTION cbmq102_tree_fill(p_wc,p_pid,p_level,p_path,p_key1,p_key2 )            #FUN-B90117
 FUNCTION cbmq102_tree_fill(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_bma01)     #FUN-B90117
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路徑
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE p_bma01            LIKE bma_file.bma01             #FUN-B90117
    DEFINE l_child          INTEGER
   DEFINE l_bma              DYNAMIC ARRAY OF RECORD
             bma01           LIKE bma_file.bma01,
             bmb03           LIKE bmb_file.bmb03,
             child_cnt       LIKE type_file.num5  #子節點數
             END RECORD
   DEFINE l_ima02            LIKE ima_file.ima02  #品名
   DEFINE l_bmb              DYNAMIC ARRAY OF RECORD
              bmb02           LIKE bmb_file.bmb02,   #MOD-CC0278 add
              bmb03           LIKE bmb_file.bmb03,
              ima02           LIKE ima_file.ima02,
              bmb06           LIKE bmb_file.bmb06,
              bmb07           LIKE bmb_file.bmb07,
              bmb10           LIKE bmb_file.bmb10
            #  child_cnt       LIKE type_file.num5
              END RECORD
  DEFINE  l_sql              STRING

   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴圈.
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5



   LET max_level = 20 #設定最大階層數為20
   IF cl_null(p_wc) THEN LET p_wc = ' 1=1' END IF   #MOD-C70011 add

   IF p_level = 0 THEN
      LET g_idx = 0
      LET p_level = 1
      CALL g_tree.clear()
      CALL l_bma.clear()


      #讓QBE出來的單頭都當作Tree的最上層
      IF l_ac = 0 THEN
          LET l_ac = 1
          LET l_sql = "SELECT DISTINCT bmb01,bmb01 as bmb03,COUNT(bmb03) as child_cnt FROM bmb_file,bma_file",
                  " WHERE ", p_wc CLIPPED,
                  " AND bmb01 = bma_file.bma01 ",
#                 " AND bma01= '",g_bma_l[l_ac].bma01_l CLIPPED,"'",             #FUN-B90117
                  " AND bma01= '",p_bma01 CLIPPED,"'",             #FUN-B90117
                  " AND bmb29 = bma06",                            #FUN-C20105                 
                  " GROUP BY bmb01",
                  " ORDER BY bmb01"
      ELSE

         LET l_sql = "SELECT DISTINCT bmb01,bmb01 as bmb03,COUNT(bmb03) as child_cnt FROM bmb_file,bma_file",
                  " WHERE ", p_wc CLIPPED,
                  " AND bmb01 = bma_file.bma01 ",
#                 " AND bma01= '",g_bma_l[l_ac].bma01_l CLIPPED,"'",             #FUN-B90117
                  " AND bma01= '",p_bma01 CLIPPED,"'",             #FUN-B90117
                  " AND bmb29 = bma06",                            #FUN-C20105                         
                  " GROUP BY bmb01",
                  " ORDER BY bmb01"

      END IF

      PREPARE cbmq102_tree_pre1 FROM l_sql
      DECLARE cbmq102_tree_cs1 CURSOR FOR cbmq102_tree_pre1

      LET l_i = 1
      FOREACH cbmq102_tree_cs1 INTO l_bma[l_i].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF

       IF g_tree_sel = '2' THEN    #FUN-B90117
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = NULL
         LET l_str = l_i  #數值轉字串
         LET g_tree[g_idx].id = l_str
         LET g_tree[g_idx].expanded = TRUE    #TRUE:展開, FALSE:不展開
         LET l_ima02 = NULL
         SELECT ima02 INTO l_ima02 FROM ima_file
            WHERE ima01 = l_bma[l_i].bma01
         LET g_tree[g_idx].name = get_field_name("bma01"),":",l_bma[l_i].bma01,
                                 "(",get_field_name("ima02"),":",l_ima02,")"
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = l_bma[l_i].bmb03
         LET g_tree[g_idx].treekey1 = l_bma[l_i].bma01
         LET g_tree[g_idx].treekey2 = l_bma[l_i].bmb03
        # 有子節點
         IF l_bma[l_i].child_cnt > 0 THEN
            LET g_tree[g_idx].has_children = TRUE
#           CALL cbmq102_tree_fill(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,g_tree[g_idx].treekey1,g_tree[g_idx].treekey2) #FUN-B90117
            CALL cbmq102_tree_fill(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,g_tree[g_idx].treekey1,g_tree[g_idx].treekey2,l_bma[l_i].bma01) #FUN-B90117
         ELSE
            LET g_tree[g_idx].has_children = FALSE
         END IF
       END IF       #FUN-B90117

#FUN-B90117--BEGIN--
       IF g_tree_sel='1' THEN
         LET g_idx = g_idx + 1
         LET g_tree1[g_idx].pid1 = NULL
         LET l_str = l_i  #數值轉字串
         LET g_tree1[g_idx].id1 = l_str
         LET g_tree1[g_idx].expanded1 = TRUE    #TRUE:展開, FALSE:不展開
         LET l_ima02 = NULL
         SELECT ima02 INTO l_ima02 FROM ima_file
            WHERE ima01 = l_bma[l_i].bma01
         LET g_tree1[g_idx].name1 = l_bma[l_i].bma01,
                                 "(",get_field_name("ima02"),":",l_ima02,")"
         LET g_tree1[g_idx].level1 = p_level
         LET g_tree1[g_idx].path1 = l_bma[l_i].bmb03
         LET g_tree1[g_idx].treekey3 = l_bma[l_i].bma01
         LET g_tree1[g_idx].treekey4 = l_bma[l_i].bmb03
#FUN-CB0078 ------Begin------
#FUN-C20105 --unmark begin--         
#        IF g_lock='Y' THEN
#           LET g_tree1[g_idx].img = "lock.png"
#        ELSE
#           LET g_tree1[g_idx].img = " "
#        END IF
#FUN-C20105 --unmark end--
#FUN-CB0078 ------End--------

        # 有子節點
         IF l_bma[l_i].child_cnt > 0 THEN
            LET g_tree1[g_idx].has_children1 = TRUE
            CALL cbmq102_tree_fill(p_wc,g_tree1[g_idx].id1,p_level,g_tree1[g_idx].path1,g_tree1[g_idx].treekey3,g_tree1[g_idx].treekey4,l_bma[l_i].bma01)
         ELSE
            LET g_tree1[g_idx].has_children1 = FALSE
         END IF
       END IF
#FUN-B90117 --END--

         LET l_i = l_i + 1
      END FOREACH

   ELSE
#   IF p_level =1 THEN                  #FUN-B90117
    IF p_level <= 20 THEN               #FUN-B90117
      LET p_level = p_level + 1   #下一階層
      IF p_level > max_level THEN
         CALL cl_err_msg("","agl1001",max_level,0)
         RETURN
      END IF

       #LET l_sql = "SELECT UNIQUE bmb03,ima02,bmb06,bmb07,bmb10 ",
        LET l_sql = "SELECT UNIQUE bmb02,bmb03,ima02,bmb06,bmb07,bmb10 ",   #MOD-CC0278 add bmb02
#                   " FROM  bmb_file LEFT JOIN ima_file ON bmb03 = ima_file.ima01 ",   #FUN-C20105 
                    " FROM  bma_file,bmb_file LEFT JOIN ima_file ON bmb03 = ima_file.ima01 ",   #FUN-C20105                     
                    "WHERE  bmb01 = '", p_key1 CLIPPED,"'",
                    " AND bma06 = '",g_bma.bma06,"'",                #MOD-D20147
                    " AND bmb29 = bma06",                            #FUN-C20105                    
                    " AND bmb01 = bma01",                            #FUN-C20105                     
                   # " GROUP BY bmb03",
                   #" ORDER BY bmb03"
                    " ORDER BY bmb02"   #MOD-CC0278 bmb03 -> bmb02
###No.FUN-A50010 by dxfwo ####
       IF NOT cl_null(g_vdate) THEN  #FUN-A50010
       #LET l_sql = "SELECT UNIQUE bmb03,ima02,bmb06,bmb07,bmb10 ",
        LET l_sql = "SELECT UNIQUE bmb02,bmb03,ima02,bmb06,bmb07,bmb10 ",   #MOD-CC0278 add bmb02
#                   " FROM bmb_file LEFT JOIN ima_file ON bmb03 = ima_file.ima01 ",   #FUN-C20105 
                    " FROM bma_file,bmb_file LEFT JOIN ima_file ON bmb03 = ima_file.ima01 ",   #FUN-C20105 
                    "WHERE  bmb01 = '", p_key1 CLIPPED,"'",
                    "  AND  bma06 =  '",g_bma.bma06,"'",                        #MOD-D20147
                    "  AND (bmb04 <='", g_vdate,"'"," OR bmb04 IS NULL )",
                    "  AND (bmb05 >  '",g_vdate,"'"," OR bmb05 IS NULL )",
                    " AND bmb29 = bma06",                            #FUN-C20105     
                    " AND bmb01 = bma01",                            #FUN-C20105                      
                   #" ORDER BY bmb03"
                    " ORDER BY bmb02"   #MOD-CC0278 bmb03 -> bmb02
       END IF
###No.FUN-A50010####
      PREPARE cbmq102_tree_pre2 FROM l_sql
      DECLARE cbmq102_tree_cs2 CURSOR FOR cbmq102_tree_pre2

      #在FOREACH中直接使用遞迴,資料會錯亂,所以先將資料放到陣列後,在FOR迴圈處理
      LET l_cnt = 1
      CALL l_bmb.clear()
      FOREACH cbmq102_tree_cs2 INTO l_bmb[l_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL l_bmb.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列
      LET l_cnt = l_cnt - 1

      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
          IF g_tree_sel = '2' THEN   #FUN-B90117
            LET g_idx = g_idx + 1
            LET g_tree[g_idx].pid = p_pid CLIPPED
            LET l_str = l_i  #數值轉字串
            LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str
            LET g_tree[g_idx].expanded = TRUE   #TRUE:展開, FALSE:不展開
            --SELECT ima02 INTO l_ima02 FROM ima_file
            --WHERE ima01 = l_bmb[l_i].bmb01 AND imaacti='Y'
            LET g_tree[g_idx].name = get_field_name("bmb03"),":",l_bmb[l_i].bmb03,
                                     "(",get_field_name("ima02"),":",l_bmb[l_i].ima02,
                                     "):",get_field_name("bmb06"),":",l_bmb[l_i].bmb06,
                                     "/",get_field_name("bmb07"),":",l_bmb[l_i].bmb07,
                                     " ",get_field_name("bmb10"),":",l_bmb[l_i].bmb10

            LET g_tree[g_idx].level = p_level
            LET g_tree[g_idx].path = p_path CLIPPED,".",l_bmb[l_i].bmb03
            LET g_tree[g_idx].treekey1 = l_bma[l_i].bma01
            LET g_tree[g_idx].treekey2 = l_bmb[l_i].bmb03
            #有子節點
            IF NOT cl_null(g_vdate) THEN                   #MOD-D20147
               SELECT COUNT(bmb03) INTO l_child FROM bmb_file WHERE bmb01 = l_bmb[l_i].bmb03
               AND (bmb04 <= g_vdate OR bmb04 IS NULL )  #FUN-B90117
               AND (bmb05 >g_vdate OR bmb05 IS NULL )    #FUN-B90117
          #MOD-D20147-add-start      
            ELSE  
                SELECT COUNT(bmb03) INTO l_child FROM bmb_file
                WHERE bmb01 = l_bmb[l_i].bmb03
                AND (bmb04 <= g_today OR bmb04 IS NULL )  
                AND (bmb05 >g_today OR bmb05 IS NULL )    
            END IF
          #MOD-D20147-add-end    

            IF l_child > 0 AND p_level <= max_level THEN #TQC-C60239
               LET g_tree[g_idx].has_children = TRUE
               CALL cbmq102_tree_fill2(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,g_tree[g_idx].treekey1,g_tree[g_idx].treekey2)
            ELSE
               LET g_tree[g_idx].has_children = FALSE
            END IF
           END IF       #FUN-B90117

#FUN-B90117--begin--
          IF  g_tree_sel='1' THEN
            LET g_idx = g_idx + 1
            LET g_tree1[g_idx].pid1 = p_pid CLIPPED
            LET l_str = l_i  #數值轉字串
            LET g_tree1[g_idx].id1 = g_tree1[g_idx].pid1,".",l_str
            LET g_tree1[g_idx].expanded1 = TRUE   #TRUE:展開, FALSE:不展開
            --SELECT ima02 INTO l_ima02 FROM ima_file
            --WHERE ima01 = l_bmb[l_i].bmb01 AND imaacti='Y'
            LET g_tree1[g_idx].name1 = l_bmb[l_i].bmb03,
                                     "(",get_field_name("ima02"),":",l_bmb[l_i].ima02,")"

            LET g_tree1[g_idx].s1=l_bmb[l_i].bmb06
            LET g_tree1[g_idx].s2=l_bmb[l_i].bmb07
            LET g_tree1[g_idx].s3=l_bmb[l_i].bmb10
            LET g_tree1[g_idx].level1 = p_level
            LET g_tree1[g_idx].path1 = p_path CLIPPED,".",l_bmb[l_i].bmb03
            LET g_tree1[g_idx].treekey3 = l_bma[l_i].bma01
            LET g_tree1[g_idx].treekey4 = l_bmb[l_i].bmb03
            #有子節點
            IF NOT cl_null(g_vdate) THEN                   #MOD-D20147
               SELECT COUNT(bmb03) INTO l_child FROM bmb_file WHERE bmb01 = l_bmb[l_i].bmb03
               AND (bmb04 <= g_vdate OR bmb04 IS NULL )
               AND (bmb05 >g_vdate OR bmb05 IS NULL )
        #MOD-D20147-add-start      
            ELSE  
                SELECT COUNT(bmb03) INTO l_child FROM bmb_file
                WHERE bmb01 = l_bmb[l_i].bmb03
                AND (bmb04 <= g_today OR bmb04 IS NULL )  
                AND (bmb05 >g_today OR bmb05 IS NULL )    
            END IF
        #MOD-D20147-add-end 


            IF l_child > 0 AND p_level <= max_level THEN #TQC-C60239
               LET g_tree1[g_idx].has_children1 = TRUE
               CALL cbmq102_tree_fill2(p_wc,g_tree1[g_idx].id1,p_level,g_tree1[g_idx].path1,g_tree1[g_idx].treekey3,g_tree1[g_idx].treekey4)
            ELSE
               LET g_tree1[g_idx].has_children1 = FALSE
            END IF
           END IF
#FUN-B90117--end--
          END FOR
      END IF

      END IF
   END IF
END FUNCTION

##################################################
# Descriptions...: Tree填充
# Date & Author..: 10/05/05 By huangtao
# Input Parameter: p_wc,p_pid,p_level,p_key1,p_key2
# Return code....:
##################################################
FUNCTION  cbmq102_tree_fill2(p_wc,p_pid,p_level,p_path,p_key1,p_key2 )
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路徑
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE l_child            INTEGER
   DEFINE l_bmb              DYNAMIC ARRAY OF RECORD
              bmb03           LIKE bmb_file.bmb03,
              ima02           LIKE ima_file.ima02,
              bmb06           LIKE bmb_file.bmb06,
              bmb07           LIKE bmb_file.bmb07,
              bmb10           LIKE bmb_file.bmb10
           #  child_cnt       LIKE type_file.num5
              END RECORD
  DEFINE  l_sql              STRING

   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴圈.
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5

   LET max_level = 20 #設定最大階層數為20  #TQC-C60239
#  LET p_level =3           #FUN-B90117
   LET p_level = p_level+1  #FUN-B90117

   #TQC-C60239--add--str--
   IF p_level > max_level THEN
      CALL cl_err_msg("","mfg-087",max_level,1)
      RETURN
   END IF
   #TQC-C60239--add--end--

   LET l_sql = "SELECT UNIQUE bmb03,ima02,bmb06,bmb07,bmb10 ",
                " FROM bmb_file LEFT JOIN ima_file ON bmb03 = ima_file.ima01 ",
                "WHERE  bmb01 = '", p_key2 CLIPPED,"'",
              # " GROUP BY bmb03",
                " ORDER BY bmb03"

###No.FUN-A50010 by dxfwo ####
   IF NOT cl_null(g_vdate) THEN  #FUN-A50010
      LET l_sql = "SELECT UNIQUE bmb03,ima02,bmb06,bmb07,bmb10 ",
                   " FROM bmb_file LEFT JOIN ima_file ON bmb03 = ima_file.ima01 ",
                   "WHERE  bmb01 = '", p_key2 CLIPPED,"'",
                   "  AND (bmb04 <='", g_vdate,"'"," OR bmb04 IS NULL )",
                   "  AND (bmb05 >  '",g_vdate,"'"," OR bmb05 IS NULL )",
                   " ORDER BY bmb03"

   END IF
###No.FUN-A50010####

    PREPARE cbmq102_tree_pre3 FROM l_sql
    DECLARE cbmq102_tree_cs3 CURSOR FOR cbmq102_tree_pre3

      #在FOREACH中直接使用遞迴,資料會錯亂,所以先將資料放到陣列後,在FOR迴圈處理
   LET l_cnt = 1
   CALL l_bmb.clear()
   FOREACH cbmq102_tree_cs3 INTO l_bmb[l_cnt].*
     IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
     END IF
         LET l_cnt = l_cnt + 1
   END FOREACH
     CALL l_bmb.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列
     LET l_cnt = l_cnt - 1

      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
           IF g_tree_sel = '2' THEN     #FUN-B90117
            LET g_idx = g_idx + 1
            LET g_tree[g_idx].pid = p_pid CLIPPED
            LET l_str = l_i  #數值轉字串
            LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str
            LET g_tree[g_idx].expanded = TRUE    #TRUE:展開, FALSE:不展開
            --SELECT ima02 INTO l_ima02 FROM ima_file
            --WHERE ima01 = l_bmb[l_i].bmb01 AND imaacti='Y'
            LET g_tree[g_idx].name = get_field_name("bmb03"),l_bmb[l_i].bmb03,
                                    "(",get_field_name("ima02"),":",l_bmb[l_i].ima02,
                                    "):",get_field_name("bmb06"),":",l_bmb[l_i].bmb06,
                                    "/",get_field_name("bmb07"),":",l_bmb[l_i].bmb07,
                                    "  ",get_field_name("bmb10"),":",l_bmb[l_i].bmb10
            LET g_tree[g_idx].level = p_level
            LET g_tree[g_idx].path = p_path CLIPPED,".",l_bmb[l_i].bmb03
            --LET g_tree[g_idx].treekey1 = l_bma[l_i].bma01
            LET g_tree[g_idx].treekey2 = l_bmb[l_i].bmb03

#FUN-B90117 --BEGIN--
            IF NOT cl_null(g_vdate) THEN                   #MOD-D20147
               SELECT COUNT(bmb03) INTO l_child FROM bmb_file WHERE bmb01 = l_bmb[l_i].bmb03
               AND (bmb04 <= g_vdate OR bmb04 IS NULL )
               AND (bmb05 >g_vdate OR bmb05 IS NULL )
         #MOD-D20147-add-start      
            ELSE  
                SELECT COUNT(bmb03) INTO l_child FROM bmb_file
                WHERE bmb01 = l_bmb[l_i].bmb03
                AND (bmb04 <= g_today OR bmb04 IS NULL )  
                AND (bmb05 >g_today OR bmb05 IS NULL )    
            END IF
        #MOD-D20147-add-end 
            IF l_child > 0 AND p_level <= max_level THEN #TQC-C60239
               LET g_tree[g_idx].has_children = TRUE
               CALL cbmq102_tree_fill2(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,g_tree[g_idx].treekey1,g_tree[g_idx].treekey2)
            ELSE
               LET g_tree[g_idx].has_children = FALSE
            END IF
           END IF

         IF g_tree_sel='1' THEN
            LET g_idx = g_idx + 1
            LET g_tree1[g_idx].pid1 = p_pid CLIPPED
            LET l_str = l_i  #數值轉字串
            LET g_tree1[g_idx].id1 = g_tree1[g_idx].pid1,".",l_str
            LET g_tree1[g_idx].expanded1 = TRUE    #TRUE:展開, FALSE:不展開
           #SELECT ima02 INTO l_ima02 FROM ima_file
           # WHERE ima01 = l_bmb[l_i].bmb01 AND imaacti='Y'
            LET g_tree1[g_idx].name1 = l_bmb[l_i].bmb03,
                                    "(",get_field_name("ima02"),":",l_bmb[l_i].ima02,")"

            LET g_tree1[g_idx].s1=l_bmb[l_i].bmb06
            LET g_tree1[g_idx].s2=l_bmb[l_i].bmb07
            LET g_tree1[g_idx].s3=l_bmb[l_i].bmb10

            LET g_tree1[g_idx].level1 = p_level
            LET g_tree1[g_idx].path1 = p_path CLIPPED,".",l_bmb[l_i].bmb03
            #LET g_tree[g_idx].treekey1 = l_bma[l_i].bma01
            LET g_tree1[g_idx].treekey4 = l_bmb[l_i].bmb03
            
            IF NOT cl_null(g_vdate) THEN                   #MOD-D20147
               SELECT COUNT(bmb03) INTO l_child FROM bmb_file WHERE bmb01 = l_bmb[l_i].bmb03
               AND (bmb04 <= g_vdate OR bmb04 IS NULL )
               AND (bmb05 >g_vdate OR bmb05 IS NULL )
        #MOD-D20147-add-start      
            ELSE  
                SELECT COUNT(bmb03) INTO l_child FROM bmb_file
                WHERE bmb01 = l_bmb[l_i].bmb03
                AND (bmb04 <= g_today OR bmb04 IS NULL )  
                AND (bmb05 >g_today OR bmb05 IS NULL )    
            END IF
        #MOD-D20147-add-end 

            IF l_child > 0 AND p_level <= max_level THEN #TQC-C60239
               LET g_tree1[g_idx].has_children1 = TRUE
               CALL cbmq102_tree_fill2(p_wc,g_tree1[g_idx].id1,p_level,g_tree1[g_idx].path1,g_tree1[g_idx].treekey3,g_tree1[g_idx].treekey4)
            ELSE
               LET g_tree1[g_idx].has_children1 = FALSE
            END IF
           END IF
#FUN-B90117--END--
         END FOR
      END IF

END FUNCTION



##################################################
# Descriptions...: 依tree path指定focus節點
# Date & Author..: 10/05/05 By huangtao
# Input Parameter:
# Return code....:
##################################################
FUNCTION cbmq102_tree_idxbypath()
   DEFINE l_i       LIKE type_file.num5

   LET g_tree_focus_idx = 1
   FOR l_i = 1 TO g_tree.getlength()
      IF g_tree[l_i].path = g_tree_focus_path THEN
            LET g_tree_focus_idx = l_i
            EXIT FOR
      END IF
   END FOR
END FUNCTION

##################################################
# Descriptions...: 展開節點
# Date & Author..: 10/05/05 By huangtao
# Input Parameter: p_idx
# Return code....:
##################################################
FUNCTION cbmq102_tree_open(p_idx)
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
            CALL cbmq102_tree_open(l_openpidx)
         END IF
      END IF
   END IF
END FUNCTION


##################################################
# Descriptions...: 檢查是否為無窮迴圈
# Date & Author..: 10/05/05 By huangtao
# Input Parameter: p_key1,p_addkey2,p_flag
# Return code....: l_loop
##################################################
#TQC-C60231  #此函數修改為檢測主件料號是否存在于元件料號下階
FUNCTION cbmq102_tree_loop(p_key1,p_addkey2,p_flag)
   DEFINE p_key1             STRING
   DEFINE p_addkey2          STRING               #要增加的節點key2
   DEFINE p_flag             LIKE type_file.chr1  #是否已跑遞迴
   DEFINE l_bmb              DYNAMIC ARRAY OF RECORD
              bmb03           LIKE bmb_file.bmb03,
              ima02           LIKE ima_file.ima02,
              bmb06           LIKE bmb_file.bmb06,
              bmb07           LIKE bmb_file.bmb07,
              bmb10           LIKE bmb_file.bmb10
            #  child_cnt       LIKE type_file.num5
              END RECORD
   DEFINE l_child            INTEGER
   DEFINE l_ima02            LIKE ima_file.ima02  #部門名稱
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴圈.
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_loop             LIKE type_file.chr1  #是否為無窮迴圈Y/N

   IF cl_null(p_flag) THEN   #第一次進遞迴
      LET g_idx = 1
      LET g_path_add[g_idx] = p_addkey2  
      #TQC-C60231--add--str--   #如果主料與元料相同
      IF g_path_add[g_idx] = p_key1 THEN 
         LET l_loop = "Y"
         RETURN l_loop
      END IF
      #TQC-C60231--add--end--
   END IF
   LET p_flag = "Y"
   IF cl_null(l_loop) THEN
      LET l_loop = "N"
   END IF

   IF NOT cl_null(p_addkey2) THEN
      LET g_sql = "SELECT UNIQUE bmb03,ima02,bmb06,bmb07,bmb10 ",
                    " FROM bmb_file LEFT JOIN ima_file ON bmb03 = ima_file.ima01 ",
                   # "WHERE  bmb01 = '", p_key1 CLIPPED,"'",    #TQC-C60231 mark
                    "WHERE  bmb01 = '", p_addkey2 CLIPPED,"'",  #TQC-C60231 add
                   # " GROUP BY bmb03",
                    " ORDER BY bmb03"
      PREPARE cbmq102_tree_pre4 FROM g_sql
      DECLARE cbmq102_tree_cs4 CURSOR FOR cbmq102_tree_pre4

      #在FOREACH中直接使用遞迴,資料會錯亂,所以先將資料放到陣列後,在FOR迴圈處理
      LET l_cnt = 1
      CALL l_bmb.clear()
      FOREACH cbmq102_tree_cs4 INTO l_bmb[l_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL l_bmb.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列
      LET l_cnt = l_cnt - 1

      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
            LET g_idx = g_idx + 1
            LET g_path_add[g_idx] = l_bmb[l_i].bmb03
            IF g_path_add[g_idx] = p_key1 THEN
               LET l_loop = "Y"
               RETURN l_loop
            END IF
            #有子節點
            #TQC-A60039 mark---start--- #TQC-C60231  remark
            SELECT COUNT(bmb03) INTO l_child FROM bmb_file WHERE bmb01 = l_bmb[l_i].bmb03
            IF l_child > 0 THEN
               CALL cbmq102_tree_loop(p_key1,l_bmb[l_i].bmb03,p_flag) RETURNING l_loop
               IF l_loop = 'Y' THEN RETURN l_loop END IF           #TQC-C60231 add 
            END IF
            #TQC-A60039 mark---end---   #TQC-C60231  remark
          END FOR
      END IF
   END IF
   RETURN l_loop
END FUNCTION


##################################################
# Descriptions...: 異動Tree資料
# Date & Author..: 10/05/05 By huangtao
# Input Parameter:
# Return code....:
##################################################
FUNCTION cbmq102_tree_update()

   #Tree重查並展開focus節點
   LET g_tree_sel='2'              #FUN-B90117
#  CALL cbmq102_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL) #Tree填充          #FUN-B90117
#  CALL cbmq102_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,NULL) #Tree填充     #FUN-B90117   #MOD-C70011 mark
   CALL cbmq102_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_bma.bma01) #Tree填充  #MOD-C70011  
   CALL cbmq102_tree_idxbypath()                        #依tree path指定focus節點
   CALL cbmq102_tree_open(g_tree_focus_idx)             #展開節點
   #復原cursor，上下筆的按鈕才可以使用
   IF g_tree[g_tree_focus_idx].level = 1 THEN
      LET g_tree_b = "N"
   #更新focus節點的單頭和單身
   ELSE
      LET g_tree_b = "Y"
   END IF
   #CALL cbmq102_q(g_tree_focus_idx)
END FUNCTION
###FUN-9A50010 END ###

##################################################
# Descriptions...: 依key指定focus節點
##################################################
FUNCTION cbmq102_tree_idxbykey()   #No.FUN-A30120 add by tommas  fetch單頭後，利用g_abd01來搜尋該資料目前位於g_tree的哪個索引中。
   DEFINE l_idx   INTEGER
   LET g_tree_focus_idx = 1
   FOR l_idx = 1 TO g_tree.getLength()
      IF ( g_tree[l_idx].level == 1 ) AND ( g_tree[l_idx].treekey2 == g_bma.bma01 ) CLIPPED THEN  # 尋找節點
         LET g_tree[l_idx].expanded = TRUE
         LET g_tree_focus_idx = l_idx
      END IF
   END FOR
END FUNCTION

##################################################
# Descriptions...: 顯示圖片
# Date & Author..: 10/05/05 By huangtao
# Input Parameter: p_idx
# Return code....:
##################################################
FUNCTION cbmq102_show_pic(p_idx)
    DEFINE p_idx  LIKE type_file.num5
    DEFINE l_wc   STRING
    DEFINE p_ima04 LIKE ima_file.ima04


    LET g_doc.column1 = "ima01"
    LET g_doc.value1 = g_tree[p_idx].treekey2
    CALL cl_get_fld_doc("ima04")


END FUNCTION
##################################################
# Descriptions...: 顯示字段名稱
# Date & Author..: 10/05/05 By huangtao
# Input Parameter: p_field_code
# Return code....:
##################################################
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

#No.MOD-A70036  --Begin
FUNCTION cbmq102_bmd()

   #delete 取替代性质为0的bmd_file资料
   DELETE FROM bmd_file
    WHERE bmd08 = g_bma.bma01
      AND bmd01 IN (SELECT UNIQUE bmb03 FROM bmb_file
                     WHERE bmb01 = g_bma.bma01
                       AND bmb29 = g_bma.bma06
                       AND bmb16 = '0')
   IF SQLCA.sqlcode THEN
      CALL cl_err3('upd','bmd_file',g_bma.bma01,g_bma.bma06,SQLCA.sqlcode,'','del bmd',1)
   END IF


   #delete 当前主件,但不在bmb_file中的bmd_file资料
   DELETE FROM bmd_file
    WHERE bmd08 = g_bma.bma01
      AND bmd01 NOT IN (SELECT UNIQUE bmb03 FROM bmb_file
                         WHERE bmb01 = g_bma.bma01
                           AND bmb29 = g_bma.bma06)
   IF SQLCA.sqlcode THEN
      CALL cl_err3('upd','bmd_file',g_bma.bma01,g_bma.bma06,SQLCA.sqlcode,'','del bmd',1)
   END IF

END FUNCTION
#No.MOD-A70036  --End

function cbmq102_show2()
DEFINE l_chr           LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   DEFINE l_oeb12,l_ogb12 LIKE oeb_file.oeb12    #MOD-530179
   DEFINE l_sfv09_in      LIKE sfv_file.sfv09
   DEFINE l_sfv09_out     LIKE sfv_file.sfv09
   DEFINE l_qc_nofirm     LIKE qcf_file.qcf091
   DEFINE l_qc_firm       LIKE qcf_file.qcf091
   DEFINE g_short_qty     LIKE sfa_file.sfa07   #FUN-940008 add
   DEFINE l_sql           string                #FUN-940008 add
   DEFINE lr_sfa   RECORD LIKE sfa_file.*       #FUN-940008 add
   DEFINE l_rvv17         LIKE rvv_file.rvv17   #MOD-C70286 add
   DEFINE l_shb114        LIKE shb_file.shb114    #CHI-B40039 add
   DEFINE l_sfa_q1        LIKE type_file.num15_3    #tianry add 161201
   DEFINE l_sfs05         LIKE sfs_file.sfs05 
   DEFINE l_img10         LIKE img_file.img10   #add by huanglf170314
   DEFINE l_a1            LIKE img_file.img10
   DEFINE l_a2            LIKE img_file.img10
   DEFINE l_all            LIKE img_file.img10
   DEFINE s1              LIKE img_file.img10
   #add by liyjf190226 str要考虑单位之间的转换
   DEFINE l_ima63         LIKE ima_file.ima63
   DEFINE l_smd04         LIKE smd_file.smd04
   DEFINE l_smd06         LIKE smd_file.smd06
   DEFINE l_bl            LIKE smd_file.smd06
    #add by liyjf190226 end要考虑单位之间的转换 
   DEFINE l_smc03         LIKE smc_file.smc03  #add by zhangsba190904
   DEFINE l_smc04         LIKE smc_file.smc04  #add by zhangsba190904
   DEFINE l_sfbud12       LIKE sfb_file.sfbud12 #darcy:2022/05/20 下版数量
   DEFINE l_tc_sfaa02     LIKE sfb_file.sfbud12 #darcy:2022/05/20 下版数量
   define l_ima27         like ima_file.ima27   #darcy:2023/04/03 add 
    
   #-->受訂量
   MESSAGE " (1)Wait..."
   SELECT SUM((oeb12-oeb24+oeb25-oeb26)*oeb05_fac) INTO g_ima.oeb_q   #FUN-570017 modify oeb12-oeb24 => oeb12-oeb24+oeb25-oeb26 
          FROM oeb_file, oea_file
          WHERE oeb04 = g_ima.ima01 AND oeb01 = oea01 AND oea00<>'0'  #
            AND oeb70 = 'N' 
            AND oeb12-oeb24+oeb25-oeb26>0   #AND oeb12 > oeb24   #FUN-570017 modify 
            AND oeaconf = 'Y'   #TQC-7C0069 add
   DISPLAY BY NAME g_ima.oeb_q
 
   #-->工單備料量 & 工單缺料量
   MESSAGE " (2)Wait..."
   LET g_ima.sfa_q1 = 0          #TQC-A40009 
   LET g_ima.sfa_q2=0            #MOD-B50011
   let g_ima.sfa_xiaban = 0  #darcy:2022/05/30
   let g_ima.sfa_liuzhi = 0  #darcy:2022/05/30
   let g_ima.ima27 = 0 #darcy:2023/04/03 add
   
#    IF g_ima.sfa_q1 < 0  THEN    #TQC-A40009 
#       LET g_ima.sfa_q1 = 0      #TQC-A40009     
#    END IF                       #TQC-A40009 

    LET l_sql = "SELECT sfa_file.*",
                " ,sfbud12 ", #darcy:2022/05/20
                "  FROM sfb_file,sfa_file",
                " WHERE sfa03 = '",g_ima.ima01,"'",
                "   AND sfb01 = sfa01",
                "   AND sfb04 !='8'",
                "   AND sfb87!='X'",
                "   AND sfb02 != '15'"
   PREPARE q102_sum_pre FROM l_sql
   DECLARE q102_sum CURSOR FOR q102_sum_pre 
   FOREACH q102_sum INTO lr_sfa.*,l_sfbud12  #darcy:2022/05/20 add l_sfbud12
      CALL s_shortqty(lr_sfa.sfa01,lr_sfa.sfa03,lr_sfa.sfa08,
                      lr_sfa.sfa12,lr_sfa.sfa27,
                      lr_sfa.sfa012,lr_sfa.sfa013)  #FUN-A50066 #TQC-A80005
           RETURNING g_short_qty 
      IF cl_null(g_short_qty) THEN LET g_short_qty = 0 END IF 
      #tianry add 161206
      SELECT SUM(sfs05) INTO l_sfs05 FROM sfs_file,sfp_file 
        WHERE sfs04=g_ima.ima01 AND sfs01=sfp01 AND sfp06 IN ('1','2','3','4')    
        AND sfpconf!='X' AND sfp04='N'  AND sfs03=lr_sfa.sfa01
      IF cl_null(l_sfs05) THEN LET l_sfs05 =0 END IF
       #tianry add 计算未扣账数量
      #tianry add 161206
     #IF (lr_sfa.sfa05 > (lr_sfa.sfa06+ g_short_qty)) OR (g_short_qty > 0) THEN                                  #MOD-C90153 mark
    #  IF (lr_sfa.sfa05 > (lr_sfa.sfa06+ g_short_qty- lr_sfa.sfa063+ lr_sfa.sfa065 -(lr_sfa.sfa062+l_sfs05))) OR (g_short_qty > 0) THEN   
       IF (lr_sfa.sfa05 > (lr_sfa.sfa06+ g_short_qty- lr_sfa.sfa063+ lr_sfa.sfa065 )) OR (g_short_qty > 0) THEN
         LET l_rvv17 = 0                                                                               #MOD-C70286 add
         SELECT SUM(rvv17) INTO l_rvv17 FROM rvv_file WHERE rvv18=lr_sfa.sfa01 AND rvv31=lr_sfa.sfa03  #MOD-C70286 add
         IF cl_null(l_rvv17) THEN LET l_rvv17 = 0 END IF                                               #MOD-C70286 add
    #     LET g_ima.sfa_q1= g_ima.sfa_q1 + ((lr_sfa.sfa05-lr_sfa.sfa06-lr_sfa.sfa065+lr_sfa.sfa063-lr_sfa.sfa062+l_rvv17)*lr_sfa.sfa13)  #MOD-C70286 add +l_rvv17
          LET s1 = (lr_sfa.sfa05-lr_sfa.sfa06-lr_sfa.sfa065+lr_sfa.sfa063-l_sfs05+l_rvv17)*lr_sfa.sfa13
    #      LET g_ima.sfa_q1= g_ima.sfa_q1 + ((lr_sfa.sfa05-lr_sfa.sfa06-lr_sfa.sfa065+lr_sfa.sfa063-l_sfs05+l_rvv17)*lr_sfa.sfa13)  #MOD-C70286 add +l_rvv17  #liuyya mark  170624
          LET g_ima.sfa_q1= g_ima.sfa_q1 + ((lr_sfa.sfa05-lr_sfa.sfa06-lr_sfa.sfa065+lr_sfa.sfa063+l_rvv17)*lr_sfa.sfa13)   #liuyya add  170624
          LET g_ima.sfa_q2= g_ima.sfa_q2 + (g_short_qty * lr_sfa.sfa13)
          #darcy:2022/05/20 s---
          if l_sfbud12 > 0 then
          #去掉下版数量部分
            #darcy:2022/09/01 add s---
            # 取替代料需要取原料号QPA
            if lr_sfa.sfa26 = 'S' OR  lr_sfa.sfa26='U' then
               SELECT sfa161 into lr_sfa.sfa161 from sfa_file
                where sfa01 = lr_sfa.sfa01 and sfa03 = lr_sfa.sfa27 and sfa08=lr_sfa.sfa08
            end if
            #darcy:2022/09/01 add e---
            let g_ima.sfa_xiaban = iif (cl_null(g_ima.sfa_xiaban),0,g_ima.sfa_xiaban)
            let g_ima.sfa_xiaban = g_ima.sfa_xiaban + lr_sfa.sfa161 * l_sfbud12 * lr_sfa.sfa13
          end if
          #darcy:2022/05/20 e---
         
      END IF          #tianry mark  161201
      #darcy:2022/07/13 s---
      select tc_sfaa02 into l_tc_sfaa02 from tc_sfaa_file 
         where tc_sfaa01 = lr_sfa.sfa01
      if cl_null(l_tc_sfaa02) then 
         let l_tc_sfaa02 = 0
      end if

      let g_ima.sfa_liuzhi = iif (cl_null(g_ima.sfa_liuzhi),0,g_ima.sfa_liuzhi)
      let g_ima.sfa_liuzhi = g_ima.sfa_liuzhi + lr_sfa.sfa161 * l_tc_sfaa02 * lr_sfa.sfa13
      let l_tc_sfaa02 = 0

      #darcy:2022/07/13 e---
 #   IF (lr_sfa.sfa05 > (lr_sfa.sfa06 + lr_sfa.sfa065 - lr_sfa.sfa063 ) OR g_short_qty > 0) THEN
 #      LET l_sfa_q1 =(lr_sfa.sfa05 - lr_sfa.sfa06 - lr_sfa.sfa065 +    lr_sfa.sfa063 - lr_sfa.sfa062 ) * lr_sfa.sfa13
 #      IF l_sfa_q1 < 0 THEN
 #         LET l_sfa_q1 = 0
 #      END IF
 #      LET g_ima.sfa_q1= g_ima.sfa_q1 + l_sfa_q1
 #      LET g_ima.sfa_q2= g_ima.sfa_q2 + (g_short_qty * lr_sfa.sfa13)
 #   END IF  
      
   END FOREACH      
    ##add by liyjf190226 str
   LET l_ima63  = '' LET l_smd04 = '' LET l_smd06 = '' LET l_bl=1
   SELECT ima63,ima27 INTO l_ima63,g_ima.ima27 FROM ima_file WHERE ima01 = g_ima.ima01  #发料单位 #darcy:2023/04/03 add ima27
   SELECT smd04,smd06 INTO l_smd04,l_smd06 FROM smd_file WHERE smd01 = g_ima.ima01 AND smd02 = l_ima63 AND smd03 = g_ima.ima25  #aooi103抓转换关系   
   #add by zhangsba190904---s  103为空到102查
   IF l_ima63 <> g_ima.ima25  THEN #发料单位与库存单位不一致
     IF cl_null(l_smd04) OR cl_null(l_smd06) THEN  
   	   SELECT smc03,smc04 INTO l_smc03,l_smc04 FROM smc_file WHERE smc01 = g_ima.ima25 AND smc02 = l_ima63    #aooi102抓转换关系
       LET l_bl = l_smc04/l_smc03
       LET g_ima.sfa_q1= g_ima.sfa_q1*l_bl
       LET g_ima.sfa_xiaban= g_ima.sfa_xiaban*l_bl #darcy:2022/05/20 add 
       LET g_ima.sfa_liuzhi= g_ima.sfa_liuzhi*l_bl #darcy:2022/05/20 add 
       LET g_ima.sfa_q2= g_ima.sfa_q2*l_bl
      
      #应客户要求，发料单位再统一换算成库存单位g_ima.ima25
       LET l_bl = l_smc03/l_smc04
       LET g_ima.sfa_q1= g_ima.sfa_q1*l_bl
       LET g_ima.sfa_xiaban= g_ima.sfa_xiaban*l_bl #darcy:2022/05/20 add 
       LET g_ima.sfa_liuzhi= g_ima.sfa_liuzhi*l_bl #darcy:2022/05/20 add 
       LET g_ima.sfa_q2= g_ima.sfa_q2*l_bl
     END IF
   END IF
   IF l_ima63 = g_ima.ima25  THEN #发料单位与库存单位一致
      LET l_bl = 1
      LET g_ima.sfa_q1= g_ima.sfa_q1*l_bl
      LET g_ima.sfa_xiaban= g_ima.sfa_xiaban*l_bl #darcy:2022/05/20
      LET g_ima.sfa_liuzhi= g_ima.sfa_liuzhi*l_bl #darcy:2022/05/20
      LET g_ima.sfa_q2= g_ima.sfa_q2*l_bl
   END IF
   #add by zhangsba190904---e
   #mark by zhangsba190904---s
   #IF l_ima63 <> g_ima.ima25  THEN #发料单位与库存单位不一致
   #   LET l_bl = l_smd06/l_smd04
   #   LET g_ima.sfa_q1= g_ima.sfa_q1*l_bl
   #   LET g_ima.sfa_q2= g_ima.sfa_q2*l_bl
   #END IF
   #mark by zhangsba190904---e   
   ##add by liyjf190226 end 
   DISPLAY BY NAME g_ima.sfa_q1,g_ima.sfa_q2,g_ima.sfa_xiaban,g_ima.sfa_liuzhi #darcy:2022/05/20 add sfa_xiaban 
   display by name g_ima.ima27 #darcy:2023/04/03 add
   #-->請購量
   MESSAGE " (3)Wait..."
   SELECT SUM((pml20-pml21)*pml09) INTO g_ima.pml_q
         FROM pml_file, pmk_file
        WHERE pml04 = g_ima.ima01 AND pml01 = pmk01
          AND pml20 > pml21
          AND ( pml16 <='2' OR pml16='S' OR pml16='R' OR pml16='W')
          AND pml011 !='SUB'
          AND pmk18 != 'X'
   DISPLAY BY NAME g_ima.pml_q

#FUN-A20048 -- begin  -- 备置量
  #SELECT SUM(sie09) INTO g_ima.sie_q  #TQC-B10143
   SELECT SUM(sig05) INTO g_ima.sie_q  #TQC-B10143
         FROM sig_file,ima_file        #TQC-B10143
        WHERE sig01=ima01 AND sig01 = g_ima.ima01 #TQC-B10143
   DISPLAY BY NAME g_ima.sie_q
#FUN-A20048 --end 
 
   #-->採購量
   MESSAGE " (4)Wait..."
   SELECT SUM((pmn20-pmn50+pmn55+pmn58)*pmn09) INTO g_ima.pmn_q       #NO:2897  #No.FUN-940083
         FROM pmn_file, pmm_file
        WHERE pmn04 = g_ima.ima01 AND pmn01 = pmm01
          AND pmn20 > pmn50-pmn55-pmn58   #No.FUN-9A0068 
          AND ( pmn16 <='2' OR pmn16='S' OR pmn16='R' OR pmn16='W')
          AND pmn011 !='SUB'
          AND pmm18 != 'X'
 
   IF cl_null(g_ima.pmn_q) THEN LET g_ima.pmn_q=0 END IF
   IF g_ima.pmn_q=0 THEN LET g_ima.pmn_q=NULL END IF
   DISPLAY BY NAME g_ima.pmn_q
 
   #-->工單在製量
   MESSAGE " (5)Wait..."
   SELECT SUM((sfb08-sfb09-sfb10-sfb11-sfb12)*ima55_fac)
     INTO g_ima.sfb_q1
     FROM sfb_file,ima_file
    WHERE sfb05=ima01 AND sfb05 = g_ima.ima01 AND sfb04 <'8'
      AND ( sfb02 !='7' AND sfb02 !='8' AND sfb02 !='11' AND sfb02 != '15' )   #FUN-5B0114   #MOD-840041 
      AND sfb08 > (sfb09+sfb10+sfb11+sfb12) AND sfb87!='X' #FUN-5C0046
       #CHI-B40039---add---start---
   LET l_shb114 = 0
   SELECT SUM(shb114) INTO l_shb114 
     FROM shb_file,sfb_file
    WHERE shb10 = g_ima.ima01
      AND shb05 = sfb01
      AND shb10 = sfb05
      AND sfb04 < '8' AND sfb87 != 'X'
      AND ( sfb02 !='7' AND sfb02 !='8' AND sfb02 !='11' AND sfb02 != '15' ) 
   IF cl_null(l_shb114) THEN LET l_shb114 = 0 END IF
   LET g_ima.sfb_q1 = g_ima.sfb_q1 - l_shb114
  #CHI-B40039---add---end---
   DISPLAY BY NAME g_ima.sfb_q1
 
   #-->委外在製量
   SELECT SUM((sfb08-sfb09-sfb10-sfb11-sfb12)*ima55_fac)
     INTO g_ima.sfb_q2
     FROM sfb_file,ima_file
    WHERE sfb05=ima01 AND sfb05 = g_ima.ima01 AND sfb04 <'8'
      AND (sfb02='7' OR sfb02='8')   #FUN-5B0114
      AND sfb08 > (sfb09+sfb10+sfb11+sfb12) AND sfb87!='X'
   IF cl_null(g_ima.sfb_q2) THEN LET g_ima.sfb_q2=0 END IF     #No.MOD-730057 modify
 #CHI-B40039---add---start---
   LET l_shb114 = 0 
   SELECT SUM(shb114) INTO l_shb114 
     FROM shb_file,sfb_file
    WHERE shb10 = g_ima.ima01
      AND shb05 = sfb01
      AND shb10 = sfb05
      AND sfb04 < '8' AND sfb87 != 'X'
      AND ( sfb02 ='7' AND sfb02 ='8') 
   IF cl_null(l_shb114) THEN LET l_shb114 = 0 END IF
   LET g_ima.sfb_q2 = g_ima.sfb_q2 - l_shb114
  #CHI-B40039---add---end---
   DISPLAY BY NAME g_ima.sfb_q2
 
   #-->委外IQC在製量
   SELECT SUM((rvb07-rvb29-rvb30)*pmn09) INTO g_ima.rvb_q2   #MOD-A70029  #MOD-AA0075 取消mark
  #SELECT SUM(rvb31*pmn09) INTO g_ima.rvb_q2   #MOD-A70029    #MOD-AA0075 mark
     FROM rvb_file, rva_file, pmn_file
    WHERE rvb05 = g_ima.ima01 AND rvb01=rva01
      AND rvb04 = pmn01 AND rvb03 = pmn02
      AND rvb07 > (rvb29+rvb30)   #MOD-A70029  #MOD-AA0075 取消mark
     #AND rvb31 > 0   #MOD-A70029    #MOD-AA0075 mark
      AND rvaconf='Y'  #No.BANN
      AND rva10 ='SUB' #MODNO:6634 #No:9039
      AND pmn43 = 0    #MOD-580174 add
   IF cl_null(g_ima.rvb_q2) THEN LET g_ima.rvb_q2=0 END IF     #No.MOD-730057 add
   DISPLAY BY NAME g_ima.rvb_q2
 
  #委外在置量應加上委外IQC在驗量
   LET g_ima.sfb_q2 = g_ima.sfb_q2 + g_ima.rvb_q2
   IF g_ima.sfb_q2=0 THEN LET g_ima.sfb_q2=NULL END IF     
   IF g_ima.rvb_q2=0 THEN LET g_ima.rvb_q2=NULL END IF     
   DISPLAY BY NAME g_ima.sfb_q2
   DISPLAY BY NAME g_ima.rvb_q2
 
   #-->IQC 在驗量
   MESSAGE " (6)Wait..."
   SELECT SUM((rvb07-rvb29-rvb30)*pmn09) INTO g_ima.rvb_q   #MOD-A70029   #MOD-AA0075 取消mark
  #SELECT SUM(rvb31*pmn09) INTO g_ima.rvb_q   #MOD-A70029   #MOD-AA0075 mark
         FROM rvb_file, rva_file, pmn_file
        WHERE rvb05 = g_ima.ima01 AND rvb01=rva01
          AND rvb04 = pmn01 AND rvb03 = pmn02
          AND rvb07 > (rvb29+rvb30)   #MOD-A70029  #MOD-AA0075 取消mark
         #AND rvb31 > 0   #MOD-A70029   #MOD-AA0075 mark
          AND rvaconf='Y' #No.BANN
          AND rva10 != 'SUB'  #BugNo:6634 #No:9039
   DISPLAY BY NAME g_ima.rvb_q
 
   #-->FQC 在驗量
   MESSAGE " (7)Wait..."
  #MOD-A90098 mod --start--
  #SELECT SUM(sfb11) INTO g_ima.qcf_q
  #  FROM sfb_file
  # WHERE sfb05 = g_ima.ima01
  SELECT SUM(sfb11*ima55_fac) INTO g_ima.qcf_q
     FROM sfb_file,ima_file
    WHERE sfb05=ima01 AND sfb05 = g_ima.ima01
  #MOD-A90098 mod --end--
      AND sfb02 <> '7' AND sfb87!='X'
      AND sfb02 <> '8'   #FUN-5B0069
      AND sfb02 <> '11'    #MOD-AA0069 add
      AND sfb04 <'8'  #plum   #No.MOD-C10177
     #AND sfb04 <'7'  #plum   #Mod MOD-AC0061   #No.MOD-C10177
   IF SQLCA.sqlcode OR STATUS THEN LET g_ima.qcf_q = '' END IF
   IF g_ima.qcf_q = 0 THEN LET g_ima.qcf_q = '' END IF
   DISPLAY BY NAME g_ima.qcf_q

  #-->超领未扣帐数量
  MESSAGE " (8)Wait..." 
  
  #mark by sunyan 210407---s  谢宇彬要求改为杂项未扣账数量
  #SELECT SUM(sfs05*ima63_fac) INTO l_a1
  SELECT NVL(SUM(sfs05*ima63_fac),0) INTO l_a1  #add by zhangzs 210823
     FROM sfs_file,ima_file,sfp_file
    WHERE sfs04=ima01 AND sfs01=sfp01
      AND sfs04 = g_ima.ima01 
      AND sfp06 = '2' AND sfpconf!='X'
      AND sfp04 <> 'Y'   #FUN-5B0069
  #Mark by sunyan 210407---e
  #add by sunyan 210407---s
 # SELECT SUM(inb09*inb08_fac) INTO l_a2
   SELECT NVL(SUM(inb09*inb08_fac),0) INTO l_a2  #add by zhangzs 210823
    FROM ina_file,inb_file
   WHERE ina01 = inb01
      AND inb04=g_ima.ima01
      AND inaconf = 'Y' 
      AND inapost = 'N'
      AND ina00 in ('1','2')
   # LET l_all = l_a1 + l_a2
   LET g_ima.sfe_c = l_a1 + l_a2  #add by zhangzs 210823
  #add by sunyan 210407---e
   IF SQLCA.sqlcode OR STATUS THEN LET g_ima.sfe_c = 0 END IF
   IF cl_null(g_ima.sfe_c) THEN LET g_ima.sfe_c = 0 END IF
   DISPLAY BY NAME g_ima.sfe_c
   #DISPLAY l_all TO g_ima.sfe_c
   
#FUN-AC0074--mark(s) 
#   #-->出貨備置量
#   SELECT SUM(oeb905*oeb05_fac) INTO l_oeb12   #no.7182
#     FROM oeb_file, oea_file, occ_file
#    WHERE oeb04 = g_ima.ima01 AND oeb01 = oea01 AND oea00<> '0' AND oeb19 = 'Y'
#      AND oeb70 = 'N' AND oeb12 > oeb24 AND oea03=occ01
#   IF cl_null(l_oeb12)  THEN LET l_oeb12=0 END IF
#   LET g_ima.alocated=l_oeb12  #+l_ogb12
#   DISPLAY BY NAME g_ima.alocated
#FUN-AC0074--mark(e) 
   IF g_ima.oeb_q  IS NULL THEN LET g_ima.oeb_q = 0 END IF
   IF g_ima.sfa_q1 IS NULL THEN LET g_ima.sfa_q1 = 0 END IF
   IF g_ima.sfa_xiaban IS NULL THEN LET g_ima.sfa_xiaban = 0 END IF #darcy:2022/05/20 add
   IF g_ima.sfa_liuzhi IS NULL THEN LET g_ima.sfa_liuzhi = 0 END IF #darcy:2022/05/20 add
   if g_ima.ima27 is null then let g_ima.ima27 = 0 end if #darcy:2023/04/03 add
   IF g_ima.sfa_q2 IS NULL THEN LET g_ima.sfa_q2 = 0 END IF
   IF g_ima.pml_q  IS NULL THEN LET g_ima.pml_q = 0 END IF
   IF g_ima.pmn_q  IS NULL THEN LET g_ima.pmn_q = 0 END IF
   IF g_ima.rvb_q  IS NULL THEN LET g_ima.rvb_q = 0 END IF
   IF g_ima.sfb_q1 IS NULL THEN LET g_ima.sfb_q1 = 0 END IF
   IF g_ima.sfb_q2 IS NULL THEN LET g_ima.sfb_q2 = 0 END IF
   IF g_ima.qcf_q  IS NULL THEN LET g_ima.qcf_q = 0 END IF
   IF g_ima.sie_q  IS NULL THEN LET g_ima.sie_q = 0 END IF      #NO.FUN-A20048 add
#  LET g_ima.atp_qty=g_ima.ima262 - g_ima.oeb_q - g_ima.sfa_q1  #NO.FUN-A20044
#  LET g_ima.atp_qty=g_avl_stk - g_ima.oeb_q - g_ima.sfa_q1     #NO.FUN-A20044  #FUN-A20048 mark
#  LET g_ima.atp_qty=g_avl_stk - g_ima.oeb_q - g_ima.sfa_q1 - g_ima.sie_q     #NO.FUN-A20048  mod #MOD-B30496  
   LET g_ima.atp_qty=g_avl_stk - g_ima.oeb_q - g_ima.sfa_q1  + g_ima.sfa_xiaban + g_ima.sfa_liuzhi                 #MOD-B30496    #darcy:2022/05/20 add g_ima.sfa_xiaban
                                  + g_ima.pml_q + g_ima.pmn_q + g_ima.rvb_q
                                  + g_ima.sfb_q1+ g_ima.sfb_q2+ g_ima.qcf_q - g_ima.sfe_c #- g_ima.img_q  #add by huanglf170314 --失效量仍参与运算
                                  - g_ima.ima27  #darcy:2023/04/03 add 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
   DISPLAY By NAME g_ima.atp_qty
end function

FUNCTION cbmq102_d(d_no)
   DEFINE d_no      LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   DEFINE t_no      LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   DEFINE l_cmd      LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(50)
 
   LET t_no = d_no
   WHILE TRUE
     IF d_no = '0' THEN
        OPEN WINDOW aimq102_w2 AT 5,15
           WITH FORM "aim/42f/aimq1021"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aimq1021")
 
        INPUT BY NAME d_no
           AFTER FIELD d_no
               IF d_no IS NULL OR d_no NOT MATCHES '[0123456789]' THEN
                  NEXT FIELD d_no
               END IF
           AFTER INPUT
             IF INT_FLAG THEN EXIT INPUT END IF
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
        IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
     END IF
     IF d_no IS NULL OR d_no = ' ' THEN LET d_no ='0' END IF
    #CASE WHEN d_no ='1' LET l_cmd='aimq131 ',g_ima.ima01             #MOD-AB0224 mark  
     CASE WHEN d_no ='1' LET l_cmd='aimq131 "',g_ima.ima01,'"'        #MOD-AB0224 add 
                         CALL cl_cmdrun(l_cmd) EXIT WHILE
         #WHEN d_no ='2' LET l_cmd='aimq138 ',g_ima.ima01             #MOD-AB0224 mark
          WHEN d_no ='2' LET l_cmd='aimq138 "',g_ima.ima01,'"'        #MOD-AB0224 add           
                         CALL cl_cmdrun(l_cmd) EXIT WHILE
         #WHEN d_no ='3' CALL aimq140(g_ima.ima01) EXIT WHILE         #MOD-B70050 mark
          WHEN d_no ='3' LET l_cmd='aimq140 "',g_ima.ima01,'"'        #MOD-B70050 add
                         CALL cl_cmdrun(l_cmd) EXIT WHILE             #MOD-B70050 add
         #WHEN d_no ='4' CALL aimq134(g_ima.ima01) EXIT WHILE         #MOD-B70050 mark
          WHEN d_no ='4' LET l_cmd='aimq134 "',g_ima.ima01,'"'        #MOD-B70050 add
                         CALL cl_cmdrun(l_cmd) EXIT WHILE             #MOD-B70050 add
         #WHEN d_no ='5' LET l_cmd='aimq136 ',g_ima.ima01             #MOD-AB0224 mark      
          WHEN d_no ='5' LET l_cmd='aimq136 "',g_ima.ima01,'"'        #MOD-AB0224 add 
                         CALL cl_cmdrun(l_cmd) EXIT WHILE
         #WHEN d_no ='6' LET l_cmd='aimq137 ',g_ima.ima01             #MOD-AB0224 mark          
          WHEN d_no ='6' LET l_cmd='aimq137 "',g_ima.ima01,'"'        #MOD-AB0224 add 
                         CALL cl_cmdrun(l_cmd) EXIT WHILE
         #WHEN d_no ='7' LET l_cmd='aimq132 ',g_ima.ima01             #MOD-AB0224 mark          
          WHEN d_no ='7' LET l_cmd='aimq132 "',g_ima.ima01,'"'        #MOD-AB0224 add 
                         CALL cl_cmdrun(l_cmd) EXIT WHILE             #MOD-C10030 add
          WHEN d_no ='0' EXIT WHILE
          OTHERWISE LET d_no ='0'
     END CASE
   END WHILE
   if t_no ='0' then CLOSE WINDOW aimq102_w2 end iF
END FUNCTION

FUNCTION q102_q2()
   DEFINE sr      RECORD
               pmm04      LIKE pmm_file.pmm04,
               pmm01      LIKE pmm_file.pmm01,
               pmc03      LIKE pmc_file.pmc03,
               pmm22      LIKE pmm_file.pmm22,
               pmn20      LIKE pmn_file.pmn20,
               pmn07      LIKE pmn_file.pmn07,
                pmn86   LIKE pmn_file.pmn86, #FUN-610086
               pmn31      LIKE pmn_file.pmn31,
               pmn33      LIKE pmn_file.pmn33,
               pmm20      LIKE pmm_file.pmm20
               END RECORD
 
   LET p_row = 6 LET p_col = 2
   OPEN WINDOW q102_q2_w AT p_row,p_col
     WITH FORM "aim/42f/aimq1022"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aimq1022")
   IF g_sma.sma116 MATCHES '[02]' THEN   
      CALL cl_set_comp_visible("pmn86",FALSE)
   END IF
 
   DECLARE q102_q2_c CURSOR FOR SELECT pmm04,pmm01,pmc03,pmm22,pmn20,pmn07,pmn86, #FUN-610086
                                       pmn31,pmn33,pmm20
                                  FROM pmm_file, pmn_file, OUTER pmc_file
                                 WHERE pmn04 = g_ima.ima01
                                   AND pmn01 = pmm01
                                   AND pmm09 = pmc01
                                   AND pmm18 != 'X'
                                 ORDER BY pmm04 DESC
 
   CALL g_bbb2.clear()
   LET g_cnt=1
 
   FOREACH q102_q2_c INTO sr.*
      IF STATUS THEN
         CALL cl_err('for:',STATUS,1)
         EXIT FOREACH
      END IF
      LET g_bbb2[g_cnt].pmm04 = sr.pmm04
      LET g_bbb2[g_cnt].pmm01 = sr.pmm01
      LET g_bbb2[g_cnt].pmc03 = sr.pmc03
      LET g_bbb2[g_cnt].pmm22 = sr.pmm22
      LET g_bbb2[g_cnt].pmn20 = sr.pmn20 USING '--------&'
      LET g_bbb2[g_cnt].pmn07 = sr.pmn07
      LET g_bbb2[g_cnt].pmn86 = sr.pmn86                   #FUN-610086
      LET g_bbb2[g_cnt].pmn31 = sr.pmn31 #USING '------&.&&' #MOD-970085 mark using
      LET g_bbb2[g_cnt].pmn33 = sr.pmn33
      LET g_bbb2[g_cnt].pmm20 = sr.pmm20[1,6]
 
      LET g_cnt=g_cnt+1
   END FOREACH
 
   DISPLAY ARRAY g_bbb2 TO s_bbb2.*
      BEFORE ROW                                                                                                                    
         LET l_ac = ARR_CURR()                                                                                                      
      CALL cl_show_fld_cont() 
      ON ACTION detail                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = 1                                                                                                               
         CONTINUE DISPLAY      
 
      ON ACTION accept                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = ARR_CURR()                                                                                                      
         CONTINUE DISPLAY    
                                                                                                                                    
      ON ACTION cancel                                                                                                              
         LET INT_FLAG=FALSE  
         LET g_action_choice="exit"                                                                                                 
         EXIT DISPLAY           
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
   AFTER DISPLAY 
     CONTINUE DISPLAY 
   END DISPLAY 
   CLOSE WINDOW q102_q2_w
 
END FUNCTION
 
 FUNCTION q102_q5()
   DEFINE sr      RECORD
               imm01      LIKE imm_file.imm01,
               imm02      LIKE imm_file.imm02,
               imn04      LIKE imn_file.imn04,
               imn05      LIKE imn_file.imn05,
               imn06      LIKE imn_file.imn06,
               imn15      LIKE imn_file.imn15,
               imn16      LIKE imn_file.imn16,
               imn17      LIKE imn_file.imn17,
               imn10      LIKE imn_file.imn10,
               imn09      LIKE imn_file.imn09
               END RECORD
 
   LET p_row = 6 LET p_col = 2
   OPEN WINDOW q102_q5_w AT p_row,p_col
     WITH FORM "aim/42f/aimq1025"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aimq1025")
 
   DECLARE q102_q5_c CURSOR FOR
      SELECT imm01,imm02,imn04,imn05,imn06,
             imn15,imn16,imn17,imn10,imn09
        FROM imm_file, imn_file
       WHERE imn03=g_ima.ima01
         AND imn01=imm01 AND imm03='N'
         AND immconf!='X'   #MOD-A60149 add
         AND imm04 <> 'X'  #MOD-D30243
       ORDER BY imm01,imm02
 
   CALL g_bbb5.clear()
   LET g_cnt=1
 
   FOREACH q102_q5_c INTO sr.*
      IF STATUS THEN
         CALL cl_err('for:',STATUS,1)
         EXIT FOREACH
      END IF
      LET g_bbb5[g_cnt].imm01 = sr.imm01
      LET g_bbb5[g_cnt].imm02 = sr.imm02
      LET g_bbb5[g_cnt].imn04 = sr.imn04
      #LET g_bbb5[g_cnt].imn05 = sr.imn04  #MOD-D30243
      #LET g_bbb5[g_cnt].imn06 = sr.imn04  #MOD-D30243
      LET g_bbb5[g_cnt].imn05 = sr.imn05   #MOD-D30243
      LET g_bbb5[g_cnt].imn06 = sr.imn06   #MOD-D30243
      LET g_bbb5[g_cnt].imn15 = sr.imn15
      #LET g_bbb5[g_cnt].imn16 = sr.imn15  #MOD-D30243
      #LET g_bbb5[g_cnt].imn17 = sr.imn15  #MOD-D30243
      LET g_bbb5[g_cnt].imn16 = sr.imn16   #MOD-D30243
      LET g_bbb5[g_cnt].imn17 = sr.imn17   #MOD-D30243
      LET g_bbb5[g_cnt].imn10 = sr.imn10 USING '#######&'
      LET g_bbb5[g_cnt].imn09 = sr.imn09[1,4]
 
      LET g_cnt=g_cnt+1
   END FOREACH
 
   DISPLAY ARRAY g_bbb5 TO s_bbb5.*
      BEFORE ROW                                                                                                                    
         LET l_ac = ARR_CURR()                                                                                                      
      CALL cl_show_fld_cont() 
      ON ACTION detail                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = 1                                                                                                               
         CONTINUE DISPLAY      
 
      ON ACTION accept                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = ARR_CURR()                                                                                                      
         CONTINUE DISPLAY    
                                                                                                                                    
      ON ACTION cancel                                                                                                              
         LET INT_FLAG=FALSE  
         LET g_action_choice="exit"                                                                                                 
         EXIT DISPLAY           
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
   AFTER DISPLAY 
     CONTINUE DISPLAY 
   END DISPLAY 
 
   CLOSE WINDOW q102_q5_w
 
END FUNCTION
 FUNCTION q102_q3()
   DEFINE sr      RECORD
               bmx07      LIKE bmx_file.bmx07,
               bmx01      LIKE bmx_file.bmx01,
               bmz03      LIKE bmz_file.bmz03,
                bmz02   LIKE bmz_file.bmz02, #FUN-660078
                bmg03   LIKE bmg_file.bmg03, #FUN-660078
               bmy03      LIKE bmy_file.bmy03,
               bmy19      LIKE bmy_file.bmy19,
               bmy06      LIKE bmy_file.bmy06
               END RECORD
   DEFINE l_sql LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
 
   LET p_row = 6 LET p_col = 2
   OPEN WINDOW q102_q3_w AT p_row,p_col
     WITH FORM "aim/42f/aimq1023"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aimq1023")
 
#----TQC-CC0001---mark--star--
#  LET l_sql="SELECT bmx07,bmx01,bmz03,bmz02,bmg03,bmy03,bmy19,bmy06 ",
#            "  FROM bmx_file, bmz_file, bmy_file, LEFT OUTER JOIN bmg_file ",
#            "ON bmy01=bmg01 AND bmg_file.bmg02=1 ",
#            " WHERE bmy05='",g_ima.ima01 ,"'",
#            "   AND bmx01=bmz01 AND bmy01=bmx01",
#            "   AND bmx06='1' ",
#            " UNION ",
#            "SELECT bmx07,bmx01,bmy17,bmy14,bmg03,bmy03,bmy19,bmy06",
#            "  FROM bmx_file,bmy_file, LEFT OUTER JOIN bmg_file ",
#            "ON bmy01=bmg01 AND bmg_file.bmg02=1 ",
#            " WHERE bmy05='",g_ima.ima01 ,"'",
#            "   AND bmx06='2' AND bmy01=bmx01",
#            " ORDER BY 1 DESC "
#----TQC-CC0001---mark--end---
#----TQC-CC0001---add---star---
   LET l_sql="SELECT bmx07,bmx01,bmz03,bmz02,bmg03,bmy03,bmy19,bmy06 ",
             "  FROM bmx_file,bmy_file,bmz_file, bmg_file ",
             " WHERE bmy05='",g_ima.ima01 ,"'",
             "   AND bmy01=bmx01 AND bmx04 <> 'X' ",
             "   AND bmy01=bmg01 AND bmg02=1 ",
             "   AND bmx01=bmz01 ",
             "   AND bmx06='1' ",
             " UNION ",
             "SELECT bmx07,bmx01,bmy17,bmy14,bmg03,bmy03,bmy19,bmy06",
             "  FROM bmx_file,bmy_file,  bmg_file ",
             " WHERE bmy05='",g_ima.ima01 ,"'",
             "   AND bmy01=bmx01 AND bmx04 <> 'X' ",
             "   AND bmy01=bmg01 AND bmg02=1 ",
             "   AND bmx06='2' ",
             " ORDER BY 1 DESC "
#----TQC-CC0001---add--end---
   PREPARE q102_q3_prepare FROM l_sql
   DECLARE q102_q3_c CURSOR FOR q102_q3_prepare
 
   CALL g_bbb3.clear()
   LET g_cnt=1
 
   FOREACH q102_q3_c INTO sr.*
      IF STATUS THEN
         CALL cl_err('for:',STATUS,1)
         EXIT FOREACH
      END IF
      LET g_bbb3[g_cnt].bmx07 = sr.bmx07
      LET g_bbb3[g_cnt].bmx01 = sr.bmx01
      LET g_bbb3[g_cnt].bmz03 = sr.bmz03
      LET g_bbb3[g_cnt].bmz02 = sr.bmz02
      LET g_bbb3[g_cnt].bmg03 = sr.bmg03
      LET g_bbb3[g_cnt].bmy03 = sr.bmy03
      LET g_bbb3[g_cnt].bmy19 = sr.bmy19
      LET g_bbb3[g_cnt].bmy06 = sr.bmy06 USING '---&'
 
      LET g_cnt=g_cnt+1
   END FOREACH
 
   DISPLAY ARRAY g_bbb3 TO s_bbb3.*
      BEFORE ROW                                                                                                                    
         LET l_ac = ARR_CURR()                                                                                                      
      CALL cl_show_fld_cont() 
      ON ACTION detail                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = 1                                                                                                               
         CONTINUE DISPLAY      #No.TQC-7B0008
 
      ON ACTION accept                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = ARR_CURR()                                                                                                      
         CONTINUE DISPLAY      #No.TQC-7B0008
                                                                                                                                    
      ON ACTION cancel                                                                                                              
         LET INT_FLAG=FALSE                 #MOD-570244     mars                                                                
         LET g_action_choice="exit"                                                                                                 
         EXIT DISPLAY           
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
   AFTER DISPLAY 
     CONTINUE DISPLAY 
   END DISPLAY 
   CLOSE WINDOW q102_q3_w                   #No.TQC-790064
 
END FUNCTION
 
FUNCTION q102_q4()
   DEFINE sr      RECORD
               bmb01      LIKE bmb_file.bmb01,
               ima02      LIKE ima_file.ima02,  #TQC-CC0001--add
               ima021     LIKE ima_file.ima021,
               bmb02      LIKE bmb_file.bmb02,
               bmb04      LIKE bmb_file.bmb04,
               bmb05      LIKE bmb_file.bmb05,
               bmb16      LIKE bmb_file.bmb16,
               bmb06      LIKE bmb_file.bmb06,
               bmb08      LIKE bmb_file.bmb08
               END RECORD
 
   LET p_row = 6 LET p_col = 2
    OPEN WINDOW q102_q4_w AT p_row,p_col   #MOD-4C0085
     WITH FORM "aim/42f/aimq1024"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aimq1024")
 
   DECLARE q102_q4_c CURSOR FOR SELECT bmb01,'','',bmb02,bmb04,bmb05,bmb16,bmb06/bmb07,bmb08
                                  FROM bmb_file
                                 WHERE bmb03=g_ima.ima01
                                 ORDER BY bmb01,bmb02,bmb04
 
   CALL g_bbb4.clear()
   LET g_cnt=1
 
   FOREACH q102_q4_c INTO sr.*
      IF STATUS THEN
         CALL cl_err('for:',STATUS,1)
         EXIT FOREACH
      END IF
      LET g_bbb4[g_cnt].bmb01 = sr.bmb01
      LET g_bbb4[g_cnt].bmb02 = sr.bmb02 USING '###&'
      LET g_bbb4[g_cnt].bmb04 = sr.bmb04
      LET g_bbb4[g_cnt].bmb05 = sr.bmb05
      LET g_bbb4[g_cnt].bmb16 = sr.bmb16
      LET g_bbb4[g_cnt].bmb06 = sr.bmb06 USING '#####&.######' #MOD-980041 
      LET g_bbb4[g_cnt].bmb08 = sr.bmb08
#--#TQC-CC0001--add-star--
      SELECT ima02,ima021 INTO g_bbb4[g_cnt].ima02,g_bbb4[g_cnt].ima021
        FROM ima_file WHERE ima01 = g_bbb4[g_cnt].bmb01
#--#TQC-CC0001--add--end--
 
      LET g_cnt=g_cnt+1
   END FOREACH
 
   DISPLAY ARRAY g_bbb4 TO s_bbb4.*
      BEFORE ROW                                                                                                                    
         LET l_ac = ARR_CURR()                                                                                                      
      CALL cl_show_fld_cont() 
      ON ACTION detail                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = 1                                                                                                               
         CONTINUE DISPLAY      
 
      ON ACTION accept                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = ARR_CURR()                                                                                                      
         CONTINUE DISPLAY    
                                                                                                                                    
      ON ACTION cancel                                                                                                              
         LET INT_FLAG=FALSE  
         LET g_action_choice="exit"                                                                                                 
         EXIT DISPLAY           

#--------TQC-CC0001---add----star--

            ON ACTION CONTROLP    #FUN-4B0043
               IF INFIELD(bmb01) THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima5"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bmb01
               END IF
#--------TQC-CC0001---add----end-----
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
   AFTER DISPLAY 
     CONTINUE DISPLAY 
   END DISPLAY 
 
   CLOSE WINDOW q102_q4_w
 
END FUNCTION
 
 FUNCTION cbmq102_detail()
  DEFINE tm RECORD
         a               LIKE type_file.chr1   
         END RECORD
DEFINE  l_cmd           LIKE type_file.chr1000  

  OPEN WINDOW q102_detail_w WITH FORM "aim/42f/aimq102a"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
  CALL cl_ui_locale("aimq102a")
  LET tm.a='1' 
   DISPLAY BY NAME tm.a 
 
   INPUT BY NAME tm.a WITHOUT DEFAULTS
      AFTER FIELD a
            IF tm.a NOT MATCHES '[1234]' THEN 
               NEXT FIELD a
            END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW q102_detail_w
      RETURN
   END IF
   
   CLOSE WINDOW q102_detail_w
   CASE tm.a
      WHEN '1'
        LET l_cmd = "asfq610"," '1' "," '",g_ima.ima01,"'"
        CALL cl_cmdrun(l_cmd) 
      WHEN '2'
        LET l_cmd = "axmq611"," '2' "," '",g_ima.ima01,"'"
        CALL cl_cmdrun(l_cmd)
      WHEN '3'
        LET l_cmd = "aimq611"," '3' "," '",g_ima.ima01,"'"
        CALL cl_cmdrun(l_cmd)
      WHEN '4'
        LET l_cmd = "asfq612"," '4' "," '",g_ima.ima01,"'"
        CALL cl_cmdrun(l_cmd)
   END CASE
END FUNCTION

FUNCTION q102_q_imgs()
   DEFINE l_imgs01  LIKE imgs_file.imgs01
   DEFINE l_imgs02  LIKE imgs_file.imgs02
   DEFINE l_imgs03  LIKE imgs_file.imgs03
   DEFINE l_imgs04  LIKE imgs_file.imgs04
   DEFINE l_ima918  LIKE ima_file.ima918
   DEFINE l_ima921  LIKE ima_file.ima921
   DEFINE g_imgs DYNAMIC ARRAY OF RECORD
                    imgs05   LIKE imgs_file.imgs05,
                    imgs06   LIKE imgs_file.imgs06,
                    imgs07   LIKE imgs_file.imgs07,
                    imgs08   LIKE imgs_file.imgs08,
                    imgs09   LIKE imgs_file.imgs09,
                    imgs10   LIKE imgs_file.imgs10,
                    imgs11   LIKE imgs_file.imgs11,
#TQC-C20310 ----- add ----- begin
                    att01    LIKE inj_file.inj04,
                    att02    LIKE inj_file.inj04,
                    att03    LIKE inj_file.inj04,
                    att04    LIKE inj_file.inj04,
                    att05    LIKE inj_file.inj04,
                    att06    LIKE inj_file.inj04,
                    att07    LIKE inj_file.inj04,
                    att08    LIKE inj_file.inj04,
                    att09    LIKE inj_file.inj04,
                    att10    LIKE inj_file.inj04
#TQC-C20310 ----- add ----- end
                 END RECORD
#TQC-C20310 ----- add ----- begin
   DEFINE g_inj03 DYNAMIC ARRAY OF RECORD
                    inj03      LIKE inj_file.inj03,
                    ini02      LIKE ini_file.ini02
                  END RECORD
  DEFINE li_i, li_j            LIKE type_file.num5
  DEFINE lc_index                     STRING
  DEFINE ls_show,ls_hide              STRING
  DEFINE l_inj04               LIKE inj_file.inj04
#TQC-C20310 ----- add ----- end
 
   SELECT ima918,ima921 INTO l_ima918,l_ima921 
     FROM ima_file
    WHERE ima01 = g_ima.ima01
   
   IF cl_null(l_ima918) THEN
      LET l_ima918="N"
   END IF
 
   IF cl_null(l_ima921) THEN
      LET l_ima921="N"
   END IF
 
   IF l_ima918 <> "Y" AND l_ima921 <> "Y" THEN
      RETURN
   END IF
 
   LET p_row = 6 LET p_col = 2
 
   OPEN WINDOW q102_q_imgs_w AT p_row,p_col WITH FORM "aim/42f/aimq1026"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_locale("aimq1026")
 
   DISPLAY g_ima.ima01,g_img[l_ac].img02,g_img[l_ac].img03,g_img[l_ac].img04 
        TO imgs01,imgs02,imgs03,imgs04 
 
   DECLARE q102_q_imgs_c CURSOR FOR SELECT imgs05,imgs06,imgs07,imgs08,
                                           imgs09,imgs10,imgs11
                   #TQC-C20310 ----- add ----- begin
                                           ,'','','','',''
                                           ,'','','','',''
                   #TQC-C20310 ----- add ----- end
                                      FROM imgs_file
                                     WHERE imgs01 = g_ima.ima01
                                       AND imgs02 = g_img[l_ac].img02
                                       AND imgs03 = g_img[l_ac].img03
                                       AND imgs04 = g_img[l_ac].img04
                                       AND imgs08 > 0
                                     ORDER BY imgs05,imgs06 
 
   CALL g_imgs.clear()
 
   LET g_cnt=1
 
#TQC-C20310 ----- add ----- begin
   DECLARE inj_curs  CURSOR FOR 
                  SELECT DISTINCT inj03,'' FROM inj_file
                   WHERE inj01 = g_ima.ima01
   #依料件特性資料動態顯示隱藏欄位名稱及內容
   LET ls_hide = ' '
   LET ls_show = ' '
   LET li_i    = 1
   FOREACH inj_curs INTO g_inj03[li_i].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF       

      SELECT ini02 INTO g_inj03[li_i].ini02 FROM ini_file     
       WHERE ini01 = g_inj03[li_i].inj03
      LET lc_index = li_i USING '&&'
      CALL cl_set_comp_att_text("att" || lc_index,g_inj03[li_i].ini02)
      IF li_i = 1 THEN
         LET  ls_show = ls_show || "att" || lc_index
      ELSE
         LET  ls_show = ls_show || ",att" || lc_index
      END IF
      LET li_i = li_i + 1
   END FOREACH 
   CALL g_inj03.deleteElement(li_i)
   LET li_i = li_i - 1
   FOR li_j = li_i TO 10
       LET lc_index = li_j USING '&&'
       IF li_j = li_i THEN
          LET ls_hide = ls_hide || "att" || lc_index
       ELSE
          LET ls_hide = ls_hide || ",att" || lc_index
       END IF
   END FOR      
   CALL cl_set_comp_visible(ls_hide,FALSE)
   CALL cl_set_comp_visible(ls_show,TRUE)
#TQC-C20310 ----- add ----- end

   FOREACH q102_q_imgs_c INTO g_imgs[g_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach imgs:',STATUS,1)
         EXIT FOREACH
      END IF
 #TQC-C20310 ----- add ----- begin
      FOR li_j = 1 TO li_i
          LET l_inj04 = NULL
          SELECT inj04 INTO l_inj04 FROM inj_file
           WHERE inj01 = g_ima.ima01
             AND inj02 = g_imgs[g_cnt].imgs06
             AND inj03 = g_inj03[li_j].inj03

            CASE li_j
               WHEN 1
                  LET g_imgs[g_cnt].att01 = l_inj04
               WHEN 2
                  LET g_imgs[g_cnt].att02 = l_inj04
               WHEN 3
                  LET g_imgs[g_cnt].att03 = l_inj04
               WHEN 4
                  LET g_imgs[g_cnt].att04 = l_inj04
               WHEN 5
                  LET g_imgs[g_cnt].att05 = l_inj04
               WHEN 6
                  LET g_imgs[g_cnt].att06 = l_inj04
               WHEN 7
                  LET g_imgs[g_cnt].att07 = l_inj04
               WHEN 8
                  LET g_imgs[g_cnt].att08 = l_inj04
               WHEN 9
                  LET g_imgs[g_cnt].att09 = l_inj04
               WHEN 10
                  LET g_imgs[g_cnt].att10 = l_inj04
            END CASE
         END FOR
 #TQC-C20310 ----- add ----- end
      LET g_cnt=g_cnt+1
 
   END FOREACH
 
   DISPLAY ARRAY g_imgs TO s_imgs.*
 
      BEFORE ROW                                                                                                                    
         LET l_ac = ARR_CURR()                                                                                                      
         CALL cl_show_fld_cont() 
 
      ON ACTION detail                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = 1                                                                                                               
         CONTINUE DISPLAY      
 
      ON ACTION accept                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = ARR_CURR()                                                                                                      
         CONTINUE DISPLAY    
                                                                                                                                    
      ON ACTION cancel                                                                                                              
         LET INT_FLAG=FALSE  
         LET g_action_choice="exit"                                                                                                 
         EXIT DISPLAY           
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
      AFTER DISPLAY 
         CONTINUE DISPLAY 
 
   END DISPLAY 
 
   CLOSE WINDOW q102_q_imgs_w
 
END FUNCTION


FUNCTION cbmq102_fetch2(p_flag,p_idx)    #FUN-9A50010 加參數p_idx
DEFINE p_flag     LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)      #處理方式
DEFINE p_idx     LIKE type_file.num5     #雙按Tree的節點index  #FUN-9A50010
DEFINE l_i       LIKE type_file.num5     #FUN-9A50010
DEFINE l_jump    LIKE type_file.num5     #跳到QBE中Tree的指定筆 #FUN-9A50010
DEFINE   l_n1       LIKE type_file.num15_3
DEFINE   l_n2       LIKE type_file.num15_3
DEFINE   l_n3       LIKE type_file.num15_3

    MESSAGE ""
   CASE p_flag
        WHEN 'F' FETCH FIRST    cbmq102_curs INTO g_bma.bma01,g_bma.bma06
        WHEN 'L' FETCH LAST     cbmq102_curs INTO g_bma.bma01,g_bma.bma06
        OTHERWISE
         message ""
   end case
     
    # TODO:直接查询栏位
    SELECT ima01, ima02, ima021, ima25, ima05, ima06,
#          ima08, ima37, ima70, ima15, ima906,ima907,ima261,ima262   #FUN-5C0086
           ima08, ima37, ima70, ima15, ima906,ima907,0,0             #NO.FUN-A20044
      INTO g_ima.ima01,g_ima.ima02,g_ima.ima021,g_ima.ima25,g_ima.ima05,
           g_ima.ima06,g_ima.ima08,g_ima.ima37,g_ima.ima70,g_ima.ima15,
           g_ima.ima906,g_ima.ima907,   #FUN-5C0086
#          g_ima.ima261,g_ima.ima262                                 #NO.FUN-A20044 
           g_unavl_stk,g_avl_stk                                     #NO.FUN-A20044         
        FROM ima_file
       WHERE ima01 = g_bma.bma01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"",
                    "",0)   #No.FUN-660156
        RETURN
    END IF
    CALL s_getstock(g_ima.ima01,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
    LET g_unavl_stk = l_n2                                  #NO.FUN-A20044
    LET g_avl_stk = l_n3                                    #NO.FUN-A20044  
    CALL cbmq102_show()

END FUNCTION
