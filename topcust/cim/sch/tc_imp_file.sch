/*
================================================================================
檔案代號:tc_imp_file
檔案名稱:工单调拨单第二单身汇总档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_imp_file
(
tc_imp01    varchar2(20) NOT NULL,   /*调拨单号                               */
tc_imp02    number(5) NOT NULL,      /*项次                                   */
tc_imp03    varchar2(20),            /*工单单号                               */
tc_imp04    varchar2(6),             /*作业编号                               */
tc_imp05    varchar2(40),            /*申请发料料号                           */
tc_imp06    varchar2(10),            /*仓库                                   */
tc_imp07    varchar2(10),            /*申请人                                 */
tc_imp08    number(15,3),            /*申请数量                               */
tc_imp09    number(15,3),            /*实际异动数量                           */
tc_imp10    varchar2(40),            /*单位                                   */
tc_imp11    varchar2(40),
tc_imp12    varchar2(40),
tc_imp13    number(10),
tc_imp14    number(10),
tc_imp15    number(15,3),
tc_imp16    number(15,3),
tc_imp17    date,
tc_imp18    varchar2(255)
);

alter table tc_imp_file add  constraint tpc_imp_pk primary key  (tc_imp01,tc_imp02) enable validate;
grant select on tc_imp_file to tiptopgp;
grant update on tc_imp_file to tiptopgp;
grant delete on tc_imp_file to tiptopgp;
grant insert on tc_imp_file to tiptopgp;
grant index on tc_imp_file to public;
grant select on tc_imp_file to ods;
