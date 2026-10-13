/*
================================================================================
檔案代號:tc_bwb_file
檔案名稱:实盘库存档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_bwb_file
(
tc_bwb01    date,                    /*库存实盘日                             */
tc_bwb02    varchar2(80),            /*物料条码                               */
tc_bwb03    varchar2(10),            /*仓库编号                               */
tc_bwb04    varchar2(40),            /*物料编号                               */
tc_bwb05    varchar2(10),            /*库位编号                               */
tc_bwb06    varchar2(24),            /*批号                                   */
tc_bwb07    number(15,3),            /*实盘数量                               */
tc_bwb08    varchar2(10),            /*盘点人员                               */
tc_bwb09    varchar2(12) NOT NULL    /*盘点计划号                             */
);

grant select on tc_bwb_file to tiptopgp;
grant update on tc_bwb_file to tiptopgp;
grant delete on tc_bwb_file to tiptopgp;
grant insert on tc_bwb_file to tiptopgp;
grant index on tc_bwb_file to public;
grant select on tc_bwb_file to ods;
