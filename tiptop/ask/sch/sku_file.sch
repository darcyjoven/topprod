/*
================================================================================
檔案代號:sku_file
檔案名稱:裁剪布料预算单头文件
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sku_file
(
sku01       varchar2(20) DEFAULT ' ' NOT NULL, /*制单号*/
sku02       varchar2(20) DEFAULT ' ' NOT NULL, /*款式号*/
sku03       date,                    /*制定日期                               */
sku04       varchar2(6),             /*no use                                 */
sku05       varchar2(6),             /*颜色编码                               */
sku06       number(15,3),            /*no use                                 */
sku07       varchar2(40),
sku08       number(5),               /*no use                                 */
sku09       varchar2(10),
sku10       varchar2(10),
sku11       varchar2(10),
skuconf     varchar2(1),
skudate     date,                    /*资料更改日期                           */
skugrup     varchar2(10),
skumemo     varchar2(255),           /*備注                                   */
skumodu     varchar2(10),            /*资料更改者                             */
skuuser     varchar2(10),            /*资料用户                               */
skuplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
skulegal    varchar2(10) NOT NULL,   /*所属法人                               */
skuoriu     varchar2(10),            /*资料建立者                             */
skuorig     varchar2(10)             /*资料建立部门                           */
);

alter table sku_file add  constraint sku_pk primary key  (sku01,sku02) enable validate;
grant select on sku_file to tiptopgp;
grant update on sku_file to tiptopgp;
grant delete on sku_file to tiptopgp;
grant insert on sku_file to tiptopgp;
grant index on sku_file to public;
grant select on sku_file to ods;
