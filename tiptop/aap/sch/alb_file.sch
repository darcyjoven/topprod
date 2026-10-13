/*
================================================================================
檔案代號:alb_file
檔案名稱:预付购料采购单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table alb_file
(
alb01       varchar2(20) NOT NULL,   /*L/C No.                                */
                                     /*L/C No                             95/11*/
alb02       number(5) NOT NULL,      /*序号                                   */
                                     /*序號                                   */
alb03       varchar2(10),            /*No Use                                 */
alb04       varchar2(20),            /*采购单号                               */
                                     /*採購單號                               */
alb05       number(5),               /*采购单项次                             */
                                     /*採購單項次                             */
alb06       number(20,6),            /*单价                                   */
                                     /*單價                                   */
alb07       number(15,3),            /*数量                                   */
                                     /*數量                                   */
alb08       number(20,6),            /*金额                                   */
                                     /*金額                                   */
alb11       varchar2(40),            /*采购料号                               */
                                     /*採購料號                               */
alb12       number(15,3),            /*已到货数量                             */
                                     /*已到貨數量                             */
alb13       number(20,6),            /*已到货金额                             */
                                     /*已到貨金額                             */
alb930      varchar2(10),            /*成本中心                               */
alb80       varchar2(4),             /*单位一                                 */
alb81       number(20,8),            /*单位一换算率(与库存单位)               */
alb82       number(15,3),            /*单位一数量                             */
alb83       varchar2(4),             /*单位二                                 */
alb84       number(20,8),            /*单位二换算率(与库存单位)               */
alb85       number(15,3),            /*单位二数量                             */
alb86       varchar2(4),             /*计价单位                               */
alb87       number(15,3),            /*计价数量                               */
albud01     varchar2(255),           /*自订字段-Textedit                      */
albud02     varchar2(40),            /*自订字段-文字                          */
albud03     varchar2(40),            /*自订字段-文字                          */
albud04     varchar2(40),            /*自订字段-文字                          */
albud05     varchar2(40),            /*自订字段-文字                          */
albud06     varchar2(40),            /*自订字段-文字                          */
albud07     number(15,3),            /*自订字段-数值                          */
albud08     number(15,3),            /*自订字段-数值                          */
albud09     number(15,3),            /*自订字段-数值                          */
albud10     number(10),              /*自订字段-整数                          */
albud11     number(10),              /*自订字段-整数                          */
albud12     number(10),              /*自订字段-整数                          */
albud13     date,                    /*自订字段-日期                          */
albud14     date,                    /*自订字段-日期                          */
albud15     date,                    /*自订字段-日期                          */
alblegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create unique index alb_03 on alb_file (alb01,alb04,alb05);
create        index alb_02 on alb_file (alb04,alb05);
alter table alb_file add  constraint alb_pk primary key  (alb01,alb02) enable validate;
grant select on alb_file to tiptopgp;
grant update on alb_file to tiptopgp;
grant delete on alb_file to tiptopgp;
grant insert on alb_file to tiptopgp;
grant index on alb_file to public;
grant select on alb_file to ods;
