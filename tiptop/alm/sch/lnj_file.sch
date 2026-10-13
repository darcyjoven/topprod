/*
================================================================================
檔案代號:lnj_file
檔案名稱:费用总类信息档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lnj_file
(
lnj01       varchar2(10) DEFAULT ' ' NOT NULL, /*费用总类编码*/
lnj02       varchar2(20),            /*费用总类名称                           */
lnj03       varchar2(1)              /*有效否                                 */
);

alter table lnj_file add  constraint lnj_pk primary key  (lnj01) enable validate;
grant select on lnj_file to tiptopgp;
grant update on lnj_file to tiptopgp;
grant delete on lnj_file to tiptopgp;
grant insert on lnj_file to tiptopgp;
grant index on lnj_file to public;
grant select on lnj_file to ods;
