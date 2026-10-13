/*
================================================================================
檔案代號:aax_file
檔案名稱:账别部门管制档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aax_file
(
aax01       varchar2(5) NOT NULL,
aax02       varchar2(10) NOT NULL,
aax03       varchar2(1)
);

alter table aax_file add  constraint aax_pk primary key  (aax01,aax02) enable validate;
grant select on aax_file to tiptopgp;
grant update on aax_file to tiptopgp;
grant delete on aax_file to tiptopgp;
grant insert on aax_file to tiptopgp;
grant index on aax_file to public;
grant select on aax_file to ods;
