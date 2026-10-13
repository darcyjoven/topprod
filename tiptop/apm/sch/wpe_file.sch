/*
================================================================================
檔案代號:wpe_file
檔案名稱:电子采购交货档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table wpe_file
(
wpe01       varchar2(15) DEFAULT ' ' NOT NULL, /*电子交货序号*/
wpe02       date,                    /*交货日期                               */
wpe03       varchar2(10),            /*厂商编号                               */
wpe04       varchar2(20),            /*采购单号                               */
wpe05       number(5),               /*项次                                   */
wpe06       number(15,3) DEFAULT '0' NOT NULL, /*交货数量*/
wpe07       varchar2(1) DEFAULT 'N' NOT NULL, /*已抛转*/
wpe08       varchar2(10)             /*来源工厂                               */
);

alter table wpe_file add  constraint wpe_pk primary key  (wpe01) enable validate;
grant select on wpe_file to tiptopgp;
grant update on wpe_file to tiptopgp;
grant delete on wpe_file to tiptopgp;
grant insert on wpe_file to tiptopgp;
grant index on wpe_file to public;
grant select on wpe_file to ods;
