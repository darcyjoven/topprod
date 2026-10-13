/*
================================================================================
檔案代號:vai_file
檔案名稱:aps物料主檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vai_file
(
vai01       varchar2(40) DEFAULT ' ' NOT NULL, /*料号*/
vai02       number(15,3),            /*安全库存                               */
vai03       number(1),               /*批量开立规则                           */
vai04       number(1),               /*耗尽料                                 */
vai05       number(1),               /*整数类型                               */
vai06       number(1),               /*品项类型                               */
vai07       varchar2(4),             /*库存单位                               */
vai08       number(18,8),            /*最大采购量                             */
vai09       number(15,3),            /*最小采购量                             */
vai10       number(15,3),            /*采购倍量                               */
vai11       number(1),               /*关键物料                               */
vai12       number(1),               /*虚拟件                                 */
vai13       varchar2(120),           /*规格                                   */
vai14       number(15,3),            /*领料倍量                               */
vai15       number(1),               /*并批开单                               */
vai16       number(9),               /*消耗后续工单之指定时间(天)             */
vai17       number(9),               /*消耗后续采购令之指定时间(天            */
vai18       varchar2(120),           /*品名                                   */
vai19       number(1),               /*选配件                                 */
vai20       number(15,3),            /*固定前置时间                           */
vai21       number(1),               /*耗用方式                               */
vai22       number(1),               /*多预测量是否作为需求                   */
vai23       number(1),               /*合并尾批                               */
vai24       number(18,8),            /*是否并于前批单据之判断比率             */
vai25       number(1),               /*客供料                                 */
vai26       varchar2(10),            /*品项规划者                             */
vai27       varchar2(10),            /*品项采买者                             */
vai28       varchar2(60),            /*品项群组代码                           */
vai29       varchar2(4),             /*采购单位                               */
vai30       number(20,8),            /*转换率(库存/采购)                      */
vai31       varchar2(4),             /*生产单位                               */
vai32       number(20,8),            /*转换率(库存/生产)                      */
vai33       varchar2(4),             /*销售单位                               */
vai34       number(20,8),            /*转换率(库存/销售)                      */
vai35       number(18,8),            /*关键料软性前置时间                     */
vai36       varchar2(60),            /*供给法则编号                           */
vai37       number(9),               /*并单周期                               */
vai38       number(18,8),            /*替代比率                               */
vai39       varchar2(10),            /*生物管码                               */
vai40       varchar2(60),            /*生产地                                 */
vai41       varchar2(24),            /*制造商                                 */
vai42       varchar2(1),             /*abc等级                                */
vai43       varchar2(40),            /*制造商品号                             */
vai44       varchar2(60),            /*生产线编号                             */
vai45       varchar2(60),            /*生产线名称                             */
vai46       varchar2(10),            /*供应商名称                             */
vai47       number(1),               /*是否为断阶点                           */
vai48       number(20,6),            /*单价                                   */
vai49       number(18,8),            /*理想因子                               */
vai50       number(18,8),            /*宽放因子                               */
vai51       varchar2(60),            /*连批条件1                              */
vai52       varchar2(60),            /*连批条件2                              */
vai53       varchar2(60),            /*连批条件3                              */
vai54       varchar2(60),            /*连批条件4                              */
vai55       varchar2(60),            /*连批条件5                              */
vai56       number(1),               /*是否先backward                         */
vai57       number(1),               /*是否批次作业                           */
vai58       number(15,3),            /*整备时间                               */
vai59       number(15,3),            /*加工时间                               */
vai60       number(9),               /*移转批量大小                           */
vai61       number(9),               /*基准数量                               */
vai62       number(15,3),            /*批次加工上限                           */
vai63       varchar2(80),            /*工艺路线                               */
vai64       number(1),               /*是否依照供应商比例开立                 */
vai65       number(9),               /*供应商比例最低量限制                   */
vai66       varchar2(10),            /*主供应商编号                           */
vai67       number(9),               /*检验天数                               */
vai68       number(1),               /*是否为外包品项                         */
vai69       varchar2(60),            /*APS保留字段文字                        */
vai70       varchar2(60),            /*APS保留字段文字                        */
vai71       varchar2(60),            /*APS保留字段文字                        */
vai72       number(9),               /*APS保留字段数值                        */
vai73       number(18,8),            /*APS保留字段浮点数                      */
vai74       number(18,8),            /*APS保留字段浮点数                      */
vai75       date,                    /*APS保留字段日期                        */
vai76       date,                    /*APS保留字段日期                        */
vailegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vaiplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vai_file add  constraint vai_pk primary key  (vailegal,vaiplant,vai01) enable validate;
grant select on vai_file to tiptopgp;
grant update on vai_file to tiptopgp;
grant delete on vai_file to tiptopgp;
grant insert on vai_file to tiptopgp;
grant index on vai_file to public;
grant select on vai_file to ods;
