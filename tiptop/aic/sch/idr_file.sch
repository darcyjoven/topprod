/*
================================================================================
檔案代號:idr_file
檔案名稱:ICD客户料件最低单价维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table idr_file
(
idr01       varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
idr02       varchar2(10) DEFAULT ' ' NOT NULL, /*客户编号*/
idr03       date DEFAULT sysdate NOT NULL, /*生效日期*/
idr04       number(20,6)             /*最低单价(本币)                         */
);

alter table idr_file add  constraint idr_pk primary key  (idr01,idr02,idr03) enable validate;
grant select on idr_file to tiptopgp;
grant update on idr_file to tiptopgp;
grant delete on idr_file to tiptopgp;
grant insert on idr_file to tiptopgp;
grant index on idr_file to public;
grant select on idr_file to ods;
