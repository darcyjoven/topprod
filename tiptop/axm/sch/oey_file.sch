/*
================================================================================
檔案代號:oey_file
檔案名稱:订单(合同)单头暂存档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oey_file
(
oey00       varchar2(1),             /*类型                                   */
                                     /*類別 (0.合約 1.正常訂單 2.換貨訂單)    */
                                     /*  換貨訂單為銷退不追訂單而再開立者,    */
                                     /*  換貨訂單不計入銷貨統計               */
oey01       varchar2(20) NOT NULL,   /*订单单号/合约单号                      */
                                     /*訂單單號/合約單號                      */
oey02       date,                    /*订单日期/合约日期                      */
                                     /*訂單日期/合約日期                      */
oey03       varchar2(10),            /*帐款客户编号                           */
                                     /*帳款客戶編號 occ01                     */
                                     /*  MISC: 雜項客戶, 可輸入簡稱,統一編號  */
oey032      varchar2(40),            /*帐款客户简称                           */
                                     /*帳款客戶簡稱                           */
oey033      varchar2(20),            /*帐款客户税号                           */
                                     /*帳款客戶統一編號                       */
oey04       varchar2(10),            /*送货客户编号                           */
                                     /*送貨客戶編號 occ01                     */
oey044      varchar2(10),            /*送货地址码                             */
                                     /*送貨地址碼                             */
                                     /*  空白: 使用送貨客戶送貨地址           */
                                     /*  Code: 使用送貨客戶其它地址           */
                                     /*  MISC: 臨時開窗輸入送貨地址 (oep_file)*/
oey05       varchar2(5),             /*发票别                                 */
                                     /*發票別 (自動開發票時將會依本欄位取簿號)*/
                                     /*  預設'1',輸入時不可空白,'X'表示不開發票*/
oey06       varchar2(10),            /*更改版本                               */
                                     /*修改版本                               */
oey07       varchar2(1),             /*出货是否计入未开发票的销货             */
                                     /*出貨是否計入未開發票的銷貨待驗收入 (Y/N)*/
oey08       varchar2(1),             /*1.内销 2.外销 3.视同外销订单           */
                                     /*1.內銷 2.外銷 3.視同外銷訂單           */
oey09       number(5) NOT NULL,      /*允许超交率                             */
                                     /*允許超交率 % (出貨單確認時判斷)        */
oey10       varchar2(20),            /*客户订单单号                           */
                                     /*客戶訂單單號                           */
oey11       varchar2(1),             /*订单来源                               */
                                     /*訂單來源 (1.輸入 2.退補 3.合約轉入)    */
oey12       varchar2(20),            /*销退单号/合约单号                      */
                                     /*銷退單號/合約單號oha01/oey01,oey00='0' */
oey14       varchar2(10),            /*人员编号                               */
                                     /*人員編號   gen01                       */
oey15       varchar2(10),            /*部门编号                               */
                                     /*部門編號   gem01                       */
oey161      number(5),               /*订金应收比率                           */
                                     /*訂金應收比率                           */
oey162      number(5),               /*出货应收比率                           */
                                     /*出貨應收比率                           */
oey163      number(5),               /*尾款应收比率                           */
                                     /*尾款應收比率                           */
oey17       varchar2(10),            /*收款客户编号                           */
                                     /*收款客戶編號 occ01                     */
oey18       varchar2(1),             /*是否采用订单汇率立帐                   */
                                     /*是否採用訂單匯率立帳                   */
oey19       varchar2(80),            /*NOTIFY                                 */
oey20       varchar2(1),             /*是否直接送货至客户                     */
                                     /*是否直接送貨至客戶                     */
oey21       varchar2(4),             /*税种                                   */
                                     /*稅別       gec01                       */
oey211      number(9,4),             /*税率                                   */
                                     /*稅率   (由稅別檔預設,不可改)gec04      */
oey212      varchar2(1),             /*联数                                   */
                                     /*聯數   (由稅別檔預設,不可改)gec05      */
oey213      varchar2(1),             /*含税否                                 */
                                     /*含稅否 (由稅別檔預設,不可改)gec07      */
oey23       varchar2(4),             /*币种                                   */
                                     /*幣別   azi01                           */
oey24       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
oey25       varchar2(10),            /*销售分类一                             */
                                     /*銷售分類一 oab01                       */
oey26       varchar2(10),            /*销售分类二                             */
                                     /*銷售分類二 oab01                       */
oey27       varchar2(1),             /*No Use                                 */
oey28       varchar2(1),             /*No Use                                 */
oey29       varchar2(1),             /*No Use                                 */
oey30       varchar2(1),             /*No Use                                 */
oey31       varchar2(6),             /*价格条件编号                           */
                                     /*價格條件編號 oah01                     */
oey32       varchar2(6),             /*收款条件编号                           */
                                     /*收款條件編號 oag01                     */
oey33       varchar2(80),            /*其它条件                               */
                                     /*其它條件                               */
oey34       number(20,6),            /*佣金率%或佣金金额                      */
                                     /*佣金率%或佣金金額                      */
oey35       varchar2(10),            /*卸货港                                 */
                                     /*卸貨港 oac01                           */
oey36       varchar2(10),            /*产证                                   */
                                     /*產證                                   */
oey37       varchar2(1),             /*佣金方式                               */
                                     /*佣金方式 1:比率->佣金=金額*oey34/100   */
                                     /*         2:金額->佣金=oey34            */
oey38       varchar2(10),            /*forwader                               */
oey39       varchar2(4),             /*佣金币种                               */
                                     /*佣金幣別                               */
oey40       varchar2(10),            /*佣金对象                               */
                                     /*佣金對象                               */
oey41       varchar2(10),            /*起运地                                 */
                                     /*起運地  oac01                          */
oey42       varchar2(10),            /*到达地                                 */
                                     /*到達地  oac01                          */
oey43       varchar2(20),            /*交运方式                               */
                                     /*交運方式                               */
oey44       varchar2(10),            /*唛头编号                               */
                                     /*嘜頭代號 ocf02,ocf01=oey03             */
oey45       varchar2(40),            /*联络人                                 */
                                     /*聯絡人                                 */
oey46       varchar2(10),            /*项目编号                               */
                                     /*專案編號                               */
oey47       varchar2(1),             /*No Use                                 */
oey48       varchar2(1),             /*No Use                                 */
oey49       varchar2(1),             /*No Use                                 */
oey50       varchar2(1),             /*是否作CSD展开                          */
                                     /*是否作CSD展開                          */
oey51       varchar2(40),            /*CSD:产品品号                           */
                                     /*CSD:產品品號                           */
oey52       date,                    /*CSD:BOM 有效日期                       */
oey53       number(15,3),            /*CSD:套数                               */
                                     /*CSD:套數                               */
oey54       number(20,6),            /*CSD:原币售价                           */
                                     /*CSD:原幣售價                           */
oey55       number(20,6),            /*CSD:原币金额                           */
                                     /*CSD:原幣金額                           */
oey56       varchar2(10),            /*CSD:出货营运中心                       */
                                     /*CSD:Delivery Plant                     */
oey57       varchar2(10),            /*CSD:出货仓库                           */
                                     /*CSD:出貨倉庫                           */
oey58       varchar2(10),            /*CSD:出货库位                           */
                                     /*CSD:出貨儲位                           */
oey59       date,                    /*CSD:预计交货日                         */
                                     /*CSD:預計交貨日                         */
oey61       number(20,6) NOT NULL,   /*订单总税前金额                         */
                                     /*訂單總未稅金額                         */
                                     /*  訂單單身維護結束時立刻更新           */
oey62       number(20,6) NOT NULL,   /*已出货税前金额                         */
                                     /*已出貨未稅金額(已確認)                 */
                                     /*  出貨單確認時更新                     */
oey63       number(20,6) NOT NULL,   /*被结案税前金额                         */
                                     /*被結案未稅金額                         */
                                     /*  訂單確認時更新                       */
oey71       varchar2(4),             /*No Use                                 */
oey72       date,                    /*首次审核日                             */
                                     /*首次確認日 (第一次確認時更新)          */
oey901      varchar2(1),             /*三角贸易否                             */
                                     /*三角貿易否                             */
oey902      varchar2(1),             /*最终订单否                             */
                                     /*最終訂單否,Y:不可再轉PO N:需再轉PO     */
oey903      varchar2(1),             /*营业额申报方式                         */
                                     /*營業額申報方式 1/2/3                   */
                                     /*  1:訂單金額全額申報                   */
                                     /*  2:訂單與PO差額申報                   */
                                     /*  3:不申報                             */
oey904      varchar2(2),             /*三角贸易流程代码                       */
                                     /*三角貿易流程代碼->oai_file             */
oey905      varchar2(1),             /*三角贸易抛转否                         */
                                     /*三角貿易拋轉否                         */
oey906      varchar2(1),             /*三角贸易来源订单否                     */
                                     /*三角貿易來源訂單否                     */
oey907      varchar2(1),             /*No Use                                 */
oey908      varchar2(1),             /*No Use                                 */
oey909      varchar2(1),             /*No Use                                 */
oey911      varchar2(10),            /*下游厂商对应客户编号                   */
                                     /*下游廠商對應客戶編號(與oai11對應)      */
oey912      varchar2(10),            /*下游厂商对应客户编号                   */
                                     /*下游廠商對應客戶編號(與oai21對應)      */
oey913      varchar2(10),            /*下游厂商对应客户编号                   */
                                     /*下游廠商對應客戶編號(與oai31對應)      */
oey914      varchar2(10),            /*下游厂商对应客户编号                   */
                                     /*下游廠商對應客戶編號(與oai41對應)      */
oey915      varchar2(10),            /*下游厂商对应客户编号                   */
                                     /*下游廠商對應客戶編號(與oai51對應)      */
oey916      varchar2(10),            /*下游厂商对应客户编号                   */
                                     /*下游廠商對應客戶編號(與oai61對應)      */
oeymksg     varchar2(1),             /*是否签核                               */
                                     /*是否簽核                               */
                                     /*本欄位可控制此張訂購單是否需簽核，如需簽*/
                                     /*核為自動賦與簽核等級或自行設定簽核等級可*/
                                     /*在單據性質檔中控制，因此簽核的控制亦可利*/
                                     /*用單據性質檔來控制                     */
oeysign     varchar2(4),             /*签核等级                               */
                                     /*簽核等級                               */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
                                     /*當此張訂購單需作簽核處理時才顯示       */
oeydays     number(5),               /*签核完成天数                           */
                                     /*簽核完成天數                           */
oeyprit     number(5),               /*签核优先等级                           */
                                     /*簽核優先等級                           */
oeysseq     number(5),               /*已签核顺序                             */
                                     /*已簽核順序                             */
                                     /*系統自動維護                           */
                                     /*此張訂購單已簽的人數                   */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
                                     /*當此張訂購單需作簽核處理時才顯示       */
oeysmax     number(5),               /*应签核顺序                             */
                                     /*應簽核順序                             */
                                     /*系統自動維護                           */
                                     /*此張訂購單應簽的人數                   */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
                                     /*當此張訂購單需作簽核處理時才顯示       */
oeyhold     varchar2(10),            /*留置原因码                             */
                                     /*留置原因碼 oak01,oak03='1'             */
oeyconf     varchar2(1),             /*审核否                                 */
                                     /*確認否 (Y/N)                           */
oeyprsw     number(5),               /*订单打印次数                           */
                                     /*訂單列印次數                           */
oeyuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
oeygrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
oeymodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
oeydate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
oeyplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oeylegal    varchar2(10) NOT NULL,   /*所属法人                               */
oeyorig     varchar2(10),            /*资料建立部门                           */
oeyoriu     varchar2(10)             /*资料建立者                             */
);

alter table oey_file add  constraint oey_pk primary key  (oey01) enable validate;
grant select on oey_file to tiptopgp;
grant update on oey_file to tiptopgp;
grant delete on oey_file to tiptopgp;
grant insert on oey_file to tiptopgp;
grant index on oey_file to public;
grant select on oey_file to ods;
