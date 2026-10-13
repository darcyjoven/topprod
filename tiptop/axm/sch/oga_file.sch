/*
================================================================================
檔案代號:oga_file
檔案名稱:出货单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oga_file
(
oga00       varchar2(1),             /*出货别                                 */
                                     /*Delivery                               */
                                     /* 1.Normal Delivery:Contra Normal Order */
                                     /* 2.Exchange and Deliver:Contra Exchange Order*/
                                     /* 3.Delivery to Offshore W/H            */
                                     /* 4.Offshore W/H Delivery               */
                                     /* 5.Inter-BU Sale                       */
                                     /* 6.Exchange Order                      */
                                     /* 7.Send-Sales Order                    */
                                     /* A:Borrow Order                        */
                                     /* B:Borrow Cost                         */
oga01       varchar2(20) NOT NULL,   /*出货单号/出通单号                      */
oga011      varchar2(20),            /*出货通知单号                           */
                                     /*出貨通知單號 oga01,oga09='1'           */
oga02       date,                    /*出货日期                               */
                                     /*出貨日期                               */
oga021      date,                    /*结关日期                               */
                                     /*結關日期                               */
oga022      date,                    /*装船日期                               */
                                     /*裝船日期                               */
oga03       varchar2(10),            /*帐款客户编号                           */
                                     /*帳款客戶編號 occ01                     */
                                     /*  MISC: 雜項客戶, 可輸入簡稱,統一編號  */
oga032      varchar2(40),            /*帐款客户简称                           */
                                     /*帳款客戶簡稱                           */
oga033      varchar2(20),            /*帐款客户税号                           */
                                     /*帳款客戶統一編號                       */
oga04       varchar2(10),            /*送货客户编号                           */
                                     /*送貨客戶編號   occ1                    */
oga044      varchar2(10),            /*送货地址码                             */
                                     /*送貨地址碼                             */
                                     /*  空白: 使用送貨客戶送貨地址           */
                                     /*  Code: 使用送貨客戶其它地址           */
                                     /*  MISC: 臨時輸入送貨地址 (oap_file)    */
oga05       varchar2(5),             /*发票别                                 */
                                     /*發票別(自動發票開窗時將會依本欄位取簿號)*/
                                     /*  預設'1',輸入時不可空白,'X'表示不開發票*/
oga06       varchar2(1),             /*更改版本                               */
                                     /*修改版本                               */
oga07       varchar2(1),             /*出货是否计入未开发票的销货             */
                                     /*出貨是否計入未開發票的銷貨待驗收入 (Y/N)*/
oga08       varchar2(1),             /*1.内销 2.外销  3.视同外销              */
                                     /*1.內銷 2.外銷  3.視同外銷->no.A047     */
oga09       varchar2(1),             /*单据别                                 */
                                     /*Doc Type(1.Delivery Advice 2.Normal Delivery Note*/
                                     /*       3.No Order Delivery Note 4.Triangle Trade Delivery Note*/
                                     /*       5.Triangle Trade Delivery Advice*/
                                     /*       6.Sub PO Delivery Advice        */
                                     /*       8.Customer Receiving Report     */
                                     /*       9.Customer Returning Report     */
                                     /*       A.Shipping Order of Borrowed Goods*/
oga10       varchar2(20),            /*帐单编号                               */
                                     /*帳單編號 oma01                         */
oga11       date,                    /*应收款日                               */
                                     /*應收款日                               */
oga12       date,                    /*容许票据到期日                         */
                                     /*容許票據到期日                         */
oga13       varchar2(10),            /*科目分类码                             */
                                     /*科目分類碼                             */
oga14       varchar2(10),            /*人员编号                               */
                                     /*人員編號 gen01                         */
oga15       varchar2(10),            /*部门编号                               */
                                     /*部門編號 gem01                         */
oga16       varchar2(20),            /*订单单号                               */
                                     /*訂單單號 oea01                         */
                                     /*  有預收訂金時, 本單號一定要輸入       */
                                     /*  有預收訂金時, 一張出貨僅可沖一張訂單 */
oga161      number(5) NOT NULL,      /*订金应收比率                           */
                                     /*訂金應收比率                           */
oga162      number(5) NOT NULL,      /*出货应收比率                           */
                                     /*出貨應收比率                           */
oga163      number(5) NOT NULL,      /*尾款应收比率                           */
                                     /*尾款應收比率                           */
oga17       number(5),               /*排货模拟顺序                           */
                                     /*排貨模擬順序                           */
oga18       varchar2(10),            /*收款客户编号                           */
                                     /*收款客戶編號 occ01                     */
oga19       varchar2(20),            /*待抵帐款-预收单号                      */
                                     /*待抵帳款-預收單號 (No-Entry)           */
                                     /*  有預收訂金時, 會由訂單單號帶出本單號 */
oga20       varchar2(1),             /*分录底稿是否可重新生成                 */
                                     /*分錄底稿是否可重新產生(Y/N)            */
                                     /*  設為'N'時表示分錄底稿有經過人為修改, */
                                     /*  當執行'分錄產生'時, 不可再產生       */
oga21       varchar2(4),             /*税种                                   */
                                     /*稅別 gec01                             */
oga211      number(9,4),             /*税率                                   */
                                     /*稅率   (由稅別檔預設,不可改) gec04     */
oga212      varchar2(1),             /*联数                                   */
                                     /*聯數   (由稅別檔預設,不可改) gec05     */
oga213      varchar2(1),             /*含税否                                 */
                                     /*含稅否 (由稅別檔預設,不可改) gec07     */
oga23       varchar2(4),             /*币种                                   */
                                     /*幣別 azi01                             */
oga24       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
oga25       varchar2(10),            /*销售分类一                             */
                                     /*銷售分類一 oab01                       */
oga26       varchar2(10),            /*销售分类二                             */
                                     /*銷售分類二 oab01                       */
oga27       varchar2(20),            /*Invoice No.                            */
                                     /*Invoice#                        98/11/01*/
oga28       varchar2(1),             /*立帐时采用订单汇率                     */
                                     /*立帳時採用訂單匯率              98/11/01*/
oga29       number(20,6),            /*信用额度余额                           */
                                     /*信用額度餘額 (於確認時更新)            */
oga30       varchar2(1),             /*包装单审核码                           */
                                     /*包裝單確認碼 (Y/N)                     */
oga31       varchar2(6),             /*价格条件编号                           */
                                     /*價格條件編號 oah01                     */
oga32       varchar2(6),             /*收款条件编号                           */
                                     /*收款條件編號 oag01                     */
oga33       varchar2(255),           /*其它条件                               */
                                     /*其它條件                               */
oga34       number(5),               /*佣金率                                 */
oga35       varchar2(1),             /*外销方式                               */
                                     /*Export Type(1/2/3/4/5/6/7/8)           */
                                     /*1.Export goods.                        */
                                     /*2.Labors that have relation with Export, or supply from*/
                                     /*  local but work overseas.             */
                                     /*3.Sales that allow to be free-tax accroding to law, and*/
                                     /*  goods that belong to passenger passing through the*/
                                     /*  territory of a country.              */
                                     /*4.Business of sales and free-tax export.*/
                                     /*  Business in the Science Park.        */
                                     /*  Equipment,material,materiel,fuel,work-in-process*/
                                     /*  stored in the bonded plant or bonded warehouse*/
                                     /*  which managed by customs.            */
oga36       varchar2(40),            /*非经海关证明文件名称                   */
                                     /*非經海關証明文件名稱                   */
oga37       varchar2(16),            /*非经海关证明文件号码                   */
                                     /*非經海關証明文件號碼                   */
oga38       varchar2(10),            /*出口报单类型                           */
                                     /*出口報單類別                           */
oga39       varchar2(30),            /*出口报单号码                           */
                                     /*出口報單號碼                           */
oga40       varchar2(1),             /*NOTIFY                                 */
                                     /*NOTIFY                          98/11/01*/
oga41       varchar2(10),            /*起运地                                 */
                                     /*起運地 oac01                           */
oga42       varchar2(10),            /*到达地                                 */
                                     /*到達地 oac01                           */
oga43       varchar2(15),            /*交运方式                               */
                                     /*交運方式                               */
oga44       varchar2(10),            /*唛头编号                               */
                                     /*嘜頭編號 ocf02,ocf01=oga03             */
oga45       varchar2(40),            /*联络人                                 */
                                     /*聯絡人                                 */
oga46       varchar2(10),            /*项目编号                               */
                                     /*專案編號                               */
oga47       varchar2(20),            /*船名/车号                              */
                                     /*船名/車號                              */
oga48       varchar2(20),            /*航次                                   */
oga49       date,                    /*开航日期                               */
oga50       number(20,6) NOT NULL,   /*原币出货金额                           */
                                     /*原幣出貨金額(未稅)                     */
oga501      number(20,6),            /*本币出货金额                           */
                                     /*nouse  #No.9347                        */
oga51       number(20,6),            /*原币出货金额                           */
                                     /*原幣出貨金額(含稅)              98/11/01*/
oga511      number(20,6),            /*本币出货金额                           */
                                     /*nouse  #No.9347                        */
oga52       number(20,6) NOT NULL,   /*原币预收订金转销货收入金额             */
                                     /*原幣預收訂金轉銷貨收入金額             */
oga53       number(20,6) NOT NULL,   /*原币应开发票税前金额                   */
                                     /*原幣應開發票未稅金額                   */
oga54       number(20,6) NOT NULL,   /*原币已开发票税前金额                   */
                                     /*原幣已開發票未稅金額                   */
oga99       varchar2(17),            /*多角贸易流程序号                       */
                                     /*多角貿易流程序號 No.7992 03/08/30 Kammy*/
oga901      varchar2(1),             /*post to abx system flag                */
                                     /*'Y':確認                               */
                                     /*'N':未確認                             */
oga902      varchar2(10),            /*信用超限留置代码                       */
                                     /*保稅異動原因                           */
oga903      varchar2(1),             /*信用检查放行否                         */
                                     /*信用查核放行否(Y/N)                    */
oga904      varchar2(15),            /*No Use                                 */
                                     /*no use           no.A046               */
oga905      varchar2(1),             /*已转三角贸易出货单否                   */
                                     /*已轉三角貿易出貨單否                   */
oga906      varchar2(1),             /*起始出货单否                           */
                                     /*起始出貨單否                           */
oga907      varchar2(20),            /*凭证号码                               */
                                     /*傳票號碼          99/06/28 modify      */
oga908      varchar2(10),            /*L/C NO                                 */
oga909      varchar2(1),             /*三角贸易否                             */
                                     /*三角貿易否                      99/05/01*/
oga910      varchar2(10),            /*境外仓库                               */
                                     /*境外倉庫                        99/05/07*/
oga911      varchar2(10),            /*境外库位                               */
                                     /*境外儲位 No.+024                99/05/07*/
ogaconf     varchar2(1),             /*审核否/作废码                          */
                                     /*確認否/作廢碼 (Y/N/X)                  */
ogapost     varchar2(1),             /*出货扣帐否                             */
                                     /*出貨扣帳否 (Y.已出貨扣帳 N.尚未)       */
ogaprsw     number(5),               /*打印次数                               */
                                     /*列印次數                               */
ogauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
ogagrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
ogamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
ogadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
oga55       varchar2(1),             /*状况码                                 */
                                     /*No use                                 */
ogamksg     varchar2(1),             /*签核                                   */
oga65       varchar2(1),             /*客户出货签收否                         */
oga66       varchar2(10),            /*出货签收在途/验退仓库                  */
oga67       varchar2(10),            /*出货签收在途/验退库位                  */
oga1001     varchar2(10),            /*收款客户编号                           */
oga1002     varchar2(10),            /*债权代码                               */
oga1003     varchar2(10),            /*业绩归属组织                           */
oga1004     varchar2(10),            /*调货客户                               */
oga1005     varchar2(1),             /*是否计算业绩                           */
oga1006     number(20,6),            /*折扣金额(税前)                         */
oga1007     number(20,6),            /*折扣金额(含税)                         */
oga1008     number(20,6),            /*出货总含税金额                         */
oga1009     varchar2(10),            /*客户所属通路                           */
oga1010     varchar2(10),            /*客户所属组织                           */
oga1011     varchar2(10),            /*开票客户                               */
oga1012     varchar2(20),            /*销退单单号                             */
oga1013     varchar2(1),             /*已打印提单否                           */
oga1014     varchar2(1),             /*调货销退单所自动生成否                 */
oga1015     varchar2(1),             /*导物流状况码                           */
oga1016     varchar2(10),            /*代送商                                 */
oga68       varchar2(10),            /*No Use                                 */
ogaspc      varchar2(1),             /*SPC抛转码 0/1/2                        */
oga69       date,                    /*录入日期                               */
oga912      varchar2(10),            /*保税异动原因代码                       */
oga913      date,                    /*保税报单日期                           */
oga914      varchar2(20),            /*入库单号                               */
oga70       varchar2(20),            /*调拨单号                               */
ogaud01     varchar2(255),           /*SRM编号                                */
ogaud02     varchar2(40),            /*客户送货编号                           */
ogaud03     varchar2(40),            /*代工厂                                 */
ogaud04     varchar2(40),            /*货运商                                 */
ogaud05     varchar2(40),            /*运单号                                 */
ogaud06     varchar2(40),            /*客户项目名称                           */
ogaud07     number(15,3),            /*自订字段-数值                          */
ogaud08     number(15,3),            /*自订字段-数值                          */
ogaud09     number(15,3),            /*自订字段-数值                          */
ogaud10     number(10),              /*自订字段-整数                          */
ogaud11     number(10),              /*自订字段-整数                          */
ogaud12     number(10),              /*自订字段-整数                          */
ogaud13     date,                    /*自订字段-日期                          */
ogaud14     date,                    /*自订字段-日期                          */
ogaud15     date,                    /*自订字段-日期                          */
oga83       varchar2(10),            /*销货营运中心                           */
oga84       varchar2(10),            /*取货营运中心                           */
oga85       varchar2(1) DEFAULT ' ' NOT NULL, /*结算方式*/
                                     /*Customer Kind                          */
                                     /*1. Paynow Customer                     */
                                     /*2. Account Customer                    */
oga86       varchar2(10),            /*客层编号                               */
oga87       varchar2(30),            /*会员卡号                               */
oga88       varchar2(40),            /*顾客姓名                               */
oga89       varchar2(20),            /*联系电话                               */
oga90       varchar2(10),            /*证件类型                               */
oga91       varchar2(40),            /*证件号码                               */
oga92       varchar2(20),            /*赠品发放单号                           */
oga93       varchar2(20),            /*返券发放单号                           */
oga94       varchar2(1) DEFAULT 'N' NOT NULL, /*POS销售否 Y-是,N-否*/
oga95       number(20),              /*本次积分                               */
oga96       varchar2(10),            /*收银机号                               */
oga97       number(5),               /*交易序号                               */
ogacond     date,                    /*审核日期                               */
ogaconu     varchar2(10),            /*审核人员                               */
ogaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ogalegal    varchar2(10) NOT NULL,   /*所属法人                               */
oga71       varchar2(20),            /*申报税号                               */
ogaoriu     varchar2(10),            /*资料建立者                             */
ogaorig     varchar2(10),            /*资料建立部门                           */
ogacont     varchar2(8),             /*审核时间                               */
oga98       varchar2(20),            /*POS单号                                */
oga72       date,
oga57       varchar2(1) DEFAULT '1' NOT NULL, /*发票性质*/
ogaslk01    varchar2(20),            /*装箱单单号                             */
ogaslk02    varchar2(1) DEFAULT ' ', /*出货类型（现货，期货）                 */
oga56       varchar2(20)             /*签收单号                               */
);

create        index oga_02 on oga_file (oga02);
create        index oga_03 on oga_file (oga03);
create        index oga_06 on oga_file (oga011);
create        index oga_04 on oga_file (oga907);
create        index oga99 on oga_file (oga99);
create        index oga_05 on oga_file (oga10);
alter table oga_file add  constraint oga_pk primary key  (oga01) enable validate;
grant select on oga_file to tiptopgp;
grant update on oga_file to tiptopgp;
grant delete on oga_file to tiptopgp;
grant insert on oga_file to tiptopgp;
grant index on oga_file to public;
grant select on oga_file to ods;
