/*
================================================================================
檔案代號:odq_file
檔案名稱:客户订货明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table odq_file
(
odq01       varchar2(10) DEFAULT ' ' NOT NULL, /*訂購會編號*/
odq02       varchar2(10) DEFAULT ' ' NOT NULL, /*客户编号*/
odq03       varchar2(40),
odq04       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
odq05       number(5) DEFAULT '0' NOT NULL, /*期数*/
odq06       varchar2(40) DEFAULT ' ' NOT NULL,
odq07       number(15,3) DEFAULT '0' NOT NULL, /*数量*/
odq08       varchar2(40) DEFAULT ' ' NOT NULL,
odq00       varchar2(20) DEFAULT ' ' NOT NULL /*订货编号*/
);

alter table odq_file add  constraint odq_pk primary key  (odq00,odq01,odq02,odq04,odq05,odq06,odq08) enable validate;
grant select on odq_file to tiptopgp;
grant update on odq_file to tiptopgp;
grant delete on odq_file to tiptopgp;
grant insert on odq_file to tiptopgp;
grant index on odq_file to public;
grant select on odq_file to ods;
