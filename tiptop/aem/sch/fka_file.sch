/*
================================================================================
檔案代號:fka_file
檔案名稱:设备基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fka_file
(
fka01       varchar2(10) NOT NULL,   /*存放位置                               */
fka02       varchar2(80),            /*位置名称                               */
fka03       varchar2(10) NOT NULL,   /*存放营运中心                           */
fka40       varchar2(1),             /*No Use                                 */
fka41       varchar2(1),             /*No Use                                 */
fka42       varchar2(1),             /*No Use                                 */
fka43       varchar2(1),             /*No Use                                 */
fkaacti     varchar2(1)              /*有效码                                 */
);

alter table fka_file add  constraint fka_pk primary key  (fka01,fka03) enable validate;
grant select on fka_file to tiptopgp;
grant update on fka_file to tiptopgp;
grant delete on fka_file to tiptopgp;
grant insert on fka_file to tiptopgp;
grant index on fka_file to public;
grant select on fka_file to ods;
