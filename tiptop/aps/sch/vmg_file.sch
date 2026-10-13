/*
================================================================================
檔案代號:vmg_file
檔案名稱:APS储位维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vmg_file
(
vmg01       varchar2(10) DEFAULT ' ' NOT NULL, /*仓库编号*/
vmg02       varchar2(10) DEFAULT ' ' NOT NULL, /*库位编号*/
vmg05       number(1),               /*是否客供料                             */
vmg06       number(1)                /*是否受供给法则限制, 0;否 1:是          */
);

alter table vmg_file add  constraint vmg_pk primary key  (vmg01,vmg02) enable validate;
grant select on vmg_file to tiptopgp;
grant update on vmg_file to tiptopgp;
grant delete on vmg_file to tiptopgp;
grant insert on vmg_file to tiptopgp;
grant index on vmg_file to public;
grant select on vmg_file to ods;
