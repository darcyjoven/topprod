/*
================================================================================
檔案代號:gfp_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gfp_file
(
gfp01       varchar2(30) DEFAULT ' ' NOT NULL, /*程序编号*/
gfp02       varchar2(60) DEFAULT ' ' NOT NULL, /*代码*/
gfp03       varchar2(1) DEFAULT ' ' NOT NULL, /*多语言代码*/
gfp04       varchar2(255)            /*编号说明                               */
);

alter table gfp_file add  constraint gfp_pk primary key  (gfp01,gfp02,gfp03) enable validate;
grant select on gfp_file to tiptopgp;
grant update on gfp_file to tiptopgp;
grant delete on gfp_file to tiptopgp;
grant insert on gfp_file to tiptopgp;
grant index on gfp_file to public;
grant select on gfp_file to ods;
