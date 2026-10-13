/*
================================================================================
檔案代號:edc_file
檔案名稱:合拼版制程档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table edc_file
(
edc01       varchar2(20) DEFAULT ' ' NOT NULL, /*合拼版号*/
edc02       number(5) DEFAULT '0' NOT NULL, /*合拼序*/
edc03       number(5) DEFAULT '0' NOT NULL, /*工艺序*/
edc04       varchar2(6),             /*作业编号                               */
edc05       varchar2(10),            /*机器编号                               */
edc06       varchar2(10),            /*工作站编号                             */
edc12       number(9,4),             /*固定损耗率                             */
edc13       number(15,3),            /*标准人工设置时间                       */
edc14       number(15,3),            /*标准人工生产时间                       */
edc15       number(15,3),            /*标准机器设置时间                       */
edc16       number(15,3),            /*标准机器生产时间                       */
edc34       number(15,3),            /*变动损耗率                             */
edc49       number(15,3),            /*单位人力                               */
edc52       varchar2(1),             /*委外否                                 */
edc53       varchar2(1),             /*PQC 否                                 */
edc54       varchar2(1),             /*Check in 否                            */
edc58       varchar2(4),             /*单位                                   */
edc59       number(20,8),            /*单位转换率                             */
edc62       number(16,8),            /*组成用量                               */
edc63       number(16,8),            /*底数                                   */
edc64       number(9,4),             /*损耗批量                               */
edc65       number(15,3),            /*标准产出量                             */
edcacti     varchar2(1),             /*资料有效码                             */
edcconf     varchar2(1),             /*资料审核码                             */
edcdate     date,                    /*最近更改日                             */
edcgrup     varchar2(10),            /*资料所有群                             */
edcmodu     varchar2(10),            /*资料更改者                             */
edcorig     varchar2(10),            /*资料建立部门                           */
edcoriu     varchar2(10),            /*资料建立者                             */
edcuser     varchar2(10),            /*资料所有者                             */
edc07       number(15,3) DEFAULT '0' NOT NULL, /*最早起始前置时间调整*/
edc08       number(15,3) DEFAULT '0' NOT NULL, /*最迟起始前置时间调整*/
edc09       number(15,3) DEFAULT '0' NOT NULL, /*最早完工前置时间调整*/
edc10       number(15,3) DEFAULT '0' NOT NULL, /*最迟完工前置时间调整*/
edc11       varchar2(10),            /*工艺编号                               */
edc121      varchar2(1) DEFAULT ' ' NOT NULL, /*盘点作业*/
edc17       number(15,3) DEFAULT '0' NOT NULL, /*标准厂外加工时间*/
edc18       number(15,3) DEFAULT '0' NOT NULL, /*标准等待时间*/
edc19       number(15,3) DEFAULT '0' NOT NULL, /*标准等待时间*/
edc20       number(15,3) DEFAULT '0' NOT NULL, /*实际人工生产时间*/
edc21       number(15,3) DEFAULT '0' NOT NULL, /*实际人工生产时间*/
edc22       number(15,3) DEFAULT '0' NOT NULL, /*实际机器设置时间*/
edc23       number(15,3) DEFAULT '0' NOT NULL, /*实际机器生产时间*/
edc24       number(15,3) DEFAULT '0' NOT NULL, /*实际厂外加工时间*/
edc25       varchar2(5),             /*开工时间                               */
edc26       varchar2(5),             /*完工时间                               */
edc27       number(9,4),             /*No Use              	                    */
edc28       number(9,4),             /*No Use              	                    */
edc291      number(15,3) DEFAULT '0' NOT NULL, /*Check in Qty*/
edc292      number(15,3) DEFAULT '0' NOT NULL, /*盘点量*/
edc301      number(15,3) DEFAULT '0' NOT NULL, /*良品转入量(+)*/
edc302      number(15,3) DEFAULT '0' NOT NULL, /*重工转入量(+)*/
edc303      number(15,3) DEFAULT '0' NOT NULL, /*工单转入量(+)*/
edc311      number(15,3) DEFAULT '0' NOT NULL, /*良品转出量(-)*/
edc312      number(15,3) DEFAULT '0' NOT NULL, /*重工转出(-)*/
edc313      number(15,3) DEFAULT '0' NOT NULL, /*当站报废量(-)*/
edc314      number(15,3) DEFAULT '0' NOT NULL, /*当站下线量(入库)(-)*/
edc315      number(15,3) DEFAULT '0' NOT NULL, /*Check in Qty    (-)*/
edc316      number(15,3) DEFAULT '0' NOT NULL, /*工单转出量       (-)*/
edc321      number(15,3) DEFAULT '0' NOT NULL, /*委外加工量*/
edc322      number(15,3) DEFAULT '0' NOT NULL, /*委外完工量*/
edc35       number(9,4),             /*C/R 比率                               */
edc36       number(9,4),             /*报废平均人工分摊比率                   */
edc37       number(15,3) DEFAULT '0' NOT NULL, /*排程人工设置时间*/
edc38       number(15,3) DEFAULT '0' NOT NULL, /*排程人工生产时间*/
edc39       number(15,3) DEFAULT '0' NOT NULL, /*排程厂外加工时间*/
edc40       number(5),               /*人工数目                               */
edc41       number(5),               /*机器数目                               */
edc42       number(9,4),             /*作业重叠程度                           */
edc43       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算基准*/
edc45       varchar2(80),            /*作业名称                               */
edc50       date,                    /*工艺开工日                             */
edc51       date,                    /*工艺完工日                             */
edc55       varchar2(10),            /*Check in 留置码                        */
edc56       varchar2(10),            /*Check out 留置码                       */
edc57       varchar2(4),             /*no use                                 */
edc60       number(5),               /*单元变更序号                           */
edc61       varchar2(1) DEFAULT ' ' NOT NULL, /*平行加工否*/
edcslk01    varchar2(1) DEFAULT ' ' NOT NULL, /*裁片管理否*/
edcslk02    number(15,3) DEFAULT '0' NOT NULL, /*现实工时*/
edcslk03    number(15,3) DEFAULT '0' NOT NULL, /*标准工价*/
edcslk04    number(15,3) DEFAULT '0' NOT NULL, /*现实工价*/
edc031      varchar2(40),            /*料件编号                               */
edc66       varchar2(1) DEFAULT ' ' NOT NULL, /*报工点否*/
edc67       varchar2(10)             /*委外厂商                               */
);

alter table edc_file add  constraint edc_pk primary key  (edc01,edc02,edc03) enable validate;
grant select on edc_file to tiptopgp;
grant update on edc_file to tiptopgp;
grant delete on edc_file to tiptopgp;
grant insert on edc_file to tiptopgp;
grant index on edc_file to public;
grant select on edc_file to ods;
