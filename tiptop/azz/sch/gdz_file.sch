/*
================================================================================
檔案代號:gdz_file
檔案名稱:个资字段种类叙述
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gdz_file
(
gdz01       varchar2(30) DEFAULT ' ' NOT NULL,
gdz02       varchar2(100)
);

alter table gdz_file add  constraint gdz_pk primary key  (gdz01) enable validate;
grant select on gdz_file to tiptopgp;
grant update on gdz_file to tiptopgp;
grant delete on gdz_file to tiptopgp;
grant insert on gdz_file to tiptopgp;
grant index on gdz_file to public;
grant select on gdz_file to ods;
