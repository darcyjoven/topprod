# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: atmt260.4gl
# Descriptions...: 產品組合包裝維護作業
# Date & Author..: 06/01/13 By jackie
# Modify.........: NO.TQC-630072 06/03/07 By Melody 指定單據編號、執行功能(g_argv2)
# Modify.........: No.FUN-610066 06/03/23 By jackie 單身錄入時不去Check庫存量 過帳時再開放倉庫,儲位,批號修改并Check庫存
# Modify.........: No.TQC-640116 06/04/09 By day  確認時顯示圖片改為"核"
# Modify.........: No.TQC-650031 06/05/12 By Rayven 修改不使用多單位時,單身子單位數量欄位還會出現問題
# Modify.........: No.FUN-660104 06/06/20 By cl Error Message 調整
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680120 06/08/31 By chen 類型轉換
# Modify.........: No.FUN-690022 06/09/20 By jamie 判斷imaacti
# Modify.........: No.FUN-690025 06/09/20 By jamie 改判斷狀況碼ima1010
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0046 06/11/21 By Rayven 出貨庫位開窗關閉此作業
# Modify.........: No.FUN-6B0065 06/11/21 By Ray atmi217并入aooi313(azf09,10,11,12,13取代tqe03,04,05,11,08)
# Modify.........: No.FUN-6B0079 06/12/04 By jamie FUNCTION _fetch() 清空key值
# Modify.........: No.FUN-710033 07/02/01 By dxfwo 增加修改單身批處理錯誤統整功能
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-770019 07/07/26 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: No.TQC-790082 07/09/13 By lumxa 打印時程序名稱不應在“制表日期”下面
# Modify.........: No.MOD-7C0005 08/01/15 By Carol 過帳/還原加g_totsuccess的處理
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840042 08/04/17 By TSD.liquor 自定欄位功能修改
# Modify.........: NO.FUN-860008 08/06/18 By zhaijie老報表修改為CR
# Modify.........: NO.TQC-880014 08/08/20 By sabrinae 因正式區的畫面檔和程式欄位不符合，所以補過程式
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID
# Modify.........: No.MOD-910140 09/01/13 By Smapmin 未確認的料號不可輸入
# Modify.........: No.TQC-930079 09/03/12 By chenyu 1.AFTER FIELD tsc04后面，取不到轉換率應該報錯
#                                                   2.AFTER FIELD tsc03后面,判斷不准確，導致沒有使用多單位，也顯示第二數量欄位
# Modify.........: No.FUN-930140 09/03/23 By Carrier 增加工單單號
# Modify.........: No.TQC-930155 09/04/14 By Zhangyajun 數據Lock失敗，不能直接Rollback
# Modify.........: No.TQC-930133 09/04/14 By chenyu 單頭的單位不可以修改
# Modify.........: No.FUN-950021 09/05/23 By Carrier 組合拆解
# Modify.........: No.FUN-870100 09/07/29 By Cockroach 零售移植
# Modify.........: No.FUN-980009 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.CHI-960052 09/10/15 By chenmoyan 使用多單位，料件是單一單位或參考單位時，單位一的轉換率錯誤
# Modify.........: No.MOD-9B0120 09/11/19 By sherry 複製時開放組合日期欄位
# Modify.........: No.FUN-9C0073 10/01/11 By chenls 程序精簡
# Modify.........: No.TQC-A10108 10/01/12 By lilingyu 審核時,未即時顯示出審核時間 審核人等信息
# Modify.........: No.TQC-A10152 10/01/22 By lilingyu 查詢時,報-201語法錯誤 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A20037 10/03/11 By lilingyu 替代碼sfa26加上"8,Z"的條件
# Modify.........: No.TQC-A30048 10/03/15 By Cockroach add oriu/orig
# Modify.........: No.FUN-A50071 10/05/19 By lixia 程序增加POS單號字段 并增加相应管控
# Modify.........: No.TQC-A50087 10/05/20 By liuxqa sfb104 赋初值.
# Modify.........: No.FUN-A60027 10/06/17 By sunchenxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.MOD-A60197 10/06/30 By liuxqa sfa012,sfa013 賦初值。
# Modify.........: No:CHI-A70027 10/07/20 By Summer 批/序號控制 
# Modify.........: No:CHI-A70051 10/07/28 By Carrier 组合单产生的工单/发料/入库等加上批序号内容
# Modify.........: No:MOD-A80061 10/08/09 By lilingyu 過賬段部分邏輯錯誤
# Modify.........: No:CHI-A80043 10/08/26 By Carrier 产生工单自动结案
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.MOD-AA0167 10/10/27 By lilingyu 過賬時,未考慮系統關帳日期
# Modify.........: No.FUN-AA0059 10/11/02 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AA0046 10/11/02 By huangtao 修改q_smy中取號的參數
# Modify.........: No.FUN-AB0014 10/11/03 By houlia 倉庫權限使用控管修改
# Modify.........: No:FUN-AA0048 10/11/24 By Carrier GP5.2架构下仓库权限修改
# Modify.........: No:MOD-B30253 11/03/12 By Summer 於INSERT INTO sfb_file前加入 LET l_sfb.sfb44 = l_tsc.tsc16,人員欄位需控卡為必填
# Modify.........: No:FUN-B30170 11/04/11 By suncx 單身增加批序號明細頁簽
# Modify.........: No:CHI-B40040 11/04/28 By lixh1 三階段結案時,sfb38應該為NULL
# Modify.........: No.FUN-A80128 11/04/29 By Mandy 因asft620 新增EasyFlow整合功能影響INSERT INTO sfu_file
# Modify.........: No:FUN-AB0001 11/04/25 By Lilan 因asfi510 新增EasyFlow整合功能影響INSERT INTO sfp_file
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60227 11/06/20 By xianghui 將數據插入到表sfp_file時，sfpmksg欄位為空與數據庫定義不為空沖突
# Modify.........: No.CHI-B60061 11/06/27 By lixh1 組合和拆解單確認後產生的工單,做第一階段結案
# Modify.........: No.FUN-B20095 11/07/01 By lixh1 新增sfq012(製程段號)
# Modify.........: No:FUN-B70074 11/07/26 By fengrui 添加行業別表的新增於刪除(sfsi_file by lixh1)
# Modify.........: No:FUN-B80061 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No:TQC-BB0207 11/11/23 By suncx 過賬時不調用t260_pb()函數，將t260_pb()中的檢查邏輯搬移
# Modify.........: No:FUN-BB0086 11/12/27 By tanxc 增加數量欄位小數取位
# Modify.........: No.TQC-B90236 12/01/11 By zhuhao s_lotout_del程式段Mark，改為s_lot_del，傳入參數不變
#                                                   _r()中，使用FOR迴圈執行s_lotout_del/s_lotin_del程式段Mark，改為s_lot_del，傳入參數不變，但第三個參數(項次)傳""
#                                                   s_lotou程式段，改為s_mod_lot，傳入參數不變，於最後多傳入-1
#                                                   s_lotin程式段，改為s_mod_lot，於第6,7,8個參數傳入倉儲批，最後多傳入1，其餘傳入參數不變
# Modify.........: No.FUN-BC0104 12/01/17 By xianghui 數量異動回寫qco20
# Modify.........: No:MOD-C10050 12/02/09 By jt_chen 產生領料單sfp03 /入庫單sfu02 預設來源組合單扣帳日期 tsc02
# Modify.........: No:TQC-C20161 12/02/17 By yangxf 隐藏pos单号栏位
# Modify.........: No:TQC-C20337 12/02/22 By yangxf 程式過帳時產生對應的工單,發料單,入庫單,其部門資料應取產品組合單上的部門,人員
# Modify.........: No:CHI-C30064 12/03/15 By Sakura 程式有用到"aim-011"訊息的地方，改用料倉儲批抓庫存單位(img09)換算
# Modify.........: No:CHI-C30106 12/04/05 By Elise 批序號維護
# Modify.........: No:CHI-C30118 12/04/06 By Sakura 參考來源單號CHI-C30106,批序號維護修改,t620sub_y_chk新增傳入參數 
# Modify.........: No.FUN-C30300 12/04/09 By bart  倉儲批開窗需顯示參考單位數量
# Modify.........: No:MOD-C40211 12/04/27 By suncx 過賬時重新檢查庫存數量
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:TQC-C60028 12/06/04 By bart 只要是ICD行業 倉儲批開窗改用q_idc
# Modify.........: No.TQC-C60079 12/06/11 By fengrui 函數i501sub_y_chk添加參數
# Modify.........: No:FUN-C70014 12/07/05 By wangwei 新增RUN CARD發料作業
# Modify.........: No:FUN-C80065 12/09/10 By nanbing 添加批序號依參數sma95隱藏  
# Modify.........: No:FUN-C80046 12/08/22 By bart 複製後停在新資料畫面
# Modify.........: No:MOD-C90144 12/09/17 By Summer 單身兩筆以上相同料件,但不同倉儲批的資料扣帳時錯誤,寫入工單備料檔改依key值欄位做group,並調整寫入發料檔方式 
# Modify.........: No:FUN-C80107 12/09/18 By suncx 增可按倉庫進行負庫存判斷
# Modify.........: No.CHI-C80041 12/12/05 By bart 取消單頭資料控制
# Modify.........: No.FUN-CC0057 12/12/18 By xumeimei 删除时更新ruc34为NULL
# Modify.........: No.FUN-CB0087 12/12/20 By fengrui 倉庫單據理由碼改善
# Modify.........: No:TQC-CC0143 12/12/27 By qirl 過帳后顯示審核
# Modify.........: No:CHI-CB0064 12/12/28 By Sakura 單頭加入批號的控卡
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No:CHI-D20014 13/02/21 By nanbing 設限倉庫控卡 不需处理，还原
# Modify.........: No:FUN-D30024 13/03/12 By fengrui 負庫存依據imd23判斷
# Modify.........: No:TQC-D30044 13/03/19 By fengrui 負庫存依據imd23判斷
# Modify.........: No:MOD-D30180 13/03/20 By Sakura 過帳段檢查庫存量前,如g_tsd[l_i].tsd13與g_tsd[l_i].tsd14為null時,預設帶空值
# Modify.........: No:CHI-D20015 13/03/26 By xuxz 修改取消確認邏輯
# Modify.........: No:FUN-D40103 13/05/15 By lixh1 增加儲位有效性檢查
# Modify.........: No:TQC-D50124 13/05/28 By lixh1 拿掉儲位有效性檢查
# Modify.........: No:TQC-D40078 13/04/28 By xujing 負庫存函数添加营运中心参数 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_tsc           RECORD LIKE tsc_file.*,       #單頭
    g_tsc_t         RECORD LIKE tsc_file.*,       #單頭(舊值)
    g_tsc_o         RECORD LIKE tsc_file.*,       #單頭(舊值)
    g_tsc01         LIKE tsc_file.tsc01,   #單頭KEY
    g_tsc01_t       LIKE tsc_file.tsc01,   #單頭KEY (舊值)
    g_t1            LIKE oay_file.oayslip,               #No.FUN-680120 VARCHAR(05)
    g_flag          LIKE type_file.chr1,                 #No.FUN-680120 VARCHAR(1)
    g_img           RECORD LIKE img_file.*,
    g_img1          RECORD LIKE img_file.*,
    g_tot           LIKE img_file.img10,
    g_img09         LIKE img_file.img09,
    g_img10         LIKE img_file.img10,
    g_imgg10        LIKE img_file.img10,
    g_imgg10_1      LIKE img_file.img10,
    g_imgg10_2      LIKE img_file.img10,
    g_ima906        LIKE ima_file.ima906,
    g_ima907        LIKE ima_file.ima907,
    g_ima55         LIKE ima_file.ima55,
    g_ima63         LIKE ima_file.ima63,
    g_ima86         LIKE ima_file.ima86,
    g_pmn38         LIKE pmn_file.pmn38,
    g_change        LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(01)
    g_tsd           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        tsd02       LIKE tsd_file.tsd02,   #項次
        tsd03       LIKE tsd_file.tsd03,   #產品編號
        ima02       LIKE ima_file.ima02,   #品名
        ima021      LIKE ima_file.ima021,  #規格
        ima1002     LIKE ima_file.ima1002, #英文名稱
        ima135      LIKE ima_file.ima135,  #條碼
        tsd12       LIKE tsd_file.tsd12,   #倉庫
        tsd13       LIKE tsd_file.tsd13,   #庫位
        tsd14       LIKE tsd_file.tsd14,   #批號
        tsd04       LIKE tsd_file.tsd04,   #單位
        tsd05       LIKE tsd_file.tsd05,   #數量
        tsd09       LIKE tsd_file.tsd09,   #單位二
        tsd10       LIKE tsd_file.tsd10,   #單位二轉換率
        tsd11       LIKE tsd_file.tsd11,   #單位二數量
        tsd06       LIKE tsd_file.tsd06,   #單位一
        tsd07       LIKE tsd_file.tsd07,   #單位一轉換率
        tsd08       LIKE tsd_file.tsd08,   #單位一數量
        tsd15       LIKE tsd_file.tsd15,   #備注
        tsdud01 LIKE tsd_file.tsdud01,
        tsdud02 LIKE tsd_file.tsdud02,
        tsdud03 LIKE tsd_file.tsdud03,
        tsdud04 LIKE tsd_file.tsdud04,
        tsdud05 LIKE tsd_file.tsdud05,
        tsdud06 LIKE tsd_file.tsdud06,
        tsdud07 LIKE tsd_file.tsdud07,
        tsdud08 LIKE tsd_file.tsdud08,
        tsdud09 LIKE tsd_file.tsdud09,
        tsdud10 LIKE tsd_file.tsdud10,
        tsdud11 LIKE tsd_file.tsdud11,
        tsdud12 LIKE tsd_file.tsdud12,
        tsdud13 LIKE tsd_file.tsdud13,
        tsdud14 LIKE tsd_file.tsdud14,
        tsdud15 LIKE tsd_file.tsdud15
                    END RECORD,
    g_tsd_t         RECORD                 #程式變數 (舊值)
        tsd02       LIKE tsd_file.tsd02,   #項次
        tsd03       LIKE tsd_file.tsd03,   #產品編號
        ima02       LIKE ima_file.ima02,   #品名
        ima021      LIKE ima_file.ima021,  #規格
        ima1002     LIKE ima_file.ima1002, #英文名稱
        ima135      LIKE ima_file.ima135,  #條碼
        tsd12       LIKE tsd_file.tsd12,   #倉庫
        tsd13       LIKE tsd_file.tsd13,   #庫位
        tsd14       LIKE tsd_file.tsd14,   #批號
        tsd04       LIKE tsd_file.tsd04,   #單位
        tsd05       LIKE tsd_file.tsd05,   #數量
        tsd09       LIKE tsd_file.tsd09,   #單位二
        tsd10       LIKE tsd_file.tsd10,   #單位二轉換率
        tsd11       LIKE tsd_file.tsd11,   #單位二數量
        tsd06       LIKE tsd_file.tsd06,   #單位一
        tsd07       LIKE tsd_file.tsd07,   #單位一轉換率
        tsd08       LIKE tsd_file.tsd08,   #單位一數量
        tsd15       LIKE tsd_file.tsd15,   #備注
        tsdud01 LIKE tsd_file.tsdud01,
        tsdud02 LIKE tsd_file.tsdud02,
        tsdud03 LIKE tsd_file.tsdud03,
        tsdud04 LIKE tsd_file.tsdud04,
        tsdud05 LIKE tsd_file.tsdud05,
        tsdud06 LIKE tsd_file.tsdud06,
        tsdud07 LIKE tsd_file.tsdud07,
        tsdud08 LIKE tsd_file.tsdud08,
        tsdud09 LIKE tsd_file.tsdud09,
        tsdud10 LIKE tsd_file.tsdud10,
        tsdud11 LIKE tsd_file.tsdud11,
        tsdud12 LIKE tsd_file.tsdud12,
        tsdud13 LIKE tsd_file.tsdud13,
        tsdud14 LIKE tsd_file.tsdud14,
        tsdud15 LIKE tsd_file.tsdud15
                    END RECORD,
    g_tsd_o         RECORD                 #程式變數 (舊值)
        tsd02       LIKE tsd_file.tsd02,   #項次
        tsd03       LIKE tsd_file.tsd03,   #產品編號
        ima02       LIKE ima_file.ima02,   #品名
        ima021      LIKE ima_file.ima021,  #規格
        ima1002     LIKE ima_file.ima1002, #英文名稱
        ima135      LIKE ima_file.ima135,  #條碼
        tsd12       LIKE tsd_file.tsd12,   #倉庫
        tsd13       LIKE tsd_file.tsd13,   #庫位
        tsd14       LIKE tsd_file.tsd14,   #批號
        tsd04       LIKE tsd_file.tsd04,   #單位
        tsd05       LIKE tsd_file.tsd05,   #數量
        tsd09       LIKE tsd_file.tsd09,   #單位二
        tsd10       LIKE tsd_file.tsd10,   #單位二轉換率
        tsd11       LIKE tsd_file.tsd11,   #單位二數量
        tsd06       LIKE tsd_file.tsd06,   #單位一
        tsd07       LIKE tsd_file.tsd07,   #單位一轉換率
        tsd08       LIKE tsd_file.tsd08,   #單位一數量
        tsd15       LIKE tsd_file.tsd15,   #備注
        tsdud01 LIKE tsd_file.tsdud01,
        tsdud02 LIKE tsd_file.tsdud02,
        tsdud03 LIKE tsd_file.tsdud03,
        tsdud04 LIKE tsd_file.tsdud04,
        tsdud05 LIKE tsd_file.tsdud05,
        tsdud06 LIKE tsd_file.tsdud06,
        tsdud07 LIKE tsd_file.tsdud07,
        tsdud08 LIKE tsd_file.tsdud08,
        tsdud09 LIKE tsd_file.tsdud09,
        tsdud10 LIKE tsd_file.tsdud10,
        tsdud11 LIKE tsd_file.tsdud11,
        tsdud12 LIKE tsd_file.tsdud12,
        tsdud13 LIKE tsd_file.tsdud13,
        tsdud14 LIKE tsd_file.tsdud14,
        tsdud15 LIKE tsd_file.tsdud15
                    END RECORD,
    g_tsd041        LIKE tsd_file.tsd041,
    g_wc,g_wc2,g_sql    string,
    g_rec_b         LIKE type_file.num5,                #單身筆數              #No.FUN-680120 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT   #No.FUN-680120 SMALLINT
 DEFINE l_sfp_count LIKE type_file.num5   #add by zhangzs 210113
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5        #No.FUN-680120 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE   g_approve       LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)  #No.TQC-640116
DEFINE   g_chr2          LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE   g_chr3          LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_cnt1          LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10          #No.FUN-680120 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10          #No.FUN-680120 INTEGER
 
DEFINE   g_jump         LIKE type_file.num10          #No.FUN-680120 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5           #No.FUN-680120 SMALLINT
DEFINE   g_argv1	LIKE oea_file.oea01           #No.FUN-680120 VARCHAR(16)           #No.TQC-630072
DEFINE g_argv2  STRING              #No.TQC-630072
DEFINE g_str        STRING
DEFINE l_table      STRING
#CHI-A70027 add --start--
DEFINE g_ima918     LIKE ima_file.ima918
DEFINE g_ima921     LIKE ima_file.ima921
DEFINE l_r          LIKE type_file.chr1 
DEFINE g_ima25      LIKE ima_file.ima25 
DEFINE g_ima25_fac  LIKE ima_file.ima25 
DEFINE g_qty        LIKE img_file.img10 
#CHI-A70027 add --end--
#MOD-AA0167 --begin--
DEFINE g_yy         LIKE type_file.num5
DEFINE g_sql2       STRING   #add by zhangzs 210113
DEFINE g_mm         LIKE type_file.num5
DEFINE l_shb05    LIKE shb_file.shb05         #add by zhangzs 210206
DEFINE l_sfbud12  LIKE sfb_file.sfbud12     #add by zhangzs 210206
#MOD-AA0167 --end--
#FUN-B30170 add begin--------------------------
DEFINE g_rvbs   DYNAMIC ARRAY OF RECORD        
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
                END RECORD,
       g_rvbs_1 DYNAMIC ARRAY OF RECORD       
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

DEFINE g_rec_b1            LIKE type_file.num5,   
       g_rec_b2            LIKE type_file.num5,   
       l_ac1               LIKE type_file.num5   
#FUN-B30170 add -end---------------------------
#No.FUN-BB0086--add--begin--
DEFINE g_tsc04_t           LIKE tsc_file.tsc04   
DEFINE g_tsc06_t           LIKE tsc_file.tsc06   
DEFINE g_tsc09_t           LIKE tsc_file.tsc09   
DEFINE g_tsd04_t           LIKE tsd_file.tsd04   
DEFINE g_tsd06_t           LIKE tsd_file.tsd06   
DEFINE g_tsd09_t           LIKE tsd_file.tsd09   
#No.FUN-BB0086--add--end--
#DEFINE g_sma894            LIKE type_file.chr1     #FUN-C80107 add  #FUN-D30024 mark
DEFINE g_imd23             LIKE type_file.chr1      #FUN-D30024 add
#add by zhangzs 210113 ------s--------
DEFINE g_sfp   RECORD      LIKE sfp_file.*
DEFINE l_sfp   RECORD      LIKE sfp_file.*
DEFINE g_sfs   RECORD      LIKE sfs_file.*
DEFINE l_sfs   RECORD      LIKE sfs_file.*
DEFINE l_sfp_count2        LIKE type_file.num5
DEFINE l_sfp_count3        LIKE type_file.num5
#add by zhangzs 210113   ------e-------
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
   LET g_sql = "l_tsc01.tsc_file.tsc01,",
               "l_gem02.gem_file.gem02,",
               "l_azf03.azf_file.azf03,",
               "l_imd02.imd_file.imd02,",
               "l_ime03.ime_file.ime03,",
               "l_tsc03.tsc_file.tsc03,",
               "l_ima02.ima_file.ima02,",
               "l_imd02a.imd_file.imd02,",
               "l_ime03a.ime_file.ime03,",
               "l_ima02a.ima_file.ima02,",
               "tsc01.tsc_file.tsc01,",
               "tsc02.tsc_file.tsc02,",
               "tsc17.tsc_file.tsc17,",
               "tsc15.tsc_file.tsc15,",
               "tsc16.tsc_file.tsc16,",
               "tsc03.tsc_file.tsc03,",
               "tsc12.tsc_file.tsc12,",
               "tsc13.tsc_file.tsc13,",
               "tsc14.tsc_file.tsc14,",
               "tsc04.tsc_file.tsc04,",
               "tsc05.tsc_file.tsc05,",
               "tsc09.tsc_file.tsc09,",
               "tsc10.tsc_file.tsc10,",
               "tsc11.tsc_file.tsc11,",
               "tsc06.tsc_file.tsc06,",
               "tsc07.tsc_file.tsc07,",
               "tsc08.tsc_file.tsc08,",
               "tsc18.tsc_file.tsc18,",
               "tsd02.tsd_file.tsd02,",
               "tsd03.tsd_file.tsd03,",
               "tsd12.tsd_file.tsd12,",
               "tsd13.tsd_file.tsd13,",
               "tsd14.tsd_file.tsd14,",
               "tsd04.tsd_file.tsd04,",
               "tsd05.tsd_file.tsd05,",
               "tsd09.tsd_file.tsd09,",
               "tsd10.tsd_file.tsd10,",
               "tsd11.tsd_file.tsd11,",
               "tsd06.tsd_file.tsd06,",
               "tsd07.tsd_file.tsd07,",
               "tsd08.tsd_file.tsd08,",
               "tsd15.tsd_file.tsd15"
   LET l_table =cl_prt_temptable('atmt260',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
 
    LET g_forupd_sql = " SELECT * FROM tsc_file WHERE tsc01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t260_cl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW t260_w WITH FORM "atm/42f/atmt260"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
    CALL cl_set_comp_visible("tsc20",g_aza.aza88 = 'Y')  #No.FUN-A50071 
    CALL cl_set_comp_visible("tsc20",FALSE)              #TQC-C20161 add
     
    LET g_wc2=' 1=1'   #0222
    IF g_sma.sma115 = 'Y' THEN
       CALL cl_set_comp_visible("tsc04,tsc05",FALSE)
       CALL cl_set_comp_visible("tsd04,tsd05",FALSE)
    ELSE
       CALL cl_set_comp_visible("tsc06,tsc07,tsc08",FALSE)
       CALL cl_set_comp_visible("tsc09,tsc10,tsc11",FALSE)
       CALL cl_set_comp_visible("tsd06,tsd07,tsd08",FALSE)
       CALL cl_set_comp_visible("tsd09,tsd10,tsd11",FALSE)
    END IF
    CALL cl_set_comp_visible("tsc07,tsc10",FALSE)
    CALL cl_set_comp_visible("tsd07,tsd10",FALSE)
 
    CALL cl_set_comp_visible("Page1,Page3",g_sma.sma95="Y")            #FUN-C80065 add
    CALL cl_set_act_visible("qry_lot_detail,qry_lot_header",g_sma.sma95="Y")  #FUN-C80065 add  


    IF g_azw.azw04 <> '2' THEN
       CALL cl_set_comp_visible('tscplant,tscplant_desc,tsccond,tscconu,tscconu_desc,tsccont',FALSE)
    END IF
 
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t260_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t260_a()
            END IF
         OTHERWISE
               CALL t260_q()
      END CASE
   END IF
 
    CALL t260_menu()
    CLOSE WINDOW t260_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION t260_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_tsd.clear()
 
  IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
     LET g_wc = " tsc01 = '",g_argv1,"'"
     LET g_wc2 = " 1=1"
  ELSE
     CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_tsc.* TO NULL    #No.FUN-750051
     CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
                       tsc01,tsc02,
                       tsc21,                 #MOD-AA0167
                       tsc17,tsc15,tsc16,tscconf,
                       tscpost,tsccond,tscconu,tsccont,tscplant,tsc03,tsc12,tsc13,tsc14,tsc04,tsc05, #FUN-870100 ADD
                       tsc09,tsc11,tsc06,tsc08,tsc19,tsc18,tsc20,  #No.FUN-930140 #FUN-A50071 add tsc20
                       tscuser,tscgrup,tscmodu,tscdate,tscacti,
                       tscoriu,tscorig,                      #TQC-A30048 ADD  
                       tscud01,tscud02,tscud03,tscud04,tscud05,
                       tscud06,tscud07,tscud08,tscud09,tscud10,
                       tscud11,tscud12,tscud13,tscud14,tscud15
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
 
     ON ACTION controlp
           CASE
               WHEN INFIELD(tsc01) #組合單號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_tsc"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tsc01
                 NEXT FIELD tsc01
               WHEN INFIELD(tsc17)    #理由碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_azf01"      #No.FUN-6B0065
                 LET g_qryparam.arg1 ="1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tsc17
                 NEXT FIELD tsc17
               WHEN INFIELD(tsc15)    #部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_gem"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tsc15
                 NEXT FIELD tsc15
               WHEN INFIELD(tsc16)    #部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_gen"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tsc16
                 NEXT FIELD tsc16
               WHEN INFIELD(tsc03)    #組合產品編號
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.state= "c"
#                LET g_qryparam.form = "q_ima01"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima01","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO tsc03
                 NEXT FIELD tsc03
               WHEN INFIELD(tsc12)    #倉庫
               #FUN-AB0014  --modify
               # CALL cl_init_qry_var()
               # LET g_qryparam.state= "c"
               # LET g_qryparam.form = "q_imd01"
               # CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
                #
                 DISPLAY g_qryparam.multiret TO tsc12
                 NEXT FIELD tsc12
               WHEN INFIELD(tsc13)    #儲位
                #FUN-AB0014  --modify
                #CALL cl_init_qry_var()
                #LET g_qryparam.state= "c"
                #LET g_qryparam.form = "q_ime"
                #LET g_qryparam.arg1 = g_tsc.tsc12
                #LET g_qryparam.arg2 = 'SW'
                #CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_ime_1(TRUE,TRUE,"","g_tsc.tsc12","",g_plant,"","","") RETURNING g_qryparam.multiret
                #FUN-AB0014  --modify
                 DISPLAY g_qryparam.multiret TO tsc13
                 NEXT FIELD tsc13
               WHEN INFIELD(tsc14)    #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_img"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tsc14
                 NEXT FIELD tsc14
               WHEN INFIELD(tsc04)    #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tsc04
                 NEXT FIELD tsc04
               WHEN INFIELD(tsc09)    #單位二
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tsc09
                 NEXT FIELD tsc09
               WHEN INFIELD(tsc06)    #單位一
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tsc06
                 NEXT FIELD tsc06
               WHEN INFIELD(tscconu)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_tscconu"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tscconu
                 NEXT FIELD tscconu
               WHEN INFIELD(tsc19)    #工單單號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_tsc19"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tsc19
                 NEXT FIELD tsc19
              OTHERWISE EXIT CASE
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
 
     CONSTRUCT g_wc2 ON tsd02,tsd03,tsd12,tsd13,tsd14,   #螢幕上取單身條件
                        tsd04,tsd05,tsd09,tsd11,tsd06,tsd08,tsd15
                        ,tsdud01,tsdud02,tsdud03,tsdud04,tsdud05
                        ,tsdud06,tsdud07,tsdud08,tsdud09,tsdud10
                        ,tsdud11,tsdud12,tsdud13,tsdud14,tsdud15
            FROM s_tsd[1].tsd02,s_tsd[1].tsd03,s_tsd[1].tsd12,
                 s_tsd[1].tsd13,s_tsd[1].tsd14,s_tsd[1].tsd04,
                 s_tsd[1].tsd05,s_tsd[1].tsd09,s_tsd[1].tsd11,
                 s_tsd[1].tsd06,s_tsd[1].tsd08,s_tsd[1].tsd15
                 ,s_tsd[1].tsdud01,s_tsd[1].tsdud02,s_tsd[1].tsdud03,s_tsd[1].tsdud04,s_tsd[1].tsdud05
                 ,s_tsd[1].tsdud06,s_tsd[1].tsdud07,s_tsd[1].tsdud08,s_tsd[1].tsdud09,s_tsd[1].tsdud10
                 ,s_tsd[1].tsdud11,s_tsd[1].tsdud12,s_tsd[1].tsdud13,s_tsd[1].tsdud14,s_tsd[1].tsdud15
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION controlp  #ok
            CASE
               WHEN INFIELD(tsd03)    #組合產品編號
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.state= "c"
#                LET g_qryparam.form = "q_ima01"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima01","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO tsd03
                 NEXT FIELD tsd03
               WHEN INFIELD(tsd12)    #倉庫
                #FUN-AB0014  --modify
                #CALL cl_init_qry_var()
                #LET g_qryparam.state= "c"
                #LET g_qryparam.form = "q_imd01"
                #CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
                #FUN-AB0014  --end
                 DISPLAY g_qryparam.multiret TO tsd12
                 NEXT FIELD tsd12
               WHEN INFIELD(tsd13)    #儲位
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_ime"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tsd13     #No.TQC-6B0046
                 NEXT FIELD tsd13                         #No.TQC-6B0046
               WHEN INFIELD(tsd14)    #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_img"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tsd14
                 NEXT FIELD tsd14
               WHEN INFIELD(tsd04)    #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tsd04
                 NEXT FIELD tsd04
               WHEN INFIELD(tsd09)    #單位二
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tsd09
                 NEXT FIELD tsd09
               WHEN INFIELD(tsd06)    #單位一
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tsd06
                 NEXT FIELD tsd06
              OTHERWISE EXIT CASE
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
     IF INT_FLAG THEN RETURN END IF
  END IF
  #資料權限的檢查
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tscuser', 'tscgrup')
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT tsc01 FROM tsc_file ",
                   " WHERE ", g_wc CLIPPED,
                   "   AND tscplant IN ",g_auth,   #FUN-870100 ADD  #TQC-A10152
                   " ORDER BY tsc01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE tsc_file.tsc01 ",
                   "  FROM tsc_file,tsd_file ",
                   " WHERE tsc01 = tsd01",
                   "   AND tscplant IN ",g_auth,   #FUN-870100 ADD  #TQC-A10152
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY tsc01"
    END IF
 
    PREPARE t260_prepare FROM g_sql
    DECLARE t260_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t260_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM tsc_file WHERE ",
                  " tscplant IN ",g_auth,   #FUN-870100 ADD
                  " AND ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT tsc01) ",
                  "FROM tsc_file,tsd_file ",
                  "WHERE tsd01=tsc01 AND ",
                  " tscplant IN ",g_auth," AND ",        #FUN-870100 ADD
                  g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t260_precount FROM g_sql
    DECLARE t260_count CURSOR FOR t260_precount
END FUNCTION
 
FUNCTION t260_menu()
   DEFINE   l_cmd    LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(100)
   DEFINE l_tscconf  LIKE tsc_file.tscconf       #add by zhangzs 210113
   DEFINE l_tscpost  LIKE tsc_file.tscpost       #add by zhangzs 210113
   DEFINE l_shb16    LIKE shb_file.shb16         #add by sx220617
   DEFINE l_shb081   LIKE shb_file.shb081        #add by sx220617
   DEFINE l_shb06    LIKE shb_file.shb06         #add by sx220617
   define i          integer #darcy:2024/07/04 add
   
   WHILE TRUE
      CALL t260_bp("G")
      CASE g_action_choice
      
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t260_a()
            END IF      
         WHEN "query"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
            IF cl_chk_act_auth() THEN
               CALL t260_q()
            END IF   
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t260_r()
            END IF    
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t260_u()
            END IF   
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t260_void(1)
            END IF   
         #FUN-D20039 ------------sta
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t260_void(2)
            END IF
         #FUN-D20039 ------------end
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t260_copy()
            END IF                 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t260_b()
               CALL t260_show ()   #CHI-C30106 add
            ELSE
               LET g_action_choice = NULL
            END IF                                 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t260_out()
            END IF                     
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "related_document"
            IF cl_chk_act_auth()  THEN
               IF g_tsc.tsc01 IS NOT NULL THEN
                 LET g_doc.column1 = "tsc01"
                 LET g_doc.value1 = g_tsc.tsc01
                 CALL cl_doc()
               END IF
            END IF  
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_tsd),'','')
             END IF     
              
         #CHI-A70027 add --start--
         WHEN "qry_lot_header"     #單頭批/序號查詢
            IF cl_chk_act_auth() THEN     
               CALL t260_qry_lot_header()
            END IF

         WHEN "qry_lot_detail"     #單身批/序號查詢
            IF l_ac > 0 THEN
               LET g_ima918 = ''
               LET g_ima921 = ''
               SELECT ima918,ima921 INTO g_ima918,g_ima921 
                 FROM ima_file
                WHERE ima01 = g_tsd[l_ac].tsd03
                  AND imaacti = "Y"
           
               IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  CALL t260_ima25(g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14,g_tsd[l_ac].tsd04)                   
                 #CALL s_lotout(g_prog,g_tsc.tsc01,g_tsd[l_ac].tsd02,0,  #TQC-B90236 mark
                  CALL s_mod_lot(g_prog,g_tsc.tsc01,g_tsd[l_ac].tsd02,0,  #TQC-B90236 add
                                g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,
                                g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14,
                                g_tsd[l_ac].tsd04,g_ima25,g_ima25_fac,
                                g_tsd[l_ac].tsd05,'','QRY',-1)   #TQC-B90236 add '-1'
                       RETURNING l_r,g_qty
               END IF
            END IF
         #CHI-A70027 add --end--                    

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t260_y()
            END IF           
         WHEN "unconfirm" #取消審核
            IF cl_chk_act_auth() THEN
               CALL t260_z()
            END IF            
         WHEN "post"     #過帳
            IF cl_chk_act_auth() THEN
            #add by zhangzs 210113  -----s------
               SELECT tscconf,tscpost INTO l_tscconf,l_tscpost FROM tsc_file WHERE tsc01 = g_tsc.tsc01
               IF l_tscconf = 'Y' AND l_tscpost = 'N' THEN 
               LET g_success='Y'
               BEGIN WORK
               #darcy:2024/07/04 add s---
               IF NOT cl_confirm('mfg0176') THEN 
                  let g_success ='N' #darcy:2024/07/04 add
                  continue while
               END IF     #TQC-640116
               call cl_progress_bar(11)
               #darcy:2024/07/04 add e---
               CALL ins_sfp()
               #add by zhangzs 201209  -----e------
               IF g_success = 'Y' THEN 
               CALL t260_post()
               #add by zhangzs 210206  ------s--------  修改工单下版数量
               SELECT shb05 INTO l_shb05 FROM shb_file WHERE shb01 = g_tsc.tscud02 #查工单号
               SELECT sfbud12 INTO l_sfbud12 FROM sfb_file WHERE sfb01 = l_shb05  #查下版数量
               IF l_sfbud12 IS NULL THEN 
                  LET l_sfbud12 = 0
               END IF 
               LET l_sfbud12 = l_sfbud12 + g_tsc.tsc05
               UPDATE sfb_file SET sfbud12 = l_sfbud12 WHERE sfb01 = l_shb05
               #add by zhangzs 210206  ------e--------

               #add by sx220617  ------s--------  更新sgm314当站下线量(入库)
               SELECT shb16, shb081,shb06 INTO l_shb16, l_shb081,l_shb06 FROM shb_file WHERE shb01 = g_tsc.tscud02 #查工单号
               
               UPDATE sgm_file SET sgm314 = sgm314 + g_tsc.tsc05 WHERE sgm01 = l_shb16 AND sgm03 = l_shb06 AND sgm04 = l_shb081
               #add by sx220617  ------e--------
               #darcy:2024/07/04 add s---
               call cl_safe_close_progress_bar()
               #darcy:2024/07/04 add e---
               
               IF g_success = 'Y' THEN
                   COMMIT WORK
                   SELECT COUNT(*) INTO l_sfp_count2 FROM sfp_file WHERE sfp01 = g_sfp.sfp01
                   SELECT COUNT(*) INTO l_sfp_count3 FROM sfp_file WHERE sfp01 = l_sfp.sfp01
                   IF l_sfp_count2 > 0 THEN 
                    LET g_msg="asfi520 '8' '",g_sfp.sfp01,"' 'query'"  #add by zhangzs 201210
                    CALL cl_cmdrun(g_msg )   #add by zhangzs 201210
                   END IF 
                   IF l_sfp_count3 > 0 THEN 
                    LET g_msg="asfi520 '9' '",l_sfp.sfp01,"' 'query'"  #add by zhangzs 201210
                    CALL cl_cmdrun(g_msg )   #add by zhangzs 201210
                   END IF 
                 #  IF l_sfp_count2 = 0 AND l_sfp_count3 = 0 THEN 
                 #   CALL cl_err('所有料号的退料数量大于已发数量，不可产生退料','!',1)
                 #  END IF 
                ELSE
                   ROLLBACK WORK
                END IF
               END IF 
               ELSE
                CALL cl_err('该笔单子不可过账','!',1)
               END IF
            END IF                    
            #darcy:2024/07/04 add s---
            select * into g_tsc.* from tsc_file where tsc01= g_tsc.tsc01
            call t260_show()
            #darcy:2024/07/04 add e---
         WHEN "undo_post"     #過帳還原
            IF cl_chk_act_auth() THEN
               CALL t260_undo_post()
            END IF
         #darcy:2023/12/21 add s---
         # 打开asfi528
         when "asfi528"
            if cl_chk_act_auth() then
               if not cl_null(g_tsc.tscud05) then
                  let g_msg="asfi520 '8' '",g_tsc.tscud04,"' 'query'"
                  call cl_cmdrun_wait(g_msg)
               end if
            end if
         #darcy:2023/12/21 add e---
         #darcy:2024/07/05 add s---
         when "csfq034"
            if g_tsc.tscpost='Y' then
               continue while
            end if
            let g_msg = "p_query csfq034 '",g_tsc.tsc01,"'"
            call cl_cmdrun_wait(g_msg)
         #darcy:2024/07/05 add e---
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t260_tscplant(p_cmd)
DEFINE  p_cmd        LIKE type_file.chr1
DEFINE  l_tscplant_desc LIKE gem_file.gem02
 
  SELECT azp02 INTO l_tscplant_desc FROM azp_file WHERE azp01 = g_plant 
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_tscplant_desc TO FORMONLY.tscplant_desc
  END IF
 
END FUNCTION
 
 
FUNCTION t260_tscconu(p_cmd)
DEFINE  p_cmd        LIKE type_file.chr1
DEFINE  l_tscconu_desc LIKE gen_file.gen02
 
  SELECT gen02 INTO l_tscconu_desc FROM gen_file WHERE gen01 = g_tsc.tscconu AND genacti='Y'
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_tscconu_desc TO FORMONLY.tscconu_desc
  END IF
 
END FUNCTION
 
#Add  輸入
FUNCTION t260_a()
DEFINE li_result     LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE l_ima55       LIKE ima_file.ima55,
       l_ima907      LIKE ima_file.ima907
 
    MESSAGE ""
    CLEAR FORM
    CALL g_tsd.clear()
 
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_tsc.* LIKE tsc_file.*             #DEFAULT 設置
    LET g_tsc01_t = NULL
    LET g_tsc_t.* = g_tsc.*
    LET g_tsc_o.* = g_tsc.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_tsc.tsc02=g_today            #組合日期
        LET g_tsc.tsc21=g_today            #MOD-AA0167
        LET g_tsc.tscconf='N'              #審核碼
        LET g_tsc.tsccond=''               #FUN-870100
        LET g_tsc.tscconu=''               #FUN-870100
        LET g_tsc.tsccont=''               #FUN-870100
        LET g_tsc.tscpost='N'              #過帳碼
        LET g_tsc.tsc05=0
        LET g_tsc.tsc08=0
        LET g_tsc.tsc11=0
        LET g_tsc.tscuser=g_user
        LET g_tsc.tscoriu = g_user      #No.FUN-980030 10/01/04
        LET g_tsc.tscorig = g_grup      #No.FUN-980030 10/01/04
        LET g_data_plant = g_plant #FUN-980030
        LET g_tsc.tscgrup=g_grup
        LET g_tsc.tscdate=g_today
        LET g_tsc.tscacti='Y'              #資料有效
        LET g_tsc.tscplant=g_plant
        DISPLAY g_tsc.tscplant TO tscplant
        CALL t260_tscplant('a')
        DISPLAY g_tsc.tsccond TO tsccond
        DISPLAY g_tsc.tscconu TO tscconu
        DISPLAY g_tsc.tsccont TO tsccont
      IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
         LET g_tsc.tsc01 = g_argv1
      END IF
 
        CALL t260_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #用戶不玩了
            INITIALIZE g_tsc.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_tsc.tsc01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        BEGIN WORK
 
  #      CALL s_auto_assign_no("aim",g_tsc.tsc01,g_tsc.tsc02,"F","tsc_file","tsc01","","","")               #FUN-AA0046  mark
        CALL s_auto_assign_no("atm",g_tsc.tsc01,g_tsc.tsc02,"U6","tsc_file","tsc01","","","")                #FUN-AA0046
             RETURNING li_result,g_tsc.tsc01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY g_tsc.tsc01 TO tsc01
 
        LET g_tsc.tscplant = g_plant #FUN-980009
        LET g_tsc.tsclegal = g_legal #FUN-980009
        INSERT INTO tsc_file VALUES (g_tsc.*)
        IF SQLCA.sqlcode THEN                 #置入資料庫不成功
            CALL cl_err3("ins","tsc_file",g_tsc.tsc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104        #FUN-B80061   ADD
            ROLLBACK WORK
           # CALL cl_err3("ins","tsc_file",g_tsc.tsc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104       #FUN-B80061   MARK
            CONTINUE WHILE
        ELSE
        COMMIT WORK
        CALL cl_flow_notify(g_tsc.tsc01,'I')
        END IF
        CALL t260_modi_lot_header() #CHI-A70027 add 
        SELECT tsc01 INTO g_tsc.tsc01 FROM tsc_file
            WHERE tsc01 = g_tsc.tsc01
        LET g_tsc01_t = g_tsc.tsc01        #保留舊值
        LET g_tsc_t.* = g_tsc.*
        LET g_tsc_o.* = g_tsc.*
        LET g_rec_b=0
        CALL t260_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t260_u()
#add by zhangzs 210113   -----s------
DEFINE l_tscud02      LIKE tsc_file.tscud02
DEFINE l_tsc05        LIKE tsc_file.tsc05
DEFINE l_tsd02        LIKE tsd_file.tsd02
DEFINE l_tsd03        LIKE tsd_file.tsd03
DEFINE l_bmb06        LIKE bmb_file.bmb06
DEFINE l_bmb07        LIKE bmb_file.bmb07
DEFINE l_tsd05        LIKE tsd_file.tsd05
DEFINE l_bmb03      LIKE bmb_file.bmb03
DEFINE l_count      LIKE type_file.num5
DEFINE g_tsd   RECORD      LIKE tsd_file.*
DEFINE l_shb05      LIKE shb_file.shb05
DEFINE l_sfb06      LIKE sfb_file.sfb06
DEFINE l_shb10      LIKE shb_file.shb10
DEFINE l_shb06      LIKE shb_file.shb06
DEFINE l_ecb03      LIKE ecb_file.ecb03
DEFINE l_ecbud04    LIKE ecb_file.ecbud04
DEFINE l_ecb06      LIKE ecb_file.ecb06
DEFINE l_sfa03      LIKE sfa_file.sfa03
DEFINE l_sfa12      LIKE sfa_file.sfa12
DEFINE l_sfa161     LIKE sfa_file.sfa161
DEFINE l_sfa06      LIKE sfa_file.sfa06
DEFINE l_sfa30      LIKE sfa_file.sfa30
DEFINE l_sfa31      LIKE sfa_file.sfa31
DEFINE l_sfaiicd03  LIKE sfai_file.sfaiicd03
DEFINE l_sfb09      LIKE sfb_file.sfb09
DEFINE l_sfb12      LIKE sfb_file.sfb12
DEFINE l_shb111     LIKE shb_file.shb111
DEFINE l_shb112     LIKE shb_file.shb112
DEFINE l_shb114     LIKE shb_file.shb114
#add by zhangzs 210113   -----e------
    IF s_shut(0) THEN RETURN END IF
    IF g_tsc.tsc01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_tsc.* FROM tsc_file WHERE tsc01=g_tsc.tsc01
    IF g_tsc.tscpost='Y' THEN CALL cl_err(g_tsc.tsc01,'afa-101',0) RETURN END IF
    IF g_tsc.tscconf='Y' THEN CALL cl_err(g_tsc.tsc01,'axm-101',0) RETURN END IF
    IF g_tsc.tscconf='X' THEN
       IF g_tsc.tscacti='Y' THEN            #若資料還有效
          CALL cl_err(g_tsc.tsc01,'9024',0)
          RETURN
       ELSE                                 #資料也已無效
          CALL cl_err(g_tsc.tsc01,'mfg1000',0)
          RETURN
       END IF
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_tsc01_t = g_tsc.tsc01
    BEGIN WORK
 
    OPEN t260_cl USING g_tsc.tsc01
    IF STATUS THEN
       CALL cl_err("OPEN t260_cl:", STATUS, 1)
       CLOSE t260_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t260_cl INTO g_tsc.*            # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tsc.tsc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t260_cl
        RETURN
    END IF
    CALL t260_show()
    WHILE TRUE
        LET g_tsc01_t = g_tsc.tsc01
        LET g_tsc_o.* = g_tsc.*
        LET g_tsc.tscmodu=g_user
        LET g_tsc.tscdate=g_today
        CALL t260_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_tsc.*=g_tsc_t.*
            CALL t260_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_tsc.tsc01 != g_tsc01_t THEN            # 更改單號
            UPDATE tsd_file SET tsd01 = g_tsc.tsc01
                WHERE tsd01 = g_tsc01_t
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","tsd_file",g_tsc.tsc01,"",SQLCA.sqlcode,"","tsd",1)  #No.FUN-660104
            END IF
        END IF
      UPDATE tsc_file SET tsc_file.* = g_tsc.*
      WHERE tsc01 = g_tsc01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","tsc_file",g_tsc.tsc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
            CONTINUE WHILE
        END IF
      #add by zhangzs 210113  -----s-----
      SELECT tscud02,tsc05 INTO l_tscud02,l_tsc05 FROM tsc_file WHERE tsc01 = g_tsc.tsc01
      IF l_tscud02 = '' OR l_tscud02 IS NULL THEN 
      ELSE 
         DELETE FROM tsd_file WHERE tsd01 = g_tsc.tsc01
      #atmt260单身
        SELECT shb05,shb10,shb06 INTO l_shb05,l_shb10,l_shb06 FROM shb_file WHERE shb01 = g_tsc.tscud02   #通过移转单号查询工单号,产品料号,工艺序
        SELECT sfb06 INTO l_sfb06 FROM sfb_file WHERE sfb01 = l_shb05  #工单上的工艺编号
        #通过产品料号和工艺编号在aeci100查出大于等于工艺序查出工艺序，作业编号,物料代号,排除物料代号为空的情况
        LET g_sql = "SELECT ecb03,ecb06,ecbud04 ",  
                    "FROM ecb_file ",
                    "WHERE ecb01 = '",l_shb10,"'",
                    " and ecbud04 is not null and ecb02 ='",l_sfb06,"'",
                    " and ecb03 >='",l_shb06,"'",
                    " group by ecb03,ecb06,ecbud04"
        
        PREPARE oea_pre1 FROM g_sql
        DECLARE oea_cur3 CURSOR WITH HOLD FOR oea_pre1
        LET l_count = 0
        FOREACH oea_cur3 INTO l_ecb03,l_ecb06,l_ecbud04
        #通过工单号和作业编号查询工单对应的发料料号，单位，实际QPA，已发数量，仓库，库位，批号
            LET g_sql2 = "SELECT sfa03,sfa12,sfa161,sfa06,sfa30,sfa31,' ' ",  
                    "FROM sfa_file ",
                    "WHERE sfa01 = '",l_shb05,"'",
                    " and sfa08 ='",l_ecb06,"'"
                    
           PREPARE oea_pre3 FROM g_sql2
           DECLARE oea_cur4 CURSOR WITH HOLD FOR oea_pre3
           FOREACH oea_cur4 INTO l_sfa03,l_sfa12,l_sfa161,l_sfa06,l_sfa30,l_sfa31,l_sfaiicd03
            #SELECT shb111,shb112,shb114 INTO l_shb111,l_shb112,l_shb114 FROM shb_file WHERE shb05 = l_shb05 AND shb06 = l_ecb03  #通过移转单号查询良品转出数量,当战报废，当站下线  #mark by zhangzs 210206
			SELECT SUM(shb111),SUM(shb112),SUM(shb114) INTO l_shb111,l_shb112,l_shb114 FROM shb_file WHERE shb05 = l_shb05 AND shb06 = l_ecb03  #通过移转单号查询良品转出数量,当战报废，当站下线  #add by zhangzs 210206
            SELECT sfb09,sfb12 INTO l_sfb09,l_sfb12 FROM sfb_file WHERE sfb01 = l_shb05  #完工数量，报废数量
            INITIALIZE g_tsd.* TO NULL
            LET g_tsd.tsd01 = g_tsc.tsc01
            LET l_count = l_count + 1
            LET g_tsd.tsd02 = l_count   #项次
            LET g_tsd.tsd03 = l_sfa03   #料号
            LET g_tsd.tsd04 = l_sfa12 #单位

            LET g_tsd.tsd05 = l_sfa06 - ((l_shb112 + l_shb114 + l_shb111) * l_sfa161)  #数量   #已发数量-（当战报废+当站下线+730良品转出数量）*实际QPA
            SELECT ROUND(g_tsd.tsd05,0) INTO g_tsd.tsd05 FROM DUAL    #add by sx200814
            LET g_tsd.tsd08 = 0              #body default
            LET g_tsd.tsd11 = 0              #body default
            LET g_tsd.tsdplant = g_plant
            LET g_tsd.tsdlegal = g_legal
            SELECT sfe08,sfe09,sfe10 INTO g_tsd.tsd12,g_tsd.tsd13,g_tsd.tsd14 FROM sfe_file WHERE sfe01 = l_shb05 AND sfe07 = l_sfa03
            IF g_tsd.tsd05 > 0 THEN 
              INSERT INTO tsd_file VALUES (g_tsd.*)
            END IF 
            IF STATUS OR SQLCA.SQLCODE THEN
             #  ROLLBACK WORK   #No:7829
               #CALL cl_err('新增到atmt260单身失败','!',1)
               EXIT FOREACH 
            ELSE 
            END IF 
            END FOREACH 
        END FOREACH  
      END IF 
       CALL t260_show()
      #add by zhangzs 210113  -----s-----
 
        EXIT WHILE
    END WHILE
    CLOSE t260_cl
    COMMIT WORK
    CALL cl_flow_notify(g_tsc.tsc01,'U')
END FUNCTION
 
#處理INPUT
FUNCTION t260_i(p_cmd)
DEFINE
    l_pmc05   LIKE pmc_file.pmc05,
    l_pmc30   LIKE pmc_file.pmc30,
    l_n,l_i   LIKE type_file.num5,          #No.FUN-680120 SMALLINT
    p_cmd     LIKE type_file.chr1           #a:輸入 u:更改        #No.FUN-680120 VARCHAR(1)
DEFINE l_code  LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE l_code1 LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE li_result   LIKE type_file.num5      #No.FUN-680120 SMALLINT
DEFINE l_ima55     LIKE ima_file.ima55,
       l_ima35     LIKE ima_file.ima35,
       l_ima36     LIKE ima_file.ima36,
       l_ima906    LIKE ima_file.ima906,
       l_ima907    LIKE ima_file.ima907,
       sn1,sn2     LIKE type_file.num5      #No.FUN-680120 SMALLINT
DEFINE l_ima159   LIKE ima_file.ima159      #CHI-CB0064 add
 
 
    IF s_shut(0) THEN RETURN END IF
 
    DISPLAY BY NAME
        g_tsc.tsc01,g_tsc.tsc02,g_tsc.tsc17,g_tsc.tsc15,
        g_tsc.tsc16,g_tsc.tscconf,g_tsc.tscpost,g_tsc.tsccond,g_tsc.tscconu,g_tsc.tsccont,g_tsc.tscplant,g_tsc.tsc03, #FUN-870100
        g_tsc.tsc12,g_tsc.tsc13,g_tsc.tsc14,g_tsc.tsc04,g_tsc.tsc05,
        g_tsc.tsc09,g_tsc.tsc11,g_tsc.tsc06,g_tsc.tsc08,g_tsc.tsc18,
        g_tsc.tsc19,g_tsc.tsc20,            #No.FUN-930140#FUN-A50071 add tsc20
        g_tsc.tscuser,g_tsc.tscgrup,g_tsc.tscmodu,g_tsc.tscdate,g_tsc.tscacti
       ,g_tsc.tscoriu,g_tsc.tscorig                      #TQC-A30048 ADD
       ,g_tsc.tsc21                                      #MOD-AA0167 
 
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME 
        g_tsc.tsc01,g_tsc.tsc02,
        g_tsc.tsc21,             #MOD-AA0167
        g_tsc.tsc17,g_tsc.tsc15,
        g_tsc.tsc16,g_tsc.tscconf,g_tsc.tscpost,g_tsc.tsc03,
        g_tsc.tsc12,g_tsc.tsc13,g_tsc.tsc14,g_tsc.tsc04,g_tsc.tsc05,
        g_tsc.tsc09,g_tsc.tsc11,g_tsc.tsc06,g_tsc.tsc08,g_tsc.tsc19,   #No.FUN-930140
        g_tsc.tsc18,g_tsc.tsc20,  #FUN-A50071 add tsc20
        g_tsc.tscuser,g_tsc.tscgrup,g_tsc.tscmodu,g_tsc.tscdate,g_tsc.tscacti,
        g_tsc.tscud01,g_tsc.tscud02,g_tsc.tscud03,g_tsc.tscud04,
        g_tsc.tscud05,g_tsc.tscud06,g_tsc.tscud07,g_tsc.tscud08,
        g_tsc.tscud09,g_tsc.tscud10,g_tsc.tscud11,g_tsc.tscud12,
        g_tsc.tscud13,g_tsc.tscud14,g_tsc.tscud15
                      WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t260_set_entry(p_cmd)
            CALL t260_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_set_comp_entry("tsc09,tsc11",TRUE)
            CALL cl_set_act_visible("modi_lot_header",g_sma.sma95="Y")  #FUN-C80065 add
            CALL cl_set_docno_format("tsc01")
            IF p_cmd = 'u' THEN
              IF g_sma.sma115='Y' THEN
                 CALL t260_du_default(p_cmd)
              END IF
            END IF
            #No.FUN-BB0086--add--begin--
            IF p_cmd = 'u' THEN 
               LET g_tsc04_t = g_tsc.tsc04
               LET g_tsc06_t = g_tsc.tsc06
               LET g_tsc09_t = g_tsc.tsc09
            END IF 
            IF p_cmd = 'a' THEN 
               LET g_tsc04_t = NULL 
               LET g_tsc06_t = NULL
               LET g_tsc09_t = NULL
            END IF 
            #No.FUN-BB0086--add--end--
 
        AFTER FIELD tsc01
            IF NOT cl_null(g_tsc.tsc01) THEN
#               CALL s_check_no("aim",g_tsc.tsc01,g_tsc_t.tsc01,"F","tsc_file","tsc01","")               #FUN-AA0046  mark
                CALL s_check_no("atm",g_tsc.tsc01,g_tsc_t.tsc01,"U6","tsc_file","tsc01","")               #FUN-AA0046
                    RETURNING li_result,g_tsc.tsc01
               DISPLAY g_tsc.tsc01 TO tsc01
               IF (NOT li_result) THEN
                  LET g_tsc.tsc01=g_tsc_o.tsc01
                  NEXT FIELD tsc01
               END IF
            END IF
 
 #MOD-AA0167 --begin--
       AFTER FIELD tsc21
            IF NOT cl_null(g_tsc.tsc21) THEN 
               IF g_sma.sma53 IS NOT NULL AND g_tsc.tsc21 <= g_sma.sma53 THEN 
                  CALL cl_err('','mfg9999',0)
                  NEXT FIELD CURRENT 
               END IF    
               CALL s_yp(g_tsc.tsc21) RETURNING g_yy,g_mm
               IF g_yy*12+g_mm > g_sma.sma51*12+g_sma.sma52 THEN #不可大於現行年月
                  CALL cl_err('','mfg6091',0)
                  NEXT FIELD CURRENT 
               END IF            
            END IF 
 #MOD-AA0167 --end--
 
        AFTER FIELD tsc17
            IF NOT cl_null(g_tsc.tsc17) THEN
                  CALL t260_tsc17('d')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_tsc.tsc17,g_errno,1)
                     LET g_tsc.tsc17 = g_tsc_o.tsc17
                     DISPLAY BY NAME g_tsc.tsc17
                     NEXT FIELD tsc17
                  END IF
             END IF
 
        AFTER FIELD tsc15
            IF NOT cl_null(g_tsc.tsc15) THEN
                  CALL t260_tsc15('d')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_tsc.tsc15,g_errno,1)
                     LET g_tsc.tsc15 = g_tsc_o.tsc15
                     DISPLAY BY NAME g_tsc.tsc15
                     NEXT FIELD tsc15
                  END IF
             END IF
 
        AFTER FIELD tsc16
            IF NOT cl_null(g_tsc.tsc16) THEN
                  CALL t260_tsc16('d')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_tsc.tsc16,g_errno,1)
                     LET g_tsc.tsc16 = g_tsc_o.tsc16
                     DISPLAY BY NAME g_tsc.tsc16
                     NEXT FIELD tsc16
                  END IF
             END IF
 
        AFTER FIELD tsc04
            IF NOT cl_null(g_tsc.tsc04) THEN
                 SELECT count(*) INTO l_n
                   FROM gfe_file
                  WHERE gfe01 = g_tsc.tsc04
                    AND gfeacti = 'Y'
                 IF l_n = 0 THEN
                    CALL cl_err(g_tsc.tsc04,'mfg0019',0)  #無此單位編號
                    NEXT FIELD tsc04
                 END IF
                 IF g_tsc.tsc04=g_img09 THEN
                    LET g_tsc.tsc041 = 1
                 ELSE
                   #Check 單位與庫存明細單位換算關系并且返回換算率
                   #CALL s_umfchk(g_tsc.tsc03,g_tsc.tsc04,g_img.img09) #FUN-CC0057
                    CALL s_umfchk(g_tsc.tsc03,g_tsc.tsc04,g_img09)     #FUN-CC0057
                         RETURNING g_cnt,g_tsc.tsc041
                    IF g_cnt = 1 THEN
                       CALL cl_err('','mfg3075',0)
                       NEXT FIELD tsc04
                    END IF
                 END IF 
                 #No.FUN-BB0086--add--begin-- 
                 IF NOT t260_tsc05_check(p_cmd) THEN 
                    LET g_tsc04_t = g_tsc.tsc04
                    NEXT FIELD tsc05 
                 END IF 
                 LET g_tsc04_t = g_tsc.tsc04
                 #No.FUN-BB0086--add--end--
            END IF
 
        AFTER FIELD tsc05
           IF NOT t260_tsc05_check(p_cmd) THEN NEXT FIELD tsc05 END IF   #No.FUN-BB0086
            #No.FUN-BB0086--mark--begin--
            #IF NOT cl_null(g_tsc.tsc05) THEN
            #   IF g_tsc.tsc05 < 0 THEN
            #      CALL cl_err('','mfg9243',0)
            #      NEXT FIELD tsc05
            #   END IF
            #END IF
            #
            # #CHI-A70027 add --start--
            # IF p_cmd = 'u' THEN 
            #    CALL t260_modi_lot_header() 
            # END IF
            # #CHI-A70027 add --end--
            #No.FUN-BB0086--mark--end--
 
        BEFORE FIELD tsc09
            CALL t260_sel_ima()   #0215
            CALL cl_set_comp_required("tsc06,tsc08,tsc09,tsc11",FALSE)
 
        AFTER FIELD tsc09
            IF NOT cl_null(g_tsc.tsc09) THEN
               SELECT count(*) INTO l_n
                 FROM gfe_file
                WHERE gfe01=g_tsc.tsc09
                  AND gfeacti='Y'
               IF l_n = 0 THEN
                  CALL cl_err(g_tsc.tsc09,'mfg0019',0)
                  NEXT FIELD tsc09
               END IF
               CALL cl_set_comp_required("tsc11",TRUE)
 
               #Check 單位二與生產單位的換算關系并返回換算率
               CALL s_du_umfchk(g_tsc.tsc03,'','','',g_img09,g_tsc.tsc09,g_ima906)
                    returning g_errno,g_tsc.tsc10
 
               CALL s_chk_imgg(g_tsc.tsc03,g_tsc.tsc12,g_tsc.tsc13,g_tsc.tsc14,g_tsc.tsc09)  # Check 多單位第二單位庫存明細是否存在
                    RETURNING l_code
               IF l_code THEN
                    IF g_sma.sma892[3,3]='Y' THEN
                       IF NOT cl_confirm('aim-995') THEN
                          NEXT FIELD tsc09
                       END IF
                    END IF
                    CALL s_add_imgg(g_tsc.tsc03,g_tsc.tsc12,g_tsc.tsc13,g_tsc.tsc14,g_tsc.tsc09,g_tsc.tsc10,g_tsc.tsc01,'',0)
                       RETURNING l_code1
                    IF l_code1 THEN
                       CALL cl_err('','lib-028',0)
                    END IF
               END IF
               DISPLAY g_tsc.tsc10 TO tsc10
               #No.FUN-BB0086--add--begin--
               IF NOT t260_tsc11_check() THEN 
                  LET g_tsc09_t = g_tsc.tsc09
                  NEXT FIELD tsc11
               END IF 
               LET g_tsc09_t = g_tsc.tsc09
               #No.FUN-BB0086--add--end-- 
            END IF
 
        BEFORE FIELD tsc11
           IF cl_null(g_tsc.tsc03) THEN NEXT FIELD tsc03 END IF
           IF g_tsc.tsc12 IS NULL OR g_tsc.tsc13 IS NULL OR
              g_tsc.tsc14 IS NULL THEN
              NEXT FIELD tsc14
           END IF
           IF NOT cl_null(g_tsc.tsc09) AND g_ima906 = '3' THEN
              CALL s_chk_imgg(g_tsc.tsc03,g_tsc.tsc12,
                              g_tsc.tsc13,g_tsc.tsc14,
                              g_tsc.tsc09) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN
                       NEXT FIELD tsc03
                    END IF
                 END IF
                 CALL s_add_imgg(g_tsc.tsc03,g_tsc.tsc12,
                                 g_tsc.tsc13,g_tsc.tsc14,
                                 g_tsc.tsc09,g_tsc.tsc10,
                                 g_tsc.tsc01,'',0) RETURNING g_flag
                 IF g_flag = 1 THEN
                    NEXT FIELD tsc03
                 END IF
              END IF
           END IF
 
 
        AFTER FIELD tsc11
           IF NOT t260_tsc11_check() THEN NEXT FIELD tsc11 END IF   #No.FUN-BB0086
            #No.FUN-BB0086--mark--begin--
            #IF NOT cl_null(g_tsc.tsc11) THEN
            #   IF g_tsc.tsc11 < 0 THEN
            #      CALL cl_err('','mfg9243',0)
            #      NEXT FIELD tsc11
            #   END IF
            #   IF g_ima906='3' THEN
            #      LET g_tot=g_tsc.tsc11*g_tsc.tsc10
            #      IF cl_null(g_tsc.tsc08) OR g_tsc.tsc08=0 THEN #CHI-960022
            #         LET g_tsc.tsc08=g_tot
            #         DISPLAY BY NAME g_tsc.tsc08
            #      END IF                                        #CHI-960022
            #   END IF
            #END IF
            #No.FUN-BB0086--mark--end--
 
        BEFORE FIELD tsc06
            CALL t260_sel_ima()   #0215
            CALL cl_set_comp_required("tsc06,tsc08,tsc09,tsc11",FALSE)
 
        AFTER FIELD tsc06
            IF NOT cl_null(g_tsc.tsc06) THEN
                 SELECT count(*) INTO l_n
                   FROM gfe_file
                  WHERE gfe01 = g_tsc.tsc06
                    AND gfeacti = 'Y'
                 IF l_n = 0 THEN
                    CALL cl_err(g_tsc.tsc06,'mfg0019',0)  #無此單位編號
                    NEXT FIELD tsc06
                 END IF
                 CALL cl_set_comp_required("tsc08",TRUE)
                 #Check 單位與庫存明細單位換算關系并且返回換算率
                 CALL s_du_umfchk(g_tsc.tsc03,'','','',g_tsc.tsc04,g_tsc.tsc06,g_ima906)
                      returning g_errno,g_tsc.tsc07
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_tsc.tsc06,g_errno,0)
                    NEXT FIELD tsc06
                 END IF
                 IF g_ima906='2' THEN
                    CALL s_chk_imgg(g_tsc.tsc03,g_tsc.tsc12,g_tsc.tsc13,g_tsc.tsc14,g_tsc.tsc06)  # Check 多單位第二單位庫存明細是否存在
                         RETURNING l_code
                    IF l_code THEN
                       IF g_sma.sma892[3,3]='Y' THEN
                          IF NOT cl_confirm('aim-995') THEN
                             NEXT FIELD tsc06
                          END IF
                       END IF
                       CALL s_add_imgg(g_tsc.tsc03,g_tsc.tsc12,g_tsc.tsc13,g_tsc.tsc14,g_tsc.tsc06,g_tsc.tsc07,g_tsc.tsc01,'',0)
                           RETURNING l_code1
                       IF l_code1 THEN
                          CALL cl_err('','lib-028',0)
                       END IF
                    END IF
                 END IF
                 DISPLAY g_tsc.tsc07 TO tsc07
                 #No.FUN-BB0086--add--begin--
                 IF NOT t260_tsc08_check() THEN 
                    LET g_tsc06_t = g_tsc.tsc06
                    NEXT FIELD tsc08
                 END IF 
                 LET g_tsc06_t = g_tsc.tsc06
                 #No.FUN-BB0086--add--begin--
            END IF
 
        AFTER FIELD tsc08
           IF NOT t260_tsc08_check() THEN NEXT FIELD tsc08 END IF   #No.FUN-BB0086
            #No.FUN-BB0086--mark--begin--
            #IF NOT cl_null(g_tsc.tsc08) THEN
            #   IF g_tsc.tsc08 < 0 THEN
            #      CALL cl_err('','mfg9243',0)
            #      NEXT FIELD tsc08
            #   END IF
            #   CALL t260_du_data_to_correct()
            #   CALL t260_set_origin_field()
            #END IF
            #No.FUN-BB0086--mark--end--
 
        BEFORE FIELD tsc03
            CALL cl_set_comp_required("tsc06,tsc08,tsc09,tsc11",false)
            CALL t260_set_entry_tsc() #CHI-CB0064 add
 
        AFTER FIELD tsc03                  #產品編號
            IF cl_null(g_tsc.tsc03) THEN
                  CALL cl_err('','aap-099',0)
                  NEXT FIELD tsc03
#FUN-AA0059 ---------------------start----------------------------
            ELSE
               IF NOT s_chk_item_no(g_tsc.tsc03,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_tsc.tsc03= g_tsc_t.tsc03 
                  NEXT FIELD tsc03
               END IF
#FUN-AA0059 ---------------------end-------------------------------
            END IF
 
            CALL t260_sel_ima()     #0215
 
            IF g_sma.sma115= 'Y' AND g_ima906 = '1' THEN
               CALL cl_set_comp_entry("tsc09,tsc11",FALSE)
            END IF
            IF g_sma.sma115= 'Y' AND g_ima906 = '3' THEN
               CALL cl_set_comp_entry("tsc11",TRUE)
               CALL cl_set_comp_entry("tsc09",FALSE)
            END IF
            IF g_sma.sma115= 'Y' AND g_ima906 = '2' THEN
               CALL cl_set_comp_entry("tsc09,tsc11,tsc06,tsc08",TRUE)
               CALL cl_set_comp_required("tsc09,tsc11,tsc06,tsc08",FALSE)
            END IF
            IF g_sma.sma115= 'Y' AND NOT cl_null(g_tsc.tsc09) THEN  #No.TQC-930079 add
               CALL cl_set_comp_required("tsc11",TRUE)
            END IF
            IF g_sma.sma115= 'Y' AND NOT cl_null(g_tsc.tsc06) THEN  #No.TQC-930079 add
               CALL cl_set_comp_required("tsc08",TRUE)
            END IF
 
            IF NOT cl_null(g_tsc.tsc03) THEN
              IF p_cmd='a' OR (p_cmd='u' AND g_tsc.tsc03 != g_tsc_t.tsc03) THEN
                 #add by zhangzs 210113 ----s-----
                 SELECT ima35,ima36 INTO g_tsc.tsc12,g_tsc.tsc13 FROM ima_file WHERE ima01 = g_tsc.tsc03  #仓库，库位
                 SELECT ima25 INTO g_tsc.tsc04 FROM ima_file WHERE ima01 = g_tsc.tsc03  #单位
                 #add by zhangzs 210113 ----e-----
                 SELECT count(*) INTO l_n FROM ima_file
                     WHERE ima01 = g_tsc.tsc03
                 IF l_n = 0 THEN
                     CALL cl_err(g_tsc.tsc03,'ams-003',0)
                     LET g_tsc.tsc03 = g_tsc_t.tsc03
                     NEXT FIELD tsc03
                 ELSE
                     IF g_sma.sma115 = 'Y' THEN  #使用多單位
                        CALL s_chk_va_setting(g_tsc.tsc03)   #(檢查多單位使用方式是否與參數設定一致)
                           RETURNING g_flag,g_ima906,g_ima907
                        IF g_flag=1 THEN
                           NEXT FIELD tsc03
                        END IF
                        IF g_ima906 = '3' THEN   #(使用參考單位)
                           LET g_tsc.tsc09=g_ima907
                           DISPLAY BY NAME g_tsc.tsc09
                        END IF
                     END IF
                     CALL t260_tsc03('d')
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_tsc.tsc03,g_errno,0)
                        NEXT FIELD tsc03
                     END IF
                     CALL t260_du_default(p_cmd)
                     #No.FUN-BB0086--add--begin--
                     LET g_tsc.tsc08 = s_digqty(g_tsc.tsc08,g_tsc.tsc06)
                     LET g_tsc.tsc11 = s_digqty(g_tsc.tsc11,g_tsc.tsc09)
                     DISPLAY BY NAME g_tsc.tsc08,g_tsc.tsc11
                     #No.FUN-BB0086--add--end--
                     SELECT ima35,ima36,ima55 INTO l_ima35,l_ima36,l_ima55
                       FROM ima_file
                      WHERE ima01=g_tsc.tsc03
                     LET g_tsc.tsc12 = l_ima35
                     LET g_tsc.tsc13 = l_ima36
                     DISPLAY g_tsc.tsc12 TO tsc12    #倉庫預設值
                     DISPLAY g_tsc.tsc13 TO tsc13    #儲位預設值
                     DISPLAY g_tsc.tsc04 TO tsc04    #單位預設值
                     DISPLAY g_tsc.tsc06 TO tsc06    #單位一預設值
                     DISPLAY g_tsc.tsc08 TO tsc08
                     DISPLAY g_tsc.tsc09 TO tsc09   #單位二預設值
                     DISPLAY g_tsc.tsc10 TO tsc10
                     DISPLAY g_tsc.tsc11 TO tsc11
                  END IF
               END IF
            END IF
            CALL t260_set_no_entry_tsc() #CHI-CB0064 add
 
        AFTER FIELD tsc12
           IF cl_null(g_tsc.tsc12) THEN
              NEXT FIELD tsc12
           END IF
           IF g_tsc.tsc12 IS NULL THEN
              LET g_tsc.tsc12 = ' '
           END IF
           IF NOT cl_null(g_tsc.tsc12) THEN
             ##CHI-D20014 add str 倉庫、庫位控管 还原
             ##------------------------------------ 檢查料號預設倉儲及單別預設倉儲
             #IF NOT s_chksmz(g_tsc.tsc03,g_tsc.tsc01,g_tsc.tsc12,g_tsc.tsc13) THEN
             #   NEXT FIELD tsc12
             #END IF
             ##CHI-D20014 add end 还原
              IF NOT s_imfchk1(g_tsc.tsc03,g_tsc.tsc12) THEN
                 CALL cl_err('s_imfchk1','mfg9036',0)
                 NEXT FIELD tsc03
              END IF
              CALL s_stkchk(g_tsc.tsc12,'A') RETURNING l_code
              IF NOT l_code THEN
                 CALL cl_err('s_stkchk','mfg1100',0)
                 NEXT FIELD tsc12
              END IF
              CALL s_swyn(g_tsc.tsc12) RETURNING sn1,sn2
                  IF sn1=1 AND g_tsc.tsc12 != g_tsc_t.tsc12 THEN
                     LET g_tsc_t.tsc12=g_tsc.tsc12
                     CALL cl_err(g_tsc.tsc12,'mfg6080',0) NEXT FIELD tsc12
                  ELSE
                     IF sn2=2 AND g_tsc.tsc12 != g_tsc_t.tsc12 THEN
                        CALL cl_err(g_tsc.tsc12,'mfg6085',0)
                        LET g_tsc_t.tsc12=g_tsc.tsc12
                        NEXT FIELD tsc12
                     END IF
                  END IF
                  LET sn1=0 LET sn2=0
           END IF
#FUN-AB0014  --modify
           IF NOT s_chk_ware(g_tsc.tsc12) THEN
              NEXT FIELD tsc12
           END IF 
#FUN-AB0014  --end
    #FUN-AB0014  --end
       #TQC-D50124 --------Begin-------
         ##FUN-D40103 ------Begin-------
         # IF NOT s_imechk(g_tsc.tsc12,g_tsc.tsc13) THEN
         #    NEXT FIELD tsc13
         # END IF
         ##FUN-D40103 ------End---------
       #TQC-D50124 --------End--------
 
        AFTER FIELD tsc13
           IF cl_null(g_tsc.tsc13) THEN  #全型空白
              LET g_tsc.tsc13 = ' '
           END IF
           IF NOT cl_null(g_tsc.tsc13) THEN
             # IF NOT cl_null(g_tsc.tsc12) THEN #CHI-D20014 add 还原
              #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
              IF NOT s_chksmz(g_tsc.tsc03,g_tsc.tsc01,g_tsc.tsc12,g_tsc.tsc13) THEN
                 NEXT FIELD tsc13
              END IF
             # END IF #CHI-D20014 add 还原  
              #------>check-1  檢查該料是否可收至該倉/儲位
              IF NOT s_imfchk(g_tsc.tsc03,g_tsc.tsc12,
                              g_tsc.tsc13) THEN
                 CALL cl_err(g_tsc.tsc13,'mfg6095',0) NEXT FIELD tsc13
              END IF
              CALL s_lwyn(g_tsc.tsc12,g_tsc.tsc13)
                   RETURNING sn1,sn2    #可用否
              IF sn2 = 2 THEN
                 IF g_pmn38 = 'Y' THEN CALL cl_err('','mfg9132',0) END IF
              ELSE
                 IF g_pmn38 = 'N' THEN CALL cl_err('','mfg9131',0) END IF
              END IF
              LET sn1=0 LET sn2=0
           END IF
#TQC-D50124 -------Begin--------
       #  #FUN-D40103 ------Begin-------
       #   IF NOT s_imechk(g_tsc.tsc12,g_tsc.tsc13) THEN
       #      NEXT FIELD tsc13
       #   END IF
       #  #FUN-D40103 ------End---------
     #TQC-D50124 -------End----------
 
        AFTER FIELD tsc14
            IF cl_null(g_tsc.tsc14) THEN
            #CHI-CB0064---add---START
               LET l_ima159 = ''
               SELECT ima159 INTO l_ima159 FROM ima_file
                WHERE ima01 = g_tsc.tsc03
               IF l_ima159 = '1' THEN
                  CALL cl_err(g_tsc.tsc14,'aim-034',1)
                  NEXT FIELD tsc14
               ELSE
            #CHI-CB0064---add-----END
                 LET g_tsc.tsc14=' '
               END IF #CHI-CB0064 add
            END IF
            IF NOT cl_null(g_tsc.tsc03) AND NOT cl_null(g_tsc.tsc12) THEN
              SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
               WHERE img01=g_tsc.tsc03 AND img02=g_tsc.tsc12
                 AND img03=g_tsc.tsc13 AND img04=g_tsc.tsc14
              IF SQLCA.sqlcode=100 THEN
                 IF NOT cl_confirm('mfg1401') THEN
                    NEXT FIELD tsc03
                 END IF
                 CALL s_add_img(g_tsc.tsc03,g_tsc.tsc12,
                                g_tsc.tsc13,g_tsc.tsc14,
#                               g_tsc.tsc01,'0',g_tsc.tsc02)   #MOD-AA0167
                                g_tsc.tsc01,'0',g_tsc.tsc21)   #MOD-AA0167
                 IF g_errno='N' THEN
                    NEXT FIELD tsc03
                 END IF
                 SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
                  WHERE img01=g_tsc.tsc03 AND img02=g_tsc.tsc12
                    AND img03=g_tsc.tsc13 AND img04=g_tsc.tsc14
              END IF
              IF cl_null(g_tsc.tsc04) THEN
                 LET g_tsc.tsc04=g_img09
              END IF
 
              SELECT COUNT(*) INTO g_cnt FROM img_file
               WHERE img01=g_tsc.tsc03
                 AND img02=g_tsc.tsc12
                 AND img03=g_tsc.tsc13
                 AND img04=g_tsc.tsc14
#                 AND img18<g_tsc.tsc02              #MOD-AA0167
                  AND img18<g_tsc.tsc21              #MOD-AA0167
             IF g_cnt > 0 THEN
                CALL cl_err('','aim-400',0)
                NEXT FIELD tsc14
             END IF
             IF g_sma.sma115='Y' THEN
                CALL t260_du_default(p_cmd)
             END IF
              SELECT *  INTO g_img1.*   #重新取得庫存明細資料
                FROM img_file
               WHERE img01=g_tsc.tsc03
                 AND img02=g_tsc.tsc12
                 AND img03=g_tsc.tsc13
                 AND img04=g_tsc.tsc14
           END IF
 
        AFTER FIELD tscud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tscud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tscud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tscud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tscud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tscud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tscud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tscud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tscud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tscud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tscud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tscud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tscud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tscud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tscud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
 
        AFTER INPUT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             EXIT INPUT
          END IF
 
          CALL t260_du_data_to_correct()
          CALL t260_set_origin_field()
          SELECT count(*) INTO l_n FROM img_file
           WHERE img01=g_tsc.tsc03
             AND img02=g_tsc.tsc12
             AND img03=g_tsc.tsc13
             AND img04=g_tsc.tsc14
          IF l_n = 0 THEN
             CALL cl_err(g_tsc.tsc03,'mfg6069',0)
             NEXT FIELD tsc03
          END IF
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(tsc01) #組合單號
                 LET g_t1 = s_get_doc_no(g_tsc.tsc01)
         #       CALL q_smy(FALSE,FALSE,g_t1,'AIM','F')   #TQC-670008   #FUN-AA0046  mark
                 CALL q_oay(FALSE,FALSE,g_t1,'U6','ATM')                 #FUN-AA0046
                      RETURNING g_tsc.tsc01
                 DISPLAY BY NAME g_tsc.tsc01
                 NEXT FIELD tsc01
               WHEN INFIELD(tsc17)    #理由碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azf01"      #No.FUN-6B0065
                 LET g_qryparam.arg1 ="1"
                 LET g_qryparam.default1 = g_tsc.tsc17
                 CALL cl_create_qry() RETURNING g_tsc.tsc17
                 DISPLAY BY NAME g_tsc.tsc17
                 NEXT FIELD tsc17
               WHEN INFIELD(tsc15)    #部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_tsc.tsc15
                 CALL cl_create_qry() RETURNING g_tsc.tsc15
                 DISPLAY BY NAME g_tsc.tsc15
                 NEXT FIELD tsc15
               WHEN INFIELD(tsc16)    #
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_tsc.tsc16
                 CALL cl_create_qry() RETURNING g_tsc.tsc16
                 DISPLAY BY NAME g_tsc.tsc16
                 NEXT FIELD tsc16
               WHEN INFIELD(tsc03)    #組合產品編號
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_ima01"
#                LET g_qryparam.default1 = g_tsc.tsc03
#                CALL cl_create_qry() RETURNING g_tsc.tsc03
                 CALL q_sel_ima(FALSE, "q_ima01","",g_tsc.tsc03,"","","","","",'' ) 
                        RETURNING   g_tsc.tsc03
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY BY NAME g_tsc.tsc03
                 NEXT FIELD tsc03
               WHEN INFIELD(tsc12)    #倉庫
               #FUN-AB0014  --modify
               # CALL cl_init_qry_var()
               # LET g_qryparam.form = "q_imd01"
               # LET g_qryparam.default1 = g_tsc.tsc12
               # CALL cl_create_qry() RETURNING g_tsc.tsc12
                 CALL q_imd_1(FALSE,TRUE,g_tsc.tsc12,"","","","imd11='Y'") RETURNING g_tsc.tsc12
                #FUN-AB0014  --end
                 DISPLAY BY NAME g_tsc.tsc12
                 NEXT FIELD tsc12
               WHEN INFIELD(tsc13)    #儲位
                #FUN-AB0014  --modify
                #CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_ime"
                #LET g_qryparam.arg1 = g_tsc.tsc12
                #LET g_qryparam.arg2 = 'SW'
                #LET g_qryparam.default1 = g_tsc.tsc13
                #CALL cl_create_qry() RETURNING g_tsc.tsc13
                 CALL q_ime_1(FALSE,TRUE,g_tsc.tsc13,g_tsc.tsc12,"",g_plant,"","","") RETURNING g_tsc.tsc13
                #FUN-AB0014  --end
                 DISPLAY BY NAME g_tsc.tsc13
                 NEXT FIELD tsc13
               WHEN INFIELD(tsc14)    #
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_img"
                 LET g_qryparam.arg1 = g_tsc.tsc14
                 CALL cl_create_qry() RETURNING g_tsc.tsc14
                 DISPLAY BY NAME g_tsc.tsc14
                 NEXT FIELD tsc14
               WHEN INFIELD(tsc04)    #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.arg1 = g_tsc.tsc04
                 CALL cl_create_qry() RETURNING g_tsc.tsc04
                 DISPLAY BY NAME g_tsc.tsc04
                 NEXT FIELD tsc04
               WHEN INFIELD(tsc09)    #單位二
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.arg1 = g_tsc.tsc09
                 CALL cl_create_qry() RETURNING g_tsc.tsc09
                 DISPLAY BY NAME g_tsc.tsc09
                 NEXT FIELD tsc09
               WHEN INFIELD(tsc06)    #單位一
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.arg1 = g_tsc.tsc06
                 CALL cl_create_qry() RETURNING g_tsc.tsc06
                 DISPLAY BY NAME g_tsc.tsc06
                 NEXT FIELD tsc06
               WHEN INFIELD(tscconu)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.default1 = g_tsc.tscconu
                    CALL cl_create_qry() RETURNING g_tsc.tscconu
                    DISPLAY BY NAME g_tsc.tscconu
                    CALL t260_tscconu('a')
                    NEXT FIELD tscconu
              OTHERWISE EXIT CASE
            END CASE

      #CHI-A70027 add --start--
      ON ACTION modi_lot_header     #單頭批/序號維護
         IF cl_chk_act_auth() THEN     
            CALL t260_modi_lot_header()
         END IF
      #CHI-A70027 add --end--
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
    END INPUT
END FUNCTION
 
FUNCTION t260_tsc17(p_cmd)  #理由碼
    DEFINE l_azf03   LIKE azf_file.azf03,
           l_azfacti LIKE azf_file.azfacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
    LET g_errno = ' '
    SELECT azf03,azfacti INTO l_azf03,l_azfacti
      FROM azf_file WHERE azf01 = g_tsc.tsc17
                      AND azf09 = '1'
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3088'
                                   LET l_azf03 = NULL
         WHEN l_azfacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_azf03 TO  FORMONLY.azf03        #No.FUN-6B0065
    END IF
END FUNCTION
 
FUNCTION t260_tsc15(p_cmd)  #部門
    DEFINE l_gem02   LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
    LET g_errno = ' '
    SELECT gem02,gemacti INTO l_gem02,l_gemacti
      FROM gem_file WHERE gem01 = g_tsc.tsc15
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-039'
                                   LET l_gem02 = NULL
         WHEN l_gemacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gem02 TO  FORMONLY.gem02
    END IF
END FUNCTION
 
FUNCTION t260_tsc16(p_cmd)  #人員
    DEFINE l_gen02   LIKE gen_file.gen02,
           l_genacti LIKE gen_file.genacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
    LET g_errno = ' '
    SELECT gen02,genacti INTO l_gen02,l_genacti
      FROM gen_file WHERE gen01 = g_tsc.tsc16
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aoo-017'
                                   LET l_gen02 = NULL
         WHEN l_genacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gen02 TO  FORMONLY.gen02
    END IF
END FUNCTION
 
FUNCTION t260_tsc03(p_cmd)  #
    DEFINE l_ima02a    LIKE ima_file.ima02,
           l_ima021a   LIKE ima_file.ima021,
           l_ima1002a  LIKE ima_file.ima1002,
           l_ima135a   LIKE ima_file.ima135,
           l_ima1010   LIKE ima_file.ima1010,
           l_imaacti   LIKE ima_file.imaacti,
           p_cmd       LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima1002,ima135,ima1010,imaacti
      INTO l_ima02a,l_ima021a,l_ima1002a,l_ima135a,l_ima1010,l_imaacti
      FROM ima_file WHERE ima01 = g_tsc.tsc03
                      AND (ima130 IS NULL OR ima130<>'2')
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET l_ima02a = NULL
                                   LET l_ima021a = NULL
                                   LET l_ima1002a = NULL
                                   LET l_ima135a = NULL
         WHEN l_ima1010<>'1'       LET g_errno = 'atm-017'  #No.FUN-690025
         WHEN l_imaacti='N'        LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'   LET g_errno = '9038'  #No.FUN-690022 add
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_ima02a   TO  FORMONLY.ima02a
       DISPLAY l_ima021a  TO  FORMONLY.ima021a
       DISPLAY l_ima1002a TO  FORMONLY.ima1002a
       DISPLAY l_ima135a  TO  FORMONLY.ima135a
    END IF
END FUNCTION
 
FUNCTION t260_tsd03(p_cmd)  #
    DEFINE l_ima02    LIKE ima_file.ima02,
           l_ima021   LIKE ima_file.ima021,
           l_ima1002  LIKE ima_file.ima1002,
           l_ima135   LIKE ima_file.ima135,
           l_ima1010   LIKE ima_file.ima1010,
           l_imaacti   LIKE ima_file.imaacti,
           p_cmd       LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
           p_ac        LIKE type_file.num5           #No.FUN-680120 SMALLINT
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima1002,ima135,ima1010,imaacti
      INTO l_ima02,l_ima021,l_ima1002,l_ima135,l_ima1010,l_imaacti
      FROM ima_file WHERE ima01 = g_tsd[l_ac].tsd03
                      AND (ima130 IS NULL OR ima130<>'2')
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET l_ima02 = NULL
                                   LET l_ima021 = NULL
                                   LET l_ima1002 = NULL
                                   LET l_ima135 = NULL
         WHEN l_ima1010<>'1'       LET g_errno = 'atm-017'   #No.FUN-690025
         WHEN l_imaacti='N'        LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'   LET g_errno = '9038'  #No.FUN-690022 add
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    LET g_tsd[l_ac].ima02 = l_ima02
    LET g_tsd[l_ac].ima021= l_ima021
    LET g_tsd[l_ac].ima1002= l_ima1002
    LET g_tsd[l_ac].ima135 = l_ima135
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY g_tsd[l_ac].ima02 TO ima02
       DISPLAY g_tsd[l_ac].ima021 TO ima021
       DISPLAY g_tsd[l_ac].ima1002 TO ima1002
       DISPLAY g_tsd[l_ac].ima135 TO ima135
    END IF
END FUNCTION
 
FUNCTION t260_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("tsc01",TRUE)
    END IF
 
    CALL cl_set_comp_entry("tsc09,tsc11",TRUE)     #0215
    call cl_set_comp_entry("tscud02",true) #darcy:2024/06/19 add
 
END FUNCTION
 
FUNCTION t260_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("tsc01",FALSE)
    END IF
 
    IF g_ima906 = '1' THEN
       CALL cl_set_comp_entry("tsc09,tsc10,tsc11",FALSE)
    END IF
    IF g_ima906 = '2' THEN
       CALL cl_set_comp_entry("tsc06,tsc09",FALSE)
    END IF
    #參考單位，每個料件只有一個，所以不開放讓用戶輸入
    IF g_ima906 = '3' THEN
       CALL cl_set_comp_entry("tsc09",FALSE)
    END IF
    #darcy:2024/07/04 add s---
    # 大部分内容都不允许修改  
    call cl_set_comp_entry(
      "tsc03,tsc12,tsc13,tsc14,tsc04,tscud02",
      false
    )
    #darcy:2024/07/04 add e---
END FUNCTION

#CHI-CB0064---add---START
FUNCTION t260_set_no_entry_tsc()
   DEFINE l_ima159    LIKE ima_file.ima159
      IF NOT cl_null(g_tsc.tsc03) THEN
         SELECT ima159 INTO l_ima159 FROM ima_file
          WHERE ima01  = g_tsc.tsc03
         IF l_ima159 = '2' THEN
            CALL cl_set_comp_entry("tsc14",FALSE)
         ELSE
            CALL cl_set_comp_entry("tsc14",TRUE)
         END IF
      END IF
END FUNCTION

FUNCTION t260_set_entry_tsc()
   CALL cl_set_comp_entry("tsc14",TRUE)
END FUNCTION
#CHI-CB0064---add-----END
 
FUNCTION t260_sel_ima()
    SELECT ima55,ima906,ima907
      INTO g_ima55,g_ima906,g_ima907
      FROM ima_file
     WHERE ima01=g_tsc.tsc03
 
END FUNCTION
 
FUNCTION t260_sel_ima_b()
    SELECT ima63,ima906,ima907
      INTO g_ima63,g_ima906,g_ima907
      FROM ima_file
     WHERE ima01=g_tsd[l_ac].tsd03
END FUNCTION
 
#Query 查詢
FUNCTION t260_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_tsd.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t260_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_tsc.* TO NULL
        RETURN
    END IF
    OPEN t260_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_tsc.* TO NULL
    ELSE
        OPEN t260_count
        FETCH t260_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t260_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t260_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680120 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680120 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t260_cs INTO g_tsc.tsc01
        WHEN 'P' FETCH PREVIOUS t260_cs INTO g_tsc.tsc01
        WHEN 'F' FETCH FIRST    t260_cs INTO g_tsc.tsc01
        WHEN 'L' FETCH LAST     t260_cs INTO g_tsc.tsc01
        WHEN '/'
 
      IF (NOT mi_no_ask) THEN
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
      FETCH ABSOLUTE g_jump t260_cs INTO g_tsc.tsc01
      LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tsc.tsc01,SQLCA.sqlcode,0)
        INITIALIZE g_tsc.* TO NULL   #NO.FUN-6B0079  add
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
    SELECT * INTO g_tsc.* FROM tsc_file WHERE tsc01 = g_tsc.tsc01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","tsc_file",g_tsc.tsc01,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
        INITIALIZE g_tsc.* TO NULL
        RETURN
    END IF
 
    CALL t260_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t260_show()
   DEFINE l_gen02 LIKE gen_file.gen02 #CHI-D20015 add
 
    LET g_tsc_t.* = g_tsc.*                #保存單頭舊值
    LET g_tsc_o.* = g_tsc.*                #保存單頭舊值
    DISPLAY BY NAME                               # 顯示單頭值
        g_tsc.tsc01,g_tsc.tsc02,
        g_tsc.tsc21,                #MOD-AA0167
        g_tsc.tsc17,g_tsc.tsc15,g_tsc.tsc16,
        g_tsc.tscconf,g_tsc.tscpost,g_tsc.tsccond,g_tsc.tscconu,g_tsc.tsccont,g_tsc.tscplant,  #FUN-870100 ADD
        g_tsc.tsc03,g_tsc.tsc12,g_tsc.tsc13,
        g_tsc.tsc14,g_tsc.tsc04,g_tsc.tsc05,g_tsc.tsc09,g_tsc.tsc10,g_tsc.tsc11,
        g_tsc.tsc06,g_tsc.tsc07,g_tsc.tsc08,g_tsc.tsc18,g_tsc.tscuser,
        g_tsc.tsc19,g_tsc.tsc20,       #No.FUN-930140#FUN-A50071 add tsc20
        g_tsc.tscoriu,g_tsc.tscorig,                            #TQC-A30048 ADD
        g_tsc.tscgrup,g_tsc.tscmodu,g_tsc.tscdate,g_tsc.tscacti,
        g_tsc.tscud01,g_tsc.tscud02,g_tsc.tscud03,g_tsc.tscud04,
        g_tsc.tscud05,g_tsc.tscud06,g_tsc.tscud07,g_tsc.tscud08,
        g_tsc.tscud09,g_tsc.tscud10,g_tsc.tscud11,g_tsc.tscud12,
        g_tsc.tscud13,g_tsc.tscud14,g_tsc.tscud15
    CALL t260_tsc17('d')
    CALL t260_tsc15('d')
    CALL t260_tsc16('d')
    CALL t260_tscplant('d')   #FUN-870100 
    CALL t260_tsc03('d')
    IF g_tsc.tscconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_tsc.tscconf='Y' THEN LET g_approve='Y' ELSE LET g_approve='N' END IF   #No.TQC-640116
    CALL cl_set_field_pic(g_tsc.tscconf,g_approve,g_tsc.tscpost,"",g_chr,g_tsc.tscacti)     #No.TQC-640116
   #CHI-D20015--add-s-tr
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_tsc.tscconu
    DISPLAY l_gen02 TO tscconu_desc
   #CHI-D20015--add--end
 
    CALL t260_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t260_void(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废

   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_tsc.tsc01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_tsc.tscconf='X' THEN RETURN END IF
    ELSE
       IF g_tsc.tscconf<>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
   IF g_tsc.tscpost='Y' THEN
      CALL cl_err(g_tsc.tscpost,'asf-922',0)
      RETURN
   ELSE
      IF g_tsc.tscconf='Y' THEN
         CALL cl_err(g_tsc.tscconf,'9023',0)
         RETURN
      END IF
   END IF
 
   BEGIN WORK
 
   OPEN t260_cl USING g_tsc.tsc01
   IF STATUS THEN
      CALL cl_err("OPEN t260_cl:", STATUS, 1)
      CLOSE t260_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t260_cl INTO g_tsc.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t260_show()
 
   IF cl_void(0,0,g_tsc.tscconf) THEN                   #確認一下
      LET g_chr=g_tsc.tscacti
      IF g_tsc.tscconf='N' THEN
         LET g_tsc.tscconf='X'
      ELSE
         IF g_tsc.tscconf='X' THEN
            LET g_tsc.tscconf='N'
         END IF
      END IF
 
      UPDATE tsc_file SET tscconf=g_tsc.tscconf,tsccond='',tscconu='',tsccont=''  #FUN-870100
       WHERE tsc01=g_tsc.tsc01
 
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","tsc_file",g_tsc.tsc01,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
      END IF
   END IF
 
   CLOSE t260_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT tscacti,tscconf,tsccond,tscconu,tsccont,tscmodu,tscdate     #FUN-870100 ADD
     INTO g_tsc.tscacti,g_tsc.tscconf,g_tsc.tsccond,g_tsc.tscconu,g_tsc.tsccont,g_tsc.tscmodu,g_tsc.tscdate FROM tsc_file #FUN-870100
    WHERE tsc01=g_tsc.tsc01
   DISPLAY BY NAME g_tsc.tscacti,g_tsc.tscconf,g_tsc.tsccond,g_tsc.tscconu,g_tsc.tsccont,g_tsc.tscmodu,g_tsc.tscdate #FUN-870100
 
   IF g_tsc.tscconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_tsc.tscconf='Y' THEN LET g_approve='Y' ELSE LET g_approve='N' END IF   #No.TQC-640116
   CALL cl_set_field_pic(g_tsc.tscconf,g_approve,g_tsc.tscpost,"",g_chr,g_tsc.tscacti)     #No.TQC-640116
END FUNCTION
 
#撤銷整筆 (所有合乎單頭的資料)
FUNCTION t260_r()
 DEFINE l_i LIKE type_file.num5          #No.FUN-680120 SMALLINT
 DEFINE i   LIKE type_file.num5          #CHI-A70027 add

    IF s_shut(0) THEN RETURN END IF
    IF g_tsc.tsc01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF g_tsc.tscacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_tsc.tsc01,'mfg1000',0)
        RETURN
    END IF
    IF g_tsc.tscpost='Y' THEN
        CALL cl_err('','afa-101',0)
        RETURN
    END IF
    IF g_tsc.tscconf='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    IF g_tsc.tscconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
 
    BEGIN WORK
 
    OPEN t260_cl USING g_tsc.tsc01
    IF STATUS THEN
       CALL cl_err("OPEN t260_cl:", STATUS, 1)
       CLOSE t260_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t260_cl INTO g_tsc.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tsc.tsc01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t260_cl   #0221
        ROLLBACK WORK
        RETURN
    END IF
    CALL t260_show()
    IF cl_delh(0,0) THEN                   #審核一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "tsc01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_tsc.tsc01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        #CHI-A70027 add --start--
        LET g_ima918 = ''
        LET g_ima921 = ''
        SELECT ima918,ima921 INTO g_ima918,g_ima921 
          FROM ima_file
         WHERE ima01 = g_tsc.tsc03
           AND imaacti = "Y"
                
        IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
          #IF NOT s_lotin_del(g_prog,g_tsc.tsc01,0,0,g_tsc.tsc03,'DEL') THEN   #TQC-B90236 mark
           IF NOT s_lot_del(g_prog,g_tsc.tsc01,'',0,g_tsc.tsc03,'DEL') THEN   #TQC-B90236 add
              CALL cl_err3("del","rvbs_file",g_tsc.tsc01,0,SQLCA.sqlcode,"","",1)
            END IF
            FOR i = 1 TO g_rec_b
              #IF NOT s_lotout_del(g_prog,g_tsc.tsc01,g_tsd[i].tsd02,0,g_tsd[i].tsd03,'DEL') THEN   #TQC-B90236 mark
               IF NOT s_lot_del(g_prog,g_tsc.tsc01,'',0,g_tsd[i].tsd03,'DEL') THEN   #TQC-B90236 add
                  CALL cl_err3("del","rvbs_file",g_tsc.tsc01,g_tsd[i].tsd02,SQLCA.sqlcode,"","",1)
                  CONTINUE FOR
               END IF
            END FOR
        END IF
        #CHI-A70027 add --end--

            DELETE FROM tsc_file WHERE tsc01 = g_tsc.tsc01
            DELETE FROM tsd_file WHERE tsd01 = g_tsc.tsc01
            UPDATE ruc_file SET ruc34 = NULL              #FUN-CC0057 add
             WHERE ruc04 = g_tsc.tsc03                    #FUN-CC0057 add
               AND ruc34 = g_tsc.tsc01                    #FUN-CC0057 add
            CLEAR FORM
            CALL g_tsd.clear()
 
         OPEN t260_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE t260_cs
            CLOSE t260_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH t260_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t260_cs
            CLOSE t260_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t260_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t260_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t260_fetch('/')
         END IF
    END IF
    CLOSE t260_cl
    COMMIT WORK
    CALL cl_flow_notify(g_tsc.tsc01,'D')
END FUNCTION
 
#單身
FUNCTION t260_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未撤銷的ARRAY CNT #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680120 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680120 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680120 SMALLINT
DEFINE
    l_ima35         LIKE ima_file.ima35,
    l_ima36         LIKE ima_file.ima36,
    l_ima63         LIKE ima_file.ima63,
    l_ima63_fac     LIKE ima_file.ima63_fac,
    l_ima906        LIKE ima_file.ima906,
    l_ima907        LIKE ima_file.ima907,
    l_code          LIKE type_file.num5,             #No.FUN-680120 SMALLINT
    sn1,sn2         LIKE type_file.num5,             #No.FUN-680120 SMALLINT
    l_c            LIKE type_file.num5             #CHI-C30106 
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_tsc.tsc01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tsc.* FROM tsc_file WHERE tsc01=g_tsc.tsc01
    IF g_tsc.tscacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_tsc.tsc01,'mfg1000',0)
        RETURN
    END IF
    IF g_tsc.tscconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
     IF g_tsc.tscconf='Y' THEN
       IF g_tsc.tscpost = 'Y' THEN
          CALL cl_err('','afa-101',0)
          RETURN
       ELSE
          CALL cl_err('','mfg3168',0)
          RETURN
       END IF
     END IF
    LET g_success='Y'
    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT tsd02,tsd03,'','','','',tsd12,tsd13,tsd14,tsd04,",
                       " tsd05,tsd09,tsd10,tsd11,tsd06,tsd07,tsd08,tsd15 ",
                       "   FROM tsd_file ",
                       "   WHERE tsd01=? AND tsd02=? ",
                       "    FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t260_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
 
        IF g_rec_b=0 THEN CALL g_tsd.clear() END IF
 
        INPUT ARRAY g_tsd WITHOUT DEFAULTS FROM s_tsd.*
 
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
               CALL cl_set_comp_entry("tsd02,tsd03,tsd04,tsd05,tsd06,tsd07,tsd08,tsd09,
                                         tsd10,tsd11,tsd12,tsd13,tsd14,tsd15",TRUE)
            #No.FUN-BB0086--add--begin--
            LET g_tsd04_t = NULL 
            LET g_tsd06_t = NULL 
            LET g_tsd09_t = NULL 
            #No.FUN-BB0086--add--end--
            CALL cl_set_act_visible("modi_lot_detail",g_sma.sma95="Y")  #FUN-C80065 add  
        BEFORE ROW
            LET p_cmd=""
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN t260_cl USING g_tsc.tsc01
            IF STATUS THEN
               CALL cl_err("OPEN t260_cl:", STATUS, 1)
               CLOSE t260_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t260_cl INTO g_tsc.*            # 鎖住將被更改或撤銷的資料
            IF SQLCA.sqlcode THEN
              CALL cl_err(g_tsc.tsc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t260_cl
              RETURN
            END IF
 
            # 修改狀態時才作備份舊值的動作
            IF g_rec_b >= l_ac THEN
                LET p_cmd="u"
                LET g_tsd_t.* = g_tsd[l_ac].*  #BACKUP
                LET g_tsd_o.* = g_tsd[l_ac].*  #BACKUP
                #No.FUN-BB0086--add--begin--
                LET g_tsd04_t = g_tsd[l_ac].tsd04
                LET g_tsd06_t = g_tsd[l_ac].tsd06
                LET g_tsd09_t = g_tsd[l_ac].tsd09
                #No.FUN-BB0086--add--end--
                OPEN t260_bcl USING g_tsc.tsc01,g_tsd_t.tsd02
                IF STATUS THEN
                   CALL cl_err("OPEN t260_bcl:", STATUS, 1)
                   CLOSE t260_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t260_bcl INTO g_tsd[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_tsd_t.tsd02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   SELECT ima02,ima021,ima1002,ima135
                     INTO g_tsd[l_ac].ima02,g_tsd[l_ac].ima021,
                          g_tsd[l_ac].ima1002,g_tsd[l_ac].ima135
                     FROM ima_file
                    WHERE ima01=g_tsd[l_ac].tsd03
                END IF
            END IF
 
        BEFORE INSERT
            LET p_cmd="a"
            LET l_n = ARR_COUNT()
            INITIALIZE g_tsd[l_ac].* TO NULL       #900423
            LET g_tsd[l_ac].tsd05 = 0              #body default
            LET g_tsd[l_ac].tsd08 = 0              #body default
            LET g_tsd[l_ac].tsd11 = 0              #body default
            LET g_tsd041 = 1
            LET g_tsd_t.* = g_tsd[l_ac].*          #新輸入資料
            LET g_tsd_o.* = g_tsd[l_ac].*          #新輸入資料
            CALL cl_show_fld_cont()
            NEXT FIELD tsd02
 
        BEFORE FIELD tsd02                        #default 序號
            IF g_tsd[l_ac].tsd02 IS NULL OR g_tsd[l_ac].tsd02 = 0 THEN
                SELECT max(tsd02)+1
                   INTO g_tsd[l_ac].tsd02
                   FROM tsd_file
                   WHERE tsd01 = g_tsc.tsc01
                IF g_tsd[l_ac].tsd02 IS NULL THEN
                    LET g_tsd[l_ac].tsd02 = 1
                END IF
            END IF
 
        AFTER FIELD tsd02                        #check 序號是否重複
            IF NOT g_tsd[l_ac].tsd02 IS NULL THEN
               IF g_tsd[l_ac].tsd02 != g_tsd_t.tsd02 OR
                  g_tsd_t.tsd02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM tsd_file
                       WHERE tsd01 = g_tsc.tsc01 AND
                             tsd02 = g_tsd[l_ac].tsd02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_tsd[l_ac].tsd02 = g_tsd_t.tsd02
                       NEXT FIELD tsd02
                   END IF
               END IF
            END IF
 
        BEFORE FIELD tsd03
            CALL cl_set_comp_required("tsd06,tsd08,tsd09,tsd11",FALSE)
 
        AFTER FIELD tsd03
            IF cl_null(g_tsd[l_ac].tsd03) THEN
                  CALL cl_err('','aap-099',0)
                  NEXT FIELD tsd03
#FUN-AA0059 ---------------------start----------------------------
            ELSE
               IF NOT s_chk_item_no(g_tsd[l_ac].tsd03,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_tsd[l_ac].tsd03= g_tsd_t.tsd03
                  NEXT FIELD tsd03
               END IF
#FUN-AA0059 ---------------------end-------------------------------
            END IF
 
            CALL t260_sel_ima_b()  #0215
 
            IF g_sma.sma115 ='Y' AND g_ima906 = '1' THEN
               CALL cl_set_comp_entry("tsd09,tsd11",FALSE)
            END IF
            IF g_sma.sma115 ='Y' AND g_ima906 = '3' THEN
               CALL cl_set_comp_entry("tsd11",TRUE)
               CALL cl_set_comp_entry("tsd09",FALSE)
            END IF
            IF g_sma.sma115 ='Y' AND g_ima906 = '2' THEN
               CALL cl_set_comp_entry("tsd09,tsd11,tsd06,tsd08",TRUE)
               CALL cl_set_comp_required("tsd09,tsd11,tsd06,tsd08",FALSE)
            END IF
            IF g_sma.sma115 = 'Y' THEN  #No.TQC-650031
               IF NOT cl_null(g_tsd[l_ac].tsd09) THEN
                  CALL cl_set_comp_required("tsd11",TRUE)
               END IF
               IF NOT cl_null(g_tsd[l_ac].tsd06) THEN
                  CALL cl_set_comp_required("tsd08",TRUE)
               END IF
            END IF  #No.TQC-650031
 
            IF NOT cl_null(g_tsd[l_ac].tsd03) THEN
              IF p_cmd = 'a' OR (p_cmd ='u' AND
                 g_tsd[l_ac].tsd03 != g_tsd_o.tsd03) THEN
                 SELECT count(*) INTO l_n FROM ima_file
                     WHERE ima01 = g_tsd[l_ac].tsd03
                 IF l_n = 0 THEN
                     CALL cl_err(g_tsd[l_ac].tsd03,'ams-003',0)
                     LET g_tsd[l_ac].tsd03 = g_tsd_t.tsd03
                     NEXT FIELD tsd03
                 ELSE
                     IF g_sma.sma115 = 'Y' THEN       #(使用多單位)
                         CALL s_chk_va_setting(g_tsd[l_ac].tsd03)    #(檢查多單位使用方式是否與參數設定一致)
                              RETURNING g_flag,g_ima906,g_ima907
                         IF g_flag=1 THEN
                            NEXT FIELD tsd03
                         END IF
                         IF g_ima906 = '3' THEN   #(使用參考單位)
                            LET g_tsd[l_ac].tsd09=g_ima907
                         END IF
                      END IF
                      CALL t260_tsd03('d')
                      IF NOT cl_null(g_errno) THEN
                         CALL cl_err(g_tsd[l_ac].tsd03,g_errno,0)
                         NEXT FIELD tsd03
                      END IF
                      CALL t260_du_default_b(p_cmd)
                      #No.FUN-BB0086--add--end--
                      LET g_tsd[l_ac].tsd08 = s_digqty(g_tsd[l_ac].tsd08,g_tsd[l_ac].tsd06)
                      LET g_tsd[l_ac].tsd11 = s_digqty(g_tsd[l_ac].tsd11,g_tsd[l_ac].tsd09)
                      DISPLAY BY NAME g_tsd[l_ac].tsd08,g_tsd[l_ac].tsd11
                      #No.FUN-BB0086--add--begin--
                      SELECT ima35,ima36,ima63,ima63_fac INTO l_ima35,l_ima36,l_ima63,l_ima63_fac
                        FROM ima_file
                       WHERE ima01=g_tsd[l_ac].tsd03
                      LET g_tsd[l_ac].tsd12 = l_ima35
                      LET g_tsd[l_ac].tsd13 = l_ima36
                      LET g_tsd[l_ac].tsd04 = l_ima63
                      DISPLAY g_tsd[l_ac].tsd12 TO tsd12
                      DISPLAY g_tsd[l_ac].tsd13 TO tsd13
                      DISPLAY g_tsd[l_ac].tsd04 TO tsd04   #單位預設值
                      DISPLAY g_tsd[l_ac].tsd06 TO tsd06   #單位一預設值
                      DISPLAY g_tsd[l_ac].tsd08 TO tsd08
                      DISPLAY g_tsd[l_ac].tsd09 TO tsd09
                      DISPLAY g_tsd[l_ac].tsd10 TO tsd10
                      DISPLAY g_tsd[l_ac].tsd11 TO tsd11
                 END IF
               END IF
            END IF
 
 
        AFTER FIELD tsd12
           IF cl_null(g_tsd[l_ac].tsd12) THEN
              NEXT FIELD tsd12
           END IF
           IF g_tsd[l_ac].tsd12 IS NULL THEN
              LET g_tsd[l_ac].tsd12 = ' '
           END IF
           IF NOT cl_null(g_tsd[l_ac].tsd12) THEN
             # #CHI-D20014 add str 倉庫、庫位控管 还原
             # #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
             # IF NOT s_chksmz(g_tsd[l_ac].tsd03,g_tsc.tsc01,g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13) THEN
             #    NEXT FIELD tsd12
             # END IF
             # #CHI-D20014 add end 还原
              CALL s_stkchk(g_tsd[l_ac].tsd12,'A') RETURNING l_code
              IF NOT l_code THEN
                 CALL cl_err('s_stkchk','mfg1100',0)
                 NEXT FIELD tsd12
              END IF
              CALL s_swyn(g_tsd[l_ac].tsd12) RETURNING sn1,sn2
                  IF sn1=1 AND g_tsd[l_ac].tsd12 != g_tsd_t.tsd12 THEN
                     LET g_tsd_t.tsd12=g_tsd[l_ac].tsd12
                     CALL cl_err(g_tsd[l_ac].tsd12,'mfg6080',0) NEXT FIELD tsd12
                  ELSE
                     IF sn2=2 AND g_tsd[l_ac].tsd12 != g_tsd_t.tsd12 THEN
                        CALL cl_err(g_tsd[l_ac].tsd12,'mfg6085',0)
                        LET g_tsd_t.tsd12=g_tsd[l_ac].tsd12
                        NEXT FIELD tsd12
                     END IF
                  END IF
                  LET sn1=0 LET sn2=0
           END IF
#FUN-AB0014  --modify
           IF NOT s_chk_ware(g_tsd[l_ac].tsd12) THEN
              NEXT FIELD tsd12
           END IF 
#FUN-AB0014  --end
 #TQC-D50124 --------Begin------
  ##FUN-D40103 -----Begin--------
  #      # IF NOT s_imechk(g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13) THEN
  #      #    NEXT FIELD tsd13
  #      # END IF 
  ##FUN-D40103 -----End----------
  #TQC-D50124 --------End--------
 
        AFTER FIELD tsd13
           IF cl_null(g_tsd[l_ac].tsd13) THEN  #全型空白
              LET g_tsd[l_ac].tsd13 = ' '
           END IF
           IF NOT cl_null(g_tsd[l_ac].tsd13) THEN
             # IF NOT cl_null(g_tsd[l_ac].tsd12) THEN #CHI-D20014 add 还原 
              #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
              IF NOT s_chksmz(g_tsd[l_ac].tsd03,g_tsc.tsc01,g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13) THEN
                 NEXT FIELD tsd13
              END IF
             # END IF #CHI-D20014 add 还原
              CALL s_lwyn(g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13)
                   RETURNING sn1,sn2    #可用否
              IF sn2 = 2 THEN
                 IF g_pmn38 = 'Y' THEN CALL cl_err('','mfg9132',0) END IF
              ELSE
                 IF g_pmn38 = 'N' THEN CALL cl_err('','mfg9131',0) END IF
              END IF
              LET sn1=0 LET sn2=0
           END IF

#TQC-D50124 ------Begin-------
  ##FUN-D40103 -----Begin--------
  #        IF NOT s_imechk(g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13) THEN
  #           NEXT FIELD tsd13
  #        END IF
  ##FUN-D40103 -----End----------
 #TQC-D50124 ------End---------
 
        AFTER FIELD tsd14
            IF cl_null(g_tsd[l_ac].tsd14) THEN
               LET g_tsd[l_ac].tsd14 = ' '
            END IF
            IF NOT cl_null(g_tsd[l_ac].tsd03) AND NOT cl_null(g_tsd[l_ac].tsd12) THEN
              SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
               WHERE img01=g_tsd[l_ac].tsd03 AND img02=g_tsd[l_ac].tsd12
                 AND img03=g_tsd[l_ac].tsd13 AND img04=g_tsd[l_ac].tsd14
              IF SQLCA.sqlcode=100 THEN
                 #FUN-C80107 modify begin----------------------------------121024
                 #CALL cl_err3("sel","img_file",g_tsd[l_ac].tsd03,"","mfg9051","","",1) #No.FUN-660104
                 #NEXT FIELD tsd03
                #FUN-D30024--modify--str--
                #INITIALIZE g_sma894 TO NULL
                #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_tsd[l_ac].tsd12) RETURNING g_sma894
                #IF g_sma894 = 'N' OR g_sma894 IS NULL THEN
                 INITIALIZE g_imd23 TO NULL
                 CALL s_inv_shrt_by_warehouse(g_tsd[l_ac].tsd12,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant
                 IF g_imd23 = 'N' THEN
                #FUN-D30024--modify--end--
                    CALL cl_err3("sel","img_file",g_tsd[l_ac].tsd03,"","mfg9051","","",1)
                    NEXT FIELD tsd03
                 ELSE
                    IF NOT cl_confirm('mfg1401') THEN
                       NEXT FIELD tsd03
                    END IF
                    CALL s_add_img(g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,
                                   g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14,
                                   g_tsc.tsc01,'0',g_tsc.tsc21)
                    IF g_errno='N' THEN
                       NEXT FIELD tsd03
                    END IF
                    SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
                     WHERE img01=g_tsd[l_ac].tsd03 AND img02=g_tsd[l_ac].tsd12
                       AND img03=g_tsd[l_ac].tsd13 AND img04=g_tsd[l_ac].tsd14
                 END IF
                 #FUN-C80107 modify end------------------------------------
              END IF
              IF cl_null(g_tsd[l_ac].tsd04) THEN
                 LET g_tsd[l_ac].tsd04=g_img09
              END IF
 
              SELECT COUNT(*) INTO g_cnt FROM img_file
               WHERE img01=g_tsd[l_ac].tsd03
                 AND img02=g_tsd[l_ac].tsd12
                 AND img03=g_tsd[l_ac].tsd13
                 AND img04=g_tsd[l_ac].tsd14
#                AND img18<g_tsc.tsc02             #MOD-AA0167
                 AND img18<g_tsc.tsc21             #MOD-AA0167
             IF g_cnt > 0 THEN
                CALL cl_err('','aim-400',0)
                NEXT FIELD tsd14
             END IF
             IF g_sma.sma115='Y' THEN
                CALL t260_du_default_b(p_cmd)
                #No.FUN-BB0086--add--end--
                LET g_tsd[l_ac].tsd08 = s_digqty(g_tsd[l_ac].tsd08,g_tsd[l_ac].tsd06)
                LET g_tsd[l_ac].tsd11 = s_digqty(g_tsd[l_ac].tsd11,g_tsd[l_ac].tsd09)
                DISPLAY BY NAME g_tsd[l_ac].tsd08,g_tsd[l_ac].tsd11
                #No.FUN-BB0086--add--begin--
             END IF
 
              SELECT *  INTO g_img1.*   #重新取得庫存明細資料
                FROM img_file
               WHERE img01=g_tsd[l_ac].tsd03
                 AND img02=g_tsd[l_ac].tsd12
                 AND img03=g_tsd[l_ac].tsd13
                 AND img04=g_tsd[l_ac].tsd14
           END IF
 
        AFTER FIELD tsd04
            IF NOT cl_null(g_tsd[l_ac].tsd04) THEN
                 SELECT count(*) INTO l_n
                   FROM gfe_file
                  WHERE gfe01 = g_tsd[l_ac].tsd04
                    AND gfeacti = 'Y'
                 IF l_n = 0 THEN
                    CALL cl_err(g_tsd[l_ac].tsd04,'mfg0019',0)  #無此單位編號
                    NEXT FIELD tsd04
                 END IF
                 #Check 單位與庫存明細單位換算關系并且返回換算率
                 CALL s_umfchk(g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd04,g_img1.img09)
                      RETURNING g_cnt,g_tsd041
                 IF g_cnt = 1 THEN
                    CALL cl_err('','mfg3075',0)
                    NEXT FIELD tsd04
                 END IF
                 #No.FUN-BB0086--add--begin--
                 IF NOT t260_tsd05_check(l_r) THEN 
                    LET g_tsd04_t = g_tsd[l_ac].tsd04
                    NEXT FIELD tsd05
                 END IF 
                 LET g_tsd04_t = g_tsd[l_ac].tsd04
                 #No.FUN-BB0086--add--end--
             END IF
 
        AFTER FIELD tsd05
           IF NOT t260_tsd05_check(l_r) THEN NEXT FIELD tsd05 END IF   #No.FUN-BB0086
            #No.FUN-BB0086--mark--begin--
            #IF NOT cl_null(g_tsd[l_ac].tsd05) THEN
            #   IF g_tsd[l_ac].tsd05 < 0 THEN
            #      CALL cl_err('','mfg9243',0)
            #      NEXT FIELD tsd05
            #   END IF
            #
            #   SELECT img10 INTO g_imgg10 FROM img_file
            #      WHERE img01=g_tsd[l_ac].tsd03
            #        AND img02=g_tsd[l_ac].tsd12
            #        AND img03=g_tsd[l_ac].tsd13
            #        AND img04=g_tsd[l_ac].tsd14
            #   IF g_tsd[l_ac].tsd05*g_tsd041 > g_imgg10 THEN
            #      CALL cl_err(g_tsd[l_ac].tsd05,'mfg1303',1)
            #      NEXT FIELD tsd05
            #   END IF
            #END IF
            # #CHI-A70027 add --start--
            # LET g_ima918 = ''
            # LET g_ima921 = ''
            # SELECT ima918,ima921 INTO g_ima918,g_ima921 
            #   FROM ima_file
            #  WHERE ima01 = g_tsd[l_ac].tsd03
            #    AND imaacti = "Y"
            #
            # IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
            #    CALL t260_ima25(g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14,g_tsd[l_ac].tsd04)                   
            #    CALL s_lotout(g_prog,g_tsc.tsc01,g_tsd[l_ac].tsd02,0,
            #                  g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,
            #                  g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14,
            #                  g_tsd[l_ac].tsd04,g_ima25,g_ima25_fac,
            #                  g_tsd[l_ac].tsd05,'','MOD')
            #         RETURNING l_r,g_qty
            #    IF l_r = "Y" THEN
            #       LET g_tsd[l_ac].tsd05 = g_qty
            #       DISPLAY BY NAME g_tsd[l_ac].tsd05
            #    END IF
            # END IF
            # #CHI-A70027 add --end--
            #No.FUN-BB0086--mark--end--
 
        BEFORE FIELD tsd09
            CALL t260_sel_ima_b()   #0215
            CALL cl_set_comp_required("tsd06,tsd08,tsd09,tsd11",FALSE)
 
        AFTER FIELD tsd09
            IF NOT cl_null(g_tsd[l_ac].tsd09) THEN
               SELECT count(*) INTO l_n
                 FROM gfe_file
                WHERE gfe01=g_tsd[l_ac].tsd09
                  AND gfeacti='Y'
               IF l_n = 0 THEN
                  CALL cl_err(g_tsd[l_ac].tsd09,'mfg0019',0)
                  NEXT FIELD tsd09
               END IF
               CALL cl_set_comp_required("tsd11",TRUE)
 
               #Check 單位二與生產單位的換算關系并返回換算率
               CALL s_du_umfchk(g_tsd[l_ac].tsd03,'','','',g_img09,g_tsd[l_ac].tsd09,g_ima906)
                    RETURNING g_errno,g_tsd[l_ac].tsd10
 
               CALL s_chk_imgg(g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14,g_tsd[l_ac].tsd09)  # Check 多單位第二單位庫存明細是否存在
                    RETURNING l_code
               IF l_code THEN
                    #FUN-C80107 modify begin------------------------------------121024
                    #CALL cl_err('','atm-263',0)
                    #NEXT FIELD tsd09
                   #FUN-D30024--modify--str--
                   #INITIALIZE g_sma894 TO NULL
                   #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_tsd[l_ac].tsd12) RETURNING g_sma894
                   #IF g_sma894 = 'N' OR g_sma894 IS NULL THEN
                    INITIALIZE g_imd23 TO NULL
                    CALL s_inv_shrt_by_warehouse(g_tsd[l_ac].tsd12,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant
                    IF g_imd23 = 'N' THEN
                   #FUN-D30024--modify--end--
                       CALL cl_err('','atm-263',0)
                       NEXT FIELD tsd09
                    ELSE
                       IF g_sma.sma892[3,3] = 'Y' THEN
                          IF NOT cl_confirm('aim-995') THEN
                             NEXT FIELD tsd09
                          END IF
                       END IF
                       CALL s_add_imgg(g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,
                                       g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14,
                                       g_tsd[l_ac].tsd09,g_tsd[l_ac].tsd10,
                                       g_tsc.tsc01,'',0) RETURNING g_flag
                       IF g_flag = 1 THEN
                          NEXT FIELD tsd09
                       END IF
                    END IF
                    #FUN-C80107 modify end--------------------------------------
               END IF
               DISPLAY g_tsd[l_ac].tsd10 TO tsd10
               #No.FUN-BB0086--add--begin--
               IF NOT t260_tsd11_check() THEN 
                  LET g_tsd09_t = g_tsd[l_ac].tsd09
                  NEXT FIELD tsd11
               END IF 
               LET g_tsd09_t = g_tsd[l_ac].tsd09
             #No.FUN-BB0086--add--end--  
            END IF
 
        BEFORE FIELD tsd11
           IF cl_null(g_tsd[l_ac].tsd03) THEN NEXT FIELD tsd03 END IF
           IF g_tsd[l_ac].tsd12 IS NULL OR g_tsd[l_ac].tsd13 IS NULL OR
              g_tsd[l_ac].tsd14 IS NULL THEN
              NEXT FIELD tsd14
           END IF
           IF NOT cl_null(g_tsd[l_ac].tsd09) AND g_ima906 = '3' THEN
              CALL s_chk_imgg(g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,
                              g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14,
                              g_tsd[l_ac].tsd09) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN
                       NEXT FIELD tsd03
                    END IF
                 END IF
                 CALL s_add_imgg(g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,
                                 g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14,
                                 g_tsd[l_ac].tsd09,g_tsd[l_ac].tsd10,
                                 g_tsc.tsc01,'',0) RETURNING g_flag
                 IF g_flag = 1 THEN
                    NEXT FIELD tsd03
                 END IF
              END IF
           END IF
 
        AFTER FIELD tsd11
           IF NOT t260_tsd11_check() THEN NEXT FIELD tsd11 END IF   #No.FUN-BB0086
            #No.FUN-BB0086--mark--begin--
            #IF NOT cl_null(g_tsd[l_ac].tsd11) THEN
            #   IF g_tsd[l_ac].tsd11 < 0 THEN
            #      CALL cl_err('','mfg9243',0)
            #      NEXT FIELD tsd11
            #   END IF
            #   IF g_ima906='3' THEN
            #      LET g_tot=g_tsd[l_ac].tsd11*g_tsd[l_ac].tsd10    
            #      IF cl_null(g_tsd[l_ac].tsd08) OR g_tsd[l_ac].tsd08=0 THEN #CHI-960022
            #         LET g_tsd[l_ac].tsd08=g_tot
            #         DISPLAY BY NAME g_tsd[l_ac].tsd08
            #      END IF                                                    #CHI-960022
            #   END IF
            #   IF g_ima906 MATCHES '[23]' THEN
            #      SELECT imgg10 INTO g_imgg10_2 FROM imgg_file
            #       WHERE imgg01=g_tsd[l_ac].tsd03
            #         AND imgg02=g_tsd[l_ac].tsd12
            #         AND imgg03=g_tsd[l_ac].tsd13
            #         AND imgg04=g_tsd[l_ac].tsd14
            #         AND imgg09=g_tsd[l_ac].tsd09
            #   END IF
            #   IF g_tsd[l_ac].tsd11 > g_imgg10_2 THEN
            #         IF NOT cl_confirm('mfg3469') THEN
            #            NEXT FIELD tsd11
            #         END IF
            #   END IF
            #END IF
            #No.FUN-BB0086--mark--end--
 
        BEFORE FIELD tsd06
            CALL t260_sel_ima_b()   #0215
            CALL cl_set_comp_required("tsd06,tsd08,tsd09,tsd11",FALSE)
 
        AFTER FIELD tsd06
            IF cl_null(g_tsd[l_ac].tsd03) THEN NEXT FIELD tsd03 END IF
            IF NOT cl_null(g_tsd[l_ac].tsd06) THEN
                 CALL cl_set_comp_required("tsd08",TRUE)
                 SELECT count(*) INTO l_n
                   FROM gfe_file
                  WHERE gfe01 = g_tsd[l_ac].tsd06
                    AND gfeacti = 'Y'
                 IF l_n = 0 THEN
                    CALL cl_err(g_tsd[l_ac].tsd06,'mfg0019',0)  #無此單位編號
                    NEXT FIELD tsd06
                 END IF
                 CALL cl_set_comp_required("tsd06",TRUE)
                 #Check 單位與庫存明細單位換算關系并且返回換算率
                 CALL s_du_umfchk(g_tsd[l_ac].tsd03,'','','',g_tsd[l_ac].tsd04,g_tsd[l_ac].tsd06,g_ima906)
                      returning g_errno,g_tsd[l_ac].tsd07
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_tsd[l_ac].tsd06,g_errno,0)
                    NEXT FIELD tsd06
                 END IF
 
                 IF g_ima906='2' THEN
                   CALL s_chk_imgg(g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14,g_tsd[l_ac].tsd06)  # Check 多單位第二單位庫存明細是否存在
                        RETURNING l_code
                   IF l_code THEN
                     #FUN-C80107 modify begin------------------------------------121024
                     #CALL cl_err('','atm-263',0)
                     #NEXT FIELD tsd06
                     #FUN-D30024--modify--str--
                     #INITIALIZE g_sma894 TO NULL
                     #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_tsd[l_ac].tsd12) RETURNING g_sma894
                     #IF g_sma894 = 'N' OR g_sma894 IS NULL THEN
                      INITIALIZE g_imd23 TO NULL
                      CALL s_inv_shrt_by_warehouse(g_tsd[l_ac].tsd12,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant
                      IF g_imd23 = 'N' THEN
                     #FUN-D30024--modify--end--
                         CALL cl_err('','atm-263',0)
                         NEXT FIELD tsd06
                      ELSE
                         IF g_sma.sma892[3,3] = 'Y' THEN
                            IF NOT cl_confirm('aim-995') THEN
                               NEXT FIELD tsd06
                            END IF
                         END IF
                         CALL s_add_imgg(g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,
                                         g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14,
                                         g_tsd[l_ac].tsd06,g_tsd[l_ac].tsd08,
                                         g_tsc.tsc01,'',0) RETURNING g_flag
                         IF g_flag = 1 THEN
                            NEXT FIELD tsd06
                         END IF
                      END IF
                     #FUN-C80107 modify end--------------------------------------
                   END IF
                 END IF
                 DISPLAY g_tsd[l_ac].tsd07 TO tsd07
                 IF g_ima906='2' THEN
                    SELECT imgg10 INTO g_imgg10_1 FROM imgg_file
                     WHERE imgg01=g_tsd[l_ac].tsd03
                       AND imgg02=g_tsd[l_ac].tsd12
                       AND imgg03=g_tsd[l_ac].tsd13
                       AND imgg04=g_tsd[l_ac].tsd14
                       AND imgg09=g_tsd[l_ac].tsd06
                 ELSE
                    SELECT img10 INTO g_imgg10_1 FROM img_file
                     WHERE img01=g_tsd[l_ac].tsd03
                       AND img02=g_tsd[l_ac].tsd12
                       AND img03=g_tsd[l_ac].tsd13
                       AND img04=g_tsd[l_ac].tsd14
                 END IF
                 #No.FUN-BB0086--add--begin--
                 IF NOT t260_tsd08_check() THEN 
                    LET g_tsd06_t = g_tsd[l_ac].tsd06
                    NEXT FIELD tsd08
                 END IF 
                 LET g_tsd06_t = g_tsd[l_ac].tsd06
                 #No.FUN-BB0086--add--end--
            END IF
 
        AFTER FIELD tsd08
           IF NOT t260_tsd08_check() THEN NEXT FIELD tsd08 END IF   #No.FUN-BB0086
            #No.FUN-BB0086--mark--begin--
            #IF NOT cl_null(g_tsd[l_ac].tsd08) THEN
            #   IF g_tsd[l_ac].tsd08 < 0 THEN
            #      CALL cl_err('','mfg9243',0)
            #      NEXT FIELD tsd08
            #   END IF
            #   IF NOT cl_null(g_tsd[l_ac].tsd06) THEN
            #      IF g_ima906 = '2' THEN   #MATCHES '[23]' THEN
            #         IF g_tsd[l_ac].tsd08 > g_imgg10_1 THEN
            #               IF NOT cl_confirm('mfg3469') THEN
            #                  NEXT FIELD tsd08
            #               END IF
            #          END IF
            #      ELSE
            #         IF g_tsd[l_ac].tsd08*g_tsd[l_ac].tsd07 > g_imgg10_1 THEN
            #               IF NOT cl_confirm('mfg3469') THEN
            #                  NEXT FIELD tsd08
            #               END IF
            #         END IF
            #      END IF
            #   END IF
            #   CALL t260_du_data_to_correct_b()
            #   CALL t260_set_origin_field_b()
            #END IF
            #No.FUN-BB0086--mark--end--
 
        AFTER FIELD tsdud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsdud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsdud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsdud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsdud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsdud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsdud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsdud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsdud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsdud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsdud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsdud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsdud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsdud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsdud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT    #0220
            END IF
            CALL t260_du_data_to_correct_b()
            CALL t260_set_origin_field_b()
            IF cl_null(g_tsd[l_ac].tsd13) THEN LET g_tsd[l_ac].tsd13 = ' ' END IF #MOD-D30180 add
            IF cl_null(g_tsd[l_ac].tsd14) THEN LET g_tsd[l_ac].tsd14 = ' ' END IF #MOD-D30180 add
            INSERT INTO tsd_file(tsd01,tsd02,tsd03,tsd04,tsd041,      #0220
                                 tsd05,tsd06,tsd07,tsd08,
                                 tsd09,tsd10,tsd11,tsd12,
                                 tsd13,tsd14,tsd15,tsdplant,     #FUN-870100
                                 tsdud01,tsdud02,tsdud03,
                                 tsdud04,tsdud05,tsdud06,
                                 tsdud07,tsdud08,tsdud09,
                                 tsdud10,tsdud11,tsdud12,
                                 tsdud13,tsdud14,tsdud15,
                                 tsdlegal #FUN-980009
                                )
            VALUES(g_tsc.tsc01,g_tsd[l_ac].tsd02,
                    g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd04,g_tsd041,
                   g_tsd[l_ac].tsd05,g_tsd[l_ac].tsd06,
                   g_tsd[l_ac].tsd07,g_tsd[l_ac].tsd08,
                   g_tsd[l_ac].tsd09,g_tsd[l_ac].tsd10,
                   g_tsd[l_ac].tsd11,g_tsd[l_ac].tsd12,
                   g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14,
                   g_tsd[l_ac].tsd15,g_tsc.tscplant,    #FUN-870100 ADD
                   g_tsd[l_ac].tsdud01,
                   g_tsd[l_ac].tsdud02,
                   g_tsd[l_ac].tsdud03,
                   g_tsd[l_ac].tsdud04,
                   g_tsd[l_ac].tsdud05,
                   g_tsd[l_ac].tsdud06,
                   g_tsd[l_ac].tsdud07,
                   g_tsd[l_ac].tsdud08,
                   g_tsd[l_ac].tsdud09,
                   g_tsd[l_ac].tsdud10,
                   g_tsd[l_ac].tsdud11,
                   g_tsd[l_ac].tsdud12,
                   g_tsd[l_ac].tsdud13,
                   g_tsd[l_ac].tsdud14,
                   g_tsd[l_ac].tsdud15,
                   g_legal              #FUN-980009
                  )
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","tsd_file",g_tsd[l_ac].tsd02,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
                # 新增至資料庫發生錯誤時, CANCEL INSERT,
                # 不需要讓舊值回復到原變數
                CANCEL INSERT
                #CHI-A70027 add --start--
                LET g_ima918 = ''
                LET g_ima921 = ''
                SELECT ima918,ima921 INTO g_ima918,g_ima921 
                  FROM ima_file
                 WHERE ima01 = g_tsd[l_ac].tsd03
                   AND imaacti = "Y"
               
                IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  #IF NOT s_lotout_del(g_prog,g_tsc.tsc01,g_tsd[l_ac].tsd02,0,g_tsd[l_ac].tsd03,'DEL') THEN  #TQC-B90236 mark
                   IF NOT s_lot_del(g_prog,g_tsc.tsc01,g_tsd[l_ac].tsd02,0,g_tsd[l_ac].tsd03,'DEL') THEN  #TQC-B90236 add
                      CALL cl_err3("del","rvbs_file",g_tsc.tsc01,g_tsd[l_ac].tsd02,SQLCA.sqlcode,"","",1)
                   END IF
                END IF
                #CHI-A70027 add --end--
            ELSE
                IF g_success='Y' THEN
                   COMMIT WORK
                   MESSAGE 'INSERT O.K'
                ELSE
                   CALL cl_rbmsg(1)
                   ROLLBACK WORK
                   MESSAGE 'INSERT FAIL'
                END IF
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE DELETE                            #是否撤銷單身
            IF g_tsd_t.tsd02 > 0 AND
               g_tsd_t.tsd02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                #CHI-A70027 add --start--
                LET g_ima918 = ''
                LET g_ima921 = ''
                SELECT ima918,ima921 INTO g_ima918,g_ima921 
                  FROM ima_file
                 WHERE ima01 = g_tsd[l_ac].tsd03
                   AND imaacti = "Y"
               
                IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  #IF NOT s_lotout_del(g_prog,g_tsc.tsc01,g_tsd[l_ac].tsd02,0,g_tsd[l_ac].tsd03,'DEL') THEN   #TQC-B90236 mark
                   IF NOT s_lot_del(g_prog,g_tsc.tsc01,g_tsd[l_ac].tsd02,0,g_tsd[l_ac].tsd03,'DEL') THEN   #TQC-B90236 add
                      CALL cl_err3("del","rvbs_file",g_tsc.tsc01,g_tsd[l_ac].tsd02,SQLCA.sqlcode,"","",1)
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF
                END IF
                #CHI-A70027 add --end--
                DELETE FROM tsd_file
                    WHERE tsd01 = g_tsc.tsc01 AND
                          tsd02 = g_tsd_t.tsd02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","tsd_file",g_tsd_t.tsd02,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
        AFTER DELETE
            IF g_success='Y' THEN
               COMMIT WORK
            ELSE
               CALL cl_rbmsg(1) ROLLBACK WORK
            END IF
            LET l_n = ARR_COUNT()
            INITIALIZE g_tsd[l_n+1].* TO NULL
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tsd[l_ac].* = g_tsd_t.*
               CLOSE t260_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_tsd[l_ac].tsd02,-263,1)
               LET g_tsd[l_ac].* = g_tsd_t.*
            ELSE
               CALL t260_set_origin_field_b()
               UPDATE tsd_file SET tsd02= g_tsd[l_ac].tsd02,
                                   tsd03= g_tsd[l_ac].tsd03,
                                   tsd04= g_tsd[l_ac].tsd04,
                                   tsd041= g_tsd041,
                                   tsd05= g_tsd[l_ac].tsd05,
                                   tsd06= g_tsd[l_ac].tsd06,
                                   tsd07= g_tsd[l_ac].tsd07,
                                   tsd08= g_tsd[l_ac].tsd08,
                                   tsd09= g_tsd[l_ac].tsd09,
                                   tsd10= g_tsd[l_ac].tsd10,
                                   tsd11= g_tsd[l_ac].tsd11,
                                   tsd12= g_tsd[l_ac].tsd12,
                                   tsd13= g_tsd[l_ac].tsd13,
                                   tsd14= g_tsd[l_ac].tsd14,
                                   tsd15= g_tsd[l_ac].tsd15,
                                   tsdplant= g_tsc.tscplant, #FUN-870100
                                   tsdud01 = g_tsd[l_ac].tsdud01,
                                   tsdud02 = g_tsd[l_ac].tsdud02,
                                   tsdud03 = g_tsd[l_ac].tsdud03,
                                   tsdud04 = g_tsd[l_ac].tsdud04,
                                   tsdud05 = g_tsd[l_ac].tsdud05,
                                   tsdud06 = g_tsd[l_ac].tsdud06,
                                   tsdud07 = g_tsd[l_ac].tsdud07,
                                   tsdud08 = g_tsd[l_ac].tsdud08,
                                   tsdud09 = g_tsd[l_ac].tsdud09,
                                   tsdud10 = g_tsd[l_ac].tsdud10,
                                   tsdud11 = g_tsd[l_ac].tsdud11,
                                   tsdud12 = g_tsd[l_ac].tsdud12,
                                   tsdud13 = g_tsd[l_ac].tsdud13,
                                   tsdud14 = g_tsd[l_ac].tsdud14,
                                   tsdud15 = g_tsd[l_ac].tsdud15
               WHERE tsd01=g_tsc.tsc01 AND tsd02=g_tsd_t.tsd02
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","tsd_file",g_tsd[l_ac].tsd02,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
                   LET g_tsd[l_ac].* = g_tsd_t.*
               ELSE
                   IF g_success='Y' THEN
                      COMMIT WORK
                      MESSAGE 'UPDATE O.K'
                   ELSE
                      CALL cl_rbmsg(1)
                      ROLLBACK WORK
                      MESSAGE 'UPDATE FAIL'
                   END IF
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'a' AND l_ac <= g_tsd.getLength() THEN  #CHI-C30106 add
                 #CHI-A70027 add --start--
                 LET g_ima918 = ''
                 LET g_ima921 = ''
                 SELECT ima918,ima921 INTO g_ima918,g_ima921 
                   FROM ima_file
                  WHERE ima01 = g_tsd[l_ac].tsd03
                    AND imaacti = "Y"
              
                 IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                   #IF NOT s_lotout_del(g_prog,g_tsc.tsc01,g_tsd[l_ac].tsd02,0,g_tsd[l_ac].tsd03,'DEL') THEN   #TQC-B90236 mark
                    IF NOT s_lot_del(g_prog,g_tsc.tsc01,g_tsd[l_ac].tsd02,0,g_tsd[l_ac].tsd03,'DEL') THEN   #TQC-B90236 add
                       CALL cl_err3("del","rvbs_file",g_tsc.tsc01,g_tsd[l_ac].tsd02,SQLCA.sqlcode,"","",1)
                    END IF
                 END IF
                 #CHI-A70027 add --end--
               END IF #CHI-C30106 add               

               # 當為修改狀態且取消輸入時, 才作回復舊值的動作
               IF p_cmd = 'u' THEN
                  LET g_tsd[l_ac].* = g_tsd_t.*
               END IF
 
               CLOSE t260_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            # 除了修改狀態取消時, 其餘不需要回復舊值或備份舊值
 
            CLOSE t260_bcl
            COMMIT WORK
 
            CALL g_tsd.deleteElement(g_rec_b+1)

       #CHI-C30106---add---S---
        AFTER INPUT
        LET g_cnt = 0
        SELECT COUNT(*) INTO g_cnt FROM tsd_file WHERE tsd01=g_tsc.tsc01
          FOR l_c = 1 TO g_cnt
             SELECT ima918,ima921 INTO g_ima918,g_ima921
               FROM ima_file
              WHERE ima01 = g_tsd[l_c].tsd03
                AND imaacti = "Y"

             IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
             UPDATE rvbs_file SET rvbs021= g_tsd[l_c].tsd03
              WHERE rvbs00= g_prog
                AND rvbs01= g_tsc.tsc01
                AND rvbs02= g_tsd[l_c].tsd02
             END IF
          END FOR
       #CHI-C30106---add---E---
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(tsd02) AND l_ac > 1 THEN
                LET g_tsd[l_ac].* = g_tsd[l_ac-1].*
                LET g_tsd[l_ac].tsd02 = g_tsd[l_ac-1].tsd02 + 1
                DISPLAY BY NAME g_tsd[l_ac].*
                NEXT FIELD tsd02
            END IF
 
        ON ACTION CONTROLZ
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(tsd03)    #組合產品編號
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_ima01"
#                LET g_qryparam.default1 = g_tsd[l_ac].tsd03
#                CALL cl_create_qry() RETURNING g_tsd[l_ac].tsd03
                 CALL q_sel_ima(FALSE, "q_ima01","",g_tsd[l_ac].tsd03,"","","","","",'' ) 
                     RETURNING   g_tsd[l_ac].tsd03
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY BY NAME g_tsd[l_ac].tsd03
                 NEXT FIELD tsd03
               WHEN INFIELD(tsd12)    #倉庫
                  #FUN-C30300---begin
                  LET g_ima906 = NULL
                  SELECT ima906 INTO g_ima906 FROM ima_file
                   WHERE ima01 = g_tsd[l_ac].tsd03
                  #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                  IF s_industry("icd") THEN  #TQC-C60028
                     CALL q_idc(FALSE,FALSE,g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14)
                     RETURNING g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14
                  ELSE
                  #FUN-C30300---end
                     CALL q_img4(FALSE,FALSE,g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14,'S')
                          RETURNING g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14
                  END IF  #FUN-C30300
                     DISPLAY BY NAME g_tsd[l_ac].tsd12
                 NEXT FIELD tsd12
               WHEN INFIELD(tsd13)    #儲位
                  #FUN-C30300---begin
                  LET g_ima906 = NULL
                  SELECT ima906 INTO g_ima906 FROM ima_file
                   WHERE ima01 = g_tsd[l_ac].tsd03
                  #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                  IF s_industry("icd") THEN  #TQC-C60028
                     CALL q_idc(FALSE,FALSE,g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14)
                     RETURNING g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14
                  ELSE
                  #FUN-C30300---end
                     CALL q_img4(FALSE,FALSE,g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14,'S')
                          RETURNING g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14
                     DISPLAY BY NAME g_tsd[l_ac].tsd13
                  END IF  #FUN-C30300
                 NEXT FIELD tsd13
               WHEN INFIELD(tsd14)    #單位
                  #FUN-C30300---begin
                  LET g_ima906 = NULL
                  SELECT ima906 INTO g_ima906 FROM ima_file
                   WHERE ima01 = g_tsd[l_ac].tsd03
                  #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                  IF s_industry("icd") THEN  #TQC-C60028
                     CALL q_idc(FALSE,FALSE,g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14)
                     RETURNING g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14
                  ELSE
                  #FUN-C30300---end
                     CALL q_img4(FALSE,FALSE,g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14,'S')
                          RETURNING g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14
                  END IF  #FUN-C30300        
                 DISPLAY BY NAME g_tsd[l_ac].tsd14
                 NEXT FIELD tsd14
               WHEN INFIELD(tsd04)    #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.default1 = g_tsd[l_ac].tsd04
                 CALL cl_create_qry() RETURNING g_tsd[l_ac].tsd04
                 DISPLAY BY NAME g_tsd[l_ac].tsd04
                 NEXT FIELD tsd04
               WHEN INFIELD(tsd09)    #單位二
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.default1 = g_tsd[l_ac].tsd09
                 CALL cl_create_qry() RETURNING g_tsd[l_ac].tsd09
                 DISPLAY BY NAME g_tsd[l_ac].tsd09
                 NEXT FIELD tsd09
               WHEN INFIELD(tsd06)    #單位一
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.default1 = g_tsd[l_ac].tsd06
                 CALL cl_create_qry() RETURNING g_tsd[l_ac].tsd06
                 DISPLAY BY NAME g_tsd[l_ac].tsd06
                 NEXT FIELD tsd06
              OTHERWISE EXIT CASE
            END CASE

         #CHI-A70027 add --start--
        ON ACTION modi_lot_detail   #單身批/序號維護
           LET g_ima918 = ''
           LET g_ima921 = ''
           SELECT ima918,ima921 INTO g_ima918,g_ima921 
             FROM ima_file
            WHERE ima01 = g_tsd[l_ac].tsd03
              AND imaacti = "Y"
           
           IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
              CALL t260_ima25(g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14,g_tsd[l_ac].tsd04)                   
             #CALL s_lotout(g_prog,g_tsc.tsc01,g_tsd[l_ac].tsd02,0,    #TQC_B90236 mark
              CALL s_mod_lot(g_prog,g_tsc.tsc01,g_tsd[l_ac].tsd02,0,    #TQC_B90236 add
                               g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,
                               g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14,
                               g_tsd[l_ac].tsd04,g_ima25,g_ima25_fac,
                               g_tsd[l_ac].tsd05,'','MOD',-1)     #TQC_B90236 add '-1'
                   RETURNING l_r,g_qty
              IF l_r = "Y" THEN
                 LET g_tsd[l_ac].tsd05 = g_qty
                 DISPLAY BY NAME g_tsd[l_ac].tsd05
              END IF
           END IF
         #CHI-A70027 add --end--
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
 
        END INPUT
 
        CLOSE t260_bcl
        COMMIT WORK
        CALL t260_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t260_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_tsc.tsc01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM tsc_file ",
                  "  WHERE tsc01 LIKE '",l_slip,"%' ",
                  "    AND tsc01 > '",g_tsc.tsc01,"'"
      PREPARE t260_pb1 FROM l_sql 
      EXECUTE t260_pb1 INTO l_cnt
      
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
         CALL t260_void(1)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end 
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM tsc_file WHERE tsc01 = g_tsc.tsc01
         INITIALIZE g_tsc.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t260_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
 
    CONSTRUCT l_wc2 ON tsd02,tsd03,ima02,ima021,ima1002,#螢幕上取單身條件
                       ima135,tsd12,tsd13,tsd14,tsd04,tsd05,tsd09,tsd10,
                       tsd11,tsd06,tsd07,tsd08,tsd15
           FROM s_tsd[1].tsd02,s_tsd[1].tsd03,s_tsd[1].ima02,s_tsd[1].ima021,
                s_tsd[1].ima1002,s_tsd[1].ima135,s_tsd[1].tsd12,
                s_tsd[1].tsd13,s_tsd[1].tsd14,s_tsd[1].tsd04,s_tsd[1].tsd05,
                s_tsd[1].tsd09,s_tsd[1].tsd10,s_tsd[1].tsd11,s_tsd[1].tsd06,
                s_tsd[1].tsd07,s_tsd[1].tsd08,s_tsd[1].tsd15
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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
    CALL t260_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t260_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    LET g_sql =
        "SELECT tsd02,tsd03,'','','','',tsd12,tsd13,tsd14,tsd04,",
        "       tsd05,tsd09,tsd10,tsd11,tsd06,tsd07,tsd08,tsd15,",
        "       tsdud01,tsdud02,tsdud03,tsdud04,tsdud05,",
        "       tsdud06,tsdud07,tsdud08,tsdud09,tsdud10,",
        "       tsdud11,tsdud12,tsdud13,tsdud14,tsdud15",
        "  FROM tsd_file ",
        " WHERE tsd01 ='",g_tsc.tsc01,"'",  #單頭
         "  AND ", p_wc2 CLIPPED, #單身
        " ORDER BY tsd02"
 
    PREPARE t260_pb FROM g_sql
    DECLARE tsd_cs                       #SCROLL CURSOR
        CURSOR FOR t260_pb
    CALL g_tsd.clear()
    LET g_cnt = 1
    FOREACH tsd_cs INTO g_tsd[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT ima02,ima021,ima1002,ima135 INTO g_tsd[g_cnt].ima02,g_tsd[g_cnt].ima021,
                                                g_tsd[g_cnt].ima1002,g_tsd[g_cnt].ima135
          FROM ima_file WHERE ima01=g_tsd[g_cnt].tsd03
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_tsd.deleteElement(g_cnt)
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
    
    #FUN-B30170 add begin-------------------------
    LET g_sql = " SELECT rvbs02,rvbs021,ima02,ima021,rvbs022,rvbs04,rvbs03,rvbs05,rvbs06,rvbs07,rvbs08",
                "   FROM rvbs_file, OUTER ima_file ",
                "  WHERE rvbs00 = '",g_prog,"' AND rvbs01 = '",g_tsc.tsc01,"'",
                "    AND rvbs021 = ima_file.ima01 AND rvbs09 = 1"
    PREPARE sel_rvbs_pre FROM g_sql
    DECLARE rvbs_curs CURSOR FOR sel_rvbs_pre

    CALL g_rvbs.clear()

    LET g_cnt = 1
   #FOREACH rvbs_curs INTO g_rvbs[g_cnt].*     #CHI-C30106 mark
    FOREACH rvbs_curs INTO g_rvbs_1[g_cnt].*   #CHI-C30106 
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rvbs.deleteElement(g_cnt)
    LET g_rec_b1 = g_cnt-1

    LET g_sql = " SELECT rvbs02,rvbs021,ima02,ima021,rvbs022,rvbs04,rvbs03,rvbs05,rvbs06,rvbs07,rvbs08",
                "   FROM rvbs_file, OUTER ima_file ",
                "  WHERE rvbs00 = '",g_prog,"' AND rvbs01 = '",g_tsc.tsc01,"'",
                "    AND rvbs021 = ima_file.ima01 AND rvbs09 = -1"
    PREPARE sel_rvbs_pre1 FROM g_sql
    DECLARE rvbs_curs1 CURSOR FOR sel_rvbs_pre1

    CALL g_rvbs_1.clear()

    LET g_cnt = 1
   #FOREACH rvbs_curs1 INTO g_rvbs_1[g_cnt].*    #CHI-C30106 mark 
    FOREACH rvbs_curs1 INTO g_rvbs[g_cnt].*      #CHI-C30106
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rvbs_1.deleteElement(g_cnt)
    LET g_rec_b2 = g_cnt-1
    #FUN-B30170 add -end-------------------------- 
END FUNCTION
 
FUNCTION t260_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
#FUN-B30170 add begin--------------------------
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_tsd TO s_tsd.* ATTRIBUTE(COUNT=g_rec_b)

         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()  
         AFTER DISPLAY
            CONTINUE DIALOG   
      END DISPLAY
      
      DISPLAY ARRAY g_rvbs_1 TO s_rvbs_1.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            CALL cl_show_fld_cont()
         AFTER DISPLAY
            CONTINUE DIALOG   
      END DISPLAY

      DISPLAY ARRAY g_rvbs TO s_rvbs.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            CALL cl_show_fld_cont()
         AFTER DISPLAY
            CONTINUE DIALOG   
      END DISPLAY
      
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION CONTROLS
         CALL cl_set_head_visible("","AUTO")
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
         CALL t260_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###tsc in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######tsc in 040505
           END IF
           ACCEPT DIALOG
 
      ON ACTION previous
         CALL t260_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###tsc in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######tsc in 040505
           END IF
	ACCEPT DIALOG
 
      ON ACTION jump
         CALL t260_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DIALOG
 
      ON ACTION next
         CALL t260_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DIALOG
 
      ON ACTION last
         CALL t260_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DIALOG
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DIALOG
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DIALOG
 
      ON ACTION post
         LET g_action_choice="post"
         EXIT DIALOG
 
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DIALOG
 
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG
  
      #FUN-D20039 -------------sta
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG
      #FUN-D20039 -------------end

      #darcy:2024/07/05 add s---
      on action csfq034
         let g_action_choice = 'csfq034'
         exit dialog
      #darcy:2024/07/05 add e---
    
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DIALOG
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION related_document
        LET g_action_choice="related_document"
        EXIT DIALOG
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
      #CHI-A70027 add --start--
      ON ACTION qry_lot_header 
         LET g_action_choice="qry_lot_header"
         EXIT DIALOG

      ON ACTION qry_lot_detail
         LET g_action_choice="qry_lot_detail"
         EXIT DIALOG
      #CHI-A70027 add --end--

      #darcy:2023/12/21 add s---
      # 增加打开一般退料单按钮
      on action asfi528
         let g_action_choice = "asfi528"
         exit dialog
      #darcy:2023/12/21 add e---
 
      &include "qry_string.4gl"
   END DIALOG
#FUN-B30170 add -end---------------------------
#FUN-B30170 mark begin---------------------------
#   DISPLAY ARRAY g_tsd TO s_tsd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
# 
#      BEFORE DISPLAY
#         CALL cl_navigator_setting( g_curs_index, g_row_count )
# 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#         CALL cl_show_fld_cont()
# 
#      ##########################################################################
#      # Standard 4ad ACTION
#      ##########################################################################
#      ON ACTION CONTROLS
#         CALL cl_set_head_visible("","AUTO")
#      ON ACTION insert
#         LET g_action_choice="insert"
#         EXIT DISPLAY
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
#      ON ACTION delete
#         LET g_action_choice="delete"
#         EXIT DISPLAY
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
#      ON ACTION first
#         CALL t260_fetch('F')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###tsc in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######tsc in 040505
#           END IF
#           ACCEPT DISPLAY
# 
#      ON ACTION previous
#         CALL t260_fetch('P')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###tsc in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######tsc in 040505
#           END IF
#	ACCEPT DISPLAY
# 
#      ON ACTION jump
#         CALL t260_fetch('/')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)
#           END IF
#	ACCEPT DISPLAY
# 
#      ON ACTION next
#         CALL t260_fetch('N')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)
#           END IF
#	ACCEPT DISPLAY
# 
#      ON ACTION last
#         CALL t260_fetch('L')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)
#           END IF
#	ACCEPT DISPLAY
# 
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
# 
#      ON ACTION confirm
#         LET g_action_choice="confirm"
#         EXIT DISPLAY
#      ON ACTION unconfirm
#         LET g_action_choice="unconfirm"
#         EXIT DISPLAY
# 
#      ON ACTION post
#         LET g_action_choice="post"
#         EXIT DISPLAY
# 
#      ON ACTION undo_post
#         LET g_action_choice="undo_post"
#         EXIT DISPLAY
# 
#      ON ACTION void
#         LET g_action_choice="void"
#         EXIT DISPLAY
# 
#      ON ACTION reproduce
#         LET g_action_choice="reproduce"
#         EXIT DISPLAY
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY
#      ON ACTION help
#         LET g_action_choice="help"
#         EXIT DISPLAY
# 
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()
# 
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ##########################################################################
#      # Special 4ad ACTION
#      ##########################################################################
#      ON ACTION controlg
#         LET g_action_choice="controlg"
#         EXIT DISPLAY
# 
#      ON ACTION accept
#         LET g_action_choice="detail"
#         LET l_ac = ARR_CURR()
#         EXIT DISPLAY
# 
#      ON ACTION cancel
#         LET INT_FLAG=FALSE 		
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
# 
#      ON ACTION about
#         CALL cl_about()
# 
#      ON ACTION related_document
#        LET g_action_choice="related_document"
#        EXIT DISPLAY
# 
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
# 
#      #CHI-A70027 add --start--
#      ON ACTION qry_lot_header 
#         LET g_action_choice="qry_lot_header"
#         EXIT DISPLAY
#
#      ON ACTION qry_lot_detail
#         LET g_action_choice="qry_lot_detail"
#         EXIT DISPLAY
#      #CHI-A70027 add --end--
#
#      AFTER DISPLAY
#         CONTINUE DISPLAY
# 
#      &include "qry_string.4gl"
#   END DISPLAY
#FUN-B30170 mark -end----------------------------
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t260_copy()
DEFINE
    l_n             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
    li_result       LIKE type_file.num5,          #No.FUN-680120 SMALLINT
    l_t1            LIKE poy_file.poy05,          #No.FUN-680120 VARCHAR(05)
    l_newdate       LIKE tsc_file.tsc02,
    l_newno         LIKE tsc_file.tsc01,
    l_oldno         LIKE tsc_file.tsc01
DEFINE l_tsc21      LIKE tsc_file.tsc21   #MOD-AA0167
  
    IF s_shut(0) THEN RETURN END IF
    IF g_tsc.tsc01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL t260_set_entry('a')
    LET g_before_input_done = TRUE

    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
#    INPUT l_newno,l_newdate FROM tsc01,tsc02   #MOD-9B0120 remark   #MOD-AA0167
     INPUT l_newno,l_newdate,l_tsc21 FROM tsc01,tsc02,tsc21          #MOD-AA0167 
     
        BEFORE INPUT
          CALL cl_set_docno_format("tsc01")
          LET l_newdate = g_today  #MOD-9B0120 add
          DISPLAY l_newdate TO tsc02 #MOD-9B0120 add
          LET l_tsc21 = g_today           #MOD-AA0167
          DISPLAY l_tsc21 TO tsc21        #MOD-AA0167

        AFTER FIELD tsc01
            IF NOT cl_null(l_newno) THEN
      #         CALL s_check_no("aim",l_newno,"","F","tsc_file","tsc01","")                #FUN-AA0046     mark
                CALL s_check_no("atm",l_newno,"","U6","tsc_file","tsc01","")                #FUN-AA0046
                    RETURNING li_result,l_newno
               DISPLAY l_newno TO tsc01
               IF (NOT li_result) THEN
                  LET g_tsc.tsc01=g_tsc_o.tsc01
                  NEXT FIELD tsc01
               END IF
            END IF
   
      #MOD-9B0120---Begin
      AFTER FIELD tsc02
         IF cl_null(l_newdate) THEN NEXT FIELD tsc02 END IF
          BEGIN WORK
     #       CALL s_auto_assign_no("aim",l_newno,l_newdate,"F","tsc_file","tsc01","","","")  #MOD-9B0120 add   #FUN-AA0046 mark
             CALL s_auto_assign_no("atm",l_newno,l_newdate,"U6","tsc_file","tsc01","","","")            #FUN-AA0046
                 RETURNING li_result,l_newno
            IF (NOT li_result) THEN
                NEXT FIELD tsc01
            END IF
            DISPLAY l_newno TO tsc01 
      #MOD-9B0120---End 
      
#MOD-AA0167 --begin--
      AFTER FIELD tsc21
           IF NOT cl_null(l_tsc21) THEN 
               IF g_sma.sma53 IS NOT NULL AND l_tsc21 <= g_sma.sma53 THEN 
                  CALL cl_err('','mfg9999',0)
                  NEXT FIELD CURRENT 
               END IF    
               CALL s_yp(l_tsc21) RETURNING g_yy,g_mm
               IF g_yy*12+g_mm > g_sma.sma51*12+g_sma.sma52 THEN #不可大於現行年月
                  CALL cl_err('','mfg6091',0)
                  NEXT FIELD CURRENT 
               END IF            
            END IF          
#MOD-AA0167 --end--
      
      ON ACTION CONTROLP
            CASE
              WHEN INFIELD (tsc01)
                 LET l_t1=s_get_doc_no(l_newno)
       #         CALL q_smy(FALSE,FALSE,l_t1,'AIM','F')   #TQC-670008      #FUN-AA0046 mark
                 CALL q_oay(FALSE,FALSE,l_t1,'U6','ATM')                    #FUN-AA0046
                      RETURNING l_t1
                 LET l_newno = l_t1
                 DISPLAY l_newno TO tsc01
                 NEXT FIELD tsc01
            END CASE
 
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        ROLLBACK WORK
        DISPLAY BY NAME g_tsc.tsc01,g_tsc.tsc02 #MOD-9B0120 add  
        DISPLAY BY NAME g_tsc.tsc21             #MOD-AA0167
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM tsc_file         #單頭複製
        WHERE tsc01=g_tsc.tsc01
        INTO TEMP y
    UPDATE y
        SET tsc01=l_newno,    #新的鍵值
            tsc02=l_newdate,  #MOD-9B0120 add
            tsc21=l_tsc21,    #MOD-AA0167
            tscuser=g_user,   #資料所有者
            tscgrup=g_grup,   #資料所有者所屬群
            tscorig=g_grup,      #TQC-A30048 ADD
            tscoriu=g_user,      #TQC-A30048 ADD
            tscmodu=NULL,     #資料更改日期
            tscdate=g_today,  #資料建立日期
            tscacti='Y',      #有效資料
            tscconf='N',      #審核碼
            tscpost='N',      #過帳碼
            tsccond='',        #FUN-870100
            tscconu='',        #FUN-870100
            tsccont=''         #FUN-870100
    INSERT INTO tsc_file
        SELECT * FROM y
 
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","tsc_file",g_tsc.tsc01,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
        ROLLBACK WORK
        RETURN
    ELSE
        COMMIT WORK
    END IF
 
    DROP TABLE x
    SELECT * FROM tsd_file         #單身複製
        WHERE tsd01=g_tsc.tsc01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","x",g_tsc.tsc01,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
        RETURN
    END IF
    UPDATE x
        SET tsd01=l_newno
    INSERT INTO tsd_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","tsd_file",g_tsc.tsc01,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
        RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno = g_tsc.tsc01
     SELECT tsc_file.* INTO g_tsc.* FROM tsc_file
      WHERE tsc01 = l_newno
     CALL t260_u()
     CALL t260_b()
     #FUN-C80046
     #LET g_tsc.tsc01 = l_oldno
     #SELECT tsc_file.* INTO g_tsc.* FROM tsc_file
     # WHERE tsc01 = l_oldno
     #FUN-C80046
     CALL t260_show()
     DISPLAY BY NAME g_tsc.tsc01
END FUNCTION
 
FUNCTION t260_y()
   DEFINE  l_tsccont  LIKE tsc_file.tsccont  #FUN-870100
   DEFINE  l_rvbs06   LIKE rvbs_file.rvbs06  #CHI-A70027 add
   DEFINE  i          LIKE type_file.num5    #CHI-A70027 add
   DEFINE  l_tsd12    LIKE tsd_file.tsd12    #No.FUN-AA0048
   DEFINE  l_img09    LIKE img_file.img09    #CHI-C30064 add
   DEFINE  l_ima25_fac LIKE ima_file.ima25   #CHI-C30064 add
   DEFINE l_gen02 LIKE gen_file.gen02 #CHI-D20015 add
   define l_cnt integer #darcy:2023/10/26 add

 
    IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30106
    IF g_tsc.tsc01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tsc.* FROM tsc_file WHERE tsc01=g_tsc.tsc01
    IF g_tsc.tscacti='N' THEN
       CALL cl_err(g_tsc.tsc01,'mfg1000',0)
       RETURN
    END IF
    IF g_tsc.tscconf='Y' THEN RETURN END IF
    IF g_tsc.tscconf='X' THEN
       CALL cl_err(g_tsc.tsc01,'axr-103',0)
       RETURN
    END IF
   #IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30106 mark

    #No.FUN-AA0048  --Begin
    IF NOT s_chk_ware(g_tsc.tsc12) THEN
       RETURN
    END IF
    DECLARE t260_ware_cs1 CURSOR FOR
     SELECT tsd12 FROM tsd_file
      WHERE tsd01 = g_tsc.tsc01
    FOREACH t260_ware_cs1 INTO l_tsd12
        IF NOT s_chk_ware(l_tsd12) THEN
           RETURN
        END IF
    END FOREACH
    #No.FUN-AA0048  --End  

    #CHI-A70027 add --start--
    #控管單頭批序號的數量是否與單據數量相符
    LET g_ima918 = ''
    LET g_ima921 = ''
    SELECT ima918,ima921 INTO g_ima918,g_ima921 
      FROM ima_file
     WHERE ima01 = g_tsc.tsc03
       AND imaacti = "Y"
    IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
       SELECT SUM(rvbs06) INTO l_rvbs06
         FROM rvbs_file
        WHERE rvbs00 = g_prog
          AND rvbs01 = g_tsc.tsc01
          AND rvbs02 = 0
          AND rvbs09 = 1

       IF cl_null(l_rvbs06) THEN
          LET l_rvbs06 = 0
       END IF

       CALL t260_ima25(g_tsc.tsc03,g_tsc.tsc12,g_tsc.tsc13,g_tsc.tsc14,g_tsc.tsc04)                   
      #CHI-C30064---Start---add
       SELECT img09 INTO l_img09 FROM img_file
        WHERE img01= g_tsc.tsc03 AND img02= g_tsc.tsc12 
          AND img03= g_tsc.tsc13 AND img04= g_tsc.tsc14 
       CALL s_umfchk(g_tsc.tsc03,g_tsc.tsc04,l_img09) RETURNING g_cnt,l_ima25_fac
       IF g_cnt = '1' THEN
          LET l_ima25_fac = 1
       END IF             
      #CHI-C30064---End---add  
      #IF (g_tsc.tsc05 * g_ima25_fac) <> l_rvbs06 THEN
       IF (g_tsc.tsc05 * l_ima25_fac) <> l_rvbs06 THEN #CHI-C30064 
          CALL cl_err(g_tsc.tsc03,"aim-011",1)
          RETURN 
       END IF
    END IF
    #darcy:2023/10/26 add s---
    # 管控数量不得超过本次良品转出数量
    let l_cnt = 0
    select count(1) into l_cnt from shb_file
      where shb01 = g_tsc.tscud02 and shb111 >= g_tsc.tsc05
    if l_cnt = 0 then
      call cl_err(g_tsc.tsc05,"ctm-007",1)
      return
    end if
    #darcy:2023/10/26 add e---
    #控管單身批序號的數量是否與單據數量相符
    FOR i = 1 TO g_rec_b
       LET g_ima918 = ''
       LET g_ima921 = ''
       SELECT ima918,ima921 INTO g_ima918,g_ima921 
         FROM ima_file
        WHERE ima01 = g_tsd[i].tsd03
          AND imaacti = "Y"
       IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
          SELECT SUM(rvbs06) INTO l_rvbs06
            FROM rvbs_file
           WHERE rvbs00 = g_prog
             AND rvbs01 = g_tsc.tsc01
             AND rvbs02 = g_tsd[i].tsd02
             AND rvbs09 = -1

          IF cl_null(l_rvbs06) THEN
             LET l_rvbs06 = 0
          END IF

          CALL t260_ima25(g_tsd[i].tsd03,g_tsd[i].tsd12,g_tsd[i].tsd13,g_tsd[i].tsd14,g_tsd[i].tsd04)                   
         #CHI-C30064---Start---add
          SELECT img09 INTO l_img09 FROM img_file
           WHERE img01= g_tsd[i].tsd03 AND img02= g_tsd[i].tsd12
             AND img03= g_tsd[i].tsd13 AND img04= g_tsd[i].tsd14
          CALL s_umfchk(g_tsd[i].tsd03,g_tsd[i].tsd04,l_img09) RETURNING g_cnt,l_ima25_fac
          IF g_cnt = '1' THEN
             LET l_ima25_fac = 1
          END IF
         #CHI-C30064---End---add
         #IF (g_tsd[i].tsd05 * g_ima25_fac) <> l_rvbs06 THEN
          IF (g_tsd[i].tsd05 * l_ima25_fac) <> l_rvbs06 THEN #CHI-C30064
             CALL cl_err(g_tsd[i].tsd03,"aim-011",1)
             RETURN
          END IF
       END IF
    END FOR
    #CHI-A70027 add --end--
 
    LET g_success='Y'
    BEGIN WORK
 
    OPEN t260_cl USING g_tsc.tsc01
    IF STATUS THEN
       CALL cl_err("OPEN t260_cl:", STATUS, 1)
       CLOSE t260_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t260_cl INTO g_tsc.*  # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tsc.tsc01,SQLCA.sqlcode,0)
        CLOSE t260_cl
        ROLLBACK WORK
        RETURN
    END IF
    LET l_tsccont=TIME  #FUN-870100
    UPDATE tsc_file SET tscconf='Y',tsccond=g_today,tscconu=g_user,tsccont=l_tsccont  #FUN-870100
     WHERE tsc01 = g_tsc.tsc01
    IF STATUS THEN
       CALL cl_err3("upd","tsc_file",g_tsc.tsc01,"",STATUS,"","",1) #No.FUN-660104
       LET g_success = 'N'
    END IF
    IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_cmmsg(1)
    ELSE
       ROLLBACK WORK
       CALL cl_rbmsg(1)
    END IF
    SELECT tscconf,tsccont,tscconu,tsccond INTO g_tsc.tscconf,g_tsc.tsccont,g_tsc.tscconu,g_tsc.tsccond FROM tsc_file
                                                   #TQC-A10108 add tsccont,tscconu,tsccond
     WHERE tsc01 = g_tsc.tsc01
    DISPLAY BY NAME g_tsc.tscconf,g_tsc.tsccond,g_tsc.tscconu,g_tsc.tsccont  #FUN-870100
   #CHI-D20015--add-s-tr
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_tsc.tscconu
    DISPLAY l_gen02 TO tscconu_desc
   #CHI-D20015--add--end
    IF g_tsc.tscconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_tsc.tscconf='Y' THEN LET g_approve='Y' ELSE LET g_approve='N' END IF   #No.TQC-640116
    CALL cl_set_field_pic(g_tsc.tscconf,g_approve,g_tsc.tscpost,"",g_chr,g_tsc.tscacti)     #No.TQC-640116
END FUNCTION
 
FUNCTION t260_z()
DEFINE l_n LIKE type_file.num5          #No.FUN-680120 SMALLINT
   DEFINE l_gen02 LIKE gen_file.gen02 #CHI-D20015 add
    
    IF g_tsc.tsc01 IS NULL THEN RETURN END IF

    #No.FUN-A50071 -----start---------    
    #-->POS單號不為空時不可取消確認
    IF NOT cl_null(g_tsc.tsc20) THEN
       CALL cl_err(' ','axm-743',0)
       RETURN
    END IF 
    #No.FUN-A50071 -----end---------
    
    SELECT * INTO g_tsc.* FROM tsc_file WHERE tsc01=g_tsc.tsc01
    IF g_tsc.tscconf='N' THEN RETURN END IF
    IF g_tsc.tscconf='X' THEN
       CALL cl_err('','axr-103',0)
       RETURN
    END IF
    IF g_tsc.tscpost = 'Y' THEN
       CALL cl_err(g_tsc.tsc01,"afa-106",0)
       RETURN
    END IF
    IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
    LET g_success='Y'
    BEGIN WORK
        OPEN t260_cl USING g_tsc.tsc01
        IF STATUS THEN
           CALL cl_err("OPEN t260_cl:", STATUS, 1)
           CLOSE t260_cl
           ROLLBACK WORK
           RETURN
        END IF
        FETCH t260_cl INTO g_tsc.*               # 對DB鎖定
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_tsc.tsc01,SQLCA.sqlcode,0)
            CLOSE t260_cl
            ROLLBACK WORK
            RETURN
        END IF
       #UPDATE tsc_file SET tscconf='N',tsccond='',tscconu='',tsccont=''  #FUN-870100#CHI-D20015 mark
        UPDATE tsc_file SET tscconf='N',tsccond=g_today,tscconu= g_user,tsccont=g_time#CHI-D20015 add
            WHERE tsc01 = g_tsc.tsc01
        IF STATUS THEN
            CALL cl_err3("upd","tsc_file",g_tsc.tsc01,"",STATUS,"","upd tscconf",1) #No.FUN-660104
            LET g_success='N'
        END IF
        IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_cmmsg(1)
        ELSE
            ROLLBACK WORK
            CALL cl_rbmsg(1)
        END IF
        SELECT tscconf,tscconu,tsccont,tsccond INTO g_tsc.tscconf,g_tsc.tscconu,g_tsc.tsccont,g_tsc.tsccond FROM tsc_file
                           #TQC-A10108 add tscconu,tsccont,tsccond
            WHERE tsc01 = g_tsc.tsc01
        DISPLAY BY NAME g_tsc.tscconf,g_tsc.tsccond,g_tsc.tscconu,g_tsc.tsccont  #FUN-870100
   #CHI-D20015--add-s-tr
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_tsc.tscconu
    DISPLAY l_gen02 TO tscconu_desc
   #CHI-D20015--add--end
        IF g_tsc.tscconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        IF g_tsc.tscconf='Y' THEN LET g_approve='Y' ELSE LET g_approve='N' END IF   #No.TQC-640116
        CALL cl_set_field_pic(g_tsc.tscconf,g_approve,g_tsc.tscpost,"",g_chr,g_tsc.tscacti)     #No.TQC-640116
END FUNCTION
 
FUNCTION t260_post()
DEFINE l_img10     LIKE img_file.img10,
       l_img09     LIKE img_file.img09,
       l_ima25     LIKE ima_file.ima25,
       l_ima906    LIKE ima_file.ima906,
       l_imafac    LIKE type_file.num5,             #No.FUN-680120 SMALLINT
       l_imaqty    LIKE tsc_file.tsc05
DEFINE l_cnt       LIKE type_file.num10             #No.FUN-680120 INTEGER
DEFINE l_sql       LIKE type_file.chr1000           #No.FUN-680120 VARCHAR(400)
DEFINE l_tsd041    LIKE tsd_file.tsd041
DEFINE l_re        LIKE type_file.num5              #No.FUN-680120 SMALLINT
DEFINE l_i         LIKE type_file.num10             #TQC-BB0207
 
    IF g_tsc.tscacti = 'N' THEN
       CALL cl_err(g_tsc.tsc01,'mfg1000',0)
       RETURN
    END IF
    IF g_tsc.tscconf='N' OR g_tsc.tscpost='Y' THEN
       CALL cl_err(g_tsc.tsc01,'afa-100',1)
       RETURN
    END IF

    #TQC-BB0207 mark begin------------- 
    #CALL t260_pb() RETURNING l_re  #FUN-610066
    #IF l_re=1 THEN
    #   CALL cl_err('','lib-028',0)
    #   RETURN
    #END IF
    #TQC-BB0207 mark end--------------
#TQC-BB0207 add begin------------------------------------
    IF s_shut(0) THEN RETURN END IF
    IF g_tsc.tsc01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tsc.* FROM tsc_file WHERE tsc01=g_tsc.tsc01
    IF g_tsc.tscacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_tsc.tsc01,'mfg1000',0)
        RETURN
    END IF
    IF g_tsc.tscconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
   # LET g_success='Y'   #mark by zhangzs 210113
    CALL s_showmsg_init()
    FOR l_i =1 TO g_rec_b
        #MOD-C40211 add begin---------
        SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
         WHERE img01=g_tsd[l_i].tsd03 AND img02=g_tsd[l_i].tsd12
           AND img03=g_tsd[l_i].tsd13 AND img04=g_tsd[l_i].tsd14
        CALL s_umfchk(g_tsd[l_i].tsd03,g_tsd[l_i].tsd04,g_img09)
                       RETURNING g_cnt,g_tsd041
        #IF g_tsd[l_i].tsd05*g_tsd041 > g_img10 THEN  #mark by sx210305 atmt260单身仅作退料,发料根据单头料号BOM产生
        IF 1=2 THEN    #add by sx210305
           #FUN-C80107 modify begin------------------------121024
           #CALL s_errmsg("tsd05",g_tsd[l_i].tsd05,"","mfg1303",1)
           #LET g_success = 'N'
          #FUN-D30024--modify--str--
          #INITIALIZE g_sma894 TO NULL
          #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_tsd[l_i].tsd12) RETURNING g_sma894
          #IF g_sma894 = 'N' THEN
           INITIALIZE g_imd23 TO NULL
           CALL s_inv_shrt_by_warehouse(g_tsd[l_i].tsd12,g_plant) RETURNING g_imd23  #TQC-D30044  #TQC-D40078 g_plant
           IF g_imd23 = 'N' THEN
          #FUN-D30024--modify--end--
              CALL s_errmsg("tsd05",g_tsd[l_i].tsd05,"","mfg1303",1)
              LET g_success = 'N'
           ELSE
              IF NOT cl_confirm('mfg3469') THEN
                 LET g_success='N'
              END IF
           END IF
           #FUN-C80107 modify end--------------------------
        END IF
        #MOD-C40211 add end-----------

        SELECT ima906 INTO g_ima906 FROM ima_file
         WHERE ima01=g_tsd[l_i].tsd03

        IF g_ima906 MATCHES '[23]' THEN
            SELECT imgg10 INTO g_imgg10_2 FROM imgg_file
             WHERE imgg01=g_tsd[l_i].tsd03
               AND imgg02=g_tsd[l_i].tsd12
               AND imgg03=g_tsd[l_i].tsd13
               AND imgg04=g_tsd[l_i].tsd14
               AND imgg09=g_tsd[l_i].tsd09
        END IF
        IF g_tsd[l_i].tsd11 > g_imgg10_2 THEN
           #FUN-D30024--modify--str-- 
           #INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
           #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_tsd[l_i].tsd12) RETURNING g_sma894       #FUN-C80107
           ##IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN                                #FUN-C80107 mark
           #IF g_sma894 = 'N' THEN      #FUN-C80107
            INITIALIZE g_imd23 TO NULL
            CALL s_inv_shrt_by_warehouse(g_tsd[l_i].tsd12,g_plant) RETURNING g_imd23  #TQC-D30044   #TQC-D40078 g_plant
            IF g_imd23 = 'N' THEN
           #FUN-D30024--modify--end--
                CALL s_errmsg("tsd11",g_tsd[l_i].tsd11,"","mfg1303",1)
                LET g_success='N'
            ELSE
                IF NOT cl_confirm('mfg3469') THEN
                   LET g_success='N'
                END IF
            END IF
        END IF
        IF NOT cl_null(g_tsd[l_i].tsd06) THEN
            IF g_ima906 = '2' THEN   #MATCHES '[23]' THEN
                IF g_tsd[l_i].tsd08 > g_imgg10_1 THEN
                   #IF g_sma.sma894[1,1] = 'N' OR g_sma.sma894[1,1] IS NULL THEN   #FUN-C80107 mark
                   #FUN-D30024--modify--str--
                   #INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
                   #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_tsd[l_i].tsd12) RETURNING g_sma894       #FUN-C80107
                   #IF g_sma894 = 'N' THEN                                                                    #FUN-C80107
                    INITIALIZE g_imd23 TO NULL
                    CALL s_inv_shrt_by_warehouse(g_tsd[l_i].tsd12,g_plant) RETURNING g_imd23     #TQC-D40078 g_plant
                    IF g_imd23 = 'N' THEN
                   #FUN-D30024--modify--end--
                        CALL s_errmsg("tsd08",g_tsd[l_i].tsd08,"","mfg1303",1)
                        LET g_success='N'
                    ELSE
                        IF NOT cl_confirm('mfg3469') THEN
                            LET g_success='N'
                        END IF
                    END IF
                END IF
            ELSE
                IF g_tsd[l_i].tsd08*g_tsd[l_i].tsd07 > g_imgg10_1 THEN
                   #IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN   #FUN-C80107 mark
                   #FUN-D30024--modify--str--
                   #INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
                   #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_tsd[l_i].tsd12) RETURNING g_sma894       #FUN-C80107
                   #IF g_sma894 = 'N' THEN                                                                    #FUN-C80107
                    INITIALIZE g_imd23 TO NULL
                    CALL s_inv_shrt_by_warehouse(g_tsd[l_i].tsd12,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant
                    IF g_imd23 = 'N' THEN
                   #FUN-D30024--modify--end--
                        CALL s_errmsg("tsd08",g_tsd[l_i].tsd08,"","mfg1303",1)
                        LET g_success='N'
                    ELSE
                        IF NOT cl_confirm('mfg3469') THEN
                            LET g_success='N'
                        END IF
                    END IF
                END IF
            END IF
        END IF
    END FOR
    IF g_success='N' THEN
       CALL s_showmsg()
       RETURN
    END IF
#TQC-BB0207 add end---------------------------------------
 
 #MOD-AA0167 --begin--
    IF g_sma.sma53 IS NOT NULL AND g_tsc.tsc21 <= g_sma.sma53 THEN 
       CALL cl_err('','mfg9999',0)
       let g_success ='N' #darcy:2024/07/04 add
       RETURN
    END IF    
    CALL s_yp(g_tsc.tsc21) RETURNING g_yy,g_mm
    IF g_yy*12+g_mm > g_sma.sma51*12+g_sma.sma52 THEN #不可大於現行年月
       CALL cl_err('','mfg6091',0)
       let g_success ='N' #darcy:2024/07/04 add
       RETURN 
     END IF           
 #MOD-AA0167 --end--
 
    
 
  #  LET g_totsuccess='Y'   #MOD-7C0005-add  #mark by zhangzs 210113
  #  LET g_success='Y'   #0211  #mark by zhangzs 210113
  #  BEGIN WORK   #mark by zhangzs 210113

   #CHI-C30106---add---S--- 
    OPEN t260_cl USING g_tsc.tsc01
            IF STATUS THEN
               CALL cl_err("OPEN t260_cl:", STATUS, 1)
               CLOSE t260_cl
               ROLLBACK WORK 
               RETURN
            END IF      
            FETCH t260_cl INTO g_tsc.*            # 鎖住將被更改或撤銷的資料
            IF SQLCA.sqlcode THEN
              CALL cl_err(g_tsc.tsc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t260_cl 
              RETURN    
            END IF  
   #CHI-C30106---add---E---
    CALL t260_post_update(g_tsc.tsc01)
 
    CALL s_showmsg()        #No.FUN-710033
    IF g_success='Y' THEN
       CALL cl_err(g_tsc.tsc01,'lib-022',0)
       UPDATE tsc_file SET tscpost='Y'       #MOD-A80061
        WHERE tsc01 = g_tsc.tsc01            #MOD-A80061
    ELSE
       CALL cl_err(g_tsc.tsc01,'lib-028',0)
    END IF
 
#    UPDATE tsc_file SET tscpost='Y'       #MOD-A80061
#     WHERE tsc01 = g_tsc.tsc01            #MOD-A80061
 
#    IF STATUS THEN                        #MOD-A80061
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN   #MOD-A80061
       CALL cl_err3("upd","tsc_file",g_tsc.tsc01,"",STATUS,"","upd tscpost",1) #No.FUN-660104
       LET g_success = 'N'
    END IF
#mark by zhangzs 210113   -------s-------
    #IF g_success = 'Y' THEN
    #   COMMIT WORK
    #   CALL cl_cmmsg(1)
    #ELSE
    #   ROLLBACK WORK
    #   CALL cl_rbmsg(1)
    #END IF
#mark by zhangzs 210113   -------e-------
    SELECT tscpost,tsc19 INTO g_tsc.tscpost,g_tsc.tsc19 FROM tsc_file  #No.FUN-950021
     WHERE tsc01 = g_tsc.tsc01
 
    DISPLAY g_tsc.tscpost TO tscpost
    DISPLAY BY NAME g_tsc.tsc19     #No.FUN-950021
    IF g_tsc.tscconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_tsc.tscconf='Y' THEN LET g_approve='Y' ELSE LET g_approve='N' END IF   #No.TQC-640116
   #  CALL cl_set_field_pic(g_tsc.tscconf,g_approve,g_tsc.tscpost,"",g_chr,g_tsc.tscacti)     #No.TQC-640116
   #  CALL t260_show()  #0222
END FUNCTION
 
FUNCTION t260_post_update(p_tsc01)
   DEFINE p_tsc01        LIKE tsc_file.tsc01
   DEFINE l_tsc          RECORD LIKE tsc_file.*
   DEFINE l_sfb01        LIKE sfb_file.sfb01
   DEFINE l_sfp01        LIKE sfp_file.sfp01
   DEFINE l_sfp01_1      LIKE sfp_file.sfp01    #add by sx210312 原工单退料单
   DEFINE l_sfp          RECORD LIKE sfp_file.*
   DEFINE l_sfu01        LIKE sfu_file.sfu01
   DEFINE l_flag         LIKE type_file.num5
   DEFINE l_o_prog       STRING
 
   SELECT * INTO l_tsc.* FROM tsc_file WHERE tsc01 = p_tsc01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','tsc_file',p_tsc01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
 
   #Generate W/O
   CALL t260_ins_sfb(p_tsc01) RETURNING l_flag,l_sfb01
   IF NOT l_flag THEN
      LET g_success='N'
      RETURN
   END IF
 
 
#--TQC-CC0143--mark--star--
#  #W/OConfirm Check
#  CALL i301sub_firm1_chk(l_sfb01,TRUE)
#  IF g_success = 'N' THEN
#     RETURN
#  END IF
#--TQC-CC0143--mark--end--
   #W/O Confirm
   CALL i301sub_firm1_upd(l_sfb01,NULL,TRUE)
   IF g_success = 'N' THEN
      RETURN
   END IF
 
   #No.CHI-A70051  --Begin
   LET l_o_prog = g_prog
   LET g_prog = 'asfi511'
   #No.CHI-A70051  --End  

   #Genero W.O Issue Note
   CALL t260_ins_sfp(p_tsc01,l_sfb01) RETURNING l_flag,l_sfp01,l_sfp01_1     #add l_sfp01_1 by sx210312 
   IF NOT l_flag THEN
      LET g_success = 'N'
      RETURN
   END IF
 
   LET l_o_prog = g_prog        #add by sx210321---s
   LET g_prog = 'asfi528'
   call cl_progressing(sfmt("一般退料单自动审核过账-%1",l_sfp01_1)) #darcy:2024/07/04 add
   CALL i501sub_y_chk(l_sfp01_1,NULL)  
   IF g_success = 'N' THEN
      RETURN
   END IF
  
   CALL i501sub_y_upd(l_sfp01_1,NULL,TRUE)
        RETURNING l_sfp.*
   IF g_success = 'N' THEN
      RETURN
   END IF
   CALL i501sub_s('2',l_sfp01_1,TRUE,'N')   #tuiliao
   IF g_success = 'N' THEN
      RETURN
   END IF
   LET g_prog = l_o_prog       #add by sx210321---e
   call cl_progressing(sfmt("退料单自动审核过账-%1",l_sfp01)) #darcy:2024/07/04 add
   #W.O Issue Note Confirm Check
   CALL i501sub_y_chk(l_sfp01,NULL)  #TQC-C60079
   IF g_success = 'N' THEN
      RETURN
   END IF
 
   #W.O Issue Note Confirm
   CALL i501sub_y_upd(l_sfp01,NULL,TRUE)
        RETURNING l_sfp.*
   IF g_success = 'N' THEN
      RETURN
   END IF
 
   #W.O Issue Note Post
   CALL i501sub_s('1',l_sfp01,TRUE,'N')
   IF g_success = 'N' THEN
      RETURN
   END IF
   LET g_prog = l_o_prog
 
   #No.CHI-A70051  --Begin
   LET l_o_prog = g_prog
   LET g_prog = 'asft620'
   #No.CHI-A70051  --End  

   #Generate Stock-In Note
   CALL t260_ins_sfu(p_tsc01,l_sfb01,l_sfp01)
        RETURNING l_flag,l_sfu01
   IF NOT l_flag THEN
      LET g_success = 'N'
      RETURN
   END IF
   call cl_progressing(sfmt("入库单自动审核过账-%1",l_sfu01)) #darcy:2024/07/04 add
   #Stock-In Note Confirm Check
   CALL t620sub_y_chk('1',l_sfu01,NULL) #CHI-C30118 add g_action_choice #TQC-C60079 
   IF g_success = 'N' THEN
      RETURN
   END IF
 
   #Stock-In Note Confirm
   CALL t620sub_y_upd(l_sfu01,NULL,TRUE)
   IF g_success = 'N' THEN
      RETURN
   END IF
 
   #Stock-In Note Post
   CALL t620sub_s(l_sfu01,'1',TRUE,NULL)
   IF g_success = 'N' THEN
     RETURN
   END IF
   LET g_prog = l_o_prog
 
   #No.CHI-A80043  --Begin
   CALL t260_sfb_close(l_sfb01)
   IF g_success = 'N' THEN
      RETURN
   END IF
   #No.CHI-A80043  --End  

   #Update atmt260
   UPDATE tsc_file SET tsc19 = l_sfb01 WHERE tsc01 = p_tsc01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('upd','tsc_file',p_tsc01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
 
FUNCTION t260_undo_post()
DEFINE l_img10     LIKE img_file.img10,
       l_img09     LIKE img_file.img09,
       l_ima25     LIKE ima_file.ima25,
       l_ima906    LIKE ima_file.ima906,
       l_imafac    LIKE type_file.num5,             #No.FUN-680120 SMALLINT
       l_imaqty    LIKE tsc_file.tsc05
DEFINE l_cnt       LIKE type_file.num10             #No.FUN-680120 INTEGER
DEFINE l_sql       LIKE type_file.chr1000           #No.FUN-680120 VARCHAR(400)
DEFINE l_tsd041    LIKE tsd_file.tsd041
DEFINE l_shb16    LIKE shb_file.shb16         #add by sx220617
DEFINE l_shb081   LIKE shb_file.shb081        #add by sx220617
DEFINE l_shb06    LIKE shb_file.shb06         #add by sx220617
DEFINE l_sgm314   LIKE sgm_file.sgm314        #add by sx220617
 
    IF g_tsc.tscacti = 'N' THEN
       CALL cl_err(g_tsc.tsc01,'mfg1000',0)
       RETURN
    END IF
    IF g_tsc.tscpost='N' THEN
       CALL cl_err(g_tsc.tsc01,'afa-108',1)
       RETURN
    END IF
 
 #MOD-AA0167 --begin--
    IF g_sma.sma53 IS NOT NULL AND g_tsc.tsc21 <= g_sma.sma53 THEN 
       CALL cl_err('','mfg9999',0)
       RETURN
    END IF    
    CALL s_yp(g_tsc.tsc21) RETURNING g_yy,g_mm
    IF g_yy*12+g_mm > g_sma.sma51*12+g_sma.sma52 THEN #不可大於現行年月
       CALL cl_err('','mfg6091',0)
       RETURN 
     END IF           
 #MOD-AA0167 --end--
    
    IF NOT cl_confirm('asf-663') THEN RETURN END IF

    #No.FUN-A50071 ----------start----------   
    #-->POS單號不為空時不可过帳還原
    IF NOT cl_null(g_tsc.tsc20) THEN
       CALL cl_err('','axm-744' ,0)
       RETURN 
    END IF 
    #No.FUN-A50071 ----------end----------
 
    LET g_totsuccess='Y'   #MOD-7C0005-add
    LET g_success='Y'      #0211
    BEGIN WORK
    CALL t260_undo_post_update(g_tsc.tsc01)
       CALL s_showmsg()        #No.FUN-710033
    IF g_success='Y' THEN
       CALL cl_err(g_tsc.tsc01,'lib-022',0)
       UPDATE tsc_file SET tscpost= 'N'        #MOD-A80061
        WHERE tsc01 = g_tsc.tsc01              #MOD-A80061
       #add by zhangzs 210206  ------s--------  修改工单下版数量
       SELECT shb05 INTO l_shb05 FROM shb_file WHERE shb01 = g_tsc.tscud02 #查工单号
       SELECT sfbud12 INTO l_sfbud12 FROM sfb_file WHERE sfb01 = l_shb05  #查下版数量
       IF l_sfbud12 IS NULL THEN 
          LET l_sfbud12 = 0
       END IF 
       LET l_sfbud12 = l_sfbud12 - g_tsc.tsc05
       UPDATE sfb_file SET sfbud12 = l_sfbud12 WHERE sfb01 = l_shb05
       #add by zhangzs 210206  ------e--------
       #add by sx220617  ------s--------  更新sgm314当站下线量(入库)
       SELECT shb16, shb081,shb06 INTO l_shb16, l_shb081,l_shb06 FROM shb_file WHERE shb01 = g_tsc.tscud02 #查工单号
       SELECT sgm314 INTO l_sgm314 FROM sgm_file  WHERE sgm01 = l_shb16 AND sgm03 = l_shb06 AND sgm04 = l_shb081
       IF l_sgm314 - g_tsc.tsc05 >= 0 THEN
          UPDATE sgm_file SET sgm314 = sgm314 - g_tsc.tsc05 WHERE sgm01 = l_shb16 AND sgm03 = l_shb06 AND sgm04 = l_shb081
       ELSE 
          CALL cl_err('扣账还原后aecq710下线数量会<0，请先找IT调整下线数量再还原','!',1)
          LET g_success = 'N'
       END IF 
       #add by sx220617  ------e--------
    ELSE
       CALL cl_err(g_tsc.tsc01,'lib-028',0)
    END IF
 
#    UPDATE tsc_file SET tscpost= 'N'        #MOD-A80061
#     WHERE tsc01 = g_tsc.tsc01              #MOD-A80061
 
#    IF STATUS THEN                           #MOD-A80061
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN  #MOD-A80061
       CALL cl_err3("upd","tsc_file",g_tsc.tsc01,"",STATUS,"","upd tscpost",1) #No.FUN-660104
       LET g_success = 'N'
    END IF
    IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_cmmsg(1)
    ELSE
       ROLLBACK WORK
       CALL cl_rbmsg(1)
    END IF
    SELECT tscpost,tsc19 INTO g_tsc.tscpost,g_tsc.tsc19 FROM tsc_file  #No.FUN-950021
     WHERE tsc01 = g_tsc.tsc01
 
    DISPLAY g_tsc.tscpost TO tscpost
    DISPLAY BY NAME g_tsc.tsc19     #No.FUN-950021
    IF g_tsc.tscconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_tsc.tscconf='Y' THEN LET g_approve='Y' ELSE LET g_approve='N' END IF   #No.TQC-640116
    CALL cl_set_field_pic(g_tsc.tscconf,g_approve,g_tsc.tscpost,"",g_chr,g_tsc.tscacti)     #No.TQC-640116
    CALL t260_show()  #0222
 
END FUNCTION
 
FUNCTION t260_undo_post_update(p_tsc01)
   DEFINE p_tsc01      LIKE tsc_file.tsc01
   DEFINE l_tsc19      LIKE tsc_file.tsc19
   DEFINE l_sfb01      LIKE sfb_file.sfb01
   DEFINE l_sfb04      LIKE sfb_file.sfb04
   DEFINE l_sfu01      LIKE sfu_file.sfu01
   DEFINE l_sfp01      LIKE sfp_file.sfp01
   DEFINE l_sfp06      LIKE sfp_file.sfp06
   DEFINE l_o_prog     STRING
   #FUN-BC0104-add-str--
   DEFINE l_sfv03  LIKE sfv_file.sfv03,
          l_sfv17  LIKE sfv_file.sfv17,
          l_sfv47  LIKE sfv_file.sfv47,
          l_flagg  LIKE type_file.chr1
   DEFINE l_cn     LIKE  type_file.num5
   DEFINE l_c      LIKE  type_file.num5
   DEFINE l_sfv_a  DYNAMIC ARRAY OF RECORD
          sfv17    LIKE  sfv_file.sfv17,
          sfv47    LIKE  sfv_file.sfv47,
          flagg    LIKE  type_file.chr1
                   END RECORD
   #FUN-BC0104-add-end--
 
   SELECT tsc19 INTO l_tsc19 FROM tsc_file WHERE tsc01 = p_tsc01
   IF cl_null(l_tsc19) THEN
      CALL cl_err(p_tsc01,'atm-411','1')  #組合/拆解單對應的工單號為空!
      LET g_success = 'N'
      RETURN
   END IF
 
   LET l_sfb01 = l_tsc19

   #No.CHI-A80043  --Begin
   CALL t260_sfb_undo_close(l_sfb01)
   IF g_success = 'N' THEN
      RETURN
   END IF
   #No.CHI-A80043  --End  

   SELECT sfb04 INTO l_sfb04 FROM sfb_file WHERE sfb01 = l_sfb01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','sfb_file',l_sfb01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
   IF l_sfb04 <> '7' THEN
      CALL cl_err(l_sfb01,'asf-435',1)
      LET g_success = 'N'
      RETURN
   END IF
 
   LET l_o_prog = g_prog
   LET g_prog = 'asft620'
   SELECT UNIQUE sfv01 INTO l_sfu01 FROM sfu_file,sfv_file
    WHERE sfu01 = sfv01
      AND sfv11 = l_sfb01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','sfv_file',l_sfb01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
 
   #Stock-in Note undo_post
   CALL t620sub_w(l_sfu01,NULL,TRUE,'1')
   IF g_success = 'N' THEN
      RETURN
   END IF
 
   #Stock-in Note Undo_confirm
   CALL t620sub_z(l_sfu01,NULL,TRUE)
   IF g_success = 'N' THEN
      RETURN
   END IF
 
   #Delete Stock-in Note
   DELETE FROM sfu_file WHERE sfu01 = l_sfu01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3('del','sfu_file',l_sfu01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
   #FUN-BC0104-add-str--
   LET l_cn = 1
   DECLARE upd_sfv CURSOR FOR
    SELECT sfv03 FROM sfv_file WHERE sfv01 = l_sfu01
   FOREACH upd_sfv INTO l_sfv03
      CALL s_iqctype_sfv(l_sfu01,l_sfv03) RETURNING l_sfv17,l_sfv47,l_flagg
      LET l_sfv_a[l_cn].sfv17 = l_sfv17
      LET l_sfv_a[l_cn].sfv47 = l_sfv47
      LET l_sfv_a[l_cn].flagg = l_flagg
      LET l_cn = l_cn + 1
   END FOREACH
   #FUN-BC0104-add-end--
   DELETE FROM sfv_file WHERE sfv01 = l_sfu01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3('del','sfv_file',l_sfu01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
#FUN-B70074-add-delete--
   ELSE 
      #FUN-BC0104-add-str--
      FOR l_c=1 TO l_cn-1
         IF l_sfv_a[l_c].flagg = 'Y' THEN
            IF NOT s_iqctype_upd_qco20(l_sfv_a[l_c].sfv17,'','',l_sfv_a[l_c].sfv47,'2') THEN
               LET g_success ='N'
               RETURN
            END IF      
         END IF
      END FOR      
      #FUN-BC0104-add-end--
      IF NOT s_industry('std') THEN 
         IF NOT s_del_sfvi(l_sfu01,'','') THEN 
            LET g_success = 'N'
            RETURN
         END IF 
      END IF
#FUN-B70074-add-end----
   END IF

   #No.CHI-A70051  --Begin
   #删除入库的批序号内容
   DELETE FROM rvbs_file WHERE rvbs00 = 'asft620' AND rvbs01 = l_sfu01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('del','rvbs_file','asft620',l_sfu01,SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
   #No.CHI-A70051  --End  

   LET g_prog = l_o_prog
 
   #Issue
   LET l_o_prog = g_prog
   SELECT UNIQUE sfp01,sfp06 INTO l_sfp01,l_sfp06 FROM sfp_file,sfq_file
    WHERE sfp01 = sfq01
      AND sfq02 = l_sfb01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','sfq_file',l_sfb01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
   CASE l_sfp06
      WHEN "1" LET g_prog='asfi511'
      WHEN "2" LET g_prog='asfi512'
      WHEN "3" LET g_prog='asfi513'
      WHEN "4" LET g_prog='asfi514'
      WHEN "6" LET g_prog='asfi526'
      WHEN "7" LET g_prog='asfi527'
      WHEN "8" LET g_prog='asfi528'
      WHEN "9" LET g_prog='asfi529'
      WHEN "D" LET g_prog='asfi519'       #FUN-C70014
   END CASE
 
   #undo_post
   CALL i501sub_z('1',l_sfp01,NULL,FALSE)
   IF g_success = 'N' THEN
      RETURN
   END IF
 
   #undo_confirm
   CALL i501sub_w(l_sfp01,NULL,FALSE)
   IF g_success = 'N' THEN
      RETURN
   END IF
   LET g_prog = l_o_prog
 
   #Delete Issue Note
   DELETE FROM sfp_file WHERE sfp01 = l_sfp01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3('del','sfp_file',l_sfp01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
   DELETE FROM sfq_file WHERE sfq01 = l_sfp01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3('del','sfq_file',l_sfp01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
   DELETE FROM sfs_file WHERE sfs01 = l_sfp01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3('del','sfs_file',l_sfp01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   #FUN-B70074 -------------Begin---------------
   ELSE
      IF NOT s_industry('std') THEN
         IF NOT s_del_sfsi(l_sfp01,'','') THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF  
   #FUN-B70074 -------------End-----------------
   END IF
   #No.CHI-A70051  --Begin
   #删除发料的批序号内容
   DELETE FROM rvbs_file WHERE rvbs00 = 'asfi511' AND rvbs01 = l_sfp01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('del','rvbs_file','asfi511',l_sfp01,SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
   #No.CHI-A70051  --End  
 
   #W/O
   DELETE FROM sfb_file WHERE sfb01 = l_sfb01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3('del','sfb_file',l_sfb01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
   DELETE FROM sfa_file WHERE sfa01 = l_sfb01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3('del','sfa_file',l_sfb01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
 
   #update tsc19
   UPDATE tsc_file SET tsc19 = '' WHERE tsc01 = p_tsc01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3('upd','tsc_file',p_tsc01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
 
END FUNCTION
 
 
FUNCTION t260_out()
    DEFINE
        l_tsc           RECORD LIKE tsc_file.*,
        l_i             LIKE type_file.num5,             #No.FUN-680120 SMALLINT
        l_name          LIKE type_file.chr20,            #No.FUN-680120 VARCHAR(20)               # External(Disk) file name
        l_za05          LIKE za_file.za05,
        sr              RECORD
                        tsc01       LIKE tsc_file.tsc01,
                        tsc02       LIKE tsc_file.tsc02,
                        tsc17       LIKE tsc_file.tsc17,
                        tsc15       LIKE tsc_file.tsc15,
                        tsc16       LIKE tsc_file.tsc16,
                        tsc03       LIKE tsc_file.tsc03,
                        tsc12       LIKE tsc_file.tsc12,
                        tsc13       LIKE tsc_file.tsc13,
                        tsc14       LIKE tsc_file.tsc14,
                        tsc04       LIKE tsc_file.tsc04,
                        tsc05       LIKE tsc_file.tsc05,
                        tsc09       LIKE tsc_file.tsc09,
                        tsc10       LIKE tsc_file.tsc10,
                        tsc11       LIKE tsc_file.tsc11,
                        tsc06       LIKE tsc_file.tsc06,
                        tsc07       LIKE tsc_file.tsc07,
                        tsc08       LIKE tsc_file.tsc08,
                        tsc18       LIKE tsc_file.tsc18,
                        tsd02       LIKE tsd_file.tsd02,   #項次
                        tsd03       LIKE tsd_file.tsd03,   #產品編號
                        tsd12       LIKE tsd_file.tsd12,   #倉庫
                        tsd13       LIKE tsd_file.tsd13,   #庫位
                        tsd14       LIKE tsd_file.tsd14,   #批號
                        tsd04       LIKE tsd_file.tsd04,   #單位
                        tsd05       LIKE tsd_file.tsd05,   #數量
                        tsd09       LIKE tsd_file.tsd09,   #單位二
                        tsd10       LIKE tsd_file.tsd10,   #單位二轉換率
                        tsd11       LIKE tsd_file.tsd11,   #單位二數量
                        tsd06       LIKE tsd_file.tsd06,   #單位一
                        tsd07       LIKE tsd_file.tsd07,   #單位一轉換率
                        tsd08       LIKE tsd_file.tsd08,   #單位一數量
                        tsd15       LIKE tsd_file.tsd15    #備注
                        END RECORD
DEFINE l_sql1     LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(500)
DEFINE       l_tsc01         LIKE tsc_file.tsc01
DEFINE       l_tsc03         LIKE tsc_file.tsc03
DEFINE       l_azf03         LIKE azf_file.azf03
DEFINE       l_gem02         LIKE gem_file.gem02
DEFINE       l_imd02a        LIKE imd_file.imd02
DEFINE       l_ime03a        LIKE ime_file.ime03
DEFINE       l_imd02         LIKE imd_file.imd02
DEFINE       l_ime03         LIKE ime_file.ime03
DEFINE       l_ima02a        LIKE ima_file.ima02
DEFINE       l_ima02         LIKE ima_file.ima02
    CALL  cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'atmt260'
    IF cl_null(g_tsc.tsc01) THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
    IF cl_null(g_wc) THEN
       LET g_wc=" tsc01='",g_tsc.tsc01,"'"
       LET g_wc2=" 1=1 "
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT tsc01,tsc02,tsc17,tsc15,tsc16,tsc03,tsc12,tsc13,tsc14,",
              "       tsc04,tsc05,tsc09,tsc10,tsc11,tsc06,tsc07,tsc08,tsc18,",
              "       tsd02,tsd03,tsd12,tsd13,tsd14,tsd04,tsd05,tsd09,",
              "       tsd10,tsd11,tsd06,tsd07,tsd08,tsd15 ",
              "  FROM tsc_file,tsd_file ",
              " WHERE tsc01=tsd01 AND ",g_wc,
              "   AND ",g_wc2 CLIPPED
 
    PREPARE t260_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t260_co                         # CURSOR
        CURSOR FOR t260_p1
 
 
      FOREACH t260_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
            SELECT gem02 INTO l_gem02
              FROM gem_file
             WHERE gem01=sr.tsc15
            SELECT azf03 INTO l_azf03
              FROM azf_file
             WHERE azf01=sr.tsc17
            SELECT imd02 INTO l_imd02a
              FROM imd_file
             WHERE imd01=sr.tsc12
            SELECT ime03 INTO l_ime03a
              FROM ime_file
             WHERE ime01=sr.tsc12
               AND ime02=sr.tsc13
            SELECT ima02 INTO l_ima02a
              FROM ima_file
             WHERE ima01=sr.tsc03
            LET l_tsc01=sr.tsc01[1,16]
            LET l_tsc03=sr.tsc03[1,20]
 
            SELECT ima02 INTO l_ima02
              FROM ima_file
             WHERE ima01 = sr.tsd03
            SELECT imd02 INTO l_imd02
              FROM imd_file
             WHERE imd01=sr.tsd12
            SELECT ime03 INTO l_ime03
              FROM ime_file
             WHERE ime01=sr.tsd12
               AND ime02=sr.tsd13
        EXECUTE insert_prep USING
          l_tsc01,l_gem02,l_azf03,l_imd02,l_ime03,l_tsc03,l_ima02,
          l_imd02a,l_ime03a,l_ima02a,sr.tsc01,sr.tsc02,sr.tsc17,sr.tsc15,
          sr.tsc16,sr.tsc03,sr.tsc12,sr.tsc13,sr.tsc14,sr.tsc04,sr.tsc05,
          sr.tsc09,sr.tsc10,sr.tsc11,sr.tsc06,sr.tsc07,sr.tsc08,sr.tsc18,
          sr.tsd02,sr.tsd03,sr.tsd12,sr.tsd13,sr.tsd14,sr.tsd04,sr.tsd05,
          sr.tsd09,sr.tsd10,sr.tsd11,sr.tsd06,sr.tsd07,sr.tsd08,sr.tsd15
      END FOREACH
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(g_wc,'tsc01,tsc02,tsc17,tsc15,tsc16,tscconf,
                       tscpost,tsc03,tsc12,tsc13,tsc14,tsc04,tsc05,
                       tsc09,tsc11,tsc06,tsc08,tsc18,
                       tscuser,tscgrup,tscmodu,tscdate,tscacti,
                       tsd02,tsd03,tsd12,tsd13,tsd14,
                        tsd04,tsd05,tsd09,tsd11,tsd06,tsd08,tsd15')
           RETURNING g_wc
     END IF
     LET g_str = g_wc
     CALL cl_prt_cs3('atmt260','atmt260',g_sql,g_str)
    CLOSE t260_co
    ERROR ""
END FUNCTION

FUNCTION t260_du_default(p_cmd)
  DEFINE l_ima35    LIKE ima_file.ima35,
         l_ima36    LIKE ima_file.ima36,
         l_ima55    LIKE ima_file.ima55,
         l_ima906   LIKE ima_file.ima906,
         l_ima907   LIKE ima_file.ima907,
         l_item     LIKE img_file.img01,
         l_ware     LIKE img_file.img02,
         l_loc      LIKE img_file.img03,
         l_lot      LIKE img_file.img04,
         l_img09    LIKE img_file.img09,
         l_unit2    LIKE img_file.img09,
         l_fac2     LIKE tsc_file.tsc10,
         l_qty2     LIKE tsc_file.tsc11,
         l_unit1    LIKE img_file.img09,
         l_fac1     LIKE tsc_file.tsc10,
         l_qty1     LIKE tsc_file.tsc11,
         l_factor   LIKE oeb_file.oeb12,         #No.FUN-680120 DECIMAL(16,8)
         p_cmd      LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
      LET l_item = g_tsc.tsc03
      LET l_ware = g_tsc.tsc12
      LET l_loc  = g_tsc.tsc13
      LET l_lot  = g_tsc.tsc14
 
      IF cl_null(g_tsc.tsc03) THEN
         RETURN
      END IF
 
      SELECT ima55,ima906,ima907 INTO l_ima55,l_ima906,l_ima907
        FROM ima_file WHERE ima01 = l_item
 
      SELECT img09 INTO l_img09 FROM img_file
       WHERE img01=l_item
         AND img02=l_ware
         AND img03=l_loc
         AND img04=l_lot
      IF cl_null(l_img09) THEN LET l_img09 = l_ima55 END IF
 
 
      IF l_ima906 = '1' THEN
         LET l_unit2 =''   #0215
         LET l_fac2  =''
         LET l_qty2  =''
      ELSE
         LET l_unit2 = l_ima907
         CALL s_du_umfchk(l_item,'','','',l_img09,l_ima907,l_ima906)
              RETURNING g_errno,l_factor
         LET l_fac2 = l_factor
         LET l_qty2 = 0
      END IF
      LET l_unit1 = l_img09
      LET l_fac1 = 1
      LET l_qty1 = 0
 
      IF p_cmd = 'a' OR (p_cmd='u' AND g_tsc.tsc03!=g_tsc_t.tsc03) THEN
         LET g_tsc.tsc09=l_unit2
         LET g_tsc.tsc10=l_fac2
         LET g_tsc.tsc11=l_qty2
         LET g_tsc.tsc06=l_unit1
         LET g_tsc.tsc07=l_fac1
         LET g_tsc.tsc08=l_qty1
      END IF
END FUNCTION
 
FUNCTION t260_du_default_b(p_cmd)
  DEFINE l_ima35    LIKE ima_file.ima35,
         l_ima36    LIKE ima_file.ima36,
         l_ima63    LIKE ima_file.ima63,
         l_ima906   LIKE ima_file.ima906,
         l_ima907   LIKE ima_file.ima907,
         l_item     LIKE img_file.img01,
         l_ware     LIKE img_file.img02,
         l_loc      LIKE img_file.img03,
         l_lot      LIKE img_file.img04,
         l_img09    LIKE img_file.img09,
         l_unit2    LIKE img_file.img09,
         l_fac2     LIKE tsc_file.tsc10,
         l_qty2     LIKE tsc_file.tsc11,
         l_unit1    LIKE img_file.img09,
         l_fac1     LIKE tsc_file.tsc10,
         l_qty1     LIKE tsc_file.tsc11,
         l_factor   LIKE oeb_file.oeb12,         #No.FUN-680120 DECIMAL(16,8)
         p_cmd      LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
      LET l_item = g_tsd[l_ac].tsd03
      LET l_ware = g_tsd[l_ac].tsd12
      LET l_loc  = g_tsd[l_ac].tsd13
      LET l_lot  = g_tsd[l_ac].tsd14
 
      IF cl_null(g_tsd[l_ac].tsd03) THEN
         RETURN
      END IF
 
      SELECT ima63,ima906,ima907 INTO l_ima63,l_ima906,l_ima907
        FROM ima_file WHERE ima01 = l_item
 
      SELECT img09 INTO l_img09 FROM img_file
       WHERE img01=l_item
         AND img02=l_ware
         AND img03=l_loc
         AND img04=l_lot
      IF cl_null(l_img09) THEN LET l_img09 = l_ima63 END IF
 
      IF l_ima906 = '1' THEN
         LET l_unit2 =''   #0215
         LET l_fac2  =''
         LET l_qty2  =''
      ELSE
         LET l_unit2 = l_ima907
         CALL s_du_umfchk(l_item,'','','',l_img09,l_ima907,l_ima906)
              RETURNING g_errno,l_factor
         LET l_fac2 = l_factor
         LET l_qty2 = 0
      END IF
      LET l_unit1 = l_img09
      LET l_fac1 = 1
      LET l_qty1 = 0
 
      IF p_cmd = 'a' OR (p_cmd='u' AND g_tsd[l_ac].tsd03!=g_tsd_t.tsd03) THEN
         LET g_tsd[l_ac].tsd09=l_unit2
         LET g_tsd[l_ac].tsd10=l_fac2
         LET g_tsd[l_ac].tsd11=l_qty2
         LET g_tsd[l_ac].tsd06=l_unit1
         LET g_tsd[l_ac].tsd07=l_fac1
         LET g_tsd[l_ac].tsd08=l_qty1
      END IF
END FUNCTION
 
FUNCTION t260_set_origin_field_b()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE tsd_file.tsd07,
            l_qty2   LIKE tsd_file.tsd08,
            l_fac1   LIKE tsd_file.tsd10,
            l_qty1   LIKE tsd_file.tsd11,
            l_factor LIKE oeb_file.oeb12       #No.FUN-680120 DECIMAL(16,8)
 
    IF g_sma.sma115='N' THEN RETURN END IF
    LET l_fac2=g_tsd[l_ac].tsd10
    LET l_qty2=g_tsd[l_ac].tsd11
    LET l_fac1=g_tsd[l_ac].tsd07
    LET l_qty1=g_tsd[l_ac].tsd08
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_tsd[l_ac].tsd04=g_tsd[l_ac].tsd06
                   LET g_tsd041=l_fac1
                   LET g_tsd[l_ac].tsd05=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_tsd[l_ac].tsd04=g_img09
                   LET g_tsd041=1
                   LET g_tsd[l_ac].tsd05=l_tot
          WHEN '3' LET g_tsd[l_ac].tsd04=g_tsd[l_ac].tsd06
                   LET g_tsd041=l_fac1
                   LET g_tsd[l_ac].tsd05=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_tsd[l_ac].tsd10=l_qty1/l_qty2
                   ELSE
                      LET g_tsd[l_ac].tsd10=0
                   END IF
       END CASE
    END IF
 
END FUNCTION
 
FUNCTION t260_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE tsc_file.tsc07,
            l_qty2   LIKE tsc_file.tsc08,
            l_fac1   LIKE tsc_file.tsc10,
            l_qty1   LIKE tsc_file.tsc11,
            l_factor LIKE oeb_file.oeb12      #No.FUN-680120 DECIMAL(16,8)
 
    IF g_sma.sma115='N' THEN RETURN END IF
    LET l_fac2=g_tsc.tsc10
    LET l_qty2=g_tsc.tsc11
    LET l_fac1=g_tsc.tsc07
    LET l_qty1=g_tsc.tsc08
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_tsc.tsc04=g_tsc.tsc06
                   LET g_tsc.tsc041=l_fac1
                   LET g_tsc.tsc05=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_tsc.tsc04=g_img09
                   LET g_tsc.tsc041=1
                   LET g_tsc.tsc05=l_tot
          WHEN '3' LET g_tsc.tsc04=g_tsc.tsc06
                   LET g_tsc.tsc041=l_fac1
                   LET g_tsc.tsc05=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_tsc.tsc10=l_qty1/l_qty2
                   ELSE
                      LET g_tsc.tsc10=0
                   END IF
       END CASE
    END IF
 
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t260_du_data_to_correct()
 
   IF cl_null(g_tsc.tsc06) THEN
      LET g_tsc.tsc07 = NULL
      LET g_tsc.tsc08 = NULL
   END IF
 
   IF cl_null(g_tsc.tsc09) THEN
      LET g_tsc.tsc10 = NULL
      LET g_tsc.tsc11 = NULL
   END IF
   DISPLAY BY NAME g_tsc.tsc07
   DISPLAY BY NAME g_tsc.tsc08
   DISPLAY BY NAME g_tsc.tsc10
   DISPLAY BY NAME g_tsc.tsc11
 
END FUNCTION
 
FUNCTION t260_du_data_to_correct_b()
 
   IF cl_null(g_tsd[l_ac].tsd06) THEN
      LET g_tsd[l_ac].tsd07 = NULL
      LET g_tsd[l_ac].tsd08 = NULL
   END IF
 
   IF cl_null(g_tsd[l_ac].tsd09) THEN
      LET g_tsd[l_ac].tsd10 = NULL
      LET g_tsd[l_ac].tsd11 = NULL
   END IF
   DISPLAY BY NAME g_tsd[l_ac].tsd07
   DISPLAY BY NAME g_tsd[l_ac].tsd08
   DISPLAY BY NAME g_tsd[l_ac].tsd10
   DISPLAY BY NAME g_tsd[l_ac].tsd11
 
END FUNCTION
 
FUNCTION t260_pb()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未撤銷的ARRAY CNT #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680120 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680120 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680120 SMALLINT
DEFINE
    l_ima35         LIKE ima_file.ima35,
    l_ima36         LIKE ima_file.ima36,
    l_ima63         LIKE ima_file.ima63,
    l_ima63_fac     LIKE ima_file.ima63_fac,
    l_ima906        LIKE ima_file.ima906,
    l_ima907        LIKE ima_file.ima907,
    l_code          LIKE type_file.num5,             #No.FUN-680120 SMALLINT
    sn1,sn2         LIKE type_file.num5              #No.FUN-680120 SMALLINT
 DEFINE p_pcmd      LIKE type_file.chr1              #No.FUN-680120 VARCHAR(1)
 DEFINE l_re        LIKE type_file.num5              #No.FUN-680120 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_tsc.tsc01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tsc.* FROM tsc_file WHERE tsc01=g_tsc.tsc01
    IF g_tsc.tscacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_tsc.tsc01,'mfg1000',0)
        RETURN
    END IF
    IF g_tsc.tscconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
    LET g_success='Y'
    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT tsd02,tsd03,'','','','',tsd12,tsd13,tsd14,tsd04,",
                       " tsd05,tsd09,tsd10,tsd11,tsd06,tsd07,tsd08,tsd15 ",
                       "   FROM tsd_file ",
                       "   WHERE tsd01=? AND tsd02=?  ",
                       "    FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t260_bclp CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
 
        IF g_rec_b=0 THEN CALL g_tsd.clear() END IF
 
        INPUT ARRAY g_tsd WITHOUT DEFAULTS FROM s_tsd.*
 
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=FALSE,DELETE ROW=FALSE,
                        APPEND ROW=FALSE)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL cl_set_comp_entry("tsd02,tsd03,tsd04,tsd05,tsd06,tsd07,tsd08,tsd09,
                                     tsd10,tsd11,tsd15",FALSE)
            CALL cl_set_comp_entry("tsd12,tsd13,tsd14",TRUE)
 
        BEFORE ROW
            LET p_cmd=""
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN t260_cl USING g_tsc.tsc01
            IF STATUS THEN
               CALL cl_err("OPEN t260_cl:", STATUS, 1)
               CLOSE t260_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t260_cl INTO g_tsc.*            # 鎖住將被更改或撤銷的資料
            IF SQLCA.sqlcode THEN
              CALL cl_err(g_tsc.tsc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t260_cl
              RETURN
            END IF
 
            # 修改狀態時才作備份舊值的動作
            IF g_rec_b >= l_ac THEN
                LET p_cmd="u"
                LET g_tsd_t.* = g_tsd[l_ac].*  #BACKUP
                LET g_tsd_o.* = g_tsd[l_ac].*  #BACKUP
 
                OPEN t260_bclp USING g_tsc.tsc01,g_tsd_t.tsd02
                IF STATUS THEN
                   CALL cl_err("OPEN t260_bclp:", STATUS, 1)
                   CLOSE t260_bclp
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t260_bclp INTO g_tsd[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_tsd_t.tsd02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   SELECT ima02,ima021,ima1002,ima135
                     INTO g_tsd[l_ac].ima02,g_tsd[l_ac].ima021,
                          g_tsd[l_ac].ima1002,g_tsd[l_ac].ima135
                     FROM ima_file
                    WHERE ima01=g_tsd[l_ac].tsd03
                END IF
            END IF
 
        AFTER FIELD tsd12
           IF cl_null(g_tsd[l_ac].tsd12) THEN
              NEXT FIELD tsd12
           END IF
           IF g_tsd[l_ac].tsd12 IS NULL THEN
              LET g_tsd[l_ac].tsd12 = ' '
           END IF
           IF NOT cl_null(g_tsd[l_ac].tsd12) THEN
             # #CHI-D20014 add str 倉庫、庫位控管 还原
             # #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
             # IF NOT s_chksmz(g_tsd[l_ac].tsd03,g_tsc.tsc01,g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13) THEN
             #    NEXT FIELD tsd12
             # END IF
             # #CHI-D20014 add end 还原
              CALL s_stkchk(g_tsd[l_ac].tsd12,'A') RETURNING l_code
              IF NOT l_code THEN
                 CALL cl_err('s_stkchk','mfg1100',0)
                 NEXT FIELD tsd12
              END IF
              CALL s_swyn(g_tsd[l_ac].tsd12) RETURNING sn1,sn2
                  IF sn1=1 AND g_tsd[l_ac].tsd12 != g_tsd_t.tsd12 THEN
                     LET g_tsd_t.tsd12=g_tsd[l_ac].tsd12
                     CALL cl_err(g_tsd[l_ac].tsd12,'mfg6080',0) NEXT FIELD tsd12
                  ELSE
                     IF sn2=2 AND g_tsd[l_ac].tsd12 != g_tsd_t.tsd12 THEN
                        CALL cl_err(g_tsd[l_ac].tsd12,'mfg6085',0)
                        LET g_tsd_t.tsd12=g_tsd[l_ac].tsd12
                        NEXT FIELD tsd12
                     END IF
                  END IF
                  LET sn1=0 LET sn2=0
           END IF
 
        AFTER FIELD tsd13
           IF cl_null(g_tsd[l_ac].tsd13) THEN  #全型空白
              LET g_tsd[l_ac].tsd13 = ' '
           END IF
           IF NOT cl_null(g_tsd[l_ac].tsd13) THEN
             # IF NOT cl_null(g_tsd[l_ac].tsd12) THEN #CHI-D20014 add 还原
              #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
              IF NOT s_chksmz(g_tsd[l_ac].tsd03,g_tsc.tsc01,g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13) THEN
                 NEXT FIELD tsd13
              END IF
             # END IF #CHI-D20014 add 还原
              CALL s_lwyn(g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13)
                   RETURNING sn1,sn2    #可用否
              IF sn2 = 2 THEN
                 IF g_pmn38 = 'Y' THEN CALL cl_err('','mfg9132',0) END IF
              ELSE
                 IF g_pmn38 = 'N' THEN CALL cl_err('','mfg9131',0) END IF
              END IF
              LET sn1=0 LET sn2=0
           END IF
 
        AFTER FIELD tsd14
            IF cl_null(g_tsd[l_ac].tsd14) THEN
               LET g_tsd[l_ac].tsd14 = ' '
            END IF
            IF NOT cl_null(g_tsd[l_ac].tsd03) AND NOT cl_null(g_tsd[l_ac].tsd12) THEN
              SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
               WHERE img01=g_tsd[l_ac].tsd03 AND img02=g_tsd[l_ac].tsd12
                 AND img03=g_tsd[l_ac].tsd13 AND img04=g_tsd[l_ac].tsd14
              IF SQLCA.sqlcode=100 THEN
                 #FUN-C80107 modify begin------------------------------------121024
                 #CALL cl_err3("sel","img_file",g_tsd[l_ac].tsd03,"","mfg9051","","",1) #No.FUN-660104
                 #NEXT FIELD tsd03
                #FUN-D30024--modify--str--
                #INITIALIZE g_sma894 TO NULL
                #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_tsd[l_ac].tsd12) RETURNING g_sma894
                #IF g_sma894 = 'N' OR g_sma894 IS NULL THEN
                 INITIALIZE g_imd23 TO NULL
                 CALL s_inv_shrt_by_warehouse(g_tsd[l_ac].tsd12,g_plant) RETURNING g_imd23   #TQC-D40078 g_plant
                 IF g_imd23 = 'N' THEN
                #FUN-D30024--modify--end--
                    CALL cl_err3("sel","img_file",g_tsd[l_ac].tsd03,"","mfg9051","","",1)
                    NEXT FIELD tsd03
                 ELSE
                    IF NOT cl_confirm('mfg1401') THEN
                       NEXT FIELD tsd03
                    END IF
                    CALL s_add_img(g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,
                                   g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14,
                                   g_tsc.tsc01,'0',g_tsc.tsc21)
                    IF g_errno='N' THEN
                       NEXT FIELD tsd03
                    END IF
                    SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
                     WHERE img01=g_tsd[l_ac].tsd03 AND img02=g_tsd[l_ac].tsd12
                       AND img03=g_tsd[l_ac].tsd13 AND img04=g_tsd[l_ac].tsd14
                 END IF
                 #FUN-C80107 modify end------------------------------------
              END IF
              IF cl_null(g_tsd[l_ac].tsd04) THEN
                 LET g_tsd[l_ac].tsd04=g_img09
              END IF
 
              SELECT COUNT(*) INTO g_cnt FROM img_file
               WHERE img01=g_tsd[l_ac].tsd03
                 AND img02=g_tsd[l_ac].tsd12
                 AND img03=g_tsd[l_ac].tsd13
                 AND img04=g_tsd[l_ac].tsd14
#                AND img18<g_tsc.tsc02             #MOD-AA0167
                 AND img18<g_tsc.tsc21             #MOD-AA0167
             IF g_cnt > 0 THEN
                CALL cl_err('','aim-400',0)
                NEXT FIELD tsd14
             END IF
             IF g_sma.sma115='Y' THEN
                CALL t260_du_default_b(p_cmd)
                #No.FUN-BB0086--add--end--
                LET g_tsd[l_ac].tsd08 = s_digqty(g_tsd[l_ac].tsd08,g_tsd[l_ac].tsd06)
                LET g_tsd[l_ac].tsd11 = s_digqty(g_tsd[l_ac].tsd11,g_tsd[l_ac].tsd09)
                DISPLAY BY NAME g_tsd[l_ac].tsd08,g_tsd[l_ac].tsd11
                #No.FUN-BB0086--add--begin--
             END IF
 
              SELECT *  INTO g_img1.*   #重新取得庫存明細資料
                FROM img_file
               WHERE img01=g_tsd[l_ac].tsd03
                 AND img02=g_tsd[l_ac].tsd12
                 AND img03=g_tsd[l_ac].tsd13
                 AND img04=g_tsd[l_ac].tsd14
           END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tsd[l_ac].* = g_tsd_t.*
               CLOSE t260_bclp
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_tsd[l_ac].tsd02,-263,1)
               LET g_tsd[l_ac].* = g_tsd_t.*
            ELSE
               CALL t260_set_origin_field_b()
               UPDATE tsd_file SET tsd02= g_tsd[l_ac].tsd02,
                                   tsd03= g_tsd[l_ac].tsd03,
                                   tsd04= g_tsd[l_ac].tsd04,
                                   tsd041= g_tsd041,
                                   tsd05= g_tsd[l_ac].tsd05,
                                   tsd06= g_tsd[l_ac].tsd06,
                                   tsd07= g_tsd[l_ac].tsd07,
                                   tsd08= g_tsd[l_ac].tsd08,
                                   tsd09= g_tsd[l_ac].tsd09,
                                   tsd10= g_tsd[l_ac].tsd10,
                                   tsd11= g_tsd[l_ac].tsd11,
                                   tsd12= g_tsd[l_ac].tsd12,
                                   tsd13= g_tsd[l_ac].tsd13,
                                   tsd14= g_tsd[l_ac].tsd14,
                                   tsd15= g_tsd[l_ac].tsd15
               WHERE tsd01=g_tsc.tsc01 AND tsd02=g_tsd_t.tsd02
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","tsd_file",g_tsd[l_ac].tsd02,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
                   LET g_tsd[l_ac].* = g_tsd_t.*
               ELSE
                   IF g_success='Y' THEN
                      COMMIT WORK
                      MESSAGE 'UPDATE O.K'
                   ELSE
                      CALL cl_rbmsg(1)
                      ROLLBACK WORK
                      MESSAGE 'UPDATE FAIL'
                   END IF
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               LET l_re = 1
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
 
               # 當為修改狀態且取消輸入時, 才作回復舊值的動作
               IF p_cmd = 'u' THEN
                  LET g_tsd[l_ac].* = g_tsd_t.*
               END IF
 
               CLOSE t260_bclp
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
               SELECT ima906 INTO g_ima906 FROM ima_file
                WHERE ima01=g_tsd[l_ac].tsd03
 
               IF g_ima906 MATCHES '[23]' THEN
                  SELECT imgg10 INTO g_imgg10_2 FROM imgg_file
                   WHERE imgg01=g_tsd[l_ac].tsd03
                     AND imgg02=g_tsd[l_ac].tsd12
                     AND imgg03=g_tsd[l_ac].tsd13
                     AND imgg04=g_tsd[l_ac].tsd14
                     AND imgg09=g_tsd[l_ac].tsd09
               END IF
               IF g_tsd[l_ac].tsd11 > g_imgg10_2 THEN
                 #IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN  #FUN-C80107 mark
                 #FUN-D30024--modify--str--
                 #INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
                 #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_tsd[l_ac].tsd12) RETURNING g_sma894       #FUN-C80107
                 #IF g_sma894 = 'N' THEN                                                                    #FUN-C80107
                  INITIALIZE g_imd23 TO NULL
                  CALL s_inv_shrt_by_warehouse(g_tsd[l_ac].tsd12,g_plant) RETURNING g_imd23   #TQC-D40078 g_plant
                  IF g_imd23 = 'N' THEN
                 #FUN-D30024--modify--end--
                     CALL cl_err(g_tsd[l_ac].tsd11,'mfg1303',1)
                     NEXT FIELD tsd12
                  ELSE
                     IF NOT cl_confirm('mfg3469') THEN
                        NEXT FIELD tsd12
                     END IF
                  END IF
               END IF
 
 
               IF NOT cl_null(g_tsd[l_ac].tsd06) THEN
                  IF g_ima906 = '2' THEN   #MATCHES '[23]' THEN
                     IF g_tsd[l_ac].tsd08 > g_imgg10_1 THEN
                       #IF g_sma.sma894[1,1] = 'N' OR g_sma.sma894[1,1] IS NULL THEN   #FUN-C80107 mark
                       #FUN-D30024--modify--str--
                       #INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
                       #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_tsd[l_ac].tsd12) RETURNING g_sma894       #FUN-C80107
                       #IF g_sma894 = 'N' THEN                                                                    #FUN-C80107
                        INITIALIZE g_imd23 TO NULL
                        CALL s_inv_shrt_by_warehouse(g_tsd[l_ac].tsd12,g_plant) RETURNING g_imd23   #TQC-D40078 g_plant
                        IF g_imd23 = 'N' THEN
                       #FUN-D30024--modify--end--
                           CALL cl_err(g_tsd[l_ac].tsd08,'mfg1303',1)
                           NEXT FIELD tsd12
                        ELSE
                           IF NOT cl_confirm('mfg3469') THEN
                              NEXT FIELD tsd12
                           END IF
                        END IF
                      END IF
                  ELSE
                     IF g_tsd[l_ac].tsd08*g_tsd[l_ac].tsd07 > g_imgg10_1 THEN
                       #IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN   #FUN-C80107 mark
                       #FUN-D30024--modify--str--
                       #INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
                       #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_tsd[l_ac].tsd12) RETURNING g_sma894       #FUN-C80107
                       #IF g_sma894 = 'N' THEN                                                                    #FUN-C80107
                        INITIALIZE g_imd23 TO NULL
                        CALL s_inv_shrt_by_warehouse(g_tsd[l_ac].tsd12,g_plant) RETURNING g_imd23 #TQC-D40078 g_plant
                        IF g_imd23 = 'N' THEN
                       #FUN-D30024--modify--end--
                           CALL cl_err(g_tsd[l_ac].tsd08,'mfg1303',1)
                           NEXT FIELD tsd12
                        ELSE
                           IF NOT cl_confirm('mfg3469') THEN
                              NEXT FIELD tsd12
                           END IF
                        END IF
                     END IF
                  END IF
               END IF
 
            # 除了修改狀態取消時, 其餘不需要回復舊值或備份舊值
 
            CLOSE t260_bclp
            COMMIT WORK
 
            CALL g_tsd.deleteElement(g_rec_b+1)
 
 
        ON ACTION CONTROLZ
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(tsd12)    #倉庫
                  #FUN-C30300---begin
                  LET g_ima906 = NULL
                  SELECT ima906 INTO g_ima906 FROM ima_file
                   WHERE ima01 = g_tsd[l_ac].tsd03
                  #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                  IF s_industry("icd") THEN  #TQC-C60028
                     CALL q_idc(FALSE,FALSE,g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14)
                     RETURNING g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14
                  ELSE
                  #FUN-C30300---end
                     CALL q_img4(FALSE,FALSE,g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14,'S')
                          RETURNING g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14
                     DISPLAY BY NAME g_tsd[l_ac].tsd12
                  END IF #FUN-C30300
                 NEXT FIELD tsd12
               WHEN INFIELD(tsd13)    #儲位
                  #FUN-C30300---begin
                  LET g_ima906 = NULL
                  SELECT ima906 INTO g_ima906 FROM ima_file
                   WHERE ima01 = g_tsd[l_ac].tsd03
                  #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                  IF s_industry("icd") THEN  #TQC-C60028
                     CALL q_idc(FALSE,FALSE,g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14)
                     RETURNING g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14
                  ELSE
                  #FUN-C30300---end
                     CALL q_img4(FALSE,FALSE,g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14,'S')
                          RETURNING g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14
                  END IF  #FUN-C30300
                 DISPLAY BY NAME g_tsd[l_ac].tsd13
                 NEXT FIELD tsd13
               WHEN INFIELD(tsd14)
                  #FUN-C30300---begin
                  LET g_ima906 = NULL
                  SELECT ima906 INTO g_ima906 FROM ima_file
                   WHERE ima01 = g_tsd[l_ac].tsd03
                  #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                  IF s_industry("icd") THEN  #TQC-C60028
                     CALL q_idc(FALSE,FALSE,g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14)
                     RETURNING g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14
                  ELSE
                  #FUN-C30300---end
                     CALL q_img4(FALSE,FALSE,g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14,'S')
                        RETURNING g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14
                     DISPLAY BY NAME g_tsd[l_ac].tsd14
                  END IF #FUN-C30300
                 NEXT FIELD tsd14
              OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
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
 
        CLOSE t260_bclp
        COMMIT WORK
        RETURN l_re
END FUNCTION
 
FUNCTION t260_ins_sfb(p_tsc01)
   DEFINE p_tsc01     LIKE tsc_file.tsc01
   DEFINE l_tsc       RECORD LIKE tsc_file.*
   DEFINE l_tsd       RECORD LIKE tsd_file.*
   DEFINE l_sfb       RECORD LIKE sfb_file.*
   DEFINE l_sfa       RECORD LIKE sfa_file.*
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_smy69     LIKE smy_file.smy69
   DEFINE l_slip      LIKE smy_file.smyslip
   DEFINE l_flag      LIKE type_file.num5
   DEFINE l_ima25     LIKE ima_file.ima25
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_fac       LIKE ima_file.ima44_fac
   DEFINE l_ima55     LIKE ima_file.ima55
   DEFINE l_ima86     LIKE ima_file.ima86
   DEFINE l_bmb06        LIKE bmb_file.bmb06   #add by zhangzs 210220
   DEFINE l_bmb07        LIKE bmb_file.bmb07   #add by zhangzs 210220
   DEFINE l_bmb09        LIKE bmb_file.bmb09   #add by zhangzs 210220
   DEFINE l_bmb10_fac   LIKE bmb_file.bmb10_fac   #add by zhangzs 210220
   DEFINE l_ima64       LIKE ima_file.ima64    #add by sx210306
   DEFINE l_ima641      LIKE ima_file.ima641   #add by sx210306
 
   SELECT * INTO l_tsc.* FROM tsc_file WHERE tsc01 = p_tsc01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','tsc_file',p_tsc01,'',SQLCA.sqlcode,'','','1')
      RETURN FALSE,NULL
   END IF
 
   LET l_flag = TRUE
   LET l_slip = s_get_doc_no(p_tsc01)
   IF cl_null(l_slip) THEN
      CALL cl_err(p_tsc01,'anm-217',1)
      RETURN FALSE,NULL
   END IF
 
   SELECT smy69 INTO l_smy69 FROM smy_file WHERE smyslip = l_slip
   IF cl_null(l_smy69) THEN
      CALL cl_err(l_slip,'atm-412',1)  #組合/拆解單對應的工單單別為空!
      RETURN FALSE,NULL
   END IF
 
   INITIALIZE l_sfb.* TO NULL
   CALL s_auto_assign_no('asf',l_smy69,l_tsc.tsc02,'1','sfb_file','sfb01','','','')
        RETURNING li_result,l_sfb.sfb01
   IF (NOT li_result) THEN
      CALL cl_err(l_smy69,'asf-377',1)
      RETURN FALSE,NULL
   END IF
   call  cl_progressing(sfmt("正在产生中间下线工单%1",l_sfb.sfb01)) #darcy:2024/07/04
 
   LET l_sfb.sfb93 = 'N'
   LET l_sfb.sfb02 = '1'
   LET l_sfb.sfb04 = '3'  #carrier
   LET l_sfb.sfb05 = l_tsc.tsc03
   LET l_sfb.sfb06 = NULL
   LET l_sfb.sfb07 = NULL
   LET l_sfb.sfb071= l_tsc.tsc02
   SELECT ima55 INTO l_ima55 FROM ima_file
    WHERE ima01 = l_sfb.sfb05
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','ima_file',l_sfb.sfb05,'',SQLCA.sqlcode,'','','1')
      RETURN FALSE,NULL
   END IF
 
   CALL s_umfchk(l_sfb.sfb05,l_tsc.tsc04,l_ima55)
        RETURNING l_cnt,l_fac
   IF l_cnt = 1 THEN
      CALL cl_err(l_sfb.sfb05,'mfg3075','1')
      RETURN FALSE,NULL
   END IF
   IF cl_null(l_fac) OR l_fac = 0 THEN LET l_fac = 1 END IF
   LET l_sfb.sfb08 = l_tsc.tsc05 * l_fac #carrier
   LET l_sfb.sfb081 =0
   LET l_sfb.sfb09  =0
   LET l_sfb.sfb10  =0
   LET l_sfb.sfb11  =0
   LET l_sfb.sfb111 =0
   LET l_sfb.sfb12  =0
   LET l_sfb.sfb121 =0
   LET l_sfb.sfb122 =0
   #LET l_sfb.sfb13  =l_tsc.tsc02   #mark by zhangzs 210113
   #LET l_sfb.sfb15  =l_tsc.tsc02   #mark by zhangzs 210113
   LET l_sfb.sfb13  =l_tsc.tsc21    #add by zhangzs 210113
   LET l_sfb.sfb15  =l_tsc.tsc21    #add by zhangzs 210113
   LET l_sfb.sfb23 ='N'
   LET l_sfb.sfb24 ='N'
   LET l_sfb.sfb29 ='Y'
   LET l_sfb.sfb39 ='1'
   LET l_sfb.sfb41 ='N'
 #  LET l_sfb.sfb81 =l_tsc.tsc02   #mark by zhangzs 210113
   LET l_sfb.sfb81 =l_tsc.tsc21    #add by zhangzs 210113
   LET l_sfb.sfb82 = l_tsc.tsc15     #TQC-C20337 ADD 
   LET l_sfb.sfb87 ='N'
   LET l_sfb.sfb95 =' '   #carrier
   LET l_sfb.sfb98 ='B12' #sx210412
   LET l_sfb.sfb99 ='N'
   LET l_sfb.sfb100='1'
   LET l_sfb.sfbacti='Y'
   LET l_sfb.sfbuser=g_user                
   LET l_sfb.sfbgrup=g_grup               
  # LET l_sfb.sfbdate=g_today  #mark by zhangzs 210113
   LET l_sfb.sfbdate=l_tsc.tsc21    #add by zhangzs 210113
   LET l_sfb.sfbmksg = 'N'
   LET l_sfb.sfbplant = g_plant
   LEt l_sfb.sfblegal = g_legal #FUN-980009
   LET l_sfb.sfboriu = g_user      #No.FUN-980030 10/01/04    
   LET l_sfb.sfborig = g_grup      #No.FUN-980030 10/01/04     
   LET l_sfb.sfb104 = ' '          #TQC-A50087 add
   LET l_sfb.sfb44 = l_tsc.tsc16   #MOD-B30253 add
   INSERT INTO sfb_file VALUES(l_sfb.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3('ins','sfb_file',l_sfb.sfb01,'',SQLCA.sqlcode,'','','1')
      RETURN FALSE,NULL
   END IF
 #mark by zhangzs 210220 -----s-----
 #  DECLARE t260_ins_sfa_cur CURSOR FOR
   #SELECT * FROM tsd_file WHERE tsd01 = p_tsc01 #MOD-C90144 mark
   #MOD-C90144 add --start--
 #   SELECT tsd03,tsd04,SUM(tsd05)
 #     INTO l_tsd.tsd03,l_tsd.tsd04,l_tsd.tsd05
 #     FROM tsd_file WHERE tsd01 = p_tsc01
 #    GROUP BY tsd03,tsd04
 #mark by zhangzs 210220 -----e-----
 #add by zhangzs 210220   -----s-----
 DECLARE t260_ins_sfa_cur CURSOR FOR
     SELECT bmb03,bmb10,bmb06,bmb07,bmb09,bmb10_fac      #元件料号，单位，组成用量，主件底数
       INTO l_tsd.tsd03,l_tsd.tsd04,l_bmb06,l_bmb07,l_bmb09,l_bmb10_fac
       FROM bmb_file WHERE bmb01 = l_tsc.tsc03 AND bmb05 IS NULL 
      ORDER BY bmb03
 LET l_tsd.tsd05 = l_tsc.tsc05 * (l_bmb06 / l_bmb07)   #数量
 #add by zhangzs 210220   -----e-----
   #MOD-C90144 add --end--
   IF SQLCA.sqlcode THEN
      CALL cl_err('t260_ins_sfa_cur',SQLCA.sqlcode,1)
      RETURN FALSE,NULL
   END IF
  #FOREACH t260_ins_sfa_cur INTO l_tsd.*                             #MOD-C90144 mark
   FOREACH t260_ins_sfa_cur INTO l_tsd.tsd03,l_tsd.tsd04,l_bmb06,l_bmb07,l_bmb09,l_bmb10_fac #MOD-C90144
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach t260_ins_sfa_cur',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      INITIALIZE l_sfa.* TO NULL
 
      LET l_sfa.sfa01  = l_sfb.sfb01             #工單編號
      LET l_sfa.sfa02  = l_sfb.sfb02             #工單型態
      LET l_sfa.sfa03  = l_tsd.tsd03             #料件編號
      SELECT ima25,ima86 INTO l_ima25,l_ima86
        FROM ima_file WHERE ima01 = l_sfa.sfa03
      IF SQLCA.sqlcode THEN
         CALL cl_err('sel ima:' || l_sfa.sfa03,SQLCA.sqlcode,1)
         RETURN FALSE,NULL
      END IF
      LET l_sfa.sfa04  = 0                       #原發數量
      LET l_sfa.sfa05  = l_bmb06*g_tsc.tsc05     #應發數量  #carrier 用量*生产数量*转换率
      LET l_sfa.sfa06  =  0                      #已發數量
      LET l_sfa.sfa061 =  0                      #已領數量
      LET l_sfa.sfa062 =  0                      #超領數量
      LET l_sfa.sfa063 =  0                      #報廢數量
      LET l_sfa.sfa064 =  0                      #盤損數量
      LET l_sfa.sfa065 =  0                      #委外代買量
      LET l_sfa.sfa066 =  0                      #委外代買已交量
      LET l_sfa.sfa07  =  0                      #欠料數量
      LET l_sfa.sfa08  =  l_bmb09                #作業編號
      LET l_sfa.sfa09  =  0                      #前置時間調整
      LET l_sfa.sfa10  =  0                      #前置時間調整
      LET l_sfa.sfa11  =  'N'                    #旗標
      LET l_sfa.sfa12  = l_tsd.tsd04             #發料單位  #carrier
      CALL s_umfchk(l_sfa.sfa03,l_sfa.sfa12,l_ima25)
           RETURNING l_cnt,l_fac
      IF l_cnt = 1 THEN
         CALL cl_err(l_sfa.sfa03,'mfg3075','1')
         RETURN FALSE,NULL
      END IF
      LET l_sfa.sfa13  =  l_fac                  #發料單位/庫存單位換算率
      # LET l_sfa.sfa14  =  l_tsd.tsd04            #成本單位  #carrier  #mark by darcy 2022年3月10日
      LET l_sfa.sfa14  =  l_ima86            #成本單位  #carrier  #add by darcy 2022年3月10日
 
      CALL s_umfchk(l_sfa.sfa03,l_sfa.sfa12,l_ima86) #mod  by  darcy 220311 sfa14 ==> sfa12
           RETURNING l_cnt,l_fac
      IF l_cnt = 1 THEN
         CALL cl_err(l_sfa.sfa03,'mfg3075','1')
         RETURN FALSE,NULL
      END IF
      LET l_sfa.sfa15  =  l_fac                  #成本單位/材料成本檔成本單位之換算率  #carrier
      LET l_sfa.sfa16  =  l_sfa.sfa05/l_sfb.sfb08#標準單位用量
      LET l_sfa.sfa161 =  l_sfa.sfa05/l_sfb.sfb08#實際單位用量 (Actual QPA)
      LET l_sfa.sfa25  =  0                      #未備料量
      LET l_sfa.sfa26  =  0                      #替代碼
      LET l_sfa.sfa27  =  l_tsd.tsd03            #被替代料號
      LET l_sfa.sfa28  =  1                      #替代率
      LET l_sfa.sfa29  =  l_sfb.sfb05            #上階料號
     #LET l_sfa.sfa30  =  l_tsd.tsd12            #指定倉庫 #MOD-C90144 mark
     #LET l_sfa.sfa31  =  l_tsd.tsd13            #指定儲位 #MOD-C90144 mark
      LET l_sfa.sfa30  =  ''                     #指定倉庫 #MOD-C90144 
      LET l_sfa.sfa31  =  ''                     #指定儲位 #MOD-C90144
      LET l_sfa.sfa100 =  0.0001                 #發料誤差允許率
      LET l_sfa.sfaacti=  'Y'                    #資料有效碼
      LET l_sfa.sfa32  =  'N'                    #代買料否
      LET l_sfa.sfaplant = g_plant
      LET l_sfa.sfalegal = g_legal #FUN-980009
      LET l_sfa.sfa012 = ' '       #MOD-A60197 add
      LET l_sfa.sfa013 = 0         #MOD-A60197 add
      
      SELECT ima64,ima641 INTO l_ima64,l_ima641 FROM ima_file     #add by sx210306---s
         WHERE ima01=l_sfa.sfa03    
      IF STATUS THEN LET l_ima64 = 0 LET l_ima641 = 0 END IF
      IF l_sfa.sfa05 >= l_ima641 THEN         #应发数大于等于最小发料量才插入到工单 
         LET l_sfa.sfa05 = s_digqty(l_sfa.sfa05,l_sfa.sfa12)     #发料数量四舍五入
         INSERT INTO sfa_file VALUES(l_sfa.*)
      END IF
      
      IF SQLCA.sqlcode THEN
         CALL cl_err3('ins','sfa_file',l_sfa.sfa01,l_sfa.sfa03,SQLCA.sqlcode,'','','1')
         RETURN FALSE,NULL
      END IF
   END FOREACH
   UPDATE tsc_file SET tsc19 = l_sfb.sfb01 WHERE tsc01 = g_tsc.tsc01   #add by zhangzs 210113
   RETURN TRUE,l_sfb.sfb01
 
END FUNCTION
 
 
FUNCTION t260_ins_sfp(p_tsc01,p_sfb01)    #产生新工单的发料单
   DEFINE p_tsc01     LIKE tsc_file.tsc01
   DEFINE p_sfb01     LIKE sfb_file.sfb01
   DEFINE l_tsc       RECORD LIKE tsc_file.*
   DEFINE l_sfb       RECORD LIKE sfb_file.*
   DEFINE l_sfa       RECORD LIKE sfa_file.*
   DEFINE l_sfp       RECORD LIKE sfp_file.*
   DEFINE l_sfq       RECORD LIKE sfq_file.*
   DEFINE l_sfs       RECORD LIKE sfs_file.*
   DEFINE l_sfsi      RECORD LIKE sfsi_file.*  #FUN-B70074
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_smy70     LIKE smy_file.smy70
   DEFINE l_slip      LIKE smy_file.smyslip
   DEFINE l_flag      LIKE type_file.num5
   DEFINE l_ima25     LIKE ima_file.ima25
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_fac       LIKE ima_file.ima44_fac
   DEFINE l_gfe03     LIKE gfe_file.gfe03
   DEFINE l_ima906    LIKE ima_file.ima906
   DEFINE l_qty       LIKE sfa_file.sfa06
   DEFINE l_tsd       RECORD LIKE tsd_file.*
   DEFINE l_rvbs      RECORD LIKE rvbs_file.*   #No.CHI-A70051
   DEFINE l_sfp01     LIKE sfp_file.sfp01      #add by sx210312 原工单下线工序前的退料，跟新工单的领料单料号和数量一样，只是工单号不一样，发料类型不一样，单别不一样
   DEFINE l_sfp06     LIKE sfp_file.sfp06      #add by sx210312 发料类型
   DEFINE l_sfs03     LIKE sfs_file.sfs03      #add by sx210312 工单号
   DEFINE l_sfp01_t   LIKE sfp_file.sfp01      #领料单号备份
   DEFINE l_shb05     LIKE shb_file.shb05      #原工单单号
   DEFINE l_cnt1      LIKE type_file.num5
 
   SELECT * INTO l_tsc.* FROM tsc_file WHERE tsc01 = p_tsc01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','tsc_file',p_tsc01,'',SQLCA.sqlcode,'','','1')
      RETURN FALSE,NULL
   END IF
 
   SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01 = p_sfb01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','sfb_file',p_sfb01,'',SQLCA.sqlcode,'','','1')
      RETURN FALSE,NULL
   END IF
 
   LET l_slip = s_get_doc_no(p_tsc01)
   IF cl_null(l_slip) THEN
      CALL cl_err(p_tsc01,'anm-217',1)  #單別不可空白,請重新輸入..!
      RETURN FALSE,NULL
   END IF
 
   SELECT smy70 INTO l_smy70 FROM smy_file WHERE smyslip = l_slip
   IF cl_null(l_smy70) THEN
      CALL cl_err(l_slip,'atm-413',1)   #組合/拆解單對應的工單發料單別為空!
      RETURN FALSE,NULL
   END IF
 
   INITIALIZE l_sfp.* TO NULL
 
   CALL s_auto_assign_no('asf',l_smy70,g_today,'3','sfp_file','sfp01','','','')
        RETURNING li_result,l_sfp.sfp01
   IF (NOT li_result) THEN
      CALL cl_err(l_smy70,'asf-377',1)
      RETURN FALSE,NULL
   END IF
   call  cl_progressing(sfmt("正在产生中间下线工单的发料单%1",l_sfp.sfp01)) #darcy:2024/07/04
   #LET l_sfp.sfp02  =g_today   #mark by zhangzs 210113
   LET l_sfp.sfp02  =l_tsc.tsc21  #add by zhangzs 210113
  #LET l_sfp.sfp03  =g_today         #MOD-C10050 Mark
  # LET l_sfp.sfp03  =l_tsc.tsc02     #MOD-C10050 Add  #mark by zhangzs 210113
   LET l_sfp.sfp03  =l_tsc.tsc21     #MOD-C10050 Add   #add by zhangzs 210113
   LET l_sfp.sfp04  ='N'
   LET l_sfp.sfp05  ='N'
   LET l_sfp.sfp06  ='1'
   LET l_sfp.sfp09  ='N'
   LET l_sfp.sfp13  ='N'
   LET l_sfp.sfpconf = 'N' #FUN-920054
   LET l_sfp.sfpuser=g_user         
   LET l_sfp.sfpgrup=g_grup        
  # LET l_sfp.sfpdate=g_today          #mark by zhangzs 210113
   LET l_sfp.sfpdate=l_tsc.tsc21      #add by zhangzs 210113
   LET l_sfp.sfpplant = g_plant
   LET l_sfp.sfplegal = g_legal #FUN-980009
   LET l_sfp.sfporiu = g_user      #No.FUN-980030 10/01/04  
   LET l_sfp.sfporig = g_grup      #No.FUN-980030 10/01/04   
   #FUN-AB0001--add---str---
   LET l_sfp.sfpmksg = g_smy.smyapr #是否簽核
   LET l_sfp.sfp15 = '0'            #簽核狀況
#  LET l_sfp.sfp16 = g_user         #申請人     #TQC-C20337 MARK
   LET l_sfp.sfp16 = l_tsc.tsc16    #TQC-C20337
   LET l_sfp.sfp07 = l_tsc.tsc15    #TQC-C20337
   #FUN-AB0001--add---end---
 
   #TQC-B60227-add-str--
   IF cl_null(l_sfp.sfpmksg) THEN 
      LET l_sfp.sfpmksg='N'
   END IF
   #TQC-B60227-add-end--
   
   INSERT INTO sfp_file VALUES(l_sfp.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3('ins','sfp_file',l_sfp.sfp01,'',SQLCA.sqlcode,'','','1')
      RETURN FALSE,NULL
   END IF
   
   CALL s_auto_assign_no('asf','MRH',g_today,'4','sfp_file','sfp01','','','')  #add by sx210312---s 原工单下线工序前的退料
        RETURNING li_result,l_sfp01
   IF (NOT li_result) THEN
      CALL cl_err('MRH','asf-377',1)
      RETURN FALSE,NULL
   END IF
   #darcy:2024/07/04 add s---
   call cl_progressing(sfmt("按照下线BOM产生一般退料-%1",l_sfp01))
   update tsc_file set tscud05 = l_sfp01 where tsc01 = p_tsc01
   #darcy:2024/07/04 add e---
   LET l_sfp01_t = l_sfp.sfp01  #领料单号备份
   LET l_sfp.sfp01 = l_sfp01    #退料单号
   LET l_sfp.sfp06 = '8'        #类型
   INSERT INTO sfp_file VALUES(l_sfp.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3('ins','sfp_file',l_sfp.sfp01,'',SQLCA.sqlcode,'','','1')
      RETURN FALSE,NULL
   END IF
   LET l_sfp.sfp01 = l_sfp01_t  #领料单号还原                                  #add by sx210312---e
  
   INITIALIZE l_sfq.* TO NULL
   LET l_sfq.sfq01 = l_sfp.sfp01
   LET l_sfq.sfq02 = l_sfb.sfb01
   LET l_sfq.sfq03 = l_sfb.sfb08
   LET l_sfq.sfq04 = ' '
  # LET l_sfq.sfq05 = g_today     #mark by zhangzs 210113
   LET l_sfq.sfq05 = l_tsc.tsc21    #add by zhangzs 210113
   LET l_sfq.sfq06 = 0
   LET l_sfq.sfq07 = ' '
   LET l_sfq.sfqplant = g_plant
   LET l_sfq.sfqlegal = g_legal #FUN-980009
   LET l_sfq.sfq012 = ' '       #FUN-B20095
   LET l_sfq.sfq014 = ' '       #FUN-C70014 add
   INSERT INTO sfq_file VALUES (l_sfq.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3('ins','sfq_file',l_sfq.sfq01,l_sfq.sfq02,SQLCA.sqlcode,'','','1')
      RETURN FALSE,NULL
   END IF

   #darcy:2024/07/04 mark s---
   #darcy:2023/12/21 add s---
   # 将退料单更新到tscud04
   # update tsc_file set tscud04 = l_sfq.sfq01
   #  where tsc01 = p_tsc01
   # if sqlca.sqlcode then
   #    call cl_err3('upd','tsc_file',l_sfq.sfq01,l_sfq.sfq02,sqlca.sqlcode,'','','1')
   #    return false,null
   # end if
   #darcy:2023/12/21 add e---
   #darcy:2024/07/04 mark e---
 
   DECLARE t260_ins_sfs_cur CURSOR FOR
    SELECT * FROM sfa_file
     WHERE sfa01 = l_sfb.sfb01
       AND sfa05 > sfa06
       AND (sfa11 <> 'E' OR sfa11 IS NULL)
    ORDER BY sfa27,sfa03
   FOREACH t260_ins_sfs_cur INTO l_sfa.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach t260_ins_sfs_cur',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      INITIALIZE l_sfs.* TO NULL

     #MOD-C90144 add --start--
      {DECLARE t260_tsd_cur CURSOR FOR   #mark by sx210223  产生的新工单不根据atmt260单身产生，根据260单头料号的BOM产生
       SELECT * FROM tsd_file
        WHERE tsd01 = p_tsc01
          AND tsd03 = l_sfa.sfa03
          AND tsd04 = l_sfa.sfa12
      FOREACH t260_tsd_cur INTO l_tsd.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach t260_tsd_cur',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF}
     #MOD-C90144 add --end--
 
         LET l_gfe03 = NULL
         LET l_ima906 = NULL
    
         #取料件單位使用方式(ima906),料件狀態(imaicd04)
         SELECT ima906 INTO l_ima906
           FROM ima_file
          WHERE ima01 = l_sfa.sfa03
    
         #取料單位小數位數
         SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01=l_sfa.sfa12
         IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03=0 END IF
    
         LET l_sfa.sfa05 = l_sfa.sfa05 - l_sfa.sfa065
    
         LET l_sfs.sfs01=l_sfp.sfp01
         SELECT MAX(sfs02) +1 INTO l_sfs.sfs02 FROM sfs_file
          WHERE sfs01 = l_sfs.sfs01
         IF cl_null(l_sfs.sfs02) OR l_sfs.sfs02 = 0 THEN
            LET l_sfs.sfs02 = 1
         END IF
         LET l_sfs.sfs03=l_sfb.sfb01
         LET l_sfs.sfs04=l_sfa.sfa03
        #LET l_qty = (l_sfa.sfa05 - l_sfa.sfa06)   #MOD-C90144 mark
        #LET l_sfs.sfs05=l_qty           #發料數量 #MOD-C90144 mark
        # LET l_sfs.sfs05=l_tsd.tsd05     #發料數量 #MOD-C90144  #mark by zhangzs 210220
         LET l_sfs.sfs05=l_sfa.sfa05     #add by zhangzs 210220
         LET l_sfs.sfs06=l_sfa.sfa12     #發料單位
        #LET l_sfs.sfs07=l_sfa.sfa30     #MOD-C90144 mark
        #LET l_sfs.sfs08=l_sfa.sfa31     #MOD-C90144 mark
         #SELECT ima35,ima36 INTO l_sfs.sfs07,l_sfs.sfs08 FROM ima_file WHERE ima01 = l_sfa.sfa03   #add by zhanzgs 210220  #mark by sx219223
         #LET l_sfs.sfs07=l_tsd.tsd12     #MOD-C90144   #mark by zhangzs 210220
         #LET l_sfs.sfs08=l_tsd.tsd13     #MOD-C90144   #mark by zhangzs 210220
         #LET l_sfs.sfs09=' '   #mark by zhangzs 210113
         #LET l_sfs.sfs09=l_tsd.tsd14   #add by zhangzs 210113   #mark by zhangzs 210220
         SELECT img02,img03,img04 INTO l_sfs.sfs07,l_sfs.sfs08,l_sfs.sfs09 FROM 
            (SELECT img02,img03,img04 FROM img_file LEFT JOIN ima_file ON ima01=img01 WHERE img23 = 'Y' AND img01 = l_sfs.sfs04  AND img10 >= (l_sfs.sfs05*ima63_fac) 
             AND img18 >= g_today AND img02 = 'XBC' ORDER BY img18) 
               WHERE rownum = 1  #add by zhangzs 210220
        #MOD-C90144 mark --start--
        #SELECT * INTO l_tsd.* FROM tsd_file
        # WHERE tsd01 = p_tsc01
        #   AND tsd03 = l_sfs.sfs04
        #   AND tsd12 = l_sfa.sfa30
        #   AND tsd13 = l_sfa.sfa31
        #MOD-C90144 mark --end--
         #LET l_sfs.sfs09 = l_tsd.tsd14  #mark by zhangzs 210220
        #MOD-C90144 mark --start--
        #IF SQLCA.sqlcode THEN
        #   CALL cl_err3('sel','tsd_file',l_tsc.tsc01,l_sfa.sfa03,SQLCA.sqlcode,'','','1')
        #   RETURN FALSE,NULL
        #END IF
        #MOD-C90144 mark --end--
         IF l_sfs.sfs07 IS NULL THEN LET l_sfs.sfs07 = 'XBC' END IF    #add XBC by sx210316
         IF l_sfs.sfs08 IS NULL THEN LET l_sfs.sfs08 = 'DDDZ' END IF   #add DDDZ by sx210316
         IF l_sfs.sfs09 IS NULL THEN LET l_sfs.sfs09 = ' ' END IF
    
         LET l_sfs.sfs10=l_sfa.sfa08
        #IF l_sfa.sfa26 MATCHES '[SUT]' THEN   #FUN-A20037
         IF l_sfa.sfa26 MATCHES '[SUTZ]' THEN  #FUN-A20037
            LET l_sfs.sfs26=l_sfa.sfa26
            LET l_sfs.sfs27=l_sfa.sfa27
            LET l_sfs.sfs28=l_sfa.sfa28
         ELSE
            LET l_sfs.sfs27=l_sfa.sfa27
            LET l_sfs.sfs28=l_sfa.sfa28
         END IF
         LET l_sfs.sfs30 = NULL
         LET l_sfs.sfs31 = NULL
         LET l_sfs.sfs32 = NULL
         LET l_sfs.sfs33 = NULL
         LET l_sfs.sfs34 = NULL
         LET l_sfs.sfs35 = NULL
    
         #處理雙單位
         IF g_sma.sma115 = 'Y' THEN
           #mark by zhangzs 210220 ----s----
           # LET l_sfs.sfs30 = l_tsd.tsd06
           # LET l_sfs.sfs31 = l_tsd.tsd07
           # LET l_sfs.sfs32 = l_tsd.tsd08
           #mark by zhangzs 210220 ----e----
           #add by zhangzs 210220 ----s----
            LET l_sfs.sfs30 = l_sfa.sfa12
            LET l_sfs.sfs31 = l_sfa.sfa12
            LET l_sfs.sfs32 = l_sfa.sfa12
           #add by zhangzs 210220 ----e----
            IF l_ima906 = '1' THEN  #不使用雙單位
               LET l_sfs.sfs33 = NULL
               LET l_sfs.sfs34 = NULL
               LET l_sfs.sfs35 = NULL
            ELSE
              #mark by zhangzs 210220 ----s----
              # LET l_sfs.sfs33 = l_tsd.tsd09
              # LET l_sfs.sfs34 = l_tsd.tsd10
              # LET l_sfs.sfs35 = l_tsd.tsd11
              #mark by zhangzs 210220 ----e----
               #add by zhangzs 210220 ----s----
               LET l_sfs.sfs33 = l_sfa.sfa12
               LET l_sfs.sfs34 = l_sfa.sfa12
               LET l_sfs.sfs35 = l_sfa.sfa12
               #add by zhangzs 210220 ----e----
            END IF
         END IF
         LET l_sfs.sfs930 = ' '
         LET l_sfs.sfsplant  = g_plant
         LET l_sfs.sfslegal = g_legal #FUN-980009
         LET l_sfs.sfs012 = ' ' #FUN-A60027 add  #No.CHI-A70051
         LET l_sfs.sfs013 = 0 #FUN-A60027 add
         LET l_sfs.sfs014 = ' '  #FUN-C70014 add
         
         #FUN-CB0087---add---str---
         IF g_aza.aza115 = 'Y' THEN
            CALL s_reason_code(l_sfs.sfs01,l_sfs.sfs03,'',l_sfs.sfs04,l_sfs.sfs07,l_sfp.sfp16,l_sfp.sfp07) RETURNING l_sfs.sfs37
            IF cl_null(l_sfs.sfs37) THEN
               CALL cl_err('','aim-425',1)
               RETURN FALSE,NULL
            END IF
         END IF
         #FUN-CB0087---add---end--
         INSERT INTO sfs_file VALUES(l_sfs.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3('ins','sfs_file',l_sfs.sfs01,l_sfs.sfs04,SQLCA.sqlcode,'','','1')
            RETURN FALSE,NULL
      #FUN-B70074 ---------------Begin----------------
         ELSE
            IF NOT s_industry('std') THEN
               INITIALIZE l_sfsi.* TO NULL
               LET l_sfsi.sfsi01 = l_sfs.sfs01
               LET l_sfsi.sfsi02 = l_sfs.sfs02
               IF NOT s_ins_sfsi(l_sfsi.*,l_sfs.sfsplant) THEN
                  RETURN FALSE,NULL
               END IF            
            END IF
      #FUN-B70074 ---------------End------------------
         END IF
         SELECT shb05 INTO l_shb05 FROM shb_file WHERE shb01 = g_tsc.tscud02 #查原来工单号 add by sx210312---s
         #mark by liy211217 s#挪下去
         #INSERT INTO img_file(img01,img02,img03,img04,img09,img10,img14,img18,img20,img21,img22,img23,img24,img25,img30,img31,img32,img33,img34,img37,imgplant,imglegal) #img 可能没有，需要增加
         #   VALUES (l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,l_sfs.sfs09,l_sfs.sfs06,'0',g_today,g_today,'1','1','W','Y','Y','N','0','0','0','0','0',g_today,g_plant,g_plant)
         #UPDATE img_file SET img18=g_today WHERE img01=l_sfs.sfs04 AND img02=l_sfs.sfs07 AND img03=l_sfs.sfs08 AND img04=l_sfs.sfs09 AND img18 < g_today
         #mark by liy211217 s#挪下去
         LET l_sfs.sfs01 = l_sfp01   #退料单号
         LET l_sfs.sfs03 = l_shb05   #原来工单 
         
         SELECT sfa05,sfa06,sfa26,sfa27 INTO l_sfa.sfa05,l_sfa.sfa06,l_sfa.sfa26,l_sfs.sfs27 FROM sfa_file WHERE sfa01=l_shb05 AND sfa03=l_sfs.sfs04  #mark by liy211217
 #原工单的�发/已发/替代料号
            and sfa08 = l_sfs.sfs10  #add:darcy:2022/04/29 增加作业编号
         #SELECT sfa05,sfa06,sfa26,sfa03 INTO l_sfa.sfa05,l_sfa.sfa06,l_sfa.sfa26,l_sfs.sfs04 FROM sfa_file WHERE sfa01 =l_shb05 AND sfa27 =l_sfs.sfs04  AND sfa05<>0#add by liy211217
         
         IF l_sfa.sfa05=0 AND l_sfa.sfa06=0 AND l_sfa.sfa26 = 0 THEN #add sfa26 by liy211217 
         
         ELSE
            INSERT INTO sfs_file VALUES(l_sfs.*)
         END IF
         IF SQLCA.sqlcode THEN
            CALL cl_err3('ins','sfs_file',l_sfs.sfs01,l_sfs.sfs04,SQLCA.sqlcode,'','','1')
            RETURN FALSE,NULL
         END IF       
         LET l_sfs.sfs01 = l_sfp.sfp01
         #add by sx210312---e
         #add by liy211217 s#挪下去
         INSERT INTO img_file(img01,img02,img03,img04,img09,img10,img14,img18,img20,img21,img22,img23,img24,img25,img30,img31,img32,img33,img34,img37,imgplant,imglegal) #img 可能没有，需要增加
            VALUES (l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,l_sfs.sfs09,l_sfs.sfs06,'0',g_today,g_today,'1','1','W','Y','Y','N','0','0','0','0','0',g_today,g_plant,g_plant)
         UPDATE img_file SET img18=g_today WHERE img01=l_sfs.sfs04 AND img02=l_sfs.sfs07 AND img03=l_sfs.sfs08 AND img04=l_sfs.sfs09 AND img18 < g_today
         #add by liy211217 s#挪下去
         #No.CHI-A70051  --Begin
         #组合单�身批序号生成工单发料批序号资料
         DECLARE t260_rvbs_cs1 CURSOR FOR
          SELECT * FROM rvbs_file
           WHERE rvbs00 = 'atmt260' 
             AND rvbs01 = l_tsd.tsd01
             AND rvbs02 = l_tsd.tsd02
         FOREACH t260_rvbs_cs1 INTO l_rvbs.*
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach t260_rvbs_cs1',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            LET l_rvbs.rvbs00 = 'asfi511'   #成套发料 sfp06 = '1'
            LET l_rvbs.rvbs01 = l_sfs.sfs01
            INSERT INTO rvbs_file VALUES (l_rvbs.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3('ins','rvbs_file','asfi511',l_sfs.sfs01,SQLCA.sqlcode,'','','1')
               RETURN FALSE,NULL
            END IF 
         END FOREACH
         #No.CHI-A70051  --End  

      #END FOREACH #MOD-C90144 add   #mark by sx210223
 
   END FOREACH
 
   RETURN TRUE,l_sfp.sfp01,l_sfp01     #add l_sfp01  by sx210312 原工单退料单
 
END FUNCTION
 
FUNCTION t260_ins_sfu(p_tsc01,p_sfb01,p_sfp01)
   DEFINE p_tsc01     LIKE tsc_file.tsc01
   DEFINE p_sfb01     LIKE sfb_file.sfb01
   DEFINE p_sfp01     LIKE sfp_file.sfp01
   DEFINE l_tsc       RECORD LIKE tsc_file.*
   DEFINE l_sfb       RECORD LIKE sfb_file.*
   DEFINE l_sfp       RECORD LIKE sfp_file.*
   DEFINE l_sfu       RECORD LIKE sfu_file.*
   DEFINE l_sfv       RECORD LIKE sfv_file.*
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_smy71     LIKE smy_file.smy71
   DEFINE l_slip      LIKE smy_file.smyslip
   DEFINE l_flag      LIKE type_file.num5
   DEFINE l_ima25     LIKE ima_file.ima25
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_fac       LIKE ima_file.ima44_fac
   DEFINE l_ima906    LIKE ima_file.ima906
   DEFINE l_tsd       RECORD LIKE tsd_file.*
   DEFINE l_ima55     LIKE ima_file.ima55
   DEFINE l_rvbs      RECORD LIKE rvbs_file.*   #No.CHI-A70051
   DEFINE l_sfvi      RECORD LIKE sfvi_file.*      #No.FUN-B70074
 
   SELECT * INTO l_tsc.* FROM tsc_file WHERE tsc01 = p_tsc01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','tsc_file',p_tsc01,'',SQLCA.sqlcode,'','','1')
      RETURN FALSE,NULL
   END IF
 
   SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01 = p_sfb01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','sfb_file',p_sfb01,'',SQLCA.sqlcode,'','','1')
      RETURN FALSE,NULL
   END IF
 
   SELECT * INTO l_sfp.* FROM sfp_file WHERE sfp01 = p_sfp01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','sfp_file',p_sfp01,'',SQLCA.sqlcode,'','','1')
      RETURN FALSE,NULL
   END IF
 
   LET l_slip = s_get_doc_no(p_tsc01)
   IF cl_null(l_slip) THEN
      CALL cl_err(p_tsc01,'anm-217',1)  #單別不可空白,請重新輸入..!
      RETURN FALSE,NULL
   END IF
 
   SELECT smy71 INTO l_smy71 FROM smy_file WHERE smyslip = l_slip
   IF cl_null(l_smy71) THEN
      CALL cl_err(l_slip,'atm-414',1)  #組合/拆解單對應的工單完工單別為空!
      RETURN FALSE,NULL
   END IF
   #FUN-A80128---add----str---
   CALL s_check_no("asf",l_smy71,'',"A","sfu_file","sfu01","") #FUN-A80128 add
                     RETURNING li_result,l_sfu.sfu01
   IF (NOT li_result) THEN
      RETURN FALSE,NULL
   END IF
   #FUN-A80128---add----end---
 
   INITIALIZE l_sfu.* TO NULL
   
   CALL s_auto_assign_no('asf',l_smy71,g_today,'A','sfu_file','sfu01','','','')  ##carrier check type
        RETURNING li_result,l_sfu.sfu01
   IF (NOT li_result) THEN
      CALL cl_err(l_smy71,'asf-377',1)
      RETURN FALSE,NULL
   END IF
   call  cl_progressing(sfmt("正在产生中间下线工单入库单的%1",l_sfu.sfu01)) #darcy:2024/07/04
   LET l_sfu.sfu00   = '1'             #類別
  #LET l_sfu.sfu02   = g_today         #MOD-C10050 Mark
  # LET l_sfu.sfu02   = l_tsc.tsc02     #MOD-C10050 Add  #mark by zhangzs 210113
   LET l_sfu.sfu02   = l_tsc.tsc21     #MOD-C10050 Add  #add by zhangzs 210113
   LET l_sfu.sfu03   = NULL            #No Use
#  LET l_sfu.sfu04   = g_grup          #部門     #TQC-C20337 mark
   LET l_sfu.sfu04   = l_tsc.tsc15     #TQC-C20337
   LET l_sfu.sfu05   = NULL            #理由
   LET l_sfu.sfu06   = l_sfb.sfb27     #專案編號
   LET l_sfu.sfu07   = NULL            #備註
   LET l_sfu.sfu08   = NULL            #PBI No.
   LET l_sfu.sfu09   = NULL            #耗材單號
   LET l_sfu.sfu10   = NULL            #No Use
   LET l_sfu.sfu11   = NULL            #No Use
   LET l_sfu.sfu12   = NULL            #No Use
   LET l_sfu.sfu13   = NULL            #No Use
   LET l_sfu.sfupost = 'N'             #過帳否
   LET l_sfu.sfuuser = g_user          #資料所有者             
   LET l_sfu.sfugrup = g_grup          #資料所有部門          
   LET l_sfu.sfumodu = NULL            #資料修改者
  # LET l_sfu.sfudate = g_today         #最近修改日   #mark by zhangzs 210113
   LET l_sfu.sfudate = l_tsc.tsc21         #最近修改日  #add by zhangzs 210113
   LET l_sfu.sfuconf = 'N'             #確認碼
 #  LET l_sfu.sfu14   = g_today         #輸入日期   #mark by zhangzs 210113
   LET l_sfu.sfu14   = l_tsc.tsc21         #輸入日期   #add by zhangzs 210113
   LET l_sfu.sfuplant= g_plant
   LET l_sfu.sfulegal= g_legal #FUN-980009
 
   LET l_sfu.sfuoriu = g_user      #No.FUN-980030 10/01/04
   LET l_sfu.sfuorig = g_grup      #No.FUN-980030 10/01/04 
   #FUN-A80128---add---str--
   LET l_sfu.sfu15   = '0'
#  LET l_sfu.sfu16   = g_user      #TQC-C20337 mark
   LET l_sfu.sfu16   = l_tsc.tsc16 #TQC-C20337
   LET l_sfu.sfumksg =  g_smy.smyapr
   #FUN-A80128---add---end--
   INSERT INTO sfu_file VALUES(l_sfu.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3('ins','sfu_file',l_sfu.sfu01,'',SQLCA.sqlcode,'','','1')
      RETURN FALSE,NULL
   END IF
 
   INITIALIZE l_sfv.* TO NULL
   LET l_sfv.sfv01    = l_sfu.sfu01            #入庫編號
   SELECT MAX(sfv03)+1 INTO l_sfv.sfv03
     FROM sfv_file
    WHERE sfv01 = l_sfv.sfv01
   IF cl_null(l_sfv.sfv03) OR l_sfv.sfv03 = 0 THEN
      LET l_sfv.sfv03 = 1
   END IF
   LET l_sfv.sfv04 = l_sfb.sfb05            #料號
 
   LET l_sfv.sfv05 = l_tsc.tsc12
   LET l_sfv.sfv06 = l_tsc.tsc13
   LET l_sfv.sfv07 = l_tsc.tsc14
 
   IF cl_null(l_sfv.sfv05) THEN LET l_sfv.sfv05 = ' ' END IF
   IF cl_null(l_sfv.sfv06) THEN LET l_sfv.sfv06 = ' ' END IF
   IF cl_null(l_sfv.sfv07) THEN LET l_sfv.sfv07 = ' ' END IF
 
   SELECT img09,img10
     FROM img_file
    WHERE img01=l_sfv.sfv04 AND img02=l_sfv.sfv05
      AND img03=l_sfv.sfv06 AND img04=l_sfv.sfv07
   IF SQLCA.sqlcode = 100 THEN
      CALL s_add_img(l_sfv.sfv04,l_sfv.sfv05,
                     l_sfv.sfv06,l_sfv.sfv07,
                     l_sfu.sfu01,l_sfv.sfv03,
                     g_today)
   END IF
 
   SELECT ima55 INTO l_ima55 FROM ima_file
    WHERE ima01 = l_sfb.sfb05
   IF SQLCA.sqlcode THEN
      CALL cl_err('sel ima:',SQLCA.sqlcode,1)
      RETURN FALSE,NULL
   END IF
 
   LET l_sfv.sfv08 = l_ima55                #庫存單位
   LET l_sfv.sfv09 = l_sfb.sfb08            #入庫量
   LET l_sfv.sfv09 = s_digqty(l_sfv.sfv09,l_sfv.sfv08)   #No.FUN-BB0086
   LET l_sfv.sfv11 = l_sfb.sfb01            #工單單號
   LET l_sfv.sfv12 = NULL                   #備註
   LET l_sfv.sfv13 = NULL                   #No Use
   LET l_sfv.sfv14 = NULL                   #No Use
   LET l_sfv.sfv15 = NULL                   #No Use
   LET l_sfv.sfv16 = 'N'                    #當月是否入聯產品否
   LET l_sfv.sfv17 = NULL                   #FQC單號
   LET l_sfv.sfv18 = NULL                   #No Use
   LET l_sfv.sfv19 = NULL                   #No Use
   LET l_sfv.sfv20 = NULL                   #Run Card
   LET l_sfv.sfv30 = NULL
   LET l_sfv.sfv31 = NULL
   LET l_sfv.sfv32 = NULL
   LET l_sfv.sfv33 = NULL
   LET l_sfv.sfv34 = NULL
   LET l_sfv.sfv35 = NULL
   IF g_sma.sma115 = 'Y' THEN
      LET l_sfv.sfv30 = l_tsc.tsc06            #單位一
      LET l_sfv.sfv31 = l_tsc.tsc07            #單位一換算率(與生產單位)
      LET l_sfv.sfv32 = l_tsc.tsc08            #單位一數量
      LET l_sfv.sfv32 = s_digqty(l_sfv.sfv32,l_sfv.sfv30)   #No.FUN-BB0086
      IF l_ima906 = '1' THEN
         LET l_sfv.sfv33 = NULL
         LET l_sfv.sfv34 = NULL
         LET l_sfv.sfv35 = NULL
      ELSE
         LET l_sfv.sfv33 = l_tsc.tsc09         #單位二
         LET l_sfv.sfv34 = l_tsc.tsc10         #單位二換算率(與生產單位)
         LET l_sfv.sfv35 = l_tsc.tsc11         #單位二數量
         LET l_sfv.sfv35 = s_digqty(l_sfv.sfv35,l_sfv.sfv33)   #No.FUN-BB0086
      END IF
      CASE l_ima906
           WHEN "2"
              IF NOT cl_null(l_sfv.sfv33) THEN
                 CALL s_chk_imgg(l_sfv.sfv04,l_sfv.sfv05,
                                 l_sfv.sfv06,l_sfv.sfv07,
                                 l_sfv.sfv33) RETURNING l_flag
                 IF g_flag = 1 THEN
                    CALL s_add_imgg(l_sfv.sfv04,l_sfv.sfv05,
                                    l_sfv.sfv04,l_sfv.sfv05,
                                    l_sfv.sfv33,l_sfv.sfv34,
                                    l_sfv.sfv01,l_sfv.sfv03,0) RETURNING l_flag
                    IF l_flag = 1 THEN
                       RETURN FALSE,NULL
                    END IF
                 END IF
              END IF
              IF NOT cl_null(l_sfv.sfv30) THEN
                 CALL s_chk_imgg(l_sfv.sfv04,l_sfv.sfv05,
                                 l_sfv.sfv06,l_sfv.sfv07,
                                 l_sfv.sfv30) RETURNING l_flag
                 IF g_flag = 1 THEN
                    CALL s_add_imgg(l_sfv.sfv04,l_sfv.sfv05,
                                    l_sfv.sfv04,l_sfv.sfv05,
                                    l_sfv.sfv30,l_sfv.sfv31,
                                    l_sfv.sfv01,l_sfv.sfv03,0) RETURNING l_flag
                    IF l_flag = 1 THEN
                       RETURN FALSE,NULL
                    END IF
                 END IF
              END IF
           WHEN "3"
              IF NOT cl_null(l_sfv.sfv33) THEN
                 CALL s_chk_imgg(l_sfv.sfv04,l_sfv.sfv05,
                                 l_sfv.sfv06,l_sfv.sfv07,
                                 l_sfv.sfv33) RETURNING l_flag
                 IF g_flag = 1 THEN
                    CALL s_add_imgg(l_sfv.sfv04,l_sfv.sfv05,
                                    l_sfv.sfv04,l_sfv.sfv05,
                                    l_sfv.sfv33,l_sfv.sfv34,
                                    l_sfv.sfv01,l_sfv.sfv03,0) RETURNING l_flag
                    IF l_flag = 1 THEN
                       RETURN FALSE,NULL
                    END IF
                 END IF
              END IF
      END CASE
   END IF
   LET l_sfv.sfv930 = l_sfb.sfb98           #成本中心
   LET l_sfv.sfv41  = l_sfb.sfb27           #專案代號
   LET l_sfv.sfv42  = l_sfb.sfb271          #WBS編碼
   LET l_sfv.sfv43  = l_sfb.sfb50           #活動代號
   LET l_sfv.sfv44  = l_sfb.sfb51           #理由碼
   LET l_sfv.sfvplant = g_plant
   LET l_sfv.sfvlegal = g_legal #FUN-980009
 
   #FUN-CB0087---add---str---
   IF g_aza.aza115 = 'Y' THEN
      CALL s_reason_code(l_sfv.sfv01,l_sfv.sfv11,'',l_sfv.sfv04,l_sfv.sfv05,l_sfu.sfu16,l_sfu.sfu04) RETURNING l_sfv.sfv44
      IF cl_null(l_sfv.sfv44) THEN
         CALL cl_err('','aim-425',1)
         RETURN FALSE,NULL
      END IF
   END IF
   #FUN-CB0087---add---end--
   INSERT INTO sfv_file VALUES(l_sfv.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3('ins','sfv_file',l_sfv.sfv01,l_sfv.sfv03,SQLCA.sqlcode,'','','1')
      RETURN FALSE,NULL
#FUN-B70074--add--insert--
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_sfvi.* TO NULL
         LET l_sfvi.sfvi01 = l_sfv.sfv01
         LET l_sfvi.sfvi03 = l_sfv.sfv03
         IF NOT s_ins_sfvi(l_sfvi.*,l_sfv.sfvplant) THEN
            RETURN FALSE,NULL 
         END IF
      END IF 
#FUN-B70074--add--insert--
   END IF
 
   #No.CHI-A70051  --Begin
   #组合单单头批序号生成工单入库批序号资料
   DECLARE t260_rvbs_cs2 CURSOR FOR
    SELECT * FROM rvbs_file
     WHERE rvbs00 = 'atmt260' 
       AND rvbs01 = p_tsc01
       AND rvbs02 = 0
   FOREACH t260_rvbs_cs2 INTO l_rvbs.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach t260_rvbs_cs2',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_rvbs.rvbs00 = 'asft620'   #工单入库
      LET l_rvbs.rvbs01 = l_sfv.sfv01
      LET l_rvbs.rvbs02 = 1
      INSERT INTO rvbs_file VALUES (l_rvbs.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3('ins','rvbs_file','asft620',l_sfp.sfp01,SQLCA.sqlcode,'','','1')
         RETURN FALSE,NULL
      END IF 
   END FOREACH
   #No.CHI-A70051  --End  
   RETURN TRUE,l_sfu.sfu01
 
END FUNCTION
#CHI-A70027 add --start--
FUNCTION t260_modi_lot_header()
   IF g_tsc.tscconf='Y' THEN
      CALL cl_err(g_tsc.tscconf,'9023',0)
      RETURN
   END IF
   LET g_ima918 = ''
   LET g_ima921 = ''
   SELECT ima918,ima921 INTO g_ima918,g_ima921 
     FROM ima_file
    WHERE ima01 = g_tsc.tsc03
      AND imaacti = "Y"
           
   IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
      BEGIN WORK
      CALL t260_ima25(g_tsc.tsc03,g_tsc.tsc12,g_tsc.tsc13,g_tsc.tsc14,g_tsc.tsc04)                   
#TQC-B90236--mark--begin
#     CALL s_lotin(g_prog,g_tsc.tsc01,0,0,
#                  g_tsc.tsc03,g_tsc.tsc04,g_ima25,
#                  g_ima25_fac,g_tsc.tsc05,'','MOD')
#TQC-B90236--mark--end
#TQC-B90236--mark--begin
      CALL s_mod_lot(g_prog,g_tsc.tsc01,0,0,
                     g_tsc.tsc03,g_tsc.tsc12,
                     g_tsc.tsc13,g_tsc.tsc14,
                     g_tsc.tsc04,g_ima25,g_ima25_fac,g_tsc.tsc05,'','MOD',1)
#TQC-B90236--mark--end
           RETURNING l_r,g_qty
      IF l_r = "Y" THEN
         LET g_tsc.tsc05 = g_qty
         DISPLAY BY NAME g_tsc.tsc05
      END IF
   END IF
END FUNCTION

FUNCTION t260_qry_lot_header()

   LET g_ima918 = ''
   LET g_ima921 = ''
   SELECT ima918,ima921 INTO g_ima918,g_ima921 
     FROM ima_file
    WHERE ima01 = g_tsc.tsc03
      AND imaacti = "Y"

   IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
      BEGIN WORK
      CALL t260_ima25(g_tsc.tsc03,g_tsc.tsc12,g_tsc.tsc13,g_tsc.tsc14,g_tsc.tsc04)                   
#TQC-B90236--mark--begin
#     CALL s_lotin(g_prog,g_tsc.tsc01,0,0,
#                  g_tsc.tsc03,g_tsc.tsc04,g_ima25,
#                  g_ima25_fac,g_tsc.tsc05,'','QRY')
#TQC-B90236--mark--end
#TQC_B90236--add---begin
      CALL s_mod_lot(g_prog,g_tsc.tsc01,0,0,
                     g_tsc.tsc03,g_tsc.tsc12,
                     g_tsc.tsc13,g_tsc.tsc14,
                     g_tsc.tsc04,g_ima25,g_ima25_fac,g_tsc.tsc05,'','QRY',1)
#TQC_B90236--add---end
           RETURNING l_r,g_qty
      IF l_r = "Y" THEN
         LET g_tsc.tsc05 = g_qty
         DISPLAY BY NAME g_tsc.tsc05
      END IF
   END IF
END FUNCTION

FUNCTION t260_ima25(p_img01,p_img02,p_img03,p_img04,p_unit)
DEFINE p_img01  LIKE img_file.img01 #料件編號
DEFINE p_img02  LIKE img_file.img02 #倉庫編號
DEFINE p_img03  LIKE img_file.img03 #儲位
DEFINE p_img04  LIKE img_file.img04 #批號
DEFINE p_unit   LIKE img_file.img09 #庫存單位

   SELECT img09 INTO g_ima25 FROM img_file
         WHERE img01 = p_img01 AND img02 = p_img02
           AND img03 = p_img03 AND img04 = p_img04
   IF STATUS=0 THEN
      IF p_unit = g_ima25 THEN
          LET g_ima25_fac =1
      ELSE
          #檢查該發料單位與主檔之單位是否可以轉換
          CALL s_umfchk(p_img01,p_unit,g_ima25)
                    RETURNING g_cnt,g_ima25_fac
          IF g_cnt = 1 THEN
             CALL cl_err('','mfg3075',1)
          END IF
      END IF
   END IF
   IF cl_null(g_ima25_fac) THEN LET g_ima25_fac = 1 END IF
END FUNCTION
#CHI-A70027 add --end--
#No.FUN-9C0073  --------------------By chenls   10/01/11

#No.CHI-A80043  --Begin
FUNCTION t260_sfb_close(p_sfb01)
   DEFINE p_sfb01     LIKE sfb_file.sfb01
   DEFINE l_sfb28     LIKE sfb_file.sfb28
   DEFINE l_sfb36     LIKE sfb_file.sfb36
   DEFINE l_sfb37     LIKE sfb_file.sfb37
   DEFINE l_sfb38     LIKE sfb_file.sfb38

   IF g_sma.sma72 = 'Y' THEN
   #  LET l_sfb28 = '2'     #CHI-B60061
      LET l_sfb28 = '1'     #CHI-B60061
      #LET l_sfb36 = g_today     #mark by zhangzs 210113
      #LET l_sfb37 = g_today     #mark by zhangzs 210113
      LET l_sfb36 = g_tsc.tsc21  #add by zhangzs 210113
      LET l_sfb37 = g_tsc.tsc21  #add by zhangzs 210113
      LET l_sfb38 = NULL   #CHI-B40040
   ELSE
      LET l_sfb28 = '3'
     # LET l_sfb36 = g_today      #mark by zhangzs 210113
     # LET l_sfb37 = g_today      #mark by zhangzs 210113
     # LET l_sfb38 = g_today      #mark by zhangzs 210113
      LET l_sfb36 = g_tsc.tsc21   #add by zhangzs 210113
      LET l_sfb37 = g_tsc.tsc21   #add by zhangzs 210113
      LET l_sfb38 = g_tsc.tsc21   #add by zhangzs 210113
   END IF
   UPDATE sfb_file SET sfb28 = l_sfb28,sfb36 = l_sfb36,
                       sfb37 = l_sfb37,sfb38 = l_sfb38,
                       sfb04 = '8'
    WHERE sfb01 = p_sfb01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3('upd','sfb_file',p_sfb01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF

   UPDATE sfa_file SET sfa25 = 0 WHERE sfa01 = p_sfb01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3('upd','sfa_file',p_sfb01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF

END FUNCTION


FUNCTION t260_sfb_undo_close(p_sfb01)
   DEFINE p_sfb01     LIKE sfb_file.sfb01

   UPDATE sfb_file SET sfb28 = NULL,sfb36 = NULL,
                       sfb37 = NULL,sfb38 = NULL,
                       sfb04 = '7'
    WHERE sfb01 = p_sfb01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3('upd','sfb_file',p_sfb01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF

END FUNCTION
#No.CHI-A80043  --End  

#No.FUN-BB0086--add--start--
FUNCTION t260_tsc05_check(p_cmd)
   DEFINE  p_cmd        LIKE type_file.chr1   
   IF NOT cl_null(g_tsc.tsc05) AND NOT cl_null(g_tsc.tsc04) THEN
      IF cl_null(g_tsc_t.tsc05) OR cl_null(g_tsc04_t) OR g_tsc_t.tsc05 != g_tsc.tsc05 OR g_tsc04_t != g_tsc.tsc04 THEN
         LET g_tsc.tsc05=s_digqty(g_tsc.tsc05,g_tsc.tsc04)
         DISPLAY BY NAME g_tsc.tsc05
      END IF
   END IF
   
   IF NOT cl_null(g_tsc.tsc05) THEN
      IF g_tsc.tsc05 < 0 THEN
         CALL cl_err('','mfg9243',0)
         RETURN FALSE 
      END IF
   END IF

   IF p_cmd = 'u' THEN 
      CALL t260_modi_lot_header() 
   END IF
   RETURN TRUE
END FUNCTION 

FUNCTION t260_tsc08_check()
   IF NOT cl_null(g_tsc.tsc08) AND NOT cl_null(g_tsc.tsc06) THEN
      IF cl_null(g_tsc_t.tsc08) OR cl_null(g_tsc06_t) OR g_tsc_t.tsc08 != g_tsc.tsc08 OR g_tsc06_t != g_tsc.tsc06 THEN
         LET g_tsc.tsc08=s_digqty(g_tsc.tsc08,g_tsc.tsc06)
         DISPLAY BY NAME g_tsc.tsc08
      END IF
   END IF
   
   IF NOT cl_null(g_tsc.tsc08) THEN
      IF g_tsc.tsc08 < 0 THEN
         CALL cl_err('','mfg9243',0)
         RETURN FALSE 
      END IF
      CALL t260_du_data_to_correct()
      CALL t260_set_origin_field()
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t260_tsc11_check()
   IF NOT cl_null(g_tsc.tsc11) AND NOT cl_null(g_tsc.tsc09) THEN
      IF cl_null(g_tsc_t.tsc11) OR cl_null(g_tsc09_t) OR g_tsc_t.tsc11 != g_tsc.tsc11 OR g_tsc09_t != g_tsc.tsc09 THEN
         LET g_tsc.tsc11=s_digqty(g_tsc.tsc11,g_tsc.tsc09)
         DISPLAY BY NAME g_tsc.tsc11
      END IF
   END IF
   
   IF NOT cl_null(g_tsc.tsc11) THEN
      IF g_tsc.tsc11 < 0 THEN
         CALL cl_err('','mfg9243',0)
         RETURN FALSE 
      END IF
      IF g_ima906='3' THEN
         LET g_tot=g_tsc.tsc11*g_tsc.tsc10
         IF cl_null(g_tsc.tsc08) OR g_tsc.tsc08=0 THEN 
            LET g_tsc.tsc08=g_tot
            DISPLAY BY NAME g_tsc.tsc08
         END IF                                        
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t260_tsd05_check(l_r)
   DEFINE l_r          LIKE type_file.chr1  
   IF NOT cl_null(g_tsd[l_ac].tsd05) AND NOT cl_null(g_tsd[l_ac].tsd04) THEN
      IF cl_null(g_tsd_t.tsd05) OR cl_null(g_tsd04_t) OR g_tsd_t.tsd05 != g_tsd[l_ac].tsd05 OR g_tsd04_t != g_tsd[l_ac].tsd04 THEN
         LET g_tsd[l_ac].tsd05=s_digqty(g_tsd[l_ac].tsd05,g_tsd[l_ac].tsd04)
         DISPLAY BY NAME g_tsd[l_ac].tsd05
      END IF
   END IF
   
   IF NOT cl_null(g_tsd[l_ac].tsd05) THEN
      IF g_tsd[l_ac].tsd05 < 0 THEN
         CALL cl_err('','mfg9243',0)
         RETURN FALSE 
      END IF

      SELECT img10 INTO g_imgg10 FROM img_file
         WHERE img01=g_tsd[l_ac].tsd03
           AND img02=g_tsd[l_ac].tsd12
           AND img03=g_tsd[l_ac].tsd13
           AND img04=g_tsd[l_ac].tsd14
      IF g_tsd[l_ac].tsd05*g_tsd041 > g_imgg10 THEN
         #FUN-C80107 modify begin------------------------121024
         #CALL cl_err(g_tsd[l_ac].tsd05,'mfg1303',1)
         #RETURN FALSE 
        #FUN-D30024--modify--str--
        #INITIALIZE g_sma894 TO NULL
        #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_tsd[l_ac].tsd12) RETURNING g_sma894
        #IF g_sma894 = 'N' THEN
         INITIALIZE g_imd23 TO NULL
         CALL s_inv_shrt_by_warehouse(g_tsd[l_ac].tsd12,g_plant) RETURNING g_imd23 #TQC-D40078 g_plant
         IF g_imd23 = 'N' THEN
        #FUN-D30024--modify--end--
            CALL cl_err(g_tsd[l_ac].tsd05,'mfg1303',1)
            RETURN FALSE 
         ELSE
            IF NOT cl_confirm('mfg3469') THEN
               RETURN FALSE 
            END IF
         END IF
         #FUN-C80107 modify end--------------------------
      END IF
   END IF
    LET g_ima918 = ''
    LET g_ima921 = ''
    SELECT ima918,ima921 INTO g_ima918,g_ima921 
      FROM ima_file
     WHERE ima01 = g_tsd[l_ac].tsd03
       AND imaacti = "Y"
  
    IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
       CALL t260_ima25(g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14,g_tsd[l_ac].tsd04)                   
      #CALL s_lotout(g_prog,g_tsc.tsc01,g_tsd[l_ac].tsd02,0,   #TQC-B90236 mark
       CALL s_mod_lot(g_prog,g_tsc.tsc01,g_tsd[l_ac].tsd02,0,   #TQC-B90236 add
                     g_tsd[l_ac].tsd03,g_tsd[l_ac].tsd12,
                     g_tsd[l_ac].tsd13,g_tsd[l_ac].tsd14,
                     g_tsd[l_ac].tsd04,g_ima25,g_ima25_fac,
                     g_tsd[l_ac].tsd05,'','MOD',-1)    #TQC-B90236 add -1
            RETURNING l_r,g_qty
       IF l_r = "Y" THEN
          LET g_tsd[l_ac].tsd05 = g_qty
          DISPLAY BY NAME g_tsd[l_ac].tsd05
       END IF
    END IF
   RETURN TRUE
END FUNCTION 

FUNCTION t260_tsd08_check()
   IF NOT cl_null(g_tsd[l_ac].tsd08) AND NOT cl_null(g_tsd[l_ac].tsd06) THEN
      IF cl_null(g_tsd_t.tsd08) OR cl_null(g_tsd06_t) OR g_tsd_t.tsd08 != g_tsd[l_ac].tsd08 OR g_tsd06_t != g_tsd[l_ac].tsd06 THEN
         LET g_tsd[l_ac].tsd08=s_digqty(g_tsd[l_ac].tsd08,g_tsd[l_ac].tsd06)
         DISPLAY BY NAME g_tsd[l_ac].tsd08
      END IF
   END IF
   
   IF NOT cl_null(g_tsd[l_ac].tsd08) THEN
      IF g_tsd[l_ac].tsd08 < 0 THEN
         CALL cl_err('','mfg9243',0)
         RETURN FALSE 
      END IF
      IF NOT cl_null(g_tsd[l_ac].tsd06) THEN
         IF g_ima906 = '2' THEN   #MATCHES '[23]' THEN
            IF g_tsd[l_ac].tsd08 > g_imgg10_1 THEN
                  IF NOT cl_confirm('mfg3469') THEN
                     RETURN FALSE 
                  END IF
             END IF
         ELSE
            IF g_tsd[l_ac].tsd08*g_tsd[l_ac].tsd07 > g_imgg10_1 THEN
                  IF NOT cl_confirm('mfg3469') THEN
                     RETURN FALSE 
                  END IF
            END IF
         END IF
      END IF
      CALL t260_du_data_to_correct_b()
      CALL t260_set_origin_field_b()
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t260_tsd11_check()
   IF NOT cl_null(g_tsd[l_ac].tsd11) AND NOT cl_null(g_tsd[l_ac].tsd09) THEN
      IF cl_null(g_tsd_t.tsd11) OR cl_null(g_tsd09_t) OR g_tsd_t.tsd11 != g_tsd[l_ac].tsd11 OR g_tsd09_t != g_tsd[l_ac].tsd09 THEN
         LET g_tsd[l_ac].tsd11=s_digqty(g_tsd[l_ac].tsd11,g_tsd[l_ac].tsd09)
         DISPLAY BY NAME g_tsd[l_ac].tsd11
      END IF
   END IF
   
   IF NOT cl_null(g_tsd[l_ac].tsd11) THEN
      IF g_tsd[l_ac].tsd11 < 0 THEN
         CALL cl_err('','mfg9243',0)
         RETURN FALSE 
      END IF
      IF g_ima906='3' THEN
         LET g_tot=g_tsd[l_ac].tsd11*g_tsd[l_ac].tsd10    
         IF cl_null(g_tsd[l_ac].tsd08) OR g_tsd[l_ac].tsd08=0 THEN #CHI-960022
            LET g_tsd[l_ac].tsd08=g_tot
            DISPLAY BY NAME g_tsd[l_ac].tsd08
         END IF                                                    #CHI-960022
      END IF
      IF g_ima906 MATCHES '[23]' THEN
         SELECT imgg10 INTO g_imgg10_2 FROM imgg_file
          WHERE imgg01=g_tsd[l_ac].tsd03
            AND imgg02=g_tsd[l_ac].tsd12
            AND imgg03=g_tsd[l_ac].tsd13
            AND imgg04=g_tsd[l_ac].tsd14
            AND imgg09=g_tsd[l_ac].tsd09
      END IF
      IF g_tsd[l_ac].tsd11 > g_imgg10_2 THEN
            IF NOT cl_confirm('mfg3469') THEN
               RETURN FALSE 
            END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#No.FUN-BB0086--add--end--
#add by zhangzs 210113 ----s-----产生原工单退料单528/529
FUNCTION ins_sfp()
DEFINE l_tsd03      LIKE tsd_file.tsd03
DEFINE l_tsd05      LIKE tsd_file.tsd05
DEFINE l_tsd12      LIKE tsd_file.tsd12
DEFINE l_tsd13      LIKE tsd_file.tsd13
DEFINE l_tsd14      LIKE tsd_file.tsd14
DEFINE li_result    LIKE type_file.num5  
DEFINE l_count      LIKE type_file.num5
DEFINE l_status     LIKE type_file.chr1
DEFINE l_sfa   RECORD      LIKE sfa_file.*
DEFINE l_tscud02    LIKE tsc_file.tscud02
DEFINE l_sfa06      LIKE sfa_file.sfa06
DEFINE l_sfp_count   LIKE type_file.num5
DEFINE l_count2       LIKE type_file.num5
DEFINE l_count3       LIKE type_file.num5
DEFINE l_cnt          LIKE type_file.num5
DEFINE l_tsd02        LIKE tsd_file.tsd02
   INITIALIZE g_sfp.* TO NULL
   INITIALIZE g_sfs.* TO NULL
   INITIALIZE l_sfp.* TO NULL
   INITIALIZE l_sfs.* TO NULL
   #一般特性sfa11
      SELECT shb05 INTO g_sfs.sfs03 FROM shb_file WHERE shb01 = g_tsc.tscud02  #工单号
      SELECT count(*) INTO l_count2 FROM tsd_file,sfa_file WHERE sfa03 = tsd03 AND sfa01 = g_sfs.sfs03 AND sfa11 = 'N' AND tsd01 = g_tsc.tsc01
      IF l_count2 > 0 THEN 
#atmt260单头
      CALL s_auto_assign_no("asf",'MRH',g_today,"","sfp_file","sfp01","","","")
        RETURNING li_result,g_sfp.sfp01
      
      IF (NOT li_result) THEN
         CALL cl_err('退料单号产生失败','!',1)
      END IF
         #darcy:2024/07/04 add s---
         call cl_progressing(sfmt("产生单身一般退料单-%1",g_sfp.sfp01))
         update tsc_file set tscud04 = g_sfp.sfp01 where tsc01 = g_tsc.tsc01
         #darcy:2024/07/04 add e---
        LET g_sfp.sfp02  =g_tsc.tsc21
        LET g_sfp.sfp03  =g_tsc.tsc21   #No.B182 010502 add
        LET g_sfp.sfp04  ='N'
        LET g_sfp.sfp06 = '8'
        LET g_sfp.sfpconf='N' #FUN-660106
        LET g_sfp.sfp05  ='N'
        LET g_sfp.sfp09  ='N'
        LET g_sfp.sfpuser=g_user  #NO:6908
        LET g_sfp.sfporiu = g_user #FUN-980030
        LET g_sfp.sfporig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_sfp.sfpgrup=g_grup  #NO:6908
        LET g_sfp.sfpdate=g_tsc.tsc21 #NO:6908
        LET g_sfp.sfp07  =g_grup  #FUN-670103
        LET g_sfp.sfp15 = '0'     #開立  
        LET g_sfp.sfpmksg = "N"
        LET g_sfp.sfp16 = g_user
        LET g_sfp.sfpplant = g_plant #FUN-980008 add
        LET g_sfp.sfplegal = g_legal #FUN-980008 add
        INSERT INTO sfp_file VALUES (g_sfp.*)
        IF SQLCA.sqlcode THEN                 #置入資料庫不成功
            CALL cl_err3("ins","sfp_file",g_sfp.sfp01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104        #FUN-B80061   ADD
            ROLLBACK WORK
            LET g_success = 'N'
            CALL cl_err('新增到asfi528单头失败','!',1)
        ELSE
            LET g_success = 'Y'
        END IF

#atmt260单身
        IF g_success = 'Y' THEN 
        LET g_sql = "SELECT DISTINCT tsd02,tsd03,tsd05,tsd12,tsd13,tsd14 ",  
                    "FROM tsd_file,sfa_file ",
                    "WHERE sfa03 = tsd03 AND sfa11 = 'N' AND sfa01 = '",g_sfs.sfs03,"' AND tsd01 = '",g_tsc.tsc01,"'"

        PREPARE oea_pre FROM g_sql
        DECLARE oea_cur2 CURSOR FOR oea_pre
        LET l_count = 0
        FOREACH oea_cur2 INTO l_tsd02,l_tsd03,l_tsd05,l_tsd12,l_tsd13,l_tsd14 #料号、数量、仓库、库位、批号
            SELECT shb05 INTO g_sfs.sfs03 FROM shb_file WHERE shb01 = g_tsc.tscud02  #工单号
            SELECT sfa06 INTO l_sfa06 FROM sfa_file WHERE sfa01 = g_sfs.sfs03 AND sfa03 = l_tsd03   #已发数量
            LET g_sfs.sfs01 = g_sfp.sfp01
            LET l_count = l_count + 1
            LET g_sfs.sfs02 = l_count   #项次
           # SELECT shb05 INTO g_sfs.sfs03 FROM shb_file WHERE shb01 = g_tsc.tscud02  #工单号
            LET g_sfs.sfs04 = l_tsd03
            LET g_sfs.sfs27 = l_tsd03
            LET g_sfs.sfs28 = 1
            SELECT ima63 INTO g_sfs.sfs06 FROM ima_file WHERE ima01 = l_tsd03  #单位
            LET g_sfs.sfs07 = l_tsd12
            LET g_sfs.sfs08 = l_tsd13
            LET g_sfs.sfs05 = l_tsd05
            LET g_sfs.sfsplant = g_plant
            LET g_sfs.sfslegal = g_legal
            LET g_sfs.sfs014 = ' '
            LET g_sfs.sfs013 = 0
            LET g_sfs.sfs012 = ' '
            SELECT tscud02 INTO l_tscud02 FROM tsc_file WHERE tsc01 = g_tsc.tsc01
            SELECT sfa08 INTO g_sfs.sfs10 FROM sfa_file WHERE sfa01 = g_sfs.sfs03 AND sfa03 = l_tsd03
            LET g_sfs.sfs09 = l_tsd14#add zhangzs 201229 pihao
            IF l_tsd05 < l_sfa06 THEN 
               SELECT COUNT(*) INTO l_cnt FROM img_file WHERE  img01=l_tsd03
                                                 AND img02=l_tsd12
                                                 AND img03=l_tsd13
                                                 AND img04=l_tsd14
                IF l_cnt=0 OR cl_null(l_cnt) THEN
                CALL s_add_img(l_tsd03, l_tsd12,l_tsd13, l_tsd14,
                        g_tsc.tsc01,l_tsd02, g_today)
                IF g_errno='N' THEN 
                  LET g_success = 'N'
                END IF
                END IF
               INSERT INTO sfs_file VALUES (g_sfs.*)
            END IF 
            IF STATUS OR SQLCA.SQLCODE THEN
              # ROLLBACK WORK   #No:7829
               LET g_success = 'N'
               CALL cl_err('新增到atmt260单身失败','!',1)
               EXIT FOREACH 
            ELSE 
               LET g_success = 'Y'
            END IF 
        END FOREACH  
        SELECT COUNT(*) INTO l_sfp_count FROM sfs_file WHERE sfs01 = g_sfp.sfp01
        call cl_progressing("单身一般退料单自动审核过账") #darcy:2024/07/04 add
        IF l_sfp_count = 0 THEN 
           DELETE FROM sfp_file WHERE sfp01 = g_sfp.sfp01
        ELSE 
           IF g_sfp.sfp15 matches '[Ss]' THEN
            CALL cl_err('','apm-030',0) #送簽中, 不可修改資料!
            RETURN
           END IF   
           CALL i501sub_y_chk(g_sfp.sfp01,'')  #TQC-C60079
           IF g_success = "Y" THEN
            CALL i501sub_y_upd(g_sfp.sfp01,g_action_choice,TRUE) RETURNING g_sfp.*
           END IF  
         #自动过账
           CALL i501sub_s('2',g_sfp.sfp01,TRUE,'N') #FUN-740187
        END IF 
        END IF 
        END IF 

        #消耗性sfa11
      SELECT shb05 INTO g_sfs.sfs03 FROM shb_file WHERE shb01 = g_tsc.tscud02  #工单号
      SELECT count(*) INTO l_count3 FROM tsd_file,sfa_file WHERE sfa03 = tsd03 AND sfa01 = g_sfs.sfs03 AND sfa11 = 'E' AND tsd01 = g_tsc.tsc01
      IF l_count3 > 0 THEN 
#atmt260单头
      CALL s_auto_assign_no("asf",'200',g_today,"","sfp_file","sfp01","","","")
        RETURNING li_result,l_sfp.sfp01
      IF (NOT li_result) THEN
         CALL cl_err('退料单号产生失败','!',1)
      END IF
        #darcy:2024/07/04 add s---
         call cl_progressing(sfmt("产生单身领料退料单-%1",l_sfp.sfp01))
         update tsc_file set tscud06 = l_sfp.sfp01 where tsc01 = g_tsc.tsc01
        #darcy:2024/07/04 add e---
        LET l_sfp.sfp02  =g_tsc.tsc21
        LET l_sfp.sfp03  =g_tsc.tsc21   #No.B182 010502 add
        LET l_sfp.sfp04  ='N'
        LET l_sfp.sfp06 = '9'
        LET l_sfp.sfpconf='N' #FUN-660106
        LET l_sfp.sfp05  ='N'
        LET l_sfp.sfp09  ='N'
        LET l_sfp.sfpuser=g_user  #NO:6908
        LET l_sfp.sfporiu = g_user #FUN-980030
        LET l_sfp.sfporig = g_grup #FUN-980030
       # LET l_data_plant = g_plant #FUN-980030
        LET l_sfp.sfpgrup=g_grup  #NO:6908
        LET l_sfp.sfpdate=g_tsc.tsc21 #NO:6908
        LET l_sfp.sfp07  =g_grup  #FUN-670103
        LET l_sfp.sfp15 = '0'     #開立  
        LET l_sfp.sfpmksg = "N"
        LET l_sfp.sfp16 = g_user
        LET l_sfp.sfpplant = g_plant #FUN-980008 add
        LET l_sfp.sfplegal = g_legal #FUN-980008 add
        INSERT INTO sfp_file VALUES (l_sfp.*)
        IF SQLCA.sqlcode THEN                 #置入資料庫不成功
            CALL cl_err3("ins","sfp_file",l_sfp.sfp01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104        #FUN-B80061   ADD
            ROLLBACK WORK
            LET g_success = 'N'
            CALL cl_err('新增到asfi529单头失败','!',1)
        ELSE
            LET g_success = 'Y'
        END IF

#atmt260单身
        IF g_success = 'Y' THEN 
        LET g_sql = "SELECT DISTINCT tsd02,tsd03,tsd05,tsd12,tsd13,tsd14 ",  
                    "FROM tsd_file,sfa_file ",
                    "WHERE sfa03 = tsd03 AND sfa11 = 'E' AND sfa01 = '",g_sfs.sfs03,"' AND tsd01 = '",g_tsc.tsc01,"' "

        PREPARE oea_pre2 FROM g_sql
        DECLARE oea_cur5 CURSOR FOR oea_pre2
        LET l_count = 0
        FOREACH oea_cur5 INTO l_tsd02,l_tsd03,l_tsd05,l_tsd12,l_tsd13,l_tsd14 #料号、数量、仓库、库位、批号
            SELECT shb05 INTO l_sfs.sfs03 FROM shb_file WHERE shb01 = g_tsc.tscud02  #工单号
            SELECT sfa06 INTO l_sfa06 FROM sfa_file WHERE sfa01 = l_sfs.sfs03 AND sfa03 = l_tsd03   #已发数量
            LET l_sfs.sfs01 = l_sfp.sfp01
            LET l_count = l_count + 1
            LET l_sfs.sfs02 = l_count   #项次
            #SELECT shb05 INTO l_sfs.sfs03 FROM shb_file WHERE shb01 = g_tsc.tscud02  #工单号
            LET l_sfs.sfs04 = l_tsd03
            LET l_sfs.sfs27 = l_tsd03
            LET l_sfs.sfs28 = 1
            SELECT ima63 INTO l_sfs.sfs06 FROM ima_file WHERE ima01 = l_tsd03  #单位
            LET l_sfs.sfs07 = l_tsd12
            LET l_sfs.sfs08 = l_tsd13
            LET l_sfs.sfs05 = l_tsd05
            LET l_sfs.sfsplant = g_plant
            LET l_sfs.sfslegal = g_legal
            LET l_sfs.sfs014 = ' '
            LET l_sfs.sfs013 = 0
            LET l_sfs.sfs012 = ' '
            SELECT tscud02 INTO l_tscud02 FROM tsc_file WHERE tsc01 = g_tsc.tsc01
            SELECT sfa08 INTO l_sfs.sfs10 FROM sfa_file WHERE sfa01 = l_sfs.sfs03 AND sfa03 = l_tsd03
            LET l_sfs.sfs09 = l_tsd14#add zhangzs 201229 pihao
            IF l_tsd05 < l_sfa06 THEN 
                SELECT COUNT(*) INTO l_cnt FROM img_file WHERE  img01=l_tsd03
                                                 AND img02=l_tsd12
                                                 AND img03=l_tsd13
                                                 AND img04=l_tsd14
                IF l_cnt=0 OR cl_null(l_cnt) THEN
                CALL s_add_img(l_tsd03, l_tsd12,l_tsd13, l_tsd14,
                        g_tsc.tsc01,l_tsd02, g_today)
                IF g_errno='N' THEN 
                  LET g_success = 'N'
                END IF
                END IF
               INSERT INTO sfs_file VALUES (l_sfs.*)
            END IF 
            IF STATUS OR SQLCA.SQLCODE THEN
              # ROLLBACK WORK   #No:7829
               LET g_success = 'N'
               CALL cl_err('新增到atmt260单身失败','!',1)
               EXIT FOREACH 
            ELSE 
               LET g_success = 'Y'
            END IF 
        END FOREACH  
        SELECT COUNT(*) INTO l_sfp_count FROM sfs_file WHERE sfs01 = l_sfp.sfp01
        call cl_progressing("单身领料料单自动审核过账") #darcy:2024/07/04 add
        IF l_sfp_count = 0 THEN 
           DELETE FROM sfp_file WHERE sfp01 = l_sfp.sfp01
        ELSE 
           IF l_sfp.sfp15 matches '[Ss]' THEN
            CALL cl_err('','apm-030',0) #送簽中, 不可修改資料!
            RETURN
           END IF   
           CALL i501sub_y_chk(l_sfp.sfp01,'')  #TQC-C60079
           IF g_success = "Y" THEN
            CALL i501sub_y_upd(l_sfp.sfp01,g_action_choice,TRUE) RETURNING l_sfp.*
           END IF  
         #自动过账
           CALL i501sub_s('2',l_sfp.sfp01,TRUE,'N') #FUN-740187
        END IF 
        END IF 
        END IF 
END FUNCTION 
#add by zhangzs 210113 ----e-----
