/*
================================================================================
檔案代號:axkk_file
檔案名稱:合并后科目异动码冲帐余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table axkk_file
(
axkk00      varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
axkk01      varchar2(10) DEFAULT ' ' NOT NULL, /*集团代号*/
axkk02      varchar2(10) DEFAULT ' ' NOT NULL, /*母公司编号*/
axkk03      varchar2(5) DEFAULT ' ' NOT NULL, /*母公司账套*/
axkk04      varchar2(10) DEFAULT ' ' NOT NULL, /*子公司编号*/
axkk041     varchar2(5) DEFAULT ' ' NOT NULL, /*子公司账套*/
axkk05      varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
axkk06      varchar2(2) DEFAULT ' ' NOT NULL, /*核算项顺序*/
axkk07      varchar2(30) DEFAULT ' ' NOT NULL, /*核算项值*/
axkk08      number(5) DEFAULT '0' NOT NULL, /*会计年度*/
axkk09      number(5) DEFAULT '0' NOT NULL, /*期别*/
axkk10      number(20,6),            /*借方总金额                             */
axkk11      number(20,6),            /*贷方总金额                             */
axkk12      number(10),              /*借方总笔数                             */
axkk13      number(10),              /*贷方总笔数                             */
axkk14      varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
axkk15      varchar2(10) DEFAULT ' ' NOT NULL, /*版本*/
axkklegal   varchar2(10) NOT NULL,   /*所属法人                               */
axkk16      number(20,6) DEFAULT '0' NOT NULL, /*no use*/
axkk17      number(20,6) DEFAULT '0' NOT NULL, /*no use*/
axkk18      varchar2(10),            /*no use                                 */
axkk19      number(20,6) DEFAULT '0' NOT NULL, /*no use*/
axkk20      number(20,6) DEFAULT '0' NOT NULL, /*no use*/
axkk21      varchar2(4),             /*no use                                 */
axkk22      varchar2(10) DEFAULT ' ' /*no use                                 */
);

alter table axkk_file add  constraint axkk_pk primary key  (axkk01,axkk02,axkk03,axkk04,axkk041,axkk05,axkk07,axkk08,axkk09,axkk00,axkk06,axkk14,axkk15) enable validate;
grant select on axkk_file to tiptopgp;
grant update on axkk_file to tiptopgp;
grant delete on axkk_file to tiptopgp;
grant insert on axkk_file to tiptopgp;
grant index on axkk_file to public;
grant select on axkk_file to ods;
