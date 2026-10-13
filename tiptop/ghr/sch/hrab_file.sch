/*
================================================================================
檔案代號:hrab_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrab_file
(
hrab01      varchar2(10) NOT NULL,
hrab02      varchar2(2) NOT NULL,
hrab03      varchar2(20),
hrab04      varchar2(20),
hrab05      varchar2(255),
hrab06      varchar2(20),
hrab07      varchar2(20),
hrab08      varchar2(20),
hrab09      varchar2(255),
hrab10      varchar2(255),
hrab11      date,
hrab12      date,
hrabacti    varchar2(1),
hrabuser    varchar2(10),
hrabgrup    varchar2(10),
hrabmodu    varchar2(10),
hrabdate    date,
hraborig    varchar2(10),
hraboriu    varchar2(10)
);

alter table hrab_file add  constraint tpc_hrab_pk primary key  (hrab01,hrab02) enable validate;
grant select on hrab_file to tiptopgp;
grant update on hrab_file to tiptopgp;
grant delete on hrab_file to tiptopgp;
grant insert on hrab_file to tiptopgp;
grant index on hrab_file to public;
grant select on hrab_file to ods;
