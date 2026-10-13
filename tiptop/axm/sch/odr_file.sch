/*
================================================================================
檔案代號:odr_file
檔案名稱:订货会需求确认档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table odr_file
(
odr01       varchar2(10) DEFAULT ' ' NOT NULL, /*訂購會編號*/
odr02       varchar2(10) DEFAULT ' ' NOT NULL, /*客户编号*/
odr03       varchar2(40) DEFAULT ' ' NOT NULL, /*料号*/
odr04       number(15,3) DEFAULT '0' NOT NULL, /*需求数量*/
odr05       number(15,3) DEFAULT '0' NOT NULL,
odr06       varchar2(20),            /*订单编号                               */
odr07       varchar2(40) DEFAULT ' ' NOT NULL,
odr00       varchar2(20) DEFAULT ' ' NOT NULL /*订货确认编号*/
);

alter table odr_file add  constraint odr_pk primary key  (odr00,odr01,odr02,odr03,odr07) enable validate;
grant select on odr_file to tiptopgp;
grant update on odr_file to tiptopgp;
grant delete on odr_file to tiptopgp;
grant insert on odr_file to tiptopgp;
grant index on odr_file to public;
grant select on odr_file to ods;
