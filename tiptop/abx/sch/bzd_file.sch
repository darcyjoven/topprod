/*
================================================================================
檔案代號:bzd_file
檔案名稱:保税机器设备记账卡单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bzd_file
(
bzd01       varchar2(20) NOT NULL,   /*记帐卡编号                             */
bzd02       number(5) NOT NULL,      /*序号                                   */
bzd03       varchar2(20),            /*机器设备编号                           */
bzd04       varchar2(255),           /*备注                                   */
bzd05       varchar2(1),             /*No Use                                 */
bzdud01     varchar2(255),           /*自订字段-Textedit                      */
bzdud02     varchar2(40),            /*自订字段-文字                          */
bzdud03     varchar2(40),            /*自订字段-文字                          */
bzdud04     varchar2(40),            /*自订字段-文字                          */
bzdud05     varchar2(40),            /*自订字段-文字                          */
bzdud06     varchar2(40),            /*自订字段-文字                          */
bzdud07     number(15,3),            /*自订字段-数值                          */
bzdud08     number(15,3),            /*自订字段-数值                          */
bzdud09     number(15,3),            /*自订字段-数值                          */
bzdud10     number(10),              /*自订字段-整数                          */
bzdud11     number(10),              /*自订字段-整数                          */
bzdud12     number(10),              /*自订字段-整数                          */
bzdud13     date,                    /*自订字段-日期                          */
bzdud14     date,                    /*自订字段-日期                          */
bzdud15     date                     /*自订字段-日期                          */
);

alter table bzd_file add  constraint bzd_pk primary key  (bzd01,bzd02) enable validate;
grant select on bzd_file to tiptopgp;
grant update on bzd_file to tiptopgp;
grant delete on bzd_file to tiptopgp;
grant insert on bzd_file to tiptopgp;
grant index on bzd_file to public;
grant select on bzd_file to ods;
