/*
================================================================================
檔案代號:gdy_file
檔案名稱:GR历史报表留存配置文件
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gdy_file
(
gdy01       varchar2(20) DEFAULT ' ' NOT NULL, /*程序编号*/
gdy02       varchar2(1) DEFAULT ' ' NOT NULL,
gdy03       varchar2(10) DEFAULT ' ' NOT NULL,
gdy04       varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
gdy05       varchar2(1) DEFAULT ' ' NOT NULL
);

alter table gdy_file add  constraint gdy_pk primary key  (gdy01,gdy02,gdy03) enable validate;
grant select on gdy_file to tiptopgp;
grant update on gdy_file to tiptopgp;
grant delete on gdy_file to tiptopgp;
grant insert on gdy_file to tiptopgp;
grant index on gdy_file to public;
grant select on gdy_file to ods;
