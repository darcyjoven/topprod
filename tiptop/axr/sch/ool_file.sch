/*
================================================================================
檔案代號:ool_file
檔案名稱:缺省会计科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ool_file
(
ool01       varchar2(10) NOT NULL,   /*科目分类码                             */
                                     /*科目分類碼                             */
ool02       varchar2(80),            /*科目分类说明                           */
                                     /*科目分類說明                           */
ool11       varchar2(24),            /*应收帐款科目                           */
                                     /*應收帳款科目                           */
ool12       varchar2(24),            /*应收票据科目                           */
                                     /*應收票據科目                           */
ool13       varchar2(24),            /*应收退票科目                           */
                                     /*應收退票科目                           */
ool14       varchar2(24),            /*销退税额科目                           */
                                     /*銷退稅額科目                           */
ool15       varchar2(24),            /*暂估应收科目                           */
ool21       varchar2(24),            /*预收订金科目                           */
                                     /*預收訂金科目                           */
ool22       varchar2(24),            /*暂收(收票)科目                         */
                                     /*暫收(收票)科目                         */
ool23       varchar2(24),            /*暂收(ＴＴ)科目                         */
                                     /*暫收(ＴＴ)科目                         */
ool24       varchar2(24),            /*暂收(押汇)科目                         */
                                     /*暫收(押匯)科目                         */
ool25       varchar2(24),            /*暂收(溢收)科目                         */
                                     /*暫收(溢收)科目                         */
ool26       varchar2(24),            /*应付销退款科目                         */
                                     /*應付銷退款科目                         */
ool27       varchar2(24),            /*备抵呆帐科目                           */
                                     /*備抵呆帳科目                           */
ool28       varchar2(24),            /*销项税额科目                           */
                                     /*銷項稅額科目                           */
ool29       varchar2(20),            /*No Use                                 */
ool41       varchar2(24),            /*销货收入科目                           */
                                     /*銷貨收入科目                           */
ool42       varchar2(24),            /*销退折让科目                           */
                                     /*銷退折讓科目                           */
ool43       varchar2(24),            /*销货成本科目                           */
                                     /*銷貨成本科目                           */
ool44       varchar2(24),            /*销货成本退回科目                       */
                                     /*銷貨成本退回科目                       */
ool45       varchar2(24),            /*应收信用状科目                         */
                                     /*應收信用狀科目                         */
ool46       varchar2(24),            /*存入信用状科目                         */
                                     /*存入信用狀科目                         */
ool47       varchar2(24),            /*销货折让科目                           */
ool48       varchar2(20),            /*No Use                                 */
ool49       varchar2(20),            /*No Use                                 */
ool51       varchar2(24),            /*收款折扣科目                           */
ool52       varchar2(24),            /*汇兑损失科目                           */
                                     /*匯兌損失科目                           */
ool53       varchar2(24),            /*汇兑收益科目                           */
                                     /*匯兌收益科目                           */
ool54       varchar2(24),            /*呆帐损失科目                           */
                                     /*呆帳損失科目                           */
ool111      varchar2(24),            /*应收帐款科目二                         */
ool121      varchar2(24),            /*应收票据科目二                         */
ool131      varchar2(24),            /*应收退票科目二                         */
ool141      varchar2(24),            /*销退税额科目二                         */
ool211      varchar2(24),            /*预收订金科目二                         */
ool221      varchar2(24),            /*暂收(收票)科目二                       */
ool231      varchar2(24),            /*暂收(ＴＴ)科目二                       */
ool241      varchar2(24),            /*暂收(押汇)科目二                       */
ool251      varchar2(24),            /*暂收(溢收)科目二                       */
ool261      varchar2(24),            /*应付销退款科目二                       */
ool271      varchar2(24),            /*备抵呆帐科目二                         */
ool281      varchar2(24),            /*销项税额科目二                         */
ool411      varchar2(24),            /*销货收入科目二                         */
ool421      varchar2(24),            /*销退折让科目二                         */
ool431      varchar2(24),            /*销货成本科目二                         */
ool441      varchar2(24),            /*销货成本退回科目二                     */
ool451      varchar2(24),            /*应收信用状科目二                       */
ool461      varchar2(24),            /*存入信用状科目二                       */
ool471      varchar2(24),            /*销货折让科目二                         */
ool511      varchar2(24),            /*收款折扣科目二                         */
ool521      varchar2(24),            /*汇兑损失科目二                         */
ool531      varchar2(24),            /*汇兑收益科目二                         */
ool541      varchar2(24),            /*呆帐损失科目二                         */
ool151      varchar2(24),            /*暂估应收科目二                         */
oolud01     varchar2(255),           /*自订字段-Textedit                      */
oolud02     varchar2(40),            /*自订字段-文字                          */
oolud03     varchar2(40),            /*自订字段-文字                          */
oolud04     varchar2(40),            /*自订字段-文字                          */
oolud05     varchar2(40),            /*自订字段-文字                          */
oolud06     varchar2(40),            /*自订字段-文字                          */
oolud07     number(15,3),            /*自订字段-数值                          */
oolud08     number(15,3),            /*自订字段-数值                          */
oolud09     number(15,3),            /*自订字段-数值                          */
oolud10     number(10),              /*自订字段-整数                          */
oolud11     number(10),              /*自订字段-整数                          */
oolud12     number(10),              /*自订字段-整数                          */
oolud13     date,                    /*自订字段-日期                          */
oolud14     date,                    /*自订字段-日期                          */
oolud15     date,                    /*自订字段-日期                          */
ool31       varchar2(24),            /*券借方科目                             */
ool311      varchar2(24),            /*券借方科目二                           */
ool32       varchar2(24),            /*券贷方科目                             */
ool321      varchar2(24),            /*券贷方科目二                           */
ool33       varchar2(24),            /*溢退待抵科目                           */
ool331      varchar2(24),            /*溢退待抵科目二                         */
ool34       varchar2(24),            /*转费用科目                             */
ool341      varchar2(24),            /*转费用科目二                           */
ool35       varchar2(24),            /*转收入科目                             */
ool351      varchar2(24),            /*转收入科目二                           */
ool36       varchar2(24),            /*代收科目                               */
ool361      varchar2(24),            /*代收科目二                             */
ool55       varchar2(24),            /*健康捐科目                             */
ool551      varchar2(24),            /*健康捐科目二                           */
ool40       varchar2(24),            /*外销收入科目                           */
ool401      varchar2(24),            /*外销收入科目二                         */
ool56       varchar2(24),            /*账扣科目                               */
ool561      varchar2(24)             /*账扣科目二                             */
);

alter table ool_file add  constraint ool_pk primary key  (ool01) enable validate;
grant select on ool_file to tiptopgp;
grant update on ool_file to tiptopgp;
grant delete on ool_file to tiptopgp;
grant insert on ool_file to tiptopgp;
grant index on ool_file to public;
grant select on ool_file to ods;
