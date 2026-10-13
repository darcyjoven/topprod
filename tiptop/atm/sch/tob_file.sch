/*
================================================================================
檔案代號:tob_file
檔案名稱:区域编号资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tob_file
(
tob01       varchar2(10) NOT NULL,   /*区域编号                               */
tob02       varchar2(80),            /*区域名称                               */
tobacti     varchar2(1)              /*资料有效码                             */
);

alter table tob_file add  constraint tob_pk primary key  (tob01) enable validate;
grant select on tob_file to tiptopgp;
grant update on tob_file to tiptopgp;
grant delete on tob_file to tiptopgp;
grant insert on tob_file to tiptopgp;
grant index on tob_file to public;
grant select on tob_file to ods;
