/*
================================================================================
檔案代號:wak_file
檔案名稱:通用接口之栏位选项对应关系档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wak_file
(
wak01       varchar2(80) DEFAULT ' ' NOT NULL, /*企业对象ID*/
wak02       varchar2(20) DEFAULT ' ' NOT NULL, /*企业对象使用的表名*/
wak03       varchar2(10) DEFAULT ' ' NOT NULL, /*字段代码*/
wak04       varchar2(10) DEFAULT ' ' NOT NULL, /*选项值*/
wak05       varchar2(30) DEFAULT ' ' NOT NULL /*选项说明*/
);

alter table wak_file add  constraint wak_pk primary key  (wak01,wak02,wak03,wak04) enable validate;
grant select on wak_file to tiptopgp;
grant update on wak_file to tiptopgp;
grant delete on wak_file to tiptopgp;
grant insert on wak_file to tiptopgp;
grant index on wak_file to public;
grant select on wak_file to ods;
