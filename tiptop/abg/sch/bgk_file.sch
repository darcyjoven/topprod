/*
================================================================================
檔案代號:bgk_file
檔案名稱:费用基础金额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bgk_file
(
bgk01       varchar2(10) NOT NULL,   /*版本                                   */
bgk02       varchar2(10) NOT NULL,   /*部门编号                               */
                                     /*部門編號                               */
bgk03       varchar2(6) NOT NULL,    /*分摊类型                               */
                                     /*分攤類別                               */
bgk04       number(20,6),            /*金额                                   */
                                     /*金額                                   */
bgk05       varchar2(1)              /*No Use                                 */
);

alter table bgk_file add  constraint bgk_pk primary key  (bgk01,bgk02,bgk03) enable validate;
grant select on bgk_file to tiptopgp;
grant update on bgk_file to tiptopgp;
grant delete on bgk_file to tiptopgp;
grant insert on bgk_file to tiptopgp;
grant index on bgk_file to public;
grant select on bgk_file to ods;
