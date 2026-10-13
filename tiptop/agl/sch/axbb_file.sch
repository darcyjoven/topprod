/*
================================================================================
檔案代號:axbb_file
檔案名稱:联属公司持股比例档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table axbb_file
(
axbb01      varchar2(10) DEFAULT ' ' NOT NULL, /*集团代号*/
axbb02      varchar2(10) DEFAULT ' ' NOT NULL, /*母公司编号*/
axbb03      varchar2(5) DEFAULT ' ' NOT NULL, /*母公司账套*/
axbb04      varchar2(10) DEFAULT ' ' NOT NULL, /*子公司编号*/
axbb05      varchar2(10) DEFAULT ' ' NOT NULL, /*子公司账套*/
axbb06      date DEFAULT sysdate NOT NULL, /*异动日期*/
axbb07      number(9,4),             /*持股比率                               */
axbb08      number(10),              /*投资股数                               */
axbb09      number(20,6) DEFAULT '0' NOT NULL, /*股本*/
axbb10      varchar2(24)             /*长期投资科目                           */
);

alter table axbb_file add  constraint axbb_pk primary key  (axbb01,axbb02,axbb03,axbb04,axbb05,axbb06) enable validate;
grant select on axbb_file to tiptopgp;
grant update on axbb_file to tiptopgp;
grant delete on axbb_file to tiptopgp;
grant insert on axbb_file to tiptopgp;
grant index on axbb_file to public;
grant select on axbb_file to ods;
