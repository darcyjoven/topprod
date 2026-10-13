/*
================================================================================
檔案代號:bol_file
檔案名稱:部位基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bol_file
(
bol01       varchar2(10) DEFAULT ' ' NOT NULL, /*部位代码*/
bol02       varchar2(80) DEFAULT ' ' NOT NULL, /*部位说明*/
bol03       varchar2(80) DEFAULT ' ' NOT NULL, /*英文说明*/
bol04       varchar2(1) DEFAULT ' ' NOT NULL, /*部位性质 1-横 2-直*/
bolacti     varchar2(1) DEFAULT ' ' NOT NULL /*有效否*/
);

alter table bol_file add  constraint bol_pk primary key  (bol01) enable validate;
grant select on bol_file to tiptopgp;
grant update on bol_file to tiptopgp;
grant delete on bol_file to tiptopgp;
grant insert on bol_file to tiptopgp;
grant index on bol_file to public;
grant select on bol_file to ods;
