/*
================================================================================
檔案代號:lqq_file
檔案名稱:会员等级条件配置文件
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lqq_file
(
lqq01       varchar2(10) DEFAULT ' ' NOT NULL, /*会员等级编码*/
lqq02       varchar2(1) DEFAULT ' ' NOT NULL, /*会员升等基准*/
lqq03       varchar2(4) DEFAULT ' ' NOT NULL, /*判断条件*/
lqq04       number(20,6) DEFAULT '0' NOT NULL, /*下限*/
lqq05       number(20,6) DEFAULT '0' NOT NULL, /*上限*/
lqq06       number(5) DEFAULT '0' NOT NULL /*序号*/
);

alter table lqq_file add  constraint lqq_pk primary key  (lqq01,lqq02) enable validate;
grant select on lqq_file to tiptopgp;
grant update on lqq_file to tiptopgp;
grant delete on lqq_file to tiptopgp;
grant insert on lqq_file to tiptopgp;
grant index on lqq_file to public;
grant select on lqq_file to ods;
