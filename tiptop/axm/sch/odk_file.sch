/*
================================================================================
檔案代號:odk_file
檔案名稱:关联产品档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table odk_file
(
odk01       varchar2(40) DEFAULT ' ' NOT NULL, /*主料号*/
odk02       varchar2(40) DEFAULT ' ' NOT NULL /*关联料号*/
);

alter table odk_file add  constraint odk_pk primary key  (odk01,odk02) enable validate;
grant select on odk_file to tiptopgp;
grant update on odk_file to tiptopgp;
grant delete on odk_file to tiptopgp;
grant insert on odk_file to tiptopgp;
grant index on odk_file to public;
grant select on odk_file to ods;
