/*
================================================================================
檔案代號:oeb_file
檔案名稱:订单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oeb_file
(
oeb01       varchar2(20) NOT NULL,   /*订单单号                               */
                                     /*訂單單號 oea01                         */
oeb03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
oeb04       varchar2(40),            /*产品编号                               */
                                     /*產品編號 ima01                         */
oeb05       varchar2(4),             /*销售单位                               */
                                     /*銷售單位 ima31                         */
oeb05_fac   number(20,8) NOT NULL,   /*销售/库存单位换算率                    */
                                     /*銷售/庫存單位換算率 (To ima25)         */
oeb06       varchar2(120),           /*品名规格                               */
                                     /*品名規格                               */
oeb07       varchar2(10),            /*额外品名编号                           */
                                     /*額外品名編號 imc02,imc01=oeb04         */
oeb08       varchar2(10),            /*出货营运中心                           */
                                     /*Delivery Plant azp01                   */
oeb09       varchar2(10),            /*出货仓库                               */
                                     /*出貨倉庫 imd01(img02)                  */
oeb091      varchar2(10),            /*出货库位                               */
                                     /*出貨儲位 ime01(img03)                  */
oeb092      varchar2(24),            /*出货批号                               */
                                     /*出貨批號       img04  No.+024          */
oeb11       varchar2(40),            /*客户产品编号                           */
                                     /*客戶產品編號 obk03,obk01=oeb04,obk02=oea*/
oeb12       number(15,3) NOT NULL,   /*数量                                   */
                                     /*數量                                   */
oeb13       number(20,6) NOT NULL,   /*单价                                   */
                                     /*單價                                   */
oeb14       number(20,6) NOT NULL,   /*税前金额                               */
                                     /*未稅金額                               */
oeb14t      number(20,6) NOT NULL,   /*含税金额                               */
                                     /*含稅金額                               */
oeb15       date,                    /*约定交货日                             */
                                     /*約定交貨日                             */
oeb16       date,                    /*排定交货日                             */
                                     /*排定交貨日                             */
oeb17       number(20,6),            /*取出单价                               */
                                     /*取出單價(紀錄第一次輸入的單價) no.7150 */
oeb18       varchar2(10),            /*出货地点                               */
                                     /*出貨地點                               */
oeb19       varchar2(1),             /*备置否                                 */
                                     /*備置否(Y/N)                            */
oeb20       varchar2(10),            /*交运方式                               */
                                     /*交運方式                               */
oeb21       varchar2(6),             /*价格条件                               */
                                     /*價格條件                               */
oeb22       varchar2(10),            /*版本                                   */
oeb23       number(15,3) NOT NULL,   /*待出货数量                             */
                                     /*待出貨數量 (已出貨通知或出貨未扣帳)    */
oeb24       number(15,3) NOT NULL,   /*已出货数量                             */
                                     /*已出貨數量                             */
oeb25       number(15,3) NOT NULL,   /*已销退数量                             */
                                     /*已銷退數量(須再換貨出貨)               */
oeb26       number(15,3) NOT NULL,   /*被结案数量                             */
                                     /*被結案數量                             */
                                     /* ==>(未交量=訂單量-已出貨+已銷退-被結案)*/
oeb70       varchar2(1),             /*结案否                                 */
                                     /*結案否 (Y/N)                           */
oeb70d      date,                    /*结案日期                               */
                                     /*結案日期                               */
oeb71       varchar2(4),             /*合约项次/估价项次/报价项次             */
                                     /*合約項次/估價項次/報價項次             */
                                     /*(當為合約轉入時須輸入)                 */
oeb72       date,                    /*产品结构指定有效日期                   */
oeb901      number(15,3),            /*已包装数:出货时需减出货量              */
                                     /*已包裝數:出貨時需減出貨量              */
oeb902      date,                    /*包装日期                               */
                                     /*包裝日期                               */
oeb903      number(15,3),            /*累积包装量                             */
                                     /*累積包裝量                             */
oeb904      number(20,6),            /*议价单价(BI)                           */
oeb905      number(15,3),            /*己备置量                               */
oeb906      varchar2(1),             /*检验否                                 */
                                     /*預設單身料號是否需要檢驗               */
oeb907      varchar2(1),             /*hold否                                 */
oeb908      varchar2(20),            /*海关手册编号                           */
oeb909      varchar2(20),            /*No Use                                 */
oeb910      varchar2(4),             /*单位一                                 */
oeb911      number(20,8),            /*单位一换算率(与销售单位)               */
oeb912      number(15,3),            /*单位一数量                             */
oeb913      varchar2(4),             /*单位二                                 */
oeb914      number(20,8),            /*单位二换算率(与销售单位)               */
oeb915      number(15,3),            /*单位二数量                             */
oeb916      varchar2(4),             /*计价单位                               */
oeb917      number(15,3) DEFAULT '0',/*计价数量                               */
oeb1001     varchar2(10),            /*原因码                                 */
oeb1002     varchar2(10),            /*订价编号                               */
oeb1003     varchar2(1),             /*作业方式                               */
oeb1004     varchar2(20),            /*提案编号                               */
oeb1005     varchar2(10),            /*订价群组                               */
oeb1006     number(9,4),             /*折扣率                                 */
oeb1007     varchar2(20),            /*现金折扣单号                           */
oeb1008     varchar2(4),             /*税种                                   */
oeb1009     number(9,4),             /*税率                                   */
oeb1010     varchar2(1),             /*含税否                                 */
oeb1011     varchar2(15),            /*非直营KAB                              */
oeb1012     varchar2(1),             /*搭赠                                   */
oeb920      number(15,3),            /*已分配量                               */
oeb1013     number(20,6),            /*本次应返金额                           */
oeb930      varchar2(10),            /*成本中心                               */
oeb27       varchar2(20),            /*请购单号                               */
oeb28       number(15,3),            /*已转请购量                             */
oeb29       number(15,3),            /*偿价数量                               */
oeb30       date,                    /*预计规还日期                           */
oeb31       varchar2(10),            /*展延原因码                             */
oeb935      varchar2(20),            /*补返来源订单单号                       */
oeb936      number(5),               /*补返来源订单项次                       */
oeb937      number(5),               /*物返条件来源合同项次                   */
oeb41       varchar2(10),            /*项目编号                               */
oeb42       varchar2(30),            /*WBS编号                                */
oeb43       varchar2(4),             /*活动编号                               */
oeb931      varchar2(20),            /*包装编号                               */
oeb932      number(15,3),            /*包装数量                               */
oeb933      varchar2(10),            /*末维属性组                             */
oeb934      varchar2(10),            /*属性群组                               */
oebud01     varchar2(255),           /*备注                                   */
oebud02     varchar2(40),            /*合约单号                               */
oebud03     varchar2(40),            /*光板订单号                             */
oebud04     varchar2(40),            /*子/母订单单号                          */
oebud05     varchar2(40),            /*版本                                   */
oebud06     varchar2(40),            /*尺寸                                   */
oebud07     number(15,3),            /*已转工单数                             */
oebud08     number(15,3),            /*未转订单数量                           */
oebud09     number(15,3),            /*未转工单数量                           */
oebud10     number(10),              /*合约单号项次                           */
oebud11     number(10),              /*子订单项次                             */
oebud12     number(10),              /*自订字段-整数                          */
oebud13     date,                    /*自订字段-日期                          */
oebud14     varchar2(40),            /*排版                                   */
oebud15     date,                    /*自订字段-日期                          */
oeb44       varchar2(1) DEFAULT ' ' NOT NULL, /*经营方式*/
oeb45       number(5,2),             /*原扣率                                 */
oeb46       number(5,2),             /*新扣率                                 */
oeb47       number(20,6) DEFAULT '0' NOT NULL, /*分摊折价=全部折价字段值的合*/
oeb48       varchar2(1) DEFAULT '1' NOT NULL, /*出货方式 1.订货 2.现货*/
oebplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oeblegal    varchar2(10) NOT NULL,   /*所属法人                               */
oeb32       date,                    /*截止日期                               */
oeb918      varchar2(20),            /*合并版号                               */
oeb919      varchar2(50),            /*计画批号                               */
oeb49       varchar2(20),            /*摊位编号                               */
oeb50       varchar2(10),            /*商户编号                               */
oeb37       number(20,6) DEFAULT '0' NOT NULL, /*基础单价*/
oeb51       varchar2(8)              /*交货时间                               */
);

create        index oeb_03 on oeb_file (oeb15);
create        index oeb_02 on oeb_file (oeb04);
create        index oeb_04 on oeb_file (oeb16);
alter table oeb_file add  constraint oeb_pk primary key  (oeb01,oeb03) enable validate;
grant select on oeb_file to tiptopgp;
grant update on oeb_file to tiptopgp;
grant delete on oeb_file to tiptopgp;
grant insert on oeb_file to tiptopgp;
grant index on oeb_file to public;
grant select on oeb_file to ods;
