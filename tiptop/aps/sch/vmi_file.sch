/*
================================================================================
檔案代號:vmi_file
檔案名稱:aps物料维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vmi_file
(
vmi01       varchar2(40) DEFAULT ' ' NOT NULL, /*料号*/
vmi03       number(1),               /*批量开立规则                           */
vmi04       number(1),               /*耗尽料                                 */
vmi05       number(1) DEFAULT '0' NOT NULL, /*整数类型*/
vmi08       number(18,8),            /*最大采购量/生产量                      */
vmi11       number(1),               /*关键物料                               */
vmi15       number(1),               /*并批开单                               */
vmi16       number(9),               /*消耗后续工单之指定时间(天)             */
vmi17       number(9),               /*消耗后续采购令之指定时间(天            */
vmi19       number(1),               /*选配件                                 */
vmi21       number(1),               /*耗用方式                               */
vmi22       number(1),               /*多预测量是否作为需求                   */
vmi23       number(1),               /*合并尾批                               */
vmi24       number(18,8),            /*是否并于前批单据之判断比率             */
vmi25       number(1),               /*客供料                                 */
vmi28       varchar2(60),            /*品项群组代码                           */
vmi35       number(18,8),            /*关键料软性前置时间                     */
vmi36       varchar2(60),            /*供给法则编号                           */
vmi37       number(9),               /*并单周期                               */
vmi38       number(18,8),            /*替代比率                               */
vmi40       varchar2(60),            /*生产地                                 */
vmi44       varchar2(60),            /*生产线编号                             */
vmi45       varchar2(60),            /*生产线名称                             */
vmi47       number(1),               /*是否为断阶点                           */
vmi49       number(18,8),            /*理想因子                               */
vmi50       number(18,8),            /*宽放因子                               */
vmi51       varchar2(60),            /*连批条件1                              */
vmi52       varchar2(60),            /*连批条件2                              */
vmi53       varchar2(60),            /*连批条件3                              */
vmi54       varchar2(60),            /*连批条件4                              */
vmi55       varchar2(60),            /*连批条件5                              */
vmi56       number(1),               /*是否先backward                         */
vmi60       number(9),               /*移转批量大小                           */
vmi64       number(1),               /*是否依照供应商比例开立                 */
vmi57       varchar2(1),             /*是否批次作业                           */
vmi65       number(9)                /*供应商比例最低量限制                   */
);

alter table vmi_file add  constraint vmi_pk primary key  (vmi01) enable validate;
grant select on vmi_file to tiptopgp;
grant update on vmi_file to tiptopgp;
grant delete on vmi_file to tiptopgp;
grant insert on vmi_file to tiptopgp;
grant index on vmi_file to public;
grant select on vmi_file to ods;
