/*
================================================================================
檔案代號:tc_imo_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_imo_file
(
tc_imo01    number(10) NOT NULL,     /*序号                                   */
tc_imo02    varchar2(40),            /*工单单号                               */
tc_imo03    varchar2(20),            /*作业编号                               */
tc_imo04    number(15,3),            /*应发套数                               */
tc_imo05    number(15,3),            /*已发套数                               */
tc_imo06    varchar2(40),            /*发料料号                               */
tc_imo07    number(15,3),            /*应发数量                               */
tc_imo08    number(15,3),            /*已发数量                               */
tc_imo09    number(16,8),            /*实际QPA                                */
tc_imo10    number(15,3),            /*完工量                                 */
tc_imo11    number(16,8),            /*完工对应应发量                         */
tc_imo12    number(16,8),            /*本次需补数量                           */
tc_imo13    number(16,8),            /*本次欠料补料量                         */
tc_imo14    number(16,8),            /*本次成套发料量                         */
tc_imo15    number(16,8)             /*本次套数                               */
);

alter table tc_imo_file add  constraint tpc_imo_pk primary key  (tc_imo01) enable validate;
grant select on tc_imo_file to tiptopgp;
grant update on tc_imo_file to tiptopgp;
grant delete on tc_imo_file to tiptopgp;
grant insert on tc_imo_file to tiptopgp;
grant index on tc_imo_file to public;
grant select on tc_imo_file to ods;
