/*
================================================================================
檔案代號:fit_file
檔案名稱:设备检查记录单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fit_file
(
fit01       varchar2(20) NOT NULL,   /*检查单号                               */
fit02       number(5) NOT NULL,      /*序号                                   */
fit03       varchar2(10),            /*保修项目                               */
fitud01     varchar2(255),           /*自订字段-Textedit                      */
fitud02     varchar2(40),            /*自订字段-文字                          */
fitud03     varchar2(40),            /*自订字段-文字                          */
fitud04     varchar2(40),            /*自订字段-文字                          */
fitud05     varchar2(40),            /*自订字段-文字                          */
fitud06     varchar2(40),            /*自订字段-文字                          */
fitud07     number(15,3),            /*自订字段-数值                          */
fitud08     number(15,3),            /*自订字段-数值                          */
fitud09     number(15,3),            /*自订字段-数值                          */
fitud10     number(10),              /*自订字段-整数                          */
fitud11     number(10),              /*自订字段-整数                          */
fitud12     number(10),              /*自订字段-整数                          */
fitud13     date,                    /*自订字段-日期                          */
fitud14     date,                    /*自订字段-日期                          */
fitud15     date,                    /*自订字段-日期                          */
fitplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
fitlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table fit_file add  constraint fit_pk primary key  (fit01,fit02) enable validate;
grant select on fit_file to tiptopgp;
grant update on fit_file to tiptopgp;
grant delete on fit_file to tiptopgp;
grant insert on fit_file to tiptopgp;
grant index on fit_file to public;
grant select on fit_file to ods;
