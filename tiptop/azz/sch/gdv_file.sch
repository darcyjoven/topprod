/*
================================================================================
檔案代號:gdv_file
檔案名稱:个资信息配置文件
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gdv_file
(
gdv01       varchar2(20) DEFAULT ' ' NOT NULL, /*画面档代码*/
gdv02       varchar2(20) DEFAULT ' ' NOT NULL, /*字段代码*/
gdv03       varchar2(1) DEFAULT ' ' NOT NULL, /*客制字段*/
gdv04       varchar2(10) DEFAULT ' ' NOT NULL, /*行业别代码*/
gdv05       varchar2(10) DEFAULT ' ' NOT NULL,
gdv06       varchar2(1),             /*是否可录入                             */
gdv07       varchar2(255),
gdv08       varchar2(255)            /*可阅读本栏个资的权限类别               */
);

alter table gdv_file add  constraint gdv_pk primary key  (gdv01,gdv02,gdv03,gdv04) enable validate;
grant select on gdv_file to tiptopgp;
grant update on gdv_file to tiptopgp;
grant delete on gdv_file to tiptopgp;
grant insert on gdv_file to tiptopgp;
grant index on gdv_file to public;
grant select on gdv_file to ods;
