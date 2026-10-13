/*
================================================================================
檔案代號:obx_file
檔案名稱:車輛保養維修記錄檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table obx_file
(
obx01       varchar2(10),            /*車輛編號                               */
obx02       number(5),               /*序號                                   */
obx03       date,                    /*異動日期                               */
obx04       varchar2(4),             /*保養編碼                               */
obx05       varchar2(120),           /*問題描述一                             */
obx06       varchar2(40),            /*問題描述二                             */
obx07       varchar2(40),            /*問題描述三                             */
obx08       varchar2(120),           /*處理狀況一                             */
obx09       varchar2(40),            /*處理狀況二                             */
obx10       varchar2(40),            /*處理狀況三                             */
obx11       varchar2(8)              /*處理人員                               */
);

create unique index obx_01 on obx_file (obx01,obx02);
grant select on obx_file to public;
grant index on obx_file to public;
grant update on obx_file to public;
grant delete on obx_file to public;
grant insert on obx_file to public;
