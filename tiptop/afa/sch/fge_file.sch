/*
================================================================================
檔案代號:fge_file
檔案名稱:不良原因代码说明资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fge_file
(
fge01       varchar2(10) NOT NULL,   /*不良原因代码                           */
fge02       varchar2(1),             /*No Use                                 */
fge03       varchar2(80),            /*说明内容                               */
fge04       varchar2(1),             /*No Use                                 */
fgeacti     varchar2(1),             /*资料有效码                             */
fgeuser     varchar2(10),            /*原始资料建立者                         */
fgegrup     varchar2(10),            /*用户部门                               */
fgemodu     varchar2(10),            /*最后更改资料者                         */
fgedate     date,                    /*最后更改日期                           */
fgeorig     varchar2(10),            /*资料建立部门                           */
fgeoriu     varchar2(10)             /*资料建立者                             */
);

alter table fge_file add  constraint fge_pk primary key  (fge01) enable validate;
grant select on fge_file to tiptopgp;
grant update on fge_file to tiptopgp;
grant delete on fge_file to tiptopgp;
grant insert on fge_file to tiptopgp;
grant index on fge_file to public;
grant select on fge_file to ods;
