/*
================================================================================
檔案代號:boxb_file
檔案名稱:配货单子档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table boxb_file
(
boxb01      varchar2(20) DEFAULT ' ' NOT NULL, /*出货通知单单号*/
boxb02      number(5) DEFAULT '0' NOT NULL, /*出货通知单项次*/
boxb03      number(5) DEFAULT '0' NOT NULL, /*配货单项次*/
boxb04      varchar2(10),            /*Nouse                                  */
boxb05      varchar2(80) DEFAULT ' ' NOT NULL, /*条码编号*/
boxb06      varchar2(10) DEFAULT ' ' NOT NULL, /*仓库*/
boxb07      varchar2(10) DEFAULT ' ' NOT NULL, /*库位*/
boxb08      varchar2(24) DEFAULT ' ' NOT NULL, /*批号*/
boxb09      number(15,3) DEFAULT '0' NOT NULL, /*数量*/
boxblegal   varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
boxbplant   varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table boxb_file add  constraint boxb_pk primary key  (boxb01,boxb02,boxb03,boxb05,boxb06,boxb07,boxb08) enable validate;
grant select on boxb_file to tiptopgp;
grant update on boxb_file to tiptopgp;
grant delete on boxb_file to tiptopgp;
grant insert on boxb_file to tiptopgp;
grant index on boxb_file to public;
grant select on boxb_file to ods;
