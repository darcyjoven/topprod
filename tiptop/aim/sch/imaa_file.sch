/*
================================================================================
檔案代號:imaa_file
檔案名稱:料件申请资料主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table imaa_file
(
imaa00      varchar2(1),             /*申请类型(I:新增 U:更改)                */
imaano      varchar2(80) NOT NULL,   /*申请单号                               */
imaa011     varchar2(40),            /*申请料件编号                           */
imaa01      varchar2(40) NOT NULL,   /*料件编号                               */
imaa02      varchar2(120),           /*品名                                   */
imaa021     varchar2(120),           /*规格                                   */
imaa03      varchar2(40),            /*目录参考号码                           */
imaa04      varchar2(255),           /*工程图号                               */
imaa05      varchar2(2),             /*No Use                                 */
imaa06      varchar2(10),            /*分群码0:表由其他相关系统而             */
imaa07      varchar2(1),             /*abc码                                  */
imaa08      varchar2(1),             /*来源码                                 */
imaa09      varchar2(10),            /*其他分群码                             */
imaa10      varchar2(10),            /*其他分群码 二                          */
imaa11      varchar2(10),            /*其他分群码 三                          */
imaa12      varchar2(10),            /*其他分群码 四                          */
imaa13      varchar2(40),            /*规格组件料件编号                       */
imaa14      varchar2(1),             /*是否为工程料件                         */
imaa15      varchar2(1),             /*保税与否                               */
imaa16      number(5),               /*No Use                                 */
imaa17      varchar2(4),             /*No Use                                 */
imaa17_fac  number(16,8),            /*No Use                                 */
imaa18      number(15,3),            /*单位重量                               */
imaa19      varchar2(4),             /*保税料件进出口分类统计用类             */
imaa20      number(9,3),             /*保税料件年度盘差容许率                 */
imaa21      varchar2(4),             /*保税料件税则编号                       */
imaa22      number(9,3),             /*保税料件应补税税率                     */
imaa23      varchar2(10),            /*仓管员                                 */
imaa24      varchar2(1),             /*检验码                                 */
imaa25      varchar2(4),             /*库存单位                               */
imaa26      number(15,3) NOT NULL,   /*No Use                                 */
imaa261     number(15,3) NOT NULL,   /*No Use                                 */
imaa262     number(15,3) NOT NULL,   /*No Use                                 */
imaa27      number(15,3),            /*安全库存量                             */
imaa271     number(15,3),            /*最高储存数量                           */
imaa28      number(15,3),            /*安全库存期间                           */
imaa29      date,                    /*No Use                                 */
imaa30      date,                    /*No Use                                 */
imaa31      varchar2(4),             /*销售单位                               */
imaa31_fac  number(20,8),            /*销售单位/库存单位换算率                */
imaa32      number(20,6),            /*标准销售订价                           */
imaa33      number(20,6),            /*最近销售单价                           */
imaa34      varchar2(10),            /*成本中心                               */
imaa35      varchar2(10),            /*主要仓库                               */
imaa36      varchar2(10),            /*主要库位别                             */
imaa37      varchar2(1),             /*补货策略码                             */
imaa38      number(15,3),            /*再补货点                               */
imaa39      varchar2(24),            /*料件所属会计科目                       */
imaa40      number(15,3),            /*No Use                                 */
imaa41      number(15,3),            /*No Use                                 */
imaa42      varchar2(1),             /*批号追踪方式                           */
imaa43      varchar2(10),            /*采购员                                 */
imaa44      varchar2(4),             /*采购单位                               */
imaa44_fac  number(20,8),            /*采购单位/库存单位换算率                */
imaa45      number(15,3),            /*采购单位倍量                           */
imaa46      number(15,3),            /*最少采购数量                           */
imaa47      number(9,4),             /*采购损耗率                             */
imaa48      number(15,3),            /*采购安全期                             */
imaa49      number(15,3),            /*到厂前置期                             */
imaa491     number(15,3),            /*入库前置期                             */
imaa50      number(15,3),            /*请购安全期                             */
imaa51      number(15,3),            /*经济订购量                             */
imaa52      number(15,3),            /*No Use                                 */
imaa53      number(20,6),            /*No Use                                 */
imaa531     number(20,6),            /*市价                                   */
imaa532     date,                    /*No Use                                 */
imaa54      varchar2(10),            /*主要供应厂商                           */
imaa55      varchar2(4),             /*生产单位                               */
imaa55_fac  number(20,8),            /*生产单位/库存单位换算率                */
imaa56      number(15,3),            /*生产单位倍量                           */
imaa561     number(15,3),            /*最少生产数量                           */
imaa562     number(9,4),             /*生产损耗率                             */
imaa57      number(5),               /*主工艺序号                             */
imaa571     varchar2(40),            /*主工艺料件                             */
imaa58      number(15,3),            /*最后人工工时                           */
imaa59      number(15,3),            /*固定前置时间                           */
imaa60      number(15,3),            /*变动前置时间                           */
imaa61      number(15,3),            /*qc 前置时间                            */
imaa62      number(15,3),            /*最大累计前置时间                       */
imaa63      varchar2(4),             /*发料单位                               */
imaa63_fac  number(20,8),            /*发料单位/库存单位换算率                */
imaa64      number(15,3),            /*发料单位倍量                           */
imaa641     number(15,3),            /*最少发料数量                           */
imaa65      number(15,3),            /*发料安全存量                           */
imaa66      number(15,3),            /*发料安全期                             */
imaa67      varchar2(10),            /*计划员                                 */
imaa68      number(15,3),            /*需求时距                               */
imaa69      number(15,3),            /*计划时距                               */
imaa70      varchar2(1),             /*消耗料件                               */
imaa71      number(5),               /*储存有效天数                           */
imaa72      number(15,3),            /*MRP允许交期提前天数                    */
imaa73      date,                    /*No Use                                 */
imaa74      date,                    /*No Use                                 */
imaa86      varchar2(4),             /*成本单位                               */
imaa86_fac  number(20,8),            /*成本/库存单位换算率                    */
imaa87      varchar2(10),            /*成本项目-材料                          */
imaa871     number(9,4),             /*间接物料分摊率                         */
imaa872     varchar2(10),            /*材料制造费用成本项目                   */
imaa873     number(9,4),             /*间接人工分摊率                         */
imaa874     varchar2(10),            /*人工制造费用成本项目                   */
imaa88      number(15,3),            /*期间采购数量                           */
imaa881     date,                    /*No Use                                 */
imaa89      number(5),               /*期间采购使用的期间                     */
imaa90      number(5),               /*期间采购使用的期间                     */
imaa91      number(20,6),            /*No Use                                 */
imaa92      varchar2(1),             /*是否签核                               */
imaa93      varchar2(8),             /*No Use                                 */
imaa94      varchar2(10),            /*缺省工艺编号                           */
imaa95      number(20,6),            /*保税单价                               */
imaa75      varchar2(15),            /*No Use                                 */
imaa76      varchar2(10),            /*No Use                                 */
imaa77      number(16,8),            /*No Use                                 */
imaa78      number(5),               /*预算成本阶数                           */
imaa79      number(5),               /*No Use                                 */
imaa80      number(5),               /*发料低阶码                             */
imaa81      number(5),               /*No Use                                 */
imaa82      number(5),               /*No Use                                 */
imaa83      number(5),               /*No Use                                 */
imaa84      number(5),               /*No Use                                 */
imaa85      number(5),               /*No Use                                 */
imaa851     varchar2(10),            /*缺省工作区                             */
imaa852     varchar2(1),             /*是否为量产料件                         */
imaa853     varchar2(1),             /*No Use                                 */
imaa96      number(5),               /*No Use                                 */
imaa97      number(5),               /*No Use                                 */
imaa98      number(20,6),            /*No Use                                 */
imaa99      number(15,3),            /*再补货量                               */
imaa100     varchar2(1),             /*检验程度                               */
imaa101     varchar2(1),             /*检验水准                               */
imaa102     varchar2(1),             /*级数                                   */
imaa103     varchar2(1),             /*采购特性                               */
imaa104     number(15,3),            /*厂商分配起始量                         */
imaa105     varchar2(1),             /*是否为软体对象                         */
imaa106     varchar2(1),             /*保税料件类型                           */
imaa107     varchar2(1),             /*插件位置                               */
imaa108     varchar2(1),             /*工单发料前调拨否                       */
imaa109     varchar2(10),            /*材料类型                               */
imaa110     varchar2(1),             /*工单开立展开选项                       */
imaa111     varchar2(5),             /*缺省工单单别                           */
imaa121     number(20,6),            /*单位材料成本                           */
imaa122     number(20,6),            /*单位人工成本                           */
imaa123     number(20,6),            /*单位制造费用                           */
imaa124     number(20,6),            /*单位管销成本                           */
imaa125     number(20,6),            /*单位成本                               */
imaa126     number(15,3),            /*基本利润率                             */
imaa127     number(20,6),            /*税前订价                               */
imaa128     number(20,6),            /*含税订价                               */
imaa129     number(15,3),            /*调拨计价加计百分比                     */
imaa130     varchar2(1),             /*产品销售特性                           */
imaa131     varchar2(10),            /*产品分类编号                           */
imaa132     varchar2(24),            /*费用科目编号                           */
imaa133     varchar2(40),            /*产品预测料号                           */
imaa134     varchar2(15),            /*主要包装方式编号                       */
imaa135     varchar2(40),            /*产品条码编号                           */
imaa136     varchar2(10),            /*主要wip 仓库                           */
imaa137     varchar2(10),            /*主要wip 库位                           */
imaa138     varchar2(40),            /*FCC No.                                */
imaa139     varchar2(1),             /*mps 计算否                             */
imaa140     varchar2(1),             /*No Use                                 */
imaa141     varchar2(1),             /*产品序号控制方式                       */
imaa142     number(5),               /*产品序号之固定长度                     */
imaa143     number(5),               /*产品序号之字首固定长度                 */
imaa144     varchar2(10),            /*产品序号之字首固定字                   */
imaa145     varchar2(1),             /*产品序号是否为固定长度                 */
imaa146     varchar2(1),             /*bom异动否                              */
imaa147     varchar2(1),             /*插件位置与qpa是否要勾稽                */
imaa148     number(5),               /*保证期                                 */
imaa901     date,                    /*No Use                                 */
imaa902     date,                    /*No Use                                 */
imaa903     varchar2(1),             /*可否做联产品入库                       */
imaa904     varchar2(1),             /*No Use                                 */
imaa905     varchar2(1),             /*当月是否入联产品                       */
imaa906     varchar2(1),             /*单位使用方式                           */
imaa907     varchar2(4),             /*第二单位(母单位/参考单位)              */
imaa908     varchar2(4),             /*计价单位                               */
imaa909     number(5),               /*mrp汇总时距(天)(预留字段)              */
imaa910     varchar2(20),            /*主特性代码                             */
imaaacti    varchar2(1),             /*资料有效码                             */
imaauser    varchar2(10),            /*资料所有者                             */
imaagrup    varchar2(10),            /*资料所有群                             */
imaamodu    varchar2(10),            /*资料更改者                             */
imaadate    date,                    /*最近更改日                             */
imaaag      varchar2(10),            /*属性群组代码                           */
imaaag1     varchar2(10),            /*母料件属性群组代码                     */
imaaud01    varchar2(255),           /*自订字段                               */
imaaud02    varchar2(40),            /*自订字段                               */
imaaud03    varchar2(40),            /*自订字段                               */
imaaud04    varchar2(40),            /*自订字段                               */
imaaud05    varchar2(40),            /*自订字段                               */
imaaud06    varchar2(40),            /*自订字段                               */
imaaud07    number(15,3),            /*自订字段                               */
imaaud08    number(15,3),            /*自订字段                               */
imaaud09    number(15,3),            /*自订字段                               */
imaaud10    number(10),              /*自订字段                               */
imaaud11    number(10),              /*自订字段                               */
imaaud12    number(10),              /*自订字段                               */
imaaud13    date,                    /*自订字段                               */
imaaud14    date,                    /*自订字段                               */
imaaud15    date,                    /*自订字段                               */
imaa1001    varchar2(100),           /*中文名称(全称)                         */
imaa1002    varchar2(80),            /*英文名称                               */
imaa1003    varchar2(20),            /*No Use                                 */
imaa1004    varchar2(10),            /*品类                                   */
imaa1005    varchar2(10),            /*品牌                                   */
imaa1006    varchar2(10),            /*系列                                   */
imaa1007    varchar2(10),            /*型别                                   */
imaa1008    varchar2(10),            /*规格                                   */
imaa1009    varchar2(10),            /*属性                                   */
imaa1010    varchar2(1),             /*状态码                                 */
imaa1011    number(15,3),            /*单位体积                               */
imaa1012    date,                    /*No Use                                 */
imaa1013    date,                    /*No Use                                 */
imaa1014    varchar2(1),             /*产品周期状态                           */
imaa1015    date,                    /*预计停产日                             */
imaa1016    varchar2(40),            /*箱条码                                 */
imaa1017    number(20,6),            /*料件标准宽                             */
imaa1018    number(20,6),            /*料件标准秤量                           */
imaa1019    number(20,6),            /*零只长度                               */
imaa1020    number(20,6),            /*零只宽度                               */
imaa1021    number(20,6),            /*零只高度                               */
imaa1022    number(15,3),            /*零只体积                               */
imaa1023    number(15,3),            /*零只重量                               */
imaa1024    number(20,6),            /*整箱长度                               */
imaa1025    number(20,6),            /*整箱宽度                               */
imaa1026    number(20,6),            /*整箱高度                               */
imaa1027    number(15,3),            /*整箱体积                               */
imaa1028    number(15,3),            /*整箱重量                               */
imaa1029    varchar2(1),             /*是否秤重控管                           */
imaa911     varchar2(1),             /*是否为重覆性生产料件 (y/n)             */
imaa912     number(15,3),            /*标准机器工时                           */
imaa913     varchar2(1),             /*统购否                                 */
imaa914     varchar2(10),            /*采购中心代码                           */
imaa391     varchar2(24),            /*会计科目二                             */
imaa1321    varchar2(24),            /*费用科目二                             */
imaa915     varchar2(1) DEFAULT '0', /*是否需做供应商的控制                   */
imaa918     varchar2(1),             /*制造批号管理否                         */
imaa919     varchar2(1),             /*制造批号自动编码否                     */
imaa920     varchar2(10),            /*制造批号编码原则                       */
imaa921     varchar2(1),             /*序号管理否                             */
imaa922     varchar2(1),             /*序号自动编码否                         */
imaa923     varchar2(10),            /*序号编码原则                           */
imaa924     varchar2(1),             /*序号唯一否                             */
imaa925     varchar2(1),             /*排序方式                               */
imaa601     number(15,3),            /*变动前置时间批量                       */
imaa926     varchar2(1) DEFAULT 'N' NOT NULL, /*AVL否*/
imaaoriu    varchar2(10),            /*资料建立者                             */
imaaorig    varchar2(10),            /*资料建立部门                           */
imaa153     number(9,4),             /*工单完工误差率                         */
imaa120     varchar2(1) DEFAULT ' ' NOT NULL, /*单据性质*/
imaa022     number(15,3) DEFAULT '0' NOT NULL, /*量化规格*/
imaa251     varchar2(4),             /*量化單位                               */
imaaicd01   varchar2(40),            /*母体料号                               */
imaaicd02   varchar2(40),            /*外编母体                               */
imaaicd03   varchar2(40),            /*外编子体                               */
imaaicd04   varchar2(1) DEFAULT ' ' NOT NULL, /*料件状态*/
imaaicd05   varchar2(1) DEFAULT ' ' NOT NULL, /*料件特性*/
imaaicd06   varchar2(40),            /*内编子体                               */
imaaicd07   varchar2(40),            /*RoHs                                   */
imaaicd08   varchar2(1) DEFAULT ' ' NOT NULL, /*刻号/BIN管理*/
imaaicd09   varchar2(1) DEFAULT ' ' NOT NULL, /*Date Code 否*/
imaaicd10   varchar2(10),            /*作业群组                               */
imaaicd11   varchar2(40),            /*来源单号                               */
imaaicd12   number(9,4),             /*备品比率                               */
imaaicd13   varchar2(1) DEFAULT ' ' NOT NULL, /*批号管控否*/
imaaicd14   number(15,3) DEFAULT '0' NOT NULL, /*GROSS DIE*/
imaaicd15   number(9,4) DEFAULT '0' NOT NULL, /*良率%*/
imaaicd16   varchar2(40),            /*WAFER型号                              */
imaa159     varchar2(1) DEFAULT ' ' NOT NULL, /*批号控管方式*/
imaa928     varchar2(1) DEFAULT ' ' NOT NULL, /*特性主料*/
imaa929     varchar2(40),            /*特性主料编号                           */
imaaicd17   varchar2(1) DEFAULT '3' NOT NULL, /*IC类型*/
imaaicd18   varchar2(6),             /*Pkg Type                               */
imaaicd19   varchar2(10),            /*Pin Count                              */
imaaicd20   varchar2(20),            /*B/d No                                 */
imaaicd21   varchar2(10),            /*B/d Ver                                */
imaa149     varchar2(24),            /*代销科目                               */
imaa1491    varchar2(24),            /*代销科目二                             */
imaa151     varchar2(1) DEFAULT ' ' NOT NULL, /*母料件否*/
imaa154     varchar2(1) DEFAULT ' ' NOT NULL, /*是否为券*/
imaa940     varchar2(10),            /*颜色组                                 */
imaa941     varchar2(10),            /*尺码组                                 */
imaa721     number(15,3),            /*MRP允许交期延后天数                    */
imaa1030    varchar2(10),
imaa163     varchar2(24),            /*发出商品科目                           */
imaa1631    varchar2(24),            /*发出商品科目二                         */
imaa164     varchar2(24),            /*费用科目                               */
imaa1641    varchar2(24)             /*费用科目二                             */
);

alter table imaa_file add  constraint imaa_pk primary key  (imaano) enable validate;
grant select on imaa_file to tiptopgp;
grant update on imaa_file to tiptopgp;
grant delete on imaa_file to tiptopgp;
grant insert on imaa_file to tiptopgp;
grant index on imaa_file to public;
grant select on imaa_file to ods;
