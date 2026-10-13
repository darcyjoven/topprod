/*
================================================================================
檔案代號:fed_file
檔案名稱:模具领用单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fed_file
(
fed01       varchar2(20) NOT NULL,   /*领用单号                               */
fed02       number(5) NOT NULL,      /*领用单序号                             */
fed03       varchar2(12),            /*模具编号                               */
fed04       number(15,3),            /*数量                                   */
fed05       varchar2(20),            /*工单编号                               */
fed06       varchar2(6),             /*作业编号                               */
fedud01     varchar2(255),           /*自订字段-Textedit                      */
fedud02     varchar2(40),            /*自订字段-文字                          */
fedud03     varchar2(40),            /*自订字段-文字                          */
fedud04     varchar2(40),            /*自订字段-文字                          */
fedud05     varchar2(40),            /*自订字段-文字                          */
fedud06     varchar2(40),            /*自订字段-文字                          */
fedud07     number(15,3),            /*自订字段-数值                          */
fedud08     number(15,3),            /*自订字段-数值                          */
fedud09     number(15,3),            /*自订字段-数值                          */
fedud10     number(10),              /*自订字段-整数                          */
fedud11     number(10),              /*自订字段-整数                          */
fedud12     number(10),              /*自订字段-整数                          */
fedud13     date,                    /*自订字段-日期                          */
fedud14     date,                    /*自订字段-日期                          */
fedud15     date,                    /*自订字段-日期                          */
fedlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table fed_file add  constraint fed_pk primary key  (fed01,fed02) enable validate;
grant select on fed_file to tiptopgp;
grant update on fed_file to tiptopgp;
grant delete on fed_file to tiptopgp;
grant insert on fed_file to tiptopgp;
grant index on fed_file to public;
grant select on fed_file to ods;
