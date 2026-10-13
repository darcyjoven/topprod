/*
================================================================================
檔案代號:foo_file
檔案名稱:固定资产系统科目余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table foo_file
(
foo01       varchar2(24) NOT NULL,   /*科目编号                               */
foo02       varchar2(10) NOT NULL,   /*部门                                   */
foo03       number(5) NOT NULL,      /*年度                                   */
foo04       number(5) NOT NULL,      /*期别                                   */
foo05d      number(20,6) NOT NULL,   /*本币借方金额                           */
foo06c      number(20,6) NOT NULL,   /*本币贷方金额                           */
foo07       varchar2(10) NOT NULL,   /*总账营运中心                           */
foo08       varchar2(5) NOT NULL,    /*帐套                                   */
foolegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table foo_file add  constraint foo_pk primary key  (foo01,foo02,foo03,foo04,foo08) enable validate;
grant select on foo_file to tiptopgp;
grant update on foo_file to tiptopgp;
grant delete on foo_file to tiptopgp;
grant insert on foo_file to tiptopgp;
grant index on foo_file to public;
grant select on foo_file to ods;
