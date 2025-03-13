# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: satmt270.4gl
# Descriptions...: 庫存雜收雜發維護作業
# Date & Author..: 06/01/18 By Tracy
# Modify.........: No.TQC-610014 06/01/24 By pengu 單身新增且為單一單位時，若打異動數量欄位未輸入案enter後程式會產生無窮回圈當住
# Modify.........: No.FUN-610090 06/01/25 By Nicola 拆并箱功能修改 (tracy追單)
# Modify.........: No.MOD-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-630018 06/03/08 By Claire 傳入單號及項次給s_upimg (tracy追單) 
# Modify.........: NO.TQC-620156 06/03/09 By kim GP3.0庫存不足err_log 延續 FUN-610070 的修改
# Modify.........: No.FUN-630046 06/03/14 BY Alexstar 新增申請人(表單關系人)欄位 (tracy追單)
# Modify.........: No.MOD-640049 06/04/08 BY kim 單身資料輸入問題  
# Modify.........: No.MOD-640054 06/04/08 BY Joer 單身新增第二筆時,不設預設值 (tracy追單) 
# Modify.........: NO.TQC-640124 06/04/10 By Tracy 取消帳款客戶欄位,修改ina1004開窗條件并更改帶出欄位,隱藏導物流狀況碼和已打印提單
# Modify.........: No.MOD-640485 06/04/17 BY Claire 單身資料輸入問題,使用下箭頭可避過控卡,但資料仍未寫入成功 (tracy追單)  
# Modify.........: No.FUN-640056 06/04/18 BY wujie  單身母料件控管 (tracy追單) 
# Modify.........: No.TQC-650015 06/05/05 BY Claire 料件多屬性@CHILD應可輸入
# Modify.........: No.MOD-650040 06/05/09 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-650094 06/05/22 BY Tracy 增加料件多屬性內容
# Modify.........: No.TQC-650111 06/05/26 BY Tracy 料件第一次入庫有問題，不可以新增img明細
# Modify.........: No.FUN-660104 06/06/20 By cl  Error Message 調整
# Modify.........: No.TQC-660097 06/06/21 By Rayven 多屬性功能改進:查詢時不顯示多屬性內容 
# Modify.........: No.FUN-660166 06/06/23 By saki 流程訊息通知功能
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680120 06/09/01 By chen 類型轉換
# Modify.........: No.FUN-690023 06/09/11 By jamie 判斷occacti
# Modify.........: No.FUN-690025 06/09/20 By jamie 改判斷狀況碼ima1010、occ1004 
# Modify.........: No.FUN-6A0072 06/10/24 By xumin g_no_ask改g_no_ask    
# Modify.........: No.TQC-6A0079 06/11/01 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.CHI-6A0004 06/11/06 By hellen 本原幣取位修改
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6A0036 06/11/14 By rainy 判斷停產(ima140)時，要一併判斷 ima1401生效日
# Modify.........: No.FUN-6B0065 06/11/21 By Ray atmi217并入aooi313(azf09,10,11,12,13取代tqe03,04,05,11,08)
# Modify.........: No.FUN-6B0079 06/12/04 By jamie 1.FUNCTION _fetch() 清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6C0017 06/12/14 By jamie 程式開頭增加'database ds'
# Modify.........: No.CHI-6A0015 06/12/19 By rainy 輸入料號後要自動帶出預設倉庫/儲位
# Modify.........: No.FUN-6C0083 06/12/08 By Nicola 錯誤訊息彙整
# Modify.........: No.TQC-710032 07/01/15 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-710033 07/02/07 By Carrier 錯誤信息匯總  
# Modify.........: No.MOD-740017 07/04/09 By claire 申請人不會顯示
# Modify.........: No.TQC-750018 07/05/04 By rainy 更改狀態無更改料號時，不重帶倉庫儲位
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-770019 07/07/26 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: No.TQC-790082 07/09/13 By lumxa 審核狀態下，進行中英文轉換時，審核圖標消失
# Modify.........: No.MOD-7B0251 07/11/30 By Carol 調整SQL語法
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-810045 08/03/03 By rainy 項目管理:專案table gja_file改為pja_file
# Modify.........: No.FUN-830132 08/03/27 By hellen 行業別拆分表 INSERT/DELETE
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-870163 08/07/31 By sherry 預設申請數量=原異動數量
# Modify.........: No.FUN-8A0086 08/10/20 By lutingting LET g_success = 'Y' 應該放在s_showmsg_init()前面
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWI
# Modify.........: No.FUN-930109 09/03/19 By xiaofeizhu 過賬時增加s_incchk檢查使用者是否有相應倉,儲的過賬權限
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowi定義規範化
# Modify.........: No.TQC-940184 09/05/12 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法   
# Modify.........: No.TQC-950134 09/05/22 By Carrier rowi定義規範化
# Modify.........: No.FUN-980009 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-870100 09/08/20 By cockroach 對ina12,inapos賦默認值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.FUN-980059 09/09/08 By arman GP5.2架構,修改SUB相關傳入參數
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.CHI-960052 09/10/15 By chenmoyan 使用多單位，料件是單一單位或參考單位時，單位一的轉換率錯誤
# Modify.........: No.FUN-9C0073 10/01/05 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.FUN-AA0062 10/11/05 By yinhy 倉庫權限使用控管修改
# Modify.........: No.FUN-AB0025 10/11/11 By vealxu 全系統增加料件管控
# Modify.........: No.FUN-AB0067 10/11/17 by destiny  增加倉庫的權限控管
# Modify.........: No.FUN-B30029 11/03/11 By huangtao 移除簽核相關欄位
# Modify.........: No.TQC-B30142 11/03/17 By lilingyu 單頭客戶編號欄位輸入完值後,報錯-217,原因是after feild 後的檢查sql錯誤
# Modify.........: No.CHI-B40058 11/05/16 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No:FUN-B70074 11/07/21 By fengrui 添加行業別表的新增於刪除
# Modify.........: No:FUN-B80061 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-BB0085 11/11/29 By xianghui 增加數量欄位小數取位
# Modify.........: No.FUN-BC0104 12/01/17 By xianghui 數量異動回寫qco20
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.FUN-C20048 12/02/09 By fengrui 量欄位小數取位處理
# Modify.........: No.FUN-C30300 12/04/09 By bart  倉儲批開窗需顯示參考單位數量
# Modify.........: No.TQC-C50038 12/05/07 By fanbj 錄入完理由碼，做合理性檢查時，SQL有誤，沒有給碼類型的條件
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:TQC-C60028 12/06/04 By bart 只要是ICD行業 倉儲批開窗改用q_idc
# Modify.........: No.CHI-C30107 12/06/13 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C30085 12/06/21 By lixiang 串CR報表改GR報表
# Modify.........: No.FUN-C70087 12/08/01 By bart 整批寫入img_file
# Modify.........: No:FUN-C80107 12/09/18 By suncx 新增可按倉庫進行負庫存判斷
# Modify.........: No.CHI-C80041 12/12/05 By bart 取消單頭資料控制
# Modify.........: No.FUN-CC0074 12/12/11 By zhangll 雜項報廢增加根據參數管控必輸性
# Modify.........: No:FUN-CC0095 12/12/18 By bart 修改整批寫入img_file
# Modify.........: No.FUN-CB0087 12/12/20 By xujing 倉庫單據理由碼改善
# Modify.........: No.TQC-D20031 13/02/20 By xujing 處理satmt270 理由碼控管
# Modify.........: No:FUN-D20039 13/01/21 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No:CHI-D20014 13/02/22 By nanbing 設限倉庫控卡 不需处理，还原
# Modify.........: No.TQC-D20047 13/02/27 By xujing 處理理由嗎碼說明帶值的問題
# Modify.........: No.TQC-D20063 13/02/27 By xujing IF aza115='Y' THEN 帶出理由碼說明的where 條件不需要加azf09='4'
# Modify.........: No.TQC-D20067 13/02/27 By xujing 調整b_fill()裏根據參數aza115給不同的條件抓azf03
# Modify.........: No:FUN-D30024 13/03/12 By fengrui 負庫存依據imd23判斷
# Modify.........: No:FUN-D30033 13/04/12 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D40078 13/04/28 By xujing 負庫存函数添加营运中心参数 

DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-CC0095---begin
GLOBALS
   DEFINE g_padd_img       DYNAMIC ARRAY OF RECORD
                     img01 LIKE img_file.img01,
                     img02 LIKE img_file.img02,
                     img03 LIKE img_file.img03,
                     img04 LIKE img_file.img04,
                     img05 LIKE img_file.img05,
                     img06 LIKE img_file.img06,
                     img09 LIKE img_file.img09,
                     img13 LIKE img_file.img13,
                     img14 LIKE img_file.img14,
                     img17 LIKE img_file.img17,
                     img18 LIKE img_file.img18,
                     img19 LIKE img_file.img19,
                     img21 LIKE img_file.img21,
                     img26 LIKE img_file.img26,
                     img27 LIKE img_file.img27,
                     img28 LIKE img_file.img28,
                     img35 LIKE img_file.img35,
                     img36 LIKE img_file.img36,
                     img37 LIKE img_file.img37
                           END RECORD

   DEFINE g_padd_imgg      DYNAMIC ARRAY OF RECORD
                    imgg00 LIKE imgg_file.imgg00,
                    imgg01 LIKE imgg_file.imgg01,
                    imgg02 LIKE imgg_file.imgg02,
                    imgg03 LIKE imgg_file.imgg03,
                    imgg04 LIKE imgg_file.imgg04,
                    imgg05 LIKE imgg_file.imgg05,
                    imgg06 LIKE imgg_file.imgg06,
                    imgg09 LIKE imgg_file.imgg09,
                    imgg10 LIKE imgg_file.imgg10,
                    imgg20 LIKE imgg_file.imgg20,
                    imgg21 LIKE imgg_file.imgg21,
                    imgg211 LIKE imgg_file.imgg211,
                    imggplant LIKE imgg_file.imggplant,
                    imgglegal LIKE imgg_file.imgglegal
                            END RECORD
END GLOBALS
#FUN-CC0095---end
DEFINE
    g_ina               RECORD LIKE ina_file.*,
    g_ina_t             RECORD LIKE ina_file.*,
    g_ina_o             RECORD LIKE ina_file.*,
    g_yy,g_mm	        LIKE type_file.num5,             #No.FUN-680120 SMALLINT       
    b_inb               RECORD LIKE inb_file.*,
    g_img09             LIKE img_file.img09,
    g_img10             LIKE img_file.img10,
    g_inb               DYNAMIC ARRAY OF RECORD  #程式變數(Prinram Variables)
                        inb03     LIKE inb_file.inb03,
#                       inb15     LIKE inb_file.inb15,                    #TQC-D20031 mark
#                       azf03     LIKE azf_file.azf03,     #No.FUN-6B0065 #TQC-D20031 mark
                        inb04     LIKE inb_file.inb04,
                        att00     LIKE imx_file.imx00,  
                        att01     LIKE imx_file.imx01,           #No.FUN-680120 VARCHAR(10)
                        att01_c   LIKE imx_file.imx01,           #No.FUN-680120 VARCHAR(10)   
                        att02     LIKE imx_file.imx02,           #No.FUN-680120 VARCHAR(10)   
                        att02_c   LIKE imx_file.imx02,           #No.FUN-680120 VARCHAR(10)   
                        att03     LIKE imx_file.imx03,           #No.FUN-680120 VARCHAR(10)   
                        att03_c   LIKE imx_file.imx03,           #No.FUN-680120 VARCHAR(10)   
                        att04     LIKE imx_file.imx04,           #No.FUN-680120 VARCHAR(10)   
                        att04_c   LIKE imx_file.imx04,           #No.FUN-680120 VARCHAR(10)   
                        att05     LIKE imx_file.imx05,           #No.FUN-680120 VARCHAR(10)   
                        att05_c   LIKE imx_file.imx05,           #No.FUN-680120 VARCHAR(10)    
                        att06     LIKE imx_file.imx06,           #No.FUN-680120 VARCHAR(10)   
                        att06_c   LIKE imx_file.imx06,           #No.FUN-680120 VARCHAR(10)   
                        att07     LIKE imx_file.imx07,           #No.FUN-680120 VARCHAR(10)   
                        att07_c   LIKE imx_file.imx07,           #No.FUN-680120 VARCHAR(10)   
                        att08     LIKE imx_file.imx08,           #No.FUN-680120 VARCHAR(10)   
                        att08_c   LIKE imx_file.imx08,           #No.FUN-680120 VARCHAR(10)   
                        att09     LIKE imx_file.imx09,           #No.FUN-680120 VARCHAR(10)   
                        att09_c   LIKE imx_file.imx09,           #No.FUN-680120 VARCHAR(10)   
                        att10     LIKE imx_file.imx10,           #No.FUN-680120 VARCHAR(10)   
                        att10_c   LIKE imx_file.imx10,           #No.FUN-680120 VARCHAR(10)   
                        ima02     LIKE ima_file.ima02, 
                        ima021    LIKE ima_file.ima021,
                        ima1002   LIKE ima_file.ima1002,
                        ima135    LIKE ima_file.ima135,
                        inb05     LIKE inb_file.inb05,
                        inb06     LIKE inb_file.inb06,
                        inb07     LIKE inb_file.inb07, 
                        inb08     LIKE inb_file.inb08,
                        inb08_fac LIKE inb_file.inb08_fac,
                        inb09     LIKE inb_file.inb09,         
                        inb905    LIKE inb_file.inb905,
                        inb906    LIKE inb_file.inb906,
                        inb907    LIKE inb_file.inb907,
                        inb902    LIKE inb_file.inb902,
                        inb903    LIKE inb_file.inb903,
                        inb904    LIKE inb_file.inb904,
                        inb1004   LIKE inb_file.inb1004,
                        inb1005   LIKE inb_file.inb1005,
                        inb1002   LIKE inb_file.inb1002,
                        inb1001   LIKE inb_file.inb1001,
                        inb1003   LIKE inb_file.inb1003,
                        inb1006   LIKE inb_file.inb1006,
                        inb11     LIKE inb_file.inb11,
                        inb12     LIKE inb_file.inb12,
                        inb901    LIKE inb_file.inb901,  
                        inb10     LIKE inb_file.inb10,   
                        inb15     LIKE inb_file.inb15,      #TQC-D20031 add
                        azf03     LIKE azf_file.azf03       #TQC-D20031 add
                        END RECORD,
    g_inb_t             RECORD
                        inb03     LIKE inb_file.inb03,
#                       inb15     LIKE inb_file.inb15,                     #TQC-D20031 mark
#                       azf03     LIKE azf_file.azf03,     #No.FUN-6B0065  #TQC-D20031 mark
                        inb04     LIKE inb_file.inb04,
                        att00     LIKE imx_file.imx00,  
                        att01     LIKE imx_file.imx01,           #No.FUN-680120 VARCHAR(10)    
                        att01_c   LIKE imx_file.imx01,           #No.FUN-680120 VARCHAR(10)   
                        att02     LIKE imx_file.imx02,           #No.FUN-680120 VARCHAR(10)   
                        att02_c   LIKE imx_file.imx02,           #No.FUN-680120 VARCHAR(10)   
                        att03     LIKE imx_file.imx03,           #No.FUN-680120 VARCHAR(10)   
                        att03_c   LIKE imx_file.imx03,           #No.FUN-680120 VARCHAR(10)   
                        att04     LIKE imx_file.imx04,           #No.FUN-680120 VARCHAR(10)   
                        att04_c   LIKE imx_file.imx04,           #No.FUN-680120 VARCHAR(10)   
                        att05     LIKE imx_file.imx05,           #No.FUN-680120 VARCHAR(10)   
                        att05_c   LIKE imx_file.imx05,           #No.FUN-680120 VARCHAR(10)   
                        att06     LIKE imx_file.imx06,           #No.FUN-680120 VARCHAR(10)   
                        att06_c   LIKE imx_file.imx06,           #No.FUN-680120 VARCHAR(10)   
                        att07     LIKE imx_file.imx07,           #No.FUN-680120 VARCHAR(10)   
                        att07_c   LIKE imx_file.imx07,           #No.FUN-680120 VARCHAR(10)   
                        att08     LIKE imx_file.imx08,           #No.FUN-680120 VARCHAR(10)   
                        att08_c   LIKE imx_file.imx08,           #No.FUN-680120 VARCHAR(10)   
                        att09     LIKE imx_file.imx09,           #No.FUN-680120 VARCHAR(10)   
                        att09_c   LIKE imx_file.imx09,           #No.FUN-680120 VARCHAR(10)   
                        att10     LIKE imx_file.imx10,           #No.FUN-680120 VARCHAR(10)   
                        att10_c   LIKE imx_file.imx10,           #No.FUN-680120 VARCHAR(10)   
                        ima02     LIKE ima_file.ima02, 
                        ima021    LIKE ima_file.ima021,
                        ima1002   LIKE ima_file.ima1002,
                        ima135    LIKE ima_file.ima135,
                        inb05     LIKE inb_file.inb05,
                        inb06     LIKE inb_file.inb06,
                        inb07     LIKE inb_file.inb07,   
                        inb08     LIKE inb_file.inb08,
                        inb08_fac LIKE inb_file.inb08_fac,
                        inb09     LIKE inb_file.inb09,
                        inb905    LIKE inb_file.inb905,
                        inb906    LIKE inb_file.inb906,
                        inb907    LIKE inb_file.inb907,
                        inb902    LIKE inb_file.inb902,
                        inb903    LIKE inb_file.inb903,
                        inb904    LIKE inb_file.inb904,
                        inb1004   LIKE inb_file.inb1004,
                        inb1005   LIKE inb_file.inb1005,
                        inb1002   LIKE inb_file.inb1002,
                        inb1001   LIKE inb_file.inb1001,
                        inb1003   LIKE inb_file.inb1003,
                        inb1006   LIKE inb_file.inb1006,
                        inb11     LIKE inb_file.inb11,
                        inb12     LIKE inb_file.inb12,
                        inb901    LIKE inb_file.inb901, 
                        inb10     LIKE inb_file.inb10,
                        inb15     LIKE inb_file.inb15,      #TQC-D20031 add
                        azf03     LIKE azf_file.azf03       #TQC-D20031 add
                        END RECORD,
    g_unit_arr          DYNAMIC ARRAY OF RECORD  #FUN-570036                                                                        
                        unit   LIKE ima_file.ima25,                                                                                 
                        fac    LIKE img_file.img21,                                                                                 
                        qty    LIKE img_file.img10                                                                                  
                        END RECORD,                                
    g_yes               LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
    g_imgg10_2          LIKE img_file.img10,
    g_imgg10_1          LIKE img_file.img10,
    g_change            LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
    g_change1           LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
    g_ima906            LIKE ima_file.ima906,
    g_ima907            LIKE ima_file.ima907,
    g_imgg00            LIKE imgg_file.imgg00,
    g_imgg10            LIKE imgg_file.imgg10,
    g_sw                LIKE type_file.num5,             #No.FUN-680120 SMALLINT
    g_factor            LIKE inb_file.inb08_fac,
    g_tot               LIKE img_file.img10,
    g_qty               LIKE img_file.img10,
    g_flag              LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
    g_wc,g_wc2,g_sql    string,  
    g_t1                LIKE oay_file.oayslip,        #No.FUN-680120 VARCHAR(5)
    g_buf               LIKE gem_file.gem02,          #No.FUN-680120 VARCHAR(40)
    g_chr               LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
    g_chr2              LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
    g_rec_b             LIKE type_file.num5,          #單身筆數        #No.FUN-680120 SMALLINT
    g_void              LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
    g_imd10             LIKE imd_file.imd10,
    g_occ02a            LIKE nma_file.nma04,           #No.FUN-680120 VARCHAR(30)                                                                                                 
    g_occ02b            LIKE nma_file.nma04,           #No.FUN-680120 VARCHAR(30)                                                                                                
    g_occ02d            LIKE nma_file.nma04,           #No.FUN-680120 VARCHAR(30)         
    g_tqa02a            LIKE tqa_file.tqa02,         
    g_tqb02a            LIKE tqb_file.tqb02,         
    g_tqb02b            LIKE tqb_file.tqb02,         
    g_tqa02b            LIKE tqa_file.tqa02,         
    l_ac                LIKE type_file.num5                   #目前處理的ARRAY CNT        #No.FUN-680120 SMALLINT
DEFINE g_argv1               LIKE aba_file.aba18           #No.FUN-680120 VARCHAR(2)
DEFINE g_argv2               LIKE ina_file.ina01  
DEFINE g_argv3               STRING              #No.FUN-660166
DEFINE g_forupd_sql          STRING              #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE g_laststage           LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)           
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_i                   LIKE type_file.num5              #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE g_row_count           LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_curs_index          LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_jump                LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_no_ask             LIKE type_file.num5          #No.FUN-680120 SMALLINT     #No.FUN-6A0072
DEFINE  g_azf10              LIKE azf_file.azf10     #No.FUN-6B0065
DEFINE  g_imm01              LIKE imm_file.imm01 #No.FUN-610090  	
DEFINE  arr_detail           DYNAMIC ARRAY OF RECORD
          imx00              LIKE imx_file.imx00,
          imx                ARRAY[10] OF LIKE imx_file.imx01 
        END RECORD
DEFINE  lr_agc               DYNAMIC ARRAY OF RECORD LIKE agc_file.*
DEFINE  lg_smy62             LIKE smy_file.smy62 #在smy_file中定義的與當前單別關聯的組別   
DEFINE  lg_group             LIKE smy_file.smy62 #當前單身中采用的組別
DEFINE  g_value              LIKE ima_file.ima01  
DEFINE  g_inb04              LIKE inb_file.inb04 
DEFINE  g_chr3               LIKE type_file.chr1                     #No.FUN-680120 VARCHAR(1)
DEFINE  g_chr4               LIKE type_file.chr1                     #No.FUN-680120 VARCHAR(1)
DEFINE  g_inb08_t            LIKE inb_file.inb08    #FUN-BB0085
DEFINE  g_inb905_t           LIKE inb_file.inb905   #FUN-BB0085
DEFINE  g_inb902_t           LIKE inb_file.inb902   #FUN-BB0085
DEFINE  g_inb1004_t          LIKE inb_file.inb1004  #FUN-BB0085
#DEFINE l_img_table      STRING             #FUN-C70087 #FUN-CC0095
#DEFINE l_imgg_table     STRING             #FUN-C70087 #FUN-CC0095
#DEFINE  g_sma894            LIKE type_file.chr1    #No.FUN-C80107 #FUN-D30024 mark
DEFINE g_imd23               LIKE type_file.chr1    #FUN-D30024 add
 
FUNCTION t270(p_argv1)
    DEFINE p_argv1       LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
 
    WHENEVER ERROR CALL cl_err_msg_log
    #CALL s_padd_img_create() RETURNING l_img_table    #FUN-C70087 #FUN-CC0095
    #CALL s_padd_imgg_create() RETURNING l_imgg_table  #FUN-C70087 #FUN-CC0095
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)

    IF g_aza.aza115 ='Y' THEN                    #TQC-D20031
       CALL cl_set_comp_required('inb15',TRUE)   #TQC-D20031
    END IF
    #初始化界面的樣式(沒有任何默認屬性組)
    LET lg_smy62 = ''
    LET lg_group = ''   
    CALL t270_refresh_detail()   
    LET g_wc2=' 1=1'
    LET g_forupd_sql = "SELECT * FROM ina_file WHERE ina01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t270_cl CURSOR FROM g_forupd_sql
    LET g_argv1=p_argv1
    CALL t270_mu_ui()   #TQC-710032
    DISPLAY g_argv1 TO ina00
    IF g_argv1 MATCHES '[135]' THEN
       LET g_imd10='S'
    ELSE
       LET g_imd10='W'
    END IF
    IF fgl_getenv('EASYFLOW') = "1" THEN
          LET g_argv2 = aws_efapp_wsk(1)         #參數:key-1
    END IF
    #如果由表單追蹤區觸發程式, 此參數指定為何種資料匣
    #當為 EasyFlow 簽核時, 加入 EasyFlow 簽核 toolbar icon
    CALL aws_efapp_toolbar()   
    IF NOT cl_null(g_argv2) THEN
       CASE g_argv3
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t270_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL t270_a()
             END IF
          OTHERWISE
             CALL t270_q()
       END CASE
    END IF
    #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
    CALL aws_efapp_flowaction("insert, modify, delete, reproduce,
         detail, query,locale, void,undo_void,confirm, undo_confirm,      #FUN-D20039 add undo_void
         easyflow_approval,stock_post,undo_post")
          RETURNING g_laststage
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
    CALL t270_menu()
    #CALL s_padd_img_drop(l_img_table)   #FUN-C70087 #FUN-CC0095
    #CALL s_padd_imgg_drop(l_imgg_table) #FUN-C70087 #FUN-CC0095
END FUNCTION
 
 
FUNCTION t270_cs()
 DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01   #No.FUN-580031
 DEFINE
    l_type          LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(01)
    l_ima08         LIKE ima_file.ima08
IF NOT cl_null(g_argv2) THEN
   LET g_wc ="ina01 = '",g_argv2,"'"
   LET g_wc2 = '1=1'
ELSE
    CLEAR FORM                                   #清除畫面
    CALL g_inb.clear()   
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031 
   INITIALIZE g_ina.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    #螢幕上取單頭條件
        ina1025,ina01,ina1017,ina03,ina02,ina1013,ina1014,ina1019,ina1018,ina11,ina1001,#FUN-630046 
        ina1003,ina1004,ina1009,ina1010,ina1011,ina1012,ina04,ina06,#No.TQC-640124  
        ina1023,ina1024,ina07,ina1005,ina1015,ina1016,inaconf,
#        inapost,inamksg,ina08,ina1022,ina1021,inauser,inagrup,inamodu,inadate    #FUN-B30029 mark
        inapost,ina1022,ina1021,inauser,inagrup,inamodu,inadate                   #FUN-B30029
        BEFORE CONSTRUCt
            CALL cl_qbe_init()                     #No.FUN-580031
        ON ACTION controlp
            CASE WHEN INFIELD(ina01)             #查詢單據                      
                      CALL cl_init_qry_var()
                      LET g_qryparam.state= "c"
 	              LET g_qryparam.form = "q_ina"
                      LET g_qryparam.arg1 = g_argv1        #單據類別
 	              CALL cl_create_qry() RETURNING g_qryparam.multiret
 	              DISPLAY g_qryparam.multiret TO ina01
 	              NEXT FIELD ina01               
                 WHEN INFIELD(ina11) #申請人                                                                                        
                      CALL cl_init_qry_var()                                                                                        
                      LET g_qryparam.form = "q_gen"                                                                                 
                      LET g_qryparam.state = 'c'                                                                                    
                      CALL cl_create_qry() RETURNING g_qryparam.multiret                                                            
                      DISPLAY g_qryparam.multiret TO ina11                                                                          
                      NEXT FIELD ina11                                                                                              
                 WHEN INFIELD(ina04)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_gem"
                      LET g_qryparam.state = "c"
                      LET g_qryparam.default1 = g_ina.ina04
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO ina04  
                      NEXT FIELD ina04                
                 WHEN INFIELD(ina06)             #專案代號 
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_pja2"  #FUN-810045
                      LET g_qryparam.default1 =  g_ina.ina06
                      LET g_qryparam.state = "c"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO ina06               
                      NEXT FIELD ina06
                 WHEN INFIELD(ina1001)                                                                                              
                      CALL cl_init_qry_var()                                                                                        
                      LET g_qryparam.state = "c"                                                                                    
                      LET g_qryparam.form ="q_occ3"                                                                                 
                      CALL cl_create_qry() RETURNING g_qryparam.multiret                                                            
                      DISPLAY g_qryparam.multiret TO ina1001                                                                        
                      NEXT FIELD ina1001 
                 WHEN INFIELD(ina1003)                                                                                              
                      CALL cl_init_qry_var()                                                                                        
                      LET g_qryparam.state = "c"                                                                                    
                      LET g_qryparam.form ="q_occ4"                                                                                 
                      CALL cl_create_qry() RETURNING g_qryparam.multiret                                                            
                      DISPLAY g_qryparam.multiret TO ina1003                                                                        
                      NEXT FIELD ina1003
                 WHEN INFIELD(ina1004)                                                                                              
                      CALL cl_init_qry_var()                                                                                        
                      LET g_qryparam.state = "c"                                                                                    
                      LET g_qryparam.form ="q_occ6" #No.TQC-640124  
                      CALL cl_create_qry() RETURNING g_qryparam.multiret                                                            
                      DISPLAY g_qryparam.multiret TO ina1004                                                                        
                      NEXT FIELD ina1004  
                 WHEN INFIELD(ina1009)                                                                                              
                      CALL cl_init_qry_var()                                                                                        
                      LET g_qryparam.state = "c"                                                                                    
                      LET g_qryparam.form ="q_tqa1"                     
                      LET g_qryparam.arg1='20'                                                                                                       
                      CALL cl_create_qry() RETURNING g_qryparam.multiret                                                            
                      DISPLAY g_qryparam.multiret TO ina1009                                                                        
                      NEXT FIELD ina1009     
                 WHEN INFIELD(ina1010)                                                                                              
                      CALL cl_init_qry_var()                                                                                        
                      LET g_qryparam.state = "c"                                                                                    
                      LET g_qryparam.form ="q_tqb"                                                                                                                                          
                      CALL cl_create_qry() RETURNING g_qryparam.multiret                                                            
                      DISPLAY g_qryparam.multiret TO ina1010                                                                        
                      NEXT FIELD ina1010  
                 WHEN INFIELD(ina1011)                                                                                              
                      CALL cl_init_qry_var()                                                                                        
                      LET g_qryparam.state = "c"                                                                                    
                      LET g_qryparam.form ="q_tqb"                                                                                                                                          
                      CALL cl_create_qry() RETURNING g_qryparam.multiret                                                            
                      DISPLAY g_qryparam.multiret TO ina1011                                                                        
                      NEXT FIELD ina1011     
                 WHEN INFIELD(ina1012)                                                                                              
                      CALL cl_init_qry_var()                                                                                        
                      LET g_qryparam.state = "c"                                                                                    
                      LET g_qryparam.form ="q_tqa1" 
                      LET g_qryparam.arg1='19'                                                                                                                                          
                      CALL cl_create_qry() RETURNING g_qryparam.multiret                                                            
                      DISPLAY g_qryparam.multiret TO ina1012                                                                        
                      NEXT FIELD ina1012   
                 WHEN INFIELD(ina1005)                                                                                              
                      CALL cl_init_qry_var()                                                                                        
                      LET g_qryparam.state = "c"                                                                                    
                      LET g_qryparam.form ="q_ocd1"                                                                                                                                                            
                      CALL cl_create_qry() RETURNING g_qryparam.multiret                                                            
                      DISPLAY g_qryparam.multiret TO ina1005                                                                        
                      NEXT FIELD ina1005                                    
                 WHEN INFIELD(ina1023)                                                                                              
                      CALL cl_init_qry_var()                                                                                        
                      LET g_qryparam.state = "c"                                                                                    
                      LET g_qryparam.form ="q_azi"                                                                                                                                                            
                      CALL cl_create_qry() RETURNING g_qryparam.multiret                                                            
                      DISPLAY g_qryparam.multiret TO ina1023                                                                        
                      NEXT FIELD ina1023                                
            END CASE
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
        ON ACTION about        
           CALL cl_about()      
        ON ACTION help          
           CALL cl_show_help()   
        ON ACTION controlg     
           CALL cl_cmdask()     
        ON ACTION qbe_select          
            CALL cl_qbe_list() RETURNING lc_qbe_sn          
            CALL cl_qbe_display_condition(lc_qbe_sn)       
     END CONSTRUCT
     IF INT_FLAG THEN RETURN END IF
     #資料權限的檢查
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('inauser', 'inagrup')
     IF NOT cl_null(g_argv1) THEN
        LET g_wc = g_wc clipped," AND ina00 = '",g_argv1,"'"
     END IF
     CONSTRUCT g_wc2 ON inb03,inb04,inb05,inb06,inb07,inb08,inb09,   
                        inb905,inb907,inb902,inb904,
                        inb1004,inb1005,inb1002,inb1001,inb1003,inb1006,
                        inb11,inb12,inb901,inb10,inb15    #TQC-D20031 move inb15 
          FROM s_inb[1].inb03,  s_inb[1].inb04, s_inb[1].inb05,       
               s_inb[1].inb06,  s_inb[1].inb07,  s_inb[1].inb08,      
               s_inb[1].inb09,  s_inb[1].inb905, s_inb[1].inb907,
               s_inb[1].inb902, s_inb[1].inb904, s_inb[1].inb1004,              
               s_inb[1].inb1005,s_inb[1].inb1002,s_inb[1].inb1001,
               s_inb[1].inb1003,s_inb[1].inb1006,
               s_inb[1].inb11,  s_inb[1].inb12, s_inb[1].inb901,
               s_inb[1].inb10,  s_inb[1].inb15            #TQC-D20031 move inb15
       BEFORE CONSTRUCT            
           CALL cl_qbe_display_condition(lc_qbe_sn)       
       ON ACTION controlp
           CASE WHEN INFIELD(inb04)
#FUN-AA0059---------mod------------str-----------------
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form ="q_ima01"
#                    LET g_qryparam.default1 = g_inb[1].inb04
#                    LET g_qryparam.state = "c"
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima(TRUE, "q_ima01","",g_inb[1].inb04,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                     DISPLAY g_qryparam.multiret TO inb04
                     NEXT FIELD inb04
                WHEN INFIELD(inb05)
                      CALL q_imd_1(TRUE,TRUE,g_inb[1].inb05,"","","","") RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO inb05  
                      NEXT FIELD inb05
                WHEN INFIELD(inb06)
                      CALL q_ime_1(TRUE,TRUE,g_inb[1].inb06,g_inb[1].inb05,"","","","","") RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO inb06 
                      NEXT FIELD inb06 
                WHEN INFIELD(inb08)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_inb[1].inb08
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO inb08
                     NEXT FIELD inb08
                WHEN INFIELD(inb905)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_inb[1].inb905
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO inb905
                     NEXT FIELD inb905
                WHEN INFIELD(inb902)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_inb[1].inb902
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO inb902
                     NEXT FIELD inb902            
                WHEN INFIELD(inb15)                   
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_azf01"     #No.FUN-6B0065
                     LET g_qryparam.default1 = g_inb[1].inb15
                     LET g_qryparam.where = " azf02 = '2' "   #TQC-C50038 add
                     LET g_qryparam.arg1 = "4"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret                   
                     DISPLAY g_qryparam.multiret TO inb15
                     NEXT FIELD inb15
                WHEN INFIELD(inb1002)                   
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_tqx2"
                     LET g_qryparam.default1 = g_inb[1].inb1002
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret                   
                     DISPLAY g_qryparam.multiret TO inb1002
                     NEXT FIELD inb1002      
                WHEN INFIELD(inb1004)                   
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_inb[1].inb1004
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret                   
                     DISPLAY g_qryparam.multiret TO inb1004
                     NEXT FIELD inb1004      
                WHEN INFIELD(inb901)
                     SELECT ima08 INTO l_ima08 FROM ima_file
                      WHERE ima01 = g_inb[1].inb04
                     IF STATUS THEN
                        LET l_ima08 = ''
                     END IF
                     IF l_ima08 = 'M' THEN LET l_type = '0' END IF
                     IF l_ima08 = 'P' THEN LET l_type = '1' END IF
                     CALL q_coc2(TRUE,TRUE,g_inb[1].inb901,'',g_ina.ina02,l_type,
                                 '',g_inb[1].inb04)
                                 RETURNING g_inb[1].inb901
                     DISPLAY BY NAME g_inb[1].inb901
                     NEXT FIELD inb901               
           END CASE
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
        ON ACTION about        
           CALL cl_about()     
        ON ACTION help          
           CALL cl_show_help()  
        ON ACTION controlg     
           CALL cl_cmdask()    
        ON ACTION qbe_save          
            CALL cl_qbe_save()       
     END CONSTRUCT
END IF  
     IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
     IF g_wc2 = " 1=1" THEN			 # 若單身未輸入條件
        LET g_sql = "SELECT ina01 FROM ina_file",
                    " WHERE ", g_wc CLIPPED,
                    " ORDER BY ina01"
     ELSE					 # 若單身有輸入條件
        LET g_sql = "SELECT UNIQUE ina_file.ina01 ",
                    "  FROM ina_file, inb_file",
                    " WHERE ina01 = inb01",
                    "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                    " ORDER BY ina01"
     END IF
     PREPARE t270_prepare FROM g_sql
     DECLARE t270_cs                             #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t270_prepare
     IF g_wc2 = " 1=1" THEN			 # 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM ina_file WHERE ",g_wc CLIPPED
     ELSE
        LET g_sql="SELECT COUNT(DISTINCT ina01) FROM ina_file,inb_file WHERE ",
                  "inb01=ina01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
     END IF
     PREPARE t270_precount FROM g_sql
     DECLARE t270_count CURSOR FOR t270_precount
END FUNCTION
FUNCTION t270_menu()
DEFINE l_creator         LIKE type_file.chr1             #No.FUN-680120 VARCHAR(01)
DEFINe l_flowuser        LIKE type_file.chr1             #No.FUN-680120 VARCHAR(01)                  # 是否有指定加簽人員      
   LET l_flowuser = "N"
   WHILE TRUE
      CALL t270_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t270_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t270_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t270_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t270_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t270_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t270_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "confirm"
            IF cl_chk_act_auth() THEN                                                                                                  
               CALL t270_confirm()                                                                                                  
            END IF                       
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN                                                                                                  
               CALL t270_undo_confirm()                                                                                                  
            END IF                       
         WHEN "stock_post"                       #庫存過帳
            IF cl_chk_act_auth() THEN
               CALL t270_s()
               IF g_ina.inapost = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               IF g_ina.ina08 = '1' THEN
                  LET g_chr2='Y'
               ELSE
                  LET g_chr2='N'
               END IF
               CALL cl_set_field_pic("",g_chr2,g_ina.inapost,"",g_void,"")            
            END IF
         WHEN "undo_post"                        #過帳還原
            IF cl_chk_act_auth() THEN              
               IF g_ina.inapost = 'Y' THEN       
                  LET g_msg="aimp379 '",g_ina.ina01,"'"
                  CALL cl_cmdrun_wait(g_msg)
                  SELECT ina08,inapost INTO g_ina.ina08,g_ina.inapost FROM ina_file
                  WHERE ina01=g_ina.ina01
          #        DISPLAY BY NAME g_ina.ina08,g_ina.inapost          #FUN-B30029  mark
                  DISPLAY BY NAME g_ina.inapost                        #FUN-B30029
                  IF g_ina.inapost = 'X' THEN
                     LET g_void = 'Y'
                  ELSE
                     LET g_void = 'N'
                  END IF
                  IF g_ina.ina08 = '1' THEN
                     LET g_chr2='Y'
                  ELSE
                     LET g_chr2='N'
                  END IF
                  CALL cl_set_field_pic("",g_chr2,g_ina.inapost,"",g_void,"")
               ELSE
                  IF g_ina.inapost = 'X' THEN    #作廢!
                     CALL cl_err(g_ina.ina01,9024,0)
                  END IF
                  IF g_ina.inapost = 'N' THEN    #未過帳資料不可過帳還原!
                     CALL cl_err(g_ina.ina01,'afa-108',1)
                  END IF
               END IF             
            END IF
         WHEN "void"                             #作廢
            IF cl_chk_act_auth() THEN
               CALL t270_x(1)
               IF g_ina.inapost = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               IF g_ina.ina08 = '1' THEN
                  LET g_chr2='Y'
               ELSE
                  LET g_chr2='N'
               END IF
               CALL cl_set_field_pic("",g_chr2,g_ina.inapost,"",g_void,"")
            END IF
         #FUN-D20039 ------------sta
         WHEN "undo_void"                             
            IF cl_chk_act_auth() THEN
               CALL t270_x(2)
               IF g_ina.inapost = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               IF g_ina.ina08 = '1' THEN
                  LET g_chr2='Y'
               ELSE
                  LET g_chr2='N'
               END IF
               CALL cl_set_field_pic("",g_chr2,g_ina.inapost,"",g_void,"")
            END IF
         #FUN-D20039 ------------end
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_inb),'','')
            END IF
         WHEN "easyflow_approval"      #EasyFlow送簽
            IF cl_chk_act_auth() THEN
               CALL t270_ef()
            END IF
            IF g_ina.inapost = 'X' THEN
               LET g_void = 'Y'
            ELSE
               LET g_void = 'N'
            END IF
            IF g_ina.ina08 = '1' THEN
                LET g_chr2='Y'
            ELSE
                LET g_chr2='N'
            END IF
            CALL cl_set_field_pic("",g_chr2,g_ina.inapost,"",g_void,"")
         WHEN "approval_status"                  #簽核狀況
            IF cl_chk_act_auth() THEN            #DISPLAY ONLY
               IF aws_condition2() THEN                 
                   CALL aws_efstat2()                  
               END IF
            END IF
         WHEN "agree"                            #准
           IF g_laststage = "Y" AND l_flowuser = 'N' THEN  #最后一關
              CALL t270_y_upd()                  #CALL 原確認的 update 段
           ELSE
              LET g_success = "Y"
              IF NOT aws_efapp_formapproval() THEN
                 LET g_success = "N"
              END IF
           END IF
           IF g_success = 'Y' THEN
              IF cl_confirm('aws-081') THEN
                 IF aws_efapp_getnextforminfo() THEN
                    LET l_flowuser = 'N'
                    LET g_argv2 = aws_efapp_wsk(1)         #參數:key-1
                    IF NOT cl_null(g_argv2) THEN
                       CALL t270_q()
                       #設定簽核功能及哪些 action 在簽核狀態時是不可被
                       CALL aws_efapp_flowaction("insert, modify, 
                            delete, reproduce, detail, query, locale,
                            void,undo_void,confirm, undo_confirm,easyflow_approval")   #FUN-D20039 add undo_void
                       RETURNING g_laststage
                    ELSE
                       EXIT WHILE
                    END IF
                 ELSE
                    EXIT WHILE
                 END IF
              ELSE
                 EXIT WHILE
              END IF
           END IF
         WHEN "deny"                             #不准
            IF (l_creator := aws_efapp_backflow()) IS NOT NULL THEN
               IF aws_efapp_formapproval() THEN
                  IF l_creator = "Y" THEN
                     LET g_ina.ina08 = 'R'
      #               DISPLAY BY NAME g_ina.ina08                #FUN-B30029  mark
                  END IF
                  IF cl_confirm('aws-081') THEN
                     IF aws_efapp_getnextforminfo() THEN
                        LET l_flowuser = 'N'
                        LET g_argv2 = aws_efapp_wsk(1)   #參數:key-1
                        IF NOT cl_null(g_argv2) THEN
                           CALL t270_q()
                           #設定簽核功能及哪些 action 在簽核狀態時是不可被
                           CALL aws_efapp_flowaction("insert, modify,
                                delete,reproduce, detail, query, locale,void,undo_void,  #FUN-D20039 add undo_void
                                confirm, undo_confirm,easyflow_approval")
                           RETURNING g_laststage
                        ELSE
                          EXIT WHILE
                        END IF
                     ELSE
                        EXIT WHILE
                     END IF
                  ELSE
                     EXIT WHILE
                  END IF
               END IF
            END IF
         WHEN "modify_flow"                      #加簽
            IF aws_efapp_flowuser() THEN         #選擇欲加簽人員
               LET l_flowuser = 'Y'
            ELSE
               LET l_flowuser = 'N'
            END IF
         WHEN "withdraw"                         #撤簽
            IF cl_confirm("aws-080") THEN
               IF aws_efapp_formapproval() THEN
                  EXIT WHILE
               END IF
            END IF
         WHEN "org_withdraw"                     #抽單
              IF cl_confirm("aws-079") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF
         WHEN "phrase"                           #簽核意見
            CALL aws_efapp_phrase()
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_ina.ina01 IS NOT NULL THEN
                 LET g_doc.column1 = "ina01"
                 LET g_doc.value1 = g_ina.ina01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
END FUNCTION
FUNCTION t270_a()
DEFINE li_result LIKE type_file.num5                     #No.FUN-680120 SMALLINT
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_inb.clear()
    INITIALIZE g_ina.* TO NULL
    LET g_ina_t.* = g_ina.*   #FUN-B50026 add
    LET g_ina_o.* = g_ina.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_ina.ina00   = g_argv1
        LET g_ina.ina02   = g_today
        LET g_ina.ina03   = g_today
        LET g_ina.ina04   = g_grup  
        LET g_ina.inapost = 'N'
        LET g_ina.inauser = g_user
        LET g_ina.inaoriu = g_user #FUN-980030
        LET g_ina.inaorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_ina.inagrup = g_grup
        LET g_ina.inadate = g_today
        LET g_ina.ina08   = '0'                  #開立  
        LET g_ina.inamksg = 'N'                  #簽核否
        LET g_ina.ina1025 = '1'
        LET g_ina.ina1022 = '0'
        LET g_ina.inaconf = 'N'
        LET g_ina.ina11=g_user                                                                                                      
        CALL t270_ina11('d')                                                                                                        
        IF NOT cl_null(g_errno) THEN                                                                                                
          LET g_ina.ina11 = ''                                                                                                      
        END IF                                                                                                                      
        CALL t270_i("a")                         #輸入單頭
        IF INT_FLAG THEN
           INITIALIZE g_ina.* TO NULL
           LET INT_FLAG=0
           CALL cl_err('',9001,0)
           ROLLBACK WORK
           EXIT WHILE
        END IF
        IF g_ina.ina01 IS NULL THEN CONTINUE WHILE END IF
        BEGIN WORK  
        CALL s_auto_assign_no("aim",g_ina.ina01,g_ina.ina03,g_chr,"ina_file","ina01","","","")
          RETURNING li_result,g_ina.ina01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_ina.ina01
 #FUN-B30029 -----------mark
 #      IF cl_null(g_ina.inamksg) THEN
 #         LET  g_ina.inamksg = g_smy.smyapr
 #      END IF
 #      IF cl_null(g_ina.inamksg) THEN
 #         LET  g_ina.inamksg = 'N'
 #      END IF
 #FUN-B30029 -----------mark
        LET g_ina.inalegal = g_legal #FUN-980009
        LET g_ina.inaplant = g_plant #FUN-980009
        LET g_ina.ina12    = 'N'     #FUN-870100   
        LET g_ina.inapos   = 'N'     #FUN-870100    
        INSERT INTO ina_file VALUES (g_ina.*)
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("ins","ina_file",g_ina.ina01,"",SQLCA.sqlcode,"","ins ina: ",1)  #No.FUN-660104    #FUN-B80061    ADD
           ROLLBACK WORK 
          # CALL cl_err3("ins","ina_file",g_ina.ina01,"",SQLCA.sqlcode,"","ins ina: ",1)  #No.FUN-660104   #FUN-B80061    MARK 
           CONTINUE WHILE
        ELSE
           COMMIT WORK 
           CALL cl_flow_notify(g_ina.ina01,'I')
        END IF
        SELECT ina01 INTO g_ina.ina01 FROM ina_file WHERE ina01 = g_ina.ina01
        LET g_ina_t.* = g_ina.*
        CALL g_inb.clear()
        LET g_rec_b = 0
        CALL t270_b()                            #輸入單身
        SELECT COUNT(*) INTO g_cnt FROM inb_file WHERE inb01=g_ina.ina01
        IF g_cnt>0 THEN
           IF g_smy.smyprint='Y' THEN
              IF cl_confirm('mfg9392') THEN CALL t270_out() END IF
           END IF
           IF g_smy.smydmy4='Y' THEN CALL t270_s() END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
FUNCTION t270_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_ina.ina01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_ina.* FROM ina_file WHERE ina01=g_ina.ina01
    IF g_ina.inapost = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_ina.inapost = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
    IF g_ina.inaconf = 'Y' THEN CALL cl_err('',9022,0) RETURN END IF
    IF g_ina.ina08 matches '[Ss]' THEN         
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
    LET g_ina_t.* = g_ina.*   #FUN-B50026 add
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ina_o.* = g_ina.*
    BEGIN WORK
    OPEN t270_cl USING g_ina.ina01
    IF STATUS THEN
       CALL cl_err("OPEN t270_cl:", STATUS, 1)
       CLOSE t270_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t270_cl INTO g_ina.*                   # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ina.ina01,SQLCA.sqlcode,0) # 資料被他人LOCK
        CLOSE t270_cl ROLLBACK WORK RETURN
    END IF
    CALL t270_show()
    WHILE TRUE
        LET g_ina.inamodu=g_user
        LET g_ina.inadate=g_today
        CALL t270_i("u")                         # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ina.*=g_ina_t.*
            CALL t270_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        LET g_ina.ina08 = '0'        
        UPDATE ina_file SET ina_file.* = g_ina.* WHERE ina01 = g_ina_o.ina01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("upd","ina_file",g_ina.ina01,"",SQLCA.sqlcode,"","upd ina: ",1)  #No.FUN-660104
           CONTINUE WHILE
        END IF
        IF g_ina.ina01 != g_ina_t.ina01 THEN CALL t270_chkkey() END IF
        EXIT WHILE
    END WHILE
    CLOSE t270_cl
#    DISPLAY BY NAME g_ina.ina08                               #FUN-B30029 mark
    IF g_ina.inapost = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF
    IF g_ina.ina08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF 
    CALL cl_set_field_pic("",g_chr2,g_ina.inapost,"",g_void,"") 
    COMMIT WORK
    CALL cl_flow_notify(g_ina.ina01,'U')
END FUNCTION
FUNCTION t270_chkkey()
   UPDATE inb_file SET inb01=g_ina.ina01
    WHERE inb01=g_ina_t.ina01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","inb_file",g_ina_t.ina01,"",SQLCA.sqlcode,"","upd inb01: ",1)  #No.FUN-660104
      LET g_ina.*=g_ina_t.*
      CALL t270_show()
      ROLLBACK WORK
      RETURN
   END IF
END FUNCTION
FUNCTION t270_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1                   #a:輸入 u:更改            #No.FUN-680120 VARCHAR(1)
  DEFINE l_flag          LIKE type_file.chr1                   #判斷必要欄位是否有輸入   #No.FUN-680120 VARCHAR(1)
  DEFINE l_n             LIKE type_file.num5                   #No.FUN-680120 SMALLINT
  DEFINE li_result       LIKE type_file.num5                   #No.FUN-680120 SMALLINT
  DEFINE l_oaz52         LIKE oaz_file.oaz52
    DISPLAY BY NAME g_ina.ina00,g_ina.inaconf,g_ina.ina1022
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME g_ina.inaoriu,g_ina.inaorig,
             g_ina.ina1025,
             g_ina.ina01,g_ina.ina1017,g_ina.ina03,g_ina.ina02,g_ina.ina1013,
             g_ina.ina1014,g_ina.ina1019,g_ina.ina1018,g_ina.ina11,g_ina.ina1001, #No.FUN-630046 
             g_ina.ina1003,g_ina.ina1004,  #No.TQC-640124  
             g_ina.ina1009,g_ina.ina1010,g_ina.ina1011,g_ina.ina1012,g_ina.ina04,
             g_ina.ina06,g_ina.ina1023,g_ina.ina07,g_ina.ina1005,
#FUN-B30029 --------------STA
#            g_ina.inapost,g_ina.inamksg,
#            g_ina.ina08,g_ina.inauser, 
             g_ina.inapost,g_ina.inauser,
#FUN-B30029 --------------END
             g_ina.inagrup,g_ina.inamodu,g_ina.inadate
             WITHOUT DEFAULTS
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t270_set_entry(p_cmd)
            CALL t270_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_set_docno_format("ina01")   
        AFTER FIELD ina11                                                                                                           
            IF NOT cl_null(g_ina.ina11) THEN                                                                                        
               CALL t270_ina11('a')                                                                                                 
               IF NOT cl_null(g_errno) THEN                                                                                         
                  LET g_ina.ina11 = g_ina_t.ina11                                                                                   
                  CALL cl_err(g_ina.ina11,g_errno,0)                                                                                
                  DISPLAY BY NAME g_ina.ina11 #                                                                                     
                  NEXT FIELD ina11                                                                                                  
               END IF        
               #TQC-D20031---add---str
               IF NOT t270_inb15_chk2() THEN
                  LET g_ina.ina11 = g_ina_t.ina11
                  NEXT FIELD ina11
               END IF 
               #TQC-D20031---add---end
            ELSE                                                                                                                    
               DISPLAY '' TO FORMONLY.gen02                                                                                         
            END IF                                                                                                                  
        AFTER FIELD ina1025
            IF g_ina.ina1025='3' THEN
               CALL cl_set_comp_visible("ina1017,ina1013,ina1014,ina1019,ina1018,
                                 ina1001,ina1003,ina1004,ina1009,ina1010,
                                 ina1011,ina1012,occ02a,occ02b,occ02d, 
                                 tqa02a,tqb02a,tqb02b,tqa02b,ina1023,ina1024,
                                 ina1005,ina1006,ina1007,ina1008,ina1015,ina1016,
                                 inaconf,ina1022,ina1021,ima1002,ima135,inb1004,
                                 inb1005,inb1002,inb1001,inb1003,inb1006",FALSE)
            ELSE 
               CALL cl_set_comp_visible("ina1017,ina1013,ina1014,ina1019,ina1018,
                                 ina1001,ina1003,ina1004,ina1009,ina1010,
                                 ina1011,ina1012,occ02a,occ02b,occ02d, 
                                 tqa02a,tqb02a,tqb02b,tqa02b,ina1023,ina1024,
                                 ina1005,ina1006,ina1007,ina1008,ina1015,ina1016,
                                 inaconf,ima1002,ima135,inb1004, #No.TQC-640124
                                 inb1005,inb1002,inb1001,inb1003,inb1006",TRUE)                                 
               IF g_sma.sma116='2' OR g_sma.sma116='3' THEN
                  CALL cl_set_comp_visible("inb1004,inb1005",TRUE)
               ELSE 
                  CALL cl_set_comp_visible("inb1004,inb1005",FALSE)
               END IF  
            END IF
        AFTER FIELD ina01
            IF NOT cl_null(g_ina.ina01) THEN
               LET g_t1=s_get_doc_no(g_ina.ina01)
               #得到該單別對應的屬性群組
               IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' ) THEN
                  #讀取smy_file中指定作業對應的默認屬性群組
                  SELECT smy62 INTO lg_smy62 FROM smy_file WHERE smyslip = g_t1
                  #刷新界面顯示
                  CALL t270_refresh_detail()
               ELSE 
                  LET lg_smy62 = ''
               END IF         
               CASE WHEN g_ina.ina00 MATCHES "[12]" LET g_chr='1'
                    WHEN g_ina.ina00 MATCHES "[34]" LET g_chr='2'
                    WHEN g_ina.ina00 MATCHES "[56]" LET g_chr='3'
               END CASE
               CALL s_check_no("aim",g_ina.ina01,g_ina_t.ina01,g_chr,"ina_file","ina01","")
                 RETURNING li_result,g_ina.ina01
               DISPLAY BY NAME g_ina.ina01
               IF (NOT li_result) THEN
       	           NEXT FIELD ina01
               END IF
               DISPLAY BY NAME g_smy.smydesc
               LET  g_ina.inamksg = g_smy.smyapr
   #            DISPLAY BY NAME g_ina.inamksg     #簽核否              #FUN-B30029 mark
            ELSE
               IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
                  LET lg_smy62 = ''
                  CALL t270_refresh_detail()
               END IF
            END IF
        AFTER FIELD ina02
            IF NOT cl_null(g_ina.ina02) THEN
	       IF g_sma.sma53 IS NOT NULL AND g_ina.ina02 <= g_sma.sma53 THEN
	           CALL cl_err('','mfg9999',0) NEXT FIELD ina02
	       END IF
               CALL s_yp(g_ina.ina02) RETURNING g_yy,g_mm
               IF g_yy*12+g_mm > g_sma.sma51*12+g_sma.sma52 THEN #不可大于現行年月
                  CALL cl_err('','mfg6091',0) NEXT FIELD ina02
               END IF
            END IF
        AFTER FIELD ina1001
            IF NOT cl_null(g_ina.ina1001) THEN                                                                                                                                                                                                                
               IF cl_null(g_ina_o.ina1001) OR                                                                                            
                  (g_ina.ina1001 != g_ina_o.ina1001) THEN                                                                                 
                  SELECT count(*) INTO l_n FROM occ_file                                                                               
                   WHERE occ01 = g_ina.ina1001   
                     AND occacti = 'Y'                                             
                     AND occ06 = '1'                                               
                     AND occ1004 = '1'      #No.FUN-690025 mod
                  IF l_n = 0 THEN                                                                                                      
                     CALL cl_err('',100,0)                                                                                             
                     LET g_ina.ina1001 = g_ina_t.ina1001                                                                                       
                     DISPLAY BY NAME g_ina.ina1001                                                                                      
                     NEXT FIELD ina1001                                                                                                  
                  END IF                                                                                                               
                  CALL t270_ina1001(p_cmd)   
                  IF NOT cl_null(g_errno) THEN                                                                                         
                     CALL cl_err(g_ina.ina1001,g_errno,0)                                                                                
                     LET g_ina.ina1001 = g_ina_o.ina1001                                                                                   
                     DISPLAY BY NAME g_ina.ina1001                                                                                       
                     NEXT FIELD ina1001                                                                                                 
                  END IF    
               END IF                                                                                                               
            END IF
            IF NOT cl_null(g_ina.ina1003) THEN                                                                                      
               CALL t270_ina1003(p_cmd)                                                                                             
               IF NOT cl_null(g_errno) THEN                                                                                         
                  CALL cl_err(g_ina.ina1003,g_errno,0)                                                                              
                  LET g_ina.ina1003 = g_ina_o.ina1003                                                                               
                  DISPLAY BY NAME g_ina.ina1003                                                                                     
                  NEXT FIELD ina1003                                                                                                
               END IF                                                                                                               
            END IF                      
            IF NOT cl_null(g_ina.ina1004) THEN                                                                                      
               CALL t270_ina1004(p_cmd)                                                                                             
               IF NOT cl_null(g_errno) THEN                                                                                         
                  CALL cl_err(g_ina.ina1004,g_errno,0)                                                                              
                  LET g_ina.ina1004 = g_ina_o.ina1004                                                                               
                  DISPLAY BY NAME g_ina.ina1004                                                                                     
                  NEXT FIELD ina1004                                                                                                
               END IF                                                                                                               
            END IF                      
            IF NOT cl_null(g_ina.ina1010) THEN
               CALL t270_ina1010(p_cmd)                                                                                             
               IF NOT cl_null(g_errno) THEN                                                                                         
                  CALL cl_err(g_ina.ina1010,g_errno,0)                                                                              
                  LET g_ina.ina1010 = g_ina_o.ina1010                                                                               
                  DISPLAY BY NAME g_ina.ina1010                                                                                     
                  NEXT FIELD ina1010                                                                                                
               END IF                                                                                                               
            END IF               
            IF NOT cl_null(g_ina.ina1011) THEN                                                                                      
               CALL t270_ina1011(p_cmd)                                                                                             
               IF NOT cl_null(g_errno) THEN                                                                                         
                  CALL cl_err(g_ina.ina1011,g_errno,0)                                                                              
                  LET g_ina.ina1011 = g_ina_o.ina1011                                                                               
                  DISPLAY BY NAME g_ina.ina1011                                                                                     
                  NEXT FIELD ina1011                                                                                                
               END IF                                                                                                               
            END IF                      
            IF NOT cl_null(g_ina.ina1012) THEN                                                                                      
               CALL t270_ina1012(p_cmd)                                                                                             
               IF NOT cl_null(g_errno) THEN                                                                                         
                  CALL cl_err(g_ina.ina1012,g_errno,0)                                                                              
                  LET g_ina.ina1012 = g_ina_o.ina1012                                                                               
                  DISPLAY BY NAME g_ina.ina1012                                                                                     
                  NEXT FIELD ina1012                                                                                                
               END IF                                                                                                               
            END IF                      
            IF NOT cl_null(g_ina.ina1005) THEN                                                                                      
               CALL t270_ina1005(p_cmd)                                                                                             
               IF NOT cl_null(g_errno) THEN                                                                                         
                  CALL cl_err(g_ina.ina1005,g_errno,0)                                                                              
                  LET g_ina.ina1005 = g_ina_o.ina1005                                                                               
                  DISPLAY BY NAME g_ina.ina1005                                                                                     
                  NEXT FIELD ina1005                                                                                                
               END IF                                                                                                               
            END IF                      
        AFTER FIELD ina1003
            IF NOT cl_null(g_ina.ina1003) THEN                                                                                                                                                                                                                
               IF cl_null(g_ina_o.ina1003) OR                                                                                            
                  (g_ina.ina1003 != g_ina_o.ina1003) THEN                                                                                 
                  SELECT count(*) INTO l_n FROM occ_file                                                                               
                   WHERE occ01 = g_ina.ina1003   
                     AND occ1004 = '1'      #No.FUN-690025 mod
                     AND occacti = 'Y' 
                     AND (occ06 = '1' or  occ06 = '2')
                  IF l_n = 0 THEN                                                                                                      
                     CALL cl_err('',100,0)                                                                                             
                     LET g_ina.ina1003 = g_ina_t.ina1003                                                                                       
                     DISPLAY BY NAME g_ina.ina1003                                                                                      
                     NEXT FIELD ina1003                                                                                                  
                  END IF                                                                                                               
               END IF                                                                                                               
               CALL t270_ina1003(p_cmd)   
               IF NOT cl_null(g_errno) THEN                                                                                         
                  CALL cl_err(g_ina.ina1003,g_errno,0)                                                                                
                  LET g_ina.ina1003 = g_ina_o.ina1003                                                                                   
                  DISPLAY BY NAME g_ina.ina1003                                                                                       
                  NEXT FIELD ina1003                                                                                                 
               END IF   
            END IF   
        AFTER FIELD ina1004
            IF NOT cl_null(g_ina.ina1004) THEN                                                                                                                                                                                                                
               IF cl_null(g_ina_o.ina1004) OR                                                                                            
                     (g_ina.ina1004 != g_ina_o.ina1004) THEN                                                                                 
                  SELECT count(*) INTO l_n FROM occ_file                                                                               
                   WHERE occ01 = g_ina.ina1004   
                     AND occ1004 = '1'      #No.FUN-690025 mod
                     AND occacti = 'Y'   
                     AND (occ06 = '1' or occ06 = '3' ) #No.TQC-640124  
                  IF l_n = 0 THEN                                                                                                      
                     CALL cl_err('',100,0)                                                                                             
                     LET g_ina.ina1004 = g_ina_t.ina1004                                                                                       
                     DISPLAY BY NAME g_ina.ina1004                                                                                      
                     NEXT FIELD ina1004                                                                                                  
                  END IF                                                                                                               
               END IF                                                                                                               
               CALL t270_ina1004(p_cmd)   
               IF NOT cl_null(g_errno) THEN                                                                                         
                  CALL cl_err(g_ina.ina1004,g_errno,0)                                                                                
                  LET g_ina.ina1004 = g_ina_o.ina1004                                                                                   
                  DISPLAY BY NAME g_ina.ina1004                                                                                       
                  NEXT FIELD ina1004                                                                                                 
               END IF                                   
            END IF                                   
        AFTER FIELD ina1009
            IF NOT cl_null(g_ina.ina1009) THEN                                                                                                                                                                                                                
               IF cl_null(g_ina_o.ina1009) OR                                                                                            
                  (g_ina.ina1009 != g_ina_o.ina1009) THEN                                                                                 
                  SELECT count(*) INTO l_n FROM tqa_file                                                                               
                   WHERE tqa01 = g_ina.ina1009   
                     AND tqa03= '20'
                     AND tqaacti='Y'                                                                                                     IF l_n = 0 THEN                                                                                                      
                     CALL cl_err('',100,0)                                                                                             
                     LET g_ina.ina1009 = g_ina_t.ina1009                                                                                       
                     DISPLAY BY NAME g_ina.ina1009                                                                                      
                     NEXT FIELD ina1009                                                                                                  
                  END IF                                                                                                               
               END IF                                                                                                               
               CALL t270_ina1009(p_cmd)                                                                                               
               IF NOT cl_null(g_errno) THEN                                                                                         
                  CALL cl_err(g_ina.ina1009,g_errno,0)                                                                                
                  LET g_ina.ina1009 = g_ina_o.ina1009                                                                                   
                  DISPLAY BY NAME g_ina.ina1009                                                                                       
                  NEXT FIELD ina1009                                                                                                 
               END IF   
            END IF   
        AFTER FIELD ina1011
            IF NOT cl_null(g_ina.ina1011) THEN                                                                                                                                                                                                                
               IF cl_null(g_ina_o.ina1011) OR                                                                                            
                  (g_ina.ina1011 != g_ina_o.ina1011) THEN                                                                                 
                  SELECT count(*) INTO l_n FROM tqb_file                                                                               
                   WHERE tqb01 = g_ina.ina1011   
                     AND tqbacti = 'Y'                                                                                         
                  IF l_n = 0 THEN                                                                                                      
                     CALL cl_err('',100,0)                                                                                             
                     LET g_ina.ina1011 = g_ina_t.ina1011                                                                                       
                     DISPLAY BY NAME g_ina.ina1011                                                                                      
                     NEXT FIELD ina1011                                                                                                  
                  END IF                                                                                                               
               END IF                                                                                                               
               CALL t270_ina1011(p_cmd)   
               IF NOT cl_null(g_errno) THEN                                                                                         
                  CALL cl_err(g_ina.ina1011,g_errno,0)                                                                                
                  LET g_ina.ina1011 = g_ina_o.ina1011                                                                                   
                  DISPLAY BY NAME g_ina.ina1011                                                                                       
                  NEXT FIELD ina1011                                                                                                 
               END IF      
            END IF      
        AFTER FIELD ina1012
            IF NOT cl_null(g_ina.ina1012) THEN                                                                                                                                                                                                                
               IF cl_null(g_ina_o.ina1012) OR                                                                                            
                  (g_ina.ina1012 != g_ina_o.ina1012) THEN                                                                                 
                  SELECT count(*) INTO l_n FROM tqa_file                                                                               
                   WHERE tqa01 = g_ina.ina1012   
                     AND tqa03 = '19'                                                                                     
                  IF l_n = 0 THEN                                                                                                      
                     CALL cl_err('',100,0)                                                                                             
                     LET g_ina.ina1012 = g_ina_t.ina1012                                                                                       
                     DISPLAY BY NAME g_ina.ina1012                                                                                      
                     NEXT FIELD ina1012                                                                                                  
                  END IF                                                                                                               
               END IF                                                                                                               
               CALL t270_ina1012(p_cmd)   
               IF NOT cl_null(g_errno) THEN                                                                                         
                  CALL cl_err(g_ina.ina1012,g_errno,0)                                                                                
                  LET g_ina.ina1012 = g_ina_o.ina1012                                                                                   
                  DISPLAY BY NAME g_ina.ina1012                                                                                       
                  NEXT FIELD ina1012                                                                                                 
               END IF                                                     
            END IF                                                     
        AFTER FIELD ina04
            CASE
                WHEN g_ina.ina00 MATCHES "[12]"
                     LET g_chr='1'
                     IF cl_null(g_ina.ina04) AND g_sma.sma847[1,1] = 'Y' THEN
                        #參數設定(asms230)雜項發料要輸入部門,請輸入部門編號
                        CALL cl_err('','aim-330',0)
                        NEXT FIELD ina04
                     END IF
                WHEN g_ina.ina00 MATCHES "[34]"
                     LET g_chr='2'
                     IF cl_null(g_ina.ina04) AND g_sma.sma847[2,2] = 'Y' THEN
                        #參數設定(asms230)雜項收料要輸入部門,請輸入部門編號
                        CALL cl_err('','aim-331',0)
                        NEXT FIELD ina04
                     END IF
                WHEN g_ina.ina00 MATCHES "[56]"
                     LET g_chr='3'
                     #FUN-CC0074 add
                     IF cl_null(g_ina.ina04) AND g_sma.sma847[3,3] = 'Y' THEN
                        #參數設定(asms230)雜項報廢要輸入部門,請輸入部門編號
                        CALL cl_err('','aim-332',0)
                        NEXT FIELD ina04
                     END IF
                     #FUN-CC0074 add--end
                OTHERWISE EXIT CASE
            END CASE
            IF NOT cl_null(g_ina.ina04) THEN
               SELECT gem02 INTO g_buf FROM gem_file
                WHERE gem01=g_ina.ina04
                  AND gemacti='Y'  
               IF STATUS THEN
                  CALL cl_err3("sel","gem_file",g_ina.ina04,"",STATUS,"","select gem",1)  #No.FUN-660104
                  NEXT FIELD ina04
               END IF
               DISPLAY g_buf TO gem02
               #TQC-D20031---add---str
               IF NOT t270_inb15_chk2() THEN
                  LET g_ina.ina04 = g_ina_t.ina04
                  NEXT FIELD ina04
               END IF 
               #TQC-D20031---add---end
            END IF
        AFTER FIELD ina06
            IF NOT cl_null(g_ina.ina06) AND g_aza.aza08='Y' THEN
                SELECT COUNT(*) INTO l_n FROM pja_file
                 WHERE pja01=g_ina.ina06
                   AND pjaacti = 'Y'
                   AND pjaclose='N'     #FUN-960038
                IF l_n = 0  THEN                 #check 專案代號主檔
                    CALL cl_err(g_ina.ina06,'apj-004',0)
                    LET g_ina.ina06= g_ina_t.ina06
                    DISPLAY BY NAME g_ina.ina06
                    NEXT FIELD ina06
                END IF
            END IF
        AFTER FIELD ina1023
            IF NOT cl_null(g_ina.ina1023) THEN                                                                                      
               IF cl_null(g_ina_o.ina1023) OR                                                                                       
                  (g_ina.ina1023 != g_ina_o.ina1023) THEN                                                                           
                  SELECT count(*) INTO l_n FROM azi_file                                                                            
                   WHERE azi01 = g_ina.ina1023                                                                                      
                  IF l_n = 0 THEN                                                                                                   
                     CALL cl_err('',100,0)                                                                                          
                     LET g_ina.ina1023 = g_ina_t.ina1023                                                                            
                     DISPLAY BY NAME g_ina.ina1023                                                                                  
                     NEXT FIELD ina1023                                                                                             
                  END IF                                                                                                            
               END IF         
            END IF         
            IF g_ina.ina1025='1' THEN                  #內銷費用
               LET l_oaz52=g_oaz.oaz52
            ELSE
               IF g_ina.ina1025='2' THEN               #外銷費用
                  LET l_oaz52=g_oaz.oaz70
               END IF
            END IF
            CALL s_curr3(g_ina.ina1023,g_ina.ina01,l_oaz52) 
            RETURNING g_ina.ina1024
            DISPLAY BY NAME g_ina.ina1024                                                                                      
        AFTER FIELD ina1005
            IF NOT cl_null(g_ina.ina1005) THEN                                                                                                                                                                                                                
               IF cl_null(g_ina_o.ina1005) OR                                                                                            
                  (g_ina.ina1005 != g_ina_o.ina1005) THEN                                                                                 
                  SELECT count(*) INTO l_n FROM ocd_file                                                                               
                   WHERE ocd02 = g_ina.ina1005                                                                                   
                  IF l_n = 0 THEN                                                                                                      
                     CALL cl_err('',100,0)                                                                                             
                     LET g_ina.ina1005 = g_ina_t.ina1005                                                                                       
                     DISPLAY BY NAME g_ina.ina1005                                                                                      
                     NEXT FIELD ina1005                                                                                                  
                  END IF                                                                                                               
               END IF                                                                                                               
               CALL t270_ina1005(p_cmd)   
               IF NOT cl_null(g_errno) THEN                                                                                         
                  CALL cl_err(g_ina.ina1005,g_errno,0)                                                                                
                  LET g_ina.ina1005 = g_ina_o.ina1005                                                                                   
                  DISPLAY BY NAME g_ina.ina1005                                                                                       
                  NEXT FIELD ina1005                                                                                                 
               END IF                
            END IF                
        AFTER INPUT
           LET g_ina.inauser = s_get_data_owner("ina_file") #FUN-C10039
           LET g_ina.inagrup = s_get_data_group("ina_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
            LET l_flag = 'N'
            IF g_ina.ina00 MATCHES "[12]" AND
               cl_null(g_ina.ina04) AND g_sma.sma847[1,1] = 'Y' THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ina.ina04
                CALL cl_err('','aim-330',0)             
            END IF
            IF g_ina.ina00 MATCHES "[34]" AND
               cl_null(g_ina.ina04) AND g_sma.sma847[2,2] = 'Y' THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ina.ina04
               CALL cl_err('','aim-331',0)               
            END IF
            #FUN-CC0074 add
            IF g_ina.ina00 MATCHES "[56]" AND
               cl_null(g_ina.ina04) AND g_sma.sma847[3,3] = 'Y' THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ina.ina04
               CALL cl_err('','aim-332',0)
            END IF
            #FUN-CC0074 add--end
            IF l_flag='Y' THEN           
                NEXT FIELD ina04
            END IF
         ON ACTION controlp
            CASE WHEN INFIELD(ina01)             #查詢單據
                      LET g_t1=s_get_doc_no(g_ina.ina01)  
                      CASE WHEN g_ina.ina00 MATCHES "[12]" LET g_chr='1'
                           WHEN g_ina.ina00 MATCHES "[34]" LET g_chr='2'
                           WHEN g_ina.ina00 MATCHES "[56]" LET g_chr='3'
                      END CASE
                      CALL q_smy(FALSE,FALSE,g_t1,'AIM',g_chr) RETURNING g_t1    #TQC-670008
                      LET g_ina.ina01=g_t1               
                      DISPLAY BY NAME g_ina.ina01
                      NEXT FIELD ina01
                 WHEN INFIELD(ina11)                                                                                                
                      CALL cl_init_qry_var()                                                                                        
                      LET g_qryparam.form = "q_gen"                                                                                 
                      LET g_qryparam.default1 = g_ina.ina11                                                                         
                      CALL cl_create_qry() RETURNING g_ina.ina11                                                                    
                      DISPLAY BY NAME g_ina.ina11                                                                                   
                      NEXT FIELD ina11                                                                                              
                 WHEN INFIELD(ina04)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_gem"
                      LET g_qryparam.default1 = g_ina.ina04
                      CALL cl_create_qry() RETURNING g_ina.ina04
                      DISPLAY BY NAME g_ina.ina04
                      NEXT FIELD ina04
                 WHEN INFIELD(ina06)             #專案代號 
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_pja2"  #FUN-810045
                      LET g_qryparam.default1 =  g_ina.ina06
                      CALL cl_create_qry() RETURNING g_ina.ina06
                      DISPLAY BY NAME g_ina.ina06
                      NEXT FIELD ina06
                 WHEN INFIELD(ina1001)             
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_occ3"
                      LET g_qryparam.default1 =  g_ina.ina1001
                      CALL cl_create_qry() RETURNING g_ina.ina1001
                      DISPLAY BY NAME g_ina.ina1001
                      NEXT FIELD ina1001
                 WHEN INFIELD(ina1003)             
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_occ4"
                      LET g_qryparam.default1 =  g_ina.ina1003
                      CALL cl_create_qry() RETURNING g_ina.ina1003
                      DISPLAY BY NAME g_ina.ina1003
                      NEXT FIELD ina1003   
                 WHEN INFIELD(ina1004)             
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_occ6"  #No.TQC-640124  
                      LET g_qryparam.default1 =  g_ina.ina1004
                      CALL cl_create_qry() RETURNING g_ina.ina1004
                      DISPLAY BY NAME g_ina.ina1004
                      NEXT FIELD ina1004                        
                 WHEN INFIELD(ina1009)             
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_tqa1"
                      LET g_qryparam.default1 =  g_ina.ina1009
                      LET g_qryparam.arg1='20' 
                      CALL cl_create_qry() RETURNING g_ina.ina1009
                      DISPLAY BY NAME g_ina.ina1009
                      NEXT FIELD ina1009    
                 WHEN INFIELD(ina1010)             
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_tqb"
                      LET g_qryparam.default1 =  g_ina.ina1010
                      CALL cl_create_qry() RETURNING g_ina.ina1010
                      DISPLAY BY NAME g_ina.ina1010
                      NEXT FIELD ina1010     
                 WHEN INFIELD(ina1011)             
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_tqb"
                      LET g_qryparam.default1 =  g_ina.ina1011
                      CALL cl_create_qry() RETURNING g_ina.ina1011
                      DISPLAY BY NAME g_ina.ina1011
                      NEXT FIELD ina1011                                                   
                 WHEN INFIELD(ina1012)             
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_tqa1"
                      LET g_qryparam.default1 =  g_ina.ina1012
                      LET g_qryparam.arg1='19'                       
                      CALL cl_create_qry() RETURNING g_ina.ina1012
                      DISPLAY BY NAME g_ina.ina1012
                      NEXT FIELD ina1012       
                 WHEN INFIELD(ina1005)             
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_ocd1"
                      LET g_qryparam.default1 =  g_ina.ina1005
                      CALL cl_create_qry() RETURNING g_ina.ina1005
                      DISPLAY BY NAME g_ina.ina1005
                      NEXT FIELD ina1005                                                      
                 WHEN INFIELD(ina1023)             
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_azi"
                      LET g_qryparam.default1 =  g_ina.ina1023                     
                      CALL cl_create_qry() RETURNING g_ina.ina1023
                      DISPLAY BY NAME g_ina.ina1023
                      NEXT FIELD ina1023           
            END CASE
        ON ACTION CONTROLF                       #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode())
           RETURNING g_fld_name,g_frm_name 
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
        ON ACTION about          
           CALL cl_about()       
        ON ACTION help          
           CALL cl_show_help()   
    END INPUT
END FUNCTION
FUNCTION t270_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ina00,ina01",TRUE)
    END IF
END FUNCTION
FUNCTION t270_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ina00,ina01",FALSE)
    END IF
END FUNCTION
FUNCTION t270_set_entry_b()
    CALL cl_set_comp_entry("inb901",TRUE)
    CALL cl_set_comp_entry("inb905,inb907",TRUE)
    CALL cl_set_comp_entry("inb1003",TRUE)
END FUNCTION
FUNCTION t270_set_no_entry_b()
DEFINE l_occ1027 LIKE occ_file.occ1027
    IF g_aza.aza27 != 'Y' OR g_ina.ina00 NOT MATCHES '[56]' THEN
       CALL cl_set_comp_entry("inb901",FALSE)
    END IF
    IF g_ima906 = '1' THEN
       CALL cl_set_comp_entry("inb905,inb906,inb907",FALSE)
    END IF
    IF g_ima906 = '2' THEN
       CALL cl_set_comp_entry("inb903,inb906",FALSE)
    END IF
    #參考單位，每個料件只有一個，所以不開放讓用戶輸入
    IF g_ima906 = '3' THEN
       CALL cl_set_comp_entry("inb905",FALSE)
    END IF
    SELECT occ1027 INTO l_occ1027 FROM occ_file
     WHERE occ01=g_ina.ina1001
    IF l_occ1027='N' and g_ina.ina1001[1,4]!='MISC' THEN #不可修改單價
       CALL cl_set_comp_entry("inb1003",FALSE)
    END IF    
END FUNCTION
FUNCTION t270_set_required()
  #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
  IF g_ima906 = '3' THEN
     CALL cl_set_comp_required("inb905,inb907,inb902,inb904",TRUE)
  END IF
  #單位不同,轉換率,數量必KEY
  IF NOT cl_null(g_inb[l_ac].inb902) THEN
     CALL cl_set_comp_required("inb904",TRUE)
  END IF
  IF NOT cl_null(g_inb[l_ac].inb905) THEN
     CALL cl_set_comp_required("inb907",TRUE)
  END IF
END FUNCTION
FUNCTION t270_set_no_required()
  CALL cl_set_comp_required("inb905,inb906,inb907,inb902,inb903,inb904",FALSE)
END FUNCTION
FUNCTION t270_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    IF g_sma.sma120 = 'Y'  THEN                                                                                                      
       LET lg_smy62 = ''                                                                                                             
       LET lg_group = ''                                                                                                             
       CALL t270_refresh_detail()                                                                                                    
    END IF                                                                                                                           
    CALL t270_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 INITIALIZE g_ina.* TO NULL RETURN END IF
    MESSAGE " SEARCHING ! "
    OPEN t270_cs                                 # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_ina.* TO NULL
    ELSE
       OPEN t270_count
       FETCH t270_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL t270_fetch('F')                      # 讀出TEMP第一筆并顯示
    END IF
    MESSAGE ""
END FUNCTION
FUNCTION t270_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1        #處理方式             #No.FUN-680120 VARCHAR(1)
DEFINE l_slip          LIKE ina_file.ina01        #No.FUN-680120 VARCHAR(10)              #No.TQC-650094
    CASE p_flag
        WHEN 'N' FETCH NEXT     t270_cs INTO g_ina.ina01
        WHEN 'P' FETCH PREVIOUS t270_cs INTO g_ina.ina01
        WHEN 'F' FETCH FIRST    t270_cs INTO g_ina.ina01
        WHEN 'L' FETCH LAST     t270_cs INTO g_ina.ina01
        WHEN '/'
            IF (NOT g_no_ask) THEN   #No.FUN-6A0072
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
                    ON ACTION about        
                       CALL cl_about()      
                    ON ACTION help         
                       CALL cl_show_help() 
                    ON ACTION controlg      
                       CALL cl_cmdask()   
               END PROMPT
               IF INT_FLAG THEN
                  LET INT_FLAG = 0
                  EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump t270_cs INTO g_ina.ina01
            LET g_no_ask = FALSE   #No.FUN-6A0072
    END CASE
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ina.ina01,SQLCA.sqlcode,0)
       INITIALIZE g_ina.* TO NULL   #NO.FUN-6B0079  add
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
    SELECT * INTO g_ina.* FROM ina_file WHERE ina01 = g_ina.ina01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ina_file",g_ina.ina01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
       INITIALIZE g_ina.* TO NULL
       RETURN
    ELSE
        LET g_data_owner = g_ina.inauser 
        LET g_data_group = g_ina.inagrup 
        LET g_data_plant = g_ina.inaplant #FUN-980030
    END IF
    #在使用Q查詢的情況下得到當前對應的屬性組smy62
    IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
       LET l_slip = g_ina.ina01[1,g_doc_len]
       SELECT smy62 INTO lg_smy62 FROM smy_file 
        WHERE smyslip = l_slip
    END IF
    CALL t270_show()
END FUNCTION
FUNCTION t270_show()
    LET g_ina_t.* = g_ina.*                      #保存單頭舊值
    IF g_ina.ina1025='3' THEN
       CALL cl_set_comp_visible("ina1017,ina1013,ina1014,ina1019,ina1018, 
                                 ina1001,ina1003,ina1004,ina1009,ina1010,
                                 ina1011,ina1012,occ02a,occ02b,occ02d,
                                 tqa02a,tqb02a,tqb02b,tqa02b,ina1023,ina1024,
                                 ina1005,ina1006,ina1007,ina1008,ina1015,ina1016,
                                 inaconf,ina1022,ina1021,ima1002,ima135,inb1004,
                                 inb1005,inb1002,inb1001,inb1003,inb1006",FALSE)
    ELSE 
       CALL cl_set_comp_visible("ina1017,ina1013,ina1014,ina1019,ina1018,
                                 ina1001,ina1003,ina1004,ina1009,ina1010,
                                 ina1011,ina1012,occ02a,occ02b,occ02d,
                                 tqa02a,tqb02a,tqb02b,tqa02b,ina1023,ina1024,
                                 ina1005,ina1006,ina1007,ina1008,ina1015,ina1016,
                                 inaconf,ima1002,ima135,inb1004, 
                                 inb1005,inb1002,inb1001,inb1003,inb1006",TRUE)                                 
       IF g_sma.sma116='2' OR g_sma.sma116='3' THEN
          CALL cl_set_comp_visible("inb1004,inb1005",TRUE)
       ELSE 
          CALL cl_set_comp_visible("inb1004,inb1005",FALSE)
       END IF  
    END IF
    CALL cl_set_comp_visible("ina1022,ina1021",FALSE)   #No.TQC-640124 
    DISPLAY BY NAME g_ina.inaoriu,g_ina.inaorig,
        g_ina.ina1025,g_ina.ina00,g_ina.ina01,g_ina.ina1017,g_ina.ina03,
        g_ina.ina02,g_ina.ina11,g_ina.ina1013,g_ina.ina1014,g_ina.ina1019,g_ina.ina1018,  #MOD-740017 add ina11
        g_ina.ina1001,g_ina.ina1003,g_ina.ina1004,g_ina.ina04,#No.TQC-640124  
        g_ina.ina1009,g_ina.ina1010,g_ina.ina1011,g_ina.ina1012,g_ina.ina06,
        g_ina.ina1023,g_ina.ina1024,g_ina.ina07,g_ina.ina1005,g_ina.ina1015,g_ina.ina1016,
        g_ina.inaconf,g_ina.ina1020,
 #       g_ina.inapost,g_ina.inamksg,g_ina.ina08,g_ina.ina1022,g_ina.ina1021,       #FUN-B30029  mark
        g_ina.inapost,g_ina.ina1022,g_ina.ina1021,                                  #FUN-B30029 
        g_ina.inauser,g_ina.inagrup,g_ina.inamodu,g_ina.inadate
    CALL t270_show2() 
    CALL t270_ina11('d')                      #FUN-630046    
    CALL t270_ina1001_1('d')  
    CALL t270_ina1003('d')  
    CALL t270_ina1004('d')  
    CALL t270_ina1009('d') 
    CALL t270_ina1010('d')  
    CALL t270_ina1011('d') 
    CALL t270_ina1012('d')  
    CALL t270_ina1005('d') 
    LET g_buf = s_get_doc_no(g_ina.ina01)  
    SELECT smydesc INTO g_buf FROM smy_file WHERE smyslip=g_buf
    DISPLAY g_buf TO smydesc LET g_buf = NULL
    IF g_ina.inapost = 'X' THEN
       LET g_void = 'Y'
    ELSE
       LET g_void = 'N'
    END IF
    IF g_ina.ina08 = '1' THEN
        LET g_chr2='Y'
    ELSE
        LET g_chr2='N'
    END IF
    CALL cl_set_field_pic("",g_chr2,g_ina.inapost,"",g_void,"")
    CALL t270_b_fill(g_wc2)
    CALL cl_show_fld_cont()                 
END FUNCTION
FUNCTION t270_show2()
    SELECT gem02 INTO g_buf FROM gem_file WHERE gem01=g_ina.ina04
    CALL cl_show_fld_cont()                 
    DISPLAY g_buf TO gem02 LET g_buf = NULL
END FUNCTION
FUNCTION t270_ina11(p_cmd)                                                                                                          
DEFINE p_cmd      LIKE type_file.chr1,       #No.FUN-680120 VARCHAR(1)
       l_gen02    LIKE gen_file.gen02,                                                                                              
       l_gen03    LIKE gen_file.gen03,             #No:7381                                                                         
       l_genacti  LIKE gen_file.genacti                                                                                             
    LET g_errno = ' '                                                                                                               
    SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti    #No:7381                                                           
      FROM gen_file                                                                                                                 
     WHERE gen01 = g_ina.ina11                                                                                                      
    CASE                                                                                                                            
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg1312'                                                                             
                                LET l_gen02 = NULL                                                                                  
                                LET l_genacti = NULL                                                                                
       WHEN l_genacti = 'N'  LET g_errno = '9028'                                                                                   
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'                                                            
    END CASE                                                                                                                        
    IF cl_null(g_errno) OR p_cmd = 'd'                                                                                              
    THEN DISPLAY l_gen02 TO FORMONLY.gen02                                                                                          
    END IF                                                                                                                          
END FUNCTION                                                                                                                        
FUNCTION t270_ina1001(p_cmd) 
   DEFINE p_cmd     LIKE type_file.chr1,           #No.FUN-680120 VARCHAR(1)
          l_occ02a  LIKE occ_file.occ02,
          l_occ06    LIKE occ_file.occ06,                                                                                                  
          l_occ1004  LIKE occ_file.occ1004,     
          l_occacti LIKE occ_file.occacti                                                                                                                                                                                   
   LET g_errno = ' '                                                                                                                
#   SELECT TOP(1) occ02,occ09,occ07,occ1005,occ1025,occ1006,ocd02,ocd221,ocd222,#No.TQC-640124    #TQC-B30142
    SELECT        occ02,occ09,occ07,occ1005,occ1025,occ1006,ocd02,ocd221,ocd222,                  #TQC-B30142
          ocd223,occ42,occ06,occ1004,occacti                                                                                        
     INTO l_occ02a,g_ina.ina1003,g_ina.ina1004,g_ina.ina1010,#No.TQC-640124
          g_ina.ina1011,g_ina.ina1012,                                                                                              
          g_ina.ina1005,g_ina.ina1006,g_ina.ina1007,g_ina.ina1008,g_ina.ina1023,                                                    
          l_occ06,l_occ1004,l_occacti                                                                                               
     FROM occ_file,ocd_file                                                                                                         
    WHERE occ01  =g_ina.ina1001                                                                                                     
      AND ocd01  =occ01                                                                                                             
      AND ROWNUM <= 1                                                                             #TQC-B30142
   CASE WHEN SQLCA.SQLCODE = 100                                                                                                    
                             LET g_errno = 'mfg9089'                                                                                  
        WHEN l_occacti  ='N' LET g_errno = '9028'                                                                                     
        WHEN l_occacti MATCHES '[PH]'    LET g_errno = '9038'  #No.FUN-690023 add
        WHEN l_occ1004 !='1' LET g_errno = 'atm-008'   #No.FUN-690025 mod                                                                                                         
        WHEN l_occ06   !='1' LET g_errno = 'atm-009'                                                                                                             
        OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'                                                              
   END CASE                                                                                                                           
   IF cl_null(g_errno) OR p_cmd = 'd' THEN                                                                                          
      DISPLAY l_occ02a  TO FORMONLY.occ02a
      DISPLAY g_ina.ina1003 TO ina1003
      DISPLAY g_ina.ina1004 TO ina1004
      DISPLAY g_ina.ina1010 TO ina1010
      DISPLAY g_ina.ina1011 TO ina1011
      DISPLAY g_ina.ina1012 TO ina1012
      DISPLAY g_ina.ina1005 TO ina1005
      DISPLAY g_ina.ina1006 TO ina1006
      DISPLAY g_ina.ina1007 TO ina1007
      DISPLAY g_ina.ina1008 TO ina1008
      DISPLAY g_ina.ina1023 TO ina1023                                                                                             
   END IF                                                                                                                                                                                                                                                               
END FUNCTION                        
FUNCTION t270_ina1001_1(p_cmd) 
   DEFINE p_cmd     LIKE type_file.chr1,           #No.FUN-680120 VARCHAR(1)
          l_occ02a  LIKE occ_file.occ02,
          l_occacti LIKE occ_file.occacti                                                                                                                                                                                   
   LET g_errno = ' '                                                                                                                
   SELECT occ02,occacti                                                                                                           
     INTO l_occ02a,l_occacti                                                                                                       
     FROM occ_file                                                                                                                
    WHERE occ01=g_ina.ina1001                                                                                                    
   CASE WHEN SQLCA.SQLCODE = 100                                                                                                    
                           LET g_errno  = 'mfg9089'                                                                                  
                           LET l_occ02a = NULL                                                                 
        WHEN l_occacti='N' LET g_errno  = '9028'                                                                                     
        WHEN l_occacti MATCHES '[PH]'   LET g_errno = '9038'  #No.FUN-690023 add
        OTHERWISE          LET g_errno  = SQLCA.SQLCODE USING '-------'                                                              
   END CASE                                                                                                                         
   IF cl_null(g_errno) OR p_cmd = 'd' THEN                                                                                          
      DISPLAY l_occ02a TO FORMONLY.occ02a                                                                                
   END IF
END FUNCTION     
FUNCTION t270_ina1003(p_cmd) 
   DEFINE p_cmd     LIKE type_file.chr1,         #No.FUN-680120 VARCHAR(1)
          l_occ02b  LIKE occ_file.occ02,
          l_occacti LIKE occ_file.occacti                                                                                                                                                                                   
   LET g_errno = ' '                                                                                                                
   SELECT occ02,occacti                                                                                                           
     INTO l_occ02b,l_occacti                                                                                                       
     FROM occ_file                                                                                                                
    WHERE occ01=g_ina.ina1003                                                                                                    
   CASE WHEN SQLCA.SQLCODE = 100                                                                                                    
                           LET g_errno  = 'mfg9089'                                                                                  
                           LET l_occ02b = NULL                                                                 
        WHEN l_occacti='N' LET g_errno  = '9028'                                                                                     
        WHEN l_occacti MATCHES '[PH]'   LET g_errno = '9038'  #No.FUN-690023 add
        OTHERWISE          LET g_errno  = SQLCA.SQLCODE USING '-------'                                                              
   END CASE                                                                                                                         
   IF cl_null(g_errno) OR p_cmd = 'd' THEN                                                                                          
      DISPLAY l_occ02b TO FORMONLY.occ02b                                                                                
   END IF
END FUNCTION     
FUNCTION t270_ina1004(p_cmd) 
   DEFINE p_cmd     LIKE type_file.chr1,           #No.FUN-680120 VARCHAR(1)
          l_occ02d  LIKE occ_file.occ02,
          l_occacti LIKE occ_file.occacti                                                                                                                                                                                   
   LET g_errno = ' '                                                                                                                
   SELECT occ02,occacti                                                                                                           
     INTO l_occ02d,l_occacti                                                                                                       
     FROM occ_file                                                                                                                
    WHERE occ01=g_ina.ina1004                                                                                                    
   CASE WHEN SQLCA.SQLCODE = 100                                                                                                    
                           LET g_errno  = 'mfg9089'                                                                                  
                           LET l_occ02d = NULL                                                                 
        WHEN l_occacti='N' LET g_errno  = '9028'                                                                                     
        WHEN l_occacti MATCHES '[PH]' LET g_errno = '9038'  #NO.FUN-690023 add
        OTHERWISE          LET g_errno  = SQLCA.SQLCODE USING '-------'                                                              
   END CASE                                                                                                                         
   IF cl_null(g_errno) OR p_cmd = 'd' THEN                                                                                          
      DISPLAY l_occ02d TO FORMONLY.occ02d                                                                                
   END IF
END FUNCTION       
FUNCTION t270_ina1009(p_cmd) 
   DEFINE p_cmd     LIKE type_file.chr1,           #No.FUN-680120 VARCHAR(1)
          l_tqa02a  LIKE tqa_file.tqa02,
          l_tqaacti LIKE tqa_file.tqaacti                                                                                                                                                                                   
   LET g_errno = ' '                                                                                                                
   SELECT tqa02,tqaacti                                                                                                           
     INTO l_tqa02a,l_tqaacti                                                                                                       
     FROM tqa_file                                                                                                                
    WHERE tqa01=g_ina.ina1009     
      AND tqa03='20'                                                                                               
   CASE WHEN SQLCA.SQLCODE = 100                                                                                                    
                           LET g_errno  = 'mfg9089'                                                                                  
                           LET l_tqa02a = NULL                                                                 
        WHEN l_tqaacti='N' LET g_errno  = '9028'                                                                                     
        OTHERWISE          LET g_errno  = SQLCA.SQLCODE USING '-------'                                                              
   END CASE                                                                                                                         
   IF cl_null(g_errno) OR p_cmd = 'd' THEN                                                                                          
      DISPLAY l_tqa02a TO FORMONLY.tqa02a                                                                                
   END IF
END FUNCTION    
FUNCTION t270_ina1010(p_cmd) 
   DEFINE p_cmd     LIKE type_file.chr1,           #No.FUN-680120 VARCHAR(1)
          l_tqb02a  LIKE tqb_file.tqb02,
          l_tqbacti LIKE tqb_file.tqbacti                                                                                                                                                                                   
   LET g_errno = ' '                                                                                                                
   SELECT tqb02,tqbacti                                                                                                           
     INTO l_tqb02a,l_tqbacti                                                                                                       
     FROM tqb_file                                                                                                                
    WHERE tqb01=g_ina.ina1010                                                                                                    
   CASE WHEN SQLCA.SQLCODE = 100                                                                                                    
                           LET g_errno  = 'mfg9089'                                                                                  
                           LET l_tqb02a = NULL                                                                 
        WHEN l_tqbacti='N' LET g_errno  = '9028'                                                                                     
        OTHERWISE          LET g_errno  = SQLCA.SQLCODE USING '-------'                                                              
   END CASE                                                                                                                         
   IF cl_null(g_errno) OR p_cmd = 'd' THEN                                                                                          
      DISPLAY l_tqb02a TO FORMONLY.tqb02a                                                                                
   END IF
END FUNCTION                 
FUNCTION t270_ina1011(p_cmd) 
   DEFINE p_cmd     LIKE type_file.chr1,           #No.FUN-680120 VARCHAR(1)
          l_tqb02b  LIKE tqb_file.tqb02,
          l_tqbacti LIKE tqb_file.tqbacti                                                                                                                                                                                   
   LET g_errno = ' '                                                                                                                
   SELECT tqb02,tqbacti                                                                                                           
     INTO l_tqb02b,l_tqbacti                                                                                                       
     FROM tqb_file                                                                                                                
    WHERE tqb01=g_ina.ina1011                                                                                                    
   CASE WHEN SQLCA.SQLCODE = 100                                                                                                    
                           LET g_errno  = 'mfg9089'                                                                                  
                           LET l_tqb02b = NULL                                                                 
        WHEN l_tqbacti='N' LET g_errno  = '9028'                                                                                     
        OTHERWISE          LET g_errno  = SQLCA.SQLCODE USING '-------'                                                              
   END CASE                                                                                                                         
   IF cl_null(g_errno) OR p_cmd = 'd' THEN                                                                                          
      DISPLAY l_tqb02b TO FORMONLY.tqb02b                                                                                
   END IF
END FUNCTION                 
FUNCTION t270_ina1012(p_cmd) 
   DEFINE p_cmd     LIKE type_file.chr1,           #No.FUN-680120 VARCHAR(1)
          l_tqa02b  LIKE tqa_file.tqa02,
          l_tqaacti LIKE tqa_file.tqaacti                                                                                                                                                                                   
   LET g_errno = ' '                                                                                                                
   SELECT tqa02,tqaacti                                                                                                           
     INTO l_tqa02b,l_tqaacti                                                                                                       
     FROM tqa_file                                                                                                                
    WHERE tqa01=g_ina.ina1012 
      AND tqa03='19'                                                                                                   
   CASE WHEN SQLCA.SQLCODE = 100                                                                                                    
                           LET g_errno  = 'mfg9089'                                                                                  
                           LET l_tqa02b = NULL                                                                 
        WHEN l_tqaacti='N' LET g_errno  = '9028'                                                                                     
        OTHERWISE          LET g_errno  = SQLCA.SQLCODE USING '-------'                                                              
   END CASE                                                                                                                         
   IF cl_null(g_errno) OR p_cmd = 'd' THEN                                                                                          
      DISPLAY l_tqa02b TO FORMONLY.tqa02b                                                                                
   END IF
END FUNCTION    
FUNCTION t270_ina1005(p_cmd) 
   DEFINE p_cmd     LIKE type_file.chr1           #No.FUN-680120 VARCHAR(1)
   LET g_errno = ' '                                                                                                                
   SELECT ocd221,ocd222,ocd223
     INTO g_ina.ina1006,g_ina.ina1007,g_ina.ina1008
     FROM ocd_file                                                                                                                
    WHERE ocd02 = g_ina.ina1005                                                                                                    
      AND ocd01 = g_ina.ina1001   #MOD-7B0251-add
   CASE WHEN SQLCA.SQLCODE = 100                                                                                                    
                           LET g_errno  = 'mfg9089'                                                                                  
                           LET g_ina.ina1006 = NULL                                                                 
                           LET g_ina.ina1007 = NULL                                                                 
                           LET g_ina.ina1008 = NULL                                                                 
        OTHERWISE          LET g_errno  = SQLCA.SQLCODE USING '-------'                                                              
   END CASE                                                                                                                         
   IF cl_null(g_errno) OR p_cmd = 'd' THEN                                                                                          
      DISPLAY g_ina.ina1006 TO ina1006
      DISPLAY g_ina.ina1007 TO ina1007
      DISPLAY g_ina.ina1008 TO ina1008
   END IF
END FUNCTION                                                                    
FUNCTION t270_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
    DEFINE l_flag       LIKE type_file.chr1             #No.FUN-B70074 
    #FUN-BC0104-add-str--
    DEFINE l_inb01  LIKE inb_file.inb01
    DEFINE l_inb03  LIKE inb_file.inb03
    DEFINE l_inb46  LIKE inb_file.inb46
    DEFINE l_inb47  LIKE inb_file.inb47
    DEFINE l_inb48  LIKE inb_file.inb48
    DEFINE l_flagg  LIKE type_file.chr1
    DEFINE l_qcl05  LIKE qcl_file.qcl05
    DEFINE l_type1  LIKE type_file.chr1
    DEFINE l_cn     LIKE  type_file.num5
    DEFINE l_c      LIKE  type_file.num5
    DEFINE l_inb_a  DYNAMIC ARRAY OF RECORD
           inb01    LIKE  inb_file.inb01,
           inb03    LIKE  inb_file.inb03,
           inb46    LIKE  inb_file.inb46,
           inb48    LIKE  inb_file.inb48,
           inb47    LIKE  inb_file.inb47,
           flagg    LIKE  type_file.chr1
                    END RECORD
    #FUN-BC0104-add-end--
    IF s_shut(0) THEN RETURN END IF
    IF g_ina.ina01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_ina.* FROM ina_file WHERE ina01=g_ina.ina01
    IF g_ina.inapost = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_ina.inapost = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
    IF g_ina.inaconf = 'Y' THEN CALL cl_err('',9022,0) RETURN END IF
    IF g_ina.ina08 matches '[Ss1]' THEN          
       CALL cl_err('','mfg3557',0)
       RETURN
    END IF
    BEGIN WORK
    OPEN t270_cl USING g_ina.ina01
    IF STATUS THEN
       CALL cl_err("OPEN t270_cl:", STATUS, 1)
       CLOSE t270_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t270_cl INTO g_ina.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ina.ina01,SQLCA.sqlcode,0)
       CLOSE t270_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL t270_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ina01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ina.ina01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
       MESSAGE "Delete ina,inb!"
       DELETE FROM ina_file WHERE ina01 = g_ina.ina01
       IF SQLCA.SQLERRD[3]=0
          THEN CALL cl_err3("del","ina_file",g_ina.ina01,"",SQLCA.sqlcode,"","No ina deleted",1)  #No.FUN-660104
               ROLLBACK WORK RETURN
       END IF
       #FUN-BC0104-add-str--
       LET l_cn = 1
       DECLARE upd_qco20 CURSOR FOR
        SELECT inb03 FROM inb_file WHERE inb01 = l_ina01
       FOREACH upd_qco20 INTO l_inb03
          CALL s_iqctype_inb(g_ina.ina01,l_inb03) RETURNING l_inb01,l_inb03,l_inb46,l_inb48,l_inb47,l_flagg
          LET l_inb_a[l_cn].inb01 = l_inb01
          LET l_inb_a[l_cn].inb03 = l_inb03
          LET l_inb_a[l_cn].inb46 = l_inb46
          LET l_inb_a[l_cn].inb48 = l_inb48
          LET l_inb_a[l_cn].inb47 = l_inb47
          LET l_inb_a[l_cn].flagg = l_flagg
          LET l_cn = l_cn + 1
       END FOREACH
       #FUN-BC0104-add-end--
       DELETE FROM inb_file WHERE inb01 = g_ina.ina01
       #FUN-BC0104-add-str--
       FOR l_c=1 TO l_cn-1
          IF l_inb_a[l_c].flagg = 'Y' THEN
             CALL s_qcl05_sel(l_inb_a[l_c].inb46) RETURNING l_qcl05
             IF l_qcl05='1' THEN LET l_type1 ='6' ELSE LET l_type1='4' END IF
             LET l_flag=s_iqctype_upd_qco20(l_inb_a[l_c].inb01,l_inb_a[l_c].inb03,l_inb_a[l_c].inb48,l_inb_a[l_c].inb47,l_type1) 
          END IF
       END FOR
       #FUN-BC0104-add-end--
#FUN-B70074-add-delete--
       IF NOT s_industry('std') THEN 
          LET l_flag=s_del_inbi(g_ina.ina01,'','')
       END IF
#FUN-B70074-add-end--
       LET g_msg=TIME
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,
                            azoplant,azolegal)
       VALUES ('atmt270',g_user,g_today,g_msg,g_ina.ina01,'delete',
               g_plant,g_legal) #FUN-980009
       CLEAR FORM
       CALL g_inb.clear()
       INITIALIZE g_ina.* TO NULL
       MESSAGE ""
       OPEN t270_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t270_cl
          CLOSE t270_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end--
       FETCH t270_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t270_cl
          CLOSE t270_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t270_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t270_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE    #No.FUN-6A0072
          CALL t270_fetch('/')
       END IF
    END IF
    CLOSE t270_cl
    COMMIT WORK
    CALL cl_flow_notify(g_ina.ina01,'D')
END FUNCTION
FUNCTION t270_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                      #未取消的ARRAY CNT #No.FUN-680120 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,                      #檢查重復用        #No.FUN-680120 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                       #單身鎖住否       #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                       #處理狀態         #No.FUN-680120 VARCHAR(1)
    l_b2            LIKE nma_file.nma04,             #No.FUN-680120 VARCHAR(30)
    l_type          LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(01)
    l_ima08         LIKE ima_file.ima08,
    l_coc04         LIKE coc_file.coc04,   
    l_coc10         LIKE coc_file.coc10,   
    l_allow_insert  LIKE type_file.num5,                      #可新增否        #No.FUN-680120 SMALLINT
    l_allow_delete  LIKE type_file.num5,                      #可刪除否        #No.FUN-680120 SMALLINT
    acti            LIKE azf_file.azfacti,            #No.FUN-680120 VARCHAR(10) # TQC-6A0079     #No.FUN-6B0065
    l_ina08         LIKE ina_file.ina08,
    l_fac           LIKE inb_file.inb08_fac,
    l_ima1010       LIKE ima_file.ima1010,   
    l_imaacti       LIKE ima_file.imaacti,   
    l_ima140        LIKE ima_file.ima140,
    l_ima1401       LIKE ima_file.ima1401,       #FUN-6A0036
    l_imaag         LIKE ima_file.imaag,         #No.FUN-640056       
    l_inb03_o       LIKE inb_file.inb03          #MOD-640049    
    DEFINE   li_i         LIKE type_file.num5             #No.FUN-680120 SMALLINT                                                                                             
    DEFINE   l_count      LIKE type_file.num5             #No.FUN-680120 SMALLINT                                                                                            
    DEFINE   l_temp       LIKE ima_file.ima01                                                                                        
    DEFINE   l_check_res  LIKE type_file.num5             #No.FUN-680120 SMALLINT               
    DEFINE   l_tqn        RECORD  LIKE tqn_file.*
    DEFINE   l_inbi       RECORD LIKE inbi_file.* #FUN-B70074 add
    DEFINE   l_tf         LIKE type_file.chr1     #FUN-BB0085
    DEFINE   l_case       STRING                  #FUN-BB0085
    #FUN-BC0104-add-str--
    DEFINE l_inb01  LIKE inb_file.inb01
    DEFINE l_inb03  LIKE inb_file.inb03
    DEFINE l_inb46  LIKE inb_file.inb46
    DEFINE l_inb47  LIKE inb_file.inb47
    DEFINE l_inb48  LIKE inb_file.inb48
    DEFINE l_flagg  LIKE type_file.chr1
    DEFINE l_qcl05  LIKE qcl_file.qcl05
    DEFINE l_type1  LIKE type_file.chr1
    #FUN-BC0104-add-end--
    DEFINE l_flag1         LIKE type_file.chr1     #TQC-D20031
    DEFINE l_where         STRING                  #TQC-D20031
    DEFINE l_sql           STRING                  #TQC-D20031

    LET g_action_choice = ""
    IF g_ina.ina01 IS NULL THEN RETURN END IF
    SELECT * INTO g_ina.* FROM ina_file WHERE ina01=g_ina.ina01
    LET l_ina08 = g_ina.ina08   
    IF g_ina.inapost = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_ina.inapost = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
    IF g_ina.inaconf = 'Y' THEN CALL cl_err('',9022,0) RETURN END IF
    IF g_ina.ina08 matches '[Ss]' THEN      
         CALL cl_err('','apm-030',0)
         RETURN
    END IF
    CALL cl_opmsg('b')
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    LET g_forupd_sql = "SELECT * FROM inb_file ",
                       " WHERE inb01= ? AND inb03= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t270_bcl CURSOR FROM g_forupd_sql    # LOCK CURSOR
    LET l_ac_t = 0
    IF g_rec_b=0 THEN CALL g_inb.clear() END IF
    INPUT ARRAY g_inb WITHOUT DEFAULTS FROM s_inb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
           CALL t270_set_entry_b()       
           CALL t270_set_no_entry_b()  
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                  #DEFAULT
            LET l_n  = ARR_COUNT()
            LET g_value = NULL
            LET g_inb04 = NULL
            LET g_chr4  = '0'
            LET g_chr3  = '0'
            BEGIN WORK
            OPEN t270_cl USING g_ina.ina01
            IF STATUS THEN
               CALL cl_err("OPEN t270_cl:", STATUS, 1)
               CLOSE t270_cl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH t270_cl INTO g_ina.*        # 鎖住將被更改或取消的資料
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ina.ina01,SQLCA.sqlcode,0)     
                  CLOSE t270_cl ROLLBACK WORK RETURN
               END IF
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_inb_t.* = g_inb[l_ac].*    #BACKUP
                OPEN t270_bcl USING g_ina.ina01,g_inb_t.inb03
                IF STATUS THEN
                   CALL cl_err("OPEN t270_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t270_bcl INTO b_inb.*
                   CALL t270_azf03_desc()                #TQC-D20047 add
                   IF SQLCA.sqlcode THEN
                       CALL cl_err('lock inb',SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                       CALL t270_b_move_to()
                       LET g_inb08_t = b_inb.inb08         #FUN-BB0085
                       LET g_inb905_t = b_inb.inb905       #FUN-BB0085
                       LET g_inb902_t = b_inb.inb902       #FUN-BB0085
                       LET g_inb1004_t = b_inb.inb1004     #FUN-BB0085
                   END IF
                END IF
                LET g_change ='N'  
                LET g_change1='N'  
                LET g_yes='N'
                CALL t270_set_entry_b()
                CALL t270_set_no_entry_b()
                CALL cl_show_fld_cont()     
            END IF
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_inb[l_ac].* TO NULL     
            INITIALIZE arr_detail[l_ac].* TO NULL   #No.TQC-650094
            INITIALIZE g_inb_t.* TO NULL
            LET g_inb08_t = NULL                    #FUN-BB0085
            LET g_inb905_t = NULL                   #FUN-BB0085
            LET g_inb902_t = NULL                   #FUN-BB0085
            LET g_inb1004_t = NULL                  #FUN-BB0085
            LET b_inb.inb01=g_ina.ina01
            LET g_inb[l_ac].inb10 = 'N'    
            LET g_inb[l_ac].inb08_fac=1
            LET g_yes='N'
            LET g_change = 'Y'
            LET g_change1= 'Y'
            CALL cl_show_fld_cont()    
            NEXT FIELD inb03           
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF NOT t270_chk_img() THEN NEXT FIELD inb04 END IF #FUN-C80107 add 121024
            IF g_sma.sma115 = 'Y' THEN
               CALL s_chk_va_setting(g_inb[l_ac].inb04)
                    RETURNING g_flag,g_ima906,g_ima907
               IF g_flag=1 THEN
                  NEXT FIELD inb04
               END IF
               CALL t270_du_data_to_correct()
            END IF
            SELECT img09 INTO g_img09 FROM img_file
             WHERE img01=g_inb[l_ac].inb04
               AND img02=g_inb[l_ac].inb05
               AND img03=g_inb[l_ac].inb06
               AND img04=g_inb[l_ac].inb07
            IF cl_null(g_img09) THEN
               CALL cl_err3("sel","img_file",g_inb[l_ac].inb04,"","mfg6069","","",1)  #No.FUN-660104
               NEXT FIELD inb04
            END IF
            IF g_sma.sma115 = 'Y' THEN
               IF t270_qty_issue() THEN
                  IF g_ima906 MATCHES '[23]' THEN
                     NEXT FIELD inb907                          
                  ELSE
                     NEXT FIELD inb904                        
                  END IF
               END IF
               CALL t270_set_origin_field()
            END IF
            CALL t270_b_move_back()
            CALL t270_b_else()
            IF g_value IS NOT NULL THEN
               SELECT COUNT(*) INTO l_n
                 FROM tqm_file,tqn_file
                WHERE tqn01 = tqm01
                  AND tqm01 = g_inb[l_ac].inb1001
                  AND tqn03 = g_value
               IF l_n = 0 THEN
                  INITIALIZE  l_tqn.* TO NULL
                  SELECT tqn_file.* INTO l_tqn.*
                    FROM tqm_file,tqn_file
                   WHERE tqn01 = tqm01
                     AND tqm01 = g_inb[l_ac].inb1001
                     AND tqn03 = g_inb04
                  SELECT MAX(tqn02) INTO l_tqn.tqn02
                    FROM tqm_file,tqn_file
                   WHERE tqn01 = tqm01
                     AND tqm01 = g_inb[l_ac].inb1001
                  LET l_tqn.tqn02 = l_tqn.tqn02+1
                  LET l_tqn.tqn03 = g_value
                  INSERT INTO tqn_file VALUES(l_tqn.*)
               END IF
            END IF
            LET b_inb.inb16 = g_inb[l_ac].inb09  #No.FUN-870163
            LET b_inb.inbplant = g_plant #FUN-980009
            LET b_inb.inblegal = g_legal #FUN-980009
     #TQC-D20031---mark---str---
           #FUN-CB0087-xj---add---str
#           IF g_aza.aza115 = 'Y' THEN
#              CALL s_reason_code(g_ina.ina01,g_ina.ina10,'',g_inb[l_ac].inb04,g_inb[l_ac].inb05,g_ina.ina04,g_ina.ina11) RETURNING b_inb.inb15
#              IF cl_null(b_inb.inb15) THEN
#                 CALL cl_err('','aim-425',1)
#                 CANCEL INSERT 
#              END IF
#           END IF
           #FUN-CB0087-xj---add---end
     #TQC-D20031---mark---end---
            INSERT INTO inb_file VALUES(b_inb.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","inb_file",b_inb.inb01,"",SQLCA.sqlcode,"","ins inb",1)  #No.FUN-660104
               CANCEL INSERT
            ELSE
#FUN-B70074--add--insert--
               IF NOT s_industry('std') THEN
                  INITIALIZE l_inbi.* TO NULL
                  LET l_inbi.inbi01 = b_inb.inb01
                  LET l_inbi.inbi03 = b_inb.inb03
                  IF NOT s_ins_inbi(l_inbi.*,b_inb.inbplant) THEN
                     CANCEL INSERT
                  END IF
               END IF 
#FUN-B70074--add--insert--
               MESSAGE 'INSERT O.K'
               LET l_ina08 = '0'          
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               CALL t270_weight_cubage(g_ina.ina01)                                                                                            
               CALL t270_ina_sum()                      
            END IF
        BEFORE FIELD inb03                       #default 序號
             IF g_inb[l_ac].inb03 IS NULL OR g_inb[l_ac].inb03 = 0 THEN
                SELECT max(inb03)+1 INTO g_inb[l_ac].inb03
                  FROM inb_file WHERE inb01 = g_ina.ina01
                IF g_inb[l_ac].inb03 IS NULL THEN
                   LET g_inb[l_ac].inb03 = 1
                END IF
             END IF
        AFTER FIELD inb03                        #check 序號是否重復
             IF NOT cl_null(g_inb[l_ac].inb03) THEN
                IF g_inb[l_ac].inb03 != g_inb_t.inb03 OR
                   g_inb_t.inb03 IS NULL THEN
                    SELECT count(*) INTO l_n FROM inb_file
                        WHERE inb01 = g_ina.ina01 AND inb03 = g_inb[l_ac].inb03
                    IF l_n > 0 THEN
                        LET g_inb[l_ac].inb03 = g_inb_t.inb03
                        CALL cl_err('',-239,0) NEXT FIELD inb03
                    END IF
                END IF
             END IF
        BEFORE FIELD inb04
           CALL t270_set_entry_b()
           CALL t270_set_no_required()     
        AFTER FIELD inb04
           #AFTER FIELD 處理邏輯修改為使用下面的函數來進行判斷，請參考相關代碼
#FUN-AA0059 ---------------------start----------------------------
            IF NOT cl_null(g_inb[l_ac].inb04) THEN
               IF NOT s_chk_item_no(g_inb[l_ac].inb04,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_inb[l_ac].inb04= g_inb_t.inb04
                  NEXT FIELD inb04
               END IF
            END IF
#FUN-AA0059 ---------------------end-------------------------------
           CALL t270_check_inb04('inb04',l_ac) RETURNING
                 l_check_res
           IF NOT l_check_res THEN NEXT FIELD inb04 END IF       
        #當sma908 <> 'Y'的時候,即不准通過單身來新增子料件,這時
        #對于采用料件多屬性新機制(與單據性質綁定)的分支來說,各個明細屬性欄位都
        #變NOENTRY的, 只能通過在母料件欄位開窗來選擇子料件,并且母料件本身也不允許
        #接受輸入,而只能開窗,所以這里要進行一個特殊的處理,就是一進att00母料件
        #欄位的時候就auto開窗,開完窗之后直接NEXT FIELD以避免用戶亂動
        #其他分支就不需要這么麻煩了
        BEFORE FIELD att00
              #根據子料件找到母料件及各個屬性
              SELECT imx00,imx01,imx02,imx03,imx04,imx05,
                     imx06,imx07,imx08,imx09,imx10 
              INTO g_inb[l_ac].att00, g_inb[l_ac].att01, g_inb[l_ac].att02,
                   g_inb[l_ac].att03, g_inb[l_ac].att04, g_inb[l_ac].att05,
                   g_inb[l_ac].att06, g_inb[l_ac].att07, g_inb[l_ac].att08,
                   g_inb[l_ac].att09, g_inb[l_ac].att10
              FROM imx_file
              WHERE imx000 = g_inb[l_ac].inb04
              LET g_inb04 = g_inb[l_ac].att00  
              LET g_chr4  = '1'               
              #賦值所有屬性
              LET g_inb[l_ac].att01_c = g_inb[l_ac].att01
              LET g_inb[l_ac].att02_c = g_inb[l_ac].att02
              LET g_inb[l_ac].att03_c = g_inb[l_ac].att03
              LET g_inb[l_ac].att04_c = g_inb[l_ac].att04
              LET g_inb[l_ac].att05_c = g_inb[l_ac].att05
              LET g_inb[l_ac].att06_c = g_inb[l_ac].att06
              LET g_inb[l_ac].att07_c = g_inb[l_ac].att07
              LET g_inb[l_ac].att08_c = g_inb[l_ac].att08
              LET g_inb[l_ac].att09_c = g_inb[l_ac].att09
              LET g_inb[l_ac].att10_c = g_inb[l_ac].att10
              #顯示所有屬性
              DISPLAY BY NAME g_inb[l_ac].att00  
              DISPLAY BY NAME 
                g_inb[l_ac].att01, g_inb[l_ac].att01_c,
                g_inb[l_ac].att02, g_inb[l_ac].att02_c,
                g_inb[l_ac].att03, g_inb[l_ac].att03_c,
                g_inb[l_ac].att04, g_inb[l_ac].att04_c,
                g_inb[l_ac].att05, g_inb[l_ac].att05_c,
                g_inb[l_ac].att06, g_inb[l_ac].att06_c,
                g_inb[l_ac].att07, g_inb[l_ac].att07_c,
                g_inb[l_ac].att08, g_inb[l_ac].att08_c,
                g_inb[l_ac].att09, g_inb[l_ac].att09_c,
                g_inb[l_ac].att10, g_inb[l_ac].att10_c
              LET g_chr3  = '1'
              CALL t270_check_inb04('imx00',l_ac) RETURNING
                l_check_res
              IF NOT l_check_res THEN NEXT FIELD att00 END IF
        #以下是為料件多屬性機制新增的20個屬性欄位的AFTER FIELD代碼
        #下面是十個輸入型屬性欄位的判斷語句
        AFTER FIELD att00
            #FUN-AB0025 ------------add start-------  
            IF NOT cl_null(g_inb[l_ac].att00) THEN
               IF NOT s_chk_item_no(g_inb[l_ac].att00,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD att00
               END IF
            END IF
            #FUN-AB0025 ------------add end-----------
            #檢查att00里面輸入的母料件是否是符合對應屬性組的母料件
            SELECT COUNT(ima01) INTO l_count FROM ima_file 
              WHERE ima01 = g_inb[l_ac].att00 AND imaag = lg_smy62
            IF l_count = 0 THEN
               CALL cl_err_msg('','aim-909',lg_smy62,0)
               NEXT FIELD att00          
            END IF
            LET g_inb04 = g_inb[l_ac].att00  
            #如果設置為不允許新增
               CALL t270_check_inb04('imx00',l_ac) RETURNING
                 l_check_res
               IF NOT l_check_res THEN NEXT FIELD att00 END IF
        AFTER FIELD att01
            CALL t270_check_att0x(g_inb[l_ac].att01,1,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att01 END IF              
        AFTER FIELD att02
            CALL t270_check_att0x(g_inb[l_ac].att02,2,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att02 END IF
        AFTER FIELD att03
            CALL t270_check_att0x(g_inb[l_ac].att03,3,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att03 END IF
        AFTER FIELD att04
            CALL t270_check_att0x(g_inb[l_ac].att04,4,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att04 END IF
        AFTER FIELD att05
            CALL t270_check_att0x(g_inb[l_ac].att05,5,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att05 END IF          
        AFTER FIELD att06
            CALL t270_check_att0x(g_inb[l_ac].att06,6,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att06 END IF
        AFTER FIELD att07
            CALL t270_check_att0x(g_inb[l_ac].att07,7,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att07 END IF
        AFTER FIELD att08
            CALL t270_check_att0x(g_inb[l_ac].att08,8,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att08 END IF
        AFTER FIELD att09
            CALL t270_check_att0x(g_inb[l_ac].att09,9,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att09 END IF
        AFTER FIELD att10
            CALL t270_check_att0x(g_inb[l_ac].att10,10,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att10 END IF
        #下面是十個輸入型屬性欄位的判斷語句
        AFTER FIELD att01_c
            CALL t270_check_att0x_c(g_inb[l_ac].att01_c,1,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att01_c END IF      
        AFTER FIELD att02_c
            CALL t270_check_att0x_c(g_inb[l_ac].att02_c,2,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att02_c END IF
        AFTER FIELD att03_c
            CALL t270_check_att0x_c(g_inb[l_ac].att03_c,3,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att03_c END IF
        AFTER FIELD att04_c
            CALL t270_check_att0x_c(g_inb[l_ac].att04_c,4,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att04_c END IF
        AFTER FIELD att05_c
            CALL t270_check_att0x_c(g_inb[l_ac].att05_c,5,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att05_c END IF
        AFTER FIELD att06_c
            CALL t270_check_att0x_c(g_inb[l_ac].att06_c,6,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att06_c END IF
        AFTER FIELD att07_c
            CALL t270_check_att0x_c(g_inb[l_ac].att07_c,7,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att07_c END IF
        AFTER FIELD att08_c
            CALL t270_check_att0x_c(g_inb[l_ac].att08_c,8,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att08_c END IF
        AFTER FIELD att09_c
            CALL t270_check_att0x_c(g_inb[l_ac].att09_c,9,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att09_c END IF
        AFTER FIELD att10_c
            CALL t270_check_att0x_c(g_inb[l_ac].att10_c,10,l_ac) RETURNING
                 l_check_res
            IF NOT l_check_res THEN NEXT FIELD att10_c END IF
        AFTER FIELD inb05
           IF cl_null(g_inb[l_ac].inb05) THEN
               CALL cl_err('','aap-099',0)
               NEXT FIELD inb05
           END IF
           IF NOT cl_null(g_inb[l_ac].inb05) THEN
             # #CHI-D20014 add str 还原
             # #檢查料號預設倉儲及單別預設倉儲
             # IF NOT s_chksmz(g_inb[l_ac].inb04, g_ina.ina01,
             #                 g_inb[l_ac].inb05, g_inb[l_ac].inb06) THEN
             #    NEXT FIELD inb05
             # END IF
             # #CHI-D20014 add end 还原
              IF g_inb_t.inb07 IS NULL OR g_inb_t.inb07 <> g_inb[l_ac].inb07 THEN
                 LET g_change='Y'
              END IF
              SELECT imd02 INTO g_buf FROM imd_file
               WHERE imd01=g_inb[l_ac].inb05 AND imd10=g_imd10
                  AND imdacti = 'Y' 
              IF STATUS THEN
                 CALL cl_err3("sel","imd_file",g_inb[l_ac].inb05,"","mfg1100","","imd",1)    #FUN-660104
                 NEXT FIELD inb05
              END IF
              #No.FUN-AA0062  --Begin
              IF NOT s_chk_ware(g_inb[l_ac].inb05) THEN
                 NEXT FIELD inb05
              END IF
              #No.FUN-AA0062  --End
           END IF
#確認料+倉存在於img_file                                                                               
           #FUN-C80107 mark begin---------------------121024
           #LET g_cnt = 0                                                                                                           
           #SELECT COUNT(*) INTO g_cnt FROM img_file                                                                                
           # WHERE img01=g_inb[l_ac].inb04                                                                                          
           #   AND img02=g_inb[l_ac].inb05                                                                                          
           #IF g_cnt = 0 AND (g_ina.ina00!='3') THEN           #No.TQC-650111                                                                                            
           #   CALL cl_err(g_inb[l_ac].inb04,'mfg6069',1)                                                                           
           #   NEXT FIELD inb05                                                                                                     
           #END IF                                           
           #FUN-C80107 mark end------------------------                                                                       
           IF NOT t270_chk_img() THEN NEXT FIELD inb05 END IF #FUN-C80107 add 121024
           NEXT FIELD inb06  #強迫跳下一個欄位,避免下箭頭的使用                                                                    
        AFTER FIELD inb06
           #控管是否為全型空白
           IF g_inb[l_ac].inb06 ='　' THEN       #全型空白
               LET g_inb[l_ac].inb06 =' '
           END IF
           IF g_inb[l_ac].inb06 IS NULL THEN LET g_inb[l_ac].inb06 =' ' END IF
           IF g_inb_t.inb06 IS NULL OR g_inb_t.inb06 <> g_inb[l_ac].inb06 THEN
              LET g_change='Y'
           END IF
          # IF NOT cl_null(g_inb[l_ac].inb05) THEN #CHI-D20014 add 还原
           #檢查料號預設倉儲及單別預設倉儲
           IF NOT s_chksmz(g_inb[l_ac].inb04, g_ina.ina01,
                           g_inb[l_ac].inb05, g_inb[l_ac].inb06) THEN
              NEXT FIELD inb05
           END IF
          # END IF #CHI-D20014 add 还原   
#確認料+倉+儲存在於img_file                                                                            
           #FUN-C80107 mark begin---------------------121024
           #LET g_cnt = 0
           #SELECT COUNT(*) INTO g_cnt FROM img_file
           # WHERE img01=g_inb[l_ac].inb04
           #   AND img02=g_inb[l_ac].inb05
           #   AND img03=g_inb[l_ac].inb06
           #IF g_cnt = 0 AND (g_ina.ina00!='3')THEN    #No.TQC-650111                                                                                         
           #   CALL cl_err(g_inb[l_ac].inb04,'mfg6069',1)
           #   NEXT FIELD inb06
           #END IF
           #FUN-C80107 mark end------------------------
           IF NOT t270_chk_img() THEN NEXT FIELD inb06 END IF #FUN-C80107 add 121024
           NEXT FIELD inb07   #強迫跳下一個欄位,避免下箭頭的使用                                                                   
        BEFORE FIELD inb07
           IF p_cmd ='a' AND NOT cl_null(g_ina.ina06) THEN
              LET g_inb[l_ac].inb07 = g_ina.ina06
           END IF
        AFTER FIELD inb07
           LET l_tf = "" #FUN-C20048 add
           IF NOT cl_null(g_ina.ina06) AND
              g_ina.ina06 != g_inb[l_ac].inb07 THEN
              CALL cl_err('','aim-503',1)
           END IF
           #控管是否為全型空白
           IF g_inb[l_ac].inb07 ='　' THEN       #全型空白
               LET g_inb[l_ac].inb07 =' '
           END IF
           IF g_inb[l_ac].inb07 IS NULL THEN LET g_inb[l_ac].inb07 =' ' END IF
           IF g_inb_t.inb07 IS NULL OR g_inb_t.inb07 <> g_inb[l_ac].inb07 THEN
              LET g_change='Y'
           END IF
           IF NOT cl_null(g_inb[l_ac].inb04) AND NOT cl_null(g_inb[l_ac].inb05) THEN
              IF NOT t270_chk_img() THEN NEXT FIELD inb05 END IF #FUN-C80107 add 121024
              #FUN-C80107 mark begin---------------------121024
              #SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
              # WHERE img01=g_inb[l_ac].inb04 AND img02=g_inb[l_ac].inb05
              #   AND img03=g_inb[l_ac].inb06 AND img04=g_inb[l_ac].inb07
              #IF (g_ina.ina00 MATCHES '[1256]' AND SQLCA.sqlcode!=0) OR
              #   (g_ina.ina00 MATCHES '[34]'   AND STATUS AND SQLCA.sqlcode!= 100) THEN
              #   CALL cl_err('sel img:',STATUS,0)
              #   NEXT FIELD inb06
              #END IF
              #IF (g_ina.ina00 MATCHES '[34]' AND SQLCA.sqlcode=100) THEN
              #   IF g_sma.sma892[3,3] = 'Y' THEN
              #      IF NOT cl_confirm('mfg1401') THEN
              #         NEXT FIELD inb04
              #      END IF
              #   END IF
              #   CALL s_add_img(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
              #                  g_inb[l_ac].inb06,g_inb[l_ac].inb07,
              #                  g_ina.ina01,g_inb[l_ac].inb03,g_ina.ina02)
              #   IF g_errno='N' THEN
              #      NEXT FIELD inb04
              #   END IF
              #   SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
              #    WHERE img01=g_inb[l_ac].inb04 AND img02=g_inb[l_ac].inb05
              #      AND img03=g_inb[l_ac].inb06 AND img04=g_inb[l_ac].inb07
              #END IF
              #IF cl_null(g_inb[l_ac].inb08) THEN
              #   LET g_inb[l_ac].inb08=g_img09
              #   DISPLAY BY NAME g_inb[l_ac].inb08    #MOD-640485    
              #   IF NOT cl_null(g_inb[l_ac].inb09) AND g_inb[l_ac].inb09<>0 THEN  #FUN-C20048 add
              #      CALL t270_inb09_check() RETURNING l_tf  #FUN-BB0085
              #   END IF                                                            #FUN-C20048 add
              #END IF
              #SELECT COUNT(*) INTO g_cnt FROM img_file
              # WHERE img01 = g_inb[l_ac].inb04   #料號
              #   AND img02 = g_inb[l_ac].inb05   #倉庫
              #   AND img03 = g_inb[l_ac].inb06   #儲位
              #   AND img04 = g_inb[l_ac].inb07   #批號
              #   AND img18 < g_ina.ina02         #調撥日期
              #IF g_cnt > 0 THEN                  #大于有效日期
              #   call cl_err('','aim-400',0)     #須修改
              #   NEXT FIELD inb07
              #END IF
              #FUN-C80107 mark end---------------------121024
              IF g_sma.sma115 = 'Y' THEN
                 CALL t270_du_default(p_cmd)
              END IF
              #FUN-BB0085-add-str--
              LET g_inb08_t = g_inb[l_ac].inb08
              IF NOT l_tf THEN  
                 NEXT FIELD inb09
              END IF 
              #FUN-BB0085-add-end--
           END IF
        AFTER FIELD inb08
           IF NOT cl_null(g_inb[l_ac].inb08) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_inb[l_ac].inb08
              IF STATUS THEN 
              #  CALL cl_err('gfe:',STATUS,0)   #No.FUN-660104
                 CALL cl_err3("sel","gfe_file",g_inb[l_ac].inb08,"",STATUS,"","gfe:",1)  #No.FUN-660104
                 NEXT FIELD inb08 
              END IF
              IF g_inb[l_ac].inb08=g_img09 THEN
                 LET g_inb[l_ac].inb08_fac =  1
              ELSE
                 CALL s_umfchk(g_inb[l_ac].inb04,g_inb[l_ac].inb08,g_img09)
                 RETURNING g_cnt,g_inb[l_ac].inb08_fac
                 IF g_cnt = 1 THEN
                    CALL cl_err('','mfg3075',0)
                    NEXT FIELD inb08
                 END IF
              END IF
              IF cl_null(g_inb[l_ac].inb04) THEN
                 NEXT FIELD inb04
              END IF
              IF g_inb_t.inb08 IS NULL OR g_inb_t.inb08 <> g_inb[l_ac].inb08 THEN
                 CALL t270_price(l_ac) RETURNING l_fac
                 IF l_fac THEN
                    NEXT FIELD inb08
                 END IF               
              END IF
              #FUN-BB0085-add-str--
              IF NOT cl_null(g_inb[l_ac].inb09) AND g_inb[l_ac].inb09<>0 THEN  #FUN-C20048 add
                 IF NOT t270_inb09_check() THEN 
                    LET g_inb08_t = g_inb[l_ac].inb08
                    NEXT FIELD inb09
                 END IF
              END IF                                                           #FUN-C20048 add
              LET g_inb08_t = g_inb[l_ac].inb08
              #FUN-BB0085-add-end--
           END IF
        AFTER FIELD inb08_fac
           IF NOT cl_null(g_inb[l_ac].inb08_fac) THEN
              IF g_inb[l_ac].inb08_fac=0 THEN
                 NEXT FIELD inb08_fac
              END IF
           END IF
        AFTER FIELD inb09
           IF NOT t270_inb09_check() THEN NEXT FIELD inb09 END IF    #FUN-BB0085
           #FUN-BB0085--mark--str-----
           #IF g_inb[l_ac].inb09=0 THEN
           #   CALL cl_err("","aim-120",0)
           #   NEXT FIELD inb09  
           #END IF
           #IF NOT cl_null(g_inb[l_ac].inb09) THEN
           #   IF g_inb_t.inb09 IS NULL OR g_inb_t.inb09 <> g_inb[l_ac].inb09 THEN
           #      IF g_sma.sma116!='2' AND g_sma.sma116!='3' THEN 
           #         LET g_inb[l_ac].inb1006=g_inb[l_ac].inb1003*g_inb[l_ac].inb09
           #      END IF
           #   END IF
           #   IF g_ina.ina00 MATCHES "[1256]" THEN
           #      SELECT img10 INTO g_img10 FROM img_file
           #         WHERE img01=g_inb[l_ac].inb04 AND img02=g_inb[l_ac].inb05
           #         AND img03=g_inb[l_ac].inb06 AND img04=g_inb[l_ac].inb07
           #      IF g_inb[l_ac].inb09*g_inb[l_ac].inb08_fac > g_img10 THEN
           #         IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN
           #            CALL cl_err(g_inb[l_ac].inb09*g_inb[l_ac].inb08_fac,'mfg1303',1)
           #           NEXT FIELD inb09  
           #         ELSE
           #            IF NOT cl_confirm('mfg3469') THEN
           #               NEXT FIELD inb09 
           #            END IF
           #         END IF
           #      END IF
           #   END IF
           #ELSE
           #   CALL cl_err("","aim-120",0)
           #   NEXT FIELD inb09                                       
           #END IF
           #IF g_change1='Y' THEN
           #   CALL t270_set_inb1005()
           #END IF
           #FUN-BB0085--mark--end-----
        BEFORE FIELD inb905
           CALL t270_set_no_required()
        AFTER FIELD inb905                       #第二單位
           IF cl_null(g_inb[l_ac].inb04) THEN NEXT FIELD inb04 END IF
           IF g_inb_t.inb905 IS NULL AND g_inb[l_ac].inb905 IS NOT NULL OR
              g_inb_t.inb905 IS NOT NULL AND g_inb[l_ac].inb905 IS NULL OR
              g_inb_t.inb905 <> g_inb[l_ac].inb905 THEN
              LET g_change1='Y'
           END IF
           IF g_inb[l_ac].inb05 IS NULL OR g_inb[l_ac].inb06 IS NULL OR
              g_inb[l_ac].inb07 IS NULL THEN
              NEXT FIELD inb07
           END IF
           IF NOT cl_null(g_inb[l_ac].inb905) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_inb[l_ac].inb905
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_inb[l_ac].inb905,"",STATUS,"","gfe:",1)  #No.FUN-660104
                 NEXT FIELD inb905
              END IF
              CALL s_du_umfchk(g_inb[l_ac].inb04,'','','',
                               g_img09,g_inb[l_ac].inb905,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_inb[l_ac].inb905,g_errno,0)
                 NEXT FIELD inb905
              END IF
              LET g_inb[l_ac].inb906 = g_factor
              CALL s_chk_imgg(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                              g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                              g_inb[l_ac].inb905) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_ina.ina00 MATCHES '[1256]' THEN
                    #FUN-C80107 modify begin---------------------------------------121024
                    #CALL cl_err('sel img:',STATUS,0)
                    #NEXT FIELD inb04
                   #FUN-D30024--modify--str-- 
                   #INITIALIZE g_sma894 TO NULL
                   #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_inb[l_ac].inb05) RETURNING g_sma894
                   #IF g_sma894 = 'N' THEN
                    INITIALIZE g_imd23 TO NULL
                    CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant
                    IF g_imd23 = 'N' THEN
                   #FUN-D30024--modify--end--
                       CALL cl_err('sel img:',STATUS,0)
                       NEXT FIELD inb04
                    END IF
                    #FUN-C80107 modify end-----------------------------------------121024
                 END IF
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN
                       NEXT FIELD inb905
                    END IF
                 END IF
                 CALL s_add_imgg(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                                 g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                                 g_inb[l_ac].inb905,g_inb[l_ac].inb906,
                                 g_ina.ina01,
                                 g_inb[l_ac].inb03,0) RETURNING g_flag
                 IF g_flag = 1 THEN
                    NEXT FIELD inb905
                 END IF
              END IF
           END IF
           CALL t270_set_required()
           CALL cl_show_fld_cont() 
           #FUN-BB0085-add-str--
           IF NOT cl_null(g_inb[l_ac].inb907) AND g_inb[l_ac].inb907<>0 THEN
              IF NOT t270_inb907_check(p_cmd) THEN 
                 LET g_inb905_t = g_inb[l_ac].inb905
                 NEXT FIELD inb907 
              END IF 
           END IF
           LET g_inb905_t = g_inb[l_ac].inb905
           #FUN-BB0085-add-end--                 
        BEFORE FIELD inb906                      #第二轉換率
           IF cl_null(g_inb[l_ac].inb04) THEN NEXT FIELD inb04 END IF
           IF g_inb[l_ac].inb05 IS NULL OR g_inb[l_ac].inb06 IS NULL OR
              g_inb[l_ac].inb07 IS NULL THEN
              NEXT FIELD inb07
           END IF
           IF NOT cl_null(g_inb[l_ac].inb905) AND g_ima906 = '3' THEN
              CALL s_chk_imgg(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                              g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                              g_inb[l_ac].inb905) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_ina.ina00 MATCHES '[1256]' THEN
                    #FUN-C80107 modify begin---------------------------------------121024
                    #CALL cl_err('sel img:',STATUS,0)
                    #NEXT FIELD inb04
                   #FUN-D30024--modify--str--
                   #INITIALIZE g_sma894 TO NULL
                   #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_inb[l_ac].inb05) RETURNING g_sma894
                   #IF g_sma894 = 'N' THEN
                    INITIALIZE g_imd23 TO NULL
                    CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant
                    IF g_imd23 = 'N' THEN
                   #FUN-D30024--modify--end-- 
                       CALL cl_err('sel img:',STATUS,0)
                       NEXT FIELD inb04
                    END IF
                    #FUN-C80107 modify end-----------------------------------------121024
                 END IF
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN
                       NEXT FIELD inb04
                    END IF
                 END IF
                 CALL s_add_imgg(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                                 g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                                 g_inb[l_ac].inb905,g_inb[l_ac].inb906,
                                 g_ina.ina01,
                                 g_inb[l_ac].inb03,0) RETURNING g_flag
                 IF g_flag = 1 THEN
                    NEXT FIELD inb04
                 END IF
              END IF
           END IF
        AFTER FIELD inb906                       #第二轉換率
           IF g_inb_t.inb906 IS NULL AND g_inb[l_ac].inb906 IS NOT NULL OR
              g_inb_t.inb906 IS NOT NULL AND g_inb[l_ac].inb906 IS NULL OR
              g_inb_t.inb906 <> g_inb[l_ac].inb906 THEN
              LET g_change1='Y'
           END IF
           IF NOT cl_null(g_inb[l_ac].inb906) THEN
              IF g_inb[l_ac].inb906=0 THEN
                 NEXT FIELD inb906
              END IF
           END IF
        BEFORE FIELD inb907
           IF cl_null(g_inb[l_ac].inb04) THEN NEXT FIELD inb04 END IF
           IF g_inb[l_ac].inb05 IS NULL OR g_inb[l_ac].inb06 IS NULL OR
              g_inb[l_ac].inb07 IS NULL THEN
              NEXT FIELD inb07
           END IF
           IF NOT cl_null(g_inb[l_ac].inb905) AND g_ima906 = '3' THEN
              CALL s_chk_imgg(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                              g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                              g_inb[l_ac].inb905) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_ina.ina00 MATCHES '[1256]' THEN
                    #FUN-C80107 modify begin---------------------------------------121024
                    #CALL cl_err('sel img:',STATUS,0)
                    #NEXT FIELD inb04
                   #FUN-D30024--modify--str--
                   #INITIALIZE g_sma894 TO NULL
                   #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_inb[l_ac].inb05) RETURNING g_sma894
                   #IF g_sma894 = 'N' THEN
                    INITIALIZE g_imd23 TO NULL
                    CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant
                    IF g_imd23 = 'N' THEN
                   #FUN-D30024--modify--end-- 
                       CALL cl_err('sel img:',STATUS,0)
                       NEXT FIELD inb04
                    END IF
                    #FUN-C80107 modify end-----------------------------------------121024
                 END IF
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN
                       NEXT FIELD inb04
                    END IF
                 END IF
                 CALL s_add_imgg(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                                 g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                                 g_inb[l_ac].inb905,g_inb[l_ac].inb906,
                                 g_ina.ina01,g_inb[l_ac].inb03,0)
                 RETURNING g_flag
                 IF g_flag = 1 THEN
                    NEXT FIELD inb04
                 END IF
              END IF
           END IF
        AFTER FIELD inb907                       #第二數量
           IF NOT t270_inb907_check(p_cmd) THEN NEXT FIELD inb907 END IF     #FUN-BB0085
           #FUN-BB0085--mark--str----
           #IF g_inb_t.inb907 IS NULL AND g_inb[l_ac].inb907 IS NOT NULL OR
           #   g_inb_t.inb907 IS NOT NULL AND g_inb[l_ac].inb907 IS NULL OR
           #   g_inb_t.inb907 <> g_inb[l_ac].inb907 THEN
           #   LET g_change1='Y'
           #END IF
           #IF NOT cl_null(g_inb[l_ac].inb907) THEN
           #   IF g_inb[l_ac].inb907 < 0 THEN
           #      CALL cl_err('','aim-391',0)  
           #      NEXT FIELD inb907                          
           #   END IF
           #   IF p_cmd = 'a' THEN
           #      IF g_ima906='3' THEN
           #         LET g_tot=g_inb[l_ac].inb907*g_inb[l_ac].inb906
           #         IF cl_null(g_inb[l_ac].inb904) OR g_inb[l_ac].inb904=0 THEN #CHI-960022
           #            LET g_inb[l_ac].inb904=g_tot*g_inb[l_ac].inb903
           #            DISPLAY BY NAME g_inb[l_ac].inb904                       #CHI-960022
           #         END IF                                                      #CHI-960011
           #      END IF
           #   END IF
           #   IF g_ima906 MATCHES '[23]' THEN
           #      SELECT imgg10 INTO g_imgg10_2 FROM imgg_file
           #       WHERE imgg01=g_inb[l_ac].inb04
           #         AND imgg02=g_inb[l_ac].inb05
           #         AND imgg03=g_inb[l_ac].inb06
           #         AND imgg04=g_inb[l_ac].inb07
           #         AND imgg09=g_inb[l_ac].inb905
           #   END IF
           #   IF NOT cl_null(g_inb[l_ac].inb905) THEN
           #      IF g_ina.ina00 MATCHES '[1256]' THEN
           #         IF g_sma.sma117 = 'N' THEN
           #            IF g_inb[l_ac].inb907 > g_imgg10_2 THEN
           #               IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN
           #                  CALL cl_err(g_inb[l_ac].inb907,'mfg1303',1)
           #                  NEXT FIELD inb907                         
           #               ELSE
           #                  IF NOT cl_confirm('mfg3469') THEN
           #                     NEXT FIELD inb907                          
           #                  ELSE
           #                     LET g_yes = 'Y'
           #                  END IF
           #               END IF
           #            END IF
           #         END IF
           #      END IF
           #   END IF
           #END IF
           #IF g_change1='Y' THEN
           #   CALL t270_set_inb1005()
           #END IF
           #CALL cl_show_fld_cont()                
           #FUN-BB0085--mark--end----
        BEFORE FIELD inb902
           CALL t270_set_no_required()
        AFTER FIELD inb902                       #第一單位
           IF cl_null(g_inb[l_ac].inb04) THEN NEXT FIELD inb04 END IF
           IF g_inb_t.inb902 IS NULL AND g_inb[l_ac].inb902 IS NOT NULL OR
              g_inb_t.inb902 IS NOT NULL AND g_inb[l_ac].inb902 IS NULL OR
              g_inb_t.inb902 <> g_inb[l_ac].inb902 THEN
              LET g_change1='Y'
           END IF
           IF g_inb[l_ac].inb05 IS NULL OR g_inb[l_ac].inb06 IS NULL OR
              g_inb[l_ac].inb07 IS NULL THEN
              NEXT FIELD inb07
           END IF
           IF NOT cl_null(g_inb[l_ac].inb902) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_inb[l_ac].inb902
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_inb[l_ac].inb902,"",STATUS,"","gfe:",1)  #No.FUN-660104
                 NEXT FIELD inb902
              END IF
              CALL s_du_umfchk(g_inb[l_ac].inb04,'','','',
                               g_inb[l_ac].inb08,g_inb[l_ac].inb902,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_inb[l_ac].inb902,g_errno,0)
                 NEXT FIELD inb902
              END IF
              LET g_inb[l_ac].inb903 = g_factor
              IF g_ima906 = '2' THEN
                 CALL s_chk_imgg(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                                 g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                                 g_inb[l_ac].inb902) RETURNING g_flag
                 IF g_flag = 1 THEN
                    IF g_ina.ina00 MATCHES '[1256]' THEN
                       #FUN-C80107 modify begin---------------------------------------121024
                       #CALL cl_err('sel img:',STATUS,0)
                       #NEXT FIELD inb04
                      #FUN-D30024--modify--str--
                      #INITIALIZE g_sma894 TO NULL
                      #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_inb[l_ac].inb05) RETURNING g_sma894
                      #IF g_sma894 = 'N' THEN
                       INITIALIZE g_imd23 TO NULL
                       CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant
                       IF g_imd23 = 'N' THEN
                      #FUN-D30024--modify--end-- 
                          CALL cl_err('sel img:',STATUS,0)
                          NEXT FIELD inb04
                       END IF
                       #FUN-C80107 modify end-----------------------------------------121024
                    END IF
                    IF g_sma.sma892[3,3] = 'Y' THEN
                       IF NOT cl_confirm('aim-995') THEN
                          NEXT FIELD inb902
                       END IF
                    END IF
                    CALL s_add_imgg(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                                    g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                                    g_inb[l_ac].inb902,g_inb[l_ac].inb903,
                                    g_ina.ina01,
                                    g_inb[l_ac].inb03,0) RETURNING g_flag
                    IF g_flag = 1 THEN
                       NEXT FIELD inb902
                    END IF
                 END IF
              END IF
              IF g_ima906 ='2' THEN
                 SELECT imgg10 INTO g_imgg10_1 FROM imgg_file
                  WHERE imgg01=g_inb[l_ac].inb04
                    AND imgg02=g_inb[l_ac].inb05
                    AND imgg03=g_inb[l_ac].inb06
                    AND imgg04=g_inb[l_ac].inb07
                    AND imgg09=g_inb[l_ac].inb902
              ELSE
                 SELECT img10 INTO g_imgg10_1 FROM img_file
                  WHERE img01=g_inb[l_ac].inb04
                    AND img02=g_inb[l_ac].inb05
                    AND img03=g_inb[l_ac].inb06
                    AND img04=g_inb[l_ac].inb07
              END IF
           END IF
           CALL t270_set_required()
           CALL cl_show_fld_cont()                  
           #FUN-BB0085-add-str--
           #CALL t270_inb904_check() RETURNING l_tf  #FUN-C20048 mark
           LET l_case = ""                                                    #FUN-C20048 add
           IF NOT cl_null(g_inb[l_ac].inb904) AND g_inb[l_ac].inb904<>0 THEN  #FUN-C20048 add
              CALL t270_inb904_check() RETURNING l_case                       #FUN-C20048 add
           END IF                                                             #FUN-C20048 add
           LET g_inb902_t = g_inb[l_ac].inb902
           CASE l_case
              WHEN "inb904"   NEXT FIELD inb904
              WHEN "inb907"   NEXT FIELD inb907
           END CASE
           #FUN-BB0085-add-end--
        AFTER FIELD inb903                       #第一轉換率
           IF g_inb_t.inb903 IS NULL AND g_inb[l_ac].inb903 IS NOT NULL OR
              g_inb_t.inb903 IS NOT NULL AND g_inb[l_ac].inb903 IS NULL OR
              g_inb_t.inb903 <> g_inb[l_ac].inb903 THEN
              LET g_change1='Y'
           END IF
           IF NOT cl_null(g_inb[l_ac].inb903) THEN
              IF g_inb[l_ac].inb903=0 THEN
                 NEXT FIELD inb903
              END IF
           END IF
        AFTER FIELD inb904                       #第一數量
           #FUN-BB0085--add-str--
           CALL t270_inb904_check() RETURNING l_case 
           CASE l_case
              WHEN "inb904"   NEXT FIELD inb904
              WHEN "inb907"   NEXT FIELD inb907
           END CASE 
           #FUN-BB0085--add-str--
           #FUN-BB0085--mark--str----
           #IF g_inb_t.inb904 IS NULL AND g_inb[l_ac].inb904 IS NOT NULL OR
           #   g_inb_t.inb904 IS NOT NULL AND g_inb[l_ac].inb904 IS NULL OR
           #   g_inb_t.inb904 <> g_inb[l_ac].inb904 THEN
           #   LET g_change1='Y'
           #END IF
           #IF NOT cl_null(g_inb[l_ac].inb904) THEN
           #   IF g_inb[l_ac].inb904 < 0 THEN
           #      CALL cl_err('','aim-391',0)  
           #      NEXT FIELD inb904                                
           #   END IF
           #   IF NOT cl_null(g_inb[l_ac].inb902) THEN
           #      IF g_ina.ina00 MATCHES '[1256]' THEN
           #         IF g_ima906 = '2' THEN
           #            IF g_sma.sma117 = 'N' THEN
           #               IF g_inb[l_ac].inb904 > g_imgg10_1 THEN
           #                  IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN
           #                     CALL cl_err(g_inb[l_ac].inb904,'mfg1303',1)
           #                     NEXT FIELD inb904                                
           #                  ELSE
           #                     IF NOT cl_confirm('mfg3469') THEN
           #                        NEXT FIELD inb904                                
           #                     ELSE
           #                        LET g_yes = 'Y'
           #                     END IF
           #                  END IF
           #               END IF
           #            END IF
           #         ELSE
           #            IF g_inb[l_ac].inb904 * g_inb[l_ac].inb903 > g_imgg10_1 THEN
           #               IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN
           #                  CALL cl_err(g_inb[l_ac].inb904,'mfg1303',1)
           #                  NEXT FIELD inb904                                   
           #               ELSE
           #                  IF NOT cl_confirm('mfg3469') THEN
           #                     NEXT FIELD inb904                           
           #                  ELSE
           #                     LET g_yes = 'Y'
           #                  END IF
           #               END IF
           #            END IF
           #         END IF
           #      END IF
           #   END IF
           #   CALL t270_du_data_to_correct()
           #   CALL t270_set_origin_field()
           #   IF g_inb[l_ac].inb09 IS NULL OR g_inb[l_ac].inb09=0 THEN
           #      IF g_ima906 MATCHES '[23]' THEN
           #         NEXT FIELD inb907                             
           #      ELSE
           #         NEXT FIELD inb904                                
           #      END IF
           #   END IF
           #END IF
           #IF g_change1='Y' THEN
           #   CALL t270_set_inb1005()
           #END IF
           #CALL cl_show_fld_cont()                  
           #FUN-BB0085--mark--end----
        BEFORE FIELD inb1004
              CALL t270_du_data_to_correct()
              CALL t270_set_origin_field()
              IF g_inb[l_ac].inb09 IS NULL OR g_inb[l_ac].inb09=0 THEN
                 IF g_ima906 MATCHES '[23]' THEN
                    NEXT FIELD inb907                        
                 ELSE
                    NEXT FIELD inb904                             
                 END IF
              END IF
        #TQC-D20031---add---str---
        BEFORE FIELD inb15
           IF g_aza.aza115 = 'Y' AND cl_null(g_inb[l_ac].inb15)THEN
              CALL s_reason_code(g_ina.ina01,g_ina.ina10,'',g_inb[l_ac].inb04,g_inb[l_ac].inb05,g_ina.ina11,g_ina.ina04) RETURNING g_inb[l_ac].inb15
              DISPLAY BY NAME g_inb[l_ac].inb15
           END IF
        #TQC-D20031---add---end---
        AFTER FIELD inb15
            LET g_buf=NULL 
           #TQC-D20031---add---str---
            IF g_aza.aza15 = 'Y' THEN
               IF t270_inb15_check() THEN  
                  CALL t270_azf03_desc()     #TQC-D20047
               ELSE 
                  NEXT FIELD inb15
               END IF  
            ELSE
           #TQC-D20031---add---end---
               IF NOT cl_null(g_inb[l_ac].inb15) THEN      
                  SELECT count(*) INTO l_n FROM azf_file
                   WHERE azf01=g_inb[l_ac].inb15 AND azf09='4' AND azfacti='Y'  
                     AND azf02 = '2'                                           #TQC-C50038 add
                  IF l_n = 0 THEN                                                                                                      
                     CALL cl_err('',100,0)                                                                                             
                     LET g_inb[l_ac].inb15 = g_inb_t.inb15                                                                                                                                                                           
                     NEXT FIELD inb15                                                                                                 
                  END IF         
                  SELECT azf03 INTO g_inb[l_ac].azf03 FROM azf_file
                   WHERE azf01=g_inb[l_ac].inb15 AND azf09='4' AND azfacti='Y' 
                     AND azf02 = '2'                                            #TQC-C50038 add
                  IF STATUS THEN
                     CALL cl_err3("sel","azf_file",g_inb[l_ac].inb15,"",STATUS,"","select azf",1)  #No.FUN-660104     #No.FUN-6B0065
                  ELSE 
                    DISPLAY g_inb[l_ac].inb15 TO inb15 
                  END IF                               
               END IF
            END IF   #TQC-D20031
    #判斷理由碼是否為"失效",失效情況下則不能輸入
            SELECT azfacti INTO acti FROM azf_file WHERE azf01 = g_inb[l_ac].inb15     #No.FUN-6B0065
            IF acti <> 'Y' THEN
#               CALL cl_err('','apy-541',1)      #CHI-B40058
               CALL cl_err('','aim-163',1)       #CHI-B40058
               LET acti = ""
               NEXT FIELD inb15
            END IF
       AFTER FIELD inb901          
          IF NOT cl_null(g_inb[l_ac].inb901) THEN
             SELECT coc10 INTO l_coc10 FROM coc_file
              WHERE coc03 = g_inb[l_ac].inb901
             IF STATUS THEN
                CALL cl_err3("sel","coc_file",g_inb[l_ac].inb901,"","aco-062","","",1)  #No.FUN-660104
                NEXT FIELD inb901
             END IF
             SELECT ima08 INTO l_ima08 FROM ima_file
              WHERE ima01 = g_inb[l_ac].inb04
             #檢查成品檔
             IF l_ima08 MATCHES '[MS]' THEN
                SELECT COUNT(*) INTO l_cnt FROM coc_file,cod_file,coa_file
                 WHERE coc01 = cod01 AND cod03 = coa03
                   AND coa05 = l_coc10
                   AND coa01 = g_inb[l_ac].inb04
                   AND coc03 = g_inb[l_ac].inb901
             END IF
             #檢查材料檔
             IF l_ima08 = 'P' THEN
                SELECT COUNT(*) INTO l_cnt FROM coc_file,coe_file,coa_file
                 WHERE coc01 = coe01 AND coe03 = coa03
                   AND coa05 = l_coc10
                   AND coa01 = g_inb[l_ac].inb04
                   AND coc03 = g_inb[l_ac].inb901
             END IF
             IF l_cnt = 0 THEN
                CALL cl_err(g_inb[l_ac].inb901,'aco-073',0)
                NEXT FIELD inb901
             END IF
          END IF
        BEFORE FIELD inb1003
           CALL t270_set_entry_b()                                                                                                  
           CALL t270_set_no_entry_b()     
        AFTER FIELD inb1004
           IF g_inb_t.inb1004 IS NULL AND g_inb[l_ac].inb1004 IS NOT NULL OR
              g_inb_t.inb1004 IS NOT NULL AND g_inb[l_ac].inb1004 IS NULL OR
              g_inb_t.inb1004 <> g_inb[l_ac].inb1004 THEN
              LET g_change1='Y'
           END IF
           IF NOT cl_null(g_inb[l_ac].inb1004) THEN            
              CALL s_du_umfchk(g_inb[l_ac].inb04,'','','',
                               g_img09,g_inb[l_ac].inb1004,'1')
              RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_inb[l_ac].inb1004,g_errno,0)
                 NEXT FIELD inb1004
              END IF
              IF cl_null(g_inb[l_ac].inb04) THEN
                 NEXT FIELD inb04
              END IF
              IF g_inb_t.inb1004 IS NULL OR g_inb_t.inb1004 <> g_inb[l_ac].inb1004 THEN
                 CALL t270_price(l_ac) RETURNING l_fac
                 IF l_fac THEN
                    NEXT FIELD inb1004
                 END IF                              
              END IF
              #FUN-BB0085-add-str--
              IF NOT t270_inb1005_check() THEN 
                 LET g_inb1004_t = g_inb[l_ac].inb1004
                 NEXT FIELD inb1005
              END IF
              LET g_inb1004_t = g_inb[l_ac].inb1004
              #FUN-BB0085-add-str--
           END IF
        BEFORE FIELD inb1005         
           IF g_change1='Y' THEN
              CALL t270_set_inb1005()
           END IF
        AFTER FIELD inb1005         
           IF NOT t270_inb1005_check() THEN NEXT FIELD inb1005 END IF    #FUN-BB0085
           #FUN-BB0085--mark--str----
           #IF g_inb[l_ac].inb1005<0 THEN
           #   CALL cl_err('','anm-249',0) NEXT FIELD inb1005
           #END IF
           #IF NOT cl_null(g_inb[l_ac].inb1005) THEN
           #   IF g_inb_t.inb1005 IS NULL OR g_inb_t.inb1005 <> g_inb[l_ac].inb1005 THEN
           #      LET g_inb[l_ac].inb1006=g_inb[l_ac].inb1003*g_inb[l_ac].inb1005
           #   END IF
           #END IF   
           #FUN-BB0085--mark--end----
        AFTER FIELD inb1002         
           IF NOT cl_null(g_inb[l_ac].inb1002) THEN  
              SELECT count(*) INTO l_n FROM tqx_file,tqy_file,tqz_file,tsa_file
               WHERE tqx01 = tqy01 AND tqx01 = tqz01 AND tqx01 = tsa01 
                 AND tqy02 = tsa02
                 AND tqz02 = tsa03 AND tqy03 = g_ina.ina1001 and tqy37='Y' 
                 AND tqx07='3'
              IF l_n = 0 THEN                                                                                                      
                 CALL cl_err('',100,0)                                                                                             
                 LET g_inb[l_ac].inb1002 = g_inb_t.inb1002                                                                                                                                                                           
                 NEXT FIELD inb1002     
              END IF 
           END IF    
           CALL t270_price(l_ac) RETURNING l_fac
           IF l_fac THEN
              NEXT FIELD inb1002
           END IF
        BEFORE FIELD inb1006
          IF g_sma.sma116!='2' AND g_sma.sma116!='3' THEN 
             LET g_inb[l_ac].inb1006=g_inb[l_ac].inb1003*g_inb[l_ac].inb09
          ELSE
             LET g_inb[l_ac].inb1006=g_inb[l_ac].inb1003*g_inb[l_ac].inb1005
          END IF
        BEFORE DELETE                            #是否取消單身
          IF g_inb_t.inb03 > 0 AND g_inb_t.inb03 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             CALL s_iqctype_inb(g_ina.ina01,g_inb_t.inb03) RETURNING l_inb01,l_inb03,l_inb46,l_inb48,l_inb47,l_flagg   #FUN-BC0104
             DELETE FROM inb_file
              WHERE inb01 = g_ina.ina01 AND inb03 = g_inb_t.inb03
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","inb_file",g_inb_t.inb03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
                ROLLBACK WORK
                CANCEL DELETE
#FUN-B70074-add-delete--
             ELSE 
                #FUN-BC0104-add-str--
                IF l_flagg = 'Y' THEN
                   CALL s_qcl05_sel(l_inb46) RETURNING l_qcl05
                   IF l_qcl05='1' THEN LET l_type1='6' ELSE LET l_type1='4' END IF
                   IF NOT s_iqctype_upd_qco20(l_inb01,l_inb03,l_inb48,l_inb47,l_type1) THEN 
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF 
                END IF
                #FUN-BC0104-add-end--
                IF NOT s_industry('std') THEN 
                   IF NOT s_del_inbi(g_ina.ina01,g_inb_t.inb03,'') THEN 
                      ROLLBACK WORK
                      CANCEL DELETE  
                   END IF 
                END IF
#FUN-B70074-add-end--
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2
             LET l_ina08 = '0'         
             COMMIT WORK
             CALL t270_weight_cubage(g_ina.ina01)                                                                                            
             CALL t270_ina_sum()       
          END IF
        ON ROW CHANGE
           IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_inb[l_ac].* = g_inb_t.*
               CLOSE t270_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF

            #TQC-D20031---add---str---
            IF NOT t270_inb15_check() THEN
               NEXT FIELD inb15
            END IF 
            #TQC-D20031---add---end---
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_inb[l_ac].inb03,-263,1)
               LET g_inb[l_ac].* = g_inb_t.*
            ELSE
               IF NOT t270_chk_img() THEN NEXT FIELD inb04 END IF #FUN-C80107 add 121024
               IF g_sma.sma115 = 'Y' THEN
                  CALL s_chk_va_setting(g_inb[l_ac].inb04)
                       RETURNING g_flag,g_ima906,g_ima907
                  IF g_flag=1 THEN
                     NEXT FIELD inb04
                  END IF
                  CALL t270_du_data_to_correct()
                  IF t270_qty_issue() THEN
                     IF g_ima906 MATCHES '[23]' THEN
                        NEXT FIELD inb907                                  
                     ELSE
                        NEXT FIELD inb904                                   
                     END IF
                  END IF
                  CALL t270_set_origin_field()
               END IF
               CALL t270_b_move_back()
               CALL t270_b_else()
               UPDATE inb_file SET * = b_inb.*
                WHERE inb01=g_ina.ina01 AND inb03=g_inb_t.inb03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","inb_file",g_inb_t.inb03,"",SQLCA.sqlcode,"","upd inb",1)  #No.FUN-660104
                  LET g_inb[l_ac].* = g_inb_t.*
               ELSE
                  #FUN-BC0104-add-str--
                  CALL s_iqctype_inb(g_ina.ina01,g_inb_t.inb03) RETURNING l_inb01,l_inb03,l_inb46,l_inb48,l_inb47,l_flagg
                  IF l_flagg = 'Y' THEN
                     CALL s_qcl05_sel(l_inb46) RETURNING l_qcl05
                     IF l_qcl05='1' THEN LET l_type1='6' ELSE LET l_type1='4' END IF
                     IF NOT s_iqctype_upd_qco20(l_inb01,l_inb03,l_inb48,l_inb47,l_type1) THEN
                        ROLLBACK WORK
                        RETURN 
                     END IF
                  END IF
                  #FUN-BC0104-add-end--
                  MESSAGE 'UPDATE O.K'
                  LET l_ina08 = '0'        
	          COMMIT WORK
                  CALL t270_weight_cubage(g_ina.ina01)                                                                                            
                  CALL t270_ina_sum()       
               END IF
            END IF
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30033 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_inb[l_ac].* = g_inb_t.*
               ELSE                            
                 #INITIALIZE g_inb[l_ac].* TO NULL  #FUN-D30033 mark
                 #FUN-D30033--add--begin--
                  CALL g_inb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
                 #FUN-D30033--add--end----
               END IF
               CLOSE t270_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            #TQC-D20031---add---str---
            IF NOT t270_inb15_check() THEN
               NEXT FIELD inb15
            END IF 
            #TQC-D20031---add---end---
            LET l_ac_t = l_ac #FUN-D30033 add
            CLOSE t270_bcl
            COMMIT WORK
        ON ACTION CONTROLO                       #沿用所有欄位
           IF INFIELD(inb03) AND l_ac > 1 THEN
              LET l_inb03_o=g_inb[l_ac].inb03    #MOD-640049 #保留原序號 
              LET g_inb[l_ac].* = g_inb[l_ac-1].*
              LET g_inb[l_ac].inb03=l_inb03_o    #MOD-640049     
              NEXT FIELD inb03
           END IF
        ON ACTION controlp
           CASE
              #新增的母料件開窗
              #這里只需要處理g_sma.sma908='Y'的情況,因為不允許單身新增子料件則在前面
              #BEFORE FIELD att00來做開窗了            
              #需注意的是其條件限制是要開多屬性母料件且母料件的屬性組等于當前屬性組
                WHEN INFIELD(att00)
                     #可以新增子料件,開窗是單純的選取母料件
#FUN-AA0059---------mod------------str-----------------
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form ="q_ima_p"
#                    LET g_qryparam.arg1 = lg_group
#                    CALL cl_create_qry() RETURNING g_inb[l_ac].att00
                     CALL q_sel_ima(FALSE, "q_ima_p","","",lg_group,"","","","",'' ) 
                        RETURNING g_inb[l_ac].att00  
#FUN-AA0059---------mod------------end-----------------
                     DISPLAY BY NAME g_inb[l_ac].att00      
                     NEXT FIELD att00              
                WHEN INFIELD(inb04)
#FUN-AA0059---------mod------------str-----------------
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form ="q_ima01"
#                    LET g_qryparam.default1 = g_inb[l_ac].inb04
#                    CALL cl_create_qry() RETURNING g_inb[l_ac].inb04
                     CALL q_sel_ima(FALSE, "q_ima01","",g_inb[l_ac].inb04,"","","","","",'' ) 
                       RETURNING g_inb[l_ac].inb04  
#FUN-AA0059---------mod------------end-----------------
                     DISPLAY BY NAME g_inb[l_ac].inb04   
                     NEXT FIELD inb04
                WHEN INFIELD(inb05) OR INFIELD(inb06) OR INFIELD(inb07)            
                     IF g_argv1 MATCHES '[135]' THEN
                        LET g_imd10='S'
                     ELSE
                        LET g_imd10='W'
                     END IF
                     #FUN-C30300---begin
                     LET g_ima906 = NULL
                     SELECT ima906 INTO g_ima906 FROM ima_file
                      WHERE ima01 = g_inb[l_ac].inb04
                     #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                     IF s_industry("icd") THEN  #TQC-C60028
                        CALL q_idc(FALSE,FALSE,g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                                               g_inb[l_ac].inb06,g_inb[l_ac].inb07)
                         RETURNING g_inb[l_ac].inb05,g_inb[l_ac].inb06,g_inb[l_ac].inb07
                     ELSE
                     #FUN-C30300---end
                        CALL q_img4(FALSE,FALSE,g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                                    g_inb[l_ac].inb06,g_inb[l_ac].inb07,g_imd10)                                   
                        RETURNING g_inb[l_ac].inb05,g_inb[l_ac].inb06,g_inb[l_ac].inb07
                     END IF  #FUN-C30300 
                     IF cl_null(g_inb[l_ac].inb05) THEN LET g_inb[l_ac].inb05 = ' ' END IF
                     IF cl_null(g_inb[l_ac].inb06) THEN LET g_inb[l_ac].inb06 = ' ' END IF
                     IF cl_null(g_inb[l_ac].inb07) THEN LET g_inb[l_ac].inb07 = ' ' END IF                   
                     DISPLAY g_inb[l_ac].inb05 TO inb05
                     DISPLAY g_inb[l_ac].inb06 TO inb06
                     DISPLAY g_inb[l_ac].inb07 TO inb07             
                     IF INFIELD(inb05) THEN NEXT FIELD inb05 END IF
                     IF INFIELD(inb06) THEN NEXT FIELD inb06 END IF
                     IF INFIELD(inb07) THEN NEXT FIELD inb07 END IF
                WHEN INFIELD(inb08)              #單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_inb[l_ac].inb08
                     CALL cl_create_qry() RETURNING g_inb[l_ac].inb08
                     DISPLAY BY NAME g_inb[l_ac].inb08       
                     NEXT FIELD inb08
                WHEN INFIELD(inb902)             #單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_inb[l_ac].inb902
                     CALL cl_create_qry() RETURNING g_inb[l_ac].inb902
                     DISPLAY BY NAME g_inb[l_ac].inb902
                     NEXT FIELD inb902
                WHEN INFIELD(inb905)             #單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_inb[l_ac].inb905
                     CALL cl_create_qry() RETURNING g_inb[l_ac].inb905
                     DISPLAY BY NAME g_inb[l_ac].inb905
                     NEXT FIELD inb905              
                WHEN INFIELD(inb15)              #理由             
                   #TQC-D20031---add---str---
                     IF g_aza.aza115='Y' THEN
                        CALL s_get_where(g_ina.ina01,g_ina.ina10,'',g_inb[l_ac].inb04,g_inb[l_ac].inb05,g_ina.ina11,g_ina.ina04) RETURNING l_flag1,l_where
                        IF l_flag1 THEN
                           CALL cl_init_qry_var()
                           LET g_qryparam.form     ="q_ggc08"
                           LET g_qryparam.where = l_where
                           LET g_qryparam.default1 = g_inb[l_ac].inb15
                        ELSE
                           CALL cl_init_qry_var()
                           LET g_qryparam.form     ="q_azf41"
                           LET g_qryparam.default1 = g_inb[l_ac].inb15
                        END IF
                        CALL cl_create_qry() RETURNING g_inb[l_ac].inb15
                        DISPLAY BY NAME g_inb[l_ac].inb15
                        CALL t270_azf03_desc()     #TQC-D20047
                        NEXT FIELD inb15
                     ELSE 
                   #TQC-D20031---add---end---
                        CALL cl_init_qry_var()
                        LET g_qryparam.form ="q_azf01"     #No.FUN-6B0065
                        LET g_qryparam.default1 = g_inb[l_ac].inb15
                        LET g_qryparam.where = " azf02 = '2' "   #TQC-C50038 add         
                        LET g_qryparam.arg1 = "4"
                        CALL cl_create_qry() RETURNING g_inb[l_ac].inb15                   
                        DISPLAY BY NAME g_inb[l_ac].inb15        
                        NEXT FIELD inb15
                     END IF     #TQC-D20031
                WHEN INFIELD(inb901)
                     SELECT ima08 INTO l_ima08 FROM ima_file
                      WHERE ima01 = g_inb[l_ac].inb04
                     IF STATUS THEN
                        LET l_ima08 = ''
                     END IF
                     IF l_ima08 = 'M' THEN LET l_type = '0' END IF
                     IF l_ima08 = 'P' THEN LET l_type = '1' END IF
                     CALL q_coc2(FALSE,FALSE,g_inb[l_ac].inb901,'',g_ina.ina02,
                                 l_type,'',g_inb[l_ac].inb04)
                     RETURNING g_inb[l_ac].inb901,l_coc04
                     DISPLAY BY NAME g_inb[l_ac].inb901        
                     NEXT FIELD inb901
                WHEN INFIELD(inb1002)                                                                                               
                     CALL cl_init_qry_var()                                                                                           
                     LET g_qryparam.form ="q_tqx2"                                                                                    
                     LET g_qryparam.default1 = g_inb[l_ac].inb1002   
                     LET g_qryparam.arg1 = g_ina.ina1001                                                                                
                     LET g_qryparam.arg2 = g_inb[l_ac].inb04
                     CALL cl_create_qry() RETURNING g_inb[l_ac].inb1002                                                                 
                     DISPLAY BY NAME g_inb[l_ac].inb1002
                     NEXT FIELD inb1002                               
                WHEN INFIELD(inb1004)                                                                                               
                     CALL cl_init_qry_var()                                                                                         
                     LET g_qryparam.form ="q_gfe"                                                                                  
                     LET g_qryparam.default1 = g_inb[l_ac].inb1004   
                     CALL cl_create_qry() RETURNING g_inb[l_ac].inb1004 
                     DISPLAY BY NAME g_inb[l_ac].inb1004
                     NEXT FIELD inb1004          
           END CASE
        ON ACTION q_imd                          #查詢倉庫
#No.FUN-AA0062  --Begin
#           CALL cl_init_qry_var()
#           LET g_qryparam.form ="q_imd"
#           LET g_qryparam.default1  = g_inb[l_ac].inb05
#           LET g_qryparam.arg1     = 'SW'        #倉庫類別 
#           CALL cl_create_qry() RETURNING g_inb[l_ac].inb05
           CALL q_imd_1(FALSE,TRUE,g_inb[l_ac].inb05,"","","","") RETURNING g_inb[l_ac].inb05
#No.FUN-AA0062  --End
           NEXT FIELD inb05
        ON ACTION q_ime                          #查詢倉庫儲位
#No.FUN-AA0062  --Begin
#           CALL cl_init_qry_var()
#           LET g_qryparam.form ="q_ime1"
#           LET g_qryparam.arg1     = 'SW'        #倉庫類別 
#           LET g_qryparam.default1 = g_inb[l_ac].inb05
#           LET g_qryparam.default2 = g_inb[l_ac].inb06
#           CALL cl_create_qry() RETURNING g_inb[l_ac].inb05,g_inb[l_ac].inb06 #MOD-4A0063
           CALL q_ime_2(FALSE,TRUE,g_inb[l_ac].inb05,g_inb[l_ac].inb06,"","") 
             RETURNING g_inb[l_ac].inb05,g_inb[l_ac].inb06
#No.FUN-AA0062  --End             
           NEXT FIELD inb05
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG CALL cl_cmdask()
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode())
           RETURNING g_fld_name,g_frm_name 
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
        ON ACTION about         
           CALL cl_about()     
        ON ACTION help         
           CALL cl_show_help() 
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
    END INPUT
    UPDATE ina_file SET inamodu=g_user,inadate=g_today,ina08=l_ina08
     WHERE ina01=g_ina.ina01
    LET g_ina.ina08 = l_ina08
#    DISPLAY BY NAME g_ina.ina08                             #FUN-B30029 mark
    IF g_ina.inapost = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF
    IF g_ina.ina08 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF 
    CALL cl_set_field_pic("",g_chr2,g_ina.inapost,"",g_void,"") 
    SELECT COUNT(*) INTO g_cnt FROM inb_file WHERE inb01=g_ina.ina01
    CLOSE t270_bcl
    COMMIT WORK
    CALL t270_weight_cubage(g_ina.ina01)
    CALL t270_ina_sum()              
    CALL t270_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t270_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
     CALL s_get_doc_no(g_ina.ina01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM ina_file ",
                  "  WHERE ina01 LIKE '",l_slip,"%' ",
                  "    AND ina01 > '",g_ina.ina01,"'"
      PREPARE t270_pb1 FROM l_sql 
      EXECUTE t270_pb1 INTO l_cnt
      
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
         IF cl_chk_act_auth() THEN
            CALL t270_x(1)
            IF g_ina.inapost = 'X' THEN
               LET g_void = 'Y'
            ELSE
               LET g_void = 'N'
            END IF
            IF g_ina.ina08 = '1' THEN
               LET g_chr2='Y'
            ELSE
               LET g_chr2='N'
            END IF
            CALL cl_set_field_pic("",g_chr2,g_ina.inapost,"",g_void,"")
         END IF
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end 
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM ina_file WHERE ina01=g_ina.ina01
         INITIALIZE g_ina.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t270_b_move_to()
   LET g_inb[l_ac].inb03     = b_inb.inb03
   LET g_inb[l_ac].inb04     = b_inb.inb04
   LET g_inb[l_ac].inb05     = b_inb.inb05
   LET g_inb[l_ac].inb06     = b_inb.inb06
   LET g_inb[l_ac].inb07     = b_inb.inb07
   LET g_inb[l_ac].inb08     = b_inb.inb08
   LET g_inb[l_ac].inb08_fac = b_inb.inb08_fac
   LET g_inb[l_ac].inb09     = b_inb.inb09
   LET g_inb[l_ac].inb902    = b_inb.inb902
   LET g_inb[l_ac].inb903    = b_inb.inb903
   LET g_inb[l_ac].inb904    = b_inb.inb904
   LET g_inb[l_ac].inb905    = b_inb.inb905
   LET g_inb[l_ac].inb906    = b_inb.inb906
   LET g_inb[l_ac].inb907    = b_inb.inb907
   LET g_inb[l_ac].inb11     = b_inb.inb11
   LET g_inb[l_ac].inb12     = b_inb.inb12
   LET g_inb[l_ac].inb15     = b_inb.inb15
   LET g_inb[l_ac].inb901    = b_inb.inb901 
   LET g_inb[l_ac].inb10     = b_inb.inb10 
   LET g_inb[l_ac].inb1001   = b_inb.inb1001 
   LET g_inb[l_ac].inb1002   = b_inb.inb1002 
   LET g_inb[l_ac].inb1003   = b_inb.inb1003 
   LET g_inb[l_ac].inb1004   = b_inb.inb1004 
   LET g_inb[l_ac].inb1005   = b_inb.inb1005 
   LET g_inb[l_ac].inb1006   = b_inb.inb1006 
END FUNCTION
FUNCTION t270_b_move_back()
   IF g_inb[l_ac].inb11  IS NULL  THEN LET g_inb[l_ac].inb11 = ' ' END IF
   IF g_inb[l_ac].inb12  IS NULL  THEN LET g_inb[l_ac].inb12 = ' ' END IF
   IF g_inb[l_ac].inb901 IS NULL  THEN LET g_inb[l_ac].inb901= ' ' END IF
   LET b_inb.inb03     = g_inb[l_ac].inb03
   LET b_inb.inb04     = g_inb[l_ac].inb04
   LET b_inb.inb05     = g_inb[l_ac].inb05
   LET b_inb.inb06     = g_inb[l_ac].inb06
   LET b_inb.inb07     = g_inb[l_ac].inb07
   LET b_inb.inb08     = g_inb[l_ac].inb08
   LET b_inb.inb08_fac = g_inb[l_ac].inb08_fac
   LET b_inb.inb09     = g_inb[l_ac].inb09
   LET b_inb.inb902    = g_inb[l_ac].inb902
   LET b_inb.inb903    = g_inb[l_ac].inb903
   LET b_inb.inb904    = g_inb[l_ac].inb904
   LET b_inb.inb905    = g_inb[l_ac].inb905
   LET b_inb.inb906    = g_inb[l_ac].inb906
   LET b_inb.inb907    = g_inb[l_ac].inb907
   LET b_inb.inb11     = g_inb[l_ac].inb11
   LET b_inb.inb12     = g_inb[l_ac].inb12
   LET b_inb.inb15     = g_inb[l_ac].inb15
   LET b_inb.inb901    = g_inb[l_ac].inb901 
   LET b_inb.inb10     = g_inb[l_ac].inb10  
   LET b_inb.inb1001   = g_inb[l_ac].inb1001  
   LET b_inb.inb1002   = g_inb[l_ac].inb1002  
   LET b_inb.inb1003   = g_inb[l_ac].inb1003  
   LET b_inb.inb1004   = g_inb[l_ac].inb1004  
   LET b_inb.inb1005   = g_inb[l_ac].inb1005  
   LET b_inb.inb1006   = g_inb[l_ac].inb1006  
END FUNCTION
FUNCTION t270_b_else()
   IF g_inb[l_ac].inb05 IS NULL THEN LET g_inb[l_ac].inb05 =' ' END IF
   IF g_inb[l_ac].inb06 IS NULL THEN LET g_inb[l_ac].inb06 =' ' END IF
   IF g_inb[l_ac].inb07 IS NULL THEN LET g_inb[l_ac].inb07 =' ' END IF
END FUNCTION
FUNCTION t270_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
    CONSTRUCT l_wc2 ON inb03,inb04,inb05,inb06,inb07,inb901
         FROM s_inb[1].inb03,s_inb[1].inb04,s_inb[1].inb05,
              s_inb[1].inb06,s_inb[1].inb07,
              s_inb[1].inb901 
       BEFORE CONSTRUCT
           CALL cl_qbe_init()           #No.FUN-580031
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
       ON ACTION about        
          CALL cl_about()    
       ON ACTION help         
          CALL cl_show_help()  
       ON ACTION controlg      
          CALL cl_cmdask()    
       ON ACTION qbe_select               
           CALL cl_qbe_select()             
       ON ACTION qbe_save               
           CALL cl_qbe_save()            
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t270_b_fill(l_wc2)
END FUNCTION
FUNCTION t270_b_fill(p_wc2)                      #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(400)
    LET g_sql =
#       "SELECT inb03,inb15,' ',inb04,",       #TQC-D20031 mark
        "SELECT inb03,inb04,",             #TQC-D20031 add
        "       '','','','','','','','','','','','','','','','','','','','','',",#No.TQC-650094
        "       ima02,ima021,ima1002,ima135,inb05,",
        "       inb06,inb07,inb08,inb08_fac,",    
        "       inb09,inb905,inb906,inb907,inb902,inb903,inb904,",          
        "       inb1004,inb1005,inb1002,inb1001,inb1003,inb1006,", 
        "       inb11,inb12,inb901,inb10,inb15,' ' ", #TQC-D20031 add inb15,' '
        " FROM inb_file LEFT OUTER JOIN ima_file ON inb04 = ima01 ", #091021
        " WHERE inb01 ='",g_ina.ina01,"'",       #單頭
        "    AND ",p_wc2 CLIPPED,  #單身  #091021
        " ORDER BY inb03"
    PREPARE t270_pb FROM g_sql
    DECLARE inb_curs CURSOR FOR t270_pb
    DISPLAY "g_sql=",g_sql
    CALL g_inb.clear()
    LET g_cnt = 1
    FOREACH inb_curs INTO g_inb[g_cnt].*         #單身 ARRAY 填充
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF
#      SELECT DISTINCT(azf03) INTO g_inb[g_cnt].azf03 FROM azf_file            #TQC-D20067 mark
#           WHERE azf09='4' AND azfacti='Y' AND azf01=g_inb[g_cnt].inb15       #TQC-D20067 mark
       #TQC-D20067---add---str---
       IF g_aza.aza115 = 'Y' THEN
          SELECT azf03 INTO g_inb[g_cnt].azf03 FROM azf_file
            WHERE azfacti='Y' AND azf01=g_inb[g_cnt].inb15 AND azf02='2'
       ELSE
          SELECT azf03 INTO g_inb[g_cnt].azf03 FROM azf_file
            WHERE azf09='4' AND azfacti='Y' AND azf01=g_inb[g_cnt].inb15 AND azf02='2'
       END IF
       #TQC-D20067---add---end---
       #如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改
       IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN              
          #得到該料件對應的父料件和所有屬性
          SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,
                 imx07,imx08,imx09,imx10 INTO
                 g_inb[g_cnt].att00,g_inb[g_cnt].att01,g_inb[g_cnt].att02,
                 g_inb[g_cnt].att03,g_inb[g_cnt].att04,g_inb[g_cnt].att05,
                 g_inb[g_cnt].att06,g_inb[g_cnt].att07,g_inb[g_cnt].att08,
                 g_inb[g_cnt].att09,g_inb[g_cnt].att10
            FROM imx_file WHERE imx000 = g_inb[g_cnt].inb04
          LET g_inb[g_cnt].att01_c = g_inb[g_cnt].att01
          LET g_inb[g_cnt].att02_c = g_inb[g_cnt].att02
          LET g_inb[g_cnt].att03_c = g_inb[g_cnt].att03
          LET g_inb[g_cnt].att04_c = g_inb[g_cnt].att04
          LET g_inb[g_cnt].att05_c = g_inb[g_cnt].att05
          LET g_inb[g_cnt].att06_c = g_inb[g_cnt].att06
          LET g_inb[g_cnt].att07_c = g_inb[g_cnt].att07
          LET g_inb[g_cnt].att08_c = g_inb[g_cnt].att08
          LET g_inb[g_cnt].att09_c = g_inb[g_cnt].att09
          LET g_inb[g_cnt].att10_c = g_inb[g_cnt].att10
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_inb.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    CALL t270_refresh_detail()  #No.TQC-650094   刷新單身的欄位顯示
END FUNCTION
FUNCTION t270_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_inb TO s_inb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
      LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()              
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
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL t270_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                 
      ON ACTION previous
         CALL t270_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                  
      ON ACTION jump
         CALL t270_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                  
      ON ACTION next
         CALL t270_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                  
      ON ACTION last
         CALL t270_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                 
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
         CALL cl_show_fld_cont()                  
         CALL t270_mu_ui()   #TQC-710032
         IF g_ina.inapost = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
        IF g_ina.ina08 = '1' THEN
            LET g_chr2='Y'
        ELSE
            LET g_chr2='N'
        END IF
        CALL cl_set_field_pic("",g_chr2,g_ina.inapost,"",g_void,"")
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
     ON ACTION easyflow_approval
        LET g_action_choice="easyflow_approval"
        EXIT DISPLAY
     ON ACTION confirm                                                                                                             
        LET g_action_choice="confirm"                                                                                              
        EXIT DISPLAY                                                                                                               
     ON ACTION undo_confirm                                                                                                        
        LET g_action_choice="undo_confirm"                                                                                         
        EXIT DISPLAY               
    #庫存過帳
      ON ACTION stock_post
         LET g_action_choice="stock_post"
         EXIT DISPLAY
    #過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY
    #作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #FUN-D20039 ------------sta
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20039 ------------end
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      ON ACTION about         
         CALL cl_about()     
      ON ACTION approval_status                  
         LET g_action_choice="approval_status"
         EXIT DISPLAY
      ON ACTION agree
         LET g_action_choice = 'agree'
         EXIT DISPLAY
      ON ACTION deny
         LET g_action_choice = 'deny'
         EXIT DISPLAY
      ON ACTION modify_flow
         LET g_action_choice = 'modify_flow'
         EXIT DISPLAY
      ON ACTION withdraw
         LET g_action_choice = 'withdraw'
         EXIT DISPLAY
      ON ACTION org_withdraw
         LET g_action_choice = 'org_withdraw'
         EXIT DISPLAY
      ON ACTION phrase
         LET g_action_choice = 'phrase'
         EXIT DISPLAY
      ON ACTION related_document                #No.FUN-6B0079  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION t270_out()
    IF g_ina.ina01 IS NULL THEN RETURN END IF
    LET g_msg = 'ina01= "',g_ina.ina01,'"'
   #LET g_msg = "aimr300 '",g_today,"' '",g_user,"' '",g_lang,"' ",    #FUN-C30085 mark
    LET g_msg = "aimg300 '",g_today,"' '",g_user,"' '",g_lang,"' ",    #FUN-C30085 add
                " 'Y' ' ' '1' ",
                " '",g_msg,"' "
    CALL cl_cmdrun(g_msg)
END FUNCTION
FUNCTION t270_s()
DEFINE l_cnt     LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(400)
DEFINE l_inb09   LIKE inb_file.inb09,
       l_inb04   LIKE inb_file.inb04,
       l_inb10   LIKE inb_file.inb10,
       l_qcs01   LIKE qcs_file.qcs01,
       l_qcs02   LIKE qcs_file.qcs02,
       l_qcs091c LIKE qcs_file.qcs091
DEFINE l_imaag   LIKE ima_file.imaag   #No.FUN-640056             
DEFINE l_flag    LIKE type_file.chr1   #FUN-930109
DEFINE g_flag    LIKE type_file.chr1   #FUN-930109
 
   IF s_shut(0) THEN RETURN END IF
   IF g_ina.ina01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_ina.* FROM ina_file WHERE ina01=g_ina.ina01
   IF g_ina.inapost = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_ina.inapost = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   IF g_ina.inaconf!= 'Y' THEN CALL cl_err('','aap-717',0) RETURN END IF
   IF g_ina.inamksg = 'Y' THEN
      IF g_ina.ina08 != '1' THEN
         CALL cl_err('','aim-317',0)
         RETURN
      END IF
   END IF
   IF g_sma.sma53 IS NOT NULL AND g_ina.ina02 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0) RETURN
   END IF
   CALL s_yp(g_ina.ina02) RETURNING g_yy,g_mm
   IF g_yy > g_sma.sma51			 # 與目前會計年度,期間比較
   THEN CALL cl_err(g_yy,'mfg6090',0) RETURN
   ELSE IF g_yy=g_sma.sma51 AND g_mm > g_sma.sma52
        THEN CALL cl_err(g_mm,'mfg6091',0) RETURN
        END IF
   END IF
  IF g_aza.aza23 MATCHES '[Yy]' AND g_ina.inamksg MATCHES '[Yy]' THEN  
      IF g_ina.ina08 <> '1' THEN
          #必須簽核狀況為已核准，才能執行過帳
          CALL cl_err(g_ina.ina01,'aim-317',1)
          RETURN
      END IF
  END IF
   #無單身不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM inb_file
    WHERE inb01=g_ina.ina01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   LET g_flag = 'Y'                                                                                                            
   DECLARE t270_s_cs CURSOR FOR SELECT * FROM inb_file                                                                           
                                 WHERE inb01=g_ina.ina01
                                 
   CALL s_showmsg_init()
                                                                          
   FOREACH t270_s_cs INTO b_inb.*                                                                                                
      CALL s_incchk(b_inb.inb05,b_inb.inb06,g_user)                                                                                 
      RETURNING l_flag                                                                                                              
      IF l_flag = FALSE THEN
         LET g_flag='N' 
         LET g_showmsg=b_inb.inb03,"/",b_inb.inb05,"/",b_inb.inb06,"/",g_user                                                                   
         CALL s_errmsg('inb03,inb05,inb06,inc03',g_showmsg,'','asf-888',1)                                                          
      END IF                                                                                                                        
   END FOREACH
   CALL s_showmsg()                                                                                                                 
   IF g_flag='N' THEN                                                                                                            
      RETURN                                                                                                                        
   END IF                                                                                                                      
   LET l_sql = " SELECT inb09,inb10,inb04,inb01,inb03 FROM inb_file ",
               "  WHERE inb01 = '",g_ina.ina01,"'"
   PREPARE t270_curs1 FROM l_sql
   DECLARE t270_pre1 CURSOR FOR t270_curs1
   LET g_success = 'Y'      #No.FUN-8A0086
   CALL s_showmsg_init()   #No.FUN-710033
   FOREACH t270_pre1 INTO l_inb09,l_inb10,l_inb04,l_qcs01,l_qcs02
     IF l_inb10 = 'Y' THEN
       LET l_qcs091c = 0
       SELECT SUM(qcs091) INTO l_qcs091c 
         FROM qcs_file
        WHERE qcs01 = l_qcs01
          AND qcs02 = l_qcs02
          AND qcs14 = 'Y'
       IF l_qcs091c IS NULL THEN
          LET l_qcs091c = 0
       END IF
       SELECT imaag INTO l_imaag FROM ima_file                                                                            
        WHERE ima01 =l_inb04                                                                                              
       IF NOT CL_null(l_imaag) OR l_imaag ='@CHILD' THEN                                                                  
          LET g_success='N'
          CALL s_errmsg("imaag",l_imaag,"","aim1004",1)
          CONTINUE FOREACH
       END IF                                                                                                             
       IF l_inb09 > l_qcs091c THEN
          LET g_success='N'
          LET g_showmsg=l_inb09,"/",l_qcs091c
          CALL s_errmsg("inb09,qcs091",g_showmsg,"","mfg3558",1)
          CONTINUE FOREACH
       END IF
     END IF
   END FOREACH
   IF g_success = 'N' THEN 
      CALL s_showmsg()
      RETURN
   END IF
   IF NOT cl_confirm('mfg0176') THEN RETURN END IF
   LET g_success = 'Y'
   BEGIN WORK
   OPEN t270_cl USING g_ina.ina01
   IF STATUS THEN
      CALL cl_err("OPEN t270_cl:", STATUS, 1)
      CLOSE t270_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t270_cl INTO g_ina.*                    # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ina.ina01,SQLCA.sqlcode,0)   # 資料被他人LOCK
      CLOSE t270_cl ROLLBACK WORK RETURN
   END IF
   CALL t270_s1()
   IF SQLCA.SQLCODE THEN LET g_success='N' END IF
   IF g_success = 'Y' THEN
      UPDATE ina_file SET inapost='Y' WHERE ina01=g_ina.ina01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL s_errmsg("ina01",g_ina.ina01,"upd inapost:",SQLCA.sqlcode,1)
         CALL s_showmsg()
         ROLLBACK WORK RETURN
      END IF
      LET g_ina.inapost='Y'
      LET g_ina.ina08='1'            
      DISPLAY BY NAME g_ina.inapost
#      DISPLAY BY NAME g_ina.ina08                #FUN-B30029  mark
      CALL s_showmsg()
      COMMIT WORK
      CALL cl_flow_notify(g_ina.ina01,'S')
   ELSE
      LET g_ina.inapost='N'
      CALL s_showmsg()
      ROLLBACK WORK
   END IF
   IF (g_ina.inapost = "N") THEN                                                                                                    
      DECLARE t270_s1_c2 CURSOR FOR SELECT * FROM inb_file                                                                          
                                     WHERE inb01 = g_ina.ina01                                                                      
      LET g_imm01 = ""                                                                                                              
      LET g_success = "Y"                                                                                                           
 
      CALL s_showmsg_init()   #No.FUN-6C0083 
 
      BEGIN WORK                                                                                                                    
      FOREACH t270_s1_c2 INTO b_inb.*                                                                                               
         IF STATUS THEN                                                                                                             
            EXIT FOREACH                                                                                                            
         END IF                                                                                                                     
         IF g_sma.sma115 = 'Y' THEN                                                                                                 
            IF g_ima906 = '2' THEN  #子母單位                                                                                       
               LET g_unit_arr[1].unit= b_inb.inb902                      
               LET g_unit_arr[1].fac = b_inb.inb903                                                                                 
               LET g_unit_arr[1].qty = b_inb.inb904                                                                                 
               LET g_unit_arr[2].unit= b_inb.inb905                                                                                 
               LET g_unit_arr[2].fac = b_inb.inb906                                                                                 
               LET g_unit_arr[2].qty = b_inb.inb907                                                                                 
               IF g_ina.ina00 MATCHES '[1256]' THEN                                                                                 
                  CALL s_dismantle(g_ina.ina01,b_inb.inb03,g_ina.ina03,                                                             
                                   b_inb.inb04,b_inb.inb05,b_inb.inb06,  
                                   b_inb.inb07,g_unit_arr,g_imm01)                                                                  
                         RETURNING g_imm01                                                                                          
                  IF g_success='N' THEN    #No.FUN-6C0083
                     LET g_totsuccess='N'                                                                                           
                     LET g_success="Y"                                                                                              
                     CONTINUE FOREACH                                                                                            
                  END IF                                                                                                            
               END IF                                                                                                               
            END IF                                                                                                                  
         END IF                                                                                                                     
      END FOREACH                                                                                                                   
 
      IF g_totsuccess="N" THEN    #TQC-620156             
         LET g_success="N"                                                                                                          
         CALL s_showmsg()   #No.FUN-6C0083
      END IF                                                                                                                        
 
      IF g_success = "Y" AND NOT cl_null(g_imm01) THEN                                                                              
         COMMIT WORK                                                                                                                
         LET g_msg="aimt324 '",g_imm01,"'"                                                                                          
         CALL cl_cmdrun_wait(g_msg)                                                                                                 
      ELSE                                                                                                                          
         ROLLBACK WORK                                                                                                              
      END IF                                                                                                                        
   END IF                                                                                                                           
   CALL cl_set_field_pic("","",g_ina.inapost,"",g_void,"") 
   MESSAGE ''
END FUNCTION
FUNCTION t270_s1()
  DEFINE l_dt     LIKE type_file.dat              #No.FUN-680120 DATE
  DEFINE l_cnt_img   LIKE type_file.num5     #FUN-C70087
  DEFINE l_cnt_imgg  LIKE type_file.num5     #FUN-C70087

   #FUN-C70087---begin
   CALL s_padd_img_init()  #FUN-CC0095
   CALL s_padd_imgg_init()  #FUN-CC0095
   
   DECLARE t270_s1_c1 CURSOR FOR SELECT * FROM inb_file
                                  WHERE inb01=g_ina.ina01

   FOREACH t270_s1_c1 INTO b_inb.*
      IF STATUS THEN EXIT FOREACH END IF
      LET l_cnt_img = 0
      SELECT COUNT(*) INTO l_cnt_img
        FROM img_file
       WHERE img01 = b_inb.inb04
         AND img02 = b_inb.inb05
         AND img03 = b_inb.inb06
         AND img04 = b_inb.inb07
       IF l_cnt_img = 0 THEN
          #CALL s_padd_img_data(b_inb.inb04,b_inb.inb05,b_inb.inb06,b_inb.inb07,g_ina.ina01,b_inb.inb03,g_ina.ina02,l_img_table) #FUN-CC0095
          CALL s_padd_img_data1(b_inb.inb04,b_inb.inb05,b_inb.inb06,b_inb.inb07,g_ina.ina01,b_inb.inb03,g_ina.ina02) #FUN-CC0095
       END IF

       CALL s_chk_imgg(b_inb.inb04,b_inb.inb05,
                       b_inb.inb06,b_inb.inb07,
                       b_inb.inb902) RETURNING g_flag
       IF g_flag = 1 THEN
          #CALL s_padd_imgg_data(b_inb.inb04,b_inb.inb05,b_inb.inb06,b_inb.inb07,b_inb.inb902,g_ina.ina01,b_inb.inb03,l_imgg_table) #FUN-CC0095
          CALL s_padd_imgg_data1(b_inb.inb04,b_inb.inb05,b_inb.inb06,b_inb.inb07,b_inb.inb902,g_ina.ina01,b_inb.inb03) #FUN-CC0095
       END IF 
       CALL s_chk_imgg(b_inb.inb04,b_inb.inb05,
                       b_inb.inb06,b_inb.inb07,
                       b_inb.inb905) RETURNING g_flag
       IF g_flag = 1 THEN
          #CALL s_padd_imgg_data(b_inb.inb04,b_inb.inb05,b_inb.inb06,b_inb.inb07,b_inb.inb905,g_ina.ina01,b_inb.inb03,l_imgg_table) #FUN-CC0095
          CALL s_padd_imgg_data1(b_inb.inb04,b_inb.inb05,b_inb.inb06,b_inb.inb07,b_inb.inb905,g_ina.ina01,b_inb.inb03) #FUN-CC0095
       END IF 
   END FOREACH 
   #FUN-CC0095---begin mark
   #LET g_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_img_table CLIPPED  #,g_cr_db_str
   #PREPARE cnt_img FROM g_sql
   #LET l_cnt_img = 0
   #EXECUTE cnt_img INTO l_cnt_img
   #
   #LET g_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_imgg_table CLIPPED #,g_cr_db_str
   #PREPARE cnt_imgg FROM g_sql
   #LET l_cnt_imgg = 0
   #EXECUTE cnt_imgg INTO l_cnt_imgg
   #FUN-CC0095---end
   LET l_cnt_img = g_padd_img.getLength()  #FUN-CC0095
   LET l_cnt_imgg = g_padd_imgg.getLength()  #FUN-CC0095
   
   IF g_sma.sma892[3,3] = 'Y' AND (l_cnt_img > 0 OR l_cnt_imgg > 0) THEN
      IF cl_confirm('mfg1401') THEN 
         IF l_cnt_img > 0 THEN 
            #IF NOT s_padd_img_show(l_img_table) THEN  #FUN-CC0095
            IF NOT s_padd_img_show1() THEN  #FUN-CC0095
               #CALL s_padd_img_del(l_img_table) #FUN-CC0095
               LET g_success = 'N'
               RETURN 
            END IF 
         END IF 
         IF l_cnt_imgg > 0 THEN #FUN-CC0095
            #IF NOT s_padd_imgg_show(l_imgg_table) THEN  #FUN-CC0095
            IF NOT s_padd_imgg_show1() THEN  #FUN-CC0095
               #CALL s_padd_imgg_del(l_imgg_table) #FUN-CC0095
               LET g_success = 'N'
               RETURN 
            END IF 
         END IF #FUN-CC0095
      ELSE
         #CALL s_padd_img_del(l_img_table) #FUN-CC0095
         #CALL s_padd_imgg_del(l_imgg_table) #FUN-CC0095
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   #CALL s_padd_img_del(l_img_table) #FUN-CC0095
   #CALL s_padd_imgg_del(l_imgg_table) #FUN-CC0095
   #FUN-C70087---end
   
  CALL s_showmsg_init()   #No.FUN-6C0083 
 
  DECLARE t270_s1_c CURSOR FOR SELECT * FROM inb_file WHERE inb01=g_ina.ina01
  FOREACH t270_s1_c INTO b_inb.*
      IF STATUS THEN
         EXIT FOREACH
      END IF
      IF g_success = "N" THEN                                                   
         LET g_totsuccess = "N"                                                 
         LET g_success = "Y"                                                    
      END IF
 
      IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
          MESSAGE '_s1() read no:',b_inb.inb03 USING '#####&',' parts: ', b_inb.inb04
      ELSE
          DISPLAY '_s1() read no:',b_inb.inb03 USING '#####&',' parts: ', b_inb.inb04 AT 2,1
      END IF
      IF cl_null(b_inb.inb04) THEN
         CONTINUE FOREACH
      END IF
      IF g_argv1 MATCHES '[1256]' THEN
         LET l_dt = g_ina.ina02
         IF l_dt IS NULL THEN
            LET l_dt = g_ina.ina03
         END IF
        #FUN-D30024--modify--str--
        #IF NOT s_stkminus(b_inb.inb04,b_inb.inb05,b_inb.inb06,b_inb.inb07,
        #                  b_inb.inb09,b_inb.inb08_fac,l_dt,g_sma.sma894[1,1]) THEN
         IF NOT s_stkminus(b_inb.inb04,b_inb.inb05,b_inb.inb06,b_inb.inb07,
                           b_inb.inb09,b_inb.inb08_fac,l_dt) THEN
        #FUN-D30024--modify--end-- 
            LET g_success = 'N'    #No.FUN-710033
            CONTINUE FOREACH                                                                                                     
         END IF
      END IF
      IF g_sma.sma115 = 'Y' THEN
         CALL t270_update_du()
      END IF
      IF g_success='N' THEN   #No.FUN-6C0083
         CONTINUE FOREACH                                                                                                        
      END IF
      CALL t270_update(b_inb.inb05,b_inb.inb06,b_inb.inb07,
                       b_inb.inb09,b_inb.inb08,b_inb.inb08_fac)
      IF g_success='N' THEN   #No.FUN-6C0083
         CONTINUE FOREACH                                                                                                        
      END IF
  END FOREACH
  IF g_totsuccess = 'N' THEN                                                   
     LET g_success = 'N'                                                       
  END IF                                                                       
 
END FUNCTION
 
FUNCTION t270_update_du()
   DEFINE l_ima25   LIKE ima_file.ima25,
          u_type    LIKE type_file.num5             #No.FUN-680120 SMALLINT
   SELECT ima906,ima907 INTO g_ima906,g_ima907 FROM ima_file
    WHERE ima01 = b_inb.inb04
   IF g_ima906 = '1' OR g_ima906 IS NULL THEN
      RETURN
   END IF
   CASE WHEN g_ina.ina00 MATCHES "[12]" LET u_type=-1
	WHEN g_ina.ina00 MATCHES "[34]" LET u_type=+1
	WHEN g_ina.ina00 MATCHES "[56]" LET u_type=0
   END CASE
   SELECT ima25 INTO l_ima25 FROM ima_file
    WHERE ima01=b_inb.inb04
   IF SQLCA.sqlcode THEN
      CALL s_errmsg("ima01",b_inb.inb04,"",SQLCA.sqlcode,1)
      LET g_success='N'
      RETURN
   END IF
   IF g_ima906 = '2' THEN                        #子母單位
      LET g_unit_arr[1].unit=b_inb.inb902                                                                                           
      LET g_unit_arr[1].fac =b_inb.inb903                                                                                           
      LET g_unit_arr[1].qty =b_inb.inb904                                                                                           
      LET g_unit_arr[2].unit=b_inb.inb905                                                                                           
      LET g_unit_arr[2].fac =b_inb.inb906                                                                                           
      LET g_unit_arr[2].qty =b_inb.inb907             
      IF NOT cl_null(b_inb.inb905) THEN
         CALL t270_upd_imgg('1',b_inb.inb04,b_inb.inb05,b_inb.inb06,
                         b_inb.inb07,b_inb.inb905,b_inb.inb906,b_inb.inb907,u_type,'2')
         IF g_success='N' THEN
            RETURN
         END IF
         IF NOT cl_null(b_inb.inb907) AND b_inb.inb907 <> 0 THEN
            CALL t270_tlff(b_inb.inb05,b_inb.inb06,b_inb.inb07,l_ima25,
                           b_inb.inb907,0,b_inb.inb905,b_inb.inb906,u_type,'2')
            IF g_success='N' THEN
               RETURN
            END IF
         END IF
      END IF
      IF NOT cl_null(b_inb.inb902) THEN
         CALL t270_upd_imgg('1',b_inb.inb04,b_inb.inb05,b_inb.inb06,
                            b_inb.inb07,b_inb.inb902,b_inb.inb903,b_inb.inb904,u_type,'1')
         IF g_success='N' THEN
            RETURN
         END IF
         IF NOT cl_null(b_inb.inb904) AND b_inb.inb904 <> 0 THEN
            CALL t270_tlff(b_inb.inb05,b_inb.inb06,b_inb.inb07,l_ima25,
                           b_inb.inb904,0,b_inb.inb902,b_inb.inb903,u_type,'1')
            IF g_success='N' THEN
               RETURN
            END IF
         END IF
      END IF
   END IF
   IF g_ima906 = '3' THEN                        #參考單位
      IF NOT cl_null(b_inb.inb905) THEN
         CALL t270_upd_imgg('2',b_inb.inb04,b_inb.inb05,b_inb.inb06,
                            b_inb.inb07,b_inb.inb905,b_inb.inb906,b_inb.inb907,u_type,'2')
         IF g_success = 'N' THEN
            RETURN
         END IF
         IF NOT cl_null(b_inb.inb907) AND b_inb.inb907 <> 0 THEN
            CALL t270_tlff(b_inb.inb05,b_inb.inb06,b_inb.inb07,l_ima25,
                           b_inb.inb907,0,b_inb.inb905,b_inb.inb906,u_type,'2')
            IF g_success='N' THEN
               RETURN
            END IF
         END IF
      END IF
   END IF
END FUNCTION
FUNCTION t270_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg211,p_imgg10,p_type,p_no)
  DEFINE p_imgg00   LIKE imgg_file.imgg00,
         p_imgg01   LIKE imgg_file.imgg01,
         p_imgg02   LIKE imgg_file.imgg02,
         p_imgg03   LIKE imgg_file.imgg03,
         p_imgg04   LIKE imgg_file.imgg04,
         p_imgg09   LIKE imgg_file.imgg09,
         p_imgg10   LIKE imgg_file.imgg10,
         p_imgg211  LIKE imgg_file.imgg211,
         l_ima25    LIKE ima_file.ima25,
         l_ima906   LIKE ima_file.ima906,
         l_imgg21   LIKE imgg_file.imgg21,
         p_no       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
         p_type     LIKE type_file.num10             #No.FUN-680120 INTEGER
    SELECT ima25,ima906 INTO l_ima25,l_ima906
      FROM ima_file WHERE ima01=p_imgg01
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
       CALL s_errmsg("ima01",p_imgg01,"ima25 null",SQLCA.sqlcode,1)
       LET g_success = 'N' RETURN
    END IF
    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
          RETURNING g_cnt,l_imgg21
    IF g_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
       LET g_showmsg=p_imgg01,"/",p_imgg09,"/",l_ima25
       CALL s_errmsg("imgg01,imgg09,ima25",g_showmsg,"","mfg3075",1)
       LET g_success = 'N' RETURN
    END IF
    CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,g_ina.ina02,  #FUN-8C0084
          '','','','','',g_ina.ina01,g_inb[1].inb03,'','','',l_imgg21,'','','','','','','',p_imgg211)      #FUN-630018
    IF g_success='N' THEN RETURN END IF
END FUNCTION
FUNCTION t270_tlff(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
                   u_type,p_flag)
DEFINE
   p_ware     LIKE img_file.img02,	         #倉庫
   p_loca     LIKE img_file.img03,	         #儲位
   p_lot      LIKE img_file.img04,     	         #批號
   p_unit     LIKE img_file.img09,
   p_qty      LIKE img_file.img10,               #數量  
   p_img10    LIKE img_file.img10,               #異動后數量
   p_uom      LIKE img_file.img09,               #img 單位
   p_factor   LIKE img_file.img21,  	         #轉換率
   l_imgg10   LIKE imgg_file.imgg10,
   u_type     LIKE type_file.num5,            #No.FUN-680120 SMALLINT             #+1:雜收 -1:雜發  0:報廢
   p_flag     LIKE type_file.chr1,            #No.FUN-680120 VARCHAR(1)
   g_cnt      LIKE type_file.num5             #No.FUN-680120 SMALLINT
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' '  END IF
    IF cl_null(p_qty)  THEN LET p_qty=0    END IF
    IF p_uom IS NULL THEN
       CALL s_errmsg("imgg09",p_uom,"p_uom null:","mfg0019",1)
       LET g_success = 'N' RETURN
    END IF
    SELECT imgg10 INTO l_imgg10 FROM imgg_file
     WHERE imgg01=b_inb.inb04 AND imgg02=p_ware
       AND imgg03=p_loca      AND imgg04=p_lot
       AND imgg09=p_uom
    IF cl_null(l_imgg10) THEN LET l_imgg10 = 0 END IF
    INITIALIZE g_tlff.* TO NULL
    LET g_tlff.tlff01=b_inb.inb04                #異動料件編號
    IF g_ina.ina00 MATCHES "[34]" THEN
       #----來源----
       LET g_tlff.tlff02=90
       LET g_tlff.tlff026=b_inb.inb11            #來源單號
       #---目的----
       LET g_tlff.tlff03=50                      #'Stock'
       LET g_tlff.tlff030=g_plant
       LET g_tlff.tlff031=p_ware                 #倉庫
       LET g_tlff.tlff032=p_loca                 #儲位
       LET g_tlff.tlff033=p_lot                  #批號
       #**該數量錯誤*****
       LET g_tlff.tlff034=l_imgg10               #異動后數量
       LET g_tlff.tlff035=p_unit                 #庫存單位(ima_file or img_file)
       LET g_tlff.tlff036=b_inb.inb01            #雜收單號
       LET g_tlff.tlff037=b_inb.inb03            #雜收項次
    END IF
    IF g_ina.ina00 MATCHES "[1256]" THEN
       #----來源----
       LET g_tlff.tlff02=50                      #'Stock'
       LET g_tlff.tlff020=g_plant
       LET g_tlff.tlff021=p_ware                 #倉庫
       LET g_tlff.tlff022=p_loca                 #儲位
       LET g_tlff.tlff023=p_lot                  #批號
       LET g_tlff.tlff024=l_imgg10               #異動后數量
       LET g_tlff.tlff025=p_unit                 #庫存單位(ima_file or img_file)
       LET g_tlff.tlff026=b_inb.inb01            #雜發/報廢單號
       LET g_tlff.tlff027=b_inb.inb03            #雜發/報廢項次
       #---目的----
       IF g_ina.ina00 MATCHES "[12]"
          THEN LET g_tlff.tlff03=90
          ELSE LET g_tlff.tlff03=40
       END IF
       LET g_tlff.tlff036=b_inb.inb11            #目的單號
    END IF
    LET g_tlff.tlff04= ' '                       #工作站
    LET g_tlff.tlff05= ' '                       #作業序號
    LET g_tlff.tlff06=g_ina.ina02                #發料日期
    LET g_tlff.tlff07=g_today                    #異動資料產生日期
    LET g_tlff.tlff08=TIME                       #異動資料產生時:分:秒
    LET g_tlff.tlff09=g_user                     #產生人
    LET g_tlff.tlff10=p_qty                      #異動數量
    LET g_tlff.tlff11=p_uom	                 #發料單位
    LET g_tlff.tlff12=p_factor                   #發料/庫存 換算率
    CASE WHEN g_ina.ina00 = '1' LET g_tlff.tlff13='aimt301'
         WHEN g_ina.ina00 = '2' LET g_tlff.tlff13='aimt311'
         WHEN g_ina.ina00 = '3' LET g_tlff.tlff13='aimt302'
         WHEN g_ina.ina00 = '4' LET g_tlff.tlff13='aimt312'
         WHEN g_ina.ina00 = '5' LET g_tlff.tlff13='aimt303'
         WHEN g_ina.ina00 = '6' LET g_tlff.tlff13='aimt313'
    END CASE
    LET g_tlff.tlff14=b_inb.inb15                #異動原因
    LET g_tlff.tlff17=g_ina.ina07              
    LET g_tlff.tlff19=g_ina.ina04
    LET g_tlff.tlff20=g_ina.ina06                #Project code
    LET g_tlff.tlff62=b_inb.inb12                #參考單號
    LET g_tlff.tlff64=b_inb.inb901               #手冊編號  
    IF cl_null(b_inb.inb907) OR b_inb.inb907=0 THEN
       CALL s_tlff(p_flag,NULL)
    ELSE
       CALL s_tlff(p_flag,b_inb.inb905)
    END IF
END FUNCTION
FUNCTION t270_update(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor)
  DEFINE p_ware    LIKE tlf_file.tlf031,          #No.FUN-680120 VARCHAR(10)                    #倉庫 # TQC-6A0079
         p_loca    LIKE tlf_file.tlf032,          #No.FUN-680120 VARCHAR(10)                    #儲位 # TQC-6A0079
         p_lot     LIKE tlf_file.tlf033,          #No.FUN-680120 VARCHAR(24)                    #批號  
         p_qty     LIKE tlf_file.tlf10,          #數量   
         p_uom     LIKE tlf_file.tlf11,           #No.FUN-680120 VARCHAR(04)                    #img 單位
         p_factor  LIKE tlf_file.tlf12,           #No.FUN-680120 DECIMAL(16,8)               #轉換率
         u_type    LIKE type_file.num5,           #No.FUN-680120 SMALLINT                    # +1:雜收 -1:雜發  0:報廢
         l_qty     LIKE img_file.img10,   
         l_ima01   LIKE ima_file.ima01,
         l_ima25   LIKE ima_file.ima25,
#        l_imaqty  LIKE ima_file.ima262,
         l_imaqty  LIKE type_file.num15_3,        ###GP5.2  #NO.FUN-A20044
         l_imafac  LIKE img_file.img21,
         l_img     RECORD
           img10   LIKE img_file.img10,
           img16   LIKE img_file.img16,
           img23   LIKE img_file.img23,
           img24   LIKE img_file.img24,
           img09   LIKE img_file.img09,
           img21   LIKE img_file.img21
                   END RECORD,
         l_cnt     LIKE type_file.num5          #No.FUN-680120 SMALLINT
  DEFINE l_newerr  LIKE type_file.num5          #No.FUN-680120 SMALLINT     
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot =' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty =0   END IF
    IF p_uom IS NULL THEN
       CALL s_errmsg("img09",p_uom,"","mfg0019",1) 
       LET g_success = 'N'
       RETURN
    END IF
#------------------------------------------- update img_file
    MESSAGE "update img_file ..."
    LET g_forupd_sql =
         "SELECT img10,img16,img23,img24,img09,img21 FROM img_file ",  #091021
        " WHERE img01= ? AND img02= ? AND img03= ? AND img04= ?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img_lock CURSOR FROM g_forupd_sql
    OPEN img_lock USING b_inb.inb04,p_ware,p_loca,p_lot
    IF STATUS THEN
       LET g_showmsg=b_inb.inb04,"/",p_ware,"/",p_loca,"/",p_lot
       CALL s_errmsg("img01,img02,img03,img04",g_showmsg,"",SQLCA.sqlcode,1) 
       LET g_success='N'
       CLOSE img_lock
       RETURN
    END IF
    FETCH img_lock INTO l_img.*
    IF STATUS THEN
       LET g_showmsg=b_inb.inb04,"/",p_ware,"/",p_loca,"/",p_lot
       CALL s_errmsg("img01,img02,img03,img04",g_showmsg,"",SQLCA.sqlcode,1) 
       LET g_success='N'
       CLOSE img_lock
       RETURN
    END IF
    IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
   # 統一由 s_upimg來做庫存不足(sma894)的判斷
    CASE WHEN g_ina.ina00 MATCHES "[12]" LET u_type=-1
            LET l_qty= l_img.img10 - p_qty #MOD-570181 add
	 WHEN g_ina.ina00 MATCHES "[34]" LET u_type=+1
            LET l_qty= l_img.img10 + p_qty #MOD-570181 add
	 WHEN g_ina.ina00 MATCHES "[56]" LET u_type=0
            LET l_qty= l_img.img10 - p_qty #MOD-570181 add
    END CASE
    CALL s_upimg(b_inb.inb04,p_ware,p_loca,p_lot,u_type,p_qty*p_factor,g_ina.ina02,  #FUN-8C0084
          '','','','',g_ina.ina01,g_inb[1].inb03,'','','','','','','','','','','','')       #FUN-630018
    IF g_success='N' THEN
       RETURN
    END IF
#------------------------------------------- update ima_file
    MESSAGE "update ima_file ..."
    LET g_forupd_sql =
        "SELECT ima25 FROM ima_file WHERE ima01= ? FOR UPDATE " #FUN-560183 del ima86
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE ima_lock CURSOR FROM g_forupd_sql
    OPEN ima_lock USING b_inb.inb04
    IF STATUS THEN
       CALL s_errmsg("ima01",b_inb.inb04,"",SQLCA.sqlcode,1)
       LET g_success = 'N'
       CLOSE ima_lock
       RETURN
    END IF
    FETCH ima_lock INTO l_ima25  #,g_ima86 #FUN-560183
    IF STATUS THEN
       CALL s_errmsg("ima01",b_inb.inb04,"",SQLCA.sqlcode,1)
       LET g_success = 'N'
       CLOSE ima_lock
       RETURN
    END IF
    IF b_inb.inb08=l_ima25 THEN
       LET l_imafac = 1
    ELSE
       CALL s_umfchk(b_inb.inb04,b_inb.inb08,l_ima25)
                RETURNING g_cnt,l_imafac
    #-單位換算率抓不到
       IF g_cnt = 1 THEN
          LET g_showmsg=b_inb.inb04,"/",b_inb.inb08,"/",l_ima25
          CALL s_errmsg("inb04,inb08,ima25",g_showmsg,"","mfg2719",1)
          LET g_success ='N'
       END IF
    END IF
    IF cl_null(l_imafac) THEN
       LET l_imafac = 1
    END IF
    LET l_imaqty = p_qty * l_imafac
    CALL s_udima(b_inb.inb04,l_img.img23,l_img.img24,l_imaqty,
                    g_ina.ina02,u_type)  RETURNING l_cnt
    IF g_success='N' THEN
       RETURN
    END IF
#------------------------------------------- insert tlf_file
    MESSAGE "insert tlf_file ..."
    IF g_success='Y' THEN
       CALL t270_tlf(p_ware,p_loca,p_lot,l_ima25,p_qty,l_qty,p_uom,p_factor,
                     u_type)
    END IF
    MESSAGE "seq#",b_inb.inb03 USING'<<<',' post ok!'
END FUNCTION
FUNCTION t270_tlf(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
                     u_type)
   DEFINE
      p_ware   LIKE tlf_file.tlf031,          #No.FUN-680120 VARCHAR(10)		         #倉庫 # TQC-6A0079
      p_loca   LIKE tlf_file.tlf032,          #No.FUN-680120 VARCHAR(10)			 #儲位 # TQC-6A0079
      p_lot    LIKE tlf_file.tlf033,          #No.FUN-680120 VARCHAR(24)	    		 #批號
      p_qty    LIKE tlf_file.tlf10,      
      p_uom    LIKE tlf_file.tlf11,           #No.FUN-680120 VARCHAR(04)                        #img 單位
      p_factor LIKE tlf_file.tlf12,           #No.FUN-680120 DECIMAL(16,8) 			 #轉換率
      p_unit   LIKE ima_file.ima25,              #單位
      p_img10  LIKE img_file.img10,              #異動后數量
      u_type   LIKE type_file.num5,           #No.FUN-680120 SMALLINT		         # +1:雜收 -1:雜發  0:報廢
      l_sfb02  LIKE sfb_file.sfb02,
      l_sfb03  LIKE sfb_file.sfb03,
      l_sfb04  LIKE sfb_file.sfb04,
      l_sfb22  LIKE sfb_file.sfb22,
      l_sfb27  LIKE sfb_file.sfb27,
      l_sta    LIKE type_file.num5,           #No.FUN-680120 SMALLINT
      g_cnt    LIKE type_file.num5            #No.FUN-680120 SMALLINT
   INITIALIZE g_tlf.* TO NULL
   LET g_tlf.tlf01=b_inb.inb04                   #異動料件編號
   IF g_ina.ina00 MATCHES "[34]" THEN
      #----來源----
      LET g_tlf.tlf02=90
      LET g_tlf.tlf026=b_inb.inb11               #來源單號
      #---目的----
      LET g_tlf.tlf03=50                         #'Stock'
      LET g_tlf.tlf030=g_plant
      LET g_tlf.tlf031=p_ware                    #倉庫
      LET g_tlf.tlf032=p_loca                    #儲位
      LET g_tlf.tlf033=p_lot                     #批號
      LET g_tlf.tlf034=p_img10                   #異動后數量
      LET g_tlf.tlf035=p_unit                    #庫存單位(ima_file or img_file)
      LET g_tlf.tlf036=b_inb.inb01               #雜收單號
      LET g_tlf.tlf037=b_inb.inb03               #雜收項次
   END IF
   IF g_ina.ina00 MATCHES "[1256]" THEN
      #----來源----
      LET g_tlf.tlf02=50                         #'Stock'
      LET g_tlf.tlf020=g_plant
      LET g_tlf.tlf021=p_ware                    #倉庫
      LET g_tlf.tlf022=p_loca                    #儲位
      LET g_tlf.tlf023=p_lot                     #批號
      LET g_tlf.tlf024=p_img10                   #異動后數量
      LET g_tlf.tlf025=p_unit                    #庫存單位(ima_file or img_file)
      LET g_tlf.tlf026=b_inb.inb01               #雜發/報廢單號
      LET g_tlf.tlf027=b_inb.inb03               #雜發/報廢項次
      #---目的----
      IF g_ina.ina00 MATCHES "[12]"
         THEN LET g_tlf.tlf03=90
         ELSE LET g_tlf.tlf03=40
      END IF
      LET g_tlf.tlf036=b_inb.inb11               #目的單號
   END IF
   LET g_tlf.tlf04= ' '                          #工作站
   LET g_tlf.tlf05= ' '                          #作業序號
   LET g_tlf.tlf06=g_ina.ina02                   #發料日期
   LET g_tlf.tlf07=g_today                       #異動資料產生日期
   LET g_tlf.tlf08=TIME                          #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user                        #產生人
   LET g_tlf.tlf10=p_qty                         #異動數量
   LET g_tlf.tlf11=p_uom	                 #發料單位
   LET g_tlf.tlf12 =p_factor                     #發料/庫存 換算率
	CASE WHEN g_ina.ina00 = '1' LET g_tlf.tlf13='aimt301'
	     WHEN g_ina.ina00 = '2' LET g_tlf.tlf13='aimt311'
	     WHEN g_ina.ina00 = '3' LET g_tlf.tlf13='aimt302'
	     WHEN g_ina.ina00 = '4' LET g_tlf.tlf13='aimt312'
	     WHEN g_ina.ina00 = '5' LET g_tlf.tlf13='aimt303'
	     WHEN g_ina.ina00 = '6' LET g_tlf.tlf13='aimt313'
	END CASE
   LET g_tlf.tlf14=b_inb.inb15                   #異動原因
   LET g_tlf.tlf17=g_ina.ina07            
   LET g_tlf.tlf19=g_ina.ina04
   LET g_tlf.tlf20=g_ina.ina06                   #Project code
   LET g_tlf.tlf62=b_inb.inb12                   #參考單號
   LET g_tlf.tlf64=b_inb.inb901                  #手冊編號  
   CALL s_tlf(1,0)
END FUNCTION
FUNCTION t270_x(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废

   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_ina.* FROM ina_file WHERE ina01=g_ina.ina01
   IF g_ina.ina01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_ina.inapost='X' THEN RETURN END IF
    ELSE
       IF g_ina.inapost<>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
   IF g_ina.inapost = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_ina.ina08 MATCHES '[Ss1]' THEN  
       CALL cl_err('','mfg3557',0)
       RETURN
   END IF
   BEGIN WORK
    OPEN t270_cl USING g_ina.ina01
    IF STATUS THEN
       CALL cl_err("OPEN t270_cl:", STATUS, 1)
       CLOSE t270_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t270_cl INTO g_ina.*                   # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ina.ina01,SQLCA.sqlcode,0) # 資料被他人LOCK
        CLOSE t270_cl ROLLBACK WORK RETURN
    END IF
    #作廢/作廢還原功能
    IF cl_void(0,0,g_ina.inapost) THEN
        LET g_chr = g_ina.inapost
        IF g_ina.inapost = 'N' THEN
            LET g_ina.inapost = 'X'
            LET g_ina.ina08   = '9'    
            LET g_ina.inaconf = 'X'    
        ELSE
            LET g_ina.inapost = 'N'
            LET g_ina.ina08 = '0'  
            LET g_ina.inaconf = 'N'    
        END IF
        UPDATE ina_file
            SET inapost = g_ina.inapost,
                ina08   = g_ina.ina08,  
                inaconf = g_ina.inaconf,  
                inamodu = g_user,
                inadate = g_today
            WHERE ina01 = g_ina.ina01
        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","ina_file",g_ina.ina01,"",SQLCA.sqlcode,"","up inapost:",1)  #No.FUN-660104
        END IF
#        DISPLAY BY NAME g_ina.inapost,g_ina.ina08,g_ina.inaconf      #FUN-B30029  mark
        DISPLAY BY NAME g_ina.inapost,g_ina.inaconf                   #FUN-B30029
    END IF
    CLOSE t270_cl
    COMMIT WORK
    CALL cl_flow_notify(g_ina.ina01,'V')
END FUNCTION
#用于default 雙單位/轉換率/數量
FUNCTION t270_du_default(p_cmd)
  DEFINE    l_item   LIKE img_file.img01,        #料號
            l_ware   LIKE img_file.img02,        #倉庫
            l_loc    LIKE img_file.img03,        #儲
            l_lot    LIKE img_file.img04,        #批
            l_ima25  LIKE ima_file.ima25,        #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,        #img單位
            l_unit2  LIKE img_file.img09,        #第二單位
            l_fac2   LIKE inb_file.inb08_fac,    #第二轉換率
            l_qty2   LIKE inb_file.inb09,        #第二數量
            l_unit1  LIKE img_file.img09,        #第一單位
            l_fac1   LIKE inb_file.inb08_fac,    #第一轉換率
            l_qty1   LIKE inb_file.inb09,        #第一數量
            p_cmd    LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
            l_factor LIKE tlf_file.tlf12           #No.FUN-680120 DECIMAL(16,8)
    LET l_item = g_inb[l_ac].inb04
    LET l_ware = g_inb[l_ac].inb05
    LET l_loc  = g_inb[l_ac].inb06
    LET l_lot  = g_inb[l_ac].inb07
    IF cl_null(g_inb[l_ac].inb04) THEN
       RETURN
    END IF
    SELECT ima25,ima906,ima907 INTO l_ima25,l_ima906,l_ima907
      FROM ima_file WHERE ima01 = l_item
    SELECT img09 INTO l_img09 FROM img_file
     WHERE img01 = l_item
       AND img02 = l_ware
       AND img03 = l_loc
       AND img04 = l_lot
    IF cl_null(l_img09) THEN LET l_img09 = l_ima25 END IF
    IF l_ima906 = '1' THEN                       #不使用雙單位
       LET l_unit2 = NULL
       LET l_fac2  = NULL
       LET l_qty2  = NULL
    ELSE
       LET l_unit2 = l_ima907
       CALL s_du_umfchk(l_item,'','','',l_img09,l_ima907,l_ima906)
            RETURNING g_errno,l_factor
       LET l_fac2 = l_factor
       LET l_qty2  = 0
    END IF
    LET l_unit1 = l_img09
    LET l_fac1  = 1
    LET l_qty1  = 0
    IF p_cmd = 'a' OR g_change = 'Y' THEN
       LET g_inb[l_ac].inb905=l_unit2
       LET g_inb[l_ac].inb906=l_fac2
       LET g_inb[l_ac].inb907=l_qty2
       LET g_inb[l_ac].inb902=l_unit1
       LET g_inb[l_ac].inb903=l_fac1
       LET g_inb[l_ac].inb904=l_qty1
    END IF
END FUNCTION
#對原來數量/換算率/單位的賦值
FUNCTION t270_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,        #img單位
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE inb_file.inb906,
            l_qty2   LIKE inb_file.inb907,
            l_fac1   LIKE inb_file.inb903,
            l_qty1   LIKE inb_file.inb904,
            l_factor LIKE tlf_file.tlf12           #No.FUN-680120 DECIMAL(16,8)
    IF g_sma.sma115='N' THEN RETURN END IF
    LET l_fac2=g_inb[l_ac].inb906
    LET l_qty2=g_inb[l_ac].inb907
    LET l_fac1=g_inb[l_ac].inb903
    LET l_qty1=g_inb[l_ac].inb904
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_inb[l_ac].inb08=g_inb[l_ac].inb902
                   LET g_inb[l_ac].inb08_fac=l_fac1
                   LET g_inb[l_ac].inb09=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_inb[l_ac].inb08=g_img09
                   LET g_inb[l_ac].inb08_fac=1
                   LET g_inb[l_ac].inb09=l_tot
          WHEN '3' LET g_inb[l_ac].inb08=g_inb[l_ac].inb902
                   LET g_inb[l_ac].inb08_fac=l_fac1
                   LET g_inb[l_ac].inb09=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_inb[l_ac].inb906=l_qty1/l_qty2
                   ELSE
                      LET g_inb[l_ac].inb906=0
                   END IF
       END CASE
       LET g_inb[l_ac].inb09 = s_digqty(g_inb[l_ac].inb09,g_inb[l_ac].inb08)     #FUN-BB0085
    END IF
END FUNCTION
#以img09單位來計算雙單位所確定的數量
FUNCTION t270_tot_by_img09(p_item,p_fac2,p_qty2,p_fac1,p_qty1)
  DEFINE p_item    LIKE ima_file.ima01
  DEFINE p_fac2    LIKE inb_file.inb903
  DEFINE p_qty2    LIKE inb_file.inb904
  DEFINE p_fac1    LIKE inb_file.inb903
  DEFINE p_qty1    LIKE inb_file.inb904
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
    ELSE                                         #不使用雙單位
       LET l_tot=p_qty1*p_fac1
    END IF
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
    RETURN l_tot
END FUNCTION
#計算庫存總量是否滿足所輸入數量
FUNCTION t270_check_inventory_qty()
  DEFINE l_img10    LIKE img_file.img10
  DEFINE l_tot      LIKE img_file.img10
  DEFINE l_flag     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
    LET l_flag = '1'
    SELECT img10 INTO l_img10 FROM img_file
     WHERE img01 = g_inb[l_ac].inb04
       AND img02 = g_inb[l_ac].inb05
       AND img03 = g_inb[l_ac].inb06
       AND img04 = g_inb[l_ac].inb07
    CALL t270_tot_by_img09(g_inb[l_ac].inb04,g_inb[l_ac].inb906,g_inb[l_ac].inb907,
                           g_inb[l_ac].inb903,g_inb[l_ac].inb904)
         RETURNING l_tot
    IF l_img10 < l_tot THEN
       LET l_flag = '0'
    END IF
    RETURN l_flag
END FUNCTION
#檢查發料/報廢動作是否可以進行下去
FUNCTION t270_qty_issue()
    IF g_ina.ina00 MATCHES "[1256]" THEN
       CALL t270_check_inventory_qty()  RETURNING g_flag
       IF g_flag = '0' THEN
         #FUN-D30024--modify--str--
         #INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
         #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_inb[l_ac].inb05) RETURNING g_sma894      #FUN-C80107
         ##IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN                               #FUN-C80107 mark
         #IF g_sma894 = 'N' THEN                                                                    #FUN-C80107
          INITIALIZE g_imd23 TO NULL
          CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING g_imd23                #TQC-D40078 g_plant
          IF g_imd23 = 'N' THEN
         #FUN-D30024--modify--end-- 
             CALL cl_err(g_inb[l_ac].inb904,'mfg1303',1)
             RETURN 1
          ELSE
             IF g_yes = 'N' THEN
                IF NOT cl_confirm('mfg3469') THEN
                   RETURN 1
                END IF
             END IF
         END IF
       END IF
    END IF
    RETURN 0
END FUNCTION
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t270_du_data_to_correct()
   IF cl_null(g_inb[l_ac].inb902) THEN
      LET g_inb[l_ac].inb903 = NULL
      LET g_inb[l_ac].inb904 = NULL
   END IF
   IF cl_null(g_inb[l_ac].inb905) THEN
      LET g_inb[l_ac].inb906 = NULL
      LET g_inb[l_ac].inb907 = NULL
   END IF
   DISPLAY BY NAME g_inb[l_ac].inb903
   DISPLAY BY NAME g_inb[l_ac].inb904
   DISPLAY BY NAME g_inb[l_ac].inb906
   DISPLAY BY NAME g_inb[l_ac].inb907
END FUNCTION
FUNCTION t270_ef()
     CALL t270_y_chk()
     IF g_success = "N" THEN
         RETURN
     END IF
     CALL aws_condition()                        #判斷送簽資料
     IF g_success = 'N' THEN
         RETURN
     END IF
##########
# CALL aws_efcli2()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
##########
 IF aws_efcli2(base.TypeInfo.create(g_ina),base.TypeInfo.create(g_inb),'','','','')
 THEN
       LET g_success = 'Y'
       LET g_ina.ina08 = 'S'                     #開單成功, 更新狀態碼為 'S. 送簽中'
#       DISPLAY BY NAME g_ina.ina08          #FUN-B30029 mark
   ELSE
       LET g_success = 'N'
   END IF
END FUNCTION
FUNCTION t270_y_chk()
DEFINE l_cnt  LIKE type_file.num5          #No.FUN-680120 SMALLINT #TQC-840066
DEFINE l_pml04       LIKE pml_file.pml04
DEFINE l_imaacti     LIKE ima_file.imaacti
DEFINE l_ima140      LIKE ima_file.ima140
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_ina.* FROM ina_file WHERE ina01 = g_ina.ina01
   IF cl_null(g_ina.ina01) THEN
       CALL cl_err('',-400,0)
       LET g_success = 'N'
       RETURN
   END IF
   LET l_cnt =0
   SELECT COUNT(*) INTO l_cnt FROM inb_file
    WHERE inb01=g_ina.ina01
   IF l_cnt=0 OR cl_null(l_cnt) THEN
      CALL cl_err('','mfg-008',0)
      LET g_success = 'N'
      RETURN
   END IF
   
END FUNCTION
FUNCTION t270_y_upd()
DEFINE   l_inb05   LIKE inb_file.inb05 #No.FUN-AB0067  

   LET g_success = 'Y'
   BEGIN WORK
   OPEN t270_cl USING g_ina.ina01
   IF STATUS THEN
      LET g_success = 'N'
      CALL cl_err("OPEN t270_cl:", STATUS, 1)
      CLOSE t270_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t270_cl INTO g_ina.*                    # 對DB鎖定
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err(g_ina.ina01,SQLCA.sqlcode,0)
      CLOSE t270_cl
      ROLLBACK WORK
      RETURN
   END IF
   IF g_success = 'Y' THEN
      IF g_ina.inamksg = 'Y' THEN
         CASE aws_efapp_formapproval()
              WHEN 0                             #呼叫 EasyFlow 簽核失敗
                   LET g_success = "N"
                   ROLLBACK WORK
                   RETURN
              WHEN 2                             #當最后一關有兩個以上簽核者且此次簽核完成后尚未結案
                   ROLLBACK WORK
                   RETURN
         END CASE
      END IF
      IF g_success='Y' THEN
         LET g_ina.ina08='1'
         COMMIT WORK
         CALL cl_flow_notify(g_ina.ina01,'Y')
 #        DISPLAY BY NAME g_ina.ina08          #FUN-B30029 mark
      ELSE
         LET g_success = 'N'
         ROLLBACK WORK
      END IF
   ELSE
      LET g_success = 'N'
      ROLLBACK WORK
   END IF
   #CKP
   SELECT * INTO g_ina.* FROM ina_file WHERE ina01 = g_ina.ina01
   IF g_ina.ina08='1' OR
      g_ina.ina08='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic("",g_chr2,g_ina.inapost,"",g_void,"")
END FUNCTION
FUNCTION t270_ina_sum()
   DEFINE l_sum   LIKE ina_file.ina1020
   SELECT azi04 INTO t_azi04   #No.CHI-6A0004
     FROM azi_file 
    WHERE azi01=g_ina.ina1023                    #取得當前庫存異動單據幣別的單價及金額小數位數
   SELECT sum(inb1006) into l_sum                #取得當前出貨單單身出貨資料中的未稅金額,含稅金額合計
     FROM inb_file
    WHERE inb01 = g_ina.ina01                    #單頭單據編號
   CALL cl_numfor(l_sum,8,t_azi04) RETURNING l_sum   #No.CHI-6A0004
   UPDATE ina_file SET ina1020=l_sum WHERE ina01=g_ina.ina01
   LET g_ina.ina1020=l_sum
   DISPLAY BY NAME g_ina.ina1020
END FUNCTION   
FUNCTION t270_weight_cubage(p_ina_ina01)         #計算體積重量                                                                                            
   DEFINE  p_ina_ina01   LIKE ina_file.ina01,                                                                                       
           i             LIKE type_file.num5,    #No.FUN-680120 SMALLINT
           l_inb03       LIKE inb_file.inb03,                                                                                       
           l_inb04       LIKE inb_file.inb04,                                                                                       
           l_inb08       LIKE inb_file.inb08,                                                                                       
           l_inb09       LIKE inb_file.inb09,                                                                                       
           l1_ina1015    LIKE ina_file.ina1015,                                                                                       
           l1_ina1016    LIKE ina_file.ina1016,                                                                                       
           l_ina1015     LIKE ina_file.ina1015,                                                                                       
           l_ina1016     LIKE ina_file.ina1016                                                                                        
   DECLARE t270_b2_b CURSOR FOR                                                                                                     
    SELECT inb03,inb04,inb08,inb09                                                                                       
      FROM inb_file                                                                                                                
     WHERE inb01 = p_ina_ina01                                                                                                     
     ORDER BY inb03                                                                                                               
   LET l_ina1015 = 0                                                                                                                
   LET l_ina1016 = 0 
   FOREACH t270_b2_b INTO l_inb03,l_inb04,l_inb08,l_inb09                                                               
      CALL s_weight_cubage(l_inb04,l_inb08,l_inb09)                                                                     
      RETURNING l1_ina1015,l1_ina1016                                                                                    
      LET l_ina1015 = l_ina1015 + l1_ina1015                                                                                        
      LET l_ina1016 = l_ina1016 + l1_ina1016                                                                                        
   END FOREACH                                                                                                                      
   IF l_ina1015 > 0 OR l_ina1016 > 0 THEN                                                                                           
      LET g_ina.ina1015 = l_ina1015                                                                                                 
      LET g_ina.ina1016 = l_ina1016                                                                                                 
      UPDATE ina_file SET ina1015 = g_ina.ina1015,                                                                                  
                          ina1016 = g_ina.ina1016                                                                                   
       WHERE ina01 = g_ina_t.ina01                                                                                                  
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN                                                                                   
         CALL cl_err3("upd","ina_file",g_ina_t.ina01,"",SQLCA.sqlcode,"","upd ina01: ",1)  #No.FUN-660104
         RETURN                                                                                                                     
      END IF                                                                                                                        
      DISPLAY g_ina.ina1015 TO ina1015                                                                                              
      DISPLAY g_ina.ina1016 TO ina1016                                                                                              
   END IF                                                                                                                           
END FUNCTION         
FUNCTION t270_price(p_ac)
DEFINE l_n             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
       p_ac            LIKE type_file.num5,          #No.FUN-680120 SMALLINT
       l_success       LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
       l_ima135        LIKE ima_file.ima135,
       l_tqz09         LIKE tqz_file.tqz09,
       l_tqx14         LIKE tqx_file.tqx14,
       l_tqx16         LIKE tqx_file.tqx16,
       l_tqz08         LIKE tqz_file.tqz08,
       l1_tqz09        LIKE tqz_file.tqz09,
       l1_tqx14        LIKE tqx_file.tqx14,
       l1_tqx16        LIKE tqx_file.tqx16,
       l1_tqz08        LIKE tqz_file.tqz08,
       l_inb08         LIKE inb_file.inb08,
       l_flag          LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
       l_unitrate      LIKE ima_file.ima31_fac,
       l_unit          LIKE ima_file.ima31,
       l_dbs           LIKE type_file.chr21,         #No.FUN-680120 VARCHAR(21)
       l_plant         LIKE type_file.chr21,         #No.FUN-980059 VARCHAR(21)
       l_occ1027       LIKE occ_file.occ1027
   SELECT azf10 INTO g_azf10
     FROM azf_file
    WHERE azf01=g_inb[p_ac].inb15
   IF NOT cl_null(g_inb[p_ac].inb1002) AND g_azf10 = 'N' THEN
      SELECT COUNT(*) INTO l_n 
        FROM tqx_file,tqy_file
       WHERE tqx01=g_inb[p_ac].inb1002
         AND tqx01=tqy01
         AND tqy03=g_ina.ina1001
         AND tqx09=g_ina.ina1023
         AND tqx07='3'
         AND tqy37='Y'
      IF l_n = 0 THEN
         CALL cl_err('sel tqx_file',STATUS,0)
         RETURN 1
      END IF
      SELECT COUNT(*) INTO l_n 
        FROM tqx_file,tqy_file,tqz_file,tsa_file
       WHERE tqx01=g_inb[p_ac].inb1002
         AND tqx09=g_ina.ina1023
         AND tqx01=tqy01
         AND tqx01=tqz01
         AND tqx01=tsa01
         AND tqy02=tsa02
         AND tqz02=tsa03
         AND tqy03=g_ina.ina1001
         AND tqz03=g_inb[p_ac].inb04
         AND tqz06 <= g_ina.ina1013
         AND tqz07 >= g_ina.ina1013
         AND tqy37='Y'
         AND tqy38<=g_ina.ina1013
         AND tqxacti='Y'
      IF l_n = 0 THEN
         SELECT ima135 INTO l_ima135
	   FROM ima_file
	  WHERE ima01=g_inb[p_ac].inb04
         IF NOT cl_null(l_ima135) THEN
            SELECT count(*) INTO l_n
              FROM tqx_file,tqy_file,tqz_file,tsa_file,
                   ima_file          
             WHERE tqx01 = g_inb[p_ac].inb1002
               AND tqx09 = g_ina.ina1023
               AND tqx01 = tqy01
               AND tqx01 = tqz01
               AND tqx01 = tsa01
               AND tqy02 = tsa02
               AND tqz02 = tsa03
               AND tqy03 = g_ina.ina1001
               AND tqz03 = ima01
               AND ima135= l_ima135
               AND tqz03 = g_inb[p_ac].inb04
               AND tqz06 <= g_ina.ina1013
               AND tqz07 >= g_ina.ina1013
               AND tqy37='Y'
               AND tqy38<=g_inba.ina1013
               AND tqxacti='Y'
            IF l_n=0 THEN
               CALL cl_err('','atm-397',0)
               RETURN 1
            END IF
         ELSE
            CALL cl_err('','atm-397',0)
            RETURN 1
         END IF
      END IF
# 取提案促銷價格
      SELECT UNIQUE tqz09,tqx14,tqx16,tqz08 
        INTO l_tqz09,l_tqx14,l_tqx16,l_tqz08
        FROM tqx_file,tqy_file,tqz_file
       WHERE tqx01= g_inb[p_ac].inb1002  
         AND tqx09 =g_ina.ina1023    
         AND tqz03= g_inb[p_ac].inb04      
         AND tqz06<= g_ina.ina1013 
         AND tqz07>= g_ina.ina1013
         AND tqx01=tqy01
         AND tqx01=tqz01
         AND tqxacti='Y'
         AND g_ina.ina1001 IN  
                 (SELECT tqy03
                    FROM tqy_file,tqx_file,tqz_file
                   WHERE tqx01= g_inb[p_ac].inb1002 
                     AND tqx09= g_ina.ina1023
                     AND tqz03= g_inb[p_ac].inb04 
                     AND tqz06<= g_ina.ina1013 
                     AND tqz07>= g_ina.ina1013 
                     AND tqx01=tqy01
                     AND tqx01=tqz01  
                     AND tqy37='Y'
                     AND tqy38<=g_ina.ina1013 )
      IF STATUS THEN
      #如料件編號在提案中不存在,抓不到促銷進價，則依據條碼抓取促銷進價
         IF NOT cl_null(l_ima135) THEN
            DECLARE t270_ima135 CURSOR FOR
             SELECT UNIQUE tqz09,tqx14,tqx16,tqz08
               FROM tqx_file,tqy_file,tqz_file,ima_file
              WHERE tqx01= g_inb[p_ac].inb1002    
                AND tqx09 =g_ina.ina1023    
                AND tqz03=ima01
                AND ima135=l_ima135    
                AND tqz06<= g_ina.ina1013 
                AND tqz07>= g_ina.ina1013
                AND tqx01=tqy01
                AND tqx01=tqz01
                AND tqxacti='Y'
                AND g_ina.ina1001 IN  
                   (SELECT tqy03
                      FROM tqy_file,tqx_file,tqz_file,
                           ima_file
                     WHERE tqx01= g_inb[p_ac].inb1002  
                       AND tqx09 =g_ina.ina1023        
                       AND tqz03=ima01
                       AND ima135=l_ima135      
                       AND tqz06<= g_ina.ina1013 
                       AND tqz07>= g_ina.ina1013   
                       AND tqx01=tqy01              
                       AND tqx01=tqz01     
                       AND tqy37='Y'
                       AND tqy38<=g_ina.ina1013 )
            FOREACH t270_ima135 INTO l1_tqz09,l1_tqx14,
                                     l1_tqx16,l1_tqz08
               IF STATUS THEN EXIT FOREACH END IF
               IF NOT cl_null(l1_tqz09) THEN 
                  EXIT FOREACH	                  	
               END IF
            END FOREACH
         ELSE
            CALL cl_err('',STATUS,0)
            RETURN 1
         END IF
      ELSE 
         IF l_tqx16 ='N' THEN                                                                                                      
            LET g_inb[p_ac].inb1003=l_tqz09                                                                                        
         ELSE                                                                                                                       
            LET g_inb[p_ac].inb1003=l_tqz09/(1+l_tqx14/100)                                                                       
         END IF            
      END IF
      #---單位換算
      IF g_sma.sma116='2' OR g_sma.sma116='3' THEN
         LET l_inb08=g_inb[p_ac].inb1004
      ELSE
         LET l_inb08=g_inb[p_ac].inb08
      END IF
      IF l1_tqz08 != l_inb08 THEN 
         CALL s_umfchk(g_inb[p_ac].inb04,l_inb08,l1_tqz08) 
              RETURNING l_flag,l_unitrate
         IF l_flag='0' THEN
            LET l1_tqz09=l1_tqz09*l_unitrate
         ELSE
            CALL cl_err('',STATUS,0)
            RETURN 1
         END IF
      END IF
      IF NOT cl_null(l1_tqx16) THEN 
         IF l1_tqx16 ='N' THEN
            LET g_inb[p_ac].inb1003=l1_tqz09
         ELSE
            LET g_inb[p_ac].inb1003=l1_tqz09/(1+l1_tqx14/100)
         END IF
      END IF
      IF cl_null(g_inb[p_ac].inb1004) THEN
         LET g_inb[p_ac].inb1005=g_inb[p_ac].inb09
      END IF
      LET g_inb[p_ac].inb1006 = g_inb[p_ac].inb1005* g_inb[p_ac].inb1003
   ELSE  #提案編號為空或者原因碼為贈品，重新依定價編號取價 
      SELECT occ1027 INTO l_occ1027 FROM occ_file
       WHERE occ01=g_ina.ina1001
      IF l_occ1027='N' AND g_ina.ina1001[1,4]!='MISC' THEN
         IF g_sma.sma116='2' OR g_sma.sma116='3' THEN
            LET l_unit=g_inb[p_ac].inb1004
         ELSE
            IF g_sma.sma115='N' THEN             #不使用雙單位
               LET l_unit=g_inb[p_ac].inb08
            ELSE 
               IF g_ima906='1' OR g_ima906='3' THEN 
                  LET l_unit=g_inb[p_ac].inb902  #使用單一單位或參考單位  
               ELSE                              #使用母子單位
                  SELECT img09                                                                                                        
                    INTO l_unit                                                                                                  
                    FROM ima_file,img_file                                                                                                         
                   WHERE ima01=g_inb[p_ac].inb04 AND ima01=img01                                                                                   
               END IF 
            END IF  
         END IF
         LET l_dbs=s_dbstring(g_dbs CLIPPED)      #TQC-940184       
        #LET l_plant=s_dbstring(g_plant CLIPPED)  #NO.FUN-980059  #No.FUN-AB0067--mark
         LET l_plant=g_plant                      #No.FUN-AB0067      
         IF NOT cl_null(l_unit) THEN 
            CALL s_fetch_price2(g_ina.ina1001,g_inb[p_ac].inb04,l_unit,g_ina.ina02,'1',l_plant,g_ina.ina1023) #No.FUN-980059
                 RETURNING g_inb[p_ac].inb1001,g_inb[p_ac].inb1003,l_success
            IF l_success ='N' THEN    
               CALL s_fetch_price2(g_ina.ina1001,g_inb[p_ac].inb04,l_unit,g_ina.ina02,'5',l_plant,g_ina.ina1023) #No.FUN-980059
                    RETURNING g_inb[p_ac].inb1001,g_inb[p_ac].inb1003,l_success 
               IF l_success ='N' THEN  
                  CALL cl_err(g_inb[p_ac].inb04,'atm-257',0)  
                  RETURN 1  
               END IF                                                                                   
            END IF
         END IF 
         IF cl_null(g_inb[p_ac].inb1004) THEN
            LET g_inb[p_ac].inb1005=g_inb[p_ac].inb09
         END IF     
         LET g_inb[p_ac].inb1006 = g_inb[p_ac].inb1005* g_inb[p_ac].inb1003       
      END IF
      IF g_azf10 = 'Y'  THEN      #No.FUN-6B0065
         LET g_inb[p_ac].inb1006=0
         LET g_inb_t.inb1006=0
      END IF
   END IF
   RETURN 0
END FUNCTION                                        
FUNCTION t270_confirm()    
DEFINE   l_inb05       LIKE inb_file.inb05 
  
   LET g_success='Y'                           
#No.FUN-AB0067--begin    
   CALL s_showmsg_init()   
#CHI-C30107 ------------- add --------------- begin
   IF g_ina.inaconf != 'Y' AND g_ina.inaconf != 'X' AND g_ina.inapost='N' THEN
   ELSE
      CALL cl_err('','atm-388',0)
      RETURN 
   END IF

   IF NOT cl_confirm('aap-222') THEN  RETURN END IF
   SELECT * INTO g_ina.* FROM ina_file WHERE ina01 = g_ina.ina01
#CHI-C30107 ------------- add --------------- end
   DECLARE t725_chk_ware CURSOR FOR SELECT inb05 FROM inb_file
                                   WHERE inb01=g_ina.ina01 
                                   #AND inb00=g_argv1
   FOREACH t725_chk_ware INTO l_inb05           
      IF NOT s_chk_ware(l_inb05) THEN
         LET g_success='N' 
      END IF 
   END FOREACH 
   CALL s_showmsg()
   IF g_success='N' THEN 
      RETURN 
   END IF    
#No.FUN-AB0067--end                                                                                  
   IF g_ina.inaconf != 'Y' AND g_ina.inaconf != 'X' AND g_ina.inapost='N' THEN  
#     IF cl_confirm('aap-222') THEN       #CHI-C30107 mark                                                                                            
         BEGIN WORK                                                                                                                    
         UPDATE ina_file SET inaconf = 'Y'                                                                                             
          WHERE ina01 = g_ina.ina01                                                                                                    
         IF SQLCA.sqlcode THEN                                                                                                         
            CALL cl_err3("upd","ina_file",g_ina.ina01,"",SQLCA.sqlcode,"","inaconf",1)  #No.FUN-660104
            ROLLBACK WORK                                                                                                              
         ELSE                                                                                                                          
            COMMIT WORK                                                                                                                 
            LET g_ina.inaconf = 'Y'                                                                                                     
            DISPLAY BY NAME g_ina.inaconf               
            CALL cl_set_field_pic(g_ina.inaconf,"","","","","")        #FUN-B30029 add                                                                        
         END IF                                                                                                                        
#     END IF               #CHI-C30107 mark                                                                                                     
   ELSE                                                                                                                          
      CALL cl_err('','atm-388',0)                                                                                                
   END IF                                                                                                                          
END FUNCTION        
FUNCTION t270_undo_confirm()                                                                                                       
   IF g_ina.inaconf='Y' AND g_ina.inapost='N' THEN  
      IF cl_confirm('aap-224') THEN                                                                                                   
         BEGIN WORK                                                                                                                    
         UPDATE ina_file SET inaconf = 'N'                                                                                             
          WHERE ina01 = g_ina.ina01                                                                                                    
         IF SQLCA.sqlcode THEN                                                                                                         
            CALL cl_err3("upd","ina_file",g_ina.ina01,"",SQLCA.sqlcode,"","inaconf",1)  #No.FUN-660104
            ROLLBACK WORK                                                                                                              
         ELSE                                                                                                                          
            COMMIT WORK                                                                                                                 
            LET g_ina.inaconf = 'N'                                                                                                     
            DISPLAY BY NAME g_ina.inaconf                                             
            CALL cl_set_field_pic(g_ina.inaconf,"","","","","")        #FUN-B30029 add                                                  
         END IF                                                                                                                        
      END IF                                                                                                                           
   ELSE                                                                                                                          
      CALL cl_err('','atm-389',0)    
   END IF                                                                                                                           
END FUNCTION
FUNCTION t270_set_inb1005()
   DEFINE l_item     LIKE img_file.img01,        #料號
          l_ima25    LIKE ima_file.ima25,        #ima單位
          l_img09    LIKE img_file.img09,        #銷售單位
          l_ima906   LIKE ima_file.ima906,
          l_fac2     LIKE img_file.img21,        #第二轉換率
          l_qty2     LIKE img_file.img10,        #第二數量
          l_fac1     LIKE img_file.img21,        #第一轉換率
          l_qty1     LIKE img_file.img10,        #第一數量
          l_tot      LIKE img_file.img10,        #計價數量
          l_unit     LIKE ima_file.ima25,     
          l_unit1    LIKE ima_file.ima25,     
          l_factor   LIKE tlf_file.tlf12           #No.FUN-680120 DECIMAL(16,8)
   SELECT ima25,img09,ima906
     INTO l_ima25,l_img09,l_ima906
     FROM ima_file,img_file
    WHERE ima01=g_inb[l_ac].inb04 AND ima01=img01
   IF SQLCA.sqlcode = 100 THEN
      IF g_inb[l_ac].inb04 MATCHES 'MISC*' THEN
         SELECT ima25,img09,ima906
           INTO l_ima25,l_img09,l_ima906
           FROM ima_file,img_file
          WHERE ima01='MISC' AND ima01=img01
      END IF
   END IF
   IF cl_null(l_img09) THEN
      LET l_img09=l_ima25
   END IF
   LET l_fac2=g_inb[l_ac].inb906
   LET l_qty2=g_inb[l_ac].inb907
   IF g_sma.sma115 = 'Y' THEN
      LET l_fac1 =g_inb[l_ac].inb903
      LET l_qty1 =g_inb[l_ac].inb904
      LET l_unit1=g_inb[l_ac].inb902   
   ELSE
      LET l_fac1=1
      LET l_qty1=g_inb[l_ac].inb09
      CALL s_umfchk(g_inb[l_ac].inb04,g_inb[l_ac].inb08,l_img09)
          RETURNING g_cnt,l_fac1
      IF g_cnt = 1 THEN
         LET l_fac1 = 1
      END IF
      LET l_unit1=g_inb[l_ac].inb08   
   END IF
   IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
   IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
   IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
   IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
   IF g_sma.sma115 = 'Y' THEN
      CASE l_ima906
         WHEN '1' LET l_tot=l_qty1*l_fac1
         WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
         WHEN '3' LET l_tot=l_qty1*l_fac1
      END CASE
   ELSE                                          #不使用雙單位
      LET l_tot=l_qty1*l_fac1
   END IF
   IF cl_null(l_tot) THEN
      LET l_tot = 0 
   END IF
   IF g_sma.sma116!='2' AND g_sma.sma116!='3' THEN
      IF g_sma.sma115 = 'Y' THEN
         CASE l_ima906
            WHEN '1' LET l_unit=l_unit1
            WHEN '2' LET l_unit=l_img09
            WHEN '3' LET l_unit=l_unit1
         END CASE
      ELSE                                       #不使用雙單位
         LET l_unit=l_unit1
      END IF
      LET g_inb[l_ac].inb1004=l_unit
   END IF
   LET l_factor = 1
   IF g_sma.sma115='Y' THEN
      CALL s_umfchk(g_inb[l_ac].inb04,g_inb[l_ac].inb08,g_inb[l_ac].inb1004)
          RETURNING g_cnt,l_factor
   ELSE
   CALL s_umfchk(g_inb[l_ac].inb04,l_img09,g_inb[l_ac].inb1004)
       RETURNING g_cnt,l_factor
   END IF                                 #No.CHI-960052
   IF g_cnt = 1 THEN
      LET l_factor = 1
   END IF
   LET l_tot = l_tot * l_factor
   LET g_inb[l_ac].inb1005 = l_tot
   LET g_inb[l_ac].inb1005 = s_digqty(g_inb[l_ac].inb1005,g_inb[l_ac].inb1004)   #FUN-BB0085
END FUNCTION
FUNCTION t270_refresh_detail()
  DEFINE l_compare          LIKE smy_file.smy62    
  DEFINE li_col_count       LIKE type_file.num5             #No.FUN-680120 SMALLINT
  DEFINE li_i, li_j         LIKE type_file.num5             #No.FUN-680120 SMALLINT
  DEFINE lc_agb03           LIKE agb_file.agb03
  DEFINE lr_agd             RECORD LIKE agd_file.*
  DEFINE lc_index           STRING
  DEFINE ls_combo_vals      STRING
  DEFINE ls_combo_txts      STRING
  DEFINE ls_sql             STRING
  DEFINE ls_show,ls_hide    STRING
  DEFINE l_gae04            LIKE gae_file.gae04
  #判斷是否進行料件多屬性新機制管理以及是否傳入了屬性群組
  IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' )AND(lg_smy62 IS NOT NULL) THEN
     #首先判斷有無單身記錄，如果單身根本沒有東東，則按照默認的lg_smy62來決定
     #顯示什么組別的信息，如果有單身，則進行下面的邏輯判斷
     IF g_inb.getLength() = 0 THEN
        LET lg_group = lg_smy62
     ELSE   
       #讀取當前單身所有的料件資料，如果它們都屬于多屬性子料件，并且擁有一致的
       #屬性群組，則以該屬性群組作為顯示單身明細屬性的依據，如果有不統一的狀況
       #則返回一個NULL，下面將不顯示任明細屬性列
       FOR li_i = 1 TO g_inb.getLength()
         #如果某一個料件沒有對應的母料件(已經在前面的b_fill中取出來放在imx00中了)
         #則不進行下面判斷直接退出了
         IF  cl_null(g_inb[li_i].att00) THEN
            LET lg_group = ''
            EXIT FOR
         END IF
         SELECT imaag INTO l_compare FROM ima_file WHERE ima01 = g_inb[li_i].att00
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
       END FOR 
     END IF
     #到這里時lg_group中存放的已經是應該顯示的組別了，該變量是一個全局變量
     #在單身INPUT或開窗時都會用到，因為refresh函數被執行的時機較早，所以能保証在需要的時候有值
     SELECT COUNT(*) INTO li_col_count FROM agb_file WHERE agb01 = lg_group
     #走到這個分支說明是采用新機制，那么使用att00父料件編號代替inb04子料件編號來顯示
     #得到當前語言別下inb04的欄位標題
     SELECT gae04 INTO l_gae04 FROM gae_file 
       WHERE gae01 = 'atmt270' AND gae02 = 'inb04' AND gae03 = g_lang
     CALL cl_set_comp_att_text("att00",l_gae04)
     #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
     IF NOT cl_null(lg_group) THEN
        LET ls_hide = 'inb04,ima02'
        LET ls_show = 'att00'
     ELSE
        LET ls_hide = 'att00'
        LET ls_show = 'inb04,ima02'
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
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
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
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("formonly.att" || lc_index || "_c","NOT NULL|REQUIRED|SCROLL","1|1|1")
          WHEN '3'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
       END CASE
     END FOR       
  ELSE
    #否則什么也不做(不顯示任何屬性列)
    LET li_i = 1
    #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
    LET ls_hide = 'att00'
    LET ls_show = 'inb04'
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
#--------------------在修改下面的代碼前請讀一下注釋先，謝了! -----------------------
#下面代碼是從單身INPUT ARRAY語句中的AFTER FIELD段中拷貝來的，因為在多屬性新模式下原來的inb04料件編號
#欄位是要被隱藏起來，并由新增加的imx00（母料件編號）+各個明細屬性欄位來取代，所以原來的AFTER FIELD
#代碼是不會被執行到，需要執行的判斷應該放新增加的几個欄位的AFTER FIELD中來進行，因為要用多次嘛，所以
#單獨用一個FUNCTION來放，順便把inb04的AFTER FIELD也移過來，免得將來維護的時候遺漏了
#下標g_inb[l_ac]都被改成g_inb[p_ac]，請注意
#本函數返回TRUE/FALSE,表示檢核過程是否通過，一般說來，在使用過程中應該是如下方式□
#    AFTER FIELD XXX
#        IF NOT t270_check_inb04(.....)  THEN NEXT FIELD XXX END IF        
FUNCTION t270_check_inb04(p_field,p_ac)
DEFINE
  p_field                     STRING,    #當前是在哪個欄位中觸發了AFTER FIELD事件
  p_ac                        LIKE type_file.num5,             #No.FUN-680120 SMALLINT  #g_inb數組中的當前記錄下標
  l_ps                        LIKE sma_file.sma46,
  l_str_tok                   base.stringTokenizer,
  l_tmp, ls_sql               STRING,
  l_param_list                STRING,
  l_cnt, li_i                 LIKE type_file.num5,             #No.FUN-680120 SMALLINT
  ls_value                    STRING,
  lv_value                    LIKE ima_file.ima01,
  ls_pid,ls_value_fld         LIKE ima_file.ima01,
  ls_name, ls_spec            STRING, 
  lc_agb03                    LIKE agb_file.agb03,
  lc_agd03                    LIKE agd_file.agd03,
  ls_pname                    LIKE ima_file.ima02,
  l_misc                      LIKE ade_file.ade04,             #No.FUN-680120 VARCHAR(04)
  l_n                         LIKE type_file.num5,             #No.FUN-680120 SMALLINT
  l_b2                        LIKE ima_file.ima31,
  l_ima25                     LIKE ima_file.ima25,
  l_imaacti                   LIKE ima_file.imaacti,
  l_qty                       LIKE type_file.num10,            #No.FUN-680120 INTEGER
  p_cmd                       STRING,
  l_ima135                    LIKE ima_file.ima135,
  l_ima1002                   LIKE ima_file.ima1002,
  l_ima35                     LIKE ima_file.ima35,
  l_ima36                     LIKE ima_file.ima36,
  l_occ1028                   LIKE occ_file.occ1028,
  l_ima1010                   LIKE ima_file.ima1010,
  l_fac                       LIKE oeb_file.oeb05_fac,
  l_ima140                    LIKE ima_file.ima140,                                                                                           
  l_ima1401                   LIKE ima_file.ima1401,       #FUN-6A0036 add                                                                                          
  l_imaag                     LIKE ima_file.imaag,         #No.FUN-640056      
  l_max                       LIKE tqw_file.tqw07,
  l_check_r                   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(01)
DEFINE l_flag                 LIKE type_file.chr1          #No.FUN-830132
     #如果當前欄位是新增欄位（母料件編號以及十個明細屬性欄位）的時候，如果全部輸了值則合成出一個
     #新的子料件編號并把值填入到已經隱藏起來的inb04中（如果imxXX能夠顯示，inb04一定是隱藏的）
     #下面就可以直接沿用inb04的檢核邏輯了
     #如果不是，則看看是不是inb04自己觸發了，如果還不是則什么也不做(無聊)，返回一個FALSE
     IF NOT cl_null(g_inb[l_ac].inb04) AND g_sma.sma120 = 'N' THEN
           SELECT imaag INTO l_imaag FROM ima_file                                                                            
            WHERE ima01 =g_inb[l_ac].inb04                                                                                    
           IF NOT CL_null(l_imaag) AND l_imaag <> '@CHILD' THEN     #TQC-650015                                                             
              CALL cl_err(g_inb[l_ac].inb04,'aim1004',0)                                                                      
              RETURN FALSE
           END IF                                                                                                             
     END IF                                                                                                             
     IF ( p_field = 'imx00' )OR( p_field = 'imx01' )OR( p_field = 'imx02' )OR
        ( p_field = 'imx03' )OR( p_field = 'imx04' )OR( p_field = 'imx05' )OR
        ( p_field = 'imx06' )OR( p_field = 'imx07' )OR( p_field = 'imx08' )OR
        ( p_field = 'imx09' )OR( p_field = 'imx10' ) THEN
        #首先判斷需要的欄位是否全部完成了輸入（只有母料件編號+被顯示出來的所有明細屬性
        #全部被輸入完成了才進行后續的操作
        LET ls_pid = g_inb[p_ac].att00   # ls_pid 父料件編號
        LET ls_value = g_inb[p_ac].att00   # ls_value 子料件編號
        IF cl_null(ls_pid) THEN 
           #MOD-640107 Add ,所有要返回TRUE的分支都要加這兩句話,原來下面的會被
           #注釋掉
           CALL t270_set_no_entry_b()
           CALL t270_set_required()
           RETURN TRUE
        END IF  #注意這里沒有錯，所以返回TRUE
        #取出當前母料件包含的明細屬性的個數
        SELECT COUNT(*) INTO l_cnt FROM agb_file WHERE agb01 = 
           (SELECT imaag FROM ima_file WHERE ima01 = ls_pid)
        IF l_cnt = 0 THEN
           #MOD-640107 Add ,所有要返回TRUE的分支都要加這兩句話,原來下面的會被
           #注釋掉
           CALL t270_set_no_entry_b()
           CALL t270_set_required()
            RETURN TRUE
        END IF
        FOR li_i = 1 TO l_cnt
            #如果有任何一個明細屬性應該輸而沒有輸的則退出
            IF cl_null(arr_detail[p_ac].imx[li_i]) THEN 
               #MOD-640107 Add ,所有要返回TRUE的分支都要加這兩句話,原來下面的會被
               #注釋掉
               CALL t270_set_no_entry_b()
               CALL t270_set_required()
               RETURN TRUE
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
        LET g_value = ls_value
        LET g_chr4  = '1'
        #把生成的子料件賦給inb04，否則下面的檢查就沒有意義了
        LET g_inb[p_ac].inb04 = ls_value
        SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_inb[l_ac].inb04                                                           
        IF l_n=0 THEN                                                                                                                  
           CALL cl_err('inb04','ams-003',1)                                                                                            
           RETURN FALSE
        END IF                                
     ELSE 
       IF ( p_field <> 'inb04' )AND( p_field <> 'imx00' ) THEN 
          RETURN FALSE
       END IF
     END IF
  #到這里已經完成了以前在cl_itemno_multi_att()中做的所有准備工作，在系統資料庫
  #中已經有了對應的子料件的名稱，下面可以按照inb04進行判斷了
  #--------重要 !!!!!!!!!!!-------------------------
  #下面的代碼都是從原INPUT ARRAY中的AFTER FIELD inb04段拷貝來的，唯一做的修改
  #是將原來的NEXT FIELD 語句都改成了RETURN FALSE, xxx,xxx ... ，因為NEXE FIELD
  #語句要交給調用方來做，這里只需要返回一個FALSE告訴它有錯誤就可以了，同時一起
  #返回的還有一些CHECK過程中要從ima_file中取得的欄位信息，其他的比如判斷邏輯和
  #錯誤提示都沒有改，如果你需要在里面添加代碼請注意上面的那個要點就可以了
  IF NOT cl_null(g_inb[l_ac].inb04) THEN
     #新增一個判斷,如果lg_smy62不為空,表示當前采用的是料件多屬性的新機制,因此這個函數應該是被
     #attxx這樣的明細屬性欄位的AFTER FIELD來調用的,所以不再使用原來的輸入機制,否則不變
     IF cl_null(lg_smy62) THEN
       IF g_sma.sma120 = 'Y' THEN
          CALL cl_itemno_multi_att("inb04",g_inb[l_ac].inb04,"","1","4")
               RETURNING l_check_r,g_inb[l_ac].inb04,g_inb[l_ac].ima02
          IF l_check_r = '0' THEN                                                                                                   
             RETURN FALSE
          END IF
          DISPLAY g_inb[l_ac].inb04 TO inb04
          DISPLAY g_inb[l_ac].ima02 TO ima02
          LET g_value = g_inb[l_ac].inb04
          LET g_chr4  = '1'
          SELECT imx00 INTO g_inb04
            FROM imx_file
           WHERE imx000 = g_inb[l_ac].inb04
       END IF
     END IF
           #判斷若為Phase out則show警示語
              SELECT ima140,ima1401 INTO l_ima140,l_ima1401 FROM ima_file  #FUN-6A0036 add(ima1401)
               WHERE ima01=g_inb[l_ac].inb04
              IF (l_ima140 = 'Y' AND l_ima1401 <= g_ina.ina02) AND g_ina.ina00 MATCHES '[34]' THEN  #FUN-6A0036
                 CALL cl_err('','aim-809',1)
              END IF
              IF g_inb[l_ac].inb04[1,4]!='MISC' THEN                
                 SELECT count(*) INTO l_n
                   FROM ima_file
                  WHERE ima01=g_inb[l_ac].inb04 
                 IF l_n = 0 THEN                                                                                                      
                    CALL cl_err('',100,0)                                                                                             
                    LET g_inb[l_ac].inb04 = g_inb_t.inb04                                                                                                                                                                           
                    RETURN FALSE
                 ELSE
                    SELECT ima1010,imaacti INTO l_ima1010,l_imaacti 
                      FROM ima_file
                     WHERE ima01=g_inb[l_ac].inb04 
                    CASE                                                                                                                             
                      WHEN l_imaacti='N'  
                           CALL cl_err('','9028',0)    
                           LET g_inb[l_ac].inb04 = g_inb_t.inb04                                                                           
                           RETURN FALSE
                      WHEN l_ima1010<>'1'        #No.FUN-690025 mod
                           CALL cl_err('','atm-017',0)      
                           LET g_inb[l_ac].inb04 = g_inb_t.inb04                                                                           
                           RETURN FALSE
                      OTHERWISE EXIT CASE
                    END CASE                                                                                                  
                 END IF 
                 SELECT ima02,ima021,ima25,ima1002,ima135,ima908,ima35,ima36   #CHI-6A0015 add ima35/36 
                   INTO g_inb[l_ac].ima02,g_inb[l_ac].ima021,l_b2,g_inb[l_ac].ima1002,g_inb[l_ac].ima135,g_inb[l_ac].inb1004,
                        #g_inb[l_ac].inb05,g_inb[l_ac].inb06     #CHI-6A0015 add  #TQC-750018
                        l_ima35,l_ima36                                           #TQC-750018
                   FROM ima_file 
                  WHERE ima01=g_inb[l_ac].inb04 AND imaacti='Y'
                 IF STATUS THEN
                    CALL cl_err3("sel","ima_file",g_inb[l_ac].inb04,"",STATUS,"","sel ima",1)  #No.FUN-660104
                         RETURN FALSE
                 END IF
                 #No.FUN-AB0067--begin   
                 ##No.FUN-AA0062  --Begin
                 #IF NOT s_chk_ware(l_ima35) THEN
                 #   LET l_ima35 = ''
                 #   LET l_ima36 = ''
                 #END IF
                 ##No.FUN-AA0062  --End   
                 #No.FUN-AB0067--end                                
                  IF cl_null(g_inb_t.inb04) OR g_inb_t.inb04 <> g_inb[l_ac].inb04 THEN
                     LET g_inb[l_ac].inb05 = l_ima35
                     LET g_inb[l_ac].inb06 = l_ima36 
                     LET g_inb[l_ac].inb07 = NULL
                  END IF
              END IF
              SELECT COUNT(*) INTO g_cnt FROM inb_file
               WHERE inb01=g_ina.ina01
                 AND inb03<>g_inb[l_ac].inb03
                 AND inb04=g_inb[l_ac].inb04
              IF g_cnt>0 THEN CALL cl_err('','aim-401',0) END IF
              IF g_sma.sma115 = 'Y' THEN
                 CALL s_chk_va_setting(g_inb[l_ac].inb04)
                      RETURNING g_flag,g_ima906,g_ima907
                 IF g_flag=1 THEN
                    RETURN FALSE
                 END IF
                 IF g_ima906 = '3' THEN
                    LET g_inb[l_ac].inb905=g_ima907
                 END IF
              END IF
              IF g_inb_t.inb04 IS NULL OR g_inb[l_ac].inb04 <> g_inb_t.inb04 THEN
                 LET g_change = 'Y'
                 CALL t270_price(l_ac) RETURNING l_fac                                                                           
              END IF                         
           CALL t270_set_no_entry_b()
           CALL t270_set_required()
     RETURN TRUE
  ELSE
     #如果是由inb04來觸發的,說明當前用的是舊的流程,那么inb04為空是可以的
     #如果是由att00來觸發,原理一樣
     IF ( p_field = 'inb04' )OR( p_field = 'imx00' ) THEN 
        #MOD-640107 Add ,所有要返回TRUE的分支都要加這兩句話,原來下面的會被
        #注釋掉
        CALL t270_set_no_entry_b()
        CALL t270_set_required()
        RETURN TRUE
     ELSE 
        #如果不是inb,則是由attxx來觸發的,則非輸不可
        RETURN FALSE
     END IF #如果為空則不允許新增
  END IF
END FUNCTION
#用于att01~att10這十個輸入型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att10)
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可
#與t270_check_inb04相同,如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION t270_check_att0x(p_value,p_index,p_row)
DEFINE
  p_value      LIKE imx_file.imx01,
  p_index      LIKE type_file.num5,             #No.FUN-680120 SMALLINT
  p_row        LIKE type_file.num5,             #No.FUN-680120 SMALLINT
  li_min_num   LIKE agc_file.agc05,
  li_max_num   LIKE agc_file.agc06,
  l_index      STRING,
  l_check_res     LIKE type_file.num5,             #No.FUN-680120 SMALLINT
  l_b2            LIKE nma_file.nma04,             #No.FUN-680120 VARCHAR(30)
  l_imaacti       LIKE ima_file.imaacti,
  l_ima25         LIKE ima_file.ima25 
  #這個欄位一旦進入了就不能忽略，因為要保証在輸入其他欄位之前必須要生成inb04料件編號
  IF cl_null(p_value) THEN 
     RETURN FALSE
  END IF
  #這里使用到了一個用于存放當前屬性組包含的所有屬性信息的全局數組lr_agc
  #該數組會由t270_refresh_detail()函數在較早的時候填充
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
  #通過了欄位檢查則可以下面的合成子料件代碼以及相應的檢核操作了
  LET arr_detail[p_row].imx[p_index] = p_value
  LET l_index = p_index USING '&&'
  CALL t270_check_inb04('imx' || l_index ,p_row) 
    RETURNING l_check_res
    RETURN l_check_res
END FUNCTION
#用于att01_c~att10_c這十個選擇型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att10)
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可
#與t270_check_inb04相同,如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION t270_check_att0x_c(p_value,p_index,p_row)
DEFINE
  p_value  LIKE imx_file.imx01,
  p_index  LIKE type_file.num5,             #No.FUN-680120 SMALLINT
  p_row    LIKE type_file.num5,             #No.FUN-680120 SMALLINT
  l_index  STRING,
  l_check_res     LIKE type_file.num5,             #No.FUN-680120 SMALLINT
  l_b2            LIKE ima_file.ima25,             #No.FUN-680120 VARCHAR(04)
  l_imaacti       LIKE ima_file.imaacti,
  l_ima25         LIKE ima_file.ima25
  #這個欄位一旦進入了就不能忽略，因為要保証在輸入其他欄位之前必須要生成inb04料件編號
  IF cl_null(p_value) THEN 
     RETURN FALSE
  END IF       
  #下拉框選擇項相當簡單，不需要進行范圍和長度的判斷，因為肯定是符合要求的了  
  LET arr_detail[p_row].imx[p_index] = p_value
  LET l_index = p_index USING '&&'
  CALL t270_check_inb04('imx'||l_index,p_row)
    RETURNING l_check_res
  RETURN l_check_res
END FUNCTION         
FUNCTION t270_mu_ui()
    CALL cl_set_comp_visible("inb903,inb906",FALSE)
    CALL cl_set_comp_visible("ina1022,ina1021",FALSE)   #No.TQC-640124
    IF g_sma.sma116='2' OR g_sma.sma116='3' THEN
       CALL cl_set_comp_visible("inb1004,inb1005",TRUE)
    ELSE 
       CALL cl_set_comp_visible("inb1004,inb1005",FALSE)
    END IF
    IF g_sma.sma115 ='N' THEN
       CALL cl_set_comp_visible("inb905,inb906,inb907",FALSE)
       CALL cl_set_comp_visible("inb902,inb903,inb904",FALSE)
    ELSE
       CALL cl_set_comp_visible("inb08,inb08_fac,inb09",FALSE)
    END IF
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("inb905",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("inb907",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("inb902",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("inb904",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("inb905",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("inb907",g_msg CLIPPED)
       IF g_argv1 MATCHES '[12]' THEN
          CALL cl_getmsg('asm-315',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb902",g_msg CLIPPED)
          CALL cl_getmsg('asm-317',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb904",g_msg CLIPPED)
       END IF
       IF g_argv1 MATCHES '[34]' THEN
          CALL cl_getmsg('asm-314',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb902",g_msg CLIPPED)
          CALL cl_getmsg('asm-318',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb904",g_msg CLIPPED)
       END IF
       IF g_argv1 MATCHES '[56]' THEN
          CALL cl_getmsg('asm-316',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb902",g_msg CLIPPED)
          CALL cl_getmsg('asm-319',g_lang) RETURNING g_msg
          CALL cl_set_comp_att_text("inb904",g_msg CLIPPED)
       END IF
    END IF
END FUNCTION
#FUN-BB0085----add----str----
FUNCTION t270_inb09_check()

   IF NOT cl_null(g_inb[l_ac].inb08) AND NOT cl_null(g_inb[l_ac].inb09) THEN
      IF cl_null(g_inb08_t) OR g_inb08_t != g_inb[l_ac].inb08
         OR cl_null(g_inb_t.inb09) OR g_inb_t.inb09 != g_inb[l_ac].inb09 THEN
         LET g_inb[l_ac].inb09 = s_digqty(g_inb[l_ac].inb09,g_inb[l_ac].inb08)
         DISPLAY BY NAME g_inb[l_ac].inb09
      END IF
   END IF
   IF g_inb[l_ac].inb09=0 THEN
       CALL cl_err("","aim-120",0)
       RETURN FALSE      
   END IF
   IF NOT cl_null(g_inb[l_ac].inb09) THEN
      IF g_inb_t.inb09 IS NULL OR g_inb_t.inb09 <> g_inb[l_ac].inb09 THEN
         IF g_sma.sma116!='2' AND g_sma.sma116!='3' THEN
            LET g_inb[l_ac].inb1006=g_inb[l_ac].inb1003*g_inb[l_ac].inb09
         END IF
      END IF
      IF g_ina.ina00 MATCHES "[1256]" THEN
         SELECT img10 INTO g_img10 FROM img_file
            WHERE img01=g_inb[l_ac].inb04 AND img02=g_inb[l_ac].inb05
            AND img03=g_inb[l_ac].inb06 AND img04=g_inb[l_ac].inb07
         IF g_inb[l_ac].inb09*g_inb[l_ac].inb08_fac > g_img10 THEN
           #FUN-D30024--modify--str--
           #INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
           #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_inb[l_ac].inb05) RETURNING g_sma894      #FUN-C80107
           ##IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN                               #FUN-C80107 mark
           #IF g_sma894 = 'N' THEN                                                                    #FUN-C80107
            INITIALIZE g_imd23 TO NULL
            CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING g_imd23     #TQC-D40078 g_plant
            IF g_imd23 = 'N' THEN
           #FUN-D30024--modify--end--
               CALL cl_err(g_inb[l_ac].inb09*g_inb[l_ac].inb08_fac,'mfg1303',1)
               RETURN FALSE   
            ELSE
               IF NOT cl_confirm('mfg3469') THEN
                  RETURN FALSE    
               END IF
            END IF
         END IF
      END IF
   ELSE
      CALL cl_err("","aim-120",0)
      RETURN FALSE    
   END IF
   IF g_change1='Y' THEN
      CALL t270_set_inb1005()
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t270_inb907_check(p_cmd)
DEFINE p_cmd    LIKE type_file.chr1

   IF NOT cl_null(g_inb[l_ac].inb905) AND NOT cl_null(g_inb[l_ac].inb907) THEN
      IF cl_null(g_inb905_t) OR g_inb905_t != g_inb[l_ac].inb905
         OR cl_null(g_inb_t.inb907) OR g_inb_t.inb907 != g_inb[l_ac].inb907 THEN
         LET g_inb[l_ac].inb907 = s_digqty(g_inb[l_ac].inb907,g_inb[l_ac].inb905)
         DISPLAY BY NAME g_inb[l_ac].inb907
      END IF
   END IF
   IF g_inb_t.inb907 IS NULL AND g_inb[l_ac].inb907 IS NOT NULL OR
      g_inb_t.inb907 IS NOT NULL AND g_inb[l_ac].inb907 IS NULL OR
      g_inb_t.inb907 <> g_inb[l_ac].inb907 THEN
      LET g_change1='Y'
   END IF
   IF NOT cl_null(g_inb[l_ac].inb907) THEN
      IF g_inb[l_ac].inb907 < 0 THEN
         CALL cl_err('','aim-391',0)
         RETURN FALSE
      END IF
      IF p_cmd = 'a' THEN
         IF g_ima906='3' THEN
            LET g_tot=g_inb[l_ac].inb907*g_inb[l_ac].inb906
            IF cl_null(g_inb[l_ac].inb904) OR g_inb[l_ac].inb904=0 THEN 
               LET g_inb[l_ac].inb904=g_tot*g_inb[l_ac].inb903
               LET g_inb[l_ac].inb904=s_digqty(g_inb[l_ac].inb904,g_inb[l_ac].inb902)
               DISPLAY BY NAME g_inb[l_ac].inb904
            END IF
         END IF
      END IF
      IF g_ima906 MATCHES '[23]' THEN
         SELECT imgg10 INTO g_imgg10_2 FROM imgg_file
          WHERE imgg01=g_inb[l_ac].inb04
            AND imgg02=g_inb[l_ac].inb05
            AND imgg03=g_inb[l_ac].inb06
            AND imgg04=g_inb[l_ac].inb07
            AND imgg09=g_inb[l_ac].inb905
      END IF
      IF NOT cl_null(g_inb[l_ac].inb905) THEN
         IF g_ina.ina00 MATCHES '[1256]' THEN
            IF g_sma.sma117 = 'N' THEN
               IF g_inb[l_ac].inb907 > g_imgg10_2 THEN
                 #FUN-D30024--modify--str--
                 #INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
                 #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_inb[l_ac].inb05) RETURNING g_sma894      #FUN-C80107
                 ##IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN                               #FUN-C80107 mark
                 #IF g_sma894 = 'N' THEN                                                                    #FUN-C80107
                  INITIALIZE g_imd23 TO NULL
                  CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant
                  IF g_imd23 = 'N' THEN
                 #FUN-D30024--modify--end--
                     CALL cl_err(g_inb[l_ac].inb907,'mfg1303',1)
                     RETURN FALSE
                  ELSE
                     IF NOT cl_confirm('mfg3469') THEN
                        RETURN FALSE     
                     ELSE
                        LET g_yes = 'Y'
                     END IF
                  END IF
               END IF
            END IF
         END IF
      END IF
   END IF
   IF g_change1='Y' THEN
      CALL t270_set_inb1005()
   END IF
   CALL cl_show_fld_cont()
   RETURN TRUE
END FUNCTION

FUNCTION t270_inb904_check()

   IF NOT cl_null(g_inb[l_ac].inb902) AND NOT cl_null(g_inb[l_ac].inb904) THEN
      IF cl_null(g_inb902_t) OR g_inb902_t != g_inb[l_ac].inb902
         OR cl_null(g_inb_t.inb904) OR g_inb_t.inb904 != g_inb[l_ac].inb904 THEN
         LET g_inb[l_ac].inb904 = s_digqty(g_inb[l_ac].inb904,g_inb[l_ac].inb902)
         DISPLAY BY NAME g_inb[l_ac].inb904
      END IF
   END IF
   IF g_inb_t.inb904 IS NULL AND g_inb[l_ac].inb904 IS NOT NULL OR
      g_inb_t.inb904 IS NOT NULL AND g_inb[l_ac].inb904 IS NULL OR
      g_inb_t.inb904 <> g_inb[l_ac].inb904 THEN
      LET g_change1='Y'
   END IF
   IF NOT cl_null(g_inb[l_ac].inb904) THEN
      IF g_inb[l_ac].inb904 < 0 THEN
         CALL cl_err('','aim-391',0)
         RETURN 'inb904'
      END IF
      IF NOT cl_null(g_inb[l_ac].inb902) THEN
         IF g_ina.ina00 MATCHES '[1256]' THEN
           #INITIALIZE g_sma894 TO NULL #FUN-C80107  #FUN-D30024 mark
            INITIALIZE g_imd23 TO NULL  #FUN-D30023
            IF g_ima906 = '2' THEN
               IF g_sma.sma117 = 'N' THEN
                  IF g_inb[l_ac].inb904 > g_imgg10_1 THEN
                    #IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN  #FUN-C80107 mark
                    #FUN-D30024--modify--str--
                    #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_inb[l_ac].inb05) RETURNING g_sma894      #FUN-C80107
                    #IF g_sma894 = 'N' THEN                                                                    #FUN-C80107
                     CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING g_imd23   #TQC-D40078 g_plant
                     IF g_imd23 = 'N' THEN
                    #FUN-D30024--modify--end--
                        CALL cl_err(g_inb[l_ac].inb904,'mfg1303',1)
                        RETURN 'inb904'
                     ELSE
                        IF NOT cl_confirm('mfg3469') THEN
                           RETURN 'inb904'
                        ELSE
                           LET g_yes = 'Y'
                        END IF
                     END IF
                  END IF
               END IF
            ELSE
               IF g_inb[l_ac].inb904 * g_inb[l_ac].inb903 > g_imgg10_1 THEN
                 #IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN   #FUN-C80107 mark
                 #FUN-D30024--modify--str--
                 #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_inb[l_ac].inb05) RETURNING g_sma894      #FUN-C80107
                 #IF g_sma894 = 'N' THEN                                                                    #FUN-C80107
                  CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING g_imd23    #TQC-D40078 g_plant
                  IF g_imd23 = 'N' THEN
                 #FUN-D30024--modify--end--
                     CALL cl_err(g_inb[l_ac].inb904,'mfg1303',1)
                     RETURN 0
                  ELSE
                     IF NOT cl_confirm('mfg3469') THEN
                        RETURN 'inb904'
                     ELSE
                        LET g_yes = 'Y'
                     END IF
                  END IF
               END IF
            END IF
         END IF
      END IF
      CALL t270_du_data_to_correct()
      CALL t270_set_origin_field()
      IF g_inb[l_ac].inb09 IS NULL OR g_inb[l_ac].inb09=0 THEN
         IF g_ima906 MATCHES '[23]' THEN
            RETURN 'inb907'
         ELSE
            RETURN 'inb904'
         END IF
      END IF
   END IF
   IF g_change1='Y' THEN
      CALL t270_set_inb1005()
   END IF
   CALL cl_show_fld_cont()
   RETURN NULL
END FUNCTION

FUNCTION t270_inb1005_check()
   IF NOT cl_null(g_inb[l_ac].inb1004) AND NOT cl_null(g_inb[l_ac].inb1005) THEN 
      IF cl_null(g_inb1004_t) OR g_inb1004_t != g_inb[l_ac].inb1004
         OR cl_null(g_inb_t.inb1005) OR g_inb_t.inb1005 != g_inb[l_ac].inb1005 THEN 
         LET g_inb[l_ac].inb1005 = s_digqty(g_inb[l_ac].inb1005,g_inb[l_ac].inb1004) 
         DISPLAY BY NAME g_inb[l_ac].inb1005
      END IF
   END IF
   IF g_inb[l_ac].inb1005<0 THEN
      CALL cl_err('','anm-249',0)
      RETURN FALSE
   END IF
   IF NOT cl_null(g_inb[l_ac].inb1005) THEN
      IF g_inb_t.inb1005 IS NULL OR g_inb_t.inb1005 <> g_inb[l_ac].inb1005 THEN
         LET g_inb[l_ac].inb1006=g_inb[l_ac].inb1003*g_inb[l_ac].inb1005
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-BB0085----add----end----
#No.FUN-9C0073 -----------------By chenls 10/01/05
#FUN-C80107 add begin------------------------------------------- 121024
FUNCTION t270_chk_img()
DEFINE l_cnt LIKE type_file.num5
   IF l_ac <=0 THEN RETURN END IF
   IF cl_null(g_inb[l_ac].inb05) THEN RETURN END IF
   IF cl_null(g_inb[l_ac].inb06) THEN LET g_inb[l_ac].inb06 = ' ' END IF
   IF cl_null(g_inb[l_ac].inb07) THEN LET g_inb[l_ac].inb07 = ' ' END IF
   SELECT COUNT(*) INTO l_cnt FROM img_file
    WHERE img01=g_inb[l_ac].inb04
      AND img02=g_inb[l_ac].inb05
      AND img03=g_inb[l_ac].inb06
      AND img04=g_inb[l_ac].inb07
   IF l_cnt=0 THEN
     #FUN-D30024--modify--str--
     #INITIALIZE g_sma894 TO NULL
     #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_inb[l_ac].inb05) RETURNING g_sma894
     #IF g_sma894 = 'N' AND g_ina.ina00 MATCHES '[1256]' THEN
      INITIALIZE g_imd23 TO NULL
      CALL s_inv_shrt_by_warehouse(g_inb[l_ac].inb05,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant
      IF g_imd23 = 'N' AND g_ina.ina00 MATCHES '[1256]' THEN
     #FUN-D30024--modify--end--
         CALL cl_err3("sel","img_file",g_inb[l_ac].inb04,"","mfg6069","","",1)
         RETURN FALSE
      ELSE
         IF g_sma.sma892[3,3] = 'Y' THEN
            IF NOT cl_confirm('mfg1401') THEN
               RETURN FALSE
            END IF
         END IF
         CALL s_add_img(g_inb[l_ac].inb04,g_inb[l_ac].inb05,
                        g_inb[l_ac].inb06,g_inb[l_ac].inb07,
                        g_ina.ina01,g_inb[l_ac].inb03,g_ina.ina02)
         IF g_errno='N' THEN
            RETURN FALSE
         END IF
      END IF
   END IF
   SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
    WHERE img01=g_inb[l_ac].inb04 AND img02=g_inb[l_ac].inb05
      AND img03=g_inb[l_ac].inb06 AND img04=g_inb[l_ac].inb07
   IF cl_null(g_inb[l_ac].inb08) THEN
      LET g_inb[l_ac].inb08=g_img09
      DISPLAY BY NAME g_inb[l_ac].inb08
   END IF
   SELECT COUNT(*) INTO g_cnt FROM img_file
    WHERE img01 = g_inb[l_ac].inb04   #料號
      AND img02 = g_inb[l_ac].inb05   #倉庫
      AND img03 = g_inb[l_ac].inb06   #儲位
      AND img04 = g_inb[l_ac].inb07   #批號
      AND img18 < g_ina.ina02         #調撥日期
   IF g_cnt > 0 THEN                  #大于有效日期
      call cl_err('','aim-400',0)     #須修改
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
#FUN-C80107 add end---------------------------------------------

#TQC-D20031---add---str---
FUNCTION t270_inb15_check()   #理由碼
DEFINE
    l_n       LIKE type_file.num5,    #FUN-CB0087
    l_sql     STRING,                 #FUN-CB0087
    l_where   STRING,                 #FUN-CB0087
    l_flag    LIKE type_file.chr1     #FUN-CB0087


    LET l_flag = FALSE
    CALL s_get_where(g_ina.ina01,g_ina.ina10,'',g_inb[l_ac].inb04,g_inb[l_ac].inb05,g_ina.ina11,g_ina.ina04) RETURNING l_flag,l_where
    IF NOT cl_null(g_inb[l_ac].inb15) THEN
       LET l_n = 0
       IF g_aza.aza115='Y' AND l_flag THEN
          LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_inb[l_ac].inb15,"' AND ",l_where
          PREPARE ggc08_pre2 FROM l_sql
          EXECUTE ggc08_pre2 INTO l_n
          IF l_n < 1 THEN  
             CALL cl_err(g_inb[l_ac].inb15,'aim-425',0)
             RETURN FALSE  
          END IF
       ELSE
          SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01 = g_inb[l_ac].inb15 AND azf02='2'
          IF l_n < 1 THEN
             CALL cl_err(g_inb[l_ac].inb15,'aim-425',0)
             RETURN FALSE
          END IF
       END IF
    ELSE                          #TQC-D20047
       CALL t270_azf03_desc()     #TQC-D20047
    END IF
RETURN TRUE
END FUNCTION

FUNCTION t270_inb15_chk2()
DEFINE l_flag       LIKE type_file.chr1,
       l_sql        STRING,
       l_where      STRING,
       l_n          LIKE type_file.num5,
       l_i          LIKE type_file.num5
   IF g_aza.aza115 = 'Y' THEN
      FOR l_i=1 TO g_inb.getlength()
         CALL s_get_where(g_ina.ina01,g_ina.ina10,'',g_inb[l_i].inb04,g_inb[l_i].inb05,g_ina.ina11,g_ina.ina04) RETURNING l_flag,l_where
         IF l_flag THEN
            LET l_n=0
            LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_inb[l_i].inb15,"' AND ",l_where
            PREPARE ggc08_pre3 FROM l_sql
            EXECUTE ggc08_pre3 INTO l_n
            IF l_n < 1 THEN
               CALL cl_err('','aim-425',1)
               RETURN FALSE
            END IF
         END IF
      END FOR
   END IF
   RETURN TRUE
END FUNCTION
#TQC-D20031---add---end---
#TQC-D20047---add---str---
FUNCTION t270_azf03_desc()
   IF NOT cl_null(g_inb[l_ac].inb15) THEN
      SELECT azf03 INTO g_inb[l_ac].azf03 FROM azf_file
                   WHERE azf01=g_inb[l_ac].inb15  AND azfacti='Y' #TQC-D20063
                     AND azf02 = '2'
      DISPLAY BY NAME g_inb[l_ac].azf03
   ELSE
      LET g_inb[l_ac].azf03 = ' '
      DISPLAY BY NAME g_inb[l_ac].azf03
   END IF
END FUNCTION
#TQC-D20047---add---end---
