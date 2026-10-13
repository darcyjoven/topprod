/*
================================================================================
檔案代號:gcx_file
檔案名稱:报表签核栏维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gcx_file
(
gcx01       varchar2(20) DEFAULT ' ' NOT NULL, /*程序编号*/
gcx02       varchar2(5) NOT NULL,    /*单别编号                               */
gcx03       varchar2(5) DEFAULT ' ' NOT NULL /*语言别*/
);

alter table gcx_file add  constraint gcx_pk primary key  (gcx01,gcx02) enable validate;
grant select on gcx_file to tiptopgp;
grant update on gcx_file to tiptopgp;
grant delete on gcx_file to tiptopgp;
grant insert on gcx_file to tiptopgp;
grant index on gcx_file to public;
grant select on gcx_file to ods;
