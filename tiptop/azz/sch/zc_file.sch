/*
================================================================================
檔案代號:zc_file
檔案名稱:工作代码档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zc_file
(
zc01        varchar2(3) NOT NULL,    /*异动编号                               */
                                     /*異動代號                               */
zc02        varchar2(10)             /*工作说明                               */
                                     /*工作說明                               */
);

alter table zc_file add  constraint zc_pk primary key  (zc01) enable validate;
grant select on zc_file to tiptopgp;
grant update on zc_file to tiptopgp;
grant delete on zc_file to tiptopgp;
grant insert on zc_file to tiptopgp;
grant index on zc_file to public;
grant select on zc_file to ods;
