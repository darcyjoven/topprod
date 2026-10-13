/*
================================================================================
檔案代號:cdm_file
檔案名稱:入库成本调整科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table cdm_file
(
cdm01       varchar2(5) DEFAULT ' ' NOT NULL, /*帐别*/
cdm02       number(5) DEFAULT '0' NOT NULL, /*年度*/
cdm03       number(5) DEFAULT '0' NOT NULL, /*月份*/
cdm04       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
cdm05       varchar2(40) DEFAULT ' ' NOT NULL, /*类型编号*/
cdm06       varchar2(40) DEFAULT ' ' NOT NULL, /*料号*/
cdm07       varchar2(24),            /*存货科目                               */
cdm08       varchar2(24),            /*对方科目                               */
cdm09       number(20,6) DEFAULT '0' NOT NULL, /*金额*/
cdm10       varchar2(20),            /*分录底稿单号                           */
cdm11       varchar2(20) DEFAULT ' ' NOT NULL, /*参考单号*/
cdmconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核码*/
cdmlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
cdm00       varchar2(1) DEFAULT ' ' NOT NULL /*类型*/
);

alter table cdm_file add  constraint cdm_pk primary key  (cdm00,cdm01,cdm02,cdm03,cdm04,cdm05,cdm06,cdm11) enable validate;
grant select on cdm_file to tiptopgp;
grant update on cdm_file to tiptopgp;
grant delete on cdm_file to tiptopgp;
grant insert on cdm_file to tiptopgp;
grant index on cdm_file to public;
grant select on cdm_file to ods;
