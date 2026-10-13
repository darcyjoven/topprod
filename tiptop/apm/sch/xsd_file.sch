/*
================================================================================
檔案代號:xsd_file
檔案名稱:经销商自定价档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table xsd_file
(
xsd01       varchar2(10) DEFAULT ' ' NOT NULL, /*下层组织*/
xsd02       varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
xsd03       varchar2(4) DEFAULT ' ' NOT NULL, /*单位*/
xsd04       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
xsd05       date DEFAULT sysdate NOT NULL, /*生效日期*/
xsd06       number(20,6) DEFAULT '0' NOT NULL,
xsd07       number(20,6) DEFAULT '0' NOT NULL, /*自定价*/
xsd08       number(20,6) DEFAULT '0' NOT NULL, /*最低售价*/
xsd99       varchar2(10) DEFAULT ' ' NOT NULL /*经销商*/
);

alter table xsd_file add  constraint xsd_pk primary key  (xsd01,xsd02,xsd03,xsd04,xsd05) enable validate;
grant select on xsd_file to tiptopgp;
grant update on xsd_file to tiptopgp;
grant delete on xsd_file to tiptopgp;
grant insert on xsd_file to tiptopgp;
grant index on xsd_file to public;
grant select on xsd_file to ods;
