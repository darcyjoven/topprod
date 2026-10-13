/*
================================================================================
檔案代號:fir_file
檔案名稱:设备检查记录单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fir_file
(
fir01       varchar2(20) NOT NULL,   /*检查单号                               */
fir02       number(5) NOT NULL,      /*序号                                   */
fir03       varchar2(4),             /*项目                                   */
fir04       varchar2(1),             /*项目判定                               */
firud01     varchar2(255),           /*自订字段-Textedit                      */
firud02     varchar2(40),            /*自订字段-文字                          */
firud03     varchar2(40),            /*自订字段-文字                          */
firud04     varchar2(40),            /*自订字段-文字                          */
firud05     varchar2(40),            /*自订字段-文字                          */
firud06     varchar2(40),            /*自订字段-文字                          */
firud07     number(15,3),            /*自订字段-数值                          */
firud08     number(15,3),            /*自订字段-数值                          */
firud09     number(15,3),            /*自订字段-数值                          */
firud10     number(10),              /*自订字段-整数                          */
firud11     number(10),              /*自订字段-整数                          */
firud12     number(10),              /*自订字段-整数                          */
firud13     date,                    /*自订字段-日期                          */
firud14     date,                    /*自订字段-日期                          */
firud15     date,                    /*自订字段-日期                          */
firplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
firlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table fir_file add  constraint fir_pk primary key  (fir01,fir02) enable validate;
grant select on fir_file to tiptopgp;
grant update on fir_file to tiptopgp;
grant delete on fir_file to tiptopgp;
grant insert on fir_file to tiptopgp;
grant index on fir_file to public;
grant select on fir_file to ods;
