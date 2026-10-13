/*
================================================================================
檔案代號:tc_datb_file
檔案名稱:顾问临时表2
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tc_datb_file
(
tc_datb01   varchar2(1000),
tc_datb02   varchar2(1000),
tc_datb03   varchar2(1000),
tc_datb04   varchar2(1000),
tc_datb05   varchar2(1000),
tc_datb06   number(20),
tc_datb07   number(20),
tc_datb08   number(20,8),
tc_datb09   number(20,8),
tc_datb10   number(20,8),
tc_datb11   number(20,8),
tc_datb12   date,
tc_datb13   date
);

grant select on tc_datb_file to tiptopgp;
grant update on tc_datb_file to tiptopgp;
grant delete on tc_datb_file to tiptopgp;
grant insert on tc_datb_file to tiptopgp;
grant index on tc_datb_file to public;
grant select on tc_datb_file to ods;
