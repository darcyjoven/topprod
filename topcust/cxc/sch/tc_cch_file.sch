/*
================================================================================
檔案代號:tc_cch_file
檔案名稱:客制在制成本推算结果表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_cch_file
(
tc_cch01    varchar2(4) NOT NULL,    /*年度                                   */
tc_cch02    varchar2(4) NOT NULL,    /*期别                                   */
tc_cch03    varchar2(40) NOT NULL,   /*主料件编码                             */
tc_cch04    varchar2(40) NOT NULL,   /*作业编号                               */
tc_cch05    varchar2(40) NOT NULL,   /*子件编码                               */
tc_cch06    number(20,6),            /*剩余结存量                             */
tc_cch07    varchar2(10),            /*库存单位                               */
tc_cch08    varchar2(10),            /*发料单位                               */
tc_cch09    number(15,8)             /*发料单位与库存单位转换率               */
);

create        index tic_cch_01 on tc_cch_file (tc_cch02,tc_cch01,tc_cch03,tc_cch04,tc_cch05);
alter table tc_cch_file add  constraint tpc_cch_pk primary key  (tc_cch01,tc_cch02,tc_cch03,tc_cch04,tc_cch05) enable validate;
grant select on tc_cch_file to tiptopgp;
grant update on tc_cch_file to tiptopgp;
grant delete on tc_cch_file to tiptopgp;
grant insert on tc_cch_file to tiptopgp;
grant index on tc_cch_file to public;
grant select on tc_cch_file to ods;
