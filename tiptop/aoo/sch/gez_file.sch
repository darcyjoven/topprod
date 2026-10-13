/*
================================================================================
檔案代號:gez_file
檔案名稱:抛转缺省资料维护(资料中心)
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gez_file
(
gez01       varchar2(10) DEFAULT ' ' NOT NULL, /*资料中心代码*/
gez02       varchar2(1) DEFAULT ' ' NOT NULL, /*资料类型*/
gez03       varchar2(10) DEFAULT ' ' NOT NULL, /*抛转营运中心*/
gez04       varchar2(20) DEFAULT ' ' NOT NULL, /*字段编号*/
gez05       varchar2(255)            /*抛转字段值                             */
);

alter table gez_file add  constraint gez_pk primary key  (gez01,gez02,gez03,gez04) enable validate;
grant select on gez_file to tiptopgp;
grant update on gez_file to tiptopgp;
grant delete on gez_file to tiptopgp;
grant insert on gez_file to tiptopgp;
grant index on gez_file to public;
grant select on gez_file to ods;
