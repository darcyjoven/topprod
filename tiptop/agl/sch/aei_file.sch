/*
================================================================================
檔案代號:aei_file
檔案名稱:合并前科目核算项(固定)冲帐余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table aei_file
(
aei00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
aei01       varchar2(10) DEFAULT ' ' NOT NULL, /*集团代号*/
aei02       varchar2(10) DEFAULT ' ' NOT NULL, /*母公司编号*/
aei021      varchar2(5) DEFAULT ' ' NOT NULL, /*母公司帐套*/
aei03       varchar2(10) DEFAULT ' ' NOT NULL, /*子公司编号*/
aei031      varchar2(5) DEFAULT ' ' NOT NULL, /*子公司帐别*/
aei04       varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
aei05       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项5值*/
aei06       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项6值*/
aei07       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项7值*/
aei08       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项8值*/
aei09       number(5) DEFAULT '0' NOT NULL, /*会计年度*/
aei10       number(5) DEFAULT '0' NOT NULL, /*期别*/
aei11       number(20,6),            /*借方总金额                             */
aei12       number(20,6),            /*贷方总金额                             */
aei13       number(10),              /*借方总笔数                             */
aei14       number(10),              /*贷方总笔数                             */
aei15       varchar2(10),            /*版本                                   */
aei16       number(20,10),           /*再衡量汇率                             */
aei17       number(20,10),           /*换算汇率                               */
aei18       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
aeilegal    varchar2(10),            /*所属法人                               */
aei19       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项1*/
aei20       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项2*/
aei21       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项3*/
aei22       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项4*/
aei23       varchar2(255) DEFAULT ' ' NOT NULL, /*索引组合值1*/
aei24       varchar2(255) DEFAULT ' ' NOT NULL /*索引组合值2*/
);

alter table aei_file add  constraint aei_pk primary key  (aei00,aei01,aei02,aei021,aei03,aei031,aei04,aei05,aei06,aei07,aei08,aei09,aei10,aei18,aei23,aei24) enable validate;
grant select on aei_file to tiptopgp;
grant update on aei_file to tiptopgp;
grant delete on aei_file to tiptopgp;
grant insert on aei_file to tiptopgp;
grant index on aei_file to public;
grant select on aei_file to ods;
