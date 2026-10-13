/*
================================================================================
檔案代號:msv_file
檔案名稱:多营运中心MRP供需明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table msv_file
(
msv000      varchar2(10) NOT NULL,   /*汇总版本号                             */
msv00       number(10) NOT NULL,     /*序号                                   */
msv01       varchar2(40) NOT NULL,   /*料号                                   */
msv02       varchar2(10) NOT NULL,   /*限定厂商编号                           */
msv03       date NOT NULL,           /*供需间距日期                           */
msv031      varchar2(10) NOT NULL,   /*分营运中心编号                         */
msv032      varchar2(10),            /*分营运中心MRP版本号                    */
msv041      number(15,3),            /*需求:受订量                            */
msv043      number(15,3),            /*需求:计划备料量                        */
                                     /*Req.:Planned Allotment Qt(MPS Down Level Explode '43' */
                                     /*               +PLM Actl.W/O Down Level Explode'45')*/
msv044      number(15,3),            /*需求:工单备料量                        */
                                     /*Req.:W/O Allotment Qt(Actl.W/O Down Level Explode '44'*/
msv051      number(15,3),            /*供给:库存量                            */
                                     /*Supply:Inventory Qty                   */
msv052      number(15,3),            /*供给:在验量                            */
                                     /*Supply:Qty On QC                       */
msv053      number(15,3),            /*供给:库存量                            */
                                     /*Supply:Inventory Qty (Substitute Item) */
msv061      number(15,3),            /*供给:请购量                            */
                                     /*Supply:Purchase Requisite Qty          */
msv062      number(15,3),            /*供给:在采量                            */
                                     /*Supply:Qty Outside (P/O Released)      */
msv063      number(15,3),            /*供给:在外量                            */
                                     /*Supply:Qty Outside (P/O Released)      */
msv064      number(15,3),            /*供给:在制量                            */
                                     /*Supply:WIP Qty (Confirmed W/O Anticipated Complete)*/
msv065      number(15,3),            /*供给:计划产                            */
                                     /*Supply:Plan.Pro.Qt (MPS Planned Production)*/
msv066      number(15,3),            /*已冻结交期的供给量(PR/PO/WO)           */
                                     /*Supply Qty of Frozen Delivery Schedule(PR/PO/WO)*/
                                     /*  Person been Frozen Delivery Schedule Can't Reset The Schedule*/
                                     /*  And Can Reset Supply Quntity of the Schedule = 61+62+63+64+65-66*/
msv070      number(15,3),            /*预估结存                               */
msv12       number(15,3),            /*建议调拨出数量                         */
msv13       number(15,3),            /*建议调拨入数量                         */
msv14       number(15,3),            /*建议交期重排导至供给调整数             */
                                     /*No Use                                 */
msv08       number(15,3),            /*预计结存                               */
                                     /*Estimated Balance                      */
msv16       number(15,3)             /*建议采购(PLP)数量                      */
                                     /*Suggest.Purchase(PLP)/Suggest.W/O(PLP)Qt*/
);

create        index msv_02 on msv_file (msv00);
alter table msv_file add  constraint msv_pk primary key  (msv01,msv02,msv03,msv000,msv031) enable validate;
grant select on msv_file to tiptopgp;
grant update on msv_file to tiptopgp;
grant delete on msv_file to tiptopgp;
grant insert on msv_file to tiptopgp;
grant index on msv_file to public;
grant select on msv_file to ods;
