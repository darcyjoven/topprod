/*
================================================================================
檔案代號:bzi_file
檔案名稱:保税机器设备外送单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bzi_file
(
bzi01       varchar2(20) NOT NULL,   /*外送单号                               */
bzi02       number(5) NOT NULL,      /*项次                                   */
bzi03       varchar2(20),            /*机器设备编号                           */
bzi04       number(5),               /*序号                                   */
bzi05       number(15,3),            /*外送数量                               */
bzi06       varchar2(20),            /*外送地点                               */
bzi07       date,                    /*预计收回日                             */
bzi08       number(15,3),            /*已收回数量                             */
bzi09       varchar2(255),           /*备注                                   */
bzi10       varchar2(1),             /*No Use                                 */
bziud01     varchar2(255),           /*自订字段-Textedit                      */
bziud02     varchar2(40),            /*自订字段-文字                          */
bziud03     varchar2(40),            /*自订字段-文字                          */
bziud04     varchar2(40),            /*自订字段-文字                          */
bziud05     varchar2(40),            /*自订字段-文字                          */
bziud06     varchar2(40),            /*自订字段-文字                          */
bziud07     number(15,3),            /*自订字段-数值                          */
bziud08     number(15,3),            /*自订字段-数值                          */
bziud09     number(15,3),            /*自订字段-数值                          */
bziud10     number(10),              /*自订字段-整数                          */
bziud11     number(10),              /*自订字段-整数                          */
bziud12     number(10),              /*自订字段-整数                          */
bziud13     date,                    /*自订字段-日期                          */
bziud14     date,                    /*自订字段-日期                          */
bziud15     date,                    /*自订字段-日期                          */
bziplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bzilegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table bzi_file add  constraint bzi_pk primary key  (bzi01,bzi02) enable validate;
grant select on bzi_file to tiptopgp;
grant update on bzi_file to tiptopgp;
grant delete on bzi_file to tiptopgp;
grant insert on bzi_file to tiptopgp;
grant index on bzi_file to public;
grant select on bzi_file to ods;
