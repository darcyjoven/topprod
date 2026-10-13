/*
================================================================================
檔案代號:fce_file
檔案名稱:固定资产抵押单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fce_file
(
fce01       varchar2(20) NOT NULL,   /*申请编号                               */
fce02       number(5),               /*项次                                   */
fce03       varchar2(10) NOT NULL,   /*财产编号                               */
fce031      varchar2(4) NOT NULL,    /*附号                                   */
fce04       number(20,6),            /*帐面价值                               */
fce05       number(20,6),            /*抵押金额                               */
fce06       varchar2(10),            /*合并财产编号                           */
fce061      varchar2(4),             /*合并附号                               */
fce07       varchar2(1),             /*状态码                                 */
fce08       varchar2(10),            /*银行标签                               */
fce09       number(20,6),            /*合并前帐面价值                         */
fce10       number(20,6),            /*合并前抵押金额                         */
fce11       number(5),               /*合并前数量                             */
fce12       varchar2(4),             /*合并前单位                             */
fce20       number(5),               /*数量                                   */
fce21       varchar2(4),             /*单位                                   */
fce22       varchar2(10),            /*No Use                                 */
fce23       varchar2(10),            /*No Use                                 */
fce24       number(20,6),            /*成本                                   */
fce25       number(20,6),            /*合并前成本                             */
fceud01     varchar2(255),           /*自订字段-Textedit                      */
fceud02     varchar2(40),            /*自订字段-文字                          */
fceud03     varchar2(40),            /*自订字段-文字                          */
fceud04     varchar2(40),            /*自订字段-文字                          */
fceud05     varchar2(40),            /*自订字段-文字                          */
fceud06     varchar2(40),            /*自订字段-文字                          */
fceud07     number(15,3),            /*自订字段-数值                          */
fceud08     number(15,3),            /*自订字段-数值                          */
fceud09     number(15,3),            /*自订字段-数值                          */
fceud10     number(10),              /*自订字段-整数                          */
fceud11     number(10),              /*自订字段-整数                          */
fceud12     number(10),              /*自订字段-整数                          */
fceud13     date,                    /*自订字段-日期                          */
fceud14     date,                    /*自订字段-日期                          */
fceud15     date,                    /*自订字段-日期                          */
fcelegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table fce_file add  constraint fce_pk primary key  (fce01,fce03,fce031) enable validate;
grant select on fce_file to tiptopgp;
grant update on fce_file to tiptopgp;
grant delete on fce_file to tiptopgp;
grant insert on fce_file to tiptopgp;
grant index on fce_file to public;
grant select on fce_file to ods;
