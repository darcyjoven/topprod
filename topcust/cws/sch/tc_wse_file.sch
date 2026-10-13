/*
================================================================================
檔案代號:tc_wse_file
檔案名稱:bpm表单对应ERP作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table tc_wse_file
(
tc_wse01    varchar2(20) NOT NULL,   /*ERP程序代号                            */
tc_wse02    varchar2(40) NOT NULL,   /*BPM表单代号                            */
tc_wse03    date NOT NULL,           /*生效日期                               */
tc_wse04    date,                    /*失效日期                               */
tc_wse05    varchar2(1000),          /*备注                                   */
tc_wse06    varchar2(100),
tc_wse07    varchar2(100),
tc_wse08    varchar2(100),
tc_wse09    number(10),
tc_wse10    number(10),
tc_wse11    number(10),
tc_wse12    date,
tc_wse13    date,
tc_wse14    date,
tc_wse15    date,
tc_wsecrtuser varchar2(20),          /*建立人员                               */
tc_wsecrtdat date,                   /*建立日期                               */
tc_wsemodusr varchar2(20),           /*修改人员                               */
tc_wsemoddat date                    /*修改日期                               */
);

alter table tc_wse_file add  constraint tpc_wse_pk primary key  (tc_wse01,tc_wse02,tc_wse03) enable validate;
grant select on tc_wse_file to tiptopgp;
grant update on tc_wse_file to tiptopgp;
grant delete on tc_wse_file to tiptopgp;
grant insert on tc_wse_file to tiptopgp;
grant index on tc_wse_file to public;
grant select on tc_wse_file to ods;
