/*
================================================================================
檔案代號:adt_file
檔案名稱:客戶庫存調整單身檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table adt_file
(
adt01       varchar2(16),            /*庫存調整單                             */
adt02       number(5),               /*項次                                   */
adt03       varchar2(20),            /*商品編號                               */
adt04       varchar2(24),            /*批號                                   */
adt05       varchar2(4),             /*單位                                   */
adt06       number(15,3),            /*數量                                   */
adt07       varchar2(20)             /*備註                                   */
);

create unique index adt_01 on adt_file (adt01,adt02);
grant select on adt_file to public;
grant index on adt_file to public;
grant update on adt_file to public;
grant delete on adt_file to public;
grant insert on adt_file to public;
