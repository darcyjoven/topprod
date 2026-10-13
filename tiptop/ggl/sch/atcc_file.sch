/*
================================================================================
檔案代號:atcc_file
檔案名稱:合并冲销后会计科目异动码余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table atcc_file
(
atcc00      varchar2(5) DEFAULT ' ' NOT NULL, /*帐别*/
atcc01      varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
atcc02      varchar2(10) DEFAULT ' ' NOT NULL, /*上层公司编号*/
atcc03      varchar2(5) DEFAULT ' ' NOT NULL, /*上层帐套*/
atcc04      varchar2(10) DEFAULT ' ' NOT NULL, /*下层公司编号*/
atcc041     varchar2(5) DEFAULT ' ' NOT NULL, /*下层帐套*/
atcc05      varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
atcc06      varchar2(2) DEFAULT ' ' NOT NULL, /*核算项顺序*/
atcc07      varchar2(30) DEFAULT ' ' NOT NULL, /*异动码值*/
atcc08      number(5) DEFAULT '0' NOT NULL, /*会计年度*/
atcc09      number(5) DEFAULT '0' NOT NULL, /*期别*/
atcc10      number(20,6) DEFAULT '0' NOT NULL, /*借方总金额*/
atcc11      number(20,6) DEFAULT '0' NOT NULL, /*贷方总金额*/
atcc12      number(10) DEFAULT '0' NOT NULL, /*借方总笔数*/
atcc13      number(10) DEFAULT '0' NOT NULL, /*贷方总笔数*/
atcc14      varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
atcc15      varchar2(10) DEFAULT ' ' NOT NULL, /*版本*/
atcc16      number(20,6) DEFAULT '0' NOT NULL, /*個體本位幣借方金額*/
atcc17      number(20,6) DEFAULT '0' NOT NULL, /*個體本位幣貸方金額*/
atcc18      varchar2(4),             /*个体本位币币种                         */
atcc19      number(20,6) DEFAULT '0' NOT NULL, /*個體功能幣借方金額*/
atcc20      number(20,6) DEFAULT '0' NOT NULL, /*個體功能幣貸方金額*/
atcc21      varchar2(4),             /*個體功能幣幣別                         */
atcc22      varchar2(10) DEFAULT ' ' NOT NULL, /*原始公司編碼*/
atcclegal   varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

alter table atcc_file add  constraint atcc_pk primary key  (atcc01,atcc02,atcc03,atcc04,atcc041,atcc05,atcc07,atcc08,atcc09,atcc00,atcc06,atcc14,atcc15,atcc22) enable validate;
grant select on atcc_file to tiptopgp;
grant update on atcc_file to tiptopgp;
grant delete on atcc_file to tiptopgp;
grant insert on atcc_file to tiptopgp;
grant index on atcc_file to public;
grant select on atcc_file to ods;
