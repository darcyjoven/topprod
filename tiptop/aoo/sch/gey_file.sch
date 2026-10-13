/*
================================================================================
檔案代號:gey_file
檔案名稱:资料控管维护档案(资料中心)
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gey_file
(
gey01       varchar2(1) DEFAULT ' ' NOT NULL, /*资料类型*/
gey02       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
gey03       varchar2(20) DEFAULT ' ' NOT NULL, /*字段编号*/
gey04       varchar2(2),             /*允许新增的条件                         */
gey05       varchar2(255)            /*允许新增值                             */
);

alter table gey_file add  constraint gey_pk primary key  (gey01,gey02,gey03) enable validate;
grant select on gey_file to tiptopgp;
grant update on gey_file to tiptopgp;
grant delete on gey_file to tiptopgp;
grant insert on gey_file to tiptopgp;
grant index on gey_file to public;
grant select on gey_file to ods;
