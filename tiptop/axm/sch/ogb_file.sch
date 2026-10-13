/*
================================================================================
檔案代號:ogb_file
檔案名稱:出货单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ogb_file
(
ogb01       varchar2(20) NOT NULL,   /*出货单号                               */
                                     /*出貨單號 oga01                         */
ogb03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
ogb04       varchar2(40),            /*产品编号                               */
                                     /*產品編號 ima01(img01)                  */
ogb05       varchar2(4),             /*销售单位                               */
                                     /*銷售單位 (與訂單必須一致)(No-Entry)ima31*/
ogb05_fac   number(20,8) NOT NULL,   /*销售/库存汇总单位换算率                */
                                     /*銷售/庫存彙總單位換算率 (To ima25)     */
ogb06       varchar2(120),           /*品名规格                               */
                                     /*品名規格                               */
ogb07       varchar2(10),            /*额外品名编号                           */
                                     /*額外品名編號  imc02,imc01=ogb04        */
ogb08       varchar2(10),            /*出货营运中心编号                       */
                                     /*Delivery Plant No. azp01               */
ogb09       varchar2(10),            /*出货仓库编号                           */
                                     /*出貨倉庫編號  imd01(img02)             */
ogb091      varchar2(10),            /*出货库位编号                           */
                                     /*出貨儲位編號  ime01(img03)             */
ogb092      varchar2(24),            /*出货批号                               */
                                     /*出貨批號            img04   No.+024    */
ogb11       varchar2(40),            /*客户产品编号                           */
                                     /*客戶產品編號 obk03,obk01=ogb04,obk02=oga*/
ogb12       number(15,3) NOT NULL,   /*实际出货数量                           */
                                     /*實際出貨數量 (依銷售單位)              */
ogb13       number(20,6) NOT NULL,   /*原币单价                               */
                                     /*原幣單價                               */
ogb14       number(20,6) NOT NULL,   /*原币税前金额                           */
                                     /*原幣未稅金額                           */
ogb14t      number(20,6) NOT NULL,   /*原币含税金额                           */
                                     /*原幣含稅金額                           */
ogb15       varchar2(4),             /*库存明细单位由厂/仓/位/批自            */
                                     /*庫存明細單位(img09)由廠/倉/儲/批自動得出*/
ogb15_fac   number(20,8) NOT NULL,   /*销售/库存明细单位换算率                */
                                     /*銷售/庫存明細單位換算率 (To ogb15)     */
ogb16       number(15,3) NOT NULL,   /*数量                                   */
                                     /*數量 (依庫存明細單位)                  */
ogb17       varchar2(1),             /*多仓位批出货否                         */
                                     /*多倉儲批出貨否 (Y/N)                   */
                                     /*  Y:多倉儲批出貨, 需再輸入庫存異動明細 */
                                     /*    (本項次下再掛另一單身 ogc_file)    */
ogb18       number(15,3) NOT NULL,   /*预计出货数量                           */
                                     /*預計出貨數量 (依銷售單位)              */
ogb19       varchar2(1),             /*检验否                                 */
                                     /*料號是否需要檢驗                       */
ogb20       varchar2(1),             /*No Use                                 */
ogb21       varchar2(1),             /*No Use                                 */
ogb22       varchar2(1),             /*No Use                                 */
ogb31       varchar2(20),            /*订单单号                               */
                                     /*訂單單號 oea01(oeb01)                  */
ogb32       number(5),               /*订单项次                               */
                                     /*訂單項次       oeb03                   */
ogb60       number(15,3) NOT NULL,   /*已开发票数量                           */
                                     /*已開發票數量                           */
ogb63       number(15,3) NOT NULL,   /*销退数量                               */
                                     /*銷退數量 (需換貨再出貨)                */
ogb64       number(15,3) NOT NULL,   /*销退数量                               */
                                     /*銷退數量 (不需換貨出貨)                */
ogb901      varchar2(1),             /*No Use                                 */
ogb902      varchar2(1),             /*No Use                                 */
ogb903      varchar2(1),             /*No Use                                 */
ogb904      varchar2(1),             /*No Use                                 */
ogb905      varchar2(1),             /*No Use                                 */
ogb906      varchar2(1),             /*No Use                                 */
ogb907      varchar2(1),             /*No Use                                 */
ogb908      varchar2(20),            /*手册编号                               */
ogb909      varchar2(1),             /*No Use                                 */
ogb910      varchar2(4),             /*单位一                                 */
ogb911      number(20,8),            /*单位一换算率(与销售单位)               */
ogb912      number(15,3),            /*单位一数量                             */
ogb913      varchar2(4),             /*单位二                                 */
ogb914      number(20,8),            /*单位二换算率(与销售单位)               */
ogb915      number(15,3),            /*单位二数量                             */
ogb916      varchar2(4),             /*计价单位                               */
ogb917      number(15,3) DEFAULT '0',/*计价数量                               */
ogb65       varchar2(10),            /*验退理由码                             */
ogb1001     varchar2(10),            /*原因码                                 */
ogb1002     varchar2(10),            /*订价编号                               */
ogb1005     varchar2(1),             /*作业方式                               */
ogb1007     varchar2(20),            /*现金折扣单号                           */
ogb1008     varchar2(4),             /*税种                                   */
ogb1009     number(9,4),             /*税率                                   */
ogb1010     varchar2(1),             /*含税否                                 */
ogb1011     varchar2(15),            /*非直营KAB                              */
ogb1003     date,                    /*预计出货日期                           */
ogb1004     varchar2(20),            /*提案编号                               */
ogb1006     number(9,4),             /*折扣率                                 */
ogb1012     varchar2(1),             /*搭赠                                   */
ogb930      varchar2(10),            /*成本中心                               */
ogb1013     number(20,6),            /*已开发票税前金额                       */
ogb1014     varchar2(1),             /*保税已放行否                           */
ogb41       varchar2(10),            /*项目编号                               */
                                     /*No use                                 */
ogb42       varchar2(30),            /*WBS编号                                */
ogb43       varchar2(4),             /*活动编号                               */
ogb931      varchar2(20),            /*包装编号                               */
ogb932      number(15,3),            /*包装数量                               */
ogbud01     varchar2(255),           /*订单备注                               */
ogbud02     varchar2(40),            /*客户订单号                             */
ogbud03     varchar2(40),            /*制造商料号                             */
ogbud04     varchar2(40),            /*希姆通订单号                           */
ogbud05     varchar2(40),            /*项目名称                               */
ogbud06     varchar2(40),            /*出通单备注                             */
ogbud07     number(15,3),            /*已签收数量                             */
ogbud08     varchar2(100),           /*自订字段-数值                          */
ogbud09     number(15,3),            /*自订字段-数值                          */
ogbud10     number(10),              /*出通单项次                             */
ogbud11     number(10),              /*自订字段-整数                          */
ogbud12     number(10),              /*自订字段-整数                          */
ogbud13     date,                    /*自订字段-日期                          */
ogbud14     date,                    /*自订字段-日期                          */
ogbud15     date,                    /*自订字段-日期                          */
ogb44       varchar2(1) DEFAULT ' ' NOT NULL, /*经营方式*/
ogb45       number(5,2),             /*原扣率                                 */
ogb46       number(5,2),             /*新扣率                                 */
ogb47       number(20,6) DEFAULT '0' NOT NULL, /*分摊折价=全部折价字段值的和*/
ogbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ogblegal    varchar2(10) NOT NULL,   /*所属法人                               */
ogb48       varchar2(20),            /*摊位编号                               */
ogb49       varchar2(10),            /*商户编号                               */
ogb37       number(20,6) DEFAULT '0' NOT NULL, /*基础单价*/
ogb40       varchar2(10),            /*抽成编号                               */
ogb71       varchar2(100),           /*发票号码                               */
ogb50       number(15,3) DEFAULT '0' NOT NULL, /*开票性质*/
ogb51       number(15,3) DEFAULT '0' NOT NULL, /*已签退数量*/
ogb52       number(15,3) DEFAULT '0' NOT NULL, /*簽退數量*/
ogb53       number(15,3) DEFAULT '0' NOT NULL, /*單位一驗退數量*/
ogb54       number(15,3) DEFAULT '0' NOT NULL, /*單位二驗退數量*/
ogb55       number(15,3) DEFAULT '0' NOT NULL /*驗退計價數量*/
);

create        index ogb_03 on ogb_file (ogb31,ogb32);
create        index ogb_02 on ogb_file (ogb04);
alter table ogb_file add  constraint ogb_pk primary key  (ogb01,ogb03) enable validate;
grant select on ogb_file to tiptopgp;
grant update on ogb_file to tiptopgp;
grant delete on ogb_file to tiptopgp;
grant insert on ogb_file to tiptopgp;
grant index on ogb_file to public;
grant select on ogb_file to ods;
