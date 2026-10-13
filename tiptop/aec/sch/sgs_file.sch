/*
================================================================================
檔案代號:sgs_file
檔案名稱:产品工艺变更档
檔案目的:产品工艺变更单身档
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sgs_file
(
sgs01       varchar2(40) DEFAULT ' ' NOT NULL, /*产品料号*/
sgs02       varchar2(10) DEFAULT ' ' NOT NULL, /*工艺编号*/
sgs03       number(5) DEFAULT '0' NOT NULL, /*变更序号*/
sgs04       varchar2(1) DEFAULT ' ' NOT NULL, /*变更方式*/
sgs05       number(5) DEFAULT '0' NOT NULL, /*工艺序号*/
sgs06       varchar2(10),            /*原作业编号                             */
sgs07       varchar2(10),            /*原工作站                               */
sgs08       varchar2(10),            /*原机器编号                             */
sgs09       number(15,3),            /*原单位人力                             */
sgs10       number(9,4),             /*原完工比率                             */
sgs11       number(8,4),             /*原标准人工工时                         */
sgs12       number(8,4),             /*原固定人工工时                         */
sgs13       number(8,4),             /*原标准机器工时                         */
sgs14       number(8,4),             /*原固定机器工时                         */
sgs15       varchar2(1),             /*原托外否                               */
sgs16       varchar2(1),             /*原pqc否                                */
sgs17       varchar2(1),             /*原check in否                           */
sgs18       varchar2(10),            /*原check in hold留置码                  */
sgs19       varchar2(10),            /*原check out hold留置码                 */
sgs20       varchar2(4),             /*No use                                 */
sgs21       varchar2(4),             /*原转出单位                             */
sgs22       number(20,8),            /*原转换率                               */
sgs23       varchar2(10),            /*新作业编号                             */
sgs24       varchar2(10),            /*新工作站                               */
sgs25       varchar2(10),            /*新机器编号                             */
sgs26       number(15,3),            /*新单位人力                             */
sgs27       number(9,4),             /*新完工比率                             */
sgs28       number(8,4),             /*新标准人工工时                         */
sgs29       number(8,4),             /*新固定人工工时                         */
sgs30       number(8,4),             /*新标准机器工时                         */
sgs31       number(8,4),             /*新固定机器工时                         */
sgs32       varchar2(1),             /*新委外否                               */
sgs33       varchar2(1),             /*新pqc否                                */
sgs34       varchar2(1),             /*新check in否                           */
sgs35       varchar2(10),            /*新check in hold留置码                  */
sgs36       varchar2(10),            /*新check out hold留置码                 */
sgs37       varchar2(4),             /*No use                                 */
sgs38       varchar2(4),             /*新转出单位                             */
sgs39       number(20,8),            /*新转换率                               */
sgsslk01    varchar2(1),             /*原裁片管理否                           */
sgsslk02    number(8,4),             /*原现实工时                             */
sgsslk03    number(20,6),            /*原标准工价                             */
sgsslk04    number(20,6),            /*原现实工价                             */
sgsslk05    varchar2(1),             /*新裁片管理否                           */
sgsslk06    number(8,4),             /*新现实工时                             */
sgsslk07    number(20,6),            /*新标准工价                             */
sgsslk08    number(20,6),            /*新现实工价                             */
sgs012      varchar2(10) DEFAULT ' ' NOT NULL, /*工艺段号*/
sgs052a     number(15,3),            /*变更后固定损耗量                       */
sgs052b     number(15,3),            /*变更前固定损耗量                       */
sgs053a     number(15,3),            /*变更后损耗批量                         */
sgs053b     number(15,3),            /*变更前损耗批量                         */
sgs014a     number(9,4),             /*生产说明                               */
sgs014b     number(9,4),             /*生产说明                               */
sgs051a     number(16,8),
sgs051b     number(16,8),
ta_sgs01a   varchar2(1500),          /*生产说明                               */
ta_sgs01b   varchar2(1500),          /*生产说明                               */
ta_sgs02a   varchar2(1500),          /*使用工具                               */
ta_sgs02b   varchar2(1500),          /*使用工具                               */
ta_sgs03a   varchar2(40),            /*物料代号                               */
ta_sgs03b   varchar2(40),            /*物料代号                               */
ta_sgs04a   varchar2(1500),          /*使用程序                               */
ta_sgs04b   varchar2(1500)           /*使用程序                               */
);

alter table sgs_file add  constraint sgs_pk primary key  (sgs01,sgs02,sgs03,sgs05,sgs012) enable validate;
grant select on sgs_file to tiptopgp;
grant update on sgs_file to tiptopgp;
grant delete on sgs_file to tiptopgp;
grant insert on sgs_file to tiptopgp;
grant index on sgs_file to public;
grant select on sgs_file to ods;
