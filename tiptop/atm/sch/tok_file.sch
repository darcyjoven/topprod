/*
================================================================================
檔案代號:tok_file
檔案名稱:广告费分摊比率资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tok_file
(
tok01       varchar2(10) NOT NULL,   /*媒体编号                               */
tok02       varchar2(40) NOT NULL,   /*品牌                                   */
tok03       number(5) NOT NULL,      /*项次                                   */
tok04       varchar2(10),            /*省别                                   */
tok05       number(9),               /*人口数                                 */
tok06       number(15,6),            /*收视率                                 */
tok07       date,                    /*生效日期                               */
tok08       date,                    /*失效日期                               */
tok09       varchar2(255),           /*备注                                   */
tokud01     varchar2(255),           /*自订字段-Textedit                      */
tokud02     varchar2(40),            /*自订字段-文字                          */
tokud03     varchar2(40),            /*自订字段-文字                          */
tokud04     varchar2(40),            /*自订字段-文字                          */
tokud05     varchar2(40),            /*自订字段-文字                          */
tokud06     varchar2(40),            /*自订字段-文字                          */
tokud07     number(15,3),            /*自订字段-数值                          */
tokud08     number(15,3),            /*自订字段-数值                          */
tokud09     number(15,3),            /*自订字段-数值                          */
tokud10     number(10),              /*自订字段-整数                          */
tokud11     number(10),              /*自订字段-整数                          */
tokud12     number(10),              /*自订字段-整数                          */
tokud13     date,                    /*自订字段-日期                          */
tokud14     date,                    /*自订字段-日期                          */
tokud15     date                     /*自订字段-日期                          */
);

alter table tok_file add  constraint tok_pk primary key  (tok01,tok02,tok03) enable validate;
grant select on tok_file to tiptopgp;
grant update on tok_file to tiptopgp;
grant delete on tok_file to tiptopgp;
grant insert on tok_file to tiptopgp;
grant index on tok_file to public;
grant select on tok_file to ods;
