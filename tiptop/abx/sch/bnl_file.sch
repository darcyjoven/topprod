/*
================================================================================
檔案代號:bnl_file
檔案名稱:委外加工记录卡档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bnl_file
(
bnl01       varchar2(8) NOT NULL     /*委外加工记录卡编号                     */
);

alter table bnl_file add  constraint bnl_pk primary key  (bnl01) enable validate;
grant select on bnl_file to tiptopgp;
grant update on bnl_file to tiptopgp;
grant delete on bnl_file to tiptopgp;
grant insert on bnl_file to tiptopgp;
grant index on bnl_file to public;
grant select on bnl_file to ods;
