/*
================================================================================
檔案代號:tut_file
檔案名稱:客户库存调整单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tut_file
(
tut01       varchar2(20) NOT NULL,   /*库存调整单                             */
tut02       number(5) NOT NULL,      /*项次                                   */
tut03       varchar2(40),            /*产品编号                               */
tut04       varchar2(24),            /*批号                                   */
tut05       varchar2(4),             /*单位                                   */
tut06       number(15,3),            /*数量                                   */
tut07       varchar2(255),           /*备注                                   */
tut08       varchar2(1),             /*库存异动类型                           */
tut09       varchar2(1),             /*No Use                                 */
tut10       varchar2(10),            /*No Use                                 */
tutud01     varchar2(255),           /*自订字段-Textedit                      */
tutud02     varchar2(40),            /*自订字段-文字                          */
tutud03     varchar2(40),            /*自订字段-文字                          */
tutud04     varchar2(40),            /*自订字段-文字                          */
tutud05     varchar2(40),            /*自订字段-文字                          */
tutud06     varchar2(40),            /*自订字段-文字                          */
tutud07     number(15,3),            /*自订字段-数值                          */
tutud08     number(15,3),            /*自订字段-数值                          */
tutud09     number(15,3),            /*自订字段-数值                          */
tutud10     number(10),              /*自订字段-整数                          */
tutud11     number(10),              /*自订字段-整数                          */
tutud12     number(10),              /*自订字段-整数                          */
tutud13     date,                    /*自订字段-日期                          */
tutud14     date,                    /*自订字段-日期                          */
tutud15     date,                    /*自订字段-日期                          */
tutplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tutlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table tut_file add  constraint tut_pk primary key  (tut01,tut02) enable validate;
grant select on tut_file to tiptopgp;
grant update on tut_file to tiptopgp;
grant delete on tut_file to tiptopgp;
grant insert on tut_file to tiptopgp;
grant index on tut_file to public;
grant select on tut_file to ods;
