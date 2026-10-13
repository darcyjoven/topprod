/*
================================================================================
檔案代號:pmk_file
檔案名稱:请购单单头
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pmk_file
(
pmk01       varchar2(20) NOT NULL,   /*请购单号                               */
                                     /*請購單號                               */
pmk02       varchar2(10),            /*请购单性质                             */
                                     /*請購單性質                             */
                                     /*正確值 REG/EXP/CAP/BKR/TAP             */
                                     /*－REG:REGular 一般性的採購             */
                                     /*－EXP:EXPensed 費用性的採購            */
                                     /*－CAP:CAPital 固定資產的採購           */
                                     /*－BKR:BlanKet Regular 無交期性的採購   */
                                     /*－TAP: TripleTrade 多角代採買。        */
pmk03       number(5),               /*更动序号                               */
                                     /*更動序號                               */
                                     /*請購單更動版本序號                     */
pmk04       date,                    /*请购日期                               */
                                     /*請購日期                               */
                                     /*請購單下單日期                         */
pmk05       varchar2(10),            /*项目号码                               */
                                     /*專案號碼--> no use(00/04/15)           */
pmk06       varchar2(10),            /*预算号码                               */
                                     /*預算號碼                               */
                                     /*如該有使用採購預算時可輸入             */
                                     /*如採用採購預算時, 系統應與應收帳款相連 */
pmk07       varchar2(10),            /*请购类型                               */
                                     /*請購類別                               */
                                     /*使用者可自行定義分類                   */
pmk08       varchar2(20),            /*PBI                                    */
pmk09       varchar2(10),            /*供应厂商                               */
                                     /*供應廠商pmc01                          */
                                     /*下單供應廠商                           */
pmk10       varchar2(10),            /*送货地址                               */
                                     /*送貨地址  pme01,pme02<>'1'             */
pmk11       varchar2(10),            /*帐单地址                               */
                                     /*帳單地址  pme01,pme02<>'0'             */
pmk12       varchar2(10),            /*请购员                                 */
                                     /*請購員 gen01                           */
pmk13       varchar2(10),            /*请购部门                               */
                                     /*請購部門 gem01                         */
pmk14       varchar2(10),            /*收货部门                               */
                                     /*收貨部門 gem01                         */
pmk15       varchar2(10),            /*审核人                                 */
                                     /*確認人                                 */
pmk16       varchar2(10),            /*运送方式                               */
                                     /*運送方式 ged01                         */
pmk17       varchar2(10),            /*代理商                                 */
                                     /*代理商   pmc01                         */
pmk18       varchar2(1),             /*审核否                                 */
                                     /*確認否(Y/N)                            */
                                     /*原'FOB條件'                            */
pmk20       varchar2(10),            /*付款条件                               */
                                     /*付款條件 pma01                         */
pmk21       varchar2(4),             /*税种                                   */
                                     /*稅別 gec01,gec011='1'                  */
pmk22       varchar2(4),             /*币种                                   */
                                     /*幣別 azi01                             */
pmk25       varchar2(1),             /*状况码                                 */
                                     /*狀況碼                                 */
                                     /*正確值 0/1/2/6/9                       */
                                     /*X: 計劃訂單轉入                        */
                                     /*0: 開立(Open)                          */
                                     /*1: 已核准                              */
                                     /*2: 轉成採購單                          */
                                     /*6: 結案                                */
                                     /*9: 作廢                                */
                                     /*S: 送簽中               # NO.6686      */
                                     /*R: 送簽退回                            */
                                     /*W: 抽單                                */
pmk26       varchar2(10),            /*理由码                                 */
                                     /*理由碼 azf01,azf02='2'                 */
pmk27       date,                    /*状况异动日期                           */
                                     /*狀況異動日期                           */
pmk28       varchar2(10),            /*会计分类                               */
                                     /*會計分類                  (專案系統使用)*/
pmk29       varchar2(24),            /*会计科目                               */
                                     /*會計科目aag01                          */
pmk30       varchar2(1),             /*收货单打印否                           */
                                     /*收貨單列印否                           */
                                     /*正確值 Y/N                             */
                                     /*Y: 收貨時, 必須列印收貨單              */
                                     /*N: 收貨時, 可不列印收貨單              */
pmk31       number(5),               /*会计年度                               */
                                     /*會計年度                               */
                                     /*該請購單所屬會計年度                   */
pmk32       number(5),               /*会计期间                               */
                                     /*會計期間                               */
                                     /*該請購單所屬會計期間                   */
pmk40       number(20,6),            /*总金额                                 */
                                     /*總金額                                 */
pmk401      number(13,3),            /*No Use                                 */
pmk41       varchar2(6),             /*价格条件                               */
                                     /*價格條件 oah01               (97/06/19)*/
pmk42       number(20,10),           /*汇率                                   */
                                     /*匯率  call s_curr3(pmk22,'B')          */
pmk43       number(9,4),             /*税率                                   */
                                     /*稅率  default gec04                    */
pmk45       varchar2(1),             /*可用/不可用                            */
pmkprsw     varchar2(1),             /*打印抑制                               */
                                     /*列印抑制                               */
pmkprno     number(5),               /*已打印次数                             */
                                     /*已列印次數                             */
pmkprdt     date,                    /*最后打印日期                           */
                                     /*最後列印日期                           */
pmkmksg     varchar2(1),             /*是否签核                               */
                                     /*是否簽核                               */
pmksign     varchar2(4),             /*签核等级                               */
                                     /*簽核等級                               */
pmkdays     number(5),               /*签核完成天数                           */
                                     /*簽核完成天數                           */
pmkprit     number(5),               /*签核优先等级                           */
                                     /*簽核優先等級                           */
pmksseq     number(5),               /*已签核顺序                             */
                                     /*已簽核順序                             */
                                     /*系統維護                               */
pmksmax     number(5),               /*应签核顺序                             */
                                     /*應簽核順序                             */
                                     /*系統維護                               */
pmkacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
pmkuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
pmkgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
pmkmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
pmkdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
pmkud01     varchar2(255),           /*用户自订字段                           */
pmkud02     varchar2(40),            /*委外单号                               */
pmkud03     varchar2(40),            /*用户自订字段                           */
pmkud04     varchar2(40),            /*用户自订字段                           */
pmkud05     varchar2(40),            /*用户自订字段                           */
pmkud06     varchar2(40),            /*用户自订字段                           */
pmkud07     number(15,3),            /*用户自订字段                           */
pmkud08     number(15,3),            /*用户自订字段                           */
pmkud09     number(15,3),            /*用户自订字段                           */
pmkud10     number(10),              /*用户自订字段                           */
pmkud11     number(10),              /*用户自订字段                           */
pmkud12     number(10),              /*用户自订字段                           */
pmkud13     date,                    /*用户自订字段                           */
pmkud14     date,                    /*用户自订字段                           */
pmkud15     date,                    /*用户自订字段                           */
pmk46       varchar2(1) DEFAULT '1' NOT NULL, /*來源類型 1-手動錄入,2-補貨建 */
                                     /*Types of Sources: 1-Manual Entry 2-Replenish Suggestion 3-Sales Orders 4-Requisition Distribution*/
pmk47       varchar2(10),            /*取货营运中心                           */
pmk48       varchar2(8),             /*请购时间                               */
pmkcond     date,                    /*审核时间                               */
pmkconu     varchar2(10),            /*审核人员                               */
pmkcrat     date,                    /*资料创建日                             */
pmkcont     varchar2(8),             /*审核时间                               */
pmkplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pmklegal    varchar2(10) NOT NULL,   /*所属法人                               */
pmkoriu     varchar2(10),            /*资料建立者                             */
pmkorig     varchar2(10),            /*资料建立部门                           */
pmk49       varchar2(20),            /*POS单号                                */
pmk50       varchar2(10),            /*生产营运中心                           */
pmk51       varchar2(20)             /*要貨模板編號                           */
);

alter table pmk_file add  constraint pmk_pk primary key  (pmk01) enable validate;
grant select on pmk_file to tiptopgp;
grant update on pmk_file to tiptopgp;
grant delete on pmk_file to tiptopgp;
grant insert on pmk_file to tiptopgp;
grant index on pmk_file to public;
grant select on pmk_file to ods;
