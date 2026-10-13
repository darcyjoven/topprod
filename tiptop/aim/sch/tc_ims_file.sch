/*
================================================================================
檔案代號:tc_ims_file
檔案名稱:料件资料主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_ims_file
(
tc_ims01    varchar2(40) NOT NULL,   /*料件编号                               */
tc_ims02    number(15,3),            /*报价良率                               */
tc_ims03    varchar2(40),            /*自订字段                               */
tc_ims04    varchar2(40),            /*自订字段                               */
tc_ims05    varchar2(40),            /*自订字段                               */
tc_ims06    varchar2(40),            /*自订字段                               */
tc_ims07    varchar2(40),            /*自订字段                               */
tc_ims08    varchar2(255),           /*自订字段                               */
tc_ims09    number(15,3),            /*自订字段                               */
tc_ims10    number(15,3),            /*自订字段                               */
tc_ims11    number(15,3),            /*自订字段                               */
tc_ims12    number(15,3),            /*自订字段                               */
tc_ims13    date,                    /*自订字段                               */
tc_ims14    date,                    /*自订字段                               */
tc_ims15    date,                    /*自订字段                               */
tc_ims16    date,                    /*自订字段                               */
tc_ims17    number(10),              /*自订字段                               */
tc_ims18    number(10),              /*自订字段                               */
tc_ims19    number(10),              /*自订字段                               */
tc_ims20    number(10),              /*自订字段                               */
tc_ims21    number(20,6),            /*自订字段                               */
tc_ims22    number(20,6),            /*自订字段                               */
tc_ims23    number(20,6),            /*自订字段                               */
tc_ims24    number(20,6)             /*自订字段                               */
);

create unique index tic_ims_01 on tc_ims_file (tc_ims01);
alter table tc_ims_file add  constraint tpc_ims_pk primary key  (tc_ims01) enable validate;
grant select on tc_ims_file to tiptopgp;
grant update on tc_ims_file to tiptopgp;
grant delete on tc_ims_file to tiptopgp;
grant insert on tc_ims_file to tiptopgp;
grant index on tc_ims_file to public;
grant select on tc_ims_file to ods;
