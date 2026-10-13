/*
================================================================================
檔案代號:oha_file
檔案名稱:销退单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oha_file
(
oha01       varchar2(20) NOT NULL,   /*销退单号                               */
                                     /*銷退單號                               */
oha02       date,                    /*销退日期                               */
                                     /*銷退日期                               */
oha03       varchar2(10),            /*帐款客户编号                           */
                                     /*帳款客戶編號  occ01                    */
                                     /*  MISC: 雜項客戶, 可輸入簡稱,統一編號  */
oha032      varchar2(40),            /*帐款客户简称                           */
                                     /*帳款客戶簡稱                           */
oha04       varchar2(10),            /*退货客户编号                           */
                                     /*退貨客戶編號  occ01                    */
oha05       varchar2(1),             /*单据别                                 */
oha08       varchar2(1),             /*1.内销 2.外销 3.视同外销               */
                                     /*1.內銷 2.外銷 3.視同外銷        NO.A093*/
oha09       varchar2(1),             /*销退处理方式                           */
                                     /*銷退處理方式 (1/2/3/4/5)               */
                                     /*  1.銷退折讓                           */
                                     /*    客戶會開立銷退折讓單沖原出貨發票   */
                                     /*    原發票不退回                       */
                                     /*    若需補貨, 則請重開換貨訂單         */
                                     /*  2.不折讓, 要換貨再出貨               */
                                     /*    本銷退單不可收銷退折讓單           */
                                     /*    需換貨出貨單 (但不可再開發票)      */
                                     /*    更新出貨單換貨銷退量               */
                                     /*  3.不折讓, 不換貨                     */
                                     /*    原出貨單尚未開發票的狀況下才可處理 */
                                     /*    本銷退單不可收銷退折讓單           */
                                     /*    更新出貨單不換貨銷退量             */
                                     /*  4.折讓且原訂單出貨     010416 add    */
                                     /*    客戶會開立銷退折讓單沖原出貨發票   */
                                     /*    原發票不退回                       */
                                     /*    若需補貨, 則可依原訂單出貨         */
                                     /*    更新訂單銷退量                     */
                                     /*  5.折讓        010416 add             */
                                     /*    沒有銷退數量, 屬於價格上之折讓     */
oha10       varchar2(20),            /*帐单编号                               */
                                     /*帳單編號  oma01                        */
oha14       varchar2(10),            /*人员编号                               */
                                     /*人員編號  gen01                        */
oha15       varchar2(10),            /*部门编号                               */
                                     /*部門編號  gem01                        */
oha16       varchar2(20),            /*出货单号                               */
                                     /*出貨單號  oga01                        */
oha17       varchar2(20),            /*RMA单号                                */
                                     /*RMA單號                             養生*/
oha21       varchar2(4),             /*税种                                   */
                                     /*稅別      gec01                        */
oha211      number(9,4),             /*税率                                   */
                                     /*稅率   (由稅別檔預設,不可改) gec04     */
oha212      varchar2(1),             /*联数                                   */
                                     /*聯數   (由稅別檔預設,不可改) gec05     */
oha213      varchar2(1),             /*含税否                                 */
                                     /*含稅否 (由稅別檔預設,不可改) gec07     */
oha23       varchar2(4),             /*币种                                   */
                                     /*幣別      azi01                        */
oha24       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
oha25       varchar2(10),            /*销售分类一                             */
                                     /*銷售分類一 oab01                       */
oha26       varchar2(10),            /*销售分类二                             */
                                     /*銷售分類二 oab01                       */
oha31       varchar2(6),             /*价格条件                               */
                                     /*價格條件   oah01                       */
oha41       varchar2(1),             /*三角贸易销退单否                       */
                                     /*三角貿易銷退單否           981221      */
oha42       varchar2(1),             /*是否入库存                             */
                                     /*是否入庫存(for 三角貿易來源廠用) 981221*/
                                     /*NOUSE      No.4444 030905              */
oha43       varchar2(1),             /*起始三角贸易销退单否                   */
                                     /*起始三角貿易銷退單否         981221    */
oha44       varchar2(1),             /*抛转否                                 */
                                     /*拋轉否(for 三角貿易)         981221    */
oha45       varchar2(1),             /*No Use                                 */
oha46       varchar2(1),             /*No Use                                 */
oha47       varchar2(20),            /*运送车号                               */
                                     /*運送車號                               */
oha48       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
oha50       number(20,6) NOT NULL,   /*原币销退总税前金额                     */
                                     /*原幣銷退總未稅金額                     */
oha53       number(20,6) NOT NULL,   /*原币销退应开折让税前金额               */
                                     /*原幣銷退應開折讓未稅金額               */
oha54       number(20,6) NOT NULL,   /*原币销退已开折让税前金额               */
                                     /*原幣銷退已開折讓未稅金額               */
oha99       varchar2(17),            /*多角贸易流程序号                       */
                                     /*多角貿易流程序號 No.4444 03/09/05      */
ohaconf     varchar2(1),             /*审核否                                 */
                                     /*確認否 (Y/N/X)                         */
ohapost     varchar2(1),             /*库存入帐否                             */
                                     /*庫存入帳否 (Y/N)                       */
ohaprsw     number(5),               /*打印次数                               */
                                     /*列印次數                               */
ohauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
ohagrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
ohamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
ohadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
oha55       varchar2(1),             /*状况码                                 */
ohamksg     varchar2(1),             /*签核否                                 */
oha1001     varchar2(10),            /*收款客户编号                           */
oha1002     varchar2(10),            /*债权代码                               */
oha1003     varchar2(10),            /*业绩归属组织                           */
oha1004     varchar2(10),            /*退货原因码                             */
oha1005     varchar2(1),             /*是否计算业绩                           */
oha1006     number(20,6),            /*折扣金额(税前)                         */
oha1007     number(20,6),            /*折扣金额(含税)                         */
oha1008     number(20,6),            /*销退总含税金额                         */
oha1009     varchar2(10),            /*客户所属通路                           */
oha1010     varchar2(10),            /*客户所属组织                           */
oha1011     varchar2(10),            /*开票客户                               */
oha1012     varchar2(20),            /*原始退单号                             */
oha1013     varchar2(20),            /*收料验收单号                           */
oha1014     varchar2(10),            /*代送商                                 */
oha1015     varchar2(1),             /*调货出货单所自动生成否                 */
oha1016     varchar2(10),            /*帐款客户编号                           */
oha1017     varchar2(1),             /*导物流状况                             */
oha1018     varchar2(20),            /*代送销货单号                           */
oha1019     number(20,6),            /*折扣退回税前金额                       */
oha1020     number(20,6),            /*折扣退回含税金额                       */
oha100      varchar2(10),            /*保税异动原因代码                       */
oha101      varchar2(30),            /*保税进口报单                           */
oha102      date,                    /*保税进口报单日期                       */
oha56       varchar2(20),            /*调拨单号                               */
ohaud01     varchar2(255),           /*自订字段-Textedit                      */
ohaud02     varchar2(40),            /*自订字段-文字                          */
ohaud03     varchar2(40),            /*自订字段-文字                          */
ohaud04     varchar2(40),            /*自订字段-文字                          */
ohaud05     varchar2(40),            /*自订字段-文字                          */
ohaud06     varchar2(40),            /*自订字段-文字                          */
ohaud07     number(15,3),            /*自订字段-数值                          */
ohaud08     number(15,3),            /*自订字段-数值                          */
ohaud09     number(15,3),            /*自订字段-数值                          */
ohaud10     number(10),              /*自订字段-整数                          */
ohaud11     number(10),              /*自订字段-整数                          */
ohaud12     number(10),              /*自订字段-整数                          */
ohaud13     date,                    /*自订字段-日期                          */
ohaud14     date,                    /*自订字段-日期                          */
ohaud15     date,                    /*自订字段-日期                          */
oha85       varchar2(1) DEFAULT ' ' NOT NULL, /*结算方式*/
                                     /*Customer Kind                          */
                                     /*1. Paynow Customer                     */
                                     /*2. Account Customer                    */
oha86       varchar2(10),            /*客层编号                               */
oha87       varchar2(30),            /*会员卡号                               */
oha88       varchar2(40),            /*顾客姓名                               */
oha89       varchar2(20),            /*联系电话                               */
oha90       varchar2(10),            /*证件类型                               */
oha91       varchar2(40),            /*证件号码                               */
oha92       varchar2(20),            /*赠品发放单号                           */
oha93       varchar2(20),            /*返券发放单号                           */
oha94       varchar2(1) DEFAULT 'N' NOT NULL, /*POS销售否 Y-是,N-否*/
oha95       number(20),              /*本次积分                               */
oha96       varchar2(10),            /*收银机号                               */
oha97       number(5),               /*交易序号                               */
ohacond     date,                    /*审核日期                               */
ohaconu     varchar2(10),            /*审核人员                               */
ohaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ohalegal    varchar2(10) NOT NULL,   /*所属法人                               */
ohaoriu     varchar2(10),            /*资料建立者                             */
ohaorig     varchar2(10),            /*资料建立部门                           */
oha98       varchar2(20),            /*POS单号                                */
oha57       varchar2(1) DEFAULT '1' NOT NULL, /*发票性质*/
ohacont     varchar2(8),             /*审核时间                               */
ohaslk02    varchar2(1)              /*订单类型                               */
);

create        index oha_02 on oha_file (oha02);
create        index oha_03 on oha_file (oha03);
create        index oha99 on oha_file (oha99);
alter table oha_file add  constraint oha_pk primary key  (oha01) enable validate;
grant select on oha_file to tiptopgp;
grant update on oha_file to tiptopgp;
grant delete on oha_file to tiptopgp;
grant insert on oha_file to tiptopgp;
grant index on oha_file to public;
grant select on oha_file to ods;
