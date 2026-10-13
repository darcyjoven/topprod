/*
================================================================================
檔案代號:aai_file
檔案名稱:股东权益科目分类/群组归属档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aai_file
(
aai00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
aai01       varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
aai02       varchar2(10) DEFAULT ' ' NOT NULL, /*分类编号*/
aai03       varchar2(10) DEFAULT ' ' NOT NULL, /*群组代码*/
aai04       varchar2(1) DEFAULT 'N' NOT NULL, /*合并*/
aai05       varchar2(1) DEFAULT '+' NOT NULL /*加减*/
);

alter table aai_file add  constraint aai_pk primary key  (aai00,aai01,aai02,aai03,aai04) enable validate;
grant select on aai_file to tiptopgp;
grant update on aai_file to tiptopgp;
grant delete on aai_file to tiptopgp;
grant insert on aai_file to tiptopgp;
grant index on aai_file to public;
grant select on aai_file to ods;
