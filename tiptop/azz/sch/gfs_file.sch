/*
================================================================================
檔案代號:gfs_file
檔案名稱:GR报表样板说明多语言文件
檔案目的:
上游檔案:gdw_file
下游檔案:N
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table gfs_file
(
gfs01       number(10) DEFAULT '1' NOT NULL,
gfs02       varchar2(1) DEFAULT ' ' NOT NULL, /*语言别*/
gfs03       varchar2(255)
);

alter table gfs_file add  constraint gfs_pk primary key  (gfs01,gfs02) enable validate;
grant select on gfs_file to tiptopgp;
grant update on gfs_file to tiptopgp;
grant delete on gfs_file to tiptopgp;
grant insert on gfs_file to tiptopgp;
grant index on gfs_file to public;
grant select on gfs_file to ods;
