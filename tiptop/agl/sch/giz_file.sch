/*
================================================================================
檔案代號:giz_file
檔案名稱:现金流量表期初开帐金额设定-本期损益(合并)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table giz_file
(
giz00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
giz01       number(5) DEFAULT '0' NOT NULL, /*年度*/
giz02       number(5) DEFAULT '0' NOT NULL, /*期别*/
giz03       number(20,6) DEFAULT '0' NOT NULL, /*期初金额*/
giz04       varchar2(10) DEFAULT ' ' NOT NULL, /*集团代号*/
giz05       varchar2(10) DEFAULT ' ' NOT NULL /*母公司编号*/
);

alter table giz_file add  constraint giz_pk primary key  (giz00,giz01,giz02,giz04,giz05) enable validate;
grant select on giz_file to tiptopgp;
grant update on giz_file to tiptopgp;
grant delete on giz_file to tiptopgp;
grant insert on giz_file to tiptopgp;
grant index on giz_file to public;
grant select on giz_file to ods;
