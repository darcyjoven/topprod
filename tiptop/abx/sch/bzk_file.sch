/*
================================================================================
檔案代號:bzk_file
檔案名稱:保税机器设备收回单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bzk_file
(
bzk01       varchar2(20) NOT NULL,   /*收回单号                               */
bzk02       number(5) NOT NULL,      /*项次                                   */
bzk03       varchar2(20),            /*外送单号                               */
bzk04       number(5),               /*外送单号项次                           */
bzk05       number(15,3),            /*本次收回数量                           */
bzk06       varchar2(255),           /*备注                                   */
bzk07       varchar2(1),             /*No Use                                 */
bzk08       varchar2(1),             /*No Use                                 */
bzk09       varchar2(1),             /*No Use                                 */
bzk10       varchar2(1),             /*No Use                                 */
bzkud01     varchar2(255),           /*自订字段-Textedit                      */
bzkud02     varchar2(40),            /*自订字段-文字                          */
bzkud03     varchar2(40),            /*自订字段-文字                          */
bzkud04     varchar2(40),            /*自订字段-文字                          */
bzkud05     varchar2(40),            /*自订字段-文字                          */
bzkud06     varchar2(40),            /*自订字段-文字                          */
bzkud07     number(15,3),            /*自订字段-数值                          */
bzkud08     number(15,3),            /*自订字段-数值                          */
bzkud09     number(15,3),            /*自订字段-数值                          */
bzkud10     number(10),              /*自订字段-整数                          */
bzkud11     number(10),              /*自订字段-整数                          */
bzkud12     number(10),              /*自订字段-整数                          */
bzkud13     date,                    /*自订字段-日期                          */
bzkud14     date,                    /*自订字段-日期                          */
bzkud15     date,                    /*自订字段-日期                          */
bzkplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bzklegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table bzk_file add  constraint bzk_pk primary key  (bzk01,bzk02) enable validate;
grant select on bzk_file to tiptopgp;
grant update on bzk_file to tiptopgp;
grant delete on bzk_file to tiptopgp;
grant insert on bzk_file to tiptopgp;
grant index on bzk_file to public;
grant select on bzk_file to ods;
