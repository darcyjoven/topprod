/*
================================================================================
檔案代號:wsu_file
檔案名稱:他系统整合站台设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wsu_file
(
wsu01       varchar2(20) DEFAULT ' ' NOT NULL, /*他系统代码*/
wsu02       varchar2(10) DEFAULT ' ' NOT NULL, /*对应营运中心编号*/
wsu03       varchar2(20) DEFAULT ' ' NOT NULL, /*他系统站台 ip 地址*/
wsu04       varchar2(255) DEFAULT ' ' NOT NULL, /*他系统 soap services 连接网址*/
wsu05       varchar2(20) DEFAULT ' ' NOT NULL /*他系统站台名称*/
);

alter table wsu_file add  constraint wsu_pk primary key  (wsu01,wsu02) enable validate;
grant select on wsu_file to tiptopgp;
grant update on wsu_file to tiptopgp;
grant delete on wsu_file to tiptopgp;
grant insert on wsu_file to tiptopgp;
grant index on wsu_file to public;
grant select on wsu_file to ods;
