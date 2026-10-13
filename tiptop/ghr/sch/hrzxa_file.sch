/*
================================================================================
檔案代號:hrzxa_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrzxa_file
(
hrzxa01     varchar2(10) NOT NULL,
hrzxa02     number(5) NOT NULL,
hrzxa03     varchar2(1),
hrzxa04     varchar2(20),
hrzxa05     varchar2(1),
hrzxa06     varchar2(255)
);

alter table hrzxa_file add  constraint tpc_hrzxa_pk primary key  (hrzxa01,hrzxa02) enable validate;
grant select on hrzxa_file to tiptopgp;
grant update on hrzxa_file to tiptopgp;
grant delete on hrzxa_file to tiptopgp;
grant insert on hrzxa_file to tiptopgp;
grant index on hrzxa_file to public;
grant select on hrzxa_file to ods;
