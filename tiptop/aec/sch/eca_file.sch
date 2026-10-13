/*
================================================================================
檔案代號:eca_file
檔案名稱:工作站基本资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table eca_file
(
eca01       varchar2(10) NOT NULL,   /*工作站编号                             */
                                     /*Workstation No.Work Site# , Maybe Manufacture Work Center/Workshop/Work Site*/
eca02       varchar2(80),            /*说明                                   */
eca03       varchar2(10),            /*工作站所属部门                         */
eca04       varchar2(1),             /*工作站类型                             */
eca05_war   varchar2(10),            /*仓库                                   */
eca05       varchar2(10),            /*存放位置                               */
eca06       varchar2(1),             /*产能类型                               */
eca07       varchar2(1),             /*班次次数                               */
eca08       number(8,4),             /*每天人工/机器产能小时                  */
eca09       number(15,3),            /*平均等待时间                           */
eca10       number(5),               /*机器资源数目                           */
eca11       number(5),               /*人工资源数目                           */
eca12       number(9,4),             /*工作站效率调整                         */
eca13       number(15,3),            /*每星期工作天数                         */
eca50       number(15,3),            /*每天机器总产能小时                     */
eca51       number(15,3),            /*每星期机器总产能小时                   */
eca52       number(15,3),            /*每天人工总产能小时                     */
eca53       number(15,3),            /*每星期人工总产能小时                   */
eca54       varchar2(10),            /*预拟工作区                             */
eca55       varchar2(4),             /*工作历编号                             */
eca60       number(15,3),            /*累计实际设置时间                       */
eca61       number(15,3),            /*累计实际人工生产时间                   */
eca62       number(15,3),            /*累计实际机器设置时间                   */
eca63       number(15,3),            /*累计实际机器生产时间                   */
eca14       varchar2(1),             /*成本计算基准                           */
eca15       varchar2(1),             /*制造费用分担基准                       */
eca16       number(13,5),            /*平均标准人工设置成本率                 */
eca17       varchar2(10),            /*标准人工设置成本项目                   */
eca18       number(13,5),            /*平均标准人工生产成本率                 */
eca19       varchar2(10),            /*标准人工生产成本项目                   */
eca20       number(13,5),            /*平均标准机器设置成本率                 */
eca21       varchar2(10),            /*标准机器设置成本项目                   */
eca201      number(13,5),            /*平均标准机器生产成本率                 */
eca211      varchar2(10),            /*标准机器生产成本项目                   */
eca22       number(9,4),             /*平均标准固定制造费用分摊率             */
eca23       varchar2(10),            /*标准固定制造费用成本项目               */
eca24       number(9,4),             /*平均标准变动制造费用分摊率             */
eca25       varchar2(10),            /*标准变动制造费用成本项目               */
eca26       number(13,5),            /*平均缺省人工设置成本率                 */
eca27       varchar2(10),            /*缺省人工设置成本项目                   */
eca28       number(13,5),            /*平均缺省人工生产成本率                 */
eca29       varchar2(10),            /*缺省人工生产成本项目                   */
eca30       number(13,5),            /*平均缺省机器设置成本率                 */
eca31       varchar2(10),            /*缺省机器设置成本项目                   */
eca301      number(13,5),            /*平均缺省机器生产成本率                 */
eca311      varchar2(10),            /*缺省机器生产成本项目                   */
eca32       number(9,4),             /*平均缺省固定制造费用分摊率             */
eca33       varchar2(10),            /*缺省固定制造费用成本项目               */
eca34       number(9,4),             /*平均缺省变动制造费用分摊率             */
eca35       varchar2(10),            /*缺省变动制造费用成本项目               */
eca36       number(20,6),            /*平均标准加工单位成本                   */
eca37       varchar2(10),            /*标准加工成本项目                       */
eca38       number(9,4),             /*平均标准加工固定制造费用分             */
eca39       varchar2(10),            /*标准加工固定制造费用成本项             */
eca40       number(9,4),             /*平均标准加工变动制造费用分             */
eca41       varchar2(10),            /*标准加工变动制造费用成本项             */
eca42       number(20,6),            /*平均缺省加工单位成本                   */
eca43       varchar2(10),            /*缺省加工成本项目                       */
eca44       number(9,4),             /*平均缺省加工固定制造费用分             */
eca45       varchar2(10),            /*缺省加工固定制造费用成本项             */
eca46       number(9,4),             /*平均缺省加工变动制造费用分             */
eca47       varchar2(10),            /*缺省加工变动制造费用成本项             */
ecaacti     varchar2(1),             /*资料有效码                             */
ecauser     varchar2(10),            /*资料所有者                             */
ecagrup     varchar2(10),            /*资料所有群                             */
ecamodu     varchar2(10),            /*资料更改者                             */
ecadate     date,                    /*最近更改日                             */
ecaoriu     varchar2(10),            /*资料建立者                             */
ecaorig     varchar2(10)             /*资料建立部门                           */
);

alter table eca_file add  constraint eca_pk primary key  (eca01) enable validate;
grant select on eca_file to tiptopgp;
grant update on eca_file to tiptopgp;
grant delete on eca_file to tiptopgp;
grant insert on eca_file to tiptopgp;
grant index on eca_file to public;
grant select on eca_file to ods;
