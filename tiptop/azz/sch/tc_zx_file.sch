/*
================================================================================
檔案代號:tc_zx_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_zx_file
(
tc_zx01     varchar2(10) NOT NULL,
tc_zx02     varchar2(80)
);

grant select on tc_zx_file to tiptopgp;
grant update on tc_zx_file to tiptopgp;
grant delete on tc_zx_file to tiptopgp;
grant insert on tc_zx_file to tiptopgp;
grant index on tc_zx_file to public;
grant select on tc_zx_file to ods;
