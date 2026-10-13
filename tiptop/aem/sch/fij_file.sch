/*
================================================================================
檔案代號:fij_file
檔案名稱:设备用户自定义档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fij_file
(
fij01       varchar2(20) NOT NULL,   /*设备编号                               */
fij02       varchar2(10) NOT NULL,   /*自定义字段                             */
fij03       varchar2(80)             /*名称                                   */
);

alter table fij_file add  constraint fij_pk primary key  (fij01,fij02) enable validate;
grant select on fij_file to tiptopgp;
grant update on fij_file to tiptopgp;
grant delete on fij_file to tiptopgp;
grant insert on fij_file to tiptopgp;
grant index on fij_file to public;
grant select on fij_file to ods;
