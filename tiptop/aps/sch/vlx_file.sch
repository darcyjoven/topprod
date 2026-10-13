/*
================================================================================
檔案代號:vlx_file
檔案名稱:资料库参数设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table vlx_file
(
vlx01       varchar2(20) DEFAULT ' ' NOT NULL, /*数据库名称/sid*/
vlx02       varchar2(60),            /*数据库IP地址                           */
vlx03       varchar2(10),            /*数据库登入帐号                         */
vlx04       varchar2(60),            /*数据库口令                             */
vlx05       varchar2(1),             /*是否为主要数据库                       */
vlx06       varchar2(1)              /*数据库来源                             */
);

alter table vlx_file add  constraint vlx_pk primary key  (vlx01) enable validate;
grant select on vlx_file to tiptopgp;
grant update on vlx_file to tiptopgp;
grant delete on vlx_file to tiptopgp;
grant insert on vlx_file to tiptopgp;
grant index on vlx_file to public;
grant select on vlx_file to ods;
