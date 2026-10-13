/*
================================================================================
檔案代號:fef_file
檔案名稱:模具归还单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fef_file
(
fef01       varchar2(20) NOT NULL,   /*归还单号                               */
fef02       number(5) NOT NULL,      /*归还单序号                             */
fef03       varchar2(12),            /*模具编号                               */
fef04       number(15,3),            /*数量                                   */
fef05       varchar2(20),            /*借用单号                               */
fefud01     varchar2(255),           /*自订字段-Textedit                      */
fefud02     varchar2(40),            /*自订字段-文字                          */
fefud03     varchar2(40),            /*自订字段-文字                          */
fefud04     varchar2(40),            /*自订字段-文字                          */
fefud05     varchar2(40),            /*自订字段-文字                          */
fefud06     varchar2(40),            /*自订字段-文字                          */
fefud07     number(15,3),            /*自订字段-数值                          */
fefud08     number(15,3),            /*自订字段-数值                          */
fefud09     number(15,3),            /*自订字段-数值                          */
fefud10     number(10),              /*自订字段-整数                          */
fefud11     number(10),              /*自订字段-整数                          */
fefud12     number(10),              /*自订字段-整数                          */
fefud13     date,                    /*自订字段-日期                          */
fefud14     date,                    /*自订字段-日期                          */
fefud15     date,                    /*自订字段-日期                          */
feflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table fef_file add  constraint fef_pk primary key  (fef01,fef02) enable validate;
grant select on fef_file to tiptopgp;
grant update on fef_file to tiptopgp;
grant delete on fef_file to tiptopgp;
grant insert on fef_file to tiptopgp;
grant index on fef_file to public;
grant select on fef_file to ods;
