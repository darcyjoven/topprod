/*
================================================================================
檔案代號:ohb_file
檔案名稱:销退单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ohb_file
(
ohb01       varchar2(20) NOT NULL,   /*销退单号                               */
                                     /*銷退單號 oha01                         */
ohb03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
ohb04       varchar2(40),            /*产品编号                               */
                                     /*產品編號 ima01(img01)                  */
ohb05       varchar2(4),             /*销售单位                               */
                                     /*銷售單位 ima25/ogb05                   */
ohb05_fac   number(20,8) NOT NULL,   /*销售/库存单位换算率                    */
                                     /*銷售/庫存單位換算率 (To ima25)         */
ohb06       varchar2(120),           /*品名规格                               */
                                     /*品名規格                               */
ohb07       varchar2(10),            /*额外品名编号                           */
                                     /*額外品名編號 imc02,imc01=ohb04         */
ohb08       varchar2(10),            /*销退入库营运中心编号                   */
                                     /*Sales/Return Store-in Plant No. azp01  */
ohb09       varchar2(10),            /*销退入库仓库编号                       */
                                     /*銷退入庫倉庫編號  imd01(img02)         */
ohb091      varchar2(10),            /*销退入库库位编号                       */
                                     /*銷退入庫儲位編號  imd01(img03)         */
ohb092      varchar2(24),            /*销退入库批号                           */
                                     /*銷退入庫批號            img04  No.+024 */
ohb11       varchar2(40),            /*客户产品编号                           */
                                     /*客戶產品編號 obk03,obk01=ohb04,obk02=oha*/
ohb12       number(15,3) NOT NULL,   /*数量                                   */
                                     /*數量                                   */
ohb13       number(20,6) NOT NULL,   /*原币单价                               */
                                     /*原幣單價                               */
ohb14       number(20,6) NOT NULL,   /*原币税前金额                           */
                                     /*原幣未稅金額                           */
ohb14t      number(20,6) NOT NULL,   /*原币含税金额                           */
                                     /*原幣含稅金額                           */
ohb15       varchar2(4),             /*库存明细单位由厂/仓/位/批自            */
                                     /*庫存明細單位(img09)由廠/倉/儲/批自動得出*/
ohb15_fac   number(20,8) NOT NULL,   /*销售/库存明细单位换算率                */
                                     /*銷售/庫存明細單位換算率 (To ogb15)     */
ohb16       number(15,3) NOT NULL,   /*数量                                   */
                                     /*數量 (依庫存明細單位)                  */
ohb30       varchar2(20),            /*原出货发票号                           */
                                     /*原出貨發票號 oma10                     */
ohb31       varchar2(20),            /*出货单号                               */
                                     /*出貨單號  oga01(ogb01)                 */
                                     /*  若可追索原出貨單, 此處請輸入原出貨單號*/
                                     /*    並可由原出貨單帶出原訂單單號(ohb31)*/
                                     /*  若不追索原出貨單, 此處請輸入空白     */
ohb32       number(5),               /*出货项次                               */
                                     /*出貨項次     ogb03                     */
ohb33       varchar2(20),            /*订单单号                               */
                                     /*訂單單號 oea01(oeb01)                  */
                                     /*  若可追索原訂單號, 此處請輸入原訂單號 */
                                     /*  若不追索原訂單號, 則須新開換貨訂單, 故*/
                                     /*    本欄將於新開換貨訂單時更新為換貨單號*/
ohb34       number(5),               /*订单项次                               */
                                     /*訂單項次      oeb03                    */
ohb50       varchar2(10),            /*退货理由码                             */
                                     /*退貨理由碼    oak01,oak03='2'          */
ohb51       varchar2(30),            /*报单号码                               */
                                     /*報單號碼                               */
ohb52       varchar2(20),            /*手册编号                               */
                                     /*手冊編號                        NO.A093*/
ohb53       varchar2(1),             /*No Use                                 */
ohb60       number(15,3) NOT NULL,   /*已开折让数量                           */
                                     /*已開折讓數量                           */
ohb910      varchar2(4),             /*单位一                                 */
ohb911      number(20,8),            /*单位一换算率(与销售单位)               */
ohb912      number(15,3),            /*单位一数量                             */
ohb913      varchar2(4),             /*单位二                                 */
ohb914      number(20,8),            /*单位二换算率(与销售单位)               */
ohb915      number(15,3),            /*单位二数量                             */
ohb916      varchar2(4),             /*计价单位                               */
ohb917      number(15,3),            /*计价数量                               */
ohb1001     varchar2(10),            /*订价编号                               */
ohb1002     varchar2(20),            /*提案编号                               */
ohb1003     number(9,4),             /*折扣率                                 */
ohb1004     varchar2(1),             /*搭增                                   */
ohb1005     varchar2(1),             /*作业方式                               */
ohb1007     varchar2(20),            /*现金折扣单号                           */
ohb1008     varchar2(4),             /*税种                                   */
ohb1009     number(9,4),             /*税率                                   */
ohb1010     varchar2(1),             /*含税否                                 */
ohb1011     varchar2(15),            /*非直营KAB                              */
ohb930      varchar2(10),            /*成本中心                               */
ohb1012     number(20,6),            /*已折让返利税前金额                     */
ohb61       varchar2(1),             /*检验                                   */
ohbud01     varchar2(255),           /*自订字段-Textedit                      */
ohbud02     varchar2(40),            /*自订字段-文字                          */
ohbud03     varchar2(40),            /*自订字段-文字                          */
ohbud04     varchar2(40),            /*自订字段-文字                          */
ohbud05     varchar2(40),            /*自订字段-文字                          */
ohbud06     varchar2(40),            /*自订字段-文字                          */
ohbud07     number(15,3),            /*自订字段-数值                          */
ohbud08     number(15,3),            /*自订字段-数值                          */
ohbud09     number(15,3),            /*自订字段-数值                          */
ohbud10     number(10),              /*自订字段-整数                          */
ohbud11     number(10),              /*自订字段-整数                          */
ohbud12     number(10),              /*自订字段-整数                          */
ohbud13     date,                    /*自订字段-日期                          */
ohbud14     date,                    /*自订字段-日期                          */
ohbud15     date,                    /*自订字段-日期                          */
ohb64       varchar2(1) DEFAULT ' ' NOT NULL, /*经营方式*/
ohb65       number(5,2),             /*原扣率                                 */
ohb66       number(5,2),             /*新扣率                                 */
ohb67       number(20,6) DEFAULT '0' NOT NULL, /*分摊折价=全部折价字段值的合*/
ohb68       varchar2(1) DEFAULT 'N' NOT NULL, /*有实物否  Y-是,N-否*/
ohbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ohblegal    varchar2(10) NOT NULL,   /*所属法人                               */
ohb69       varchar2(20),            /*摊位编号                               */
ohb70       varchar2(10),            /*商户编号                               */
ohb37       number(20,6) DEFAULT '0' NOT NULL, /*基础单价*/
ohb40       varchar2(10),            /*抽成编号                               */
ohb71       varchar2(20)             /*开票性质                               */
);

create        index ohb_03 on ohb_file (ohb30);
create        index ohb_05 on ohb_file (ohb33,ohb34);
create        index ohb_04 on ohb_file (ohb31,ohb32);
create        index ohb_02 on ohb_file (ohb04);
alter table ohb_file add  constraint ohb_pk primary key  (ohb01,ohb03) enable validate;
grant select on ohb_file to tiptopgp;
grant update on ohb_file to tiptopgp;
grant delete on ohb_file to tiptopgp;
grant insert on ohb_file to tiptopgp;
grant index on ohb_file to public;
grant select on ohb_file to ods;
