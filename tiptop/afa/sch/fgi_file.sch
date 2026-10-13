/*
================================================================================
檔案代號:fgi_file
檔案名稱:折毕再提异动单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fgi_file
(
fgi01       varchar2(20) NOT NULL,   /*异动单号                               */
fgi02       number(5) NOT NULL,      /*行序                                   */
fgi03       varchar2(1),             /*No Use                                 */
fgi04       varchar2(10),            /*主类型                                 */
fgi05       varchar2(10),            /*次类型                                 */
fgi06       varchar2(10),            /*财产编号                               */
fgi07       varchar2(4),             /*附号                                   */
fgi08       number(5),               /*再提年限                               */
fgi09       number(20,6),            /*折毕残值                               */
fgi10       varchar2(1),             /*折毕再提否                             */
fgi11       varchar2(1),             /*状态                                   */
fgi12       varchar2(1),             /*No Use                                 */
fgiud01     varchar2(255),           /*自订字段-Textedit                      */
fgiud02     varchar2(40),            /*自订字段-文字                          */
fgiud03     varchar2(40),            /*自订字段-文字                          */
fgiud04     varchar2(40),            /*自订字段-文字                          */
fgiud05     varchar2(40),            /*自订字段-文字                          */
fgiud06     varchar2(40),            /*自订字段-文字                          */
fgiud07     number(15,3),            /*自订字段-数值                          */
fgiud08     number(15,3),            /*自订字段-数值                          */
fgiud09     number(15,3),            /*自订字段-数值                          */
fgiud10     number(10),              /*自订字段-整数                          */
fgiud11     number(10),              /*自订字段-整数                          */
fgiud12     number(10),              /*自订字段-整数                          */
fgiud13     date,                    /*自订字段-日期                          */
fgiud14     date,                    /*自订字段-日期                          */
fgiud15     date,                    /*自订字段-日期                          */
fgilegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table fgi_file add  constraint fgi_pk primary key  (fgi01,fgi02) enable validate;
grant select on fgi_file to tiptopgp;
grant update on fgi_file to tiptopgp;
grant delete on fgi_file to tiptopgp;
grant insert on fgi_file to tiptopgp;
grant index on fgi_file to public;
grant select on fgi_file to ods;
