/*
================================================================================
檔案代號:ibi_file
檔案名稱:包装关系单身档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ibi_file
(
ibi01       varchar2(80) DEFAULT ' ' NOT NULL, /*条码编号*/
ibi02       number(5) DEFAULT '0' NOT NULL, /*项次*/
ibi03       varchar2(10),            /*No use                                 */
ibi04       varchar2(80),            /*条码编号(单身)                         */
ibi05       number(15,3) DEFAULT '0' NOT NULL, /*数量*/
ibi06       varchar2(1) DEFAULT ' ' NOT NULL, /*展开库存计算*/
ibiud01     varchar2(255),           /*自订字段-Textedit                      */
ibiud02     varchar2(40),            /*自订字段-文字                          */
ibiud03     varchar2(40),            /*自订字段-文字                          */
ibiud04     varchar2(40),            /*自订字段-文字                          */
ibiud05     varchar2(40),            /*自订字段-文字                          */
ibiud06     varchar2(40),            /*自订字段-文字                          */
ibiud07     number(15,3),            /*自订字段-数值                          */
ibiud08     number(15,3),            /*自订字段-数值                          */
ibiud09     number(15,3),            /*自订字段-数值                          */
ibiud10     number(10),              /*自订字段-整数                          */
ibiud11     number(10),              /*自订字段-整数                          */
ibiud12     number(10),              /*自订字段-整数                          */
ibiud13     date,                    /*自订字段-日期                          */
ibiud14     date,                    /*自订字段-日期                          */
ibiud15     date                     /*自订字段-日期                          */
);

alter table ibi_file add  constraint ibi_pk primary key  (ibi01,ibi02) enable validate;
grant select on ibi_file to tiptopgp;
grant update on ibi_file to tiptopgp;
grant delete on ibi_file to tiptopgp;
grant insert on ibi_file to tiptopgp;
grant index on ibi_file to public;
grant select on ibi_file to ods;
