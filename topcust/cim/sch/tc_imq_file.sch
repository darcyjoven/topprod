/*
================================================================================
檔案代號:tc_imq_file
檔案名稱:工单调拨单第二单身明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_imq_file
(
tc_imq01    varchar2(20) NOT NULL,   /*调拨单号                               */
tc_imq02    number(5) NOT NULL,      /*项次                                   */
tc_imq03    varchar2(20),            /*工单单号                               */
tc_imq04    varchar2(6),             /*作业编号                               */
tc_imq05    varchar2(40),            /*发料料号                               */
tc_imq06    varchar2(10),            /*拨出仓库                               */
tc_imq07    varchar2(10),            /*储位                                   */
tc_imq08    varchar2(24),            /*批号                                   */
tc_imq09    varchar2(4),             /*拨出单位                               */
tc_imq10    varchar2(10),            /*拨入仓库                               */
tc_imq11    varchar2(10),            /*储位                                   */
tc_imq12    varchar2(24),            /*批号                                   */
tc_imq13    varchar2(4),             /*拨入单位                               */
tc_imq14    number(15,3),            /*拨出数量                               */
tc_imq15    number(15,3),            /*拨入数量                               */
tc_imq16    number(15,6),            /*单位转换                               */
tc_imq17    varchar2(10),            /*理由码                                 */
tc_imq18    varchar2(255),           /*备注                                   */
tc_imq19    varchar2(40),
tc_imq20    varchar2(40),
tc_imq21    varchar2(40),
tc_imq22    varchar2(40),
tc_imq23    number(10),
tc_imq24    number(10),
tc_imq25    number(10),
tc_imq26    number(15,3),
tc_imq27    number(15,3),
tc_imq28    number(15,3),
tc_imq29    date,
tc_imq30    date,
tc_imq31    date,
tc_imq32    varchar2(255)
);

alter table tc_imq_file add  constraint tpc_imq_pk primary key  (tc_imq01,tc_imq02) enable validate;
grant select on tc_imq_file to tiptopgp;
grant update on tc_imq_file to tiptopgp;
grant delete on tc_imq_file to tiptopgp;
grant insert on tc_imq_file to tiptopgp;
grant index on tc_imq_file to public;
grant select on tc_imq_file to ods;
