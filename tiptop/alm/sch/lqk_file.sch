/*
================================================================================
檔案代號:lqk_file
檔案名稱:特殊摊位费用分摊设置单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lqk_file
(
lqk01       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
lqk02       number(5) DEFAULT '0' NOT NULL, /*组别*/
lqk03       varchar2(20) DEFAULT ' ' NOT NULL, /*摊位编号*/
lqk04       varchar2(1) DEFAULT ' ' NOT NULL, /*费用分摊方式*/
lqk05       varchar2(1) DEFAULT ' ' NOT NULL, /*费用分摊金额类别*/
lqk06       varchar2(1) DEFAULT ' ' NOT NULL /*类型*/
);

alter table lqk_file add  constraint lqk_pk primary key  (lqk01,lqk02,lqk03) enable validate;
grant select on lqk_file to tiptopgp;
grant update on lqk_file to tiptopgp;
grant delete on lqk_file to tiptopgp;
grant insert on lqk_file to tiptopgp;
grant index on lqk_file to public;
grant select on lqk_file to ods;
