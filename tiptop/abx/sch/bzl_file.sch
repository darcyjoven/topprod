/*
================================================================================
檔案代號:bzl_file
檔案名稱:保税机器设备报废/除账单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bzl_file
(
bzl00       varchar2(1),             /*性质                                   */
                                     /*1.Retire 2.Charge Office               */
bzl01       varchar2(20) NOT NULL,   /*报废/除帐单号                          */
bzl02       date,                    /*单据日期                               */
bzl03       varchar2(255),           /*备注                                   */
bzl04       varchar2(10),            /*审核人                                 */
bzl05       date,                    /*审核日期                               */
bzl06       varchar2(1),             /*确认码                                 */
                                     /*Y/N/X                                  */
bzl07       varchar2(1),             /*No Use                                 */
bzl08       varchar2(1),             /*No Use                                 */
bzl09       varchar2(1),             /*No Use                                 */
bzl10       varchar2(1),             /*No Use                                 */
bzlacti     varchar2(1),             /*资料有效码                             */
bzluser     varchar2(10),            /*资料所有者                             */
bzlgrup     varchar2(10),            /*资料所有部门                           */
bzlmodu     varchar2(10),            /*资料更改者                             */
bzldate     date,                    /*最近更改日                             */
bzlud01     varchar2(255),           /*自订字段-Textedit                      */
bzlud02     varchar2(40),            /*自订字段-文字                          */
bzlud03     varchar2(40),            /*自订字段-文字                          */
bzlud04     varchar2(40),            /*自订字段-文字                          */
bzlud05     varchar2(40),            /*自订字段-文字                          */
bzlud06     varchar2(40),            /*自订字段-文字                          */
bzlud07     number(15,3),            /*自订字段-数值                          */
bzlud08     number(15,3),            /*自订字段-数值                          */
bzlud09     number(15,3),            /*自订字段-数值                          */
bzlud10     number(10),              /*自订字段-整数                          */
bzlud11     number(10),              /*自订字段-整数                          */
bzlud12     number(10),              /*自订字段-整数                          */
bzlud13     date,                    /*自订字段-日期                          */
bzlud14     date,                    /*自订字段-日期                          */
bzlud15     date,                    /*自订字段-日期                          */
bzlplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bzllegal    varchar2(10) NOT NULL,   /*所属法人                               */
bzlorig     varchar2(10),            /*资料建立部门                           */
bzloriu     varchar2(10)             /*资料建立者                             */
);

alter table bzl_file add  constraint bzl_pk primary key  (bzl01) enable validate;
grant select on bzl_file to tiptopgp;
grant update on bzl_file to tiptopgp;
grant delete on bzl_file to tiptopgp;
grant insert on bzl_file to tiptopgp;
grant index on bzl_file to public;
grant select on bzl_file to ods;
