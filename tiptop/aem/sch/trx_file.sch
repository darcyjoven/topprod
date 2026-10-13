/*
================================================================================
檔案代號:trx_file
檔案名稱:人员工种资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table trx_file
(
trx01       varchar2(6) NOT NULL,    /*工作种类                               */
trx02       varchar2(10) NOT NULL,   /*人员                                   */
trx03       varchar2(255)            /*备注                                   */
);

alter table trx_file add  constraint trx_pk primary key  (trx01,trx02) enable validate;
grant select on trx_file to tiptopgp;
grant update on trx_file to tiptopgp;
grant delete on trx_file to tiptopgp;
grant insert on trx_file to tiptopgp;
grant index on trx_file to public;
grant select on trx_file to ods;
