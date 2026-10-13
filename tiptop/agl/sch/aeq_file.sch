/*
================================================================================
檔案代號:aeq_file
檔案名稱:合并现金流量表直接法抵消设置
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table aeq_file
(
aeq01       varchar2(5) DEFAULT ' ' NOT NULL, /*帐别*/
aeq02       varchar2(10) DEFAULT ' ' NOT NULL, /*来源公司编号*/
aeq03       varchar2(10) DEFAULT ' ' NOT NULL, /*对冲公司编号*/
aeq04       number(5) DEFAULT '0' NOT NULL, /*年度*/
aeq05       number(5) DEFAULT '0' NOT NULL, /*期别*/
aeq06       varchar2(4) DEFAULT ' ' NOT NULL, /*来源公司现金异动码*/
aeq07       varchar2(1) DEFAULT ' ' NOT NULL, /*加减项*/
aeq08       number(20,6) DEFAULT '0' NOT NULL, /*金额*/
aeq09       varchar2(4) DEFAULT ' ' NOT NULL, /*现金流量项目*/
aeq10       varchar2(1) DEFAULT ' ' NOT NULL, /*加减项*/
aeq11       varchar2(80),            /*备注                                   */
aeqlegal    varchar2(10)             /*所属法人                               */
);

alter table aeq_file add  constraint aeq_pk primary key  (aeq01,aeq02,aeq03,aeq04,aeq05,aeq06,aeq09) enable validate;
grant select on aeq_file to tiptopgp;
grant update on aeq_file to tiptopgp;
grant delete on aeq_file to tiptopgp;
grant insert on aeq_file to tiptopgp;
grant index on aeq_file to public;
grant select on aeq_file to ods;
