/*
================================================================================
檔案代號:vml_file
檔案名稱:APS品项分配法则维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vml_file
(
vml01       varchar2(40) DEFAULT ' ' NOT NULL, /*完成品料号*/
vml02       varchar2(60) DEFAULT ' ' NOT NULL, /*分配法则编号*/
vml03       varchar2(40) DEFAULT ' ' NOT NULL, /*为part_id本身或其下阶料号*/
vml04       varchar2(60) DEFAULT ' ' NOT NULL, /*供给法则编号*/
vml05       number(1)                /*是否视为无供给法则 0：否 1：           */
);

alter table vml_file add  constraint vml_pk primary key  (vml01,vml02,vml03,vml04) enable validate;
grant select on vml_file to tiptopgp;
grant update on vml_file to tiptopgp;
grant delete on vml_file to tiptopgp;
grant insert on vml_file to tiptopgp;
grant index on vml_file to public;
grant select on vml_file to ods;
