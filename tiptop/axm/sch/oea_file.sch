/*
================================================================================
檔案代號:oea_file
檔案名稱:订单(合同)单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oea_file
(
oea00       varchar2(1),             /*类型                                   */
                                     /*Category                               */
                                     /* 0.Contract   1.Normal Order  2.Exchange Order*/
                                     /* 3:Delivery to Offshore W/H   4:Offshore W/H Delivery      5:Inter-BU Sale*/
                                     /* 6:Exchange Order     7:Send-Sales Orde      8:Borrow Order    9:Borrow Cost  */
                                     /*  Sales Sum. Not Count Exchange Order Sales, If The Exchange Order Is The Open Order After Sales/Return And Not Add.*/
oea01       varchar2(20) NOT NULL,   /*订单单号/合约单号                      */
                                     /*訂單單號/合約單號                      */
oea02       date,                    /*订单日期/合约日期                      */
                                     /*訂單日期/合約日期                      */
oea03       varchar2(10),            /*帐款客户编号                           */
                                     /*帳款客戶編號 occ01                     */
                                     /*  MISC: 雜項客戶, 可輸入簡稱,統一編號  */
oea032      varchar2(40),            /*帐款客户简称                           */
                                     /*帳款客戶簡稱                           */
oea033      varchar2(20),            /*帐款客户税号                           */
                                     /*帳款客戶統一編號                       */
oea04       varchar2(10),            /*送货客户编号                           */
                                     /*送貨客戶編號 occ01                     */
oea044      varchar2(10),            /*送货地址码                             */
                                     /*送貨地址碼                             */
                                     /*  空白: 使用送貨客戶送貨地址           */
                                     /*  Code: 使用送貨客戶其它地址           */
                                     /*  MISC: 臨時開窗輸入送貨地址 (oap_file)*/
oea05       varchar2(5),             /*发票别                                 */
                                     /*發票別 (自動開發票時將會依本欄位取簿號)*/
                                     /*  預設'1',輸入時不可空白,'X'表示不開發票*/
oea06       number(5),               /*更改版本                               */
                                     /*修改版本    (modify in 99/10/11)       */
oea07       varchar2(1),             /*出货是否计入未开发票的销货             */
                                     /*出貨是否計入未開發票的銷貨待驗收入 (Y/N)*/
oea08       varchar2(1),             /*订单性质                               */
                                     /*1.Local Sales 2.Export 3.As Export Order*/
oea09       number(5) NOT NULL,      /*允许超交率                             */
                                     /*允許超交率 % (出貨單確認時判斷)        */
oea10       varchar2(30),            /*客户订单单号                           */
                                     /*客戶訂單單號                           */
oea11       varchar2(1),             /*订单来源                               */
                                     /*訂單來源 (1.輸入 2.退補 3.合約轉入)    */
                                     /*         (4.估價單轉入            )    */
                                     /*         (5.報價單轉入            )    */
                                     /*         (6.多角代採買            )    */
                                     /*         (7.境外倉出貨單 no.7175  )    */
oea12       varchar2(20),            /*销退单号/合约单号/估价单号             */
                                     /*銷退單號/合約單號/估價單號             */
oea14       varchar2(10),            /*人员编号                               */
                                     /*人員編號   gen01                       */
oea15       varchar2(10),            /*部门编号                               */
                                     /*部門編號   gem01                       */
oea161      number(5),               /*订金应收比率                           */
                                     /*訂金應收比率                           */
oea162      number(5),               /*出货应收比率                           */
                                     /*出貨應收比率                           */
oea163      number(5),               /*尾款应收比率                           */
                                     /*尾款應收比率                           */
oea17       varchar2(10),            /*收款客户编号                           */
                                     /*收款客戶編號 occ01                     */
oea18       varchar2(1),             /*是否采用订单汇率立帐                   */
                                     /*是否採用訂單匯率立帳                   */
oea19       varchar2(80),            /*通知                                   */
oea20       varchar2(1),             /*是否直接送货至客户                     */
                                     /*是否直接送貨至客戶                     */
oea21       varchar2(4),             /*税种                                   */
                                     /*稅別       gec01                       */
oea211      number(9,4),             /*税率                                   */
                                     /*稅率   (由稅別檔預設,不可改)gec04      */
oea212      varchar2(1),             /*联数                                   */
                                     /*聯數   (由稅別檔預設,不可改)gec05      */
oea213      varchar2(1),             /*含税否                                 */
                                     /*含稅否 (由稅別檔預設,不可改)gec07      */
oea23       varchar2(4),             /*币种                                   */
                                     /*幣別   azi01                           */
oea24       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
oea25       varchar2(10),            /*销售分类一                             */
                                     /*銷售分類一 oab01                       */
oea26       varchar2(10),            /*销售分类二                             */
                                     /*銷售分類二 oab01                       */
oea27       varchar2(1),             /*No Use                                 */
oea28       varchar2(1),             /*No Use                                 */
oea29       varchar2(1),             /*No Use                                 */
oea30       varchar2(1),             /*No Use                                 */
oea31       varchar2(6),             /*价格条件编号                           */
                                     /*價格條件編號 oah01                     */
oea32       varchar2(6),             /*收款条件编号                           */
                                     /*收款條件編號 oag01                     */
oea33       varchar2(80),            /*其它条件                               */
                                     /*其它條件                               */
oea34       number(20,6),            /*佣金率%或佣金金额                      */
                                     /*佣金率%或佣金金額 modify 99/05/01      */
oea35       varchar2(10),            /*卸货港                                 */
                                     /*卸貨港 oac01      modify 99/05/01      */
oea36       varchar2(40),            /*产证                                   */
                                     /*產證              modify 99/05/01      */
oea37       varchar2(1),             /*订单分配否                             */
oea38       varchar2(10),            /*forwader                               */
oea39       varchar2(1),             /*No Use                                 */
oea40       varchar2(20),            /*抛转请购单号                           */
oea41       varchar2(10),            /*起运地                                 */
                                     /*起運地  oac01                          */
oea42       varchar2(10),            /*到达地                                 */
                                     /*到達地  oac01                          */
oea43       varchar2(20),            /*交运方式                               */
                                     /*交運方式                               */
oea44       varchar2(10),            /*唛头编号                               */
                                     /*嘜頭代號 ocf02,ocf01=oea03             */
oea45       varchar2(40),            /*联络人                                 */
                                     /*聯絡人                                 */
oea46       varchar2(10),            /*项目编号                               */
                                     /*專案編號                               */
oea47       varchar2(10),            /*代理商编号                             */
oea48       varchar2(10),            /*佣金编号                               */
oea49       varchar2(1),             /*状况码                                 */
                                     /*狀況碼:                                */
                                     /*0: 開立(Open)                          */
                                     /*1: 已核准                              */
                                     /*S: 送簽                 #No.6686       */
                                     /*R: 送簽退回                            */
                                     /*W: 抽單                                */
oea50       varchar2(1),             /*是否作CSD展开                          */
                                     /*是否作CSD展開                          */
oea51       varchar2(40),            /*CSD:产品品号                           */
                                     /*CSD:產品品號                           */
oea52       date,                    /*CSD:BOM 有效日期                       */
oea53       number(15,3),            /*CSD:套数                               */
                                     /*CSD:套數                               */
oea54       number(20,6),            /*CSD:原币售价                           */
                                     /*CSD:原幣售價                           */
oea55       number(20,6),            /*CSD:原币金额                           */
                                     /*CSD:原幣金額                           */
oea56       varchar2(10),            /*CSD:出货营运中心                       */
                                     /*CSD:Delivery Plant                     */
oea57       varchar2(10),            /*CSD:出货仓库                           */
                                     /*CSD:出貨倉庫                           */
oea58       varchar2(10),            /*CSD:出货库位                           */
                                     /*CSD:出貨儲位                           */
oea59       date,                    /*CSD:预计交货日                         */
                                     /*CSD:預計交貨日                         */
oea61       number(20,6) NOT NULL,   /*订单总税前金额                         */
                                     /*訂單總未稅金額                         */
                                     /*  訂單單身維護結束時立刻更新           */
oea62       number(20,6) NOT NULL,   /*已出货税前金额                         */
                                     /*已出貨未稅金額(已確認)                 */
                                     /*  出貨單確認時更新                     */
oea63       number(20,6) NOT NULL,   /*被结案税前金额                         */
                                     /*被結案未稅金額                         */
                                     /*  訂單確認時更新                       */
oea71       varchar2(4),             /*No Use                                 */
oea72       date,                    /*审核日                                 */
                                     /*確認日                                 */
oea99       varchar2(17),            /*多角贸易流程序号                       */
                                     /*多角貿易流程序號 No.7946 03/08/27 Kammy*/
oea901      varchar2(1),             /*多角贸易否                             */
                                     /*多角貿易否                             */
oea902      varchar2(1),             /*最终订单否                             */
                                     /*最終訂單否,Y:不可再轉PO N:需再轉PO     */
oea903      varchar2(1),             /*营业额申报方式                         */
                                     /*營業額申報方式 1/2/3                   */
                                     /*  1:訂單金額全額申報                   */
                                     /*  2:訂單與PO差額申報                   */
                                     /*  3:不申報                             */
oea904      varchar2(8),             /*多角贸易流程代码                       */
                                     /*多角貿易流程代碼->oai_file  oai01No.7946*/
oea905      varchar2(1),             /*多角贸易抛转否                         */
                                     /*多角貿易拋轉否                         */
oea906      varchar2(1),             /*多角贸易来源订单否                     */
                                     /*多角貿易來源訂單否                     */
oea907      varchar2(10),            /*RMA NO                                 */
oea908      date,                    /*信用超限放行有效日期                   */
oea909      varchar2(1),             /*No Use                                 */
oea911      varchar2(10),            /*下游厂商对应客户编号                   */
                                     /*下游廠商對應客戶編號                   */
oea912      varchar2(10),            /*下游厂商对应客户编号                   */
                                     /*下游廠商對應客戶編號                   */
oea913      varchar2(10),            /*下游厂商对应客户编号                   */
                                     /*下游廠商對應客戶編號                   */
oea914      varchar2(10),            /*下游厂商对应客户编号                   */
                                     /*下游廠商對應客戶編號                   */
oea915      varchar2(10),            /*下游厂商对应客户编号                   */
                                     /*下游廠商對應客戶編號                   */
oea916      varchar2(10),            /*下游厂商对应客户编号                   */
                                     /*下游廠商對應客戶編號                   */
oeamksg     varchar2(1),             /*是否签核                               */
                                     /*是否簽核                               */
                                     /*本欄位可控制此張採購單是否需簽核，如需簽*/
                                     /*核為自動賦與簽核等級或自行設定簽核等級可*/
                                     /*在單據性質檔中控制，因此簽核的控制亦可利*/
                                     /*用單據性質檔來控制                     */
oeasign     varchar2(4),             /*签核等级                               */
                                     /*簽核等級                               */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
oeadays     number(5),               /*签核完成天数                           */
                                     /*簽核完成天數                           */
oeaprit     number(5),               /*签核优先等级                           */
                                     /*簽核優先等級                           */
oeasseq     number(5),               /*已签核顺序                             */
                                     /*已簽核順序                             */
                                     /*系統自動維護                           */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
oeasmax     number(5),               /*应签核顺序                             */
                                     /*應簽核順序                             */
                                     /*系統自動維護                           */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
oeahold     varchar2(10),            /*留置原因码                             */
                                     /*留置原因碼 oak01,oak03='1'             */
oeaconf     varchar2(1),             /*审核否                                 */
                                     /*確認否 (Y/N/X)                         */
oeaprsw     number(5),               /*订单打印次数                           */
                                     /*訂單列印次數                           */
oeauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
oeagrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
oeamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
oeadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
oeaud01     varchar2(255),           /*自订字段                               */
oeaud02     varchar2(40),            /*是否开立SMT                            */
oeaud03     varchar2(40),            /*含模切料                               */
oeaud04     varchar2(40),            /*自订字段                               */
oeaud05     varchar2(40),            /*自订字段                               */
oeaud06     varchar2(40),            /*自订字段                               */
oeaud07     number(15,3),            /*自订字段                               */
oeaud08     number(15,3),            /*自订字段                               */
oeaud09     number(15,3),            /*自订字段                               */
oeaud10     number(10),              /*自订字段                               */
oeaud11     number(10),              /*自订字段                               */
oeaud12     number(10),              /*自订字段                               */
oeaud13     date,                    /*自订字段                               */
                                     /*上次订单日期                           */
oeaud14     date,                    /*自订字段                               */
oeaud15     date,                    /*自订字段                               */
oea65       varchar2(1),             /*客户出货签收否                         */
oea1001     varchar2(10),            /*收款客户编号                           */
oea1002     varchar2(10),            /*债权代码                               */
oea1003     varchar2(10),            /*业绩归属组织                           */
oea1004     varchar2(10),            /*调货客户                               */
oea1005     varchar2(1),             /*是否计算业绩                           */
oea1006     number(20,6),            /*折扣金额(税前)                         */
oea1007     number(20,6),            /*折扣金额(含税)                         */
oea1008     number(20,6),            /*订单总含税金额                         */
oea1009     varchar2(10),            /*客户所属通路                           */
oea1010     varchar2(10),            /*客户所属组织                           */
oea1011     varchar2(10),            /*开票客户                               */
oea1012     varchar2(1),             /*自提否                                 */
oea1013     number(15,3),            /*重量                                   */
oea1014     number(15,3),            /*体积                                   */
oea1015     varchar2(10),            /*代送商                                 */
oea68       varchar2(10),            /*No Use                                 */
oea80       varchar2(6),             /*订金收款条件                           */
oea81       varchar2(6),             /*尾款收款条件                           */
oea82       varchar2(1),             /*借货偿价                               */
oea917      varchar2(1),             /*二维录入                               */
oeaslk01    varchar2(20),            /*出口国                                 */
oea918      varchar2(1) DEFAULT 'n', /*定金立账分期                           */
oea919      varchar2(1) DEFAULT 'n', /*尾帐立账分期                           */
oea83       varchar2(10),            /*销货营运中心                           */
oea84       varchar2(10),            /*取货营运中心                           */
oea85       varchar2(1) DEFAULT ' ' NOT NULL, /*结算方式*/
                                     /*Customer Kind                          */
                                     /*1. Paynow Customer                     */
                                     /*2. Account Customer                    */
oea86       varchar2(10),            /*客层编号                               */
oea87       varchar2(30),            /*会员卡号                               */
oea88       varchar2(40),            /*顾客姓名                               */
oea89       varchar2(20),            /*联系电话                               */
oea90       varchar2(10),            /*证件类型                               */
oea91       varchar2(40),            /*证件号码                               */
oea92       varchar2(20),            /*赠品发放单号                           */
oea93       varchar2(20),            /*返券发放单号                           */
oeacont     varchar2(8),             /*审核时间                               */
oeaconu     varchar2(10),            /*审核人员                               */
oeaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oealegal    varchar2(10) NOT NULL,   /*所属法人                               */
oeaoriu     varchar2(10),            /*资料建立者                             */
oeaorig     varchar2(10),            /*资料建立部门                           */
oea94       varchar2(20),            /*POS单号                                */
oeaslk02    varchar2(1) DEFAULT ' ', /*订单明细                               */
oea261      number(20,6),            /*订金金额                               */
oea262      number(20,6),            /*出货金额                               */
oea263      number(20,6),            /*尾款金额                               */
oea95       varchar2(10)             /*生产营运中心                           */
);

create        index oea_02 on oea_file (oea02);
create        index oea_03 on oea_file (oea03);
create        index oea99 on oea_file (oea99);
alter table oea_file add  constraint oea_pk primary key  (oea01) enable validate;
grant select on oea_file to tiptopgp;
grant update on oea_file to tiptopgp;
grant delete on oea_file to tiptopgp;
grant insert on oea_file to tiptopgp;
grant index on oea_file to public;
grant select on oea_file to ods;
