/*
================================================================================
檔案代號:fim_file
檔案名稱:设备工单资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fim_file
(
fim01       varchar2(20) NOT NULL,   /*工单编号                               */
fim02       number(5) NOT NULL,      /*项次                                   */
fim03       varchar2(10),            /*保修项目                               */
fim04       date,                    /*开始日期                               */
fim05       date,                    /*完成日期                               */
fim06       number(8,3),             /*准备工时                               */
fim07       number(8,3),             /*标准工时                               */
fim08       varchar2(1),             /*停机否                                 */
fim09       number(15,3),            /*停机时间                               */
fim10       varchar2(80),            /*停机原因                               */
fim11       varchar2(1),             /*完成否                                 */
fimud01     varchar2(255),           /*自订字段-Textedit                      */
fimud02     varchar2(40),            /*自订字段-文字                          */
fimud03     varchar2(40),            /*自订字段-文字                          */
fimud04     varchar2(40),            /*自订字段-文字                          */
fimud05     varchar2(40),            /*自订字段-文字                          */
fimud06     varchar2(40),            /*自订字段-文字                          */
fimud07     number(15,3),            /*自订字段-数值                          */
fimud08     number(15,3),            /*自订字段-数值                          */
fimud09     number(15,3),            /*自订字段-数值                          */
fimud10     number(10),              /*自订字段-整数                          */
fimud11     number(10),              /*自订字段-整数                          */
fimud12     number(10),              /*自订字段-整数                          */
fimud13     date,                    /*自订字段-日期                          */
fimud14     date,                    /*自订字段-日期                          */
fimud15     date,                    /*自订字段-日期                          */
fimplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
fimlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table fim_file add  constraint fim_pk primary key  (fim01,fim02) enable validate;
grant select on fim_file to tiptopgp;
grant update on fim_file to tiptopgp;
grant delete on fim_file to tiptopgp;
grant insert on fim_file to tiptopgp;
grant index on fim_file to public;
grant select on fim_file to ods;
