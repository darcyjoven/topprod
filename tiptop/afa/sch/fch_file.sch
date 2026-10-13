/*
================================================================================
檔案代號:fch_file
檔案名稱:固定资产免税单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fch_file
(
fch01       varchar2(20) NOT NULL,   /*申请单号                               */
fch02       date,                    /*申请日期                               */
fch03       number(5),               /*免税选定年份                           */
fch04       date,                    /*开工核准日期                           */
fch05       varchar2(30),            /*开工核准文号                           */
fch06       date,                    /*免税核准日期                           */
fch07       varchar2(30),            /*免税核准文号                           */
fch08       number(5),               /*免税年限                               */
fch09       number(20,6),            /*免税金额                               */
fchconf     varchar2(1),             /*审核否                                 */
fchprsw     number(5),               /*打印次数                               */
fchuser     varchar2(10),            /*资料所有者                             */
fchgrup     varchar2(10),            /*资料所有部门                           */
fchmodu     varchar2(10),            /*资料更改者                             */
fchdate     date,                    /*最近更改日                             */
fchud01     varchar2(255),           /*自订字段-Textedit                      */
fchud02     varchar2(40),            /*自订字段-文字                          */
fchud03     varchar2(40),            /*自订字段-文字                          */
fchud04     varchar2(40),            /*自订字段-文字                          */
fchud05     varchar2(40),            /*自订字段-文字                          */
fchud06     varchar2(40),            /*自订字段-文字                          */
fchud07     number(15,3),            /*自订字段-数值                          */
fchud08     number(15,3),            /*自订字段-数值                          */
fchud09     number(15,3),            /*自订字段-数值                          */
fchud10     number(10),              /*自订字段-整数                          */
fchud11     number(10),              /*自订字段-整数                          */
fchud12     number(10),              /*自订字段-整数                          */
fchud13     date,                    /*自订字段-日期                          */
fchud14     date,                    /*自订字段-日期                          */
fchud15     date,                    /*自订字段-日期                          */
fchlegal    varchar2(10) NOT NULL,   /*所属法人                               */
fchoriu     varchar2(10),            /*资料建立者                             */
fchorig     varchar2(10)             /*资料建立部门                           */
);

alter table fch_file add  constraint fch_pk primary key  (fch01) enable validate;
grant select on fch_file to tiptopgp;
grant update on fch_file to tiptopgp;
grant delete on fch_file to tiptopgp;
grant insert on fch_file to tiptopgp;
grant index on fch_file to public;
grant select on fch_file to ods;
