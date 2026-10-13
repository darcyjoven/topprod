/*
================================================================================
檔案代號:xsh_file
檔案名稱:出貨回報
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table xsh_file
(
xsh01       varchar2(20) DEFAULT ' ' NOT NULL, /*回报代号*/
xsh02       date,                    /*开始日期                               */
xsh03       date,                    /*截止日期                               */
xsh04       varchar2(10),            /*上级组织                               */
xsh05       varchar2(1) DEFAULT ' ' NOT NULL, /*状态*/
xsh99       varchar2(10) DEFAULT ' ' NOT NULL /*经销商*/
);

alter table xsh_file add  constraint xsh_pk primary key  (xsh01) enable validate;
grant select on xsh_file to tiptopgp;
grant update on xsh_file to tiptopgp;
grant delete on xsh_file to tiptopgp;
grant insert on xsh_file to tiptopgp;
grant index on xsh_file to public;
grant select on xsh_file to ods;
