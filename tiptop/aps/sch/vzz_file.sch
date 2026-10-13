/*
================================================================================
檔案代號:vzz_file
檔案名稱:aps系统参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vzz_file
(
vzz00       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
vzz01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
vzz02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
vzz03       date,                    /*规划开始时间                           */
vzz04       date,                    /*起始基准日                             */
vzz05       number(1),               /*非关键物料po开立时机                   */
vzz06       date,                    /*erp转档时间                            */
vzz07       date,                    /*当前版本排程时间                       */
vzz08       date,                    /*原始版本排程时间                       */
vzz09       number(1),               /*是否将结果储存至 excel                 */
vzz10       number(9),               /*报表警示(太早)                         */
vzz11       number(9),               /*报表警示(太晚)                         */
vzz12       number(1),               /*采购令开立法则                         */
vzz13       number(1),               /*单据追溯记录锁定                       */
vzz14       number(1),               /*存货预配记录锁定                       */
vzz15       number(1),               /*关键物料设置                           */
vzz16       number(1),               /*开工时间依据                           */
vzz17       number(1),               /*mrp时间递推方式                        */
vzz18       number(1),               /*是否op代料                             */
vzz19       number(1),               /*是否以priority值为规划优先次           */
vzz20       number(1),               /*规划是否删除前次工单                   */
vzz21       number(1),               /*规划是否删除前次采购单                 */
vzz22       number(1),               /*是否计算安全库存                       */
vzz23       number(1),               /*是否允许多重配置                       */
vzz24       number(1),               /*是否载入取替代料资料                   */
vzz25       number(1),               /*是否强制调整单据                       */
vzz26       number(1),               /*采购单位设置                           */
vzz27       number(1),               /*是否详细检查物料资讯                   */
vzz28       number(1),               /*是否储存虚拟需求订单                   */
vzz29       number(1),               /*预测耗用类型                           */
vzz30       number(1),               /*是否发放预测订单多开的量               */
vzz31       number(1),               /*预测耗用汇整周期区间                   */
vzz32       number(9),               /*耗用周期数                             */
vzz33       number(9),               /*耗用周期结束日(月)                     */
vzz34       number(1),               /*耗用周期结束日(星期)                   */
vzz35       number(1),               /*是否合并尾批                           */
vzz36       number(18,8),            /*最大可合并比率                         */
vzz37       number(9),               /*并单周期时间                           */
vzz38       number(9),               /*mrp报表规划天数                        */
vzz39       number(9),               /*预测订单比真实订单晚多久仍             */
vzz40       number(1),               /*是否存货优先                           */
vzz41       number(1),               /*是否检查bom回圈结构                    */
vzz42       number(1),               /*是否依po状态决定单据供应顺             */
vzz43       varchar2(60),            /*旧料采购令排除                         */
vzz44       number(1),               /*替代比率对象                           */
vzz45       number(9),               /*限制天数(早-mo)                        */
vzz46       number(9),               /*限制天数(晚-mo)                        */
vzz47       number(9),               /*限制天数(早-po)                        */
vzz48       number(9),               /*限制天数(晚-po)                        */
vzz49       number(1),               /*是否启用配货引擎                       */
vzz50       number(1),               /*际耗用量计算方式                       */
vzz51       number(9),               /*前推月份                               */
vzz52       number(9),               /*后推月份                               */
vzz53       number(1),               /*是否找寻替代工艺路线                   */
vzz54       number(1),               /*是否找寻替代作业                       */
vzz55       number(1),               /*是否找寻替代机台                       */
vzz56       number(9),               /*每日起始时间                           */
vzz57       number(9),               /*连批时距                               */
vzz58       varchar2(60),            /*工单排序方式                           */
vzz59       varchar2(60),            /*订单排序方式                           */
vzz60       number(1),               /*资源的类型                             */
vzz61       number(18,8),            /*工时允差                               */
vzz62       varchar2(6),             /*虚拟作业编号                           */
vzz63       varchar2(60),            /*虚拟设备编号                           */
vzz64       varchar2(60),            /*全厂周行事历                           */
vzz65       varchar2(60),            /*全厂日行事历                           */
vzz66       varchar2(60),            /*aps整合模式                            */
vzz67       number(1),               /*mrp时距方式                            */
vzz68       varchar2(6),             /*无工艺工单虚拟工艺路线                 */
vzz69       varchar2(60),            /*无工艺工单虚拟加工顺序号               */
vzz70       varchar2(10),            /*限定版本                               */
vzz71       varchar2(60),            /*MRP模式                                */
vzz72       varchar2(10),            /*虚拟外包厂商                           */
vzz73       varchar2(60),            /*新开工单单别                           */
vzz74       varchar2(60),            /*新开采购令单别                         */
vzz75       number(1),               /*版本自动确认                           */
vzz76       number(1),               /*无法则工单是否继承法则 0:否            */
vzz77       number(1),               /*检验日计算方式                         */
vzz78       varchar2(60),            /*工单多余量自动开立需求订单             */
vzz79       varchar2(60),            /*单据供给顺序法则                       */
vzz80       number(1),               /*订单最早可开工模式                     */
vzz81       number(9),               /*订单加工限制天数                       */
vzz82       number(1),               /*排程时是否要先BackWard                 */
vzz83       number(1),               /*系统讯息记录模式                       */
vzz84       varchar2(60),            /*APS保留字段文字                        */
vzz85       varchar2(60),            /*APS保留字段文字                        */
vzz86       varchar2(60),            /*APS保留字段文字                        */
vzz87       number(9),               /*APS保留字段数值                        */
vzz88       number(18,8),            /*APS保留字段浮点数                      */
vzz89       number(18,8),            /*APS保留字段浮点数                      */
vzz90       date,                    /*APS保留字段日期                        */
vzz91       date,                    /*APS保留字段日期                        */
vzzlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vzzplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属工厂*/
vzz92       number(1),               /*使用平行工艺否                         */
vzz93       number(1),               /*使用工艺BOM否                          */
vzz94       number(1) DEFAULT '1' NOT NULL /*安全库存模式*/
);

alter table vzz_file add  constraint vzz_pk primary key  (vzzlegal,vzzplant,vzz00,vzz01,vzz02) enable validate;
grant select on vzz_file to tiptopgp;
grant update on vzz_file to tiptopgp;
grant delete on vzz_file to tiptopgp;
grant insert on vzz_file to tiptopgp;
grant index on vzz_file to public;
grant select on vzz_file to ods;
