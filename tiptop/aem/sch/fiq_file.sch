/*
================================================================================
檔案代號:fiq_file
檔案名稱:设备检查记录单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fiq_file
(
fiq00       varchar2(1),             /*资料来源                               */
fiq01       varchar2(20) NOT NULL,   /*检查单号                               */
fiq02       varchar2(20),            /*设备编号                               */
fiq03       date,                    /*检查日期                               */
fiq04       varchar2(5),             /*检查时间                               */
fiq05       date,                    /*完成日期                               */
fiq06       varchar2(5),             /*完成时间                               */
fiq07       varchar2(10),            /*检查员                                 */
fiq08       varchar2(10),            /*厂商编号                               */
fiq09       varchar2(300),           /*问题描述                               */
fiq11       varchar2(1),             /*No Use                                 */
fiq12       varchar2(1),             /*No Use                                 */
fiqconf     varchar2(1),             /*资料审核码                             */
fiqacti     varchar2(1),             /*资料有效码                             */
fiquser     varchar2(10),            /*资料所有者                             */
fiqgrup     varchar2(10),            /*资料所有部门                           */
fiqmodu     varchar2(10),            /*最后更改人员                           */
fiqdate     date,                    /*最后更改日期                           */
fiqud01     varchar2(255),           /*自订字段-Textedit                      */
fiqud02     varchar2(40),            /*自订字段-文字                          */
fiqud03     varchar2(40),            /*自订字段-文字                          */
fiqud04     varchar2(40),            /*自订字段-文字                          */
fiqud05     varchar2(40),            /*自订字段-文字                          */
fiqud06     varchar2(40),            /*自订字段-文字                          */
fiqud07     number(15,3),            /*自订字段-数值                          */
fiqud08     number(15,3),            /*自订字段-数值                          */
fiqud09     number(15,3),            /*自订字段-数值                          */
fiqud10     number(10),              /*自订字段-整数                          */
fiqud11     number(10),              /*自订字段-整数                          */
fiqud12     number(10),              /*自订字段-整数                          */
fiqud13     date,                    /*自订字段-日期                          */
fiqud14     date,                    /*自订字段-日期                          */
fiqud15     date,                    /*自订字段-日期                          */
fiqplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
fiqlegal    varchar2(10) NOT NULL,   /*所属法人                               */
fiqoriu     varchar2(10),            /*资料建立者                             */
fiqorig     varchar2(10)             /*资料建立部门                           */
);

alter table fiq_file add  constraint fiq_pk primary key  (fiq01) enable validate;
grant select on fiq_file to tiptopgp;
grant update on fiq_file to tiptopgp;
grant delete on fiq_file to tiptopgp;
grant insert on fiq_file to tiptopgp;
grant index on fiq_file to public;
grant select on fiq_file to ods;
