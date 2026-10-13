/*
================================================================================
檔案代號:bzc_file
檔案名稱:保税机器设备记账卡单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bzc_file
(
bzc01       varchar2(20) NOT NULL,   /*记帐卡编号                             */
bzc02       varchar2(80),            /*记帐卡名称                             */
bzc03       varchar2(10),            /*负责人                                 */
bzc04       varchar2(10),            /*承办人                                 */
bzc05       varchar2(255),           /*备注                                   */
bzcacti     varchar2(1),             /*资料有效码                             */
bzcuser     varchar2(10),            /*资料所有者                             */
bzcgrup     varchar2(10),            /*资料所有部门                           */
bzcmodu     varchar2(10),            /*资料更改者                             */
bzcdate     date,                    /*最近更改日                             */
bzcud01     varchar2(255),           /*自订字段-Textedit                      */
bzcud02     varchar2(40),            /*自订字段-文字                          */
bzcud03     varchar2(40),            /*自订字段-文字                          */
bzcud04     varchar2(40),            /*自订字段-文字                          */
bzcud05     varchar2(40),            /*自订字段-文字                          */
bzcud06     varchar2(40),            /*自订字段-文字                          */
bzcud07     number(15,3),            /*自订字段-数值                          */
bzcud08     number(15,3),            /*自订字段-数值                          */
bzcud09     number(15,3),            /*自订字段-数值                          */
bzcud10     number(10),              /*自订字段-整数                          */
bzcud11     number(10),              /*自订字段-整数                          */
bzcud12     number(10),              /*自订字段-整数                          */
bzcud13     date,                    /*自订字段-日期                          */
bzcud14     date,                    /*自订字段-日期                          */
bzcud15     date,                    /*自订字段-日期                          */
bzcorig     varchar2(10),            /*资料建立部门                           */
bzcoriu     varchar2(10)             /*资料建立者                             */
);

alter table bzc_file add  constraint bzc_pk primary key  (bzc01) enable validate;
grant select on bzc_file to tiptopgp;
grant update on bzc_file to tiptopgp;
grant delete on bzc_file to tiptopgp;
grant insert on bzc_file to tiptopgp;
grant index on bzc_file to public;
grant select on bzc_file to ods;
