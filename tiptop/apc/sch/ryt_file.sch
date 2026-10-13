/*
================================================================================
檔案代號:ryt_file
檔案名稱:POS权限功能档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table ryt_file
(
ryt01       varchar2(10) DEFAULT ' ' NOT NULL, /*权限编号*/
ryt02       varchar2(40) DEFAULT ' ' NOT NULL, /*模块编号*/
ryt03       varchar2(40) DEFAULT ' ' NOT NULL, /*功能编号*/
ryt04       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
rytacti     varchar2(1) DEFAULT ' ' NOT NULL /*有效否*/
);

alter table ryt_file add  constraint ryt_pk primary key  (ryt01,ryt02,ryt03) enable validate;
grant select on ryt_file to tiptopgp;
grant update on ryt_file to tiptopgp;
grant delete on ryt_file to tiptopgp;
grant insert on ryt_file to tiptopgp;
grant index on ryt_file to public;
grant select on ryt_file to ods;
