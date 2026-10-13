/*
================================================================================
檔案代號:tc_spx_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_spx_file
(
tc_spx01    varchar2(40) NOT NULL,   /*配货计划号                             */
tc_spx02    varchar2(40) NOT NULL,   /*模板编号                               */
tc_spx03    date,                    /*日期                                   */
tc_spx04    varchar2(255),           /*备注                                   */
tc_spx05    varchar2(40)             /*客户编号                               */
);

create unique index tic_spx_01 on tc_spx_file (tc_spx01);
alter table tc_spx_file add  constraint tpc_spx_pk primary key  (tc_spx01) enable validate;
grant select on tc_spx_file to tiptopgp;
grant update on tc_spx_file to tiptopgp;
grant delete on tc_spx_file to tiptopgp;
grant insert on tc_spx_file to tiptopgp;
grant index on tc_spx_file to public;
grant select on tc_spx_file to ods;
