/*
================================================================================
檔案代號:waj_file
檔案名稱:通用接口之栏位选项对应关系档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table waj_file
(
waj01       varchar2(10) DEFAULT ' ' NOT NULL, /*系统标示*/
waj02       varchar2(80) DEFAULT ' ' NOT NULL, /*企业对象ID*/
waj03       varchar2(20),            /*企業對象使用的檔案名稱(no use          */
waj04       varchar2(200) DEFAULT ' ' NOT NULL, /*目标系统属性ID*/
waj05       varchar2(10) DEFAULT ' ' NOT NULL, /*选项值*/
waj06       varchar2(30) DEFAULT ' ' NOT NULL, /*选项说明*/
waj07       varchar2(10) DEFAULT ' ' NOT NULL /*对应TIPTOP选项值*/
);

alter table waj_file add  constraint waj_pk primary key  (waj01,waj02,waj04,waj05) enable validate;
grant select on waj_file to tiptopgp;
grant update on waj_file to tiptopgp;
grant delete on waj_file to tiptopgp;
grant insert on waj_file to tiptopgp;
grant index on waj_file to public;
grant select on waj_file to ods;
