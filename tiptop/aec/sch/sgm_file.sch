/*
================================================================================
檔案代號:sgm_file
檔案名稱:Run Card 工艺追踪档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sgm_file
(
sgm01       varchar2(23) DEFAULT ' ' NOT NULL, /*Run Card*/
sgm02       varchar2(20),            /*工单单号                               */
sgm03_par   varchar2(40),            /*料件编号                               */
sgm03       number(5) NOT NULL,      /*工艺序号                               */
sgm04       varchar2(6),             /*作业编号                               */
sgm05       varchar2(10),            /*机器编号                               */
sgm06       varchar2(10),            /*工作中心编号                           */
sgm07       number(15,3),            /*最早起始前置时间调整                   */
sgm08       number(15,3),            /*最迟起始前置时间调整                   */
sgm09       number(15,3),            /*最早完工前置时间调整                   */
sgm10       number(15,3),            /*最迟完工前置时间调整                   */
sgm11       varchar2(10),            /*工艺编号                               */
sgm12       number(9,4),             /*损耗率                                 */
sgm121      varchar2(1),             /*盘点作业                               */
sgm13       number(15,2),            /*标准人工设置时间                       */
sgm14       number(15,2),            /*标准人工生产时间                       */
sgm15       number(15,2),            /*标准机器设置时间                       */
sgm16       number(15,2),            /*标准机器生产时间                       */
sgm17       number(15,3),            /*标准委外加工时间                       */
sgm18       number(15,3),            /*标准等待时间                           */
sgm19       number(15,3),            /*标准等待时间                           */
sgm20       number(15,3),            /*实际人工生产时间                       */
sgm21       number(15,3),            /*实际人工生产时间                       */
sgm22       number(15,3),            /*实际机器设置时间                       */
sgm23       number(15,3),            /*实际机器生产时间                       */
sgm24       number(15,3),            /*实际委外加工时间                       */
sgm25       number(15,3),            /*赚得标准人工设置时间                   */
sgm26       number(15,3),            /*赚得标准人工生产时间                   */
sgm27       number(15,3),            /*赚得标准机器设置时间                   */
sgm28       number(15,3),            /*赚得标准机器生产时间                   */
sgm291      number(15,3),            /*Check in Qty                           */
sgm292      number(15,3),            /*盘点量                                 */
sgm301      number(15,3),            /*良品转入量       (+)                   */
sgm302      number(15,3),            /*返工转入量       (+)                   */
sgm303      number(15,3),            /*分割转入量       (+)                   */
sgm304      number(15,3),            /*合并转入量       (+)                   */
sgm311      number(15,3),            /*良品转出量       (-)                   */
sgm312      number(15,3),            /*返工转出         (-)                   */
sgm313      number(15,3),            /*当站报废量       (-)                   */
sgm314      number(15,3),            /*当站下线量(入库) (-)                   */
sgm315      number(15,3),            /*Bonus Qty        (-)                   */
sgm316      number(15,3),            /*分割转出量       (-)                   */
sgm317      number(15,3),            /*合并转出量       (-)                   */
sgm321      number(15,3),            /*委外加工量                             */
sgm322      number(15,3),            /*委外完工量                             */
sgm34       number(9,4),             /*实际损耗率                             */
sgm35       number(9,4),             /*C/R 比率                               */
sgm36       number(9,4),             /*报废平均人工分摊比率                   */
sgm37       number(15,3),            /*排程人工设置时间                       */
sgm38       number(15,3),            /*排程人工生产时间                       */
sgm39       number(15,3),            /*排程委外加工时间                       */
sgm40       number(5),               /*人工数目                               */
sgm41       number(5),               /*机器数目                               */
sgm42       number(9,4),             /*作业重叠程度                           */
sgm43       varchar2(1),             /*成本计算基准                           */
sgm45       varchar2(80),            /*作业名称                               */
sgm49       number(15,2),            /*单位人力                               */
sgm50       date,                    /*工艺开工日                             */
sgm51       date,                    /*工艺完工日                             */
sgm52       varchar2(1),             /*委外否                                 */
sgm53       varchar2(1),             /*PQC 否                                 */
sgm54       varchar2(1),             /*Check in 否                            */
sgm55       varchar2(10),            /*Check in 留置码                        */
sgm56       varchar2(10),            /*Check out 留置码                       */
sgm57       varchar2(4),             /*转入单位                               */
sgm58       varchar2(4),             /*转出单位                               */
sgm59       number(20,8),            /*单位转换率                             */
sgmacti     varchar2(1),             /*资料有效码                             */
sgmuser     varchar2(10),            /*资料所有者                             */
sgmgrup     varchar2(10),            /*资料所有群                             */
sgmmodu     varchar2(10),            /*资料更改者                             */
sgmdate     date,                    /*最近更改日                             */
sgmplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sgmlegal    varchar2(10) NOT NULL,   /*所属法人                               */
sgmorig     varchar2(10),            /*资料建立部门                           */
sgmoriu     varchar2(10),            /*资料建立者                             */
sgm012      varchar2(10) NOT NULL,   /*工艺段号                               */
sgm011      varchar2(10),            /*上工艺段号                             */
sgm62       number(16,8),            /*组成用量                               */
sgm63       number(16,8),            /*底数                                   */
sgm64       number(9,4),             /*损耗批量                               */
sgm65       number(15,3),            /*标准产出量                             */
sgm66       varchar2(1) DEFAULT ' ' NOT NULL, /*报工点否*/
sgm67       varchar2(10),            /*委外厂商                               */
sgm014      varchar2(80),            /*工艺段说明                             */
sgm015      varchar2(10),            /*下工艺段号                             */
ta_sgm01    varchar2(1500),          /*生产说明                               */
ta_sgm02    varchar2(1500),          /*使用工具                               */
ta_sgm03    varchar2(1500),          /*使用程序                               */
ta_sgm04    varchar2(40),
ta_sgm05    varchar2(40),
ta_sgm06    varchar2(1),             /*报工否                                 */
sgmud01     number(5)
);

alter table sgm_file add  constraint sgm_pk primary key  (sgm01,sgm03,sgm012) enable validate;
grant select on sgm_file to tiptopgp;
grant update on sgm_file to tiptopgp;
grant delete on sgm_file to tiptopgp;
grant insert on sgm_file to tiptopgp;
grant index on sgm_file to public;
grant select on sgm_file to ods;
