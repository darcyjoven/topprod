/*
================================================================================
檔案代號:pmlslk_file
檔案名稱:SLK请购单款号单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pmlslk_file
(
pmlslk01    varchar2(20) DEFAULT ' ' NOT NULL, /*请购单号*/
pmlslk02    number(5) DEFAULT '0' NOT NULL, /*项次*/
pmlslk04    varchar2(40),            /*料号                                   */
pmlslk041   varchar2(120),           /*品名规格                               */
pmlslk07    varchar2(4),             /*请购单位                               */
pmlslk08    varchar2(4),             /*库存单位                               */
pmlslk190   varchar2(1) DEFAULT ' ' NOT NULL, /*统购否*/
pmlslk191   varchar2(10),
pmlslk192   varchar2(1) DEFAULT ' ' NOT NULL,
pmlslk20    number(15,3) DEFAULT '0' NOT NULL, /*请购量*/
pmlslk21    number(15,3) DEFAULT '0' NOT NULL,
pmlslk24    varchar2(20),            /*来源单号                               */
pmlslk25    number(5),               /*来源项次                               */
pmlslk30    number(20,6) DEFAULT '0' NOT NULL,
pmlslk31    number(20,6) DEFAULT '0' NOT NULL, /*税前单价*/
pmlslk31t   number(20,6) DEFAULT '0' NOT NULL, /*含税单价*/
pmlslk33    date,                    /*交货日期                               */
pmlslk34    date,                    /*到厂日期                               */
pmlslk35    date,                    /*到库日期                               */
pmlslk44    number(20,6) DEFAULT '0' NOT NULL,
pmlslk50    varchar2(1) DEFAULT '1' NOT NULL,
pmlslk88    number(20,6) DEFAULT '0' NOT NULL, /*税前金额*/
pmlslk88t   number(20,6) DEFAULT '0' NOT NULL, /*含税金额*/
pmlslk90    varchar2(10),            /*费用原因                               */
pmlslk930   varchar2(10),            /*成本中心                               */
pmlslklegal varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
pmlslkplant varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table pmlslk_file add  constraint pmlslk_pk primary key  (pmlslk01,pmlslk02) enable validate;
grant select on pmlslk_file to tiptopgp;
grant update on pmlslk_file to tiptopgp;
grant delete on pmlslk_file to tiptopgp;
grant insert on pmlslk_file to tiptopgp;
grant index on pmlslk_file to public;
grant select on pmlslk_file to ods;
