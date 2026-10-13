/*
================================================================================
檔案代號:pom_file
檔案名稱:无交期性采购单单头
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pom_file
(
pom01       varchar2(20) NOT NULL,   /*采购单号                               */
                                     /*採購單號                               */
pom02       varchar2(10),            /*采购单性质                             */
                                     /*採購單性質                             */
                                     /*正確值 REG/EXP/CAP/SUB                 */
                                     /*REG:REGular          一般性  採購      */
                                     /*EXP:EXPensed         消耗性  採購      */
                                     /*CAP:CAPital          資材性  採購      */
                                     /*SUB:SUBcontracted    廠外加工採購      */
pom03       number(5),               /*更动序号                               */
                                     /*Change S/N                             */
                                     /*P/O Change  Version S/N                */
                                     /*There Is Function Of Reserve History P/O Data In This System. Can Record Modify Or Not By Changing S/N When There Is Some Trade Alteration Between  User And Vender,No Changing Be Blank*/
pom04       date,                    /*采购日期                               */
                                     /*採購日期                               */
                                     /*採購單下單日期                         */
                                     /*本欄位不允許空白                       */
pom05       varchar2(10),            /*项目号码                               */
                                     /*專案號碼 --> no use (00/04/18)         */
                                     /*如該採購單為特定給某一專案使用時可輸入 */
pom06       varchar2(10),            /*预算号码                               */
                                     /*預算號碼 pno01                         */
                                     /*如果有使用採購預算時可輸入             */
                                     /*如採用採購預算時, 系統應與應付帳款相連 */
pom07       varchar2(10),            /*单据分类                               */
                                     /*單據分類                               */
                                     /*使用者可自行定義將採購單分類           */
pom08       varchar2(20),            /*PBI                                    */
pom09       varchar2(10),            /*供应厂商                               */
                                     /*供應廠商 pmc01                         */
                                     /*下單供應廠商                           */
                                     /*輸入供應商編號交易狀況為               */
                                     /*0: 已核淮(可接受)                      */
                                     /*1: 尚待核淮(提示警告訊息確認後可接受)  */
                                     /*2: 不淮交易(不可接受)                  */
pom10       varchar2(10),            /*送货地址                               */
                                     /*送貨地址  pme01,pme02<>'1'             */
                                     /*輸入此批採購的送貨地址                 */
pom11       varchar2(10),            /*帐单地址                               */
                                     /*帳單地址  pme01,pme02<>'0'             */
                                     /*輸入此批採購的帳單地址                 */
pom12       varchar2(10),            /*采购员                                 */
                                     /*採購員 gen01                           */
                                     /*輸入批採購的採購員代號, 可空白         */
                                     /*如果有設定採購員, 則需存在 員工檔      */
pom13       varchar2(10),            /*采购部门                               */
                                     /*採購部門 gem01                         */
pom14       varchar2(10),            /*收货部门                               */
                                     /*收貨部門 gem01                         */
                                     /*輸入此批採購的收貨部門, 可空白         */
                                     /*如果有設定請購部門, 則需存在 部門檔    */
pom15       varchar2(10),            /*审核人                                 */
                                     /*確認人                                 */
                                     /*輸入此批採購確認人, 可空白             */
                                     /*如果有設定確認人, 則需存在 員工檔      */
pom16       varchar2(10),            /*运送方式                               */
                                     /*運送方式 ged01                         */
                                     /*輸入此批採購的確認人, 可空白           */
pom17       varchar2(10),            /*代理商                                 */
                                     /*代理商  pmc01                          */
                                     /*輸入此批採購的代理商, 可空白           */
pom18       varchar2(1),             /*确认码                                 */
                                     /*Confirm Code  (97/07)                  */
pom20       varchar2(10),            /*付款方式                               */
                                     /*付款方式 pma01                         */
                                     /*輸入此批採購的付款方式                 */
pom21       varchar2(4),             /*税种                                   */
                                     /*稅別 gec01                             */
                                     /*輸入此批採購的稅別, 不可空白           */
pom22       varchar2(4),             /*币种                                   */
                                     /*幣別 azi01                             */
                                     /*輸入此批採購的幣別, 不可空白           */
pom25       varchar2(1),             /*状况码                                 */
                                     /*狀況碼                                 */
                                     /*正確值 x/0/1/2/6/9                     */
                                     /*X: 計劃訂單轉入                        */
                                     /*0: 開立(Open)                          */
                                     /*1: 已核准                              */
                                     /*2: 已轉採購單                          */
                                     /*6: 結案                                */
                                     /*9: 取消(Cancel)                        */
pom26       varchar2(10),            /*理由码                                 */
                                     /*理由碼 azf01,azf02='2'                 */
                                     /*狀況變更的理由, 可空白                 */
pom27       date,                    /*状况异动日期                           */
                                     /*狀況異動日期                           */
pom28       varchar2(10),            /*会计分类                               */
                                     /*會計分類                               */
                                     /*專案系統使用                           */
pom29       varchar2(24),            /*会计科目                               */
                                     /*會計科目 aag01                         */
                                     /*單據性質為  'EXP'，'SER'，'CAP' 時一定要*/
                                     /*輸入會計科目                           */
pom30       varchar2(1),             /*收货单打印否                           */
                                     /*收貨單列印否                           */
                                     /*正確值 Y/N                             */
                                     /*Y: 收貨時, 必須列印收貨單              */
                                     /*N: 收貨時, 可不列印收貨單              */
pom31       number(5),               /*会计年度                               */
                                     /*會計年度                               */
                                     /*該採購單所屬會計年度                   */
pom32       number(5),               /*会计期间                               */
                                     /*會計期間                               */
                                     /*該採購單所屬會計期間                   */
pom40       number(20,6),            /*总金额                                 */
                                     /*總金額                                 */
                                     /*系統維護                               */
                                     /*採購單身各項資料的  單價 * 數量 之總和 */
pom401      number(20,6),            /*代买总金额                             */
                                     /*代買總金額                             */
pom41       varchar2(6),             /*价格条件                               */
                                     /*價格條件 oah01                (97/06/19)*/
pom42       number(20,10),           /*汇率                                   */
                                     /*Exchange Rate                          */
                                     /*Value Must Greater Than Zero           */
                                     /*Need To Input Exchange Rate Of Home Currency -Foreign Currency When Currency Type Is Not Home Currency*/
pom43       number(9,4),             /*税率                                   */
                                     /*稅率  % default gec04                  */
                                     /*輸入此批採購的稅率, 為百分比           */
pom44       varchar2(1),             /*税处理                                 */
                                     /*稅處理                                 */
                                     /*0.可抵銷項稅額                         */
                                     /*1.可退還                               */
                                     /*2.不可扣抵                             */
                                     /*應付貨款時可預設                       */
pom45       varchar2(1),             /*可用/不可用                            */
                                     /*Usable/Unusable                        */
                                     /*This P/O Usable Or Not When Explode MRP，As The P/O Is Available Inventory Or Not When Srore-in*/
                                     /*P/O Body Is Unusable If P/O Head Is Unusable*/
                                     /*P/O Body Maybe Usable Or Unusable If P/O Head Is Usable*/
pom46       number(5),               /*预付比率                               */
                                     /*預付比率                               */
                                     /*由付款方式檔中預設值                   */
pom47       number(20,6),            /*预付金额                               */
                                     /*預付金額                               */
                                     /*採購單的金額 * 預付比率                */
pom48       number(20,6),            /*已结帐金额                             */
                                     /*已結帳金額                             */
pom49       varchar2(1),             /*预付发票否                             */
                                     /*預付發票否(Y/N)                        */
pomprsw     varchar2(1),             /*打印控制                               */
                                     /*Print control                          */
                                     /*To determine whether the Purchase List should be print.*/
                                     /*If choose 'Y',the system will do the corresponding*/
                                     /*process , there will be a virtual query feild if the*/
                                     /*print should be excute soon, and choose the print style*/
                                     /*when finish input. If choose'N' the system will push the*/
                                     /*Purchase List inputed to the print cache buffer and users*/
                                     /*can excute batch-print by Puechase System Waiting Print*/
                                     /*List.                                  */
pomprno     number(5),               /*已打印次数                             */
                                     /*Printed Times                          */
                                     /*Printed Times Of The P/O Can Ctrol Reinssue The P/O Because Of Reprinting*/
pomprdt     date,                    /*最后打印日期                           */
                                     /*Last Print Date                        */
                                     /*Last Print Date Of The P/O Help To Control Print And Inssue*/
pommksg     varchar2(1),             /*是否签核                               */
                                     /*Approve?                               */
                                     /*The Field Can Control The P/O Need Approved Or Not,If Need To Auto Give Approval Level Or Set Approval Level Oneself,Can Control It In Document Property, So Can also Control Approve By Document Property*/
pomsign     varchar2(4),             /*签核等级                               */
                                     /*簽核等級                               */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
                                     /*當此張採購單需作簽核處理時才顯示       */
pomdays     number(5),               /*签核完成天数                           */
                                     /*簽核完成天數                           */
pomprit     number(5),               /*签核优先等级                           */
                                     /*簽核優先等級                           */
pomsseq     number(5),               /*已签核顺序                             */
                                     /*已簽核順序                             */
                                     /*系統自動維護                           */
                                     /*此張採購單已簽的人數                   */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
                                     /*當此張採購單需作簽核處理時才顯示       */
pomsmax     number(5),               /*应签核顺序                             */
                                     /*應簽核順序                             */
                                     /*系統自動維護                           */
                                     /*此張採購單應簽的人數                   */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
                                     /*當此張採購單需作簽核處理時才顯示       */
pomacti     varchar2(1),             /*资料有效码                             */
pomuser     varchar2(10),            /*资料所有者                             */
pomgrup     varchar2(10),            /*资料所有部门                           */
pommodu     varchar2(10),            /*资料更改者                             */
pomdate     date,                    /*最近更改日                             */
pom40t      number(20,6),            /*含税总金额                             */
pomud01     varchar2(255),           /*自订字段-Textedit                      */
pomud02     varchar2(40),            /*自订字段-文字                          */
pomud03     varchar2(40),            /*自订字段-文字                          */
pomud04     varchar2(40),            /*自订字段-文字                          */
pomud05     varchar2(40),            /*自订字段-文字                          */
pomud06     varchar2(40),            /*自订字段-文字                          */
pomud07     number(15,3),            /*自订字段-数值                          */
pomud08     number(15,3),            /*自订字段-数值                          */
pomud09     number(15,3),            /*自订字段-数值                          */
pomud10     number(10),              /*自订字段-整数                          */
pomud11     number(10),              /*自订字段-整数                          */
pomud12     number(10),              /*自订字段-整数                          */
pomud13     date,                    /*自订字段-日期                          */
pomud14     date,                    /*自订字段-日期                          */
pomud15     date,                    /*自订字段-日期                          */
pomplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pomlegal    varchar2(10) NOT NULL,   /*所属法人                               */
pomoriu     varchar2(10),            /*资料建立者                             */
pomorig     varchar2(10)             /*资料建立部门                           */
);

create        index pom_02 on pom_file (pom09);
create        index pom_03 on pom_file (pom04);
alter table pom_file add  constraint pom_pk primary key  (pom01) enable validate;
grant select on pom_file to tiptopgp;
grant update on pom_file to tiptopgp;
grant delete on pom_file to tiptopgp;
grant insert on pom_file to tiptopgp;
grant index on pom_file to public;
grant select on pom_file to ods;
