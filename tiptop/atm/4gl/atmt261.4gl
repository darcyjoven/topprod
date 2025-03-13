# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmt261.4gl
# Descriptions...: 產品組合包裝拆解維護作業
# Date & Author..: 06/01/19 By jackie
# Modify.........: NO.TQC-630072 06/03/07 By Melody 指定單據編號、執行功能(g_argv2)
# Modify.........: No.TQC-640116 06/04/09 By day  確認時顯示圖片改為"核"
# Modify.........: No.TQC-640116 06/04/10 By Ray  執行過帳，將成本庫別/倉庫/儲位/批號(tlf901~tlf904)寫入tlf_file中
# Modify.........: No.TQC-650031 06/05/12 By Rayven 修改過帳時,單頭資料更新tlf_file異動錯誤
# Modify.........: No.TQC-650031 06/05/12 By Rayven 修改不使用多單位時,單身子單位數量欄位還會出現問題
# Modify.........: No.FUN-660104 06/06/20 By cl   Error Message 調整
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
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840042 08/04/17 By TSD.liquor 自定欄位功能修改
# Modify.........: No.FUN-850155 08/06/20 By destiny 報表改為CR輸出                                                                 
#                                08/08/04 By Cockroach 21追至31區
# Modify.........: NO.TQC-880014 08/08/20 By sabrinae 因正式區的畫面檔和程式欄位不符合，所以補過程式檔
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID
# Modify.........: No.MOD-910140 09/01/13 By Smapmin 未確認的料號不可輸入
# Modify.........: No.TQC-930080 09/03/12 By chenyu 1.AFTER FIELD tse04后面，取不到轉換率應該報錯
#                                                   2.AFTER FIELD tse03后面,判斷不准確，導致沒有使用多單位，也顯示第二數量欄位
# Modify.........: No.FUN-930140 09/03/23 By Carrier 增加工單單號
# Modify.........: No.TQC-930155 09/04/14 By Zhangyajun 數據Lock失敗，不能直接Rollback
# Modify.........: No.FUN-950021 09/05/23 By Carrier 組合拆解
# Modify.........: No.MOD-960031 09/06/05 By Dido 過帳前應檢核是否已作廢
# Modify.........: No.MOD-960150 09/06/11 By Dido 重新取得庫存明細資料 
# Modify.........: No.FUN-870100 09/07/30 By Cockroach 零售超市移植              
# Modify.........: No.FUN-980009 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.CHI-960052 09/10/15 By chenmoyan 使用多單位，料件是單一單位或參考單位時，單位一的轉換率錯誤
# Modify.........: No.MOD-9C0344 09/12/23 By Dido 單頭數量不可等於 0 
# Modify.........: No.FUN-9C0073 10/01/11 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A20037 10/03/11 By lilingyu 替代碼sfa26加上"8,Z"的條件
# Modify.........: No.TQC-A30048 10/03/15 By Cockroach  add oriu/orig
# Modify.........: No.FUN-A50071 10/05/19 By lixia 程序增加POS單號字段 并增加相应管控
# Modify.........: No.TQC-A50087 10/05/20 By liuxqa sfb104 赋初值.
# Modify.........: No.FUN-A60027 10/06/17 By sunchenxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.MOD-A60197 10/06/30 By liuxqa sfa012,sfa013 賦初值。
# Modify.........: No:CHI-A70027 10/07/20 By Summer 批/序號控制 
# Modify.........: No:CHI-A70051 10/07/28 By Carrier 拆解单产生的工单/发料/入库等加上批序号内容
# Modify.........: No:MOD-A80046 10/08/06 By lilingyu 過賬時,庫存量不足,依然可以過賬成功
# Modify.........: No:MOD-A80061 10/08/09 By lilingyu 過賬段部分邏輯錯誤
# Modify.........: No:MOD-A80082 10/08/10 By lilingyu 工單產生備料,但是單頭的備料否字段賦值錯誤 
# Modify.........: No:CHI-A80043 10/08/26 By Carrier 产生工单自动结案
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.MOD-AA0167 10/10/27 By lilingyu 過賬時,未考慮系統關帳日期
# Modify.........: No.FUN-AA0059 10/11/02 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AA0046 10/11/02 By huangtao 修改q_smy取號設定參數
# Modify.........: No.FUN-AB0015 10/11/03 By houlia 倉庫權限使用控管修改 
# Modify.........: No:FUN-AA0048 10/11/24 By Carrier GP5.2架构下仓库权限修改
# Modify.........: No.TQC-AC0293 10/12/20 By vealxu sfp01的開窗/檢查要排除smy73='Y'的單據
# Modify.........: No:MOD-B30164 11/03/12 By Summer 於INSERT INTO sfb_file前加入 LET l_sfb.sfb44 = l_tse.tse16,人員欄位需控卡為必填
# Modify.........: No:FUN-B30170 11/04/11 By suncx 單身增加批序號明細頁簽
# Modify.........: No:CHI-B40040 11/04/28 By lixh1 三階段結案時,sfb38應該為NULL
# Modify.........: No:FUN-AB0001 11/05/24 By Lilan  因asfi510 新增EasyFlow整合功能影響INSERT INTO sfp_file
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:MOD-B60100 11/06/13 By JoHung 作廢未顯示圖檔，修改cl_set_field_pic第五個參數，程式其他有使用處一併修改
# Modify.........: No:TQC-B60259 11/06/21 By jan 解決不能過帳的問題 即 sfpmksg若为空，则给'N'
# Modify.........: No.CHI-B60061 11/06/27 By lixh1 組合和拆解單確認後產生的工單,做第一階段結案
# Modify.........: No.FUN-B20095 11/07/01 By lixh1 新增sfq012(製程段號)
# Modify.........: No.FUN-B70074 11/07/25 By lixh1 新增行業別TABLE
# Modify.........: No:FUN-B80061 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-BB0086 11/12/27 By tanxc 增加數量欄位小數取位
# Modify.........: No.TQC-B90236 12/01/11 By zhuhao _r()中，使用FOR迴圈執行s_lotout_del/s_lotin_del程式段Mark，改為s_lot_del，傳入參數不變，但第三個參數(項次)傳""
#                                                   s_lotou程式段，改為s_mod_lot，傳入參數不變，於最後多傳入-1
#                                                   s_lotin程式段，改為s_mod_lot，於第6,7,8個參數傳入倉儲批，最後多傳入1，其餘傳入參數不變
# Modify.........: No.FUN-BC0104 12/01/29 By xianghui 數量異動回寫qco20
# Modify.........: No.MOD-C10054 12/02/09 By jt_chen sfp03扣帳日期、sfu02入庫日期、tse02組合日期,目前程式sfp03是給g_today,程式沒有寫入sfu_file; sfp03與ksc02給值,改為tse02
# Modify.........: No:FUN-C20068 12/02/14 By fengrui 數量欄位小數取位處理
# Modify.........: No:TQC-C20161 12/02/17 By yangxf 隐藏POS单号栏位
# Modify.........: No:TQC-C20337 12/02/22 By yangxf 程式過帳時產生對應的工單,發料單,入庫單,其部門資料應取產品組合單上的部門,人員
# Modify.........: No:CHI-C30064 12/03/15 By Sakura 程式有用到"aim-011"訊息的地方，改用料倉儲批抓庫存單位(img09)換算
# Modify.........: No:CHI-C30106 12/04/06 By Elise 批序號維護
# Modify.........: No:CHI-C30118 12/04/06 By Sakura 參考來源單號CHI-C30106,批序號維護修改,t622sub_y_chk新增傳入參數
# Modify.........: No.FUN-C30300 12/04/09 By bart  倉儲批開窗需顯示參考單位數量
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:TQC-C60028 12/06/04 By bart 只要是ICD行業 倉儲批開窗改用q_idc
# Modify.........: No.TQC-C60079 12/06/11 By fengrui 函數i501sub_y_chk添加參數
# Modify.........: No:FUN-C70014 12/07/09 By wangwei 新增RUN CARD發料作業
# Modify.........: No.FUN-C70087 12/08/01 By bart 整批寫入img_file
# Modify.........: No:FUN-C80046 12/08/16 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-C80065 12/08/16 By nanbing 添加批序號依參數sma95隱藏
# Modify.........: No:TQC-C80161 12/08/27 By yangxf 確認時未將確認人，確認日期顯示
# Modify.........: No:FUN-C80107 12/09/18 By suncx 新增可按倉庫進行負庫存判斷
# Modify.........: No.CHI-C80041 12/12/05 By bart 取消單頭資料控制
# Modify.........: No:TQC-CC0142 12/12/27 By qirl 過帳后顯示審核
# Modify.........: No.FUN-CB0087 12/12/20 By fengrui 倉庫單據理由碼改善
# Modify.........: No:FUN-CC0095 13/01/16 By bart 修改整批寫入img_file
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No:CHI-D20014 13/02/21 By nanbing 設限倉庫控卡 不需处理，还原
# Modify.........: No.TQC-D20050 13/02/25 By fengrui 修正倉庫單據理由碼改善测试问题
# Modify.........: No:FUN-D30024 13/03/12 By fengrui 負庫存依據imd23判斷
# Modify.........: No:CHI-D20015 13/03/26 By xuxz 修改取消確認邏輯
# Modify.........: No:FUN-D30033 13/04/18 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D40103 13/05/15 By lixh1 增加儲位有效性檢查
# Modify.........: No:TQC-D50124 13/05/28 By lixh1 拿掉儲位有效性檢查
# Modify.........: No:TQC-D40078 13/04/28 By xujing 負庫存函数添加营运中心参数
# Modify.........: No:MOD-DC0095 13/12/13 By SunLM 對成本中心賦初值smy60

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
    g_tse           RECORD LIKE tse_file.*,       #單頭
    g_tse_t         RECORD LIKE tse_file.*,       #單頭(舊值)
    g_tse_o         RECORD LIKE tse_file.*,       #單頭(舊值)
    g_tse01         LIKE tse_file.tse01,   #單頭KEY
    g_tse01_t       LIKE tse_file.tse01,   #單頭KEY (舊值)
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
    g_tsf           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        tsf02       LIKE tsf_file.tsf02,   #項次
        tsf03       LIKE tsf_file.tsf03,   #產品編號
        ima02       LIKE ima_file.ima02,   #品名
        ima021      LIKE ima_file.ima021,  #規格     
        ima1002     LIKE ima_file.ima1002, #英文名稱   
        ima135      LIKE ima_file.ima135,  #條碼
        tsf12       LIKE tsf_file.tsf12,   #倉庫
        tsf13       LIKE tsf_file.tsf13,   #庫位
        tsf14       LIKE tsf_file.tsf14,   #批號
        tsf04       LIKE tsf_file.tsf04,   #單位
        tsf05       LIKE tsf_file.tsf05,   #數量
        tsf09       LIKE tsf_file.tsf09,   #單位二
        tsf10       LIKE tsf_file.tsf10,   #單位二轉換率
        tsf11       LIKE tsf_file.tsf11,   #單位二數量
        tsf06       LIKE tsf_file.tsf06,   #單位一
        tsf07       LIKE tsf_file.tsf07,   #單位一轉換率
        tsf08       LIKE tsf_file.tsf08,   #單位一數量
        tsf15       LIKE tsf_file.tsf15,   #備注
        tsfud01 LIKE tsf_file.tsfud01,
        tsfud02 LIKE tsf_file.tsfud02,
        tsfud03 LIKE tsf_file.tsfud03,
        tsfud04 LIKE tsf_file.tsfud04,
        tsfud05 LIKE tsf_file.tsfud05,
        tsfud06 LIKE tsf_file.tsfud06,
        tsfud07 LIKE tsf_file.tsfud07,
        tsfud08 LIKE tsf_file.tsfud08,
        tsfud09 LIKE tsf_file.tsfud09,
        tsfud10 LIKE tsf_file.tsfud10,
        tsfud11 LIKE tsf_file.tsfud11,
        tsfud12 LIKE tsf_file.tsfud12,
        tsfud13 LIKE tsf_file.tsfud13,
        tsfud14 LIKE tsf_file.tsfud14,
        tsfud15 LIKE tsf_file.tsfud15
                    END RECORD,
    g_tsf_t         RECORD                 #程式變數 (舊值)
        tsf02       LIKE tsf_file.tsf02,   #項次
        tsf03       LIKE tsf_file.tsf03,   #產品編號
        ima02       LIKE ima_file.ima02,   #品名
        ima021      LIKE ima_file.ima021,  #規格     
        ima1002     LIKE ima_file.ima1002, #英文名稱   
        ima135      LIKE ima_file.ima135,  #條碼
        tsf12       LIKE tsf_file.tsf12,   #倉庫
        tsf13       LIKE tsf_file.tsf13,   #庫位
        tsf14       LIKE tsf_file.tsf14,   #批號
        tsf04       LIKE tsf_file.tsf04,   #單位
        tsf05       LIKE tsf_file.tsf05,   #數量
        tsf09       LIKE tsf_file.tsf09,   #單位二
        tsf10       LIKE tsf_file.tsf10,   #單位二轉換率
        tsf11       LIKE tsf_file.tsf11,   #單位二數量
        tsf06       LIKE tsf_file.tsf06,   #單位一
        tsf07       LIKE tsf_file.tsf07,   #單位一轉換率
        tsf08       LIKE tsf_file.tsf08,   #單位一數量
        tsf15       LIKE tsf_file.tsf15,   #備注
        tsfud01 LIKE tsf_file.tsfud01,
        tsfud02 LIKE tsf_file.tsfud02,
        tsfud03 LIKE tsf_file.tsfud03,
        tsfud04 LIKE tsf_file.tsfud04,
        tsfud05 LIKE tsf_file.tsfud05,
        tsfud06 LIKE tsf_file.tsfud06,
        tsfud07 LIKE tsf_file.tsfud07,
        tsfud08 LIKE tsf_file.tsfud08,
        tsfud09 LIKE tsf_file.tsfud09,
        tsfud10 LIKE tsf_file.tsfud10,
        tsfud11 LIKE tsf_file.tsfud11,
        tsfud12 LIKE tsf_file.tsfud12,
        tsfud13 LIKE tsf_file.tsfud13,
        tsfud14 LIKE tsf_file.tsfud14,
        tsfud15 LIKE tsf_file.tsfud15
                    END RECORD,
    g_tsf_o         RECORD                 #程式變數 (舊值)
        tsf02       LIKE tsf_file.tsf02,   #項次
        tsf03       LIKE tsf_file.tsf03,   #產品編號
        ima02       LIKE ima_file.ima02,   #品名
        ima021      LIKE ima_file.ima021,  #規格     
        ima1002     LIKE ima_file.ima1002, #英文名稱   
        ima135      LIKE ima_file.ima135,  #條碼
        tsf12       LIKE tsf_file.tsf12,   #倉庫
        tsf13       LIKE tsf_file.tsf13,   #庫位
        tsf14       LIKE tsf_file.tsf14,   #批號
        tsf04       LIKE tsf_file.tsf04,   #單位
        tsf05       LIKE tsf_file.tsf05,   #數量
        tsf09       LIKE tsf_file.tsf09,   #單位二
        tsf10       LIKE tsf_file.tsf10,   #單位二轉換率
        tsf11       LIKE tsf_file.tsf11,   #單位二數量
        tsf06       LIKE tsf_file.tsf06,   #單位一
        tsf07       LIKE tsf_file.tsf07,   #單位一轉換率
        tsf08       LIKE tsf_file.tsf08,   #單位一數量
        tsf15       LIKE tsf_file.tsf15,   #備注
        tsfud01 LIKE tsf_file.tsfud01,
        tsfud02 LIKE tsf_file.tsfud02,
        tsfud03 LIKE tsf_file.tsfud03,
        tsfud04 LIKE tsf_file.tsfud04,
        tsfud05 LIKE tsf_file.tsfud05,
        tsfud06 LIKE tsf_file.tsfud06,
        tsfud07 LIKE tsf_file.tsfud07,
        tsfud08 LIKE tsf_file.tsfud08,
        tsfud09 LIKE tsf_file.tsfud09,
        tsfud10 LIKE tsf_file.tsfud10,
        tsfud11 LIKE tsf_file.tsfud11,
        tsfud12 LIKE tsf_file.tsfud12,
        tsfud13 LIKE tsf_file.tsfud13,
        tsfud14 LIKE tsf_file.tsfud14,
        tsfud15 LIKE tsf_file.tsfud15
                    END RECORD,
    g_tse041        LIKE tse_file.tse041,
    g_tsf041        LIKE tsf_file.tsf041,
    g_wc,g_wc2,g_sql    string,
    g_rec_b         LIKE type_file.num5,                #單身筆數             #No.FUN-680120 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680120 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5        #No.FUN-680120 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE   g_chr2          LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE   g_chr3          LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE   g_approve       LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)  #No.TQC-640116
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_cnt1          LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10          #No.FUN-680120 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10          #No.FUN-680120 INTEGER
 
DEFINE   g_jump         LIKE type_file.num10          #No.FUN-680120 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE g_argv1	LIKE oea_file.oea01                   #No.FUN-680120 VARCHAR(16)           #No.TQC-630072
DEFINE g_argv2  STRING              #No.TQC-630072
DEFINE l_table        STRING                                                                                                        
DEFINE g_str          STRING                                                                                                        
DEFINE l_sql          STRING                                                                                                        
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
DEFINE g_mm         LIKE type_file.num5
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
DEFINE g_tse04_t           LIKE tse_file.tse04
DEFINE g_tse06_t           LIKE tse_file.tse06
DEFINE g_tse09_t           LIKE tse_file.tse09
DEFINE g_tsf04_t           LIKE tsf_file.tsf04
DEFINE g_tsf06_t           LIKE tsf_file.tsf06
DEFINE g_tsf09_t           LIKE tsf_file.tsf09
#No.FUN-BB0086--add--end--
#DEFINE l_img_table        STRING             #FUN-C70087 #FUN-CC0095
#DEFINE l_imgg_table       STRING             #FUN-C70087 #FUN-CC0095
#DEFINE g_sma894           LIKE  type_file.chr1   #FUN-C80107 add #FUN-D30024 mark
DEFINE g_imd23             LIKE  type_file.chr1   #FUN-D30024 add

MAIN
DEFINE
    p_row,p_col     LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
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
   #CALL s_padd_img_create() RETURNING l_img_table   #FUN-C70087 #FUN-CC0095
   #CALL s_padd_imgg_create() RETURNING l_imgg_table #FUN-C70087 #FUN-CC0095
   LET g_sql = "tse01.tse_file.tse01,",                                                                                             
               "tse02.tse_file.tse02,",                                                                                             
               "tse15.tse_file.tse15,",                                                                                             
               "gem02.gem_file.gem02,",                                                                                             
               "tse17.tse_file.tse17,",                                                                                             
               "azf03.azf_file.azf03,",                                                                                             
               "tse12.tse_file.tse12,",                                                                                             
               "imd02.imd_file.imd02,",                                                                                             
               "imd02a.imd_file.imd02,",                                                                                            
               "ime03.ime_file.ime03,",                                                                                             
               "ime03e.ime_file.ime03,",                                                                                            
               "tse13.tse_file.tse13,",                                                                                             
               "tse14.tse_file.tse14,",                                                                                             
               "tse03.tse_file.tse03,",                                                                                             
               "tse04.tse_file.tse04,",                                                                                             
               "tse05.tse_file.tse05,",                                                                                             
               "tse18.tse_file.tse18,",                                                                                             
               "tsf02.tsf_file.tsf02,",                                                                                             
               "tsf03.tsf_file.tsf03,",                                                                                             
               "ima02.ima_file.ima02,",                                                                                             
               "ima02a.ima_file.ima02,",    
               "tsf12.tsf_file.tsf12,",                                                                                             
               "tsf13.tsf_file.tsf13,",                                                                                             
               "tsf14.tsf_file.tsf14,",                                                                                             
               "tsf04.tsf_file.tsf04,",                                                                                             
               "tsf05.tsf_file.tsf05,",                                                                                             
               "tsf15.tsf_file.tsf15"                                                                                               
   LET l_table = cl_prt_temptable('atmt261',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",                                                                                    
               "        ?,?,?,?,?, ?,?,?,?,?, ",                                                                                    
               "        ?,?,?,?,?, ?,?)"                                                                                            
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
 
 
    LET g_forupd_sql = " SELECT * FROM tse_file WHERE tse01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t261_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 4 LET p_col = 4
    OPEN WINDOW t261_w AT p_row,p_col
        WITH FORM "atm/42f/atmt261"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()
#   CALL cl_set_comp_visible("tse20",g_aza.aza88 = 'Y')  #No.FUN-A50071  #TQC-C20161 mark
    CALL cl_set_comp_visible("tse20",FALSE)              #TQC-C20161 add 

    LET g_wc2 = ' 1=1'
    IF g_sma.sma115 = 'Y' THEN
       CALL cl_set_comp_visible("tse04,tse05",FALSE)
       CALL cl_set_comp_visible("tsf04,tsf05",FALSE)
    ELSE
       CALL cl_set_comp_visible("tse06,tse07,tse08",FALSE)
       CALL cl_set_comp_visible("tse09,tse10,tse11",FALSE)
       CALL cl_set_comp_visible("tsf06,tsf07,tsf08",FALSE)
       CALL cl_set_comp_visible("tsf09,tsf10,tsf11",FALSE)
    END IF
    CALL cl_set_comp_visible("tse07,tse10",FALSE)
    CALL cl_set_comp_visible("tsf07,tsf10",FALSE)

    CALL cl_set_comp_visible("Page1,Page3",g_sma.sma95="Y")            #FUN-C80065 add
    CALL cl_set_act_visible("qry_lot_detail,qry_lot_header",g_sma.sma95="Y")  #FUN-C80065 add  

 
    IF g_azw.azw04 <> '2' THEN
       CALL cl_set_comp_visible('tseplant,tseplant_desc,tsecond,tseconu,tseconu_desc,tsecont',FALSE)
    END IF
        
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t261_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t261_a()
            END IF
         OTHERWISE
               CALL t261_q()
      END CASE
   END IF
 
    CALL t261_menu()
    CLOSE WINDOW t261_w                 #結束畫面
    #CALL s_padd_img_drop(l_img_table)   #FUN-C70087 #FUN-CC0095
    #CALL s_padd_imgg_drop(l_imgg_table) #FUN-C70087 #FUN-CC0095
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
#QBE 查詢資料
FUNCTION t261_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_tsf.clear()
 
  IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN 
     LET g_wc = " tse01 = '",g_argv1,"'"
     LET g_wc2 = " 1=1"
  ELSE  
     CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_tse.* TO NULL    #No.FUN-750051
     CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
                       tse01,tse02,
                       tse21,                 #MOD-AA0167                       
                       tse17,tse15,tse16,tseconf,
                       tsepost,tsecond,tseconu,tsecont,tseplant,tse03,tse12,tse13,tse14,tse20,tse04,tse05, #FUN-870100 ADD
                       tse09,tse11,tse06,tse08,tse19,tse18,  #No.FUN-930140 #No.FUN-A50071 add tse20
                       tseuser,tsegrup,tsemodu,tsedate,tseacti,
                       tseoriu,tseorig,                        #TQC-A30048 ADD             
                       tseud01,tseud02,tseud03,tseud04,tseud05,
                       tseud06,tseud07,tseud08,tseud09,tseud10,
                       tseud11,tseud12,tseud13,tseud14,tseud15
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
 
     ON ACTION controlp 
           CASE
               WHEN INFIELD(tse01) #組合單號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_tse"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tse01 
                 NEXT FIELD tse01
               WHEN INFIELD(tse17)    #理由碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_azf01"      #No.FUN-6B0065
                 LET g_qryparam.arg1 ="1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tse17
                 NEXT FIELD tse17
               WHEN INFIELD(tse15)    #部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_gem"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tse15
                 NEXT FIELD tse15
               WHEN INFIELD(tse16)    #部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_gen"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tse16
                 NEXT FIELD tse16
               WHEN INFIELD(tse03)    #組合產品編號
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.state= "c"
#                LET g_qryparam.form = "q_ima01"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima01","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------

                 DISPLAY g_qryparam.multiret TO tse03
                 NEXT FIELD tse03
               WHEN INFIELD(tse12)    #倉庫
                #FUN-AB0015  --modify
                #CALL cl_init_qry_var()
                #LET g_qryparam.state= "c"
                #LET g_qryparam.form = "q_imd01"
                #CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
                #FUN-AB0015  --end
                 DISPLAY g_qryparam.multiret TO tse12
                 NEXT FIELD tse12
               WHEN INFIELD(tse13)    #儲位
                #FUN-AB0015  --modify
                #CALL cl_init_qry_var()
                #LET g_qryparam.state= "c"
                #LET g_qryparam.form = "q_ime"
                #LET g_qryparam.arg1 = g_tse.tse12
                #LET g_qryparam.arg2 = 'SW'
                #CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_ime_1(TRUE,TRUE,"","g_tse.tse12","",g_plant,"","","") RETURNING g_qryparam.multiret
                #FUN-AB0015  --end
                 DISPLAY g_qryparam.multiret TO tse13
                 NEXT FIELD tse13
               WHEN INFIELD(tse14)    #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_img"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tse14
                 NEXT FIELD tse14
               WHEN INFIELD(tse04)    #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tse04
                 NEXT FIELD tse04
               WHEN INFIELD(tse09)    #單位二
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tse09
                 NEXT FIELD tse09
               WHEN INFIELD(tse06)    #單位一
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tse06
                 NEXT FIELD tse06
               WHEN INFIELD(tseconu)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_tseconu"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tseconu
                 NEXT FIELD tseconu
 
               WHEN INFIELD(tse19)    #工單單號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_tse19"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tse19
                 NEXT FIELD tse19
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
 
     CONSTRUCT g_wc2 ON tsf02,tsf03,tsf12,tsf13,tsf14,   #螢幕上取單身條件
                        tsf04,tsf05,tsf09,tsf11,tsf06,tsf08,tsf15
                        ,tsfud01,tsfud02,tsfud03,tsfud04,tsfud05
                        ,tsfud06,tsfud07,tsfud08,tsfud09,tsfud10
                        ,tsfud11,tsfud12,tsfud13,tsfud14,tsfud15
            FROM s_tsf[1].tsf02,s_tsf[1].tsf03,s_tsf[1].tsf12,
                 s_tsf[1].tsf13,s_tsf[1].tsf14,s_tsf[1].tsf04,
                 s_tsf[1].tsf05,s_tsf[1].tsf09,s_tsf[1].tsf11,
                 s_tsf[1].tsf06,s_tsf[1].tsf08,s_tsf[1].tsf15
                 ,s_tsf[1].tsfud01,s_tsf[1].tsfud02,s_tsf[1].tsfud03,s_tsf[1].tsfud04,s_tsf[1].tsfud05
                 ,s_tsf[1].tsfud06,s_tsf[1].tsfud07,s_tsf[1].tsfud08,s_tsf[1].tsfud09,s_tsf[1].tsfud10
                 ,s_tsf[1].tsfud11,s_tsf[1].tsfud12,s_tsf[1].tsfud13,s_tsf[1].tsfud14,s_tsf[1].tsfud15
                 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION controlp  #ok
            CASE
               WHEN INFIELD(tsf03)    #組合產品編號
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.state= "c"
#                LET g_qryparam.form = "q_ima01"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima01","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO tsf03
                 NEXT FIELD tsf03
               WHEN INFIELD(tsf12)    #倉庫
                #FUN-AB0015  --modify
                #CALL cl_init_qry_var()
                #LET g_qryparam.state= "c"
                #LET g_qryparam.form = "q_imd01"
                #CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
                #FUN-AB0015  --end
                 DISPLAY g_qryparam.multiret TO tsf12
                 NEXT FIELD tsf12
               WHEN INFIELD(tsf13)    #儲位
                #FUN-AB0015  --modify
                #CALL cl_init_qry_var()
                #LET g_qryparam.state= "c"
                #LET g_qryparam.form = "q_ime"
                #CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","") RETURNING g_qryparam.multiret
                #FUN-AB0015  --end
                 DISPLAY g_qryparam.multiret TO tsf13     #No.TQC-6B0104
                 NEXT FIELD tsf13                         #No.TQC-6B0104 
               WHEN INFIELD(tsf14)    #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_img"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tsf14
                 NEXT FIELD tsf14
               WHEN INFIELD(tsf04)    #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tsf04
                 NEXT FIELD tsf04
               WHEN INFIELD(tsf09)    #單位二
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tsf09
                 NEXT FIELD tsf09
               WHEN INFIELD(tsf06)    #單位一
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tsf06
                 NEXT FIELD tsf06
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
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tseuser', 'tsegrup')
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  tse01 FROM tse_file ",
                   " WHERE ", g_wc CLIPPED,
                   "   AND tseplant IN ",g_auth,         #FUN-870100  
                   " ORDER BY tse01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE tse_file. tse01 ",
                   "  FROM tse_file,tsf_file ",
                   " WHERE tse01 = tsf01",
                   "   AND tseplant IN ",g_auth,         #FUN-870100
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY tse01"
    END IF
 
    PREPARE t261_prepare FROM g_sql
    DECLARE t261_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t261_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM tse_file WHERE ",
                  " tseplant IN ",g_auth,                #FUN-870100                          
                  " AND ",g_wc CLIPPED 
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT tse01) ",
                  "FROM tse_file,tsf_file ",
                  "WHERE tsf01=tse01 ",
                  " AND  tseplant IN ",g_auth,   #FUN-870100
                  " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t261_precount FROM g_sql
    DECLARE t261_count CURSOR FOR t261_precount
END FUNCTION
 
FUNCTION t261_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(100)
 
   WHILE TRUE
      CALL t261_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL t261_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t261_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL t261_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL t261_u()
            END IF
         WHEN "reproduce" 
            IF cl_chk_act_auth() THEN
               CALL t261_copy()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t261_b()
               CALL t261_show ()   #CHI-C30106 add
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "related_document"                                     
            IF cl_chk_act_auth()  THEN                                       
               IF g_tse.tse01 IS NOT NULL THEN                     
                 LET g_doc.column1 = "tse01"                         
                 LET g_doc.value1 = g_tse.tse01                                 
                 CALL cl_doc()                                                  
               END IF                                                   
            END IF  
                                                        
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_tsf),'','')
             END IF
 
         WHEN "confirm"                                                
            IF cl_chk_act_auth() THEN     
               CALL t261_y()
            END IF 
 
         WHEN "unconfirm" #取消審核
            IF cl_chk_act_auth() THEN     
               CALL t261_z()
            END IF 
 
         WHEN "post"     #過帳    
            IF cl_chk_act_auth() THEN     
               CALL t261_post()
            END IF
 
         WHEN "undo_post"     #過帳還原
            IF cl_chk_act_auth() THEN     
               CALL t261_undo_post()
            END IF
 
         WHEN "void" 
            IF cl_chk_act_auth() THEN
               CALL t261_void(1)
            END IF
 
         #FUN-D20039 --------------sta
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t261_void(2)
            END IF
         #FUN-D20039 --------------end
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t261_out()        
            END IF

         #CHI-A70027 add --start--
         WHEN "qry_lot_header"     #單頭批/序號查詢
            IF cl_chk_act_auth() THEN     
               CALL t261_qry_lot_header()
            END IF

         WHEN "qry_lot_detail"     #單身批/序號查詢
            IF l_ac > 0 THEN
               LET g_ima918 = ''
               LET g_ima921 = ''
               SELECT ima918,ima921 INTO g_ima918,g_ima921 
                 FROM ima_file
                WHERE ima01 = g_tsf[l_ac].tsf03
                  AND imaacti = "Y"
           
               IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  CALL t261_ima25(g_tsf[l_ac].tsf03,g_tsf[l_ac].tsf12,g_tsf[l_ac].tsf13,g_tsf[l_ac].tsf14,g_tsf[l_ac].tsf04)                   
#TQC-B90236--mark--begin
#                 CALL s_lotin(g_prog,g_tse.tse01,g_tsf[l_ac].tsf02,0,
#                               g_tsf[l_ac].tsf03,g_tsf[l_ac].tsf04,g_ima25,
#                               g_ima25_fac,g_tsf[l_ac].tsf05,'','QRY')
#TQC-B90236--mark--end
#TQC-B90236--add---begin
                  CALL s_mod_lot(g_prog,g_tse.tse01,g_tsf[l_ac].tsf02,0,
                                 g_tsf[l_ac].tsf03,g_tsf[l_ac].tsf12,
                                 g_tsf[l_ac].tsf13,g_tsf[l_ac].tsf14,
                                 g_tsf[l_ac].tsf04,g_ima25,g_ima25_fac,g_tsf[l_ac].tsf05,'','QRY',1) 
#TQC-B90236--add---end
                       RETURNING l_r,g_qty
               END IF
            END IF
         #CHI-A70027 add --end--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t260_tseplant(p_cmd)
DEFINE  p_cmd        LIKE type_file.chr1
DEFINE  l_tseplant_desc LIKE gem_file.gem02
 
  SELECT azp02 INTO l_tseplant_desc FROM azp_file WHERE azp01 = g_plant  
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_tseplant_desc TO FORMONLY.tseplant_desc
  END IF
 
END FUNCTION
 
FUNCTION t260_tseconu(p_cmd)
DEFINE  p_cmd        LIKE type_file.chr1
DEFINE  l_tseconu_desc LIKE gen_file.gen02
 
  SELECT gen02 INTO l_tseconu_desc FROM gen_file WHERE gen01 = g_tse.tseconu AND genacti='Y'
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_tseconu_desc TO FORMONLY.tseconu_desc
  END IF
 
END FUNCTION
 
#Add  輸入
FUNCTION t261_a()
DEFINE li_result     LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE l_ima55       LIKE ima_file.ima55,
       l_ima907      LIKE ima_file.ima907
 
    MESSAGE ""
    CLEAR FORM
    CALL g_tsf.clear()
 
 
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_tse.* LIKE tse_file.*             #DEFAULT 設置
    LET g_tse01_t = NULL
    LET g_tse_t.* = g_tse.*
    LET g_tse_o.* = g_tse.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_tse.tse02=g_today            #組合日期
        LET g_tse.tse21=g_today            #MOD-AA0167        
        LET g_tse.tseconf='N'              #審核碼
        LET g_tse.tsecond=''               #FUN-870100
        LET g_tse.tseconu=''               #FUN-870100
        LET g_tse.tsecont=''               #FUN-870100
        LET g_tse.tsepost='N'              #過帳碼
        LET g_tse.tse05=0
        LET g_tse.tseplant = g_plant #FUN-980009
        LET g_tse.tselegal = g_legal #FUN-980009
        LET g_tse.tseoriu = g_user      #No.FUN-980030 10/01/04
        LET g_tse.tseorig = g_grup      #No.FUN-980030 10/01/04
        LET g_tse.tse08=0
        LET g_tse.tse11=0
        LET g_tse.tseuser=g_user
        LET g_data_plant = g_plant #FUN-980030
        LET g_tse.tsegrup=g_grup
        LET g_tse.tsedate=g_today
        LET g_tse.tseacti='Y'              #資料有效
        LET g_tse.tseplant=g_plant 
        DISPLAY g_tse.tseplant TO tseplant
        CALL t260_tseplant('a')
        DISPLAY g_tse.tsecond TO tsecond
        DISPLAY g_tse.tseconu TO tseconu
        DISPLAY g_tse.tsecont TO tsecont
 
      IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
         LET g_tse.tse01 = g_argv1
      END IF
        
        CALL t261_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #用戶不玩了
            INITIALIZE g_tse.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_tse.tse01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        BEGIN WORK
 
    #    CALL s_auto_assign_no("aim",g_tse.tse01,g_tse.tse02,"G","tse_file","tse01","","","")              #FUN-AA0046  mark
         CALL s_auto_assign_no("atm",g_tse.tse01,g_tse.tse02,"U7","tse_file","tse01","","","")              #FUN-AA0046
             RETURNING li_result,g_tse.tse01
        IF (NOT li_result) THEN                                                                                                     
           CONTINUE WHILE                                                                                                           
        END IF                                                                                                                      
        DISPLAY g_tse.tse01 TO tse01   
 
        INSERT INTO tse_file VALUES (g_tse.*)
        IF SQLCA.sqlcode THEN                 #置入資料庫不成功
            CALL cl_err3("ins","tse_file",g_tse.tse01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104         #FUN-B80061    ADD
            ROLLBACK WORK
           # CALL cl_err3("ins","tse_file",g_tse.tse01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104        #FUN-B80061    MARK
            CONTINUE WHILE
        ELSE 
        COMMIT WORK
        CALL cl_flow_notify(g_tse.tse01,'I')
        END IF
        CALL t261_modi_lot_header() #CHI-A70027 add 
        SELECT tse01 INTO g_tse.tse01 FROM tse_file
            WHERE tse01 = g_tse.tse01
        LET g_tse01_t = g_tse.tse01        #保留舊值
        LET g_tse_t.* = g_tse.*
        LET g_tse_o.* = g_tse.*
        LET g_rec_b=0
        CALL t261_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t261_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_tse.tse01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_tse.* FROM tse_file WHERE tse01=g_tse.tse01
    IF g_tse.tsepost='Y' THEN CALL cl_err(g_tse.tse01,'afa-101',0) RETURN END IF
    IF g_tse.tseconf='Y' THEN CALL cl_err(g_tse.tse01,'axm-101',0) RETURN END IF  
    IF g_tse.tseconf='X' THEN
       IF g_tse.tseacti='Y' THEN            #若資料還有效
          CALL cl_err(g_tse.tse01,'9024',0)
          RETURN
       ELSE                                 #資料也已無效
          CALL cl_err(g_tse.tse01,'mfg1000',0)
          RETURN
       END IF    
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_tse01_t = g_tse.tse01
    BEGIN WORK
 
    OPEN t261_cl USING g_tse.tse01
    IF STATUS THEN
       CALL cl_err("OPEN t261_cl:", STATUS, 1)
       CLOSE t261_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t261_cl INTO g_tse.*            # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tse.tse01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t261_cl
        RETURN
    END IF
    CALL t261_show()
    WHILE TRUE
        LET g_tse01_t = g_tse.tse01
        LET g_tse_o.* = g_tse.*
        LET g_tse.tsemodu=g_user
        LET g_tse.tsedate=g_today
        CALL t261_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_tse.*=g_tse_t.*
            CALL t261_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_tse.tse01 != g_tse01_t THEN            # 更改單號
            UPDATE tsf_file SET tsf01 = g_tse.tse01
                WHERE tsf01 = g_tse01_t
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","tsf_file",g_tse01_t,"",SQLCA.sqlcode,"","tsf",1)  #No.FUN-660104
               CONTINUE WHILE
            END IF
        END IF
      UPDATE tse_file SET tse_file.* = g_tse.*
       WHERE tse01 = g_tse01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","tse_file",g_tse.tse01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
            CONTINUE WHILE
        END IF
        
        EXIT WHILE
    END WHILE
    CLOSE t261_cl
    COMMIT WORK
    CALL cl_flow_notify(g_tse.tse01,'U')
END FUNCTION
 
#處理INPUT
FUNCTION t261_i(p_cmd)
DEFINE
    l_pmc05   LIKE pmc_file.pmc05,
    l_pmc30   LIKE pmc_file.pmc30,
    l_n,l_i   LIKE type_file.num5,          #No.FUN-680120 SMALLINT
    p_cmd           LIKE type_file.chr1     #a:輸入 u:更改        #No.FUN-680120 VARCHAR(1)
DEFINE l_code LIKE type_file.num5               #No.FUN-680120 SMALLINT
DEFINE li_result   LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE l_ima63     LIKE ima_file.ima63,
       l_ima63_fac LIKE ima_file.ima63_fac,
       l_ima35     LIKE ima_file.ima35, 
       l_ima36     LIKE ima_file.ima36, 
       l_ima55     LIKE ima_file.ima55, 
       l_ima906    LIKE ima_file.ima906,
       l_ima907    LIKE ima_file.ima907,
       sn1,sn2     LIKE type_file.num5           #No.FUN-680120 SMALLINT
 
 
    IF s_shut(0) THEN RETURN END IF
 
    DISPLAY BY NAME 
        g_tse.tse01,g_tse.tse02,g_tse.tse17,g_tse.tse15, 
        g_tse.tse16,g_tse.tseconf,g_tse.tsepost,g_tse.tsecond,g_tse.tseconu,g_tse.tsecont,g_tse.tseplant,g_tse.tse03, #FUN-870100
        g_tse.tse12,g_tse.tse13,g_tse.tse14,g_tse.tse20,g_tse.tse04,g_tse.tse05,  #No.FUN-A50071 add tse20
        g_tse.tse09,g_tse.tse11,g_tse.tse06,g_tse.tse08,g_tse.tse18,
        g_tse.tse19,     #No.FUN-930140  
        g_tse.tseuser,g_tse.tsegrup,g_tse.tsemodu,g_tse.tsedate,g_tse.tseacti,
        g_tse.tseoriu,g_tse.tseorig,                        #TQC-A30048 ADD
        g_tse.tseud01,g_tse.tseud02,g_tse.tseud03,g_tse.tseud04,
        g_tse.tseud05,g_tse.tseud06,g_tse.tseud07,g_tse.tseud08,
        g_tse.tseud09,g_tse.tseud10,g_tse.tseud11,g_tse.tseud12,
        g_tse.tseud13,g_tse.tseud14,g_tse.tseud15 
       ,g_tse.tse21                                      #MOD-AA0167         
        
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME 
        g_tse.tse01,g_tse.tse02,
        g_tse.tse21,             #MOD-AA0167        
        g_tse.tse17,g_tse.tse15, 
        g_tse.tse16,g_tse.tseconf,g_tse.tsepost,g_tse.tse03,
        g_tse.tse12,g_tse.tse13,g_tse.tse14,g_tse.tse20,g_tse.tse04,g_tse.tse05,  #No.FUN-A50071 add tse20
        g_tse.tse09,g_tse.tse11,g_tse.tse06,g_tse.tse08,g_tse.tse19,  #No.FUN-930140
        g_tse.tse18,
        g_tse.tseuser,g_tse.tsegrup,g_tse.tsemodu,g_tse.tsedate,g_tse.tseacti,
        g_tse.tseud01,g_tse.tseud02,g_tse.tseud03,g_tse.tseud04,
        g_tse.tseud05,g_tse.tseud06,g_tse.tseud07,g_tse.tseud08,
        g_tse.tseud09,g_tse.tseud10,g_tse.tseud11,g_tse.tseud12,
        g_tse.tseud13,g_tse.tseud14,g_tse.tseud15 
                      WITHOUT DEFAULTS 
       
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t261_set_entry(p_cmd)
            CALL t261_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_set_comp_entry("tse09,tse11",TRUE)
            CALL cl_set_act_visible("modi_lot_header",g_sma.sma95="Y")  #FUN-C80065 add
            CALL cl_set_docno_format("tse01")
            IF p_cmd = 'u' THEN                                                                                                     
              IF g_sma.sma115='Y' THEN                                                                                              
                 CALL t261_du_default(p_cmd)                                                                                        
              END IF                                                                                                                
            END IF  
         #No.FUN-BB0086--add--begin--
         IF p_cmd = 'u' THEN 
            LET g_tse04_t = g_tse.tse04
            LET g_tse06_t = g_tse.tse06
            LET g_tse09_t = g_tse.tse09
         END IF 
         IF p_cmd = 'a' THEN 
            LET g_tse04_t = NULL 
            LET g_tse06_t = NULL 
            LET g_tse09_t = NULL 
         END IF 
         #No.FUN-BB0086--add--end--
         
        AFTER FIELD tse01
            IF NOT cl_null(g_tse.tse01) THEN
 #              CALL s_check_no("aim",g_tse.tse01,g_tse_t.tse01,"G","tse_file","tse01","")                     #FUN-AA0046  mark
                CALL s_check_no("atm",g_tse.tse01,g_tse_t.tse01,"U7","tse_file","tse01","")                     #FUN-AA0046
                    RETURNING li_result,g_tse.tse01
               DISPLAY g_tse.tse01 TO tse01
               IF (NOT li_result) THEN                                                                                                 
                  LET g_tse.tse01=g_tse_o.tse01                                                                                        
                  NEXT FIELD tse01                                                                                                     
               END IF    
            END IF

 #MOD-AA0167 --begin--
       AFTER FIELD tse21
            IF NOT cl_null(g_tse.tse21) THEN 
               IF g_sma.sma53 IS NOT NULL AND g_tse.tse21 <= g_sma.sma53 THEN 
                  CALL cl_err('','mfg9999',0)
                  NEXT FIELD CURRENT 
               END IF    
               CALL s_yp(g_tse.tse21) RETURNING g_yy,g_mm
               IF g_yy*12+g_mm > g_sma.sma51*12+g_sma.sma52 THEN #不可大於現行年月
                  CALL cl_err('','mfg6091',0)
                  NEXT FIELD CURRENT 
               END IF            
            END IF 
 #MOD-AA0167 --end--
  
        AFTER FIELD tse17
            IF NOT cl_null(g_tse.tse17) THEN
                  CALL t261_tse17('d')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_tse.tse17,g_errno,1)
                     LET g_tse.tse17 = g_tse_o.tse17
                     DISPLAY BY NAME g_tse.tse17
                     NEXT FIELD tse17
                  END IF
             END IF
 
        AFTER FIELD tse15
            IF NOT cl_null(g_tse.tse15) THEN
                  CALL t261_tse15('d')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_tse.tse15,g_errno,1)
                     LET g_tse.tse15 = g_tse_o.tse15
                     DISPLAY BY NAME g_tse.tse15
                     NEXT FIELD tse15
                  END IF
             END IF
 
        AFTER FIELD tse16
            IF NOT cl_null(g_tse.tse16) THEN
                  CALL t261_tse16('d')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_tse.tse16,g_errno,1)
                     LET g_tse.tse16 = g_tse_o.tse16
                     DISPLAY BY NAME g_tse.tse16
                     NEXT FIELD tse16
                  END IF
             END IF
            
        AFTER FIELD tse04
            IF NOT cl_null(g_tse.tse04) THEN
                 SELECT count(*) INTO l_n
                   FROM gfe_file
                  WHERE gfe01 = g_tse.tse04
                    AND gfeacti = 'Y'
                 IF l_n = 0 THEN
                    CALL cl_err(g_tse.tse04,'mfg0019',0)  #無此單位編號
                    NEXT FIELD tse04
                 END IF
                 #Check 單位與庫存明細單位換算關系并且返回換算率
                 CALL s_umfchk(g_tse.tse03,g_tse.tse04,g_img.img09)
                      RETURNING g_cnt,g_tse.tse041
                 IF g_cnt = 1 THEN
                    CALL cl_err('','mfg3075',0)
                    NEXT FIELD tse04
                 END IF
                 #No.FUN-BB0086--add--begin--
                 IF NOT cl_null(g_tse.tse05) AND g_tse.tse05<>0 THEN  #FUN-C20068
                    IF NOT t261_tse05_check(p_cmd) THEN 
                       LET g_tse04_t = g_tse.tse04
                       NEXT FIELD tse05
                    END IF                                            #FUN-C20068
                 END IF
                 LET g_tse04_t = g_tse.tse04
                 #No.FUN-BB0086--add--end--  
             END IF
            
        AFTER FIELD tse05
           IF NOT t261_tse05_check(p_cmd) THEN NEXT FIELD tse05 END IF   #No.FUN-BB0086
            #No.FUN-BB0086--mark--begin--
            #IF NOT cl_null(g_tse.tse05) THEN
            #   IF g_tse.tse05 <= 0 THEN       #MOD-9C0344
            #      CALL cl_err('','mfg9243',0)
            #      NEXT FIELD tse05
            #   END IF
            #END IF
            #
            # SELECT img10 INTO g_imgg10 FROM img_file
            #    WHERE img01=g_tse.tse03           
            #      AND img02=g_tse.tse12                          
            #      AND img03=g_tse.tse13                  
            #      AND img04=g_tse.tse14               
            # IF g_tse.tse05*g_tse.tse041 > g_imgg10 THEN
            #    CALL cl_err(g_tse.tse05,'mfg1303',1)
            #    NEXT FIELD tse05
            # END IF
            #
            # #CHI-A70027 add --start--
            # IF p_cmd = 'u' THEN 
            #    CALL t261_modi_lot_header() 
            # END IF
            # #CHI-A70027 add --end--
            #No.FUN-BB0086--mark--end--
 
        BEFORE FIELD tse09
            CALL t261_sel_ima()   #0215
            CALL cl_set_comp_required("tse06,tse08,tse09,tse11",FALSE)
 
        AFTER FIELD tse09
            IF NOT cl_null(g_tse.tse09) THEN
               SELECT count(*) INTO l_n
                 FROM gfe_file
                WHERE gfe01=g_tse.tse09
                  AND gfeacti='Y'
               IF l_n = 0 THEN
                  CALL cl_err(g_tse.tse09,'mfg0019',0)
                  NEXT FIELD tse09
               END IF
               CALL cl_set_comp_required("tse11",TRUE)
 
               #Check 單位二與生產單位的換算關系并返回換算率
               CALL s_du_umfchk(g_tse.tse03,'','','',g_img09,g_tse.tse09,g_ima906)
                    returning g_errno,g_tse.tse10
 
               CALL s_chk_imgg(g_tse.tse03,g_tse.tse12,g_tse.tse13,g_tse.tse14,g_tse.tse09)  # Check 多單位第二單位庫存明細是否存在
                    RETURNING l_code
               IF l_code THEN
                  #FUN-C80107 modify begin------------------------------------121024
                  #CALL cl_err('','atm-263',0)
                  #NEXT FIELD tse09
                 #FUN-D30024--modify--str--
                 #INITIALIZE g_sma894 TO NULL
                 #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_tse.tse12) RETURNING g_sma894
                 #IF g_sma894 = 'N' THEN
                  INITIALIZE g_imd23 TO NULL
                  CALL s_inv_shrt_by_warehouse(g_tse.tse12,g_plant) RETURNING g_imd23 #TQC-D40078 g_plant
                  IF g_imd23 = 'N' THEN
                 #FUN-D30024--modify--end--
                     CALL cl_err('','atm-263',0)
                     NEXT FIELD tse09
                  ELSE
                     IF g_sma.sma892[3,3] = 'Y' THEN
                        IF NOT cl_confirm('aim-995') THEN
                           NEXT FIELD tse09
                        END IF
                     END IF
                     CALL s_add_imgg(g_tse.tse03,g_tse.tse12,
                                     g_tse.tse13,g_tse.tse14,
                                     g_tse.tse09,g_tse.tse10,
                                     g_tse.tse01,'',0) RETURNING g_flag                                                                                       
                     IF g_flag = 1 THEN
                        NEXT FIELD tse09
                     END IF
                  END IF
                  #FUN-C80107 modify end--------------------------------------
               END IF
               DISPLAY g_tse.tse10 TO tse10
               #No.FUN-BB0086--add--begin--
               IF NOT cl_null(g_tse.tse11) AND g_tse.tse11<>0 THEN  #FUN-C20068
                  IF NOT t261_tse11_check() THEN 
                     LET g_tse09_t = g_tse.tse09
                     NEXT FIELD tse11
                  END IF 
               END IF                                               #FUN-C20068
               LET g_tse09_t = g_tse.tse09
               #No.FUN-BB0086--add--end--
            END IF
 
        BEFORE FIELD tse11
           IF cl_null(g_tse.tse03) THEN NEXT FIELD tse03 END IF                                                               
           IF g_tse.tse12 IS NULL OR g_tse.tse13 IS NULL OR                                                             
              g_tse.tse14 IS NULL THEN                                                                                        
              NEXT FIELD tse14                                                                                                      
           END IF                                                                                                                   
           IF NOT cl_null(g_tse.tse09) AND g_ima906 = '3' THEN                                                               
              CALL s_chk_imgg(g_tse.tse03,g_tse.tse12,                                                                  
                              g_tse.tse13,g_tse.tse14,                                                                  
                              g_tse.tse09) RETURNING g_flag                                                                  
              IF g_flag = 1 THEN                                                                                                    
                 IF g_sma.sma892[3,3] = 'Y' THEN                                                                                    
                    IF NOT cl_confirm('aim-995') THEN                                                                               
                       NEXT FIELD tse03                                                                                             
                    END IF                                                                                                          
                 END IF                           
                 CALL s_add_imgg(g_tse.tse03,g_tse.tse12,                                                               
                                 g_tse.tse13,g_tse.tse14,                                                               
                                 g_tse.tse09,g_tse.tse10,                                                             
                                 g_tse.tse01,'',0) RETURNING g_flag                                                                                       
                 IF g_flag = 1 THEN                                                                                                 
                    NEXT FIELD tse03                                                                                                
                 END IF                                                                                                             
              END IF                                                                                                                
           END IF     
 
 
        AFTER FIELD tse11
           IF NOT t261_tse11_check() THEN NEXT FIELD tse11 END IF   #No.FUN-BB0086
            #No.FUN-BB0086--mark--begin--
            #IF NOT cl_null(g_tse.tse11) THEN
            #   IF g_tse.tse11 <= 0 THEN         #MOD-9C0344
            #      CALL cl_err('','mfg9243',0)
            #      NEXT FIELD tse11
            #   END IF
            #   IF g_ima906='3' THEN                                                                                              
            #      IF cl_null(g_tse.tse08) OR g_tse.tse08=0 THEN  #No.CHI-960022
            #         LET g_tot=g_tse.tse11*g_tse.tse10                                                                              
            #         LET g_tse.tse08=g_tot                                                                              
            #         DISPLAY BY NAME g_tse.tse08                                                                                    
            #      END IF                                         #No.CHI-960022
            #   END IF                                                                                                            
            #   IF g_ima906 MATCHES '[23]' THEN
            #      SELECT imgg10 INTO g_imgg10_2
            #        FROM imgg_file
            #       WHERE imgg01=g_tse.tse03          
            #         AND imgg02=g_tse.tse12                     
            #         AND imgg03=g_tse.tse13
            #         AND imgg04=g_tse.tse14
            #         AND imgg09=g_tse.tse09                             
            #   END IF  
            #   IF g_tse.tse11 > g_imgg10_2 THEN                                                                      
            #      IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN                                                    
            #         CALL cl_err(g_tse.tse11,'mfg1303',1)                                                            
            #         NEXT FIELD tse11                                                                                   
            #      ELSE                                                                                                      
            #         IF NOT cl_confirm('mfg3469') THEN                                                                      
            #            NEXT FIELD tse11                                                                                  
            #         END IF                                                                                                 
            #      END IF                                                                                                    
            #   END IF
            #END IF
            #No.FUN-BB0086--mark--end--
 
        BEFORE FIELD tse06
            CALL t261_sel_ima()   #0215
            CALL cl_set_comp_required("tse06,tse08,tse09,tse11",FALSE)
 
        AFTER FIELD tse06
            IF NOT cl_null(g_tse.tse06) THEN
                 SELECT count(*) INTO l_n
                   FROM gfe_file
                  WHERE gfe01 = g_tse.tse06
                    AND gfeacti = 'Y'
                 IF l_n = 0 THEN
                    CALL cl_err(g_tse.tse06,'mfg0019',0)  #無此單位編號
                    NEXT FIELD tse06
                 END IF
                 CALL cl_set_comp_required("tse08",TRUE)
                 #Check 單位與庫存明細單位換算關系并且返回換算率
                 CALL s_du_umfchk(g_tse.tse03,'','','',g_img09,g_tse.tse06,g_ima906)
                      returning g_errno,g_tse.tse07
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_tse.tse06,g_errno,0)
                    NEXT FIELD tse06
                 END IF
  
                 IF g_ima906='2' THEN
                    CALL s_chk_imgg(g_tse.tse03,g_tse.tse12,g_tse.tse13,g_tse.tse14,g_tse.tse06)  # Check 多單位第二單位庫存明細是否存在
                         RETURNING l_code
                    IF l_code THEN
                       #FUN-C80107 modify begin------------------------------------121024
                       #CALL cl_err('','atm-263',0)
                       #NEXT FIELD tse06
                      #FUN-D30024--modify--str--
                      #INITIALIZE g_sma894 TO NULL
                      #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_tse.tse12) RETURNING g_sma894
                      #IF g_sma894 = 'N' THEN
                       INITIALIZE g_imd23 TO NULL
                       CALL s_inv_shrt_by_warehouse(g_tse.tse12,g_plant) RETURNING g_imd23 #TQC-D40078 g_plant
                       IF g_imd23 = 'N' THEN
                      #FUN-D30024--modify--end--
                          CALL cl_err('','atm-263',0)
                          NEXT FIELD tse06
                       ELSE
                          IF g_sma.sma892[3,3] = 'Y' THEN
                             IF NOT cl_confirm('aim-995') THEN
                                NEXT FIELD tse06
                             END IF
                          END IF
                          CALL s_add_imgg(g_tse.tse03,g_tse.tse12,
                                          g_tse.tse13,g_tse.tse14,
                                          g_tse.tse06,g_tse.tse07,
                                          g_tse.tse01,'',0) RETURNING g_flag                                                                                  
                          IF g_flag = 1 THEN
                             NEXT FIELD tse06
                          END IF
                       END IF
                       #FUN-C80107 modify end--------------------------------------
                    END IF
                 END IF
                 DISPLAY g_tse.tse07 TO tse07
                 IF g_ima906='2' THEN                                                                                               
                    SELECT imgg10 INTO g_imgg10_1 FROM imgg_file                                                                    
                     WHERE imgg01=g_tse.tse03 
                       AND imgg02=g_tse.tse12                                                                           
                       AND imgg03=g_tse.tse13                                                                           
                       AND imgg04=g_tse.tse14                                                                           
                       AND imgg09=g_tse.tse06                                                                           
                 ELSE                                                                                                               
                    SELECT img10 INTO g_imgg10_1 FROM img_file                                                                      
                     WHERE img01=g_tse.tse03 
                       AND img02=g_tse.tse12                                                                           
                       AND img03=g_tse.tse13                                                                           
                       AND img04=g_tse.tse14                                                                           
                 END IF  
                 #No.FUN-BB0086--add--begin--
                 IF NOT cl_null(g_tse.tse08) AND g_tse.tse08<>0 THEN  #FUN-C20068
                    IF NOT t261_tse08_check() THEN 
                       LET g_tse06_t = g_tse.tse06
                       NEXT FIELD tse08
                    END IF 
                 END IF                                               #FUN-C20068 
                 LET g_tse06_t = g_tse.tse06
                 #No.FUN-BB0086--add--end--
            END IF
            
        AFTER FIELD tse08
           IF NOT t261_tse08_check() THEN NEXT FIELD tse08 END IF   #No.FUN-BB0086
           #No.FUN-BB0086--mark--start--
           # IF NOT cl_null(g_tse.tse08) THEN
           #    IF g_tse.tse08 <= 0 THEN          #MOD-9C0344
           #       CALL cl_err('','mfg9243',0)
           #       NEXT FIELD tse08
           #    END IF
           #    IF NOT cl_null(g_tse.tse06) THEN    #0215
           #       IF g_ima906 = '2' THEN   # MATCHES '[23]' THEN        #(使用母子單位)
           #          IF g_tse.tse08 > g_imgg10_1 THEN
           #             IF g_sma.sma894[1,1] = 'N' OR g_sma.sma894[1,1] IS NULL THEN
           #                CALL cl_err(g_tse.tse08,'mfg1303',1)
           #                NEXT FIELD tse08
           #             ELSE
           #                IF NOT cl_confirm('mfg3469') THEN
           #                   NEXT FIELD tse08
           #                END IF
           #             END IF
           #           END IF
           #       ELSE
           #          IF g_tse.tse08*g_tse.tse07 > g_imgg10_1 THEN
           #             IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN
           #                CALL cl_err(g_tse.tse08,'mfg1303',1)
           #                NEXT FIELD tse08
           #             ELSE
           #                IF NOT cl_confirm('mfg3469') THEN
           #                   NEXT FIELD tse08
           #                END IF
           #             END IF
           #          END IF
           #       END IF
           #    END IF
           #    CALL t261_du_data_to_correct()
           #    CALL t261_set_origin_field()
           # END IF
           #No.FUN-BB0086--mark---end---

        BEFORE FIELD tse03
            CALL cl_set_comp_required("tse06,tse08,tse09,tse11",false)
 
        AFTER FIELD tse03                  #產品編號
            IF cl_null(g_tse.tse03) THEN
                  CALL cl_err('','aap-099',0)
                  NEXT FIELD tse03
#FUN-AA0059 ---------------------start----------------------------
            ELSE
               IF NOT s_chk_item_no(g_tse.tse03,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_tse.tse03= g_tse_t.tse03
                  NEXT FIELD tse03
               END IF
#FUN-AA0059 ---------------------end-------------------------------
            END IF
            CALL t261_sel_ima()    #0215
            IF g_sma.sma115= 'Y' AND g_ima906 = '1' THEN
               CALL cl_set_comp_entry("tse09,tse11",FALSE)
            END IF
            IF g_sma.sma115= 'Y' AND g_ima906 = '3' THEN
               CALL cl_set_comp_entry("tse11",TRUE)
               CALL cl_set_comp_entry("tse09",FALSE)
            END IF
            IF g_sma.sma115= 'Y' AND g_ima906 = '2' THEN
               CALL cl_set_comp_entry("tse09,tse11,tse06,tse08",TRUE)  
               CALL cl_set_comp_required("tse09,tse11,tse06,tse08",FALSE)
            END IF
            IF g_sma.sma115= 'Y' AND NOT cl_null(g_tse.tse09) THEN  #No.TQC-930080 add
               CALL cl_set_comp_required("tse11",TRUE)
            END IF
            IF g_sma.sma115= 'Y' AND NOT cl_null(g_tse.tse06) THEN  #No.TQC-930080 add
               CALL cl_set_comp_required("tse08",TRUE)
            END IF
 
            IF NOT cl_null(g_tse.tse03) THEN 
               IF p_cmd='a' OR (p_cmd='u' AND g_tse.tse03!=g_tse_t.tse03) THEN
                 SELECT count(*) INTO l_n FROM ima_file
                     WHERE ima01 = g_tse.tse03
                 IF l_n = 0 THEN
                     CALL cl_err(g_tse.tse03,'ams-003',0)
                     LET g_tse.tse03 = g_tse_t.tse03
                     NEXT FIELD tse03
                 ELSE
                     IF g_sma.sma115 = 'Y' THEN  #使用多單位
                        CALL s_chk_va_setting(g_tse.tse03)   #(檢查多單位使用方式是否與參數設定一致)
                           RETURNING g_flag,g_ima906,g_ima907
                        IF g_flag=1 THEN
                           NEXT FIELD tse03
                        END IF
                        IF g_ima906 = '3' THEN   #(使用參考單位)
                           LET g_tse.tse09=g_ima907
                        END IF
                     END IF
                     CALL t261_tse03('d')
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_tse.tse03,g_errno,0)
                        NEXT FIELD tse03
                     END IF
                     CALL t261_du_default(p_cmd)
                     SELECT ima35,ima36,ima63,ima63_fac INTO l_ima35,l_ima36,l_ima63,l_ima63_fac
                       FROM ima_file
                      WHERE ima01=g_tse.tse03
                     LET g_tse.tse12 = l_ima35
                     LET g_tse.tse13 = l_ima36
                     LET g_tse.tse04 = l_ima63
                     DISPLAY g_tse.tse12 TO tse12    #倉庫預設值
                     DISPLAY g_tse.tse13 TO tse13    #儲位預設值
                     DISPLAY g_tse.tse04 TO tse04    #單位預設值
                     DISPLAY g_tse.tse06 TO tse06    #單位二預設值
                     DISPLAY g_tse.tse08 TO tse08
                     DISPLAY g_tse.tse09 TO tse09   #單位二預設值
                     DISPLAY g_tse.tse10 TO tse10
                     DISPLAY g_tse.tse11 TO tse11
                  END IF
               END IF
            END IF
 
        AFTER FIELD tse12
           IF cl_null(g_tse.tse12) THEN
              NEXT FIELD tse12
           END IF
           IF g_tse.tse12 IS NULL THEN
              LET g_tse.tse12 = ' '
           END IF
           IF NOT cl_null(g_tse.tse12) THEN
             # #CHI-D20014 add sta 还原
             # #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
             # IF NOT s_chksmz(g_tse.tse03,g_tse.tse01,g_tse.tse12,g_tse.tse13) THEN
             #    NEXT FIELD tse12
             # END IF
             # #CHI-D20014 add end 还原
              CALL s_stkchk(g_tse.tse12,'A') RETURNING l_code
              IF NOT l_code THEN
                 CALL cl_err('s_stkchk','mfg1100',0) 
                 NEXT FIELD tse12
              END IF
              CALL s_swyn(g_tse.tse12) RETURNING sn1,sn2
                  IF sn1=1 AND g_tse.tse12 != g_tse_t.tse12 THEN                                                              
                     LET g_tse_t.tse12=g_tse.tse12                                                                            
                     CALL cl_err(g_tse.tse12,'mfg6080',0) NEXT FIELD tse12                                                    
                  ELSE                                                                                                              
                     IF sn2=2 AND g_tse.tse12 != g_tse_t.tse12 THEN                                                           
                        CALL cl_err(g_tse.tse12,'mfg6085',0)                                                                  
                        LET g_tse_t.tse12=g_tse.tse12                                                                         
                        NEXT FIELD tse12                                                                                            
                     END IF                                                                                                         
                  END IF                                                                                                            
                  LET sn1=0 LET sn2=0  
           END IF
#FUN-AB0015  --modify
           IF NOT s_chk_ware(g_tse.tse12) THEN
              NEXT FIELD tse12
           END IF
#FUN-AB0015  --end           
 #TQC-D50124 ---------Begin---------
       ##FUN-D40103 -------Begin--------
       #   IF NOT s_imechk(g_tse.tse12,g_tse.tse13) THEN
       #      NEXT FIELD tse13
       #   END IF
       ##FUN-D40103 -------End----------
  #TQC-D50124 ---------End-----------
 
        AFTER FIELD tse13
           IF cl_null(g_tse.tse13) THEN  #全型空白
              LET g_tse.tse13 = ' '
           END IF
           IF NOT cl_null(g_tse.tse13) THEN
             # IF NOT cl_null(g_tse.tse12) THEN #CHI-D20014 add 还原
              #------------------------------------ 檢查料號預設倉儲及單別預設倉儲    
              IF NOT s_chksmz(g_tse.tse03,g_tse.tse01,g_tse.tse12,g_tse.tse13) THEN
                 NEXT FIELD tse13
              END IF
             # END IF #CHI-D20014 add 还原
              #------>check-1  檢查該料是否可收至該倉/儲位 
              CALL s_lwyn(g_tse.tse12,g_tse.tse13)                                                                   
                   RETURNING sn1,sn2    #可用否                                                                                  
              IF sn2 = 2 THEN                                                                                                    
                 IF g_pmn38 = 'Y' THEN CALL cl_err('','mfg9132',0) END IF                                                        
              ELSE                                                                                                               
                 IF g_pmn38 = 'N' THEN CALL cl_err('','mfg9131',0) END IF                                                        
              END IF                                                                                                             
              LET sn1=0 LET sn2=0  
           END IF
        #TQC-D50124 -----Begin-----
       ##FUN-D40103 -------Begin--------
       # # IF NOT s_imechk(g_tse.tse12,g_tse.tse13) THEN
       # #    NEXT FIELD tse13
       # # END IF
       ##FUN-D40103 -------End----------
      #TQC-D50124 -----End-------
 
        AFTER FIELD tseud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tseud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tseud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tseud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tseud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tseud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tseud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tseud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tseud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tseud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tseud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tseud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tseud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tseud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tseud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
 
        AFTER FIELD tse14
            IF cl_null(g_tse.tse14) THEN
               LET g_tse.tse14=' '
            END IF
            IF NOT cl_null(g_tse.tse03) AND NOT cl_null(g_tse.tse12) THEN
              SELECT img09,img10 INTO g_img09,g_img10 FROM img_file                                                                 
               WHERE img01=g_tse.tse03 AND img02=g_tse.tse12                                                                        
                 AND img03=g_tse.tse13 AND img04=g_tse.tse14                                                                        
              IF SQLCA.sqlcode=100 THEN                                                                                             
                #FUN-C80107 modify begin------------------------121024
                #CALL cl_err3("sel","img_file",g_tse.tse03,"","mfg9051","","",1)  #No.FUN-660104
                #NEXT FIELD tse03
                #FUN-D30024--modify--str--
                #INITIALIZE g_sma894 TO NULL
                #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_tse.tse12) RETURNING g_sma894
                #IF g_sma894 = 'N' THEN
                 INITIALIZE g_imd23 TO NULL
                 CALL s_inv_shrt_by_warehouse(g_tse.tse12,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant
                 IF g_imd23 = 'N' THEN
                #FUN-D30024--modify--end--
                    CALL cl_err3("sel","img_file",g_tse.tse03,"","mfg9051","","",1)
                    NEXT FIELD tse03
                 ELSE
                    IF NOT cl_confirm('mfg1401') THEN
                       NEXT FIELD tse03
                    END IF
                    CALL s_add_img(g_tse.tse03,g_tse.tse12,
                                   g_tse.tse13,g_tse.tse14,
                                   g_tse.tse01,'0',g_tse.tse21)
                    IF g_errno='N' THEN
                       NEXT FIELD tse03
                    END IF
                 END IF
                #FUN-C80107 modify end--------------------------
              END IF                                                                                                                
              IF cl_null(g_tse.tse04) THEN                                                                                          
                 LET g_tse.tse04=g_img09                                                                                            
              END IF                    
 
              SELECT COUNT(*) INTO g_cnt FROM img_file                                                                              
               WHERE img01=g_tse.tse03                                                                                              
                 AND img02=g_tse.tse12                                                                                              
                 AND img03=g_tse.tse13                                                                                              
                 AND img04=g_tse.tse14                                                                                              
#                AND img18<g_tse.tse02             #MOD-AA0167
                 AND img18<g_tse.tse21             #MOD-AA0167
              IF g_cnt > 0 THEN                                                                                                      
                 CALL cl_err('','aim-400',0)                                                                                         
                 NEXT FIELD tse14                                                                                                    
              END IF                                                                                                                 
              IF g_sma.sma115='Y' THEN                                                                                               
                 CALL t261_du_default(p_cmd)                                                                                         
              END IF                                                                                                                 
              SELECT * INTO g_img.*    #重新取得庫存明細資料
                FROM img_file
               WHERE img01=g_tse.tse03
                 AND img02=g_tse.tse12
                 AND img03=g_tse.tse13
                 AND img04=g_tse.tse14
           END IF    
 
        AFTER INPUT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             EXIT INPUT
          END IF
          CALL t261_du_data_to_correct()
          CALL t261_set_origin_field()
          IF cl_null(g_tse.tse14) THEN
             LET g_tse.tse14=' '
          END IF
          SELECT count(*) INTO l_n FROM img_file                                                                                 
           WHERE img01=g_tse.tse03                                                                                                
             AND img02=g_tse.tse12                                                                                                
             AND img03=g_tse.tse13                                                                                                
             AND img04=g_tse.tse14                                                                                                
          IF l_n = 0 THEN                                                                                                
             CALL cl_err(g_tse.tse03,'mfg6069',0)                                                                           
             NEXT FIELD tse03                                                                                                     
          END IF 
          IF g_sma.sma115 = 'N' AND g_tse.tse05 <= 0 THEN 
             CALL cl_err('','mfg9243',0)
             NEXT FIELD tse05
          END IF
          IF g_sma.sma115 = 'Y' AND g_tse.tse08 <= 0 THEN 
             CALL cl_err('','mfg9243',0)
             NEXT FIELD tse08
          END IF
          IF g_sma.sma115 = 'Y' AND g_tse.tse11 <= 0 THEN 
             CALL cl_err('','mfg9243',0)
             NEXT FIELD tse11
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
               WHEN INFIELD(tse01) #組合單號
                 LET g_t1 = s_get_doc_no(g_tse.tse01)
                 LET g_sql = " (smy73 <> 'Y' OR smy73 is null ) "           #TQC-AC0293
                 CALL smy_qry_set_par_where(g_sql)                          #TQC-AC0293   
             #   CALL q_smy(FALSE,FALSE,g_t1,'AIM','G')  #TQC-670008       #FUN-AA0046  mark
                 CALL q_oay(FALSE,FALSE,g_t1,'U7','ATM')                    #FUN-AA0046
                      RETURNING g_tse.tse01
                 DISPLAY BY NAME g_tse.tse01
                 NEXT FIELD tse01
               WHEN INFIELD(tse17)    #理由碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azf01"      #No.FUN-6B0065
                 LET g_qryparam.arg1 ="1"
                 LET g_qryparam.default1 = g_tse.tse17
                 CALL cl_create_qry() RETURNING g_tse.tse17
                 DISPLAY BY NAME g_tse.tse17
                 NEXT FIELD tse17
               WHEN INFIELD(tse15)    #部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_tse.tse15
                 CALL cl_create_qry() RETURNING g_tse.tse15                
                 DISPLAY BY NAME g_tse.tse15
                 NEXT FIELD tse15
               WHEN INFIELD(tse16)    #部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_tse.tse16
                 CALL cl_create_qry() RETURNING g_tse.tse16             
                 DISPLAY BY NAME g_tse.tse16
                 NEXT FIELD tse16
               WHEN INFIELD(tse03)    #組合產品編號
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_ima01"
#                LET g_qryparam.default1 = g_tse.tse03
#                CALL cl_create_qry() RETURNING g_tse.tse03        
                 CALL q_sel_ima(FALSE, "q_ima01","",g_tse.tse03,"","","","","",'' ) 
                   RETURNING  g_tse.tse03
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY BY NAME g_tse.tse03
                 NEXT FIELD tse03
               WHEN INFIELD(tse12)    #倉庫
                  #FUN-C30300---begin
                  LET g_ima906 = NULL
                  SELECT ima906 INTO g_ima906 FROM ima_file
                   WHERE ima01 = g_tse.tse03
                  #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                  IF s_industry("icd") THEN  #TQC-C60028
                     CALL q_idc(FALSE,TRUE,g_tse.tse03,g_tse.tse12,g_tse.tse13,g_tse.tse14)
                     RETURNING g_tse.tse12,g_tse.tse13,g_tse.tse14
                  ELSE
                  #FUN-C30300---end
                     CALL q_img4(FALSE,FALSE,g_tse.tse03,g_tse.tse12,g_tse.tse13,g_tse.tse14,'S') 
                          RETURNING g_tse.tse12,g_tse.tse13,g_tse.tse14
                  END IF #FUN-C30300
                 DISPLAY BY NAME g_tse.tse12
                 NEXT FIELD tse12
               WHEN INFIELD(tse13)    #儲位
                  #FUN-C30300---begin
                  LET g_ima906 = NULL
                  SELECT ima906 INTO g_ima906 FROM ima_file
                   WHERE ima01 = g_tse.tse03
                  #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                  IF s_industry("icd") THEN  #TQC-C60028
                     CALL q_idc(FALSE,TRUE,g_tse.tse03,g_tse.tse12,g_tse.tse13,g_tse.tse14)
                     RETURNING g_tse.tse12,g_tse.tse13,g_tse.tse14
                  ELSE
                  #FUN-C30300---end
                     CALL q_img4(FALSE,FALSE,g_tse.tse03,g_tse.tse12,g_tse.tse13,g_tse.tse14,'S') 
                          RETURNING g_tse.tse12,g_tse.tse13,g_tse.tse14
                  END IF #FUN-C30300
                 DISPLAY BY NAME g_tse.tse13
                 NEXT FIELD tse13
               WHEN INFIELD(tse14)    #單位
                  #FUN-C30300---begin
                  LET g_ima906 = NULL
                  SELECT ima906 INTO g_ima906 FROM ima_file
                   WHERE ima01 = g_tse.tse03
                  #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                  IF s_industry("icd") THEN  #TQC-C60028
                     CALL q_idc(FALSE,TRUE,g_tse.tse03,g_tse.tse12,g_tse.tse13,g_tse.tse14)
                     RETURNING g_tse.tse12,g_tse.tse13,g_tse.tse14
                  ELSE
                  #FUN-C30300---end
                     CALL q_img4(FALSE,FALSE,g_tse.tse03,g_tse.tse12,g_tse.tse13,g_tse.tse14,'S') 
                          RETURNING g_tse.tse12,g_tse.tse13,g_tse.tse14
                  END IF #FUN-C30300
                 DISPLAY BY NAME g_tse.tse14
                 NEXT FIELD tse14
               WHEN INFIELD(tse04)    #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.arg1 = g_tse.tse04
                 CALL cl_create_qry() RETURNING g_tse.tse04
                 DISPLAY BY NAME g_tse.tse04
                 NEXT FIELD tse04
               WHEN INFIELD(tse09)    #單位二
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.arg1 = g_tse.tse09
                 CALL cl_create_qry() RETURNING g_tse.tse09
                 DISPLAY BY NAME g_tse.tse09
                 NEXT FIELD tse09
               WHEN INFIELD(tse06)    #單位一
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.arg1 = g_tse.tse06
                 CALL cl_create_qry() RETURNING g_tse.tse06
                 DISPLAY BY NAME g_tse.tse06
                 NEXT FIELD tse06
 
               WHEN INFIELD(tseconu)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.default1 = g_tse.tseconu
                    CALL cl_create_qry() RETURNING g_tse.tseconu
                    DISPLAY BY NAME g_tse.tseconu
                    CALL t260_tseconu('a')
                    NEXT FIELD tseconu
 
              OTHERWISE EXIT CASE
            END CASE

      #CHI-A70027 add --start--
      ON ACTION modi_lot_header     #單頭批/序號維護
            IF cl_chk_act_auth() THEN     
               CALL t261_modi_lot_header()
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
 
FUNCTION t261_tse17(p_cmd)  #理由碼
    DEFINE l_azf03   LIKE azf_file.azf03,
           l_azfacti LIKE azf_file.azfacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
    LET g_errno = ' '
    SELECT azf03,azfacti INTO l_azf03,l_azfacti
      FROM azf_file WHERE azf01 = g_tse.tse17
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
 
FUNCTION t261_tse15(p_cmd)  #部門
    DEFINE l_gem02   LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
    LET g_errno = ' '
    SELECT gem02,gemacti INTO l_gem02,l_gemacti
      FROM gem_file WHERE gem01 = g_tse.tse15
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-039'
                                   LET l_gem02 = NULL
         WHEN l_gemacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gem02 TO  FORMONLY.gem02  
    END IF
END FUNCTION
 
FUNCTION t261_tse16(p_cmd)  #人員
    DEFINE l_gen02   LIKE gen_file.gen02,
           l_genacti LIKE gen_file.genacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
    LET g_errno = ' '
    SELECT gen02,genacti INTO l_gen02,l_genacti
      FROM gen_file WHERE gen01 = g_tse.tse16
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aoo-017'
                                   LET l_gen02 = NULL
         WHEN l_genacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gen02 TO  FORMONLY.gen02  
    END IF
END FUNCTION
 
FUNCTION t261_tse03(p_cmd)  #
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
      FROM ima_file WHERE ima01 = g_tse.tse03
                      AND (ima130 IS NULL OR ima130<>'2')
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET l_ima02a = NULL
                                   LET l_ima021a = NULL
                                   LET l_ima1002a = NULL
                                   LET l_ima135a = NULL
         WHEN l_ima1010<>'1'       LET g_errno = 'atm-017'  #No.FUN-690025  mod
         WHEN l_imaacti='N'        LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]' LET g_errno = '9038' #No.FUN-690022 add
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_ima02a   TO  FORMONLY.ima02a
       DISPLAY l_ima021a  TO  FORMONLY.ima021a
       DISPLAY l_ima1002a TO  FORMONLY.ima1002a
       DISPLAY l_ima135a  TO  FORMONLY.ima135a
    END IF
END FUNCTION
 
FUNCTION t261_tsf03(p_cmd)  #
    DEFINE l_ima02    LIKE ima_file.ima02,
           l_ima021   LIKE ima_file.ima021,
           l_ima1002  LIKE ima_file.ima1002,
           l_ima135   LIKE ima_file.ima135,
           l_ima1010   LIKE ima_file.ima1010,
           l_imaacti   LIKE ima_file.imaacti,
           p_cmd       LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima1002,ima135,ima1010,imaacti 
      INTO l_ima02,l_ima021,l_ima1002,l_ima135,l_ima1010,l_imaacti
      FROM ima_file WHERE ima01 = g_tsf[l_ac].tsf03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET l_ima02 = NULL
                                   LET l_ima021 = NULL
                                   LET l_ima1002 = NULL
                                   LET l_ima135 = NULL
         WHEN l_ima1010<>'1'       LET g_errno = 'atm-017'   #No.FUN-690025 mod
         WHEN l_imaacti='N'        LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038' #No.FUN-690022 add
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    LET g_tsf[l_ac].ima02 = l_ima02
    LET g_tsf[l_ac].ima021= l_ima021
    LET g_tsf[l_ac].ima1002= l_ima1002
    LET g_tsf[l_ac].ima135 = l_ima135 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY g_tsf[l_ac].ima02 TO ima02
       DISPLAY g_tsf[l_ac].ima021 TO ima021
       DISPLAY g_tsf[l_ac].ima1002 TO ima1002
       DISPLAY g_tsf[l_ac].ima135 TO ima135
    END IF
END FUNCTION
 
FUNCTION t261_tsf14(p_cmd)
    DEFINE l_tsf04    LIKE tsf_file.tsf04,
           l_tsf041   LIKE tsf_file.tsf041,
           l_tsf09    LIKE tsf_file.tsf09,  
           l_tsf10    LIKE tsf_file.tsf10, 
           l_tsf06    LIKE tsf_file.tsf06, 
           l_tsf07    LIKE tsf_file.tsf07, 
           p_cmd       LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
    LET g_errno = ' '
    SELECT tsf04,tsf041,tsf09,tsf10,tsf06,tsf07
      INTO l_tsf04,l_tsf041,l_tsf09,l_tsf10,l_tsf06,l_tsf07
      FROM tsf_file WHERE tsf01 = g_tse.tse01
                      AND tsf14 = g_tsf[l_ac].tsf14
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET l_tsf04 = NULL
                                   LET l_tsf041 = NULL
                                   LET l_tsf09 = NULL
                                   LET l_tsf10 = NULL
                                   LET l_tsf06 = NULL
                                   LET l_tsf07 = NULL
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    LET g_tsf[l_ac].tsf04 = l_tsf04
    LET g_tsf[l_ac].tsf09 = l_tsf09
    LET g_tsf[l_ac].tsf10 = l_tsf10
    LET g_tsf[l_ac].tsf06 = l_tsf06
    LET g_tsf[l_ac].tsf07 = l_tsf07
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY g_tsf[l_ac].tsf04  TO  tsf04           
       DISPLAY g_tsf[l_ac].tsf09  TO  tsf09           
       DISPLAY g_tsf[l_ac].tsf10  TO  tsf10           
       DISPLAY g_tsf[l_ac].tsf06  TO  tsf06           
       DISPLAY g_tsf[l_ac].tsf07  TO  tsf07           
    END IF
END FUNCTION
 
FUNCTION t261_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("tse01",TRUE)
    END IF
 
    CALL cl_set_comp_entry("tse09,tse11",TRUE)     #0215
END FUNCTION
 
FUNCTION t261_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("tse01",FALSE)
    END IF
 
    IF g_ima906 = '1' THEN
       CALL cl_set_comp_entry("tse09,tse10,tse11",FALSE)
    END IF
    IF g_ima906 = '2' THEN
       CALL cl_set_comp_entry("tse06,tse09",FALSE)
    END IF
    #參考單位，每個料件只有一個，所以不開放讓用戶輸入  
    IF g_ima906 = '3' THEN                                                                                                          
       CALL cl_set_comp_entry("tse09",FALSE)                                                                                        
    END IF  
END FUNCTION
 
FUNCTION t261_sel_ima()
  
    SELECT ima63,ima906,ima907                                                                                                      
      INTO g_ima63,g_ima906,g_ima907                                                                                                
      FROM ima_file                                                                                                                 
     WHERE ima01=g_tse.tse03  
 
END FUNCTION
 
FUNCTION t261_sel_ima_b()
  
    SELECT ima55,ima906,ima907                                                                                                      
      INTO g_ima55,g_ima906,g_ima907                                                                                                
      FROM ima_file                                                                                                                 
     WHERE ima01=g_tsf[l_ac].tsf03
 
END FUNCTION
 
#Query 查詢
FUNCTION t261_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_tsf.clear()
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL t261_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_tse.* TO NULL
        RETURN
    END IF
    OPEN t261_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_tse.* TO NULL
    ELSE
        OPEN t261_count
        FETCH t261_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
        CALL t261_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t261_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680120 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680120 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t261_cs INTO g_tse.tse01
        WHEN 'P' FETCH PREVIOUS t261_cs INTO g_tse.tse01
        WHEN 'F' FETCH FIRST    t261_cs INTO g_tse.tse01
        WHEN 'L' FETCH LAST     t261_cs INTO g_tse.tse01
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
      FETCH ABSOLUTE g_jump t261_cs INTO g_tse.tse01
      LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tse.tse01,SQLCA.sqlcode,0)
        INITIALIZE g_tse.* TO NULL      #No.FUN-6B0079 add
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
    SELECT * INTO g_tse.* FROM tse_file WHERE tse01 = g_tse.tse01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","tse_file",g_tse.tse01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
        INITIALIZE g_tse.* TO NULL
        RETURN
    END IF
 
    CALL t261_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t261_show()
   DEFINE l_gen02  LIKE gen_file.gen02     #TQC-C80161 add 
    LET g_tse_t.* = g_tse.*                #保存單頭舊值
    LET g_tse_o.* = g_tse.*                #保存單頭舊值
    DISPLAY BY NAME                               # 顯示單頭值
        g_tse.tse01,g_tse.tse02,g_tse.tse17,g_tse.tse15,g_tse.tse16,
        g_tse.tseconf,g_tse.tsepost,g_tse.tsecond,g_tse.tseconu,g_tse.tsecont,g_tse.tseplant,g_tse.tse03,g_tse.tse12,g_tse.tse13, #FUN-870100
        g_tse.tse14,g_tse.tse20,g_tse.tse04,g_tse.tse05,g_tse.tse09,g_tse.tse10,g_tse.tse11,  #No.FUN-A50071 add tse20
        g_tse.tse06,g_tse.tse07,g_tse.tse08,g_tse.tse18,g_tse.tseuser,
        g_tse.tse19,            #No.FUN-930140
        g_tse.tseoriu,g_tse.tseorig,                 #TQC-A30048 ADD
        g_tse.tsegrup,g_tse.tsemodu,g_tse.tsedate,g_tse.tseacti,
        g_tse.tseud01,g_tse.tseud02,g_tse.tseud03,g_tse.tseud04,
        g_tse.tseud05,g_tse.tseud06,g_tse.tseud07,g_tse.tseud08,
        g_tse.tseud09,g_tse.tseud10,g_tse.tseud11,g_tse.tseud12,
        g_tse.tseud13,g_tse.tseud14,g_tse.tseud15 
       ,g_tse.tse21                #MOD-AA0167        
        
    CALL t261_tse17('d')    
    CALL t261_tse15('d')    
    CALL t261_tse16('d')    
    CALL t261_tse03('d')   
    CALL t260_tseplant('d')   #FUN-870100  
   #TQC-C80161 add begin ---
    SELECT gen02 INTO l_gen02
      FROM gen_file
     WHERE gen01 = g_tse.tseconu
    DISPLAY l_gen02 TO FORMONLY.tseconu_desc
   #TQC-C80161 add end ----
    IF g_tse.tseconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF  
    IF g_tse.tseconf='Y' THEN LET g_approve='Y' ELSE LET g_approve='N' END IF   #No.TQC-640116
#   CALL cl_set_field_pic(g_tse.tseconf,g_approve,g_tse.tsepost,"","",g_tse.tseacti)     #No.TQC-640116  #MOD-B60100 mark
    CALL cl_set_field_pic(g_tse.tseconf,g_approve,g_tse.tsepost,"",g_chr,g_tse.tseacti)  #MOD-B60100
    CALL t261_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()             
END FUNCTION
 
FUNCTION t261_void(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废

   IF s_shut(0) THEN 
      RETURN
   END IF
 
   IF g_tse.tse01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_tse.tseconf='X' THEN RETURN END IF
    ELSE
       IF g_tse.tseconf<>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
   IF g_tse.tsepost='Y' THEN
      CALL cl_err(g_tse.tsepost,'asf-922',0)
      RETURN
   ELSE
      IF g_tse.tseconf='Y' THEN
         CALL cl_err(g_tse.tseconf,'9023',0)
         RETURN
      END IF
   END IF
 
   BEGIN WORK
 
   OPEN t261_cl USING g_tse.tse01
   IF STATUS THEN
      CALL cl_err("OPEN t261_cl:", STATUS, 1)
      CLOSE t261_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t261_cl INTO g_tse.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t261_show()
 
   IF cl_void(0,0,g_tse.tseconf) THEN                   #確認一下
      LET g_chr=g_tse.tseacti
      IF g_tse.tseconf='N' THEN
         LET g_tse.tseconf='X'
      ELSE
         IF g_tse.tseconf='X' THEN
            LET g_tse.tseconf='N'
         END IF
      END IF
 
      UPDATE tse_file SET tseconf=g_tse.tseconf,tsecond='',tseconu='',tsecont=''  #FUN-870100
       WHERE tse01=g_tse.tse01
 
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","tse_file",g_tse.tse01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
      END IF
   END IF
 
   CLOSE t261_cl
   IF g_success = 'Y' THEN 
      COMMIT WORK
   ELSE 
      ROLLBACK WORK
   END IF  
 
   SELECT tseacti,tseconf,tsecond,tseconu,tsecont,tsemodu,tsedate             #FUN-870100
     INTO g_tse.tseacti,g_tse.tseconf,g_tse.tsecond,g_tse.tseconu,g_tse.tsecont,g_tse.tsemodu,g_tse.tsedate FROM tse_file
    WHERE tse01=g_tse.tse01 
   DISPLAY BY NAME g_tse.tseacti,g_tse.tseconf,g_tse.tsecond,g_tse.tseconu,g_tse.tsecont,g_tse.tsemodu,g_tse.tsedate
 
   IF g_tse.tseconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF  
   IF g_tse.tseconf='Y' THEN LET g_approve='Y' ELSE LET g_approve='N' END IF   #No.TQC-640116
#  CALL cl_set_field_pic(g_tse.tseconf,g_approve,g_tse.tsepost,"","",g_tse.tseacti)     #No.TQC-640116  #MOD-B60100 mark
   CALL cl_set_field_pic(g_tse.tseconf,g_approve,g_tse.tsepost,"",g_chr,g_tse.tseacti)  #MOD-B60100
            
END FUNCTION
 
#撤銷整筆 (所有合乎單頭的資料)
FUNCTION t261_r()
 DEFINE l_i LIKE type_file.num5          #No.FUN-680120 SMALLINT
 DEFINE i   LIKE type_file.num5          #CHI-A70027 add

    IF s_shut(0) THEN RETURN END IF
    IF g_tse.tse01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF g_tse.tseacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_tse.tse01,'mfg1000',0)
        RETURN
    END IF
    IF g_tse.tsepost='Y' THEN
        CALL cl_err('','afa-101',0)
        RETURN
    END IF 
    IF g_tse.tseconf='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF  
    IF g_tse.tseconf='X' THEN CALL cl_err('','9024',0) RETURN END IF    
 
    BEGIN WORK
 
    OPEN t261_cl USING g_tse.tse01
    IF STATUS THEN
       CALL cl_err("OPEN t261_cl:", STATUS, 1)
       CLOSE t261_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t261_cl INTO g_tse.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tse.tse01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL t261_show()
    IF cl_delh(0,0) THEN                   #審核一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "tse01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_tse.tse01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        #CHI-A70027 add --start--
        LET g_ima918 = ''
        LET g_ima921 = ''
        SELECT ima918,ima921 INTO g_ima918,g_ima921 
          FROM ima_file
         WHERE ima01 = g_tse.tse03
           AND imaacti = "Y"
                
        IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
          #IF NOT s_lotout_del(g_prog,g_tse.tse01,0,0,g_tse.tse03,'DEL') THEN   #TQC-B90236 mark
           IF NOT s_lot_del(g_prog,g_tse.tse01,'',0,g_tse.tse03,'DEL') THEN   #TQC-B90236 add
              CALL cl_err3("del","rvbs_file",g_tse.tse01,0,SQLCA.sqlcode,"","",1)
            END IF
            FOR i = 1 TO g_rec_b
              #IF NOT s_lotin_del(g_prog,g_tse.tse01,g_tsf[i].tsf02,0,g_tsf[i].tsf03,'DEL') THEN  #TQC-B90236 mark
               IF NOT s_lot_del(g_prog,g_tse.tse01,'',0,g_tsf[i].tsf03,'DEL') THEN  #TQC-B90236 add
                  CALL cl_err3("del","rvbs_file",g_tse.tse01,g_tsf[i].tsf02,SQLCA.sqlcode,"","",1)
                  CONTINUE FOR
               END IF
            END FOR
        END IF
        #CHI-A70027 add --end--

            DELETE FROM tse_file WHERE tse01 = g_tse.tse01
            DELETE FROM tsf_file WHERE tsf01 = g_tse.tse01
            
            CLEAR FORM
            CALL g_tsf.clear()
         
         OPEN t261_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE t261_cs
            CLOSE t261_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end--
         FETCH t261_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t261_cs
            CLOSE t261_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t261_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t261_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t261_fetch('/')
         END IF
    END IF
    CLOSE t261_cl
    COMMIT WORK
    CALL cl_flow_notify(g_tse.tse01,'D')
END FUNCTION
 
#單身
FUNCTION t261_b()
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
    l_ima55         LIKE ima_file.ima55,
    l_ima63         LIKE ima_file.ima63,
    l_ima906        LIKE ima_file.ima906,
    l_ima907        LIKE ima_file.ima907,
    l_code          LIKE type_file.num5,             #No.FUN-680120 SMALLINT
    l_code1         LIKE type_file.num5,             #No.FUN-680120 SMALLINT
    sn1,sn2         LIKE type_file.num5,             #No.FUN-680120 SMALLINT
    l_c            LIKE type_file.num5     #CHI-C30106 add
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_tse.tse01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tse.* FROM tse_file WHERE tse01=g_tse.tse01
    IF g_tse.tseacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_tse.tse01,'mfg1000',0)
        RETURN
    END IF
    IF g_tse.tseconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_tse.tseconf='Y' THEN
       IF g_tse.tsepost = 'Y' THEN
          CALL cl_err('','afa-101',0) 
          RETURN 
       ELSE
          CALL cl_err('','mfg3168',0)
          RETURN
       END IF
    END IF                               
    LET g_success='Y'
    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT tsf02,tsf03,'','','','',tsf12,tsf13,tsf14,tsf04,", 
                       " tsf05,tsf09,tsf10,tsf11,tsf06,tsf07,tsf08,tsf15 ",
                       "   FROM tsf_file ",
                       "   WHERE tsf01=? AND tsf02=?  ",
                       "    FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t261_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        
        IF g_rec_b=0 THEN CALL g_tsf.clear() END IF
 
        INPUT ARRAY g_tsf WITHOUT DEFAULTS FROM s_tsf.*
 
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL cl_set_comp_entry("tsf09,tsf11",TRUE)
            CALL cl_set_act_visible("modi_lot_detail",g_sma.sma95="Y")  #FUN-C80065 add
            #No.FUN-BB0086--add--begin--
            LET g_tsf04_t = NULL
            LET g_tsf06_t = NULL
            LET g_tsf09_t = NULL
            #No.FUN-BB0086--add--end--
 
        BEFORE ROW
            LET p_cmd=""
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN t261_cl USING g_tse.tse01
            IF STATUS THEN
               CALL cl_err("OPEN t261_cl:", STATUS, 1)
               CLOSE t261_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t261_cl INTO g_tse.*            # 鎖住將被更改或撤銷的資料
            IF SQLCA.sqlcode THEN
              CALL cl_err(g_tse.tse01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t261_cl
              RETURN
            END IF
 
            # 修改狀態時才作備份舊值的動作
            IF g_rec_b >= l_ac THEN
                LET p_cmd="u"
                LET g_tsf_t.* = g_tsf[l_ac].*  #BACKUP
                LET g_tsf_o.* = g_tsf[l_ac].*  #BACKUP
                #No.FUN-BB0086--add--begin--
                LET g_tsf04_t = g_tsf[l_ac].tsf04
                LET g_tsf06_t = g_tsf[l_ac].tsf06
                LET g_tsf09_t = g_tsf[l_ac].tsf09
                #No.FUN-BB0086--add--end--
                OPEN t261_bcl USING g_tse.tse01,g_tsf_t.tsf02
                IF STATUS THEN
                   CALL cl_err("OPEN t261_bcl:", STATUS, 1)
                   CLOSE t261_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t261_bcl INTO g_tsf[l_ac].* 
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_tsf_t.tsf02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   CALL t261_tsf03('d')
                END IF
            END IF
 
        BEFORE INSERT
            LET p_cmd="a"
            LET l_n = ARR_COUNT()
            INITIALIZE g_tsf[l_ac].* TO NULL       #900423
            LET g_tsf[l_ac].tsf05 = 0              #body default
            LET g_tsf[l_ac].tsf08 = 0              #body default
            LET g_tsf[l_ac].tsf11 = 0              #body default
            LET g_tsf_t.* = g_tsf[l_ac].*          #新輸入資料
            LET g_tsf_o.* = g_tsf[l_ac].*          #新輸入資料
            CALL cl_show_fld_cont()          
            NEXT FIELD tsf02
 
        BEFORE FIELD tsf02                        #default 序號
            IF g_tsf[l_ac].tsf02 IS NULL OR g_tsf[l_ac].tsf02 = 0 THEN
                SELECT max(tsf02)+1
                   INTO g_tsf[l_ac].tsf02
                   FROM tsf_file
                   WHERE tsf01 = g_tse.tse01
                IF g_tsf[l_ac].tsf02 IS NULL THEN
                    LET g_tsf[l_ac].tsf02 = 1
                END IF
            END IF
 
        AFTER FIELD tsf02                        #check 序號是否重複
            IF NOT g_tsf[l_ac].tsf02 IS NULL THEN
               IF g_tsf[l_ac].tsf02 != g_tsf_t.tsf02 OR
                  g_tsf_t.tsf02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM tsf_file
                       WHERE tsf01 = g_tse.tse01 AND
                             tsf02 = g_tsf[l_ac].tsf02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_tsf[l_ac].tsf02 = g_tsf_t.tsf02
                       NEXT FIELD tsf02
                   END IF
               END IF
            END IF
 
        BEFORE FIELD tsf03
            CALL cl_set_comp_required("tsf06,tsf08,tsf09,tsf11",false)
 
        AFTER FIELD tsf03 
            IF cl_null(g_tsf[l_ac].tsf03) THEN
                  CALL cl_err('','aap-099',0)
                  NEXT FIELD tsf03
#FUN-AA0059 ---------------------start----------------------------
            ELSE
               IF NOT s_chk_item_no(g_tsf[l_ac].tsf03,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_tsf[l_ac].tsf03= g_tsf_t.tsf03
                  NEXT FIELD tsf03
               END IF
#FUN-AA0059 ---------------------end-------------------------------
            END IF
            CALL t261_sel_ima_b()     #0215
            IF g_sma.sma115 ='Y' AND g_ima906 = '1' THEN
               CALL cl_set_comp_entry("tsf09,tsf11",FALSE)
            END IF
            IF g_sma.sma115 ='Y' AND g_ima906 = '3' THEN
               CALL cl_set_comp_entry("tsf11",TRUE)
               CALL cl_set_comp_entry("tsf09",FALSE)
            END IF
            IF g_sma.sma115 ='Y' AND g_ima906 = '2' THEN
               CALL cl_set_comp_entry("tsf09,tsf11,tsf06,tsf08",TRUE)  
               CALL cl_set_comp_required("tsf09,tsf11,tsf06,tsf08",FALSE)
            END IF
            IF g_sma.sma115 = 'Y' THEN  #No.TQC-650031
               IF NOT cl_null(g_tsf[l_ac].tsf09) THEN
                  CALL cl_set_comp_required("tsf11",TRUE)
               END IF
               IF NOT cl_null(g_tsf[l_ac].tsf06) THEN
                  CALL cl_set_comp_required("tsf08",TRUE)
               END IF
            END IF  #No.TQC-650031 
            IF NOT cl_null(g_tsf[l_ac].tsf03) THEN 
              IF p_cmd = 'a' OR (p_cmd ='u' AND 
                 g_tsf[l_ac].tsf03 != g_tsf_o.tsf03) THEN
                 SELECT count(*) INTO l_n FROM ima_file
                     WHERE ima01 = g_tsf[l_ac].tsf03
                 IF l_n = 0 THEN
                     CALL cl_err(g_tsf[l_ac].tsf03,'ams-003',0)
                     LET g_tsf[l_ac].tsf03 = g_tsf_t.tsf03
                     NEXT FIELD tsf03
                 ELSE
                     IF g_sma.sma115 = 'Y' THEN       #(使用多單位)
                         CALL s_chk_va_setting(g_tsf[l_ac].tsf03)    #(檢查多單位使用方式是否與參數設定一致)
                              RETURNING g_flag,g_ima906,g_ima907
                         IF g_flag=1 THEN
                            NEXT FIELD tsf03
                         END IF
                         IF g_ima906 = '3' THEN   #(使用參考單位)
                            LET g_tsf[l_ac].tsf09=g_ima907
                         END IF
                      END IF
                      CALL t261_tsf03('d')
                      IF NOT cl_null(g_errno) THEN
                         CALL cl_err(g_tsf[l_ac].tsf03,g_errno,0)
                         NEXT FIELD tsf03
                      END IF
                      CALL t261_du_default_b(p_cmd)
                      SELECT ima35,ima36,ima55 INTO l_ima35,l_ima36,l_ima55
                        FROM ima_file
                       WHERE ima01=g_tsf[l_ac].tsf03
                      LET g_tsf[l_ac].tsf12 = l_ima35
                      LET g_tsf[l_ac].tsf13 = l_ima36
                      LET g_tsf[l_ac].tsf04 = l_ima55
                      DISPLAY g_tsf[l_ac].tsf12 TO tsf12
                      DISPLAY g_tsf[l_ac].tsf13 TO tsf13
                      DISPLAY g_tsf[l_ac].tsf04 TO tsf04   #單位預設值
                      DISPLAY g_tsf[l_ac].tsf06 TO tsf06   #單位一預設值
                      DISPLAY g_tsf[l_ac].tsf08 TO tsf08
                      DISPLAY g_tsf[l_ac].tsf09 TO tsf09
                      DISPLAY g_tsf[l_ac].tsf10 TO tsf10
                      DISPLAY g_tsf[l_ac].tsf11 TO tsf11
                 END IF
               END IF
            END IF
 
 
        AFTER FIELD tsf12
           IF cl_null(g_tsf[l_ac].tsf12) THEN
              NEXT FIELD tsf12
           END IF
           IF g_tsf[l_ac].tsf12 IS NULL THEN
              LET g_tsf[l_ac].tsf12 = ' '
           END IF
           IF NOT cl_null(g_tsf[l_ac].tsf12) THEN
             # #CHI-D20014 add end 还原
             # #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
             # IF NOT s_chksmz(g_tsf[l_ac].tsf03,g_tse.tse01,g_tsf[l_ac].tsf12,g_tsf[l_ac].tsf13) THEN
             #    NEXT FIELD tsf12
             # END IF
             # #CHI-D20014 add end 还原
              IF NOT s_imfchk1(g_tsf[l_ac].tsf03,g_tsf[l_ac].tsf12) THEN
                 CALL cl_err('s_imfchk1','mfg9036',0)
                 NEXT FIELD tsf03
              END IF
              CALL s_stkchk(g_tsf[l_ac].tsf12,'A') RETURNING l_code
              IF NOT l_code THEN
                 CALL cl_err('s_stkchk','mfg1100',0) 
                 NEXT FIELD tsf12
              END IF
              CALL s_swyn(g_tsf[l_ac].tsf12) RETURNING sn1,sn2
                  IF sn1=1 AND g_tsf[l_ac].tsf12 != g_tsf_t.tsf12 THEN                                                              
                     LET g_tsf_t.tsf12=g_tsf[l_ac].tsf12                                                                            
                     CALL cl_err(g_tsf[l_ac].tsf12,'mfg6080',0) NEXT FIELD tsf12                                                    
                  ELSE                                                                                                              
                     IF sn2=2 AND g_tsf[l_ac].tsf12 != g_tsf_t.tsf12 THEN                                                           
                        CALL cl_err(g_tsf[l_ac].tsf12,'mfg6085',0)                                                                  
                        LET g_tsf_t.tsf12=g_tsf[l_ac].tsf12                                                                         
                        NEXT FIELD tsf12                                                                                            
                     END IF                                                                                                         
                  END IF                                                                                                            
                  LET sn1=0 LET sn2=0  
           END IF
#FUN-AB0015  --modify
           IF NOT s_chk_ware(g_tsf[l_ac].tsf12) THEN
              NEXT FIELD tsf12
           END IF 
#FUN-AB0015  --end
   #TQC-D50124 -----Begin------
     ##FUN-D40103 -------Begin-------
     #     IF NOT s_imechk(g_tsf[l_ac].tsf12,g_tsf[l_ac].tsf13) THEN
     #        NEXT FIELD tsf13
     #     END IF
     ##FUN-D40103 -------End---------
     #TQC-D50124 -----End--------- 

        AFTER FIELD tsf13
           IF cl_null(g_tsf[l_ac].tsf13) THEN  #全型空白
              LET g_tsf[l_ac].tsf13 = ' '
           END IF
           IF NOT cl_null(g_tsf[l_ac].tsf13) THEN
             # IF NOT cl_null(g_tsf[l_ac].tsf12) THEN #CHI-D20014 add 还原
              #------------------------------------ 檢查料號預設倉儲及單別預設倉儲    
              IF NOT s_chksmz(g_tsf[l_ac].tsf03,g_tse.tse01,g_tsf[l_ac].tsf12,g_tsf[l_ac].tsf13) THEN
                 NEXT FIELD tsf13
              END IF
             # END IF #CHI-D20014 add 还原     
              #------>check-1  檢查該料是否可收至該倉/儲位 
              IF NOT s_imfchk(g_tsf[l_ac].tsf03,g_tsf[l_ac].tsf12,                                                                  
                              g_tsf[l_ac].tsf13) THEN                                                                               
                 CALL cl_err(g_tsf[l_ac].tsf13,'mfg6095',0) NEXT FIELD tsf13                                                        
              END IF             
              CALL s_lwyn(g_tsf[l_ac].tsf12,g_tsf[l_ac].tsf13)                                                                   
                   RETURNING sn1,sn2    #可用否                                                                                  
              IF sn2 = 2 THEN                                                                                                    
                 IF g_pmn38 = 'Y' THEN CALL cl_err('','mfg9132',0) END IF                                                        
              ELSE                                                                                                               
                 IF g_pmn38 = 'N' THEN CALL cl_err('','mfg9131',0) END IF                                                        
              END IF                                                                                                             
              LET sn1=0 LET sn2=0  
           END IF
#TQC-D50124 --------Begin---------
     ##FUN-D40103 -------Begin-------
     #     IF NOT s_imechk(g_tsf[l_ac].tsf12,g_tsf[l_ac].tsf13) THEN
     #        NEXT FIELD tsf13
     #     END IF
     ##FUN-D40103 -------End--------
    #TQC-D50124 --------End----------- 

        AFTER FIELD tsf14 
            IF cl_null(g_tsf[l_ac].tsf14) THEN
               LET g_tsf[l_ac].tsf14 = ' '
            END IF 
            IF NOT cl_null(g_tsf[l_ac].tsf03) AND NOT cl_null(g_tsf[l_ac].tsf12) THEN
              SELECT img09,img10 INTO g_img09,g_img10
                FROM img_file
               WHERE img01=g_tsf[l_ac].tsf03
                 AND img02=g_tsf[l_ac].tsf12
                 AND img03=g_tsf[l_ac].tsf13
                 AND img04=g_tsf[l_ac].tsf14
              IF SQLCA.sqlcode=100 THEN
                 IF NOT cl_confirm('mfg1401') THEN
                   NEXT FIELD tsf03
                 END IF
                 CALL s_add_img(g_tsf[l_ac].tsf03,g_tsf[l_ac].tsf12,
                                g_tsf[l_ac].tsf13,g_tsf[l_ac].tsf14,
#                               g_tse.tse01,g_tsf[l_ac].tsf02,g_tse.tse02)   #MOD-AA0167
                                g_tse.tse01,g_tsf[l_ac].tsf02,g_tse.tse21)   #MOD-AA0167
                 IF g_errno='N' THEN
                    NEXT FIELD tsf03
                 END IF
                 SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
                  WHERE img01=g_tsf[l_ac].tsf03 AND img02=g_tsf[l_ac].tsf12
                    AND img03=g_tsf[l_ac].tsf13 AND img04=g_tsf[l_ac].tsf14
              END IF
 
              SELECT COUNT(*) INTO g_cnt
                FROM img_file
               WHERE img01=g_tsf[l_ac].tsf03
                 AND img02=g_tsf[l_ac].tsf12
                 AND img03=g_tsf[l_ac].tsf13
                 AND img04=g_tsf[l_ac].tsf14
#                AND img18<g_tse.tse02        #MOD-AA0167
                 AND img18<g_tse.tse21        #MOD-AA0167
              IF g_cnt > 0 THEN
                 CALL cl_err('','aim-400',0)
                 NEXT FIELD tsf14
              END IF
              IF g_sma.sma115='Y' THEN
                 CALL t261_du_default_b(p_cmd)
              END  IF
            END IF
            
        AFTER FIELD tsf04 
            IF NOT cl_null(g_tsf[l_ac].tsf04) THEN
                 SELECT count(*) INTO l_n
                   FROM gfe_file
                  WHERE gfe01 = g_tsf[l_ac].tsf04
                    AND gfeacti = 'Y'
                 IF l_n = 0 THEN
                    CALL cl_err(g_tsf[l_ac].tsf04,'mfg0019',0)  #無此單位編號
                    NEXT FIELD tsf04
                 END IF
                 SELECT * INTO g_img.*    #重新取得庫存明細資料
                   FROM img_file
                  WHERE img01=g_tsf[l_ac].tsf03 AND img02=g_tsf[l_ac].tsf12
                    AND img03=g_tsf[l_ac].tsf13 AND img04=g_tsf[l_ac].tsf14
                 #Check 單位與庫存明細單位換算關系并且返回換算率
                 CALL s_umfchk(g_tsf[l_ac].tsf03,g_tsf[l_ac].tsf04,g_img09)  #No.FUN-950021
                      RETURNING g_cnt,g_tsf041
                 IF g_cnt = 1 THEN
                    CALL cl_err('','mfg3075',0)
                    NEXT FIELD tsf04
                 END IF
                 #No.FUN-BB0086--add--begin--
                 IF NOT cl_null(g_tsf[l_ac].tsf05) AND g_tsf[l_ac].tsf05<>0 THEN  #FUN-C20068 
                    IF NOT t261_tsf05_check() THEN 
                       LET g_tsf04_t = g_tsf[l_ac].tsf04
                       NEXT FIELD tsf05
                    END IF 
                 END IF                                                           #FUN-C20068
                 LET g_tsf04_t = g_tsf[l_ac].tsf04
                 #No.FUN-BB0086--add--end--
             END IF
 
        AFTER FIELD tsf05 
           IF NOT t261_tsf05_check() THEN NEXT FIELD tsf05 END IF   #No.FUN-BB0086
            #No.FUN-BB0086--mark--begin--
            #IF NOT cl_null(g_tsf[l_ac].tsf05) THEN
            #   IF g_tsf[l_ac].tsf05 <= 0 THEN       #MOD-9C0344
            #      CALL cl_err('','mfg9243',0)
            #      NEXT FIELD tsf05
            #   END IF
            # END IF
            # #CHI-A70027 add --start--
            # LET g_ima918 = ''
            # LET g_ima921 = ''
            # SELECT ima918,ima921 INTO g_ima918,g_ima921 
            #   FROM ima_file
            #  WHERE ima01 = g_tsf[l_ac].tsf03
            #    AND imaacti = "Y"
            #
            # IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
            #    CALL t261_ima25(g_tsf[l_ac].tsf03,g_tsf[l_ac].tsf12,g_tsf[l_ac].tsf13,g_tsf[l_ac].tsf14,g_tsf[l_ac].tsf04)                   
            #    CALL s_lotin(g_prog,g_tse.tse01,g_tsf[l_ac].tsf02,0,
            #                 g_tsf[l_ac].tsf03,g_tsf[l_ac].tsf04,g_ima25,
            #                 g_ima25_fac,g_tsf[l_ac].tsf05,'','MOD')
            #         RETURNING l_r,g_qty
            #    IF l_r = "Y" THEN
            #       LET g_tsf[l_ac].tsf05 = g_qty
            #       DISPLAY BY NAME g_tsf[l_ac].tsf05
            #    END IF
            # END IF
             #CHI-A70027 add --end--
            #No.FUN-BB0086--mark--end--
 
        BEFORE FIELD tsf09
            CALL t261_sel_ima_b()   #0215
            CALL cl_set_comp_required("tsf06,tsf08,tsf09,tsf11",FALSE)
 
        AFTER FIELD tsf09
            IF NOT cl_null(g_tsf[l_ac].tsf09) THEN
               CALL cl_set_comp_required("tsf11",TRUE)               
               SELECT count(*) INTO l_n
                 FROM gfe_file
                WHERE gfe01=g_tsf[l_ac].tsf09
                  AND gfeacti='Y'
               IF l_n = 0 THEN
                  CALL cl_err(g_tsf[l_ac].tsf09,'mfg0019',0)
                  NEXT FIELD tsf09
               END IF
 
               #Check 單位二與生產單位的換算關系并返回換算率
               CALL s_du_umfchk(g_tsf[l_ac].tsf03,'','','',g_img09,g_tsf[l_ac].tsf09,g_ima906)
                    returning g_errno,g_tsf[l_ac].tsf10
 
               CALL s_chk_imgg(g_tsf[l_ac].tsf03,g_tsf[l_ac].tsf12,g_tsf[l_ac].tsf13,g_tsf[l_ac].tsf14,g_tsf[l_ac].tsf09)  # Check 多單位第二單位庫存明細是否存在
                    RETURNING l_code
               IF l_code THEN
                    IF g_sma.sma892[3,3]='Y' THEN
                       IF NOT cl_confirm('aim-995') THEN
                       NEXT FIELD tsf09
                     END IF
                  END IF
                  CALL s_add_imgg(g_tsf[l_ac].tsf03,g_tsf[l_ac].tsf12,g_tsf[l_ac].tsf13,g_tsf[l_ac].tsf14,g_tsf[l_ac].tsf09,g_tsf[l_ac].tsf10,g_tse.tse01,'',0)
                       RETURNING l_code1
                    IF l_code1 THEN
                       CALL cl_err('','lib-028',0)
                    END IF   
               END IF
               DISPLAY g_tsf[l_ac].tsf10 TO tsf10
               #No.FUN-BB0086--add--begin--
               IF NOT cl_null(g_tsf[l_ac].tsf11) AND g_tsf[l_ac].tsf11<>0 THEN #FUN-C20068
                  IF NOT t261_tsf11_check() THEN 
                     LET g_tsf09_t = g_tsf[l_ac].tsf09
                     NEXT FIELD tsf11
                  END IF 
               END IF                                                          #FUN-C20068
               LET g_tsf09_t = g_tsf[l_ac].tsf09
               #No.FUN-BB0086--add--end--
            END IF
 
        BEFORE FIELD tsf11
           IF cl_null(g_tsf[l_ac].tsf03) THEN NEXT FIELD tsf03 END IF                                                               
           IF g_tsf[l_ac].tsf12 IS NULL OR g_tsf[l_ac].tsf13 IS NULL OR                                                             
              g_tsf[l_ac].tsf14 IS NULL THEN                                                                                        
              NEXT FIELD tsf14                                                                                                      
           END IF                                                                                                                   
           IF NOT cl_null(g_tsf[l_ac].tsf09) AND g_ima906 = '3' THEN                                                               
              CALL s_chk_imgg(g_tsf[l_ac].tsf03,g_tsf[l_ac].tsf12,                                                                  
                              g_tsf[l_ac].tsf13,g_tsf[l_ac].tsf14,                                                                  
                              g_tsf[l_ac].tsf09) RETURNING g_flag                                                                  
              IF g_flag = 1 THEN                                                                                                    
                 IF g_sma.sma892[3,3] = 'Y' THEN                                                                                    
                    IF NOT cl_confirm('aim-995') THEN                                                                               
                       NEXT FIELD tsf03                                                                                             
                    END IF                                                                                                          
                 END IF                           
                 CALL s_add_imgg(g_tsf[l_ac].tsf03,g_tsf[l_ac].tsf12,                                                               
                                 g_tsf[l_ac].tsf13,g_tsf[l_ac].tsf14,                                                               
                                 g_tsf[l_ac].tsf09,g_tsf[l_ac].tsf10,                                                             
                                 g_tse.tse01,'',0) RETURNING g_flag                                                                                       
                 IF g_flag = 1 THEN                                                                                                 
                    NEXT FIELD tsf03                                                                                                
                 END IF                                                                                                             
              END IF                                                                                                                
           END IF     
 
        AFTER FIELD tsf11
           IF NOT t261_tsf11_check() THEN NEXT FIELD tsf11 END IF   #No.FUN-BB0086
           #No.FUN-BB0086--mark--begin--
           # IF NOT cl_null(g_tsf[l_ac].tsf11) THEN
           #    IF g_tsf[l_ac].tsf11 <= 0 THEN        #MOD-9C0344
           #       CALL cl_err('','mfg9243',0)
           #       NEXT FIELD tsf11
           #    END IF
           #    IF g_ima906='3' THEN                                                                                              
           #       LET g_tot=g_tsf[l_ac].tsf11*g_tsf[l_ac].tsf10                                                                  
           #        IF cl_null(g_tsf[l_ac].tsf08) OR g_tsf[l_ac].tsf08=0 THEN #CHI-960022
           #          LET g_tsf[l_ac].tsf08=g_tot                                                                  
           #          DISPLAY BY NAME g_tsf[l_ac].tsf08                                                                              
           #       END IF                                                    #CHI-960022
           #    END IF                                                                                                            
           # END IF
           #No.FUN-BB0086--mark--end--
 
        BEFORE FIELD tsf06
            CALL t261_sel_ima_b()   #0215
            CALL cl_set_comp_required("tsf06,tsf08,tsf09,tsf11",FALSE)
 
        AFTER FIELD tsf06
            IF NOT cl_null(g_tsf[l_ac].tsf06) THEN
                 CALL cl_set_comp_required("tsf08",TRUE)
                 SELECT count(*) INTO l_n
                   FROM gfe_file
                  WHERE gfe01 = g_tsf[l_ac].tsf06
                    AND gfeacti = 'Y'
                 IF l_n = 0 THEN
                    CALL cl_err(g_tsf[l_ac].tsf06,'mfg0019',0)  #無此單位編號
                    NEXT FIELD tsf06
                 END IF
                 CALL cl_set_comp_required("tsf08",TRUE)
                 #Check 單位與庫存明細單位換算關系并且返回換算率
                 CALL s_du_umfchk(g_tsf[l_ac].tsf03,'','','',g_tsf[l_ac].tsf04,g_tsf[l_ac].tsf06,g_ima906)
                      returning g_errno,g_tsf[l_ac].tsf07
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_tsf[l_ac].tsf06,g_errno,0)
                    NEXT FIELD tsf06
                 END IF
 
                 IF g_ima906='2' THEN
                    CALL s_chk_imgg(g_tsf[l_ac].tsf03,g_tsf[l_ac].tsf12,g_tsf[l_ac].tsf13,g_tsf[l_ac].tsf14,g_tsf[l_ac].tsf06)  # Check 多單位第二單位庫存明細是否存在
                         RETURNING l_code
                    IF l_code THEN
                       IF g_sma.sma892[3,3]='Y' THEN
                          IF NOT cl_confirm('aim-995') THEN
                             NEXT FIELD tsf06
                          END IF
                       END IF
                       CALL s_add_imgg(g_tsf[l_ac].tsf03,g_tsf[l_ac].tsf12,g_tsf[l_ac].tsf13,g_tsf[l_ac].tsf14,g_tsf[l_ac].tsf06,g_tsf[l_ac].tsf07,g_tse.tse01,'',0)
                           RETURNING l_code1
                       IF l_code1 THEN
                          CALL cl_err('','lib-028',0)
                       END IF   
                    END IF
                 END IF
                 DISPLAY g_tsf[l_ac].tsf07 TO tsf07
                 #No.FUN-BB0086--add--begin--
                 IF NOT cl_null(g_tsf[l_ac].tsf08) AND g_tsf[l_ac].tsf08<>0 THEN  #FUN-C20068
                    IF NOT t261_tsf08_check() THEN 
                       LET g_tsf06_t = g_tsf[l_ac].tsf06
                       NEXT FIELD tsf08
                    END IF 
                 END IF                                                           #FUN-C20068
                 LET g_tsf06_t = g_tsf[l_ac].tsf06
                 #No.FUN-BB0086--add--end--
            END IF
         
        AFTER FIELD tsf08
           IF NOT t261_tsf08_check() THEN NEXT FIELD tsf08 END IF   #No.FUN-BB0086
            #No.FUN-BB0086--mark--begin--
            #IF NOT cl_null(g_tsf[l_ac].tsf08) THEN
            #   IF g_tsf[l_ac].tsf08 <= 0 THEN           #MOD-9C0344
            #      CALL cl_err('','mfg9243',0)
            #      NEXT FIELD tsf08
            #   END IF
            #   CALL t261_du_data_to_correct_b()
            #   CALL t261_set_origin_field_b()
            #END IF
            #No.FUN-BB0086--mark--end--
 
        AFTER FIELD tsfud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsfud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsfud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsfud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsfud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsfud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsfud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsfud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsfud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsfud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsfud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsfud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsfud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsfud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tsfud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT            
            END IF
            CALL t261_du_data_to_correct_b()
            CALL t261_set_origin_field_b()
            INSERT INTO tsf_file(tsf01,tsf02,tsf03,tsf04,tsf041,
                                 tsf05,tsf06,tsf07,tsf08,
                                 tsf09,tsf10,tsf11,tsf12,
                                 tsf13,tsf14,tsf15,tsfplant,   #FUN-870100
                                 tsfud01,tsfud02,tsfud03,
                                 tsfud04,tsfud05,tsfud06,
                                 tsfud07,tsfud08,tsfud09,
                                 tsfud10,tsfud11,tsfud12,
                                 tsfud13,tsfud14,tsfud15,
                                 tsflegal  #FUN-980009
                                )
            VALUES(g_tse.tse01,g_tsf[l_ac].tsf02,
                    g_tsf[l_ac].tsf03,g_tsf[l_ac].tsf04,g_tsf041,
                   g_tsf[l_ac].tsf05,g_tsf[l_ac].tsf06,
                   g_tsf[l_ac].tsf07,g_tsf[l_ac].tsf08,
                   g_tsf[l_ac].tsf09,g_tsf[l_ac].tsf10,
                   g_tsf[l_ac].tsf11,g_tsf[l_ac].tsf12,
                   g_tsf[l_ac].tsf13,g_tsf[l_ac].tsf14,
                   g_tsf[l_ac].tsf15,g_tse.tseplant,      #FUN-870100 ADD
                   g_tsf[l_ac].tsfud01,
                   g_tsf[l_ac].tsfud02,
                   g_tsf[l_ac].tsfud03,
                   g_tsf[l_ac].tsfud04,
                   g_tsf[l_ac].tsfud05,
                   g_tsf[l_ac].tsfud06,
                   g_tsf[l_ac].tsfud07,
                   g_tsf[l_ac].tsfud08,
                   g_tsf[l_ac].tsfud09,
                   g_tsf[l_ac].tsfud10,
                   g_tsf[l_ac].tsfud11,
                   g_tsf[l_ac].tsfud12,
                   g_tsf[l_ac].tsfud13,
                   g_tsf[l_ac].tsfud14,
                   g_tsf[l_ac].tsfud15,
                   g_legal   #FUN-980009
                  )
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","tsf_file",g_tsf[l_ac].tsf02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
                # 新增至資料庫發生錯誤時, CANCEL INSERT,
                # 不需要讓舊值回復到原變數
                CANCEL INSERT
                #CHI-A70027 add --start--
                LET g_ima918 = ''
                LET g_ima921 = ''
                SELECT ima918,ima921 INTO g_ima918,g_ima921 
                  FROM ima_file
                 WHERE ima01 = g_tsf[l_ac].tsf03
                   AND imaacti = "Y"
               
                IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                   IF NOT s_lotin_del(g_prog,g_tse.tse01,g_tsf[l_ac].tsf02,0,g_tsf[l_ac].tsf03,'DEL') THEN 
                      CALL cl_err3("del","rvbs_file",g_tse.tse01,g_tsf[l_ac].tsf02,SQLCA.sqlcode,"","",1)
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
            IF g_tsf_t.tsf02 > 0 AND
               g_tsf_t.tsf02 IS NOT NULL THEN
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
                 WHERE ima01 = g_tsf[l_ac].tsf03
                   AND imaacti = "Y"
               
                IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                   IF NOT s_lotin_del(g_prog,g_tse.tse01,g_tsf[l_ac].tsf02,0,g_tsf[l_ac].tsf03,'DEL') THEN 
                      CALL cl_err3("del","rvbs_file",g_tse.tse01,g_tsf[l_ac].tsf02,SQLCA.sqlcode,"","",1)
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF
                END IF
                #CHI-A70027 add --end--
                DELETE FROM tsf_file
                    WHERE tsf01 = g_tse.tse01 AND
                          tsf02 = g_tsf_t.tsf02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","tsf_file",g_tsf_t.tsf02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
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
            INITIALIZE g_tsf[l_n+1].* TO NULL
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tsf[l_ac].* = g_tsf_t.*
               CLOSE t261_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_tsf[l_ac].tsf02,-263,1)
               LET g_tsf[l_ac].* = g_tsf_t.*
            ELSE
               CALL t261_set_origin_field_b()
               UPDATE tsf_file SET tsf02= g_tsf[l_ac].tsf02,
                                   tsf03= g_tsf[l_ac].tsf03,
                                   tsf04= g_tsf[l_ac].tsf04,
                                   tsf041= g_tsf041,
                                   tsf05= g_tsf[l_ac].tsf05,
                                   tsf06= g_tsf[l_ac].tsf06,
                                   tsf07= g_tsf[l_ac].tsf07,
                                   tsf08= g_tsf[l_ac].tsf08,
                                   tsf09= g_tsf[l_ac].tsf09,
                                   tsf10= g_tsf[l_ac].tsf10,
                                   tsf11= g_tsf[l_ac].tsf11,
                                   tsf12= g_tsf[l_ac].tsf12,
                                   tsf13= g_tsf[l_ac].tsf13,
                                   tsf14= g_tsf[l_ac].tsf14,
                                   tsf15= g_tsf[l_ac].tsf15,
                                   tsfplant= g_tse.tseplant, #FUN-870100
                                   tsfud01 = g_tsf[l_ac].tsfud01,
                                   tsfud02 = g_tsf[l_ac].tsfud02,
                                   tsfud03 = g_tsf[l_ac].tsfud03,
                                   tsfud04 = g_tsf[l_ac].tsfud04,
                                   tsfud05 = g_tsf[l_ac].tsfud05,
                                   tsfud06 = g_tsf[l_ac].tsfud06,
                                   tsfud07 = g_tsf[l_ac].tsfud07,
                                   tsfud08 = g_tsf[l_ac].tsfud08,
                                   tsfud09 = g_tsf[l_ac].tsfud09,
                                   tsfud10 = g_tsf[l_ac].tsfud10,
                                   tsfud11 = g_tsf[l_ac].tsfud11,
                                   tsfud12 = g_tsf[l_ac].tsfud12,
                                   tsfud13 = g_tsf[l_ac].tsfud13,
                                   tsfud14 = g_tsf[l_ac].tsfud14,
                                   tsfud15 = g_tsf[l_ac].tsfud15
               WHERE tsf01=g_tse.tse01 AND tsf02=g_tsf_t.tsf02
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","tsf_file",g_tsf[l_ac].tsf02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
                   LET g_tsf[l_ac].* = g_tsf_t.*
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
           #LET l_ac_t = l_ac  #FUN-D30033 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'a' AND l_ac <= g_tsf.getLength() THEN  #CHI-C30106 add
                 #CHI-A70027 add --start--
                 LET g_ima918 = ''
                 LET g_ima921 = ''
                 SELECT ima918,ima921 INTO g_ima918,g_ima921 
                   FROM ima_file
                  WHERE ima01 = g_tsf[l_ac].tsf03
                    AND imaacti = "Y"
              
                 IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                    IF NOT s_lotin_del(g_prog,g_tse.tse01,g_tsf[l_ac].tsf02,0,g_tsf[l_ac].tsf03,'DEL') THEN   
                       CALL cl_err3("del","rvbs_file",g_tse.tse01,g_tsf[l_ac].tsf02,SQLCA.sqlcode,"","",1)
                    END IF
                 END IF
               END IF  #CHI-C30106 add
               #CHI-A70027 add --end--
 
               # 當為修改狀態且取消輸入時, 才作回復舊值的動作
               IF p_cmd = 'u' THEN
                  LET g_tsf[l_ac].* = g_tsf_t.*
               #FUN-D30033--add--begin--
               ELSE
                  CALL g_tsf.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30033--add--end----
               END IF
 
               CLOSE t261_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
             IF g_sma.sma115 = 'N' AND g_tsf[l_ac].tsf05 <= 0 THEN 
                CALL cl_err('','mfg9243',0)
                ROLLBACK WORK
                NEXT FIELD tsf05
             END IF
             IF g_sma.sma115 = 'Y' AND g_tsf[l_ac].tsf08 <= 0 THEN 
                CALL cl_err('','mfg9243',0)
                ROLLBACK WORK
                NEXT FIELD tsf08
             END IF
             IF g_sma.sma115 = 'Y' AND g_tsf[l_ac].tsf11 <= 0 THEN 
                CALL cl_err('','mfg9243',0)
                ROLLBACK WORK
                NEXT FIELD tsf11
             END IF
 
            # 除了修改狀態取消時, 其餘不需要回復舊值或備份舊值
            LET l_ac_t = l_ac  #FUN-D30033 add
 
            CLOSE t261_bcl
            COMMIT WORK
            
            CALL g_tsf.deleteElement(g_rec_b+1)

       #CHI-C30106---add---S---
        AFTER INPUT
        LET g_cnt = 0
        SELECT COUNT(*) INTO g_cnt FROM tsf_file WHERE tsf01=g_tse.tse01
        FOR l_c=1 TO g_cnt
          SELECT ima918,ima921 INTO g_ima918,g_ima921
            FROM ima_file
           WHERE ima01 = g_tsf[l_c].tsf03
             AND imaacti = "Y"

          IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
          UPDATE rvbs_file SET rvbs021 = g_tsf[l_c].tsf03
           WHERE rvbs00=g_prog
             AND rvbs01=g_tse.tse01
             AND rvbs02=g_tsf[l_c].tsf02
          END IF
        END FOR
       #CHI-C30106---add---E---
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(tsf02) AND l_ac > 1 THEN
                LET g_tsf[l_ac].* = g_tsf[l_ac-1].*
                LET g_tsf[l_ac].tsf02 = g_tsf[l_ac-1].tsf02 + 1
                DISPLAY BY NAME g_tsf[l_ac].*
                NEXT FIELD tsf02
            END IF
 
        ON ACTION CONTROLZ
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(tsf03)    #組合產品編號
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_ima01"
#                LET g_qryparam.default1 = g_tsf[l_ac].tsf03
#                CALL cl_create_qry() RETURNING g_tsf[l_ac].tsf03
                 CALL q_sel_ima(FALSE, "q_ima01","",g_tsf[l_ac].tsf03,"","","","","",'' ) 
                  RETURNING   g_tsf[l_ac].tsf03
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY BY NAME g_tsf[l_ac].tsf03
                 NEXT FIELD tsf03
               WHEN INFIELD(tsf12)    #倉庫
                #FUN-AB0015  --modify
                #CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_imd01"
                #LET g_qryparam.default1 = g_tsf[l_ac].tsf12
                #CALL cl_create_qry() RETURNING g_tsf[l_ac].tsf12
                 CALL q_imd_1(FALSE,TRUE,g_tsf[l_ac].tsf12,"","","","imd11='Y'") RETURNING g_tsf[l_ac].tsf12
                #FUN-AB0015  --end
                 DISPLAY BY NAME g_tsf[l_ac].tsf12
                 NEXT FIELD tsf12
               WHEN INFIELD(tsf13)    #儲位
                #FUN-AB0015  --modify
                #CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_ime"
                #LET g_qryparam.arg1 = g_tsf[l_ac].tsf12
                #LET g_qryparam.arg2 = 'SW'
                #LET g_qryparam.default1 = g_tsf[l_ac].tsf13
                #CALL cl_create_qry() RETURNING g_tsf[l_ac].tsf13
                 CALL q_ime_1(FALSE,TRUE,g_tsf[l_ac].tsf13,g_tsf[l_ac].tsf12,"",g_plant,"","","") RETURNING g_tsf[l_ac].tsf13
                #FUN-AB0015  --end
                 DISPLAY BY NAME g_tsf[l_ac].tsf13
                 NEXT FIELD tsf13
               WHEN INFIELD(tsf14)    #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_img"
                 LET g_qryparam.arg1 = g_tsf[l_ac].tsf14
                 CALL cl_create_qry() RETURNING g_tsf[l_ac].tsf14
                 DISPLAY BY NAME g_tsf[l_ac].tsf14
                 NEXT FIELD tsf14
               WHEN INFIELD(tsf04)    #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.default1 = g_tsf[l_ac].tsf04
                 CALL cl_create_qry() RETURNING g_tsf[l_ac].tsf04
                 DISPLAY BY NAME g_tsf[l_ac].tsf04
                 NEXT FIELD tsf04
               WHEN INFIELD(tsf09)    #單位二
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.default1 = g_tsf[l_ac].tsf09
                 CALL cl_create_qry() RETURNING g_tsf[l_ac].tsf09
                 DISPLAY BY NAME g_tsf[l_ac].tsf09
                 NEXT FIELD tsf09
               WHEN INFIELD(tsf06)    #單位一
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.default1 = g_tsf[l_ac].tsf06
                 CALL cl_create_qry() RETURNING g_tsf[l_ac].tsf06
                 DISPLAY BY NAME g_tsf[l_ac].tsf06
                 NEXT FIELD tsf06
              OTHERWISE EXIT CASE
            END CASE

         #CHI-A70027 add --start--
        ON ACTION modi_lot_detail   #單身批/序號維護
           LET g_ima918 = ''
           LET g_ima921 = ''
           SELECT ima918,ima921 INTO g_ima918,g_ima921 
             FROM ima_file
            WHERE ima01 = g_tsf[l_ac].tsf03
              AND imaacti = "Y"
           
           IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
              CALL t261_ima25(g_tsf[l_ac].tsf03,g_tsf[l_ac].tsf12,g_tsf[l_ac].tsf13,g_tsf[l_ac].tsf14,g_tsf[l_ac].tsf04)                   
#TQC-B90236--mark--begin
#             CALL s_lotin(g_prog,g_tse.tse01,g_tsf[l_ac].tsf02,0,
#                          g_tsf[l_ac].tsf03,g_tsf[l_ac].tsf04,g_ima25,
#                          g_ima25_fac,g_tsf[l_ac].tsf05,'','MOD')
#TQC-B90236--mark--end
#TQC-B90236--add---begin
              CALL s_mod_lot(g_prog,g_tse.tse01,g_tsf[l_ac].tsf02,0,
                             g_tsf[l_ac].tsf03,g_tsf[l_ac].tsf12,
                             g_tsf[l_ac].tsf13,g_tsf[l_ac].tsf14,
                             g_tsf[l_ac].tsf04,g_ima25,g_ima25_fac,g_tsf[l_ac].tsf05,'','MOD',1)
#TQC-B90236--add---end
                   RETURNING l_r,g_qty
              IF l_r = "Y" THEN
                 LET g_tsf[l_ac].tsf05 = g_qty
                 DISPLAY BY NAME g_tsf[l_ac].tsf05
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
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
        END INPUT
 
        CLOSE t261_bcl
        COMMIT WORK
        CALL t261_delHeader()     #CHI-C30002 add
END FUNCTION
   
#CHI-C30002 -------- add -------- begin
FUNCTION t261_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_tse.tse01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM tse_file ",
                  "  WHERE tse01 LIKE '",l_slip,"%' ",
                  "    AND tse01 > '",g_tse.tse01,"'"
      PREPARE t261_pb1 FROM l_sql 
      EXECUTE t261_pb1 INTO l_cnt
      
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
         CALL t261_void(1)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end 
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM tse_file WHERE tse01 = g_tse.tse01
         INITIALIZE g_tse.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t261_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
 
    CONSTRUCT l_wc2 ON tsf02,tsf03,ima02,ima021,ima1002,#螢幕上取單身條件
                       ima135,tsf12,tsf13,tsf14,tsf04,tsf05,tsf09,tsf10,
                       tsf11,tsf06,tsf07,tsf08,tsf15
           FROM s_tsf[1].tsf02,s_tsf[1].tsf03,s_tsf[1].ima02,s_tsf[1].ima021,
                s_tsf[1].ima1002,s_tsf[1].ima135,s_tsf[1].tsf12,
                s_tsf[1].tsf13,s_tsf[1].tsf14,s_tsf[1].tsf04,s_tsf[1].tsf05,
                s_tsf[1].tsf09,s_tsf[1].tsf10,s_tsf[1].tsf11,s_tsf[1].tsf06,
                s_tsf[1].tsf07,s_tsf[1].tsf08,s_tsf[1].tsf15
                 
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
    CALL t261_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t261_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
    
    LET g_sql =
        "SELECT tsf02,tsf03,'','','','',tsf12,tsf13,tsf14,tsf04,",
        "       tsf05,tsf09,tsf10,tsf11,tsf06,tsf07,tsf08,tsf15,",
        "       tsfud01,tsfud02,tsfud03,tsfud04,tsfud05,",
        "       tsfud06,tsfud07,tsfud08,tsfud09,tsfud10,",
        "       tsfud11,tsfud12,tsfud13,tsfud14,tsfud15", 
        "  FROM tsf_file ",
        " WHERE tsf01 ='",g_tse.tse01,"'",  #單頭
         "  AND ", p_wc2 CLIPPED, #單身
        " ORDER BY tsf02"
    
    PREPARE t261_pb FROM g_sql
    DECLARE tsf_cs                       #SCROLL CURSOR
        CURSOR FOR t261_pb
    CALL g_tsf.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH tsf_cs INTO g_tsf[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT ima02,ima021,ima1002,ima135 INTO g_tsf[g_cnt].ima02,g_tsf[g_cnt].ima021,                                                    
                                                g_tsf[g_cnt].ima1002,g_tsf[g_cnt].ima135                                                    
          FROM ima_file WHERE ima01=g_tsf[g_cnt].tsf03  
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_tsf.deleteElement(g_cnt)
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
    #FUN-B30170 add begin-------------------------
    LET g_sql = " SELECT rvbs02,rvbs021,ima02,ima021,rvbs022,rvbs04,rvbs03,rvbs05,rvbs06,rvbs07,rvbs08",
                "   FROM rvbs_file, OUTER ima_file ",
                "  WHERE rvbs00 = '",g_prog,"' AND rvbs01 = '",g_tse.tse01,"'",
                "    AND rvbs021 = ima_file.ima01 AND rvbs09 = -1"
    PREPARE sel_rvbs_pre FROM g_sql
    DECLARE rvbs_curs CURSOR FOR sel_rvbs_pre

    CALL g_rvbs.clear()

    LET g_cnt = 1
   #FOREACH rvbs_curs INTO g_rvbs[g_cnt].*    #CHI-C30106 mark
    FOREACH rvbs_curs INTO g_rvbs_1[g_cnt].*  #CHI-C30106 
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rvbs.deleteElement(g_cnt)
    LET g_rec_b1=g_cnt-1

    LET g_sql = " SELECT rvbs02,rvbs021,ima02,ima021,rvbs022,rvbs04,rvbs03,rvbs05,rvbs06,rvbs07,rvbs08",
                "   FROM rvbs_file, OUTER ima_file ",
                "  WHERE rvbs00 = '",g_prog,"' AND rvbs01 = '",g_tse.tse01,"'",
                "    AND rvbs021 = ima_file.ima01 AND rvbs09 = 1"
    PREPARE sel_rvbs_pre1 FROM g_sql
    DECLARE rvbs_curs1 CURSOR FOR sel_rvbs_pre1

    CALL g_rvbs_1.clear()

    LET g_cnt = 1
   #FOREACH rvbs_curs1 INTO g_rvbs_1[g_cnt].*   #CHI-C30106 mark
    FOREACH rvbs_curs1 INTO g_rvbs[g_cnt].*     #CHI-C30106
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rvbs_1.deleteElement(g_cnt)
    LET g_rec_b2=g_cnt-1
    #FUN-B30170 add -end--------------------------
END FUNCTION
 
FUNCTION t261_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
#FUN-B30170 add begin--------------------------
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_tsf TO s_tsf.* ATTRIBUTE(COUNT=g_rec_b)

         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()  
         AFTER DISPLAY
            CONTINUE DIALOG   #糷琌DIALOG
      END DISPLAY
      
      DISPLAY ARRAY g_rvbs_1 TO s_rvbs_1.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            CALL cl_show_fld_cont()
         AFTER DISPLAY
            CONTINUE DIALOG   #糷琌DIALOG
      END DISPLAY

      DISPLAY ARRAY g_rvbs TO s_rvbs.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            CALL cl_show_fld_cont()
         AFTER DISPLAY
            CONTINUE DIALOG   #糷琌DIALOG
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
         CALL t261_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###tse in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######tse in 040505
           END IF
           ACCEPT DIALOG                
 
      ON ACTION previous
         CALL t261_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###tse in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######tse in 040505
           END IF
	ACCEPT DIALOG           
 
      ON ACTION jump
         CALL t261_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DIALOG            
                              
      ON ACTION next
         CALL t261_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DIALOG              
                              
      ON ACTION last 
         CALL t261_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DIALOG             
                              
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG

      #FUN-D20039 -----------sta
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG
      #FUN-D20039 -----------end
                              
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
   
      &include "qry_string.4gl"
   END DIALOG
#FUN-B30170 add -end---------------------------
#FUN-B30170 mark begin-----------------------------------
#   DISPLAY ARRAY g_tsf TO s_tsf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
#         CALL t261_fetch('F')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###tse in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######tse in 040505
#           END IF
#           ACCEPT DISPLAY                
# 
#      ON ACTION previous
#         CALL t261_fetch('P')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###tse in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######tse in 040505
#           END IF
#	ACCEPT DISPLAY           
# 
#      ON ACTION jump
#         CALL t261_fetch('/')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)  
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)
#           END IF
#	ACCEPT DISPLAY            
#                              
#      ON ACTION next
#         CALL t261_fetch('N')
#         CALL cl_navigator_setting(g_curs_index, g_row_count) 
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)
#           END IF
#	ACCEPT DISPLAY              
#                              
#      ON ACTION last 
#         CALL t261_fetch('L')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1) 
#           END IF
#	ACCEPT DISPLAY             
#                              
#      ON ACTION void
#         LET g_action_choice="void"
#         EXIT DISPLAY
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
#FUN-B30170 mark -end------------------------------------
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t261_copy()
DEFINE
    l_n             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
    li_result       LIKE type_file.num5,          #No.FUN-680120 SMALLINT
    l_t1            LIKE poy_file.poy05,          #No.FUN-680120 VARCHAR(05)
    l_newdate       LIKE tse_file.tse02,
    l_newno         LIKE tse_file.tse01,
    l_oldno         LIKE tse_file.tse01
DEFINE l_tse21      LIKE tse_file.tse21   #MOD-AA0167 
DEFINE l_smy73      LIKE smy_file.smy73   #TQC-AC0293
 
    IF s_shut(0) THEN RETURN END IF
    IF g_tse.tse01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL t261_set_entry('a')
    LET g_before_input_done = TRUE
 
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
#    INPUT l_newno FROM tse01                     #MOD-AA0167
     INPUT l_newno,l_tse21 FROM tse01,tse21       #MOD-AA0167
 
        BEFORE INPUT
          CALL cl_set_docno_format("tse01")
          LET l_tse21 = g_today                   #MOD-AA0167
          DISPLAY l_tse21 TO tse21                #MOD-AA0167
          
        AFTER FIELD tse01
            IF NOT cl_null(l_newno) THEN
    #           CALL s_check_no("aim",l_newno,"","G","tse_file","tse01","")                #FUN-AA0046  mark
                CALL s_check_no("atm",l_newno,"","U7","tse_file","tse01","")                #FUN-AA0046
                    RETURNING li_result,l_newno
               DISPLAY l_newno TO tse01
               IF (NOT li_result) THEN                                                                                                 
                  LET g_tse.tse01=g_tse_o.tse01                                                                                        
                  NEXT FIELD tse01                                                                                                     
               END IF    

             #TQC-AC0293 -----------------add start--------------
              LET g_t1 = s_get_doc_no(l_newno)  
              SELECT smy73 INTO l_smy73 FROM smy_file
               WHERE smyslip = g_t1
              IF l_smy73 = 'Y' THEN
                 CALL cl_err('','asf-874',0)
                 LET g_tse.tse01=g_tse_o.tse01
                 NEXT FIELD tse01 
              END IF
             #TQC-AC0293 -----------------add end----------------
 
              BEGIN WORK
    #           CALL s_auto_assign_no("aim",l_newno,g_tse.tse02,"G","tse_file","tse01","","","")      #FUN-AA0046  mark
                CALL s_auto_assign_no("atm",l_newno,g_tse.tse02,"U7","tse_file","tse01","","","")      #FUN-AA0046
                    RETURNING li_result,l_newno
               IF (NOT li_result) THEN                                                                                                     
                    NEXT FIELD tse01                                                                                                         
               END IF                                                                                                                      
               DISPLAY l_newno TO tse01   
            END IF

#MOD-AA0167 --begin--
      AFTER FIELD tse21
           IF NOT cl_null(l_tse21) THEN 
               IF g_sma.sma53 IS NOT NULL AND l_tse21 <= g_sma.sma53 THEN 
                  CALL cl_err('','mfg9999',0)
                  NEXT FIELD CURRENT 
               END IF    
               CALL s_yp(l_tse21) RETURNING g_yy,g_mm
               IF g_yy*12+g_mm > g_sma.sma51*12+g_sma.sma52 THEN #不可大於現行年月
                  CALL cl_err('','mfg6091',0)
                  NEXT FIELD CURRENT 
               END IF            
            END IF          
#MOD-AA0167 --end--
            
      ON ACTION CONTROLP
            CASE
              WHEN INFIELD (tse01)
                 LET l_t1=s_get_doc_no(l_newno)
                 LET g_sql = " (smy73 <> 'Y' OR smy73 is null ) "           #TQC-AC0293
                 CALL smy_qry_set_par_where(g_sql)                          #TQC-AC0293
            #     CALL q_smy(FALSE,FALSE,l_t1,'AIM','G' )  #TQC-670008      #FUN-AA0046  mark
                 CALL q_oay(FALSE,FALSE,l_t1,'U7','ATM' )                   #FUN-AA0046
                      RETURNING l_t1             
                 LET l_newno = l_t1
                 DISPLAY l_newno TO tse01
                 NEXT FIELD tse01
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
        DISPLAY BY NAME g_tse.tse01 
        DISPLAY BY NAME g_tse.tse21             #MOD-AA0167        
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM tse_file         #單頭複製
        WHERE tse01=g_tse.tse01
        INTO TEMP y
    UPDATE y
        SET tse01=l_newno,    #新的鍵值
            tse21=l_tse21,    #MOD-AA0167        
            tseuser=g_user,   #資料所有者
            tsegrup=g_grup,   #資料所有者所屬群
            tseoriu=g_user,     #TQC-A30048 ADD
            tseorig=g_grup,     #TQC-A30048 ADD
            tsemodu=NULL,     #資料更改日期
            tsedate=g_today,  #資料建立日期
            tseacti='Y',      #有效資料
            tseconf='N',      #審核碼
            tsecond='',        #FUN-870100
            tseconu='',        #FUN-870100
            tsecont='',        #FUN-870100
            tsepost='N'       #過帳碼 
    INSERT INTO tse_file
        SELECT * FROM y
 
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","tse_file",g_tse.tse01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
        ROLLBACK WORK
        RETURN
    ELSE
        COMMIT WORK
    END IF
 
    DROP TABLE x
    SELECT * FROM tsf_file         #單身複製
        WHERE tsf01=g_tse.tse01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","x",g_tse.tse01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
        RETURN
    END IF
    UPDATE x
        SET tsf01=l_newno
    INSERT INTO tsf_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","tsf_file",g_tse.tse01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
        RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
        
     LET l_oldno = g_tse.tse01
     SELECT tse_file.* INTO g_tse.* FROM tse_file
      WHERE tse01 = l_newno
     CALL t261_u()
     CALL t261_b()
     #FUN-C80046---begin
     #LET g_tse.tse01 = l_oldno
     #SELECT tse_file.* INTO g_tse.* FROM tse_file 
     # WHERE tse01 = l_oldno
     #CALL t261_show()
     #FUN-C80046---end
     DISPLAY BY NAME g_tse.tse01
END FUNCTION
 
FUNCTION t261_y()
   DEFINE  l_tsecont  LIKE tse_file.tsecont  #FUN-870100
   DEFINE  l_rvbs06   LIKE rvbs_file.rvbs06  #CHI-A70027 add
   DEFINE  i          LIKE type_file.num5    #CHI-A70027 add
   DEFINE  l_tsf12    LIKE tsf_file.tsf12    #No.FUN-AA0048
   DEFINE  l_img09    LIKE img_file.img09    #CHI-C30064 add
   DEFINE  l_ima25_fac LIKE ima_file.ima25   #CHI-C30064 add
   DEFINE  l_gen02     LIKE gen_file.gen02   #TQC-C80161 add

   #IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30106       #TQC-C80161 mark
    IF g_tse.tse01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tse.* FROM tse_file WHERE tse01=g_tse.tse01
    IF g_tse.tseacti='N' THEN
       CALL cl_err(g_tse.tse01,'mfg1000',0)
       RETURN
    END IF
   #IF g_tse.tseconf='Y' THEN RETURN END IF                           #TQC-C80161 mark
    IF g_tse.tseconf='Y' THEN CALL cl_err(g_tse.tse01,'atm-158',0) RETURN END IF #TQC-C80161 add
    IF g_tse.tseconf='X' THEN 
       CALL cl_err(g_tse.tse01,'axr-103',0) 
       RETURN
    END IF
   #IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30106 mark
    IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30106       #TQC-C80161 add
    #No.FUN-AA0048  --Begin
    IF NOT s_chk_ware(g_tse.tse12) THEN
       RETURN
    END IF
    DECLARE t261_ware_cs1 CURSOR FOR
     SELECT tsf12 FROM tsf_file
      WHERE tsf01 = g_tse.tse01
    FOREACH t261_ware_cs1 INTO l_tsf12
        IF NOT s_chk_ware(l_tsf12) THEN
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
     WHERE ima01 = g_tse.tse03
       AND imaacti = "Y"
    IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
       SELECT SUM(rvbs06) INTO l_rvbs06
         FROM rvbs_file
        WHERE rvbs00 = g_prog
          AND rvbs01 = g_tse.tse01
          AND rvbs02 = 0
          AND rvbs09 = -1

       IF cl_null(l_rvbs06) THEN
          LET l_rvbs06 = 0
       END IF

       CALL t261_ima25(g_tse.tse03,g_tse.tse12,g_tse.tse13,g_tse.tse14,g_tse.tse04)                   
      #CHI-C30064---Start---add
       SELECT img09 INTO l_img09 FROM img_file
        WHERE img01= g_tse.tse03 AND img02= g_tse.tse12 
          AND img03= g_tse.tse13 AND img04= g_tse.tse14 
       CALL s_umfchk(g_tse.tse03,g_tse.tse04,l_img09) RETURNING g_cnt,l_ima25_fac
       IF g_cnt = '1' THEN
          LET l_ima25_fac = 1
       END IF             
      #CHI-C30064---End---add 
      #IF (g_tse.tse05 * g_ima25_fac) <> l_rvbs06 THEN
       IF (g_tse.tse05 * l_ima25_fac) <> l_rvbs06 THEN #CHI-C30064
          CALL cl_err(g_tse.tse03,"aim-011",1)
          RETURN 
       END IF
    END IF
    #控管單身批序號的數量是否與單據數量相符
    FOR i = 1 TO g_rec_b
       LET g_ima918 = ''
       LET g_ima921 = ''
       SELECT ima918,ima921 INTO g_ima918,g_ima921 
         FROM ima_file
        WHERE ima01 = g_tsf[i].tsf03
          AND imaacti = "Y"
       IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
          SELECT SUM(rvbs06) INTO l_rvbs06
            FROM rvbs_file
           WHERE rvbs00 = g_prog
             AND rvbs01 = g_tse.tse01
             AND rvbs02 = g_tsf[i].tsf02
             AND rvbs09 = 1

          IF cl_null(l_rvbs06) THEN
             LET l_rvbs06 = 0
          END IF

          CALL t261_ima25(g_tsf[i].tsf03,g_tsf[i].tsf12,g_tsf[i].tsf13,g_tsf[i].tsf14,g_tsf[i].tsf04)                   
         #CHI-C30064---Start---add
           SELECT img09 INTO l_img09 FROM img_file
            WHERE img01= g_tsf[i].tsf03 AND img02= g_tsf[i].tsf12
              AND img03= g_tsf[i].tsf13 AND img04= g_tsf[i].tsf14
          CALL s_umfchk(g_tsf[i].tsf03,g_tsf[i].tsf04,l_img09) RETURNING g_cnt,l_ima25_fac
          IF g_cnt = '1' THEN
             LET l_ima25_fac = 1
          END IF
         #CHI-C30064---End---add 
         #IF (g_tsf[i].tsf05 * g_ima25_fac) <> l_rvbs06 THEN
          IF (g_tsf[i].tsf05 * l_ima25_fac) <> l_rvbs06 THEN #CHI-C30064
             CALL cl_err(g_tsf[i].tsf03,"aim-011",1)
             RETURN
          END IF
       END IF
    END FOR
    #CHI-A70027 add --end--
 
    LET g_success='Y'
    BEGIN WORK
 
    OPEN t261_cl USING g_tse.tse01
    IF STATUS THEN
       CALL cl_err("OPEN t261_cl:", STATUS, 1)
       CLOSE t261_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t261_cl INTO g_tse.*  # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tse.tse01,SQLCA.sqlcode,0)
        CLOSE t261_cl
        ROLLBACK WORK
        RETURN
    END IF
 
    LET l_tsecont=TIME  #FUN-870100
    UPDATE tse_file SET tseconf='Y',tsecond=g_today,tseconu=g_user,tsecont=l_tsecont  #FUN-870100
     WHERE tse01 = g_tse.tse01
    IF STATUS THEN
       CALL cl_err3("upd","tse_file",g_tse.tse01,"",STATUS,"","upd tseconf",1)  #No.FUN-660104
       LET g_success = 'N'
    END IF
    IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_cmmsg(1)
    ELSE
       ROLLBACK WORK
       CALL cl_rbmsg(1)
    END IF
   #SELECT tseconf INTO g_tse.tseconf FROM tse_file     #TQC-C80161 mark
    SELECT tseconf,tsecond,tseconu,tsecont INTO g_tse.tseconf,g_tse.tsecond,g_tse.tseconu,g_tse.tsecont FROM tse_file        #TQC-C80161 add
     WHERE tse01 = g_tse.tse01
    DISPLAY BY NAME g_tse.tseconf,g_tse.tsecond,g_tse.tseconu,g_tse.tsecont  #FUN-870100
   #TQC-C80161 add begin ---
    SELECT gen02 INTO l_gen02 
      FROM gen_file
     WHERE gen01 = g_tse.tseconu
    DISPLAY l_gen02 TO FORMONLY.tseconu_desc
   #TQC-C80161 add end ----
    IF g_tse.tseconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF  
    IF g_tse.tseconf='Y' THEN LET g_approve='Y' ELSE LET g_approve='N' END IF   #No.TQC-640116
#   CALL cl_set_field_pic(g_tse.tseconf,g_approve,g_tse.tsepost,"","",g_tse.tseacti)     #No.TQC-640116  #MOD-B60100 mark
    CALL cl_set_field_pic(g_tse.tseconf,g_approve,g_tse.tsepost,"",g_chr,g_tse.tseacti)  #MOD-B60100
END FUNCTION
 
FUNCTION t261_z()
DEFINE l_n LIKE type_file.num5          #No.FUN-680120 SMALLINT
   DEFINE l_gen02 LIKE gen_file.gen02 #CHI-D20015 add
 
    IF g_tse.tse01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tse.* FROM tse_file WHERE tse01=g_tse.tse01
    IF g_tse.tseconf='N' THEN RETURN END IF
    IF g_tse.tseconf='X' THEN 
       CALL cl_err('','axr-103',0) 
       RETURN
    END IF
    IF g_tse.tsepost = 'Y' THEN
       CALL cl_err(g_tse.tse01,"afa-106",0)
       RETURN
    END IF
    IF NOT cl_confirm('axm-109') THEN RETURN END IF
    #No.FUN-A50071 -----start---------    
    #-->POS單號不為空時不可取消確認
    IF NOT cl_null(g_tse.tse20) THEN
       CALL cl_err(' ','axm-743',0)
       RETURN
    END IF 
    #No.FUN-A50071 -----end---------
    
    LET g_success='Y'
    BEGIN WORK
        OPEN t261_cl USING g_tse.tse01
        IF STATUS THEN
           CALL cl_err("OPEN t261_cl:", STATUS, 1)
           CLOSE t261_cl
           ROLLBACK WORK
           RETURN
        END IF
        FETCH t261_cl INTO g_tse.*               # 對DB鎖定
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_tse.tse01,SQLCA.sqlcode,0)
            CLOSE t261_cl
            ROLLBACK WORK
            RETURN
        END IF
       #UPDATE tse_file SET tseconf='N',tsecond='',tseconu='',tsecont=''  #FUN-870100#FUN-870100#CHI-D20015 mark
        UPDATE tse_file SET tseconf='N',tsecond=g_today,tseconu= g_user,tsecont=g_time#CHI-D20015 add
            WHERE tse01 = g_tse.tse01
        IF STATUS THEN
            CALL cl_err3("upd","tse_file",g_tse.tse01,"",STATUS,"","upd tseconf",1)  #No.FUN-660104
            LET g_success='N'
        END IF
        IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_cmmsg(1)
        ELSE
            ROLLBACK WORK
            CALL cl_rbmsg(1)
        END IF
       #SELECT tseconf INTO g_tse.tseconf FROM tse_file        #TQC-C80161 mark
        SELECT tseconf,tsecond,tseconu,tsecont INTO g_tse.tseconf,g_tse.tsecond,g_tse.tseconu,g_tse.tsecont FROM tse_file        #TQC-C80161 add
            WHERE tse01 = g_tse.tse01
        DISPLAY BY NAME g_tse.tseconf,g_tse.tsecond,g_tse.tseconu,g_tse.tsecont  #FUN-870100
       #DISPLAY '' TO FORMONLY.tseconu_desc#CHI-D20015 mark
       #CHI-D20015--add-s-tr
        SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_tse.tseconu
        DISPLAY l_gen02 TO tseconu_desc
       #CHI-D20015--add--end
        IF g_tse.tseconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF  
        IF g_tse.tseconf='Y' THEN LET g_approve='Y' ELSE LET g_approve='N' END IF   #No.TQC-640116
#       CALL cl_set_field_pic(g_tse.tseconf,g_approve,g_tse.tsepost,"","",g_tse.tseacti)     #No.TQC-640116  #MOD-B60100 mark
        CALL cl_set_field_pic(g_tse.tseconf,g_approve,g_tse.tsepost,"",g_chr,g_tse.tseacti)  #MOD-B60100
END FUNCTION
 
FUNCTION t261_post()
DEFINE l_img10     LIKE img_file.img10,
       l_img09     LIKE img_file.img09,
       l_ima25     LIKE ima_file.ima25,
       l_ima906    LIKE ima_file.ima906,
       l_imafac    LIKE type_file.num5,             #No.FUN-680120 SMALLINT        
       l_imaqty    LIKE tse_file.tse05
DEFINE l_cnt       LIKE type_file.num10             #No.FUN-680120 INTEGER
DEFINE l_sql       LIKE type_file.chr1000           #No.FUN-680120 VARCHAR(400)
DEFINE l_tsf041    LIKE tsf_file.tsf041
DEFINE l_cnt_img   LIKE type_file.num5     #FUN-C70087
DEFINE l_cnt_imgg  LIKE type_file.num5     #FUN-C70087
DEFINE l_tsf       RECORD LIKE tsf_file.*  #FUN-C70087
 
    IF g_tse.tseacti = 'N' THEN
       CALL cl_err(g_tse.tse01,'mfg1000',0)
       RETURN
    END IF
    IF g_tse.tseconf = 'X' THEN  
       CALL cl_err(g_tse.tse01,'9024',1)
       RETURN
    END IF
    IF g_tse.tseconf='N' OR g_tse.tsepost='Y' THEN
       CALL cl_err(g_tse.tse01,'afa-100',1)
       RETURN 
    END IF

 #MOD-AA0167 --begin--
    IF g_sma.sma53 IS NOT NULL AND g_tse.tse21 <= g_sma.sma53 THEN 
       CALL cl_err('','mfg9999',0)
       RETURN
    END IF    
    CALL s_yp(g_tse.tse21) RETURNING g_yy,g_mm
    IF g_yy*12+g_mm > g_sma.sma51*12+g_sma.sma52 THEN #不可大於現行年月
       CALL cl_err('','mfg6091',0)
       RETURN 
     END IF           
 #MOD-AA0167 --end--
     
    IF NOT cl_confirm('mfg0176') THEN RETURN END IF   
 
    LET g_success='Y'   #0211
    BEGIN WORK
   #FUN-C70087---begin
   CALL s_padd_img_init()  #FUN-CC0095
   CALL s_padd_imgg_init()  #FUN-CC0095
   
   DECLARE t261_p_c CURSOR FOR SELECT * FROM tsf_file
     WHERE tsf01 = g_tse.tse01 

   FOREACH t261_p_c INTO l_tsf.*
      IF STATUS THEN EXIT FOREACH END IF
      LET l_cnt_img = 0
      SELECT COUNT(*) INTO l_cnt_img
        FROM img_file
       WHERE img01 = l_tsf.tsf03
         AND img02 = l_tsf.tsf12
         AND img03 = l_tsf.tsf13
         AND img04 = l_tsf.tsf14
       IF l_cnt_img = 0 THEN
          #CALL s_padd_img_data(l_tsf.tsf03,l_tsf.tsf12,l_tsf.tsf13,l_tsf.tsf14,g_tse.tse01,l_tsf.tsf02,g_tse.tse21,l_img_table) #FUN-CC0095
          CALL s_padd_img_data1(l_tsf.tsf03,l_tsf.tsf12,l_tsf.tsf13,l_tsf.tsf14,g_tse.tse01,l_tsf.tsf02,g_tse.tse21) #FUN-CC0095
       END IF

       CALL s_chk_imgg(l_tsf.tsf03,l_tsf.tsf12,
                       l_tsf.tsf13,l_tsf.tsf14,
                       l_tsf.tsf06) RETURNING g_flag
       IF g_flag = 1 THEN
          #CALL s_padd_imgg_data(l_tsf.tsf03,l_tsf.tsf12,l_tsf.tsf13,l_tsf.tsf14,l_tsf.tsf06,g_tse.tse01,l_tsf.tsf02,l_imgg_table) #FUN-CC0095
          CALL s_padd_imgg_data1(l_tsf.tsf03,l_tsf.tsf12,l_tsf.tsf13,l_tsf.tsf14,l_tsf.tsf06,g_tse.tse01,l_tsf.tsf02) #FUN-CC0095
       END IF 
       CALL s_chk_imgg(l_tsf.tsf03,l_tsf.tsf12,
                       l_tsf.tsf13,l_tsf.tsf14,
                       l_tsf.tsf09) RETURNING g_flag
       IF g_flag = 1 THEN
          #CALL s_padd_imgg_data(l_tsf.tsf03,l_tsf.tsf12,l_tsf.tsf13,l_tsf.tsf14,l_tsf.tsf09,g_tse.tse01,l_tsf.tsf02,l_imgg_table) #FUN-CC0095
          CALL s_padd_imgg_data1(l_tsf.tsf03,l_tsf.tsf12,l_tsf.tsf13,l_tsf.tsf14,l_tsf.tsf09,g_tse.tse01,l_tsf.tsf02) #FUN-CC0095
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
   #            " FROM ",l_imgg_table CLIPPED  #,g_cr_db_str
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
         #CALL s_padd_img_del(l_img_table)  #FUN-CC0095
         #CALL s_padd_imgg_del(l_imgg_table)  #FUN-CC0095
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   #CALL s_padd_img_del(l_img_table)  #FUN-CC0095
   #CALL s_padd_imgg_del(l_imgg_table)  #FUN-CC0095
   #FUN-C70087---end
   #CHI-C30106---add---S---
    OPEN t261_cl USING g_tse.tse01
            IF STATUS THEN
               CALL cl_err("OPEN t261_cl:", STATUS, 1)
               CLOSE t261_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t261_cl INTO g_tse.*            # 鎖住將被更改或撤銷的資料
            IF SQLCA.sqlcode THEN
              CALL cl_err(g_tse.tse01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t261_cl
              RETURN
            END IF
   #CHI-C30106---add---E---

    CALL t261_post_update(g_tse.tse01)
     CALL s_showmsg()        #No.FUN-710033
    IF g_success='Y' THEN
       CALL cl_err(g_tse.tse01,'lib-022',0)
       UPDATE tse_file SET tsepost='Y'     #MOD-A80046
       WHERE tse01 = g_tse.tse01          #MOD-A80046
    ELSE
       CALL cl_err(g_tse.tse01,'lib-028',0)
    END IF
 
#    UPDATE tse_file SET tsepost='Y'     #MOD-A80046
#     WHERE tse01 = g_tse.tse01          #MOD-A80046
 
#    IF STATUS THEN                              #MOD-A80061
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN #MOD-A80061
       CALL cl_err3("upd","tse_file",g_tse.tse01,"",STATUS,"","upd tsepost",1)  #No.FUN-660104
       LET g_success = 'N'                                                                                                          
    END IF                                                                                                                          
    IF g_success = 'Y' THEN                                                                                                         
       COMMIT WORK                                                                                                                  
       CALL cl_cmmsg(1)                                                                                                             
    ELSE                                                                                                                            
       ROLLBACK WORK                                                                                                                
       CALL cl_rbmsg(1)                                                                                                             
    END IF                                                                                                                          
    SELECT tsepost,tse19 INTO g_tse.tsepost,g_tse.tse19 FROM tse_file   #No.FUN-950021                                                                  
     WHERE tse01 = g_tse.tse01                                                                                                      
 
    DISPLAY g_tse.tsepost TO tsepost
    DISPLAY BY NAME g_tse.tse19           #No.FUN-950021
    IF g_tse.tseconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF  
    IF g_tse.tseconf='Y' THEN LET g_approve='Y' ELSE LET g_approve='N' END IF   #No.TQC-640116
#   CALL cl_set_field_pic(g_tse.tseconf,g_approve,g_tse.tsepost,"","",g_tse.tseacti)  #No.TQC-640116  #MOD-B60100 mark
    CALL cl_set_field_pic(g_tse.tseconf,g_approve,g_tse.tsepost,"",g_chr,g_tse.tseacti)  #MOD-B60100
    CALL t261_show()
END FUNCTION
 
FUNCTION t261_post_update(p_tse01)
   DEFINE p_tse01        LIKE tse_file.tse01
   DEFINE l_tse          RECORD LIKE tse_file.*
   DEFINE l_sfb01        LIKE sfb_file.sfb01
   DEFINE l_sfp01        LIKE sfp_file.sfp01
   DEFINE l_sfp          RECORD LIKE sfp_file.*
   DEFINE l_ksc01        LIKE ksc_file.ksc01
   DEFINE l_flag         LIKE type_file.num5
   DEFINE l_o_prog       STRING
 
   SELECT * INTO l_tse.* FROM tse_file WHERE tse01 = p_tse01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','tse_file',p_tse01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
 
   #Generate W/O
   CALL t261_ins_sfb(p_tse01) RETURNING l_flag,l_sfb01
   IF NOT l_flag THEN
      LET g_success='N'
      RETURN
   END IF
 
#--TQC-CC0142--mark--star--
#  #W/OConfirm Check
#  CALL i301sub_firm1_chk(l_sfb01,TRUE)
#  IF g_success = 'N' THEN
#     RETURN
#  END IF
#--TQC-CC0142--mark--end--
 
   #W/O Confirm
   CALL i301sub_firm1_upd(l_sfb01,NULL,TRUE)
   IF g_success = 'N' THEN
      RETURN
   END IF
 
   #Genero W.O Issue Note
   CALL t261_ins_sfp(p_tse01,l_sfb01) RETURNING l_flag,l_sfp01
   IF NOT l_flag THEN
      LET g_success = 'N'
      RETURN
   END IF
 
   #No.CHI-A70051  --Begin
   LET l_o_prog = g_prog
   #CASE l_sfp.sfp06
   #   WHEN "1" LET g_prog='asfi511'
   #   WHEN "2" LET g_prog='asfi512'
   #   WHEN "3" LET g_prog='asfi513'
   #   WHEN "4" LET g_prog='asfi514'
   #   WHEN "6" LET g_prog='asfi526'
   #   WHEN "7" LET g_prog='asfi527'
   #   WHEN "8" LET g_prog='asfi528'
   #   WHEN "9" LET g_prog='asfi529'
   
   #END CASE
   LET g_prog = 'asfi511'

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
 
   #No.CHI-A70051  --End  

   #W.O Issue Note Post
   CALL i501sub_s('1',l_sfp01,TRUE,'N')
   IF g_success = 'N' THEN
      RETURN
   END IF
   LET g_prog = l_o_prog
 
   #Generate Stock-In Note
   CALL t261_ins_ksc(p_tse01,l_sfb01,l_sfp01)
        RETURNING l_flag,l_ksc01
   IF NOT l_flag THEN
      LET g_success = 'N'
      RETURN
   END IF
 
   #No.CHI-A70051  --Begin
   LET l_o_prog = g_prog
   LET g_prog = 'asft622'
   #No.CHI-A70051  --End  
   #Stock-In Note Confirm Check
   CALL t622sub_y_chk(l_ksc01,NULL) #CHI-C30118 add g_action_choice #TQC-C60079
   IF g_success = 'N' THEN
      RETURN
   END IF
 
   #Stock-In Note Confirm
   CALL t622sub_y_upd(l_ksc01,NULL,TRUE)
   IF g_success = 'N' THEN
      RETURN
   END IF
 
   #Stock-In Note Post
   CALL t622sub_s(l_ksc01,'1',TRUE,NULL)
   IF g_success = 'N' THEN
     RETURN
   END IF
   LET g_prog = l_o_prog


   #No.CHI-A80043  --Begin
   CALL t261_sfb_close(l_sfb01)
   IF g_success = 'N' THEN
      RETURN
   END IF
   #No.CHI-A80043  --End  
 
   #Update atmt261
   UPDATE tse_file SET tse19 = l_sfb01 WHERE tse01 = p_tse01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('upd','tse_file',p_tse01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
 
END FUNCTION
 
 
FUNCTION t261_undo_post()
DEFINE l_img10     LIKE img_file.img10,
       l_img09     LIKE img_file.img09,
       l_ima25     LIKE ima_file.ima25,
       l_ima906    LIKE ima_file.ima906,
       l_imafac    LIKE type_file.num5,             #No.FUN-680120 SMALLINT        
       l_imaqty    LIKE tse_file.tse05
DEFINE l_cnt       LIKE type_file.num10             #No.FUN-680120 INTEGER
DEFINE l_sql       LIKE type_file.chr1000           #No.FUN-680120 VARCHAR(400)
DEFINE l_tsf041    LIKE tsf_file.tsf041
 
    IF g_tse.tseacti = 'N' THEN
       CALL cl_err(g_tse.tse01,'mfg1000',0)
       RETURN
    END IF
    IF g_tse.tsepost='N' THEN
       CALL cl_err(g_tse.tse01,'afa-108',1)
       RETURN 
    END IF

 #MOD-AA0167 --begin--
    IF g_sma.sma53 IS NOT NULL AND g_tse.tse21 <= g_sma.sma53 THEN 
       CALL cl_err('','mfg9999',0)
       RETURN
    END IF    
    CALL s_yp(g_tse.tse21) RETURNING g_yy,g_mm
    IF g_yy*12+g_mm > g_sma.sma51*12+g_sma.sma52 THEN #不可大於現行年月
       CALL cl_err('','mfg6091',0)
       RETURN 
     END IF           
 #MOD-AA0167 --end--
     
    IF NOT cl_confirm('asf-663') THEN RETURN END IF 
    #No.FUN-A50071 ----------start----------   
    #-->POS單號不為空時不可過帳還原
    IF NOT cl_null(g_tse.tse20) THEN
       CALL cl_err('','axm-744' ,0)
       RETURN 
    END IF 
    #No.FUN-A50071 ----------end----------   
 
    LET g_success='Y'   #0211
    BEGIN WORK
    CALL t261_undo_post_update(g_tse.tse01)
       CALL s_showmsg()        #No.FUN-710033
    IF g_success='Y' THEN
       CALL cl_err(g_tse.tse01,'lib-022',0)
       UPDATE tse_file SET tsepost= 'N'               #MOD-A80061
        WHERE tse01 = g_tse.tse01                     #MOD-A80061
    ELSE
       CALL cl_err(g_tse.tse01,'lib-028',0)
    END IF
 
#    UPDATE tse_file SET tsepost= 'N'               #MOD-A80061
#     WHERE tse01 = g_tse.tse01                     #MOD-A80061
 
#    IF STATUS THEN                                 #MOD-A80061 
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN    #MOD-A80061
       CALL cl_err3("upd","tse_file",g_tse.tse01,"",STATUS,"","upd tsepost",1)  #No.FUN-660104
       LET g_success = 'N'                                                                                                          
    END IF                                                                                                                          
    IF g_success = 'Y' THEN                                                                                                         
       COMMIT WORK                                                                                                                  
       CALL cl_cmmsg(1)                                                                                                             
    ELSE                                                                                                                            
       ROLLBACK WORK                                                                                                                
       CALL cl_rbmsg(1)                                                                                                             
    END IF                                                                                                                          
    SELECT tsepost,tse19 INTO g_tse.tsepost,g_tse.tse19 FROM tse_file  #No.FUN-950021                                                                   
     WHERE tse01 = g_tse.tse01                                                                                                      
 
    DISPLAY g_tse.tsepost TO tsepost
    DISPLAY BY NAME g_tse.tse19       #No.FUN-950021
    IF g_tse.tseconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF  
    IF g_tse.tseconf='Y' THEN LET g_approve='Y' ELSE LET g_approve='N' END IF   #No.TQC-640116
#   CALL cl_set_field_pic(g_tse.tseconf,g_approve,g_tse.tsepost,"","",g_tse.tseacti)     #No.TQC-640116  #MOD-B60100 mark
    CALL cl_set_field_pic(g_tse.tseconf,g_approve,g_tse.tsepost,"",g_chr,g_tse.tseacti)  #MOD-B60100
    CALL t261_show()
END FUNCTION
 
FUNCTION t261_undo_post_update(p_tse01)
   DEFINE p_tse01      LIKE tse_file.tse01
   DEFINE l_tse19      LIKE tse_file.tse19
   DEFINE l_sfb01      LIKE sfb_file.sfb01
   DEFINE l_sfb04      LIKE sfb_file.sfb04
   DEFINE l_ksc01      LIKE ksc_file.ksc01
   DEFINE l_sfp01      LIKE sfp_file.sfp01
   DEFINE l_sfp06      LIKE sfp_file.sfp06
   DEFINE l_o_prog     STRING
   #FUN-BC0104-add-str--
   DEFINE l_ksd03  LIKE ksd_file.ksd03,
          l_ksd17  LIKE ksd_file.ksd17,
          l_ksd47  LIKE ksd_file.ksd47,
          l_flagg  LIKE type_file.chr1
   DEFINE l_cn     LIKE  type_file.num5
   DEFINE l_c      LIKE  type_file.num5
   DEFINE l_ksd_a  DYNAMIC ARRAY OF RECORD
          ksd17    LIKE  ksd_file.ksd17,
          ksd47    LIKE  ksd_file.ksd47,
          flagg    LIKE  type_file.chr1
                   END RECORD
   #FUN-BC0104-add-end--
 
   SELECT tse19 INTO l_tse19 FROM tse_file WHERE tse01 = p_tse01
   IF cl_null(l_tse19) THEN
      CALL cl_err(p_tse01,'atm-411','1')  #組合/拆解單對應的工單號為空!
      LET g_success = 'N'
      RETURN
   END IF
 
   LET l_sfb01 = l_tse19

   #No.CHI-A80043  --Begin
   CALL t261_sfb_undo_close(l_sfb01)
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
 
   #Stock-in
   LET l_o_prog = g_prog
   LET g_prog = 'asft622'
   SELECT UNIQUE ksd01 INTO l_ksc01 FROM ksc_file,ksd_file
    WHERE ksc01 = ksd01
      AND ksd11 = l_sfb01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','ksd_file',l_sfb01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
 
   #Stock-in Note undo_post
   CALL t622sub_w(l_ksc01,NULL,TRUE,'1')
   IF g_success = 'N' THEN
      RETURN
   END IF
 
   #Stock-in Note Undo_confirm
   CALL t622sub_z(l_ksc01,NULL,TRUE)
   IF g_success = 'N' THEN
      RETURN
   END IF
 
   #Delete Stock-in Note
   DELETE FROM ksc_file WHERE ksc01 = l_ksc01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3('del','ksc_file',l_ksc01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
   #FUN-BC0104-add-str--
   LET l_cn = 1
   DECLARE upd_ksd CURSOR FOR
    SELECT ksd03 FROM ksd_file WHERE ksd01 = l_ksc01
   FOREACH upd_ksd INTO l_ksd03
      CALL s_iqctype_ksd(l_ksc01,l_ksd03) RETURNING l_ksd17,l_ksd47,l_flagg
      LET l_ksd_a[l_cn].ksd17 = l_ksd17
      LET l_ksd_a[l_cn].ksd47 = l_ksd47
      LET l_ksd_a[l_cn].flagg = l_flagg
      LET l_cn = l_cn + 1
   END FOREACH
   #FUN-BC0104-add-end--
   DELETE FROM ksd_file WHERE ksd01 = l_ksc01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3('del','ksd_file',l_ksc01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
   #FUN-BC0104-add-str--
   FOR l_c=1 TO l_cn-1
      IF l_ksd_a[l_c].flagg = 'Y' THEN
         IF NOT s_iqctype_upd_qco20(l_ksd_a[l_c].ksd17,'','',l_ksd_a[l_c].ksd47,'3') THEN
            LET g_success ='N'
            RETURN
         END IF
      END IF
   END FOR
   #FUN-BC0104-add-end--

   #No.CHI-A70051  --Begin
   DELETE FROM rvbs_file WHERE rvbs00 = 'asft622' AND rvbs01 = l_ksc01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('del','rvbs_file','asft622',l_ksc01,SQLCA.sqlcode,'','','1')
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
      WHEN "D" LET g_prog='asfi519'        #FUN-C70014
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
#FUN-B70074 ------------------Begin-----------------
   ELSE
      IF NOT s_industry('std') THEN
         IF NOT s_del_sfsi(l_sfp01,'','') THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF     
#FUN-B70074 ------------------End------------------- 
   END IF
   #No.CHI-A70051  --Begin
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
 
   #update tse19
   UPDATE tse_file SET tse19 = '' WHERE tse01 = p_tse01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3('upd','tse_file',p_tse01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
 
END FUNCTION
 
  
FUNCTION t261_out()
    DEFINE
        l_tse           RECORD LIKE tse_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680120 VARCHAR(20)               # External(Disk) file name
        l_za05          LIKE za_file.za05,  
        sr              RECORD
                        tse01       LIKE tse_file.tse01,
                        tse02       LIKE tse_file.tse02,
                        tse17       LIKE tse_file.tse17,
                        tse15       LIKE tse_file.tse15,
                        tse16       LIKE tse_file.tse16,
                        tse03       LIKE tse_file.tse03,
                        tse12       LIKE tse_file.tse12,
                        tse13       LIKE tse_file.tse13,
                        tse14       LIKE tse_file.tse14,
                        tse04       LIKE tse_file.tse04,
                        tse05       LIKE tse_file.tse05,
                        tse09       LIKE tse_file.tse09,
                        tse10       LIKE tse_file.tse10,
                        tse11       LIKE tse_file.tse11,
                        tse06       LIKE tse_file.tse06,
                        tse07       LIKE tse_file.tse07,
                        tse08       LIKE tse_file.tse08,
                        tse18       LIKE tse_file.tse18,
                        tsf02       LIKE tsf_file.tsf02,   #項次
                        tsf03       LIKE tsf_file.tsf03,   #產品編號
                        tsf12       LIKE tsf_file.tsf12,   #倉庫
                        tsf13       LIKE tsf_file.tsf13,   #庫位
                        tsf14       LIKE tsf_file.tsf14,   #批號
                        tsf04       LIKE tsf_file.tsf04,   #單位
                        tsf05       LIKE tsf_file.tsf05,   #數量
                        tsf09       LIKE tsf_file.tsf09,   #單位二
                        tsf10       LIKE tsf_file.tsf10,   #單位二轉換率
                        tsf11       LIKE tsf_file.tsf11,   #單位二數量
                        tsf06       LIKE tsf_file.tsf06,   #單位一
                        tsf07       LIKE tsf_file.tsf07,   #單位一轉換率
                        tsf08       LIKE tsf_file.tsf08,   #單位一數量
                        tsf15       LIKE tsf_file.tsf15    #備注
                        END RECORD
DEFINE l_sql1     LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(500)
DEFINE  l_tse01         LIKE tse_file.tse01,                                                                                        
        l_tse03         LIKE tse_file.tse03,                                                                                        
        l_azf03         LIKE azf_file.azf03,                                                                                        
        l_gem02         LIKE gem_file.gem02,                                                                                        
        l_imd02a        LIKE imd_file.imd02,                                                                                        
        l_ime03a        LIKE ime_file.ime03,                                                                                        
        l_imd02         LIKE imd_file.imd02,                                                                                        
        l_ime03         LIKE ime_file.ime03,                                                                                        
        l_ima02a        LIKE ima_file.ima02,                                                                                        
        l_ima02         LIKE ima_file.ima02                                                                                         
     CALL cl_del_data(l_table)                                               #No.FUN-850155     
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                #No.FUN-850155   
    IF cl_null(g_tse.tse01) THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF   
    IF cl_null(g_wc) THEN 
       LET g_wc=" tse01='",g_tse.tse01,"'"
       LET g_wc2=" 1=1 "
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT tse01,tse02,tse17,tse15,tse16,tse03,tse12,tse13,tse14,",
              "       tse04,tse05,tse09,tse10,tse11,tse06,tse07,tse08,tse18,",
              "       tsf02,tsf03,tsf12,tsf13,tsf14,tsf04,tsf05,tsf09,",
              "       tsf10,tsf11,tsf06,tsf07,tsf08,tsf15 ",
              "  FROM tse_file,tsf_file ",
              " WHERE tse01=tsf01 AND ",g_wc,
              "   AND ",g_wc2 CLIPPED
 
    PREPARE t261_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t261_co                         # CURSOR
        CURSOR FOR t261_p1
 
      FOREACH t261_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
            SELECT gem02 INTO l_gem02                                                                                               
              FROM gem_file                                                                                                         
             WHERE gem01=sr.tse15                                                                                                   
            SELECT azf03 INTO l_azf03                                                                                               
              FROM azf_file                                                                                                         
             WHERE azf01=sr.tse17                                                                                                   
            SELECT imd02 INTO l_imd02a                                                                                              
              FROM imd_file                                                                                                         
             WHERE imd01=sr.tse12                                                                                                   
            SELECT ime03 INTO l_ime03a                                                                                              
              FROM ime_file                                                                                                         
             WHERE ime01=sr.tse12                                                                                                   
               AND ime02=sr.tse13                                                                                                   
               AND imeacti = 'Y'   #FUN-D40103
            SELECT ima02 INTO l_ima02a                                                                                              
              FROM ima_file                                                                                                         
             WHERE ima01=sr.tse03                                                                                                   
            SELECT ima02 INTO l_ima02                                                                                               
              FROM ima_file                                                                                                         
             WHERE ima01 = sr.tsf03                                                                                                 
            SELECT imd02 INTO l_imd02                                                                                               
              FROM imd_file                                        
             WHERE imd01=sr.tsf12                                                                                                   
            SELECT ime03 INTO l_ime03                                                                                               
              FROM ime_file                                                                                                         
             WHERE ime01=sr.tsf12                                                                                                   
               AND ime02=sr.tsf13                                                                                                   
               AND imeacti = 'Y'   #FUN-D40103
      EXECUTE insert_prep USING sr.tse01,sr.tse02,sr.tse15,l_gem02,sr.tse17,l_azf03,sr.tse12,l_imd02,                               
                                l_imd02a,l_ime03,l_ime03a,sr.tse13,sr.tse14,sr.tse03,sr.tse04,sr.tse05,                             
                                sr.tse18,sr.tsf02,sr.tsf03,l_ima02,l_ima02a,sr.tsf12,sr.tsf13,sr.tsf14,                             
                                sr.tsf04,sr.tsf05,sr.tsf15        
      END FOREACH
 
 
    CLOSE t261_co
    ERROR ""
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(g_wc,'tse01,tse02,tse17,tse15,tse16,tseconf,                                                                 
                       tsepost,tse03,tse12,tse13,tse14,tse04,tse05,                                                                 
                       tse09,tse11,tse06,tse08,tse18,tseuser,                                                                       
                       tsegrup,tsemodu,tsedate,tseacti')                                                                            
              RETURNING g_wc                                                                                                        
      END IF                                                                                                                        
      LET g_str=g_wc                                                                                                                
      LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                                            
      CALL cl_prt_cs3('atmt261','atmt261',l_sql,g_str)      
END FUNCTION
FUNCTION t261_du_default(p_cmd)
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
         l_fac2     LIKE tse_file.tse10,
         l_qty2     LIKE tse_file.tse11,
         l_unit1    LIKE img_file.img09,
         l_fac1     LIKE tse_file.tse10,
         l_qty1     LIKE tse_file.tse11,
         l_factor   LIKE oeb_file.oeb12,           #No.FUN-680120 DECIMAL(16,8)
         p_cmd      LIKE type_file.chr1            #No.FUN-680120 VARCHAR(1)
 
      LET l_item = g_tse.tse03 
      LET l_ware = g_tse.tse12 
      LET l_loc  = g_tse.tse13 
      LET l_lot  = g_tse.tse14 
    
      IF cl_null(g_tse.tse03) THEN
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
 
      IF p_cmd = 'a' OR (p_cmd='u' AND g_tse.tse03!=g_tse_t.tse03) THEN
         LET g_tse.tse09=l_unit2
         LET g_tse.tse10=l_fac2 
         LET g_tse.tse11=l_qty2 
         LET g_tse.tse06=l_unit1
         LET g_tse.tse07=l_fac1 
         LET g_tse.tse08=l_qty1 
      END IF
END FUNCTION
 
FUNCTION t261_du_default_b(p_cmd)
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
         l_fac2     LIKE tse_file.tse10,
         l_qty2     LIKE tse_file.tse11,
         l_unit1    LIKE img_file.img09,
         l_fac1     LIKE tse_file.tse10,
         l_qty1     LIKE tse_file.tse11,
         l_factor   LIKE bmt_file.bmt07,           #No.FUN-680120 DECIMAL(16,8)
         p_cmd      LIKE type_file.chr1            #No.FUN-680120 VARCHAR(1)
 
      LET l_item = g_tsf[l_ac].tsf03 
      LET l_ware = g_tsf[l_ac].tsf12
      LET l_loc  = g_tsf[l_ac].tsf13
      LET l_lot  = g_tsf[l_ac].tsf14
    
      IF cl_null(g_tsf[l_ac].tsf03) THEN
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
 
      IF p_cmd = 'a' OR (p_cmd='u' AND g_tsf[l_ac].tsf03!=g_tsf_t.tsf03) THEN
         LET g_tsf[l_ac].tsf09=l_unit2
         LET g_tsf[l_ac].tsf10=l_fac2 
         LET g_tsf[l_ac].tsf11=l_qty2 
         LET g_tsf[l_ac].tsf06=l_unit1
         LET g_tsf[l_ac].tsf07=l_fac1 
         LET g_tsf[l_ac].tsf08=l_qty1 
      END IF
END FUNCTION
 
FUNCTION t261_set_origin_field_b()                                                                                                    
  DEFINE    l_ima906 LIKE ima_file.ima906,                                                                                          
            l_ima907 LIKE ima_file.ima907,                                                                                          
            l_img09  LIKE img_file.img09,     #img單位                                                                              
            l_tot    LIKE img_file.img10,                                                                                           
            l_fac2   LIKE tsf_file.tsf07,                                                                                          
            l_qty2   LIKE tsf_file.tsf08,                                                                                         
            l_fac1   LIKE tsf_file.tsf10,                                                                                          
            l_qty1   LIKE tsf_file.tsf11,                                                                                          
            l_factor LIKE bmt_file.bmt07           #No.FUN-680120 DECIMAL(16,8)                                                                                          
                                                                                                                                    
    IF g_sma.sma115='N' THEN RETURN END IF                                                                                          
    LET l_fac2=g_tsf[l_ac].tsf10                                                                                                   
    LET l_qty2=g_tsf[l_ac].tsf11                                                                                                   
    LET l_fac1=g_tsf[l_ac].tsf07                                                                                                   
    LET l_qty1=g_tsf[l_ac].tsf08                                                                                                    
                                                                                                                                    
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF                                                                                     
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF                                                                                     
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF                                                                                     
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF    
 
    IF g_sma.sma115 = 'Y' THEN                                                                                                      
       CASE g_ima906                                                                                                                
          WHEN '1' LET g_tsf[l_ac].tsf04=g_tsf[l_ac].tsf06                                                                          
                   LET g_tsf041=l_fac1                                                                                 
                   LET g_tsf[l_ac].tsf05=l_qty1                                                                                     
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2                                                                            
                   LET g_tsf[l_ac].tsf04=g_img09                                                                                    
                   LET g_tsf041=1                                                                                      
                   LET g_tsf[l_ac].tsf05=l_tot                                                                                      
          WHEN '3' LET g_tsf[l_ac].tsf04=g_tsf[l_ac].tsf06                                                                    
                   LET g_tsf041=l_fac1                                                                                 
                   LET g_tsf[l_ac].tsf05=l_qty1                                                                                     
                   IF l_qty2 <> 0 THEN                                                                                              
                      LET g_tsf[l_ac].tsf10=l_qty1/l_qty2                                                                          
                   ELSE                                                                                                             
                      LET g_tsf[l_ac].tsf10=0                                                                                      
                   END IF                                                                                                           
       END CASE          
    END IF                                                                                                                          
                                                                                                                                    
END FUNCTION    
 
FUNCTION t261_set_origin_field()                                                                                                    
  DEFINE    l_ima906 LIKE ima_file.ima906,                                                                                          
            l_ima907 LIKE ima_file.ima907,                                                                                          
            l_img09  LIKE img_file.img09,     #img單位                                                                              
            l_tot    LIKE img_file.img10,                                                                                           
            l_fac2   LIKE tse_file.tse07,                                                                                          
            l_qty2   LIKE tse_file.tse08,                                                                                         
            l_fac1   LIKE tse_file.tse10,                                                                                          
            l_qty1   LIKE tse_file.tse11,                                                                                          
            l_factor LIKE bmt_file.bmt07           #No.FUN-680120 DECIMAL(16,8)                                                                                              
                                                                                                                                    
    IF g_sma.sma115='N' THEN RETURN END IF                                                                                          
    LET l_fac2=g_tse.tse10                                                                                                   
    LET l_qty2=g_tse.tse11                                                                                                   
    LET l_fac1=g_tse.tse07                                                                                                   
    LET l_qty1=g_tse.tse08                                                                                                    
                                                                                                                                    
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF                                                                                     
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF                                                                                     
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF                                                                                     
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF    
 
    IF g_sma.sma115 = 'Y' THEN                                                                                                      
       CASE g_ima906                                                                                                                
          WHEN '1' LET g_tse.tse04=g_tse.tse06                                                                          
                   LET g_tse.tse041=l_fac1                                                                                 
                   LET g_tse.tse05=l_qty1                                                                                     
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2                                                                            
                   LET g_tse.tse04=g_img09                                                                                    
                   LET g_tse.tse041=1                                                                                      
                   LET g_tse.tse05=l_tot                                                                                      
          WHEN '3' LET g_tse.tse04=g_tse.tse06                                                                    
                   LET g_tse.tse041=l_fac1                                                                                 
                   LET g_tse.tse05=l_qty1                                                                                     
                   IF l_qty2 <> 0 THEN                                                                                              
                      LET g_tse.tse10=l_qty1/l_qty2                                                                          
                   ELSE                                                                                                             
                      LET g_tse.tse10=0                                                                                      
                   END IF                                                                                                           
       END CASE          
    END IF                                                                                                                          
                                                                                                                                    
END FUNCTION    
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t261_du_data_to_correct()
 
   IF cl_null(g_tse.tse06) THEN
      LET g_tse.tse07 = NULL
      LET g_tse.tse08 = NULL
   END IF
 
   IF cl_null(g_tse.tse09) THEN
      LET g_tse.tse10 = NULL
      LET g_tse.tse11 = NULL
   END IF
   DISPLAY BY NAME g_tse.tse07
   DISPLAY BY NAME g_tse.tse08
   DISPLAY BY NAME g_tse.tse10
   DISPLAY BY NAME g_tse.tse11
 
END FUNCTION
 
FUNCTION t261_du_data_to_correct_b()
 
   IF cl_null(g_tsf[l_ac].tsf06) THEN
      LET g_tsf[l_ac].tsf07 = NULL
      LET g_tsf[l_ac].tsf08 = NULL
   END IF
 
   IF cl_null(g_tsf[l_ac].tsf09) THEN
      LET g_tsf[l_ac].tsf10 = NULL
      LET g_tsf[l_ac].tsf11 = NULL
   END IF
   DISPLAY BY NAME g_tsf[l_ac].tsf07
   DISPLAY BY NAME g_tsf[l_ac].tsf08
   DISPLAY BY NAME g_tsf[l_ac].tsf10
   DISPLAY BY NAME g_tsf[l_ac].tsf11
 
END FUNCTION
 
FUNCTION t261_ins_sfb(p_tse01)
   DEFINE p_tse01     LIKE tse_file.tse01
   DEFINE l_tse       RECORD LIKE tse_file.*
   DEFINE l_tsf       RECORD LIKE tsf_file.*
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
   DEFINE l_smy60     LIKE smy_file.smy60  #MOD-DC0095
   SELECT * INTO l_tse.* FROM tse_file WHERE tse01 = p_tse01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','tse_file',p_tse01,'',SQLCA.sqlcode,'','','1')
      RETURN FALSE,NULL
   END IF
 
   LET l_flag = TRUE
   LET l_slip = s_get_doc_no(p_tse01)
   IF cl_null(l_slip) THEN
      CALL cl_err(p_tse01,'anm-217',1)
      RETURN FALSE,NULL
   END IF
 
   SELECT smy69 INTO l_smy69 FROM smy_file WHERE smyslip = l_slip
   IF cl_null(l_smy69) THEN
      CALL cl_err(l_slip,'atm-412',1)  #組合/拆解單對應的工單單別為空!
      RETURN FALSE,NULL
   END IF
 
   INITIALIZE l_sfb.* TO NULL
 
   CALL s_auto_assign_no('asf',l_smy69,l_tse.tse02,'1','sfb_file','sfb01','','','')
        RETURNING li_result,l_sfb.sfb01
   IF (NOT li_result) THEN
      CALL cl_err(l_smy69,'asf-377',1)
      RETURN FALSE,NULL
   END IF
 
   LET l_sfb.sfb93 = 'N'
   LET l_sfb.sfb02 = '11'
   LET l_sfb.sfb04 = '3'  #carrier
   LET l_sfb.sfb05 = l_tse.tse03
   LET l_sfb.sfb06 = NULL
   LET l_sfb.sfb07 = NULL
   LET l_sfb.sfb071= l_tse.tse02
   SELECT ima55 INTO l_ima55 FROM ima_file
    WHERE ima01 = l_sfb.sfb05
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','ima_file',l_sfb.sfb05,'',SQLCA.sqlcode,'','','1')
      RETURN FALSE,NULL
   END IF
 
   CALL s_umfchk(l_sfb.sfb05,l_tse.tse04,l_ima55)
        RETURNING l_cnt,l_fac
   IF l_cnt = 1 THEN
      CALL cl_err(l_sfb.sfb05,'mfg3075','1')
      RETURN FALSE,NULL
   END IF
   IF cl_null(l_fac) OR l_fac = 0 THEN LET l_fac = 1 END IF
   LET l_sfb.sfb08 = l_tse.tse05 * l_fac #carrier
   LET l_sfb.sfb081 =0
   LET l_sfb.sfb09  =0
   LET l_sfb.sfb10  =0
   LET l_sfb.sfb11  =0
   LET l_sfb.sfb111 =0
   LET l_sfb.sfb12  =0
   LET l_sfb.sfb121 =0
   LET l_sfb.sfb122 =0
   LET l_sfb.sfb13  =l_tse.tse02
   LET l_sfb.sfb15  =l_tse.tse02
#  LET l_sfb.sfb23 ='N'    #check with kim ..different from pkg       #MOD-A80082
   LET l_sfb.sfb23 ='Y'                                               #MOD-A80082 
   LET l_sfb.sfb24 ='N'
   LET l_sfb.sfb29 ='Y'
   LET l_sfb.sfb39 ='1'
   LET l_sfb.sfb41 ='N'
   LET l_sfb.sfb81 =l_tse.tse02
   LET l_sfb.sfb87 ='N'
   LET l_sfb.sfb94 = 'N'
   LET l_sfb.sfb95 =' '   #carrier
   LET l_sfb.sfb98 =' '
   #MOD-DC0095 add begin-----------  
   LET l_slip = s_get_doc_no(l_sfb.sfb01)
   IF NOT cl_null(l_slip) THEN
      SELECT smy60 INTO l_smy60 FROM smy_file WHERE smyslip = l_slip
      IF NOT cl_null(l_smy60) THEN 
         LET l_sfb.sfb98 = l_smy60
      END IF 
   END IF 
   #MOD-DC0095 add end--------------
   LET l_sfb.sfb99 ='Y'   #carrier
   LET l_sfb.sfb100='1'
   LET l_sfb.sfbacti='Y'
   LET l_sfb.sfbuser=g_user  
   LET l_sfb.sfbgrup=g_grup   
   LET l_sfb.sfbdate=g_today
   LET l_sfb.sfbmksg = 'N'
   LET l_sfb.sfbplant = g_plant
   LET l_sfb.sfblegal = g_legal  #FUN-980009
   LET l_sfb.sfboriu = g_user      #No.FUN-980030 10/01/04 
   LET l_sfb.sfborig = g_grup      #No.FUN-980030 10/01/04
   LET l_sfb.sfb104 = ' '          #No.TQC-A50087 add
   LET l_sfb.sfb44 = l_tse.tse16   #MOD-B30164 add
   LET l_sfb.sfb82 = l_tse.tse15   #TQC-C20337 add 
   INSERT INTO sfb_file VALUES(l_sfb.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3('ins','sfb_file',l_sfb.sfb01,'',SQLCA.sqlcode,'','','1')
      RETURN FALSE,NULL
   END IF
 
   INITIALIZE l_sfa.* TO NULL
 
   LET l_sfa.sfa01  = l_sfb.sfb01             #工單編號
   LET l_sfa.sfa02  = l_sfb.sfb02             #工單型態
   LET l_sfa.sfa03  = l_tse.tse03             #料件編號
   SELECT ima25,ima86 INTO l_ima25,l_ima86
     FROM ima_file WHERE ima01 = l_sfa.sfa03
   IF SQLCA.sqlcode THEN
      CALL cl_err('sel ima:' || l_sfa.sfa03,SQLCA.sqlcode,1)
      RETURN FALSE,NULL
   END IF
   LET l_sfa.sfa04  = 0                       #原發數量
   LET l_sfa.sfa05  = l_tse.tse05             #應發數量  #carrier
   LET l_sfa.sfa06  =  0                      #已發數量
   LET l_sfa.sfa061 =  0                      #已領數量
   LET l_sfa.sfa062 =  0                      #超領數量
   LET l_sfa.sfa063 =  0                      #報廢數量
   LET l_sfa.sfa064 =  0                      #盤損數量
   LET l_sfa.sfa065 =  0                      #委外代買量
   LET l_sfa.sfa066 =  0                      #委外代買已交量
   LET l_sfa.sfa07  =  0                      #欠料數量
   LET l_sfa.sfa08  =  ' '                    #作業編號
   LET l_sfa.sfa09  =  0                      #前置時間調整
   LET l_sfa.sfa10  =  0                      #前置時間調整
   LET l_sfa.sfa11  =  'N'                    #旗標
   LET l_sfa.sfa12  = l_tse.tse04             #發料單位  #carrier
   CALL s_umfchk(l_sfa.sfa03,l_sfa.sfa12,l_ima25)
        RETURNING l_cnt,l_fac
   IF l_cnt = 1 THEN
      CALL cl_err(l_sfa.sfa03,'mfg3075','1')
      RETURN FALSE,NULL
   END IF
   LET l_sfa.sfa13  =  l_fac                  #發料單位/庫存單位換算率
   LET l_sfa.sfa14  =  l_tse.tse04            #成本單位  #carrier
 
   CALL s_umfchk(l_sfa.sfa03,l_sfa.sfa14,l_ima86)
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
   LET l_sfa.sfa27  =  l_tse.tse03            #被替代料號
   LET l_sfa.sfa28  =  1                      #替代率
   LET l_sfa.sfa29  =  l_sfb.sfb05            #上階料號
   LET l_sfa.sfa30  =  l_tse.tse12            #指定倉庫
   LET l_sfa.sfa31  =  l_tse.tse13            #指定儲位
   LET l_sfa.sfa100 =  0                      #發料誤差允許率
   LET l_sfa.sfaacti=  'Y'                    #資料有效碼
   LET l_sfa.sfa32  =  'N'                    #代買料否
   LET l_sfa.sfaplant = g_plant
   LET l_sfa.sfalegal = g_legal #FUN-980009
   LET l_sfa.sfa012 = ' '       #MOD-A60197 add
   LET l_sfa.sfa013 = 0         #MOD-A60197 add   
   INSERT INTO sfa_file VALUES(l_sfa.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3('ins','sfa_file',l_sfa.sfa01,l_sfa.sfa03,SQLCA.sqlcode,'','','1')
      RETURN FALSE,NULL
   END IF
 
   RETURN TRUE,l_sfb.sfb01
 
END FUNCTION
 
FUNCTION t261_ins_sfp(p_tse01,p_sfb01)
   DEFINE p_tse01     LIKE tse_file.tse01
   DEFINE p_sfb01     LIKE sfb_file.sfb01
   DEFINE l_tse       RECORD LIKE tse_file.*
   DEFINE l_sfb       RECORD LIKE sfb_file.*
   DEFINE l_sfa       RECORD LIKE sfa_file.*
   DEFINE l_sfp       RECORD LIKE sfp_file.*
   DEFINE l_sfq       RECORD LIKE sfq_file.*
   DEFINE l_sfs       RECORD LIKE sfs_file.*
   DEFINE l_sfsi      RECORD LIKE sfsi_file.*   #FUN-B70074
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
   DEFINE l_tsf       RECORD LIKE tsf_file.*
   DEFINE l_rvbs      RECORD LIKE rvbs_file.*   #No.CHI-A70051
 
   SELECT * INTO l_tse.* FROM tse_file WHERE tse01 = p_tse01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','tse_file',p_tse01,'',SQLCA.sqlcode,'','','1')
      RETURN FALSE,NULL
   END IF
 
   SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01 = p_sfb01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','sfb_file',p_sfb01,'',SQLCA.sqlcode,'','','1')
      RETURN FALSE,NULL
   END IF
 
   LET l_slip = s_get_doc_no(p_tse01)
   IF cl_null(l_slip) THEN
      CALL cl_err(p_tse01,'anm-217',1)  #單別不可空白,請重新輸入..!
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
   LET l_sfp.sfp02  =g_today
  #LET l_sfp.sfp03  =g_today     #MOD-C10054 Mark
   LET l_sfp.sfp03  =l_tse.tse02 #MOD-C10054 Add
   LET l_sfp.sfp04  ='N'
   LET l_sfp.sfp05  ='N'
   LET l_sfp.sfp06  ='1'
   LET l_sfp.sfp09  ='N'
   LET l_sfp.sfp13  ='N'
   LET l_sfp.sfpconf = 'N' #FUN-920054
   LET l_sfp.sfpuser=g_user        
   LET l_sfp.sfpgrup=g_grup         
   LET l_sfp.sfpdate=g_today
   LET l_sfp.sfpplant = g_plant
   LET l_sfp.sfplegal = g_legal #FUN-980009
   LET l_sfp.sfporiu = g_user      #No.FUN-980030 10/01/04
   LET l_sfp.sfporig = g_grup      #No.FUN-980030 10/01/04 
   #FUN-AB0001--add---str---
   LET l_sfp.sfpmksg = g_smy.smyapr #是否簽核
   LET l_sfp.sfp15 = '0'            #簽核狀況
#  LET l_sfp.sfp16 = g_user         #申請人  #TQC-C20337 mark
   LET l_sfp.sfp16 = l_tse.tse16    #TQC-C20337
   LET l_sfp.sfp07 = l_tse.tse15    #TQC-C20337
   #FUN-AB0001--add---end---

   IF cl_null(l_sfp.sfpmksg) THEN LET l_sfp.sfpmksg='N' END IF   #TQC-B60259
   INSERT INTO sfp_file VALUES(l_sfp.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3('ins','sfp_file',l_sfp.sfp01,'',SQLCA.sqlcode,'','','1')
      RETURN FALSE,NULL
   END IF
 
   INITIALIZE l_sfq.* TO NULL
   LET l_sfq.sfq01 = l_sfp.sfp01
   LET l_sfq.sfq02 = l_sfb.sfb01
   LET l_sfq.sfq03 = l_sfb.sfb08
   LET l_sfq.sfq04 = ' '
   LET l_sfq.sfq05 = g_today
   LET l_sfq.sfq06 = 0
   LET l_sfq.sfq07 = ' '
   LET l_sfq.sfq08 = l_sfq.sfq03
   LET l_sfq.sfqplant = g_plant
   LET l_sfq.sfqlegal = g_legal #FUN-980009
   LET l_sfq.sfq012 = ' '       #FUN-B20095 
   LET l_sfq.sfq014 = ' '       #FUN-C70014 add

   INSERT INTO sfq_file VALUES (l_sfq.*)

   IF SQLCA.sqlcode THEN
      CALL cl_err3('ins','sfq_file',l_sfq.sfq01,l_sfq.sfq02,SQLCA.sqlcode,'','','1')
      RETURN FALSE,NULL
   END IF
 
   DECLARE t261_ins_sfs_cur CURSOR FOR
    SELECT * FROM sfa_file
     WHERE sfa01 = l_sfb.sfb01
       AND sfa05 > sfa06
       AND (sfa11 <> 'E' OR sfa11 IS NULL)
    ORDER BY sfa27,sfa03
   FOREACH t261_ins_sfs_cur INTO l_sfa.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach t261_ins_sfs_cur',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      INITIALIZE l_sfs.* TO NULL
 
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
      LET l_qty = (l_sfa.sfa05 - l_sfa.sfa06)
      LET l_sfs.sfs05=l_qty           #發料數量
      LET l_sfs.sfs06=l_sfa.sfa12     #發料單位
      LET l_sfs.sfs07=l_sfa.sfa30
      LET l_sfs.sfs08=l_sfa.sfa31
      LET l_sfs.sfs09=' '
      SELECT * INTO l_tse.* FROM tse_file
       WHERE tse01 = p_tse01
      LET l_sfs.sfs09 = l_tse.tse14
      IF SQLCA.sqlcode THEN
         CALL cl_err3('sel','tse_file',l_tse.tse01,'',SQLCA.sqlcode,'','','1')
         RETURN FALSE,NULL
      END IF
      IF l_sfs.sfs07 IS NULL THEN LET l_sfs.sfs07 = ' ' END IF
      IF l_sfs.sfs08 IS NULL THEN LET l_sfs.sfs08 = ' ' END IF
      IF l_sfs.sfs09 IS NULL THEN LET l_sfs.sfs09 = ' ' END IF
 
      LET l_sfs.sfs10=l_sfa.sfa08
     #IF l_sfa.sfa26 MATCHES '[SUT]' THEN    #FUN-A20037
      IF l_sfa.sfa26 MATCHES '[SUTZ]' THEN   #FUN-A20037
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
         LET l_sfs.sfs30 = l_tse.tse06
         LET l_sfs.sfs31 = l_tse.tse07
         LET l_sfs.sfs32 = l_tse.tse08
 
         IF l_ima906 = '1' THEN  #不使用雙單位
            LET l_sfs.sfs33 = NULL
            LET l_sfs.sfs34 = NULL
            LET l_sfs.sfs35 = NULL
         ELSE
            LET l_sfs.sfs33 = l_tse.tse09
            LET l_sfs.sfs34 = l_tse.tse10
            LET l_sfs.sfs35 = l_tse.tse11
         END IF
      END IF
      LET l_sfs.sfs930 = ' '
      LET l_sfs.sfsplant  = g_plant
      LET l_sfs.sfslegal = g_legal #FUN-980009
      LET l_sfs.sfs012 = ' ' #FUN-A60027 add  #No.CHI-A70051
      LET l_sfs.sfs013 = 0 #FUN-A60027 add
      LET l_sfs.sfs014 = ' ' #FUN-C70014 add
      
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
    #FUN-B70074 -----------------Begin-------------------
      ELSE
         IF NOT s_industry('std') THEN
            INITIALIZE l_sfsi.* TO NULL
            LET l_sfsi.sfsi01 = l_sfs.sfs01
            LET l_sfsi.sfsi02 = l_sfs.sfs02
            IF NOT s_ins_sfsi(l_sfsi.*,l_sfs.sfsplant) THEN      
               RETURN FALSE,NULL
            END IF
         END IF  
    #FUN-B70074 -----------------End---------------------
      END IF
 
   END FOREACH

   #No.CHI-A70051  --Begin
   #拆解单单头批序号生成工单发料批序号资料
   DECLARE t261_rvbs_cs1 CURSOR FOR
    SELECT * FROM rvbs_file
     WHERE rvbs00 = 'atmt261' 
       AND rvbs01 = g_tse.tse01
       AND rvbs02 = 0
   FOREACH t261_rvbs_cs1 INTO l_rvbs.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach t261_rvbs_cs1',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_rvbs.rvbs00 = 'asfi511'   #成套发料 sfp06 = '1'
      LET l_rvbs.rvbs01 = l_sfp.sfp01
      LET l_rvbs.rvbs02 = 1
      INSERT INTO rvbs_file VALUES (l_rvbs.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3('ins','rvbs_file','asfi511',l_sfp.sfp01,SQLCA.sqlcode,'','','1')
         RETURN FALSE,NULL
      END IF 
   END FOREACH
   #No.CHI-A70051  --End  
 
   RETURN TRUE,l_sfp.sfp01
 
END FUNCTION
 
FUNCTION t261_ins_ksc(p_tse01,p_sfb01,p_sfp01)
   DEFINE p_tse01     LIKE tse_file.tse01
   DEFINE p_sfb01     LIKE sfb_file.sfb01
   DEFINE p_sfp01     LIKE sfp_file.sfp01
   DEFINE l_tse       RECORD LIKE tse_file.*
   DEFINE l_sfb       RECORD LIKE sfb_file.*
   DEFINE l_sfp       RECORD LIKE sfp_file.*
   DEFINE l_ksc       RECORD LIKE ksc_file.*
   DEFINE l_ksd       RECORD LIKE ksd_file.*
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_smy71     LIKE smy_file.smy71
   DEFINE l_slip      LIKE smy_file.smyslip
   DEFINE l_flag      LIKE type_file.num5
   DEFINE l_ima25     LIKE ima_file.ima25
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_fac       LIKE ima_file.ima44_fac
   DEFINE l_ima906    LIKE ima_file.ima906
   DEFINE l_tsf       RECORD LIKE tsf_file.*
   DEFINE l_ima55     LIKE ima_file.ima55
   DEFINE l_rvbs      RECORD LIKE rvbs_file.*   #No.CHI-A70051
 
   SELECT * INTO l_tse.* FROM tse_file WHERE tse01 = p_tse01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','tse_file',p_tse01,'',SQLCA.sqlcode,'','','1')
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
 
   LET l_slip = s_get_doc_no(p_tse01)
   IF cl_null(l_slip) THEN
      CALL cl_err(p_tse01,'anm-217',1)  #單別不可空白,請重新輸入..!
      RETURN FALSE,NULL
   END IF
 
   SELECT smy71 INTO l_smy71 FROM smy_file WHERE smyslip = l_slip
   IF cl_null(l_smy71) THEN
      CALL cl_err(l_slip,'atm-414',1)  #組合/拆解單對應的工單完工單別為空!
      RETURN FALSE,NULL
   END IF
 
   INITIALIZE l_ksc.* TO NULL
 
   CALL s_auto_assign_no('asf',l_smy71,g_today,'C','ksc_file','ksc01','','','')  ##carrier check type
        RETURNING li_result,l_ksc.ksc01
   IF (NOT li_result) THEN
      CALL cl_err(l_smy71,'asf-377',1)
      RETURN FALSE,NULL
   END IF
   LET l_ksc.ksc00   = '1'             #類別
  #LET l_ksc.ksc02   = g_today         #MOD-C10054 Mark
   LET l_ksc.ksc02   = l_tse.tse02     #MOD-C10054 ADD
   LET l_ksc.ksc03   = NULL            #No Use
#  LET l_ksc.ksc04   = g_grup          #部門    #TQC-C20337 mark
   LET l_ksc.ksc04   = l_tse.tse15     #TQC-C20337 add
   LET l_ksc.ksc05   = NULL            #理由
   LET l_ksc.ksc06   = l_sfb.sfb27     #專案編號
   LET l_ksc.ksc07   = NULL            #備註
   LET l_ksc.ksc08   = NULL            #PBI No.
   LET l_ksc.ksc09   = NULL            #耗材單號
   LET l_ksc.ksc10   = NULL            #No Use
   LET l_ksc.ksc11   = NULL            #No Use
   LET l_ksc.ksc12   = NULL            #No Use
   LET l_ksc.ksc13   = NULL            #No Use
   LET l_ksc.kscpost = 'N'             #過帳否
   LET l_ksc.kscuser = g_user          #資料所有者  
   LET l_ksc.kscgrup = g_grup          #資料所有部門 
   LET l_ksc.kscmodu = NULL            #資料修改者
   LET l_ksc.kscdate = g_today         #最近修改日
   LET l_ksc.kscconf = 'N'             #確認碼
   LET l_ksc.ksc14   = g_today         #輸入日期
   LET l_ksc.kscplant= g_plant
   LET l_ksc.ksclegal = g_legal #FUN-980009
   LET l_ksc.kscoriu = g_user      #No.FUN-980030 10/01/04  
   LET l_ksc.kscorig = g_grup      #No.FUN-980030 10/01/04 
   INSERT INTO ksc_file VALUES(l_ksc.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3('ins','ksc_file',l_ksc.ksc01,'',SQLCA.sqlcode,'','','1')
      RETURN FALSE,NULL
   END IF
 
   #carrier stop here
   DECLARE t261_ins_ksd_cur CURSOR FOR
    SELECT * FROM tsf_file WHERE tsf01 = p_tse01
   IF SQLCA.sqlcode THEN
      CALL cl_err('t261_ins_ksd_cur',SQLCA.sqlcode,1)
      RETURN FALSE,NULL
   END IF
   FOREACH t261_ins_ksd_cur INTO l_tsf.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach t261_ins_ksd_cur',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      INITIALIZE l_ksd.* TO NULL
      LET l_ksd.ksd01    = l_ksc.ksc01            #入庫編號
      SELECT MAX(ksd03)+1 INTO l_ksd.ksd03
        FROM ksd_file
       WHERE ksd01 = l_ksd.ksd01
      IF cl_null(l_ksd.ksd03) OR l_ksd.ksd03 = 0 THEN
         LET l_ksd.ksd03 = 1
      END IF
      LET l_ksd.ksd04 = l_tsf.tsf03            #料號
 
      LET l_ksd.ksd05 = l_tsf.tsf12
      LET l_ksd.ksd06 = l_tsf.tsf13
      LET l_ksd.ksd07 = l_tsf.tsf14
 
      IF cl_null(l_ksd.ksd05) THEN LET l_ksd.ksd05 = ' ' END IF
      IF cl_null(l_ksd.ksd06) THEN LET l_ksd.ksd06 = ' ' END IF
      IF cl_null(l_ksd.ksd07) THEN LET l_ksd.ksd07 = ' ' END IF
 
      SELECT img09,img10
        FROM img_file
       WHERE img01=l_ksd.ksd04 AND img02=l_ksd.ksd05
         AND img03=l_ksd.ksd06 AND img04=l_ksd.ksd07
      IF SQLCA.sqlcode = 100 THEN
         CALL s_add_img(l_ksd.ksd04,l_ksd.ksd05,
                        l_ksd.ksd06,l_ksd.ksd07,
                        l_ksc.ksc01,l_ksd.ksd03,
                        g_today)
      END IF
 
      LET l_ksd.ksd08 = l_tsf.tsf04            #庫存單位
      LET l_ksd.ksd09 = l_tsf.tsf05            #入庫量
      LET l_ksd.ksd11 = l_sfb.sfb01            #工單單號
      LET l_ksd.ksd12 = NULL                   #備註
      LET l_ksd.ksd13 = NULL                   #No Use
      LET l_ksd.ksd14 = NULL                   #No Use
      LET l_ksd.ksd15 = NULL                   #No Use
      LET l_ksd.ksd16 = 'N'                    #當月是否入聯產品否
      LET l_ksd.ksd17 = NULL                   #FQC單號
      LET l_ksd.ksd18 = NULL                   #No Use
      LET l_ksd.ksd19 = NULL                   #No Use
      LET l_ksd.ksd20 = NULL                   #Run Card
      LET l_ksd.ksd30 = NULL
      LET l_ksd.ksd31 = NULL
      LET l_ksd.ksd32 = NULL
      LET l_ksd.ksd33 = NULL
      LET l_ksd.ksd34 = NULL
      LET l_ksd.ksd35 = NULL
      IF g_sma.sma115 = 'Y' THEN
         LET l_ksd.ksd30 = l_tsf.tsf06            #單位一
         LET l_ksd.ksd31 = l_tsf.tsf07            #單位一換算率(與生產單位)
         LET l_ksd.ksd32 = l_tsf.tsf08            #單位一數量
         IF l_ima906 = '1' THEN
            LET l_ksd.ksd33 = NULL
            LET l_ksd.ksd34 = NULL
            LET l_ksd.ksd35 = NULL
         ELSE
            LET l_ksd.ksd33 = l_tsf.tsf09         #單位二
            LET l_ksd.ksd34 = l_tsf.tsf10         #單位二換算率(與生產單位)
            LET l_ksd.ksd35 = l_tsf.tsf11         #單位二數量
         END IF
         CASE l_ima906
              WHEN "2"
                 IF NOT cl_null(l_ksd.ksd33) THEN
                    CALL s_chk_imgg(l_ksd.ksd04,l_ksd.ksd05,
                                    l_ksd.ksd06,l_ksd.ksd07,
                                    l_ksd.ksd33) RETURNING l_flag
                    IF g_flag = 1 THEN
                       CALL s_add_imgg(l_ksd.ksd04,l_ksd.ksd05,
                                       l_ksd.ksd04,l_ksd.ksd05,
                                       l_ksd.ksd33,l_ksd.ksd34,
                                       l_ksd.ksd01,l_ksd.ksd03,0) RETURNING l_flag
                       IF l_flag = 1 THEN
                          RETURN FALSE,NULL
                       END IF
                    END IF
                 END IF
                 IF NOT cl_null(l_ksd.ksd30) THEN
                    CALL s_chk_imgg(l_ksd.ksd04,l_ksd.ksd05,
                                    l_ksd.ksd06,l_ksd.ksd07,
                                    l_ksd.ksd30) RETURNING l_flag
                    IF g_flag = 1 THEN
                       CALL s_add_imgg(l_ksd.ksd04,l_ksd.ksd05,
                                       l_ksd.ksd04,l_ksd.ksd05,
                                       l_ksd.ksd30,l_ksd.ksd31,
                                       l_ksd.ksd01,l_ksd.ksd03,0) RETURNING l_flag
                       IF l_flag = 1 THEN
                          RETURN FALSE,NULL
                       END IF
                    END IF
                 END IF
              WHEN "3"
                 IF NOT cl_null(l_ksd.ksd33) THEN
                    CALL s_chk_imgg(l_ksd.ksd04,l_ksd.ksd05,
                                    l_ksd.ksd06,l_ksd.ksd07,
                                    l_ksd.ksd33) RETURNING l_flag
                    IF g_flag = 1 THEN
                       CALL s_add_imgg(l_ksd.ksd04,l_ksd.ksd05,
                                       l_ksd.ksd04,l_ksd.ksd05,
                                       l_ksd.ksd33,l_ksd.ksd34,
                                       l_ksd.ksd01,l_ksd.ksd03,0) RETURNING l_flag
                       IF l_flag = 1 THEN
                          RETURN FALSE,NULL
                       END IF
                    END IF
                 END IF
         END CASE
      END IF
      LET l_ksd.ksd930 = l_sfb.sfb98           #成本中心
      LET l_ksd.ksdplant = g_plant
      LET l_ksd.ksdlegal = g_legal #FUN-980009
      #TQC-D20050--add--str-- 
      IF g_aza.aza115 = 'Y' THEN
         CALL s_reason_code(l_ksd.ksd01,l_ksd.ksd11,'',l_ksd.ksd04,l_ksd.ksd05,'',l_ksc.ksc04) RETURNING l_ksd.ksd36 
         IF cl_null(l_ksd.ksd36) THEN
            CALL cl_err('','aim-425',1)
            RETURN FALSE,NULL
         END IF
      END IF
      #TQC-D20050--add--end-- 
      INSERT INTO ksd_file VALUES(l_ksd.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3('ins','ksd_file',l_ksd.ksd01,l_ksd.ksd03,SQLCA.sqlcode,'','','1')
         RETURN FALSE,NULL
      END IF

      #No.CHI-A70051  --Begin
      #拆解单单身批序号生成工单入库批序号资料
      DECLARE t261_rvbs_cs2 CURSOR FOR
       SELECT * FROM rvbs_file
        WHERE rvbs00 = 'atmt261' 
          AND rvbs01 = g_tse.tse01
          AND rvbs02 = l_tsf.tsf02
      FOREACH t261_rvbs_cs2 INTO l_rvbs.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach t261_rvbs_cs1',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET l_rvbs.rvbs00 = 'asft622'   #拆件式工单入库
         LET l_rvbs.rvbs01 = l_ksc.ksc01
         INSERT INTO rvbs_file VALUES (l_rvbs.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3('ins','rvbs_file','asft622',l_ksc.ksc01,SQLCA.sqlcode,'','','1')
            RETURN FALSE,NULL
         END IF 
      END FOREACH
      #No.CHI-A70051  --End  
   END FOREACH
   RETURN TRUE,l_ksc.ksc01
 
END FUNCTION
#CHI-A70027 add --start--
FUNCTION t261_modi_lot_header()
   IF g_tse.tseconf='Y' THEN
      CALL cl_err(g_tse.tseconf,'9023',0)
      RETURN
   END IF
   LET g_ima918 = ''
   LET g_ima921 = ''
   SELECT ima918,ima921 INTO g_ima918,g_ima921 
     FROM ima_file
    WHERE ima01 = g_tse.tse03
      AND imaacti = "Y"
           
   IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
      CALL t261_ima25(g_tse.tse03,g_tse.tse12,g_tse.tse13,g_tse.tse14,g_tse.tse04)                   
     #CALL s_lotout(g_prog,g_tse.tse01,0,0,   #TQC-B90236 mark
      CALL s_mod_lot(g_prog,g_tse.tse01,0,0,   #TQC-B90236 add
                    g_tse.tse03,g_tse.tse12,
                    g_tse.tse13,g_tse.tse14,
                    g_tse.tse04,g_ima25,g_ima25_fac,
                    g_tse.tse05,'','MOD',-1)   #TQC-B90236 add '-1'
           RETURNING l_r,g_qty
      IF l_r = "Y" THEN
         LET g_tse.tse05 = g_qty
         DISPLAY BY NAME g_tse.tse05
      END IF
   END IF
END FUNCTION

FUNCTION t261_qry_lot_header()

   LET g_ima918 = ''
   LET g_ima921 = ''
   SELECT ima918,ima921 INTO g_ima918,g_ima921 
     FROM ima_file
    WHERE ima01 = g_tse.tse03
      AND imaacti = "Y"

   IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
      CALL t261_ima25(g_tse.tse03,g_tse.tse12,g_tse.tse13,g_tse.tse14,g_tse.tse04)                   
     #CALL s_lotout(g_prog,g_tse.tse01,0,0,   #TQC-B90236 mark
      CALL s_mod_lot(g_prog,g_tse.tse01,0,0,   #TQC-B90236 add
                    g_tse.tse03,g_tse.tse12,
                    g_tse.tse13,g_tse.tse14,
                    g_tse.tse04,g_ima25,g_ima25_fac,
                    g_tse.tse05,'','QRY',-1)   #TQC-B90236 add '-1'
           RETURNING l_r,g_qty
      IF l_r = "Y" THEN
         LET g_tse.tse05 = g_qty
         DISPLAY BY NAME g_tse.tse05
      END IF
   END IF
END FUNCTION

FUNCTION t261_ima25(p_img01,p_img02,p_img03,p_img04,p_unit)
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
#No.FUN-9C0073 ---------------------By chenls   10/01/11

#No.CHI-A80043  --Begin
FUNCTION t261_sfb_close(p_sfb01)
   DEFINE p_sfb01     LIKE sfb_file.sfb01
   DEFINE l_sfb28     LIKE sfb_file.sfb28
   DEFINE l_sfb36     LIKE sfb_file.sfb36
   DEFINE l_sfb37     LIKE sfb_file.sfb37
   DEFINE l_sfb38     LIKE sfb_file.sfb38

   IF g_sma.sma72 = 'Y' THEN
   #  LET l_sfb28 = '2'   #CHI-B60061
      LET l_sfb28 = '1'   #CHI-B60061
      LET l_sfb36 = g_today
      LET l_sfb37 = g_today
      LET l_sfb38 = NULL   #CHI-B40040
   ELSE
      LET l_sfb28 = '3'
      LET l_sfb36 = g_today
      LET l_sfb37 = g_today
      LET l_sfb38 = g_today
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


FUNCTION t261_sfb_undo_close(p_sfb01)
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

#No.FUN-BB0086--add--begin--
FUNCTION t261_tse05_check(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   IF NOT cl_null(g_tse.tse05) AND NOT cl_null(g_tse.tse04) THEN
      IF cl_null(g_tse_t.tse05) OR cl_null(g_tse04_t) OR g_tse_t.tse05 != g_tse.tse05 OR g_tse04_t != g_tse.tse04 THEN
         LET g_tse.tse05=s_digqty(g_tse.tse05,g_tse.tse04)
         DISPLAY BY NAME g_tse.tse05
      END IF
   END IF
   
   IF NOT cl_null(g_tse.tse05) THEN
      IF g_tse.tse05 <= 0 THEN       
         CALL cl_err('','mfg9243',0)
         RETURN FALSE 
      END IF
   END IF

    SELECT img10 INTO g_imgg10 FROM img_file
       WHERE img01=g_tse.tse03           
         AND img02=g_tse.tse12                          
         AND img03=g_tse.tse13                  
         AND img04=g_tse.tse14               
    IF g_tse.tse05*g_tse.tse041 > g_imgg10 THEN
      #FUN-C80107 modify begin------------------------------121024
      #CALL cl_err(g_tse.tse05,'mfg1303',1)
      #RETURN FALSE 
      #FUN-D30024--modify--str--
      #INITIALIZE g_sma894 TO NULL
      #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_tse.tse12) RETURNING g_sma894
      #IF g_sma894 = 'N' THEN
       INITIALIZE g_imd23 TO NULL
       CALL s_inv_shrt_by_warehouse(g_tse.tse12,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant
       IF g_imd23 = 'N' THEN
      #FUN-D30024--modify--end--
          CALL cl_err(g_tse.tse05,'mfg1303',1)
          RETURN FALSE
       ELSE
          IF NOT cl_confirm('mfg3469') THEN
             RETURN FALSE
          END IF
       END IF
      #FUN-C80107 modify end-------------------------------
    END IF

    IF p_cmd = 'u' THEN 
       CALL t261_modi_lot_header() 
    END IF
   RETURN TRUE
END FUNCTION

FUNCTION t261_tse08_check()
   IF NOT cl_null(g_tse.tse08) AND NOT cl_null(g_tse.tse06) THEN
      IF cl_null(g_tse_t.tse08) OR cl_null(g_tse06_t) OR g_tse_t.tse08 != g_tse.tse08 OR g_tse06_t != g_tse.tse06 THEN
         LET g_tse.tse08=s_digqty(g_tse.tse08,g_tse.tse06)
         DISPLAY BY NAME g_tse.tse08
      END IF
   END IF
   
   IF NOT cl_null(g_tse.tse08) THEN
      IF g_tse.tse08 <= 0 THEN          #MOD-9C0344
         CALL cl_err('','mfg9243',0)
         RETURN FALSE 
      END IF
      IF NOT cl_null(g_tse.tse06) THEN    #0215
         #INITIALIZE g_sma894 TO NULL     #FUN-C80107 #FUN-D30024 mark
         INITIALIZE g_imd23 TO NULL       #FUN-D30024 add 
         IF g_ima906 = '2' THEN   # MATCHES '[23]' THEN        #(使用母子單位)
            IF g_tse.tse08 > g_imgg10_1 THEN
              #IF g_sma.sma894[1,1] = 'N' OR g_sma.sma894[1,1] IS NULL THEN   #FUN-C80107 mark
              #FUN-D30024--modify--str--
              #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_tse.tse12) RETURNING g_sma894   #FUN-C80107
              #IF g_sma894 = 'N' THEN    #FUN-C80107
               CALL s_inv_shrt_by_warehouse(g_tse.tse12,g_plant) RETURNING g_imd23 #TQC-D40078 g_plant
               IF g_imd23 = 'N' THEN
              #FUN-D30024--modify--end--
                  CALL cl_err(g_tse.tse08,'mfg1303',1)
                  RETURN FALSE 
               ELSE
                  IF NOT cl_confirm('mfg3469') THEN
                     RETURN FALSE 
                  END IF
               END IF
             END IF
         ELSE
            IF g_tse.tse08*g_tse.tse07 > g_imgg10_1 THEN
              #IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN    #FUN-C80107 mark
              #FUN-D30024--modify--str--
              #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_tse.tse12) RETURNING g_sma894   #FUN-C80107
              #IF g_sma894 = 'N' THEN    #FUN-C80107
               CALL s_inv_shrt_by_warehouse(g_tse.tse12,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant
               IF g_imd23 = 'N' THEN
              #FUN-D30024--modify--end--
                  CALL cl_err(g_tse.tse08,'mfg1303',1)
                  RETURN FALSE 
               ELSE
                  IF NOT cl_confirm('mfg3469') THEN
                     RETURN FALSE 
                  END IF
               END IF
            END IF
         END IF
      END IF
      CALL t261_du_data_to_correct()
      CALL t261_set_origin_field()
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t261_tse11_check()
   IF NOT cl_null(g_tse.tse11) AND NOT cl_null(g_tse.tse09) THEN
      IF cl_null(g_tse_t.tse11) OR cl_null(g_tse09_t) OR g_tse_t.tse11 != g_tse.tse11 OR g_tse09_t != g_tse.tse09 THEN
         LET g_tse.tse11=s_digqty(g_tse.tse11,g_tse.tse09)
         DISPLAY BY NAME g_tse.tse11
      END IF
   END IF
   
   IF NOT cl_null(g_tse.tse11) THEN
      IF g_tse.tse11 <= 0 THEN         #MOD-9C0344
         CALL cl_err('','mfg9243',0)
         RETURN FALSE 
      END IF
      IF g_ima906='3' THEN                                                                                              
         IF cl_null(g_tse.tse08) OR g_tse.tse08=0 THEN  #No.CHI-960022
            LET g_tot=g_tse.tse11*g_tse.tse10                                                                              
            LET g_tse.tse08=g_tot                                                                              
            DISPLAY BY NAME g_tse.tse08                                                                                    
         END IF                                         #No.CHI-960022
      END IF                                                                                                            
      IF g_ima906 MATCHES '[23]' THEN
         SELECT imgg10 INTO g_imgg10_2
           FROM imgg_file
          WHERE imgg01=g_tse.tse03          
            AND imgg02=g_tse.tse12                     
            AND imgg03=g_tse.tse13
            AND imgg04=g_tse.tse14
            AND imgg09=g_tse.tse09                             
      END IF  
      IF g_tse.tse11 > g_imgg10_2 THEN                                                                      
        #FUN-D30024--modify--str--
        #INITIALIZE g_sma894 TO NULL                                                      #FUN-C80107
        #CALL s_inv_shrt_by_warehouse(g_sma.sma894[1,1],g_tse.tse12) RETURNING g_sma894   #FUN-C80107
        ##IF g_sma.sma894[1,1]='N' OR g_sma.sma894[1,1] IS NULL THEN                       #FUN-C80107 mark
        #IF g_sma894 = 'N' THEN                                                           #FUN-C80107
         INITIALIZE g_imd23 TO NULL
         CALL s_inv_shrt_by_warehouse(g_tse.tse12,g_plant) RETURNING g_imd23   #TQC-D40078 g_plant
         IF g_imd23 = 'N' THEN
        #FUN-D30024--modify--end--
            CALL cl_err(g_tse.tse11,'mfg1303',1)                                                            
            RETURN FALSE                                                                                 
         ELSE                                                                                                      
            IF NOT cl_confirm('mfg3469') THEN                                                                      
               RETURN FALSE                                                                             
            END IF                                                                                                 
         END IF                                                                                                    
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t261_tsf05_check()
   IF NOT cl_null(g_tsf[l_ac].tsf05) AND NOT cl_null(g_tsf[l_ac].tsf04) THEN
      IF cl_null(g_tsf_t.tsf05) OR cl_null(g_tsf04_t) OR g_tsf_t.tsf05 != g_tsf[l_ac].tsf05 OR g_tsf04_t != g_tsf[l_ac].tsf04 THEN
         LET g_tsf[l_ac].tsf05=s_digqty(g_tsf[l_ac].tsf05,g_tsf[l_ac].tsf04)
         DISPLAY BY NAME g_tsf[l_ac].tsf05
      END IF
   END IF

   IF NOT cl_null(g_tsf[l_ac].tsf05) THEN
      IF g_tsf[l_ac].tsf05 <= 0 THEN       
         CALL cl_err('','mfg9243',0)
         RETURN FALSE 
      END IF
    END IF
    LET g_ima918 = ''
    LET g_ima921 = ''
    SELECT ima918,ima921 INTO g_ima918,g_ima921 
      FROM ima_file
     WHERE ima01 = g_tsf[l_ac].tsf03
       AND imaacti = "Y"
  
    IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
       CALL t261_ima25(g_tsf[l_ac].tsf03,g_tsf[l_ac].tsf12,g_tsf[l_ac].tsf13,g_tsf[l_ac].tsf14,g_tsf[l_ac].tsf04)                   
#TQC-B90236--mark--begin
#      CALL s_lotin(g_prog,g_tse.tse01,g_tsf[l_ac].tsf02,0,
#                   g_tsf[l_ac].tsf03,g_tsf[l_ac].tsf04,g_ima25,
#                   g_ima25_fac,g_tsf[l_ac].tsf05,'','MOD')
#TQC-B90236--mark--end
#TQC-B90236--add--begin
       CALL s_mod_lot(g_prog,g_tse.tse01,g_tsf[l_ac].tsf02,0,
                      g_tsf[l_ac].tsf03,g_tsf[l_ac].tsf12,
                      g_tsf[l_ac].tsf13,g_tsf[l_ac].tsf14,
                      g_tsf[l_ac].tsf04,g_ima25,g_ima25_fac,g_tsf[l_ac].tsf05,'','MOD',1)
#TQC-B90236--add--end
            RETURNING l_r,g_qty
       IF l_r = "Y" THEN
          LET g_tsf[l_ac].tsf05 = g_qty
          DISPLAY BY NAME g_tsf[l_ac].tsf05
       END IF
    END IF
   RETURN TRUE
END FUNCTION

FUNCTION t261_tsf08_check()
   IF NOT cl_null(g_tsf[l_ac].tsf08) AND NOT cl_null(g_tsf[l_ac].tsf06) THEN
      IF cl_null(g_tsf_t.tsf08) OR cl_null(g_tsf06_t) OR g_tsf_t.tsf08 != g_tsf[l_ac].tsf08 OR g_tsf06_t != g_tsf[l_ac].tsf06 THEN
         LET g_tsf[l_ac].tsf08=s_digqty(g_tsf[l_ac].tsf08,g_tsf[l_ac].tsf06)
         DISPLAY BY NAME g_tsf[l_ac].tsf08
      END IF
   END IF
   
   IF NOT cl_null(g_tsf[l_ac].tsf08) THEN
      IF g_tsf[l_ac].tsf08 <= 0 THEN           
         CALL cl_err('','mfg9243',0)
         RETURN FALSE 
      END IF
      CALL t261_du_data_to_correct_b()
      CALL t261_set_origin_field_b()
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t261_tsf11_check()
   IF NOT cl_null(g_tsf[l_ac].tsf11) AND NOT cl_null(g_tsf[l_ac].tsf09) THEN
      IF cl_null(g_tsf_t.tsf11) OR cl_null(g_tsf09_t) OR g_tsf_t.tsf11 != g_tsf[l_ac].tsf11 OR g_tsf09_t != g_tsf[l_ac].tsf09 THEN
         LET g_tsf[l_ac].tsf11=s_digqty(g_tsf[l_ac].tsf11,g_tsf[l_ac].tsf09)
         DISPLAY BY NAME g_tsf[l_ac].tsf11
      END IF
   END IF
   
   IF NOT cl_null(g_tsf[l_ac].tsf11) THEN
      IF g_tsf[l_ac].tsf11 <= 0 THEN        #MOD-9C0344
         CALL cl_err('','mfg9243',0)
         RETURN FALSE 
      END IF
      IF g_ima906='3' THEN                                                                                              
         LET g_tot=g_tsf[l_ac].tsf11*g_tsf[l_ac].tsf10                                                                  
         IF cl_null(g_tsf[l_ac].tsf08) OR g_tsf[l_ac].tsf08=0 THEN 
            LET g_tsf[l_ac].tsf08=g_tot                                                                  
            DISPLAY BY NAME g_tsf[l_ac].tsf08                                                                              
         END IF                                                    
      END IF                                                                                                            
   END IF
   RETURN TRUE
END FUNCTION
#No.FUN-BB0086--add--end--
