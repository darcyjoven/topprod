/*
================================================================================
檔案代號:rvb_file
檔案名稱:收货单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rvb_file
(
rvb01       varchar2(20) NOT NULL,   /*收货单号                               */
                                     /*收貨單號  rva01                        */
                                     /*儲存該次的採購收貨收貨單號。           */
rvb02       number(5) NOT NULL,      /*收货单项次                             */
                                     /*收貨單項次                             */
                                     /*儲存該次的採購收貨收貨單的收貨項次。   */
rvb03       number(5),               /*采购单项次                             */
                                     /*採購單項次 pmn02                       */
                                     /*儲存該次的採購收貨收貨單的收貨項次的對 */
                                     /*應採購單的採購項次。                   */
                                     /*如為「委外代買料件」收貨時，則其項次固 */
                                     /*定為「0」。                            */
rvb04       varchar2(20),            /*采购单号                               */
                                     /*採購單號  pmm01(pmn01)                 */
                                     /*儲存該次的採購收貨收貨單的收貨項次的對 */
                                     /*應採購單號。                           */
rvb05       varchar2(40),            /*料件编号                               */
                                     /*料件编号  ima01 -->pmn041              */
                                     /*储存该次的采购收货料件的编号。         */
rvb06       number(15,3) NOT NULL,   /*已请款量                               */
                                     /*已請款量                               */
                                     /*儲存該次的採購收貨收貨量中已被請款的數 */
                                     /*量。                                   */
                                     /*該量=rvv23(已請款批配量)               */
rvb07       number(15,3) NOT NULL,   /*实收数量                               */
                                     /*實收數量                               */
                                     /*儲存該次的採購收貨收貨的實際數量。     */
rvb08       number(15,3) NOT NULL,   /*收货数量                               */
                                     /*收貨數量                               */
                                     /*儲存該次的採購收貨收貨單上的註明數量。 */
rvb09       number(15,3) NOT NULL,   /*允请款量                               */
                                     /*允請款量                               */
                                     /*儲存該次的採購收貨收貨量中被認可允許請 */
                                     /*款量。                                 */
rvb10       number(20,6) NOT NULL,   /*收料单价                               */
                                     /*收料單價(原幣)                         */
                                     /*儲存該次的採購收貨料件的原幣單價。     */
rvb11       number(5),               /*代买项次                               */
                                     /*代買項次                               */
                                     /*如為「委外代買料件」收貨時的對應代買項 */
                                     /*次。                                   */
                                     /*如為非「委外代買料件」收貨時，則固定為 */
                                     /*「0」。                                */
rvb12       date,                    /*收货应完成日期                         */
                                     /*收貨應完成日期                         */
                                     /*儲存該次的採購收貨料件需完成驗驗的最遲 */
                                     /*日期。                                 */
rvb13       varchar2(24),            /*厂商批号                               */
                                     /*廠商批號                               */
                                     /*儲存該次的採購收貨料件的廠商出廠批號； */
                                     /*如該廠商無此產品管制批號，則為「空白」。*/
rvb14       varchar2(10),            /*容器编号                               */
                                     /*容器代號                               */
                                     /*儲存該次的採購收貨料件的廠商出貨容器種 */
                                     /*類代號；如箱、筐、籮。                 */
rvb15       number(15,3),            /*容器装数                               */
                                     /*容器裝數                               */
                                     /*儲存該次的採購收貨料件的廠商出貨容器的 */
                                     /*裝貨量（計量單位為採購單位）。         */
rvb16       number(15,3),            /*容器数目                               */
                                     /*容器數目                               */
                                     /*儲存該次的採購收貨料件的廠商出貨容器數。*/
                                     /*容器數量*容器數目=實收數量             */
rvb17       varchar2(24),            /*检验批号                               */
                                     /*檢驗批號                               */
                                     /*儲存該次的採購收貨料件的設定檢驗批號， */
                                     /*裝貨量（計量單位為採購單位）。         */
rvb18       varchar2(2),             /*收货状况                               */
                                     /*收貨狀況                               */
                                     /*儲存該收貨料件目前處理狀況。           */
                                     /*系統自行維護。                         */
                                     /*正確值可區分為三階段，「10/20/30」。   */
                                     /*10: 在「收貨檢驗區」中                 */
                                     /*20: 在「會驗區（MRB）」中(已無此狀況)  */
                                     /*30: 入「庫存」                         */
rvb19       varchar2(1),             /*收货性质                               */
                                     /*收貨性質                               */
                                     /*儲存該收貨依據來源。                   */
                                     /*系統自行維護。                         */
                                     /*正確值為「1/2」。                      */
                                     /*1: 採購單收貨                          */
                                     /*2: 委外代買料件收貨                    */
rvb20       varchar2(10),            /*料件无法入库是否继续运行               */
rvb21       number(5),               /*保税过帐否                             */
                                     /*保稅過帳否                             */
                                     /*0:未確認                               */
                                     /*1:確認                                 */
rvb22       varchar2(1000),          /*发票编号                               */
                                     /*發票編號                               */
                                     /*儲存該筆收貨項次對應之發票號碼         */
rvb25       varchar2(20),            /*手册编号                               */
rvb26       date,                    /*No Use                                 */
rvb27       number(13,3),            /*No Use                                 */
rvb28       number(13,3),            /*No Use                                 */
rvb29       number(15,3) NOT NULL,   /*验退量                                 */
                                     /*驗退量                                 */
                                     /*儲存該收貨被「驗退」量                 */
rvb30       number(15,3) NOT NULL,   /*入库量                                 */
                                     /*入庫量                                 */
                                     /*儲存該收貨已檢驗「入庫」的數量。       */
rvb31       number(15,3) NOT NULL,   /*可入库量                               */
                                     /*可入庫量                               */
                                     /*儲存該收貨尚可被「入庫」的數量，亦即為 */
                                     /*rvb07-rvb29-rvb30                      */
rvb32       number(15,3),            /*退扣                                   */
rvb33       number(15,3),            /*允收数量                               */
                                     /*允收數量 (由QC人員於輸入檢驗結果時輸入)*/
rvb34       varchar2(20),            /*工单号码                               */
                                     /*工單號碼(97/05/01) sfb01               */
rvb35       varchar2(1),             /*样品否                                 */
                                     /*樣品否(97/05/09)                       */
rvb36       varchar2(10),            /*仓库                                   */
                                     /*倉庫  (97/07/21) imd01(img02)(imf02)   */
rvb37       varchar2(10),            /*库位                                   */
                                     /*儲位  (97/07/21) ime01(img03)No.+024   */
rvb38       varchar2(24),            /*批号                                   */
                                     /*批號  (97/07/21)       img04  No.+024  */
rvb39       varchar2(1),             /*检验否                                 */
                                     /*檢驗否   NO:7143                       */
rvb40       date,                    /*检验日期                               */
                                     /*檢驗日期 NO:7143                       */
rvb41       varchar2(40),            /*检验结果                               */
                                     /*檢驗結果 NO:7143                       */
rvb80       varchar2(4),             /*单位一                                 */
rvb81       number(20,8),            /*单位一换算率(与采购单位)               */
rvb82       number(15,3),            /*单位一数量                             */
rvb83       varchar2(4),             /*单位二                                 */
rvb84       number(20,8),            /*单位二换算率(与采购单位)               */
rvb85       number(15,3),            /*单位二数量                             */
rvb86       varchar2(4),             /*计价单位                               */
rvb87       number(15,3),            /*计价数量                               */
rvb88       number(20,6),            /*税前金额                               */
rvb88t      number(20,6),            /*含税金额                               */
rvb10t      number(20,6),            /*含税单价                               */
rvb331      number(15,3),            /*允收数量一                             */
rvb332      number(15,3),            /*允收数量二                             */
rvb930      varchar2(10),            /*成本中心                               */
rvbud01     varchar2(255),           /*备注                                   */
rvbud02     varchar2(40),            /*治工具是否收回                         */
rvbud03     varchar2(40),            /*放行                                   */
rvbud04     varchar2(40),            /*送货单号                               */
rvbud05     varchar2(40),            /*项目编号                               */
rvbud06     varchar2(40),            /*自订字段-文字                          */
rvbud07     number(15,3),            /*自订字段-数值                          */
rvbud08     number(15,3),            /*自订字段-数值                          */
rvbud09     number(15,3),            /*自订字段-数值                          */
rvbud10     number(10),              /*自订字段-整数                          */
rvbud11     number(10),              /*自订字段-整数                          */
rvbud12     number(10),              /*自订字段-整数                          */
rvbud13     date,                    /*生产日期                               */
rvbud14     date,                    /*储存有效日期                           */
rvbud15     date,                    /*自订字段-日期                          */
rvb051      varchar2(120),           /*品名规格                               */
rvb89       varchar2(1) DEFAULT 'N', /*VMI收货否                              */
rvb90       varchar2(4),             /*收货单位                               */
rvb90_fac   number(20,8),            /*收货单位与库存单位间的转换             */
rvb42       varchar2(1) DEFAULT ' ' NOT NULL, /*取价类型 1-搭赠,2-促销协议,3- */
rvb43       varchar2(20),            /*价格来源                               */
rvb44       varchar2(20),            /*来源单号                               */
rvb45       number(5),               /*来源项次                               */
rvbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rvblegal    varchar2(10) NOT NULL,   /*所属法人                               */
rvb93       varchar2(15),            /*电子交货序号                           */
rvb919      varchar2(50)             /*计画批号                               */
);

create        index rvb_02 on rvb_file (rvb04,rvb03);
create        index rvb_03 on rvb_file (rvb05);
alter table rvb_file add  constraint rvb_pk primary key  (rvb01,rvb02) enable validate;
grant select on rvb_file to tiptopgp;
grant update on rvb_file to tiptopgp;
grant delete on rvb_file to tiptopgp;
grant insert on rvb_file to tiptopgp;
grant index on rvb_file to public;
grant select on rvb_file to ods;
