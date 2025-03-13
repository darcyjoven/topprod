# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aimt720.4gl
# Descriptions...: 多工廠庫存調撥作業(單階調撥)
# Date & Author..: 95/06/29 by nick
# Modify.........: 95/08/03 By Danny (加扣帳功能)
#                  By Melody    smymxno'已用編號'欄位取消
#                  By Melody    新增'是否立即列印'功能
# Modify.........: 97/07/24 By Melody CHECK sma894 是否庫存可扣至負數
# Modify.........: 97/09/04 By Roger  加上"Y:撥出確認"
#                                     原本"S:過帳" 視為 "撥入確認"
#                                     "Y"及"S" 由 cl_smuchk() 控制權限
#                                     因必須區分單別, 並非 cl_chk_act_auth()
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.MOD-490283 04/09/30 By Nicola action '預設撥入倉庫儲位', 應抓撥入工廠的資料
# Modify.........: No.MOD-4A0248 04/10/27 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0053 04/12/08 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.FUN-530065 05/03/29 By Will 增加料件的開窗
# Modify.........: No.FUN-550011 05/05/25 By kim GP2.0功能 庫存單據不同期要check庫存是否為負
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: No.FUN-560271 05/06/30 By day 單別加大
# Modify.........: No.MOD-590297 05/11/22 By Pengu 輸入單身『料件編號』應檢查撥入廠是否有此料號.並出警告訊息
# Modify.........: No.FUN-5B0125 05/12/28 By Sarah 增加多單位處理功能(ref aimt324改法)
# Modify.........: No.FUN-5C0077 05/12/22 By yoyo 單身新增欄位來表明單身料號是否需要檢驗
# Modify.........: No.FUN-610067 06/02/08 By Smapmin 雙單位畫面調整
# Modify.........: No.TQC-630052 06/03/07 By Claire 流程訊息通知傳參數
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: No.MOD-650040 06/05/09 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-650093 06/05/22 By cl 增加料件多屬性功能
# Modify.........: No.FUN-660029 06/06/13 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-660078 06/06/14 By rainy aim系統中，用char定義的變數，改為用LIKE
# Modify.........: No.TQC-660068 06/06/14 By Claire 流程訊息通知傳參數
# Modify.........: No.TQC-660100 06/06/21 By Rayven 多屬性功能改進:查詢時不顯示多屬性內容 
# Modify.........: NO.FUN-660156 06/06/23 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-660085 06/07/03 By Joe 若單身倉庫欄位已有值，則倉庫開窗查詢時，重新查詢時不會顯示該料號所有的倉儲。
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-670093 06/07/20 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680010 06/08/26 by Joe SPC整合專案-自動新增 QC 單據
# Modify.........: No.FUN-690026 06/09/14 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/10/11 By jamie 1.FUNCTION t720()_q 一開始應清空g_imm.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/10 By bnlent  單頭折疊功能修改
# Modify.........: No.FUN-710025 07/01/29 By bnlent  錯誤訊息匯整
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740249 07/04/24 By Rayven 狀態里的欄位都無法查詢
# Modify.........: NO.CHI-730005 07/06/22 BY yiting 新增取消確認/過帳還原功能
# Modify.........: No.CHI-770019 07/07/25 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: No.TQC-750014 07/08/14 By pengu 庫存轉換率異常
# Modify.........: No.TQC-780079 07/08/30 By pengu t720_check_item() 中第一個 "RETURN",應該改為 "RETURN l_success"
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-7B0018 08/03/04 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830132 08/03/28 By hellen 將imaicd_file變成icd專用
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.FUN-840194 08/06/25 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.CHI-860005 08/06/27 By xiaofeizhu 使用參考單位且參考數量為0時，也需寫入tlff_file
# Modify.........: No.MOD-8A0055 08/10/07 By claire 扣帳還原時,u_tlf()只刪除單身最後一筆項次
# Modify.........: No.MOD-8C0246 08/12/24 By chenl  調整FUN-830132錯誤。
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID
# Modify.........: No.MOD-8B0190 09/02/03 By Pengu 過帳還原的時候目的的資料庫TLF沒有刪除
# Modify.........: No.FUN-920186 09/03/18 By lala  理由碼imn28必須為庫存調撥
# Modify.........: No.TQC-930155 09/03/30 By Sunyanchun Lock img_file,imgg_file時，若報錯，不要rollback ，要放g_success ='N'
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-940178 09/05/12 By Cockroach 跨庫SQL一律改為調用s_dbstring()  
# Modify.........: No.TQC-950134 09/05/22 By Carrier rowid定義規範化
# Modify.........: No.FUN-980081 09/08/19 By destiny 修改傳到s_madd_img里的參數
# Modify.........: No.FUN-980004 09/08/25 By TSD.hoho GP5.2架構重整，修改 INSERT INTO語法
# Modify.........: No.FUN-980093 09/08/25 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.CHI-960052 09/10/15 By chenmoyan 使用多單位，料件是單一單位或參考單位時，單位一的轉換率錯誤
# Modify.........: No:FUN-870007 09/12/09 By Cockroach PASS NO.
# Modify.........: No.FUN-9C0072 10/01/15 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  過帳還原時的呆滯日期異動
# Modify.........: No.FUN-A50102 10/06/08 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现 
# Modify.........: No.TQC-A60018 10/08/04 By destiny 1.第二次新增时会把上次新增的资料带出来                             
#                                                    2.更新img_file时异动日期不应该传空
#                                                    3.拨入营运中心开窗应根据当前法人开对应的资料
# Modify.........: No.FUN-AA0059 10/10/28 By huangtao 修改料號的管控
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-AB0067 10/11/17 by destiny  增加倉庫的權限控管
# Modify.........: No.TQC-AC0044 10/12/10 by destiny  del tlf 报语法错
# Modify.........: No.FUN-A60034 11/03/08 By Mandy 因aimt324 新增EasyFlow整合功能影響INSERT INTO imm_file
# Modify.........: No:FUN-A70104 11/03/08 By Mandy [EF簽核] aimt324影響程式簽核欄位default
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.TQC-B50032 11/05/18 By destiny 审核时不存在的部门可以通过 
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B70074 11/07/20 By xianghui 添加行業別表的新增於刪除
# Modify.........: No.FUN-B80070 11/08/08 By fanbj FOR UPDATE 下一行調用cl_forupd_sql 函式
# Modify.........: No.TQC-BB0193 11/11/29 By pauline tlf/tlff加上plant條件
# Modify.........: No.FUN-BB0084 11/12/05 By lixh1 增加數量欄位小數取位
# Modify.........: No.MOD-C10126 12/01/13 By lilingyu 取消審核（過賬還原)時，tlff更新不對
# Modify.........: No.FUN-C20002 12/02/02 By fanbj 券產品的倉庫調整
# Modify.........: No.FUN-C30300 12/04/09 By bart  倉儲批開窗需顯示參考單位數量
# Modify.........: No:MOD-C50027 12/05/07 By suncx 撥入審核（過賬）時，需調用s_stkminus校驗當期庫存是否足夠
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.TQC-C50034 12/05/23 By chenjing 增加單頭錄入完點擊【確定】後，CALL prompt來詢問調撥單的生產方式
# Modify.........: No:TQC-C60028 12/06/04 By bart 只要是ICD行業 倉儲批開窗改用q_idc
# Modify.........: No:TQC-C60081 12/06/11 By chenjing 修改單頭下條件時查詢總筆數錯誤
# Modify.........: No:FUN-C30085 12/06/20 By lixiang 串CR報表改GR報表
# Modify.........: No:FUN-C80107 12/09/18 By suncx 增可按倉庫進行負庫存判斷
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No:FUN-CB0087 12/12/06 By qiull 庫存單據理由碼改善
# Modify.........: No.FUN-D20060 13/02/22 By yangtt 設限倉庫/儲位控卡
# Modify.........: No:FUN-BC0062 13/02/28 By fengrui 當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
# Modify.........: No:MOD-C30785 13/03/07 By Elise 撥入過帳時,同時在撥入營運中心產生單據
# Modify.........: No:FUN-D30024 13/03/12 By qiull 負庫存依據imd23判斷
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.TQC-D40026 13/04/15 By fengrui 還原FUN-BC0062修改
# Modify.........: No.CHI-D40043 13/04/19 Bt bart 1.請控卡單身若無資料不允許確認與撥出確認
#                                                 2.此加上作廢功能，請參考aimt325的作廢段的控卡。
# Modify.........: No:MOD-D50183 13/05/22 By fengmy 過帳還原,刪除tlf時加入來源和目的營運中心
# Modify.........: No:TQC-D40078 13/04/28 By xujing 負庫存函数添加营运中心参数 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_imm           RECORD LIKE imm_file.*,
    g_imm_t         RECORD LIKE imm_file.*,
    g_imm_o         RECORD LIKE imm_file.*,
    b_imn           RECORD LIKE imn_file.*,
    g_s             RECORD      
                        imn041 LIKE imn_file.imn041, #FUN-660078
                        imn151 LIKE imn_file.imn151  #FUN-660078
                    END RECORD,
    g_s_t           RECORD      
                        imn041 LIKE imn_file.imn041, #FUN-660078
                        imn151 LIKE imn_file.imn151  #FUN-660078
                    END RECORD,
    g_yy,g_mm       LIKE type_file.num5,             #No.FUN-690026 SMALLINT
    g_imn03_t       LIKE imn_file.imn03,
    t_imn04         LIKE imn_file.imn04,
    t_imn05         LIKE imn_file.imn05,
    t_imn15         LIKE imn_file.imn15,
    t_imn16         LIKE imn_file.imn16,
    t_imf04         LIKE imf_file.imf04,
    t_imf05         LIKE imf_file.imf05,
    g_value         LIKE ima_file.ima01,
    g_imn           DYNAMIC ARRAY OF RECORD          #程式變數(Prinram Variables)
                    imn02     LIKE imn_file.imn02,
                    imn03     LIKE imn_file.imn03,
                    att00     LIKE imx_file.imx00,  
                    att01     LIKE imx_file.imx01,  #No.FUN-690026 VARCHAR(10)
                    att01_c   LIKE imx_file.imx01,  #No.FUN-690026 VARCHAR(10)
                    att02     LIKE imx_file.imx02,  #No.FUN-690026 VARCHAR(10)
                    att02_c   LIKE imx_file.imx02,  #No.FUN-690026 VARCHAR(10)
                    att03     LIKE imx_file.imx03,  #No.FUN-690026 VARCHAR(10)
                    att03_c   LIKE imx_file.imx03,  #No.FUN-690026 VARCHAR(10)
                    att04     LIKE imx_file.imx04,  #No.FUN-690026 VARCHAR(10)
                    att04_c   LIKE imx_file.imx04,  #No.FUN-690026 VARCHAR(10)
                    att05     LIKE imx_file.imx05,  #No.FUN-690026 VARCHAR(10)
                    att05_c   LIKE imx_file.imx05,  #No.FUN-690026 VARCHAR(10)
                    att06     LIKE imx_file.imx06,  #No.FUN-690026 VARCHAR(10)
                    att06_c   LIKE imx_file.imx06,  #No.FUN-690026 VARCHAR(10)
                    att07     LIKE imx_file.imx07,  #No.FUN-690026 VARCHAR(10)
                    att07_c   LIKE imx_file.imx07,  #No.FUN-690026 VARCHAR(10)
                    att08     LIKE imx_file.imx08,  #No.FUN-690026 VARCHAR(10)
                    att08_c   LIKE imx_file.imx08,  #No.FUN-690026 VARCHAR(10)
                    att09     LIKE imx_file.imx09,  #No.FUN-690026 VARCHAR(10)
                    att09_c   LIKE imx_file.imx09,  #No.FUN-690026 VARCHAR(10)
                    att10     LIKE imx_file.imx10,  #No.FUN-690026 VARCHAR(10)
                    att10_c   LIKE imx_file.imx10,  #No.FUN-690026 VARCHAR(10)
                    imn29     LIKE imn_file.imn29,     #FUN-5C0077
                    #imn28     LIKE imn_file.imn28,    #FUN-CB0087 mark
                    imn04     LIKE imn_file.imn04,
                    imn05     LIKE imn_file.imn05,
                    imn06     LIKE imn_file.imn06,
                    imn09     LIKE imn_file.imn09,
                    imn9301   LIKE imn_file.imn9301, #FUN-670093
                    gem02b    LIKE gem_file.gem02,   #FUN-670093
                    imn33     LIKE imn_file.imn33,
                    imn34     LIKE imn_file.imn34,
                    imn35     LIKE imn_file.imn35,
                    imn30     LIKE imn_file.imn30,
                    imn31     LIKE imn_file.imn31,
                    imn32     LIKE imn_file.imn32,
                    imn15     LIKE imn_file.imn15,
                    imn16     LIKE imn_file.imn16,
                    imn17     LIKE imn_file.imn17,
                    imn20     LIKE imn_file.imn20,
                    imn9302   LIKE imn_file.imn9302, #FUN-670093
                    gem02c    LIKE gem_file.gem02,   #FUN-670093
                    imn43     LIKE imn_file.imn43,
                    imn44     LIKE imn_file.imn44,
                    imn45     LIKE imn_file.imn45,
                    imn40     LIKE imn_file.imn40,
                    imn41     LIKE imn_file.imn41,
                    imn42     LIKE imn_file.imn42,
                    imn10     LIKE imn_file.imn10,
                    imn22     LIKE imn_file.imn22,
                    imn21     LIKE imn_file.imn21,
                    imn52     LIKE imn_file.imn52,
                    imn51     LIKE imn_file.imn51,
                    imn28     LIKE imn_file.imn28,    #FUN-CB0087
                    azf03     LIKE azf_file.azf03     #FUN-CB0087
                    END RECORD,
    g_imn_t   RECORD
                    imn02     LIKE imn_file.imn02,
                    imn03     LIKE imn_file.imn03,
                    att00     LIKE imx_file.imx00,  
                    att01     LIKE imx_file.imx01,  #No.FUN-690026 VARCHAR(10)
                    att01_c   LIKE imx_file.imx01,  #No.FUN-690026 VARCHAR(10)
                    att02     LIKE imx_file.imx02,  #No.FUN-690026 VARCHAR(10)
                    att02_c   LIKE imx_file.imx02,  #No.FUN-690026 VARCHAR(10)
                    att03     LIKE imx_file.imx03,  #No.FUN-690026 VARCHAR(10)
                    att03_c   LIKE imx_file.imx03,  #No.FUN-690026 VARCHAR(10)
                    att04     LIKE imx_file.imx04,  #No.FUN-690026 VARCHAR(10)
                    att04_c   LIKE imx_file.imx04,  #No.FUN-690026 VARCHAR(10)
                    att05     LIKE imx_file.imx05,  #No.FUN-690026 VARCHAR(10)
                    att05_c   LIKE imx_file.imx05,  #No.FUN-690026 VARCHAR(10)
                    att06     LIKE imx_file.imx06,  #No.FUN-690026 VARCHAR(10)
                    att06_c   LIKE imx_file.imx06,  #No.FUN-690026 VARCHAR(10)
                    att07     LIKE imx_file.imx07,  #No.FUN-690026 VARCHAR(10)
                    att07_c   LIKE imx_file.imx07,  #No.FUN-690026 VARCHAR(10)
                    att08     LIKE imx_file.imx08,  #No.FUN-690026 VARCHAR(10)
                    att08_c   LIKE imx_file.imx08,  #No.FUN-690026 VARCHAR(10)
                    att09     LIKE imx_file.imx09,  #No.FUN-690026 VARCHAR(10)
                    att09_c   LIKE imx_file.imx09,  #No.FUN-690026 VARCHAR(10)
                    att10     LIKE imx_file.imx10,  #No.FUN-690026 VARCHAR(10)
                    att10_c   LIKE imx_file.imx10,  #No.FUN-690026 VARCHAR(10)
                    imn29     LIKE imn_file.imn29,    #FUN-5C0077
                    #imn28     LIKE imn_file.imn28,   #FUN-CB0087
                    imn04     LIKE imn_file.imn04,
                    imn05     LIKE imn_file.imn05,
                    imn06     LIKE imn_file.imn06,
                    imn09     LIKE imn_file.imn09,
                    imn9301   LIKE imn_file.imn9301, #FUN-670093
                    gem02b    LIKE gem_file.gem02,   #FUN-670093
                    imn33     LIKE imn_file.imn33,
                    imn34     LIKE imn_file.imn34,
                    imn35     LIKE imn_file.imn35,
                    imn30     LIKE imn_file.imn30,
                    imn31     LIKE imn_file.imn31,
                    imn32     LIKE imn_file.imn32,
                    imn15     LIKE imn_file.imn15,
                    imn16     LIKE imn_file.imn16,
                    imn17     LIKE imn_file.imn17,
                    imn20     LIKE imn_file.imn20,
                    imn9302   LIKE imn_file.imn9302, #FUN-670093
                    gem02c    LIKE gem_file.gem02,   #FUN-670093
                    imn43     LIKE imn_file.imn43,
                    imn44     LIKE imn_file.imn44,
                    imn45     LIKE imn_file.imn45,
                    imn40     LIKE imn_file.imn40,
                    imn41     LIKE imn_file.imn41,
                    imn42     LIKE imn_file.imn42,
                    imn10     LIKE imn_file.imn10,
                    imn22     LIKE imn_file.imn22,
                    imn21     LIKE imn_file.imn21,
                    imn52     LIKE imn_file.imn52,
                    imn51     LIKE imn_file.imn51,
                    imn28     LIKE imn_file.imn28,    #FUN-CB0087
                    azf03     LIKE azf_file.azf03     #FUN-CB0087
                    END RECORD,
    g_img09_s           LIKE img_file.img09,
    g_img09_t           LIKE img_file.img09,
    g_img10_s           LIKE img_file.img10,
    g_img10_t           LIKE img_file.img10,
    g_ima906            LIKE ima_file.ima906,
    g_ima907            LIKE ima_file.ima907,
    g_factor            LIKE img_file.img21,
    g_tot               LIKE img_file.img10,
    g_flag              LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    g_wc,g_wc1,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN
    h_qty               LIKE ima_file.ima271,
    g_t1                LIKE smy_file.smyslip,  #No.FUN-560271 #No.FUN-690026 VARCHAR(5)
    g_buf               LIKE ima_file.ima02,    #No.FUN-690026 VARCHAR(30)
    g_buf1              LIKE ima_file.ima021,   #No.FUN-690026 VARCHAR(30)
    g_buf2              LIKE ima_file.ima15,    #No.FUN-690026 VARCHAR(1)
    sn1,sn2             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    l_code              LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_rec_b             LIKE type_file.num5,    #單身筆數  #No.FUN-690026 SMALLINT
    l_ac                LIKE type_file.num5,    #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
    g_debit,g_credit    LIKE img_file.img26,
    g_ima25,g_ima25_2   LIKE ima_file.ima25,
    g_img10,g_img10_2   LIKE img_file.img10,
    g_chgplant 		LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    g_azp01             LIKE azp_file.azp01,
    g_azp03_o           LIKE azp_file.azp03,
    g_azp03             LIKE azp_file.azp03,
    g_db_tra            LIKE azp_file.azp03,    #來源trans DB#FUN-980093
    g_azp03_tra         LIKE azp_file.azp03,    #FUN-980093
    g_azp03_tra_o       LIKE azp_file.azp03,    #FUN-980093
    g_cmd               LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(100)
 
DEFINE l_qcs091             LIKE qcs_file.qcs091
DEFINE p_row,p_col          LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql         STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_cnt                LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                  LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg                LIKE type_file.chr1000 #TQC-610072  #No.FUN-690026 VARCHAR(120)
DEFINE g_row_count          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask            LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_argv1              LIKE imm_file.imm01    # 單號 #TQC-630052 #No.FUN-690026 VARCHAR(16)
DEFINE g_argv2              STRING                 # 指定執行的功能   #TQC-630052
DEFINE   arr_detail    DYNAMIC ARRAY OF RECORD                                                                                      
         imx00      LIKE imx_file.imx00,                                                                                            
         imx        ARRAY[10] OF LIKE imx_file.imx01                                                                                
         END RECORD                                                                                                                 
DEFINE   lr_agc        DYNAMIC ARRAY OF RECORD LIKE agc_file.*                                                                      
DEFINE   lg_smy62      LIKE smy_file.smy62   #在smy_file中定義的與當前單別關聯的                                                    
DEFINE   lg_group      LIKE smy_file.smy62   #當前單身中采用的組別 
#FUN-BB0084 --------------Begin---------------
DEFINE   g_imn30_t     LIKE imn_file.imn30 
DEFINE   g_imn33_t     LIKE imn_file.imn33 
DEFINE   g_imn40_t     LIKE imn_file.imn40
DEFINE   g_imn43_t     LIKE imn_file.imn43
#FUN-BB0084 --------------End-----------------
DEFINE   g_flag1       LIKE type_file.chr1   #FUN-C80107 add
 
MAIN
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AIM")) THEN
       EXIT PROGRAM
    END IF
 
    LET g_argv1=ARG_VAL(1)           #TQC-630052
    LET g_argv2=ARG_VAL(2)           #TQC-630052
 
    CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
    INITIALIZE g_imm.* TO NULL
    INITIALIZE g_imm_t.* TO NULL
    INITIALIZE g_imm_o.* TO NULL
 
    #不異動g_dbs的值,把g_plant對應的trans db 存在g_db_tra
    LET g_plant_new = g_plant
    CALL s_gettrandbs()
    LET g_db_tra = g_dbs_tra
 
    LET g_forupd_sql = "SELECT * FROM imm_file WHERE imm01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t720_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 1 LET p_col = 8
 
    OPEN WINDOW t720_w AT p_row,p_col WITH FORM "aim/42f/aimt720"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    LET lg_smy62 = ''                                                                                                               
    LET lg_group = ''                                                                                                               
    CALL t720_refresh_detail()      
    CALL cl_ui_init()
 
    # 先以g_argv2判斷直接執行哪種功能，執行Q時，g_argv1是單號(imm01)
    # 執行I時，g_argv1是單號(imm01)
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t720_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL t720_a()
             END IF
          OTHERWISE
                CALL t720_q()
       END CASE
    END IF
 
 
   CALL t720_def_form()
 
    CALL t720_menu()
 
    CLOSE WINDOW t720_w                   #結束畫面
    CALL  cl_used(g_prog,g_time,2)         #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
FUNCTION t720_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_imn.clear()
   IF cl_null(g_argv1) THEN  #TQC-630052
    INITIALIZE g_imm.* TO NULL   #FUN-640213 add 
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        imm01,imm02,imm14,imm04,imm03,immspc,immuser,immgrup,immmodu,immdate    #No.TQC-740249
 
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION controlp
           CASE WHEN INFIELD(imm01) #查詢單据
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form  = "q_imm105"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imm01
                    NEXT FIELD imm01
               WHEN INFIELD(g_s.imn041) #工廠別
                    CALL cl_init_qry_var()
                    LET g_qryparam.form     = "q_azr"
                    LET g_qryparam.default1 = g_s.imn041
                    CALL cl_create_qry() RETURNING g_s.imn041
                    DISPLAY BY NAME g_s.imn041
                    NEXT FIELD oplnat
               WHEN INFIELD(imn151)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_azp"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imn151
               WHEN INFIELD(imm14)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gem4"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imm14
                  NEXT FIELD imm14
               OTHERWISE EXIT CASE
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
    END CONSTRUCT
 
    IF INT_FLAG THEN RETURN END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('immuser', 'immgrup')
 
    CONSTRUCT BY NAME g_wc1 ON                     # 螢幕上取單頭工廠條件
        imn041,imn151
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
 
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
 
    CONSTRUCT g_wc2 ON imn02,imn03,imn29,imn28,imn04,imn05,imn06,imn09,imn9301,  #No.FUN-5C0077  #FUN-670093
                       imn33,imn34,imn35,imn30,imn31,imn32,
                       imn15,imn16,imn17,imn20,imn9302,  #FUN-670093
                       imn43,imn44,imn45,imn40,imn41,imn42,
                       imn10,imn22,imn21,imn52,imn51
            FROM s_imn[1].imn02,s_imn[1].imn03,s_imn[1].imn29,s_imn[1].imn28,s_imn[1].imn04, #NO.FUN-5C0077
                 s_imn[1].imn05,s_imn[1].imn06,s_imn[1].imn09,s_imn[1].imn9301, #FUN-670093
                 s_imn[1].imn33,s_imn[1].imn34,s_imn[1].imn35,
                 s_imn[1].imn30,s_imn[1].imn31,s_imn[1].imn32,
                 s_imn[1].imn15,s_imn[1].imn16,s_imn[1].imn17,s_imn[1].imn20,s_imn[1].imn9302, #FUN-670093
                 s_imn[1].imn43,s_imn[1].imn44,s_imn[1].imn45,
                 s_imn[1].imn40,s_imn[1].imn41,s_imn[1].imn42,
                 s_imn[1].imn10,s_imn[1].imn22,s_imn[1].imn21,
                 s_imn[1].imn52,s_imn[1].imn51
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(imn03)
#FUN-AA0059 --Begin--
             #   CALL cl_init_qry_var()
             #   LET g_qryparam.form = "q_ima"
             #   LET g_qryparam.state = "c"
             #   LET g_qryparam.default1 = g_imn[1].imn03
             #   CALL cl_create_qry() RETURNING g_imn[1].imn03
                CALL q_sel_ima( TRUE, "q_ima","",g_imn[1].imn03,"","","","","",'')  RETURNING g_imn[1].imn03
#FUN-AA0059 --End--                
                DISPLAY g_imn[1].imn03 TO imn03
                NEXT FIELD imn03
             WHEN INFIELD(imn33)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gfe"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO inm33
                NEXT FIELD inm33
             WHEN INFIELD(imn30)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gfe"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO imn30
                NEXT FIELD imn30
             WHEN INFIELD(imn43)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gfe"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO inm43
                NEXT FIELD inm43
             WHEN INFIELD(imn40)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gfe"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO imn40
                NEXT FIELD imn40
             WHEN INFIELD(imn28)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_azf01a"
                LET g_qryparam.state    = "c"
                LET g_qryparam.default1 = g_imn[1].imn28
                LET g_qryparam.arg1     = "6"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO imn28
                NEXT FIELD imn28
             WHEN INFIELD(imn9301)
                CALL cl_init_qry_var()
                LET g_qryparam.form  = "q_gem4"
                LET g_qryparam.state = "c"   #多選
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO imn9301
                NEXT FIELD imn9301
             WHEN INFIELD(imn9302)
                CALL cl_init_qry_var()
                LET g_qryparam.form  = "q_gem4"
                LET g_qryparam.state = "c"   #多選
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO imn9302
                NEXT FIELD imn9302
             OTHERWISE
                EXIT CASE
         END CASE
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
    END CONSTRUCT
 
   ELSE
      LET g_wc  =" imm01 = '",g_argv1,"'"  
      LET g_wc1 =" 1=1"  
      LET g_wc2 =" 1=1"  
   END IF
 
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF g_wc2 = " 1=1" AND g_wc1=" 1=1" THEN	# 若單身未輸入條件    #TQC-C60081  ADD ' '
       LET g_sql = "SELECT  imm01 FROM imm_file",
                   " WHERE imm10 = '3' AND ", g_wc CLIPPED,
                   " ORDER BY imm01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE imm_file. imm01 ",
                   "  FROM imm_file, imn_file",
                   " WHERE imm01 = imn01",
                   "   AND imm10 = '3'  ",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
				   "   AND ",g_wc1 CLIPPED,
                   " ORDER BY imm01"
    END IF
 
    PREPARE t720_prepare FROM g_sql
    DECLARE t720_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t720_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM imm_file ",              
                  "WHERE imm10 = '3' AND ",g_wc CLIPPED         
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT imm01) FROM imm_file,imn_file ",
                  " WHERE imm10 = '3' AND ",
                  "imm01=imn01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
				  " AND ",g_wc1 CLIPPED
    END IF
    PREPARE t720_precount FROM g_sql
    DECLARE t720_count CURSOR FOR t720_precount
END FUNCTION
 
FUNCTION t720_menu()
 
   WHILE TRUE
      CALL t720_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t720_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t720_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t720_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t720_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t720_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t720_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "撥出確認"
         WHEN "conf_transfer_out"
               CALL t720_y()
 
       #@WHEN "撥出取消確認"
         WHEN "undo_conf_transfer_out"
            IF cl_chk_act_auth() THEN
               CALL t720_z()
            END IF
 
       #@WHEN "撥入確認 過帳"
         WHEN "conf_transfer_in_post"
               CALL t720_s()
 
       #@WHEN "撥入確認 過帳還原"
         WHEN "undo_conf_transfer_in_post"
            IF cl_chk_act_auth() THEN
               CALL t720_w()
            END IF
 
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_imn),'','')
            END IF
 
         WHEN "trans_spc"         
            IF cl_chk_act_auth() THEN
               CALL t720_spc()
            END IF
 
        WHEN "related_document"  #相關文件
           IF cl_chk_act_auth() THEN
              IF g_imm.imm01 IS NOT NULL THEN
                LET g_doc.column1 = "imm01"
                LET g_doc.value1 = g_imm.imm01
                CALL cl_doc()
              END IF
          END IF
         #CHI-D40043---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t720_x(1)  
            END IF
            
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t720_x(2)   
            END IF
         #CHI-D40043---end
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t720_g1()
  DEFINE l_wc,l_sql   LIKE type_file.chr1000     #No.FUN-690026 VARCHAR(400)
  DEFINE t_img02      LIKE imn_file.imn15        #FUN-660078
  DEFINE t_img03      LIKE imn_file.imn16        #FUN-660078
  DEFINE t_img04      LIKE imn_file.imn17        #FUN-660078
  DEFINE l_img RECORD LIKE img_file.*
  DEFINE l_imn9301    LIKE imn_file.imn9301      #FUN-670093
  DEFINE l_flag       LIKE type_file.chr1        #FUN-B70074
  DEFINE l_imni       RECORD LIKE imni_file.*    #FUN-B70074
  
    LET p_row = 3 LET p_col = 10
    OPEN WINDOW t720g1_w AT p_row,p_col  WITH FORM "aim/42f/aimt720g1"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aimt720g1")
 
    CONSTRUCT BY NAME l_wc ON img01,img04,img02,img03
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
 
    IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW t720g1_w RETURN END IF
 
    INPUT BY NAME t_img04,t_img02,t_img03
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
    IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW t720g1_w RETURN END IF
 
    LET l_sql="SELECT * FROM img_file WHERE ",l_wc CLIPPED,
              " AND img10 > 0",
              " ORDER BY img01,img04,img02,img03"
    PREPARE t720_g1_p FROM l_sql
    DECLARE t720_g1_c CURSOR FOR t720_g1_p
 
    INITIALIZE b_imn.* TO NULL
 
    SELECT MAX(imn02) INTO b_imn.imn02 FROM imn_file WHERE imn01=g_imm.imm01
    IF b_imn.imn02 IS NULL THEN LET b_imn.imn02=0 END IF
    LET l_imn9301=s_costcenter(g_imm.imm14) #FUN-670093
    FOREACH t720_g1_c INTO l_img.*
       IF STATUS THEN EXIT FOREACH END IF
       LET b_imn.imn01 = g_imm.imm01
       LET b_imn.imn02 = b_imn.imn02 + 1
       LET b_imn.imn03 = l_img.img01
       LET b_imn.imn04 = l_img.img02
       LET b_imn.imn05 = l_img.img03
       LET b_imn.imn06 = l_img.img04
       LET b_imn.imn09 = l_img.img09
       LET b_imn.imn10 = l_img.img10
       LET b_imn.imn9301=l_imn9301 #FUN-670093
       LET b_imn.imn9302=l_imn9301 #FUN-670093
       IF t_img02 IS NULL
          THEN LET b_imn.imn15 = l_img.img02
          ELSE LET b_imn.imn15 = t_img02
       END IF
       IF t_img03 IS NULL
          THEN LET b_imn.imn16 = l_img.img03
          ELSE LET b_imn.imn16 = t_img03
       END IF
       IF t_img04 IS NULL
          THEN LET b_imn.imn17 = l_img.img04
          ELSE LET b_imn.imn17 = t_img04
       END IF
       CALL t720_b_move_to()
       LET b_imn.imn20=NULL LET b_imn.imn21=NULL
       SELECT img09,img21 INTO b_imn.imn20,b_imn.imn21
	FROM img_file WHERE img01=b_imn.imn03 AND img02=b_imn.imn15
			AND img03=b_imn.imn16 AND img04=b_imn.imn17
       IF STATUS=100 THEN
           CALL s_madd_img(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                           g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                           g_imm.imm01,      g_imn[l_ac].imn02,
                           g_imm.imm02,g_s.imn151)                    #No.FUN-980081 
          SELECT img09,img21 INTO b_imn.imn20,b_imn.imn21
	   FROM img_file WHERE img01=b_imn.imn03 AND img02=b_imn.imn15
			   AND img03=b_imn.imn16 AND img04=b_imn.imn17
       END IF
       LET b_imn.imn21 = b_imn.imn21 / l_img.img21
       LET b_imn.imn22 = b_imn.imn10 * b_imn.imn21
       LET b_imn.imn22 = s_digqty(b_imn.imn22,b_imn.imn20)    #FUN-BB0084
       LET b_imn.imn27 = 'N'
       LET b_imn.imnplant = g_plant #FUN-980004
       LET b_imn.imnlegal = g_legal #FUN-980004
       INSERT INTO imn_file VALUES (b_imn.*)
       MESSAGE 'Insert seq no:',b_imn.imn02,' status:',SQLCA.SQLCODE
       #FUN-B70074-add-str--
       IF NOT s_industry('std') THEN 
          INITIALIZE l_imni.* TO NULL
          LET l_imni.imni01 = b_imn.imn01
          LET l_imni.imni02 = b_imn.imn02
          LET l_flag = s_ins_imni(l_imni.*,b_imn.imnplant)         
       END IF       
       #FUN-B70074-add-end--
    END FOREACH
    CLOSE WINDOW t720g1_w
END FUNCTION

 
FUNCTION t720_a()
    DEFINE li_result  LIKE type_file.num5        #No.FUN-550029  #No.FUN-690026 SMALLINT
  #TQC-C50034--add--start--
    DEFINE  l_msg  LIKE ze_file.ze03, 
            l_chr  LIKE type_file.chr1
    DEFINE  l_imn  RECORD LIKE imn_file.*   
    DEFINE  l_sql  STRING
  #TQC-C50034--add--end--
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_imn.clear()
    INITIALIZE g_imm.* TO NULL
    INITIALIZE g_s.* TO NULL    #No.TQC-A60018
    LET g_imm_o.* = g_imm.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_imm.imm02  =g_today
        LET g_imm.imm04  = 'N'
        LET g_imm.imm03  = 'N'
        LET g_imm.immspc = '0' #FUN-680010
        LET g_imm.immconf= 'N' #FUN-660029 
        LET g_imm.imm09  =g_user
        LET g_imm.imm10  = '3'
        LET g_imm.immacti='Y'
        LET g_imm.immuser=g_user
        LET g_imm.immoriu = g_user #FUN-980030
        LET g_imm.immorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_imm.immgrup=g_grup
        LET g_imm.immdate=g_today
        LET g_s.imn041=g_plant
        LET g_imm.imm14=g_grup #FUN-670093
        LET g_imm.immplant = g_plant #FUN-980004
        LET g_imm.immlegal = g_legal #FUN-980004
        BEGIN WORK
        CALL t720_i("a")                #輸入單頭
        IF INT_FLAG THEN
           INITIALIZE g_imm.* TO NULL
           LET INT_FLAG=0 CALL cl_err('',9001,0) ROLLBACK WORK EXIT WHILE
        END IF
        IF g_imm.imm01 IS NULL THEN CONTINUE WHILE END IF
        BEGIN WORK
           CALL  s_auto_assign_no("aim",g_imm.imm01,g_imm.imm02,"","imm_file","imm01",
                  "","","")
              RETURNING li_result,g_imm.imm01
        IF (NOT li_result) THEN
	           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_imm.imm01
        #FUN-A60034--add---str---
        #FUN-A70104--mod---str---
        LET g_imm.immmksg = 'N'          #是否簽核
        LET g_imm.imm15 = '0'            #簽核狀況
        LET g_imm.imm16 = g_user         #申請人
        #FUN-A70104--mod---end---
        #FUN-A60034--add---end---
        INSERT INTO imm_file VALUES (g_imm.*)
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("ins","imm_file",g_imm.imm01,"",SQLCA.sqlcode,"","ins imm",1)   #NO.FUN-640266  #No.FUN-660156
           CONTINUE WHILE
        ELSE
            COMMIT WORK
            CALL cl_flow_notify(g_imm.imm01,'I')
       #TQC-C50034--add--start--
            LET g_imm_t.* = g_imm.*        #保存上筆資料
            CALL cl_getmsg('mfg9390',g_lang) RETURNING l_msg
            WHILE l_chr IS NULL OR l_chr NOT MATCHES'[123]'
               LET INT_FLAG = 0 
               PROMPT l_msg CLIPPED FOR CHAR l_chr

               IF INT_FLAG THEN
                  LET INT_FLAG = 0 
                  LET l_chr = '1'
                  EXIT WHILE
               END IF
            END WHILE
            
            IF l_chr = '2' OR l_chr = '3' THEN
               IF l_chr = '2' THEN     #工單方式
                  CALL t7001(g_imm.imm01,g_imm.imm02,'1',g_s.imn041,g_s.imn151)
               ELSE
                  CALL t7001(g_imm.imm01,g_imm.imm02,'2',g_s.imn041,g_s.imn151)
               END IF
               CALL t720_b_fill("1=1")
            END IF
       #TQC-C50034--add--end--
        END IF
        SELECT imm01 INTO g_imm.imm01 FROM imm_file WHERE imm01 = g_imm.imm01
        LET g_imm_t.* = g_imm.*
		LET g_s_t.*=g_s.*
        IF l_chr NOT MATCHES '[2,3]' THEN   #TQC-C50034 add
           INITIALIZE b_imn.* TO NULL
           CALL g_imn.clear()
           LET g_rec_b = 0
        END IF
        CALL t720_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t720_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_imm.imm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_imm.* FROM imm_file WHERE imm01=g_imm.imm01
    IF g_imm.imm03 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_imm.imm04 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_imm.imm04 = 'X' THEN RETURN END IF  #CHI-D40043
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_imm_o.* = g_imm.*
	BEGIN WORK
 
    OPEN t720_cl USING g_imm.imm01
    IF STATUS THEN
       CALL cl_err("OPEN t720_cl:", STATUS, 1)
       CLOSE t720_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t720_cl INTO g_imm.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t720_cl ROLLBACK WORK RETURN
    END IF
    CALL t720_show()
    WHILE TRUE
        LET g_imm.immmodu=g_user
        LET g_imm.immdate=g_today
        CALL t720_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_imm.*=g_imm_t.*
            LET g_s_t.*=g_s.*
            CALL t720_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE imm_file SET * = g_imm.* WHERE imm01 = g_imm_o.imm01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("upd","imm_file",g_imm_t.imm01,"",SQLCA.sqlcode,"","upd imm",1)   #NO.FUN-640266 #No.FUN-660156
           CONTINUE WHILE
        END IF
        IF g_imm.imm01 != g_imm_t.imm01 THEN CALL t720_chkkey() END IF
        EXIT WHILE
    END WHILE
    CLOSE t720_cl
    COMMIT WORK
    CALL cl_flow_notify(g_imm.imm01,'U')
END FUNCTION
 
FUNCTION t720_chkkey()
      UPDATE imn_file SET imn01=g_imm.imm01 WHERE imn01=g_imm_t.imm01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","imn_file",g_imm_t.imm01,"",SQLCA.sqlcode,"","upd imn01",1)   #NO.FUN-640266 #No.FUN-660156
         LET g_imm.*=g_imm_t.* CALL t720_show() ROLLBACK WORK RETURN
      END IF
END FUNCTION
 
FUNCTION t720_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1    #a:輸入 u:更改  #No.FUN-690026 VARCHAR(1)
  DEFINE l_flag          LIKE type_file.chr1    #判斷必要欄位是否有輸入  #No.FUN-690026 VARCHAR(1)
  DEFINE li_result       LIKE type_file.num5    #No.FUN-550029  #No.FUN-690026 SMALLINT
     CALL cl_set_head_visible("","YES")   #No.FUN-6B0030 
    INPUT BY NAME g_imm.immoriu,g_imm.immorig,g_imm.imm01,g_imm.imm02,g_imm.imm14,g_s.imn041,g_s.imn151,g_imm.imm04,  #FUN-670093
                  g_imm.imm03,g_imm.immspc,g_imm.immuser,g_imm.immgrup,g_imm.immmodu,     #FUN-680010
                  g_imm.immdate
          WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t720_set_entry(p_cmd)
            CALL t720_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_set_docno_format("imm01")
 
        AFTER FIELD imm01
            IF NOT cl_null(g_imm.imm01) THEN
               #得到該單別對應的屬性群組      
               LET g_t1 = s_get_doc_no(g_imm.imm01)                                                                                         
               IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' ) THEN                                                                 
                  #讀取smy_file中指定作業對應的默認屬性群組                                                                            
                  SELECT smy62 INTO lg_smy62 FROM smy_file WHERE smyslip = g_t1                                                        
                  #刷新界面顯示                                                                                                        
                  CALL t720_refresh_detail()                                                                                           
               ELSE                                                                                                                    
                  LET lg_smy62 = ''                                                                                                    
               END IF              
 
              CALL s_check_no("aim",g_imm.imm01,g_imm_t.imm01,"4","imm_file","imm01","")
                   RETURNING li_result,g_imm.imm01
               DISPLAY BY NAME g_imm.imm01
               IF (NOT li_result) THEN
                    LET g_imm.imm01 = g_imm_t.imm01
                    DISPLAY BY NAME g_imm.imm01
                    NEXT FIELD imm01
               END IF
            END IF
 
        AFTER FIELD imm02
            IF NOT cl_null(g_imm.imm02) THEN
              
	       IF g_sma.sma53 IS NOT NULL AND g_imm.imm02 <= g_sma.sma53 THEN
	          CALL cl_err('','mfg9999',0) NEXT FIELD imm02
	       END IF
               CALL s_yp(g_imm.imm02) RETURNING g_yy,g_mm
               IF (g_yy*12+g_mm)>(g_sma.sma51*12+g_sma.sma52)THEN #不可大於現行年月
                  CALL cl_err('','mfg6091',0) NEXT FIELD imm02
               END IF
            END IF
 
        AFTER FIELD imn151	#撥入工廠別
            IF NOT cl_null(g_s.imn151) THEN
               IF g_s.imn151 = g_s.imn041 THEN
                   LET g_s.imn151 = g_s_t.imn151
                   DISPLAY BY NAME g_s.imn151
                   CALL cl_err(g_s.imn151,'mfg3454',0)
                   NEXT FIELD imn151
               END IF
               #檢查工廠並將新的資料庫放在g_dbs_new
               IF NOT s_chknplt(g_s.imn151,'AIM','AIM') THEN
                  CALL cl_err(g_s.imn151,g_errno,0)
                  NEXT FIELD imn151
               END IF
               IF g_s_t.imn151 IS NOT NULL AND g_s_t.imn151 != g_s.imn151 THEN
                  LET g_chgplant = 'Y'
               END IF
               SELECT azp03 INTO g_azp03 FROM azp_file WHERE azp01=g_s.imn151
               LET g_azp03=s_dbstring(g_azp03 CLIPPED)
               LET g_plant_new = g_s.imn151
               CALL s_getdbs()     LET g_azp03 = g_dbs_new
               CALL s_gettrandbs() LET g_azp03_tra = g_dbs_tra
            END IF
        AFTER FIELD imm14
            IF NOT cl_null(g_imm.imm14) THEN
               SELECT gem02 INTO g_buf FROM gem_file
                WHERE gem01=g_imm.imm14
                  AND gemacti='Y'
               IF STATUS THEN
                  CALL cl_err3("sel","gem_file",g_imm.imm14,"",SQLCA.sqlcode,"",
                               "select gem",1)
                  NEXT FIELD imm14
               END IF
               DISPLAY g_buf TO gem02
               #FUN-CB0087---add---str---
               IF NOT t720_imn28_chk() THEN
                  LET g_imm.imm14 = g_imm_t.imm14
                  NEXT FIELD imm14
               END IF
               #FUN-CB0087---add---end---
            END IF
 
        ON ACTION controlp
          CASE WHEN INFIELD(imm01) #查詢單据
                 LET g_t1=g_imm.imm01[1,g_doc_len]   #No.FUN-560271
                 CALL q_smy(FALSE,TRUE,g_t1,'AIM','4') RETURNING g_t1  #TQC-670008
                 LET g_imm.imm01=g_t1                  #No.FUN-550029
                 DISPLAY BY NAME g_imm.imm01
                 NEXT FIELD imm01
               WHEN INFIELD(g_s.imn041) #工廠別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azr"
                  LET g_qryparam.default1 = g_s.imn041
                  CALL cl_create_qry() RETURNING g_s.imn041
                  DISPLAY BY NAME g_s.imn041
                  NEXT FIELD oplnat
               WHEN INFIELD(imn151)
                  CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_azp"            #NO.TQC-A60018
                  LET g_qryparam.form = "q_imn151"          #NO.TQC-A60018
                  LET g_qryparam.arg1 = g_legal             #NO.TQC-A60018
                  LET g_qryparam.default1 = g_s.imn151
                  CALL cl_create_qry() RETURNING g_s.imn151
                  DISPLAY BY NAME g_s.imn151
                  NEXT FIELD imn151
               WHEN INFIELD(imm14)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.default1 = g_imm.imm14
                    CALL cl_create_qry() RETURNING g_imm.imm14
                    DISPLAY BY NAME g_imm.imm14
                    NEXT FIELD imm14
               OTHERWISE EXIT CASE
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION t720_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("imm01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t720_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("imm01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t720_set_entry_b()
 
   CALL cl_set_comp_entry("imn33,imn35,imn43",TRUE)
 
END FUNCTION
 
FUNCTION t720_set_no_entry_b()
 
   IF g_ima906 = '1' THEN
      CALL cl_set_comp_entry("imn33,imn34,imn35,imn43,imn44,imn45",FALSE)
   END IF
   IF g_ima906 = '2' THEN
      CALL cl_set_comp_entry("imn31,imn34,imn41,imn44",FALSE)
   END IF
   #參考單位，每個料件只有一個，所以不開放讓用戶輸入
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_entry("imn33,imn43",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION t720_set_required()
 
   #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_required("imn33,imn35,imn30,imn32,
                                 imn43,imn45,imn40,imn42",TRUE)
   END IF
   #單位不空,轉換率,數量必KEY,KEY了來源,目的必KEY
   IF NOT cl_null(g_imn[l_ac].imn33) THEN
      CALL cl_set_comp_required("imn35,imn43,imn45",TRUE)
   END IF
   IF NOT cl_null(g_imn[l_ac].imn30) THEN
      CALL cl_set_comp_required("imn32,imn40,imn42",TRUE)
   END IF
   IF NOT cl_null(g_imn[l_ac].imn43) THEN
      CALL cl_set_comp_required("imn45,imn33,imn35",TRUE)
   END IF
   IF NOT cl_null(g_imn[l_ac].imn40) THEN
      CALL cl_set_comp_required("imn42,imn30,imn32",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t720_set_no_required()
 
   CALL cl_set_comp_required("imn33,imn34,imn35,imn30,imn31,imn32,
                              imn43,imn44,imn45,imn40,imn41,imn42",FALSE)
 
END FUNCTION
 
FUNCTION t720_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_imm.* TO NULL             #No.FUN-680046
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
 
    IF g_sma.sma120 = 'Y'  THEN                                                                                                     
       LET lg_smy62 = ''                                                                                                            
       LET lg_group = ''                                                                                                            
       CALL t720_refresh_detail()                                                                                                   
    END IF                                                                                                                          
 
    CALL t720_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 INITIALIZE g_imm.* TO NULL RETURN END IF
    MESSAGE " SEARCHING ! "
    OPEN t720_cs               # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_imm.* TO NULL
    ELSE
        OPEN t720_count
        FETCH t720_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t720_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t720_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,   #處理方式  #No.FUN-690026 VARCHAR(1)
    l_slip          LIKE smy_file.smyslip  #NO.TQC-650093 add. #No.FUN-690026 VARCHAR(10)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t720_cs INTO g_imm.imm01
        WHEN 'P' FETCH PREVIOUS t720_cs INTO g_imm.imm01
        WHEN 'F' FETCH FIRST    t720_cs INTO g_imm.imm01
        WHEN 'L' FETCH LAST     t720_cs INTO g_imm.imm01
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
            FETCH ABSOLUTE g_jump t720_cs INTO g_imm.imm01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)
        INITIALIZE g_imm.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_imm.* FROM imm_file WHERE imm01 = g_imm.imm01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","imm_file",g_imm.imm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
       INITIALIZE g_imm.* TO NULL
       RETURN
    END IF
   #在使用Q查詢的情況下得到當前對應的屬性組smy62                                                                                    
   IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN                                                                                
      LET l_slip = g_imm.imm01[1,g_doc_len]                                                                                         
      SELECT smy62 INTO lg_smy62 FROM smy_file                                                                                      
         WHERE smyslip = l_slip                                                                                                     
   END IF                                     
 
	SELECT DISTINCT imn041,imn151 INTO g_s.* FROM imn_file
	WHERE imn01=g_imm.imm01
        LET g_data_owner = g_imm.immuser #FUN-4C0053
        LET g_data_group = g_imm.immgrup #FUN-4C0053
        LET g_data_plant = g_imm.immplant #FUN-980030
    CALL t720_show()
END FUNCTION
 
FUNCTION t720_show()
    LET g_imm_t.* = g_imm.*                #保存單頭舊值
    DISPLAY BY NAME g_imm.immoriu,g_imm.immorig, g_imm.imm01,g_imm.imm02,g_imm.imm14,g_imm.imm04,g_imm.imm03,g_imm.immspc,  #FUN-680010
                    g_imm.immuser,g_imm.immgrup,g_imm.immmodu,g_imm.immdate
    DISPLAY BY NAME g_s.*
    CALL t720_b_fill(g_wc2)
    DISPLAY s_costcenter_desc(g_imm.imm14) TO FORMONLY.gem02 #FUN-670093
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t720_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
    DEFINE l_flag1 LIKE type_file.chr1      #FUN-B70074 

    IF s_shut(0) THEN RETURN END IF
    IF g_imm.imm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_imm.* FROM imm_file WHERE imm01=g_imm.imm01
    IF g_imm.imm03 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_imm.imm04 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_imm.imm04 = 'X' THEN RETURN END IF  #CHI-D40043
 
    BEGIN WORK
 
    OPEN t720_cl USING g_imm.imm01
    IF STATUS THEN
       CALL cl_err("OPEN t720_cl:", STATUS, 1)
       CLOSE t720_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t720_cl INTO g_imm.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0) ROLLBACK WORK RETURN
    END IF
    CALL t720_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "imm01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_imm.imm01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "Delete imm,imn!"
        DELETE FROM imm_file WHERE imm01 = g_imm.imm01
        IF SQLCA.SQLERRD[3]=0
           THEN 
                CALL cl_err3("del","imm_file",g_imm.imm01,"",SQLCA.sqlcode,"",
                             "No imm deleted",1)   #NO.FUN-640266  #No.FUN-660156
                ROLLBACK WORK RETURN
        END IF
        DELETE FROM imn_file WHERE imn01 = g_imm.imm01
        #FUN-B70074-add-str--
        IF NOT s_industry('std') THEN 
           LET l_flag1 = s_del_imni(g_imm.imm01,'','') 
        END IF 
        #FUN-B70074-add-end--
        LET g_msg=TIME
        INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,
                             azoplant,azolegal) #FUN-980004
           VALUES ('aimt720',g_user,g_today,g_msg,g_imm.imm01,'delete',
                   azoplant,azolegal) #FUN-980004
        CLEAR FORM
        CALL g_imn.clear()
    	INITIALIZE g_imm.* TO NULL
        MESSAGE ""
        OPEN t720_count
        #FUN-B50062-add-start--
        IF STATUS THEN
           CLOSE t720_cs
           CLOSE t720_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        FETCH t720_count INTO g_row_count
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t720_cs
           CLOSE t720_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t720_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t720_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t720_fetch('/')
        END IF
    END IF
    CLOSE t720_cl
    COMMIT WORK
    CALL cl_flow_notify(g_imm.imm01,'D')
 
END FUNCTION
 
FUNCTION t720_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_row,l_col     LIKE type_file.num5,    #分段輸入之行,列數  #No.FUN-690026 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,    #檢查重複用  #No.FUN-690026 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  #No.FUN-690026 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態  #No.FUN-690026 VARCHAR(1)
    l_img10         LIKE img_file.img10,
    l_qty           LIKE img_file.img10,    #MOD-530179
    l_flag          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    l_sql           LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(300)
    l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-690026 SMALLINT
    l_allow_delete  LIKE type_file.num5,    #可刪除否  #No.FUN-690026 SMALLINT
    l_ima130        LIKE ima_file.ima130,   #FUN-660078                                                                                                
    l_ima131        LIKE ima_file.ima131,   #FUN-660078
    l_b2            LIKE type_file.chr50,   #No.FUN-690026 VARCHAR(30)
    l_azf09         LIKE azf_file.azf09,     #FUN-920186
    l_ima25         LIKE ima_file.ima25,
    l_imaag         LIKE ima_file.imaag,
    l_imaacti       LIKE ima_file.imaacti
   DEFINE   li_i         LIKE type_file.num5                                                                                                       #No.FUN-690026 SMALLINT
   DEFINE   l_count      LIKE type_file.num5                                                                                                       #No.FUN-690026 SMALLINT
   DEFINE   l_temp       LIKE ima_file.ima01                                                                                        
   DEFINE   l_check_res  LIKE type_file.num5     #No.FUN-690026 SMALLINT
   DEFINE   l_imni   RECORD LIKE imni_file.*  #FUN-B70074

   #FUN-C20002--start add------------------------
   DEFINE   l_ima154     LIKE ima_file.ima154
   DEFINE   l_rcj03      LIKE rcj_file.rcj03
   DEFINE   l_rtz07      LIKE rtz_file.rtz07
   DEFINE   l_rtz08      LIKE rtz_file.rtz08
   #FUN-C20002--end add-------------------------- 
   DEFINE   l_where      STRING                 #FUN-CB0087
   DEFINE   l_store      STRING                 #FUN-CB0087

    LET g_action_choice = ""
    IF g_imm.imm01 IS NULL THEN RETURN END IF
    SELECT * INTO g_imm.* FROM imm_file WHERE imm01=g_imm.imm01
    IF g_imm.imm03 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_imm.imm04 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_imm.imm04 = 'X' THEN RETURN END IF  #CHI-D40043
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
    IF cl_null(g_azp03) THEN
       SELECT azp03 INTO g_azp03 FROM azp_file WHERE azp01=g_s.imn151
               LET g_azp03=s_dbstring(g_azp03 CLIPPED)
    END IF
 
     LET g_plant_new = g_s.imn151
     CALL s_getdbs()     LET g_azp03 = g_dbs_new
     CALL s_gettrandbs() LET g_azp03_tra = g_dbs_tra
 
    LET g_forupd_sql = "SELECT * FROM imn_file ",
                       "WHERE imn01= ? AND imn02= ? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t720_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    INPUT ARRAY g_imn WITHOUT DEFAULTS FROM s_imn.*
          ATTRIBUTE(COUNT=g_rec_b, MAXCOUNT=g_max_rec, UNBUFFERED,
                    INSERT ROW=l_allow_insert, DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN t720_cl USING g_imm.imm01
            IF STATUS THEN
               CALL cl_err("OPEN t720_cl:", STATUS, 1)
               CLOSE t720_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t720_cl INTO g_imm.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)     # 資料被他人LOCK
                CLOSE t720_cl ROLLBACK WORK RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_imn_t.* = g_imn[l_ac].*  #BACKUP
            #FUN-BB0084 ----------Begin-----------
               LET g_imn30_t = g_imn[l_ac].imn30
               LET g_imn33_t = g_imn[l_ac].imn33
               LET g_imn43_t = g_imn[l_ac].imn43
            #FUN-BB0084 ----------End-------------
               OPEN t720_bcl USING g_imm.imm01,g_imn_t.imn02
               IF STATUS THEN
                  CALL cl_err("OPEN t720_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t720_bcl INTO b_imn.*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('lock imn',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     CALL t720_b_move_to()
                     LET g_imn[l_ac].gem02b=s_costcenter_desc(g_imn[l_ac].imn9301) #FUN-670093
                     LET g_imn[l_ac].gem02c=s_costcenter_desc(g_imn[l_ac].imn9302) #FUN-670093
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_imn[l_ac].* TO NULL      #900423
            INITIALIZE g_imn_t.* TO NULL      #900423
            INITIALIZE arr_detail[l_ac].* TO NULL #NO.TQC-650093
        #FUN-BB0084 -----------Begin------------
            LET g_imn30_t = NULL
            LET g_imn33_t = NULL
            LET g_imn43_t = NULL
        #FUN-BB0084 -----------End--------------
            LET b_imn.imn01=g_imm.imm01
            LET b_imn.imnplant = g_plant #FUN-980004
            LET b_imn.imnlegal = g_legal #FUN-980004
            LET g_imn[l_ac].imn29='N'     #FUN-5C0077
            LET g_imn[l_ac].imn10=0
            LET g_imn[l_ac].imn22=0
            LET g_imn[l_ac].imn21=1
            LET b_imn.imn041=g_s.imn041
            LET b_imn.imn151=g_s.imn151
            LET g_imn[l_ac].imn21=1
            LET g_imn[l_ac].imn9301=s_costcenter(g_imm.imm14) #FUN-670093
            LET g_imn[l_ac].imn9302=g_imn[l_ac].imn9301 #FUN-670093
            LET g_imn[l_ac].gem02b=s_costcenter_desc(g_imn[l_ac].imn9301) #FUN-670093
            LET g_imn[l_ac].gem02c=s_costcenter_desc(g_imn[l_ac].imn9302) #FUN-670093
            IF g_sma.sma115 = 'Y' THEN
               LET g_imn[l_ac].imn51=1
               LET g_imn[l_ac].imn52=1
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD imn02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err(g_imn[l_ac].imn03,9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
 
            IF g_sma.sma115 = 'Y' THEN
               CALL s_chk_va_setting(g_imn[l_ac].imn03)
                    RETURNING g_flag,g_ima906,g_ima907
               IF g_flag=1 THEN
                  NEXT FIELD imn03
               END IF
               CALL t720_du_data_to_correct()
            END IF
 
           #LET l_sql = "SELECT img09 FROM ",g_db_tra CLIPPED,"img_file ", #FUN-980093 add  #FUN-A50102
            LET l_sql = "SELECT img09 FROM ",cl_get_target_table(g_s.imn041,'img_file'),    #FUN-A50102
                        " WHERE img01='",g_imn[l_ac].imn03,"'",
                        "   AND img02='",g_imn[l_ac].imn04,"'",
                        "   AND img03='",g_imn[l_ac].imn05,"'",
                        "   AND img04='",g_imn[l_ac].imn06,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,g_s.imn041) RETURNING l_sql  #FUN-980093
            PREPARE img_c1 FROM l_sql
            DECLARE img_cur1 CURSOR FOR img_c1
            OPEN img_cur1
            FETCH img_cur1 INTO g_img09_s
            IF cl_null(g_img09_s) THEN
               #FUN-C80107 modify begin---------------------------------------121101
               #CALL cl_err(g_imn[l_ac].imn04,'mfg6069',0)
               #NEXT FIELD imn04
               LET g_flag1 = NULL
               #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_flag1  #FUN-D30024--mark
               CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_s.imn041) RETURNING g_flag1  #FUN-D30024--add  #TQC-D40078 g_s.imn041
               IF g_flag1 = 'N' OR g_flag1 IS NULL THEN
                  CALL cl_err(g_imn[l_ac].imn04,'mfg6069',0)
                  NEXT FIELD imn04
               ELSE
                  IF g_sma.sma892[3,3] = 'Y' THEN
                     IF NOT cl_confirm('mfg1401') THEN NEXT FIELD imn04 END IF
                  END IF
                  CALL s_add_img(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                                 g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                                 g_imm.imm01      ,g_imn[l_ac].imn02,
                                 g_imm.imm02)
                  IF g_errno='N' THEN
                     NEXT FIELD imn04
                  END IF
               END IF
               #FUN-C80107 modify end-----------------------------------------
            END IF
 
           #LET l_sql = "SELECT img09 FROM ",g_azp03_tra CLIPPED,"img_file ", #FUN-980093 add  #FUN-A50102
            LET l_sql = "SELECT img09 FROM ",cl_get_target_table(g_s.imn151,'img_file'),   #FUN-A50102
                        " WHERE img01='",g_imn[l_ac].imn03,"'",
                        "   AND img02='",g_imn[l_ac].imn15,"'",
                        "   AND img03='",g_imn[l_ac].imn16,"'",
                        "   AND img04='",g_imn[l_ac].imn17,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
            CALL cl_parse_qry_sql(l_sql,g_s.imn151) RETURNING l_sql  #FUN-980093
            PREPARE img_c2 FROM l_sql
            DECLARE img_cur2 CURSOR FOR img_c2
            OPEN img_cur2
            FETCH img_cur2 INTO g_img09_t
            IF cl_null(g_img09_t) THEN
               #FUN-C80107 modify begin--------------------------------------------121101
               #CALL cl_err(g_imn[l_ac].imn15,'mfg6069',0)
               #NEXT FIELD imn15
               IF NOT cl_confirm('mfg1401') THEN
                  CALL cl_err(g_imn[l_ac].imn15,'mfg6069',0)
                  NEXT FIELD imn15
               END IF
               CALL s_madd_img(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                               g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                               g_imm.imm01,      g_imn[l_ac].imn02,
                               g_imm.imm02,g_s.imn151)
               IF g_errno='N' THEN NEXT FIELD imn17 END IF
               #FUN-C80107 modify end----------------------------------------------
            END IF
 
            IF g_sma.sma115 = 'Y' THEN
               IF t720_qty_issue() THEN
                  NEXT FIELD imn30
               END IF
               CALL t720_set_origin_field()
            #FUN-BB0084 -----------Begin-------------
               DISPLAY BY NAME g_imn[l_ac].imn09
               DISPLAY BY NAME g_imn[l_ac].imn10
               DISPLAY BY NAME g_imn[l_ac].imn20
               DISPLAY BY NAME g_imn[l_ac].imn22
               DISPLAY BY NAME g_imn[l_ac].imn21
               DISPLAY BY NAME g_imn[l_ac].imn34
               DISPLAY BY NAME g_imn[l_ac].imn44 
            #FUN-BB0084 -----------End---------------
            END IF
 
            CALL t720_b_move_back()
            INSERT INTO imn_file VALUES(b_imn.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","imn_file",b_imn.imn01,"",SQLCA.sqlcode,"",
                            "ins imn",1)   #NO.FUN-640266 #No.FUN-660156
               CANCEL INSERT
            ELSE
               #FUN-B70074-add-str--
               IF NOT s_industry('std') THEN 
                  INITIALIZE l_imni.* TO NULL
                  LET l_imni.imni01 = b_imn.imn01
                  LET l_imni.imni02 = b_imn.imn02
                  IF NOT s_ins_imni(l_imni.*,b_imn.imnplant)  THEN 
                     CANCEL INSERT
                  END IF           
               END IF
               #FUN-B70074-add-end--
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
         BEFORE FIELD imn02                  #default 序號
             IF g_imn[l_ac].imn02 IS NULL OR g_imn[l_ac].imn02 = 0 THEN
                SELECT max(imn02)+1 INTO g_imn[l_ac].imn02
                  FROM imn_file WHERE imn01 = g_imm.imm01
                IF g_imn[l_ac].imn02 IS NULL THEN
                    LET g_imn[l_ac].imn02 = 1
                END IF
            END IF
 
        AFTER FIELD imn02                        #check 序號是否重複
            IF NOT cl_null(g_imn[l_ac].imn02) THEN
               IF g_imn[l_ac].imn02 != g_imn_t.imn02 OR
                  g_imn_t.imn02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM imn_file
                       WHERE imn01 = g_imm.imm01 AND imn02 = g_imn[l_ac].imn02
                   IF l_n > 0 THEN
                       LET g_imn[l_ac].imn02 = g_imn_t.imn02
                       CALL cl_err('',-239,0) NEXT FIELD imn02
                   END IF
               END IF
            END IF
 
        BEFORE FIELD imn03
           CALL t720_set_entry_b()
           CALL t720_set_no_required()
 
	AFTER FIELD imn03
#FUN-AA0059 ---------------------start----------------------------
            IF NOT cl_null(g_imn[l_ac].imn03) THEN
               IF NOT s_chk_item_no(g_imn[l_ac].imn03,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_imn[l_ac].imn03= g_imn_t.imn03
                  NEXT FIELD imn03
               END IF
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            CALL t720_check_imn03('imn03',l_ac) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
            IF NOT l_check_res THEN NEXT FIELD imn03 END IF           
            SELECT imaag INTO l_imaag FROM ima_file
             WHERE ima01=g_imn[l_ac].imn03
            IF (NOT cl_null(l_imaag)) AND (l_imaag != '@CHILD') THEN
                CALL cl_err(g_imn[l_ac].imn03,"aim1004",1)
                NEXT FIELD imn03
            END IF
      
      #以下是為料件多屬性機制新增的20個屬性欄位的AFTER FIELD代碼
      #下面是十個輸入型屬性欄位的判斷語句 
      AFTER FIELD att00                                                                                                             
          #檢查att00里面輸入的母料件是否是符合對應屬性組的母料件                                                                    
          SELECT COUNT(ima01) INTO l_count FROM ima_file                                                                            
            WHERE ima01 = g_imn[l_ac].att00 AND imaag = lg_smy62                                                                    
          IF l_count = 0 THEN                                                                                                       
             CALL cl_err_msg('','aim-909',lg_smy62,0)                                                                               
             NEXT FIELD att00                                                                                                       
          END IF                                                                                                                    
 
          IF p_cmd='u' THEN                                                                                                         
             CALL  cl_set_comp_entry("att01,att01_c,att02,att02_c,att03,att03_c,                                                    
                                    att04,att04_c,att05,att05_c,att06,att06_c,                                                      
                                    att07,att07_c,att08,att08_c,att09,att09_c,                                                      
                                    att10,att10_c",TRUE)  
          END IF
                                                                                                                                  
      AFTER FIELD att01
          CALL t720_check_att0x(g_imn[l_ac].att01,1,l_ac) RETURNING
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att01 END IF              
      AFTER FIELD att02
          CALL T720_check_att0x(g_imn[l_ac].att02,2,l_ac) RETURNING
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att02 END IF
      AFTER FIELD att03
          CALL t720_check_att0x(g_imn[l_ac].att03,3,l_ac) RETURNING
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att03 END IF
      AFTER FIELD att04
          CALL t720_check_att0x(g_imn[l_ac].att04,4,l_ac) RETURNING
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att04 END IF
      AFTER FIELD att05
          CALL t720_check_att0x(g_imn[l_ac].att05,5,l_ac) RETURNING
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att05 END IF          
      AFTER FIELD att06
          CALL t720_check_att0x(g_imn[l_ac].att06,6,l_ac) RETURNING
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att06 END IF
      AFTER FIELD att07
          CALL t720_check_att0x(g_imn[l_ac].att07,7,l_ac) RETURNING
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att07 END IF
      AFTER FIELD att08
          CALL t720_check_att0x(g_imn[l_ac].att08,8,l_ac) RETURNING
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att08 END IF
      AFTER FIELD att09
          CALL t720_check_att0x(g_imn[l_ac].att09,9,l_ac) RETURNING
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att09 END IF
      AFTER FIELD att10
          CALL t720_check_att0x(g_imn[l_ac].att10,10,l_ac) RETURNING
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att10 END IF
      #下面是十個輸入型屬性欄位的判斷語句
      AFTER FIELD att01_c
          CALL t720_check_att0x_c(g_imn[l_ac].att01_c,1,l_ac) RETURNING
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att01_c END IF      
      AFTER FIELD att02_c
          CALL t720_check_att0x_c(g_imn[l_ac].att02_c,2,l_ac) RETURNING
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att02_c END IF
      AFTER FIELD att03_c
          CALL t720_check_att0x_c(g_imn[l_ac].att03_c,3,l_ac) RETURNING
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att03_c END IF
      AFTER FIELD att04_c
          CALL t720_check_att0x_c(g_imn[l_ac].att04_c,4,l_ac) RETURNING
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att04_c END IF
      AFTER FIELD att05_c
          CALL t720_check_att0x_c(g_imn[l_ac].att05_c,5,l_ac) RETURNING
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att05_c END IF
      AFTER FIELD att06_c
          CALL t720_check_att0x_c(g_imn[l_ac].att06_c,6,l_ac) RETURNING
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att06_c END IF
      AFTER FIELD att07_c
          CALL t720_check_att0x_c(g_imn[l_ac].att07_c,7,l_ac) RETURNING
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att07_c END IF
      AFTER FIELD att08_c
          CALL t720_check_att0x_c(g_imn[l_ac].att08_c,8,l_ac) RETURNING
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att08_c END IF
      AFTER FIELD att09_c
          CALL t720_check_att0x_c(g_imn[l_ac].att09_c,9,l_ac) RETURNING
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att09_c END IF
      AFTER FIELD att10_c
          CALL t720_check_att0x_c(g_imn[l_ac].att10_c,10,l_ac) RETURNING
               l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
          IF NOT l_check_res THEN NEXT FIELD att10_c END IF
 
 
        #FUN-CB0087--add--str
        BEFORE FIELD imn28
           IF g_aza.aza115 = 'Y' AND cl_null(g_imn[l_ac].imn28) THEN
              LET l_store = ''
              IF NOT cl_null(g_imn[l_ac].imn04) THEN
                 LET l_store = l_store,g_imn[l_ac].imn04
              END IF
              IF NOT cl_null(g_imn[l_ac].imn15) THEN
                 IF NOT cl_null(l_store) THEN
                    LET l_store = l_store,"','",g_imn[l_ac].imn15
                 ELSE
                    LET l_store = l_store,g_imn[l_ac].imn15
                 END IF
              END IF
              CALL s_reason_code(g_imm.imm01,'','',g_imn[l_ac].imn03,l_store,'',g_imm.imm14) RETURNING g_imn[l_ac].imn28
              CALL t720_azf03()            
              DISPLAY BY NAME g_imn[l_ac].imn28
           END IF
        #FUN-CB0087--add--end
        AFTER FIELD imn28
            IF NOT cl_null(g_imn[l_ac].imn28) THEN
              #FUN-CB0087---add---str
              IF g_aza.aza115='Y' THEN
                 IF NOT t720_imn28_chk1() THEN
                    NEXT FIELD imn28
                 ELSE
                    CALL t720_azf03()
                 END IF
              ELSE
              #FUN-CB0087---add---end
               SELECT azf09 INTO l_azf09 FROM azf_file
                WHERE azf01=g_imn[l_ac].imn28 AND azf02='2'
               IF l_azf09 != '6' THEN
                  CALL cl_err('','aoo-405',0)
                  NEXT FIELD imn28
               END IF
               SELECT azf03 INTO g_buf FROM azf_file
                WHERE azf01=g_imn[l_ac].imn28 AND azf02='2' #6818
               IF STATUS THEN
                  CALL cl_err3("sel","azf_file",g_imn[l_ac].imn28,"",
                                SQLCA.sqlcode,"","select azf",1)   #NO.FUN-640266 #No.FUN-660156
                 NEXT FIELD imn28
               END IF
               END IF                          #FUN-CB0087
               MESSAGE g_buf
               DISPLAY g_buf TO g_imn[l_ac].azf03    #FUN-CB0087
            END IF
 
        AFTER FIELD imn04  #倉庫
           IF NOT cl_null(g_imn[l_ac].imn04) THEN
              #FUN-D20060----add---str--
              IF NOT s_chksmz(g_imn[l_ac].imn03, g_imm.imm01,
                              g_imn[l_ac].imn04, g_imn[l_ac].imn05) THEN
                 NEXT FIELD imn04
              END IF
              #FUN-D20060----add---end--
              #FUN-C20002--start add------------------------
              IF g_azw.azw04 = '2' THEN 
                 SELECT ima154 INTO l_ima154
                   FROM ima_file
                  WHERE ima01 = g_imn[l_ac].imn03
                 IF l_ima154 = 'Y' AND g_imn[l_ac].imn03[1,4] <> 'MISC' THEN
                    SELECT rcj03 INTO l_rcj03
                      FROM rcj_file
                     WHERE rcj00 = '0' 

                    #FUN-C90049 mark begin---
                    #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08
                    #  FROM rtz_file
                    # WHERE rtz01 = g_plant   
                    #FUN-C90049 markend-----

                    CALL s_get_defstore(g_plant,g_imn[l_ac].imn03) RETURNING l_rtz07,l_rtz08   #FUN-C90049 add

                     IF l_rcj03 = '1' THEN
                        IF g_imn[l_ac].imn04 <> l_rtz07 THEN
                           CALL cl_err('','aim1142',0)
                           LET g_imn[l_ac].imn04 = g_imn_t.imn04
                           NEXT FIELD imn04
                        END IF  
                     ELSE
                        IF g_imn[l_ac].imn04 <> l_rtz08 THEN
                           CALL cl_err('','aim1143',0)
                           LET g_imn[l_ac].imn04 = g_imn_t.imn04
                           NEXT FIELD imn04
                        END IF    
                     END IF 
                 END IF    
              END IF          
              #FUN-C20002--end add--------------------------   
              #No.FUN-AB0067--begin    
              IF NOT s_chk_ware(g_imn[l_ac].imn04) THEN
                 NEXT FIELD imn04
              END IF               
              #No.FUN-AB0067--end
              IF NOT s_stkchk(g_imn[l_ac].imn04,'A') THEN
                 CALL cl_err(g_imn[l_ac].imn04,'mfg6076',0)
                 NEXT FIELD imn04
              END IF
              CALL s_swyn(g_imn[l_ac].imn04) RETURNING sn1,sn2
    	      IF sn1=1 AND g_imn[l_ac].imn04!=t_imn04
              THEN CALL cl_err(g_imn[l_ac].imn04,'mfg6080',0)
                   LET t_imn04=g_imn[l_ac].imn04
                   NEXT FIELD imn04
              ELSE IF sn2=2 AND g_imn[l_ac].imn04!=t_imn04
                   THEN CALL cl_err(g_imn[l_ac].imn04,'mfg6085',0)
                        LET t_imn04=g_imn[l_ac].imn04
                        NEXT FIELD imn04
                   END IF
              END IF
              LET sn1=0 LET sn2=0
           END IF
           LET g_imn_t.imn04=g_imn[l_ac].imn04   #FUN-5B0125
           NEXT FIELD imn05                      #No.TQC-750014 add
 
        AFTER FIELD imn05  #儲位
           IF g_imn[l_ac].imn05 IS NULL THEN LET g_imn[l_ac].imn05=' ' END IF
           IF g_imn[l_ac].imn05 = '　' THEN LET g_imn[l_ac].imn05 = ' ' END IF #全型空白
           #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
           LET g_azp03_o = t720_catstr(g_dbs)
           LET g_buf = s_get_doc_no(g_imm.imm01)    #No.MOD-590297
           IF NOT s_chksmz1(g_imn[l_ac].imn03, g_buf,    #No.MOD-590297
              g_imn[l_ac].imn04, g_imn[l_ac].imn05,g_s.imn041) THEN #FUN-980093 add
              NEXT FIELD imn04
           END IF
            #FUN-D20060----add---str--
            IF NOT cl_null(g_imn[l_ac].imn04) THEN
               IF NOT s_chksmz(g_imn[l_ac].imn03, g_imm.imm01,
                               g_imn[l_ac].imn04, g_imn[l_ac].imn05) THEN
                  NEXT FIELD imn04
               END IF
            END IF
            #FUN-D20060----add---end--
           #---->需存在倉庫/儲位檔中
            IF g_imn[l_ac].imn05 IS NOT NULL THEN
               IF sn1=1 AND g_imn[l_ac].imn05!=t_imn05
               THEN CALL cl_err(g_imn[l_ac].imn05,'mfg6081',0)
                    LET t_imn05=g_imn[l_ac].imn05
                    NEXT FIELD imn05
               ELSE IF sn2=2 AND g_imn[l_ac].imn05!=t_imn05
                    THEN CALL cl_err(g_imn[l_ac].imn05,'mfg6086',0)
                         LET t_imn05=g_imn[l_ac].imn05
                    NEXT FIELD imn05
                    END IF
               END IF
	       LET sn1=0 LET sn2=0
            END IF
            LET g_imn_t.imn05=g_imn[l_ac].imn05   #FUN-5B0125
            NEXT FIELD imn06                      #No.TQC-750014 add
 
        AFTER FIELD imn06  #批號
           IF g_imn[l_ac].imn06 IS NULL THEN LET g_imn[l_ac].imn06=' ' END IF
           IF g_imn[l_ac].imn06 = '　' THEN LET g_imn[l_ac].imn06 = ' ' END IF #全型空白
          #LET l_sql = "SELECT img09,img10 FROM ",g_db_tra CLIPPED,"img_file ", #FUN-980093 add   #FUN-A50102
           LET l_sql = "SELECT img09,img10 FROM ",cl_get_target_table(g_s.imn041,'img_file'),     #FUN-A50102
                       " WHERE img01='",g_imn[l_ac].imn03,"'",
                       "   AND img02='",g_imn[l_ac].imn04,"'",
                       "   AND img03='",g_imn[l_ac].imn05,"'",
                       "   AND img04='",g_imn[l_ac].imn06,"'"
 	   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,g_s.imn041) RETURNING l_sql  #FUN-980093
           PREPARE img_c3 FROM l_sql
           DECLARE img_cur3 CURSOR FOR img_c3
           OPEN img_cur3
           FETCH img_cur3 INTO g_img09_s,g_img10_s
           LET g_imn[l_ac].imn09 = g_img09_s
           LET l_img10 = g_img10_s
           IF SQLCA.sqlcode THEN
               #FUN-C80107 add begin-------------------------121101
               IF cl_null(g_imn[l_ac].imn04) THEN
                  CALL cl_err(g_imn[l_ac].imn04,'aim-149',0)
                  NEXT FIELD imn04
               END IF
               #FUN-C80107 add end----------------------------
               LET l_img10 = 0
               #FUN-C80107 modify begin---------------------------------------121101
               #CALL cl_err(g_imn[l_ac].imn06,'mfg6101',0)
               #NEXT FIELD imn04
               LET g_flag1 = NULL
               #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_flag1   #FUN-D30024--mark
               CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_s.imn041) RETURNING g_flag1   #FUN-D30024--add #TQC-D40078 g_s.imn041
               IF g_flag1 = 'N' OR g_flag1 IS NULL THEN
                  CALL cl_err(g_imn[l_ac].imn06,'mfg6101',0)
                  NEXT FIELD imn04
               ELSE
                  IF g_sma.sma892[3,3] = 'Y' THEN
                     IF NOT cl_confirm('mfg1401') THEN NEXT FIELD imn04 END IF
                  END IF
                  CALL s_add_img(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                                 g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                                 g_imm.imm01      ,g_imn[l_ac].imn02,
                                 g_imm.imm02)
                  IF g_errno='N' THEN
                     NEXT FIELD imn04
                  END IF
               END IF
               #FUN-C80107 modify end-----------------------------------------
           END IF
           DISPLAY g_imn[l_ac].imn09 TO imn09
        #FUN-BB0084 ---------------Begin----------------
           IF NOT cl_null(g_imn[l_ac].imn09) AND NOT cl_null(g_imn[l_ac].imn10) THEN
              LET g_imn[l_ac].imn10 = s_digqty(g_imn[l_ac].imn10,g_imn[l_ac].imn09)
              DISPLAY g_imn[l_ac].imn10 TO imn10
           END IF
        #FUN-BB0084 ---------------End------------------
           #-->有效日期
           IF NOT s_actimg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                           g_imn[l_ac].imn05,g_imn[l_ac].imn06)
           THEN CALL cl_err('inactive','mfg6117',0)
                NEXT FIELD imn04
           END IF
           IF p_cmd = 'u' THEN
              CALL t720_chk_out() RETURNING g_i
              IF g_i THEN
                 NEXT FIELD imn06
              END IF
           END IF
           IF g_sma.sma115 = 'Y' THEN
              IF g_imn_t.imn03 IS NULL OR g_imn[l_ac].imn03 <> g_imn_t.imn03 OR
                 g_imn_t.imn04 IS NULL OR g_imn[l_ac].imn04 <> g_imn_t.imn04 OR
                 g_imn_t.imn05 IS NULL OR g_imn[l_ac].imn05 <> g_imn_t.imn05 OR
                 g_imn_t.imn06 IS NULL OR g_imn[l_ac].imn06 <> g_imn_t.imn06 THEN
                 CALL t720_du_default(p_cmd,g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                                      g_imn[l_ac].imn05,g_imn[l_ac].imn06)
                      RETURNING g_imn[l_ac].imn33,g_imn[l_ac].imn34,g_imn[l_ac].imn35,
                                g_imn[l_ac].imn30,g_imn[l_ac].imn31,g_imn[l_ac].imn32
              END IF
           END IF
           LET g_imn_t.imn06=g_imn[l_ac].imn06
 
        BEFORE FIELD imn33
           CALL t720_set_no_required()
 
        AFTER FIELD imn33  #第二單位
           IF cl_null(g_imn[l_ac].imn03) THEN NEXT FIELD imn03 END IF
           IF g_imn[l_ac].imn04 IS NULL OR g_imn[l_ac].imn05 IS NULL OR
              g_imn[l_ac].imn06 IS NULL THEN
              NEXT FIELD imn04
           END IF
           IF NOT cl_null(g_imn[l_ac].imn33) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_imn[l_ac].imn33
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_imn[l_ac].imn33,"",
                               SQLCA.sqlcode,"","gfe:",1)   #No.FUN-660156
                 NEXT FIELD imn33
              END IF
              CALL s_du_umfchk(g_imn[l_ac].imn03,'','','',
                               g_img09_s,g_imn[l_ac].imn33,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imn[l_ac].imn33,g_errno,0)
                 NEXT FIELD imn33
              END IF
              IF cl_null(g_imn_t.imn33) OR g_imn_t.imn33 <> g_imn[l_ac].imn33 THEN
                 LET g_imn[l_ac].imn34 = g_factor
              END IF
              #多工廠查詢imgg_file中是否存在雙單位資料
              CALL s_mchk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                               g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                              #g_imn[l_ac].imn33,g_dbs) RETURNING g_flag #FUN-980093 mark
                               g_imn[l_ac].imn33,g_s.imn041) RETURNING g_flag #FUN-980093 add
              IF g_flag = 1 THEN
                 #FUN-C80107 modify begin---------------------------------------121101
                 #CALL cl_err('sel img:',STATUS,0)
                 #NEXT FIELD imn33
                 LET g_flag1 = NULL
                 #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_flag1  #FUN-D30024--mark
                 CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_s.imn041) RETURNING g_flag1  #FUN-D30024--add #TQC-D40078 g_s.imn041
                 IF g_flag1 = 'N' OR g_flag1 IS NULL THEN
                    CALL cl_err('sel imgg:',STATUS,0)
                    NEXT FIELD imn33
                 ELSE
                    IF g_sma.sma892[3,3] = 'Y' THEN
                       IF g_bgjob='N' OR cl_null(g_bgjob) THEN
                          IF NOT cl_confirm('aim-995') THEN
                             NEXT FIELD imn33
                          END IF
                       END IF
                    END IF
                    CALL s_add_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                                    g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                                    g_imn[l_ac].imn33,g_imn[l_ac].imn34,
                                    g_imm.imm01,g_imn[l_ac].imn02,0)
                          RETURNING g_flag
                    IF g_flag = 1 THEN
                       NEXT FIELD imn33
                    END IF
                 END IF
                 #FUN-C80107 modify end-----------------------------------------
              END IF
           END IF
           CALL t720_set_required()
           LET g_imn_t.imn33=g_imn[l_ac].imn33
#FUN-BB0084 ----------------Begin--------------
           IF NOT t720_imn35_chk(p_cmd) THEN
              LET g_imn33_t=g_imn[l_ac].imn33
              NEXT FIELD imn35
           END IF
           LET g_imn33_t=g_imn[l_ac].imn33
#FUN-BB0084 ----------------End----------------
 
        BEFORE FIELD imn34  #第二轉換率
           IF cl_null(g_imn[l_ac].imn03) THEN NEXT FIELD imn03 END IF
           IF g_imn[l_ac].imn04 IS NULL OR g_imn[l_ac].imn05 IS NULL OR
              g_imn[l_ac].imn06 IS NULL THEN
              NEXT FIELD imn04
           END IF
           IF NOT cl_null(g_imn[l_ac].imn33) AND g_ima906 = '3' THEN
              #多工廠查詢imgg_file中是否存在雙單位資料
              CALL s_mchk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                               g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                               g_imn[l_ac].imn33,g_s.imn041) RETURNING g_flag #FUN-980093 add
              IF g_flag = 1 THEN
                 #FUN-C80107 modify begin---------------------------------------121101
                 #CALL cl_err('sel img:',STATUS,0)
                 #NEXT FIELD imn04
                 LET g_flag1 = NULL
                 #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_flag1  #FUN-D30024--mark
                 CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_s.imn041) RETURNING g_flag1  #FUN-D30024--add #TQC-D40078 g_s.imn041
                 IF g_flag1 = 'N' OR g_flag1 IS NULL THEN
                    CALL cl_err('sel imgg:',STATUS,0)
                    NEXT FIELD imn04
                 ELSE
                    IF g_sma.sma892[3,3] = 'Y' THEN
                       IF g_bgjob='N' OR cl_null(g_bgjob) THEN
                          IF NOT cl_confirm('aim-995') THEN
                             NEXT FIELD imn04
                          END IF
                       END IF
                    END IF
                    CALL s_add_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                                    g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                                    g_imn[l_ac].imn33,g_imn[l_ac].imn34,
                                    g_imm.imm01,g_imn[l_ac].imn02,0)
                          RETURNING g_flag
                    IF g_flag = 1 THEN
                       NEXT FIELD imn04
                    END IF
                 END IF
                 #FUN-C80107 modify end-----------------------------------------
              END IF
           END IF
 
        AFTER FIELD imn34  #第二轉換率
           IF NOT cl_null(g_imn[l_ac].imn34) THEN
              IF g_imn[l_ac].imn34=0 THEN
                 NEXT FIELD imn34
              END IF
           END IF
 
        BEFORE FIELD imn35
           IF cl_null(g_imn[l_ac].imn03) THEN NEXT FIELD imn03 END IF
           IF g_imn[l_ac].imn04 IS NULL OR g_imn[l_ac].imn05 IS NULL OR
              g_imn[l_ac].imn06 IS NULL THEN
              NEXT FIELD imn04
           END IF
           IF NOT cl_null(g_imn[l_ac].imn33) AND g_ima906 = '3' THEN
              #多工廠查詢imgg_file中是否存在雙單位資料
              CALL s_mchk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                               g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                               g_imn[l_ac].imn33,g_s.imn041) RETURNING g_flag #FUN-980093 add
              IF g_flag = 1 THEN
                 #FUN-C80107 modify begin---------------------------------------121101
                 #CALL cl_err('sel img:',STATUS,0)
                 #NEXT FIELD imn04
                 LET g_flag1 = NULL
                 #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_flag1  #FUN-D30024--mark
                 CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_s.imn041) RETURNING g_flag1  #FUN-D30024--add  #TQC-D40078 g_s.imn041
                 IF g_flag1 = 'N' OR g_flag1 IS NULL THEN
                    CALL cl_err('sel imgg:',STATUS,0)
                    NEXT FIELD imn04
                 ELSE
                    IF g_sma.sma892[3,3] = 'Y' THEN
                       IF g_bgjob='N' OR cl_null(g_bgjob) THEN
                          IF NOT cl_confirm('aim-995') THEN
                             NEXT FIELD imn04
                          END IF
                       END IF
                    END IF
                    CALL s_add_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                                    g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                                    g_imn[l_ac].imn33,g_imn[l_ac].imn34,
                                    g_imm.imm01,g_imn[l_ac].imn02,0)
                          RETURNING g_flag
                    IF g_flag = 1 THEN
                       NEXT FIELD imn04
                    END IF
                 END IF
                 #FUN-C80107 modify end-----------------------------------------
              END IF
           END IF
 
        AFTER FIELD imn35  #第二數量
#FUN-BB0084 -----------------Begin-------------------
           IF NOT t720_imn35_chk(p_cmd) THEN 
              NEXT FIELD imn35 
           END IF
#FUN-BB0084 -----------------End---------------------
#FUN-BB0084 -----------------Begin-------------------
#          IF NOT cl_null(g_imn[l_ac].imn35) THEN
#             IF g_imn[l_ac].imn35 < 0 THEN
#                CALL cl_err('','aim-391',0)  #
#                NEXT FIELD imn35
#             END IF
#             IF p_cmd = 'a' THEN
#                IF g_ima906='3' THEN
#                   LET g_tot=g_imn[l_ac].imn35*g_imn[l_ac].imn34
#                   IF cl_null(g_imn[l_ac].imn32) OR g_imn[l_ac].imn32=0 THEN #CHI-960022
#                      LET g_imn[l_ac].imn32=g_tot*g_imn[l_ac].imn31
#                   END IF                                                    #CHI-960022
#                END IF
#             END IF
#          END IF
#FUN-BB0084 -----------------End--------------------
 
        BEFORE FIELD imn30
           CALL t720_set_no_required()
 
        AFTER FIELD imn30  #第一單位
           IF cl_null(g_imn[l_ac].imn03) THEN NEXT FIELD imn03 END IF
           IF g_imn[l_ac].imn04 IS NULL OR g_imn[l_ac].imn05 IS NULL OR
              g_imn[l_ac].imn06 IS NULL THEN
              NEXT FIELD imn04
           END IF
           IF NOT cl_null(g_imn[l_ac].imn30) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_imn[l_ac].imn30
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_imn[l_ac].imn30,"",
                               SQLCA.sqlcode,"","gfe:",1)  #No.FUN-660156
                 NEXT FIELD imn30
              END IF
              CALL s_du_umfchk(g_imn[l_ac].imn03,'','','',
                               g_imn[l_ac].imn09,g_imn[l_ac].imn30,'1') #No.CHI-960052
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imn[l_ac].imn30,g_errno,0)
                 NEXT FIELD imn30
              END IF
              IF cl_null(g_imn_t.imn30) OR g_imn_t.imn30 <> g_imn[l_ac].imn30 THEN
                 LET g_imn[l_ac].imn31 = g_factor
              END IF
              IF g_ima906 = '2' THEN
                 #多工廠查詢imgg_file中是否存在雙單位資料
                 CALL s_mchk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                                  g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                                  g_imn[l_ac].imn30,g_s.imn041) RETURNING g_flag #FUN-980093 add
                 IF g_flag = 1 THEN
                    #FUN-C80107 modify begin---------------------------------------121101
                    #CALL cl_err('sel img:',STATUS,0)
                    #NEXT FIELD imn30
                    LET g_flag1 = NULL
                    #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_flag1 #FUN-D30024--mark
                    CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_s.imn041) RETURNING g_flag1 #FUN-D30024--add  #TQC-D40078 g_s.imn041
                    IF g_flag1 = 'N' OR g_flag1 IS NULL THEN
                       CALL cl_err('sel imgg:',STATUS,0)
                       NEXT FIELD imn30
                    ELSE
                       IF g_sma.sma892[3,3] = 'Y' THEN
                          IF g_bgjob='N' OR cl_null(g_bgjob) THEN
                             IF NOT cl_confirm('aim-995') THEN
                                NEXT FIELD imn30
                             END IF
                          END IF
                       END IF
                       CALL s_add_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                                       g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                                       g_imn[l_ac].imn30,g_imn[l_ac].imn31,
                                       g_imm.imm01,g_imn[l_ac].imn02,0)
                             RETURNING g_flag
                       IF g_flag = 1 THEN
                          NEXT FIELD imn30
                       END IF
                    END IF
                    #FUN-C80107 modify end-----------------------------------------
                 END IF
              END IF
           END IF
           CALL t720_set_required()
           LET g_imn_t.imn30=g_imn[l_ac].imn30
    #FUN-BB0084 -------------Begin-------------
           IF NOT t720_imn32_chk() THEN
              LET g_imn30_t = g_imn[l_ac].imn30
              NEXT FIELD imn32
           END IF
           LET g_imn30_t = g_imn[l_ac].imn30
    #FUN-BB0084 -------------End---------------
 
        AFTER FIELD imn31  #第一轉換率
           IF NOT cl_null(g_imn[l_ac].imn31) THEN
              IF g_imn[l_ac].imn31=0 THEN
                 NEXT FIELD imn31
              END IF
           END IF
 
        AFTER FIELD imn32  #第一數量
#FUN-BB0084 --------------Begin------------------
           IF NOT t720_imn32_chk() THEN
              NEXT FIELD imn32
           END IF  
#FUN-BB0084 --------------End--------------------
#FUN-BB0084 --------------Begin------------------
#          IF NOT cl_null(g_imn[l_ac].imn32) THEN
#             IF g_imn[l_ac].imn32 < 0 THEN
#                CALL cl_err('','aim-391',0)  #
#                NEXT FIELD imn32
#             END IF
#          END IF
#FUN-BB0084 --------------End--------------------
 
        AFTER FIELD imn10  #調撥數量
            IF NOT cl_null(g_imn[l_ac].imn10) THEN
               IF g_imn[l_ac].imn10 <= 0 THEN
                  CALL cl_err('','mfg9105',0)
                  NEXT FIELD imn10
               END IF
     #FUN-BB0084 ---------------Begin----------------
               IF NOT cl_null(g_imn[l_ac].imn09) THEN
                  IF cl_null(g_imn_t.imn10) OR g_imn_t.imn10! = g_imn[l_ac].imn10 THEN
                     LET g_imn[l_ac].imn10 = s_digqty(g_imn[l_ac].imn10,g_imn[l_ac].imn09)
                     DISPLAY BY NAME g_imn[l_ac].imn10
                  END IF
               END IF 
     #FUN-BB0084 ---------------End------------------
               IF p_cmd = 'u' THEN
                  LET g_imn[l_ac].imn22 = g_imn[l_ac].imn10 * g_imn[l_ac].imn21
                  LET g_imn[l_ac].imn22 = s_digqty(g_imn[l_ac].imn22,g_imn[l_ac].imn20)   #FUN-BB0084
                  DISPLAY BY NAME g_imn[l_ac].imn22
               END IF
               IF g_imn[l_ac].imn10 > l_img10 THEN
                 #IF g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN  #FUN-C80107 mark
                  LET g_flag1 = NULL    #FUN-C80107 add
                  #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_flag1   #FUN-C80107 add #FUN-D30024--mark
                  CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_s.imn041) RETURNING g_flag1         #FUN-D30024--add #TQC-D40078 g_s.imn041
                  IF g_flag1 = 'N' OR g_flag1 IS NULL THEN           #FUN-C80107 add
                     CALL cl_err(l_img10,'mfg3471',0)
                     NEXT FIELD imn10
                  ELSE
                     IF NOT cl_confirm('mfg3469') THEN
                        NEXT FIELD imn10
                     END IF
                  END IF
               END IF
            END IF
            IF g_imn[l_ac].imn09 != g_imn[l_ac].imn20 THEN
               LET g_azp03_o = t720_catstr(g_azp03)
               CALL s_umfchk1(g_imn[l_ac].imn03,g_imn[l_ac].imn09,
                              g_imn[l_ac].imn20,g_s.imn151) #FUN-980093 add
               RETURNING g_cnt,g_imn[l_ac].imn21
               IF g_cnt = 1 THEN
                  CALL cl_err('','mfg3075',1)
                  NEXT FIELD imn17
               END IF
            ELSE
               LET g_imn[l_ac].imn21=1
            END IF
            LET g_imn[l_ac].imn22=g_imn[l_ac].imn10*g_imn[l_ac].imn21
            LET g_imn[l_ac].imn22=s_digqty(g_imn[l_ac].imn22,g_imn[l_ac].imn20)    #FUN-BB0084
            DISPLAY BY NAME g_imn[l_ac].imn22
#           DISPLAY BY NAME g_imn[l_ac].imn21
#------目的倉庫------------------------------------------------
        AFTER FIELD imn15  #倉庫
            IF NOT cl_null(g_imn[l_ac].imn15) THEN
               #FUN-D20060----add---str--
               IF NOT s_chksmz(g_imn[l_ac].imn03, g_imm.imm01,
                               g_imn[l_ac].imn15, g_imn[l_ac].imn16) THEN
                  NEXT FIELD imn15
               END IF
               #FUN-D20060----add---end--
               #FUN-C20002--start add------------------------
               IF g_azw.azw04 = '2' THEN
                  SELECT ima154 INTO l_ima154
                    FROM ima_file
                   WHERE ima01 = g_imn[l_ac].imn03
                  IF l_ima154 = 'Y' AND g_imn[l_ac].imn03[1,4] <> 'MISC' THEN
                     SELECT rcj03 INTO l_rcj03
                       FROM rcj_file
                      WHERE rcj00 = '0'  

                     #FUN-C90049 mark begin---
                     #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08
                     #  FROM rtz_file
                     # WHERE rtz01 = b_imn.imn151
                     #FUN-C90049 mark end-----

                     CALL s_get_defstore(b_imn.imn151,g_imn[l_ac].imn03) RETURNING l_rtz07,l_rtz08   #FUN-C90049 add
                     IF l_rcj03 = '1' THEN
                        IF g_imn[l_ac].imn15 <> l_rtz07 THEN
                           CALL cl_err('','aim1142',0)
                           LET g_imn[l_ac].imn15 = g_imn_t.imn15
                           NEXT FIELD imn15
                        END IF
                     ELSE
                        IF g_imn[l_ac].imn15 <> l_rtz08 THEN
                           CALL cl_err('','aim1143',0)
                           LET g_imn[l_ac].imn15 = g_imn_t.imn15
                           NEXT FIELD imn15
                        END IF
                     END IF
                  END IF
               END IF
               #FUN-C20002--end add--------------------------
               #No.FUN-AB0067--begin    
               IF NOT s_chk_ware1(g_imn[l_ac].imn15,g_s.imn151) THEN
                  NEXT FIELD imn15
               END IF               
               #No.FUN-AB0067--end               
               IF NOT s_imfchk12(g_imn[l_ac].imn03,g_imn[l_ac].imn15,g_s.imn151) #FUN-980093 add
                  THEN CALL cl_err(g_imn[l_ac].imn15,'mfg9036',0)
                       NEXT FIELD imn15
               END IF
               CALL s_stkchk2(g_s.imn151,g_imn[l_ac].imn15,'A') RETURNING l_code #FUN-980093 mark
               IF NOT l_code THEN
                  CALL cl_err(g_imn[l_ac].imn15,l_code,1)
                  NEXT FIELD imn15
               END IF
               CALL  s_swyn1(g_imn[l_ac].imn15,g_s.imn151) RETURNING sn1,sn2 #FUN-980093 add
               IF sn1=1 AND g_imn[l_ac].imn15!=t_imn15
                  THEN CALL cl_err(g_imn[l_ac].imn15,'mfg6080',1)
                       LET t_imn15=g_imn[l_ac].imn15
                       NEXT FIELD imn15
               ELSE IF sn2=2 AND g_imn[l_ac].imn15!=t_imn15
                    THEN CALL cl_err(g_imn[l_ac].imn15,'mfg6085',0)
                         LET t_imn15=g_imn[l_ac].imn15
                         NEXT FIELD imn15
                    END IF
               END IF
            END IF
            LET g_imn_t.imn15=g_imn[l_ac].imn15   #FUN-5B0125
            NEXT FIELD imn16                      #FUN-5B0125
 
        AFTER FIELD imn16  #儲位
           IF g_imn[l_ac].imn16 IS NULL THEN LET g_imn[l_ac].imn16=' ' END IF
           IF g_imn[l_ac].imn16 = '　' THEN LET g_imn[l_ac].imn16 = ' ' END IF #全型空白
           #FUN-D20060----add---str--
           IF g_imn[l_ac].imn15 IS NOT NULL THEN
              IF NOT s_chksmz(g_imn[l_ac].imn03, g_imm.imm01,
                              g_imn[l_ac].imn15, g_imn[l_ac].imn16) THEN
                 NEXT FIELD imn15
              END IF
           END IF
           #FUN-D20060----add---end--
            #------>chk-1
            IF NOT s_imfchk11(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                              g_imn[l_ac].imn16,g_s.imn151) #FUN-980093 add
            THEN CALL cl_err(g_imn[l_ac].imn16,'mfg6095',0)
                 NEXT FIELD imn16
            END IF
            CALL s_hqty1(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                         g_imn[l_ac].imn16,g_s.imn151) #FUN-980093 add
                    RETURNING g_cnt,t_imf04,t_imf05
                LET h_qty=t_imf04
            CALL  s_lwyn1(g_imn[l_ac].imn15,g_imn[l_ac].imn16,g_s.imn151) #FUN-980093 add
                          RETURNING sn1,sn2
            IF sn1=1 AND g_imn[l_ac].imn16!=t_imn16
            THEN CALL cl_err(g_imn[l_ac].imn16,'mfg6081',0)
                 LET t_imn16=g_imn[l_ac].imn16
                 NEXT FIELD imn16
            ELSE IF sn2=2 AND g_imn[l_ac].imn16!=t_imn16
                    THEN CALL cl_err(g_imn[l_ac].imn16,'mfg6086',0)
                         LET t_imn16=g_imn[l_ac].imn16
                    NEXT FIELD imn16
                 END IF
           END IF
           LET sn1=0 LET sn2=0
           LET g_imn_t.imn16=g_imn[l_ac].imn16   #FUN-5B0125
           NEXT FIELD imn17                      #FUN-5B0125
 
        AFTER FIELD imn17
           IF g_imn[l_ac].imn17 IS NULL THEN LET g_imn[l_ac].imn17=' ' END IF
           IF g_imn[l_ac].imn17 = '　' THEN LET g_imn[l_ac].imn17 = ' ' END IF #全型空白
          #LET l_sql="SELECT img09 FROM ",g_azp03_tra CLIPPED,"img_file", #FUN-980093 add  #FUN-A50102
           LET l_sql="SELECT img09 FROM ",cl_get_target_table(g_s.imn151,'img_file'),      #FUN-A50102
                     " WHERE img01='",g_imn[l_ac].imn03 CLIPPED,"' AND",
                     " img02='",g_imn[l_ac].imn15 ,"' AND",
                     " img03='",g_imn[l_ac].imn16 ,"' AND",
                     " img04='",g_imn[l_ac].imn17 ,"'"
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
           CALL cl_parse_qry_sql(l_sql,g_s.imn151) RETURNING l_sql  #FUN-980093
           PREPARE t720_prex_pre FROM l_sql
           DECLARE t720_prex CURSOR FOR t720_prex_pre
           OPEN t720_prex
	   FETCH t720_prex INTO g_imn[l_ac].imn20
           IF SQLCA.sqlcode THEN
              #FUN-C80107 add begin-------------------------121101
              IF cl_null(g_imn[l_ac].imn15) THEN
                 CALL cl_err(g_imn[l_ac].imn15,'aim-149',0)
                 NEXT FIELD imn15
              END IF
              #FUN-C80107 add end----------------------------
              IF NOT cl_confirm('mfg1401') THEN NEXT FIELD imn15 END IF
                 CALL s_madd_img(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                                 g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                                 g_imm.imm01,      g_imn[l_ac].imn02,
                                 g_imm.imm02,g_s.imn151)                 #No.FUN-980081 
              IF g_errno='N' THEN NEXT FIELD imn17 END IF
           END IF
           IF NOT s_actimg1(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                            g_imn[l_ac].imn16,g_imn[l_ac].imn17,g_s.imn151) #FUN-980093 add
           THEN CALL cl_err('inactive','mfg6117',0)
                NEXT FIELD imn15
           END IF
           LET g_imn[l_ac].imn22=g_imn[l_ac].imn10*g_imn[l_ac].imn21
           LET g_imn[l_ac].imn22=s_digqty(g_imn[l_ac].imn22,g_imn[l_ac].imn20)   #FUN-BB0084  
           DISPLAY BY NAME g_imn[l_ac].imn20                                     #FUN-BB0084 
           DISPLAY BY NAME g_imn[l_ac].imn22                                     #FUN-BB0084
          #LET l_sql = "SELECT img09,img10 FROM ",g_azp03_tra CLIPPED,"img_file ", #TQC-940178 ADD    #FUN-980093 add  #FUN-A50102
           LET l_sql = "SELECT img09,img10 FROM ",cl_get_target_table(g_s.imn151,'img_file'),  #FUN-A50102
                       " WHERE img01='",g_imn[l_ac].imn03,"'",
                       "   AND img02='",g_imn[l_ac].imn15,"'",
                       "   AND img03='",g_imn[l_ac].imn16,"'",
                       "   AND img04='",g_imn[l_ac].imn17,"'"
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
           CALL cl_parse_qry_sql(l_sql,g_s.imn151) RETURNING l_sql  #FUN-980093
           PREPARE img_c4 FROM l_sql
           DECLARE img_cur4 CURSOR FOR img_c4
           OPEN img_cur4
           FETCH img_cur4 INTO g_img09_t,g_img10_t
           LET g_imn[l_ac].imn20 = g_img09_t
           DISPLAY g_imn[l_ac].imn20 TO imn20
           IF SQLCA.sqlcode THEN
               LET l_img10 = 0
               CALL cl_err(g_imn[l_ac].imn15,'mfg6101',0)
               NEXT FIELD imn15
           END IF
           IF g_sma.sma115 = 'Y' THEN
              IF g_imn_t.imn03 IS NULL OR g_imn[l_ac].imn03 <> g_imn_t.imn03 OR
                 g_imn_t.imn15 IS NULL OR g_imn[l_ac].imn15 <> g_imn_t.imn15 OR
                 g_imn_t.imn16 IS NULL OR g_imn[l_ac].imn16 <> g_imn_t.imn16 OR
                 g_imn_t.imn17 IS NULL OR g_imn[l_ac].imn17 <> g_imn_t.imn17 THEN
                 CALL t720_du_default(p_cmd,g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                                      g_imn[l_ac].imn16,g_imn[l_ac].imn17)
                      RETURNING g_imn[l_ac].imn43,g_imn[l_ac].imn44,g_imn[l_ac].imn45,
                                g_imn[l_ac].imn40,g_imn[l_ac].imn41,g_imn[l_ac].imn42
              END IF
           END IF
           LET g_imn_t.imn17=g_imn[l_ac].imn17
 
        BEFORE FIELD imn43
           CALL t720_set_no_required()
 
        AFTER FIELD imn43  #第二單位
           IF cl_null(g_imn[l_ac].imn03) THEN NEXT FIELD imn03 END IF
           IF g_imn[l_ac].imn15 IS NULL OR g_imn[l_ac].imn16 IS NULL OR
              g_imn[l_ac].imn17 IS NULL THEN
              NEXT FIELD imn15
           END IF
           IF NOT cl_null(g_imn[l_ac].imn43) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_imn[l_ac].imn43
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_imn[l_ac].imn43,"",
                               SQLCA.sqlcode,"","gfe:",1)  #No.FUN-660156
                 NEXT FIELD imn43
              END IF
              CALL s_du_umfchk(g_imn[l_ac].imn03,'','','',
                               g_img09_t,g_imn[l_ac].imn43,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imn[l_ac].imn43,g_errno,0)
                 NEXT FIELD imn43
              END IF
              IF cl_null(g_imn_t.imn43) OR g_imn_t.imn43 <> g_imn[l_ac].imn43 THEN
                 LET g_imn[l_ac].imn44 = g_factor
              END IF
              CALL s_umfchk(g_imn[l_ac].imn03,g_imn[l_ac].imn33,g_imn[l_ac].imn43)
                   RETURNING g_flag,g_factor
              IF g_flag = 1 THEN
                 LET g_msg=g_imn[l_ac].imn03,' ',g_imn[l_ac].imn33,' ',g_imn[l_ac].imn43
                 CALL cl_err(g_msg CLIPPED,'mfg3075',1)
                 NEXT FIELD imn43
              ELSE
                 LET g_imn[l_ac].imn52=g_factor
              END IF
              #多工廠查詢imgg_file中是否存在雙單位資料
              CALL s_mchk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                               g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                               g_imn[l_ac].imn43,g_s.imn151) RETURNING g_flag #FUN-980093 add
              IF g_flag = 1 THEN
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN NEXT FIELD imn43 END IF
                 END IF
                 CALL s_madd_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                                  g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                                  g_imn[l_ac].imn43,g_imn[l_ac].imn44,
                                  g_imm.imm01,g_imn[l_ac].imn02,0,g_s.imn151) #FUN-980093 add
                      RETURNING g_flag
                 IF g_flag = 1 THEN
                    NEXT FIELD imn43
                 END IF
              END IF
              LET g_imn[l_ac].imn45=g_imn[l_ac].imn35*g_imn[l_ac].imn52
              LET g_imn[l_ac].imn45=s_digqty(g_imn[l_ac].imn45,g_imn[l_ac].imn43)    #FUN-BB0084
              DISPLAY g_imn[l_ac].imn45 TO imn45     #FUN-BB0084 
           END IF
           CALL t720_set_required()
           LET g_imn_t.imn43=g_imn[l_ac].imn43
     #FUN-BB0084 ----------------Begin------------------
           IF NOT t720_imn45_chk(p_cmd) THEN
              LET g_imn43_t = g_imn[l_ac].imn43
              NEXT FIELD imn45
           END IF
           LET g_imn43_t = g_imn[l_ac].imn43
     #FUN-BB0084 ----------------End--------------------     
 
        BEFORE FIELD imn44  #第二轉換率
           IF cl_null(g_imn[l_ac].imn03) THEN NEXT FIELD imn03 END IF
           IF g_imn[l_ac].imn15 IS NULL OR g_imn[l_ac].imn16 IS NULL OR
              g_imn[l_ac].imn17 IS NULL THEN
              NEXT FIELD imn15
           END IF
           IF NOT cl_null(g_imn[l_ac].imn43) AND g_ima906 = '3' THEN
              #多工廠查詢imgg_file中是否存在雙單位資料
              CALL s_mchk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                               g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                               g_imn[l_ac].imn43,g_s.imn151) RETURNING g_flag #FUN-980093 add
              IF g_flag = 1 THEN
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN NEXT FIELD imn15 END IF
                 END IF
                 CALL s_madd_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                                  g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                                  g_imn[l_ac].imn43,g_imn[l_ac].imn44,
                                  g_imm.imm01,g_imn[l_ac].imn02,0,g_s.imn151) #FUN-980093 add
                      RETURNING g_flag
                 IF g_flag = 1 THEN
                    NEXT FIELD imn15
                 END IF
              END IF
              LET g_imn[l_ac].imn45=g_imn[l_ac].imn35*g_imn[l_ac].imn52
              LET g_imn[l_ac].imn45=s_digqty(g_imn[l_ac].imn45,g_imn[l_ac].imn43)   #FUN-BB0084
              DISPLAY BY NAME g_imn[l_ac].imn45   #FUN-BB0084
           END IF
 
        AFTER FIELD imn44  #第二轉換率
           IF NOT cl_null(g_imn[l_ac].imn44) THEN
              IF g_imn[l_ac].imn44=0 THEN
                 NEXT FIELD imn44
              END IF
           END IF
 
        AFTER FIELD imn45  #第二數量
#FUN-BB0084 ------------Begin---------------
           IF NOT t720_imn45_chk(p_cmd) THEN
              NEXT FIELD imn45
           END IF  
#FUN-BB0084 ------------End-----------------
#FUN-BB0084 ----------------Begin----------------
#          IF NOT cl_null(g_imn[l_ac].imn45) THEN
#             IF g_imn[l_ac].imn45 < 0 THEN
#                CALL cl_err('','aim-391',0)  #
#                NEXT FIELD imn45
#             END IF
#             IF p_cmd = 'a' THEN
#                IF g_ima906='3' THEN
#                   LET g_tot=g_imn[l_ac].imn45*g_imn[l_ac].imn44
#                   IF cl_null(g_imn[l_ac].imn42) OR g_imn[l_ac].imn42=0 THEN
#                      LET g_imn[l_ac].imn42=g_tot*g_imn[l_ac].imn41
#                   END IF
#                END IF
#             END IF
#          END IF
#FUN-BB0084 ----------------End-----------------
 
        BEFORE FIELD imn40
           IF g_ima906 = '3' THEN
              IF cl_null(g_imn[l_ac].imn03) THEN NEXT FIELD imn03 END IF
              IF g_imn[l_ac].imn15 IS NULL OR g_imn[l_ac].imn16 IS NULL OR
                 g_imn[l_ac].imn17 IS NULL THEN
                 NEXT FIELD imn15
              END IF
              IF NOT cl_null(g_imn[l_ac].imn43) AND g_ima906 = '3' THEN
                 #多工廠查詢imgg_file中是否存在雙單位資料
                 CALL s_mchk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                                  g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                                  g_imn[l_ac].imn43,g_s.imn151) RETURNING g_flag #FUN-980093 add
                 IF g_flag = 1 THEN
                    IF g_sma.sma892[3,3] = 'Y' THEN
                       IF NOT cl_confirm('aim-995') THEN NEXT FIELD imn15 END IF
                    END IF
                    CALL s_madd_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                                     g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                                     g_imn[l_ac].imn43,g_imn[l_ac].imn44,
                                     g_imm.imm01,g_imn[l_ac].imn02,0,g_s.imn151) #FUN-980093 add
                         RETURNING g_flag
                    IF g_flag = 1 THEN
                       NEXT FIELD imn15
                    END IF
                 END IF
                 LET g_imn[l_ac].imn45=g_imn[l_ac].imn35*g_imn[l_ac].imn52
                 LET g_imn[l_ac].imn45=s_digqty(g_imn[l_ac].imn45,g_imn[l_ac].imn43)  #FUN-BB0084
                 DISPLAY BY NAME g_imn[l_ac].imn45                                    #FUN-BB0084
              END IF
           END IF
           CALL t720_set_no_required()
 
        AFTER FIELD imn40  #第一單位
           IF cl_null(g_imn[l_ac].imn03) THEN NEXT FIELD imn03 END IF
           IF g_imn[l_ac].imn15 IS NULL OR g_imn[l_ac].imn16 IS NULL OR
              g_imn[l_ac].imn17 IS NULL THEN
              NEXT FIELD imn15
           END IF
           IF NOT cl_null(g_imn[l_ac].imn40) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_imn[l_ac].imn40
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_imn[l_ac].imn40,"",
                               SQLCA.sqlcode,"","gfe:",1)  #No.FUN-660156
                 NEXT FIELD imn40
              END IF
              CALL s_du_umfchk(g_imn[l_ac].imn03,'','','',                      
                               g_imn[l_ac].imn20,g_imn[l_ac].imn40,'1')         
                   RETURNING g_errno,g_factor                                   
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imn[l_ac].imn40,g_errno,0)
                 NEXT FIELD imn40
              END IF
              IF cl_null(g_imn_t.imn40) OR g_imn_t.imn40 <> g_imn[l_ac].imn40 THEN
                 LET g_imn[l_ac].imn41 = g_factor
              END IF
              CALL s_umfchk(g_imn[l_ac].imn03,g_imn[l_ac].imn30,g_imn[l_ac].imn40)
                   RETURNING g_flag,g_factor
              IF g_flag = 1 THEN
                 LET g_msg=g_imn[l_ac].imn03,' ',g_imn[l_ac].imn30,' ',g_imn[l_ac].imn40
                 CALL cl_err(g_msg CLIPPED,'mfg3075',1)
                 NEXT FIELD imn40
              ELSE
                 LET g_imn[l_ac].imn51=g_factor
              END IF
              IF g_ima906 = '2' THEN
                 #多工廠查詢imgg_file中是否存在雙單位資料
                 CALL s_mchk_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                                  g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                                  g_imn[l_ac].imn40,g_s.imn151) RETURNING g_flag #FUN-980093 add
                 IF g_flag = 1 THEN
                    IF g_sma.sma892[3,3] = 'Y' THEN
                       IF NOT cl_confirm('aim-995') THEN NEXT FIELD imn40 END IF
                    END IF
                    CALL s_madd_imgg(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                                     g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                                     g_imn[l_ac].imn40,g_imn[l_ac].imn41,
                                     g_imm.imm01,g_imn[l_ac].imn02,0,g_s.imn151) #FUN-980093 add
                         RETURNING g_flag
                    IF g_flag = 1 THEN
                       NEXT FIELD imn40
                    END IF
                 END IF
              END IF
              LET g_imn[l_ac].imn42=g_imn[l_ac].imn32*g_imn[l_ac].imn51
              LET g_imn[l_ac].imn42=s_digqty(g_imn[l_ac].imn42,g_imn[l_ac].imn40)   #FUN-BB0084
              DISPLAY BY NAME g_imn[l_ac].imn42   #FUN-BB0084 
           END IF
           CALL t720_set_required()
           LET g_imn_t.imn40=g_imn[l_ac].imn40
#FUN-BB0084 --------------Begin-----------------
           IF NOT t720_imn42_chk() THEN 
              LET g_imn40_t = g_imn[l_ac].imn40 
              NEXT FIELD imn42
           END IF
           LET g_imn40_t = g_imn[l_ac].imn40
#FUN-BB0084 --------------End-------------------
 
        AFTER FIELD imn41  #第一轉換率
           IF NOT cl_null(g_imn[l_ac].imn41) THEN
              IF g_imn[l_ac].imn41=0 THEN
                 NEXT FIELD imn41
              END IF
           END IF
 
        AFTER FIELD imn42  #第一數量
#FUN-BB0084 -------------Begin------------
           IF NOT t720_imn42_chk() THEN
              NEXT FIELD imn42
           END IF   
#FUN-BB0084 -------------End--------------
#FUN-BB0084 -------------Begin------------
#          IF NOT cl_null(g_imn[l_ac].imn42) THEN
#             IF g_imn[l_ac].imn42 < 0 THEN
#                CALL cl_err('','aim-391',0)  #
#                NEXT FIELD imn42
#             END IF
#          END IF
#FUN-BB0084 -------------End--------------
        AFTER FIELD imn9301 
           IF NOT s_costcenter_chk(g_imn[l_ac].imn9301) THEN
              LET g_imn[l_ac].imn9301=g_imn_t.imn9301
              LET g_imn[l_ac].gem02b=g_imn_t.gem02b
              DISPLAY BY NAME g_imn[l_ac].imn9301,g_imn[l_ac].gem02b
              NEXT FIELD imn9301
           ELSE
              LET g_imn[l_ac].gem02b=s_costcenter_desc(g_imn[l_ac].imn9301)
              DISPLAY BY NAME g_imn[l_ac].gem02b
           END IF
        AFTER FIELD imn9302 
           IF NOT s_costcenter_chk(g_imn[l_ac].imn9302) THEN
              LET g_imn[l_ac].imn9302=g_imn_t.imn9302
              LET g_imn[l_ac].gem02c=g_imn_t.gem02c
              DISPLAY BY NAME g_imn[l_ac].imn9302,g_imn[l_ac].gem02c
              NEXT FIELD imn9302
           ELSE
              LET g_imn[l_ac].gem02c=s_costcenter_desc(g_imn[l_ac].imn9302)
              DISPLAY BY NAME g_imn[l_ac].gem02c
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_imn_t.imn02 > 0 AND g_imn_t.imn02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM imn_file
                 WHERE imn01 = g_imm.imm01 AND imn02 = g_imn_t.imn02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","imn_file",g_imm.imm01,g_imn_t.imn02,
                                 SQLCA.sqlcode,"","",1)  #No.FUN-660156
                    ROLLBACK WORK
                    CANCEL DELETE
                ELSE
                #FUN-B70074-add-str--
                   IF NOT s_industry('std') THEN
                      IF NOT s_del_imni(g_imm.imm01,g_imn_t.imn02,'') THEN 
                         ROLLBACK WORK
                         CANCEL DELETE
                      END IF
                   END IF
                #FUN-B70074-add-end--
                   LET g_rec_b=g_rec_b-1
                   DISPLAY g_rec_b TO FORMONLY.cn2
	           COMMIT WORK
                END IF
            END IF
 
        ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err(g_imn[l_ac].imn03,9001,0)
             LET INT_FLAG = 0
             LET g_imn[l_ac].* = g_imn_t.*
             CLOSE t720_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          #FUN-CB0087---add---str---
          IF g_aza.aza115 = 'Y' THEN
             IF NOT t720_imn28_chk1() THEN
                NEXT FIELD imn28
             END IF
          END IF
          #FUN-CB0087---add---end---
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_imn[l_ac].imn02,-263,1)
             LET g_imn[l_ac].* = g_imn_t.*
          ELSE
             IF g_sma.sma115 = 'Y' THEN
                CALL s_chk_va_setting(g_imn[l_ac].imn03)
                     RETURNING g_flag,g_ima906,g_ima907
                IF g_flag=1 THEN
                   NEXT FIELD imn03
                END IF
                CALL t720_du_data_to_correct()
             END IF
 
             IF NOT cl_null(g_imn[l_ac].imn03) THEN #MOD-4B0249(多包此IF 判斷)
               SELECT * FROM img_file
                WHERE img01=g_imn[l_ac].imn03
                  AND img02=g_imn[l_ac].imn15
                  AND img03=g_imn[l_ac].imn16
                  AND img04=g_imn[l_ac].imn17
               IF STATUS=100 THEN
                  IF g_sma.sma892[3,3] = 'Y' THEN
                     IF NOT cl_confirm('mfg1401') THEN
                        NEXT FIELD imn15
                     END IF
                  END IF
                  CALL s_add_img(g_imn[l_ac].imn03,g_imn[l_ac].imn15,
                                 g_imn[l_ac].imn16,g_imn[l_ac].imn17,
                                 g_imm.imm01,g_imn[l_ac].imn02,g_imm.imm02)
                  IF g_errno='N' THEN
                      NEXT FIELD imn17
                  END IF
               END IF
             END IF #MOD-4B0249
 
             IF g_sma.sma115 = 'Y' THEN
                IF t720_qty_issue() THEN
                   NEXT FIELD imn30
                END IF
                CALL t720_set_origin_field()
            #FUN-BB0084 -----------Begin-------------
                DISPLAY BY NAME g_imn[l_ac].imn09
                DISPLAY BY NAME g_imn[l_ac].imn10
                DISPLAY BY NAME g_imn[l_ac].imn20
                DISPLAY BY NAME g_imn[l_ac].imn22
                DISPLAY BY NAME g_imn[l_ac].imn21
                DISPLAY BY NAME g_imn[l_ac].imn34
                DISPLAY BY NAME g_imn[l_ac].imn44 
            #FUN-BB0084 -----------End---------------
             END IF
 
             CALL t720_b_move_back()
             UPDATE imn_file SET * = b_imn.*
              WHERE imn01=g_imm.imm01 AND imn02=g_imn_t.imn02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","imn_file",g_imm.imm01,g_imn_t.imn02,SQLCA.sqlcode,"",
                             "upd imn",1)   #NO.FUN-640266  #No.FUN-660156
                LET g_imn[l_ac].* = g_imn_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
	        COMMIT WORK
             END IF
          END IF
 
        AFTER ROW
          LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac     #FUN-D40030 Mark
          IF INT_FLAG THEN
             CALL cl_err(g_imn[l_ac].imn03,9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_imn[l_ac].* = g_imn_t.*
             #FUN-D40030--add--str--
             ELSE
                CALL g_imn.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D40030--add--end--
             END IF
             CLOSE t720_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac     #FUN-D40030 Add
          #FUN-CB0087---add---str---
          IF g_aza.aza115 = 'Y' THEN
             IF NOT t720_imn28_chk1() THEN
                NEXT FIELD imn28
             END IF
          END IF
          #FUN-CB0087---add---end---
          CLOSE t720_bcl
          COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(imn02) AND l_ac > 1 THEN
              LET g_imn[l_ac].* = g_imn[l_ac-1].*
              LET g_imn[l_ac].imn02 = NULL
              NEXT FIELD imn02
           END IF
 
        ON ACTION controlp
           CASE 
                #TQC-650093--begin--  新增的母料件開窗
                #這里只需要處理g_sma.sma908='Y'的情況,因為不允許單身新增子料件則在前面
                #BEFORE FIELD att00來做開窗了 
                #需注意的是其條件限制是要開多屬性母料件且母料件的屬性組等于當前屬性組
                WHEN INFIELD(att00)
                   #可以新增子料件,開窗是單純的選取母料件                                                                               
#FUN-AA0059 --Begin--
                #   CALL cl_init_qry_var()                                                                                               
                #   LET g_qryparam.form ="q_ima_p"                                                                                       
                #   LET g_qryparam.arg1 = lg_group                                                                                       
                #   CALL cl_create_qry() RETURNING g_imn[l_ac].att00                                                                     
                   CALL q_sel_ima(FALSE, "q_ima_p", "", "", lg_group, "", "", "" ,"",'' )  RETURNING g_imn[l_ac].att00
#FUN-AA0059 --End--
                   DISPLAY BY NAME g_imn[l_ac].att00  
                   NEXT FIELD att00            
 
                WHEN INFIELD(imn03)
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form     ="q_ima"
                  #   LET g_qryparam.default1 = g_imn[l_ac].imn03
                  #   CALL cl_create_qry() RETURNING g_imn[l_ac].imn03
                     CALL q_sel_ima(FALSE, "q_ima", "", g_imn[l_ac].imn03, "", "", "", "" ,"",'' )  RETURNING g_imn[l_ac].imn03
#FUN-AA0059 --End--
                     NEXT FIELD imn03
 
                WHEN INFIELD(imn04) OR INFIELD(imn05) OR INFIELD(imn06)
                   #FUN-C30300---begin
                   LET g_ima906 = NULL
                   SELECT ima906 INTO g_ima906 FROM ima_file
                    WHERE ima01 = g_imn[l_ac].imn03
                   #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                   IF s_industry("icd") THEN  #TQC-C60028
                      CALL q_idc(FALSE,TRUE,g_imn[l_ac].imn03,g_imn[l_ac].imn04,g_imn[l_ac].imn05,g_imn[l_ac].imn06)
                      RETURNING g_imn[l_ac].imn04,g_imn[l_ac].imn05,
                                g_imn[l_ac].imn06
                   ELSE
                   #FUN-C30300---end
                      CALL q_img4(FALSE,TRUE,g_imn[l_ac].imn03,   ##NO.FUN-660085
                                              g_imn[l_ac].imn04,
                                              g_imn[l_ac].imn05,
                                              g_imn[l_ac].imn06,'A')
                      RETURNING g_imn[l_ac].imn04,g_imn[l_ac].imn05,
                                g_imn[l_ac].imn06
                   END IF   #FUN-C30300
                     IF cl_null(g_imn[l_ac].imn05) THEN
                        LET g_imn[l_ac].imn05 = ' '
                     END IF
                     IF cl_null(g_imn[l_ac].imn06) THEN
                        LET g_imn[l_ac].imn06 = ' '
                     END IF
                     DISPLAY g_imn[l_ac].imn04 TO imn04
                     DISPLAY g_imn[l_ac].imn05 TO imn05
                     DISPLAY g_imn[l_ac].imn06 TO imn06
                     IF INFIELD(imn04) THEN NEXT FIELD imn04 END IF
                     IF INFIELD(imn05) THEN NEXT FIELD imn05 END IF
                     IF INFIELD(imn06) THEN NEXT FIELD imn06 END IF
 
                WHEN INFIELD(imn15) OR INFIELD(imn16) OR INFIELD(imn17)
                   #FUN-C30300---begin
                   LET g_ima906 = NULL
                   SELECT ima906 INTO g_ima906 FROM ima_file
                    WHERE ima01 = g_imn[l_ac].imn03
                   #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                   IF s_industry("icd") THEN  #TQC-C60028
                      CALL q_idc(FALSE,TRUE,g_imn[l_ac].imn03,g_imn[l_ac].imn15,g_imn[l_ac].imn16,g_imn[l_ac].imn17)
                      RETURNING g_imn[l_ac].imn15,g_imn[l_ac].imn16,
                                g_imn[l_ac].imn17
                   ELSE
                   #FUN-C30300---end
                      CALL q_img41(FALSE,TRUE,g_imn[l_ac].imn03,  ##NO.FUN-660085
                                               g_imn[l_ac].imn15,
                                               g_imn[l_ac].imn16,
                                               g_imn[l_ac].imn17,'A',g_s.imn151) #No.FUN-980093 add
                      RETURNING g_imn[l_ac].imn15,g_imn[l_ac].imn16,
                                g_imn[l_ac].imn17
                   END IF  #FUN-C30300
                     IF cl_null(g_imn[l_ac].imn16) THEN
                        LET g_imn[l_ac].imn16 = ' '
                     END IF
                     IF cl_null(g_imn[l_ac].imn17) THEN
                        LET g_imn[l_ac].imn17 = ' '
                     END IF
                     IF INFIELD(imn15) THEN NEXT FIELD imn15 END IF
                     IF INFIELD(imn16) THEN NEXT FIELD imn16 END IF
                     IF INFIELD(imn17) THEN NEXT FIELD imn17 END IF
 
                WHEN INFIELD(imn28) #理由
                    #FUN-CB0087---add---str---
                    LET l_store = ''
                    IF NOT cl_null(g_imn[l_ac].imn04) THEN
                       LET l_store = l_store,g_imn[l_ac].imn04
                    END IF
                    IF NOT cl_null(g_imn[l_ac].imn15) THEN
                       IF NOT cl_null(l_store) THEN
                          LET l_store = l_store,"','",g_imn[l_ac].imn15
                       ELSE
                          LET l_store = l_store,g_imn[l_ac].imn15
                       END IF
                    END IF
                    CALL s_get_where(g_imm.imm01,'','',g_imn[l_ac].imn03,l_store,'',g_imm.imm14) RETURNING l_flag,l_where
                    IF l_flag AND g_aza.aza115 = 'Y' THEN
                       CALL cl_init_qry_var()
                       LET g_qryparam.form     ="q_ggc08"
                       LET g_qryparam.where = l_where
                       LET g_qryparam.default1 = g_imn[l_ac].imn28
                    ELSE
                    #FUN-CB0087---add---end---
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_azf01a"            #FUN-920186
                     LET g_qryparam.default1 = g_imn[l_ac].imn28
                     LET g_qryparam.arg1     = "6"                #FUN-920186
                     END IF                                       #FUN-CB0087
                     CALL cl_create_qry() RETURNING g_imn[l_ac].imn28
                     CALL t720_azf03()                            #FUN-CB0087
                     NEXT FIELD imn28
 
                WHEN INFIELD(imn33) #單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_imn[l_ac].imn33
                     CALL cl_create_qry() RETURNING g_imn[l_ac].imn33
                     NEXT FIELD imn33
 
                WHEN INFIELD(imn30) #單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_imn[l_ac].imn30
                     CALL cl_create_qry() RETURNING g_imn[l_ac].imn30
                     NEXT FIELD imn30
 
                WHEN INFIELD(imn43) #單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_imn[l_ac].imn43
                     CALL cl_create_qry() RETURNING g_imn[l_ac].imn43
                     NEXT FIELD imn43
 
                WHEN INFIELD(imn40) #單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_imn[l_ac].imn40
                     CALL cl_create_qry() RETURNING g_imn[l_ac].imn40
                     NEXT FIELD imn40
               WHEN INFIELD(imn9301)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gem4"
                  CALL cl_create_qry() RETURNING g_imn[l_ac].imn9301
                  DISPLAY BY NAME g_imn[l_ac].imn9301
                  NEXT FIELD imn9301
               WHEN INFIELD(imn9302)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gem4"
                  CALL cl_create_qry() RETURNING g_imn[l_ac].imn9302
                  DISPLAY BY NAME g_imn[l_ac].imn9302
                  NEXT FIELD imn9302
           END CASE
 
        ON ACTION def_tr_out_imf
             #WHEN INFIELD(imn04) #預設倉庫/ 儲位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_imf"
                 LET g_qryparam.default1 = g_imn[l_ac].imn04
                 LET g_qryparam.default2 = g_imn[l_ac].imn05
                 LET g_qryparam.arg1     = g_imn[l_ac].imn03
                 LET g_qryparam.arg2     = "A"
                 IF g_qryparam.arg2 != 'A' THEN
                    LET g_qryparam.where=g_qryparam.where CLIPPED, " AND ime04 matches'",g_qryparam.arg2,"'"
                 END IF
                 CALL cl_create_qry() RETURNING g_imn[l_ac].imn04,g_imn[l_ac].imn05
                 NEXT FIELD imn04
							
        ON ACTION def_tr_in_imf
           #WHEN INFIELD(imn15) #預設倉庫/ 儲位
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_imf1"  #No.MOD-490283
               LET g_qryparam.default1 = g_imn[l_ac].imn15
               LET g_qryparam.default2 = g_imn[l_ac].imn16
               LET g_qryparam.arg1     = g_imn[l_ac].imn03
               LET g_qryparam.arg2     = "A"
               SELECT azp01,azp03 INTO g_azp01,g_azp03
                 FROM azp_file WHERE azp01=g_s.imn151
               LET g_azp03=s_dbstring(g_azp03 CLIPPED)
               IF STATUS THEN #CALL cl_err('select azp #1',STATUS,1) 
                    CALL cl_err3("sel","azp_file",g_s.imn151,"",SQLCA.sqlcode,
                                 "","select azp #1",1)   #NO.FUN-640266
               RETURN END IF
               DISPLAY "g_azp03: ",g_azp03
               LET g_qryparam.arg3     = g_azp03
               IF g_qryparam.arg2 != 'A' THEN
                  LET g_qryparam.where=g_qryparam.where CLIPPED, " AND ime04 matches'",g_qryparam.arg2,"'"
               END IF
               CALL cl_create_qry() RETURNING g_imn[l_ac].imn15,g_imn[l_ac].imn16
 
               SELECT azp03 INTO g_dbs FROM azp_file WHERE azp01=g_s.imn041
               LET g_dbs=s_dbstring(g_dbs CLIPPED)
               IF STATUS THEN 
                  CALL cl_err3("sel","azp_file",g_s.imn041,"",SQLCA.sqlcode,
                               "","select azp #2",1)   #NO.FUN-640266
                  RETURN 
               END IF
 
               NEXT FIELD imn15
 
        ON ACTION mntn_reason
           #WHEN INFIELD(imn28) #理由
               CALL cl_cmdrun("aooi301")
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
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
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
      END INPUT
 
      UPDATE imm_file SET immmodu=g_user,immdate=g_today
          WHERE imm01=g_imm.imm01
 
      SELECT COUNT(*) INTO g_cnt FROM imn_file WHERE imn01=g_imm.imm01
      #因為s_imfchk11,s_imfchk12會select不同database的sma_file,所以在此
      #必須重新select此datatbase的sma_file
      SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","sma_file","","",SQLCA.sqlcode,
                      "","",1)   #NO.FUN-640266
         RETURN 0
      END IF
      CLOSE t720_bcl
      COMMIT WORK
#     CALL t720_delall() #CHI-C30002 mark
      CALL t720_delHeader()     #CHI-C30002 add
      IF g_smy.smyprint='Y' THEN
         IF cl_confirm('mfg9392') THEN
            CALL t720_out()
         END IF
      END IF
END FUNCTION

#FUN-BB0084 -----------------Begin-------------------
#FUNCTION t720_imn10_chk(p_cmd) 
#DEFINE p_cmd     LIKE type_file.chr1
#   IF NOT cl_null(g_imn[l_ac].imn10) THEN 
#      IF g_imn[l_ac].imn10 <= 0 THEN 
#         CALL cl_err('','mfg9105',0)
#         RETURN "imn10" 
#      END IF
#      IF NOT cl_null(g_imn[l_ac].imn09) THEN
#      IF p_cmd = 'u' THEN 
#         LET g_imn[l_ac].imn22 = g_imn[l_ac].imn10 * g_imn[l_ac].imn21
#         LET g_imn[l_ac].imn22 = s_digqty(g_imn[l_ac].imn22,g_imn[l_ac].imn20)  
#         DISPLAY BY NAME g_imn[l_ac].imn22
#      END IF
#      IF g_imn[l_ac].imn10 > l_img10 THEN 
#         IF g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN 
#            CALL cl_err(l_img10,'mfg3471',0)
#            RETURN "imn10" 
#         ELSE 
#            IF NOT cl_confirm('mfg3469') THEN 
#               RETURN "imn10" 
#            END IF
#         END IF
#      END IF
#   END IF
#   IF g_imn[l_ac].imn09 != g_imn[l_ac].imn20 THEN
#      LET g_azp03_o = t720_catstr(g_azp03)
#      CALL s_umfchk1(g_imn[l_ac].imn03,g_imn[l_ac].imn09,
#                     g_imn[l_ac].imn20,g_s.imn151) #FUN-980093 add
#      RETURNING g_cnt,g_imn[l_ac].imn21
#      IF g_cnt = 1 THEN
#         CALL cl_err('','mfg3075',1)
#         RETURN "imn17"
#      END IF
#   ELSE
#      LET g_imn[l_ac].imn21=1
#   END IF
#   LET g_imn[l_ac].imn22=g_imn[l_ac].imn10*g_imn[l_ac].imn21
#   LET g_imn[l_ac].imn22=s_digqty(g_imn[l_ac].imn22,g_imn[l_ac].imn20)
#   DISPLAY BY NAME g_imn[l_ac].imn22
#   DISPLAY BY NAME g_imn[l_ac].imn21
#   RETURN NULL
#END FUNCTION 

FUNCTION t720_imn32_chk()
   IF NOT cl_null(g_imn[l_ac].imn32) THEN
      IF g_imn[l_ac].imn32 < 0 THEN
         CALL cl_err('','aim-391',0)  #
         RETURN FALSE 
      END IF
   END IF
   IF NOT cl_null(g_imn[l_ac].imn32) AND NOT cl_null(g_imn[l_ac].imn30) THEN
      IF cl_null(g_imn30_t) OR cl_null(g_imn_t.imn32) OR
         g_imn30_t!=g_imn[l_ac].imn30 OR g_imn_t.imn32 ! = g_imn[l_ac].imn32 THEN
         LET g_imn[l_ac].imn32 = s_digqty(g_imn[l_ac].imn32,g_imn[l_ac].imn30)
         DISPLAY BY NAME g_imn[l_ac].imn32
      END IF
   END IF
   RETURN TRUE 
END FUNCTION

FUNCTION t720_imn35_chk(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
   IF NOT cl_null(g_imn[l_ac].imn35) THEN
      IF g_imn[l_ac].imn35 < 0 THEN
         CALL cl_err('','aim-391',0)  #
         RETURN FALSE 
      END IF
      IF NOT cl_null(g_imn[l_ac].imn33) THEN
         IF cl_null(g_imn33_t) OR cl_null(g_imn_t.imn35) OR 
            g_imn33_t!=g_imn[l_ac].imn33 OR g_imn_t.imn35!=g_imn[l_ac].imn35 THEN
            LET g_imn[l_ac].imn35 = s_digqty(g_imn[l_ac].imn35,g_imn[l_ac].imn33)
            DISPLAY BY NAME g_imn[l_ac].imn35
         END IF  
      END IF
      IF p_cmd = 'a' THEN
         IF g_ima906='3' THEN
            LET g_tot=g_imn[l_ac].imn35*g_imn[l_ac].imn34
            IF cl_null(g_imn[l_ac].imn32) OR g_imn[l_ac].imn32=0 THEN #CHI-960022
               LET g_imn[l_ac].imn32=g_tot*g_imn[l_ac].imn31
               LET g_imn[l_ac].imn32=s_digqty(g_imn[l_ac].imn32,g_imn[l_ac].imn30)
               DISPLAY BY NAME g_imn[l_ac].imn32         
            END IF                             
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t720_imn42_chk() 
   IF NOT cl_null(g_imn[l_ac].imn42) THEN 
      IF g_imn[l_ac].imn42 < 0 THEN 
         CALL cl_err('','aim-391',0)  #
         RETURN FALSE 
      END IF
   END IF
   IF NOT cl_null(g_imn[l_ac].imn42) AND NOT cl_null(g_imn[l_ac].imn40) THEN
      IF cl_null (g_imn40_t) OR cl_null(g_imn_t.imn42) OR
         g_imn40_t! = g_imn[l_ac].imn40 OR g_imn_t.imn42! = g_imn[l_ac].imn42 THEN
         LET g_imn[l_ac].imn42 = s_digqty(g_imn[l_ac].imn42,g_imn[l_ac].imn40) 
         DISPLAY BY NAME g_imn[l_ac].imn42
      END IF
   END IF
   RETURN TRUE 
END FUNCTION

FUNCTION t720_imn45_chk(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1
   IF NOT cl_null(g_imn[l_ac].imn45) THEN 
      IF g_imn[l_ac].imn45 < 0 THEN 
         CALL cl_err('','aim-391',0)  #
          RETURN FALSE 
      END IF
      IF NOT cl_null(g_imn[l_ac].imn43) THEN
         IF cl_null(g_imn43_t) OR cl_null(g_imn_t.imn45) OR
            g_imn43_t! = g_imn[l_ac].imn43 OR g_imn_t.imn45! = g_imn[l_ac].imn45 THEN
            LET g_imn[l_ac].imn45 = s_digqty(g_imn[l_ac].imn45,g_imn[l_ac].imn43)
            DISPLAY BY NAME g_imn[l_ac].imn45
         END IF
      END IF  
      IF p_cmd = 'a' THEN 
         IF g_ima906='3' THEN 
            LET g_tot=g_imn[l_ac].imn45*g_imn[l_ac].imn44
            IF cl_null(g_imn[l_ac].imn42) OR g_imn[l_ac].imn42=0 THEN 
               LET g_imn[l_ac].imn42=g_tot*g_imn[l_ac].imn41
               LET g_imn[l_ac].imn42=s_digqty(g_imn[l_ac].imn42,g_imn[l_ac].imn42)
               DISPLAY BY NAME g_imn[l_ac].imn42
            END IF
         END IF
      END IF
   END IF
   RETURN TRUE 
END FUNCTION
#FUN-BB0084 -----------------End---------------------
 
#CHI-C30002 -------- add -------- begin
FUNCTION t720_delHeader()
   DEFINE l_action_choice    STRING               #CHI-D40043
   DEFINE l_cho              LIKE type_file.num5  #CHI-D40043
   DEFINE l_num              LIKE type_file.num5  #CHI-D40043
   DEFINE l_slip             LIKE type_file.chr5  #CHI-D40043
   DEFINE l_sql              STRING               #CHI-D40043
   DEFINE l_cnt              LIKE type_file.num5  #CHI-D40043
   
   IF g_rec_b = 0 THEN
      #CHI-D40043---begin
      CALL s_get_doc_no(g_imm.imm01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM imm_file ",
                  "  WHERE imm01 LIKE '",l_slip,"%' ",
                  "    AND imm01 > '",g_imm.imm01,"'"
      PREPARE t720_pb1 FROM l_sql 
      EXECUTE t720_pb1 INTO l_cnt       
      
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
         CALL t720_x(1)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-D40043---end
      #IF cl_confirm("9042") THEN  #CHI-D40043
         DELETE FROM imm_file WHERE imm01 = g_imm.imm01
         INITIALIZE g_imm.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t720_delall()
#DEFINE p_num  LIKE pib_file.pib03,   #No.FUN-690026 VARCHAR(6)
#      p_slip LIKE smy_file.smyslip  #No.FUN-560271 #No.FUN-690026 VARCHAR(5)
#
#   SELECT COUNT(*) INTO g_cnt FROM imn_file
#    WHERE imn01=g_imm.imm01
#   IF g_cnt = 0 THEN 			# 未輸入單身資料, 則取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#          LET p_num=g_imm.imm01[g_no_sp,g_no_ep]     #No.FUN-550029
#          LET p_num=p_num-1
#          LET p_slip=s_get_doc_no(g_imm.imm01)       #No.FUN-550029
#      DELETE FROM imm_file WHERE imm01 = g_imm.imm01
#      INITIALIZE g_imm.* TO NULL
#      CLEAR FORM
#      CALL g_imn.clear()
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t720_b_move_to()
    LET g_imn[l_ac].imn02=b_imn.imn02
    LET g_imn[l_ac].imn03=b_imn.imn03
    LET g_imn[l_ac].imn29=b_imn.imn29     #No.FUN-5C0077
    LET g_imn[l_ac].imn28=b_imn.imn28
    LET g_imn[l_ac].imn04=b_imn.imn04
    LET g_imn[l_ac].imn05=b_imn.imn05
    LET g_imn[l_ac].imn06=b_imn.imn06
    LET g_imn[l_ac].imn09=b_imn.imn09
    LET g_imn[l_ac].imn10=b_imn.imn10
    LET g_imn[l_ac].imn15=b_imn.imn15
    LET g_imn[l_ac].imn16=b_imn.imn16
    LET g_imn[l_ac].imn17=b_imn.imn17
    LET g_imn[l_ac].imn20=b_imn.imn20
    LET g_imn[l_ac].imn21=b_imn.imn21
    LET g_imn[l_ac].imn22=b_imn.imn22
    LET g_imn[l_ac].imn33=b_imn.imn33
    LET g_imn[l_ac].imn34=b_imn.imn34
    LET g_imn[l_ac].imn35=b_imn.imn35
    LET g_imn[l_ac].imn30=b_imn.imn30
    LET g_imn[l_ac].imn31=b_imn.imn31
    LET g_imn[l_ac].imn32=b_imn.imn32
    LET g_imn[l_ac].imn43=b_imn.imn43
    LET g_imn[l_ac].imn44=b_imn.imn44
    LET g_imn[l_ac].imn45=b_imn.imn45
    LET g_imn[l_ac].imn40=b_imn.imn40
    LET g_imn[l_ac].imn41=b_imn.imn41
    LET g_imn[l_ac].imn42=b_imn.imn42
    LET g_imn[l_ac].imn51=b_imn.imn51
    LET g_imn[l_ac].imn52=b_imn.imn52
    LET g_imn[l_ac].imn9301=b_imn.imn9301 #FUN-670093
    LET g_imn[l_ac].imn9302=b_imn.imn9302 #FUN-670093
END FUNCTION
 
FUNCTION t720_b_move_back()
 
    IF g_imn[l_ac].imn05 IS NULL THEN LET g_imn[l_ac].imn05=' ' END IF
    IF g_imn[l_ac].imn06 IS NULL THEN LET g_imn[l_ac].imn06=' ' END IF
    IF g_imn[l_ac].imn16 IS NULL THEN LET g_imn[l_ac].imn16=' ' END IF
    LET b_imn.imn02=g_imn[l_ac].imn02
    LET b_imn.imn03=g_imn[l_ac].imn03
    LET b_imn.imn29=g_imn[l_ac].imn29     #No.FUN-5C0077
    LET b_imn.imn28=g_imn[l_ac].imn28
    LET b_imn.imn04=g_imn[l_ac].imn04
    LET b_imn.imn05=g_imn[l_ac].imn05
    LET b_imn.imn06=g_imn[l_ac].imn06
    LET b_imn.imn09=g_imn[l_ac].imn09
    LET b_imn.imn10=g_imn[l_ac].imn10
    LET b_imn.imn15=g_imn[l_ac].imn15
    LET b_imn.imn16=g_imn[l_ac].imn16
    LET b_imn.imn17=g_imn[l_ac].imn17
    LET b_imn.imn20=g_imn[l_ac].imn20
    LET b_imn.imn21=g_imn[l_ac].imn21
    LET b_imn.imn22=g_imn[l_ac].imn22
    LET b_imn.imn14=''
    LET b_imn.imn26=''
    LET b_imn.imn33=g_imn[l_ac].imn33
    LET b_imn.imn34=g_imn[l_ac].imn34
    LET b_imn.imn35=g_imn[l_ac].imn35
    LET b_imn.imn30=g_imn[l_ac].imn30
    LET b_imn.imn31=g_imn[l_ac].imn31
    LET b_imn.imn32=g_imn[l_ac].imn32
    LET b_imn.imn43=g_imn[l_ac].imn43
    LET b_imn.imn44=g_imn[l_ac].imn44
    LET b_imn.imn45=g_imn[l_ac].imn45
    LET b_imn.imn40=g_imn[l_ac].imn40
    LET b_imn.imn41=g_imn[l_ac].imn41
    LET b_imn.imn42=g_imn[l_ac].imn42
    LET b_imn.imn51=g_imn[l_ac].imn51
    LET b_imn.imn52=g_imn[l_ac].imn52
    LET b_imn.imn9301=g_imn[l_ac].imn9301 #FUN-670093
    LET b_imn.imn9302=g_imn[l_ac].imn9302 #FUN-670093
END FUNCTION
 
FUNCTION t720_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON imn02,imn03,imn29,imn28,imn04,imn05,imn06,imn09,     #No.FUN-5C0077
                       imn33,imn34,imn35,imn30,imn31,imn32,
                       imn15,imn16,imn17,imn20,
                       imn43,imn44,imn45,imn40,imn41,imn42,
                       imn10,imn22,imn21,imn52,imn51
         FROM s_imn[1].imn02,s_imn[1].imn03,s_imn[1].imn29,s_imn[1].imn28,s_imn[1].imn04,    #No.FUN-5C0077
              s_imn[1].imn05,s_imn[1].imn06,s_imn[1].imn09,
              s_imn[1].imn33,s_imn[1].imn34,s_imn[1].imn35,
              s_imn[1].imn30,s_imn[1].imn31,s_imn[1].imn32,
              s_imn[1].imn15,s_imn[1].imn16,s_imn[1].imn17,s_imn[1].imn20,
              s_imn[1].imn43,s_imn[1].imn44,s_imn[1].imn45,
              s_imn[1].imn40,s_imn[1].imn41,s_imn[1].imn42,
              s_imn[1].imn10,s_imn[1].imn22,s_imn[1].imn21,
              s_imn[1].imn52,s_imn[1].imn51
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
        ON ACTION controlp
           CASE WHEN INFIELD(imn03)
#FUN-AA0059 --Begin--
                 #  CALL cl_init_qry_var()
                 #  LET g_qryparam.form     ="q_ima"
                 #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima(FALSE, "q_ima", "", "" , "", "", "", "" ,"",'' )  RETURNING g_qryparam.multiret 
#FUIN-AA0059 --End--
                   DISPLAY g_qryparam.multiret TO imn03
                   NEXT FIELD imn03

               WHEN INFIELD(imn28) #理由
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf01a"         #FUN-920186
                  LET g_qryparam.default1 = g_imn[1].imn28
                  LET g_qryparam.arg1     = "6" 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imn28
                  NEXT FIELD imn28
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
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t720_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t720_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
    LET g_sql =
       #采用料件多屬性方式。No.TQC-650093
        "SELECT imn02,imn03,'','','','','','','','','','','','','',",
        "       '','','','','','','','',imn29,imn04,imn05,imn06,imn09,imn9301,'',",  #FUN-670093   #FUN-CB0087 去掉imn28
        "       imn33,imn34,imn35,imn30,imn31,imn32,",
        "       imn15,imn16,imn17,imn20,imn9302,'',",  #FUN-670093
        "       imn43,imn44,imn45,imn40,imn41,imn42,",
        "       imn10,imn22,imn21,imn52,imn51,imn28,azf03 ",  #FUN-CB0087 add>imn28,azf03
        #" FROM imn_file, OUTER ima_file ",                                                         #FUN-CB0087 mark
        "  FROM imn_file LEFT OUTER JOIN ima_file ON ima01=imn03 ",                                 #FUN-CB0087 add
        "                LEFT OUTER JOIN azf_file ON azf01=imn28 and azf02='2' ",                   #FUN-CB0087 add
        " WHERE imn01 ='",g_imm.imm01,"'",  #單頭
        #"   AND imn_file.imn03 = ima_file.ima01 AND ",p_wc2 CLIPPED,                     #單身     #FUN-CB0087 mark
        " AND ",p_wc2 CLIPPED,                                                                      #FUN-CB0087 add
        " ORDER BY 1"
 
    PREPARE t720_pb FROM g_sql
    DECLARE imn_curs CURSOR FOR t720_pb
 
    CALL g_imn.clear()
 
    LET g_cnt = 1
    FOREACH imn_curs INTO g_imn[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        
        #如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改   
        IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN                                                                           
           #得到該料件對應的父料件和所有屬性                                                                                        
           SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,                                                                        
                  imx07,imx08,imx09,imx10 INTO                                                                                      
                  g_imn[g_cnt].att00,g_imn[g_cnt].att01,g_imn[g_cnt].att02,                                                         
                  g_imn[g_cnt].att03,g_imn[g_cnt].att04,g_imn[g_cnt].att05,                                                         
                  g_imn[g_cnt].att06,g_imn[g_cnt].att07,g_imn[g_cnt].att08,                                                         
                  g_imn[g_cnt].att09,g_imn[g_cnt].att10                                                                             
           FROM imx_file WHERE imx000 = g_imn[g_cnt].imn03                                                                          
                                                                                                                                    
           LET g_imn[g_cnt].att01_c = g_imn[g_cnt].att01                                                                            
           LET g_imn[g_cnt].att02_c = g_imn[g_cnt].att02                                                                            
           LET g_imn[g_cnt].att03_c = g_imn[g_cnt].att03                                                                            
           LET g_imn[g_cnt].att04_c = g_imn[g_cnt].att04                                                                            
           LET g_imn[g_cnt].att05_c = g_imn[g_cnt].att05                                                                            
           LET g_imn[g_cnt].att06_c = g_imn[g_cnt].att06                                                                            
           LET g_imn[g_cnt].att07_c = g_imn[g_cnt].att07                                                                            
           LET g_imn[g_cnt].att08_c = g_imn[g_cnt].att08                                                                            
           LET g_imn[g_cnt].att09_c = g_imn[g_cnt].att09 
           LET g_imn[g_cnt].att10_c = g_imn[g_cnt].att10                                                                            
                                                                                                                                    
        END IF              
 
        LET g_imn[g_cnt].gem02b=s_costcenter_desc(g_imn[g_cnt].imn9301) #FUN-670093
        LET g_imn[g_cnt].gem02c=s_costcenter_desc(g_imn[g_cnt].imn9302) #FUN-670093
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_imn.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    CALL t720_refresh_detail()  #TQC-650093 刷新單身的欄位顯示
 
END FUNCTION
 
FUNCTION t720_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_imn TO s_imn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
         CALL t720_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t720_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t720_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t720_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t720_fetch('L')
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
         CALL t720_def_form()   #FUN-610067
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
    #@ON ACTION 撥出確認
      ON ACTION conf_transfer_out
         LET g_action_choice="conf_transfer_out"
         EXIT DISPLAY
    #@ON ACTION 撥出確認取消
      ON ACTION undo_conf_transfer_out
         LET g_action_choice="undo_conf_transfer_out"
         EXIT DISPLAY
 
    #@ON ACTION conf_transfer_in_post
      ON ACTION conf_transfer_in_post
         LET g_action_choice="conf_transfer_in_post"
         EXIT DISPLAY
 
    #@ON ACTION undo_conf_transfer_in_post 過帳還原
      ON ACTION undo_conf_transfer_in_post
         LET g_action_choice="undo_conf_transfer_in_post"
         EXIT DISPLAY
      #CHI-D40043---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
         
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D40043---end 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
    #@ON ACTION 拋轉至SPC
      ON ACTION trans_spc                     
         LET g_action_choice="trans_spc"
         EXIT DISPLAY
 
     ON ACTION related_document                #No.FUN-680046  相關文件
        LET g_action_choice="related_document"          
        EXIT DISPLAY 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t720_out()
    IF g_imm.imm01 IS NULL THEN RETURN END IF
 
    LET g_msg = 'imm01="',g_imm.imm01,'" '
  # LET g_msg = "aimr512 '",g_today,"' '",g_user,"' '",g_lang,"' ",   #FUN-C30085 mark
    LET g_msg = "aimg512 '",g_today,"' '",g_user,"' '",g_lang,"' ",   #FUN-C30085 add
                " 'Y' ' ' '1' ", 
                " '",g_msg,"' '3' "
    CALL cl_cmdrun(g_msg)
END FUNCTION
 
FUNCTION t720_y()
DEFINE l_buf       LIKE gem_file.gem02 #TQC-B50032
DEFINE l_cnt       LIKE type_file.num5  #CHI-D40043

   IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_imm.* FROM imm_file WHERE imm01=g_imm.imm01
   IF g_imm.imm04 = 'Y' THEN  RETURN END IF
   IF g_imm.imm04 = 'X' THEN RETURN END IF  #CHI-D40043
   IF g_imm.imm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   #TQC-B50032--begin
   IF NOT cl_null(g_imm.imm14) THEN
      SELECT gem02 INTO l_buf FROM gem_file
       WHERE gem01=g_imm.imm14
         AND gemacti='Y'   
      IF STATUS THEN
         CALL cl_err3("sel","gem_file",g_imm.imm14,"",SQLCA.sqlcode,"","select gem",1)
         RETURN 
      END IF
   END IF
   #TQC-B50032--end
   #CHI-D40043---begin
   SELECT COUNT(*) INTO l_cnt
     FROM imn_file
    WHERE imn01 = g_imm.imm01
   IF l_cnt = 0 THEN
      CALL cl_err(g_mm,'art-486',0)
      RETURN 
   END IF 
   #CHI-D40043---end
	IF g_sma.sma53 IS NOT NULL AND g_imm.imm02 <= g_sma.sma53 THEN
	   CALL cl_err('','mfg9999',0) RETURN
	END IF
        CALL s_yp(g_imm.imm02) RETURNING g_yy,g_mm
        IF g_yy > g_sma.sma51			# 與目前會計年度,期間比較
        THEN CALL cl_err(g_yy,'mfg6090',0) RETURN
        ELSE IF g_yy=g_sma.sma51 AND g_mm > g_sma.sma52
             THEN CALL cl_err(g_mm,'mfg6091',0) RETURN
             END IF
        END IF
#No.FUN-AB0067--begin    
   LET g_success='Y' 
   CALL s_showmsg_init()   
   DECLARE t720_chk_ware CURSOR FOR SELECT * FROM imn_file
                                   WHERE imn01=g_imm.imm01
   FOREACH t720_chk_ware INTO b_imn.*           
      IF NOT s_chk_ware(b_imn.imn04) THEN
         LET g_success='N' 
      END IF 
      IF NOT s_chk_ware1(b_imn.imn15,g_s.imn151) THEN
         LET g_success='N' 
      END IF       
     #FUN-CB0087--add--str--
     IF g_aza.aza115 = 'Y' AND cl_null(b_imn.imn28) THEN
        LET g_success = 'N'
        CALL cl_err('','aim-888',1)
        EXIT FOREACH
     END IF
     #FUN-CB0087--add--end
   END FOREACH 
   CALL s_showmsg()
   LET g_bgerr=0 
   IF g_success='N' THEN 
      RETURN 
   END IF    
#No.FUN-AB0067--end        
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   BEGIN WORK
 
    OPEN t720_cl USING g_imm.imm01
    IF STATUS THEN
       CALL cl_err("OPEN t720_cl:", STATUS, 1)
       CLOSE t720_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t720_cl INTO g_imm.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t720_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'
   UPDATE imm_file SET imm04 = 'Y' WHERE imm01 = g_imm.imm01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","imm_file",g_imm.imm01,"",SQLCA.sqlcode,"",
                   "upd imm_file",1)   #NO.FUN-640266 #No.FUN-660156 
      LET g_success = 'N'
   END IF
   IF g_success = 'Y'
      THEN COMMIT WORK
           CALL cl_flow_notify(g_imm.imm01,'Y')
      ELSE ROLLBACK WORK
   END IF
   SELECT imm04 INTO g_imm.imm04 FROM imm_file WHERE imm01 = g_imm.imm01
   DISPLAY BY NAME g_imm.imm04
END FUNCTION
 
FUNCTION t720_z()
   IF s_shut(0) THEN RETURN END IF
   #TQC-D40026--mark--str--
   #FUN-BC0062 ---------Begin--------
   ##當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
   #   SELECT ccz_file.* INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
   #   IF g_ccz.ccz28  = '6' AND g_imm.imm04 = 'Y' THEN
   #      CALL cl_err('','apm-936',1)
   #      RETURN
   #   END IF
   ##FUN-BC0062 ---------End----------
   #TQC-D40026--mark--str--
    SELECT * INTO g_imm.* FROM imm_file WHERE imm01=g_imm.imm01
   IF g_imm.imm04 = 'N' THEN  RETURN END IF
   IF g_imm.imm03 = 'Y' THEN CALL cl_err('','aim-308',0) RETURN END IF   #MOD-C30785
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
 
    OPEN t720_cl USING g_imm.imm01
    IF STATUS THEN
       CALL cl_err("OPEN t720_cl:", STATUS, 1)
       CLOSE t720_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t720_cl INTO g_imm.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t720_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'
   UPDATE imm_file SET imm04 = 'N' WHERE imm01 = g_imm.imm01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","imm_file",g_imm.imm01,"",SQLCA.sqlcode,"",
                   "upd imm_file",1)  
      LET g_success = 'N'
   END IF
   IF g_success = 'Y'
      THEN COMMIT WORK
      ELSE ROLLBACK WORK
   END IF
   SELECT imm04 INTO g_imm.imm04 FROM imm_file WHERE imm01 = g_imm.imm01
   DISPLAY BY NAME g_imm.imm04
END FUNCTION
 
FUNCTION t720_s()
DEFINE l_sql   LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(4000)
DEFINE l_imn10 LIKE imn_file.imn10
DEFINE l_imn29 LIKE imn_file.imn29
DEFINE l_imn03 LIKE imn_file.imn03
DEFINE l_qcs01 LIKE qcs_file.qcs01
DEFINE l_qcs02 LIKE qcs_file.qcs02
DEFINE l_buf       LIKE gem_file.gem02 #TQC-B50032
DEFINE l_cnt   LIKE type_file.num5  #CHI-D40043

   IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_imm.* FROM imm_file WHERE imm01=g_imm.imm01
   IF g_imm.imm03 = 'Y' THEN  RETURN END IF
   IF g_imm.imm04 = 'N' THEN CALL cl_err('','aim-393',0) RETURN END IF
   IF g_imm.imm04 = 'X' THEN RETURN END IF  #CHI-D40043
   IF g_imm.imm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   
   #CHI-D40043---begin
   SELECT COUNT(*) INTO l_cnt
     FROM imn_file
    WHERE imn01 = g_imm.imm01
   IF l_cnt = 0 THEN
      CALL cl_err(g_mm,'art-486',0)
      RETURN 
   END IF 
   #CHI-D40043---end
   #TQC-B50032--begin
   IF NOT cl_null(g_imm.imm14) THEN
      SELECT gem02 INTO l_buf FROM gem_file
       WHERE gem01=g_imm.imm14
         AND gemacti='Y'   
      IF STATUS THEN
         CALL cl_err3("sel","gem_file",g_imm.imm14,"",SQLCA.sqlcode,"","select gem",1)
         RETURN 
      END IF
   END IF
   #TQC-B50032--end               
	IF g_sma.sma53 IS NOT NULL AND g_imm.imm02 <= g_sma.sma53 THEN
	   CALL cl_err('','mfg9999',0) RETURN
	END IF
        CALL s_yp(g_imm.imm02) RETURNING g_yy,g_mm
        IF g_yy > g_sma.sma51			# 與目前會計年度,期間比較
        THEN CALL cl_err(g_yy,'mfg6090',0) RETURN
        ELSE IF g_mm > g_sma.sma52
             THEN CALL cl_err(g_mm,'mfg6091',0) RETURN
             END IF
        END IF
   IF NOT cl_confirm('mfg0176') THEN RETURN END IF
   LET l_sql="SELECT imn10,imn29,imn03,imn01,imn02 FROM imn_file",
             " WHERE imn01= '",g_imm.imm01,"'"
   PREPARE t324_curs1 FROM l_sql
   DECLARE t324_pre1 CURSOR FOR t324_curs1
   FOREACH t324_pre1 INTO l_imn10,l_imn29,l_imn03,l_qcs01,l_qcs02
    IF l_imn29='Y' THEN
      LET l_qcs091=0
      SELECT SUM(qcs091) INTO l_qcs091 FROM qcs_file
       WHERE qcs01=l_qcs01
         AND qcs02=l_qcs02
         AND qcs14='Y'
      IF cl_null(l_qcs091) THEN LET l_qcs091=0 END IF
      IF l_qcs091 < l_imn10 THEN
         CALL cl_err(l_imn03,'aim1003',1)
         RETURN
      END IF
    END IF
   END FOREACH
   IF cl_null(g_azp03) THEN
      SELECT azp01,azp03 INTO g_azp01,g_azp03
        FROM azp_file WHERE azp01=g_s.imn151
               LET g_azp03=s_dbstring(g_azp03 CLIPPED)
      IF STATUS THEN #CALL cl_err('select azp #1',STATUS,1) 
          CALL cl_err3("sel","azp_file",g_s.imn151,"",SQLCA.sqlcode,"",
                       "select azp #1",1)   #NO.FUN-640266  #No.FUN-660156
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM 
       END IF
 
       LET g_plant_new = g_s.imn151
       CALL s_gettrandbs()
       LET g_azp03_tra = g_dbs_tra
 
   END IF
   IF cl_null(g_azp03_tra) THEN
      LET g_plant_new = g_s.imn151
      CALL s_gettrandbs()
      LET g_azp03_tra = g_dbs_tra
   END IF
 
   SELECT azp03 INTO g_dbs FROM azp_file WHERE azp01=g_s.imn041
               LET g_dbs=s_dbstring(g_dbs CLIPPED)
   IF STATUS THEN #CALL cl_err('select azp #2',STATUS,1) 
       CALL cl_err3("sel","azp_file",g_s.imn041,"",SQLCA.sqlcode,"",
                    "select azp #2",1)   #NO.FUN-640266 #No.FUN-660156
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM 
   END IF
 
   LET g_plant_new = g_s.imn041
   CALL s_gettrandbs()
   LET g_db_tra = g_dbs_tra
   DECLARE t720_s1_c CURSOR FOR SELECT *
                       FROM imn_file WHERE imn01=g_imm.imm01
   BEGIN WORK
 
    OPEN t720_cl USING g_imm.imm01
    IF STATUS THEN
       CALL cl_err("OPEN t720_cl:", STATUS, 1)
       CLOSE t720_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t720_cl INTO g_imm.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t720_cl ROLLBACK WORK RETURN
    END IF
     LET g_success = 'Y'
     CALL s_showmsg_init()    #No.FUN-710025
     FOREACH t720_s1_c INTO b_imn.*
         IF STATUS THEN EXIT FOREACH END IF
         MESSAGE 'read imn:',b_imn.imn03
         IF cl_null(b_imn.imn04) THEN CONTINUE FOREACH END IF
          IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
          END IF                                                                                                                       
 
         #MOD-C50027 add begin-----------
         IF NOT s_stkminus(b_imn.imn03,b_imn.imn04,b_imn.imn05,b_imn.imn06,
                          #b_imn.imn10,b_imn.imn21,g_imm.imm02,g_sma.sma894[4,4]) THEN  #FUN-D30024--mark
                           b_imn.imn10,b_imn.imn21,g_imm.imm02) THEN                    #FUN-D30024--add

            LET g_totsuccess="N"
            CONTINUE FOREACH
         END IF
         #MOD-C50027 add end-------------

         #-->撥出更新
         IF t720_t(b_imn.*) THEN LET g_success = 'N' EXIT FOREACH END IF
         IF g_sma.sma115 = 'Y' THEN
            CALL t720_upd_s(b_imn.*) 
         END IF
         IF g_success = 'N' THEN EXIT FOREACH END IF
 
         #-->撥入更新
         IF t720_t2(b_imn.*) THEN  LET g_success ='N' EXIT FOREACH END IF
         IF g_sma.sma115 = 'Y' THEN
            CALL t720_upd_t(b_imn.*)
         END IF
         IF g_success = 'N' THEN EXIT FOREACH END IF
     END FOREACH
     IF g_totsuccess="N" THEN                                                                                                         
         LET g_success="N"                                                                                                             
     END IF                                                                                                                           
 
     IF g_success = 'Y' THEN   #FUN-5B0125
        UPDATE imm_file SET imm03 = 'Y' WHERE imm01 = g_imm.imm01
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
           CALL s_errmsg('imm01',g_imm.imm01,'up imm_file',SQLCA.sqlcode,1)
           LET g_success = 'N'
        END IF
        #-----MOD-C30785---------
        IF g_success = 'Y' THEN
           LET l_sql = " INSERT INTO ",cl_get_target_table(g_s.imn151,'imm_file'),
                       " SELECT * FROM imm_file WHERE imm01='",g_imm.imm01,"'"
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
           CALL cl_parse_qry_sql(l_sql,g_s.imn151) RETURNING l_sql   
           PREPARE i720_ins_p1 FROM l_sql
           EXECUTE i720_ins_p1
           LET l_sql = " INSERT INTO ",cl_get_target_table(g_s.imn151,'imn_file'),
                       " SELECT * FROM imn_file WHERE imn01='",g_imm.imm01,"'"
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
           CALL cl_parse_qry_sql(l_sql,g_s.imn151) RETURNING l_sql
           PREPARE i720_ins_p2 FROM l_sql
           EXECUTE i720_ins_p2
        END IF
        #-----END MOD-C30785-----
     END IF                    #FUN-5B0125
     CALL s_showmsg()          #No.FUN-710025
   IF g_success = 'Y'
      THEN COMMIT WORK
           CALL cl_flow_notify(g_imm.imm01,'S')
      ELSE ROLLBACK WORK
   END IF
   SELECT imm03 INTO g_imm.imm03 FROM imm_file WHERE imm01 = g_imm.imm01
   DISPLAY BY NAME g_imm.imm03
END FUNCTION
 
FUNCTION t720_w()
   DEFINE l_sql   STRING   #MOD-C30785
 
   IF s_shut(0) THEN RETURN END IF
   #TQC-D40026--mark--str--
   #FUN-BC0062 ---------Begin--------
   ##當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
   #   SELECT ccz_file.* INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
   #   IF g_ccz.ccz28  = '6' AND g_imm.imm03 = 'Y' THEN
   #      CALL cl_err('','apm-936',1)
   #      RETURN
   #   END IF
   ##FUN-BC0062 ---------End----------
   #TQC-D40026--mark--end--
    SELECT * INTO g_imm.* FROM imm_file WHERE imm01=g_imm.imm01
   IF g_imm.imm03 = 'N' THEN CALL cl_err('','afa-108',0) RETURN END IF
   IF g_imm.imm04 = 'N' THEN CALL cl_err('','aim-393',0) RETURN END IF
   IF g_imm.imm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF NOT cl_confirm('asf-663') THEN RETURN END IF
   IF cl_null(g_azp03) THEN
      SELECT azp01,azp03 INTO g_azp01,g_azp03
        FROM azp_file WHERE azp01=g_s.imn151
               LET g_azp03=s_dbstring(g_azp03 CLIPPED)
      IF STATUS THEN #CALL cl_err('select azp #1',STATUS,1) 
          CALL cl_err3("sel","azp_file",g_s.imn151,"",SQLCA.sqlcode,"",
                       "select azp #1",1)   #NO.FUN-640266  #No.FUN-660156
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM 
       END IF
 
      LET g_plant_new = g_s.imn151
      CALL s_gettrandbs()
      LET g_azp03_tra = g_dbs_tra
 
   END IF
 
   IF cl_null(g_azp03_tra) THEN
      LET g_plant_new = g_s.imn151
      CALL s_gettrandbs()
      LET g_azp03_tra = g_dbs_tra
   END IF
 
   SELECT azp03 INTO g_dbs FROM azp_file WHERE azp01=g_s.imn041
               LET g_dbs=s_dbstring(g_dbs CLIPPED)
   IF STATUS THEN #CALL cl_err('select azp #2',STATUS,1) 
       CALL cl_err3("sel","azp_file",g_s.imn041,"",SQLCA.sqlcode,"",
                    "select azp #2",1)   #NO.FUN-640266 #No.FUN-660156
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM 
   END IF
 
   LET g_plant_new = g_s.imn041
   CALL s_gettrandbs()
   LET g_db_tra = g_dbs_tra
 
   DECLARE t720_s1_c1 CURSOR FOR SELECT *
                       FROM imn_file WHERE imn01=g_imm.imm01
   BEGIN WORK
 
    OPEN t720_cl USING g_imm.imm01
    IF STATUS THEN
       CALL cl_err("OPEN t720_cl:", STATUS, 1)
       CLOSE t720_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t720_cl INTO g_imm.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t720_cl ROLLBACK WORK RETURN
    END IF
    LET g_success = 'Y'
    CALL s_showmsg_init()    #No.FUN-710025
    FOREACH t720_s1_c1 INTO b_imn.*
        IF STATUS THEN EXIT FOREACH END IF
        MESSAGE 'read imn:',b_imn.imn03
        IF cl_null(b_imn.imn04) THEN CONTINUE FOREACH END IF
        IF g_success='N' THEN                                                                                                        
            LET g_totsuccess='N'                                                                                                      
            LET g_success="Y"                                                                                                         
        END IF                                                                                                                       
 
        #-->撥出更新
        IF t720_t3(b_imn.*) THEN LET g_success = 'N' EXIT FOREACH END IF
        IF g_sma.sma115 = 'Y' THEN
           CALL t720_upd_s1(b_imn.*) 
        END IF
        IF g_success = 'N' THEN EXIT FOREACH END IF
 
         #-->撥入更新
         IF t720_t4(b_imn.*) THEN  LET g_success ='N' EXIT FOREACH END IF
         IF g_sma.sma115 = 'Y' THEN
            CALL t720_upd_t1(b_imn.*)
         END IF
         CALL t720_u_tlf()     #MOD-8A0055 
         IF g_success = 'N' THEN EXIT FOREACH END IF
     END FOREACH
     #-----MOD-C30785---------
     IF g_success = 'Y' THEN 
        LET l_sql = " DELETE FROM  ",cl_get_target_table(g_s.imn151,'imm_file'),
                    " WHERE imm01='",g_imm.imm01,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,g_s.imn151) RETURNING l_sql
        PREPARE i720_del_p3 FROM l_sql  
        EXECUTE i720_del_p3
        LET l_sql = " DELETE FROM  ",cl_get_target_table(g_s.imn151,'imn_file'),
                    " WHERE imn01='",g_imm.imm01,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,g_s.imn151) RETURNING l_sql
        PREPARE i720_del_p4 FROM l_sql
        EXECUTE i720_del_p4 
     END IF
     #-----MOD-C30785-----
 
     IF g_totsuccess="N" THEN                                                                                                         
         LET g_success="N"                                                                                                             
     END IF                                                                                                                           
 
     IF g_success = 'Y' THEN   #FUN-5B0125
        UPDATE imm_file SET imm03 = 'N' WHERE imm01 = g_imm.imm01
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
           CALL s_errmsg('imm01',g_imm.imm01,'up imm_file',SQLCA.sqlcode,1)
           LET g_success = 'N'
        END IF
     END IF                    #FUN-5B0125
     CALL s_showmsg()          #No.FUN-710025
   IF g_success = 'Y'
      THEN COMMIT WORK
           CALL cl_flow_notify(g_imm.imm01,'S')
      ELSE ROLLBACK WORK
   END IF
   SELECT imm03 INTO g_imm.imm03 FROM imm_file WHERE imm01 = g_imm.imm01
   DISPLAY BY NAME g_imm.imm03
END FUNCTION
 
FUNCTION t720_upd_s(p_imn)
 DEFINE p_imn     RECORD LIKE imn_file.*
 DEFINE l_ima25   LIKE ima_file.ima25,
        u_type    LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
  SELECT ima906,ima907,ima25 INTO g_ima906,g_ima907,l_ima25 FROM ima_file
   WHERE ima01 = p_imn.imn03
  IF SQLCA.sqlcode THEN
     LET g_success='N' RETURN
  END IF
  IF g_ima906 = '1' OR cl_null(g_ima906) THEN
     RETURN
  END IF
 
  IF g_ima906 = '2' THEN  #子母單位
     IF NOT cl_null(p_imn.imn33) THEN
        CALL t720_upd_imgg('1',p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,
                           p_imn.imn33,p_imn.imn34,p_imn.imn35,'-1','2')
        IF g_success='N' THEN RETURN END IF
        IF NOT cl_null(p_imn.imn35) THEN                                       #CHI-860005  
           CALL t720_tlff_1('2',p_imn.*,'+1',g_s.imn041) #FUN-980093 add
           IF g_success='N' THEN RETURN END IF
        END IF
     END IF
     IF NOT cl_null(p_imn.imn30) THEN
        CALL t720_upd_imgg('1',p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,
                           p_imn.imn30,p_imn.imn31,p_imn.imn32,'-1','1')
        IF g_success='N' THEN RETURN END IF
        IF NOT cl_null(p_imn.imn32) THEN                                       #CHI-860005 
           CALL t720_tlff_2('1',p_imn.*,'-1',g_s.imn041) #FUN-980093 add
           IF g_success='N' THEN RETURN END IF
        END IF
     END IF
  END IF
  IF g_ima906 = '3' THEN  #參考單位
     IF NOT cl_null(p_imn.imn33) THEN
        CALL t720_upd_imgg('2',p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,
                           p_imn.imn33,p_imn.imn34,p_imn.imn35,'-1','2')
        IF g_success = 'N' THEN RETURN END IF
        IF NOT cl_null(p_imn.imn35) THEN                                       #CHI-860005
           CALL t720_tlff_1('2',p_imn.*,'-1',g_s.imn041) #FUN-980093 add
           IF g_success='N' THEN RETURN END IF
        END IF
     END IF
  END IF
 
END FUNCTION
 
FUNCTION t720_upd_t(p_imn)
 DEFINE p_imn     RECORD LIKE imn_file.*
 DEFINE l_ima25   LIKE ima_file.ima25,
        u_type    LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
  SELECT ima906,ima907,ima25 INTO g_ima906,g_ima907,l_ima25 FROM ima_file
   WHERE ima01 = p_imn.imn03
  IF SQLCA.sqlcode THEN
     LET g_success='N' RETURN
  END IF
  IF g_ima906 = '1' OR cl_null(g_ima906) THEN RETURN END IF
 
  IF g_ima906 = '2' THEN  #子母單位
     IF NOT cl_null(p_imn.imn43) THEN
        CALL t720_upd_imgg1('1',p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,
                            p_imn.imn43,p_imn.imn44,p_imn.imn45,+1,'2')
        IF g_success='N' THEN RETURN END IF
        IF NOT cl_null(p_imn.imn45) THEN                                       #CHI-860005    
           CALL t720_tlff_1('2',p_imn.*,+1,g_s.imn151) #FUN-980093 add
           IF g_success='N' THEN RETURN END IF
        END IF
     END IF
     IF NOT cl_null(p_imn.imn40) THEN
        CALL t720_upd_imgg1('1',p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,
                            p_imn.imn40,p_imn.imn41,p_imn.imn42,+1,'1')
        IF g_success='N' THEN RETURN END IF
        IF NOT cl_null(p_imn.imn42) THEN                                       #CHI-860005
           CALL t720_tlff_2('1',p_imn.*,+1,g_s.imn151) #FUN-980093 add
           IF g_success='N' THEN RETURN END IF
        END IF
     END IF
  END IF
  IF g_ima906 = '3' THEN  #參考單位
     IF NOT cl_null(p_imn.imn43) THEN
        CALL t720_upd_imgg1('2',p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,
                           p_imn.imn43,p_imn.imn44,p_imn.imn45,+1,'2')
        IF g_success = 'N' THEN RETURN END IF
        IF NOT cl_null(p_imn.imn45) THEN                                       #CHI-860005
           CALL t720_tlff_1('2',p_imn.*,+1,g_s.imn151) #FUN-980093 add
           IF g_success='N' THEN RETURN END IF
        END IF
     END IF
  END IF
 
END FUNCTION
 
FUNCTION t720_upd_s1(p_imn)
 DEFINE p_imn     RECORD LIKE imn_file.*
 DEFINE l_ima25   LIKE ima_file.ima25,
        u_type    LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
  SELECT ima906,ima907,ima25 INTO g_ima906,g_ima907,l_ima25 FROM ima_file
   WHERE ima01 = p_imn.imn03
  IF SQLCA.sqlcode THEN
     LET g_success='N' RETURN
  END IF
  IF g_ima906 = '1' OR cl_null(g_ima906) THEN
     RETURN
  END IF
 
  IF g_ima906 = '2' THEN  #子母單位
     IF NOT cl_null(p_imn.imn33) THEN
        CALL t720_upd_imgg('1',p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,
                           p_imn.imn33,p_imn.imn34,p_imn.imn35,'+1','2')
        IF g_success='N' THEN RETURN END IF
        CALL t720_u_tlff(b_imn.*)
        IF g_success='N' THEN RETURN END IF
     END IF
     IF NOT cl_null(p_imn.imn30) THEN
        CALL t720_upd_imgg('1',p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,
                           p_imn.imn30,p_imn.imn31,p_imn.imn32,'+1','1')
        IF g_success='N' THEN RETURN END IF
        CALL t720_u_tlff(b_imn.*)
        IF g_success='N' THEN RETURN END IF
     END IF
  END IF
  IF g_ima906 = '3' THEN  #參考單位
     IF NOT cl_null(p_imn.imn33) THEN
        CALL t720_upd_imgg('2',p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,
                           p_imn.imn33,p_imn.imn34,p_imn.imn35,'+1','2')
        IF g_success = 'N' THEN RETURN END IF
        CALL t720_u_tlff(b_imn.*)
        IF g_success='N' THEN RETURN END IF
     END IF
  END IF
END FUNCTION
 
FUNCTION t720_upd_t1(p_imn)
 DEFINE p_imn     RECORD LIKE imn_file.*
 DEFINE l_ima25   LIKE ima_file.ima25,
        u_type    LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
  SELECT ima906,ima907,ima25 INTO g_ima906,g_ima907,l_ima25 FROM ima_file
   WHERE ima01 = p_imn.imn03
  IF SQLCA.sqlcode THEN
     LET g_success='N' RETURN
  END IF
  IF g_ima906 = '1' OR cl_null(g_ima906) THEN RETURN END IF
 
  IF g_ima906 = '2' THEN  #子母單位
     IF NOT cl_null(p_imn.imn33) THEN
#MOD-C10126 --begin--
#        CALL t720_upd_imgg('1',p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,
#                           p_imn.imn33,p_imn.imn34,p_imn.imn35,'-1','2')

         CALL t720_upd_imgg1('1',p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,
                           p_imn.imn43,p_imn.imn44,p_imn.imn45,'-1','2')
#MOD-C10126 --end--

        IF g_success='N' THEN RETURN END IF
        CALL t720_u_tlff(b_imn.*)
        IF g_success='N' THEN RETURN END IF
     END IF
     IF NOT cl_null(p_imn.imn30) THEN
#MOD-C10126 --begin--
#       CALL t720_upd_imgg('1',p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,
#                           p_imn.imn30,p_imn.imn31,p_imn.imn32,'-1','1')

         CALL t720_upd_imgg1('1',p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,
                           p_imn.imn40,p_imn.imn41,p_imn.imn42,'-1','1')
#MOD-C10126 --end--

        IF g_success='N' THEN RETURN END IF
        CALL t720_u_tlff(b_imn.*)
        IF g_success='N' THEN RETURN END IF
     END IF
  END IF
  IF g_ima906 = '3' THEN  #參考單位
     IF NOT cl_null(p_imn.imn33) THEN
#MOD-C10126 --begin--
#       CALL t720_upd_imgg('2',p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,
#                           p_imn.imn33,p_imn.imn34,p_imn.imn35,'-1','2')

        CALL t720_upd_imgg1('1',p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,
                           p_imn.imn43,p_imn.imn44,p_imn.imn45,'-1','2')
#MOD-C10126 --end--

        IF g_success = 'N' THEN RETURN END IF
#       CALL t720_u_tlff(b_imn.*)             #MOD-C10126
        IF g_success='N' THEN RETURN END IF
     END IF
  END IF
END FUNCTION
 
FUNCTION t720_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg211,p_imgg10,p_type,p_no)
 DEFINE p_imgg00   LIKE imgg_file.imgg00,
        p_imgg01   LIKE imgg_file.imgg01,
        p_imgg02   LIKE imgg_file.imgg02,
        p_imgg03   LIKE imgg_file.imgg03,
        p_imgg04   LIKE imgg_file.imgg04,
        p_imgg09   LIKE imgg_file.imgg09,
        p_imgg211  LIKE imgg_file.imgg211,
        p_imgg10   LIKE imgg_file.imgg10,
        p_no       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_ima25    LIKE ima_file.ima25,
        l_ima906   LIKE ima_file.ima906,
        l_imgg21   LIKE imgg_file.imgg21,
        p_type     LIKE type_file.num10    #No.FUN-690026 INTEGER
DEFINE l_img   RECORD
            img16      LIKE img_file.img16,
            img23      LIKE img_file.img23,
            img24      LIKE img_file.img24,
            img09      LIKE img_file.img09,
            img21      LIKE img_file.img21
            END RECORD
 
   LET g_forupd_sql =
       "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
       "  WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
       "   AND imgg09= ? FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE imgg_lock CURSOR FROM g_forupd_sql
 
   OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
   IF STATUS THEN
      CALL cl_err("OPEN imgg_lock:", STATUS, 1)
      LET g_success='N'
      CLOSE imgg_lock
      RETURN
   END IF
   FETCH imgg_lock INTO p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
   IF STATUS THEN
      CALL cl_err('lock imgg fail',STATUS,1)
      LET g_success='N'
      CLOSE imgg_lock
      RETURN
   END IF
 
   SELECT ima25,ima906 INTO l_ima25,l_ima906
     FROM ima_file WHERE ima01=p_imgg01
   IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
      CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"","ima25 null",1)  #No.FUN-660156 
      LET g_success = 'N' RETURN
   END IF
 
   CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
         RETURNING g_cnt,l_imgg21
   IF g_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
      CALL cl_err('','mfg3075',0)
      LET g_success = 'N' RETURN
   END IF
 
   CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,g_imm.imm02,  #FUN-8C0084
         p_imgg01,p_imgg02,p_imgg03,p_imgg04,'','','','',p_imgg09,'',l_imgg21,'','','','','','','',p_imgg211)
   IF g_success='N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t720_upd_imgg1(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg211,p_imgg10,p_type,p_no)
DEFINE p_imgg00   LIKE imgg_file.imgg00,
       p_imgg01   LIKE imgg_file.imgg01,
       p_imgg02   LIKE imgg_file.imgg02,
       p_imgg03   LIKE imgg_file.imgg03,
       p_imgg04   LIKE imgg_file.imgg04,
       p_imgg09   LIKE imgg_file.imgg09,
       p_imgg211  LIKE imgg_file.imgg211,
       p_imgg10   LIKE imgg_file.imgg10,
       p_no       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
       l_ima25    LIKE ima_file.ima25,
       l_ima906   LIKE ima_file.ima906,
       l_imgg21   LIKE imgg_file.imgg21,
       p_type     LIKE type_file.num10    #No.FUN-690026 INTEGER
 
  LET g_forupd_sql =
     #FUN-A50102--mod--str--
     #"SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM ",g_azp03_tra CLIPPED,"imgg_file ", #FUN-980093 add
      "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 ",
      "  FROM ",cl_get_target_table(g_s.imn151,'imgg_file'),   
     #FUN-A50102--mod--end
      "  WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
      "   AND imgg09= ? FOR UPDATE "
  #CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql   #FUN-A50102    #FUN-B80070--mark--
  CALL cl_forupd_sql(g_forupd_sql) RETURNING g_forupd_sql       #FUN-B80070--add---
  CALL cl_parse_qry_sql(g_forupd_sql,g_s.imn151) RETURNING g_forupd_sql #FUN-980093 add
 
  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
  DECLARE imgg_lock1 CURSOR FROM g_forupd_sql
 
  OPEN imgg_lock1 USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
  IF STATUS THEN
     CALL cl_err("OPEN imgg_lock1:", STATUS, 1)
     LET g_success='N'
     CLOSE imgg_lock1
     RETURN
  END IF
  FETCH imgg_lock1 INTO p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
  IF STATUS THEN
     CALL cl_err('lock imgg fail',STATUS,1)
     LET g_success='N'
     CLOSE imgg_lock1
     RETURN
  END IF
 
  SELECT ima25,ima906 INTO l_ima25,l_ima906
    FROM ima_file WHERE ima01=p_imgg01
  IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
     CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"","ima25 null",1)   #No.FUN-660156
     LET g_success = 'N' RETURN
  END IF
 
  CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
        RETURNING g_cnt,l_imgg21
  IF g_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
     CALL cl_err('','mfg3075',0)
     LET g_success = 'N' RETURN
  END IF
 
  LET g_azp03_o = t720_catstr(g_azp03)
  CALL s_upimgg1(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,g_imm.imm02,p_imgg01, #FUN-8C0084
                 p_imgg02,p_imgg03,p_imgg04,g_imm.imm01,'','','',p_imgg09,'',l_imgg21,'','','','','','','',
                 p_imgg211,g_s.imn151) #FUN-980093 add
  IF g_success='N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t720_tlff_1(p_flag,p_imn,p_type,p_plant) #FUN-980093 add
DEFINE
  p_imn      RECORD LIKE imn_file.*,
  p_flag     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
  p_type     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  l_imgg10_s LIKE imgg_file.imgg10,
  l_imgg10_t LIKE imgg_file.imgg10,
  p_dbs      LIKE type_file.chr21,   #No.FUN-690026 VARCHAR(21)
  p_plant    LIKE type_file.chr21,#FUN-980093
  p_dbs_tra  LIKE type_file.chr21 #FUN-980093
 
  LET g_plant_new = p_plant
  CALL s_getdbs()       LET p_dbs = g_dbs_new
  CALL s_gettrandbs()   LET p_dbs_tra = g_dbs_tra
 
   IF p_imn.imn33 IS NULL THEN
      CALL cl_err('p_imn33 null:','asf-031',1) LET g_success = 'N' RETURN
   END IF
 
   IF p_imn.imn43 IS NULL THEN
      CALL cl_err('p_imn43 null:','asf-031',1) LET g_success = 'N' RETURN
   END IF
 
   INITIALIZE g_tlff.* TO NULL
   SELECT imgg10 INTO l_imgg10_s FROM imgg_file
    WHERE imgg01=p_imn.imn03  AND imgg02=p_imn.imn04
      AND imgg03=p_imn.imn05  AND imgg04=p_imn.imn06
      AND imgg09=p_imn.imn33
   IF cl_null(l_imgg10_s) THEN LET l_imgg10_s=0 END IF
 
   SELECT imgg10 INTO l_imgg10_t FROM imgg_file
    WHERE imgg01=p_imn.imn03  AND imgg02=p_imn.imn15
      AND imgg03=p_imn.imn16  AND imgg04=p_imn.imn17
      AND imgg09=p_imn.imn43
   IF cl_null(l_imgg10_t) THEN LET l_imgg10_t=0 END IF
 
   LET g_tlff.tlff01=p_imn.imn03               #異動料件編號
   #----來源----
   LET g_tlff.tlff02=50                        #來源為倉庫(撥出)
   LET g_tlff.tlff020=g_plant                  #工廠別
   LET g_tlff.tlff021=p_imn.imn04              #倉庫別
   LET g_tlff.tlff022=p_imn.imn05              #儲位別
   LET g_tlff.tlff023=p_imn.imn06              #批號
   LET g_tlff.tlff024=l_imgg10_s#-p_imn.imn35  #異動後庫存數量
   LET g_tlff.tlff025=p_imn.imn33              #庫存單位(ima_file or img_file)
   LET g_tlff.tlff026=p_imn.imn01              #調撥單號
   LET g_tlff.tlff027=p_imn.imn02              #項次
 
   #----目的----
   LET g_tlff.tlff03=50                        #資料目的為(撥入)
   LET g_tlff.tlff030=g_plant                  #工廠別
   LET g_tlff.tlff031=p_imn.imn15              #倉庫別
   LET g_tlff.tlff032=p_imn.imn16              #儲位別
   LET g_tlff.tlff033=p_imn.imn17              #批號
   LET g_tlff.tlff034=l_imgg10_t#+p_imn.imn44  #異動後庫存量
   LET g_tlff.tlff035=p_imn.imn43              #庫存單位(ima_file or img_file)
   LET g_tlff.tlff036=p_imn.imn01              #參考號碼
   LET g_tlff.tlff037=p_imn.imn02              #項次
 
   #---- 97/06/20 調撥作業來源目的碼
   IF p_type=-1 THEN #-- 出
      LET g_tlff.tlff02=50
      LET g_tlff.tlff03=99
      LET g_tlff.tlff030=' '
      LET g_tlff.tlff031=' '
      LET g_tlff.tlff032=' '
      LET g_tlff.tlff033=' '
      LET g_tlff.tlff034=0
      LET g_tlff.tlff035=' '
      LET g_tlff.tlff036=' '
      LET g_tlff.tlff037=0
      LET g_tlff.tlff10=p_imn.imn35            #調撥數量
      LET g_tlff.tlff11=p_imn.imn33            #撥出單位
      LET g_tlff.tlff12=p_imn.imn34            #撥出/撥入庫存轉換率
      LET g_tlff.tlff930=p_imn.imn9301   #FUN-670093
   ELSE               #-- 入
      LET g_tlff.tlff02=99
      LET g_tlff.tlff03=50
      LET g_tlff.tlff020=' '
      LET g_tlff.tlff021=' '
      LET g_tlff.tlff022=' '
      LET g_tlff.tlff023=' '
      LET g_tlff.tlff024=0
      LET g_tlff.tlff025=' '
      LET g_tlff.tlff026=' '
      LET g_tlff.tlff027=0
      LET g_tlff.tlff10=p_imn.imn45            #調撥數量
      LET g_tlff.tlff11=p_imn.imn43            #撥入單位
      LET g_tlff.tlff12=p_imn.imn44            #撥入/撥出庫存轉換率
      LET g_tlff.tlff930=p_imn.imn9302   #FUN-670093
   END IF
 
   #--->異動數量
   LET g_tlff.tlff04=' '                       #工作站
   LET g_tlff.tlff05=' '                       #作業序號
   LET g_tlff.tlff06=g_imm.imm02               #發料日期
   LET g_tlff.tlff07=g_today                   #異動資料產生日期
   LET g_tlff.tlff08=TIME                      #異動資料產生時:分:秒
   LET g_tlff.tlff09=g_user                    #產生人
   LET g_tlff.tlff13='aimt720'                 #異動命令代號
   LET g_tlff.tlff14=p_imn.imn28               #異動原因
   LET g_tlff.tlff15=g_debit                   #借方會計科目
   LET g_tlff.tlff16=g_credit                  #貸方會計科目
   LET g_tlff.tlff17=g_imm.imm09               #remark
   LET g_tlff.tlff19= ' '                      #異動廠商/客戶編號
   LET g_tlff.tlff20= ' '                      #project no.
   IF p_type=-1 THEN
      IF cl_null(p_imn.imn35) OR p_imn.imn35 = 0 THEN
         CALL s_tlff2(p_flag,NULL,p_plant) #FUN-980093 add
      ELSE
         CALL s_tlff2(p_flag,p_imn.imn33,p_plant) #FUN-980093 add
      END IF
   ELSE
      IF cl_null(p_imn.imn45) OR p_imn.imn45 = 0 THEN
         CALL s_tlff2(p_flag,NULL,p_plant) #FUN-980093 add
      ELSE
         CALL s_tlff2(p_flag,p_imn.imn43,p_plant) #FUN-980093 add
      END IF
   END IF
END FUNCTION
 
FUNCTION t720_tlff_2(p_flag,p_imn,p_type,p_plant) #FUN-980093 add
DEFINE
   p_imn      RECORD LIKE imn_file.*,
   p_flag     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
   p_type     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
   l_imgg10_s LIKE imgg_file.imgg10,
   l_imgg10_t LIKE imgg_file.imgg10,
   p_dbs      LIKE type_file.chr21,   #No.FUN-690026 VARCHAR(21)
   p_plant    LIKE type_file.chr21,#FUN-980093
   p_dbs_tra  LIKE type_file.chr21 #FUN-980093
 
  LET g_plant_new = p_plant
  CALL s_getdbs()       LET p_dbs = g_dbs_new
  CALL s_gettrandbs()   LET p_dbs_tra = g_dbs_tra
 
   IF p_imn.imn30 IS NULL THEN
      CALL cl_err('p_imn30 null:','asf-031',1) LET g_success = 'N' RETURN
   END IF
 
   IF p_imn.imn40 IS NULL THEN
      CALL cl_err('p_imn40 null:','asf-031',1) LET g_success = 'N' RETURN
   END IF
 
   INITIALIZE g_tlff.* TO NULL
   SELECT imgg10 INTO l_imgg10_s FROM imgg_file
    WHERE imgg01=p_imn.imn03  AND imgg02=p_imn.imn04
      AND imgg03=p_imn.imn05  AND imgg04=p_imn.imn06
      AND imgg09=p_imn.imn30
   IF cl_null(l_imgg10_s) THEN LET l_imgg10_s=0 END IF
 
   SELECT imgg10 INTO l_imgg10_t FROM imgg_file
    WHERE imgg01=p_imn.imn03  AND imgg02=p_imn.imn15
      AND imgg03=p_imn.imn16  AND imgg04=p_imn.imn17
      AND imgg09=p_imn.imn40
   IF cl_null(l_imgg10_t) THEN LET l_imgg10_t=0 END IF
 
   LET g_tlff.tlff01=p_imn.imn03               #異動料件編號
   #----來源----
   LET g_tlff.tlff02=50                        #來源為倉庫(撥出)
   LET g_tlff.tlff020=g_plant                  #工廠別
   LET g_tlff.tlff021=p_imn.imn04              #倉庫別
   LET g_tlff.tlff022=p_imn.imn05              #儲位別
   LET g_tlff.tlff023=p_imn.imn06              #批號
   LET g_tlff.tlff024=l_imgg10_s#-p_imn.imn31  #異動後庫存數量
   LET g_tlff.tlff025=p_imn.imn30              #庫存單位(ima_file or img_file
   LET g_tlff.tlff026=p_imn.imn01              #調撥單號
   LET g_tlff.tlff027=p_imn.imn02              #項次
 
   #----目的----
   LET g_tlff.tlff03=50                        #資料目的為(撥入)
   LET g_tlff.tlff030=g_plant                  #工廠別
   LET g_tlff.tlff031=p_imn.imn15              #倉庫別
   LET g_tlff.tlff032=p_imn.imn16              #儲位別
   LET g_tlff.tlff033=p_imn.imn17              #批號
   LET g_tlff.tlff034=l_imgg10_t#+p_imn.imn41  #異動後庫存量
   LET g_tlff.tlff035=p_imn.imn40              #庫存單位(ima_file or img_file)
   LET g_tlff.tlff036=p_imn.imn01              #參考號碼
   LET g_tlff.tlff037=p_imn.imn02              #項次
 
   #---- 97/06/20 調撥作業來源目的碼
   IF p_type=-1 THEN #-- 出
      LET g_tlff.tlff02=50
      LET g_tlff.tlff03=99
      LET g_tlff.tlff030=' '
      LET g_tlff.tlff031=' '
      LET g_tlff.tlff032=' '
      LET g_tlff.tlff033=' '
      LET g_tlff.tlff034=0
      LET g_tlff.tlff035=' '
      LET g_tlff.tlff036=' '
      LET g_tlff.tlff037=0
      LET g_tlff.tlff10=p_imn.imn32            #調撥數量
      LET g_tlff.tlff11=p_imn.imn30            #撥出單位
      LET g_tlff.tlff12=p_imn.imn31            #撥出/撥入庫存轉換率
      LET g_tlff.tlff930=p_imn.imn9301   #FUN-670093
   ELSE               #-- 入
      LET g_tlff.tlff02=99
      LET g_tlff.tlff03=50
      LET g_tlff.tlff020=' '
      LET g_tlff.tlff021=' '
      LET g_tlff.tlff022=' '
      LET g_tlff.tlff023=' '
      LET g_tlff.tlff024=0
      LET g_tlff.tlff025=' '
      LET g_tlff.tlff026=' '
      LET g_tlff.tlff027=0
      LET g_tlff.tlff10=p_imn.imn42            #調撥數量
      LET g_tlff.tlff11=p_imn.imn40            #撥入單位
      LET g_tlff.tlff12=p_imn.imn41            #撥入/撥出庫存轉換率
      LET g_tlff.tlff930=p_imn.imn9302   #FUN-670093
   END IF
 
   #--->異動數量
   LET g_tlff.tlff04=' '                       #工作站
   LET g_tlff.tlff05=' '                       #作業序號
   LET g_tlff.tlff06=g_imm.imm02               #發料日期
   LET g_tlff.tlff07=g_today                   #異動資料產生日期
   LET g_tlff.tlff08=TIME                      #異動資料產生時:分:秒
   LET g_tlff.tlff09=g_user                    #產生人
   LET g_tlff.tlff13='aimt720'                 #異動命令代號
   LET g_tlff.tlff14=p_imn.imn28               #異動原因
   LET g_tlff.tlff15=g_debit                   #借方會計科目
   LET g_tlff.tlff16=g_credit                  #貸方會計科目
   LET g_tlff.tlff17=g_imm.imm09               #remark
   LET g_tlff.tlff19= ' '                      #異動廠商/客戶編號
   LET g_tlff.tlff20= ' '                      #project no.
   IF p_type=-1 THEN
      IF cl_null(p_imn.imn35) OR p_imn.imn35 = 0 THEN
         CALL s_tlff2(p_flag,NULL,p_plant) #FUN-980093 add
      ELSE
         CALL s_tlff2(p_flag,p_imn.imn33,p_plant) #FUN-980093 add
      END IF
   ELSE
      IF cl_null(p_imn.imn45) OR p_imn.imn45 = 0 THEN
         CALL s_tlff2(p_flag,NULL,p_plant) #FUN-980093 add
      ELSE
         CALL s_tlff2(p_flag,p_imn.imn43,p_plant) #FUN-980093 add
      END IF
   END IF
END FUNCTION
 
#-->撥出更新
FUNCTION t720_t(p_imn)
DEFINE
    p_imn   RECORD LIKE imn_file.*,
    l_sql   LIKE type_file.chr1000,            #No.FUN-690026 VARCHAR(300)
    l_img   RECORD
            img16      LIKE img_file.img16,
            img23      LIKE img_file.img23,
            img24      LIKE img_file.img24,
            img09      LIKE img_file.img09,
            img21      LIKE img_file.img21
            END RECORD,
    l_qty   LIKE img_file.img10,
    l_n     LIKE type_file.num5                #No.FUN-690026 SMALLINT
 
    MESSAGE "update img_file ..."
    LET l_n = 0
    IF cl_null(p_imn.imn04) THEN LET p_imn.imn04=' ' END IF
    IF cl_null(p_imn.imn05) THEN LET p_imn.imn05=' ' END IF
    IF cl_null(p_imn.imn06) THEN LET p_imn.imn06=' ' END IF
 
    LET g_forupd_sql="SELECT img16,img23,img24,img09,img21,img26,img10",
                    #"  FROM ",g_db_tra CLIPPED,"img_file ", #FUN-980093 add  #FUN-A50102
                     "  FROM ",cl_get_target_table(g_s.imn041,'img_file'),    #FUN-A50102
                     "  WHERE img01= ? AND img02= ? AND img03= ? AND img04= ? ",
                     "   FOR UPDATE "
    # 	 CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql    #FUN-920032  #FUN-B80070--mark--
    CALL cl_forupd_sql(g_forupd_sql) RETURNING g_forupd_sql       #FUN-B80070--add---
    CALL cl_parse_qry_sql(g_forupd_sql,g_s.imn041) RETURNING g_forupd_sql #FUN-980093
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img_lock CURSOR FROM g_forupd_sql
 
    OPEN img_lock USING p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06
    IF SQLCA.sqlcode THEN
       CALL cl_err('lock img fail',STATUS,1)    #NO.TQC-930155 
       LET g_success = 'N'
       RETURN 1
    END IF
    FETCH img_lock INTO l_img.*,g_debit,g_img10
    IF SQLCA.sqlcode THEN
       CALL cl_err('lock img fail',STATUS,1)   #NO.TQC-930155 
       LET g_success = 'N'
       RETURN 1
    END IF
 
    IF l_n = 0 THEN
       LET g_azp03_o = t720_catstr(g_dbs)
       LET l_n = l_n + 1
    ELSE
       LET g_azp03_o = g_dbs
    END IF
    #No.TQC-A60018--begin
    IF cl_null(l_img.img16) THEN 
       LET l_img.img16=g_today
    END IF 
    #No.TQC-A60018--end
#-->更新倉庫庫存明細資料
#                 1           2  3           4
   #CALL s_upimg1(' ',-1,p_imn.imn10,l_img.img16,  #FUN-8C0084
    CALL s_upimg1(p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,-1,p_imn.imn10,l_img.img16,  #FUN-8C0084
#       5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22  23
        '','','','','','','','','','','','','','','','','','',g_s.imn041) #FUN-980093 add
    IF g_success = 'N' THEN RETURN 1 END IF
 
#-->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
    MESSAGE "update ima_file ..."
 
   #LET g_forupd_sql="SELECT ima25 FROM ",s_dbstring(g_dbs CLIPPED),"ima_file",#TQC-940178 ADD #FUN-A50102
    LET g_forupd_sql="SELECT ima25 FROM ",cl_get_target_table(g_plant,'ima_file'),   #FUN-A50102
                     " WHERE ima01= ? FOR UPDATE "
    #CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql  #FUN-920032  #FUN-B80070--mark--
    CALL cl_forupd_sql(g_forupd_sql) RETURNING g_forupd_sql       #FUN-B80070--add---
    CALL cl_parse_qry_sql(g_forupd_sql,g_plant) RETURNING g_forupd_sql  #FUN-A50102 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE ima_lock CURSOR FROM g_forupd_sql
 
    OPEN ima_lock USING p_imn.imn03
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1)
       LET g_success='N' RETURN  1
    END IF
 
    FETCH ima_lock INTO g_ima25  #,g_ima86 #FUN-560183
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1)
       LET g_success='N' RETURN  1
    END IF
 
#-->料件庫存單位數量
    LET l_qty=p_imn.imn10 * l_img.img21
	IF cl_null(l_qty)  THEN RETURN 1 END IF
 
    IF s_udima1(p_imn.imn03,             #料件編號
			    l_img.img23,             #是否可用倉儲
			    l_img.img24,             #是否為MRP可用倉儲
			    l_qty,                   #調撥數量(換算為料件庫存單位)
			    g_today,                 #最近一次撥出日期
			    -1,                     #表撥出
                g_s.imn041)                  #資料庫編號 #FUN-980093 add
    	THEN RETURN 1
	END IF
    IF g_success = 'N' THEN RETURN 1 END IF
 
#-->產生異動記錄檔
    CALL t720_log_2('1',1,0,'',p_imn.*,g_plant,g_azp01,g_s.imn041) #FUN-980093 add
 
#-->將已鎖住之資料釋放出來
    CLOSE img_lock
 
    RETURN 0
 
END FUNCTION
 
FUNCTION t720_t2(p_imn)
DEFINE
    p_imn  RECORD LIKE imn_file.*,
    l_img   RECORD
            img16      LIKE img_file.img16,
            img23      LIKE img_file.img23,
            img24      LIKE img_file.img24,
            img09      LIKE img_file.img09,
            img21      LIKE img_file.img21,
            img19      LIKE img_file.img19,
            img27      LIKE img_file.img27,
            img28      LIKE img_file.img28,
            img35      LIKE img_file.img35,
            img36      LIKE img_file.img36
            END RECORD,
	l_sql LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(300)
        l_qty LIKE img_file.img10
 
 
    LET g_forupd_sql="SELECT img16,img23,img24,img09,img21,", 
                     "       img19,img27,img28,img35,img36,img26,img10",
                    #"  FROM ",g_azp03_tra CLIPPED,"img_file", #FUN-980093 add   #FUN-A50102
                     "  FROM ",cl_get_target_table(g_s.imn151,'img_file'),       #FUN-A50102
                     "  WHERE img01= ? AND img02= ? AND img03= ? AND img04= ? ",
                     "   FOR UPDATE"
    #CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql   #FUN-A50102   #FUN-B80070--mark--
    CALL cl_forupd_sql(g_forupd_sql) RETURNING g_forupd_sql       #FUN-B80070--add---
    CALL cl_parse_qry_sql(g_forupd_sql,g_s.imn151) RETURNING g_forupd_sql #FUN-980093
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img2_lock CURSOR FROM g_forupd_sql
 
 
    OPEN img2_lock USING p_imn.imn03,p_imn.imn15,
                         p_imn.imn16,p_imn.imn17
    IF SQLCA.sqlcode THEN
       CALL cl_err('lock img fail',STATUS,1)
       LET g_success = 'N' RETURN 1
    END IF
 
    FETCH img2_lock INTO l_img.*,g_credit,g_img10_2
    IF SQLCA.sqlcode THEN
       CALL cl_err('lock img2 fail',STATUS,1)
       LET g_success = 'N' RETURN 1
    END IF
 
#-->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
    MESSAGE "update ima2_file ..."
 
   #LET g_forupd_sql="SELECT ima25 FROM ",s_dbstring(g_azp03 CLIPPED),"ima_file",#TQC-940178 ADD  #FUN-A50102
    LET g_forupd_sql="SELECT ima25 FROM ",cl_get_target_table(g_s.imn151,'ima_file'),   #FUN-A50102
                     " WHERE ima01= ?  FOR UPDATE"
    #CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql   #FUN-A50102   #FUN-B80070--mark--
    CALL cl_forupd_sql(g_forupd_sql) RETURNING g_forupd_sql       #FUN-B80070--add---
    CALL cl_parse_qry_sql(g_forupd_sql,g_s.imn151) RETURNING g_forupd_sql  #FUN-A50102 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE ima2_lock CURSOR FROM g_forupd_sql
 
    OPEN ima2_lock USING p_imn.imn03
    IF SQLCA.sqlcode THEN
       CALL cl_err('lock ima fail',STATUS,1)
        LET g_success='N' RETURN  1
    END IF
 
    FETCH ima2_lock INTO g_ima25_2  #,g_ima86_2 #FUN-560183
    IF SQLCA.sqlcode THEN
       CALL cl_err('lock ima fail',STATUS,1)
        LET g_success='N' RETURN  1
    END IF
 
 
    LET g_azp03_o = t720_catstr(g_azp03)
    CALL s_upimg1(p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,+1,p_imn.imn22,g_imm.imm02,  #FUN-8C0084
#       5           6           7           8
        p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,
#       9           10          11          12          13
        p_imn.imn01,p_imn.imn02,l_img.img09,p_imn.imn22,l_img.img09,
#       14  15          16
        1,  l_img.img21,1,
#       17          18          19          20          21
        g_credit,l_img.img35,l_img.img27,l_img.img28,l_img.img19,
#       22          23
        l_img.img36,g_s.imn151) #FUN-980093 add
    IF g_success = 'N' THEN RETURN 1 END IF
 
#-->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
    LET l_qty = p_imn.imn22 * l_img.img21
    IF s_udima1(p_imn.imn03,            #料件編號
			    l_img.img23,            #是否可用倉儲
			    l_img.img24,            #是否為MRP可用倉儲
			    l_qty,                  #發料數量(換算為料件庫存單位)
			    g_today,                #最近一次收料日期
			    +1,                    #表收料
			    g_s.imn151)               #資料庫編號 #FUN-980093 add
         THEN RETURN  1
    END IF
    IF g_success = 'N' THEN RETURN 1 END IF
 
#-->產生異動記錄檔
    CALL t720_log_2('2',1,0,'',p_imn.*,g_azp01,g_plant,g_s.imn151) #FUN-980093 add
    RETURN 0
END FUNCTION
 
FUNCTION t720_t3(p_imn)
DEFINE
    p_imn   RECORD LIKE imn_file.*,
    l_sql   LIKE type_file.chr1000,            #No.FUN-690026 VARCHAR(300)
    l_img   RECORD
            img16      LIKE img_file.img16,
            img23      LIKE img_file.img23,
            img24      LIKE img_file.img24,
            img09      LIKE img_file.img09,
            img21      LIKE img_file.img21
            END RECORD,
    l_qty   LIKE img_file.img10,
    l_n     LIKE type_file.num5                #No.FUN-690026 SMALLINT
 
    MESSAGE "update img_file ..."
    LET l_n = 0
    IF cl_null(p_imn.imn04) THEN LET p_imn.imn04=' ' END IF
    IF cl_null(p_imn.imn05) THEN LET p_imn.imn05=' ' END IF
    IF cl_null(p_imn.imn06) THEN LET p_imn.imn06=' ' END IF
 
    LET g_forupd_sql="SELECT img16,img23,img24,img09,img21,img26,img10",
                    #"  FROM ",g_db_tra CLIPPED,"img_file ", #FUN-980093 add   #FUN-A50102
                     "  FROM ",cl_get_target_table(g_s.imn041,'img_file'),     #FUN-A50102
                     "  WHERE img01= ? AND img02= ? AND img03= ? AND img04= ? ",
                     "   FOR UPDATE "
    #	 CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql   #FUN-920032   #FUN-B80070--mark--
    CALL cl_forupd_sql(g_forupd_sql) RETURNING g_forupd_sql       #FUN-B80070--add---
    CALL cl_parse_qry_sql(g_forupd_sql,g_s.imn041) RETURNING g_forupd_sql #FUN-980093
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img_lock3 CURSOR FROM g_forupd_sql
 
    OPEN img_lock3 USING p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06
    IF SQLCA.sqlcode THEN
       CALL cl_err('lock img fail',STATUS,1)   #NO.TQC-930155 
       LET g_success = 'N'
       RETURN 1
    END IF
    FETCH img_lock3 INTO l_img.*,g_debit,g_img10
    IF SQLCA.sqlcode THEN
       CALL cl_err('lock img fail',STATUS,1)   #NO.TQC-930155
       LET g_success = 'N'
       RETURN 1
    END IF
 
    IF l_n = 0 THEN
       LET g_azp03_o = t720_catstr(g_dbs)
       LET l_n = l_n + 1
    ELSE
       LET g_azp03_o = g_dbs
    END IF
#-->更新倉庫庫存明細資料
#                 1           2  3           4
    CALL s_upimg1(p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,'+1',p_imn.imn10,l_img.img16, #FUN-8C0084
#       5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22  23
       #p_imn.imn03,p_imn.imn04,p_imn.imn05,p_imn.imn06,'','','','','','','','','','','','','','',g_azp03_o) #FUN-980093 mark
        '','','','','','','','','','','','','','','','','','',g_s.imn041) #FUN-980093 add
    IF g_success = 'N' THEN RETURN 1 END IF
 
#-->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
    MESSAGE "update ima_file ..."
   #LET g_forupd_sql="SELECT ima25 FROM ",s_dbstring(g_dbs CLIPPED),"ima_file",#TQC-940178 add  #FUN-A50102
    LET g_forupd_sql="SELECT ima25 FROM ",cl_get_target_table(g_plant,'ima_file'),  #FUN-A50102
                     " WHERE ima01= ? FOR UPDATE "
    #	 CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql   #FUN-920032  #FUN-B80070--mark--
    CALL cl_forupd_sql(g_forupd_sql) RETURNING g_forupd_sql       #FUN-B80070--add---
    CALL cl_parse_qry_sql(g_forupd_sql,g_plant) RETURNING g_forupd_sql     #FUN-A50102
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE ima_lock3 CURSOR FROM g_forupd_sql
 
    OPEN ima_lock3 USING p_imn.imn03
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1)
       LET g_success='N' RETURN  1
    END IF
 
    FETCH ima_lock3 INTO g_ima25  #,g_ima86 #FUN-560183
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1)
       LET g_success='N' RETURN  1
    END IF
 
#-->料件庫存單位數量
    LET l_qty=p_imn.imn10 * l_img.img21
	IF cl_null(l_qty)  THEN RETURN 1 END IF
 
    IF s_udima1(p_imn.imn03,             #料件編號
			    l_img.img23,             #是否可用倉儲
			    l_img.img24,             #是否為MRP可用倉儲
			    l_qty,                   #調撥數量(換算為料件庫存單位)
			    g_today,                 #最近一次撥出日期
			    +1,                     #表撥出
                g_s.imn041) #FUN-980093 add
    	THEN RETURN 1
	END IF
    IF g_success = 'N' THEN RETURN 1 END IF
#-->將已鎖住之資料釋放出來
    CLOSE img_lock3
 
    RETURN 0
 
END FUNCTION
 
FUNCTION t720_t4(p_imn)
DEFINE
    p_imn  RECORD LIKE imn_file.*,
    l_img   RECORD
            img16      LIKE img_file.img16,
            img23      LIKE img_file.img23,
            img24      LIKE img_file.img24,
            img09      LIKE img_file.img09,
            img21      LIKE img_file.img21,
            img19      LIKE img_file.img19,
            img27      LIKE img_file.img27,
            img28      LIKE img_file.img28,
            img35      LIKE img_file.img35,
            img36      LIKE img_file.img36
            END RECORD,
	l_sql LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(300)
        l_qty LIKE img_file.img10
 
    LET g_forupd_sql="SELECT img16,img23,img24,img09,img21,",
                     "       img19,img27,img28,img35,img36,img26,img10",
                    #"  FROM ",g_azp03_tra CLIPPED,"img_file", #FUN-980093 add  #FUN-A50102
                     "  FROM ",cl_get_target_table(g_s.imn151,'img_file'),     #FUN-A50102
                     "  WHERE img01= ? AND img02= ? AND img03= ? AND img04= ? ",
                     "   FOR UPDATE"
    #CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql   #FUN-A50102  #FUN-B80070--mark--
    CALL cl_forupd_sql(g_forupd_sql) RETURNING g_forupd_sql       #FUN-B80070--add---
    CALL cl_parse_qry_sql(g_forupd_sql,g_s.imn151) RETURNING g_forupd_sql #FUN-980093
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img2_lock4 CURSOR FROM g_forupd_sql
 
    OPEN img2_lock4 USING p_imn.imn03,p_imn.imn15,
                         p_imn.imn16,p_imn.imn17
    IF SQLCA.sqlcode THEN
       CALL cl_err('lock img fail',STATUS,1)
       LET g_success = 'N' RETURN 1
    END IF
 
    FETCH img2_lock4 INTO l_img.*,g_credit,g_img10_2
    IF SQLCA.sqlcode THEN
       CALL cl_err('lock img2 fail',STATUS,1)
       LET g_success = 'N' RETURN 1
    END IF
 
#-->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
    MESSAGE "update ima2_file ..."
   #LET g_forupd_sql="SELECT ima25 FROM ",s_dbstring(g_azp03 CLIPPED),"ima_file", #TQC-940178 ADD  #FUN-A50102
    LET g_forupd_sql="SELECT ima25 FROM ",cl_get_target_table(g_s.imn151,'ima_file'),   #FUN-A50102
                     " WHERE ima01= ?  FOR UPDATE"
    #CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql   #FUN-A50102  #FUN-B80070--mark--
    CALL cl_forupd_sql(g_forupd_sql) RETURNING g_forupd_sql       #FUN-B80070--add---
    CALL cl_parse_qry_sql(g_forupd_sql,g_s.imn151) RETURNING g_forupd_sql   #FUN-A50102
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE ima2_lock4 CURSOR FROM g_forupd_sql
 
    OPEN ima2_lock4 USING p_imn.imn03
    IF SQLCA.sqlcode THEN
       CALL cl_err('lock ima fail',STATUS,1)
        LET g_success='N' RETURN  1
    END IF
 
    FETCH ima2_lock4 INTO g_ima25_2  #,g_ima86_2 #FUN-560183
    IF SQLCA.sqlcode THEN
       CALL cl_err('lock ima fail',STATUS,1)
        LET g_success='N' RETURN  1
    END IF
 
    LET g_azp03_o = t720_catstr(g_azp03)
    CALL s_upimg1(p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,-1,p_imn.imn22,g_imm.imm02,  #FUN-8C0084
#       5           6           7           8
        p_imn.imn03,p_imn.imn15,p_imn.imn16,p_imn.imn17,
#       9           10          11          12          13
        p_imn.imn01,p_imn.imn02,l_img.img09,p_imn.imn22,l_img.img09,
#       14  15          16
        1,  l_img.img21,1,
#       17          18          19          20          21
        g_credit,l_img.img35,l_img.img27,l_img.img28,l_img.img19,
#       22          23
        l_img.img36,g_s.imn151) #FUN-980093 add
    IF g_success = 'N' THEN RETURN 1 END IF
 
#-->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
    LET l_qty = p_imn.imn22 * l_img.img21
    IF s_udima1(p_imn.imn03,            #料件編號
			    l_img.img23,            #是否可用倉儲
			    l_img.img24,            #是否為MRP可用倉儲
			    l_qty,                  #發料數量(換算為料件庫存單位)
			    g_today,                #最近一次收料日期
			    -1,                    #表收料
			   #g_azp03_o)                #資料庫編號 #FUN-980093 mark
			    g_s.imn151) #FUN-980093 add
         THEN RETURN  1
    END IF
    IF g_success = 'N' THEN RETURN 1 END IF
    RETURN 0
END FUNCTION
 
#處理異動記錄
FUNCTION t720_log_2(p_chr,p_stdc,p_reason,p_code,p_imn,p_plant1,p_plant2,p_plant) #FUN-980093 add
DEFINE
    p_chr           LIKE type_file.chr1,       #撥出/撥入  #No.FUN-690026 VARCHAR(1)
    p_stdc          LIKE type_file.num5,       #是否需取得標準成本  #No.FUN-690026 SMALLINT
    p_reason        LIKE type_file.num5,       #是否需取得異動原因  #No.FUN-690026 SMALLINT
    p_code          LIKE type_file.chr4,       #No.FUN-690026 VARCHAR(04)
    p_plant1        LIKE azp_file.azp01,       #來源工廠
    p_plant2        LIKE azp_file.azp01,       #目的工廠
    p_plant         LIKE azp_file.azp01,       #FUN-980093
    p_dbs           LIKE azp_file.azp03,
    p_imn           RECORD LIKE imn_file.*
 
 IF p_chr = '1' THEN  #撥出
    #----來源----
    LET g_tlf.tlf01=p_imn.imn03 	        #異動料件編號
    LET g_tlf.tlf02=50         	 	        #來源為倉庫(撥出)
    LET g_tlf.tlf020=p_imn.imn041               #工廠別
    LET g_tlf.tlf021=p_imn.imn04   	        #倉庫別
    LET g_tlf.tlf022=p_imn.imn05	        #儲位別
    LET g_tlf.tlf023=p_imn.imn06         	#批號
    LET g_tlf.tlf024=g_img10 - p_imn.imn10      #異動後庫存數量
    LET g_tlf.tlf025=p_imn.imn09                #庫存單位(ima_file or img_file)
    LET g_tlf.tlf026=p_imn.imn01                #調撥單號
    LET g_tlf.tlf027=p_imn.imn02                #項次
 
    #----目的----
    LET g_tlf.tlf03=57         	                #資料目的為(撥入)
    LET g_tlf.tlf030=p_imn.imn151
    LET g_tlf.tlf031=''                         #倉庫別
    LET g_tlf.tlf032=''                         #儲位別
    LET g_tlf.tlf033=''           	        #批號
    LET g_tlf.tlf034=''                         #異動後庫存量
    LET g_tlf.tlf035=''                      	#庫存單位(ima_file or img_file)
    LET g_tlf.tlf036=p_imn.imn01                #參考號碼
    LET g_tlf.tlf037=p_imn.imn02                #項次
    LET g_tlf.tlf13='aimt720'                   #異動命令代號
    LET g_tlf.tlf12=1                           #撥出/撥入庫存轉換率
    LET g_tlf.tlf930=p_imn.imn9301  #FUN-670093
 ELSE    #撥入
    #----來源----
    LET g_tlf.tlf01=p_imn.imn03 	        #異動料件編號
    LET g_tlf.tlf02=57         	 	        #來源為倉庫(撥出)
    LET g_tlf.tlf020=p_imn.imn041               #工廠別
    LET g_tlf.tlf021=''            	        #倉庫別
    LET g_tlf.tlf022=''                         #儲位別
    LET g_tlf.tlf023=''                         #批號
    LET g_tlf.tlf024=''                         #異動後庫存數量
    LET g_tlf.tlf025=''                         #庫存單位(ima_file or img_file)
    LET g_tlf.tlf026=p_imn.imn01                #調撥單號
    LET g_tlf.tlf027=p_imn.imn02                #項次
 
    #----目的----
    LET g_tlf.tlf03=50         	                #資料目的為(撥入)
    LET g_tlf.tlf030=p_imn.imn151     
    LET g_tlf.tlf031=p_imn.imn15                #倉庫別
    LET g_tlf.tlf032=p_imn.imn16                #儲位別
    LET g_tlf.tlf033=p_imn.imn17  	        #批號
    LET g_tlf.tlf034=g_img10_2 + p_imn.imn22    #異動後庫存量
    LET g_tlf.tlf035=p_imn.imn20             	#庫存單位(ima_file or img_file)
    LET g_tlf.tlf036=p_imn.imn01                #參考號碼
    LET g_tlf.tlf037=p_imn.imn02                #項次
    LET g_tlf.tlf13='aimt720'                   #異動命令代號
    LET g_tlf.tlf12=p_imn.imn21                 #撥出/撥入庫存轉換率
    LET g_tlf.tlf930=p_imn.imn9302  #FUN-670093
 END IF
    #--->異動數量
    LET g_tlf.tlf04=' '                         #工作站
    LET g_tlf.tlf05=' '                         #作業序號
    LET g_tlf.tlf06=g_imm.imm02                 #發料日期
    LET g_tlf.tlf07=g_today                     #異動資料產生日期
    LET g_tlf.tlf08=TIME                        #異動資料產生時:分:秒
    LET g_tlf.tlf09=g_user                      #產生人
    LET g_tlf.tlf10=p_imn.imn10                 #調撥數量
    LET g_tlf.tlf11=p_imn.imn09                 #撥出單位
    LET g_tlf.tlf14=p_imn.imn28                 #異動原因
    LET g_tlf.tlf15=g_debit                     #借方會計科目
    LET g_tlf.tlf16=g_credit                    #貸方會計科目
    LET g_tlf.tlf17=g_imm.imm09                 #remark
    CALL s_imaQOH(p_imn.imn03)
         RETURNING g_tlf.tlf18                  #異動後總庫存量
    LET g_tlf.tlf19= ' '                        #異動廠商/客戶編號
    LET g_tlf.tlf20= ' '                        #project no.
    LET g_azp03_o = t720_catstr(p_dbs)
    CALL s_tlf2(p_stdc,p_reason,p_plant)        #No.FUN-980081 
END FUNCTION
 
## database + :
FUNCTION t720_catstr(p_dbs)
DEFINE p_dbs  LIKE azp_file.azp03
 
  FOR g_i=20 TO 1 STEP -1
      IF p_dbs[g_i,g_i]='.'
         THEN RETURN p_dbs
      END IF
  END FOR
  LET p_dbs=s_dbstring(p_dbs CLIPPED)
  RETURN p_dbs
END FUNCTION
 
#check 撥出:料/倉/儲/批
#(1)數量是否大於0
#(2)是否有效
#(3)重算撥出/入的換算率 及撥入數量
FUNCTION t720_chk_out()
  DEFINE l_img10 LIKE img_file.img10
 
  IF cl_null(g_imn[l_ac].imn05) THEN
     LET g_imn[l_ac].imn05 = ' '
  END IF
 
  IF cl_null(g_imn[l_ac].imn06) THEN
     LET g_imn[l_ac].imn06 = ' '
  END IF
 
  SELECT img09,img10
    INTO g_imn[l_ac].imn09,l_img10
    FROM img_file
   WHERE img01=g_imn[l_ac].imn03
     AND img02=g_imn[l_ac].imn04
     AND img03=g_imn[l_ac].imn05
     AND img04=g_imn[l_ac].imn06
  IF SQLCA.sqlcode THEN
      LET l_img10 = 0
      #在庫存明細資料查無該筆, 請重新輸入!!
      #FUN-C80107 modify begin---------------------------------------121101
      #CALL cl_err3("sel","img_file",g_imn[l_ac].imn03,g_imn[l_ac].imn06,
      #             "mfg6101","","",1)   #No.FUN-660156
      #RETURN 1
      LET g_flag1 = NULL
      #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_flag1  #FUN-D30024--mark
      CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_s.imn041) RETURNING g_flag1  #FUN-D30024--add #TQC-D40078 g_s.imn041
      IF g_flag1 = 'N' OR g_flag1 IS NULL THEN
         CALL cl_err3("sel","img_file",g_imn[l_ac].imn03,g_imn[l_ac].imn06,
                      "mfg6101","","",1)
         RETURN 1
      ELSE
         IF g_sma.sma892[3,3] = 'Y' THEN
            IF NOT cl_confirm('mfg1401') THEN RETURN 1 END IF
         END IF
         CALL s_add_img(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                        g_imn[l_ac].imn05,g_imn[l_ac].imn06,
                        g_imm.imm01      ,g_imn[l_ac].imn02,
                        g_imm.imm02)
         IF g_errno='N' THEN
            RETURN 1
         END IF
      END IF
      #FUN-C80107 modify end-----------------------------------------
  END IF
  IF l_img10 <=0 THEN
      #庫存不足是否許調撥出庫='N'
     #IF g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN  #FUN-C80107
      LET g_flag1 = NULL    #FUN-C80107 add
      #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_flag1   #FUN-C80107 add #FUN-D30024--mark
      CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_s.imn041) RETURNING g_flag1   #FUN-D30024--add  #TQC-D40078 g_s.imn041
      IF g_flag1 = 'N' OR g_flag1 IS NULL THEN           #FUN-C80107 add
          #目前已無庫存量無法執行調撥動作
          CALL cl_err(l_img10,'mfg3471',1)
          RETURN 1
      END IF
  END IF
  #-->有效日期
  IF NOT s_actimg(g_imn[l_ac].imn03,g_imn[l_ac].imn04,
                  g_imn[l_ac].imn05,g_imn[l_ac].imn06) THEN
      CALL cl_err('inactive','mfg6117',1)
      RETURN 1
  END IF
  CALL s_umfchk(g_imn[l_ac].imn03,g_imn[l_ac].imn09,g_imn[l_ac].imn20)
           RETURNING g_cnt,g_imn[l_ac].imn21
  IF g_cnt = 1 THEN
      CALL cl_err('','mfg3075',1)
      RETURN 1
  END IF
#FUN-BB0084 -------------------Begin------------------
  IF NOT cl_null(g_imn[l_ac].imn09) AND NOT cl_null(g_imn[l_ac].imn10) THEN
     LET g_imn[l_ac].imn10 = s_digqty(g_imn[l_ac].imn10,g_imn[l_ac].imn09)
     DISPLAY BY NAME g_imn[l_ac].imn09
     DISPLAY BY NAME g_imn[l_ac].imn10 
  END IF
#FUN-BB0084 -------------------End--------------------
  LET g_imn[l_ac].imn22=g_imn[l_ac].imn10*g_imn[l_ac].imn21
  LET g_imn[l_ac].imn22=s_digqty(g_imn[l_ac].imn22,g_imn[l_ac].imn20)     #FUN-BB0084
  DISPLAY BY NAME g_imn[l_ac].imn22                                       #FUN-BB0084
  IF g_imn[l_ac].imn09 <> g_imn_t.imn09 THEN
      #撥出:倉/儲/批的單位已變了,請注意撥出數量是否正確
      CALL cl_err('','aim-324',0)
  END IF
  RETURN 0
END FUNCTION
 
#用於default 雙單位/轉換率/數量
FUNCTION t720_du_default(p_cmd,p_item,p_ware,p_loc,p_lot)
 DEFINE    p_item   LIKE img_file.img01,     #料號
           p_ware   LIKE img_file.img02,     #倉庫
           p_loc    LIKE img_file.img03,     #儲
           p_lot    LIKE img_file.img04,     #批
           l_ima25  LIKE ima_file.ima25,     #ima單位
           l_ima906 LIKE ima_file.ima906,
           l_ima907 LIKE ima_file.ima907,
           l_img09  LIKE img_file.img09,     #img單位
           l_unit2  LIKE img_file.img09,     #第二單位
           l_fac2   LIKE img_file.img21,     #第二轉換率
           l_qty2   LIKE img_file.img10,     #第二數量
           l_unit1  LIKE img_file.img09,     #第一單位
           l_fac1   LIKE img_file.img21,     #第一轉換率
           l_qty1   LIKE img_file.img10,     #第一數量
           p_cmd    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_factor LIKE ima_file.ima31_fac  #No.FUN-690026 DECIMAL(16,8)
 
   SELECT ima25,ima906,ima907 INTO l_ima25,l_ima906,l_ima907
     FROM ima_file WHERE ima01 = p_item
 
   SELECT img09 INTO l_img09 FROM img_file
    WHERE img01 = p_item
      AND img02 = p_ware
      AND img03 = p_loc
      AND img04 = p_lot
   IF cl_null(l_img09) THEN LET l_img09 = l_ima25 END IF
 
   IF l_ima906 = '1' THEN  #不使用雙單位
      LET l_unit2 = NULL
      LET l_fac2  = NULL
      LET l_qty2  = NULL
   ELSE
      LET l_unit2 = l_ima907
      CALL s_du_umfchk(p_item,'','','',l_img09,l_ima907,l_ima906)
           RETURNING g_errno,l_factor
      LET l_fac2 = l_factor
      LET l_qty2 = 0
   END IF
   LET l_unit1 = l_img09
   LET l_fac1  = 1
   LET l_qty1  = 0
 
   RETURN l_unit2,l_fac2,l_qty2,l_unit1,l_fac1,l_qty1
END FUNCTION
 
#對原來數量/換算率/單位的賦值
FUNCTION t720_set_origin_field()
 DEFINE    p_flag      LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_ima906    LIKE ima_file.ima906,
           l_ima907    LIKE ima_file.ima907,
           l_tot       LIKE img_file.img10,
           l_img09_s   LIKE img_file.img09,
           l_img09_t   LIKE img_file.img09,
           l_fac1      LIKE img_file.img21,
           l_fac2      LIKE img_file.img21,
           l_fac3      LIKE img_file.img21,
           l_fac4      LIKE img_file.img21,
           l_qty1      LIKE img_file.img10,
           l_qty2      LIKE img_file.img10,
           l_qty3      LIKE img_file.img10,
           l_qty4      LIKE img_file.img10,
           l_sql       STRING
 
  IF g_sma.sma115='N' THEN RETURN END IF
  LET l_qty1=g_imn[l_ac].imn35      #母參考單位
  LET l_qty2=g_imn[l_ac].imn32      #子/撥出數量
  LET l_qty3=g_imn[l_ac].imn45      #母/參考數量(目的)
  LET l_qty4=g_imn[l_ac].imn42      #子/撥入數量
  LET l_fac1=g_imn[l_ac].imn34      #母/參考單位換算率(來源)
  LET l_fac2=g_imn[l_ac].imn31      #子/撥出單位換算率(來源)
  LET l_fac3=g_imn[l_ac].imn44      #母/參考單位換算率(目的)
  LET l_fac4=g_imn[l_ac].imn41      #子/撥入單位換算率(目的)
 
  IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
  IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
  IF cl_null(l_qty3) THEN LET l_qty3=0 END IF
  IF cl_null(l_qty4) THEN LET l_qty4=0 END IF
  IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
  IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
  IF cl_null(l_fac3) THEN LET l_fac3=1 END IF
  IF cl_null(l_fac4) THEN LET l_fac4=1 END IF
 
   #source
  #LET l_sql = "SELECT img09 FROM ",g_db_tra CLIPPED,"img_file ", #FUN-980093 add  #FUN-A50102
   LET l_sql = "SELECT img09 FROM ",cl_get_target_table(g_s.imn041,'img_file'),    #FUN-A50102
               " WHERE img01='",g_imn[l_ac].imn03,"'",
               "   AND img02='",g_imn[l_ac].imn04,"'",
               "   AND img03='",g_imn[l_ac].imn05,"'",
               "   AND img04='",g_imn[l_ac].imn06,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,g_s.imn041) RETURNING l_sql #FUN-980093
   PREPARE img_c5 FROM l_sql
   DECLARE img_cur5 CURSOR FOR img_c5
   OPEN img_cur5
   FETCH img_cur5 INTO l_img09_s
   IF cl_null(l_img09_s) THEN
      CALL cl_err(g_imn[l_ac].imn04,'mfg6069',0)
   END IF
 
   #destination
  #LET l_sql = "SELECT img09 FROM ",g_azp03_tra CLIPPED,"img_file ", #FUN-980093 add  #FUN-A50102
   LET l_sql = "SELECT img09 FROM ",cl_get_target_table(g_s.imn151,'img_file'),       #FUN-A50102
               " WHERE img01='",g_imn[l_ac].imn03,"'",
               "   AND img02='",g_imn[l_ac].imn15,"'",
               "   AND img03='",g_imn[l_ac].imn16,"'",
               "   AND img04='",g_imn[l_ac].imn17,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_s.imn151) RETURNING l_sql  #FUN-980093
   PREPARE img_c6 FROM l_sql
   DECLARE img_cur6 CURSOR FOR img_c6
   OPEN img_cur6
   FETCH img_cur6 INTO l_img09_t
   IF cl_null(l_img09_t) THEN
      CALL cl_err(g_imn[l_ac].imn15,'mfg6069',0)
   END IF
 
   IF g_sma.sma115 = 'Y' THEN
      CASE g_ima906
         WHEN '1' LET g_imn[l_ac].imn09=l_img09_s
                  LET g_imn[l_ac].imn10=l_qty2*l_fac2
                  LET g_imn[l_ac].imn20=l_img09_t
                  LET g_imn[l_ac].imn22=l_qty4*l_fac4
         WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
                  LET g_imn[l_ac].imn09=l_img09_s
                  LET g_imn[l_ac].imn10=l_tot
                  LET l_tot=l_qty3*l_fac3+l_qty4*l_fac4
                  LET g_imn[l_ac].imn20=l_img09_t
                  LET g_imn[l_ac].imn22=l_tot
         WHEN '3' LET g_imn[l_ac].imn09=l_img09_s
                  LET g_imn[l_ac].imn10=l_qty2*l_fac2
                  LET g_imn[l_ac].imn20=l_img09_t
                  LET g_imn[l_ac].imn22=l_qty4*l_fac4
                  IF l_qty1 <> 0 THEN
                     LET g_imn[l_ac].imn34=l_qty2/l_qty1
                  ELSE
                     LET g_imn[l_ac].imn34=0
                  END IF
                  IF l_qty3 <> 0 THEN
                     LET g_imn[l_ac].imn44=l_qty4/l_qty3
                  ELSE
                     LET g_imn[l_ac].imn44=0
                  END IF
      END CASE
      LET g_imn[l_ac].imn10=s_digqty(g_imn[l_ac].imn10,g_imn[l_ac].imn09)   #FUN-BB0084
      LET g_imn[l_ac].imn22=s_digqty(g_imn[l_ac].imn22,g_imn[l_ac].imn20)   #FUN-BB0084
   END IF
 
   IF g_imn[l_ac].imn09 <> g_imn[l_ac].imn20 THEN
      CALL s_umfchk(g_imn[l_ac].imn03,g_imn[l_ac].imn09,g_imn[l_ac].imn20)
           RETURNING g_cnt,g_imn[l_ac].imn21
   ELSE
      LET g_imn[l_ac].imn21 = 1
   END IF
 
END FUNCTION
 
#以img09單位來計算雙單位所確定的數量
FUNCTION t720_tot_by_img09(p_item,p_fac2,p_qty2,p_fac1,p_qty1)
 DEFINE p_item    LIKE ima_file.ima01
 DEFINE p_fac2    LIKE img_file.img21
 DEFINE p_qty2    LIKE img_file.img10
 DEFINE p_fac1    LIKE img_file.img21
 DEFINE p_qty1    LIKE img_file.img10
 DEFINE l_ima906  LIKE ima_file.ima906
 DEFINE l_ima907  LIKE ima_file.ima907
 DEFINE l_tot     LIKE img_file.img10
 
   SELECT ima906,ima907 INTO l_ima906,l_ima907
     FROM ima_file WHERE ima01 = p_item
 
   IF cl_null(p_fac2) THEN LET p_fac2 = 1 END IF
   IF cl_null(p_qty2) THEN LET p_qty2 = 0 END IF
   IF cl_null(p_fac1) THEN LET p_fac1 = 1 END IF
   IF cl_null(p_qty1) THEN LET p_qty1 = 0 END IF
   IF g_sma.sma115 = 'Y' THEN
      CASE l_ima906
         WHEN '1' LET l_tot=p_qty1*p_fac1
         WHEN '2' LET l_tot=p_qty1*p_fac1+p_qty2*p_fac2
         WHEN '3' LET l_tot=p_qty1*p_fac1
      END CASE
   ELSE  #不使用雙單位
      LET l_tot=p_qty1*p_fac1
   END IF
   IF cl_null(l_tot) THEN LET l_tot = 0 END IF
   RETURN l_tot
 
END FUNCTION
 
#計算庫存總量是否滿足所輸入數量
FUNCTION t720_check_inventory_qty()
 DEFINE l_img10    LIKE img_file.img10
 DEFINE l_tot      LIKE img_file.img10
 DEFINE l_flag     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   LET l_flag = '1'
   SELECT img10 INTO l_img10 FROM img_file
    WHERE img01 = g_imn[l_ac].imn03
      AND img02 = g_imn[l_ac].imn04
      AND img03 = g_imn[l_ac].imn05
      AND img04 = g_imn[l_ac].imn06
 
   CALL t720_tot_by_img09(g_imn[l_ac].imn03,g_imn[l_ac].imn34,g_imn[l_ac].imn35,
                          g_imn[l_ac].imn31,g_imn[l_ac].imn32)
        RETURNING l_tot
   IF l_img10 < l_tot THEN
      LET l_flag = '0'
   END IF
   RETURN l_flag
END FUNCTION
 
#檢查發料/報廢動作是否可以進行下去
FUNCTION t720_qty_issue()
 
   CALL t720_check_inventory_qty()  RETURNING g_flag
   IF g_flag = '0' THEN
     #IF g_sma.sma894[4,4]='N' OR g_sma.sma894[4,4] IS NULL THEN  #FUN-C80107 mark
      LET g_flag1 = NULL    #FUN-C80107 add
      #CALL s_inv_shrt_by_warehouse(g_sma.sma894[4,4],g_imn[l_ac].imn04) RETURNING g_flag1   #FUN-C80107 add #FUN-D30024--mark
      CALL s_inv_shrt_by_warehouse(g_imn[l_ac].imn04,g_s.imn041) RETURNING g_flag1  #FUN-D30024--add  #TQC-D40078 g_s.imn041
      IF g_flag1 = 'N' OR g_flag1 IS NULL THEN           #FUN-C80107 add
         CALL cl_err(g_imn[l_ac].imn03,'mfg1303',1)
         RETURN 1
      ELSE
         IF NOT cl_confirm('mfg3469') THEN
            RETURN 1
         END IF
     END IF
   END IF
 
   RETURN 0
 
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t720_du_data_to_correct()
 
  IF cl_null(g_imn[l_ac].imn33) THEN
     LET g_imn[l_ac].imn34 = NULL
     LET g_imn[l_ac].imn35 = NULL
  END IF
 
  IF cl_null(g_imn[l_ac].imn30) THEN
     LET g_imn[l_ac].imn31 = NULL
     LET g_imn[l_ac].imn32 = NULL
  END IF
 
  IF cl_null(g_imn[l_ac].imn43) THEN
     LET g_imn[l_ac].imn44 = NULL
     LET g_imn[l_ac].imn45 = NULL
  END IF
 
  IF cl_null(g_imn[l_ac].imn40) THEN
     LET g_imn[l_ac].imn41 = NULL
     LET g_imn[l_ac].imn42 = NULL
  END IF
 
  DISPLAY BY NAME g_imn[l_ac].imn33
  DISPLAY BY NAME g_imn[l_ac].imn34
  DISPLAY BY NAME g_imn[l_ac].imn35
  DISPLAY BY NAME g_imn[l_ac].imn30
  DISPLAY BY NAME g_imn[l_ac].imn31
  DISPLAY BY NAME g_imn[l_ac].imn32
  DISPLAY BY NAME g_imn[l_ac].imn43
  DISPLAY BY NAME g_imn[l_ac].imn44
  DISPLAY BY NAME g_imn[l_ac].imn45
  DISPLAY BY NAME g_imn[l_ac].imn40
  DISPLAY BY NAME g_imn[l_ac].imn41
  DISPLAY BY NAME g_imn[l_ac].imn42
END FUNCTION
 
FUNCTION t720_def_form()
    CALL cl_set_comp_required("imn28",g_aza.aza115='Y')        #FUN-CB0087---add---
    CALL cl_set_comp_visible("imn31,imn34,imn41,imn44",FALSE)
    IF g_sma.sma115 ='N' THEN
       CALL cl_set_comp_visible("imn33,imn34,imn35,imn43,imn44,imn45,imn52",FALSE)
       CALL cl_set_comp_visible("imn30,imn31,imn32,imn40,imn41,imn42,imn51",FALSE)
    ELSE
       CALL cl_set_comp_visible("imn09,imn10,imn20,imn21,imn22",FALSE)
    END IF
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-331',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn33",g_msg CLIPPED)
       CALL cl_getmsg('asm-332',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn35",g_msg CLIPPED)
       CALL cl_getmsg('asm-333',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn30",g_msg CLIPPED)
       CALL cl_getmsg('asm-334',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn32",g_msg CLIPPED)
       CALL cl_getmsg('asm-335',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn43",g_msg CLIPPED)
       CALL cl_getmsg('asm-336',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn45",g_msg CLIPPED)
       CALL cl_getmsg('asm-337',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn40",g_msg CLIPPED)
       CALL cl_getmsg('asm-338',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn42",g_msg CLIPPED)
       CALL cl_getmsg('asm-347',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn52",g_msg CLIPPED)
       CALL cl_getmsg('asm-348',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn51",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-339',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn33",g_msg CLIPPED)
       CALL cl_getmsg('asm-340',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn35",g_msg CLIPPED)
       CALL cl_getmsg('asm-341',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn30",g_msg CLIPPED)
       CALL cl_getmsg('asm-342',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn32",g_msg CLIPPED)
       CALL cl_getmsg('asm-343',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn43",g_msg CLIPPED)
       CALL cl_getmsg('asm-344',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn45",g_msg CLIPPED)
       CALL cl_getmsg('asm-345',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn40",g_msg CLIPPED)
       CALL cl_getmsg('asm-346',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn42",g_msg CLIPPED)
       CALL cl_getmsg('asm-349',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn52",g_msg CLIPPED)
       CALL cl_getmsg('asm-350',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imn51",g_msg CLIPPED)
    END IF
    IF g_aaz.aaz90='Y' THEN
       CALL cl_set_comp_required("imm14",TRUE)
    END IF
 
    CALL cl_set_comp_visible("imn9301,gem02b,imn9302,gem02c",g_aaz.aaz90='Y')  #FUN-670093
 
    IF g_aza.aza64 matches '[ Nn]' THEN
       CALL cl_set_comp_visible("immspc",FALSE)
       CALL cl_set_act_visible("trans_spc",FALSE)
    END IF 
 
END FUNCTION
 
FUNCTION t720_refresh_detail()
  DEFINE l_compare          LIKE smy_file.smy62                                                                                     
  DEFINE li_col_count       LIKE type_file.num5                                                                                                    #No.FUN-690026 SMALLINT
  DEFINE li_i, li_j         LIKE type_file.num5                                                                                                    #No.FUN-690026 SMALLINT
  DEFINE lc_agb03           LIKE agb_file.agb03                                                                                     
  DEFINE lr_agd             RECORD LIKE agd_file.*                                                                                  
  DEFINE lc_index           STRING                                                                                                  
  DEFINE ls_combo_vals      STRING                                                                                                  
  DEFINE ls_combo_txts      STRING                                                                                                  
  DEFINE ls_sql             STRING                                                                                                  
  DEFINE ls_show,ls_hide    STRING                                                                                                  
  DEFINE l_gae04            LIKE gae_file.gae04
 
  #判斷是否進行料件多屬性新機制管理以及是否傳入了屬性群組 
  IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' ) AND (NOT cl_null(lg_smy62)) THEN                                                                           
     #首先判斷有無單身記錄，如果單身根本沒有東東，則按照默認的lg_smy62來決定                                                        
     #顯示什麼組別的信息，如果有單身，則進行下面的邏輯判斷                                                                          
     IF g_imn.getLength() = 0 THEN                                                                                                  
        LET lg_group = lg_smy62                                                                                                     
     ELSE                                
       #讀取當前單身所有的料件資料，如果它們都屬于多屬性子料件，并且擁有一致的                                                      
       #屬性群組，則以該屬性群組作為顯示單身明細屬性的依據，如果有不統一的狀況                                                      
       #則返回一個NULL，下面將不顯示任明細屬性列                                                                                    
       FOR li_i = 1 TO g_imn.getLength()
         #如果某一個料件沒有對應的母料件(已經在前面的b_fill中取出來放在imx00中了                                                    
         #則不進行下面判斷直接退出了                                                                                                
         IF  cl_null(g_imn[li_i].att00) THEN                                                                                        
            LET lg_group = ''                                                                                                       
            EXIT FOR                                                                                                                
         END IF                                                                                                                     
         SELECT imaag INTO l_compare FROM ima_file WHERE ima01 = g_imn[li_i].att00 
         #第一次是賦值                                                                                                              
         IF cl_null(lg_group) THEN                                                                                                  
            LET lg_group = l_compare                                                                                                
         #以后是比較                                                                                                                
         ELSE                                                                                                                       
           #如果在單身料件屬于不同的屬性組則直接退出（不顯示這些東東)                                                               
           IF l_compare <> lg_group THEN                                                                                            
              LET lg_group = ''                                                                                                     
              EXIT FOR                                                                                                              
           END IF                                                                                                                   
         END IF              
         IF lg_group <> lg_smy62 THEN                                                                                               
            LET lg_group = ''                                                                                                       
            EXIT FOR                                                                                                                
         END IF                                                                                                                 
       END FOR                                                                                                                      
     END IF                                                                                                                         
                                                                                                                                    
     #到這里時lg_group中存放的已經是應該顯示的組別了，該變量是一個全局變量                                                          
     #在單身INPUT或開窗時都會用到，因為refresh函數被執行的時機較早，所以能保証在需要的時候有值
 
     SELECT COUNT(*) INTO li_col_count FROM agb_file WHERE agb01 = lg_group                                                         
                                                                                                                                    
     #走到這個分支說明是采用新機制，那麼使用att00父料件編號代替imn03子料件編號來顯示   
     #得到當前語言別下imn03的欄位標題   
     SELECT gae04 INTO l_gae04 FROM gae_file  
       WHERE gae01 = g_prog AND gae02 = 'imn03' AND gae03 = g_lang  
     CALL cl_set_comp_att_text("att00",l_gae04)
 
     #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏 
     IF NOT cl_null(lg_group) THEN                                                                                                  
        LET ls_hide = 'imn03'
        LET ls_show = 'att00'                                                                                                       
     ELSE                                                                                                                           
        LET ls_hide = 'att00'                                                                                                       
        LET ls_show = 'imn03'
     END IF
 
     #顯現該有的欄位,置換欄位格式   
     CALL lr_agc.clear()  #因為這個過程可能會被執行多次，作為一個公共變量，每次執行之前必須要初始化    
     FOR li_i = 1 TO li_col_count                                                                                                   
         SELECT agb03 INTO lc_agb03 FROM agb_file                                                                                   
           WHERE agb01 = lg_group AND agb02 = li_i                                                                                  
                                                                                                                                    
         LET lc_agb03 = lc_agb03 CLIPPED                                                                                            
         SELECT * INTO lr_agc[li_i].* FROM agc_file                                                                                 
           WHERE agc01 = lc_agb03                                                                                                   
                                                                                                                                    
         LET lc_index = li_i USING '&&'                                                                                             
                                                                                                                                    
         CASE lr_agc[li_i].agc04                                                                                                    
           WHEN '1'                                                                                                                 
             LET ls_show = ls_show || ",att" || lc_index                                                                            
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"                                                                    
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)                                                        
                                                                                                                                    
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1") 
           WHEN '2'                                                                                                                 
             LET ls_show = ls_show || ",att" || lc_index || "_c"                                                                    
             LET ls_hide = ls_hide || ",att" || lc_index                                                                            
             CALL cl_set_comp_att_text("att" || lc_index || "_c",lr_agc[li_i].agc02)
             LET ls_sql = "SELECT * FROM agd_file WHERE agd01 = '",lr_agc[li_i].agc01,"'"                                                    
             DECLARE agd_curs CURSOR FROM ls_sql                                                                                    
             LET ls_combo_vals = ""                                                                                                 
             LET ls_combo_txts = ""                                                                                                 
             FOREACH agd_curs INTO lr_agd.*                                                                                         
                IF SQLCA.sqlcode THEN                                                                                               
                   EXIT FOREACH                                                                                                     
                END IF                  
                IF ls_combo_vals IS NULL THEN
                   LET ls_combo_vals = lr_agd.agd02 CLIPPED
                ELSE
                   LET ls_combo_vals = ls_combo_vals,",",lr_agd.agd02 CLIPPED
                END IF
                IF ls_combo_txts IS NULL THEN
                   LET ls_combo_txts = lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                ELSE
                   LET ls_combo_txts = ls_combo_txts,",",lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                END IF
             END FOREACH
             CALL cl_set_combo_items("formonly.att" || lc_index || "_c",ls_combo_vals,ls_combo_txts)
                CALL cl_chg_comp_att("formonly.att" || lc_index || "_c","NOT NULL|REQUIRED|SCROLL","1|1|1")
          WHEN '3'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
       END CASE                                                                                                                     
     END FOR                                                                                                                        
                                                                                                                                    
  ELSE                                                                                                                              
    #否則什麼也不做(不顯示任何屬性列)                                                                                               
    LET li_i = 1                                                                                                                    
    #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
    LET ls_hide = 'att00'                                                                                                           
    LET ls_show = 'imn03'
  END IF 
 
  #下面開始隱藏其他明細屬性欄位(從li_i開始)                                                                                         
  FOR li_j = li_i TO 10                                                                                                             
      LET lc_index = li_j USING '&&'                                                                                                
      #注意att0x和att0x_c都要隱藏，別忘了_c的                                                                                       
      LET ls_hide = ls_hide || ",att" || lc_index || ",att" || lc_index || "_c"                                                     
  END FOR                                                                       
  #這樣只用調兩次公共函數就可以解決問題了，效率應該會高一些                                                                         
  CALL cl_set_comp_visible(ls_show, TRUE)                                                                                           
  CALL cl_set_comp_visible(ls_hide, FALSE)                                                                                          
                                                                                                                                    
END FUNCTION                       
 
#--------------------在修改下面的代碼前請讀一下注釋先，謝了! ------------------- 
 
#本函數返回TRUE/FALSE,表示檢核過程是否通過，一般說來，在使用過程中應該是如下方式                                                    
#    AFTER FIELD XXX                                                                                                                
#        IF NOT t720_check_imn03(.....)  THEN NEXT FIELD XXX END IF     
FUNCTION t720_check_imn03(p_field,p_ac)
DEFINE                                                                                                                              
  p_field                     STRING,    #當前是在哪個欄位中觸發了AFTER FIELD事件  >
  p_ac                        LIKE type_file.num5,    #g_imn數組中的當前記錄下標                                                                   #No.FUN-690026 SMALLINT
  l_oeb06                     LIKE oeb_file.oeb06,    
  l_ps                        LIKE sma_file.sma46,    
  l_str_tok                   base.stringTokenizer,   
  l_tmp, ls_sql               STRING, 
  l_param_list                STRING, 
  l_cnt, li_i                 LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  ls_value                    STRING,               
  ls_pid,ls_value_fld         LIKE ima_file.ima01,  
  ls_name, ls_spec            STRING,               
  lc_agb03                    LIKE agb_file.agb03,  
  lc_agd03                    LIKE agd_file.agd03,  
  ls_pname                    LIKE ima_file.ima02,   
  l_misc                      LIKE type_file.chr4,    #VAR CHAR -> CHAR           #No.FUN-690026 VARCHAR(04),    
  l_n                         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  l_b2                        LIKE ima_file.ima31,    
  l_ima130                    LIKE ima_file.ima130,   
  l_ima131                    LIKE ima_file.ima131,   
  l_ima25                     LIKE ima_file.ima25,    
  l_imaacti                   LIKE ima_file.imaacti,    
  l_qty                       LIKE type_file.num10,   #No.FUN-690026 INTEGER
  l_sql                       LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(1000)
  p_cmd                       STRING,
  l_tmm                       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
  l_v                         LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
  DEFINE l_flag               LIKE type_file.chr1     #No.FUN-7B0018
 
  IF ( p_field = 'imx00' )OR( p_field = 'imx01' )OR( p_field = 'imx02' )OR                                                          
     ( p_field = 'imx03' )OR( p_field = 'imx04' )OR( p_field = 'imx05' )OR                                                          
     ( p_field = 'imx06' )OR( p_field = 'imx07' )OR( p_field = 'imx08' )OR                                                          
     ( p_field = 'imx09' )OR( p_field = 'imx10' ) THEN 
     LET ls_pid = g_imn[p_ac].att00   # ls_pid 父料件編號    
     LET ls_value = g_imn[p_ac].att00   # ls_value 子料件編號
     IF cl_null(ls_pid) THEN    
        CALL t720_set_no_entry_b() 
        CALL t720_set_required()  
        RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti 
     END IF  #注意這里沒有錯，所以返回TRUE                                                                                          
                                                                                                                                    
     #取出當前母料件包含的明細屬性的個數
     SELECT COUNT(*) INTO l_cnt FROM agb_file WHERE agb01 =                                                                         
        (SELECT imaag FROM ima_file WHERE ima01 = ls_pid)                                                                           
     IF l_cnt = 0 THEN 
        CALL t720_set_no_entry_b() 
        CALL t720_set_required()  
         RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                    
     END IF                                                                                                                         
                                                                                                                                    
     FOR li_i = 1 TO l_cnt                                                                                                          
         #如果有任何一個明細屬性應該輸而沒有輸的則退出 
         IF cl_null(arr_detail[p_ac].imx[li_i]) THEN  
            CALL t720_set_no_entry_b()     
            CALL t720_set_required()
            RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
         END IF                                                                                                                     
     END FOR                                                                                                                        
                                                                                                                                    
     #得到系統定義的標准分隔符sma46  
     SELECT sma46 INTO l_ps FROM sma_file                                                                                           
                                                                                                                                    
     #合成子料件的名稱                                                                                                              
     SELECT ima02 INTO ls_pname FROM ima_file   # ls_name 父料件名稱                                                                
       WHERE ima01 = ls_pid                                                                                                         
     LET ls_spec = ls_pname  # ls_spec 子料件名稱                                                                                   
     #方法□循環在agd_file中找有沒有對應記錄，如果有，就用該記錄的名稱來                                                            
     #替換初始名稱，如果找不到則就用原來的名稱                                                                                      
     FOR li_i = 1 TO l_cnt                                                                                                          
         LET lc_agd03 = ""                                                                                                          
         LET ls_value = ls_value.trim(), l_ps, arr_detail[p_ac].imx[li_i]                                                           
         SELECT agd03 INTO lc_agd03 FROM agd_file                                                                                   
          WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = arr_detail[p_ac].imx[li_i]
         IF cl_null(lc_agd03) THEN                                                                                                  
            LET ls_spec = ls_spec.trim(),l_ps,arr_detail[p_ac].imx[li_i]                                                            
         ELSE                                                                                                                       
            LET ls_spec = ls_spec.trim(),l_ps,lc_agd03                                                                              
         END IF                                                                                                                     
     END FOR                                 
     #解析ls_value生成要傳給cl_copy_bom的那個l_param_list                                                                           
     LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)                                                                     
     LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉                                                                  
                                                                                                                                    
     LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",                                                                     
                  "ima01 = '",ls_pid CLIPPED,"' AND agb01 = imaag ",                                                                
                  "ORDER BY agb02"                                                                                                  
     DECLARE param_curs CURSOR FROM ls_sql                                                                                          
     FOREACH param_curs INTO lc_agb03                                                                                               
       #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致                                                                 
       IF cl_null(l_param_list) THEN                                                                                                
          LET l_param_list = '#',lc_agb03,'#|',l_str_tok.nextToken()                                                                
       ELSE                                                                                                                         
          LET l_param_list = l_param_list,'|#',lc_agb03,'#|',l_str_tok.nextToken()                                                    
       END IF                                                                                                                       
     END FOREACH                               
 
     #出貨單不允許新增ima_file里面沒有的子料件，故在此檢查一下                                                                   
      LET g_value = ls_value
      SELECT count(*) INTO l_n FROM ima_file                                                                                      
       WHERE ima01 = g_value                                                                                                      
        IF l_n =0 THEN                                                                                                              
           CALL cl_err(ls_value,'atm-523',0)                                                                                        
           RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                                                                                  
        END IF      
                  
     #調用cl_copy_ima將新生成的子料件插入到數據庫中                                                                                 
     IF cl_copy_ima(ls_pid,ls_value,ls_spec,l_param_list) = TRUE THEN                                                               
        #如果向其中成功插入記錄則同步插入屬性記錄到imx_file中去                                                                     
        LET ls_value_fld = ls_value                                                                                                 
        INSERT INTO imx_file VALUES(ls_value_fld,ls_pid,arr_detail[p_ac].imx[1], 
          arr_detail[p_ac].imx[2],arr_detail[p_ac].imx[3],arr_detail[p_ac].imx[4],
          arr_detail[p_ac].imx[5],arr_detail[p_ac].imx[6],arr_detail[p_ac].imx[7],
          arr_detail[p_ac].imx[8],arr_detail[p_ac].imx[9],arr_detail[p_ac].imx[10])
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","imx_file",ls_value_fld,"",SQLCA.sqlcode,
                        "Failure to insert imx_file , rollback insert to ima_file !","",1)  #No.FUN-660156
           DELETE FROM ima_file WHERE ima01 = ls_value_fld
           IF s_industry('icd') THEN          #No.MOD-8C0246 add
              LET l_flag = s_del_imaicd(ls_value_fld,'')
           END IF
           RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
        END IF
     END IF 
     LET g_imn[l_ac].imn03 = ls_value                                                                                               
  ELSE                                                                                                                              
    IF ( p_field <> 'imn03' )AND( p_field <> 'imx00' ) THEN                                                                         
       RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                    
    END IF                                                                                                                          
  END IF                                                                     
 
  #--------重要 !!!!!!!!!!!-------------------------                                                                                
  #下面的代碼都是從原INPUT ARRAY中的AFTER FIELD imn03段拷貝來的，唯一做的修改
  #是將原來的NEXT FIELD 語句都改成了RETURN FALSE, xxx,xxx ... ，因為NEXE FIELD                                                      
  #語句要交給調用方來做，這里只需要返回一個FALSE告訴它有錯誤就可以了，同時一起                                                      
  #返回的還有一些CHECK過程中要從ima_file中取得的欄位信息，其他的比如判斷邏輯和                                                      
  #錯誤提示都沒有改，如果你需要在里面添加代碼請注意上面的那個要點就可以了
 
  IF NOT g_imn[l_ac].imn03 IS NULL THEN
 
     IF cl_null(lg_smy62) THEN
       IF g_sma.sma120 = 'Y' THEN                                                                                                   
          CALL cl_itemno_multi_att("imn03",g_imn[l_ac].imn03,"","1","3")
            RETURNING l_tmm,g_imn[l_ac].imn03,l_oeb06
          DISPLAY g_imn[l_ac].imn03 TO imn03
       END IF
     END IF
 
     SELECT ima02,ima021,ima31,ima130,ima131,ima15,ima25,imaacti                                                                    
       INTO g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
       FROM ima_file                                                                                                                
      WHERE ima01=g_imn[l_ac].imn03
     IF STATUS THEN
        CALL cl_err3("sel","ima_file",g_imn[l_ac].imn03,"","mfg0002","","",1)  #No.FUN-660156
       RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
     END IF
 
     IF l_imaacti='N' THEN
       CALL cl_err(g_imn[l_ac].imn03,'mfg0001',1)
       RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
     END IF
 
     IF g_sma.sma115 = 'Y' THEN
        CALL s_chk_va_setting(g_imn[l_ac].imn03)
             RETURNING g_flag,g_ima906,g_ima907
        IF g_flag=1 THEN
           RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
        END IF
        IF g_ima906 = '3' THEN
           LET g_imn[l_ac].imn33=g_ima907
           LET g_imn[l_ac].imn43=g_ima907
        END IF
     END IF
 
     CALL t720_check_item(g_s.imn151,g_imn[l_ac].imn03) #FUN-980093 add
          RETURNING l_v         
    IF l_v='Y' THEN
       RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
    ELSE
       RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
    END IF
    CALL t720_set_no_entry_b()
    CALL t720_set_required()  
  ELSE
     IF ( p_field = 'imn03' )OR( p_field = 'imx00' ) THEN 
        CALL t720_set_no_entry_b()
        CALL t720_set_required()  
        RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
     ELSE
        RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
     END IF
  END IF
 
END FUNCTION
 
#用于att01~att10這十個輸入型屬性欄位的AFTER FIELD事件的判斷函數  
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att10)
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可                                                                         
#與t720_check_imn03相同,如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE                                                            
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD 
FUNCTION t720_check_att0x(p_value,p_index,p_row) 
DEFINE                                                                                                                              
  p_value         LIKE imx_file.imx01,   
  p_index         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  p_row           LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  li_min_num      LIKE agc_file.agc05,   
  li_max_num      LIKE agc_file.agc06,   
  l_index         STRING,                
  l_check_res     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
  l_b2            LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(30)
  l_imaacti       LIKE ima_file.imaacti, 
  l_ima130        LIKE ima_file.ima130,  #FUN-660078                                                                                                
  l_ima131        LIKE ima_file.ima131,  #FUN-660078
  l_ima25         LIKE ima_file.ima25  
 
  IF cl_null(p_value) THEN                                                                                                          
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                      
  END IF                
 
  #判斷長度與定義的使用位數是否相等                                                                                                 
  IF LENGTH(p_value CLIPPED) <> lr_agc[p_index].agc03 THEN                                                                          
     CALL cl_err_msg("","aim-911",lr_agc[p_index].agc03,1)                                                                          
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                      
  END IF                                
  #比較大小是否在合理範圍之內                                                                                                       
  LET li_min_num = lr_agc[p_index].agc05                                                                                            
  LET li_max_num = lr_agc[p_index].agc06                                                                                            
  IF (lr_agc[p_index].agc05 IS NOT NULL) AND                                                                                        
     (p_value < li_min_num) THEN                                                                                                    
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1) 
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
  END IF
  IF (lr_agc[p_index].agc06 IS NOT NULL) AND
     (p_value > li_max_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
  END IF
  #通過了欄位檢查則可以下面的合成子料件代碼以及相應的檢核操作了                                                                     
  LET arr_detail[p_row].imx[p_index] = p_value                                                                                      
  LET l_index = p_index USING '&&'  
  CALL t720_check_imn03('imx' || l_index ,p_row) 
    RETURNING l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
    RETURN l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
END FUNCTION
 
#用于att01_c~att10_c這十個選擇型屬性欄位的AFTER FIELD事件的判斷函數                                                                 
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att10                                                    
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可                                                                         
#與t720_check_imn03相同,如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE                                                            
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD                                                                                
FUNCTION t720_check_att0x_c(p_value,p_index,p_row) 
DEFINE                                                                                                                              
  p_value  LIKE imx_file.imx01,  
  p_index  LIKE type_file.num5,   #No.FUN-690026 SMALLINT
  p_row    LIKE type_file.num5,   #No.FUN-690026 SMALLINT
  l_index  STRING,               
                                 
  l_check_res     LIKE type_file.num10,  #No.FUN-690026 SMALLINT
  l_b2            LIKE type_file.chr20,  #No.FUN-690026 VARCHAR(30)
  l_imaacti       LIKE ima_file.imaacti,                                                                                            
  l_ima130        LIKE ima_file.ima130, #FUN-660078                                                                                                         
  l_ima131        LIKE ima_file.ima131, #FUN-660078                                                                                                        
  l_ima25         LIKE ima_file.ima25  
 
  IF cl_null(p_value) THEN                                                                                                          
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti                                                      
  END IF  
  #下拉框選擇項相當簡單，不需要進行範圍和長度的判斷，因為肯定是符合要求的了                                                         
  LET arr_detail[p_row].imx[p_index] = p_value                                                                                      
  LET l_index = p_index USING '&&'                                                                                                  
  CALL t720_check_imn03('imx'||l_index,p_row) 
    RETURNING l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
      RETURN l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
 
 
END FUNCTION
 
#多工廠多屬性料件資料判斷
#A調撥給B,則需判斷B是否存在調撥料件(母料件及子料件)
#FUNCTION t720_check_item(p_dbs,p_value) #FUN-980093 mark
FUNCTION t720_check_item(p_plant,p_value) #FUN-980093 add
  DEFINE p_dbs      LIKE type_file.chr21,     #No.FUN-690026 VARCHAR(21)
         p_plant    LIKE type_file.chr21,
         p_dbs_tra     LIKE type_file.chr21,
         l_imx10    LIKE imx_file.imx10,
         p_value    LIKE ima_file.ima01,
         l_imx      RECORD LIKE imx_file.*,
         l_ima      RECORD LIKE ima_file.*,
         l_msg      LIKE type_file.chr1000,   #No.FUN-690026 VARCHAR(3000)
         l_sql      LIKE type_file.chr1000,   #No.FUN-690026 VARCHAR(1000)
         l_cnt1     LIKE type_file.num5,      # 子料件計數器  #No.FUN-690026 SMALLINT
         l_cnt2     LIKE type_file.num5,      # 母料件計數器  #No.FUN-690026 SMALLINT
         l_success  LIKE type_file.chr1       #No.FUN-690026 VARCHAR(1)
  DEFINE l_imaicd   RECORD LIKE imaicd_file.* #No.FUN-7B0018
 
     LET l_cnt1 = 0  #計數器初始為0
     LET l_cnt2 = 0
     BEGIN WORK
     #判斷B是否存在調撥料件(子料件)
     SELECT imx10 INTO l_imx10 FROM imx_file
      WHERE imx000=p_value
 
     LET g_plant_new = p_plant
     CALL s_getdbs() LET p_dbs = g_dbs_new
     CALL s_gettrandbs() LET p_dbs_tra = g_dbs_tra
 
    #LET l_sql ="SELECT COUNT(*) FROM ",s_dbstring(p_dbs CLIPPED),"ima_file",  #TQC-940178 ADD  #FUN-A50102
     LET l_sql ="SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'ima_file'),  #FUN-A50102 
                " WHERE ima01= '",p_value CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql    #FUN-A50102
     PREPARE t720_c2_pre FROM l_sql
     DECLARE t720_c2 CURSOR FOR t720_c2_pre
     OPEN t720_c2
     FETCH t720_c2 INTO l_cnt1
     IF STATUS THEN
        LET l_cnt1 = 0
     END IF
     IF l_cnt1 <= 0 THEN   
        #若B不存在調撥料件,則判斷是否存在該調撥料件之母料件
       #LET l_sql = " SELECT COUNT(*) FROM ",s_dbstring(p_dbs CLIPPED),"ima_file",  #TQC-940178 ADD   #FUN-A50102
        LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'ima_file'),  #FUN-A50102   
                    " WHERE ima01= '",l_imx10 CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql    #FUN-A50102
        PREPARE t720_c2_pre2 FROM l_sql
        DECLARE t720_c21 CURSOR FOR t720_c2_pre2
        OPEN t720_c21
        FETCH t720_c21 INTO l_cnt2 
        IF STATUS THEN
           LET l_cnt2=0
           LET l_success='N'
           CLOSE t720_c2
           RETURN l_success      #No.TQC-780079 modify
        END IF
        #--子料件及母料件皆不存在于B中
        IF l_cnt2 <= 0  THEN  
           SELECT * INTO l_ima.* FROM ima_file
            WHERE ima01=l_imx10
           IF SQLCA.sqlcode THEN
              CALL cl_err3("sel","ima_file",l_imx10,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
              CLOSE t720_c2
              CLOSE t720_c21
              LET l_success ='N'
           END IF
          #LET l_sql = " INSERT INTO ",s_dbstring(p_dbs CLIPPED),"ima_file",    #TQC-940178 ADD  #FUN-A50102
           LET l_sql = " INSERT INTO ",cl_get_target_table(p_plant,'ima_file'),  #FUN-A50102 
                       " SELECT * FROM ima_file WHERE ima01='",l_imx10,"'"
 	   #CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #FUN-920032   #FUN-B80070--mark--
           CALL cl_forupd_sql(g_forupd_sql) RETURNING g_forupd_sql       #FUN-B80070--add---
           CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql    #FUN-A50102
           PREPARE t720_c2_pre3 FROM l_sql
           IF STATUS THEN
              LET l_msg = ' prepare t720_c2_pre2',p_dbs CLIPPED,'ima_file'
              LET l_success='N'
            #  ROLLBACK WORK      #FUN-B80070---回滾放在報錯後---
              CALL cl_err(l_msg,SQLCA.sqlcode,1) 
              ROLLBACK WORK       #FUN-B80070--mark--
           ELSE
              IF s_industry('icd') THEN          #No.MOD-8C0246 add
                 INITIALIZE l_imaicd.* TO NULL
                 LET l_imaicd.imaicd00 = l_imx10
                 IF NOT s_ins_imaicd(l_imaicd.*,p_plant) THEN #FUN-980093 add
                    LET l_success = 'N'
                    ROLLBACK WORK
                 END IF
              END IF
           END IF 
        END IF
        SELECT * INTO l_ima.* FROM ima_file
         WHERE ima01=p_value
        IF SQLCA.sqlcode THEN
           CALL cl_err3("sel","ima_file",p_value,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
        END IF 
       #LET l_sql = " INSERT INTO ",s_dbstring(p_dbs CLIPPED),"ima_file",   #TQC-940178 ADD  #FUN-A50102
        LET l_sql = " INSERT INTO ",cl_get_target_table(p_plant,'ima_file'),   #FUN-A50102
                    " SELECT * FROM ima_file WHERE ima01='",p_value,"'"
 	 #CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032   #FUN-B80070--mark--
         CALL cl_forupd_sql(g_forupd_sql) RETURNING g_forupd_sql       #FUN-B80070--add---
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql    #FUN-A50102
        PREPARE t720_c2_pre4 FROM l_sql
        EXECUTE t720_c2_pre4
        IF STATUS THEN
           LET l_msg = ' prepare t720_c2_pre4',p_dbs CLIPPED,'ima_file'
           LET l_success='N'
         #  ROLLBACK WORK       #FUN-B80070---回滾放在報錯後---
           CALL cl_err(l_msg,SQLCA.sqlcode,1) 
           ROLLBACK WORK        #FUN-B80070--add--
        ELSE
           IF s_industry('icd') THEN          #No.MOD-8C0246 add
              INITIALIZE l_imaicd.* TO NULL
              LET l_imaicd.imaicd00 = p_value
              IF NOT s_ins_imaicd(l_imaicd.*,p_plant) THEN #FUN-980093 add
                 LET l_success = 'N'
                 ROLLBACK WORK
              END IF
           END IF
           SELECT * INTO l_imx.* FROM imx_file
            WHERE imx000=p_value
           IF SQLCA.sqlcode THEN
              CALL cl_err3("sel","imx_file",p_value,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
              
           END IF 
          #LET l_sql = " INSERT INTO ",s_dbstring(p_dbs CLIPPED),"imx_file",#TQC-940178 ADD  #FUN-A50102
           LET l_sql = " INSERT INTO ",cl_get_target_table(p_plant,'imx_file'),   #FUN-A50102       
                       " SELECT * FROM imx_file WHERE imx000='",p_value,"'" 
 	   #CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-920032  #FUN-B80070--mark--
           CALL cl_forupd_sql(g_forupd_sql) RETURNING g_forupd_sql       #FUN-B80070--add---
           CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql    #FUN-A50102
           PREPARE t720_c2_pre5 FROM l_sql
           EXECUTE t720_c2_pre5
           IF STATUS THEN
              LET l_msg =' prepare t720_c2_pre5',p_dbs CLIPPED,'imx_file'
           #   ROLLBACK WORK    #FUN-B80070---回滾放在報錯後---
              CALL cl_err(l_msg,SQLCA.sqlcode,1) 
              ROLLBACK WORK     #FUN-B80070--add--
           END IF 
        END IF
        LET l_success ='Y'
        CLOSE t720_c21
     ELSE
        LET l_success ='Y'
     END IF
     CLOSE t720_c2
     COMMIT WORK
 
     RETURN l_success
  
 
END FUNCTION
 
 
FUNCTION t720_spc()
DEFINE l_gaz03        LIKE gaz_file.gaz03
DEFINE l_cnt          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE l_qc_cnt       LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE l_imn02        LIKE imn_file.imn02    ## 項次
DEFINE l_qcs          DYNAMIC ARRAY OF RECORD LIKE qcs_file.*
DEFINE l_qc_prog      LIKE zz_file.zz01      #No.FUN-690026 VARCHAR(10)
DEFINE l_i            LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE l_cmd          STRING
DEFINE l_sql          STRING
DEFINE l_err          STRING
 
   LET g_success = 'Y'
 
   #檢查資料是否可拋轉至 SPC
   IF g_imm.imm04 matches '[Nn]' THEN    #判斷是否撥出確認
      CALL cl_err('imm04','aim-393',0)
      LET g_success='N'
      RETURN
   END IF
 
   IF g_imm.imm03 matches '[Yy]' THEN    #判斷是否撥入確認
      CALL cl_err('imm04','aim-100',0)
      LET g_success='N'
      RETURN
   END IF
 
   #CALL aws_spccli_check('單號','SPC拋轉碼','確認碼','有效碼')
   CALL aws_spccli_check(g_imm.imm01,g_imm.immspc,'','')
   IF g_success = 'N' THEN
      RETURN
   END IF
 
   LET l_qc_prog = "aqct700"               #設定QC單的程式代號
 
   #若在 QC 單已有此單號相關資料，則取消拋轉至 SPC
   SELECT COUNT(*) INTO l_cnt FROM qcs_file WHERE qcs01 = g_imm.imm01  
   IF l_cnt > 0 THEN
      CALL cl_get_progname(l_qc_prog,g_lang) RETURNING l_gaz03
      CALL cl_err_msg(g_imm.imm01,'aqc-115', l_gaz03 CLIPPED || "|" || l_qc_prog CLIPPED,'1')
      LET g_success='N'
      RETURN
   END IF
  
   #需要 QC 檢驗的筆數
   SELECT COUNT(*) INTO l_qc_cnt FROM imn_file 
    WHERE imn01 = g_imm.imm01 AND imn29 = 'Y' 
   IF l_qc_cnt = 0 THEN 
      CALL cl_err(g_imm.imm01,l_err,0) 
      LET g_success='N'
      RETURN
   END IF
 
   #需檢驗的資料，自動新增資料至 QC 單 ,功能參數為「SPC」
   LET l_sql  = "SELECT imn02 FROM imn_file 
                  WHERE imn01 = '",g_imm.imm01,"' AND imn29='Y'"
   PREPARE t720_imn_p FROM l_sql
   DECLARE t720_imn_c CURSOR WITH HOLD FOR t720_imn_p
   FOREACH t720_imn_c INTO l_imn02
       display l_cmd
       LET l_cmd = l_qc_prog CLIPPED," '",g_imm.imm01,"' '",l_imn02,"' '1' 'SPC' 'D'"
       CALL aws_spccli_qc(l_qc_prog,l_cmd)
   END FOREACH 
 
   #判斷產生的 QC 單筆數是否正確
   SELECT COUNT(*) INTO l_cnt FROM qcs_file WHERE qcs01 = g_imm.imm01
   IF l_cnt <> l_qc_cnt THEN
      CALL t720_qcs_del()
      LET g_success='N'
      RETURN
   END IF
 
   LET l_sql  = "SELECT *  FROM qcs_file WHERE qcs01 = '",g_imm.imm01,"'"
   PREPARE t720_qc_p FROM l_sql
   DECLARE t720_qc_c CURSOR WITH HOLD FOR t720_qc_p
   LET l_cnt = 1
   FOREACH t720_qc_c INTO l_qcs[l_cnt].*
       LET l_cnt = l_cnt + 1 
   END FOREACH
   CALL l_qcs.deleteElement(l_cnt)
 
   # CALL aws_spccli() 
   #功能: 傳送此單號所有的 QC 單至 SPC 端
   # 傳入參數: (1) QC 程式代號, (2) QC 單頭資料,
   # 回傳值  : 0 傳送失敗; 1 傳送成功
   IF aws_spccli(l_qc_prog,base.TypeInfo.create(l_qcs),"insert") THEN
      LET g_imm.immspc = '1'
   ELSE
      LET g_imm.immspc = '2'
      CALL t720_qcs_del()
   END IF
 
   UPDATE imm_file set immspc = g_imm.immspc WHERE imm01 = g_imm.imm01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","imm_file",g_imm.imm01,"",STATUS,"","upd immspc",1)
      IF g_imm.immspc = '1' THEN
          CALL t720_qcs_del()
      END IF
      LET g_success = 'N'
   END IF
   DISPLAY BY NAME g_imm.immspc
  
END FUNCTION 
 
FUNCTION t720_qcs_del()
 
      DELETE FROM qcs_file WHERE qcs01 = g_imm.imm01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcs_file",g_imm.imm01,"",SQLCA.sqlcode,"","DEL qcs_file err!",0)
      END IF
 
      DELETE FROM qct_file WHERE qct01 = g_imm.imm01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qct_file",g_imm.imm01,"",SQLCA.sqlcode,"","DEL qct_file err!",0)
      END IF
 
      DELETE FROM qctt_file WHERE qctt01 = g_imm.imm01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qctt_file",g_imm.imm01,"",SQLCA.sqlcode,"","DEL qcstt_file err!",0)
      END IF
 
      DELETE FROM qcu_file WHERE qcu01 = g_imm.imm01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcu_file",g_imm.imm01,"",SQLCA.sqlcode,"","DEL qcu_file err!",0)
      END IF
 
      DELETE FROM qcv_file WHERE qcv01 = g_imm.imm01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcv_file",g_imm.imm01,"",SQLCA.sqlcode,"","DEL qcv_file err!",0)
      END IF
END FUNCTION 
 
FUNCTION t720_u_tlff(p_imn)
DEFINE p_imn     RECORD LIKE imn_file.*
 
    MESSAGE "d_tlff!"
    CALL ui.Interface.refresh()
 
    DELETE FROM tlff_file
     WHERE tlff01 =p_imn.imn03
       AND ((tlff026=g_imm.imm01 AND tlff027=p_imn.imn02) OR
            (tlff036=g_imm.imm01 AND tlff037=p_imn.imn02)) #異動單號/項次 
       AND tlff06 =g_imm.imm02 #異動日期 
       AND tlffplant = p_imn.imn041   #TQC-BB0193 add
       AND tlff030 =p_imn.imn151      #MOD-D50183 add
   
    IF STATUS THEN
       IF g_bgerr THEN
          LET g_showmsg = p_imn.imn03,'/',g_imm.imm02
          CALL s_errmsg('tlff01,tlff06',g_showmsg,'del tlff',STATUS,1) 
       ELSE
          CALL cl_err3("del","tlf_file",g_imm.imm02,"",STATUS,"","del tlff",1)   #NO.FUN-640266 #No.FUN-660156
       END IF
       LET g_success='N' RETURN
    END IF
  #LET g_sql ="DELETE FROM ",g_azp03_tra CLIPPED,"tlff_file ", #FUN-980093 add   #FUN-A50102
   LET g_sql ="DELETE FROM ",cl_get_target_table(g_s.imn151,'tlff_file'),   #FUN-A50102 
              " WHERE tlff01 ='",p_imn.imn03,"' ",
              "   AND ((tlff026='",g_imm.imm01,"' AND tlff027='",p_imn.imn02,"') OR ",
              "(tlff036='",g_imm.imm01,"' AND tlff037='",p_imn.imn02,"')) ", 
              "AND tlff06 ='",g_imm.imm02,"'" #單據日期 
             ,"   AND tlff020 = '",p_imn.imn041,"'"                               #MOD-D50183 add
             ,"   AND tlff030 = '",p_imn.imn151,"'"                               #MOD-D50183 add
   CALL cl_replace_sqldb(g_sql)  RETURNING g_sql   #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,g_s.imn151) RETURNING g_sql #FUN-980093 add
   PREPARE i720_del_p2 FROM g_sql
   EXECUTE i720_del_p2 
   IF STATUS THEN
      IF g_bgerr THEN
         LET g_showmsg = p_imn.imn03,'/',g_imm.imm02
         CALL s_errmsg('tlff01,tlff06',g_showmsg,'del tlff:',STATUS,1) 
      ELSE
         CALL cl_err3("del","tlff_file",g_imm.imm01,"",STATUS,"","del tlff",1)   #NO.FUN-640266 #No.FUN-660156
      END IF
      LET g_success='N' RETURN
   END IF
   IF SQLCA.SQLERRD[3]=0 THEN
      IF g_bgerr THEN
         LET g_showmsg = p_imn.imn03,'/',g_imm.imm02
         CALL s_errmsg('tlff01,tlff06',g_showmsg,'del tlff:','mfg0177',1) 
      ELSE
         CALL cl_err3("del","tlff_file",g_imm.imm01,"","mfg0177","","del tlff",1)   #NO.FUN-640266 #No.FUN-660156
      END IF
      LET g_success='N' RETURN
   END IF
END FUNCTION
 
FUNCTION t720_u_tlf() #------------------------------------ Update tlf_file
  DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
  DEFINE l_sql   STRING                                    #NO.FUN-8C0131 
  DEFINE l_i     LIKE type_file.num5                       #NO.FUN-8C0131 
  
   MESSAGE "d_tlf!"
   CALL ui.Interface.refresh()
  ##NO.FUN-8C0131   add--begin   
    LET l_sql =  " SELECT  * FROM tlf_file ", 
                 "  WHERE  tlf01 = '",b_imn.imn03,"'",
                 "    AND ((tlf026='",g_imm.imm01,"' AND tlf027=",b_imn.imn02,") OR ",
                 "        (tlf036='",g_imm.imm01,"' AND tlf037=",b_imn.imn02,")) ",
                 "   AND tlf06 ='",g_imm.imm02,"'",     
                 "   AND tlfplant = '",b_imn.imn041,"'"   #TQC-BB0193 add
                ,"   AND tlf030 = '",b_imn.imn151,"'"     #MOD-D50183 add
    DECLARE t720_u_tlf_c CURSOR FROM l_sql
    LET l_i = 0 
    CALL la_tlf.clear()
    FOREACH t720_u_tlf_c INTO g_tlf.*
       LET l_i = l_i + 1
       LET la_tlf[l_i].* = g_tlf.*
    END FOREACH     

  ##NO.FUN-8C0131   add--end 
   DELETE FROM tlf_file
    WHERE tlf01 =b_imn.imn03
      AND ((tlf026=g_imm.imm01 AND tlf027=b_imn.imn02) OR
           (tlf036=g_imm.imm01 AND tlf037=b_imn.imn02)) #異動單號/項次 
      AND tlf06 =g_imm.imm02 #單據日期
      AND tlfplant = b_imn.imn041   #TQC-BB0193 add  #plant 為撥出營運中心 
      AND tlf030 = b_imn.imn151     #MOD-D50183 add
 
   IF STATUS THEN
      IF g_bgerr THEN
         LET g_showmsg = b_imn.imn03,'/',g_imm.imm02
         CALL s_errmsg('tlf01,tlf06',g_showmsg,'del tlf:',STATUS,1) 
      ELSE
         CALL cl_err3("del","tlf_file",g_imm.imm01,"",STATUS,"","del tlf",1)   #NO.FUN-640266 #No.FUN-660156
      END IF
      LET g_success='N' RETURN
   END IF
 
   IF SQLCA.SQLERRD[3]=0 THEN
      IF g_bgerr THEN
         LET g_showmsg = b_imn.imn03,'/',g_imm.imm02
         CALL s_errmsg('tlf01,tlf06',g_showmsg,'del tlf:','mfg0177',1) 
      ELSE
         CALL cl_err3("del","tlf_file",g_imm.imm01,"","mfg0177","","del tlf",1)   #NO.FUN-640266 #No.FUN-660156
      END IF
      LET g_success='N' RETURN
   END IF
  ##NO.FUN-8C0131   add--begin
    FOR l_i = 1 TO la_tlf.getlength()
       LET g_tlf.* = la_tlf[l_i].*
       IF NOT s_untlf1('') THEN 
          LET g_success='N' RETURN
       END IF 
    END FOR       
  ##NO.FUN-8C0131   add--end
  ##NO.FUN-8C0131   add--begin   
   #LET l_sql =  " SELECT  * FROM",g_azp03_tra CLIPPED,"tlf_file ",  #FUN-A50102
    LET l_sql =  " SELECT  * FROM ",cl_get_target_table(g_s.imn151,'tlf_file'),   #FUN-A50102 
                 "  WHERE  tlf01 = '",b_imn.imn03,"'",
                 "    AND ((tlf026='",g_imm.imm01,"' AND tlf027=",b_imn.imn02,") OR ",
                 "        (tlf036='",g_imm.imm01,"' AND tlf037=",b_imn.imn02,")) ",
                 "   AND tlf06 ='",g_imm.imm02,"'"     
                ,"   AND tlf020 = '",b_imn.imn041,"'"   #MOD-D50183 add
                ,"   AND tlf030 = '",b_imn.imn151,"'"   #MOD-D50183 add
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql  #FUN-A50102
   #CALL cl_parse_qry_sql(g_sql,g_s.imn151) RETURNING g_sql   #FUN-A50102   #TQC-BB0193 mark
    CALL cl_parse_qry_sql(l_sql,g_s.imn151) RETURNING l_sql  #TQC-BB0193 add  
    DECLARE t720_u_tlf_c1 CURSOR FROM l_sql
    LET l_i = 0 
    CALL la_tlf.clear()
    FOREACH t720_u_tlf_c1 INTO g_tlf.*
       LET l_i = l_i + 1
       LET la_tlf[l_i].* = g_tlf.*
    END FOREACH     

  ##NO.FUN-8C0131   add--end  
  #LET g_sql ="DELETE FROM ",g_azp03_tra CLIPPED,"tlf_file ", #FUN-980093 add   #FUN-A50102
   LET g_sql ="DELETE FROM ",cl_get_target_table(g_s.imn151,'tlf_file'),   #FUN-A50102 
             #"WHERE tlf01 ='",b_imn.imn03,"' ",  #TQC-AC0044
              " WHERE tlf01 ='",b_imn.imn03,"' ", #TQC-AC0044
              "AND ((tlf026='",g_imm.imm01,"' AND tlf027='",b_imn.imn02,"') OR ",
              "(tlf036='",g_imm.imm01,"' AND tlf037='",b_imn.imn02,"')) ", 
              "AND tlf06 ='",g_imm.imm02,"'" #單據日期 
             ,"   AND tlf020 = '",b_imn.imn041,"'"   #MOD-D50183 add
             ,"   AND tlf030 = '",b_imn.imn151,"'"   #MOD-D50183 add
   #CALL cl_replace_sqldb(l_sql) RETURNING l_sql  #FUN-A50102  #TQC-BB0193 mark 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #TQC-BB0193 add
   CALL cl_parse_qry_sql(g_sql,g_s.imn151) RETURNING g_sql  #FUN-980093
   PREPARE i720_del_p1 FROM g_sql
   EXECUTE i720_del_p1 
   IF STATUS THEN
      IF g_bgerr THEN
         LET g_showmsg = b_imn.imn03,'/',g_imm.imm02
         CALL s_errmsg('tlf01,tlf06',g_showmsg,'del tlf:',STATUS,1) 
      ELSE
         CALL cl_err3("del","tlf_file",g_imm.imm01,"",STATUS,"","del tlf",1)   #NO.FUN-640266 #No.FUN-660156
      END IF
      LET g_success='N' RETURN
   END IF
   IF SQLCA.SQLERRD[3]=0 THEN
      IF g_bgerr THEN
         LET g_showmsg = b_imn.imn03,'/',g_imm.imm02
         CALL s_errmsg('tlf01,tlf06',g_showmsg,'del tlf:','mfg0177',1) 
      ELSE
         CALL cl_err3("del","tlf_file",g_imm.imm01,"","mfg0177","","del tlf",1)   #NO.FUN-640266 #No.FUN-660156
      END IF
      LET g_success='N' RETURN
   END IF
  ##NO.FUN-8C0131   add--begin
    FOR l_i = 1 TO la_tlf.getlength()
       LET g_tlf.* = la_tlf[l_i].*
      # IF NOT s_untlf1(g_azp03_tra) THEN 
        IF NOT s_untlf1(g_s.imn151) THEN   #FUN-A50102
          LET g_success='N' RETURN
       END IF 
    END FOR       
  ##NO.FUN-8C0131   add--end 
END FUNCTION
#No.FUN-9C0072 精簡程式碼 
#FUN-CB0087---add---str---
FUNCTION t720_imn28_chk()
DEFINE l_flag       LIKE type_file.chr1,
       l_sql        STRING,
       l_where      STRING,
       l_n          LIKE type_file.num5,
       l_i          LIKE type_file.num5,
       l_store      STRING,
       l_azf03      LIKE azf_file.azf03,
       l_azf09      LIKE azf_file.azf09
   IF g_aza.aza115 = 'Y' THEN
      FOR l_i=1 TO g_imn.getlength()
         LET l_store = ''
         IF NOT cl_null(g_imn[l_i].imn04) THEN
            LET l_store = l_store,g_imn[l_i].imn04
         END IF
         IF NOT cl_null(g_imn[l_i].imn15) THEN
            IF NOT cl_null(l_store) THEN
               LET l_store = l_store,"','",g_imn[l_i].imn15
            ELSE
               LET l_store = l_store,g_imn[l_i].imn15
            END IF
         END IF
         CALL s_get_where(g_imm.imm01,'','',g_imn[l_i].imn03,l_store,'',g_imm.imm14) RETURNING l_flag,l_where
         IF l_flag THEN
            LET l_n=0
            LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_imn[l_i].imn28,"' AND ",l_where
            PREPARE ggc08_pre FROM l_sql
            EXECUTE ggc08_pre INTO l_n
            IF l_n < 1 THEN
               CALL cl_err('','aim-425',0)
               RETURN FALSE
            END IF
         ELSE 
            LET g_errno = ''
            SELECT azf03,azf09 INTO l_azf03,l_azf09 FROM azf_file  
            WHERE azf01 = g_imn[l_i].imn28 AND azf02 = '2'

            CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3088'
                                           LET l_azf03 = ''
                 WHEN l_azf09 != '6'       LET g_errno = 'aoo-405'      
                 OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
            END CASE
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_imn[l_i].imn28,g_errno,0)
               RETURN FALSE
            END IF
         END IF
      END FOR
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t720_imn28_chk1()
DEFINE  l_flag          LIKE type_file.chr1,
        l_n             LIKE type_file.num5,
        l_where         STRING,
        l_sql           STRING,
        l_store         STRING,
        l_azf03      LIKE azf_file.azf03,
        l_azf09      LIKE azf_file.azf09
   LET l_store = ''
   IF NOT cl_null(g_imn[l_ac].imn04) THEN
      LET l_store = l_store,g_imn[l_ac].imn04
   END IF
   IF NOT cl_null(g_imn[l_ac].imn15) THEN
      IF NOT cl_null(l_store) THEN
         LET l_store = l_store,"','",g_imn[l_ac].imn15
      ELSE
         LET l_store = l_store,g_imn[l_ac].imn15
      END IF
   END IF
   IF NOT cl_null(g_imn[l_ac].imn28) THEN
      LET l_n = 0
      LET l_flag = FALSE
      IF g_aza.aza115='Y' THEN
         CALL s_get_where(g_imm.imm01,'','',g_imn[l_ac].imn03,l_store,'',g_imm.imm14) RETURNING l_flag,l_where
      END IF
      IF g_aza.aza115='Y' AND l_flag THEN
         LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_imn[l_ac].imn28,"' AND ",l_where
         PREPARE ggc08_pre1 FROM l_sql
         EXECUTE ggc08_pre1 INTO l_n
         IF l_n < 1 THEN
            CALL cl_err('','aim-425',0)
            RETURN FALSE
         END IF
      ELSE
         #SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01 = g_imn[l_ac].imn28 AND azf02 = '2'
         #IF l_n < 1 THEN
         #   CALL cl_err('','aim-425',0)
         LET g_errno = ''
         SELECT azf03,azf09 INTO l_azf03,l_azf09 FROM azf_file   
         WHERE azf01 = g_imn[l_ac].imn28 AND azf02 = '2'

         CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3088'
                                        LET l_azf03 = ''
              WHEN l_azf09 != '6'       LET g_errno = 'aoo-405'  
              OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_imn[l_ac].imn28,g_errno,0)
            RETURN FALSE
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t720_azf03()
   SELECT azf03 INTO g_imn[l_ac].azf03
     FROM azf_file
    WHERE azf01 = g_imn[l_ac].imn28
      AND azf02 = '2'
   DISPLAY BY NAME g_imn[l_ac].azf03
END FUNCTION
#FUN-CB0087---add---end---
#CHI-D40043---begin
FUNCTION t720_x(p_type)  
   DEFINE l_cnt  LIKE type_file.num10 
   DEFINE l_flag LIKE type_file.chr1  
   DEFINE p_type LIKE type_file.chr1 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_imm.* FROM imm_file WHERE imm01=g_imm.imm01 
   IF cl_null(g_imm.imm01) THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_imm.imm04 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_imm.immspc = '1' OR g_imm.immspc = '3' THEN CALL cl_err('','aqc-116',0) RETURN END IF  #FUN-680010
   #-->已有QC單則不可作廢
   SELECT COUNT(*) INTO l_cnt FROM qcs_file
    WHERE qcs01 = g_imm.imm01 AND qcs00='D'
   IF l_cnt > 0 THEN
      CALL cl_err(' ','aqc-118',0)
      RETURN
   END IF

   IF p_type = 1 THEN
      IF g_imm.imm04 ='X' THEN RETURN END IF
   ELSE
      IF g_imm.imm04 <>'X' THEN RETURN END IF
   END IF

   BEGIN WORK
   IF g_imm.imm04 = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF 
   IF cl_void(0,0,l_flag) THEN       
        IF p_type = 1 THEN       
            LET g_imm.imm04='X'
        ELSE
            LET g_imm.imm04='N'
        END IF
        UPDATE imm_file SET imm04 = g_imm.imm04,immmodu=g_user,immdate=TODAY
         WHERE imm01 = g_imm.imm01
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","imm_file",g_imm.imm01,"",SQLCA.sqlcode,"","up imm04",1) 
           ROLLBACK WORK
        ELSE
            COMMIT WORK
            CALL cl_flow_notify(g_imm.imm01,'V')
        END IF
   END IF
   SELECT imm04 INTO g_imm.imm04 FROM imm_file WHERE imm01 = g_imm.imm01 
   DISPLAY BY NAME g_imm.imm04
END FUNCTION
#CHI-D40043---end
