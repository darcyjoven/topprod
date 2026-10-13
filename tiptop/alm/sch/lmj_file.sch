/*
================================================================================
檔案代號:lmj_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lmj_file
(
lmj01       varchar2(10) DEFAULT ' ' NOT NULL, /*中类编号*/
lmj02       varchar2(60),            /*中类名称                               */
lmj03       varchar2(10),            /*大类编号                               */
lmj04       varchar2(1)              /*有效否                                 */
);

alter table lmj_file add  constraint lmj_pk primary key  (lmj01) enable validate;
grant select on lmj_file to tiptopgp;
grant update on lmj_file to tiptopgp;
grant delete on lmj_file to tiptopgp;
grant insert on lmj_file to tiptopgp;
grant index on lmj_file to public;
grant select on lmj_file to ods;
