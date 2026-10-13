/*
================================================================================
檔案代號:ohi_file
檔案名稱:销售价格条件单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ohi_file
(
ohi01       varchar2(6) DEFAULT ' ' NOT NULL, /*销售价格条件编号*/
ohi02       number(5) DEFAULT '0' NOT NULL, /*组别*/
ohi03       number(5) DEFAULT '0' NOT NULL, /*顺序*/
ohi04       varchar2(10)             /*价格编号                               */
);

alter table ohi_file add  constraint ohi_pk primary key  (ohi01,ohi02,ohi03) enable validate;
grant select on ohi_file to tiptopgp;
grant update on ohi_file to tiptopgp;
grant delete on ohi_file to tiptopgp;
grant insert on ohi_file to tiptopgp;
grant index on ohi_file to public;
grant select on ohi_file to ods;
