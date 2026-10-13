/*
================================================================================
檔案代號:gev_file
檔案名稱:资料控管维护档案(资料中心)
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gev_file
(
gev01       varchar2(1) DEFAULT ' ' NOT NULL, /*资料类型*/
gev02       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
gev03       varchar2(1),             /*资料中心否                             */
gev04       varchar2(10)             /*资料中心代码                           */
);

alter table gev_file add  constraint gev_pk primary key  (gev01,gev02) enable validate;
grant select on gev_file to tiptopgp;
grant update on gev_file to tiptopgp;
grant delete on gev_file to tiptopgp;
grant insert on gev_file to tiptopgp;
grant index on gev_file to public;
grant select on gev_file to ods;
