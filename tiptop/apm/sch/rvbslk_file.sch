/*
================================================================================
檔案代號:rvbslk_file
檔案名稱:SLK收货单款号单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rvbslk_file
(
rvbslk01    varchar2(20) DEFAULT ' ' NOT NULL, /*收货单号*/
rvbslk02    number(5) DEFAULT '0' NOT NULL, /*收货单项次*/
rvbslk03    number(5),               /*采购单项次                             */
rvbslk04    varchar2(20),            /*采购单编号                             */
rvbslk05    varchar2(40),            /*料件编号                               */
rvbslk051   varchar2(120),           /*品名规格                               */
rvbslk07    number(15,3) DEFAULT '0' NOT NULL, /*实收数量*/
rvbslk10    number(20,6) DEFAULT '0' NOT NULL, /*收料单价*/
rvbslk10t   number(20,6) DEFAULT '0' NOT NULL, /*含税单价*/
rvbslk29    number(15,3) DEFAULT '0' NOT NULL, /*退货量*/
rvbslk30    number(15,3) DEFAULT '0' NOT NULL, /*入库量*/
rvbslk36    varchar2(10),            /*仓库                                   */
rvbslk37    varchar2(10),            /*库位                                   */
rvbslk38    varchar2(24),            /*批号                                   */
rvbslk42    varchar2(1) DEFAULT ' ' NOT NULL, /*取价类型*/
rvbslk43    varchar2(20),            /*价格来源                               */
rvbslk88    number(20,6) DEFAULT '0' NOT NULL, /*税前金额*/
rvbslk88t   number(20,6) DEFAULT '0' NOT NULL, /*含税金额*/
rvbslk90    varchar2(4),             /*收货单位                               */
rvbslk930   varchar2(10),            /*成本中心                               */
rvbslklegal varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
rvbslkplant varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table rvbslk_file add  constraint rvbslk_pk primary key  (rvbslk01,rvbslk02) enable validate;
grant select on rvbslk_file to tiptopgp;
grant update on rvbslk_file to tiptopgp;
grant delete on rvbslk_file to tiptopgp;
grant insert on rvbslk_file to tiptopgp;
grant index on rvbslk_file to public;
grant select on rvbslk_file to ods;
