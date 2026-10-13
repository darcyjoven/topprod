/*
================================================================================
檔案代號:gaw_file
檔案名稱:程序群组纪录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gaw_file
(
gaw01       varchar2(10) NOT NULL,   /*程序群组代码                           */
gaw02       varchar2(100)            /*程序群组说明                           */
);

alter table gaw_file add  constraint gaw_pk primary key  (gaw01) enable validate;
grant select on gaw_file to tiptopgp;
grant update on gaw_file to tiptopgp;
grant delete on gaw_file to tiptopgp;
grant insert on gaw_file to tiptopgp;
grant index on gaw_file to public;
grant select on gaw_file to ods;
