/*
================================================================================
檔案代號:hisd_file
檔案名稱:历史资料备份流程设定关联档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table hisd_file
(
hisd01      varchar2(30) DEFAULT ' ' NOT NULL, /*对应流程名*/
hisd02      varchar2(80) DEFAULT ' ' NOT NULL, /*TABLE*/
hisd03      varchar2(80) DEFAULT ' ' NOT NULL, /*关联TABLE*/
hisd04      varchar2(40) DEFAULT ' ' NOT NULL, /*关联条件*/
hisd05      varchar2(255),           /*附加条件                               */
hisdtype    varchar2(30) DEFAULT ' ' NOT NULL, /*备份方案*/
hisd06      varchar2(100),           /*其它条件                               */
hisd07      varchar2(100)            /*其它条件                               */
);

grant select on hisd_file to tiptopgp;
grant update on hisd_file to tiptopgp;
grant delete on hisd_file to tiptopgp;
grant insert on hisd_file to tiptopgp;
grant index on hisd_file to public;
grant select on hisd_file to ods;
