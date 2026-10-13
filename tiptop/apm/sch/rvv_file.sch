/*
================================================================================
檔案代號:rvv_file
檔案名稱:入库/退扣单异动档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rvv_file
(
rvv01       varchar2(20) NOT NULL,   /*入库单号/退货单号                      */
                                     /*入庫單號/退貨單號  rvu01               */
rvv02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
rvv03       varchar2(1),             /*异动类型                               */
                                     /*異動類別 (1.入庫  2.驗退 3.倉退) rvu00 */
rvv04       varchar2(20),            /*收货单号                               */
                                     /*收貨單號 rva01(rvb01)                  */
rvv05       number(5),               /*项次                                   */
                                     /*項次           rvb02                   */
rvv06       varchar2(10),            /*送货厂商编号                           */
                                     /*送貨廠商編號   pmc01                   */
rvv09       date,                    /*异动日期                               */
                                     /*異動日期                               */
rvv17       number(15,3),            /*数量                                   */
                                     /*數量                                   */
rvv18       varchar2(20),            /*工单编号                               */
                                     /*工單編號       sfb01                   */
rvv23       number(15,3),            /*已请款匹配量                           */
                                     /*已請款匹配量                           */
rvv24       varchar2(1),             /*保税过帐否                             */
                                     /*保稅過帳否                             */
rvv25       varchar2(1),             /*样品否                                 */
                                     /*樣品否                                 */
rvv26       varchar2(10),            /*退货理由                               */
                                     /*退貨理由      azf01,azf02='2'          */
rvv31       varchar2(40),            /*料件编号                               */
                                     /*料件編號      ima01(img01)             */
rvv031      varchar2(120),           /*品名                                   */
                                     /*料名                                   */
rvv32       varchar2(10),            /*仓库                                   */
                                     /*倉庫          imd01(img02)(imf02)      */
rvv33       varchar2(10),            /*存放位置                               */
                                     /*存放位置      ime01(img03)(imf03)      */
rvv34       varchar2(24),            /*批号/项目编号                          */
                                     /*批號/專案代號   img04 / pmn122 No.+024 */
rvv35       varchar2(4),             /*单位                                   */
                                     /*單位          gfe01                    */
rvv35_fac   number(20,8),            /*转换率                                 */
                                     /*轉換率                         #No:7704*/
rvv36       varchar2(20),            /*采购单号                               */
                                     /*採購單號      pmm01(pmn01)             */
rvv37       number(5),               /*采购序号                               */
                                     /*採購序號            pmn02              */
rvv38       number(20,6),            /*单价                                   */
                                     /*單價                           971026Add*/
rvv39       number(20,6),            /*金额                                   */
                                     /*金額                           971026Add*/
rvv40       varchar2(1),             /*冲暂估否                               */
rvv41       varchar2(20),            /*手册编号                               */
rvv42       number(5),               /*No Use                                 */
rvv43       number(5),               /*No Use                                 */
rvv80       varchar2(4),             /*单位一                                 */
rvv81       number(20,8),            /*单位一换算率(与采购单位)               */
rvv82       number(15,3),            /*单位一数量                             */
rvv83       varchar2(4),             /*单位二                                 */
rvv84       number(20,8),            /*单位二换算率(与采购单位)               */
rvv85       number(15,3),            /*单位二数量                             */
rvv86       varchar2(4),             /*计价单位                               */
rvv87       number(15,3),            /*计价数量                               */
rvv39t      number(20,6),            /*含税金额 (注意:原rvv39定义为           */
rvv38t      number(20,6),            /*含税单价                               */
rvv930      varchar2(10),            /*成本中心                               */
rvv88       number(15,3),            /*暂估数量                               */
rvvud01     varchar2(255),           /*自订字段-Textedit                      */
rvvud02     varchar2(40),            /*送货单号                               */
rvvud03     varchar2(40),            /*项目编号                               */
rvvud04     varchar2(40),            /*自订字段-文字                          */
rvvud05     varchar2(40),            /*自订字段-文字                          */
rvvud06     varchar2(40),            /*自订字段-文字                          */
rvvud07     number(15,3),            /*线速                                   */
rvvud08     number(15,3),            /*自订字段-数值                          */
rvvud09     number(15,3),            /*自订字段-数值                          */
rvvud10     number(10),              /*自订字段-整数                          */
rvvud11     number(10),              /*自订字段-整数                          */
rvvud12     number(10),              /*自订字段-整数                          */
rvvud13     date,                    /*生成日期                               */
rvvud14     date,                    /*自订字段-日期                          */
rvvud15     date,                    /*自订字段-日期                          */
rvv89       varchar2(1) DEFAULT 'N', /*VMI退货否                              */
rvv10       varchar2(1) DEFAULT ' ' NOT NULL, /*取价类型 1-搭赠,2-促销协议,3- */
                                     /*取价类型 1-搭赠,2-促销协议,3-采购协议 4-其他*/
rvv11       varchar2(20),            /*价格来源                               */
rvv12       varchar2(20),            /*来源单号                               */
rvv13       number(5),               /*来源项次                               */
rvvplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rvvlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rvv919      varchar2(50),            /*计画批号                               */
rvv22       varchar2(20),            /*发票编号                               */
rvv45       number(5),               /*检验批号                               */
rvv46       varchar2(10),            /*QC判定结果编码                         */
rvv47       number(5)                /*QC判定结果项次                         */
);

create        index rvv_04 on rvv_file (rvv09);
create        index rvv_02 on rvv_file (rvv04,rvv05);
create        index rvv_03 on rvv_file (rvv36,rvv37);
alter table rvv_file add  constraint rvv_pk primary key  (rvv01,rvv02) enable validate;
grant select on rvv_file to tiptopgp;
grant update on rvv_file to tiptopgp;
grant delete on rvv_file to tiptopgp;
grant insert on rvv_file to tiptopgp;
grant index on rvv_file to public;
grant select on rvv_file to ods;
