/*
================================================================================
檔案代號:pmm_file
檔案名稱:采购单单头
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pmm_file
(
pmm01       varchar2(20) NOT NULL,   /*采购单号                               */
                                     /*採購單號                               */
pmm02       varchar2(10),            /*采购单性质                             */
pmm03       number(5),               /*更动序号                               */
                                     /*更動序號                               */
                                     /*採購單更動版本序號                     */
                                     /*本系統有保留歷史採購單資料的功能，當使用*/
                                     /*者與廠商之間的交易有一些變更時可利用更動*/
                                     /*序號記錄變更否，如無變更本欄位為空白   */
pmm04       date,                    /*采购日期                               */
                                     /*採購日期                               */
                                     /*採購單下單日期                         */
                                     /*本欄位不允許空白                       */
pmm05       varchar2(10),            /*项目号码                               */
                                     /*專案號碼 --> no use (00/04/18)         */
                                     /*如該採購單為特定給某一專案使用時可輸入 */
pmm06       varchar2(10),            /*预算号码                               */
                                     /*預算號碼 pno01                         */
                                     /*如果有使用採購預算時可輸入             */
                                     /*如採用採購預算時, 系統應與應付帳款相連 */
pmm07       varchar2(10),            /*单据分类                               */
                                     /*單據分類                               */
                                     /*使用者可自行定義將採購單分類           */
pmm08       varchar2(20),            /*PBI                                    */
pmm09       varchar2(10),            /*供应厂商                               */
                                     /*供應廠商 pmc01                         */
                                     /*下單供應廠商                           */
                                     /*輸入供應商編號交易狀況為               */
                                     /*0: 已核淮(可接受)                      */
                                     /*1: 尚待核淮(提示警告訊息確認後可接受)  */
                                     /*2: 不淮交易(不可接受)                  */
pmm10       varchar2(10),            /*送货地址                               */
                                     /*送貨地址  pme01,pme02<>'1'             */
                                     /*輸入此批採購的送貨地址                 */
pmm11       varchar2(10),            /*帐单地址                               */
                                     /*帳單地址  pme01,pme02<>'0'             */
                                     /*輸入此批採購的帳單地址                 */
pmm12       varchar2(10),            /*采购员                                 */
                                     /*Buyer gen01                            */
                                     /*Input Buyer No. Of Batch Purchase, May Blank. If Set Buyer, Employee Table Must Exist*/
pmm13       varchar2(10),            /*采购部门                               */
                                     /*採購部門 gem01                         */
pmm14       varchar2(10),            /*收货部门                               */
                                     /*收貨部門 gem01                         */
                                     /*輸入此批採購的收貨部門, 可空白         */
                                     /*如果有設定請購部門, 則需存在 部門檔    */
pmm15       varchar2(10),            /*审核人                                 */
                                     /*確認人                                 */
                                     /*輸入此批採購確認人, 可空白             */
                                     /*如果有設定確認人, 則需存在 員工檔      */
pmm16       varchar2(10),            /*运送方式                               */
                                     /*運送方式 ged01                         */
                                     /*輸入此批採購的確認人, 可空白           */
pmm17       varchar2(10),            /*代理商                                 */
                                     /*代理商  pmc01                          */
                                     /*輸入此批採購的代理商, 可空白           */
pmm18       varchar2(1),             /*确认码                                 */
                                     /*確認碼(Y/N/X) X.作廢         (97/07)   */
pmm20       varchar2(10),            /*付款方式                               */
                                     /*付款方式 pma01                         */
                                     /*輸入此批採購的付款方式                 */
pmm21       varchar2(4),             /*税种                                   */
                                     /*稅別 gec01                             */
                                     /*輸入此批採購的稅別, 不可空白           */
pmm22       varchar2(4),             /*币种                                   */
                                     /*幣別 azi01                             */
                                     /*輸入此批採購的幣別, 不可空白           */
pmm25       varchar2(1),             /*状况码                                 */
                                     /*狀況碼                                 */
                                     /*正確值 x/0/1/2/6/9/S/R/W               */
                                     /*X: 計劃訂單轉入                        */
                                     /*0: 開立(Open)                          */
                                     /*1: 已核准                              */
                                     /*2: 發出採購單                          */
                                     /*6: 結案                                */
                                     /*9: 取消(Cancel)                        */
                                     /*S: 送簽                  #No.6686      */
                                     /*R: 送簽退回                            */
                                     /*W: 抽單                                */
pmm26       varchar2(10),            /*理由码                                 */
                                     /*理由碼 azf01,azf02='2'                 */
                                     /*狀況變更的理由, 可空白                 */
pmm27       date,                    /*状况异动日期                           */
                                     /*狀況異動日期                           */
pmm28       varchar2(10),            /*会计分类                               */
                                     /*會計分類                               */
                                     /*專案系統使用                           */
pmm29       varchar2(24),            /*会计科目                               */
                                     /*會計科目 aag01                         */
                                     /*單據性質為  'EXP'，'SER'，'CAP' 時一定要*/
                                     /*輸入會計科目                           */
pmm30       varchar2(1),             /*收货单打印否                           */
                                     /*收貨單列印否                           */
                                     /*正確值 Y/N                             */
                                     /*Y: 收貨時, 必須列印收貨單              */
                                     /*N: 收貨時, 可不列印收貨單              */
pmm31       number(5),               /*会计年度                               */
                                     /*會計年度                               */
                                     /*該採購單所屬會計年度                   */
pmm32       number(5),               /*会计期间                               */
                                     /*會計期間                               */
                                     /*該採購單所屬會計期間                   */
pmm40       number(20,6),            /*总金额                                 */
                                     /*總金額                                 */
                                     /*系統維護                               */
                                     /*採購單身各項資料的  單價 * 數量 之總和 */
pmm401      number(20,6),            /*代买总金额                             */
                                     /*代買總金額                             */
pmm41       varchar2(6),             /*价格条件                               */
                                     /*價格條件 oah01                (97/06/19)*/
pmm42       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
                                     /*本欄位需大於零                         */
                                     /*當幣別輸入非本幣時需輸入本幣對外幣的匯率*/
pmm43       number(9,4),             /*税率                                   */
                                     /*稅率  % default gec04                  */
                                     /*輸入此批採購的稅率, 為百分比           */
pmm44       varchar2(1),             /*扣抵区分                               */
                                     /*扣抵區分                               */
                                     /*  1.可扣抵進貨及費用                   */
                                     /*  2.可扣抵固定資產                     */
pmm45       varchar2(1),             /*可用/不可用                            */
                                     /*Available/Unavailable                  */
                                     /*When practising MRP whether the purchase order is*/
                                     /*available or not? In other words, whether it is available*/
                                     /*or not when the purchase order is stored-in.If the head*/
                                     /*files of the purchase order is unavailable then the body*/
                                     /* of the purchase order is also unavailable. And if the*/
                                     /*head files of the purchase order is available the body*/
                                     /*files of the purchase order could be avaiable or*/
                                     /*unavailable.                           */
pmm46       number(5),               /*预付比率                               */
                                     /*預付比率                               */
                                     /*由付款方式檔中預設值                   */
pmm47       number(20,6),            /*预付金额                               */
                                     /*預付金額                               */
                                     /*採購單的金額 * 預付比率                */
pmm48       number(20,6),            /*已结帐金额                             */
                                     /*已結帳金額                             */
pmm49       varchar2(1),             /*预付发票否                             */
                                     /*預付發票否(Y/N)                        */
pmm50       varchar2(10),            /*代买流程最终供应商编号                 */
                                     /*代買流程最終供應商代號   01/11/06 Tommy*/
pmm99       varchar2(17),            /*多角贸易流程序号                       */
                                     /*多角貿易流程序號 No.7920 03/08/26 Kammy*/
pmm901      varchar2(1),             /*多角贸易否                             */
                                     /*多角貿易否                             */
pmm902      varchar2(1),             /*最终采购单否                           */
                                     /*最終採購單否,Y:不可再轉PO N:需再轉PO   */
pmm903      varchar2(1),             /*营业额申报方式                         */
                                     /*營業額申報方式 1/2/3                   */
                                     /*  1:訂單金額全額申報                   */
                                     /*  2:訂單與PO差額申報                   */
                                     /*  3:不申報                             */
pmm904      varchar2(8),             /*多角贸易流程代码                       */
                                     /*多角貿易流程代碼->poz_file  No.7920    */
pmm905      varchar2(1),             /*多角贸易抛转否                         */
                                     /*多角貿易拋轉否                         */
pmm906      varchar2(1),             /*多角贸易来源采购单否                   */
                                     /*多角貿易來源採購單否                   */
pmm907      varchar2(10),            /*No Use                                 */
pmm908      date,                    /*No Use                                 */
pmm909      varchar2(1),             /*资料来源                               */
pmm911      varchar2(10),            /*下游厂商对应客户编号                   */
                                     /*下游廠商對應客戶編號(與poa11對應)      */
pmm912      varchar2(10),            /*下游厂商对应客户编号                   */
                                     /*下游廠商對應客戶編號(與poa21對應)      */
pmm913      varchar2(10),            /*下游厂商对应客户编号                   */
                                     /*下游廠商對應客戶編號(與poa31對應)      */
pmm914      varchar2(10),            /*下游厂商对应客户编号                   */
                                     /*下游廠商對應客戶編號(與poa41對應)      */
pmm915      varchar2(10),            /*下游厂商对应客户编号                   */
                                     /*下游廠商對應客戶編號(與poa51對應)      */
pmm916      varchar2(10),            /*下游厂商对应客户编号                   */
                                     /*下游廠商對應客戶編號(與poa61對應)      */
pmmprsw     varchar2(1),             /*打印控制                               */
                                     /*Print control                          */
                                     /*To determine whether the Purchase List should be print.*/
                                     /*If choose 'Y',the system will do the corresponding*/
                                     /*process , there will be a virtual query feild if the*/
                                     /*print should be excute soon, and choose the print style*/
                                     /*when finish input. If choose'N' the system will push the*/
                                     /*Purchase List inputed to the print cache buffer and users*/
                                     /*can excute batch-print by Puechase System Waiting Print*/
                                     /*List.                                  */
pmmprno     number(5),               /*已打印次数                             */
                                     /*Printed Times                          */
                                     /*Printed Times Of The P/O Can Ctrol Reinssue The P/O Because Of Reprinting*/
pmmprdt     date,                    /*最后打印日期                           */
                                     /*Last Print Date                        */
                                     /*Last Print Date Of The P/O Help To Control Print And Inssue*/
pmmmksg     varchar2(1),             /*是否签核                               */
                                     /*Approve?                               */
                                     /*This field is used to control whether the purchase order*/
                                     /*need to be approved. If it is required to be approved as*/
                                     /*auto-set approval level or manual-set approval level,the*/
                                     /*Doucument Property Task is usable.     */
pmmsign     varchar2(4),             /*签核等级                               */
                                     /*簽核等級                               */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
                                     /*當此張採購單需作簽核處理時才顯示       */
pmmdays     number(5),               /*签核完成天数                           */
                                     /*簽核完成天數                           */
pmmprit     number(5),               /*签核优先等级                           */
                                     /*簽核優先等級                           */
pmmsseq     number(5),               /*已签核顺序                             */
                                     /*已簽核順序                             */
                                     /*系統自動維護                           */
                                     /*此張採購單已簽的人數                   */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
                                     /*當此張採購單需作簽核處理時才顯示       */
pmmsmax     number(5),               /*应签核顺序                             */
                                     /*應簽核順序                             */
                                     /*系統自動維護                           */
                                     /*此張採購單應簽的人數                   */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
                                     /*當此張採購單需作簽核處理時才顯示       */
pmmacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
pmmuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
pmmgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
pmmmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
pmmdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
pmm40t      number(20,6),            /*含税总金额                             */
pmmud01     varchar2(255),           /*用户定义                               */
pmmud02     varchar2(40),            /*用户定义                               */
pmmud03     varchar2(40),            /*用户定义                               */
pmmud04     varchar2(40),            /*用户定义                               */
pmmud05     varchar2(40),            /*用户定义                               */
pmmud06     varchar2(100),           /*委外申请单号                           */
pmmud07     number(15,3),            /*用户定义                               */
pmmud08     number(15,3),            /*用户定义                               */
pmmud09     number(15,3),            /*用户定义                               */
pmmud10     number(10),              /*用户定义                               */
pmmud11     number(10),              /*用户定义                               */
pmmud12     number(10),              /*用户定义                               */
pmmud13     date,                    /*用户定义                               */
pmmud14     date,                    /*用户定义                               */
pmmud15     date,                    /*用户定义                               */
pmm51       varchar2(1) DEFAULT ' ' NOT NULL, /*经营方式 1-经销,2-成本代销,3- */
pmm52       varchar2(10),            /*采购营运中心                           */
pmm53       varchar2(10),            /*配送中心                               */
pmmcond     date,                    /*审核日期                               */
pmmcont     varchar2(8),             /*审核时间                               */
pmmconu     varchar2(10),            /*审核人员                               */
pmmcrat     date,                    /*资料创建日                             */
pmmpos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否*/
pmmplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pmmlegal    varchar2(10) NOT NULL,   /*所属法人                               */
pmmoriu     varchar2(10),            /*资料建立者                             */
pmmorig     varchar2(10)             /*资料建立部门                           */
);

create        index pmm_02 on pmm_file (pmm09);
create        index pmm99 on pmm_file (pmm99);
create        index pmm_03 on pmm_file (pmm04);
alter table pmm_file add  constraint pmm_pk primary key  (pmm01) enable validate;
grant select on pmm_file to tiptopgp;
grant update on pmm_file to tiptopgp;
grant delete on pmm_file to tiptopgp;
grant insert on pmm_file to tiptopgp;
grant index on pmm_file to public;
grant select on pmm_file to ods;
