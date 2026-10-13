/*
================================================================================
檔案代號:gio_file
檔案名稱:人工输入金额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gio_file
(
gio00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
gio01       varchar2(6) DEFAULT ' ' NOT NULL, /*群组代码*/
gio02       varchar2(24) DEFAULT ' ' NOT NULL, /*编号*/
gio03       varchar2(20) DEFAULT ' ' NOT NULL, /*年度*/
gio04       varchar2(80),            /*说明                                   */
gio05       number(20,6),            /*人工录入金额                           */
gio06       number(5) DEFAULT '0' NOT NULL, /*年度*/
gio07       number(5) DEFAULT '0' NOT NULL /*期别*/
);

alter table gio_file add  constraint gio_pk primary key  (gio00,gio01,gio02,gio03,gio06,gio07) enable validate;
grant select on gio_file to tiptopgp;
grant update on gio_file to tiptopgp;
grant delete on gio_file to tiptopgp;
grant insert on gio_file to tiptopgp;
grant index on gio_file to public;
grant select on gio_file to ods;
