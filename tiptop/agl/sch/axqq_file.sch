/*
================================================================================
檔案代號:axqq_file
檔案名稱:权益科目金额暂存资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table axqq_file
(
axqq00      varchar2(5) DEFAULT ' ' NOT NULL, /*帐套编号*/
axqq01      varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
axqq02      varchar2(10) DEFAULT ' ' NOT NULL, /*上层公司编号*/
axqq03      varchar2(5) DEFAULT ' ' NOT NULL, /*上层帐套*/
axqq04      varchar2(10) DEFAULT ' ' NOT NULL, /*下层公司编号*/
axqq041     varchar2(5) DEFAULT ' ' NOT NULL, /*下层帐套*/
axqq05      varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
axqq06      number(5) DEFAULT '0' NOT NULL, /*会计年度*/
axqq07      number(5) DEFAULT '0' NOT NULL, /*期别*/
axqq08      number(20,6) DEFAULT '0' NOT NULL, /*年初金额*/
axqq09      number(20,6) DEFAULT '0' NOT NULL, /*本年发生金额*/
axqq10      number(10),              /*no use                                 */
axqq11      number(10),              /*no use                                 */
axqq12      varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
axqqlegal   varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

alter table axqq_file add  constraint axqq_pk primary key  (axqq01,axqq02,axqq03,axqq04,axqq041,axqq05,axqq06,axqq07,axqq00,axqq12) enable validate;
grant select on axqq_file to tiptopgp;
grant update on axqq_file to tiptopgp;
grant delete on axqq_file to tiptopgp;
grant insert on axqq_file to tiptopgp;
grant index on axqq_file to public;
grant select on axqq_file to ods;
