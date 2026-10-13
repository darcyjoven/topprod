/*
================================================================================
檔案代號:waq_file
檔案名稱:CROSS 整合平台所注册 TIPTOP 的服务清单
檔案目的:提供维护 CROSS 整合平台的 TIPTOP 服务清单
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table waq_file
(
waq01       varchar2(1) DEFAULT ' ' NOT NULL, /*服务端*/
waq02       varchar2(40) DEFAULT ' ' NOT NULL /*服务代码*/
);

alter table waq_file add  constraint waq_pk primary key  (waq01,waq02) enable validate;
grant select on waq_file to tiptopgp;
grant update on waq_file to tiptopgp;
grant delete on waq_file to tiptopgp;
grant insert on waq_file to tiptopgp;
grant index on waq_file to public;
grant select on waq_file to ods;
