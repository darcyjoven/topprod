# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: asfq301.4gl
# Descriptions...: 工單狀況查詢
# Date & Author..: 97/08/01 By Roger
# Modify.........: 98/10/23 By Star 增加11.拆件式工單型態
# Modify.........: No:7773 03/08/13 Melody 避免與 axcp013 結果不符, 6.入庫選項的 '入退量' 改用 USING '----&.&&' 呈現
# Modify.........: No:8892 03/12/16 Ching sfb82(製造部門/委外廠商)應根據工單型態(sfb02)抓不同的來源
#                                         sfb02=7 or 8時,抓供應商資料(pmc_file);其他則抓部門資料(gem_file)
# Modify.........: No:9029 04/01/08 Melody FOR g_cnt = 1 TO g_bbb_arrno LET g_bbb[g_cnt]=' ' END FOR 其中 ' ' 應長一點,才不會有字串保留覆
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位用like方式
# Modify.........: No.MOD-4B0173 04/11/22 by Carol 因變數內容沒有清成空白,so先查一筆有資料的之後, 再查一筆不存在的資料, 則單身會續留上一筆資訊
# Modify.........: No.MOD-4B0238 04/11/25 by Carol 直接執行此程式時,用滑鼠無法打X離開
# Modify.........: No.MOD-4C0010 04/12/02 By Mandy DEFINE smydesc欄位用LIKE方式
# Modify.........: No.FUN-550067 05/05/31 By Trisy 單據編號加大
# Modify.........: No.FUN-570175 05/07/18 By Elva  新增雙單位內容
# Modify.........: No.MOD-5A0048 05/10/04 By Sarah 已發料,但發料頁面沒show出資料
# Modify.........: No.FUN-610006 06/01/07 By Smapmin 雙單位畫面調整
# Modify.........: No.TQC-630106 06/03/10 By Claire DISPLAY ARRAY無控制單身筆數
# Modify.........: No.FUN-650096 06/05/17 By Sarah 在 [基本資料] add 報廢數量(sfa063) after sfa07(欠料數量)
# Modify.........: No.MOD-650128 06/06/01 By Pengu q301_6()為什麼只取tlff_file，應該考慮tlf_file
# Modify.........: No.FUN-660106 06/06/16 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-660128 06/06/28 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/16 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-750032 07/05/10 By pengu 新增部門廠商欄位也能查廠商的資料
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-840681 08/04/29 By Carol [製程]資料顯示調整(per也要調)
# Modify.........: No.MOD-860081 08/06/06 By jamie ON IDLE問題
# Modify.........: No.FUN-840232 08/08/01 By sherry 表身查詢畫面,建議新增報工單資料查詢
# Modify.........: No.FUN-870086 08/09/01 By claire (1)開放匯出excel的功能
#                                                   (2)單身每個page都要於匯出excel
# Modify.........: No.TQC-880001 08/09/01 By claire 匯出excel的功能,給預設單身值
# Modify.........: No.FUN-8A0134 08/11/04 By jan 在 [基本資料] add 超領數量(sfa062)
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.MOD-920123 09/02/09 By claire 委外page,不應顯示採購下階料的單據
# Modify.........: No.MOD-930034 09/03/04 By shiwuying 當報工單狀態為“X作廢”，但在asfq301還是有顯示此報報工單
# Modify.........: No.FUN-940008 09/05/07 By hongmei 發料改善
# Modify.........: No.MOD-950148 09/05/14 By lutingting 制程頁簽的作業說明改抓aeci700的作業名稱ecm45 
# Modify.........: No.FUN-960100 09/06/30 By mike 在"基本資料"的單身頁簽中在"發料料號"欄位后面加上"替代碼"欄位，請將替代碼改成呈現在
#                                                 而不要再跟料號共用同一個欄位   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990010 09/11/06 By jan 單身新增'工藝報工'page
# Modify.........: No:MOD-990001 09/11/12 By sabrina 預計結存量未考慮發料單位與庫存單位轉換率
# Modify.........: No.FUN-9C0072 10/01/11 By vealxu 精簡程式碼
# Modify.........: No.FUN-A20037 10/03/15 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo 於GP5.2 Single DB架構中，因img_file 透過view會過濾Plant Code，因此會造 
#                                                  成ima26*角色混亂的狀況，因此对ima26的调整
# Modify.........: No:MOD-A50051 10/05/10 By Sarah "報工"頁籤無法匯出Excel
# Modify.........: No.FUN-A60027 10/06/08 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:CHI-A50043 10/06/17 By Summer "發料"page中的料號欄位後面加上品名與規格
# Modify.........: No:FUN-A80150 10/09/07 By sabrina 單頭新增"計劃批號"(sfb919)欄位
# Modify.........: No:MOD-AC0393 10/12/29 By sabrina 將FQC頁籤的抽驗量移除
# Modify.........: No.FUN-B10030 11/01/19 By vealxu 拿掉"營運中心切換"ACTION
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No:MOD-BB0290 11/11/25 By johung 工單有製程且有異動單號時，製程單身查詢結果資料與資料間會多一行空行
# Modify.........: No:CHI-C30131 12/06/21 By bart 增加phase out欄位
# Modify.........: No:FUN-C70014 12/07/09 By wangwei 新增RUN CARD發料作業
# Modify.........: No:MOD-C70186 12/07/17 By ck2yuan 欄位 h6 庫存數量顯示錯誤
# Modify.........: No:TQC-C70156 12/08/06 By lixh1 替代頁簽出現有空白行
# Modify.........: No:FUN-C30114 12/08/07 By batr 新增欄位上階工單單號(sfb89)
# Modify.........: No:TQC-CC0004 12/12/03 By qirl 操作優化
# Modify.........: No:TQC-CC0005 12/12/03 By qirl 增加開窗
# Modify.........: No:TQC-CC0007 12/12/04 By qirl 操作優化
# Modify.........: No:TQC-CC0014 12/12/04 By qirl 操作優化
# Modify.........: No:TQC-CC0015 12/12/04 By qirl 操作優化
# Modify.........: No:MOD-D10176 13/01/18 By bart 把pmn20/pmn50/pmn82/pmn85 改為 USING '-------&.&&&'
# Modify.........: No:CHI-D20030 13/03/08 By bart 加入當站下線資料
# Modify.........: No:MOD-D50061 13/05/08 By bart 外部呼叫應該直接帶出查詢資料
# Modify.........: No:MOD-D60245 13/06/28 By suncx 外部呼叫應該直接帶出查詢資料後應該可以直接輸入條件查詢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE   g_arr1         DYNAMIC ARRAY OF RECORD
            a1          LIKE sfa_file.sfa03,
            a9          LIKE ima_file.ima02,
            a10         LIKE ima_file.ima021,
            a11         LIKE sfa_file.sfa26, #FUN-960100      
            a2          LIKE sfa_file.sfa08,
            a12         LIKE ima_file.ima140,  #CHI-C30131
            a3          LIKE sfa_file.sfa05,
            a4          LIKE sfa_file.sfa06,
            a5          LIKE sfa_file.sfa07,
            a51         LIKE sfa_file.sfa063,   #FUN-650096 add
            a52         LIKE sfa_file.sfa062,   #FUN-8A0134
            a6          LIKE sfa_file.sfa07,
#           a7          LIKE ima_file.ima262,
#           a8          LIKE ima_file.ima262,
            a7          LIKE type_file.num15_3, ###GP5.2  #NO.FUN-A20044
            a8          LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
#           a9          LIKE ima_file.ima02,
#           a10         LIKE ima_file.ima021
                        END RECORD
DEFINE   g_arr2         DYNAMIC ARRAY OF RECORD
            b1          LIKE ecm_file.ecm03,
            b2          LIKE ecm_file.ecm301,
            b3          LIKE ecm_file.ecm45,  #No.MOD-950148 add
            b4          LIKE sfq_file.sfq01,
            b5          LIKE type_file.chr10,     #類別sfp06     #MOD-840681-modify
            b6          LIKE sfp_file.sfp03,      #MOD-840681-modify
            b7          LIKE sfq_file.sfq03,      #MOD-840681-modify
            b8          LIKE sfv_file.sfv09,      #MOD-840681-modify
            b9          LIKE sfv_file.sfv12       #MOD-840681-modify
                        END RECORD
DEFINE   g_arr3         DYNAMIC ARRAY OF RECORD
            c1          LIKE pmm_file.pmm01,
            c2          LIKE pmm_file.pmm09,
            c3          LIKE pmn_file.pmn02,
            c4          LIKE pmn_file.pmn04,
            c12         LIKE ima_file.ima02,     #TQC-CC0007
            c13         LIKE ima_file.ima021,    #TQC-CC0007
            c5          LIKE pmn_file.pmn33,
            c6          LIKE pmn_file.pmn20,
            c8          LIKE pmn_file.pmn83,
            c9          LIKE pmn_file.pmn85,
            c10         LIKE pmn_file.pmn80,
            c11         LIKE pmn_file.pmn82,
            c7          LIKE pmn_file.pmn50
                        END RECORD
DEFINE   g_arr4         DYNAMIC ARRAY OF RECORD
            d1          LIKE tlf_file.tlf06,
            d21         like tlf_file.tlf08,  #darcy:2024/12/18 add
            d2          LIKE tlf_file.tlf905,
            d3          LIKE tlf_file.tlf906,
            d4          LIKE tlf_file.tlf01,
            d15         LIKE ima_file.ima02,   #CHI-A50043 add
            d16         LIKE ima_file.ima021,  #CHI-A50043 add
            d5          LIKE tlf_file.tlf05,
            d6          LIKE tlf_file.tlf902,
            d19         LIKE imd_file.imd02,   #TQC-CC0007
            d7          LIKE tlf_file.tlf903,
            d20         LIKE ime_file.ime03,   #TQC-CC0007
            d8          LIKE tlf_file.tlf904,
            d9          LIKE tlf_file.tlf10,
            d10         LIKE tlf_file.tlf11,
            d11         LIKE tlf_file.tlf11,
            d12         LIKE tlf_file.tlf10,
            d13         LIKE tlf_file.tlf11,
            d14         LIKE tlf_file.tlf10,
            d17         LIKE sfs_file.sfs012,     #FUN-A60027
            d18         LIKE sfs_file.sfs013      #FUN-A60027
                        END RECORD
DEFINE   g_arr5         DYNAMIC ARRAY OF RECORD
            e1          LIKE qcf_file.qcf01,
            e2          LIKE qcf_file.qcf04,
            e3          LIKE qcf_file.qcf22,
           #e4          LIKE qcf_file.qcf06,                   #MOD-AC0393 mark
            e5          LIKE qcf_file.qcf091
                        END RECORD
DEFINE   g_arr6         DYNAMIC ARRAY OF RECORD
            f1          LIKE tlf_file.tlf06,
            f19         like tlf_file.tlf08, #darcy:2024/12/18 add
            f2          LIKE tlf_file.tlf905,
            f3          LIKE tlf_file.tlf906,
            f4          LIKE tlf_file.tlf01,
            f15         LIKE ima_file.ima02,     #TQC-CC0014
            f16         LIKE ima_file.ima021,    #TQC-CC0014
            f5          LIKE tlf_file.tlf902,
            f17         LIKE imd_file.imd02,     #TQC-CC0014
            f6          LIKE tlf_file.tlf903,
            f18         LIKE ime_file.ime03,     #TQC-CC0014
            f7          LIKE tlf_file.tlf904,
            f8          LIKE tlf_file.tlf10,
            f9          LIKE tlf_file.tlf11,
            f11         LIKE tlf_file.tlf11,
            f12         LIKE tlf_file.tlf10,
            f13         LIKE tlf_file.tlf11,
            f14         LIKE tlf_file.tlf10,
            f10         LIKE tlf_file.tlf05
                        END RECORD
DEFINE   g_arr7         DYNAMIC ARRAY OF RECORD
            g1          LIKE sfb_file.sfb01,
            g2          LIKE sfb_file.sfb05,
            g8          LIKE ima_file.ima02,     #TQC-CC0014
            g9          LIKE ima_file.ima021,    #TQC-CC0014
            g3          LIKE sfb_file.sfb82,
            g10         LIKE gem_file.gem02, #TQC-CC0014
            g4          LIKE sfb_file.sfb13,
            g5          LIKE sfb_file.sfb08,
            g6          LIKE sfb_file.sfb081,
            g7          LIKE sfb_file.sfb09
                        END RECORD
DEFINE   g_arr8         DYNAMIC ARRAY OF RECORD
            h1          LIKE sfa_file.sfa27,
            h7          LIKE ima_file.ima02,     #TQC-CC0014
            h8          LIKE ima_file.ima021,    #TQC-CC0014
            h2          LIKE sfa_file.sfa26,
#           h3          LIKE ima_file.ima26,        #No.FUN-680121 DEC(15,3) 
#           h4          LIKE ima_file.ima262,
            h3          LIKE type_file.num15_3,     ###GP5.2  #NO.FUN-A20044
            h4          LIKE type_file.num15_3,     ###GP5.2  #NO.FUN-A20044
            h5          LIKE bmd_file.bmd04,
            h9          LIKE ima_file.ima02,     #TQC-CC0014
            h10         LIKE ima_file.ima021,    #TQC-CC0014
#           h6          LIKE ima_file.ima262
            h6          LIKE type_file.num15_3      ###GP5.2  #NO.FUN-A20044
                        END RECORD
DEFINE   g_arr9         DYNAMIC ARRAY OF RECORD
            i1          LIKE sfa_file.sfa03,
            i2          LIKE sfa_file.sfa05,
            i3          LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(40)
                        END RECORD
DEFINE   g_arr10        DYNAMIC ARRAY OF RECORD
            j1          LIKE shm_file.shm01,
            j2          LIKE shm_file.shm08,
            j3          LIKE shm_file.shm13,
            j4          LIKE shm_file.shm15,
            j5          LIKE shm_file.shm09
                        END RECORD
DEFINE   g_arr11        DYNAMIC ARRAY OF RECORD
            k1          LIKE srf_file.srf01,
            k2          LIKE srf_file.srf02,
            k3          LIKE srg_file.srg02,
            k4          LIKE srg_file.srg04,
            k5          LIKE srg_file.srg15,
            k6          LIKE srg_file.srg05,
            k7          LIKE srg_file.srg06,
            k8          LIKE srg_file.srg07,
            k9          LIKE srg_file.srg08,
            k10         LIKE srg_file.srg09,
            k11         LIKE srg_file.srg10,
            k12         LIKE srg_file.srg11,
            k13         LIKE srg_file.srg12
                        END RECORD
DEFINE   g_arr13      DYNAMIC ARRAY OF RECORD
         m1           LIKE shb_file.shb01,
         m2           LIKE shb_file.shb02,
         m021         LIKE shb_file.shb021,
         m3           LIKE shb_file.shb03,
         m031         LIKE shb_file.shb031,
         m032         LIKE shb_file.shb032,
         m033         LIKE shb_file.shb033,
         m4           LIKE shb_file.shb04,
         m041         LIKE gen_file.gen02,    #TQC-CC0015---add--
         m5           LIKE shb_file.shb05,
         m6           LIKE shb_file.shb06,
         m7           LIKE shb_file.shb07,
         m8           LIKE shb_file.shb08,
         m081         LIKE shb_file.shb081,
         m9           LIKE shb_file.shb09,
         m10          LIKE shb_file.shb10,
         m111         LIKE shb_file.shb111,
         m112         LIKE shb_file.shb112,
         m113         LIKE shb_file.shb113,
         m114         LIKE shb_file.shb114,
         m115         LIKE shb_file.shb115,
         m12          LIKE shb_file.shb12,
         m13          LIKE shb_file.shb13,
         m14          LIKE shb_file.shb14,
         m15          LIKE shb_file.shb15,
         m16          LIKE shb_file.shb16,
         m17          LIKE shb_file.shb17,
         m18          LIKE shb_file.shb012    #FUN-A60027
                      END RECORD 
#CHI-D20030---begin
DEFINE   g_arr14      DYNAMIC ARRAY OF RECORD
         n01          LIKE shd_file.shd01,
         n02          LIKE shd_file.shd02,
         n031         LIKE shb_file.shb03,
         n06          LIKE shd_file.shd06,
         n03          LIKE shd_file.shd03,
         n04          LIKE shd_file.shd04,
         n05          LIKE shd_file.shd05,
         n16          LIKE shd_file.shd16,
         n07          LIKE shd_file.shd07,
         n18          LIKE shd_file.shd18,
         n181         LIKE azf_file.azf03
                      END RECORD 
#CHI-D20030---end                      
DEFINE   g_sfb              RECORD LIKE sfb_file.*,
         g_ima              RECORD LIKE ima_file.*,
         g_pmc              RECORD LIKE pmc_file.*,
         g_bbb_flag         LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
         g_bbb              ARRAY[600] of LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(79)
         g_line1,g_line2,l_line3	  LIKE type_file.num10,         #No.FUN-680121 INTEGER
          g_wc,g_wc2         string,  #No.FUN-580092 HCN
          g_sql              string,  #No.FUN-580092 HCN
         g_t1               LIKE oay_file.oayslip,                      #No.FUN-550067        #No.FUN-680121 VARCHAR(05)
         g_argv1            LIKE type_file.chr21,        #No.FUN-680121 VARCHAR(21)
         g_buf              LIKE type_file.chr20,        #No.FUN-680121 CAHR(20)
         g_rec_b            LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE   l_za05             LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(40)
DEFINE   g_flag             LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_b_flag           LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE   g_row_count        LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_curs_index       LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_i                LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE   g_forupd_sql       STRING
DEFINE   g_chr              LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_msg              LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(72)
DEFINE   g_cnt              LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE   g_jump             LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   mi_no_ask          LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE   g_confirm          LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_approve          LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_post             LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_close            LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_void             LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_valid            LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1) 
DEFINE   g_b_flag_up        LIKE type_file.num5          #TQC-CC0007
DEFINE   l_ac               LIKE type_file.num10         #TQC-CC0007
DEFINE   l_ac_t             LIKE type_file.num10         #TQC-CC0007
DEFINE   w    ui.Window
DEFINE   f    ui.Form
DEFINE   page om.DomNode
 
MAIN
   DEFINE   p_row,p_col   LIKE type_file.num5          #No.FUN-680121 SMALLINT
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
  LET g_argv1=ARG_VAL(1)
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211 
   OPEN WINDOW t301_w AT p_row,p_col WITH FORM "asf/42f/asfq301"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL q301_def_form()
 
 
   IF NOT cl_null(g_argv1) THEN #MOD-D50061
      CALL q301_q()       #TQC-CC0004--mark--  #MOD-D50061
      LET g_argv1 = ''    #MOD-D60245 add
   END IF #MOD-D50061 
   CALL q301()
   CLOSE WINDOW t301_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
END MAIN
 
FUNCTION q301()
   LET g_wc2=' 1=1'
 
   LET g_forupd_sql= " SELECT * FROM sfb_file ",
                      " WHERE sfb01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE q301_cl CURSOR FROM g_forupd_sql
 
   SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
   CALL q301_menu()
END FUNCTION
 
FUNCTION q301_cs()
   IF NOT cl_null(g_argv1) THEN
      LET g_wc=" sfb01='",g_argv1,"'"
   ELSE
      CLEAR FORM                             #清除畫面
       LET g_action_choice=" "                #MOD-4B0238 add
      CALL cl_set_head_visible("group01","YES")  #NO.FUN-6B0031
   INITIALIZE g_sfb.* TO NULL    #No.FUN-750051
#---TQC-CC0007---add---star---
#       LET g_sfb.sfb23 = 'N'
#       LET g_sfb.sfb24 = 'N'
#       LET g_sfb.sfb41 = 'N'
#       LET g_sfb.sfb99 = 'N'
#---TQC-CC0007---add---end----
      CONSTRUCT BY NAME g_wc ON              # 螢幕上取單頭條件
          sfb01, sfb81, sfb98, sfb02, sfb04, sfb39,
          sfb82, sfb22, sfb221, sfb05, sfb08,
          sfb081, sfb09, sfb07, sfb071, sfb06,
          sfb919,sfb86,sfb89, sfb13, sfb25, sfb15, sfb28,        #FUN-A80150 add sfb919 #FUN-C30114 sfb89
          sfb38, sfb34, sfb27,
          sfb23, sfb24, sfb41, sfb99
# 2004/03/29 by saki : 加此段的on action是怕 如果在construct的時候 被指定其中之一的table
#                      來查詢, 就要出現相符的資料
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
#---TQC-CC0007---add---star--
#       DISPLAY g_sfb.sfb23 TO sfb23 
#       DISPLAY g_sfb.sfb24 TO sfb24
#       DISPLAY g_sfb.sfb41 TO sfb41
#       DISPLAY g_sfb.sfb99 TO sfb99
#---TQC-CC0007---add---end----
        ON ACTION vend
           CALL cl_init_qry_var()
           LET g_qryparam.state    = "c"
           LET g_qryparam.form     = "q_pmc"
           LET g_qryparam.default1 = g_sfb.sfb82
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO sfb82
           NEXT FIELD sfb82
        ON ACTION controlp
           CASE WHEN INFIELD(sfb82)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_gem"
                     LET g_qryparam.default1 = g_sfb.sfb82
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfb82
                     NEXT FIELD sfb82
                WHEN INFIELD(sfb05) #item
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_ima"
                     LET g_qryparam.default1 = g_sfb.sfb05
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfb05
                     NEXT FIELD sfb05
                WHEN INFIELD(sfb06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_ecu"
                     LET g_qryparam.default1 = g_sfb.sfb06
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfb06
                     NEXT FIELD sfb06
#----TQC-CC0005---add---star----
                WHEN INFIELD(sfb01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_sfa10"
                     LET g_qryparam.default1 = g_sfb.sfb01
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfb01
                     NEXT FIELD sfb01
                WHEN INFIELD(sfb98)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_sfb98"
                     LET g_qryparam.default1 = g_sfb.sfb98
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfb98
                     NEXT FIELD sfb98
                WHEN INFIELD(sfb22)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_sfb22"
                     LET g_qryparam.default1 = g_sfb.sfb22
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfb22
                     NEXT FIELD sfb22
                WHEN INFIELD(sfb221)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_sfb221"
                     LET g_qryparam.default1 = g_sfb.sfb221
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfb221
                     NEXT FIELD sfb221
                WHEN INFIELD(sfb86)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_sfb861"
                     LET g_qryparam.default1 = g_sfb.sfb86
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfb86
                     NEXT FIELD sfb86
                WHEN INFIELD(sfb89)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_sfb89"
                     LET g_qryparam.default1 = g_sfb.sfb89
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfb89
                     NEXT FIELD sfb89
                WHEN INFIELD(sfb27)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_sfb27"
                     LET g_qryparam.default1 = g_sfb.sfb27
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfb27
                     NEXT FIELD sfb27
#----TQC-CC0005---add---end-----
                OTHERWISE EXIT CASE
            END CASE
 
         ON ACTION allotment
            LET g_b_flag = "1"
 
         ON ACTION routing
            LET g_b_flag = "2"
 
         ON ACTION sub_po
            LET g_b_flag = "3"
 
         ON ACTION issue
            LET g_b_flag = "4"
 
         ON ACTION fqc
            LET g_b_flag = "5"
 
         ON ACTION store_in
            LET g_b_flag = "6"
 
         ON ACTION sub_wo
            LET g_b_flag = "7"
 
         ON ACTION substitute
            LET g_b_flag = "8"
 
         ON ACTION qvl
            LET g_b_flag = "9"
 
         ON ACTION runcard
            LET g_b_flag = "10"
            
         ON ACTION report_no
            LET g_b_flag = "11"

         ON ACTION Routing_Reportable
            LET g_b_flag = "13"
         
         ON ACTION off_line  #CHI-D20030
            LET g_b_flag = "14"  #CHI-D20030
            
         ON ACTION cancel
            LET g_action_choice="exit"
            EXIT CONSTRUCT
 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT CONSTRUCT
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE CONSTRUCT
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
      END CONSTRUCT
 
       IF INT_FLAG OR g_action_choice = "exit" THEN    #MOD-4B0238 add 'exit'
         RETURN
      END IF
   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
 
   LET g_sql = "SELECT  sfb01 FROM sfb_file",
               " WHERE sfb87!='X' AND ", g_wc CLIPPED,
               " ORDER BY sfb01"
 
   PREPARE q301_prepare FROM g_sql
   DECLARE q301_cs SCROLL CURSOR WITH HOLD FOR q301_prepare
 
   LET g_sql="SELECT COUNT(*) FROM sfb_file WHERE sfb87!='X' AND ",g_wc CLIPPED
   PREPARE q301_precount FROM g_sql
   DECLARE q301_count CURSOR FOR q301_precount
END FUNCTION
 
FUNCTION q301_menu()
 
   WHILE TRUE
#---TQC-CC0004--mark--
#     IF g_action_choice = "exit"  THEN
#        EXIT WHILE
#     END IF
#---TQC-CC0004--mark--
      CASE g_b_flag
         WHEN '1'
            CALL q301_bp1("G")
         WHEN '2'
            CALL q301_bp2("G")
         WHEN '3'
            CALL q301_bp3("G")
         WHEN '4'
            CALL q301_bp4("G")
         WHEN '5'
            CALL q301_bp5("G")
         WHEN '6'
            CALL q301_bp6("G")
         WHEN '7'
            CALL q301_bp7("G")
         WHEN '8'
            CALL q301_bp8("G")
         WHEN '9'
            CALL q301_bp9("G")
         WHEN '10'
            CALL q301_bp10("G")
         WHEN '11'               #No.FUN-840232
            CALL q301_bp11("G")  #No.FUN-840232
         WHEN '13'               #No.FUN-990010
            CALL q301_bp13("G")  #No.FUN-990010
         WHEN '14'               #CHI-D20030
            CALL q301_bp14("G")  #CHI-D20030
         OTHERWISE
            CALL q301_bp1("G")
      END CASE
 
      CASE g_action_choice
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
 
         #@WHEN "查詢"
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q301_q()
            END IF
 
#        #@WHEN "備料"
         WHEN "allotment"
            CALL q301_1()
            LET g_b_flag = "1"
 
#        #@WHEN "製程"
         WHEN "routing"
            CALL q301_2()
            LET g_b_flag = "2"
 
#        #@WHEN "委外採購"
         WHEN "sub_po"
            CALL q301_3()
            LET g_b_flag = "3"
 
#        #@WHEN "發料"
         WHEN "issue"
            CALL q301_4()
            LET g_b_flag = "4"
 
         WHEN "fqc"
            CALL q301_5()
            LET g_b_flag = "5"
 
#        #@WHEN "入庫"
         WHEN "store_in"
            CALL q301_6()
            LET g_b_flag = "6"
 
#        #@WHEN "子工單"
         WHEN "sub_wo"
            CALL q301_7()
            LET g_b_flag = "7"
 
#        #@WHEN "替代"
         WHEN "substitute"
            CALL q301_8()
            LET g_b_flag = "8"
 
         WHEN "qvl"
            CALL q301_9()
            LET g_b_flag = "9"
 
         WHEN "runcard"
            CALL q301_10()
            LET g_b_flag = "10"
            
         WHEN "report_no"
            CALL q301_11()
            LET g_b_flag = "11"   
         
         WHEN "Routing_Reportable"
            CALL q301_13()
            LET g_b_flag = "13"   
         #CHI-D20030---begin
         WHEN "off_line"
            CALL q301_14()
            LET g_b_flag = "14"
         #CHI-D20030---end  
         #@WHEN "材料庫存"
         WHEN "inventory"
            LET g_msg="aimq102 2 '",g_sfb.sfb01,"'"
            CALL cl_cmdrun(g_msg)
 
         #@WHEN "材料供需"
         WHEN "meterial_supply"
            LET g_msg="aimq841 2 '",g_sfb.sfb01,"'"
            CALL cl_cmdrun(g_msg)
 
         #@WHEN "備註"
         WHEN "memo"
            CALL s_asf_memo('d',g_sfb.sfb01)
 
         #@WHEN "工單維護"
         WHEN "maint_w_o"
            LET g_msg="asfi301 '",g_sfb.sfb01,"'"
            CALL cl_cmdrun(g_msg)
 
         #@WHEN "切換資料庫"
        #WHEN "switch_plant"                   #FUN-B10030
        #   CALL cl_cmdrun('aoos901')          #FUN-B10030
        #   IF NOT cl_setup("ASF") THEN        #FUN-B10030
        #      EXIT PROGRAM                    #FUN-B10030
        #   END IF                             #FUN-B10030
         #@WHEN "匯出excel"
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
               LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               CASE g_b_flag
                WHEN '1'
                   LET page = f.FindNode("Page","page01")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_arr1),'','')
                WHEN '2'
                   LET page = f.FindNode("Page","page02")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_arr2),'','')
                WHEN '3'
                   LET page = f.FindNode("Page","page03")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_arr3),'','')
                WHEN '4'
                   LET page = f.FindNode("Page","page04")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_arr4),'','')
                WHEN '5'
                   LET page = f.FindNode("Page","page05")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_arr5),'','')
                WHEN '6'
                   LET page = f.FindNode("Page","page06")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_arr6),'','')
                WHEN '7'
                   LET page = f.FindNode("Page","page07")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_arr7),'','')
                WHEN '8'
                   LET page = f.FindNode("Page","page08")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_arr8),'','')
                WHEN '9'
                   LET page = f.FindNode("Page","page09")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_arr9),'','')
                WHEN '10'
                   LET page = f.FindNode("Page","page10")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_arr10),'','')
                WHEN '11'                                                             #MOD-A50051 add
                   LET page = f.FindNode("Page","page11")                             #MOD-A50051 add
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_arr11),'','')  #MOD-A50051 add
                WHEN '13'                                                             #FUN-990010
                   LET page = f.FindNode("Page","page13")                             #FUN-990010  
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_arr13),'','')  #FUN-990010
                WHEN '14'                                                             #CHI-D20030
                   LET page = f.FindNode("Page","page14")                             #CHI-D20030
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_arr14),'','')  #CHI-D20030
               END CASE
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q301_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   LET g_b_flag = ""
   LET g_b_flag = "1"   #TQC-880001 modify
   LET g_rec_b = 0
   DISPLAY g_rec_b TO cn2
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
#TQC-CC0007 -----------Begin-----------
   IF g_sma.sma541 = 'N' THEN
      CALL cl_set_comp_visible("ecm012,m18,d17,d18",FALSE)
   ELSE
      CALL cl_set_comp_visible("ecm012,m18,d17,d18",TRUE)
   END IF
#TQC-CC0007 -----------End-------------
   CALL q301_cs()
   IF INT_FLAG OR g_action_choice="exit" THEN
      LET INT_FLAG = 0
      INITIALIZE g_sfb.* TO NULL
      RETURN
   END IF
 
   MESSAGE " SEARCHING ! "
   OPEN q301_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_sfb.* TO NULL
   ELSE
      OPEN q301_count
      FETCH q301_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL q301_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION q301_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,                 #處理方式          #No.FUN-680121 VARCHAR(1)
            l_abso   LIKE type_file.num10                 #絕對的筆數        #No.FUN-680121 INTEGER
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     q301_cs INTO g_sfb.sfb01
      WHEN 'P' FETCH PREVIOUS q301_cs INTO g_sfb.sfb01
      WHEN 'F' FETCH FIRST    q301_cs INTO g_sfb.sfb01
      WHEN 'L' FETCH LAST     q301_cs INTO g_sfb.sfb01
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
         FETCH ABSOLUTE g_jump q301_cs INTO g_sfb.sfb01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      INITIALIZE g_sfb.* TO NULL
      CALL g_arr1.clear()
      CALL g_arr2.clear()
      CALL g_arr3.clear()
      CALL g_arr4.clear()
      CALL g_arr5.clear()
      CALL g_arr6.clear()
      CALL g_arr7.clear()
      CALL g_arr8.clear()
      CALL g_arr9.clear()
      CALL g_arr10.clear()
      CALL g_arr11.clear()    #No.FUN-840232   
      CALL g_arr13.clear()    #No.FUN-990010  
      CALL g_arr14.clear()    #CHI-D20030
      CALL cl_err(g_sfb.sfb01,SQLCA.sqlcode,0)
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
   SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01 = g_sfb.sfb01
   IF SQLCA.sqlcode THEN
      INITIALIZE g_sfb.* TO NULL
      CALL g_arr1.clear()
      CALL g_arr2.clear()
      CALL g_arr3.clear()
      CALL g_arr4.clear()
      CALL g_arr5.clear()
      CALL g_arr6.clear()
      CALL g_arr7.clear()
      CALL g_arr8.clear()
      CALL g_arr9.clear()
      CALL g_arr10.clear()
      CALL g_arr11.clear()    #No.FUN-840232 
      CALL g_arr13.clear()    #No.FUN-990010 
      CALL g_arr14.clear()    #CHI-D20030
      CALL cl_err3("sel","sfb_file",g_sfb.sfb01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660128
      RETURN
   END IF
   CALL q301_show()
END FUNCTION
 
FUNCTION q301_show()
   DEFINE l_smydesc LIKE smy_file.smydesc  #MOD-4C0010
   DISPLAY BY NAME
      g_sfb.sfb01, g_sfb.sfb81, g_sfb.sfb98,
      g_sfb.sfb02, g_sfb.sfb04, g_sfb.sfb39,
      g_sfb.sfb82, g_sfb.sfb22, g_sfb.sfb221,g_sfb.sfb05, g_sfb.sfb08,
      g_sfb.sfb081,g_sfb.sfb09, g_sfb.sfb07, g_sfb.sfb071, g_sfb.sfb06,
      g_sfb.sfb919,g_sfb.sfb86, g_sfb.sfb89,g_sfb.sfb13,g_sfb.sfb25,  g_sfb.sfb15, g_sfb.sfb28,    #FUN-A80150 add sfb919 #FUN-C30114 sfb89
      g_sfb.sfb38, g_sfb.sfb34, g_sfb.sfb27,
      g_sfb.sfb23, g_sfb.sfb24, g_sfb.sfb41, g_sfb.sfb99
 
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
   IF NOT cl_null(g_sfb.sfb28) THEN
      LET g_close = 'Y'
   ELSE
      LET g_close = 'N'
   END IF
   #圖形顯示
   CALL cl_set_field_pic(g_confirm,"","",g_close,g_void,g_sfb.sfbacti)
 
   LET g_buf = s_get_doc_no(g_sfb.sfb01)   #No.FUN-550067
   SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip=g_buf
   DISPLAY l_smydesc TO smydesc
   LET g_buf = NULL
 
   INITIALIZE g_ima.* TO NULL
   SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_sfb.sfb05
   DISPLAY BY NAME g_ima.ima02,g_ima.ima021,g_ima.ima55
 
    LET g_buf=''
    IF NOT cl_null(g_sfb.sfb82) THEN
       IF (g_sfb.sfb02=7 OR g_sfb.sfb02=8 ) THEN #NO:7075
          SELECT pmc03 INTO g_buf FROM pmc_file WHERE pmc01=g_sfb.sfb82
       ELSE
          SELECT gem02 INTO g_buf FROM gem_file WHERE gem01=g_sfb.sfb82
             AND gemacti='Y'   #NO:6950
       END IF
    END IF
    DISPLAY g_buf TO pmc03
 
   CASE g_b_flag
      WHEN '1'
         CALL q301_1()
      WHEN '2'
         CALL q301_2()
      WHEN '3'
         CALL q301_3()
      WHEN '4'
         CALL q301_4()
      WHEN '5'
         CALL q301_5()
      WHEN '6'
         CALL q301_6()
      WHEN '7'
         CALL q301_7()
      WHEN '8'
         CALL q301_8()
      WHEN '9'
         CALL q301_9()
      WHEN '10'
         CALL q301_10()
      WHEN '11'
         CALL q301_11()
      WHEN '13'              #FUN-990010
         CALL q301_13()      #FUN-990010
      WHEN '14'              #CHI-D20030
         CALL q301_14()      #CHI-D20030
      OTHERWISE
         CALL q301_1()
   END CASE
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q301_1()
   DEFINE   l_sfa       RECORD LIKE sfa_file.*
   DEFINE   l_ima02     LIKE ima_file.ima02
   DEFINE   l_ima021    LIKE ima_file.ima021
#  DEFINE   l_ima262    LIKE ima_file.ima262      #NO.FUN-A20044
   DEFINE   l_avl_stk   LIKE type_file.num15_3    ###GP5.2  #NO.FUN-A20044
   DEFINE   l_ima25    LIKE ima_file.ima25     
   DEFINE   l_cnt      LIKE type_file.num5
   DEFINE   l_factor   LIKE ima_file.ima55_fac
   DEFINE   l_short_qty LIKE sfa_file.sfa07    #FUN-940008 add
   DEFINE   l_n1        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_n2        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_n3        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044 
   DEFINE   l_ima140    LIKE ima_file.ima140   #CHI-C30131

   DECLARE q301_1_c CURSOR FOR
#     SELECT sfa_file.*, ima02,ima021,ima262,ima25 FROM sfa_file, ima_file      #No:MOD-990001 add ima25
      SELECT sfa_file.*, ima02,ima021,0,ima25,ima140 FROM sfa_file, ima_file           #NO.FUN-A20044  #CHI-C30131 add ima140
       WHERE sfa01 = g_sfb.sfb01 AND sfa03 = ima01
       ORDER BY sfa27
 
   CALL g_arr1.clear()
 
   LET g_rec_b = 0
   LET g_cnt=1
#  FOREACH q301_1_c INTO l_sfa.*,l_ima02,l_ima021,l_ima262,l_ima25     #No:MOD-990001 add l_ima25
   FOREACH q301_1_c INTO l_sfa.*,l_ima02,l_ima021,l_avl_stk,l_ima25,l_ima140    #NO.FUN-A20044  #CHI-C30131 add ima140
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)   
         EXIT FOREACH
      END IF
      CALL s_getstock(l_sfa.sfa03,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044 
      LET l_avl_stk = l_n3                                            #NO.FUN-A20044
      CALL s_umfchk(l_sfa.sfa03,l_sfa.sfa12,l_ima25)
             RETURNING l_cnt,l_factor
      IF l_cnt THEN LET l_factor = 1 END IF
      IF cl_null(l_factor) THEN LET l_factor = 1 END IF
      #計算欠料量
      CALL s_shortqty(l_sfa.sfa01,l_sfa.sfa03,l_sfa.sfa08,
                      l_sfa.sfa12,l_sfa.sfa27,l_sfa.sfa012,l_sfa.sfa013)      #FUN-A60027 add sfa012 sfa013
         RETURNING l_short_qty
      IF cl_null(l_short_qty) THEN LET l_short_qty = 0 END IF
      LET g_arr1[g_cnt].a1  = l_sfa.sfa03
      LET g_arr1[g_cnt].a11 = l_sfa.sfa26 #FUN-960100   
      LET g_arr1[g_cnt].a2  = l_sfa.sfa08
      LET g_arr1[g_cnt].a12 = l_ima140    #CHI-C30131
      LET g_arr1[g_cnt].a3  = l_sfa.sfa05
      LET g_arr1[g_cnt].a4  = l_sfa.sfa06
      LET g_arr1[g_cnt].a5  = l_short_qty    #FUN-940008 add  
      LET g_arr1[g_cnt].a51 = l_sfa.sfa063   #FUN-650096 add
      LET g_arr1[g_cnt].a52 = l_sfa.sfa062   #FUN-8A0134 add
      LET g_arr1[g_cnt].a6  = l_sfa.sfa05 - l_sfa.sfa06 - l_short_qty  #FUN-940008 add
#     LET g_arr1[g_cnt].a7  = l_ima262
#     LET g_arr1[g_cnt].a8  = l_ima262 - ((l_sfa.sfa05-l_sfa.sfa06)*l_factor)   #No:MOD-990001 modify
      LET g_arr1[g_cnt].a7  = l_avl_stk                                         #NO.FUN-A20044 
      LET g_arr1[g_cnt].a8  = l_avl_stk - ((l_sfa.sfa05-l_sfa.sfa06)*l_factor)  #NO.FUN-A20044 
      LET g_arr1[g_cnt].a9  = l_ima02                                 
      LET g_arr1[g_cnt].a10 = l_ima021
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION q301_2()
   DEFINE   l_ecm        RECORD LIKE ecm_file.*
   DEFINE   l_sfp        RECORD LIKE sfp_file.*
   DEFINE   l_sfq        RECORD LIKE sfq_file.*
   DEFINE   l_sfu        RECORD LIKE sfu_file.*
   DEFINE   l_sfv        RECORD LIKE sfv_file.*
   DEFINE   l_minopseq   LIKE type_file.num5           #No.FUN-680121 SMALLINT
   DEFINE   l_ima571     LIKE ima_file.ima571
   DEFINE   l_ecb17      LIKE ecb_file.ecb17           #No.FUN-680121 VARCHAR(10)
   DEFINE   l_add        LIKE type_file.num5   #MOD-BB0290 add
 
 
   SELECT ima571 INTO l_ima571 FROM ima_file WHERE ima01 = g_sfb.sfb05
   IF l_ima571 IS NULL THEN LET l_ima571=' ' END IF
 
   DECLARE q301_2_c CURSOR FOR                                                                                                      
      SELECT ecm_file.* FROM ecm_file                                                                                               
       WHERE ecm01 = g_sfb.sfb01                                                                                                    
       ORDER BY ecm03                                                                                                               
 
   CALL g_arr2.clear()
 
   LET g_rec_b = 0
   LET g_cnt=1
   FOREACH q301_2_c INTO l_ecm.*   #No.MOD-950148  
      LET l_add = FALSE   #MOD-BB0290 add
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)   
         EXIT FOREACH
      END IF
      LET l_ecm.ecm301 = l_ecm.ecm301 + l_ecm.ecm302 + l_ecm.ecm303
      LET g_arr2[g_cnt].b1 = l_ecm.ecm03 USING '#&'
      LET g_arr2[g_cnt].b2 = l_ecm.ecm301 USING '-------&'
      LET g_arr2[g_cnt].b3 = l_ecm.ecm45   #No.MOD-950148 
      IF NOT cl_null(l_ecm.ecm04) THEN
         DECLARE q301_2_c2 CURSOR FOR
            SELECT * FROM sfq_file, sfp_file
             WHERE sfq02 = g_sfb.sfb01 AND sfq04 = l_ecm.ecm04
               AND sfq01 = sfp01 AND sfp04='Y'
             ORDER BY sfq01
         FOREACH q301_2_c2 INTO l_sfq.*, l_sfp.*
            LET g_arr2[g_cnt].b4   =l_sfq.sfq01
            CASE l_sfp.sfp06
                 WHEN '1'      LET g_arr2[g_cnt].b5 = cl_getmsg('asf-231',g_lang)
                 WHEN '2'      LET g_arr2[g_cnt].b5 = cl_getmsg('asf-232',g_lang)
                 WHEN '3'      LET g_arr2[g_cnt].b5 = cl_getmsg('asf-233',g_lang)
                 WHEN '4'      LET g_arr2[g_cnt].b5 = cl_getmsg('asf-234',g_lang)
                 WHEN 'A'      LET g_arr2[g_cnt].b5 = cl_getmsg('asf-235',g_lang)
                 WHEN 'C'      LET g_arr2[g_cnt].b5 = cl_getmsg('asf-236',g_lang)
                 WHEN 'D'      LET g_arr2[g_cnt].b5 = cl_getmsg('asf-231',g_lang)               #FUN-C70014
               OTHERWISE       
            END CASE
            LET g_arr2[g_cnt].b6   =l_sfp.sfp03
            LET g_arr2[g_cnt].b7   =l_sfq.sfq03 USING '--------'
            LET g_cnt=g_cnt+1
            LET l_add = TRUE   #MOD-BB0290 add
         END FOREACH
      END IF
 
      DECLARE q301_2_c3 CURSOR FOR
         SELECT * FROM sfv_file, sfu_file
          WHERE sfv11 = g_sfb.sfb01 AND (sfv14 = l_ecm.ecm03 OR sfv15 = l_ecm.ecm03)
            AND sfv01 = sfu01 AND sfupost = 'Y'
          ORDER BY sfu02,sfu00,sfu01
      FOREACH q301_2_c3 INTO l_sfv.*, l_sfu.*
         LET l_sfv.sfv09 = l_sfv.sfv09 * -1		#先視為轉出
         IF l_sfu.sfu00 = '0' AND l_sfv.sfv15 = l_ecm.ecm03 THEN
            LET g_i=l_sfv.sfv14
            LET l_sfv.sfv14 = l_sfv.sfv15
            LET l_sfv.sfv15 = g_i
            LET l_sfv.sfv09 = l_sfv.sfv09*-1	#改為轉入
         END IF
         IF l_sfu.sfu00='2' THEN LET l_sfv.sfv09=l_sfv.sfv09*-1 END IF
         LET g_arr2[g_cnt].b4   =l_sfv.sfv01
         LET g_arr2[g_cnt].b5   = cl_getmsg('asf-851',g_lang)
         LET g_arr2[g_cnt].b6   =l_sfu.sfu00
         LET g_arr2[g_cnt].b7   =l_sfu.sfu02
         LET g_arr2[g_cnt].b8   =l_sfv.sfv09
         LET g_arr2[g_cnt].b9   =l_sfv.sfv12
         LET g_cnt=g_cnt+1
         LET l_add = TRUE   #MOD-BB0290 add
      END FOREACH
      IF NOT l_add THEN   #MOD-BB0290 add
         LET g_cnt=g_cnt+1
      END IF              #MOD-BB0290 add
   END FOREACH
   DISPLAY g_rec_b TO cn2
END FUNCTION
 
FUNCTION q301_3()
   DEFINE   l_pmm   RECORD LIKE pmm_file.*
   DEFINE   l_pmn   RECORD LIKE pmn_file.*
 
   DECLARE q301_3_c CURSOR FOR
      SELECT * FROM pmn_file, OUTER pmm_file
       WHERE pmn41 = g_sfb.sfb01 AND pmn_file.pmn01 = pmm_file.pmm01 AND pmm18 <> 'X'
         AND pmm02 = 'SUB'  #MOD-920123 add
 
   CALL g_arr3.clear()
 
   LET g_rec_b = 0
   LET g_cnt=1
   FOREACH q301_3_c INTO l_pmn.*, l_pmm.*
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)  
         EXIT FOREACH
      END IF
      SELECT pmc03 INTO l_pmm.pmm09 FROM pmc_file WHERE pmc01 = l_pmm.pmm09
#TQC-CC0007  -----------Begin--------------
      SELECT ima02,ima021 INTO g_arr3[g_cnt].c12,g_arr3[g_cnt].c13 FROM ima_file
       WHERE ima01 = l_pmn.pmn04
#TQC-CC0007  -----------End----------------
      LET g_arr3[g_cnt].c1   = l_pmm.pmm01
      LET g_arr3[g_cnt].c2   = l_pmm.pmm09
      LET g_arr3[g_cnt].c3   = l_pmn.pmn02 USING '#&'
      LET g_arr3[g_cnt].c4   = l_pmn.pmn04
      LET g_arr3[g_cnt].c5   = l_pmn.pmn33
      #LET g_arr3[g_cnt].c6   = l_pmn.pmn20 USING '-------&' #MOD-D10176
      LET g_arr3[g_cnt].c6   = l_pmn.pmn20 USING '-------&.&&&'  #MOD-D10176
      LET g_arr3[g_cnt].c8   = l_pmn.pmn83
      #LET g_arr3[g_cnt].c9   = l_pmn.pmn85 USING '-------&' #MOD-D10176
      LET g_arr3[g_cnt].c9   = l_pmn.pmn85 USING '-------&.&&&'  #MOD-D10176
      LET g_arr3[g_cnt].c10  = l_pmn.pmn80
      #LET g_arr3[g_cnt].c11  = l_pmn.pmn82 USING '-------&' #MOD-D10176
      #LET g_arr3[g_cnt].c7   = l_pmn.pmn50 USING '-------&' #MOD-D10176
      LET g_arr3[g_cnt].c11  = l_pmn.pmn82 USING '-------&.&&&'  #MOD-D10176
      LET g_arr3[g_cnt].c7   = l_pmn.pmn50 USING '-------&.&&&'  #MOD-D10176
      LET g_cnt=g_cnt+1
   END FOREACH
   DISPLAY g_rec_b TO cn2
END FUNCTION
 
FUNCTION q301_4()
   DEFINE  l_tlf      RECORD LIKE tlf_file.*
   DEFINE  l_tlff     RECORD LIKE tlff_file.*  #FUN-570175
   DEFINE  l_tlff218t LIKE tlff_file.tlff218   #FUN-570175
   DEFINE  l_ware     LIKE type_file.chr20     #No.FUN-680121 VARCHAR(20)
   DEFINE  l_sfe30    LIKE sfe_file.sfe30      #MOD-5A0048
   DEFINE  l_sfe32    LIKE sfe_file.sfe32      #MOD-5A0048
   DEFINE  l_sfe33    LIKE sfe_file.sfe33      #MOD-5A0048
   DEFINE  l_sfe35    LIKE sfe_file.sfe35      #MOD-5A0048
   DEFINE  l_ima02    LIKE ima_file.ima02      #CHI-A50043 add
   DEFINE  l_ima021   LIKE ima_file.ima021     #CHI-A50043 add
 
   #CHI-A50043 mark --start--
   #DECLARE q301_4_c CURSOR FOR
   #SELECT * FROM tlf_file
   # WHERE tlf62 = g_sfb.sfb01 AND tlf13 MATCHES 'asfi5*' AND tlf907 <> 0
   # ORDER BY tlf06,tlf905
   #CHI-A50043 mark --end--
   #CHI-A50043 add --start--
   DECLARE q301_4_c CURSOR FOR
   SELECT tlf_file.*, ima02,ima021 FROM tlf_file, ima_file
    WHERE tlf01 = ima01                 
      AND tlf62 = g_sfb.sfb01 AND tlf13 MATCHES 'asfi5*' AND tlf907 <> 0
    ORDER BY tlf06,tlf905
   #CHI-A50043 add --end--
 
   CALL g_arr4.clear()
 
   LET g_rec_b = 0
   LET g_cnt=1
   FOREACH q301_4_c INTO l_tlf.*,l_ima02,l_ima021  #CHI-A50043 add l_ima02,l_ima021
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)   
         EXIT FOREACH
      END IF
      LET l_ware=l_tlf.tlf902 CLIPPED,'/',l_tlf.tlf903 CLIPPED,'/',l_tlf.tlf904
#TQC-CC0007 ------------Begin--------------
      SELECT imd02 INTO g_arr4[g_cnt].d19 FROM imd_file
       WHERE imd01 = l_tlf.tlf902
      SELECT ime03 INTO g_arr4[g_cnt].d20 FROM ime_file
       WHERE ime01 = l_tlf.tlf902
         AND ime02 = l_tlf.tlf903
#TQC-CC0007 ------------End----------------
      LET l_tlf.tlf10 = l_tlf.tlf10 * l_tlf.tlf907 * -1
      LET g_arr4[g_cnt].d1   = l_tlf.tlf06
      let g_arr4[g_cnt].d21  = l_tlf.tlf08 #darcy:2024/12/18 add
      LET g_arr4[g_cnt].d2   = l_tlf.tlf905
      LET g_arr4[g_cnt].d3   = l_tlf.tlf906
      LET g_arr4[g_cnt].d4   = l_tlf.tlf01
      LET g_arr4[g_cnt].d15  = l_ima02       #CHI-A50043 add
      LET g_arr4[g_cnt].d16  = l_ima021      #CHI-A50043 add
      LET g_arr4[g_cnt].d5   = l_tlf.tlf05
      LET g_arr4[g_cnt].d6   = l_tlf.tlf902
      LET g_arr4[g_cnt].d7   = l_tlf.tlf903
      LET g_arr4[g_cnt].d8   = l_tlf.tlf904
      LET g_arr4[g_cnt].d9   = l_tlf.tlf10
      LET g_arr4[g_cnt].d10  = l_tlf.tlf11
     
     #No.FUN-A60027 -------------start----------------------
      SELECT sfs012,sfs013 INTO g_arr4[g_cnt].d17,g_arr4[g_cnt].d18
        FROM sfs_file 
       WHERE sfs01 = l_tlf.tlf905
         AND sfs02 = l_tlf.tlf906
     #No.FUN-A60027 ---------------end----------------------     
 
     #抓雙單位的資料
      DECLARE q301_4_du_c CURSOR FOR
       SELECT sfe30,sfe32,sfe33,sfe35 FROM sfe_file
        WHERE sfe02 = l_tlf.tlf026   #單號
          AND sfe28 = l_tlf.tlf027   #項次
          AND sfe07 = l_tlf.tlf01    #料號
      FOREACH q301_4_du_c INTO l_sfe30,l_sfe32,l_sfe33,l_sfe35
         LET g_arr4[g_cnt].d11  = l_sfe33
         LET g_arr4[g_cnt].d12  = l_sfe35
         LET g_arr4[g_cnt].d13  = l_sfe30
         LET g_arr4[g_cnt].d14  = l_sfe32
      END FOREACH
      LET g_cnt=g_cnt+1
   END FOREACH
   DISPLAY g_rec_b TO cn2
END FUNCTION
 
FUNCTION q301_5()
   DEFINE   l_qcf      RECORD LIKE qcf_file.*,
            l_retqty   LIKE qcf_file.qcf061
 
   DECLARE q301_5_c CURSOR FOR
      SELECT * FROM qcf_file WHERE qcf02=g_sfb.sfb01 AND qcf14 <> 'X'
       ORDER BY qcf00
 
   CALL g_arr5.clear()
 
   LET g_rec_b = 0
   LET g_cnt=1
   FOREACH q301_5_c INTO l_qcf.*
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)  
         EXIT FOREACH
      END IF
      LET g_arr5[g_cnt].e1   = l_qcf.qcf01
      LET g_arr5[g_cnt].e2   = l_qcf.qcf04
      LET g_arr5[g_cnt].e3   = l_qcf.qcf22
     #LET g_arr5[g_cnt].e4   = l_qcf.qcf06           #MOD-AC0393 mark
      LET g_arr5[g_cnt].e5   = l_qcf.qcf091
      LET g_cnt=g_cnt+1
   END FOREACH
   DISPLAY g_rec_b TO cn2
END FUNCTION
 
FUNCTION q301_6()
   DEFINE   l_tlf    RECORD LIKE tlf_file.*
   DEFINE   l_tlff   RECORD LIKE tlff_file.*   #FUN-570175
   DEFINE   l_tlff218t      LIKE tlff_file.tlff218  #FUN-570175
   DEFINE   l_ware    LIKE type_file.chr20     #No.FUN-680121 VARCHAR(20)
   DEFINE  l_sfv30    LIKE sfv_file.sfv30      #No.MOD-650128   add
   DEFINE  l_sfv32    LIKE sfv_file.sfv32      #No.MOD-650128   add
   DEFINE  l_sfv33    LIKE sfv_file.sfv33      #No.MOD-650128   add
   DEFINE  l_sfv35    LIKE sfv_file.sfv35      #No.MOD-650128   add
 
   DECLARE q301_6_c CURSOR FOR
   SELECT * FROM tlf_file
    WHERE tlf62 = g_sfb.sfb01 AND tlf13 MATCHES 'asft6*' AND tlf907 <> 0
    ORDER BY tlf06,tlf905
 
   CALL g_arr6.clear()
 
   LET g_rec_b = 0
   LET g_cnt=1
   FOREACH q301_6_c INTO l_tlf.*
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)   
         EXIT FOREACH
      END IF
#TQC-CC0014 -----------Begin-----------
      SELECT ima02,ima021 INTO g_arr6[g_cnt].f15,g_arr6[g_cnt].f16 FROM ima_file
       WHERE ima01 = l_tlf.tlf01

      SELECT imd02 INTO g_arr6[g_cnt].f17 FROM imd_file
       WHERE imd01 = l_tlf.tlf902
      SELECT ime03 INTO g_arr6[g_cnt].f18 FROM ime_file
       WHERE ime01 = l_tlf.tlf902
         AND ime02 = l_tlf.tlf903

#TQC-CC0014 -----------End-------------
      LET l_ware=l_tlf.tlf902 CLIPPED,'/',l_tlf.tlf903 CLIPPED,'/',l_tlf.tlf904
      LET l_tlf.tlf10 = l_tlf.tlf10 * l_tlf.tlf907 
      LET g_arr6[g_cnt].f1   = l_tlf.tlf06
      LET g_arr6[g_cnt].f19  = l_tlf.tlf08  #darcy:2024/12/18 add
      LET g_arr6[g_cnt].f2   = l_tlf.tlf905
      LET g_arr6[g_cnt].f3   = l_tlf.tlf906
      LET g_arr6[g_cnt].f4   = l_tlf.tlf01
      LET g_arr6[g_cnt].f5   = l_tlf.tlf05
      LET g_arr6[g_cnt].f5   = l_tlf.tlf902
      LET g_arr6[g_cnt].f6   = l_tlf.tlf903
      LET g_arr6[g_cnt].f7   = l_tlf.tlf904
      LET g_arr6[g_cnt].f8   = l_tlf.tlf10
      LET g_arr6[g_cnt].f9   = l_tlf.tlf11
      LET g_arr6[g_cnt].f10  = l_tlf.tlf05
 
     #抓雙單位的資料
      DECLARE q301_6_du_c CURSOR FOR
       SELECT sfv30,sfv32,sfv33,sfv35 FROM sfv_file
        WHERE sfv01 = l_tlf.tlf905   #單號
          AND sfv03 = l_tlf.tlf906   #項次
          AND sfv04 = l_tlf.tlf01    #料號
      FOREACH q301_6_du_c INTO l_sfv30,l_sfv32,l_sfv33,l_sfv35
         LET g_arr6[g_cnt].f11  = l_sfv33
         LET g_arr6[g_cnt].f12  = l_sfv35
         LET g_arr6[g_cnt].f13  = l_sfv30
         LET g_arr6[g_cnt].f14  = l_sfv32
      END FOREACH
      LET g_cnt=g_cnt+1
   END FOREACH
   DISPLAY g_rec_b TO cn2
END FUNCTION
 
FUNCTION q301_7()
   DEFINE   l_sfb   RECORD LIKE sfb_file.*
 
   DECLARE q301_7_c CURSOR FOR
    SELECT * FROM sfb_file WHERE sfb86=g_sfb.sfb01 ORDER BY sfb01
 
   CALL g_arr7.clear()
 
   LET g_rec_b = 0
   LET g_cnt=1
   FOREACH q301_7_c INTO l_sfb.*
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)   
         EXIT FOREACH
      END IF
#TQC-CC0014 ------------Begin-------------
      SELECT ima02,ima021 INTO g_arr7[g_cnt].g8,g_arr7[g_cnt].g9 FROM ima_file
       WHERE ima01 = l_sfb.sfb05
      SELECT gem02 INTO g_arr7[g_cnt].g10 FROM gem_file
       WHERE gem01 = l_sfb.sfb82
#TQC-CC0014 ------------End---------------
      LET g_arr7[g_cnt].g1   = l_sfb.sfb01
      LET g_arr7[g_cnt].g2   = l_sfb.sfb05
      LET g_arr7[g_cnt].g3   = l_sfb.sfb82
      LET g_arr7[g_cnt].g4   = l_sfb.sfb13
      LET g_arr7[g_cnt].g5   = l_sfb.sfb08
      LET g_arr7[g_cnt].g6   = l_sfb.sfb081
      LET g_arr7[g_cnt].g7   = l_sfb.sfb09
      LET g_cnt=g_cnt+1
   END FOREACH
   DISPLAY g_rec_b TO cn2
END FUNCTION
 
FUNCTION q301_8()
   DEFINE   l_sfa            RECORD LIKE sfa_file.*
#  DEFINE   l_qty,l_ima262   LIKE ima_file.ima262  #No.FUN-680121 DEC(15,3)
   DEFINE   l_qty,l_avl_stk  LIKE type_file.num15_3    ###GP5.2  #NO.FUN-A20044
   DEFINE   l_bmd04          LIKE bmd_file.bmd04   #No.MOD-490217
   DEFINE   l_n1        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_n2        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_n3        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044 
 
   DECLARE q301_8_c CURSOR FOR
#   SELECT sfa_file.*,ima262 FROM sfa_file, ima_file #NO.FUN-A20044
    SELECT sfa_file.*,0 FROM sfa_file, ima_file      #NO.FUN-A20044
     WHERE sfa01 = g_sfb.sfb01 AND sfa26 IN ('1','2','3','4','5','6','7','8')  #FUN-A20037 add '7,8'
       AND sfa27 = ima01
     ORDER BY sfa27
 
   CALL g_arr8.clear()
 
   LET g_rec_b = 0
   LET g_cnt=1
#  FOREACH q301_8_c INTO l_sfa.*, l_ima262      #NO.FUN-A20044
   FOREACH q301_8_c INTO l_sfa.*, l_avl_stk     #NO.FUN-A20044
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)   
         EXIT FOREACH
      END IF
      CALL s_getstock(l_sfa.sfa27,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
      LET l_avl_stk = l_n3                                            #NO.FUN-A20044  
      LET l_qty=0
      SELECT SUM(sfa05-sfa06) INTO l_qty FROM sfa_file
       WHERE sfa01=g_sfb.sfb01 AND sfa27 = l_sfa.sfa27
#TQC-CC0014 ------------Begin-------------
      SELECT ima02,ima021 INTO g_arr8[g_cnt].h7,g_arr8[g_cnt].h8 FROM ima_file
       WHERE ima01 = l_sfa.sfa27
#TQC-CC0014 ------------End---------------
      LET g_arr8[g_cnt].h1   = l_sfa.sfa27
      LET g_arr8[g_cnt].h2   = l_sfa.sfa26
      LET g_arr8[g_cnt].h3   = l_qty
#     LET g_arr8[g_cnt].h4   = l_ima262    #NO.FUN-A20044
      LET g_arr8[g_cnt].h4   = l_avl_stk   #NO.FUN-A20044
      DECLARE q301_8_c2 CURSOR FOR
#        SELECT bmd04, ima262 FROM bmd_file, ima_file  #NO.FUN-A20044
         SELECT bmd04, 0 FROM bmd_file, ima_file       #NO.FUN-A20044
          WHERE bmd01 = l_sfa.sfa27 AND (bmd08 = 'ALL' OR bmd08 = g_sfb.sfb05)
            AND bmd04 = ima01
            AND bmdacti = 'Y'                                           #CHI-910021
#     FOREACH q301_8_c2 INTO l_bmd04, l_ima262                        #NO.FUN-A20044
      FOREACH q301_8_c2 INTO l_bmd04, l_avl_stk                       #NO.FUN-A20044
     #CALL s_getstock(l_sfa.sfa27,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044  #MOD-C70186 mark
      CALL s_getstock(l_bmd04,g_plant) RETURNING  l_n1,l_n2,l_n3      #MOD-C70186 add
      LET l_avl_stk = l_n3                                            #NO.FUN-A20044  
         LET g_arr8[g_cnt].h5 = l_bmd04
#        LET g_arr8[g_cnt].h6 = l_ima262                              #NO.FUN-A20044   
         LET g_arr8[g_cnt].h6 = l_avl_stk                             #NO.FUN-A20044
#TQC-CC0014 ------------Begin-------------
      SELECT ima02,ima021 INTO g_arr8[g_cnt].h9,g_arr8[g_cnt].h10 FROM ima_file
       WHERE ima01 = l_bmd04
#TQC-CC0014 ------------End---------------
         LET g_cnt=g_cnt+1
      END FOREACH
#     LET g_cnt=g_cnt+1    #TQC-C70156
   END FOREACH
   DISPLAY g_rec_b TO cn2
END FUNCTION
 
FUNCTION q301_9()
   DEFINE   l_sfa     RECORD LIKE sfa_file.*
   DEFINE   l_bml04   LIKE type_file.chr20         #No.FUN-680121 VARCHAR(20)
 
   DECLARE q301_9_c CURSOR FOR
      SELECT sfa_file.* FROM sfa_file
       WHERE sfa01=g_sfb.sfb01
         AND sfa03 IN (SELECT bml01 FROM bml_file WHERE bml01=sfa03)
       ORDER BY sfa03
 
   CALL g_arr9.clear()
 
   LET g_rec_b = 0
   LET g_cnt=1
   FOREACH q301_9_c INTO l_sfa.*
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)  
         EXIT FOREACH
      END IF
      DECLARE q301_9_c2 CURSOR FOR
         SELECT bml04 FROM bml_file
          WHERE bml01=l_sfa.sfa03 AND (bml02='ALL' OR bml02=g_sfb.sfb05)
      LET g_msg=NULL
      FOREACH q301_9_c2 INTO l_bml04
         LET g_msg=g_msg CLIPPED,l_bml04 CLIPPED,','
      END FOREACH
      IF g_msg IS NULL THEN CONTINUE FOREACH END IF
      LET g_arr9[g_cnt].i1   = l_sfa.sfa03
      LET g_arr9[g_cnt].i2   = l_sfa.sfa05-l_sfa.sfa06
      LET g_arr9[g_cnt].i3   = g_msg CLIPPED
      LET g_cnt=g_cnt+1
   END FOREACH
   DISPLAY g_rec_b TO cn2
END FUNCTION
 
FUNCTION q301_10()
   DEFINE   l_shm     RECORD LIKE shm_file.*
   DEFINE   l_bml04   LIKE type_file.chr20         #No.FUN-680121 VARCHAR(20)
 
 
   DECLARE q301_a_c CURSOR FOR
      SELECT shm_file.* FROM shm_file
       WHERE shm012=g_sfb.sfb01
       ORDER BY shm01
 
   CALL g_arr10.clear()
 
   LET g_rec_b = 0
   LET g_cnt=1
   FOREACH q301_a_c INTO l_shm.*
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)   
         EXIT FOREACH
      END IF
      LET g_arr10[g_cnt].j1   = l_shm.shm01
      LET g_arr10[g_cnt].j2   = l_shm.shm08
      LET g_arr10[g_cnt].j3   = l_shm.shm13
      LET g_arr10[g_cnt].j4   = l_shm.shm15
      LET g_arr10[g_cnt].j5   = l_shm.shm09
      LET g_cnt=g_cnt+1
   END FOREACH
   DISPLAY g_rec_b TO cn2
END FUNCTION
 
FUNCTION q301_11()
   DEFINE   l_srg     RECORD LIKE srg_file.*
   DEFINE   l_srf01   LIKE srf_file.srf01
   DEFINE   l_srf02   LIKE srf_file.srf02
 
   DECLARE q301_b_c CURSOR FOR
      SELECT srg_file.* FROM srg_file,srf_file   #No.MOD-930034
       WHERE srg16 = g_sfb.sfb01
         AND srg01 = srf01                       #No.MOD-930034 add
         AND srfconf <> 'X'                      #No.MOD-930034
       ORDER BY srg16
 
   CALL g_arr11.clear()
 
   LET g_rec_b = 0
   LET g_cnt=1
   FOREACH q301_b_c INTO l_srg.*
      SELECT srf01,srf02 INTO l_srf01,l_srf02 FROM srf_file
       WHERE srf01 = l_srg.srg01
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)   
         EXIT FOREACH
      END IF
      LET g_arr11[g_cnt].k1   = l_srf01
      LET g_arr11[g_cnt].k2   = l_srf02
      LET g_arr11[g_cnt].k3   = l_srg.srg02
      LET g_arr11[g_cnt].k4   = l_srg.srg04
      LET g_arr11[g_cnt].k5   = l_srg.srg15
      LET g_arr11[g_cnt].k6   = l_srg.srg05
      LET g_arr11[g_cnt].k7   = l_srg.srg06
      LET g_arr11[g_cnt].k8   = l_srg.srg07
      LET g_arr11[g_cnt].k9   = l_srg.srg08
      LET g_arr11[g_cnt].k10  = l_srg.srg09
      LET g_arr11[g_cnt].k11  = l_srg.srg10
      LET g_arr11[g_cnt].k12  = l_srg.srg11
      LET g_arr11[g_cnt].k13  = l_srg.srg12
      LET g_cnt=g_cnt+1
   END FOREACH
   DISPLAY g_rec_b TO cn2
END FUNCTION

FUNCTION q301_13()
   DEFINE   l_shb     RECORD LIKE shb_file.*

   DECLARE q301_b_c13 CURSOR FOR
      SELECT shb_file.* FROM shb_file
       WHERE shb05 = g_sfb.sfb01
         AND shbconf = 'Y'     #FUN-A70095
       ORDER BY shb01

   CALL g_arr13.clear()

   LET g_rec_b = 0
   LET g_cnt=1
   FOREACH q301_b_c13 INTO l_shb.*
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)   
         EXIT FOREACH
      END IF
      LET g_arr13[g_cnt].m1   = l_shb.shb01
      LET g_arr13[g_cnt].m2   = l_shb.shb02
      LET g_arr13[g_cnt].m021 = l_shb.shb021
      LET g_arr13[g_cnt].m3   = l_shb.shb03
      LET g_arr13[g_cnt].m031 = l_shb.shb031
      LET g_arr13[g_cnt].m032 = l_shb.shb032
      LET g_arr13[g_cnt].m033 = l_shb.shb033
      LET g_arr13[g_cnt].m4   = l_shb.shb04
      LET g_arr13[g_cnt].m5   = l_shb.shb05
      LET g_arr13[g_cnt].m6   = l_shb.shb06
      LET g_arr13[g_cnt].m7   = l_shb.shb07
      LET g_arr13[g_cnt].m8   = l_shb.shb08
      LET g_arr13[g_cnt].m081 = l_shb.shb081
      LET g_arr13[g_cnt].m9   = l_shb.shb09
      LET g_arr13[g_cnt].m10  = l_shb.shb10
      LET g_arr13[g_cnt].m111 = l_shb.shb111
      LET g_arr13[g_cnt].m112 = l_shb.shb112
      LET g_arr13[g_cnt].m113 = l_shb.shb113
      LET g_arr13[g_cnt].m114 = l_shb.shb114
      LET g_arr13[g_cnt].m115 = l_shb.shb115
      LET g_arr13[g_cnt].m12  = l_shb.shb12
      LET g_arr13[g_cnt].m13  = l_shb.shb13
      LET g_arr13[g_cnt].m14  = l_shb.shb14
      LET g_arr13[g_cnt].m15  = l_shb.shb15
      LET g_arr13[g_cnt].m16  = l_shb.shb16
      LET g_arr13[g_cnt].m17  = l_shb.shb17
      LET g_arr13[g_cnt].m18  = l_shb.shb012    #FUN-A60027
#---TQC-CC0015---add--star---
      SELECT gen02 INTO g_arr13[g_cnt].m041 FROM gen_file
       WHERE gen01 = g_arr13[g_cnt].m4
#---TQC-CC0015---add--end---
      LET g_cnt=g_cnt+1
   END FOREACH
   DISPLAY g_rec_b TO cn2
END FUNCTION
#CHI-D20030---begin
FUNCTION q301_14()
   DEFINE   l_shd     RECORD LIKE shd_file.*
   DEFINE   l_shb03   LIKE shb_file.shb03
   DEFINE   l_azf03   LIKE azf_file.azf03

   DECLARE q301_b_c14 CURSOR FOR
      SELECT shd_file.*,shb03 FROM shb_file,shd_file
       WHERE shb05 = g_sfb.sfb01
         AND shb01 = shd01
         AND shbconf = 'Y'     
       ORDER BY shb01

   CALL g_arr14.clear()

   LET g_rec_b = 0
   LET g_cnt=1
   FOREACH q301_b_c14 INTO l_shd.*,l_shb03
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)   
         EXIT FOREACH
      END IF
      LET g_arr14[g_cnt].n01   = l_shd.shd01
      LET g_arr14[g_cnt].n02   = l_shd.shd02
      LET g_arr14[g_cnt].n03   = l_shd.shd03
      LET g_arr14[g_cnt].n031   = l_shb03
      LET g_arr14[g_cnt].n04   = l_shd.shd04
      LET g_arr14[g_cnt].n05   = l_shd.shd05
      LET g_arr14[g_cnt].n06   = l_shd.shd06
      LET g_arr14[g_cnt].n07   = l_shd.shd07
      LET g_arr14[g_cnt].n16   = l_shd.shd16
      LET g_arr14[g_cnt].n18   = l_shd.shd18

      SELECT azf03 INTO g_arr14[g_cnt].n181 
        FROM azf_file 
       WHERE azf01=g_arr14[g_cnt].n18 AND azf02='2'

      LET g_cnt=g_cnt+1
   END FOREACH
   DISPLAY g_rec_b TO cn2
END FUNCTION
#CHI-D20030---end
FUNCTION q301_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)  #MOD-4A013
   DISPLAY ARRAY g_arr1 TO s_arr1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION first
         CALL q301_fetch('F')
         EXIT DISPLAY
         CALL q301_bp1_refresh()
 
      ON ACTION previous
         CALL q301_fetch('P')
         EXIT DISPLAY
         CALL q301_bp1_refresh()
 
      ON ACTION jump
         CALL q301_fetch('/')
         EXIT DISPLAY
         CALL q301_bp1_refresh()
 
      ON ACTION next
         CALL q301_fetch('N')
         EXIT DISPLAY
         CALL q301_bp1_refresh()
 
      ON ACTION last
         CALL q301_fetch('L')
         EXIT DISPLAY
         CALL q301_bp1_refresh()
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CALL q301_def_form()   #FUN-610006
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
         IF NOT cl_null(g_sfb.sfb28) THEN
            LET g_close = 'Y'
         ELSE
            LET g_close = 'N'
         END IF
         #圖形顯示
         CALL cl_set_field_pic(g_confirm,"","",g_close,g_void,g_sfb.sfbacti)
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #@ON ACTION 查詢
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      #@ON ACTION 備料
      ON ACTION allotment
         LET g_action_choice="allotment"
         EXIT DISPLAY
 
      #@ON ACTION 製程
      ON ACTION routing
         LET g_action_choice="routing"
         EXIT DISPLAY
 
      #@ON ACTION 委外採購
      ON ACTION sub_po
         LET g_action_choice="sub_po"
         EXIT DISPLAY
 
      #@ON ACTION 發料
      ON ACTION issue
         LET g_action_choice="issue"
         EXIT DISPLAY
 
      ON ACTION fqc
         LET g_action_choice="fqc"
         EXIT DISPLAY
 
      #@ON ACTION 入庫
      ON ACTION store_in
         LET g_action_choice="store_in"
         EXIT DISPLAY
 
      #@ON ACTION 子工單
      ON ACTION sub_wo
         LET g_action_choice="sub_wo"
         EXIT DISPLAY
 
      #@ON ACTION 替代
      ON ACTION substitute
         LET g_action_choice="substitute"
         EXIT DISPLAY
 
      ON ACTION qvl
         LET g_action_choice="qvl"
         EXIT DISPLAY
 
      ON ACTION runcard
         LET g_action_choice="runcard"
         EXIT DISPLAY
         
      ON ACTION report_no
         LET g_action_choice="report_no"
         EXIT DISPLAY

      ON ACTION Routing_Reportable
         LET g_action_choice="Routing_Reportable"
         EXIT DISPLAY
      #CHI-D20030---begin
      ON ACTION off_line
         LET g_action_choice="off_line"
         EXIT DISPLAY
      #CHI-D20030---end
      #@ON ACTION 庫存資料
      ON ACTION inventory
         LET g_action_choice="inventory"
         EXIT DISPLAY
 
      #@ON ACTION 材料供需
      ON ACTION meterial_supply
         LET g_action_choice="meterial_supply"
         EXIT DISPLAY
 
      #@ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
 
      #@ON ACTION 工單維護
      ON ACTION maint_w_o
         LET g_action_choice="maint_w_o"
         EXIT DISPLAY
 
      #@ON ACTION 工廠切換
    # ON ACTION switch_plant                     #FUN-B10030
    #    LET g_action_choice="switch_plant"      #FUN-B10030
    #    EXIT DISPLAY                            #FUN-B10030
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("group01","AUTO")                                                                                      
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q301_bp1_refresh()
   DISPLAY ARRAY g_arr1 TO s_arr1.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
 
FUNCTION q301_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)  #MOD-4A013
   DISPLAY ARRAY g_arr2 TO s_arr2.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION first
         CALL q301_fetch('F')
         EXIT DISPLAY
         CALL q301_bp2_refresh()
 
      ON ACTION previous
         CALL q301_fetch('P')
         EXIT DISPLAY
         CALL q301_bp2_refresh()
 
      ON ACTION jump
         CALL q301_fetch('/')
         EXIT DISPLAY
         CALL q301_bp2_refresh()
 
      ON ACTION next
         CALL q301_fetch('N')
         EXIT DISPLAY
         CALL q301_bp2_refresh()
 
      ON ACTION last
         CALL q301_fetch('L')
         EXIT DISPLAY
         CALL q301_bp2_refresh()
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CALL q301_def_form()   #FUN-610006
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
         IF NOT cl_null(g_sfb.sfb28) THEN
            LET g_close = 'Y'
         ELSE
            LET g_close = 'N'
         END IF
         #圖形顯示
         CALL cl_set_field_pic(g_confirm,"","",g_close,g_void,g_sfb.sfbacti)
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #@ON ACTION 查詢
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      #@ON ACTION 備料
      ON ACTION allotment
         LET g_action_choice="allotment"
         EXIT DISPLAY
 
      #@ON ACTION 製程
      ON ACTION routing
         LET g_action_choice="routing"
         EXIT DISPLAY
 
      #@ON ACTION 委外採購
      ON ACTION sub_po
         LET g_action_choice="sub_po"
         EXIT DISPLAY
 
      #@ON ACTION 發料
      ON ACTION issue
         LET g_action_choice="issue"
         EXIT DISPLAY
 
      ON ACTION fqc
         LET g_action_choice="fqc"
         EXIT DISPLAY
 
      #@ON ACTION 入庫
      ON ACTION store_in
         LET g_action_choice="store_in"
         EXIT DISPLAY
 
      #@ON ACTION 子工單
      ON ACTION sub_wo
         LET g_action_choice="sub_wo"
         EXIT DISPLAY
 
      #@ON ACTION 替代
      ON ACTION substitute
         LET g_action_choice="substitute"
         EXIT DISPLAY
 
      ON ACTION qvl
         LET g_action_choice="qvl"
         EXIT DISPLAY
 
      ON ACTION runcard
         LET g_action_choice="runcard"
         EXIT DISPLAY
 
      ON ACTION report_no
         LET g_action_choice="report_no"
         EXIT DISPLAY
       
      ON ACTION Routing_Reportable
         LET g_action_choice="Routing_Reportable"
         EXIT DISPLAY
      #CHI-D20030---begin
      ON ACTION off_line
         LET g_action_choice="off_line"
         EXIT DISPLAY
      #CHI-D20030---end
      #@ON ACTION 庫存資料
      ON ACTION inventory
         LET g_action_choice="inventory"
         EXIT DISPLAY
 
      #@ON ACTION 材料供需
      ON ACTION meterial_supply
         LET g_action_choice="meterial_supply"
         EXIT DISPLAY
 
      #@ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
 
      #@ON ACTION 工單維護
      ON ACTION maint_w_o
         LET g_action_choice="maint_w_o"
         EXIT DISPLAY
 
      #@ON ACTION 工廠切換
    # ON ACTION switch_plant                    #FUN-B10030
    #    LET g_action_choice="switch_plant"     #FUN-B10030
    #    EXIT DISPLAY                           #FUN-B10030
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("group01","AUTO")                                                                                      
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q301_bp2_refresh()
   DISPLAY ARRAY g_arr2 TO s_arr2.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
 
FUNCTION q301_bp3(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)  #MOD-4A0139
   DISPLAY ARRAY g_arr3 TO s_arr3.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION first
         CALL q301_fetch('F')
         EXIT DISPLAY
         CALL q301_bp3_refresh()
 
      ON ACTION previous
         CALL q301_fetch('P')
         EXIT DISPLAY
         CALL q301_bp3_refresh()
 
      ON ACTION jump
         CALL q301_fetch('/')
         EXIT DISPLAY
         CALL q301_bp3_refresh()
 
      ON ACTION next
         CALL q301_fetch('N')
         EXIT DISPLAY
         CALL q301_bp3_refresh()
 
      ON ACTION last
         CALL q301_fetch('L')
         EXIT DISPLAY
         CALL q301_bp3_refresh()
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CALL q301_def_form()   #FUN-610006
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
         IF NOT cl_null(g_sfb.sfb28) THEN
            LET g_close = 'Y'
         ELSE
            LET g_close = 'N'
         END IF
         #圖形顯示
         CALL cl_set_field_pic(g_confirm,"","",g_close,g_void,g_sfb.sfbacti)
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
 
 #MOD-4B0238 add
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #@ON ACTION 查詢
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      #@ON ACTION 備料
      ON ACTION allotment
         LET g_action_choice="allotment"
         EXIT DISPLAY
 
      #@ON ACTION 製程
      ON ACTION routing
         LET g_action_choice="routing"
         EXIT DISPLAY
 
      #@ON ACTION 委外採購
      ON ACTION sub_po
         LET g_action_choice="sub_po"
         EXIT DISPLAY
 
      #@ON ACTION 發料
      ON ACTION issue
         LET g_action_choice="issue"
         EXIT DISPLAY
 
      ON ACTION fqc
         LET g_action_choice="fqc"
         EXIT DISPLAY
 
      #@ON ACTION 入庫
      ON ACTION store_in
         LET g_action_choice="store_in"
         EXIT DISPLAY
 
      #@ON ACTION 子工單
      ON ACTION sub_wo
         LET g_action_choice="sub_wo"
         EXIT DISPLAY
 
      #@ON ACTION 替代
      ON ACTION substitute
         LET g_action_choice="substitute"
         EXIT DISPLAY
 
      ON ACTION qvl
         LET g_action_choice="qvl"
         EXIT DISPLAY
 
      ON ACTION runcard
         LET g_action_choice="runcard"
         EXIT DISPLAY
         
      ON ACTION report_no
         LET g_action_choice="report_no"
         EXIT DISPLAY

      ON ACTION Routing_Reportable
         LET g_action_choice="Routing_Reportable"
         EXIT DISPLAY
      #CHI-D20030---begin
      ON ACTION off_line
         LET g_action_choice="off_line"
         EXIT DISPLAY
      #CHI-D20030---end
      #@ON ACTION 庫存資料
      ON ACTION inventory
         LET g_action_choice="inventory"
         EXIT DISPLAY
 
      #@ON ACTION 材料供需
      ON ACTION meterial_supply
         LET g_action_choice="meterial_supply"
         EXIT DISPLAY
 
      #@ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
 
      #@ON ACTION 工單維護
      ON ACTION maint_w_o
         LET g_action_choice="maint_w_o"
         EXIT DISPLAY
 
      #@ON ACTION 工廠切換
    # ON ACTION switch_plant                  #FUN-B10030
    #    LET g_action_choice="switch_plant"   #FUN-B10030
    #    EXIT DISPLAY                         #FUN-B10030
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("group01","AUTO")                                                                                      
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q301_bp3_refresh()
   DISPLAY ARRAY g_arr3 TO s_arr3.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
 
FUNCTION q301_bp4(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)  #MOD-4A0139
   DISPLAY ARRAY g_arr4 TO s_arr4.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION first
         CALL q301_fetch('F')
         EXIT DISPLAY
         CALL q301_bp4_refresh()
 
      ON ACTION previous
         CALL q301_fetch('P')
         EXIT DISPLAY
         CALL q301_bp4_refresh()
 
      ON ACTION jump
         CALL q301_fetch('/')
         EXIT DISPLAY
         CALL q301_bp4_refresh()
 
      ON ACTION next
         CALL q301_fetch('N')
         EXIT DISPLAY
         CALL q301_bp4_refresh()
 
      ON ACTION last
         CALL q301_fetch('L')
         EXIT DISPLAY
         CALL q301_bp4_refresh()
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CALL q301_def_form()   #FUN-610006
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
         IF NOT cl_null(g_sfb.sfb28) THEN
            LET g_close = 'Y'
         ELSE
            LET g_close = 'N'
         END IF
         #圖形顯示
         CALL cl_set_field_pic(g_confirm,"","",g_close,g_void,g_sfb.sfbacti)
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #@ON ACTION 查詢
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      #@ON ACTION 備料
      ON ACTION allotment
         LET g_action_choice="allotment"
         EXIT DISPLAY
 
      #@ON ACTION 製程
      ON ACTION routing
         LET g_action_choice="routing"
         EXIT DISPLAY
 
      #@ON ACTION 委外採購
      ON ACTION sub_po
         LET g_action_choice="sub_po"
         EXIT DISPLAY
 
      #@ON ACTION 發料
      ON ACTION issue
         LET g_action_choice="issue"
         EXIT DISPLAY
 
      ON ACTION fqc
         LET g_action_choice="fqc"
         EXIT DISPLAY
 
      #@ON ACTION 入庫
      ON ACTION store_in
         LET g_action_choice="store_in"
         EXIT DISPLAY
 
      #@ON ACTION 子工單
      ON ACTION sub_wo
         LET g_action_choice="sub_wo"
         EXIT DISPLAY
 
      #@ON ACTION 替代
      ON ACTION substitute
         LET g_action_choice="substitute"
         EXIT DISPLAY
 
      ON ACTION qvl
         LET g_action_choice="qvl"
         EXIT DISPLAY
 
      ON ACTION runcard
         LET g_action_choice="runcard"
         EXIT DISPLAY
         
      ON ACTION report_no
         LET g_action_choice="report_no"
         EXIT DISPLAY

      ON ACTION Routing_Reportable
         LET g_action_choice="Routing_Reportable"
         EXIT DISPLAY
      #CHI-D20030---begin
      ON ACTION off_line
         LET g_action_choice="off_line"
         EXIT DISPLAY
      #CHI-D20030---end
      #@ON ACTION 庫存資料
      ON ACTION inventory
         LET g_action_choice="inventory"
         EXIT DISPLAY
 
      #@ON ACTION 材料供需
      ON ACTION meterial_supply
         LET g_action_choice="meterial_supply"
         EXIT DISPLAY
 
      #@ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
 
      #@ON ACTION 工單維護
      ON ACTION maint_w_o
         LET g_action_choice="maint_w_o"
         EXIT DISPLAY
 
      #@ON ACTION 工廠切換
   #  ON ACTION switch_plant                       #FUN-B10030
   #     LET g_action_choice="switch_plant"        #FUN-B10030
   #     EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("group01","AUTO")                                                                                      
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q301_bp4_refresh()
   DISPLAY ARRAY g_arr4 TO s_arr4.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
 
FUNCTION q301_bp5(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)  #MOD-4A013
   DISPLAY ARRAY g_arr5 TO s_arr5.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION first
         CALL q301_fetch('F')
         EXIT DISPLAY
         CALL q301_bp5_refresh()
 
      ON ACTION previous
         CALL q301_fetch('P')
         EXIT DISPLAY
         CALL q301_bp5_refresh()
 
      ON ACTION jump
         CALL q301_fetch('/')
         EXIT DISPLAY
         CALL q301_bp5_refresh()
 
      ON ACTION next
         CALL q301_fetch('N')
         EXIT DISPLAY
         CALL q301_bp5_refresh()
 
      ON ACTION last
         CALL q301_fetch('L')
         EXIT DISPLAY
         CALL q301_bp5_refresh()
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CALL q301_def_form()   #FUN-610006
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
         IF NOT cl_null(g_sfb.sfb28) THEN
            LET g_close = 'Y'
         ELSE
            LET g_close = 'N'
         END IF
         #圖形顯示
         CALL cl_set_field_pic(g_confirm,"","",g_close,g_void,g_sfb.sfbacti)
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #@ON ACTION 查詢
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      #@ON ACTION 備料
      ON ACTION allotment
         LET g_action_choice="allotment"
         EXIT DISPLAY
 
      #@ON ACTION 製程
      ON ACTION routing
         LET g_action_choice="routing"
         EXIT DISPLAY
 
      #@ON ACTION 委外採購
      ON ACTION sub_po
         LET g_action_choice="sub_po"
         EXIT DISPLAY
 
      #@ON ACTION 發料
      ON ACTION issue
         LET g_action_choice="issue"
         EXIT DISPLAY
 
      ON ACTION fqc
         LET g_action_choice="fqc"
         EXIT DISPLAY
 
      #@ON ACTION 入庫
      ON ACTION store_in
         LET g_action_choice="store_in"
         EXIT DISPLAY
 
      #@ON ACTION 子工單
      ON ACTION sub_wo
         LET g_action_choice="sub_wo"
         EXIT DISPLAY
 
      #@ON ACTION 替代
      ON ACTION substitute
         LET g_action_choice="substitute"
         EXIT DISPLAY
 
      ON ACTION qvl
         LET g_action_choice="qvl"
         EXIT DISPLAY
 
      ON ACTION runcard
         LET g_action_choice="runcard"
         EXIT DISPLAY
         
      ON ACTION report_no
         LET g_action_choice="report_no"
         EXIT DISPLAY

      ON ACTION Routing_Reportable
         LET g_action_choice="Routing_Reportable"
         EXIT DISPLAY
      #CHI-D20030---begin
      ON ACTION off_line
         LET g_action_choice="off_line"
         EXIT DISPLAY
      #CHI-D20030---end
      #@ON ACTION 庫存資料
      ON ACTION inventory
         LET g_action_choice="inventory"
         EXIT DISPLAY
 
      #@ON ACTION 材料供需
      ON ACTION meterial_supply
         LET g_action_choice="meterial_supply"
         EXIT DISPLAY
 
      #@ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
 
      #@ON ACTION 工單維護
      ON ACTION maint_w_o
         LET g_action_choice="maint_w_o"
         EXIT DISPLAY
 
      #@ON ACTION 工廠切換
    # ON ACTION switch_plant                     #FUN-B10030
    #    LET g_action_choice="switch_plant"      #FUN-B10030
    #    EXIT DISPLAY                            #FUN-B10030 
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("group01","AUTO")                                                                                      
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q301_bp5_refresh()
   DISPLAY ARRAY g_arr5 TO s_arr5.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
 
FUNCTION q301_bp6(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)  #MOD-4A013
   DISPLAY ARRAY g_arr6 TO s_arr6.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION first
         CALL q301_fetch('F')
         EXIT DISPLAY
         CALL q301_bp6_refresh()
 
      ON ACTION previous
         CALL q301_fetch('P')
         EXIT DISPLAY
         CALL q301_bp6_refresh()
 
      ON ACTION jump
         CALL q301_fetch('/')
         EXIT DISPLAY
         CALL q301_bp6_refresh()
 
      ON ACTION next
         CALL q301_fetch('N')
         EXIT DISPLAY
         CALL q301_bp6_refresh()
 
      ON ACTION last
         CALL q301_fetch('L')
         EXIT DISPLAY
         CALL q301_bp6_refresh()
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CALL q301_def_form()   #FUN-610006
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
         IF NOT cl_null(g_sfb.sfb28) THEN
            LET g_close = 'Y'
         ELSE
            LET g_close = 'N'
         END IF
         #圖形顯示
         CALL cl_set_field_pic(g_confirm,"","",g_close,g_void,g_sfb.sfbacti)
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #@ON ACTION 查詢
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      #@ON ACTION 備料
      ON ACTION allotment
         LET g_action_choice="allotment"
         EXIT DISPLAY
 
      #@ON ACTION 製程
      ON ACTION routing
         LET g_action_choice="routing"
         EXIT DISPLAY
 
      #@ON ACTION 委外採購
      ON ACTION sub_po
         LET g_action_choice="sub_po"
         EXIT DISPLAY
 
      #@ON ACTION 發料
      ON ACTION issue
         LET g_action_choice="issue"
         EXIT DISPLAY
 
      ON ACTION fqc
         LET g_action_choice="fqc"
         EXIT DISPLAY
 
      #@ON ACTION 入庫
      ON ACTION store_in
         LET g_action_choice="store_in"
         EXIT DISPLAY
 
      #@ON ACTION 子工單
      ON ACTION sub_wo
         LET g_action_choice="sub_wo"
         EXIT DISPLAY
 
      #@ON ACTION 替代
      ON ACTION substitute
         LET g_action_choice="substitute"
         EXIT DISPLAY
 
      ON ACTION qvl
         LET g_action_choice="qvl"
         EXIT DISPLAY
 
      ON ACTION runcard
         LET g_action_choice="runcard"
         EXIT DISPLAY
         
      ON ACTION report_no
         LET g_action_choice="report_no"
         EXIT DISPLAY

      ON ACTION Routing_Reportable
         LET g_action_choice="Routing_Reportable"
         EXIT DISPLAY
      #CHI-D20030---begin
      ON ACTION off_line
         LET g_action_choice="off_line"
         EXIT DISPLAY
      #CHI-D20030---end
      #@ON ACTION 庫存資料
      ON ACTION inventory
         LET g_action_choice="inventory"
         EXIT DISPLAY
 
      #@ON ACTION 材料供需
      ON ACTION meterial_supply
         LET g_action_choice="meterial_supply"
         EXIT DISPLAY
 
      #@ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
 
      #@ON ACTION 工單維護
      ON ACTION maint_w_o
         LET g_action_choice="maint_w_o"
         EXIT DISPLAY
 
      #@ON ACTION 工廠切換
    # ON ACTION switch_plant                  #FUN-B10030
    #    LET g_action_choice="switch_plant"   #FUN-B10030
    #    EXIT DISPLAY                         #FUN-B10030
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("group01","AUTO")                                                                                      
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q301_bp6_refresh()
   DISPLAY ARRAY g_arr6 TO s_arr6.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
 
FUNCTION q301_bp7(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)  #MOD-4A013
   DISPLAY ARRAY g_arr7 TO s_arr7.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION first
         CALL q301_fetch('F')
         EXIT DISPLAY
         CALL q301_bp7_refresh()
 
      ON ACTION previous
         CALL q301_fetch('P')
         EXIT DISPLAY
         CALL q301_bp7_refresh()
 
      ON ACTION jump
         CALL q301_fetch('/')
         EXIT DISPLAY
         CALL q301_bp7_refresh()
 
      ON ACTION next
         CALL q301_fetch('N')
         EXIT DISPLAY
         CALL q301_bp7_refresh()
 
      ON ACTION last
         CALL q301_fetch('L')
         EXIT DISPLAY
         CALL q301_bp7_refresh()
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CALL q301_def_form()   #FUN-610006
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
         IF NOT cl_null(g_sfb.sfb28) THEN
            LET g_close = 'Y'
         ELSE
            LET g_close = 'N'
         END IF
         #圖形顯示
         CALL cl_set_field_pic(g_confirm,"","",g_close,g_void,g_sfb.sfbacti)
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #@ON ACTION 查詢
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      #@ON ACTION 備料
      ON ACTION allotment
         LET g_action_choice="allotment"
         EXIT DISPLAY
 
      #@ON ACTION 製程
      ON ACTION routing
         LET g_action_choice="routing"
         EXIT DISPLAY
 
      #@ON ACTION 委外採購
      ON ACTION sub_po
         LET g_action_choice="sub_po"
         EXIT DISPLAY
 
      #@ON ACTION 發料
      ON ACTION issue
         LET g_action_choice="issue"
         EXIT DISPLAY
 
      ON ACTION fqc
         LET g_action_choice="fqc"
         EXIT DISPLAY
 
      #@ON ACTION 入庫
      ON ACTION store_in
         LET g_action_choice="store_in"
         EXIT DISPLAY
 
      #@ON ACTION 子工單
      ON ACTION sub_wo
         LET g_action_choice="sub_wo"
         EXIT DISPLAY
 
      #@ON ACTION 替代
      ON ACTION substitute
         LET g_action_choice="substitute"
         EXIT DISPLAY
 
      ON ACTION qvl
         LET g_action_choice="qvl"
         EXIT DISPLAY
 
      ON ACTION runcard
         LET g_action_choice="runcard"
         EXIT DISPLAY
         
      ON ACTION report_no
         LET g_action_choice="report_no"
         EXIT DISPLAY

      ON ACTION Routing_Reportable
         LET g_action_choice="Routing_Reportable"
         EXIT DISPLAY
      #CHI-D20030---begin
      ON ACTION off_line
         LET g_action_choice="off_line"
         EXIT DISPLAY
      #CHI-D20030---end
      #@ON ACTION 庫存資料
      ON ACTION inventory
         LET g_action_choice="inventory"
         EXIT DISPLAY
 
      #@ON ACTION 材料供需
      ON ACTION meterial_supply
         LET g_action_choice="meterial_supply"
         EXIT DISPLAY
 
      #@ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
 
      #@ON ACTION 工單維護
      ON ACTION maint_w_o
         LET g_action_choice="maint_w_o"
         EXIT DISPLAY
 
      #@ON ACTION 工廠切換
    # ON ACTION switch_plant                     #FUN-B10030
    #    LET g_action_choice="switch_plant"      #FUN-B10030
    #    EXIT DISPLAY                            #FUN-B10030 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("group01","AUTO")                                                                                      
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q301_bp7_refresh()
   DISPLAY ARRAY g_arr7 TO s_arr7.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
 
FUNCTION q301_bp8(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
display 'g_rec_b=',g_rec_b
    CALL cl_set_act_visible("accept,cancel", FALSE)  #MOD-4A013
   DISPLAY ARRAY g_arr8 TO s_arr8.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION first
         CALL q301_fetch('F')
         EXIT DISPLAY
         CALL q301_bp8_refresh()
 
      ON ACTION previous
         CALL q301_fetch('P')
         EXIT DISPLAY
         CALL q301_bp8_refresh()
 
      ON ACTION jump
         CALL q301_fetch('/')
         EXIT DISPLAY
         CALL q301_bp8_refresh()
 
      ON ACTION next
         CALL q301_fetch('N')
         EXIT DISPLAY
         CALL q301_bp8_refresh()
 
      ON ACTION last
         CALL q301_fetch('L')
         EXIT DISPLAY
         CALL q301_bp8_refresh()
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CALL q301_def_form()   #FUN-610006
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
         IF NOT cl_null(g_sfb.sfb28) THEN
            LET g_close = 'Y'
         ELSE
            LET g_close = 'N'
         END IF
         #圖形顯示
         CALL cl_set_field_pic(g_confirm,"","",g_close,g_void,g_sfb.sfbacti)
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #@ON ACTION 查詢
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      #@ON ACTION 備料
      ON ACTION allotment
         LET g_action_choice="allotment"
         EXIT DISPLAY
 
      #@ON ACTION 製程
      ON ACTION routing
         LET g_action_choice="routing"
         EXIT DISPLAY
 
      #@ON ACTION 委外採購
      ON ACTION sub_po
         LET g_action_choice="sub_po"
         EXIT DISPLAY
 
      #@ON ACTION 發料
      ON ACTION issue
         LET g_action_choice="issue"
         EXIT DISPLAY
 
      ON ACTION fqc
         LET g_action_choice="fqc"
         EXIT DISPLAY
 
      #@ON ACTION 入庫
      ON ACTION store_in
         LET g_action_choice="store_in"
         EXIT DISPLAY
 
      #@ON ACTION 子工單
      ON ACTION sub_wo
         LET g_action_choice="sub_wo"
         EXIT DISPLAY
 
      #@ON ACTION 替代
      ON ACTION substitute
         LET g_action_choice="substitute"
         EXIT DISPLAY
 
      ON ACTION qvl
         LET g_action_choice="qvl"
         EXIT DISPLAY
 
      ON ACTION runcard
         LET g_action_choice="runcard"
         EXIT DISPLAY
 
 
      ON ACTION report_no
         LET g_action_choice="report_no"
         EXIT DISPLAY
      
      ON ACTION Routing_Reportable
         LET g_action_choice="Routing_Reportable"
         EXIT DISPLAY
      #CHI-D20030---begin
      ON ACTION off_line
         LET g_action_choice="off_line"
         EXIT DISPLAY
      #CHI-D20030---end
      #@ON ACTION 庫存資料
      ON ACTION inventory
         LET g_action_choice="inventory"
         EXIT DISPLAY
 
      #@ON ACTION 材料供需
      ON ACTION meterial_supply
         LET g_action_choice="meterial_supply"
         EXIT DISPLAY
 
      #@ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
 
      #@ON ACTION 工單維護
      ON ACTION maint_w_o
         LET g_action_choice="maint_w_o"
         EXIT DISPLAY
 
      #@ON ACTION 工廠切換
    # ON ACTION switch_plant                     #FUN-B10030
    #    LET g_action_choice="switch_plant"      #FUN-B10030
    #    EXIT DISPLAY                            #FUN-B10030
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("group01","AUTO")                                                                                      
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q301_bp8_refresh()
   DISPLAY ARRAY g_arr8 TO s_arr8.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
 
FUNCTION q301_bp9(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)  #MOD-4A013
   DISPLAY ARRAY g_arr9 TO s_arr9.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION first
         CALL q301_fetch('F')
         EXIT DISPLAY
         CALL q301_bp9_refresh()
 
      ON ACTION previous
         CALL q301_fetch('P')
         EXIT DISPLAY
         CALL q301_bp9_refresh()
 
      ON ACTION jump
         CALL q301_fetch('/')
         EXIT DISPLAY
         CALL q301_bp9_refresh()
 
      ON ACTION next
         CALL q301_fetch('N')
         EXIT DISPLAY
         CALL q301_bp9_refresh()
 
      ON ACTION last
         CALL q301_fetch('L')
         EXIT DISPLAY
         CALL q301_bp9_refresh()
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CALL q301_def_form()   #FUN-610006
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
         IF NOT cl_null(g_sfb.sfb28) THEN
            LET g_close = 'Y'
         ELSE
            LET g_close = 'N'
         END IF
         #圖形顯示
         CALL cl_set_field_pic(g_confirm,"","",g_close,g_void,g_sfb.sfbacti)
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #@ON ACTION 查詢
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      #@ON ACTION 備料
      ON ACTION allotment
         LET g_action_choice="allotment"
         EXIT DISPLAY
 
      #@ON ACTION 製程
      ON ACTION routing
         LET g_action_choice="routing"
         EXIT DISPLAY
 
      #@ON ACTION 委外採購
      ON ACTION sub_po
         LET g_action_choice="sub_po"
         EXIT DISPLAY
 
      #@ON ACTION 發料
      ON ACTION issue
         LET g_action_choice="issue"
         EXIT DISPLAY
 
      ON ACTION fqc
         LET g_action_choice="fqc"
         EXIT DISPLAY
 
      #@ON ACTION 入庫
      ON ACTION store_in
         LET g_action_choice="store_in"
         EXIT DISPLAY
 
      #@ON ACTION 子工單
      ON ACTION sub_wo
         LET g_action_choice="sub_wo"
         EXIT DISPLAY
 
      #@ON ACTION 替代
      ON ACTION substitute
         LET g_action_choice="substitute"
         EXIT DISPLAY
 
      ON ACTION qvl
         LET g_action_choice="qvl"
         EXIT DISPLAY
 
      ON ACTION runcard
         LET g_action_choice="runcard"
         EXIT DISPLAY
         
      ON ACTION report_no
         LET g_action_choice="report_no"
         EXIT DISPLAY

      ON ACTION Routing_Reportable
         LET g_action_choice="Routing_Reportable"
         EXIT DISPLAY
      #CHI-D20030---begin
      ON ACTION off_line
         LET g_action_choice="off_line"
         EXIT DISPLAY
      #CHI-D20030---end
      #@ON ACTION 庫存資料
      ON ACTION inventory
         LET g_action_choice="inventory"
         EXIT DISPLAY
 
      #@ON ACTION 材料供需
      ON ACTION meterial_supply
         LET g_action_choice="meterial_supply"
         EXIT DISPLAY
 
      #@ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
 
      #@ON ACTION 工單維護
      ON ACTION maint_w_o
         LET g_action_choice="maint_w_o"
         EXIT DISPLAY
 
      #@ON ACTION 工廠切換
   #  ON ACTION switch_plant                     #FUN-B10030
   #     LET g_action_choice="switch_plant"      #FUN-B10030
   #     EXIT DISPLAY                            #FUN-B10030
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("group01","AUTO")                                                                                      
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q301_bp9_refresh()
   DISPLAY ARRAY g_arr9 TO s_arr9.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
 
FUNCTION q301_bp10(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)  #MOD-4A013
   DISPLAY ARRAY g_arr10 TO s_arr10.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION first
         CALL q301_fetch('F')
         EXIT DISPLAY
         CALL q301_bp10_refresh()
 
      ON ACTION previous
         CALL q301_fetch('P')
         EXIT DISPLAY
         CALL q301_bp10_refresh()
 
      ON ACTION jump
         CALL q301_fetch('/')
         EXIT DISPLAY
         CALL q301_bp10_refresh()
 
      ON ACTION next
         CALL q301_fetch('N')
         EXIT DISPLAY
         CALL q301_bp10_refresh()
 
      ON ACTION last
         CALL q301_fetch('L')
         EXIT DISPLAY
         CALL q301_bp10_refresh()
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CALL q301_def_form()   #FUN-610006
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
         IF NOT cl_null(g_sfb.sfb28) THEN
            LET g_close = 'Y'
         ELSE
            LET g_close = 'N'
         END IF
         #圖形顯示
         CALL cl_set_field_pic(g_confirm,"","",g_close,g_void,g_sfb.sfbacti)
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #@ON ACTION 查詢
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      #@ON ACTION 備料
      ON ACTION allotment
         LET g_action_choice="allotment"
         EXIT DISPLAY
 
      #@ON ACTION 製程
      ON ACTION routing
         LET g_action_choice="routing"
         EXIT DISPLAY
 
      #@ON ACTION 委外採購
      ON ACTION sub_po
         LET g_action_choice="sub_po"
         EXIT DISPLAY
 
      #@ON ACTION 發料
      ON ACTION issue
         LET g_action_choice="issue"
         EXIT DISPLAY
 
      ON ACTION fqc
         LET g_action_choice="fqc"
         EXIT DISPLAY
 
      #@ON ACTION 入庫
      ON ACTION store_in
         LET g_action_choice="store_in"
         EXIT DISPLAY
 
      #@ON ACTION 子工單
      ON ACTION sub_wo
         LET g_action_choice="sub_wo"
         EXIT DISPLAY
 
      #@ON ACTION 替代
      ON ACTION substitute
         LET g_action_choice="substitute"
         EXIT DISPLAY
 
      ON ACTION qvl
         LET g_action_choice="qvl"
         EXIT DISPLAY
 
      ON ACTION runcard
         LET g_action_choice="runcard"
         EXIT DISPLAY
         
      ON ACTION report_no
         LET g_action_choice="report_no"
         EXIT DISPLAY

      ON ACTION Routing_Reportable
         LET g_action_choice="Routing_Reportable"
         EXIT DISPLAY
      #CHI-D20030---begin
      ON ACTION off_line
         LET g_action_choice="off_line"
         EXIT DISPLAY
      #CHI-D20030---end   
      #@ON ACTION 庫存資料
      ON ACTION inventory
         LET g_action_choice="inventory"
         EXIT DISPLAY
 
      #@ON ACTION 材料供需
      ON ACTION meterial_supply
         LET g_action_choice="meterial_supply"
         EXIT DISPLAY
 
      #@ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
 
      #@ON ACTION 工單維護
      ON ACTION maint_w_o
         LET g_action_choice="maint_w_o"
         EXIT DISPLAY
 
      #@ON ACTION 工廠切換
    # ON ACTION switch_plant                    #FUN-B10030
    #    LET g_action_choice="switch_plant"     #FUN-B10030
    #    EXIT DISPLAY                           #FUN-B10030
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("group01","AUTO")                                                                                      
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q301_bp10_refresh()
   DISPLAY ARRAY g_arr10 TO s_arr10.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
 
FUNCTION q301_bp11(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)  
   DISPLAY ARRAY g_arr11 TO s_arr11.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION first
         CALL q301_fetch('F')
         EXIT DISPLAY
         CALL q301_bp11_refresh()
 
      ON ACTION previous
         CALL q301_fetch('P')
         EXIT DISPLAY
         CALL q301_bp11_refresh()
 
      ON ACTION jump
         CALL q301_fetch('/')
         EXIT DISPLAY
         CALL q301_bp11_refresh()
 
      ON ACTION next
         CALL q301_fetch('N')
         EXIT DISPLAY
         CALL q301_bp11_refresh()
 
      ON ACTION last
         CALL q301_fetch('L')
         EXIT DISPLAY
         CALL q301_bp11_refresh()
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CALL q301_def_form()   #FUN-610006
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
         IF NOT cl_null(g_sfb.sfb28) THEN
            LET g_close = 'Y'
         ELSE
            LET g_close = 'N'
         END IF
         #圖形顯示
         CALL cl_set_field_pic(g_confirm,"","",g_close,g_void,g_sfb.sfbacti)
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #@ON ACTION 查詢
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      #@ON ACTION 備料
      ON ACTION allotment
         LET g_action_choice="allotment"
         EXIT DISPLAY
 
      #@ON ACTION 製程
      ON ACTION routing
         LET g_action_choice="routing"
         EXIT DISPLAY
 
      #@ON ACTION 委外採購
      ON ACTION sub_po
         LET g_action_choice="sub_po"
         EXIT DISPLAY
 
      #@ON ACTION 發料
      ON ACTION issue
         LET g_action_choice="issue"
         EXIT DISPLAY
 
      ON ACTION fqc
         LET g_action_choice="fqc"
         EXIT DISPLAY
 
      #@ON ACTION 入庫
      ON ACTION store_in
         LET g_action_choice="store_in"
         EXIT DISPLAY
 
      #@ON ACTION 子工單
      ON ACTION sub_wo
         LET g_action_choice="sub_wo"
         EXIT DISPLAY
 
      #@ON ACTION 替代
      ON ACTION substitute
         LET g_action_choice="substitute"
         EXIT DISPLAY
 
      ON ACTION qvl
         LET g_action_choice="qvl"
         EXIT DISPLAY
 
      ON ACTION runcard
         LET g_action_choice="runcard"
         EXIT DISPLAY
         
      ON ACTION report_no
         LET g_action_choice="report_no"
         EXIT DISPLAY
         
      ON ACTION Routing_Reportable
         LET g_action_choice="Routing_Reportable"
         EXIT DISPLAY
      #CHI-D20030---begin
      ON ACTION off_line
         LET g_action_choice="off_line"
         EXIT DISPLAY
      #CHI-D20030---end    
      #@ON ACTION 庫存資料
      ON ACTION inventory
         LET g_action_choice="inventory"
         EXIT DISPLAY
 
      #@ON ACTION 材料供需
      ON ACTION meterial_supply
         LET g_action_choice="meterial_supply"
         EXIT DISPLAY
 
      #@ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
 
      #@ON ACTION 工單維護
      ON ACTION maint_w_o
         LET g_action_choice="maint_w_o"
         EXIT DISPLAY
 
      #@ON ACTION 工廠切換
     #ON ACTION switch_plant                     #FUN-B10030
     #   LET g_action_choice="switch_plant"      #FUN-B10030
     #   EXIT DISPLAY                            #FUN-B10030
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("group01","AUTO")                                                                                      
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q301_bp11_refresh()
   DISPLAY ARRAY g_arr11 TO s_arr11.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION

FUNCTION q301_bp13(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          

   IF p_ud <> "G" THEN
      RETURN
   END IF

   LET g_action_choice = " "

    CALL cl_set_act_visible("accept,cancel", FALSE)  
    DISPLAY ARRAY g_arr13 TO s_arr13.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()

      ON ACTION first
         CALL q301_fetch('F')
         EXIT DISPLAY
         CALL q301_bp13_refresh()

      ON ACTION previous
         CALL q301_fetch('P')
         EXIT DISPLAY
         CALL q301_bp13_refresh()

      ON ACTION jump
         CALL q301_fetch('/')
         EXIT DISPLAY
         CALL q301_bp13_refresh()

      ON ACTION next
         CALL q301_fetch('N')
         EXIT DISPLAY
         CALL q301_bp13_refresh()

      ON ACTION last
         CALL q301_fetch('L')
         EXIT DISPLAY
         CALL q301_bp13_refresh()

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CALL q301_def_form()   #FUN-610006
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
         IF NOT cl_null(g_sfb.sfb28) THEN
            LET g_close = 'Y'
         ELSE
            LET g_close = 'N'
         END IF
         #圖形顯示
         CALL cl_set_field_pic(g_confirm,"","",g_close,g_void,g_sfb.sfbacti)
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      #@ON ACTION 查詢
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      #@ON ACTION 備料
      ON ACTION allotment
         LET g_action_choice="allotment"
         EXIT DISPLAY

      #@ON ACTION 製程
      ON ACTION routing
         LET g_action_choice="routing"
         EXIT DISPLAY

      #@ON ACTION 委外採購
      ON ACTION sub_po
         LET g_action_choice="sub_po"
         EXIT DISPLAY

      #@ON ACTION 發料
      ON ACTION issue
         LET g_action_choice="issue"
         EXIT DISPLAY

      ON ACTION fqc
         LET g_action_choice="fqc"
         EXIT DISPLAY

      #@ON ACTION 入庫
      ON ACTION store_in
         LET g_action_choice="store_in"
         EXIT DISPLAY

      #@ON ACTION 子工單
      ON ACTION sub_wo
         LET g_action_choice="sub_wo"
         EXIT DISPLAY

      #@ON ACTION 替代
      ON ACTION substitute
         LET g_action_choice="substitute"
         EXIT DISPLAY

      ON ACTION qvl
         LET g_action_choice="qvl"
         EXIT DISPLAY

      ON ACTION runcard
         LET g_action_choice="runcard"
         EXIT DISPLAY
         
      ON ACTION report_no
         LET g_action_choice="report_no"
         EXIT DISPLAY
         
      ON ACTION Routing_Reportable
         LET g_action_choice="Routing_Reportable"
         EXIT DISPLAY
      #CHI-D20030---begin
      ON ACTION off_line
         LET g_action_choice="off_line"
         EXIT DISPLAY
      #CHI-D20030---end
      #@ON ACTION 庫存資料
      ON ACTION inventory
         LET g_action_choice="inventory"
         EXIT DISPLAY

      #@ON ACTION 材料供需
      ON ACTION meterial_supply
         LET g_action_choice="meterial_supply"
         EXIT DISPLAY

      #@ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY

      #@ON ACTION 工單維護
      ON ACTION maint_w_o
         LET g_action_choice="maint_w_o"
         EXIT DISPLAY

      #@ON ACTION 工廠切換
    # ON ACTION switch_plant                    #FUN-B10030
    #    LET g_action_choice="switch_plant"     #FUN-B10030
   #     EXIT DISPLAY                           #FUN-B10030

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("group01","AUTO")                                                                                      
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q301_bp13_refresh()
   DISPLAY ARRAY g_arr13 TO s_arr13.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION

#CHI-D20030---begin
FUNCTION q301_bp14(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          

   IF p_ud <> "G" THEN
      RETURN
   END IF

   LET g_action_choice = " "

    CALL cl_set_act_visible("accept,cancel", FALSE)  
    DISPLAY ARRAY g_arr14 TO s_arr14.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()

      ON ACTION first
         CALL q301_fetch('F')
         EXIT DISPLAY
         CALL q301_bp14_refresh()

      ON ACTION previous
         CALL q301_fetch('P')
         EXIT DISPLAY
         CALL q301_bp14_refresh()

      ON ACTION jump
         CALL q301_fetch('/')
         EXIT DISPLAY
         CALL q301_bp14_refresh()

      ON ACTION next
         CALL q301_fetch('N')
         EXIT DISPLAY
         CALL q301_bp14_refresh()

      ON ACTION last
         CALL q301_fetch('L')
         EXIT DISPLAY
         CALL q301_bp14_refresh()

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()  
         CALL q301_def_form()   
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
         IF NOT cl_null(g_sfb.sfb28) THEN
            LET g_close = 'Y'
         ELSE
            LET g_close = 'N'
         END IF
         #圖形顯示
         CALL cl_set_field_pic(g_confirm,"","",g_close,g_void,g_sfb.sfbacti)
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      #@ON ACTION 查詢
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      #@ON ACTION 備料
      ON ACTION allotment
         LET g_action_choice="allotment"
         EXIT DISPLAY

      #@ON ACTION 製程
      ON ACTION routing
         LET g_action_choice="routing"
         EXIT DISPLAY

      #@ON ACTION 委外採購
      ON ACTION sub_po
         LET g_action_choice="sub_po"
         EXIT DISPLAY

      #@ON ACTION 發料
      ON ACTION issue
         LET g_action_choice="issue"
         EXIT DISPLAY

      ON ACTION fqc
         LET g_action_choice="fqc"
         EXIT DISPLAY

      #@ON ACTION 入庫
      ON ACTION store_in
         LET g_action_choice="store_in"
         EXIT DISPLAY

      #@ON ACTION 子工單
      ON ACTION sub_wo
         LET g_action_choice="sub_wo"
         EXIT DISPLAY

      #@ON ACTION 替代
      ON ACTION substitute
         LET g_action_choice="substitute"
         EXIT DISPLAY

      ON ACTION qvl
         LET g_action_choice="qvl"
         EXIT DISPLAY

      ON ACTION runcard
         LET g_action_choice="runcard"
         EXIT DISPLAY
         
      ON ACTION report_no
         LET g_action_choice="report_no"
         EXIT DISPLAY
         
      ON ACTION Routing_Reportable
         LET g_action_choice="Routing_Reportable"
         EXIT DISPLAY
      #CHI-D20030---begin
      ON ACTION off_line
         LET g_action_choice="off_line"
         EXIT DISPLAY
      #CHI-D20030---end
      #@ON ACTION 庫存資料
      ON ACTION inventory
         LET g_action_choice="inventory"
         EXIT DISPLAY

      #@ON ACTION 材料供需
      ON ACTION meterial_supply
         LET g_action_choice="meterial_supply"
         EXIT DISPLAY

      #@ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY

      #@ON ACTION 工單維護
      ON ACTION maint_w_o
         LET g_action_choice="maint_w_o"
         EXIT DISPLAY

      #@ON ACTION 工廠切換
    # ON ACTION switch_plant                    #FUN-B10030
    #    LET g_action_choice="switch_plant"     #FUN-B10030
   #     EXIT DISPLAY                           #FUN-B10030

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("group01","AUTO")                                                                                      
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q301_bp14_refresh()
   DISPLAY ARRAY g_arr14 TO s_arr14.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
#CHI-D20030---end

FUNCTION q301_def_form()
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("c8,c9,c10,c11,d11,d12,d13,d14,f11,f12,f13,f14",FALSE)
   END IF
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("c8",g_msg CLIPPED)
      CALL cl_set_comp_att_text("d11",g_msg CLIPPED)
      CALL cl_set_comp_att_text("f11",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("c9",g_msg CLIPPED)
      CALL cl_set_comp_att_text("d12",g_msg CLIPPED)
      CALL cl_set_comp_att_text("f12",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("c10",g_msg CLIPPED)
      CALL cl_set_comp_att_text("d13",g_msg CLIPPED)
      CALL cl_set_comp_att_text("f13",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("c11",g_msg CLIPPED)
      CALL cl_set_comp_att_text("d14",g_msg CLIPPED)
      CALL cl_set_comp_att_text("f14",g_msg CLIPPED)
   END IF
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("c8",g_msg CLIPPED)
      CALL cl_set_comp_att_text("d11",g_msg CLIPPED)
      CALL cl_set_comp_att_text("f11",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("c9",g_msg CLIPPED)
      CALL cl_set_comp_att_text("d12",g_msg CLIPPED)
      CALL cl_set_comp_att_text("f12",g_msg CLIPPED)
      CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("c10",g_msg CLIPPED)
      CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("c11",g_msg CLIPPED)
      CALL cl_getmsg('asm-328',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("d13",g_msg CLIPPED)
      CALL cl_set_comp_att_text("f13",g_msg CLIPPED)
      CALL cl_getmsg('asm-329',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("d14",g_msg CLIPPED)
      CALL cl_set_comp_att_text("f14",g_msg CLIPPED)
   END IF
   CALL cl_set_comp_visible('sfb919',g_sma.sma1421='Y')      #FUN-A80150 add
END FUNCTION
#No.FUN-9C0072 精簡程式碼

 
