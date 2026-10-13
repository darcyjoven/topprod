/*
================================================================================
檔案代號:rys_file
檔案名稱:POS权限模块档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table rys_file
(
rys01       varchar2(10) DEFAULT ' ' NOT NULL, /*权限编号*/
rys02       varchar2(40) DEFAULT ' ' NOT NULL, /*模块编号*/
rys03       varchar2(1) DEFAULT ' ' NOT NULL, /*是否可用*/
rysacti     varchar2(1) DEFAULT ' ' NOT NULL /*有效否*/
);

alter table rys_file add  constraint rys_pk primary key  (rys01,rys02) enable validate;
grant select on rys_file to tiptopgp;
grant update on rys_file to tiptopgp;
grant delete on rys_file to tiptopgp;
grant insert on rys_file to tiptopgp;
grant index on rys_file to public;
grant select on rys_file to ods;
