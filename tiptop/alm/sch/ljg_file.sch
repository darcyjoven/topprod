/*
================================================================================
檔案代號:ljg_file
檔案名稱:商户退场报告单身一档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ljg_file
(
ljg01       varchar2(20) DEFAULT ' ' NOT NULL, /*退场单号*/
ljg02       number(5) DEFAULT '0' NOT NULL, /*项次*/
ljg03       varchar2(10),            /*费用编号                               */
ljg04       number(20,6),            /*费用金额                               */
ljglegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
ljgplant    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table ljg_file add  constraint ljg_pk primary key  (ljg01,ljg02) enable validate;
grant select on ljg_file to tiptopgp;
grant update on ljg_file to tiptopgp;
grant delete on ljg_file to tiptopgp;
grant insert on ljg_file to tiptopgp;
grant index on ljg_file to public;
grant select on ljg_file to ods;
