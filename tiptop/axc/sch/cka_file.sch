/*
================================================================================
檔案代號:cka_file
檔案名稱:作业执行日志
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cka_file
(
cka00       varchar2(15) DEFAULT ' ' NOT NULL, /*流水号*/
cka01       varchar2(20),            /*程序编号                               */
cka02       number(5),               /*年度                                   */
cka03       number(5),               /*期别                                   */
cka04       date,                    /*开始日期                               */
cka05       varchar2(8),             /*开始时间                               */
cka06       date,                    /*结束日期                               */
cka07       varchar2(8),             /*结束时间                               */
cka08       varchar2(255),           /*执行条件                               */
cka09       varchar2(255),           /*条件选项                               */
cka10       varchar2(1) DEFAULT ' ' NOT NULL, /*成功否*/
cka11       varchar2(10),            /*版本号                                 */
ckaud01     varchar2(255),           /*自订字段-Textedit                      */
ckaud02     varchar2(40),            /*自订字段-文字                          */
ckaud03     varchar2(40),            /*自订字段-文字                          */
ckaud04     varchar2(40),            /*自订字段-文字                          */
ckaud05     varchar2(40),            /*自订字段-文字                          */
ckaud06     varchar2(40),            /*自订字段-文字                          */
ckaud07     number(15,3),            /*自订字段-数值                          */
ckaud08     number(15,3),            /*自订字段-数值                          */
ckaud09     number(15,3),            /*自订字段-数值                          */
ckaud10     number(10),              /*自订字段-整数                          */
ckaud11     number(10),              /*自订字段-整数                          */
ckaud12     number(10),              /*自订字段-整数                          */
ckaud13     date,                    /*自订字段-日期                          */
ckaud14     date,                    /*自订字段-日期                          */
ckaud15     date,                    /*自订字段-日期                          */
ckauser     varchar2(10)             /*运行人员                               */
);

alter table cka_file add  constraint cka_pk primary key  (cka00) enable validate;
grant select on cka_file to tiptopgp;
grant update on cka_file to tiptopgp;
grant delete on cka_file to tiptopgp;
grant insert on cka_file to tiptopgp;
grant index on cka_file to public;
grant select on cka_file to ods;
