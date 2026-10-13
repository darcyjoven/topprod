/*
================================================================================
檔案代號:fbm_file
檔案名稱:固定资产存放位置异动单(单身)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fbm_file
(
fbm01       varchar2(20) NOT NULL,   /*单号                                   */
fbm02       number(5) NOT NULL,      /*项次                                   */
fbm03       varchar2(10),            /*财产编号                               */
fbm031      varchar2(4),             /*附号                                   */
fbm04       varchar2(10),            /*保管人                                 */
fbm05       varchar2(10),            /*保管部门                               */
fbm06       varchar2(10),            /*放置地点                               */
fbmud01     varchar2(255),           /*自订字段-Textedit                      */
fbmud02     varchar2(40),            /*自订字段-文字                          */
fbmud03     varchar2(40),            /*自订字段-文字                          */
fbmud04     varchar2(40),            /*自订字段-文字                          */
fbmud05     varchar2(40),            /*自订字段-文字                          */
fbmud06     varchar2(40),            /*自订字段-文字                          */
fbmud07     number(15,3),            /*自订字段-数值                          */
fbmud08     number(15,3),            /*自订字段-数值                          */
fbmud09     number(15,3),            /*自订字段-数值                          */
fbmud10     number(10),              /*自订字段-整数                          */
fbmud11     number(10),              /*自订字段-整数                          */
fbmud12     number(10),              /*自订字段-整数                          */
fbmud13     date,                    /*自订字段-日期                          */
fbmud14     date,                    /*自订字段-日期                          */
fbmud15     date,                    /*自订字段-日期                          */
fbmlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create unique index fbm_02 on fbm_file (fbm01,fbm03,fbm031);
alter table fbm_file add  constraint fbm_pk primary key  (fbm01,fbm02) enable validate;
grant select on fbm_file to tiptopgp;
grant update on fbm_file to tiptopgp;
grant delete on fbm_file to tiptopgp;
grant insert on fbm_file to tiptopgp;
grant index on fbm_file to public;
grant select on fbm_file to ods;
