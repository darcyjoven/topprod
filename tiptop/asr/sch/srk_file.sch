/*
================================================================================
檔案代號:srk_file
檔案名稱:产品投入工时单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table srk_file
(
srk01       date NOT NULL,           /*日期                                   */
srk02       varchar2(10) NOT NULL,   /*成本中心                               */
srk03       varchar2(255),           /*备注                                   */
srk04       varchar2(1),             /*No Use                                 */
srk05       number(15,3) NOT NULL,   /*工时合计                               */
srkfirm     varchar2(1),             /*确认码                                 */
srkinpd     date,                    /*录入日期                               */
srkacti     varchar2(1),             /*资料有效码                             */
srkuser     varchar2(10),            /*资料所有者                             */
srkgrup     varchar2(10),            /*资料所有群                             */
srkmodu     varchar2(10),            /*资料更改者                             */
srkdate     date,                    /*最近更改日                             */
srkud01     varchar2(255),           /*自订字段-Textedit                      */
srkud02     varchar2(40),            /*自订字段-文字                          */
srkud03     varchar2(40),            /*自订字段-文字                          */
srkud04     varchar2(40),            /*自订字段-文字                          */
srkud05     varchar2(40),            /*自订字段-文字                          */
srkud06     varchar2(40),            /*自订字段-文字                          */
srkud07     number(15,3),            /*自订字段-数值                          */
srkud08     number(15,3),            /*自订字段-数值                          */
srkud09     number(15,3),            /*自订字段-数值                          */
srkud10     number(10),              /*自订字段-整数                          */
srkud11     number(10),              /*自订字段-整数                          */
srkud12     number(10),              /*自订字段-整数                          */
srkud13     date,                    /*自订字段-日期                          */
srkud14     date,                    /*自订字段-日期                          */
srkud15     date,                    /*自订字段-日期                          */
srkoriu     varchar2(10),            /*资料建立者                             */
srkorig     varchar2(10)             /*资料建立部门                           */
);

alter table srk_file add  constraint srk_pk primary key  (srk01,srk02) enable validate;
grant select on srk_file to tiptopgp;
grant update on srk_file to tiptopgp;
grant delete on srk_file to tiptopgp;
grant insert on srk_file to tiptopgp;
grant index on srk_file to public;
grant select on srk_file to ods;
