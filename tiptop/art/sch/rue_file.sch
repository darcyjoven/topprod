/*
================================================================================
檔案代號:rue_file
檔案名稱:需求分配单商品单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rue_file
(
rue00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据来源*/
rue01       varchar2(20) DEFAULT ' ' NOT NULL, /*需求分配单号*/
rue011      number(5) DEFAULT '0' NOT NULL, /*项次*/
rue02       varchar2(10) DEFAULT ' ' NOT NULL, /*需求营运中心*/
rue03       varchar2(20) DEFAULT ' ' NOT NULL, /*需求单号*/
rue04       number(5) DEFAULT '0' NOT NULL, /*需求项次*/
rue05       varchar2(40),            /*产品编号                               */
rue06       varchar2(10),            /*源头营运中心                           */
rue07       varchar2(20),            /*源头单号                               */
rue08       number(5),               /*源头项次                               */
rue09       date,                    /*提出日期                               */
rue10       varchar2(1),             /*资料来源                               */
                                     /*Data From 1.Input 2.Suggest Purchase 3.S/O*/
rue11       varchar2(10),            /*取货營運中心                           */
rue12       varchar2(10),            /*供应商代码                             */
rue13       varchar2(1),             /*经营方式                               */
                                     /*Running Mode 1:Sell 2:Sell Goods On a Commission Basis (Cost) */
                                     /*3:Sell Goods On a Commission Basis (Deduction%) 4:Pool*/
rue14       varchar2(1),             /*采购类型                               */
                                     /*PO Type                                */
                                     /*1:Indent 2:Unit PO Immediacy Provide 3:Unit PO-Distribute*/
rue15       varchar2(4),             /*库存单位                               */
rue16       number(15,3),            /*已分配量                               */
rue17       varchar2(40),            /*产品条码                               */
rue18       varchar2(4),             /*请购单位                               */
rue19       number(16,8),            /*换算率                                 */
rue20       number(15,3),            /*需求量                                 */
rue21       number(15,3),            /*采购量                                 */
rue22       number(15,3),            /*配送量                                 */
rue23       number(15,3),            /*调拨量                                 */
rue24       varchar2(10),            /*拨出营运中心                           */
rue25       varchar2(1),             /*强制结束否                             */
rue26       varchar2(4),             /*采购单位                               */
rue27       number(16,8),            /*换算率                                 */
rue28       number(20,6),            /*采购单价                               */
rue29       date,                    /*交货日期                               */
rue30       varchar2(1),             /*取价类型                               */
                                     /*Price Type 1.Premium 2.Promotion 3.PR 4.Other*/
rue31       varchar2(20),            /*价格来源                               */
rue32       varchar2(10),            /*配送中心                               */
rue33       date,                    /*需求日期                               */
rue34       varchar2(8),             /*采购多角贸易流程编号                   */
rue35       varchar2(1),             /*需求类型                               */
                                     /*Demand Type 1-Replenishment 2-Ordering */
ruelegal    varchar2(10) NOT NULL,   /*所属法人                               */
rueplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rue36       varchar2(8)              /*采購多角贸易流程代碼                   */
);

create        index rue02 on rue_file (rue05);
create        index rue_03 on rue_file (rue01,rue02,rue03,rue04);
alter table rue_file add  constraint rue_pk primary key  (rue01,rue011) enable validate;
grant select on rue_file to tiptopgp;
grant update on rue_file to tiptopgp;
grant delete on rue_file to tiptopgp;
grant insert on rue_file to tiptopgp;
grant index on rue_file to public;
grant select on rue_file to ods;
