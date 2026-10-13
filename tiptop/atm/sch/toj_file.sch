/*
================================================================================
檔案代號:toj_file
檔案名稱:媒体代码说明资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table toj_file
(
toj01       varchar2(10) NOT NULL,   /*媒体编号                               */
toj02       varchar2(40) NOT NULL,   /*品牌                                   */
toj03       varchar2(255),           /*备注                                   */
tojacti     varchar2(1),             /*有效否                                 */
tojuser     varchar2(10),            /*建档人员                               */
tojgrup     varchar2(10),            /*建档部门                               */
tojmodu     varchar2(10),            /*最后更改人员                           */
tojdate     date,                    /*最近更改日期                           */
tojud01     varchar2(255),           /*自订字段-Textedit                      */
tojud02     varchar2(40),            /*自订字段-文字                          */
tojud03     varchar2(40),            /*自订字段-文字                          */
tojud04     varchar2(40),            /*自订字段-文字                          */
tojud05     varchar2(40),            /*自订字段-文字                          */
tojud06     varchar2(40),            /*自订字段-文字                          */
tojud07     number(15,3),            /*自订字段-数值                          */
tojud08     number(15,3),            /*自订字段-数值                          */
tojud09     number(15,3),            /*自订字段-数值                          */
tojud10     number(10),              /*自订字段-整数                          */
tojud11     number(10),              /*自订字段-整数                          */
tojud12     number(10),              /*自订字段-整数                          */
tojud13     date,                    /*自订字段-日期                          */
tojud14     date,                    /*自订字段-日期                          */
tojud15     date,                    /*自订字段-日期                          */
tojoriu     varchar2(10),            /*资料建立者                             */
tojorig     varchar2(10)             /*资料建立部门                           */
);

alter table toj_file add  constraint toj_pk primary key  (toj01,toj02) enable validate;
grant select on toj_file to tiptopgp;
grant update on toj_file to tiptopgp;
grant delete on toj_file to tiptopgp;
grant insert on toj_file to tiptopgp;
grant index on toj_file to public;
grant select on toj_file to ods;
