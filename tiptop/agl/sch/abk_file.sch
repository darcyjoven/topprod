/*
================================================================================
檔案代號:abk_file
檔案名稱:费用分摊明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table abk_file
(
abk00       varchar2(1) NOT NULL,    /*性质                                   */
abk01       varchar2(10) NOT NULL,   /*费用编号                               */
abk02       number(5) NOT NULL,      /*项次                                   */
abk03       number(5) NOT NULL,      /*年度                                   */
abk04       number(5) NOT NULL,      /*月份                                   */
abk05       number(20,6),            /*金额                                   */
abk06       varchar2(20),            /*凭证编号                               */
abk07       date,                    /*凭证日期                               */
abk08       varchar2(20),            /*分录底稿单号                           */
abk09       varchar2(10),            /*处理人员                               */
abk10       varchar2(24),            /*科目编号                               */
abklegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table abk_file add  constraint abk_pk primary key  (abk00,abk01,abk02,abk03,abk04) enable validate;
grant select on abk_file to tiptopgp;
grant update on abk_file to tiptopgp;
grant delete on abk_file to tiptopgp;
grant insert on abk_file to tiptopgp;
grant index on abk_file to public;
grant select on abk_file to ods;
