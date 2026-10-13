/*
================================================================================
檔案代號:pon_file
檔案名稱:无交期性采购单单身
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pon_file
(
pon01       varchar2(20) NOT NULL,   /*采购单号                               */
                                     /*採購單號 pmm01                         */
pon011      varchar2(10),            /*单据性质                               */
                                     /*Document Property                      */
                                     /*The choose list show as flow:          */
                                     /*REG:REGular          General        Pruchase*/
                                     /*EXP:EXPensed         Consumption    Pruchase*/
                                     /*SER:SERvice          Service        Pruchase*/
                                     /*CAP:CAPital          Capital Goods  Pruchase*/
                                     /*BKR:BlanKet Regular  Blanket        Pruchase*/
                                     /*SUB:SUBcontracted    Subcontracting Pruchase*/
                                     /*DAS:De-assembly      Item Set       Pruchase*/
                                     /*IPO:InterLogistics   Multi-Plant    Pruchase*/
                                     /*RTN:Returned         Return/Cover/Purchase*/
pon02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
                                     /*採購單所含蓋的項目編號                 */
pon03       varchar2(20),            /*询价单号                               */
                                     /*Inquiry List#                          */
                                     /*Vender Inquiry Line#                   */
                                     /*Inputting Inquiry Line# Meet That The Vender No. Must Equal To Head Setting Supplier # In The Inquiry List*/
pon04       varchar2(40),            /*料件编号                               */
                                     /*料件編號 ima01                         */
                                     /*採購料件編號                           */
                                     /*使用者有輸入詢價單號時所輸入的料件需存在*/
                                     /*於所輸入的詢價單號                     */
pon041      varchar2(120),           /*品名规格                               */
                                     /*品名規格                               */
                                     /*為MISC 料件時必須輸入品名規格          */
pon05       varchar2(20),            /*APS单据编号                            */
                                     /*APS單據編號   no.4649 02/03/15(modify) */
pon06       varchar2(40),            /*厂商料件编号                           */
                                     /*Vender Item Code pmh04,pmh01=pon04,pmh02=pmm*/
                                     /*This field record the item code that defined by venders*/
                                     /*themselves.                            */
pon07       varchar2(4),             /*采购单位                               */
                                     /*Purchase Unit gfe01                    */
                                     /*This system can purchase by severy units, when the units*/
                                     /*is different, the system will auto-transfer the unit to*/
                                     /*the quantity related.                  */
pon08       varchar2(4),             /*库存单位                               */
                                     /*庫存單位 ima25                         */
                                     /*本欄位可比較庫存單位與採購單位是否相同 */
pon09       number(20,8),            /*换算因子                               */
                                     /*轉換因子                               */
                                     /*本欄位為採購單位/料件庫存單位的轉換率  */
                                     /*當採購收貨入庫可直接使用此轉換率       */
pon10       varchar2(10),            /*检验码                                 */
                                     /*檢驗碼                                 */
                                     /*為此批採購料件的檢驗理由               */
pon11       varchar2(1),             /*冻结码                                 */
                                     /*凍結碼                                 */
                                     /*採購時程凍結碼                         */
                                     /*正確值 Y/N                             */
                                     /*Y: MRP重新作業時, 不可重推採購需求時距 */
                                     /*N: MRP重新作業時,   可重推採購需求時距 */
pon121      number(20,8),            /*换算因子                               */
                                     /*轉換因子                    (97/06/19) */
                                     /*本欄位為採購單位/請購單位的轉換率      */
pon122      varchar2(10),            /*No Use                                 */
pon123      varchar2(24),            /*厂牌                                   */
                                     /*廠牌                        (97/12 add)*/
pon13       number(9,4),             /*超/短交限率                            */
                                     /*此採購料件可超交或短交的限率           */
pon14       varchar2(1),             /*部份交货                               */
                                     /*部份交貨(Y/N)                          */
                                     /*輸入後的正確值為'Y' 或 'N'             */
pon15       varchar2(1),             /*提前交货                               */
                                     /*提前交貨 (Y/N)                         */
                                     /*此採購料件是否可提前交貨               */
pon16       varchar2(1),             /*状况码                                 */
                                     /*狀況碼                                 */
                                     /*Status Flag                            */
                                     /*X :計劃工單轉入                        */
                                     /*0 :開立(Open)                          */
                                     /*1 :已核准                              */
                                     /*2 :已轉採購單                          */
                                     /*6 :結案-正常                           */
                                     /*7 :結案-結長                           */
                                     /*8 :結案-結短                           */
                                     /*9 :取消(Cancel)                        */
pon18       date,                    /*MRP 需求日期                           */
pon20       number(15,3) NOT NULL,   /*采购量                                 */
                                     /*採購量                                 */
pon21       number(15,3),            /*已转量                                 */
                                     /*已轉量                                 */
pon23       varchar2(10),            /*送货地址                               */
                                     /*送貨地址 pme01,pme02<>'1'              */
pon24       varchar2(20),            /*请购单号                               */
                                     /*請購單號 pmk01(pml01)                  */
pon25       number(5),               /*请购单号项次                           */
                                     /*請購單號項次 pml02                     */
pon30       number(20,6),            /*标准价格                               */
                                     /*標準價格                               */
                                     /*本欄位預設值為料件主檔中的採購成本     */
pon31       number(20,6) NOT NULL,   /*单价                                   */
                                     /*單價                                   */
                                     /*此料件的採購單價                       */
pon32       number(20,6),            /*采购价差                               */
                                     /*採購價差(PPV)                          */
                                     /*採購價差 = 單價 * 匯率 - 標準價格      */
                                     /*價差單位為本幣                         */
pon33       date,                    /*原始交货日期                           */
                                     /*原始交貨日期                           */
                                     /*預定供應廠商發貨日期                   */
                                     /*本欄位為輸入時的原始確定的交貨日期     */
pon34       date,                    /*原始到厂日期                           */
                                     /*原始到廠日期                           */
                                     /*該採購單項次到 本公司/廠房/檢驗區 日期 */
                                     /*本欄位為輸入時的原始確定的到到廠日期   */
pon35       date,                    /*原始到库日期                           */
                                     /*原始到庫日期                           */
                                     /*該採購單項次 入到 庫房 日期            */
                                     /*本欄位為輸入時的原始確定的到庫日期     */
pon36       date,                    /*最近审核交货日期                       */
                                     /*最近確認交貨日期                       */
                                     /*與廠商確認的最近一次交貨日期           */
pon37       date,                    /*最后一次到厂日期                       */
                                     /*最後一次到廠日期                       */
                                     /*與廠商確認的最後一次到廠日期           */
pon38       varchar2(1),             /*可用/不可用                            */
                                     /*該採購單項次的料件為可用庫存或者使用者有*/
                                     /*其特殊用途可定義成不可用庫存           */
pon40       varchar2(24),            /*会计科目                               */
                                     /*會計科目 aag01                         */
pon41       varchar2(20),            /*工单号码                               */
                                     /*工單號碼 sfb01                         */
                                     /*單據性質為廠外加工 (SUB) 時本欄位需輸入*/
                                     /*且製程序號需輸入                       */
pon42       varchar2(1),             /*替代码                                 */
                                     /*替代碼 (0/1/2/S/U)                     */
                                     /*0: 原始料件, 不可被替代                */
                                     /*1: 原始料件, 可以被替代                */
                                     /*2: 原始料件, 已經被替代                */
                                     /*S: 替代料件                            */
pon43       number(5),               /*本工艺序号                             */
                                     /*本製程序號                             */
                                     /*如為專屬採購單則本欄位值為 0           */
pon431      number(5),               /*下工艺序号                             */
                                     /*下製程序號                             */
                                     /*如為專屬採購單則本欄位值為 0           */
pon44       number(20,6),            /*本币单价                               */
                                     /*本幣單價                               */
                                     /*本幣單價 = 單價 * 匯率                 */
pon45       number(5),               /*无交期性采购单项次                     */
                                     /*無交期性採購單項次                     */
pon46       number(5),               /*工艺序号                               */
                                     /*製程序號 ecm03                         */
                                     /*料件被製作程序過程中的生產活動順序編號 */
pon50       number(15,3) NOT NULL,   /*已转采购量                             */
                                     /*已轉採購量                             */
pon51       number(15,3) NOT NULL,   /*在验量                                 */
                                     /*在驗量                                 */
pon52       varchar2(10),            /*仓库                                   */
                                     /*倉庫imd01(img02)(imf02)           (8608)*/
pon53       number(15,3) NOT NULL,   /*入库量                                 */
                                     /*入庫量                                 */
pon54       varchar2(10),            /*库位                                   */
                                     /*儲位ime01(img03)(imf03)           (8608)*/
pon55       number(15,3) NOT NULL,   /*验退量                                 */
                                     /*驗退量                                 */
pon56       varchar2(24),            /*批号                                   */
                                     /*批號     img04                    (8608)*/
pon57       number(15,3) NOT NULL,   /*超短交量                               */
                                     /*超短交量 (= pon50 - pon20)             */
                                     /*結案時計算, 短交為負值, 超交為正值     */
pon58       number(15,3),            /*仓退量                                 */
                                     /*倉退量                            (8704)*/
pon59       varchar2(20),            /*退货单号                               */
                                     /*退貨單號                               */
pon60       number(5),               /*项次                                   */
                                     /*項次                                   */
pon61       varchar2(40) NOT NULL,   /*被替代料号                             */
                                     /*被替代料號                             */
                                     /*當 pon42='0/1/2'時,本欄位儲存料號同pon04*/
                                     /*當 pon42='S'    時,本欄位儲存被替代料號*/
pon62       number(9,4) NOT NULL,    /*替代率                                 */
                                     /*當 pon42='0/1/2'時,本欄位=1            */
                                     /*當 pon42='S'    時,本欄位儲存替代率    */
pon63       varchar2(1),             /*急料否                                 */
pon64       varchar2(1),             /*保税否                                 */
                                     /*保稅否                                 */
pon65       varchar2(1),             /*代买性质                               */
                                     /*代買性質 1.一般採購 2.代買採購         */
pon66       varchar2(10),            /*预算编号                               */
                                     /*預算編號   (For 請採購預算)            */
pon67       varchar2(10),            /*部门编号                               */
                                     /*部門編號   (For 請採購預算)            */
pon80       varchar2(4),             /*单位一                                 */
pon81       number(20,8),            /*单位一换算率(与采购单位)               */
pon82       number(15,3),            /*单位一数量                             */
pon83       varchar2(4),             /*单位二                                 */
pon84       number(20,8),            /*单位二换算率(与采购单位)               */
pon85       number(15,3),            /*单位二数量                             */
pon86       varchar2(4),             /*计价单位                               */
pon87       number(15,3),            /*计价数量                               */
pon88       number(20,6),            /*税前金额                               */
pon88t      number(20,6),            /*含税金额                               */
pon31t      number(20,6),            /*含税单价                               */
ponud01     varchar2(255),           /*自订字段-Textedit                      */
ponud02     varchar2(40),            /*自订字段-文字                          */
ponud03     varchar2(40),            /*自订字段-文字                          */
ponud04     varchar2(40),            /*自订字段-文字                          */
ponud05     varchar2(40),            /*自订字段-文字                          */
ponud06     varchar2(40),            /*自订字段-文字                          */
ponud07     number(15,3),            /*自订字段-数值                          */
ponud08     number(15,3),            /*自订字段-数值                          */
ponud09     number(15,3),            /*自订字段-数值                          */
ponud10     number(10),              /*自订字段-整数                          */
ponud11     number(10),              /*自订字段-整数                          */
ponud12     number(10),              /*自订字段-整数                          */
ponud13     date,                    /*自订字段-日期                          */
ponud14     date,                    /*自订字段-日期                          */
ponud15     date,                    /*自订字段-日期                          */
ponplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ponlegal    varchar2(10) NOT NULL,   /*所属法人                               */
pon19       date                     /*截止日期                               */
);

create        index pon_03 on pon_file (pon41);
create        index pon_02 on pon_file (pon04);
create        index pon_04 on pon_file (pon24,pon25);
alter table pon_file add  constraint pon_pk primary key  (pon01,pon02) enable validate;
grant select on pon_file to tiptopgp;
grant update on pon_file to tiptopgp;
grant delete on pon_file to tiptopgp;
grant insert on pon_file to tiptopgp;
grant index on pon_file to public;
grant select on pon_file to ods;
