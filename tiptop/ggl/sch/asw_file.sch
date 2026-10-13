/*
================================================================================
檔案代號:asw_file
檔案名稱:合并报表关系人交易资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table asw_file
(
asw01       number(5) DEFAULT '0' NOT NULL, /*年度*/
asw02       number(5) DEFAULT '0' NOT NULL, /*期别*/
asw03       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
asw031      varchar2(10) DEFAULT ' ' NOT NULL, /*上层公司*/
asw04       number(5) DEFAULT '0' NOT NULL, /*项次*/
asw05       varchar2(1) DEFAULT ' ' NOT NULL, /*交易性质*/
asw06       varchar2(1) DEFAULT ' ' NOT NULL, /*交易类型*/
asw07       varchar2(10),            /*来源公司                               */
asw08       varchar2(10),            /*交易公司                               */
asw09       varchar2(24),            /*帐列科目                               */
asw10       varchar2(24),            /*交易科目                               */
asw11       varchar2(4) DEFAULT ' ' NOT NULL, /*来源币种*/
asw12       number(20,6) DEFAULT '0' NOT NULL, /*交易金额*/
asw13       number(20,6) DEFAULT '0' NOT NULL, /*交易损益*/
asw131      number(20,6) DEFAULT '0' NOT NULL, /*已实现损益*/
asw14       number(20,6) DEFAULT '0' NOT NULL, /*未实现利益*/
asw15       number(15,3) DEFAULT '0' NOT NULL, /*持股比率*/
asw16       number(20,6) DEFAULT '0' NOT NULL, /*分配未实现利益*/
asw17       varchar2(20),            /*来源单号                               */
asw18       varchar2(20),            /*调整单号                               */
asw19       varchar2(24),            /*未实现损益科目                         */
aswlegal    varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

alter table asw_file add  constraint asw_pk primary key  (asw01,asw02,asw03,asw031,asw04,asw11) enable validate;
grant select on asw_file to tiptopgp;
grant update on asw_file to tiptopgp;
grant delete on asw_file to tiptopgp;
grant insert on asw_file to tiptopgp;
grant index on asw_file to public;
grant select on asw_file to ods;
