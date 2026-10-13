/*
================================================================================
檔案代號:ecb_file
檔案名稱:工艺资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ecb_file
(
ecb01       varchar2(40) NOT NULL,   /*料件编号                               */
ecb02       varchar2(10) NOT NULL,   /*工艺编号                               */
ecb03       number(5) NOT NULL,      /*工艺序号                               */
ecb04       number(9,4),             /*完工比率                               */
ecb05       date,                    /*No Use                                 */
ecb06       varchar2(6),             /*作业编号                               */
ecb36       varchar2(40),            /*规格组件编号                           */
ecb37       varchar2(5),             /*作业选择                               */
ecb07       varchar2(10),            /*机器编号                               */
ecb08       varchar2(10),            /*工作站编号                             */
ecb09       varchar2(1),             /*盘点作业                               */
ecb10       number(15,3),            /*搬运时间                               */
ecb11       number(9,4),             /*作业重叠程度                           */
ecb12       varchar2(10),            /*输出装置编号                           */
ecb13       varchar2(1),             /*成本计算基准                           */
ecb14       number(9,4),             /*变动损耗率                             */
                                     /*损耗率(%)                              */
                                     /*表示在本生产程序/作业将会发生的标准    */
                                     /*损耗率, 在对材料而言, 系统将依产品如   */
                                     /*结构中的损耗率, 为一百分比             */
ecb15       number(5),               /*人工数                                 */
ecb16       number(5),               /*机器数                                 */
ecb17       varchar2(80),            /*说明                                   */
ecb18       number(15,2),            /*标准人工设置时间                       */
ecb19       number(15,2),            /*标准人工生产时间                       */
ecb20       number(15,2),            /*标准机器设置时间                       */
ecb21       number(15,2),            /*标准机器生产时间                       */
ecb22       number(15,3),            /*标准委外加工时间                       */
ecb23       number(20,6),            /*标准委外加工成本                       */
ecb24       varchar2(40),            /*委外加工料件                           */
ecb25       varchar2(10),            /*委外加工厂商                           */
ecb26       number(15,3),            /*排程设置时间                           */
ecb27       number(15,3),            /*排程生产时间                           */
ecb28       number(15,3),            /*排程委外加工时间                       */
ecb30       number(15,3),            /*缺省人工设置时间(分)                   */
ecb31       number(15,3),            /*缺省人工生产时间(分)                   */
ecb32       number(15,3),            /*缺省机器设置时间(分)                   */
ecb33       number(15,3),            /*缺省机器生产时间(分)                   */
ecb34       number(15,3),            /*缺省委外加工时间                       */
ecb35       number(20,6),            /*缺省委外加工成本                       */
ecb38       number(15,3),            /*单位人力                               */
ecb39       varchar2(1),             /*委外否                                 */
ecb40       varchar2(1),             /*PQC 否                                 */
ecb41       varchar2(1),             /*Check in 否                            */
ecb42       varchar2(10),            /*Check in hold                          */
ecb43       varchar2(10),            /*Check out Hold留置码                   */
ecb44       varchar2(4),             /*NO USE                                 */
ecb45       varchar2(4),             /*转出单位                               */
ecb46       number(20,8),            /*组成用量                               */
ecbacti     varchar2(1),             /*资料有效码                             */
ecbuser     varchar2(10),            /*资料所有者                             */
ecbgrup     varchar2(10),            /*资料所有群                             */
ecbmodu     varchar2(10),            /*资料更改者                             */
ecbdate     date,                    /*最近更改日                             */
ecb47       number(5),               /*单元变更序号                           */
ecbslk01    varchar2(1),             /*裁片管理否                             */
ecbslk02    number(8,4),             /*现实工时                               */
ecbslk03    number(8,4),             /*延后上工序开工天数                     */
ecbslk04    number(20,6),            /*标准工价                               */
ecbslk05    number(20,6),            /*现实工价                               */
ecbud01     varchar2(255),           /*自订字段-Textedit                      */
ecbud02     varchar2(1500),          /*生产说明                               */
ecbud03     varchar2(1500),          /*使用工具                               */
ecbud04     varchar2(40),            /*物料代号                               */
ecbud05     varchar2(1500),          /*使用程序                               */
ecbud06     varchar2(40),            /*报工否                                 */
ecbud07     number(15,3),            /*自订字段-数值                          */
ecbud08     number(15,3),            /*自订字段-数值                          */
ecbud09     varchar2(10) DEFAULT ' ' NOT NULL, /*层别*/
ecbud10     number(10),              /*自订字段-整数                          */
ecbud11     number(10),              /*自订字段-整数                          */
ecbud12     number(10),              /*自订字段-整数                          */
ecbud13     date,                    /*自订字段-日期                          */
ecbud14     date,                    /*自订字段-日期                          */
ecbud15     date,                    /*自订字段-日期                          */
ecb48       number(20,6),            /*加工单价                               */
ecb49       varchar2(10),            /*no use                                 */
ecboriu     varchar2(10),            /*资料建立者                             */
ecborig     varchar2(10),            /*资料建立部门                           */
ecb012      varchar2(10) DEFAULT ' ' NOT NULL, /*工艺段号*/
ecb51       number(16,8),            /*底数                                   */
ecb52       number(15,3),            /*固定损耗量                             */
ecb53       number(15,3),            /*损耗批量                               */
ecb66       varchar2(1) DEFAULT ' ' NOT NULL, /*报工点否*/
ecbud16     varchar2(1000),          /*参数                                   */
ecbud17     varchar2(1000)           /*图纸                                   */
);

alter table ecb_file add  constraint ecb_pk primary key  (ecb01,ecb02,ecb03,ecb012) enable validate;
grant select on ecb_file to tiptopgp;
grant update on ecb_file to tiptopgp;
grant delete on ecb_file to tiptopgp;
grant insert on ecb_file to tiptopgp;
grant index on ecb_file to public;
grant select on ecb_file to ods;
