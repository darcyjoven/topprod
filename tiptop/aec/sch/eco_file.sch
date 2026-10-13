/*
================================================================================
檔案代號:eco_file
檔案名稱:产品工艺资源资料维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table eco_file
(
eco01       varchar2(40) NOT NULL,   /*料件编号                               */
eco02       varchar2(10) NOT NULL,   /*工艺编号                               */
eco03       number(5) NOT NULL,      /*工艺序号                               */
eco04       varchar2(10) NOT NULL,   /*资源编号                               */
eco05       number(15,3),            /*固定耗用                               */
eco06       number(15,3),            /*变动耗用                               */
eco07       number(15,3),            /*耗用批量                               */
eco08       varchar2(255),           /*备注                                   */
ecoud01     varchar2(255),           /*自订字段-Textedit                      */
ecoud02     varchar2(40),            /*自订字段-文字                          */
ecoud03     varchar2(40),            /*自订字段-文字                          */
ecoud04     varchar2(40),            /*自订字段-文字                          */
ecoud05     varchar2(40),            /*自订字段-文字                          */
ecoud06     varchar2(40),            /*自订字段-文字                          */
ecoud07     number(15,3),            /*自订字段-数值                          */
ecoud08     number(15,3),            /*自订字段-数值                          */
ecoud09     number(15,3),            /*自订字段-数值                          */
ecoud10     number(10),              /*自订字段-整数                          */
ecoud11     number(10),              /*自订字段-整数                          */
ecoud12     number(10),              /*自订字段-整数                          */
ecoud13     date,                    /*自订字段-日期                          */
ecoud14     date,                    /*自订字段-日期                          */
ecoud15     date,                    /*自订字段-日期                          */
eco012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table eco_file add  constraint eco_pk primary key  (eco01,eco02,eco03,eco04,eco012) enable validate;
grant select on eco_file to tiptopgp;
grant update on eco_file to tiptopgp;
grant delete on eco_file to tiptopgp;
grant insert on eco_file to tiptopgp;
grant index on eco_file to public;
grant select on eco_file to ods;
