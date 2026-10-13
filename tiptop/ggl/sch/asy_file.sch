/*
================================================================================
檔案代號:asy_file
檔案名稱:合并报表关系人递延项摊销明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table asy_file
(
asy01       number(5) DEFAULT '0' NOT NULL, /*年度*/
asy02       number(5) DEFAULT '0' NOT NULL, /*期别*/
asy03       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
asy031      varchar2(10) DEFAULT ' ' NOT NULL, /*上层公司*/
asy04       varchar2(5) DEFAULT ' ' NOT NULL, /*项次*/
asy05       number(5) DEFAULT '0' NOT NULL, /*摊销年度*/
asy06       number(5) DEFAULT '0' NOT NULL, /*摊销期别*/
asy07       number(20,6) DEFAULT '0' NOT NULL, /*本期摊销金额*/
asy08       number(20,6) DEFAULT '0' NOT NULL, /*本期摊销合并币种金额*/
asy09       varchar2(20),            /*抵消凭证编号                           */
asylegal    varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

alter table asy_file add  constraint asy_pk primary key  (asy01,asy02,asy03,asy031,asy04,asy05,asy06) enable validate;
grant select on asy_file to tiptopgp;
grant update on asy_file to tiptopgp;
grant delete on asy_file to tiptopgp;
grant insert on asy_file to tiptopgp;
grant index on asy_file to public;
grant select on asy_file to ods;
