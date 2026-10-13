/*
================================================================================
檔案代號:atc_file
檔案名稱:合并后会计科目各期余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table atc_file
(
atc00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐别*/
atc01       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
atc02       varchar2(10) DEFAULT ' ' NOT NULL, /*上层公司编号*/
atc03       varchar2(5) DEFAULT ' ' NOT NULL, /*上层帐套*/
atc04       varchar2(10) DEFAULT ' ' NOT NULL, /*下层公司编号*/
atc041      varchar2(5) DEFAULT ' ' NOT NULL, /*下层帐套*/
atc05       varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
atc06       number(5) DEFAULT '0' NOT NULL, /*会计年度*/
atc07       number(5) DEFAULT '0' NOT NULL, /*期别*/
atc08       number(20,6) DEFAULT '0' NOT NULL, /*借方金额*/
atc09       number(20,6) DEFAULT '0' NOT NULL, /*贷方金额*/
atc10       number(10) DEFAULT '0' NOT NULL, /*借方笔数*/
atc11       number(10) DEFAULT '0' NOT NULL, /*贷方笔数*/
atc12       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
atc13       varchar2(10) DEFAULT ' ' NOT NULL, /*版本*/
atc14       number(20,6) DEFAULT '0' NOT NULL, /*個體本位幣借方金額*/
atc15       number(20,6) DEFAULT '0' NOT NULL, /*個體本位幣貸方金額*/
atc16       varchar2(4),             /*个体本位币币种                         */
atc17       number(20,6) DEFAULT '0' NOT NULL, /*個體功能幣借方金額*/
atc18       number(20,6) DEFAULT '0' NOT NULL, /*個體功能幣貸方金額*/
atc19       varchar2(4),             /*個體功能幣幣別                         */
atc20       varchar2(10) DEFAULT ' ' NOT NULL, /*原始公司編碼*/
atclegal    varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

alter table atc_file add  constraint atc_pk primary key  (atc01,atc02,atc03,atc04,atc041,atc05,atc06,atc07,atc00,atc12,atc13,atc20) enable validate;
grant select on atc_file to tiptopgp;
grant update on atc_file to tiptopgp;
grant delete on atc_file to tiptopgp;
grant insert on atc_file to tiptopgp;
grant index on atc_file to public;
grant select on atc_file to ods;
