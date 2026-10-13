/*
================================================================================
檔案代號:gdx_file
檔案名稱:TIPTOP签核代码维护档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gdx_file
(
gdx01       varchar2(5) DEFAULT ' ' NOT NULL, /*签核代号*/
gdx02       number(5) DEFAULT '0' NOT NULL, /*序号*/
gdx03       varchar2(1) DEFAULT ' ' NOT NULL, /*语言别*/
gdx04       varchar2(80)             /*签核人员职称                           */
);

alter table gdx_file add  constraint gdx_pk primary key  (gdx01,gdx02,gdx03) enable validate;
grant select on gdx_file to tiptopgp;
grant update on gdx_file to tiptopgp;
grant delete on gdx_file to tiptopgp;
grant insert on gdx_file to tiptopgp;
grant index on gdx_file to public;
grant select on gdx_file to ods;
