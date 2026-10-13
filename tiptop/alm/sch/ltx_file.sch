/*
================================================================================
檔案代號:ltx_file
檔案名稱:公允价值设定作业文件
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ltx_file
(
ltx01       varchar2(4) DEFAULT ' ' NOT NULL, /*年度*/
ltx02       varchar2(2) DEFAULT ' ' NOT NULL, /*月份*/
ltx03       number(20,6) DEFAULT '0' NOT NULL /*公允价值*/
);

alter table ltx_file add  constraint ltx_pk primary key  (ltx01,ltx02) enable validate;
grant select on ltx_file to tiptopgp;
grant update on ltx_file to tiptopgp;
grant delete on ltx_file to tiptopgp;
grant insert on ltx_file to tiptopgp;
grant index on ltx_file to public;
grant select on ltx_file to ods;
