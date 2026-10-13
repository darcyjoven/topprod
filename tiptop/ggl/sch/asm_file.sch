/*
================================================================================
檔案代號:asm_file
檔案名稱:合并个体会计科目余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table asm_file
(
asm00       varchar2(5) DEFAULT ' ' NOT NULL, /*族群帐套*/
asm01       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
asm02       varchar2(10) DEFAULT ' ' NOT NULL, /*合并个体编号*/
asm03       varchar2(5) DEFAULT ' ' NOT NULL, /*合并个体帐套*/
asm04       varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
asm05       number(5) DEFAULT '0' NOT NULL, /*会计年度*/
asm06       number(5) DEFAULT '0' NOT NULL, /*期别*/
asm07       number(20,6) DEFAULT '0' NOT NULL, /*借方金额*/
asm08       number(20,6) DEFAULT '0' NOT NULL, /*贷方金额*/
asm09       number(10) DEFAULT '0' NOT NULL, /*借方总笔数*/
asm10       number(10) DEFAULT '0' NOT NULL, /*贷方总笔数*/
asm11       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
asm12       number(20,6) DEFAULT '0' NOT NULL, /*個體本位幣借方金額*/
asm13       number(20,6) DEFAULT '0' NOT NULL, /*個體本位幣貸方金額*/
asm14       varchar2(4),             /*个体本位币币别                         */
asm15       number(20,6) DEFAULT '0' NOT NULL, /*个体功能币借方金额*/
asm16       number(20,6) DEFAULT '0' NOT NULL, /*个体功能币贷方金额*/
asm17       varchar2(4),             /*個體功能幣幣別                         */
asm18       varchar2(10) DEFAULT ' ' NOT NULL, /*原始公司編碼*/
asmlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
asm20       number(5) DEFAULT '0' NOT NULL, /*合并年度*/
asm21       number(5) DEFAULT '0' NOT NULL /*合并期别*/
);

alter table asm_file add  constraint asm_pk primary key  (asm00,asm01,asm02,asm03,asm04,asm05,asm06,asm11,asm18,asm20,asm21) enable validate;
grant select on asm_file to tiptopgp;
grant update on asm_file to tiptopgp;
grant delete on asm_file to tiptopgp;
grant insert on asm_file to tiptopgp;
grant index on asm_file to public;
grant select on asm_file to ods;
