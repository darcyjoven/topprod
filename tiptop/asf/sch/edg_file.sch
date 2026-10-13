/*
================================================================================
檔案代號:edg_file
檔案名稱:PBI制程档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table edg_file
(
edg01       varchar2(20) DEFAULT ' ' NOT NULL, /*PBI单号*/
edg02       number(5) DEFAULT '0' NOT NULL, /*PBI项次*/
edg03       number(5) DEFAULT '0' NOT NULL, /*工艺序*/
edg031      varchar2(40),            /*料件编号                               */
edg04       varchar2(6),             /*作业编号                               */
edg05       varchar2(10),            /*机器编号                               */
edg06       varchar2(10),            /*工作站编号                             */
edg07       number(15,3) DEFAULT '0' NOT NULL, /*最早起始前置时间调整*/
edg08       number(15,3) DEFAULT '0' NOT NULL, /*最迟起始前置时间调整*/
edg09       number(15,3) DEFAULT '0' NOT NULL, /*最早完工前置时间调整*/
edg10       number(15,3) DEFAULT '0' NOT NULL, /*最迟完工前置时间调整*/
edg11       varchar2(10),            /*工艺编号                               */
edg12       number(9,4),             /*固定损耗量                             */
edg121      varchar2(1) DEFAULT ' ' NOT NULL, /*盘点作业*/
edg13       number(15,3) DEFAULT '0' NOT NULL, /*标准人工设置时间*/
edg14       number(15,3) DEFAULT '0' NOT NULL, /*标准人工生产时间*/
edg15       number(15,3) DEFAULT '0' NOT NULL, /*标准机器设置时间*/
edg16       number(15,3) DEFAULT '0' NOT NULL, /*标准机器生产时间*/
edg17       number(15,3) DEFAULT '0' NOT NULL, /*标准委外加工时间*/
edg18       number(15,3) DEFAULT '0' NOT NULL, /*标准等待时间*/
edg19       number(15,3) DEFAULT '0' NOT NULL, /*标准等待时间*/
edg20       number(15,3) DEFAULT '0' NOT NULL, /*实际人工生产时间*/
edg21       number(15,3) DEFAULT '0' NOT NULL, /*实际人工生产时间*/
edg22       number(15,3) DEFAULT '0' NOT NULL, /*实际机器设置时间*/
edg23       number(15,3) DEFAULT '0' NOT NULL, /*实际机器生产时间*/
edg24       number(15,3) DEFAULT '0' NOT NULL, /*实际委外加工时间*/
edg25       varchar2(5),             /*开工时间                               */
edg26       varchar2(5),             /*完工时间                               */
edg27       number(9,4),             /*No Use                                 */
edg28       number(9,4),             /*No Use                                 */
edg291      number(15,3) DEFAULT '0' NOT NULL, /*Check in Qty*/
edg292      number(15,3) DEFAULT '0' NOT NULL, /*盘点量*/
edg301      number(15,3) DEFAULT '0' NOT NULL, /*良品转入量       (+)*/
edg302      number(15,3) DEFAULT '0' NOT NULL, /*返工转入量       (+)*/
edg303      number(15,3) DEFAULT '0' NOT NULL, /*工单转入量       (+)*/
edg311      number(15,3) DEFAULT '0' NOT NULL, /*良品转出量       (-)*/
edg312      number(15,3) DEFAULT '0' NOT NULL, /*返工转出         (-)*/
edg313      number(15,3) DEFAULT '0' NOT NULL, /*当站报废量       (-)*/
edg314      number(15,3) DEFAULT '0' NOT NULL, /*当站下线量(入库) (-)*/
edg315      number(15,3) DEFAULT '0' NOT NULL, /*Bonus Qty        (-)*/
edg316      number(15,3) DEFAULT '0' NOT NULL, /*工单转出量       (-)*/
edg321      number(15,3) DEFAULT '0' NOT NULL, /*委外加工量*/
edg322      number(15,3) DEFAULT '0' NOT NULL, /*委外完工量*/
edg34       number(15,3) DEFAULT '0' NOT NULL, /*变动损耗率*/
edg35       number(9,4),             /*C/R 比率                               */
edg36       number(9,4),             /*报废平均人工分摊比率                   */
edg37       number(15,3) DEFAULT '0' NOT NULL, /*排程人工设置时间*/
edg38       number(15,3) DEFAULT '0' NOT NULL, /*排程人工生产时间*/
edg39       number(15,3) DEFAULT '0' NOT NULL, /*排程委外加工时间*/
edg40       number(15,3) DEFAULT '0' NOT NULL, /*人工数目*/
edg41       number(5),               /*机器数目                               */
edg42       number(9,4),             /*作业重叠程度                           */
edg43       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算基准*/
edg45       varchar2(80),            /*作业名称                               */
edg49       number(15,3) NOT NULL,   /*单位人力                               */
edg50       date,                    /*工艺开工日                             */
edg51       date,                    /*工艺完工日                             */
edg52       varchar2(1) DEFAULT ' ' NOT NULL, /*委外否*/
edg53       varchar2(1) DEFAULT ' ' NOT NULL, /*PQC 否*/
edg54       varchar2(1) DEFAULT ' ' NOT NULL, /*Check in 否*/
edg55       varchar2(10),            /*Check in 留置码                        */
edg56       varchar2(10),            /*Check out 留置码                       */
edg57       varchar2(4),             /*no use                                 */
edg58       varchar2(4),             /*单位                                   */
edg59       number(20,8),            /*no use                                 */
edg60       number(5),               /*单元变更序号                           */
edg61       varchar2(1) NOT NULL,    /*平行加工否                             */
edg62       number(16,8),            /*组成用量                               */
edg63       number(16,8),            /*底数                                   */
edg64       number(9,4),             /*损耗批量                               */
edg65       number(15,3) DEFAULT '0' NOT NULL, /*标准产出量*/
edg66       varchar2(1) DEFAULT ' ' NOT NULL, /*报工点否*/
edgacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
edgconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
edgdate     date,                    /*最近更改日                             */
edggrup     varchar2(10),            /*资料所有群                             */
edgmodu     varchar2(10),            /*资料更改者                             */
edgorig     varchar2(10),            /*资料建立部门                           */
edgoriu     varchar2(10),            /*资料建立者                             */
edgslk01    varchar2(1) DEFAULT ' ' NOT NULL, /*裁片管理否*/
edgslk02    number(15,3) DEFAULT '0' NOT NULL, /*现实工时*/
edgslk03    number(15,3) DEFAULT '0' NOT NULL, /*标准工价*/
edgslk04    number(15,3) DEFAULT '0' NOT NULL, /*现实工价*/
edguser     varchar2(10),            /*资料所有者                             */
edg67       varchar2(10)             /*委外厂商                               */
);

alter table edg_file add  constraint edg_pk primary key  (edg01,edg02,edg03) enable validate;
grant select on edg_file to tiptopgp;
grant update on edg_file to tiptopgp;
grant delete on edg_file to tiptopgp;
grant insert on edg_file to tiptopgp;
grant index on edg_file to public;
grant select on edg_file to ods;
