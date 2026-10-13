/*
================================================================================
檔案代號:aeii_file
檔案名稱:合并后科目核算项(固定)冲帐余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table aeii_file
(
aeii00      varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
aeii01      varchar2(10) DEFAULT ' ' NOT NULL, /*集团代号*/
aeii02      varchar2(10) DEFAULT ' ' NOT NULL, /*母公司编号*/
aeii021     varchar2(5) DEFAULT ' ' NOT NULL, /*母公司帐套*/
aeii03      varchar2(10) DEFAULT ' ' NOT NULL, /*子公司编号*/
aeii031     varchar2(5) DEFAULT ' ' NOT NULL, /*子公司帐套*/
aeii04      varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
aeii05      varchar2(30) DEFAULT ' ' NOT NULL, /*核算项5值*/
aeii06      varchar2(30) DEFAULT ' ' NOT NULL, /*核算项6值*/
aeii07      varchar2(30) DEFAULT ' ' NOT NULL, /*核算项7值*/
aeii08      varchar2(30) DEFAULT ' ' NOT NULL, /*核算项8值*/
aeii09      number(5) DEFAULT '0' NOT NULL, /*会计年度*/
aeii10      number(5) DEFAULT '0' NOT NULL, /*期别*/
aeii11      number(20,6) DEFAULT '0' NOT NULL, /*借方总金额*/
aeii12      number(20,6) DEFAULT '0' NOT NULL, /*贷方总金额*/
aeii13      number(10),              /*借方总笔数                             */
aeii14      number(10),              /*贷方总笔数                             */
aeii15      varchar2(10),            /*版本                                   */
aeii16      number(20,10),           /*再衡量汇率                             */
aeii17      number(20,10),           /*换算汇率                               */
aeii18      varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
aeiilegal   varchar2(10),            /*所属法人                               */
aeii19      varchar2(30) DEFAULT ' ' NOT NULL, /*核算项1*/
aeii20      varchar2(30) DEFAULT ' ' NOT NULL, /*核算项2*/
aeii21      varchar2(30) DEFAULT ' ' NOT NULL, /*核算项3*/
aeii22      varchar2(30) DEFAULT ' ' NOT NULL, /*核算项4*/
aeii23      varchar2(255) DEFAULT ' ' NOT NULL, /*索引组合值1*/
aeii24      varchar2(255) DEFAULT ' ' NOT NULL /*索引组合值2*/
);

alter table aeii_file add  constraint aeii_pk primary key  (aeii00,aeii01,aeii02,aeii021,aeii03,aeii031,aeii04,aeii05,aeii06,aeii07,aeii08,aeii09,aeii10,aeii18,aeii23,aeii24) enable validate;
grant select on aeii_file to tiptopgp;
grant update on aeii_file to tiptopgp;
grant delete on aeii_file to tiptopgp;
grant insert on aeii_file to tiptopgp;
grant index on aeii_file to public;
grant select on aeii_file to ods;
