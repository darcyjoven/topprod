/*
================================================================================
檔案代號:aps_file
檔案名稱:部门预设会计科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aps_file
(
aps01       varchar2(10) NOT NULL,   /*部门编号                               */
                                     /*部門編號                               */
aps11       varchar2(24),            /*现金科目                               */
                                     /*現金科目                               */
aps12       varchar2(24),            /*预付帐款科目                           */
                                     /*預付帳款科目                           */
aps13       varchar2(24),            /*暂付帐款科目                           */
                                     /*暫付帳款科目                           */
aps14       varchar2(24),            /*开状预付购料款科目                     */
                                     /*開狀預付購料款科目                     */
aps21       varchar2(24),            /*未开发票应付帐款科目                   */
                                     /*未開發票應付帳款科目                   */
aps22       varchar2(24),            /*应付帐款科目                           */
                                     /*應付帳款科目                           */
aps23       varchar2(24),            /*应付费用科目                           */
                                     /*應付費用科目                           */
aps231      varchar2(24),            /*预估应付保险费科目                     */
                                     /*預估應付保險費科目                     */
aps232      varchar2(24),            /*预估应付报关杂费科目                   */
                                     /*預估應付報關雜費科目                   */
aps233      varchar2(24),            /*代付费用科目                           */
                                     /*代付費用科目                           */
aps234      varchar2(24),            /*在途存货科目                           */
                                     /*在途存貨科目(可設為與 aps14 相同)      */
aps24       varchar2(24),            /*应付票据科目                           */
                                     /*應付票據科目                           */
aps25       varchar2(24),            /*银行借款科目                           */
                                     /*銀行借款科目                           */
aps40       varchar2(24),            /*购货退回科目                           */
                                     /*購貨退回科目(未折讓)                   */
aps41       varchar2(24),            /*进货折让科目                           */
                                     /*進貨折讓科目                           */
aps42       varchar2(24),            /*汇差损失科目                           */
                                     /*匯差損失科目                           */
aps43       varchar2(24),            /*汇差收益科目                           */
                                     /*匯差收益科目                           */
aps44       varchar2(24),            /*价格差异科目/采购价差科目              */
                                     /*價格差異科目/採購價差科目              */
aps45       varchar2(24),            /*存货科目                               */
                                     /*存貨科目                               */
aps46       varchar2(24),            /*手续费科目                             */
                                     /*手續費科目                             */
aps47       varchar2(24),            /*邮资科目                               */
                                     /*郵資科目                               */
aps51       varchar2(24),            /*立帐差异科目                           */
                                     /*立帳差異科目(到單與到貨差異)           */
aps52       varchar2(24),            /*暂估利息费用                           */
                                     /*暫估利息費用                           */
aps53       varchar2(24),            /*应付暂估利息                           */
                                     /*應付暫估利息                           */
aps54       varchar2(24),            /*利差损失科目                           */
                                     /*利差損失科目                           */
aps55       varchar2(24),            /*利差收益科目                           */
aps56       varchar2(24),            /*代付汇票科目                           */
                                     /*代付匯票科目                           */
aps57       varchar2(24),            /*转帐手续科目                           */
aps58       varchar2(24),            /*应付电汇科目                           */
aps59       varchar2(24),            /*No Use                                 */
aps60       varchar2(24),            /*No Use                                 */
apsacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
apsuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
apsgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
apsmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
apsdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
aps111      varchar2(24),            /*现金科目二                             */
aps121      varchar2(24),            /*预付帐款科目二                         */
aps131      varchar2(24),            /*暂付帐款科目二                         */
aps141      varchar2(24),            /*开状预付购料款科目二                   */
aps211      varchar2(24),            /*未开发票应付帐款科目二                 */
aps221      varchar2(24),            /*应付帐款科目二                         */
aps235      varchar2(24),            /*应付帐款科目二                         */
aps236      varchar2(24),            /*预估应付保险费科目二                   */
aps237      varchar2(24),            /*预估应付报关杂费科目二                 */
aps238      varchar2(24),            /*代付费用科目二                         */
aps239      varchar2(24),            /*在途存货科目二                         */
aps241      varchar2(24),            /*应付票据科目二                         */
aps251      varchar2(24),            /*银行借款科目二                         */
aps401      varchar2(24),            /*购货退回科目二                         */
aps411      varchar2(24),            /*进货折让科目二                         */
aps421      varchar2(24),            /*汇差损失科目二                         */
aps431      varchar2(24),            /*汇差收益科目二                         */
aps441      varchar2(24),            /*价格差异科目二/采购价差科目            */
aps451      varchar2(24),            /*存货科目二                             */
aps461      varchar2(24),            /*手续费科目二                           */
aps471      varchar2(24),            /*邮资科目二                             */
aps511      varchar2(24),            /*立帐差异科目二                         */
aps541      varchar2(24),            /*利差损失科目二                         */
aps551      varchar2(24),            /*利差收益科目二                         */
aps561      varchar2(24),            /*代付汇票科目二                         */
aps571      varchar2(24),            /*转帐手续科目二                         */
aps581      varchar2(24),            /*应付电汇科目二                         */
aps521      varchar2(24),            /*暂估利息费用二                         */
aps531      varchar2(24),            /*应付暂估利息二                         */
apsoriu     varchar2(10),            /*资料建立者                             */
apsorig     varchar2(10),            /*资料建立部门                           */
aps61       varchar2(24),            /*溢退科目                               */
aps611      varchar2(24),            /*溢退科目二                             */
aps02       varchar2(4),             /*暂估税种                               */
aps03       varchar2(4)              /*预付税种                               */
);

alter table aps_file add  constraint aps_pk primary key  (aps01) enable validate;
grant select on aps_file to tiptopgp;
grant update on aps_file to tiptopgp;
grant delete on aps_file to tiptopgp;
grant insert on aps_file to tiptopgp;
grant index on aps_file to public;
grant select on aps_file to ods;
