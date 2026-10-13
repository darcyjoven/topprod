/*
================================================================================
檔案代號:wst_file
檔案名稱:整合服务 ERP 与他系统间栏位转换单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wst_file
(
wst01       varchar2(40) DEFAULT ' ' NOT NULL, /*服务代码*/
wst02       varchar2(1) DEFAULT ' ' NOT NULL, /*存取模式*/
wst03       varchar2(20) DEFAULT ' ' NOT NULL, /*他系统代码*/
wst04       varchar2(20) DEFAULT ' ' NOT NULL, /*erp 字段名称*/
wst05       varchar2(30) DEFAULT ' ' NOT NULL, /*erp 字段内容*/
wst06       varchar2(30) DEFAULT ' ' NOT NULL /*他系统转换值*/
);

alter table wst_file add  constraint wst_pk primary key  (wst01,wst02,wst03,wst04,wst05) enable validate;
grant select on wst_file to tiptopgp;
grant update on wst_file to tiptopgp;
grant delete on wst_file to tiptopgp;
grant insert on wst_file to tiptopgp;
grant index on wst_file to public;
grant select on wst_file to ods;
