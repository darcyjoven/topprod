/*
================================================================================
檔案代號:msb_file
檔案名稱:MPS 计划单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table msb_file
(
msb01       varchar2(20) NOT NULL,   /*MPS 计划编号                           */
                                     /*MPS 計劃編號                           */
msb02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
msb03       varchar2(40),            /*料号                                   */
                                     /*料號                                   */
msb04       date,                    /*预计生产完工日期                       */
                                     /*預計生產完工日期                       */
msb05       number(15,3),            /*数量                                   */
                                     /*數量                                   */
msb06       varchar2(40),            /*主料料号                               */
                                     /*主料料號                               */
msb07       date,                    /*BOM 有效日期                           */
msb08       number(15,3),            /*原始计划数量                           */
                                     /*原始計劃數量                           */
msbud01     varchar2(255),           /*自订字段-Textedit                      */
msbud02     varchar2(40),            /*自订字段-文字                          */
msbud03     varchar2(40),            /*自订字段-文字                          */
msbud04     varchar2(40),            /*自订字段-文字                          */
msbud05     varchar2(40),            /*自订字段-文字                          */
msbud06     varchar2(40),            /*自订字段-文字                          */
msbud07     number(15,3),            /*自订字段-数值                          */
msbud08     number(15,3),            /*自订字段-数值                          */
msbud09     number(15,3),            /*自订字段-数值                          */
msbud10     number(10),              /*自订字段-整数                          */
msbud11     number(10),              /*自订字段-整数                          */
msbud12     number(10),              /*自订字段-整数                          */
msbud13     date,                    /*自订字段-日期                          */
msbud14     date,                    /*自订字段-日期                          */
msbud15     date,                    /*自订字段-日期                          */
msbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
msblegal    varchar2(10) NOT NULL,   /*所属法人                               */
msb919      varchar2(50)             /*计画批号                               */
);

create        index msb_02 on msb_file (msb03);
alter table msb_file add  constraint msb_pk primary key  (msb01,msb02) enable validate;
grant select on msb_file to tiptopgp;
grant update on msb_file to tiptopgp;
grant delete on msb_file to tiptopgp;
grant insert on msb_file to tiptopgp;
grant index on msb_file to public;
grant select on msb_file to ods;
