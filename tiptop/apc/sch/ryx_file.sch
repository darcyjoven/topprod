/*
================================================================================
檔案代號:ryx_file
檔案名稱:名称多种语言对照档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table ryx_file
(
ryx01       varchar2(15) DEFAULT ' ' NOT NULL, /*档案编号*/
ryx02       varchar2(20) DEFAULT ' ' NOT NULL, /*字段编号*/
ryx03       varchar2(255) DEFAULT ' ' NOT NULL, /*KEY值序列*/
ryx04       varchar2(1) DEFAULT ' ' NOT NULL, /*语言别*/
ryx05       varchar2(100)            /*各语言别下的名称                       */
);

alter table ryx_file add  constraint ryx_pk primary key  (ryx01,ryx02,ryx03,ryx04) enable validate;
grant select on ryx_file to tiptopgp;
grant update on ryx_file to tiptopgp;
grant delete on ryx_file to tiptopgp;
grant insert on ryx_file to tiptopgp;
grant index on ryx_file to public;
grant select on ryx_file to ods;
