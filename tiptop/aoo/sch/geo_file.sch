/*
================================================================================
檔案代號:geo_file
檔案名稱:地区资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table geo_file
(
geo01       varchar2(10) NOT NULL,   /*地区编号                               */
geo02       varchar2(80),            /*地区名称                               */
geo03       varchar2(10),            /*隶属国家                               */
geoacti     varchar2(1),             /*资料有效码                             */
geouser     varchar2(10),            /*资料所有者                             */
geogrup     varchar2(10),            /*资料所有部门                           */
geomodu     varchar2(10),            /*资料更改者                             */
geodate     date,                    /*最近更改日                             */
geoorig     varchar2(10),            /*资料建立部门                           */
geooriu     varchar2(10)             /*资料建立者                             */
);

alter table geo_file add  constraint geo_pk primary key  (geo01) enable validate;
grant select on geo_file to tiptopgp;
grant update on geo_file to tiptopgp;
grant delete on geo_file to tiptopgp;
grant insert on geo_file to tiptopgp;
grant index on geo_file to public;
grant select on geo_file to ods;
