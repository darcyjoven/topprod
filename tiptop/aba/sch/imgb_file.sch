/*
================================================================================
檔案代號:imgb_file
檔案名稱:条码库存档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table imgb_file
(
imgb01      varchar2(80) DEFAULT ' ' NOT NULL, /*条码编号*/
imgb02      varchar2(10) DEFAULT ' ' NOT NULL, /*仓库*/
imgb03      varchar2(10) DEFAULT ' ' NOT NULL, /*库位*/
imgb04      varchar2(24) DEFAULT ' ' NOT NULL, /*批号*/
imgb05      number(15,3) DEFAULT '0' NOT NULL, /*库存数量*/
imgblegal   varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
imgbplant   varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table imgb_file add  constraint imgb_pk primary key  (imgb01,imgb02,imgb03,imgb04) enable validate;
grant select on imgb_file to tiptopgp;
grant update on imgb_file to tiptopgp;
grant delete on imgb_file to tiptopgp;
grant insert on imgb_file to tiptopgp;
grant index on imgb_file to public;
grant select on imgb_file to ods;
