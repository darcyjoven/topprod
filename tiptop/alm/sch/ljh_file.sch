/*
================================================================================
檔案代號:ljh_file
檔案名稱:商户退场报告单身二档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ljh_file
(
ljh01       varchar2(20) DEFAULT ' ' NOT NULL, /*退场单号*/
ljh02       number(5) DEFAULT '0' NOT NULL, /*项次*/
ljh03       varchar2(10),            /*费用编号                               */
ljh04       number(20,6),            /*费用金额                               */
ljhlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
ljhplant    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table ljh_file add  constraint ljh_pk primary key  (ljh01,ljh02) enable validate;
grant select on ljh_file to tiptopgp;
grant update on ljh_file to tiptopgp;
grant delete on ljh_file to tiptopgp;
grant insert on ljh_file to tiptopgp;
grant index on ljh_file to public;
grant select on ljh_file to ods;
