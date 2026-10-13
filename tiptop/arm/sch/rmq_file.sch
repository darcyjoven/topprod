/*
================================================================================
檔案代號:rmq_file
檔案名稱:RMA覆出packing资料明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rmq_file
(
rmq01       varchar2(20) NOT NULL,   /*覆出单号                               */
                                     /*覆出單號                               */
rmq02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
rmq03       number(5),               /*栈板编号                               */
                                     /*棧板編號                               */
rmq04       varchar2(11),            /*栈板长宽高                             */
                                     /*棧板長寬高                             */
rmq05       number(5),               /*箱号                                   */
                                     /*箱號                                   */
rmq06       varchar2(11),            /*箱号长宽高                             */
                                     /*箱號長寬高                             */
rmq07       number(15,3),            /*箱号重量                               */
                                     /*箱號重量                               */
rmq08       number(5),               /*c/no: 件数                             */
                                     /*c/no: 件數                             */
rmqud01     varchar2(255),           /*自订字段-Textedit                      */
rmqud02     varchar2(40),            /*自订字段-文字                          */
rmqud03     varchar2(40),            /*自订字段-文字                          */
rmqud04     varchar2(40),            /*自订字段-文字                          */
rmqud05     varchar2(40),            /*自订字段-文字                          */
rmqud06     varchar2(40),            /*自订字段-文字                          */
rmqud07     number(15,3),            /*自订字段-数值                          */
rmqud08     number(15,3),            /*自订字段-数值                          */
rmqud09     number(15,3),            /*自订字段-数值                          */
rmqud10     number(10),              /*自订字段-整数                          */
rmqud11     number(10),              /*自订字段-整数                          */
rmqud12     number(10),              /*自订字段-整数                          */
rmqud13     date,                    /*自订字段-日期                          */
rmqud14     date,                    /*自订字段-日期                          */
rmqud15     date,                    /*自订字段-日期                          */
rmqplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rmqlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table rmq_file add  constraint rmq_pk primary key  (rmq01,rmq02) enable validate;
grant select on rmq_file to tiptopgp;
grant update on rmq_file to tiptopgp;
grant delete on rmq_file to tiptopgp;
grant insert on rmq_file to tiptopgp;
grant index on rmq_file to public;
grant select on rmq_file to ods;
