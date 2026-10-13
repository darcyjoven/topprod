/*
================================================================================
檔案代號:ltc_file
檔案名稱:卡种/券种生效范围变更单身二档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ltc_file
(
ltc01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据号*/
ltc02       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
ltc03       varchar2(20) DEFAULT ' ' NOT NULL /*编号*/
);

alter table ltc_file add  constraint ltc_pk primary key  (ltc01,ltc02,ltc03) enable validate;
grant select on ltc_file to tiptopgp;
grant update on ltc_file to tiptopgp;
grant delete on ltc_file to tiptopgp;
grant insert on ltc_file to tiptopgp;
grant index on ltc_file to public;
grant select on ltc_file to ods;
