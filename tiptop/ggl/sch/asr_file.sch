/*
================================================================================
檔案代號:asr_file
檔案名稱:合并前会计科目各期余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table asr_file
(
asr00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
asr01       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
asr02       varchar2(10) DEFAULT ' ' NOT NULL, /*上层公司编号*/
asr03       varchar2(5) DEFAULT ' ' NOT NULL, /*上层帐套*/
asr04       varchar2(10) DEFAULT ' ' NOT NULL, /*下层公司编号*/
asr041      varchar2(5) DEFAULT ' ' NOT NULL, /*下层帐套*/
asr05       varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
asr06       number(5) DEFAULT '0' NOT NULL, /*会计年度*/
asr07       number(5) DEFAULT '0' NOT NULL, /*期别*/
asr08       number(20,6) DEFAULT '0' NOT NULL, /*借方金额*/
asr09       number(20,6) DEFAULT '0' NOT NULL, /*贷方金额*/
asr10       number(10) DEFAULT '0' NOT NULL, /*借方笔数*/
asr11       number(10) DEFAULT '0' NOT NULL, /*贷方笔数*/
asr12       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
asr13       number(20,6) DEFAULT '0' NOT NULL, /*下层公司原币种借方金额*/
asr14       number(20,6) DEFAULT '0' NOT NULL, /*下层公司原币种贷方金额*/
asr15       number(20,6) DEFAULT '0' NOT NULL, /*功能币种借方金额*/
asr16       number(20,6) DEFAULT '0' NOT NULL, /*功能币种贷方金额*/
asr17       varchar2(10) DEFAULT ' ' NOT NULL, /*版本*/
asr18       number(20,10) DEFAULT '0' NOT NULL, /*功能币种汇率*/
asr19       number(20,10) DEFAULT '0' NOT NULL, /*合并币种汇率*/
asr20       varchar2(10) DEFAULT ' ' NOT NULL, /*原始公司編碼*/
asr21       varchar2(4),             /*功能币种                               */
asr22       varchar2(4),             /*原始公司币种                           */
asrlegal    varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

alter table asr_file add  constraint asr_pk primary key  (asr01,asr02,asr03,asr04,asr041,asr05,asr06,asr07,asr00,asr12,asr17,asr20) enable validate;
grant select on asr_file to tiptopgp;
grant update on asr_file to tiptopgp;
grant delete on asr_file to tiptopgp;
grant insert on asr_file to tiptopgp;
grant index on asr_file to public;
grant select on asr_file to ods;
