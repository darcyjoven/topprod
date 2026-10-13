/*
================================================================================
檔案代號:ccj_file
檔案名稱:每日投入工时单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ccj_file
(
ccj01       date NOT NULL,           /*日期                                   */
ccj02       varchar2(10) NOT NULL,   /*部门                                   */
                                     /*部門                                   */
ccj03       number(5) NOT NULL,      /*序号                                   */
                                     /*序號                                   */
ccj04       varchar2(20) NOT NULL,   /*工单编号                               */
                                     /*工單編號                               */
ccj05       number(15,3) NOT NULL,   /*投入工时                               */
                                     /*投入工時                               */
ccj06       number(15,3),            /*生产数量                               */
                                     /*生產數量                               */
ccj07       number(15,3),            /*投入标准人工工时                       */
ccj08       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
ccj071      number(15,3) DEFAULT '0',/*投入标准机器工时                       */
ccjud01     varchar2(255),           /*自订字段-Textedit                      */
ccjud02     varchar2(40),            /*自订字段-文字                          */
ccjud03     varchar2(40),            /*自订字段-文字                          */
ccjud04     varchar2(40),            /*自订字段-文字                          */
ccjud05     varchar2(40),            /*自订字段-文字                          */
ccjud06     varchar2(40),            /*自订字段-文字                          */
ccjud07     number(15,3),            /*自订字段-数值                          */
ccjud08     number(15,3),            /*自订字段-数值                          */
ccjud09     number(15,3),            /*自订字段-数值                          */
ccjud10     number(10),              /*自订字段-整数                          */
ccjud11     number(10),              /*自订字段-整数                          */
ccjud12     number(10),              /*自订字段-整数                          */
ccjud13     date,                    /*自订字段-日期                          */
ccjud14     date,                    /*自订字段-日期                          */
ccjud15     date,                    /*自订字段-日期                          */
ccj051      number(15,3),            /*投入机时                               */
ccjlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index ccj_02 on ccj_file (ccj04);
alter table ccj_file add  constraint ccj_pk primary key  (ccj01,ccj02,ccj03) enable validate;
grant select on ccj_file to tiptopgp;
grant update on ccj_file to tiptopgp;
grant delete on ccj_file to tiptopgp;
grant insert on ccj_file to tiptopgp;
grant index on ccj_file to public;
grant select on ccj_file to ods;
