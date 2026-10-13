/*
================================================================================
檔案代號:lmw_file
檔案名稱:商户密码档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lmw_file
(
lmw01       varchar2(10) DEFAULT ' ' NOT NULL, /*商户号*/
lmw02       varchar2(10)             /*口令                                   */
);

alter table lmw_file add  constraint lmw_pk primary key  (lmw01) enable validate;
grant select on lmw_file to tiptopgp;
grant update on lmw_file to tiptopgp;
grant delete on lmw_file to tiptopgp;
grant insert on lmw_file to tiptopgp;
grant index on lmw_file to public;
grant select on lmw_file to ods;
