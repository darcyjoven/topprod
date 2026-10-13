/*
================================================================================
檔案代號:too_file
檔案名稱:省别编号维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table too_file
(
too01       varchar2(10) NOT NULL,   /*省别编号                               */
too02       varchar2(80),            /*省别名称                               */
too03       varchar2(10),            /*区域编号                               */
tooacti     varchar2(1)              /*有效否                                 */
);

alter table too_file add  constraint too_pk primary key  (too01) enable validate;
grant select on too_file to tiptopgp;
grant update on too_file to tiptopgp;
grant delete on too_file to tiptopgp;
grant insert on too_file to tiptopgp;
grant index on too_file to public;
grant select on too_file to ods;
