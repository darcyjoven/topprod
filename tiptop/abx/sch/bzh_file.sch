/*
================================================================================
檔案代號:bzh_file
檔案名稱:保税机器设备外送单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bzh_file
(
bzh01       varchar2(20) NOT NULL,   /*外送单号                               */
bzh02       date,                    /*单据日期                               */
bzh03       varchar2(255),           /*备注                                   */
bzh04       varchar2(10),            /*审核人                                 */
bzh05       date,                    /*审核日期                               */
bzh06       varchar2(1),             /*确认码                                 */
                                     /*Y/N/X                                  */
bzh07       varchar2(1),             /*No Use                                 */
bzh08       varchar2(1),             /*No Use                                 */
bzh09       varchar2(1),             /*No Use                                 */
bzh10       varchar2(1),             /*No Use                                 */
bzhacti     varchar2(1),             /*资料有效码                             */
bzhuser     varchar2(10),            /*资料所有者                             */
bzhgrup     varchar2(10),            /*资料所有部门                           */
bzhmodu     varchar2(10),            /*资料更改者                             */
bzhdate     date,                    /*最近更改日                             */
bzhud01     varchar2(255),           /*自订字段-Textedit                      */
bzhud02     varchar2(40),            /*自订字段-文字                          */
bzhud03     varchar2(40),            /*自订字段-文字                          */
bzhud04     varchar2(40),            /*自订字段-文字                          */
bzhud05     varchar2(40),            /*自订字段-文字                          */
bzhud06     varchar2(40),            /*自订字段-文字                          */
bzhud07     number(15,3),            /*自订字段-数值                          */
bzhud08     number(15,3),            /*自订字段-数值                          */
bzhud09     number(15,3),            /*自订字段-数值                          */
bzhud10     number(10),              /*自订字段-整数                          */
bzhud11     number(10),              /*自订字段-整数                          */
bzhud12     number(10),              /*自订字段-整数                          */
bzhud13     date,                    /*自订字段-日期                          */
bzhud14     date,                    /*自订字段-日期                          */
bzhud15     date,                    /*自订字段-日期                          */
bzhplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bzhlegal    varchar2(10) NOT NULL,   /*所属法人                               */
bzhorig     varchar2(10),            /*资料建立部门                           */
bzhoriu     varchar2(10)             /*资料建立者                             */
);

alter table bzh_file add  constraint bzh_pk primary key  (bzh01) enable validate;
grant select on bzh_file to tiptopgp;
grant update on bzh_file to tiptopgp;
grant delete on bzh_file to tiptopgp;
grant insert on bzh_file to tiptopgp;
grant index on bzh_file to public;
grant select on bzh_file to ods;
