/*
================================================================================
檔案代號:mss_file
檔案名稱:MRP 供需汇总档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table mss_file
(
mss_v       varchar2(10) NOT NULL,   /*模拟版本                               */
                                     /*模擬版本                               */
mss00       number(10),              /*序号　　　　　　　　　                 */
                                     /*序號 (於 LRP 完畢, 自動賦與)           */
mss01       varchar2(40) NOT NULL,   /*料号                                   */
                                     /*料號                                   */
mss02       varchar2(10) NOT NULL,   /*限定厂商编号                           */
                                     /*限定廠商編號                           */
mss03       date NOT NULL,           /*供需日期                               */
                                     /*供需日期 (依時距推算)                  */
mss041      number(15,3),            /*需求:受订量                            */
                                     /*Requirement:Ordered Qty (Safety Inv/Indept.Req/Ordered)*/
                                     /*            ('40'     '41'     '42'    */
mss043      number(15,3),            /*需求:计划备料量                        */
                                     /*Req.:Planned Allotment Qt(MPS Down Level Explode '43' + PLM W/O Down Level Explode'45')*/
mss044      number(15,3),            /*需求:工单备料量                        */
                                     /*需求:工單備料量(實際工單下階料展出'44')*/
mss051      number(15,3),            /*供给:库存量                            */
                                     /*供給:庫存量                            */
mss052      number(15,3),            /*供给:在验量                            */
                                     /*供給:在驗量                            */
mss053      number(15,3),            /*供给:库存量                            */
                                     /*供給:庫存量 (替代料)                   */
mss061      number(15,3),            /*供给:请购量                            */
                                     /*供給:請購量                            */
mss062      number(15,3),            /*供给:在采量                            */
                                     /*供給:在採量 (採購單未發出)             */
mss063      number(15,3),            /*供给:在外量                            */
                                     /*供給:在外量 (採購單已發出)             */
mss064      number(15,3),            /*供给:在制量                            */
                                     /*供給:在製量 (確認工單預計完工)         */
mss065      number(15,3),            /*供给:计划产                            */
                                     /*供給:計劃產 (MPS 計劃預計生產)         */
mss06_fz    number(15,3),            /*已冻结交期的供给量(PR/PO/WO)           */
                                     /*Supply Qty of Frozen Delivery Schedule(PR/PO/WO)(PR/PO/WO) Frozen Delivery Cann't Reschedule,So Supply Qty of Schedule =*/
mss071      number(15,3),            /*建议交期重排导至供给减少数             */
                                     /*建議交期重排導致供給減少數量           */
mss072      number(15,3),            /*建议交期重排导至供给增加数             */
                                     /*建議交期重排導致供給增加數量           */
mss08       number(15,3),            /*预计结存                               */
                                     /*預計結存                               */
mss09       number(15,3),            /*建议采购(PLP)建议工单(PLM)数量         */
                                     /*建議採購(PLP)/建議工單(PLM)數量        */
mss10       varchar2(1),             /*已转请购/工单否                        */
                                     /*已轉請購/工單否(Y/N)                   */
mss11       date,                    /*行动日期                               */
                                     /*行動日期                               */
                                     /* P: 請購日期 (需求日-採購前置日數)     */
                                     /* M: OPEN日期 (需求日-製造前置日數)     */
mss12       varchar2(1),             /*No Use                                 */
mssplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
msslegal    varchar2(10) NOT NULL,   /*所属法人                               */
mss13       varchar2(1) DEFAULT ' ' NOT NULL
);

create        index mss_02 on mss_file (mss00);
alter table mss_file add  constraint mss_pk primary key  (mss01,mss02,mss03,mss_v) enable validate;
grant select on mss_file to tiptopgp;
grant update on mss_file to tiptopgp;
grant delete on mss_file to tiptopgp;
grant insert on mss_file to tiptopgp;
grant index on mss_file to public;
grant select on mss_file to ods;
