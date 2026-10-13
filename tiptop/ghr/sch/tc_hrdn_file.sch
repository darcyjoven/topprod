/*
================================================================================
檔案代號:tc_hrdn_file
檔案名稱:员工银行卡信息
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table tc_hrdn_file
(
tc_hrdn01   varchar2(20),
tc_hrdn02   varchar2(100),
tc_hrdn03   varchar2(50),
tc_hrdn04   varchar2(20),
tc_hrdn05   varchar2(20),
tc_hrdn06   varchar2(50),
tc_hrdn07   date,
tc_hrdn08   varchar2(100)
);

grant select on tc_hrdn_file to tiptopgp;
grant update on tc_hrdn_file to tiptopgp;
grant delete on tc_hrdn_file to tiptopgp;
grant insert on tc_hrdn_file to tiptopgp;
grant index on tc_hrdn_file to public;
grant select on tc_hrdn_file to ods;
