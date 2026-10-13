/*
================================================================================
檔案代號:ayc_file
檔案名稱:股东权益传票明细群组归属档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ayc_file
(
ayc01       varchar2(10) NOT NULL,   /*公司编号                               */
ayc02       varchar2(5) NOT NULL,    /*帐套                                   */
ayc03       varchar2(4) NOT NULL,    /*币种                                   */
ayc04       number(5) NOT NULL,      /*年度                                   */
ayc05       number(5) NOT NULL,      /*期别                                   */
ayc06       date NOT NULL,           /*凭证日期                               */
ayc07       varchar2(20) NOT NULL,   /*凭证编号                               */
ayc08       number(10) NOT NULL,     /*项次                                   */
ayc09       varchar2(80),            /*摘要                                   */
ayc10       varchar2(24),            /*会计科目                               */
ayc11       varchar2(1),             /*借贷方                                 */
ayc12       number(20,6),            /*金额                                   */
ayc13       varchar2(10)             /*群组分类                               */
);

alter table ayc_file add  constraint ayc_pk primary key  (ayc01,ayc02,ayc03,ayc04,ayc05,ayc06,ayc07,ayc08) enable validate;
grant select on ayc_file to tiptopgp;
grant update on ayc_file to tiptopgp;
grant delete on ayc_file to tiptopgp;
grant insert on ayc_file to tiptopgp;
grant index on ayc_file to public;
grant select on ayc_file to ods;
