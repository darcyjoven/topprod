/*
================================================================================
檔案代號:vlz_file
檔案名稱:APS系统参数维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vlz_file
(
vlz01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
vlz02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
vlz03       date,                    /*规划开始时间                           */
vlz04       date,                    /*起始基准日                             */
vlz05       number(1),               /*非关建物料PO开立时机                   */
vlz06       date,                    /*erp转档时间                            */
vlz07       date,                    /*当前版本排程时间                       */
vlz08       date,                    /*原始版本排程时间                       */
vlz09       number(1),               /*是否将结果储存至 excel                 */
vlz10       number(9),               /*报表警示(太早)                         */
vlz11       number(9),               /*报表警示(太晚)                         */
vlz12       number(1),               /*采购令开立法则                         */
vlz13       number(1),               /*单据追溯记录锁定设置                   */
vlz14       number(1),               /*存货预配记录锁定设置                   */
vlz15       number(1),               /*关键物料设置                           */
vlz16       number(1),               /*开工时间依据                           */
vlz17       number(1),               /*mrp时间递推方式                        */
vlz18       number(1),               /*是否op代料                             */
vlz19       number(1),               /*是否以priority值为规划优先次           */
vlz20       number(1),               /*规划是否删除前次工单                   */
vlz21       number(1),               /*规划时是否删除前次采购单               */
vlz22       number(1),               /*是否计算安全库存                       */
vlz23       number(1),               /*是否允许多重配置                       */
vlz24       number(1),               /*是否载入取替代料资料                   */
vlz25       number(1),               /*是否强制调整单据                       */
vlz26       number(1),               /*采购单位设置                           */
vlz27       number(1),               /*是否详细检查物料资讯                   */
vlz28       number(1),               /*是否储存虚拟需求订单                   */
vlz29       number(1),               /*预测耗用类型                           */
vlz30       number(1),               /*是否发放预测订单多开的量               */
vlz31       number(1),               /*预测耗用汇整周期区间                   */
vlz32       number(9),               /*耗用周期数                             */
vlz33       number(9),               /*耗用周期结束日(月)                     */
vlz34       number(1),               /*耗用周期结束日(星期)                   */
vlz35       number(1),               /*是否合并尾批                           */
vlz36       number(18,8),            /*最大可合并比率                         */
vlz37       number(9),               /*并单周期时间                           */
vlz38       number(9),               /*mrp报表规划天数                        */
vlz39       number(9),               /*预测订单比真实订单晚多久仍             */
vlz40       number(1),               /*是否存货优先                           */
vlz41       number(1),               /*是否检查bom回圈结构                    */
vlz42       number(1),               /*始否依po状态决定单据供应顺             */
vlz43       varchar2(60),            /*旧料采购令排除                         */
vlz44       number(1),               /*替代比率对象类型                       */
vlz45       number(9),               /*限制天数(早-mo)                        */
vlz46       number(9),               /*限制天数(晚-mo)                        */
vlz47       number(9),               /*限制天数(早-po)                        */
vlz48       number(9),               /*限制天数(晚-po)                        */
vlz49       number(1),               /*是否启用配货引擎                       */
vlz50       number(1),               /*际耗用量计算方式                       */
vlz51       number(9),               /*前推月份                               */
vlz52       number(9),               /*后推月份                               */
vlz53       number(1),               /*是否找寻替代工艺路线                   */
vlz54       number(1),               /*是否找寻替代作业                       */
vlz55       number(1),               /*是否找寻替代机台                       */
vlz56       number(9),               /*每日起始时间                           */
vlz57       number(9),               /*连批时距                               */
vlz58       varchar2(60),            /*工单排序方式                           */
vlz59       varchar2(60),            /*订单排序方式                           */
vlz60       number(1),               /*资源的类型                             */
vlz61       number(18,8),            /*工时允差                               */
vlz62       varchar2(6),             /*虚拟作业编号                           */
vlz63       varchar2(60),            /*虚拟设备编号                           */
vlz64       varchar2(60),            /*全厂周行事历                           */
vlz65       varchar2(60),            /*全厂日行事历                           */
vlz66       varchar2(60),            /*aps整合模式                            */
vlz67       number(1),               /*mrp时距方式                            */
vlz68       varchar2(6),             /*无工艺工单虚拟工艺路线                 */
vlz69       varchar2(60),            /*无工艺工单虚拟加工顺序号               */
vlz70       varchar2(10),            /*限定版本                               */
vlz71       varchar2(60),            /*MRP模式                                */
vlz72       varchar2(10),            /*虚拟外包厂商                           */
vlz56b      varchar2(8),             /*每日开始时间(hh:mm:ss)                 */
vlz57b      varchar2(8),             /*连批时距(hh:mm:ss)                     */
vlz73       varchar2(60),            /*新开工单单别                           */
vlz74       varchar2(60),            /*新开采购令单别                         */
vlz75       number(1),               /*版本自动确认                           */
vlz76       number(1),               /*无法则工单是否继承法则 0:否            */
vlz77       number(1),               /*检验日计算方式                         */
vlz78       varchar2(60),            /*工单多余量自动开立需求订单             */
vlz79       number(1),               /*单据供给顺序法则                       */
vlz80       number(1),               /*订单最早可开工模式                     */
vlz81       number(9),               /*订单加工限制天数                       */
vlz82       number(1),               /*排程时是否要先BackWard                 */
vlz83       number(1),               /*系统讯息记录模式                       */
vlzlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vlzplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属工厂*/
vlz84       number(1) DEFAULT '1' NOT NULL /*安全庫存模式*/
);

alter table vlz_file add  constraint vlz_pk primary key  (vlz01,vlz02) enable validate;
grant select on vlz_file to tiptopgp;
grant update on vlz_file to tiptopgp;
grant delete on vlz_file to tiptopgp;
grant insert on vlz_file to tiptopgp;
grant index on vlz_file to public;
grant select on vlz_file to ods;
