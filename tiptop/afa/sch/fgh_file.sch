/*
================================================================================
檔案代號:fgh_file
檔案名稱:折毕再提(财签)单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fgh_file
(
fgh01       varchar2(20) NOT NULL,   /*异动单号                               */
fgh02       date,                    /*单据日期                               */
fgh03       varchar2(1),             /*性质                                   */
fgh04       varchar2(1),             /*No Use                                 */
fghconf     varchar2(1),             /*资料审核码                             */
fghacti     varchar2(1),             /*资料有效码                             */
fghuser     varchar2(10),            /*资料所有者                             */
fghgrup     varchar2(10),            /*资料所有部门                           */
fghmodu     varchar2(10),            /*资料更改者                             */
fghdate     date,                    /*最近更改日                             */
fghud01     varchar2(255),           /*自订字段-Textedit                      */
fghud02     varchar2(40),            /*自订字段-文字                          */
fghud03     varchar2(40),            /*自订字段-文字                          */
fghud04     varchar2(40),            /*自订字段-文字                          */
fghud05     varchar2(40),            /*自订字段-文字                          */
fghud06     varchar2(40),            /*自订字段-文字                          */
fghud07     number(15,3),            /*自订字段-数值                          */
fghud08     number(15,3),            /*自订字段-数值                          */
fghud09     number(15,3),            /*自订字段-数值                          */
fghud10     number(10),              /*自订字段-整数                          */
fghud11     number(10),              /*自订字段-整数                          */
fghud12     number(10),              /*自订字段-整数                          */
fghud13     date,                    /*自订字段-日期                          */
fghud14     date,                    /*自订字段-日期                          */
fghud15     date,                    /*自订字段-日期                          */
fghlegal    varchar2(10) NOT NULL,   /*所属法人                               */
fghoriu     varchar2(10),            /*资料建立者                             */
fghorig     varchar2(10)             /*资料建立部门                           */
);

alter table fgh_file add  constraint fgh_pk primary key  (fgh01) enable validate;
grant select on fgh_file to tiptopgp;
grant update on fgh_file to tiptopgp;
grant delete on fgh_file to tiptopgp;
grant insert on fgh_file to tiptopgp;
grant index on fgh_file to public;
grant select on fgh_file to ods;
