/*
================================================================================
檔案代號:ggb_file
檔案名稱:程序自动执行维护单身档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table ggb_file
(
ggb01       varchar2(10) DEFAULT ' ' NOT NULL, /*流程编号*/
ggb02       number(5) DEFAULT '0' NOT NULL, /*序号*/
ggb03       varchar2(100),           /*流程编号 程序编号                      */
ggb04       varchar2(1) DEFAULT ' ' NOT NULL, /*自动运行*/
ggb05       varchar2(1) DEFAULT ' ' NOT NULL, /*是否必须*/
ggb06       varchar2(255),           /*运行条件 以|为分隔符                   */
ggb07       varchar2(255),           /*备注                                   */
ggbacti     varchar2(1) DEFAULT ' ' NOT NULL, /*有效码*/
ggbud01     varchar2(255),           /*自订字段-Textedit                      */
ggbud02     varchar2(40),            /*自订字段-文字                          */
ggbud03     varchar2(40),            /*自订字段-文字                          */
ggbud04     varchar2(40),            /*自订字段-文字                          */
ggbud05     varchar2(40),            /*自订字段-文字                          */
ggbud06     varchar2(40),            /*自订字段-文字                          */
ggbud07     number(15,3),            /*自订字段-数值                          */
ggbud08     number(15,3),            /*自订字段-数值                          */
ggbud09     number(15,3),            /*自订字段-数值                          */
ggbud10     number(10),              /*自订字段-整数                          */
ggbud11     number(10),              /*自订字段-整数                          */
ggbud12     number(10),              /*自订字段-整数                          */
ggbud13     date,                    /*自订字段-日期                          */
ggbud14     date,                    /*自订字段-日期                          */
ggbud15     date                     /*自订字段-日期                          */
);

alter table ggb_file add  constraint ggb_pk primary key  (ggb01,ggb02) enable validate;
grant select on ggb_file to tiptopgp;
grant update on ggb_file to tiptopgp;
grant delete on ggb_file to tiptopgp;
grant insert on ggb_file to tiptopgp;
grant index on ggb_file to public;
grant select on ggb_file to ods;
