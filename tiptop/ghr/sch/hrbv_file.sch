/*
================================================================================
檔案代號:hrbv_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbv_file
(
hrbv01      varchar2(50) NOT NULL,
hrbv02      varchar2(100),
hrbv03      varchar2(50),
hrbv04      varchar2(1),
hrbv05      varchar2(50),
hrbv06      varchar2(100),
hrbv07      varchar2(50),
hrbv08      varchar2(50),
hrbv09      varchar2(50),
hrbv10      varchar2(50),
hrbv11      varchar2(50),
hrbv12      varchar2(255),
hrbvacti    varchar2(1),
hrbvud01    varchar2(255),
hrbvud02    varchar2(40),
hrbvud03    varchar2(40),
hrbvud04    varchar2(40),
hrbvud05    varchar2(40),
hrbvud06    varchar2(40),
hrbvud07    number(15,3),
hrbvud08    number(15,3),
hrbvud09    number(15,3),
hrbvud10    number(10),
hrbvud11    number(10),
hrbvud12    number(10),
hrbvud13    date,
hrbvud14    date,
hrbvud15    date,
hrbvuser    varchar2(10),
hrbvgrup    varchar2(10),
hrbvmodu    varchar2(10),
hrbvorig    varchar2(10),
hrbvdate    date,
hrbvoriu    varchar2(10)
);

alter table hrbv_file add  constraint tpc_hrbv_pk primary key  (hrbv01) enable validate;
grant select on hrbv_file to tiptopgp;
grant update on hrbv_file to tiptopgp;
grant delete on hrbv_file to tiptopgp;
grant insert on hrbv_file to tiptopgp;
grant index on hrbv_file to public;
grant select on hrbv_file to ods;
