/*
================================================================================
檔案代號:asn_file
檔案名稱:合并个体异动码会计科目余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table asn_file
(
asn00       varchar2(5) DEFAULT ' ' NOT NULL, /*族群帐套*/
asn01       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
asn02       varchar2(10) DEFAULT ' ' NOT NULL, /*合并个体编号*/
asn03       varchar2(5) DEFAULT ' ' NOT NULL, /*合并个体帐套*/
asn04       varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
asn05       varchar2(30) DEFAULT ' ' NOT NULL, /*异动码值*/
asn06       number(5) DEFAULT '0' NOT NULL, /*会计年度*/
asn07       number(5) DEFAULT '0' NOT NULL, /*期别*/
asn08       number(20,6) DEFAULT '0' NOT NULL, /*借方金额*/
asn09       number(20,6) DEFAULT '0' NOT NULL, /*贷方金额*/
asn10       number(10) DEFAULT '0' NOT NULL, /*借方总笔数*/
asn11       number(10) DEFAULT '0' NOT NULL, /*贷方总笔数*/
asn12       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
asn13       number(20,6) DEFAULT '0' NOT NULL, /*個體本位幣借方金額*/
asn14       number(20,6) DEFAULT '0' NOT NULL, /*個體本位幣貸方金額*/
asn15       varchar2(4),             /*个体本位币币种                         */
asn16       number(20,6) DEFAULT '0' NOT NULL, /*個體功能幣借方金額*/
asn17       number(20,6) DEFAULT '0' NOT NULL, /*個體功能幣貸方金額*/
asn18       varchar2(4),             /*個體功能幣幣別                         */
asn19       varchar2(10) DEFAULT ' ' NOT NULL, /*原始公司編碼*/
asnlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
asn20       number(5) DEFAULT '0' NOT NULL, /*合并年度*/
asn21       number(5) DEFAULT '0' NOT NULL /*合并期别*/
);

alter table asn_file add  constraint asn_pk primary key  (asn00,asn01,asn02,asn03,asn04,asn05,asn06,asn07,asn12,asn19,asn20,asn21) enable validate;
grant select on asn_file to tiptopgp;
grant update on asn_file to tiptopgp;
grant delete on asn_file to tiptopgp;
grant insert on asn_file to tiptopgp;
grant index on asn_file to public;
grant select on asn_file to ods;
