/*
================================================================================
檔案代號:pog_file
檔案名稱:料件特卖价格单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pog_file
(
pog01       varchar2(6) DEFAULT ' ' NOT NULL, /*价格条件*/
pog02       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
pog03       date DEFAULT sysdate NOT NULL, /*生效日期*/
pog04       varchar2(10) DEFAULT ' ' NOT NULL, /*厂商编号*/
pog05       varchar2(6) DEFAULT ' ' NOT NULL, /*付款方式*/
pog06       varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
pog07       varchar2(4) DEFAULT ' ' NOT NULL, /*单位*/
pog08       number(20,6),            /*税前单价                               */
pog08t      number(20,6),            /*含税单价                               */
pog09       number(9,4)              /*折扣                                   */
);

alter table pog_file add  constraint pog_pk primary key  (pog01,pog02,pog03,pog04,pog05,pog06,pog07) enable validate;
grant select on pog_file to tiptopgp;
grant update on pog_file to tiptopgp;
grant delete on pog_file to tiptopgp;
grant insert on pog_file to tiptopgp;
grant index on pog_file to public;
grant select on pog_file to ods;
