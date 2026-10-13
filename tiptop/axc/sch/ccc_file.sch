/*
================================================================================
檔案代號:ccc_file
檔案名稱:库存月加权成本资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ccc_file
(
ccc01       varchar2(40) NOT NULL,   /*料号                                   */
                                     /*料號                                   */
ccc02       number(5) NOT NULL,      /*年度                                   */
ccc03       number(5) NOT NULL,      /*月份                                   */
ccc04       number(5),               /*成本阶数                               */
                                     /*成本階數                               */
                                     /*char(02) -> smallint            No.7269*/
ccc05       number(5),               /*No Use                                 */
ccc06       number(5),               /*No Use                                 */
ccc11       number(15,3) NOT NULL,   /*上月结存数量                           */
                                     /*上月結存數量                           */
ccc12       number(20,6) NOT NULL,   /*上月结存金额(a+b+c+d+e)                */
                                     /*上月結存金額(a+b+c+d+e)                */
ccc12a      number(20,6) NOT NULL,   /*上月结存金额-材料   (a)                */
                                     /*上月結存金額-材料   (a)                */
ccc12b      number(20,6) NOT NULL,   /*上月结存金额-人工   (b)                */
                                     /*上月結存金額-人工   (b)                */
ccc12c      number(20,6) NOT NULL,   /*上月结存金额-制费   (c)                */
                                     /*上月結存金額-製費   (c)                */
ccc12d      number(20,6) NOT NULL,   /*上月结存金额-加工   (d)                */
                                     /*上月結存金額-加工   (d)                */
ccc12e      number(20,6) NOT NULL,   /*上月结存金额-其他   (e)                */
                                     /*上月結存金額-其他   (e)                */
ccc21       number(15,3) NOT NULL,   /*本月入库数量                           */
                                     /*本月入庫數量(採購入庫+自製入庫+委外入庫)*/
ccc22       number(20,6) NOT NULL,   /*本月入库金额(a+b+c+d+e)                */
                                     /*本月入庫金額(a+b+c+d+e)                */
ccc22a      number(20,6) NOT NULL,   /*本月入库金额-材料   (a)                */
                                     /*本月入庫金額-材料   (a)                */
ccc22b      number(20,6) NOT NULL,   /*本月入库金额-人工   (b)                */
                                     /*本月入庫金額-人工   (b)                */
ccc22c      number(20,6) NOT NULL,   /*本月入库金额-制费   (c)                */
                                     /*本月入庫金額-製費   (c)                */
ccc22d      number(20,6) NOT NULL,   /*本月入库金额-加工   (d)                */
                                     /*本月入庫金額-加工   (d)                */
ccc22e      number(20,6) NOT NULL,   /*本月入库金额-其他   (e)                */
                                     /*本月入庫金額-其他   (e)                */
ccc23       number(20,6) NOT NULL,   /*本月平均单价(a+b+c+d+e)                */
                                     /*本月平均單價(a+b+c+d+e)                */
ccc23a      number(20,6) NOT NULL,   /*本月平均单价-材料   (a)                */
                                     /*本月平均單價-材料   (a)                */
ccc23b      number(20,6) NOT NULL,   /*本月平均单价-人工   (b)                */
                                     /*本月平均單價-人工   (b)                */
ccc23c      number(20,6) NOT NULL,   /*本月平均单价-制费   (c)                */
                                     /*本月平均單價-製費   (c)                */
ccc23d      number(20,6) NOT NULL,   /*本月平均单价-加工   (d)                */
                                     /*本月平均單價-加工   (d)                */
ccc23e      number(20,6) NOT NULL,   /*本月平均单价-其他   (e)                */
                                     /*本月平均單價-其他   (e)                */
ccc25       number(15,3) NOT NULL,   /*本月返工领出数量                       */
                                     /*本月重工領出數量 (負值表示領出)        */
ccc26       number(20,6) NOT NULL,   /*本月返工领出金额(a+b+c+d+e)            */
                                     /*本月重工領出金額(a+b+c+d+e)            */
ccc26a      number(20,6) NOT NULL,   /*本月返工领出金额-材料   (a)            */
                                     /*本月重工領出金額-材料   (a)            */
ccc26b      number(20,6) NOT NULL,   /*本月返工领出金额-人工   (b)            */
                                     /*本月重工領出金額-人工   (b)            */
ccc26c      number(20,6) NOT NULL,   /*本月返工领出金额-制费   (c)            */
                                     /*本月重工領出金額-製費   (c)            */
ccc26d      number(20,6) NOT NULL,   /*本月返工领出金额-加工   (d)            */
                                     /*本月重工領出金額-加工   (d)            */
ccc26e      number(20,6) NOT NULL,   /*本月返工领出金额-其他   (e)            */
                                     /*本月重工領出金額-其他   (e)            */
ccc27       number(15,3) NOT NULL,   /*本月返工入库数量                       */
                                     /*本月重工入庫數量                       */
ccc28       number(20,6) NOT NULL,   /*本月返工入库金额(a+b+c+d+e)            */
                                     /*本月重工入庫金額(a+b+c+d+e)            */
ccc28a      number(20,6) NOT NULL,   /*本月返工入库金额-材料   (a)            */
                                     /*本月重工入庫金額-材料   (a)            */
ccc28b      number(20,6) NOT NULL,   /*本月返工入库金额-人工   (b)            */
                                     /*本月重工入庫金額-人工   (b)            */
ccc28c      number(20,6) NOT NULL,   /*本月返工入库金额-制费   (c)            */
                                     /*本月重工入庫金額-製費   (c)            */
ccc28d      number(20,6) NOT NULL,   /*本月返工入库金额-加工   (d)            */
                                     /*本月重工入庫金額-加工   (d)            */
ccc28e      number(20,6) NOT NULL,   /*本月返工入库金额-其他   (e)            */
                                     /*本月重工入庫金額-其他   (e)            */
ccc31       number(15,3) NOT NULL,   /*本月工单领用数量                       */
                                     /*本月工單領用數量 (負值表示領用)        */
ccc32       number(20,6) NOT NULL,   /*本月工单领用成本                       */
                                     /*本月工單領用成本                       */
ccc41       number(15,3) NOT NULL,   /*本月杂项领用数量 (负值表示             */
                                     /*本月雜項領用數量 (負值表示領用)        */
ccc42       number(20,6) NOT NULL,   /*本月杂项领用成本                       */
                                     /*本月雜項領用成本                       */
ccc43       number(15,3),            /*本月杂项入库数量                       */
                                     /*本月雜項入庫數量                       */
ccc44       number(20,6),            /*本月杂项入库成本                       */
                                     /*本月雜項入庫成本                       */
ccc51       number(15,3) NOT NULL,   /*本月其他调整数量                       */
                                     /*本月其他調整數量 (負值表示庫存減少)    */
ccc52       number(20,6) NOT NULL,   /*本月其他调整成本                       */
                                     /*本月其他調整成本                       */
ccc61       number(15,3) NOT NULL,   /*本月销货数量                           */
                                     /*本月銷貨數量     (負值表示銷貨)        */
ccc62       number(20,6) NOT NULL,   /*本月销货成本                           */
                                     /*本月銷貨成本                           */
ccc62a      number(20,6),            /*本月销货成本-材料   (a)                */
                                     /*本月銷貨成本-材料   (a)                */
ccc62b      number(20,6),            /*本月销货成本-人工   (b)                */
                                     /*本月銷貨成本-人工   (b)                */
ccc62c      number(20,6),            /*本月销货成本-制费   (c)                */
                                     /*本月銷貨成本-製費   (c)                */
ccc62d      number(20,6),            /*本月销货成本-加工   (d)                */
                                     /*本月銷貨成本-加工   (d)                */
ccc62e      number(20,6),            /*本月销货成本-其他   (e)                */
                                     /*本月銷貨成本-其他   (e)                */
ccc63       number(20,6) NOT NULL,   /*本月销货收入                           */
                                     /*本月銷貨收入                           */
ccc64       number(15,3),            /*本月销退数量                           */
                                     /*本月銷退數量                           */
ccc65       number(20,6),            /*本月销退金额                           */
                                     /*本月銷退金額                           */
ccc66       number(20,6),            /*本月销退成本                           */
                                     /*本月銷退成本                           */
ccc66a      number(20,6),            /*本月销退成本-材料   (a)                */
                                     /*本月銷退成本-材料   (a)                */
ccc66b      number(20,6),            /*本月销退成本-人工   (b)                */
                                     /*本月銷退成本-人工   (b)                */
ccc66c      number(20,6),            /*本月销退成本-制费   (c)                */
                                     /*本月銷退成本-製費   (c)                */
ccc66d      number(20,6),            /*本月销退成本-加工   (d)                */
                                     /*本月銷退成本-加工   (d)                */
ccc66e      number(20,6),            /*本月销退成本-其他   (e)                */
                                     /*本月銷退成本-其他   (e)                */
ccc71       number(15,3) NOT NULL,   /*本月盘盈亏数量                         */
                                     /*本月盤盈虧數量                         */
ccc72       number(20,6) NOT NULL,   /*本月盘盈亏金额                         */
                                     /*本月盤盈虧金額                         */
ccc91       number(15,3) NOT NULL,   /*本月结存数量                           */
                                     /*本月結存數量                           */
ccc92       number(20,6) NOT NULL,   /*本月结存金额(a+b+c+d+e)                */
                                     /*本月結存金額(a+b+c+d+e)                */
ccc92a      number(20,6) NOT NULL,   /*本月结存金额-材料   (a)                */
                                     /*本月結存金額-材料   (a)                */
ccc92b      number(20,6) NOT NULL,   /*本月结存金额-人工   (b)                */
                                     /*本月結存金額-人工   (b)                */
ccc92c      number(20,6) NOT NULL,   /*本月结存金额-制费   (c)                */
                                     /*本月結存金額-製費   (c)                */
ccc92d      number(20,6) NOT NULL,   /*本月结存金额-加工   (d)                */
                                     /*本月結存金額-加工   (d)                */
ccc92e      number(20,6) NOT NULL,   /*本月结存金额-其他   (e)                */
                                     /*本月結存金額-其他   (e)                */
ccc93       number(20,6) NOT NULL,   /*本月结存调整金额                       */
                                     /*本月結存調整金額                       */
ccc93a      number(20,6),            /*本月结存调整-材料   (a)                */
                                     /*本月結存調整-材料   (a)                */
ccc93b      number(20,6),            /*本月结存调整-人工   (b)                */
                                     /*本月結存調整-人工   (b)                */
ccc93c      number(20,6),            /*本月结存调整-制费   (c)                */
                                     /*本月結存調整-製費   (c)                */
ccc93d      number(20,6),            /*本月结存调整-加工   (d)                */
                                     /*本月結存調整-加工   (d)                */
ccc93e      number(20,6),            /*本月结存调整-其他   (e)                */
                                     /*本月結存調整-其他   (e)                */
cccuser     varchar2(10),            /*最近计算人员                           */
                                     /*最近計算人員                           */
cccdate     date,                    /*最近计算日期                           */
                                     /*最近計算日期                           */
ccctime     varchar2(5),             /*最近计算时间                           */
                                     /*最近計算時間                           */
ccc211      number(15,3),            /*采购入库数                             */
ccc212      number(15,3),            /*委外入库数                             */
ccc213      number(15,3),            /*工单入库数                             */
ccc214      number(15,3),            /*杂项入库数                             */
ccc215      number(15,3),            /*调整入库数                             */
ccc221      number(20,6),            /*采购入库金额                           */
ccc222      number(20,6),            /*委外入库金额                           */
ccc223      number(20,6),            /*工单入库金额                           */
ccc224      number(20,6),            /*杂项入库金额                           */
ccc225      number(20,6),            /*调整入库金额                           */
ccc22a1     number(20,6),            /*采购入库金额材料                       */
ccc22a2     number(20,6),            /*委外入库金额材料                       */
ccc22a3     number(20,6),            /*工单入库金额材料                       */
ccc22a4     number(20,6),            /*杂项入库金额材料                       */
ccc22a5     number(20,6),            /*调整入库金额材料                       */
ccc22b1     number(20,6),            /*采购入库金额人工                       */
ccc22b2     number(20,6),            /*委外入库金额人工                       */
ccc22b3     number(20,6),            /*工单入库金额人工                       */
ccc22b4     number(20,6),            /*杂项入库金额人工                       */
ccc22b5     number(20,6),            /*调整入库金额人工                       */
ccc22c1     number(20,6),            /*采购入库金额制费                       */
ccc22c2     number(20,6),            /*委外入库金额制费                       */
ccc22c3     number(20,6),            /*工单入库金额制费                       */
ccc22c4     number(20,6),            /*杂项入库金额制费                       */
ccc22c5     number(20,6),            /*调整入库金额制费                       */
ccc22d1     number(20,6),            /*采购入库金额加工                       */
ccc22d2     number(20,6),            /*委外入库金额加工                       */
ccc22d3     number(20,6),            /*工单入库金额加工                       */
ccc22d4     number(20,6),            /*杂项入库金额加工                       */
ccc22d5     number(20,6),            /*调整入库金额加工                       */
ccc22e1     number(20,6),            /*采购入库金额其它                       */
ccc22e2     number(20,6),            /*委外入库金额其它                       */
ccc22e3     number(20,6),            /*工单入库金额其它                       */
ccc22e4     number(20,6),            /*杂项入库金额其它                       */
ccc22e5     number(20,6),            /*调整入库金额其它                       */
ccc81       number(15,3),            /*本月订单数量                           */
ccc82       number(20,6),            /*本月订单成本                           */
ccc82a      number(20,6),            /*本月订单成本-材料                      */
ccc82b      number(20,6),            /*本月订单成本-人工                      */
ccc82c      number(20,6),            /*本月订单成本-制费                      */
ccc82d      number(20,6),            /*本月订单成本-加工                      */
ccc82e      number(20,6),            /*本月订单成本-其他                      */
ccc07       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
ccc08       varchar2(40) DEFAULT ' ' NOT NULL, /*类别代号(批次号/专案号/利润 */
ccc12f      number(20,6) DEFAULT '0',/*上月结存金额-制费三 (f)                */
ccc12g      number(20,6) DEFAULT '0',/*上月结存金额-制费四 (g)                */
ccc12h      number(20,6) DEFAULT '0',/*上月结存金额-制费五 (h)                */
ccc22f      number(20,6) DEFAULT '0',/*本月入库金额-制费三  (f)               */
ccc22f1     number(20,6) DEFAULT '0',/*采购入库金额-制费三                    */
ccc22f2     number(20,6) DEFAULT '0',/*委外入库金额-制费三                    */
ccc22f3     number(20,6) DEFAULT '0',/*工单入库金额-制费三                    */
ccc22f4     number(20,6) DEFAULT '0',/*杂项入库金额-制费三                    */
ccc22f5     number(20,6) DEFAULT '0',/*调整入库金额-制费三                    */
ccc22g      number(20,6) DEFAULT '0',/*本月入库金额-制费四  (g)               */
ccc22g1     number(20,6) DEFAULT '0',/*采购入库金额-制费四                    */
ccc22g2     number(20,6) DEFAULT '0',/*委外入库金额-制费四                    */
ccc22g3     number(20,6) DEFAULT '0',/*工单入库金额-制费四                    */
ccc22g4     number(20,6) DEFAULT '0',/*杂项入库金额-制费四                    */
ccc22g5     number(20,6) DEFAULT '0',/*调整入库金额-制费四                    */
ccc22h      number(20,6) DEFAULT '0',/*本月入库金额-制费五  (h)               */
ccc22h1     number(20,6) DEFAULT '0',/*采购入库金额-制费五                    */
ccc22h2     number(20,6) DEFAULT '0',/*委外入库金额-制费五                    */
ccc22h3     number(20,6) DEFAULT '0',/*工单入库金额-制费五                    */
ccc22h4     number(20,6) DEFAULT '0',/*杂项入库金额-制费五                    */
ccc22h5     number(20,6) DEFAULT '0',/*调整入库金额-制费五                    */
ccc23f      number(20,6) DEFAULT '0',/*本月平均单价-制费三   (f)              */
ccc23g      number(20,6) DEFAULT '0',/*本月平均单价-制费四   (g)              */
ccc23h      number(20,6) DEFAULT '0',/*本月平均单价-制费五   (h)              */
ccc26f      number(20,6) DEFAULT '0',/*本月返工领出金额-制费三  (f)           */
ccc26g      number(20,6) DEFAULT '0',/*本月返工领出金额-制费四  (g)           */
ccc26h      number(20,6) DEFAULT '0',/*本月返工领出金额-制费五  (h)           */
ccc28f      number(20,6) DEFAULT '0',/*本月返工入库金额-制费三   (f)          */
ccc28g      number(20,6) DEFAULT '0',/*本月返工入库金额-制费四   (g)          */
ccc28h      number(20,6) DEFAULT '0',/*本月返工入库金额-制费五   (h)          */
ccc62f      number(20,6) DEFAULT '0',/*本月销货成本-制费三                    */
ccc62g      number(20,6) DEFAULT '0',/*本月销货成本-制费四                    */
ccc62h      number(20,6) DEFAULT '0',/*本月销货成本-制费五                    */
ccc66f      number(20,6) DEFAULT '0',/*本月销退成本-制费三                    */
ccc66g      number(20,6) DEFAULT '0',/*本月销退成本-制费四                    */
ccc66h      number(20,6) DEFAULT '0',/*本月销退成本-制费五                    */
ccc82f      number(20,6) DEFAULT '0',/*本月订单成本-制费三                    */
ccc82g      number(20,6) DEFAULT '0',/*本月订单成本-制费四                    */
ccc82h      number(20,6) DEFAULT '0',/*本月订单成本-制费五                    */
ccc92f      number(20,6) DEFAULT '0',/*本月结存金额-制费三   (f)              */
ccc92g      number(20,6) DEFAULT '0',/*本月结存金额-制费四   (g)              */
ccc92h      number(20,6) DEFAULT '0',/*本月结存金额-制费五   (h)              */
ccc93f      number(20,6) DEFAULT '0',/*本月结存调整金额-制费三                */
ccc93g      number(20,6) DEFAULT '0',/*本月结存调整金额-制费四                */
ccc93h      number(20,6) DEFAULT '0',/*本月结存调整金额-制费五                */
cccud01     varchar2(255),           /*自订字段-Textedit                      */
cccud02     varchar2(40),            /*自订字段-文字                          */
cccud03     varchar2(40),            /*自订字段-文字                          */
cccud04     varchar2(40),            /*自订字段-文字                          */
cccud05     varchar2(40),            /*自订字段-文字                          */
cccud06     varchar2(40),            /*自订字段-文字                          */
cccud07     number(15,3),            /*自订字段-数值                          */
cccud08     number(15,3),            /*自订字段-数值                          */
cccud09     number(15,3),            /*自订字段-数值                          */
cccud10     number(10),              /*自订字段-整数                          */
cccud11     number(10),              /*自订字段-整数                          */
cccud12     number(10),              /*自订字段-整数                          */
cccud13     date,                    /*自订字段-日期                          */
cccud14     date,                    /*自订字段-日期                          */
cccud15     date,                    /*自订字段-日期                          */
cccorig     varchar2(10),            /*资料建立部门                           */
cccoriu     varchar2(10),            /*资料建立者                             */
ccc216      number(15,3),            /*销退入库数                             */
ccc226      number(20,6),            /*销退入库金额                           */
ccc22a6     number(20,6),            /*销退入库金额材料                       */
ccc22b6     number(20,6),            /*销退入库金额人工                       */
ccc22c6     number(20,6),            /*销退入库金额-制费一                    */
ccc22d6     number(20,6),            /*銷退入庫金額加工                       */
ccc22e6     number(20,6),            /*销退入库金额-制费二                    */
ccc22f6     number(20,6),            /*销退入库金额-制费三                    */
ccc22g6     number(20,6),            /*销退入库金额-制费四                    */
ccc22h6     number(20,6),            /*销退入库金额-制费五                    */
ccclegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table ccc_file add  constraint ccc_pk primary key  (ccc01,ccc02,ccc03,ccc07,ccc08) enable validate;
grant select on ccc_file to tiptopgp;
grant update on ccc_file to tiptopgp;
grant delete on ccc_file to tiptopgp;
grant insert on ccc_file to tiptopgp;
grant index on ccc_file to public;
grant select on ccc_file to ods;
