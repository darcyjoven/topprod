/*
================================================================================
檔案代號:sfei_file
檔案名稱:工单料帐历史行业别档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table sfei_file
(
sfei02      varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
sfei28      number(5) DEFAULT '0' NOT NULL, /*单据项次*/
sfeiicd028  varchar2(80),            /*DATECODE                               */
sfeiicd029  varchar2(24),            /*母批                                   */
sfeilegal   varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
sfeiplant   varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table sfei_file add  constraint sfei_pk primary key  (sfei02,sfei28) enable validate;
grant select on sfei_file to tiptopgp;
grant update on sfei_file to tiptopgp;
grant delete on sfei_file to tiptopgp;
grant insert on sfei_file to tiptopgp;
grant index on sfei_file to public;
grant select on sfei_file to ods;
