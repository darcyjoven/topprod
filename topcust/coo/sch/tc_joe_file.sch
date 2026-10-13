/*
================================================================================
檔案代號:tc_joe_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_joe_file
(
tc_joe01    varchar2(8) NOT NULL,    /*员工编号                               */
tc_joe02    varchar2(1),             /*性别                                   */
tc_joe03    date,                    /*出生日期                               */
tc_joe04    varchar2(6),             /*部门编号                               */
tc_joe05    varchar2(4),             /*班别编号                               */
tc_joe06    varchar2(14),            /*联系电话                               */
tc_joe07    varchar2(255),           /*住址                                   */
tc_joeacti  varchar2(1),             /*资料有效否                             */
tc_joeuser  varchar2(10),            /*资料所有者                             */
tc_joegrup  varchar2(6),             /*资料所有组                             */
tc_joemodu  varchar2(10),            /*最后修改者                             */
tc_joedate  date                     /*最后修改日                             */
);

alter table tc_joe_file add  constraint tpc_joe_pk primary key  (tc_joe01) enable validate;
grant select on tc_joe_file to tiptopgp;
grant update on tc_joe_file to tiptopgp;
grant delete on tc_joe_file to tiptopgp;
grant insert on tc_joe_file to tiptopgp;
grant index on tc_joe_file to public;
grant select on tc_joe_file to ods;
