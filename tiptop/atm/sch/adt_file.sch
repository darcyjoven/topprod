/*
================================================================================
檔案代號:adt_file
檔案名稱:NO USE
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table adt_file
(
adt01       varchar2(20) NOT NULL,   /*库存调整单                             */
adt02       number(5) NOT NULL,      /*项次                                   */
adt03       varchar2(40),            /*产品编号                               */
adt04       varchar2(24),            /*批号                                   */
adt05       varchar2(4),             /*单位                                   */
adt06       number(15,3),            /*数量                                   */
adt07       varchar2(255)            /*备注                                   */
);

alter table adt_file add  constraint adt_pk primary key  (adt01,adt02) enable validate;
grant select on adt_file to tiptopgp;
grant update on adt_file to tiptopgp;
grant delete on adt_file to tiptopgp;
grant insert on adt_file to tiptopgp;
grant index on adt_file to public;
grant select on adt_file to ods;
