/*
================================================================================
檔案代號:imkb_file
檔案名稱:条码月结档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table imkb_file
(
imkb01      varchar2(80) DEFAULT ' ' NOT NULL, /*条码编号*/
imkb02      varchar2(10) DEFAULT ' ' NOT NULL, /*仓库*/
imkb03      varchar2(10) DEFAULT ' ' NOT NULL, /*库位*/
imkb04      varchar2(24) DEFAULT ' ' NOT NULL, /*批号*/
imkb05      number(5) DEFAULT '0' NOT NULL, /*年度*/
imkb06      number(5) DEFAULT '0' NOT NULL, /*期别*/
imkb07      number(15,3) DEFAULT '0' NOT NULL, /*本期入库统计量*/
imkb08      number(15,3) DEFAULT '0' NOT NULL, /*本期销货统计量*/
imkb09      number(15,3) DEFAULT '0' NOT NULL, /*本期领用统计量*/
imkb10      number(15,3) DEFAULT '0' NOT NULL, /*本期调拨统计量*/
imkb11      number(15,3) DEFAULT '0' NOT NULL, /*本期调整统计量*/
imkb12      number(15,3) DEFAULT '0' NOT NULL, /*期末数量*/
imkblegal   varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
imkbplant   varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table imkb_file add  constraint imkb_pk primary key  (imkb01,imkb02,imkb03,imkb04,imkb05,imkb06) enable validate;
grant select on imkb_file to tiptopgp;
grant update on imkb_file to tiptopgp;
grant delete on imkb_file to tiptopgp;
grant insert on imkb_file to tiptopgp;
grant index on imkb_file to public;
grant select on imkb_file to ods;
