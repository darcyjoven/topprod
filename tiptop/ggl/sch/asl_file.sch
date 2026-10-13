/*
================================================================================
檔案代號:asl_file
檔案名稱:合并前科目异动码(固定)冲账余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table asl_file
(
asl00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐别*/
asl01       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
asl02       varchar2(10) DEFAULT ' ' NOT NULL, /*上层公司编号*/
asl021      varchar2(5) DEFAULT ' ' NOT NULL, /*上层公司帐套*/
asl03       varchar2(10) DEFAULT ' ' NOT NULL, /*下层公司编号*/
asl031      varchar2(5) DEFAULT ' ' NOT NULL, /*下层公司帐套*/
asl04       varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
asl05       varchar2(30) DEFAULT ' ' NOT NULL, /*异动码5值*/
asl06       varchar2(30) DEFAULT ' ' NOT NULL, /*异动码6值*/
asl07       varchar2(30) DEFAULT ' ' NOT NULL, /*异动码7值*/
asl08       varchar2(30) DEFAULT ' ' NOT NULL, /*异动码8值*/
asl09       number(5) DEFAULT '0' NOT NULL, /*会计年度*/
asl10       number(5) DEFAULT '0' NOT NULL, /*期别*/
asl11       number(20,6) DEFAULT '0' NOT NULL, /*借方总金额*/
asl12       number(20,6) DEFAULT '0' NOT NULL, /*贷方总金额*/
asl13       number(10) DEFAULT '0' NOT NULL, /*借方总笔数*/
asl14       number(10) DEFAULT '0' NOT NULL, /*贷方总笔数*/
asl15       varchar2(10),            /*版本                                   */
asl16       number(20,10) DEFAULT '0' NOT NULL, /*再衡量汇率*/
asl17       number(20,10) DEFAULT '0' NOT NULL, /*换算汇率*/
asl18       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
asllegal    varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

alter table asl_file add  constraint asl_pk primary key  (asl00,asl01,asl02,asl021,asl03,asl031,asl04,asl05,asl06,asl07,asl08,asl09,asl10,asl18) enable validate;
grant select on asl_file to tiptopgp;
grant update on asl_file to tiptopgp;
grant delete on asl_file to tiptopgp;
grant insert on asl_file to tiptopgp;
grant index on asl_file to public;
grant select on asl_file to ods;
