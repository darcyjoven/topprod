/*
================================================================================
檔案代號:oaz_file
檔案名稱:销售系统参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table oaz_file
(
oaz00       varchar2(1) NOT NULL,    /*KEY VALUE = '0'                        */
oaz01       varchar2(1),             /*当前销售系统是否可开放用户             */
                                     /*目前銷售系統是否可開放使用者使用(Y/N)? */
                                     /*Y: 正常使用                            */
                                     /*N: 僅供使用者列印查詢                  */
                                     /*   不可作資料的新增,修改,查詢,刪除     */
oaz02       varchar2(1),             /*是否与总帐管理系统连线                 */
                                     /*是否與總帳管理系統連線(Y.是/N.否)      */
                                     /*Y: 與總帳管理系統連線, 傳票將拋轉總帳  */
                                     /*N: 不與總帳管理系統連線, 傳票不拋轉總帳*/
oaz02p      varchar2(10),            /*总帐管理系统所在营运中心编             */
                                     /*Plant # where AGL is                   */
oaz02b      varchar2(5),             /*总帐管理系统使用帐套编号               */
                                     /*總帳管理系統使用帳別編號               */
oaz03       varchar2(1),             /*是否与制造管理系统连线                 */
                                     /*是否與製造管理系統連線(Y.是/N.否)      */
oaz04       varchar2(1),             /*是否与票据管理系统连线                 */
                                     /*是否與票據管理系統連線(Y.是/N.否)      */
oaz05       varchar2(1),             /*是否与应收帐款系统连线                 */
                                     /*是否與應收帳款系統連線(Y.是/N.否)      */
oaz06       varchar2(1),             /*是否生成MPS 异动记录                   */
                                     /*是否產生MPS 異動記錄                   */
oaz07       varchar2(1),             /*是否允许订单单价为0                    */
                                     /*是否允許訂單單價為0 (for 三角貿易)     */
oaz08       varchar2(1),             /*出货时单价是否重新计算                 */
                                     /*出貨時單價是否重新計算 (for 三角貿易)  */
oaz09       date,                    /*关帐日期                               */
                                     /*關帳日期                               */
oaz101      varchar2(1),             /*多营运中心出库否                       */
                                     /*Multi-Plant Store-out?(Y/N)            */
oaz102      varchar2(1),             /*多仓库出库否                           */
                                     /*多倉庫出庫否 (Y/N)                     */
oaz103      varchar2(1),             /*多库位出库否                           */
                                     /*多儲位出庫否 (Y/N)                     */
oaz104      varchar2(1),             /*多批号出库否                           */
                                     /*多批號出庫否 (Y/N)                     */
oaz105      varchar2(1),             /*一单到底                               */
oaz11       varchar2(10),            /*信用超限留置代码                       */
                                     /*信用超限留置代碼                       */
oaz121      varchar2(1),             /*订单打印时,信用检查超限处理            */
                                     /*訂單列印時,信用查核超限處理方式        */
                                     /* 0. 不檢查                             */
                                     /* 1. 顯示警告訊息                       */
oaz122      varchar2(1),             /*订单审核时,信用检查超限处理            */
                                     /*訂單確認時,信用查核超限處理方式 (0/1/2)*/
                                     /* 0. 不檢查                             */
                                     /* 1. 顯示警告訊息, 可確認但設定留置     */
                                     /* 2. 拒絕確認 (不可出貨)                */
oaz123      varchar2(1),             /*No Use                                 */
oaz131      varchar2(1),             /*出货通知单打印时,信用检查超            */
                                     /*出貨通知單列印時,信用查核超限處理方式  */
                                     /* 0. 不檢查                             */
                                     /* 1. 出貨通知單上列印警告訊息           */
oaz132      varchar2(1),             /*出货通知单审核时,信用检查超            */
                                     /*出貨通知單確認時,信用查核超限處理方式  */
                                     /* 0. 不檢查                             */
                                     /* 1. 顯示警告訊息                       */
                                     /* 2. 拒絕確認 (不可出貨)                */
oaz133      varchar2(1),             /*No Use                                 */
oaz141      varchar2(1),             /*出货单打印时,信用检查超限处            */
                                     /*出貨單列印時,信用查核超限處理方式(0/1/2)*/
                                     /* 0. 不檢查                             */
                                     /* 1. 出貨單上列印警告訊息               */
oaz142      varchar2(1),             /*出货审核时,信用检查超限处理            */
                                     /*出貨確認時,信用查核超限處理方式 (0/1/2)*/
                                     /* 0. 不檢查                             */
                                     /* 1. 顯示警告訊息, 並讓使用者選擇是否繼續*/
                                     /* 2. 拒絕確認 (不可開發票)              */
oaz151      number(5),               /*待抵帐款金额信用检查比率               */
                                     /*待抵帳款金額信用查核比率(%)            */
oaz152      number(5),               /*ＬＣ收状金额信用检查比率(%)            */
                                     /*ＬＣ收狀金額信用查核比率(%)            */
oaz153      number(5),               /*财务暂收支票信用检查比率               */
                                     /*財務暫收支票信用查核比率(%)            */
oaz154      number(5),               /*财务暂收ＴＴ信用检查比率               */
                                     /*財務暫收ＴＴ信用查核比率(%)            */
oaz155      number(5),               /*已冲帐未审核检查比率                   */
                                     /*已沖帳未確認查核比率(%)                */
oaz156      number(5),               /*No Use                                 */
oaz161      number(5),               /*未兑应收票据信用检查比率               */
                                     /*未兌應收票據信用查核比率(%)            */
oaz162      number(5),               /*发票应收帐款信用检查比率               */
                                     /*發票應收帳款信用查核比率(%)            */
oaz163      number(5),               /*出货未开发票信用检查比率               */
                                     /*出貨未開發票信用查核比率(%)            */
oaz164      number(5),               /*接单未出货额信用检查比率               */
                                     /*接單未出貨額信用查核比率(%)            */
oaz165      number(5),               /*出货通知单 检查比率(%)                 */
                                     /*出貨通知單 查核比率(%)                 */
oaz166      number(5),               /*No Use                                 */
oaz171      varchar2(1),             /*产品可用数量是否包含不可用             */
                                     /*產品可用數量是否包含不可用庫存數量 (Y/N)*/
oaz172      varchar2(1),             /*产品可用数量是否包含工单在             */
                                     /*產品可用數量是否包含工單在製量     (Y/N)*/
oaz173      varchar2(1),             /*产品可用数量是否包含ＦＱＣ             */
                                     /*產品可用數量是否包含ＦＱＣ數量     (Y/N)*/
oaz174      varchar2(1),             /*产品可用数量是否包含采购在             */
                                     /*產品可用數量是否包含採購在外量     (Y/N)*/
oaz175      varchar2(1),             /*产品可用数量是否包含ＩＱＣ             */
                                     /*產品可用數量是否包含ＩＱＣ數量     (Y/N)*/
oaz176      varchar2(1),             /*No Use                                 */
oaz181      varchar2(1),             /*产品可用数量是否扣除报价单             */
                                     /*產品可用數量是否扣除報價單數量 (Y/N)   */
oaz182      varchar2(1),             /*产品可用数量是否扣除订单受             */
                                     /*產品可用數量是否扣除訂單受訂量 (Y/N)   */
oaz183      varchar2(1),             /*产品可用数量是否扣除出货通             */
                                     /*產品可用數量是否扣除出貨通知量 (Y/N)   */
oaz184      varchar2(1),             /*订单单价低于取出单价的处理             */
oaz185      number(9,4),             /*低价比率                               */
oaz186      varchar2(1),             /*No Use                                 */
oaz19       varchar2(1),             /*集团订单分配是否抛转出货单             */
oaz201      number(5),               /*订单缺省容许超交率                     */
                                     /*訂單預設容許超交率 (%)                 */
oaz202      varchar2(1),             /*No Use                                 */
                                     /*nouse                       No.7953    */
oaz203      varchar2(1),             /*是否抛转 Invoice                       */
                                     /*是否拋轉 Invoice (Y/N)? (for 三角貿易) */
oaz204      varchar2(1),             /*是否抛转 Packing Lis                   */
                                     /*是否拋轉 Packing List(Y/N)?(for三角貿易)*/
oaz205      varchar2(3),             /*销退单抛转方式                         */
oaz206      varchar2(3),             /*No Use                                 */
oaz207      number(5),               /*No Use                                 */
oaz208      number(5),               /*No Use                                 */
oaz209      number(5),               /*No Use                                 */
oaz211      varchar2(1),             /*信用额度汇率基准                       */
oaz212      varchar2(1),             /*信用额度当日汇率基准                   */
oaz213      number(5),               /*No Use                                 */
oaz214      number(5),               /*No Use                                 */
oaz215      number(5),               /*No Use                                 */
oaz216      number(5),               /*No Use                                 */
oaz217      number(5),               /*No Use                                 */
oaz218      number(5),               /*No Use                                 */
oaz219      number(5),               /*No Use                                 */
oaz22       varchar2(1),             /*包装单审核时是否更新出货单             */
                                     /*包裝單確認時是否更新出貨單數量(Y/N)    */
oaz23       varchar2(1),             /*出货时,是否可作成品替代                */
oaz24       varchar2(1),             /*出货通知单录入后是否立刻开             */
                                     /*出貨通知單輸入後是否立刻開窗輸入地址(YN)*/
oaz25       number(5),               /*估价单工艺生成之序号间距数             */
                                     /*估價單製程產生之序號間隔數目(For 估價) */
oaz31       varchar2(1),             /*报价类参数                             */
                                     /*報價類參數                             */
oaz32       varchar2(1),             /*多角贸易使用汇率 S/B/C/D               */
                                     /*三角貿易使用匯率 S/B/C/D               */
oaz41       varchar2(2),             /*订单维护作业缺省起始版本编             */
                                     /*訂單維護作業預設起始版本編號           */
oaz42       varchar2(1),             /*出货时,成品替代方式                    */
                                     /*1.Prod Class                           */
                                     /*2.SUB Group                            */
oaz43       varchar2(1),             /*订单维护单身录入完,是否立刻            */
                                     /*訂單維護單身輸入完,是否立刻開窗輸入其它*/
oaz44       varchar2(1),             /*订单审核时是否更新产品客户             */
                                     /*訂單確認時是否更新產品客戶檔(Y/N)      */
oaz45       varchar2(1),             /*No Use                                 */
oaz46       varchar2(1),             /*订单录入料号时,是否依客户品            */
                                     /*訂單輸入料號時,是否依客戶品號轉換(Y/N) */
oaz51       varchar2(1),             /*出货通知单号是否与出货单号             */
                                     /*出貨通知單號是否與出貨單號一致 (Y/N)   */
oaz52       varchar2(1),             /*内销使用汇率 B/S/C/D                   */
                                     /*內銷使用匯率 B/S/C/D                   */
oaz61       varchar2(1),             /*出货单审核后库存扣帐方式               */
                                     /*出貨單確認後庫存扣帳方式 (1/2/3)       */
                                     /*  1.立刻扣帳(不詢問)                   */
                                     /*  2.立刻扣帳(會詢問)                   */
                                     /*  3.事後再扣帳                         */
oaz62       varchar2(1),             /*内销出货单扣帐后是否转入A/R            */
                                     /*內銷出貨單扣帳後是否轉入A/R並開發票(Y/N)*/
oaz63       varchar2(1),             /*销退单审核是否转入A/R                  */
                                     /*銷退單確認是否轉入A/R(Y/N)             */
oaz64       varchar2(1),             /*出货是否计入未开发票的销货             */
                                     /*出貨是否計入未開發票的銷貨待驗收入(YNO)*/
                                     /*  Y.是, 則出貨時產生(待驗)銷貨收入傳票 */
                                     /*        若有訂金, 則同時轉銷貨收入     */
                                     /*        發票開立後再將待驗應收轉入應收 */
                                     /*  N.否, 則發票開立後才產生銷貨收入傳票 */
                                     /*  O.依客戶訂單決定                     */
oaz65       varchar2(1),             /*出货单录入订单号检查方式               */
                                     /*出貨單輸入訂單號檢查方式               */
                                     /*  0.可空白                             */
                                     /*  1.不可空白                           */
oaz66       varchar2(1),             /*销退单录入出货单号检查方式             */
                                     /*銷退單輸入出貨單號檢查方式             */
                                     /*  0.可空白                             */
                                     /*  1.不可空白                           */
oaz67       varchar2(1),             /*包装单之出货单号来源为                 */
                                     /*包裝單之出貨單號來源為(1,2)            */
                                     /*  1.出貨單通知單                       */
                                     /*  2.出貨單                             */
oaz681      number(5),               /*国内订单单身储存最大笔数               */
                                     /*國內訂單單身儲存最大筆數               */
oaz682      number(5),               /*国外订单单身储存最大笔数               */
                                     /*國外訂單單身儲存最大筆數               */
oaz691      number(5),               /*国内出货单身储存最大笔数               */
                                     /*國內出貨單身儲存最大筆數               */
oaz692      number(5),               /*国外出货单身储存最大笔数               */
                                     /*國外出貨單身儲存最大筆數               */
oaz70       varchar2(1),             /*外销使用汇率 B/S/C/D                   */
                                     /*外銷使用匯率 B/S/C/D                   */
oaz71       varchar2(1),             /*出货异动明细自动赋予方式               */
                                     /*出貨異動明細自動賦予方式               */
                                     /*  1.與產品項次相同                     */
                                     /*  2.由(img_file)預設,料批與產品項次相同*/
oaz72       varchar2(1),             /*报价录入后是否立刻开窗录入             */
                                     /*報價輸入後是否立刻開窗輸入地址(Y/N)    */
oaz73       varchar2(1),             /*报价录入后是否立刻开窗录入             */
                                     /*報價輸入後是否立刻開窗輸入其它(Y/N)    */
oaz99       varchar2(1),             /*报价录入后是否立刻开窗录入             */
                                     /*報價輸入後是否立刻開窗輸入包裝(Y/N)    */
oaz74       varchar2(10),            /*出货待验仓库                           */
oaz75       varchar2(10),            /*出货待验库位                           */
oaz76       varchar2(10),            /*出货验退仓库                           */
oaz77       varchar2(10),            /*出货验退库位                           */
oaz78       varchar2(10),            /*借出客户仓库                           */
oaz79       varchar2(5),             /*借出调拨单单别                         */
oaz80       varchar2(20) DEFAULT ' ' NOT NULL, /*默认现金折扣单别*/
oaz81       varchar2(1),             /*出货通知单做批/序号控管                */
oaz83       varchar2(10),
oaz84       varchar2(10),
oaz85       varchar2(10),
oaz86       varchar2(10),            /*默认返券费用编号                       */
oaz87       varchar2(1) DEFAULT '1' NOT NULL, /*返券费用计算方式 1-销售金额,*/
oaz88       varchar2(10),            /*促销换赠理由码                         */
oaz89       varchar2(1) DEFAULT ' ' NOT NULL, /*促銷換贈歸屬*/
oaz90       varchar2(1) DEFAULT ' ' NOT NULL, /*积分/累计消费换物/换券归属*/
oaz91       varchar2(10),            /*积分/累计消费换物/换券理由             */
oazud01     varchar2(255),           /*自订字段                               */
oazud02     varchar2(40),            /*自订字段                               */
oazud03     varchar2(40),            /*自订字段                               */
oazud04     varchar2(40),            /*自订字段                               */
oazud05     varchar2(40),            /*自订字段                               */
oazud06     varchar2(255),           /*自订字段                               */
oazud07     number(15,3),            /*自订字段                               */
oazud08     number(15,3),            /*自订字段                               */
oazud09     number(15,3),            /*自订字段                               */
oazud10     number(10),              /*自订字段                               */
oazud11     number(10),              /*自订字段                               */
oazud12     number(10),              /*自订字段                               */
oazud13     date,                    /*自订字段                               */
oazud14     date,                    /*自订字段                               */
oazud15     date,                    /*自订字段                               */
oaz92       varchar2(1) DEFAULT ' ' NOT NULL, /*立账方式走开票流程*/
oaz93       varchar2(1) DEFAULT ' ' NOT NULL, /*发出商品纳入成本计算*/
oaz94       varchar2(1) DEFAULT ' ' NOT NULL, /*出货多次签收*/
oaz95       varchar2(10),            /*发票仓                                 */
oaz100      varchar2(1) DEFAULT ' ' NOT NULL, /*审核立即转应收*/
oaz106      varchar2(1) DEFAULT ' ' NOT NULL, /*审核立即过账*/
oaz97       varchar2(5),
oaz98       varchar2(5),             /*应收单别                               */
oaz107      varchar2(1) DEFAULT 'N' NOT NULL, /*做发出商品分录*/
oaz108      varchar2(1) DEFAULT ' ' NOT NULL
);

alter table oaz_file add  constraint oaz_pk primary key  (oaz00) enable validate;
grant select on oaz_file to tiptopgp;
grant update on oaz_file to tiptopgp;
grant delete on oaz_file to tiptopgp;
grant insert on oaz_file to tiptopgp;
grant index on oaz_file to public;
grant select on oaz_file to ods;
