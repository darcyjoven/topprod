/*
================================================================================
檔案代號:giqq_file
檔案名稱:现金流量群组表(合并)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table giqq_file
(
giqq01      varchar2(10) DEFAULT ' ' NOT NULL, /*群组代码*/
giqq02      varchar2(80),            /*说明                                   */
giqq03      varchar2(1) DEFAULT ' ' NOT NULL, /*变动分类*/
giqq04      number(5)                /*行序                                   */
);

alter table giqq_file add  constraint giqq_pk primary key  (giqq01) enable validate;
grant select on giqq_file to tiptopgp;
grant update on giqq_file to tiptopgp;
grant delete on giqq_file to tiptopgp;
grant insert on giqq_file to tiptopgp;
grant index on giqq_file to public;
grant select on giqq_file to ods;
