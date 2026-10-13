/*
================================================================================
檔案代號:hisc_file
檔案名稱:历史资料备份流程设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table hisc_file
(
hisc01      varchar2(30) DEFAULT ' ' NOT NULL, /*流程名*/
hisc02      varchar2(255),           /*流程说明                               */
hisc03      varchar2(80) DEFAULT ' ' NOT NULL, /*基准TABLE*/
hisc04      varchar2(80),            /*条件字段                               */
hisc05      varchar2(255),           /*附加条件                               */
hisctype    varchar2(30) DEFAULT ' ' NOT NULL, /*备份方案*/
hisc06      varchar2(100),           /*其它条件                               */
hisc07      varchar2(100)            /*其它条件                               */
);

grant select on hisc_file to tiptopgp;
grant update on hisc_file to tiptopgp;
grant delete on hisc_file to tiptopgp;
grant insert on hisc_file to tiptopgp;
grant index on hisc_file to public;
grant select on hisc_file to ods;
