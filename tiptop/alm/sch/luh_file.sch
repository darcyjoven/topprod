/*
================================================================================
檔案代號:luh_file
檔案名稱:正式商戶狀態信息檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table luh_file
(
luh00       varchar2(10),            /*来源门店编号                           */
luh01       varchar2(10) DEFAULT ' ' NOT NULL, /*商户号*/
luh02       varchar2(20) DEFAULT ' ' NOT NULL, /*版本号*/
luh03       varchar2(10),            /*no use 原门店编号                      */
luh04       varchar2(1) DEFAULT ' ' NOT NULL, /*商户初始状态*/
luh05       varchar2(1) DEFAULT ' ' NOT NULL, /*希望变更状态*/
luh06       varchar2(1) DEFAULT ' ' NOT NULL, /*确认结果*/
luh07       varchar2(1) DEFAULT ' ' NOT NULL, /*商户状态*/
luhlegal    varchar2(10) NOT NULL,   /*所属法人                               */
luhstore    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table luh_file add  constraint luh_pk primary key  (luh01,luh02,luhstore) enable validate;
grant select on luh_file to tiptopgp;
grant update on luh_file to tiptopgp;
grant delete on luh_file to tiptopgp;
grant insert on luh_file to tiptopgp;
grant index on luh_file to public;
grant select on luh_file to ods;
