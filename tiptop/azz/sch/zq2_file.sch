/*
================================================================================
檔案代號:zq2_file
檔案名稱:字段说明档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zq2_file
(
zq201       number(5) NOT NULL,      /*Column code                            */
zq202       varchar2(2),             /*No Use                                 */
zq203       varchar2(2)              /*No Use                                 */
);

alter table zq2_file add  constraint zq2_pk primary key  (zq201) enable validate;
grant select on zq2_file to tiptopgp;
grant update on zq2_file to tiptopgp;
grant delete on zq2_file to tiptopgp;
grant insert on zq2_file to tiptopgp;
grant index on zq2_file to public;
grant select on zq2_file to ods;
