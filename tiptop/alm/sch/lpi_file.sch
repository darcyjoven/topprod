/*
================================================================================
檔案代號:lpi_file
檔案名稱:类别摊位生效范围资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lpi_file
(
lpi01       varchar2(20) DEFAULT ' ' NOT NULL, /*摊位编号*/
lpi02       varchar2(10),            /*no use                                 */
lpi03       varchar2(10),            /*楼栋编号                               */
lpi04       varchar2(10),            /*楼层编号                               */
lpi05       varchar2(10),            /*小类编号                               */
lpi06       varchar2(10),            /*中类编号                               */
lpi07       varchar2(10),            /*大类编号                               */
lpilegal    varchar2(10) NOT NULL,   /*所属法人                               */
lpiplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table lpi_file add  constraint lpi_pk primary key  (lpiplant,lpi01) enable validate;
grant select on lpi_file to tiptopgp;
grant update on lpi_file to tiptopgp;
grant delete on lpi_file to tiptopgp;
grant insert on lpi_file to tiptopgp;
grant index on lpi_file to public;
grant select on lpi_file to ods;
