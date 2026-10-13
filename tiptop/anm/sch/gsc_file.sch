/*
================================================================================
檔案代號:gsc_file
檔案名稱:票券外汇投资基本资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table gsc_file
(
gsc01       varchar2(20) NOT NULL,   /*投资单号                               */
gsc02       varchar2(20) NOT NULL,   /*异动单号(购买单号/平仓单号)            */
gsc03       date,                    /*异动日期                               */
gsc04       number(15,3),            /*数量                                   */
gsc05       number(20,6),            /*单价                                   */
gsc06       number(20,6),            /*金额                                   */
gsc07       number(5),               /*类型                                   */
gsc08       varchar2(6),             /*费用编号                               */
gsc09       number(20,6),            /*费用金额                               */
gsc10       varchar2(1),             /*No Use                                 */
gscud01     varchar2(255),           /*自订字段-Textedit                      */
gscud02     varchar2(40),            /*自订字段-文字                          */
gscud03     varchar2(40),            /*自订字段-文字                          */
gscud04     varchar2(40),            /*自订字段-文字                          */
gscud05     varchar2(40),            /*自订字段-文字                          */
gscud06     varchar2(40),            /*自订字段-文字                          */
gscud07     number(15,3),            /*自订字段-数值                          */
gscud08     number(15,3),            /*自订字段-数值                          */
gscud09     number(15,3),            /*自订字段-数值                          */
gscud10     number(10),              /*自订字段-整数                          */
gscud11     number(10),              /*自订字段-整数                          */
gscud12     number(10),              /*自订字段-整数                          */
gscud13     date,                    /*自订字段-日期                          */
gscud14     date,                    /*自订字段-日期                          */
gscud15     date,                    /*自订字段-日期                          */
gsclegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index gsc_02 on gsc_file (gsc03);
alter table gsc_file add  constraint gsc_pk primary key  (gsc01,gsc02) enable validate;
grant select on gsc_file to tiptopgp;
grant update on gsc_file to tiptopgp;
grant delete on gsc_file to tiptopgp;
grant insert on gsc_file to tiptopgp;
grant index on gsc_file to public;
grant select on gsc_file to ods;
