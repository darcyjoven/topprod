/*
================================================================================
檔案代號:boi_file
檔案名稱:缩放比率参数档
檔案目的:缩放比率参数档 单档多栏
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table boi_file
(
boi01       varchar2(10) DEFAULT ' ' NOT NULL, /*参数代号*/
boi02       number(15,3) DEFAULT '0' NOT NULL, /*参数内容*/
boi03       varchar2(20) DEFAULT ' ' NOT NULL, /*参数描述*/
boiacti     varchar2(1) DEFAULT ' ' NOT NULL /*有效否*/
);

alter table boi_file add  constraint boi_pk primary key  (boi01) enable validate;
grant select on boi_file to tiptopgp;
grant update on boi_file to tiptopgp;
grant delete on boi_file to tiptopgp;
grant insert on boi_file to tiptopgp;
grant index on boi_file to public;
grant select on boi_file to ods;
