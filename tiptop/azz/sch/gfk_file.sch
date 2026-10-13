/*
================================================================================
檔案代號:gfk_file
檔案名稱:资料归属挡
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gfk_file
(
gfk01       varchar2(15) DEFAULT ' ' NOT NULL, /*表格代码*/
gfk02       varchar2(20) DEFAULT ' ' NOT NULL, /*资料所有者字段*/
gfk03       varchar2(20) DEFAULT ' ' NOT NULL /*资料所有部门栏位*/
);

alter table gfk_file add  constraint gfk_pk primary key  (gfk01) enable validate;
grant select on gfk_file to tiptopgp;
grant update on gfk_file to tiptopgp;
grant delete on gfk_file to tiptopgp;
grant insert on gfk_file to tiptopgp;
grant index on gfk_file to public;
grant select on gfk_file to ods;
