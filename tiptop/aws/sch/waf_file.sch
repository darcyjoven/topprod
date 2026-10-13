/*
================================================================================
檔案代號:waf_file
檔案名稱:通用接口之报表存放路径表
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table waf_file
(
waf01       varchar2(20) DEFAULT ' ' NOT NULL, /*服务器IP*/
waf02       varchar2(80),            /*服务器用途说明                         */
waf03       varchar2(500)            /*报表存放路径                           */
);

alter table waf_file add  constraint waf_pk primary key  (waf01) enable validate;
grant select on waf_file to tiptopgp;
grant update on waf_file to tiptopgp;
grant delete on waf_file to tiptopgp;
grant insert on waf_file to tiptopgp;
grant index on waf_file to public;
grant select on waf_file to ods;
