/*
================================================================================
檔案代號:vld_file
檔案名稱:MDS沖銷條件記錄檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vld_file
(
vld01       varchar2(10) NOT NULL,   /*APS版本                                */
vld02       varchar2(10) NOT NULL,   /*储存版本                               */
vld03       date,                    /*资料日期(起始)                         */
vld04       date,                    /*资料日期(截止)                         */
vld05       varchar2(1),             /*日期选择                               */
vld06       varchar2(1),             /*使用时距方式                           */
vld07       varchar2(1),             /*销售订单纳入否                         */
vld08       varchar2(1),             /*合约订单纳入否                         */
vld09       varchar2(1),             /*独立性需求纳入否                       */
vld10       varchar2(1),             /*需求纳入方式                           */
vld11       varchar2(1),             /*预测数量来源                           */
vld12       date,                    /*运行日期                               */
vld13       varchar2(8),             /*运行时间                               */
vld14       varchar2(10),            /*时距编号                               */
vld15       varchar2(1),             /*前期资料纳入第1期做冲销否              */
vld16       varchar2(1),             /*预测料号纳入否                         */
vld17       varchar2(1),             /*预测资料来源                           */
vld18       date,                    /*计划基准日                             */
vldplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
vldlegal    varchar2(10) NOT NULL,   /*所属法人                               */
vld19       number(5)                /*期数                                   */
);

alter table vld_file add  constraint vld_pk primary key  (vld01,vld02) enable validate;
grant select on vld_file to tiptopgp;
grant update on vld_file to tiptopgp;
grant delete on vld_file to tiptopgp;
grant insert on vld_file to tiptopgp;
grant index on vld_file to public;
grant select on vld_file to ods;
