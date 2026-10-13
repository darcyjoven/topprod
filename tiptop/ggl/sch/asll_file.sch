/*
================================================================================
檔案代號:asll_file
檔案名稱:合并后科目异动码(固定)冲账余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table asll_file
(
asll00      varchar2(5) DEFAULT ' ' NOT NULL, /*帐别*/
asll01      varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
asll02      varchar2(10) DEFAULT ' ' NOT NULL, /*上层公司编号*/
asll021     varchar2(5) DEFAULT ' ' NOT NULL, /*上层公司帐套*/
asll03      varchar2(10) DEFAULT ' ' NOT NULL, /*下层公司编号*/
asll031     varchar2(5) DEFAULT ' ' NOT NULL, /*下层公司帐套*/
asll04      varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
asll05      varchar2(30) DEFAULT ' ' NOT NULL, /*异动码5值*/
asll06      varchar2(30) DEFAULT ' ' NOT NULL, /*异动码6值*/
asll07      varchar2(30) DEFAULT ' ' NOT NULL, /*异动码7值*/
asll08      varchar2(30) DEFAULT ' ' NOT NULL, /*异动码8值*/
asll09      number(5) DEFAULT '0' NOT NULL, /*会计年度*/
asll10      number(5) DEFAULT '0' NOT NULL, /*期别*/
asll11      number(20,6) DEFAULT '0' NOT NULL, /*借方总金额*/
asll12      number(20,6) DEFAULT '0' NOT NULL, /*贷方总金额*/
asll13      number(10) DEFAULT '0' NOT NULL, /*借方总笔数*/
asll14      number(10) DEFAULT '0' NOT NULL, /*贷方总笔数*/
asll15      varchar2(10),            /*版本                                   */
asll16      number(20,10) DEFAULT '0' NOT NULL, /*再衡量汇率*/
asll17      number(20,10) DEFAULT '0' NOT NULL, /*换算汇率*/
asll18      varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
aslllegal   varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

alter table asll_file add  constraint asll_pk primary key  (asll00,asll01,asll02,asll021,asll03,asll031,asll04,asll05,asll06,asll07,asll08,asll09,asll10,asll18) enable validate;
grant select on asll_file to tiptopgp;
grant update on asll_file to tiptopgp;
grant delete on asll_file to tiptopgp;
grant insert on asll_file to tiptopgp;
grant index on asll_file to public;
grant select on asll_file to ods;
