/*
================================================================================
檔案代號:odv_file
檔案名稱:配比产品维护作业单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table odv_file
(
odv01       varchar2(10) DEFAULT ' ' NOT NULL, /*配比版本*/
odv02       varchar2(10) DEFAULT ' ' NOT NULL, /*尺寸*/
odv03       number(15,3) DEFAULT '0' NOT NULL /*配比%*/
);

alter table odv_file add  constraint odv_pk primary key  (odv01,odv02) enable validate;
grant select on odv_file to tiptopgp;
grant update on odv_file to tiptopgp;
grant delete on odv_file to tiptopgp;
grant insert on odv_file to tiptopgp;
grant index on odv_file to public;
grant select on odv_file to ods;
