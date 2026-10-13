/*
================================================================================
檔案代號:ckl_file
檔案名稱:差异明细表
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ckl_file
(
ckl01       varchar2(10) DEFAULT ' ' NOT NULL,
ckl02       varchar2(20) DEFAULT ' ' NOT NULL, /*单号*/
ckl03       number(5) DEFAULT '0' NOT NULL, /*项次*/
ckl04       varchar2(40),            /*料号                                   */
ckl05       number(15,3) DEFAULT '0' NOT NULL, /*数量*/
ckl06       number(20,6) DEFAULT '0' NOT NULL, /*金额*/
ckl07       number(5) DEFAULT '0' NOT NULL, /*年度*/
ckl08       number(5) DEFAULT '0' NOT NULL /*月份*/
);

alter table ckl_file add  constraint ckl_pk primary key  (ckl01,ckl02,ckl03,ckl07,ckl08) enable validate;
grant select on ckl_file to tiptopgp;
grant update on ckl_file to tiptopgp;
grant delete on ckl_file to tiptopgp;
grant insert on ckl_file to tiptopgp;
grant index on ckl_file to public;
grant select on ckl_file to ods;
