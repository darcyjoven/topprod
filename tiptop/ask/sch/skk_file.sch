/*
================================================================================
檔案代號:skk_file
檔案名稱:计薪系数档
檔案目的:计薪系数档 假双档
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table skk_file
(
skk01       varchar2(10) DEFAULT ' ' NOT NULL, /*部门编号*/
skk02       number(5) DEFAULT '0' NOT NULL, /*年度*/
skk03       number(10) DEFAULT '0' NOT NULL, /*月份*/
skk04       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
skk05       number(15,3) DEFAULT '0' NOT NULL, /*系数*/
skk06       varchar2(80),            /*说明                                   */
skkacti     varchar2(1) DEFAULT ' ' NOT NULL /*有效否*/
);

alter table skk_file add  constraint skk_pk primary key  (skk01,skk02,skk03,skk04) enable validate;
grant select on skk_file to tiptopgp;
grant update on skk_file to tiptopgp;
grant delete on skk_file to tiptopgp;
grant insert on skk_file to tiptopgp;
grant index on skk_file to public;
grant select on skk_file to ods;
