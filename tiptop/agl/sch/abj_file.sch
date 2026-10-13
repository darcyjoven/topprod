/*
================================================================================
檔案代號:abj_file
檔案名稱:预付暨递延费用基本资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table abj_file
(
abj00       varchar2(1) NOT NULL,    /*性质                                   */
abj01       varchar2(10) NOT NULL,   /*费用编号                               */
abj02       number(5) NOT NULL,      /*项次                                   */
abj03       varchar2(30),            /*费用明细                               */
abj04       varchar2(24),            /*费用科目编号                           */
abj05       number(20,6),            /*费用                                   */
abj06       varchar2(24),            /*资产科目编号                           */
abj07       number(5),               /*已摊年度                               */
abj08       number(5),               /*已摊月份                               */
abj09       number(20,6)             /*已摊金额                               */
);

alter table abj_file add  constraint abj_pk primary key  (abj00,abj01,abj02) enable validate;
grant select on abj_file to tiptopgp;
grant update on abj_file to tiptopgp;
grant delete on abj_file to tiptopgp;
grant insert on abj_file to tiptopgp;
grant index on abj_file to public;
grant select on abj_file to ods;
