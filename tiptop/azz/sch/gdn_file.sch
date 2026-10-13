/*
================================================================================
檔案代號:gdn_file
檔案名稱:提供單身匯出Excel時Sorting功能的中介檔案
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gdn_file
(
gdn01       number(5) DEFAULT '1' NOT NULL, /*Process ID*/
gdn02       number(10) DEFAULT '1' NOT NULL, /*单身资料笔数*/
gdn03       number(10) DEFAULT '1' NOT NULL,
gdn04       varchar2(4000)           /*单身资料                               */
);

alter table gdn_file add  constraint gdn_pk primary key  (gdn01,gdn02,gdn03) enable validate;
grant select on gdn_file to tiptopgp;
grant update on gdn_file to tiptopgp;
grant delete on gdn_file to tiptopgp;
grant insert on gdn_file to tiptopgp;
grant index on gdn_file to public;
grant select on gdn_file to ods;
