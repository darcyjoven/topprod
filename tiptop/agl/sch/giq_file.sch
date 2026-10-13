/*
================================================================================
檔案代號:giq_file
檔案名稱:现金流量群组表(总账)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table giq_file
(
giq01       varchar2(10) DEFAULT ' ' NOT NULL, /*群组代码*/
giq02       varchar2(80),            /*说明                                   */
giq03       varchar2(1) DEFAULT ' ' NOT NULL, /*变动分类*/
giq04       number(5)                /*行序                                   */
);

alter table giq_file add  constraint giq_pk primary key  (giq01) enable validate;
grant select on giq_file to tiptopgp;
grant update on giq_file to tiptopgp;
grant delete on giq_file to tiptopgp;
grant insert on giq_file to tiptopgp;
grant index on giq_file to public;
grant select on giq_file to ods;
