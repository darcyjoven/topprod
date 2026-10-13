/*
================================================================================
檔案代號:imz_file
檔案名稱:料件分类基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table imz_file
(
imz01       varchar2(10) NOT NULL,   /*料件分群码                             */
                                     /*料件分群碼                             */
imz02       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
imz03       varchar2(20),            /*目录参考号码                           */
                                     /*目錄參考號碼                           */
                                     /*料件所屬的目錄編號                     */
imz04       varchar2(20),            /*工程图号                               */
                                     /*工程圖號                               */
                                     /*該料件所在的主要工程圖號               */
imz07       varchar2(1),             /*ABC码                                  */
                                     /*ABC碼                                  */
imz08       varchar2(1),             /*来源码                                 */
                                     /*來源碼                                 */
                                     /*C:規格組件                             */
                                     /*T:最後規格料件                         */
                                     /*D:特性料件                             */
                                     /*A:族群料件                             */
                                     /*M:自製料件                             */
                                     /*P:採購料件                             */
                                     /*X:虛擬料件                             */
                                     /*K:配件虛擬料件                         */
                                     /*U:自製大宗料件                         */
                                     /*V:採購大宗料件                         */
                                     /*R:在製途料件                           */
                                     /*Z:雜項料件                             */
                                     /*S:廠外加工料件                         */
imz09       varchar2(10),            /*其他分群码 一                          */
                                     /*其他分群碼 一                          */
                                     /*使用者自行定義                         */
imz10       varchar2(10),            /*其他分群码 二                          */
                                     /*其他分群碼 二                          */
                                     /*使用者自行定義                         */
imz11       varchar2(10),            /*其他分群码 三                          */
                                     /*其他分群碼 三                          */
                                     /*使用者自行定義                         */
imz12       varchar2(10),            /*其他分群码 四                          */
                                     /*其他分群碼 四                          */
                                     /*使用者自行定義                         */
imz14       varchar2(1),             /*是否为工程料件                         */
                                     /*是否為工程料件                         */
                                     /*正確值 'Y' 或 'N'                      */
                                     /*Y: 工程料件                            */
                                     /*N: 非工程料件                          */
imz15       varchar2(1),             /*保税与否                               */
                                     /*保稅與否                               */
                                     /*正確值 Y/N                             */
                                     /*Y: 保稅                                */
                                     /*N: 非保稅                              */
imz17       varchar2(4),             /*No Use                                 */
                                     /*銷售統計單位                           */
imz19       varchar2(4),             /*保税料件进出口分类统计用类             */
imz21       varchar2(20),            /*保税料件税则编号                       */
                                     /*保稅料件稅則編號                       */
imz23       varchar2(10),            /*仓管员                                 */
                                     /*倉管員                                 */
imz24       varchar2(1),             /*检验否                                 */
imz25       varchar2(4),             /*库存单位                               */
                                     /*庫存單位                               */
imz27       number(15,3),            /*安全库存量                             */
                                     /*安全庫存量                             */
imz28       number(15,3),            /*安全库存期间                           */
                                     /*安全庫存期間                           */
imz31       varchar2(4),             /*销售单位                               */
                                     /*銷售單位                               */
imz31_fac   number(20,8),            /*销售单位/库存单位换算率                */
                                     /*銷售單位/庫存單位換算率                */
imz34       varchar2(10),            /*成本中心                               */
imz35       varchar2(10),            /*主要仓库                               */
                                     /*主要倉庫別                             */
imz36       varchar2(10),            /*主要库位别                             */
                                     /*主要儲位別                             */
imz37       varchar2(1),             /*补货策略码                             */
                                     /*補貨策略碼                             */
                                     /*正確值 0/1/2/3/4/5                     */
                                     /*0: 再訂購點    Reorder point parts     */
                                     /*1: MRP         MRP parts               */
                                     /*2: MPS         MPS parts               */
                                     /*3: FAS         FAS parts               */
                                     /*4: 訂單式生產  On-order parts          */
                                     /*5: 期間採購    Fixed interval parts    */
imz38       number(15,3),            /*再补货点                               */
                                     /*再補貨點                               */
imz39       varchar2(24),            /*料件所属会计科目                       */
                                     /*料件所屬會計科目                       */
imz42       varchar2(1),             /*批号追踪方式                           */
                                     /*批號追蹤方式                           */
                                     /*正確值 0/1/2                           */
                                     /*0: 無                                  */
                                     /*1: 軟性                                */
                                     /*2: 硬性                                */
imz43       varchar2(100),           /*采购员                                 */
                                     /*採購員                                 */
imz44       varchar2(4),             /*采购单位                               */
                                     /*採購單位                               */
imz44_fac   number(20,8),            /*采购单位/库存单位换算率                */
                                     /*採購單位/庫存單位換算率                */
imz45       number(15,3),            /*采购单位倍量                           */
                                     /*採購單位倍量                           */
imz46       number(15,3),            /*最少采购数量                           */
                                     /*最少採購數量                           */
                                     /*採購此料件時, 最少需採購數量           */
imz47       number(9,4),             /*采购损耗率                             */
                                     /*採購損耗率                             */
imz48       number(15,3),            /*采购安全期                             */
                                     /*採購安全期                             */
imz49       number(15,3),            /*到厂前置期                             */
                                     /*到廠前置期                             */
imz491      number(15,3),            /*入库前置期                             */
                                     /*入庫前置期                             */
imz50       number(15,3),            /*请购安全期                             */
                                     /*請購安全期                             */
imz51       number(15,3),            /*经济订购量                             */
                                     /*經濟訂購量                             */
imz52       number(15,3),            /*平均订购量                             */
                                     /*平均訂購量                             */
imz54       varchar2(10),            /*主要供应厂商                           */
                                     /*主要供應廠商                           */
                                     /*需存在採購管理子系統中的供應廠商       */
imz55       varchar2(4),             /*生产单位                               */
                                     /*生產單位                               */
imz55_fac   number(20,8),            /*生产单位/库存单位换算率                */
                                     /*生產單位/庫存單位換算率                */
imz56       number(15,3),            /*生产单位倍量                           */
                                     /*生產單位倍量                           */
imz561      number(15,3),            /*最少生产数量                           */
                                     /*最少生產數量                           */
imz562      number(9,4),             /*生产损耗率                             */
                                     /*生產損耗率                             */
imz571      varchar2(40),            /*主工艺料件                             */
                                     /*主製程料件                             */
imz59       number(15,3),            /*固定前置时间                           */
                                     /*固定前置時間                           */
imz60       number(15,3),            /*变动前置时间                           */
                                     /*變動前置時間                           */
imz61       number(15,3),            /*QC 前置时间                            */
                                     /*QC 前置時間                            */
imz62       number(15,3),            /*累计前置时间                           */
                                     /*累計前置時間                           */
imz63       varchar2(4),             /*发料单位                               */
                                     /*發料單位                               */
imz63_fac   number(20,8),            /*发料单位/库存单位换算率                */
                                     /*發料單位/庫存單位換算率                */
imz64       number(15,3),            /*发料单位倍量                           */
                                     /*發料單位倍量                           */
imz641      number(15,3),            /*最少发料数量                           */
                                     /*最少發料數量                           */
imz65       number(15,3),            /*发料安全存量                           */
                                     /*發料安全存量                           */
imz66       number(15,3),            /*发料安全期                             */
                                     /*發料安全期                             */
imz67       varchar2(10),            /*计划员                                 */
                                     /*計劃員                                 */
imz68       number(15,3),            /*需求时距                               */
                                     /*需求時距                               */
imz69       number(15,3),            /*计划时距                               */
                                     /*計劃時距                               */
imz70       varchar2(1),             /*消耗料件                               */
                                     /*消秏料件                               */
                                     /*正確值 Y/N                             */
imz71       number(5),               /*储存有效天数                           */
                                     /*儲存有效天數                           */
imz86       varchar2(4),             /*成本单位                               */
                                     /*成本單位                               */
imz86_fac   number(20,8),            /*成本/库存单位换算                      */
                                     /*成本/庫存單位換算                      */
imz87       varchar2(10),            /*成本项目                               */
                                     /*成本項目                               */
imz871      number(9,4),             /*材料制造费用分摊率                     */
                                     /*材料製造費用分攤率                     */
imz872      varchar2(10),            /*材料制造费用成本项目                   */
                                     /*材料製造費用成本項目                   */
imz873      number(9,4),             /*人工制造费用分摊率                     */
                                     /*人工製造費用分攤率                     */
imz874      varchar2(10),            /*人工制造费用成本项目                   */
                                     /*人工製造費用成本項目                   */
imz88       number(15,3),            /*期间采购数量                           */
                                     /*期間採購數量                           */
imz89       number(5),               /*期间采购使用的期间                     */
                                     /*期間採購使用的期間(月)                 */
imz90       number(5),               /*期间采购使用的期间                     */
                                     /*期間採購使用的期間(日)                 */
imz94       varchar2(10),            /*预设制程编号(工单开立时预              */
                                     /*預設製程編號 (工單開立時預設之)  no:6843*/
imz99       number(15,3),            /*再补货量                               */
                                     /*再補貨量                               */
imz100      varchar2(1),             /*检验程度                               */
                                     /*檢驗程度                         no:6843*/
                                     /*N.正常檢驗 T.加嚴檢驗 R.減量檢驗       */
imz101      varchar2(1),             /*检验水准                               */
                                     /*檢驗水準                         no:6843*/
                                     /*1.一般    2.特殊                       */
imz102      varchar2(1),             /*级数                                   */
                                     /*級數                             no:6843*/
imz103      varchar2(1),             /*采购特性                               */
                                     /*採購特性                         no:6843*/
                                     /*分類此採購料件特性                     */
                                     /*'0':內購 '1':外購 '2':其它             */
imz105      varchar2(1),             /*是否为软体对象                         */
                                     /*是否為軟體物件                   no:6843*/
imz106      varchar2(1),             /*保税料件类型                           */
imz107      varchar2(1),             /*插件位置                               */
                                     /*Location of Insert   #No:6542              no:6843*/
                                     /*Y:  Auto Open Window to enter Ins.Loc  */
                                     /*N:Unauto Open window to enter Ins.Loc  */
imz108      varchar2(1),             /*工单发料前调拨否                       */
                                     /*Transfer Before Work Order Delivery? (Y/N)     no:6843*/
                                     /*  Y:Before Work Order Delivery it must be delivered to*/
                                     /*    WIP   warehouse(online warehouse) for supplement by*/
                                     /*    the way of transfer according to the batch quantity*/
                                     /*    and least purchase quantity and against the missing*/
                                     /*    quantity of WIP warehouse.Not considering the*/
                                     /*    quantity of the work order allotment and the work*/
                                     /*    order purchase.                    */
imz109      varchar2(10),            /*材料类型                               */
                                     /*材料類別                         no:6843*/
imz110      varchar2(1),             /*工单开立展开选项                       */
                                     /*工單開立展開選項                 no:6843*/
                                     /*1.不展開                               */
                                     /*2.不展開, 但自動開立工單               */
                                     /*3.展開                                 */
                                     /*4.開窗詢問是否展開                     */
imz130      varchar2(1),             /*产品销售特性                           */
                                     /*Product Sales Property                   #MOD-660068*/
                                     /*  0.NO product                         */
                                     /*  1.Normal                             */
                                     /*  2.MISC                               */
                                     /*  3.CSD                                */
imz131      varchar2(10),            /*产品分类编号                           */
                                     /*產品分類編號                     no:6843*/
imz132      varchar2(24),            /*费用科目编号                           */
                                     /*費用科目編號                     no:6843*/
imz133      varchar2(40),            /*产品预测料号                           */
                                     /*產品預測料號                     no:6843*/
imz134      varchar2(15),            /*主要包装方式编号                       */
                                     /*主要包裝方式編號                 no:6843*/
imz147      varchar2(1),             /*插件位置与QPA是否要勾稽                */
                                     /*插件位置與QPA是否要勾稽 #NO:6542       */
imz148      number(5),               /*保证期                                 */
                                     /*保證期(天)              #NO:7181(養生) */
imz903      varchar2(1),             /*可否做联产品入库                       */
                                     /*可否做聯產品入庫#NO:6872               */
imzacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
imzuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
imzgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
imzmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
imzdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
imz906      varchar2(1),             /*单位使用方式1.单一单位2.母子           */
imz907      varchar2(4),             /*第二单位(母单位/参考单位)              */
imz908      varchar2(4),             /*计价单位                               */
imz909      number(5),               /*MRP汇总时距(天)(预留字段)              */
imz911      varchar2(1),             /*是否为重覆性生产料件 (Y/N)             */
imz136      varchar2(10),            /*主要WIP 仓库                           */
imz137      varchar2(10),            /*主要WIP 库位                           */
imz391      varchar2(24),            /*会计科目二                             */
imz1321     varchar2(24),            /*费用科目二                             */
imz72       varchar2(1) DEFAULT '0' NOT NULL, /*是否需做供应商的控制*/
imz150      varchar2(1) DEFAULT ' ' NOT NULL, /*收货替代方式*/
imz152      varchar2(1) DEFAULT ' ' NOT NULL, /*PO对Blanket PO替代方式*/
imzud01     varchar2(255),           /*自订字段-Textedit                      */
imzud02     varchar2(40),            /*自订字段-文字                          */
imzud03     varchar2(40),            /*自订字段-文字                          */
imzud04     varchar2(40),            /*自订字段-文字                          */
imzud05     varchar2(40),            /*自订字段-文字                          */
imzud06     varchar2(40),            /*自订字段-文字                          */
imzud07     number(15,3),            /*自订字段-数值                          */
imzud08     number(15,3),            /*自订字段-数值                          */
imzud09     number(15,3),            /*自订字段-数值                          */
imzud10     number(10),              /*自订字段-整数                          */
imzud11     number(10),              /*自订字段-整数                          */
imzud12     number(10),              /*自订字段-整数                          */
imzud13     date,                    /*自订字段-日期                          */
imzud14     date,                    /*自订字段-日期                          */
imzud15     date,                    /*自订字段-日期                          */
imz601      number(15,3),            /*变动前置时间批量                       */
imz153      number(9,4),             /*工单完工误差率                         */
imz926      varchar2(1) DEFAULT ' ' NOT NULL, /*AVL否*/
imz73       varchar2(24),            /*代销科目                               */
imz731      varchar2(24),            /*代销科目二                             */
imzicd01    varchar2(40),            /*母体料号                               */
imzicd02    varchar2(40),            /*外编母体                               */
imzicd03    varchar2(40),            /*外编子体                               */
imzicd04    varchar2(1),             /*料件状态                               */
imzicd05    varchar2(1),             /*料件特性                               */
imzicd06    varchar2(40),            /*内编子体                               */
imzicd07    varchar2(40),            /*RoHs                                   */
imzicd08    varchar2(1),             /*刻号/BIN管理                           */
imzicd09    varchar2(1),             /*Date Code 否                           */
imzicd10    varchar2(10),            /*作业群组                               */
imzicd12    number(9,4),             /*备品比率                               */
imzicd79    varchar2(80),            /*ICD 群组                               */
imzoriu     varchar2(10),            /*资料建立者                             */
imzorig     varchar2(10),            /*资料建立部门                           */
imz918      varchar2(1),             /*制造批号管理否                         */
imz919      varchar2(1),             /*制造批号自动编码否                     */
imz920      varchar2(10),            /*制造批号编码规则                       */
imz921      varchar2(1),             /*序号管理否                             */
imz922      varchar2(1),             /*序号自动编码否                         */
imz923      varchar2(10),            /*序号编码原则                           */
imz924      varchar2(1),             /*序号唯一否                             */
imz925      varchar2(1),             /*排序方式                               */
imzicd13    varchar2(1),             /*批号管控否                             */
imz156      varchar2(1) DEFAULT ' ' NOT NULL, /*号机自动编号否*/
imz157      varchar2(10) DEFAULT ' ',/*号机编码原则                           */
imz158      varchar2(1) DEFAULT ' ' NOT NULL, /*号机库存管理*/
imzicd14    number(15,3) DEFAULT '0' NOT NULL, /*GROSS DIE*/
imzicd15    number(9,4) DEFAULT '0' NOT NULL, /*良率%*/
imzicd16    varchar2(40),            /*WAFER型号                              */
imz022      number(15,3) DEFAULT '0' NOT NULL, /*量化规格*/
imz251      varchar2(4),             /*量化單位                               */
imz159      varchar2(1) DEFAULT ' ' NOT NULL, /*批号控管方式*/
imz928      varchar2(1) DEFAULT ' ' NOT NULL, /*特性主料*/
imz929      varchar2(40),            /*特性主料编号                           */
imzicd17    varchar2(1) DEFAULT '3' NOT NULL, /*IC类型*/
imzicd18    varchar2(6),             /*Pkg Type                               */
imzicd19    varchar2(10),            /*Pin Count                              */
imzicd20    varchar2(20),            /*B/d No                                 */
imzicd21    varchar2(10),            /*B/d Ver                                */
imz163      varchar2(24),            /*发出商品科目                           */
imz1631     varchar2(24)             /*发出商品科目二                         */
);

alter table imz_file add  constraint imz_pk primary key  (imz01) enable validate;
grant select on imz_file to tiptopgp;
grant update on imz_file to tiptopgp;
grant delete on imz_file to tiptopgp;
grant insert on imz_file to tiptopgp;
grant index on imz_file to public;
grant select on imz_file to ods;
