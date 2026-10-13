/*
================================================================================
檔案代號:tqh_file
檔案名稱:债权产品系列关系档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tqh_file
(
tqh01       varchar2(10) NOT NULL,   /*债权编号                               */
tqh02       varchar2(10) NOT NULL,   /*系列编号                               */
tqhacti     varchar2(1),             /*资料有效码                             */
tqhuser     varchar2(10),            /*资料所有者                             */
tqhgrup     varchar2(10),            /*资料所有部门                           */
tqhmodu     varchar2(10),            /*资料更改者                             */
tqhdate     date,                    /*最近更改日                             */
tqhud01     varchar2(255),           /*自订字段-Textedit                      */
tqhud02     varchar2(40),            /*自订字段-文字                          */
tqhud03     varchar2(40),            /*自订字段-文字                          */
tqhud04     varchar2(40),            /*自订字段-文字                          */
tqhud05     varchar2(40),            /*自订字段-文字                          */
tqhud06     varchar2(40),            /*自订字段-文字                          */
tqhud07     number(15,3),            /*自订字段-数值                          */
tqhud08     number(15,3),            /*自订字段-数值                          */
tqhud09     number(15,3),            /*自订字段-数值                          */
tqhud10     number(10),              /*自订字段-整数                          */
tqhud11     number(10),              /*自订字段-整数                          */
tqhud12     number(10),              /*自订字段-整数                          */
tqhud13     date,                    /*自订字段-日期                          */
tqhud14     date,                    /*自订字段-日期                          */
tqhud15     date,                    /*自订字段-日期                          */
tqhoriu     varchar2(10),            /*资料建立者                             */
tqhorig     varchar2(10)             /*资料建立部门                           */
);

alter table tqh_file add  constraint tqh_pk primary key  (tqh01,tqh02) enable validate;
grant select on tqh_file to tiptopgp;
grant update on tqh_file to tiptopgp;
grant delete on tqh_file to tiptopgp;
grant insert on tqh_file to tiptopgp;
grant index on tqh_file to public;
grant select on tqh_file to ods;
