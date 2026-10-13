/*
================================================================================
檔案代號:vmh_file
檔案名稱:APS供给法则维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vmh_file
(
vmh01       varchar2(60) DEFAULT ' ' NOT NULL, /*供给法则编号*/
vmh02       number(9) DEFAULT '0' NOT NULL, /*供给类型*/
vmh03       varchar2(10) DEFAULT ' ' NOT NULL, /*仓库编号*/
vmh04       varchar2(10) DEFAULT ' ' NOT NULL, /*库位编号*/
vmh05       number(5)                /*优先顺序                               */
);

alter table vmh_file add  constraint vmh_pk primary key  (vmh01,vmh02,vmh03,vmh04) enable validate;
grant select on vmh_file to tiptopgp;
grant update on vmh_file to tiptopgp;
grant delete on vmh_file to tiptopgp;
grant insert on vmh_file to tiptopgp;
grant index on vmh_file to public;
grant select on vmh_file to ods;
