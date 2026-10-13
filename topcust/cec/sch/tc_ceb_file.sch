/*
================================================================================
檔案代號:tc_ceb_file
檔案名稱:工艺资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_ceb_file
(
tc_ceb01    varchar2(40) NOT NULL,   /*料件编号                               */
tc_ceb02    varchar2(10) NOT NULL,   /*工艺编号                               */
tc_ceb03    number(5) NOT NULL,      /*工艺序号                               */
tc_ceb04    number(9,4),             /*完工比率                               */
tc_ceb05    date,                    /*No Use                                 */
tc_ceb06    varchar2(6),             /*作业编号                               */
tc_ceb36    varchar2(40),            /*规格组件编号                           */
tc_ceb37    varchar2(5),             /*作业选择                               */
tc_ceb07    varchar2(10),            /*机器编号                               */
tc_ceb08    varchar2(10),            /*工作站编号                             */
tc_ceb09    varchar2(1),             /*盘点作业                               */
tc_ceb10    number(15,3),            /*搬运时间                               */
tc_ceb11    number(9,4),             /*作业重叠程度                           */
tc_ceb12    varchar2(10),            /*输出装置编号                           */
tc_ceb13    varchar2(1),             /*成本计算基准                           */
tc_ceb14    number(9,4),             /*变动损耗率                             */
                                     /*损耗率(%)                              */
                                     /*表示在本生产程序/作业将会发生的标准    */
                                     /*损耗率, 在对材料而言, 系统将依产品如   */
                                     /*结构中的损耗率, 为一百分比             */
tc_ceb15    number(5),               /*人工数                                 */
tc_ceb16    number(5),               /*机器数                                 */
tc_ceb17    varchar2(80),            /*说明                                   */
tc_ceb18    number(15,2),            /*标准人工设置时间                       */
tc_ceb19    number(15,2),            /*标准人工生产时间                       */
tc_ceb20    number(15,2),            /*标准机器设置时间                       */
tc_ceb21    number(15,2),            /*标准机器生产时间                       */
tc_ceb22    number(15,3),            /*标准委外加工时间                       */
tc_ceb23    number(20,6),            /*标准委外加工成本                       */
tc_ceb24    varchar2(40),            /*委外加工料件                           */
tc_ceb25    varchar2(10),            /*委外加工厂商                           */
tc_ceb26    number(15,3),            /*排程设置时间                           */
tc_ceb27    number(15,3),            /*排程生产时间                           */
tc_ceb28    number(15,3),            /*排程委外加工时间                       */
tc_ceb30    number(15,3),            /*缺省人工设置时间(分)                   */
tc_ceb31    number(15,3),            /*缺省人工生产时间(分)                   */
tc_ceb32    number(15,3),            /*缺省机器设置时间(分)                   */
tc_ceb33    number(15,3),            /*缺省机器生产时间(分)                   */
tc_ceb34    number(15,3),            /*缺省委外加工时间                       */
tc_ceb35    number(20,6),            /*缺省委外加工成本                       */
tc_ceb38    number(15,3),            /*单位人力                               */
tc_ceb39    varchar2(1),             /*委外否                                 */
tc_ceb40    varchar2(1),             /*PQC 否                                 */
tc_ceb41    varchar2(1),             /*Check in 否                            */
tc_ceb42    varchar2(10),            /*Check in hold                          */
tc_ceb43    varchar2(10),            /*Check out Hold留置码                   */
tc_ceb44    varchar2(4),             /*NO USE                                 */
tc_ceb45    varchar2(4),             /*转出单位                               */
tc_ceb46    number(20,8),            /*组成用量                               */
tc_cebacti  varchar2(1),             /*资料有效码                             */
tc_cebuser  varchar2(10),            /*资料所有者                             */
tc_cebgrup  varchar2(10),            /*资料所有群                             */
tc_cebmodu  varchar2(10),            /*资料更改者                             */
tc_cebdate  date,                    /*最近更改日                             */
tc_ceb47    number(5),               /*单元变更序号                           */
tc_cebslk01 varchar2(1),             /*裁片管理否                             */
tc_cebslk02 number(8,4),             /*现实工时                               */
tc_cebslk03 number(8,4),             /*延后上工序开工天数                     */
tc_cebslk04 number(20,6),            /*标准工价                               */
tc_cebslk05 number(20,6),            /*现实工价                               */
tc_cebud01  varchar2(255),           /*自订字段-Textedit                      */
tc_cebud02  varchar2(1500),          /*生产说明                               */
tc_cebud03  varchar2(1500),          /*使用工具                               */
tc_cebud04  varchar2(40),            /*物料代号                               */
tc_cebud05  varchar2(1500),          /*使用程序                               */
tc_cebud06  varchar2(40),            /*自订字段-文字                          */
tc_cebud07  number(15,3),            /*自订字段-数值                          */
tc_cebud08  number(15,3),            /*自订字段-数值                          */
tc_cebud09  number(15,3),            /*自订字段-数值                          */
tc_cebud10  number(10),              /*自订字段-整数                          */
tc_cebud11  number(10) NOT NULL,     /*变更版次序号                           */
tc_cebud12  number(10),              /*自订字段-整数                          */
tc_cebud13  date,                    /*自订字段-日期                          */
tc_cebud14  date,                    /*自订字段-日期                          */
tc_cebud15  date,                    /*自订字段-日期                          */
tc_ceb48    number(20,6),            /*加工单价                               */
tc_ceb49    varchar2(10),            /*no use                                 */
tc_ceboriu  varchar2(10),            /*资料建立者                             */
tc_ceborig  varchar2(10),            /*资料建立部门                           */
tc_ceb012   varchar2(10) DEFAULT ' ' NOT NULL, /*工艺段号*/
tc_ceb51    number(16,8),            /*底数                                   */
tc_ceb52    number(15,3),            /*固定损耗量                             */
tc_ceb53    number(15,3),            /*损耗批量                               */
tc_ceb66    varchar2(1) DEFAULT ' ' NOT NULL /*报工点否*/
);

alter table tc_ceb_file add  constraint tpc_ceb_pk primary key  (tc_ceb01,tc_ceb02,tc_ceb03,tc_ceb012,tc_cebud11) enable validate;
grant select on tc_ceb_file to tiptopgp;
grant update on tc_ceb_file to tiptopgp;
grant delete on tc_ceb_file to tiptopgp;
grant insert on tc_ceb_file to tiptopgp;
grant index on tc_ceb_file to public;
grant select on tc_ceb_file to ods;
