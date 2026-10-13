/*
================================================================================
檔案代號:toi_file
檔案名稱:省台广告费分摊比率档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table toi_file
(
toi01       varchar2(10) NOT NULL,   /*省别                                   */
toi02       varchar2(10) NOT NULL,   /*媒体编号                               */
toi03       number(5) NOT NULL,      /*项次                                   */
toi04       varchar2(10),            /*地级市                                 */
toi05       number(5),               /*喜好度                                 */
toi06       number(9),               /*收视人口                               */
toi07       date,                    /*生效日期                               */
toi08       date,                    /*失效日期                               */
toi09       varchar2(255),           /*备注                                   */
toiud01     varchar2(255),           /*自订字段-Textedit                      */
toiud02     varchar2(40),            /*自订字段-文字                          */
toiud03     varchar2(40),            /*自订字段-文字                          */
toiud04     varchar2(40),            /*自订字段-文字                          */
toiud05     varchar2(40),            /*自订字段-文字                          */
toiud06     varchar2(40),            /*自订字段-文字                          */
toiud07     number(15,3),            /*自订字段-数值                          */
toiud08     number(15,3),            /*自订字段-数值                          */
toiud09     number(15,3),            /*自订字段-数值                          */
toiud10     number(10),              /*自订字段-整数                          */
toiud11     number(10),              /*自订字段-整数                          */
toiud12     number(10),              /*自订字段-整数                          */
toiud13     date,                    /*自订字段-日期                          */
toiud14     date,                    /*自订字段-日期                          */
toiud15     date                     /*自订字段-日期                          */
);

alter table toi_file add  constraint toi_pk primary key  (toi01,toi02,toi03) enable validate;
grant select on toi_file to tiptopgp;
grant update on toi_file to tiptopgp;
grant delete on toi_file to tiptopgp;
grant insert on toi_file to tiptopgp;
grant index on toi_file to public;
grant select on toi_file to ods;
