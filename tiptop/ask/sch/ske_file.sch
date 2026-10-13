/*
================================================================================
檔案代號:ske_file
檔案名稱:制单说明资料档
檔案目的:制单说明资料档 单档多栏
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ske_file
(
ske01       varchar2(20) DEFAULT ' ' NOT NULL, /*制单编号*/
ske02       varchar2(1) DEFAULT ' ' NOT NULL, /*说明类型*/
ske03       number(10) DEFAULT '0' NOT NULL, /*说明项次*/
ske04       varchar2(80) DEFAULT ' ' NOT NULL, /*说明内容*/
ske05       varchar2(1) DEFAULT ' ' NOT NULL, /*打印方式   1-打印于前 2-打印  */
skeplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
skelegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table ske_file add  constraint ske_pk primary key  (ske01,ske02,ske03) enable validate;
grant select on ske_file to tiptopgp;
grant update on ske_file to tiptopgp;
grant delete on ske_file to tiptopgp;
grant insert on ske_file to tiptopgp;
grant index on ske_file to public;
grant select on ske_file to ods;
