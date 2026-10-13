/*
================================================================================
檔案代號:oqw_file
檔案名稱:生产地资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oqw_file
(
oqw01       varchar2(10) NOT NULL,   /*生产地编号                             */
                                     /*生產地編號                             */
oqw02       varchar2(80),            /*生产地名称                             */
                                     /*生產地名稱                             */
oqw03       varchar2(10),            /*隶属国家编号                           */
                                     /*隸屬國別編號                           */
oqwacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
oqwuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
oqwgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
oqwmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
oqwdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
oqworig     varchar2(10),            /*资料建立部门                           */
oqworiu     varchar2(10)             /*资料建立者                             */
);

alter table oqw_file add  constraint oqw_pk primary key  (oqw01) enable validate;
grant select on oqw_file to tiptopgp;
grant update on oqw_file to tiptopgp;
grant delete on oqw_file to tiptopgp;
grant insert on oqw_file to tiptopgp;
grant index on oqw_file to public;
grant select on oqw_file to ods;
