/*
================================================================================
檔案代號:lto_file
檔案名稱:预算维护作业资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lto_file
(
lto01       varchar2(10),            /*no use 原门店编号                      */
lto02       varchar2(4) DEFAULT ' ' NOT NULL, /*年份*/
lto03       varchar2(4) DEFAULT ' ' NOT NULL, /*月份*/
lto04       number(20,2) DEFAULT '0' NOT NULL, /*预算金额*/
ltolegal    varchar2(10) NOT NULL,   /*所属法人                               */
ltostore    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table lto_file add  constraint lto_pk primary key  (ltostore,lto02,lto03) enable validate;
grant select on lto_file to tiptopgp;
grant update on lto_file to tiptopgp;
grant delete on lto_file to tiptopgp;
grant insert on lto_file to tiptopgp;
grant index on lto_file to public;
grant select on lto_file to ods;
