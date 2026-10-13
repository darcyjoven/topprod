/*
================================================================================
檔案代號:toh_file
檔案名稱:省台广告费分摊比率档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table toh_file
(
toh01       varchar2(10) NOT NULL,   /*省别                                   */
toh02       varchar2(10) NOT NULL,   /*媒体编号                               */
toh03       varchar2(255),           /*备注                                   */
tohacti     varchar2(1),             /*有效否                                 */
tohuser     varchar2(10),            /*建档人员                               */
tohgrup     varchar2(10),            /*建档部门                               */
tohmodu     varchar2(10),            /*最后更改者                             */
tohdate     date,                    /*最近更改日                             */
tohud01     varchar2(255),           /*自订字段-Textedit                      */
tohud02     varchar2(40),            /*自订字段-文字                          */
tohud03     varchar2(40),            /*自订字段-文字                          */
tohud04     varchar2(40),            /*自订字段-文字                          */
tohud05     varchar2(40),            /*自订字段-文字                          */
tohud06     varchar2(40),            /*自订字段-文字                          */
tohud07     number(15,3),            /*自订字段-数值                          */
tohud08     number(15,3),            /*自订字段-数值                          */
tohud09     number(15,3),            /*自订字段-数值                          */
tohud10     number(10),              /*自订字段-整数                          */
tohud11     number(10),              /*自订字段-整数                          */
tohud12     number(10),              /*自订字段-整数                          */
tohud13     date,                    /*自订字段-日期                          */
tohud14     date,                    /*自订字段-日期                          */
tohud15     date,                    /*自订字段-日期                          */
tohoriu     varchar2(10),            /*资料建立者                             */
tohorig     varchar2(10)             /*资料建立部门                           */
);

alter table toh_file add  constraint toh_pk primary key  (toh01,toh02) enable validate;
grant select on toh_file to tiptopgp;
grant update on toh_file to tiptopgp;
grant delete on toh_file to tiptopgp;
grant insert on toh_file to tiptopgp;
grant index on toh_file to public;
grant select on toh_file to ods;
