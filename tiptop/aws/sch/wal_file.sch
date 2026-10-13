/*
================================================================================
檔案代號:wal_file
檔案名稱:DB与Wab地址维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wal_file
(
wal01       varchar2(10) DEFAULT ' ' NOT NULL, /*系统*/
wal02       varchar2(20) DEFAULT ' ' NOT NULL, /*DB名称*/
wal03       varchar2(100) DEFAULT ' ' NOT NULL /*Web服务器地址*/
);

alter table wal_file add  constraint wal_pk primary key  (wal01,wal02) enable validate;
grant select on wal_file to tiptopgp;
grant update on wal_file to tiptopgp;
grant delete on wal_file to tiptopgp;
grant insert on wal_file to tiptopgp;
grant index on wal_file to public;
grant select on wal_file to ods;
