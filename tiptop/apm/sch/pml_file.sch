/*
================================================================================
檔案代號:pml_file
檔案名稱:请购单单身
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pml_file
(
pml01       varchar2(20) NOT NULL,   /*请购单号                               */
                                     /*請購單號  pmk01                        */
pml011      varchar2(10),            /*采购性质                               */
                                     /*單據性質                               */
                                     /*正確值 REG/EXP/SER/CAP/BKR/SUB/DAS/IPO */
                                     /* /RTN                                  */
                                     /*REG:REGular          一般性  採購      */
                                     /*EXP:EXPensed         消耗性  採購      */
                                     /*SER:SERvice          服務性  採購      */
                                     /*CAP:CAPital          資材性  採購      */
                                     /*BKR:BlanKet Regular  無交期性採購      */
                                     /*SUB:SUBcontracted    廠外加工採購      */
                                     /*DAS:De-assembly      套件    採購      */
                                     /*IPO:InterLogistics       多工廠  採購  */
                                     /*RTN:Returned         退貨補貨採購      */
pml02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
                                     /*請購單所含蓋的項目編號                 */
pml03       varchar2(20),            /*询价单号                               */
                                     /*詢價單號                               */
                                     /*廠商詢價的詢價單單號                   */
pml04       varchar2(40),            /*料件编号                               */
                                     /*料件編號 ima01                         */
                                     /*請購料件編號                           */
pml041      varchar2(120),           /*品名规格                               */
                                     /*品名規格                               */
                                     /*存放 MISC 料件                         */
pml05       varchar2(32),            /*APS单据编号                            */
                                     /*APS單據編號   no.4649 02/03/15(modify) */
pml06       varchar2(255),           /*备注                                   */
                                     /*備註                            (97/08)*/
pml07       varchar2(4),             /*请购单位                               */
                                     /*請購單位 gfe01                         */
                                     /*請購單上請購數量單位                   */
pml08       varchar2(4),             /*库存单位                               */
                                     /*庫存單位 default ima25                 */
                                     /*料件庫存單位                           */
pml09       number(20,8),            /*转换率                                 */
                                     /*轉換率                                 */
                                     /*請購單位/庫存單位的轉換率              */
pml10       varchar2(10),            /*检验码                                 */
                                     /*檢驗碼                                 */
                                     /*設定檢驗的類別代碼                     */
pml11       varchar2(1),             /*冻结码                                 */
                                     /*凍結碼                                 */
                                     /*請購時程確定碼                         */
                                     /*正確值 Y/N                             */
                                     /*Y: MRP重新作業時, 不可重推採購需求時距 */
                                     /*N: MRP重新作業時,   可重推採購需求時距 */
pml12       varchar2(10),            /*项目编号                               */
                                     /*專案代號(00/04/15)                     */
pml121      varchar2(30),            /*WBS编号                                */
                                     /*專案代號-順序(00/01/24)                */
pml122      varchar2(4),             /*活动编号                               */
                                     /*專案代號-項次(00/01/24)                */
pml123      varchar2(24),            /*厂牌                                   */
                                     /*廠牌                         (97/12 add)*/
pml13       number(9,4),             /*超/短交限率                            */
                                     /*允許可超交/短交數量比率                */
pml14       varchar2(1),             /*部份交货否                             */
                                     /*部份交貨否(Y/N)                        */
pml15       varchar2(1),             /*提前交货否                             */
                                     /*提前交貨否(Y/N)                        */
pml16       varchar2(1),             /*状况码                                 */
                                     /*狀況碼                                 */
                                     /*正確值 0/1/2/6/7/8/9                   */
                                     /*X: 計劃訂單轉入                        */
                                     /*0: 開立(Open)                          */
                                     /*1: 已核准                              */
                                     /*2: 轉成採購單                          */
                                     /*6: 結案-正常                           */
                                     /*7: 結案-結長                           */
                                     /*8: 結案-結短                           */
                                     /*9: 作廢(Cancel)                        */
pml18       date,                    /*MRP 需求日期                           */
                                     /*該請購料件的MRP/MPS計劃訂單需求日期    */
pml20       number(15,3),            /*订购量                                 */
                                     /*訂購量                           (97/07)*/
                                     /*請購數量                               */
                                     /*單位為請購單位                         */
pml21       number(15,3),            /*已转采购数量                           */
                                     /*已轉採購數量                     (97/07)*/
                                     /*被轉成採購的累計數量                   */
                                     /*單位為請購單位                         */
pml23       varchar2(1),             /*课税否                                 */
                                     /*課稅否                                 */
                                     /*該請購單項次(料伴)是否需課稅           */
                                     /*正確值 Y/N                             */
                                     /*Y: 需課稅, 稅率按請購單單頭            */
                                     /*N: 不需課稅                            */
pml30       number(20,6),            /*标准价格                               */
                                     /*標準價格                               */
                                     /*價格單位為本幣                         */
pml31       number(20,6),            /*税前单价                               */
                                     /*單價                                   */
                                     /*價格單位為按請購單單頭幣別             */
                                     /*匯率採用請購單單頭匯率                 */
pml32       number(20,6),            /*采购价差                               */
                                     /*採購價差 - PPV                         */
                                     /*採購價差 = 單價 * 匯率 - 標準價格      */
                                     /*價差單位為本幣                         */
pml33       date,                    /*交货日期                               */
                                     /*交貨日期                               */
                                     /*預定供應廠商發貨日期                   */
pml34       date,                    /*到厂日期                               */
                                     /*到廠日期                               */
                                     /*該請購單項次到 本公司/廠房/檢驗區 日期 */
                                     /*如為部份交貨, 則記錄最近一次日期       */
pml35       date,                    /*到库日期                               */
                                     /*到庫日期                               */
                                     /*該請購單項次 入到 庫房 日期            */
                                     /*如為部份交貨, 則記錄最近一次日期       */
pml38       varchar2(1),             /*可用/不可用                            */
                                     /*Usable/Unusable                        */
                                     /*Item Of The P/O Line # is Available Inventory, If User Have Sepecial Usage Can Define It To UnAvailable Inventory*/
pml40       varchar2(24),            /*会计科目                               */
                                     /*會計科目 aag01                         */
                                     /*該筆請購單項次所屬會計科目             */
                                     /*當請購單性質為 EXP/SER/CAP 時需輸入    */
pml41       varchar2(20),            /*PLP NO(MRP版本+序)                     */
                                     /*當請購單為MRP/PLP轉入時,儲存原MRP版本+序*/
pml42       varchar2(1) NOT NULL,    /*替代码                                 */
                                     /*替代碼                                 */
                                     /*儲存該工單備料的料件為原始組合的下階料 */
                                     /*件或採用取/替代料件                    */
                                     /*正確值 0/1/2/S/U                       */
                                     /*0: 原始料件, 不可被替代                */
                                     /*1: 原始料件, 可以被替代                */
                                     /*2: 原始料件, 已經被替代                */
                                     /*S: 替代料件                            */
                                     /*U: 取代料件                            */
pml43       number(5),               /*作业序号                               */
                                     /*作業序號                               */
                                     /*如為專屬的廠外加工則本欄位值為0        */
pml431      number(5),               /*下一站之作业序号                       */
                                     /*下一站之作業序號                       */
                                     /*如為專屬的廠外加工則本欄位值為0        */
pml44       number(20,6),            /*本币单价                               */
                                     /*本幣單價                               */
                                     /*如幣別非本幣時, 本幣單價 <> 單價       */
                                     /*價格單位為本幣                         */
                                     /*匯率為請購單單頭匯率                   */
                                     /*系統維護                               */
pml45       varchar2(20),            /*制单号                                 */
pml46       varchar2(10),            /*No Use                                 */
pml66       varchar2(10),            /*预算编号                               */
                                     /*預算編號  (For 請採購預算)             */
pml67       varchar2(10),            /*部门编号                               */
                                     /*部門編號  (For 請採購預算)             */
pml80       varchar2(4),             /*单位一                                 */
pml81       number(20,8),            /*单位一换算率(与采购单位)               */
pml82       number(15,3),            /*单位一数量                             */
pml83       varchar2(4),             /*单位二                                 */
pml84       number(20,8),            /*单位二换算率(与采购单位)               */
pml85       number(15,3),            /*单位二数量                             */
pml86       varchar2(4),             /*计价单位                               */
pml87       number(15,3),            /*计价数量                               */
pml88       number(20,6),            /*税前金额                               */
pml88t      number(20,6),            /*含税金额                               */
pml31t      number(20,6),            /*含税单价                               */
pml190      varchar2(1),             /*统购否                                 */
pml191      varchar2(10),            /*采购中心代码                           */
pml192      varchar2(1),             /*统购抛转                               */
pml930      varchar2(10),            /*成本中心                               */
pml24       varchar2(20),            /*来源单号                               */
pml25       number(5),               /*来源项次                               */
pml401      varchar2(24),            /*会计科目二                             */
pml90       varchar2(10),            /*费用原因                               */
pmlud01     varchar2(255),           /*自订字段-Textedit                      */
pmlud02     varchar2(40),            /*批号                                   */
pmlud03     varchar2(40),            /*自订字段-文字                          */
pmlud04     varchar2(40),            /*自订字段-文字                          */
pmlud05     varchar2(40),            /*自订字段-文字                          */
pmlud06     varchar2(40),            /*自订字段-文字                          */
pmlud07     number(15,3),            /*自订字段-数值                          */
pmlud08     number(15,3),            /*自订字段-数值                          */
pmlud09     number(15,3),            /*自订字段-数值                          */
pmlud10     number(10),              /*自订字段-整数                          */
pmlud11     number(10),              /*自订字段-整数                          */
pmlud12     number(10),              /*自订字段-整数                          */
pmlud13     date,                    /*自订字段-日期                          */
pmlud14     date,                    /*自订字段-日期                          */
pmlud15     date,                    /*自订字段-日期                          */
pml91       varchar2(1) DEFAULT ' ' NOT NULL, /*是否急料*/
pml47       varchar2(40),            /*产品条码                               */
pml48       varchar2(10),            /*供应商代码                             */
pml49       varchar2(1) DEFAULT ' ' NOT NULL, /*经营方式 1-经销,2-成本代销,3- */
pml50       varchar2(1) DEFAULT '1' NOT NULL, /*采购类型 1-自订货,2-统采直供,*/
pml51       varchar2(10),            /*源头营运中心                           */
pml52       varchar2(20),            /*源头单号                               */
pml53       number(5),               /*源头项次                               */
pml54       varchar2(1) DEFAULT ' ' NOT NULL, /*需求类型 1.补货 2.订货*/
pml55       varchar2(8),             /*交货时间                               */
pml56       varchar2(1) DEFAULT ' ' NOT NULL, /*转出状态1-未转出 2-已转出 3-  */
pmlplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pmllegal    varchar2(10) NOT NULL,   /*所属法人                               */
pml92       varchar2(1) DEFAULT 'N' NOT NULL, /*电子采购否*/
pml93       varchar2(15),            /*电子采购序号                           */
pml919      varchar2(50),            /*计画批号                               */
pml57       varchar2(10)             /*仓库                                   */
);

create        index pml_03 on pml_file (pml41);
create        index pml_02 on pml_file (pml04);
alter table pml_file add  constraint pml_pk primary key  (pml01,pml02) enable validate;
grant select on pml_file to tiptopgp;
grant update on pml_file to tiptopgp;
grant delete on pml_file to tiptopgp;
grant insert on pml_file to tiptopgp;
grant index on pml_file to public;
grant select on pml_file to ods;
