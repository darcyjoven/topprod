/*
================================================================================
檔案代號:vmw_file
檔案名稱:aps 製令/工單維護檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vmw_file
(
vmw01       varchar2(20) DEFAULT ' ' NOT NULL,
vmw02       varchar2(60),
vmw25       number(1),               /*是否受供给法则限制, 0;否 1:是          */
vmw26       number(1),               /*MO多余量需求建立模式 0：多余           */
vmwlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vmwplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vmw_file add  constraint vmw_pk primary key  (vmw01) enable validate;
grant select on vmw_file to tiptopgp;
grant update on vmw_file to tiptopgp;
grant delete on vmw_file to tiptopgp;
grant insert on vmw_file to tiptopgp;
grant index on vmw_file to public;
grant select on vmw_file to ods;
