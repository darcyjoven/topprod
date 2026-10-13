/*
================================================================================
檔案代號:tc_ccpc_file
檔案名稱:客制历史成本单价表
檔案目的:记录2017年1月之前成本单价
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tc_ccpc_file
(
tc_ccpc01   varchar2(40) NOT NULL,   /*料号                                   */
tc_ccpc02   number(5) NOT NULL,      /*年度                                   */
tc_ccpc03   number(5) NOT NULL,      /*月份                                   */
tc_ccpc04   number(20,6) NOT NULL    /*成本单价                               */
);

create unique index tic_ccpc_01 on tc_ccpc_file (tc_ccpc01,tc_ccpc02,tc_ccpc03);
alter table tc_ccpc_file add  constraint tpc_ccpc_pk primary key  (tc_ccpc01,tc_ccpc02,tc_ccpc03) enable validate;
grant select on tc_ccpc_file to tiptopgp;
grant update on tc_ccpc_file to tiptopgp;
grant delete on tc_ccpc_file to tiptopgp;
grant insert on tc_ccpc_file to tiptopgp;
grant index on tc_ccpc_file to public;
grant select on tc_ccpc_file to ods;
