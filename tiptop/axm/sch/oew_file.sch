/*
================================================================================
檔案代號:oew_file
檔案名稱:订单(合同)单头暂存档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oew_file
(
oew00       varchar2(1),             /*类型                                   */
                                     /*類別 (0.合約 1.正常訂單 2.換貨訂單)    */
                                     /*  換貨訂單為銷退不追訂單而再開立者,    */
                                     /*  換貨訂單不計入銷貨統計               */
oew01       varchar2(20) NOT NULL,   /*订单单号/合约单号                      */
                                     /*訂單單號/合約單號                      */
oew02       date,                    /*订单日期/合约日期                      */
                                     /*訂單日期/合約日期                      */
oew03       varchar2(10),            /*帐款客户编号                           */
                                     /*帳款客戶編號 occ01                     */
                                     /*  MISC: 雜項客戶, 可輸入簡稱,統一編號  */
oew032      varchar2(40),            /*帐款客户简称                           */
                                     /*帳款客戶簡稱                           */
oew033      varchar2(20),            /*帐款客户税号                           */
                                     /*帳款客戶統一編號                       */
oew04       varchar2(10),            /*送货客户编号                           */
                                     /*送貨客戶編號 occ01                     */
oew044      varchar2(10),            /*送货地址码                             */
                                     /*送貨地址碼                             */
                                     /*  空白: 使用送貨客戶送貨地址           */
                                     /*  Code: 使用送貨客戶其它地址           */
                                     /*  MISC: 臨時開窗輸入送貨地址 (oep_file)*/
oew05       varchar2(5),             /*发票别                                 */
                                     /*發票別 (自動開發票時將會依本欄位取簿號)*/
                                     /*  預設'1',輸入時不可空白,'X'表示不開發票*/
oew06       varchar2(10),            /*更改版本                               */
                                     /*修改版本                               */
oew07       varchar2(1),             /*出货是否计入未开发票的销货             */
                                     /*出貨是否計入未開發票的銷貨待驗收入 (Y/N)*/
oew08       varchar2(1),             /*1.内销 2.外销 3.视同外销订单           */
                                     /*1.內銷 2.外銷 3.視同外銷訂單           */
oew09       number(5) NOT NULL,      /*允许超交率                             */
                                     /*允許超交率 % (出貨單確認時判斷)        */
oew10       varchar2(20),            /*客户订单单号                           */
                                     /*客戶訂單單號                           */
oew11       varchar2(1),             /*订单来源                               */
                                     /*訂單來源 (1.輸入 2.退補 3.合約轉入)    */
oew12       varchar2(20),            /*销退单号/合约单号                      */
                                     /*銷退單號/合約單號oha01/oew01,oew00='0' */
oew14       varchar2(10),            /*人员编号                               */
                                     /*人員編號   gen01                       */
oew15       varchar2(10),            /*部门编号                               */
                                     /*部門編號   gem01                       */
oew161      number(5),               /*订金应收比率                           */
                                     /*訂金應收比率                           */
oew162      number(5),               /*出货应收比率                           */
                                     /*出貨應收比率                           */
oew163      number(5),               /*尾款应收比率                           */
                                     /*尾款應收比率                           */
oew17       varchar2(10),            /*收款客户编号                           */
                                     /*收款客戶編號 occ01                     */
oew18       varchar2(1),             /*是否采用订单汇率立帐                   */
                                     /*是否採用訂單匯率立帳                   */
oew19       varchar2(80),            /*NOTIFY                                 */
oew20       varchar2(1),             /*是否直接送货至客户                     */
                                     /*是否直接送貨至客戶                     */
oew21       varchar2(4),             /*税种                                   */
                                     /*稅別       gec01                       */
oew211      number(9,4),             /*税率                                   */
                                     /*稅率   (由稅別檔預設,不可改)gec04      */
oew212      varchar2(1),             /*联数                                   */
                                     /*聯數   (由稅別檔預設,不可改)gec05      */
oew213      varchar2(1),             /*含税否                                 */
                                     /*含稅否 (由稅別檔預設,不可改)gec07      */
oew23       varchar2(4),             /*币种                                   */
                                     /*幣別   azi01                           */
oew24       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
oew25       varchar2(10),            /*销售分类一                             */
                                     /*銷售分類一 oab01                       */
oew26       varchar2(10),            /*销售分类二                             */
                                     /*銷售分類二 oab01                       */
oew27       varchar2(1),             /*No Use                                 */
oew28       varchar2(1),             /*No Use                                 */
oew29       varchar2(1),             /*No Use                                 */
oew30       varchar2(1),             /*No Use                                 */
oew31       varchar2(6),             /*价格条件编号                           */
                                     /*價格條件編號 oah01                     */
oew32       varchar2(6),             /*收款条件编号                           */
                                     /*收款條件編號 oag01                     */
oew33       varchar2(80),            /*其它条件                               */
                                     /*其它條件                               */
oew34       number(20,6),            /*佣金率%或佣金金额                      */
                                     /*佣金率%或佣金金額                      */
oew35       varchar2(10),            /*卸货港                                 */
                                     /*卸貨港 oac01                           */
oew36       varchar2(10),            /*产证                                   */
                                     /*產證                                   */
oew37       varchar2(1),             /*佣金方式                               */
                                     /*佣金方式 1:比率->佣金=金額*oew34/100   */
                                     /*         2:金額->佣金=oew34            */
oew38       varchar2(10),            /*forwader                               */
oew39       varchar2(4),             /*佣金币种                               */
                                     /*佣金幣別                               */
oew40       varchar2(10),            /*佣金对象                               */
                                     /*佣金對象                               */
oew41       varchar2(10),            /*起运地                                 */
                                     /*起運地  oac01                          */
oew42       varchar2(10),            /*到达地                                 */
                                     /*到達地  oac01                          */
oew43       varchar2(20),            /*交运方式                               */
                                     /*交運方式                               */
oew44       varchar2(10),            /*唛头编号                               */
                                     /*嘜頭代號 ocf02,ocf01=oew03             */
oew45       varchar2(40),            /*联络人                                 */
                                     /*聯絡人                                 */
oew46       varchar2(10),            /*项目编号                               */
                                     /*專案編號                               */
oew47       varchar2(1),             /*No Use                                 */
oew48       varchar2(1),             /*No Use                                 */
oew49       varchar2(1),             /*No Use                                 */
oew50       varchar2(1),             /*是否作CSD展开                          */
                                     /*是否作CSD展開                          */
oew51       varchar2(40),            /*CSD:产品品号                           */
                                     /*CSD:產品品號                           */
oew52       date,                    /*CSD:BOM 有效日期                       */
oew53       number(15,3),            /*CSD:套数                               */
                                     /*CSD:套數                               */
oew54       number(20,6),            /*CSD:原币售价                           */
                                     /*CSD:原幣售價                           */
oew55       number(20,6),            /*CSD:原币金额                           */
                                     /*CSD:原幣金額                           */
oew56       varchar2(10),            /*CSD:出货营运中心                       */
                                     /*CSD:Delivery Plant                     */
oew57       varchar2(10),            /*CSD:出货仓库                           */
                                     /*CSD:出貨倉庫                           */
oew58       varchar2(10),            /*CSD:出货库位                           */
                                     /*CSD:出貨儲位                           */
oew59       date,                    /*CSD:预计交货日                         */
                                     /*CSD:預計交貨日                         */
oew61       number(20,6) NOT NULL,   /*订单总税前金额                         */
                                     /*訂單總未稅金額                         */
                                     /*  訂單單身維護結束時立刻更新           */
oew62       number(20,6) NOT NULL,   /*已出货税前金额                         */
                                     /*已出貨未稅金額(已確認)                 */
                                     /*  出貨單確認時更新                     */
oew63       number(20,6) NOT NULL,   /*被结案税前金额                         */
                                     /*被結案未稅金額                         */
                                     /*  訂單確認時更新                       */
oew71       varchar2(4),             /*是否转入正式订单                       */
                                     /*是否轉入正式訂單(Y/N)   add 與oea不同  */
oew72       date,                    /*首次审核日                             */
                                     /*首次確認日 (第一次確認時更新)          */
oew901      varchar2(1),             /*角贸易否                               */
                                     /*三角貿易否                             */
oew902      varchar2(1),             /*最终订单否                             */
                                     /*最終訂單否,Y:不可再轉PO N:需再轉PO     */
oew903      varchar2(1),             /*营业额申报方式                         */
                                     /*營業額申報方式 1/2/3                   */
                                     /*  1:訂單金額全額申報                   */
                                     /*  2:訂單與PO差額申報                   */
                                     /*  3:不申報                             */
oew904      varchar2(2),             /*三角贸易流程代码                       */
                                     /*三角貿易流程代碼->oai_file             */
oew905      varchar2(1),             /*三角贸易抛转否                         */
                                     /*三角貿易拋轉否                         */
oew906      varchar2(1),             /*三角贸易来源订单否                     */
                                     /*三角貿易來源訂單否                     */
oew907      varchar2(1),             /*No Use                                 */
oew908      varchar2(1),             /*No Use                                 */
oew909      varchar2(1),             /*No Use                                 */
oew911      varchar2(10),            /*下游厂商对应客户编号                   */
                                     /*下游廠商對應客戶編號(與oai11對應)      */
oew912      varchar2(10),            /*下游厂商对应客户编号                   */
                                     /*下游廠商對應客戶編號(與oai21對應)      */
oew913      varchar2(10),            /*下游厂商对应客户编号                   */
                                     /*下游廠商對應客戶編號(與oai31對應)      */
oew914      varchar2(10),            /*下游厂商对应客户编号                   */
                                     /*下游廠商對應客戶編號(與oai41對應)      */
oew915      varchar2(10),            /*下游厂商对应客户编号                   */
                                     /*下游廠商對應客戶編號(與oai51對應)      */
oew916      varchar2(10),            /*下游厂商对应客户编号                   */
                                     /*下游廠商對應客戶編號(與oai61對應)      */
oewmksg     varchar2(1),             /*是否签核                               */
                                     /*是否簽核                               */
                                     /*本欄位可控制此張訂購單是否需簽核，如需簽*/
                                     /*核為自動賦與簽核等級或自行設定簽核等級可*/
                                     /*在單據性質檔中控制，因此簽核的控制亦可利*/
                                     /*用單據性質檔來控制                     */
oewsign     varchar2(4),             /*签核等级                               */
                                     /*簽核等級                               */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
                                     /*當此張訂購單需作簽核處理時才顯示       */
oewdays     number(5),               /*签核完成天数                           */
                                     /*簽核完成天數                           */
oewprit     number(5),               /*签核优先等级                           */
                                     /*簽核優先等級                           */
oewsseq     number(5),               /*已签核顺序                             */
                                     /*已簽核順序                             */
                                     /*系統自動維護                           */
                                     /*此張訂購單已簽的人數                   */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
                                     /*當此張訂購單需作簽核處理時才顯示       */
oewsmax     number(5),               /*应签核顺序                             */
                                     /*應簽核順序                             */
                                     /*系統自動維護                           */
                                     /*此張訂購單應簽的人數                   */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
                                     /*當此張訂購單需作簽核處理時才顯示       */
oewhold     varchar2(10),            /*留置原因码                             */
                                     /*留置原因碼 oak01,oak03='1'             */
oewconf     varchar2(1),             /*审核否                                 */
                                     /*確認否 (Y/N)                           */
oewprsw     number(5),               /*订单打印次数                           */
                                     /*訂單列印次數                           */
oewuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
oewgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
oewmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
oewdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
oewplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oewlegal    varchar2(10) NOT NULL,   /*所属法人                               */
oeworig     varchar2(10),            /*资料建立部门                           */
oeworiu     varchar2(10)             /*资料建立者                             */
);

alter table oew_file add  constraint oew_pk primary key  (oew01) enable validate;
grant select on oew_file to tiptopgp;
grant update on oew_file to tiptopgp;
grant delete on oew_file to tiptopgp;
grant insert on oew_file to tiptopgp;
grant index on oew_file to public;
grant select on oew_file to ods;
