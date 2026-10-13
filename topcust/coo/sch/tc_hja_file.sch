/*
================================================================================
檔案代號:tc_hja_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tc_hja_file
(
tc_hja01    varchar2(10) NOT NULL,   /*省份编号                               */
                                     /*                                       */
                                     /*                                       */
                                     /*                                       */
tc_hja02    varchar2(10)             /*部门编号                               */
);

create unique index tic_hja_01 on tc_hja_file (tc_hja01);
alter table tc_hja_file add  constraint tpc_hja_pk primary key  (tc_hja01) enable validate;
grant select on tc_hja_file to tiptopgp;
grant update on tc_hja_file to tiptopgp;
grant delete on tc_hja_file to tiptopgp;
grant insert on tc_hja_file to tiptopgp;
grant index on tc_hja_file to public;
grant select on tc_hja_file to ods;
