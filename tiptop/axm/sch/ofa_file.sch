/*
================================================================================
檔案代號:ofa_file
檔案名稱:INVOICE单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ofa_file
(
ofa00       varchar2(1),             /*出货别                                 */
                                     /*出貨別 (1.正常出貨 2.換貨出貨)         */
                                     /* 1.正常出貨                            */
                                     /* 2.換貨出貨                            */
                                     /* 3.出至境外倉                          */
                                     /* 4.境外倉出貨                          */
ofa01       varchar2(20) NOT NULL,   /*Invoice No.                            */
ofa011      varchar2(20),            /*出货通知单号                           */
                                     /*出貨通知單號                           */
ofa02       date,                    /*出货日期                               */
                                     /*出貨日期                               */
ofa03       varchar2(10),            /*帐款客户编号                           */
                                     /*帳款客戶編號                           */
                                     /*  MISC: 雜項客戶, 可輸入簡稱,統一編號  */
ofa032      varchar2(40),            /*帐款客户简称                           */
                                     /*帳款客戶簡稱                           */
ofa033      varchar2(20),            /*帐款客户税号                           */
                                     /*帳款客戶統一編號                       */
ofa0351     varchar2(80),            /*帐款客户全名                           */
                                     /*帳款客戶全名(同 occ18 公司全名-1)   9608*/
ofa0352     varchar2(80),            /*帐款客户全名                           */
                                     /*帳款客戶全名(同 occ19 公司全名-2)   9608*/
ofa0353     varchar2(255),           /*帐款客户地址                           */
                                     /*帳款客戶地址(同 occ231)             9608*/
ofa0354     varchar2(255),           /*帐款客户地址                           */
                                     /*帳款客戶地址(同 occ232)             9608*/
ofa0355     varchar2(255),           /*帐款客户地址                           */
                                     /*帳款客戶地址(同 occ233)             9608*/
ofa04       varchar2(10),            /*送货客户编号                           */
                                     /*送貨客戶編號                           */
ofa044      varchar2(10),            /*送货地址码                             */
                                     /*送貨地址碼                             */
                                     /*  空白: 使用送貨客戶送貨地址           */
                                     /*  Code: 使用送貨客戶其它地址           */
                                     /*  MISC: 臨時輸入送貨地址               */
ofa0451     varchar2(80),            /*送货客户全名                           */
                                     /*送貨客戶全名 (同 occ18 公司全名-1)  9608*/
ofa0452     varchar2(80),            /*送货客户全名                           */
                                     /*送貨客戶全名 (同 occ19 公司全名-2)  9608*/
ofa0453     varchar2(255),           /*送货客户地址                           */
                                     /*送貨客戶地址 (同 occ241 或 ocd221   9608*/
ofa0454     varchar2(255),           /*送货客户地址                           */
                                     /*送貨客戶地址 (同 occ242 或 ocd222   9608*/
ofa0455     varchar2(255),           /*送货客户地址                           */
                                     /*送貨客戶地址 (同 occ243 或 ocd223   9608*/
ofa08       varchar2(1),             /*1.内销 2.外销                          */
                                     /*1.內銷 2.外銷                          */
ofa10       varchar2(30),            /*客户订单单号                           */
                                     /*客戶訂單單號                        9608*/
ofa16       varchar2(20),            /*订单单号                               */
                                     /*訂單單號                               */
ofa18       varchar2(10),            /*收款客户编号                           */
                                     /*收款客戶編號                           */
ofa21       varchar2(4),             /*税种                                   */
                                     /*稅別                                   */
ofa211      number(9,4),             /*税率                                   */
                                     /*稅率   (由稅別檔預設,不可改)           */
ofa212      varchar2(1),             /*联数                                   */
                                     /*聯數   (由稅別檔預設,不可改)           */
ofa213      varchar2(1),             /*含税否                                 */
                                     /*含稅否 (由稅別檔預設,不可改)           */
ofa23       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
ofa24       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
ofa25       varchar2(1),             /*保出字第xxxxxx号                       */
                                     /*保出字第xxxxxx號                       */
ofa26       varchar2(1),             /*No Use                                 */
ofa27       varchar2(1),             /*No Use                                 */
ofa28       varchar2(1),             /*No Use                                 */
ofa29       varchar2(1),             /*No Use                                 */
ofa30       varchar2(1),             /*No Use                                 */
ofa31       varchar2(6),             /*价格条件编号                           */
                                     /*價格條件編號                           */
ofa32       varchar2(6),             /*收款条件编号                           */
                                     /*收款條件編號                           */
ofa33       varchar2(255),           /*其它条件                               */
                                     /*其它條件                               */
ofa35       varchar2(1),             /*外销方式                               */
                                     /*外銷方式(1/2/3/4/5/6/7)                */
ofa36       varchar2(40),            /*非经海关证明文件名称                   */
                                     /*非經海關証明文件名稱                   */
ofa37       varchar2(10),            /*非经海关证明文件号码                   */
                                     /*非經海關証明文件號碼                   */
ofa38       varchar2(10),            /*出口报单类型                           */
                                     /*出口報單類別                           */
ofa39       varchar2(30),            /*出口报单号码                           */
                                     /*出口報單號碼                           */
ofa41       varchar2(10),            /*起运地                                 */
                                     /*起運地                                 */
ofa42       varchar2(10),            /*到达地                                 */
                                     /*到達地                                 */
ofa43       varchar2(15),            /*交运方式                               */
                                     /*交運方式                               */
ofa44       varchar2(10),            /*麦头编号                               */
                                     /*麥頭編號                               */
ofa45       varchar2(20),            /*CTN No.(From-To)                       */
ofa46       varchar2(20),            /*CTN No.(From-To)                       */
ofa47       varchar2(80),            /*船名                                   */
ofa48       varchar2(20),            /*航次                                   */
ofa49       date,                    /*开航日期                               */
                                     /*Sailing date                        9608*/
ofa50       number(20,6) NOT NULL,   /*原币出货金额                           */
                                     /*原幣出貨金額(未稅)                     */
ofa61       varchar2(20),            /*L/C NO.                                */
                                     /*L/C NO.                             9608*/
ofa62       date,                    /*开状日                                 */
                                     /*開狀日                              9608*/
ofa63       varchar2(40),            /*开状银行                               */
                                     /*開狀銀行                            9608*/
ofa71       varchar2(1),             /*1.打印本公司料号                       */
                                     /*1.列印本公司料號                    9608*/
                                     /*2.列印客戶料號                      9608*/
                                     /*3.列印本公司料號及客戶料號          9608*/
ofa72       varchar2(1),             /*是否打印FCC No.                        */
                                     /*是否列印FCC# (Y/N)                  9608*/
                                     /*FCC(Federal Communications Commission) */
                                     /*美國聯邦通訊委員會                     */
ofa73       varchar2(1),             /*是否打印软体检验码                     */
                                     /*是否列印軟體檢驗碼 (Y/N)            9608*/
ofa741      varchar2(4),             /*打印常用说明编号                       */
                                     /*列印常用說明編號                    9608*/
ofa742      varchar2(4),             /*打印常用说明编号                       */
                                     /*列印常用說明編號                    9608*/
ofa743      varchar2(4),             /*打印常用说明编号                       */
                                     /*列印常用說明編號                    9608*/
ofa75       varchar2(1),             /*1.PLT 2.CTN                            */
                                     /*1.PLT 2.CTN                         9608*/
ofa76       varchar2(20),            /*放行单号                               */
                                     /*放行單號                            9608*/
ofa77       number(15,3),            /*栈板重量                               */
                                     /*棧板重量                            9608*/
ofa78       varchar2(1),             /*卸货港                                 */
                                     /*卸貨港                              9608*/
ofa79       varchar2(1),             /*No Use                                 */
ofa99       varchar2(17),            /*多角贸易序号                           */
                                     /*多角貿易序號     No.7995 03/08/31 Kammy*/
ofa908      varchar2(20),            /*收状单号                               */
                                     /*收狀單號 (當收款條件為LC時, 須輸入)    */
ofaconf     varchar2(1),             /*审核否/作废码                          */
                                     /*確認否/作廢碼 (Y/N/X)                  */
ofaprsw     number(5),               /*打印次数                               */
                                     /*列印次數                               */
ofauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
ofagrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
ofamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
ofadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
ofaud01     varchar2(255),           /*自订字段-Textedit                      */
ofaud02     varchar2(40),            /*自订字段-文字                          */
ofaud03     varchar2(40),            /*自订字段-文字                          */
ofaud04     varchar2(40),            /*自订字段-文字                          */
ofaud05     varchar2(40),            /*自订字段-文字                          */
ofaud06     varchar2(40),            /*自订字段-文字                          */
ofaud07     number(15,3),            /*自订字段-数值                          */
ofaud08     number(15,3),            /*自订字段-数值                          */
ofaud09     number(15,3),            /*自订字段-数值                          */
ofaud10     number(10),              /*自订字段-整数                          */
ofaud11     number(10),              /*自订字段-整数                          */
ofaud12     number(10),              /*自订字段-整数                          */
ofaud13     date,                    /*自订字段-日期                          */
ofaud14     date,                    /*自订字段-日期                          */
ofaud15     date,                    /*自订字段-日期                          */
ofaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ofalegal    varchar2(10) NOT NULL,   /*所属法人                               */
ofaoriu     varchar2(10),            /*资料建立者                             */
ofaorig     varchar2(10),            /*资料建立部门                           */
ofa0356     varchar2(255),           /*帐款客户地址                           */
ofa0357     varchar2(255),           /*帐款客户地址                           */
ofa0456     varchar2(255),           /*送货客户地址                           */
ofa0457     varchar2(255)            /*送货客户地址                           */
);

create        index ofa_03 on ofa_file (ofa03);
create        index ofa_05 on ofa_file (ofa16);
create        index ofa_04 on ofa_file (ofa011);
create        index ofa99 on ofa_file (ofa99);
create        index ofa_02 on ofa_file (ofa02);
alter table ofa_file add  constraint ofa_pk primary key  (ofa01) enable validate;
grant select on ofa_file to tiptopgp;
grant update on ofa_file to tiptopgp;
grant delete on ofa_file to tiptopgp;
grant insert on ofa_file to tiptopgp;
grant index on ofa_file to public;
grant select on ofa_file to ods;
