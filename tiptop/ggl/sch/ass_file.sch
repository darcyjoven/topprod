/*
================================================================================
檔案代號:ass_file
檔案名稱:合并前科目异动码冲账余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ass_file
(
ass00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐别*/
ass01       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
ass02       varchar2(10) DEFAULT ' ' NOT NULL, /*上层公司编号*/
ass03       varchar2(5) DEFAULT ' ' NOT NULL, /*上层帐套*/
ass04       varchar2(10) DEFAULT ' ' NOT NULL, /*下层公司编号*/
ass041      varchar2(5) DEFAULT ' ' NOT NULL, /*下层帐套*/
ass05       varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
ass06       varchar2(2) DEFAULT ' ' NOT NULL, /*核算项顺序*/
ass07       varchar2(30) DEFAULT ' ' NOT NULL, /*异动码值*/
ass08       number(5) DEFAULT '0' NOT NULL, /*会计年度*/
ass09       number(5) DEFAULT '0' NOT NULL, /*期别*/
ass10       number(20,6) DEFAULT '0' NOT NULL, /*借方总金额*/
ass11       number(20,6) DEFAULT '0' NOT NULL, /*贷方总金额*/
ass12       number(10) DEFAULT '0' NOT NULL, /*借方总笔数*/
ass13       number(10) DEFAULT '0' NOT NULL, /*贷方总笔数*/
ass14       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
ass15       varchar2(10) DEFAULT ' ' NOT NULL, /*版本*/
ass16       number(20,10) DEFAULT '0' NOT NULL, /*功能币种汇率*/
ass17       number(20,10) DEFAULT '0' NOT NULL, /*合并币种汇率*/
ass18       number(20,6) DEFAULT '0' NOT NULL, /*下层公司原币种借方金额*/
ass19       number(20,6) DEFAULT '0' NOT NULL, /*下层公司原币种贷方金额*/
ass20       number(20,6) DEFAULT '0' NOT NULL, /*下层公司功能币种借方金额*/
ass21       number(20,6) DEFAULT '0' NOT NULL, /*下层公司功能币种贷方金额*/
ass22       varchar2(10) DEFAULT ' ' NOT NULL, /*原始公司編碼*/
ass23       varchar2(4),             /*功能币种                               */
ass24       varchar2(4),             /*原始公司币种                           */
asslegal    varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

alter table ass_file add  constraint ass_pk primary key  (ass01,ass02,ass03,ass04,ass041,ass05,ass07,ass08,ass09,ass00,ass06,ass14,ass15,ass22) enable validate;
grant select on ass_file to tiptopgp;
grant update on ass_file to tiptopgp;
grant delete on ass_file to tiptopgp;
grant insert on ass_file to tiptopgp;
grant index on ass_file to public;
grant select on ass_file to ods;
