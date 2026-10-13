/*
================================================================================
檔案代號:cdf_file
檔案名稱:每月工单发料元件科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table cdf_file
(
cdf01       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
cdf02       number(5) DEFAULT '0' NOT NULL, /*年度*/
cdf03       number(5) DEFAULT '0' NOT NULL, /*月份*/
cdf04       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
cdf05       varchar2(40) DEFAULT ' ' NOT NULL, /*类型编号*/
cdf06       varchar2(40) DEFAULT ' ' NOT NULL, /*工单单号*/
cdf07       varchar2(40) DEFAULT ' ' NOT NULL, /*元件*/
cdf08       varchar2(24),            /*科目                                   */
cdf09       number(20,6) DEFAULT '0' NOT NULL, /*本月投入金额*/
cdf09a      number(20,6) DEFAULT '0' NOT NULL, /*本月投入金額-材料*/
cdf09b      number(20,6) DEFAULT '0' NOT NULL, /*本月投入金額-人工*/
cdf09c      number(20,6) DEFAULT '0' NOT NULL, /*本月投入金額-制費一*/
cdf09d      number(20,6) DEFAULT '0' NOT NULL, /*本月投入金額-加工*/
cdf09e      number(20,6) DEFAULT '0' NOT NULL, /*本月投入金額-制費二*/
cdf09f      number(20,6) DEFAULT '0' NOT NULL, /*本月投入金額-制費三*/
cdf09g      number(20,6) DEFAULT '0' NOT NULL, /*本月投入金額-制費四*/
cdf09h      number(20,6) DEFAULT '0' NOT NULL, /*本月投入金額-制費五*/
cdf10       varchar2(10),            /*成本中心                               */
cdflegal    varchar2(10),            /*所属法人                               */
cdforig     varchar2(10),            /*资料建立部门                           */
cdforiu     varchar2(10),            /*资料建立者                             */
cdfplant    varchar2(10)             /*所属工厂                               */
);

create        index cdf_01 on cdf_file (cdf01,cdf02,cdf03,cdf04,cdf05,cdf06,cdf07);
alter table cdf_file add  constraint cdf_pk primary key  (cdf01,cdf02,cdf03,cdf04,cdf05,cdf06,cdf07) enable validate;
grant select on cdf_file to tiptopgp;
grant update on cdf_file to tiptopgp;
grant delete on cdf_file to tiptopgp;
grant insert on cdf_file to tiptopgp;
grant index on cdf_file to public;
grant select on cdf_file to ods;
