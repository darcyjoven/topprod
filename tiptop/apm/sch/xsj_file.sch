/*
================================================================================
檔案代號:xsj_file
檔案名稱:库存开账
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table xsj_file
(
xsj00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据型态 0-库存开帐 1-库存调 */
xsj01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
xsj02       date,                    /*单据日期                               */
xsj03       varchar2(1) DEFAULT ' ' NOT NULL, /*状态*/
xsj99       varchar2(10) DEFAULT ' ' NOT NULL /*经销商*/
);

alter table xsj_file add  constraint xsj_pk primary key  (xsj01) enable validate;
grant select on xsj_file to tiptopgp;
grant update on xsj_file to tiptopgp;
grant delete on xsj_file to tiptopgp;
grant insert on xsj_file to tiptopgp;
grant index on xsj_file to public;
grant select on xsj_file to ods;
