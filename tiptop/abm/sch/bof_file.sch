/*
================================================================================
檔案代號:bof_file
檔案名稱:分量损耗率资料档
檔案目的:分量损耗率资料档 单档多栏
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bof_file
(
bof01       varchar2(40) DEFAULT ' ' NOT NULL, /*主件料号*/
bof02       varchar2(20) DEFAULT ' ' NOT NULL, /*类型 1-料号 2-分群码*/
bof03       varchar2(40) DEFAULT ' ' NOT NULL, /*元件料号/分群码*/
bof04       number(15,3) DEFAULT '0' NOT NULL, /*生产起始数量*/
bof05       number(15,3) DEFAULT '0' NOT NULL, /*生产截止数量*/
bof06       number(9,4) DEFAULT '0' NOT NULL, /*固定损耗系数*/
bof07       number(9,4) DEFAULT '0' NOT NULL /*变动损耗系数*/
);

alter table bof_file add  constraint bof_pk primary key  (bof01,bof02,bof03,bof04,bof05) enable validate;
grant select on bof_file to tiptopgp;
grant update on bof_file to tiptopgp;
grant delete on bof_file to tiptopgp;
grant insert on bof_file to tiptopgp;
grant index on bof_file to public;
grant select on bof_file to ods;
