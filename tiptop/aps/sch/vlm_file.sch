/*
================================================================================
檔案代號:vlm_file
檔案名稱:aps伺服器參數設定
檔案目的:aps伺服器參數設定
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table vlm_file
(
vlm01       varchar2(20) DEFAULT ' ' NOT NULL, /*APS服务器主机*/
vlm02       varchar2(20),            /*服务器IP地址                           */
vlm03       number(5)                /*服务器PORT                             */
);

alter table vlm_file add  constraint vlm_pk primary key  (vlm01) enable validate;
grant select on vlm_file to tiptopgp;
grant update on vlm_file to tiptopgp;
grant delete on vlm_file to tiptopgp;
grant insert on vlm_file to tiptopgp;
grant index on vlm_file to public;
grant select on vlm_file to ods;
