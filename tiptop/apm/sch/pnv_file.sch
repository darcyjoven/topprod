/*
================================================================================
檔案代號:pnv_file
檔案名稱:采购流程资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pnv_file
(
pnv01       varchar2(10) NOT NULL,   /*采购中心代码                           */
pnv02       varchar2(10) NOT NULL,   /*需求营运中心                           */
pnv03       varchar2(5),             /*缺省采购单别                           */
pnv04       varchar2(8),             /*缺省采购流程                           */
pnvacti     varchar2(1),             /*资料有效码                             */
pnvuser     varchar2(10),            /*资料所有者                             */
pnvgrup     varchar2(10),            /*资料所有群                             */
pnvmodu     varchar2(10),            /*资料更改者                             */
pnvdate     date,                    /*最近更改日                             */
pnvorig     varchar2(10),            /*资料建立部门                           */
pnvoriu     varchar2(10)             /*资料建立者                             */
);

alter table pnv_file add  constraint pnv_pk primary key  (pnv01,pnv02) enable validate;
grant select on pnv_file to tiptopgp;
grant update on pnv_file to tiptopgp;
grant delete on pnv_file to tiptopgp;
grant insert on pnv_file to tiptopgp;
grant index on pnv_file to public;
grant select on pnv_file to ods;
