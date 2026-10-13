/*
================================================================================
檔案代號:bnd_file
檔案名稱:保税产品结构资料单头
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bnd_file
(
bnd01       varchar2(40) NOT NULL,   /*主件料号                               */
bnd02       date NOT NULL,           /*生效日期                               */
bnd03       date,                    /*失效日期                               */
bnd04       varchar2(30),            /*BOM编号                                */
bnd101      varchar2(40),            /*NO USE                                 */
bnd102      varchar2(1),             /*保税BOM打印否(Y/N)                     */
bndud01     varchar2(255),           /*自订字段-Textedit                      */
bndud02     varchar2(40),            /*自订字段-文字                          */
bndud03     varchar2(40),            /*自订字段-文字                          */
bndud04     varchar2(40),            /*自订字段-文字                          */
bndud05     varchar2(40),            /*自订字段-文字                          */
bndud06     varchar2(40),            /*自订字段-文字                          */
bndud07     number(15,3),            /*自订字段-数值                          */
bndud08     number(15,3),            /*自订字段-数值                          */
bndud09     number(15,3),            /*自订字段-数值                          */
bndud10     number(10),              /*自订字段-整数                          */
bndud11     number(10),              /*自订字段-整数                          */
bndud12     number(10),              /*自订字段-整数                          */
bndud13     date,                    /*自订字段-日期                          */
bndud14     date,                    /*自订字段-日期                          */
bndud15     date                     /*自订字段-日期                          */
);

alter table bnd_file add  constraint bnd_pk primary key  (bnd01,bnd02) enable validate;
grant select on bnd_file to tiptopgp;
grant update on bnd_file to tiptopgp;
grant delete on bnd_file to tiptopgp;
grant insert on bnd_file to tiptopgp;
grant index on bnd_file to public;
grant select on bnd_file to ods;
