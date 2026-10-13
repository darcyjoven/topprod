/*
================================================================================
檔案代號:srf_file
檔案名稱:报工资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table srf_file
(
srf01       varchar2(20) NOT NULL,   /*报工单号                               */
srf02       date,                    /*报工日期                               */
srf03       varchar2(10),            /*机台生产线                             */
srf04       varchar2(10),            /*班别                                   */
srf05       date,                    /*生产日期                               */
srf06       varchar2(20),            /*领料单号                               */
srf07       varchar2(1),             /*报工类型                               */
                                     /*1:Re. Pro. Report;  2:W/O Pro. Report  */
srfconf     varchar2(1),             /*审核码(y/n/x)                          */
srfuser     varchar2(10),            /*资料所有者                             */
srfgrup     varchar2(10),            /*资料所有部门                           */
srfmodu     varchar2(10),            /*资料更改者                             */
srfdate     date,                    /*最近更改日                             */
srfspc      varchar2(1),             /*SPC抛转码 0/1/2                        */
srfud01     varchar2(255),           /*自订字段-Textedit                      */
srfud02     varchar2(40),            /*自订字段-文字                          */
srfud03     varchar2(40),            /*自订字段-文字                          */
srfud04     varchar2(40),            /*自订字段-文字                          */
srfud05     varchar2(40),            /*自订字段-文字                          */
srfud06     varchar2(40),            /*自订字段-文字                          */
srfud07     number(15,3),            /*自订字段-数值                          */
srfud08     number(15,3),            /*自订字段-数值                          */
srfud09     number(15,3),            /*自订字段-数值                          */
srfud10     number(10),              /*自订字段-整数                          */
srfud11     number(10),              /*自订字段-整数                          */
srfud12     number(10),              /*自订字段-整数                          */
srfud13     date,                    /*自订字段-日期                          */
srfud14     date,                    /*自订字段-日期                          */
srfud15     date,                    /*自订字段-日期                          */
srfplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
srflegal    varchar2(10) NOT NULL,   /*所属法人                               */
srforiu     varchar2(10),            /*资料建立者                             */
srforig     varchar2(10)             /*资料建立部门                           */
);

alter table srf_file add  constraint srf_pk primary key  (srf01) enable validate;
grant select on srf_file to tiptopgp;
grant update on srf_file to tiptopgp;
grant delete on srf_file to tiptopgp;
grant insert on srf_file to tiptopgp;
grant index on srf_file to public;
grant select on srf_file to ods;
