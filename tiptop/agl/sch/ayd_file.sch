/*
================================================================================
檔案代號:ayd_file
檔案名稱:合并股东权益期初余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ayd_file
(
ayd00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套编号*/
ayd01       varchar2(10) DEFAULT ' ' NOT NULL, /*集团代号*/
ayd02       varchar2(10) DEFAULT ' ' NOT NULL, /*母公司*/
ayd03       number(5) DEFAULT '0' NOT NULL, /*年度*/
ayd04       number(5) DEFAULT '0' NOT NULL, /*期别*/
ayd05       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
ayd06       varchar2(10) DEFAULT ' ' NOT NULL, /*分类代码*/
ayd07       varchar2(10) DEFAULT ' ' NOT NULL, /*群组代码*/
ayd08       number(20,6) DEFAULT '0' NOT NULL, /*余额*/
aydlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
aydorig     varchar2(10),            /*资料建立部门                           */
aydoriu     varchar2(10)             /*资料建立者                             */
);

alter table ayd_file add  constraint ayd_pk primary key  (ayd00,ayd01,ayd02,ayd03,ayd04,ayd05,ayd06,ayd07) enable validate;
grant select on ayd_file to tiptopgp;
grant update on ayd_file to tiptopgp;
grant delete on ayd_file to tiptopgp;
grant insert on ayd_file to tiptopgp;
grant index on ayd_file to public;
grant select on ayd_file to ods;
