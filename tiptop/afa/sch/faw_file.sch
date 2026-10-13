/*
================================================================================
檔案代號:faw_file
檔案名稱:资产收回单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table faw_file
(
faw01       varchar2(20) NOT NULL,   /*收回单号                               */
faw02       date,                    /*收回日期                               */
faw03       varchar2(20),            /*外送单号                               */
fawconf     varchar2(1),             /*确认码                                 */
fawpost     varchar2(1),             /*过帐码                                 */
fawprsw     number(5),               /*打印次数                               */
fawuser     varchar2(10),            /*资料所有者                             */
fawgrup     varchar2(10),            /*资料所有群                             */
fawmodu     varchar2(10),            /*资料更改者                             */
fawdate     date,                    /*最近更改日                             */
faw04       varchar2(1),             /*状况码                                 */
fawmksg     varchar2(1),             /*签核否？                               */
faw05       varchar2(10),            /*申请人                                 */
fawud01     varchar2(255),           /*自订字段-Textedit                      */
fawud02     varchar2(40),            /*自订字段-文字                          */
fawud03     varchar2(40),            /*自订字段-文字                          */
fawud04     varchar2(40),            /*自订字段-文字                          */
fawud05     varchar2(40),            /*自订字段-文字                          */
fawud06     varchar2(40),            /*自订字段-文字                          */
fawud07     number(15,3),            /*自订字段-数值                          */
fawud08     number(15,3),            /*自订字段-数值                          */
fawud09     number(15,3),            /*自订字段-数值                          */
fawud10     number(10),              /*自订字段-整数                          */
fawud11     number(10),              /*自订字段-整数                          */
fawud12     number(10),              /*自订字段-整数                          */
fawud13     date,                    /*自订字段-日期                          */
fawud14     date,                    /*自订字段-日期                          */
fawud15     date,                    /*自订字段-日期                          */
fawlegal    varchar2(10) NOT NULL,   /*所属法人                               */
faworiu     varchar2(10),            /*资料建立者                             */
faworig     varchar2(10)             /*资料建立部门                           */
);

alter table faw_file add  constraint faw_pk primary key  (faw01) enable validate;
grant select on faw_file to tiptopgp;
grant update on faw_file to tiptopgp;
grant delete on faw_file to tiptopgp;
grant insert on faw_file to tiptopgp;
grant index on faw_file to public;
grant select on faw_file to ods;
