/*
================================================================================
檔案代號:nmp_file
檔案名稱:银行存款统计档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table nmp_file
(
nmp01       varchar2(20) DEFAULT ' ' NOT NULL, /*银行编号*/
                                     /*銀行編號                               */
nmp02       number(5) NOT NULL,      /*年度                                   */
nmp03       number(5) NOT NULL,      /*月份                                   */
nmp04       number(20,6) NOT NULL,   /*出纳存入合计                           */
                                     /*出納存入合計(原幣)                     */
nmp05       number(20,6) NOT NULL,   /*出纳提出合计                           */
                                     /*出納提出合計(原幣)                     */
nmp06       number(20,6) NOT NULL,   /*出纳结存合计                           */
                                     /*出納結存合計(原幣)                     */
nmp07       number(20,6) NOT NULL,   /*出纳存入合计                           */
                                     /*出納存入合計(本幣)                     */
nmp08       number(20,6) NOT NULL,   /*出纳提出合计                           */
                                     /*出納提出合計(本幣)                     */
nmp09       number(20,6) NOT NULL,   /*出纳结存合计                           */
                                     /*出納結存合計(本幣)                     */
nmp14       number(20,6) NOT NULL,   /*总帐存入合计                           */
                                     /*總帳存入合計(原幣)                     */
nmp15       number(20,6) NOT NULL,   /*总帐提出合计                           */
                                     /*總帳提出合計(原幣)                     */
nmp16       number(20,6) NOT NULL,   /*总帐结存合计                           */
                                     /*總帳結存合計(原幣)                     */
nmp17       number(20,6) NOT NULL,   /*总帐存入合计                           */
                                     /*總帳存入合計(本幣)                     */
nmp18       number(20,6) NOT NULL,   /*总帐提出合计                           */
                                     /*總帳提出合計(本幣)                     */
nmp19       number(20,6) NOT NULL,   /*总帐结存合计                           */
                                     /*總帳結存合計(本幣)                     */
nmplegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table nmp_file add  constraint nmp_pk primary key  (nmp01,nmp02,nmp03) enable validate;
grant select on nmp_file to tiptopgp;
grant update on nmp_file to tiptopgp;
grant delete on nmp_file to tiptopgp;
grant insert on nmp_file to tiptopgp;
grant index on nmp_file to public;
grant select on nmp_file to ods;
