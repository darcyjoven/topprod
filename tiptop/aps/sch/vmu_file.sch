/*
================================================================================
檔案代號:vmu_file
檔案名稱:APS需求訂單檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vmu_file
(
vmu01       varchar2(10) NOT NULL,   /*APS版本                                */
vmu02       varchar2(10) NOT NULL,   /*储存版本                               */
vmu03       varchar2(60) NOT NULL,   /*需求订单编号                           */
vmu04       date,                    /*交期                                   */
vmu05       number(1),               /*可否耗用                               */
vmu06       varchar2(10),            /*客户编号                               */
vmu07       number(1),               /*是否能排程                             */
vmu08       varchar2(1),             /*需求订单类型                           */
vmu09       varchar2(40),            /*产品族编号                             */
vmu10       number(9),               /*订单优先顺序                           */
vmu11       varchar2(60),            /*销售订单编号                           */
vmu12       varchar2(60),            /*客户单号                               */
vmu13       number(15,3),            /*已出货量                               */
vmu14       varchar2(4),             /*单位                                   */
vmu15       varchar2(10),            /*客户群组编号                           */
vmu16       varchar2(10),            /*拥有者                                 */
vmu17       number(20,8),            /*转换比率                               */
vmu18       date,                    /*订单开立日期                           */
vmu19       varchar2(60),            /*分配法则                               */
vmu20       number(9),               /*运输天数                               */
vmu21       varchar2(60),            /*客户品号                               */
vmu22       number(1),               /*是否严守交期                           */
vmu23       varchar2(40),            /*料号                                   */
vmu24       number(15,3),            /*订购品项之数量                         */
vmu25       varchar2(1),             /*需求来源类别                           */
vmu26       number(5),               /*需求来源项次                           */
vmulegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vmuplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vmu_file add  constraint vmu_pk primary key  (vmu01,vmu02,vmu03) enable validate;
grant select on vmu_file to tiptopgp;
grant update on vmu_file to tiptopgp;
grant delete on vmu_file to tiptopgp;
grant insert on vmu_file to tiptopgp;
grant index on vmu_file to public;
grant select on vmu_file to ods;
