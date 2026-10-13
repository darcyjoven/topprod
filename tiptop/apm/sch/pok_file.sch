/*
================================================================================
檔案代號:pok_file
檔案名稱:料件价格数量折扣单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pok_file
(
pok01       varchar2(6) DEFAULT ' ' NOT NULL, /*价格条件*/
pok02       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
pok03       varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
pok04       varchar2(4) DEFAULT ' ' NOT NULL, /*单位*/
pok05       date DEFAULT sysdate NOT NULL, /*生效日期*/
pok06       number(15,6) DEFAULT '0' NOT NULL, /*最低数量*/
pok07       number(9,4)              /*折扣                                   */
);

alter table pok_file add  constraint pok_pk primary key  (pok01,pok02,pok03,pok04,pok05,pok06) enable validate;
grant select on pok_file to tiptopgp;
grant update on pok_file to tiptopgp;
grant delete on pok_file to tiptopgp;
grant insert on pok_file to tiptopgp;
grant index on pok_file to public;
grant select on pok_file to ods;
