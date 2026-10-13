/*
================================================================================
檔案代號:amg_file
檔案名稱:卖方厂编资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table amg_file
(
amg01       varchar2(1) DEFAULT ' ' NOT NULL, /*分类方式*/
amg02       varchar2(10) DEFAULT ' ' NOT NULL, /*产品编号类别编号*/
amg03       varchar2(20),            /*卖方厂编                               */
amgacti     varchar2(1) DEFAULT 'Y' NOT NULL /*有效否*/
);

alter table amg_file add  constraint amg_pk primary key  (amg01,amg02) enable validate;
grant select on amg_file to tiptopgp;
grant update on amg_file to tiptopgp;
grant delete on amg_file to tiptopgp;
grant insert on amg_file to tiptopgp;
grant index on amg_file to public;
grant select on amg_file to ods;
