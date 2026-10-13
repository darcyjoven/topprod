/*
================================================================================
檔案代號:tc_ccpd_file
檔案名稱:客制历史成本单价表-axrq378
檔案目的:记录2017年1月之前成本单价-axrq378
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tc_ccpd_file
(
tc_ccpd01   varchar2(40) NOT NULL,   /*料号                                   */
tc_ccpd02   number(5) NOT NULL,      /*年度                                   */
tc_ccpd03   number(5) NOT NULL,      /*月份                                   */
tc_ccpd04   number(20,6)             /*成本单价                               */
);

create unique index tic_ccpd_01 on tc_ccpd_file (tc_ccpd01,tc_ccpd02,tc_ccpd03);
alter table tc_ccpd_file add  constraint tpc_ccpd_pk primary key  (tc_ccpd01,tc_ccpd02,tc_ccpd03) enable validate;
grant select on tc_ccpd_file to tiptopgp;
grant update on tc_ccpd_file to tiptopgp;
grant delete on tc_ccpd_file to tiptopgp;
grant insert on tc_ccpd_file to tiptopgp;
grant index on tc_ccpd_file to public;
grant select on tc_ccpd_file to ods;
