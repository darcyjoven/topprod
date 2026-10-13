/*
================================================================================
檔案代號:gbu_file
檔案名稱:主键关联纪录文件
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gbu_file
(
gbu01       varchar2(20) DEFAULT ' ' NOT NULL, /*主键Primary Key 字段名称*/
gbu02       varchar2(20) DEFAULT ' ' NOT NULL, /*主键Primary Key Table名称*/
gbu03       varchar2(20),
gbu04       varchar2(40),
gbu05       varchar2(20),
gbu06       varchar2(1)              /*no use                                 */
);

alter table gbu_file add  constraint gbu_pk primary key  (gbu01) enable validate;
grant select on gbu_file to tiptopgp;
grant update on gbu_file to tiptopgp;
grant delete on gbu_file to tiptopgp;
grant insert on gbu_file to tiptopgp;
grant index on gbu_file to public;
grant select on gbu_file to ods;
