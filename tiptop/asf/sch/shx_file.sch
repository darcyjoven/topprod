/*
================================================================================
檔案代號:shx_file
檔案名稱:生产日报档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table shx_file
(
shx01       varchar2(20) DEFAULT ' ' NOT NULL, /*移转单号*/
shx02       date,
shx03       varchar2(10),
shx04       varchar2(1),             /*审核码                                 */
shx05       varchar2(6),             /*作业编号                               */
shx06       varchar2(20),            /*PBI                                    */
shx07       varchar2(6),             /*飞票报工否                             */
shx08       varchar2(1),
shx09       varchar2(20),            /*飞票号码                               */
shx10       varchar2(1),             /*报工类型                               */
shxacti     varchar2(1),             /*资料有效否                             */
shxdate     date,                    /*最近更改日                             */
shxgrup     varchar2(10),
shxmodu     varchar2(10),            /*资料更改者                             */
shxuser     varchar2(10),            /*资料所有者                             */
shxplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
shxlegal    varchar2(10) NOT NULL,   /*所属法人                               */
shxoriu     varchar2(10),            /*资料建立者                             */
shxorig     varchar2(10)             /*资料建立部门                           */
);

alter table shx_file add  constraint shx_pk primary key  (shx01) enable validate;
grant select on shx_file to tiptopgp;
grant update on shx_file to tiptopgp;
grant delete on shx_file to tiptopgp;
grant insert on shx_file to tiptopgp;
grant index on shx_file to public;
grant select on shx_file to ods;
