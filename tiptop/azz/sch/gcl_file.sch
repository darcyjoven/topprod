/*
================================================================================
檔案代號:gcl_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gcl_file
(
gcl01       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
gcl02       varchar2(20) DEFAULT ' ' NOT NULL, /*程序代码*/
gcl03       varchar2(10) DEFAULT ' ' NOT NULL, /*制表人*/
gcl04       varchar2(10) DEFAULT ' ' NOT NULL, /*权限类型*/
gcl05       date DEFAULT sysdate NOT NULL, /*建立日期*/
gcl06       varchar2(255) DEFAULT ' ' NOT NULL,
gcl07       varchar2(1) DEFAULT ' ' NOT NULL, /*有效否*/
gcl08       varchar2(10) DEFAULT ' ' NOT NULL /*建立时间*/
);

alter table gcl_file add  constraint gcl_pk primary key  (gcl01,gcl02,gcl03,gcl05,gcl08) enable validate;
grant select on gcl_file to tiptopgp;
grant update on gcl_file to tiptopgp;
grant delete on gcl_file to tiptopgp;
grant insert on gcl_file to tiptopgp;
grant index on gcl_file to public;
grant select on gcl_file to ods;
