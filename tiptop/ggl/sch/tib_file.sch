/*
================================================================================
檔案代號:tib_file
檔案名稱:期间现金活动分类明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tib_file
(
tib01       number(5) NOT NULL,      /*起始年度                               */
tib02       number(5) NOT NULL,      /*起始期别                               */
tib03       varchar2(5) NOT NULL,    /*帐套                                   */
tib04       varchar2(24) NOT NULL,   /*科目编号                               */
tib05       varchar2(1) NOT NULL,    /*借贷别                                 */
tib06       varchar2(20) NOT NULL,   /*凭证编号                               */
tib07       number(5) NOT NULL,      /*凭证项次                               */
tib08       number(20,6),            /*金额                                   */
tib09       varchar2(6)              /*现金代码                               */
);

alter table tib_file add  constraint tib_pk primary key  (tib01,tib02,tib03,tib04,tib05,tib06,tib07) enable validate;
grant select on tib_file to tiptopgp;
grant update on tib_file to tiptopgp;
grant delete on tib_file to tiptopgp;
grant insert on tib_file to tiptopgp;
grant index on tib_file to public;
grant select on tib_file to ods;
