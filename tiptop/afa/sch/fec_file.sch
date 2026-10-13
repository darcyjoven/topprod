/*
================================================================================
檔案代號:fec_file
檔案名稱:模具领用单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fec_file
(
fec01       varchar2(20) NOT NULL,   /*领用单号                               */
fec02       date,                    /*领用日期                               */
fec03       varchar2(10),            /*部门编号/厂商编号                      */
fec04       varchar2(255),           /*备    注                               */
fec05       varchar2(1),             /*类型                                   */
fecacti     varchar2(1),             /*资料有效码                             */
fecuser     varchar2(10),            /*资料所有者                             */
fecgrup     varchar2(10),            /*资料所有部门                           */
fecmodu     varchar2(10),            /*资料更改者                             */
fecdate     date,                    /*最近更改日                             */
fecud01     varchar2(255),           /*自订字段-Textedit                      */
fecud02     varchar2(40),            /*自订字段-文字                          */
fecud03     varchar2(40),            /*自订字段-文字                          */
fecud04     varchar2(40),            /*自订字段-文字                          */
fecud05     varchar2(40),            /*自订字段-文字                          */
fecud06     varchar2(40),            /*自订字段-文字                          */
fecud07     number(15,3),            /*自订字段-数值                          */
fecud08     number(15,3),            /*自订字段-数值                          */
fecud09     number(15,3),            /*自订字段-数值                          */
fecud10     number(10),              /*自订字段-整数                          */
fecud11     number(10),              /*自订字段-整数                          */
fecud12     number(10),              /*自订字段-整数                          */
fecud13     date,                    /*自订字段-日期                          */
fecud14     date,                    /*自订字段-日期                          */
fecud15     date,                    /*自订字段-日期                          */
fecconf     varchar2(1),             /*审核否                                 */
fec06       varchar2(1),             /*签核状况                               */
fec07       varchar2(10),            /*申请人                                 */
fecmksg     varchar2(1),             /*是否签核                               */
feclegal    varchar2(10) NOT NULL,   /*所属法人                               */
fecoriu     varchar2(10),            /*资料建立者                             */
fecorig     varchar2(10)             /*资料建立部门                           */
);

alter table fec_file add  constraint fec_pk primary key  (fec01) enable validate;
grant select on fec_file to tiptopgp;
grant update on fec_file to tiptopgp;
grant delete on fec_file to tiptopgp;
grant insert on fec_file to tiptopgp;
grant index on fec_file to public;
grant select on fec_file to ods;
