# Prog. Version..: '5.30.05-13.04.01(00010)'     #
#
# Pattern name...: aimq102.4gl
# Descriptions...: 料件動態資料查詢
#                g_argv1      # 1.依料號 2.依工單 3.依訂單 4.依BOM
#                g_argv2      # 1.料號   2.工單   3.訂單   4.產品
# Date & Author..: 91/10/19 By Carol
# Modify.........: 97/07/30 By Melody ogb19 取消
# Modify.........: No:8405 03/10/02 By Melody line494 應該 INITIALIZE g_ima.* TO NULL後再RETURN 避免查詢某一不存在料號,按期間採購卻有上一筆查詢的殘值
# Modify.........: No.MOD-480150 04/09/13 By Nicola 1.action "期間異動" ,"在途調撥", "ECN","BOM用途",無法使用
#                                                   2.b_fill 未 add deleteElement() 使單身 "可用倉儲" 多 display 一些東西
# Modify.........: No.MOD-490286 04/09/30 By Nicola 1. action '開窗查詢' 應放在料件欄位'放大鏡',不須有一action
#                                                   2. action '料件查詢'與top menu 的查詢重複,不須存在
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4B0043 04/11/15 By Nicola 加入開窗功能
# Modify.........: No.MOD-4C0031 04/12/07 By Mandy 利用期間異動查詢後,再次進入期間異動查詢,要能重新下QBE
# Modify.........: No.MOD-4C0085 04/12/14 By day   BOM用途功能開窗錯誤
# Modify.........: NO.MOD-510123 05/01/18 by ching EF簽核納入
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC()方式的改成用LIKE方式
# Modify.........: No.MOD-530273 05/04/04 By Mandy 1.切換工廠劃面單頭清為空白,title要show成切換過後的工廠
# Modify.........: No.MOD-580174 05/09/05 By Rosayu IQC的在驗量應加入委外採購數量(但是製程委外應排除)
# Modify.........: No.MOD-590279 05/09/16 By pengu  在DISPLAY ARRAY未加ATTRIBUTE，照成單身顯示有問題
# Modify.........: No.MOD-5A0151 05/10/13 By Sarah q102_menu()段加入LET INT_FLAG=0
# Modify.........: No.FUN-5A0062 05/10/21 By Sarah 增加show計算"委外IQC在驗量"
# Modify.........: No.MOD-5B0174 05/11/23 By Sarah g_argv2(料號)應放大到40碼,g_msg取6碼改14碼
# Modify.........: No.FUN-5B0069 05/11/30 By Sarah 計算IQC在驗量時需加上rva10!='SUB',計算FQC在驗量時需加上sfb02<>'8'
# Modify.........: No.FUN-5B0114 05/12/07 By Sarah 1.工單在製量應排除"8.重工委外"之工單
#                                                  2.委外在製量未含"8.重工委外",應補入
# Modify.........: No.FUN-5C0046 05/12/19 By kim 修改在製量的where條件
# Modify.........: No.FUN-5C0086 06/01/05 By Sarah 如aimi100依asms290設定動態DISPLAY單位管制方式,第二單位
# Modify.........: No.FUN-610086 06/01/23 By kevin 增加計價欄位
# Modify.........: No.TQC-620102 06/02/22 By Claire _q1()加入ON ACTION cancel 等..
# Modify.........: No.FUN-620040 06/05/23 By kim 客戶反應，單身下條件 (在倉儲批那裡下條件) 無效....
# Modify.........: No.FUN-570017 06/05/26 By Sarah 計算受訂量oeb12-oeb24 => oeb12-oeb24+oeb25-oeb26
# Modify.........: No.FUN-660078 06/06/14 By rainy aim系統中，用char定義的變數，改為用LIK
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-660209 06/07/04 By Sarah 增加ACTION"多單位庫存明細查詢" call aimq410
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.TQC-6A0036 06/10/23 By saki 修改切換工廠按下取消時會關閉程式
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/16 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-710032 07/01/15 By Smapmin 雙單位畫面調整
# Modify.........: No.MOD-710172 07/02/13 By pengu 開啟"最近採購"之視窗應依據參數決定是否顯示計價單位欄位
# Modify.........: No.MOD-730057 07/03/23 By pengu 委外在製量應加入委外IQC 在驗量
# Modify.........: No.TQC-740249 07/04/25 By Rayven 營運中心切換時，取消，界面資料被清空
# Modify.........: No.TQC-750041 07/05/15 By sherry 營運中心切換時，取消，界面資料被清空
# Modify.........: No.TQC-790064 07/09/12 By dxfwo 點ECN進入界面，此界面不能被退出
# Modify.........: No.TQC-7b0008 07/11/01 By wujie 點擊“ECN”、“BOM用途”、“在途調撥”、“最近采購”功能鈕，開窗后，在程式界面的單身位置雙擊，則程式會自動退出界面。
# Modify.........: No.MOD-7C0015 07/12/04 By Pengu 「期間異動」開窗資料,應有匯出excel功能
# Modify.........: No.TQC-7C0069 07/12/07 by heather 開立尚未審核狀態的訂單,不應該計入受訂量,受訂量為實際接到的訂單量 
# Modify.........: No.TQC-7C0097 07/12/08 by zLynn 將采購量分為在采量和在外量來顯示(注：此修改需還原，留下單號僅為了重新將程序過到正式區)
# Modify.........: No.MOD-840041 08/04/08 By claire 排除試產工單(sfb02 != '15')
# Modify.........: No.FUN-840046 08/04/11 By alex 移除無用的on action 1-10
# Modify.........: No.FUN-850153 08/05/29 By Nicola 新增Action "查詢批/序號庫存資料"
# Modify.........: No.MOD-850310 08/05/30 by claire 工單未備(A)  = 應發 - 已發 -代買 + 下階料報廢 - 超領,若 A  < 0 ,則 LET A = 0
# Modify.........: No.MOD-860210 08/07/16 By Pengu 調整可用量不再扣除工單欠料量
# Modify.........: No.MOD-890217 08/09/23 By claire 期間異動匯出excel格式不對齊
# Modify.........: No.MOD-870122 08/07/10 By chenl  調整msg大小為30
# Modify.........: No.MOD-8C0033 08/12/03 By claire 查詢時 單頭 料號開窗 選擇  "全選" 回到主畫面後 按下確定 會出現 (-404) 的錯誤 
# Modify.........: No.FUN-940008 09/05/06 By hongmei GP5.2發料改善
# Modify.........: No.FUN-940083 09/05/14 By dxfwo   原可收量計算(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58)
# Modify.........: No.MOD-970085 09/07/10 By mike 請將LET g_bbb2[g_cnt].pmn31 = sr.pmn31 USING '------&.&&'中的USING取消
# Modify.........: No.MOD-980041 09/08/06 By mike 在aimq102 執行 BOM用途 開窗資料內容異常，看起來很像是當BOM用量小於1時，QPA顯示就會
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9A0068 09/10/23 by dxfwo VMI测试结果反馈及相关调整
# Modify.........: No:TQC-9A0192 09/10/30 by kim GP5.2
# Modify.........: No.FUN-9C0072 10/01/05 By vealxu 精簡程式碼
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:FUN-A20048 10/03/30 By liuxqa 增加备置量栏位
# Modify.........: No:TQC-A40009 10/04/02 By lilingyu 查詢資料，下翻到下一筆資料，"工單備料量sfa_q1"有值,然后再翻到上一筆,上一筆的sfa_q1仍然顯示的是本筆的值 
# Modify.........: No:CHI-A40004 10/04/12 By Summer 單身最後面加show img38欄位
# Modify.........: No:MOD-A60149 10/06/23 By Sarah 在途調撥查詢應排除作廢資料
# Modify.........: No:MOD-A70029 10/07/05 By Smapmin 修改在驗量的算法
# Modify.........: No:TQC-A80005 10/08/02 By jan s_shortqty 加傳參數
# Modify.........: No:MOD-A80066 10/08/11 By sabrina 切換營運中心不可run aoos901，這樣會連udm_tree也跟著變
# Modify.........: No:MOD-A90098 10/09/16 By Summer FQC在驗量應考慮生產單位與庫存單位的換算率 
# Modify.........: NO:MOD-AA0069 10/10/13 BY sabrina FQC在驗量先排除拆件式工單(sfb02<>'11')
# Modify.........: No:MOD-AA0075 10/10/14 By sabrina 還原MOD-A70029
# Modify.........: No:MOD-AB0224 10/11/24 By sabrina 串aimq131/aimq132/aimq136/aimq137/aimq138時，參數前後要加雙引號(") 
# Modify.........: No:MOD-AC0061 10/12/08 By zLynn FQC取消计算结案工单
# Modify.........: No:MOD-B10051 11/01/07 By sabrina 切換營運中心後，畫面的Title也要換成該營運中心的名稱 
# Modify.........: No:TQC-B10143 11/01/14 By jan 工單備置量應計算備置未處理數量
# Modify.........: No:FUN-B10030 11/01/19 By Mengxw Remove "switch_plant"action 
# Modify.........: No:MOD-B30496 11/03/15 By lixh1 調整可用量的計算
# Modify.........: No:FUN-AC0074 11/04/21 By shenyang 調整被質量，添加‘備置明細’欄位
# Modify.........: No:MOD-B50011 11/05/03 By destiny 變量沒有清空，導致上一筆資料會帶到下一筆
# Modify.........: No:MOD-B70050 11/07/17 By Vampire 匯出 excel 改用 cl_cmdrun()
# Modify.........: No:FUN-B80137 11/08/22 By Sakura  單身增加"批序號明細"頁簽
# Modify.........: No:FUN-B80153 11/08/30 by pauline 將期間異動ACTION異動成為SUB程式
# Modify.........: No:CHI-C10003 12/01/04 By ck2yuan 將搜尋條件增加imaacti='Y',避免撈出無效資料
# Modify.........: No:MOD-C10030 12/01/05 By ck2yuan 補上CALL cl_cmdrun(l_cmd) EXIT WHILE 
# Modify.........: No:CHI-B40048 12/02/08 By Elise 期間異動新增"供應商/部門簡稱"
# Modify.........: No:MOD-C10177 12/01/29 By Carrier 还原 MOD-AC0061
# Modify.........: No:TQC-C20310 12/02/21 By yuhuabao Action"查詢批/序號庫存資料"開窗中，也應該要顯示料件動態特性的相關欄位
# Modify.........: No:MOD-C70286 12/08/09 By ck2yuan 因委外入庫會回寫到sfa06,所以 sfa_q1 應加回委外入庫量
# Modify.........: No:CHI-C60036 12/08/13 By ck2yuan 儲位/批號開放可下查詢條件
# Modify.........: No:MOD-C90153 12/10/11 By Elise aimq102的備料條件應與amrp500條件相同
# Modify.........: No:MOD-CA0138 12/10/26 By Elise 調整sql條件
# Modify.........: No:TQC-CC0001 12/12/03 By qirl 欄位開窗查詢
# Modify.........: No:TQC-CC0092 12/12/18 By qirl 新增欄位
# Modify.........: No:CHI-B40039 13/01/18 By Alberti 工單在製量應扣除當站下線量
# Modify.........: No:MOD-D30243 13/03/27 By bart 1.排除作廢 2.播出與撥入的儲位批號，應為各自的倉儲批
# Modify.........: No:MOD-D80023 13/08/05 By fengmy sig05條件少撈sig03，導致撈出之值有誤
# Modify.........: No:TQC-DB0050 13/11/21 By wangrr 修改'儲位名稱'取值方式

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm     RECORD
                 wc       STRING,    #MOD-8C0033 modify LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(500)
                 wc2      LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(500)
              END RECORD,
       m_ima  DYNAMIC ARRAY OF RECORD
                 ima02    LIKE ima_file.ima02,
                 ima021   LIKE ima_file.ima021,
                 ima01    LIKE ima_file.ima01
              END RECORD,
       g_ima  RECORD
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
                 #darcy:2023/06/26 add s---
                 ima44     LIKE ima_file.ima44,
                 ima44_fac LIKE ima_file.ima44_fac,
                 ima45     LIKE ima_file.ima45,
                 ima46     LIKE ima_file.ima46,
                 ima881    LIKE ima_file.ima881,
                 #darcy:2023/06/26 add e---
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
                 ,rpc13      like rpc_file.rpc13   #darcy:2023/06/15 add --独立需求量
                 
              END RECORD,
       #darcy:2024/09/20 add s---
       g_ima_ap  RECORD
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
                 #darcy:2023/06/26 add s---
                 ima44     LIKE ima_file.ima44,
                 ima44_fac LIKE ima_file.ima44_fac,
                 ima45     LIKE ima_file.ima45,
                 ima46     LIKE ima_file.ima46,
                 ima881    LIKE ima_file.ima881,
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
                 ,rpc13      like rpc_file.rpc13   #darcy:2023/06/15 add --独立需求量
              END RECORD,
       #darcy:2024/09/20 add e---
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
              END RECORD,
       g_sw               LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
       g_argv1            LIKE type_file.chr20,   # 1.依料號 2.依工單 3.依訂單 4.依BOM #No.FUN-690026 VARCHAR(20)
       g_argv2            LIKE ima_file.ima01,    # 1.料號   2.工單   3.訂單   4.產品   #MOD-5B0174 #No.FUN-690026 VARCHAR(40)
       g_argv3            varchar(10), #darcy:2024/07/25 add
       g_query_flag       LIKE type_file.num5,    #第一次進入程式時即進入Query之後進入next  #No.FUN-690026 SMALLINT
       g_wc3,g_wc4        STRING,                 #WHERE CONDITION  #No.FUN-580092 HCN
       g_sql              STRING,                 #WHERE CONDITION  #No.FUN-580092 HCN
       g_line1,g_line2    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       g_refresh          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
       g_chr              LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
       g_cmd              LIKE type_file.chr1000, #FUN-660209 add  #No.FUN-690026 VARCHAR(100)
       l_za05             LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
       g_rec_b            LIKE type_file.num5,     #單身筆數  #No.FUN-690026 SMALLINT
       g_rec_b1            LIKE type_file.num5,    #單身筆數  #No.FUN-B80137 SMALLINT
       l_ac               LIKE type_file.num5,     #目前處理的ARRAY CNT      #No.TQC-750041
       l_ac1               LIKE type_file.num5     #目前處理的ARRAY CNT      #No.FUN-B80137
DEFINE p_row,p_col        LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_count            LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cnt              LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_unavl_stk        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
DEFINE g_avl_stk          LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
DEFINE g_msg              LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index       LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump             LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_no_ask          LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE lc_qbe_sn          LIKE gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE g_plant_t          LIKE type_file.chr21   #No.TQC-740249                                                                                      
DEFINE g_flag             LIKE type_file.chr1    #No.TQC-740249
DEFINE g_curs_index_t     LIKE type_file.num10  #No.TQC-750041
DEFINE w ui.Window                          #MOD-890217
DEFINE n om.DomNode                         #MOD-890217
#FUN-B80137 add begin--------------------------
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
                END RECORD
#FUN-B80137 add -end---------------------------
 
FUNCTION aimq102(p_argv1,p_argv2,p_argv3)
   DEFINE p_argv1   LIKE type_file.chr1000, # 1.依料號 2.依工單 3.依訂單 4.依BOM #No.FUN-690026 VARCHAR(20)
          p_argv2   LIKE ima_file.ima01,    # 1.料號   2.工單   3.訂單   4.產品   #MOD-5B0174 #No.FUN-690026 VARCHAR(40)
          p_argv3   varchar(10) #darcy:2024/07/25 add 1. 全部料号 2.量产 3.试产

   WHENEVER ERROR CONTINUE
 
   LET g_sw = p_argv1
   LET g_argv1 = p_argv1
   LET g_argv2 = p_argv2
   let g_argv3 = p_argv3 #darcy:2024/07/25 add s---
   LET g_query_flag = 1
   LET g_line1 = 3
   LET g_line2 = 4
   LET g_refresh = 'Y'                    #功能 'D.切換 Database'
 
   WHILE g_refresh = 'Y'
      LET g_refresh = 'N'                    #
 
      LET p_row = 1 LET p_col = 6
      LET g_line1 = 1
      LET g_line2 = 2
 
      OPEN WINDOW q102_w WITH FORM "cim/42f/cimq102"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
      CALL cl_ui_init() #TQC-9A0192
      
      CALL q102_mu_ui()
 
      IF NOT cl_null(g_argv1) THEN
         CALL q102_q()
      END IF
 
      LET g_flag = 0
 
      IF NOT cl_null(g_plant_t) THEN
         IF g_plant_t = g_plant THEN
            LET g_flag = 1
            CALL q102_q()
         END IF
      END IF
 
      CALL q102_menu()
 
      CLOSE WINDOW q102_w
 
   END WHILE
 
END FUNCTION
 
#QBE 查詢資料
FUNCTION q102_cs()
   DEFINE l_cnt        LIKE type_file.num5   #No.FUN-690026 SMALLINT
 
   IF NOT cl_null(g_argv1) THEN
      CASE WHEN g_argv1='1' LET tm.wc = "ima01 = '",g_argv2,"'"
           WHEN g_argv1='2' LET tm.wc = "ima01 IN",
                                       " (SELECT sfa03 FROM sfa_file WHERE ",
                                       "  sfa01='",g_argv2,"')"
           WHEN g_argv1='3' LET tm.wc = "ima01 IN",
                                       " (SELECT oeb04 FROM oeb_file WHERE ",
                                       "  oeb01='",g_argv2,"')"
      END CASE
      LET tm.wc2=' 1=1'
   ELSE
      CLEAR FORM #清除畫面
      CALL g_img.clear()
      CALL cl_opmsg('q')
      IF g_sw = 1 THEN
         INITIALIZE g_ima.* TO NULL  #FUN-640213 add
         CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
         IF g_flag = 0 THEN  #No.TQC-740249
            CONSTRUCT BY NAME tm.wc ON ima01,ima02,ima021
 
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
    
   
               ON ACTION CONTROLP
                  CASE
                     WHEN INFIELD(ima01)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_ima"
                        LET g_qryparam.state = 'c'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO ima01
                        NEXT FIELD ima01
                  END CASE
   
               ON ACTION qbe_select
                  CALL cl_qbe_list() RETURNING lc_qbe_sn
                  CALL cl_qbe_display_condition(lc_qbe_sn)
   
            END CONSTRUCT
         END IF #No.TQC-740249
 
         IF INT_FLAG THEN RETURN END IF
 
         CALL q102_b_askkey()
 
         IF INT_FLAG THEN RETURN END IF
      END IF
 
      IF g_sw = 2 THEN
         OPEN WINDOW q102_w2 AT 6,3 WITH FORM "aim/42f/aimq841_2"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aimq841_2")
 
         WHILE TRUE
            CONSTRUCT BY NAME g_wc3 ON sfa01
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

#-----TQC-CC0001---add----star--
            ON ACTION CONTROLP    #FUN-4B0043
               IF INFIELD(sfa01) THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_sfa6"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfa01
                  NEXT FIELD sfa01
               END IF

#-----TQC-CC0001---add----end----
 
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
            IF INT_FLAG THEN EXIT WHILE END IF
            IF g_wc3<>' 1=1' THEN EXIT WHILE END IF
         END WHILE
         CLOSE WINDOW q102_w2
         IF INT_FLAG THEN RETURN END IF
         LET tm.wc = "ima01 IN (SELECT sfa03 FROM sfa_file WHERE ",
                                       g_wc3 CLIPPED,")"
      END IF
      IF g_sw = 3 THEN
         OPEN WINDOW q102_w3 AT 6,3 WITH FORM "aim/42f/aimq841_3"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aimq841_3")
 
         WHILE TRUE
            CONSTRUCT BY NAME g_wc3 ON oeb01
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
#-----TQC-CC0001---add----star--
            ON ACTION CONTROLP    #FUN-4B0043
               IF INFIELD(oeb01) THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_oeb01"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb01
                  NEXT FIELD oeb01
               END IF

#-----TQC-CC0001---add----end----
 
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
            IF INT_FLAG THEN EXIT WHILE END IF
            IF g_wc3<>' 1=1' THEN EXIT WHILE END IF
         END WHILE
         CLOSE WINDOW q102_w3
         IF INT_FLAG THEN RETURN END IF
         LET tm.wc = "ima01 IN (SELECT oeb04 FROM oeb_file WHERE ",
                                       g_wc3 CLIPPED,")"
      END IF
      IF g_sw = 4 THEN
         OPEN WINDOW q102_w4 AT 6,3 WITH FORM "aim/42f/aimq841_4"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aimq841_4")
 
         CONSTRUCT BY NAME g_wc3 ON bmb01
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
 
 
            ON ACTION CONTROLP    #FUN-4B0043
               IF INFIELD(bmb01) THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima5"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bmb01
                  NEXT FIELD bmb01
               END IF
 
                 ON ACTION qbe_select
                  CALL cl_qbe_select()
                 ON ACTION qbe_save
               CALL cl_qbe_save()
         END CONSTRUCT
         CLOSE WINDOW q102_w4
         IF INT_FLAG THEN RETURN END IF
 
         LET tm.wc = "ima01 IN ",
                     " (SELECT bmb03 FROM bmb_file ",
                     "   WHERE ",g_wc3 CLIPPED,
                     "     AND bmb04 <= '",g_today,"'",
                     "     AND (bmb05 > '",g_today,"'",
                     "      OR bmb05 IS NULL ))"
      END IF
   END IF
   MESSAGE ' WAIT '
   IF tm.wc2=' 1=1' OR tm.wc2 IS NULL THEN
      LET g_sql=" SELECT UNIQUE '',ima02,ima021,ima01 FROM ima_file ",
                " WHERE ",tm.wc CLIPPED,
                "   AND imaacti='Y'"  #CHI-C10003 add
    ELSE
      LET g_sql=" SELECT UNIQUE '',ima02,ima021,ima01 ",
                "  FROM ima_file,img_file ",
                " WHERE ima_file.ima01=img_file.img01 AND ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
                "   AND img10<>0", #FUN-620040
                "   AND imaacti='Y'"  #CHI-C10003 add
   END IF
 
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
 
   LET g_sql = g_sql clipped," ORDER BY ima01"
   PREPARE q102_prepare FROM g_sql
   DECLARE q102_cs SCROLL CURSOR WITH HOLD FOR q102_prepare
   LET g_cnt=1
   FOREACH q102_cs INTO m_ima[g_cnt].*
     LET g_cnt=g_cnt+1 IF g_cnt>1000 THEN EXIT FOREACH END IF
   END FOREACH
   IF tm.wc2=' 1=1' THEN
      LET g_sql=" SELECT COUNT(*) FROM ima_file ",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND imaacti='Y'"  #CHI-C10003 add
    ELSE
      LET g_sql=" SELECT COUNT(DISTINCT ima01) FROM ima_file,OUTER img_file ",
                " WHERE ima_file.ima01=img_file.img01 AND ",tm.wc CLIPPED,
                "   AND imaacti='Y'"  #CHI-C10003 add
      IF NOT cl_null(tm.wc2) THEN
          LET g_sql = g_sql CLIPPED,
                      " AND ",tm.wc2 CLIPPED,
                      " AND img10<>0" #FUN-620040
      END IF
   END IF
   PREPARE q102_pp  FROM g_sql
   DECLARE q102_cnt   CURSOR FOR q102_pp
END FUNCTION
 
FUNCTION q102_b_askkey()
 
   IF g_flag = 0 THEN  #No.TQC-740249
      CONSTRUCT tm.wc2 ON img02,img03,img04,img23,img10,img18 FROM              #add by huanglf170314                          #CHI-C60036 add img03,img04,
            s_img[1].img02,s_img[1].img03,s_img[1].img04,s_img[1].img23,s_img[1].img10,s_img[1].img18  #add by huanglf170314    #CHI-C60036 add s_img[1].img03,s_img[1].img04,
                  #No.FUN-580031 --start--     HCN
                  BEFORE CONSTRUCT
                     CALL cl_qbe_display_condition(lc_qbe_sn)
                  #No.FUN-580031 --end--       HCN
   
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
   END IF #No.TQC-740249
END FUNCTION
 
FUNCTION q102_menu()
 
   WHILE TRUE
      LET INT_FLAG=0   #MOD-5A0151
      CALL q102_bp("G")
      CASE g_action_choice
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "query"
            LET g_sw = 1
            CALL q102_q()
#@         WHEN "依工單查"
         WHEN "query_by_w_o"
            LET g_sw = 2
            CALL q102_q()
#@         WHEN "依訂單查"
         WHEN "query_by_order"
            LET g_sw = 3
            CALL q102_q()
#@         WHEN "依BOM查"
         WHEN "query_by_bom"
            LET g_sw = 4
            CALL q102_q()
#@         WHEN "期間異動"
         WHEN "period_tran"
            IF cl_chk_act_auth() THEN
             #  CALL q102_q1()                            #FUN-B80153 mark
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
            CALL q102_d('0')
         WHEN "query_lot_data"  #查詢批/序號資料
            IF l_ac > 0 THEN
               CALL q102_q_imgs()
            END IF
 #FUN-AC0074--add--begin
         WHEN "Stocks_detail"
            IF cl_chk_act_auth() THEN
               IF g_ima.sie_q>0 THEN 
                  CALL q102_detail()
               ELSE
                  CALL cl_err('','aim-050',0)
               END IF
            END IF
 #FUN-AC0074--add--end
#@       WHEN "切換資料庫"
         #--FUN-B10030--start--
        # WHEN "switch_plant"
           #MOD-A80066---modify---start---
           #LET g_plant_t = g_plant  #No.TQC-740249
           #LET g_curs_index_t = 1
           #LET g_curs_index_t = g_curs_index   #No.TQC-750041
           #CALL cl_cmdrun_wait('aoos901 continue')    #No.TQC-6A0036
           #CALL g_img.clear()
           #CALL g_bbb1.clear()
           #CALL g_bbb2.clear()
           #CALL g_bbb3.clear()
           #CALL g_bbb4.clear()
           #CALL g_bbb5.clear()
           #IF (NOT cl_user()) THEN
           #   EXIT PROGRAM
           #END IF
           #IF NOT cl_setup("AIM") THEN
           #   EXIT PROGRAM
           #END IF
           #LET g_refresh = 'Y'
 
           #EXIT WHILE
           # CALL q102_sp()
           #--FUN-B10030--end-- 
           #MOD-A80066---modify---end---
         WHEN "du_detail"
            LET g_cmd = "aimq410 '",g_ima.ima01,"'"
            CALL cl_cmdrun(g_cmd CLIPPED)
         WHEN "1"
            CALL q102_d('1')
         WHEN "2"
            CALL q102_d('2')
         WHEN "3"
            CALL q102_d('3')
         WHEN "4"
            CALL q102_d('4')
         WHEN "5"
            CALL q102_d('5')
         WHEN "6"
            CALL q102_d('6')
         WHEN "7"
            CALL q102_d('7')
         WHEN "8"
            CALL q102_d('8')
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_img),'','')
            END IF
       END CASE
    END WHILE
END FUNCTION
 
 
FUNCTION q102_F1()
   DEFINE p_key            LIKE ima_file.ima01  #No.FUN-690026 VARCHAR(20)
   LET p_key=q102_F1_p()
 
    SELECT ima01, ima02, ima021, ima25, ima05, ima06,
#          ima08, ima37, ima70,  ima15, ima906,img907,ima261,ima262   #FUN-5C0086
           ima08, ima37, ima70,  ima15, ima906,img907,0,0
           INTO g_ima.*
           FROM ima_file WHERE ima01=p_key
   CALL q102_show()
END FUNCTION
 
FUNCTION q102_F1_p()
   DEFINE l_n,l_ac,l_sl      LIKE type_file.num5    #No.FUN-690026 SMALLINT
   DEFINE p_key            LIKE ima_file.ima01    #No.FUN-690026 VARCHAR(20)
 
   IF cl_null(g_argv1) THEN
      CALL cl_init_qry_var()
      LET g_qryparam.form ="q_ima"
      LET g_qryparam.default1 = " "
      CALL cl_create_qry() RETURNING p_key
   END IF
   OPEN WINDOW q102_F1_w AT 3,2
     WITH FORM "aim/42f/aimq102f"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aimq102f")
 
   CALL SET_COUNT(1000)
 
   INPUT ARRAY m_ima WITHOUT DEFAULTS FROM s_ima.*
 
          BEFORE INPUT
             CALL fgl_set_arr_curr(l_ac)
 
          BEFORE ROW
             LET l_ac = ARR_CURR()
 
          ON ACTION accept
             LET l_ac = ARR_CURR()
             LET p_key=m_ima[l_ac].ima01
           EXIT INPUT
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
   CLOSE WINDOW q102_F1_w
   IF INT_FLAG THEN LET INT_FLAG = 0 END IF
   RETURN p_key
END FUNCTION
 
FUNCTION q102_q()
 DEFINE l_null   LIKE type_file.chr1  #No.TQC-750041  
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q102_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q102_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q102_cnt
       FETCH q102_cnt INTO g_row_count
       DISPLAY g_row_count TO cnt
       IF g_flag = 1 THEN 
          LET g_jump = g_curs_index_t
          CALL q102_fetch('/')
       ELSE
        CALL q102_fetch('F')                  # 讀出TEMP第一筆並顯示
      END IF     #No.TQC-750041
    END IF
      MESSAGE ''
END FUNCTION
 
FUNCTION q102_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,   #處理方式  #No.FUN-690026 VARCHAR(1)
    l_null          LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE   l_n1       LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
DEFINE   l_n2       LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
DEFINE   l_n3       LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044  
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q102_cs INTO l_null,g_ima.ima02,g_ima.ima021,g_ima.ima01
        WHEN 'P' FETCH PREVIOUS q102_cs INTO l_null,g_ima.ima02,g_ima.ima021,g_ima.ima01
        WHEN 'F' FETCH FIRST    q102_cs INTO l_null,g_ima.ima02,g_ima.ima021,g_ima.ima01
        WHEN 'L' FETCH LAST     q102_cs INTO l_null,g_ima.ima02,g_ima.ima021,g_ima.ima01
        WHEN '/'
            IF (NOT g_no_ask) AND g_flag = 0 THEN
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
            FETCH ABSOLUTE g_jump q102_cs INTO l_null,g_ima.ima02,g_ima.ima021,g_ima.ima01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL  #No:8405
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
    SELECT ima01, ima02, ima021, ima25, ima05, ima06,
#          ima08, ima37, ima70, ima15, ima906,ima907,ima261,ima262   #FUN-5C0086
           ima08, ima37, ima70, ima15, ima906,ima907,0,0             #NO.FUN-A20044
           ,ima44,ima44_fac,ima45,ima46,ima881  #darcy:2023/06/26 add
      INTO g_ima.ima01,g_ima.ima02,g_ima.ima021,g_ima.ima25,g_ima.ima05,
           g_ima.ima06,g_ima.ima08,g_ima.ima37,g_ima.ima70,g_ima.ima15,
           g_ima.ima906,g_ima.ima907,   #FUN-5C0086
#          g_ima.ima261,g_ima.ima262                                 #NO.FUN-A20044 
           g_unavl_stk,g_avl_stk                                     #NO.FUN-A20044         
           ,g_ima.ima44,g_ima.ima44_fac,g_ima.ima45,g_ima.ima46,g_ima.ima881  #darcy:2023/06/26 add
        FROM ima_file
       WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"",
                    "",0)   #No.FUN-660156
        RETURN
    END IF
   #darcy:2024/08/02 add s---
   let g_sql = "select sum(img10*img21) ",
               " from ", cl_get_target_table( g_plant, 'img_file'),
               " where img01 = ? and img24 = 'Y' "
   case g_argv3 
      when '2'
      let g_sql = g_sql, " and img02 not in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='1')"
      when '3'
      let g_sql = g_sql, " and img02 in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='1')"
   end case
   call cl_parse_qry_sql(g_sql,g_plant) returning g_sql
   prepare avl_stk_mpsmrp_pre from g_sql
   execute avl_stk_mpsmrp_pre into l_n3  using g_ima.ima01       
   if cl_null(l_n3) then
      let l_n3 = 0
   end if
   let g_sql = "select sum(img10*img21) ",
               " from ", cl_get_target_table( g_plant, 'img_file'),
               " where img01 = ? and img23 = 'N'  "
   case g_argv3 
      when '2'
      let g_sql = g_sql, " and img02 not in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='1')"
      when '3'
      let g_sql = g_sql, " and img02 in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='1')"
   end case
   call cl_parse_qry_sql(g_sql,g_plant) returning g_sql
   prepare unavl_stk_pre from g_sql
   execute unavl_stk_pre into l_n2  using g_ima.ima01
   if cl_null(l_n2) then
      let l_n2 = 0
   end if
   #CALL s_getstock(g_ima.ima01,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
   #darcy:2024/08/02 add e---
    LET g_unavl_stk = l_n2                                  #NO.FUN-A20044
    LET g_avl_stk = l_n3                                    #NO.FUN-A20044  
    #darcy:2023/06/20 add s---
    let g_ima.avl_stk = g_avl_stk
    let g_ima.unavl_stk = g_unavl_stk
    #darcy:2023/06/20 add e---
    CALL q102_show()
END FUNCTION
 
FUNCTION q102_show()
   DISPLAY BY NAME
           g_ima.ima01, g_ima.ima02, g_ima.ima021,
           g_ima.ima25, g_ima.ima05, g_ima.ima06,
           g_ima.ima08, g_ima.ima37, g_ima.ima70, g_ima.ima15,
           g_ima.ima906,g_ima.ima907    #FUN-5C0086
#          g_ima.ima261,g_ima.ima262    #NO.FUN-A20044
           ,g_ima.ima44,g_ima.ima44_fac,g_ima.ima45,g_ima.ima46,g_ima.ima881  #darcy:2023/06/26 add
   DISPLAY g_unavl_stk to FORMONLY.unavl_stk      #NO.FUN-A20044    
   DISPLAY g_avl_stk to FORMONLY.avl_stk          #NO.FUN-A20044    
   #darcy:2024/09/20 add s---
   if g_argv3 = "2" then
      let g_argv3 = "3"
      initialize g_ima_ap.* to null
      call q102_get_g_ima(g_ima.ima01) returning g_ima_ap.*
      display g_ima_ap.avl_stk          to avl_stk1
      display g_ima_ap.img_q            to img_q1
      display g_ima_ap.oeb_q            to oeb_q1
      display g_ima_ap.sfa_q1           to sfa_q3
      display g_ima_ap.sfe_c            to sfe_c1
      display g_ima_ap.sfa_q2           to sfa_q4
      display g_ima_ap.sfa_xiaban       to sfa_xiaban1
      display g_ima_ap.sfa_liuzhi       to sfa_liuzhi1
      display g_ima_ap.pml_q            to pml_q1
      display g_ima_ap.pmn_q            to pmn_q1
      display g_ima_ap.sfb_q1           to sfb_q3
      display g_ima_ap.sfb_q2           to sfb_q4
      display g_ima_ap.rvb_q2           to rvb_q1
      display g_ima_ap.rvb_q            to rvb_q3
      display g_ima_ap.qcf_q            to qcf_q1
      display g_ima_ap.ima27            to ima1
      display g_ima_ap.rpc13            to rpc1
      display g_ima_ap.atp_qty          to atp_qty1
      display g_ima_ap.unavl_stk        to unavl_stk1
      display g_ima_ap.sie_q            to sie_q1
      let g_argv3 = "2"
   end if
   #darcy:2024/09/20 add e---
   #darcy:2023/06/20 add s---
   # let g_ima.avl_stk = g_avl_stk
   # let g_ima.unavl_stk = g_unavl_stk
   #darcy:2023/06/20 add e---
   #darcy:2024/09/23 add s---
   call saimq102_get_stk()
   #darcy:2024/09/23 add e---
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       DISPLAY '!','!' TO ima70,ima15
   END IF
   CALL q102_b_fill() #單身
   CALL q102_show2()
   MESSAGE ''
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q102_show2()
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
   #darcy:2024/07/25 mod s---
   #SELECT SUM((oeb12-oeb24+oeb25-oeb26)*oeb05_fac) INTO g_ima.oeb_q   #FUN-570017 modify oeb12-oeb24 => oeb12-oeb24+oeb25-oeb26 
   #       FROM oeb_file, oea_file
   #       WHERE oeb04 = g_ima.ima01 AND oeb01 = oea01 AND oea00<>'0'  #
   #         AND oeb70 = 'N' 
   #         AND oeb12-oeb24+oeb25-oeb26>0   #AND oeb12 > oeb24   #FUN-570017 modify 
   #         AND oeaconf = 'Y'   #TQC-7C0069 add
   let l_sql = "SELECT SUM((oeb12-oeb24+oeb25-oeb26)*oeb05_fac)  ",
               " FROM oeb_file, oea_file ",
               " WHERE oeb04 = '",g_ima.ima01,"' AND oeb01 = oea01 AND oea00<>'0' ",
               "  AND oeb70 = 'N' ",
               "  AND oeb12-oeb24+oeb25-oeb26>0 ",
               "  AND oeaconf = 'Y'"
   case g_argv3
      when '2'
         let l_sql = l_sql , " and substr(oeb01,1,3) not in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='6' )"
      when '3'
         let l_sql = l_sql , " and substr(oeb01,1,3)  in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='6' )"
   end case
   prepare saimq102_p1 from l_sql
   execute saimq102_p1 into g_ima.oeb_q
   #darcy:2024/07/25 mod e---
   DISPLAY BY NAME g_ima.oeb_q
 
   #-->工單備料量 & 工單缺料量
   MESSAGE " (2)Wait..."
   LET g_ima.sfa_q1 = 0          #TQC-A40009 
   LET g_ima.sfa_q2=0            #MOD-B50011
   let g_ima.sfa_xiaban = 0  #darcy:2022/05/30
   let g_ima.sfa_liuzhi = 0  #darcy:2022/05/30
   let g_ima.ima27 = 0 #darcy:2023/04/03 add
   let g_ima.rpc13 = 0 #darcy:2023/06/15
   
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
   #darcy:2024/07/25 add s---
   case g_argv3
      when "2"
         let l_sql = l_sql , " and substr(sfb01,1,3) not in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='5' )"
      when "3"
         let l_sql = l_sql , " and substr(sfb01,1,3) in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='5' )"
   end case
   #darcy:2024/07/25 add e---
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
   if g_argv3 = "3" then let g_ima.ima27 = 0 end if #darcy:2024/09/23 add
   #darcy:2023/06/15 add s---
   #darcy:2024/08/05 add s---
   #select sum(rpc13-nvl(rpc131,0)) into g_ima.rpc13 from rpc_file 
   # where rpc01 = g_ima.ima01 --and rpc02 like 'XRO%'
   #   and rpc18='Y' and rpc19='N' #只计算MRO料件
   let l_sql = " select sum(rpc13-nvl(rpc131,0))   from rpc_file ",
               "  where rpc01 = '",g_ima.ima01,"'",
               "    and rpc18='Y' and rpc19='N'" 
   case g_argv3
      when '2'
         let l_sql = l_sql , "  and ta_rpc06 ='1'  "
      when '3'
         let l_sql = l_sql , "  and ta_rpc06 ='2'  "
   end case
   prepare q102_rpc_rpc13 from l_sql
   execute q102_rpc_rpc13 into g_ima.rpc13
   #darcy:2024/08/05 add e---
   #darcy:2023/06/15 add e---
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
   display by name g_ima.rpc13 #darcy:2023/06/15 add
   #-->請購量
   MESSAGE " (3)Wait..."
   #darcy:2024/07/25 mod s---
   # SELECT SUM((pml20-pml21)*pml09) INTO g_ima.pml_q
   #       FROM pml_file, pmk_file
   #      WHERE pml04 = g_ima.ima01 AND pml01 = pmk01
   #        AND pml20 > pml21
   #        AND ( pml16 <='2' OR pml16='S' OR pml16='R' OR pml16='W')
   #        AND pml011 !='SUB'
   #        AND pmk18 != 'X'
   let l_sql = "SELECT SUM((pml20-pml21)*pml09)  ",
               " FROM pml_file, pmk_file ",
               "WHERE pml04 = '",g_ima.ima01,"' AND pml01 = pmk01 ",
               "  AND pml20 > pml21 ",
               "  AND ( pml16 <='2' OR pml16='S' OR pml16='R' OR pml16='W') ",
               "  AND pml011 !='SUB' ",
               "  AND pmk18 != 'X' "
   case g_argv3
      when '2'
         let l_sql = l_sql , " and substr(pml01,1,3) not in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='2' )"
      when '3'
         let l_sql = l_sql , " and substr(pml01,1,3) in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='2' )"
   end case
   prepare saimq102_p2 from l_sql
   execute saimq102_p2 into g_ima.pml_q
   #darcy:2024/07/25 mod e---
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
   #darcy:2024/07/25 mod s---
   # SELECT SUM((pmn20-pmn50+pmn55+pmn58)*pmn09) INTO g_ima.pmn_q       #NO:2897  #No.FUN-940083
   #       FROM pmn_file, pmm_file
   #      WHERE pmn04 = g_ima.ima01 AND pmn01 = pmm01
   #        AND pmn20 > pmn50-pmn55-pmn58   #No.FUN-9A0068 
   #        AND ( pmn16 <='2' OR pmn16='S' OR pmn16='R' OR pmn16='W')
   #        AND pmn011 !='SUB'
   #        AND pmm18 != 'X'
   let l_sql = "  SELECT SUM((pmn20-pmn50+pmn55+pmn58)*pmn09)  ",
               "    FROM pmn_file, pmm_file",
               " WHERE pmn04 = '",g_ima.ima01,"' AND pmn01 = pmm01",
               "    AND pmn20 > pmn50-pmn55-pmn58 ",
               "    AND ( pmn16 <='2' OR pmn16='S' OR pmn16='R' OR pmn16='W')",
               "    AND pmn011 !='SUB'",
               "    AND pmm18 != 'X'"
   case g_argv3
      when '2'
         let l_sql = l_sql , " and substr(pmn01,1,3) not in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='3' )"
      when '3'
         let l_sql = l_sql , " and substr(pmn01,1,3)  in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='3' )"
   end case
   prepare saimq102_p3 from l_sql
   execute saimq102_p3 into g_ima.pmn_q
   #darcy:2024/07/25 mod e---
 
   IF cl_null(g_ima.pmn_q) THEN LET g_ima.pmn_q=0 END IF
   IF g_ima.pmn_q=0 THEN LET g_ima.pmn_q=NULL END IF
   DISPLAY BY NAME g_ima.pmn_q
 
   #-->工單在製量
   MESSAGE " (5)Wait..."
   #darcy:2024/07/25 mod s---
   # SELECT SUM((sfb08-sfb09-sfb10-sfb11-sfb12)*ima55_fac)
   #   INTO g_ima.sfb_q1
   #   FROM sfb_file,ima_file
   #  WHERE sfb05=ima01 AND sfb05 = g_ima.ima01 AND sfb04 <'8'
   #    AND ( sfb02 !='7' AND sfb02 !='8' AND sfb02 !='11' AND sfb02 != '15' )   #FUN-5B0114   #MOD-840041 
   #    AND sfb08 > (sfb09+sfb10+sfb11+sfb12) AND sfb87!='X' #FUN-5C0046
       #CHI-B40039---add---start---
   let l_sql = "SELECT SUM((sfb08-sfb09-sfb10-sfb11-sfb12)*ima55_fac) ",
               " FROM sfb_file,ima_file",
               "WHERE sfb05=ima01 AND sfb05 = '",g_ima.ima01,"' AND sfb04 <'8'",
               "  AND ( sfb02 !='7' AND sfb02 !='8' AND sfb02 !='11' AND sfb02 != '15' ) ",
               "  AND sfb08 > (sfb09+sfb10+sfb11+sfb12) AND sfb87!='X' "
   case g_argv3
      when "2"
         let l_sql = l_sql , " and substr(sfb01,1,3) not in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='5' )"
      when "3"
         let l_sql = l_sql , " and substr(sfb01,1,3) in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='5' )"
   end case
   prepare saimq102_p4 from l_sql
   execute saimq102_p4 into g_ima.sfb_q1
   #darcy:2024/07/25 mod e---
   LET l_shb114 = 0
   #darcy:2024/07/25 mod s---
   # SELECT SUM(shb114) INTO l_shb114
   #   FROM shb_file,sfb_file
   #  WHERE shb10 = g_ima.ima01
   #    AND shb05 = sfb01
   #    AND shb10 = sfb05
   #    AND sfb04 < '8' AND sfb87 != 'X'
   #    AND ( sfb02 !='7' AND sfb02 !='8' AND sfb02 !='11' AND sfb02 != '15' )
   let l_sql = "SELECT SUM(shb114)  ",
               "  FROM shb_file,sfb_file ",
               " WHERE shb10 = '",g_ima.ima01,"' ",
               "   AND shb05 = sfb01 ",
               "   AND shb10 = sfb05 ",
               "   AND sfb04 < '8' AND sfb87 != 'X' ",
               "   AND ( sfb02 !='7' AND sfb02 !='8' AND sfb02 !='11' AND sfb02 != '15' )  "
   case g_argv3
      when '2'
         let l_sql = l_sql , " and substr(shb05,1,3) not in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='5' )"
      when '3'
         let l_sql = l_sql , " and substr(shb05,1,3)  in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='5' )"
   end case
   prepare saimq102_p5 from l_sql
   execute saimq102_p5 into l_shb114
   #darcy:2024/07/25 mod e---
   IF cl_null(l_shb114) THEN LET l_shb114 = 0 END IF
   LET g_ima.sfb_q1 = g_ima.sfb_q1 - l_shb114
  #CHI-B40039---add---end---
   DISPLAY BY NAME g_ima.sfb_q1
 
   #-->委外在製量
   #darcy:2024/07/25 mod s---
   # SELECT SUM((sfb08-sfb09-sfb10-sfb11-sfb12)*ima55_fac)
   #   INTO g_ima.sfb_q2
   #   FROM sfb_file,ima_file
   #  WHERE sfb05=ima01 AND sfb05 = g_ima.ima01 AND sfb04 <'8'
   #    AND (sfb02='7' OR sfb02='8')   #FUN-5B0114
   #    AND sfb08 > (sfb09+sfb10+sfb11+sfb12) AND sfb87!='X'
   let l_sql = "SELECT SUM((sfb08-sfb09-sfb10-sfb11-sfb12)*ima55_fac)",
               "  FROM sfb_file,ima_file",
               " WHERE sfb05=ima01 AND sfb05 = '",g_ima.ima01,"' AND sfb04 <'8'",
               "   AND (sfb02='7' OR sfb02='8') ",
               "   AND sfb08 > (sfb09+sfb10+sfb11+sfb12) AND sfb87!='X'"
   case g_argv3
      when "2"
         let l_sql = l_sql , " and substr(sfb01,1,3) not in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='5' )"
      when "3"
         let l_sql = l_sql , " and substr(sfb01,1,3) in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='5' )"
   end case
   prepare saimq102_p6 from l_sql
   execute saimq102_p6 into g_ima.sfb_q2
   #darcy:2024/07/25 mod e---
   IF cl_null(g_ima.sfb_q2) THEN LET g_ima.sfb_q2=0 END IF     #No.MOD-730057 modify
 #CHI-B40039---add---start---
   LET l_shb114 = 0 
   #darcy:2024/07/25 add s---
   # SELECT SUM(shb114) INTO l_shb114 
   #   FROM shb_file,sfb_file
   #  WHERE shb10 = g_ima.ima01
   #    AND shb05 = sfb01
   #    AND shb10 = sfb05
   #    AND sfb04 < '8' AND sfb87 != 'X'
   #    AND ( sfb02 ='7' AND sfb02 ='8') 
   let l_sql = " SELECT SUM(shb114)  ",
               " FROM shb_file,sfb_file",
               " WHERE shb10 = '",g_ima.ima01,"'",
               "    AND shb05 = sfb01",
               "    AND shb10 = sfb05",
               "    AND sfb04 < '8' AND sfb87 != 'X'",
               "    AND ( sfb02 ='7' AND sfb02 ='8') "
   case g_argv3
      when '2'
         let l_sql = l_sql , " and substr(shb05,1,3) not in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='5' )"
      when '3'
         let l_sql = l_sql , " and substr(shb05,1,3)  in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='5' )"
   end case
   prepare saimq102_p7 from l_sql
   execute saimq102_p7 into l_shb114 
   #darcy:2024/07/25 add e---
   IF cl_null(l_shb114) THEN LET l_shb114 = 0 END IF
   LET g_ima.sfb_q2 = g_ima.sfb_q2 - l_shb114
  #CHI-B40039---add---end---
   DISPLAY BY NAME g_ima.sfb_q2
 
   #-->委外IQC在製量
   #darcy:2024/07/25 mod s---
#    SELECT SUM((rvb07-rvb29-rvb30)*pmn09) INTO g_ima.rvb_q2   #MOD-A70029  #MOD-AA0075 取消mark
#   #SELECT SUM(rvb31*pmn09) INTO g_ima.rvb_q2   #MOD-A70029    #MOD-AA0075 mark
#      FROM rvb_file, rva_file, pmn_file
#     WHERE rvb05 = g_ima.ima01 AND rvb01=rva01
#       AND rvb04 = pmn01 AND rvb03 = pmn02
#       AND rvb07 > (rvb29+rvb30)   #MOD-A70029  #MOD-AA0075 取消mark
#      #AND rvb31 > 0   #MOD-A70029    #MOD-AA0075 mark
#       AND rvaconf='Y'  #No.BANN
#       AND rva10 ='SUB' #MODNO:6634 #No:9039
#       AND pmn43 = 0    #MOD-580174 add
   let l_sql = " SELECT SUM((rvb07-rvb29-rvb30)*pmn09) ",
               "  FROM rvb_file, rva_file, pmn_file",
               " WHERE rvb05 = '",g_ima.ima01,"' AND rvb01=rva01",
               "   AND rvb04 = pmn01 AND rvb03 = pmn02",
               "   AND rvb07 > (rvb29+rvb30)  ",
               "   AND rvaconf='Y' ",
               "   AND rva10 ='SUB'",
               "   AND pmn43 = 0   " 
   case g_argv3
      when '2'
         let l_sql = l_sql , " and substr(pmn01,1,3) not in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='3' )"
      when '3'
         let l_sql = l_sql , " and substr(pmn01,1,3)  in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='3' )"
   end case
   prepare saimq102_p8 from l_sql
   execute saimq102_p8 into g_ima.rvb_q2 
   #darcy:2024/07/25 mod e---
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
   #darcy:2024/07/25 mod s---
#    SELECT SUM((rvb07-rvb29-rvb30)*pmn09) INTO g_ima.rvb_q   #MOD-A70029   #MOD-AA0075 取消mark
#   #SELECT SUM(rvb31*pmn09) INTO g_ima.rvb_q   #MOD-A70029   #MOD-AA0075 mark
#          FROM rvb_file, rva_file, pmn_file
#         WHERE rvb05 = g_ima.ima01 AND rvb01=rva01
#           AND rvb04 = pmn01 AND rvb03 = pmn02
#           AND rvb07 > (rvb29+rvb30)   #MOD-A70029  #MOD-AA0075 取消mark
#          #AND rvb31 > 0   #MOD-A70029   #MOD-AA0075 mark
#           AND rvaconf='Y' #No.BANN
#           AND rva10 != 'SUB'  #BugNo:6634 #No:9039
   let l_sql = "SELECT SUM((rvb07-rvb29-rvb30)*pmn09)  ",
               "  FROM rvb_file, rva_file, pmn_file",
               " WHERE rvb05 = '",g_ima.ima01,"' AND rvb01=rva01",
               "   AND rvb04 = pmn01 AND rvb03 = pmn02",
               "   AND rvb07 > (rvb29+rvb30) ",
               "   AND rvaconf='Y' ",
               "   AND rva10 != 'SUB' "
   case g_argv3
      when '2'
         let l_sql = l_sql , " and substr(pmn01,1,3) not in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='3' )"
      when '3'
         let l_sql = l_sql , " and substr(pmn01,1,3)  in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='3' )"
   end case
   prepare saimq102_p9 from l_sql
   execute saimq102_p9 into g_ima.rvb_q
   #darcy:2024/07/25 mod e---
   DISPLAY BY NAME g_ima.rvb_q
 
   #-->FQC 在驗量
   MESSAGE " (7)Wait..."
  #MOD-A90098 mod --start--
  #SELECT SUM(sfb11) INTO g_ima.qcf_q
  #  FROM sfb_file
  # WHERE sfb05 = g_ima.ima01
   #darcy:2024/07/25 mod s---
#    SELECT SUM(sfb11*ima55_fac) INTO g_ima.qcf_q
#      FROM sfb_file,ima_file
#     WHERE sfb05=ima01 AND sfb05 = g_ima.ima01
#   #MOD-A90098 mod --end--
#       AND sfb02 <> '7' AND sfb87!='X'
#       AND sfb02 <> '8'   #FUN-5B0069
#       AND sfb02 <> '11'    #MOD-AA0069 add
#       AND sfb04 <'8'  #plum   #No.MOD-C10177
#      #AND sfb04 <'7'  #plum   #Mod MOD-AC0061   #No.MOD-C10177
   let l_sql = " SELECT SUM(sfb11*ima55_fac) ",
               "  FROM sfb_file,ima_file",
               " WHERE sfb05=ima01 AND sfb05 = '",g_ima.ima01,"'",
               "   AND sfb02 <> '7' AND sfb87!='X'",
               "   AND sfb02 <> '8' ",
               "   AND sfb02 <> '11'",
               "   AND sfb04 <'8'"
   case g_argv3
      when '2'
         let l_sql = l_sql , " and substr(sfb01,1,3) not in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='5' )"
      when '3'
         let l_sql = l_sql , " and substr(sfb01,1,3)  in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='5' )"
   end case
   prepare saimq102_p10 from l_sql
   execute saimq102_p10 into g_ima.qcf_q
   #darcy:2024/07/25 mod e---
   IF SQLCA.sqlcode OR STATUS THEN LET g_ima.qcf_q = '' END IF
   IF g_ima.qcf_q = 0 THEN LET g_ima.qcf_q = '' END IF
   DISPLAY BY NAME g_ima.qcf_q

  #-->超领未扣帐数量
  MESSAGE " (8)Wait..." 
  
   #darcy:2023/06/16 add s---
   # 杂发，超领已审核未过账使用 改回产生独立需求单据
  #mark by sunyan 210407---s  谢宇彬要求改为杂项未扣账数量
  #SELECT SUM(sfs05*ima63_fac) INTO l_a1
  #darcy:2024/07/25 mod s---
#   SELECT NVL(SUM(sfs05*ima63_fac),0) INTO l_a1  #add by zhangzs 210823
#      FROM sfs_file,ima_file,sfp_file
#     WHERE sfs04=ima01 AND sfs01=sfp01
#       AND sfs04 = g_ima.ima01 
#       AND sfp06 = '2' AND sfpconf!='X'
#       AND sfp04 <> 'Y'   #FUN-5B0069
   let l_sql = " SELECT NVL(SUM(sfs05*ima63_fac),0) ",
               "  FROM sfs_file,ima_file,sfp_file",
               " WHERE sfs04=ima01 AND sfs01=sfp01",
               "   AND sfs04 = '",g_ima.ima01,"' ",
               "   AND sfp06 = '2' AND sfpconf!='X'",
               "   AND sfp04 <> 'Y' "
   case g_argv3
      when '2'
         let l_sql = l_sql , " and substr(sfs03,1,3) not in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='5' )"
      when '3'
         let l_sql = l_sql , " and substr(sfs03,1,3)  in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='5' )"
   end case
   prepare saimq102_p11 from l_sql
   execute saimq102_p11 into l_a1
  #darcy:2024/07/25 mod e---
  #Mark by sunyan 210407---e
  #add by sunyan 210407---s
 # SELECT SUM(inb09*inb08_fac) INTO l_a2
   #darcy:2024/07/25 mod s---
   # SELECT NVL(SUM(inb09*inb08_fac),0) INTO l_a2  #add by zhangzs 210823
   #  FROM ina_file,inb_file
   # WHERE ina01 = inb01
   #    AND inb04=g_ima.ima01
   #    AND inaconf = 'Y' 
   #    AND inapost = 'N'
   #    AND ina00 in ('1','2')
   let l_sql = " SELECT NVL(SUM(inb09*inb08_fac),0) ",
               " FROM ina_file,inb_file",
               " WHERE ina01 = inb01",
               "  AND inb04='",g_ima.ima01,"'",
               "  AND inaconf = 'Y' ",
               "  AND inapost = 'N'",
               "  AND ina00 in ('1','2')"
   case g_argv3
      when '2'
         let l_sql = l_sql , " and substr(inb05,1,3) not in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='1' )"
      when '3'
         let l_sql = l_sql , " and substr(inb05,1,3)  in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='1' )"
   end case
   prepare saimq102_p12 from l_sql
   execute saimq102_p12 into l_a2
   #darcy:2024/07/25 mod e---
   # LET l_all = l_a1 + l_a2
   LET g_ima.sfe_c = l_a1 + l_a2  #add by zhangzs 210823
  #add by sunyan 210407---e
   IF SQLCA.sqlcode OR STATUS THEN LET g_ima.sfe_c = 0 END IF
   IF cl_null(g_ima.sfe_c) THEN LET g_ima.sfe_c = 0 END IF
   #  let g_ima.sfe_c = 0
   #darcy:2023/06/16 add e---
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
   if g_ima.rpc13 is null then let g_ima.rpc13 = 0 end if #darcy:2023/06/15 add
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
                                  - g_ima.rpc13  #darcy:2023/06/15 add
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
   DISPLAY By NAME g_ima.atp_qty
END FUNCTION
 
FUNCTION q102_b_fill()              #BODY FILL UP
   DEFINE l_sql          LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
   DEFINE l_img10        LIKE img_file.img10   #add by huanglf170314
   IF tm.wc2 IS NULL OR tm.wc2=' ' THEN LET tm.wc2=" 1=1" END IF

   LET l_img10 = 0 #add by huanglf170314
   LET g_ima.img_q = 0 #add by huanglf170314
   LET l_sql =
        "SELECT img02,'',img03,'',img04,img23,img10,img18,'',img09,img38", #img18 add by huanglf170314 #No.FUN-850153 #CHI-A40004 add img38#FUN-AC0074
        " FROM  img_file",
        " WHERE img01 = '",g_ima.ima01,"'",
        "   AND img10<>0",
        "   AND ",tm.wc2 #FUN-620040
   #darcy:2024/07/25 mod s---
   # " ORDER BY img02,img03,img04"
   #darcy:2024/09/23 mark s---
   # case g_argv3 
   #    when '2'
   #    let l_sql = l_sql, " and img02 not in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='1')"
   #    when '3'
   #    let l_sql = l_sql, " and img02 in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='1')"
   # end case
   #darcy:2024/09/23 mark e---
   let l_sql = l_sql ," ORDER BY img02,img03,img04"
   #darcy:2024/07/25 mod e---
    PREPARE q102_pb FROM l_sql
    DECLARE q102_bcs CURSOR FOR q102_pb
 
    CALL g_img.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q102_bcs INTO g_img[g_cnt].*
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
                "  WHERE imgs01 = '",g_ima.ima01,"' "
   #darcy:2024/07/25 mod s---
   #"  ORDER BY imgs02,imgs03,imgs04 "
   # darcy:2024/09/23 mark s---
   # case g_argv3 
   #    when '2'
   #    let l_sql = l_sql, " and imgs02 not in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='1')"
   #    when '3'
   #    let l_sql = l_sql, " and imgs02 in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='1')"
   # end case
   # darcy:2024/09/23 mark e---
   let l_sql = l_sql ,"  ORDER BY imgs02,imgs03,imgs04 "

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
    #FUN-B80137 add -end--------------------------       
END FUNCTION
 
 
FUNCTION q102_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DIALOG ATTRIBUTES(UNBUFFERED)     #FUN-B80137 add
    #DISPLAY ARRAY g_img TO s_img.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #No.MOD-590279 add attribute #NO:FUN-B80137 mark
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
 
      ON ACTION first
         CALL q102_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           #ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST #FUN-B80137 mark
           ACCEPT DIALOG    #FUN-B80137 add
 
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
 
      ON ACTION previous
         CALL q102_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
      #ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST #FUN-B80137 mark
      ACCEPT DIALOG    #FUN-B80137 add
 
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
 
      ON ACTION jump
         CALL q102_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
      #ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST #FUN-B80137 mark
      ACCEPT DIALOG    #FUN-B80137 add
 
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
 
      ON ACTION next
         CALL q102_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
      #ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST #FUN-B80137 mark
      ACCEPT DIALOG    #FUN-B80137 add
 
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
 
      ON ACTION last
         CALL q102_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
      #ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST #FUN-B80137 mark
      ACCEPT DIALOG    #FUN-B80137 add
 
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
 
      ON ACTION help
         LET g_action_choice="help"
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL q102_mu_ui()   #TQC-710032
 
      ON ACTION exit
         LET g_action_choice="exit"
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
 
#@      ON ACTION 查詢
      ON ACTION query
         LET g_action_choice="query"
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
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
      ON ACTION accept
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
 
      ON ACTION cancel
         LET INT_FLAG=FALSE             #MOD-570244      mars
         LET g_action_choice="exit"
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         #EXIT DISPLAY #FUN-B80137 mark
         EXIT DIALOG    #FUN-B80137 add
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         #CONTINUE DISPLAY #FUN-B80137 mark
         CONTINUE DIALOG    #FUN-B80137 add
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
     #FUN-B80137 mark begin-----------
     # AFTER DISPLAY
     #    CONTINUE DISPLAY
     #FUN-B80137 mark end------------
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
   #END DISPLAY #FUN-B80137 mark
   END DIALOG      #FUN-B80137 add
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q102_d(d_no)
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
#FUN-B80153 mark start
#FUNCTION q102_q1()
#   DEFINE l_sql            LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
#   DEFINE l_exit_sw      LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
#   DEFINE l_tlf      RECORD
#              tlf01      LIKE tlf_file.tlf01,
#               tlf026      LIKE tlf_file.tlf026,
#               tlf036      LIKE tlf_file.tlf036,
#               tlf06      LIKE tlf_file.tlf06,
#               tlf10      LIKE tlf_file.tlf10,
#               tlf11      LIKE tlf_file.tlf11,
#               tlf13      LIKE tlf_file.tlf13,
#               tlf19      LIKE tlf_file.tlf19,
#               tlf901      LIKE tlf_file.tlf901,
#               tlf902      LIKE tlf_file.tlf902,
#               tlf903      LIKE tlf_file.tlf903,
#               tlf904      LIKE tlf_file.tlf904,
#               tlf905      LIKE tlf_file.tlf905,
#               tlf907      LIKE tlf_file.tlf907
#               END RECORD
# 
#   LET p_row = 6 LET p_col = 2
#   OPEN WINDOW q102_q1_w AT p_row,p_col
#     WITH FORM "aim/42f/aimq10211"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
# 
#   CALL cl_ui_locale("aimq10211")
# 
#      CALL g_bbb1.clear()
#      CALL q102_q1_wc()
# 
# WHILE TRUE #MOD-4C0031 add while
#    LET l_exit_sw = 'N' #MOD-4C0031
#  IF INT_FLAG THEN      #MOD-4C0031 add if 判斷
#    LET INT_FLAG = 0    #MOD-4C0031
# ELSE
#   LET l_sql= "SELECT tlf01,tlf026,tlf036,tlf06,tlf10,tlf11,tlf13,tlf19,",
#               "       tlf901,tlf902,tlf903,tlf904,tlf905,tlf907",
#            "       FROM tlf_file",
#              " WHERE tlf01='",g_ima.ima01,"'",
#              "   AND (tlf02=50 OR tlf03=50)",
#              "   AND ",g_wc4 CLIPPED,
#              " ORDER BY tlf06"
#   PREPARE q102_q1_p FROM l_sql
#   DECLARE q102_q1_c CURSOR FOR q102_q1_p
# 
#   CALL g_bbb1.clear()
#   LET g_cnt=1
# 
#   FOREACH q102_q1_c INTO l_tlf.*
#      IF STATUS THEN
#         CALL cl_err('for:',STATUS,1)
#         EXIT FOREACH
#      END IF
#      LET l_tlf.tlf10 = l_tlf.tlf10 * l_tlf.tlf907
#      CALL s_command (l_tlf.tlf13) RETURNING g_chr,g_msg
# 
#      LET g_bbb1[g_cnt].tlf06 = l_tlf.tlf06
#      LET g_bbb1[g_cnt].tlf026=l_tlf.tlf026
#      LET g_bbb1[g_cnt].tlf036=l_tlf.tlf036
#      LET g_bbb1[g_cnt].msg=g_msg[1,30]   #MOD-870122
#      LET g_bbb1[g_cnt].tlf19 =l_tlf.tlf19
#      LET g_bbb1[g_cnt].tlf902=l_tlf.tlf902
#      LET g_bbb1[g_cnt].tlf903=l_tlf.tlf903
#      LET g_bbb1[g_cnt].tlf904=l_tlf.tlf904
#      LET g_bbb1[g_cnt].tlf10 =l_tlf.tlf10 USING '-----------&.&&&'
#      LET g_bbb1[g_cnt].tlf11 =l_tlf.tlf11
# 
#      LET g_cnt=g_cnt+1
#   END FOREACH
# END IF #MOD-4C0031
#   CALL cl_set_act_visible("accept,cancel", FALSE)
#   DISPLAY ARRAY g_bbb1 TO s_bbb1.*
#        ON ACTION query
#           CALL q102_q1_wc()
#           EXIT DISPLAY
#        ON ACTION exit
#           LET l_exit_sw = 'Y'
#           EXIT DISPLAY
# 
#        ON ACTION cancel
#           LET l_exit_sw = 'Y'
#           EXIT DISPLAY
# 
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE DISPLAY
# 
#        ON ACTION about
#           CALL cl_about()
# 
#        ON ACTION help
#           CALL cl_show_help()
# 
#        ON ACTION controlg
#           CALL cl_cmdask()
#      ON ACTION exporttoexcel 
#         LET w = ui.Window.getCurrent()
#         LET n = w.getNode()
#         CALL cl_export_to_excel(n,base.TypeInfo.create(g_bbb1),'','')
#   END DISPLAY
#   CALL cl_set_act_visible("accept,cancel", TRUE)
#   IF l_exit_sw = 'Y' THEN
#       EXIT WHILE
#   END IF
# END WHILE #MOD-4C0031 add while
#   CLOSE WINDOW q102_q1_w
# 
#END FUNCTION
#FUN-B80153 mark END
#FUN-AC0074--add--begin
FUNCTION q102_detail()
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
#FUN-AC0074--add--end 
#FUN-B80153 mark Start
#FUNCTION q102_q1_wc()
#   OPEN WINDOW q102_iw AT 14,20
#        WITH FORM "aim/42f/aimq102i"
#    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
# 
#    CALL cl_ui_locale("aimq102i")
#    CALL cl_set_act_visible("accept,cancel", TRUE) #MOD-4C0031
#   CONSTRUCT BY NAME g_wc4 ON tlf902,tlf06
#              BEFORE CONSTRUCT
#                 CALL cl_qbe_init()
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
#       ON ACTION exit     #MOD-4C0031
#                 ON ACTION qbe_select
#                  CALL cl_qbe_select()
#                 ON ACTION qbe_save
#               CALL cl_qbe_save()
#          EXIT CONSTRUCT  #MOD-4C0031
# 
#   END CONSTRUCT
#   CLOSE WINDOW q102_iw
#END FUNCTION
#FUN-B80153 mark END 
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
 
FUNCTION q102_mu_ui()
   CALL cl_set_comp_visible("ima906",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("group043",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("ima907",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("group044",g_sma.sma115='Y')
   IF g_sma.sma122='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ima907",g_msg CLIPPED)
   END IF
   IF g_sma.sma122='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ima907",g_msg CLIPPED)
   END IF
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
#MOD-A80066---add---start---
#--FUN-B10030--start--
#FUNCTION q102_sp()
#   DEFINE l_plant,l_dbs	LIKE type_file.chr21  
 
#            LET INT_FLAG = 0  ######add for prompt bug
#   PROMPT 'PLANT CODE:' FOR l_plant
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
 
#      ON ACTION about         
#         CALL cl_about()      
 
#      ON ACTION help          
#         CALL cl_show_help()  
 
#      ON ACTION controlg      
#         CALL cl_cmdask()     
 
 
#   END PROMPT
#   IF l_plant IS NULL THEN RETURN END IF
#   SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_plant
#   IF STATUS THEN ERROR 'WRONG database!' RETURN END IF
#   DATABASE l_dbs
#   CALL cl_ins_del_sid(1,l_plant)
#   IF STATUS THEN ERROR 'open database error!' RETURN END IF
#   LET g_plant = l_plant
#   LET g_dbs   = l_dbs
#   CALL s_chgdbs()       #MOD-B10051
#END FUNCTION
#--FUN-B10030--end--
#MOD-A80066---add---end---
#No.FUN-9C0072 精簡程式碼
 

function q102_get_g_ima(p_ima01)
   define p_ima01 like ima_file.ima01
   DEFINE   l_n1       LIKE type_file.num15_3
   DEFINE   l_n2       LIKE type_file.num15_3
   DEFINE   l_n3       LIKE type_file.num15_3

   SELECT ima01, ima02, ima021, ima25, ima05, ima06,
#          ima08, ima37, ima70, ima15, ima906,ima907,ima261,ima262   #FUN-5C0086
         ima08, ima37, ima70, ima15, ima906,ima907,0,0             #NO.FUN-A20044
   INTO g_ima.ima01,g_ima.ima02,g_ima.ima021,g_ima.ima25,g_ima.ima05,
         g_ima.ima06,g_ima.ima08,g_ima.ima37,g_ima.ima70,g_ima.ima15,
         g_ima.ima906,g_ima.ima907,   #FUN-5C0086
#          g_ima.ima261,g_ima.ima262                                 #NO.FUN-A20044 
         g_unavl_stk,g_avl_stk                                     #NO.FUN-A20044         
      FROM ima_file
      WHERE ima01 = p_ima01
      
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"",
                    "",0)   #No.FUN-660156
        RETURN
    END IF
   #darcy:2024/08/02 add s---
   let g_sql = "select sum(img10*img21) ",
               " from ", cl_get_target_table( g_plant, 'img_file'),
               " where img01 = ? and img24 = 'Y' "
   case g_argv3 
      when '2'
      let g_sql = g_sql, " and img02 not in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='1')"
      when '3'
      let g_sql = g_sql, " and img02 in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='1')"
   end case
   call cl_parse_qry_sql(g_sql,g_plant) returning g_sql
   prepare avl_stk_mpsmrp_pre1 from g_sql
   execute avl_stk_mpsmrp_pre1 into l_n3  using g_ima.ima01       
   if cl_null(l_n3) then
      let l_n3 = 0
   end if
   let g_sql = "select sum(img10*img21) ",
               " from ", cl_get_target_table( g_plant, 'img_file'),
               " where img01 = ? and img23 = 'N'  "
   case g_argv3 
      when '2'
      let g_sql = g_sql, " and img02 not in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='1')"
      when '3'
      let g_sql = g_sql, " and img02 in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='1')"
   end case
   call cl_parse_qry_sql(g_sql,g_plant) returning g_sql
   prepare unavl_stk_pre1 from g_sql
   execute unavl_stk_pre1 into l_n2  using g_ima.ima01
   if cl_null(l_n2) then
      let l_n2 = 0
   end if
   #CALL s_getstock(g_ima.ima01,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
   #darcy:2024/08/02 add e---
   call saimq102_get_stk()
   call q102_show2()

   return g_ima.*
end function


function saimq102_get_stk()
   define l_n2,l_n3  decimal(16,3)
   #darcy:2024/08/02 add s---
   let g_sql = "select sum(img10*img21) ",
               " from ", cl_get_target_table( g_plant, 'img_file'),
               " where img01 = ? and img24 = 'Y' "
   case g_argv3 
      when '2'
      let g_sql = g_sql, " and img02 not in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='1')"
      when '3'
      let g_sql = g_sql, " and img02 in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='1')"
   end case
   call cl_parse_qry_sql(g_sql,g_plant) returning g_sql
   prepare avl_stk_mpsmrp_pre2 from g_sql
   execute avl_stk_mpsmrp_pre2 into l_n3  using g_ima.ima01       
   if cl_null(l_n3) then
      let l_n3 = 0
   end if
   let g_sql = "select sum(img10*img21) ",
               " from ", cl_get_target_table( g_plant, 'img_file'),
               " where img01 = ? and img23 = 'N'  "
   case g_argv3 
      when '2'
      let g_sql = g_sql, " and img02 not in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='1')"
      when '3'
      let g_sql = g_sql, " and img02 in (select tc_sma02 from tc_sma_file where tc_sma01 ='csmi109' and tc_sma06 ='1')"
   end case
   call cl_parse_qry_sql(g_sql,g_plant) returning g_sql
   prepare unavl_stk_pre2 from g_sql
   execute unavl_stk_pre2 into l_n2  using g_ima.ima01
   if cl_null(l_n2) then
      let l_n2 = 0
   end if
   #CALL s_getstock(g_ima.ima01,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
   #darcy:2024/08/02 add e---
    LET g_unavl_stk = l_n2                                  #NO.FUN-A20044
    LET g_avl_stk = l_n3                                    #NO.FUN-A20044  
    #darcy:2023/06/20 add s---
    let g_ima.avl_stk = g_avl_stk
    let g_ima.unavl_stk = g_unavl_stk
    #darcy:2023/06/20 add e---
end function
