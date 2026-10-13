/*
================================================================================
檔案代號:poj_file
檔案名稱:料件价格单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table poj_file
(
poj01       varchar2(6) DEFAULT ' ' NOT NULL, /*价格条件*/
poj02       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
poj03       varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
poj04       varchar2(4) DEFAULT ' ' NOT NULL, /*单位*/
poj05       date DEFAULT sysdate NOT NULL, /*生效日期*/
poj06       number(20,6),            /*税前单价                               */
poj06t      number(20,6),            /*含税单价                               */
poj07       number(15,3)             /*折扣                                   */
);

alter table poj_file add  constraint poj_pk primary key  (poj01,poj02,poj03,poj04,poj05) enable validate;
grant select on poj_file to tiptopgp;
grant update on poj_file to tiptopgp;
grant delete on poj_file to tiptopgp;
grant insert on poj_file to tiptopgp;
grant index on poj_file to public;
grant select on poj_file to ods;
