/*
================================================================================
檔案代號:alk_file
檔案名稱:信用状到货单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table alk_file
(
alk01       varchar2(20) NOT NULL,   /*到货单号                               */
                                     /*到貨單號                               */
alk02       date,                    /*到货日期                               */
                                     /*到貨日期(存貨立帳日期)                 */
alk03       varchar2(20),            /*预购单号                               */
alk04       varchar2(10),            /*帐款部门                               */
                                     /*帳款部門                               */
alk05       varchar2(10),            /*付款厂商                               */
                                     /*付款廠商                               */
alk07       varchar2(20),            /*到单单号                               */
                                     /*到單單號                               */
alk08       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
alk10       varchar2(10),            /*付款条件                               */
                                     /*付款條件 (LC, TT, OA, DA, DP) 001114   */
alk11       varchar2(4),             /*到货币种                               */
                                     /*到貨幣別                               */
alk12       number(20,10),           /*到货汇率                               */
                                     /*到貨匯率 (先到單則以到單匯率,否則預估) */
alk13       number(20,6),            /*到货原币                               */
                                     /*到貨原幣                               */
alk16       number(20,6),            /*应还本币                               */
                                     /*到貨本幣                               */
alk23       number(20,6),            /*预估应付费用合计                       */
                                     /*預估應付費用合計                       */
alk24       number(10),              /*No Use                                 */
alk25       number(20,6),            /*到货应摊本币                           */
                                     /*到貨應攤本幣                           */
alk26       number(20,6),            /*预购应摊                               */
                                     /*預購應攤                               */
alk27       number(20,6),            /*汇差应摊                               */
alk33       number(20,6),            /*后到单额(原币)                         */
                                     /*後到單額(原幣)                         */
alk37       number(20,10),           /*先到单时的到单汇率                     */
                                     /*先到單時的到單匯率                 11/11*/
alk38       number(20,6),            /*先到单时的到单原币金额                 */
                                     /*先到單時的到單原幣金額             11/11*/
alk39       number(20,6),            /*先到单时的到单本币金额                 */
                                     /*先到單時的到單本幣金額             11/11*/
alk40       varchar2(24),            /*预付科目                               */
                                     /*預付科目 (會計分錄)                    */
alk41       varchar2(24),            /*短期借款                               */
                                     /*短期借款 (會計分錄)                    */
alk42       varchar2(24),            /*代付费用                               */
                                     /*代付費用 (會計分錄)                    */
alk43       varchar2(24),            /*暂估应付                               */
                                     /*暫估應付 (會計分錄)                    */
alk44       varchar2(24),            /*存货科目                               */
                                     /*存貨科目 (會計分錄)                11/11*/
alk45       varchar2(24),            /*立帐差异科目                           */
                                     /*立帳差異科目                       11/11*/
alk46       varchar2(20),            /*Invoice No                             */
                                     /*Invoice No   99/05/11 add              */
alk70       varchar2(1),             /*已分摊否                               */
                                     /*已分攤否(Y/N) Default='N'              */
alk72       varchar2(20),            /*到货凭证编号                           */
                                     /*到貨傳票編號                           */
alk74       varchar2(20),            /*付款凭证编号                           */
                                     /*付款傳票編號                           */
alkfirm     varchar2(1),             /*确认码                                 */
                                     /*確認碼                                 */
alkinpd     date,                    /*录入日期                               */
                                     /*輸入日期                               */
alkacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
alkuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
alkgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
alkmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
alkdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
alk930      varchar2(10),            /*成本中心                               */
alk401      varchar2(24),            /*预付科目二                             */
alk411      varchar2(24),            /*短期借款二                             */
alk421      varchar2(24),            /*代付费用二                             */
alk431      varchar2(24),            /*暂估应付二                             */
alk441      varchar2(24),            /*存贷科目二                             */
alk451      varchar2(24),            /*立帐差异科目二                         */
alkud01     varchar2(255),           /*自订字段-Textedit                      */
alkud02     varchar2(40),            /*自订字段-文字                          */
alkud03     varchar2(40),            /*自订字段-文字                          */
alkud04     varchar2(40),            /*自订字段-文字                          */
alkud05     varchar2(40),            /*自订字段-文字                          */
alkud06     varchar2(40),            /*自订字段-文字                          */
alkud07     number(15,3),            /*自订字段-数值                          */
alkud08     number(15,3),            /*自订字段-数值                          */
alkud09     number(15,3),            /*自订字段-数值                          */
alkud10     number(10),              /*自订字段-整数                          */
alkud11     number(10),              /*自订字段-整数                          */
alkud12     number(10),              /*自订字段-整数                          */
alkud13     date,                    /*自订字段-日期                          */
alkud14     date,                    /*自订字段-日期                          */
alkud15     date,                    /*自订字段-日期                          */
alklegal    varchar2(10) NOT NULL,   /*所属法人                               */
alk97       varchar2(10),            /*采购营运中心编号                       */
alkoriu     varchar2(10),            /*资料建立者                             */
alkorig     varchar2(10)             /*资料建立部门                           */
);

create        index alk_02 on alk_file (alk02);
create        index alk_03 on alk_file (alk03);
create        index alk_05 on alk_file (alk72);
create        index alk_04 on alk_file (alk07);
alter table alk_file add  constraint alk_pk primary key  (alk01) enable validate;
grant select on alk_file to tiptopgp;
grant update on alk_file to tiptopgp;
grant delete on alk_file to tiptopgp;
grant insert on alk_file to tiptopgp;
grant index on alk_file to public;
grant select on alk_file to ods;
