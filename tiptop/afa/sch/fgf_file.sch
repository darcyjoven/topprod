/*
================================================================================
檔案代號:fgf_file
檔案名稱:量测仪器校验异动维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fgf_file
(
fgf01       varchar2(10) NOT NULL,   /*校验编号                               */
fgf02       varchar2(1),             /*No Use                                 */
fgfconf     varchar2(1),             /*确认码                                 */
fgfacti     varchar2(1),             /*资料有效码                             */
fgfuser     varchar2(10),            /*资料所有者                             */
fgfgrup     varchar2(10),            /*资料所有群                             */
fgfmodu     varchar2(10),            /*资料更改者                             */
fgfdate     date,                    /*最近更改日                             */
fgfud01     varchar2(255),           /*自订字段-Textedit                      */
fgfud02     varchar2(40),            /*自订字段-文字                          */
fgfud03     varchar2(40),            /*自订字段-文字                          */
fgfud04     varchar2(40),            /*自订字段-文字                          */
fgfud05     varchar2(40),            /*自订字段-文字                          */
fgfud06     varchar2(40),            /*自订字段-文字                          */
fgfud07     number(15,3),            /*自订字段-数值                          */
fgfud08     number(15,3),            /*自订字段-数值                          */
fgfud09     number(15,3),            /*自订字段-数值                          */
fgfud10     number(10),              /*自订字段-整数                          */
fgfud11     number(10),              /*自订字段-整数                          */
fgfud12     number(10),              /*自订字段-整数                          */
fgfud13     date,                    /*自订字段-日期                          */
fgfud14     date,                    /*自订字段-日期                          */
fgfud15     date,                    /*自订字段-日期                          */
fgflegal    varchar2(10) NOT NULL,   /*所属法人                               */
fgforiu     varchar2(10),            /*资料建立者                             */
fgforig     varchar2(10)             /*资料建立部门                           */
);

alter table fgf_file add  constraint fgf_pk primary key  (fgf01) enable validate;
grant select on fgf_file to tiptopgp;
grant update on fgf_file to tiptopgp;
grant delete on fgf_file to tiptopgp;
grant insert on fgf_file to tiptopgp;
grant index on fgf_file to public;
grant select on fgf_file to ods;
