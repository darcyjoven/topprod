/*
================================================================================
檔案代號:tqm_file
檔案名稱:产品价格单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tqm_file
(
tqm01       varchar2(10) NOT NULL,   /*订价编号                               */
tqm02       varchar2(80),            /*订价名称                               */
tqm03       varchar2(10),            /*适用通路                               */
tqm04       varchar2(1),             /*状态码                                 */
tqm05       varchar2(4),             /*币种                                   */
tqm06       varchar2(1),             /*订价类型                               */
tqmacti     varchar2(1),             /*资料有效码                             */
tqmuser     varchar2(10),            /*资料所有者                             */
tqmgrup     varchar2(10),            /*资料所有部门                           */
tqmmodu     varchar2(10),            /*资料更改者                             */
tqmdate     date,                    /*最近更改日                             */
tqm07       varchar2(10) DEFAULT ' ' NOT NULL, /*资料来源*/
tqm08       number(10),              /*抛转次数                               */
tqmud01     varchar2(255),           /*自订字段-Textedit                      */
tqmud02     varchar2(40),            /*自订字段-文字                          */
tqmud03     varchar2(40),            /*自订字段-文字                          */
tqmud04     varchar2(40),            /*自订字段-文字                          */
tqmud05     varchar2(40),            /*自订字段-文字                          */
tqmud06     varchar2(40),            /*自订字段-文字                          */
tqmud07     number(15,3),            /*自订字段-数值                          */
tqmud08     number(15,3),            /*自订字段-数值                          */
tqmud09     number(15,3),            /*自订字段-数值                          */
tqmud10     number(10),              /*自订字段-整数                          */
tqmud11     number(10),              /*自订字段-整数                          */
tqmud12     number(10),              /*自订字段-整数                          */
tqmud13     date,                    /*自订字段-日期                          */
tqmud14     date,                    /*自订字段-日期                          */
tqmud15     date,                    /*自订字段-日期                          */
tqmorig     varchar2(10),            /*资料建立部门                           */
tqmoriu     varchar2(10)             /*资料建立者                             */
);

alter table tqm_file add  constraint tqm_pk primary key  (tqm01) enable validate;
grant select on tqm_file to tiptopgp;
grant update on tqm_file to tiptopgp;
grant delete on tqm_file to tiptopgp;
grant insert on tqm_file to tiptopgp;
grant index on tqm_file to public;
grant select on tqm_file to ods;
