/*
================================================================================
檔案代號:tc_sfaa_file
檔案名稱:工单留置数量
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_sfaa_file
(
tc_sfaa01   varchar2(40) NOT NULL,
tc_sfaa02   number(15,3),
tc_sfaa03   date,
tc_sfaa04   varchar2(2000),
tc_sfaa05   varchar2(40),
tc_sfaa06   varchar2(40),
tc_sfaa07   number(15,3),
tc_sfaa08   number(15,3),
tc_sfaa09   number(15,3),
tc_sfaa10   date,
tc_sfaa11   date,
tc_sfaa12   date
);

create unique index tic_sfaa_01 on tc_sfaa_file (tc_sfaa01);
alter table tc_sfaa_file add  constraint tpc_sfaa_pk primary key  (tc_sfaa01) enable validate;
grant select on tc_sfaa_file to tiptopgp;
grant update on tc_sfaa_file to tiptopgp;
grant delete on tc_sfaa_file to tiptopgp;
grant insert on tc_sfaa_file to tiptopgp;
grant index on tc_sfaa_file to public;
grant select on tc_sfaa_file to ods;
