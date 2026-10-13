/*
================================================================================
檔案代號:xsi_file
檔案名稱:出貨回報明細
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table xsi_file
(
xsi01       varchar2(20) DEFAULT ' ' NOT NULL, /*回报代号*/
xsi02       number(5) DEFAULT '0' NOT NULL, /*项次*/
xsi03       varchar2(40),            /*产品编号                               */
xsi04       number(15,3) DEFAULT '0' NOT NULL, /*累计出货数量*/
xsi05       varchar2(4),             /*单位                                   */
xsi06       number(20,6) DEFAULT '0' NOT NULL /*金额*/
);

alter table xsi_file add  constraint xsi_pk primary key  (xsi01,xsi02) enable validate;
grant select on xsi_file to tiptopgp;
grant update on xsi_file to tiptopgp;
grant delete on xsi_file to tiptopgp;
grant insert on xsi_file to tiptopgp;
grant index on xsi_file to public;
grant select on xsi_file to ods;
