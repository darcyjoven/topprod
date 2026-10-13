/*
================================================================================
檔案代號:vnk_file
檔案名稱:APS工模具群组主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vnk_file
(
vnk01       varchar2(60) NOT NULL,   /*工模具群组编号                         */
vnk02       varchar2(60),            /*工模具群组名称                         */
vnk03       varchar2(60)             /*工模具群组描述                         */
);

alter table vnk_file add  constraint vnk_pk primary key  (vnk01) enable validate;
grant select on vnk_file to tiptopgp;
grant update on vnk_file to tiptopgp;
grant delete on vnk_file to tiptopgp;
grant insert on vnk_file to tiptopgp;
grant index on vnk_file to public;
grant select on vnk_file to ods;
