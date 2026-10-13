/*
================================================================================
檔案代號:vob_file
檔案名稱:aps(製令結果)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vob_file
(
vob00       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
vob01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
vob02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
vob03       varchar2(60) DEFAULT ' ' NOT NULL, /*采购单编号*/
vob04       date,                    /*erp预计抵达日期                        */
vob05       number(1),               /*是否已开的采购令                       */
vob06       varchar2(60),            /*库房位置                               */
vob07       varchar2(40),            /*料号                                   */
vob08       number(15,3),            /*预计采购数量                           */
vob09       date,                    /*erp预计开立日期                        */
vob10       varchar2(10),            /*供应商编号                             */
vob11       varchar2(4),             /*单位                                   */
vob12       varchar2(60),            /*计划批号                               */
vob13       varchar2(20),            /*erp中对应的采购单单号                  */
vob14       date,                    /*系统规划抵达日期                       */
vob15       date,                    /*系统规划开立日期                       */
vob16       number(1),               /*atp需求订单                            */
vob17       varchar2(60),            /*此采购令首次供给的需求订单             */
vob18       varchar2(60),            /*此采购单首次供给的工单编号             */
vob19       varchar2(60),            /*主要来源需求订单                       */
vob20       number(15,3),            /*已入库数量                             */
vob21       number(15,3),            /*可用量                                 */
vob22       number(1),               /*保留                                   */
vob23       varchar2(10),            /*拥有者                                 */
vob24       number(1),               /*状态                                   */
vob25       varchar2(4),             /*APS规划时单位                          */
vob26       number(20,8),            /*转换比率                               */
vob27       number(1),               /*是否锁定                               */
vob28       number(15,3),            /*待验量                                 */
vob29       number(15,3),            /*待入库量                               */
vob30       number(15,3),            /*验退量                                 */
vob31       number(15,3),            /*主料替他量                             */
vob32       number(15,3),            /*实际耗用量                             */
vob33       number(15,3),            /*建议开立量                             */
vob34       date,                    /*backward交期                           */
vob35       varchar2(10),            /*新拥有者                               */
vob36       varchar2(1),             /*变更否                                 */
vob37       number(15,3),            /*确认请购数量                           */
vob38       date,                    /*确认到厂日                             */
vob39       varchar2(20),            /*产生的请购单号                         */
vob40       date,                    /*APS建议到库日                          */
vob41       number(15,3),            /*MOD订单耗用量                          */
vob42       varchar2(60),            /*供给法则                               */
vob43       varchar2(60),            /*APS保留字段文字                        */
vob44       varchar2(60),            /*APS保留字段文字                        */
vob45       varchar2(60),            /*APS保留字段文字                        */
vob46       number(9),               /*APS保留字段数值                        */
vob47       number(18,8),            /*APS保留字段浮点数                      */
vob48       number(18,8),            /*APS保留字段浮点数                      */
vob49       date,                    /*APS保留字段日期                        */
vob50       date,                    /*APS保留字段日期                        */
voblegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vobplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vob_file add  constraint vob_pk primary key  (vob00,vob01,vob02,vob03) enable validate;
grant select on vob_file to tiptopgp;
grant update on vob_file to tiptopgp;
grant delete on vob_file to tiptopgp;
grant insert on vob_file to tiptopgp;
grant index on vob_file to public;
grant select on vob_file to ods;
