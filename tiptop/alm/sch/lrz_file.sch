/*
================================================================================
檔案代號:lrz_file
檔案名稱:券单位金额维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lrz_file
(
lrz01       varchar2(10) DEFAULT ' ' NOT NULL, /*券单位金额编号*/
lrz02       number(20) DEFAULT '0' NOT NULL, /*券单位金额*/
lrz03       varchar2(1) DEFAULT ' ' NOT NULL /*有效否*/
);

alter table lrz_file add  constraint lrz_pk primary key  (lrz01) enable validate;
grant select on lrz_file to tiptopgp;
grant update on lrz_file to tiptopgp;
grant delete on lrz_file to tiptopgp;
grant insert on lrz_file to tiptopgp;
grant index on lrz_file to public;
grant select on lrz_file to ods;
