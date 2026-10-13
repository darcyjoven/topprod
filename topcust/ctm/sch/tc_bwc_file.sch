/*
================================================================================
檔案代號:tc_bwc_file
檔案名稱:盘点范围表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_bwc_file
(
tc_bwc01    date,                    /*库存截取日                             */
tc_bwc02    varchar2(8),             /*库存截取时间点                         */
tc_bwc03    varchar2(2000),          /*仓库范围                               */
tc_bwc04    varchar2(2000),          /*物料范围                               */
tc_bwc05    varchar2(255),           /*盘点范围说明                           */
tc_bwc06    varchar2(10),            /*设定人员                               */
tc_bwc07    varchar2(12) NOT NULL    /*盘点计划号                             */
);

grant select on tc_bwc_file to tiptopgp;
grant update on tc_bwc_file to tiptopgp;
grant delete on tc_bwc_file to tiptopgp;
grant insert on tc_bwc_file to tiptopgp;
grant index on tc_bwc_file to public;
grant select on tc_bwc_file to ods;
