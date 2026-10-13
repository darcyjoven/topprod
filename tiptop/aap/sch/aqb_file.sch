/*
================================================================================
檔案代號:aqb_file
檔案名稱:应付账款分摊单身-来源
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table aqb_file
(
aqb01       varchar2(20) NOT NULL,   /*分摊费用单号                           */
aqb02       varchar2(20) NOT NULL,   /*来源杂项单号                           */
aqb03       number(20,6),            /*来源杂项单号总金额                     */
aqb04       number(20,6),            /*本币分摊额                             */
aqb05       varchar2(1),             /*No Use                                 */
aqbud01     varchar2(255),           /*自订字段-Textedit                      */
aqbud02     varchar2(40),            /*自订字段-文字                          */
aqbud03     varchar2(40),            /*自订字段-文字                          */
aqbud04     varchar2(40),            /*自订字段-文字                          */
aqbud05     varchar2(40),            /*自订字段-文字                          */
aqbud06     varchar2(40),            /*自订字段-文字                          */
aqbud07     number(15,3),            /*自订字段-数值                          */
aqbud08     number(15,3),            /*自订字段-数值                          */
aqbud09     number(15,3),            /*自订字段-数值                          */
aqbud10     number(10),              /*自订字段-整数                          */
aqbud11     number(10),              /*自订字段-整数                          */
aqbud12     number(10),              /*自订字段-整数                          */
aqbud13     date,                    /*自订字段-日期                          */
aqbud14     date,                    /*自订字段-日期                          */
aqbud15     date,                    /*自订字段-日期                          */
aqblegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table aqb_file add  constraint aqb_pk primary key  (aqb01,aqb02) enable validate;
grant select on aqb_file to tiptopgp;
grant update on aqb_file to tiptopgp;
grant delete on aqb_file to tiptopgp;
grant insert on aqb_file to tiptopgp;
grant index on aqb_file to public;
grant select on aqb_file to ods;
