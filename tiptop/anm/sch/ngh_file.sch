/*
================================================================================
檔案代號:ngh_file
檔案名稱:集团追索天数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ngh_file
(
ngh00       varchar2(1) NOT NULL,    /*key value(0)                           */
ngh01       number(5),               /*订单[+]                                */
ngh02       number(5),               /*销货单[+]                              */
ngh03       number(5),               /*应收帐款[+]                            */
ngh04       number(5),               /*应收票据[+]                            */
ngh05       number(5),               /*采购单[-]                              */
ngh06       number(5),               /*入库单[-]                              */
ngh07       number(5),               /*应付帐款[-]                            */
ngh08       number(5),               /*应付票据[-]                            */
ngh09       number(5),               /*应收利息[+]                            */
ngh10       number(5),               /*应付利息[-]                            */
ngh11       number(5),               /*短期融资到期[-]                        */
ngh12       number(5),               /*中期融资到期[-]                        */
ngh13       number(5),               /*投资[+]                                */
ngh14       number(5),               /*外汇[+]                                */
ngh15       number(3)                /*No Use                                 */
);

alter table ngh_file add  constraint ngh_pk primary key  (ngh00) enable validate;
grant select on ngh_file to tiptopgp;
grant update on ngh_file to tiptopgp;
grant delete on ngh_file to tiptopgp;
grant insert on ngh_file to tiptopgp;
grant index on ngh_file to public;
grant select on ngh_file to ods;
