/*
================================================================================
檔案代號:tod_file
檔案名稱:广告地区资料维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tod_file
(
tod01       varchar2(10) NOT NULL,   /*区域                                   */
tod02       varchar2(10) NOT NULL,   /*省别                                   */
tod03       varchar2(10) NOT NULL,   /*地级市                                 */
tod04       varchar2(10) NOT NULL,   /*县                                     */
tod05       varchar2(10),            /*城市类型                               */
tod06       number(15,3),            /*城市面积                               */
tod07       number(20,6),            /*年均收入                               */
tod08       number(9),               /*人口数                                 */
tod09       number(9),               /*户数                                   */
tod10       number(9),               /*非农人口                               */
tod11       varchar2(255),           /*备注                                   */
todacti     varchar2(1),             /*有效否                                 */
toduser     varchar2(10),            /*建档人员                               */
todgrup     varchar2(10),            /*建档部门                               */
todmodu     varchar2(10),            /*最后更改人员                           */
toddate     date,                    /*最近更改日期                           */
todud01     varchar2(255),           /*自订字段-Textedit                      */
todud02     varchar2(40),            /*自订字段-文字                          */
todud03     varchar2(40),            /*自订字段-文字                          */
todud04     varchar2(40),            /*自订字段-文字                          */
todud05     varchar2(40),            /*自订字段-文字                          */
todud06     varchar2(40),            /*自订字段-文字                          */
todud07     number(15,3),            /*自订字段-数值                          */
todud08     number(15,3),            /*自订字段-数值                          */
todud09     number(15,3),            /*自订字段-数值                          */
todud10     number(10),              /*自订字段-整数                          */
todud11     number(10),              /*自订字段-整数                          */
todud12     number(10),              /*自订字段-整数                          */
todud13     date,                    /*自订字段-日期                          */
todud14     date,                    /*自订字段-日期                          */
todud15     date,                    /*自订字段-日期                          */
todoriu     varchar2(10),            /*资料建立者                             */
todorig     varchar2(10)             /*资料建立部门                           */
);

alter table tod_file add  constraint tod_pk primary key  (tod01,tod02,tod03,tod04) enable validate;
grant select on tod_file to tiptopgp;
grant update on tod_file to tiptopgp;
grant delete on tod_file to tiptopgp;
grant insert on tod_file to tiptopgp;
grant index on tod_file to public;
grant select on tod_file to ods;
