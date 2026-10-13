/*
================================================================================
檔案代號:lmk_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lmk_file
(
lmk01       varchar2(10) DEFAULT ' ' NOT NULL, /*小类编号*/
lmk02       varchar2(60),            /*小类名称                               */
lmk03       varchar2(10),            /*中类编号                               */
lmk04       varchar2(10),            /*大类编号                               */
lmk05       varchar2(1)              /*有效否                                 */
);

alter table lmk_file add  constraint lmk_pk primary key  (lmk01) enable validate;
grant select on lmk_file to tiptopgp;
grant update on lmk_file to tiptopgp;
grant delete on lmk_file to tiptopgp;
grant insert on lmk_file to tiptopgp;
grant index on lmk_file to public;
grant select on lmk_file to ods;
