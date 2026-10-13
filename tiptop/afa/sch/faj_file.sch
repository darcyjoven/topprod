/*
================================================================================
檔案代號:faj_file
檔案名稱:固定资产基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table faj_file
(
faj01       varchar2(10) NOT NULL,   /*序号                                   */
faj02       varchar2(10) NOT NULL,   /*财产编号                               */
faj021      varchar2(1),             /*类型                                   */
faj022      varchar2(4) NOT NULL,    /*附号                                   */
faj03       varchar2(1),             /*取得方式                               */
faj04       varchar2(10),            /*资产类型                               */
faj05       varchar2(10),            /*资产次类型                             */
faj06       varchar2(1000),          /*中文名称-1                             */
faj061      varchar2(80),            /*中文名称-2                             */
faj07       varchar2(1000),          /*英文名称-1                             */
faj071      varchar2(80),            /*英文名称-2                             */
faj08       varchar2(30),            /*规格型号                               */
faj09       varchar2(1),             /*资产性质                               */
faj10       varchar2(10),            /*供应商编号                             */
faj11       varchar2(1000),          /*制造厂商编号                           */
faj12       varchar2(10),            /*原产地                                 */
faj13       number(20,6),            /*本币单价                               */
faj14       number(20,6),            /*本币成本                               */
faj141      number(20,6),            /*调整成本                               */
faj15       varchar2(4),             /*原币币种                               */
faj16       number(20,6),            /*原币成本                               */
faj17       number(5),               /*数量                                   */
faj171      number(5),               /*在外数量                               */
faj18       varchar2(4),             /*计量单位                               */
faj19       varchar2(10),            /*保管人                                 */
faj20       varchar2(10),            /*保管部门                               */
faj21       varchar2(10),            /*存放位置                               */
faj22       varchar2(10),            /*存放营运中心                           */
faj23       varchar2(1),             /*分摊方式                               */
faj24       varchar2(10),            /*分摊部门/分摊类型                      */
faj25       date,                    /*取得日期                               */
faj26       date,                    /*入帐日期                               */
faj27       varchar2(6),             /*折旧年月                               */
faj28       varchar2(1),             /*折旧方法                               */
faj29       number(5),               /*耐用年限(月数)                         */
faj30       number(5),               /*未使用年限(月数)                       */
faj31       number(20,6),            /*预留残值                               */
faj32       number(20,6),            /*累积折旧                               */
faj33       number(20,6),            /*未折减额                               */
faj34       varchar2(1),             /*折毕再提否                             */
faj35       number(20,6),            /*折毕再提预留残值                       */
faj36       number(5),               /*折毕再提年限                           */
faj37       varchar2(1),             /*是否直接资本化                         */
faj38       varchar2(1),             /*保税否                                 */
faj39       varchar2(1),             /*保险否                                 */
faj40       varchar2(1),             /*免税否                                 */
faj41       varchar2(1),             /*抵押否                                 */
faj42       varchar2(1),             /*投资抵减否                             */
faj421      number(5),               /*本币投资抵减比率                       */
faj422      number(5),               /*外币投资抵减比率                       */
faj423      number(5),               /*投资抵减补税年限                       */
faj43       varchar2(1),             /*资产状态                               */
faj44       varchar2(10),            /*进货营运中心                           */
faj45       varchar2(20),            /*帐款编号                               */
faj451      number(5),               /*帐款编号项次                           */
faj46       varchar2(20),            /*收料单号                               */
faj461      number(5),               /*收料单项次                             */
faj462      date,                    /*收料日期                               */
faj47       varchar2(20),            /*采购单号                               */
faj471      number(5),               /*采购单项次                             */
faj48       varchar2(30),            /*进口报单                               */
faj49       varchar2(10),            /*进口编号                               */
faj491      date,                    /*交货日期                               */
faj50       varchar2(12),            /*预算编号                               */
faj51       varchar2(600),           /*发票号码                               */
                                     /*                                       */
faj511      date,                    /*发票日期                               */
faj52       varchar2(20),            /*凭证号码                               */
faj53       varchar2(24),            /*资产科目                               */
faj54       varchar2(24),            /*累折科目                               */
faj55       varchar2(24),            /*折旧科目                               */
faj56       varchar2(80),            /*用途                                   */
faj57       number(5),               /*最近折旧年度                           */
faj571      number(5),               /*最近折旧期别                           */
faj58       number(5),               /*销帐数量                               */
faj59       number(20,6),            /*销帐成本                               */
faj60       number(20,6),            /*销帐累折                               */
faj61       varchar2(1),             /*税签折旧方法                           */
faj62       number(20,6),            /*税签成本                               */
faj63       number(20,6),            /*税签调整成本                           */
faj64       number(5),               /*税签耐用年限                           */
faj65       number(5),               /*税签未使用年限(月数)                   */
faj66       number(20,6),            /*税签预留残值                           */
faj67       number(20,6),            /*税签累积折旧                           */
faj68       number(20,6),            /*税签未折减额                           */
faj69       number(20,6),            /*税签销帐成本                           */
faj70       number(20,6),            /*税签销帐累折                           */
faj71       varchar2(1),             /*税签折毕再提否                         */
faj72       number(20,6),            /*税签再提预留残值                       */
faj73       number(5),               /*税签折毕再提年限                       */
faj74       number(5),               /*最近税签折旧年度                       */
faj741      number(5),               /*最近折旧期别                           */
faj80       number(5),               /*抵减率                                 */
faj81       number(20,6),            /*抵减金额                               */
faj811      number(20,6),            /*已抵减金额                             */
faj812      number(5),               /*已抵减的年度                           */
faj813      varchar2(80),            /*不可抵减原因                           */
faj82       date,                    /*管理局核准日期                         */
faj83       varchar2(30),            /*管理局核准文号                         */
faj84       date,                    /*国税局核准日期                         */
faj85       varchar2(30),            /*国税局核准文号                         */
faj851      varchar2(1),             /*抵减的合并码                           */
faj86       number(20,6),            /*申请抵押金额                           */
faj87       number(20,6),            /*设置抵押金额                           */
faj88       date,                    /*抵押日期                               */
faj89       varchar2(30),            /*抵押文号                               */
faj90       varchar2(20),            /*抵押银行                               */
faj91       date,                    /*解除日期                               */
faj92       varchar2(10),            /*底稿财产编号                           */
faj921      varchar2(4),             /*底稿财产附号                           */
faj100      date,                    /*最近异动日期                           */
faj201      varchar2(1),             /*税签资产状态                           */
faj202      number(5),               /*No Use                                 */
faj203      number(20,6),            /*本期累折(财签)                         */
faj204      number(20,6),            /*本期销帐累折(财签)                     */
faj205      number(20,6),            /*本期累折(税签)                         */
faj206      number(20,6),            /*本期销帐累折(税签)                     */
faj207      varchar2(1),             /*资产列管/列帐                          */
fajconf     varchar2(1),             /*审核否                                 */
fajuser     varchar2(10),            /*资料所有者                             */
fajgrup     varchar2(10),            /*资料所有部门                           */
fajmodu     varchar2(10),            /*资料更改者                             */
fajdate     date,                    /*最近更改日                             */
faj101      number(20,6),            /*已计提减值准备                         */
faj102      number(20,6),            /*销帐减值准备                           */
faj103      number(20,6),            /*税签减值准备                           */
faj104      number(20,6),            /*税签销帐减值                           */
faj105      varchar2(1),             /*资产停用否                             */
                                     /*資產停用否(Y/N)      #No:A099          */
faj106      number(15,2),            /*预计总工作量                           */
faj107      number(15,2),            /*已使用工作量                           */
faj108      number(20,6),            /*年折旧额                               */
faj109      number(20,6),            /*税签年折旧额                           */
faj110      number(15,2),            /*税签预计总工作量                       */
faj111      number(15,2),            /*税签已使用工作量                       */
faj112      number(15,2),            /*No Use                                 */
faj113      number(15,2),            /*No Use                                 */
faj114      number(5),               /*No Use                                 */
faj115      varchar2(1),             /*保税机器设备撷取否                     */
                                     /*保稅機器設備擷取否 #FUN-6A0007         */
faj531      varchar2(24),            /*资产科目二                             */
faj541      varchar2(24),            /*累折科目二                             */
faj551      varchar2(24),            /*折旧科目二                             */
fajud01     varchar2(255),           /*自订字段-Textedit                      */
fajud02     varchar2(100),           /*发票号                                 */
fajud03     varchar2(100),           /*凭证号                                 */
fajud04     varchar2(40),            /*自订字段-文字                          */
fajud05     varchar2(40),            /*自订字段-文字                          */
fajud06     varchar2(40),            /*自订字段-文字                          */
fajud07     number(15,3),            /*自订字段-数值                          */
fajud08     number(15,3),            /*自订字段-数值                          */
fajud09     number(15,3),            /*自订字段-数值                          */
fajud10     number(10),              /*自订字段-整数                          */
fajud11     number(10),              /*自订字段-整数                          */
fajud12     number(10),              /*自订字段-整数                          */
fajud13     date,                    /*自订字段-日期                          */
fajud14     date,                    /*自订字段-日期                          */
fajud15     date,                    /*自订字段-日期                          */
faj331      number(20,6) DEFAULT '0' NOT NULL, /*第一个月未折减额*/
faj681      number(20,6) DEFAULT '0' NOT NULL, /*税签第一个月未折减额*/
fajoriu     varchar2(10),            /*资料建立者                             */
fajorig     varchar2(10),            /*资料建立部门                           */
faj93       varchar2(10),            /*族群编号                               */
faj1012     number(20,6) DEFAULT '0' NOT NULL, /*已堤列减值准备(财签二)*/
faj1022     number(20,6) DEFAULT '0' NOT NULL, /*销帐减值准备(财签二)*/
faj1062     number(15,3) DEFAULT '0' NOT NULL, /*预计总工作量(财签二)*/
faj1072     number(15,3) DEFAULT '0' NOT NULL, /*已使用工作量(财签二)*/
faj1082     number(20,6) DEFAULT '0' NOT NULL, /*年折旧额(财签二)*/
faj1412     number(20,6) DEFAULT '0' NOT NULL, /*调整成本(财签二)*/
faj142      number(20,6) DEFAULT '0' NOT NULL, /*取得成本(财签二)*/
faj143      varchar2(4),             /*币别(财签二)                           */
faj144      number(20,10),           /*取得汇率(财签二)                       */
faj2032     number(20,6) DEFAULT '0' NOT NULL, /*本期累折(财签二)*/
faj2042     number(20,6) DEFAULT '0' NOT NULL, /*本期销账累折(财签二)*/
faj232      varchar2(1) DEFAULT ' ' NOT NULL, /*分摊方式(财签二)*/
faj242      varchar2(10),            /*分摊部门/分摊类型(财签二)              */
faj262      date,                    /*入账日期(财签二)                       */
faj272      varchar2(6),             /*折旧年月(财签二)                       */
faj282      varchar2(1) DEFAULT ' ' NOT NULL, /*折旧方法(财签二)*/
faj292      number(5),               /*耐用年限(月数)(财签二)                 */
faj302      number(5),               /*未使用年限(月数)(财签二)               */
faj312      number(20,6) DEFAULT '0' NOT NULL, /*预留残值(财签二)*/
faj322      number(20,6) DEFAULT '0' NOT NULL, /*累积折旧(财签二)*/
faj3312     number(20,6) DEFAULT '0' NOT NULL, /*第一个月未折减额(财签二)*/
faj332      number(20,6) DEFAULT '0' NOT NULL, /*未折减额(财签二)*/
faj342      varchar2(1) DEFAULT ' ' NOT NULL, /*折毕再提否(财签二)*/
faj352      number(20,6) DEFAULT '0' NOT NULL, /*折毕再提预留残值(财签二)*/
faj362      number(5),               /*折毕再提年限(财签二)                   */
faj432      varchar2(1) DEFAULT ' ' NOT NULL, /*资产状态(财签二)*/
faj5712     number(5),
faj572      number(5),               /*最近折旧年度(财签二)                   */
faj582      number(5),               /*销账数量(财签二)                       */
faj592      number(20,6) DEFAULT '0' NOT NULL, /*销账成本(财签二)*/
faj602      number(20,6) DEFAULT '0' NOT NULL, /*销账累折(财签二)*/
faj922      varchar2(10)             /*序号                                   */
);

create        index faj_02 on faj_file (faj02,faj022);
alter table faj_file add  constraint faj_pk primary key  (faj01,faj02,faj022) enable validate;
grant select on faj_file to tiptopgp;
grant update on faj_file to tiptopgp;
grant delete on faj_file to tiptopgp;
grant insert on faj_file to tiptopgp;
grant index on faj_file to public;
grant select on faj_file to ods;
