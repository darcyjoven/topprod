/*
================================================================================
檔案代號:gixx_file
檔案名稱:现金流量表人工输入金额档(合并)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gixx_file
(
gixx00      varchar2(5) DEFAULT ' ' NOT NULL, /*合并帐套*/
gixx01      varchar2(10) DEFAULT ' ' NOT NULL, /*群组代码*/
gixx02      varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
gixx03      varchar2(16) DEFAULT ' ' NOT NULL, /*编号*/
gixx04      varchar2(80),            /*说明                                   */
gixx05      number(20,6) DEFAULT '0' NOT NULL, /*人工录入金额*/
gixx06      number(5) DEFAULT '0' NOT NULL, /*年度*/
gixx07      number(5) DEFAULT '0' NOT NULL, /*期别*/
gixx08      varchar2(10) DEFAULT ' ' NOT NULL, /*集团代号*/
gixx09      varchar2(10) DEFAULT ' ' NOT NULL /*母公司编号*/
);

alter table gixx_file add  constraint gixx_pk primary key  (gixx00,gixx01,gixx02,gixx03) enable validate;
grant select on gixx_file to tiptopgp;
grant update on gixx_file to tiptopgp;
grant delete on gixx_file to tiptopgp;
grant insert on gixx_file to tiptopgp;
grant index on gixx_file to public;
grant select on gixx_file to ods;
