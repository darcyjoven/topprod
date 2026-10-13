/*
================================================================================
檔案代號:asnn_file
檔案名稱:合并个体异动码5～异动码8会计科目余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table asnn_file
(
asnn00      varchar2(5) DEFAULT ' ' NOT NULL, /*族群帐套*/
asnn01      varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
asnn02      varchar2(10) DEFAULT ' ' NOT NULL, /*合并个体编号*/
asnn03      varchar2(5) DEFAULT ' ' NOT NULL, /*合并个体帐套*/
asnn04      varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
asnn05      varchar2(30) DEFAULT ' ' NOT NULL, /*异动码5值*/
asnn06      varchar2(30) DEFAULT ' ' NOT NULL, /*异动码6值*/
asnn07      varchar2(30) DEFAULT ' ' NOT NULL, /*异动码7值*/
asnn08      varchar2(30) DEFAULT ' ' NOT NULL, /*异动码8值*/
asnn09      number(5) DEFAULT '0' NOT NULL, /*会计年度*/
asnn10      number(5) DEFAULT '0' NOT NULL, /*期别*/
asnn11      number(20,6) DEFAULT '0' NOT NULL, /*借方金额*/
asnn12      number(20,6) DEFAULT '0' NOT NULL, /*贷方金额*/
asnn13      number(10) DEFAULT '0' NOT NULL, /*借方总笔数*/
asnn14      number(10) DEFAULT '0' NOT NULL, /*贷方总笔数*/
asnn15      varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
asnnlegal   varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
asnn16      varchar2(10) DEFAULT ' ' NOT NULL, /*原始公司编号*/
asnn20      number(5) DEFAULT '0' NOT NULL, /*合并年度*/
asnn21      number(5) DEFAULT '0' NOT NULL /*合并期别*/
);

alter table asnn_file add  constraint asnn_pk primary key  (asnn00,asnn01,asnn02,asnn03,asnn04,asnn05,asnn06,asnn07,asnn08,asnn09,asnn10,asnn15,asnn16,asnn20,asnn21) enable validate;
grant select on asnn_file to tiptopgp;
grant update on asnn_file to tiptopgp;
grant delete on asnn_file to tiptopgp;
grant insert on asnn_file to tiptopgp;
grant index on asnn_file to public;
grant select on asnn_file to ods;
