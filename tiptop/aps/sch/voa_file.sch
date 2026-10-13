/*
================================================================================
檔案代號:voa_file
檔案名稱:aps(採購令結果)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table voa_file
(
voa00       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
voa01       varchar2(10) DEFAULT ' ' NOT NULL, /*限定版本*/
voa02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
voa03       varchar2(60) DEFAULT ' ' NOT NULL, /*需求订单编号*/
voa04       varchar2(40),            /*料号                                   */
voa05       number(15,3),            /*订购数量                               */
voa06       date,                    /*交期                                   */
voa07       number(1),               /*可否耗用                               */
voa08       varchar2(10),            /*客户编号                               */
voa09       varchar2(10),            /*客户群组编号                           */
voa10       number(1),               /*是否纳入排程                           */
voa11       varchar2(1),             /*订单类型                               */
voa12       varchar2(40),            /*产品族料件编号                         */
voa13       number(9),               /*订单之优先顺序                         */
voa14       varchar2(60),            /*订单编号                               */
voa15       varchar2(60),            /*客户单号                               */
voa16       number(15,3),            /*已出货量                               */
voa17       number(15,3),            /*可完成数量                             */
voa18       number(15,3),            /*预测耗用量                             */
voa19       number(15,3),            /*短缺数量                               */
voa20       number(15,3),            /*实际短缺量                             */
voa21       number(15,3),            /*实际需生产数量                         */
voa22       date,                    /*预计开工日期                           */
voa23       date,                    /*预计完工日期                           */
voa24       number(1),               /*检查码                                 */
voa25       varchar2(60),            /*错误信息                               */
voa26       varchar2(60),            /*延迟来源                               */
voa27       varchar2(60),            /*短缺来源                               */
voa28       number(1),               /*选配件                                 */
voa29       varchar2(1),             /*产品族代码                             */
voa30       date,                    /*mp阶段规划的预计开工日                 */
voa31       date,                    /*mp阶段规划的预计完工日                 */
voa32       varchar2(4),             /*计量单位                               */
voa33       number(1),               /*是否有客供料缺料                       */
voa34       varchar2(10),            /*订单拥有者                             */
voa35       varchar2(10),            /*订单规划者                             */
voa36       varchar2(10),            /*订单采买者                             */
voa37       number(20,8),            /*转换率                                 */
voa38       date,                    /*订单开立日期                           */
voa39       varchar2(4),             /*APS规划时单位                          */
voa40       varchar2(1),             /*变更否                                 */
voa41       varchar2(60),            /*APS保留字段文字                        */
voa42       varchar2(60),            /*APS保留字段文字                        */
voa43       varchar2(60),            /*APS保留字段文字                        */
voa44       number(9),               /*APS保留字段数值                        */
voa45       number(18,8),            /*APS保留字段浮点数                      */
voa46       number(18,8),            /*APS保留字段浮点数                      */
voa47       date,                    /*APS保留字段日期                        */
voa48       date,                    /*APS保留字段日期                        */
voalegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
voaplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table voa_file add  constraint voa_pk primary key  (voa00,voa01,voa02,voa03) enable validate;
grant select on voa_file to tiptopgp;
grant update on voa_file to tiptopgp;
grant delete on voa_file to tiptopgp;
grant insert on voa_file to tiptopgp;
grant index on voa_file to public;
grant select on voa_file to ods;
