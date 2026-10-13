/*
================================================================================
檔案代號:toe_file
檔案名稱:广告地区资料维护作业单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table toe_file
(
toe01       varchar2(10) NOT NULL,   /*区域                                   */
toe02       varchar2(10) NOT NULL,   /*省别                                   */
toe03       varchar2(10) NOT NULL,   /*地级市                                 */
toe04       varchar2(10) NOT NULL,   /*县                                     */
toe05       varchar2(40) NOT NULL,   /*品牌                                   */
toe06       number(20,6),            /*标准营业额                             */
toe07       varchar2(255),           /*备注                                   */
toeud01     varchar2(255),           /*自订字段-Textedit                      */
toeud02     varchar2(40),            /*自订字段-文字                          */
toeud03     varchar2(40),            /*自订字段-文字                          */
toeud04     varchar2(40),            /*自订字段-文字                          */
toeud05     varchar2(40),            /*自订字段-文字                          */
toeud06     varchar2(40),            /*自订字段-文字                          */
toeud07     number(15,3),            /*自订字段-数值                          */
toeud08     number(15,3),            /*自订字段-数值                          */
toeud09     number(15,3),            /*自订字段-数值                          */
toeud10     number(10),              /*自订字段-整数                          */
toeud11     number(10),              /*自订字段-整数                          */
toeud12     number(10),              /*自订字段-整数                          */
toeud13     date,                    /*自订字段-日期                          */
toeud14     date,                    /*自订字段-日期                          */
toeud15     date                     /*自订字段-日期                          */
);

alter table toe_file add  constraint toe_pk primary key  (toe01,toe02,toe03,toe04,toe05) enable validate;
grant select on toe_file to tiptopgp;
grant update on toe_file to tiptopgp;
grant delete on toe_file to tiptopgp;
grant insert on toe_file to tiptopgp;
grant index on toe_file to public;
grant select on toe_file to ods;
