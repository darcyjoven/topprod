/*
================================================================================
檔案代號:awa_file
檔案名稱:科目转换对照档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table awa_file
(
awa01       varchar2(24) NOT NULL,   /*原科目                                 */
awa02       varchar2(24)             /*新科目                                 */
);

alter table awa_file add  constraint awa_pk primary key  (awa01) enable validate;
grant select on awa_file to tiptopgp;
grant update on awa_file to tiptopgp;
grant delete on awa_file to tiptopgp;
grant insert on awa_file to tiptopgp;
grant index on awa_file to public;
grant select on awa_file to ods;
