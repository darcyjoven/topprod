/*
================================================================================
檔案代號:tc_ccg_file
檔案名稱:期末在制盘点清单
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_ccg_file
(
tc_ccg01    varchar2(4) NOT NULL,    /*年度                                   */
tc_ccg02    varchar2(4) NOT NULL,    /*期别                                   */
tc_ccg03    varchar2(30) NOT NULL,   /*工单单号                               */
tc_ccg04    varchar2(20) NOT NULL,   /*作业编号                               */
tc_ccg05    number(20,6)             /*在制数量                               */
                                     /*PCS量                                  */
);

alter table tc_ccg_file add  constraint tpc_ccg_pk primary key  (tc_ccg01,tc_ccg02,tc_ccg03,tc_ccg04) enable validate;
grant select on tc_ccg_file to tiptopgp;
grant update on tc_ccg_file to tiptopgp;
grant delete on tc_ccg_file to tiptopgp;
grant insert on tc_ccg_file to tiptopgp;
grant index on tc_ccg_file to public;
grant select on tc_ccg_file to ods;
