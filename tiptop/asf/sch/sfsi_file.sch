/*
================================================================================
檔案代號:sfsi_file
檔案名稱:工单发料底稿单身行业别档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sfsi_file
(
sfsi01      varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
sfsi02      number(5) DEFAULT '0' NOT NULL, /*项次*/
sfsiicd028  varchar2(80),            /*DATECODE                               */
sfsiicd029  varchar2(24),            /*母批                                   */
sfsilegal   varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
sfsiplant   varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table sfsi_file add  constraint sfsi_pk primary key  (sfsi01,sfsi02) enable validate;
grant select on sfsi_file to tiptopgp;
grant update on sfsi_file to tiptopgp;
grant delete on sfsi_file to tiptopgp;
grant insert on sfsi_file to tiptopgp;
grant index on sfsi_file to public;
grant select on sfsi_file to ods;
