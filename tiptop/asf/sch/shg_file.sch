/*
================================================================================
檔案代號:shg_file
檔案名稱:稼动效率资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table shg_file
(
shg01       date NOT NULL,           /*日期                                   */
shg02       varchar2(10) NOT NULL,   /*员工编号                               */
                                     /*員工編號                               */
shg021      varchar2(10) NOT NULL,   /*班别编号                               */
                                     /*班別編號                               */
shg03       number(5) NOT NULL,      /*序号                                   */
                                     /*序號                                   */
shg04       varchar2(10),            /*转稼原因                               */
                                     /*轉稼原因                               */
shg05       number(10,4),            /*转稼工时                               */
                                     /*轉稼工時                               */
shg06       varchar2(20),            /*工单号码                               */
                                     /*工單號碼                               */
shg07       varchar2(10),            /*工艺编号                               */
                                     /*製程代號                               */
shg08       varchar2(40),            /*料号                                   */
                                     /*料號                                   */
shg09       number(10,4),            /*核准工时                               */
                                     /*核准工時                               */
shg10       varchar2(10),            /*责任单位                               */
                                     /*責任單位                               */
shg11       varchar2(1),             /*审核否                                 */
                                     /*確認否                                 */
shgud01     varchar2(255),           /*自订字段-Textedit                      */
shgud02     varchar2(40),            /*自订字段-文字                          */
shgud03     varchar2(40),            /*自订字段-文字                          */
shgud04     varchar2(40),            /*自订字段-文字                          */
shgud05     varchar2(40),            /*自订字段-文字                          */
shgud06     varchar2(40),            /*自订字段-文字                          */
shgud07     number(15,3),            /*自订字段-数值                          */
shgud08     number(15,3),            /*自订字段-数值                          */
shgud09     number(15,3),            /*自订字段-数值                          */
shgud10     number(10),              /*自订字段-整数                          */
shgud11     number(10),              /*自订字段-整数                          */
shgud12     number(10),              /*自订字段-整数                          */
shgud13     date,                    /*自订字段-日期                          */
shgud14     date,                    /*自订字段-日期                          */
shgud15     date,                    /*自订字段-日期                          */
shgplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
shglegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table shg_file add  constraint shg_pk primary key  (shg01,shg02,shg021,shg03) enable validate;
grant select on shg_file to tiptopgp;
grant update on shg_file to tiptopgp;
grant delete on shg_file to tiptopgp;
grant insert on shg_file to tiptopgp;
grant index on shg_file to public;
grant select on shg_file to ods;
