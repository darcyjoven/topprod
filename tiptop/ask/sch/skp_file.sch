/*
================================================================================
檔案代號:skp_file
檔案名稱:款式版片基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table skp_file
(
skp01       varchar2(40) DEFAULT ' ' NOT NULL, /*款式料号*/
skp02       number(10) DEFAULT '0' NOT NULL, /*版片序号*/
skp03       varchar2(40) DEFAULT ' ' NOT NULL, /*元件料号*/
skp04       varchar2(10) DEFAULT ' ' NOT NULL, /*部位*/
skp05       number(15,3) DEFAULT '0' NOT NULL /*单件片数*/
);

alter table skp_file add  constraint skp_pk primary key  (skp01,skp02) enable validate;
grant select on skp_file to tiptopgp;
grant update on skp_file to tiptopgp;
grant delete on skp_file to tiptopgp;
grant insert on skp_file to tiptopgp;
grant index on skp_file to public;
grant select on skp_file to ods;
