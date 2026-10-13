/*
================================================================================
檔案代號:fio_file
檔案名稱:设备保修项目资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fio_file
(
fio01       varchar2(10) NOT NULL,   /*项目编号                               */
fio02       varchar2(80),            /*说明                                   */
fio03       number(8,3),             /*预备工时,单位小时                      */
fio04       number(8,3),             /*标准工时,单位小时                      */
fio05       varchar2(1),             /*保修类型                               */
fio06       varchar2(2),             /*保养周期                               */
fio07       varchar2(2),             /*保修规模                               */
fio08       varchar2(1),             /*停机否                                 */
fio09       varchar2(1),             /*No                                     */
fio10       varchar2(1),             /*No                                     */
fioacti     varchar2(1),             /*资料有效码                             */
fiouser     varchar2(10),            /*资料所有者                             */
fiogrup     varchar2(10),            /*资料所有部门                           */
fiomodu     varchar2(10),            /*最后更改人员                           */
fiodate     date,                    /*最后更改日期                           */
fiooriu     varchar2(10),            /*资料建立者                             */
fioorig     varchar2(10)             /*资料建立部门                           */
);

alter table fio_file add  constraint fio_pk primary key  (fio01) enable validate;
grant select on fio_file to tiptopgp;
grant update on fio_file to tiptopgp;
grant delete on fio_file to tiptopgp;
grant insert on fio_file to tiptopgp;
grant index on fio_file to public;
grant select on fio_file to ods;
