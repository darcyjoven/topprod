/*
================================================================================
檔案代號:tc_data_file
檔案名稱:顾问临时表
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table tc_data_file
(
tc_data01   varchar2(1000),
tc_data02   varchar2(1000),
tc_data03   varchar2(1000),
tc_data04   varchar2(1000),
tc_data05   varchar2(1000),
tc_data06   number(28),
tc_data07   number(28),
tc_data08   number(28,8),
tc_data09   number(28,8),
tc_data10   date,
tc_data11   date
);

grant select on tc_data_file to tiptopgp;
grant update on tc_data_file to tiptopgp;
grant delete on tc_data_file to tiptopgp;
grant insert on tc_data_file to tiptopgp;
grant index on tc_data_file to public;
grant select on tc_data_file to ods;
