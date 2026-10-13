/*
================================================================================
檔案代號:pmnslk_file
檔案名稱:SLK采购单款号单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pmnslk_file
(
pmnslk01    varchar2(20) DEFAULT ' ' NOT NULL, /*采购单号*/
pmnslk02    number(5) DEFAULT '0' NOT NULL, /*项次*/
pmnslk04    varchar2(40),            /*料件编号                               */
pmnslk041   varchar2(120),           /*品名规格                               */
pmnslk07    varchar2(4),             /*采购单位                               */
pmnslk08    varchar2(4),             /*库存单位                               */
pmnslk20    number(15,3) DEFAULT '0' NOT NULL, /*采购量*/
pmnslk24    varchar2(20),            /*请购单号                               */
pmnslk25    number(5),               /*请购单号项次                           */
pmnslk30    number(20,6) DEFAULT '0' NOT NULL, /*标准价格*/
pmnslk31    number(20,6) DEFAULT '0' NOT NULL, /*单价*/
pmnslk31t   number(20,6) DEFAULT '0' NOT NULL, /*含税单价*/
pmnslk33    date,                    /*原始交货日期                           */
pmnslk34    date,                    /*原始到货日期                           */
pmnslk35    date,                    /*原始到库日期                           */
pmnslk44    number(20,6) DEFAULT '0' NOT NULL, /*本币单价*/
pmnslk52    varchar2(10),            /*仓库                                   */
pmnslk54    varchar2(10),            /*库位                                   */
pmnslk56    varchar2(24),            /*批号                                   */
pmnslk73    varchar2(1) DEFAULT ' ' NOT NULL, /*取价类型*/
pmnslk74    varchar2(16),            /*价格来源                               */
pmnslk88    number(20,6) DEFAULT '0' NOT NULL, /*税前金额*/
pmnslk88t   number(20,6) DEFAULT '0' NOT NULL, /*含税金额*/
pmnslklegal varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
pmnslkplant varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
pmnslk68    varchar2(20),            /*Blanket PO 单号                        */
pmnslk69    number(5)                /*Blanket PO 项次                        */
);

alter table pmnslk_file add  constraint pmnslk_pk primary key  (pmnslk01,pmnslk02) enable validate;
grant select on pmnslk_file to tiptopgp;
grant update on pmnslk_file to tiptopgp;
grant delete on pmnslk_file to tiptopgp;
grant insert on pmnslk_file to tiptopgp;
grant index on pmnslk_file to public;
grant select on pmnslk_file to ods;
