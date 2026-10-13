/*
================================================================================
檔案代號:tc_bwa_file
檔案名稱:系统库存截取档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_bwa_file
(
tc_bwa01    date,                    /*库存截取日                             */
tc_bwa02    varchar2(8),             /*库存截取时间点                         */
tc_bwa03    varchar2(10),            /*仓库编号                               */
tc_bwa04    varchar2(40),            /*料件编号                               */
tc_bwa05    varchar2(10),            /*库位编号                               */
tc_bwa06    varchar2(24),            /*批号                                   */
tc_bwa07    varchar2(4),             /*库存单位                               */
tc_bwa08    number(15,3),            /*库存数量                               */
tc_bwa09    varchar2(12) NOT NULL    /*盘点计划号                             */
);

grant select on tc_bwa_file to tiptopgp;
grant update on tc_bwa_file to tiptopgp;
grant delete on tc_bwa_file to tiptopgp;
grant insert on tc_bwa_file to tiptopgp;
grant index on tc_bwa_file to public;
grant select on tc_bwa_file to ods;
