/*
================================================================================
檔案代號:inc_file
檔案名稱:仓储限定人员档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table inc_file
(
inc01       varchar2(10) DEFAULT ' ' NOT NULL, /*仓库*/
inc02       varchar2(10) DEFAULT ' ' NOT NULL, /*库位*/
inc03       varchar2(10) DEFAULT ' ' NOT NULL /*员工编号*/
);

alter table inc_file add  constraint inc_pk primary key  (inc01,inc02,inc03) enable validate;
grant select on inc_file to tiptopgp;
grant update on inc_file to tiptopgp;
grant delete on inc_file to tiptopgp;
grant insert on inc_file to tiptopgp;
grant index on inc_file to public;
grant select on inc_file to ods;
