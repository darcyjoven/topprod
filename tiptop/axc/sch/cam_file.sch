/*
================================================================================
檔案代號:cam_file
檔案名稱:每日投入工时单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cam_file
(
cam01       date NOT NULL,           /*日期                                   */
cam02       varchar2(10) NOT NULL,   /*成本中心                               */
cam03       number(5) NOT NULL,      /*序号                                   */
                                     /*序號                                   */
cam04       varchar2(20),            /*工单编号                               */
                                     /*工單編號                               */
cam05       varchar2(23),            /*RUN CARD                               */
cam06       number(5),               /*工艺序                                 */
                                     /*製程序                                 */
cam07       number(15,3),            /*约当数量                               */
                                     /*約當數量                               */
cam08       number(15,3),            /*投入工时                               */
                                     /*投入工時                               */
cam09       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
cam10       number(15,3),            /*投入标准人工工时                       */
cam11       number(15,3),            /*投入标准机器工时                       */
camud01     varchar2(255),           /*自订字段-Textedit                      */
camud02     varchar2(40),            /*自订字段-文字                          */
camud03     varchar2(40),            /*自订字段-文字                          */
camud04     varchar2(40),            /*自订字段-文字                          */
camud05     varchar2(40),            /*自订字段-文字                          */
camud06     varchar2(40),            /*自订字段-文字                          */
camud07     number(15,3),            /*自订字段-数值                          */
camud08     number(15,3),            /*自订字段-数值                          */
camud09     number(15,3),            /*自订字段-数值                          */
camud10     number(10),              /*自订字段-整数                          */
camud11     number(10),              /*自订字段-整数                          */
camud12     number(10),              /*自订字段-整数                          */
camud13     date,                    /*自订字段-日期                          */
camud14     date,                    /*自订字段-日期                          */
camud15     date,                    /*自订字段-日期                          */
camlegal    varchar2(10) NOT NULL,   /*所属法人                               */
cam012      varchar2(10),            /*工艺段号                               */
cam081      number(15,3)             /*投入机时                               */
);

create        index cam_02 on cam_file (cam04);
alter table cam_file add  constraint cam_pk primary key  (cam01,cam02,cam03) enable validate;
grant select on cam_file to tiptopgp;
grant update on cam_file to tiptopgp;
grant delete on cam_file to tiptopgp;
grant insert on cam_file to tiptopgp;
grant index on cam_file to public;
grant select on cam_file to ods;
