/*
================================================================================
檔案代號:gix_file
檔案名稱:现金流量表人工输入金额档(总账)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gix_file
(
gix00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
gix01       varchar2(10) DEFAULT ' ' NOT NULL, /*群组代码*/
gix02       varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
gix03       varchar2(16) DEFAULT ' ' NOT NULL, /*编号*/
gix04       varchar2(80),            /*说明                                   */
gix05       number(20,6) DEFAULT '0' NOT NULL, /*人工录入金额*/
gix06       number(5) DEFAULT '0' NOT NULL, /*年度*/
gix07       number(5) DEFAULT '0' NOT NULL /*期别*/
);

alter table gix_file add  constraint gix_pk primary key  (gix00,gix01,gix02,gix03) enable validate;
grant select on gix_file to tiptopgp;
grant update on gix_file to tiptopgp;
grant delete on gix_file to tiptopgp;
grant insert on gix_file to tiptopgp;
grant index on gix_file to public;
grant select on gix_file to ods;
