# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aimt309.4gl
# Date & Author..: 03/02/27 By Mandy
# Modify.........: No:7857 03/08/20 By Mandy  呼叫自動取單號時應在 Transction中
# Modify.........: No.MOD-470041 04/07/20 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-480396 04/09/01 By Nicola 修改單身輸入順序
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.MOD-4A0050 04/10/06 By Mandy 過帳的時候再check一次倉/儲/批不可空白
# Modify.........: No.FUN-4A0073 04/10/11 By Carol1.借料單號應該開出未歸還之料號
#                                                 2.項次開窗應只開出該借料單未歸還之項次,並show 出未歸還數量
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0053 04/12/08 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.MOD-510086 05/01/12 By ching 登打數message錯誤
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC()方式的改成用LIKE方式
# Modify.........: No.FUN-550011 05/05/25 By kim GP2.0功能 庫存單據不同期要check庫存是否為負
# Modify.........: No.FUN-550029 05/05/30 By vivien 單據編號格式放大
# Modify.........: No.FUN-550108 05/05/26 By echo 新增報表備註
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: No.MOD-570022 05/07/04 By kim DELETE tlf_file時,加入tlf905, tlf906 的條件
# Modify.........: No.FUN-570249 05/08/04 By Carrier 多單位內容修改
# Modify.........: No.MOD-570302 05/08/16 By kim 還料料號(imq05)設為Noentry,並移除開窗程式
# Modify.........: No.FUN-580014 05/08/18 By day  報表轉xml
# Modify.........: No.MOD-580069 05/08/15 By pengu 1.在還料入庫時並未考慮借料單位的換算
                                          #        2.若不允許負庫存時，當還料倉不存在時,不可以做s_add_img
# Modify.........: No.MOD-590125 05/09/09 By Carol 重計還料單位與倉庫的單位轉換率
# Modify.........: No.MOD-590118 05/09/09 By Carrier 修改set_origin_field
# Modify.........: No.FUN-590120 05/09/26 By Claire 控管嚴謹
# Modify.........: No.TQC-5B0019 05/11/07 By Sarah 將印報表名稱那一行移到印製表日期的前面一行
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.FUN-5C0077 05/12/23 By jackie  單身增加檢驗否imq15欄位，扣帳時做檢查
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-610067 06/02/08 By Smapmin 雙單位畫面調整
# Modify.........: No.TQC-630052 06/03/07 By Claire 流程訊息通知傳參數
# Modify.........: NO.TQC-620156 06/03/14 By kim GP3.0過帳錯誤統整顯示功能新增
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: No.FUN-660080 06/06/14 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: NO.FUN-660156 06/06/22 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-660085 06/07/03 By Joe 若單身倉庫欄位已有值，則倉庫開窗查詢時，重新查詢時不會顯示該料號所有的倉儲。
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670093 06/07/26 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680010 06/08/26 by Joe SPC整合專案-自動新增 QC 單據
# Modify.........: No.FUN-690026 06/09/13 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690022 06/09/22 By jamie 判斷imaacti
# Modify.........: No.FUN-680046 06/10/11 By jamie 1.FUNCTION t309()_q 一開始應清空g_imr.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/10 By bnlent  單頭折疊功能修改
# Modify.........: No.CHI-690066 06/12/13 By rainy CALL s_daywk() 要判斷未設定或非工作日
# Modify.........: No.CHI-6A0015 06/12/19 By rainy 輸入料號後自動帶出預設倉庫儲位
# Modify.........: No.FUN-6C0083 07/01/08 By Nicola 錯誤訊息彙整
# Modify.........: No.FUN-6B0038 07/02/05 By rainy 庫存扣帳時先跳到扣帳日期輸入
# Modify.........: No.FUN-710058 07/02/05 By jamie 放寬項次位數
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740117 07/03/17 By rainy 手動輸入單身存檔時出現錯誤
# Modify.........: No.CHI-740017 07/04/19 By kim 單身 檢驗碼應 defualt 'N' ,現在是給 NULL
# Modify.........: No.TQC-750018 07/05/04 By rainy 更改狀態無更改料號時，不重帶倉庫儲位
# Modify.........: No.TQC-750022 07/05/09 By sherry 單身還料倉開窗只能開默認窗口
# Modify.........: No.TQC-750130 07/05/23 By rainy 已確認, 但過帳出現 aim-316訊息
# Modify.........: No.MOD-750058 07/05/31 By pengu 開窗選擇批號後應在判斷儲位與批號是否為NULL
# Modify.........: No.MOD-760061 07/06/15 By pengu 若在過帳時將扣帳日期改掉則會無法扣帳還原
# Modify.........: No.CHI-770019 07/07/25 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: No.TQC-7A0096 07/10/24 By Judy 多單位時，對單身單位的控管
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: NO.FUN-840020 08/04/09 By zhaijie 報表輸出改為CR
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.MOD-860030 08/06/03 By claire (1)還料倉儲批應來源於借料單的倉儲批
#                                                   (2)批號不可default給空值
# Modify.........: No.CHI-860005 08/06/27 By xiaofeizhu 使用參考單位且參考數量為0時，也需寫入tlff_file
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID
# Modify.........: No.CHI-910013 09/01/07 By claire (1) 扣帳日default g_today
#                                                   (2) 新增時可輸入扣帳日                  
# Modify.........: No.CHI-930007 09/03/03 By jan 扣帳時,點退出按鈕后,仍能繼續執行
# Modify.........: No.FUN-930109 09/03/19 By xiaofeizhu 過賬時增加s_incchk檢查使用者是否有相應倉,儲的過賬權限
# Modify.........: No.TQC-930155 09/03/27 By Sunyanchun OPEN cursor失敗時，記錄g_success ='N'
# Modify.........: No.TQC-940075 09/04/15 By chenyu 在輸入單身查詢條件的時候，imq22對應成imq23了
# Modify.........: No.FUN-980004 09/08/25 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990087 09/10/12 By lilingyu 單身"還料數量"欄位未控管負數
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.CHI-960052 09/10/15 By chenmoyan 使用多單位，料件是單一單位或參考單位時，單位一的轉換率錯誤
# Modify.........: No.FUN-9C0072 10/01/15 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  過帳還原時的呆滯日期異動
# Modify.........: No:FUN-A80106 10/08/19 by Summer 增加ICD維護刻號/BIN
# Modify.........: No:CHI-A90020 10/10/08 by Summer 刪除前先詢問訊息9042"未輸入單身資料, 是否取消單頭資料 (Y/N) ?"
# Modify.........: No:FUN-AA0007 10/10/14 By jan 若輸入的批號之ids17='Y',则控卡不能输入
# Modify.........: No:MOD-AA0106 10/10/19 by sabrina 查詢單一單號在列印時只能印一次，之後要再印就會顯示"無報表產生"錯誤訊息 
# Modify.........: No.FUN-AA0059 10/10/29 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AB0067 10/11/16 by destiny  增加倉庫的權限控管
# Modify.........: No:MOD-AB0217 10/11/23 by sabrina 過帳還原時沒有卡關帳日期sma53
# Modify.........: No.TQC-AC0353 10/12/24 By zhangll 增加单头借料单号控管
# Modify.........: No.TQC-B10063 11/01/11 By lilingyu 狀態page,部分欄位不可下查詢條件
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B30187 11/06/24 By jason ICD功能修改，增加母批、DATECODE欄位 
# Modify.........: No:FUN-B70061 11/07/20 By jason 維護刻號/BIN回寫母批DATECODE
# Modify.........: No.FUN-B80070 11/08/08 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No:MOD-B60151 11/08/10 by Summer 在after row時若有l_ac會造成單身資料異常
# Modify.........: No.FUN-B80119 11/09/14 By fengrui  增加調用s_icdpost的p_plant參數
# Modify.........: No.FUN-BA0051 11/11/09 By jason 一批號多DATECODE功能
# Modify.........: No:FUN-BB0083 11/12/07 By xujing 增加數量欄位小數取位
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.FUN-BC0109 12/02/09 By jason for ICD Datecode回寫多筆時即以","做分隔
# Modify.........: No.FUN-C20048 12/02/10 By fengrui 數量欄位小數取位處理
# Modify.........: No.FUN-C30062 12/03/13 By bart 報表加入確認欄位
# Modify.........: No.FUN-C30300 12/04/09 By bart  倉儲批開窗需顯示參考單位數量
# Modify.........: No:FUN-C30302 12/04/13 By bart 修改 s_icdout 回傳值
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:TQC-C60028 12/06/04 By bart 只要是ICD行業 倉儲批開窗改用q_idc
# Modify.........: No:FUN-C50071 12/06/06 By Sakura 增加批序號功能(單身批序號修改/批序號查詢)
# Modify.........: No.CHI-C30107 12/06/08 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C70087 12/07/31 By bart 整批寫入img_file
# Modify.........: No:FUN-C80107 12/09/18 By suncx 新增可按倉庫進行負庫存判斷 
# Modify.........: No:CHI-C70017 12/10/29 By bart 關帳日管控
# Modify.........: No.TQC-CB0014 12/11/06 By xuxz 單身項次不可以為0，借料單號欄位開窗條件修改，自動產生單身后單頭單據類型說明欄位值帶出
# Modify.........: No.CHI-C80041 12/12/05 By bart 取消單頭資料控制
# Modify.........: No.FUN-CB0087 12/12/12 By qiull 庫存單據理由碼改善
# Modify.........: No:FUN-CC0095 13/01/16 By bart 修改整批寫入img_file
# Modify.........: No:FUN-D10081 13/01/17 By qiull 增加資料清單
# Modify.........: No:TQC-D10084 13/01/28 By qiull 資料清單頁簽不可點擊單身按鈕
# Modify.........: No:CHI-D20010 13/02/20 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.FUN-D20060 13/02/22 By chenying 設限倉庫控卡
# Modify.........: No.TQC-D20042 13/02/25 By qiull 修改理由碼改善測試問題
# Modify.........: No:FUN-BC0062 13/02/28 By fengrui 當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
# Modify.........: No:FUN-D30024 13/03/12 By qiull 負庫存依據imd23判斷
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
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
#模組變數(Module Variables)
DEFINE
    g_imr           RECORD LIKE imr_file.*,       #簽核等級 (假單頭)
    g_imr_t         RECORD LIKE imr_file.*,       #簽核等級 (舊值)
    g_imr_o         RECORD LIKE imr_file.*,       #簽核等級 (舊值)
    b_imq           RECORD LIKE imq_file.*,
    b_imqi          RECORD LIKE imqi_file.*,      #FUN-B30187
    g_imr01_t       LIKE imr_file.imr01,          #簽核等級 (舊值)
    g_imq           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)  #No.MOD-480396
        imq02       LIKE imq_file.imq02,   #項次
        imq03       LIKE imq_file.imq03,   #
        imq04       LIKE imq_file.imq04,   #
        imp03       LIKE imp_file.imp03,   #
        ima02s      LIKE ima_file.ima02,   #
        imp05       LIKE imp_file.imp05,   #
        imp23       LIKE imp_file.imp23,   #
        imp25       LIKE imp_file.imp25,   #
        imp20       LIKE imp_file.imp20,   #
        imp22       LIKE imp_file.imp22,   #
        imq05       LIKE imq_file.imq05,   #
        ima02e      LIKE ima_file.ima02,   #
        imq08       LIKE imq_file.imq08,   #
        imq09       LIKE imq_file.imq09,   #
        imq10       LIKE imq_file.imq10,
        imq06       LIKE imq_file.imq06,   #
        imp04       LIKE imp_file.imp04,   #
        imq07       LIKE imq_file.imq07,   #
        imq23       LIKE imq_file.imq23,   #
        imq24       LIKE imq_file.imq24,   #
        imq25       LIKE imq_file.imq25,   #
        imq20       LIKE imq_file.imq20,   #
        imq21       LIKE imq_file.imq21,   #
        imq22       LIKE imq_file.imq22,   #
        imq26       LIKE imq_file.imq26,   #FUN-CB0087
        azf03       LIKE azf_file.azf03,   #FUN-CB0087
        imq07f      LIKE imq_file.imq07,   #
        imq06_fac   LIKE imq_file.imq06_fac,
        imq15       LIKE imq_file.imq15,   #No.FUN-5C0077
        imq930      LIKE imq_file.imq930,  #FUN-670093
        gem02c      LIKE gem_file.gem02    #FUN-670093
       ,imqiicd028  LIKE imqi_file.imqiicd028   #FUN-B30187
       ,imqiicd029  LIKE imqi_file.imqiicd029   #FUN-B30187
                    END RECORD,
     g_imq_t         RECORD                 #程式變數 (舊值)  #No.MOD-480396
        imq02       LIKE imq_file.imq02,   #項次
        imq03       LIKE imq_file.imq03,   #
        imq04       LIKE imq_file.imq04,   #
        imp03       LIKE imp_file.imp03,   #
        ima02s      LIKE ima_file.ima02,   #
        imp05       LIKE imp_file.imp05,   #
        imp23       LIKE imp_file.imp23,   #
        imp25       LIKE imp_file.imp25,   #
        imp20       LIKE imp_file.imp20,   #
        imp22       LIKE imp_file.imp22,   #
        imq05       LIKE imq_file.imq05,   #
        ima02e      LIKE ima_file.ima02,   #
        imq08       LIKE imq_file.imq08,   #
        imq09       LIKE imq_file.imq09,   #
        imq10       LIKE imq_file.imq10,
        imq06       LIKE imq_file.imq06,   #
        imp04       LIKE imp_file.imp04,   #
        imq07       LIKE imq_file.imq07,   #
        imq23       LIKE imq_file.imq23,   #
        imq24       LIKE imq_file.imq24,   #
        imq25       LIKE imq_file.imq25,   #
        imq20       LIKE imq_file.imq20,   #
        imq21       LIKE imq_file.imq21,   #
        imq22       LIKE imq_file.imq22,   #
        imq26       LIKE imq_file.imq26,   #FUN-CB0087
        azf03       LIKE azf_file.azf03,   #FUN-CB0087
        imq07f      LIKE imq_file.imq07,   #
        imq06_fac   LIKE imq_file.imq06_fac,
        imq15       LIKE imq_file.imq15,   #No.FUN-5C0077
        imq930      LIKE imq_file.imq930,  #FUN-670093
        gem02c      LIKE gem_file.gem02    #FUN-670093
       ,imqiicd028  LIKE imqi_file.imqiicd028   #FUN-B30187
       ,imqiicd029  LIKE imqi_file.imqiicd029   #FUN-B30187
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING, #TQC-630166
    g_cmd             LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(100)
    g_rec_b           LIKE type_file.num5,    #單身筆數  #No.FUN-690026 SMALLINT
    g_void            LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    l_ac              LIKE type_file.num5,    #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
    g_t1              LIKE smy_file.smyslip, #單別  #No.FUN-550029 #No.FUN-690026 VARCHAR(05)
    g_unit            LIKE ima_file.ima25,   #庫存單位             #No.FUN-690026 VARCHAR(04)
    g_flag            LIKE type_file.chr1,   #判斷是否為新增的自動編號  #No.FUN-690026 VARCHAR(1)
    g_ima25      LIKE ima_file.ima25,        #主檔庫存單位
    g_ima25_fac  LIKE img_file.img20,        #收料單位對主檔庫存單位轉換率
    g_ima39      LIKE ima_file.ima39,        #料件所屬會計科目
    g_img10      LIKE img_file.img10,        #庫存數量
    g_img09      LIKE img_file.img09,        #庫存img之單位
    g_img26      LIKE img_file.img26,        #倉庫所屬會計科目
    g_img23      LIKE img_file.img23,        #是否為可用倉儲
    g_img24      LIKE img_file.img24,        #是否為MRP可用倉儲
    g_img21      LIKE img_file.img21,        #庫存單位對料件庫存單位轉換率
    g_img19      LIKE ima_file.ima271,       #最高限量
    g_ima271     LIKE ima_file.ima271,       #最高儲存量
    g_imf05      LIKE imf_file.imf05,        #預設料件庫存量
    h_qty        LIKE ima_file.ima271,
    g_str        LIKE type_file.chr1,    #TQC-7A0096
    g_desc       LIKE ze_file.ze03,          #說明 #No.FUN-690026 VARCHAR(26)
    l_year,l_prd LIKE type_file.num5,        #No.FUN-690026 SMALLINT
    sn1,sn2      LIKE type_file.num5,        #No.FUN-690026 SMALLINT
#   g_ima262     LIKE ima_file.ima262,       #料件庫存可使用量(ima262)
    g_avl_stk    LIKE type_file.num15_3,     ###GP5.2  #NO.FUN-A20044
    g_img RECORD
                 img19 LIKE img_file.img19,  #Class
                 img36 LIKE img_file.img36
          END RECORD,
    m_imr RECORD
                 img09_fac LIKE ima_file.ima63_fac,
                 img09     LIKE img_file.img09,
                 ima63     LIKE ima_file.ima63,
                 img10     LIKE img_file.img10,
                 img35_2   LIKE img_file.img35,
                 img27     LIKE img_file.img27,
                 img28     LIKE img_file.img28,
                 ima25_fac LIKE ima_file.ima63_fac,
                 ima25     LIKE ima_file.ima25
          END RECORD,
    t_img02      LIKE img_file.img02,        #倉庫
    t_img03      LIKE img_file.img03         #儲位
DEFINE p_row,p_col         LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE
    g_yes               LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    g_imgg10_2          LIKE img_file.img10,
    g_imgg10_1          LIKE img_file.img10,
    g_change            LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    g_change1           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    g_ima906            LIKE ima_file.ima906,
    g_ima907            LIKE ima_file.ima907,
    g_imgg00            LIKE imgg_file.imgg00,
    g_imgg10            LIKE imgg_file.imgg10,
    g_sw                LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_factor            LIKE inb_file.inb08_fac,
    g_tot               LIKE img_file.img10,
    g_qty               LIKE img_file.img10
    DEFINE  g_dies          LIKE ida_file.ida17 #FUN-A80106 add
#FUN-C50071 add begin--------------------------
DEFINE g_rvbs   DYNAMIC ARRAY OF RECORD        #批序號明細單身變量
                  rvbs02  LIKE rvbs_file.rvbs02,
                  rvbs021 LIKE rvbs_file.rvbs021,
                  ima02a  LIKE ima_file.ima02,
                  ima021a LIKE ima_file.ima021,
                  rvbs022 LIKE rvbs_file.rvbs022,
                  rvbs04  LIKE rvbs_file.rvbs04,
                  rvbs03  LIKE rvbs_file.rvbs03,
                  rvbs05  LIKE rvbs_file.rvbs05,
                  rvbs06  LIKE rvbs_file.rvbs06,
                  rvbs07  LIKE rvbs_file.rvbs07,
                  rvbs08  LIKE rvbs_file.rvbs08
                END RECORD
DEFINE g_rec_b1    LIKE type_file.num5,   #單身二筆數
       l_ac1       LIKE type_file.num5    #目前處理的ARRAY CNT
DEFINE g_ima918    LIKE ima_file.ima918
DEFINE g_ima921    LIKE ima_file.ima921
DEFINE l_r         LIKE type_file.chr1
DEFINE l_i         LIKE type_file.num5
DEFINE l_fac       LIKE img_file.img34
#FUN-C50071 add -end---------------------------
 
 
#主程式開始
DEFINE g_forupd_sql    STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_chr           LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i             LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index    LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_argv1         LIKE imr_file.imr01    # 單號  #TQC-630052 #No.FUN-690026 VARCHAR(16)
DEFINE g_argv2         STRING                   # 指定執行的功能   #TQC-630052
DEFINE l_table        STRING
DEFINE g_str1         STRING
DEFINE g_imq06_t       LIKE imq_file.imq07    #FUN-BB0083 add
DEFINE g_imq20_t       LIKE imq_file.imq22    #FUN-BB0083 add
DEFINE g_imq23_t       LIKE imq_file.imq25    #FUN-BB0083 add
#DEFINE l_img_table      STRING             #FUN-C70087  #FUN-CC0095
#DEFINE l_imgg_table     STRING             #FUN-C70087  #FUN-CC0095
DEFINE            l_flag01    LIKE type_file.chr1   #FUN-C80107 add
#FUN-D10081---add---str---
DEFINE g_imr_l DYNAMIC ARRAY OF RECORD
               imr01   LIKE imr_file.imr01,
               smydesc LIKE smy_file.smydesc,
               imr02   LIKE imr_file.imr02,
               imr03   LIKE imr_file.imr03,
               gen02   LIKE gen_file.gen02,
               imr04   LIKE imr_file.imr04,
               gem02   LIKE gem_file.gem02,
               imr05   LIKE imr_file.imr05,
               imr06   LIKE imr_file.imr06,
               imr09   LIKE imr_file.imr09,
               imrconf LIKE imr_file.imrconf,
               imrpost LIKE imr_file.imrpost
               END RECORD,
        l_ac4      LIKE type_file.num5,
        g_rec_b4   LIKE type_file.num5,
        g_action_flag  STRING
DEFINE   w     ui.Window
DEFINE   f     ui.Form
DEFINE   page  om.DomNode
#FUN-D10081---add---end---

MAIN
 
    LET g_str ='y'          #CHI-910013
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
#FUN-A80106 add --start--
    LET g_cmd ='aimt309_icd'
    LET g_prog='aimt309_icd'
#FUN-A80106 add --end--
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("AIM")) THEN
       EXIT PROGRAM
    END IF
    #CALL s_padd_img_create() RETURNING l_img_table   #FUN-C70087  #FUN-CC0095
    #CALL s_padd_imgg_create() RETURNING l_imgg_table #FUN-C70087  #FUN-CC0095
 
    LET g_argv1=ARG_VAL(1)           #TQC-630052
    LET g_argv2=ARG_VAL(2)           #TQC-630052
 
    CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
 
    LET p_row = 3 LET p_col = 2
    LET g_sql = "imr01.imr_file.imr01,",
                "imr02.imr_file.imr02,",
                "imr03.imr_file.imr03,",
                "imr04.imr_file.imr04,",
                "imr05.imr_file.imr05,",
                "imr06.imr_file.imr06,",
                "imrconf.imr_file.imrconf,",   #FUN-C30062
                "gen02.gen_file.gen02,",
                "gem02.gem_file.gem02,",
                "imrpost.imr_file.imrpost,",
                "imq02.imq_file.imq02,",
                "imq03.imq_file.imq03,",
                "imq04.imq_file.imq04,",
                "imq05.imq_file.imq05,",
                "imq06.imq_file.imq06,",
                "imq06_fac.imq_file.imq06_fac,",
                "imq07.imq_file.imq07,",
                "imq08.imq_file.imq08,",
                "imq09.imq_file.imq09,",
                "imq10.imq_file.imq10,",
                "imp03.imp_file.imp03,",
                "imp04.imp_file.imp04,",
                "imp05.imp_file.imp05,",
                "ima02s.ima_file.ima02,",
                "ima02e.ima_file.ima02"
   LET l_table = cl_prt_temptable('aimt309',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?)"    #FUN-C30062 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",status,1) EXIT PROGRAM
   END IF                
    OPEN WINDOW t309_w AT p_row,p_col      #顯示畫面
        WITH FORM "aim/42f/aimt309"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL cl_set_comp_required("imq26",g_aza.aza115='Y')      #FUN-CB0087
    CALL t309_mu_ui()
 
    # 先以g_argv2判斷直接執行哪種功能，執行Q時，g_argv1是單號(imr05)
    # 執行I時，g_argv1是單號(imr05)
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t309_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL t309_a()
             END IF
          OTHERWISE
             CALL t309_q()
       END CASE
    END IF
 
    CALL t309()
    CLOSE WINDOW t309_w                    #結束畫面
    #CALL s_padd_img_drop(l_img_table)   #FUN-C70087  #FUN-CC0095
    #CALL s_padd_imgg_drop(l_imgg_table) #FUN-C70087  #FUN-CC0095
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
FUNCTION t309()
 
    #--LOCK CURSOR
    LET g_forupd_sql =
      "SELECT * FROM imr_file WHERE imr01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t309_cl CURSOR FROM g_forupd_sql
 
    CALL t309_menu()
END FUNCTION
 
#QBE 查詢資料
FUNCTION t309_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                                    #清除畫面
   CALL g_imq.clear()
 
    INITIALIZE g_imr.* TO NULL
 
   IF cl_null(g_argv1) THEN  #TQC-630052
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        imr01,imr02,imr05,imr09,imr03,imr04,imr06,imrconf,imrspc, #FUN-660080 #FUN-680010
        imrpost,imruser,imrgrup,
        imroriu,imrorig,           #TQC-B10063
        imrmodu,imrdate
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(imr01) #查詢單据
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_imr"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imr01
                    NEXT FIELD imr01
               WHEN INFIELD(imr03) #借料人員
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imr03
                    NEXT FIELD imr03
               WHEN INFIELD(imr04) #部門
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imr04
                    NEXT FIELD imr04
               WHEN INFIELD(imr05) #借料單號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_imo"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imr05
                    NEXT FIELD imr05
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imruser', 'imrgrup')
 
    CONSTRUCT g_wc2 ON imq02,imq03,imq04,imq05,imq08,imq09,imq10,
                       imq06,imq07,imq23,imq25,imq20,imq22,imq26,imq15,  #FUN-5C0077 增加imq15   #FUN-CB0087 add>imq26
                       imq930   #FUN-670093
                       ,imqiicd028,imqiicd029   #FUN-B30187
                                            # 螢幕上取單身條件
         FROM s_imq[1].imq02,s_imq[1].imq03,s_imq[1].imq04,
              s_imq[1].imq05,s_imq[1].imq08,s_imq[1].imq09,
              s_imq[1].imq10,s_imq[1].imq06,s_imq[1].imq07,
              s_imq[1].imq23,s_imq[1].imq25,s_imq[1].imq20,
              s_imq[1].imq22,s_imq[1].imq26,s_imq[1].imq15,   #No.FUN-5C0077   #No.TQC-940075 imq23-->imq22  #FUN-CB0087 add>imq26
              s_imq[1].imq930   #FUN-670093
              ,s_imq[1].imqiicd028,s_imq[1].imqiicd029   #FUN-B30187
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(imq03) #借料單號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_imp2"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imq03
                    NEXT FIELD imq03
               WHEN INFIELD(imq06) #還料單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imq06
                   NEXT FIELD imq06
                WHEN INFIELD(imq08)
                   #No.FUN-AB0067--begin   
                   #CALL cl_init_qry_var()
                   #LET g_qryparam.form     = "q_imd"
                   #LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                   #LET g_qryparam.state    = "c"
                   #CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_imd_1(TRUE,TRUE,"",'SW',"","","") RETURNING g_qryparam.multiret 
                   #No.FUN-AB0067--end
                   DISPLAY g_qryparam.multiret TO imq08
              WHEN INFIELD(imq23)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imq23
                 NEXT FIELD imq23
              WHEN INFIELD(imq20)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imq20
                 NEXT FIELD imq20
               WHEN INFIELD(imq930)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gem4"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imq930
                  NEXT FIELD imq930
               #FUN-B30187 --START--
               WHEN INFIELD(imqiicd029 )
                  CALL q_slot(TRUE,TRUE,g_imq[1].imqiicd029,'','')                         
                   RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imqiicd029
                  NEXT FIELD imqiicd029
               #FUN-B30187 --END--
               #FUN-CB0087---add---str---         
               WHEN INFIELD(imq26)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form     ="q_azf41"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret 
                  DISPLAY g_qryparam.multiret TO imq26
                  NEXT FIELD imq26
               #FUN-CB0087---add---end---
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
 
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
   ELSE
      LET g_wc =" imr01 = '",g_argv1,"'"  
      LET g_wc2 =" 1=1"  
   END IF
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  imr01 FROM imr_file ",
                   " WHERE ", g_wc CLIPPED,
                   "   AND imr00 = '1' ",#原數償還
                   " ORDER BY imr01"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE imr_file. imr01 ",
                   "  FROM imr_file, imq_file ",
                   " WHERE imr01 = imq01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   "   AND imr00 = '1' ",#原數償還
                   " ORDER BY imr01"
       #FUN-B30187 --START--
       IF g_wc2.getindexof('imqi',1)>0 THEN
          LET g_sql = "SELECT UNIQUE imr_file. imr01 ",
                      " FROM imr_file, imq_file, imqi_file ",
                      " WHERE imr01 = imq01",
                      "  AND imq01 = imqi01",
                      "  AND imq02 = imqi02",
                      "  AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                      "  AND imr00 = '1' ",#原數償還
                      " ORDER BY imr01"
       END IF 
       #FUN-B30187 --END--
    END IF
 
    PREPARE t309_prepare FROM g_sql
    DECLARE t309_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t309_prepare
    DECLARE t309_fill_cs CURSOR WITH HOLD FOR t309_prepare   #FUN-D10081 add
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM imr_file WHERE ",g_wc CLIPPED,
                  "   AND imr00 = '1' " #原數償還
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT imr01) ",
                  "  FROM imr_file,imq_file ",
                  " WHERE imq01=imr01 ",
                  "   AND ",g_wc CLIPPED,
                  "   AND ",g_wc2 CLIPPED,
                  "   AND imr00 = '1' "#原數償還
       #FUN-B30187 --START--
       IF g_wc2.getindexof('imqi',1)>0 THEN
          LET g_sql = "SELECT COUNT(DISTINCT imr01) ",
                      " FROM imr_file, imq_file, imqi_file ",
                      " WHERE imr01 = imq01",
                      "  AND imq01 = imqi01",
                      "  AND imq02 = imqi02",
                      "  AND ", g_wc CLIPPED,
                      "  AND ",g_wc2 CLIPPED,
                      "  AND imr00 = '1' "#原數償還
       END IF 
       #FUN-B30187 --END--
    END IF
    PREPARE t309_precount FROM g_sql
    DECLARE t309_count CURSOR FOR t309_precount
END FUNCTION
 
FUNCTION t309_menu()
#FUN-A80106 add --start--
DEFINE l_imq             RECORD LIKE imq_file.*
DEFINE l_imaicd01        LIKE imaicd_file.imaicd01
DEFINE l_r               LIKE type_file.chr1  #FUN-C30302
DEFINE l_qty             LIKE type_file.num15_3  #FUN-C30302
#FUN-A80106 add --end--
 
   WHILE TRUE
      IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN      #FUN-D10081 add
         CALL t309_bp("G")
      #FUN-D10081---add---str---
      ELSE 
         CALL t309_list_fill()
         CALL t309_bp2("G")
         IF NOT cl_null(g_action_choice) AND l_ac4>0 THEN #將清單的資料回傳到主畫面
            SELECT imr_file.* INTO g_imr.*
              FROM imr_file
             WHERE imr01 = g_imr_l[l_ac4].imr01
         END IF 
         IF g_action_choice!= "" THEN
            LET g_action_flag = "page_main"
            LET l_ac4 = ARR_CURR()
            LET g_jump = l_ac4
            LET mi_no_ask = TRUE
            IF g_rec_b4 >0 THEN
               CALL t309_fetch('/')
            END IF
            CALL cl_set_comp_visible("page_list", FALSE)
            CALL cl_set_comp_visible("page_main", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page_list", TRUE)
            CALL cl_set_comp_visible("page_main", TRUE)
         END IF
      END IF
      #FUN-D10081---add---end---
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t309_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t309_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t309_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t309_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t309_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t309_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "確認"
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t309_y_chk()
               IF g_success = "Y" THEN
                  CALL t309_y_upd()
               END IF
            END IF
       #@WHEN "取消確認"
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t309_z()
            END IF
       #@WHEN "作廢"
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t309_x()  #CHI-D20010
               CALL t309_x(1)  #CHI-D20010
               IF g_imr.imrconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_imr.imrconf,"",g_imr.imrpost,"",g_void,"")
            END IF

       #CHI-D20010---begin
          WHEN "undo_void"
             IF cl_chk_act_auth() THEN
                CALL t309_x(2)
                IF g_imr.imrconf = 'X' THEN
                   LET g_void = 'Y'
                ELSE
                   LET g_void = 'N'
                END IF
               CALL cl_set_field_pic(g_imr.imrconf,"",g_imr.imrpost,"",g_void,"")
             END IF
       #CHI-D20010---end 

#FUN-A80106 add --start--
       #@WHEN "單據刻號BIN查詢作業"
         WHEN "aic_s_icdqry"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_imr.imr01) THEN
                  CALL s_icdqry(-1,g_imr.imr01,'',g_imr.imrpost,'')
               END IF
            END IF
 
      #@WHEN 刻號/BIN號出庫明細
         WHEN "aic_s_icdout"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_imr.imr01) AND
                  g_imr.imrpost = 'N' AND
                  NOT cl_null(l_ac) AND l_ac <> 0 THEN
                  #避免畫面資料是舊的，所以重撈
                  INITIALIZE l_imq.* TO NULL
                  SELECT * INTO l_imq.* FROM imq_file
                   WHERE imq01 = g_imr.imr01 AND imq02 = g_imq[l_ac].imq02
                  #出庫
                  LET g_dies = 0
                  CALL s_icdout(l_imq.imq05,l_imq.imq08,
                                l_imq.imq09,l_imq.imq10,
                                l_imq.imq06,l_imq.imq07,
                                g_imr.imr01,l_imq.imq02,
                                g_imr.imr02,
                                'N','','','','')
                       RETURNING g_dies,l_r,l_qty   #FUN-C30302
                  #FUN-C30302---begin
                  IF l_r = 'Y' THEN
                      LET l_qty = s_digqty(l_qty,l_imq.imq06) 
                      LET g_imq[l_ac].imq07 = l_qty
                      LET g_imq[l_ac].imq22 = l_qty
                      LET g_imq[l_ac].imq07f = g_imq[l_ac].imq07 / g_imq[l_ac].imq06_fac
                      
                      UPDATE imq_file set imq07 = g_imq[l_ac].imq07,imq22 = g_imq[l_ac].imq22
                       WHERE imq01=g_imr.imr01 AND imq02=g_imq[l_ac].imq02
                      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                         LET g_imq[l_ac].imq07 = b_imq.imq07
		                 LET g_imq[l_ac].imq22 = b_imq.imq22
                         LET g_success = 'N'
                      ELSE
                         LET b_imq.imq07 = g_imq[l_ac].imq07
		                 LET b_imq.imq22 = g_imq[l_ac].imq22                
                      END IF
                      DISPLAY BY NAME g_imq[l_ac].imq07, g_imq[l_ac].imq22,g_imq[l_ac].imq07f
                  END IF 
                  #FUN-C30302---end
                  CALL t309_ind_icd_upd_dies()
               END IF
            END IF
#FUN-A80106 add --end--
         
       #@WHEN "過帳"
         WHEN "post"
            IF cl_chk_act_auth() THEN
               CALL t309_s()
               IF g_imr.imrconf = 'X' THEN #FUN-660080
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_imr.imrconf,"",g_imr.imrpost,"",g_void,"") #FUN-660080
            END IF
       #@WHEN "過帳還原"
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               CALL t309_w()
               IF g_imr.imrconf = 'X' THEN #FUN-660080
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_imr.imrconf,"",g_imr.imrpost,"",g_void,"") #FUN-660080
            END IF
         WHEN "exporttoexcel" #FUN-4B0002
            LET w = ui.Window.getCurrent()   #FUN-D10081 add
            LET f = w.getForm()              #FUN-D10081 add
            IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN   #FUN-D10081 add
               IF cl_chk_act_auth() THEN
                  LET page = f.FindNode("Page","page_main")                 #FUN-D10081 add
                  #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_imq),'','')   #FUN-D10081 mark
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_imq),'','')   #FUN-D10081 add
               END IF
            #FUN-D10081---add---str---
            END IF 
            IF g_action_flag = "page_list" THEN
               LET page = f.FindNode("Page","page_list")
               IF cl_chk_act_auth() THEN
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_imr_l),'','')
               END IF
            END IF
            #FUN-D10081---add---end---     
 
         WHEN "trans_spc"         
            IF cl_chk_act_auth() THEN
               CALL t309_spc()
            END IF
 
        WHEN "related_document"  #相關文件
           IF cl_chk_act_auth() THEN
              IF g_imr.imr01 IS NOT NULL THEN
                LET g_doc.column1 = "imr01"
                LET g_doc.value1 = g_imr.imr01
                CALL cl_doc()
              END IF
          END IF
#FUN-C50071 add begin-------------------------
         WHEN "qry_lot"  #批序號查詢
            IF l_ac > 0 THEN
               SELECT ima918,ima921 INTO g_ima918,g_ima921
                 FROM ima_file
                WHERE ima01 = g_imq[l_ac].imq05
                  AND imaacti = "Y"

               IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  LET g_success = 'Y'
                  BEGIN WORK
                  LET g_img09 = ''   LET g_img10 = 0

                  SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
                   WHERE img01 = g_imq[l_ac].imq05 AND img02 = g_imq[l_ac].imq08
                     AND img03 = g_imq[l_ac].imq09 AND img04 = g_imq[l_ac].imq10

                  CALL s_umfchk(g_imq[l_ac].imq05,g_imq[l_ac].imq06,g_img09)
                     RETURNING l_i,l_fac
                  IF l_i = 1 THEN LET l_fac = 1 END IF

                  CALL s_mod_lot(g_prog,g_imr.imr01,g_imq[l_ac].imq02,0,
                                g_imq[l_ac].imq05,g_imq[l_ac].imq08,
                                g_imq[l_ac].imq09,g_imq[l_ac].imq10,
                                g_imq[l_ac].imq06,g_img09,
                                g_imq[l_ac].imq06_fac,g_imq[l_ac].imq07,'','QRY',-1)
                     RETURNING l_r,g_qty
                  IF g_success = "Y" THEN
                     COMMIT WORK
                  ELSE
                     ROLLBACK WORK
                  END IF
               END IF
            END IF
#FUN-C50071 add -end--------------------------
      END CASE
   END WHILE
END FUNCTION
 
 
#Add  輸入
FUNCTION t309_a()
    DEFINE li_result  LIKE type_file.num5            #No.FUN-550029  #No.FUN-690026 SMALLINT
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_imq.clear()
    INITIALIZE g_imr.* LIKE imr_file.*             #DEFAULT 設定
    LET g_imr01_t = NULL
    #預設值及將數值類變數清成零
    LET g_imr_t.* = g_imr.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_imr.imr00 = '1' #原數償還
        LET g_imr.imr02 = g_today
        LET g_imr.imrpost='N'
        LET g_imr.imrconf='N' #FUN-660080
        LET g_imr.imrspc ='0' #FUN-680010
        LET g_imr.imruser=g_user
        LET g_imr.imroriu = g_user #FUN-980030
        LET g_imr.imrorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_imr.imrgrup=g_grup
        LET g_imr.imrdate=g_today
        LET g_imr.imr02=g_today         #借料日期為系統日期
        LET g_imr.imr09=g_today         #扣帳日期為系統日期 #CHI-910013 add
        LET g_imr.imr03=g_user
        LET g_imr.imrplant = g_plant #FUN-980004 add
        LET g_imr.imrlegal = g_legal #FUN-980004 add
        IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
           LET g_imr.imr05 = g_argv1
        END IF
        LET g_str = 'y'                 #CHI-910013 add
        CALL t309_i("a")                #輸入單頭
        IF INT_FLAG THEN                #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            INITIALIZE g_imr.* TO NULL
            EXIT WHILE
        END IF
        BEGIN WORK #No:7857
        CALL s_auto_assign_no("aim",g_imr.imr01,g_imr.imr02,"C","imr_file","imr01",   #No.FUN-5C0077
                  "","","")
             RETURNING li_result,g_imr.imr01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
 
	#進行輸入之單號檢查
	CALL s_mfgchno(g_imr.imr01) RETURNING g_i,g_imr.imr01
	DISPLAY BY NAME g_imr.imr01
	IF NOT g_i THEN CONTINUE WHILE END IF
 
        INSERT INTO imr_file VALUES (g_imr.*)
        IF SQLCA.sqlcode THEN           # 置入資料庫不成功
        #    ROLLBACK WORK #No:7857         #FUN-B80070---回滾放在報錯後---
            CALL cl_err3("ins","imr_file",g_imr.imr01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
            ROLLBACK WORK          #FUN-B80070--add--
            CONTINUE WHILE
        ELSE
            COMMIT WORK #No:7857
            CALL cl_flow_notify(g_imr.imr01,'I')
        END IF
        LET g_imr01_t = g_imr.imr01        #保留舊值
        LET g_imr_t.* = g_imr.*
        CALL g_imq.clear()
        LET g_rec_b = 0    #No.FUN-5C0077
        CALL t309_b()                   #輸入單身
 
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t309_u()
    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_imr.* FROM imr_file WHERE imr01=g_imr.imr01
    IF g_imr.imr01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_imr.imrconf='Y' THEN CALL cl_err('','aap-005',0) RETURN END IF
    IF g_imr.imrpost='Y' THEN CALL cl_err(g_imr.imr01,'aar-347',0) RETURN END IF
    IF g_imr.imrconf='X' THEN CALL cl_err('','9024',0) RETURN END IF

    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_imr01_t = g_imr.imr01
    LET g_imr_o.* = g_imr.*
    BEGIN WORK
 
    OPEN t309_cl USING g_imr.imr01
    IF STATUS THEN
       CALL cl_err("OPEN t309_cl:", STATUS, 1)
       CLOSE t309_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t309_cl INTO g_imr.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imr.imr01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t309_cl ROLLBACK WORK RETURN
    END IF
    CALL t309_show()
    WHILE TRUE
        LET g_imr01_t = g_imr.imr01
        LET g_imr.imrmodu=g_user
        LET g_imr.imrdate=g_today
        CALL t309_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_imr.*=g_imr_t.*
            CALL t309_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_imr.imr01 != g_imr01_t THEN            # 更改單號
            UPDATE imq_file SET imq01 = g_imr.imr01
                WHERE imq01 = g_imr01_t
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","imq_file",g_imr01_t,"",SQLCA.sqlcode,"",
                            "imq",1)  #No.FUN-660156
               CONTINUE WHILE
            END IF
        END IF
        #FUN-B30187 --START--
        IF g_imr.imr01 != g_imr01_t THEN            # 更改單號
           UPDATE imqi_file SET imqi01 = g_imr.imr01
                   WHERE imqi01 = g_imr01_t
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","imqi_file",g_imr01_t,"",SQLCA.sqlcode,"",
                               "imqi",1)   
                  CONTINUE WHILE 
               END IF
        END IF                
        #FUN-B30187 --END--
        UPDATE imr_file SET imr_file.* = g_imr.* WHERE imr01 = g_imr01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","imr_file",g_imr_t.imr01,"",SQLCA.sqlcode,"",
                         "",1)  #No.FUN-660156
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t309_cl
    COMMIT WORK
    CALL cl_flow_notify(g_imr.imr01,'U')
END FUNCTION
 
#處理INPUT
FUNCTION t309_i(p_cmd)
DEFINE
       p_cmd      LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
       l_flag     LIKE type_file.chr1     #判斷必要欄位是否有輸入  #No.FUN-690026 VARCHAR(1)
DEFINE li_result  LIKE type_file.num5     #No.FUN-550029  #No.FUN-690026 SMALLINT
DEFINE l_cnt      LIKE type_file.num5     #Add No.TQC-AC0353
 
    DISPLAY BY NAME                              # 顯示單頭值
                    g_imr.imr01,g_imr.imr02,g_imr.imr05,g_imr.imr09,
                    g_imr.imr03,g_imr.imr04,g_imr.imr06,g_imr.imrconf,g_imr.imrspc, #FUN-660080 #FUN-680010
                    g_imr.imrpost,g_imr.imruser,
                    g_imr.imrgrup,g_imr.imrmodu,g_imr.imrdate
      CALL cl_set_head_visible("","YES")   #No.FUN-6B0030 
      INPUT BY NAME g_imr.imroriu,g_imr.imrorig,
                    g_imr.imr01,g_imr.imr02,g_imr.imr05,g_imr.imr09,
                    g_imr.imr03,g_imr.imr04,g_imr.imr06,g_imr.imrconf, #FUN-660080
                    g_imr.imrpost,g_imr.imruser,
                    g_imr.imrgrup,g_imr.imrmodu,g_imr.imrdate
                   WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t309_set_entry(p_cmd)
            CALL t309_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_set_docno_format("imr01")
 
 
        AFTER FIELD imr02        #還料日期不可空白
	    IF g_imr.imr02 IS NULL THEN
                LET g_imr.imr02=g_today
            END IF
            DISPLAY g_imr.imr02 to imr02
              LET li_result = 0
              CALL s_daywk(g_imr.imr02) RETURNING li_result
	      IF li_result = 0 THEN #非工作日
                 CALL cl_err(g_imr.imr02,'mfg3152',0)
	         NEXT FIELD imr02
	      END IF
	      IF li_result = 2 THEN #未設定
                 CALL cl_err(g_imr.imr02,'mfg3153',0)
	         NEXT FIELD imr02
	      END IF
	      
            CALL s_yp(g_imr.imr02) RETURNING l_year,l_prd
            #---->與目前會計年度,期間比較,如日期大於目前會計年度,期間則不可過
            IF (l_year*12+l_prd) > (g_sma.sma51*12+g_sma.sma52)
               THEN CALL cl_err('','mfg6091',0) NEXT FIELD imr02
            END IF
	    IF g_sma.sma53 IS NOT NULL AND g_imr.imr02 <= g_sma.sma53 THEN
		CALL cl_err('','mfg9999',0) NEXT FIELD imr02
	    END IF
 
        AFTER FIELD imr01       #還料單號(不可空白)
            CALL s_check_no("aim",g_imr.imr01,g_imr_t.imr01,"C","imr_file","imr01","")
                 RETURNING li_result,g_imr.imr01
                 IF (NOT li_result) THEN
                    NEXT FIELD imr01
                 END IF
            DISPLAY g_smy.smydesc TO FORMONLY.smydesc
                #進行輸入之單號檢查
                CALL s_mfgchno(g_imr.imr01) RETURNING g_i,g_imr.imr01
                DISPLAY BY NAME g_imr.imr01
                IF NOT g_i THEN NEXT FIELD imr01 END IF
        AFTER FIELD imr05
            IF NOT cl_null(g_imr.imr05) THEN
               CALL t309_imr05(g_imr.imr05)
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_imr.imr05,g_errno,0)
                   LET g_imr.imr05 = g_imr_t.imr05
                   DISPLAY BY NAME g_imr.imr05
                   NEXT FIELD imr05
               END IF
               #Add No.TQC-AC0353
               IF p_cmd = 'u' THEN
                  SELECT COUNT(*) INTO l_cnt FROM imq_file
                   WHERE imq01 = g_imr.imr01
                     AND imq03 <> g_imr.imr05
                  IF l_cnt > 0 THEN
                     CALL cl_err(g_imr.imr05,'apm-940',0)
                     LET g_imr.imr05 = g_imr_t.imr05
                     DISPLAY BY NAME g_imr.imr05
                     NEXT FIELD imr05
                  END IF
               END IF
               #End Add No.TQC-AC0353
            END IF
        AFTER FIELD imr03    #還料人員,不可空白
          IF NOT cl_null(g_imr.imr03) THEN
             CALL t309_imr03('a') #檢查員工資料檔
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_imr.imr03 = g_imr_t.imr03
                DISPLAY BY NAME g_imr.imr03
                NEXT FIELD imr03
             END IF
             #FUN-CB0087---add---str---
             IF NOT t309_imq26_chk1() THEN
                NEXT FIELD imr03
             END IF
             #FUN-CB0087---add---end---
          END IF
 
        AFTER FIELD imr04    #部門,不可空白
          IF NOT cl_null(g_imr.imr04) THEN
             CALL t309_imr04('a') #檢查部門
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_imr.imr04 = g_imr_t.imr04
                DISPLAY BY NAME g_imr.imr04
                NEXT FIELD imr04
             END IF
             #FUN-CB0087---add---str---
             IF NOT t309_imq26_chk1() THEN
                NEXT FIELD imr04
             END IF
             #FUN-CB0087---add---end---
          END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_imr.imruser = s_get_data_owner("imr_file") #FUN-C10039
           LET g_imr.imrgrup = s_get_data_group("imr_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF g_imr.imr01 IS NULL THEN  #還料單號
               LET l_flag='Y'
               DISPLAY BY NAME g_imr.imr01
            END IF
            IF g_imr.imr02 IS NULL THEN  #還料日期
               LET l_flag='Y'
               DISPLAY BY NAME g_imr.imr02
            END IF
            IF cl_null(g_imr.imr03) THEN
                LET l_flag = 'Y'
                DISPLAY BY NAME g_imr.imr03
            END IF
            IF cl_null(g_imr.imr04) THEN
                LET l_flag = 'Y'
                DISPLAY BY NAME g_imr.imr04
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD imr01
            END IF
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(imr01) #查詢單据
                    LET g_t1=s_get_doc_no(g_imr.imr01)    #No.FUN-550029
                    CALL q_smy(FALSE,FALSE,g_t1,'AIM','C') RETURNING g_t1  #TQC-670008
                    LET g_imr.imr01=g_t1                  #No.FUN-550029
                    DISPLAY BY NAME g_imr.imr01
                    NEXT FIELD imr01
               WHEN INFIELD(imr03) #借料人員
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.default1 = g_imr.imr03
                    CALL cl_create_qry() RETURNING g_imr.imr03
                    DISPLAY BY NAME g_imr.imr03
                    NEXT FIELD imr03
               WHEN INFIELD(imr04) #部門
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.default1 = g_imr.imr04
                    CALL cl_create_qry() RETURNING g_imr.imr04
                    DISPLAY BY NAME g_imr.imr04
                    NEXT FIELD imr04
               WHEN INFIELD(imr05) #借料單號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_imo"
                    LET g_qryparam.default1 = g_imr.imr05
                    LET g_qryparam.where = " imopost = 'Y'"#TQC-CB0014 add
                    CALL cl_create_qry() RETURNING g_imr.imr05
                    DISPLAY BY NAME g_imr.imr05
                    NEXT FIELD imr05
               OTHERWISE EXIT CASE
            END CASE
        ON ACTION CONTROLF
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
 
FUNCTION i010_imr03(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
   l_gen02    LIKE gen_file.gen02,
   l_gen03    LIKE gen_file.gen03,
   l_gen04    LIKE gen_file.gen04,
   l_genacti  LIKE gen_file.genacti,
   l_gem02    LIKE gem_file.gem02
 
   LET g_errno=''
   SELECT gen02,gen03,gen04,genacti
     INTO l_gen02,l_gen03,l_gen04,l_genacti
     FROM gen_file
    WHERE gen01=g_imr.imr03
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='aoo-070'
                                LET l_gen02=NULL
                                LET l_gen03=NULL
                                LET l_gen04=NULL
       WHEN l_genacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
 
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_gen02 TO FORMONLY.gen02
      DISPLAY l_gen03 TO imr04
      SELECT gem02 INTO l_gem02 FROM gem_file
       WHERE gem01=l_gen03
      IF SQLCA.sqlcode THEN LET l_gem02=' ' END IF
      DISPLAY l_gem02 TO gem02
   END IF
END FUNCTION
 
#Query 查詢
FUNCTION t309_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_imr.* TO NULL             #No.FUN-680046
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
   CALL g_imq.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t309_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t309_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_imr.* TO NULL
    ELSE
        OPEN t309_count
        FETCH t309_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t309_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION t309_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690026 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t309_cs INTO g_imr.imr01
        WHEN 'P' FETCH PREVIOUS t309_cs INTO g_imr.imr01
        WHEN 'F' FETCH FIRST    t309_cs INTO g_imr.imr01
        WHEN 'L' FETCH LAST     t309_cs INTO g_imr.imr01
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
            FETCH ABSOLUTE g_jump t309_cs INTO g_imr.imr01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imr.imr01,SQLCA.sqlcode,0)
        INITIALIZE g_imr.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_imr.* FROM imr_file WHERE imr01 = g_imr.imr01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","imr_file",g_imr.imr01,"",SQLCA.sqlcode,"",
                     "",1)  #No.FUN-660156
        INITIALIZE g_imr.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_imr.imruser #FUN-4C0053
        LET g_data_group = g_imr.imrgrup #FUN-4C0053
        LET g_data_plant = g_imr.imrplant #FUN-980030
    END IF
 
    CALL t309_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t309_show()
  DEFINE l_smydesc   LIKE smy_file.smydesc
 
    LET g_imr_t.* = g_imr.*                #保存單頭舊值
    DISPLAY BY NAME g_imr.imroriu,g_imr.imrorig,                              # 顯示單頭值
        g_imr.imr01,g_imr.imr02,g_imr.imr05,g_imr.imr09,
        g_imr.imr03,g_imr.imr04,g_imr.imr06,g_imr.imrconf,g_imr.imrspc, #FUN-660080 #FUN-680010
        g_imr.imrpost,g_imr.imruser,g_imr.imrgrup,g_imr.imrmodu,
        g_imr.imrdate
 
 
  # LET g_t1=g_imr.imr01                    #No.FUN-550029#TQC-CB0014 mark
    CALL s_get_doc_no(g_imr.imr01) RETURNING g_t1#TQC-CB0014 add
    SELECT smydesc INTO l_smydesc
      FROM smy_file
     WHERE smyslip = g_t1
    DISPLAY l_smydesc TO FORMONLY.smydesc
 
    CALL t309_imr03('d')
    CALL t309_imr04('d')
    IF g_imr.imrconf = 'X' THEN  #FUN-660080
       LET g_void = 'Y'
    ELSE
       LET g_void = 'N'
    END IF
    CALL cl_set_field_pic(g_imr.imrconf,"",g_imr.imrpost,"",g_void,"")
    CALL t309_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t309_r()
#FUN-A80106 add --start--
DEFINE l_flag   LIKE type_file.chr1 
#FUN-A80106 add --end--

    IF s_shut(0) THEN RETURN END IF
    IF g_imr.imr01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    
    IF g_imr.imrconf = 'Y' THEN
        CALL cl_err(g_imr.imr01,'anm-105',0)
        RETURN
    END IF
    IF g_imr.imrpost = 'Y' THEN
        CALL cl_err(g_imr.imr01,'afa-101',0)
        RETURN
    END IF
    IF g_imr.imrconf = 'X' THEN #FUN-660080
        CALL cl_err(g_imr.imr01,'axr-103',0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t309_cl USING g_imr.imr01
    IF STATUS THEN
       CALL cl_err("OPEN t309_cl:", STATUS, 1)
       CLOSE t309_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t309_cl INTO g_imr.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imr.imr01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t309_cl ROLLBACK WORK RETURN
    END IF
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "imr01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_imr.imr01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
#FUN-A80106 add --start--
        LET g_cnt = 0
        #出庫
        SELECT COUNT(*) INTO g_cnt FROM idb_file
         WHERE idb07 = g_imr.imr01
        IF g_cnt > 0 THEN
           #此單號項次已有刻號/BIN明細資料,將一併刪除,是否確定執行此動作？
           IF NOT cl_confirm('aic-112') THEN
              CLOSE t309_cl
              ROLLBACK WORK
              RETURN
           ELSE
              LET g_cnt = 0
              #出庫
              CALL s_icdinout_del(-1,g_imr.imr01,'','')  #FUN-B80119--傳入p_plant參數''---
                   RETURNING l_flag
              IF l_flag = 0 THEN
                 CLOSE t309_cl
                 ROLLBACK WORK
                 RETURN
              END IF
            END IF
        END IF
#FUN-A80106 add --end--            
         DELETE FROM imr_file WHERE imr01 = g_imr.imr01
         DELETE FROM imq_file WHERE imq01 = g_imr.imr01
        #FUN-B30187 --START--
        IF NOT s_del_imqi(g_imr.imr01,'','') THEN 
           #不作處理        
        END IF
        #FUN-B30187 --END--
#FUN-C50071 add begin-------------------------
        FOR l_i = 1 TO g_rec_b
            IF NOT s_lot_del(g_prog,g_imr.imr01,'',0,g_imq[l_i].imq05,'DEL') THEN
              ROLLBACK WORK
              RETURN
            END IF
        END FOR
#FUN-C50071 add -end--------------------------
         INITIALIZE g_imr.* TO NULL
         CLEAR FORM
         CALL g_imq.clear()
         OPEN t309_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE t309_cs
            CLOSE t309_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH t309_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t309_cs
            CLOSE t309_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t309_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t309_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t309_fetch('/')
         END IF
    END IF
    CLOSE t309_cl
    COMMIT WORK
    CALL cl_flow_notify(g_imr.imr01,'D')
END FUNCTION
 
#單身
FUNCTION t309_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用  #No.FUN-690026 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否  #No.FUN-690026 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態  #No.FUN-690026 VARCHAR(1)
    l_ima02         LIKE ima_file.ima02,   #品名規格
    l_ima05         LIKE ima_file.ima05,   #目前版本
    l_ima08         LIKE ima_file.ima08,   #來源碼
    l_ima25         LIKE ima_file.ima25,   #庫存單位
    l_imq10         LIKE imq_file.imq10,
    l_img10         LIKE img_file.img10,    #-No.MOD-580069 add
    l_direct        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    l_code          LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(07)
    l_imp04         LIKE imp_file.imp04,
    l_imp08         LIKE imp_file.imp08,
    l_message       LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(80)
    l_digcut        LIKE imq_file.imq07,    #MOD-530179
    l_digcut1       LIKE imq_file.imq07,    #MOD-530179
    l_keyinyes      LIKE imq_file.imq07,    #MOD-530179,  #已登打數量
    l_keyinno       LIKE imq_file.imq07,    #MOD-530179,  #未登打數量
    l_imq07         LIKE imq_file.imq07,
    l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-690026 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否  #No.FUN-690026 SMALLINT
#FUN-A80106 add --start--
DEFINE   l_flag     LIKE type_file.chr1       #判斷BIN/刻號處理成功否
#DEFINE   l_imaicd08 LIKE imaicd_file.imaicd08 #刻號明細維護   #FUN-BA0051 mark
DEFINE   l_imaicd01 LIKE imaicd_file.imaicd01 
DEFINE   l_imq05    LIKE imq_file.imq05
DEFINE   l_act      LIKE type_file.chr1
DEFINE   l_r        LIKE type_file.chr1  #FUN-C30302
DEFINE   l_qty      LIKE type_file.num15_3  #FUN-C30302
#FUN-A80106 add --end--    
DEFINE   l_case     STRING                   #FUN-BB0083 add
DEFINE   l_flag1    LIKE type_file.chr1      #FUN-CB0087
DEFINE   l_where    STRING                   #FUN-CB0087
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_imr.imr01) THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_imr.imrconf = 'Y' THEN
        CALL cl_err(g_imr.imr01,'9023',0)
        RETURN
    END IF
    IF g_imr.imrpost = 'Y' THEN
        CALL cl_err(g_imr.imr01,'afa-101',0)
        RETURN
    END IF
    IF g_imr.imrconf = 'X' THEN #FUN-660080
        CALL cl_err(g_imr.imr01,'axr-103',0)
        RETURN
    END IF
 
    LET g_change1='N' #No.FUN-570249
    CALL t309_b_g()   #自動代出未全數償還之借料單身
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
     " SELECT imq02,imq03 ,imq04,'','',",
      "        '','','','','',imq05 ,'',imq08,imq09 ,imq10,imq06,'',",    #No.MOD-480396
      #"        imq07,imq23,imq24,imq25,imq20,imq21,imq22,'',imq06_fac,imq15,imq930,'' ",   #No.FUN-5C0077 #FUN-670093      #FUN-CB0087 mark
     "        imq07,imq23,imq24,imq25,imq20,imq21,imq22,imq26,'','',imq06_fac,imq15,imq930,'' ",   #No.FUN-5C0077 #FUN-670093  #FUN-CB0087 add>imq26,''
     "        ,'',''",   #FUN-B30187
     "   FROM imq_file ",
     "    WHERE imq01= ? ",
     "    AND imq02= ? ",
     "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t309_bcl CURSOR FROM g_forupd_sql
    
    #FUN-B30187 --START--
    LET g_forupd_sql = " SELECT imqiicd028,imqiicd029 FROM imqi_file ",
                          "  WHERE imqi01 = ? ",
                          "    AND imqi02 = ? ",
                          "    FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t309_bcl_ind CURSOR FROM g_forupd_sql
    #FUN-B30187 --END--
 
    LET l_ac_t = 0
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    IF g_rec_b = 0 THEN CALL g_imq.clear() END IF  #No.FUN-5C0077
 
    INPUT ARRAY g_imq WITHOUT DEFAULTS FROM s_imq.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           IF g_sma.sma115 = 'Y' THEN
             SELECT ima906 INTO g_ima906 FROM ima_file,imr_file,imq_file
              WHERE imr01=imq01 and ima01=imq05 and imr01=g_imr.imr01
           END IF
           CALL t309_set_entry_b(p_cmd)
           CALL t309_set_no_entry_b(p_cmd)
           LET g_before_input_done = TRUE
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
#FUN-A80106 add --start--
            LET l_act = NULL
#FUN-A80106 add --end--            
            BEGIN WORK
            OPEN t309_cl USING g_imr.imr01
            IF STATUS THEN
               CALL cl_err("OPEN t309_cl:", STATUS, 1)
               CLOSE t309_cl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH t309_cl INTO g_imr.*            # 鎖住將被更改或取消的資料
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_imr.imr01,SQLCA.sqlcode,0)      # 資料被他人LOCK
                  CLOSE t309_cl
                  ROLLBACK WORK
                  RETURN
               END IF
            END IF
            LET g_ima906 = ' '  #TQC-7A0096
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_imq_t.* = g_imq[l_ac].*  #BACKUP
                #FUN-BB0083---add---str
                LET g_imq06_t = g_imq[l_ac].imq06
                LET g_imq20_t = g_imq[l_ac].imq20
                LET g_imq23_t = g_imq[l_ac].imq23
                #FUN-BB0083---add---end
 
                OPEN t309_bcl USING g_imr.imr01,g_imq_t.imq02
                IF STATUS THEN
                    CALL cl_err("OPEN t309_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH t309_bcl INTO g_imq[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_imq_t.imq02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    #FUN-B30187 --START--
                    ELSE 
                       OPEN t309_bcl_ind USING g_imr.imr01,g_imq_t.imq02
                       IF STATUS THEN
                          CALL cl_err("OPEN t309_bcl_ind:", STATUS, 1)
                          LET l_lock_sw = "Y"
                       ELSE 
                          FETCH t309_bcl_ind INTO g_imq[l_ac].imqiicd028,g_imq[l_ac].imqiicd029
                          IF SQLCA.sqlcode THEN
                             CALL cl_err('lock imqi',SQLCA.sqlcode,1)
                             LET l_lock_sw = "Y"
                          END IF 
                       END IF
                    #FUN-B30187 --END--
                    END IF
                    SELECT ima906 INTO g_ima906 FROM ima_file WHERE ima01=g_imq[l_ac].imq05 #TQC-7A0096
                    LET g_imq[l_ac].gem02c=s_costcenter_desc(g_imq[l_ac].imq930) #FUN-670093
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
                LET g_change='N'
                CALL t309_set_entry_b(p_cmd)
                CALL t309_set_no_entry_b(p_cmd)
                              
            END IF
            CALL t309_imq04('d')
            CALL t309_imq05(' ')
            CALL t309_imq26()       #FUN-CB0087
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF g_imq[l_ac].imq09 IS NULL THEN
                LET g_imq[l_ac].imq09 = ' '
            END IF
            IF g_imq[l_ac].imq10 IS NULL THEN
                LET g_imq[l_ac].imq10 = ' '
            END IF
            IF g_sma.sma115 = 'Y' THEN
               CALL s_chk_va_setting(g_imq[l_ac].imq05)
                    RETURNING g_flag,g_ima906,g_ima907
               IF g_flag=1 THEN
                  NEXT FIELD imp03
               END IF
               CALL t309_du_data_to_correct()
            END IF
            CALL t309_set_origin_field()
#FUN-A80106 add --start--
	    #   料號為參考單位,單一單位,且狀態為其它段生產料號(imaicd04=3,4)時,
            #   將單位一的資料給單位二
            CALL t309_ind_icd_set_value()
#FUN-A80106 add --end--

#FUN-C50071 add begin-------------------------
            SELECT ima918,ima921 INTO g_ima918,g_ima921
              FROM ima_file
             WHERE ima01 = g_imq[l_ac].imq05
               AND imaacti = "Y"

            IF (g_ima918 = 'Y' OR g_ima921 = 'Y') AND g_imq[l_ac].imq15 = 'N'
               AND (g_imq[l_ac].imq07 <> g_imq_t.imq07 OR cl_null(g_imq_t.imq07)) THEN
               LET g_success = 'Y'
               LET g_img09 = ''

               SELECT img09 INTO g_img09 FROM img_file
                  WHERE img01 = g_imq[l_ac].imq05
                    AND img02 = g_imq[l_ac].imq08
                    AND img03 = g_imq[l_ac].imq09
                    AND img04 = g_imq[l_ac].imq10

               CALL s_umfchk(g_imq[l_ac].imq05,g_imq[l_ac].imq06,g_img09)
                  RETURNING l_i,l_fac
               IF l_i = 1 THEN LET l_fac = 1 END IF

               CALL s_mod_lot(g_prog,g_imr.imr01,g_imq[l_ac].imq02,0,
                             g_imq[l_ac].imq05,g_imq[l_ac].imq08,
                             g_imq[l_ac].imq09,g_imq[l_ac].imq10,
                             g_imq[l_ac].imq06,g_img09,
                             g_imq[l_ac].imq06_fac,g_imq[l_ac].imq07,'','MOD',-1)
                  RETURNING l_r,g_qty
               IF l_r = "Y" THEN
                  LET g_imq[l_ac].imq07 = g_qty
               END IF
            END IF
            LET g_success = 'Y'
            IF s_chk_rvbs('',g_imq[l_ac].imq05) THEN
               CALL t309_rvbs()
            END IF
            IF g_success = 'N' THEN
               CANCEL INSERT
               NEXT FIELD imq02
            END IF
#FUN-C50071 add -end--------------------------
            LET g_success = 'Y'   #FUN-B30187
            
            INSERT INTO imq_file (imq01,imq02,imq03,imq04,imq05,imq06,
                                  imq06_fac,imq07,imq08,imq09,imq10,imq11,
                                  imq12,imq13,imq14,imq16,imq17,          #TQC-740117
                                  #imq18,imq19,imq20,imq21,imq22,imq23,        #FUN-CB0087 mark
                                  imq18,imq19,imq20,imq21,imq22,imq26,imq23,   #FUN-CB0087 add>imq26
                                  imq24,imq25,imq15,imq930,imqplant,imqlegal)  #No.FUN-5C0077 #FUN-670093 #FUN-980004 add imqplant,imqlegal
            VALUES(g_imr.imr01,g_imq[l_ac].imq02,
                   g_imq[l_ac].imq03,g_imq[l_ac].imq04,
                   g_imq[l_ac].imq05,g_imq[l_ac].imq06,g_imq[l_ac].imq06_fac,
                   g_imq[l_ac].imq07,g_imq[l_ac].imq08,
                   g_imq[l_ac].imq09,g_imq[l_ac].imq10,
                   NULL,NULL,NULL,NULL,       #TQC-740117
                   NULL,NULL,NULL,NULL,g_imq[l_ac].imq20,
                   #g_imq[l_ac].imq21,g_imq[l_ac].imq22,                         #FUN-CB0087 mark
                   g_imq[l_ac].imq21,g_imq[l_ac].imq22,g_imq[l_ac].imq26,       #FUN-CB0087 add>imq26
                   g_imq[l_ac].imq23,g_imq[l_ac].imq24,
                   g_imq[l_ac].imq25,g_imq[l_ac].imq15,g_imq[l_ac].imq930,g_plant,g_legal)  #No.FUN-5C0077 #FUN-670093 #FUN-980004 add g_plant,g_legal
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","imq_file",g_imr.imr01,g_imq[l_ac].imq02,
                             SQLCA.sqlcode,"","",1)  #No.FUN-660156
               LET g_success = 'N'   #FUN-B30187
               CANCEL INSERT
#FUN-C50071 add begin-------------------------
               SELECT ima918,ima921 INTO g_ima918,g_ima921
                  FROM ima_file
                  WHERE ima01 = g_imq[l_ac].imq04
                    AND imaacti = 'Y'
               
               IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  IF NOT s_lot_del(g_prog,g_imr.imr01,g_imq[l_ac].imq02,0,g_imq[l_ac].imq05,'DEL') THEN
                     CALL cl_err3("del","rvbs_file",g_imr.imr01,g_imq_t.imq02,
                                   SQLCA.sqlcode,"","",1)
                  END IF
               END IF
#FUN-C50071 add -end--------------------------
            ELSE
               #FUN-B30187 --START--
               LET b_imqi.imqi01 = g_imr.imr01
               LET b_imqi.imqi02 = g_imq[l_ac].imq02
               LET b_imqi.imqiicd028 = g_imq[l_ac].imqiicd028
               LET b_imqi.imqiicd029 = g_imq[l_ac].imqiicd029
               LET b_imqi.imqilegal = g_legal
               LET b_imqi.imqiplant = g_plant              
               IF NOT s_ins_imqi(b_imqi.*,g_plant) THEN
                  LET g_success = 'N'  
                  CANCEL INSERT
               END IF
              #FUN-B30187 --END--
            END IF

            IF g_success = 'Y' THEN   ##FUN-B30187
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
#FUN-A80106 add --start--
	           LET l_act = 'a'
#FUN-A80106 add --end--  
            END IF 
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_imq[l_ac].* TO NULL      #900423
             INITIALIZE g_imq_t       TO NULL      #MOD-510086
            LET g_imq[l_ac].imq07 = 0
            LET g_imq[l_ac].imq06_fac = 1
            LET g_imq[l_ac].imq15 = 'N'
            LET g_imq[l_ac].imq21=1
            LET g_imq[l_ac].imq24=1
            LET g_change='Y'
            LET g_imq[l_ac].imq930 = s_costcenter(g_imr.imr04) #FUN-670093
            LET g_imq[l_ac].gem02c = s_costcenter_desc(g_imq[l_ac].imq930) #FUN-670093
            LET g_imq_t.* = g_imq[l_ac].*         #新輸入資料
            #FUN-BB0083---add---str
            LET g_imq06_t = NULL
            LET g_imq20_t = NULL
            LET g_imq23_t = NULL 
            #FUN-BB0083---add---end
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD imq02
 
        BEFORE FIELD imq02                        #default 序號
            IF g_imq[l_ac].imq02 IS NULL OR
               g_imq[l_ac].imq02 = 0 THEN
                SELECT max(imq02)+1
                   INTO g_imq[l_ac].imq02
                   FROM imq_file
                   WHERE imq01 = g_imr.imr01
                IF g_imq[l_ac].imq02 IS NULL THEN
                    LET g_imq[l_ac].imq02 = 1
                END IF
            END IF
 
        AFTER FIELD imq02                        #check 序號是否重複
            IF g_imq[l_ac].imq02 != g_imq_t.imq02 OR
               g_imq[l_ac].imq02 = 0 OR #TQC-CB0014
               g_imq_t.imq02 IS NULL THEN
               #TQC-CB0014--add--str
               IF g_imq[l_ac].imq02 = 0 THEN
                  LET g_imq[l_ac].imq02 = g_imq_t.imq02
                  CALL cl_err('','aec-994',0)
                  NEXT FIELD imq02
               END IF
              #TQC-CB0014--add--end
                SELECT count(*) INTO l_n FROM imq_file
                 WHERE imq01 = g_imr.imr01
                   AND imq02 = g_imq[l_ac].imq02
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_imq[l_ac].imq02 = g_imq_t.imq02
                    NEXT FIELD imq02
                END IF
            END IF
#FUN-A80106 add --start--
           #若已有ida/idb存在不可修改--(S)
           IF p_cmd = 'u' AND NOT cl_null(g_imq[l_ac].imq02) THEN
              IF g_imq_t.imq02 <> g_imq[l_ac].imq02 THEN
                 CALL t309_ind_icd_chk_icd()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_imq[l_ac].imq02 = g_imq_t.imq02
                    NEXT FIELD imq02
                 END IF
              END IF
           END IF
           #若已有ida/idb存在不可修改--(E)
#FUN-A80106 add --end--               
 
        AFTER FIELD imq03 #借料編號
            IF NOT cl_null(g_imq[l_ac].imq03) THEN
                IF NOT cl_null(g_imr.imr05) THEN
                    IF g_imq[l_ac].imq03 != g_imr.imr05 THEN
                        #此單身借料單號與單頭的借料單號不同!
                        CALL cl_err(g_imq[l_ac].imq03,'aim-113',0)
                        LET g_imq[l_ac].imq03 = g_imq_t.imq03
                        DISPLAY BY NAME g_imq[l_ac].imq03
                        NEXT FIELD imq03
                    END IF
                END IF
                CALL t309_imr05(g_imq[l_ac].imq03)
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_imq[l_ac].imq03,g_errno,0)
                    LET g_imq[l_ac].imq03 = g_imq_t.imq03
                    NEXT FIELD imq03
                END IF
                #FUN-CB0087---add---str---
                IF NOT t309_imq26_chk() THEN
                   NEXT FIELD imq26
                END IF
                #FUN-CB0087---add---end---
            END IF
        
        AFTER FIELD imq04 #借料編號-項次
           IF NOT cl_null(g_imq[l_ac].imq04)THEN
               CALL t309_imq04(p_cmd)  #MOD-860030 add
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_imq[l_ac].imq03,g_errno,0)
                   LET g_imq[l_ac].imq03 = g_imq_t.imq03
                   LET g_imq[l_ac].imq04 = g_imq_t.imq04
                   DISPLAY BY NAME g_imq[l_ac].imq03
                   DISPLAY BY NAME g_imq[l_ac].imq04
                   NEXT FIELD imq03
                ELSE
                   SELECT imp930 INTO g_imq[l_ac].imq930 FROM imp_file
                                                        WHERE imp01=g_imq[l_ac].imq03
                                                          AND imp02=g_imq[l_ac].imq04
                   LET g_imq[l_ac].gem02c=s_costcenter_desc(g_imq[l_ac].imq930) #FUN-670093
                   DISPLAY BY NAME g_imq[l_ac].imq930
                   DISPLAY BY NAME g_imq[l_ac].gem02c
                END IF
           END IF
           SELECT imp04,imp08 INTO l_imp04,l_imp08
             FROM imp_file
            WHERE imp01 = g_imq[l_ac].imq03
              AND imp02 = g_imq[l_ac].imq04
           #還>借
           IF l_imp08 >= l_imp04 THEN
               #借料數量已還清!
               CALL cl_err('','aim-116',0)
               NEXT FIELD imq03
           END IF
           IF p_cmd = 'a' OR g_imq[l_ac].imq03 <> g_imq_t.imq03 OR
                             g_imq[l_ac].imq04 <> g_imq_t.imq04 THEN
                    SELECT SUM(imq07/imq06_fac)
                      INTO l_keyinyes #已登打的數量
                      FROM imq_file,imr_file
                     WHERE imq03 = g_imq[l_ac].imq03
                       AND imq04 = g_imq[l_ac].imq04
                       AND imrconf <> 'X' #作廢的不算 #FUN-660080
                       AND imr01 = imq01
                    IF cl_null(l_keyinyes) THEN
                        LET l_keyinyes = 0
                    END IF
                    #  已登打數量 >= 借料數量
                    IF l_keyinyes >= l_imp04 THEN
                        LET l_message = NULL
                        LET l_message = g_imq[l_ac].imq03,'+',g_imq[l_ac].imq04
                        #未登打數量等於零
                        CALL cl_err(l_message,'aim-118',0)
                        INITIALIZE g_imq[l_ac].* TO NULL
                        LET g_imq[l_ac].imq15='N' #CHI-740017
                        DISPLAY BY NAME g_imq[l_ac].imq15
                        NEXT FIELD imq02
                    END IF
           END IF
           #FUN-CB0087---add---str---
           IF NOT cl_null(g_imq[l_ac].imq04)THEN
              IF NOT t309_imq26_chk() THEN
                 NEXT FIELD imq26
              END IF
           END IF
           #FUN-CB0087---add---end---
 
        BEFORE FIELD imq05
           CALL t309_set_entry_b(p_cmd)
           CALL t309_set_no_required()
 
        AFTER FIELD imq05  #還料料號
            IF NOT cl_null(g_imq[l_ac].imq05) THEN
#FUN-AA0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(g_imq[l_ac].imq05,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_imq[l_ac].imq05= g_imq_t.imq05
                  NEXT FIELD imq05
               END IF
#FUN-AA0059 ---------------------end-------------------------------
              IF cl_null(g_imq_t.imq05) OR g_imq[l_ac].imq05<>g_imq_t.imq05 THEN
                 LET g_change = 'Y'
              END IF
              IF g_sma.sma115 = 'Y' THEN
                 CALL s_chk_va_setting(g_imq[l_ac].imq05)
                      RETURNING g_flag,g_ima906,g_ima907
                 IF g_flag=1 THEN
                    NEXT FIELD imq05
                 END IF
                 IF g_ima906 = '3' THEN
                    LET g_imq[l_ac].imq23=g_ima907
                 END IF
              END IF
#FUN-A80106 add --start--
	         #若已有ida/idb存在不可修改--(S)
           IF p_cmd = 'u' AND NOT cl_null(g_imq[l_ac].imq05) THEN
              IF g_imq_t.imq05 <> g_imq[l_ac].imq05 THEN
                 CALL t309_ind_icd_chk_icd()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_imq[l_ac].imq05 = g_imq_t.imq05
                    NEXT FIELD imq05
                 END IF
              END IF
           END IF
           #FUN-AA0007--begin--add-----------
           IF NOT s_icdout_holdlot(g_imq[l_ac].imq05,g_imq[l_ac].imq08,
                                   g_imq[l_ac].imq09,g_imq[l_ac].imq10) THEN
              NEXT FIELD imq05
           END IF
           #FUN-AA0007--end--add------------
#FUN-A80106 add --end--                  
            END IF
            CALL t309_set_no_entry_b(p_cmd)
            CALL t309_set_required()

        AFTER FIELD imq08  #倉庫
            IF NOT cl_null(g_imq[l_ac].imq08) THEN
               #FUN-D20060--add--str--
               IF NOT s_chksmz(g_imq[l_ac].imq05, g_imr.imr01,
                               g_imq[l_ac].imq08, g_imq[l_ac].imq09) THEN
                  NEXT FIELD imq08
               END IF
               #FUN-D20060--add--str--
                #No.FUN-AB0067--begin    
                IF NOT s_chk_ware(g_imq[l_ac].imq08) THEN
                   NEXT FIELD imq08
                END IF 
                #No.FUN-AB0067--end                
                IF NOT s_imfchk1(g_imq[l_ac].imq05,g_imq[l_ac].imq08)
                   THEN CALL cl_err(g_imq[l_ac].imq08,'mfg9036',0)
                        NEXT FIELD imq08
                END IF
                CALL  s_stkchk(g_imq[l_ac].imq08,'A') RETURNING l_code
                IF l_code = 0 THEN
                   CALL cl_err(g_imq[l_ac].imq08,'mfg4020',0)
                   NEXT FIELD imq08
                END IF
                #----->檢查倉庫是否為可用倉
                CALL  s_swyn(g_imq[l_ac].imq08) RETURNING sn1,sn2
                IF sn1=1 AND g_imq[l_ac].imq08!=t_img02 THEN
                   CALL cl_err(g_imq[l_ac].imq08,'mfg6080',0)
                   LET t_img02=g_imq[l_ac].imq08
                   NEXT FIELD imq08
                ELSE
                  IF sn2=2 AND g_imq[l_ac].imq08!=t_img02 THEN
                     CALL cl_err(g_imq[l_ac].imq08,'mfg6085',0)
                     LET t_img02=g_imq[l_ac].imq08
                     NEXT FIELD imq08
                  END IF
                END IF
                LET sn1=0 LET sn2=0
                IF cl_null(g_imq_t.imq08) OR
                   g_imq_t.imq08 <> g_imq[l_ac].imq08 THEN
                   LET g_change='Y'
                END IF
            END IF
#FUN-A80106 add --start--
           #若已有ida/idb存在不可修改--(S)
           IF p_cmd = 'u' AND NOT cl_null(g_imq[l_ac].imq08) THEN
              IF g_imq_t.imq08 <> g_imq[l_ac].imq08 THEN
                 CALL t309_ind_icd_chk_icd()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_imq[l_ac].imq08 = g_imq_t.imq08
                    NEXT FIELD imq08
                 END IF
              END IF
           END IF
           #FUN-AA0007--begin--add-----------
           IF NOT s_icdout_holdlot(g_imq[l_ac].imq05,g_imq[l_ac].imq08,
                                   g_imq[l_ac].imq09,g_imq[l_ac].imq10) THEN
              NEXT FIELD imq08
           END IF
           #FUN-AA0007--end--add------------
           #若已有ida/idb存在不可修改--(E)
#FUN-A80106 add --end--              
           #FUN-CB0087---add---str---
           IF NOT t309_imq26_chk() THEN
              NEXT FIELD imq26
           END IF
           #FUN-CB0087---add---end---
 
        AFTER FIELD imq09  #儲位
           #BugNo:5626 控管是否為全型空白
           IF g_imq[l_ac].imq09 = '　' THEN #全型空白
               LET g_imq[l_ac].imq09 =' '
           END IF
           IF cl_null(g_imq[l_ac].imq09) THEN LET g_imq[l_ac].imq09=' ' END IF
           IF NOT cl_null(g_imq[l_ac].imq09) THEN  
              IF NOT cl_null(g_imq[l_ac].imq08) THEN  #FUN-D20060
               #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
                 IF NOT s_chksmz(g_imq[l_ac].imq05, g_imr.imr01,
                                 g_imq[l_ac].imq08, g_imq[l_ac].imq09) THEN
                    NEXT FIELD imq09
                 END IF
               END IF   #FUN-D20060
               IF NOT s_imfchk(g_imq[l_ac].imq05,g_imq[l_ac].imq08,g_imq[l_ac].imq09)
                  THEN CALL cl_err(g_imq[l_ac].imq09,'mfg6095',0)
                  NEXT FIELD imq09
               END IF
 
               #---->需存在倉庫/儲位檔中
               IF g_imq[l_ac].imq09 IS NOT NULL THEN
                  CALL s_hqty(g_imq[l_ac].imq05,g_imq[l_ac].imq08,g_imq[l_ac].imq09)
                       RETURNING g_cnt,g_img19,g_imf05
                  IF g_img19 IS NULL THEN LET g_img19=0 END IF
                  LET h_qty=g_img19
                  CALL  s_lwyn(g_imq[l_ac].imq08,g_imq[l_ac].imq09) RETURNING sn1,sn2
                   IF sn1=1 AND g_imq[l_ac].imq09!=t_img03
                      THEN CALL cl_err(g_imq[l_ac].imq09,'mfg6080',0)
                           LET t_img03=g_imq[l_ac].imq09
                           NEXT FIELD imq09
                   ELSE IF sn2=2 AND g_imq[l_ac].imq09!=t_img03
                           THEN CALL cl_err(g_imq[l_ac].imq09,'mfg6085',0)
                           LET t_img03=g_imq[l_ac].imq09
                           NEXT FIELD imq09
                        END IF
                   END IF
                   LET sn1=0 LET sn2=0
               END IF
               LET l_direct='D'
           END IF
           IF g_imq_t.imq09 IS NULL OR
              g_imq_t.imq09 <> g_imq[l_ac].imq09 THEN
              LET g_change='Y'
           END IF
#FUN-A80106 add --start--
	        IF p_cmd = 'u' THEN
             IF cl_null(g_imq_t.imq09) THEN LET g_imq_t.imq09 = ' ' END IF
             IF g_imq_t.imq09 <> g_imq[l_ac].imq09 THEN
                CALL t309_ind_icd_chk_icd()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   LET g_imq[l_ac].imq09 = g_imq_t.imq09
                   NEXT FIELD imq09
                END IF
             END IF
          END IF
          #FUN-AA0007--begin--add-----------
          IF NOT s_icdout_holdlot(g_imq[l_ac].imq05,g_imq[l_ac].imq08,
                                  g_imq[l_ac].imq09,g_imq[l_ac].imq10) THEN
             NEXT FIELD imq09
          END IF
          #FUN-AA0007--end--add------------
#FUN-A80106 add --end--            
 
        AFTER FIELD imq10  # 批號
           #BugNo:5626 控管是否為全型空白
           IF g_imq[l_ac].imq10 = '　' THEN #全型空白
               LET g_imq[l_ac].imq10 =' '
           END IF
           IF g_imq[l_ac].imq10 IS NULL THEN LET g_imq[l_ac].imq10 = ' ' END IF
           IF NOT cl_null(g_imq[l_ac].imq08) THEN
               SELECT * FROM img_file
                WHERE img01=g_imq[l_ac].imq05 AND img02=g_imq[l_ac].imq08
                  AND img03=g_imq[l_ac].imq09 AND img04=g_imq[l_ac].imq10
               IF STATUS=100 THEN
                 #FUN-C80107 modify begin---------------------------------------121024
                 #CALL cl_err3("sel","img_file",g_imq[l_ac].imq05,g_imq[l_ac].imq08,
                 #             "mfg6142","","",1)  #No.FUN-660156
                  LET l_flag01 = NULL
                  #CALL s_inv_shrt_by_warehouse(g_sma.sma894[5,5],g_imq[l_ac].imq08) RETURNING l_flag01 #FUN-D30024--mark
                  CALL s_inv_shrt_by_warehouse(g_imq[l_ac].imq08,g_plant) RETURNING l_flag01     #FUN-D30024--add #TQC-D40078 g_plant
                  IF l_flag01 = 'N' OR l_flag01 IS NULL THEN
                     CALL cl_err3("sel","img_file",g_imq[l_ac].imq05,g_imq[l_ac].imq08,
                                  "mfg6142","","",1)
                     NEXT FIELD imq08
                  ELSE
                     IF g_sma.sma892[3,3] = 'Y' THEN
                        IF NOT cl_confirm('mfg1401') THEN NEXT FIELD imq08 END IF
                     END IF
                     CALL s_add_img(g_imq[l_ac].imq05,g_imq[l_ac].imq08,
                                    g_imq[l_ac].imq09,g_imq[l_ac].imq10,
                                    g_imr.imr01      ,g_imq[l_ac].imq02,
                                    g_imr.imr02)
                     IF g_errno='N' THEN
                        NEXT FIELD imq08
                     END IF
                  END IF
                 #FUN-C80107 modify end-----------------------------------------
               END IF
               CALL t309_imq10_a()
               IF g_imq[l_ac].imq06 IS NULL THEN
                  LET g_imq[l_ac].imq06=g_imq[l_ac].imp05
                  DISPLAY BY NAME g_imq[l_ac].imq06
               END IF
               IF NOT s_actimg(g_imq[l_ac].imq05,g_imq[l_ac].imq08,
                               g_imq[l_ac].imq09,g_imq[l_ac].imq10) THEN
                  CALL cl_err('inactive','mfg6117',0)
                  NEXT FIELD imq08
               END IF
               IF g_imq[l_ac].imq06 IS NULL THEN
                  LET g_imq[l_ac].imq06=g_imq[l_ac].imp05
               END IF
               LET l_direct='D'
               SELECT img09 INTO g_img09 FROM img_file
                WHERE img01=g_imq[l_ac].imq05 AND img02=g_imq[l_ac].imq08
                  AND img03=g_imq[l_ac].imq09 AND img04=g_imq[l_ac].imq10
               CALL t309_du_default(p_cmd)
           END IF
           IF g_imq_t.imq10 IS NULL OR
              g_imq_t.imq10 <> g_imq[l_ac].imq10 THEN
              LET g_change='Y'
           END IF
#FUN-A80106 add --start--
	         IF p_cmd = 'u' THEN
              IF cl_null(g_imq_t.imq10) THEN LET g_imq_t.imq10 = ' ' END IF
              IF g_imq_t.imq10 <> g_imq[l_ac].imq10 THEN
                 CALL t309_ind_icd_chk_icd()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_imq[l_ac].imq10 = g_imq_t.imq10
                    NEXT FIELD imq10
                 END IF
              END IF
           END IF
          #FUN-AA0007--begin--add-----------
          IF NOT s_icdout_holdlot(g_imq[l_ac].imq05,g_imq[l_ac].imq08,
                                  g_imq[l_ac].imq09,g_imq[l_ac].imq10) THEN
             NEXT FIELD imq10
          END IF
          #FUN-AA0007--end--add------------
          CALL t309_def_imqiicd029()   #FUN-B30187 
#FUN-A80106 add --end--            
 
        AFTER FIELD imq06
            IF NOT cl_null(g_imq[l_ac].imq06) THEN
                CALL t309_unit(g_imq[l_ac].imq06)
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD imq06
                END IF
                CALL s_umfchk(g_imq[l_ac].imq05,g_imq[l_ac].imp05,
                              g_imq[l_ac].imq06)
                        RETURNING g_cnt,g_imq[l_ac].imq06_fac
                        DISPLAY BY NAME g_imq[l_ac].imq06_fac
                IF g_cnt = 1 THEN
                   CALL cl_err('','mfg3075',0)
                   NEXT FIELD imq06
                END IF
                LET l_direct='D'
            END IF
#FUN-A80106 add --start--
	         IF p_cmd = 'u' AND g_sma.sma115 = 'N' AND
              NOT cl_null(g_imq[l_ac].imq06) THEN
              IF g_imq_t.imq06 <> g_imq[l_ac].imq06 THEN
                 CALL t309_ind_icd_chk_icd()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_imq[l_ac].imq06 = g_imq_t.imq06
                    NEXT FIELD imq06
                 END IF
              END IF
           END IF
#FUN-A80106 add --end--
#FUN-BB0083---add---str
           IF NOT cl_null(g_imq[l_ac].imq06) AND NOT cl_null(g_imq[l_ac].imq07) AND g_imq[l_ac].imq07<>0 THEN #FUN-C20048
              CALL t309_imq07_check() RETURNING l_case
              LET g_imq06_t = g_imq[l_ac].imq06
              CASE l_case
                 WHEN "imq03"
                    NEXT FIELD imq03
                 WHEN "imq07"
                    NEXT FIELD imq07
                 WHEN "imq08"
                    NEXT FIELD imq08
                 OTHERWISE EXIT CASE
              END CASE 
           END IF 
#FUN-BB0083---add---end
 
        BEFORE FIELD imq07
           #當下那筆還料數量
           LET l_digcut = g_imq[l_ac].imq07/g_imq[l_ac].imq06_fac
           CALL cl_digcut(l_digcut,3) RETURNING l_digcut
           IF cl_null(l_digcut) THEN
               LET l_digcut = 0
           END IF
 
           #原本的還料數量
           LET l_digcut1 = g_imq_t.imq07/g_imq_t.imq06_fac
           CALL cl_digcut(l_digcut1,3) RETURNING l_digcut1
           IF cl_null(l_digcut1) THEN
               LET l_digcut1 = 0
           END IF
 
           SELECT SUM(imq07/imq06_fac)
             INTO l_keyinyes #已登打的數量
             FROM imq_file,imr_file
            WHERE imq03 = g_imq[l_ac].imq03
              AND imq04 = g_imq[l_ac].imq04
              AND imrconf <> 'X' #作廢的不算 #FUN-660080
              AND imr01 = imq01
           IF cl_null(l_keyinyes) THEN
               LET l_keyinyes = 0
           END IF
           LET l_keyinyes = l_keyinyes - l_digcut1 #已登打數量 - 原本的  還料數量
           LET l_keyinyes = l_keyinyes + l_digcut  #已登打數量 + 當下那筆還料數量
           IF l_keyinyes > g_imq[l_ac].imp04 THEN
               LET l_keyinno = 0 #未登打數量
           ELSE
               LET l_keyinno = g_imq[l_ac].imp04 - l_keyinyes #未登打數量
           END IF
           LET l_message = NULL
           LET l_message =   '借料:',g_imq[l_ac].imp04 USING '#######&.&',g_imq[l_ac].imp05,' ',
                           '已登打:',       l_keyinyes USING '#######&.&',g_imq[l_ac].imp05,' ',
                           '未登打:',       l_keyinno  USING '#######&.&',g_imq[l_ac].imp05
           IF g_imq[l_ac].imp05 <> g_imq[l_ac].imq06 THEN
               LET l_message = l_message CLIPPED,'=',l_keyinno*g_imq[l_ac].imq06_fac USING '#######&.&',g_imq[l_ac].imq06
           END IF
           ERROR l_message
 
        AFTER FIELD imq07
          #FUN-BB0083---add---str
          CALL t309_imq07_check() RETURNING l_case
          CASE l_case
             WHEN "imq03"
                 NEXT FIELD imq03
             WHEN "imq07"
                 NEXT FIELD imq07
             WHEN "imq08"
                 NEXT FIELD imq08
             OTHERWISE EXIT CASE
          END CASE 
          #FUN-BB0083---add---end
          #FUN-BB0083---mark---str
          # IF g_imq[l_ac].imq07 = 0 THEN
          #     CALL cl_err('','mfg1322',1)
          #     NEXT FIELD imq07
          # END IF
          # IF NOT cl_null(g_imq[l_ac].imq07) THEN
          #     IF g_imq[l_ac].imq07 < 0 THEN 
          #        CALL cl_err('','aec-020',1)
          #        NEXT FIELD imq07
          #     END IF 
          #     LET g_imq[l_ac].imq07f = g_imq[l_ac].imq07 / g_imq[l_ac].imq06_fac
          #     DISPLAY BY NAME g_imq[l_ac].imq07f
          #     #當下那筆還料數量
          #     LET l_digcut = g_imq[l_ac].imq07/g_imq[l_ac].imq06_fac
          #     CALL cl_digcut(l_digcut,3) RETURNING l_digcut
          #     IF cl_null(l_digcut) THEN
          #         LET l_digcut = 0
          #     END IF
 
               #原本的還料數量
          #     LET l_digcut1 = g_imq_t.imq07/g_imq_t.imq06_fac
          #     CALL cl_digcut(l_digcut1,3) RETURNING l_digcut1
          #     IF cl_null(l_digcut1) THEN
          #         LET l_digcut1 = 0
          #     END IF
 
          #     SELECT SUM(imq07/imq06_fac)
          #       INTO l_keyinyes #已登打的數量
          #       FROM imq_file,imr_file
          #      WHERE imq03 = g_imq[l_ac].imq03
          #        AND imq04 = g_imq[l_ac].imq04
          #        AND imrconf <> 'X' #作廢的不算 #FUN-660080
          #        AND imr01 = imq01
          #     IF cl_null(l_keyinyes) THEN
          #         LET l_keyinyes = 0
          #     END IF
          #     LET l_keyinyes = l_keyinyes - l_digcut1 #已登打數量 - 原本的  還料數量
          #     LET l_keyinyes = l_keyinyes + l_digcut  #已登打數量 + 當下那筆還料數量
          #     IF l_keyinyes > g_imq[l_ac].imp04 THEN
          #         LET l_keyinno = 0 #未登打數量
          #     ELSE
          #         LET l_keyinno = g_imq[l_ac].imp04 - l_keyinyes #未登打數量
          #     END IF
                        #借,還
          #     SELECT imp04,imp08 INTO l_imp04,l_imp08
          #       FROM imp_file
          #      WHERE imp01 = g_imq[l_ac].imq03
          #        AND imp02 = g_imq[l_ac].imq04
          #     #還>借
          #     IF l_imp08 >= l_imp04 THEN
          #         #借料數量已還清!
          #         CALL cl_err('','aim-116',1)
          #         NEXT FIELD imq03
          #     END IF
 
          #  #  已登打數量 > 借料數量
          #     IF l_keyinyes > l_imp04 THEN
          #         CALL cl_err('','aim-117',1)
          #         LET g_imq[l_ac].imq07 = g_imq_t.imq07
          #         NEXT FIELD imq07
          #     END IF
        #---------No.MOD-580069 add 判斷是否允許負庫存
          #     IF g_sma.sma894[5,5] = 'N' THEN
          #        SELECT img10 INTO l_img10 FROM img_file
          #            WHERE img01 = g_imq[l_ac].imq05
          #            AND img02 = g_imq[l_ac].imq08
          #            AND img03 = g_imq[l_ac].imq09
          #            AND img04 = g_imq[l_ac].imq10
          #         IF g_imq[l_ac].imq07 > l_img10 THEN
          #            CALL cl_err('','aim-406',1)
          #            NEXT FIELD imq08
          #         END IF
          #      END IF
 
          # END IF
          #FUN-BB0083---mark---end
         
        BEFORE FIELD imq23
           CALL t309_set_no_required()
 
        AFTER FIELD imq23  #第二單位
           IF cl_null(g_imq[l_ac].imq05) THEN NEXT FIELD imq05 END IF
           IF g_imq[l_ac].imq08 IS NULL OR g_imq[l_ac].imq09 IS NULL OR
              g_imq[l_ac].imq10 IS NULL THEN
              NEXT FIELD imq08
           END IF
           IF NOT cl_null(g_imq[l_ac].imq23) THEN
              CALL t309_unit(g_imq[l_ac].imq23)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD imq23
              END IF
              CALL s_du_umfchk(g_imq[l_ac].imq05,'','','',
                               g_img09,g_imq[l_ac].imq23,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imq[l_ac].imq23,g_errno,0)
                 NEXT FIELD imq23
              END IF
              LET g_imq[l_ac].imq24 = g_factor
              CALL s_chk_imgg(g_imq[l_ac].imq05,g_imq[l_ac].imq08,
                              g_imq[l_ac].imq09,g_imq[l_ac].imq10,
                              g_imq[l_ac].imq23) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN
                       NEXT FIELD imq23
                    END IF
                 END IF
                 CALL s_add_imgg(g_imq[l_ac].imq05,g_imq[l_ac].imq08,
                                 g_imq[l_ac].imq09,g_imq[l_ac].imq10,
                                 g_imq[l_ac].imq23,g_imq[l_ac].imq24,
                                 g_imr.imr01,
                                 g_imq[l_ac].imq02,0) RETURNING g_flag
                 IF g_flag = 1 THEN
                    NEXT FIELD imq23
                 END IF
              END IF
           END IF
           CALL t309_set_required()
           CALL cl_show_fld_cont()                   #No.FUN-560197
           #FUN-BB0083---add---str
           IF NOT cl_null(g_imq[l_ac].imq23) THEN
              IF NOT t309_imq25_check() THEN
                 LET g_imq23_t = g_imq[l_ac].imq23
                 NEXT FIELD imq25
              END IF
              LET g_imq23_t = g_imq[l_ac].imq23
           END IF
           #FUN-BB0083---add---end
 
        BEFORE FIELD imq25
           IF cl_null(g_imq[l_ac].imq05) THEN NEXT FIELD imq05 END IF
           IF g_imq[l_ac].imq08 IS NULL OR g_imq[l_ac].imq09 IS NULL OR
              g_imq[l_ac].imq10 IS NULL THEN
              NEXT FIELD imq10
           END IF
           IF NOT cl_null(g_imq[l_ac].imq23) AND g_ima906 = '3' THEN
              CALL s_du_umfchk(g_imq[l_ac].imq05,'','','',
                               g_img09,g_imq[l_ac].imq23,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imq[l_ac].imq23,g_errno,0)
                 NEXT FIELD imq08
              END IF
              LET g_imq[l_ac].imq24 = g_factor
              CALL s_chk_imgg(g_imq[l_ac].imq05,g_imq[l_ac].imq08,
                              g_imq[l_ac].imq09,g_imq[l_ac].imq10,
                              g_imq[l_ac].imq23) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN
                       NEXT FIELD imq05
                    END IF
                 END IF
                 CALL s_add_imgg(g_imq[l_ac].imq05,g_imq[l_ac].imq08,
                                 g_imq[l_ac].imq09,g_imq[l_ac].imq10,
                                 g_imq[l_ac].imq23,g_imq[l_ac].imq24,
                                 g_imr.imr01,
                                 g_imq[l_ac].imq02,0) RETURNING g_flag
                 IF g_flag = 1 THEN
                    NEXT FIELD imq05
                 END IF
              END IF
           END IF
 
        AFTER FIELD imq25  #第二數量
           #FUN-BB0083---add---str
           IF NOT t309_imq25_check() THEN
              NEXT FIELD imq25
           END IF            
           #FUN-BB0083---add---end
           #FUN-BB0083---mark---str
           #IF NOT cl_null(g_imq[l_ac].imq25) THEN
           #   IF g_imq[l_ac].imq25 < 0 THEN
           #      CALL cl_err('','aim-391',0)  #
           #      NEXT FIELD imq25
           #   END IF
           #   IF p_cmd = 'a' THEN
           #      IF g_ima906='3' THEN
           #         LET g_tot=g_imq[l_ac].imq25*g_imq[l_ac].imq24
           #         IF cl_null(g_imq[l_ac].imq22) OR g_imq[l_ac].imq22=0 THEN  #CHI-960022
           #            LET g_imq[l_ac].imq22=g_tot*g_imq[l_ac].imq21
           #            DISPLAY BY NAME g_imq[l_ac].imq22                       #CHI-960022
           #         END IF                                                     #CHI-960022
           #      END IF
           #   END IF
           #END IF
           #CALL cl_show_fld_cont()                   #No.FUN-560197
           #FUN-BB0083---mark---end
 
        BEFORE FIELD imq20
           CALL t309_set_no_required()
 
        AFTER FIELD imq20  #第一單位
           IF cl_null(g_imq[l_ac].imq05) THEN NEXT FIELD imq05 END IF
           IF g_imq[l_ac].imq08 IS NULL OR g_imq[l_ac].imq09 IS NULL OR
              g_imq[l_ac].imq10 IS NULL THEN
              NEXT FIELD imq10
           END IF
           IF NOT cl_null(g_imq[l_ac].imq20) THEN
              SELECT ima906 INTO g_ima906 FROM ima_file WHERE ima01=g_imq[l_ac].imq05  #TQC-7A0096
              CALL t309_unit(g_imq[l_ac].imq20)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD imq20
              END IF
              CALL s_du_umfchk(g_imq[l_ac].imq05,'','','',
                               g_imq[l_ac].imq06,g_imq[l_ac].imq20,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imq[l_ac].imq20,g_errno,0)
                 NEXT FIELD imq20
              END IF
              LET g_imq[l_ac].imq21 = g_factor
              IF g_ima906 = '2' THEN
                 CALL s_chk_imgg(g_imq[l_ac].imq05,g_imq[l_ac].imq08,
                                 g_imq[l_ac].imq09,g_imq[l_ac].imq10,
                                 g_imq[l_ac].imq20) RETURNING g_flag
                 IF g_flag = 1 THEN
                    IF g_sma.sma892[3,3] = 'Y' THEN
                       IF NOT cl_confirm('aim-995') THEN
                          NEXT FIELD imq20
                       END IF
                    END IF
                    CALL s_add_imgg(g_imq[l_ac].imq05,g_imq[l_ac].imq08,
                                    g_imq[l_ac].imq09,g_imq[l_ac].imq10,
                                    g_imq[l_ac].imq20,g_imq[l_ac].imq21,
                                    g_imr.imr01,
                                    g_imq[l_ac].imq02,0) RETURNING g_flag
                    IF g_flag = 1 THEN
                       NEXT FIELD imq20
                    END IF
                 END IF
              END IF
           END IF
           CALL t309_set_required()
           CALL cl_show_fld_cont()                   #No.FUN-560197
#FUN-A80106 add --start--
	         IF p_cmd = 'u' AND g_sma.sma115 = 'Y' THEN  #修改且多單位
              IF NOT cl_null(g_imq[l_ac].imq20) THEN
                 LET g_ima906 = NULL
                 SELECT ima906 INTO g_ima906 FROM ima_file
                  WHERE ima01 = g_imq[l_ac].imq05
                 IF NOT cl_null(g_ima906) AND g_ima906 MATCHES '[13]' THEN
                    IF g_imq_t.imq20 <> g_imq[l_ac].imq20 THEN
                       CALL t309_ind_icd_chk_icd()
                       IF NOT cl_null(g_errno) THEN
                          CALL cl_err('',g_errno,0)
                          LET g_imq[l_ac].imq20 = g_imq_t.imq20
                          NEXT FIELD imq20
                       END IF
                    END IF
                 END IF
              END IF
           END IF
#FUN-A80106 add --end--    
#FUN-BB0083---add---str
           IF NOT cl_null(g_imq[l_ac].imq20) THEN
              CALL t309_imq22_check() RETURNING l_case
              LET g_imq20_t = g_imq[l_ac].imq20
              CASE l_case
                 WHEN "imq06"
                    NEXT FIELD imq06
                 WHEN "imq08"
                    NEXT FIELD imq08
                 WHEN "imq22"
                    NEXT FIELD imq22
                 OTHERWISE EXIT CASE
              END CASE
           END IF  
#FUN-BB0083---add---end
 
        AFTER FIELD imq22  #第一數量
          #FUN-BB0083---add---str
          CALL t309_imq22_check() RETURNING l_case
          CASE l_case
             WHEN "imq06"
                NEXT FIELD imq06
             WHEN "imq08"
                NEXT FIELD imq08
             WHEN "imq22"
                NEXT FIELD imq22
             OTHERWISE EXIT CASE
          END CASE
          #FUN-BB0083---add---end
          #FUN-BB0083---mark---str
          #IF NOT cl_null(g_imq[l_ac].imq22) THEN
          #   IF g_imq[l_ac].imq22 < 0 THEN
          #      CALL cl_err('','aim-391',0)  #
          #      NEXT FIELD imq22
          #   END IF
          #END IF
          #CALL t309_du_data_to_correct()
          #CALL t309_set_origin_field()
          #CALL t309_unit(g_imq[l_ac].imq06)
          #IF NOT cl_null(g_errno) THEN
          #   CALL cl_err(g_imq[l_ac].imq06,g_errno,0)
          #   NEXT FIELD imq08
          #END IF
          #CALL s_umfchk(g_imq[l_ac].imq05,g_imq[l_ac].imp05,
          #              g_imq[l_ac].imq06)
          #     RETURNING g_cnt,g_imq[l_ac].imq06_fac
          #IF g_cnt = 1 THEN
          #   CALL cl_err('','mfg3075',0)
          #   NEXT FIELD imq06
          #END IF
          #IF g_imq[l_ac].imq07 = 0 THEN
          #    CALL cl_err('imq07','mfg1322',1)
          #    NEXT FIELD imq08
          #END IF
          #IF NOT cl_null(g_imq[l_ac].imq07) THEN
          #    LET g_imq[l_ac].imq07f = g_imq[l_ac].imq07 / g_imq[l_ac].imq06_fac
          #    #當下那筆還料數量
          #    LET l_digcut = g_imq[l_ac].imq07/g_imq[l_ac].imq06_fac
          #    CALL cl_digcut(l_digcut,3) RETURNING l_digcut
          #    IF cl_null(l_digcut) THEN
          #        LET l_digcut = 0
          #    END IF
          #
          #    #原本的還料數量
          #    LET l_digcut1 = g_imq_t.imq07/g_imq_t.imq06_fac
          #    CALL cl_digcut(l_digcut1,3) RETURNING l_digcut1
          #    IF cl_null(l_digcut1) THEN
          #        LET l_digcut1 = 0
          #    END IF
          #
          #    SELECT SUM(imq07/imq06_fac)
          #      INTO l_keyinyes #已登打的數量
          #      FROM imq_file,imr_file
          #     WHERE imq03 = g_imq[l_ac].imq03
          #       AND imq04 = g_imq[l_ac].imq04
          #       AND imrconf <> 'X' #作廢的不算 #FUN-660080
          #       AND imr01 = imq01
          #    IF cl_null(l_keyinyes) THEN
          #        LET l_keyinyes = 0
          #    END IF
          #    LET l_keyinyes = l_keyinyes - l_digcut1 #已登打數量 - 原本的  還料數量
          #    LET l_keyinyes = l_keyinyes + l_digcut  #已登打數量 + 當下那筆還料數量
          #    IF l_keyinyes > g_imq[l_ac].imp04 THEN
          #        LET l_keyinno = 0 #未登打數量
          #    ELSE
          #        LET l_keyinno = g_imq[l_ac].imp04 - l_keyinyes #未登打數量
          #    END IF
          #             #借,還
          #    SELECT imp04,imp08 INTO l_imp04,l_imp08
          #      FROM imp_file
          #     WHERE imp01 = g_imq[l_ac].imq03
          #       AND imp02 = g_imq[l_ac].imq04
          #    #還>借
          #    IF l_imp08 >= l_imp04 THEN
          #        #借料數量已還清!
          #        CALL cl_err('','aim-116',1)
          #        NEXT FIELD imq08
          #    END IF
          # 
          #    #  已登打數量 > 借料數量
          #    IF l_keyinyes > l_imp04 THEN
          #        CALL cl_err('','aim-117',1)
          #        LET g_imq[l_ac].imq07 = g_imq_t.imq07
          #        NEXT FIELD imq08
          #    END IF
          #END IF
          #FUN-BB0083---mark---end
        #FUN-CB0087---add---str---
        BEFORE FIELD imq26
           IF g_aza.aza115 = 'Y' AND cl_null(g_imq[l_ac].imq26) THEN
              CALL s_reason_code(g_imr.imr01,g_imq[l_ac].imq03,'',g_imq[l_ac].imq05,g_imq[l_ac].imq08,g_imr.imr03,g_imr.imr04) RETURNING g_imq[l_ac].imq26
              CALL t309_imq26()
              DISPLAY BY NAME g_imq[l_ac].imq26
           END IF

        AFTER FIELD imq26
           IF NOT t309_imq26_chk() THEN
              NEXT FIELD imq26
           ELSE
              CALL t309_imq26()
           END IF
        #FUN-CB0087---add---end---
 
        BEFORE DELETE                            #是否取消單身
            IF g_imq_t.imq02 > 0 AND
               g_imq_t.imq02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
#FUN-A80106 add --start--
             LET g_cnt = 0
             #出庫
             SELECT COUNT(*) INTO g_cnt FROM idb_file
              WHERE idb07 = g_imr.imr01
                AND idb08 = g_imq_t.imq02
             IF g_cnt > 0 THEN
                IF NOT cl_confirm('aic-112') THEN
                   CANCEL DELETE
                ELSE
                   LET g_cnt = 0
                   #出庫
                   CALL s_icdinout_del(-1,g_imr.imr01,g_imq_t.imq02,'')  #FUN-B80119--傳入p_plant參數''---
                        RETURNING l_flag
                   IF l_flag = 0 THEN
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF
                END IF
             END IF
#FUN-A80106 add --end--                  

#FUN-C50071 add begin-------------------------
                SELECT ima918,ima921 INTO g_ima918,g_ima921
                  FROM ima_file
                 WHERE ima01 = g_imq[l_ac].imq05
                   AND imaacti = "Y"

              IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                 IF NOT s_lot_del(g_prog,g_imr.imr01,g_imq[l_ac].imq02,0,g_imq[l_ac].imq05,'DEL') THEN
                    CALL cl_err3("del","rvbs_file",g_imr.imr01,g_imq_t.imq02,
                                  SQLCA.sqlcode,"","",1)
                      ROLLBACK WORK
                      CANCEL DELETE
                 END IF
              END IF
#FUN-C50071 add -end--------------------------
                DELETE FROM imq_file
                    WHERE imq01 = g_imr.imr01
                      AND imq02 = g_imq_t.imq02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","imq_file",g_imr.imr01,g_imq_t.imq02,
                                SQLCA.sqlcode,"","",1)  #No.FUN-660156
                    ROLLBACK WORK
                    CANCEL DELETE
                #FUN-B30187 -START--
                ELSE 
                   IF NOT s_del_imqi(g_imr.imr01,g_imq_t.imq02,'') THEN
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF
                #FUN-B30187 -END--
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
#FUN-C50071 add begin-------------------------
            ELSE
                SELECT ima918,ima921 INTO g_ima918,g_ima921
                  FROM ima_file
                 WHERE ima01 = g_imq[l_ac].imq05
                   AND imaacti = "Y"

                IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                   IF NOT s_lot_del(g_prog,g_imr.imr01,g_imq[l_ac].imq02,0,g_imq[l_ac].imq05,'DEL') THEN
                      CALL cl_err3("del","rvbs_file",g_imr.imr01,g_imq_t.imq02,
                                    SQLCA.sqlcode,"","",1)
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF
                END IF
#FUN-C50071 add -end--------------------------
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_imq[l_ac].* = g_imq_t.*
               CLOSE t309_bcl
               CLOSE t309_bcl_ind   #FUN-B30187
               ROLLBACK WORK
               EXIT INPUT
            END IF
#FUN-A80106 add --start--
            IF cl_null(g_imq_t.imq09) THEN LET g_imq_t.imq09 = ' ' END IF
            IF cl_null(g_imq_t.imq10) THEN LET g_imq_t.imq10 = ' ' END IF
            IF cl_null(g_imq[l_ac].imq09) THEN
               #LET g_imq[l_ac].imq10 = ' '  #FUN-C30302
               LET g_imq[l_ac].imq09 = ' '#FUN-C30302
            END IF
            IF cl_null(g_imq[l_ac].imq10) THEN
               LET g_imq[l_ac].imq10 = ' '
            END IF
            IF g_imq_t.imq02 <> g_imq[l_ac].imq02 OR
               g_imq_t.imq05 <> g_imq[l_ac].imq05 OR
               g_imq_t.imq08 <> g_imq[l_ac].imq08 OR
               g_imq_t.imq09 <> g_imq[l_ac].imq09 OR
               g_imq_t.imq10 <> g_imq[l_ac].imq10 OR
               g_imq_t.imq06 <> g_imq[l_ac].imq06 THEN
               CALL t309_ind_icd_chk_icd()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD imq05
               END IF
            END IF
#FUN-A80106 add --end--               

#FUN-C50071 add begin-------------------------
            SELECT ima918,ima921 INTO g_ima918,g_ima921
              FROM ima_file
             WHERE ima01 = g_imq[l_ac].imq05
               AND imaacti = "Y"

            IF (g_ima918 = 'Y' OR g_ima921 = 'Y') AND g_imq[l_ac].imq15 = 'N'
               AND (g_imq[l_ac].imq07 <> g_imq_t.imq07 OR cl_null(g_imq_t.imq07)) THEN
               LET g_success = 'Y'
               LET g_img09 = ''

               SELECT img09 INTO g_img09 FROM img_file
                  WHERE img01 = g_imq[l_ac].imq05
                    AND img02 = g_imq[l_ac].imq08
                    AND img03 = g_imq[l_ac].imq09
                    AND img04 = g_imq[l_ac].imq10

               CALL s_umfchk(g_imq[l_ac].imq05,g_imq[l_ac].imq06,g_img09)
                  RETURNING l_i,l_fac
               IF l_i = 1 THEN LET l_fac = 1 END IF

               CALL s_mod_lot(g_prog,g_imr.imr01,g_imq[l_ac].imq02,0,
                             g_imq[l_ac].imq05,g_imq[l_ac].imq08,
                             g_imq[l_ac].imq09,g_imq[l_ac].imq10,
                             g_imq[l_ac].imq06,g_img09,
                             g_imq[l_ac].imq06_fac,g_imq[l_ac].imq07,'','MOD',-1)
                  RETURNING l_r,g_qty
               IF l_r = "Y" THEN
                  LET g_imq[l_ac].imq07 = g_qty
               END IF
            END IF
#FUN-C50071 add -end--------------------------

            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_imq[l_ac].imq02,-263,1)
               LET g_imq[l_ac].* = g_imq_t.*
            ELSE
                IF g_imq[l_ac].imq09 IS NULL THEN
                    LET g_imq[l_ac].imq09 = ' '
                END IF
                IF g_imq[l_ac].imq10 IS NULL THEN
                    LET g_imq[l_ac].imq10 = ' '
                END IF
                IF g_sma.sma115 = 'Y' THEN
                   CALL s_chk_va_setting(g_imq[l_ac].imq05)
                        RETURNING g_flag,g_ima906,g_ima907
                   IF g_flag=1 THEN
                      NEXT FIELD imp03
                   END IF
                   CALL t309_du_data_to_correct()
                END IF
                CALL t309_set_origin_field()

#FUN-C50071 add begin-------------------------
                LET g_success = 'Y'
                IF s_chk_rvbs('',g_imq[l_ac].imq05) THEN
                   CALL t309_rvbs()
                END IF
                IF g_success = 'N' THEN
                   NEXT FIELD imq02
                END IF
#FUN-C50071 add -end--------------------------

#FUN-A80106 add --start--
               #   料號為參考單位,單一單位,且狀態為其它段生產料號
               #   (imaicd04=3,4)時,將單位一的資料給單位二
               CALL t309_ind_icd_set_value()
#FUN-A80106 add --end--
                LET g_success = 'Y'   #FUN-B30187                 
                UPDATE imq_file SET
                       imq02=g_imq[l_ac].imq02,
                       imq03=g_imq[l_ac].imq03,
                       imq04=g_imq[l_ac].imq04,
                       imq05=g_imq[l_ac].imq05,
                       imq06=g_imq[l_ac].imq06,
                   imq06_fac=g_imq[l_ac].imq06_fac,
                       imq07=g_imq[l_ac].imq07,
                       imq08=g_imq[l_ac].imq08,
                       imq09=g_imq[l_ac].imq09,
                       imq10= g_imq[l_ac].imq10,
                       imq20= g_imq[l_ac].imq20,
                       imq21= g_imq[l_ac].imq21,
                       imq22= g_imq[l_ac].imq22,
                       imq26= g_imq[l_ac].imq26,  #FUN-CB0087
                       imq23= g_imq[l_ac].imq23,
                       imq24= g_imq[l_ac].imq24,
                       imq25= g_imq[l_ac].imq25,
                       imq15= g_imq[l_ac].imq15   #No.FUN-5C0077
                 WHERE imq01=g_imr.imr01
                   AND imq02=g_imq_t.imq02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","imq_file",g_imr.imr01,g_imq_t.imq02,
                                 SQLCA.sqlcode,"","upd",1)  #No.FUN-660156
                    LET g_imq[l_ac].* = g_imq_t.*
                    LET g_success = 'N'   #FUN-B30187
                #FUN-B30187 --START--            
                ELSE                   
                   UPDATE imqi_file SET 
                          imqi02=g_imq[l_ac].imq02,
                          imqiicd028=g_imq[l_ac].imqiicd028,
                          imqiicd029=g_imq[l_ac].imqiicd029
                           WHERE imqi01=g_imr.imr01 AND imqi02=g_imq_t.imq02
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","imqi_file",g_imr.imr01,g_imq_t.imq02,
                      SQLCA.sqlcode,"","upd imqi",1) 
                      LET g_imq[l_ac].* = g_imq_t.*
                      LET g_success = 'N'
                   END IF
                #FUN-B30187 --END--
                END IF

                IF g_success = 'Y' THEN   #FUN-B30187
                   MESSAGE 'UPDATE O.K'
                    COMMIT WORK
#FUN-A80106 add --start--
                    LET l_act = 'u'
#FUN-A80106 add --end--                 
                END IF  
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac       #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
#FUN-C50071 add begin-------------------------
               IF p_cmd = 'a' AND l_ac <= g_imq.getLength() THEN
                  SELECT ima918,ima921 INTO g_ima918,g_ima921
                    FROM ima_file
                   WHERE ima01 = g_imq[l_ac].imq05
                     AND imaacti = "Y"

                  IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                     IF NOT s_lot_del(g_prog,g_imr.imr01,g_imq[l_ac].imq02,0,g_imq[l_ac].imq05,'DEL') THEN
                        CALL cl_err3("del","rvbs_file",g_imr.imr01,g_imq_t.imq02,
                                      SQLCA.sqlcode,"","",1)
                     END IF
                  END IF
                  #FUN-D40030--add--str--
                  CALL g_imq.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
                  #FUN-D40030--add--end--
               END IF
#FUN-C50071 add -end--------------------------
               IF p_cmd='u' THEN
                  LET g_imq[l_ac].* = g_imq_t.*
               END IF
               LET l_ac_t = l_ac       #FUN-D40030 Add
               CLOSE t309_bcl
               CLOSE t309_bcl_ind   #FUN-B30187
               ROLLBACK WORK
               EXIT INPUT
            ELSE
               IF l_ac <= g_rec_b THEN               #MOD-B60151 add
                  IF g_imq[l_ac].imq07 < 0 THEN
                     CALL cl_err('','aec-020',1)
                     NEXT FIELD imq07
                  END IF
               END IF                                #MOD-B60151 add
            END IF
            CLOSE t309_bcl
            CLOSE t309_bcl_ind   #FUN-B30187
            COMMIT WORK
            
#FUN-A80106 add --start--
            IF NOT cl_null(l_act) AND l_act MATCHES '[au]' THEN
               #FUN-BA0051 --START mark--
               #LET l_imaicd08 = NULL
               #SELECT l_imaicd08 INTO l_imaicd08 FROM imaicd_file
               # WHERE imaicd00 = g_imq[l_ac].imq05
               #IF NOT cl_null(l_imaicd08) AND l_imaicd08 = 'Y' THEN
               #FUN-BA0051 --END mark--
               IF s_icdbin(g_imq[l_ac].imq05) THEN   #FUN-BA0051
                  #出庫
                  IF cl_confirm('aic-312') THEN
                     LET g_dies = 0
                     CALL s_icdout(g_imq[l_ac].imq05,
                                   g_imq[l_ac].imq08,
                                   g_imq[l_ac].imq09,
                                   g_imq[l_ac].imq10,
                                   g_imq[l_ac].imq06,
                                   g_imq[l_ac].imq07,
                                   g_imr.imr01,g_imq[l_ac].imq02,
                                   g_imr.imr02,
                                   'N','','','','')
                          RETURNING g_dies,l_r,l_qty   #FUN-C30302
                     #FUN-C30302---begin
                     IF l_r = 'Y' THEN
                         LET l_qty = s_digqty(l_qty,g_imq[l_ac].imq06) 
                         LET g_imq[l_ac].imq07 = l_qty
                         LET g_imq[l_ac].imq22 = l_qty
                         LET g_imq[l_ac].imq07f = g_imq[l_ac].imq07 / g_imq[l_ac].imq06_fac
                         
                         UPDATE imq_file set imq07 = g_imq[l_ac].imq07,imq22 = g_imq[l_ac].imq22
                          WHERE imq01=g_imr.imr01 AND imq02=g_imq[l_ac].imq02
                         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                            LET g_imq[l_ac].imq07 = b_imq.imq07
		                    LET g_imq[l_ac].imq22 = b_imq.imq22
                            LET g_success = 'N'
                         ELSE
                            LET b_imq.imq07 = g_imq[l_ac].imq07
		                    LET b_imq.imq22 = g_imq[l_ac].imq22                
                         END IF
                         DISPLAY BY NAME g_imq[l_ac].imq07, g_imq[l_ac].imq22,g_imq[l_ac].imq07f
                     END IF 
                     #FUN-C30302---end
                     CALL t309_ind_icd_upd_dies()
                  END IF
               END IF
            END IF
#FUN-A80106 add --end--             

#FUN-C50071 add begin-------------------------
       AFTER INPUT
            #FUN-CB0087---add---str---
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            #FUN-CB0087---add---end---
            LET g_cnt = 0
            SELECT COUNT(*) INTO g_cnt FROM imq_file WHERE imq01=g_imr.imr01
            FOR l_ac=1 TO g_cnt
              SELECT ima918,ima921 INTO g_ima918,g_ima921
                FROM ima_file
               WHERE ima01 = g_imq[l_ac].imq05
                 AND imaacti = "Y"

              IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
              UPDATE rvbs_file SET rvbs021=g_imq[l_ac].imq05
               WHERE rvbs00= g_prog
                 AND rvbs01= g_imr.imr01
                 AND rvbs02= g_imq[l_ac].imq02
              END IF
            END FOR
#FUN-C50071 add -end--------------------------
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(imq03) #借料單號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_imp2"   #FUN-4A0073
                    CALL cl_create_qry() RETURNING g_imq[l_ac].imq03
                     DISPLAY BY NAME g_imq[l_ac].imq03,g_imq[l_ac].imq04  #No.MOD-490371
                    NEXT FIELD imq03
               WHEN INFIELD(imq04) #借料項次
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_imp3"   #FUN-4A0073
                    LET g_qryparam.arg1 = g_imq[l_ac].imq03
                    CALL cl_create_qry() RETURNING g_imq[l_ac].imq04
                     DISPLAY BY NAME g_imq[l_ac].imq03,g_imq[l_ac].imq04  #No.MOD-490371
                    NEXT FIELD imq04
               WHEN INFIELD(imq06) #還料單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.default1 = g_imq[l_ac].imq06
                    CALL cl_create_qry() RETURNING g_imq[l_ac].imq06
                    DISPLAY BY NAME g_imq[l_ac].imq06      #No.MOD-490371
                   NEXT FIELD imq06
               WHEN INFIELD(imq08) OR INFIELD(imq09) OR INFIELD(imq10)
                  #FUN-C30300---begin
                  LET g_ima906 = NULL
                  SELECT ima906 INTO g_ima906 FROM ima_file
                   WHERE ima01 = g_imq[l_ac].imq05
                  #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                  IF s_industry("icd") THEN  #TQC-C60028
                     CALL q_idc(FALSE,TRUE,g_imq[l_ac].imq05,'',
                               g_imq[l_ac].imq09,g_imq[l_ac].imq10)
                     RETURNING g_imq[l_ac].imq08,
                               g_imq[l_ac].imq09,g_imq[l_ac].imq10
                  ELSE
                 #FUN-C30300---end
                    CALL q_img4(FALSE,TRUE,g_imq[l_ac].imq05,'',g_imq[l_ac].imq09,  ##NO.FUN-660085    #No.TQC-750022
                                   g_imq[l_ac].imq10,'A')
                    RETURNING    g_imq[l_ac].imq08,
                                      g_imq[l_ac].imq09,g_imq[l_ac].imq10
                  END IF #FUN-C30300                  
                    IF cl_null(g_imq[l_ac].imq09) THEN LET g_imq[l_ac].imq09 = ' ' END IF
                    IF cl_null(g_imq[l_ac].imq10) THEN LET g_imq[l_ac].imq10 = ' ' END IF
                    DISPLAy g_imq[l_ac].imq08 TO imq08
                    DISPLAy g_imq[l_ac].imq09 TO imq09
                    DISPLAy g_imq[l_ac].imq10 TO imq10
                    CALL t309_def_imqiicd029()   #FUN-B30187
                    IF INFIELD(imq08) THEN NEXT FIELD imq08 END IF
                    IF INFIELD(imq09) THEN NEXT FIELD imq09 END IF
                    IF INFIELD(imq10) THEN NEXT FIELD imq10 END IF
                WHEN INFIELD(imq23) #單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_imq[l_ac].imq23
                     CALL cl_create_qry() RETURNING g_imq[l_ac].imq23
                     NEXT FIELD imq23
                WHEN INFIELD(imq20) #單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_imq[l_ac].imq20
                     CALL cl_create_qry() RETURNING g_imq[l_ac].imq20
                     NEXT FIELD imq20
               WHEN INFIELD(imq930)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gem4"
                  CALL cl_create_qry() RETURNING g_imq[l_ac].imq930
                  DISPLAY BY NAME g_imq[l_ac].imq930
                  NEXT FIELD imq930              
               #FUN-CB0087---add---str---
               WHEN INFIELD(imq26)
                  CALL s_get_where(g_imr.imr01,g_imq[l_ac].imq03,'',g_imq[l_ac].imq05,g_imq[l_ac].imq08,g_imr.imr03,g_imr.imr04) RETURNING l_flag1,l_where
                  IF g_aza.aza115='Y' AND l_flag1 THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     ="q_ggc08"
                     LET g_qryparam.where = l_where
                     LET g_qryparam.default1 = g_imq[l_ac].imq26
                  ELSE
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     ="q_azf41"
                     LET g_qryparam.default1 = g_imq[l_ac].imq26
                  END IF
                  CALL cl_create_qry() RETURNING g_imq[l_ac].imq26
                  DISPLAY BY NAME g_imq[l_ac].imq26
                  CALL t309_imq26()
                  NEXT FIELD imq26 
               #FUN-CB0087---add---end---
               OTHERWISE EXIT CASE
            END CASE
 
      ON ACTION mntn_stock #建立倉庫別
                   LET g_cmd = 'aimi200 x'
                   CALL cl_cmdrun(g_cmd)
 
      ON ACTION mntn_loc  #建立儲位別
                   LET g_cmd = "aimi201 '",g_imq[l_ac].imq09,"'" #BugNo:6598
                   CALL cl_cmdrun(g_cmd)
      ON ACTION mntn_unit #單位換算
                  CALL cl_cmdrun("aooi103 ")
 
       ON ACTION qry_warehouse #預設倉庫/ 儲位
                   #No.FUN-AB0067--begin
                   #CALL cl_init_qry_var()
                   #LET g_qryparam.form = "q_imd"
                   #LET g_qryparam.default1 = g_imq[l_ac].imq08
                   #LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                   #CALL cl_create_qry() RETURNING g_imq[l_ac].imq08
                   CALL q_imd_1(FALSE,TRUE,g_imq[l_ac].imq08,"","","","") RETURNING g_imq[l_ac].imq08
                   #No.FUN-AB0067--end
                   NEXT FIELD imq08
#FUN-A80106 add --start--
        ON ACTION aic_s_icdqry #刻號/BIN號查詢作業
           IF NOT cl_null(g_imq[l_ac].imq02) THEN
              CALL s_icdqry(-1,g_imr.imr01,g_imq[l_ac].imq02,
                            g_imr.imrpost,g_imq[l_ac].imq05)
           END IF
#FUN-A80106 add --end--                     

#FUN-C50071 add begin-------------------------
        ON ACTION modi_lot
           SELECT ima918,ima921 INTO g_ima918,g_ima921
             FROM ima_file
            WHERE ima01 = g_imq[l_ac].imq05
              AND imaacti = "Y"

           IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
              LET g_img09 = ''   LET g_img10 = 0

              SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
               WHERE img01 = g_imq[l_ac].imq05
                 AND img02 = g_imq[l_ac].imq08
                 AND img03 = g_imq[l_ac].imq09
                 AND img04 = g_imq[l_ac].imq10

              CALL s_umfchk(g_imq[l_ac].imq05,g_imq[l_ac].imq06,g_img09)
                 RETURNING l_i,l_fac
              IF l_i = 1 THEN LET l_fac = 1 END IF

              CALL s_mod_lot(g_prog,g_imr.imr01,g_imq[l_ac].imq02,0,
                            g_imq[l_ac].imq05,g_imq[l_ac].imq08,
                            g_imq[l_ac].imq09,g_imq[l_ac].imq10,
                            g_imq[l_ac].imq06,g_img09,
                            g_imq[l_ac].imq06_fac,g_imq[l_ac].imq07,'','MOD',-1)
                 RETURNING l_r,g_qty
                 IF l_r = "Y" THEN
                    LET g_imq[l_ac].imq07 = g_qty
                 END IF
           END IF
#FUN-C50071 add -end--------------------------
 
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
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
    END INPUT
 
    LET g_imr.imrmodu = g_user
    LET g_imr.imrdate = g_today
    UPDATE imr_file SET imrmodu = g_imr.imrmodu,imrdate = g_imr.imrdate
     WHERE imr01 =  g_imr.imr01
    DISPLAY BY NAME g_imr.imrmodu,g_imr.imrdate
 
    CLOSE t309_bcl
    CLOSE t309_bcl_ind   #FUN-B30187
    COMMIT WORK
#   CALL t309_delall()     #CHI-C30002 mark
    CALL t309_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t309_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_imr.imr01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM imr_file ",
                  "  WHERE imr01 LIKE '",l_slip,"%' ",
                  "    AND imr01 > '",g_imr.imr01,"'"
      PREPARE t309_pb1 FROM l_sql 
      EXECUTE t309_pb1 INTO l_cnt
      
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
        #CALL t309_x()    #CHI-D20010
         CALL t309_x(1)   #CHI-D20010 
         IF g_imr.imrconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_imr.imrconf,"",g_imr.imrpost,"",g_void,"")
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM imr_file WHERE imr01 = g_imr.imr01
         INITIALIZE  g_imr.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t309_delall()
#   SELECT COUNT(*) INTO g_cnt FROM imq_file
#       WHERE imq01 = g_imr.imr01
#   IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
#      IF cl_confirm('9042') THEN #CHI-A90020 add
#        #CALL cl_getmsg('9044',g_lang) RETURNING g_msg #CHI-A90020 mark
#        #ERROR g_msg CLIPPED #CHI-A90020 mark
#        DELETE FROM imr_file WHERE imr01 = g_imr.imr01
#        CLEAR FORM
#        CALL g_imq.clear()
#      END IF #CHI-A90020 add
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t309_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
    CONSTRUCT g_wc2 ON imq02,imq03,imq04,imq05,imq08,imq09,imq10,
                       imq06,imq07
                                            # 螢幕上取單身條件
         FROM s_imq[1].imq02,s_imq[1].imq03,s_imq[1].imq04,
              s_imq[1].imq05,s_imq[1].imq08,s_imq[1].imq09,
              s_imq[1].imq10,s_imq[1].imq06,s_imq[1].imq07
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
    CALL t309_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t309_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(500)
 
    IF cl_null(p_wc2) THEN
        LET p_wc2 = " 1=1"
    END IF
    LET g_sql =
        "SELECT imq02,imq03 ,imq04,imp03,'', ",
        "       imp05,imp23,imp25,imp20,imp22,",
         "       imq05 ,'',imq08,imq09 ,imq10,imq06,imp04 , ",  #No.MOD-480396
        "       imq07,imq23,imq24,imq25,imq20,imq21,imq22,imq26,azf03,'',imq06_fac,imq15,imq930,'' ",  #No.FUN-5C0077  #FUN-670093  #FUN-CB0087 add>imq22后加imq26,azf03
        "       ,'','' ",   #FUN-B30187        
        #"  FROM imq_file, imp_file,imr_file",     #FUN-CB0087 mark
        "  FROM imq_file LEFT OUTER JOIN azf_file ON imq26 = azf01 AND azf02='2',imp_file,imr_file",  #FUN-CB0087 add
        " WHERE imq01 ='",g_imr.imr01,"'", #單頭
        "   AND imq03 = imp01 ",
        "   AND imq04 = imp02 ",
        "   AND ",p_wc2 CLIPPED,           #單身
        "   AND imr00 = '1' ",#原數償還
        "   AND imr01 = imq01",
        " ORDER BY imq02,imq03,imq04"

    #FUN-B30187 --START--
    LET g_sql =
        "SELECT imq02,imq03 ,imq04,imp03,'', ",
        "       imp05,imp23,imp25,imp20,imp22,",
        "       imq05 ,'',imq08,imq09 ,imq10,imq06,imp04 , ",  
        "       imq07,imq23,imq24,imq25,imq20,imq21,imq22,imq26,azf03,'',imq06_fac,imq15,imq930,'', ",   #FUN-CB0087 add>imq26,azf03
        "       imqiicd028,imqiicd029 ",   
        #"  FROM imq_file, imp_file,imr_file,imqi_file",     #FUN-CB0087 mark
        "  FROM imq_file LEFT OUTER JOIN azf_file ON imq26 = azf01 AND azf02='2',imp_file,imr_file,imqi_file",  #FUN-CB0087 add
        "  WHERE imq01 ='",g_imr.imr01,"'", #單頭
        "   AND imq03 = imp01 ",
        "   AND imq04 = imp02 ",
        "   AND ",p_wc2 CLIPPED,           #單身
        "   AND imr00 = '1' ",#原數償還
        "   AND imr01 = imq01",
        "   AND imq01 = imqi01",
        "   AND imq02 = imqi02",
        " ORDER BY imq02,imq03,imq04"                 
    #FUN-B30187 --END--
        
    PREPARE t309_pb FROM g_sql
    DECLARE imq_curs                       #CURSOR
        CURSOR FOR t309_pb
 
    CALL g_imq.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH imq_curs INTO g_imq[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT ima02 INTO g_imq[g_cnt].ima02s
          FROM ima_file
         WHERE ima01 = g_imq[g_cnt].imp03
 
        SELECT ima02 INTO g_imq[g_cnt].ima02e
          FROM ima_file
         WHERE ima01 = g_imq[g_cnt].imq05
 
        LET g_imq[g_cnt].imq07f = g_imq[g_cnt].imq07 / g_imq[g_cnt].imq06_fac
        LET g_imq[g_cnt].gem02c=s_costcenter_desc(g_imq[g_cnt].imq930) #FUN-670093
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_imq.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 #FUN-C50071 add begin-------------------------
    LET g_sql = " SELECT rvbs02,rvbs021,ima02,ima021,rvbs022,rvbs04,rvbs03,rvbs05,rvbs06,rvbs07,rvbs08",
                "   FROM rvbs_file LEFT JOIN ima_file ON rvbs021 = ima01",
                "  WHERE rvbs00 = '",g_prog,"' AND rvbs01 = '",g_imr.imr01,"'"
    PREPARE sel_rvbs_pre FROM g_sql
    DECLARE rvbs_curs CURSOR FOR sel_rvbs_pre

    CALL g_rvbs.clear()

    LET g_cnt = 1
    FOREACH rvbs_curs INTO g_rvbs[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rvbs.deleteElement(g_cnt)
    LET g_rec_b1 = g_cnt - 1
  #FUN-C50071 add -end--------------------------
END FUNCTION
 
FUNCTION t309_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
#FUN-C50071 add begin-------------------------
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_imq TO s_imq.* ATTRIBUTE(COUNT=g_rec_b)

         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

         AFTER DISPLAY
               CONTINUE DIALOG   #因為外層是DIALOG
      END DISPLAY

      DISPLAY ARRAY g_rvbs TO s_rvbs.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()

         AFTER DISPLAY
            CONTINUE DIALOG   #因為外層是DIALOG
      END DISPLAY

      #FUN-D10081---add---str---
      ON ACTION page_list 
         LET g_action_flag="page_list"
         EXIT DIALOG
      #FUN-D10081---add---end---
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG
      ON ACTION first
         CALL t309_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t309_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t309_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t309_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t309_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG
      ON ACTION output
         LET g_action_choice="output"
         EXIT DIALOG
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL t309_mu_ui()   #FUN-610067
         IF g_imr.imrconf = 'X' THEN #FUN-660080
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_imr.imrconf,"",g_imr.imrpost,"",g_void,"") #FUN-660080
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DIALOG
    #@ON ACTION 過帳
      ON ACTION post
         LET g_action_choice="post"
         EXIT DIALOG
    #@ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DIALOG
    #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG
      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG 
      #CHI-D20010---end
#FUN-A80106 add --start--
    #@ON ACTION 單據刻號BIN查詢作業
      ON ACTION aic_s_icdqry
         LET g_action_choice = "aic_s_icdqry"
         EXIT DIALOG
 
    #@ON ACTION 單據刻號BIN明細維護作業
      ON ACTION aic_s_icdout
         LET g_action_choice = "aic_s_icdout"
         EXIT DIALOG
#FUN-A80106 add --end--          
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
    #@ON ACTION 拋轉至SPC
      ON ACTION trans_spc                     
         LET g_action_choice="trans_spc"
         EXIT DIALOG
 
      ON ACTION related_document                #No.FUN-680046  相關文件
         LET g_action_choice="related_document"          
         EXIT DIALOG  
 
      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DIALOG

     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
   
      &include "qry_string.4gl"
    END DIALOG
#FUN-C50071 add -end--------------------------

#FUN-C50071 mark -begin--------------------------
#  DISPLAY ARRAY g_imq TO s_imq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
#
#     BEFORE DISPLAY
#        CALL cl_navigator_setting( g_curs_index, g_row_count )
#
#     BEFORE ROW
#        LET l_ac = ARR_CURR()
#     CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#
#     ON ACTION insert
#        LET g_action_choice="insert"
#        EXIT DISPLAY
#     ON ACTION query
#        LET g_action_choice="query"
#        EXIT DISPLAY
#     ON ACTION delete
#        LET g_action_choice="delete"
#        EXIT DISPLAY
#     ON ACTION modify
#        LET g_action_choice="modify"
#        EXIT DISPLAY
#     ON ACTION first
#        CALL t309_fetch('F')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#          IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
#          END IF
#          ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#
#     ON ACTION previous
#        CALL t309_fetch('P')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#          IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
#          END IF
#       ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#
#     ON ACTION jump
#        CALL t309_fetch('/')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#          IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
#          END IF
#       ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#
#     ON ACTION next
#        CALL t309_fetch('N')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#          IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
#          END IF
#       ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#
#     ON ACTION last
#        CALL t309_fetch('L')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#          IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
#          END IF
#       ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#
#     ON ACTION detail
#        LET g_action_choice="detail"
#        LET l_ac = 1
#        EXIT DISPLAY
#     ON ACTION output
#        LET g_action_choice="output"
#        EXIT DISPLAY
#     ON ACTION help
#        LET g_action_choice="help"
#        EXIT DISPLAY
#
#     ON ACTION locale
#        CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        CALL t309_mu_ui()   #FUN-610067
#        IF g_imr.imrconf = 'X' THEN #FUN-660080
#           LET g_void = 'Y'
#        ELSE
#           LET g_void = 'N'
#        END IF
#        CALL cl_set_field_pic(g_imr.imrconf,"",g_imr.imrpost,"",g_void,"") #FUN-660080
#        EXIT DISPLAY
#
#     ON ACTION exit
#        LET g_action_choice="exit"
#        EXIT DISPLAY
#     ON ACTION controlg
#        LET g_action_choice="controlg"
#        EXIT DISPLAY
#   #@ON ACTION 確認
#     ON ACTION confirm
#        LET g_action_choice="confirm"
#        EXIT DISPLAY
#   #@ON ACTION 取消確認
#     ON ACTION undo_confirm
#        LET g_action_choice="undo_confirm"
#        EXIT DISPLAY
#   #@ON ACTION 過帳
#     ON ACTION post
#        LET g_action_choice="post"
#        EXIT DISPLAY
#   #@ON ACTION 過帳還原
#     ON ACTION undo_post
#        LET g_action_choice="undo_post"
#        EXIT DISPLAY
#   #@ON ACTION 作廢
#     ON ACTION void
#        LET g_action_choice="void"
#        EXIT DISPLAY
##FUN-A80106 add --start--
#&ifdef ICD
#   #@ON ACTION 單據刻號BIN查詢作業
#     ON ACTION aic_s_icdqry
#        LET g_action_choice = "aic_s_icdqry"
#        EXIT DISPLAY
#
#   #@ON ACTION 單據刻號BIN明細維護作業
#     ON ACTION aic_s_icdout
#        LET g_action_choice = "aic_s_icdout"
#        EXIT DISPLAY
#&endif
##FUN-A80106 add --end--          
#     ON ACTION accept
#        LET g_action_choice="detail"
#        LET l_ac = ARR_CURR()
#        EXIT DISPLAY
#
#     ON ACTION cancel
#            LET INT_FLAG=FALSE 		#MOD-570244	mars
#        LET g_action_choice="exit"
#        EXIT DISPLAY
#
#     ON ACTION exporttoexcel #FUN-4B0002
#        LET g_action_choice = 'exporttoexcel'
#        EXIT DISPLAY
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     AFTER DISPLAY
#        CONTINUE DISPLAY
#
#   #@ON ACTION 拋轉至SPC
#     ON ACTION trans_spc                     
#        LET g_action_choice="trans_spc"
#        EXIT DISPLAY
#
#     ON ACTION related_document                #No.FUN-680046  相關文件
#        LET g_action_choice="related_document"          
#        EXIT DISPLAY  
#
#    ON ACTION controls                                                                                                             
#        CALL cl_set_head_visible("","AUTO")                                                                                        
#  
#     &include "qry_string.4gl"
#   END DISPLAY
#FUN-C50071 mark --end---------------------------
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
#取得該倉庫/ 儲位的相關數量資料
FUNCTION t309_imq10_a()
 
    LET g_errno=' ' LET g_desc=' '
    SELECT img09,img23,img24,img21
      INTO g_imq[l_ac].imq06,g_img23,g_img24,g_img21
      FROM img_file
     WHERE img01=g_imq[l_ac].imq05
       AND img02=g_imq[l_ac].imq08
       AND img03=g_imq[l_ac].imq09
       AND img04=g_imq[l_ac].imq10
 
     CASE WHEN SQLCA.SQLCODE=100  LET g_errno ='apm-259' #此料號之倉儲批不存在!
                                  LET g_desc  ='尚未存在之倉庫/儲位/批號'
          OTHERWISE               LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     DISPLAY g_imq[l_ac].imq06 TO s_imq[l_ac].imq06
     CALL s_umfchk(g_imq[l_ac].imq05,g_imq[l_ac].imp05,g_imq[l_ac].imq06)
               RETURNING g_cnt,g_imq[l_ac].imq06_fac
     IF cl_null(g_imq[l_ac].imq06_fac) THEN
         LET g_imq[l_ac].imq06_fac = 1
     END IF
     LET g_imq[l_ac].imq07f = g_imq[l_ac].imq07 / g_imq[l_ac].imq06_fac
     DISPLAY BY NAME g_imq[l_ac].imq06_fac
     DISPLAY BY NAME g_imq[l_ac].imq07f
END FUNCTION
 
#檢查單位是否存在於單位檔中
FUNCTION t309_unit(p_key)
    DEFINE p_key     LIKE gfe_file.gfe01,
           l_gfe02   LIKE gfe_file.gfe02,
           l_gfeacti LIKE gfe_file.gfeacti
 
    LET g_errno = ' '
    SELECT gfe02,gfeacti
           INTO l_gfe02,l_gfeacti
           FROM gfe_file WHERE gfe01 = p_key
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2605'
                            LET l_gfe02 = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
#--------------------------------------------------------------------#
#更新相關的檔案
#--------------------------------------------------------------------#
FUNCTION t309_t()
DEFINE
    l_n         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    l_qty       LIKE img_file.img08,
    l_img09     LIKE img_file.img09,
    l_imq06_fac LIKE imq_file.imq06_fac,
    l_cnt       LIKE type_file.num5     #No.FUN-690026 SMALLINT
DEFINE l_ima01  LIKE ima_file.ima01     #No.TQC-930155 
#FUN-A80106 add --start--
  DEFINE l_flag   LIKE type_file.num5   #判斷s_icdpost()成功/失敗
#FUN-A80106 add --end--
 
    LET l_qty = b_imq.imq07 #還料數量
    IF cl_null(l_qty) THEN LET g_success='N' RETURN END IF
    #FUN-C80107 add begin---------------------------------------121024
    SELECT * FROM img_file
     WHERE img01=g_imq[l_ac].imq05 AND img02=g_imq[l_ac].imq08
       AND img03=g_imq[l_ac].imq09 AND img04=g_imq[l_ac].imq10
    IF STATUS=100 THEN
       LET l_flag01 = NULL
       #CALL s_inv_shrt_by_warehouse(g_sma.sma894[5,5],g_imq[l_ac].imq08) RETURNING l_flag01  #FUN-D30024--mark
       CALL s_inv_shrt_by_warehouse(g_imq[l_ac].imq08,g_plant) RETURNING l_flag01  #FUN-D30024--add #TQC-D40078 g_plant
       IF l_flag01 = 'N' OR l_flag01 IS NULL THEN
           CALL cl_err3("sel","img_file",g_imq[l_ac].imq05,g_imq[l_ac].imq08,
                        "mfg6142","","",1)
           LET g_success='N' RETURN
       ELSE
           IF g_sma.sma892[3,3] = 'Y' THEN
               IF NOT cl_confirm('mfg1401') THEN
                  LET g_success='N' RETURN
               END IF
           END IF
           CALL s_add_img(g_imq[l_ac].imq05,g_imq[l_ac].imq08,
                          g_imq[l_ac].imq09,g_imq[l_ac].imq10,
                          g_imr.imr01      ,g_imq[l_ac].imq02,
                          g_imr.imr02)
           IF g_errno='N' THEN
               LET g_success='N' RETURN
           END IF
       END IF
    END IF
    #FUN-C80107 add end-----------------------------------------
    LET g_forupd_sql = "SELECT img09  FROM img_file ",    
                       "   WHERE img01 = ? AND img02 = ? ",      
                       "     AND img03 = ? AND img04 = ? FOR UPDATE " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img1_lock CURSOR FROM g_forupd_sql      
    OPEN img1_lock USING b_imq.imq05,b_imq.imq08,b_imq.imq09,b_imq.imq10       
    IF STATUS THEN     
       CALL cl_err('lock img3 fail',STATUS,1)  
       LET g_success = 'N'    
       RETURN  
    END IF      
    FETCH img1_lock INTO l_img09      
    IF STATUS THEN  
       CALL cl_err('sel img_file fail',STATUS,1) 
       LET g_success = 'N' 
       RETURN    
    END IF
 
 #------MOD-580069 add 換算環料單位與庫存單位的換算率
     CALL s_umfchk(b_imq.imq05,b_imq.imq06,l_img09)
                    RETURNING l_cnt,l_imq06_fac
     IF cl_null(l_imq06_fac) THEN
        LET l_imq06_fac = 1
     END IF
     LET l_qty = b_imq.imq07 * l_imq06_fac
 
 
    CALL t309_get_value()
    
#FUN-A80106 add --start--
        #FUN-B30187 --START--        
        SELECT * INTO b_imqi.* FROM imqi_file 
         WHERE imqi01=g_imr.imr01 AND imqi02=b_imq.imq02
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_imr.imr01,SQLCA.sqlcode,0)
            LET g_success = 'N'                                                                                                       
            RETURN
        END IF 
        #FUN-B30187 --END--
        CALL s_icdpost(-1,b_imq.imq05,b_imq.imq08,b_imq.imq09,
                       b_imq.imq10,b_imq.imq06,b_imq.imq07,
                       b_imq.imq01,b_imq.imq02,g_imr.imr02,'Y',
                       '','',b_imqi.imqiicd029,b_imqi.imqiicd028,'') #FUN-B30187  #FUN-B80119--傳入p_plant參數''---
             RETURNING l_flag
        IF l_flag = 0 THEN
           LET g_success = 'N'
           RETURN
        END IF
#FUN-A80106 add --end-- 
 
    CALL s_upimg(b_imq.imq05,b_imq.imq08,b_imq.imq09,b_imq.imq10,-1,l_qty,g_imr.imr02,b_imq.imq05,b_imq.imq08,#FUN-8C0084
                #b_imq.imq09,b_imq.imq10,g_imr.imr01,'',b_imq.imq06,b_imq.imq07,          #FUN-C50071 mark
                 b_imq.imq09,b_imq.imq10,g_imr.imr01,b_imq.imq02,b_imq.imq06,b_imq.imq07, #FUN-C50071 add
                 b_imq.imq06,1,g_ima25_fac,1,'','','','','','') #FUN-560183 g_ima86->1
 
    IF g_success = 'N' THEN RETURN  END IF
    LET g_forupd_sql = "SELECT ima01 FROM ima_file WHERE ima01 = ? FOR UPDATE "    
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE ima_lock2 CURSOR FROM g_forupd_sql   
    OPEN ima_lock2 USING b_imq.imq05     
    IF STATUS THEN      
       CALL cl_err('lock ima2 fail',STATUS,1)  
       LET g_success = 'N'  
       RETURN           
    END IF               
    FETCH ima_lock2 INTO l_ima01  
    IF STATUS THEN     
       CALL cl_err('sel ima fail',STATUS,1) 
       LET g_success = 'N'    
       RETURN        
    END IF            
    #更新庫存主檔之庫存數量
    IF s_udima(b_imq.imq05,                       #料件編號
               g_img23,                           #是否可用倉儲
               g_img24,                           #是否為MRP可用倉儲
               b_imq.imq07*g_ima25_fac,           #發料數量(換算為庫存單位)
               g_imr.imr02,                       #最近一次發料日期
               -1)                                #表收料
       THEN LET g_success='N' RETURN
    END IF
    #產生異動記錄資料
    CALL t309_log(1,0,'',b_imq.imq05,l_qty)
 
    #No.FUN-570249  --begin
    IF g_sma.sma115='Y' THEN
       CALL t309_update_du(-1)
    END IF
    IF g_success='N' THEN RETURN END IF
    #No.FUN-570249  --end
 
 
END FUNCTION
 
 
#處理異動記錄
FUNCTION t309_log(p_stdc,p_reason,p_code,p_item,p_qty)
DEFINE
    l_pmn02         LIKE pmn_file.pmn02,   #採購單性質
    p_stdc          LIKE type_file.num5,   #是否需取得標準成本  #No.FUN-690026 SMALLINT
    p_reason        LIKE type_file.num5,   #是否需取得異動原因  #No.FUN-690026 SMALLINT
    p_code          LIKE type_file.chr20,  #No.FUN-690026 VARCHAR(04)
    p_item          LIKE ima_file.ima01,   #No.FUN-690026 VARCHAR(20)
    p_qty           LIKE img_file.img08,   #MOD-530179       #異動數量
    l_imo05         LIKE imo_file.imo05,   #MOD-590125 modify
    l_img09         LIKE img_file.img09,   #MOD-590125 add
    l_flag          LIKE type_file.num5    #MOD-590125 add  #No.FUN-690026 SMALLINT
 
 
#----來源----
    LET g_tlf.tlf01=p_item      	 #異動料件編號
    LET g_tlf.tlf02=50         	         #資料來源為倉庫
    LET g_tlf.tlf020=g_plant             #工廠別
    LET g_tlf.tlf021=b_imq.imq08  	 #倉庫別
    LET g_tlf.tlf022=b_imq.imq09  	 #儲位別
    LET g_tlf.tlf023=b_imq.imq10  	 #入庫批號
    IF g_sma.sma12 = 'Y' THEN
        LET g_tlf.tlf024=g_img10-b_imq.imq07
        LET g_tlf.tlf025=g_img09
    ELSE
#       LET g_tlf.tlf024=g_ima262-b_imq.imq07     #NO.FUN-A20044
        LET g_tlf.tlf024=g_avl_stk-b_imq.imq07    #NO.FUN-A20044
        LET g_tlf.tlf025=g_ima25
    END IF
    LET g_tlf.tlf026=g_imr.imr01         #參考單据
    LET g_tlf.tlf027=b_imq.imq02
#----目的----
    LET g_tlf.tlf03=80         	 	 #資料來源為倉庫
    LET g_tlf.tlf030=g_plant             #工廠別
    LET g_tlf.tlf031=' '                 #倉庫別
    LET g_tlf.tlf032=' '                 #儲位別
    LET g_tlf.tlf033=' '                 #批號
    LET g_tlf.tlf034=' '                 #異動後庫存數量
    LET g_tlf.tlf035=' '                 #庫存單位(ima_file or imr_file)
    LET g_tlf.tlf036=b_imq.imq03         #還料單號
    LET g_tlf.tlf037=b_imq.imq04         #還料項次
#--->異動數量
    LET g_tlf.tlf04=' '                  #工作站
    LET g_tlf.tlf05=' '                  #作業序號
    LET g_tlf.tlf06=g_imr.imr09          #還料日期
    LET g_tlf.tlf07=g_today              #異動資料產生日期
    LET g_tlf.tlf08=TIME                 #異動資料產生時:分:秒
    LET g_tlf.tlf09=g_user               #產生人
    LET g_tlf.tlf10=b_imq.imq07          #還料數量
    LET g_tlf.tlf11=b_imq.imq06          #還料單位
 
 
#  計算還料單的還料單位與還料倉庫單位的[單位轉換率]-->因還料單的單位可以更改
   SELECT img09 INTO l_img09 FROM img_file
    WHERE img01=g_tlf.tlf01
      AND img02=b_imq.imq08
      AND img03=b_imq.imq09
      AND img04=b_imq.imq10
    CALL s_umfchk(g_tlf.tlf01,g_tlf.tlf11,l_img09)
      RETURNING l_flag,g_tlf.tlf12
    IF l_flag THEN
       CALL cl_err('','abm-731',1)
       LET g_success='N'
       LET g_tlf.tlf12=1
    END IF
    IF STATUS OR g_tlf.tlf12 IS NULL THEN LET g_tlf.tlf12=1 END IF
 
    LET g_tlf.tlf13='aimt309'            #異動命令代號
    LET g_tlf.tlf14=' '                  #異動原因
    IF g_sma.sma12='Y'                   #貸方會計科目
       THEN LET g_tlf.tlf16=g_ima39      #料件會計科目
       ELSE LET g_tlf.tlf16=g_img26      #倉儲會計科目
    END IF
    SELECT imo05 INTO l_imo05
      FROM imo_file
     WHERE imo01 = b_imq.imq03
    LET g_tlf.tlf15=l_imo05              #貸方會計科目
    LET g_tlf.tlf17=' '                  #非庫存性料件編號
    CALL s_imaQOH(b_imq.imq05)
         RETURNING g_tlf.tlf18           #異動後總庫存量
    LET g_tlf.tlf19= ' '                 #異動廠商/客戶編號
    LET g_tlf.tlf20= ' '                 #project no.
    CALL s_tlf(p_stdc,p_reason)
END FUNCTION
 
FUNCTION t309_get_value()
   DEFINE   l_n1        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_n2        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_n3        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044  
 
        #庫存數量,倉儲所屬會計科目,是否為可用倉儲,是否為ＭＲＰ可用倉儲
    SELECT img10,img26,img23,img24,img09
      INTO g_img10,g_img26,g_img23,g_img24,g_img09 FROM img_file
     WHERE img01=b_imq.imq05
       AND img02=b_imq.imq08
       AND img03=b_imq.imq09
       AND img04=b_imq.imq10
 
    #料件所屬會計科目,成本單位,庫存單位
#   SELECT ima39,ima25,ima262  #FUN-560183 del ima86                       #NO.FUN-A20044
#     INTO g_ima39,g_ima25,g_ima262 FROM ima_file #FUN-560183 del g_ima86  #NO.FUN-A20044
    SELECT ima39,ima25,0  #FUN-560183 del ima86                            #NO.FUN-A20044
      INTO g_ima39,g_ima25,g_avl_stk FROM ima_file #FUN-560183 del g_ima86 #NO.FUN-A20044
     WHERE ima01=b_imq.imq05
      CALL s_getstock(b_imq.imq05,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044  
      LET g_avl_stk = l_n3                                                      #NO.FUN-A20044 
      CALL s_umfchk(b_imq.imq05,b_imq.imq06,g_ima25)
                    RETURNING g_cnt,g_ima25_fac
END FUNCTION
 
FUNCTION t309_s() #扣帳
  DEFINE l_imp08   LIKE imp_file.imp08,
         l_imo07   LIKE imo_file.imo07,
         l_imq03   LIKE imq_file.imq03,
         l_imq04   LIKE imq_file.imq04,
         l_sum1    LIKE imq_file.imq07,   #MOD-530179
         l_sum2    LIKE imq_file.imq07,   #MOD-530179
         l_mess    LIKE type_file.chr1000,#No.FUN-690026 VARCHAR(20)
         p_cmd     LIKE type_file.chr1,   #TQC-7A0096
         l_return  LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 DEFINE l_imr09   LIKE imr_file.imr09  #FUN-6B0038 add
 DEFINE l_yy,l_mm LIKE type_file.num5  #FUN-6B0038
 
DEFINE l_cnt     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_sql     LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(400)
       l_imq07   LIKE imq_file.imq07,
       l_imq15   LIKE imq_file.imq15,
       l_imq05   LIKE imq_file.imq05,
       l_qcs01   LIKE qcs_file.qcs01,
       l_qcs02   LIKE qcs_file.qcs02,
       l_qcs091c LIKE qcs_file.qcs091
DEFINE l_flag    LIKE type_file.chr1     #FUN-930109
DEFINE l_imq08   LIKE imq_file.imq08     #FUN-930109
DEFINE l_imq09   LIKE imq_file.imq09     #FUN-930109
DEFINE l_imq02   LIKE imq_file.imq02     #FUN-930109
DEFINE g_flag    LIKE type_file.chr1     #FUN-930109
DEFINE l_imp05   LIKE imp_file.imp05     #FUN-BB0083
DEFINE l_cnt_img   LIKE type_file.num5     #FUN-C70087
DEFINE l_cnt_imgg  LIKE type_file.num5     #FUN-C70087
 
    SELECT * INTO g_imr.* FROM imr_file WHERE imr01=g_imr.imr01
    IF cl_null(g_imr.imr01) THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_imr.imrconf='N' THEN CALL cl_err('','aba-100',0) RETURN END IF #FUN-660080
    IF g_imr.imrpost='Y' THEN CALL cl_err(g_imr.imr01,'aar-347',0) RETURN END IF
    IF g_imr.imrconf='X' THEN CALL cl_err('','9024',0) RETURN END IF #已作廢 #FUN-660080
    IF NOT cl_null(g_imr.imr05) THEN
        SELECT imo07 INTO l_imo07
          FROM imo_file
         WHERE imo01 = g_imr.imr05
        IF l_imo07 = 'Y' THEN
            #此借料單據已結案!
            CALL cl_err(g_imr.imr05,'aim-411',0)
            RETURN
        END IF
    ELSE
        SELECT COUNT(*) INTO g_cnt
          FROM imq_file
         WHERE imq01=g_imr.imr01
           AND (imq03 IS NULL OR imq03 = ' ')
        IF g_cnt >=1 THEN
            #單身借料單號欄位不可空白!
            CALL cl_err(g_imr.imr01,'aim-416',0)
            RETURN
        END IF
    END IF
    LET g_flag ='Y'
    DECLARE t309_s_cs1 CURSOR FOR SELECT UNIQUE imq02,imq08,imq09 FROM imq_file 
                                  WHERE imq01=g_imr.imr01 
     
    CALL s_showmsg_init()
                              
    FOREACH t309_s_cs1 INTO l_imq02,l_imq08,l_imq09
      CALL s_incchk(l_imq08,l_imq09,g_user) 
      RETURNING l_flag
      IF l_flag = FALSE THEN
         LET g_flag='N'
         LET g_showmsg=l_imq02,"/",l_imq08,"/",l_imq09,"/",g_user                                                                   
         CALL s_errmsg('imq02,imq08,imq09,inc03',g_showmsg,'','asf-888',1)                                                          
      END IF
    END FOREACH
    CALL s_showmsg()                                                                                                                 
    IF g_flag='N' THEN                                                                                                            
       RETURN                                                                                                                        
    END IF                                     
 
    DECLARE t309_s_cur CURSOR FOR
        SELECT UNIQUE imq03,imq04
          FROM imq_file
        WHERE imq01 = g_imr.imr01
    LET l_return = 'N'
    FOREACH t309_s_cur INTO l_imq03,l_imq04
        SELECT COUNT(*) INTO g_cnt
          FROM imp_file
         WHERE imp01 = l_imq03 #借料單號
           AND imp02 = l_imq04 #借料項次
           AND imp07 = 'Y'
        IF g_cnt > 0 THEN
            LET l_mess=''
            LET l_mess = l_imq03 CLIPPED,'+',l_imq04 CLIPPED
            #此借料單據已結案!
            CALL cl_err(l_mess,'aim-411',1)
            LET l_return = 'Y'
        END IF
        LET l_sum1 = 0
        LET l_sum2 = 0
        SELECT SUM(imq07/imq06_fac)
          INTO l_sum1 #此次要償還的數量
          FROM imq_file
         WHERE imq01 = g_imr.imr01
           AND imq03 = l_imq03
           AND imq04 = l_imq04
        SELECT (imp04-imp08)
          INTO l_sum2 #未償還的數量
          FROM imp_file
         WHERE imp01 = l_imq03
           AND imp02 = l_imq04
        IF l_sum1 > l_sum2 THEN
            LET l_mess=''
            LET l_mess = l_imq03 CLIPPED,'+',l_imq04 CLIPPED
            #此次償還的數量>未償還的數量
            CALL cl_err(l_mess,'aim-418',1)
            LET l_return = 'Y'
        END IF
    END FOREACH
    IF l_return = 'Y' THEN RETURN END IF
   LET l_sql = " SELECT imq07,imq15,imq05,imq01,imq02 FROM imq_file ",
               "  WHERE imq01 = '",g_imr.imr01,"'"
   PREPARE t309_curs1 FROM l_sql
   DECLARE t309_pre1 CURSOR FOR t309_curs1
   FOREACH t309_pre1 INTO l_imq07,l_imq15,l_imq05,l_qcs01,l_qcs02
     IF l_imq15 = 'Y' THEN
       LET l_qcs091c = 0
       SELECT SUM(qcs091) INTO l_qcs091c
         FROM qcs_file
        WHERE qcs01 = l_qcs01
          AND qcs02 = l_qcs02
          AND qcs14 = 'Y'
       IF l_qcs091c IS NULL THEN
          LET l_qcs091c = 0
       END IF
 
       IF l_imq07 > l_qcs091c THEN
          CALL cl_err(l_imq05,'mfg3558',1)
          RETURN
       END IF
     END IF
   END FOREACH
    IF NOT cl_sure(21,20) THEN RETURN END IF
 
   LET g_str = 'y'   #TQC-7A0096
  INPUT l_imr09 WITHOUT DEFAULTS FROM imr09
    BEFORE INPUT
       CALL t309_set_entry(p_cmd)
       CALL t309_set_no_entry(p_cmd)
      LET l_imr09 = g_today          #TQC-740117
      DISPLAY l_imr09 TO imr09
 
    AFTER FIELD imr09
      IF NOT cl_null(l_imr09) THEN
         IF g_sma.sma53 IS NOT NULL AND l_imr09 <= g_sma.sma53 THEN
              CALL cl_err('','mfg9999',0) NEXT FIELD imr09
         END IF
          CALL s_yp(l_imr09) RETURNING l_yy,l_mm
 
          IF ((l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52)) THEN
                 CALL cl_err('','mfg6090',0)
                 NEXT FIELD imr09
          END IF
       END IF
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
 IF INT_FLAG THEN LET INT_FLAG = 0 LET g_success = 'N' RETURN END IF  #CHI-930007
 
 
    LET g_success='Y'
    BEGIN WORK
 
    OPEN t309_cl USING g_imr.imr01
    IF STATUS THEN
       CALL cl_err("OPEN t309_cl:", STATUS, 1)
       CLOSE t309_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t309_cl INTO g_imr.*            # 鎖住將被更改或取消的資料
    IF cl_null(l_imr09) THEN LET l_imr09 = g_today END IF 
    LET g_imr.imr09=l_imr09        
    DISPLAY BY NAME g_imr.imr09    
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imr.imr01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t309_cl ROLLBACK WORK RETURN
    END IF    

   #FUN-C70087---begin
   CALL s_padd_img_init()  #FUN-CC0095
   CALL s_padd_imgg_init()  #FUN-CC0095
   
   DECLARE t309_s_c1 CURSOR FOR SELECT * FROM imq_file
     WHERE imq01 = g_imr.imr01 

   FOREACH t309_s_c1 INTO b_imq.*
      IF STATUS THEN EXIT FOREACH END IF
      LET l_cnt_img = 0
      SELECT COUNT(*) INTO l_cnt_img
        FROM img_file
       WHERE img01 = b_imq.imq05
         AND img02 = b_imq.imq08
         AND img03 = b_imq.imq09
         AND img04 = b_imq.imq10
       IF l_cnt_img = 0 THEN
          #CALL s_padd_img_data(b_imq.imq05,b_imq.imq08,b_imq.imq09,b_imq.imq10,g_imr.imr01,b_imq.imq02,g_imr.imr09,l_img_table)  #FUN-CC0095
          CALL s_padd_img_data1(b_imq.imq05,b_imq.imq08,b_imq.imq09,b_imq.imq10,g_imr.imr01,b_imq.imq02,g_imr.imr09)  #FUN-CC0095
       END IF

       CALL s_chk_imgg(b_imq.imq05,b_imq.imq08,
                       b_imq.imq09,b_imq.imq10,
                       b_imq.imq20) RETURNING g_flag
       IF g_flag = 1 THEN
          #CALL s_padd_imgg_data(b_imq.imq05,b_imq.imq08,b_imq.imq09,b_imq.imq10,b_imq.imq20,g_imr.imr01,b_imq.imq02,l_imgg_table)  #FUN-CC0095
          CALL s_padd_imgg_data1(b_imq.imq05,b_imq.imq08,b_imq.imq09,b_imq.imq10,b_imq.imq20,g_imr.imr01,b_imq.imq02)  #FUN-CC0095
       END IF 
       CALL s_chk_imgg(b_imq.imq05,b_imq.imq08,
                       b_imq.imq09,b_imq.imq10,
                       b_imq.imq23) RETURNING g_flag
       IF g_flag = 1 THEN
          #CALL s_padd_imgg_data(b_imq.imq05,b_imq.imq08,b_imq.imq09,b_imq.imq10,b_imq.imq23,g_imr.imr01,b_imq.imq02,l_imgg_table)  #FUN-CC0095
          CALL s_padd_imgg_data1(b_imq.imq05,b_imq.imq08,b_imq.imq09,b_imq.imq10,b_imq.imq23,g_imr.imr01,b_imq.imq02)  #FUN-CC0095
       END IF 
   END FOREACH 
   #FUN-CC0095---begin mark
   #LET g_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_img_table CLIPPED #g_cr_db_str,
   #PREPARE cnt_img FROM g_sql
   #LET l_cnt_img = 0
   #EXECUTE cnt_img INTO l_cnt_img
   #
   #LET g_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_imgg_table CLIPPED #g_cr_db_str,
   #PREPARE cnt_imgg FROM g_sql 
   #LET l_cnt_imgg = 0
   #EXECUTE cnt_imgg INTO l_cnt_imgg
   #FUN-CC0095---end    
   LET l_cnt_img = g_padd_img.getLength()  #FUN-CC0095
   LET l_cnt_imgg = g_padd_imgg.getLength()  #FUN-CC0095
   
   IF g_sma.sma892[3,3] = 'Y' AND (l_cnt_img > 0 OR l_cnt_imgg > 0) THEN
      IF cl_confirm('mfg1401') THEN 
         IF l_cnt_img > 0 THEN 
            #IF NOT s_padd_img_show(l_img_table) THEN   #FUN-CC0095
            IF NOT s_padd_img_show1() THEN  #FUN-CC0095
               #CALL s_padd_img_del(l_img_table)  #FUN-CC0095
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
         #CALL s_padd_img_del(l_img_table)  #FUN-CC0095 
         #CALL s_padd_imgg_del(l_imgg_table)  #FUN-CC0095 
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   #CALL s_padd_img_del(l_img_table)  #FUN-CC0095 
   #CALL s_padd_imgg_del(l_imgg_table)  #FUN-CC0095 
   #FUN-C70087---end
 
    CALL s_showmsg_init()   #No.FUN-6C0083 
 
    DECLARE t309_s_cs CURSOR FOR
      SELECT * FROM imq_file WHERE imq01=g_imr.imr01
 
    FOREACH t309_s_cs INTO b_imq.*
    
      IF NOT s_stkminus(b_imq.imq05,b_imq.imq08,b_imq.imq09,b_imq.imq10,
                       #b_imq.imq07,b_imq.imq06_fac,g_today,g_sma.sma894[5,5]) THEN  #FUN-D30024--mark
                        b_imq.imq07,b_imq.imq06_fac,g_today) THEN                    #FUN-D30024--add
         LET g_totsuccess="N"   #No.FUN-6C0083
         CONTINUE FOREACH
      END IF
 
      CALL t309_t()
      IF g_success='N' THEN    #No.FUN-6C0083
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH
      END IF
      SELECT imp08 INTO l_imp08
        FROM imp_file
       WHERE imp01 = b_imq.imq03
         AND imp02 = b_imq.imq04
      #FUN-BB0083---add---str
      SELECT imp05 INTO l_imp05
        FROM imp_file
       WHERE imp01 = b_imq.imq03
         AND imp02 = b_imq.imq04
      LET l_imp08 = l_imp08+(b_imq.imq07/b_imq.imq06_fac)
      LET l_imp08 = s_digqty(l_imp08,l_imp05)
      #FUN-BB0083---add---end
 
      UPDATE imp_file
         SET imp08 = l_imp08 #l_imp08+(b_imq.imq07/b_imq.imq06_fac) FUN-BB0083 mod
       WHERE imp01 = b_imq.imq03
         AND imp02 = b_imq.imq04
      IF SQLCA.sqlcode OR sqlca.sqlerrd[3]=0 THEN LET g_success='N' END IF
      IF g_success='N' THEN EXIT FOREACH END IF
    END FOREACH
 
    IF g_totsuccess="N" THEN
       LET g_success="N"
    END IF
    CALL s_showmsg()   #No.FUN-6C0083
    MESSAGE ""
    UPDATE imr_file
       SET imr09 = g_imr.imr09,    #FUN-6B0038
           imrpost='Y',
           imrmodu=g_user,
           imrdate=g_today
     WHERE imr01=g_imr.imr01
    IF SQLCA.sqlcode OR sqlca.sqlerrd[3]=0 THEN LET g_success='N' END IF
    IF g_success = 'Y'
       THEN
       LET g_imr.imrpost='Y'
       LET g_imr.imrmodu=g_user
       LET g_imr.imrdate=g_today
       CALL cl_cmmsg(1) COMMIT WORK
       CALL cl_flow_notify(g_imr.imr01,'S')
    ELSE
       CALL cl_rbmsg(1) ROLLBACK WORK
    END IF
    DISPLAY BY NAME g_imr.imr09,g_imr.imrpost,g_imr.imrmodu,g_imr.imrdate
END FUNCTION
 
FUNCTION t309_w()
  DEFINE  l_qty       LIKE img_file.img08,
          l_imp08     LIKE imp_file.imp08,
          l_imo07     LIKE imo_file.imo07,
          l_imq03     LIKE imq_file.imq03,
          l_imq04     LIKE imq_file.imq04,
          l_mess      LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(20)
          l_return    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_img09     LIKE img_file.img09,
          l_imq06_fac LIKE imq_file.imq06_fac,
          l_cnt       LIKE type_file.num5     #No.FUN-690026 SMALLINT
  DEFINE l_ima01      LIKE ima_file.ima01     #NO.TQC-930155 
  DEFINE la_tlf       DYNAMIC ARRAY OF RECORD LIKE tlf_file.*  #NO.FUN-8C0131 
  DEFINE l_sql        STRING                                   #NO.FUN-8C0131 
  DEFINE l_i          LIKE type_file.num5                      #NO.FUN-8C0131
  DEFINE l_ima918     LIKE ima_file.ima918   #No:FUN-C50071
  DEFINE l_ima921     LIKE ima_file.ima921   #No:FUN-C50071
  DEFINE l_imp05      LIKE imp_file.imp05     #FUN-BB0083 add
  DEFINE l_yy,l_mm    LIKE type_file.num5    #CHI-C70017
#FUN-A80106 add --start--
DEFINE l_flag   LIKE type_file.num5   #判斷s_icdpost()成功/失敗
#FUN-A80106 add --end-- 
 
    SELECT * INTO g_imr.* FROM imr_file WHERE imr01=g_imr.imr01
    IF cl_null(g_imr.imr01) THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_imr.imrpost='N' THEN CALL cl_err('','afa-108',0) RETURN END IF
    IF g_imr.imrconf='X' THEN CALL cl_err('','9024',0) RETURN END IF #FUN-660080
    #FUN-BC0062 ---------Begin--------
    #當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
       SELECT ccz_file.* INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
       IF g_ccz.ccz28  = '6' THEN
          CALL cl_err('','apm-936',1)
          RETURN
       END IF
    #FUN-BC0062 ---------End----------
    IF NOT cl_null(g_imr.imr05) THEN
        SELECT imo07 INTO l_imo07
          FROM imo_file
         WHERE imo01 = g_imr.imr05
        IF l_imo07 = 'Y' THEN
            #此借料單據已結案!
            CALL cl_err(g_imr.imr05,'aim-411',0)
            RETURN
        END IF
    ELSE
        SELECT COUNT(*) INTO g_cnt
          FROM imq_file
         WHERE imq01=g_imr.imr01
           AND (imq03 IS NULL OR imq03 = ' ')
        IF g_cnt >=1 THEN
            #單身借料單號欄位不可空白!
            CALL cl_err(g_imr.imr01,'aim-416',0)
            RETURN
        END IF
    END IF
    #CHI-C70017---begin
    IF g_sma.sma53 IS NOT NULL AND g_imr.imr09 <= g_sma.sma53 THEN
       CALL cl_err('','mfg9999',0) 
       RETURN
    END IF
    CALL s_yp(g_imr.imr09) RETURNING l_yy,l_mm
 
    IF ((l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52)) THEN
       CALL cl_err('','mfg6090',0)
       RETURN
    END IF
    #CHI-C70017---end
    
   #MOD-AB0217---add---start---
    IF g_sma.sma53 IS NOT NULL AND g_imr.imr09 <= g_sma.sma53 THEN 
       CALL cl_err('','axr-164',0) 
       RETURN 
    END IF
   #MOD-AB0217---add---end---
    DECLARE t309_w_cur CURSOR FOR
        SELECT UNIQUE imq03,imq04
          FROM imq_file
        WHERE imq01 = g_imr.imr01
    LET l_return = 'N'
    FOREACH t309_w_cur INTO l_imq03,l_imq04
        SELECT COUNT(*) INTO g_cnt
          FROM imp_file
         WHERE imp01 = l_imq03 #借料單號
           AND imp02 = l_imq04 #借料項次
           AND imp07 = 'Y'
        IF g_cnt > 0 THEN
            LET l_mess=''
            LET l_mess = l_imq03 CLIPPED,'+',l_imq04 CLIPPED
            #此借料單據已結案!
            CALL cl_err(l_mess,'aim-411',1)
            LET l_return = 'Y'
        END IF
    END FOREACH
    IF l_return = 'Y' THEN RETURN END IF
    IF NOT cl_sure(21,20) THEN RETURN END IF
 
    LET g_success='Y'
    BEGIN WORK
 
    OPEN t309_cl USING g_imr.imr01
    IF STATUS THEN
       CALL cl_err("OPEN t309_cl:", STATUS, 1)
       CLOSE t309_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t309_cl INTO g_imr.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imr.imr01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t309_cl ROLLBACK WORK RETURN
    END IF
       DECLARE t309_w_cs CURSOR FOR
         SELECT * FROM imq_file WHERE imq01=g_imr.imr01
 
       FOREACH t309_w_cs INTO b_imq.*
          LET l_qty = b_imq.imq07
 
          CALL t309_get_value()
          LET g_forupd_sql = "SELECT img09 FROM img_file ",           
                             "  WHERE img01 = ? AND img02 = ? ",             
                             "    AND img03 = ? AND img04 = ? FOR UPDATE "    
          LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
          DECLARE img2_lock CURSOR FROM g_forupd_sql                           
          OPEN img2_lock USING b_imq.imq05,b_imq.imq08,b_imq.imq09,b_imq.imq10  
          IF STATUS THEN                               
             CALL cl_err('lock img2 fail',STATUS,1)     
             LET g_success = 'N'            
             EXIT FOREACH                    
          END IF                              
          FETCH img2_lock INTO l_img09 
          IF STATUS THEN                        
             CALL cl_err('sel img fail',STATUS,1)
             LET g_success = 'N'                
             EXIT FOREACH                        
          END IF                                  
#------MOD-580069 add 換算環料單位與庫存單位的換算率
     CALL s_umfchk(b_imq.imq05,b_imq.imq06,l_img09)
                    RETURNING l_cnt,l_imq06_fac
     IF cl_null(l_imq06_fac) THEN
        LET l_imq06_fac = 1
     END IF
     LET l_qty = b_imq.imq07 * l_imq06_fac
     
#FUN-A80106 add --start--
        #FUN-B30187 --START--        
        SELECT * INTO b_imqi.* FROM imqi_file 
         WHERE imqi01=g_imr.imr01 AND imqi02=b_imq.imq02
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_imr.imr01,SQLCA.sqlcode,0)
            LET g_success = 'N'                                                                                                       
            RETURN
        END IF 
        #FUN-B30187 --END--
        CALL s_icdpost(-1,b_imq.imq05,b_imq.imq08,b_imq.imq09,
                       b_imq.imq10,b_imq.imq06,b_imq.imq07,
                       b_imq.imq01,b_imq.imq02,g_imr.imr02,'N',
                       '','',b_imqi.imqiicd029,b_imqi.imqiicd028,'') #FUN-B30187  #FUN-B80119--傳入p_plant參數''---
             RETURNING l_flag
        IF l_flag = 0 THEN
           LET g_success = 'N'
           RETURN
        END IF
#FUN-A80106 add --end--  
 
    CALL s_upimg(b_imq.imq05,b_imq.imq08,b_imq.imq09,b_imq.imq10,+1,l_qty,g_imr.imr02, #FUN-8C0084
#       5           6           7           8           9
        b_imq.imq05,b_imq.imq08,b_imq.imq09,b_imq.imq10,g_imr.imr01,
#       10 11          12          13
       #'',b_imq.imq06,b_imq.imq07,b_imq.imq06,          #FUN-C50071 mark 
        b_imq.imq02,b_imq.imq06,b_imq.imq07,b_imq.imq06, #FUN-C50071 add
#       14              15              16
        1              ,g_ima25_fac,1, #FUN-560183 g_ima86->1
#       17 18 19 20 21
        '','','','','','')
 
 
 
          IF g_success = 'N' THEN EXIT FOREACH END IF
          LET g_forupd_sql = "SELECT ima01 FROM ima_file WHERE ima01 = ? FOR UPDATE "    
          LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
          DECLARE ima_lock1 CURSOR FROM g_forupd_sql
          OPEN ima_lock1 USING b_imq.imq05       
          IF STATUS THEN                          
             CALL cl_err('lock ima1 fail',STATUS,1)
             LET g_success = 'N'              
             EXIT FOREACH                      
          END IF                                
          FETCH ima_lock1 INTO l_ima01           
          IF STATUS THEN                          
             CALL cl_err('sel ima fail',STATUS,1)  
             LET g_success = 'N'  
             EXIT FOREACH          
          END IF                    
          IF s_udima(b_imq.imq05,                       #料件編號
                     g_img23,                           #是否可用倉儲
                     g_img24,                           #是否為MRP可用倉儲
                     b_imq.imq07*g_ima25_fac,           #發料數量(換算為庫存單位)
                     g_imr.imr02,                       #最近一次發料日期
                     +1) THEN
              LET g_success='N' EXIT FOREACH
          END IF
  ##NO.FUN-8C0131   add--begin   
    LET l_sql =  " SELECT  * FROM tlf_file ", 
                 "  WHERE  tlf01 = '",b_imq.imq05,"'",
                 "    AND tlf036='",b_imq.imq03,"' AND tlf037='",b_imq.imq04,"'",
                 "   AND tlf03 =80 AND lf905='",g_imr.imr01,"' AND tlf906='",b_imq.imq02,"'"     
    DECLARE t309_u_tlf_c CURSOR FROM l_sql
    LET l_i = 0 
    CALL la_tlf.clear()
    FOREACH t309_u_tlf_c INTO g_tlf.*
       LET l_i = l_i + 1
       LET la_tlf[l_i].* = g_tlf.*
    END FOREACH     

  ##NO.FUN-8C0131   add--end 
          DELETE FROM tlf_file
           WHERE tlf01 =b_imq.imq05 AND tlf036=b_imq.imq03
             AND tlf037=b_imq.imq04 AND tlf03 =80
              AND tlf905=g_imr.imr01 AND tlf906=b_imq.imq02 #MOD-570022
          IF SQLCA.sqlcode THEN
             CALL cl_err3("del","tlf_file",b_imq.imq05,"",sqlca.sqlcode,"","del tlf:",1)   #NO.FUN-640266 #No.FUN-660156
             LET g_success='N'
             EXIT FOREACH
          END IF
  ##NO.FUN-8C0131   add--begin
          FOR l_i = 1 TO la_tlf.getlength()
             LET g_tlf.* = la_tlf[l_i].*
             IF NOT s_untlf1('') THEN 
                LET g_success='N' RETURN
             END IF 
          END FOR       
  ##NO.FUN-8C0131   add--end  

#FUN-C50071 add begin-------------------------
          SELECT ima918,ima921 INTO l_ima918,l_ima921
            FROM ima_file
           WHERE ima01 = b_imq.imq05
             AND imaacti = "Y"

          IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
             DELETE FROM tlfs_file
             WHERE tlfs01 = b_imq.imq05
               AND tlfs10 = b_imq.imq01
               AND tlfs11 = b_imq.imq02

             IF STATUS OR SQLCA.SQLCODE THEN
                CALL cl_err3("del","tlfs_file",b_imq.imq01,"",STATUS,"","del tlfs",1)
                LET g_success='N'
                RETURN
              END IF

             IF SQLCA.SQLERRD[3]=0 THEN
                CALL cl_err3("del","tlfs_file",b_imq.imq01,"","mfg0177","","del tlfs",1)
                LET g_success='N'
                RETURN
             END IF
          END IF
#FUN-C50071 add -end--------------------------

          IF g_sma.sma115='Y' THEN
             CALL t309_update_du(+1)
             SELECT ima906 INTO g_ima906 FROM ima_file WHERE ima01=b_imp.imp03
             IF g_ima906 MATCHES '[23]' THEN
                DELETE FROM tlff_file
                 WHERE tlff01 =b_imq.imq05 AND tlff036=b_imq.imq03
                   AND tlff037=b_imq.imq04 AND tlff03 =80
                   AND tlff905=g_imr.imr01 AND tlff906=b_imq.imq02
                IF SQLCA.sqlerrd[3]=0 OR SQLCA.sqlcode THEN
                   CALL cl_err3("del","tlff_file",b_imq.imq05,"",sqlca.sqlcode,"","del tlff:",1)   #NO.FUN-640266 #No.FUN-660156
                   LET g_success='N'
                   EXIT FOREACH
                END IF
             END IF
          END IF
 
         SELECT imp08 INTO l_imp08
           FROM imp_file
          WHERE imp01 = b_imq.imq03
            AND imp02 = b_imq.imq04
       
         #FUN-BB0083---add---str
         SELECT imp05 INTO l_imp05
           FROM imp_file
          WHERE imp01 = b_imq.imq03
            AND imp02 = b_imq.imq04
         LET l_imp08 = l_imp08-(b_imq.imq07/b_imq.imq06_fac)
         LET l_imp08 = s_digqty(l_imp08,l_imp05)
         #FUN-BB0083---add---end

         UPDATE imp_file
            SET imp08 = l_imp08 #l_imp08-(b_imq.imq07/b_imq.imq06_fac) FUN-BB0083 mod
          WHERE imp01 = b_imq.imq03
            AND imp02 = b_imq.imq04
         IF sqlca.sqlcode or sqlca.sqlerrd[3]=0 THEN LET g_success='N' END IF
         IF g_success='N' THEN EXIT FOREACH END IF
       END FOREACH
    UPDATE imr_file
       SET imr09 = NULL,
           imrpost='N',
           imrmodu=g_user,
           imrdate=g_today
     WHERE imr01=g_imr.imr01
    IF sqlca.sqlcode or sqlca.sqlerrd[3]=0 THEN LET g_success='N' END IF
 
    IF g_success = 'Y' THEN
       LET g_imr.imr09=NULL
       LET g_imr.imrpost='N'
       LET g_imr.imrmodu=g_user
       LET g_imr.imrdate=g_today
       CALL cl_cmmsg(1) COMMIT WORK
    ELSE
       LET g_imr.imrpost='Y'
       CALL cl_rbmsg(1) ROLLBACK WORK
    END IF
    DISPLAY BY NAME g_imr.imr09,g_imr.imrpost,g_imr.imrmodu,g_imr.imrdate
END FUNCTION
 
#====>作廢/作廢還原功能
#FUNCTION t309_x()         #CHI-D20010
FUNCTION t309_x(p_type)    #CHI-D20010
#FUN-A80106 add --start--
   DEFINE l_flag    LIKE type_file.chr1     #判斷BIN/刻號處理成功否
#FUN-A80106 add --end--
   DEFINE l_flag1   LIKE type_file.chr1  #CHI-D20010
   DEFINE p_type    LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_imr.imr01) THEN CALL cl_err('',-400,0) RETURN END IF

   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_imr.imrconf ='X' THEN RETURN END IF
   ELSE
      IF g_imr.imrconf <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end

   BEGIN WORK
   LET g_success='Y'
 
   OPEN t309_cl USING g_imr.imr01
   IF STATUS THEN
      CALL cl_err("OPEN t309_cl:", STATUS, 1)
      CLOSE t309_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t309_cl INTO g_imr.* #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_imr.imr01,SQLCA.sqlcode,0) #資料被他人LOCK
       CLOSE t309_cl ROLLBACK WORK RETURN
   END IF
   #-->己過帳不可作廢
   IF g_imr.imrpost = 'Y' THEN CALL cl_err(g_imr.imr01,'afa-101',0) RETURN END IF
   IF g_imr.imrconf = 'Y' THEN CALL cl_err(g_imr.imr01,'axr-368',0) RETURN END IF #FUN-660080
   IF g_imr.imrconf = 'X' THEN  LET l_flag1 = 'X' ELSE LET l_flag1 = 'N' END IF #CHI-D20010
  #IF cl_void(0,0,g_imr.imrconf) THEN #FUN-660080#CHI-D20010
   IF cl_void(0,0,l_flag1) THEN #FUN-660080      #CHI-D20010
        LET g_chr=g_imr.imrconf #FUN-660080
       #IF g_imr.imrconf ='N' THEN #FUN-660080   #CHI-D20010
        IF p_type = 1 THEN #FUN-660080           #CHI-D20010
#FUN-A80106 add --start--
            #若已有ida/idb詢問且一併刪
            LET g_cnt = 0
            #出庫
            SELECT COUNT(*) INTO g_cnt FROM idb_file
             WHERE idb07 = g_imr.imr01
            IF g_cnt > 0 THEN
               IF NOT cl_confirm('aic-112') THEN
                  CLOSE t309_cl
                  ROLLBACK WORK
                  RETURN
               ELSE
                  LET g_cnt = 0
                  #出庫
                  CALL s_icdinout_del(-1,g_imr.imr01,'','')  #FUN-B80119--傳入p_plant參數''---
                       RETURNING l_flag
                  IF l_flag = 0 THEN
                     CLOSE t309_cl
                     ROLLBACK WORK
                     RETURN
                  END IF
               END IF
            END IF
#FUN-A80106 add --end--        
            LET g_imr.imrconf='X' #FUN-660080
        ELSE
            LET g_imr.imrconf='N' #FUN-660080
        END IF
        UPDATE imr_file
            SET imrconf=g_imr.imrconf, #FUN-660080
                imrmodu=g_user,
                imrdate=g_today
            WHERE imr01  =g_imr.imr01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("upd","imr_file",g_imr.imr01,"",SQLCA.sqlcode,"",
                        "upd",1)   #No.FUN-660156
           LET g_imr.imrconf = g_chr  #FUN-660080
        END IF
        DISPLAY BY NAME g_imr.imrconf,g_imr.imrmodu,g_imr.imrdate #FUN-660080
   END IF
   CLOSE t309_cl
   COMMIT WORK
   CALL cl_flow_notify(g_imr.imr01,'V')
END FUNCTION
 
FUNCTION t309_out()
DEFINE
    l_i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    sr              RECORD
        imr01       LIKE imr_file.imr01,   #單頭
        imr02       LIKE imr_file.imr02,   #
        imr03       LIKE imr_file.imr03,   #
        imr04       LIKE imr_file.imr04,   #
        imr05       LIKE imr_file.imr05,   #
        imr06       LIKE imr_file.imr06,   #
        imrconf     LIKE imr_file.imrconf, #FUN-C30062
        gen02       LIKE gen_file.gen02,   #
        gem02       LIKE gem_file.gem02,   #
        imrpost     LIKE imr_file.imrpost, #
        imq02       LIKE imq_file.imq02  , #單身
        imq03       LIKE imq_file.imq03  , #
        imq04       LIKE imq_file.imq04  , #
        imq05       LIKE imq_file.imq05  , #
        imq06       LIKE imq_file.imq06  , #
        imq06_fac   LIKE imq_file.imq06_fac  , #
        imq07       LIKE imq_file.imq07  , #
        imq08       LIKE imq_file.imq08  , #
        imq09       LIKE imq_file.imq09  , #
        imq10       LIKE imq_file.imq10  , #
        imp03       LIKE imp_file.imp03  , #
        imp04       LIKE imp_file.imp04  , #
        imp05       LIKE imp_file.imp05  , #
        ima02s      LIKE ima_file.ima02  , #
        ima02e      LIKE ima_file.ima02    #
       END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name  #No.FUN-690026 VARCHAR(20)
    l_za05          LIKE za_file.za05,              #  #No.FUN-690026 VARCHAR(40)
    l_wc            STRING,                          #MOD-AA0106
    l_prog          STRING                          #FUN-C30062
    
    CALL cl_del_data(l_table)                    #NO.FUN-840020
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aimt309' #NO.FUN-840020
    IF g_imr.imr01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    IF cl_null(g_wc) THEN
        LET g_wc=" imr01='",g_imr.imr01,"'"
    END IF
    IF cl_null(g_wc2) THEN
        LET g_wc2=" 1=1 "
    END IF
    #改成印當下的那一筆資料內容
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT imr01,imr02,imr03,imr04,imr05,imr06,imrconf,gen02,gem02,imrpost, ",    #單頭  #FUN-C30062 add imrconf
              "       imq02,imq03,imq04,imq05,imq06,imq06_fac,imq07,imq08,imq09, ",
              "       imq10,imp03,imp04,imp05 ",
              "  FROM imr_file,imq_file,imp_file, ",
              " OUTER gen_file,OUTER gem_file ",
              " WHERE imq01 = imr01 ",   #還料單號
              "   AND imq03 = imp01 ",   #借料單號
              "   AND imq04 = imp02 ",   #借料項次
              "   AND gen_file.gen01 = imr_file.imr03 ",
              "   AND gem_file.gem01 = imr_file.imr04 ",
              "   AND imr00 = '1' ",     #原價償還
              "   AND ",g_wc  CLIPPED,
              "   AND ",g_wc2 CLIPPED,
              " ORDER BY 1,10,11,12 "
    PREPARE t309_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t309_co                         # CURSOR
        CURSOR FOR t309_p1
 
    FOREACH t309_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
        SELECT ima02 INTO sr.ima02s FROM ima_file WHERE ima01=sr.imp03
        SELECT ima02 INTO sr.ima02e FROM ima_file WHERE ima01=sr.imq05
 
      EXECUTE insert_prep USING
        sr.imr01,sr.imr02,sr.imr03,sr.imr04,sr.imr05,sr.imr06,sr.imrconf,sr.gen02,    #FUN-C30062 add sr.imrconf
        sr.gem02,sr.imrpost,sr.imq02,sr.imq03,sr.imq04,sr.imq05,sr.imq06,
        sr.imq06_fac,sr.imq07,sr.imq08,sr.imq09,sr.imq10,sr.imp03,
        sr.imp04,sr.imp05,sr.ima02s,sr.ima02e
    END FOREACH
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(g_wc,'imr01,imr02,imr05,imr09,imr03,imr04,imr06,imrconf,                            imrspc,imrpost,imruser,imrgrup,imrmodu,imrdate,                            imq02,imq03,imq04,imq05,imq08,imq09,imq10,imq06,                            imq07,imq23,imq25,imq20,imq22,imq26,imq15,imq930')   #FUN-CB0087 add>imq26 在imq22后加
          #RETURNING g_wc           #MOD-AA0106 mark   
           RETURNING l_wc           #MOD-AA0106 add 
     END IF
    #LET g_str1 = g_wc              #MOD-AA0106 mark          
     LET g_str1 = l_wc              #MOD-AA0106 add 
     LET l_prog = g_prog            #FUN-C30062
     LET g_prog = 'aimt309'         #FUN-C30062
     CALL cl_prt_cs3('aimt309','aimt309',g_sql,g_str1) 
     LET g_prog = l_prog            #FUN-C30062
    CLOSE t309_co
    ERROR ""
END FUNCTION

FUNCTION t309_imr05(p_imr05)
   DEFINE   l_imo07   LIKE imo_file.imo07,
            l_imoconf LIKE imo_file.imoconf,
            l_imopost LIKE imo_file.imopost,
            p_imr05   LIKE imr_file.imr05
 
       LET g_errno=''
       SELECT imo07,imoconf,imopost
         INTO l_imo07,l_imoconf,l_imopost
         FROM imo_file
        WHERE imo01 = p_imr05
        CASE
            WHEN SQLCA.sqlcode=100   LET g_errno='aim-410' #無此借料單號!
                                     LET l_imo07=NULL
                                     LET l_imoconf=NULL
                                     LET l_imopost=NULL
            WHEN l_imo07='Y'         LET g_errno='aim-411' #此借料單據已結案!
            WHEN l_imoconf='N'       LET g_errno='9029'    #此筆資料尚未確認, 不可使用
            WHEN l_imoconf='X'       LET g_errno='9024'    #此筆資料已作廢
            WHEN l_imopost='N'       LET g_errno='aim-206  #單據尚未過帳!            OTHERWISE                 LET g_errno=SQLCA.sqlcode USING '------'
        END CASE
END FUNCTION
FUNCTION t309_imq04(p_cmd)
   DEFINE   l_imp07   LIKE imp_file.imp07,
            l_imoconf LIKE imo_file.imoconf,
            l_imopost LIKE imo_file.imopost,
            p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   DEFINE   l_ima35   LIKE ima_file.ima35,   #TQC-750018
            l_ima36   LIKE ima_file.ima36    #TQC-750018
   DEFINE  l_imq08    LIKE imq_file.imq08,
           l_imq09    LIKE imq_file.imq09,
           l_imq10    LIKE imq_file.imq10
 
       LET g_errno=''
       SELECT imp03,ima02,imp05,imp04,imp07,imoconf,imopost,
              imp23,imp25,imp20,imp22,ima35,ima36    #CHI-6A0015 add ima35/36
             ,imp11,imp12,imp13      #MOD-860030 
         INTO g_imq[l_ac].imp03,g_imq[l_ac].ima02s,
              g_imq[l_ac].imp05,g_imq[l_ac].imp04,
              l_imp07,l_imoconf,l_imopost,
              g_imq[l_ac].imp23,g_imq[l_ac].imp25,
              g_imq[l_ac].imp20,g_imq[l_ac].imp22, 
              l_ima35,l_ima36                                         #TQC-750018
              ,l_imq08,l_imq09,l_imq10   #MOD-860030 add
         FROM imp_file,imo_file,OUTER ima_file
        WHERE imp01 = g_imq[l_ac].imq03
          AND imp02 = g_imq[l_ac].imq04
          AND imp_file.imp03 = ima_file.ima01
          AND imp01 = imo01
        CASE
            WHEN SQLCA.sqlcode=100   LET g_errno='aim-410' #無此借料單號!
                                     LET g_imq[l_ac].imp03=NULL
                                     LET g_imq[l_ac].ima02s=NULL
                                     LET g_imq[l_ac].imp05=NULL
                                     LET g_imq[l_ac].imp04=NULL
                                     LET l_imp07=NULL
                                     LET g_imq[l_ac].imp23=NULL
                                     LET g_imq[l_ac].imp25=NULL
                                     LET g_imq[l_ac].imp20=NULL
                                     LET g_imq[l_ac].imp22=NULL
            WHEN l_imp07='Y'         LET g_errno='aim-411' #此借料單據已結案!
            WHEN l_imoconf='N'       LET g_errno='9029'    #此筆資料尚未確認, 不可使用
            WHEN l_imoconf='X'       LET g_errno='9024'    #此筆資料已作廢
            WHEN l_imopost='N'       LET g_errno='aim-206  #單據尚未過帳!            OTHERWISE                 LET g_errno=SQLCA.sqlcode USING '------'
        END CASE
         LET g_imq[l_ac].imq05=g_imq[l_ac].imp03 #MOD-570302
         DISPLAY BY NAME g_imq[l_ac].imp03
         DISPLAY BY NAME g_imq[l_ac].ima02s
         DISPLAY BY NAME g_imq[l_ac].imp05
         DISPLAY BY NAME g_imq[l_ac].imp04
         DISPLAY BY NAME g_imq[l_ac].imq05
         IF p_cmd = 'a' THEN
           LET g_imq[l_ac].imq08 = l_imq08
           LET g_imq[l_ac].imq09 = l_imq09
           LET g_imq[l_ac].imq10 = l_imq10
           DISPLAY BY NAME g_imq[l_ac].imq08    
           DISPLAY BY NAME g_imq[l_ac].imq09
           DISPLAY BY NAME g_imq[l_ac].imq10  
         END IF
         IF p_cmd <> 'a' THEN    #MOD-860030 add
         IF cl_null(g_imq_t.imq04) OR g_imq_t.imq04 <> g_imq[l_ac].imq04 THEN  #TQC-750018
           LET g_imq[l_ac].imq08 = l_ima35    #TQC-750018
           LET g_imq[l_ac].imq09 = l_ima36    #TQC-750018
           LET g_imq[l_ac].imq10 = ' '        #MOD-860030  add
           DISPLAY BY NAME g_imq[l_ac].imq08    #CHI-6A0015
           DISPLAY BY NAME g_imq[l_ac].imq09    #CHI-6A0015
           DISPLAY BY NAME g_imq[l_ac].imq10    #TQC-750018
         END IF                               #TQC-750018
         END IF     #MOD-860030 add
 
         CALL t309_imq05('a') #MOD-570302
END FUNCTION
 
FUNCTION t309_imr03(p_cmd)    #人員
  DEFINE p_cmd       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
         l_gen02     LIKE gen_file.gen02,
         l_gen03     LIKE gen_file.gen03,
         l_gem02     LIKE gem_file.gem02,
         l_genacti   LIKE gen_file.genacti
 
  LET g_errno = ' '
  SELECT   gen02,      gen03,  gem02,  genacti
    INTO l_gen02,l_gen03,l_gem02,l_genacti
    FROM gen_file, OUTER gem_file WHERE gen01 = g_imr.imr03
                                     AND gen_file.gen03 = gem_file.gem01
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                 LET l_gen02 = NULL
       WHEN l_genacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF p_cmd='d' THEN
     DISPLAY l_gen02 TO FORMONLY.gen02
  END IF
  IF p_cmd='a' THEN
     DISPLAY l_gen02 TO FORMONLY.gen02
     LET g_imr.imr04 = l_gen03
     DISPLAY l_gen03 TO imr04
     DISPLAY l_gem02 TO FORMONLY.gem02
  END IF
END FUNCTION
{
FUNCTION t309_imr03(p_cmd)    #人員
  DEFINE p_cmd       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
         l_gen02     LIKE gen_file.gen02,
         l_genacti   LIKE gen_file.genacti
 
  LET g_errno = ' '
  SELECT gen02,genacti INTO l_gen02,l_genacti
    FROM gen_file WHERE gen01 = g_imr.imr03
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                 LET l_gen02 = NULL
       WHEN l_genacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF p_cmd='d' OR cl_null(g_errno) THEN
     DISPLAY l_gen02 TO FORMONLY.gen02
  END IF
END FUNCTION
}
FUNCTION t309_imr04(p_cmd)    #部門編號
  DEFINE p_cmd       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
         l_gem02     LIKE gem_file.gem02,
         l_gemacti   LIKE gem_file.gemacti
 
  LET g_errno = ' '
  SELECT gem02,gemacti INTO l_gem02,l_gemacti
    FROM gem_file
   WHERE gem01 = g_imr.imr04
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
                                 LET l_gem02 = NULL
       WHEN l_gemacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF p_cmd='d' OR cl_null(g_errno) THEN
     DISPLAY l_gem02 TO FORMONLY.gem02
  END IF
END FUNCTION
 
FUNCTION t309_imq05(p_cmd)    #還料編號
  DEFINE p_cmd       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
         l_ima02     LIKE ima_file.ima02,
         l_imaacti   LIKE ima_file.imaacti
 
  LET g_errno = ' '
  SELECT ima02,imaacti INTO g_imq[l_ac].ima02e,l_imaacti
    FROM ima_file
   WHERE ima01 = g_imq[l_ac].imq05
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
                                 LET l_ima02 = NULL
       WHEN l_imaacti='N' LET g_errno = '9028'
       WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION
 
 
FUNCTION t309_b_g()   #自動代出未全數償還之借料單身
  DEFINE  l_imp_g         RECORD LIKE imp_file.*,  #產生用,借料資料單身檔
          l_imq_g         RECORD LIKE imq_file.*,  #產生用,還料明細資料檔
          l_n             LIKE type_file.num10,   #No.FUN-690026 INTEGER
          l_qty2          LIKE img_file.img10,     #No.FUN-570249
          l_qty1          LIKE img_file.img10,     #No.FUN-570249
          l_qty2_n        LIKE img_file.img10,     #No.FUN-570249
          l_qty1_n        LIKE img_file.img10,     #No.FUN-570249
          l_imp04_08      LIKE imp_file.imp04,
          l_imq12         LIKE imq_file.imq12,
          l_keyinyes      LIKE imq_file.imq07, #MOD-530179 #已登打數量
          l_keyinno       LIKE imq_file.imq07  #MOD-530179 #未登打數量
  DEFINE  l_ima35         LIKE ima_file.ima35,  #CHI-6A0015
          l_ima36         LIKE ima_file.ima36   #CHI-6A0015
 
   IF cl_null(g_imr.imr05) THEN
       RETURN
   END IF
   SELECT COUNT(*) INTO l_n FROM imq_file
    WHERE imq01 = g_imr.imr01
   IF l_n > 0 THEN
       RETURN
   END IF
   #自動代出未全數償還之借料單身(Y/N)?
   IF NOT cl_confirm('aim-415') THEN RETURN END IF
   DECLARE imp_cur_g CURSOR FOR
    SELECT * FROM imp_file
     WHERE imp01 = g_imr.imr05
       AND imp07 !='Y'
   BEGIN WORK
   LET g_success = 'Y'
   LET g_cnt = 1
   FOREACH imp_cur_g INTO l_imp_g.*
       IF SQLCA.sqlcode THEN LET g_success = 'N' EXIT FOREACH END IF
       IF cl_null(l_imp_g.imp09) THEN
           LET l_imp_g.imp09 = 0
       END IF
       SELECT SUM(imq07/imq06_fac)
         INTO l_keyinyes                          #已登打的數量
         FROM imq_file,imr_file
        WHERE imq03 = l_imp_g.imp01
          AND imq04 = l_imp_g.imp02
          AND imrconf <> 'X' #作廢的不算 #FUN-660080
          AND imr01 = imq01
       IF cl_null(l_keyinyes) THEN
           LET l_keyinyes = 0
       END IF
       LET l_keyinno = l_imp_g.imp04 - l_keyinyes #未登打數量
       IF l_keyinno<=0 THEN
           CONTINUE FOREACH
       END IF
       LET l_imq12   = l_keyinno * l_imp_g.imp09  #實償金額
       IF g_sma.sma115='Y' THEN
          SELECT SUM(imq25),SUM(imq22)
            INTO l_qty2,l_qty1
            FROM imq_file,imr_file
           WHERE imq03 = l_imp_g.imp01
             AND imq04 = l_imp_g.imp02
             AND imrconf <> 'X' #作廢的不算 #FUN-660080
             AND imr01 = imq01
          IF cl_null(l_qty2) THEN
              LET l_qty2 = 0
          END IF
          LET l_qty2_n = l_imp_g.imp25 - l_qty2
          IF cl_null(l_qty1) THEN
              LET l_qty1 = 0
          END IF
          LET l_qty1_n = l_imp_g.imp22 - l_qty1
       END IF
      SELECT ima35,ima36 INTO l_ima35,l_ima36 FROM ima_file
       WHERE ima01 = l_imp_g.imp03
      IF SQLCA.sqlcode THEN
         LET l_ima35 = NULL
         LET l_ima36 = NULL
      END IF
 
        INSERT INTO imq_file (imq01,imq02,imq03,imq04,imq05,imq06,imq06_fac,  #No.MOD-470041
                             imq07,imq08,imq09,imq10,imq11,imq12,imq13,imq14,
                             imq15,imq16,imq17,imq18,imq19,imq20,
                             imq21,imq22,imq26,imq23,imq24,imq25,imqplant,imqlegal) #FUN-980004 add imqplant,imqlegal  #FUN-CB0087 add>imq26 在imq22后
            VALUES (g_imr.imr01,g_cnt,l_imp_g.imp01,l_imp_g.imp02,
                    l_imp_g.imp03,l_imp_g.imp05,1,l_keyinno,l_imp_g.imp11,l_imp_g.imp12,         #MOD-860030
                    l_imp_g.imp13,l_imp_g.imp09,l_imq12,NULL,NULL,'N',NULL,                      #MOD-860030 
                    NULL,NULL,NULL,l_imp_g.imp20,l_imp_g.imp21,l_qty1_n,l_imp_g.imp16,           #FUN-CB0087 add>imp16 最后加  l_imp_g.imp16
                    l_imp_g.imp23,l_imp_g.imp24,l_qty2_n,g_plant,g_legal) #FUN-980004 add g_plant,g_legal
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","imq_file",g_imr.imr01,"",SQLCA.sqlcode,"",
                       "",1)   #No.FUN-660156
          LET g_success = 'N'
          EXIT FOREACH
       #FUN-B30187 --START--              
       ELSE
          LET b_imqi.imqi01 = g_imr.imr01
          LET b_imqi.imqi02 = g_cnt
          LET b_imqi.imqiicd028 = ' '
          LET b_imqi.imqiicd029 = ' '
          LET b_imqi.imqilegal = g_legal
          LET b_imqi.imqiplant = g_plant              
          IF NOT s_ins_imqi(b_imqi.*,g_plant) THEN
             LET g_success = 'N'
             EXIT FOREACH
          END IF
       #FUN-B30187 --END--
       END IF
       LET g_cnt = g_cnt + 1
   END FOREACH
   IF g_success = 'Y' THEN
       COMMIT WORK
   ELSE
       ROLLBACK WORK
   END IF
   LET g_change1='Y' #No.FUN-570249
   CALL t309_show()
END FUNCTION
 
#單頭
FUNCTION t309_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("imr01",TRUE)
   END IF
   IF g_str='y' THEN
       CALL cl_set_comp_entry("imr09",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t309_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("imr01",FALSE)
       END IF
   END IF
   IF g_str='n' THEN
       CALL cl_set_comp_entry("imr09",FALSE)
   END IF
 
END FUNCTION
 
#單身
FUNCTION t309_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("imq08,imq09,imq10",TRUE)
   END IF
 
   IF g_ima906 = '1' THEN
      CALL cl_set_comp_entry("imp20,imp22,imq20,imq22",TRUE)
   END IF
   IF g_ima906 = '2' THEN
      CALL cl_set_comp_entry("imq23,imq25,imq20,imq22,imp23,imp25,imp20,imp22",TRUE)
   END IF
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_entry("imq25,imp25",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t309_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF g_sma.sma12 != 'Y' THEN
           CALL cl_set_comp_entry("imq08,imq09,imq10",FALSE)
       END IF
   END IF
   IF g_ima906 = '1' THEN
      CALL cl_set_comp_entry("imq23,imq25,imp23,imp25",FALSE) #TQC-7A0096 add imp23,imp25
   END IF
   #參考單位，每個料件只有一個，所以不開放讓用戶輸入
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_entry("imq23,imp23",FALSE)  #TQC-7A0096
   END IF
 
END FUNCTION
 
FUNCTION t309_mu_ui()
    CALL cl_set_comp_visible("imq21,imq24",FALSE)
    CALL cl_set_comp_visible("imp20,imp23,imp22,imp25,imq20,imq23,imq22,imq25",g_sma.sma115='Y')
    CALL cl_set_comp_visible("imp04,imp05,imq07,imq06,imq06_fac",g_sma.sma115='N')
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imp23",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imp25",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imp20",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imp22",g_msg CLIPPED)
 
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imq23",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imq25",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imq20",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imq22",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imp23",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imp25",g_msg CLIPPED)
       CALL cl_getmsg('asm-397',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imp20",g_msg CLIPPED)
       CALL cl_getmsg('asm-398',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imp22",g_msg CLIPPED)
 
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imq23",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imq25",g_msg CLIPPED)
       CALL cl_getmsg('asm-400',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imq20",g_msg CLIPPED)
       CALL cl_getmsg('asm-401',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imq22",g_msg CLIPPED)
    END IF
    CALL cl_set_comp_visible("imq930,gem02c",g_aaz.aaz90='Y')  #FUN-670093
 
    IF g_aza.aza64 matches '[ Nn]' THEN
       CALL cl_set_comp_visible("imrspc",FALSE)
       CALL cl_set_act_visible("trans_spc",FALSE)
    END IF 
 
END FUNCTION
 
#用于default 雙單位/轉換率/數量
FUNCTION t309_du_default(p_cmd)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ware   LIKE img_file.img02,     #倉庫
            l_loc    LIKE img_file.img03,     #儲
            l_lot    LIKE img_file.img04,     #批
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_unit2  LIKE img_file.img09,     #第二單位
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_unit1  LIKE img_file.img09,     #第一單位
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            p_cmd    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
            l_factor LIKE ima_file.ima31_fac  #No.FUN-690026 DECIMAL(16,8)
 
    LET l_item = g_imq[l_ac].imq05
    LET l_ware = g_imq[l_ac].imq08
    LET l_loc  = g_imq[l_ac].imq09
    LET l_lot  = g_imq[l_ac].imq10
 
    SELECT ima25,ima906,ima907 INTO l_ima25,l_ima906,l_ima907
      FROM ima_file WHERE ima01 = l_item
 
    SELECT img09 INTO g_img09 FROM img_file
     WHERE img01 = l_item
       AND img02 = l_ware
       AND img03 = l_loc
       AND img04 = l_lot
    IF cl_null(g_img09) THEN LET g_img09 = l_ima25 END IF
 
    IF l_ima906 = '1' THEN  #不使用雙單位
       LET l_unit2 = NULL
       LET l_fac2  = NULL
       LET l_qty2  = NULL
    ELSE
       LET l_unit2 = l_ima907
       CALL s_du_umfchk(l_item,'','','',g_img09,l_ima907,l_ima906)
            RETURNING g_errno,l_factor
       LET l_fac2 = l_factor
       LET l_qty2  = 0
    END IF
    LET l_unit1 = g_img09
    LET l_fac1  = 1
    LET l_qty1  = 0
 
    IF p_cmd = 'a' OR (g_change = 'Y' AND g_change1<>'Y') THEN
       LET g_imq[l_ac].imq23 =l_unit2
       LET g_imq[l_ac].imq24 =l_fac2
       LET g_imq[l_ac].imq25 =l_qty2
       LET g_imq[l_ac].imq20 =l_unit1
       LET g_imq[l_ac].imq21 =l_fac1
       LET g_imq[l_ac].imq22 =l_qty1
    END IF
END FUNCTION
 
FUNCTION t309_update_du(p_type)
DEFINE l_ima25   LIKE ima_file.ima25
DEFINE p_type    LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
   SELECT ima906,ima907 INTO g_ima906,g_ima907 FROM ima_file
    WHERE ima01 = b_imq.imq05
   IF g_ima906 = '1' OR g_ima906 IS NULL THEN
      RETURN
   END IF
 
   SELECT ima25 INTO l_ima25 FROM ima_file
    WHERE ima01=b_imq.imq05
   IF SQLCA.sqlcode THEN
      LET g_success='N' RETURN
   END IF
   IF g_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(b_imq.imq25) THEN                                             #CHI-860005
         CALL t309_upd_imgg('1',b_imq.imq05,b_imq.imq08,b_imq.imq09,
                         b_imq.imq10,b_imq.imq23,b_imq.imq24,b_imq.imq25,'2',p_type)
         IF g_success='N' THEN RETURN END IF
         IF p_type=-1 THEN
            CALL t309_tlff(b_imq.imq08,b_imq.imq09,b_imq.imq10,l_ima25,
                           b_imq.imq25,0,b_imq.imq23,b_imq.imq24,'2')
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
      IF NOT cl_null(b_imq.imq22) THEN                                             #CHI-860005
         CALL t309_upd_imgg('1',b_imq.imq05,b_imq.imq08,b_imq.imq09,
                         b_imq.imq10,b_imq.imq20,b_imq.imq21,b_imq.imq22,'1',p_type)
         IF g_success='N' THEN RETURN END IF
         IF p_type=-1 THEN
            CALL t309_tlff(b_imq.imq08,b_imq.imq09,b_imq.imq10,l_ima25,
                           b_imq.imq22,0,b_imq.imq20,b_imq.imq21,'1')
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
   IF g_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(b_imq.imq25) THEN                                             #CHI-860005
         CALL t309_upd_imgg('2',b_imq.imq05,b_imq.imq08,b_imq.imq09,
                         b_imq.imq10,b_imq.imq23,b_imq.imq24,b_imq.imq25,'2',p_type)
         IF g_success = 'N' THEN RETURN END IF
         IF p_type=-1 THEN
            CALL t309_tlff(b_imq.imq08,b_imq.imq09,b_imq.imq10,l_ima25,
                           b_imq.imq25,0,b_imq.imq23,b_imq.imq24,'2')
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t309_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg211,p_imgg10,p_no,p_type)
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
         p_no       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
         p_type     LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
    LET g_forupd_sql =
        "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
        "   WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
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
       CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"",
                    "ima25 null",1)   #No.FUN-660156
       LET g_success = 'N' RETURN
    END IF
 
    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
          RETURNING g_cnt,l_imgg21
    IF g_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
       CALL cl_err('','mfg3075',0)
       LET g_success = 'N' RETURN
    END IF
 
    CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,g_imr.imr02,#FUN-8C0084
          p_imgg01,p_imgg02,p_imgg03,p_imgg04,'','','','',p_imgg09,'',l_imgg21,'','','','','','','',p_imgg211)
    IF g_success='N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t309_tlff(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
                   p_flag)
DEFINE
   p_ware     LIKE img_file.img02,	 ##倉庫
   p_loca     LIKE img_file.img03,	 ##儲位
   p_lot      LIKE img_file.img04,     	 ##批號
   p_unit     LIKE img_file.img09,
   p_qty      LIKE img_file.img10,       ##數量
   p_img10    LIKE img_file.img10,       ##異動後數量
   p_uom      LIKE img_file.img09,       ##img 單位
   p_factor   LIKE img_file.img21,  	 ##轉換率
   l_imgg10   LIKE imgg_file.imgg10,
   p_flag     LIKE type_file.chr1,       #No.FUN-690026 VARCHAR(1)
   l_imo05    LIKE imo_file.imo05,
   g_cnt      LIKE type_file.num5        #No.FUN-690026 SMALLINT
 
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' '  END IF
    IF cl_null(p_qty)  THEN LET p_qty=0    END IF
 
    IF p_uom IS NULL THEN
       CALL cl_err('p_uom null:','asf-031',1) LET g_success = 'N' RETURN
    END IF
 
    SELECT imgg10 INTO l_imgg10 FROM imgg_file
     WHERE imgg01=b_imq.imq05 AND imgg02=p_ware
       AND imgg03=p_loca      AND imgg04=p_lot
       AND imgg09=p_uom
    IF cl_null(l_imgg10) THEN LET l_imgg10 = 0 END IF
    INITIALIZE g_tlff.* TO NULL
#----來源----
    LET g_tlff.tlff01=b_imq.imq05 	 #異動料件編號
    LET g_tlff.tlff02=50         	 #資料來源為倉庫
    LET g_tlff.tlff020=g_plant           #工廠別
    LET g_tlff.tlff021=b_imq.imq08  	 #倉庫別
    LET g_tlff.tlff022=b_imq.imq09  	 #儲位別
    LET g_tlff.tlff023=b_imq.imq10  	 #入庫批號
    IF g_sma.sma12 = 'Y' THEN
        LET g_tlff.tlff024=l_imgg10
        LET g_tlff.tlff025=g_img09
    ELSE
#       LET g_tlff.tlff024=g_ima262-p_qty  #NO.FUN-A20044
        LET g_tlff.tlff024=g_avl_stk-p_qty #NO.FUN-A20044
        LET g_tlff.tlff025=g_ima25
    END IF
    LET g_tlff.tlff026=g_imr.imr01         #參考單据
    LET g_tlff.tlff027=b_imq.imq02
#----目的----
    LET g_tlff.tlff03=80         	   #資料來源為倉庫
    LET g_tlff.tlff030=g_plant             #工廠別
    LET g_tlff.tlff031=' '                 #倉庫別
    LET g_tlff.tlff032=' '                 #儲位別
    LET g_tlff.tlff033=' '                 #批號
    LET g_tlff.tlff034=' '                 #異動後庫存數量
    LET g_tlff.tlff035=' '                 #庫存單位(ima_file or imr_file)
    LET g_tlff.tlff036=b_imq.imq03         #還料單號
    LET g_tlff.tlff037=b_imq.imq04         #還料項次
#--->異動數量
    LET g_tlff.tlff04=' '                  #工作站
    LET g_tlff.tlff05=' '                  #作業序號
    LET g_tlff.tlff06=g_imr.imr02          #還料日期
    LET g_tlff.tlff07=g_today              #異動資料產生日期
    LET g_tlff.tlff08=TIME                 #異動資料產生時:分:秒
    LET g_tlff.tlff09=g_user               #產生人
    LET g_tlff.tlff10=p_qty                #還料數量
    LET g_tlff.tlff11=p_uom                #還料單位
    LET g_tlff.tlff12=p_factor             #轉換率
    LET g_tlff.tlff13='aimt309'            #異動命令代號
    LET g_tlff.tlff14=' '                  #異動原因
    IF g_sma.sma12='Y'                     #貸方會計科目
       THEN LET g_tlff.tlff16=g_ima39      #料件會計科目
       ELSE LET g_tlff.tlff16=g_img26      #倉儲會計科目
    END IF
    SELECT imo05 INTO l_imo05
      FROM imo_file
     WHERE imo01 = b_imq.imq03
    LET g_tlff.tlff15=l_imo05              #貸方會計科目
    LET g_tlff.tlff17=' '                  #非庫存性料件編號
    CALL s_imaQOH(b_imq.imq05)
         RETURNING g_tlff.tlff18           #異動後總庫存量
    LET g_tlff.tlff19= ' '                 #異動廠商/客戶編號
    LET g_tlff.tlff20= ' '                 #project no.
    IF cl_null(b_imq.imq25) OR b_imq.imq25=0 THEN
       CALL s_tlff(p_flag,NULL)
    ELSE
       CALL s_tlff(p_flag,b_imq.imq23)
    END IF
END FUNCTION
 
FUNCTION t309_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE imn_file.imn34,
            l_qty2   LIKE imn_file.imn35,
            l_fac1   LIKE imn_file.imn31,
            l_qty1   LIKE imn_file.imn32,
            l_factor LIKE ima_file.ima31_fac  #No.FUN-690026 DECIMAL(16,8)
 
    IF g_sma.sma115='N' THEN RETURN END IF
    LET l_fac2=g_imq[l_ac].imq24
    LET l_qty2=g_imq[l_ac].imq25
    LET l_fac1=g_imq[l_ac].imq21
    LET l_qty1=g_imq[l_ac].imq22
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_imq[l_ac].imq06=g_imq[l_ac].imq20
                   LET g_imq[l_ac].imq07=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_imq[l_ac].imq06=g_img09
                   LET g_imq[l_ac].imq07=l_tot
          WHEN '3' LET g_imq[l_ac].imq06=g_imq[l_ac].imq20
                   LET g_imq[l_ac].imq07=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_imq[l_ac].imq24 =l_qty1/l_qty2
                   ELSE
                      LET g_imq[l_ac].imq24 =0
                   END IF
       END CASE
    END IF
 
END FUNCTION
 
FUNCTION t309_set_required()
 
  #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
  IF g_ima906 = '3' THEN
     CALL cl_set_comp_required("imq23,imq25,imq20,imq22",TRUE)
  END IF
  #單位不同,轉換率,數量必KEY
  IF NOT cl_null(g_imq[l_ac].imq20) THEN
     CALL cl_set_comp_required("imq22",TRUE)
  END IF
  IF NOT cl_null(g_imq[l_ac].imq23) THEN
     CALL cl_set_comp_required("imq25",TRUE)
  END IF
 
END FUNCTION
 
FUNCTION t309_set_no_required()
 
  CALL cl_set_comp_required("imq23,imq25,imq20,imq22",FALSE)
 
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t309_du_data_to_correct()
 
   IF cl_null(g_imq[l_ac].imq23) THEN
      LET g_imq[l_ac].imq24 = NULL
      LET g_imq[l_ac].imq25 = NULL
   END IF
 
   IF cl_null(g_imq[l_ac].imq20) THEN
      LET g_imq[l_ac].imq21 = NULL
      LET g_imq[l_ac].imq22 = NULL
   END IF
   DISPLAY BY NAME g_imq[l_ac].imq21
   DISPLAY BY NAME g_imq[l_ac].imq22
   DISPLAY BY NAME g_imq[l_ac].imq24
   DISPLAY BY NAME g_imq[l_ac].imq25
 
END FUNCTION
 
FUNCTION t309_y_chk()
DEFINE l_cnt LIKE type_file.num10   #No.FUN-690026 INTEGER
#FUN-A80106 add --start--
DEFINE l_flag      LIKE type_file.chr1
#DEFINE l_imaicd08  LIKE imaicd_file.imaicd08   #FUN-BA0051 mark
#FUN-A80106 add --end--
#FUN-C50071 add begin-------------------------
DEFINE l_rvbs06       LIKE rvbs_file.rvbs06
DEFINE l_imq06_fac    LIKE imq_file.imq06_fac
#FUN-C50071 add -end--------------------------

   LET g_success = 'Y'
#CHI-C30107 ----------- add ----------- begin
   IF cl_null(g_imr.imr01) THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_imr.imrconf='Y' THEN
      LET g_success = 'N'
      CALL cl_err('','9023',0)
      RETURN
   END IF

   IF g_imr.imrconf = 'X' THEN
      LET g_success = 'N'
      CALL cl_err(' ','9024',0)
      RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF
#CHI-C30107 ---------- add ------------ end
   IF cl_null(g_imr.imr01) THEN 
      CALL cl_err('',-400,0) 
      LET g_success = 'N'
      RETURN 
   END IF
 
   SELECT * INTO g_imr.* FROM imr_file WHERE imr01 = g_imr.imr01
   IF g_imr.imrconf='Y' THEN
      LET g_success = 'N'           
      CALL cl_err('','9023',0)      
      RETURN
   END IF
 
   IF g_imr.imrconf = 'X' THEN
      LET g_success = 'N'   
      CALL cl_err(' ','9024',0)
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM imr_file
      WHERE imr01= g_imr.imr01
   IF l_cnt = 0 THEN
      LET g_success = 'N'
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
#No.FUN-AB0067--begin 
   CALL s_showmsg_init() 
   DECLARE t309_chk_ware CURSOR FOR SELECT * FROM imq_file
                                   WHERE imq01=g_imr.imr01
   FOREACH t309_chk_ware INTO b_imq.* 
      IF NOT s_chk_ware(b_imq.imq08) THEN
         LET g_success='N' 
      END IF       
#FUN-C50071 add begin-------------------------
      SELECT ima918,ima921 INTO g_ima918,g_ima921
        FROM ima_file
       WHERE ima01 = g_imq[l_ac].imq05
         AND imaacti = "Y"

      IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
         SELECT SUM(rvbs06) INTO l_rvbs06
           FROM rvbs_file
          WHERE rvbs00 = g_prog
            AND rvbs01 = g_imr.imr01
            AND rvbs02 = g_imq[l_ac].imq02
            AND rvbs13 = 0
            AND rvbs09 = -1

         IF cl_null(l_rvbs06) THEN
            LET l_rvbs06 = 0
         END IF

         SELECT img09 INTO g_img09 FROM img_file
          WHERE img01 = g_imq[l_ac].imq05
            AND img02 = g_imq[l_ac].imq08
            AND img03 = g_imq[l_ac].imq09
            AND img04 = g_imq[l_ac].imq10

         CALL s_umfchk(g_imq[l_ac].imq05,g_imq[l_ac].imq06,g_img09)
            RETURNING l_i,l_imq06_fac
         IF l_i = 1 THEN LET l_imq06_fac = 1 END IF

         IF (g_imq[l_ac].imq07 * l_imq06_fac) <> l_rvbs06 THEN
            LET g_success = "N"
            CALL cl_err(g_imq[l_ac].imq05,"aim-011",1)
            EXIT FOREACH
         END IF
      END IF
      #FUN-CB0087---add---atr
      IF g_aza.aza115 = 'Y' AND cl_null(g_imq[l_ac].imq26) THEN
         LET g_success = "N"
         CALL cl_err('','aim-888',1)
         EXIT FOREACH
      END IF
      #FUN-CB0087---add---end
#FUN-C50071 add -end--------------------------
   END FOREACH    
   CALL s_showmsg()
   LET g_bgerr=0 
   IF g_success='N' THEN 
      RETURN 
   END IF    
#No.FUN-AB0067--end 

  #TQC-750130 此段搬到確認時判斷
    SELECT COUNT(*) INTO g_cnt
      FROM imq_file
     WHERE imq01=g_imr.imr01
       AND (imq08 IS NULL OR imq08 = ' ' OR imq09 IS NULL OR imq10 IS NULL
           )
    IF g_cnt >=1 THEN
        #單身還料倉/儲/批欄位不可空白!
        LET g_success = 'N'
        CALL cl_err(g_imr.imr01,'aim-316',0)
        RETURN
    END IF
    
#FUN-A80106 add --start--
   DECLARE t309_y_chk_c CURSOR FOR SELECT * FROM imq_file
                                   WHERE imq01=g_imr.imr01
   FOREACH t309_y_chk_c INTO b_imq.*     
      #FUN-BA0051 --START mark--   
      #LET l_imaicd08 = NULL
      #SELECT imaicd08 INTO l_imaicd08
      #  FROM imaicd_file
      # WHERE imaicd00 = b_imq.imq05
      # IF l_imaicd08 = 'Y' THEN
      #FUN-BA0051 --END mark--
      IF s_icdbin(b_imq.imq05) THEN   #FUN-BA0051      
          CALL s_icdchk(-1,b_imq.imq05,
                          b_imq.imq08,
                          b_imq.imq09, 
                          b_imq.imq10, 
                          b_imq.imq07, 
                          b_imq.imq01, 
                          b_imq.imq02, 
                          g_imr.imr02,'')  #FUN-B80119--傳入p_plant參數''---
                  RETURNING l_flag
          IF l_flag = 0 THEN
             CALL cl_err(b_imq.imq02,'aic-056',1)
             LET g_success = 'N'
             RETURN
          END IF
       END IF            
   END FOREACH 
#FUN-A80106 add --end--      
 
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION
 
FUNCTION t309_y_upd()
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 mark
   LET g_success = 'Y'
   BEGIN WORK
 
   OPEN t309_cl USING g_imr.imr01
   IF STATUS THEN
      CALL cl_err("OPEN t309_cl:", STATUS, 1)
      CLOSE t309_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t309_cl INTO g_imr.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_imr.imr01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t309_cl 
       ROLLBACK WORK 
       RETURN
   END IF
   CLOSE t309_cl
   UPDATE imr_file SET imrconf = 'Y' WHERE imr01 = g_imr.imr01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","imr_file",g_imr.imr01,"",SQLCA.sqlcode,"",
                   "upd umrconf",1)   #No.FUN-660156
      LET g_success = 'N'
   END IF
 
   IF g_success='Y' THEN
      COMMIT WORK
      LET g_imr.imrconf='Y'
      CALL cl_flow_notify(g_imr.imr01,'Y')
   ELSE
      ROLLBACK WORK
      LET g_imr.imrconf='N'
   END IF
   DISPLAY BY NAME g_imr.imrconf
   IF g_imr.imrconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_imr.imrconf,"",g_imr.imrpost,"",g_chr,"")
END FUNCTION
 
FUNCTION t309_z()
   DEFINE l_cnt     LIKE type_file.num5      #FUN-680010  #No.FUN-690026 SMALLINT
 
   IF cl_null(g_imr.imr01) THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_imr.* FROM imr_file WHERE imr01 = g_imr.imr01
   IF g_imr.imrconf='N' THEN RETURN END IF
   IF g_imr.imrconf='X' THEN CALL cl_err(' ','9024',0) RETURN END IF
 
   #-->已有QC單則不可取消確認
   SELECT COUNT(*) INTO l_cnt FROM qcs_file
    WHERE qcs01 = g_imr.imr01 AND qcs00='F'  
   IF l_cnt > 0 THEN
      CALL cl_err(' ','aqc-118',0)
      RETURN
   END IF
 
   IF g_imr.imrpost='Y' THEN
      CALL cl_err('imr03=Y:','afa-101',0)
      RETURN
   END IF
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
 
   OPEN t309_cl USING g_imr.imr01
   IF STATUS THEN
      CALL cl_err("OPEN t309_cl:", STATUS, 1)
      CLOSE t309_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t309_cl INTO g_imr.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_imr.imr01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t309_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   CLOSE t309_cl
   LET g_success = 'Y'
   UPDATE imr_file SET imrconf = 'N' WHERE imr01 = g_imr.imr01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
      LET g_success = 'N' 
   END IF
   IF g_success = 'Y' THEN
      LET g_imr.imrconf='N'
      COMMIT WORK
      DISPLAY BY NAME g_imr.imrconf
   ELSE
      LET g_imr.imrconf='Y'
      ROLLBACK WORK
   END IF
   IF g_imr.imrconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_imr.imrconf,"",g_imr.imrpost,"",g_chr,"")
END FUNCTION
 
FUNCTION t309_spc()
DEFINE l_gaz03        LIKE gaz_file.gaz03
DEFINE l_cnt          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE l_qc_cnt       LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE l_imq02        LIKE imq_file.imq02    ## 項次
DEFINE l_qcs          DYNAMIC ARRAY OF RECORD LIKE qcs_file.*
DEFINE l_qc_prog      LIKE zz_file.zz01      #No.FUN-690026 VARCHAR(10)
DEFINE l_i            LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE l_cmd          STRING
DEFINE l_sql          STRING
DEFINE l_err          STRING
 
   LET g_success = 'Y'
 
   #檢查資料是否可拋轉至 SPC
   IF g_imr.imrpost matches '[Yy]' THEN    #判斷是否已過帳
      CALL cl_err('imrpost','aim-318',0)
      LET g_success='N'
      RETURN
   END IF
 
   CALL aws_spccli_check(g_imr.imr01,g_imr.imrspc,g_imr.imrconf,'')
   IF g_success = 'N' THEN
      RETURN
   END IF
 
   LET l_qc_prog = "aqct700"               #設定QC單的程式代號
 
   #若在 QC 單已有此單號相關資料，則取消拋轉至 SPC
   SELECT COUNT(*) INTO l_cnt FROM qcs_file WHERE qcs01 = g_imr.imr01  
   IF l_cnt > 0 THEN
      CALL cl_get_progname(l_qc_prog,g_lang) RETURNING l_gaz03
      CALL cl_err_msg(g_imr.imr01,'aqc-115', l_gaz03 CLIPPED || "|" || l_qc_prog CLIPPED,'1')
      LET g_success='N'
      RETURN
   END IF
  
   #需要 QC 檢驗的筆數
   SELECT COUNT(*) INTO l_qc_cnt FROM imq_file 
    WHERE imq01 = g_imr.imr01 AND imq15 = 'Y' 
   IF l_qc_cnt = 0 THEN 
      CALL cl_err(g_imr.imr01,l_err,0) 
      LET g_success='N'
      RETURN
   END IF
 
   #需檢驗的資料，自動新增資料至 QC 單 ,功能參數為「SPC」
   LET l_sql  = "SELECT imq02 FROM imq_file                   WHERE imq01 = '",g_imr.imr01,"' AND imq15='Y'"
   PREPARE t309_imq_p FROM l_sql
   DECLARE t309_imq_c CURSOR WITH HOLD FOR t309_imq_p
   FOREACH t309_imq_c INTO l_imq02
       display l_cmd
       LET l_cmd = l_qc_prog CLIPPED," '",g_imr.imr01,"' '",l_imq02,"' '1' 'SPC' 'F'"
       CALL cl_cmdrun_wait(l_cmd)
   END FOREACH 
 
   #判斷產生的 QC 單筆數是否正確
   SELECT COUNT(*) INTO l_cnt FROM qcs_file WHERE qcs01 = g_imr.imr01
   IF l_cnt <> l_qc_cnt THEN
      CALL t309_qcs_del()
      LET g_success='N'
      RETURN
   END IF
 
   LET l_sql  = "SELECT *  FROM qcs_file WHERE qcs01 = '",g_imr.imr01,"'"
   PREPARE t309_qc_p FROM l_sql
   DECLARE t309_qc_c CURSOR WITH HOLD FOR t309_qc_p
   LET l_cnt = 1
   FOREACH t309_qc_c INTO l_qcs[l_cnt].*
       LET l_cnt = l_cnt + 1 
   END FOREACH
   CALL l_qcs.deleteElement(l_cnt)
 
   # CALL aws_spccli() 
   #功能: 傳送此單號所有的 QC 單至 SPC 端
   # 傳入參數: (1) QC 程式代號, (2) QC 單頭資料,
   # 回傳值  : 0 傳送失敗; 1 傳送成功
   IF aws_spccli(l_qc_prog,base.TypeInfo.create(l_qcs),"insert") THEN
      LET g_imr.imrspc = '1'
   ELSE
      LET g_imr.imrspc = '2'
      CALL t309_qcs_del()
   END IF
 
   UPDATE imr_file set imrspc = g_imr.imrspc WHERE imr01 = g_imr.imr01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","imr_file",g_imr.imr01,"",STATUS,"","upd imrspc",1)
      IF g_imr.imrspc = '1' THEN
          CALL t309_qcs_del()
      END IF
      LET g_success = 'N'
   END IF
   DISPLAY BY NAME g_imr.imrspc
  
END FUNCTION 
 
FUNCTION t309_qcs_del()
 
      DELETE FROM qcs_file WHERE qcs01 = g_imr.imr01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcs_file",g_imr.imr01,"",SQLCA.sqlcode,"","DEL qcs_filee err!",0)
      END IF
 
      DELETE FROM qct_file WHERE qct01 = g_imr.imr01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qct_file",g_imr.imr01,"",SQLCA.sqlcode,"","DEL qct_filee err!",0)
      END IF
 
      DELETE FROM qcu_file WHERE qcu01 = g_imr.imr01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcu_file",g_imr.imr01,"",SQLCA.sqlcode,"","DEL qcu_filee err!",0)
      END IF
 
      DELETE FROM qctt_file WHERE qctt01 = g_imr.imr01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qctt_file",g_imr.imr01,"",SQLCA.sqlcode,"","DEL qcstt_filee err!",0)
      END IF
 
END FUNCTION 
#No.FUN-9C0072 精簡程式碼

#FUN-A80106 add --start--
#檢查是否有ida/idb存在--(S)
FUNCTION t309_ind_icd_chk_icd()
     LET g_cnt = 0
     LET g_errno = ' '
     #出庫
     SELECT COUNT(*) INTO g_cnt FROM idb_file
      WHERE idb07 = g_imr.imr01
        AND idb08 = g_imq_t.imq02
     IF g_cnt > 0 THEN
	LET g_errno = 'aic-113'
     ELSE
	LET g_errno = SQLCA.SQLCODE USING '-------'
     END IF
END FUNCTION
#檢查是否有ida/idb存在--(E)
 
 
#   料號為參考單位,單一單位,且狀態為其它段生產料號(imaicd04=3,4)時,
#   將單位一的資料給單位二
FUNCTION t309_ind_icd_set_value()
    DEFINE l_ima906    LIKE ima_file.ima906,
	   l_imaicd04  LIKE imaicd_file.imaicd04
    IF g_sma.sma115 = 'Y' THEN
       LET l_ima906 = NULL
       LET l_imaicd04 = NULL
       SELECT ima906,imaicd04 INTO l_ima906,l_imaicd04 FROM ima_file,imaicd_file
	WHERE imaicd00 = ima01
	  AND imaicd00 = g_imq[l_ac].imq05
       IF NOT cl_null(l_ima906) AND l_ima906 MATCHES '[3]' THEN
	  IF l_imaicd04 MATCHES '[34]' THEN
	     LET g_imq[l_ac].imq23 = g_imq[l_ac].imq20 #單位
	     LET g_imq[l_ac].imq25 = g_imq[l_ac].imq22 #數量
	     LET g_imq[l_ac].imq24 = g_imq[l_ac].imq22/g_imq[l_ac].imq25
 
	     LET b_imq.imq23= g_imq[l_ac].imq23
	     LET b_imq.imq24= g_imq[l_ac].imq24
	     LET b_imq.imq25= g_imq[l_ac].imq25
	     DISPLAY BY NAME g_imq[l_ac].imq23,
			     g_imq[l_ac].imq24,
			     g_imq[l_ac].imq23
 
	  END IF
       END IF
    END IF
END FUNCTION
 
 #更新die數
 #當料號為wafer段時imaicd04=1,用dice數量加總給原將單據的第二單位數量。
 #當料號為wafer段時imaicd04=2,用pass bin = 'Y'數量加總給原將單據的第二單位數量。
FUNCTION t309_ind_icd_upd_dies()
    DEFINE l_ima906    LIKE ima_file.ima906,
	   l_imaicd04  LIKE imaicd_file.imaicd04                #FUN_BA0051
       #l_imaicd08  LIKE imaicd_file.imaicd08   #FUN-B30187 #FUN-BA0051 mark
    DEFINE l_ida15 LIKE ida_file.ida15,        #FUN-B30187
           l_ida16 LIKE ida_file.ida16         #FUN-B30187

    BEGIN WORK            #FUN-B30187
    LET g_success = 'Y'   #FUN-B30187
    
    IF g_sma.sma115 = 'Y' THEN
       LET l_ima906 = NULL
       LET l_imaicd04 = NULL
       SELECT ima906,imaicd04 INTO l_ima906,l_imaicd04 #FUN-B30187 加imaicd08 #FUN-BA0051 mark imaicd08 
        FROM ima_file,imaicd_file
	    WHERE ima01 = imaicd00
	    AND ima01 = g_imq[l_ac].imq05
        #若料號為單一單位, 如IC料號, 出入庫不回寫單位二級單位二數量
       IF NOT cl_null(l_ima906) AND l_ima906 MATCHES '[3]' THEN
	      IF l_imaicd04 MATCHES '[12]' THEN
	         LET g_imq[l_ac].imq25 = g_dies             #數量
	         LET g_imq[l_ac].imq24 = g_imq[l_ac].imq22/g_imq[l_ac].imq25
	         #BEGIN WORK   #FUN-B30187 mark
	         UPDATE imq_file set imq24 = g_imq[l_ac].imq24,
			  imq25 = g_imq[l_ac].imq25
	          WHERE imq01=g_imr.imr01 AND imq02=g_imq[l_ac].imq02
	         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
		        LET g_imq[l_ac].imq24 = b_imq.imq24
		        LET g_imq[l_ac].imq25 = b_imq.imq25
                LET g_success = 'N'   #FUN-B30187
		        #ROLLBACK WORK        #FUN-B30187 mark
             ELSE
		        LET b_imq.imq24 = g_imq[l_ac].imq24
		        LET b_imq.imq25 = g_imq[l_ac].imq25                
		        #COMMIT WORK   #FUN-B30187 mark
	         END IF
	         DISPLAY BY NAME g_imq[l_ac].imq24, g_imq[l_ac].imq25
          END IF
       END IF
    END IF

    #FUN-BA0051 --START mark--
    #FUN-B70061 --START--
    #IF cl_null(l_imaicd08) THEN
    #    SELECT imaicd08 INTO l_imaicd08 FROM imaicd_file 
    #     WHERE imaicd00 = g_imq[l_ac].imq05
    #END IF
    ##FUN-B70061 --END--
    # 
    #FUN-B30187 --START--    
    #IF l_imaicd08 = 'Y' THEN
    #FUN-BA0051 --END mark--
    IF s_icdbin(g_imq[l_ac].imq05) THEN   #FUN-BA0051
       LET g_sql = "SELECT idb14 FROM idb_file",   #FUN-BC0109 del idb15
                            " WHERE idb07 = '", g_imr.imr01, "'",
                            " AND idb08 =", g_imq[l_ac].imq02       
       DECLARE t309_upd_dia_c CURSOR FROM g_sql            
       OPEN t309_upd_dia_c                                       
       FETCH t309_upd_dia_c INTO g_imq[l_ac].imqiicd029   #FUN-BC0109 del ,g_imq[l_ac].imqiicd028

       #串接Date Code值
       CALL s_icdfun_datecode('1',g_imr.imr01,g_imq[l_ac].imq02) 
                                RETURNING g_imq[l_ac].imqiicd028   #FUN-BC0109
                                
       UPDATE imqi_file set imqiicd029 = g_imq[l_ac].imqiicd029,
        imqiicd028 = g_imq[l_ac].imqiicd028
        WHERE imqi01=g_imr.imr01 AND imqi02=g_imq[l_ac].imq02
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          LET g_imq[l_ac].imqiicd029 = g_imq_t.imqiicd029
          LET g_imq[l_ac].imqiicd028 = g_imq_t.imqiicd028
          LET g_success  = 'N'
       ELSE
          LET g_imq_t.imqiicd029 = g_imq[l_ac].imqiicd029
          LET g_imq_t.imqiicd028 = g_imq[l_ac].imqiicd028          
       END IF 
       DISPLAY BY NAME g_imq[l_ac].imqiicd029, g_imq[l_ac].imqiicd028       
    END IF
    
    IF g_success = 'Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
    #FUN-B30187 --END-- 
END FUNCTION

#FUN-B30187 --START--
FUNCTION t309_def_imqiicd029()
DEFINE l_idc10    LIKE idc_file.idc10,
       l_idc11    LIKE idc_file.idc11
DEFINE l_flag     LIKE type_file.num10

   CALL s_icdfun_def_slot(g_imq[l_ac].imq05,g_imq[l_ac].imq08,g_imq[l_ac].imq09,
                          g_imq[l_ac].imq10) RETURNING l_flag,l_idc10,l_idc11   
   IF l_flag = 1 THEN 
      LET g_imq[l_ac].imqiicd029 = l_idc10
      LET g_imq[l_ac].imqiicd028 = l_idc11      
      DISPLAY BY NAME g_imq[l_ac].imqiicd029,g_imq[l_ac].imqiicd028
   END IF 
END FUNCTION 
#FUN-B30187 --END--
#FUN-A80106 add --end--

#FUN-BB0083---add---str
FUNCTION t309_imq07_check()
#imq07 的單位 imq06
DEFINE l_digcut        LIKE imq_file.imq07,    
       l_digcut1       LIKE imq_file.imq07,
       l_keyinyes      LIKE imq_file.imq07,    
       l_keyinno       LIKE imq_file.imq07,
       l_imp04         LIKE imp_file.imp04,
       l_imp08         LIKE imp_file.imp08,
       l_img10         LIKE img_file.img10
DEFINE l_flag          LIKE type_file.chr1    #FUN-C80107 add
   IF NOT cl_null(g_imq[l_ac].imq06) AND NOT cl_null(g_imq[l_ac].imq07) THEN
      IF cl_null(g_imq_t.imq07) OR cl_null(g_imq06_t) OR g_imq_t.imq07 != g_imq[l_ac].imq07 OR g_imq06_t != g_imq[l_ac].imq06 THEN 
         LET g_imq[l_ac].imq07=s_digqty(g_imq[l_ac].imq07,g_imq[l_ac].imq06)
         DISPLAY BY NAME g_imq[l_ac].imq07  
      END IF  
   END IF
   IF g_imq[l_ac].imq07 = 0 THEN
      CALL cl_err('','mfg1322',1)
      RETURN "imq07"
   END IF
   IF NOT cl_null(g_imq[l_ac].imq07) THEN
      IF g_imq[l_ac].imq07 < 0 THEN 
         CALL cl_err('','aec-020',1)
         RETURN "imq07"
      END IF 
      LET g_imq[l_ac].imq07f = g_imq[l_ac].imq07 / g_imq[l_ac].imq06_fac
      DISPLAY BY NAME g_imq[l_ac].imq07f
      #當下那筆還料數量
      LET l_digcut = g_imq[l_ac].imq07/g_imq[l_ac].imq06_fac
      CALL cl_digcut(l_digcut,3) RETURNING l_digcut
      IF cl_null(l_digcut) THEN
         LET l_digcut = 0
      END IF
 
      #原本的還料數量
      LET l_digcut1 = g_imq_t.imq07/g_imq_t.imq06_fac
      CALL cl_digcut(l_digcut1,3) RETURNING l_digcut1
      IF cl_null(l_digcut1) THEN
         LET l_digcut1 = 0
      END IF
 
      SELECT SUM(imq07/imq06_fac)
         INTO l_keyinyes #已登打的數量
         FROM imq_file,imr_file
         WHERE imq03 = g_imq[l_ac].imq03
         AND imq04 = g_imq[l_ac].imq04
         AND imrconf <> 'X' #作廢的不算 #FUN-660080
         AND imr01 = imq01
      IF cl_null(l_keyinyes) THEN
         LET l_keyinyes = 0
      END IF
      LET l_keyinyes = l_keyinyes - l_digcut1 #已登打數量 - 原本的  還料數量
      LET l_keyinyes = l_keyinyes + l_digcut  #已登打數量 + 當下那筆還料數量
      IF l_keyinyes > g_imq[l_ac].imp04 THEN
         LET l_keyinno = 0 #未登打數量
      ELSE
         LET l_keyinno = g_imq[l_ac].imp04 - l_keyinyes #未登打數量
      END IF
                        #借,還
      SELECT imp04,imp08 INTO l_imp04,l_imp08
         FROM imp_file
         WHERE imp01 = g_imq[l_ac].imq03
         AND imp02 = g_imq[l_ac].imq04
         #還>借
      IF l_imp08 >= l_imp04 THEN
         #借料數量已還清!
         CALL cl_err('','aim-116',1)
         RETURN "imq03"
      END IF
 
      #  已登打數量 > 借料數量
      IF l_keyinyes > l_imp04 THEN
         CALL cl_err('','aim-117',1)
         LET g_imq[l_ac].imq07 = g_imq_t.imq07
         RETURN "imq07"
      END IF
      #---------No.MOD-580069 add 判斷是否允許負庫存
      LET l_flag = NULL    #FUN-C80107 add
      #CALL s_inv_shrt_by_warehouse(g_sma.sma894[5,5],g_imq[l_ac].imq08) RETURNING l_flag #FUN-C80107 add #FUN-D30024--mark
      CALL s_inv_shrt_by_warehouse(g_imq[l_ac].imq08,g_plant) RETURNING l_flag             #FUN-D30024--add #TQC-D40078 g_plant
     #IF g_sma.sma894[5,5] = 'N' THEN           #FUN-C80107 mark
      IF l_flag = 'N' OR l_flag IS NULL THEN    #FUN-C80107 add
         SELECT img10 INTO l_img10 FROM img_file
         WHERE img01 = g_imq[l_ac].imq05
         AND img02 = g_imq[l_ac].imq08
         AND img03 = g_imq[l_ac].imq09
         AND img04 = g_imq[l_ac].imq10
         IF g_imq[l_ac].imq07 > l_img10 THEN
            CALL cl_err('','aim-406',1)
            RETURN "imq08"
         END IF
       END IF 
   END IF
RETURN ''

END FUNCTION

FUNCTION t309_imq22_check()
#imq22 的單位 imq20
DEFINE l_digcut        LIKE imq_file.imq07,    
       l_digcut1       LIKE imq_file.imq07,
       l_keyinyes      LIKE imq_file.imq07,    
       l_keyinno       LIKE imq_file.imq07,
       l_imp04         LIKE imp_file.imp04,
       l_imp08         LIKE imp_file.imp08,
       l_img10         LIKE img_file.img10
   IF NOT cl_null(g_imq[l_ac].imq20) AND NOT cl_null(g_imq[l_ac].imq22) THEN
      IF cl_null(g_imq_t.imq22) OR cl_null(g_imq20_t) OR g_imq_t.imq22 != g_imq[l_ac].imq22 OR g_imq20_t != g_imq[l_ac].imq20 THEN 
         LET g_imq[l_ac].imq22=s_digqty(g_imq[l_ac].imq22,g_imq[l_ac].imq20)
         DISPLAY BY NAME g_imq[l_ac].imq22  
      END IF  
   END IF
   IF NOT cl_null(g_imq[l_ac].imq22) THEN
      IF g_imq[l_ac].imq22 < 0 THEN
         CALL cl_err('','aim-391',0)  #
         RETURN "imq22"
     END IF
   END IF
   CALL t309_du_data_to_correct()
   CALL t309_set_origin_field()
   CALL t309_unit(g_imq[l_ac].imq06)
   IF NOT cl_null(g_errno) THEN
      CALL cl_err(g_imq[l_ac].imq06,g_errno,0)
      RETURN "imq08"
   END IF
   CALL s_umfchk(g_imq[l_ac].imq05,g_imq[l_ac].imp05,
                 g_imq[l_ac].imq06)
        RETURNING g_cnt,g_imq[l_ac].imq06_fac
   IF g_cnt = 1 THEN
      CALL cl_err('','mfg3075',0)
      RETURN "imq06"
   END IF
   IF g_imq[l_ac].imq07 = 0 THEN
       CALL cl_err('imq07','mfg1322',1)
       RETURN "imq08"
   END IF
   IF NOT cl_null(g_imq[l_ac].imq07) THEN
       LET g_imq[l_ac].imq07f = g_imq[l_ac].imq07 / g_imq[l_ac].imq06_fac
       #當下那筆還料數量
       LET l_digcut = g_imq[l_ac].imq07/g_imq[l_ac].imq06_fac
       CALL cl_digcut(l_digcut,3) RETURNING l_digcut
       IF cl_null(l_digcut) THEN
           LET l_digcut = 0
       END IF
 
       #原本的還料數量
       LET l_digcut1 = g_imq_t.imq07/g_imq_t.imq06_fac
       CALL cl_digcut(l_digcut1,3) RETURNING l_digcut1
       IF cl_null(l_digcut1) THEN
           LET l_digcut1 = 0
       END IF
 
       SELECT SUM(imq07/imq06_fac)
         INTO l_keyinyes #已登打的數量
         FROM imq_file,imr_file
        WHERE imq03 = g_imq[l_ac].imq03
          AND imq04 = g_imq[l_ac].imq04
          AND imrconf <> 'X' #作廢的不算 #FUN-660080
          AND imr01 = imq01
       IF cl_null(l_keyinyes) THEN
           LET l_keyinyes = 0
       END IF
       LET l_keyinyes = l_keyinyes - l_digcut1 #已登打數量 - 原本的  還料數量
       LET l_keyinyes = l_keyinyes + l_digcut  #已登打數量 + 當下那筆還料數量
       IF l_keyinyes > g_imq[l_ac].imp04 THEN
           LET l_keyinno = 0 #未登打數量
       ELSE
           LET l_keyinno = g_imq[l_ac].imp04 - l_keyinyes #未登打數量
       END IF
                #借,還
       SELECT imp04,imp08 INTO l_imp04,l_imp08
         FROM imp_file
        WHERE imp01 = g_imq[l_ac].imq03
          AND imp02 = g_imq[l_ac].imq04
       #還>借
       IF l_imp08 >= l_imp04 THEN
           #借料數量已還清!
           CALL cl_err('','aim-116',1)
           RETURN "imq08"
       END IF
 
       #  已登打數量 > 借料數量
       IF l_keyinyes > l_imp04 THEN
           CALL cl_err('','aim-117',1)
           LET g_imq[l_ac].imq07 = g_imq_t.imq07
           RETURN "imq08"
       END IF
   END IF
RETURN ''
END FUNCTION

FUNCTION t309_imq25_check()
#imq25 的單位 imq23
DEFINE p_cmd LIKE type_file.chr1
   IF NOT cl_null(g_imq[l_ac].imq23) AND NOT cl_null(g_imq[l_ac].imq25) THEN
      IF cl_null(g_imq_t.imq25) OR cl_null(g_imq23_t) OR g_imq_t.imq25 != g_imq[l_ac].imq25 OR g_imq23_t != g_imq[l_ac].imq23 THEN 
         LET g_imq[l_ac].imq25=s_digqty(g_imq[l_ac].imq25,g_imq[l_ac].imq23)
         DISPLAY BY NAME g_imq[l_ac].imq23  
      END IF  
   END IF
   IF NOT cl_null(g_imq[l_ac].imq25) THEN
      IF g_imq[l_ac].imq25 < 0 THEN
         CALL cl_err('','aim-391',0)  #
         RETURN FALSE
      END IF
      IF p_cmd = 'a' THEN
         IF g_ima906='3' THEN
            LET g_tot=g_imq[l_ac].imq25*g_imq[l_ac].imq24
            IF cl_null(g_imq[l_ac].imq22) OR g_imq[l_ac].imq22=0 THEN  #CHI-960022
               LET g_imq[l_ac].imq22=g_tot*g_imq[l_ac].imq21
               DISPLAY BY NAME g_imq[l_ac].imq22                       #CHI-960022
            END IF                                                     #CHI-960022
         END IF
      END IF
   END IF
   CALL cl_show_fld_cont() 
RETURN TRUE 
END FUNCTION

   
#FUN-BB0083---add---end

#FUN-C50071 add begin-------------------------
FUNCTION t309_rvbs()
  DEFINE b_rvbs  RECORD  LIKE rvbs_file.*
  DEFINE l_ima25         LIKE ima_file.ima25

      LET b_rvbs.rvbs00  = g_prog
      LET b_rvbs.rvbs01  = g_imr.imr01
      LET b_rvbs.rvbs02  = g_imq[l_ac].imq02
      LET b_rvbs.rvbs021 = g_imq[l_ac].imq05
      LET b_rvbs.rvbs06  = g_imq[l_ac].imq07 * g_imq[l_ac].imq06_fac  #數量*庫存單位換算率
      LET b_rvbs.rvbs09  = -1  #-1出庫
      CALL s_ins_rvbs("1",b_rvbs.*)

END FUNCTION
#FUN-C50071 add -end--------------------------
#FUN-CB0087---add---str---
FUNCTION t309_imq26()
IF NOT cl_null(g_imq[l_ac].imq26) THEN             #TQC-D20042
   SELECT azf03 INTO g_imq[l_ac].azf03
     FROM azf_file
    WHERE azf01 = g_imq[l_ac].imq26
      AND azf02 = '2'
ELSE                                               #TQC-D20042
   LET g_imq[l_ac].azf03 = ' '                     #TQC-D20042
END IF                                             #TQC-D20042
   DISPLAY BY NAME g_imq[l_ac].azf03
END FUNCTION

FUNCTION t309_imq26_chk()
DEFINE  l_flag          LIKE type_file.chr1,
        l_n             LIKE type_file.num5,
        l_where         STRING,
        l_sql           STRING
   IF NOT cl_null(g_imq[l_ac].imq26) THEN
      LET l_n = 0
      LET l_flag = FALSE
      IF g_aza.aza115='Y' THEN
         CALL s_get_where(g_imr.imr01,g_imq[l_ac].imq03,'',g_imq[l_ac].imq05,g_imq[l_ac].imq08,g_imr.imr03,g_imr.imr04) RETURNING l_flag,l_where
      END IF
      IF g_aza.aza115='Y' AND l_flag THEN
         LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_imq[l_ac].imq26,"' AND ",l_where
         PREPARE ggc08_pre FROM l_sql
         EXECUTE ggc08_pre INTO l_n
         IF l_n < 1 THEN
            CALL cl_err(g_imq[l_ac].imq26,'aim-425',0)
            RETURN FALSE
         END IF
      ELSE
         SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01 = g_imq[l_ac].imq26 AND azf02 = '2'
         IF l_n < 1 THEN
            CALL cl_err(g_imq[l_ac].imq26,'aim-425',0)
            RETURN FALSE
         END IF
      END IF
   ELSE                                    #TQC-D20042
      LET g_imq[l_ac].azf03 = ' '          #TQC-D20042
      DISPLAY BY NAME g_imq[l_ac].azf03    #TQC-D20042
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t309_imq26_chk1()
DEFINE  l_flag          LIKE type_file.chr1,
        l_n             LIKE type_file.num5,
        l_where         STRING,
        l_sql           STRING,
        l_i             LIKE type_file.num5
   IF g_aza.aza115 = 'Y' THEN
      FOR l_i=1 TO g_imq.getlength()
         CALL s_get_where(g_imr.imr01,g_imq[l_ac].imq03,'',g_imq[l_i].imq05,g_imq[l_i].imq08,g_imr.imr03,g_imr.imr04) RETURNING l_flag,l_where
         IF l_flag THEN
            LET l_n=0
            LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_imq[l_i].imq26,"' AND ",l_where
            PREPARE ggc08_pre1 FROM l_sql
            EXECUTE ggc08_pre1 INTO l_n
            IF l_n < 1 THEN
               CALL cl_err('','aim-425',0)
               LET g_imr.imr03 = g_imr_t.imr03
               LET g_imr.imr04 = g_imr_t.imr04
               RETURN FALSE
            END IF
         END IF
      END FOR
   END IF
   RETURN TRUE
END FUNCTION
#FUN-CB0087---add---end---
#FUN-D10081---add---str---
FUNCTION t309_list_fill()
  DEFINE l_imr01         LIKE imr_file.imr01
  DEFINE l_i             LIKE type_file.num10

    CALL g_imr_l.clear()
    LET l_i = 1
    FOREACH t309_fill_cs INTO l_imr01
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT imr01,'',imr02,imr03,gen02,imr04,gem02,imr05,imr06,
              imr09,imrconf,imrpost
         INTO g_imr_l[l_i].*
         FROM imr_file
              LEFT OUTER JOIN gem_file ON gem01 = imr04
              LEFT OUTER JOIN gen_file ON gen01 = imr03
        WHERE imr01=l_imr01
       LET g_t1=s_get_doc_no(g_imr_l[l_i].imr01)
       SELECT smydesc INTO g_imr_l[l_i].smydesc
         FROM smy_file 
        WHERE smyslip = g_t1

       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN
            CALL cl_err( '', 9035, 0 )
          END IF
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b4 = l_i - 1
    DISPLAY ARRAY g_imr_l TO s_imr_l.* ATTRIBUTE(COUNT=g_rec_b4,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
    
END FUNCTION

FUNCTION t309_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1  
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_imr_l TO s_imr_l.* ATTRIBUTE(COUNT=g_rec_b4,UNBUFFERED)
      BEFORE DISPLAY
          CALL fgl_set_arr_curr(g_curs_index)
          CALL cl_navigator_setting( g_curs_index, g_row_count )
       BEFORE ROW
          LET l_ac4 = ARR_CURR()
          LET g_curs_index = l_ac4
          CALL cl_show_fld_cont()

      ON ACTION page_main
         LET g_action_flag = "page_main"
         LET l_ac4 = ARR_CURR()
         LET g_jump = l_ac4
         LET mi_no_ask = TRUE
         IF g_rec_b4 > 0 THEN
             CALL t309_fetch('/')
         END IF
         CALL cl_set_comp_visible("page_list", FALSE)
         CALL cl_set_comp_visible("page_main", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_list", TRUE)
         CALL cl_set_comp_visible("page_main", TRUE)          
         EXIT DISPLAY

      ON ACTION ACCEPT
         LET g_action_flag = "page_main"
         LET l_ac4 = ARR_CURR()
         LET g_jump = l_ac4
         LET mi_no_ask = TRUE
         CALL t309_fetch('/')  
         CALL cl_set_comp_visible("page_list", FALSE)
         CALL cl_set_comp_visible("page_list", TRUE)
         CALL cl_set_comp_visible("page_main", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_main", TRUE)    
         EXIT DISPLAY

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
         CALL t309_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                  
 
 
      ON ACTION previous
         CALL t309_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                  
 
 
      ON ACTION jump
         CALL t309_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                 
 
 
      ON ACTION next
         CALL t309_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                  
 
 
      ON ACTION last
         CALL t309_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                  
 
 
      #TQC-D10084---mark---str---
      #ON ACTION detail
      #   LET g_action_choice="detail"
      #   LET l_ac = 1
      #   EXIT DISPLAY
       #TQC-D10084---mark---end---
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   
         CALL t309_mu_ui()   
         IF g_imr.imrconf = 'X' THEN 
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_imr.imrconf,"",g_imr.imrpost,"",g_void,"") 
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
    #@ON ACTION 過帳
      ON ACTION post
         LET g_action_choice="post"
         EXIT DISPLAY
    #@ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY
    #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end
    #@ON ACTION 單據刻號BIN查詢作業
      ON ACTION aic_s_icdqry
         LET g_action_choice = "aic_s_icdqry"
         EXIT DISPLAY
 
    #@ON ACTION 單據刻號BIN明細維護作業
      ON ACTION aic_s_icdout
         LET g_action_choice = "aic_s_icdout"
         EXIT DISPLAY
 
      ON ACTION CANCEL
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
 
    #@ON ACTION 拋轉至SPC
      ON ACTION trans_spc                     
         LET g_action_choice="trans_spc"
         EXIT DISPLAY
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DISPLAY

     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
   
      &include "qry_string.4gl"
    END DISPLAY

    CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION 
#FUN-D10081---add---end
