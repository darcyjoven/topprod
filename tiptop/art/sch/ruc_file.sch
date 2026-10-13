/*
================================================================================
檔案代號:ruc_file
檔案名稱:需求汇总表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ruc_file
(
ruc00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据来源 1-请购单*/
ruc01       varchar2(10) DEFAULT ' ' NOT NULL, /*需求营运中心*/
ruc02       varchar2(20) DEFAULT ' ' NOT NULL, /*需求单号*/
ruc03       number(5) DEFAULT '0' NOT NULL, /*项次*/
ruc04       varchar2(40),            /*产品编号                               */
ruc05       date,                    /*提出日期                               */
ruc06       varchar2(10),            /*取货营运中心                           */
ruc07       varchar2(1),             /*来源类型 1-手工录入 2-补货建           */
ruc08       varchar2(20),            /*来源单号                               */
ruc09       number(5),               /*来源项次                               */
ruc10       varchar2(10),            /*供应商代码                             */
ruc11       varchar2(1),             /*经营方式 1-经销 2-成本代销 3-          */
                                     /*Operating methods: 1- Distribution 2- Cost Consignment 3- Deduction Rate Consignment 4-Joint Venture*/
ruc12       varchar2(1),             /*采购类型 1-自订货 2-统采直供           */
                                     /*Purchase Type 1-Self-Ordering 2-Unified Pur & Direct Supply 3-Unified Pur & Dist.*/
ruc13       varchar2(4),             /*库存单位                               */
ruc14       varchar2(40),            /*商品条码                               */
ruc15       varchar2(80),            /*品名规格                               */
ruc16       varchar2(4),             /*请购单位                               */
ruc17       number(16,8),            /*换算率-请购单位：库存单位              */
                                     /*Conversion Rate - Requisition Unit: Stock Unit*/
ruc18       number(15,3),            /*需求量                                 */
ruc19       number(15,3),            /*已分采购量                             */
ruc20       number(15,3),            /*已分配送量                             */
ruc21       number(15,3),            /*已分调拨量                             */
ruc22       varchar2(1),             /*结案码 6:结案-正常 7:结案-结           */
                                     /*Closing Code 6. Closing - Normal 7. Closing - Long-Term 8. Closing - Short-Term*/
ruc23       varchar2(10),            /*源头营运中心                           */
ruc24       varchar2(20),            /*源头单号                               */
ruc25       number(5),               /*源头项次                               */
ruc26       varchar2(10),            /*配送中心                               */
ruc27       date,                    /*需求日期                               */
ruc28       varchar2(1),             /*需求类型 1-补获 2-订货                 */
                                     /*Demand Type 1-Replenishment 2-Ordering */
ruc29       varchar2(1),             /*送货上门 Y-是 N-否                     */
ruc30       varchar2(10),            /*采购中心                               */
ruc31       varchar2(8),             /*需求时间                               */
ruc32       varchar2(10),
ruc33       varchar2(1) DEFAULT ' ' NOT NULL,
ruc34       varchar2(20)
);

create        index ruc_02 on ruc_file (ruc04);
alter table ruc_file add  constraint ruc_pk primary key  (ruc00,ruc01,ruc02,ruc03) enable validate;
grant select on ruc_file to tiptopgp;
grant update on ruc_file to tiptopgp;
grant delete on ruc_file to tiptopgp;
grant insert on ruc_file to tiptopgp;
grant index on ruc_file to public;
grant select on ruc_file to ods;
