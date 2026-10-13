/*
================================================================================
檔案代號:vmt_file
檔案名稱:APS预测群组冲销维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vmt_file
(
vmt01       varchar2(40) DEFAULT ' ' NOT NULL, /*主冲销料号*/
vmt02       varchar2(40) DEFAULT ' ' NOT NULL /*被冲销料号*/
);

alter table vmt_file add  constraint vmt_pk primary key  (vmt01,vmt02) enable validate;
grant select on vmt_file to tiptopgp;
grant update on vmt_file to tiptopgp;
grant delete on vmt_file to tiptopgp;
grant insert on vmt_file to tiptopgp;
grant index on vmt_file to public;
grant select on vmt_file to ods;
