/*
================================================================================
檔案代號:shf_file
檔案名稱:稼动效率资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table shf_file
(
shf01       date NOT NULL,           /*日期                                   */
shf02       varchar2(10) NOT NULL,   /*员工编号                               */
                                     /*員工編號                               */
shf03       varchar2(10) NOT NULL,   /*线/班别编号                            */
                                     /*線/班別代號                            */
shfud01     varchar2(255),           /*自订字段-Textedit                      */
shfud02     varchar2(40),            /*自订字段-文字                          */
shfud03     varchar2(40),            /*自订字段-文字                          */
shfud04     varchar2(40),            /*自订字段-文字                          */
shfud05     varchar2(40),            /*自订字段-文字                          */
shfud06     varchar2(40),            /*自订字段-文字                          */
shfud07     number(15,3),            /*自订字段-数值                          */
shfud08     number(15,3),            /*自订字段-数值                          */
shfud09     number(15,3),            /*自订字段-数值                          */
shfud10     number(10),              /*自订字段-整数                          */
shfud11     number(10),              /*自订字段-整数                          */
shfud12     number(10),              /*自订字段-整数                          */
shfud13     date,                    /*自订字段-日期                          */
shfud14     date,                    /*自订字段-日期                          */
shfud15     date,                    /*自订字段-日期                          */
shfplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
shflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table shf_file add  constraint shf_pk primary key  (shf01,shf02,shf03) enable validate;
grant select on shf_file to tiptopgp;
grant update on shf_file to tiptopgp;
grant delete on shf_file to tiptopgp;
grant insert on shf_file to tiptopgp;
grant index on shf_file to public;
grant select on shf_file to ods;
