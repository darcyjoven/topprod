/*
================================================================================
檔案代號:aaj_file
檔案名稱:合并股东权益科目分类/群组归属档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aaj_file
(
aaj00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套编号*/
aaj01       varchar2(10) DEFAULT ' ' NOT NULL, /*集团代号*/
aaj02       varchar2(10) DEFAULT ' ' NOT NULL, /*母公司编号*/
aaj03       varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
aaj04       varchar2(10) DEFAULT ' ' NOT NULL, /*分类编号*/
aaj05       varchar2(10) DEFAULT ' ' NOT NULL, /*群组代码*/
aaj06       varchar2(1) DEFAULT '-' NOT NULL /*加减*/
);

alter table aaj_file add  constraint aaj_pk primary key  (aaj00,aaj01,aaj02,aaj03,aaj04,aaj05) enable validate;
grant select on aaj_file to tiptopgp;
grant update on aaj_file to tiptopgp;
grant delete on aaj_file to tiptopgp;
grant insert on aaj_file to tiptopgp;
grant index on aaj_file to public;
grant select on aaj_file to ods;
