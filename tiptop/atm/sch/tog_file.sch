/*
================================================================================
檔案代號:tog_file
檔案名稱:媒体基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tog_file
(
tog01       varchar2(10) NOT NULL,   /*媒体编号                               */
tog02       number(5) NOT NULL,      /*项次                                   */
tog03       varchar2(5),             /*起始时段                               */
tog04       varchar2(5),             /*截止时段                               */
tog05       varchar2(4),             /*单位                                   */
tog06       number(20,6),            /*单价                                   */
tog07       varchar2(255),           /*备注                                   */
togud01     varchar2(255),           /*自订字段-Textedit                      */
togud02     varchar2(40),            /*自订字段-文字                          */
togud03     varchar2(40),            /*自订字段-文字                          */
togud04     varchar2(40),            /*自订字段-文字                          */
togud05     varchar2(40),            /*自订字段-文字                          */
togud06     varchar2(40),            /*自订字段-文字                          */
togud07     number(15,3),            /*自订字段-数值                          */
togud08     number(15,3),            /*自订字段-数值                          */
togud09     number(15,3),            /*自订字段-数值                          */
togud10     number(10),              /*自订字段-整数                          */
togud11     number(10),              /*自订字段-整数                          */
togud12     number(10),              /*自订字段-整数                          */
togud13     date,                    /*自订字段-日期                          */
togud14     date,                    /*自订字段-日期                          */
togud15     date                     /*自订字段-日期                          */
);

alter table tog_file add  constraint tog_pk primary key  (tog01,tog02) enable validate;
grant select on tog_file to tiptopgp;
grant update on tog_file to tiptopgp;
grant delete on tog_file to tiptopgp;
grant insert on tog_file to tiptopgp;
grant index on tog_file to public;
grant select on tog_file to ods;
