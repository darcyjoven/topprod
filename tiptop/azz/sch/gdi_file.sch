/*
================================================================================
檔案代號:gdi_file
檔案名稱:p_cron 参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gdi_file
(
gdi01       varchar2(40) DEFAULT ' ' NOT NULL, /*作业名称*/
gdi02       number(5) DEFAULT '0' NOT NULL, /*序号*/
gdi03       varchar2(10) DEFAULT ' ' NOT NULL,
gdi04       varchar2(20) DEFAULT ' ' NOT NULL, /*参数名称*/
gdi05       varchar2(1000)           /*参数内容                               */
);

alter table gdi_file add  constraint gdi_pk primary key  (gdi01,gdi02,gdi03,gdi04) enable validate;
grant select on gdi_file to tiptopgp;
grant update on gdi_file to tiptopgp;
grant delete on gdi_file to tiptopgp;
grant insert on gdi_file to tiptopgp;
grant index on gdi_file to public;
grant select on gdi_file to ods;
