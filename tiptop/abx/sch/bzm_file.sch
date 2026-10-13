/*
================================================================================
檔案代號:bzm_file
檔案名稱:保税机器设备报废/除账单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bzm_file
(
bzm01       varchar2(20) NOT NULL,   /*报废/除帐单号                          */
bzm02       number(5) NOT NULL,      /*项次                                   */
bzm03       varchar2(20),            /*机器设备编号                           */
bzm04       number(5),               /*序号                                   */
bzm05       number(15,3),            /*报废/除帐数量                          */
bzm06       varchar2(255),           /*备注                                   */
bzm07       varchar2(1),             /*No Use                                 */
bzm08       varchar2(1),             /*No Use                                 */
bzm09       varchar2(1),             /*No Use                                 */
bzm10       varchar2(1),             /*No Use                                 */
bzmud01     varchar2(255),           /*自订字段-Textedit                      */
bzmud02     varchar2(40),            /*自订字段-文字                          */
bzmud03     varchar2(40),            /*自订字段-文字                          */
bzmud04     varchar2(40),            /*自订字段-文字                          */
bzmud05     varchar2(40),            /*自订字段-文字                          */
bzmud06     varchar2(40),            /*自订字段-文字                          */
bzmud07     number(15,3),            /*自订字段-数值                          */
bzmud08     number(15,3),            /*自订字段-数值                          */
bzmud09     number(15,3),            /*自订字段-数值                          */
bzmud10     number(10),              /*自订字段-整数                          */
bzmud11     number(10),              /*自订字段-整数                          */
bzmud12     number(10),              /*自订字段-整数                          */
bzmud13     date,                    /*自订字段-日期                          */
bzmud14     date,                    /*自订字段-日期                          */
bzmud15     date,                    /*自订字段-日期                          */
bzmplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bzmlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table bzm_file add  constraint bzm_pk primary key  (bzm01,bzm02) enable validate;
grant select on bzm_file to tiptopgp;
grant update on bzm_file to tiptopgp;
grant delete on bzm_file to tiptopgp;
grant insert on bzm_file to tiptopgp;
grant index on bzm_file to public;
grant select on bzm_file to ods;
