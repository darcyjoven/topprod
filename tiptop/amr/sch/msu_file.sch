/*
================================================================================
檔案代號:msu_file
檔案名稱:多营运中心MRP供需汇总档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table msu_file
(
msu000      varchar2(10) NOT NULL,   /*汇总版本号                             */
msu00       number(10) NOT NULL,     /*序号                                   */
msu01       varchar2(40) NOT NULL,   /*料号                                   */
msu02       varchar2(10) NOT NULL,   /*限定厂商编号                           */
msu03       date NOT NULL,           /*供需间距日期                           */
msu041      number(15,3),            /*需求:受订量                            */
msu043      number(15,3),            /*需求:计划备料量                        */
                                     /*Req.:Planned Allotment Qt(MPS Down Level Explode '43' + PLM W/O Down Level Explode'45')*/
msu044      number(15,3),            /*需求:工单备料量                        */
                                     /*Req.:W/O Allotment Qt(Actl.W/O Down Level Explode '44'*/
msu051      number(15,3),            /*供给:库存量                            */
                                     /*Supply:Inventory Qty                   */
msu052      number(15,3),            /*供给:在验量                            */
                                     /*Supply:Qty On QC                       */
msu053      number(15,3),            /*供给:库存量                            */
                                     /*Supply:Inventory Qty (Substitute Item) */
msu061      number(15,3),            /*供给:请购量                            */
                                     /*Supply:Purchase Requisite Qty          */
msu062      number(15,3),            /*供给:在采量                            */
                                     /*Supply:Qty Outside (P/O Released)      */
msu063      number(15,3),            /*供给:在外量                            */
                                     /*Supply:Qty Outside (P/O Released)      */
msu064      number(15,3),            /*供给:在制量                            */
                                     /*Supply:WIP Qty (Confirmed W/O Anticipated Complete)*/
msu065      number(15,3),            /*供给:计划产                            */
                                     /*Supply:Plan.Pro.Qt (MPS Planned Production)*/
msu066      number(15,3),            /*已冻结交期的供给量(PR/PO/WO)           */
                                     /*Supply Qty of Frozen Delivery Schedule(PR/PO/WO)*/
                                     /*  Person been Frozen Delivery Schedule Can't Reset The Schedule*/
                                     /*  And Can Reset Supply Quntity of the Schedule = 61+62+63+64+65-66*/
msu071      number(15,3),            /*建议交期重排导至供给减少数             */
                                     /*Supply Qty Reduced due to Suggested Re-Scheduled Delivery*/
msu072      number(15,3),            /*建议交期重排导至供给增加数             */
                                     /*Supply Qty Increased due to Suggested Re-Scheduled Delivery*/
msu08       number(15,3),            /*预计结存                               */
                                     /*Estimated Balance                      */
msu09       number(15,3),            /*建议采购(PLP)数量                      */
                                     /*Suggest.Purchase(PLP)/Suggest.W/O(PLP)Qt*/
msu11       date,                    /*行动日期                               */
                                     /*Action Date                            */
                                     /* P: P/R Date (Requirement Date-Var. PR Lead Days)*/
                                     /* M: OPEN Date (Requirement Date-Manufacture Days)*/
msu12       varchar2(1),             /*确认码                                 */
msuacti     varchar2(1),             /*资料有效否                             */
msuuser     varchar2(10),            /*资料所有者                             */
msugrup     varchar2(10),            /*资料所有群                             */
msumodu     varchar2(10),            /*资料更改者                             */
msudate     date,                    /*最近更改日                             */
msuoriu     varchar2(10),            /*资料建立者                             */
msuorig     varchar2(10)             /*资料建立部门                           */
);

create        index msu_02 on msu_file (msu00);
alter table msu_file add  constraint msu_pk primary key  (msu01,msu02,msu03,msu000) enable validate;
grant select on msu_file to tiptopgp;
grant update on msu_file to tiptopgp;
grant delete on msu_file to tiptopgp;
grant insert on msu_file to tiptopgp;
grant index on msu_file to public;
grant select on msu_file to ods;
