/*
================================================================================
檔案代號:fjb_file
檔案名稱:设备备件资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fjb_file
(
fjb01       varchar2(20) NOT NULL,   /*设备编号                               */
fjb02       number(5) NOT NULL,      /*项次                                   */
fjb03       varchar2(40),            /*备件编号                               */
fjb04       varchar2(4),             /*类型                                   */
fjb05       varchar2(4),             /*单位                                   */
fjb06       number(15,3),            /*数量                                   */
fjbud01     varchar2(255),           /*自订字段-Textedit                      */
fjbud02     varchar2(40),            /*自订字段-文字                          */
fjbud03     varchar2(40),            /*自订字段-文字                          */
fjbud04     varchar2(40),            /*自订字段-文字                          */
fjbud05     varchar2(40),            /*自订字段-文字                          */
fjbud06     varchar2(40),            /*自订字段-文字                          */
fjbud07     number(15,3),            /*自订字段-数值                          */
fjbud08     number(15,3),            /*自订字段-数值                          */
fjbud09     number(15,3),            /*自订字段-数值                          */
fjbud10     number(10),              /*自订字段-整数                          */
fjbud11     number(10),              /*自订字段-整数                          */
fjbud12     number(10),              /*自订字段-整数                          */
fjbud13     date,                    /*自订字段-日期                          */
fjbud14     date,                    /*自订字段-日期                          */
fjbud15     date                     /*自订字段-日期                          */
);

alter table fjb_file add  constraint fjb_pk primary key  (fjb01,fjb02) enable validate;
grant select on fjb_file to tiptopgp;
grant update on fjb_file to tiptopgp;
grant delete on fjb_file to tiptopgp;
grant insert on fjb_file to tiptopgp;
grant index on fjb_file to public;
grant select on fjb_file to ods;
