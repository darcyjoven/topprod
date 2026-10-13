/*
================================================================================
檔案代號:zyy_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:Y
============.========================.==========================================
*/
create table zyy_file
(
zyy01       varchar2(10) DEFAULT ' ' NOT NULL,
zyy02       varchar2(80),
zyy03       varchar2(10) DEFAULT ' ' NOT NULL
);

alter table zyy_file add  constraint zyy_pk primary key  (zyy01,zyy03) enable validate;
grant select on zyy_file to tiptopgp;
grant update on zyy_file to tiptopgp;
grant delete on zyy_file to tiptopgp;
grant insert on zyy_file to tiptopgp;
grant index on zyy_file to public;
grant select on zyy_file to ods;
