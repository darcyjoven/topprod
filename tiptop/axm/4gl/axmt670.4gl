# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmt670.4gl
# Descriptions...: 開票維護作業
# Date & Author..: 12/05/20  By yinhy FUN-C50025
# Modify ........: No.FUN-C60033 12/06/25 By minpp 新增omf00欄位，修改程序有有關key處理
# Modify ........: No.FUN-C60036 12/06/28 By xuxz 新增多倉庫多單位功能
# Modify ........: No.FUN-C60036 12/07/04 By minpp 1.出货税前金额隐藏 2.原币/本币 税前单价 改为原币/本币 单价  3.oaz93=Y时,把omf23/omf20/omf201/omf202和按钮 查询多仓位批 隐藏
# Modify ........: No.FUN-C60036 12/07/06 By minpp 增加一个action "发票维护"
# Modify ........: No.FUN-C60036 12/07/18 By minpp 單別從axmi010中取值，新增時默認單別為oaz97，可以修改
# Modify ........: No.TQC-C80008 12/08/01 By xuxz 批/序號查詢按鈕只有顯示沒有作用,移除
# Modify ........: No.FUN-C50097 12/08/03 By SunLM ogg13,ogc13非空判斷賦值
# Modify ........: NO.TQC-C80042 12/08/06 By lutingting 扣帳增加給值tlf14/tlff14為出貨單/銷退單原因碼
# Modify ........: NO.FUN-C80107 12/09/17 By suncx 新增依倉庫設置負庫存管控
# Modify ........: NO.MOD-CA0092 12/10/15 By xuxz 銷退時候如果是5.折讓，金額欄位應該直接給單價
# Modify.........: No:MOD-CA0062 12/10/15 By xuxz s_upimg添加批號參數，過濾MISC，axr-163報錯細化
# Modify.........: No:FUN-CA0084 12/10/19 By xuxz 發出商品完善
# Modify.........: No.MOD-CA0160 12/10/23 By lutingting 外幣匯率仍然為1
# Modify ........: NO.TQC-CA0062 12/10/31 By xuxz sma53報錯多次改為一次
# Modify ........: NO.MOD-CB0041 12/11/06 By SunLM 多筆資料查詢無效,只能顯示第一筆資料
# Modify ........: NO.MOD-CB0040 12/11/06 By SunLM 本幣開票含稅金額不能大於發票限額
# Modify ........: NO.MOD-CB0069 12/11/08 By SunLM 調整出貨單/銷退單號檢查,需要過帳的單據才行
# Modify ........: NO.MOD-CB0073 12/11/08 By SunLM 開票月份必須大于等于出貨單過賬日期，否則報錯
# Modify.........: No:MOD-CB0050 12/11/12 By SunLM 走開票流程時，對于原因碼為贈品（aooi313列入銷售費用為Y）的項次，
# Modify.........:                                 出貨過賬不應產生至發票倉，axmt670也不能針對此項次開票。
# Modify.........: No:MOD-CB0083 12/11/13 By SunLM "2"類型的出貨單以及"2/3"類型的銷退單不能開立發票
# Modify.........: No:MOD-CC0049 12/12/10 By suncx 新增欄位管控，1、錄入時，開票日期不能小於ccz01,ccz02
#                                                             2、單身出貨單/銷退單開窗挑選出貨日期必須小于等于開票日期的期別
#                                                             3、axmt670審核、過賬檢查單據日期大于等于ccz01,ccz02
# Modify.........: No:MOD-CC0206 12/12/21 By suncx TQC-C80042改错导致问题
# Modify.........: No:MOD-CC0230 12/12/25 By SunLM 在進行任何異動前,對g_omf_1.*進行重新取值
# Modify.........: No:MOD-CC0257 12/12/28 By SunLM 調整審核段/取消審核段的邏輯,防止"9其他類型"單身不能審核/取消審核
# Modify.........: No:MOD-CC0257 12/12/28 By SunLM 调整单位赋值问题,参考单位金额取值问题
# Modify.........: No:TQC-D10020 13/01/06 By yangtt 1、點擊【應收維護】，畫面檔關閉
#                                                   2、點擊【確認】，沒有直接報錯“-400  請先選取欲處理的資料！”
#                                                   3、點擊【扣帳還原】，沒有直接報錯“-400  請先選取欲處理的資料！”
# Modify.........: No:MOD-D10128 13/01/15 By SunLM  g_omf_1.*数组对齐
# Modify.........: No:MOD-CC0087 13/01/17 By Carrier 单身有出货时,确保总单身金额不可小于零,其他状况均可小于零
# Modify.........: No:MOD-CB0192 13/01/22 By Carrier 发出商品功能在做库存扣帐时,批次传入错误
# Modify.........: No:FUN-D10103 13/01/24 By zhangweib 單頭新增備註(omf30),gisp101拋轉時拋轉至isa10
# Modify.........: No:TQC-D10102 13/01/30 By xuxzz 修改ogc12，ogg12的控管
# Modify.........: No:MOD-D10266 13/01/30 By SunLM 调整确认逻辑,在确认过程中,第二个操作者不能删除或者更改同一笔资料
# Modify.........: No:MOD-D10265 13/01/30 By SunLM 是否,無invoice者應產生應收帳款
# Modify.........: No:FUN-D20003 13/02/02 By xuxz  賬款編號移動到單頭，添加補登發票按鈕
# Modify.........: No:MOD-D20042 13/02/07 By suncx 扣賬還原時未判斷關帳日期
# Modify ........: NO.FUN-CB0040 13/02/21 By minpp 增加报表打印共功能
# Modify.........: No:MOD-D20079 13/02/27 By SunLM 審核時候,檢查多倉儲出貨數量是否與單身出貨數量一致
# Modify.........: No:TQC-D20046 13/02/28 By qiull chenjing xuxz修改發出商品測試問題
# Modify.........: No:TQC-D20009 13/03/04 By fengrui chenjing xujing  修改發出商品測試問題
# Modify.........: No:FUN-D10091 13/03/05 By minpp 增加資料清單
# Modify.........: No:FUN-D10082 13/03/07 By lujh 單身新增訂單單號和訂單項次欄位
# Modify.........: No:FUN-D30024 13/03/12 By fengrui 負庫存依據imd23判斷
# Modify.........: No:MOD-D40035 13/04/08 By SunLM 更改單頭日期,匯率應該自動更新,以及單身本幣金額自動更新
# Modify.........: No:MOD-D40039 13/04/10 By Vampire 調整增加 gec011 = '2'
# Modify.........: No:FUN-D30034 13/04/16 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D50076 13/05/10 By suncx 進單身修改時未鎖住單頭資料，導致一個用戶在修改單身，另一個用戶卻能做審核等動作
# Modify.........: No:MOD-D40221 13/05/20 By SunLM 是否,單價為零，是否立賬
# Modify.........: No:FUN-D50006 13/06/04 By lixiang omf17增加開窗挑選
# Modify.........: No:FUN-D50009 13/06/04 By lixiang 增加狀態頁簽
# Modify.........: No:FUN-D50007 13/06/05 By lixiang 增加開票人，開票部門
# Modify.........: No:FUN-D50008 13/06/05 By lixiang 原開票日期改欄位名改為錄入日期，增加發票日期，發票日期与相關關賬日期都不關聯，拋轉應收時拋到oma09字段 
# Modify.........: No:MOD-D60035 13/06/05 By SunLM 出貨/銷退單單據日期年月大於發票日期年月，不可開票！
# Modify.........: No:MOD-D60158 13/06/19 By SunLM 本币单价小数位数取值有误
# Modify.........: No:MOD-D60160 13/06/19 By SunLM  omf31日期不做管控,扣账日期年月与开票录入日期年月不一致检查
# Modify.........: No:MOD-D60161 13/06/19 By SunLM   金额显示与axrt300有尾差
# Modify.........: No:MOD-D60152 13/06/19 By SunLM 調整刪除后的異常顯示問題
# Modify.........: No:MOD-D60157 13/06/19 By SunLM 进入单身删除异常问题
# Modify.........: No:MOD-D60162 13/06/19 By SunLM 單价為零可以正常生成應收賬款。
# Modify.........: No:TQC-D60063 13/06/20 By lixiang 新增時不經過開票人，開票部門欄位，增加對其控管
# Modify.........: No:TQC-D40067 13/06/23 By lixiang 單頭的自動編號放到單身新增前，避免同時錄入編號重複
# Modify.........: No:TQC-D40078 13/04/28 By xujing 負庫存函数添加营运中心参数 
# Modify.........: No:TQC-D70018 13/07/01 By lujh 因為一张出貨單可以多次開立發票，所以刪除單身時根據出貨單和項次去抓axrt300的資料判斷是不合理的
#                                                 可以進單身刪除，肯定還沒有拋應收，因此刪除單身時無需去抓axrt300的資料來做檢查 
# Modify.........: No:TQC-D70020 13/07/01 By lujh 單身單價本來為10.然後點擊更改將單價改為0，後面的原幣金額，稅額，本幣金額，稅額等欄位沒有跟著變 
# Modify.........: No:FUN-D60075 13/07/02 By zhuhao 審核多窗口問題處理
# Modify.........: No:MOD-D70152 13/07/23 By SunLM 補登發票后,更新oma10和oma09
# Modify.........: NO:MOD-D80108 13/08/16 By SunLM 经过出货单号开窗，自动带出的金额资料有问题
# Modify.........: NO:MOD-D80176 13/08/27 By SunLM 调整omf16赋值
# Modify.........: NO:MOD-DB0059 13/11/08 By SunLM 單身稅額欄位進行幣別取位
# Modify.........: No.MOD-DB0161 13/11/25 By SunLM 外銷出貨都需要有INVOICE單才可以立賬。所以應l_yes default 為Y
# Modify.........: No.MOD-DC0010 13/12/03 By SunLM tlf12应该根据仓储批，取出img09，如果为空，则再去取ima25库存单位
# Modify.........: No.MOD-DC0091 13/12/13 By SunLM 非成本仓的出货和销退不能开票
# Modify.........: No.MOD-DC0096 13/12/13 By SunLM 插入重复的报错处理

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_omf_1         RECORD
                           omf00        LIKE     omf_file.omf00,   #FUN-C60033 
	                       omf01        LIKE     omf_file.omf01,   #FUN-C50025
	                       omf02        LIKE     omf_file.omf02, 
	                       omf03        LIKE     omf_file.omf03, 
	                       #omf04        LIKE     omf_file.omf04,    #FUN-C60036 放入单身中  
	                       omf05        LIKE     omf_file.omf05, 
	                       omf051       LIKE     omf_file.omf051, 
	                       omf06        LIKE     omf_file.omf06, 
	                       omf061       LIKE     omf_file.omf061,
	                       omf07        LIKE     omf_file.omf07,
	                       omf08        LIKE     omf_file.omf08,
	                       omf22        LIKE     omf_file.omf22,
                               omf30        LIKE     omf_file.omf30,   #No.FUN-D10103   Add
                               omf24        LIKE     omf_file.omf24,   #No.FUN-C60036 add
	                       omfpost      LIKE     omf_file.omfpost,
                               omf04        LIKE     omf_file.omf04,    #FUN-D20003 add
	                       omf19_sum    LIKE     omf_file.omf19,
	                       omf19x_sum   LIKE     omf_file.omf19x,
	                       omf19t_sum   LIKE     omf_file.omf19t,
	                       omf29_sum    LIKE     omf_file.omf29,
	                       omf29x_sum   LIKE     omf_file.omf29x,
	                       omf29t_sum   LIKE     omf_file.omf29t,
                               omf31        LIKE     omf_file.omf31,     #FUN-D50008 add
                               omf32        LIKE     omf_file.omf32,     #FUN-D50007 add
                               omf33        LIKE     omf_file.omf33,     #FUN-D50007 add
                               omfuser      LIKE     omf_file.omfuser,   #FUN-D50009 add
                               omfgrup      LIKE     omf_file.omfgrup,   #FUN-D50009 add
                               omforiu      LIKE     omf_file.omforiu,   #FUN-D50009 add
                               omforig      LIKE     omf_file.omforig,   #FUN-D50009 add
                               omfmodu      LIKE     omf_file.omfmodu,   #FUN-D50009 add
                               omfdate      LIKE     omf_file.omfdate    #FUN-D50009 add
	                       END RECORD,
         g_omf_1_t       RECORD 
                               omf00        LIKE     omf_file.omf00,   #FUN-C60033
	                       omf01        LIKE     omf_file.omf01, 
	                       omf02        LIKE     omf_file.omf02, 
	                       omf03        LIKE     omf_file.omf03, 
	                       #omf04        LIKE     omf_file.omf04,    #FUN-C60036 放入单身中     
	                       omf05        LIKE     omf_file.omf05, 
	                       omf051       LIKE     omf_file.omf051, 
	                       omf06        LIKE     omf_file.omf06, 
	                       omf061       LIKE     omf_file.omf061,
	                       omf07        LIKE     omf_file.omf07,
	                       omf08        LIKE     omf_file.omf08,
	                       omf22        LIKE     omf_file.omf22,
                               omf30        LIKE     omf_file.omf30,   #No.FUN-D10103   Add
                               omf24        LIKE     omf_file.omf24,   #No.FUN-C60036 add
	                       omfpost      LIKE     omf_file.omfpost,
                               omf04        LIKE     omf_file.omf04,    #FUN-D20003 add
	                       omf19_sum    LIKE     omf_file.omf19,
	                       omf19x_sum   LIKE     omf_file.omf19x,
	                       omf19t_sum   LIKE     omf_file.omf19t,
	                       omf29_sum    LIKE     omf_file.omf29,
	                       omf29x_sum   LIKE     omf_file.omf29x,
	                       omf29t_sum   LIKE     omf_file.omf29t,
                               omf31        LIKE     omf_file.omf31,     #FUN-D50008 add
                               omf32        LIKE     omf_file.omf32,     #FUN-D50007 add
                               omf33        LIKE     omf_file.omf33,     #FUN-D50007 add
                               omfuser      LIKE     omf_file.omfuser,   #FUN-D50009 add
                               omfgrup      LIKE     omf_file.omfgrup,   #FUN-D50009 add
                               omforiu      LIKE     omf_file.omforiu,   #FUN-D50009 add
                               omforig      LIKE     omf_file.omforig,   #FUN-D50009 add
                               omfmodu      LIKE     omf_file.omfmodu,   #FUN-D50009 add
                               omfdate      LIKE     omf_file.omfdate    #FUN-D50009 add
	                       END RECORD,       
	                                  
         g_omf           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                         omf21       LIKE omf_file.omf21,
                         omf09       LIKE omf_file.omf09,
                         omf10       LIKE omf_file.omf10,
                         omf11       LIKE omf_file.omf11,
                         omf12       LIKE omf_file.omf12,
                         oga011      LIKE oga_file.oga011, #add by huanglf170313
                         ogb11       LIKE ogb_file.ogb11,  #add by dengsy160527
                         omf25       LIKE omf_file.omf25,   #FUN-D10082 add
                         omf26       LIKE omf_file.omf26,   #FUN-D10082 add
                         omf13       LIKE omf_file.omf13,
                         omf14       LIKE omf_file.omf14,
                         omf15       LIKE omf_file.omf15,  
                         omf23       LIKE omf_file.omf23, #FUN-C60036 add
                         omf20       LIKE omf_file.omf20,  
                         omf201      LIKE omf_file.omf201,
                         omf202      LIKE omf_file.omf202, #FUN-C60036 add
                         omf16       LIKE omf_file.omf16,
                         omf17       LIKE omf_file.omf17,
                         #FUN-C60036--add--str
                         omf913      LIKE omf_file.omf913,
                         omf914      LIKE omf_file.omf914,
                         omf915      LIKE omf_file.omf915,
                         omf910      LIKE omf_file.omf910,
                         omf911      LIKE omf_file.omf911,
                         omf912      LIKE omf_file.omf912,
                         omf916      LIKE omf_file.omf916,
                         omf917      LIKE omf_file.omf917,
                         #FUN-C60036--add--end
                         ogb14       LIKE ogb_file.ogb14,                         
                         omf28       LIKE omf_file.omf28,
                         omf29       LIKE omf_file.omf29,
                         omf29x      LIKE omf_file.omf29x,
                         omf29t      LIKE omf_file.omf29t,
                         omf18       LIKE omf_file.omf18,
                         omf19       LIKE omf_file.omf19,
                         omf19x      LIKE omf_file.omf19x,
                         omf19t      LIKE omf_file.omf19t#FUN-D20003 del ,
                        #omf04        LIKE     omf_file.omf04    #FUN-C60036 放入单身中#FUN-D20003 mark
                         END RECORD,
       g_omf_t           RECORD                 #程式變數 (舊值)
       	                 omf21       LIKE omf_file.omf21,
                         omf09       LIKE omf_file.omf09,
                         omf10       LIKE omf_file.omf10,
                         omf11       LIKE omf_file.omf11,
                         omf12       LIKE omf_file.omf12,
                         oga011      LIKE oga_file.oga011, #add by huanglf170313
                         ogb11       LIKE ogb_file.ogb11,  #add by dengsy160527
                         omf25       LIKE omf_file.omf25,   #FUN-D10082 add
                         omf26       LIKE omf_file.omf26,   #FUN-D10082 add
                         omf13       LIKE omf_file.omf13,
                         omf14       LIKE omf_file.omf14,
                         omf15       LIKE omf_file.omf15, 
                         omf23       LIKE omf_file.omf23, #FUN-C60036 add 
                         omf20       LIKE omf_file.omf20,  
                         omf201      LIKE omf_file.omf201,
                         omf202      LIKE omf_file.omf202, #FUN-C60036 add
                         omf16       LIKE omf_file.omf16,
                         omf17       LIKE omf_file.omf17,
                         #FUN-C60036--add--str
                         omf913      LIKE omf_file.omf913,
                         omf914      LIKE omf_file.omf914,
                         omf915      LIKE omf_file.omf915,
                         omf910      LIKE omf_file.omf910,
                         omf911      LIKE omf_file.omf911,
                         omf912      LIKE omf_file.omf912,
                         omf916      LIKE omf_file.omf916,
                         omf917      LIKE omf_file.omf917,
                         #FUN-C60036--add--end
                         ogb14       LIKE ogb_file.ogb14,                         
                         omf28       LIKE omf_file.omf28,
                         omf29       LIKE omf_file.omf29,
                         omf29x      LIKE omf_file.omf29x,
                         omf29t      LIKE omf_file.omf29t,
                         omf18       LIKE omf_file.omf18,
                         omf19       LIKE omf_file.omf19,
                         omf19x      LIKE omf_file.omf19x,
                         omf19t      LIKE omf_file.omf19t#FUN-D20003 del ,
                        #omf04        LIKE     omf_file.omf04   #FUN-C60036 放入单身中#FUN-D20003 mark
                         END RECORD,
       g_wc,g_sql       string, 
       g_ss             LIKE type_file.chr1, 
       g_rec_b          LIKE type_file.num5, 
       g_argv1              LIKE omf_file.omf00,        #(帳款編號)
       g_argv2              STRING,
       l_ac             LIKE type_file.num5  
DEFINE g_gec05          LIKE gec_file.gec05
DEFINE g_gec07          LIKE gec_file.gec07  
DEFINE g_omf01_t        LIKE omf_file.omf01
DEFINE g_omf00_t        LIKE omf_file.omf00   #FUN-C60033 
DEFINE g_omf02_t        LIKE omf_file.omf02
DEFINE g_omf16          LIKE omf_file.omf16  
DEFINE g_forupd_sql STRING   #SELECT ... FOR 
DEFINE g_chr           LIKE type_file.chr1   
DEFINE g_chr2          LIKE type_file.chr1    #TQC-D20009--xj--add
DEFINE g_cnt           LIKE type_file.num10  
DEFINE g_i             LIKE type_file.num5   
DEFINE g_msg           LIKE ze_file.ze03     
DEFINE g_row_count     LIKE type_file.num10  
DEFINE g_curs_index    LIKE type_file.num10  
DEFINE g_jump          LIKE type_file.num10  
DEFINE g_no_ask        LIKE type_file.num5    
DEFINE g_str           STRING                
DEFINE g_wc2           STRING                
DEFINE g_buf           STRING                  
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE g_ogb71              LIKE ogb_file.ogb71 
DEFINE g_t1                 LIKE ooy_file.ooyslip   #FUN-C60033
DEFINE p_row,p_col          LIKE type_file.num5  #FUN-C60036 add
#FUN-C60036--add--str
DEFINE g_imgg10_1       LIKE imgg_file.imgg10,
       g_imgg10_2       LIKE imgg_file.imgg10,
       g_auto_con       LIKE type_file.num5,
       g_omf11_str      STRING,   
       g_change         LIKE type_file.chr1,    
       g_ima25          LIKE ima_file.ima25,
       g_ima31          LIKE ima_file.ima31,
       
       g_ima906         LIKE ima_file.ima906,
       g_ima907         LIKE ima_file.ima907,
       g_ima908         LIKE ima_file.ima908,
       g_factor         LIKE img_file.img21,
       g_buf1            LIKE type_file.chr1000,
       g_flag           LIKE type_file.chr1,
       p_cmd            LIKE type_file.chr1,
       l_lock_sw        LIKE type_file.chr1,
       l_n              LIKE type_file.num5,
       g_tot            LIKE type_file.num20_6,
       g_type           LIKE type_file.chr2,
       g_argv3           LIKE oma_file.oma01
#FUN-C60036--add--end
DEFINE g_flag1          LIKE type_file.chr1   #FUN-C80107 add
DEFINE g_sum_omf16      LIKE omf_file.omf16   #FUN-D10082 add
#FUN-D10091----add---str
DEFINE g_omf_l           DYNAMIC ARRAY OF RECORD 
                         m           LIKE type_file.num5,
                         omf00       LIKE omf_file.omf00,
                         omf03       LIKE omf_file.omf03,
                         omf01       LIKE omf_file.omf01,
                         omf02       LIKE omf_file.omf02,
                         omf05       LIKE omf_file.omf05,
                         omf051      LIKE omf_file.omf051,
                         omf06       LIKE omf_file.omf06,
                         omf07       LIKE omf_file.omf07,
                         omf22       LIKE omf_file.omf22,
                         omf10       LIKE omf_file.omf10,
                         omf11       LIKE omf_file.omf11,
                         omf12       LIKE omf_file.omf12,
                         omf13       LIKE omf_file.omf13,
                         omf14       LIKE omf_file.omf14,
                         omf15       LIKE omf_file.omf15,
                         omf16       LIKE omf_file.omf16,
                         omf17       LIKE omf_file.omf17,
                         omf29       LIKE omf_file.omf29,
                         omf19       LIKE omf_file.omf19,
                         omf04       LIKE omf_file.omf04,
                         ogb11       LIKE ogb_file.ogb11  #add by dengsy160527
                
                         END RECORD
DEFINE  l_ac1         LIKE type_file.num5
DEFINE  g_action_flag  STRING
DEFINE   w    ui.Window
DEFINE   f    ui.Form
DEFINE   page om.DomNode
DEFINE g_bp_flag       LIKE type_file.chr10
DEFINE g_rec_b1        LIKE type_file.num10
define l_ogc12 				 like ogc_file.ogc12   #add by dengsy160614
define l_ogc12_1 				 like ogc_file.ogc12   #add by dengsy160614
define l_count5				 like type_file.num5   #add by dengsy160614
DEFINE g_change1    LIKE type_file.chr1 #add by ly 20170222
DEFINE l_count1,l_count2        LIKE type_file.num5  #add by dengsy170410
#FUN-D10091---add---end
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
   LET g_argv1 = ARG_VAL(1) #FUN-C60036 add omf00
   LET g_argv2 = ARG_VAL(2) #
   LET g_argv3 = ARG_VAL(3) #FUN-C60036 add oma01
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   SELECT oaz100,oaz106 INTO g_oaz.oaz100,g_oaz.oaz106 FROM oaz_file #FUN-C60036 add
   SELECT ccz01,ccz02 INTO g_ccz.ccz01,g_ccz.ccz02 FROM ccz_file     #MOD-CC0049 add
   IF g_oaz.oaz92 = 'N' THEN
      CALL cl_err('','axm-545',1)
      EXIT PROGRAM
   END IF
   SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00 = '0'   #MOD-CA0160
   #FUN-C60033---MOD---STR   
   #LET g_forupd_sql = "SELECT omf01,omf02,omf03,omf05,omf06,omf07,omf22",
   #                    "  FROM omf_file WHERE omf01=? AND omf02=? FOR UPDATE" 
    LET g_forupd_sql = "SELECT omf00,omf01,omf02,omf03,omf05,omf06,omf07,omf22,omf30,",   #No.FUN-D10103 Add omf30
                       "       omf31,omf32,omf33 ",   #FUND-50008 #FUN-D50007 add
                       "  FROM omf_file WHERE omf00=? FOR UPDATE"
   #FUN-C60033--MOD--END
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t670_cl CURSOR FROM g_forupd_sql
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   INITIALIZE g_omf_1.* TO NULL
   INITIALIZE g_omf_1_t.* TO NULL
 
   OPEN WINDOW t670_w WITH FORM "axm/42f/axmt670"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_set_locale_frm_name("axmt670")  
   CALL cl_ui_init()
 
   IF g_aza.aza47 = 'Y' THEN
      CALL cl_set_act_visible("issue_invoice",TRUE)
   END IF

   CALL cl_set_act_visible("bdfp",g_aza.aza47 = 'N')#FUN-D20003 add
   #FUN-C60033--add--by xuxz str
    IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("omf913",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("omf915",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("omf910",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("omf912",g_msg CLIPPED)
   END IF

   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("omf913",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("omf915",g_msg CLIPPED)
      CALL cl_getmsg('axm-567',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("omf910",g_msg CLIPPED)
      CALL cl_getmsg('axm-568',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("omf912",g_msg CLIPPED)
   END IF
   #FUN-C60033--add--by xuxz  end
   #IF g_ooz.ooz93 = 'N' THEN
      CALL cl_set_comp_visible("omf20,omf201,omfpost",TRUE)
   	  CALL cl_set_act_visible("deduct_inventory,undo_deduct",TRUE)
   #ELSE
   #	  CALL cl_set_comp_visible("omf20,omf201",FALSE)
   #	  CALL cl_set_act_visible("deduct_inventory,undo_deduct",FALSE)
   #END IF
   #FUN-C60036--add--str
   IF NOT cl_null(g_argv3) THEN 
      LET g_action_choice = "query"
      IF cl_chk_act_auth() THEN
         CALL t670_q()
      END IF
   END IF 
   IF NOT cl_null(g_argv1) AND g_argv2 = 'q' THEN 
      LET g_action_choice = "query"
      IF cl_chk_act_auth() THEN
         CALL t670_q()
      END IF
   END IF
   IF g_sma.sma115 ='N' THEN #使用双单位					
      CALL cl_set_comp_visible("omf913,omf914,omf915",FALSE)					
      CALL cl_set_comp_visible("omf910,omf911,omf912",FALSE)	
      CALL cl_set_comp_visible("omf16,omf17",TRUE)    
   ELSE					
      CALL cl_set_comp_visible("omf913,omf914,omf915",TRUE)					
     #CALL cl_set_comp_visible("omf910,omf911,omf912",TRUE)
      CALL cl_set_comp_visible("omf914,omf911",FALSE) #FUN-C60033 add by xuxz 
      CALL cl_set_comp_visible("omf910,omf912",TRUE)#FUN-C60033 add by xuxz
      CALL cl_set_comp_visible("omf16,omf17",FALSE)					
   END IF					
   SELECT oaz93,oaz02 INTO g_oaz.oaz93,g_oaz.oaz92 FROM oaz_file
   IF g_oaz.oaz93 = 'Y' AND g_oaz.oaz92 = 'Y' THEN 
      CALL cl_set_comp_visible("omfpost",TRUE)	
      CALL cl_set_act_visible("deduct_inventory,undo_deduct",TRUE)
      CALL cl_set_comp_visible("omf24",TRUE)
   ELSE 
      CALL cl_set_comp_visible("omfpost",FALSE)	
      CALL cl_set_act_visible("deduct_inventory,undo_deduct",FALSE)
      CALL cl_set_comp_visible("omf24",FALSE)
   END IF 
   IF g_sma.sma116 MATCHES '[01]' THEN    			
      CALL cl_set_comp_visible("omf916,omf917",FALSE)
   ELSE
      CALL cl_set_comp_visible("omf916,omf917",TRUE)	   
   END IF		
   
   LET g_type = '1'
   IF g_oaz.oaz92 = 'Y' AND g_aza.aza26 = '2' AND g_aza.aza47 = 'Y' THEN 
      CALL cl_set_act_visible("maintain_invoice,issue_invoice",TRUE)
   ELSE
      CALL cl_set_act_visible("maintain_invoice,issue_invoice",FALSE)
   END IF 
   #FUN-C60036--add--end
   
   #FUN-C60036--minpp--add---str
   CALL cl_set_comp_visible("ogb14",FALSE)
   SELECT oaz93 INTO g_oaz.oaz93 FROM oaz_file WHERE oaz00='0'
   IF g_oaz.oaz93 = 'N' THEN
      CALL cl_set_comp_visible("omf23,omf20,omf201,omf202",FALSE)
      CALL cl_set_act_visible("qry_mntn_inv_detail",FALSE)
   ELSE
      CALL cl_set_comp_visible("omf23,omf20,omf201,omf202",TRUE)
      CALL cl_set_act_visible("qry_mntn_inv_detail",TRUE)
   END IF
   #FUN-C60036--minpp--add---end
   

   CALL t670_menu()
   CLOSE WINDOW t670_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t670_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
   CLEAR FORM                             #清除畫面
   CALL g_omf.clear()
   #FUN-C60036--ad--str
   IF NOT cl_null(g_argv3) THEN 
      LET g_wc2 = " omf04 = '",g_argv3,"'"
      LET g_wc  = " 1=1"
   ELSE
      IF NOT cl_null(g_argv1) AND g_argv2 = 'q' THEN 
         LET g_wc = " omf00 ='",g_argv1,"'"
         LET g_wc2 = " 1=1"
      ELSE
   #FUN-C60036--add--end
      CALL cl_set_head_visible("","YES")           #設定單頭為顯示狀態
      INITIALIZE g_omf_1.* TO NULL  
      
      #CONSTRUCT BY NAME g_wc ON omf00,omf03,omf01,omf02,omf04,omf05,omf06,omf07,omf08,omf22   #FUN-C60033 ADD omf00 #FUN-C60036 mark
     #CONSTRUCT BY NAME g_wc ON omf00,omf03,omf01,omf02,omf05,omf06,omf07,omf22,omf08,omf30,omf24,omfpost   #FUN-C60036  #No.FUN-D10103   Add omf30#FUN-D20003 mark
      CONSTRUCT BY NAME g_wc ON omf00,omf03,omf01,omf02,omf31,omf05,omf06,omf07,omf22, #FUN-D50008 add omf31
                                omf32,omf33,     #FUN-D50007 add omf32,omf33
                                omf08,omf24,omfpost,omf04, #FUN-D20003 add
                                omfuser,omfgrup,omforiu,omforig,omfmodu,omfdate  #FUN-D50009 add

      BEFORE CONSTRUCT      
         CALL cl_qbe_display_condition(lc_qbe_sn)
         INITIALIZE g_omf_1.* TO NULL
 
      ON ACTION controlp
         CASE
            #FUN-C60033--ADD--STR
             WHEN INFIELD(omf00)
               #No.yinhy130515  --Begin
               #CALL cl_init_qry_var()
               #LET g_qryparam.form ="q_omf"
               #LET g_qryparam.state = "c"
               #CALL cl_create_qry() RETURNING g_qryparam.multiret    
               CALL q_omf1(TRUE,TRUE,'','') RETURNING g_qryparam.multiret
               #No.yinhy130515  --End
               DISPLAY g_qryparam.multiret TO  omf00
               NEXT FIELD omf00
             #FUN-C60033--ADD--END

            WHEN INFIELD(omf05)                                                 
               CALL cl_init_qry_var()                                           
               LET g_qryparam.form ="q_occ"                                    
               LET g_qryparam.state = "c"                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret               
               DISPLAY g_qryparam.multiret TO  omf05                            
               NEXT FIELD omf05
	    WHEN INFIELD(omf06)
	       CALL cl_init_qry_var()
	       LET g_qryparam.form ="q_gec"
	       LET g_qryparam.state = "c"
	       CALL cl_create_qry() RETURNING g_qryparam.multiret
	       DISPLAY g_qryparam.multiret TO omf06
	       NEXT FIELD omf06
	        
	    WHEN INFIELD(omf07)
	       CALL cl_init_qry_var()
	       LET g_qryparam.form ="q_azi"
	       LET g_qryparam.state = "c"
	       CALL cl_create_qry() RETURNING g_qryparam.multiret
	       DISPLAY g_qryparam.multiret TO omf07
	       NEXT FIELD omf07
          #FUN-D50007--add--begin---
            WHEN INFIELD(omf32)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_omf32"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO omf32
               NEXT FIELD omf32
            WHEN INFIELD(omf33)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_omf33"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO omf33
               NEXT FIELD omf33
          #FUN-D50007--add--end---
	    OTHERWISE EXIT CASE
	       END CASE
	       
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF INT_FLAG THEN RETURN END IF              
   #FUN-C60036--mod--str   
    # CONSTRUCT g_wc2 ON omf21,omf09,omf10,omf11,omf12,omf16,omf18,omf29,omf29x,omf29t,omf19,omf19x,omf19t,omf04 #FUN-C60036 add omf04
    #              FROM s_omf[1].omf21,s_omf[1].omf09,s_omf[1].omf10,s_omf[1].omf11,s_omf[1].omf12, s_omf[1].omf16, s_omf[1].omf18,
    #                   s_omf[1].omf29,s_omf[1].omf29x,s_omf[1].omf29t,s_omf[1].omf19,s_omf[1].omf19x,s_omf[1].omf19t,s_omf[1].omf04 # FUN-C60036 add omf04                  
      CONSTRUCT g_wc2 ON omf21,omf09,omf10,omf11,omf12,omf25,omf26,omf13,omf14,  #FUN-D10082 add omf25,omf26
                         omf15,omf23,omf20,omf201,omf202,omf16,omf17,omf913,omf914,omf915,omf910,
                          omf911,omf912,omf916,omf917,omf28,omf29,omf29x,omf29t,omf18,omf19,omf19x,omf19t#,omf04#FUN-D20003 mark omf04
                   FROM  s_omf[1].omf21,s_omf[1].omf09,s_omf[1].omf10,s_omf[1].omf11,s_omf[1].omf12,
                         s_omf[1].omf25,s_omf[1].omf26,s_omf[1].omf13,s_omf[1].omf14, #FUN-D10082 add omf25,omf26
                         s_omf[1].omf15,s_omf[1].omf23,s_omf[1].omf20,s_omf[1].omf201,s_omf[1].omf202,s_omf[1].omf16,s_omf[1].omf17,
                         s_omf[1].omf913,s_omf[1].omf914,s_omf[1].omf915,s_omf[1].omf910,
                         s_omf[1].omf911,s_omf[1].omf912,s_omf[1].omf916,s_omf[1].omf917,s_omf[1].omf28,s_omf[1].omf29,
                         s_omf[1].omf29x,s_omf[1].omf29t,s_omf[1].omf18,s_omf[1].omf19,s_omf[1].omf19x,s_omf[1].omf19t#,s_omf[1].omf04#FUN-D20003 mark omf04

      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      
      
      ON ACTION CONTROLP
	 CASE
            WHEN INFIELD(omf09)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azw"
	       LET g_qryparam.state = "c"
               LET g_qryparam.where = "azw02 = '",g_legal,"' "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO omf09
               NEXT FIELD omf09
        #FUN-D10082--add--str--
            WHEN INFIELD(omf25)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oea01_2"
	           LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO omf25
               NEXT FIELD omf25
        #FUN-D10082--add--end--
	    WHEN INFIELD(omf11)#出貨單單號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_omf11"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO omf11
               NEXT FIELD omf11   
            WHEN INFIELD(omf14)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_omf14"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO omf14
               NEXT FIELD omf14
          #FUN-D50006--add---begin---
            WHEN INFIELD(omf17)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gfe"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO omf17
               NEXT FIELD omf17
          #FUN-D50006--add---end---
            WHEN INFIELD(omf913)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gfe"
	       LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO omf913
               NEXT FIELD omf913
            WHEN INFIELD(omf910)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gfe"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO omf910
               NEXT FIELD omf910
            WHEN INFIELD(omf916)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gfe"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO omf916
               NEXT FIELD omf916                 
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
         CALL cl_qbe_select()
         
      ON ACTION qbe_save
		     CALL cl_qbe_save()
		
     END CONSTRUCT
 
      IF INT_FLAG THEN
         RETURN
      END IF
     END IF #FUN-C60036 add
  END IF #FUN-C60036 add
  #LET g_sql= "SELECT UNIQUE omf01,omf02,omf03,omf04,omf05,omf051,omf06,omf061,omf07,omf08,omf22,omfpost FROM omf_file ",  #FUN-C60033 MARK
   LET g_sql= #"SELECT UNIQUE omf00,omf01,omf02,omf03,omf04,omf05,omf051,omf06,omf061,omf07,omf08,omf22,omf24,omfpost FROM omf_file ", #FUN-C60033
              " SELECT UNIQUE omf00 FROM omf_file ", #UNIQUE 121106 MOD-CB0041 add
              " WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
              " ORDER BY 1"
   PREPARE t670_prepare FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('t670_prepare',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE t670_b_curs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR t670_prepare
      	
  #LET g_sql="SELECT COUNT(DISTINCT omf01) FROM omf_file WHERE ",g_wc CLIPPED, " AND ",g_wc2 CLIPPED    #FUN-C60033  mark
   LET g_sql="SELECT COUNT(DISTINCT omf00) FROM omf_file WHERE ",g_wc CLIPPED, " AND ",g_wc2 CLIPPED    #FUN-C60033
   PREPARE t670_precount FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('t670_precount',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE t670_count CURSOR FOR t670_precount
END FUNCTION
 
FUNCTION t670_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(100)
   DEFINE l_partnum    STRING   #GPM料號
   DEFINE l_supplierid STRING   #GPM廠商
   DEFINE l_status     LIKE type_file.num10  #GPM傳回值
   DEFINE l_oma00      LIKE oma_file.oma00 #FUN-C60036 add
   DEFINE l_wc STRING   #add by guanyao160831
 
   WHILE TRUE
      IF cl_null(g_action_flag) OR g_action_flag = "Page1" THEN   #FUN-D10091 add
         CALL t670_bp("G")
      #FUN-D10091------add---str
      ELSE
         CALL t670_list_fill()
         CALL t670_bp2("G")
         IF NOT cl_null(g_action_choice) AND l_ac1>0 THEN #將清單的資料回傳到主畫面
     #      SELECT omf_file.* INTO g_omf_1.*
            SELECT omf_file.*,'' INTO g_omf_l[l_ac1].*  #add ,'' by dengsy160527
              FROM omf_file
             WHERE omf00=g_omf_l[l_ac1].omf00
             #str----- add by dengsy160527
             LET g_omf_l[l_ac1].ogb11=NULL 
             SELECT ogb11 INTO g_omf_l[l_ac1].ogb11 FROM ogb_file 
             WHERE ogb01=g_omf_l[l_ac1].omf11 AND ogb03=g_omf_l[l_ac1].omf12
             IF cl_null(g_omf_l[l_ac1].ogb11) THEN 
                SELECT ohb11 INTO g_omf_l[l_ac1].ogb11 FROM ohb_file 
                WHERE ohb01=g_omf_l[l_ac1].omf11 AND ohb03=g_omf_l[l_ac1].omf12
             END IF  
             #end----- add by dengsy160527


         END IF
         IF g_action_choice!= "" THEN
            LET g_action_flag = "Page1"
            LET l_ac1 = ARR_CURR()
            LET g_jump = g_omf_l[l_ac1].m
            IF g_rec_b1 >0 THEN
               CALL t670_fetch('/')
            END IF
            CALL cl_set_comp_visible("Page2", FALSE)
            CALL cl_set_comp_visible("info", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("Page2", TRUE)
            CALL cl_set_comp_visible("info", TRUE)
          END IF
      END IF
      #FUN-FUN-D10091-----add----end
      CASE g_action_choice
 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t670_a()
               CALL t670_show()  #add by dengsy170222
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t670_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t670_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t670_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t670_b()
               CALL t670_show() #add by dengsy170222
            ELSE
               LET g_action_choice = NULL
            END IF
         
         WHEN "confirm"
           IF cl_chk_act_auth() THEN
              BEGIN WORK
              LET g_auto_con = 1
              CALL t670_y()
              IF g_success = 'Y' THEN 
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF 
              CALL t670_show()
           END IF
        #TQC-D20009--xj--add--str
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t670_x()
            END IF
        #TQC-D20009--xj--add--end
           
        #FUN-D20003--add--str
         WHEN "bdfp"
            IF cl_chk_act_auth() THEN
               CALL t670_bdfp()
               CALL t670_show()
            END IF
        #FUN-D20003--add--end
         WHEN "undo_confirm"
           IF cl_chk_act_auth() THEN
              BEGIN WORK
              LET g_auto_con = 1
              CALL t670_w()
              IF g_success = 'Y' THEN
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF
              CALL t670_show()
           END IF
         
         WHEN "deduct_inventory"
            IF cl_chk_act_auth() THEN
            	 LET g_success = "Y"
              BEGIN WORK
              LET g_auto_con = 2
               CALL t670_s()  
              #CALL t670_show()#FUN-C60036 mark
               IF g_success = "Y" THEN
                  COMMIT WORK                  
               ELSE
                  ROLLBACK WORK
               END IF
               CALL t670_show() #FUN-C60036 add
            END IF
         
         WHEN "undo_deduct"
            IF cl_chk_act_auth() THEN
            	 LET g_success = "Y"
               BEGIN WORK #FUN-C60036 add
               LET g_auto_con = 2
               CALL t670_z()  
              # CALL t670_show()#FUN-C60036 mark
               IF g_success = "Y" THEN
                  COMMIT WORK                  
               ELSE
                  ROLLBACK WORK
               END IF
               CALL t670_show() #FUN-C60036 add
            END IF
         WHEN "issue_invoice"
         	  IF cl_chk_act_auth() THEN
               #LET g_msg="gisp100 '",g_omf_1.omf04,"'"  #FUN-C60036 mark
              #CALL cl_cmdrun_wait(g_msg) #FUN-C60036 mark
               CALL t670_gisp101()
            END IF
         #FUN-C60036--minpp--str
         WHEN "maintain_invoice"
            IF cl_chk_act_auth() THEN
               LET g_msg = "gisi100 '",g_omf_1.omf00,"' '",g_omf_1.omf02,"'" 
               CALL cl_cmdrun_wait(g_msg)
            END IF
         #FUN-C60036--minpp--end  

         #add by ly 20170222--s
         WHEN "unit_price"
            IF cl_chk_act_auth() THEN
               
               LET g_change1 = 'Y'
               CALL t670_b()
               LET g_change1 = 'N'
            END IF
         #add by ly 20170222--e
         
         #FUN-C60036--add--str
         WHEN "spin_fin"                      #拋轉財務
            IF cl_chk_act_auth() THEN
               BEGIN WORK
               LET g_auto_con = 2
               CALL t670_axrp310()
               IF g_success = 'Y' THEN
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF
            END IF
         WHEN "a_r"
            IF cl_chk_act_auth() THEN  #TQC-D10020 add
               LET l_ac = ARR_CURR()   #TQC-D10020 add
               IF l_ac != 0 THEN   #TQC-D10020 add
                 #IF NOT cl_null(g_omf[l_ac].omf04) THEN#FUN-D20003 mark
                 IF NOT cl_null(g_omf_1.omf00) THEN#FUN-D20003 add
                     SELECT oma00 INTO l_oma00 FROM oma_file
                     #WHERE oma01=g_omf[l_ac].omf04#FUN-D20003 mark
                     WHERE oma01 = g_omf_1.omf04 #FUN-D20003 add
                     IF cl_null(l_oma00) THEN
                        LET l_oma00='12'
                     END IF
                    #LET g_msg="axrt300 '",g_omf[l_ac].omf04,"' '' '",l_oma00,"'"   #FUN-D20003 mark
                     LET g_msg="axrt300 '",g_omf_1.omf04,"' '' '",l_oma00,"'"   #FUN-D20003  add

                     CALL cl_cmdrun_wait(g_msg)  
                     CALL t670_b_fill("1=1")
                  END IF
               END IF  #TQC-D10020 add
            END IF  #TQC-D10020 add
         WHEN "qry_mntn_inv_detail"
            IF cl_chk_act_auth() THEN
                LET l_ac = ARR_CURR()
                IF l_ac != 0 THEN
                    IF g_omf[l_ac].omf23 = 'Y' THEN
                        LET g_success = 'Y'             
                        BEGIN WORK                       
                        IF g_sma.sma115 = 'Y' THEN
                           CALL t670_b_ogg_1()
                        ELSE
                           CALL t670_b_ogc_1()
                        END IF
                        IF g_success = "Y" THEN
                           COMMIT WORK
                        ELSE
                           ROLLBACK WORK    
                        END IF
                    END IF
                END IF
            END IF

         #FUN-CB0040---add---str
         WHEN "output"
           IF cl_chk_act_auth()  AND NOT cl_null(g_omf_1.omf00) THEN
              #str-----mark by guanyao160811
              #LET g_msg = "axmr680",
              #            " '",g_omf_1.omf00,"' 'Y'"
              #end-----mark by guanyao160811
              #str-----add by guanyao160831
              LET l_wc = ' omf00 = "',g_omf_1.omf00,'"'
              LET g_msg = "cxmr015",
                          " '",g_today CLIPPED,"' ''",
                          " '",g_lang CLIPPED,"' 'Y' '' '1'",  
                          " '",l_wc CLIPPED,"' "
                          ," '1' 'N' 'N' 'Y'"
              #end-----add by guanyao160831
                          CALL cl_cmdrun(g_msg)
            END IF
         #FUN-CB0040---add---end

         #FUN-C60036--add--end
         #tianry add 161110tianry
         WHEN "t670_sum_omf"
            IF cl_chk_act_auth() THEN
               IF g_omf_1.omf00 IS NOT NULL THEN
                    LET g_msg="cxmq007 '",g_omf_1.omf00,"'"," '",g_gec07,"'" 
                    CALL cl_cmdrun_wait(g_msg) #MOD-580344
               END IF
            END IF            


         #tianry add end 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
             #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_omf_1),'','')  #MOD-CA0160 mark
              #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_omf),'','')  #MOD-CA0160 add  #mark by dengsy160527
              #str------ add by dengsy160527
              LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               IF cl_null(g_action_flag) OR g_action_flag = "Page1" THEN
                  LET page = f.FindNode("Page","page1")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_omf),'','')
               END IF
               IF g_action_flag = "Page2" THEN
                  LET page = f.FindNode("Page","page2")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_omf_l),'','')
               END IF
              #end------ add by dengsy160527
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_omf_1.omf00 IS NOT NULL THEN
                 LET g_doc.column1 = "omf00"
                 LET g_doc.value1 = g_omf_1.omf00
                 CALL cl_doc()
               END IF
         END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t670_a()
   DEFINE li_result   LIKE type_file.chr1    #FUN-C60033
   DEFINE l_gen02      LIKE gen_file.gen02   #FUN-D50007 add
   DEFINE l_gem02      LIKE gem_file.gem02   #FUN-D50007 add

   MESSAGE ""
   CLEAR FORM
   CALL g_omf.clear()
   INITIALIZE g_omf_1.* TO NULL

   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
 
   WHILE TRUE
   	  LET g_omf_1.omf03 = g_today       #Default
          LET g_omf_1.omf08 = 'N'           #FUN-C60036
          LET g_omf_1.omf02 = ' '           #FUN-C60036 add
          DISPLAY BY NAME g_omf_1.omf08     #FUN-C60036--minpp
          LET g_omf_1.omfpost = 'N'         #FUN-C60036 add
          DISPLAY BY NAME g_omf_1.omfpost   #FUN-C60036 add
          SELECT oaz97 INTO g_oaz.oaz97 FROM oaz_file WHERE oaz00='0'    #FUN-C60036--minpp--0718
          LET g_omf_1.omf00 = g_oaz.oaz97
          DISPLAY BY NAME g_omf_1.omf00                                   #FUN-C60036--minpp--0718
          LET g_omf_1.omfuser = g_user    #FUN-D50009 add
          LET g_omf_1.omfgrup = g_grup    #FUN-D50009 add
          LET g_omf_1.omforiu = g_user    #FUN-D50009 add
          LET g_omf_1.omforig = g_grup    #FUN-D50009 add
          LET g_omf_1.omfdate = g_today   #FUN-D50009 add
          LET g_omf_1.omf31 = g_today   #FUN-D50008 add
          LET g_omf_1.omf32 = g_user    #FUN-D50007 add
          LET g_omf_1.omf33 = g_grup    #FUN-D50007 add

      CALL t670_i("a")                #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_omf_1.* TO NULL
         DISPLAY BY NAME g_omf_1.* 
         CLEAR FORM       #FUN-D50007 add
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      #FUN-C60033---ADD---STR
      IF cl_null(g_omf_1.omf00) THEN
         CONTINUE WHILE
      END IF
#       CALL s_auto_assign_no("axm",g_omf_1.omf00,g_omf_1.omf03,"","omf_file","omf00","","","") RETURNING li_result,g_omf_1.omf00 #TQC-D40067 mark
#      IF (NOT li_result) THEN #TQC-D40067 mark
#         CONTINUE WHILE #TQC-D40067 mark
#      END IF #TQC-D40067 mark
      DISPLAY BY NAME g_omf_1.omf00

     #FUN-D50007---add--begin---
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_omf_1.omf32
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = g_omf_1.omf33
      DISPLAY l_gen02 TO FORMONLY.gen02
      DISPLAY l_gem02 TO FORMONLY.gem02
     #FUN-D50007---add--end---
   
      #FUN-C60033---ADD---END
      LET g_rec_b = 0
      IF g_ss='N' THEN
         CALL g_omf.clear()
      ELSE
         CALL t670_b_fill('1=1')         #單身
      END IF
      CALL t670_b()                      #輸入單身

      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t670_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,        
   l_n         	   LIKE type_file.num10        
DEFINE  lc_prog_name   LIKE gaz_file.gaz03                                                                                                
DEFINE  i        LIKE type_file.num5                                                                                                
DEFINE l_mm         LIKE type_file.num5
DEFINE l_yy         LIKE type_file.num5  
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_gen02      LIKE gen_file.gen02   #FUN-D50007 add
DEFINE l_gem02      LIKE gem_file.gem02   #FUN-D50007 add
DEFINE l_flag       LIKE type_file.chr1  #MOD-D60035
DEFINE l_omf00      LIKE omf_file.omf00   #TQC-D40067 add

   LET g_ss='Y'
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032

   
  IF p_cmd = 'a' THEN 
     CALL cl_set_comp_required('omf05,omf06,omf07,omf22',TRUE)
  END IF 
  INPUT BY NAME g_omf_1.omf00,g_omf_1.omf03,g_omf_1.omf01,g_omf_1.omf02,   #FUN-C60033 ADD-omf00
                g_omf_1.omf31,g_omf_1.omf05,g_omf_1.omf06,     #FUN-D50008 add omf31
  	       #g_omf_1.omf07,g_omf_1.omf04,g_omf_1.omf22 #FUN-C60036--mark
                g_omf_1.omf07,g_omf_1.omf22, #FUN-C60036--add
                g_omf_1.omf32,g_omf_1.omf33,  #FUN-D50007 add
                g_omf_1.omf30   #No.FUN-D10103 Add
       WITHOUT DEFAULTS 
      
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t670_set_entry(p_cmd)
         CALL t670_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("omf00")  #TQC-D40067 add
     #FUN-C60033---ADD---STR      
      AFTER FIELD omf00
         IF (p_cmd = 'a') OR
            (p_cmd = 'u' AND g_omf_1_t.omf00 != g_omf_1.omf00) THEN
            IF NOT cl_null(g_omf_1.omf00) AND NOT cl_null(g_omf_1.omf00) THEN
               CALL s_get_doc_no(g_omf_1.omf00) RETURNING l_omf00 #TQC-D40067 add
               #CALL t670_oay_chk(g_omf_1.omf00)  #TQC-D40067 mark
               CALL t670_oay_chk(l_omf00)         #TQC-D40067 add
               IF cl_null(g_errno)THEN
                  DISPLAY g_omf_1.omf00 TO omf00 
               ELSE
                  CALL cl_err('',g_errno,0)
                  LET g_omf_1.omf00 = ''
                  NEXT FIELD omf00
               END IF
             END IF  
          END IF
        #FUN-C60033--ADD---END
 	
      AFTER FIELD omf01
        IF (p_cmd = 'a') OR
           (p_cmd = 'u' AND g_omf_1_t.omf01 != g_omf_1.omf01) THEN
           IF NOT cl_null(g_omf_1.omf01) AND g_omf_1.omf02 IS NOT NULL THEN  
              SELECT COUNT(*) INTO l_n FROM omf_file
               WHERE omf01 = g_omf_1.omf01
                 AND omf02 = g_omf_1.omf02
              IF l_n > 0  THEN
                 CALL cl_err('',-239,0)
                 LET g_omf_1.omf01 = g_omf_1_t.omf01
                 DISPLAY BY NAME g_omf_1.omf01
                 NEXT FIELD omf01
               END IF
             #FUN-C60036--mark--str--
             #SELECT COUNT(*) INTO l_n FROM ome_file
             # WHERE ome03 = g_omf_1.omf01
             #   AND ome01 IN (SELECT oma10 FROM oma_file)
             #IF l_n > 0 THEN
             #   CALL cl_err('','axr-331',0)
             #   NEXT FIELD omf01
             #END IF     
             #FUN-C60036--mark--end
            END IF
           #MOD-CA0160--mark--str--
           #IF NOT cl_null(g_omf_1.omf01) THEN  
           #   IF g_ooz.ooz32 = 'Y' THEN
           #   	 LET l_yy = YEAR(g_omf_1.omf03)
           #      LET l_mm = MONTH(g_omf_1.omf03)
           #      LET l_cnt = 0
           #      SELECT COUNT(*) INTO l_cnt FROM oom_file
           #       WHERE oom01 = l_yy
           #         AND l_mm BETWEEN oom02 AND oom021
           #         AND oom07 <= g_omf_1.omf01 AND g_omf_1.omf01 <= oom08
           #         AND (oom16 = g_omf_1.omf02 OR oom16 IS NULL)
           #      IF l_cnt = 0 THEN
           #         CALL cl_err(g_omf_1.omf01,'axr-314',0)
           #         NEXT FIELD omf01
           #      END IF               
           #   END IF 
           #END IF    
           #MOD-CA0160--mark--end
        END IF
        IF g_omf_1.omf01 IS NULL THEN LET g_omf_1.omf01 = ' ' END IF   #FUN-C60033     
 
      AFTER FIELD omf02
         IF (p_cmd = 'a') OR
            (p_cmd = 'u' AND g_omf_1_t.omf02 != g_omf_1.omf02) THEN
            IF NOT cl_null(g_omf_1.omf01) AND g_omf_1.omf02 IS NOT NULL THEN  
              SELECT COUNT(*) INTO l_n FROM omf_file
               WHERE omf01 = g_omf_1.omf01
                 AND omf02 = g_omf_1.omf02
              IF l_n > 0  THEN
                 CALL cl_err('',-239,0)
                 LET g_omf_1.omf01 = g_omf_1_t.omf01
                 DISPLAY BY NAME g_omf_1.omf01
                 NEXT FIELD omf01
              END IF
             #FUN-C60036--mark--str--
             #SELECT COUNT(*) INTO l_n FROM ome_file
             # WHERE ome03 = g_omf_1.omf01
             #   AND ome01 IN (SELECT oma10 FROM oma_file)
             #IF l_n > 0 THEN
             #   CALL cl_err('','axr-331',0)
             #   NEXT FIELD omf01
             #END IF     
             #FUN-C60036--mark--end
            END IF
           #MOD-CA0160--mark-str--
           #IF g_omf_1.omf02 IS NOT NULL THEN
           #   IF g_ooz.ooz32 = 'Y' THEN
           #   	 LET l_yy = YEAR(g_omf_1.omf03)
           #      LET l_mm = MONTH(g_omf_1.omf03)
           #      LET l_cnt = 0
           #      SELECT COUNT(*) INTO l_cnt FROM oom_file
           #       WHERE oom01 = l_yy
           #         AND l_mm BETWEEN oom02 AND oom021
           #         AND oom07 <= g_omf_1.omf01 AND g_omf_1.omf01 <= oom08
           #         AND (oom16 = g_omf_1.omf02 OR oom16 IS NULL)
           #      IF l_cnt = 0 THEN
           #         CALL cl_err(g_omf_1.omf01,'axr-314',0)
           #         NEXT FIELD omf01
           #      END IF               
           #   END IF 
           #END IF      
           ##MOD-CA0160--mark--end
        END IF     
        IF g_omf_1.omf02 IS NULL THEN lET g_omf_1.omf02 = ' ' END IF  #FUN-C60036--add--
      #MOD-CC0049 add begin----------------------
      AFTER FIELD omf03
         IF NOT cl_null(g_omf_1.omf03) THEN 
            CALL s_yp(g_omf_1.omf03) RETURNING l_yy,l_mm
            IF l_yy < g_ccz.ccz01 OR (l_yy = g_ccz.ccz01 AND l_mm < g_ccz.ccz02) THEN
               CALL cl_err('','axm-771',0)
               NEXT FIELD omf03
            END IF
            #MOD-D60035 add begin-----------
            IF p_cmd = 'u' THEN 
               CALL t670_chk_date() RETURNING l_flag  #MOD-D60035         
               IF l_flag ='N' THEN 
                  CALL cl_err(g_omf_1.omf03,'axm-772',1)
                  NEXT FIELD omf03
               END IF    
            END IF 
            #MOD-D60035 add end-------------             
            #MOD-D40035 add begin----------------------------
            IF g_aza.aza17 != g_omf_1.omf07 THEN
               IF NOT cl_null(g_omf_1.omf03) AND g_omf_1.omf03 != g_omf_1_t.omf03 THEN
                  IF cl_confirm('apm-701') THEN
                     CALL s_curr3(g_omf_1.omf07,g_omf_1.omf03,g_ooz.ooz17)
                           RETURNING g_omf_1.omf22
                     DISPLAY BY NAME g_omf_1.omf22
                  END IF
               END IF
            END IF            
            #MOD-D40035 add end------------------------------
         END IF 
      #MOD-CC0049 add end------------------------
         #str------ add by dengsy170410
      IF p_cmd = 'u' THEN 
      LET l_count1=0
      LET l_count2=0
      SELECT count(*) INTO l_count1 FROM oga_file,omf_file
      WHERE omf00=g_omf00_t AND oga01=omf11 AND omf10='1'
      AND (oga02>g_omf_1.omf03 )
      SELECT count(*) INTO l_count2 FROM oha_file,omf_file
      WHERE omf00=g_omf00_t AND oha01=omf11 AND omf10='2'
      AND (oha02>g_omf_1.omf03)
      IF l_count1>0 THEN 
         CALL cl_err('','cxm-123',0) 
         NEXT FIELD current
      END IF 
      IF l_count2>0 THEN 
         CALL cl_err('','cxm-124',0) 
          NEXT FIELD current
      END IF
      END IF 
      #end------ add by dengsy170410
        
      AFTER FIELD omf07
         IF NOT cl_null(g_omf_1.omf07) THEN
            SELECT azi04 INTO t_azi04 FROM azi_file
             WHERE azi01 = g_omf_1.omf07
            IF STATUS THEN
               CALL cl_err3("sel","azi_file",g_omf_1.omf07,"","aap-002","","",1)  
               NEXT FIELD omf07
            END IF  
            IF p_cmd='a' OR (p_cmd='u' AND
                            (g_omf_1.omf07 <> g_omf_1_t.omf07)  OR
                            (g_omf_1.omf03 <> g_omf_1_t.omf03)) THEN
               CALL s_curr3(g_omf_1.omf07,g_omf_1.omf03,g_ooz.ooz17)
                    RETURNING g_omf_1.omf22
               IF cl_null(g_omf_1.omf22) THEN
                  LET g_omf_1.omf22 = 0
               END IF
               DISPLAY g_omf_1.omf22 TO omf22
            END IF          
         END IF

      AFTER FIELD omf05
          IF NOT t670_chk_omf05(p_cmd) THEN  #FUN-C60036-minpp
              NEXT FIELD CURRENT             #FUN-C60036-minpp
           END IF                            #FUN-C60036-minpp
         #FUN-C60033--MARK--STR
        # IF (p_cmd = 'a') OR
        #   (p_cmd = 'u' AND g_omf_1_t.omf05 != g_omf_1.omf05) THEN
        #   IF NOT cl_null(g_omf_1.omf05)  THEN
        #      SELECT occ02 INTO g_omf_1.omf051 FROM occ_file  
        #       WHERE occ01 = g_omf_1.omf05                  
        #      IF STATUS THEN
        #         IF g_omf_1.omf05 != "*" THEN
        #            CALL cl_err3("sel","occ_file",g_omf_1.omf05,"",
        #                          "anm-045","","",1) 
        #            LET g_omf_1.omf05 = g_omf_1_t.omf05
        #            #NEXT FIELD poe01 #FUN-C60036 mark
        #            NEXT FIELD omf05
        #         END IF
        #      ELSE
        #         DISPLAY BY NAME g_omf_1.omf051
        #      END IF
        #   END IF
        #END IF
        #FUN-C60033--MARK--END
      AFTER FIELD omf06
         IF NOT cl_null(g_omf_1.omf06) THEN
            SELECT gec04 INTO g_omf_1.omf061
              FROM gec_file WHERE gec01 = g_omf_1.omf06 AND gec011='2' 
            IF STATUS THEN
               CALL cl_err3("sel","gec_file",g_omf_1.omf06,"","mfg3044","","",1) 
               NEXT FIELD omf06
            END IF
            DISPLAY BY NAME g_omf_1.omf061
         END IF

     #FUN-D50008---add--begin---
      AFTER FIELD omf31
         IF (p_cmd = 'a') OR
            (p_cmd = 'u' AND g_omf_1_t.omf31 != g_omf_1.omf31) THEN 
            IF (NOT cl_null(g_omf_1.omf31)) AND (NOT cl_null(g_omf_1.omf03)) THEN
               IF g_omf_1.omf31 < g_omf_1.omf03 THEN
                 # CALL cl_err(g_omf_1.omf31,'axm-392',0)  #不可小於錄入日期#MOD-D60160 mark
                 # NEXT FIELD omf31  #MOD-D60160 mark
               END IF
            END IF
         END IF
         #str------ add by dengsy170410
         IF p_cmd = 'u' THEN 
      LET l_count1=0
      LET l_count2=0
      SELECT count(*) INTO l_count1 FROM oga_file,omf_file
      WHERE omf00=g_omf00_t AND oga01=omf11 AND omf10='1'
      AND ( oga02>g_omf_1.omf31)
      SELECT count(*) INTO l_count2 FROM oha_file,omf_file
      WHERE omf00=g_omf00_t AND oha01=omf11 AND omf10='2'
      AND ( oha02>g_omf_1.omf31)
      IF l_count1>0 THEN 
         CALL cl_err('','cxm-123',0) 
         NEXT FIELD CURRENT 
      END IF 
      IF l_count2>0 THEN 
         CALL cl_err('','cxm-124',0) 
         NEXT FIELD CURRENT 
      END IF
      END IF 
      #end------ add by dengsy170410
     #FUN-D50008---add--end---

     #FUN-D50007---add--begin---
      AFTER FIELD omf32
         IF NOT cl_null(g_omf_1.omf32) THEN
            SELECT gen02,gen03 INTO l_gen02,g_omf_1.omf33
               FROM gen_file WHERE gen01 = g_omf_1.omf32 AND genacti = 'Y'
            IF STATUS THEN
               CALL cl_err(g_omf_1.omf32,'aap-038',0)
               LET g_omf_1.omf32 = g_omf_1_t.omf32
               NEXT FIELD omf32
            END IF
            SELECT gem02 INTO l_gem02 FROM gem_file
               WHERE gem01 = g_omf_1.omf33 AND gemacti = 'Y'
            DISPLAY BY NAME g_omf_1.omf32,g_omf_1.omf33
            DISPLAY l_gen02 TO FORMONLY.gen02
            DISPLAY l_gem02 TO FORMONLY.gem02
         END IF

      AFTER FIELD omf33
         IF NOT cl_null(g_omf_1.omf33) THEN
            SELECT gem02 INTO l_gem02 FROM gem_file
               WHERE gem01 = g_omf_1.omf33 AND gemacti = 'Y'
            IF STATUS THEN
               CALL cl_err(g_omf_1.omf33,'asf-624',0)
               LET g_omf_1.omf33 = g_omf_1_t.omf33
               NEXT FIELD omf33
            END IF
            DISPLAY BY NAME g_omf_1.omf32,g_omf_1.omf33
            DISPLAY l_gem02 TO FORMONLY.gem02
         END IF
     #FUN-D50007---add--end---

     #TQC-D60063--add--begin---
      AFTER INPUT
         IF NOT cl_null(g_omf_1.omf32) THEN
            SELECT gen02 INTO l_gen02
                FROM gen_file WHERE gen01 = g_omf_1.omf32 AND genacti = 'Y'
            IF STATUS THEN
               CALL cl_err(g_omf_1.omf32,'aap-038',0)
               NEXT FIELD omf32
            END IF 
         END IF

         IF NOT cl_null(g_omf_1.omf33) THEN
            SELECT gem02 INTO l_gem02 FROM gem_file
               WHERE gem01 = g_omf_1.omf33 AND gemacti = 'Y'
            IF STATUS THEN
               CALL cl_err(g_omf_1.omf33,'asf-624',0)
               NEXT FIELD omf33
            END IF 
         END IF
     #TQC-D60063--add--end--- 

      ON ACTION controlp
         CASE
          #FUN-C60033--ADD--STR
            WHEN INFIELD(omf00)
               LET g_t1=s_get_doc_no(g_omf_1.omf00)
               CALL q_oay( FALSE,FALSE, g_t1,'70','AXM')  RETURNING g_t1
               LET g_omf_1.omf00 = g_t1
               DISPLAY BY NAME g_omf_1.omf00
               NEXT FIELD omf00
           #FUN-C60033---ADD--END
            WHEN INFIELD(omf06)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gec"
               LET g_qryparam.arg1 ="2"
               LET g_qryparam.default1 = g_omf_1.omf06
               CALL cl_create_qry() RETURNING g_omf_1.omf06
               NEXT FIELD omf06
 
            WHEN INFIELD(omf07)               # CURRENCY
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azi"
               LET g_qryparam.default1 = g_omf_1.omf07
               CALL cl_create_qry() RETURNING g_omf_1.omf07
               DISPLAY BY NAME g_omf_1.omf07
 
            WHEN INFIELD (omf05)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_occ"
               LET g_qryparam.default1 = g_omf_1.omf05
               CALL cl_create_qry() RETURNING g_omf_1.omf05
               DISPLAY BY NAME g_omf_1.omf05
               NEXT FIELD omf05
          #FUN-D50007---add--begin---
            WHEN INFIELD (omf32)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_omf_1.omf32
               DISPLAY BY NAME g_omf_1.omf32
               NEXT FIELD omf32

            WHEN INFIELD (omf33)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gem"
               CALL cl_create_qry() RETURNING g_omf_1.omf33
               DISPLAY BY NAME g_omf_1.omf33
               NEXT FIELD omf33
          #FUN-D50007---add--end--- 
            OTHERWISE EXIT CASE
         END CASE
 
         
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 

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
 
END FUNCTION

FUNCTION t670_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_omf_1.omf01 TO NULL
    INITIALIZE g_omf_1.omf02 TO NULL
   MESSAGE ""
   CALL cl_opmsg('q')
 
   CALL t670_cs()                       #取得查詢條件
 
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_omf_1.omf01 TO NULL
      INITIALIZE g_omf_1.omf02 TO NULL
      RETURN
   END IF
 
   OPEN t670_b_curs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                         #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_omf_1.omf01 TO NULL
      INITIALIZE g_omf_1.omf02 TO NULL
   ELSE
      OPEN t670_count
      FETCH t670_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t670_fetch('F')            #讀出TEMP第一筆並顯示
      CALL t670_list_fill()   #No.FUN-D10091
      LET g_bp_flag = 'list'  #No.FUN-D10091
   END IF
 
END FUNCTION
 
FUNCTION t670_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-680136 VARCHAR(1)
 
   MESSAGE ""
   CASE p_flag
     #FUN-C60033---MOD--STR
     #  WHEN 'N' FETCH NEXT     t670_b_curs INTO g_omf_1.omf01,g_omf_1.omf02    
     #  WHEN 'P' FETCH PREVIOUS t670_b_curs INTO g_omf_1.omf01,g_omf_1.omf02    
     #  WHEN 'F' FETCH FIRST    t670_b_curs INTO g_omf_1.omf01,g_omf_1.omf02    
     #  WHEN 'L' FETCH LAST     t670_b_curs INTO g_omf_1.omf01,g_omf_1.omf02    
        WHEN 'N' FETCH NEXT     t670_b_curs INTO g_omf_1.omf00
        WHEN 'P' FETCH PREVIOUS t670_b_curs INTO g_omf_1.omf00
        WHEN 'F' FETCH FIRST    t670_b_curs INTO g_omf_1.omf00
        WHEN 'L' FETCH LAST     t670_b_curs INTO g_omf_1.omf00
        WHEN '/'
     #FUN-C60033---MOD--STR
       IF (NOT g_no_ask) THEN
           CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
           LET INT_FLAG = 0  ######add for prompt bug
         #FUN-D10091---mark---str 
         # PROMPT g_msg CLIPPED,': ' FOR g_jump
         #    ON IDLE g_idle_seconds
         #       CALL cl_on_idle()
 
         #    ON ACTION about        
         #       CALL cl_about()     
         #   
         #    ON ACTION help         
         #       CALL cl_show_help() 
         #   
         #    ON ACTION controlg     
         #       CALL cl_cmdask()    
         #   
         #   
         #  END PROMPT
         ##FUN-D10091---mark--end
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
        END IF
      # FETCH ABSOLUTE g_jump t670_b_curs INTO g_omf_1.omf01,g_omf_1.omf02  #FUN-C60033
        FETCH ABSOLUTE g_jump t670_b_curs INTO g_omf_1.omf00                #FUN-C60033
        LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_omf_1.omf01,SQLCA.sqlcode,0)
      INITIALIZE g_omf_1.* TO NULL
   ELSE
      
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )

      #SELECT UNIQUE omf00,omf01,omf02,omf03,omf04,omf05,omf051,omf06,omf061,omf07,omf08,omf22,omfpost, #FUN-C60033 ADD--omf00#FUN-C60036--mark
      SELECT UNIQUE omf00,omf01,omf02,omf03,omf05,omf051,omf06,omf061,omf07,omf08,omf22,
                    omf30,omf24,omfpost, #FUN-C60036 add  #NO.FUN-D10103 Add omf30
                    omf04,'','','', '','','',   #MOD-D10128 add 3个''
                    omf31,omf32,omf33,omfuser,omfgrup,omforiu,omforig,omfmodu,omfdate  #FUN-D50007 ADD
        INTO g_omf_1.*
        FROM omf_file
       WHERE omf00 = g_omf_1.omf00  #FUN-C60033
      
      SELECT SUM(omf19),SUM(omf19x),SUM(omf19t),SUM(omf29),SUM(omf29x),SUM(omf29t)
       INTO g_omf_1.omf19_sum,g_omf_1.omf19x_sum,g_omf_1.omf19t_sum,g_omf_1.omf29_sum,g_omf_1.omf29x_sum,g_omf_1.omf29t_sum
       FROM omf_file
      WHERE omf00 = g_omf_1.omf00   
      SELECT azi04 INTO t_azi04 FROM azi_file
             WHERE azi01 = g_omf_1.omf07
      CAll t670_upd_show_diff()  #MOD-D60161 add
      #FUN-C60036--add--str
      LET g_omf_1.omf19_sum = cl_digcut(g_omf_1.omf19_sum,g_azi04)
      LET g_omf_1.omf19x_sum = cl_digcut(g_omf_1.omf19x_sum,g_azi04)
      LET g_omf_1.omf19t_sum = cl_digcut(g_omf_1.omf19t_sum,g_azi04)
      LET g_omf_1.omf29_sum = cl_digcut(g_omf_1.omf29_sum,t_azi04)
      LET g_omf_1.omf29x_sum = cl_digcut(g_omf_1.omf29x_sum,t_azi04)
      LET g_omf_1.omf29t_sum = cl_digcut(g_omf_1.omf29t_sum,t_azi04)
      #FUN-C60036--add--end
      CALL t670_show()
   END IF
 
END FUNCTION
 
FUNCTION t670_show()
DEFINE l_gen02    LIKE gen_file.gen02   #FUN-D50007 add
DEFINE l_gem02    LIKE gem_file.gem02   #FUN-D50007 add

   #FUN-C60036--add--str
   SELECT DISTINCT omfpost,omf24,omf04 INTO g_omf_1.omfpost,g_omf_1.omf24,g_omf_1.omf04 FROM omf_file WHERE omf00 = g_omf_1.omf00#FUN-D20003 add omf04
   DISPLAY g_omf_1.omfpost TO omfpost
   DISPLAY g_omf_1.omf24 TO omf24
   #FUN-C60036--ad--end

   #str------ add by dengsy160518
   SELECT SUM(omf19),SUM(omf19x),SUM(omf19t),SUM(omf29),SUM(omf29x),SUM(omf29t)
       INTO g_omf_1.omf19_sum,g_omf_1.omf19x_sum,g_omf_1.omf19t_sum,g_omf_1.omf29_sum,g_omf_1.omf29x_sum,g_omf_1.omf29t_sum
       FROM omf_file
      WHERE omf00 = g_omf_1.omf00   #FUN-C60033
    DISPLAY BY NAME g_omf_1.omf19_sum,g_omf_1.omf19x_sum,g_omf_1.omf19t_sum,g_omf_1.omf29_sum,g_omf_1.omf29x_sum,g_omf_1.omf29t_sum
   #end------ add by dengsy160518
   #FUN-D50009---add---begin---
   SELECT omfuser,omfgrup,omforiu,omforig,omfmodu,omfdate
      INTO g_omf_1.omfuser,g_omf_1.omfgrup,g_omf_1.omforiu,g_omf_1.omforig,g_omf_1.omfmodu,g_omf_1.omfdate
   FROM omf_file WHERE omf00 = g_omf_1.omf00
   #FUN-D50009---add---end---

  #FUN-D50007---add--begin---
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_omf_1.omf32
   SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = g_omf_1.omf33
   DISPLAY l_gen02 TO FORMONLY.gen02
   DISPLAY l_gem02 TO FORMONLY.gem02
  #FUN-D50007---add--end---

   DISPLAY BY NAME g_omf_1.*
   IF cl_null(g_wc2) THEN LET g_wc2 = '1=1' END IF #FUN-C60036 add
   CALL t670_b_fill(g_wc2)                #單身
   CALL cl_show_fld_cont() 
#  CALL cl_set_field_pic(g_omf_1.omf08,"","","","","")       #TQC-D20009--xj-mark
   CALL t670_pic()    #TQC-D20009--xj--add
END FUNCTION


FUNCTION t670_u()
DEFINE  l_cnt   LIKE type_file.num5     #NO FUN-690009 SMALLINT
   IF s_shut(0) THEN RETURN END IF
   
   IF g_omf_1.omf01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL t670_fresh() #MOD-CC0230 add
   IF g_omf_1.omf08 = 'Y' THEN CALL cl_err('','axr-101',0) RETURN END IF #FUN-C60036 add
   IF g_omf_1.omf08 = 'X' THEN CALL cl_err('','alm-638',0) RETURN END IF #TQC-D20009--xj--add
  #FUN-C60036--mark--str--
  #SELECT COUNT(*) INTO l_cnt FROM ome_file
  # WHERE ome01 = g_omf_1.omf01
  #   AND ome60 IN (SELECT oma01 FROM oma_file) 
  #IF l_cnt > 0 THEN
  #   CALL cl_err('','apm-241',0)
  #   RETURN
  #END IF
  #FUN-C60036--mark--end
   MESSAGE ""
   CALL cl_opmsg('u')
 
   BEGIN WORK
 # OPEN t670_cl USING g_omf_1.omf01,g_omf_1.omf02    #FUN-C60033
   OPEN t670_cl USING g_omf_1.omf00                  #FUN-C60033
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_omf_1.omf01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t670_b_curs
      ROLLBACK WORK
      RETURN
   ELSE
    # FETCH t670_cl INTO g_omf_1.omf01,g_omf_1.omf02,g_omf_1.omf03,g_omf_1.omf05,g_omf_1.omf06,g_omf_1.omf07,g_omf_1.omf22   #FUN-C60033
     #FETCH t670_cl INTO g_omf_1.omf00,g_omf_1.omf01,g_omf_1.omf02,g_omf_1.omf03,g_omf_1.omf05,g_omf_1.omf06,g_omf_1.omf07,g_omf_1.omf22  #FUN-C60033 #No.FUN-D10103   Mark
     #No.FUN-D10103 ---start--- Add
      FETCH t670_cl INTO g_omf_1.omf00,g_omf_1.omf01,g_omf_1.omf02,
                         g_omf_1.omf03,g_omf_1.omf05,g_omf_1.omf06,
                         g_omf_1.omf07,g_omf_1.omf22,g_omf_1.omf30,
                         g_omf_1.omf31,g_omf_1.omf32,g_omf_1.omf33  #FUN-D50008 #FUN-D50007 add
     #No.FUN-D10103 ---end  --- Add
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_omf_1.omf01,SQLCA.sqlcode,0)  # 資料被他人LOCK
         CLOSE t670_cl ROLLBACK WORK RETURN
      END IF
   END IF
   LET g_omf_1_t.* = g_omf_1.* 
   CALL t670_show()
   WHILE TRUE
     #LET g_omf01_t = g_omf_1.omf01   #FUN-C60033
     #LET g_omf02_t = g_omf_1.omf02   #FUN-C60033
      LET g_omf00_t = g_omf_1.omf00   #FUN-C60033 
      CALL t670_i("u")                                  #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_omf_1.*=g_omf_1_t.*
         CALL t670_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      UPDATE omf_file SET omf_file.omf00 = g_omf_1.omf00,  #FUN-C60033
                          omf_file.omf01 = g_omf_1.omf01,
                          omf_file.omf02 = g_omf_1.omf02,
                          omf_file.omf03 = g_omf_1.omf03,
                          omf_file.omf30 = g_omf_1.omf30,  #No.FUN-D10103   Add
                          omf_file.omf22 = g_omf_1.omf22,
                          omf_file.omf31 = g_omf_1.omf31,  #FUN-D50008 add
                          omf_file.omf32 = g_omf_1.omf32,  #FUN-D50007 add
                          omf_file.omf33 = g_omf_1.omf33,  #FUN-D50007 add
                          omf_file.omfmodu = g_user       #FUN-D50009 add
                 #  WHERE omf_file.omf01 = g_omf01_t      #FUN-C60033
                 #    AND omf_file.omf01 = g_omf02_t      #FUN-C60033
                    WHERE omf_file.omf00 = g_omf00_t      #FUN-C60033 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","omf_file",g_omf01_t,"",SQLCA.sqlcode,"","",1) 
         CONTINUE WHILE
 #No.FUN-D10091--add-star--
       ELSE
          #MOD-D40035 add begin---------
          IF g_omf_1.omf22 <> g_omf_1_t.omf22 THEN 
             CALL t670_sum_upd()
             IF g_success = 'N' THEN 
                CALL cl_err3("upd","omf_file","t670_sum_upd","",SQLCA.sqlcode,"","",1) 
                CONTINUE WHILE
             ELSE 
                CALL t670_list_fill()
                COMMIT WORK                
             END IF     
          ELSE 
          ##MOD-D40035 add end------------                
             CALL t670_list_fill()
             COMMIT WORK
          END IF #MOD-D40035 add
 #No.FUN-D10091--add-end--
      END IF

      EXIT WHILE
   END WHILE
   CLOSE t670_cl
   COMMIT WORK
   CALL t670_fresh() #MOD-D40035 add
END FUNCTION

##MOD-D40035 add begin-------
FUNCTION t670_sum_upd()

DEFINE m_omf   RECORD LIKE  omf_file.*,
       l_sql   STRING

   LET l_sql =  " SELECT * FROM omf_file WHERE omf00 =  ","'",g_omf00_t,"'"," ORDER BY omf00,omf21"
   PREPARE t670_lc FROM l_sql
   DECLARE t670_cur CURSOR FOR t670_lc                                
   FOREACH t670_cur INTO m_omf.*
      IF STATUS THEN 
         CALL cl_err3("FOREACH","t670_cur",g_omf00_t,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N' 
         EXIT FOREACH   
      END IF
      LET m_omf.omf18 = m_omf.omf28 * g_omf_1.omf22
      LET m_omf.omf18 = cl_digcut(m_omf.omf18,g_azi03)     #本幣 #MOD-D60158 azi04---->azi03
      
      LET m_omf.omf19 = m_omf.omf29 * g_omf_1.omf22
      LET m_omf.omf19 = cl_digcut(m_omf.omf19,g_azi04)     #本幣
      
      LET m_omf.omf19t = m_omf.omf29t * g_omf_1.omf22
      LET m_omf.omf19t = cl_digcut(m_omf.omf19t,g_azi04)   #本幣
      
      LET m_omf.omf19x = m_omf.omf19t - m_omf.omf19
      LET m_omf.omf19x = cl_digcut(m_omf.omf19x,g_azi04)   #本幣 
      
      UPDATE omf_file SET  omf18 = m_omf.omf18,
                           omf19 = m_omf.omf19,
                           omf19t = m_omf.omf19t,
                           omf19x = m_omf.omf19x 
       WHERE omf_file.omf00 = g_omf00_t
         AND omf_file.omf21 = m_omf.omf21                              
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","omf_file",g_omf00_t,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF 
   END FOREACH       
END FUNCTION 
#MOD-D40035 add end------------

FUNCTION t670_r()
   IF s_shut(0) THEN
      RETURN
   END IF
  #IF g_omf_1.omf01 IS NULL THEN  #FUN-C60033
   IF g_omf_1.omf00 IS NULL THEN  #FUN-C60033
      CALL cl_err("",-400,0)  
      RETURN
   END IF

   CALL t670_fresh() #MOD-CC0230 add
   IF g_omf_1.omf08 = 'Y' THEN CALL cl_err('','axr-101',0) RETURN END IF#FUN-C60036 add
   IF g_omf_1.omf08 = 'X' THEN CALL cl_err('','alm-667',0) RETURN END IF#TQC-D20009--xj--add
   BEGIN WORK
  #OPEN t670_cl USING g_omf_1.omf01,g_omf_1.omf02   #FUN-C60033
   OPEN t670_cl USING g_omf_1.omf00                 #FUN-C60033 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_omf_1.omf01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   ELSE
    # FETCH t670_cl INTO g_omf_1.omf01,g_omf_1.omf02,g_omf_1.omf03,g_omf_1.omf05,g_omf_1.omf06,g_omf_1.omf07,g_omf_1.omf22                 #FUN-C60033
    # FETCH t670_cl INTO g_omf_1.omf00,g_omf_1.omf01,g_omf_1.omf02,g_omf_1.omf03,g_omf_1.omf05,g_omf_1.omf06,g_omf_1.omf07,g_omf_1.omf22   #FUN-C60033   #No.FUN-D10103   Mark
     #No.FUN-D10103 ---start-- Add
      FETCH t670_cl INTO g_omf_1.omf00,g_omf_1.omf01,g_omf_1.omf02,
                         g_omf_1.omf03,g_omf_1.omf05,g_omf_1.omf06,
                         g_omf_1.omf07,g_omf_1.omf22,g_omf_1.omf30,
                         g_omf_1.omf31,g_omf_1.omf32,g_omf_1.omf33  #FUN-D50008 #FUN-D50007 add
     #No.FUN-D10103 ---end  -- Add
      IF SQLCA.sqlcode THEN                                         #資料被他人LOCK
         CALL cl_err(g_omf_1.omf01,SQLCA.sqlcode,0) RETURN END IF
      END IF
      CALL t670_show()          
      IF cl_delh(15,21) THEN                #確認一下
       INITIALIZE g_doc.* TO NULL     
      #LET g_doc.column1 = "omf01"       #FUN-C60033
      #LET g_doc.value1 = g_omf_1.omf01  #FUN-C60033 
       LET g_doc.column1 = "omf00"       #FUN-C60033
       LET g_doc.value1 = g_omf_1.omf00  #FUN-C60033
       CALL cl_del_doc()       
     # DELETE FROM omf_file WHERE omf01 = g_omf_1.omf01 AND omf02 = g_omf_1.omf02   #FUN-C60033
       DELETE FROM omf_file WHERE omf00 = g_omf_1.omf00                             #FUN-C60033

       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","omf_file","","",SQLCA.sqlcode,"","BODY DELETE:",1)
          ROLLBACK WORK RETURN
       END IF
       #FUN-C60036-ad--str
       IF g_sma.sma115 = 'Y' THEN 
          DELETE FROM ogg_file 
           WHERE ogg01 = g_omf_1.omf00 
          DELETE FROM ogc_file 
           WHERE ogc01 = g_omf_1.omf00
       ELSE 
          DELETE FROM ogc_file 
           WHERE ogc01 = g_omf_1.omf00 
       END IF
       #FUN-C60036--add--end
  
       CLEAR FORM                                                  #刪除后要將畫面上數據清空
       CALL t670_list_fill()   #No.FUN-D10091--add--
       CALL g_omf.clear()
       MESSAGE ""
       OPEN t670_count #MOD-D60152 add
       FETCH t670_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t670_cl
          CLOSE t670_count
          COMMIT WORK
          RETURN
       END IF
    
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t670_b_curs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t670_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
           #tianry add 
           INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
           VALUES ('axmt670',g_user,g_today,g_msg,g_omf_1.omf00,'delete',g_plant,g_legal)	
           #tianry add end 
          CALL t670_fetch('/')
       END IF
    END IF
   CLOSE t670_cl
   COMMIT WORK
   #tianry add 161118tianry
   # INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
   #        VALUES ('axmt670',g_user,g_today,g_msg,g_omf_1_t.omf00,'delete',g_plant,g_legal)
   #tianry add end 
END FUNCTION

#No.FUN-D10091--add--star--
FUNCTION t670_list_fill()
  DEFINE l_omf00         LIKE omf_file.omf00
  DEFINE l_omf21         LIKE omf_file.omf21
  DEFINE l_i             LIKE type_file.num10
  DEFINE l_sql           STRING
  DEFINE m               LIKE type_file.num5
  DEFINE l_omf00_t       LIKE omf_file.omf00

    CALL g_omf_l.clear()
    LET l_i = 1

    LET l_sql = "SELECT omf00,omf21 FROM omf_file",
                " WHERE ",g_wc CLIPPED,
                "   AND ",g_wc2 CLIPPED,
                " ORDER BY omf00,omf21"
    PREPARE t670_bcl1 FROM l_sql      # LOCK CURSOR
    DECLARE t670_cs1 CURSOR FOR t670_bcl1

    LET m = 1
    FOREACH t670_cs1 INTO l_omf00,l_omf21
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       IF NOT cl_null(l_omf00_t) AND l_omf00_t != l_omf00 THEN
          LET m = m + 1
          LET l_omf00_t = l_omf00
       ELSE
          LET l_omf00_t = l_omf00
       END IF
       SELECT '',omf00,omf03,omf01,omf02,omf05,omf051,omf06,omf07,omf22,omf10,omf11,omf12,omf13,omf14,omf15,omf16,omf17,
              omf29,omf19,omf04

         INTO g_omf_l[l_i].*
         FROM omf_file
        WHERE omf00=l_omf00
          AND omf21=l_omf21
        #str----- add by dengsy160527
             LET g_omf_l[l_i].ogb11=NULL 
             SELECT ogb11 INTO g_omf_l[l_i].ogb11 FROM ogb_file 
             WHERE ogb01=g_omf_l[l_i].omf11 AND ogb03=g_omf_l[l_i].omf12
             IF cl_null(g_omf_l[l_i].ogb11) THEN 
                SELECT ohb11 INTO g_omf_l[l_i].ogb11 FROM ohb_file 
                WHERE ohb01=g_omf_l[l_i].omf11 AND ohb03=g_omf_l[l_i].omf12
             END IF  
          #end----- add by dengsy160527

        
       LET g_omf_l[l_i].m = m
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN   #CHI-BB0034 add
            CALL cl_err( '', 9035, 0 )
          END IF                              #CHI-BB0034 add
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b1 = l_i - 1
    DISPLAY ARRAY g_omf_l TO s_omf_l.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY

END FUNCTION

FUNCTION t670_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
   DEFINE   l_n    LIKE type_file.num5


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_oaz.oaz93 = 'N' THEN
      CALL cl_set_act_visible("deduct_inventory,undo_deduct", FALSE)
   END IF
 # DISPLAY ARRAY g_omf_ TO s_omf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
   DISPLAY ARRAY g_omf_l TO s_omf_l.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)

  BEFORE DISPLAY
     CALL cl_navigator_setting( g_curs_index, g_row_count )
         FOR l_n=1 TO 5000
             IF g_curs_index = g_omf_l[l_n].m THEN
                LET g_curs_index = l_n
                EXIT FOR
             ELSE
                CONTINUE FOR
             END IF
         END FOR
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF

      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         IF  l_ac1 <> l_n THEN
         LET g_curs_index = g_omf_l[l_ac1].m
         END  IF
         CALL cl_show_fld_cont()

      ON ACTION Page1
         LET g_action_flag = "Page1"
         LET l_ac1 = ARR_CURR()
         LET g_jump = g_omf_l[l_ac1].m
         IF g_rec_b1 >0 THEN
            CALL t670_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page2", FALSE)
         CALL cl_set_comp_visible("info", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page2", TRUE)
         CALL cl_set_comp_visible("info", TRUE)
         EXIT DISPLAY

      ON ACTION ACCEPT
         LET g_action_flag = "Page1"
         LET l_ac1 = ARR_CURR()
         LET g_jump =g_omf_l[l_ac1].m
         CALL t670_fetch('/')
         CALL cl_set_comp_visible("info", FALSE)
         CALL cl_set_comp_visible("info", TRUE)
         CALL cl_set_comp_visible("Page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page2", TRUE)
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
  ON ACTION first
     CALL t670_fetch('F')
     CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
     IF g_rec_b1 != 0 THEN
        CALL fgl_set_arr_curr(g_curs_index)
     END IF
     ACCEPT DISPLAY


  ON ACTION previous
     CALL t670_fetch('P')
     CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
     IF g_rec_b1 != 0 THEN
        CALL fgl_set_arr_curr(g_curs_index)
     END IF
     ACCEPT DISPLAY


  ON ACTION jump
     CALL t670_fetch('/')
     CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
     IF g_rec_b1 != 0 THEN
        CALL fgl_set_arr_curr(g_curs_index)
     END IF
     ACCEPT DISPLAY


  ON ACTION next
     CALL t670_fetch('N')
     CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
     IF g_rec_b1 != 0 THEN
        CALL fgl_set_arr_curr(g_curs_index)
     END IF
     ACCEPT DISPLAY


  ON ACTION last
     CALL t670_fetch('L')
     CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
     IF g_rec_b1 != 0 THEN
        CALL fgl_set_arr_curr(g_curs_index)
     END IF
     ACCEPT DISPLAY

  ON ACTION issue_invoice
     LET g_action_choice="issue_invoice"
     EXIT DISPLAY

 #FUN-C60036--07/06--str
  ON ACTION maintain_invoice
     LET g_action_choice="maintain_invoice"
     EXIT DISPLAY
 #FUN-C60036--07/06--end
 #add by ly 20170222--s
   ON ACTION unit_price
     LET g_action_choice="unit_price"
     EXIT DISPLAY
 #add by ly 20170222--e
  ON ACTION modify
     LET g_action_choice="modify"
     EXIT DISPLAY
  ON ACTION detail
     LET g_action_choice="detail"
     LET l_ac = 1
     EXIT DISPLAY

  ON ACTION confirm
     LET g_action_choice="confirm"
     EXIT DISPLAY
  ON ACTION undo_confirm
     LET g_action_choice="undo_confirm"
     EXIT DISPLAY

# ON ACTION S.庫存扣帳
  ON ACTION deduct_inventory
     LET g_action_choice="deduct_inventory"
     EXIT DISPLAY

# ON ACTION Z.扣帳還原
  ON ACTION undo_deduct
     LET g_action_choice="undo_deduct"
     EXIT DISPLAY

  #FUN-C60036--add--str
  ON ACTION spin_fin
     LET g_action_choice = "spin_fin"
     EXIT DISPLAY

  ON ACTION a_r
     LET g_action_choice="a_r"
     EXIT DISPLAy

  ON ACTION qry_mntn_inv_detail
     LET g_action_choice="qry_mntn_inv_detail"
     EXIT DISPLAY
  #FUN-C60036--add--end
  #tianry add 161110
   ON ACTION t670_sum_omf
    LET g_action_choice="t670_sum_omf"
     EXIT DISPLAY
  
  #tianry add end 

  ON ACTION help
     LET g_action_choice="help"
     EXIT DISPLAY

  #FUN-CB0040---add---str
  ON ACTION output
     LET g_action_choice="output"
         EXIT DISPLAY
  #FUN-CB0040--add--end

  ON ACTION locale
     CALL cl_dynamic_locale()
     CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    #FUN-C60033--add--str
      IF g_sma.sma122 ='1' THEN
         CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("omf913",g_msg CLIPPED)
         CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("omf915",g_msg CLIPPED)
         CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("omf910",g_msg CLIPPED)
         CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("omf912",g_msg CLIPPED)
      END IF

      IF g_sma.sma122 ='2' THEN
         CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("omf913",g_msg CLIPPED)
         CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("omf915",g_msg CLIPPED)
         CALL cl_getmsg('axm-567',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("omf910",g_msg CLIPPED)
         CALL cl_getmsg('axm-568',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("omf912",g_msg CLIPPED)
      END IF
     #FUN-C60033--add-end

  ON ACTION exit
     LET g_action_choice="exit"
     EXIT DISPLAY

  ##########################################################################
  # Special 4ad ACTION
  ##########################################################################
  ON ACTION controlg
     LET g_action_choice="controlg"
     EXIT DISPLAY


  ON ACTION cancel
     LET INT_FLAG=FALSE                 #MOD-570244     mars
     LET g_action_choice="exit"
     EXIT DISPLAY

  ON IDLE g_idle_seconds
     CALL cl_on_idle()
     CONTINUE DISPLAY

  ON ACTION about         #MOD-4C0121
     CALL cl_about()      #MOD-4C0121


  ON ACTION exporttoexcel       #FUN-4B0025
     LET g_action_choice = 'exporttoexcel'
     EXIT DISPLAY

  AFTER DISPLAY
     CONTINUE DISPLAY

  ON ACTION controls                           #No.FUN-6B0032
     CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032

  ON ACTION related_document                #No.FUN-6A0162  相關文件
     LET g_action_choice="related_document"
     EXIT DISPLAY


   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION
#No.FUN-D10091--add--end---
 
#單身
FUNCTION t670_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     
    l_n             LIKE type_file.num5,     
    l_n1            LIKE type_file.num5,     
    l_omf11         LIKE omf_file.omf11,     
    l_cnt           LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,     
    p_cmd           LIKE type_file.chr1,     
    l_cmd           LIKE type_file.chr1000,  
    l_omf     RECORD LIKE omf_file.*,
    l_ogb12         LIKE ogb_file.ogb12,
    l_allow_insert  LIKE type_file.num5,     
    l_allow_delete  LIKE type_file.num5,
    l_omf16         LIKE omf_file.omf16   #FUN-C60036
    DEFINE l_omf19s LIKE omf_file.omf19,#FUN-C60036
           l_omf19z LIKE omf_file.omf19#FUN-C60036
    DEFINE li_cnt   LIKE type_file.num5 #FUN-C60036 add
    DEFINE l_oha09  LIKE oha_file.oha09 #MOD-CA0092 add
    #FUN-C60036-add--str
    DEFINE temp_omf13 STRING
    DEFINE bst base.StringTokenizer
    DEFINE temptext STRING
    DEFINE l_errno LIKE type_file.num10
    #FUN-C60036--add--end
    DEFINE l_slip   LIKE oay_file.oayslip #MOD-CB0040 add
    DEFINE l_oay13  LIKE oay_file.oay13   #MOD-CB0040 add
    DEFINE l_oay14  LIKE oay_file.oay14   #MOD-CB0040 add     
    DEFINE l_cnt1   LIKE type_file.num5   #No.MOD-CC0087
    DEFINE l_sum    LIKE omf_file.omf19t  #No.MOD-CC0087
    DEFINE l_sql    STRING                #yinhy130510
    DEFINE l_oga02,l_oha02 LIKE oga_file.oga02  #MOD-D60035
    DEFINE li_result   LIKE type_file.chr1    #TQC-D40067 add
    DEFINE l_flag  LIKE type_file.chr1 #MOD-DC0091
    
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
   #IF g_omf_1.omf01 IS NULL THEN
    IF cl_null(g_omf_1.omf00) THEN #FUN-C60033 add by xuxz  
       RETURN
    END IF
     SELECT azi04 INTO t_azi04 FROM azi_file#FUN-C60036 add
             WHERE azi01 = g_omf_1.omf07 #FUN-C60036 add
    CALL t670_fresh() #MOD-CC0230 add         
    IF g_omf_1.omf08 = 'Y' THEN CALL cl_err('','axr-101',0) RETURN END IF
    IF g_omf_1.omf08 = 'X' THEN CALL cl_err('','alm-148',0) RETURN END IF #TQC-D20009--xj--add
    SELECT oaz93,oaz95 INTO g_oaz.oaz93,g_oaz.oaz95 FROM oaz_file	
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT omf21,omf09,omf10,omf11,omf12,'','',omf25,omf26,omf13,omf14,",#add by huanglf170314 #FUN-D10082 add omf25,omf26  #add '' by dengsy160527
                       "       omf15,omf23,omf20,omf201,omf202,omf16,omf17,",
                       "       omf913,omf914,omf915,omf910,omf911,omf912,omf916,omf917, ",#FUN-C60036 add
                       "       '',omf28,omf29,omf29x,omf29t,",
                      #"       omf18,omf19,omf19x,omf19t,omf04 FROM omf_file",#FUN-C60036 add omf04#FUN-D20003 mark
                       "       omf18,omf19,omf19x,omf19t FROM omf_file",#FUN-D20003 add
              #        "  WHERE omf01=? AND omf02=? AND omf21=? FOR UPDATE "    #FUN-C60033
                       "  WHERE omf00=? AND omf21=? FOR UPDATE "                #FUN-C60033
                       
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t670_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    #add by ly 20170222--s
    IF g_change1 = 'Y' THEN 
        LET l_allow_insert = FALSE 
        LET l_allow_delete = FALSE 
    END IF 
    #add by ly 20170222--e
    #CALL cl_set_comp_entry('omf18',FALSE)  #TQC-D20009 mark
    CALL cl_set_comp_entry("omf20,omf201",FALSE)
    INPUT ARRAY g_omf WITHOUT DEFAULTS FROM s_omf.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF

        #FUN-C60036--add--str
      # AFTER INPUT
      #    IF (g_omf[l_ac].omf19 + g_omf[l_ac].omf19x <> g_omf[l_ac].omf19t) OR
      #       (g_omf[l_ac].omf29 + g_omf[l_ac].omf29x <> g_omf[l_ac].omf29t) THEN 
      #       IF NOT cl_confirm('axr-181') THEN 
      #          NEXT FIELD omf19
      #       END IF
      #    END IF  
      # #FUN-C60036--ad--end

        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           LET g_success = 'Y'  
           BEGIN WORK #FUN-C60033 add 
           #MOD-D50076 add begin----------------------------
           SELECT COUNT(*) INTO l_cnt FROM omf_file WHERE omf00 = g_omf_1.omf00
           IF l_cnt > 0 THEN 
              OPEN t670_cl USING g_omf_1.omf00    
              IF STATUS THEN
                 CALL cl_err("OPEN t670_cl:", STATUS, 1)
                 CLOSE t670_cl
                 ROLLBACK WORK
                 RETURN
              END IF

              FETCH t670_cl INTO g_omf_1.omf00,g_omf_1.omf01,g_omf_1.omf02,
                                 g_omf_1.omf03,g_omf_1.omf05,g_omf_1.omf06,
                                 g_omf_1.omf07,g_omf_1.omf22,g_omf_1.omf30  # 鎖住將被更改或取消的資料
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_omf_1.omf00,SQLCA.sqlcode,0)     # 資料被他人LOCK
                 CLOSE t670_cl
                 ROLLBACK WORK
                 RETURN
              END IF
           END IF 
           #MOD-D50076 add  end ----------------------------
           IF g_rec_b >= l_ac THEN
             #BEGIN WORK
              LET p_cmd='u'
              LET g_omf_t.* = g_omf[l_ac].*  #BACKUP
           #  OPEN t670_bcl USING g_omf_1.omf01,g_omf_1.omf02,g_omf_t.omf21     #FUN-C60033
              OPEN t670_bcl USING g_omf_1.omf00,g_omf_t.omf21                   #FUN-C60033
              IF STATUS THEN
                 CALL cl_err("OPEN t670_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
                 RETURN #MOD-D10266 add
              ELSE
                 FETCH t670_bcl INTO g_omf[l_ac].*
                 LET g_plant_new = g_omf[l_ac].omf09
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_omf_1_t.omf02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 ELSE
                 	  IF g_omf[l_ac].omf10 = '1' THEN
                       LET g_sql = "SELECT ogb14,ogb11 ",  #add ogb11 by dengsy160527
                                  "  FROM ",cl_get_target_table(g_plant_new,'ogb_file'),
                                  " WHERE ogb01 = '",g_omf[l_ac].omf11,"' ",
                                  "   AND ogb03 = '",g_omf[l_ac].omf12,"' "    
                     ELSE
 	                      LET g_sql = "SELECT ohb14,ohb11 ",  #add ohb11 by dengsy160527
                                   "  FROM ",cl_get_target_table(g_plant_new,'ohb_file'),
                                    " WHERE ohb01 = '",g_omf[l_ac].omf11,"' ",
                                   "   AND ohb03 = '",g_omf[l_ac].omf12,"' "
                     
                     END IF 

                       
                     CALL cl_replace_sqldb(g_sql) RETURNING g_sql    	
	                   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql        
                     PREPARE sel_ogb14_pre FROM g_sql
                     EXECUTE sel_ogb14_pre INTO g_omf[l_ac].ogb14,g_omf[l_ac].ogb11 #add g_omf[l_ac].ogb11 by dengsy160527
               #     DISPLAY BY NAME g_omf[l_ac].ogb14
                    #CALL t670_set_entry(p_cmd)     #FUN-C60036 mark

             #str-----add by huanglf170313
                    SELECT oga011 INTO g_omf[l_ac].oga011 FROM oga_file
                    WHERE oga01 = g_omf[l_ac].omf11
             #str-----end by huanglf170313
                     CALL t670_set_no_entry(p_cmd)  
                 END IF
                 #MOD-CA0092--add--str
                 IF g_omf[l_ac].omf10 = '2' THEN 
                    LET l_oha09 = ''
                    LET g_sql = " SELECT oha09 FROM ",cl_get_target_table(g_plant_new,'oha_file'),
                                 "  WHERE oha01 = '",g_omf[l_ac].omf11,"'"
                    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
                    PREPARE sel_oha09_pre_1 FROM g_sql
                    EXECUTE sel_oha09_pre_1 INTO l_oha09
                    CALL cl_set_comp_entry('omf16,omf912,omf915,omf917',l_oha09 != '5') 
                 END IF 
                 #MOD-CA0092--add--end
                 CALL t670_set_entry_b('u')    #TQC-D20009 add
                 CALL t670_set_no_entry_b('u') #TQC-D20009 add
              END IF
              CALL cl_show_fld_cont() 
          #ELSE
          #LET p_cmd = 'a'
          #LET g_omf[l_ac].omf09 = g_plant
          #IF g_oaz.oaz93 = 'Y' THEN
          #   LET g_omf[l_ac].omf20 = g_oaz.oaz95
          #   LET g_omf[l_ac].omf201 = g_omf_1.omf05
          #END IF
          #LET g_omf[l_ac].omf10 = 1 #FUN-C60036 add
          #LET g_omf[l_ac].omf16 = 0
          #LET g_omf[l_ac].omf18 = 0           
          #LET g_omf[l_ac].omf19 = 0
          #LET g_omf[l_ac].omf19x = 0
          #LET g_omf[l_ac].omf19t = 0
          #LET g_omf[l_ac].omf28 = 0
          #LET g_omf[l_ac].omf29 = 0
          #LET g_omf[l_ac].omf29x = 0
          #LET g_omf[l_ac].omf29t = 0
          #LET g_omf[l_ac].omf23 = 'N'
          #IF g_omf[l_ac].omf21 IS NULL OR g_omf[l_ac].omf21 = 0 THEN
          #   SELECT max(omf21)+1
          #     INTO g_omf[l_ac].omf21
          #     FROM omf_file
          #     WHERE omf00 = g_omf_1.omf00 
          #   IF g_omf[l_ac].omf21 IS NULL THEN
          #      LET g_omf[l_ac].omf21 = 1
          #   END IF
          #END IF
           END IF
          #DISPLAY BY NAME g_omf[l_ac].*
           LET g_omf_t.* = g_omf[l_ac].* #FUN-C60036 add
      
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'           
           INITIALIZE g_omf[l_ac].* TO NULL  
           LET g_omf[l_ac].omf09 = g_plant
           IF g_oaz.oaz93 = 'Y' THEN
              LET g_omf[l_ac].omf20 = g_oaz.oaz95
              LET g_omf[l_ac].omf201 = g_omf_1.omf05
           END IF
           LET g_omf[l_ac].omf10 = 1 #FUN-C60036 add
           LET g_omf[l_ac].omf16 = 0
           LET g_omf[l_ac].omf18 = 0           
           LET g_omf[l_ac].omf19 = 0
           LET g_omf[l_ac].omf19x = 0
           LET g_omf[l_ac].omf19t = 0
           LET g_omf[l_ac].omf28 = 0
           LET g_omf[l_ac].omf29 = 0
           LET g_omf[l_ac].omf29x = 0
           LET g_omf[l_ac].omf29t = 0
           LET g_omf[l_ac].omf23 = 'N' #FUN-C60036 add
           LET g_omf_1_t.* = g_omf_1.*
           LET g_omf_t.* = g_omf[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()   
          #CALL t670_set_entry(p_cmd)  #FUN-C60036 mark
           NEXT FIELD omf21 #FUN-C60036 add
  
  
       BEFORE FIELD omf21                        #default 序號
           IF g_omf[l_ac].omf21 IS NULL OR g_omf[l_ac].omf21 = 0 THEN
              SELECT max(omf21)+1
                INTO g_omf[l_ac].omf21
                FROM omf_file
              # WHERE omf01 = g_omf_1.omf01     #FUN-C60033
              #   AND omf02 = g_omf_1.omf02     #FUN-C60033
                WHERE omf00 = g_omf_1.omf00     #FUN-C60033
              IF g_omf[l_ac].omf21 IS NULL THEN
                 LET g_omf[l_ac].omf21 = 1
              END IF
           END IF

        AFTER FIELD omf21                        #check 序號是否重複
           IF NOT cl_null(g_omf[l_ac].omf21) THEN
              IF g_omf[l_ac].omf21 != g_omf_t.omf21
                 OR g_omf_t.omf21 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM omf_file
               #  WHERE omf01 = g_omf_1.omf01     #FUN-C60033
               #    AND omf02 = g_omf_1.omf02     #FUN-C60033
                  WHERE omf00 = g_omf_1.omf00     #FUN-C60033
                    AND omf21 = g_omf[l_ac].omf21
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_omf[l_ac].omf21 = g_omf_t.omf21
                    NEXT FIELD omf21
                 END IF
              END IF
         #FUN-D20009--cj--add--
              IF g_omf[l_ac].omf21 <= 0 THEN
                 CALL cl_err('','aec-994',1)
                 LET g_omf[l_ac].omf21 = g_omf_t.omf21
                 NEXT FIELD omf21
              END IF
         #FUN-D20009--cj--add--
           END IF
         AFTER FIELD omf09
           IF NOT cl_null(g_omf[l_ac].omf09) THEN
              CALL t670_omf09()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_omf[l_ac].omf09,g_errno,1)
                 NEXT FIELD omf09
              END IF
          #    LET g_omf[l_ac].omf19 = g_omf[l_ac].omf29 * g_omf_1.omf22
          #    LET g_omf[l_ac].omf19t = g_omf[l_ac].omf29t * g_omf_1.omf22
          #    LET g_omf[l_ac].omf19x = g_omf[l_ac].omf19t - g_omf[l_ac].omf19
          #    LET g_omf[l_ac].omf19 = cl_digcut(g_omf[l_ac].omf19,g_azi04)     #本幣
          #    LET g_omf[l_ac].omf19x = cl_digcut(g_omf[l_ac].omf19x,g_azi04)   #本幣
          #    LET g_omf[l_ac].omf19t = cl_digcut(g_omf[l_ac].omf19t,g_azi04)   #本幣
           ELSE
              CALL cl_err('','alm-809',0)
              NEXT FIELD omf09
           END IF  
         #FUN-C60033--add--str--by xuxz
         AFTER FIELD omf10
            IF NOT cl_null(g_omf[l_ac].omf10) THEN
               IF g_omf[l_ac].omf10 = '9' THEN 
                  #CALL cl_set_comp_entry('omf11,omf12,omf20,omf201,omf202,omf23',FALSE)  #TQC-D20009 mark
                  LET g_omf[l_ac].omf23 = 'N'
                  LET g_omf[l_ac].omf11 = ' '
                  LET g_omf[l_ac].omf20 = ' '
                  LET g_omf[l_ac].omf201 = ' '
                 #LET g_omf[l_ac].omf12 = ' ' #TQC-D20009 xj#TQC-d20046 mark
               #TQC-D20009--mark--str--
               #   CALL cl_set_comp_entry('omf13,omf14,omf15,omf17',TRUE)  
               #ELSE
               #  # CALL cl_set_comp_entry('omf11,omf12,omf202',TRUE)        #TQC-D20046---mark---
               #   CALL cl_set_comp_entry('omf11,omf12',TRUE)        #TQC-D20046---add---
               #   CALL cl_set_comp_entry('omf13,omf14,omf15.omf17',FALSE) 
               #TQC-D20009--mark--end--
               END IF 
               CALL t670_set_entry_b('u')    #TQC-D20009 add
               CALL t670_set_no_entry_b('u') #TQC-D20009 add
            END IF 
         #FUN-C60033--add--end -- by xuxz
         AFTER FIELD omf11
            #IF  cl_null(g_omf[l_ac].omf11) THEN
            #   LET g_omf[l_ac].omf11 = g_omf_t.omf11
            #   NEXT FIELD omf11
            #END IF
            IF NOT cl_null(g_omf[l_ac].omf11) THEN
               IF p_cmd = 'a' OR
                  (g_omf_t.omf11 != g_omf[l_ac].omf11) THEN
                  CALL t670_omf11()
                  IF NOT cl_null(g_errno) THEN
                     IF NOT cl_null(g_omf_t.omf11) THEN
                        LET g_omf[l_ac].omf11 = g_omf_t.omf11
                     END IF
                     CALL cl_err(g_omf[l_ac].omf11,g_errno,0) 
                     NEXT FIELD omf11
                  END IF
               END IF
               #MOD-D60035 add begin----------------
                IF g_omf[l_ac].omf10 = '2' THEN 
                    LET g_sql = " SELECT oha02 FROM ",cl_get_target_table(g_plant_new,'oha_file'), 
                                "  WHERE oha01 = '",g_omf[l_ac].omf11,"'"
                    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
                    PREPARE sel_oha02_pre_2 FROM g_sql
                    EXECUTE sel_oha02_pre_2 INTO l_oha02
                    IF l_oha02 > g_omf_1.omf03 THEN 
                       CALL cl_err(l_oha02,'axm-772',1)
                       NEXT FIELD omf11
                    END IF    
                END IF     
                IF g_omf[l_ac].omf10 = '1' THEN 
                    LET g_sql = " SELECT oga02 FROM ",cl_get_target_table(g_plant_new,'oga_file'), 
                                "  WHERE oga01 = '",g_omf[l_ac].omf11,"'"
                    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
                    PREPARE sel_oga02_pre_2 FROM g_sql
                    EXECUTE sel_oga02_pre_2 INTO l_oga02
                    IF l_oga02 > g_omf_1.omf03 THEN 
                       CALL cl_err(l_oga02,'axm-772',1)
                       NEXT FIELD omf11
                    END IF                  
                END IF                     
               #MOD-D60035 add end------------------                
            END IF
            #MOD-CA0092--add--str
             IF g_omf[l_ac].omf10 = '2' THEN 
                 LET l_oha09 = ''
                 LET g_sql = " SELECT oha09 FROM ",cl_get_target_table(g_plant_new,'oha_file'),
                             "  WHERE oha01 = '",g_omf[l_ac].omf11,"'"
                 CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                 CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
                 PREPARE sel_oha09_pre_2 FROM g_sql
                 EXECUTE sel_oha09_pre_2 INTO l_oha09
                 CALL cl_set_comp_entry('omf16,omf912,omf915,omf917',l_oha09 != '5')
             END IF 
            #MOD-CA0092--add--end
            #MOD-DC0091 add begin------------------------------------------------------
            IF NOT cl_null(g_omf[l_ac].omf11) AND NOT cl_null(g_omf[l_ac].omf12) THEN 
               IF (g_omf[l_ac].omf11 <> g_omf_t.omf11) OR  cl_null(g_omf_t.omf11) THEN 
                  CALL t670_jce_chk() RETURNING l_flag
                  IF l_flag = 'N' THEN 
                     CALL cl_err(g_omf[l_ac].omf11,'axm-884',1)
                     NEXT FIELD omf11
                  END IF    
               END IF    
            END IF    
            #MOD-DC0091 add end------------------------------------------------------

            #str---add by huanglf170313
            IF NOT cl_null(g_omf[l_ac].omf11) THEN
               SELECT oga011 INTO g_omf[l_ac].oga011 FROM oga_file WHERE oga01 = g_omf[l_ac].omf11
               DISPLAY BY NAME g_omf[l_ac].oga011
            END IF
            #str---end by huanglf170313
        
         AFTER FIELD omf12
            #MOD-DC0091 add begin------------------------------------------------------
            IF NOT cl_null(g_omf[l_ac].omf11) AND NOT cl_null(g_omf[l_ac].omf12) THEN 
               IF (g_omf[l_ac].omf12 <> g_omf_t.omf12) OR cl_null(g_omf_t.omf12) THEN 
                  CALL t670_jce_chk() RETURNING l_flag
                  IF l_flag = 'N' THEN 
                     CALL cl_err(g_omf[l_ac].omf11,'axm-884',1)
                     NEXT FIELD omf12
                  END IF    
               END IF    
            END IF    
            #MOD-DC0091 add end------------------------------------------------------         
            IF NOT cl_null(g_omf[l_ac].omf12) THEN
              IF (p_cmd = 'a') OR
                 (p_cmd = 'u' AND (g_omf_t.omf12 != g_omf[l_ac].omf12 OR g_omf_t.omf11 != g_omf[l_ac].omf11)) THEN
                 
                 CALL t670_omf12()
                 
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_omf[l_ac].omf12,g_errno,0)
                    NEXT FIELD omf12
                 ELSE 
                    IF g_sma.sma115 = 'Y' THEN 
                       CALL t670_b_ogg()
                    ELSE 
                       CALL t670_b_ogc()
                    END IF 
                 END IF      
              END IF  
              #FUN-D10082--add--str--
              IF g_omf[l_ac].omf10 = '9'  THEN
                 CALL cl_set_comp_entry('omf25,omf26',TRUE) 
              ELSE
                 CALL cl_set_comp_entry('omf25,omf26',FALSE)
                 IF g_omf[l_ac].omf10 = '1' THEN 
                    SELECT ogb31,ogb32 INTO g_omf[l_ac].omf25,g_omf[l_ac].omf26
                      FROM ogb_file 
                     WHERE ogb01 = g_omf[l_ac].omf11
                       AND ogb03 = g_omf[l_ac].omf12
                 END IF 
                 IF g_omf[l_ac].omf10 = '2' THEN 
                    SELECT ohb33,ohb34 INTO g_omf[l_ac].omf25,g_omf[l_ac].omf26
                      FROM ohb_file 
                     WHERE ohb01 = g_omf[l_ac].omf11
                       AND ohb03 = g_omf[l_ac].omf12
                 END IF
              END IF   
              #FUN-D10082--add--end--        
           END IF

           #FUN-D10082--add--str--
        AFTER FIELD omf25
           IF NOT cl_null(g_omf[l_ac].omf26) THEN
              IF p_cmd = 'a' OR
                  (g_omf_t.omf25 != g_omf[l_ac].omf25) THEN
                 LET l_n = 0 
                 SELECT COUNT(*) INTO l_n FROM oeb_file
                  WHERE oeb01 = g_omf[l_ac].omf25
                    AND oeb03 = g_omf[l_ac].omf26
                 IF l_n = 0 THEN
                    CALL cl_err('','axm-571',0)
                    NEXT FIELD omf25
                 ELSE
                    CALL t670_omf25()
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_omf[l_ac].omf25,g_errno,0)
                       NEXT FIELD omf25
                    END IF 
                 END IF
              END IF 
           END IF 

        AFTER FIELD omf26
           IF NOT cl_null(g_omf[l_ac].omf25) THEN
              IF (p_cmd = 'a') OR
                 (p_cmd = 'u' AND (g_omf_t.omf26 != g_omf[l_ac].omf26 OR g_omf_t.omf25 != g_omf[l_ac].omf25)) THEN
                 LET l_n = 0
                 SELECT COUNT(*) INTO l_n FROM oeb_file
                  WHERE oeb01 = g_omf[l_ac].omf25
                    AND oeb03 = g_omf[l_ac].omf26
                 IF l_n = 0 THEN
                    CALL cl_err('','axm-571',0)
                    NEXT FIELD omf26
                 ELSE
                    CALL t670_omf25()
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_omf[l_ac].omf25,g_errno,0)
                       NEXT FIELD omf26
                    END IF 
                 END IF
              END IF
           END IF 
        #FUN-D10082--add--end--
        
        #FUN-C60036--add--str
        AFTER FIELD omf29 
           IF p_cmd = 'a' OR 
              (p_cmd = 'u' AND (g_omf_t.omf29 != g_omf[l_ac].omf29)) THEN 
              LET g_omf[l_ac].omf19 = g_omf[l_ac].omf29 * g_omf_1.omf22
              LET g_omf[l_ac].omf19 = cl_digcut(g_omf[l_ac].omf19,g_azi04)     #本幣
              LET g_omf_t.omf29 = g_omf[l_ac].omf29
        #str----add by huanglf160923
              IF NOT cl_null(g_omf[l_ac].omf29x) THEN 
                 LET  g_omf[l_ac].omf29t = g_omf[l_ac].omf29 + g_omf[l_ac].omf29x 
              END IF
        #str----end by huanglf160923
        #str----add by huanglf160923
              IF NOT cl_null(g_omf[l_ac].omf19x) THEN 
                 LET  g_omf[l_ac].omf19t = g_omf[l_ac].omf19 + g_omf[l_ac].omf19x 
              END IF
        #str----end by huanglf160923
           END IF 
#MOD-DB0059 mark begin---------
#        AFTER FIELD omf29x
#           IF p_cmd = 'a' OR
#              (p_cmd = 'u' AND (g_omf_t.omf29x != g_omf[l_ac].omf29x)) THEN
#              LET g_omf[l_ac].omf19x = g_omf[l_ac].omf29x * g_omf_1.omf22
#              LET g_omf_t.omf29x = g_omf[l_ac].omf29x
#           END IF
#MOD-DB0059 mark end-----------
#MOD-DB0059 add begin---------           
        AFTER FIELD omf29x
           IF p_cmd = 'a' OR
              (p_cmd = 'u' AND (g_omf_t.omf29x != g_omf[l_ac].omf29x)) THEN
              LET g_omf[l_ac].omf29x = cl_digcut(g_omf[l_ac].omf29x,t_azi04) #原幣 #sunlmadd
              LET g_omf[l_ac].omf19x = g_omf[l_ac].omf29x * g_omf_1.omf22
              LET g_omf[l_ac].omf19x = cl_digcut(g_omf[l_ac].omf19x,g_azi04)   #本幣 #sunlmadd
              LET g_omf_t.omf29x = g_omf[l_ac].omf29x
         #str----add by huanglf160923
              IF NOT cl_null(g_omf[l_ac].omf29) THEN 
                 LET  g_omf[l_ac].omf29t = g_omf[l_ac].omf29 + g_omf[l_ac].omf29x 
              END IF
        #str----end by huanglf160923
        #str----add by huanglf160923
              IF NOT cl_null(g_omf[l_ac].omf19) THEN 
                 LET  g_omf[l_ac].omf19t = g_omf[l_ac].omf19 + g_omf[l_ac].omf19x 
              END IF
        #str----end by huanglf160923
           END IF
        AFTER FIELD omf19x
           IF p_cmd = 'a' OR
              (p_cmd = 'u' AND (g_omf_t.omf19x != g_omf[l_ac].omf19x)) THEN
              LET g_omf[l_ac].omf29x = cl_digcut(g_omf[l_ac].omf29x,t_azi04) #原幣 #sunlmadd
              LET g_omf[l_ac].omf19x = g_omf[l_ac].omf29x * g_omf_1.omf22
              LET g_omf[l_ac].omf19x = cl_digcut(g_omf[l_ac].omf19x,g_azi04)   #本幣 #sunlmadd
              LET g_omf_t.omf19x = g_omf[l_ac].omf19x
        #str----add by huanglf160923
              IF NOT cl_null(g_omf[l_ac].omf19) THEN 
                 LET  g_omf[l_ac].omf19t = g_omf[l_ac].omf19 + g_omf[l_ac].omf19x 
              END IF
        #str----end by huanglf160923
           END IF 
#MOD-DB0059 add end---------           
        AFTER FIELD omf29t
           IF p_cmd = 'a' OR
              (p_cmd = 'u' AND (g_omf_t.omf29t != g_omf[l_ac].omf29t)) THEN
              LET g_omf[l_ac].omf19t = g_omf[l_ac].omf29t * g_omf_1.omf22
              LET g_omf[l_ac].omf19t = cl_digcut(g_omf[l_ac].omf19t,g_azi04)     #本幣
              LET g_omf_t.omf29t = g_omf[l_ac].omf29t
           END IF
        AFTER FIELD omf13
           IF NOT cl_null(g_omf[l_ac].omf13) THEN 
           IF g_sma.sma115 = 'Y' THEN					
              CALL s_chk_va_setting(g_omf[l_ac].omf13)					
                   RETURNING g_flag,g_ima906,g_ima907					
              IF g_flag=1 THEN					
                 NEXT FIELD omf13				
              END IF					
              CALL s_chk_va_setting1(g_omf[l_ac].omf13)					
                   RETURNING g_flag,g_ima908					
              IF g_flag=1 THEN					
                 NEXT FIELD omf13				
              END IF					
              IF g_ima906 = '3' THEN					
                 LET g_omf[l_ac].omf913=g_ima907					
              END IF					
           END IF					
           IF g_sma.sma116 MATCHES '[23]' THEN					
              CALL s_chk_va_setting1(g_omf[l_ac].omf13)					
                   RETURNING g_flag,g_ima908					
              IF g_flag=1 THEN					
                 NEXT FIELD omf13				
              END IF					
              IF cl_null(g_omf[l_ac].omf916) THEN					
                 LET g_omf[l_ac].omf916=g_ima908					
              END IF					
           END IF					
           IF g_omf[l_ac].omf10 = '9' THEN 
              LET temp_omf13 = g_omf[l_ac].omf13
              IF temp_omf13.substring(1,4) !='MISC' OR temp_omf13.getlength()<4 THEN 
                 CALL cl_err('','axm-340',0)
                 NEXT FIELD omf13
              END IF  
              #yinhy130510  --Begin
              IF NOT cl_null(g_omf[l_ac].omf13) THEN
                 LET l_sql = "SELECT ima02,ima021,ima44 FROM ",cl_get_target_table(g_omf[l_ac].omf09,'ima_file'), 
                             " WHERE ima01 = '",g_omf[l_ac].omf13,"' "
                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
                 CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
                 PREPARE ima_pre FROM l_sql
                 DECLARE ima_cs CURSOR FOR ima_pre
                 OPEN ima_cs
                 FETCH ima_cs INTO g_omf[l_ac].omf14,g_omf[l_ac].omf15,g_omf[l_ac].omf17
              END IF
               CALL cl_set_comp_entry("omf14,omf15",TRUE)

              #yinhy130510  --End
           END IF 
           END IF 
        AFTER FIELD omf17
           IF cl_null(g_omf[l_ac].omf916) THEN  LET g_omf[l_ac].omf916 = g_omf[l_ac].omf17 END IF 
        #FUN-C60036--add--end
        AFTER FIELD omf16
            SELECT azi04 INTO t_azi04 FROM azi_file 
             WHERE azi01 = g_omf_1.omf07
          #IF cl_null(g_omf[l_ac].omf16) THEN#MOD-CA0092 mark
           IF cl_null(g_omf[l_ac].omf16) OR (g_omf[l_ac].omf16 = 0 AND (l_oha09 !='5' OR cl_null(l_oha09))) THEN #MOD-CA0092
              NEXT FIELD omf16
           ELSE         
              IF g_omf[l_ac].omf10 != '9' THEN #FUN-C60033--add--by xuxz 
             
              CALL t670_omf16()
              IF g_omf[l_ac].omf10 = '1' THEN             	  
               	 LET g_sql = "SELECT ogb12 FROM ",cl_get_target_table(g_plant_new,'ogb_file'),
                             " WHERE ogb01 = '",g_omf[l_ac].omf11,"' ",
                             "   AND ogb03 = '",g_omf[l_ac].omf12,"' "
              ELSE
                	LET g_sql = "SELECT ohb12 FROM ",cl_get_target_table(g_plant_new,'ohb_file'),
                              " WHERE ohb01 = '",g_omf[l_ac].omf11,"' ",
                              "   AND ohb03 = '",g_omf[l_ac].omf12,"' "
              END IF
              CALL cl_replace_sqldb(g_sql) RETURNING g_sql			
              CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql                
              PREPARE sel_ogb12_pre FROM g_sql
              EXECUTE sel_ogb12_pre INTO l_ogb12
              IF cl_null(l_ogb12) THEN LET l_ogb12 = 0 END IF
              #FUN-C60036--add--str--
              IF g_omf[l_ac].omf10 = '2' THEN
                 LET l_omf16 = g_omf[l_ac].omf16*(-1)
                 IF l_omf16 > l_ogb12 - g_omf16  OR l_omf16 < 0 THEN#FUN-CA0084 add l_omf16 <0
                #   CALL cl_err(' ','abm-010',0)     #TQC-D20046--cj--mark
                    CALL cl_err(' ','axr-398',0)      #TQC-D20046--cj--add
                    NEXT FIELD omf16
                 END IF
              ELSE  
              #FUN-C60036--add--end
                 IF g_omf[l_ac].omf16 > l_ogb12 - g_omf16  OR g_omf[l_ac].omf16 < 0 THEN #FUN-CA0084 add g_omf[l_ac].omf16 < 0 
                #   CALL cl_err(' ','abm-010',0)     #TQC-D20046--cj--mark
                    CALL cl_err(' ','axr-397',0)      #TQC-D20046--cj--add
                    NEXT FIELD omf16
                 END IF
              END IF  #FUN-C60036
             END IF #FUN-C60033--add--by xuxz

            #FUN-D10082--add--str--
            #IF g_omf[l_ac].omf10 = '9' THEN 
            IF g_omf[l_ac].omf10 = '9' AND NOT cl_null(g_omf[l_ac].omf25) AND NOT cl_null(g_omf[l_ac].omf26) THEN        #yinhy130510         	
               LET g_sql = " SELECT oeb12" ,
                           "   FROM ",cl_get_target_table(g_plant_new,'oeb_file') ,
                           "  WHERE oeb01 = '",g_omf[l_ac].omf25,"'",
                           "    AND oeb03 = '",g_omf[l_ac].omf26,"'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql    	
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
               PREPARE sel_oeb_pre1 FROM g_sql
               EXECUTE sel_oeb_pre1 INTO g_sum_omf16
               IF cl_null(g_sum_omf16) THEN LET g_sum_omf16 = 0 END IF
               LET g_sql = " SELECT abs(SUM(omf16)) ",
                           "   FROM omf_file ",
                           "  WHERE omf00 <>'",g_omf_1.omf00,"'",
                           "    AND omf09 = '",g_omf[l_ac].omf09,"'",
                           "    AND omf25 = '",g_omf[l_ac].omf25,"'",
                           "    AND omf26 = '",g_omf[l_ac].omf26,"'"
               PREPARE t670_omf25_pb1 FROM g_sql
               IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
                  CALL cl_used(g_prog,g_time,2) RETURNING g_time
                  EXIT PROGRAM 
               END IF
               DECLARE omf_omf25_curs1 CURSOR FOR t670_omf25_pb1
               OPEN omf_omf25_curs1
               FETCH omf_omf25_curs1 INTO g_omf16
               IF cl_null(g_omf16) THEN LET g_omf16 = 0 END IF
               IF g_omf[l_ac].omf16 + g_omf16 > g_sum_omf16 THEN 
                  CALL cl_err('','apm1022',0)
                  NEXT FIELD omf16
               END IF 
            END IF   
             #FUN-D10082--add--end--

           #IF g_omf[l_ac].omf16 <> 0 AND (g_omf_t.omf16 <> g_omf[l_ac].omf16#MOD-CA0092--mark
            IF (g_omf_t.omf16 <> g_omf[l_ac].omf16         #MOD-CA0092 add
               OR g_omf_t.omf19 <> g_omf[l_ac].omf19) THEN
               LET g_omf[l_ac].omf917 = g_omf[l_ac].omf16
               LET g_sql = " SELECT gec05,gec07,gec04 FROM ",cl_get_target_table(g_plant_new,'gec_file'),
                           "  WHERE gec01='",g_omf_1.omf06,"' ",
                           "    AND gec011 = '2'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
		           CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql            
               PREPARE sel_gec07_pre1 FROM g_sql
               EXECUTE sel_gec07_pre1 INTO g_gec05,g_gec07,g_omf_1.omf061
               IF g_gec07 = 'Y' THEN    #含稅
                  #未稅金額=(含稅單價*數量)/(1+稅率/100)
                  IF g_omf[l_ac].omf16 <> 0 THEN     
                     LET g_omf[l_ac].omf29 = cl_digcut((g_omf[l_ac].omf28*g_omf[l_ac].omf16),t_azi04)/(1+g_omf_1.omf061/100)    
                     LET g_omf[l_ac].omf29t = g_omf[l_ac].omf16 * g_omf[l_ac].omf28
                    #LET g_omf[l_ac].omf19 = cl_digcut((g_omf[l_ac].omf18*g_omf[l_ac].omf16),g_azi04)/(1+g_omf_1.omf061/100)
                    #LET g_omf[l_ac].omf19t = g_omf[l_ac].omf16 * g_omf[l_ac].omf18
                 #MOD-CA0092--add--str
                  ELSE
                     IF l_oha09 = '5' THEN 
                        LET g_omf[l_ac].omf29 = cl_digcut((g_omf[l_ac].omf28*(-1)),t_azi04)/(1+g_omf_1.omf061/100)
                        LET g_omf[l_ac].omf29t =-1* g_omf[l_ac].omf28
                     END IF 
                 #MOD-CA0092--add--end
                  END IF
               ELSE                     #不含稅
                  #未稅金額=未稅單價*數量
                  IF g_omf[l_ac].omf16 <> 0 THEN
                     LET g_omf[l_ac].omf29 = g_omf[l_ac].omf16 * g_omf[l_ac].omf28
                     LET g_omf[l_ac].omf29 = cl_digcut(g_omf[l_ac].omf29,t_azi04)
                     LET g_omf[l_ac].omf29t = g_omf[l_ac].omf29 * (1+g_omf_1.omf061/100) 
                    #LET g_omf[l_ac].omf19 = g_omf[l_ac].omf18*g_omf[l_ac].omf16
                    #LET g_omf[l_ac].omf19 = cl_digcut(g_omf[l_ac].omf19,g_azi04)
                    #LET g_omf[l_ac].omf19t = g_omf[l_ac].omf19 * (1+g_omf_1.omf061/100)
                  #MOD-CA0092--add--str
                  ELSE
                     IF l_oha09 = '5' THEN
                        LET g_omf[l_ac].omf29 = -1*g_omf[l_ac].omf28
                        LET g_omf[l_ac].omf29 = cl_digcut(g_omf[l_ac].omf29,t_azi04)
                        LET g_omf[l_ac].omf29t = g_omf[l_ac].omf29 * (1+g_omf_1.omf061/100)
                     END IF
                 #MOD-CA0092--add--end
                  END IF                                            
               END IF
               
               LET g_omf[l_ac].omf29 = cl_digcut(g_omf[l_ac].omf29,t_azi04)
               LET g_omf[l_ac].omf29t = cl_digcut(g_omf[l_ac].omf29t,t_azi04) #FUN-C60036 add
               LET g_omf[l_ac].omf29x = g_omf[l_ac].omf29t -g_omf[l_ac].omf29 #原幣稅額
               LET g_omf[l_ac].omf29x = cl_digcut(g_omf[l_ac].omf29x,t_azi04)      
              #FUN-C60036--mod--str
              #LET g_omf[l_ac].omf19 = g_omf[l_ac].omf29 * g_omf_1.omf22        #本幣
              #LET g_omf[l_ac].omf19 = cl_digcut(g_omf[l_ac].omf19,g_azi04)     #本幣
              #LET g_omf[l_ac].omf19x = g_omf[l_ac].omf19 * g_omf_1.omf061/100  #本幣
              #LET g_omf[l_ac].omf19x = cl_digcut(g_omf[l_ac].omf19x,g_azi04)   #本幣
              #LET g_omf[l_ac].omf19t =  g_omf[l_ac].omf19 + g_omf[l_ac].omf19x #本幣#FUN-C60036 mark
              #LET g_omf[l_ac].omf19t = cl_digcut(g_omf[l_ac].omf19t,g_azi04)   #本幣  
               LET g_omf[l_ac].omf19 = g_omf[l_ac].omf29 * g_omf_1.omf22
               LET g_omf[l_ac].omf19 = cl_digcut(g_omf[l_ac].omf19,g_azi04)     #本幣
               LET g_omf[l_ac].omf19t = g_omf[l_ac].omf29t * g_omf_1.omf22
               LET g_omf[l_ac].omf19t = cl_digcut(g_omf[l_ac].omf19t,g_azi04)   #本幣
               LET g_omf[l_ac].omf19x = g_omf[l_ac].omf19t - g_omf[l_ac].omf19
               LET g_omf[l_ac].omf19x = cl_digcut(g_omf[l_ac].omf19x,g_azi04)   #本幣
              #FUN-C60036--mod--end
            END IF   

            DISPLAY BY NAME g_omf[l_ac].ogb14
            DISPLAY BY NAME g_omf[l_ac].ogb11  #add by dengsy160527
            DISPLAY BY NAME g_omf[l_ac].oga011 #add by huanglf170313 
            DISPLAY BY NAME g_omf[l_ac].omf16
            DISPLAY BY NAME g_omf[l_ac].omf17
            DISPLAY BY NAME g_omf[l_ac].omf18         
            DISPLAY BY NAME g_omf[l_ac].omf19
            DISPLAY BY NAME g_omf[l_ac].omf19x
            DISPLAY BY NAME g_omf[l_ac].omf19t
            DISPLAY BY NAME g_omf[l_ac].omf28
            DISPLAY BY NAME g_omf[l_ac].omf29
            DISPLAY BY NAME g_omf[l_ac].omf29x
            DISPLAY BY NAME g_omf[l_ac].omf29t

         END IF
     #FUN-C60036--mark--str 
      #AFTER FIELD omf18
      #    IF cl_null(g_omf[l_ac].omf18) THEN
      #       NEXT FIELD omf18
      #    ELSE         
      #       IF g_omf[l_ac].omf18 <> 0 AND (g_omf_t.omf18 <> g_omf[l_ac].omf18
      #        OR g_omf_t.omf19 <> g_omf[l_ac].omf19) THEN

      #        LET g_sql = " SELECT gec05,gec07,gec04 FROM ",cl_get_target_table(g_plant_new,'gec_file'), #FUN-A50102      #MOD-A80052 #
      #                    "  WHERE gec01='",g_omf_1.omf06,"' ",
      #                    "    AND gec011 = '2'"
      #        CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      # 	           CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql            
      #        PREPARE sel_gec07_pre2 FROM g_sql
      #        EXECUTE sel_gec07_pre2 INTO g_gec05,g_gec07,g_omf_1.omf061     #MOD-A80052
      #        IF g_gec07 = 'Y' THEN    #含稅
      #           #未稅金額=(含稅單價*數量)/(1+稅率/100)
      #           IF g_omf[l_ac].omf917 <> 0 THEN     #FUN-C60036 mod 16--->917
      #           	  LET g_omf[l_ac].omf29 = cl_digcut((g_omf[l_ac].omf28*g_omf[l_ac].omf916),t_azi04)/(1+g_omf_1.omf061/100)    #FUN-C60036 mod 16--->917
      #              LET g_omf[l_ac].omf29t = g_omf[l_ac].omf917 * g_omf[l_ac].omf28#FUN-C60036 mod 16--->917
      #           END IF
      #        ELSE                     #不含稅
      #           #未稅金額=未稅單價*數量
      #           IF g_omf[l_ac].omf917 <> 0 THEN#FUN-C60036 mod 16--->917
      #              LET g_omf[l_ac].omf29 = g_omf[l_ac].omf917 * g_omf[l_ac].omf28#FUN-C60036 mod 16--->917
      #              LET g_omf[l_ac].omf29 = cl_digcut(g_omf[l_ac].omf29,t_azi04)
      #              LET g_omf[l_ac].omf29t = g_omf[l_ac].omf29 * (1+g_omf_1.omf061/100) 
      #           END IF                                            
      #        END IF
      #        LET g_omf[l_ac].omf29 = cl_digcut(g_omf[l_ac].omf29,t_azi04)
      #        LET g_omf[l_ac].omf29t = cl_digcut(g_omf[l_ac].omf29t,t_azi04) #FUN-C60036 add
      #        LET g_omf[l_ac].omf29x = g_omf[l_ac].omf29t-g_omf[l_ac].omf29
      #        LET g_omf[l_ac].omf29x = cl_digcut(g_omf[l_ac].omf29x,t_azi04)      
      #       #FUN-C600036-mod --str
      #       #LET g_omf[l_ac].omf19 = g_omf[l_ac].omf29 * g_omf_1.omf22        #本幣
      #       #LET g_omf[l_ac].omf19 = cl_digcut(g_omf[l_ac].omf19,g_azi04)     #本幣
      #       #LET g_omf[l_ac].omf19x = g_omf[l_ac].omf19 * g_omf_1.omf061/100  #本幣
      #       #LET g_omf[l_ac].omf19x = cl_digcut(g_omf[l_ac].omf19x,g_azi04)   #本幣
      #       #LET g_omf[l_ac].omf19t =  g_omf[l_ac].omf19 + g_omf[l_ac].omf19x #本幣#FUN-C60036 mark
      #       #LET g_omf[l_ac].omf19t = cl_digcut(g_omf[l_ac].omf19t,g_azi04)   #本幣
      #        LET g_omf[l_ac].omf19 = g_omf[l_ac].omf29 * g_omf_1.omf22
      #        LET g_omf[l_ac].omf19 = cl_digcut(g_omf[l_ac].omf19,g_azi04)     #本幣
      #        LET g_omf[l_ac].omf19t = g_omf[l_ac].omf29t * g_omf_1.omf22
      #        LET g_omf[l_ac].omf19t = cl_digcut(g_omf[l_ac].omf19t,g_azi04)   #本幣
      #        LET g_omf[l_ac].omf19x = g_omf[l_ac].omf19t - g_omf[l_ac].omf19
      #        LET g_omf[l_ac].omf19x = cl_digcut(g_omf[l_ac].omf19x,g_azi04)   #本幣
      #       #FUN-C60036--mod--end
      #     END IF   

      #     DISPLAY BY NAME g_omf[l_ac].ogb14
      #     DISPLAY BY NAME g_omf[l_ac].omf16
      #     DISPLAY BY NAME g_omf[l_ac].omf17
      #     DISPLAY BY NAME g_omf[l_ac].omf18
      #     DISPLAY BY NAME g_omf[l_ac].omf19
      #     DISPLAY BY NAME g_omf[l_ac].omf19x
      #     DISPLAY BY NAME g_omf[l_ac].omf19t
      #     DISPLAY BY NAME g_omf[l_ac].omf28
      #     DISPLAY BY NAME g_omf[l_ac].omf29
      #     DISPLAY BY NAME g_omf[l_ac].omf29x
      #     DISPLAY BY NAME g_omf[l_ac].omf29t
      #  END IF
      #FUN-C60036--mark--end
        #FUN-C60036--add--str
        AFTER FIELD omf28
           IF cl_null(g_omf[l_ac].omf28) THEN
              NEXT FIELD omf28
           ELSE         
              #IF g_omf[l_ac].omf28 <> 0 AND (g_omf_t.omf28 <> g_omf[l_ac].omf28  #TQC-D70020 mark
              # OR g_omf_t.omf29 <> g_omf[l_ac].omf29) THEN                       #TQC-D70020 mark
              IF g_omf_t.omf28 <> g_omf[l_ac].omf28 OR g_omf_t.omf29 <> g_omf[l_ac].omf29 THEN    #TQC-D70020 add
               LET g_omf_t.omf28 = g_omf[l_ac].omf28   #TQC-D70020 add
               LET g_sql = " SELECT gec05,gec07,gec04 FROM ",cl_get_target_table(g_plant_new,'gec_file'), #FUN-A50102      #MOD-A80052
                           "  WHERE gec01='",g_omf_1.omf06,"' ",
                           "    AND gec011 = '2'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
		           CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql            
               PREPARE sel_gec07_pre2_1 FROM g_sql
               EXECUTE sel_gec07_pre2_1 INTO g_gec05,g_gec07,g_omf_1.omf061    
               IF g_gec07 = 'Y' THEN    #含稅
                  #未稅金額=(含稅單價*數量)/(1+稅率/100)
                  IF g_omf[l_ac].omf917 <> 0 THEN     #FUN-C60036 mod 16--->917
                  	  LET g_omf[l_ac].omf29 = cl_digcut((g_omf[l_ac].omf28*g_omf[l_ac].omf917)/(1+g_omf_1.omf061/100),t_azi04)    #FUN-C60036 mod 16--->917
                      LET g_omf[l_ac].omf29t = g_omf[l_ac].omf917 * g_omf[l_ac].omf28 #FUN-C60036 mod 16--->917
                      LET g_omf[l_ac].omf29t = cl_digcut(g_omf[l_ac].omf29t,t_azi04)
                  #MOD-CA0092--add--str
                  ELSE
                     IF l_oha09 = '5' THEN
                        LET g_omf[l_ac].omf29 = cl_digcut((g_omf[l_ac].omf28*(-1))/(1+g_omf_1.omf061/100),t_azi04)
                        LET g_omf[l_ac].omf29t = -1*g_omf[l_ac].omf28
                     END IF
                 #MOD-CA0092--add--end
                  END IF
               ELSE                     #不含稅
                  #未稅金額=未稅單價*數量
                  IF g_omf[l_ac].omf917 <> 0 THEN#FUN-C60036 mod 16--->917
                     LET g_omf[l_ac].omf29 = g_omf[l_ac].omf917 * g_omf[l_ac].omf28 #FUN-C60036 mod 16--->917
                     LET g_omf[l_ac].omf29 = cl_digcut(g_omf[l_ac].omf29,t_azi04)
                     LET g_omf[l_ac].omf29t = g_omf[l_ac].omf29 * (1+g_omf_1.omf061/100) 
                     LET g_omf[l_ac].omf29t =cl_digcut(g_omf[l_ac].omf29t,t_azi04)
                  #MOD-CA0092--add--str
                  ELSE
                     IF l_oha09 = '5' THEN
                        LET g_omf[l_ac].omf29 = -1*g_omf[l_ac].omf28
                        LET g_omf[l_ac].omf29 = cl_digcut(g_omf[l_ac].omf29,t_azi04)
                        LET g_omf[l_ac].omf29t = g_omf[l_ac].omf29 * (1+g_omf_1.omf061/100)
                        LET g_omf[l_ac].omf29t =cl_digcut(g_omf[l_ac].omf29t,t_azi04)
                     END IF
                 #MOD-CA0092--add--end
                  END IF                                            
               END IF
               LET g_omf[l_ac].omf29 = cl_digcut(g_omf[l_ac].omf29,t_azi04)
               LET g_omf[l_ac].omf29t = cl_digcut(g_omf[l_ac].omf29t,t_azi04) 
               LET g_omf[l_ac].omf29x = g_omf[l_ac].omf29t- g_omf[l_ac].omf29
               LET g_omf[l_ac].omf29x = cl_digcut(g_omf[l_ac].omf29x,t_azi04)      
               LET g_omf[l_ac].omf18 = g_omf[l_ac].omf28 * g_omf_1.omf22
               LET g_omf[l_ac].omf18 = cl_digcut(g_omf[l_ac].omf18,g_azi03)     #本幣 #MOD-D60158 azi04---->azi03
               LET g_omf[l_ac].omf19 = g_omf[l_ac].omf29 * g_omf_1.omf22
               LET g_omf[l_ac].omf19 = cl_digcut(g_omf[l_ac].omf19,g_azi04)     #本幣
               LET g_omf[l_ac].omf19t = g_omf[l_ac].omf29t * g_omf_1.omf22
               LET g_omf[l_ac].omf19t = cl_digcut(g_omf[l_ac].omf19t,g_azi04)   #本幣
               LET g_omf[l_ac].omf19x = g_omf[l_ac].omf19t - g_omf[l_ac].omf19
               LET g_omf[l_ac].omf19x = cl_digcut(g_omf[l_ac].omf19x,g_azi04)   #本幣
            END IF   

            DISPLAY BY NAME g_omf[l_ac].ogb14
            DISPLAY BY NAME g_omf[l_ac].ogb11 #add by dengsy160527
            DISPLAY BY NAME g_omf[l_ac].oga011 #add by huanglf170313
            DISPLAY BY NAME g_omf[l_ac].omf16
            DISPLAY BY NAME g_omf[l_ac].omf17
            DISPLAY BY NAME g_omf[l_ac].omf18
            DISPLAY BY NAME g_omf[l_ac].omf19
            DISPLAY BY NAME g_omf[l_ac].omf19x
            DISPLAY BY NAME g_omf[l_ac].omf19t
            DISPLAY BY NAME g_omf[l_ac].omf28
            DISPLAY BY NAME g_omf[l_ac].omf29
            DISPLAY BY NAME g_omf[l_ac].omf29x
            DISPLAY BY NAME g_omf[l_ac].omf29t
         END IF
         
        BEFORE FIELD omf913
           CALL t670_set_required()
        AFTER FIELD omf913
           CASE t670_chk_omf913()
              WHEN "omf13"  NEXT FIELD omf13
              WHEN "omf202" 
                 CASE 
                    WHEN g_oaz.oaz104 = 'Y'
                         NEXT FIELD omf202
                    WHEN g_oaz.oaz103 = 'Y'
                         NEXT FIELD omf201
                    WHEN g_oaz.oaz102 = 'Y'
                         NEXT FIELD omf20
                 END CASE
              WHEN "omf913" NEXT FIELD omf913
           END CASE
           IF NOT cl_null(g_omf[l_ac].omf915) AND NOT cl_null(g_omf[l_ac].omf913) THEN
              IF cl_null(g_omf_t.omf915) OR cl_null(g_omf_t.omf913) OR g_omf_t.omf915 != g_omf[l_ac].omf915 OR g_omf_t.omf913 != g_omf[l_ac].omf913 THEN
                 LET g_omf[l_ac].omf915=s_digqty(g_omf[l_ac].omf915,g_omf[l_ac].omf913)
                 DISPLAY BY NAME g_omf[l_ac].omf915
              END IF
           END IF
           CALL t670_sum_omf917()
           LET g_omf_t.omf913 = g_omf[l_ac].omf913
           
        BEFORE FIELD omf914
           CASE t670_bef_omf914()
              WHEN "omf13"  NEXT FIELD omf13
              WHEN "omf202" 
                 CASE 
                    WHEN g_oaz.oaz104 = 'Y'
                         NEXT FIELD omf202
                    WHEN g_oaz.oaz103 = 'Y'
                         NEXT FIELD omf201
                    WHEN g_oaz.oaz102 = 'Y'
                         NEXT FIELD omf20
                 END CASE
           END CASE
           
        AFTER FIELD omf914
           IF NOT t670_chk_omf914() THEN
              NEXT FIELD omf914
           ELSE
              CALL t670_sum_omf917()
           END IF
           LET g_omf_t.omf914 = g_omf[l_ac].omf914
        BEFORE FIELD omf915
           CASE t670_bef_omf915()
              WHEN "omf13"  NEXT FIELD omf13
              WHEN "omf202" 
                 CASE 
                    WHEN g_oaz.oaz104 = 'Y'
                         NEXT FIELD omf202
                    WHEN g_oaz.oaz103 = 'Y'
                         NEXT FIELD omf201
                    WHEN g_oaz.oaz102 = 'Y'
                         NEXT FIELD omf20
                 END CASE
           END CASE
        AFTER FIELD omf915
           IF NOT cl_null(g_omf[l_ac].omf915) AND NOT cl_null(g_omf[l_ac].omf913) THEN
              IF cl_null(g_omf_t.omf915) OR cl_null(g_omf_t.omf913) OR g_omf_t.omf915 != g_omf[l_ac].omf915 OR g_omf_t.omf913 != g_omf[l_ac].omf913 THEN
                 LET g_omf[l_ac].omf915=s_digqty(g_omf[l_ac].omf915,g_omf[l_ac].omf913)
              END IF
           END IF
           IF NOT t670_chk_omf915(p_cmd) THEN
              NEXT FIELD CURRENT
           END IF
           CASE  t670_chk_num()
              WHEN "omf912" 
                 CALL cl_err('','axr-163',1)
                 NEXT FIELD omf912
              WHEN "omf915" 
                 CALL cl_err('','axr-163',1)
                 NEXT FIELD omf915
           END CASE 
           #MOD-CA0092--add--str
           IF g_omf[l_ac].omf912 = 0 AND g_omf[l_ac].omf915 = 0 AND g_sma.sma115 = 'Y' THEN
              IF l_oha09 !='5' THEN
                 NEXT FIELD omf912
              END IF
           END IF
           #MOD-CA0092--add--end
           CALL t670_sum_omf917()
 
        BEFORE FIELD omf910
           CALL t670_set_required()
        AFTER FIELD omf910
           CASE t670_chk_omf910()
              WHEN "omf13"  NEXT FIELD omf13
              WHEN "omf202" 
                 CASE 
                    WHEN g_oaz.oaz104 = 'Y'
                         NEXT FIELD omf202
                    WHEN g_oaz.oaz103 = 'Y'
                         NEXT FIELD omf201
                    WHEN g_oaz.oaz102 = 'Y'
                         NEXT FIELD omf20
                 END CASE
              WHEN "omf910" NEXT FIELD omf910
           END CASE
           CALL t670_sum_omf917()
           
        BEFORE FIELD omf911
           CASE t670_bef_omf911()
              WHEN "omf13"  NEXT FIELD omf13
              WHEN "omf202" 
                 CASE 
                    WHEN g_oaz.oaz104 = 'Y'
                         NEXT FIELD omf202
                    WHEN g_oaz.oaz103 = 'Y'
                         NEXT FIELD omf201
                    WHEN g_oaz.oaz102 = 'Y'
                         NEXT FIELD omf20
                 END CASE
           END CASE
        AFTER FIELD omf911
           IF NOT t670_chk_omf911() THEN
              NEXT FIELD CURRENT
           END IF
           CALL t670_sum_omf917()
           
        BEFORE FIELD omf912
           CASE t670_bef_omf912()
              WHEN "omf13"  NEXT FIELD oomf13
              WHEN "omf202" 
                 CASE 
                    WHEN g_oaz.oaz104 = 'Y'
                         NEXT FIELD omf202
                    WHEN g_oaz.oaz103 = 'Y'
                         NEXT FIELD omf201
                    WHEN g_oaz.oaz102 = 'Y'
                         NEXT FIELD omf209
                 END CASE
           END CASE
           IF NOT cl_null(g_omf[l_ac].omf912) THEN
              LET g_omf_t.omf912 = g_omf[l_ac].omf912
           END IF

        AFTER FIELD omf912  #第一數量
           CALL t670_omf912_check() 
           CASE  t670_chk_num()
              WHEN "omf912" 
                 CALL cl_err('','axr-163',1)
                 NEXT FIELD omf912
              WHEN "omf915" 
                 CALL cl_err('','axr-163',1)
                 NEXT FIELD omf915
           END CASE 
           #MOD-CA0092--add--str
           IF g_omf[l_ac].omf912 = 0 AND g_omf[l_ac].omf915 = 0 AND g_sma.sma115 = 'Y' THEN
              IF l_oha09 !='5' THEN
                 NEXT FIELD omf912
              END IF
           END IF
           #MOD-CA0092--add--end
           CALL t670_sum_omf917()
        
        BEFORE FIELD omf916
           CALL t670_set_required()
        AFTER FIELD omf916
           CASE  t670_chk_omf916(p_cmd) 
              WHEN "omf13"   NEXT FIELD omf13
              WHEN "omf916" NEXT FIELD CURRENT
              WHEN "omf202"  NEXT FIELD omf202
           END CASE
           IF NOT cl_null(g_omf[l_ac].omf917) AND g_omf[l_ac].omf917 <> 0 THEN 
              IF NOT t670_omf917_check() THEN 
                 LET g_omf_t.omf916 = g_omf[l_ac].omf916
                 NEXT FIELD omf917
              END IF 
           END IF                                                             
           LET g_omf_t.omf916 = g_omf[l_ac].omf916
           
        BEFORE FIELD omf917
           IF g_change='Y' THEN
              CALL t670_set_omf917()
           END IF
        AFTER FIELD omf917
           IF NOT t670_omf917_check() THEN NEXT FIELD omf917 END IF
           CASE  t670_chk_num()
              WHEN "omf912" 
                 CALL cl_err('','axr-163',1)
                 NEXT FIELD omf912
              WHEN "omf915" 
                 CALL cl_err('','axr-163',1)
                 NEXT FIELD omf915
           END CASE 
           LET g_sql = " SELECT gec05,gec07,gec04 FROM ",cl_get_target_table(g_plant_new,'gec_file'), #FUN-A50102      #MOD-A80052
                           "  WHERE gec01='",g_omf_1.omf06,"' ",
                           "    AND gec011 = '2'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                           CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
               PREPARE sel_gec07_pre3_1 FROM g_sql
               EXECUTE sel_gec07_pre3_1 INTO g_gec05,g_gec07,g_omf_1.omf061
               IF g_gec07 = 'Y' THEN    #含稅
                  #未稅金額=(含稅單價*數量)/(1+稅率/100)
                  IF g_omf[l_ac].omf917 <> 0 THEN     #FUN-C60036 mod 16--->917
                          LET g_omf[l_ac].omf29 = cl_digcut((g_omf[l_ac].omf28*g_omf[l_ac].omf917),t_azi04)/(1+g_omf_1.omf061/100)    #FUN-C60036 mod 16--->9
                     LET g_omf[l_ac].omf29t = g_omf[l_ac].omf917 * g_omf[l_ac].omf28#FUN-C60036 mod 16--->917
                 #MOD-CA0092--add--str
                  ELSE
                     IF l_oha09 = '5' THEN
                        LET g_omf[l_ac].omf29 = cl_digcut((g_omf[l_ac].omf28*(-1)),t_azi04)/(1+g_omf_1.omf061/100)
                        LET g_omf[l_ac].omf29t = -1*g_omf[l_ac].omf28
                     END IF
                 #MOD-CA0092--add--end
                  END IF
               ELSE                     #不含稅
                  #未稅金額=未稅單價*數量
                  IF g_omf[l_ac].omf917 <> 0 THEN#FUN-C60036 mod 16--->917
                     LET g_omf[l_ac].omf29 = g_omf[l_ac].omf917 * g_omf[l_ac].omf28#FUN-C60036 mod 16--->917
                     LET g_omf[l_ac].omf29 = cl_digcut(g_omf[l_ac].omf29,t_azi04)
                     LET g_omf[l_ac].omf29t = g_omf[l_ac].omf29 * (1+g_omf_1.omf061/100)
                  #MOD-CA0092--add--str
                  ELSE
                     IF l_oha09 = '5' THEN
                        LET g_omf[l_ac].omf29 = -1*g_omf[l_ac].omf28
                        LET g_omf[l_ac].omf29 = cl_digcut(g_omf[l_ac].omf29,t_azi04)
                        LET g_omf[l_ac].omf29t = g_omf[l_ac].omf29 * (1+g_omf_1.omf061/100)
                     END IF
                 #MOD-CA0092--add--end
                  END IF
               END IF
               LET g_omf[l_ac].omf29 = cl_digcut(g_omf[l_ac].omf29,t_azi04)
               LET g_omf[l_ac].omf29t = cl_digcut(g_omf[l_ac].omf29t,t_azi04)
               LET g_omf[l_ac].omf29x = g_omf[l_ac].omf29t- g_omf[l_ac].omf29
               LET g_omf[l_ac].omf29x = cl_digcut(g_omf[l_ac].omf29x,t_azi04)
               LET g_omf[l_ac].omf19 = g_omf[l_ac].omf29 * g_omf_1.omf22
               LET g_omf[l_ac].omf19 = cl_digcut(g_omf[l_ac].omf19,g_azi04)     #本幣
               LET g_omf[l_ac].omf19t = g_omf[l_ac].omf29t * g_omf_1.omf22
               LET g_omf[l_ac].omf19t = cl_digcut(g_omf[l_ac].omf19t,g_azi04)   #本幣
               LET g_omf[l_ac].omf19x = g_omf[l_ac].omf19t - g_omf[l_ac].omf19
               LET g_omf[l_ac].omf19x = cl_digcut(g_omf[l_ac].omf19x,g_azi04)   #本幣
        #FUN-C60036--add--end
           
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF (g_omf[l_ac].omf19 + g_omf[l_ac].omf19x <> g_omf[l_ac].omf19t) OR
                   (g_omf[l_ac].omf29 + g_omf[l_ac].omf29x <> g_omf[l_ac].omf29t) THEN
                   IF NOT cl_confirm('axr-181') THEN
                    NEXT FIELD omf19
                   END IF
                END IF
         #TQC-D40067--add--begin---
           LET l_n = 0
           SELECT COUNT(*) INTO l_n FROM omf_file
            WHERE omf00 = g_omf_1.omf00 
           IF l_n = 0 THEN    #單身錄入第一筆資料時單頭發票號碼自動編號
              CALL s_auto_assign_no("axm",g_omf_1.omf00,g_omf_1.omf03,"","omf_file","omf00","","","")
                   RETURNING li_result,g_omf_1.omf00
              IF (NOT li_result) THEN
                 EXIT INPUT
              END IF
              DISPLAY BY NAME g_omf_1.omf00
           END IF
         #TQC-D40067--add--end----                
           LET l_omf.omf00=g_omf_1.omf00    #FUN-C60033
           LET l_omf.omf01=g_omf_1.omf01
           LET l_omf.omf02=g_omf_1.omf02
           LET l_omf.omf03=g_omf_1.omf03
           #LET l_omf.omf04=g_omf_1.omf04 #FUN-C60036 mark
           LET l_omf.omf04=g_omf_1.omf04#FUN-D20003 add
           LET l_omf.omf05=g_omf_1.omf05
           LET l_omf.omf051=g_omf_1.omf051
           LET l_omf.omf06=g_omf_1.omf06
           LET l_omf.omf061=g_omf_1.omf061
           LET l_omf.omf07=g_omf_1.omf07
           LET l_omf.omf22=g_omf_1.omf22
           LET l_omf.omf30=g_omf_1.omf30   #No.FUN-D10103   Add
           LET l_omf.omf31=g_omf_1.omf31        #FUN-D50008 add
           LET l_omf.omf32=g_omf_1.omf32        #FUN-D50007 add
           LET l_omf.omf33=g_omf_1.omf33        #FUN-D50007 add
           LET l_omf.omfuser = g_omf_1.omfuser  #FUN-D50009 add
           LET l_omf.omfgrup = g_omf_1.omfgrup  #FUN-D50009 add
           LET l_omf.omforiu = g_omf_1.omforiu  #FUN-D50009 add
           LET l_omf.omforig = g_omf_1.omforig  #FUN-D50009 add
           LET l_omf.omfmodu = g_omf_1.omfmodu  #FUN-D50009 add
           LET l_omf.omfdate = g_omf_1.omfdate  #FUN-D50009 add

           LET l_omf.omf08='N'
           LET l_omf.omf21=g_omf[l_ac].omf21
           LET l_omf.omf09=g_omf[l_ac].omf09
           LET l_omf.omf10=g_omf[l_ac].omf10
           LET l_omf.omf11=g_omf[l_ac].omf11
           LET l_omf.omf12=g_omf[l_ac].omf12
           LET l_omf.omf25=g_omf[l_ac].omf25   #FUN-D10082 add
           LET l_omf.omf26=g_omf[l_ac].omf26   #FUN-D10082 add
           LET l_omf.omf13=g_omf[l_ac].omf13
           LET l_omf.omf14=g_omf[l_ac].omf14
           LET l_omf.omf15=g_omf[l_ac].omf15              #TQC-D20046---add---
           LET l_omf.omf16=g_omf[l_ac].omf16
           LET l_omf.omf17=g_omf[l_ac].omf17
           LET l_omf.omf18=g_omf[l_ac].omf18
           LET l_omf.omf19=g_omf[l_ac].omf19
           LET l_omf.omf19x=g_omf[l_ac].omf19x
           LET l_omf.omf19t=g_omf[l_ac].omf19t
           LET l_omf.omf28=g_omf[l_ac].omf28
           LET l_omf.omf29=g_omf[l_ac].omf29
           LET l_omf.omf29x=g_omf[l_ac].omf29x
           LET l_omf.omf29t=g_omf[l_ac].omf29t
           LET l_omf.omf20=g_omf[l_ac].omf20
           LET l_omf.omf201=g_omf[l_ac].omf201
           LET l_omf.omflegal=g_legal
           LET l_omf.omfpost='N'
           #FUN-C60036--add-str
           LET l_omf.omf23=g_omf[l_ac].omf23
           LET l_omf.omf202=g_omf[l_ac].omf202
           LET l_omf.omf910=g_omf[l_ac].omf910
           LET l_omf.omf911=g_omf[l_ac].omf911
           LET l_omf.omf912=g_omf[l_ac].omf912
           LET l_omf.omf913=g_omf[l_ac].omf913
           LET l_omf.omf914=g_omf[l_ac].omf914
           LET l_omf.omf915=g_omf[l_ac].omf915
           LET l_omf.omf916=g_omf[l_ac].omf916
           LET l_omf.omf917=g_omf[l_ac].omf917
           #FUN-C60036--add--end
           IF cl_null(l_omf.omf02) THEN LET l_omf.omf02 = ' ' END IF
           IF cl_null(l_omf.omf16) THEN LET l_omf.omf16=0 END IF
           IF cl_null(l_omf.omf18) THEN LET l_omf.omf18=0 END IF
           IF cl_null(l_omf.omf19) THEN LET l_omf.omf19=0 END IF
           IF cl_null(l_omf.omf19x) THEN LET l_omf.omf19x=0 END IF
           IF cl_null(l_omf.omf19t) THEN LET l_omf.omf19t=0 END IF
           IF cl_null(l_omf.omf28) THEN LET l_omf.omf28=0 END IF
           IF cl_null(l_omf.omf29) THEN LET l_omf.omf29=0 END IF
           IF cl_null(l_omf.omf29x) THEN LET l_omf.omf29x=0 END IF
           IF cl_null(l_omf.omf29t) THEN LET l_omf.omf29t=0 END IF
          #FUN-C60033---ADD--STR
           IF cl_null(l_omf.omf23) THEN LET l_omf.omf23='N' END IF
           #IF cl_null(l_omf.omf910) THEN LET l_omf.omf910=0  END IF  #MOD-CC0257 mark
           IF cl_null(l_omf.omf911) THEN LET l_omf.omf911=0 END IF
           IF cl_null(l_omf.omf912) THEN LET l_omf.omf912=0 END IF
           #IF cl_null(l_omf.omf913) THEN LET l_omf.omf913=0  END IF  #MOD-CC0257 mark
           IF cl_null(l_omf.omf914) THEN LET l_omf.omf914=0 END IF
           IF cl_null(l_omf.omf915) THEN LET l_omf.omf915=0 END IF
           #IF cl_null(l_omf.omf916) THEN LET l_omf.omf916=0  END IF  #MOD-CC0257 mark
           IF cl_null(l_omf.omf917) THEN LET l_omf.omf917=0 END IF
           LET l_omf.omf24 = ''
          #FUN-C60033---ADD--END 
           BEGIN WORK
           IF cl_null(l_omf.omf12) THEN LET l_omf.omf12 = 0 END IF #FUN-C60033 add-by xuxz
           IF cl_null(l_omf.omf01) THEN LET l_omf.omf01 = ' ' END IF #FUN-CA0084 add
           INSERT INTO omf_file VALUES(l_omf.*)
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err3("ins","omf_file","","",SQLCA.sqlcode,"","",1) 
              LET g_omf[l_ac].* = g_omf_t.*
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              #str------- add by dengsy160614
                    let l_ogc12 =0
                     let l_ogc12_1 =0
                     let l_count5=0
                    select sum(ogc12) into l_ogc12 from ogc_file 
                     where ogc01=g_omf[l_ac].omf11  and ogc03=g_omf[l_ac].omf12
                      select sum(ogc12) into l_ogc12_1 from ogc_file 
                     where ogc01=g_omf_1.omf00  and ogc03=g_omf_t.omf21
                      select count(*) into l_count5 from ogc_file 
                     where ogc01=g_omf[l_ac].omf11  and ogc03=g_omf[l_ac].omf12
                      if l_count5=1 then 
  										update ogc_file set ogc12=g_omf[l_ac].omf16,ogc16=g_omf[l_ac].omf16
  									   where ogc01=g_omf_1.omf00  and ogc03= g_omf_t.omf21
  									end if
  									if l_count5>=1 then 
  									     
  									    let l_ogc12 =g_omf[l_ac].omf16 -l_ogc12_1
  									    update ogc_file set ogc12=ogc12+l_ogc12
  									    where ogc01=g_omf_1.omf00  and ogc03= g_omf_t.omf21
  									     and ogc12>l_ogc12 and rownum=1
  									      update ogc_file set ogc16=ogc12
  									    where ogc01=g_omf_1.omf00  and ogc03= g_omf_t.omf21
  									     
  									end if
                     #end------ add by dengsy160614
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
      BEFORE DELETE                          #是否取消單身
      #  IF NOT cl_null(g_omf_t.omf12) AND NOT cl_null(g_omf_t.omf11)THEN
         #TQC-D70018--mark--str--
         #IF NOT cl_null(g_omf_t.omf21) THEN #FUN-C60036 add
         #   SELECT COUNT(*) INTO l_cnt
         #    #FROM omb_file,oma_file,ome_file   #FUN-C60036
         #     FROM omb_file,oma_file
         #    WHERE omb01 = oma01
         #     # AND oma10 = ome01# MOD-D60157 mark
         #      AND oma00 = '12'
         #      AND omb31 = g_omf_t.omf11
         #      AND omb32 = g_omf_t.omf12
         #     #AND ome01 = g_omf_1.omf01   #FUN-C60036
         #  #str MOD-A20066 add
         #   #檢查發票是否存在退貨折讓帳款裡
         #   IF l_cnt = 0 THEN
         #      SELECT COUNT(*) INTO l_cnt
         #        FROM omb_file,oma_file
         #       WHERE omb01 = oma01
         #         AND oma00 = '21'
         #         AND omb31 = g_omf_t.omf11
         #         AND omb32 = g_omf_t.omf12
         #        # AND ome01 = g_omf_1.omf01 #MOD-D60157
         #   END IF
         #  #end MOD-A20066 add
         #   IF l_cnt > 0 THEN
         #      CALL cl_err('','apm-241',0)
         #      CANCEL DELETE
         #   END IF
         #END IF
         #TQC-D70018--mark--end--
        #IF NOT cl_null(g_omf_t.omf12) AND NOT cl_null(g_omf_t.omf11)THEN
         IF NOT cl_null(g_omf_t.omf21) THEN #FUN-C60036 add
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            #FUN-C60036--add--str
            IF g_sma.sma115 = 'Y' THEN 
               DELETE FROM ogg_file 
                WHERE ogg01 = g_omf_1.omf00 AND ogg03 = g_omf_t.omf21
               DELETE FROM ogc_file
                WHERE ogc01 = g_omf_1.omf00 AND ogc03 = g_omf_t.omf21
            ELSE 
               DELETE FROM ogc_file 
                WHERE ogc01 = g_omf_1.omf00 AND ogc03 = g_omf_t.omf21
            END IF 
            #FUN-C60036--add--end
         #FUN-C60033---MOD---STR
         #   DELETE FROM omf_file WHERE omf01 = g_omf_1.omf01
         #                          AND omf02 = g_omf_1.omf02
             DELETE FROM omf_file WHERE omf00 = g_omf_1.omf00
                                   AND omf21 = g_omf_t.omf21
         #FUN-C60033---MOD---END
            IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err3("del","omf_file",g_omf_t.omf11,g_omf_t.omf12,SQLCA.sqlcode,"","",1) 
               ROLLBACK WORK
               CANCEL DELETE
            ELSE
               MESSAGE 'DELETE O.K'
               COMMIT WORK
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               #tianry add 
               INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
               VALUES ('axmt670',g_user,g_today,g_omf[l_ac].omf21,g_omf_1.omf00,'delete',g_plant,g_legal)
 
               #tianry add end 



            END IF
 
            SELECT SUM(omf19),SUM(omf19x),SUM(omf19t),SUM(omf29),SUM(omf29x),SUM(omf29t)
              INTO g_omf_1.omf19_sum,g_omf_1.omf19x_sum,g_omf_1.omf19t_sum,g_omf_1.omf29_sum,g_omf_1.omf29x_sum,g_omf_1.omf29t_sum
              FROM omf_file
        #    WHERE omf01 = g_omf_1.omf01   #FUN-C60033 
        #      AND omf02 = g_omf_1.omf02   #FUN-C60033 
             WHERE omf01 = g_omf_1.omf00   #FUN-C60033 
            #FUN-C60036--add--str
            CALL t670_upd_show_diff() #MOD-D60161 add
            LET g_omf_1.omf19_sum = cl_digcut(g_omf_1.omf19_sum,g_azi04)
            LET g_omf_1.omf19x_sum = cl_digcut(g_omf_1.omf19x_sum,g_azi04)
            LET g_omf_1.omf19t_sum = cl_digcut(g_omf_1.omf19t_sum,g_azi04)
            LET g_omf_1.omf29_sum = cl_digcut(g_omf_1.omf29_sum,t_azi04)
            LET g_omf_1.omf29x_sum = cl_digcut(g_omf_1.omf29x_sum,t_azi04)
            LET g_omf_1.omf29t_sum = cl_digcut(g_omf_1.omf29t_sum,t_azi04)
            #FUN-C60036--add--end

            DISPLAY BY NAME g_omf_1.omf19_sum,g_omf_1.omf19x_sum,g_omf_1.omf19t_sum,g_omf_1.omf29_sum,g_omf_1.omf29x_sum,g_omf_1.omf29t_sum
            #MOD-DC0096 add begin---------
            SELECT COUNT(*) INTO l_cnt FROM omf_file WHERE omf00 = g_omf_1.omf00
            IF l_cnt = 0 THEN 
               LET g_omf_1.omf00 = s_get_doc_no(g_omf_1.omf00)
               DISPLAY BY NAME g_omf_1.omf00
            END IF    
            #MOD-DC0096 add end-----------
         END IF

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_omf[l_ac].* = g_omf_t.*
              CLOSE t670_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
           	  CALL cl_err(g_omf[l_ac].omf11,-263,1)
              LET g_omf[l_ac].* = g_omf_t.*
           ELSE
           	  CALL t670_omf11()
           	  IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_omf[l_ac].omf11,g_errno,0) 
                 NEXT FIELD omf11
              END IF
            #FUN-C60036--mark--str--
            #	  LET l_n=0
            #     SELECT COUNT(*) INTO l_n FROM ome_file
            #  WHERE ome03 = g_omf_1.omf01
            #    AND ome01 IN (SELECT oma10 FROM oma_file)
            # IF l_n > 0 THEN
            #    CALL cl_err('','axr-331',0)
            #    NEXT FIELD omf11
            # ELSE                
            #FUN-C60036--mark--end
                #FUN-C60036--add--str
                IF cl_null(g_omf[l_ac].omf911) THEN LET g_omf[l_ac].omf911 = 0 END IF
                IF cl_null(g_omf[l_ac].omf912) THEN LET g_omf[l_ac].omf912 = 0 END IF
                IF cl_null(g_omf[l_ac].omf914) THEN LET g_omf[l_ac].omf914 = 0 END IF
                IF cl_null(g_omf[l_ac].omf915) THEN LET g_omf[l_ac].omf915 = 0 END IF
                #FUN-C60036--add--end
                IF (g_omf[l_ac].omf19 + g_omf[l_ac].omf19x <> g_omf[l_ac].omf19t) OR
                   (g_omf[l_ac].omf29 + g_omf[l_ac].omf29x <> g_omf[l_ac].omf29t) THEN
                   IF NOT cl_confirm('axr-181') THEN
                    NEXT FIELD omf19
                   END IF
                END IF
                UPDATE omf_file SET omf21=g_omf[l_ac].omf21,
                                    omf09=g_omf[l_ac].omf09,
                                    omf10=g_omf[l_ac].omf10,
                                    omf11=g_omf[l_ac].omf11,
                                    omf12=g_omf[l_ac].omf12, 
                                    omf25=g_omf[l_ac].omf25,    #FUN-D10082 add  
                                    omf26=g_omf[l_ac].omf26,    #FUN-D10082 add
                                    omf13=g_omf[l_ac].omf13, 
                                    omf14=g_omf[l_ac].omf14,
                                    omf15=g_omf[l_ac].omf15, 
                                    omf23=g_omf[l_ac].omf23, #FUN-C60036 add
                                    omf20=g_omf[l_ac].omf20, 
                                    omf201=g_omf[l_ac].omf201,
                                    omf202=g_omf[l_ac].omf202,#FUN-C60036 add
                                    omf16=g_omf[l_ac].omf16,
                                    omf17=g_omf[l_ac].omf17,
                                    #FUN-C60036--add--str
                                    omf910=g_omf[l_ac].omf910,
                                    omf911=g_omf[l_ac].omf911,
                                    omf912=g_omf[l_ac].omf912,
                                    omf913=g_omf[l_ac].omf913,
                                    omf914=g_omf[l_ac].omf914,
                                    omf915=g_omf[l_ac].omf915,
                                    omf916=g_omf[l_ac].omf916,
                                    omf917=g_omf[l_ac].omf917,
                                    #FUN-C60036--add--end
                                    omf18=g_omf[l_ac].omf18,
                                    omf19=g_omf[l_ac].omf19,
                                    omf19x=g_omf[l_ac].omf19x,
                                    omf19t=g_omf[l_ac].omf19t,
                                    omf28=g_omf[l_ac].omf28,
                                    omf29=g_omf[l_ac].omf29,
                                    omf29x=g_omf[l_ac].omf29x,
                                    omf29t=g_omf[l_ac].omf29t
               # WHERE omf01=g_omf_1_t.omf01   #FUN-C60033
               #   AND omf02=g_omf_1_t.omf02   #FUN-C60033
                 WHERE omf00=g_omf_1.omf00   #FUN-C60033
                   #AND omf09=g_omf_t.omf21    #FUN-C60036 mark
                   AND omf21 = g_omf_t.omf21   #FUN-C60036 add
                
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","omf_file","","",SQLCA.sqlcode,"","",1)
                   LET g_omf[l_ac].* = g_omf_t.*
                   ROLLBACK WORK
                   EXIT INPUT
                ELSE
                  MESSAGE 'UPDATE O.K' 
                  COMMIT WORK 
                   #str------- add by dengsy160614
                    let l_ogc12 =0
                     let l_ogc12_1 =0
                     let l_count5=0
                    select sum(ogc12) into l_ogc12 from ogc_file 
                     where ogc01=g_omf[l_ac].omf11  and ogc03=g_omf[l_ac].omf12
                      select sum(ogc12) into l_ogc12_1 from ogc_file 
                     where ogc01=g_omf_1.omf00  and ogc03=g_omf_t.omf21
                      select count(*) into l_count5 from ogc_file 
                     where ogc01=g_omf[l_ac].omf11  and ogc03=g_omf[l_ac].omf12
                      if l_count5=1 then 
  										update ogc_file set ogc12=g_omf[l_ac].omf16,ogc16=g_omf[l_ac].omf16
  									   where ogc01=g_omf_1.omf00  and ogc03= g_omf_t.omf21
  									end if
  									if l_count5>=1 then 
  									     
  									    let l_ogc12 =g_omf[l_ac].omf16 -l_ogc12_1
  									    update ogc_file set ogc12=ogc12+l_ogc12
  									    where ogc01=g_omf_1.omf00  and ogc03= g_omf_t.omf21
  									     and ogc12>l_ogc12 and rownum=1
  									      update ogc_file set ogc16=ogc12
  									    where ogc01=g_omf_1.omf00  and ogc03= g_omf_t.omf21
  									     
  									end if
                     #end------ add by dengsy160614
                END IF              
           #END IF          #FUN-C60036 
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac      #FUN-D30034 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_omf[l_ac].* = g_omf_t.*
              #FUN-D30034--add--str--
              ELSE
                 CALL g_omf.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 ELSE                   #TQC-D40067 add
                    CLEAR FORM          #TQC-D40067 add
                    CALL g_omf.clear()  #TQC-D40067 add                    
                 END IF
              #FUN-D30034--add--end--
              END IF
              CLOSE t670_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
          # IF (g_omf[l_ac].omf19 + g_omf[l_ac].omf19x <> g_omf[l_ac].omf19t) OR
          #    (g_omf[l_ac].omf29 + g_omf[l_ac].omf29x <> g_omf[l_ac].omf29t) THEN
          #    IF NOT cl_confirm('axr-181') THEN
          #       NEXT FIELD omf19
          #    END IF
          # END IF
           LET l_ac_t = l_ac      #FUN-D30034 Add
           CLOSE t670_bcl
           COMMIT WORK
           SELECT SUM(omf19),SUM(omf19x),SUM(omf19t),SUM(omf29),SUM(omf29x),SUM(omf29t)
              INTO g_omf_1.omf19_sum,g_omf_1.omf19x_sum,g_omf_1.omf19t_sum,g_omf_1.omf29_sum,g_omf_1.omf29x_sum,g_omf_1.omf29t_sum
              FROM omf_file
            #WHERE omf01 = g_omf_1.omf01    #FUN-C60033
            #  AND omf02 = g_omf_1.omf02    #FUN-C60033
             WHERE omf00 = g_omf_1.omf00
        #  #FUN-C60036--add--str
        #   SELECT SUM(omf19) INTO l_omf19s FROM omf_file
        #   WHERE omf00 = g_omf_1.omf00
        #      AND omf10 = '1'
        #  SELECT SUM(omf19) INTO l_omf19z FROM omf_file
        #   WHERE omf00 = g_omf_1.omf00
        #     AND omf10 = '2'
        #  IF cl_null(l_omf19s) THEN LET l_omf19s = 0 END IF
        #  IF cl_null(l_omf19z) THEN LET l_omf19z = 0 END IF
        #  IF l_omf19s > 0 AND l_omf19z < 0 THEN
        #     IF (l_omf19s + l_omf19z)< 0  THEN
        #        CALL cl_err('','gap-003',1)
        #        NEXT FIELD omf11
        #     END IF
        #  END IF
        #  #FUN-C60036--add--end
           CALL t670_upd_show_diff() #MOD-D60161 add 
           #FUN-C60036--add--str
            LET g_omf_1.omf19_sum = cl_digcut(g_omf_1.omf19_sum,g_azi04)
            LET g_omf_1.omf19x_sum = cl_digcut(g_omf_1.omf19x_sum,g_azi04)
            LET g_omf_1.omf19t_sum = cl_digcut(g_omf_1.omf19t_sum,g_azi04)
            LET g_omf_1.omf29_sum = cl_digcut(g_omf_1.omf29_sum,t_azi04)
            LET g_omf_1.omf29x_sum = cl_digcut(g_omf_1.omf29x_sum,t_azi04)
            LET g_omf_1.omf29t_sum = cl_digcut(g_omf_1.omf29t_sum,t_azi04)
            #FUN-C60036--add--end
            #MOD-CB0040 add beg-------
            LET l_slip=s_get_doc_no(g_omf_1.omf00)      
            SELECT oay13,oay14 INTO l_oay13,l_oay14 FROM oay_file WHERE oayslip = l_slip
            IF l_oay13 = 'Y' THEN
               IF g_omf_1.omf19t_sum > l_oay14 THEN
                  CALL cl_err(l_oay14,'axm-700',1)
               END IF
            END IF   
            #MOD-CB0040 add end--------             
            #DISPLAY BY NAME g_omf_1.omf19_sum,g_omf_1.omf19x_sum,g_omf_1.omf19t_sum,g_omf_1.omf29_sum,g_omf_1.omf29x_sum,g_omf_1.omf29t_sum
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(omf09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azw"
                 LET g_qryparam.default1 = g_omf[l_ac].omf09
                 LET g_qryparam.where = "azw02 = '",g_legal,"' "
                 CALL cl_create_qry() RETURNING g_omf[l_ac].omf09
                 DISPLAY g_omf[l_ac].omf09 TO omf09
                 NEXT FIELD omf09
              #FUN-D10082--add--str--
              WHEN INFIELD(omf25)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oea01_2"
	             LET g_qryparam.default1 = g_omf[l_ac].omf25
                 CALL cl_create_qry() RETURNING g_omf[l_ac].omf25
                 DISPLAY g_omf[l_ac].omf25 TO omf25
                 NEXT FIELD omf25
              #FUN-D10082--add--end--
              WHEN INFIELD(omf11)
                #FUN-C60036-add-str
              IF cl_null(g_omf_t.omf11) AND cl_null(g_omf_t.omf12)  THEN#TQC-D20046 add omf12
                 LET g_omf11_str = ''
                 CASE g_omf[l_ac].omf10
                    WHEN '1'
                       CALL cq_ogb5(TRUE,TRUE,g_omf_1.omf05,g_omf_1.omf05,g_omf_1.omf06,
                                   g_omf_1.omf07,g_omf[l_ac].omf09,g_omf_1.omf00,g_omf_1.omf03) RETURNING g_omf11_str,g_omf[l_ac].omf12  #MOD-CC0049 add g_omf_1.omf03
                    WHEN '2'
                       CALL q_ohb4(TRUE,TRUE,g_omf_1.omf05,g_omf_1.omf05,g_omf_1.omf06,
                                   g_omf_1.omf07,g_omf[l_ac].omf09,g_omf_1.omf00,g_omf_1.omf03) RETURNING g_omf11_str,g_omf[l_ac].omf12  #MOD-CC0049 add g_omf_1.omf03
                 END CASE 
                 IF cl_null(g_omf11_str) THEN
                    LET g_omf[l_ac].omf11 = g_omf_t.omf11
                    LET g_omf[l_ac].omf12 = g_omf_t.omf12
                    NEXT FIELD omf11
                 END IF
                 LET g_success = 'Y'
                 LET l_errno = 0 
                 LET bst= base.StringTokenizer.create(g_omf11_str,'|')
                 CALL s_showmsg_init()
                 WHILE bst.hasMoreTokens()
                    LET temptext=bst.nextToken()
                    LET g_omf[l_ac].omf11 = temptext.substring(1,temptext.getIndexOf(",",1)-1)
                    LET g_omf[l_ac].omf12=temptext.substring(temptext.getIndexOf(",",1)+1,temptext.getlength())
                    CALL t670_omf12()
                  #TQC-D40067--add--begin---
                    LET l_n = 0
                    SELECT COUNT(*) INTO l_n FROM omf_file
                     WHERE omf00 = g_omf_1.omf00 
                    IF l_n = 0 THEN    #單身錄入第一筆資料時單頭發票號碼自動編號
                       CALL s_auto_assign_no("axm",g_omf_1.omf00,g_omf_1.omf03,"","omf_file","omf00","","","")
                            RETURNING li_result,g_omf_1.omf00
                       IF (NOT li_result) THEN
                          EXIT INPUT
                       END IF
                       DISPLAY BY NAME g_omf_1.omf00
                    END IF
                  #TQC-D40067--add--end----                    
                    IF g_sma.sma115 = 'Y' THEN
                       CALL t670_b_ogg()
                    ELSE
                       CALL t670_b_ogc()
                    END IF
                    LET l_omf.omf00=g_omf_1.omf00                     
                    LET l_omf.omf01=g_omf_1.omf01
                    LET l_omf.omf02=g_omf_1.omf02
                    LET l_omf.omf03=g_omf_1.omf03
                    LET l_omf.omf05=g_omf_1.omf05
                    LET l_omf.omf051=g_omf_1.omf051
                    LET l_omf.omf06=g_omf_1.omf06
                    LET l_omf.omf061=g_omf_1.omf061
                    LET l_omf.omf07=g_omf_1.omf07
                    LET l_omf.omf22=g_omf_1.omf22
                    LET l_omf.omf31=g_omf_1.omf31        #FUN-D50008 add
                    LET l_omf.omf32=g_omf_1.omf32        #FUN-D50007 add
                    LET l_omf.omf33=g_omf_1.omf33        #FUN-D50007 add
                    LET l_omf.omfuser = g_omf_1.omfuser  #FUN-D50009 add
                    LET l_omf.omfgrup = g_omf_1.omfgrup  #FUN-D50009 add
                    LET l_omf.omforiu = g_omf_1.omforiu  #FUN-D50009 add
                    LET l_omf.omforig = g_omf_1.omforig  #FUN-D50009 add
                    LET l_omf.omfmodu = g_omf_1.omfmodu  #FUN-D50009 add
                    LET l_omf.omfdate = g_omf_1.omfdate  #FUN-D50009 add
                    LET l_omf.omf08='N'
                    LET l_omf.omf21=g_omf[l_ac].omf21
                    LET l_omf.omf09=g_omf[l_ac].omf09
                    LET l_omf.omf10=g_omf[l_ac].omf10
                    LET l_omf.omf11=g_omf[l_ac].omf11
                    LET l_omf.omf12=g_omf[l_ac].omf12
                    #FUN-D10082--add--str--
                    IF g_omf[l_ac].omf10 = '9'  THEN
                       CALL cl_set_comp_entry('omf25,omf26',TRUE) 
                    ELSE
                       CALL cl_set_comp_entry('omf25,omf26',FALSE)
                       IF g_omf[l_ac].omf10 = '1' THEN 
                          SELECT ogb31,ogb32 INTO g_omf[l_ac].omf25,g_omf[l_ac].omf26
                            FROM ogb_file 
                           WHERE ogb01 = g_omf[l_ac].omf11
                             AND ogb03 = g_omf[l_ac].omf12
                       END IF 
                       IF g_omf[l_ac].omf10 = '2' THEN 
                          SELECT ohb33,ohb34 INTO g_omf[l_ac].omf25,g_omf[l_ac].omf26
                            FROM ohb_file 
                           WHERE ohb01 = g_omf[l_ac].omf11
                             AND ohb03 = g_omf[l_ac].omf12
                       END IF
                    END IF 
                    LET l_omf.omf25=g_omf[l_ac].omf25                     
                    LET l_omf.omf26=g_omf[l_ac].omf26                     
                    #FUN-D10082--add--end--
                    LET l_omf.omf13=g_omf[l_ac].omf13
                    LET l_omf.omf14=g_omf[l_ac].omf14
                    LET l_omf.omf15=g_omf[l_ac].omf15     ##FUN-C60036 minpp--0718
                    LET l_omf.omf16=g_omf[l_ac].omf16
                    LET l_omf.omf17=g_omf[l_ac].omf17
                    LET l_omf.omf18=g_omf[l_ac].omf18
                    LET l_omf.omf19=g_omf[l_ac].omf19
                    LET l_omf.omf19x=g_omf[l_ac].omf19x
                    LET l_omf.omf19t=g_omf[l_ac].omf19t
                    LET l_omf.omf28=g_omf[l_ac].omf28
                    LET l_omf.omf29=g_omf[l_ac].omf29
                    LET l_omf.omf29x=g_omf[l_ac].omf29x
                    LET l_omf.omf29t=g_omf[l_ac].omf29t
                    LET l_omf.omf20=g_omf[l_ac].omf20
                    LET l_omf.omf201=g_omf[l_ac].omf201
                    LET l_omf.omflegal=g_legal
                    LET l_omf.omfpost='N'
                    LET l_omf.omf23=g_omf[l_ac].omf23
                    LET l_omf.omf202=g_omf[l_ac].omf202
                    LET l_omf.omf910=g_omf[l_ac].omf910
                    LET l_omf.omf911=g_omf[l_ac].omf911
                    LET l_omf.omf912=g_omf[l_ac].omf912
                    LET l_omf.omf913=g_omf[l_ac].omf913
                    LET l_omf.omf914=g_omf[l_ac].omf914
                    LET l_omf.omf915=g_omf[l_ac].omf915
                    LET l_omf.omf916=g_omf[l_ac].omf916
                    LET l_omf.omf917=g_omf[l_ac].omf917
                    IF cl_null(l_omf.omf02) THEN LET l_omf.omf02 = ' ' END IF
                    IF cl_null(l_omf.omf16) THEN LET l_omf.omf16=0 END IF
                    IF cl_null(l_omf.omf18) THEN LET l_omf.omf18=0 END IF
                    IF cl_null(l_omf.omf19) THEN LET l_omf.omf19=0 END IF
                    IF cl_null(l_omf.omf19x) THEN LET l_omf.omf19x=0 END IF
                    IF cl_null(l_omf.omf19t) THEN LET l_omf.omf19t=0 END IF
                    IF cl_null(l_omf.omf28) THEN LET l_omf.omf28=0 END IF
                    IF cl_null(l_omf.omf29) THEN LET l_omf.omf29=0 END IF
                    IF cl_null(l_omf.omf29x) THEN LET l_omf.omf29x=0 END IF
                    IF cl_null(l_omf.omf29t) THEN LET l_omf.omf29t=0 END IF
                    IF cl_null(l_omf.omf23) THEN LET l_omf.omf23='N' END IF
                    #IF cl_null(l_omf.omf910) THEN LET l_omf.omf910=0  END IF #MOD-CC0257 mark
                    IF cl_null(l_omf.omf911) THEN LET l_omf.omf911=0 END IF
                    IF cl_null(l_omf.omf912) THEN LET l_omf.omf912=0 END IF
                    #IF cl_null(l_omf.omf913) THEN LET l_omf.omf913=0  END IF #MOD-CC0257 mark
                    IF cl_null(l_omf.omf914) THEN LET l_omf.omf914=0 END IF
                    IF cl_null(l_omf.omf915) THEN LET l_omf.omf915=0 END IF
                    #IF cl_null(l_omf.omf916) THEN LET l_omf.omf916=0  END IF #MOD-CC0257 mark
                    IF cl_null(l_omf.omf917) THEN LET l_omf.omf917=0 END IF
                    LET l_omf.omf24 = ''
                    LET l_n = 0 
                    SELECT COUNT(*) INTO l_n FROM omf_file
                     WHERE omf00 = l_omf.omf00  AND omf11 = l_omf.omf11
                       AND omf12 = l_omf.omf12
                    IF l_n = 0 THEN 
                    IF cl_null(l_omf.omf01) THEN LET l_omf.omf01 = ' ' END IF #FUN-CA0084 add
                    INSERT INTO omf_file VALUES(l_omf.*)
                    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                       CALL s_errmsg('omf11','',l_omf.omf11,SQLCA.sqlcode,1)
                       LET g_success = 'N'
                    ELSE
                       LET l_errno = l_errno +1
                       LET g_omf[l_ac+1].omf09 = g_omf[l_ac].omf09
                       LET g_omf[l_ac+1].omf10 = g_omf[l_ac].omf10 
                       LET g_omf[l_ac+1].omf21 = g_omf[l_ac].omf21 +1
                       IF g_oaz.oaz93 = 'Y' THEN
                         LET g_omf[l_ac+1].omf20 = g_oaz.oaz95
                         LET g_omf[l_ac+1].omf201 = g_omf_1.omf05
                       END IF
                       #str------- add by dengsy160614
                    let l_ogc12 =0
                     let l_ogc12_1 =0
                     let l_count5=0
                    select sum(ogc12) into l_ogc12 from ogc_file 
                     where ogc01=g_omf[l_ac].omf11  and ogc03=g_omf[l_ac].omf12
                      select sum(ogc12) into l_ogc12_1 from ogc_file 
                     where ogc01=g_omf_1.omf00  and ogc03=g_omf_t.omf21
                      select count(*) into l_count5 from ogc_file 
                     where ogc01=g_omf[l_ac].omf11  and ogc03=g_omf[l_ac].omf12
                      if l_count5=1 then 
  										update ogc_file set ogc12=g_omf[l_ac].omf16,ogc16=g_omf[l_ac].omf16
  									   where ogc01=g_omf_1.omf00  and ogc03= g_omf_t.omf21
  									end if
  									if l_count5>=1 then 
  									     
  									    let l_ogc12 =g_omf[l_ac].omf16 -l_ogc12_1
  									    update ogc_file set ogc12=ogc12+l_ogc12
  									    where ogc01=g_omf_1.omf00  and ogc03= g_omf_t.omf21
  									     and ogc12>l_ogc12 and rownum=1
  									      update ogc_file set ogc16=ogc12
  									    where ogc01=g_omf_1.omf00  and ogc03= g_omf_t.omf21
  									     
  									end if
                     #end------ add by dengsy160614
                       LET l_ac = l_ac + 1
                    END IF 
                    ELSE
                       CALL s_errmsg('omf11,omf12','',l_omf.omf11 || '/' || l_omf.omf12,'axr-376',1)
                       LET g_success = 'N'
                    END IF 
                 END WHILE
                 CALL s_showmsg()
                 COMMIT WORK
                 IF l_errno = 0 THEN 
                    LET g_omf[l_ac].omf11 = ''
                    LET g_omf[l_ac].omf12 = ''
                    LET g_omf[l_ac].omf11 = g_omf_t.omf11
                    LET g_omf[l_ac].omf12 = g_omf_t.omf12
                    NEXT FIELD omf11
                 ELSE
                    CALL t670_b_fill(" 1=1")
                    CALL t670_b()
                    CALL t670_show() #add by dengsy170222
                 END IF 
                 EXIT INPUT
              ELSE
                 CASE g_omf[l_ac].omf10
                    WHEN '1'
                       CALL q_ogb5(FALSE,TRUE,g_omf_1.omf05,g_omf_1.omf05,g_omf_1.omf06,
                                   g_omf_1.omf07,g_omf[l_ac].omf09,g_omf_1.omf00,g_omf_1.omf03) RETURNING g_omf[l_ac].omf11,g_omf[l_ac].omf12 #MOD-CC0049 add g_omf_1.omf03
                    WHEN '2'
                       CALL q_ohb4(FALSE,TRUE,g_omf_1.omf05,g_omf_1.omf05,g_omf_1.omf06,
                                   g_omf_1.omf07,g_omf[l_ac].omf09,g_omf_1.omf00,g_omf_1.omf03) RETURNING g_omf[l_ac].omf11,g_omf[l_ac].omf12 #MOD-CC0049 add g_omf_1.omf03
                 END CASE
                 IF cl_null(g_omf[l_ac].omf11) THEN 
                    LET g_omf[l_ac].omf11 = g_omf_t.omf11
                    LET g_omf[l_ac].omf12 = g_omf_t.omf12
                 ELSE
                    CALL t670_omf12() 
                 END IF
              END IF    
                #FUN-C60036--add--end
                 #FUN-C60036--mark--str
              	 #IF g_omf[l_ac].omf10 = '1' THEN
                 #   CALL cl_init_qry_var()
                 #   LET g_qryparam.form ="q_ogb01"
                 #   LET g_qryparam.arg1 = g_omf_1.omf05
                 #   LET g_qryparam.where = "( oga09='2' OR oga09='3' OR oga09='4' OR oga09='5' OR oga09='6' OR oga09='8' OR oga09='A')  "
                 #   LET g_qryparam.where = " (oga00='1' OR oga00='4' OR oga00='5' OR oga00='6' OR oga00='B') "
                 #   LET g_qryparam.where = " (oga65='N' AND ogapost='Y') "
                 #ELSE
               	 #   CALL cl_init_qry_var()
                 #   LET g_qryparam.form ="q_ohb04"
                 #   LET g_qryparam.arg1 = g_omf_1.omf05                   
                 #END IF
                 #CALL cl_create_qry() RETURNING g_omf[l_ac].omf11,g_omf[l_ac].omf12
                 #FUN-C60036--mark--end
                 DISPLAY BY NAME g_omf[l_ac].omf11
                 NEXT FIELD omf11
                
             #FUN-D50006--add---begin---
               WHEN INFIELD(omf17)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1 = g_omf[l_ac].omf17
                  CALL cl_create_qry() RETURNING g_omf[l_ac].omf17
                  DISPLAY BY NAME g_omf[l_ac].omf17
                  NEXT FIELD omf17
             #FUN-D50006--add---end---
 
               #FUN-C60036--add--str
               WHEN INFIELD(omf910)
               	  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1 = g_omf[l_ac].omf910                 
                  CALL cl_create_qry() RETURNING g_omf[l_ac].omf910
                  DISPLAY BY NAME g_omf[l_ac].omf910
                  NEXT FIELD omf910
               WHEN INFIELD(omf913)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1 = g_omf[l_ac].omf913                
                  CALL cl_create_qry() RETURNING g_omf[l_ac].omf913
                  DISPLAY BY NAME g_omf[l_ac].omf913
                  NEXT FIELD omf913
               WHEN INFIELD(omf916)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1 = g_omf[l_ac].omf916                
                  CALL cl_create_qry() RETURNING g_omf[l_ac].omf916
                  DISPLAY BY NAME g_omf[l_ac].omf916
                  NEXT FIELD omf916
               #FUN-C60036--add--end
               OTHERWISE EXIT CASE
            END CASE
      
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(omf02) AND l_ac > 1 THEN
              LET g_omf[l_ac].* = g_omf[l_ac-1].*
              LET g_omf[l_ac].omf11 = 0   #No.MOD-8B0203 add
              NEXT FIELD omf02
           END IF
 
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
      #FUN-C60036--add--str
      ON ACTION mntn_inv_detail                                                                                                     
         IF g_omf[l_ac].omf23 = 'Y' THEN                                                                                            
            IF g_sma.sma115 = 'Y' THEN                                                                                              
               CALL t670_b_ogg()                                                                                                    
            ELSE                                                                                                                                                                                                                               
               CALL t670_b_ogc()                                                                                                                                                                                                             
            END IF                                                                                                                  
         END IF
      #FUN-C60036--add--end
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
    END INPUT
    #No.MOD-CC0087  --Begin
    LET l_cnt1 = 0
    SELECT COUNT(*) INTO l_cnt1 FROM omf_file
     WHERE omf00 = g_omf_1.omf00
       AND omf10 = '1'
    IF cl_null(l_cnt1) THEN LET l_cnt1 = 0 END IF

    LET l_sum = 0
    SELECT SUM(omf19) INTO l_sum FROM omf_file
     WHERE omf00 = g_omf_1.omf00
    IF cl_null(l_sum) THEN LET l_sum = 0 END IF

    IF l_cnt1 > 0 AND l_sum < 0 THEN
       CALL cl_err('','gap-003',1)
       CALL t670_b()
       CALL t670_show() #add by dengsy170222
    END IF

    UPDATE omf_file SET omf_file.omfmodu = g_user,       #FUN-D50009 add
                        omf_file.omfdate = g_today       #FUN-D50009 add
                    WHERE omf_file.omf00 = g_omf_1.omf00 #FUN-D50009 add

    ##FUN-C60036--add--str
    #LET li_cnt = 0 
    #SELECT COUNT(*) INTO li_cnt FROM omf_file
    # WHERE omf00 = g_omf_1.omf00
    #   AND omf10 != '2'
    #IF li_cnt > 0 THEN
    #   LET li_cnt = 0
    #   SELECT COUNT(*) INTO li_cnt FROM omf_file
    #    WHERE omf00 = g_omf_1.omf00
    #      AND omf10 = '2'
    #   IF li_cnt > 0 THEN 
    #      SELECT SUM(omf19) INTO l_omf19s FROM omf_file
    #       WHERE omf00 = g_omf_1.omf00
    #         AND omf10 != '2'
    #      SELECT SUM(omf19) INTO l_omf19z FROM omf_file
    #       WHERE omf00 = g_omf_1.omf00
    #         AND omf10 = '2'
    #      IF cl_null(l_omf19s) THEN LET l_omf19s = 0 END IF
    #      IF cl_null(l_omf19z) THEN LET l_omf19z = 0 END IF
    #      IF (l_omf19s + l_omf19z)< 0  THEN
    #         CALL cl_err('','gap-003',1)
    #         CALL t670_b() 
    #      END IF
    #   END IF 
    #END IF 
    ##FUN-C60036--add--end
    #No.MOD-CC0087  --End
    CLOSE t670_bcl
    COMMIT WORK

 
END FUNCTION
 
 
FUNCTION t670_b_askkey()
DEFINE
    l_wc    STRING   #MOD-8B0084
 
    CONSTRUCT l_wc ON omf21,omf09,omf10,omf11,omf12,omf25,omf26, #FUN-D10082 add omf25,omf26
                      omf13,omf14,omf15,omf20,omf201,omf16,
                      omf17,omf18,omf29,omf29t,omf29x,omf19,omf19t,omf19x
                 FROM s_omf[1].omf21,s_omf[1].omf09,s_omf[1].omf10,s_omf[1].omf11,
                      s_omf[1].omf12,s_omf[1].omf25,s_omf[1].omf26,  #FUN-D10082 add omf25,omf26
                      s_omf[1].omf13,s_omf[1].omf14,s_omf[1].omf15,s_omf[1].omf20,  
                      s_omf[1].omf201,s_omf[1].omf16,s_omf[1].omf17,s_omf[1].omf18,
                      s_omf[1].omf29,s_omf[1].omf29t,s_omf[1].omf29x,s_omf[1].omf28,
                      s_omf[1].omf19,s_omf[1].omf19t,s_omf[1].omf19x
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
 
    IF INT_FLAG THEN RETURN END IF
 
    CALL t670_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION t670_b_fill(p_wc)              #BODY FILL UP
DEFINE p_wc   STRING   #MOD-8B0084
DEFINE omf16_sum  LIKE omf_file.omf16  #add by dengsy160527 
 
   LET g_sql = "SELECT omf21,omf09,omf10,omf11,omf12,'','',omf25,omf26,omf13,omf14,'',", #'' add by huanglf170313#FUN-D10082 add  omf25,omf26  #add '' by dengsy160527
               "       omf23,omf20,omf201,omf202,omf16,",#FUN-C60036 add omf23,omf202   #FUN-C60036 minpp--0718 mod-omf15-->''
               "       omf17,omf913,omf914,omf915,omf910,omf911,omf912,omf916,omf917 ,",
              #"       '',omf28,omf29,omf29x,omf29t,omf18,omf19,omf19x,omf19t,omf04 ",#FUN-C60036 add omf04#FUN-D20003 mark
               "       '',omf28,omf29,omf29x,omf29t,omf18,omf19,omf19x,omf19t",#FUN-D20003 add
               " FROM omf_file ",
             # " WHERE omf01 = '",g_omf_1.omf01,"'",   #FUN-C60033
             # "   AND omf02 = '",g_omf_1.omf02,"'",   #FUN-C60033
               " WHERE omf00 = '",g_omf_1.omf00,"'",   #FUN-C60033
               "   AND ",p_wc CLIPPED,
               " ORDER BY omf21,omf09,omf10,omf11"
   PREPARE t670_prepare2 FROM g_sql      #預備一下
   DECLARE omf_curs CURSOR FOR t670_prepare2
 
   CALL g_omf.clear()
   LET g_cnt = 1
   LET omf16_sum=0  #add by dengsy160527
 
   FOREACH omf_curs INTO g_omf[g_cnt].*   #單身 ARRAY 填充
    	IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_plant_new = g_omf[g_cnt].omf09#FUN-C60036 add
    	IF g_omf[g_cnt].omf10 = '1' THEN
        LET g_sql = "SELECT ogb14,ogb11 ",  #add ogb11 by dengsy160527
                   "  FROM ",cl_get_target_table(g_plant_new,'ogb_file'),
                   " WHERE ogb01 = '",g_omf[g_cnt].omf11,"' ",
                   "   AND ogb03 = '",g_omf[g_cnt].omf12,"' "    
      ELSE
 	       LET g_sql = "SELECT ohb14,ohb11 ",  #add ohb11 by dengsy160527
                    "  FROM ",cl_get_target_table(g_plant_new,'ohb_file'),
                     " WHERE ohb01 = '",g_omf[g_cnt].omf11,"' ",
                    "   AND ohb03 = '",g_omf[g_cnt].omf12,"' "

      END IF   
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql    	
	    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql        
      PREPARE sel_ogb14_pre1 FROM g_sql
      EXECUTE sel_ogb14_pre1 INTO g_omf[g_cnt].ogb14,g_omf[g_cnt].ogb11  #add g_omf[g_cnt].ogb11 by dengsy160527
      DISPLAY BY NAME g_omf[g_cnt].ogb14
      DISPLAY BY NAME g_omf[g_cnt].ogb11  #add by dengsy160527
      #str-----add by huanglf170313
         LET g_omf[g_cnt].oga011 = NULL
         SELECT (CASE WHEN oga09='8' THEN oga011 ELSE oga01 end) INTO g_omf[g_cnt].oga011 FROM oga_file
         WHERE oga01 = g_omf[g_cnt].omf11
      #str-----end by huanglf170313
      IF g_omf[g_cnt].omf10<>'9' THEN  #TAC-D20009 add
         SELECT ima021 INTO g_omf[g_cnt].omf15 FROM ima_file WHERE ima01=g_omf[g_cnt].omf13   ##FUN-C60036 minpp--0718--add  
      END IF
      LET omf16_sum=omf16_sum+g_omf[g_cnt].omf16  #add by dengsy160527
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
      END IF
   END FOREACH
   CALL g_omf.deleteElement(g_cnt)
   LET g_rec_b =g_cnt -1
   DISPLAY g_rec_b TO FORMONLY.cn2
   DISPLAY BY NAME omf16_sum #add by dengsy160527
   LET g_cnt=0
END FUNCTION
 
FUNCTION t670_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   IF g_oaz.oaz93 = 'N' THEN 
      CALL cl_set_act_visible("deduct_inventory,undo_deduct", FALSE)
   END IF 
   DISPLAY ARRAY g_omf TO s_omf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
  BEFORE DISPLAY
     CALL cl_navigator_setting( g_curs_index, g_row_count )
  
  BEFORE ROW
     LET l_ac = ARR_CURR()
  CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 

  #FUN-D10091--add--star--
  ON ACTION Page2
     LET g_action_flag = "Page2"
     EXIT DISPLAY

  #FUN-D10091--add--end-- 
  ON ACTION insert
     LET g_action_choice="insert"
     EXIT DISPLAY
  ON ACTION query
     LET g_action_choice="query"
     EXIT DISPLAY
  ON ACTION delete
     LET g_action_choice="delete"
     EXIT DISPLAY
  ON ACTION first
     CALL t670_fetch('F')
     CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
       IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
       END IF
       ACCEPT DISPLAY  
  
  
  ON ACTION previous
     CALL t670_fetch('P')
     CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(1)  ######add in 040505
       END IF
	ACCEPT DISPLAY 
  
  
  ON ACTION jump
     CALL t670_fetch('/')
     CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(1)  ######add in 040505
       END IF
	ACCEPT DISPLAY
  
  
  ON ACTION next
     CALL t670_fetch('N')
     CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(1)  ######add in 040505
       END IF
	ACCEPT DISPLAY
  
  
  ON ACTION last
     CALL t670_fetch('L')
     CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(1)  ######add in 040505
       END IF
    ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
  
  ON ACTION issue_invoice
     LET g_action_choice="issue_invoice"
     EXIT DISPLAY

 #FUN-C60036--07/06--str
  ON ACTION maintain_invoice
     LET g_action_choice="maintain_invoice"
     EXIT DISPLAY
 #FUN-C60036--07/06--end
 #add by ly 20170222--s
   ON ACTION unit_price
     LET g_action_choice="unit_price"
     EXIT DISPLAY
 #add by ly 20170222--e
 #FUN-D20003--add--str
  ON ACTION bdfp
     LET g_action_choice="bdfp"
     EXIT DISPLAY
 #FUN-D20003--add--end
  ON ACTION modify
     LET g_action_choice="modify"
     EXIT DISPLAY
  ON ACTION detail
     LET g_action_choice="detail"
     LET l_ac = 1
     EXIT DISPLAY
     
  ON ACTION confirm
     LET g_action_choice="confirm"
     EXIT DISPLAY
  ON ACTION undo_confirm
     LET g_action_choice="undo_confirm"
     EXIT DISPLAY
#TQC-D20009---xj-add---str
# ON ACTION 作廢
  ON ACTION void
     LET g_action_choice="void"
    EXIT DISPLAY
#TQC-D20009---xj-add---end
# ON ACTION S.庫存扣帳
  ON ACTION deduct_inventory
     LET g_action_choice="deduct_inventory"
     EXIT DISPLAY
           
# ON ACTION Z.扣帳還原
  ON ACTION undo_deduct
     LET g_action_choice="undo_deduct"
     EXIT DISPLAY      
     
  #FUN-C60036--add--str
  ON ACTION spin_fin
     LET g_action_choice = "spin_fin"
     EXIT DISPLAY

  ON ACTION a_r
     LET g_action_choice="a_r"
     EXIT DISPLAy

  ON ACTION qry_mntn_inv_detail
     LET g_action_choice="qry_mntn_inv_detail"
     EXIT DISPLAY
  #FUN-C60036--add--end
  #tianry add 161110
   ON ACTION t670_sum_omf
    LET g_action_choice="t670_sum_omf"
     EXIT DISPLAY

    #tianry add end 
  #FUN-CB0040---add---str
  ON ACTION output
     LET g_action_choice="output"
         EXIT DISPLAY
  #FUN-CB0040--add--end

  ON ACTION help
     LET g_action_choice="help"
     EXIT DISPLAY
  
  ON ACTION locale
     CALL cl_dynamic_locale()
     CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    #FUN-C60033--add--str
      IF g_sma.sma122 ='1' THEN
         CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("omf913",g_msg CLIPPED)
         CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("omf915",g_msg CLIPPED)
         CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("omf910",g_msg CLIPPED)
         CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("omf912",g_msg CLIPPED)
      END IF

      IF g_sma.sma122 ='2' THEN
         CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("omf913",g_msg CLIPPED)
         CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("omf915",g_msg CLIPPED)
         CALL cl_getmsg('axm-567',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("omf910",g_msg CLIPPED)
         CALL cl_getmsg('axm-568',g_lang) RETURNING g_msg
         CALL cl_set_comp_att_text("omf912",g_msg CLIPPED)
      END IF 
     #FUN-C60033--add-end
  
  ON ACTION exit
     LET g_action_choice="exit"
     EXIT DISPLAY
  
  ##########################################################################
  # Special 4ad ACTION
  ##########################################################################
  ON ACTION controlg
     LET g_action_choice="controlg"
     EXIT DISPLAY
  
  ON ACTION accept
     LET g_action_choice="detail"
     LET l_ac = ARR_CURR()
     EXIT DISPLAY
  
  ON ACTION cancel
     LET INT_FLAG=FALSE 		#MOD-570244	mars
     LET g_action_choice="exit"
     EXIT DISPLAY
  
  ON IDLE g_idle_seconds
     CALL cl_on_idle()
     CONTINUE DISPLAY
  
  ON ACTION about         #MOD-4C0121
     CALL cl_about()      #MOD-4C0121
  
  
  ON ACTION exporttoexcel       #FUN-4B0025
     LET g_action_choice = 'exporttoexcel'
     EXIT DISPLAY
  
  AFTER DISPLAY
     CONTINUE DISPLAY
  
  ON ACTION controls                           #No.FUN-6B0032             
     CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
  
  ON ACTION related_document                #No.FUN-6A0162  相關文件
     LET g_action_choice="related_document"          
     EXIT DISPLAY
  
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION
 
FUNCTION t670_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("omf00,omf05,omf06,omf07,omf22",TRUE)#FUN-C60036
   END IF
END FUNCTION
 
FUNCTION t670_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("omf00,omf05,omf06,omf07,omf22",FALSE)  	  
   END IF
   CALL cl_set_comp_entry("omf20,omf201",FALSE)
END FUNCTION

 
FUNCTION t670_omf11()
   DEFINE l_n       LIKE type_file.num5,   
          l_oga03   LIKE oga_file.oga03,
          l_oga21   LIKE oga_file.oga21,
          l_oga23   LIKE oga_file.oga23,
          l_ogaconf LIKE oga_file.ogaconf, 
          l_oha03   LIKE oga_file.oga03,
          l_oha21   LIKE oha_file.oha21,
          l_oha23   LIKE oha_file.oha23,
          l_ohaconf LIKE oga_file.ogaconf,
          l_ogapost LIKE oga_file.ogapost, #MOD-CB0069 add
          l_ohapost LIKE oha_file.ohapost, #MOD-CB0069 add
          l_oga00   LIKE oga_file.oga00,   #MOD-CB0083 add
          l_oha09   LIKE oha_file.oha09,   #MOD-CB0083 add
          l_oga02   LIKE oga_file.oga02,   #MOD-CC0049 add 
          l_oha02   LIKE oha_file.oha02    #MOD-CC0049 add 
   DEFINE l_yy1,l_mm1 LIKE type_file.num5,   #MOD-CC0049 add
          l_yy2,l_mm2 LIKE type_file.num5    #MOD-CC0049 add
   DEFINE l_oga65   LIKE oga_file.oga65      #TQC-D20046 cj add

   LET g_errno = ''
   IF g_omf[l_ac].omf10 = '1' THEN
     #LET g_sql = "SELECT UNIQUE oga03,oga21,oga23,ogaconf,ogapost,oga00 FROM ",cl_get_target_table(g_omf[l_ac].omf09,'oga_file'),         #MOD-CC0049 mark
      LET g_sql = "SELECT UNIQUE oga02,oga03,oga21,oga23,ogaconf,ogapost,oga00,oga65 FROM ",cl_get_target_table(g_omf[l_ac].omf09,'oga_file'),   #MOD-CC0049 add oga02  #TQC--D20046 add oga65
               " WHERE oga01 = '",g_omf[l_ac].omf11,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql      				
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql                           
      PREPARE sel_omf11_pre FROM g_sql
     #EXECUTE sel_omf11_pre INTO l_oga03,l_oga21,l_oga23,l_ogaconf,l_ogapost,l_oga00 #MOD-CB0069 add l_ogapost #MOD-CB0083 add oga00          #MOD-CC0049 mark
      EXECUTE sel_omf11_pre INTO l_oga02,l_oga03,l_oga21,l_oga23,l_ogaconf,l_ogapost,l_oga00,l_oga65 #MOD-CB0069 add l_ogapost #MOD-CB0083 add oga00  #MOD-CC0049 add oga02  #TQC--D20046 add oga65
   #  CALL s_yp(l_oga02) RETURNING l_yy1,l_mm1        #MOD-CC0049 add   #TQC-D20046 cj mark
   #  CALL s_yp(g_omf_1.omf03) RETURNING l_yy2,l_mm2  #MOD-CC0049 add   #TQC-D20046 cj mark
      CASE
         WHEN SQLCA.SQLCODE = 100         LET g_errno = 'atm-151'
         WHEN l_oga03 != g_omf_1.omf05    LET g_errno = 'aap-040' 
         WHEN l_oga21 != g_omf_1.omf06    LET g_errno = 'axm-142'
         WHEN l_oga23 != g_omf_1.omf07    LET g_errno = 'alm-730'
         WHEN l_ogaconf != 'Y'            LET g_errno = 'anm-960'
         WHEN l_ogapost != 'Y'            LET g_errno = 'axm-713' #MOD-CB0069
         WHEN l_oga00    = '2'            LET g_errno = 'axm-718' #MOD-CB0083  
    #    WHEN l_yy1 > l_yy2 OR (l_yy1 = l_yy2 AND l_mm1 > l_mm2) #MOD-CC0049 add  #TQC-D20046 cj mark
    #       LET g_errno = 'axm-772' #MOD-CC0049 add  #TQC-D20046 cj mark
         WHEN l_oga65 = 'Y'               LET g_errno = 'axr-399'   #TQC-D20046 cj add
      END CASE
    #TQC-D20046--cj--add--
      CALL s_yp(l_oga02) RETURNING l_yy1,l_mm1        #MOD-CC0049 add
      CALL s_yp(g_omf_1.omf03) RETURNING l_yy2,l_mm2  #MOD-CC0049 add
      IF l_yy1 > l_yy2 OR (l_yy1 = l_yy2 AND l_mm1 > l_mm2) THEN
         LET g_errno = 'axm-772'
      END IF
    #TQC-D20046--cj--add--
   ELSE
      IF g_omf[l_ac].omf10 = '2' THEN 
     #LET g_sql = "SELECT UNIQUE oha03,oha21,oha23,ohaconf,ohapost,oha09 FROM ",cl_get_target_table(g_omf[l_ac].omf09,'oha_file'),       #MOD-CC0049 mark
   	  LET g_sql = "SELECT UNIQUE oha02,oha03,oha21,oha23,ohaconf,ohapost,oha09 FROM ",cl_get_target_table(g_omf[l_ac].omf09,'oha_file'), #MOD-CC0049 add oha02
               " WHERE oha01 = '",g_omf[l_ac].omf11,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql      				
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql                           
      PREPARE sel_omf11_pre1 FROM g_sql
     #EXECUTE sel_omf11_pre1 INTO l_oha03,l_oha21,l_oha23,l_ohaconf,l_ohapost,l_oha09 #MOD-CB0069 add  l_ogapost #MOD-CB0083 add oha09          #MOD-CC0049 mark    
      EXECUTE sel_omf11_pre1 INTO l_oha02,l_oha03,l_oha21,l_oha23,l_ohaconf,l_ohapost,l_oha09 #MOD-CB0069 add  l_ogapost #MOD-CB0083 add oha09  #MOD-CC0049 add oha02
  #   CALL s_yp(l_oha02) RETURNING l_yy1,l_mm1        #MOD-CC0049 add  #TQC-D20046 cj add
  #   CALL s_yp(g_omf_1.omf03) RETURNING l_yy2,l_mm2  #MOD-CC0049 add  #TQC-D20046 cj add
      CASE
         WHEN SQLCA.SQLCODE = 100         LET g_errno = 'atm-029'
         WHEN l_oha03 != g_omf_1.omf05    LET g_errno = 'aap-040' 
         WHEN l_oha21 != g_omf_1.omf06    LET g_errno = 'axm-142'
         WHEN l_oha23 != g_omf_1.omf07    LET g_errno = 'alm-730'
         WHEN l_ohaconf != 'Y'            LET g_errno = 'anm-960'
         WHEN l_ohapost != 'Y'            LET g_errno = 'axm-713' #MOD-CB0069
         WHEN l_oha09 MATCHES '[23]'      LET g_errno = 'axm-719' ##MOD-CB0083 add oha09  
  #      WHEN l_yy1 > l_yy2 OR (l_yy1 = l_yy2 AND l_mm1 > l_mm2) #MOD-CC0049 add #TQC-D20046 cj add
  #         LET g_errno = 'axm-772' #MOD-CC0049 add              #TQC-D20046 cj add
      END CASE
    #TQC-D20046--cj--add--
         CALL s_yp(l_oha02) RETURNING l_yy1,l_mm1        #MOD-CC0049 add  #TQC-D20046 cj add
         CALL s_yp(g_omf_1.omf03) RETURNING l_yy2,l_mm2  #MOD-CC0049 add  #TQC-D20046 cj add
         IF l_yy1 > l_yy2 OR (l_yy1 = l_yy2 AND l_mm1 > l_mm2) THEN
            LET g_errno = 'axm-772'
         END IF
    #TQC-D20046--cj--add--
      END IF 
   END IF
   
END FUNCTION

FUNCTION t670_omf12()
   DEFINE g_omf11  LIKE omf_file.omf11,
          g_omf12  LIKE omf_file.omf12, 
          g_omf03  LIKE omf_file.omf03
          #g_omf04  LIKE omf_file.omf04#FUN-C60036--mark
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_gec04  LIKE gec_file.gec04
   DEFINE l_gec05  LIKE gec_file.gec05
   DEFINE l_oga24  LIKE oga_file.oga24
   #FUN-C60036--add--str
   DEFINE l_omf915 LIKE omf_file.omf915,
          l_omf912 LIKE omf_file.omf912,
          l_omf917 LIKE omf_file.omf917
   #FUN-C60036--add--end
   DEFINE li_cnt   LIKE type_file.num5 #MOD-CA0092 add 201211
   DEFINE l_oha09  LIKE oha_file.oha09 #MOD-CA0092
   DEFINE l_ogb1001 LIKE ogb_file.ogb1001 #MOD-CB0050 add 
   DEFINE l_cnt2         LIKE type_file.num5  #MOD-CB0050
      
  SELECT azi04 INTO t_azi04 FROM azi_file
             WHERE azi01 = g_omf_1.omf07
 
   LET g_errno = ''
   
   SELECT COUNT(*) INTO l_cnt FROM omf_file
    WHERE omf00 = g_omf_1.omf00
      AND omf11 = g_omf[l_ac].omf11
      AND omf12 = g_omf[l_ac].omf12
      AND omf21 <>g_omf[l_ac].omf21
   IF l_cnt>0 THEN
      LET g_errno = 'axr-376'
   END IF 
#MOD-CB0050 add beg-----------------
   IF g_omf[l_ac].omf10 = '1' THEN
      LET g_sql = "SELECT ogb1001",
                   "  FROM ",cl_get_target_table(g_plant_new,'ogb_file'),"",
                   " WHERE  ogb01 = '",g_omf[l_ac].omf11,"' ",
                   " AND ogb03 = '",g_omf[l_ac].omf12,"' " 
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE sel_ogb1001_pre FROM g_sql
      EXECUTE sel_ogb1001_pre INTO l_ogb1001  
      IF NOT cl_null(l_ogb1001) THEN 
      SELECT COUNT(*) INTO l_cnt2 FROM azf_file 
       WHERE azf01=l_ogb1001 
       AND azf02 = '2' 
       AND azf08 = 'Y'   
       AND azfacti = 'Y' 
      IF l_cnt2 > 0 THEN 
         #走開票流程時，對于原因碼為贈品（aooi313列入銷售費用為Y）的項次，
         #出貨過賬不應產生至發票倉，axmt670也不能針對此項次開票。
         LET g_errno = 'axm-717'
      END IF 
      END IF  
   END IF                 
#MOD-CB0050 add end-----------------   
   IF g_omf[l_ac].omf10 = '1' THEN
      LET g_sql = "SELECT ogb04,ogb06,ogb12,ogb05,ogb14,ogb13,gec04,gec05,oga24,",#FUN-C60036 add ,
                  " ogb092,ogb17,ogb913,ogb914,ogb910,ogb911,ogb915,ogb912,ogb917,ogb916 ", #FUN-C60036 add
                  " ,ogb11,oga011 ",   #add by dengsy160527 #add by huanglf170313
                   "  FROM ",cl_get_target_table(g_plant_new,'ogb_file'),",",
                             cl_get_target_table(g_plant_new,'oga_file'),",",
                             cl_get_target_table(g_plant_new,'gec_file'), 
                   " WHERE oga01 = ogb01 AND ogb01 = '",g_omf[l_ac].omf11,"' ",
                   "   AND ogb03 = '",g_omf[l_ac].omf12,"' ",
                   "   AND gec01 = oga21 ", #MOD-D40039 add ,
                   "   AND gec011 = '2' "   #MOD-D40039 add
     
   ELSE
      #MOD-CA0092--add--str--20121106
      IF g_omf[l_ac].omf10 = '2' THEN
         LET g_sql = " SELECT oha09 FROM ",cl_get_target_table(g_plant_new,'oha_file'),
                     "  WHERE oha01 = '",g_omf[l_ac].omf11,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
         PREPARE sel_oha09_pre_3 FROM g_sql
         EXECUTE sel_oha09_pre_3 INTO l_oha09
      END IF
     #MOD-CA0092--add--end--20121106
 	   LET g_sql = "SELECT ohb04,ohb06,ohb12,ohb05,ohb14,ohb13,gec04,gec05,oha24,",#FUN-C60036 add ,
                   " ohb092,'',ohb913,ohb914,ohb910,ohb911,ohb915,ohb912,ohb917,ohb916", #FUN-C60036 add
                   " ,ohb11,'' ",  #add by dengsy160527 #add by huanglf170313
                   "  FROM ",cl_get_target_table(g_plant_new,'ohb_file'),",",
                             cl_get_target_table(g_plant_new,'oha_file'),",",
                             cl_get_target_table(g_plant_new,'gec_file'), 
                   " WHERE oha01 = ohb01 AND ohb01 = '",g_omf[l_ac].omf11,"' ",
                   "   AND ohb03 = '",g_omf[l_ac].omf12,"' ",
                   "   AND gec01 = oha21 ", #MOD-D40039 add ,
                   "   AND gec011 = '2' "   #MOD-D40039 add
   END IF   
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql    	
	 CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql        
   PREPARE sel_ogb_pre FROM g_sql
   EXECUTE sel_ogb_pre INTO g_omf[l_ac].omf13,g_omf[l_ac].omf14, g_omf[l_ac].omf16,g_omf[l_ac].omf17,
                            g_omf[l_ac].ogb14,g_omf[l_ac].omf28,l_gec04,l_gec05,l_oga24, #FUN-C60036 add ,
                            #FUN-C60036--add-str
                            g_omf[l_ac].omf202,g_omf[l_ac].omf23,
                            g_omf[l_ac].omf913,g_omf[l_ac].omf914,
                            g_omf[l_ac].omf910,g_omf[l_ac].omf911,
                            g_omf[l_ac].omf915,g_omf[l_ac].omf912,g_omf[l_ac].omf917,
                            g_omf[l_ac].omf916
                            ,g_omf[l_ac].ogb11,g_omf[l_ac].oga011  #add by huanglf170313 #add by dengsy160527
                            #FUN-C60036--add--end


    #TQC-D20009--cj--add--
      IF STATUS THEN
         LET g_errno = 'axm-590'
         RETURN
      END IF
    #TQC-D20009--cj--add--
    SELECT ima021 INTO g_omf[l_ac].omf15 FROM ima_file WHERE ima01=g_omf[l_ac].omf13 #FUN-C60036 minpp--0718
    #FUN-C60036--add--str
    LET l_omf915 = 0
    LET l_omf912 = 0 
    LET l_omf917 = 0
    
    SELECT SUM(omf915),SUM(omf912),SUM(omf917) INTO l_omf915,l_omf912,l_omf917
      FROM omf_file
     WHERE omf11 = g_omf[l_ac].omf11 AND omf12 = g_omf[l_ac].omf12
    IF cl_null(l_omf915) THEN LET l_omf915 = 0 END IF 
    IF cl_null(l_omf912) THEN LET l_omf912 = 0 END IF 
    IF cl_null(l_omf917) THEN LET l_omf917 = 0 END IF 
    LET g_omf[l_ac].omf915 = g_omf[l_ac].omf915 - l_omf915
    LET g_omf[l_ac].omf912 = g_omf[l_ac].omf912 - l_omf912
   #LET g_omf[l_ac].omf917 = g_omf[l_ac].omf917 - l_omf917#FUN-CA0084 mark
    #FUN-CA0084--mod--str
    IF g_omf[l_ac].omf10 = '1' THEN 
       LET g_omf[l_ac].omf917 = g_omf[l_ac].omf917 - l_omf917
    ELSE
       LET g_omf[l_ac].omf917 = g_omf[l_ac].omf917+ l_omf917
    END IF 
    #FUN-CA0084--mod--end
    IF cl_null(g_omf[l_ac].omf917) THEN LET g_omf[l_ac].omf917 = g_omf[l_ac].omf16 END IF
    IF cl_null(g_omf[l_ac].omf16) THEN LET g_omf[l_ac].omf16 = g_omf[l_ac].omf917 END IF 
    IF cl_null(g_omf[l_ac].omf23) THEN LET g_omf[l_ac].omf23 = 'N' END IF#FUN-CA0084
   #IF g_sma.sma115 = 'N'  OR g_sma.sma116 = '0' THEN LET g_omf[l_ac].omf917 = g_omf[l_ac].omf16 END IF #FUN-CA0084 mark
  # #FUN-C60036 --add--end
    IF STATUS OR (g_omf[l_ac].omf917 = 0 AND l_oha09 !='5') OR (g_omf[l_ac].omf10 = '1' AND g_omf[l_ac].omf917 <= 0) THEN#MOD-CA0092 add OR g_omf[l_ac].omf917...
       IF g_omf[l_ac].omf10 = '1' THEN
          #MOD-CA0092--add--str-20121106
          IF g_omf[l_ac].omf917 <= 0 THEN
             LET g_errno = 'axm-590'
          ELSE
          #MOD-CA0092--add--end-20121106
             LET g_errno = 'atm-151' 
          END IF #MOD-CA0092
          #MOD-CA0092 --add--str
          LET g_omf[l_ac].omf16 = 0
          LET g_omf[l_ac].omf13 = ''
          LET g_omf[l_ac].omf14 = ''
          LET g_omf[l_ac].omf15 = ''
          LET g_omf[l_ac].omf17 = ''
          LET g_omf[l_ac].omf28 = ''
         #MOD-CA0092--add--end
          RETURN
       ELSE
          #MOD-CA0092--add--str-20121106
          IF g_omf[l_ac].omf917 = 0 THEN
             LET g_errno = 'axm-590'
          ELSE
          #MOD-CA0092--add--end-20121106
             LET g_errno = 'atm-029' 
          END IF 
          #MOD-CA0092 --add--str
          LET g_omf[l_ac].omf16 = 0
          LET g_omf[l_ac].omf13 = ''
          LET g_omf[l_ac].omf14 = ''
          LET g_omf[l_ac].omf15 = ''
          LET g_omf[l_ac].omf17 = ''
          LET g_omf[l_ac].omf28 = ''
         #MOD-CA0092--add--end
          RETURN
       END IF
    END IF
     
    #MOD-CA0092--add--str
    IF l_oha09 = '5' THEN 
       LET li_cnt = 0
       SELECT COUNT(*) INTO li_cnt FROM omf_file
        WHERE omf11 = g_omf[l_ac].omf11
          AND omf12 = g_omf[l_ac].omf12
          AND omf00 != g_omf_1.omf00
       IF li_cnt >0 THEN
          LET g_errno = 'axm-590'
          LET g_omf[l_ac].omf16 = 0
          LET g_omf[l_ac].omf13 = ''
          LET g_omf[l_ac].omf14 = ''
          LET g_omf[l_ac].omf15 = ''
          LET g_omf[l_ac].omf17 = ''
          LET g_omf[l_ac].omf28 = ''
          RETURN
       END IF 
    END IF 
    #MOD-CA0092--add--end
   CALL t670_omf16()
   #IF g_sma.sma115 = 'N'  OR g_sma.sma116 = '0' THEN LET g_omf[l_ac].omf917 = g_omf[l_ac].omf16 END IF#FUN-CA0084 add #MOD-D80108 mark
   LET g_omf[l_ac].omf16 = g_omf[l_ac].omf16 - g_omf16
   IF g_sma.sma115 = 'N'  OR g_sma.sma116 = '0' THEN LET g_omf[l_ac].omf917 = g_omf[l_ac].omf16 END IF #MOD-D80108 add   
   IF g_omf[l_ac].omf10 = '2' THEN
   	  LET g_omf[l_ac].omf16 = g_omf[l_ac].omf16  * -1
      LET g_omf[l_ac].omf917 = g_omf[l_ac].omf917 * -1
   END IF
   
  #LET g_omf[l_ac].omf18 = g_omf[l_ac].omf28 * l_oga24  #轉換為本幣單價
   LET g_omf[l_ac].omf18 = g_omf[l_ac].omf28 * g_omf_1.omf22
 
   IF cl_null(g_omf[l_ac].ogb14) OR g_omf[l_ac].ogb14=0 OR (NOT cl_null(g_omf[l_ac].omf16)) THEN
      LET g_sql = "SELECT gec05,gec07 FROM ",cl_get_target_table(g_plant_new,'gec_file'),
                  " WHERE gec01='",g_omf_1.omf06,"' ",
                  "   AND gec011='2'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql 				
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql               
      PREPARE sel_gec07_pre FROM g_sql 
      EXECUTE sel_gec07_pre INTO g_gec05,g_gec07 
      IF g_gec07 = 'Y' THEN    #含稅
         #未稅金額=(含稅單價*數量)/(1+稅率/100)
         IF g_omf[l_ac].omf917 <> 0 THEN     #FUN-C60036 mod 16--->917
         	  LET g_omf[l_ac].omf29 = cl_digcut((g_omf[l_ac].omf28*g_omf[l_ac].omf917),t_azi04)/(1+g_omf_1.omf061/100)    #FUN-C60036 mod 16--->917
            LET g_omf[l_ac].omf29t = g_omf[l_ac].omf917 * g_omf[l_ac].omf28#FUN-C60036 mod 16--->917
         #MOD-CA0092 --add--str
         ELSE
            IF l_oha09 = '5' THEN
               LET g_omf[l_ac].omf29 = cl_digcut((g_omf[l_ac].omf28*(-1)),t_azi04)/(1+g_omf_1.omf061/100)
               LET g_omf[l_ac].omf29t = -1*g_omf[l_ac].omf28
            END IF 
         #MOD-CA0092--add--end
         END IF
      ELSE                     #不含稅
         #未稅金額=未稅單價*數量
         IF g_omf[l_ac].omf917 <> 0 THEN #FUN-C60036 mod 16--->917
            LET g_omf[l_ac].omf29 = g_omf[l_ac].omf917 * g_omf[l_ac].omf28#FUN-C60036 mod 16--->917
            LET g_omf[l_ac].omf29 = cl_digcut(g_omf[l_ac].omf29,t_azi04)
            LET g_omf[l_ac].omf29t = g_omf[l_ac].omf29 * (1+g_omf_1.omf061/100) 
         #MOD-CA0092--add--str
         ELSE
            IF l_oha09 = '5' THEN 
               LET g_omf[l_ac].omf29 = -1*g_omf[l_ac].omf28
               LET g_omf[l_ac].omf29 = cl_digcut(g_omf[l_ac].omf29,t_azi04)
               LET g_omf[l_ac].omf29t = g_omf[l_ac].omf29 * (1+g_omf_1.omf061/100)
            END IF 
         #MOD-CA0092--add--end
         END IF                                            
      END IF
   END IF
   LET g_omf[l_ac].omf29 = cl_digcut(g_omf[l_ac].omf29,t_azi04)
   LET g_omf[l_ac].omf29t = cl_digcut(g_omf[l_ac].omf29t,t_azi04)   #FUN-C60036
  #LET g_omf[l_ac].omf29x = g_omf[l_ac].omf29 * g_omf_1.omf061/100  #原幣稅額  #FUN-C60036
   LET g_omf[l_ac].omf29x = g_omf[l_ac].omf29t - g_omf[l_ac].omf29  #原幣稅額  #FUN-C60036
   LET g_omf[l_ac].omf29x = cl_digcut(g_omf[l_ac].omf29x,t_azi04)      
  #FUN-C60036--mod--str
  #LET g_omf[l_ac].omf19 = g_omf[l_ac].omf29 * g_omf_1.omf22
  #LET g_omf[l_ac].omf19 = cl_digcut(g_omf[l_ac].omf19,g_azi04)     #本幣
  #LET g_omf[l_ac].omf19x = g_omf[l_ac].omf19 * g_omf_1.omf061/100  #本幣
  #LET g_omf[l_ac].omf19x = cl_digcut(g_omf[l_ac].omf19x,g_azi04)   #本幣
  #LET g_omf[l_ac].omf19t =  g_omf[l_ac].omf19 + g_omf[l_ac].omf19x #本幣
  #LET g_omf[l_ac].omf19t = cl_digcut(g_omf[l_ac].omf19t,g_azi04)   #本幣
   LET g_omf[l_ac].omf19 = g_omf[l_ac].omf29 * g_omf_1.omf22
   LET g_omf[l_ac].omf19 = cl_digcut(g_omf[l_ac].omf19,g_azi04)     #本幣
   LET g_omf[l_ac].omf19t = g_omf[l_ac].omf29t * g_omf_1.omf22
   LET g_omf[l_ac].omf19t = cl_digcut(g_omf[l_ac].omf19t,g_azi04)   #本幣
   LET g_omf[l_ac].omf19x = g_omf[l_ac].omf19t - g_omf[l_ac].omf19
   LET g_omf[l_ac].omf19x = cl_digcut(g_omf[l_ac].omf19x,g_azi04)   #本幣
  #FUN-C60036--mod--end
   
   DISPLAY BY NAME g_omf[l_ac].omf13
   DISPLAY BY NAME g_omf[l_ac].omf14
   DISPLAY BY NAME g_omf[l_ac].omf15
   DISPLAY BY NAME g_omf[l_ac].omf20
   DISPLAY BY NAME g_omf[l_ac].omf201
   DISPLAY BY NAME g_omf[l_ac].ogb14
   DISPLAY BY NAME g_omf[l_ac].ogb11 #add by dengsy160527
   DISPLAY BY NAME g_omf[l_ac].oga011 #add by huanglf170313
   DISPLAY BY NAME g_omf[l_ac].omf16
   DISPLAY BY NAME g_omf[l_ac].omf17
   DISPLAY BY NAME g_omf[l_ac].omf18
   DISPLAY BY NAME g_omf[l_ac].omf28
   DISPLAY BY NAME g_omf[l_ac].omf29
   DISPLAY BY NAME g_omf[l_ac].omf29x
   DISPLAY BY NAME g_omf[l_ac].omf29t
   DISPLAY BY NAME g_omf[l_ac].omf19
   DISPLAY BY NAME g_omf[l_ac].omf19x
   DISPLAY BY NAME g_omf[l_ac].omf19t
   #FUN-C60036--add--str
   DISPLAY BY NAME g_omf[l_ac].omf23
   DISPLAY BY NAME g_omf[l_ac].omf202
   DISPLAY BY NAME g_omf[l_ac].omf910
   DISPLAY BY NAME g_omf[l_ac].omf911
   DISPLAY BY NAME g_omf[l_ac].omf912
   DISPLAY BY NAME g_omf[l_ac].omf913
   DISPLAY BY NAME g_omf[l_ac].omf914
   DISPLAY BY NAME g_omf[l_ac].omf915
   DISPLAY BY NAME g_omf[l_ac].omf916
   DISPLAY BY NAME g_omf[l_ac].omf917
   #FUN-C60036--ad--end
   
END FUNCTION

#FUN-D10082--add--str--
FUNCTION t670_omf25()
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_sql    STRING 

   SELECT azi04 INTO t_azi04 FROM azi_file
             WHERE azi01 = g_omf_1.omf07
   
   LET g_errno = ''
   
   SELECT COUNT(*) INTO l_cnt FROM omf_file
    WHERE omf00 = g_omf_1.omf00
      AND omf25 = g_omf[l_ac].omf25
      AND omf26 = g_omf[l_ac].omf26
      AND omf21 <>g_omf[l_ac].omf21
   IF l_cnt>0 THEN
      LET g_errno = 'axr-376'
      RETURN 
   END IF 
   LET g_sql = " SELECT oeb04,oeb06,oeb092,oeb12,oeb05,oeb13" ,
               "   FROM ",cl_get_target_table(g_plant_new,'oeb_file') ,
               "  WHERE oeb01 = '",g_omf[l_ac].omf25,"'",
               "    AND oeb03 = '",g_omf[l_ac].omf26,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql    	
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE sel_oeb_pre FROM g_sql
   EXECUTE sel_oeb_pre INTO g_omf[l_ac].omf13,g_omf[l_ac].omf14,
                            g_omf[l_ac].omf202,g_omf[l_ac].omf16,
                            g_omf[l_ac].omf17,g_omf[l_ac].omf28
   SELECT ima021 INTO g_omf[l_ac].omf15 FROM ima_file WHERE ima01=g_omf[l_ac].omf13
   LET l_sql = " SELECT abs(SUM(omf16)) ",
               "   FROM omf_file ",
               "  WHERE omf00 <>'",g_omf_1.omf00,"'",
               "    AND omf09 = '",g_omf[l_ac].omf09,"'",
               "    AND omf25 = '",g_omf[l_ac].omf25,"'",
               "    AND omf26 = '",g_omf[l_ac].omf26,"'"
   PREPARE t670_omf25_pb FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF
   DECLARE omf_omf25_curs CURSOR FOR t670_omf25_pb
   OPEN omf_omf25_curs
   FETCH omf_omf25_curs INTO g_omf16
   IF cl_null(g_omf16) THEN LET g_omf16 = 0 END IF
   LET g_omf[l_ac].omf16 = g_omf[l_ac].omf16 - g_omf16
   LET g_omf[l_ac].omf18 = g_omf[l_ac].omf28 * g_omf_1.omf22
   LET g_omf[l_ac].omf29 = g_omf[l_ac].omf16 * g_omf[l_ac].omf28
   LET g_omf[l_ac].omf29 = cl_digcut(g_omf[l_ac].omf29,t_azi04)
   LET g_omf[l_ac].omf29t = g_omf[l_ac].omf29 * (1+g_omf_1.omf061/100) 
   LET g_omf[l_ac].omf29t = cl_digcut(g_omf[l_ac].omf29t,t_azi04)
   LET g_omf[l_ac].omf29x = g_omf[l_ac].omf29t - g_omf[l_ac].omf29
   LET g_omf[l_ac].omf29x = cl_digcut(g_omf[l_ac].omf29x,t_azi04)
   LET g_omf[l_ac].omf19 = g_omf[l_ac].omf29 * g_omf_1.omf22
   LET g_omf[l_ac].omf19 = cl_digcut(g_omf[l_ac].omf19,g_azi04)     #本幣
   LET g_omf[l_ac].omf19t = g_omf[l_ac].omf29t * g_omf_1.omf22
   LET g_omf[l_ac].omf19t = cl_digcut(g_omf[l_ac].omf19t,g_azi04)   #本幣
   LET g_omf[l_ac].omf19x = g_omf[l_ac].omf19t - g_omf[l_ac].omf19
   LET g_omf[l_ac].omf19x = cl_digcut(g_omf[l_ac].omf19x,g_azi04)   #本幣
   
END FUNCTION 
#FUN-D10082--add--end--


FUNCTION t670_omf16()
   DEFINE l_sql    LIKE type_file.chr1000 
   DEFINE l_omb12  LIKE omb_file.omb12 
  #FUN-C60036--mod--str--
  #LET l_sql = " SELECT abs(SUM(omf16)) ",  
  #            "   FROM omf_file ",
  #            "  WHERE omf01 NOT IN ",
  #            "(SELECT DISTINCT ome01 ",
  #            "   FROM ome_file,oma_file,omb_file ",
  #            "  WHERE ome16 = oma01 ",
  #            "    AND oma01 = omb01 ",
  #            "    AND omb31 = '",g_omf[l_ac].omf11,"' ",
  #            "    AND omb32 = ",g_omf[l_ac].omf12,") ",
  #            "    AND omf09 = '",g_omf[l_ac].omf09,"' ",
  #            "    AND omf11 = '",g_omf[l_ac].omf11,"' ",
  #            "    AND omf12 = ",g_omf[l_ac].omf12," "
   LET l_sql = " SELECT abs(SUM(omf16)) ",
               "   FROM omf_file ",
               "  WHERE omf00 <>'",g_omf_1.omf00,"'",
#              "    AND omf21 <>'",g_omf[l_ac].omf21,"'",
               "    AND omf09 = '",g_omf[l_ac].omf09,"'",
               "    AND omf11 = '",g_omf[l_ac].omf11,"'",
               "    AND omf12 = '",g_omf[l_ac].omf12,"'"
  #FUN-C60036--mod--end
   PREPARE t670_pb1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF
   DECLARE omf_curs1 CURSOR FOR t670_pb1
   OPEN omf_curs1
   FETCH omf_curs1 INTO g_omf16
   IF cl_null(g_omf16) THEN LET g_omf16 = 0 END IF
  ##FUN-C60036--mark--str
  #SELECT SUM(abs(omb12)) INTO l_omb12
  #  FROM omb_file,oma_file
  # WHERE oma01 = omb01
  #   AND omb31 = g_omf[l_ac].omf11
  #   AND omb32 = g_omf[l_ac].omf12
  #IF cl_null(l_omb12) THEN LET l_omb12 = 0 END IF
  #LET g_omf16 = g_omf16 + l_omb12
  ##FUN-C60036-mark--end
END FUNCTION


FUNCTION t670_y() 		
   DEFINE  l_omf    RECORD LIKE omf_file.*,
           l_ogb    RECORD LIKE ogb_file.*,
           l_ohb    RECORD LIKE ohb_file.*
  #DEFINE  tot     	      LIKE type_file.num20_6
   DEFINE  tot     	      LIKE type_file.num15_3   #mod#TQC-D10102 
   DEFINE l_slip   LIKE oay_file.oayslip  #MOD-CB0040 add
   DEFINE l_oay13  LIKE oay_file.oay13    #MOD-CB0040 add
   DEFINE l_oay14  LIKE oay_file.oay14    #MOD-CB0040 add
   DEFINE l_yy,l_mm LIKE type_file.num5   #MOD-CC0049 add
   DEFINE l_ogc12   LIKE ogc_file.ogc12,   #MOD-D20079
          l_ogg12   LIKE ogg_file.ogg12,
          l_ogg12_2 LIKE ogg_file.ogg12
   DEFINE l_n       LIKE type_file.num5   #TQC-D60063 add
   DEFINE l_oha09  LIKE oha_file.oha09    #add by kuangxj170901 
          
   CALL t670_fresh() #MOD-CC0230 add
   #TQC-D10020----add---str---
   IF g_omf_1.omf00 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   #TQC-D10020----add---end---
   IF g_omf_1.omf08='Y' THEN 
      CALL cl_err('','1208',0) 
      RETURN
   END IF
   IF g_omf_1.omf08 = 'X' THEN CALL cl_err('','alm-674',0) RETURN END IF #TQC-D20009--xj--add
   #MOD-CC0049 add begin----------------------
    IF NOT cl_null(g_omf_1.omf03) THEN 
       CALL s_yp(g_omf_1.omf03) RETURNING l_yy,l_mm
       IF l_yy < g_ccz.ccz01 OR (l_yy = g_ccz.ccz01 AND l_mm < g_ccz.ccz02) THEN
          CALL cl_err('','axm-771',0)
          RETURN
       END IF
    END IF 
   #MOD-CC0049 add end------------------------
#   IF g_omf_1.omf07 = g_aza.aza17 THEN 
#      SELECT SUM(omf19),SUM(omf19x),SUM(omf19t),SUM(omf29),SUM(omf29x),SUM(omf29t)
#       INTO g_omf_1.omf19_sum,g_omf_1.omf19x_sum,g_omf_1.omf19t_sum,g_omf_1.omf29_sum,g_omf_1.omf29x_sum,g_omf_1.omf29t_sum
#       FROM omf_file
#      WHERE omf00 = g_omf_1.omf00
#      CALL t670_upd_show_diff() #MOD-D60161 add
#      #MOD-D60161--add--str
#       LET g_omf_1.omf19_sum = cl_digcut(g_omf_1.omf19_sum,g_azi04)
#       LET g_omf_1.omf19x_sum = cl_digcut(g_omf_1.omf19x_sum,g_azi04)
#       LET g_omf_1.omf19t_sum = cl_digcut(g_omf_1.omf19t_sum,g_azi04)
#       LET g_omf_1.omf29_sum = cl_digcut(g_omf_1.omf29_sum,t_azi04)
#       LET g_omf_1.omf29x_sum = cl_digcut(g_omf_1.omf29x_sum,t_azi04)
#       LET g_omf_1.omf29t_sum = cl_digcut(g_omf_1.omf29t_sum,t_azi04)
#       #MOD-D60161--add--end 
#      IF g_omf_1.omf19_sum <> g_omf_1.omf29_sum THEN 
#         CALL cl_err('','axr-419',0)
#         RETURN
#      END IF 
#      IF g_omf_1.omf19t_sum <> g_omf_1.omf29t_sum THEN 
#         CALL cl_err('','axr-419',0)
#         RETURN
#      END IF
#      IF g_omf_1.omf19x_sum <> g_omf_1.omf29x_sum THEN 
#         CALL cl_err('','axr-419',0)
#         RETURN
#      END IF
#   END IF
#MOD-CB0040 add beg-------

     #TQC-D60063--add--begin---
     IF NOT cl_null(g_omf_1.omf32) THEN
        LET l_n = 0
        SELECT COUNT(*) INTO l_n
           FROM gen_file WHERE gen01 = g_omf_1.omf32 AND genacti = 'Y'
        IF l_n = 0 THEN
           CALL cl_err(g_omf_1.omf32,'aap-038',0)
           RETURN 
        END IF
    END IF

    IF NOT cl_null(g_omf_1.omf33) THEN
       LET l_n = 0
       SELECT COUNT(*) INTO l_n FROM gem_file
           WHERE gem01 = g_omf_1.omf33 AND gemacti = 'Y'
       IF l_n = 0 THEN
          CALL cl_err(g_omf_1.omf33,'asf-624',0)
          RETURN 
       END IF
    END IF
   #TQC-D60063--add--end---

   LET l_slip=s_get_doc_no(g_omf_1.omf00)      
   SELECT oay13,oay14 INTO l_oay13,l_oay14 FROM oay_file WHERE oayslip = l_slip
   IF l_oay13 = 'Y' THEN
      IF g_omf_1.omf19t_sum > l_oay14 THEN
         CALL cl_err(l_oay14,'axm-700',1)
         RETURN
      END IF
   END IF   
#MOD-CB0040 add end--------    
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   IF STATUS THEN CALL cl_err('omf_curs',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF

   LET g_success='Y'
  #BEGIN WORK
   #MOD-D50076 add begin----------------------------
   OPEN t670_cl USING g_omf_1.omf00    
   IF STATUS THEN
      CALL cl_err("OPEN t670_cl:", STATUS, 1)
      CLOSE t670_cl
      LET g_success='N'
      RETURN
   END IF

   FETCH t670_cl INTO g_omf_1.omf00,g_omf_1.omf01,g_omf_1.omf02,
                      g_omf_1.omf03,g_omf_1.omf05,g_omf_1.omf06,
                      g_omf_1.omf07,g_omf_1.omf22,g_omf_1.omf30  # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_omf_1.omf00,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t670_cl
      LET g_success='N'
      RETURN
   END IF
   #MOD-D50076 add  end ----------------------------
#MOD-D10266  add begin--------
      UPDATE omf_file SET omf08 = 'Y' WHERE omf00 = g_omf_1.omf00
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","omf_file",l_omf.omf11,l_omf.omf12,STATUS,"","upd omf08",1)
         LET g_success = 'N'
         ROLLBACK WORK
         RETURN
      END IF
      #130615 add by tangyh--str MOD-D60160 begin----
      IF g_oaz.oaz93 = 'N' THEN 
         UPDATE omf_file SET omf24 = g_omf_1.omf03 WHERE omf00 = g_omf_1.omf00
      END IF 
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","omf_file",l_omf.omf11,l_omf.omf12,STATUS,"","upd omf08",1)
         LET g_success = 'N'
         ROLLBACK WORK
         RETURN
      END IF
      #130615 add by tangyh--end MOD-D60160 end------
#MOD-D10266 add end-------------   
   DECLARE omf_curs2 CURSOR FOR
      #SELECT * FROM omf_file WHERE omf01 = g_omf_1.omf01 AND omf02 = g_omf_1.omf02    #FUN-C60033
       SELECT * FROM omf_file WHERE omf00 = g_omf_1.omf00                              #FUN-C60033
   FOREACH omf_curs2 INTO l_omf.*
   	LET tot = 0
      IF NOT cl_null(l_omf.omf11) AND NOT cl_null(l_omf.omf12) THEN   	  	 
         SELECT SUM(omf917) INTO tot FROM omf_file #FUN-C60033 mod 16-->917
         #WHERE omf01 = l_omf.omf01 AND omf02 = l_omf.omf02    #FUN-C60033
          WHERE omf00 = l_omf.omf00
            AND omf21 = l_omf.omf21
         IF cl_null(tot) THEN LET tot = 0 END IF
         IF l_omf.omf10='1' THEN
            #MOD-D20079 add begin------------------------------------
            IF l_omf.omf23='Y' THEN 
               IF g_sma.sma115='Y' THEN 
                  #單位1數量統計
                  IF l_omf.omf912 > 0 THEN 
                     SELECT SUM(ogg12) INTO l_ogg12 FROM ogg_file 
                      WHERE ogg20 = '1'
                        AND ogg01 = l_omf.omf00
                        AND ogg03 = l_omf.omf21
                     IF l_ogg12 <> l_omf.omf912 THEN 
                        CALL cl_err(l_omf.omf21,'axm-586',1)
                        LET g_success = 'N' 
                        RETURN                     
                     END IF
                  END IF 
                  #單位2數量統計
                  IF l_omf.omf915 > 0 THEN 
                     SELECT SUM(ogg12) INTO l_ogg12_2 FROM ogg_file 
                      WHERE ogg20 = '2'
                        AND ogg01 = l_omf.omf00
                        AND ogg03 = l_omf.omf21
                     IF l_ogg12_2 <> l_omf.omf915 THEN 
                        CALL cl_err(l_omf.omf21,'axm-586',1)
                        LET g_success = 'N' 
                        RETURN                     
                     END IF
                  END IF                                               
               ELSE 
                  SELECT SUM(ogc12) INTO l_ogc12 FROM ogc_file 
                   WHERE ogc01 = l_omf.omf00
                     AND ogc03 = l_omf.omf21
                  IF l_ogc12 <> l_omf.omf16 THEN 
                     CALL cl_err(l_omf.omf21,'axm-586',1)
                     LET g_success = 'N' 
                     RETURN                     
                  END IF      
               END IF    
            END IF 
            #MOD-D20079 add end--------------------------------------
      	   LET g_sql = "SELECT * FROM ",cl_get_target_table(l_omf.omf09,'ogb_file'),
                        " WHERE ogb01 = '",l_omf.omf11,"' AND ogb03 = '",l_omf.omf12,"'"  
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_omf.omf09) RETURNING g_sql
            PREPARE sel_ogb FROM g_sql 
            EXECUTE sel_ogb INTO l_ogb.*     
            IF STATUS THEN 
               CALL cl_err3("sel","ogb_file",l_omf.omf11,l_omf.omf12,STATUS,"","s_upd_ogb60:sel ogb",1)    #No.FUN-660116
               LET g_success = 'N' RETURN
            END IF  
            IF cl_null(l_ogb.ogb917) THEN LET l_ogb.ogb917 = 0 END IF
            IF tot > l_ogb.ogb917 THEN	
               CALL cl_err('','axr-174',1)
               LET g_success = 'N' RETURN
            END IF         
            LET l_ogb.ogb71 = g_ogb71
            LET g_sql = "UPDATE ",cl_get_target_table(l_omf.omf09,'ogb_file'),
                      "   SET ogb60= ogb60 + ",tot,",",
                      "       ogb71= '",l_omf.omf01,"'",
                      " WHERE ogb01 = '",l_omf.omf11,"' AND ogb03 = '",l_omf.omf12,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_omf.omf09) RETURNING g_sql
            PREPARE upd_ogb60 FROM g_sql
            EXECUTE upd_ogb60
            IF STATUS THEN
               CALL cl_err3("upd","ogb_file",l_omf.omf11,l_omf.omf12,STATUS,"","upd ogb60",1) 
               LET g_success = 'N' 
               RETURN
            END IF
            IF SQLCA.SQLERRD[3]=0 THEN
               CALL cl_err('upd ogb60','axr-134',1) LET g_success = 'N' RETURN
            END IF       
         ELSE
           IF l_omf.omf10 = '2' THEN 
            #mod by kuangxj170901 begin
             # LET g_sql = "SELECT * FROM ",cl_get_target_table(l_omf.omf09,'ohb_file'),
             #             " WHERE ohb01 = '",l_omf.omf11,"' AND ohb03 = '",l_omf.omf12,"'"  
               LET g_sql = "SELECT ohb_file.*,oha09 FROM ",cl_get_target_table(l_omf.omf09,'ohb_file'),",",cl_get_target_table(l_omf.omf09,'oha_file'),
                            " WHERE oha01=ohb01 AND  ohb01 = '",l_omf.omf11,"' AND ohb03 = '",l_omf.omf12,"'"
             #mod by kuangxj170901 end
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,l_omf.omf09) RETURNING g_sql
               PREPARE sel_ohb FROM g_sql 
            #   EXECUTE sel_ohb INTO l_ohb.*    #mark by kuangxj170901
               EXECUTE sel_ohb INTO l_ohb.*,l_oha09 #add by kuangxj170901 
               IF STATUS THEN 
                  CALL cl_err3("sel","ohb_file",l_omf.omf11,l_omf.omf12,STATUS,"","s_upd_ohb60:sel ohb",1)    #No.FUN-660116
                  LET g_success = 'N' RETURN
               END IF  
               IF cl_null(l_ohb.ohb917) THEN LET l_ohb.ohb917 = 0 END IF
               IF tot > l_ohb.ohb917 THEN	
                  CALL cl_err('','axr-174',1)
                  LET g_success = 'N' RETURN
               END IF         
            IF l_oha09!='5' THEN #add by kuangxj170901
               LET g_sql = "UPDATE ",cl_get_target_table(l_omf.omf09,'ohb_file'),
                         "   SET ohb60= ohb60 + abs(",tot,")",
                         "      ,ohb71 = '",l_omf.omf01,"'",     #FUN-C60036
                         " WHERE ohb01 = '",l_omf.omf11,"' AND ohb03 = '",l_omf.omf12,"'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,l_omf.omf09) RETURNING g_sql
               PREPARE upd_ohb60 FROM g_sql
               EXECUTE upd_ohb60
               IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                  CALL cl_err3("upd","ohb_file",l_omf.omf11,l_omf.omf12,STATUS,"","upd ohb60",1) 
                  LET g_success = 'N' 
                  ROLLBACK WORK
                  RETURN
               END IF
            END IF #add by kuangxj170901
           END IF 
         END IF
     #MOD-CC0257 mark begin-------------------------------- 
     #UPDATE omf_file SET omf08 = 'Y' WHERE omf01 = g_omf_1.omf01 AND omf02 = g_omf_1.omf02
     #IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
     #	 CALL cl_err3("upd","omf_file",l_omf.omf11,l_omf.omf12,STATUS,"","upd omf08",1) 
     #   LET g_success = 'N'
     #   ROLLBACK WORK 
     #   RETURN
     #END IF
     #MOD-CC0257 mark end----------------------------------
      END IF
   END FOREACH
   IF g_success = 'Y' THEN 
  #MOD-CC0257 add begin----------------------------------            
#MOD-D10266 mark begin-------
#      UPDATE omf_file SET omf08 = 'Y' WHERE omf00 = g_omf_1.omf00
#      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err3("upd","omf_file",l_omf.omf11,l_omf.omf12,STATUS,"","upd omf08",1)
#         LET g_success = 'N'
#         ROLLBACK WORK
#         RETURN
#      END IF
#   	 COMMIT WORK 
#MOD-D10266 mark end 	
      IF INT_FLAG OR  STATUS THEN 
         LET g_success = 'N'
         ROLLBACK WORK
         RETURN  
      ELSE 
         COMMIT WORK
      END IF    	           
      LET g_omf_1.omf08 = 'Y'
      DISPLAY BY NAME g_omf_1.omf08
      CALL cl_set_field_pic(g_omf_1.omf08,"","","","","")
  #MOD-CC0257 add end----------------------------------         
      #FUN-C60036-add--str
      SELECT oaz100,oaz106 INTO g_oaz.oaz100,g_oaz.oaz106 FROM oaz_file
      IF g_oaz.oaz106 = 'Y' AND g_oaz.oaz92 ='Y' AND g_oaz.oaz93 = 'Y' THEN 
         BEGIN WORK
         CALL t670_s()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
      END IF
      IF g_oaz.oaz100 = 'Y' AND g_success = 'Y'  THEN CAll t670_axrp310() END IF
      #FUN-C60036-add--end
   END IF      
END FUNCTION
 
FUNCTION t670_w() 			
   DEFINE  l_omf    RECORD LIKE omf_file.*,
           l_ogb    RECORD LIKE ogb_file.*,
           l_ohb    RECORD LIKE ohb_file.*
   DEFINE  tot     	       LIKE type_file.num20_6
   DEFINE  l_n      LIKE type_file.num5#FUN-C60036 add
   DEFINE l_omf04 LIKE omf_file.omf04 #FUN-C60036 add
   DEFINE l_oma    RECORD LIKE oma_file.*
   DEFINE l_cnt    LIKE type_file.num10

   SELECT oaz93,oaz92,oaz100,oaz106 INTO g_oaz.oaz93,g_oaz.oaz92,g_oaz.oaz100,g_oaz.oaz106
     FROM oaz_file
   CALL t670_fresh() #MOD-CC0230 add
   IF g_omf_1.omf08='Y' THEN 
      IF  g_oaz.oaz106 != 'Y' THEN
         IF g_omf_1.omfpost='Y' THEN
           CALL cl_err('','arm-800',0)
           RETURN
         END IF 
      END IF 
   #FUN-C60036--add--str
   ELSE
      #FUN-CA0084--add--str
      IF cl_null(g_omf_1.omf00) THEN 
         CALL cl_err('','-400',0)
      ELSE
     #FUN-CA0084--add--end
         CALL cl_err('','9025',0)
      END IF #FUN-CA0084--add
      RETURN #FUN-CA0084--add
   #FUN-C60036-add--end
   END IF
   #FUN-C60036--ad--str
   LET l_n = 0 
   IF  g_oaz.oaz106 != 'Y' THEN
   SELECT COUNT(*) INTO l_n  FROM omf_file
    WHERE omf00 = g_omf_1.omf00
      AND omf04 IS NOT NULL
   IF l_n > 0 THEN 
      CALL cl_err('','aap-228',0)
      RETURN
   END IF
   END IF 
   LET g_sql = " SELECT DISTINCT omf04 FROM omf_file ",
                  "  WHERE omf00 = '",g_omf_1.omf00,"'",
                  "    AND omf04 IS NOT NULL "
      PREPARE t670_deloma_pre1 FROM g_sql
      DECLARE t670_deloma_cs1 CURSOR FOR t670_deloma_pre1
   FOREACH t670_deloma_cs1 INTO l_oma.oma01
   SELECT * INTO l_oma.* FROM oma_file WHERE oma01 = l_oma.oma01
    IF l_oma.omaconf = 'Y' THEN
       CALL cl_err('','axr-279',0)
       LET g_success = 'N'
       RETURN
    END IF
    IF l_oma.omavoid = 'Y' THEN
       CALL cl_err('','axr-103',0)
       LET g_success = 'N'
       RETURN
    END IF
    IF l_oma.oma64 matches '[Ss1]' THEN
       CALL cl_err('','mfg3557',0)
       LET g_success = 'N'
       RETURN
    END IF
    IF l_oma.oma70 = '1'  THEN
          CALL cl_err('','alm-552',0)
       LET g_success = 'N'
       RETURN
       END IF
    SELECT COUNT(*) INTO l_cnt FROM oot_file
     WHERE oot01 = l_oma.oma01
    IF l_cnt > 0 THEN
       CALL cl_err('','axr-009',0)
       LET g_success = 'N'
       RETURN
    END IF
    IF g_oaz.oaz100 = 'N' THEN 
       CALL cl_err('','aap-228',0)
       RETURN 
    END IF 
   END FOREACH
   #FUN-C60036--ad--end
   IF NOT cl_confirm('8882') THEN RETURN END IF

   LET g_success='Y'
   
   IF g_oaz.oaz100 = 'Y' THEN 
      LET g_sql = " SELECT DISTINCT omf04 FROM omf_file ",
                  "  WHERE omf00 = '",g_omf_1.omf00,"'",
                  "    AND omf04 IS NOT NULL "
      PREPARE t670_deloma_pre FROM g_sql
      DECLARE t670_deloma_cs CURSOR FOR t670_deloma_pre
   #  BEGIN WORK
      FOREACH t670_deloma_cs INTO l_omf04
         IF g_success = 'N' THEN 
            EXIT FOREACH 
         END IF 
         CALL t670_deloma(l_omf04) 
      END FOREACH
   #  IF g_success = "Y" THEN
   #     COMMIT WORK
   #  ELSE
   #     ROLLBACK WORK
   #  END IF
   END IF
   IF g_success = 'N' THEN RETURN END IF 
   IF g_success = 'Y' AND g_oaz.oaz106 = 'Y' AND g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' AND g_omf_1.omfpost = 'Y' THEN
   #  BEGIN WORK
      CALL t670_z()
   #  IF g_success = "Y" THEN
   #     COMMIT WORK
   #  ELSE
   #     ROLLBACK WORK
   #  END IF 
   END IF
   IF g_success = 'N' THEN RETURN END IF  
  #BEGIN WORK
   
   DECLARE omf_curs3 CURSOR FOR
    #  SELECT * FROM omf_file WHERE omf01 = g_omf_1.omf01 AND omf02 = g_omf_1.omf02   #FUN-C60033
       SELECT * FROM omf_file WHERE omf00 = g_omf_1.omf00                             #FUN-C60033
   FOREACH omf_curs3 INTO l_omf.*
      IF NOT cl_null(l_omf.omf11) AND NOT cl_null(l_omf.omf12) THEN
          SELECT SUM(omf917) INTO tot FROM omf_file #FUN-C60033 mod 16-->917
         # WHERE omf01 = l_omf.omf01 AND omf02 = l_omf.omf02    #FUN-C60033
           WHERE omf00 = l_omf.omf00                            #FUN-C60033
             AND omf21 = l_omf.omf21
         IF cl_null(tot) THEN LET tot = 0 END IF
         IF l_omf.omf10='1' THEN
         	 LET g_sql = "SELECT * FROM ",cl_get_target_table(l_omf.omf09,'ogb_file'),
                " WHERE ogb01 = '",l_omf.omf11,"' AND ogb03 = '",l_omf.omf12,"'"  
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_omf.omf09) RETURNING g_sql
            PREPARE sel_ogb1 FROM g_sql 
            EXECUTE sel_ogb1 INTO l_ogb.*     
            IF STATUS THEN 
               CALL cl_err3("sel","ogb_file",l_omf.omf11,l_omf.omf12,STATUS,"","s_upd_ogb60:sel ogb",1)    #No.FUN-660116
               LET g_success = 'N' RETURN
            END IF  
            IF cl_null(l_ogb.ogb917) THEN LET l_ogb.ogb917 = 0 END IF
            IF tot > l_ogb.ogb917 THEN	
               CALL cl_err('','axr-174',1)
               LET g_success = 'N' RETURN
            END IF         
        
            LET g_sql = "UPDATE ",cl_get_target_table(l_omf.omf09,'ogb_file'),
                      "   SET ogb60 = ogb60 - ",tot,",",
                      "       ogb71 = '",g_ogb71,"'",
                      " WHERE ogb01 = '",l_omf.omf11,"' AND ogb03 = '",l_omf.omf12,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_omf.omf09) RETURNING g_sql
            PREPARE upd_ogb60_1 FROM g_sql
            EXECUTE upd_ogb60_1
            IF STATUS OR SQLCA.SQLERRD[3]=0  THEN
               CALL cl_err3("upd","ogb_file",l_omf.omf11,l_omf.omf12,STATUS,"","upd ogb60",1) 
               LET g_success = 'N' 
               ROLLBACK WORK
               RETURN
            END IF
         ELSE
           LET g_sql = "SELECT * FROM ",cl_get_target_table(l_omf.omf09,'ohb_file'),
                       " WHERE ohb01 = '",l_omf.omf11,"' AND ohb03 = '",l_omf.omf12,"'"  
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_omf.omf09) RETURNING g_sql
            PREPARE sel_ohb_1 FROM g_sql 
            EXECUTE sel_ohb_1 INTO l_ohb.*     
            IF STATUS THEN 
               CALL cl_err3("sel","ohb_file",l_omf.omf11,l_omf.omf12,STATUS,"","s_upd_ohb60:sel ohb",1)    #No.FUN-660116
               LET g_success = 'N' RETURN
            END IF  
            IF cl_null(l_ohb.ohb917) THEN LET l_ohb.ohb917 = 0 END IF
            IF tot > l_ohb.ohb917 THEN	
               CALL cl_err('','axr-174',1)
               LET g_success = 'N' 
               RETURN
            END IF         
        
            LET g_sql = "UPDATE ",cl_get_target_table(l_omf.omf09,'ohb_file'),
                      "   SET ohb60= ohb60 - abs(",tot,")",
                      "      ,ohb71 = NULL ",                 #FUN-C60036
                      " WHERE ohb01 = '",l_omf.omf11,"' AND ohb03 = '",l_omf.omf12,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_omf.omf09) RETURNING g_sql
            PREPARE upd_ohb60_1 FROM g_sql
            EXECUTE upd_ohb60_1
            IF STATUS THEN
               CALL cl_err3("upd","ohb_file",l_omf.omf11,l_omf.omf12,STATUS,"","upd ohb60",1) 
               ROLLBACK WORK
               LET g_success = 'N' 
               RETURN
            END IF
            IF SQLCA.SQLERRD[3]=0 THEN
               CALL cl_err('upd ohb60','axr-134',1) LET g_success = 'N' 
               ROLLBACK WORK
               RETURN
            END IF
         END IF
         #UPDATE omf_file SET omf08 = 'N' WHERE omf01 = g_omf_1.omf01 AND omf02 = g_omf_1.omf02   #FUN-C60033
 #MOD-CC0257 mark begin------------------
 #      UPDATE omf_file SET omf08 = 'N' WHERE omf00 = g_omf_1.omf00                             #FUN-C60033
 #         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
 #           CALL cl_err3("upd","omf_file",l_omf.omf11,l_omf.omf12,STATUS,"","upd omf08",1)
 #           LET g_success = 'N' 
 #           ROLLBACK WORK
 #           RETURN
 #         END IF
 #MOD-CC0257 mark end--------------------
      END IF
   END FOREACH
   IF g_success = 'Y' THEN
#MOD-CC0257 add begin--------
     UPDATE omf_file SET omf08 = 'N' WHERE omf00 = g_omf_1.omf00                             #FUN-C60033
       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
         CALL cl_err3("upd","omf_file",l_omf.omf11,l_omf.omf12,STATUS,"","upd omf08",1)
         LET g_success = 'N' 
         ROLLBACK WORK
         RETURN
       END IF 
#MOD-CC0257 add end-------------                    
    	COMMIT WORK   	 
       LET g_omf_1.omf08 = 'N'
       DISPLAY BY NAME g_omf_1.omf08
       CALL cl_set_field_pic(g_omf_1.omf08,"","","","","")         
       CALL t670_show()
   END IF      	
END FUNCTION
 

FUNCTION t670_s()
   DEFINE  l_omf    RECORD LIKE omf_file.*,
           l_type          LIKE type_file.num5,
           #FUN-C60036--add--str
           li_sql          STRING,
           l_ogc    RECORD LIKE ogc_file.*,
           l_ogg    RECORD LIKE ogg_file.*,
           l_ima906 LIKE ima_file.ima906,
           l_ogc12  LIKE ogc_file.ogc12,
           l_ogg12  LIKE ogg_file.ogg12
   DEFINE  ls_n    LIKE type_file.num5
           #FUN-C60036--add--end 
   DEFINE  l_tlf14  LIKE tlf_file.tlf14   #TQC-C80042
   DEFINE  l_flag    LIKE type_file.num5  #MOD-CB0073 add
   DEFINE  l_yy,l_mm LIKE type_file.num5  #MOD-CC0049 add
   DEFINE  li_oha09 LIKE oha_file.oha09,#FUN-D20003 20130204
           li_img10 LIKE img_file.img10#FUN-D20003 20130204
   DEFINE  l_yy2,l_mm2  LIKE type_file.num5 #MOD-D60160
   
   CALL t670_fresh() #MOD-CC0230 add
   IF g_omf_1.omf08='N' OR g_omf_1.omf08='X' OR g_omf_1.omfpost='Y' THEN  #TQC-D20009-xj-add omf08='X'
      CALL cl_err('','afa-100',0) #TQC-D20009 add
      RETURN 
   END IF
    #FUN-C60036 add--str
   LET ls_n = 0 
   SELECT COUNT(*) INTO ls_n FROM omf_file 
    WHERE omf00 = g_omf_1.omf00 
      AND omf10 <>'9'
   IF ls_n = 0 THEN 
      CALL cl_err('','axm-715',0) #MOD-CB0073 add    
      RETURN 
   END IF
   #FUN-C60036--add--end
   IF g_oaz.oaz106 = 'Y' AND g_auto_con = 1 THEN 
      LET g_omf_1.omf24 = g_omf_1.omf03
   ELSE
      IF NOT cl_confirm('axr-197') THEN
         LET g_success = 'N'
         RETURN 
      END IF
   INPUT g_omf_1.omf24 WITHOUT DEFAULTS FROM omf24
      BEFORE INPUT 
         LET g_omf_1.omf24 = g_today
         DISPLAY g_omf_1.omf24 TO omf24
      AFTER FIELD omf24
         IF cl_null(g_omf_1.omf24) THEN 
            NEXT FIELD omf24
         END IF 
#MOD-CB0073 add begin----------
         IF NOT cl_null(g_omf_1.omf24) THEN 
            CALL t670_chkomf24(g_omf_1.omf24) RETURNING l_flag
            IF l_flag > 0 THEN 
               NEXT FIELD omf24
            END IF   
            #MOD-CC0049 add begin----------------------
            CALL s_yp(g_omf_1.omf24) RETURNING l_yy,l_mm
            IF l_yy < g_ccz.ccz01 OR (l_yy = g_ccz.ccz01 AND l_mm < g_ccz.ccz02) THEN
               CALL cl_err('','axm-773',0)
               NEXT FIELD omf24
            END IF 
            #MOD-CC0049 add end------------------------
            #MOD-D60160 add begin------------------------
            CALL s_yp(g_omf_1.omf03) RETURNING l_yy2,l_mm2
            IF l_yy != l_yy2 OR l_mm != l_mm2 THEN
               CALL cl_err('','axm-774',0)
               NEXT FIELD omf24
            END IF            
            #MOD-D60160 add end------------------------
         END IF 
#MOD-CB0073 add end---------- 
        
                  
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help()  

      ON ACTION controlg      
         CALL cl_cmdask()     
      ON ACTION cancel
         LET INT_FLAG=1
         LET g_omf_1.omf24 = ''
         DISPLAY g_omf_1.omf24 TO omf24
         EXIT INPUT 
   END INPUT 
   IF INT_FLAG = 1 THEN 
      LET INT_FLAG = 0
      RETURN
   END IF 
   END IF 
   LET g_success='Y'
  #BEGIN WORK
   #FUN-C60036--ad--str
   UPDATE omf_file SET omf24 = g_omf_1.omf24 
    WHERE omf00 = g_omf_1.omf00
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err('upd omf_file',SQLCA.SQLCODE,1)
      LET g_success='N'
   END IF
   
   LET li_sql = " SELECT * FROM ogc_file ",
                "  WHERE ogc01 = ? ",
                "    AND ogc03 = ? "
   PREPARE omf_s_img FROM li_sql
   DECLARE omf_s_img_cs CURSOR FOR omf_s_img
   LET li_sql = " SELECT * FROM ogg_file ",
                "  WHERE ogg01 = ? ",
                "    AND ogg03 = ? ",
                "  ORDER BY ogg20 desc "#TQC-D20046 add by xuxz
   PREPARE omf_s_imgg FROM li_sql
   DECLARE omf_s_imgg_cs CURSOR FOR omf_s_imgg
   #FUN-C60036--ad--end
  #BEGIN WORK
      DECLARE omf_curs4 CURSOR FOR
     # SELECT * FROM omf_file WHERE omf01 = g_omf_1.omf01 AND omf02 = g_omf_1.omf02   #FUN-C60033
       SELECT * FROM omf_file WHERE omf00 = g_omf_1.omf00                             #FUN-C60033
         AND omf10 <>'9' #FUN-C60033 add xuxz
         AND omf13 NOT LIKE 'MISC%' #MOD-CA0062 add
   FOREACH omf_curs4 INTO l_omf.*
          IF cl_null(l_omf.omf20) THEN
             SELECT oaz95 INTO l_omf.omf20 FROM oaz_file
          END IF  
   	  IF NOT cl_null(l_omf.omf11) AND NOT cl_null(l_omf.omf12) THEN
            IF l_omf.omf10 = '1' THEN
               LET l_type = -1
               #TQC-C80042-add--str--
               SELECT ogb1001 INTO l_tlf14 FROM ogb_file WHERE ogb01 = l_omf.omf11
                  AND ogb03 = l_omf.omf12
               #TQC-C80042--add--end
            ELSE
               LET l_type = 1
               #FUN-C60036--add--str--
               LET l_omf.omf16 = l_omf.omf16*(-1)
               LET l_omf.omf917 = l_omf.omf917*(-1)
               LET l_omf.omf912 = l_omf.omf912*(-1)
               LET l_omf.omf915 = l_omf.omf915*(-1)
               #FUN-C60036--add--end
               #TQC-C80042--add--str--
               SELECT ohb50 INTO l_tlf14 FROM ohb_file WHERE ohb01 = l_omf.omf11
                  AND ohb03 = l_omf.omf12
               #TQC-C80042--add--end
               #FUN-D20003 20130204--add--str
               #銷退單oha09為5.折讓的時候如果不存在對應的img_file的資料扣帳時候會報錯，故在此新增
               SELECT oha09 INTO li_oha09 FROM oha_file WHERE oha01 = l_omf.omf11
               IF li_oha09 = '5' THEN
               SELECT img10 INTO li_img10 FROM img_file
                WHERE img01 = l_omf.omf13
                  AND img02 = l_omf.omf20
                  AND img03 = l_omf.omf05
                  AND img04 = l_omf.omf202
                  IF SQLCA.sqlcode THEN
                     CALL s_add_img(l_omf.omf13,l_omf.omf20,l_omf.omf05,l_omf.omf202,l_omf.omf00,l_omf.omf21,l_omf.omf24)
                  END IF
               END IF
               #FUN-D20003 20130204--add--end
            END IF  
            #FUN-C60036--add--str
            IF l_omf.omf23 = 'N' THEN 
               IF g_sma.sma115 = 'N' THEN 
            #FUN-C60036--add--end
                  #No.MOD-CB0192  --Begin
                  #CALL s_upimg(l_omf.omf13,l_omf.omf20,l_omf.omf05,'',
                  CALL s_upimg(l_omf.omf13,l_omf.omf20,l_omf.omf05,l_omf.omf202,
                  #No.MOD-CB0192  --End
                      #l_type,l_omf.omf16,g_today,l_omf.omf13,'','','',#MOD-CA0062 mark
                        l_type,l_omf.omf16,g_today,l_omf.omf13,'','',l_omf.omf202,#MOD-CA0062 add
                        l_omf.omf00,l_omf.omf21,'','','','','','','','','','','','')#FUN-C60036 mod11-00 12 --21
                 #FUN-C60036--mod--str--
                 #CALL t670_tlf(l_omf.omf13,l_omf.omf20,l_omf.omf201,'',l_omf.omf16,l_omf.omf10,l_omf.omf11,l_omf.omf12,
                 #            l_omf.omf01,l_omf.omf21,l_omf.omf17,l_omf.omf09,'')
                  CALL t670_tlf(l_omf.omf13,l_omf.omf20,l_omf.omf05,l_omf.omf202,l_omf.omf16,l_omf.omf10,l_omf.omf00,l_omf.omf21,
                                l_omf.omf17,l_omf.omf09,'',l_omf.omf03,l_tlf14)   #TQC-C80042 add tlf14
                 #FUN-C60036--mod--end
            #FUN-C60036-add--str
               ELSE
                 #No.MOD-CB0192  --Begin
                 #CALL s_upimg(l_omf.omf13,l_omf.omf20,l_omf.omf05,'',
                 CALL s_upimg(l_omf.omf13,l_omf.omf20,l_omf.omf05,l_omf.omf202,
                 #No.MOD-CB0192  --End
                      #l_type,l_omf.omf917,g_today,l_omf.omf13,'','','',#MOD-CA0062 mark
                       l_type,l_omf.omf917,g_today,l_omf.omf13,'','',l_omf.omf202,#MOD-CA0062 add
                        l_omf.omf00,l_omf.omf21,'','','','','','','','','','','','') 
                 CALL t670_tlf(l_omf.omf13,l_omf.omf20,l_omf.omf05,l_omf.omf202,l_omf.omf917,l_omf.omf10,l_omf.omf00,l_omf.omf21,
                               l_omf.omf916,l_omf.omf09,'',l_omf.omf03,l_tlf14) #TQC-C80042 add tlf14
                 SELECT ima906 INTO l_ima906 FROM ima_file
                   WHERE ima01=l_omf.omf13
                     IF l_ima906 = '1' THEN
                        CALL s_upimg_imgs(
                             #No.MOD-CB0192  --Begin
                             #l_omf.omf13,l_omf.omf20,l_omf.omf05,'',l_type,
                             l_omf.omf13,l_omf.omf20,l_omf.omf05,l_omf.omf202,l_type,
                             #No.MOD-CB0192  --End
                             l_omf.omf00,l_omf.omf21,l_omf.omf910,'2')  
		            	CALL s_upimg_imgs(
                             #No.MOD-CB0192  --Begin
                             #l_omf.omf13,l_omf.omf20,l_omf.omf05,'',l_type,
                             l_omf.omf13,l_omf.omf20,l_omf.omf05,l_omf.omf202,l_type,
                             #No.MOD-CB0192  --End
                             l_omf.omf00,l_omf.omf21,l_omf.omf913,'2') 
                     END IF
                     IF l_ima906 = '2' THEN
                        IF NOT cl_null(l_omf.omf912) THEN
                             CALL t670sub_upd_imgg(
                                       #No.MOD-CB0192  --Begin
                                       #'1',l_omf.omf13,l_omf.omf20,l_omf.omf05,'',
                                        '1',l_omf.omf13,l_omf.omf20,l_omf.omf05,l_omf.omf202,
                                       #No.MOD-CB0192  --End
                                       l_omf.omf910,l_type,l_omf.omf912,l_type,'1',l_omf.omf03)
                           IF g_success = 'N' THEN
                              LET g_totsuccess="N"
                              LET g_success="Y"
                              CONTINUE FOREACH
                           END IF
                           #No.MOD-CB0192  --Begin
                           #CALL s_upimg_imgs(l_omf.omf13,l_omf.omf20,l_omf.omf05,'',l_type,
                           CALL s_upimg_imgs(l_omf.omf13,l_omf.omf20,l_omf.omf05,l_omf.omf202,l_type,
                           #No.MOD-CB0192  --End
                              l_omf.omf00,l_omf.omf21,l_omf.omf912,'2')
                        END IF

		        	    IF NOT cl_null(l_omf.omf915) THEN
                           CALL t670sub_upd_imgg(
                                        #No.MOD-CB0192  --Begin
                                        #'1',l_omf.omf13,l_omf.omf20,l_omf.omf05,'',
                                        '1',l_omf.omf13,l_omf.omf20,l_omf.omf05,l_omf.omf202,
                                        #No.MOD-CB0192  --End
                                       l_omf.omf913,l_type,l_omf.omf915,l_type,'1',l_omf.omf03)
                           IF g_success = 'N' THEN
                              LET g_totsuccess="N"
                              LET g_success="Y"
                              CONTINUE FOREACH
                           END IF
                           #No.MOD-CB0192  --Begin
                           #CALL s_upimg_imgs(l_omf.omf13,l_omf.omf20,l_omf.omf05,'',l_type,
                           CALL s_upimg_imgs(l_omf.omf13,l_omf.omf20,l_omf.omf05,l_omf.omf202,l_type,
                           #No.MOD-CB0192  --End
                              l_omf.omf00,l_omf.omf21,l_omf.omf914,'2')
                        END IF
                    END IF
                    IF l_ima906 = '3' THEN
                       CALL t670sub_upd_imgg(
                           #No.MOD-CB0192  --Begin
                           #'2',l_omf.omf13,l_omf.omf20,l_omf.omf05,'',
                            '2',l_omf.omf13,l_omf.omf20,l_omf.omf05,l_omf.omf202,
                           #No.MOD-CB0192  --End
                           l_omf.omf913,1,l_omf.omf915,l_type,'2',l_omf.omf03)
                           IF g_success = 'N' THEN
                              LET g_totsuccess="N"
                              LET g_success="Y"
                              CONTINUE FOREACH
                           END IF
                  #   END IF    #MOD-CC0206 mark
                  #  IF l_ima906 = '2' THEN #FUN-C60033 add
                  #  CALL t670sub_tlff('1',l_omf.omf13,l_omf.omf20,l_omf.omf05,l_omf.omf202,
                  #                    l_omf.omf910,l_omf.omf911,l_omf.omf912,l_omf.*,l_type,l_omf.omf03)
                  #  END IF 
	                 CALL t670sub_tlff('2',l_omf.omf13,l_omf.omf20,l_omf.omf05,l_omf.omf202,
                                       l_omf.omf913,l_omf.omf914,l_omf.omf915,l_omf.*,l_type,l_omf.omf03,l_tlf14)  #TQC-C80042 add tlf14 
                  END IF #MOD-CC0206 add
                  IF l_ima906 = '2' THEN #FUN-C60033 add
                     CALL t670sub_tlff('2',l_omf.omf13,l_omf.omf20,l_omf.omf05,l_omf.omf202,#TQC-D20046 addxuxz
                                          l_omf.omf913,l_omf.omf914,l_omf.omf915,l_omf.*,l_type,l_omf.omf03,l_tlf14)#TQC-D20046 addxuxz
                     CALL t670sub_tlff('1',l_omf.omf13,l_omf.omf20,l_omf.omf05,l_omf.omf202,
                                       l_omf.omf910,l_omf.omf911,l_omf.omf912,l_omf.*,l_type,l_omf.omf03,l_tlf14)  #TQC-C80042 add tlf14
                  END IF
               END IF 
            ELSE 
               IF g_sma.sma115= 'N' THEN 
                  SELECT SUM(ogc12) INTO l_ogc12 FROM ogc_file
                   WHERE ogc01 = l_omf.omf00
                     AND ogc03 = l_omf.omf21
                  IF l_ogc12 <> l_omf.omf16 THEN 
                     CALL cl_err('','axm-172',1)
                     LET g_success = 'N'
                     RETURN   
                  END IF
                  FOREACH omf_s_img_cs  USING l_omf.omf00,l_omf.omf21 INTO l_ogc.*
                     CALL s_upimg(l_omf.omf13,l_ogc.ogc09,l_ogc.ogc091,l_ogc.ogc092,
                      #l_type,l_ogc.ogc12,g_today,l_omf.omf13,'','','',#MOD-CA0062 mark
                        l_type,l_ogc.ogc12,g_today,l_omf.omf13,'','',l_ogc.ogc092,#MOD-CA0062 add
                        l_omf.omf00,l_omf.omf21,'','','','','','','','','','','','')#FUN-C60036 mod11-00 12 --21

                    #FUN-C60036--mod--str--
                    #CALL t670_tlf(l_omf.omf13,l_ogc.ogc09,l_ogc.ogc091,l_ogc.ogc092,l_ogc.ogc12,l_omf.omf10,l_omf.omf11,l_omf.omf12,
                    #         l_omf.omf01,l_omf.omf21,l_ogc.ogc15,l_omf.omf09,'')
                     CALL t670_tlf(l_omf.omf13,l_ogc.ogc09,l_ogc.ogc091,l_ogc.ogc092,l_ogc.ogc12,l_omf.omf10,l_omf.omf00,l_omf.omf21,
                                   l_ogc.ogc15,l_omf.omf09,'',l_omf.omf03,l_tlf14)  #TQC-C80042 add tlf14
                    #FUN-C60036--mod--end
                  END FOREACH 
               ELSE
                  SELECT SUM(ogg12) INTO l_ogg12 FROM ogg_file
                   WHERE ogg01 = = l_omf.omf00
                     AND ogg03= l_omf.omf21
                     AND ogg20 = '2'
                  IF l_ogg12 <> l_omf.omf915 THEN 
                     CALL cl_err('','axm-172',1)
                     LET g_success = 'N'
                     RETURN
                  END IF 
                  SELECT SUM(ogg12) INTO l_ogg12 FROM ogg_file
                   WHERE ogg01 = = l_omf.omf00
                     AND ogg03= l_omf.omf21
                     AND ogg20 = '1'
                  IF l_ogg12 <> l_omf.omf912 THEN
                     CALL cl_err('','axm-172',1)
                     LET g_success = 'N'
                     RETURN
                  END IF
                  FOREACH omf_s_img_cs  USING l_omf.omf00,l_omf.omf21 INTO l_ogc.*
                     CALL s_upimg(l_omf.omf13,l_ogc.ogc09,l_ogc.ogc091,l_ogc.ogc092,
                      #l_type,l_ogc.ogc12,g_today,l_omf.omf13,'','','',#MOD-CA0062--mark
                       l_type,l_ogc.ogc12,g_today,l_omf.omf13,'','',l_ogc.ogc092,#MOD-CA0062--add
                        l_omf.omf00,l_omf.omf21,'','','','','','','','','','','','')#FUN-C60036 mod11-00 12 --21

                    #FUN-C60036--mod--str--
                    #CALL t670_tlf(l_omf.omf13,l_ogc.ogc09,l_ogc.ogc091,l_ogc.ogc092,l_ogc.ogc12,l_omf.omf10,l_omf.omf11,l_omf.omf12,
                    #         l_omf.omf01,l_omf.omf21,l_ogc.ogc15,l_omf.omf09,'')
                     CALL t670_tlf(l_omf.omf13,l_ogc.ogc09,l_ogc.ogc091,l_ogc.ogc092,l_ogc.ogc12,l_omf.omf10,l_omf.omf00,l_omf.omf21,
                                   l_ogc.ogc15,l_omf.omf09,'',l_omf.omf03,l_tlf14)  #TQC-C80042 add tlf14
                    #FUN-C60036--mod--end
                  END FOREACH
                  SELECT ima906 INTO l_ima906 FROM ima_file
                   WHERE ima01=l_omf.omf13
                  FOREACH omf_s_imgg_cs  USING l_omf.omf00,l_omf.omf21 INTO l_ogg.*
                     IF l_ima906 = '1' THEN
                        CALL s_upimg_imgs(
                             l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,l_type,   
                             l_omf.omf00,l_omf.omf21,l_ogg.ogg10,'2')  #FUN-C60036 mod11-00 12 --21 
                     END IF
                     IF l_ima906 = '2' THEN
                        IF NOT cl_null(l_ogg.ogg10) THEN
                             CALL t670sub_upd_imgg(
                                        '1',l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,  
                                        l_ogg.ogg10,l_type,l_ogg.ogg12,l_type,'1',l_omf.omf03)
                          IF g_success = 'N' THEN   
                             LET g_totsuccess="N"
                             LET g_success="Y"
                             CONTINUE FOREACH
                          END IF
                          CALL s_upimg_imgs(l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,l_type,  
                             l_omf.omf00,l_omf.omf21,l_ogg.ogg10,'2')   
                       END IF
                    END IF
                    IF l_ima906 = '3' THEN
                       IF l_ogg.ogg20 = '2' THEN
                            CALL t670sub_upd_imgg(
                            '2',l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,  
                            l_ogg.ogg10,1,l_ogg.ogg12,l_type,'2',l_omf.omf03)
                           IF g_success = 'N' THEN
                              LET g_totsuccess="N"  
                              LET g_success="Y"
                              CONTINUE FOREACH
                           END IF
                           CALL t670sub_tlff(l_ogg.ogg20,l_omf.omf13,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
                                       l_ogg.ogg15,l_ogg.ogg15_fac,l_ogg.ogg12,l_omf.*,l_type,l_omf.omf03,l_tlf14)  #TQC-C80042 add tlf14
                        END IF
                     END IF
                     IF l_ima906 ='2' THEN 
                     CALL t670sub_tlff(l_ogg.ogg20,l_omf.omf13,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
                                       l_ogg.ogg15,l_ogg.ogg15_fac,l_ogg.ogg12,l_omf.*,l_type,l_omf.omf03,l_tlf14)  #TQC-C80042 add tlf14
                     END IF 
                  END FOREACH 
               END IF 
            END IF 
            #FUN-C60036--add--end
           #UPDATE omf_file SET omfpost = 'Y' WHERE omf01 = g_omf_1.omf01 AND omf02 = g_omf_1.omf02 #FUN-C60033
           #FUN-C60033--mark-by xuxz
           #UPDATE omf_file SET omfpost = 'Y' WHERE omf00 = g_omf_1.omf00                           #FUN-C60033 
           #IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
           #	 CALL cl_err3("upd","omf_file",l_omf.omf11,l_omf.omf12,STATUS,"","upd omfpost",1) 
           #   LET g_success = 'N'
           #END IF
           #FUN-C60033--mark--by xuxz

        END IF
     END FOREACH
     #FUN-C60033--add-by xuxz str
     IF g_totsuccess = 'N' THEN LET g_success = 'N' END IF 
     IF g_success = 'Y' THEN 
        UPDATE omf_file SET omfpost = 'Y' WHERE omf00 = g_omf_1.omf00
        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("upd","omf_file",'','',STATUS,"","upd omfpost",1)
           LET g_success = 'N'
        END IF  
     END IF 
     #FUN-C60033--add- by xuxz end
     
END FUNCTION

FUNCTION t670_z()
   DEFINE  l_omf    RECORD LIKE omf_file.*,
           l_type          LIKE type_file.num5,
       #FUN-C60036--add--str
           li_sql          STRING,
           l_ogc    RECORD LIKE ogc_file.*,
           l_ogg    RECORD LIKE ogg_file.*,
           l_ima906 LIKE ima_file.ima906,
           l_item   LIKE omf_file.omf13,
           l_flag   LIKE type_file.chr1
    DEFINE ls_n    LIKE type_file.num10
           #FUN-C60036--add--end     
  # IF cl_null(g_omf_1.omf01) THEN RETURN END IF       #FUN-C60036
    #TQC-D10020----add---str---
    IF g_omf_1.omf00 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    #TQC-D10020----add---end---
    CALL t670_fresh() #MOD-CC0230 add
    IF g_omf_1.omfpost='N' THEN CALL cl_err('','axm-206',0) RETURN END IF
    IF g_omf_1.omfpost='X' THEN CALL cl_err('','apm1057',0) RETURN END IF #TQC-D20009--xj--add
    #MOD-D20042 add begin-----------------------------
    SELECT sma53 INTO g_sma.sma53 FROM sma_file
    IF g_sma.sma53 IS NOT NULL AND g_omf_1.omf24 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',1)
      RETURN
    END IF
    #MOD-D20042 add end-------------------------------
    LET ls_n = 0
    SELECT COUNT(*) INTO ls_n FROM omf_file
     WHERE omf00 = g_omf_1.omf00 AND omf04 IS NOT NULL
    IF ls_n >0 THEN 
       CALL cl_err('','axm-610',0)
       RETURN
    END IF 
    IF g_oaz.oaz106 != 'Y' OR g_auto_con = 2 THEN 
       IF NOT cl_confirm('axr-137') THEN RETURN END IF 
    END IF
   #BEGIN WORK
   #FUN-C60036--ad--str
   LET li_sql = " SELECT * FROM ogc_file ",
                "  WHERE ogc01 = ? ",
                "    AND ogc03 = ? "
   PREPARE omf_z_img FROM li_sql
   DECLARE omf_z_img_cs CURSOR FOR omf_z_img
   LET li_sql = " SELECT * FROM ogg_file ",
                "  WHERE ogg01 = ? ",
                "    AND ogg03 = ? "
   PREPARE omf_z_imgg FROM li_sql
   DECLARE omf_z_imgg_cs CURSOR FOR omf_z_imgg
   #FUN-C60036--ad--end
   LET g_success='Y'
  #BEGIN WORK
      DECLARE omf_curs5 CURSOR FOR
    #  SELECT * FROM omf_file WHERE omf01 = g_omf_1.omf01 AND omf02 = g_omf_1.omf02    #FUN-C60033
       SELECT * FROM omf_file WHERE omf00 = g_omf_1.omf00                              #FUN-C60033
          AND omf10 <> '9' #FUN-C60033 add
   FOREACH omf_curs5 INTO l_omf.*
          IF cl_null(l_omf.omf20) THEN
             SELECT oaz95 INTO l_omf.omf20 FROM oaz_file
          END IF
   	  IF NOT cl_null(l_omf.omf11) AND NOT cl_null(l_omf.omf12) THEN
            IF l_omf.omf10 = '1' THEN
               LET l_type = 1
            ELSE
               LET l_type = -1
            END IF  
            #FUN-C60036--ad--str
            IF l_omf.omf13[1,4]='MISC' THEN CONTINUE FOREACH END IF
            SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01 = l_omf.omf13
            IF l_omf.omf23='Y' THEN     ##多倉儲出貨
               FOREACH omf_z_img_cs  USING l_omf.omf00,l_omf.omf21 INTO l_ogc.*
                  IF SQLCA.SQLCODE THEN
                     CALL s_errmsg('','',"FOREACH #1",SQLCA.sqlcode,1)  
                     LET g_success='N' 
                     EXIT FOREACH                
                   END IF
                    CALL ui.Interface.refresh()
                    LET l_item = l_omf.omf13
                    CALL t670_u_img(l_ogc.ogc09,l_ogc.ogc091,l_ogc.ogc092,l_ogc.ogc16,l_item,l_omf.omf00,l_omf.omf21)            	                                  
                    IF g_success='N' THEN RETURN END IF
                END FOREACH
                IF g_sma.sma115 = 'Y' THEN 
                   FOREACH omf_z_imgg_cs  USING l_omf.omf00,l_omf.omf21 INTO l_ogg.*
                      IF SQLCA.SQLCODE THEN
                         CALL s_errmsg('','',"Foreach #1",SQLCA.sqlcode,1)   
                         LET g_success='N'
                         RETURN               
                         EXIT FOREACH         
                      END IF
                      CALL ui.Interface.refresh()
                      IF l_ima906 = '1' THEN 
                         IF g_sma.sma115='Y' THEN   
                            CALL s_upimg_imgs(l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,1,l_omf.omf00,l_omf.omf21,l_ogg.ogg10,'2')        
                         END IF
                      END IF
                      IF l_ima906 = '2' THEN
                         IF l_ogg.ogg20 = '1' THEN
                            CALL t670_du(l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
                                         '','','',l_ogg.ogg10,1,l_ogg.ogg12,'1',l_omf.omf13,l_omf.omf03)
                         ELSE
                            CALL t670_du(l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
                                         l_ogg.ogg10,1,l_ogg.ogg12,'','','','1',l_omf.omf13,l_omf.omf03)
                         END IF
                         IF g_sma.sma115='Y' THEN  
                            CALL s_upimg_imgs(l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,1,l_omf.omf00,l_omf.omf21,l_ogg.ogg10,'2')        
                         END IF
                      END IF
                      IF l_ima906 = '3' THEN
                         IF l_ogg.ogg20 = '2' THEN
                            CALL t670_du(l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
                                         l_ogg.ogg10,1,l_ogg.ogg12,'','','','1',l_omf.omf13,l_omf.omf03)
                            LET l_flag = '1'   
                         END IF
                         IF g_sma.sma115='Y' THEN   
                            CALL s_upimg_imgs(l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,1,l_omf.omf00,l_omf.omf21,l_ogg.ogg10,'2')        
                         END IF
                      END IF
                      IF g_success='N' THEN 
                         EXIT FOREACH         
                      END IF
                   END FOREACH
               END IF 
            ELSE
            #FUN-C60036--ad--end
            #No.MOD-CB0192  --Begin
            #CALL s_upimg(l_omf.omf13,l_omf.omf20,l_omf.omf05,'',
            CALL s_upimg(l_omf.omf13,l_omf.omf20,l_omf.omf05,l_omf.omf202,
            #No.MOD-CB0192  --End
                1,l_omf.omf16,g_today,l_omf.omf13,'','','',
                l_omf.omf00,l_omf.omf21,'','','','','','','','','','','','')#FUN-C60036 mod11-00 12 --21
            IF g_sma.sma115 = 'Y' THEN
                      IF l_ima906 = '1' THEN
                         IF g_sma.sma115='Y' THEN
                            #No.MOD-CB0192  --Begin
                            #CALL s_upimg_imgs(l_omf.omf13,l_omf.omf20,l_omf.omf05,'',1,l_omf.omf00,l_omf.omf21,l_omf.omf916,'2')
                            CALL s_upimg_imgs(l_omf.omf13,l_omf.omf20,l_omf.omf05,l_omf.omf202,1,l_omf.omf00,l_omf.omf21,l_omf.omf916,'2')
                            #No.MOD-CB0192  --End
                         END IF
                      END IF
                      IF l_ima906 = '2' THEN
                            #No.MOD-CB0192  --Begin
                            #CALL t670_du(l_omf.omf20,l_omf.omf05,'',
                            CALL t670_du(l_omf.omf20,l_omf.omf05,l_omf.omf202,
                            #No.MOD-CB0192  --End
                                         '','','',l_omf.omf910,1,l_omf.omf912,'1',l_omf.omf13,l_omf.omf03)
                            #No.MOD-CB0192  --Begin
                            #CALL t670_du(l_omf.omf20,l_omf.omf05,'',
                            CALL t670_du(l_omf.omf20,l_omf.omf05,l_omf.omf202,
                            #No.MOD-CB0192  --End
                                         l_omf.omf913,1,l_omf.omf915,'','','','1',l_omf.omf13,l_omf.omf03)
                         IF g_sma.sma115='Y' THEN
                            CALL s_upimg_imgs(l_omf.omf13,l_omf.omf20,l_omf.omf201,l_omf.omf202,1,l_omf.omf00,l_omf.omf21,l_omf.omf910,'2')
                            CALL s_upimg_imgs(l_omf.omf13,l_omf.omf20,l_omf.omf201,l_omf.omf202,1,l_omf.omf00,l_omf.omf21,l_omf.omf913,'2')
                         END IF
                      END IF
                      IF l_ima906 = '3' THEN
                            #No.MOD-CB0192  --Begin
                            #CALL t670_du(l_omf.omf20,l_omf.omf05,'',
                            CALL t670_du(l_omf.omf20,l_omf.omf05,l_omf.omf202,
                            #No.MOD-CB0192  --End
                                         l_omf.omf913,1,l_omf.omf915,'','','','1',l_omf.omf13,l_omf.omf03)
                            LET l_flag = '1'
                         IF g_sma.sma115='Y' THEN
                            #No.MOD-CB0192  --Begin
                            #CALL s_upimg_imgs(l_omf.omf13,l_omf.omf20,l_omf.omf05,'',1,l_omf.omf00,l_omf.omf21,l_omf.omf913,'2')
                            CALL s_upimg_imgs(l_omf.omf13,l_omf.omf20,l_omf.omf05,l_omf.omf202,1,l_omf.omf00,l_omf.omf21,l_omf.omf913,'2')
                            #No.MOD-CB0192  --End
                         END IF
                      END IF
               END IF
            END IF #FUN-C60036--add
            DELETE FROM tlf_file   WHERE tlf01=l_omf.omf13 
                                    #AND tlf02=50    #FUN-C60036
                                     AND tlf026=l_omf.omf00
                                     AND tlf027=l_omf.omf21
                                     AND tlf036=l_omf.omf00
                                     AND tlf037=l_omf.omf21
            
            DELETE FROM tlff_file WHERE tlff01=l_omf.omf13 
                                    #AND tlff02=50   #FUN-C60036
                                     AND tlff026=l_omf.omf00
                                     AND tlff027=l_omf.omf21
                                     AND tlff036=l_omf.omf00
                                     AND tlff037=l_omf.omf21
        END IF
     END FOREACH
    #UPDATE omf_file SET omfpost = 'N' WHERE omf01 = g_omf_1.omf01 AND omf02 = g_omf_1.omf02  #FUN-C60033
     UPDATE omf_file SET omfpost = 'N',omf24 = ''  WHERE omf00 = g_omf_1.omf00                            #FUN-C60033 #FUN-C60036 add omf24
     IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
     	 CALL cl_err3("upd","omf_file",l_omf.omf11,l_omf.omf12,STATUS,"","upd omfpost",1) 
        LET g_success = 'N'
     END IF
END FUNCTION

#FUNCTION t670_tlf(p_part,p_ware,p_loca,p_lot,p_qty,p_sta,p_no,p_no1,p_no2,p_no3,p_unit,p_plant,p_gov)   #FUN-C60036
FUNCTION t670_tlf(p_part,p_ware,p_omf05,p_lot,p_qty,p_sta,p_omf00,p_omf21,p_unit,p_plant,p_gov,p_omf03,p_tlf14)  #TQC-C80042 add tlf14
 DEFINE p_part   LIKE img_file.img01,   ##料件編號(p_part)
        p_ware   LIKE img_file.img02,   ##倉庫
        #p_loca   LIKE img_file.img03,   ##儲位   #FUN-C60036
        p_omf05   LIKE omf_file.omf05,   ##儲位   #FUN-C60036
        p_lot    LIKE img_file.img04,   ##批號
        p_qty    LIKE img_file.img10,   ##數量
        p_sta    LIKE type_file.chr1,   ##1.出貨 2.銷退
       #FUN-C60036--mod--str--
       #p_no     LIKE inb_file.inb01,   ##来源单据编号 
       #p_no1    LIKE inb_file.inb03,   ##来源单据项次
       #p_no2    LIKE inb_file.inb11,   ##目的单据编号(参考号码) 
       #p_no3    LIKE inb_file.inb03,   ##目的单据项次
        p_omf00  LIKE omf_file.omf00,   ##開票單號
        p_omf21  LIKE omf_file.omf21,   ##開票項次
       #FUN-C60036--mod--end
        p_tlf14  LIKE tlf_file.tlf14,   ##理由碼 #TQC-C80042 
        p_plant  LIKE oga_file.ogaplant,  ##轉換率
        p_unit   LIKE ima_file.ima25,   ##單位
        p_gov    LIKE ina_file.ina04,   ##部門    
        p_omf03  LIKE omf_file.omf03,   ##发票日期
        l_ima25  LIKE ima_file.ima25,
        l_ima86  LIKE ima_file.ima86,
        l_sta    LIKE type_file.num5,
        l_cnt    LIKE type_file.num5
DEFINE l_yy         LIKE type_file.num5  #MOD-CC0049
DEFINE l_mm         LIKE type_file.num5  #MOD-CC0049
DEFINE l_img09  LIKE img_file.img09 #MOD-DC0010
   
   INITIALIZE g_tlf.* TO NULL
   LET g_tlf.tlf01=p_part        #異動料件編號

   SELECT ima25,ima86 INTO l_ima25,l_ima86 FROM ima_file WHERE ima01 = p_part
   
       LET g_tlf.tlf026=p_omf00
       LET g_tlf.tlf027=p_omf21
       LET g_tlf.tlf036=p_omf00
       LET g_tlf.tlf037=p_omf21
      #FUN-C60036--mod--end
       LET g_tlf.tlf04= ' '
       LET g_tlf.tlf05= ' ' 
      #LET g_tlf.tlf06=g_today   #FUN-C60036
      #LET g_tlf.tlf06=p_omf03   #FUN-C60036
       LET g_tlf.tlf06 = g_omf_1.omf24 #FUN-C60036 add
       LET g_tlf.tlf07=g_today
       LET g_tlf.tlf08=TIME
       LET g_tlf.tlf09=g_user
       LET g_tlf.tlf10=p_qty   
       LET g_tlf.tlf11=p_unit
       LET g_tlf.tlf13='axmt670'
       #LET g_tlf.tlf19=p_gov   #FUN-C60036 mark
       LET g_tlf.tlf19=p_omf05  #FUN-C60036 add
      #LET g_tlf.tlf60=p_plant
       
       LET g_tlf.tlfplant=g_plant
       LET g_tlf.tlflegal=g_legal
       IF p_sta = '1' THEN
       	  LET g_tlf.tlf907=-1
       	  LET g_tlf.tlf03=724
       	  LET g_tlf.tlf02=50
          LET g_tlf.tlf020=p_plant
          LET g_tlf.tlf021=p_ware
          LET g_tlf.tlf022=p_omf05
          LET g_tlf.tlf023=p_lot
          LET g_tlf.tlf024=' '
          LET g_tlf.tlf025=p_unit
          LET g_tlf.tlf030=' '
          LET g_tlf.tlf031=' '
          LET g_tlf.tlf032=' '
          LET g_tlf.tlf033=' '
          LET g_tlf.tlf034='' 
          LET g_tlf.tlf035='' 
          LET g_tlf.tlf902=g_tlf.tlf021
          LET g_tlf.tlf903=g_tlf.tlf022
          LET g_tlf.tlf904=g_tlf.tlf023
          LET g_tlf.tlf905=g_tlf.tlf026
          LET g_tlf.tlf906=g_tlf.tlf027
       ELSE
       	  LET g_tlf.tlf907=1
          LET g_tlf.tlf02=731
       	  LET g_tlf.tlf03=50
          LET g_tlf.tlf020=' '
          LET g_tlf.tlf021=' '
          LET g_tlf.tlf022=' '
          LET g_tlf.tlf023=' '
          LET g_tlf.tlf024=0
          LET g_tlf.tlf025=' '
          LET g_tlf.tlf030=p_plant
          LET g_tlf.tlf031=p_ware
          LET g_tlf.tlf032=p_omf05   #FUN-C60036
          LET g_tlf.tlf033=p_lot
          LET g_tlf.tlf034='' 
          LET g_tlf.tlf035='' 
          LET g_tlf.tlf902=g_tlf.tlf031
          LET g_tlf.tlf903=g_tlf.tlf032
          LET g_tlf.tlf904=g_tlf.tlf033
          LET g_tlf.tlf905=g_tlf.tlf036
          LET g_tlf.tlf906=g_tlf.tlf037
       END IF
       #FUN-C60036 str add-----
       IF NOT cl_null(g_tlf.tlf902) THEN
         SELECT imd09 INTO g_tlf.tlf901
           FROM imd_file
          WHERE imd01=g_tlf.tlf902
            AND imdacti = 'Y'
         IF g_tlf.tlf901 IS NULL THEN LET g_tlf.tlf901=' ' END IF
       ELSE
         LET g_tlf.tlf901=' '
       END IF
       #FUN-C60036 end add-----
       IF (g_tlf.tlf02=50 OR g_tlf.tlf03=50) THEN
       IF NOT s_tlfidle(p_plant,g_tlf.*) THEN        #更新呆滯日期
         CALL cl_err('upd ima902:','9050',1)
         LET g_success='N'
       END IF
   END IF
   LET g_tlf.tlf012=' '
   LET g_tlf.tlf013=0
   SELECT sma53 INTO g_sma.sma53 FROM sma_file
   IF g_sma.sma53 IS NOT NULL AND g_tlf.tlf06 <= g_sma.sma53 AND g_success = 'Y' THEN #TQC-CA0062 add g_success 
      CALL cl_err('','mfg9999',1)
      LET g_success = 'N'
   END IF
#MOD-CC0049 add end---------
    IF NOT cl_null(g_tlf.tlf06) THEN 
       CALL s_yp(g_tlf.tlf06) RETURNING l_yy,l_mm
       IF l_yy < g_ccz.ccz01 OR (l_yy = g_ccz.ccz01 AND l_mm < g_ccz.ccz02) THEN
          CALL cl_err('','axm-771',0)  #發票日期年月小於成本結算年月，請重新錄入！
          RETURN
       END IF
    END IF
#MOD-CC0049 add end---------    
   #FUN-C60036--add--str
   SELECT ima25 INTO l_ima25 FROM ima_file
     WHERE ima01=g_tlf.tlf01
     #取img09的值MOD-DC0010
     #CALL s_umfchk(p_part,p_unit,p_unit) RETURNING l_cnt ,g_tlf.tlf12 # MOD-DC0010
    SELECT img09 INTO l_img09 FROM img_file WHERE img01=p_part  AND img02 =p_ware
                                              AND img03=p_omf05  AND img04 = p_lot
    IF cl_null(l_img09) THEN 
       LET l_img09 = l_ima25
    END IF                                                                         
    CALL s_umfchk(p_part,p_unit,l_img09) RETURNING l_cnt ,g_tlf.tlf12  # MOD-DC0010
     
    CALL s_umfchk(g_tlf.tlf01,g_tlf.tlf11,l_ima25)
      RETURNING l_cnt,g_tlf.tlf60
    #FUN-C60036-add--end

  LET g_tlf.tlf14 = p_tlf14  #TQC-C80042

  #FUN-C60033--mod--by --xuxz
  #INSERT INTO tlf_file VALUES (g_tlf.*)
  #IF SQLCA.sqlcode THEN
  #   CALL s_errmsg('tlf01',g_tlf.tlf01,'tlf_ins',SQLCA.sqlcode,1)
  #   LET g_success = 'N'
  #END IF      
   IF g_success = 'Y' THEN #TQC-CA0062 add
      CALL s_tlf(1,0) 
   END IF #TQC-CA0062 add
  #FUN-C60033--mod--by --xuxz
   
END FUNCTION
#FUN-C60036--add--str
FUNCTION t670_b_ogg_1()   # 庫存異動明細(ogg_file)輸入
  DEFINE ls_tmp           STRING
  DEFINE r_ogg            RECORD LIKE ogg_file.*
  DEFINE r_ogc            RECORD LIKE ogc_file.*
  DEFINE l_ogg            DYNAMIC ARRAY OF RECORD
         ogg20            LIKE ogg_file.ogg20,    
         ogg09            LIKE ogg_file.ogg09,
         ogg091           LIKE ogg_file.ogg091,
         ogg092           LIKE ogg_file.ogg092,
         ogg12            LIKE ogg_file.ogg12,   
         ogg10            LIKE ogg_file.ogg10,
         img10            LIKE img_file.img10,   
         ogg15            LIKE ogg_file.ogg15,
         ogg15_fac        LIKE ogg_file.ogg15_fac,
         ogg16            LIKE ogg_file.ogg16,
         ogg18            LIKE ogg_file.ogg18    
                          END RECORD
  DEFINE l_ogg12_t1       LIKE ogg_file.ogg12
  DEFINE l_ogg16_t1       LIKE ogg_file.ogg16
  DEFINE l_ogg12_t2       LIKE ogg_file.ogg12
  DEFINE l_ogg16_t2       LIKE ogg_file.ogg16
  DEFINE l_img21          LIKE img_file.img21
  DEFINE l_ima906         LIKE ima_file.ima906
  DEFINE l_img09          LIKE img_file.img09
  DEFINE i,j,s,l_i,k      LIKE type_file.num5,   
         l_allow_insert   LIKE type_file.num5,                
         l_allow_delete   LIKE type_file.num5                
  DEFINE l_ogg17          LIKE ogg_file.ogg17    
  DEFINE l_msg            STRING
  DEFINE l_msg1           STRING
  DEFINE l_msg2           STRING

   IF g_omf[l_ac].omf23 IS NULL THEN RETURN END IF
   IF g_omf[l_ac].omf23 = 'N' THEN RETURN END IF

   SELECT COUNT(*) INTO i FROM ogg_file
    WHERE ogg01 = g_omf_1.omf00 AND ogg03 = g_omf[l_ac].omf21

   OPEN WINDOW t6701_w AT 04,02 WITH FORM "axm/42f/axmt670_1"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 

    CALL cl_ui_locale("axmt670_1")

   IF g_sma.sma122 = '1' THEN
      CALL cl_getmsg('asm-303',g_lang) RETURNING l_msg1
      CALL cl_getmsg('asm-302',g_lang) RETURNING l_msg2
      LET l_msg = '1:',l_msg1 CLIPPED,',2:',l_msg2 CLIPPED
      CALL cl_set_combo_items('ogg20','1,2',l_msg)
   END IF

   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-326',g_lang) RETURNING l_msg1
      CALL cl_getmsg('asm-304',g_lang) RETURNING l_msg2
      LET l_msg = '1:',l_msg1 CLIPPED,',2:',l_msg2 CLIPPED
      CALL cl_set_combo_items('ogg20','1,2',l_msg)
   END IF

   DECLARE t6701_ogg_c_1 CURSOR FOR
    SELECT ogg20,ogg09,ogg091,ogg092,ogg12,ogg10,0,ogg15,ogg15_fac,ogg16,ogg18    
      FROM ogg_file
     WHERE ogg01 = g_omf_1.omf00 AND ogg03 = g_omf[l_ac].omf21 
     ORDER BY ogg20    

   CALL l_ogg.clear()

   SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=g_omf[l_ac].omf13

   LET i = 1
   FOREACH t6701_ogg_c_1 INTO l_ogg[i].*
      IF STATUS THEN
         CALL cl_err('foreach ogg',STATUS,0)
         EXIT FOREACH
      END IF
      IF l_ima906 = '1' THEN
         SELECT img10 INTO l_ogg[i].img10 FROM img_file
          WHERE img01=g_omf[l_ac].omf13 AND img02=l_ogg[i].ogg09
            AND img03=l_ogg[i].ogg091   AND img04=l_ogg[i].ogg092
      END IF
      IF l_ima906 = '2' THEN
         SELECT imgg10 INTO l_ogg[i].img10 FROM imgg_file
          WHERE imgg01=g_omf[l_ac].omf13 AND imgg02=l_ogg[i].ogg09
            AND imgg03=l_ogg[i].ogg091   AND imgg04=l_ogg[i].ogg092
            AND imgg09=l_ogg[i].ogg10
      END IF
      IF l_ima906 = '3' THEN
         IF l_ogg[i].ogg20 = '2' THEN
            SELECT imgg10 INTO l_ogg[i].img10 FROM imgg_file
             WHERE imgg01=g_omf[l_ac].omf13 AND imgg02=l_ogg[i].ogg09
               AND imgg03=l_ogg[i].ogg091   AND imgg04=l_ogg[i].ogg092
               AND imgg09=l_ogg[i].ogg10
         ELSE
            SELECT img10 INTO l_ogg[i].img10 FROM img_file
             WHERE img01=g_omf[l_ac].omf13 AND img02=l_ogg[i].ogg09
               AND img03=l_ogg[i].ogg091   AND img04=l_ogg[i].ogg092
         END IF
      END IF
      IF cl_null(l_ogg[i].img10) THEN LET l_ogg[i].img10 = 0 END IF
      LET i = i + 1
   END FOREACH
   CALL l_ogg.deleteElement(i)
   LET l_i=i-1
   DISPLAY l_i TO cn2

   SELECT SUM(ogg12),SUM(ogg16) INTO l_ogg12_t1,l_ogg16_t1 FROM ogg_file
    WHERE ogg01 = g_omf_1.omf00 AND ogg03 = g_omf[l_ac].omf21
      AND ogg20 = '2'
   SELECT SUM(ogg12),SUM(ogg16) INTO l_ogg12_t2,l_ogg16_t2 FROM ogg_file
    WHERE ogg01 = g_omf_1.omf00 AND ogg03 = g_omf[l_ac].omf21
      AND ogg20 = '1'

   DISPLAY l_ogg12_t1 TO ogg12t_1
   DISPLAY l_ogg16_t1 TO ogg16t_1
   DISPLAY l_ogg12_t2 TO ogg12t_2
   DISPLAY l_ogg16_t2 TO ogg16t_2
   DISPLAY g_omf[l_ac].omf912 TO ogb12t_1   #No:MOD-590206
   DISPLAY g_omf[l_ac].omf915 TO ogb12t_2   #No:MOD-590206

   CALL cl_set_act_visible("cancel", FALSE)
   LET i=ARR_CURR()                         #No:FUN-8A0030   
   IF g_action_choice="qry_mntn_inv_detail" THEN
      DISPLAY ARRAY l_ogg TO s_ogg.* ATTRIBUTE(COUNT=l_i,UNBUFFERED)       #No.FUN-640123

      BEFORE ROW 
        LET i=ARR_CURR()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about         
         CALL cl_about()      

      ON ACTION help          
         CALL cl_show_help()  

      ON ACTION controlg      
         CALL cl_cmdask()
         
     #TQC-C80008--mark--str
     #ON ACTION qry_lot
     #   LET l_ogg[i].ogg12 = s_digqty(l_ogg[i].ogg12,l_ogg[i].ogg10)    
     #TQC-C80008--mark--end
      END DISPLAY 

   END IF
   CLOSE WINDOW t6701_w
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
END FUNCTION

FUNCTION t670_b_ogc_1()                 # 庫存異動明細(ogc_file)輸入
  DEFINE r_ogc      RECORD LIKE ogc_file.*
  DEFINE l_ogc      DYNAMIC ARRAY OF RECORD
                        ogc09     LIKE ogc_file.ogc09,
                        ogc091    LIKE ogc_file.ogc091,
                        ogc092    LIKE ogc_file.ogc092,
                        ogc12     LIKE ogc_file.ogc12,   
                         img10     LIKE img_file.img10, 
                        ogc15     LIKE ogc_file.ogc15,
                        ogc15_fac LIKE ogc_file.ogc15_fac,
                        ogc16     LIKE ogc_file.ogc16,
                        ogc18     LIKE ogc_file.ogc18   
                      END RECORD
  DEFINE l_n          LIKE type_file.num5   
  DEFINE l_ogc12_t    LIKE ogc_file.ogc12
  DEFINE l_ogc16_t    LIKE ogc_file.ogc16
  DEFINE l_img21      LIKE img_file.img21
  DEFINE i,k,s,l_i    LIKE type_file.num5,    
         l_allow_insert   LIKE type_file.num5,               
         l_allow_delete   LIKE type_file.num5                 
   
   LET p_row = 2 LET p_col = 2


   OPEN WINDOW t6702_w AT p_row,p_col WITH FORM "axm/42f/axmt670_2"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 

   CALL cl_ui_locale("axmt670_2")
   DECLARE t6702_c_1 CURSOR FOR
          SELECT ogc09,ogc091,ogc092,ogc12,'',ogc15,ogc15_fac,ogc16,ogc18   
             FROM ogc_file           
            WHERE ogc01 = g_omf_1.omf00 AND ogc03 = g_omf[l_ac].omf21
                 
   CALL l_ogc.clear()
   LET i = 1
   LET l_i = 1
   FOREACH t6702_c_1 INTO l_ogc[i].*
      IF STATUS THEN CALL cl_err('foreach ogc',STATUS,0) EXIT FOREACH END IF
      SELECT img10 INTO l_ogc[i].img10 FROM img_file
       WHERE img01=g_omf[l_ac].omf13
         AND img02=l_ogc[i].ogc09
         AND img03=l_ogc[i].ogc091
         AND img04=l_ogc[i].ogc092
      LET i = i + 1
   END FOREACH
   CALL l_ogc.deleteElement(i)
   LET l_i=(i-1)

   SELECT SUM(ogc12),SUM(ogc16) INTO l_ogc12_t,l_ogc16_t FROM ogc_file
    WHERE ogc01 = g_omf_1.omf00 AND ogc03 = g_omf[l_ac].omf21

   DISPLAY l_i TO cn2
   DISPLAY l_ogc12_t TO ogc12t
   DISPLAY l_ogc16_t TO ogc16t
   DISPLAY g_omf[l_ac].omf16 TO ogb12t                
   
   CALL cl_set_act_visible("cancel", FALSE)

   IF g_action_choice="qry_mntn_inv_detail" THEN
      DISPLAY ARRAY l_ogc TO s_ogc.* ATTRIBUTE(COUNT=l_i,UNBUFFERED)   

         BEFORE ROW
           LET i=ARR_CURR()
           CALL cl_show_fld_cont()

        #TQC-C80008 --mark--str
        #ON ACTION qry_lot
        #   LET l_ogc[i].ogc12 = s_digqty(l_ogc[i].ogc12,g_omf[l_ac].omf17)  
        #TQC-C80008 --mark--end
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION help          
            CALL cl_show_help()  
         
         ON ACTION controlg      
            CALL cl_cmdask()     

      END DISPLAY 

   END IF

   CLOSE WINDOW t6702_w 

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF

END FUNCTION

FUNCTION t670_ogg_ogc()
   DEFINE li_sql STRING 
   DEFINE li_ogg RECORD LIKE ogg_file.*
   DEFINE li_ogc12 LIKE ogc_file.ogc12,
          li_ogg12 LIKE ogg_file.ogg12
   DEFINE li_ogc RECORD LIKE ogc_file.*
   DEFINE l_n           LIKE type_file.num5   #add TQC-D10102
   IF g_sma.sma115 = 'Y' THEN
      DELETE FROM ogg_file WHERE ogg01 = g_omf_1.omf00 AND ogg03 = g_omf_t.omf21   
      LET li_sql = " SELECT ogg092,ogg10,SUM(ogg12),ogg15,ogg15_fac,ogg16, ",
                   "  ogg20,ogg17,oggplant,ogglegal,SUM(ogg13) FROM ogg_file", #出貨簽收沒有完成故mark FUN-C50097 取消mark
                   #"  ogg20,ogg17,oggplant,ogglegal FROM ogg_file",
                   "  WHERE ogg01 = '",g_omf[l_ac].omf11,"'",
                   "    AND ogg03 = '",g_omf[l_ac].omf12,"'",
                   "  GROUP BY ogg092,ogg10,ogg15,ogg15_fac,ogg16,ogg20,ogg17,oggplant,ogglegal"
      PREPARE t670_ogg_pre FROM li_sql
      DECLARE t670_ogg_cs CURSOR FOR t670_ogg_pre
      #固定值
      SELECT oaz95 INTO li_ogg.ogg09  FROM oaz_file 
      LET li_ogg.ogg091 = g_omf_1.omf05
      LET li_ogg.ogg01 = g_omf_1.omf00
      LET li_ogg.ogg03 = g_omf[l_ac].omf21
      LET li_ogg.ogg18 = 1
      FOREACH t670_ogg_cs INTO li_ogg.ogg092,li_ogg.ogg10,li_ogg.ogg12,li_ogg.ogg15,
                               li_ogg.ogg15_fac,li_ogg.ogg16,li_ogg.ogg20,li_ogg.ogg17,
                               li_ogg.oggplant,li_ogg.ogglegal ,li_ogg.ogg13 #出貨簽收沒有完成故mark
         LET li_ogg12 = 0
         LET li_sql = " SELECT SUM(ogg12) FROM ogg_file",
                "                             ,omf_file",   #add#TQC-D10102
               #"  WHERE ogg01 IN (SELECT ogg01 FROM ogg_file,",cl_get_target_table(g_omf[l_ac].omf09,'oay_file'),#TQC-D10102 mark
                "  WHERE (ogg01,ogg03) IN (SELECT ogg01,ogg03 FROM ogg_file,",cl_get_target_table(g_omf[l_ac].omf09,'oay_file'),#TQC-D10102 add
                "                   WHERE ogg01 != '",g_omf_1.omf00,"'",
                "                     AND ogg09 = '",li_ogg.ogg09,"'",
                "                     AND ogg091 = '",li_ogg.ogg091,"'",
                "                     AND ogg17 = '",g_omf[l_ac].omf13,"'",
                "                     AND ogg20 = '",li_ogg.ogg20,"'",
                "                     AND ogg092 = '",li_ogg.ogg092,"'",
               #TQC-D10102--add--str
                "                     AND (ogg01,ogg03) IN ( SELECT omf00,omf21 FROM omf_file ",
                "                                             WHERE omf11 = '",g_omf[l_ac].omf11,"'",
                "                                               AND omf12 = '",g_omf[l_ac].omf12,"')",
               #TQC-D10102--add--end
                "   AND ogg01 like ltrim(rtrim(oayslip))||'-%'  AND oaytype = '70') ",                    
                "    AND ogg09 = '",li_ogg.ogg09,"'",
                "    AND ogg091 = '",li_ogg.ogg091,"'",
                "    AND ogg17 = '",g_omf[l_ac].omf13,"'",
                "    AND ogg20 = '",li_ogg.ogg20,"'",
                "    AND ogg092 = '",li_ogg.ogg092,"'"
               #add TQC-D10102 ---start---
               ,"    AND ogg01 = omf00 AND ogg03 = omf21 "
               ,"    AND omf11 = '",g_omf[l_ac].omf11,"'"
               ,"    AND omf12 = '",g_omf[l_ac].omf12,"'"
               #add TQC-D10102 ---end---
         CALL cl_replace_sqldb(li_sql) RETURNING li_sql
         CALL cl_parse_qry_sql(li_sql,g_omf[l_ac].omf09) RETURNING li_sql
         PREPARE t670_chknumogg12_pre_2 FROM li_sql
         EXECUTE t670_chknumogg12_pre_2 INTO li_ogg12
         IF cl_null(li_ogg12) THEN LET li_ogg12 = 0 END IF 
##add TQC-D10102 ---start---
         SELECT COUNT(*) INTO l_n FROM ogg_file
          WHERE ogg01 = li_ogg.ogg01
            AND ogg03 = li_ogg.ogg03
            AND ogg09 = li_ogg.ogg09
            AND ogg091 = li_ogg.ogg091
            AND ogg092 = li_ogg.ogg092
            AND ogg10 = li_ogg.ogg10
            AND ogg17 = li_ogg.ogg17
         IF l_n > 0 THEN
            UPDATE ogg_file
               SET ogg12 = ogg12 + li_ogg.ogg12,
                   ogg13 = ogg13 + li_ogg.ogg13,
                   ogg16 = ogg16 + li_ogg.ogg16
             WHERE ogg01 = li_ogg.ogg01
               AND ogg03 = li_ogg.ogg03
               AND ogg09 = li_ogg.ogg09
               AND ogg091 = li_ogg.ogg091
               AND ogg092 = li_ogg.ogg092
               AND ogg10 = li_ogg.ogg10
               AND ogg17 = li_ogg.ogg17
         ELSE
#add TQC-D10102 ---end---
            LET li_ogg.ogg12 = li_ogg.ogg12 - li_ogg12
            LET li_ogg.ogg16 = li_ogg.ogg12 * li_ogg.ogg15_fac
            INSERT INTO ogg_file VALUES(li_ogg.*)
            LET li_ogg.ogg18 = li_ogg.ogg18 +1
         END IF   #add TQC-D10102 
      END FOREACH 
      SELECT SUM(ogg12) INTO g_omf[l_ac].omf915
        FROM ogg_file
       WHERE ogg01 = g_omf_1.omf00
         AND ogg03 = g_omf[l_ac].omf21
         AND ogg20 = '2'
      SELECT SUM(ogg12) INTO g_omf[l_ac].omf912
        FROM ogg_file
       WHERE ogg01 = g_omf_1.omf00
         AND ogg03 = g_omf[l_ac].omf21
         AND ogg20 = '1'
      CALL t670_sum_omf917()
      LET g_omf[l_ac].omf16 = g_omf[l_ac].omf917
   ELSE
      DELETE FROM ogc_file WHERE ogc01 = g_omf_1.omf00 AND ogc03 = g_omf[l_ac].omf21  
      LET li_sql = " SELECT ogc092,SUM(ogc12),ogc15,ogc15_fac,SUM(ogc16), ",
                  " ogc17,ogcplant,ogclegal,SUM(ogc13) FROM ogc_file",#出貨簽收沒有完成故mark
                  # " ogc17,ogcplant,ogclegal FROM ogc_file",
                   "  WHERE ogc01 = '",g_omf[l_ac].omf11,"'",
                   "    AND ogc03 = '",g_omf[l_ac].omf12,"'",
                   "  GROUP BY ogc092,ogc15,ogc15_fac,ogc17,ogcplant,ogclegal"
      PREPARE t670_ogc_pre FROM li_sql
      DECLARE t670_ogc_cs CURSOR FOR t670_ogc_pre
      #固定值
      SELECT oaz95 INTO li_ogc.ogc09  FROM oaz_file 
      LET li_ogc.ogc091 = g_omf_1.omf05
      LET li_ogc.ogc01 = g_omf_1.omf00
      LET li_ogc.ogc03 = g_omf[l_ac].omf21
      LET li_ogc.ogc18 = 1
      IF cl_null(li_ogc.ogc09) THEN LET li_ogc.ogc09=' ' END IF #add by dengsy160531
      FOREACH t670_ogc_cs INTO li_ogc.ogc092,li_ogc.ogc12,li_ogc.ogc15,
                               li_ogc.ogc15_fac,li_ogc.ogc16,li_ogc.ogc17,
                               li_ogc.ogcplant,li_ogc.ogclegal ,li_ogc.ogc13 #出貨簽收沒有完成故mark
         LET li_ogc12 = 0  
         LET li_sql = " SELECT SUM(ogc12) FROM ogc_file ",
                     #"  WHERE ogc01 IN ( SELECT ogc01 FROM ogc_file, ",cl_get_target_table(g_omf[l_ac].omf09,'oay_file'),#TQC-D10102 mark
                      "  WHERE (ogc01,ogc03) IN ( SELECT ogc01,ogc03 FROM ogc_file, ",cl_get_target_table(g_omf[l_ac].omf09,'oay_file'),#TQC-D10102 add
                      "                          WHERE ogc09 = '",li_ogc.ogc09,"'",
                      "   AND ogc01 like ltrim(rtrim(oayslip))||'-%'  AND oaytype = '70' ",
                      "                            AND ogc091 = '",li_ogc.ogc091,"'",
                      "                            AND ogc092 = '",li_ogc.ogc092,"'",
                      "                            AND ogc17 = '",g_omf[l_ac].omf13,"'",
                     #TQC-D10102--add--str
                      "                            AND (ogc01,ogc03) IN ( SELECT omf00,omf21 FROM omf_file ",
                      "                                                    WHERE omf11 = '",g_omf[l_ac].omf11,"'",
                      "                                                      AND omf12 = '",g_omf[l_ac].omf12,"')",
                     #TQC-D10102--add--end
                      "                            AND ogc01 != '",g_omf_1.omf00,"') ",
                      "   AND ogc09 = '",li_ogc.ogc09,"'",
                      "   AND ogc17 = '",g_omf[l_ac].omf13,"'",
                      "   AND ogc091 = '",li_ogc.ogc091,"'",
                      "    AND ogc092 = '",li_ogc.ogc092,"'"
         CALL cl_replace_sqldb(li_sql) RETURNING li_sql            
         CALL cl_parse_qry_sql(li_sql,g_omf[l_ac].omf09) RETURNING li_sql
         PREPARE t670_chknumogc12_pre_3 FROM li_sql
         EXECUTE t670_chknumogc12_pre_3 INTO li_ogc12
         IF cl_null(li_ogc12) THEN LET li_ogc12 = 0 END IF 
         LET li_ogc.ogc12 = li_ogc.ogc12 - li_ogc12
         LET li_ogc.ogc16 = li_ogc.ogc12 * li_ogc.ogc15_fac
         INSERT INTO ogc_file VALUES(li_ogc.*)
         #str------ add by dengsy160606
         IF SQLCA.sqlcode THEN
                CALL s_errmsg('','',"INS ogc:",SQLCA.sqlcode,1)         
                LET g_success = 'N'
                EXIT FOREACH               
             END IF
         #end------ add by dengsy160606
         LET li_ogc.ogc18 = li_ogc.ogc18+1
      END FOREACH
      SELECT SUM(ogc12) INTO  g_omf[l_ac].omf16 FROM ogc_file
       WHERE ogc01 = g_omf_1.omf00
       AND ogc03 = g_omf[l_ac].omf21
      LET g_omf[l_ac].omf917 = g_omf[l_ac].omf16
      LET g_sql = " SELECT gec05,gec07,gec04 FROM ",cl_get_target_table(g_plant_new,'gec_file'),
                  "  WHERE gec01='",g_omf_1.omf06,"' ",
                  "    AND gec011 = '2'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE sel_gec07_pre1_2 FROM g_sql
      EXECUTE sel_gec07_pre1_2 INTO g_gec05,g_gec07,g_omf_1.omf061
      IF g_gec07 = 'Y' THEN    #含稅
         #未稅金額=(含稅單價*數量)/(1+稅率/100)
         IF g_omf[l_ac].omf16 <> 0 THEN
            LET g_omf[l_ac].omf29 = cl_digcut((g_omf[l_ac].omf28*g_omf[l_ac].omf16),t_azi04)/(1+g_omf_1.omf061/100)
            LET g_omf[l_ac].omf29t = g_omf[l_ac].omf16 * g_omf[l_ac].omf28
         END IF
      ELSE            #不含稅
         #未稅金額=未稅單價*數量
         IF g_omf[l_ac].omf16 <> 0 THEN
            LET g_omf[l_ac].omf29 = g_omf[l_ac].omf16 * g_omf[l_ac].omf28
            LET g_omf[l_ac].omf29 = cl_digcut(g_omf[l_ac].omf29,t_azi04)
            LET g_omf[l_ac].omf29t = g_omf[l_ac].omf29 * (1+g_omf_1.omf061/100)
         END IF
      END IF

      LET g_omf[l_ac].omf29 = cl_digcut(g_omf[l_ac].omf29,t_azi04)
      LET g_omf[l_ac].omf29t = cl_digcut(g_omf[l_ac].omf29t,t_azi04)
      LET g_omf[l_ac].omf29x = g_omf[l_ac].omf29t -g_omf[l_ac].omf29 #原幣稅額
      LET g_omf[l_ac].omf29x = cl_digcut(g_omf[l_ac].omf29x,t_azi04)
      LET g_omf[l_ac].omf19 = g_omf[l_ac].omf29 * g_omf_1.omf22
      LET g_omf[l_ac].omf19 = cl_digcut(g_omf[l_ac].omf19,g_azi04)     #本幣
      LET g_omf[l_ac].omf19t = g_omf[l_ac].omf29t * g_omf_1.omf22
      LET g_omf[l_ac].omf19t = cl_digcut(g_omf[l_ac].omf19t,g_azi04)   #本幣
      LET g_omf[l_ac].omf19x = g_omf[l_ac].omf19t - g_omf[l_ac].omf19
      LET g_omf[l_ac].omf19t = g_omf[l_ac].omf29t * g_omf_1.omf22
      LET g_omf[l_ac].omf19t = cl_digcut(g_omf[l_ac].omf19t,g_azi04)   #本幣
      LET g_omf[l_ac].omf19x = g_omf[l_ac].omf19t - g_omf[l_ac].omf19
      LET g_omf[l_ac].omf19x = cl_digcut(g_omf[l_ac].omf19x,g_azi04)   #本幣
   END IF
END FUNCTION 
FUNCTION t670_b_ogg() 
   DEFINE r_ogg            RECORD LIKE ogg_file.*
   DEFINE r_ogc            RECORD LIKE ogc_file.*
   DEFINE l_ogg            DYNAMIC ARRAY OF RECORD
          ogg20            LIKE ogg_file.ogg20,       
          ogg09            LIKE ogg_file.ogg09,
          ogg091           LIKE ogg_file.ogg091,
          ogg092           LIKE ogg_file.ogg092,
          ogg12            LIKE ogg_file.ogg12,       
          ogg10            LIKE ogg_file.ogg10,
          img10            LIKE img_file.img10,       
          ogg15            LIKE ogg_file.ogg15, 
          ogg15_fac        LIKE ogg_file.ogg15_fac,
          ogg16            LIKE ogg_file.ogg16,
          ogg18            LIKE ogg_file.ogg18
                           END RECORD
  #出貨簽收沒有完成故mark 
  DEFINE li_ogg           DYNAMIC ARRAY OF RECORD
           ogg13          LIKE ogg_file.ogg13
                          END RECORD
   DEFINE l_ogg_t            RECORD
          ogg20            LIKE ogg_file.ogg20,       
          ogg09            LIKE ogg_file.ogg09,
          ogg091           LIKE ogg_file.ogg091,
          ogg092           LIKE ogg_file.ogg092,
          ogg12            LIKE ogg_file.ogg12,       
          ogg10            LIKE ogg_file.ogg10,
          img10            LIKE img_file.img10,       
          ogg15            LIKE ogg_file.ogg15, 
          ogg15_fac        LIKE ogg_file.ogg15_fac,
          ogg16            LIKE ogg_file.ogg16,
          ogg18            LIKE ogg_file.ogg18
                           END RECORD
   DEFINE l_ogg12_t1       LIKE ogg_file.ogg12
   DEFINE l_ogg16_t1       LIKE ogg_file.ogg16
   DEFINE l_ogg12_t2       LIKE ogg_file.ogg12
   DEFINE l_ogg16_t2       LIKE ogg_file.ogg16
   DEFINE l_img21          LIKE img_file.img21
   DEFINE l_ima906         LIKE ima_file.ima906
   DEFINE l_img09          LIKE img_file.img09
   DEFINE i,j,s,l_i,k      LIKE type_file.num5,      
          l_allow_insert   LIKE type_file.num5,       #可新增否  
          l_allow_delete   LIKE type_file.num5        #可刪除否  
   DEFINE l_ogg18          LIKE ogg_file.ogg18        
   DEFINE l_pmd            LIKE type_file.chr1
   DEFINE l_msg            STRING
   DEFINE l_msg1           STRING
   DEFINE l_msg2           STRING
   DEFINE l_msg3           STRING                     
   DEFINE l_cnt            LIKE type_file.num5       
   DEFINE l_bno            LIKE rvbs_file.rvbs08     
   DEFINE l_oea00          LIKE oea_file.oea00,       
          l_oea11          LIKE oea_file.oea11,      
          l_oea12          LIKE oea_file.oea12,      
          l_oga16          LIKE oga_file.oga16        
   DEFINE l_flag           LIKE type_file.chr1       
  DEFINE g_ogg18      LIKE ogg_file.ogg18 
   IF g_omf[l_ac].omf23 IS NULL THEN RETURN END IF 
   IF g_omf[l_ac].omf23 = 'N' THEN RETURN END IF 
   SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=g_omf[l_ac].omf13
   SELECT count(*) INTO i FROM ogg_file 
    WHERE ogg01 = g_omf_1.omf00 AND ogg03 = g_omf[l_ac].omf21
   IF i = 0 THEN CALL t670_ogg_ogc() END IF 
   OPEN WINDOW t6701_w AT 04,02 WITH FORM "axm/42f/axmt670_1"
       ATTRIBUTE (STYLE = g_win_style CLIPPED )
   CALL cl_ui_locale("axmt670_1")
   IF g_sma.sma122 = '1' THEN
      CALL cl_getmsg('asm-303',g_lang) RETURNING l_msg1
      CALL cl_getmsg('asm-302',g_lang) RETURNING l_msg2
      LET l_msg = '1:',l_msg1 CLIPPED,',2:',l_msg2 CLIPPED
      CALL cl_set_combo_items('ogg20','1,2',l_msg)
   END IF

   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-326',g_lang) RETURNING l_msg1
      CALL cl_getmsg('asm-304',g_lang) RETURNING l_msg2
      LET l_msg = '1:',l_msg1 CLIPPED,',2:',l_msg2 CLIPPED
      CALL cl_set_combo_items('ogg20','1,2',l_msg)
   END IF
      DECLARE t6706_ogg_c CURSOR FOR
    SELECT ogg20,ogg09,ogg091,ogg092,ogg12,ogg10,0,ogg15,ogg15_fac,ogg16,ogg18,ogg13   #出貨簽收沒有完成故mark
      FROM ogg_file
     WHERE ogg01 = g_omf_1.omf00 AND ogg03 = g_omf[l_ac].omf21     
     ORDER BY ogg20      

   CALL l_ogg.clear()

   LET i = 1
   FOREACH t6706_ogg_c INTO l_ogg[i].* ,li_ogg[i].ogg13 #出貨簽收沒有完成故mark
      IF STATUS THEN
         CALL cl_err('foreach ogg',STATUS,0)
         EXIT FOREACH
      END IF
      IF l_ima906 = '1' THEN
         SELECT img10 INTO l_ogg[i].img10 FROM img_file
          WHERE img01=g_omf[l_ac].omf13 AND img02=l_ogg[i].ogg09
            AND img03=l_ogg[i].ogg091   AND img04=l_ogg[i].ogg092
      END IF
      IF l_ima906 = '2' THEN
         SELECT imgg10 INTO l_ogg[i].img10 FROM imgg_file
          WHERE imgg01=g_omf[l_ac].omf13  AND imgg02=l_ogg[i].ogg09
            AND imgg03=l_ogg[i].ogg091   AND imgg04=l_ogg[i].ogg092
            AND imgg09=l_ogg[i].ogg10
      END IF
      IF l_ima906 = '3' THEN
         IF l_ogg[i].ogg20 = '2' THEN
            SELECT imgg10 INTO l_ogg[i].img10 FROM imgg_file
             WHERE imgg01=g_omf[l_ac].omf13  AND imgg02=l_ogg[i].ogg09
               AND imgg03=l_ogg[i].ogg091   AND imgg04=l_ogg[i].ogg092
               AND imgg09=l_ogg[i].ogg10
         ELSE
            SELECT img10 INTO l_ogg[i].img10 FROM img_file
             WHERE img01=g_omf[l_ac].omf13  AND img02=l_ogg[i].ogg09
               AND img03=l_ogg[i].ogg091   AND img04=l_ogg[i].ogg092
         END IF
      END IF
      IF cl_null(l_ogg[i].img10) THEN LET l_ogg[i].img10 = 0 END IF
      LET i = i + 1
   END FOREACH
   CALL l_ogg.deleteElement(i)
   LET l_i=i-1
   DISPLAY l_i TO cn2

   SELECT SUM(ogg12),SUM(ogg16) INTO l_ogg12_t1,l_ogg16_t1 FROM ogg_file
    WHERE ogg01 = g_omf_1.omf00 AND ogg03 = g_omf[l_ac].omf21
      AND ogg20 = '1'
   SELECT SUM(ogg12),SUM(ogg16) INTO l_ogg12_t2,l_ogg16_t2 FROM ogg_file
    WHERE ogg01 = g_omf_1.omf00 AND ogg03 = g_omf[l_ac].omf21
      AND ogg20 = '2'

   DISPLAY l_ogg12_t1 TO ogg12t_1
   DISPLAY l_ogg16_t1 TO ogg16t_1
   DISPLAY l_ogg12_t2 TO ogg12t_2
   DISPLAY l_ogg16_t2 TO ogg16t_2
   DISPLAY g_omf[l_ac].omf912 TO ogb12t_1   
   DISPLAY g_omf[l_ac].omf915 TO ogb12t_2   
   
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
   LET g_forupd_sql = " SELECT ogg20,ogg09,ogg091,ogg092,ogg12,ogg10,'',ogg15,ogg15_fac,ogg16,ogg18",
                      "   FROM ogg_file ",
                      "  WHERE ogg01 = ? AND ogg03 = ? ",
                      "    AND ogg09 = ? AND ogg091 = ? ",
                      "    AND ogg092 = ? AND ogg10 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t670_ogg_bcl CURSOR FROM g_forupd_sql
   CALL cl_set_comp_entry("ogg09,ogg091,ogg092,ogg20,",FALSE)
   INPUT ARRAY l_ogg WITHOUT DEFAULTS FROM s_ogg.*
         ATTRIBUTE(COUNT=l_i,MAXCOUNT=l_i,UNBUFFERED,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF l_i != 0 THEN
            CALL fgl_set_arr_curr(i)
         END IF
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE
         LET g_ogg18 = 0
         SELECT MAX(ogg18)+1 INTO g_ogg18 
           FROM ogg_file
           WHERE ogg01 = g_omf_1.omf00 AND ogg03 = g_omf[l_ac].omf21 
         IF cl_null(g_ogg18) OR g_ogg18 = 0 THEN
            LET g_ogg18 = 1
         END IF
      AFTER INPUT
        IF INT_FLAG THEN LET INT_FLAG = 0 EXIT INPUT END IF
        IF l_ogg12_t1 != g_omf[l_ac].omf912 OR l_ogg12_t2 != g_omf[l_ac].omf915 THEN
           IF cl_confirm('axm-170') THEN
              EXIT INPUT
           ELSE
              NEXT FIELD ogg09
           END IF
        END IF
      BEFORE ROW
        LET p_cmd = ''
           LET i = ARR_CURR()
           LET l_lock_sw = 'N'           
           LET l_n  = ARR_COUNT()
          #BEGIN WORK
 
           IF l_i >= i THEN
              LET p_cmd='u'
              LET l_ogg_t.* = l_ogg[i].*     
              OPEN t670_ogg_bcl USING g_omf_1.omf00,g_omf[l_ac].omf21,l_ogg_t.ogg09,
                                      l_ogg_t.ogg091,l_ogg_t.ogg092,l_ogg_t.ogg10
              IF STATUS THEN
                 CALL cl_err("OPEN t670_ogg_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t670_ogg_bcl INTO l_ogg[i].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('',SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT img09 INTO l_ogg[i].ogg15
                   FROM img_file
                  WHERE img01 = g_omf[l_ac].omf13
                    AND img02 = l_ogg[i].ogg09
                    AND img03 = l_ogg[i].ogg091
                    AND img04 = l_ogg[i].ogg092
                 DISPLAY l_ogg[i].ogg15 TO ogg15
                 IF l_ima906 = '1' THEN
                    SELECT img10 INTO l_ogg[i].img10 FROM img_file
                     WHERE img01=g_omf[l_ac].omf13 AND img02=l_ogg[i].ogg09
                       AND img03=l_ogg[i].ogg091   AND img04=l_ogg[i].ogg092
                 END IF
                 IF l_ima906 = '2' THEN
                    SELECT imgg10 INTO l_ogg[i].img10 FROM imgg_file
                     WHERE imgg01=g_omf[l_ac].omf13  AND imgg02=l_ogg[i].ogg09
                       AND imgg03=l_ogg[i].ogg091   AND imgg04=l_ogg[i].ogg092
                       AND imgg09=l_ogg[i].ogg10
                 END IF
                 IF l_ima906 = '3' THEN
                    IF l_ogg[i].ogg20 = '2' THEN
                       SELECT imgg10 INTO l_ogg[i].img10 FROM imgg_file
                        WHERE imgg01=g_omf[l_ac].omf13  AND imgg02=l_ogg[i].ogg09
                          AND imgg03=l_ogg[i].ogg091   AND imgg04=l_ogg[i].ogg092
                          AND imgg09=l_ogg[i].ogg10
                    ELSE
                       SELECT img10 INTO l_ogg[i].img10 FROM img_file
                        WHERE img01=g_omf[l_ac].omf13  AND img02=l_ogg[i].ogg09
                          AND img03=l_ogg[i].ogg091   AND img04=l_ogg[i].ogg092
                    END IF
                 END IF
                 IF cl_null(l_ogg[i].img10) THEN LET l_ogg[i].img10 = 0 END IF
              END IF   
           END IF     

      BEFORE INSERT   
         LET l_n = ARR_COUNT()
         LET p_cmd = 'a'
         INITIALIZE l_ogg[i].* TO NULL
         IF cl_null(l_ogg[i].ogg18) OR l_ogg[i].ogg18 = 0 THEN
            LET l_ogg[i].ogg18 = g_ogg18
         END IF
         LET l_ogg[i].ogg09 = g_oaz.oaz95
         LET l_ogg[i].ogg091 = g_omf_1.omf05
         LET l_ogg[i].ogg10 = g_omf[l_ac].omf913
         LET l_ogg[i].ogg15 = g_omf[l_ac].omf913
         LET l_ogg[i].ogg15_fac = 1
         LET l_ogg_t.* = l_ogg[i].*
         CALL cl_show_fld_cont()     
         NEXT FIELD ogg20
         
      AFTER FIELD ogg12
         IF NOT cl_null(l_ogg[i].ogg12) THEN 
            CALL t670_chknumogg12(l_ogg[i].*)
            IF g_errno !='     ' OR NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD ogg12
            END IF
         END IF 
      AFTER INSERT
         IF INT_FLAG THEN                
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           EXIT INPUT
        END IF
        IF l_ogg[i].ogg12 IS NOT NULL AND l_ogg[i].ogg12 != 0 THEN
           IF l_ogg[i].ogg09 IS NULL THEN LET l_ogg[i].ogg09 = ' ' END IF
           IF l_ogg[i].ogg091 IS NULL THEN LET l_ogg[i].ogg091 = ' ' END IF
           IF l_ogg[i].ogg092 IS NULL THEN LET l_ogg[i].ogg092 = ' ' END IF
           IF l_ima906 = '1' THEN
              SELECT img10,img09,img21
                INTO l_ogg[i].img10,l_ogg[i].ogg15,l_img21
                FROM img_file
               WHERE img01 = g_omf[l_ac].omf13 AND img02 = l_ogg[i].ogg09
                 AND img03 = l_ogg[i].ogg091   AND img04 = l_ogg[i].ogg092
              IF STATUS THEN
                 CALL cl_err3("sel","img_file","","",SQLCA.sqlcode,"","sel img",1)  #No.FUN-670008
                 NEXT FIELD ogg09
              END IF
              CALL s_umfchk(g_omf[l_ac].omf13,l_ogg[i].ogg10,l_ogg[i].ogg15)
                            RETURNING g_cnt,l_ogg[i].ogg15_fac
              IF g_cnt=1 THEN 
                 CALL cl_err('','mfg3075',1) 
                #TQC-C50131 -- add -- begin
                 CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg3
                 LET l_msg3 = l_msg3 CLIPPED,"(",g_omf[l_ac].omf13,")"
                 CALL cl_msgany(10,20,l_msg3)
                #TQC-C50131 -- add -- end
                 NEXT FIELD ogg092 
              END IF
              IF cl_null(l_ogg[i].ogg15_fac) THEN LET l_ogg[i].ogg15_fac=1 END IF
           END IF
           IF l_ima906 = '2' THEN
              SELECT imgg10,imgg09,imgg21
                INTO l_ogg[i].img10,l_ogg[i].ogg15,l_img21
                FROM imgg_file
               WHERE imgg01 = g_omf[l_ac].omf13 AND imgg02 = l_ogg[i].ogg09
                 AND imgg03 = l_ogg[i].ogg091   AND imgg04 = l_ogg[i].ogg092
                 AND imgg09 = l_ogg[i].ogg10
              IF STATUS THEN
                 CALL cl_err3("sel","imgg_file","","",SQLCA.sqlcode,"","sel imgg",1)  #No.FUN-670008
                 NEXT FIELD ogg09
              END IF
              LET l_ogg[i].ogg15_fac = 1
           END IF
           IF l_ima906 = '3' THEN
              IF l_ogg[i].ogg20 = '1' THEN
                 SELECT img10,img09,img21
                   INTO l_ogg[i].img10,l_ogg[i].ogg15,l_img21
                   FROM img_file
                  WHERE img01 = g_omf[l_ac].omf13 AND img02 = l_ogg[i].ogg09
                    AND img03 = l_ogg[i].ogg091   AND img04 = l_ogg[i].ogg092
                 IF STATUS THEN
                    CALL cl_err3("sel","img_file","","",SQLCA.sqlcode,"","sel img",1)  #No.FUN-670008
                    NEXT FIELD ogg09
                 END IF
                 CALL s_umfchk(g_omf[l_ac].omf13,l_ogg[i].ogg10,l_ogg[i].ogg15)
                               RETURNING g_cnt,l_ogg[i].ogg15_fac
                 IF g_cnt=1 THEN 
                    CALL cl_err('','mfg3075',1) 
                   #TQC-C50131 -- add -- begin
                    CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg3
                    LET l_msg3 = l_msg3 CLIPPED,"(",g_omf[l_ac].omf13,")"
                    CALL cl_msgany(10,20,l_msg3)
                   #TQC-C50131 -- add -- end
                    NEXT FIELD ogg092 
                 END IF
                 IF cl_null(l_ogg[i].ogg15_fac) THEN LET l_ogg[i].ogg15_fac=1 END IF
              END IF
              IF l_ogg[i].ogg20 = '2' THEN
                 SELECT imgg10,imgg09,imgg21
                   INTO l_ogg[i].img10,l_ogg[i].ogg15,l_img21
                   FROM imgg_file
                  WHERE imgg01 = g_omf[l_ac].omf13 AND imgg02 = l_ogg[i].ogg09
                    AND imgg03 = l_ogg[i].ogg091   AND imgg04 = l_ogg[i].ogg092
                    AND imgg09 = l_ogg[i].ogg10
                 IF STATUS THEN
                    CALL cl_err3("sel","imgg_file","","",SQLCA.sqlcode,"","sel imgg",1)  #No.FUN-670008
                    NEXT FIELD ogg09
                 END IF
                 LET l_ogg[i].ogg15_fac = 1
              END IF
           END IF
           DISPLAY l_ogg[i].img10 TO img10
           DISPLAY l_ogg[i].ogg15 TO ogg15
           LET l_ogg[i].ogg16 = l_ogg[i].ogg12 * l_ogg[i].ogg15_fac
           LET l_ogg[i].ogg16 = s_digqty(l_ogg[i].ogg16,l_ogg[i].ogg15)   #FUN-910088--add--
           DISPLAY l_ogg[i].ogg16 TO s_ogg[j].ogg16
        END IF
        IF g_sma.sma117 = 'N' THEN
           #IF l_ogg[i].ogg12 > l_ogg[i].img10 THEN   #MOD-A70059
           IF l_ogg[i].ogg16 > l_ogg[i].img10 THEN   #MOD-A70059
              LET g_flag1 = NULL    #FUN-C80107 add
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],l_ogg[i].ogg09) RETURNING g_flag1   #FUN-C80107 add
             #IF g_sma.sma894[2,2]='N' OR g_sma.sma894[2,2] IS NULL THEN     #FUN-C80107 mark   
              CALL s_inv_shrt_by_warehouse(l_ogg[i].ogg09,g_plant) RETURNING g_flag1 #FUN-D30024 add   #TQC-D40078 g_plant
              IF g_flag1 = 'N' OR g_flag1 IS NULL THEN                       #FUN-C80107 add     #FUN-D30024
                 CALL cl_err(l_ogg[i].ogg12,'axm-280',1)
                 NEXT FIELD ogg12
              ELSE
                 IF NOT cl_confirm('mfg3469') THEN
                    NEXT FIELD ogg12
                 END IF
              END IF
           END IF
        END IF
        INITIALIZE r_ogg.* TO NULL
        LET r_ogg.ogg01 = g_omf_1.omf00
        LET r_ogg.ogg03 = g_omf[l_ac].omf21
        LET r_ogg.ogg09 = l_ogg[i].ogg09
        LET r_ogg.ogg091 = l_ogg[i].ogg091
        LET r_ogg.ogg092 = l_ogg[i].ogg092
        LET r_ogg.ogg10 = l_ogg[i].ogg10
        LET r_ogg.ogg12 = l_ogg[i].ogg12
        LET r_ogg.ogg15 = l_ogg[i].ogg15
        LET r_ogg.ogg15_fac = l_ogg[i].ogg15_fac
        LET r_ogg.ogg16 = l_ogg[i].ogg16
        LET r_ogg.ogg20 = l_ogg[i].ogg20
        LET r_ogg.ogg17 = g_omf[l_ac].omf13
        LET r_ogg.ogg18 = l_ogg[i].ogg18
        LET r_ogg.oggplant = g_plant
        LET r_ogg.ogglegal = g_legal
        INSERT INTO ogg_file VALUES(r_ogg.*)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","ogg_file",'','',SQLCA.sqlcode,"","",0)   
             CANCEL INSERT
          ELSE 
             LET g_ogg18 = g_ogg18 + 1
             MESSAGE 'INSERT O.K'
             LET l_i = l_i + 1
             DISPLAY l_i TO FORMONLY.cn2
          END IF
      BEFORE DELETE                            
         IF NOT cl_null(l_ogg[i].ogg09) THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF
             
             DELETE FROM ogg_file 
              WHERE ogg01 = g_omf_1.omf00 AND ogg03 = g_omf[l_ac].omf21
                AND ogg09 = l_ogg_t.ogg09 AND ogg091 = l_ogg_t.ogg091 
                AND ogg092 = l_ogg_t.ogg092 AND ogg10 = l_ogg_t.ogg10
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","ogc_file",r_ogg.ogg01,r_ogg.ogg03,SQLCA.sqlcode,"","",0)  
               #ROLLBACK WORK
                CANCEL DELETE
             END IF 
             LET l_i = g_rec_b - 1
             DISPLAY l_i TO FORMONLY.cn2
          END IF
        # COMMIT WORK
          
      AFTER ROW
          LET l_ogg12_t1 = 0
        LET l_ogg16_t1 = 0
        LET l_ogg12_t2 = 0
        LET l_ogg16_t2 = 0
        FOR k = 1 TO l_ogg.getLength()
           IF l_ogg[k].ogg12 IS NOT NULL AND l_ogg[k].ogg12 <> 0 THEN
              IF l_ogg[k].ogg20 = '1' THEN
                 LET l_ogg12_t1 = l_ogg12_t1 + l_ogg[k].ogg12
                 LET l_ogg16_t1 = l_ogg16_t1 + l_ogg[k].ogg16
              END IF
              IF l_ogg[k].ogg20 = '2' THEN
                 LET l_ogg12_t2 = l_ogg12_t2 + l_ogg[k].ogg12
                 LET l_ogg16_t2 = l_ogg16_t2 + l_ogg[k].ogg16
              END IF
           END IF
        END FOR
        DISPLAY l_ogg12_t1 TO ogg12t_1
        DISPLAY l_ogg16_t1 TO ogg16t_1
        DISPLAY l_ogg12_t2 TO ogg12t_2
        DISPLAY l_ogg16_t2 TO ogg16t_2
      ON ROW CHANGE 
         IF INT_FLAG THEN                
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           EXIT INPUT
        END IF
        IF l_ogg[i].ogg12 IS NOT NULL AND l_ogg[i].ogg12 != 0 THEN
           IF l_ogg[i].ogg09 IS NULL THEN LET l_ogg[i].ogg09 = ' ' END IF
           IF l_ogg[i].ogg091 IS NULL THEN LET l_ogg[i].ogg091 = ' ' END IF
           IF l_ogg[i].ogg092 IS NULL THEN LET l_ogg[i].ogg092 = ' ' END IF
           IF l_ima906 = '1' THEN
              SELECT img10,img09,img21
                INTO l_ogg[i].img10,l_ogg[i].ogg15,l_img21
                FROM img_file
               WHERE img01 = g_omf[l_ac].omf13 AND img02 = l_ogg[i].ogg09
                 AND img03 = l_ogg[i].ogg091   AND img04 = l_ogg[i].ogg092
              IF STATUS THEN
                 CALL cl_err3("sel","img_file","","",SQLCA.sqlcode,"","sel img",1)  #No.FUN-670008
                 NEXT FIELD ogg09
              END IF
              CALL s_umfchk(g_omf[l_ac].omf13,l_ogg[i].ogg10,l_ogg[i].ogg15)
                            RETURNING g_cnt,l_ogg[i].ogg15_fac
              IF g_cnt=1 THEN 
                 CALL cl_err('','mfg3075',1) 
                #TQC-C50131 -- add -- begin
                 CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg3
                 LET l_msg3 = l_msg3 CLIPPED,"(",g_omf[l_ac].omf13,")"
                 CALL cl_msgany(10,20,l_msg3)
                #TQC-C50131 -- add -- end
                 NEXT FIELD ogg092 
              END IF
              IF cl_null(l_ogg[i].ogg15_fac) THEN LET l_ogg[i].ogg15_fac=1 END IF
           END IF
           IF l_ima906 = '2' THEN
              SELECT imgg10,imgg09,imgg21
                INTO l_ogg[i].img10,l_ogg[i].ogg15,l_img21
                FROM imgg_file
               WHERE imgg01 = g_omf[l_ac].omf13 AND imgg02 = l_ogg[i].ogg09
                 AND imgg03 = l_ogg[i].ogg091   AND imgg04 = l_ogg[i].ogg092
                 AND imgg09 = l_ogg[i].ogg10
              IF STATUS THEN
                 CALL cl_err3("sel","imgg_file","","",SQLCA.sqlcode,"","sel imgg",1)  #No.FUN-670008
                 NEXT FIELD ogg09
              END IF
              LET l_ogg[i].ogg15_fac = 1
           END IF
           IF l_ima906 = '3' THEN
              IF l_ogg[i].ogg20 = '1' THEN
                 SELECT img10,img09,img21
                   INTO l_ogg[i].img10,l_ogg[i].ogg15,l_img21
                   FROM img_file
                  WHERE img01 = g_omf[l_ac].omf13 AND img02 = l_ogg[i].ogg09
                    AND img03 = l_ogg[i].ogg091   AND img04 = l_ogg[i].ogg092
                 IF STATUS THEN
                    CALL cl_err3("sel","img_file","","",SQLCA.sqlcode,"","sel img",1)  #No.FUN-670008
                    NEXT FIELD ogg09
                 END IF
                 CALL s_umfchk(g_omf[l_ac].omf13,l_ogg[i].ogg10,l_ogg[i].ogg15)
                               RETURNING g_cnt,l_ogg[i].ogg15_fac
                 IF g_cnt=1 THEN 
                    CALL cl_err('','mfg3075',1) 
                   #TQC-C50131 -- add -- begin
                    CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg3
                    LET l_msg3 = l_msg3 CLIPPED,"(",g_omf[l_ac].omf13,")"
                    CALL cl_msgany(10,20,l_msg3)
                   #TQC-C50131 -- add -- end
                    NEXT FIELD ogg092 
                 END IF
                 IF cl_null(l_ogg[i].ogg15_fac) THEN LET l_ogg[i].ogg15_fac=1 END IF
              END IF
              IF l_ogg[i].ogg20 = '2' THEN
                 SELECT imgg10,imgg09,imgg21
                   INTO l_ogg[i].img10,l_ogg[i].ogg15,l_img21
                   FROM imgg_file
                  WHERE imgg01 = g_omf[l_ac].omf13 AND imgg02 = l_ogg[i].ogg09
                    AND imgg03 = l_ogg[i].ogg091   AND imgg04 = l_ogg[i].ogg092
                    AND imgg09 = l_ogg[i].ogg10
                 IF STATUS THEN
                    CALL cl_err3("sel","imgg_file","","",SQLCA.sqlcode,"","sel imgg",1) 
                    NEXT FIELD ogg09
                 END IF
                 LET l_ogg[i].ogg15_fac = 1
              END IF
           END IF

           LET l_ogg[i].ogg16 = l_ogg[i].ogg12 * l_ogg[i].ogg15_fac
           LET l_ogg[i].ogg16 = s_digqty(l_ogg[i].ogg16,l_ogg[i].ogg15)   
           UPDATE ogg_file SET ogg20 = l_ogg[i].ogg20,ogg091 = l_ogg[i].ogg091,
                               ogg092 = l_ogg[i].ogg092,ogg12 = l_ogg[i].ogg12,
                               ogg10 = l_ogg[i].ogg10,ogg15 = l_ogg[i].ogg15,
                               ogg15_fac = l_ogg[i].ogg15_fac,ogg16 = l_ogg[i].ogg16,
                               ogg18 = l_ogg[i].ogg18
            WHERE ogg01 = g_omf_1.omf00 AND ogg03 = g_omf[l_ac].omf21
                AND ogg09 = l_ogg_t.ogg09 AND ogg091 = l_ogg_t.ogg091 
                AND ogg092 = l_ogg_t.ogg092 AND ogg10 = l_ogg_t.ogg10
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","ogg_file",'','',SQLCA.sqlcode,"","",0)   
                LET l_ogg[i].* = l_ogg_t.*
             END IF
             MESSAGE 'UPDATE O.K'
          #  COMMIT WORK
            SELECT SUM(ogg12) INTO g_omf[l_ac].omf915
              FROM ogg_file
             WHERE ogg01 = g_omf_1.omf00
               AND ogg03 = g_omf[l_ac].omf21
               AND ogg20 = '2'
             SELECT SUM(ogg12) INTO g_omf[l_ac].omf912
               FROM ogg_file
              WHERE ogg01 = g_omf_1.omf00
                AND ogg03 = g_omf[l_ac].omf21
                AND ogg20 = '1'
            CALL t670_sum_omf917()
            LET g_omf[l_ac].omf16 = g_omf[l_ac].omf917 
        END IF
        IF g_sma.sma117 = 'N' THEN
           IF l_ogg[i].ogg16 > l_ogg[i].img10 THEN   #MOD-A70059
              LET g_flag1 = NULL    #FUN-C80107 add
             #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],l_ogg[i].ogg09) RETURNING g_flag1   #FUN-C80107 add
             #IF g_sma.sma894[2,2]='N' OR g_sma.sma894[2,2] IS NULL THEN      #FUN-C80107 mark
              CALL s_inv_shrt_by_warehouse(l_ogg[i].ogg09,g_plant) RETURNING g_flag1   #FUN-D30024 add    #TQC-D40078 g_plant
              IF g_flag1 = 'N' OR g_flag1 IS NULL THEN                         #FUN-C80107 add    #FUN-D30024 
                 CALL cl_err(l_ogg[i].ogg12,'axm-280',1)
                 NEXT FIELD ogg12
              ELSE
                 IF NOT cl_confirm('mfg3469') THEN
                    NEXT FIELD ogg12
                 END IF
              END IF
           END IF
        END IF
         
      ON ACTION controlp
          CASE
            WHEN INFIELD(ogg09)
            IF g_azw.azw04='2' THEN 
               CALL q_img42(FALSE,FALSE,g_omf[l_ac].omf13,'','','','A','1',g_plant)                                     
                  RETURNING l_ogg[i].ogg09,l_ogg[i].ogg091,l_ogg[i].ogg092
            ELSE
               LET g_ima906 = NULL
               SELECT ima906 INTO g_ima906 FROM ima_file
                WHERE ima01 = g_omf[l_ac].omf13
               IF s_industry("icd") THEN  
                  CALL q_idc(FALSE,FALSE,g_omf[l_ac].omf13,' ',' ',' ')
                  RETURNING  l_ogg[i].ogg09,l_ogg[i].ogg091,l_ogg[i].ogg092
               ELSE
                  CALL q_img4(FALSE,FALSE,g_omf[l_ac].omf13,' ',' ',' ','A')
                           RETURNING l_ogg[i].ogg09,l_ogg[i].ogg091,l_ogg[i].ogg092
               END IF 
            END IF  
               DISPLAY BY NAME l_ogg[i].ogg09,l_ogg[i].ogg091,l_ogg[i].ogg092       
                NEXT FIELD ogg09
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
      CALL cl_err('',9001,0)
      LET INT_FLAG = 0
      CLOSE WINDOW t6701_w
      RETURN
   END IF

   CLOSE WINDOW t6701_w

   LET g_success ='Y'

  #BEGIN WORK
   DELETE FROM ogc_file
    WHERE ogc01 = g_omf_1.omf00
      AND ogc03 = g_omf[l_ac].omf21
   CALL s_showmsg_init()      
   
   FOR i = 1 TO l_ogg.getLength()
     
       INITIALIZE r_ogc.* TO NULL
       LET r_ogc.ogc01 =g_omf_1.omf00
       LET r_ogc.ogc03 =g_omf[l_ac].omf21
       LET r_ogc.ogc09 =l_ogg[i].ogg09
       LET r_ogc.ogc091=l_ogg[i].ogg091
       LET r_ogc.ogc092=l_ogg[i].ogg092
       LET r_ogc.ogc18 =l_ogg[i].ogg18      
       SELECT img09 INTO l_img09 FROM img_file
        WHERE img01=g_omf[l_ac].omf13
          AND img02=r_ogc.ogc09
          AND img03=r_ogc.ogc091
          AND img04=r_ogc.ogc092
       LET r_ogc.ogc13 = li_ogg[i].ogg13  #FUN-C60036 add#出貨簽收沒有完成故mark
       IF l_ima906 = '1' THEN
          LET g_factor = 1
          LET r_ogc.ogc12=l_ogg[i].ogg12#*g_factor
          LET r_ogc.ogc12 = s_digqty(r_ogc.ogc12,g_omf[l_ac].omf17)   
          LET r_ogc.ogc15=l_img09
          LET r_ogc.ogc15_fac=l_ogg[i].ogg15_fac
          LET r_ogc.ogc16=r_ogc.ogc12*r_ogc.ogc15_fac
          LET r_ogc.ogc16 = s_digqty(r_ogc.ogc16,r_ogc.ogc15)   
          LET r_ogc.ogc17=g_omf[l_ac].omf13 
          IF cl_null(r_ogc.ogc01) THEN LET r_ogc.ogc01=' ' END IF
          IF cl_null(r_ogc.ogc03) THEN LET r_ogc.ogc03=0 END IF
          IF cl_null(r_ogc.ogc09) THEN LET r_ogc.ogc09=' ' END IF
          IF cl_null(r_ogc.ogc091) THEN LET r_ogc.ogc091=' ' END IF
          IF cl_null(r_ogc.ogc092) THEN LET r_ogc.ogc092=' ' END IF
          IF cl_null(r_ogc.ogc17) THEN LET r_ogc.ogc17=' ' END IF
          IF cl_null(r_ogc.ogc12) THEN LET r_ogc.ogc12=0 END IF
          IF cl_null(r_ogc.ogc15_fac) THEN LET r_ogc.ogc15_fac=0 END IF
          IF cl_null(r_ogc.ogc16) THEN LET r_ogc.ogc16=0 END IF
          LET r_ogc.ogc18 = l_ogg[i].ogg18   


          LET r_ogc.ogcplant = g_plant 
          LET r_ogc.ogclegal = g_legal  

          INSERT INTO ogc_file VALUES(r_ogc.*)
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('','',"INS ogc_file",SQLCA.sqlcode,1)                  
             LET g_success = 'N'
             CONTINUE FOR        
          END IF
       END IF
       IF l_ima906 = '2' THEN
          LET g_factor = 1
          CALL s_umfchk(g_omf[l_ac].omf13,l_ogg[i].ogg10,g_omf[l_ac].omf17)
                        RETURNING g_cnt,g_factor
          IF g_cnt=1 THEN LET g_factor = 1 END IF
          LET r_ogc.ogc12=l_ogg[i].ogg12*g_factor
          LET r_ogc.ogc12 = s_digqty(r_ogc.ogc12,g_omf[l_ac].omf17)   
          LET g_factor = 1
          CALL s_umfchk(g_omf[l_ac].omf13,l_ogg[i].ogg10,l_img09)
                        RETURNING g_cnt,g_factor
          IF g_cnt=1 THEN LET g_factor = 1 END IF
          LET r_ogc.ogc15=l_img09
          LET r_ogc.ogc15_fac = 1
          LET r_ogc.ogc16=l_ogg[i].ogg12*g_factor
          LET r_ogc.ogc16 = s_digqty(r_ogc.ogc16,r_ogc.ogc15)  
          LET r_ogc.ogc17=g_omf[l_ac].omf13 
          IF cl_null(r_ogc.ogc01) THEN LET r_ogc.ogc01=' ' END IF
          IF cl_null(r_ogc.ogc03) THEN LET r_ogc.ogc03=0 END IF
          IF cl_null(r_ogc.ogc09) THEN LET r_ogc.ogc09=' ' END IF
          IF cl_null(r_ogc.ogc091) THEN LET r_ogc.ogc091=' ' END IF
          IF cl_null(r_ogc.ogc092) THEN LET r_ogc.ogc092=' ' END IF
          IF cl_null(r_ogc.ogc17) THEN LET r_ogc.ogc17=' ' END IF
          IF cl_null(r_ogc.ogc12) THEN LET r_ogc.ogc12=0 END IF
          IF cl_null(r_ogc.ogc15_fac) THEN LET r_ogc.ogc15_fac=0 END IF
          IF cl_null(r_ogc.ogc16) THEN LET r_ogc.ogc16=0 END IF
          LET r_ogc.ogc18 = l_ogg[i].ogg18   
          LET r_ogc.ogcplant = g_plant 
          LET r_ogc.ogclegal = g_legal  

          INSERT INTO ogc_file VALUES(r_ogc.*)
          IF SQLCA.sqlcode THEN
             IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
                UPDATE ogc_file SET ogc12=ogc12+r_ogc.ogc12,
                                    ogc16=ogc16+r_ogc.ogc16
                 WHERE ogc01 =g_omf_1.omf00
                   AND ogc03 =g_omf[l_ac].omf21
                   AND ogc09 =l_ogg[i].ogg09
                   AND ogc091=l_ogg[i].ogg091
                   AND ogc092=l_ogg[i].ogg092
                IF SQLCA.sqlcode THEN
                   LET g_showmsg=g_omf_1.omf00,"/",g_omf[l_ac].omf21,"/",l_ogg[i].ogg09,"/",l_ogg[i].ogg091,"/",l_ogg[i].ogg092 
                   CALL s_errmsg("ogc01,ogc03,ogc09,ogc091,ogc092",g_showmsg,"UPD ogc_file",SQLCA.sqlcode,1)   
                   LET g_success = 'N'
                   CONTINUE FOR  #No.FUN-710046
                END IF
             ELSE
                CALL s_errmsg('','',"INS ogc:",SQLCA.sqlcode,1)  #No.FUN-710046
                LET g_success = 'N'
                CONTINUE FOR            #No.FUN-710046
             END IF
          END IF
       END IF
       IF l_ima906 = '3' THEN
          IF l_ogg[i].ogg20 = '1' THEN
             LET g_factor = 1
             LET r_ogc.ogc12=l_ogg[i].ogg12#*g_factor
             LET r_ogc.ogc12 = s_digqty(r_ogc.ogc12,g_omf[l_ac].omf17)   
             LET r_ogc.ogc15=l_img09
             LET r_ogc.ogc15_fac=l_ogg[i].ogg15_fac
             LET r_ogc.ogc16=r_ogc.ogc12*r_ogc.ogc15_fac
             LET r_ogc.ogc16 = s_digqty(r_ogc.ogc16,r_ogc.ogc15)     
             LET r_ogc.ogc17=g_omf[l_ac].omf13   #MOD-970149
             IF cl_null(r_ogc.ogc01) THEN LET r_ogc.ogc01=' ' END IF
             IF cl_null(r_ogc.ogc03) THEN LET r_ogc.ogc03=0 END IF
             IF cl_null(r_ogc.ogc09) THEN LET r_ogc.ogc09=' ' END IF
             IF cl_null(r_ogc.ogc091) THEN LET r_ogc.ogc091=' ' END IF
             IF cl_null(r_ogc.ogc092) THEN LET r_ogc.ogc092=' ' END IF
             IF cl_null(r_ogc.ogc17) THEN LET r_ogc.ogc17=' ' END IF
             IF cl_null(r_ogc.ogc12) THEN LET r_ogc.ogc12=0 END IF
             IF cl_null(r_ogc.ogc15_fac) THEN LET r_ogc.ogc15_fac=0 END IF
             IF cl_null(r_ogc.ogc16) THEN LET r_ogc.ogc16=0 END IF
             LET r_ogc.ogc18 = l_ogg[i].ogg18   

             LET r_ogc.ogcplant = g_plant 
             LET r_ogc.ogclegal = g_legal  

             INSERT INTO ogc_file VALUES(r_ogc.*)
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','',"INS ogc:",SQLCA.sqlcode,1)         
                LET g_success = 'N'
                CONTINUE FOR              
             END IF
          END IF
       END IF
    END FOR
     DELETE FROM ogg_file WHERE ogg01 = g_omf_1.omf00
       AND ogg21 = g_omf[l_ac].omf21 AND ogg12 = 0
     DELETE FROM ogc_file 
    WHERE  ogc01 = g_omf_1.omf01 
      AND ogc21 = g_omf[l_ac].omf21
      AND ogc12 = 0
     IF g_totsuccess="N" THEN
        LET g_success="N"
     END IF
     CALL s_showmsg()
    IF g_success='Y' THEN
      #COMMIT WORK
    ELSE
      #ROLLBACK WORK
    END IF
END FUNCTION 

FUNCTION t670_b_ogc() 
   DEFINE r_ogc   RECORD LIKE ogc_file.*
   DEFINE l_ogc   DYNAMIC ARRAY OF RECORD
                     ogc09     LIKE ogc_file.ogc09,
                     ogc091    LIKE ogc_file.ogc091,
                     ogc092    LIKE ogc_file.ogc092,
                     ogc12     LIKE ogc_file.ogc12,  
                     img10     LIKE img_file.img10, 
                     ogc15     LIKE ogc_file.ogc15,
                     ogc15_fac LIKE ogc_file.ogc15_fac,
                     ogc16     LIKE ogc_file.ogc16,
                     ogc18     LIKE ogc_file.ogc18   
                  END RECORD
   DEFINE l_ogc_t  RECORD
                     ogc09     LIKE ogc_file.ogc09,
                     ogc091    LIKE ogc_file.ogc091,
                     ogc092    LIKE ogc_file.ogc092,
                     ogc12     LIKE ogc_file.ogc12,  
                     img10     LIKE img_file.img10, 
                     ogc15     LIKE ogc_file.ogc15,
                     ogc15_fac LIKE ogc_file.ogc15_fac,
                     ogc16     LIKE ogc_file.ogc16,
                     ogc18     LIKE ogc_file.ogc18   
                  END RECORD
   DEFINE l_n          LIKE type_file.num5     
   DEFINE l_ogc12_t    LIKE ogc_file.ogc12
   DEFINE l_ogc16_t    LIKE ogc_file.ogc16
   DEFINE l_img21      LIKE img_file.img21
   DEFINE i,k,s,l_i    LIKE type_file.num5,   
          l_allow_insert   LIKE type_file.num5,                #可新增否 
          l_allow_delete   LIKE type_file.num5                 #可刪除否  
   DEFINE l_ogc18      LIKE ogc_file.ogc18  
   DEFINE l_bno        LIKE rvbs_file.rvbs08
   DEFINE g_ogc18      LIKE ogc_file.ogc18  
   DEFINE l_msg3       STRING              
   IF g_omf[l_ac].omf23 = 'N' OR cl_null(g_omf[l_ac].omf23) THEN RETURN END IF 
   LET p_row = 2 LET p_col = 2
    SELECT count(*) INTO i FROM ogc_file 
    WHERE ogc01 = g_omf_1.omf00 AND ogc03 = g_omf[l_ac].omf21
   IF i = 0 THEN CALL t670_ogg_ogc() END IF 

   #str----- mark by dengsy160606  
   {OPEN WINDOW t6702_w AT p_row,p_col WITH FORM "axm/42f/axmt670_2"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 

    CALL cl_ui_locale("axmt670_2")
   
   DECLARE t670_ogc_c CURSOR FOR
         SELECT ogc09,ogc091,ogc092,ogc12,'',ogc15,ogc15_fac,ogc16,ogc18 
             FROM ogc_file
            WHERE ogc01 = g_omf_1.omf00 AND ogc03 = g_omf[l_ac].omf21     
              

   CALL l_ogc.clear()
   LET i = 1
   LET l_i = 1
   FOREACH t670_ogc_c INTO l_ogc[i].*
      IF STATUS THEN
         CALL cl_err('foreach ogc',STATUS,0)
         EXIT FOREACH
      END IF
      SELECT img10 INTO l_ogc[i].img10 FROM img_file 
       WHERE img01=g_omf[l_ac].omf13
         AND img02=l_ogc[i].ogc09
         AND img03=l_ogc[i].ogc091
         AND img04=l_ogc[i].ogc092
      LET i = i + 1
   END FOREACH

   CALL l_ogc.deleteElement(i)
   LET l_i=(i-1)

   SELECT SUM(ogc12),SUM(ogc16) INTO l_ogc12_t,l_ogc16_t FROM ogc_file
    WHERE ogc01 = g_omf_1.omf00 AND ogc03 = g_omf[l_ac].omf21     

   DISPLAY l_i TO cn2
   DISPLAY l_ogc12_t TO ogc12t
   DISPLAY l_ogc16_t TO ogc16t
   DISPLAY g_omf[l_ac].omf16 TO ogb12t   

   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
   LET g_forupd_sql = " SELECT ogc09,ogc091,ogc092,ogc12,'',ogc15,ogc15_fac,ogc16,ogc18",
                      "   FROM ogc_file ",
                      "  WHERE ogc01 = ? AND ogc03 = ? ",
                      "    AND ogc09 = ? AND ogc091 = ? ",
                      "    AND ogc092 = ? AND ogc17 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t670_ogc_bcl CURSOR FROM g_forupd_sql
   LET i = 1
   CALL cl_set_comp_entry("ogc09,ogc091,ogc092",FALSE)
   INPUT ARRAY l_ogc WITHOUT DEFAULTS FROM s_ogc.*
         ATTRIBUTE(COUNT=l_i,MAXCOUNT=l_i,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF l_i != 0 THEN
            CALL fgl_set_arr_curr(i)
         END IF
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE
         LET g_ogc18 = 0
         SELECT MAX(ogc18)+1 INTO g_ogc18 
           FROM ogc_file
           WHERE ogc01 = g_omf_1.omf00 AND ogc03 = g_omf[l_ac].omf21 
         IF cl_null(g_ogc18) OR g_ogc18 = 0 THEN
            LET g_ogc18 = 1
         END IF
      
      BEFORE ROW
        LET p_cmd = ''
           LET i = ARR_CURR()
           LET l_lock_sw = 'N'           
           LET l_n  = ARR_COUNT()
          #BEGIN WORK
 
           IF l_i >= i THEN
              LET p_cmd='u'
              LET l_ogc_t.* = l_ogc[i].*     
              OPEN t670_ogc_bcl USING g_omf_1.omf00,g_omf[l_ac].omf21,l_ogc_t.ogc09,
                                     l_ogc_t.ogc091,l_ogc_t.ogc092,g_omf[l_ac].omf13
              IF STATUS THEN
                 CALL cl_err("OPEN t670_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t670_ogc_bcl INTO l_ogc[i].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('',SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT img10 INTO l_ogc[i].img10 FROM img_file
                  WHERE img01=g_omf[l_ac].omf13
                    AND img02=l_ogc[i].ogc09
                    AND img03=l_ogc[i].ogc091
                    AND img04=l_ogc[i].ogc092
              END IF   
           END IF     

      BEFORE INSERT    
        
        LET l_n = ARR_COUNT()
        LET p_cmd='a'
        INITIALIZE l_ogc[i].* TO NULL      
              
        IF cl_null(l_ogc[i].ogc18) OR l_ogc[i].ogc18 = 0 THEN
            LET l_ogc[i].ogc18 = g_ogc18
        END IF
        LET l_ogc[i].ogc09 = g_oaz.oaz95
        LET l_ogc[i].ogc091 = g_omf_1.omf05
        LET r_ogc.ogc15 = g_omf[l_ac].omf17

        LET l_ogc_t.* = l_ogc[i].*
        CALL cl_show_fld_cont()     
        NEXT FIELD ogc09

    
      AFTER INSERT
        
        IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
        END IF
        IF l_ogc[i].ogc12 IS NOT NULL AND l_ogc[i].ogc12 != 0 THEN
            IF l_ogc[i].ogc09 IS NULL THEN LET l_ogc[i].ogc09 = ' ' END IF
            IF l_ogc[i].ogc091 IS NULL THEN LET l_ogc[i].ogc091 = ' ' END IF
            IF l_ogc[i].ogc092 IS NULL THEN LET l_ogc[i].ogc092 = ' ' END IF
            SELECT img10,img09,img21 INTO l_ogc[i].img10,l_ogc[i].ogc15,l_img21
              FROM img_file
             WHERE img01 = g_omf[l_ac].omf13 AND img02 = l_ogc[i].ogc09     
               AND img03 = l_ogc[i].ogc091   AND img04 = l_ogc[i].ogc092
      
            IF NOT cl_null(l_ogc[i].ogc15) THEN           
               CALL s_umfchk(g_omf[l_ac].omf13,g_omf[l_ac].omf17,l_ogc[i].ogc15)     
                             RETURNING g_cnt,l_ogc[i].ogc15_fac
               IF g_cnt=1 THEN 
                  CALL cl_err('','mfg3075',1) 
                  CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg3
                  LET l_msg3 = l_msg3 CLIPPED,"(",g_omf[l_ac].omf13,")"
                  CALL cl_msgany(10,20,l_msg3)
                  NEXT FIELD ogc092 
               END IF
            END IF        
            IF cl_null(l_ogc[i].ogc15_fac) THEN LET l_ogc[i].ogc15_fac=1 END IF
            LET l_ogc[i].ogc16 = l_ogc[i].ogc12 * l_ogc[i].ogc15_fac
            LET l_ogc[i].ogc16 = s_digqty(l_ogc[i].ogc16,l_ogc[i].ogc15)   
         END IF
         INITIALIZE r_ogc.* TO NULL
         LET r_ogc.ogc01 = g_omf_1.omf00
         LET r_ogc.ogc03 = g_omf[l_ac].omf21
         LET r_ogc.ogc09 = l_ogc[i].ogc09    
         LET r_ogc.ogc091 = l_ogc[i].ogc091    
         LET r_ogc.ogc092 = l_ogc[i].ogc092  
         LET r_ogc.ogc12 = l_ogc[i].ogc12 
         IF cl_null(l_ogc[i].ogc15) THEN 
            LET r_ogc.ogc15 = g_omf[l_ac].omf17
         ELSE 
           LET r_ogc.ogc15 = l_ogc[i].ogc15    
         END IF  
         LET r_ogc.ogc15_fac = l_ogc[i].ogc15_fac 
         LET r_ogc.ogc16 = l_ogc[i].ogc16 
         LET r_ogc.ogc18 = l_ogc[i].ogc18 
         LET r_ogc.ogc17 = g_omf[l_ac].omf13
         LET r_ogc.ogcplant = g_plant
         LET r_ogc.ogclegal = g_legal 
         INSERT INTO ogc_file VALUES(r_ogc.*)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","ogc_file",'','',SQLCA.sqlcode,"","",0)   
             CANCEL INSERT
          ELSE 
             LET g_ogc18 = g_ogc18 + 1
             MESSAGE 'INSERT O.K'
             LET l_i = l_i + 1
             DISPLAY l_i TO FORMONLY.cn2
          END IF
         BEFORE DELETE                            #是否取消單身
          IF NOT cl_null(l_ogc[i].ogc09) THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF
             
             DELETE FROM ogc_file 
              WHERE ogc01 = g_omf_1.omf00 AND ogc03 = g_omf[l_ac].omf21
                AND ogc09 = l_ogc_t.ogc09 AND ogc091 = l_ogc_t.ogc091 
                AND ogc092 = l_ogc_t.ogc092 AND ogc17 = g_omf[l_ac].omf13
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","ogc_file",r_ogc.ogc01,r_ogc.ogc03,SQLCA.sqlcode,"","",0)  
               #ROLLBACK WORK
                CANCEL DELETE
             END IF 
             LET l_i = g_rec_b - 1
             DISPLAY l_i TO FORMONLY.cn2
          END IF
       #  COMMIT WORK
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET l_ogc[i].* = l_ogc_t.*
             CLOSE t670_ogc_bcl
          #  ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_ogc[i].ogc12 IS NOT NULL AND l_ogc[i].ogc12 != 0 THEN
            IF l_ogc[i].ogc09 IS NULL THEN LET l_ogc[i].ogc09 = ' ' END IF
            IF l_ogc[i].ogc091 IS NULL THEN LET l_ogc[i].ogc091 = ' ' END IF
            IF l_ogc[i].ogc092 IS NULL THEN LET l_ogc[i].ogc092 = ' ' END IF
            SELECT img10,img09,img21 INTO l_ogc[i].img10,l_ogc[i].ogc15,l_img21
              FROM img_file
             WHERE img01 = g_omf[l_ac].omf13 AND img02 = l_ogc[i].ogc09     
               AND img03 = l_ogc[i].ogc091   AND img04 = l_ogc[i].ogc092
      
            IF NOT cl_null(l_ogc[i].ogc15) THEN           
               CALL s_umfchk(g_omf[l_ac].omf13,g_omf[l_ac].omf17,l_ogc[i].ogc15)     
                             RETURNING g_cnt,l_ogc[i].ogc15_fac
               IF g_cnt=1 THEN 
                  CALL cl_err('','mfg3075',1) 
                  CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg3
                  LET l_msg3 = l_msg3 CLIPPED,"(",g_omf[l_ac].omf13,")"
                  CALL cl_msgany(10,20,l_msg3)
                  NEXT FIELD ogc092 
               END IF
            END IF        
            IF cl_null(l_ogc[i].ogc15_fac) THEN LET l_ogc[i].ogc15_fac=1 END IF
            LET l_ogc[i].ogc16 = l_ogc[i].ogc12 * l_ogc[i].ogc15_fac
            LET l_ogc[i].ogc16 = s_digqty(l_ogc[i].ogc16,l_ogc[i].ogc15)   
         END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err('',-263,1)
          ELSE
             UPDATE ogc_file
                SET ogc09 = l_ogc[i].ogc09,ogc091 = l_ogc[i].ogc091,
                    ogc092 = l_ogc[i].ogc092 ,ogc12 = l_ogc[i].ogc12,
                    ogc15 = l_ogc[i].ogc15,ogc15_fac = l_ogc[i].ogc15_fac,
                    ogc16 = l_ogc[i].ogc16 ,ogc18 = l_ogc[i].ogc18
             WHERE ogc01 = g_omf_1.omf00 AND ogc03 = g_omf[l_ac].omf21
                AND ogc09 = l_ogc_t.ogc09 AND ogc091 = l_ogc_t.ogc091 
                AND ogc092 = l_ogc_t.ogc092 AND ogc17 = g_omf[l_ac].omf13
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","ogc_file",'','',SQLCA.sqlcode,"","",0)   
                LET l_ogc[i].* = l_ogc_t.*
             END IF
             MESSAGE 'UPDATE O.K'
           # COMMIT WORK
             SELECT SUM(ogc12) INTO  g_omf[l_ac].omf16 FROM ogc_file 
              WHERE ogc01 = g_omf_1.omf00
                AND ogc03 = g_omf[l_ac].omf21
               LET g_omf[l_ac].omf917 = g_omf[l_ac].omf16
               LET g_sql = " SELECT gec05,gec07,gec04 FROM ",cl_get_target_table(g_plant_new,'gec_file'),
                           "  WHERE gec01='",g_omf_1.omf06,"' ",
                           "    AND gec011 = '2'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
               PREPARE sel_gec07_pre1_3 FROM g_sql
               EXECUTE sel_gec07_pre1_3 INTO g_gec05,g_gec07,g_omf_1.omf061
               IF g_gec07 = 'Y' THEN    #含稅
                  #未稅金額=(含稅單價*數量)/(1+稅率/100)
                  IF g_omf[l_ac].omf16 <> 0 THEN
                     LET g_omf[l_ac].omf29 = cl_digcut((g_omf[l_ac].omf28*g_omf[l_ac].omf16),t_azi04)/(1+g_omf_1.omf061/100)
                     LET g_omf[l_ac].omf29t = g_omf[l_ac].omf16 * g_omf[l_ac].omf28
                  END IF
               ELSE                     #不含稅
                  #未稅金額=未稅單價*數量
                  IF g_omf[l_ac].omf16 <> 0 THEN
                     LET g_omf[l_ac].omf29 = g_omf[l_ac].omf16 * g_omf[l_ac].omf28
                     LET g_omf[l_ac].omf29 = cl_digcut(g_omf[l_ac].omf29,t_azi04)
                     LET g_omf[l_ac].omf29t = g_omf[l_ac].omf29 * (1+g_omf_1.omf061/100)
                  END IF
               END IF

               LET g_omf[l_ac].omf29 = cl_digcut(g_omf[l_ac].omf29,t_azi04)
               LET g_omf[l_ac].omf29t = cl_digcut(g_omf[l_ac].omf29t,t_azi04) 
               LET g_omf[l_ac].omf29x = g_omf[l_ac].omf29t -g_omf[l_ac].omf29 #原幣稅額
               LET g_omf[l_ac].omf29x = cl_digcut(g_omf[l_ac].omf29x,t_azi04)
               LET g_omf[l_ac].omf19 = g_omf[l_ac].omf29 * g_omf_1.omf22
               LET g_omf[l_ac].omf19 = cl_digcut(g_omf[l_ac].omf19,g_azi04)     #本幣
               LET g_omf[l_ac].omf19t = g_omf[l_ac].omf29t * g_omf_1.omf22
               LET g_omf[l_ac].omf19t = cl_digcut(g_omf[l_ac].omf19t,g_azi04)   #本幣
               LET g_omf[l_ac].omf19x = g_omf[l_ac].omf19t - g_omf[l_ac].omf19
               LET g_omf[l_ac].omf19t = g_omf[l_ac].omf29t * g_omf_1.omf22
               LET g_omf[l_ac].omf19t = cl_digcut(g_omf[l_ac].omf19t,g_azi04)   #本幣
               LET g_omf[l_ac].omf19x = g_omf[l_ac].omf19t - g_omf[l_ac].omf19
               LET g_omf[l_ac].omf19x = cl_digcut(g_omf[l_ac].omf19x,g_azi04)   #本幣
          END IF
          
      AFTER ROW
         LET i = ARR_CURR() 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET l_ogc[i].* = l_ogc_t.*
            END IF
            CLOSE t670_ogc_bcl
         #  ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE t670_ogc_bcl
        #COMMIT WORK
         LET l_ogc12_t = 0
         LET l_ogc16_t = 0


         SELECT SUM(ogc12),SUM(ogc16) INTO l_ogc12_t,l_ogc16_t
          FROM ogc_file 
         WHERE ogc01 = r_ogc.ogc01 AND ogc03 = r_ogc.ogc03

         DISPLAY l_ogc12_t TO ogc12t
         DISPLAY l_ogc16_t TO ogc16t
      AFTER INPUT 
         IF l_ogc12_t != g_omf[l_ac].omf16 THEN     
            IF cl_confirm('axm-170') THEN
               LET g_omf[l_ac].omf16 = 0 
               SELECT SUM(ogc12) INTO g_omf[l_ac].omf16 FROM ogc_file
                WHERE ogc01 = g_omf_1.omf00 AND ogc03 = g_omf[l_ac].omf21
                                   
               DISPLAY BY NAME g_omf[l_ac].omf16
               UPDATE omf_file SET omf16 = g_omf[l_ac].omf16
                WHERE ogc01 = g_omf_1.omf00 AND ogc03 = g_omf[l_ac].omf21               
               EXIT INPUT
            ELSE
               NEXT FIELD ogc09
            END IF
         END IF
      AFTER FIELD ogc09
         IF NOT cl_null(l_ogc[i].ogc09) THEN
            SELECT COUNT(*) INTO l_n  FROM imd_file
             WHERE imd01=l_ogc[i].ogc09
              #AND imd11='Y'    #FUN-D10103 
               AND imdacti='Y'
            IF l_n=0 THEN
               CALL cl_err(l_ogc[i].ogc09,'axm-993',0)
               NEXT FIELD ogc09
            END IF
            
            IF NOT s_chk_ware(l_ogc[i].ogc09) THEN
               NEXT FIELD ogc09 
            END IF 
         END IF
      
      AFTER FIELD ogc12
         IF NOT cl_null(l_ogc[i].ogc12) THEN 
            CALL t670_chknumogc12(l_ogc[i].*)
            IF g_errno !='     ' OR NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD ogc12
            END IF 
         END IF 
         LET l_ogc[i].ogc12 = s_digqty(l_ogc[i].ogc12,g_omf[l_ac].omf17)  
         LET l_ogc[i].ogc16 = l_ogc[i].ogc12 * l_ogc[i].ogc15_fac
         LET l_ogc[i].ogc16 = s_digqty(l_ogc[i].ogc16,l_ogc[i].ogc15)    

            SELECT img09 INTO l_ogc[i].ogc15
                 FROM img_file
                WHERE img01 = g_omf[l_ac].omf13
                  AND img02 = l_ogc[i].ogc09
                  AND img03 = l_ogc[i].ogc091
                  AND img04 = l_ogc[i].ogc092
               
               LET l_ogc[i].ogc16 = s_digqty(l_ogc[i].ogc16,l_ogc[i].ogc15)   
               

               IF NOT cl_null(l_ogc[i].ogc15) THEN 
                  CALL s_umfchk(g_omf[l_ac].omf13,g_omf[l_ac].omf17,l_ogc[i].ogc15)
                      RETURNING g_cnt,l_ogc[i].ogc15_fac
                  IF g_cnt=1 THEN
                     CALL cl_err('','mfg3075',1)
                    
                     CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg3
                     LET l_msg3 = l_msg3 CLIPPED,"(",g_omf[l_ac].omf13,")"
                     CALL cl_msgany(10,20,l_msg3)

                     NEXT FIELD ogc092 
                  END IF
               END IF

               IF cl_null(l_ogc[i].ogc15_fac) THEN
                  LET l_ogc[i].ogc15_fac = 1
               END IF
      ON ACTION controlp
         CASE
            WHEN INFIELD(ogc09)
               IF g_azw.azw04='2' THEN
                  CALL q_img42(FALSE,FALSE,g_omf[l_ac].omf13,'','','','A','1',g_plant)                            
                        RETURNING l_ogc[i].ogc09,l_ogc[i].ogc091,l_ogc[i].ogc092
               ELSE
                  LET g_ima906 = NULL
                  SELECT ima906 INTO g_ima906 FROM ima_file
                   WHERE ima01 = g_omf[l_ac].omf13
                  IF s_industry("icd") THEN  
                     CALL q_idc(FALSE,FALSE,g_omf[l_ac].omf13,' ',' ',' ')
                     RETURNING  l_ogc[i].ogc09,l_ogc[i].ogc091,l_ogc[i].ogc092
                  ELSE
                     CALL q_img4(FALSE,FALSE,g_omf[l_ac].omf13,' ',' ',' ','A')    
                              RETURNING l_ogc[i].ogc09,l_ogc[i].ogc091,l_ogc[i].ogc092
                  END IF 
               END IF   
                  DISPLAY BY NAME l_ogc[i].ogc09,l_ogc[i].ogc091,l_ogc[i].ogc092        
                 NEXT FIELD ogc09
            WHEN INFIELD(ogc091)
                 CALL q_ime_1(FALSE,TRUE,l_ogc[i].ogc091,l_ogc[i].ogc09,"","","","","") RETURNING l_ogc[i].ogc091
                 DISPLAY BY NAME l_ogc[i].ogc091      
                 NEXT FIELD ogc091
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
      LET g_success='N' 
      CALL cl_err('',9001,0)
      LET INT_FLAG = 0
      CLOSE WINDOW t6702_w
      RETURN
   END IF

  CLOSE WINDOW t6702_w}
   #end----- mark by dengsy16060   #delete mark by dengsy160614
   DELETE FROM ogc_file 
    WHERE  ogc01 = g_omf_1.omf01 
      AND ogc21 = g_omf[l_ac].omf21
      AND ogc12 = 0
END FUNCTION 

FUNCTION t670_set_required()
 DEFINE p_cmd LIKE type_file.chr1
  IF g_sma.sma115 = 'Y' THEN 					
     SELECT ima906 INTO g_ima906 FROM ima_file WHERE ima01=g_omf[l_ac].omf13					
     IF g_ima906 = '3' THEN					
        CALL cl_set_comp_required("omf913,omf915,omf910,omf912",TRUE)
     ELSE
        CALL cl_set_comp_required("omf913,omf915,omf910,omf912",FALSE)
     END IF					
     #單位不同,轉換率,數量必KEY					
     IF NOT cl_null(g_omf[l_ac].omf910) THEN					
        CALL cl_set_comp_required("omf912",TRUE)
     END IF					
     IF NOT cl_null(g_omf[l_ac].omf913) AND g_ima906 MATCHES '[23]' THEN					
        CALL cl_set_comp_required("omf915",TRUE)					
     END IF					
  END IF   					
  IF g_sma.sma116 MATCHES '[23]' THEN   				
     IF NOT cl_null(g_omf[l_ac].omf916) THEN					
        CALL cl_set_comp_required("omf917",TRUE)					
     END IF					
   END IF					

END FUNCTION
FUNCTION t670_chk_omf913()
   IF cl_null(g_omf[l_ac].omf13) THEN RETURN "omf13" END IF
   IF g_omf[l_ac].omf23 = 'N' THEN
      IF cl_null(g_omf[l_ac].omf201) THEN LET g_omf[l_ac].omf201 = ' ' END IF
      IF cl_null(g_omf[l_ac].omf202) THEN LET g_omf[l_ac].omf202 = ' ' END IF
   END IF
   IF (g_omf_t.omf913 IS NULL AND g_omf[l_ac].omf913 IS NOT NULL) OR     
      (g_omf_t.omf913 IS NOT NULL AND g_omf[l_ac].omf913 IS NULL) OR     
      (g_omf_t.omf913 <> g_omf[l_ac].omf913) THEN                       
      LET g_change='Y'
   END IF
   IF NOT cl_null(g_omf[l_ac].omf913) THEN
      SELECT gfe02 INTO g_buf1 FROM gfe_file
       WHERE gfe01=g_omf[l_ac].omf913
         AND gfeacti='Y'
      IF STATUS THEN
         CALL cl_err3("sel","gfe_file",g_omf[l_ac].omf913,"",SQLCA.sqlcode,"","gfe:",1) 
         RETURN "omf913"
      END IF
      IF NOT cl_null(g_omf[l_ac].omf13) THEN
         SELECT ima31,ima906 INTO g_ima31,g_ima906 
           FROM ima_file
          WHERE ima01=g_omf[l_ac].omf13
      END IF
      CALL s_du_umfchk(g_omf[l_ac].omf13,'','','',
                       g_ima31,g_omf[l_ac].omf913,g_ima906)
           RETURNING g_errno,g_factor
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_omf[l_ac].omf913,g_errno,0)
         RETURN "omf913"
      END IF
      IF cl_null(g_omf_t.omf913) OR g_omf_t.omf913 <> g_omf[l_ac].omf913 THEN
         LET g_omf[l_ac].omf914 = g_factor
      END IF
      IF g_omf[l_ac].omf23='N' AND
         g_omf[l_ac].omf13 NOT MATCHES 'MISC*' THEN
         SELECT imgg10 INTO g_imgg10_2 FROM imgg_file
          WHERE imgg01=g_omf[l_ac].omf13
            AND imgg02=g_omf[l_ac].omf20
            AND imgg03=g_omf[l_ac].omf201
            AND imgg04=g_omf[l_ac].omf202
            AND imgg09=g_omf[l_ac].omf913
         IF cl_null(g_imgg10_2) THEN LET g_imgg10_2=0 END IF
      END IF
   END IF
   IF g_change='Y' THEN
      CALL t670_set_omf917()
   END IF
   CALL t670_set_required()
   CALL cl_show_fld_cont()     
   RETURN NULL
END FUNCTION

FUNCTION t670_set_omf917()
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima31  LIKE ima_file.ima31,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_tot    LIKE img_file.img10,     #計價數量
            l_factor LIKE ima_file.ima31_fac  

    SELECT ima25,ima31,ima906 INTO l_ima25,l_ima31,l_ima906
      FROM ima_file WHERE ima01=g_omf[l_ac].omf13
    IF SQLCA.sqlcode = 100 THEN
       IF g_omf[l_ac].omf13 MATCHES 'MISC*' THEN
          SELECT ima25,ima31,ima906 INTO l_ima25,l_ima31,l_ima906
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima31) THEN LET l_ima31=l_ima25 END IF

    LET l_fac2=g_omf[l_ac].omf914
    LET l_qty2=g_omf[l_ac].omf915
    IF g_sma.sma115 = 'Y' THEN
       LET l_fac1=g_omf[l_ac].omf911
       LET l_qty1=g_omf[l_ac].omf912
    ELSE
       LET l_fac1=1
       LET l_qty1=g_omf[l_ac].omf16
       CALL s_umfchk(g_omf[l_ac].omf13,g_omf[l_ac].omf17,l_ima31)
             RETURNING g_cnt,l_fac1
       IF g_cnt = 1 THEN
          LET l_fac1 = 1
       END IF
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
    ELSE  #不使用雙單位
       LET l_tot=l_qty1*l_fac1
    END IF
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
    LET l_factor = 1
    IF g_sma.sma115 = 'Y' THEN 
       CALL s_umfchk(g_omf[l_ac].omf13,g_omf[l_ac].omf17,g_omf[l_ac].omf916)
           RETURNING g_cnt,l_factor
    ELSE
       CALL s_umfchk(g_omf[l_ac].omf13,l_ima31,g_omf[l_ac].omf916)
           RETURNING g_cnt,l_factor
    END IF 
    IF g_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor

    LET g_omf[l_ac].omf917 = l_tot
    LET g_omf[l_ac].omf917 = s_digqty(g_omf[l_ac].omf917,g_omf[l_ac].omf916)   #No.FUN-BB0086

    IF g_omf[l_ac].omf17 = g_omf[l_ac].omf916 AND g_sma.sma115='N' THEN
      LET g_omf[l_ac].omf917 = g_omf[l_ac].omf16
    END IF

     
END FUNCTION

FUNCTION t670_bef_omf914()
   IF cl_null(g_omf[l_ac].omf13) THEN RETURN "ogb04" END IF
   #IF g_ogb[l_ac].ogb17 = 'N' THEN
   #   IF g_oga.oga09 MATCHES '[246]' THEN
   #      IF g_omf[l_ac].omf20 IS NULL OR g_omf[l_ac].omf201 IS NULL OR
   #         g_omf[l_ac].omf202 IS NULL THEN
   #        RETURN "ogb092"
   #      END IF
   #   END IF
   #END IF
   IF NOT cl_null(g_omf[l_ac].omf913) THEN
      IF g_omf[l_ac].omf23='N' AND
         g_omf[l_ac].omf13 NOT MATCHES 'MISC*' THEN
         #CALL s_chk_imgg(g_omf[l_ac].omf13,g_omf[l_ac].omf20,
         #                g_omf[l_ac].omf201,g_omf[l_ac].omf202,
         #                g_omf[l_ac].omf913) RETURNING g_flag
         #IF g_flag = 1 THEN
         #   IF g_oga.oga09 MATCHES '[246]' THEN
         #      CALL cl_err(g_omf[l_ac].omf913,'asm-301',0)
         #      RETURN "ogb092"
         #  END IF
         #END IF
         SELECT imgg10 INTO g_imgg10_2 FROM imgg_file
          WHERE imgg01=g_omf[l_ac].omf13
            AND imgg02=g_omf[l_ac].omf20
            AND imgg03=g_omf[l_ac].omf201
            AND imgg04=g_omf[l_ac].omf202
            AND imgg09=g_omf[l_ac].omf913
         IF cl_null(g_imgg10_2) THEN LET g_imgg10_2=0 END IF
      END IF
   END IF
   RETURN NULL
END FUNCTION

FUNCTION t670_chk_omf914()
   IF (g_omf_t.omf914 IS NULL AND g_omf[l_ac].omf914 IS NOT NULL) OR  
      (g_omf_t.omf914 IS NOT NULL AND g_omf[l_ac].omf914 IS NULL) OR  
      (g_omf_t.omf914 <> g_omf[l_ac].omf914) THEN                     
      LET g_change='Y'
   END IF
   IF NOT cl_null(g_omf[l_ac].omf914) THEN
      IF g_omf[l_ac].omf914=0 THEN
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t670_omf917_check()
   IF NOT cl_null(g_omf[l_ac].omf917) AND NOT cl_null(g_omf[l_ac].omf916) THEN
      IF cl_null(g_omf_t.omf917) OR cl_null(g_omf_t.omf916) OR g_omf_t.omf917 != g_omf[l_ac].omf917 OR g_omf_t.omf916 != g_omf[l_ac].omf916 THEN
         LET g_omf[l_ac].omf917=s_digqty(g_omf[l_ac].omf917,g_omf[l_ac].omf916)
         DISPLAY BY NAME g_omf[l_ac].omf917
      END IF
   END IF
   
   IF NOT cl_null(g_omf[l_ac].omf917) THEN
      IF g_omf[l_ac].omf917 < 0 THEN
         CALL cl_err('','aim-391',0)  #
         RETURN FALSE 
      END IF
   ELSE
      CALL cl_err('','mfg3291',0)  #
      RETURN FALSE 
   END IF
   #IF NOT cl_null(g_omf[l_ac].omf917) AND (g_omf[l_ac].omf917!=g_omf_t.omf917
   #                                       OR g_omf_t.omf917 IS NULL ) THEN
   #   CALL t670_omf14()
   #END IF
   RETURN TRUE
END FUNCTION 

FUNCTION t670_chk_omf916(p_cmd)        
 DEFINE p_cmd LIKE type_file.chr1     


   IF cl_null(g_omf[l_ac].omf13) THEN RETURN "omf13" END IF
   IF (g_omf_t.omf916 IS NULL AND g_omf[l_ac].omf916 IS NOT NULL) OR 
      (g_omf_t.omf916 IS NOT NULL AND g_omf[l_ac].omf916 IS NULL) OR 
      (g_omf_t.omf916 <> g_omf[l_ac].omf916) THEN                    
      LET g_change='Y'
   END IF
   IF NOT cl_null(g_omf[l_ac].omf916) THEN
      SELECT gfe02 INTO g_buf1 FROM gfe_file
       WHERE gfe01=g_omf[l_ac].omf916
         AND gfeacti='Y'
      IF STATUS THEN
         CALL cl_err3("sel","gfe_file",g_omf[l_ac].omf916,"",SQLCA.sqlcode,"","gfe:",1)  
         RETURN "omf916"
      END IF
      IF NOT cl_null(g_omf[l_ac].omf13) THEN
         SELECT ima25 INTO g_ima25 
           FROM ima_file
          WHERE ima01=g_omf[l_ac].omf13
      END IF
      CALL s_du_umfchk(g_omf[l_ac].omf13,'','','',
                       g_ima25,g_omf[l_ac].omf916,'1')
           RETURNING g_errno,g_factor
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_omf[l_ac].omf916,g_errno,0)
         RETURN "omf916"
      END IF
      IF NOT cl_null(g_omf[l_ac].omf13) THEN
         IF (g_omf_t.omf916 IS NULL OR g_omf_t.omf916 <> g_omf[l_ac].omf916) AND g_aza.aza50 ='Y' THEN   
            IF g_change='Y' THEN
               CALL t670_set_omf917()
            END IF
                                                                    
         END IF
      END IF
   END IF
   CALL t670_set_required()
   RETURN NULL
END FUNCTION

FUNCTION t670_bef_omf911()
   IF cl_null(g_omf[l_ac].omf13) THEN RETURN "omf13" END IF
   CALL cl_show_fld_cont()   
   RETURN NULL
END FUNCTION

FUNCTION t670_chk_omf911()
   IF (g_omf_t.omf911 IS NULL AND g_omf[l_ac].omf911 IS NOT NULL) OR 
      (g_omf_t.omf911 IS NOT NULL AND g_omf[l_ac].omf911 IS NULL) OR 
      (g_omf_t.omf911 <> g_omf[l_ac].omf911) THEN                    
      LET g_change='Y'
   END IF
   IF NOT cl_null(g_omf[l_ac].omf911) THEN
      IF g_omf[l_ac].omf911=0 THEN
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t670_chk_omf910()
   IF cl_null(g_omf[l_ac].omf13) THEN
      RETURN "omf13"
   END IF
   IF g_omf[l_ac].omf23 = 'N' THEN
      IF cl_null(g_omf[l_ac].omf201) THEN LET g_omf[l_ac].omf201 = ' ' END IF
      IF cl_null(g_omf[l_ac].omf202) THEN LET g_omf[l_ac].omf202 = ' ' END IF
   END IF
   IF (g_omf_t.omf910 IS NULL AND g_omf[l_ac].omf910 IS NOT NULL) OR  
      (g_omf_t.omf910 IS NOT NULL AND g_omf[l_ac].omf910 IS NULL) OR   
      (g_omf_t.omf910 <> g_omf[l_ac].omf910) THEN                      
      LET g_change='Y'
   END IF
   IF NOT cl_null(g_omf[l_ac].omf910) THEN
      SELECT gfe02 INTO g_buf1 FROM gfe_file
       WHERE gfe01=g_omf[l_ac].omf910
         AND gfeacti='Y'
      IF STATUS THEN
         CALL cl_err3("sel","gfe_file","g_omf[l_ac].omf910","",SQLCA.sqlcode,"","",1)  #No.FUN-670008
         RETURN "omf910"
      END IF
      IF NOT cl_null(g_omf[l_ac].omf13) THEN
         SELECT ima31 INTO g_ima31 
           FROM ima_file
          WHERE ima01=g_omf[l_ac].omf13
      END IF
      CALL t670_set_origin_field()
      CALL s_du_umfchk(g_omf[l_ac].omf13,'','','',
                       g_omf[l_ac].omf17,g_omf[l_ac].omf910,'1')
           RETURNING g_errno,g_factor
      CALL s_du_umfchk(g_omf[l_ac].omf13,'','','',
                       g_ima31,g_omf[l_ac].omf910,'1')
           RETURNING g_errno,g_factor
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_omf[l_ac].omf910,g_errno,0)
         RETURN "omf910"
      END IF
      IF cl_null(g_omf_t.omf910) OR g_omf_t.omf910 <> g_omf[l_ac].omf910 THEN
         LET g_omf[l_ac].omf911 = g_factor
      END IF
      IF g_omf[l_ac].omf23='N' AND
         g_omf[l_ac].omf13 NOT MATCHES 'MISC*' THEN
         SELECT ima906 INTO g_ima906 FROM ima_file
          WHERE ima01=g_omf[l_ac].omf13
         IF g_ima906 = '2' THEN   
            CALL s_chk_imgg(g_omf[l_ac].omf13,g_omf[l_ac].omf20,
                            g_omf[l_ac].omf201,g_omf[l_ac].omf202,
                            g_omf[l_ac].omf910) RETURNING g_flag
            #IF g_flag = 1 THEN
            #   IF g_oga.oga09 MATCHES '[246]' THEN
            #      CALL cl_err(g_omf[l_ac].omf910,'asm-301',0)
            #      RETURN "omf202"
            #   END IF
            #END IF
         END IF
         IF g_ima906 = '2' THEN
            SELECT imgg10 INTO g_imgg10_1 FROM imgg_file
             WHERE imgg01=g_omf[l_ac].omf13
               AND imgg02=g_omf[l_ac].omf20
               AND imgg03=g_omf[l_ac].omf201
               AND imgg04=g_omf[l_ac].omf202
               AND imgg09=g_omf[l_ac].omf910
         ELSE
            SELECT img10 INTO g_imgg10_1 FROM img_file
             WHERE img01=g_omf[l_ac].omf13
               AND img02=g_omf[l_ac].omf20
               AND img03=g_omf[l_ac].omf201
               AND img04=g_omf[l_ac].omf202
         END IF
         IF cl_null(g_imgg10_1) THEN LET g_imgg10_1=0 END IF
      END IF
   ELSE
      #IF g_oga.oga09 MATCHES '[15]' THEN
      #   #出貨單位欄位不可空白
      #   CALL cl_err(g_omf[l_ac].omf910,'mfg0037',1)
      #   RETURN "omf910"
      #END IF
   END IF

   IF g_change='Y' THEN                                                 
      CALL t670_set_omf917()                                             
   END IF

   CALL t670_set_required()
   RETURN NULL
END FUNCTION 

FUNCTION t670_bef_omf912()
   IF cl_null(g_omf[l_ac].omf13) THEN RETURN "omf13" END IF
   IF g_omf[l_ac].omf201 IS NULL THEN LET g_omf[l_ac].omf201=' ' END IF
   IF g_omf[l_ac].omf202 IS NULL THEN LET g_omf[l_ac].omf202=' ' END IF
   IF g_omf[l_ac].omf17 = 'N' THEN
      #IF g_oga.oga09 MATCHES '[246]' THEN
      #   IF g_omf[l_ac].omf20 IS NULL OR g_omf[l_ac].omf201 IS NULL OR
      #      g_omf[l_ac].omf202 IS NULL THEN
      #      RETURN "omf202"
      #   END IF
      #END IF
   END IF
   IF NOT cl_null(g_omf[l_ac].omf910) THEN
      IF g_omf[l_ac].omf17='N' AND g_ima906 = '2' AND
         g_omf[l_ac].omf13 NOT MATCHES 'MISC*' THEN
         CALL s_chk_imgg(g_omf[l_ac].omf13,g_omf[l_ac].omf20,
                         g_omf[l_ac].omf201,g_omf[l_ac].omf202,
                         g_omf[l_ac].omf910) RETURNING g_flag
         IF g_flag = 1 THEN
            #IF g_oga.oga09 MATCHES '[246]' THEN
            #   CALL cl_err(g_omf[l_ac].omf910,'asm-301',0)
            #   RETURN "omf202"
            #END IF
         END IF
      END IF
     IF g_ima906 = '2' THEN
        SELECT imgg10 INTO g_imgg10_1 FROM imgg_file
         WHERE imgg01=g_omf[l_ac].omf13
           AND imgg02=g_omf[l_ac].omf20
           AND imgg03=g_omf[l_ac].omf201
           AND imgg04=g_omf[l_ac].omf202
           AND imgg09=g_omf[l_ac].omf910
     ELSE
        SELECT img10 INTO g_imgg10_1 FROM img_file
         WHERE img01=g_omf[l_ac].omf13
           AND img02=g_omf[l_ac].omf20
           AND img03=g_omf[l_ac].omf201
           AND img04=g_omf[l_ac].omf202
     END IF
     IF cl_null(g_imgg10_1) THEN LET g_imgg10_1=0 END IF
   END IF
   RETURN NULL
END FUNCTION
#對原來數量/換算率/單位的賦值
FUNCTION t670_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_ima25  LIKE ima_file.ima25,
            l_ima31  LIKE ima_file.ima31,
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE omf_file.omf914,
            l_qty2   LIKE omf_file.omf915,
            l_fac1   LIKE omf_file.omf911,
            l_qty1   LIKE omf_file.omf912,
            l_factor LIKE ima_file.ima31_fac  

    IF g_sma.sma115='N' THEN RETURN END IF
    SELECT ima25,ima31 INTO l_ima25,l_ima31 FROM ima_file
     WHERE ima01=g_omf[l_ac].omf13     
    IF SQLCA.sqlcode = 100 THEN
       IF g_omf[l_ac].omf13 MATCHES 'MISC*' THEN           
          SELECT ima25,ima31 INTO l_ima25,l_ima31
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima31) THEN LET l_ima31=l_ima25 END IF

    LET l_fac2=g_omf[l_ac].omf914  
    LET l_qty2=g_omf[l_ac].omf915  
    LET l_fac1=g_omf[l_ac].omf911  
    LET l_qty1=g_omf[l_ac].omf912  

    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF

    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_omf[l_ac].omf16=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_omf[l_ac].omf16=l_tot
          WHEN '3'
                   LET g_omf[l_ac].omf16=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_omf[l_ac].omf914 = l_qty1 / l_qty2
                   ELSE
                      LET g_omf[l_ac].omf914 = 0
                   END IF
       END CASE
       LET g_omf[l_ac].omf16 = s_digqty(g_omf[l_ac].omf16,g_omf[l_ac].omf17) #FUN-BB0086 add
    END IF
    LET g_factor = 1
    CALL s_umfchk(g_omf[l_ac].omf13,g_omf[l_ac].omf17,l_ima25)
          RETURNING g_cnt,g_factor
    IF g_cnt = 1 THEN
       LET g_factor = 1
    END IF
    #LET b_omf.omf17_fac = g_factor

    IF g_sma.sma116 ='0' OR g_sma.sma116 ='1' THEN
       LET g_omf[l_ac].omf916 = g_omf[l_ac].omf17
       LET g_omf[l_ac].omf917 = g_omf[l_ac].omf16
    END IF


END FUNCTION
FUNCTION t670_chkomf913()
   IF cl_null(g_omf[l_ac].omf13) THEN RETURN "omf13" END IF
   IF g_omf[l_ac].omf23 = 'N' THEN
      IF cl_null(g_omf[l_ac].omf201) THEN LET g_omf[l_ac].omf201 = ' ' END IF
      IF cl_null(g_omf[l_ac].omf202) THEN LET g_omf[l_ac].omf202 = ' ' END IF
      
   END IF
   IF (g_omf_t.omf913 IS NULL AND g_omf[l_ac].omf913 IS NOT NULL) OR     
      (g_omf_t.omf913 IS NOT NULL AND g_omf[l_ac].omf913 IS NULL) OR     
      (g_omf_t.omf913 <> g_omf[l_ac].omf913) THEN                        
      LET g_change='Y'
   END IF
   IF NOT cl_null(g_omf[l_ac].omf913) THEN
      SELECT gfe02 INTO g_buf1 FROM gfe_file
       WHERE gfe01=g_omf[l_ac].omf913
         AND gfeacti='Y'
      IF STATUS THEN
         CALL cl_err3("sel","gfe_file",g_omf[l_ac].omf913,"",SQLCA.sqlcode,"","gfe:",1)  #No.FUN-670008
         RETURN "omf913"
      END IF
      IF NOT cl_null(g_omf[l_ac].omf13) THEN
         SELECT ima31,ima906 INTO g_ima31,g_ima906 
           FROM ima_file
          WHERE ima01=g_omf[l_ac].omf13
      END IF
      CALL s_du_umfchk(g_omf[l_ac].omf13,'','','',
                       g_ima31,g_omf[l_ac].omf913,g_ima906)
           RETURNING g_errno,g_factor
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_omf[l_ac].omf913,g_errno,0)
         RETURN "omf913"
      END IF
      IF cl_null(g_omf_t.omf913) OR g_omf_t.omf913 <> g_omf[l_ac].omf913 THEN
         LET g_omf[l_ac].omf914 = g_factor
      END IF
      IF g_omf[l_ac].omf23='N' AND
         g_omf[l_ac].omf13 NOT MATCHES 'MISC*' THEN
         SELECT imgg10 INTO g_imgg10_2 FROM imgg_file
          WHERE imgg01=g_omf[l_ac].omf13
            AND imgg02=g_omf[l_ac].omf20
            AND imgg03=g_omf[l_ac].omf201
            AND imgg04=g_omf[l_ac].omf202
            AND imgg09=g_omf[l_ac].omf913
         IF cl_null(g_imgg10_2) THEN LET g_imgg10_2=0 END IF
      END IF
   END IF
   IF g_change='Y' THEN
      CALL t670_set_omf917()
   END IF
   CALL t670_set_required()
   CALL cl_show_fld_cont()     
   RETURN NULL
END FUNCTION

FUNCTION t670_bef_omf915()
   IF cl_null(g_omf[l_ac].omf13) THEN RETURN "omf13" END IF
   IF g_omf[l_ac].omf201 IS NULL THEN LET g_omf[l_ac].omf201=' ' END IF
   IF g_omf[l_ac].omf202 IS NULL THEN LET g_omf[l_ac].omf202=' ' END IF
   IF NOT cl_null(g_omf[l_ac].omf913) THEN
      IF g_omf[l_ac].omf23='N' AND
         g_omf[l_ac].omf13 NOT MATCHES 'MISC*' THEN
         SELECT imgg10 INTO g_imgg10_2 FROM imgg_file
          WHERE imgg01=g_omf[l_ac].omf13
            AND imgg02=g_omf[l_ac].omf20
            AND imgg03=g_omf[l_ac].omf201
            AND imgg04=g_omf[l_ac].omf202
            AND imgg09=g_omf[l_ac].omf913
         IF cl_null(g_imgg10_2) THEN LET g_imgg10_2=0 END IF
      END IF
   END IF
   RETURN NULL
END FUNCTION

FUNCTION t670_chk_omf915(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1

   IF (g_omf_t.omf915 IS NULL AND g_omf[l_ac].omf915 IS NOT NULL) OR   
      (g_omf_t.omf915 IS NOT NULL AND g_omf[l_ac].omf915 IS NULL) OR   
      (g_omf_t.omf915 <> g_omf[l_ac].omf915) THEN                     
      LET g_change='Y'
   END IF
   IF NOT cl_null(g_omf[l_ac].omf915) THEN
      IF g_omf[l_ac].omf915 < 0 THEN
         CALL cl_err('','aim-391',0)  
         RETURN FALSE
      END IF
      IF p_cmd = 'a' THEN
         IF g_ima906='3' THEN
            LET g_tot=g_omf[l_ac].omf915*g_omf[l_ac].omf914
            IF cl_null(g_omf[l_ac].omf912) OR g_omf[l_ac].omf912=0 THEN 
               LET g_omf[l_ac].omf912=g_tot*g_omf[l_ac].omf911
               DISPLAY BY NAME g_omf[l_ac].omf912                       
            END IF                                                     
         END IF
      END IF
   END IF
   IF g_change='Y' THEN
      CALL t670_set_omf917()
   END IF
   CALL cl_show_fld_cont()     
   RETURN TRUE
END FUNCTION
FUNCTION t670_omf912_check()
   IF NOT cl_null(g_omf[l_ac].omf912) AND NOT cl_null(g_omf[l_ac].omf910) THEN
      IF cl_null(g_omf_t.omf912) OR cl_null(g_omf_t.omf910) OR g_omf_t.omf912 != g_omf[l_ac].omf912 OR g_omf_t.omf910 != g_omf[l_ac].omf910 THEN
         LET g_omf[l_ac].omf912=s_digqty(g_omf[l_ac].omf912,g_omf[l_ac].omf910)
         DISPLAY BY NAME g_omf[l_ac].omf912
      END IF
   END IF 
END FUNCTION 
FUNCTION t670_chk_num()
   DEFINE g_omf11  LIKE omf_file.omf11,
          g_omf12  LIKE omf_file.omf12, 
          g_omf03  LIKE omf_file.omf03
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_gec04  LIKE gec_file.gec04
   DEFINE l_gec05  LIKE gec_file.gec05
   DEFINE l_oga24  LIKE oga_file.oga24
   #FUN-C60036--add--str
   DEFINE l_omf915 LIKE omf_file.omf915,
          l_omf912 LIKE omf_file.omf912,
          l_omf917 LIKE omf_file.omf917
   DEFINE li_omf915 LIKE omf_file.omf915,
          li_omf912 LIKE omf_file.omf912,
          li_omf917 LIKE omf_file.omf917,
          l_return  STRING 
   #FUN-C60036--add--end
   
 
   LET g_errno = ''

   IF g_omf[l_ac].omf10 = '1' THEN
      LET g_sql = "SELECT ogb915,ogb912,ogb917 ", 
                   "  FROM ",cl_get_target_table(g_plant_new,'ogb_file'),",",
                             cl_get_target_table(g_plant_new,'oga_file'),",",
                             cl_get_target_table(g_plant_new,'gec_file'), 
                   " WHERE oga01 = ogb01 AND ogb01 = '",g_omf[l_ac].omf11,"' ",
                   "   AND ogb03 = '",g_omf[l_ac].omf12,"' ",
                   "   AND gec01 = oga21 "
     
   ELSE
 	   LET g_sql = "SELECT ohb915,ohb912,ohb917", 
                   "  FROM ",cl_get_target_table(g_plant_new,'ohb_file'),",",
                             cl_get_target_table(g_plant_new,'oha_file'),",",
                             cl_get_target_table(g_plant_new,'gec_file'), 
                   " WHERE oha01 = ohb01 AND ohb01 = '",g_omf[l_ac].omf11,"' ",
                   "   AND ohb03 = '",g_omf[l_ac].omf12,"' ",
                   "   AND gec01 = oha21 "
   END IF   
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql    	
	 CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql        
   PREPARE sel_ogb_pre_chk FROM g_sql
   EXECUTE sel_ogb_pre_chk INTO li_omf915,li_omf912,li_omf917
    LET l_omf915 = 0
    LET l_omf912 = 0 
    LET l_omf917 = 0
    
    SELECT SUM(omf915),SUM(omf912),SUM(omf917) INTO l_omf915,l_omf912,l_omf917
      FROM omf_file
     WHERE omf11 = g_omf[l_ac].omf11 AND omf12 = g_omf[l_ac].omf12
      #AND omf01 != g_omf_1.omf00 AND omf21 != g_omf_t.omf21  #TQC-D10102mark
       AND omf00 != g_omf_1.omf00 #TQC-D10102 add 
    IF cl_null(l_omf915) THEN LET l_omf915 = 0 END IF 
    IF cl_null(l_omf912) THEN LET l_omf912 = 0 END IF 
    IF cl_null(l_omf917) THEN LET l_omf917 = 0 END IF 
    LET l_return = ''
    IF  g_omf[l_ac].omf915 > li_omf915 - l_omf915 THEN 
       LET l_return = "omf915"
    ELSE
        IF  g_omf[l_ac].omf912 > li_omf912 - l_omf912 THEN 
           LET l_return = "omf912" 
        ELSE
           IF  g_omf[l_ac].omf917 > li_omf917 - l_omf917 THEN
              LET l_return =  "omf917" 
           END IF  
        END IF 
    END IF 
    RETURN l_return 
END FUNCTION 

FUNCTION t670sub_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg211,p_imgg10,p_type,p_no,l_omf03)
  DEFINE p_imgg00   LIKE imgg_file.imgg00,
         p_imgg01   LIKE imgg_file.imgg01,
         p_imgg02   LIKE imgg_file.imgg02,
         p_imgg03   LIKE imgg_file.imgg03,
         p_imgg04   LIKE imgg_file.imgg04,
         p_imgg09   LIKE imgg_file.imgg09,
         p_imgg211  LIKE imgg_file.imgg211,
         p_no       LIKE type_file.chr1,    
         l_ima25    LIKE ima_file.ima25,
         l_ima906   LIKE ima_file.ima906,
         l_imgg21   LIKE imgg_file.imgg21,
         p_imgg10   LIKE imgg_file.imgg10,
         p_type     LIKE type_file.num10      
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_omf03   LIKE omf_file.omf03
   DEFINE l_msg     STRING                 
 
    LET g_forupd_sql =
        "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
        "  WHERE imgg01= ?  AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
        "    AND imgg09= ? FOR UPDATE "   #FUN-560043
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE imgg_lock CURSOR FROM g_forupd_sql
    IF cl_null(p_imgg04) THEN LET p_imgg04 = ' '  END IF
    OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09   #FUN-560043
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
    SELECT ima25,ima906 INTO l_ima25,l_ima906 FROM ima_file WHERE ima01=p_imgg01
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
       CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"","ima25 null",1)  #No.FUN-670008
       LET g_success = 'N' RETURN
    END IF
 
    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
          RETURNING l_cnt,l_imgg21
    IF l_cnt = 1 AND NOT (l_ima906='3' AND p_no ='2') THEN
       CALL cl_err('','mfg3075',0)
      #MOD-C50020---S---
       CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg
       LET l_msg = l_msg CLIPPED,":",p_imgg01
       CALL cl_err(l_msg,'mfg3075',0)     #MOD-C50020 add l_msg
      #MOD-C50020---E---
       LET g_success = 'N' RETURN
    END IF
    IF cl_null(p_imgg04) THEN LET p_imgg04 = '' END IF
    CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,l_omf03, 
          '','','','','','','','','','',l_imgg21,'','','','','','','',p_imgg211)
    IF g_success='N' THEN RETURN END IF
 
END FUNCTION
FUNCTION t670_du(p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,p_unit1,p_fac1,p_qty1,p_flag,b_omf13,b_omf03) 
  DEFINE p_ware     LIKE img_file.img02
  DEFINE p_loc      LIKE img_file.img03
  DEFINE p_lot      LIKE img_file.img04
  DEFINE p_unit2    LIKE img_file.img09
  DEFINE p_fac2     LIKE img_file.img21
  DEFINE p_qty2     LIKE img_file.img10
  DEFINE p_unit1    LIKE img_file.img09
  DEFINE p_fac1     LIKE img_file.img21
  DEFINE p_qty1     LIKE img_file.img10
  DEFINE p_flag     LIKE type_file.chr1          
  DEFINE l_ima906   LIKE ima_file.ima906
  DEFINE b_omf13    LIKE omf_file.omf13
  DEFINE b_omf03    LIKE omf_file.omf03
 
    IF g_sma.sma115 = 'N' THEN RETURN END IF
    LET l_ima906 = NULL
    SELECT ima906 INTO l_ima906 FROM ima_file
     WHERE ima01=b_omf13
    IF l_ima906 IS NULL OR l_ima906 = '1' THEN RETURN END IF
    IF l_ima906 = '2' THEN
       IF cl_null(p_qty2) THEN LET p_qty2=0  END IF 
       IF NOT cl_null(p_unit2) AND p_qty2<>0 THEN   
          CALL t670_upd_imgg('1',p_ware,p_loc,p_lot,
                             p_unit2,p_qty2,p_fac2,'2',b_omf13,b_omf03) 
          IF g_success='N' THEN RETURN END IF
       END IF
       IF NOT cl_null(p_unit1) THEN
          CALL t670_upd_imgg('1',p_ware,p_loc,p_lot,
                             p_unit1,p_qty1,p_fac1,'1',b_omf13,b_omf03)
          IF g_success='N' THEN RETURN END IF
       END IF
    END IF
    IF l_ima906 = '3' THEN
       IF NOT cl_null(p_unit2) THEN
          CALL t670_upd_imgg('2',p_ware,p_loc,p_lot,
                             p_unit2,p_qty2,p_fac2,'2',b_omf13,b_omf03) 
          IF g_success='N' THEN RETURN END IF
       END IF
    END IF
END FUNCTION

FUNCTION t670_u_img(p_ware,p_loca,p_lot,p_qty,p_item,l_omf00,l_omf21)
  DEFINE p_ware  LIKE ogb_file.ogb09,       ##倉庫
         p_loca  LIKE ogb_file.ogb091,      ##儲位 
         p_lot   LIKE ogb_file.ogb092,      ##批號   
         p_qty   LIKE qcs_file.qcs06,   ##數量   
         p_item  LIKE ogb_file.ogb04,  
	 l_omf00 LIKE omf_file.omf00,
	 l_omf21 LIKE omf_file.omf21
  DEFINE l_img    RECORD
                  img10   LIKE img_file.img10,
                  img16   LIKE img_file.img16,
                  img23   LIKE img_file.img23,
                  img24   LIKE img_file.img24,
                  img09   LIKE img_file.img09,
                  img21   LIKE img_file.img21
                  END RECORD 
  DEFINE l_flag LIKE type_file.num5      
  
   
    IF s_joint_venture( p_item ,g_plant) OR NOT s_internal_item( p_item,g_plant ) THEN    
       RETURN
    END IF    
    CALL ui.Interface.refresh()
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty=0 END IF
 
    LET g_forupd_sql = "SELECT img10,img16,img23,img24,img09,img21 ",
                       " FROM img_file ",
                       "  WHERE img01 = ? AND img02= ? AND img03= ? ",
                       " AND img04= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img_lock1 CURSOR FROM g_forupd_sql
 
    OPEN img_lock1 USING p_item,p_ware,p_loca,p_lot        
    IF STATUS THEN
       CALL cl_err("OPEN img_lock:", STATUS, 1)
       CLOSE img_lock1
       LET g_success = 'N'  #No.MOD-8A)208 add
       RETURN
    END IF
 
    FETCH img_lock1 INTO l_img.*
    IF STATUS THEN
       CALL s_errmsg('','',"lock img fail",SQLCA.sqlcode,1)  
       LET g_success='N' RETURN
    END IF
    IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
    CALL s_upimg(p_item,p_ware,p_loca,p_lot,g_type,p_qty,g_today,   
          '','','','',l_omf00,l_omf21,'','','','','','','','',0,0,'','')  
    IF g_success='N' THEN
       CALL s_errmsg('','',"s_upimg()",SQLCA.sqlcode,1)  
       RETURN
    END IF
 
END FUNCTION
FUNCTION t670_upd_imgg(p_imgg00,p_imgg02,p_imgg03,p_imgg04,            
                       p_imgg09,p_imgg10,p_imgg211,p_no,l_omf13,l_omf03)
 DEFINE p_imgg00   LIKE imgg_file.imgg00,                                       
        p_imgg02   LIKE imgg_file.imgg02,                                       
        p_imgg03   LIKE imgg_file.imgg03,                                       
        p_imgg04   LIKE imgg_file.imgg04,                                       
        p_imgg09   LIKE imgg_file.imgg09,                                       
        p_imgg10   LIKE imgg_file.imgg10,                                       
        p_imgg211  LIKE imgg_file.imgg211,                                       
        p_no       LIKE type_file.chr1,     
        l_ima25    LIKE ima_file.ima25,                                         
        l_ima906   LIKE ima_file.ima906,                                         
        l_imgg21   LIKE imgg_file.imgg21,
	l_omf13    LIKE omf_file.omf13,
	l_omf03    LIKE omf_file.omf03

   CALL ui.Interface.refresh()                                                  
  IF cl_null(p_imgg04) THEN LET p_imgg04 = ' '  END IF 
                                                                                
   LET g_forupd_sql =                                                           
       "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",                                          
       "  WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
       "    AND imgg09= ? FOR UPDATE "                           
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE imgg_lock_1 CURSOR FROM g_forupd_sql                                   
                                                                                
   OPEN imgg_lock_1 USING l_omf13,p_imgg02,p_imgg03,p_imgg04,p_imgg09
   IF STATUS THEN                                                               
      CALL cl_err("OPEN imgg_lock:", STATUS, 1)                                 
      LET g_success='N'                                                         
      CLOSE imgg_lock                                                           
      RETURN                                                                    
   END IF                                                                       

   FETCH imgg_lock_1 INTO l_omf13,p_imgg02,p_imgg03,p_imgg04,p_imgg09
   IF STATUS THEN                                                               
      CALL cl_err('lock imgg fail',STATUS,1)                                    
      LET g_success='N'                                                         
      CLOSE imgg_lock                                                           
      RETURN                                                                    
   END IF                 
    SELECT ima25,ima906 INTO l_ima25,l_ima906
      FROM ima_file WHERE ima01=l_omf13
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN                                    
       CALL s_errmsg("ima01",l_omf13,"SEL ima_file",SQLCA.sqlcode,1)               
       LET g_success = 'N' RETURN                                               
    END IF                                                                      
                                                                                
    CALL s_umfchk(l_omf13,p_imgg09,l_ima25)
          RETURNING g_cnt,l_imgg21                                              
    IF g_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN                                                           
       CALL s_errmsg('','','',"mfg3075",1)   #No.FUN-710046                                 
       LET g_success = 'N' RETURN                                               
    END IF                                                                      
                                                                                
   CALL s_upimgg(l_omf13,p_imgg02,p_imgg03,p_imgg04,p_imgg09,+1,p_imgg10,l_omf03,                     
          '','','','','','','','','','',l_imgg21,'','','','','','','',p_imgg211)
   IF g_success = 'N' THEN                                                      
      CALL s_errmsg('','',"u_upimgg(+1)","9050",0)  
      RETURN                                
   END IF    
                                                                                
END FUNCTION

FUNCTION t670sub_tlff(p_flag,p_item,p_ware,p_loc,p_lot,p_unit,p_fac,p_qty,l_omf,p_type,p_omf03,p_tlff14) #TQC-C80042 add tlff14   
DEFINE
   p_flag     LIKE type_file.chr1,    
   p_item     LIKE ima_file.ima01,
   p_ware     LIKE img_file.img02,
   p_loc      LIKE img_file.img03,
   p_lot      LIKE img_file.img04,
   p_unit     LIKE img_file.img09,
   p_fac      LIKE img_file.img21,
   p_qty      LIKE img_file.img10,
  #p_type     LIKE type_file.chr1,   
   p_type     LIKE type_file.num5,
   p_omf03    LIKE omf_file.omf03,  ##发票日期
   p_lineno   LIKE ogb_file.ogb03,
   p_tlff14   LIKE tlff_file.tlff14,  #TQC-C80042 
   l_imgg10   LIKE imgg_file.imgg10,
   l_ima86    LIKE ima_file.ima86,  
   l_omf      RECORD LIKE omf_file.*

   INITIALIZE g_tlff.* TO NULL
   SELECT imgg10 INTO l_imgg10 FROM imgg_file
    WHERE imgg01=p_item  AND imgg02=p_ware
      AND imgg03=p_loc   AND imgg04=p_lot
      AND imgg09=p_unit
   IF cl_null(l_imgg10) THEN LET l_imgg10=0 END IF
   SELECT ima86 INTO l_ima86 FROM ima_file
                            WHERE ima01=p_item
   #----來源----
   LET g_tlff.tlff01=p_item              #異動料件編號
  #LET g_tlff.tlff02=50                  #'Stock'
   LET g_tlff.tlff020=l_omf.omf09
   LET g_tlff.tlff021=p_ware             #倉庫
   LET g_tlff.tlff022=p_loc              #儲位
   LET g_tlff.tlff023=p_lot              #批號
  #LET g_tlff.tlff024=l_imgg10           #異動後數量
   LET g_tlff.tlff024= ' '
   LET g_tlff.tlff025=p_unit             #庫存單位(ima_file or img_file)
   LET g_tlff.tlff026=l_omf.omf00        #出貨單號
   LET g_tlff.tlff027=l_omf.omf21       #出貨項次
   #---目的----
   IF p_type = '-1' THEN 
      LET g_tlff.tlff02=50                  #'Stock'
      LET g_tlff.tlff03=724
   ELSE 
      LET g_tlff.tlff02 = 734
      LET g_tlff.tlff03 = 50
   END IF
  #LET g_tlff.tlff030=l_omf.omf09
  #LET g_tlff.tlff031=p_ware                #倉庫
  #LET g_tlff.tlff032=p_loc                #儲位
  #LET g_tlff.tlff033=p_lot                #批號
   LET g_tlff.tlff030=' '
   LET g_tlff.tlff031=' '                #倉庫
   LET g_tlff.tlff032=' '                #儲位
   LET g_tlff.tlff033=' '                #批號

   LET g_tlff.tlff034=' '                #異動後庫存數量
   LET g_tlff.tlff035=' '                #庫存單位(ima_file or img_file)
   LET g_tlff.tlff036=l_omf.omf00        #訂單單號
   LET g_tlff.tlff037=l_omf.omf21  #訂單項次
 
   #-->異動數量
   LET g_tlff.tlff04= ' '             #工作站
   LET g_tlff.tlff05= ' '             #作業序號
  #LET g_tlff.tlff06=g_today      #發料日期
  #LET g_tlff.tlff06=p_omf03      ##发票日期
   LET g_tlff.tlff06= g_omf_1.omf24
   LET g_tlff.tlff07=g_today          #異動資料產生日期
   LET g_tlff.tlff08=TIME             #異動資料產生時:分:秒
   LET g_tlff.tlff09=g_user           #產生人
   LET g_tlff.tlff10=p_qty            #異動數量
   LET g_tlff.tlff11=p_unit           #發料單位
   LET g_tlff.tlff12=p_fac            #發料/庫存 換算率
   LET g_tlff.tlff13='axmt670'
   LET g_tlff.tlff14=' '              #異動原因
 
   LET g_tlff.tlff17=' '              #非庫存性料件編號
   CALL s_imaQOH(l_omf.omf13)
        RETURNING g_tlff.tlff18
   LET g_tlff.tlff19=l_omf.omf05
   LET g_tlff.tlff20 = ''
   LET g_tlff.tlff61= l_ima86 
   LET g_tlff.tlff62=l_omf.omf05   
   LET g_tlff.tlff63=l_omf.omf21    
   LET g_tlff.tlff64='' 
   LET g_tlff.tlff66=p_flag        
   LET g_tlff.tlff902=g_tlff.tlff021
   IF NOT cl_null(g_tlff.tlff902) THEN
      SELECT imd09 INTO g_tlff.tlff901
        FROM imd_file
       WHERE imd01=g_tlff.tlff902
         AND imdacti = 'Y'
      IF g_tlff.tlff901 IS NULL THEN LET g_tlff.tlff901=' ' END IF
   ELSE
      LET g_tlff.tlff901=' '
   END IF
   LET g_tlff.tlff903=g_tlff.tlff022
   LET g_tlff.tlff904=g_tlff.tlff023
   LET g_tlff.tlff905 = l_omf.omf00
   LET g_tlff.tlff906 = l_omf.omf21
   LET g_tlff.tlff907 = p_type
   LET g_tlff.tlff930=''
   LET g_tlff.tlff14 = p_tlff14  #TQC-C80042
   IF p_flag = "2" THEN   
      CALL s_tlff(p_flag,NULL)  
   ELSE   
      IF cl_null(l_omf.omf915) OR l_omf.omf915=0 THEN
         CALL s_tlff(p_flag,NULL)
      ELSE
         CALL s_tlff(p_flag,l_omf.omf913)
      END IF
   END IF   
END FUNCTION

FUNCTION t670_omf09()
   LET g_errno = ''

   SELECT * FROM azp_file,azw_file
    WHERE azp01 = azw01
      AND azp01 = g_omf[l_ac].omf09
      AND azw02 = g_legal

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'agl-171'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   LET g_plant_new = g_omf[l_ac].omf09
END FUNCTION


FUNCTION t670_oay_chk(p_omf00)
   DEFINE p_omf00   LIKE omf_file.omf00
   DEFINE l_oayacti LIKE oay_file.oayacti
   DEFINE l_oaytype LIKE oay_file.oaytype
   DEFINE l_oayslip LIKE oay_file.oayslip

   LET g_errno = ''
   SELECT oayslip,oayacti,oaytype INTO l_oayslip,l_oayacti,l_oaytype
     FROM oay_file
    WHERE oayslip = p_omf00

   CASE 
      WHEN SQLCA.sqlcode=100
         LET g_errno='aap-010'
      WHEN l_oayacti='N'
         LET g_errno='agl-530'
      WHEN l_oaytype <> '70'
         LET g_errno='aap-009'
      OTHERWISE
         LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
END FUNCTION 

FUNCTION t670_axrp310()
   DEFINE li_sql STRING
   DEFINE l_wc,l_str STRING  
   DEFINE l_n LIKE type_file.num10
   DEFINE l_oha09 LIKE oha_file.oha09
   DEFINE l_omf09 LIKE omf_file.omf09,
          l_omf10 LIKE omf_file.omf10,
          l_omf11 LIKE omf_file.omf11,
          l_omf19 LIKE omf_file.omf19
   DEFINE l_oay11 LIKE oay_file.oay11 #FUN-CA0084 add 20121031
   DEFINE l_yes   LIKE type_file.chr1 #MOD-D10265
   DEFINE l_yes2  LIKE type_file.chr1 #MOD-D40221
   
   IF s_shut(0) THEN
      RETURN
   END IF
   
  IF cl_null(g_omf_1.omf00) THEN    
      CALL cl_err('',-400,1)
      RETURN
   END IF
   CALL t670_fresh() #MOD-CC0230 add

   IF g_omf_1.omf08 !='Y' THEN 
      CALL cl_err('','aap-084',1)
      RETURN
   END IF 
  #IF NOT cl_null(g_omf[l_ac].omf04) THEN #FUN-D20003 mark
   IF NOT cl_null(g_omf_1.omf04) THEN #FUN-D20003 add
      CALL cl_err('','axm-610',1)
      RETURN
   END IF
   #FUN-CA0084--add--str--20121031
   IF NOT cl_null(g_omf_1.omf00) THEN
      LET g_sql= "SELECT oay11 FROM oay_file,omf_file ",
                 " WHERE omf00 like ltrim(rtrim(oayslip))||'-%' AND omf00 = '",g_omf_1.omf00,"'"
      PREPARE p330_oay11_prepare FROM g_sql
      EXECUTE p330_oay11_prepare INTO l_oay11
      IF l_oay11 != 'Y' THEN
         CALL cl_err(g_omf_1.omf00,'axr-372',1)
         RETURN
      END IF
   END IF
  #FUN-CA0084--add--end--20121031
   IF g_oaz.oaz100 != 'Y' OR g_auto_con = 2 THEN 
      LET l_n = 0 
      SELECT COUNT(*) INTO l_n FROM omf_file
       WHERE omf00 = g_omf_1.omf00 AND omfpost != 'Y' 
         AND omf11 IS NOT NULL
         AND omf13 NOT LIKE 'MISC%' #MOD-CA0062 add
      IF l_n > 0 AND g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' THEN 
         CALL cl_err('','axm-299',1)
         RETURN
      END IF 
      IF NOT cl_confirm('axr-179') THEN RETURN END IF
   END IF 
   LET l_wc = 'omf00 = "',g_omf_1.omf00,'"',
              ' AND omf01 = "',g_omf_1.omf01,'"'
              #,' AND omf02 = "',g_omf_1.omf02,'"'   #mark by dengsy160517
  #LET li_sql = " SELECT DISTINCT omf09,omf10,omf11 FROM omf_file ",
  #             "  WHERE omf00 = '",g_omf_1.omf00,"'",
  #             "    AND omf01 = '",g_omf_1.omf01,"'",
  #             "    AND omf02 = '",g_omf_1.omf02,"'"
  #PREPARE sel_omf09_10_11_pre FROM li_sql
  #DECLARE sel_omf09_10_11_cs CURSOR FOR sel_omf09_10_11_pre
  #FOREACH sel_omf09_10_11_cs INTO l_omf09,l_omf10,l_omf11
  #IF l_omf10 = '1' THEN
  #   LET l_str = " axrp310 '",l_omf11,"' ' ' ' ' ' ' ' ' ",
  #            " ' ' ' ' ' ' ' ' ' ' 'Y' ",
  #            " ' ' 'Y' ' ' ' ' '",l_wc,"'"
  #ELSE
  #   LET li_sql = "SELECT oha09 FROM ",cl_get_target_table(l_omf09,'oha_file'),
  #                " WHERE oha01 = '",l_omf11,"' "
  #   CALL cl_replace_sqldb(li_sql) RETURNING li_sql    	
  #   CALL cl_parse_qry_sql(li_sql,g_plant_new) RETURNING li_sql       
  #   PREPARE sel_oha09_pre FROM li_sql
  #   EXECUTE sel_oha09_pre INTO l_oha09
  #   LET l_str="axrp304 '",l_omf11,"' '",l_oha09,"' '",l_omf09,"' '' '' '' '' '' 'N' '' '",l_wc,"'"
  #END IF 
  # SELECT sum(omf19) INTO l_omf19 FROM omf_file   mark by quan 170713
   SELECT max(omf19) INTO l_omf19 FROM omf_file 
     WHERE omf00 = g_omf_1.omf00
       AND omf01 = g_omf_1.omf01
       AND omf02 = g_omf_1.omf02
   IF cl_null(l_omf19) THEN LET l_omf19 = 0 END IF
   IF l_omf19 >= 0 THEN #MOD-D60162 add =
      SELECT oaz98,oaz100 INTO g_oaz.oaz98,g_oaz.oaz100 FROM oaz_file
      IF g_oaz.oaz100 = 'Y' THEN 
        IF cl_null(g_oaz.oaz98) THEN LET g_oaz.oaz98 = ' ' END IF
      END IF
     #LET l_str = " axrp330 '1=1' '5' '",g_today,"' 'N' 'N' '",g_oaz.oaz98,"' 'Y' '' '",l_wc,"' 'axmt670'" #FUN-CA0084 mark 20121031
#FUN-D60075 -------- mark ----------------- begin -----------------
#MOD-D10265 add begin--------------------------------
#     #LET l_str = " axrp330 '1=1' '5' '",g_omf_1.omf03,"' 'N' 'N' '",g_oaz.oaz98,"' 'Y' '' '",l_wc,"' 'axmt670'"#FUN-CA0084 add 20121031
#     IF NOT cl_confirm('axr9999') THEN
#        LET l_yes = 'N'
#     ELSE 
#        LET l_yes = 'Y'
#     END IF
#     #MOD-D40221 add begin
#     IF NOT cl_confirm('axr9998') THEN
#        LET l_yes2 = 'N'
#     ELSE
#        LET l_yes2 = 'Y'
#     END IF
#     #MOD-D40221 add end        
#FUN-D60075 -------- mark ----------------- end -------------------
#FUN-D60075 -------- add ------------------ begin -----------------
     # LET l_yes = 'N' 
      LET l_yes = 'Y' #MOD-DB0161 add
      LET l_yes2 = 'Y'
#FUN-D60075 -------- add ------------------ end -------------------
      LET l_str = " axrp330 '1=1' '5' '",g_omf_1.omf03,"' '",l_yes,"' '",l_yes2,"' '",g_oaz.oaz98,"' 'Y' '' '",l_wc,"' 'axmt670'"#FUN-CA0084 add 20121031         
#MOD-D10265 add end--------------------------------      
   ELSE
      LET li_sql = "SELECT oha09 FROM ",cl_get_target_table(l_omf09,'oha_file'),
                   " WHERE oha01 = '",g_omf[l_ac].omf11,"' "
      CALL cl_replace_sqldb(li_sql) RETURNING li_sql
      CALL cl_parse_qry_sql(li_sql,g_plant_new) RETURNING li_sql
      PREPARE sel_oha09_pre FROM li_sql
      EXECUTE sel_oha09_pre INTO l_oha09
      LET l_str="axrp304 '",g_omf[l_ac].omf11,"' '",l_oha09,"' '",g_omf[l_ac].omf09,"' '' '",g_omf_1.omf03,"' '' '' '' 'N' '' '",l_wc,"' 'axmt670'"#FUN-CA0084 mod ''-->omf03
   END IF 
   CALL cl_cmdrun_wait(l_str)
  #END FOREACH
   CALL t670_b_fill('1=1')   
   CALL t670_show() #FUN-D20003 add
   
END FUNCTION
 
FUNCTION t670_gisp101()
   DEFINE l_wc,l_str STRING
   IF s_shut(0) THEN
      RETURN
   END IF

   IF cl_null(g_omf_1.omf00) THEN 
      CALL cl_err('',-400,1)
      RETURN
   END IF
   CALL t670_fresh() #MOD-CC0230 add

   IF g_omf_1.omf08 !='Y' THEN
      CALL cl_err('','aap-084',1)
      RETURN
   END IF
   IF NOT cl_confirm('axr-178') THEN RETURN END IF
   LET l_wc = 'omf00 = "',g_omf_1.omf00,'"',
              ' AND omf01 = "',g_omf_1.omf01,'"',
              ' AND omf02 = "',g_omf_1.omf02,'"'
   LET l_str = " gisp101 '",l_wc,"' 'Y' 'Y'"
   CALL cl_cmdrun_wait(l_str)
END FUNCTION

FUNCTION t670_sum_omf917()
   DEFINE l_omf911 LIKE omf_file.omf911,
          l_omf914 LIKE omf_file.omf914,
          l_flag   LIKE type_file.num5
   IF g_omf[l_ac].omf911 = g_omf_t.omf911 AND g_omf[l_ac].omf912 = g_omf_t.omf912
     AND g_omf[l_ac].omf914 = g_omf_t.omf914 AND g_omf[l_ac].omf915 = g_omf_t.omf915 THEN 
     RETURN
   END IF 
   IF cl_null(g_omf[l_ac].omf911) THEN LET g_omf[l_ac].omf911 = 0 END IF 
   IF cl_null(g_omf[l_ac].omf912) THEN LET g_omf[l_ac].omf912 = 0 END IF
   IF cl_null(g_omf[l_ac].omf914) THEN LET g_omf[l_ac].omf914 = 0 END IF
   IF cl_null(g_omf[l_ac].omf915) THEN LET g_omf[l_ac].omf915 = 0 END IF
   IF cl_null(g_omf[l_ac].omf910)  OR cl_null(g_omf[l_ac].omf916) THEN  #MOD-CC0257移除 OR cl_null(g_omf[l_ac].omf913) sunlm 参考单位可能为空
      RETURN
   END IF 
  #LET g_omf[l_ac].omf917 = g_omf[l_ac].omf911 * g_omf[l_ac].omf912 + g_omf[l_ac].omf914 * g_omf[l_ac].omf915
   CALL s_umfchk(g_omf[l_ac].omf13,g_omf[l_ac].omf910,g_omf[l_ac].omf916) RETURNING l_flag,l_omf911
   CALL s_umfchk(g_omf[l_ac].omf13,g_omf[l_ac].omf913,g_omf[l_ac].omf916) RETURNING l_flag,l_omf914
   IF cl_null(l_omf911) THEN LET l_omf911=0 END IF  #MOD-CC0257
   IF cl_null(l_omf914) THEN LET l_omf914=0 END IF  #MOD-CC0257
   LET g_omf[l_ac].omf917 = l_omf911 * g_omf[l_ac].omf912 + l_omf914 * g_omf[l_ac].omf915
   IF g_omf[l_ac].omf916 = g_omf[l_ac].omf17 THEN 
      LET g_omf[l_ac].omf16 = g_omf[l_ac].omf917 #MOD-D80176 add
   END IF    
   SELECT azi04 INTO t_azi04 FROM azi_file
    WHERE azi01 = g_omf_1.omf07
    LET g_sql = " SELECT gec05,gec07,gec04 FROM ",cl_get_target_table(g_plant_new,'gec_file'), #FUN-A50102      #MOD-A80052
                "  WHERE gec01='",g_omf_1.omf06,"' ",
                "    AND gec011 = '2'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE sel_gec07_pre4_1 FROM g_sql
   EXECUTE sel_gec07_pre4_1 INTO g_gec05,g_gec07,g_omf_1.omf061
   IF g_gec07 = 'Y' THEN    #含稅
     #未稅金額=(含稅單價*數量)/(1+稅率/100)
      IF g_omf[l_ac].omf917 <> 0 THEN     #FUN-C60036 mod 16--->917
         LET g_omf[l_ac].omf29 = cl_digcut((g_omf[l_ac].omf28*g_omf[l_ac].omf917),t_azi04)/(1+g_omf_1.omf061/100)    #FUN-C60036 mod 16--->9
         LET g_omf[l_ac].omf29t = g_omf[l_ac].omf917 * g_omf[l_ac].omf28#FUN-C60036 mod 16--->917
      END IF
   ELSE                     #不含稅
      #未稅金額=未稅單價*數量
      IF g_omf[l_ac].omf917 <> 0 THEN#FUN-C60036 mod 16--->917
         LET g_omf[l_ac].omf29 = g_omf[l_ac].omf917 * g_omf[l_ac].omf28#FUN-C60036 mod 16--->917
         LET g_omf[l_ac].omf29 = cl_digcut(g_omf[l_ac].omf29,t_azi04)
         LET g_omf[l_ac].omf29t = g_omf[l_ac].omf29 * (1+g_omf_1.omf061/100)
      END IF
   END IF
   LET g_omf[l_ac].omf29 = cl_digcut(g_omf[l_ac].omf29,t_azi04)
   LET g_omf[l_ac].omf29t = cl_digcut(g_omf[l_ac].omf29t,t_azi04)
   LET g_omf[l_ac].omf29x = g_omf[l_ac].omf29t- g_omf[l_ac].omf29
   LET g_omf[l_ac].omf29x = cl_digcut(g_omf[l_ac].omf29x,t_azi04)
   LET g_omf[l_ac].omf19 = g_omf[l_ac].omf29 * g_omf_1.omf22
   LET g_omf[l_ac].omf19 = cl_digcut(g_omf[l_ac].omf19,g_azi04)     #本幣
   LET g_omf[l_ac].omf19t = g_omf[l_ac].omf29t * g_omf_1.omf22
   LET g_omf[l_ac].omf19t = cl_digcut(g_omf[l_ac].omf19t,g_azi04)   #本幣
   LET g_omf[l_ac].omf19x = g_omf[l_ac].omf19t - g_omf[l_ac].omf19
   LET g_omf[l_ac].omf19x = cl_digcut(g_omf[l_ac].omf19x,g_azi04)   #本幣

END FUNCTION
#FUN-C60036--add--end

#FUN-C60036--minpp--str
FUNCTION t670_chk_omf05(p_cmd)
   DEFINE l_occ              RECORD LIKE occ_file.*
   DEFINE p_cmd           LIKE type_file.chr1
   DEFINE  l_buf             LIKE omf_file.omf051
   
   IF NOT cl_null(g_omf_1.omf05) THEN     
      IF g_aza.aza50 = 'Y' THEN  
         SELECT * INTO l_occ.* FROM occ_file
          WHERE occ01=g_omf_1.omf05    
             AND occ1004 ='1'     
             AND occ06 ='1'       
            AND occacti='Y'
         IF SQLCA.sqlcode=100 THEN
            CALL cl_err3("sel","occ_file",g_omf_1.omf05,"","anm-045","","select occ",1)  
            RETURN FALSE  
         ELSE
            IF g_azw.azw04='2' THEN
               IF l_occ.occ930=g_plant THEN
                  CALL cl_err('','art-444',0)
                  RETURN FALSE
               END IF
            END IF
            IF l_occ.occ1004!='1' THEN    
               CALL cl_err('select occ','atm-073',0)
               RETURN FALSE
            ELSE
               IF l_occ.occ06!='1' THEN
                  CALL cl_err('select occ','atm-072',0)
                  RETURN FALSE
               END IF
            END IF
         END IF
      ELSE
         SELECT * INTO l_occ.* FROM occ_file
          WHERE occ01=g_omf_1.omf05
             AND occ1004 ='1'
             AND occacti='Y'
         IF SQLCA.sqlcode=100 THEN
            CALL cl_err3("sel","occ_file",g_omf_1.omf05,"","anm-045","","select occ",1)
            RETURN FALSE 
         END IF
      END IF
    END IF
      SELECT occ02 INTO l_buf FROM occ_file
       WHERE occ01 = g_omf_1.omf05
         AND occacti = 'Y'
      IF STATUS THEN
          LET l_buf =''
      END IF
      LET g_omf_1.omf051=l_buf
      DISPLAY g_omf_1.omf051  TO omf051

           LET g_omf_1.omf07=l_occ.occ42
           LET g_omf_1.omf06=l_occ.occ41
           SELECT gec04 INTO g_omf_1.omf061
           FROM gec_file WHERE gec01 = g_omf_1.omf06 AND gec011='2'
           IF cl_null(g_omf_1.omf061) THEN
              LET g_omf_1.omf061=0
           END IF 
          CALL s_curr3(g_omf_1.omf07,g_omf_1.omf03,g_ooz.ooz17) RETURNING  g_omf_1.omf22
     DISPLAY BY NAME g_omf_1.omf07,g_omf_1.omf06,g_omf_1.omf061,g_omf_1.omf22
     RETURN TRUE
END FUNCTION


##FUN-C60036--minpp--end

#FUN-C60036--ad
FUNCTION t670_deloma(p_omf04)
   DEFINE l_chr,l_sure LIKE type_file.chr1,      
           l_n          LIKE type_file.num5,      
           l_cnt        LIKE type_file.num5       
   DEFINE  l_omb        RECORD LIKE omb_file.*,   
           tot          LIKE omb_file.omb18  
   DEFINE  l_flag       LIKE type_file.chr1       
   DEFINE  l_oob06      LIKE oob_file.oob06
   DEFINE  l_nmh17      LIKE nmh_file.nmh17
   DEFINE  l_nmh24      LIKE nmh_file.nmh24
   DEFINE  l_nmh33      LIKE nmh_file.nmh33
   DEFINE  l_omb38      LIKE omb_file.omb38         
   DEFINE  l_azw05      LIKE azw_file.azw05
   DEFINE  l_azw05_t    LIKE azw_file.azw05
   DEFINE  l_azw        DYNAMIC ARRAY OF RECORD
             azw05      LIKE azw_file.azw05,      
             azw01      LIKE azw_file.azw01     
                        END RECORD
   DEFINE  l_omb44      LIKE omb_file.omb44
   DEFINE  l_i          LIKE type_file.num5
   DEFINE  l_count      LIKE type_file.num5
   DEFINE  l_oaz92      LIKE oaz_file.oaz92, 
       m_oma01              LIKE oma_file.oma01,          
       m_oma05              LIKE oma_file.oma05,          
       m_omb31              LIKE omb_file.omb31  
   DEFINE  l_oma        RECORD LIKE oma_file.*
   DEFINE  l_ooy        RECORD LIKE ooy_file.*, 
           p_omf04      LIKE omf_file.omf04
    LET l_oma.oma01 = p_omf04
    SELECT * INTO l_oma.* FROM oma_file WHERE oma01 = l_oma.oma01
    IF l_oma.omaconf = 'Y' THEN 
       CALL cl_err('','axr-279',0)
       LET g_success = 'N'
       RETURN
    END IF
    IF l_oma.omavoid = 'Y' THEN
       CALL cl_err('','axr-103',0)
       LET g_success = 'N'
       RETURN
    END IF
    IF l_oma.oma64 matches '[Ss1]' THEN          
       CALL cl_err('','mfg3557',0)
       LET g_success = 'N'
       RETURN
    END IF
    IF l_oma.oma70 = '1'  THEN
          CALL cl_err('','alm-552',0)
       LET g_success = 'N'
       RETURN 
       END IF
    SELECT COUNT(*) INTO l_cnt FROM oot_file
     WHERE oot01 = l_oma.oma01
    IF l_cnt > 0 THEN
       CALL cl_err('','axr-009',0)
       LET g_success = 'N'
       RETURN
    END IF
   SELECT * INTO l_ooy.* FROM ooy_file WHERE ooyslip = l_oma.oma00
   IF g_aza.aza26 != '2' OR l_oma.oma00[1,1]!='2' OR l_ooy.ooydmy2!='Y' THEN
      IF l_oma.oma55 != 0 AND l_oma.oma00!='31' THEN 
         CALL cl_err('','axr-160',0)
         LET g_success = 'N'
         RETURN 
      END IF                
   END IF
   IF NOT cl_null(l_oma.oma33) THEN
      CALL cl_err(l_oma.oma01,'axr-310',0)
      LET g_success = 'N'
      RETURN
   END IF
   #BEGIN WORK
    LET g_success = 'Y'
    DECLARE oob_cs1 CURSOR FOR
      SELECT oob06 FROM oob_file
       WHERE oob01=l_oma.oma01 AND oob03='1' AND oob04='1' AND oob02>0
    FOREACH oob_cs1 INTO l_oob06
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       SELECT nmh17,nmh24,nmh33 INTO l_nmh17,l_nmh24,l_nmh33 FROM nmh_file
        WHERE nmh01=l_oob06
       IF l_nmh24<>'2' THEN
          CALL cl_err('','axr-045',1)
          LET g_success='N'
          EXIT FOREACH
       END IF
       IF l_nmh17 > 0 THEN
          CALL cl_err('','axr-077',1)
          LET g_success='N'
          EXIT FOREACH
       END IF
       IF NOT cl_null(l_nmh33) THEN
          CALL cl_err('','axr-047',1)
          LET g_success='N'
          EXIT FOREACH
       END IF
       DELETE FROM nmh_file WHERE nmh01=l_oob06
       IF STATUS OR SQLCA.SQLCODE THEN
          CALL cl_err3("del","nmh_file","","",SQLCA.sqlcode,"","",1)
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       DELETE FROM npp_file
        WHERE nppsys= 'NM' AND npp00=2 AND npp01 = l_oob06 AND npp011=1
       DELETE FROM npq_file
        WHERE npqsys= 'NM' AND npq00=2 AND npq01 = l_oob06 AND npq011=1
       DELETE FROM tic_file WHERE tic04 = l_oob06
    END FOREACH
    IF g_success = 'N' THEN RETURN END IF 
    DECLARE sel_oga_cs08 CURSOR FOR
     SELECT azw05,omb44 FROM omb_file,azw_file
      WHERE omb01 = l_oma.oma01
        AND omb44 = azw01
      ORDER BY azw05 
    LET g_cnt = 1
    LET l_azw05_t = ''
    FOREACH sel_oga_cs08 INTO l_azw05,l_omb44
       IF STATUS THEN EXIT FOREACH END IF     
       IF l_azw05_t = l_azw05 THEN
          CONTINUE FOREACH
       END IF
       LET l_azw[g_cnt].azw05 = l_azw05
       LET l_azw[g_cnt].azw01 = l_omb44   
       LET l_azw05_t = l_azw05
       LET g_cnt = g_cnt + 1
    END FOREACH
    LET l_count = g_cnt - 1
        INITIALIZE g_doc.* TO NULL          
        LET g_doc.column1 = "oma01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = l_oma.oma01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        IF l_oma.oma10 IS NOT NULL THEN
          SELECT COUNT(*) INTO g_cnt FROM oma_file
           WHERE oma10 = l_oma.oma10
             AND omavoid = 'N'        #MOD-B90053
          #FUN-C60033--add--str--
          SELECT oaz92 INTO l_oaz92 FROM oaz_file
          IF l_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN
          ELSE
           #FUN-C60033--add--end
             #FUN-C60036--mark--str--
             #IF g_cnt = 1 THEN  #一張發票對一張應收時才詢問是否殺
             #   IF NOT cl_confirm('axr-153') THEN RETURN END IF
             #   DELETE FROM ome_file WHERE ome01 = l_oma.oma10 AND (ome03 = l_oma.oma75 OR ome03 =' ')    #No.FUN-B90130     #No.MOD-A10050 add
             #   DELETE FROM omee_file WHERE omee01 = l_oma.oma10 AND (omee03 = l_oma.oma75 OR omee03 =' ')   #CHI-A70028 add #No.FUN-B90130           
             #END IF                                              #No.MOD-A10050 add
             #FUN-C60036--mark--end
            
             IF l_oma.oma00 = '12' OR                          #CHI-A50040
                l_oma.oma00 = '21' OR l_oma.oma00 = '19' OR l_oma.oma00 = '28' THEN  #MOD-B20038
                DECLARE omb_curs2 CURSOR FOR
                   SELECT * FROM omb_file WHERE omb01=l_oma.oma01
                      AND omf31 IS NOT NULL
                FOREACH omb_curs2 INTO l_omb.*
                   IF cl_null(l_omb.omb31) THEN CONTINUE FOREACH END IF 
                   IF STATUS THEN EXIT FOREACH END IF     #MOD-AC0233
                   LET g_plant_new = l_omb.omb44
                   SELECT SUM(omb14*oma162/100) INTO tot FROM omb_file, oma_file   #MOD-760035
                     WHERE omb31=l_omb.omb31 AND omb01=oma01
                       AND omb32=l_omb.omb32   #MOD-760035
                       AND omavoid='N'
                       AND oma00=l_oma.oma00
                       AND oma10 IS NOT NULL AND oma10 != ' '
                   IF cl_null(tot) THEN LET tot = 0 END IF
                   IF l_omb.omb38 != 3 THEN        #TQC-860003
                     LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
                                  "   SET oga54 = oga54 - '",tot,"'",
                                  " WHERE oga01 = '",l_omb.omb31,"'"
                      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102              
                      PREPARE upd_oga_pre01 FROM g_sql
                      EXECUTE upd_oga_pre01
                      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                         CALL cl_err3("upd","oga_file",l_omb.omb31,"",STATUS,"","upd oga54",1)  #No.FUN-660116  
                         LET g_success='N' 
                         EXIT FOREACH
                      END IF
                     LET g_sql = " UPDATE ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
                                  " SET ogb60 = 0 ",
                                  "  WHERE ogb01 = '",l_omb.omb31,"'",
                                  "    AND ogb03 = '",l_omb.omb32,"'"
                      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102              
                      PREPARE upd_ogb_pre02 FROM g_sql
                      EXECUTE upd_ogb_pre02
                      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                         CALL cl_err3("upd","ogg_file",l_omb.omb31,l_omb.omb32,STATUS,"","upd ogb60",1) 
                         LET g_success='N' 
                         EXIT FOREACH
                      END IF
                   ELSE
                      LET g_sql = " UPDATE ",cl_get_target_table(g_plant_new,'oha_file'), #FUN-A50102
                                  "    SET oha54 = oha54 - '",tot,"'",
                                  "  WHERE oha01 = '",l_omb.omb31,"'"
                      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102              
                      PREPARE upd_oha_pre03 FROM g_sql
                      EXECUTE upd_oha_pre03
                      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                         CALL cl_err3("upd","oha_file",l_omb.omb31,"",STATUS,"","upd oha54",1)  #No.FUN-660116  
                         LET g_success='N' 
                         EXIT FOREACH
                      END IF
                      LET g_sql = " UPDATE ",cl_get_target_table(g_plant_new,'ohb_file'), #FUN-A50102
                                  " SET ohb60 = 0 ",
                                  "  WHERE ohb01 = '",l_omb.omb31,"' ",
                                  "    AND ohb03 = '",l_omb.omb32,"'"
                      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102               
                      PREPARE upd_ohb_pre04 FROM g_sql
                      EXECUTE upd_ohb_pre04
                      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                         CALL cl_err3("upd","ohb_file",l_omb.omb31,l_omb.omb32,STATUS,"","upd ohb60",1) 
                         LET g_success='N' 
                         EXIT FOREACH
                      END IF
                   END IF
                END FOREACH
             END IF
          END IF  #FUN-C60033
        END IF
       
       IF l_oma.oma00='12' OR l_oma.oma00 = '19' THEN   #MOD-B20038
           LET g_cnt=0

           FOR l_i = 1 TO l_count
              LET g_plant_new = l_azw[l_i].azw01  #FUN-A50102
              LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
                          " WHERE oga10 = '",l_oma.oma01,"' AND oga00 !='2'"
              CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
              CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102             
              PREPARE sel_oga_pre06 FROM g_sql
              EXECUTE sel_oga_pre06 INTO l_cnt
              LET g_cnt = g_cnt + l_cnt
           END FOR
           IF g_cnt > 0 THEN
             #抓取單身的出貨單
              LET g_sql = "SELECT DISTINCT omb31,omb38,omb44 FROM oma_file,omb_file", #No.FUN-9C0014
                          " WHERE oma01 = omb01",
                          #"   AND oma00 = '12'",   #MOD-B20038
                          "   AND (oma00 = '12' OR oma00 = '19')",   #MOD-B20038
                          "   AND omf31 IS NOT NULL ",
                          "   AND omavoid != 'Y'",
                          "   AND omb01 = '",l_oma.oma01,"'",
                          " ORDER BY omb31"
              PREPARE t300_oga10_p1 FROM g_sql
              DECLARE t300_oga10_c1 CURSOR FOR t300_oga10_p1
              FOREACH t300_oga10_c1 INTO m_omb31,l_omb38,l_omb44 #MOD-9B0052 #No.FUN-9C0014 Add l_omb44
                 IF STATUS THEN EXIT FOREACH END IF     #MOD-AC0233
                 LET m_oma01 = ''  LET m_oma05 = ''
                 SELECT MAX(oma01) INTO m_oma01 FROM oma_file,omb_file
                  WHERE oma01 = omb01
                    #AND oma00 = '12'   #MOD-B20038
                    AND (oma00 = '12' OR oma00 = '19')   #MOD-B20038
                    AND omavoid != 'Y'
                    AND oma01 != l_oma.oma01
                    AND omb31 = m_omb31
                 IF cl_null(m_oma01) THEN
                    LET m_oma01=''   #MOD-8C0141 mod
                    LET m_oma05=l_oma.oma05            #MOD-9C0164
                 ELSE
                    SELECT oma05 INTO m_oma05 
                      FROM oma_file 
                     WHERE oma01=m_oma01
                       AND omavoid = 'N'        #MOD-B90053
                    IF cl_null(m_oma05) THEN LET m_oma05='' END IF   #MOD-8C0141 mod
                 END IF
                 LET g_plant_new = l_omb44
                 IF g_ooz.ooz65 = 'Y' AND l_omb38 = '3' THEN
                    LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'oha_file'), #FUN-A50102
                                " SET oha10 = NULL ",
                                " WHERE oha01 = '",m_omb31,"'"
                 ELSE
                    LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
                                "   SET oga10 = '",m_oma01,"',oga05 = '",m_oma05,"'",
                                " WHERE oga01 = '",m_omb31,"'"
                 END IF
                 CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                 CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
                 PREPARE sel_oga_pre07 FROM g_sql
                 EXECUTE sel_oga_pre07
                 IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                    CALL cl_err3("upd","oga_file",m_omb31,"",SQLCA.sqlcode,"","upd oga10:",1)  #No.FUN-660116
                    LET g_success = 'N'
                 END IF
              END FOREACH
           END IF
        END IF
 
        MESSAGE "Delete oma,omb,oao,npp,npq!"
        DELETE FROM oma_file WHERE oma01 = l_oma.oma01
        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN   
           CALL cl_err3("del","oma_file",l_oma.oma01,"",SQLCA.sqlcode,"","No oma deleted",1)  #No.FUN-660116  
           LET g_success = 'N'

      ELSE        
         LET g_sql = "SELECT UNIQUE omb44 FROM omb_file ",
                     " WHERE omb01 = '",l_oma.oma01,"'",
                     "   AND omf31 IS NOT NULL "
         PREPARE sel_omb44_pre FROM g_sql
         DECLARE sel_omb44_cur CURSOR FOR sel_omb44_pre
         FOREACH sel_omb44_cur INTO l_omb44
            IF STATUS THEN EXIT FOREACH END IF     #MOD-AC0233
            LET g_sql = "UPDATE ",cl_get_target_table(l_omb44,'oha_file'),
                        "   SET oha10 = NULL ",
                        " WHERE oha10 = '",l_oma.oma01,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_omb44) RETURNING g_sql
            PREPARE upd_oha FROM g_sql
            EXECUTE upd_oha
         
            IF STATUS THEN 
               CALL cl_err('',STATUS,0)
               LET g_success = 'N'
            END IF     
         END FOREACH   #FUN-A60056              
        END IF

        
        IF NOT cl_null(l_oma.oma62) THEN
           LET g_sql = "SELECT UNIQUE omb44 FROM omb_file ",
                        " WHERE omb01 = '",l_oma.oma01,"'"
            PREPARE sel_omb44_pre1 FROM g_sql
            DECLARE sel_omb44_cur1 CURSOR FOR sel_omb44_pre1
            FOREACH sel_omb44_cur1 INTO l_omb44
               IF STATUS THEN EXIT FOREACH END IF     #MOD-AC0233
               LET g_sql = "UPDATE ",cl_get_target_table(l_omb44,'rme_file'),
                           "   SET rme10 = NULL ",
                           " WHERE rme01 = '",l_oma.oma62,"'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,l_omb44) RETURNING g_sql
               PREPARE upd_rme FROM g_sql
               EXECUTE upd_rme
               IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                  CALL cl_err3("upd","rme_file",l_oma.oma62,"",SQLCA.sqlcode,"","upd rme10:",1)  
                  LET g_success = 'N'
               END IF
            END FOREACH   #FUN-A60056
        END IF

        DELETE FROM omb_file WHERE omb01 = l_oma.oma01
        IF STATUS THEN
           CALL cl_err3("del","omb_file",l_oma.oma01,"",STATUS,"","No omb deleted",1)  
           LET g_success = 'N'
        END IF
        DELETE FROM omc_file WHERE omc01 = l_oma.oma01
        IF STATUS THEN
           CALL cl_err3("del","omc_file",l_oma.oma01,"",STATUS,"","No omc deleted",1)
           LET g_success = 'N'
        END IF
        DELETE FROM oov_file WHERE oov01 = l_oma.oma01
        IF STATUS THEN
           CALL cl_err3("del","oov_file",l_oma.oma01,"",STATUS,"","No oov deleted",1)  #No.FUN-660116
           LET g_success = 'N'
        END IF
        IF l_oma.oma00='14' THEN
           UPDATE fbe_file SET fbe11=NULL WHERE fbe11=l_oma.oma01
        END IF
        IF l_oma.oma00='15' OR l_oma.oma00='17' THEN
           UPDATE lub_file SET lub14=NULL WHERE lub01=l_oma.oma16
              AND lub14=l_oma.oma01 
           IF STATUS THEN
              CALL cl_err("upd lub_file",STATUS,1)
              LET g_success = 'N'
           END IF
        END IF
        IF l_oma.oma00 MATCHES '1*' THEN
           DELETE FROM oot_file WHERE oot03 = l_oma.oma01
        ELSE
           DELETE FROM oot_file WHERE oot01 = l_oma.oma01
        END IF
        DELETE FROM npp_file WHERE npp01 = l_oma.oma01 AND nppsys = 'AR'
                               AND npp00 = 2 AND npp011 = 1
        DELETE FROM npq_file WHERE npq01 = l_oma.oma01 AND npqsys = 'AR'
                               AND npq00 = 2 AND npq011 = 1
        DELETE FROM tic_file WHERE tic04 = l_oma.oma01
        DELETE FROM oob_file WHERE oob01 = l_oma.oma01
        DELETE FROM ooa_file WHERE ooa01 = l_oma.oma01
        DELETE FROM oml_file WHERE oml01 = l_oma.oma01  #FUN-B40032 ADD
        DELETE FROM omk_file WHERE omk01 = l_oma.oma01  #FUN-B40032 ADD
        IF l_oma.oma16 IS NOT NULL THEN
           IF l_oma.oma01 <> l_oma.oma16 THEN
              DELETE FROM oao_file WHERE oao01 = l_oma.oma01
           END IF
        ELSE
           LET g_cnt=0
           SELECT COUNT(*) INTO g_cnt FROM omb_file
            WHERE omb31 = l_oma.oma01
           IF g_cnt = 0 THEN
              DELETE FROM oao_file WHERE oao01 = l_oma.oma01
           END IF
        END IF
        IF l_oma.oma00='21' OR l_oma.oma00 = '28' THEN
           LET g_cnt=0
           FOR l_i = 1 TO l_count
              LET g_plant_new = l_azw[l_i].azw01   #FUN-A50102
              LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'oha_file'), #FUN-A50102
                          " WHERE oha10 = '",l_oma.oma01,"' "          #No.MOD-B40084
              CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
              CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102            
              PREPARE sel_oga_pre12 FROM g_sql
              EXECUTE sel_oga_pre12 INTO l_cnt
              LET g_cnt = g_cnt + l_cnt
           END FOR
           IF g_cnt > 0 THEN
              FOR l_i = 1 TO l_count
                 LET g_plant_new = l_azw[l_i].azw01   #FUN-A50102
                 LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'oha_file'), 
                             "   SET oha10 = NULL ",
                             " WHERE oha10 = '",l_oma.oma01,"'"
                 CALL cl_replace_sqldb(g_sql) RETURNING g_sql              						
                 CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql                       
                 PREPARE upd_oha_pre13 FROM g_sql
                 EXECUTE upd_oha_pre13
                 IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                    CALL cl_err3("upd","oha_file",l_oma.oma01,"",SQLCA.sqlcode,"","upd oha10:",1)
                    LET g_success = 'N'
                 END IF
              END FOR
           END IF
        END IF
        LET g_cnt = 0 
        FOR l_i = 1 TO l_count
           LET g_plant_new = l_azw[l_i].azw01   #FUN-A50102
           LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'oha_file'), 
                       " WHERE oha10 = '",l_oma.oma01,"' ",
                       "   AND ohaconf = 'Y'",
                       "   AND ohapost = 'Y'",
                       "   AND oha09 = '3' "
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql              						
           CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql                        
           PREPARE sel_oga_pre14 FROM g_sql
           EXECUTE sel_oga_pre14 INTO l_cnt
           LET g_cnt = g_cnt + l_cnt
        END FOR
        IF g_cnt > 0 THEN 
           FOR l_i = 1 TO l_count
              LET g_plant_new = l_azw[l_i].azw01   #FUN-A50102
              LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'oha_file'), 
                          "   SET oha10 = NULL ",
                          " WHERE oha10 = '",l_oma.oma01,"'",
                          "   AND ohaconf = 'Y'",
                          "   AND ohapost = 'Y'",
                          "   AND oha09 = '3' "
              CALL cl_replace_sqldb(g_sql) RETURNING g_sql             						
              CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql                                 
              PREPARE upd_oha_pre14 FROM g_sql
              EXECUTE upd_oha_pre14
              IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                 CALL cl_err3("upd","oha_file",l_oma.oma01,"",SQLCA.sqlcode,"","upd oha10:",1)
                 LET g_success = 'N'
              END IF
           END FOR
        END IF
        LET g_msg=TIME
        INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)     
           VALUES ('axmt670',g_user,g_today,g_msg,l_oma.oma01,'delete',g_plant,g_legal) 
        SELECT oaz92 INTO g_oaz.oaz92 FROM oaz_file
        IF g_oaz.oaz92 = 'Y' AND g_aza.aza26 ='2' THEN
           UPDATE omf_file SET omf04 = '' WHERE omf04 = l_oma.oma01
        END IF
        INITIALIZE l_oma.* TO NULL
        MESSAGE ""
 
END FUNCTION
FUNCTION t670_chknumogc12(p_ogc)
   DEFINE p_ogc   RECORD
                     ogc09     LIKE ogc_file.ogc09,
                     ogc091    LIKE ogc_file.ogc091,
                     ogc092    LIKE ogc_file.ogc092,
                     ogc12     LIKE ogc_file.ogc12,
                     img10     LIKE img_file.img10,
                     ogc15     LIKE ogc_file.ogc15,
                     ogc15_fac LIKE ogc_file.ogc15_fac,
                     ogc16     LIKE ogc_file.ogc16,
                     ogc18     LIKE ogc_file.ogc18
                  END RECORD
   DEFINE li_sql STRING
   DEFINE l_ogc12 LIKE ogc_file.ogc12,
          li_ogc12 LIKE ogc_file.ogc12

   LET g_errno=''
   LET li_sql = " SELECT SUM(ogc12) FROM ogc_file ",
                "  WHERE ogc01 = '",g_omf[l_ac].omf11,"'",
                "    AND ogc03 = '",g_omf[l_ac].omf12,"'",
                "    AND ogc092 = '",p_ogc.ogc092,"'"
   PREPARE t670_chknumogc12_pre FROM li_sql
   EXECUTE t670_chknumogc12_pre INTO l_ogc12
   LET li_sql = " SELECT SUM(ogc12) FROM ogc_file ",
               #"  WHERE ogc01 IN ( SELECT ogc01 FROM ogc_file, ",cl_get_target_table(g_omf[l_ac].omf09,'oay_file'),#MOD-CA0062 mark
                "  WHERE (ogc01,ogc03) IN ( SELECT ogc01,ogc03 FROM ogc_file, ",cl_get_target_table(g_omf[l_ac].omf09,'oay_file'),#MOD-CA0062 
                "                    WHERE ogc09 = '",p_ogc.ogc09,"'",
                "   AND ogc01 like ltrim(rtrim(oayslip))||'-%'  AND oaytype = '70' ",
                "                      AND ogc091 = '",p_ogc.ogc091,"'",
                "                      AND ogc092 = '",p_ogc.ogc092,"'",
                "                      AND ogc17 = '",g_omf[l_ac].omf13,"'",
              # "                      AND ogc01 != '",g_omf_1.omf00,"') ",#MOD-CA0062 mark
               #TQC-D10102--add--str
                "                      AND (ogc01,ogc03) IN ( SELECT omf00,omf21 FROM omf_file ",
                "                                              WHERE omf11 = '",g_omf[l_ac].omf11,"'",
                "                                                AND omf12 = '",g_omf[l_ac].omf12,"')",
               #TQC-D10102--add--end
                "                      AND (ogc01 != '",g_omf_1.omf00,"' OR (ogc01 = '",g_omf_1.omf00,"' AND ogc03 <> '",g_omf[l_ac].omf21,"'))) ",#MOD-CA0062
                "   AND ogc09 = '",p_ogc.ogc09,"'",
                "   AND ogc17 = '",g_omf[l_ac].omf13,"'",
                "   AND ogc091 = '",p_ogc.ogc091,"'",
                "    AND ogc092 = '",p_ogc.ogc092,"'"
   CALL cl_replace_sqldb(li_sql) RETURNING li_sql           
   CALL cl_parse_qry_sql(li_sql,g_omf[l_ac].omf09) RETURNING li_sql
   PREPARE t670_chknumogc12_pre_2 FROM li_sql
   EXECUTE t670_chknumogc12_pre_2 INTO li_ogc12
   IF cl_null(li_ogc12) THEN LET li_ogc12 = 0 END IF
   IF (p_ogc.ogc12 > l_ogc12 - li_ogc12) THEN 
      LET g_errno = 'axr-163'
   END IF 
END FUNCTION
FUNCTION t670_chknumogg12(p_ogg)
   DEFINE p_ogg           RECORD
          ogg20            LIKE ogg_file.ogg20,
          ogg09            LIKE ogg_file.ogg09,
          ogg091           LIKE ogg_file.ogg091,
          ogg092           LIKE ogg_file.ogg092,
          ogg12            LIKE ogg_file.ogg12,
          ogg10            LIKE ogg_file.ogg10,
          img10            LIKE img_file.img10,
          ogg15            LIKE ogg_file.ogg15,
          ogg15_fac        LIKE ogg_file.ogg15_fac,
          ogg16            LIKE ogg_file.ogg16,
          ogg18            LIKE ogg_file.ogg18
                           END RECORD
   DEFINE li_sql STRING
   DEFINE l_ogg12 LIKE ogg_file.ogg12,
          li_ogg12 LIKE ogg_file.ogg12

   LET g_errno=''
   LET li_sql = " SELECT SUM(ogg12) ",
                   "   FROM ogg_file",
                   "  WHERE ogg01 = '",g_omf[l_ac].omf11,"'",
                   "    AND ogg03 = '",g_omf[l_ac].omf12,"'",
                   "    AND ogg20 = '",p_ogg.ogg20,"'",
                   "    AND ogg092 = '",p_ogg.ogg092,"'",
                   "    AND ogg20 = '",p_ogg.ogg20,"'"
                   
   PREPARE t670_chknumogg12_pre_3 FROM li_sql
   EXECUTE t670_chknumogg12_pre_3 INTO l_ogg12
   LET li_sql = " SELECT SUM(ogg12) FROM ogg_file",
                "                       ,omf_file",   #addTQC-D10102 
               #"  WHERE ogg01 IN (SELECT ogg01 FROM ogg_file,",cl_get_target_table(g_omf[l_ac].omf09,'oay_file'),#TQC-D10102 mark
                "  WHERE (ogg01,ogg03) IN (SELECT ogg01,ogg03 FROM ogg_file,",cl_get_target_table(g_omf[l_ac].omf09,'oay_file'),#TQC-D10102 add
                "                   WHERE ogg01 != '",g_omf_1.omf00,"'",
                "                     AND ogg09 = '",p_ogg.ogg09,"'",
                "                     AND ogg17 = '",g_omf[l_ac].omf13,"'",
                "                     AND ogg20 = '",p_ogg.ogg20,"'",
                "                     AND ogg091 = '",p_ogg.ogg091,"'",
               #TQC-D10102--add--str
                "                     AND (ogg01,ogg03) IN ( SELECT omf00,omf21 FROM omf_file ",
                "                                             WHERE omf11 = '",g_omf[l_ac].omf11,"'",
                "                                               AND omf12 = '",g_omf[l_ac].omf12,"')",
               #TQC-D10102--add--end
                "                     AND ogg092 = '",p_ogg.ogg092,"'",
                "   AND ogg01 like ltrim(rtrim(oayslip))||'-%'  AND oaytype = '70') ",                    
                "    AND ogg09 = '",p_ogg.ogg09,"'",
                "    AND ogg091 = '",p_ogg.ogg091,"'",
                "    AND ogg20 = '",p_ogg.ogg20,"'",
                "    AND ogg17 = '",g_omf[l_ac].omf13,"'",
                "    AND ogg092 = '",p_ogg.ogg092,"'"
               #add by TQC-D10102 ---start---
               ,"    AND ogg01 = omf00 AND ogg03 = omf21 "
               ,"    AND omf11 = '",g_omf[l_ac].omf11,"'"
               ,"    AND omf12 = '",g_omf[l_ac].omf12,"'"
               #add by TQC-D10102---end---
   PREPARE t670_chknumogg12_pre_4 FROM li_sql
   EXECUTE t670_chknumogg12_pre_4 INTO li_ogg12
   IF cl_null(li_ogg12) THEN LET li_ogg12 = 0 END IF 
   IF (p_ogg.ogg12 > l_ogg12 - li_ogg12) THEN 
      LET g_errno = 'axr-163'
   END IF 
END FUNCTION


#MOD-CB0073 add begin------
#check 开票日期和出货单&销退单的日期差异
FUNCTION t670_chkomf24(p_omf24)

DEFINE   p_omf24   LIKE omf_file.omf24,
         l_oga02   LIKE oga_file.oga02,
         l_oha02   LIKE oha_file.oha02,
         l_sql     STRING,
         l_omf    RECORD LIKE omf_file.*,
         l_ogb    RECORD LIKE ogb_file.*,
         l_ohb    RECORD LIKE ohb_file.*,
         l_flag    LIKE type_file.num5
   CALL s_showmsg_init()         
   LET l_flag = 0
   DECLARE omf_curs6 CURSOR FOR
       SELECT * FROM omf_file WHERE omf00 = g_omf_1.omf00                         
   FOREACH omf_curs6 INTO l_omf.*
      IF l_omf.omf10 NOT MATCHES '[12]' THEN 
         CONTINUE FOREACH 
      END IF    
      #出货日期检查
      IF l_omf.omf10 = '1' THEN 
         LET l_sql = "SELECT oga02  FROM ",cl_get_target_table(l_omf.omf09,'oga_file'),
                     " WHERE oga01 = '",l_omf.omf11,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         PREPARE sel_oga02 FROM l_sql
         EXECUTE sel_oga02 INTO l_oga02
         IF STATUS THEN 
            CALL s_errmsg('sel oga02',l_omf.omf11,l_omf.omf12,STATUS,1)
            LET g_success = 'N' 
            RETURN FALSE  
         END IF  
         IF p_omf24 < l_oga02 THEN 
            #CALL s_errmsg("sel oga02 ",l_oga02,p_omf24,"axm-714",1) #TQC-D20009 mark
            CALL s_errmsg("sel oga02 ",l_oga02,p_omf24,"axm-724",1)  #TQC-D20009 add
            LET l_flag = l_flag + 1    
         END IF                           
      END IF
      #销退日期检查 
      IF l_omf.omf10 = '2' THEN 
         LET l_sql = "SELECT oha02  FROM ",cl_get_target_table(l_omf.omf09,'oha_file'),
                     " WHERE oha01 = '",l_omf.omf11,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         PREPARE sel_oha02 FROM l_sql
         EXECUTE sel_oha02 INTO l_oha02
         IF STATUS THEN 
            CALL s_errmsg('sel oha02',l_omf.omf11,l_omf.omf12,STATUS,1)
            LET g_success = 'N' 
            RETURN FALSE  
         END IF  
         IF p_omf24 < l_oha02 THEN 
            #CALL s_errmsg("sel oha02 ",l_oha02,p_omf24,"axm-714",1) #TQC-D20009 mark
            CALL s_errmsg("sel oga02 ",l_oga02,p_omf24,"axm-723",1)  #TQC-D20009 add
            LET l_flag = l_flag + 1    
         END IF         
      END IF     
   
   END FOREACH
   CALL s_showmsg() 
   RETURN l_flag
END FUNCTION 
#MOD-CB0073 add end-------

#MOD-CC0230 add  begin---------------------
FUNCTION t670_fresh()

   SELECT UNIQUE omf00,omf01,omf02,omf03,omf05,omf051,omf06,omf061,omf07,omf08,omf22,omf30,omf24,omfpost,
                 omf04,'','','', '','','',   #MOD-D10128 add 3个'' #No.FUN-D10103  Add omf30#FUN-D20003 add omf04
                 omf31,omf32,omf33,omfuser,omfgrup,omforiu,omforig,omfmodu,omfdate  #FUN-D50007 ADD
     INTO g_omf_1.*
     FROM omf_file
    WHERE omf00 = g_omf_1.omf00 
    
   SELECT SUM(omf19),SUM(omf19x),SUM(omf19t),SUM(omf29),SUM(omf29x),SUM(omf29t)
    INTO g_omf_1.omf19_sum,g_omf_1.omf19x_sum,g_omf_1.omf19t_sum,g_omf_1.omf29_sum,g_omf_1.omf29x_sum,g_omf_1.omf29t_sum
    FROM omf_file
   WHERE omf00 = g_omf_1.omf00   
   CALL t670_upd_show_diff() #MOD-D60161 add
   LET g_omf_1.omf19_sum = cl_digcut(g_omf_1.omf19_sum,g_azi04)
   LET g_omf_1.omf19x_sum = cl_digcut(g_omf_1.omf19x_sum,g_azi04)
   LET g_omf_1.omf19t_sum = cl_digcut(g_omf_1.omf19t_sum,g_azi04)
   LET g_omf_1.omf29_sum = cl_digcut(g_omf_1.omf29_sum,t_azi04)
   LET g_omf_1.omf29x_sum = cl_digcut(g_omf_1.omf29x_sum,t_azi04)
   LET g_omf_1.omf29t_sum = cl_digcut(g_omf_1.omf29t_sum,t_azi04)
   CALL t670_show()

END FUNCTION 
#MOD-CC0230 add  end---------------------
FUNCTION t670_bdfp()
   IF s_shut(0) THEN
      RETURN
   END IF

   IF cl_null(g_omf_1.omf00) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   CALL t670_fresh()

  #INPUT發票資料段
   INPUT BY NAME g_omf_1.omf03,g_omf_1.omf01,g_omf_1.omf02 WITHOUT DEFAULTS


      #str------ add by dengsy170410
      AFTER FIELD omf03 
      LET l_count1=0
      LET l_count2=0
      SELECT count(*) INTO l_count1 FROM oga_file,omf_file
      WHERE omf00=g_omf00_t AND oga01=omf11 AND omf10='1'
      AND (oga02>g_omf_1.omf03 )
      SELECT count(*) INTO l_count2 FROM oha_file,omf_file
      WHERE omf00=g_omf00_t AND oha01=omf11 AND omf10='2'
      AND (oha02>g_omf_1.omf03)
      IF l_count1>0 THEN 
         CALL cl_err('','cxm-123',0) 
         NEXT FIELD CURRENT 
      END IF 
      IF l_count2>0 THEN 
         CALL cl_err('','cxm-124',0) 
         NEXT FIELD CURRENT 
      END IF
      #end------ add by dengsy170410
      ON ACTION CONTROLG
        CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()
     
      ON ACTION help
         CALL cl_show_help()

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
   
   END INPUT
   
   IF INT_FLAG THEN
      CALL t670_fresh()
      RETURN
   END IF 
   BEGIN WORK
   UPDATE omf_file SET omf03 = g_omf_1.omf03,
                       omf01 = g_omf_1.omf01,
                       omf02 = g_omf_1.omf02
    WHERE omf00 = g_omf_1.omf00
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","omf_file",g_omf00_t,"",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
   ELSE
   #MOD-D70152 add begin---------------
      IF NOT cl_null(g_omf_1.omf04) THEN 
         UPDATE oma_file SET oma09 = g_omf_1.omf03,
                             oma10 =  g_omf_1.omf01
                        WHERE oma01 = g_omf_1.omf04  
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","oma_file",g_omf_1.omf04,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
         ELSE                         
      #MOD-D70152 add end-----------------
            COMMIT WORK
         END IF    #MOD-D70152 add
      ELSE 
         COMMIT WORK #MOD-D70152 add  
      END IF     
   END IF
#TQC-D20009--cj--add--str--
   IF g_omf[l_ac].omf10 = '1' AND g_omf_1.omf08 = 'Y' THEN
      UPDATE ogb_file SET ogb71 = g_omf_1.omf01
       WHERE ogb01 = g_omf[l_ac].omf11
         AND ogb03 = g_omf[l_ac].omf21
   END IF
   IF g_omf[l_ac].omf10 = '2' AND g_omf_1.omf08 = 'Y' THEN
      UPDATE ohb_file SET ohb71 = g_omf_1.omf01
       WHERE ohb01 = g_omf[l_ac].omf11
         AND ohb03 = g_omf[l_ac].omf21
   END IF
#TQC-D20009--cj--add--end--
   CALL t670_fresh()
      
END FUNCTION
#FUN-D20003 add--end

#TQC-D20009--xj--add--str
FUNCTION t670_x()
   IF g_omf_1.omf01 IS NULL THEN
      CALL cl_err('',-400,0) 
      RETURN
   END IF  
   IF g_omf_1.omf00 IS NULL THEN RETURN END IF
   SELECT DISTINCT omf08 INTO g_omf_1.omf08 FROM omf_file
    WHERE omf00=g_omf_1.omf00
   IF g_omf_1.omf08 = 'Y' THEN CALL cl_err('','apc-122',1) RETURN END IF
    #已確認,不可異動！
   BEGIN WORK
   LET g_success = 'Y'
      
   OPEN t670_cl USING g_omf_1.omf00
   IF STATUS THEN
      CALL cl_err("OPEN t670_cl:", STATUS, 1)
      CLOSE t670_cl
      ROLLBACK WORK
      RETURN 
   END IF
   
  #FETCH t670_cl INTO g_omf_1.*               # 鎖住將被更改或取消的資料 #FUN-D50007 mark
   FETCH t670_cl INTO g_omf_1.omf00,g_omf_1.omf01,g_omf_1.omf02,     #FUN-D50007 add
                         g_omf_1.omf03,g_omf_1.omf05,g_omf_1.omf06,  #FUN-D50007 add
                         g_omf_1.omf07,g_omf_1.omf22,g_omf_1.omf30,  #FUN-D50007 add
                         g_omf_1.omf31,g_omf_1.omf32,g_omf_1.omf33   #FUN-D50007 add
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_omf_1.omf00,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   IF cl_void(0,0,g_omf_1.omf08) THEN
      IF g_omf_1.omf08 ='N' THEN
         LET g_omf_1.omf08='X'
      ELSE
         LET g_omf_1.omf08='N'
      END IF
      UPDATE omf_file SET
             omf08=g_omf_1.omf08
       WHERE omf00=g_omf_1.omf00
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","omf_file",g_omf_1.omf00,"",'',"","upd omf_file",1)
         LET g_success='N'
      END IF
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_omf_1.omf00,'V')
      DISPLAY BY NAME g_omf_1.omf08
   ELSE
      LET g_omf_1.omf08= g_omf_1_t.omf08
      DISPLAY BY NAME g_omf_1.omf08
      ROLLBACK WORK
   END IF

   SELECT DISTINCT omf08 INTO g_omf_1.omf08 FROM omf_file
    WHERE omf00=g_omf_1.omf00

   DISPLAY BY NAME g_omf_1.omf08
   IF g_omf_1.omf08 = 'X' THEN
      CALL cl_set_field_pic(g_omf_1.omf08,"Y","","","Y","")
    ELSE
      CALL cl_set_field_pic(g_omf_1.omf08,"N","","","N","")
   END IF
END FUNCTION

FUNCTION t670_pic()
 IF g_omf_1.omf08='X' THEN
    LET g_chr='Y'
 ELSE
    LET g_chr='N'
 END IF

 IF g_omf_1.omf08='Y' THEN
    LET g_chr2 = 'Y'
 ELSE
    LET g_chr2 = 'N'
 END IF
 CALL cl_set_field_pic(g_omf_1.omf08,g_chr2,"","",g_chr,"")
END FUNCTION
#TQC-D20009--xj--add--end

#TQC-D20009--add--str--
FUNCTION t670_set_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   #add by ly 20170222--s
   CALL cl_set_comp_entry("omf28,omf29,omf29x,omf29t,omf18,omf19,omf19x,omf19t",FALSE)
   CALL cl_set_comp_entry("omf21,omf09,omf10,omf11,omf12,omf25,omf26,omf13,omf14",TRUE)
   CALL cl_set_comp_entry("omf15,omf23,omf20,omf201,omf202,omf16,omf17",TRUE)
   CALL cl_set_comp_entry("omf913,omf914,omf915,omf910,omf911,omf912,omf916,omf917",TRUE)
   #add by ly 20170222--e
   #CALL cl_set_comp_entry('omf11,omf12,omf13,omf14,omf15,omf17,omf25,omf26',TRUE)  #FUN-D10082 add omf25,omf26
END FUNCTION

FUNCTION t670_set_no_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   IF l_ac>0 THEN
      IF g_omf[l_ac].omf10 = '9' THEN
         CALL cl_set_comp_entry('omf11,omf12',FALSE)
         #CALL cl_set_comp_entry('omf13,omf14,omf15,omf17',FALSE)        #FUN-D10082 add #yinhy130510
         CALL cl_set_comp_entry('omf14,omf15',FALSE)        #FUN-D10082 add #yinhy130510
      ELSE
         CALL cl_set_comp_entry('omf13,omf14,omf15,omf17,omf25,omf26',FALSE) #FUN-D10082 add omf25,omf26
      END IF
   END IF
   #add by ly 20170222--s
   IF g_change1 = 'Y' THEN 
      CALL cl_set_comp_entry("omf28,omf29,omf29x,omf29t,omf18,omf19,omf19x,omf19t",TRUE)
      CALL cl_set_comp_entry("omf21,omf09,omf10,omf11,omf12,omf25,omf26,omf13,omf14",FALSE)
      CALL cl_set_comp_entry("omf15,omf23,omf20,omf201,omf202,omf16,omf17",FALSE)
      CALL cl_set_comp_entry("omf913,omf914,omf915,omf910,omf911,omf912,omf916,omf917",FALSE)
   END IF 
   #add by ly 20170222--e

   #str----add by huanglf170225
  IF l_ac>0 THEN
      IF g_omf[l_ac].omf10 = '9' THEN
           CALL cl_set_comp_entry("omf28,omf29,omf29x,omf29t,omf18,omf19,omf19x,omf19t",TRUE)
      END IF
   END IF
   #str----end by huanglf170224
END FUNCTION
#TQC-D20009--add--str--


#MOD-D60035 add begin-----------------
FUNCTION t670_chk_date()

   DEFINE l_flag  LIKE type_file.chr1,
          i       LIKE type_file.num5,
          l_omf09 LIKE omf_file.omf09,
          l_omf10 LIKE omf_file.omf10,
          l_omf11 LIKE omf_file.omf11,
          l_oga02 LIKE oga_file.oga02,
          l_oha02 LIKE oha_file.oha02,
          l_sql   STRING
   
   LET l_flag = 'Y'
   FOR i = 1 TO g_rec_b
      SELECT omf09,omf10,omf11 INTO l_omf09,l_omf10,l_omf11 FROM omf_file
       WHERE omf00 = g_omf_1.omf00 
         AND omf21 = i 
         AND omf10 IN ('1','2')
      IF l_omf10 = '1' THEN 
         LET l_sql = " SELECT oga02 FROM ",cl_get_target_table(l_omf09,'oga_file'),
                     " WHERE oga01 = '", l_omf11,"'" 
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql    	
   	   CALL cl_parse_qry_sql(l_sql,l_omf09) RETURNING l_sql        
         PREPARE sel_oga02_pre FROM l_sql
         EXECUTE sel_oga02_pre INTO l_oga02                     
         IF l_oga02 >  g_omf_1.omf03 THEN 
            LET l_flag = 'N'
            EXIT FOR 
         END IF      
      END IF 
      IF l_omf10 = '2' THEN 
         LET l_sql = " SELECT oha02 FROM ",cl_get_target_table(l_omf09,'oha_file'),
                     " WHERE oha01 = '", l_omf11,"'" 
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql    	
   	   CALL cl_parse_qry_sql(l_sql,l_omf09) RETURNING l_sql        
         PREPARE sel_oha02_pre FROM l_sql
         EXECUTE sel_oha02_pre INTO l_oha02 
         IF l_oha02 >  g_omf_1.omf03 THEN 
            LET l_flag = 'N'
            EXIT FOR 
         END IF      
      END IF                  
   END FOR    
  
   RETURN l_flag
   
END FUNCTION 
#MOD-D60035 add end--------------------


#MOD-D60161 add begin-------------------
#页面下方显示的金额合计与应收相比较有尾差
FUNCTION t670_upd_show_diff()

   LET g_sql = " SELECT gec05,gec07,gec04 FROM ",cl_get_target_table(g_plant_new,'gec_file'),
               "  WHERE gec01='",g_omf_1.omf06,"' ",
               "    AND gec011 = '2'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql            
   PREPARE sel_gec07_pre22 FROM g_sql
   EXECUTE sel_gec07_pre22 INTO g_gec05,g_gec07,g_omf_1.omf061
   
   IF g_gec07 ='Y' THEN 
      LET g_omf_1.omf29_sum  = g_omf_1.omf29t_sum/(1+g_omf_1.omf061/100)
      LET g_omf_1.omf29x_sum = g_omf_1.omf29t_sum - g_omf_1.omf29_sum
      LET g_omf_1.omf19_sum  = g_omf_1.omf19t_sum/(1+g_omf_1.omf061/100)
      LET g_omf_1.omf19x_sum = g_omf_1.omf19t_sum - g_omf_1.omf19_sum      
   ELSE 
      LET g_omf_1.omf29t_sum  = g_omf_1.omf29_sum*(1+g_omf_1.omf061/100)
      LET g_omf_1.omf29x_sum = g_omf_1.omf29t_sum - g_omf_1.omf29_sum
      LET g_omf_1.omf19t_sum  = g_omf_1.omf19_sum*(1+g_omf_1.omf061/100)
      LET g_omf_1.omf19x_sum = g_omf_1.omf19t_sum - g_omf_1.omf19_sum      
   END IF    
END FUNCTION
#sunlm add end------------------

#MOD-DC0091 add beg------------------------
FUNCTION t670_jce_chk()
DEFINE l_flag   LIKE type_file.chr1
DEFINE l_ogb09  LIKE ogb_file.ogb09
DEFINE l_ohb09  LIKE ohb_file.ohb09
DEFINE l_ogb17  LIKE ogb_file.ogb17
DEFINE l_cnt    LIKE type_file.num5
   
   LET l_flag = 'Y'
   IF g_omf[l_ac].omf10 = '1' THEN #判断出货单单仓库是否在非成本仓
      LET g_sql = " SELECT ogb09,ogb17 FROM ",cl_get_target_table(g_plant_new,'ogb_file'), 
                  "  WHERE ogb01 = '",g_omf[l_ac].omf11,"'",
                  "  AND   ogb03 = '",g_omf[l_ac].omf12,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE sel_ogb09_pre_1 FROM g_sql
      EXECUTE sel_ogb09_pre_1 INTO l_ogb09,l_ogb17
      IF l_ogb17 ='Y' THEN #多仓储批的出货
         LET g_sql = " SELECT count(*) FROM ",cl_get_target_table(g_plant_new,'ogc_file'),",", cl_get_target_table(g_plant_new,'jce_file'),
                     "  WHERE ogc01 = '",g_omf[l_ac].omf11,"'",
                     "  AND   ogc03 = '",g_omf[l_ac].omf12,"'",
                     "  AND   jce02 = ogc09"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
         PREPARE sel_ogc_pre_1 FROM g_sql
         EXECUTE sel_ogc_pre_1 INTO l_cnt
         IF l_cnt > 0 THEN 
            LET l_flag = 'N' 
            RETURN l_flag
         END IF    
      ELSE 
         LET g_sql = " SELECT count(*) FROM ",cl_get_target_table(g_plant_new,'jce_file'),
                     "  WHERE jce02 = '",l_ogb09,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
         PREPARE sel_jce_pre_1 FROM g_sql
         EXECUTE sel_jce_pre_1 INTO l_cnt
         IF l_cnt > 0 THEN 
            LET l_flag = 'N' 
            RETURN l_flag
         END IF 
      END IF       
   ELSE #判断销退单仓库是否在非成本仓
      LET g_sql = " SELECT ohb09 FROM ",cl_get_target_table(g_plant_new,'ohb_file'), 
                  "  WHERE ohb01 = '",g_omf[l_ac].omf11,"'",
                  "  AND   ohb03 = '",g_omf[l_ac].omf12,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE sel_ohb09_pre_1 FROM g_sql
      EXECUTE sel_ohb09_pre_1 INTO l_ohb09 
      LET g_sql = " SELECT count(*) FROM ",cl_get_target_table(g_plant_new,'jce_file'),
                  "  WHERE jce02 = '",l_ohb09,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE sel_jce_pre_2 FROM g_sql
      EXECUTE sel_jce_pre_2 INTO l_cnt
      IF l_cnt > 0 THEN 
         LET l_flag = 'N' 
         RETURN l_flag
      END IF          
   END IF    
   RETURN l_flag
END FUNCTION 
#MOD-DC0091 add end------------------------


FUNCTION t670_sum_omf()
DEFINE l_count   LIKE type_file.num5
DEFINE l_sql     STRING
DEFINE l_omf_1   DYNAMIC ARRAY OF RECORD
        omf10    LIKE omf_file.omf10,   #类型
        omf11    LIKE omf_file.omf11,   #出货单号
        oga02    LIKE oga_file.oga02,   #出货日期
        ogbud02  LIKE ogb_file.ogbud02, #客户订单号
        omf13    LIKE omf_file.omf13,   #料号
        ima02    LIKE ima_file.ima02,   #品名
        ima021   LIKE ima_file.ima021,  #规格
        omf07    LIKE omf_file.omf07,   #币种
        omf17    LIKE omf_file.omf17,   #单位
        sum_omf16    LIKE ogb_file.ogb12,   #汇总数量
        omf28    LIKE omf_file.omf28,       #原币单价
        omf29    LIKE omf_file.omf29,       #原币税前金额 
        omf29t   LIKE omf_file.omf29t,      #原币含税金额
        omf18    LIKE omf_file.omf18,       #本币单价
        omf19    LIKE omf_file.omf19,       #本币税前金额
        omf19t   LIKE omf_file.omf19t       #本币含税金额
                 END RECORD
DEFINE l_i       LIKE type_file.num5
DEFINE l_rec_b   LIKE type_file.num5
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_omf11   LIKE omf_file.omf11,
       l_omf13   LIKE omf_file.omf13,
       l_omf28   LIKE omf_file.omf28,
       l_omf18   LIKE omf_file.omf18,
       l_flag    LIKE type_file.chr1,
       t_azi04   LIKE azi_file.azi04
DEFINE  l_sum1   LIKE omf_file.omf19,
         l_sum2   LIKE omf_file.omf19,
         l_sum3   LIKE omf_file.omf19,
         l_sum4   LIKE omf_file.omf19,
         l_sum5   LIKE omf_file.omf19,
         l_sum6   LIKE omf_file.omf19,
         l_oha09  LIKE oha_file.oha09,
         l_omf19x  LIKE omf_file.omf19x,
         l_omf29x   LIKE omf_file.omf29x

SELECT azi04 INTO t_azi04 FROM azi_file
 WHERE azi01 = g_omf_1.omf07  
 CALL cre_omf_tmp()  #用来存储料号+本币单价+原币单价
 DECLARE sel_omf_cur CURSOR FOR
 SELECT DISTINCT omf11,omf13  FROM omf_file WHERE omf00=g_omf_1.omf00
 FOREACH sel_omf_cur INTO l_omf11,l_omf13
   DECLARE sel_oomf_cur CURSOR FOR 
   SELECT omf28,omf18 FROM omf_file 
   WHERE omf00=g_omf_1.omf00 AND omf11=l_omf11 AND omf13=l_omf13 #add by huanglf161114
   ORDER BY omf21 DESC
   OPEN sel_oomf_cur 
   FETCH sel_oomf_cur INTO l_omf28,l_omf18
   CLOSE sel_oomf_cur 
   INSERT INTO t670_omf_tmp  VALUES (l_omf11,l_omf13,l_omf28,l_omf18)
   IF STATUS THEN 
      CALL cl_err('ins tmp err',STATUS,1)
      EXIT FOREACH 
      LET l_flag='N'
   END IF    
   
 END FOREACH 
 IF l_flag='N' THEN
    RETURN
 END IF 
 LET l_i=1
 LET l_sum1=0
 LET l_sum2=0
 LET l_sum3=0
 LET l_sum4=0
 LET l_sum5=0
 LET l_sum6=0
 
 DECLARE sel_omf1_cur CURSOR FOR
 SELECT omf10,omf11,'',ogbud02,omf13,ima02,ima021,omf07,omf17,sum(omf16),0,0,0,0,0,0 FROM 
 omf_file,ogb_file,ima_file
 WHERE omf00=g_omf_1.omf00 AND omf13=ima01 AND omf11=ogb01 AND omf12=ogb03 
 GROUP BY omf10,omf11,ogbud02,omf13,ima02,ima021,omf07,omf17
 FOREACH sel_omf1_cur INTO l_omf_1[l_i].*
   IF l_omf_1[l_i].omf10 = '2' THEN 
      LET l_oha09 = ''
      LET g_sql = " SELECT oha09 FROM ",cl_get_target_table(g_plant_new,'oha_file'),
                  "  WHERE oha01 = '",l_omf_1[l_i].omf11,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE sel_oha09_pre_1_aa FROM g_sql
      EXECUTE sel_oha09_pre_1_aa INTO l_oha09
   END IF 
  {# IF g_omf[l_ac].omf10 = '1' THEN 
      LET g_sql = " SELECT oga02 FROM ",cl_get_target_table(g_plant_new,'oga_file'), 
                  "  WHERE oga01 = '",g_omf[l_ac].omf11,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE sel_oga02_pre_2 FROM g_sql
      EXECUTE sel_oga02_pre_2 INTO l_oga02
         END IF 
   
}

   SELECT oga02 INTO l_omf_1[l_i].oga02 FROM oga_file WHERE oga01=l_omf_1[l_i].omf11  #出货日期
   SELECT omf28,omf18 INTO l_omf_1[l_i].omf28,l_omf_1[l_i].omf18 FROM t670_omf_tmp WHERE omf11=l_omf_1[l_i].omf11
   AND omf13=l_omf_1[l_i].omf13
   IF g_gec07 = 'Y' THEN    #含稅
      IF l_omf_1[l_i].sum_omf16 <> 0 THEN     
         LET l_omf_1[l_i].omf29 = cl_digcut((l_omf_1[l_i].omf28*l_omf_1[l_i].sum_omf16),t_azi04)/(1+g_omf_1.omf061/100)    
         LET l_omf_1[l_i].omf29t = l_omf_1[l_i].sum_omf16 * l_omf_1[l_i].omf28
      ELSE
         IF l_oha09 = '5' THEN 
            LET l_omf_1[l_i].omf29 = cl_digcut((l_omf_1[l_i].omf28*(-1)),t_azi04)/(1+g_omf_1.omf061/100)
            LET l_omf_1[l_i].omf29t =-1* l_omf_1[l_i].omf28
         END IF 
      END IF
   ELSE                     #不含稅
      #未稅金額=未稅單價*數量
      IF l_omf_1[l_i].sum_omf16 <> 0 THEN
         LET l_omf_1[l_i].omf29 = l_omf_1[l_i].sum_omf16 * l_omf_1[l_i].omf28
         LET l_omf_1[l_i].omf29 = cl_digcut(l_omf_1[l_i].omf29,t_azi04)
         LET l_omf_1[l_i].omf29t = l_omf_1[l_i].omf29 * (1+g_omf_1.omf061/100) 
      ELSE
         IF l_oha09 = '5' THEN
            LET l_omf_1[l_i].omf29 = -1*l_omf_1[l_i].omf28
            LET l_omf_1[l_i].omf29 = cl_digcut(l_omf_1[l_i].omf29,t_azi04)
            LET l_omf_1[l_i].omf29t = l_omf_1[l_i].omf29 * (1+g_omf_1.omf061/100)
         END IF
      END IF                                            
    END IF
    LET l_omf_1[l_i].omf29 = cl_digcut(l_omf_1[l_i].omf29,t_azi04)
    LET l_omf_1[l_i].omf29t = cl_digcut(l_omf_1[l_i].omf29t,t_azi04) #FUN-C60036 add
    LET l_omf_1[l_i].omf19 = l_omf_1[l_i].omf29 * g_omf_1.omf22
    LET l_omf_1[l_i].omf19 = cl_digcut(l_omf_1[l_i].omf19,g_azi04)     #本幣
    LET l_omf_1[l_i].omf19t = l_omf_1[l_i].omf29t * g_omf_1.omf22
    LET l_omf_1[l_i].omf19t = cl_digcut(l_omf_1[l_i].omf19t,g_azi04)   #本幣
    LET l_omf29x = l_omf_1[l_i].omf29t -l_omf_1[l_i].omf29 #原幣稅額
    LET l_omf29x = cl_digcut(l_omf29x,t_azi04)
    LET l_omf19x = l_omf_1[l_i].omf19t - l_omf_1[l_i].omf19
    LET l_omf19x = cl_digcut(l_omf19x,g_azi04) 
    LET l_sum1=l_sum1+l_omf_1[l_i].omf29     #原币税前金额合计
    LET l_sum2=l_sum2+l_omf29x    #原币税额合计
    LET l_sum3=l_sum3+l_omf_1[l_i].omf29t    #原币含税金额合计
    LET l_sum4=l_sum4+l_omf_1[l_i].omf19     #本币税前金额合计
    LET l_sum5=l_sum5+l_omf19x               #本币税额合计 
    LET l_sum6=l_sum6+l_omf_1[l_i].omf19t    #本币含税金额合计

    LET l_i=l_i+1
          

 END FOREACH 
 
 LET l_rec_b=l_i-1
 CALL l_omf_1.deleteElement(l_i)
 OPEN WINDOW i50111_t_w AT 4,3 WITH FORM "axm/42f/axmt670_aa"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

 CALL cl_ui_locale("axmt670_aa")
 CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY l_sum1 TO FORMONLY.sum1
   DISPLAY l_sum2 TO FORMONLY.sum2
   DISPLAY l_sum3 TO FORMONLY.sum3
   DISPLAY l_sum4 TO FORMONLY.sum4
   DISPLAY l_sum5 TO FORMONLY.sum5
   DISPLAY l_sum6 TO FORMONLY.sum6
 
   LET g_action_choice ='exporttoexcel'
   DISPLAY ARRAY l_omf_1 TO s_omf_1.* ATTRIBUTE(COUNT=l_rec_b)
   BEFORE ROW
            LET l_cnt = ARR_CURR()
            CALL cl_show_fld_cont()

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY

         ON ACTION about
            CALL cl_about()
         ON ACTION    exporttoexcel      #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(l_omf_1),'','')
            END IF
         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION EXIT
            EXIT DISPLAY

         ON ACTION CANCEL
            EXIT DISPLAY

    END DISPLAY
    CLOSE WINDOW i50111_t_w
    LET g_action_choice=''




END FUNCTION 



FUNCTION cre_omf_tmp()
DROP TABLE t670_omf_tmp
CREATE TEMP TABLE  t670_omf_tmp
(omf11   LIKE omf_file.omf11,
 omf13   LIKE omf_file.omf13,
 omf28   LIKE omf_file.omf28,
 omf18   LIKE omf_file.omf18)
DROP TABLE t6701_omf_tmp


END FUNCTION

