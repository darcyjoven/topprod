/*
================================================================================
檔案代號:giyy_file
檔案名稱:现金流量表揭露事项说明文件(合并)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table giyy_file
(
giyy01      number(5) DEFAULT '0' NOT NULL, /*顺序*/
giyy02      varchar2(80),            /*说明                                   */
giyy03      number(20,6) DEFAULT '0' NOT NULL, /*金额*/
giyy04      number(5) DEFAULT '0' NOT NULL, /*年度*/
giyy05      number(5) DEFAULT '0' NOT NULL, /*期别*/
giyy06      varchar2(10) DEFAULT ' ' NOT NULL, /*集团代号*/
giyy07      varchar2(10) DEFAULT ' ' NOT NULL /*母公司编号*/
);

alter table giyy_file add  constraint giyy_pk primary key  (giyy01,giyy04,giyy05,giyy06,giyy07) enable validate;
grant select on giyy_file to tiptopgp;
grant update on giyy_file to tiptopgp;
grant delete on giyy_file to tiptopgp;
grant insert on giyy_file to tiptopgp;
grant index on giyy_file to public;
grant select on giyy_file to ods;
