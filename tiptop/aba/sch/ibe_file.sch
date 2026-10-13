/*
================================================================================
檔案代號:ibe_file
檔案名稱:条码管理系统单据性质档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ibe_file
(
ibedesc     varchar2(80),            /*单据名称                               */
ibemxno     varchar2(20),            /*已用单号                               */
ibeslip     varchar2(5) DEFAULT ' ' NOT NULL, /*单别*/
ibetype     varchar2(2) DEFAULT ' ', /*单据性质                               */
ibeud01     varchar2(255),           /*自订字段-Textedit                      */
ibeud02     varchar2(40),            /*自订字段-文字                          */
ibeud03     varchar2(40),            /*自订字段-文字                          */
ibeud04     varchar2(40),            /*自订字段-文字                          */
ibeud05     varchar2(40),
ibeud06     varchar2(40),            /*自订字段-文字                          */
ibeud07     number(15,3),            /*自订字段-数值                          */
ibeud08     number(15,3),            /*自订字段-数值                          */
ibeud09     number(15,3),            /*自订字段-数值                          */
ibeud10     number(10),              /*自订字段-整数                          */
ibeud11     number(10),              /*自订字段-整数                          */
ibeud12     number(10),              /*自订字段-整数                          */
ibeud13     date,                    /*自订字段-日期                          */
ibeud14     date,                    /*自订字段-日期                          */
ibeud15     date                     /*自订字段-日期                          */
);

alter table ibe_file add  constraint ibe_pk primary key  (ibeslip) enable validate;
grant select on ibe_file to tiptopgp;
grant update on ibe_file to tiptopgp;
grant delete on ibe_file to tiptopgp;
grant insert on ibe_file to tiptopgp;
grant index on ibe_file to public;
grant select on ibe_file to ods;
