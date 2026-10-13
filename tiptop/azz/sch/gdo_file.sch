/*
================================================================================
檔案代號:gdo_file
檔案名稱:纸张格式基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gdo_file
(
gdo01       varchar2(10) DEFAULT ' ' NOT NULL,
gdo02       varchar2(100),
gdo03       number(15,3) DEFAULT '0' NOT NULL,
gdo04       number(15,3) DEFAULT '0' NOT NULL,
gdo05       varchar2(1) DEFAULT ' ' NOT NULL,
gdo06       varchar2(100)
);

alter table gdo_file add  constraint gdo_pk primary key  (gdo01) enable validate;
grant select on gdo_file to tiptopgp;
grant update on gdo_file to tiptopgp;
grant delete on gdo_file to tiptopgp;
grant insert on gdo_file to tiptopgp;
grant index on gdo_file to public;
grant select on gdo_file to ods;
