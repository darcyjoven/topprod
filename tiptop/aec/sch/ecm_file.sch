/*
================================================================================
檔案代號:ecm_file
檔案名稱:工艺追踪档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ecm_file
(
ecm01       varchar2(20) NOT NULL,   /*工单编号                               */
ecm02       number(5),               /*工单类型                               */
ecm03_par   varchar2(40),            /*料件编号                               */
ecm03       number(5) NOT NULL,      /*工艺序号                               */
ecm04       varchar2(6),             /*作业编号                               */
ecm05       varchar2(10),            /*机器编号                               */
ecm06       varchar2(10),            /*工作站编号                             */
ecm07       number(15,3),            /*最早起始前置时间调整                   */
ecm08       number(15,3),            /*最迟起始前置时间调整                   */
ecm09       number(15,3),            /*最早完工前置时间调整                   */
ecm10       number(15,3),            /*最迟完工前置时间调整                   */
ecm11       varchar2(10),            /*工艺编号                               */
ecm12       number(9,4),             /*固定损耗量                             */
                                     /*损耗率(%)                              */
                                     /*表示在本生产程序/作业将会发生的标准    */
                                     /*损耗率, 在对材料而言, 系统将依产品如   */
                                     /*结构中的损耗率, 为一百分比             */
                                     /*yield                                  */
                                     /*存放-percent 值                        */
ecm121      varchar2(1),             /*盘点作业                               */
ecm13       number(15,2),            /*标准人工设置时间                       */
ecm14       number(15,2),            /*标准人工生产时间                       */
ecm15       number(15,2),            /*标准机器设置时间                       */
ecm16       number(15,2),            /*标准机器生产时间                       */
ecm17       number(15,3),            /*标准委外加工时间                       */
ecm18       number(15,3),            /*标准等待时间                           */
ecm19       number(15,3),            /*标准等待时间                           */
ecm20       number(15,3),            /*实际人工生产时间                       */
ecm21       number(15,3),            /*实际人工生产时间                       */
ecm22       number(15,3),            /*实际机器设置时间                       */
ecm23       number(15,3),            /*实际机器生产时间                       */
ecm24       number(15,3),            /*实际委外加工时间                       */
ecm25       varchar2(5),             /*开工时间                               */
ecm26       varchar2(5),             /*完工时间                               */
ecm27       number(8,2),             /*No Use                                 */
                                     /*no use       no.4621 02/03/14          */
ecm28       number(8,2),             /*No Use                                 */
                                     /*no use       no.4621 02/03/14          */
ecm291      number(15,3),            /*Check in Qty                           */
ecm292      number(15,3),            /*盘点量                                 */
ecm301      number(15,3),            /*良品转入量       (+)                   */
ecm302      number(15,3),            /*返工转入量       (+)                   */
ecm303      number(15,3),            /*工单转入量       (+)                   */
ecm311      number(15,3),            /*良品转出量       (-)                   */
ecm312      number(15,3),            /*返工转出         (-)                   */
ecm313      number(15,3),            /*当站报废量       (-)                   */
ecm314      number(15,3),            /*当站下线量(入库) (-)                   */
ecm315      number(15,3),            /*Bonus Qty        (-)                   */
ecm316      number(15,3),            /*工单转出量       (-)                   */
ecm321      number(15,3),            /*委外加工量                             */
ecm322      number(15,3),            /*委外完工量                             */
ecm34       number(15,3),            /*变动损耗率                             */
ecm35       number(9,4),             /*C/R 比率                               */
ecm36       number(9,4),             /*报废平均人工分摊比率                   */
ecm37       number(15,3),            /*排程人工设置时间                       */
ecm38       number(15,3),            /*排程人工生产时间                       */
ecm39       number(15,3),            /*排程委外加工时间                       */
ecm40       number(5),               /*人工数目                               */
ecm41       number(5),               /*机器数目                               */
ecm42       number(9,4),             /*作业重叠程度                           */
ecm43       varchar2(1),             /*成本计算基准                           */
ecm45       varchar2(80),            /*作业名称                               */
ecm49       number(15,2),            /*单位人力                               */
ecm50       date,                    /*工艺开工日                             */
ecm51       date,                    /*工艺完工日                             */
ecm52       varchar2(1),             /*委外否                                 */
ecm53       varchar2(1),             /*PQC 否                                 */
ecm54       varchar2(1),             /*Check in 否                            */
ecm55       varchar2(10),            /*Check in 留置码                        */
ecm56       varchar2(10),            /*Check out 留置码                       */
ecm57       varchar2(4),             /*no use                                 */
ecm58       varchar2(4),             /*转出单位                               */
ecm59       number(20,8),            /*no use                                 */
ecmacti     varchar2(1),             /*资料有效码                             */
ecmuser     varchar2(10),            /*资料所有者                             */
ecmgrup     varchar2(10),            /*资料所有群                             */
ecmmodu     varchar2(10),            /*资料更改者                             */
ecmdate     date,                    /*最近更改日                             */
ecm60       number(5),               /*单元变更序号                           */
ecmslk01    varchar2(1),             /*裁片管理否                             */
ecmslk02    number(15,3),            /*现实工时                               */
ecmslk03    number(20,6),            /*标准工价                               */
ecmslk04    number(20,6),            /*现实工价                               */
ecm61       varchar2(1),             /*锁定设备否                             */
ecmplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ecmlegal    varchar2(10) NOT NULL,   /*所属法人                               */
ecmorig     varchar2(10),            /*资料建立部门                           */
ecmoriu     varchar2(10),            /*资料建立者                             */
ecm011      varchar2(10),            /*上工艺段号                             */
ecm012      varchar2(10) DEFAULT ' ' NOT NULL, /*工艺段号*/
ecm62       number(16,8),            /*组成用量                               */
ecm63       number(16,8),            /*底数                                   */
ecm64       number(9,4),             /*损耗批量                               */
ecm65       number(15,3),            /*标准产出量                             */
ecm66       varchar2(1) DEFAULT ' ' NOT NULL, /*报工点否*/
ecm67       varchar2(10),            /*委外厂商                               */
ecm014      varchar2(80),            /*工艺段说明                             */
ecm015      varchar2(10),            /*下工艺段号                             */
ta_ecm01    varchar2(1500),          /*生产说明                               */
ta_ecm02    varchar2(1500),          /*使用工具                               */
ta_ecm03    varchar2(1500)           /*使用程序                               */
);

alter table ecm_file add  constraint ecm_pk primary key  (ecm01,ecm03,ecm012) enable validate;
grant select on ecm_file to tiptopgp;
grant update on ecm_file to tiptopgp;
grant delete on ecm_file to tiptopgp;
grant insert on ecm_file to tiptopgp;
grant index on ecm_file to public;
grant select on ecm_file to ods;
