/*
================================================================================
檔案代號:boe_file
檔案名稱:成品材料缩放比例档
檔案目的:成品材料缩放比例档 假双档
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table boe_file
(
boe01       varchar2(40) DEFAULT ' ' NOT NULL, /*主件款式，放单头*/
boe02       varchar2(40) DEFAULT ' ' NOT NULL, /*元件款式，放单头*/
boe03       varchar2(20) DEFAULT ' ' NOT NULL, /*主件属性段一,放单身*/
boe04       varchar2(20) DEFAULT ' ' NOT NULL, /*主件属性段二,放单身*/
boe05       varchar2(20) DEFAULT ' ' NOT NULL, /*主件属性段三,放单身*/
boe06       varchar2(10) DEFAULT ' ' NOT NULL, /*部位，放单身*/
boe07       varchar2(80),            /*用量缩放比例公式                       */
boe08       varchar2(80)             /*损耗率缩放比率公式                     */
);

alter table boe_file add  constraint boe_pk primary key  (boe01,boe02,boe03,boe04,boe05,boe06) enable validate;
grant select on boe_file to tiptopgp;
grant update on boe_file to tiptopgp;
grant delete on boe_file to tiptopgp;
grant insert on boe_file to tiptopgp;
grant index on boe_file to public;
grant select on boe_file to ods;
