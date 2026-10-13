/*
================================================================================
檔案代號:tc_imn_file
檔案名稱:工单调拨单第一单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_imn_file
(
tc_imn01    varchar2(20) NOT NULL,   /*调拨单号                               */
tc_imn02    number(5) NOT NULL,      /*项次                                   */
tc_imn03    varchar2(20),            /*工单单号                               */
tc_imn04    varchar2(6),             /*作业编号                               */
tc_imn05    varchar2(40),            /*料件编号                               */
tc_imn06    number(15,3),            /*生产数量                               */
tc_imn07    varchar2(40),
tc_imn08    varchar2(40),            /*作业编号                               */
tc_imn09    varchar2(40),
tc_imn10    varchar2(40),            /*所属站别                               */
tc_imn11    number(10),              /*发料套数                               */
tc_imn12    number(10),
tc_imn13    number(10),
tc_imn14    number(15,3),            /*部门                                   */
tc_imn15    number(15,3),
tc_imn16    number(15,3),
tc_imn17    date,
tc_imn18    date,
tc_imn19    date,
tc_imn20    varchar2(255)
);

alter table tc_imn_file add  constraint tpc_imn_pk primary key  (tc_imn01,tc_imn02) enable validate;
grant select on tc_imn_file to tiptopgp;
grant update on tc_imn_file to tiptopgp;
grant delete on tc_imn_file to tiptopgp;
grant insert on tc_imn_file to tiptopgp;
grant index on tc_imn_file to public;
grant select on tc_imn_file to ods;
