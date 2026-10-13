/*
================================================================================
檔案代號:bod_file
檔案名稱:成品材料属性对应关系
檔案目的:成品材料属性对应关系单身档 双档单身
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bod_file
(
bod01       varchar2(40) DEFAULT ' ' NOT NULL, /*主件款式*/
bod02       varchar2(40) DEFAULT ' ' NOT NULL, /*元件款式*/
bod03       varchar2(10) DEFAULT ' ' NOT NULL, /*主件属性代码*/
bod04       varchar2(10) DEFAULT ' ' NOT NULL, /*元件属性代码*/
bod05       varchar2(20) DEFAULT ' ' NOT NULL, /*主件属性值*/
bod06       varchar2(10) DEFAULT ' ' NOT NULL, /*部位*/
bod07       varchar2(20) DEFAULT ' ' NOT NULL, /*元件属性值*/
bod08       varchar2(80) DEFAULT ' ' NOT NULL, /*主件属性描述*/
bod09       varchar2(80) DEFAULT ' ' NOT NULL /*元件属性描述*/
);

alter table bod_file add  constraint bod_pk primary key  (bod01,bod02,bod03,bod04,bod05,bod06) enable validate;
grant select on bod_file to tiptopgp;
grant update on bod_file to tiptopgp;
grant delete on bod_file to tiptopgp;
grant insert on bod_file to tiptopgp;
grant index on bod_file to public;
grant select on bod_file to ods;
