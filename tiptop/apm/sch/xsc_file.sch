/*
================================================================================
檔案代號:xsc_file
檔案名稱:订单底稿明细
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table xsc_file
(
xsc01       varchar2(20) DEFAULT ' ' NOT NULL, /*底稿单号*/
xsc02       number(5) DEFAULT '0' NOT NULL, /*项次*/
xsc03       varchar2(40),            /*产品编号                               */
xsc04       varchar2(4),             /*销售单位                               */
xsc05       number(15,3) DEFAULT '0' NOT NULL, /*数量*/
xsc06       number(20,6) DEFAULT '0' NOT NULL, /*单价*/
xsc07       number(20,6) DEFAULT '0' NOT NULL, /*税前金额*/
xsc07t      number(20,6) DEFAULT '0' NOT NULL, /*含税金额*/
xsc08       date,                    /*预计交货日                             */
xsc09       number(15,3) DEFAULT '0' NOT NULL
);

alter table xsc_file add  constraint xsc_pk primary key  (xsc01,xsc02) enable validate;
grant select on xsc_file to tiptopgp;
grant update on xsc_file to tiptopgp;
grant delete on xsc_file to tiptopgp;
grant insert on xsc_file to tiptopgp;
grant index on xsc_file to public;
grant select on xsc_file to ods;
