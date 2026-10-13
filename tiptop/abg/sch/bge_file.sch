/*
================================================================================
檔案代號:bge_file
檔案名稱:部门预计人力维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bge_file
(
bge01       varchar2(10) NOT NULL,   /*版本                                   */
bge02       varchar2(10) NOT NULL,   /*部门                                   */
                                     /*部門                                   */
bge03       number(5) NOT NULL,      /*年度                                   */
bge04       number(5) NOT NULL,      /*月份                                   */
bge05       varchar2(10) NOT NULL,   /*职等编号                               */
                                     /*職等代號                               */
bge06       number(5) NOT NULL,      /*职级编号                               */
                                     /*職級代號                               */
bge07       number(5),               /*编制人力                               */
                                     /*編製人力(直接)                         */
bge08       number(15,3),            /*未超时加班时数(直接)                   */
                                     /*未超時加班時數(直接)                   */
bge09       number(5),               /*编制人力                               */
                                     /*編製人力(間接)                         */
bge10       number(15,3),            /*未超时加班时数(间接)                   */
                                     /*未超時加班時數(間接)                   */
bge11       number(15,3),            /*超时加班时数                           */
                                     /*超時加班時數(直接)                     */
bge12       number(15,3),            /*超时加班时数                           */
                                     /*超時加班時數(間接)                     */
bgedate     date,                    /*最近更改日                             */
bgegrup     varchar2(10),            /*资料所有部门                           */
bgemodu     varchar2(10),            /*资料更改者                             */
bgeuser     varchar2(10),            /*资料所有者                             */
bgeorig     varchar2(10),            /*资料建立部门                           */
bgeoriu     varchar2(10)             /*资料建立者                             */
);

alter table bge_file add  constraint bge_pk primary key  (bge01,bge02,bge03,bge04,bge05,bge06) enable validate;
grant select on bge_file to tiptopgp;
grant update on bge_file to tiptopgp;
grant delete on bge_file to tiptopgp;
grant insert on bge_file to tiptopgp;
grant index on bge_file to public;
grant select on bge_file to ods;
