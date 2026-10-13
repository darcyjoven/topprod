/*
================================================================================
檔案代號:mps_file
檔案名稱:MPS 供需汇总档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table mps_file
(
mps_v       varchar2(10) NOT NULL,   /*模拟版本                               */
                                     /*模擬版本                               */
mps00       number(10),              /*序号　　　　　　　　　                 */
                                     /*序號 (於 MPS 完畢, 自動賦與)           */
mps01       varchar2(40) NOT NULL,   /*料号                                   */
                                     /*料號                                   */
mps02       varchar2(10),            /*No Use                                 */
mps03       date NOT NULL,           /*供需日期                               */
                                     /*供需日期 (依時距推算)                  */
mps039      number(15,3),            /*需求:预测量                            */
                                     /*需求:預測量 ('39')                     */
mps041      number(15,3),            /*需求:受订量                            */
                                     /*Requirement:Qty Ordered (Safety Inventory/Independent Requirement/Ordered)*/
                                     /*            ('40'     '41'     '42'    */
mps043      number(15,3),            /*需求:计划备料量                        */
                                     /*Req.:Planned Allotment Qt(MPS Down Level Explode '43' + PLM W/O Down Level Explode'45')*/
mps044      number(15,3),            /*需求:工单备料量                        */
mps046      number(15,3),            /*需求:受订量                            */
                                     /*需求:受訂量(相依需求)                  */
mps051      number(15,3),            /*供给:库存量                            */
                                     /*供給:庫存量                            */
mps052      number(15,3),            /*供给:在验量                            */
                                     /*供給:在驗量                            */
mps053      number(15,3),            /*供给:库存量                            */
                                     /*供給:庫存量 (替代料)                   */
mps061      number(15,3),            /*供给:请购量                            */
                                     /*供給:請購量                            */
mps062      number(15,3),            /*供给:在采量                            */
                                     /*供給:在採量 (採購單未發出)             */
mps063      number(15,3),            /*供给:在外量                            */
                                     /*供給:在外量 (採購單已發出)             */
mps064      number(15,3),            /*供给:在制量                            */
mps065      number(15,3),            /*供给:计划产量                          */
                                     /*供給:計劃產 (MPS 計劃預計生產)         */
mps06_fz    number(15,3),            /*已冻结交期的供给量(PR/PO/WO)           */
                                     /*Supply Qty of Frozen Delivery Schedule(PR/PO/WO)(PR/PO/WO) Frozen Delivery Cann't Reschedule,So Supply Qty of Schedule =*/
mps071      number(15,3),            /*建议交期重排导至供给减少数             */
mps072      number(15,3),            /*建议交期重排导至供给增加数             */
mps08       number(15,3),            /*预计结存                               */
                                     /*預計結存                               */
mps09       number(15,3),            /*建议采购(PLP)建议工单(PLM)数量         */
                                     /*建議採購(PLP)/建議工單(PLM)數量        */
                                     /*主生產排程量                           */
mps10       varchar2(1),             /*是否已转正式MPS计划                    */
                                     /*是否已轉正式MPS計劃(Y/N)               */
mps11       date,                    /*行动日期                               */
                                     /*行動日期                               */
                                     /* P: 請購日期 (需求日-採購前置日數)     */
                                     /* M: OPEN日期 (需求日-製造前置日數)     */
mps12       number(12,3),            /*No Use                                 */
mpsplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
mpslegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index mps_02 on mps_file (mps00);
alter table mps_file add  constraint mps_pk primary key  (mps01,mps03,mps_v) enable validate;
grant select on mps_file to tiptopgp;
grant update on mps_file to tiptopgp;
grant delete on mps_file to tiptopgp;
grant insert on mps_file to tiptopgp;
grant index on mps_file to public;
grant select on mps_file to ods;
