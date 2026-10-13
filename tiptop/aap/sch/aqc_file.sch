/*
================================================================================
檔案代號:aqc_file
檔案名稱:应付账款分摊单身档-目的
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table aqc_file
(
aqc01       varchar2(20) NOT NULL,   /*分摊费用单号                           */
aqc02       varchar2(20) NOT NULL,   /*目的应付单号                           */
aqc03       number(5) NOT NULL,      /*目的应付单号项次                       */
aqc04       number(20,6),            /*分摊前本币单价                         */
aqc05       number(15,3),            /*数量                                   */
aqc06       number(20,6),            /*分摊前金额                             */
aqc07       number(20,6),            /*分摊后本币单价                         */
aqc08       number(20,6),            /*分摊后金额                             */
aqcud01     varchar2(255),           /*自订字段-Textedit                      */
aqcud02     varchar2(40),            /*自订字段-文字                          */
aqcud03     varchar2(40),            /*自订字段-文字                          */
aqcud04     varchar2(40),            /*自订字段-文字                          */
aqcud05     varchar2(40),            /*自订字段-文字                          */
aqcud06     varchar2(40),            /*自订字段-文字                          */
aqcud07     number(15,3),            /*自订字段-数值                          */
aqcud08     number(15,3),            /*自订字段-数值                          */
aqcud09     number(15,3),            /*自订字段-数值                          */
aqcud10     number(10),              /*自订字段-整数                          */
aqcud11     number(10),              /*自订字段-整数                          */
aqcud12     number(10),              /*自订字段-整数                          */
aqcud13     date,                    /*自订字段-日期                          */
aqcud14     date,                    /*自订字段-日期                          */
aqcud15     date,                    /*自订字段-日期                          */
aqclegal    varchar2(10) NOT NULL,   /*所属法人                               */
aqc111      varchar2(24),            /*会计科目二                             */
aqc09       varchar2(40),            /*料件编号                               */
aqc10       varchar2(1) DEFAULT ' ' NOT NULL, /*目的类型*/
aqc11       varchar2(24)             /*会计科目                               */
);

alter table aqc_file add  constraint aqc_pk primary key  (aqc01,aqc02,aqc03) enable validate;
grant select on aqc_file to tiptopgp;
grant update on aqc_file to tiptopgp;
grant delete on aqc_file to tiptopgp;
grant insert on aqc_file to tiptopgp;
grant index on aqc_file to public;
grant select on aqc_file to ods;
