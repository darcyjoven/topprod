/*
================================================================================
檔案代號:ltb_file
檔案名稱:卡种/券种生效范围变更单身一档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ltb_file
(
ltb01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据号*/
ltb02       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
ltb03       number(5) DEFAULT '0' NOT NULL, /*项次*/
ltb04       varchar2(10),            /*门店编号                               */
ltb05       varchar2(20),            /*摊位编号                               */
ltb06       varchar2(1),             /*变更类型                               */
ltb07       varchar2(1) DEFAULT ' ' NOT NULL /*有效否*/
);

alter table ltb_file add  constraint ltb_pk primary key  (ltb01,ltb02,ltb03) enable validate;
grant select on ltb_file to tiptopgp;
grant update on ltb_file to tiptopgp;
grant delete on ltb_file to tiptopgp;
grant insert on ltb_file to tiptopgp;
grant index on ltb_file to public;
grant select on ltb_file to ods;
