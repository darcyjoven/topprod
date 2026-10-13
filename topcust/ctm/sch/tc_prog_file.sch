/*
================================================================================
檔案代號:tc_prog_file
檔案名稱:作业基本档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_prog_file
(
tc_prog01   varchar2(10) NOT NULL,   /*作业编号                               */
tc_prog02   varchar2(80)             /*作业名称                               */
);

create unique index tic_prog_01 on tc_prog_file (tc_prog01);
alter table tc_prog_file add  constraint tpc_prog_pk primary key  (tc_prog01) enable validate;
grant select on tc_prog_file to tiptopgp;
grant update on tc_prog_file to tiptopgp;
grant delete on tc_prog_file to tiptopgp;
grant insert on tc_prog_file to tiptopgp;
grant index on tc_prog_file to public;
grant select on tc_prog_file to ods;
