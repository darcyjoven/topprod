/*
================================================================================
檔案代號:cdk_file
檔案名稱:每月盘盈亏科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table cdk_file
(
cdk01       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
cdk02       number(5) DEFAULT '0' NOT NULL, /*年度*/
cdk03       number(5) DEFAULT '0' NOT NULL, /*月份*/
cdk04       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
cdk05       varchar2(40) DEFAULT ' ' NOT NULL, /*类型编号*/
cdk06       varchar2(40) DEFAULT ' ' NOT NULL, /*料件*/
cdk07       varchar2(24),            /*存货科目                               */
cdk08       number(15,3) DEFAULT '0' NOT NULL, /*盘盈亏数量*/
cdk09       number(20,6) DEFAULT '0' NOT NULL, /*盘盈亏金额*/
cdk10       varchar2(30),            /*分录底稿单号                           */
cdk11       varchar2(10) DEFAULT ' ' NOT NULL, /*成本中心*/
cdk12       varchar2(10),            /*no use                                 */
cdk13       varchar2(24),            /*费用科目                               */
cdkconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
cdklegal    varchar2(10)             /*所属法人                               */
);

alter table cdk_file add  constraint cdk_pk primary key  (cdk01,cdk02,cdk03,cdk04,cdk05,cdk06,cdk11) enable validate;
grant select on cdk_file to tiptopgp;
grant update on cdk_file to tiptopgp;
grant delete on cdk_file to tiptopgp;
grant insert on cdk_file to tiptopgp;
grant index on cdk_file to public;
grant select on cdk_file to ods;
