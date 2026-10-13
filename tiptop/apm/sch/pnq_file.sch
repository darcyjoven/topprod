/*
================================================================================
檔案代號:pnq_file
檔案名稱:采购价格条件单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pnq_file
(
pnq01       varchar2(6) DEFAULT ' ' NOT NULL, /*采购价格条件编号*/
pnq02       number(5) DEFAULT '0' NOT NULL, /*顺序*/
pnq03       varchar2(10),            /*价格代码                               */
pnq04       number(5) DEFAULT '0' NOT NULL /*组别*/
);

alter table pnq_file add  constraint pnq_pk primary key  (pnq01,pnq02,pnq04) enable validate;
grant select on pnq_file to tiptopgp;
grant update on pnq_file to tiptopgp;
grant delete on pnq_file to tiptopgp;
grant insert on pnq_file to tiptopgp;
grant index on pnq_file to public;
grant select on pnq_file to ods;
