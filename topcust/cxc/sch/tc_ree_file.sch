/*
================================================================================
檔案代號:tc_ree_file
檔案名稱:研发费用记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tc_ree_file
(
tc_ree01    varchar2(20) NOT NULL,   /*研发费用调整单号                       */
tc_ree02    date NOT NULL,           /*执行日期                               */
tc_ree03    varchar2(20) NOT NULL,   /*工单单号                               */
tc_ree04    varchar2(20),            /*退料单号                               */
tc_ree05    varchar2(40),            /*退料料件编号                           */
tc_ree06    number(20,6),            /*退料数量                               */
tc_ree07    varchar2(1),             /*退料有效性                             */
tc_ree08    varchar2(20),            /*杂发单号                               */
tc_ree09    varchar2(40),            /*杂发料件编号                           */
tc_ree10    number(20,6),            /*杂发数量                               */
tc_ree11    varchar2(1)              /*杂发有效性                             */
);

create unique index tic_ree_01 on tc_ree_file (tc_ree01);
alter table tc_ree_file add  constraint tpc_ree_pk primary key  (tc_ree01) enable validate;
grant select on tc_ree_file to tiptopgp;
grant update on tc_ree_file to tiptopgp;
grant delete on tc_ree_file to tiptopgp;
grant insert on tc_ree_file to tiptopgp;
grant index on tc_ree_file to public;
grant select on tc_ree_file to ods;
