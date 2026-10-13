/*
================================================================================
檔案代號:vme_file
檔案名稱:APS资源群组维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vme_file
(
vme01       varchar2(60) DEFAULT ' ' NOT NULL, /*资源群组编号*/
vme02       varchar2(10) DEFAULT ' ' NOT NULL /*资源编号*/
);

alter table vme_file add  constraint vme_pk primary key  (vme01,vme02) enable validate;
grant select on vme_file to tiptopgp;
grant update on vme_file to tiptopgp;
grant delete on vme_file to tiptopgp;
grant insert on vme_file to tiptopgp;
grant index on vme_file to public;
grant select on vme_file to ods;
