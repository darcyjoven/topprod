/*
================================================================================
檔案代號:gizz_file
檔案名稱:现金流量表期初金额开帐档(合并)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gizz_file
(
gizz00      varchar2(5) DEFAULT ' ' NOT NULL, /*合并帐套*/
gizz01      varchar2(10) DEFAULT ' ' NOT NULL, /*集团代号*/
gizz02      varchar2(10) DEFAULT ' ' NOT NULL, /*母公司编号*/
gizz03      number(5) DEFAULT '0' NOT NULL, /*年度*/
gizz04      number(5) DEFAULT '0' NOT NULL, /*期别*/
gizz05      number(20,6) DEFAULT '0' NOT NULL, /*期初金额*/
gizz06      varchar2(24) DEFAULT ' ' NOT NULL, /*会计科目编号*/
gizz07      varchar2(10) DEFAULT ' ' NOT NULL /*群组代码*/
);

alter table gizz_file add  constraint gizz_pk primary key  (gizz00,gizz01,gizz02,gizz03,gizz04,gizz06,gizz07) enable validate;
grant select on gizz_file to tiptopgp;
grant update on gizz_file to tiptopgp;
grant delete on gizz_file to tiptopgp;
grant insert on gizz_file to tiptopgp;
grant index on gizz_file to public;
grant select on gizz_file to ods;
