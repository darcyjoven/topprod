/*
================================================================================
檔案代號:cdh_file
檔案名稱:每月工单入库元件科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table cdh_file
(
cdh01       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
cdh02       number(5) DEFAULT '0' NOT NULL, /*年度*/
cdh03       number(5) DEFAULT '0' NOT NULL, /*月份*/
cdh04       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
cdh05       varchar2(40) DEFAULT ' ' NOT NULL, /*类型编号*/
cdh06       varchar2(40) DEFAULT ' ' NOT NULL, /*工单单号*/
cdh07       varchar2(40) DEFAULT ' ' NOT NULL, /*元件*/
cdh08       varchar2(24) DEFAULT ' ',/*科目                                   */
cdh09       number(15,3) DEFAULT '0' NOT NULL, /*本月转出数量*/
cdh10       number(20,6) DEFAULT '0' NOT NULL, /*本月转出金额*/
cdh10a      number(20,6) DEFAULT '0' NOT NULL, /*本月本階轉出金額-材料*/
cdh10b      number(20,6) DEFAULT '0' NOT NULL, /*本月本階轉出金額-人工*/
cdh10c      number(20,6) DEFAULT '0' NOT NULL, /*本月本階轉出金額-制費一*/
cdh10d      number(20,6) DEFAULT '0' NOT NULL, /*本月本階轉出金額-加工*/
cdh10e      number(20,6) DEFAULT '0' NOT NULL, /*本月本階轉出金額-制費二*/
cdh10f      number(20,6) DEFAULT '0' NOT NULL, /*本月本階轉出金額-制費三*/
cdh10g      number(20,6) DEFAULT '0' NOT NULL, /*本月本階轉出金額-制費四*/
cdh10h      number(20,6) DEFAULT '0' NOT NULL, /*本月本階轉出金額-制費五*/
cdh11       varchar2(10),            /*成本中心                               */
cdhlegal    varchar2(10),            /*所属法人                               */
cdhorig     varchar2(10),            /*资料建立部门                           */
cdhoriu     varchar2(10),            /*资料建立者                             */
cdhplant    varchar2(10),            /*所属工厂                               */
cdh00       varchar2(1) DEFAULT '1' NOT NULL /*来源类型*/
);

create        index cdh_01 on cdh_file (cdh01,cdh02,cdh03,cdh04,cdh05,cdh06,cdh07);
alter table cdh_file add  constraint cdh_pk primary key  (cdh00,cdh01,cdh02,cdh03,cdh04,cdh05,cdh06,cdh07) enable validate;
grant select on cdh_file to tiptopgp;
grant update on cdh_file to tiptopgp;
grant delete on cdh_file to tiptopgp;
grant insert on cdh_file to tiptopgp;
grant index on cdh_file to public;
grant select on cdh_file to ods;
