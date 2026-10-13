/*
================================================================================
檔案代號:all_file
檔案名稱:预付购料采购单身历次更改历史记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table all_file
(
all00       varchar2(1) DEFAULT '0' NOT NULL, /*更改次数*/
                                     /*修改次數 (95/11/10 By Roger)       95/11*/
all01       varchar2(20) NOT NULL,   /*L/C No.                                */
                                     /*L/C No                             95/11*/
all02       number(5) NOT NULL,      /*序号                                   */
                                     /*序號                                   */
all04       varchar2(20),            /*采购单号                               */
                                     /*採購單號                               */
all05       number(5),               /*采购单项次                             */
                                     /*採購單項次                             */
all06       number(20,6),            /*单价                                   */
                                     /*單價                                   */
all07       number(15,3),            /*数量                                   */
                                     /*數量                                   */
all08       number(20,6),            /*金额                                   */
                                     /*金額                                   */
all11       varchar2(40),            /*采购料号                               */
                                     /*採購料號                               */
all12       number(15,3),            /*已到货数量                             */
                                     /*已到貨數量      99/05/10 modify        */
all13       number(20,6),            /*已到货金额                             */
                                     /*已到貨金額      99/05/10 modify        */
all930      varchar2(10),            /*成本中心                               */
all80       varchar2(4),             /*单位一                                 */
all81       number(20,8),            /*单位一换算率(与库存单位)               */
all82       number(15,3),            /*单位一数量                             */
all83       varchar2(4),             /*单位二                                 */
all84       number(20,8),            /*单位二换算率(与库存单位)               */
all85       number(15,3),            /*单位二数量                             */
all86       varchar2(4),             /*计价单位                               */
all87       number(15,3),            /*计价数量                               */
allud01     varchar2(255),           /*自订字段-Textedit                      */
allud02     varchar2(40),            /*自订字段-文字                          */
allud03     varchar2(40),            /*自订字段-文字                          */
allud04     varchar2(40),            /*自订字段-文字                          */
allud05     varchar2(40),            /*自订字段-文字                          */
allud06     varchar2(40),            /*自订字段-文字                          */
allud07     number(15,3),            /*自订字段-数值                          */
allud08     number(15,3),            /*自订字段-数值                          */
allud09     number(15,3),            /*自订字段-数值                          */
allud10     number(10),              /*自订字段-整数                          */
allud11     number(10),              /*自订字段-整数                          */
allud12     number(10),              /*自订字段-整数                          */
allud13     date,                    /*自订字段-日期                          */
allud14     date,                    /*自订字段-日期                          */
allud15     date,                    /*自订字段-日期                          */
alllegal    varchar2(10) NOT NULL,   /*所属法人                               */
all44       varchar2(10)             /*资料来源营运中心                       */
);

alter table all_file add  constraint all_pk primary key  (all01,all02,all00) enable validate;
grant select on all_file to tiptopgp;
grant update on all_file to tiptopgp;
grant delete on all_file to tiptopgp;
grant insert on all_file to tiptopgp;
grant index on all_file to public;
grant select on all_file to ods;
