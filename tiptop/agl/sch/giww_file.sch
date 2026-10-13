/*
================================================================================
檔案代號:giww_file
檔案名稱:现金流量活动科目档(合并)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table giww_file
(
giww00      varchar2(5) DEFAULT ' ' NOT NULL, /*合并帐套*/
giww01      varchar2(10) DEFAULT ' ' NOT NULL, /*群组代码*/
giww02      varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
giww03      varchar2(1) DEFAULT ' ' NOT NULL, /*加减项 +.加项 / -.减项*/
giww04      varchar2(1) DEFAULT ' ' NOT NULL, /*1.异动 2.期初 3.期末 4.人工录  */
giww05      varchar2(10) DEFAULT ' ' NOT NULL, /*集团代号*/
giww06      varchar2(10) DEFAULT ' ' NOT NULL /*母公司编号*/
);

alter table giww_file add  constraint giww_pk primary key  (giww00,giww01,giww02,giww05,giww06) enable validate;
grant select on giww_file to tiptopgp;
grant update on giww_file to tiptopgp;
grant delete on giww_file to tiptopgp;
grant insert on giww_file to tiptopgp;
grant index on giww_file to public;
grant select on giww_file to ods;
