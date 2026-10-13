/*
================================================================================
檔案代號:pnz_file
檔案名稱:采购价格条件档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pnz_file
(
pnz01       varchar2(6) DEFAULT ' ' NOT NULL, /*价格条件编号*/
pnz02       varchar2(80) DEFAULT ' ',/*说明                                   */
pnz03       varchar2(2) DEFAULT ' ' NOT NULL, /*取价方式*/
pnz04       varchar2(1) DEFAULT 'Y' NOT NULL, /*未取到价格时人工输入*/
pnz05       varchar2(1) DEFAULT 'Y' NOT NULL, /*不依顺序对比取价Y对比取价 N */
pnz06       varchar2(1) DEFAULT ' ' NOT NULL, /*同組同類型互斥*/
pnz07       varchar2(1) DEFAULT 'N' NOT NULL, /*取到价格允许修改*/
pnz08       varchar2(1) DEFAULT 'Y' NOT NULL /*单价可否为零*/
);

alter table pnz_file add  constraint pnz_pk primary key  (pnz01) enable validate;
grant select on pnz_file to tiptopgp;
grant update on pnz_file to tiptopgp;
grant delete on pnz_file to tiptopgp;
grant insert on pnz_file to tiptopgp;
grant index on pnz_file to public;
grant select on pnz_file to ods;
