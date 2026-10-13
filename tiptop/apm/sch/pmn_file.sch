/*
================================================================================
檔案代號:pmn_file
檔案名稱:采购单单身
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pmn_file
(
pmn01       varchar2(20) NOT NULL,   /*采购单号                               */
                                     /*採購單號 pmm01                         */
pmn011      varchar2(10),            /*单据性质                               */
                                     /*單據性質                               */
                                     /*正確值 REG/EXP/SER/CAP/BKR/SUB/DAS/IPO */
                                     /* /RTN                                  */
                                     /*REG:REGular          一般性  採購      */
                                     /*EXP:EXPensed         消耗性  採購      */
                                     /*SER:SERvice          服務性  採購      */
                                     /*CAP:CAPital          資材性  採購      */
                                     /*BKR:BlanKet Regular  無交期性採購      */
                                     /*SUB:SUBcontracted    廠外加工採購      */
                                     /*DAS:De-assembly      套件    採購      */
                                     /*IPO:InterLogistics       多工廠  採購  */
                                     /*RTN:Returned         退貨補貨採購      */
pmn02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
                                     /*採購單所含蓋的項目編號                 */
pmn03       varchar2(20),            /*询价单号                               */
                                     /*Inquiry List#                          */
                                     /*Vender Inquiry Line#                   */
                                     /*Inputting Inquiry Line# Meet That The Vender No. Must Equal To Head Setting Supplier # In The Inquiry List*/
pmn04       varchar2(40),            /*料件编号                               */
                                     /*Item Code ima01                        */
                                     /*Purchase Item Code                     */
                                     /*When input inquiry list code, the related material item */
                                     /*must be exit in the inquiry list.      */
pmn041      varchar2(120),           /*品名规格                               */
                                     /*品名規格                               */
                                     /*為MISC 料件時必須輸入品名規格          */
pmn05       varchar2(20),            /*APS单据编号                            */
                                     /*APS單據編號 no.4650 02/03/15(modify)   */
pmn06       varchar2(40),            /*厂商料件编号                           */
                                     /*Vender Item# pmh04,pmh01=pmn04,pmh02=pmm*/
                                     /*Vender May Make Item No. Themselvs, The Field Record The Item# Make By Vender*/
pmn07       varchar2(4),             /*采购单位                               */
                                     /*Purchase Unit gfe01                    */
                                     /*This system can purchase by severy units, when the units*/
                                     /*is different, the system will auto-transfer the unit to*/
                                     /*the quantity related.                  */
pmn08       varchar2(4),             /*库存单位                               */
                                     /*庫存單位 ima25                         */
                                     /*本欄位可比較庫存單位與採購單位是否相同 */
pmn09       number(20,8),            /*换算因子                               */
                                     /*轉換因子                               */
                                     /*本欄位為採購單位/料件庫存單位的轉換率  */
                                     /*當採購收貨入庫可直接使用此轉換率       */
pmn10       varchar2(4),             /*No Use                                 */
                                     /*NO USE                                 */
pmn11       varchar2(1),             /*冻结码                                 */
                                     /*凍結碼                                 */
                                     /*採購時程凍結碼                         */
                                     /*正確值 Y/N                             */
                                     /*Y: MRP重新作業時, 不可重推採購需求時距 */
                                     /*N: MRP重新作業時,   可重推採購需求時距 */
pmn121      number(20,8),            /*换算因子                               */
                                     /*轉換因子                    (97/06/19) */
                                     /*本欄位為採購單位/請購單位的轉換率      */
pmn122      varchar2(10),            /*项目编号                               */
                                     /*專案代號 (00/04/18)                    */
pmn123      varchar2(24),            /*厂牌                                   */
                                     /*廠牌                        (97/12 add)*/
pmn13       number(9,4),             /*超/短交限率                            */
                                     /*此採購料件可超交或短交的限率           */
pmn14       varchar2(1),             /*部份交货                               */
                                     /*部份交貨(Y/N)                          */
                                     /*輸入後的正確值為'Y' 或 'N'             */
pmn15       varchar2(1),             /*提前交货                               */
                                     /*提前交貨 (Y/N)                         */
                                     /*此採購料件是否可提前交貨               */
pmn16       varchar2(1),             /*状况码                                 */
                                     /*狀況碼                                 */
                                     /*Status Flag                            */
                                     /*X :計劃工單轉入                        */
                                     /*0 :開立(Open)                          */
                                     /*1 :已核准                              */
                                     /*2 :發出採購單                          */
                                     /*6 :結案-正常                           */
                                     /*7 :結案-結長                           */
                                     /*8 :結案-結短                           */
                                     /*9 :取消(Cancel)                        */
pmn18       varchar2(23),            /*RunCard单号(委外)                      */
                                     /*RunCard單號(委外)                      */
pmn20       number(15,3) NOT NULL,   /*采购量                                 */
                                     /*採購量                                 */
pmn23       varchar2(10),            /*送货地址                               */
                                     /*送貨地址 pme01,pme02<>'1'              */
pmn24       varchar2(20),            /*请购单号                               */
                                     /*請購單號 pmk01(pml01)                  */
pmn25       number(5),               /*请购单号项次                           */
                                     /*請購單號項次 pml02                     */
pmn30       number(20,6),            /*标准价格                               */
                                     /*標準價格                               */
                                     /*本欄位預設值為料件主檔中的採購成本     */
pmn31       number(20,6) NOT NULL,   /*单价                                   */
                                     /*單價              #未稅單價 Bug No.7259*/
                                     /*此料件的採購單價                       */
pmn31t      number(20,6),            /*含税单价                               */
                                     /*Price With Tax          #Price With Tax  Bug No.7259*/
                                     /*Purchase Price Of This Item,Calculate By Formula When Create pmn31: pmn31t= pmn31*(1+pmm43/100)*/
pmn32       number(5),               /*RunCard委外工艺序                      */
                                     /*RunCard委外製程序                      */
pmn33       date,                    /*原始交货日期                           */
                                     /*原始交貨日期                           */
                                     /*預定供應廠商發貨日期                   */
                                     /*本欄位為輸入時的原始確定的交貨日期     */
pmn34       date,                    /*原始到厂日期                           */
                                     /*原始到廠日期                           */
                                     /*該採購單項次到 本公司/廠房/檢驗區 日期 */
                                     /*本欄位為輸入時的原始確定的到到廠日期   */
pmn35       date,                    /*原始到库日期                           */
                                     /*原始到庫日期                           */
                                     /*該採購單項次 入到 庫房 日期            */
                                     /*本欄位為輸入時的原始確定的到庫日期     */
pmn36       date,                    /*最近审核交货日期                       */
                                     /*最近確認交貨日期                       */
                                     /*與廠商確認的最近一次交貨日期           */
pmn37       date,                    /*最后一次到厂日期                       */
                                     /*最後一次到廠日期                       */
                                     /*與廠商確認的最後一次到廠日期           */
pmn38       varchar2(1),             /*可用/不可用                            */
                                     /*Usable/Unusable                        */
                                     /*Item Of The P/O Line # is Available Inventory, If User Have Sepecial Usage Can Define It To UnAvailable Inventory*/
pmn40       varchar2(24),            /*会计科目                               */
                                     /*會計科目 aag01                         */
pmn41       varchar2(20),            /*工单号码                               */
                                     /*工單號碼 sfb01                         */
                                     /*單據性質為廠外加工 (SUB) 時本欄位需輸入*/
                                     /*且製程序號需輸入                       */
pmn42       varchar2(1) NOT NULL,    /*替代码                                 */
                                     /*替代碼 (0/1/2/S/U)                     */
                                     /*0: 原始料件, 不可被替代                */
                                     /*1: 原始料件, 可以被替代                */
                                     /*2: 原始料件, 已經被替代                */
                                     /*S: 替代料件                            */
pmn43       number(5),               /*本工艺序号                             */
                                     /*本製程序號                             */
                                     /*如為專屬採購單則本欄位值為 0           */
pmn431      number(5),               /*下工艺序号                             */
                                     /*下製程序號                             */
                                     /*如為專屬採購單則本欄位值為 0           */
pmn44       number(20,6),            /*本币单价                               */
                                     /*本幣單價                               */
                                     /*本幣單價 = 單價 * 匯率                 */
pmn45       number(5),               /*无交期性采购单项次                     */
                                     /*無交期性採購單項次                     */
pmn46       number(5),               /*工艺序号                               */
                                     /*製程序號 ecm03                         */
                                     /*料件被製作程序過程中的生產活動順序編號 */
pmn50       number(15,3) NOT NULL,   /*交货量                                 */
                                     /*交貨量                                 */
                                     /*=>未交=訂購  - (已交 - 驗退量)         */
                                     /*      (pmn20 - (pmn50 - pmn55)         */
                                     /*報表或查詢作業的已交量= 交貨量-驗退量  */
pmn51       number(15,3) NOT NULL,   /*在验量                                 */
                                     /*在驗量                                 */
pmn52       varchar2(10),            /*仓库                                   */
                                     /*倉庫imd01(img02)(imf02)           (8608)*/
pmn53       number(15,3) NOT NULL,   /*入库量                                 */
                                     /*入庫量                                 */
pmn54       varchar2(10),            /*库位                                   */
                                     /*儲位ime01(img03)(imf03)           (8608)*/
pmn55       number(15,3) NOT NULL,   /*验退量                                 */
                                     /*驗退量                                 */
pmn56       varchar2(24),            /*批号                                   */
                                     /*批號     img04                    (8608)*/
pmn57       number(15,3) NOT NULL,   /*超短交量                               */
                                     /*超短交量 (= pmn50 - pmn20-pmn55)       */
                                     /*結案時計算, 短交為負值, 超交為正值     */
pmn58       number(15,3) DEFAULT '0' NOT NULL, /*退货换货量*/
                                     /*仓退量                            (8704)*/
pmn59       varchar2(20),            /*退货单号                               */
                                     /*退貨單號                               */
pmn60       number(5),               /*项次                                   */
                                     /*項次                                   */
pmn61       varchar2(40) NOT NULL,   /*被替代料号                             */
                                     /*被替代料號                             */
                                     /*當 pmn42='0/1/2'時,本欄位儲存料號同pmn04*/
                                     /*當 pmn42='S'    時,本欄位儲存被替代料號*/
pmn62       number(9,4) NOT NULL,    /*替代率                                 */
                                     /*當 pmn42='0/1/2'時,本欄位=1            */
                                     /*當 pmn42='S'    時,本欄位儲存替代率    */
pmn63       varchar2(1),             /*急料否                                 */
pmn64       varchar2(1),             /*保税否                                 */
                                     /*保稅否                                 */
pmn65       varchar2(1),             /*代买性质                               */
                                     /*代買性質 1.一般採購 2.代買採購         */
pmn66       varchar2(10),            /*预算编号                               */
                                     /*預算編號   (For 請採購預算)            */
pmn67       varchar2(10),            /*部门编号                               */
                                     /*部門編號   (For 請採購預算)            */
pmn68       varchar2(20),            /*Blanket PO 单号                        */
                                     /*Blanket PO 單號   add 01/09/04         */
pmn69       number(5),               /*Blanket PO 项次                        */
pmn70       number(20,8),            /*换算因子                               */
                                     /*轉換因子          add 01/09/04         */
                                     /*本欄位為採購單位/Blanket PO單位的轉換率*/
pmn71       varchar2(20),            /*海关手册编号                           */
                                     /*海關手冊編號  add 02/11/12             */
pmn80       varchar2(4),             /*单位一                                 */
pmn81       number(20,8),            /*单位一换算率(与采购单位)               */
pmn82       number(15,3),            /*单位一数量                             */
pmn83       varchar2(4),             /*单位二                                 */
pmn84       number(20,8),            /*单位二换算率(与采购单位)               */
pmn85       number(15,3),            /*单位二数量                             */
pmn86       varchar2(4),             /*计价单位                               */
pmn87       number(15,3),            /*计价数量                               */
pmn88       number(20,6),            /*税前金额                               */
pmn88t      number(20,6),            /*含税金额                               */
pmn930      varchar2(10),            /*采购成本中心                           */
pmn401      varchar2(24),            /*会计科目二                             */
pmn90       number(20,6),            /*取出单价                               */
pmn94       varchar2(16),            /*no use                                 */
pmn95       number(5),               /*no use                                 */
pmn96       varchar2(30),            /*WBS编号                                */
pmn97       varchar2(4),             /*活动编号                               */
pmn98       varchar2(10),            /*费用原因                               */
pmn91       varchar2(10),            /*单元编号                               */
pmnud01     varchar2(255),           /*备注                                   */
pmnud02     varchar2(40),            /*自订字段-文字                          */
pmnud03     varchar2(40),            /*治工具是否外发                         */
pmnud04     varchar2(40),            /*自订字段-文字                          */
pmnud05     varchar2(40),            /*自订字段-文字                          */
pmnud06     varchar2(40),            /*自订字段-文字                          */
pmnud07     number(15,3),            /*自订字段-数值                          */
pmnud08     number(15,3),            /*自订字段-数值                          */
pmnud09     number(15,3),            /*自订字段-数值                          */
pmnud10     number(10),              /*自订字段-整数                          */
pmnud11     number(10),              /*自订字段-整数                          */
pmnud12     number(10),              /*自订字段-整数                          */
pmnud13     date,                    /*自订字段-日期                          */
pmnud14     date,                    /*自订字段-日期                          */
pmnud15     date,                    /*自订字段-日期                          */
pmn89       varchar2(1) DEFAULT 'N', /*VMI采购                                */
pmn72       varchar2(40),            /*商品条码                               */
pmn73       varchar2(1) DEFAULT ' ' NOT NULL, /*取价类型 1-搭赠,2-促销协议,3- */
pmn74       varchar2(20),            /*价格来源                               */
pmn75       varchar2(20),            /*来源单号                               */
pmn76       number(5),               /*来源项次                               */
pmn77       varchar2(10),            /*来源营运中心                           */
pmnplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pmnlegal    varchar2(10) NOT NULL,   /*所属法人                               */
pmn012      varchar2(10),            /*工艺段号                               */
pmn919      varchar2(50),            /*计画批号                               */
pmn99       varchar2(15),            /*电子采购序号                           */
pmn78       varchar2(6),             /*作业编号                               */
pmn100      varchar2(255)            /*备注                                   */
);

create        index pmn_04 on pmn_file (pmn24,pmn25);
create        index pmn_03 on pmn_file (pmn41);
create        index pmn_02 on pmn_file (pmn04);
alter table pmn_file add  constraint pmn_pk primary key  (pmn01,pmn02) enable validate;
grant select on pmn_file to tiptopgp;
grant update on pmn_file to tiptopgp;
grant delete on pmn_file to tiptopgp;
grant insert on pmn_file to tiptopgp;
grant index on pmn_file to public;
grant select on pmn_file to ods;
