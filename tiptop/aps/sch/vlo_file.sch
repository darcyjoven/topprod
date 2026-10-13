/*
================================================================================
檔案代號:vlo_file
檔案名稱:　
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vlo_file
(
vlo01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
vlo02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
vlo03       varchar2(1) DEFAULT '1' NOT NULL, /*排列顺序*/
vlo04       varchar2(1) DEFAULT '2' NOT NULL, /*排列顺序*/
vlo05       varchar2(1) DEFAULT '3' NOT NULL, /*排列顺序*/
vlo06       varchar2(1) DEFAULT ' ' NOT NULL,
vlolegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vloplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table vlo_file add  constraint vlo_pk primary key  (vlo01,vlo02) enable validate;
grant select on vlo_file to tiptopgp;
grant update on vlo_file to tiptopgp;
grant delete on vlo_file to tiptopgp;
grant insert on vlo_file to tiptopgp;
grant index on vlo_file to public;
grant select on vlo_file to ods;
