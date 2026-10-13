/*
================================================================================
檔案代號:fak_file
檔案名稱:固定资产底稿资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fak_file
(
fak00       varchar2(8),             /*生成批号                               */
fak01       varchar2(10) NOT NULL,   /*序号                                   */
fak02       varchar2(10) NOT NULL,   /*财产编号                               */
fak021      varchar2(1),             /*类型                                   */
fak022      varchar2(4) NOT NULL,    /*附号                                   */
fak03       varchar2(1),             /*取得方式                               */
fak04       varchar2(10),            /*资产类型                               */
fak05       varchar2(10),            /*资产次类型                             */
fak06       varchar2(80),            /*中文名称-1                             */
fak061      varchar2(80),            /*中文名称-2                             */
fak07       varchar2(80),            /*英文名称-1                             */
fak071      varchar2(80),            /*英文名称-2                             */
fak08       varchar2(30),            /*规格型号                               */
fak09       varchar2(1),             /*资产性质                               */
fak10       varchar2(10),            /*供应商编号                             */
fak11       varchar2(10),            /*制造厂商编号                           */
fak12       varchar2(10),            /*原产地                                 */
fak13       number(20,6),            /*本币单价                               */
fak14       number(20,6),            /*本币成本                               */
fak141      number(20,6),            /*调整成本                               */
fak15       varchar2(4),             /*原币币种                               */
fak16       number(20,6),            /*原币成本                               */
fak17       number(5),               /*数量                                   */
fak171      number(5),               /*在外数量(外送)                         */
fak18       varchar2(4),             /*计量单位                               */
fak19       varchar2(10),            /*保管人                                 */
fak20       varchar2(10),            /*保管部门                               */
fak21       varchar2(10),            /*存放位置                               */
fak22       varchar2(10),            /*存放营运中心                           */
fak23       varchar2(1),             /*分摊方式                               */
fak24       varchar2(10),            /*分摊部门/分摊类型                      */
fak25       date,                    /*取得日期                               */
fak26       date,                    /*入帐日期                               */
fak27       varchar2(6),             /*开始计提折旧年月                       */
fak28       varchar2(1),             /*折旧方法                               */
fak29       number(5),               /*耐用年限(月数)                         */
fak30       number(5),               /*未使用年限(月数)                       */
fak31       number(20,6),            /*预留残值                               */
fak32       number(20,6),            /*累积折旧                               */
fak33       number(20,6),            /*未折减额额                             */
fak34       varchar2(1),             /*折毕再提否                             */
fak35       number(20,6),            /*再提金额                               */
fak36       number(5),               /*折毕再提年限                           */
fak37       varchar2(1),             /*是否直接资本化                         */
fak38       varchar2(1),             /*保税否                                 */
fak39       varchar2(1),             /*保险否                                 */
fak40       varchar2(1),             /*免税否                                 */
fak41       varchar2(1),             /*抵押否                                 */
fak42       varchar2(1),             /*投资抵减否                             */
fak421      number(5),               /*本币投资抵减比率                       */
fak422      number(5),               /*外币投资抵减比率                       */
fak423      number(5),               /*投资抵减补税年限                       */
fak43       varchar2(1),             /*资产状态                               */
fak44       varchar2(10),            /*进货营运中心                           */
fak45       varchar2(20),            /*帐款编号                               */
fak451      number(5),               /*帐款编号项次                           */
fak46       varchar2(20),            /*收料单号                               */
fak461      number(5),               /*收料单项次                             */
fak462      date,                    /*收料日期                               */
fak47       varchar2(20),            /*采购单                                 */
fak471      number(5),               /*采购单项次                             */
fak48       varchar2(30),            /*进口报单                               */
fak49       varchar2(10),            /*进口编号                               */
fak50       varchar2(15),            /*预算编号                               */
fak51       varchar2(20),            /*发票号码                               */
fak511      date,                    /*发票日期                               */
fak52       varchar2(20),            /*凭证号码                               */
fak53       varchar2(24),            /*资产科目                               */
fak54       varchar2(24),            /*累折科目                               */
fak55       varchar2(24),            /*折旧科目                               */
fak56       varchar2(80),            /*用途                                   */
fak57       number(5),               /*最近折旧年度                           */
fak571      number(5),               /*最近折旧期别                           */
fak58       number(5),               /*销帐数量                               */
fak59       number(20,6),            /*销帐成本                               */
fak60       number(20,6),            /*销帐累折                               */
fak61       varchar2(1),             /*税签折旧方法                           */
fak62       number(20,6),            /*税签成本                               */
fak63       number(20,6),            /*税签调整成本                           */
fak64       number(5),               /*税签耐用年限                           */
fak65       number(5),               /*税签未用年限(月数)                     */
fak66       number(20,6),            /*税签预留残值                           */
fak67       number(20,6),            /*税签累积折旧                           */
fak68       number(20,6),            /*税签未折减额                           */
fak69       number(20,6),            /*税签销帐成本                           */
fak70       number(20,6),            /*税签销帐累折                           */
fak71       varchar2(1),             /*税签折毕再提否                         */
fak72       number(20,6),            /*税签再提金额                           */
fak73       number(5),               /*税签折毕再提年限                       */
fak74       number(5),               /*最近税签折旧年月                       */
fak90       varchar2(10),            /*群组号码                               */
fak901      varchar2(4),             /*群组附号                               */
fak91       varchar2(1),             /*更新码                                 */
fak92       varchar2(1),             /*利息资本化否                           */
fak207      varchar2(1),             /*资产列管/列帐                          */
fakuser     varchar2(10),            /*资料所有者                             */
fakgrup     varchar2(10),            /*资料所有部门                           */
fakmodu     varchar2(10),            /*资料更改者                             */
fakdate     date,                    /*最近更改日                             */
fak531      varchar2(24),            /*资产科目二                             */
fak541      varchar2(24),            /*累折科目二                             */
fak551      varchar2(24),            /*折旧科目二                             */
fakud01     varchar2(255),           /*自订字段-Textedit                      */
fakud02     varchar2(40),            /*自订字段-文字                          */
fakud03     varchar2(40),            /*自订字段-文字                          */
fakud04     varchar2(40),            /*自订字段-文字                          */
fakud05     varchar2(40),            /*自订字段-文字                          */
fakud06     varchar2(40),            /*自订字段-文字                          */
fakud07     number(15,3),            /*自订字段-数值                          */
fakud08     number(15,3),            /*自订字段-数值                          */
fakud09     number(15,3),            /*自订字段-数值                          */
fakud10     number(10),              /*自订字段-整数                          */
fakud11     number(10),              /*自订字段-整数                          */
fakud12     number(10),              /*自订字段-整数                          */
fakud13     date,                    /*自订字段-日期                          */
fakud14     date,                    /*自订字段-日期                          */
fakud15     date,                    /*自订字段-日期                          */
fakoriu     varchar2(10),            /*资料建立者                             */
fakorig     varchar2(10),            /*资料建立部门                           */
fak93       varchar2(10),            /*族群编号                               */
fak1412     number(20,6) DEFAULT '0' NOT NULL, /*调整成本(财签二)*/
fak142      number(20,6) DEFAULT '0' NOT NULL, /*取得成本(财签二)*/
fak143      varchar2(4),             /*币别(财签二)                           */
fak144      number(20,10),           /*取得汇率(财签二)                       */
fak232      varchar2(1) DEFAULT ' ' NOT NULL, /*分摊方式(财签二)*/
fak242      varchar2(10),            /*分摊部门/分摊类型(财签二)              */
fak262      date,                    /*入账日期(财签二)                       */
fak272      varchar2(6),             /*开始计提折旧年月(财签二)               */
fak282      varchar2(1) DEFAULT ' ' NOT NULL, /*折旧方法(财签二)*/
fak292      number(5),               /*耐用年限(月数)(财签二)                 */
fak302      number(5),               /*未使用年限(月数)(财签二)               */
fak312      number(20,6) DEFAULT '0' NOT NULL, /*预留残值(财签二)*/
fak322      number(20,6) DEFAULT '0' NOT NULL, /*累积折旧(财签二)*/
fak332      number(20,6) DEFAULT '0' NOT NULL, /*未折减额额(财签二)*/
fak342      varchar2(1) DEFAULT ' ' NOT NULL, /*折毕再提否(财签二)*/
fak352      number(20,6) DEFAULT '0' NOT NULL, /*再提金额(财签二)*/
fak362      number(5),               /*折毕再提年限(财签二)                   */
fak5712     number(5),               /*最近折旧期别(财签二)                   */
fak572      number(5)                /*最近折旧年度(财签二)                   */
);

create        index fak_02 on fak_file (fak02,fak022);
alter table fak_file add  constraint fak_pk primary key  (fak01,fak02,fak022) enable validate;
grant select on fak_file to tiptopgp;
grant update on fak_file to tiptopgp;
grant delete on fak_file to tiptopgp;
grant insert on fak_file to tiptopgp;
grant index on fak_file to public;
grant select on fak_file to ods;
