/*
================================================================================
檔案代號:tc_azf_file
檔案名稱:生产其他出入库领用理由码
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table tc_azf_file
(
tc_azf01    varchar2(20),
tc_azf02    varchar2(30),
tc_azf03    varchar2(20)
);

grant select on tc_azf_file to tiptopgp;
grant update on tc_azf_file to tiptopgp;
grant delete on tc_azf_file to tiptopgp;
grant insert on tc_azf_file to tiptopgp;
grant index on tc_azf_file to public;
grant select on tc_azf_file to ods;
