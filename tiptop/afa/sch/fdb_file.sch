/*
================================================================================
檔案代號:fdb_file
檔案名稱:保险标的物单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fdb_file
(
fdb01       varchar2(20) NOT NULL,   /*保单编号                               */
fdb02       number(5) NOT NULL,      /*序号                                   */
fdb03       varchar2(80),            /*保险标的物                             */
fdb04       varchar2(80),            /*使用性质名称                           */
fdb05       varchar2(10),            /*部门                                   */
fdb06       number(20,6),            /*保险金额                               */
fdb07       number(9,4),             /*保险费率                               */
fdb08       number(20,6),            /*保险费                                 */
fdb09       number(9,4),             /*全额保险率                             */
fdb10       varchar2(1),             /*No Use                                 */
fdb11       varchar2(1),             /*No Use                                 */
fdb12       varchar2(1),             /*No Use                                 */
fdbud01     varchar2(255),           /*自订字段-Textedit                      */
fdbud02     varchar2(40),            /*自订字段-文字                          */
fdbud03     varchar2(40),            /*自订字段-文字                          */
fdbud04     varchar2(40),            /*自订字段-文字                          */
fdbud05     varchar2(40),            /*自订字段-文字                          */
fdbud06     varchar2(40),            /*自订字段-文字                          */
fdbud07     number(15,3),            /*自订字段-数值                          */
fdbud08     number(15,3),            /*自订字段-数值                          */
fdbud09     number(15,3),            /*自订字段-数值                          */
fdbud10     number(10),              /*自订字段-整数                          */
fdbud11     number(10),              /*自订字段-整数                          */
fdbud12     number(10),              /*自订字段-整数                          */
fdbud13     date,                    /*自订字段-日期                          */
fdbud14     date,                    /*自订字段-日期                          */
fdbud15     date,                    /*自订字段-日期                          */
fdblegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table fdb_file add  constraint fdb_pk primary key  (fdb01,fdb02) enable validate;
grant select on fdb_file to tiptopgp;
grant update on fdb_file to tiptopgp;
grant delete on fdb_file to tiptopgp;
grant insert on fdb_file to tiptopgp;
grant index on fdb_file to public;
grant select on fdb_file to ods;
