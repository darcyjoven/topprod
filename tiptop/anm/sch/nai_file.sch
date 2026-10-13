/*
================================================================================
檔案代號:nai_file
檔案名稱:银行对账单开账档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nai_file
(
nai01       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
nai02       varchar2(11) DEFAULT ' ' NOT NULL, /*银行编号*/
nai03       number(5) DEFAULT '0' NOT NULL, /*年度*/
nai04       number(5) DEFAULT '0' NOT NULL, /*期别*/
nai05       varchar2(1) DEFAULT ' ' NOT NULL, /*借贷别*/
nai06       number(20,6) DEFAULT '0' NOT NULL, /*金额*/
nai07       varchar2(80),            /*摘要                                   */
nai08       varchar2(20) DEFAULT ' ' NOT NULL, /*流水号*/
nai09       varchar2(1) DEFAULT ' ' NOT NULL, /*对帐码*/
nailegal    varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

create unique index nai_01 on nai_file (nai08);
alter table nai_file add  constraint nai_pk primary key  (nai08) enable validate;
grant select on nai_file to tiptopgp;
grant update on nai_file to tiptopgp;
grant delete on nai_file to tiptopgp;
grant insert on nai_file to tiptopgp;
grant index on nai_file to public;
grant select on nai_file to ods;
