/*
================================================================================
檔案代號:vlb_file
檔案名稱:aps資料產生記錄檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vlb_file
(
vlb01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
vlb02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
vlb03       varchar2(10) DEFAULT ' ' NOT NULL, /*生成人员*/
vlb04       date DEFAULT sysdate NOT NULL, /*运行日期*/
vlb05       varchar2(5) DEFAULT ' ' NOT NULL, /*起始时间*/
vlb06       varchar2(5),             /*结束时间                               */
vlb07       date,                    /*资料日期(起始)                         */
vlb08       date,                    /*资料日期(截止)                         */
vlb09       varchar2(1),             /*多厂区设置                             */
vlb10       varchar2(1),             /*系统参数档                             */
vlb11       varchar2(1),             /*工作模式                               */
vlb12       varchar2(1),             /*日行事历                               */
vlb13       varchar2(1),             /*周行事历                               */
vlb14       varchar2(1),             /*外包商资料                             */
vlb15       varchar2(1),             /*工作站                                 */
vlb16       varchar2(1),             /*资源                                   */
vlb17       varchar2(1),             /*资源群组                               */
vlb18       varchar2(1),             /*仓库主档                               */
vlb19       varchar2(1),             /*库位                                   */
vlb20       varchar2(1),             /*供给法则                               */
vlb21       varchar2(1),             /*物料主档                               */
vlb22       varchar2(1),             /*实体库存                               */
vlb23       varchar2(1),             /*料件供应商                             */
vlb24       varchar2(1),             /*品项分配法则                           */
vlb25       varchar2(1),             /*品项工艺路线                           */
vlb26       varchar2(1),             /*工艺路线工艺                           */
vlb27       varchar2(1),             /*物料清单/料表                          */
vlb28       varchar2(1),             /*投料点                                 */
vlb29       varchar2(1),             /*单品取替代                             */
vlb30       varchar2(1),             /*万用取替代                             */
vlb31       varchar2(1),             /*顾客                                   */
vlb32       varchar2(1),             /*预测群组冲销                           */
vlb33       varchar2(1),             /*需求订单                               */
vlb34       varchar2(1),             /*需求订单选配                           */
vlb35       varchar2(1),             /*制令/工单                              */
vlb36       varchar2(1),             /*工单领料状况                           */
vlb37       varchar2(1),             /*现场报工                               */
vlb38       varchar2(1),             /*采购令(请购单)                         */
vlb39       varchar2(1),             /*采购令(采购单)                         */
vlb40       varchar2(1),             /*存货预配纪录(工单/订单)                */
vlb41       varchar2(1),             /*单据追溯                               */
vlb42       varchar2(1),             /*加班资讯                               */
vlb43       varchar2(1),             /*锁定工艺时间                           */
vlb44       varchar2(1),             /*锁定使用设备                           */
vlb45       varchar2(1),             /*工单外包                               */
vlb46       varchar2(1),             /*工艺外包                               */
vlb47       varchar2(1),             /*工模具                                 */
vlbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
vlblegal    varchar2(10) NOT NULL,   /*所属法人                               */
vlb00       varchar2(1) DEFAULT '2' NOT NULL, /*类型*/
vlb48       date,                    /*规划开始日期                           */
vlb49       varchar2(8),             /*规划开始时间                           */
vlb50       date                     /*基本资料最后异动日                     */
);

alter table vlb_file add  constraint vlb_pk primary key  (vlb00,vlb01,vlb02,vlb03) enable validate;
grant select on vlb_file to tiptopgp;
grant update on vlb_file to tiptopgp;
grant delete on vlb_file to tiptopgp;
grant insert on vlb_file to tiptopgp;
grant index on vlb_file to public;
grant select on vlb_file to ods;
