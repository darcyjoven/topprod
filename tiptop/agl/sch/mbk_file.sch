/*
================================================================================
檔案代號:mbk_file
檔案名稱:报表结构科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table mbk_file
(
mbk01       varchar2(6) DEFAULT ' ' NOT NULL, /*报表编号*/
mbk02       number(9,4) DEFAULT '0' NOT NULL, /*项次*/
mbk03       varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
mbk04       varchar2(1) DEFAULT ' ' NOT NULL, /*加减*/
mbk05       varchar2(1) DEFAULT ' ' NOT NULL /*金额来源*/
);

create unique index mbk_01 on mbk_file (mbk01,mbk02,mbk03);
alter table mbk_file add  constraint mbk_pk primary key  (mbk01,mbk02,mbk03) enable validate;
grant select on mbk_file to tiptopgp;
grant update on mbk_file to tiptopgp;
grant delete on mbk_file to tiptopgp;
grant insert on mbk_file to tiptopgp;
grant index on mbk_file to public;
grant select on mbk_file to ods;
