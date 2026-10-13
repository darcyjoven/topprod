/*
================================================================================
檔案代號:cof_file
檔案名稱:商品编号币种单价资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cof_file
(
cof01       varchar2(40) NOT NULL,   /*商品编号                               */
cof02       varchar2(4) NOT NULL,    /*币种                                   */
cof03       number(20,6),            /*单价                                   */
cof04       varchar2(4),             /*No Use                                 */
cof05       varchar2(4),             /*No Use                                 */
cof06       number(16,8),            /*No Use                                 */
cof07       varchar2(1),             /*No Use                                 */
cof08       varchar2(1),             /*No Use                                 */
cof09       varchar2(1),             /*No Use                                 */
cofud01     varchar2(255),           /*自订字段-Textedit                      */
cofud02     varchar2(40),            /*自订字段-文字                          */
cofud03     varchar2(40),            /*自订字段-文字                          */
cofud04     varchar2(40),            /*自订字段-文字                          */
cofud05     varchar2(40),            /*自订字段-文字                          */
cofud06     varchar2(40),            /*自订字段-文字                          */
cofud07     number(15,3),            /*自订字段-数值                          */
cofud08     number(15,3),            /*自订字段-数值                          */
cofud09     number(15,3),            /*自订字段-数值                          */
cofud10     number(10),              /*自订字段-整数                          */
cofud11     number(10),              /*自订字段-整数                          */
cofud12     number(10),              /*自订字段-整数                          */
cofud13     date,                    /*自订字段-日期                          */
cofud14     date,                    /*自订字段-日期                          */
cofud15     date                     /*自订字段-日期                          */
);

alter table cof_file add  constraint cof_pk primary key  (cof01,cof02) enable validate;
grant select on cof_file to tiptopgp;
grant update on cof_file to tiptopgp;
grant delete on cof_file to tiptopgp;
grant insert on cof_file to tiptopgp;
grant index on cof_file to public;
grant select on cof_file to ods;
