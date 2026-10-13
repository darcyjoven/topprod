/*
================================================================================
檔案代號:imt_file
檔案名稱:款式材质成分说明资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table imt_file
(
imt01       varchar2(80) DEFAULT ' ' NOT NULL, /*款式编号*/
imt02       number(10) DEFAULT '0' NOT NULL, /*说明项次*/
imt03       varchar2(80)             /*说明内容                               */
);

alter table imt_file add  constraint imt_pk primary key  (imt01,imt02) enable validate;
grant select on imt_file to tiptopgp;
grant update on imt_file to tiptopgp;
grant delete on imt_file to tiptopgp;
grant insert on imt_file to tiptopgp;
grant index on imt_file to public;
grant select on imt_file to ods;
