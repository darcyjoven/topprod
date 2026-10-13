/*
================================================================================
檔案代號:tc_imgbb_file
檔案名稱:盘前条码库存档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_imgbb_file
(
tc_imgbb01  varchar2(80),            /*条码编号                               */
tc_imgbb02  varchar2(10),            /*仓库编号                               */
tc_imgbb03  varchar2(10),            /*储位编号                               */
tc_imgbb04  varchar2(24),            /*批号                                   */
tc_imgbb05  number(15,3),            /*当前库存量                             */
tc_imgbb06  date,                    /*库存截取日                             */
tc_imgbb07  varchar2(12),            /*库存截取时间点                         */
tc_imgbb08  varchar2(100)            /*盘点计划号                             */
);

grant select on tc_imgbb_file to tiptopgp;
grant update on tc_imgbb_file to tiptopgp;
grant delete on tc_imgbb_file to tiptopgp;
grant insert on tc_imgbb_file to tiptopgp;
grant index on tc_imgbb_file to public;
grant select on tc_imgbb_file to ods;
