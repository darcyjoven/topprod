/*
================================================================================
檔案代號:tqo_file
檔案名稱:客户订价档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tqo_file
(
tqo01       varchar2(10) NOT NULL,   /*客户编号                               */
tqo02       varchar2(10) NOT NULL,   /*订价编号                               */
tqoacti     varchar2(1),             /*资料有效码                             */
tqouser     varchar2(10),            /*资料所有者                             */
tqogrup     varchar2(10),            /*资料所有部门                           */
tqomodu     varchar2(10),            /*资料更改者                             */
tqodate     date,                    /*最近更改日                             */
tqo03       number(5) NOT NULL,      /*项次                                   */
tqo04       varchar2(10) DEFAULT ' ' NOT NULL, /*资料来源*/
tqo05       number(10),              /*订价资料抛转次数                       */
tqoud01     varchar2(255),           /*自订字段-Textedit                      */
tqoud02     varchar2(40),            /*自订字段-文字                          */
tqoud03     varchar2(40),            /*自订字段-文字                          */
tqoud04     varchar2(40),            /*自订字段-文字                          */
tqoud05     varchar2(40),            /*自订字段-文字                          */
tqoud06     varchar2(40),            /*自订字段-文字                          */
tqoud07     number(15,3),            /*自订字段-数值                          */
tqoud08     number(15,3),            /*自订字段-数值                          */
tqoud09     number(15,3),            /*自订字段-数值                          */
tqoud10     number(10),              /*自订字段-整数                          */
tqoud11     number(10),              /*自订字段-整数                          */
tqoud12     number(10),              /*自订字段-整数                          */
tqoud13     date,                    /*自订字段-日期                          */
tqoud14     date,                    /*自订字段-日期                          */
tqoud15     date,                    /*自订字段-日期                          */
tqooriu     varchar2(10),            /*资料建立者                             */
tqoorig     varchar2(10)             /*资料建立部门                           */
);

alter table tqo_file add  constraint tqo_pk primary key  (tqo01,tqo03) enable validate;
grant select on tqo_file to tiptopgp;
grant update on tqo_file to tiptopgp;
grant delete on tqo_file to tiptopgp;
grant insert on tqo_file to tiptopgp;
grant index on tqo_file to public;
grant select on tqo_file to ods;
