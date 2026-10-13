/*
================================================================================
檔案代號:aem_file
檔案名稱:合并个体异动码1~异动码8会计科目余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table aem_file
(
aem00       varchar2(5) DEFAULT ' ' NOT NULL, /*集团帐套*/
aem01       varchar2(10) DEFAULT ' ' NOT NULL, /*集团代号*/
aem02       varchar2(10) DEFAULT ' ' NOT NULL, /*合併個體編號*/
aem03       varchar2(5) DEFAULT ' ' NOT NULL, /*合併個體帳別*/
aem04       varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
aem05       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项5值*/
aem06       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项6值*/
aem07       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项7值*/
aem08       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项8值*/
aem09       number(5) DEFAULT '0' NOT NULL, /*会计年度*/
aem10       number(5) DEFAULT '0' NOT NULL, /*期别*/
aem11       number(20,6) DEFAULT '0' NOT NULL, /*借方金额*/
aem12       number(20,6) DEFAULT '0' NOT NULL, /*贷方金额*/
aem13       number(10),              /*借方总笔数                             */
aem14       number(10),              /*贷方总笔数                             */
aem15       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
aemlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
aem16       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项1*/
aem17       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项2*/
aem18       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项3*/
aem19       varchar2(30) DEFAULT ' ' NOT NULL /*核算项4*/
);

alter table aem_file add  constraint aem_pk primary key  (aem00,aem01,aem02,aem03,aem04,aem05,aem06,aem07,aem08,aem09,aem10,aem15,aem16,aem17,aem18,aem19) enable validate;
grant select on aem_file to tiptopgp;
grant update on aem_file to tiptopgp;
grant delete on aem_file to tiptopgp;
grant insert on aem_file to tiptopgp;
grant index on aem_file to public;
grant select on aem_file to ods;
