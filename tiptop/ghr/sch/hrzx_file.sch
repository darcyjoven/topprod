/*
================================================================================
檔案代號:hrzx_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrzx_file
(
hrzx01      varchar2(10) NOT NULL,
hrzx02      varchar2(10),
hrzx03      varchar2(255),
hrzxuser    varchar2(10),
hrzxgrup    varchar2(10),
hrzxmodu    varchar2(10),
hrzxdate    date,
hrzxorig    varchar2(10),
hrzxoriu    varchar2(10),
hrzx04      varchar2(1),
hrzx05      varchar2(1)
);

alter table hrzx_file add  constraint tpc_hrzx_pk primary key  (hrzx01) enable validate;
grant select on hrzx_file to tiptopgp;
grant update on hrzx_file to tiptopgp;
grant delete on hrzx_file to tiptopgp;
grant insert on hrzx_file to tiptopgp;
grant index on hrzx_file to public;
grant select on hrzx_file to ods;
