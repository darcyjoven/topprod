/*
================================================================================
檔案代號:lnk_file
檔案名稱:卡种/券种生效范围资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lnk_file
(
lnk01       varchar2(20) DEFAULT ' ' NOT NULL, /*编号*/
lnk02       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
lnk03       varchar2(10) DEFAULT ' ' NOT NULL, /*门店编号*/
lnk04       varchar2(20) DEFAULT ' ' NOT NULL, /*摊位编号*/
lnk05       varchar2(1) DEFAULT 'Y' NOT NULL /*有效否*/
);

alter table lnk_file add  constraint lnk_pk primary key  (lnk01,lnk02,lnk03,lnk04) enable validate;
grant select on lnk_file to tiptopgp;
grant update on lnk_file to tiptopgp;
grant delete on lnk_file to tiptopgp;
grant insert on lnk_file to tiptopgp;
grant index on lnk_file to public;
grant select on lnk_file to ods;
