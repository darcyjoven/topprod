/*
================================================================================
檔案代號:bzj_file
檔案名稱:保税机器设备收回单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bzj_file
(
bzj01       varchar2(20) NOT NULL,   /*收回单号                               */
bzj02       date,                    /*单据日期                               */
bzj03       varchar2(255),           /*备注                                   */
bzj04       varchar2(10),            /*审核人                                 */
bzj05       date,                    /*审核日期                               */
bzj06       varchar2(1),             /*确认码                                 */
                                     /*Y/N/X                                  */
bzj07       varchar2(1),             /*No Use                                 */
bzj08       varchar2(1),             /*No Use                                 */
bzj09       varchar2(1),             /*No Use                                 */
bzj10       varchar2(1),             /*No Use                                 */
bzjacti     varchar2(1),             /*资料有效码                             */
bzjuser     varchar2(10),            /*资料所有者                             */
bzjgrup     varchar2(10),            /*资料所有部门                           */
bzjmodu     varchar2(10),            /*资料更改者                             */
bzjdate     date,                    /*最近更改日                             */
bzjud01     varchar2(255),           /*自订字段-Textedit                      */
bzjud02     varchar2(40),            /*自订字段-文字                          */
bzjud03     varchar2(40),            /*自订字段-文字                          */
bzjud04     varchar2(40),            /*自订字段-文字                          */
bzjud05     varchar2(40),            /*自订字段-文字                          */
bzjud06     varchar2(40),            /*自订字段-文字                          */
bzjud07     number(15,3),            /*自订字段-数值                          */
bzjud08     number(15,3),            /*自订字段-数值                          */
bzjud09     number(15,3),            /*自订字段-数值                          */
bzjud10     number(10),              /*自订字段-整数                          */
bzjud11     number(10),              /*自订字段-整数                          */
bzjud12     number(10),              /*自订字段-整数                          */
bzjud13     date,                    /*自订字段-日期                          */
bzjud14     date,                    /*自订字段-日期                          */
bzjud15     date,                    /*自订字段-日期                          */
bzjplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bzjlegal    varchar2(10) NOT NULL,   /*所属法人                               */
bzjorig     varchar2(10),            /*资料建立部门                           */
bzjoriu     varchar2(10)             /*资料建立者                             */
);

alter table bzj_file add  constraint bzj_pk primary key  (bzj01) enable validate;
grant select on bzj_file to tiptopgp;
grant update on bzj_file to tiptopgp;
grant delete on bzj_file to tiptopgp;
grant insert on bzj_file to tiptopgp;
grant index on bzj_file to public;
grant select on bzj_file to ods;
