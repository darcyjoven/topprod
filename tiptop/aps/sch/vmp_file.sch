/*
================================================================================
檔案代號:vmp_file
檔案名稱:APS资源群组维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vmp_file
(
vmp01       varchar2(60) DEFAULT ' ' NOT NULL, /*资源群组编号*/
vmp02       varchar2(10) DEFAULT ' ' NOT NULL /*资源编号*/
);

alter table vmp_file add  constraint vmp_pk primary key  (vmp01,vmp02) enable validate;
grant select on vmp_file to tiptopgp;
grant update on vmp_file to tiptopgp;
grant delete on vmp_file to tiptopgp;
grant insert on vmp_file to tiptopgp;
grant index on vmp_file to public;
grant select on vmp_file to ods;
