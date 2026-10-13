/*
================================================================================
檔案代號:hrceb_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrceb_file
(
hrceb01     number(15) NOT NULL,
hrceb02     number(5) NOT NULL,
hrceb03     varchar2(10) NOT NULL,
hrceb04     varchar2(10),
hrceb05     varchar2(20),
hrceb06     varchar2(255)
);

alter table hrceb_file add  constraint tpc_hrceb_pk primary key  (hrceb01,hrceb02) enable validate;
grant select on hrceb_file to tiptopgp;
grant update on hrceb_file to tiptopgp;
grant delete on hrceb_file to tiptopgp;
grant insert on hrceb_file to tiptopgp;
grant index on hrceb_file to public;
grant select on hrceb_file to ods;
