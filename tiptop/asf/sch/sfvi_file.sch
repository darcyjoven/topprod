/*
================================================================================
檔案代號:sfvi_file
檔案名稱:工单完工入库单身行业别档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sfvi_file
(
sfvi01      varchar2(20) DEFAULT ' ' NOT NULL, /*入库编号*/
sfvi03      number(5) DEFAULT '0' NOT NULL, /*项次*/
sfviicd028  varchar2(80),            /*DATECODE                               */
sfviicd029  varchar2(24),            /*母批                                   */
sfvilegal   varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
sfviplant   varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table sfvi_file add  constraint sfvi_pk primary key  (sfvi01,sfvi03) enable validate;
grant select on sfvi_file to tiptopgp;
grant update on sfvi_file to tiptopgp;
grant delete on sfvi_file to tiptopgp;
grant insert on sfvi_file to tiptopgp;
grant index on sfvi_file to public;
grant select on sfvi_file to ods;
