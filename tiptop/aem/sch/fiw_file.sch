/*
================================================================================
檔案代號:fiw_file
檔案名稱:设备保修工单库存异动单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fiw_file
(
fiw01       varchar2(20) NOT NULL,   /*单据编号                               */
fiw02       number(5) NOT NULL,      /*项次                                   */
fiw03       varchar2(40),            /*料件编号                               */
fiw04       varchar2(10),            /*仓库                                   */
fiw05       varchar2(10),            /*库位                                   */
fiw06       varchar2(24),            /*批号                                   */
fiw07       varchar2(4),             /*单位                                   */
fiw07_fac   number(20,8),            /*单位换算率                             */
fiw08       number(15,3),            /*异动数量                               */
fiw09       varchar2(1),             /*备件否                                 */
fiw10       number(20,6),            /*单价                                   */
fiw11       number(20,6),            /*金额                                   */
fiw20       varchar2(4),             /*单位一                                 */
fiw21       number(20,8),            /*单位一转换率(与库存单位)               */
fiw22       number(15,3),            /*单位一数量                             */
fiw23       varchar2(4),             /*单位二                                 */
fiw24       number(20,8),            /*单位二转换率(与库存单位)               */
fiw25       number(15,3),            /*单位二数量                             */
fiw41       varchar2(10),            /*项目编号                               */
fiw42       varchar2(30),            /*WBS编码                                */
fiw43       varchar2(4),             /*活动编号                               */
fiw44       varchar2(10),            /*理由码                                 */
fiwud01     varchar2(255),           /*自订字段-Textedit                      */
fiwud02     varchar2(40),            /*自订字段-文字                          */
fiwud03     varchar2(40),            /*自订字段-文字                          */
fiwud04     varchar2(40),            /*自订字段-文字                          */
fiwud05     varchar2(40),            /*自订字段-文字                          */
fiwud06     varchar2(40),            /*自订字段-文字                          */
fiwud07     number(15,3),            /*自订字段-数值                          */
fiwud08     number(15,3),            /*自订字段-数值                          */
fiwud09     number(15,3),            /*自订字段-数值                          */
fiwud10     number(10),              /*自订字段-整数                          */
fiwud11     number(10),              /*自订字段-整数                          */
fiwud12     number(10),              /*自订字段-整数                          */
fiwud13     date,                    /*自订字段-日期                          */
fiwud14     date,                    /*自订字段-日期                          */
fiwud15     date,                    /*自订字段-日期                          */
fiwplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
fiwlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table fiw_file add  constraint fiw_pk primary key  (fiw01,fiw02) enable validate;
grant select on fiw_file to tiptopgp;
grant update on fiw_file to tiptopgp;
grant delete on fiw_file to tiptopgp;
grant insert on fiw_file to tiptopgp;
grant index on fiw_file to public;
grant select on fiw_file to ods;
