/*
================================================================================
檔案代號:obb_file
檔案名稱:产品大类档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table obb_file
(
obb01       varchar2(1) NOT NULL,    /*产品大类码                             */
                                     /*產品大類碼                             */
obb02       varchar2(80),            /*大类名称                               */
                                     /*大類名稱                               */
obb03       varchar2(1),             /*No Use                                 */
obb04       varchar2(1),             /*No Use                                 */
obb05       varchar2(1),             /*No Use                                 */
obb06       varchar2(1)              /*No Use                                 */
);

alter table obb_file add  constraint obb_pk primary key  (obb01) enable validate;
grant select on obb_file to tiptopgp;
grant update on obb_file to tiptopgp;
grant delete on obb_file to tiptopgp;
grant insert on obb_file to tiptopgp;
grant index on obb_file to public;
grant select on obb_file to ods;
