/*
================================================================================
檔案代號:lnr_file
檔案名稱:付款方式資料檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lnr_file
(
lnr01       varchar2(10) DEFAULT ' ' NOT NULL, /*付款方式编号*/
lnr02       varchar2(20),            /*付款方式名称                           */
lnr03       number(5),               /*月份数                                 */
lnr04       varchar2(1)              /*有效否                                 */
);

alter table lnr_file add  constraint lnr_pk primary key  (lnr01) enable validate;
grant select on lnr_file to tiptopgp;
grant update on lnr_file to tiptopgp;
grant delete on lnr_file to tiptopgp;
grant insert on lnr_file to tiptopgp;
grant index on lnr_file to public;
grant select on lnr_file to ods;
