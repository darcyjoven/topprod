/*
================================================================================
檔案代號:tc_sib_file
檔案名稱:供应商发货单身
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_sib_file
(
tc_sib01    varchar2(20) NOT NULL,   /*发货单身                               */
tc_sib02    number(5) NOT NULL,      /*项次                                   */
tc_sib03    varchar2(20),            /*采购单号                               */
tc_sib04    number(5),               /*采购项次                               */
tc_sib05    number(15,3),            /*实发数量                               */
tc_sib06    varchar2(10),            /*仓库                                   */
tc_sib07    number(15,3),            /*收货数量                               */
tc_sib08    varchar2(20)             /*发票号                                 */
);

create        index tic_sib_01 on tc_sib_file (tc_sib01,tc_sib02);
alter table tc_sib_file add  constraint tpc_sib_pk primary key  (tc_sib01,tc_sib02) enable validate;
grant select on tc_sib_file to tiptopgp;
grant update on tc_sib_file to tiptopgp;
grant delete on tc_sib_file to tiptopgp;
grant insert on tc_sib_file to tiptopgp;
grant index on tc_sib_file to public;
grant select on tc_sib_file to ods;
