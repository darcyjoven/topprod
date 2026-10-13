/*
================================================================================
檔案代號:aea_file
檔案名稱:分类账档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table aea_file
(
aea00       varchar2(5) NOT NULL,    /*帐套                                   */
aea01       varchar2(24) NOT NULL,   /*统治或独立科目编号                     */
aea02       date,                    /*凭证日期                               */
aea03       varchar2(20) NOT NULL,   /*凭证编号                               */
aea04       number(5) NOT NULL,      /*项次                                   */
aea05       varchar2(24),            /*明细科目编号                           */
aealegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index aea_02 on aea_file (aea05,aea02);
create        index aea_01 on aea_file (aea01,aea02);
alter table aea_file add  constraint aea_pk primary key  (aea03,aea04,aea01,aea00) enable validate;
grant select on aea_file to tiptopgp;
grant update on aea_file to tiptopgp;
grant delete on aea_file to tiptopgp;
grant insert on aea_file to tiptopgp;
grant index on aea_file to public;
grant select on aea_file to ods;
