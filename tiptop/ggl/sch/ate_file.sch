/*
================================================================================
檔案代號:ate_file
檔案名稱:合并现金流量表直接法抵消设置
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ate_file
(
ate01       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
ate02       varchar2(10) DEFAULT ' ' NOT NULL, /*来源公司编号*/
ate03       varchar2(10) DEFAULT ' ' NOT NULL, /*对冲公司编号*/
ate04       number(5) DEFAULT '0' NOT NULL, /*年度*/
ate05       number(5) DEFAULT '0' NOT NULL, /*期别*/
ate06       varchar2(4) DEFAULT ' ' NOT NULL, /*来源公司现金异动码*/
ate07       varchar2(1) DEFAULT ' ' NOT NULL, /*加减项*/
ate08       number(20,6) DEFAULT '0' NOT NULL, /*金额*/
ate09       varchar2(4) DEFAULT ' ' NOT NULL, /*现金流量项目*/
ate10       varchar2(1) DEFAULT ' ' NOT NULL, /*加减项*/
ate11       varchar2(80),            /*备注                                   */
atelegal    varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

alter table ate_file add  constraint ate_pk primary key  (ate01,ate02,ate03,ate04,ate05,ate06,ate09) enable validate;
grant select on ate_file to tiptopgp;
grant update on ate_file to tiptopgp;
grant delete on ate_file to tiptopgp;
grant insert on ate_file to tiptopgp;
grant index on ate_file to public;
grant select on ate_file to ods;
