/*
================================================================================
檔案代號:toa_file
檔案名稱:媒体编号资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table toa_file
(
toa01       varchar2(4) NOT NULL,    /*媒体编号                               */
toa02       varchar2(80),            /*媒体名称                               */
toa03       varchar2(1),             /*类型                                   */
toaacti     varchar2(1)              /*有效否                                 */
);

alter table toa_file add  constraint toa_pk primary key  (toa01) enable validate;
grant select on toa_file to tiptopgp;
grant update on toa_file to tiptopgp;
grant delete on toa_file to tiptopgp;
grant insert on toa_file to tiptopgp;
grant index on toa_file to public;
grant select on toa_file to ods;
