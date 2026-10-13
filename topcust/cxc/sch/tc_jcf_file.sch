/*
================================================================================
檔案代號:tc_jcf_file
檔案名稱:线边仓设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table tc_jcf_file
(
tc_jcf01    varchar2(10) NOT NULL,   /*线边仓别                               */
tc_jcf02    varchar2(10) NOT NULL,   /*仓库编号                               */
tc_jcf03    varchar2(1),
tc_jcfacti  varchar2(1),             /*有效码                                 */
tc_jcfuser  varchar2(10),            /*建立人员                               */
tc_jcfgrup  varchar2(10),            /*所属部门                               */
tc_jcfmodu  varchar2(10),            /*修改人员                               */
tc_jcfdate  date,                    /*修改日期                               */
tc_jcforig  varchar2(10),
tc_jcforiu  varchar2(10)
);

create unique index tic_jcf_01 on tc_jcf_file (tc_jcf01,tc_jcf02);
alter table tc_jcf_file add  constraint tpc_jcf_pk primary key  (tc_jcf01,tc_jcf02) enable validate;
grant select on tc_jcf_file to tiptopgp;
grant update on tc_jcf_file to tiptopgp;
grant delete on tc_jcf_file to tiptopgp;
grant insert on tc_jcf_file to tiptopgp;
grant index on tc_jcf_file to public;
grant select on tc_jcf_file to ods;
