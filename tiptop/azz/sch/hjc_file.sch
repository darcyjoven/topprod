/*
================================================================================
檔案代號:hjc_file
檔案名稱:各时点线上使用者状况记录表
檔案目的:各时点线上使用者状况记录
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table hjc_file
(
hjc01       number(5) NOT NULL,
hjc02       varchar2(20) NOT NULL,
hjc03       varchar2(20) NOT NULL,
hjc04       varchar2(10),
hjc05       number(5)
);

alter table hjc_file add  constraint hjc_pk primary key  (hjc01,hjc02,hjc03) enable validate;
grant select on hjc_file to tiptopgp;
grant update on hjc_file to tiptopgp;
grant delete on hjc_file to tiptopgp;
grant insert on hjc_file to tiptopgp;
grant index on hjc_file to public;
grant select on hjc_file to ods;
