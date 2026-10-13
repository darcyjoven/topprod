/*
================================================================================
檔案代號:poh_file
檔案名稱:料件特卖数量折扣单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table poh_file
(
poh01       varchar2(6) DEFAULT ' ' NOT NULL, /*价格条件*/
poh02       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
poh03       date DEFAULT sysdate NOT NULL, /*生效日期*/
poh04       varchar2(10) DEFAULT ' ' NOT NULL, /*厂商编号*/
poh05       varchar2(6) DEFAULT ' ' NOT NULL, /*付款方式*/
poh06       varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
poh07       varchar2(4) DEFAULT ' ' NOT NULL, /*单位*/
poh08       number(15,6) DEFAULT '0' NOT NULL, /*最低数量*/
poh09       number(9,4)              /*折扣                                   */
);

alter table poh_file add  constraint poh_pk primary key  (poh01,poh02,poh03,poh04,poh05,poh06,poh07,poh08) enable validate;
grant select on poh_file to tiptopgp;
grant update on poh_file to tiptopgp;
grant delete on poh_file to tiptopgp;
grant insert on poh_file to tiptopgp;
grant index on poh_file to public;
grant select on poh_file to ods;
