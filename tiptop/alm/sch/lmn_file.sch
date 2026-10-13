/*
================================================================================
檔案代號:lmn_file
檔案名稱:战盟基本数据单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lmn_file
(
lmn01       varchar2(20) DEFAULT ' ' NOT NULL, /*战盟协议编号*/
lmn02       varchar2(10) DEFAULT ' ' NOT NULL /*品牌编号*/
);

alter table lmn_file add  constraint lmn_pk primary key  (lmn01,lmn02) enable validate;
grant select on lmn_file to tiptopgp;
grant update on lmn_file to tiptopgp;
grant delete on lmn_file to tiptopgp;
grant insert on lmn_file to tiptopgp;
grant index on lmn_file to public;
grant select on lmn_file to ods;
