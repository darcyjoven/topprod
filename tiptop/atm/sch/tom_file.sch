/*
================================================================================
檔案代號:tom_file
檔案名稱:广告合同资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tom_file
(
tom01       varchar2(10) NOT NULL,   /*合约编号                               */
tom02       number(5) NOT NULL,      /*合约项次                               */
tom03       varchar2(10),            /*媒体编号                               */
tom04       number(5),               /*媒体项目明细                           */
tom05       number(20,6),            /*单价                                   */
tom06       number(15,3),            /*折扣                                   */
tom07       number(20,6),            /*净价                                   */
tom08       number(9),               /*次数小计                               */
tom09       number(20,6),            /*金额小计                               */
tom10       varchar2(255),           /*备注                                   */
tomud01     varchar2(255),           /*自订字段-Textedit                      */
tomud02     varchar2(40),            /*自订字段-文字                          */
tomud03     varchar2(40),            /*自订字段-文字                          */
tomud04     varchar2(40),            /*自订字段-文字                          */
tomud05     varchar2(40),            /*自订字段-文字                          */
tomud06     varchar2(40),            /*自订字段-文字                          */
tomud07     number(15,3),            /*自订字段-数值                          */
tomud08     number(15,3),            /*自订字段-数值                          */
tomud09     number(15,3),            /*自订字段-数值                          */
tomud10     number(10),              /*自订字段-整数                          */
tomud11     number(10),              /*自订字段-整数                          */
tomud12     number(10),              /*自订字段-整数                          */
tomud13     date,                    /*自订字段-日期                          */
tomud14     date,                    /*自订字段-日期                          */
tomud15     date                     /*自订字段-日期                          */
);

alter table tom_file add  constraint tom_pk primary key  (tom01,tom02) enable validate;
grant select on tom_file to tiptopgp;
grant update on tom_file to tiptopgp;
grant delete on tom_file to tiptopgp;
grant insert on tom_file to tiptopgp;
grant index on tom_file to public;
grant select on tom_file to ods;
