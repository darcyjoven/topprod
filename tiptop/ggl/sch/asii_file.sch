/*
================================================================================
檔案代號:asii_file
檔案名稱:权益科目金额暂存资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table asii_file
(
asii00      varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
asii01      varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
asii02      varchar2(10) DEFAULT ' ' NOT NULL, /*上层公司编号*/
asii03      varchar2(5) DEFAULT ' ' NOT NULL, /*上层帐套*/
asii04      varchar2(10) DEFAULT ' ' NOT NULL, /*下层公司编号*/
asii041     varchar2(5) DEFAULT ' ' NOT NULL, /*下层帐套*/
asii05      varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
asii06      number(5) DEFAULT '0' NOT NULL, /*会计年度*/
asii07      number(5) DEFAULT '0' NOT NULL, /*期别*/
asii08      number(20,6) DEFAULT '0' NOT NULL, /*年度金额*/
asii09      number(20,6) DEFAULT '0' NOT NULL, /*本年发生金额*/
asii10      number(10) DEFAULT '0' NOT NULL, /*NO USE*/
asii11      number(10) DEFAULT '0' NOT NULL, /*NO USE*/
asii12      varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
asiilegal   varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

alter table asii_file add  constraint asii_pk primary key  (asii00,asii01,asii02,asii03,asii04,asii041,asii05,asii06,asii07,asii12) enable validate;
grant select on asii_file to tiptopgp;
grant update on asii_file to tiptopgp;
grant delete on asii_file to tiptopgp;
grant insert on asii_file to tiptopgp;
grant index on asii_file to public;
grant select on asii_file to ods;
