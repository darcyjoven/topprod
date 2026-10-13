/*
================================================================================
檔案代號:tc_workt_file
檔案名稱:生产报工明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_workt_file
(
tc_workt01  date NOT NULL,           /*报工日期                               */
tc_workt02  varchar2(10) NOT NULL,   /*报工时间                               */
tc_workt03  varchar2(40) NOT NULL,   /*报工品项                               */
tc_workt04  varchar2(6) NOT NULL,    /*作业编号                               */
tc_workt05  varchar2(10),            /*报工人                                 */
tc_workt06  number(15,3),            /*报工数量                               */
tc_workt07  varchar2(1),             /*需生成入库                             */
tc_workt08  varchar2(1),             /*入库完成否                             */
tc_workt09  varchar2(20),            /*完工入库单号                           */
tc_workt10  number(15,3),            /*报工工时                               */
tc_workt11  varchar2(20),            /*工单号                                 */
tc_workt12  number(15,3)             /*不良数量                               */
);

create unique index tic_workt_01 on tc_workt_file (tc_workt01,tc_workt02,tc_workt03,tc_workt04);
alter table tc_workt_file add  constraint tpc_workt_pk primary key  (tc_workt01,tc_workt02,tc_workt03,tc_workt04) enable validate;
grant select on tc_workt_file to tiptopgp;
grant update on tc_workt_file to tiptopgp;
grant delete on tc_workt_file to tiptopgp;
grant insert on tc_workt_file to tiptopgp;
grant index on tc_workt_file to public;
grant select on tc_workt_file to ods;
